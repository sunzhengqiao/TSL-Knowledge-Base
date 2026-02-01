#Version 8
#BeginDescription
Creates a table of Wall Number,Description,Height,Thickness,Length,Weight,Area for Stickframe walls in the modelspace

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 30.01.2019  -  version 2.5
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
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
* date: 10.06.2008
* version 1.0: Release Version
*
* date: 11.06.2008
* version 1.1: Add the option to define multiple wall types and sort by columns
*
* date: 12.06.2008
* version 1.2: Round the values and sort by wall column
*
* date: 12.06.2008
* version 1.3: Change the origin Point

* date: 18.09.2008
* version 1.4: 	Change the Name from "hsb_Panel Schedule Weight" to "Wall Panel Schedule"
*				Change the way to analize the weight of the Panel, now use km/m3.
*
* date: 18.09.2008
* version 1.5: Add Properties for the weight
*
* date: 13.02.2009
* version 1.6: Change the Name on the Properties for the weight of the material
*
* date: 31.03.2009
* version 1.7: Add the Desciption and the Area of the Panel
*
* date: 31.03.2009
* version 1.8: Change name from "Wall Panel Schedule" to "hsb_WallPanelSchedule" and add m2 to the Area
*
* date: 31.03.2009
* version 1.9: Add the description to the properties and chage the table Text Color
*
* date: 01.04.2009
* version 2.0: Allow the TSL to run from the Palette
*
* date: 23.04.2009
* version 2.1: Create the shape of the sheeting using Plane profile instead of ProfNeto of the zone.
*
* date: 10.03.2010
* version 2.2: BugFix with the area of the panel.
*
* date: 21.03.2011
* version 2.3: Calculate the size of the panel base on the beams
*
* date: 20.03.2011
* version 2.4: 	Now the weight will be read from the MapX of the element
*				Option to display ON/OFF diferent columns
*/

Unit (1, "mm");

String sArNY[] = {T("No"), T("Yes")};

//Sheets
//String sSheetName[0];//={"9MM OSB3", "Glidevale TF200(Green)"};  //Name of the Sheet
//double dWeightFactorSheet[0];//={610, 100};  // This Factor is the weight(kg) per cubic meter

int arNZoneToShow[] = {10,9,8,7,6,0,1,2,3,4,5};
int arNZone[] = {-5,-4,-3,-2,-1,0,1,2,3,4,5};
PropInt nPropZone(0,arNZoneToShow,T("Area of Zone"), 5);
nPropZone.setDescription("Please select the zone that is going to be used to calculate the Area of the Element");

PropString sShowDescription(0,sArNY,T("Show Description"), 1);
PropString sShowHeight(1,sArNY,T("Show Height"), 1);
PropString sShowLength(2,sArNY,T("Show Length"), 1);
PropString sShowThickness(11,sArNY,T("Show Thickness"), 1);
PropString sShowWeight(3,sArNY,T("Show Weight"), 1);
PropString sShowArea(4,sArNY,T("Show Area"), 1);

PropString sTitle(5, "Panel Schedule", T("|Table Title|"));

PropString sDimStyle(6,_DimStyles,T("|Dimstyle|"));
PropInt nColor (1, 7, T("|Table Text Color|"));
PropInt nTitleColor (2, 4, T("|Title Color|"));
PropInt nHeaderColor (3, -1, T("|Header Color|"));
PropInt nLineColor(4, -1, T("|Line Color|"));

//PropString

int arNSortKeys[] = {0, 1, 2, 3, 4, 5};                                                   //////////////////////////////////////////////////
String arSSortKeys[] = {T("Wall"), T("Description"), T("Height"), T("Length"), T("Weight"), T("Area")};   //T("Type"),
PropString sPrimarySortKey(7, arSSortKeys, T("Primary sortkey"));

PropString sSecondarySortKey(8, arSSortKeys, T("Secondary sortkey"));

PropString sTertiarySortKey(9, arSSortKeys, T("Tertiary sortkey"));

int arBTrueFalse[] = {TRUE, FALSE};
String arSSortMode[] = {T("Ascending"), T("Descending")};
PropString sSortMode(10, arSSortMode, T("Sort mode"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=arNZone[arNZoneToShow.find(nPropZone)];

int nPrimarySortKey = arNSortKeys[ arSSortKeys.find(sPrimarySortKey,0) ];
int nSecondarySortKey = arNSortKeys[ arSSortKeys.find(sSecondarySortKey,0) ];
int nTertiarySortKey = arNSortKeys[ arSSortKeys.find(sTertiarySortKey,0) ];
int bAscending = arBTrueFalse[arSSortMode.find(sSortMode,0)];

int bShowDescription = sArNY.find(sShowDescription, 0);
int bShowHeight = sArNY.find(sShowHeight, 0);
int bShowLength = sArNY.find(sShowLength, 0);
int bShowThickness = sArNY.find(sShowThickness, 0);
int bShowWeight = sArNY.find(sShowWeight, 0);
int bShowArea = sArNY.find(sShowArea, 0);

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();	

	_Pt0=getPoint("Pick a Point");

	PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}

 	if (_Element.length()== 0)eraseInstance();
	return;
}

if( _Element.length()==0 ){eraseInstance(); return;}


///////////////////////////////////
// display
Display dp(nColor);
dp.dimStyle(sDimStyle);
LineSeg ls(_Pt0-_XW*U(5), _Pt0+_XW*U(5));
LineSeg ls1(_Pt0-_YW*U(5), _Pt0+_YW*U(5));
dp.draw(ls);
dp.draw(ls1);


double dTotalArea;
double dTotalVolume;

//Used for sorting
String arSPrimarySort[0];
String arSSecondarySort[0];
String arSTertiarySort[0];

//Columns
String sWallNumber[0];
String sWallType[0];                  ///////////////////////////////////
String sWallHeight[0];
String sWallLength[0];
String sWallThickness[0];
String sWallWeight[0];
String sWallArea[0];

int nNrOfRows = 0;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	Point3d ptEl = csEl.ptOrg();
	//ptEl.vis(2);
	Plane plnZ (csEl.ptOrg(), vz);
	
	Vector3d vXTxt = _XW;
	Vector3d vYTxt = _YW;
	String strElCode=el.definition();
	String strElNumber=el.number();
	
	LineSeg ls=el.segmentMinMax();
	
	//double dHeightEl=abs(vy.dotProduct(ls.ptStart()-ls.ptEnd()));
	//double dLengthEl=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
	
	
	double dWeight=0;

	Sheet shAll[]=el.sheet();
	
	Beam bmAll[]=el.beam();
	
	Map mpElInfo=el.subMapX("HSB_ElementInfo");
	
	if (mpElInfo.hasDouble("TotalWeight"))
	{
		dWeight=mpElInfo.getDouble("TotalWeight");
	}
	
	PlaneProfile ppOutline (csEl);
	for (int i=0; i<bmAll.length(); i++)
	{
		
		Beam bm=bmAll[i];
		//Create the shape of the beams
		PlaneProfile ppBm(plnZ);
		//ppBm=bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, U(20));
		ppBm=bm.realBody().shadowProfile(plnZ);
		ppBm.shrink(-U(2));
		
		ppBm.transformBy(U(0.01)*vx.rotateBy(i*123.456,vz));
		int a=ppOutline.unionWith(ppBm);

	}
	
	ppOutline.shrink(U(2));
	
	LineSeg lsTop=ppOutline.extentInDir(vy);
	LineSeg lsLength=ppOutline.extentInDir(vx);
	
	double dHeightEl=abs(vy.dotProduct(lsTop.ptStart()-lsTop.ptEnd()));
	double dLengthEl=abs(vx.dotProduct(lsLength.ptStart()-lsLength.ptEnd()));

	double dThicknessEl = 0;
	for (int i=-5; i<6; i++)
	{ 
		ElemZone elZone = el.zone(i);
		dThicknessEl += elZone.dH();
	}

	ppOutline.vis(1);
	
	//Set the shape of the element in a diferent Plane Profile
	PLine plAll[]=ppOutline.allRings();
	PlaneProfile ppEl(csEl);
	
	if (plAll.length()>0 && nZone==0)
	{
		int dMaxArea=0;
		PLine plOutline;
		for (int i=0; i<plAll.length(); i++)
		{
			if (plAll[i].area()>dMaxArea)
			{
				dMaxArea=plAll[i].area();
				plOutline=plAll[i];
			}
		}
		ppEl.joinRing (plOutline, FALSE);
	}
	else
	{
		Sheet shEl[]=el.sheet(nZone);
		for (int i=0; i<shEl.length(); i++)
		{
			//Create the shape of the sheet
			PlaneProfile ppSh(plnZ);
			//ppBm=bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, U(20));
			ppSh.joinRing (shEl[i].plEnvelope(), FALSE);
			ppSh.shrink(-U(2));
			
			ppSh.transformBy(U(0.01)*vx.rotateBy(i*123.456,vz));
			int a=ppEl.unionWith(ppSh);
	
		}
		//ppEl=el.profNetto(nZone);
	}
	
	double dArea=ppEl.area()/(U(1)*U(1));
	
	dArea=dArea/1000000;
	
	String sArea;
	sArea.formatUnit(dArea,2,2);
	sArea=sArea+ " m2";

	String strHeight;
	strHeight.formatUnit(dHeightEl, 2, 0);

	String strThickness;
	strThickness.formatUnit(dThicknessEl, 2, 0);

	String strLength;
	strLength.formatUnit(dLengthEl, 2, 0);

	String strWeight;
	strWeight.formatUnit(dWeight, 2, 0);
	strWeight=strWeight+ " Kg";
	
	//Append the information to the arrays
	sWallNumber.append(strElNumber);
	sWallType.append(strElCode);                                  /////////////////////////////////////////////
	sWallHeight.append(strHeight);
	sWallLength.append(strLength);
	sWallThickness.append(strThickness);
	sWallWeight.append(strWeight);
	sWallArea.append(sArea);
		
	//Wall
	arSPrimarySort.append(strElNumber);
	arSSecondarySort.append(strElNumber);
	arSTertiarySort.append(strElNumber);
	//Type
	arSPrimarySort[nNrOfRows] = arSPrimarySort[nNrOfRows]+";"+strElCode;                       //////////////////////
	arSSecondarySort[nNrOfRows] = arSSecondarySort[nNrOfRows]+";"+strElCode;              ///////////////////////
	arSTertiarySort[nNrOfRows] = arSTertiarySort[nNrOfRows]+";"+strElCode;                    //////////////////////////
	//Height
	arSPrimarySort[nNrOfRows] = arSPrimarySort[nNrOfRows]+";"+strHeight;
	arSSecondarySort[nNrOfRows] = arSSecondarySort[nNrOfRows]+";"+strHeight;
	arSTertiarySort[nNrOfRows] = arSTertiarySort[nNrOfRows]+";"+strHeight;
	//Thickness
	arSPrimarySort[nNrOfRows] = arSPrimarySort[nNrOfRows]+";"+strThickness;
	arSSecondarySort[nNrOfRows] = arSSecondarySort[nNrOfRows]+";"+strThickness;
	arSTertiarySort[nNrOfRows] = arSTertiarySort[nNrOfRows]+";"+strThickness;
	//Length
	arSPrimarySort[nNrOfRows] = arSPrimarySort[nNrOfRows]+";"+strLength;
	arSSecondarySort[nNrOfRows] = arSSecondarySort[nNrOfRows]+";"+strLength;
	arSTertiarySort[nNrOfRows] = arSTertiarySort[nNrOfRows]+";"+strLength;
	//Weight
	arSPrimarySort[nNrOfRows] = arSPrimarySort[nNrOfRows]+";"+strWeight;
	arSSecondarySort[nNrOfRows] = arSSecondarySort[nNrOfRows]+";"+strWeight;
	arSTertiarySort[nNrOfRows] = arSTertiarySort[nNrOfRows]+";"+strWeight;
	//Area
	arSPrimarySort[nNrOfRows] = arSPrimarySort[nNrOfRows]+";"+sArea;
	arSSecondarySort[nNrOfRows] = arSSecondarySort[nNrOfRows]+";"+sArea;
	arSTertiarySort[nNrOfRows] = arSTertiarySort[nNrOfRows]+";"+sArea;


	nNrOfRows++;	

}


//Time to sort
for(int i=0;i<nNrOfRows;i++){
	arSPrimarySort[i]  = arSPrimarySort[i] + ";" + 1;
	arSPrimarySort[i] = arSPrimarySort[i].token(nPrimarySortKey);
	arSSecondarySort[i]  = arSSecondarySort[i] + ";" + 1;
	arSSecondarySort[i] = arSSecondarySort[i].token(nSecondarySortKey);
	arSTertiarySort[i]  = arSTertiarySort[i] + ";" + 1;
	arSTertiarySort[i] = arSTertiarySort[i].token(nTertiarySortKey);
}
String sSort;
int nSort;
for(int s1=1;s1<nNrOfRows;s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		int bSort = arSTertiarySort[s11] > arSTertiarySort[s2];
		if( bAscending ){
			bSort = arSTertiarySort[s11] < arSTertiarySort[s2];
		}
		if( bSort ){
			sSort = arSPrimarySort[s2];		arSPrimarySort[s2] = arSPrimarySort[s11];			arSPrimarySort[s11] = sSort;
			sSort = arSSecondarySort[s2];	arSSecondarySort[s2] = arSSecondarySort[s11];	arSSecondarySort[s11] = sSort;
			sSort = arSTertiarySort[s2];		arSTertiarySort[s2] = arSTertiarySort[s11];			arSTertiarySort[s11] = sSort;

			sSort = sWallNumber[s2];		sWallNumber[s2] = sWallNumber[s11];			sWallNumber[s11] = sSort;
			sSort = sWallType[s2];			sWallType[s2] = sWallType[s11];					sWallType[s11] = sSort;
			sSort = sWallHeight[s2];			sWallHeight[s2] = sWallHeight[s11];				sWallHeight[s11] = sSort;
			sSort = sWallThickness[s2];		sWallThickness[s2] = sWallThickness[s11];			sWallThickness[s11] = sSort;
			sSort = sWallLength[s2];			sWallLength[s2] = sWallLength[s11];				sWallLength[s11] = sSort;
			sSort = sWallWeight[s2];			sWallWeight[s2] = sWallWeight[s11];				sWallWeight[s11] = sSort;
			sSort = sWallArea[s2];			sWallArea[s2] = sWallArea[s11];					sWallArea[s11] = sSort;

			s11=s2;
		}
	}
}
for(int s1=1;s1<nNrOfRows;s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		int bSort = arSSecondarySort[s11] > arSSecondarySort[s2];
		if( bAscending ){
			bSort = arSSecondarySort[s11] < arSSecondarySort[s2];
		}
		if( bSort ){
			sSort = arSPrimarySort[s2];		arSPrimarySort[s2] = arSPrimarySort[s11];			arSPrimarySort[s11] = sSort;
			sSort = arSSecondarySort[s2];	arSSecondarySort[s2] = arSSecondarySort[s11];	arSSecondarySort[s11] = sSort;
			sSort = arSTertiarySort[s2];		arSTertiarySort[s2] = arSTertiarySort[s11];			arSTertiarySort[s11] = sSort;

			sSort = sWallNumber[s2];		sWallNumber[s2] = sWallNumber[s11];			sWallNumber[s11] = sSort;
			sSort = sWallType[s2];			sWallType[s2] = sWallType[s11];					sWallType[s11] = sSort;
			sSort = sWallHeight[s2];			sWallHeight[s2] = sWallHeight[s11];				sWallHeight[s11] = sSort;
			sSort = sWallThickness[s2];		sWallThickness[s2] = sWallThickness[s11];			sWallThickness[s11] = sSort;
			sSort = sWallLength[s2];			sWallLength[s2] = sWallLength[s11];				sWallLength[s11] = sSort;
			sSort = sWallWeight[s2];			sWallWeight[s2] = sWallWeight[s11];				sWallWeight[s11] = sSort;
			sSort = sWallArea[s2];			sWallArea[s2] = sWallArea[s11];					sWallArea[s11] = sSort;

			s11=s2;
		}
	}
}
for(int s1=1;s1<nNrOfRows;s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		int bSort = arSPrimarySort[s11] > arSPrimarySort[s2];
		if( bAscending ){
			bSort = arSPrimarySort[s11] < arSPrimarySort[s2];
		}
		if( bSort ){
			sSort = arSPrimarySort[s2];		arSPrimarySort[s2] = arSPrimarySort[s11];			arSPrimarySort[s11] = sSort;
			sSort = arSSecondarySort[s2];	arSSecondarySort[s2] = arSSecondarySort[s11];	arSSecondarySort[s11] = sSort;
			sSort = arSTertiarySort[s2];		arSTertiarySort[s2] = arSTertiarySort[s11];			arSTertiarySort[s11] = sSort;

			sSort = sWallNumber[s2];		sWallNumber[s2] = sWallNumber[s11];			sWallNumber[s11] = sSort;
			sSort = sWallType[s2];			sWallType[s2] = sWallType[s11];					sWallType[s11] = sSort;
			sSort = sWallHeight[s2];			sWallHeight[s2] = sWallHeight[s11];				sWallHeight[s11] = sSort;
			sSort = sWallThickness[s2];		sWallThickness[s2] = sWallThickness[s11];			sWallThickness[s11] = sSort;
			sSort = sWallLength[s2];			sWallLength[s2] = sWallLength[s11];				sWallLength[s11] = sSort;
			sSort = sWallWeight[s2];			sWallWeight[s2] = sWallWeight[s11];				sWallWeight[s11] = sSort;
			sSort = sWallArea[s2];			sWallArea[s2] = sWallArea[s11];					sWallArea[s11] = sSort;

			s11=s2;
		}
	}
}



//Display
Display dpTitle(nTitleColor);
dpTitle.dimStyle(sDimStyle);
Display dpHeader(nHeaderColor);
dpHeader.dimStyle(sDimStyle);
Display dpLine(nLineColor);


int nNumberOfColumns=1;    //////////////////////////////////////////
if (bShowDescription) nNumberOfColumns++;
if (bShowHeight) nNumberOfColumns++;
if (bShowThickness) nNumberOfColumns++;
if (bShowLength) nNumberOfColumns++;
if (bShowWeight) nNumberOfColumns++;
if (bShowArea) nNumberOfColumns++;


//Create table-entries
//Row index
int nRowIndex = 0;
//Row height
double dRowHeight = 1.5 * dpHeader.textHeightForStyle("Max Weight", sDimStyle);

//Column width
double dColumnW = 1.25 * dpHeader.textLengthForStyle("Max Weight", sDimStyle);

int nColumnIndex=0;

int nIndexName=0;
int nIndexDesc=0;
int nIndexHeight=0;
int nIndexThickness = 0;
int nIndexLength=0;
int nIndexWeight=0;
int nIndexArea=0;


double dColumnWidthAr[0];//={dColumnW, dColumnW, dColumnW, dColumnW, dColumnW, dColumnW};
dColumnWidthAr.append(dColumnW);
nIndexName=0;
nColumnIndex++;

if (bShowDescription)
{
	dColumnWidthAr.append(dColumnW);
	nIndexDesc=nColumnIndex;
	nColumnIndex++;
}
if (bShowHeight) 
{
	dColumnWidthAr.append(dColumnW);
	nIndexHeight=nColumnIndex;
	nColumnIndex++;
}
if (bShowThickness) 
{
	dColumnWidthAr.append(dColumnW);
	nIndexThickness=nColumnIndex;
	nColumnIndex++;
}
if (bShowLength)
{
	dColumnWidthAr.append(dColumnW);
	nIndexLength=nColumnIndex;
	nColumnIndex++;
}
if (bShowWeight)
{
	dColumnWidthAr.append(dColumnW);
	nIndexWeight=nColumnIndex;
	nColumnIndex++;
}
if (bShowArea)
{	
	dColumnWidthAr.append(dColumnW);
	nIndexArea=nColumnIndex;
	nColumnIndex++;
}


for (int i=0; i<sWallNumber.length(); i++)
{
	//Wall Number
	if (dColumnWidthAr[nIndexName]<(1.25 * dpHeader.textLengthForStyle(sWallNumber[i], sDimStyle)))
		dColumnWidthAr[nIndexName]=1.25 * dpHeader.textLengthForStyle(sWallNumber[i], sDimStyle);
	//Wall Type
	if (bShowDescription)
	{
		if (dColumnWidthAr[nIndexDesc]<(1.25 * dpHeader.textLengthForStyle(sWallType[i], sDimStyle)))
			dColumnWidthAr[nIndexDesc]=1.25 * dpHeader.textLengthForStyle(sWallType[i], sDimStyle);
	}
	//Wall Height
	if (bShowHeight)
	{
		if (dColumnWidthAr[nIndexHeight]<(1.25 * dpHeader.textLengthForStyle(sWallHeight[i], sDimStyle)))
			dColumnWidthAr[nIndexHeight]=1.25 * dpHeader.textLengthForStyle(sWallHeight[i], sDimStyle);
	}
	//Wall Thickness
	if (bShowThickness)
	{
		if (dColumnWidthAr[nIndexThickness]<(1.25 * dpHeader.textLengthForStyle(sWallThickness[i], sDimStyle)))
			dColumnWidthAr[nIndexThickness]=1.25 * dpHeader.textLengthForStyle(sWallThickness[i], sDimStyle);
	}
	//Wall Length
	if (bShowLength)
	{
		if (dColumnWidthAr[nIndexLength]<(1.25 * dpHeader.textLengthForStyle(sWallLength[i], sDimStyle)))
			dColumnWidthAr[nIndexLength]=1.25 * dpHeader.textLengthForStyle(sWallLength[i], sDimStyle);
	}
	//Wall Weight
	if (bShowWeight)
	{
		if (dColumnWidthAr[nIndexWeight]<(1.25 * dpHeader.textLengthForStyle(sWallWeight[i], sDimStyle)))
			dColumnWidthAr[nIndexWeight]=1.25 * dpHeader.textLengthForStyle(sWallWeight[i], sDimStyle);
	}
	//Wall Area
	if (bShowArea)
	{
		if (dColumnWidthAr[nIndexArea]<(1.25 * dpHeader.textLengthForStyle(sWallArea[i], sDimStyle)))
			dColumnWidthAr[nIndexArea]=1.25 * dpHeader.textLengthForStyle(sWallArea[i], sDimStyle);
	}
}

double dColumnWidth;
for (int i=0; i<dColumnWidthAr.length(); i++) 
{ 
	dColumnWidth += dColumnWidthAr[i];
}


//Point in the midle between the Title and the Heager Row
Point3d ptOrgTable=_Pt0 - _YW * 2 * dRowHeight;
//Draw header of table
dpLine.draw( PLine(ptOrgTable + _YW * 2 * dRowHeight, ptOrgTable + _XW * dColumnWidth + _YW * 2 * dRowHeight) );
dpTitle.textHeight(1.5 * dRowHeight);
dpTitle.draw( sTitle, ptOrgTable + _XW * .5 * dColumnWidth + _YW * dRowHeight, _XW, _YW, 0, 0);
dpLine.draw( PLine(ptOrgTable, ptOrgTable + _XW * dColumnWidth) );
PLine plColumnBorder(ptOrgTable, ptOrgTable + _YW * 2 * dRowHeight);
dpLine.draw(plColumnBorder);
plColumnBorder.transformBy(_XW * dColumnWidth);
dpLine.draw(plColumnBorder);
//Draw column-names of table
Point3d ptTxt = ptOrgTable - _YW * nRowIndex * dRowHeight - _YW * .5 * dRowHeight;
double dCW=0;

dpHeader.draw( "Wall", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexName]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexName];
if(bShowDescription)
{ dpHeader.draw( "Description", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexDesc]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexDesc];}
if(bShowHeight) 
{dpHeader.draw( "Height", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexHeight]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexHeight];}
if (bShowThickness)
{dpHeader.draw( "Thickness", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexThickness]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexThickness];}
if(bShowLength) 
{dpHeader.draw( "Length", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexLength]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexLength];}
if(bShowWeight) 
{dpHeader.draw( "Max Weight", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexWeight]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexWeight];}
if(bShowArea) 
{dpHeader.draw( "Area", ptTxt + _XW * (dCW+dColumnWidthAr[nIndexArea]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexArea];}

plColumnBorder = PLine(ptOrgTable, ptOrgTable - _YW * dRowHeight);
dpLine.draw(plColumnBorder);
for( int i=0;i<nNumberOfColumns;i++ )
{
	plColumnBorder.transformBy(_XW * dColumnWidthAr[i]);
	dpLine.draw(plColumnBorder);
}

nRowIndex++;

for (int i=0; i<sWallNumber.length(); i++)
{	
	//Upper left corner of row
	Point3d ptRow = ptOrgTable - _YW * nRowIndex * dRowHeight;
	//Create PLine to draw as border of the row
	PLine plRowBorder(ptRow, ptRow + _XW * dColumnWidth);
	
	
	//Row border
	dpLine.draw(plRowBorder);
	//Column borders
	plColumnBorder.transformBy(-_XW * dColumnWidth - _YW * dRowHeight);
	dpLine.draw(plColumnBorder);
	for( int j=0; j<nNumberOfColumns; j++ )
	{
		plColumnBorder.transformBy(_XW * dColumnWidthAr[j]);
		dpLine.draw(plColumnBorder);
	}			
	//Display of the arrays o ptRow	
	Point3d ptTxt = ptRow - _YW * .5 * dRowHeight;
	
	//Show here the display
	double dCW=0;
	dp.draw( sWallNumber[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexName]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[nIndexName];
	if(bShowDescription) 
	{dp.draw( sWallType[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexDesc]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[nIndexDesc];}
	if(bShowHeight) 
	{dp.draw( sWallHeight[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexHeight]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[nIndexHeight];}
	if (bShowThickness)
	{dp.draw( sWallThickness[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexThickness]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[nIndexThickness];}
	if(bShowLength) 
	{dp.draw( sWallLength[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexLength]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[nIndexLength];}
	if(bShowWeight) 
	{dp.draw( sWallWeight[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexWeight]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[nIndexWeight];}
	if(bShowArea) 
	{dp.draw( sWallArea[i], ptTxt + _XW * (dCW+dColumnWidthAr[nIndexArea]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[nIndexArea];}
	//dpHeader.draw(nQty[i], ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dpHeader.draw(sDescription[i], ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);
	
	//Transform row border and Increase row-index
	plRowBorder.transformBy(-_YW * dRowHeight);
	nRowIndex++;
	
	//Border of last row
	if( nRowIndex > 0 ){
		dpLine.draw(PLine(ptOrgTable - _YW * nRowIndex * dRowHeight, ptOrgTable - _YW * nRowIndex * dRowHeight + _XW * dColumnWidth));
	}
}

//assignToElementFloorGroup(_Element[0], TRUE, 0, 'I');













#End
#BeginThumbnail
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
JHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`__9
`











#End