#Version 8
#BeginDescription
Creates dimensions in wall elevation layout for studs, sheeting, openings, blocking and show some wall information like nailing offset, frame weight and wall description.
v1.61: 11.oct.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 61
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

* v1.0: 15.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from hsb_A4 Layout, to keep US content folder naming standards
	- Thumbnail added
* v1.56: 15.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.56, to keep updated with hsb_A4 Layout
* v1.57: 24.mar.2013: David Rueda (dr@hsb-cad.com)
	- Option to show vertical dimline names: "Blocking", "Opening", "Wall height" (No/Yes)
	- Option to move vertical blocking dimline to left/right side of element 
	- Offset from element for vertical blocking dimline (when at left side)
	- Option to define dimpoints for blocking dimension line (bottom, center or top of blocking)
* v1.58: 26.mar.2013: David Rueda (dr@hsb-cad.com)
	- Bugfix: Dimensioning of opening was not OK, corrected to be size of rough opening.
	- Applied dimstyle to opening dimensioning (when text on center of opening)	
* v1.59: 07.apr.2013: David Rueda (dr@hsb-cad.com)
	- Dimline for openings now split: one delta and one cummulus
	- PropDouble "Offset for cummulative opening dimension" added (separate 2 resulting dimlines from item before)
	- Added _kSFVeryTopPlate type to nBmTypeValidForConvex array
* v1.60: 09.oct.2013: David Rueda (dr@hsb-cad.com)
	- Running dimension values now is offset from _Pt0 instead from element's origin
	- Running dimension lines now is offset from _Pt0 instead from element's origin
	- Added "Show Delta Opening Dimension" (yes/no) property
* v1.61: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- Added "Show Element Dimension" (Yes/No) property
	- Show jacks length at side of beam center
	- Applied formatUnit jacks length
	- Applied formatUnit rough opening size
	- Applied formatUnit header/sill length
*/

int nLunits=U(2,4);
int nPrec=U(2,3);

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

PropString strShowElementDimLine(43,sArYesNo,T("Show Element Dimension"));
int nShowElementDimLine=sArYesNo.find(strShowElementDimLine);

String sArMode[] = {T("Line and Text"), T("Dimension Line")};
PropString sMode(31, sArMode, T("Show as"),0);
int nRunningMode= sArMode.find(sMode, 0);

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
int nYesNo=strYesNoDiag.find(strYesNoDim );

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
int nZone=-1;
if (nLocZone>0)
{
	nZone=nRealZones[nLocZone-1];
}

PropString sFilterBC(6,"",T("Filter sheets by material"));

PropDouble dOffsetFromEl (4, U(150, 8), T("Offset From Element"));
PropDouble dOffsetBetweenLn (5, U(150, 8), T("Offset Between Text Lines"));
PropDouble dOffsetBottomDim (6, U(0, 0), T("Offset Bottom Dimension/Text From PickPoint"));
PropDouble dOffsetTopDim (10, U(150, 6), T("Offset Top Text From PickPoint in VP Units"));

PropDouble dOffsetRunningDim (11, U(100, 6), T("Offset Running Dimension"));
double dOffsetRunDim=dOffsetRunningDim; 
PropDouble dOffsetStudReferences (13, U(60, 6), T("Offset Stud References"));
PropDouble dLengthBeamLine(12, U(250, 6), T("Length Running Dimension Lines"));

PropDouble dOffsetHorOpDim (7, U(0, 0), T("Offset Horizontal Opening Dim"));
dOffsetHorOpDim.setDescription(T("This Offset apply when the dim line is in the middle of the opening"));

String strHeaderDesc[]={T("From Details"),T("From Beam Name"), T("From Beam Size"),T("No")};
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
int nYesNoWindowSize= sArYesNo.find(sYesNoWindowSize, 0);

PropString strDimOpCummulative (16,sArYesNo,T("Show Cummulative Opening Dimension"), 0);
int nDimOpCummulative = sArYesNo.find(strDimOpCummulative, 0);

PropString strDimOpDelta (42,sArYesNo,T("Show Delta Opening Dimension"), 0);
int nDimOpDelta = sArYesNo.find(strDimOpDelta, 0);

PropDouble dOffsetCummulativeOpeningDimension(15,0,"      "+T("|Offset for cummulative opening dimension|"),0);

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
nBmTypeValidForConvex.append(_kSFVeryTopPlate); //DR 07.apr.2013

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
		
Beam bmHor[] = vy.filterBeamsPerpendicularSort(bmAll);
Beam bmAux[] = vy.filterBeamsParallel(bmAll);
Beam bmVer[] = vx.filterBeamsPerpendicularSort(bmAux);

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

	Body bdBmVP=bm.envelopeBody();
	bdBmVP.transformBy(ms2ps);
	bdBmVP.vis();

	int nBeamType=bm.type();
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
	for (int j=i+1; j<bmToDimBottom.length(); j++)
		if (bmToDimBottom[i]==bmToDimBottom[j])
		{
			bmToDimBottom.removeAt(j);
			j--;
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
	
	if (nStartEnd!=3)
	{
		//Collect Dim Points
		Point3d ptDim [] = dml.collectDimPoints(bmVer, nType);
		
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
	
			dp.draw(nDist, ptToDisp - _YW*dTextY *nRow, _XW , _YW, 1,1);
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
			
			if (bm.dD(vx)<bm.dD(vz))
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
					dpHatch.color(bm.color());
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
	//dOffsetRunDim+=U(40); commented out DR: 09.oct.2013

//Beams location of last point-------------------------------------

	Beam arBmaux[0];
	//Point3d ptVerBot [0];
	Beam bmToDim[0];
	bmToDimBottom.append(bmJacksAboveOp);
	bmToDimBottom=vx.filterBeamsPerpendicularSort(bmToDimBottom);
	
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
	for (int i=0; i<bmToDim.length(); i++)
	{
		int nBeamType=bmToDim[i].type();
		if (nBmTypeToAvoid.find(nBeamType, -1) != -1)
		{
			bmToDim.removeAt(i);
			i--;
		}
	}
	
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
	if (nZone!=-1)
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
	
	Point3d ptSheetTop = ptToHeight+ vy*dOffsetFromEl;//reference point
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
			PlaneProfile plSheet = bdSheet.shadowProfile(plSheet);
			PLine plSheets [] = plSheet.allRings();
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

ElemText et[0];
et = el.elemTexts(); 

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
		int nTmpLUnits=U(0,3);
		
		String sOPRealW;
		sOPRealW.formatUnit(dOPRealW, sDimLayout); // DR 11.oct.2013

		String sOPRealH;
		sOPRealH.formatUnit(dOPRealH, sDimLayout); // DR 11.oct.2013
		
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
	
	// Define extrems of rough opening DR 26.mar.2013
	Point3d ptSearchRoughLimits=ptCenterOp+op.coordSys().vecZ()*U(25,1);// DR 26.mar.2013

	ptMostLeftOp=ptMostLeftOp-vx*dGapSideOp;
	Beam bmTmp[]=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptSearchRoughLimits,-vx); // DR 26.mar.2013
	if(bmTmp.length()>0) // dr 26.mar.2013
	{
		Beam bmOpLeft=bmTmp[0];
		Point3d ptOpRoughLeft=bmOpLeft.ptCen()+vx*bmOpLeft.dD(vx)*.5;
		ptMostLeftOp+=vx*vx.dotProduct(ptOpRoughLeft-ptMostLeftOp);

		ptOpRoughLeft.transformBy(ms2ps);ptOpRoughLeft.vis();
		Body bdBmOpLeft=bmOpLeft.envelopeBody();
		bdBmOpLeft.transformBy(ms2ps);
		bdBmOpLeft.vis(1);
	}
	
	ptMostRightOp=ptMostRightOp+vx*dGapSideOp;
	bmTmp=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptSearchRoughLimits,vx); // DR 26.mar.2013
	if(bmTmp.length()>0) // dr 26.mar.2013
	{
		Beam bmOpRight=bmTmp[0];
		Point3d ptOpRoughRight=bmOpRight.ptCen()-vx*bmOpRight.dD(vx)*.5;
		ptMostRightOp+=vx*vx.dotProduct(ptOpRoughRight-ptMostRightOp);

		ptOpRoughRight.transformBy(ms2ps);ptOpRoughRight.vis();
		Body bdBmOpRight=bmOpRight.envelopeBody();
		bdBmOpRight.transformBy(ms2ps);
		bdBmOpRight.vis(1);
	}
	
	ptMostUpOp=ptMostUpOp+vy*dGapTopOp;
	bmTmp=Beam().filterBeamsHalfLineIntersectSort(bmHor, ptSearchRoughLimits,vy); // DR 26.mar.2013
	if(bmTmp.length()>0) // dr 26.mar.2013
	{
		Beam bmOpTop=bmTmp[0];
		Point3d ptOpRoughTop=bmOpTop.ptCen()-vy*bmOpTop.dD(vy)*.5;
		ptMostUpOp+=vy*vy.dotProduct(ptOpRoughTop-ptMostUpOp);

		ptOpRoughTop.transformBy(ms2ps);ptOpRoughTop.vis();
		Body bdBmOpTop=bmOpTop.envelopeBody();
		bdBmOpTop.transformBy(ms2ps);
		bdBmOpTop.vis(1);
	}

	ptMostDownOp=ptMostDownOp-vy*dGapBottomOp;
	bmTmp=Beam().filterBeamsHalfLineIntersectSort(bmHor, ptSearchRoughLimits,-vy); // DR 26.mar.2013
	if(bmTmp.length()>0) // dr 26.mar.2013
	{
		Beam bmOpBottom=bmTmp[0];
		Point3d ptOpRoughBottom=bmOpBottom.ptCen()+vy*bmOpBottom.dD(vy)*.5;
		ptMostDownOp+=vy*vy.dotProduct(ptOpRoughBottom-ptMostDownOp);

		ptOpRoughBottom.transformBy(ms2ps);ptOpRoughBottom.vis(1);
		Body bdBmOnBottom=bmOpBottom.envelopeBody();
		bdBmOnBottom.transformBy(ms2ps);bdBmOnBottom.vis(1);
	}

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
			sHeight.formatUnit(dHeaderHeight, 2, 0);
			String sText=nNumberOfHeaders+"/"+dHeaderWidth+"x"+sHeight+"x"+dHeaderLength;
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
	//if (nDimOpCummulative) DR: 07.apr.2013
		//nDimType=_kDimBoth; DR: 07.apr.2013
	
	if (nDimOpeningLocHor==0 || nDimOpeningLocHor==2) // center / center and below
	{
		//Dim dimOpenings(dimLnOpenings, ptOpDimBottom,"<>","<>", _kDimPar, _kDimNone); // def in MS
		Dim dimOpenings(dimLnOpenings, ptOpDimBottom,"<>","<>", nDimType); // def in MS
		dimOpenings.transformBy(ms2ps); // transfrom the dim from MS to PS
		dp.draw(dimOpenings);
	}
	if (nDimOpeningLocHor==1 || nDimOpeningLocHor==2) // below / center and below
	{
		Line lnOpBellowEl (ptBaseDimHor, vx);
		ptOpDimBottom= lnOpBellowEl.projectPoints(ptOpDimBottom);
		ptOpDimBottom= lnOpBellowEl.orderPoints(ptOpDimBottom);
		
		// Delta
		if(nDimOpDelta) // DR: 09.oct.2013
		{
			DimLine dimLnOpeningsBellowElDelta(ptBaseDimHor, vx, vy);
			Dim dimOpeningsBellowElDelta(dimLnOpeningsBellowElDelta, ptOpDimBottom,"<>","<>", nDimType); // def in MS
			dimOpeningsBellowElDelta.transformBy(ms2ps); // transfrom the dim from MS to PS
			dp.draw(dimOpeningsBellowElDelta);
		}
		
		// Cummulus DR: 07.apr.2013
		if (nDimOpCummulative) // DR: 07.apr.2013
		{	
			DimLine dimLnOpeningsBellowElCumm(ptBaseDimHor+vy*dOffsetCummulativeOpeningDimension, vx, vy);
			Dim dimOpeningsBellowElCumm(dimLnOpeningsBellowElCumm, ptOpDimBottom,"<>","<>", _kDimCumm); // def in MS
			dimOpeningsBellowElCumm.transformBy(ms2ps); // transfrom the dim from MS to PS
			dp.draw(dimOpeningsBellowElCumm);
		}
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
	
	if(nShowElementDimLine) // DR:11.oct.2013
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
		DimLine dlBot (ptOrgEl, vx, vy);
		Line lnBot(ptOrgEl, vx);
		//bmToDim.append(bmJacksAboveOp);
		
		Point3d ptVerBot[] = dlBot.collectDimPoints(bmToDim, nTypeBot);
		ptVerBot.append(ptMostLeft);
		ptVerBot.append(ptMostRight);
		ptVerBot.append(ptOpDimBottom);
		//Sort the points
		ptVerBot=lnBot.projectPoints(ptVerBot);
		ptVerBot=lnBot.orderPoints(ptVerBot);
		
		int nSystemRepresentation = U(2,4);
		double dLast=0;
		String sLast;
		if(nRunningMode==0)
		{
			for(int i = 0; i<ptVerBot.length(); i ++)
			{
				PLine plDimBmLast;//line of dimension
				Point3d ptPs = ptVerBot[i];//point to display the dimension

				//paperspace
				if ( sSpace == sPaperSpace )
				{
					_Pt0.vis();
					Viewport vp;
					if (_Viewport.length()==0) return; // _Viewport array has some elements
					vp = _Viewport[_Viewport.length()-1]; // take last element of array
					_Viewport[0] = vp; // make sure the connection to the first one is lost	
					
					//Displaying value
					dLast = abs(vx.dotProduct(ptStartEl - ptVerBot[i]));
					sLast.formatUnit(dLast, nSystemRepresentation, 0);
					ptPs.transformBy(ms2ps);
					ptPs+=_YW*(_YW.dotProduct(_Pt0-ptPs)+dOffsetBeamDim);
					plDimBmLast.addVertex(ptPs );
					plDimBmLast.addVertex(ptPs + _YW*dLengthBeamLine);
					dpStuds.draw(sLast, ptPs,  _YW, -_XW, 1,1.4 );
					dp.draw(plDimBmLast);
				}
				else // modelspace
				{
					ptPs=ptPs- vy*(dOffsetBeamDim+dLengthBeamLine);
		
					plDimBmLast.addVertex(ptPs );
					plDimBmLast.addVertex(ptPs + vy*dLengthBeamLine);
		
					
					ptPs.transformBy(ms2ps);
					//Displaying value
					dLast = abs(vx.dotProduct(ptStartEl - ptVerBot[i]));
					sLast.formatUnit(dLast, nSystemRepresentation, 0);
					
					dpStuds.draw(sLast, ptPs,  _YW, -_XW, 1,1.4 );
					
					plDimBmLast.transformBy(ms2ps);
					//Displaying polyline
					dp.draw(plDimBmLast);
				}
			}//next i
		}
		else if(nRunningMode==1)
		{
			if (ptVerBot.length()>1)
			{
				ptVerBot.append(ptStartEl);
				
				
				Point3d ptPs = ptVerBot[0];//point to display the dimension
				ptPs=ptPs- vy*(dOffsetBeamDim);
	
				
				DimLine dl (ptPs, vx, vy);
				
				Line ln (ptPs, vx);
				ptVerBot=ln.projectPoints(ptVerBot);
				ptVerBot=ln.orderPoints(ptVerBot);
				
				Dim dim(dl, ptVerBot,"<>","<>", _kDimNone, nRunningType);
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
//		sDim.formatUnit(dBmLength, 2, 0); // DR: 11.oct.2013
		sDim.formatUnit(dBmLength, nLunits,nPrec); // DR: 11.oct.2013
//		Point3d ptToDisp=bm.ptCen()+ el.vecY()*U(40); // DR: 11.oct.2013
		Point3d ptToDisp=bm.ptCen()-vx*(bm.dD(vx)*.5+U(12,.5)) ; // DR: 11.oct.2013
		ptToDisp.transformBy(ms2ps);
		dp.draw(sDim, ptToDisp, _YW, -_XW, 0, 1);
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
		//sHeaderHeight.format("%4.0f", dHeightHeader);
		sHeaderHeight.formatUnit(dHeightHeader,nLunits,nPrec); // DR: 11.oct.2013

		Point3d ptSill=ptSillHeight[nLocOp];
		double dSillHeader=vy.dotProduct(ptOpDimSide[i+1]-ptMostDown);
		String sSillHeight;
//		sSillHeight.format("%4.0f", dSillHeader);
		sSillHeight.formatUnit(dSillHeader,nLunits,nPrec); // DR: 11.oct.2013

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
// TODO
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
	
		if (nYesNo==2)//Diag as text on top
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
		for (int i=0; i<bmHeadbinder.length(); i++)
		{
			Beam bm=bmHeadbinder[i];
			Point3d ptExtremeHB[]=bm.realBody().allVertices();
			if (ptExtremeHB.length()>0)
				ptExtEle.append(ptExtremeHB);
		}
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
		
		if(nYesNo==0)//Yes
		{
			dp.draw(dimDiagonal);
		}
		else if (nYesNo==2)// As text on top
		{
			LineSeg ls(ptStart1, ptEnd1);
			ls.transformBy(ms2ps);
			Point3d ptDiagTextDisp= ptBaseDimHorTop;
			ptDiagTextDisp.transformBy(ms2ps);
			double dDiagonalLength=(ptStart1-ptEnd1).length();
			String sDiagonalLength;
			sDiagonalLength.format("Diagonal: %4.0f", dDiagonalLength);
			//dp.draw (ls);
			dp.draw(sDiagonalLength, ptDiagTextDisp, _XW, _YW, 1, 1);
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
		
		if (!((ptExtEle[i]-ptExtEle[iN]).isParallelTo(vx) || (ptExtEle[i]-ptExtEle[iN]).isParallelTo(vy)))
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

return;
#End
#BeginThumbnail
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
/`"BBB@`HHHH`****`/_9
`




#End
