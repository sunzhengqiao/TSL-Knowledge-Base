#Version 7
#BeginDescription
Version No. 1.2   2006-02-15   th@hsbCAD.de
   - Dialog added
Version No. 1.1 , Date: 2006-02-14 Modified by David Rueda O., TSL Team, Quito, Ecuador.
Version No. 1.0 (Initial), Date: 2006-01-30 Created by David Rueda O., TSL Team, Quito, Ecuador.
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
U(1, "mm");

// props
String arStrType[]={"LS 60x65","LS 60x165","LS 80x90","LS 80x190","LB 60x65","LB 60x165","LB 80x90","LB 80x190"};//Shoe type
String strFixing[]={T("nails"),T("screws")};
String strError = T("\nShoe cannot be used!");
PropString prStrType (0,arStrType,T("Type"),0);//type of fixing
PropString prStrFixing (1,strFixing,T("Fixing"),0);
PropDouble prdExtH (0,0,T("Extra Beam Height"));//
PropDouble prdElev (0,0,T("Elevation"));

// on insert
	if(_bOnInsert)
	{
		showDialog();
		_Beam.append(getBeam());
		_Pt0 = getPoint();
	}

//Create arrays
//Shoe sizes
double arSc[]={70,70,70,70,70,70,70,70};
double arSh[]={65,165,90,190,65,165,90,190};
double arSl[]={60,60,80,80,60,60,80,80};
double arSj[]={0,0,0,0,90,90,90,90};
double arSk[]={0,0,0,0,90,90,90,90};
double arSth1[]={4,4,4,4,4,4,4,4};
double arSth2[]={0,0,0,0,5,5,5,5};
double arSs[]={270,270,270,270,0,0,0,0};
double arSb[]={0,0,0,0,100,100,100,100};
String arSm[]={"40305","40310","40320","40330","40405","40410","40420","40430"};//Shoe model


// get beam size
double dBw =_Beam0.dD(_Y0);
double dBh =_Beam0.dD(_Z0); 


//define type of fixing
int iIndex = -1;
for (int i=0; i < arSm.length(); i++)
{
	if (prStrType==arStrType[i])
	{
		iIndex = i;
		break;
	}
}

if (iIndex == -1)
{
	reportMessage(strError);
	eraseInstance();
	return;
}


//getting meassures
double dSc=arSc[iIndex];
double dSh=arSh[iIndex];
double dSl=arSl[iIndex];
double dSj=arSj[iIndex];
double dSk=arSk[iIndex];
double dSth1=arSth1[iIndex];
double dSth2=arSth2[iIndex];
double dSs=arSs[iIndex];
double dSb=arSb[iIndex];
double dSdiam=16;
double dNut=10;
String strSm="BMF-"+arSm[iIndex];//model
String strStype=arStrType[iIndex];//type


Point3d ptRef=_Pt0-_X0*prdElev-_Z0*(_H0*.5-dSl*.5);//Reference point: MOVING POINT ON LB MODELS

Display dp(0);

if(iIndex > 3 ){// LB MODELS
	
	//DRAWING PARTS
	//Base plate
	PLine pl1 (-_X0);
	pl1.addVertex(ptRef+_Z0*dSk*.5+_Y0*dSj*.5);
	pl1.addVertex(ptRef+_Z0*dSk*.5-_Y0*dSj*.5);
	pl1.addVertex(ptRef-_Z0*dSk*.5-_Y0*dSj*.5);
	pl1.addVertex(ptRef-_Z0*dSk*.5+_Y0*dSj*.5);
	pl1.close();
	Body bdBasePlate(pl1,-_X0*dSth2,1);
	dp.draw(bdBasePlate);
	
	//Drill
	ptRef+=-_X0*dSth2;
	Body bdDrill(ptRef,ptRef-_X0*(dSb-dNut*2), dSdiam*.5);
	dp.draw(bdDrill);
	
	//Nut1
	Body bdNut1(ptRef-_X0*(dSb-dNut*2+.2), ptRef-_X0*(dSb-dNut-.01), dSdiam*.5*1.7);
	dp.draw(bdNut1);
	
	//Nut2
	Body bdNut2(ptRef-_X0*(dSb-dNut-.02), ptRef-_X0*(dSb-.01), dSdiam*.5*1.7);
	dp.draw(bdNut2);
	
	//Bottom plate
	ptRef+=-_X0*(dSb-.02+dSth1);
	PLine pl2 (-_X0);
	pl2.addVertex(ptRef+_Z0*dSl*.5+_Y0*dSc*.5);
	pl2.addVertex(ptRef+_Z0*dSl*.5-_Y0*dSc*.5);
	pl2.addVertex(ptRef-_Z0*dSl*.5-_Y0*dSc*.5);
	pl2.addVertex(ptRef-_Z0*dSl*.5+_Y0*dSc*.5);
	pl2.close();
	Body bdBottomPlate(pl2,_X0*dSth1,1);
	dp.draw(bdBottomPlate);
	
	//Cutting beam
	ptRef.vis();
	Cut ct(ptRef,_X0);
	_Beam0.addTool(ct,TRUE);
	
	//Lateral plate
	ptRef+=-_Z0*dSl*.5;
	PLine pl3(_Z0);
	pl3.addVertex(ptRef+_Y0*dSc*.5+_X0*dSth1);
	pl3.addVertex(ptRef+_Y0*dSc*.5-_X0*dSh);
	pl3.addVertex(ptRef-_Y0*dSc*.5-_X0*dSh);
	pl3.addVertex(ptRef-_Y0*dSc*.5+_X0*dSth1);
	pl3.close();
	Body bdLateralPlate(pl3,_Z0*dSth1,-1);
	dp.draw(bdLateralPlate);


	
}


else{//LS MODELS
	Point3d ptRef=_Pt0-_X0*prdElev-_Z0*(_H0*.5-dSl*.5);//Reference point: MOVING POINT ON LB MODELS

	//DRAWING PARTS
	//Drill
	//ptRef+=-_X0*dSth2;
	Body bdDrill(ptRef,ptRef-_X0*(dSs-dNut*2), dSdiam*.5);
	dp.draw(bdDrill);
	
	//Nut1
	Body bdNut1(ptRef-_X0*(dSs-dNut*2+.2), ptRef-_X0*(dSs-dNut-.01), dSdiam*.5*1.7);
	dp.draw(bdNut1);
	
	//Nut2
	Body bdNut2(ptRef-_X0*(dSs-dNut-.02), ptRef-_X0*(dSs-.01), dSdiam*.5*1.7);
	dp.draw(bdNut2);
	
	//Bottom plate
	ptRef+=-_X0*(dSs-.02+dSth1);
	PLine pl2 (-_X0);
	pl2.addVertex(ptRef+_Z0*dSl*.5+_Y0*dSc*.5);
	pl2.addVertex(ptRef+_Z0*dSl*.5-_Y0*dSc*.5);
	pl2.addVertex(ptRef-_Z0*dSl*.5-_Y0*dSc*.5);
	pl2.addVertex(ptRef-_Z0*dSl*.5+_Y0*dSc*.5);
	pl2.close();
	Body bdBottomPlate(pl2,_X0*dSth1,1);
	dp.draw(bdBottomPlate);

	//Lateral plate
	ptRef+=-_Z0*dSl*.5;
	PLine pl3(_Z0);
	pl3.addVertex(ptRef+_Y0*dSc*.5+_X0*dSth1);
	pl3.addVertex(ptRef+_Y0*dSc*.5-_X0*dSh);
	pl3.addVertex(ptRef-_Y0*dSc*.5-_X0*dSh);
	pl3.addVertex(ptRef-_Y0*dSc*.5+_X0*dSth1);
	pl3.close();
	Body bdLateralPlate(pl3,_Z0*dSth1,-1);
	dp.draw(bdLateralPlate);

	//Cutting beam
	Cut ct(ptRef,_X0);
	_Beam0.addTool(ct,TRUE);
}

// Hardware 
strSm=strSm+"-"+prStrFixing;
strStype=strStype+"-"+prStrFixing;

//Material
setCompareKey(strSm); // hanger name  
model(strStype);//Article number 
dxaout(strSm,strStype);//Designation  
material(T("BMF Material"));
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
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`6;0<,?PK*
MH7$L5!84`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`%=OO'ZU:)8E,`H`*`"@`H
M`*`"@`H`*`"@`H`5?O#ZTF"*U:F84`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0!:M?\`5GZUE/<TCL3U!04`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`%=OO'Z
MU:)8E,`H`<D;O]U<T6%<0@@X(P?>@8E`!0`4`%`!0`4`%`"K]X?6DP16K4S"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`+5K_JS]:RGN:1V)Z@H*`"@`H`*
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
:`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H``_]D*
`

#End
