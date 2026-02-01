#Version 7
#BeginDescription
Version No. 1.1 , 2006-02-27 , dr@hsb-cad.com
 - Translation added to strings
Version No. 1.0 , 2006-02-24 , dr@hsb-cad.com
   - An engineered one-piece connector for attaching I-joist
    rafters to wall plates.
  - The VPA is adjustable to slopes between 15° and 45° with
    a special interlock design indicating when the maximum pitch
    is reached. This product complements the versatile LSSU.
   Designed for use with double 38mm top plates with a 50mm seat, 
   which allows sufficient bearing area for most rafters.
   - No notching is required when using the VPA. This connector reduces
    the need for beveled plates and toenailing. It has positive angle nailing
    to speed installation and to minimise wood splitting.

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
double dEps = U(0.9, "mm");
double dHth = U(1.2);//Hanger thickness


//Aux Vectors
Vector3d vecR = _Beam0.vecD(_X1);//Pointing to "Right" direction
if ( vecR.dotProduct ( _X1 ) < 0 )
	vecR = -vecR;
Vector3d vecU = _Beam0.vecD(_ZW);//Pointing to male's "Up" direction
if ( vecU.dotProduct ( _ZW ) < 0 )
	vecU = -vecU;
Vector3d vecMaleXUp = _X0;//Paralell to _X0 but always pointing "Up" 
if (  vecMaleXUp.Z() < 0 )
	vecMaleXUp = -vecMaleXUp;
Vector3d vecFemaleU = _Beam1.vecD(_ZW);//Pointing to female´s "Up" direction
Vector3d vecFemaleHng = _Beam1.vecD( _X1.crossProduct(vecFemaleU));//Pointing to hanger
Point3d ptPos=_Beam1.ptCen()+vecFemaleHng*10;
if(abs(vecFemaleHng.dotProduct(_Pt0-_Beam1.ptCen()))<abs(vecFemaleHng.dotProduct(_Pt0-ptPos)))
	vecFemaleHng=-vecFemaleHng;
	
//Create arrays
//Heights
double darrHw [] = { U(40), U(45), U(52), U(60), U(90) };
double darrJoistW [] = { U(38), U(45), U(50), U(60), U(90) };
String strarrModel [] = { "VPA2","VPA25","VPA2.06","VPA35","VPA4" };//Model 

//Properties
PropDouble prdMaleWidthTlorenace ( 0, 0, T("Male Tolerance"));
prdMaleWidthTlorenace.setDescription(T("If beam is smallest that expected by manufacturer, a measure of tolerance can be added"));
double dRankH;
double dRankL;

if (_bOnInsert) 
{	

	_Beam.append(getBeam(T("Select male beam")));	
	_Beam.append(getBeam(T("Select female beam")));	
	showDialogOnce();	
	return;
}

if(abs(_X0.dotProduct(_X1)) > dEps )//Verify perpendicularity
	{
		reportMessage (T("\nBeams must be perpendicular "));
		eraseInstance();	
	}

//Get male beam's sizes
double dMw = _Beam0.dD(_X1);
double dMh = _Beam0.dD(vecFemaleU);
//Get female beam's sizes
double dFw = _Beam1.dD(vecFemaleHng);
double dFh = _Beam1.dD(_ZW);

//Verify male beam width
//Determinate right hanger depending on male beam width
int iIndex = -1;
for ( int i = 0; i < darrJoistW.length(); i++)
{
	dRankH = darrJoistW [i];
	dRankL = darrJoistW [i] - prdMaleWidthTlorenace;
	
	if ( dMw  <= dRankH && dMw  >= dRankL)
	{
		iIndex = i;
		break;
	}
}	

if ( iIndex == -1 )
{
	reportMessage (T("\nMale beam doesn´t fit in hanger"));
	eraseInstance();
}


double dHw = darrJoistW [ iIndex ];//Hanger´s male beam support width
double dHtotalw = dHw * 3;//Hanger's total width
double dHdep = dHw * 1.5;
String strModel= strarrModel [ iIndex ];//Hanger's model

Point3d ptLeftFemale, ptRightFemale, ptRightMale, ptLeftMale, arrptMale1 [0], arrptMale2 [0], ptLend, ptRend, ptRef, ptContact;
ptContact = _Beam1.ptCen() + vecFemaleHng * dFw * .5 + vecFemaleU * dFh * .5; // Contact point aligned to _Pt0 on female beam
ptContact += vecR * vecR.dotProduct ( _Pt0 - ptContact );
//Zone of contact in male beam
PLine plRightMale ( vecFemaleU ); //PLine along down/left vertex of male beam
plRightMale.addVertex ( _Beam0.ptCen () + _X0 * _Beam0.solidLength () * .5 + vecR * dMw * .5 - vecU * dMh * .5);
plRightMale.addVertex ( _Beam0.ptCen () - _X0 * _Beam0.solidLength () * .5 + vecR * dMw * .5 - vecU * dMh * .5 );
PLine plLeftMale ( vecFemaleU ); // PLine along down/right vertex of male beam
plLeftMale.addVertex ( _Beam0.ptCen () + _X0 * _Beam0.solidLength () * .5 - vecR * dMw * .5 - vecU * dMh * .5);
plLeftMale.addVertex ( _Beam0.ptCen () - _X0 * _Beam0.solidLength () * .5 - vecR * dMw * .5 - vecU * dMh * .5 );
Plane pln ( ptContact, vecFemaleHng );//Plane in contact point located at female beam
arrptMale1 = plRightMale.intersectPoints ( pln );
arrptMale2  = plLeftMale.intersectPoints ( pln );
if ( arrptMale1.length() == 0 || arrptMale2.length() == 0 ) // Checks if ptRightMale & ptLeftMale exist
{
	reportMessage (T("\nHanger cannot be used here"));
	eraseInstance();
}
ptRightMale = arrptMale1 [0]; // Right contact point in male beam
ptLeftMale = arrptMale2 [0]; // left contact point in male beam

//Contact zone in female beam
ptLeftFemale = ptContact - vecR * dMw * .5;
ptRightFemale = ptContact + vecR * dMw * .5;

//Verify right position of male beam
ptLend = _Beam1.ptCen() - vecR * _Beam1.solidLength () * .5 + vecFemaleU * dFw * .5; //Left end in female beam
ptRend = _Beam1.ptCen() + vecR * _Beam1.solidLength () * .5 + vecFemaleU * dFw * .5;//Right end in female beam
ptRef = ptLeftFemale + vecR * dHw * .5;

//Check that male beam is OVER male beam
if ( abs ( vecR.dotProduct ( ( ptRef - vecR * dHtotalw *.5 ) - ptRef) ) > abs ( vecR.dotProduct ( ptLend - ptRef) ) || abs ( vecR.dotProduct ( ( ptRef + vecR * dHtotalw *.5 ) - ptRef) ) > abs ( vecR.dotProduct ( ptRend - ptRef) ) )
{
	reportMessage (T("\nMale beam is not in right position over female beam"));
	eraseInstance();
}  
//Check the beams are in contact
if ( abs ( ( ptLeftFemale - ptLeftMale ).length() ) > dEps ) 
{
	reportMessage (T("\nBeams are not in contact or are intersecting each other"));
	eraseInstance();		
}

//Verify angles from manufacturer
double dMinAngle = 15;
double dMaxAngle = 45;
double dAngle = acos ( _X0.dotProduct (vecFemaleHng));
if ( dAngle > 90 )
	dAngle = 180 - dAngle;
if (  dAngle < dMinAngle - dEps || dAngle  > dMaxAngle + dEps )
{
	reportMessage (T("\nAngle not recommended by manufacturer"));	
	eraseInstance();	
}

//DRAWING
//Front plate in female beam
ptRef = ptLeftFemale + vecR * dHw * .5;//			MOVING POINT
PLine pl1 ( vecFemaleHng );
pl1.addVertex ( ptRef - vecR * dHtotalw * .5 );
pl1.addVertex ( ptRef + vecR * dHtotalw * .5 );
pl1.addVertex ( ptRef + vecR * dHtotalw * .5 - vecFemaleU * dHw * .4 );
pl1.addVertex ( ptRef + vecR * dHtotalw * .3 - vecFemaleU * dHw * .8 );
pl1.addVertex ( ptRef - vecR * dHtotalw * .3 - vecFemaleU * dHw * .8 );
pl1.addVertex ( ptRef - vecR * dHtotalw * .5 - vecFemaleU * dHw * .4 );
pl1.close();
Body bd1 ( pl1, -vecMaleXUp * dHth, 1 );
double ptFemaleMinHeight=abs(vecFemaleU.dotProduct(ptContact-( ptRef + vecR * dHtotalw * .3 - vecFemaleU * dHw * .8 )));

//Support's bottom plate
PLine pl2 ( -vecU );
pl2.addVertex ( ptRef + vecR * (dHw * .5 + dHth ));
pl2.addVertex ( ptRef + vecR * (dHw * .5 + dHth ) + vecMaleXUp * dHw * 1.3 );
pl2.addVertex ( ptRef - vecR * (dHw * .5 + dHth ) + vecMaleXUp * dHw * 1.3 );
pl2.addVertex ( ptRef - vecR * (dHw * .5 + dHth ));
pl2.close ();
Body bd2 ( pl2, -vecFemaleHng * dHth, 1 );

//Support's lateral plate (Right)
PLine pl3 ( -vecR );
ptRef += -vecR * dHw * .5 ;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 90, vecR ) * dHw * 1.3;
pl3.addVertex ( ptRef );
ptRef += vecU * dHw * .1;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 40, vecR ) * dHw * 1.3;
pl3.addVertex ( ptRef );
ptRef += vecU * dHw * .2;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -45, vecR ) * dHw * .04;
double dMaleMinHeigth=abs(vecU.dotProduct(ptRef-ptContact));//Distance for check minimum male beam's height
pl3.addVertex ( ptRef );
ptRef += -vecMaleXUp * dHw * .6;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -135, vecR ) * dHw * .08;
pl3.addVertex ( ptRef );
ptRef += -vecU * dHw * .15;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 135, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 180, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 225, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -90, vecR ) * dHw * .02;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -45, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 0, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( 45, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU * dHw * .12;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -45, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -90, vecR ) * dHw * .5;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -135, vecR ) * dHw * .04;
pl3.addVertex ( ptRef );
ptRef += -vecU * dHw * .2;
pl3.addVertex ( ptRef );
ptRef += vecU.rotateBy ( -138, vecR ) * dHw * 1.3;
pl3.addVertex ( ptRef );
pl3.close();
Body bd3 ( pl3, -vecR * dHth, 1);


//Support plate on female beam, normal to _ZW
//Fixed part
PLine pl4 ( _ZW );
ptRef +=  vecFemaleHng * vecFemaleHng.dotProduct(ptContact-ptRef) + vecFemaleU * vecFemaleU.dotProduct(ptContact-ptRef) - vecR * (dHtotalw * .5 - dHw * .5 );
pl4.addVertex ( ptRef );
ptRef += -vecFemaleHng * dHw * .8;
pl4.addVertex ( ptRef );
ptRef += -vecFemaleHng.rotateBy ( 45, vecFemaleU) * dHw * .1;
pl4.addVertex ( ptRef );
ptRef += vecR* dHw * .3;
pl4.addVertex ( ptRef );
ptRef +=  vecFemaleHng * vecFemaleHng.dotProduct(ptContact-ptRef) + vecR * ( vecR.dotProduct ( ( ptContact - vecR * ( dHw * .5 + dHth )) - ptRef));
pl4.addVertex ( ptRef );
pl4.close();
Body bd4 ( pl4, vecMaleXUp, 1 );
PLine pl5 ( _ZW );
ptRef += vecR * ( dHth + dHw  * 2);
pl5.addVertex ( ptRef );
ptRef += -vecFemaleHng * dHw * .8;
pl5.addVertex ( ptRef );
ptRef += -vecFemaleHng.rotateBy ( -45, vecFemaleU) * dHw * .1;
pl5.addVertex ( ptRef );
ptRef -= vecR* dHw * .3;
pl5.addVertex ( ptRef );
ptRef +=  vecFemaleHng * vecFemaleHng.dotProduct(ptContact-ptRef) + vecR * ( vecR.dotProduct ( ( ptContact + vecR * ( dHw * .5 + dHth )) - ptRef));
pl5.addVertex ( ptRef );
pl5.close();
Body bd5 ( pl5, vecMaleXUp, 1 );
//Floating mobile part 
ptRef += - vecR * ( dHw + dHth *2) - vecFemaleHng * dHth;
ptRef += vecFemaleU.rotateBy ( 90-dAngle, vecR ) * dHw * 1.3;
//This part will be placed depending on the angle, so it'e mobile, then the circle is for finding the pointto draw
PLine plCircle( vecR );
plCircle.createCircle(ptRef, vecR, dHw);
Plane plnCircle(ptContact, vecFemaleU);
Point3d ptarrIntersected[]=plCircle.intersectPoints(plnCircle);//Intersection between planeand circle will give us all the points, then we must select the rigth one
Point3d ptIntersects=ptContact;
for(int i=0; i<ptarrIntersected.length(); i++)
{
	if(vecFemaleHng.dotProduct(ptIntersects-ptContact)>vecFemaleHng.dotProduct(ptarrIntersected[i]-ptContact))
		ptIntersects=ptarrIntersected[i];
}

//Extra checks
//Check that male beam has height enough (from line 181)
if(dMh<dMaleMinHeigth)
{
	reportMessage(T("\nMale height not enough for hanger"));
	eraseInstance();
}
//Check that female beam has width enough
if(dFw<abs(vecFemaleHng.dotProduct(ptContact-ptIntersects)))
{
	reportMessage(T("\nFemale width not enough for hanger"));
	eraseInstance();
}
//Check that female beam has heigth enough (from line 157)
if(dFh<ptFemaleMinHeight)
{
	reportMessage(T("\nFemale height not enough for hanger"));
	eraseInstance();
}

Vector3d vecAux(ptRef-ptIntersects);// for determine the angle for extrusion vector in very last part of drawing
PLine pl6(vecMaleXUp);
pl6.addVertex(ptRef);
pl6.addVertex(ptIntersects);
pl6.addVertex(ptIntersects+vecR*(dHth*2+dHw));
pl6.addVertex(ptRef+vecR*(dHth*2+dHw));
Body bd6(pl6,-vecFemaleHng*dHth, 1);
//Fixed mobile part 
ptRef+=vecFemaleHng*(vecFemaleHng.dotProduct(ptIntersects-ptRef)-dHth)+vecFemaleU*vecFemaleU.dotProduct(ptIntersects-ptRef);
PLine pl7 (vecFemaleU);
pl7.addVertex(ptRef+vecFemaleHng*dHth);
pl7.addVertex(ptRef);
pl7.addVertex(ptRef-vecR*(dHtotalw*.5-dHw*.5-dHth));
pl7.addVertex(ptRef-vecR*(dHtotalw*.5-dHw*.5-dHth)+vecFemaleHng*(dHw*.47-dHth));
pl7.addVertex(ptRef-vecR*(dHtotalw*.5-dHw*(.88)-dHth)+vecFemaleHng*(dHw*.47-dHth));
ptRef+=-vecR*(dHtotalw*.5-dHw*(.88)-dHth)+vecFemaleHng*dHw*.46+vecR.rotateBy(54,vecFemaleU)*dHw*.65;
pl7.addVertex(ptRef);
ptRef+=-vecR*(vecR.dotProduct(ptRef-ptContact)-vecR.dotProduct((ptContact-vecR*dHw*.5)-ptContact)+dHth);
ptRef+=vecR*dHw*.1;
pl7.addVertex(ptRef);
pl7.addVertex(ptIntersects-vecR*(vecR.dotProduct(ptIntersects-ptRef))+vecFemaleHng*dHw*.2);
pl7.addVertex(ptIntersects-vecR*(vecR.dotProduct(ptIntersects-(ptContact+vecR*(dHw*.5+dHth))-vecR*(vecR.dotProduct(ptIntersects-ptContact+vecR*(dHw*(.5-.1)+dHth)))))+vecFemaleHng*dHw*.2);
ptRef-=vecR*(vecR.dotProduct(ptRef-(ptContact+vecR*(dHw*.5+dHth))-vecR*(vecR.dotProduct(ptRef-ptContact+vecR*(dHw*(.5-.2)+dHth)))));
pl7.addVertex(ptRef);
pl7.addVertex(ptRef+vecR*dHw*.31);
ptRef+=vecR*dHw*.31+vecR.rotateBy(-55,vecFemaleU)*dHw*.65;
pl7.addVertex(ptRef);
pl7.addVertex(ptRef+vecR*dHw*.394);
pl7.addVertex(ptRef+vecR*dHw*.394-vecFemaleHng*(vecFemaleHng.dotProduct(ptRef-ptIntersects)));
pl7.close();
//Here we use the vecAux
vecAux.normalize();
Body bd7(pl7,vecAux,1);
Display dspl (9);
dspl.draw ( bd1 );
dspl.draw ( bd2 );
dspl.draw ( bd3 );
bd3.transformBy ( vecR * ( dHw + dHth ));
dspl.draw(bd3);
dspl.draw(bd4);
dspl.draw (bd5);
dspl.draw ( bd6 );
dspl.draw ( bd7 );



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
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`"JI9@%&2:-@-&WA\E.
M>6/6L9.Y1+4@%`!0`4`%`!0`4`(S!5)8X`I@499#(^>W85HE8!E,`H`*`"@`
MH`*`"@"*J)"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`O6L`50[#YCTSVK*4KZ%;%FH`*`"@`H`*`"@`H`*`*4\OF'`^Z
M*T2L!%5`%`!0`4`%`!0`4`&=HW'GT%&X$542%`!0`4`%`!0`4`%`!0`4`%`!
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
`


#End
