#Version 8
#BeginDescription
#Versions:
Version 1.5 08.01.2024 HSB-21034 bugfix compile error

Version 1.4 16.06.2023 HSB-18065: Include "Lowfield-SpaceStudAssembly" TSLs 
Version 1.3 22.06.2022 HSB-15357: Include "GC-SpaceStudAssembly" TSLs










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
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
* #Versions:
// 1.5 08.01.2024 HSB-21034 bugfix compile error , Author Thorsten Huck
// 1.4 16.06.2023 HSB-18065: Include "Lowfield-SpaceStudAssembly" TSLs Author: Marsel Nakuci
// 1.3 22.06.2022 HSB-15357: Include "GC-SpaceStudAssembly" TSLs Author: Marsel Nakuci
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 28.08.2011
* version 1.0: Release Version
*
* date: 21.09.2011
* version 1.1: Add running dimension on top
*
* date: 21.09.2011
* version 1.2: Add the display of the metalparts
*/


PropString sDimStyle(0,_DimStyles, "Dim Style PosNom");
PropDouble dTextH(0, U(40), "Text Height");


PropString sDimStyleDims(1,_DimStyles, "Dim Style Dimensions");
PropDouble dOffset(1,U(100), "Offset dim Lines");

//PropString propHeader(1,"Text can be changed in the OPM","Table header");
PropInt nColor(0,3,"Color");

if (_bOnInsert)
{
	showDialog();
	//int nSpace = sArSpace.find(sSpace);
	
	_Pt0=getPoint(T("Pick a point"));
	//Shopdraw Space
	Entity ent = getShopDrawView(T("|Select the view entity from which the information is taken|")); // select ShopDrawView
	_Entity.append(ent);

	return;
}//end bOnInsert

setMarbleDiameter(U(5, 0.2));

Display dp(nColor); // use color of entity for frame
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight
dp.textHeight(dTextH);

Entity entAll[0];	

//coordSys
CoordSys ms2ps, ps2ms;	

	
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
	if (ent.bIsValid())
	{
		_Entity.append(ent);
	}
}

if( _Entity.length()==0 )return;

String sPosnum[0];

CoordSys cs;

TslInst tslNail[0];

for (int i=0; i<_Entity.length(); i++)
{
	TslInst tsl=(TslInst) _Entity[i];
	if (tsl.bIsValid() && (tsl.scriptName()=="hsb_SpaceStudAssembly" 
	|| tsl.scriptName()=="GC-SpaceStudAssembly"
	|| tsl.scriptName()=="Lowfield-SpaceStudAssembly"))
	{
		sPosnum.append(tsl.posnum());
		cs=tsl.coordSys();
		Entity entThisTSL[]=tsl.entity();
		for (int j=0; j<entThisTSL.length(); j++)
		{
			TslInst tslPlate=(TslInst) entThisTSL[j];
			if (tslPlate.bIsValid())
			{
				if (tslPlate.scriptName()=="hsb_NailPlate")
				{
					tslNail.append(tslPlate);
				}
				//reportMessage("\nPlate"+tslPlate.posnum());
			}
		}
		Beam bmThisTSL[]=tsl.beam();
		for (int j=0; j<bmThisTSL.length(); j++)
		{
			Beam bm=(Beam)bmThisTSL[j];
			if (bm.bIsValid())
			{
				_Beam.append(bm);
				reportMessage("\nBeam"+bm.posnum());
			}
		}
	}
}

for (int i=0; i<tslNail.length(); i++)
{
	Body bd=tslNail[i].realBody();
	bd.transformBy(ms2ps);
	dp.draw(bd);
}



for (int i=0; i<sPosnum.length(); i++)
{
	dp.draw(sPosnum[i],_Pt0,_XW,_YW,0,0);
}



Point3d ptAllVertex[0];
for (int i=0; i<_Beam.length(); i++)
{
	ptAllVertex.append(_Beam[i].realBody().allVertices());
}

//ptAllVertex=ms2ps.transformPoints(ptAllVertex);

Point3d ptCenterPanel;
ptCenterPanel.setToAverage(ptAllVertex);

Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

//Collect the extreme point to dimension top, bottom, left and right
Point3d ptMostLeft=ptCenterPanel;
Point3d ptMostRight=ptCenterPanel;
Point3d ptMostUp=ptCenterPanel;
Point3d ptMostDown=ptCenterPanel;

for (int i=0; i<ptAllVertex.length(); i++)
{
	Point3d pt=ptAllVertex[i];
	if (vz.dotProduct(ptMostLeft-pt)>0)
		ptMostLeft=pt;
	if (vz.dotProduct(ptMostRight-pt)<0)
		ptMostRight=pt;
	if (vx.dotProduct(ptMostUp-pt)<0)
		ptMostUp=pt;
	if (vx.dotProduct(ptMostDown-pt)>0)
		ptMostDown=pt;
}




Line lnBase(ptMostDown, vz);
ptMostLeft=lnBase.closestPointTo(ptMostLeft);
ptMostRight=lnBase.closestPointTo(ptMostRight);

Line lnTop(ptMostUp, vz);
ptAllVertex=lnTop.projectPoints(ptAllVertex);
ptAllVertex=lnTop.orderPoints(ptAllVertex);

Point3d ptDimLeft[0];
Line lnLeft(ptMostLeft,vx);
ptMostDown=lnLeft.closestPointTo(ptMostDown);
ptMostUp=lnLeft.closestPointTo(ptMostUp);
ptDimLeft.append(ptMostDown);
ptDimLeft.append(ptMostUp);

Point3d ptDimBottom[0];
ptDimBottom.append(ptMostLeft);
ptDimBottom.append(ptMostRight);

Point3d ptDimTop[0];
ptDimTop.append(ptMostLeft);
ptDimTop.append(ptMostRight);

Display dpDim(-1);
dpDim.dimStyle(sDimStyleDims, ps2ms.scale());

DimLine dmlLeft (ptMostLeft-vz*dOffset, vx, -vz);
Dim dmLeft (dmlLeft ,ptDimLeft,"<>","<>",_kDimDelta);
dmLeft.transformBy(ms2ps);
dpDim.draw(dmLeft);

//DimLine dmlBotton (ptMostLeft-vx*dOffset, vz, vx);
DimLine dmlBotton (ptMostLeft-vx*dOffset, vz, vx);
Dim dmBottom (dmlBotton, ptDimBottom,"<>","<>",_kDimDelta);
dmBottom.setDeltaOnTop(false);
dmBottom.transformBy(ms2ps);
dpDim.draw(dmBottom);

//DimLine dmlTop (ptMostUp+vx*dOffset, vz, vx);
DimLine dmlTop (ptMostUp+vx*dOffset, vz, vx);
Dim dmTop (dmlTop, ptAllVertex,"<>","<>",_kDimDelta);
dmTop.transformBy(ms2ps);
dpDim.draw(dmTop);






#End
#BeginThumbnail






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21034 bugfix compile error" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/8/2024 10:33:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18065: Include &quot;Lowfield-SpaceStudAssembly&quot; TSLs" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/16/2023 12:11:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15357: Include &quot;GC-SpaceStudAssembly&quot; TSLs" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/22/2022 9:44:01 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End