#Version 8
#BeginDescription
Draws a List of SIP panels with the same Posnum for shop drawings

Modified by: Chirag Sawjani
date: 10.10.2018  - version 1.2

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
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
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 13.07.2012 
* version 1.0: Release
*
* Modified by: Chirag Sawjani
* date: 11.06.2015
* version 1.1: Removed unnecessary code
*/


String sModel = T("|Model|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sModel , sShopdrawSpace };
PropString sSpace(0,sArSpace,T("|Drawing space|"));

PropString sDimLayout(1,_DimStyles,T("Dim Style"));
PropInt nDimColor(0,1,T("Color"));

PropString sListHeading(2,"Panel List:","Panel list heading:");


if(_bOnInsert)
{
	showDialog();

	_Pt0=getPoint(T("Pick a point for edge details"));
	
		if (sSpace == sModel)
	{	//Model
		PrEntity ssE(T("Please select Elements"),Sip());
	 	if (ssE.go())
		{
	 		Entity ents[0];
	 		ents = ssE.set();
	 		for (int i = 0; i < ents.length(); i++ )
			 {
	 			Sip s = (Sip) ents[i];
	 			_Entity.append(s);
	 		 }
	 	}	
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
	
		//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}


	
	return;

}//end bOnInsert

// coordSys
CoordSys ms2ps, ps2ms;	
Sip sipCurr;


Display dp(nDimColor);
dp.dimStyle(sDimLayout);




if (_Entity.length()==0) return; // _Entity array has some elements

if (sSpace == sModel) 
{
	sipCurr=(Sip)_Entity[0];
}

if (sSpace == sShopdrawSpace ) 
{
	
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	if (!sv.bIsValid()) return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) 
	{
		dp.color(nDimColor);
		dp.dimStyle(sDimLayout);
		dp.textHeight(U(5));
		dp.draw(scriptName(),_Pt0,_XW ,_YW,1,0);	
		return; // no viewData found
	}
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
		
		
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Sip()))
		{
			sipCurr=(Sip)ent;
		}
	}
}

//Get all entities with the posnum
EntityCollection entCollection=sipCurr.getEntitiesWithPosnum(sipCurr.posnum());
Sip sipCollection[]=entCollection.sip();


Point3d ptDraw=_Pt0;
//Heading
dp.draw(sListHeading,ptDraw,_XW,_YW,1,0);
ptDraw-=(dp.textHeightForStyle("X", sDimLayout)+U(20))*_YW;

//Display current panel number if no other sips are in the posnum collection, otherwise go through the collection listing panel numbers
if(sipCollection.length()==0)
{
	String sLabel=sipCurr.label();
	String sSubLabel=sipCurr.subLabel();
		
	String sComposed=sLabel+sSubLabel;
	dp.draw(sComposed,ptDraw,_XW,_YW,1,0);

}
else
{
	String sComposedName[0];	
	for(int s=0;s<sipCollection.length();s++)
	{
		Sip sip=sipCollection[s];
		String sLabel=sip.label();
		String sSubLabel=sip.subLabel();
		
		String sComposed=sLabel+sSubLabel;
		sComposedName.append(sComposed);

	}
	
	//Sort the composed name
	for (int c=0; c<sComposedName.length()-1; c++)
	{
		for (int d=c+1; d<sComposedName.length(); d++)
		{
			if (sComposedName[c]>sComposedName[d])
			{
				sComposedName.swap(c, d);
			     d--;
			}
		}
	}

	for (int c=0; c<sComposedName.length(); c++)
	{
		String sComposed=sComposedName[c];
		dp.draw(sComposed,ptDraw,_XW,_YW,1,0);
		ptDraw-=(dp.textHeightForStyle("X", sDimLayout)+U(20))*_YW;		
	}
	
}

#End
#BeginThumbnail




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End