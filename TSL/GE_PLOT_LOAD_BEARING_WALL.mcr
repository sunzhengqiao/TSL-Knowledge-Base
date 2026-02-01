#Version 8
#BeginDescription
Displays graphical representation of LOAD BEARING WALLS and STRUCTURAL WOOD BEAM on PAPER SPACE or SHOP DRAWINGS
v1.4: 25.jul.2012: David Rueda (dr@hsb-cad.com)



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v1.4: 25.jul.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
* v1.3: 25.jul.2012: David Rueda (dr@hsb-cad.com)
	- Version update
* v1.2: 08.feb.2012: David Rueda (dr@hsb-cad.com)
	- Messages added to guide user on insertion
* v1.1: 24.jan.2012: David Rueda (dr@hsb-cad.com)
	- Filter load bearing walls by ElementWallSF property loadBearing().
* v1.0: 12.dec.2011: David Rueda (dr@hsb-cad.com)	
	- Release
*/

//OPM
String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(0,sArSpace,T("|Drawing space|"));

PropString sEmpty(1," "," ");
sEmpty.setReadOnly(1);

String sArWDp[]={T("|solid hatch|"), T("|cross hatch|"), T("|no display|")};
PropString sWDp(2,sArWDp, T("|Load bearing walls display|"),1);
int nWDp=sArWDp.find(sWDp,0);
PropDouble dWlHatchPtnr(0,U(25,1),T("|Load bearing walls pattern|"));
PropInt nWColor(0, 1, T("|Load bearing walls color|"),0);

PropString sEmpty2(3,"", "  ");
sEmpty2.setReadOnly(1);

String sArBmDp[]={T("|single line hatch|"), T("|no display|")};
PropString sBmDp(4,sArBmDp, T("|Structural wood beam display|"),0);
int nBmDp=sArBmDp.find(sBmDp);
PropDouble dBmHatchPtnr(1,U(25,1),T("|Structural wood beam pattern|"));
PropInt nBmColor(1, 3, T("|Structural wood beam color| "));
//END OPM

if(_bOnInsert)
{
		if( insertCycleCount()>1 ){ 
			eraseInstance();
			return;
		}

	showDialogOnce();
	
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("Select viewport")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select ShopDrawView|")); // select ShopDrawView
		_Entity.append(ent);
	}

	reportMessage(T("|Go to your hsbConsole and select any element in the target group|"));

	return;
}
//end _bOnInsert

Element el;
int nZoneIndex;
Entity entAll[0];	

//coordSys
CoordSys ms2ps, ps2ms;	

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) 
	{
		eraseInstance();
		return; // _Viewport array has some elements
	}
		
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) 
		return;

	ms2ps = vp.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	el = vp.element();
	nZoneIndex = vp.activeZoneIndex();
}

//shopdrawspace
else if (sSpace == sShopdrawSpace ) {
	
	if (_Entity.length()==0)
	{
		eraseInstance();
		return; // _Entity array has some elements
	}
	
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	
	if (!sv.bIsValid()) 
		return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) 
		return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Element()))
		{
			el=(Element) ent;
			break;
		}
	}
}
sSpace.setReadOnly(1);
if( !el.bIsValid() )return;

_Pt0=ps2ms.ptOrg();
setMarbleDiameter(U(5, 0.2));

//Collecting all wall elements from selected element's group
Group gr=el.elementGroup(); // default constructor, or empty groupname means complete drawing
Group gpAll (gr.namePart(0)+"\\"+gr.namePart(1));
int bAlsoInSubGroups = TRUE;
Entity arEnt[] = gpAll.collectEntities( bAlsoInSubGroups, ElementWall(), _kModelSpace);

//Validating elements
Element arEl[0];
for (int i=0; i<arEnt.length(); i++)
{
	ElementWall el=(ElementWall) arEnt[i];
	if (el.bIsValid())
	{
		arEl.append(el);
	}
}

for(int e=0;e<arEl.length();e++)
{
	Element el=arEl[e];

	// Check if wall is load bearing 
	ElementWallSF elSF= (ElementWallSF) el;
	if( !elSF.loadBearing())
		continue;
	
	PLine plEl=el.plOutlineWall();
	plEl.transformBy(ms2ps);
	PlaneProfile ppWall(plEl);	

	//Displaying walls
	//Setting display props. for wall display
	Display dpW(nWColor);
	String sWHatch;
	if(nWDp==0)// Solid hatch
	{
		sWHatch="SOLID";
	}
	else if(nWDp==1)// Net hatch
	{
		sWHatch="NET";
	}
	
	if(nWDp!=2)
	{
		//Display wall PLine
		dpW.draw(plEl);
		//Display hatch
		Hatch htWall(sWHatch, dWlHatchPtnr/4);
		htWall.setAngle(45);
		dpW.draw(ppWall,htWall);
	}

	if(!nBmDp)// Display is required
	{
		//Displaying STRUCTURAL WOOD BEAMS (headers on load bearing walls)
		Display dpBm(nBmColor);
		Plane plW(Point3d (0,0,0), _ZW);
		Beam arBm[]=el.beam();
		for(int b=0;b<arBm.length();b++)
		{
			Beam bm=	arBm[b];
			//Getting header types
			if(bm.type()==18)//Header
			{
				Body bdBm=bm.envelopeBody();
				PlaneProfile ppBm=bdBm.shadowProfile(plW);
				ppBm.transformBy(ms2ps);
				String sBmHatch="LINE";
				Hatch htBm(sBmHatch, dBmHatchPtnr*10);
				htBm.setAngle(-46);
				dpBm.draw(ppBm,htBm);
				dpBm.draw(ppBm);
			}
		}
	}
}

return;


#End
#BeginThumbnail
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
>HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`__9
`

#End
