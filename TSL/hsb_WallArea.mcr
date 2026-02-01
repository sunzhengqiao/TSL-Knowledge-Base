#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
13.04.2012  -  version 1.3





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  IRELAND
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
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 02.02.2011
* version 1.0: Release Version
*
* Modify by: Alberto Jena (ajena@itw-industry.com)
* date: 14.02.2011
* version 1.1: Remove the Area of the openings
*
* date: 17.02.2011
* version 1.2: Fix issue with opening area
*
* date: 13.04.2012
* version 1.3: Fix issue with panel not close
*/

Unit(1,"mm"); // script uses mm
int nLunit = 2; // architectural
int nPrec = 1; // precision 

PropString sDimStyle(0, _DimStyles, T("Set Dimstyle"));
PropInt nColor(1, -1, T("Enter Colour"));

if(_bOnInsert)
{
	_Pt0 = getPoint("Select Point for insert");
	Viewport vp = getViewport("Select the viewport"); // select viewport
  	_Viewport.append(vp);
	return;
}

if(_Viewport.length()==0)
{
	reportMessage("No Viewport found");
	eraseInstance();
	return;
}

Element el=_Viewport[0].element();

double dGenBeamArea=0;
Plane plWallElev(el.ptOrg(),el.vecZ());
GenBeam genbmAll[]=el.genBeam();
PlaneProfile pp;

for(int j=0;j<genbmAll.length();j++)
{
	GenBeam genCurr=genbmAll[j];
	Body bdCurr=genCurr.realBody();
	if(j==0)
	{
		pp=bdCurr.shadowProfile(plWallElev);
	}
	else
	{
		PlaneProfile ppCurr=bdCurr.shadowProfile(plWallElev);
		pp.unionWith(ppCurr);
	}
}

//Remove any rings that are defined as openings to get an outline of the wall
int nOpenings[]=pp.ringIsOpening();
PLine plOutline[]=pp.allRings();

for(int j=nOpenings.length()-1;j>=0;j--)
{
	int nCurrOpening=nOpenings[j];
	if(nCurrOpening==1)
	{
		plOutline.removeAt(j);
	}
}

for(int j=0;j<plOutline.length();j++)
{
	PLine plCurr=plOutline[j];
	plCurr.vis();
	dGenBeamArea=dGenBeamArea+plCurr.area();
}

Opening opAll[]=el.opening();

double dOpTotalArea=0;

for(int j=0;j<opAll.length();j++)
{
	PlaneProfile ppOp=opAll[j].plShape();
	dGenBeamArea-=ppOp.area();
	dOpTotalArea+=ppOp.area();
}


el.plEnvelope().vis(4);
double dWallEnvelopeArea=0;
dWallEnvelopeArea=dWallEnvelopeArea+el.plEnvelope().area();
//Convert units to sqm
if (dGenBeamArea<0)
{
	dGenBeamArea=dWallEnvelopeArea-dOpTotalArea;
}

dWallEnvelopeArea=dWallEnvelopeArea/U(1000000);
dGenBeamArea=dGenBeamArea/U(1000000);

String sArea; 
sArea.formatUnit(dGenBeamArea,nLunit,nPrec);
sArea=sArea+"sq.m";
Display dp(nColor); 
dp.dimStyle(sDimStyle);
dp.draw( "Area: "+sArea, _Pt0,  _XW,_YW, 1,0);	

return;





#End
#BeginThumbnail






#End
