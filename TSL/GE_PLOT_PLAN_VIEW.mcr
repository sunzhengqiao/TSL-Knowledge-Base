#Version 8
#BeginDescription
Creates a view of a TF wall in layout and displays customizable symbols for beam types.
Symbols available:
‘ No display ’
 ‘ o ’
‘ \ ’
‘ / ’
‘ X ’ 
‘ Outline only ‘ 
‘ Center line trough timber’
v1.1: 20.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* v1.1: 20.mar.2013: David Rueda (dr@hsb-cad.com)
*	- Name on prop. changed from "Sill" to "Window Sill"
* v1.0: 28.jun.2012: David Rueda (dr@hsb-cad.com)
*	- Made a copy of Albert's hsb_LayoutPlanSection (v2.0: 07.06.2012)
*	- Added pre-defined values for individual customization for every beam type
*	- Added special treatment for vertical/horizontal blocking 
*/

// symbols :  '/'  
//                   'O'   : letter O (not number zero)
//                   '\\'     need to have a double backslash
//                   'X'
//                   ' '      need blank (not empty otherwise TSL doesn't work)
//			   'S' 	Show only the Shadow on that with
//			   '-' 	Shows line through timber

String sChoices[]= { T("|No display|"), "O", "/", "\\", "X", T("|Outline only|"), T("|Center line trough timber|")};
String sSymbols[]= {" ", "O", "/", "\\", "X", "S", "-"};
String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(1, sArSpace, T("|Drawing space|"));

int nBmType[0];
String arCross[0];arCross.setLength(0);

PropString sbmName00(3, sChoices, T("Jack Over Opening"), 0);			nBmType.append(_kSFJackOverOpening);		arCross.append( sSymbols[ sChoices.find( sbmName00, 0)]);
PropString sbmName01(4, sChoices, T("Jack Under Opening"), 0);			nBmType.append(_kSFJackUnderOpening);		arCross.append( sSymbols[ sChoices.find( sbmName01, 0)]);
PropString sbmName02(5, sChoices, T("Cripple Stud"), 0);					nBmType.append(_kCrippleStud);				arCross.append( sSymbols[ sChoices.find( sbmName02, 0)]);
PropString sbmName03(6, sChoices, T("Transom"), 0);						nBmType.append(_kSFTransom);					arCross.append( sSymbols[ sChoices.find( sbmName03, 0)]);
PropString sbmName04(7, sChoices, T("King Stud"), 0);						nBmType.append(_kKingStud);					arCross.append( sSymbols[ sChoices.find( sbmName04, 0)]);
PropString sbmName05(8, sChoices, T("Window Sill"), 0);					nBmType.append(_kSill);							arCross.append( sSymbols[ sChoices.find( sbmName05, 0)]);
PropString sbmName06(9, sChoices, T("Angled TopPlate Left"), 0);			nBmType.append(_kSFAngledTPLeft);			arCross.append( sSymbols[ sChoices.find( sbmName06, 0)]);
PropString sbmName07(10, sChoices, T("Angled TopPlate Right"), 0);		nBmType.append(_kSFAngledTPRight);			arCross.append( sSymbols[ sChoices.find( sbmName07, 0)]);
PropString sbmName08(11, sChoices, T("TopPlate"), 0);						nBmType.append(_kSFTopPlate);					arCross.append( sSymbols[ sChoices.find( sbmName08, 0)]);
PropString sbmName09(12, sChoices, T("Bottom Plate"), 0);				nBmType.append(_kSFBottomPlate);				arCross.append( sSymbols[ sChoices.find( sbmName09, 0)]);
PropString sbmName10(13, sChoices, T("Blocking"), 0);						nBmType.append(_kSFBlocking);					arCross.append( sSymbols[ sChoices.find( sbmName10, 0)]);
										   /* Adding _kBlocking */				nBmType.append(_kBlocking);					arCross.append( sSymbols[ sChoices.find( sbmName10, 0)]);
PropString sbmName11(15, sChoices, T("Supporting Beam"), 0);			nBmType.append(_kSFSupportingBeam);		arCross.append( sSymbols[ sChoices.find( sbmName11, 0)]);
PropString sbmName12(16, sChoices, T("Stud"), 0);							nBmType.append(_kStud);						arCross.append( sSymbols[ sChoices.find( sbmName12, 0)]);
PropString sbmName13(17, sChoices, T("Stud Left"), 0);						nBmType.append(_kSFStudLeft);					arCross.append( sSymbols[ sChoices.find( sbmName13, 0)]);
PropString sbmName14(18, sChoices, T("Stud Right"), 0);					nBmType.append(_kSFStudRight);				arCross.append( sSymbols[ sChoices.find( sbmName14, 0)]);
PropString sbmName15(19, sChoices, T("Header"), 0);						nBmType.append(_kHeader);						arCross.append( sSymbols[ sChoices.find( sbmName15, 0)]);
PropString sbmName16(20, sChoices, T("Brace"), 0);						nBmType.append(_kBrace);						arCross.append( sSymbols[ sChoices.find( sbmName16, 0)]);
PropString sbmName17(21, sChoices, T("Locating Plate"), 0);				nBmType.append(_kLocatingPlate);				arCross.append( sSymbols[ sChoices.find( sbmName17, 0)]);
PropString sbmName18(22, sChoices, T("Packer"), 0);						nBmType.append(_kSFPacker);					arCross.append( sSymbols[ sChoices.find( sbmName18, 0)]);
PropString sbmName19(23, sChoices, T("SolePlate"), 0);					nBmType.append(_kSFSolePlate);				arCross.append( sSymbols[ sChoices.find( sbmName19, 0)]);
PropString sbmName20(24, sChoices, T("HeadBinder/Very Top Plate"), 0);	nBmType.append(_kSFVeryTopPlate);			arCross.append( sSymbols[ sChoices.find( sbmName20, 0)]);
PropString sbmName21(25, sChoices, T("Vent"), 0);							nBmType.append(_kSFVent);						arCross.append( sSymbols[ sChoices.find( sbmName21, 0)]);

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	showDialog();
	
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}

	//Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
	//_Viewport.append(vp);
	
	return;
}

Display dp(-1); // use color of entity for frame

// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
if (_Viewport.length()>0)
	sSpace.set(sPaperSpace);
else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
	sSpace.set(sShopdrawSpace);

sSpace.setReadOnly(TRUE);

Element el;
CoordSys csVp;

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost
	
	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;
	
	csVp = vp.coordSys();
	el = vp.element();
}

//shopdrawspace	
if (sSpace == sShopdrawSpace )
{
	if (_Entity.length()==0) return; // _Entity array has some elements
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	if (!sv.bIsValid()) return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	csVp = vwData.coordSys();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Element()))
		{
			el=(Element) ent;
		}
	}
}


Beam arBeam[0]; 
arBeam  = el.beam();

_Pt0= csVp.ptOrg();

// Display element outline
CoordSys csEl= el.coordSys();
Vector3d vxEl= csEl.vecX();
Vector3d vyEl= csEl.vecY();
Vector3d vzEl= csEl.vecZ();
dp.color(4);

// Top view
PLine plElOutline= el.plOutlineWall();
PlaneProfile ppElOutline(plElOutline);
LineSeg ls=ppElOutline.extentInDir(vxEl);
double dElL=abs(vxEl.dotProduct(ls.ptStart()-ls.ptEnd()));
double dElH= ((Wall)el).baseHeight();
double dElW=el.dBeamWidth();
Point3d ptElMid= el.ptOrg()+vxEl*dElL*.5+vyEl*dElH*.5- vzEl* dElW*.5;
Point3d ptElMidPS= ptElMid;
ptElMidPS.transformBy( csVp);
PLine plElPS= plElOutline;
plElPS.transformBy( csVp);
dp.draw( plElPS);

// Side view
Point3d pt1= el.ptOrg();
Point3d pt2= pt1- vzEl* dElW+ vyEl* dElH;
plElPS.createRectangle( LineSeg( pt1, pt2), vzEl, vyEl);
plElPS.transformBy( csVp);
dp.draw( plElPS);
dp.color(-1);

int bSomethingWasDisplayed=false;
Plane pln (csVp.ptOrg(), _ZW); // Plane to project points
Vector3d vz=_ZW;
for (int i=0; i<arBeam.length(); i++) 
{
	// loop over list items
	int bOK = false;
	Beam bm = arBeam[i];
	
	int nLocation = nBmType.find(bm.type(), -1);	

	String Cross;
	if (nLocation!=-1)
	{
		Cross=arCross[nLocation];
	}
	if (nLocation!=-1 && Cross!='N')
	{
		double dHL = bm.dL()/2;
		double dHH = bm.dH()/2;
		double dHW = bm.dW()/2;

    		Point3d ptM = bm.ptCen();
   		Point3d pta = bm.ptCen()+bm.vecX()*dHL+bm.vecY()*dHW+bm.vecZ()*dHH;
   		Point3d ptb = bm.ptCen()-bm.vecX()*dHL-bm.vecY()*dHW-bm.vecZ()*dHH;

   		Point3d ptc = bm.ptCen()+bm.vecX()*dHL-bm.vecY()*dHW+bm.vecZ()*dHH;
   		Point3d ptd = bm.ptCen()-bm.vecX()*dHL+bm.vecY()*dHW-bm.vecZ()*dHH;

   		Point3d ptm1 = bm.ptCen()+bm.vecX()*dHL;
   		Point3d ptm2 = bm.ptCen()-bm.vecX()*dHL;

		pta.transformBy(csVp);
		ptb.transformBy(csVp);
		PLine L1(pta, ptb);
		L1.projectPointsToPlane(pln, vz);
		
 		ptc.transformBy(csVp);
		ptd.transformBy(csVp);
		PLine L2(ptc, ptd);
		L2.projectPointsToPlane(pln, vz);

 		ptm1.transformBy(csVp);
		ptm2.transformBy(csVp);
		PLine L3(ptm1, ptm2);
		L3.projectPointsToPlane(pln, vz);

		double dStr = dHW*.8;
		if (dHH<dHW){
			dStr = dHH*.8;
		}
		PLine Plcir; Plcir.createCircle(ptM,bm.vecX(),dStr);


		Body bdBeam = bm.realBody();
		bdBeam.transformBy(csVp);
		PlaneProfile ppBm=bdBeam.shadowProfile(pln);
 
		// START special treatment for blocking		
		if (_Viewport.length()!=0 && (bm.type() == _kSFBlocking || bm.type() == _kBlocking))
		{ 
			Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
			Vector3d vxElPS= vxEl;
			vxElPS.transformBy( csVp);
	
			String cAlternateBlockSymbol= '/';

			int bBlockIsHorizontal;
			if( bm.vecX().isPerpendicularTo( _ZW))
				bBlockIsHorizontal= true;
			else
				bBlockIsHorizontal= false;

			if(vxElPS.isPerpendicularTo(_ZW)) // Horizontal display
			{
				if( bBlockIsHorizontal)
					Cross=cAlternateBlockSymbol;				
			}
			else 		// Vertical display
			{
				if( !bBlockIsHorizontal)
					Cross=cAlternateBlockSymbol;				
			}
		}
		// END special treatment for blocking
		  	
    		if (Cross=='S') {
			dp.draw(ppBm);
			bSomethingWasDisplayed= true;
    		}	   	

    		if (Cross=='X') {
			dp.draw(L1);
			dp.draw(L2);
			dp.draw(ppBm);
			bSomethingWasDisplayed= true;
    		}	   	

    		if (Cross=='-') {
			dp.draw(L3);
			dp.draw(ppBm);
			bSomethingWasDisplayed= true;
    		}	   	
  	
     		if (Cross=='\\') {
			dp.draw(L1);
			dp.draw(ppBm);
			bSomethingWasDisplayed= true;
    		}	   	

   		if (Cross=='/') {
			dp.draw(L2);
			dp.draw(ppBm);
			bSomethingWasDisplayed= true;
    		}	   	

    		if (Cross=='O') {
			Plcir.transformBy(csVp);
		Plcir.projectPointsToPlane(pln, vz);			dp.draw(Plcir);
			dp.draw(ppBm);
			bSomethingWasDisplayed= true;
    		}	   	
	}
}

if( !bSomethingWasDisplayed && sSpace == sPaperSpace )
{
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Pt0= ptElMidPS;
	dp.color(1);
	dp.textHeight(.1);
	Vector3d vxElPS= vxEl;
	vxElPS.transformBy( csVp);
	Vector3d vzElPS= vzEl;
	vzElPS.transformBy( csVp);

	Vector3d vxText, vyText;
	if( vxElPS.isParallelTo( _XW))
	{
		vxText= _XW;
		vyText= _YW;
	}
	else
	{
		vxText= _YW;
		vyText= _XW;
	}
	
	dp.draw( T("|This tsl need to be customized|"), ptElMidPS, vxText, vyText, 0,0, _kDevice );
}

return;


#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`*(`ZT#`2(``A$!`Q$!_\0`
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
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`JVMY]
MIN;Z'R]OV6<0YSG=F-'S[??Q^%%_>?8;9)O+W[IXH<9Q]^14S^&[/X55TK_D
M(ZW_`-?J_P#I/#1K_P#R#HO^OVT_]*(ZRYGR-^IIRKG2]#4HHHK4S"BBB@`H
MHHH`****`"BBB@`HHHH`*JVMY]IN;Z'R]OV6<0YSG=F-'S[??Q^%6JR]*_Y"
M.M_]?J_^D\-3)M-?UT*BKIEJ_O/L-LDWE[]T\4.,X^_(J9_#=G\*M5EZ_P#\
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
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`**\_\+7&K^*I?$$DGB35;/\`L_6[NP2.".T*%$8%
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
M2;A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
K`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'_V444
`



#End
