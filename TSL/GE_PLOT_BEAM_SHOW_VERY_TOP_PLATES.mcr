#Version 8
#BeginDescription
GE_PLOT_BEAM_SHOW_VERY_TOP_PLATES
Draws VTP's
v1.0: 04.sep.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2012 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: 04.sep.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

int nIndex;
String sTab="     ";
String sNoYes[]={T("|No|"), T("|Yes|")};

PropString sTitle(0,"",T("|Hatch|"));
sTitle.setReadOnly(1);
	PropString sDisplayHatch(1,sNoYes,sTab+T("|Display Hatch|"),1);
	int nDisplayHatch=sNoYes.find(sDisplayHatch,1);
	PropString sHatchPattern(2,_HatchPatterns,sTab+T("|Pattern|"),1);
	PropDouble dHatchScale(0,U(10,.5),sTab+T("|Scale|"));
	

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
  	Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
	_Viewport.append(vp);

	nIndex=_HatchPatterns.find("DOTS",-1);
	if(nIndex>-1)
	{
		sHatchPattern.set(_HatchPatterns[nIndex]);
	}
		
	return;
}

if (_Viewport.length()==0) 
	return; // _Viewport array has some elements
Viewport vp= _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid())
	return;
CoordSys csVp= vp.coordSys();
Element el= vp.element();
if (!el.element().bIsValid()) 
	return;

PLine plEl=el.plOutlineWall();
PlaneProfile ppEl(plEl);
plEl.transformBy(csVp);
Display dp(4);
dp.draw(plEl);


Hatch hatch(sHatchPattern,dHatchScale);
dp.color(32);

Beam bmAll[]= el.beam();
for(int b=0;b<bmAll.length();b++)
{
	Beam bm=bmAll[b];
	if(bm.type()==_kSFVeryTopPlate || bm.type()==_kSFVeryTopSlopedPlate)
	{
		Body bdBm=bm.envelopeBody();
		bdBm.transformBy(csVp);
		PlaneProfile ppBm=bdBm.shadowProfile(Plane(bm.ptCen(),_ZW));	
		dp.draw(ppBm);

		if(nDisplayHatch)
			dp.draw(ppBm,hatch);
	}
}

return;
#End
#BeginThumbnail

#End
