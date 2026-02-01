#Version 8
#BeginDescription
Creates dimensions in the wall elevation layout for the studs, sheeting, openings, blockings and show some wall information like nailing offset, frame weight and wall description.
1.75 02/08/2024 Support dimStyle presision on diagonal text. AJ

Modified by: Alberto Jena
Date: 13.07.2021 - version 1.74


1.76 22/08/2024 Small improvements. AJ
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 76
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
* --------------------------------
*
* Created by: Roberto Hallo, rh@hsb-cad.com, Date: 2007/Nov/30, Version:1.0
* Author: Roberto Hallo, rh@hsb-cad.com, Date: 2007/Dic/04, Version:1.1
* Author: Roberto Hallo, rh@hsb-cad.com, Date: 2007/Dic/10, Version:1.2
* Author: Roberto Hallo, rh@hsb-cad.com, Date: 2007/Dic/11, Version:1.3
* Author: Roberto Hallo, rh@hsb-cad.com, Date: 2007/Dic/19, Version:1.4
* Author: Roberto Hallo, rh@hsb-cad.com, Date: 2007/Dic/20, Version:1.5
* Author: Alberto Jena, aj@hsb-cad.com, Date: 2008/June/27, Version:1.6
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 17.09.2008
* version 1.7: Add the Gap around the openings when they have.
*
* date: 12.11.2008
* version 1.8: The origin point of the dimension now is base on the origin of the beams, not the origin of the element.
*
* date: 12.08.2009
* version 1.9: Bugfix finding the origin of the element.
*
* date: 18.08.2009
* version 1.10: Change to Read the information to export the nailing spacing
*
* date: 21.08.2009
* version 1.11: Big Changes on Multiple Things and a lot of properties added
*
* date: 27.08.2009
* version 1.12: Finish and Release this new Update
*
* date: 27.08.2009
* version 1.13: Add Property Y/N Dim Blocking, new offset for text and fix origin point of nailing.
*
* date: 06.10.2009
* version 1.14: Fix the Location of the text on top.
*
* date: 09.10.2009
* version 1.15: Change the Name from "A4 Layout" to "hsb_A4 Layout".
*
* date: 15.10.2009
* version 1.16: 	Bugfix with the dimension of Locating Plate.
*					Add dimension of the panels on the lest when they are not square.
*					Add Code to include beams that are flipt 90 degrees.
*
* date: 16.10.2009
* version 1.17: 	Relocate the right dimension when the panel have an angle top plate right.
*
* date: 28.10.2009
* version 1.18: 	Fix the display of the list.
*
* date: 11.11.2009
* version 1.19: 	Fix the dimensions when the X of the panel is reverse on the viewport.
*
* date: 19.01.2010
* version 1.20: 	Add Options to remove the text on top of the panel
*
* date: 26.01.2010
* version 1.21:		Fix the diagonal of the element because is was showing a excluded beam
*
* date: 09.02.2010
* version 1.22:		Add the Length of the Header, add the option to show the beam Name instead of the header description to use it with steel headers
*
* date: 02.03.2010
* version 1.23:		Add the option to include or exclude rotated beams
*
* date: 29.03.2010
* version 1.24:		Add the Option to show the Nail Type
*
* date: 29.07.2010
* version 1.25:		Support Imperial
*
* date: 25.08.2010
* version 1.26:		Add a property to show the angular dimensions or not
*
* date: 14.09.2010
* version 1.27:		Add a property to show length of the Blocking Pieces
* 
* date: 08.10.2010
* version 1.28:		Distances from element's origin to beams are now displayed in mm or imperial (1'- 2 1/2") according to drawing units
*
* date: 19.10.2010
* version 1.29:		Adjust the TSL for Deeside requirements
*
* date: 27.10.2010
* version 1.30:		Add the option to inset the TSL in a shopdraw layout
*
* date: 29.10.2010
* version 1.31:		Add hatch option for flat studs
*
* date: 08.11.2010
* version 1.32:		Add and Extra Dim Style for Stud Dimension
*
* date: 09.11.2010
* version 1.33:		Add Flat Stud description property
*
* date: 15.11.2010
* version 1.34:		Add Color for the dimensions
*
* date: 15.11.2010
* version 1.35:		Set the horizontal openign dimension to be 200mm below header
*					Set the header height in the middle of the opening
*
* date: 09.02.2011
* version 1.36:		Add Jacks Over Opening to the Dimensions below panel
*					Remove the angular dimension when there is no angle plates present
*					Add a property to show/hide the frame weight
*
* date: 15.02.2011
* version 1.37:		Bugfix with dimension of jacks
*
* date: 15.02.2011
* version 1.38:		Bugfix with dimension of jacks
*
* date: 16.02.2011
* version 1.39:		Add the code of the jacks above opening
*					Fix Header size when rip headers are used
*
* version 1.40:		Support HeadBinder Dimension
*
* version 1.41:		Bugfix with some infinite loop
*
* date: 20.07.2011
* version 1.42:		Show diagonal including the headbinder if the property is included in the dimension
*					Add a zone filter for the sheeting
*
* date: 28.07.2011
* version 1.43:		Fix issue dimensioning angle plates when the wall is mirror.
*
* date: 12.08.2011
* version 1.44:		Add another option to dimension the openings on the right side of the panel.
*
* date: 16.02.2012
* version 1.45:		Add property for the offset of the running dimensions
*
* date: 11.04.2012
* version 1.46:		Increased body of header check in vz
*
* date: 24.04.2012
* version 1.47:		Add the option to display the opening size
*
* date: 10.05.2012
* version 1.48:		Added option to display dimenion lines for the running dimensions and created offset and switch for Stud References
*
* date: 22.06.2012
* version 1.49:	   Added option to put length on beam
*
* date: 22.06.2012
* version 1.50:	  Add Property to show the length of the jacks
*
* date: 03.09.2012
* version 1.51:	  Reduce the tolerance for the bottom dimensions
*
* date: 27.09.2012
* version 1.52:	  Added property to show head height, sill height, both or none
*
* date: 11.10.2012
* version 1.53:	  Added property to show opening description
*
* date: 15.11.2012
* version 1.54:	 Fixed angled dimensions and added property to show angular studs as text
*
* date: 26.11.2012
* version 1.55:	 Add display of a property set for the description of the opening.
*
* date: 19.02.2013
* version 1.56:	 Add extra property to exclude beams by code.
*
* v1.57: 24.mar.2013: David Rueda (dr@hsb-cad.com)
	- Option to show vertical dimline names: "Blocking", "Opening", "Wall height" (No/Yes)
	- Option to move vertical blocking dimline to left/right side of element 
	- Offset from element for vertical blocking dimline (when at left side)
	- Option to define dimpoints for blocking dimension line (bottom, center or top of blocking)
*
* date: 16.01.2015
* version 1.59:	 Streamlined vertical beams to those belonging to zone 0 only. 
* Fixed disparity between units in list of running dimensions and running dimension line.
* Removed duplicates in list of running dimensions
*
* date: 08.08.2018
* version 1.68: Change format of the diagonal to support inches.
*/

String sArYesNo[] = {T("No"), T("Yes")};
String sLeftRight[] = {T("Left"), T("Right")};
String sBottomCenterTop[] = {T("Bottom"), T("Center"), T("Top")};

String strStartEnd[]={T("Start"),T("End"), T("Center"), T("None")};

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(22,sArSpace,T("|Drawing space|"));


PropString strShowDim (0,strStartEnd,T("Show Left Dimension List"),3);
int nStartEnd=strStartEnd.find(strShowDim);

PropDouble dTextY (0, U(5, 0.2), T("List Spacing"));
PropDouble dDistList (1, U(300, 12), T("X Offset for List"));
PropDouble dDistListY (2, U(0, 0), T("Y Offset for List"));

PropInt nColumn (0, 20, T("Number of Items per column"));

PropString sDimLayout(1,_DimStyles,T("Dim Style"));

PropString sDimStyleStuds(25,_DimStyles,T("Dim Style Studs Only"));

PropDouble dFactor (3, 450, T("Timber density (kg/m3)"));

PropString sYesNoHeadBinder (28, sArYesNo,T("Dimensions Include Headbinder"),0);
sYesNoHeadBinder.setDescription("Allow you to show or hide the length og the blocking pieces");
int nYesNoHeadBinder = sArYesNo.find(sYesNoHeadBinder, 0);

String strStartEndBot []={T("Start"),T("End"), T("Center"), T("None")};
PropString strShowDimBot (2,strStartEndBot,T("Show Bottom Dimension"));
int nStartEndBot=strStartEndBot.find(strShowDimBot);

String strLeftRightBot []={T("Left Side"),T("Right Side")};
PropString strLeftRightDimBot (42,strLeftRightBot,T("Bottom Dimension From"));
int nLeftRightBot=strLeftRightBot.find(strLeftRightDimBot);

String sArMode[] = {T("Line and Text"), T("Dimension Line - Running"), T("Dimension Line - Delta")};
PropString sMode(31, sArMode, T("Show as"),0);
int nRunningMode= sArMode.find(sMode, 0);

String sDeltaOnTopModes[] = {T("Top"), T("Bottom")};
PropString sDeltaOnTop(43, sDeltaOnTopModes, T("Text location"),0);
int nDeltaOnTop= sDeltaOnTopModes.find(sDeltaOnTop, 0);

String arType[]={"Parallel","Perpendicular"};
int arIType[]={_kDimPar,_kDimPerp};
PropString strType(32,arType,"Running Dimension Orientation",0);
int nRunningType = arIType[arType.find(strType,0)];

PropString sFilterBMC(15,"",T("Include Beam With BeamCode"));
sFilterBMC.setDescription(T("Set the code of the extra beams that you want to show int the beam dimension at the bottom of the panel. To add more than 1 use ';' after each code"));

PropString sFilterExcludeBMC(38,"",T("Exclude Beam With BeamCode"));
sFilterExcludeBMC.setDescription(T("Set the code of the extra beams that you want to show int the beam dimension at the bottom of the panel. To add more than 1 use ';' after each code"));

PropString strYesNoStuds (18,sArYesNo,T("Exclude Rotated Studs"),0);
int nYesNoStuds=sArYesNo.find(strYesNoStuds);

PropString sYesNoVerticalDimName (40,sArYesNo,T("Show Vertical Dim Names"),0);// DR 22.mar.2013 START 001
int  nYesNoVerticalDimName= sArYesNo.find(sYesNoVerticalDimName, 0);// DR 22.mar.2013 END 001

String strYesNoDiag[]={T("Yes"),T("No"), T("As Text on Top")};
PropString strYesNoDim (3,strYesNoDiag,T("Show Panel Diagonal Dimension"),1);
int nYesNoDiagonal=strYesNoDiag.find(strYesNoDim );

PropString strYesNoSheet (4,sArYesNo,T("Show Diagonal for Sheets"), 0);
int nYesNoSheet=sArYesNo.find(strYesNoSheet );
PropInt nColorDiag(1,5,T("Sheet Color Diagonal"));

PropString strYesNoSheetVis (5,sArYesNo,T("Show Sheet Outline"), 0);
int nYesNoSheetVis=sArYesNo.find(strYesNoSheetVis);
PropInt nColorOutline(2,5,T("Sheet Color Outline")); 

String sValidZones[]={"All","1","2","3","4","5","6","7","8","9","10"};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString sZones (29, sValidZones, T("Sheet Zone"), 0);

int nLocZone=sValidZones.find(sZones, 0);
int nZone=99;
if (nLocZone>0)
{
	nZone=nRealZones[nLocZone-1];
}

PropString sFilterBC(6,"",T("Filter sheets by material"));

PropDouble dOffsetFromEl (4, U(150, 8), T("Offset From Element"));
PropDouble dOffsetBetweenLn (5, U(150, 8), T("Offset Between Text Lines"));
PropDouble dOffsetBottomDim (6, U(0, 0), T("Offset Bottom Dimension/Text >From PickPoint"));
PropDouble dOffsetTopDim (10, U(150, 6), T("Offset Top Text From PickPoint in VP Units"));

PropDouble dOffsetRunningDim (11, U(100, 6), T("Offset Running Dimension"));
double dOffsetRunDim =dOffsetRunningDim; 
PropDouble dOffsetStudReferences (13, U(60, 6), T("Offset Stud References"));
PropDouble dLengthBeamLine(12, U(250, 6), T("Length Running Dimension Lines"));

PropDouble dOffsetHorOpDim (7, U(0, 0), T("Offset Horizontal Opening Dim"));
dOffsetHorOpDim.setDescription(T("This Offset apply when the dim line is in the middle of the opening"));

String strHeaderDesc[]={T("From Details"),T("From Beam Name"), T("From Beam Size"),T("No"),T("Header detail description")};
PropString strYesNoHeader (12,strHeaderDesc,T("Show Header Description"), 2);
int nHeaderDesc=strHeaderDesc.find(strYesNoHeader);
PropDouble dOffsetHeader (8, U(50, 2), T("Offset Header Description"));

String sDimOpeningLocVer[] = {T("Right Side"), T("Center of Opening"), T("Left Side"), T("None")};//T("Bellow Element"), T("Bellow and Center")
PropString strDimOpLocVer (7,sDimOpeningLocVer,T("Vertical Opening Dimension "),1);
int nDimOpeningLocVer = sDimOpeningLocVer.find(strDimOpLocVer, 0);

String sDimOpeningLocHor[] = {T("Center of Opening"), T("Below Element"), T("Both"), T("None")};
PropString strDimOpLocHor (8,sDimOpeningLocHor,T("Horizontal Opening Dimension "),1);
int nDimOpeningLocHor = sDimOpeningLocHor.find(strDimOpLocHor, 0);

String sOpeningDescription[] = {T("None"), T("hsbCAD"), T("AutoCAD"), T("Property Set")};
PropString sYesNoWindowDescription (36, sOpeningDescription, T("Show Window/Door Description"), 0);
int nYesNoWindowDescription = sOpeningDescription.find(sYesNoWindowDescription , 0);

PropString sPropSetName (37, "", "Property set name");

PropString sYesNoWindowSize (30, sArYesNo, T("Show Window/Door size"), 1);
int nYesNoWindowSize = sArYesNo.find(sYesNoWindowSize, 0);

PropString strDimOpCummulative (16,sArYesNo,T("Show Cummulative Opening Dimension"), 0);
int nDimOpCummulative = sArYesNo.find(strDimOpCummulative, 0);

String sShowWindowHeights[] = {T("None"), T("Head Height"), T("Sill Height"), T("Both")};//T("Bellow Element"), T("Bellow and Center")
PropString strShowWindowHeights (35,sShowWindowHeights,T("Show Window Head/Sill Heights "),1);
int nShowWindowHeights= sShowWindowHeights.find(strShowWindowHeights , 0);

PropString sYesNoBlocking (14,sArYesNo,T("Show Blocking Dim"),1);
int  nYesNoBlocking= sArYesNo.find(sYesNoBlocking, 0);

PropString sBlockingDimToBottomCenterTop(41,sBottomCenterTop,T("Dimension blocking to"),2); // DR 22.mar.2013 
int  nBlockingDimToBottomCenterTop= sBottomCenterTop.find(sBlockingDimToBottomCenterTop, 2); // DR 22.mar.2013 

PropString sBlockingDimLineAlignment(39,sLeftRight,T("Blocking Dimline alignment"),1);// DR 22.mar.2013 
int  nBlockingDimLineAlignment= sLeftRight.find(sBlockingDimLineAlignment,1);// DR 22.mar.2013 

PropDouble dBlockingDimOffsetFromEl (14, U(100, 4), T("Blocking Dim Offset From Element (left side only)")); // DR 22.mar.2013 
dBlockingDimOffsetFromEl.setDescription(T("|Only appliable when is on left side of element|"));

String sAngleStudDim[]={T("None"),T("Dimension"),T("Text")};
PropString sYesNoBm (9,sAngleStudDim,T("Show Angle Stud Dim"),1);
int nYesNoBm = sAngleStudDim.find(sYesNoBm, 1);

String sShortLong[] = {T("Long Side"), T("Short Side")};
PropString strShortLong (10,sShortLong,T("Dimension From"),0);
int bLongShort = sShortLong.find(strShortLong, 0);

PropDouble dDimOffBM(9,U(25, 2),T("Offset Stud Dim Line"));

PropString sYesNoAngle (11,sArYesNo,T("Dim Angle Top Plate"),0);
int nYesNoAngle = sArYesNo.find(sYesNoAngle, 0);

PropString sYesNoNailing (13,sArYesNo,T("Show Nailing Information"),0);
int nYesNoNailing = sArYesNo.find(sYesNoNailing, 0);

PropString sYesNoNailingType (19,sArYesNo,T("Show Nailing Type"),0);
int nYesNoNailingType = sArYesNo.find(sYesNoNailingType, 0);

PropString sYesNoWallDetails (17,sArYesNo,T("Show Wall Information"),1);
int nYesNoWallDetails = sArYesNo.find(sYesNoWallDetails, 0);

PropString sYesNoWallWeight (27,sArYesNo,T("Show Frame Weight"),1);
int nYesNoWallWeight = sArYesNo.find(sYesNoWallWeight, 0);

PropString sYesNoAngularDim (20, sArYesNo,T("Show Angular Dimensions"),0);
sYesNoAngularDim.setDescription("Allow you to show or hide any angular dimension that is coming from the calculation of the shape of the panel base on the beams");
int nYesNoAngularDim = sArYesNo.find(sYesNoAngularDim, 0);

PropString sYesNoBlockLength (21, sArYesNo,T("Show Blocking Length"),0);
sYesNoBlockLength.setDescription("Allow you to show or hide the length og the blocking pieces");
int nYesNoBlockLength = sArYesNo.find(sYesNoBlockLength, 0);

PropString sYesNoJaks (34,sArYesNo,T("Show Jacks Length"),1);
int  nYesNoJacks= sArYesNo.find(sYesNoJaks, 0);

PropString sYesNoHatchFlatBeams (23, sArYesNo,T("Hatch Flat Studs"),0);
sYesNoHatchFlatBeams.setDescription("Allow you to add a hatch pattern to the flat studs");
int nYesNoHatchFlatBeams = sArYesNo.find(sYesNoHatchFlatBeams, 0);

PropString sYesNoStudReferences (33, sArYesNo,T("Show Stud References"),1);
sYesNoStudReferences .setDescription("Shows 'S', 'J' etc. under each stud");
int nYesNoStudReferences = sArYesNo.find(sYesNoStudReferences, 0);

PropString sHatchPattern(24, _HatchPatterns, "Hatch pattern");

PropString sYesNoFlatBeamDescription (26, sArYesNo,T("Show Flat Studs Description"),0);
sYesNoFlatBeamDescription.setDescription("Allow to see the description of the flat beams");
int nYesNoFlatBeamDesc = sArYesNo.find(sYesNoFlatBeamDescription, 0);

PropInt nDimColor(3,1,T("Color"));
if (nDimColor < 0 || nDimColor > 255) nDimColor.set(0);

if(_bOnInsert)
{
	showDialog();
	//int nSpace = sArSpace.find(sSpace);
	
	_Pt0=getPoint(T("Pick a point where the bottom horizontal dim will reference to"));
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

	//_Viewport.append(getViewport(T("Select a viewport")));
	return;

}//end bOnInsert

setMarbleDiameter(U(1));

int bInches = false;
if (U(25,1)==1)
{ 
	bInches = true;
}

int nPrecision=0; 
if (bInches) nPrecision = 2;

// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
if (_Viewport.length()>0)
	sSpace.set(sPaperSpace);
else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
	sSpace.set(sShopdrawSpace);

sSpace.setReadOnly(TRUE);

int nBmTypeToAvoid[0];
//nBmTypeToAvoid.append(_kLocatingPlate);
nBmTypeToAvoid.append(_kTypeNotSet);
nBmTypeToAvoid.append(_kSFStudRight);
nBmTypeToAvoid.append(_kSFStudLeft);	
nBmTypeToAvoid.append(_kSFSupportingBeam);
nBmTypeToAvoid.append(_kKingStud);
nBmTypeToAvoid.append(_kCrippleStud);

int nBmTypeValidForConvex[0];
nBmTypeValidForConvex.append(_kSFStudRight);
nBmTypeValidForConvex.append(_kSFStudLeft);	
nBmTypeValidForConvex.append(_kSFAngledTPLeft);
nBmTypeValidForConvex.append(_kSFAngledTPRight);	
nBmTypeValidForConvex.append(_kKingStud);
nBmTypeValidForConvex.append(_kSFTopPlate);
nBmTypeValidForConvex.append(_kSFBottomPlate);

//if (nYesNoHeadBinder)
//{ 
//	nBmTypeValidForConvex.append(_kSFVeryTopPlate);
//}


Element el;
int nZoneIndex;
Entity entAll[0];	

// coordSys
CoordSys ms2ps, ps2ms;	

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost
	
	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;
	
	ms2ps = vp.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	el = vp.element();
	nZoneIndex = vp.activeZoneIndex();
}

//shopdrawspace	
if (sSpace == sShopdrawSpace ) {
	
	if (_Entity.length()==0) return; // _Entity array has some elements
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	if (!sv.bIsValid()) return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) return; // no viewData found
	
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
		}
	}
}

//Viewport vp = _Viewport[0];
//CoordSys ms2ps = vp.coordSys();
//CoordSys ps2ms = ms2ps; ps2ms.invert();

//Element el = vp.element();
if( !el.bIsValid() )return;

ElementWallSF elSF= (ElementWallSF) el;

if (!elSF.bIsValid())return;

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

vx.normalize();
vy.normalize();
vz.normalize();

Point3d ptOrgEl=csEl.ptOrg();

//CoordSys coordvp = vp.coordSys();
Vector3d VecX = ms2ps.vecX();
Vector3d VecY = ms2ps.vecY();
Vector3d VecZ = ms2ps.vecZ();

double dBmWidth=el.dBeamWidth();

//Check if the panel haven been reverse on the viewport
int nReverseX=FALSE;
Vector3d vAuxX=vx;
vAuxX.transformBy(ms2ps);
if (vAuxX.dotProduct(_XW)<0)
{
	nReverseX=TRUE;
	vx=-vx;
	vz=-vz;
}

Beam bmAll [] = el.beam();
if (bmAll.length()<1)
	return;
		

//Beam bmAux[] = vy.filterBeamsParallel(bmAll);

GenBeam genBeamsInZone0[]=el.genBeam(0);
Beam beamsInZone0[0];
for(int x=0;x<genBeamsInZone0.length();x++)
{
	Beam bm=(Beam)genBeamsInZone0[x];
	if(bm.bIsValid())
	{
		beamsInZone0.append(bm);
	}
}

bmAll.setLength(0);
bmAll = beamsInZone0;
if (bmAll.length()<1)
	return;

Beam bmHor[] = vy.filterBeamsPerpendicularSort(bmAll);
Beam bmVer[] = vx.filterBeamsPerpendicularSort(beamsInZone0);



// filter beams with code//////////////////////
String sFBMC = sFilterBMC + ";";
String arBMCode[0];
int nIndexBMC = 0; 
int sIndexBMC = 0;

while(sIndexBMC < sFBMC.length()-1)
{
	String sTokenBMC = sFBMC.token(nIndexBMC);
	nIndexBMC++;
	if(sTokenBMC.length()==0)
	{
		sIndexBMC++;
		continue;
	}
	sIndexBMC = sFBMC.find(sTokenBMC,0);
	sTokenBMC.trimLeft();
	sTokenBMC.trimRight();
	sTokenBMC.makeUpper();
	arBMCode.append(sTokenBMC);
}
////////////////////////////////////////////////////////////

// filter beams with code//////////////////////
String sExcludeFBMC = sFilterExcludeBMC + ";";
String arBMExcludeCode[0];
int nIndexExcludeBMC = 0; 
int sIndexExcludeBMC = 0;

while(sIndexExcludeBMC < sExcludeFBMC.length()-1)
{
	String sTokenExcludeBMC = sExcludeFBMC.token(nIndexExcludeBMC);
	nIndexExcludeBMC++;
	if(sTokenExcludeBMC.length()==0)
	{
		sIndexExcludeBMC++;
		continue;
	}
	sIndexExcludeBMC = sExcludeFBMC.find(sTokenExcludeBMC,0);
	sTokenExcludeBMC.trimLeft();
	sTokenExcludeBMC.trimRight();
	sTokenExcludeBMC.makeUpper();
	arBMExcludeCode.append(sTokenExcludeBMC);
}
////////////////////////////////////////////////////////////




//Removing the turned beams
if (nYesNoStuds)
{
	for(int i = 0; i<bmVer.length(); i++)
	{
		if(bmVer[i].dD(vz) < bmVer[i].dD(vx))
		{
			//Beam Rotated
			String sBMCode=bmVer[i].beamCode().token(0);
			sBMCode.makeUpper();
			if (arBMCode.find(sBMCode,-1)==-1)
			{
				bmVer.removeAt(i);
				i--;
			}
		}
	}
}

Beam bmBottomPlate[0];
Point3d ptBeamVerticesForConvex[0];

Beam bmJacksAboveOp[0];

Beam bmFemale[0];
int nLeft=FALSE;
int nRight=FALSE;


//Find Headers
Beam bmHeader[0];
Beam bmHeadbinder[0];

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	int nBeamType=bm.type();
	
	String sBMCode=bm.beamCode().token(0);
	sBMCode.makeUpper();
	if (arBMExcludeCode.find(sBMCode, -1) != -1)
	{
		continue;
	}
	
	
	if (nBeamType==_kSFBottomPlate)
	{
		bmBottomPlate.append(bm);
		Body bd=bm.realBody();
		Point3d ptBeamVertices[]=bd.allVertices();
		ptBeamVerticesForConvex.append(ptBeamVertices);
	}
	else if (nBmTypeValidForConvex.find(nBeamType, -1) != -1)
	{
		Body bd=bm.realBody();
		Point3d ptBeamVertices[]=bd.allVertices();
		ptBeamVerticesForConvex.append(ptBeamVertices);
	}
	
	if (nBeamType==_kSFAngledTPLeft)
	{
		nLeft=TRUE;
		bmFemale.append(bm);
	}
	else if (nBeamType==_kSFAngledTPRight)
	{
		nRight=TRUE;
		bmFemale.append(bm);
	}
	else if (nBeamType== _kSFJackOverOpening)
	{
		bmJacksAboveOp.append(bm);
	}
	else if (nBeamType==_kHeader)
	{
		bmHeader.append(bm);
	}
	else if (nBeamType==_kPanelSplineLumber || nBeamType==_kSFVeryTopPlate)
	{
		bmHeadbinder.append(bm);
	}
}

Beam bmToDimBottom[0];
for (int i=0; i<bmBottomPlate.length(); i++)
{
	Beam bmTemp[]=bmBottomPlate[i].filterBeamsCapsuleIntersect(bmVer);
	bmToDimBottom.append(bmTemp);
}
bmToDimBottom.append(bmJacksAboveOp);

for (int i=0; i<bmToDimBottom.length()-1; i++)
{
	for (int j=i+1; j<bmToDimBottom.length(); j++)
	{
		if (bmToDimBottom[i]==bmToDimBottom[j])
		{
			bmToDimBottom.removeAt(j);
			j--;
		}

	}
}

for (int i=0; i<bmToDimBottom.length(); i++)
{
	String sBMCode=bmToDimBottom[i].beamCode().token(0);
	sBMCode.makeUpper();
	if (arBMExcludeCode.find(sBMCode, -1) != -1)
	{
		bmToDimBottom.removeAt(i);
		i--;
	}
}


//Extract the plane in contact with the face of the element
Plane plnZ(el.ptOrg(), vz);
//Project all vertex points to the plane and create the convex hull encompassing all the vertices
ptBeamVerticesForConvex= plnZ.projectPoints(ptBeamVerticesForConvex);

PLine plConvexHull;
plConvexHull.createConvexHull(plnZ, ptBeamVerticesForConvex);
//plConvexHull.vis();

PLine plOutlineElement(vz);
//plOutlineElement=plConvexHull;

//Point3d ptAllVertex[]=plConvexHull.vertexPoints(FALSE);

Point3d arPtAll[] = plConvexHull.vertexPoints(FALSE);

if( arPtAll.length() > 2 )
{
	plOutlineElement.addVertex(arPtAll[0]);
	for (int i=1; i<arPtAll.length()-1; i++)
	{
		//Analyze initial point with last point and next point
		Vector3d v1(arPtAll[i-1] - arPtAll[i]);
		v1.normalize();
		Vector3d v2(arPtAll[i] - arPtAll[i+1]);
		v2.normalize();
	
		if( abs(v1.dotProduct(v2)) <0.99 ) 
		{
			plOutlineElement.addVertex(arPtAll[i]);
		}
	}
}

plOutlineElement.close();

Point3d ptAllVertex[]=plOutlineElement.vertexPoints(TRUE);

Point3d ptCenterPanel;
ptCenterPanel.setToAverage(ptAllVertex);

//Collect the extreme point to dimension top, bottom, left and right
Point3d ptMostLeft=ptCenterPanel;
Point3d ptMostRight=ptCenterPanel;
Point3d ptMostUp=ptCenterPanel;
Point3d ptMostDown=ptCenterPanel;

for (int i=0; i<ptAllVertex.length(); i++)
{
	Point3d pt=ptAllVertex[i];
	if (vx.dotProduct(ptMostLeft-pt)>0)
		ptMostLeft=pt;
	if (vx.dotProduct(ptMostRight-pt)<0)
		ptMostRight=pt;
	if (vy.dotProduct(ptMostUp-pt)<0)
		ptMostUp=pt;
	if (vy.dotProduct(ptMostDown-pt)>0)
		ptMostDown=pt;
}

if (nYesNoHeadBinder)
{
	Point3d ptHeadBinder[0];
	Point3d ptDimHeader;
	for (int i=0; i<bmHeadbinder.length(); i++)
	{
		Beam bm=bmHeadbinder[i];
		ptDimHeader=bm.ptCen()+vy*(bm.dD(vy)*0.5);
		if (ptDimHeader.Z()>ptMostUp.Z())
			ptMostUp=ptDimHeader;
	}
}

Line lnBase(ptMostDown, vx);
ptMostLeft=lnBase.closestPointTo(ptMostLeft);
ptMostRight=lnBase.closestPointTo(ptMostRight);
	
ptOrgEl=ptMostLeft;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Store the viewport scale
	Display dp(nDimColor);
	dp.dimStyle(sDimLayout, ps2ms.scale());
	//dp.dimStyle(sDimLayout);

	Display dpStuds(nDimColor);
	dpStuds.dimStyle(sDimStyleStuds, ps2ms.scale());

	//DimLine
	DimLine dml (ptOrgEl, vx, vy);
	
	//Element Height
	Line lnElOrg (ptOrgEl, vy);
	Line lnX (ptOrgEl, vx);
	Point3d ptAllVertices [0];
	
	//Wall Volume
	double dElVol;
	for(int i = 0; i<bmAll.length(); i++)
	{
		dElVol += bmAll[i].volume();
	}

	//Find the Start of the element base on the beams
	Point3d ptStartEl=Line(ptMostDown, vx).closestPointTo(ptMostLeft);
	Point3d ptEndEl=Line(ptMostDown, vx).closestPointTo(ptMostRight);
	
	Point3d ptToHeight = Line(ptMostUp, vx).closestPointTo(ptMostLeft);
	
	double dElHeigth = abs(vy.dotProduct(ptMostUp - ptMostDown));//Element Height
	
	//Point where be displayed the list
	Point3d ptToDisp = ptOrgEl + vy*(dElHeigth+dDistListY) - vx*dDistList;//RH 2007-12-19
	ptToDisp.transformBy(ms2ps);
	Point3d ptAux = ptToDisp;
	
	//Beam Point List on X -------------------------------------
	//Type of dim collection for List
	
	int nType = _kLeft;
	
	if(nStartEnd == 1)
		nType = _kRight;
	if(nStartEnd == 2)
		nType = _kCenter;

	
	//Display the dimensions at the left side
	int nCon = 1;
	int nRow =0;//control the columns

	int nSystemRepresentation = U(2,4);
	if (nStartEnd!=3)
	{
		//Collect Dim Points
		Point3d ptDim [] = dml.collectDimPoints(bmVer, nType);
		for(int i =0; i<ptDim.length() - 1; i++)
		{
			Point3d ptCurrent=ptDim[i];
			Point3d ptNext=ptDim[i+1];
			if(abs((ptCurrent - ptNext).dotProduct(vx)) < U(0.1))
			{
				ptDim.removeAt(i+1);
				i--;
			}
		}
		
		for(int i =0; i<ptDim.length(); i++)
		{
			if(i >(nColumn*nCon)-1 )
			{
				ptToDisp = ptAux + _XW*U(10, 0.4)*nCon;
				nCon++;
				nRow=0;
			}//end if
			
			double dDist = abs(vx.dotProduct(ptStartEl - ptDim[i]));
			int nDist = dDist;
			String sDist;
			sDist.formatUnit(dDist , nSystemRepresentation, 0);

	
			dp.draw(sDist, ptToDisp - _YW*dTextY *nRow, _XW , _YW, 1,1);
			nRow++;
			
		}//next i
	}

//Show the beams code (J or C)

	String strVer [0];//array of codes

	int nBmType [] ={_kSFSupportingBeam, _kCrippleStud, _kSFJackUnderOpening, _kSFJackOverOpening };
	String strToType [] = {"C", "C", "J", "J"};
	
	Point3d ptCenter=el.ptOrg();
	ptCenter=ptCenter-vz*(el.dBeamWidth()*0.5);

	Display dpHatch(-1);
	Hatch hatch(sHatchPattern ,U(8));
	hatch.setAngle(0); 
	
	Beam bmFlatStuds[0];
	
	for(int i =0; i< bmToDimBottom.length(); i++)
	{
		Beam bm=bmToDimBottom[i];
		int nLoc = nBmType.find(bmToDimBottom[i].type(), -1);
		
		if(nLoc !=-1)
		{
			strVer.append(strToType [nLoc]);
		}
		else
		{
			
			if (abs(bm.dD(vz)-el.dBeamWidth())<U(0.1, 0.1) || (bm.dD(vx)<bm.dD(vz)))//if (bm.dD(vx)<bm.dD(vz))
			{
				strVer.append("S");//Studs
			}
			else
			{
				bmFlatStuds.append(bm);
				
				if (vz.dotProduct(ptCenter-bm.ptCen())>0)
					strVer.append("JB");//Juction Back
				else
					strVer.append("JF");//Juction Front
				
				//Apply hatch to those beams
				if (nYesNoHatchFlatBeams)
				{
					dpHatch.color(nDimColor);
					PlaneProfile ppBm=bm.realBody().shadowProfile(plnZ);
					ppBm.shrink(U(1));
					ppBm.transformBy(ms2ps);
					dpHatch.draw(ppBm, hatch);
					
				}
			}
		}
	}//next i
	
	//Display de decription of the Flat Studs
	if (nYesNoFlatBeamDesc)
	{
		bmFlatStuds=vx.filterBeamsPerpendicularSort(bmFlatStuds);
		for(int i =0; i< bmFlatStuds.length(); i++)
		{
			Beam bm=bmFlatStuds[i];
			String sText="";
			if (abs(dBmWidth-bm.dD(vx))>U(1))
			{
				sText.formatUnit(bm.dD(vx), 2, 0);
				sText+=" ";
			}
			sText+="FS to ";
			int nSingleStud=true;
			
			if (i<bmFlatStuds.length()-1)
			{
				Beam bmNext=bmFlatStuds[i+1];
				if (abs(vx.dotProduct(bm.ptCen()-bmNext.ptCen()))<U(2))
				{
					sText+="front & rear ";
					i++;
					nSingleStud=false;
				}
			}
			
			if (nSingleStud)
			{
				if (vz.dotProduct(ptCenter-bm.ptCen())>0)
					sText+="rear";//Juction Back
				else
					sText+="front";//Juction Front

			}
			
			Point3d ptToDisplay=bm.ptCen();
			ptToDisplay.transformBy(ms2ps);
			dpStuds.draw(sText, ptToDisplay, _YW, -_XW, 0, 0);
		}
	}
	
	
	Point3d ptShowCode [0];//location point to display the codes
	
	ptShowCode = dml.collectDimPoints(bmToDimBottom, _kCenter);//collect all display points
	ptShowCode=lnX.projectPoints(ptShowCode);
	//ptShowCode=lnX.orderPoints(ptShowCode);
	
	if(nYesNoStudReferences)
	{
		for(int i = 0; i<ptShowCode.length(); i++)
		{
			Point3d ptAuxi = ptShowCode[i] - vy*dOffsetStudReferences;
			
			ptAuxi.transformBy(ms2ps);
			
			dpStuds.draw(strVer[i], ptAuxi, _XW, _YW,0,-.5);
		}//next i
	}
	dOffsetRunDim+=U(40);

//Beams location of last point-------------------------------------

	Beam arBmaux[0];
	//Point3d ptVerBot [0];
	
	Vector3d vxDirForDimensionBeams=vx;
	if (nLeftRightBot==1)//right
	{
		vxDirForDimensionBeams=-vxDirForDimensionBeams;
	}

	
	Beam bmToDim[0];
	bmToDimBottom.append(bmJacksAboveOp);
	bmToDimBottom=vxDirForDimensionBeams.filterBeamsPerpendicularSort(bmToDimBottom);
	
	for(int i =0; i<bmToDimBottom.length()-1; i++)
	{
		Beam bmThis=bmToDimBottom[i];
		Beam bmNext=bmToDimBottom[i+1];
		if (abs(vx.dotProduct(bmThis.ptCen()-bmNext.ptCen()))<U(1))
		{
			if (bmThis.type()==_kSFJackOverOpening)
			{
				bmToDimBottom.removeAt(i);
				i--;
			}
			else if (bmNext.type()==_kSFJackOverOpening)
			{
				bmToDimBottom.removeAt(i+1);
				i--;
			}
		}
	}
	
	
	
	
	for(int i =0; i<bmToDimBottom.length()-1; i++)
	{
		//Body bdBm=bmToDimBottom[i].realBody();
		//bdBm.transformBy(ms2ps);
		//bdBm.vis(i);
		
		//Body bdBm1=bmToDimBottom[i+1].realBody();
		//bdBm1.transformBy(ms2ps);
		//bdBm1.vis(i+1);
		
		if(arBmaux.length()==0)
		{
			arBmaux.append(bmToDimBottom[i]);
		}
      	
		if(abs(vx.dotProduct(bmToDimBottom[i].ptCen() - bmToDimBottom[i+1].ptCen())) <= bmToDimBottom[i].dD(vx)*.5 +  bmToDimBottom[i+1].dD(vx)*.5 +U(0.5, 0.05) && i < bmToDimBottom.length()-2)
		{
			arBmaux.append(bmToDimBottom[i+1]);
		
			if( abs(vx.dotProduct(bmToDimBottom[i+1].ptCen() - bmToDimBottom[i+2].ptCen())) <= bmToDimBottom[i+1].dD(vx) + U(0.5, 0.05) && i == bmToDimBottom.length()-3)
				arBmaux.append(bmToDimBottom[i+2]);
		
			continue;
		}
		else 
		{
			//if(arBmaux.length() >=2 && (arBmaux[0].type()==_kSFJackOverOpening))
			{
			//	bmToDim.append(arBmaux[0]);
			}
			if(arBmaux.length() >=2 && (arBmaux[0].type()!=_kSFJackUnderOpening))// || arBmaux[0].type()!=_kSFJackOverOpening
			{
				if (arBmaux[0].type()!=_kSFJackOverOpening)
				{
					bmToDim.append(arBmaux[0]);
					//Body bdBm1=arBmaux[0].realBody();
					//bdBm1.transformBy(ms2ps);
					//bdBm1.vis(i+1);
				}
			}		
			else
			{
				bmToDim.append(bmToDimBottom[i]);
				//Body bdBm1=bmToDimBottom[i].realBody();
				//bdBm1.transformBy(ms2ps);
				//bdBm1.vis(i+1);

			}
			
			
			if(i == bmToDimBottom.length()-2)
				bmToDim.append(bmToDimBottom[bmToDimBottom.length()-1]);

			arBmaux.setLength(0);
			continue;
		
		}
	}
	
	//Remove the Beams that are not needed	
//	for (int i=0; i<bmToDim.length(); i++)
//	{
//		int nBeamType=bmToDim[i].type();
//		if (nBmTypeToAvoid.find(nBeamType, -1) != -1)
//		{
//			bmToDim.removeAt(i);
//			i--;
//		}
//	}
	

//Top sheets Dimension and Diagonal-------------------------------------

	// filter sheet with material//////////////////////
	String sFBC = sFilterBC + ";";
	String arSFBC[0];
	int nIndexBC = 0; 
	int sIndexBC = 0;
	
	while(sIndexBC < sFBC.length()-1)
	{
  		String sTokenBC = sFBC.token(nIndexBC);
  		nIndexBC++;
  		if(sTokenBC.length()==0)
		{
    			sIndexBC++;
    			continue;
  		}
  		sIndexBC = sFBC.find(sTokenBC,0);
  		sTokenBC.trimLeft();
  		sTokenBC.trimRight();
		sTokenBC.makeUpper();
  		arSFBC.append(sTokenBC);
	}
	////////////////////////////////////////////////////////////
	
	//Collect all sheet	
	//Sheet shAll []= el.sheet(nZone);
	Sheet shAll [0];
	if (nZone!=99)
		shAll=el.sheet(nZone);
	else
		shAll=el.sheet();
		
	Sheet shToWork [0];
	for(int i =0; i<arSFBC.length(); i++)
	{
		for(int j =0; j<shAll.length(); j++)
		{
			String sSheetMaterial=shAll[j].material();
			sSheetMaterial.makeUpper();
			if(arSFBC[i] == sSheetMaterial)
			{
				shToWork.append(shAll[j]);
			}
		}

	}
	
	double dOffset = nYesNoAngularDim ? dOffsetBetweenLn + dOffsetFromEl  : dOffsetBetweenLn;
	Point3d ptSheetTop = ptToHeight+ vy*dOffset;//reference point
	//Offset the distance because there will be another dimension in that place for the headbinder
	//if (bmHeadbinder.length()>0)
		//ptSheetTop = ptSheetTop+ vy*dOffsetBetweenLn;
	
	DimLine dmSheetTop (ptSheetTop, vx, vy);
	Line lnTopSheet (ptSheetTop, vx);
	Line lnElOrgX (ptOrgEl, vx);
	
	//if(shAll.length() > 0)
	if(shToWork.length() > 0)
	{
		ptSheetTop = ptSheetTop + vy*dOffsetBetweenLn;
		//Top sheets Dimension
		//Point3d ptSheetToDim [] = dmSheetTop.collectDimPoints(shAll, _kLeftAndRight);
		Point3d ptSheetToDim [] = dmSheetTop.collectDimPoints(shToWork, _kLeftAndRight);
				
		ptSheetToDim = lnTopSheet.projectPoints(ptSheetToDim);
		ptSheetToDim = lnTopSheet.orderPoints(ptSheetToDim, U(1, 0.01));
		
		Dim dmSheetTop (dmSheetTop,ptSheetToDim ,"<>","<>",_kDimDelta );
		dmSheetTop.transformBy(ms2ps);
		dp.draw(dmSheetTop);
		
		//Sheet Diagonal
		Plane plSheet (ptOrgEl, vz);
		//for (int i=0; i<shAll.length(); i++)

		Display dpSheetOutline (nColorOutline);
		for (int i=0; i<shToWork.length(); i++) 
		{
 			 // loop over list items
  			Sheet sh = shToWork[i];
			
			//Showing the shapes of the sheets
			//Body bdSheet = shToWork[i].realBody();
			Body bdSheet = sh.realBody();
			//bdSheet.vis();
			//PlaneProfile plSheet = bdSheet.shadowProfile(plSheet); Remove in version 1.61 because not been calculating the right shape of sheet
			PlaneProfile plSheet=sh.profShape();
			plSheet.vis(1);

			PLine plSheets [] = plSheet.allRings();

			if (plSheets.length()==0) continue;
			
			PLine plnSheet = plSheets[0];
			PLine plEnv = plnSheet;
			
			plnSheet.transformBy(ms2ps);
			if (nYesNoSheetVis)
				dpSheetOutline.draw(plnSheet);
			
    			Point3d ptEnv[] = plEnv.vertexPoints(1);

  			for (int j=0;j<ptEnv.length();j++)
				ptEnv[j].transformBy(ms2ps);
				
			////////////////////////////////////// RH 2007-12-19	
			double dTol = U(1, 0.01);
			Point3d ptMin, ptMax;
			for (int j=0;j<ptEnv.length();j++)
			{
				for(int k = 1; k <ptEnv.length();k++)
				{
					Vector3d vecUno (ptEnv[k] - ptEnv[j]);
					vecUno.normalize();

					if(abs(vecUno.dotProduct(ptEnv[k] - ptEnv[j])) > dTol)
					{
						ptMin = ptEnv[j];
						ptMax = ptEnv[k];
						dTol = abs(vecUno.dotProduct(ptEnv[k] - ptEnv[j]));
					}
					
				}
			}
			/////////////////////////////////////////////

			PLine plDia(ptMin,ptMax);	
			String sLineStyle="DASHED";//ACAD_ISO10W100
			
			Display dpSheetDiag (nColorDiag);
			dpSheetDiag.lineType(sLineStyle);
			
			if(nYesNoSheet)
				dpSheetDiag.draw(plDia);
		
		}//next i
	}
	

//Openings-------------------------------------
Opening opAll[]=el.opening();
Point3d ptOpDimBottom[0];
Point3d ptOpDimSide[0];
Point3d ptCenterAllOp[0];
double dOpWidth[0];
Point3d ptHeaderHeight[0];
Point3d ptSillHeight[0];

//Collect Lintols description-------------------------------------

Point3d ptLocationDesc[0];

String sHeaderDescription[0];
String sHeaderDetailDescription[0];
ElemText et[0];
et = el.elemTexts(); 


ElemText eltext[] = el.elemTexts();

for (int i = 0; i <et.length(); i++)
{
	Point3d ptTextorig = et[i].ptOrg();
	String eltext = et[i].text();

	String textCode = et[i].code();
	String textSubCode = et[i].subCode();

	if(textCode=="WINDOW" && textSubCode == "HEADER")
	{
		ptLocationDesc.append(ptTextorig);
		sHeaderDescription.append(eltext);
		sHeaderDetailDescription.append(eltext);
	}
}

//Loop throw all the openings
for (int o=0; o<opAll.length(); o++)
{
	Opening op=opAll[o];
	OpeningSF opSF = (OpeningSF) op;
	double dGapSideOp=0;
	double dGapBottomOp=0;
	double dGapTopOp=0;
	
	if (opSF.bIsValid())
	{
		dGapSideOp=opSF.dGapSide();
		dGapBottomOp=opSF.dGapBottom();
		dGapTopOp=opSF.dGapTop();
	}
	
	PLine plShapeOp=op.plShape();


	Point3d ptAllVertexOp[]=plShapeOp.vertexPoints(TRUE);
	Point3d ptCenterOp;
	ptCenterOp.setToAverage(ptAllVertexOp);
	
	
	if (nYesNoWindowSize)
	{
		double dOPRealW=op.width();
		double dOPRealH=op.height();

		String sOPRealW;
		sOPRealW.formatUnit(dOPRealW, 2, nPrecision);
		String sOPRealH;
		sOPRealH.formatUnit(dOPRealH, 2, nPrecision);

		String sOPStrucW;
		String sOPStrucH;
		int nSFOpening=false;
		OpeningSF opSF=(OpeningSF) op;
		
		if (opSF.bIsValid())
		{
			nSFOpening=true;
			double dOPStrucW=dOPRealW+opSF.dGapSide()*2;
			double dOPStrucH=dOPRealH+opSF.dGapTop()+opSF.dGapBottom();
			sOPStrucW.formatUnit(dOPStrucW, 2, nPrecision);
			sOPStrucH.formatUnit(dOPStrucH, 2, nPrecision);
		}
		
		Point3d ptTextOPDisp = ptCenterOp;
		ptTextOPDisp.transformBy(ms2ps);
		ptTextOPDisp.vis();
		if(nYesNoWindowDescription==1)
		{
			String sOpDescription=opSF.openingDescr();
			dp.draw(sOpDescription,ptTextOPDisp,_XW,_YW,0,1.2);
			ptTextOPDisp-=_YW*(dp.textHeightForStyle("X",sDimLayout)+0.5);
		}
		if(nYesNoWindowDescription==2)
		{
			String sOpDescription=op.description();
			dp.draw(sOpDescription,ptTextOPDisp,_XW,_YW,0,1.2);
			ptTextOPDisp-=_YW*(dp.textHeightForStyle("X",sDimLayout)+0.5);
		}
		if(nYesNoWindowDescription==3)
		{
			String sLinesToDisplay[0];
			Map mpThisOp=op.getAttachedPropSetMap(sPropSetName);
			if (mpThisOp.length()>0)
			{
				for (int i=0; i<mpThisOp.length(); i++)
				{
					if (mpThisOp.hasString(i))
					{
						sLinesToDisplay.append(mpThisOp.getString(i));
					}
					else if (mpThisOp.hasDouble(i))
					{
						String sThisValue=mpThisOp.getDouble(i);
						if (mpThisOp.keyAt(i)=="Weight")
						{
							sThisValue+="Kg";
						}
						sLinesToDisplay.append(sThisValue);
					}
					else if (mpThisOp.hasInt(i))
					{
						sLinesToDisplay.append(mpThisOp.getInt(i));
					}
				}
			}
			
			if (sLinesToDisplay.length()>0)
			{
				ptTextOPDisp+=_YW*((dp.textHeightForStyle("X",sDimLayout)+0.5)*(sLinesToDisplay.length()-1));
			}
			
			for (int i=0; i<sLinesToDisplay.length(); i++)
			{
				dp.draw(sLinesToDisplay[i],ptTextOPDisp,_XW,_YW,0,1.2);
				ptTextOPDisp-=_YW*(dp.textHeightForStyle("X",sDimLayout)+0.5);
			}
			
		}
		
		dp.draw("W:"+sOPRealW, ptTextOPDisp, _XW , _YW, 0, 1.2);
		dp.draw("H:"+sOPRealH, ptTextOPDisp, _XW , _YW, 0, -1.2);
		if (nSFOpening)
		{
			dp.draw("("+sOPStrucW+"x"+sOPStrucH+")", ptTextOPDisp, _XW , _YW, 0, -3.6);
		}
	}
	
	
	//Collect the extreme point to dimension top, bottom, left and right
	Point3d ptMostLeftOp=ptCenterOp;
	Point3d ptMostRightOp=ptCenterOp;
	Point3d ptMostUpOp=ptCenterOp;
	Point3d ptMostDownOp=ptCenterOp;
	
	Line lnCenterOp(ptCenterOp, vy);
	
	for (int i=0; i<ptAllVertexOp.length(); i++)
	{
		Point3d pt=ptAllVertexOp[i];
		if (vx.dotProduct(ptMostLeftOp-pt)>0)
			ptMostLeftOp=pt;
		if (vx.dotProduct(ptMostRightOp-pt)<0)
			ptMostRightOp=pt;
		if (vy.dotProduct(ptMostUpOp-pt)<0)
			ptMostUpOp=pt;
		if (vy.dotProduct(ptMostDownOp-pt)>0)
			ptMostDownOp=pt;
	}
	ptMostLeftOp=ptMostLeftOp-vx*dGapSideOp;
	ptMostRightOp=ptMostRightOp+vx*dGapSideOp;
	ptMostUpOp=ptMostUpOp+vy*dGapTopOp;
	ptMostDownOp=ptMostDownOp-vy*dGapBottomOp;

	ptOpDimBottom.append(ptMostLeftOp);
	ptOpDimBottom.append(ptMostRightOp);

	ptOpDimSide.append(ptMostUpOp);
	ptOpDimSide.append(ptMostDownOp);
	
	ptCenterAllOp.append(ptCenterOp);
	ptHeaderHeight.append(lnCenterOp.closestPointTo(ptMostUpOp));
	ptSillHeight.append(lnCenterOp.closestPointTo(ptMostDownOp));

	dOpWidth.append(abs(vx.dotProduct(ptMostLeftOp-ptMostRightOp)));
	
	Point3d ptHeader=Line(ptMostLeftOp, vy).closestPointTo(ptMostUpOp);
	double dHeightHeader=vy.dotProduct(ptHeader-ptMostDown);
	String sHeaderHeight;
	sHeaderHeight.format("Op Height: %4.0f", dHeightHeader);

	ptHeader.transformBy(ms2ps);
	//dp.draw(sHeaderHeight, ptHeader, _XW, _YW, 1.1, -1.5);
	
	//Find the Header that bellongs to that opening
	//bmHeader
	
	Body bdHeader (ptCenterOp, vy, -vx, vz, U(10000, 400), U(20, 1), U(1000, 8),1,0,0);
	Beam bmHeaderThisOp[0];
	ptCenterOp.vis();
	bdHeader.vis();
	for (int i=0; i<bmHeader.length(); i++)
	{
		if (bmHeader[i].envelopeBody(FALSE, TRUE).hasIntersection(bdHeader))
		{
			bmHeaderThisOp.append(bmHeader[i]);
		}
	}
	int nHeaderIndex=-1;
	double dHeaderHeight=0;
	double dHeaderLength=0;
	double dHeaderWidth=0;
	String sBmName;
	for (int i=0; i<bmHeaderThisOp.length(); i++)
	{
		if (bmHeaderThisOp[i].dD(vy)>dHeaderHeight)
		{
			dHeaderHeight=bmHeaderThisOp[i].dD(vy);
			sBmName=bmHeaderThisOp[i].name();
		}
		if (bmHeaderThisOp[i].dD(vz)>dHeaderWidth)
		{
			dHeaderWidth=bmHeaderThisOp[i].dD(vz);
		}
		if (bmHeaderThisOp[i].solidLength()>dHeaderLength)
		{
			dHeaderLength=bmHeaderThisOp[i].solidLength();
		}
	}
	
	//Calculate the number of headers
	int nNumberOfHeaders=0;
	for (int i=0; i<bmHeaderThisOp.length(); i++)
	{
		double test=bmHeaderThisOp[i].dD(vz);
		if (bmHeaderThisOp[i].dD(vz)>(dHeaderWidth-U(1)))
			nNumberOfHeaders++;
		
	}

	
	//Show the ElemText that correspond to each opening
	double dMaxDist=U(10000, 400);
	int nLoc=-1;
	for (int i=0; i<ptLocationDesc.length(); i++)
	{
		if (abs(vx.dotProduct(ptLocationDesc[i]-ptCenterOp))<dMaxDist)
		{
			dMaxDist=abs(vx.dotProduct(ptLocationDesc[i]-ptCenterOp));
			nLoc=i;
		}
	}
	
	if (nLoc!=-1)
	{
		if (nHeaderDesc==0)
		{
			String sText=sHeaderDescription[nLoc]+" "+dHeaderLength;
			Point3d ptTextOrig = ptLocationDesc[nLoc];
			ptTextOrig=ptTextOrig -vy*dOffsetHeader;
			ptTextOrig.transformBy(ms2ps);
		    	dp.draw(sText, ptTextOrig, _XW , _YW, 1.2, -1.2);
		}
		if (nHeaderDesc==1)
		{
			String sText=sBmName+" "+dHeaderLength;
			Point3d ptTextOrig = ptLocationDesc[nLoc];
			ptTextOrig=ptTextOrig -vy*dOffsetHeader;
			ptTextOrig.transformBy(ms2ps);
		    	dp.draw(sText, ptTextOrig, _XW , _YW, 1.2, -1.2);
		}
		if (nHeaderDesc==2)
		{

			String sHeight;
			sHeight.formatUnit(dHeaderHeight, 2, nPrecision);
			String sThislength;
			sThislength.formatUnit(dHeaderLength, 2, nPrecision);
			//String sThisWidth;
			//sThisWidth.formatUnit(dHeaderWidth, 2, 2);
			String sText=nNumberOfHeaders+"/"+dHeaderWidth+"x"+sHeight+"x"+sThislength;
			Point3d ptTextOrig = ptLocationDesc[nLoc];
			ptTextOrig=ptTextOrig -vy*dOffsetHeader;
			ptTextOrig.transformBy(ms2ps);
		    	dp.draw(sText, ptTextOrig, _XW , _YW, 1.2, -1.2);
		}
		if (nHeaderDesc==4) //Header detail description
		{
			String sText=sHeaderDetailDescription[nLoc];
			Point3d ptTextOrig = ptLocationDesc[nLoc];
			ptTextOrig=ptTextOrig -vy*dOffsetHeader;
			ptTextOrig.transformBy(ms2ps);
		    	dp.draw(sText, ptTextOrig, _XW , _YW, 1.2, -1.2);
		}
	}
}

Point3d ptBaseDimHor=_Pt0;
ptBaseDimHor.transformBy(ps2ms);
ptBaseDimHor=ptBaseDimHor-vy*dOffsetBottomDim;

Point3d ptBaseDimHorTop=_Pt0;
//ptBaseDimHorTop.transformBy(ps2ms);
ptBaseDimHorTop=ptBaseDimHorTop+_YW*dOffsetTopDim;
ptBaseDimHorTop.transformBy(ps2ms);

//Horizontal dimension in the midle of the openings
//Show the dimension of the Openings 
if (opAll.length()>0 && nDimOpeningLocHor!=3)
{
	Point3d ptBaseDimOpenings;
	ptBaseDimOpenings.setToAverage(ptHeaderHeight);
	
	DimLine dimLnOpenings(ptBaseDimOpenings-vy*(U(200)-dOffsetHorOpDim), vx, vy);
	
	ptOpDimBottom.append(ptMostLeft);
	ptOpDimBottom.append(ptMostRight);
	
	Line lnOp (ptBaseDimOpenings-vy*(U(200)-dOffsetHorOpDim), vx);
	ptOpDimBottom= lnOp.projectPoints(ptOpDimBottom);
	ptOpDimBottom= lnOp.orderPoints(ptOpDimBottom);
	
	int nDimType=_kDimDelta;
	if (nDimOpCummulative)
		nDimType=_kDimBoth;
	
	if (nDimOpeningLocHor==0 || nDimOpeningLocHor==2)
	{
		//Dim dimOpenings(dimLnOpenings, ptOpDimBottom,"<>","<>", _kDimPar, _kDimNone); // def in MS
		Dim dimOpenings(dimLnOpenings, ptOpDimBottom,"<>","<>", nDimType); // def in MS
		dimOpenings.transformBy(ms2ps); // transfrom the dim from MS to PS
		dp.draw(dimOpenings);
	}
	if (nDimOpeningLocHor==1 || nDimOpeningLocHor==2)
	{
		Line lnOpBellowEl (ptBaseDimHor, vx);
		ptOpDimBottom= lnOpBellowEl.projectPoints(ptOpDimBottom);
		ptOpDimBottom= lnOpBellowEl.orderPoints(ptOpDimBottom);
		
		DimLine dimLnOpeningsBellowEl(ptBaseDimHor, vx, vy);
		Dim dimOpeningsBellowEl(dimLnOpeningsBellowEl, ptOpDimBottom,"<>","<>", nDimType); // def in MS
		dimOpeningsBellowEl.transformBy(ms2ps); // transfrom the dim from MS to PS
		dp.draw(dimOpeningsBellowEl);
	}
}

//HeadBinder dimension
if (bmHeadbinder.length()>0)
{
	Point3d ptHeadBinder[0];
	Point3d ptDimHeader;
	for (int i=0; i<bmHeadbinder.length(); i++)
	{
		Beam bm=bmHeadbinder[i];
		if (i==0)
		{
			ptDimHeader=bm.ptCen()+vy*(bm.dD(vy)*0.5);
		}
		else
		{
			if (bm.ptCen().Z()>ptDimHeader.Z())
			{
				ptDimHeader=bm.ptCen()+vy*(bm.dD(vy)*0.5);
			}
		}
		
		Vector3d vxBm=bm.vecX();
		if (vxBm.dotProduct(vx)<0)
			vxBm=-vxBm;
		Point3d ptVertex[]=bm.realBody().extremeVertices(vxBm);
		if (ptVertex.length()>0)
		{
			ptHeadBinder.append(ptVertex[0]);
			ptHeadBinder.append(ptVertex[ptVertex.length()-1]);
		}
	}

	//ptDimHeader+= vy*dOffsetBetweenLn
	
	Line lnHeadbinder(ptDimHeader, vx);
	ptHeadBinder=lnHeadbinder.projectPoints(ptHeadBinder);
	ptHeadBinder=lnHeadbinder.orderPoints(ptHeadBinder);
	
	Point3d ptDimLeftHB[0];
	Point3d ptDimRightHB[0];
	if (ptHeadBinder.length()>1)
	{
		Point3d ptLeftHB=ptHeadBinder[0];
		Point3d ptRightHB=ptHeadBinder[ptHeadBinder.length()-1];
		if (vx.dotProduct(ptLeftHB-ptMostLeft)<0)
		{
			ptDimLeftHB.append(ptLeftHB);
			ptDimLeftHB.append(ptMostLeft);
		}
		else
		{
			if (vx.dotProduct(ptLeftHB-ptMostLeft)>0)
			{
				ptHeadBinder.append(ptMostLeft);
			}
		}
		if (vx.dotProduct(ptRightHB-ptMostRight)>0)
		{
			ptDimRightHB.append(ptRightHB);
			ptDimRightHB.append(ptMostRight);
		}
		else
		{
			if (vx.dotProduct(ptRightHB-ptMostRight)<0)
			{
				ptHeadBinder.append(ptMostRight);
			}
		}
		//ptVerBot.append(ptMostLeft);
		//ptVerBot.append(ptMostRight);
	}
	//Dim Left Oversail
	if (ptDimLeftHB.length()>1)
	{
		ptDimLeftHB=Line (ptDimHeader-vy*U(38), vx).projectPoints(ptDimLeftHB);
		ptDimLeftHB=Line (ptDimHeader-vy*U(38), vx).orderPoints(ptDimLeftHB);
		
		DimLine dmLeftHB (ptDimLeftHB[0]-vy*U(dOffsetFromEl), vx, vy);
		Dim dimLeftHB (dmLeftHB , ptDimLeftHB, "<>", "<>", _kDimDelta);
		dimLeftHB.setDeltaOnTop(false);
		dimLeftHB.transformBy(ms2ps);

		dp.draw(dimLeftHB);
	}
	//Dim Right Oversail
	if (ptDimRightHB.length()>1)
	{
		ptDimRightHB=Line (ptDimHeader-vy*U(38), vx).projectPoints(ptDimRightHB);
		ptDimRightHB=Line (ptDimHeader-vy*U(38), vx).orderPoints(ptDimRightHB);
		
		DimLine dmRightHB (ptDimRightHB[0]-vy*U(dOffsetFromEl), vx, vy);
		Dim dimRightHB (dmRightHB, ptDimRightHB, "<>", "<>", _kDimDelta);
		dimRightHB.setDeltaOnTop(false);
		dimRightHB.transformBy(ms2ps);
	
		dp.draw(dimRightHB);
	}
	//Dim Headbinder on top
	if (ptHeadBinder.length()>1)
	{
		ptHeadBinder=Line (ptDimHeader, vx).projectPoints(ptHeadBinder);
		ptHeadBinder=Line (ptDimHeader, vx).orderPoints(ptHeadBinder);
		
		DimLine dmHB (ptSheetTop, vx, vy);
		Dim dimHB (dmHB, ptHeadBinder, "<>", "<>", _kDimDelta);
		dimHB.transformBy(ms2ps);
	
		dp.draw(dimHB);
	}
}//Endi dimension headbinder

//Bottom plates dimensions-------------------------------------
//Points to be dimensioned



	if (opAll.length()>0 && (nDimOpeningLocHor==1 || nDimOpeningLocHor==2) )
		ptBaseDimHor=ptBaseDimHor-vy*dOffsetBetweenLn;
	//nDimOpeningLocHor
	
	//DimLine dmBot (ptMostLeft- vy*U(dOffsetBottomDim) , vx, vy);
	DimLine dmBot (ptBaseDimHor, vx, vy);
	
	Point3d ptLengthElement[0];
	ptLengthElement.append(Line (ptBaseDimHor, vx).closestPointTo(ptMostLeft));//- vy*U(dOffsetBottomDim)
	ptLengthElement.append(Line (ptBaseDimHor, vx).closestPointTo(ptMostRight));
	
	Dim dimBot (dmBot, ptLengthElement, "<>", "<>", _kDimDelta);
	dimBot.transformBy(ms2ps);
	
	dp.draw(dimBot);
	
	//Point3d ptTxtEl=ptMostRight- vy*U(550);
	//ptTxtEl.transformBy(ms2ps);
	//dp.draw("Element", ptTxtEl, _XW, _YW, 1.5, 0);


//Dimension of the Studs below the element 
	int nTypeBot = _kLeft;
	
	if(nStartEndBot == 1)
		nTypeBot = _kRight;
	if(nStartEndBot == 2)
		nTypeBot = _kCenter;

	if(nStartEndBot != 3)
	{
		double dOffsetBeamDim=dOffsetRunDim;
		//double dLengthBeamLine=U(9, 0.4);
		//if (sSpace == sShopdrawSpace )
		//{
		//	dOffsetBeamDim=dOffsetRunDim;
		//	dLengthBeamLine=U(180, 3);
		//}
		
		Vector3d vxDirForDimension=vx;
		Vector3d vyDirForDimension=vy;
		int nRunningFlag=true;
		if (nLeftRightBot==1 && nRunningMode!=2)//right
		{
			vxDirForDimension=-vxDirForDimension;
			vyDirForDimension=-vyDirForDimension;
			nRunningFlag=false;
		}
		DimLine dlBot (ptOrgEl, vxDirForDimension, vyDirForDimension);
		Line lnBot(ptOrgEl, vxDirForDimension);
		//bmToDim.append(bmJacksAboveOp);
		
		Point3d ptVerBot[] = dlBot.collectDimPoints(bmToDim, nTypeBot);
		ptVerBot.append(ptMostLeft);
		ptVerBot.append(ptMostRight);
		ptVerBot.append(ptOpDimBottom);
		//Sort the points
		ptVerBot=lnBot.projectPoints(ptVerBot);
		ptVerBot=lnBot.orderPoints(ptVerBot);
		
		double dLast=0;
		String sLast;
		if(nRunningMode==0)
		{
			for(int i = 0; i<ptVerBot.length(); i ++)
			{
				PLine plDimBmLast;//line of dimension
				Point3d ptPs = ptVerBot[i];//point to display the dimension
	
				ptPs=ptPs- vy*(dOffsetBeamDim+dLengthBeamLine);
	
				plDimBmLast.addVertex(ptPs );
				plDimBmLast.addVertex(ptPs + vy*dLengthBeamLine);
	
				
				ptPs.transformBy(ms2ps);
				//Displaying value
				dLast = abs(vx.dotProduct(ptStartEl - ptVerBot[i]));
				if (nLeftRightBot==1)//right
					dLast = abs(vx.dotProduct(ptEndEl - ptVerBot[i]));

				sLast.formatUnit(dLast, nSystemRepresentation, 0);
				
				dpStuds.draw(sLast, ptPs,  _YW, -_XW, 1,1.4 );
				
				plDimBmLast.transformBy(ms2ps);
				//Displaying polyline
				dp.draw(plDimBmLast);
	
			}//next i
		}
		else if(nRunningMode > 0)
		{
			if (ptVerBot.length()>1)
			{
				ptVerBot.append(ptStartEl);
				
				
				Point3d ptPs = ptVerBot[0];//point to display the dimension
				ptPs=ptPs- vy*(dOffsetBeamDim);
	
				
				DimLine dl (ptPs, vxDirForDimension, vyDirForDimension);
				
				Line ln (ptPs, vxDirForDimension);
				ptVerBot=ln.projectPoints(ptVerBot);
				ptVerBot=ln.orderPoints(ptVerBot);

				int endModus = nRunningMode == 1 ? nRunningType : _kDimNone;
				int middleModus = nRunningMode ==1 ? _kDimNone : _kDimDelta;
				int bDeltaOnTop = nRunningMode ==1 ? true : false;
				Dim dim(dl, ptVerBot,"<>","<>", middleModus, endModus);
				if (nDeltaOnTop)
					dim.setDeltaOnTop(false);
				else
					dim.setDeltaOnTop(true);
				dim.transformBy(ms2ps);
				dp.draw(dim); 
			}
		}
	}


//Vertical Dimension
//Find the base point to start to locate the dimensions

Point3d ptBaseDimRight = ptMostRight;
ptBaseDimRight=ptBaseDimRight+vx*dOffsetFromEl;

Point3d ptBaseDimLeft = ptMostLeft;
ptBaseDimLeft=ptBaseDimLeft-vx*dOffsetFromEl;

//If there is any angle plate then dimension the extreme points of the panel
if (bmFemale.length()>0)
{
	Point3d ptAngleWalls[0];
	ptAngleWalls=ptAllVertex;
	
	Point3d ptDimAnglePanel=ptStartEl-vx*dOffsetFromEl;
	if (nReverseX)
	{
		ptDimAnglePanel=ptBaseDimRight;
		//ptBaseDimRight=ptBaseDimRight+vx*U(dOffsetBetweenLn);
	}
	
	if (nRight==TRUE && nLeft==FALSE)
	{
		ptDimAnglePanel=ptBaseDimRight;
		if (nReverseX)
		{
			ptDimAnglePanel=ptStartEl-vx*dOffsetFromEl;
			//ptBaseDimRight=ptBaseDimRight+vx*U(dOffsetBetweenLn);
		}
	}
	
	if ((nRight==TRUE && nReverseX==FALSE) || (nLeft==TRUE && nReverseX==TRUE))
		ptBaseDimRight=ptBaseDimRight+vx*dOffsetBetweenLn;
		
	Line lnY (ptDimAnglePanel, vy);
	ptAngleWalls=lnY.projectPoints(ptAngleWalls);
	ptAngleWalls=lnY.orderPoints(ptAngleWalls);

	if (ptAngleWalls.length()>2)
	{
		ptAngleWalls.removeAt(ptAngleWalls.length()-1);
		DimLine dmLeftElement (ptDimAnglePanel, vy, -vx);
		Dim dimLeftElement (dmLeftElement, ptAngleWalls, "<>", "<>", _kDimDelta);
		dimLeftElement.transformBy(ms2ps);
	
		dp.draw(dimLeftElement);
	}
}

//Dimension for Blockings-------------------------------------

int nConf = 0;
Point3d ptToDimBlock [0];
Beam bmBlocking[0];

Beam bmJaks[0];

for(int i = 0; i<bmAll.length(); i++)
{
	if(bmAll[i].type() == _kSFBlocking)
	{
		if(nBlockingDimToBottomCenterTop==1) // Dimension to center of blocking
		{
			ptToDimBlock.append(bmAll[i].ptCen());
		}
		else
		{					
			Body bdBlock = bmAll[i].envelopeBody();
			Point3d ptExt [0];
			if(nBlockingDimToBottomCenterTop==0) // Bottom
			 	ptExt = bdBlock.extremeVertices(vy);
			else //top
			 	ptExt = bdBlock.extremeVertices(-vy);
			
			ptToDimBlock.append(ptExt [0]);
		}

		nConf =1;
		bmBlocking.append(bmAll[i]);
	}//end if
	
	if(bmAll[i].type() == _kSFJackOverOpening || bmAll[i].type() == _kSFJackUnderOpening)
	{
		bmJaks.append(bmAll[i]);
	}
}//next i

//Show the length og the Blocking pieces
if(nYesNoBlockLength)
{
	for (int i=0; i<bmBlocking.length(); i++)
	{
		Beam bm=bmBlocking[i];
		double dBmLength=bm.solidLength();
		String sDim;
		sDim.formatUnit(dBmLength, 2, 0);

		Point3d ptToDisp=bm.ptCen()+ el.vecY()*U(40);
		ptToDisp.transformBy(ms2ps);
		dp.draw(sDim, ptToDisp, _XW, _YW, 0, 1);
	}
}

if (nYesNoJacks)
{
	for (int i=0; i<bmJaks.length(); i++)
	{
		Beam bm=bmJaks[i];
		double dBmLength=bm.solidLength();
		String sDim;
		sDim.formatUnit(dBmLength, 2, 0);

		Point3d ptToDisp=bm.ptCen()+ el.vecY()*U(40);
		ptToDisp.transformBy(ms2ps);
		dp.draw(sDim, ptToDisp, _YW, -_XW, 0, 0);
	}
}

if (nYesNoBlocking)
{
//	DimLine dlBlock (ptBaseDimRight, vy,-vx); // DR 22.mar.2013 
//	Line lnBlocking (ptBaseDimRight, vy); // DR 22.mar.2013 

	ptToDimBlock.append(ptStartEl);
	if(nConf==1)
	{
		DimLine dlBlock;
		Line lnBlocking;

		Point3d ptBlockingDim; // DR 22.mar.2013

		if(nBlockingDimLineAlignment==0) // Left
		{
			ptBlockingDim=ptOrgEl-vx*dBlockingDimOffsetFromEl;
		}
		else
		{
			ptBlockingDim=ptBaseDimRight;
		}

		dlBlock=DimLine(ptBlockingDim, vy,-vx);
		lnBlocking=Line(ptBlockingDim, vy);
		
		ptToDimBlock = lnBlocking.projectPoints(ptToDimBlock);
		ptToDimBlock = lnBlocking.orderPoints(ptToDimBlock,U(1, 0.4));

		Dim dmBlock (dlBlock, ptToDimBlock,"<>","<>",_kDimDelta );
		dmBlock.transformBy(ms2ps);
		dp.draw(dmBlock);
		
		if(nBlockingDimLineAlignment) // Right
		{
			ptBaseDimRight=ptBaseDimRight+vx*U(dOffsetBetweenLn);
		}

		if(nYesNoVerticalDimName) // DR 22.mar.2013 START 002
		{
			Point3d ptDrawTxt=ptToDimBlock[ptToDimBlock.length()-1];
			ptDrawTxt+=vx*vx.dotProduct(ptBlockingDim-ptDrawTxt)+vy*U(50,2);
			ptDrawTxt.transformBy(ms2ps);
			dp.draw("Blocking", ptDrawTxt, _YW, -_XW, 1, 0);
		}// DR 22.mar.2013 END 002
	}//end if
}

int nLocOp=0;

if (nDimOpeningLocVer!=3)
{
	for (int i=0; i<ptOpDimSide.length(); i+=2)
	{
		Point3d ptBaseDimRightOpening=ptBaseDimRight;
		if (nDimOpeningLocVer==1)//Center of opening
		{
			ptBaseDimRightOpening=ptCenterAllOp[nLocOp]+vx*(dOpWidth[nLocOp]*0.5)*0.80;
		}
	
		if (nDimOpeningLocVer==2)// Left side of the panel
		{
			ptBaseDimRightOpening=ptBaseDimLeft;
			ptBaseDimLeft=ptBaseDimLeft-vx*dOffsetBetweenLn;

			if (i != 0)
			{
				if (abs(vy.dotProduct(ptOpDimSide[i]-ptOpDimSide[i-2])) <U(1, 0.03) && abs(vy.dotProduct(ptOpDimSide[i+1]-ptOpDimSide[i-1])) <U(1, 0.03))
					continue;
			}			
		}
	
		if (i != 0)
		{
			if (nDimOpeningLocVer==0)//Right of the panel
			{
				if (abs(vy.dotProduct(ptOpDimSide[i]-ptOpDimSide[i-2])) <U(1, 0.03) && abs(vy.dotProduct(ptOpDimSide[i+1]-ptOpDimSide[i-1])) <U(1, 0.03))
					continue;
				ptBaseDimRight=ptBaseDimRight+vx*dOffsetBetweenLn;
				ptBaseDimRightOpening=ptBaseDimRight;
			}
			

		}
	
		Point3d ptDimOpeningRight[0];
		ptDimOpeningRight.append(ptMostDown);
		ptDimOpeningRight.append(ptOpDimSide[i]);
		ptDimOpeningRight.append(ptOpDimSide[i+1]);
		ptDimOpeningRight.append(ptMostUp);
		
		Line lnOp (ptBaseDimRightOpening, vy);
		ptDimOpeningRight= lnOp.projectPoints(ptDimOpeningRight);
		ptDimOpeningRight= lnOp.orderPoints(ptDimOpeningRight);
		
		DimLine dimLnOpeningRight(ptBaseDimRightOpening, vy, -vx);
	
		Dim dimOpeningRight(dimLnOpeningRight, ptDimOpeningRight, "<>", "<>", _kDimPar, _kDimNone); // def in MS
		dimOpeningRight.transformBy(ms2ps); // transfrom the dim from MS to PS
		dp.draw(dimOpeningRight);

		if(nYesNoVerticalDimName) // DR 22.mar.2013 START 002
		{
			Point3d ptDrawTxt=ptDimOpeningRight[ptDimOpeningRight.length()-1];
			ptDrawTxt+=vx*vx.dotProduct(ptBaseDimRightOpening-ptDrawTxt)+vy*U(50,2);
			ptDrawTxt.transformBy(ms2ps);
			dp.draw("Opening", ptDrawTxt, _YW, -_XW, 1, 0);
		}// DR 22.mar.2013 END 002

		//Draw the Height of the Opening		
		//Point3d ptHeader=lnOp.closestPointTo(ptOpDimSide[i]);
		Point3d ptHeader=ptHeaderHeight[nLocOp];
		double dHeightHeader=vy.dotProduct(ptOpDimSide[i]-ptMostDown);
		String sHeaderHeight;
		sHeaderHeight.format("%4.0f", dHeightHeader);

		Point3d ptSill=ptSillHeight[nLocOp];
		double dSillHeader=vy.dotProduct(ptOpDimSide[i+1]-ptMostDown);
		String sSillHeight;
		sSillHeight.format("%4.0f", dSillHeader);

		ptHeader.transformBy(ms2ps);
		ptSill.transformBy(ms2ps);
		if(nShowWindowHeights==1 || nShowWindowHeights==3)
		{
			dp.draw(sHeaderHeight, ptHeader, _XW, _YW, 0, -1.2);
		}
		if(nShowWindowHeights==2 || nShowWindowHeights==3)
		{

			dp.draw(sSillHeight, ptSill, _XW, _YW, 0, 1.2);
		}
		nLocOp++;
	}
}

//Wall Height Dimension -------------------------------------

	if (opAll.length()>0 && nDimOpeningLocVer==0)
		ptBaseDimRight=ptBaseDimRight+vx*dOffsetBetweenLn;
	
	DimLine dlWall ( ptBaseDimRight, vy,-vx);
	Line lnWall (ptBaseDimRight, vy);
	Point3d ptToDimWallH [0];
	ptToDimWallH.append(ptStartEl);
	ptToDimWallH.append(ptToHeight);
	
	ptToDimWallH = lnWall.projectPoints(ptToDimWallH);
	ptToDimWallH = lnWall.orderPoints(ptToDimWallH);
	
	Dim dmWall (dlWall, ptToDimWallH, "<>","<>",_kDimDelta );
	dmWall.transformBy(ms2ps);
	dp.draw(dmWall);

	if(nYesNoVerticalDimName) // DR 22.mar.2013 START 002
	{
		Point3d ptDrawTxt=ptToDimWallH[ptToDimWallH.length()-1];
		ptDrawTxt+=vx*vx.dotProduct(ptBaseDimRight-ptDrawTxt)+vy*U(50,2);
		ptDrawTxt.transformBy(ms2ps);
		dp.draw("Wall height", ptDrawTxt, _YW, -_XW, 1, 0);
	}// DR 22.mar.2013 END 002

//Wall definition-------------------------------------
	if(nYesNoWallDetails)
	{
		String strWallDes = el.definition();
		Point3d ptDefi = ptBaseDimHorTop;
	
		if (nYesNoDiagonal==2)//Diag as text on top
			ptDefi=ptDefi+vy*dOffsetBetweenLn;
		
		int nBmW = el.dBeamHeight();
		int nElW = el.dBeamWidth();
		int nElWeight = dFactor * dElVol /1000000000;
		
		ptDefi.transformBy(ms2ps);
		
		String sTextInfo=strWallDes + " " + nBmW + "x" + nElW;
		if (nYesNoWallWeight)
			sTextInfo+=" (Frame weight: " + nElWeight + " kg)";
			
		dp.draw(sTextInfo, ptDefi,  _XW,_YW, 1,1);
	}
	
//Nailing descrption-------------------------------------
	if(nYesNoNailing)
	{
		double dSpacingEdge1;
		double dSpacingCenter1;
		int nZones1;
		String sNailType1;
		
		TslInst tslAll[]=el.tslInstAttached();
		for (int i=0; i<tslAll.length(); i++)
		{
			if ( tslAll[i].scriptName() == "hsb_Apply Naillines to Elements")
			{
				Map mpTSL=tslAll[i].map();
				if (mpTSL.hasMap("NailingInfo"))
				{
					Map mpNailInfo=mpTSL.getMap("NailingInfo");
					nZones1=mpNailInfo.getInt("nZone1");
					dSpacingEdge1=mpNailInfo.getDouble("dPerimeter1");
					dSpacingCenter1=mpNailInfo.getDouble("dIntermediate1");
					sNailType1=mpNailInfo.getString("sNailType1");
				}
			}
		}
		
		ptBaseDimHor=ptBaseDimHor-vy*dOffsetBetweenLn;
		Point3d ptNail = ptBaseDimHor;
		Point3d ptNail2 = ptNail-vy*dOffsetBetweenLn;
		ptNail.transformBy(ms2ps);
		ptNail2.transformBy(ms2ps);
		
		if(shAll.length() == 0)
			dp.draw("Cladding Nailing: N/A", ptNail,  _XW,_YW, 1,0);
		else
			dp.draw("Cladding Nailing: Perimeter "+dSpacingEdge1+"mm" +" / Intermediate " +dSpacingCenter1+"mm", ptNail,  _XW,_YW, 1,0);
		
		if (nYesNoNailingType)
		{
			dp.draw("Nail Type: " + sNailType1, ptNail2,  _XW,_YW, 1,0);
		}
	}
	
//Show Diagonal of Wall -------------------------------------
	
	Plane pn(ptOrgEl, vz);

	// get PP
	/*
	 PlaneProfile pp(pn);
	 PlaneProfile ppContour(pn);
	 PlaneProfile ppAllBm[0];
   
	 for (int i = 0 ; i < bmAll.length(); i++)
	{
	  Body bd=bmAll[i].realBody();
	  PlaneProfile ppBm(pn);
	  PlaneProfile ppBmContour(ppBm);
	  ppBm = bd.shadowProfile(pn);
	  ppAllBm.append(ppBm);
	  ppBmContour= bd.shadowProfile(pn);
	  ppBmContour.shrink(-U(5));
	  ppContour.unionWith(ppBmContour);
	  }
  
	  ppContour.shrink(U(5));
  
	// find outer contour
	 PLine plContour, plAllContour[0];
	 plAllContour = ppContour.allRings();
 
	 for (int i = 0 ; i < plAllContour.length(); i++)
	  if (plAllContour[i].area() > plContour.area())
	   plContour = plAllContour[i];
	 
	 ppContour = PlaneProfile(plContour);
	 ppContour.vis(1); 
  

	PLine plElement=plContour;
	*/

	Point3d ptExtEle[] =plConvexHull.vertexPoints(TRUE); 
	if (nYesNoHeadBinder)
	{
//		for (int i=0; i<bmHeadbinder.length(); i++)
//		{
//			Beam bm=bmHeadbinder[i];
//			Body bd = bm.realBody();
//			Point3d ptExtremeHB[] = bd.extremeVertices(vx);
//			if (ptExtremeHB.length()>0)
//				ptExtEle.append(ptExtremeHB);
//		}
	}
	
	Point3d ptMit;
	ptMit.setToAverage(ptExtEle);
	
 	Point3d ptStart1,ptStart2,ptEnd1,ptEnd2;
	double dDistance1, dDistance2;
 	PLine plDiag1, plDiag2;

	 if(ptExtEle.length()>2)//If element is not a triangle
	{
  		for(int j=0; j<ptExtEle.length();j++)
		{
  		 	for(int k=0; k<ptExtEle.length();k++)
			{
   				 if((ptExtEle[j]-ptExtEle[k]).length()>dDistance1
   				&&k!=j
   				&&(k-j)!=1
  				&&(j-k)!=1)
   				{
     					dDistance1=(ptExtEle[j]-ptExtEle[k]).length();
   			 		ptStart1=ptExtEle[j];
     					ptEnd1=ptExtEle[k];
   				}
     
  			}
 		}
		
		//Display vectors
		Vector3d vecXDiag (ptEnd1 - ptStart1);
		vecXDiag.normalize();
		Vector3d vecYDiag = vz.crossProduct(vecXDiag);
		vecYDiag.normalize();
		
		if(vy.dotProduct(vecYDiag)< 0)
			vecYDiag = - vecYDiag;
			
		if(vx.dotProduct(vecXDiag)< 0)
			vecXDiag = - vecXDiag;
		
		DimLine dlDiagonal ( ptStart1, vecXDiag ,vecYDiag );
		Dim dimDiagonal (dlDiagonal, ptStart1, ptEnd1);
		dimDiagonal.transformBy(ms2ps);
		
		if(nYesNoDiagonal==0)//Yes
		{
			dp.draw(dimDiagonal);
		}
		else if (nYesNoDiagonal==2)// As text on top
		{
			LineSeg ls(ptStart1, ptEnd1);
			ls.transformBy(ms2ps);
			Point3d ptDiagTextDisp= ptBaseDimHorTop;
			ptDiagTextDisp.transformBy(ms2ps);
			double dDiagonalLength=(ptStart1-ptEnd1).length();
			String sDiagonalLength;
			//sDiagonalLength.format("Diagonal: %4.0f", dDiagonalLength);
			sDiagonalLength.formatUnit(dDiagonalLength, sDimLayout);
			//dp.draw (ls);
			
			dp.draw("Diagonal: "+ sDiagonalLength, ptDiagTextDisp, _XW, _YW, 1, 1);
		}
	}

//Angled Dimension
if(nYesNoAngularDim)
{
	Vector3d vecAngle[0];
	int nAngle=FALSE;
	Point3d ptAngled[0];
	for (int i=0; i<ptExtEle.length(); i++)
	{
		int iN = i==ptExtEle.length()-1 ? 0 : i+1;
		
		int isParallelToVx = abs((ptExtEle[i]-ptExtEle[iN]).normal().dotProduct(vx)) > 0.99;
		int isParallelToVy = abs((ptExtEle[i]-ptExtEle[iN]).normal().dotProduct(vy)) > 0.99;
		//ptExtEle[i].vis(i);
		//ptExtEle[iN].vis(i);
		
		if (!(isParallelToVx  || isParallelToVy))
		{

			nAngle=TRUE;
			ptAngled.append(ptExtEle[i]);
			ptAngled.append(ptExtEle[iN]);
		}
	}
	
	for( int i=0; i<ptAngled.length(); i++ )
	{
		Point3d ptAux1=ptAngled[i];
		ptAux1.transformBy(ms2ps);
		ptAux1.vis(i);
	}
	for( int i=0; i<ptAngled.length()-2; i+=2 )
	{
		if (ptAngled.length()>2)
		{
			Vector3d vecLin (ptAngled[i]-ptAngled[i+1]);
			vecLin.normalize();
			Vector3d vecNext (ptAngled[i+2]-ptAngled[i+3]);
			vecNext.normalize();
			double asd = abs(vecLin.dotProduct(vecNext));
		  	if (abs(vecLin.dotProduct(vecNext))>0.99)
			{
			   	ptAngled.removeAt(i+2);
 				ptAngled.removeAt(i+1);
 			 	i -= 2;
			} 
		}
		
	}

	for (int i=0; i<ptAngled.length()-1; i+=2)
	{
		Vector3d vecDirection=ptAngled[i+1]-ptAngled[i];
		vecDirection.normalize();
		Point3d ptToDim[0];
		if (vecDirection.dotProduct(vx)<0)
		{
			vecDirection=-vecDirection;
			ptToDim.append(ptAngled[i+1]);
			ptToDim.append(ptAngled[i]);
			
		}
		else
		{
			ptToDim.append(ptAngled[i]);
			ptToDim.append(ptAngled[i+1]);
		}
		
		Vector3d vecOffset=vecDirection.crossProduct(el.vecZ());

		if (vy.dotProduct(vecOffset)<0)
			vecOffset=-vecOffset;
		
		
		Point3d ptAux1=ptAngled[i];
		Point3d ptAux2=ptAngled[i+1];
		ptAux1.transformBy(ms2ps);
		ptAux2.transformBy(ms2ps);
		ptAux1.vis(1);
		ptAux2.vis(1);
		
		DimLine dimLine(ptAngled[i]+vecOffset*abs(dOffsetFromEl), vecDirection, vecOffset);
		Dim dim(dimLine, ptToDim, "<>", "<>", _kDimDelta);
		dim.transformBy(ms2ps);
		dp.draw(dim);
			
	}//next i
}
	
	///////////////////////////

	
	
	//Dimension the Beams that have contact with the andgle plates
	Beam bmToDimAngle[0];
	for (int i=0; i<bmAll.length(); i++)
	{
		for (int j=0; j<bmFemale.length(); j++)
		{
			if (bmAll[i].vecX().isPerpendicularTo(vx) && bmAll[i].hasTConnection(bmFemale[j], 0.1, TRUE))
			{
				bmToDimAngle.append(bmAll[i]);
			}
		}
	}
	
	if (nYesNoBm==1)
	{
		for (int i=0; i<bmToDimAngle.length(); i++)
		{
			Beam bm=bmToDimAngle[i];
			Body bdBeam=bm.realBody();
			Point3d ptAux[]=bdBeam.extremeVertices(vy);
			Point3d ptH=ptAux[ptAux.length()-1];
			Point3d ptExt[]=bdBeam.allVertices();
			Point3d ptBmToDim[0];
			Line lnBm (bm.ptCen(), vy);
			ptExt=lnBm.projectPoints(ptExt);
			ptExt=lnBm.orderPoints(ptExt, U(1, 0.03));
			
			Vector3d vecDirDim=vx;
			if (vx.dotProduct(bm.ptCen()-ptH)<0)
				vecDirDim=-vecDirDim;
			
			if (ptExt.length()<3)
				continue;
			
			ptBmToDim.append(ptExt[0]);
			
			if (bLongShort)
			{
				vecDirDim=-vecDirDim;
				ptBmToDim.append(ptExt[ptExt.length()-2]);
			}
			else
			{
				ptBmToDim.append(ptExt[ptExt.length()-1]);
			}
	
			
			// dimline
			DimLine dlBm(bm.ptCen()- vecDirDim*dDimOffBM, vy, -vx);
			Dim dimBeam (dlBm, ptBmToDim, "<>",  "<>", _kDimDelta,_kDimNone );
	
			double dBmLength=abs(bm.vecX().dotProduct(ptBmToDim[0]-ptBmToDim[ptBmToDim.length()-1]));
			String sDim;
			sDim.formatUnit(dBmLength, 2, 0);
			
			if (vx.dotProduct(vecDirDim)>0)
				dimBeam.setDeltaOnTop(TRUE);
			else
				dimBeam.setDeltaOnTop(FALSE);
	
			dimBeam.transformBy(ms2ps);
			dp.draw(dimBeam);
			
			//Point3d ptToDisp=bm.ptCen()+ vecDirDim*(dDimOffBM);
			//ptToDisp.transformBy(ms2ps);
			//dp.draw("("+sDim+")", ptToDisp, _YW, -_XW, 0, 0);
		}
	}
	
	if(nYesNoBm==2)
	{
		for (int i=0; i<bmToDimAngle.length(); i++)
		{
			Beam bm=bmToDimAngle[i];
			Body bdBeam=bm.realBody();
			Point3d ptAux[]=bdBeam.extremeVertices(vy);
			Point3d ptH=ptAux[ptAux.length()-1];
			Point3d ptExt[]=bdBeam.allVertices();
			Point3d ptBmToDim[0];
			Line lnBm (bm.ptCen(), vy);
			ptExt=lnBm.projectPoints(ptExt);
			ptExt=lnBm.orderPoints(ptExt, U(1, 0.03));
			
			Vector3d vecDirDim=vx;
			if (vx.dotProduct(bm.ptCen()-ptH)<0)
				vecDirDim=-vecDirDim;
			
			if (ptExt.length()<3)
				continue;
			
			ptBmToDim.append(ptExt[0]);
			
			if (bLongShort)
			{
				vecDirDim=-vecDirDim;
				ptBmToDim.append(ptExt[ptExt.length()-2]);
			}
			else
			{
				ptBmToDim.append(ptExt[ptExt.length()-1]);
			}
			

			double dBmLength=abs(bm.vecX().dotProduct(ptBmToDim[0]-ptBmToDim[ptBmToDim.length()-1]));
			String sDim;
			sDim.formatUnit(dBmLength, 2, 0);
			sDim="("+sDim+")";
			Point3d ptToDisp=bm.ptCen()+ vecDirDim*dDimOffBM;	
			ptToDisp.transformBy(ms2ps);
			dp.draw(sDim, ptToDisp, _YW, -_XW, 0, 0);
		
		}
	}

//Dimension the Angle Top Plate and the Angle Bottom Plate
if (nYesNoAngle)
{
	Beam bmAngLeft[0];
	Beam bmAngRight[0];
	for (int i=0; i<bmAll.length(); i++)
	{
		if (bmAll[i].type()==_kSFAngledTPLeft)
		{
			bmAngLeft.append(bmAll[i]);
		}
		else if (bmAll[i].type()==_kSFAngledTPRight)
		{
			bmAngRight.append(bmAll[i]);
		}
	}
	Vector3d vDimDir=_XW;
	vDimDir.transformBy(ps2ms);
	vDimDir.normalize();
	
	for (int i=0; i<bmAngLeft.length(); i++)
	{
		Beam bm=bmAngLeft[i];
		Point3d ptCenter=bm.ptCen();
		Point3d ptToDimAng[0];

		Vector3d vecXBm=bm.vecX();
		if (vecXBm.dotProduct(vDimDir)<0)
			vecXBm=-vecXBm;
			
		Vector3d vecZBm=vz.crossProduct(vecXBm);
		vecZBm.normalize();
		
		Body bdBeam=bm.realBody();
		Point3d ptExt[]=bdBeam.allVertices();
		Point3d ptUp[0];

		Line lnUp (ptCenter, vecXBm);

		ptUp=lnUp.orderPoints(ptExt);
		if (ptUp.length()>1)
		{
			ptToDimAng.append(ptUp[0]);
			ptToDimAng.append(ptUp[ptUp.length()-1]);
		}

		if (ptToDimAng.length()>1)
		{
			DimLine dlBmAng(bm.ptCen()+ vecZBm*dDimOffBM, vecXBm, vecZBm);
			Dim dimBeamAng (dlBmAng, ptToDimAng, "<>",  "<>", _kDimDelta, _kDimNone);
			//dimBeam.setDeltaOnTop(TRUE);
			dimBeamAng.transformBy(ms2ps);
			dp.draw(dimBeamAng);
		}
	}
	for (int i=0; i<bmAngRight.length(); i++)
	{
		Beam bm=bmAngRight[i];
		Point3d ptCenter=bm.ptCen();
		Point3d ptToDimAng[0];
		
		Vector3d vecXBm=bm.vecX();
		if (vecXBm.dotProduct(vDimDir)<0)
			vecXBm=-vecXBm;
		Body bdBeam=bm.realBody();
		
		Vector3d vecZBm=vz.crossProduct(vecXBm);
		vecZBm.normalize();
		
		Point3d ptExt[]=bdBeam.allVertices();
		Point3d ptUp[0];

		Line lnUp (ptCenter, vecXBm);
		
		ptUp=lnUp.orderPoints(ptExt);

		if (ptUp.length()>1)
		{
			ptToDimAng.append(ptUp[0]);
			ptToDimAng.append(ptUp[ptUp.length()-1]);
		}

		if (ptToDimAng.length()>1)
		{
			DimLine dlBmAng(bm.ptCen()+ vecZBm*dDimOffBM, vecXBm, vecZBm);
			Dim dimBeamAng (dlBmAng, ptToDimAng, "<>",  "<>", _kDimDelta, _kDimNone);
			dimBeamAng.transformBy(ms2ps);
			dp.draw(dimBeamAng);
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Small improvements." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="76" />
      <str nm="DATE" vl="8/22/2024 10:52:16 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Support dimStyle presision on diagonal text." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="75" />
      <str nm="DATE" vl="8/2/2024 2:08:27 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End