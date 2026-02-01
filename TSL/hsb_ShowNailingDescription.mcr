#Version 8
#BeginDescription
Shows nailing specification for Perimeter and Intermediate for a stickframe wall, which has been applied by "hsb_Apply Naillines to Elements"

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 26.09.2013  -  version 1.6




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
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
* date: 14.10.2009
* version 1.0: 	First Release
*
* date: 29.03.2010
* version 1.1:		Add the Option to show the Nail Type
*
* date: 29.03.2010
* version 1.2:		Remove the Nail Type if there is no nail type available.
*
* date: 11.05.2011
* version 1.3:		Remove the Nail Type if there is no nail type available.
*
* date: 06.02.2013
* version 1.5:		Remove the filter of the TSL name to get the nailing information.
*
* date: 26.09.2013
* version 1.6:		Add property for text height.
*/


//Units
U(1,"mm");

String sArYesNo[] = {T("No"), T("Yes")};

int nZones[]={1,2,3,4,5,6,7,8,9,10};
PropInt nZone (0, nZones, T("Nailing Zone"), 0);

PropString sDimLayout (0,_DimStyles,T("Dim Style"));

PropDouble dNewTextHeight (1, -1, T("Text Height"));
dNewTextHeight.setDescription(T("-1 will use default text height"));

PropDouble dOffsetBetweenLn (0, U(5), T("Offset Between Text Lines"));

PropString sYesNoNailingType (1,sArYesNo,T("Show Nailing Type"),0);
int nYesNoNailingType = sArYesNo.find(sYesNoNailingType, 0);

PropString sPrefix(2,"Cladding Nailing: ",T("Nailing Description Prefix"));

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	_Pt0=getPoint(T("Pick a Point To Locate the Description"));
	_Viewport.append(getViewport(T("Select a viewport")));
	
	showDialogOnce();
	
	return;

}//end bOnInsert

setMarbleDiameter(U(0.1));

if( _Viewport.length() == 0 ){
	eraseInstance();
	return;
}

Viewport vp = _Viewport[0];

CoordSys ms2ps = vp.coordSys();

CoordSys ps2ms = ms2ps; ps2ms.invert();

Element el = vp.element();
if( !el.bIsValid() )return;

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Beam bmAll [] = el.beam();
if (bmAll.length()<1)
	return;

Sheet shAll[]=el.sheet();

Display dp(-1);
dp.dimStyle(sDimLayout, ps2ms.scale());

if (dNewTextHeight!=-1)
{
	dp.textHeight(dNewTextHeight);
}
//dp.dimStyle(sDimLayout);

double dSpacingEdge1;
double dSpacingCenter1;
int nZones1;
String sNailType1;

TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	//String sTSLName=tslAll[i].scriptName();
	//sTSLName.makeLower();
	//if ( sTSLName == "hsb_apply naillines to elements")
	//{
		Map mpTSL=tslAll[i].map();
		if (mpTSL.hasMap("NailingInfo"))
		{
			String sZone="nZone"+nZone;
			String sPerimeter="dPerimeter"+nZone;
			String sIntermediate="dIntermediate"+nZone;
			String sNailType="sNailType"+nZone;
			Map mpNailInfo=mpTSL.getMap("NailingInfo");
			nZones1=mpNailInfo.getInt(sZone);
			dSpacingEdge1=mpNailInfo.getDouble(sPerimeter);
			dSpacingCenter1=mpNailInfo.getDouble(sIntermediate);
			sNailType1=mpNailInfo.getString(sNailType);
		}
	//}
}

Point3d ptNail = _Pt0;
Point3d ptNail2= ptNail-_YW*dOffsetBetweenLn;

if(shAll.length() == 0)
	dp.draw("Cladding Nailing: N/A", ptNail,  _XW,_YW, 1,0);
else
	dp.draw(sPrefix+"Perimeter "+dSpacingEdge1+"mm" +" / Intermediate " +dSpacingCenter1+"mm", ptNail,  _XW,_YW, 1,-1);

if (nYesNoNailingType && sNailType1!="")
{
	dp.draw("Nail Type: " + sNailType1, ptNail2,  _XW,_YW, 1,-1);
}







#End
#BeginThumbnail








#End
