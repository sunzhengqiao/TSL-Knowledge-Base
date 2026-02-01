#Version 8
#BeginDescription
Displays wall icon (arrow) of current element in active hsbCAD viewport
v1.2: 14.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: 14.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from BP_LAYOUT_MINIDOMAIN, to keep US content folder naming standards
 v1.2: 14.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.2, to keep updated with BP_LAYOUT_MINIDOMAIN
	- Thumbnail reeplaced
	- Description added
	- Copyright added
*/



Unit(1,"mm"); // script uses mm

PropDouble d0 (0, 2, T("Size"));

showDialog();
if (_bOnInsert) {
  
  reportMessage("\nAfter inserting you can change the OPM value to set the direction, and the zone.");
   _Pt0 = getPoint(); // select point
  Viewport vp = getViewport("Select a viewport, you can add others later on with the HSB_LINKTOOLS command."); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));



// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();

ElementWallSF elW=(ElementWallSF)el;


int nZoneIndex = vp.activeZoneIndex();

Display dp(0); 
dp.color(1);

if(elW.bIsValid()){
	Vector3d  vx = el.coordSys().vecX();
	Vector3d  vy = el.coordSys().vecY();
	Vector3d  vz = el.coordSys().vecZ();
	Point3d pOl[] = el.plOutlineWall().vertexPoints(TRUE);
	double  dElLength = (pOl[0] - pOl[1]).length();
	Point3d pX = el.coordSys().ptOrg();
	pX.transformBy(ms2ps);

	Vector3d vxps = vx;
	vxps.transformBy(ms2ps);
	Vector3d vyps = vy;
	vyps.transformBy(ms2ps);
	Vector3d vzps = vz;
	vzps.transformBy(ms2ps);

	pX = pX + vxps * 0.5 * dElLength;

	PLine plA(_ZW);
	plA.addVertex(pX + vxps * 50 * d0 + vzps * d0 * 100);
	plA.addVertex(pX);
	plA.addVertex(pX - vxps * 50 * d0 + vzps * d0 * 100);
	plA.addVertex(pX - vxps * 5 * d0 + vzps * d0 * 100);
	plA.addVertex(pX - vxps * 5 * d0 + vzps * d0 * 200);
	plA.addVertex(pX + vxps * 5 * d0 + vzps * d0 * 200);
	plA.addVertex(pX + vxps * 5 * d0 + vzps * d0 * 100);
	plA.addVertex(pX + vxps * 50 * d0 + vzps * d0 * 100);

	dp.draw(plA);
}
else{
	PLine pl = el.plEnvelope();
	pl.transformBy(ms2ps);
	//dp.draw(pl);
} 










#End
#BeginThumbnail
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
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K"U7
MP;X?UN]-[J&G++<%0K2+(Z%@.F=I&3VR><`#M6[15PJ3@[P=GY":3W"BBBH&
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%97B33+C6?#U
M[I]K<_9YITVK)SCJ"5..<$#!]B>#TK5HI-75F73J2IS4X[IW/G^VM_\`A#?%
MBQ:_I45W%'D-&XW*R'@2)GAN^,^XX(R/<;#6]-U/36U&SO(I+1-V^4G:$V]=
MV<%<#GGMSTIFM:#IVOV36VH6ZR#:0D@`WQ$XY5NQX'L<<Y%>/7'@;Q-9:Q)H
MEJL\EK<LN;A-RP2*"2#)C@$<\')!Z9R,\EIT':*NF?22J8?-XJ56?)4BM>S7
M6WG_`%KTZ3Q;\3VBEEL/#Y4LC`-?<,,CJ$4C!'0;CQUP.AJEX:^&M[J5P-1\
M1-+%&SB0P,<RSY&26;.5R2,Y^;K]W@UU?A7X?:=H"QW-TJWFH[5)=P"D3`YS
M&".#T^8\\<8R178U<:,IOFJ_<<];,Z6%@Z&7JW>75^G]>EB*VMK>SMUM[6"*
M"%,[8XD"J,G)P!QUJ6BBND\%MMW84444""BBB@`HHHH`****`"BBB@`HHHH`
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
>****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_9
`

#End
