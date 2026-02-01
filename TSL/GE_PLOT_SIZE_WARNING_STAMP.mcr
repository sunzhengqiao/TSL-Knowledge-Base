#Version 8
#BeginDescription
Indicates an element being too large.
v0.3: 19.mar.2013: David Rueda (dr@hsb-cad.com)


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 0
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
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
* v0.3: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Dimstyle applied
	- Color set to red
* v0.2: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description modified
	- Thumbnail added
	- Copyright added
* V0.1_Nov 31 2011 No author
*
*/

Unit(1,"inch");

PropString pDimStyle(0,_DimStyles,"DimStyle");
PropDouble dTH(0,U(0),"Text Height (0 Uses DimStyle)");
PropDouble dMaxSize(1,U(102.25),"Max Size");
PropDouble dAngle(2,15 ,"Angle for Text");
dAngle.setFormat(_kNoUnit);

String arDir[]={"Element Y(Height)","Element X(Width)","Both"};
PropString stDir(1,arDir,"Direction To Check");

PropString strText(2,"WIDE LOAD","Text to Draw");

if(_bOnInsert){
	if(insertCycleCount()>1)eraseInstance();
	
	showDialog();
	
	_Pt0 = getPoint("Select location"); // select point
	Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
	_Viewport.append(vp);
	return;
}



Display dp(-1); // use color of entity
if(dTH>U(0))
	dp.textHeight(dTH);
else
	dp.dimStyle(pDimStyle);

dp.color(1);

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost



// check if the viewport has hsb data
if (!vp.element().bIsValid())return;
Element el = vp.element();
Line lnX(el.ptOrg(),el.vecX());
Line lnY(el.ptOrg(),el.vecY());


Beam arBm[]=el.beam();

Point3d arPt[0];
for(int i=0;i<arBm.length();i++)arPt.append(arBm[i].realBody().allVertices());

int iDraw=0;

if(stDir == arDir[0]){
	//in El Y only
	arPt=lnY.orderPoints(arPt);
	
	if(arPt.length() > 1){
		double dd=el.vecY().dotProduct(arPt[arPt.length()-1]-arPt[0]);
		if(dd>dMaxSize)iDraw=1;
	}
}
else if(stDir == arDir[1]){
	//in El X only
	arPt=lnX.orderPoints(arPt);
	
	if(arPt.length() > 1){
		double dd=el.vecX().dotProduct(arPt[arPt.length()-1]-arPt[0]);
		if(dd>dMaxSize)iDraw=1;
	}
}
else if(stDir == arDir[2]){
	//both directions
	arPt=lnX.orderPoints(arPt);
	Point3d arPt2[]=lnY.orderPoints(arPt);
	if(arPt.length() > 1 && arPt2.length() > 1){
		double dx=el.vecX().dotProduct(arPt[arPt.length()-1]-arPt[0]);
		double dy=el.vecY().dotProduct(arPt2[arPt2.length()-1]-arPt2[0]);
		if(dx>dMaxSize || dy>dMaxSize)iDraw=1;
	}
}

CoordSys csDraw(_PtW,_XW,_YW,_ZW);

CoordSys csRotate;
csRotate.setToRotation(dAngle,_ZW,_PtW);
csDraw.transformBy(csRotate);





// draw the text at insert point
if(iDraw)dp.draw(strText ,_Pt0,csDraw.vecX(),csDraw.vecY(),0,0);





























#End
#BeginThumbnail
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
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
+`HHHH`****`/_]DH
`


#End
