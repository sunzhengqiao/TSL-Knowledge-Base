#Version 8
#BeginDescription
Creates a list of the diferent components that are part of the zones of the element.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 13.05.2021 - version 1.1
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* date: 10.07.2013
* version 1.0: Release Version
*
* date: 13.05.2021
* version 1.1: Added the name of the insulation
*/

Unit (1, "mm");

PropString sTitle(0, "Element Components", T("|Table Title|"));

PropString sDimStyle(1,_DimStyles,T("|Dimstyle|"));

PropDouble dScale(2, 1, "   " + T("Scale"));	
PropDouble dPropCharSize(3, U(17),"   " + T("character size"));	

PropInt nColor (0, 1, T("|Table Text Color|"));
PropInt nTitleColor (1, 1, T("|Title Color|"));
PropInt nHeaderColor (2, 1, T("|Header Color|"));
PropInt nLineColor(3, 1, T("|Line Color|"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();	

	_Pt0=getPoint("Pick a Point");
	
	Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
	_Viewport.append(vp);

	return;
}

if (_Viewport.length()==0) 
{
	eraseInstance();
	return; // _Viewport array has some elements
}

Viewport vp;	
vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) 
	return;

//coordSys
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps;
ps2ms.invert();

Element el = vp.element();

if( !el.bIsValid() ){eraseInstance(); return;}



double dCharSize = dPropCharSize * dScale;

///////////////////////////////////
// display
Display dp(nColor);
dp.dimStyle(sDimStyle);
dp.textHeight(dCharSize);

LineSeg ls(_Pt0-_XW*U(.1), _Pt0+_XW*U(.1));
LineSeg ls1(_Pt0-_YW*U(.1), _Pt0+_YW*U(.1));
dp.draw(ls);
dp.draw(ls1);


//Levels Information
String sZones[0];
String sMaterials[0];
String sHeights[0];

int nNum=0;

for (int n=10; n>=-10; n--)
{
	String sZMaterial[0];
	String sZHeight[0];
	
	GenBeam gbmAll[]=el.genBeam(n);
	if (gbmAll.length()<1) continue;
	
	for (int i=0; i<gbmAll.length(); i++)
	{
		GenBeam gbm=gbmAll[i];
		double dHeight=gbm.dH();
		String sHeight;
		sHeight.formatUnit(dHeight, 2, 0);
			
		String sMaterial=gbm.material();
		sMaterial.trimLeft();
		sMaterial.trimRight();
		sMaterial.makeUpper();
		
		if (sMaterial=="INSULATION")
		{ 
			sMaterial="Insulation: "+ gbm.name();
			sMaterial.trimLeft();
			sMaterial.trimRight();
			sMaterial.makeUpper();
		}
		
		int nLoc=sZMaterial.find(sMaterial, -1);
		if (nLoc==-1)
		{
			sZMaterial.append(sMaterial);
			sZHeight.append(sHeight);
		}
		/*
		else
		{
			if (sZHeight.find(sHeight , -1) != nLoc)
			{
				sZMaterial.append(sMaterial);
				sZHeight.append(sHeight);				
			}
		}
		*/
	}
	
	if(sZMaterial.length()>0)
	{ 

		
		int nRealZone=n;
		if (n<0)
		{
			nRealZone=5-(n);
		}
		
		String sCombineMaterial;
		String sCombineHeight;
		
		for (int i=0; i<sZMaterial.length(); i++)
		{
			sCombineMaterial+=sZMaterial[i];
			sCombineHeight+=sZHeight[i];
			
			if (i<sZMaterial.length()-1)
			{
				sCombineMaterial+="/";
				sCombineHeight+="/";
			}
		}
		
		sZones.append("Z"+nRealZone);
		sMaterials.append(sCombineMaterial);
		sHeights.append(sCombineHeight);
	}
}

int nNrOfRows=sZones.length();

//Display
Display dpTitle(nTitleColor);
dpTitle.dimStyle(sDimStyle);

Display dpHeader(nHeaderColor);
dpHeader.dimStyle(sDimStyle);
dpHeader.textHeight(dCharSize);

Display dpLine(nLineColor);


int nNumberOfColumns=3;    //////////////////////////////////////////
//Create table-entries
//Row index
int nRowIndex = 0;
//Row height
//double dA=dpHeader.textHeightForStyle("Max Weight", sDimStyle);

double dRowHeight = 1.6 * dpHeader.textHeightForStyle("Max Weight", sDimStyle)*dScale;

//Column width
double dColumnW = 1.25 * dpHeader.textLengthForStyle("Max Weight", sDimStyle)*dScale;

double dColumnWidthAr[]={dColumnW, dColumnW, dColumnW};

for (int i=0; i<sZones.length(); i++)
{
	//Wall Group
	if (dColumnWidthAr[0]<(1.25 * dpHeader.textLengthForStyle(sZones[i], sDimStyle)*dScale))
		dColumnWidthAr[0]=1.25 * dpHeader.textLengthForStyle(sZones[i], sDimStyle)*dScale;
	//Wall Code
	if (dColumnWidthAr[1]<(1.25 * dpHeader.textLengthForStyle(sMaterials[i], sDimStyle)*dScale))
		dColumnWidthAr[1]=1.25 * dpHeader.textLengthForStyle(sMaterials[i], sDimStyle)*dScale;
	//Wall Height
	if (dColumnWidthAr[2]<(1.25 * dpHeader.textLengthForStyle(sHeights[i], sDimStyle)*dScale))
		dColumnWidthAr[2]=1.25 * dpHeader.textLengthForStyle(sHeights[i], sDimStyle)*dScale;
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
dpHeader.draw( "Zone", ptTxt + _XW * (dCW+dColumnWidthAr[0]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[0];
dpHeader.draw( "Material", ptTxt + _XW * (dCW+dColumnWidthAr[1]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[1];
dpHeader.draw( "Height", ptTxt + _XW * (dCW+dColumnWidthAr[2]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[2];

plColumnBorder = PLine(ptOrgTable, ptOrgTable - _YW * dRowHeight);
dpLine.draw(plColumnBorder);
for( int i=0;i<nNumberOfColumns;i++ ){
	plColumnBorder.transformBy(_XW * dColumnWidthAr[i]);
	dpLine.draw(plColumnBorder);
}

nRowIndex++;

for (int i=0; i<sZones.length(); i++)
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
	for( int j=0;j<nNumberOfColumns;j++ ){
		plColumnBorder.transformBy(_XW * dColumnWidthAr[j]);
		dpLine.draw(plColumnBorder);
	}			
	//Display of the arrays o ptRow	
	Point3d ptTxt = ptRow - _YW * .5 * dRowHeight;
	
	//Show here the display
	double dCW=0;

	int nFlag=TRUE;
	if (i>0)
	{
		if (sZones[i-1]==sZones[i])
			nFlag=FALSE;
	}

	if (nFlag)
		dp.draw( sZones[i], ptTxt + _XW * (dCW+dColumnWidthAr[0]*0.5), _XW, _YW, 0, 0);
	dCW+=dColumnWidthAr[0];
	dp.draw( sMaterials[i], ptTxt + _XW * (dCW+dColumnWidthAr[1]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[1];
	dp.draw( sHeights[i], ptTxt + _XW * (dCW+dColumnWidthAr[2]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[2];
	//dp.draw( sWallPitch[i], ptTxt + _XW * (dCW+dColumnWidthAr[3]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[3];
	//dp.draw( sWallLintel[i], ptTxt + _XW * (dCW+dColumnWidthAr[4]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[4];
	//dp.draw( sWallNailing[i], ptTxt + _XW * (dCW+dColumnWidthAr[5]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[5];
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