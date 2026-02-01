#Version 8
#BeginDescription
Creates a view of a TF wall in layout and displays according to he following symbols and UCS of the viewport:  'O'  (letter O): Shows o, '\\' (double backslash): Shows slash, '/' (frontslash): Shows frontslash, 'X': Shows X, 'N': No display, 'S': Shows outline, '-': Shows line through timber

Last modified by: Alberto Jena (aj@hsb-cad.com)
18.11.2015  -  version 2.4








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 27.05.2008
* version 1.0: Release Version
*
* date: 27.10.2010
* version 1.1: Release Version
*
* date: 18.11.2010
* version 1.2: Project all the points to the origin of the viewport or place holder
*
* date: 13.04.2011
* version 1.3: Add some displays for the space stud
*
* date: 07.06.2012
* version 2.0: Made properties for each beam type and its display and corrected Viewport shadowprofile plane
*
* date: 07.02.2013
* version 2.2: Added _kBlocking to array
*/

/*
String arDir[]= {"Horizontal", "Vertical"};
PropString strDir(0, arDir, "Direction");
int nDir = arDir.find(strDir,0);
*/

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(1, sArSpace, T("|Drawing space|"));

PropString sbmName00(3, "N", T("Jack Over Opening"));
PropString sbmName01(4, "N", T("Jack Under Opening"));
PropString sbmName02(5, "X", T("Cripple Stud"));
PropString sbmName03(6, "-", T("Transom"));
PropString sbmName04(7, "X", T("King Stud"));
PropString sbmName05(8, "N", T("Sill"));
PropString sbmName06(9, "S", T("Angled TopPlate Left"));
PropString sbmName07(10, "S", T("Angled TopPlate Right"));
PropString sbmName08(11, "S", T("TopPlate"));
PropString sbmName09(12, "S", T("Bottom Plate"));
PropString sbmName10(13, "N", T("Blocking"));
PropString sbmName11(15, "X", T("Supporting Beam"));
PropString sbmName12(16, "X", T("Stud"));
PropString sbmName13(17, "X", T("Stud Left"));
PropString sbmName14(18, "X", T("Stud Right"));
PropString sbmName15(19, "N", T("Header"));
PropString sbmName16(20, "N", T("Brace"));
PropString sbmName17(21, "N", T("Locating Plate"));
PropString sbmName18(22, "N", T("Packer"));
PropString sbmName19(23, "S", T("SolePlate"));
PropString sbmName20(24, "S", T("HeadBinder/Very Top Plate"));
PropString sbmName21(25, "S", T("Vent"));
PropString sbmName22(26, "S", T("Angle Fillet"));
PropString sbmName23(27, "N", T("Beam"));

int nBmType[0];
char arCross[0];

// symbols :  '/'  
//                   'O'   : letter O (not number zero)
//                   '\\'     need to have a double backslash
//                   'X'
//                   ' '      need blank (not empty otherwise TSL doesn't work)
//			   'S' 	Show only the Shadow on that with
//			   '-' 	Shows line through timber

//BEAM TYPES
nBmType.append(_kSFJackOverOpening);
nBmType.append(_kSFJackUnderOpening);
nBmType.append(_kCrippleStud);
nBmType.append(_kSFTransom);
nBmType.append(_kKingStud);
nBmType.append(_kSill);
nBmType.append(_kSFAngledTPLeft);
nBmType.append(_kSFAngledTPRight);
nBmType.append(_kSFTopPlate);
nBmType.append(_kSFBottomPlate);
nBmType.append(_kSFBlocking);
nBmType.append(_kSFSupportingBeam);
nBmType.append(_kStud);
nBmType.append(_kSFStudLeft);
nBmType.append(_kSFStudRight);
nBmType.append(_kHeader);
nBmType.append(_kBrace);
nBmType.append(_kLocatingPlate);
nBmType.append(_kSFPacker);
nBmType.append(_kSFSolePlate);
nBmType.append(_kSFVeryTopPlate);
nBmType.append(_kSFVent);
nBmType.append(_kBlocking);
nBmType.append(_kTRWedge);
nBmType.append(_kBeam);

arCross.setLength(0);
arCross.append(sbmName00.getAt(0));
arCross.append(sbmName01.getAt(0));
arCross.append(sbmName02.getAt(0));
arCross.append(sbmName03.getAt(0));
arCross.append(sbmName04.getAt(0));
arCross.append(sbmName05.getAt(0));
arCross.append(sbmName06.getAt(0));
arCross.append(sbmName07.getAt(0));
arCross.append(sbmName08.getAt(0));
arCross.append(sbmName09.getAt(0));
arCross.append(sbmName10.getAt(0));
arCross.append(sbmName11.getAt(0));
arCross.append(sbmName12.getAt(0));
arCross.append(sbmName13.getAt(0));
arCross.append(sbmName14.getAt(0));
arCross.append(sbmName15.getAt(0));
arCross.append(sbmName16.getAt(0));
arCross.append(sbmName17.getAt(0));
arCross.append(sbmName18.getAt(0));
arCross.append(sbmName19.getAt(0));
arCross.append(sbmName20.getAt(0));
arCross.append(sbmName21.getAt(0));
arCross.append(sbmName10.getAt(0));
arCross.append(sbmName22.getAt(0));
arCross.append(sbmName23.getAt(0));

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
	
/////////////////////////

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

//Plane pln (csVp.ptOrg(), csVp.vecZ());
Plane pln (csVp.ptOrg(), _ZW);
Vector3d vz=_ZW;
csVp.ptOrg().vis();
Vector3d test=csVp.vecZ();
test.normalize();
test.vis(csVp.ptOrg());

for (int i=0; i<arBeam.length(); i++) 
{
	// loop over list items
	int bOK = false;
	Beam bm = arBeam[i];
	
	int nLocation = nBmType.find(bm.type(), -1);	

	char Cross;
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
		Plcir.projectPointsToPlane(pln, vz);

		Body bdBeam = bm.realBody();
		bdBeam.transformBy(csVp);
		PlaneProfile ppBm=bdBeam.shadowProfile(pln);
		dp.draw(ppBm);

   	
    		if (Cross=='X') {
			dp.draw(L1);
			dp.draw(L2);
    		}	   	

    		if (Cross=='-') {
			dp.draw(L3);
    		}	   	

   	
    		if (Cross=='/') {
			dp.draw(L1);
    		}	   	

   	
    		if (Cross=='\\') {
			dp.draw(L2);
    		}	   	


    		if (Cross=='O') {
			Plcir.transformBy(csVp);
			dp.draw(Plcir);
    		}	   	
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