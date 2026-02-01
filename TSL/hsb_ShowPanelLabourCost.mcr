#Version 8
#BeginDescription
Displays labour cost of stickframe walls, based on area, shape and price defined in the properties. 

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 31.03.2009  -  version 1.3









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
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
* date: 02.03.2008
* version 1.0: Release Version
*
* date: 25.03.2008
* version 1.2: BugFix with the area of the Panel
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

PropString sDimStyle (0, _DimStyles, T("Dimension Style"));

PropString psExtType(1, "A;B;",  T("Code External Walls"));
psExtType.setDescription(T("Please type the codes of the external walls separate by ; "));
PropDouble dExtPriceOp(0, 3, T("Price for Opening on External Walls"));
PropDouble dExtPrice(1, 2, T("Price for External Walls"));
PropDouble dExtPriceGb(2, 2, T("Price for Gable External Walls"));
PropDouble dExtPriceDm(3, 2, T("Price for Dormer External Walls"));


PropString psIntType(2, "I;F;",  T("Code Internal Walls"));
psIntType.setDescription(T("Please type the codes of the internal walls separate by ; "));
PropDouble dIntPriceOp(4, 3, T("Price for Opening on Internal Walls"));
PropDouble dIntPrice(5, 2, T("Price for Internal Walls"));
PropDouble dMinHeight(6, 2000, T("Minimun Height"));
PropDouble dIntPriceSm(7, 3, T("Price Internal Wall when less than minimun height"));
PropDouble dIntPriceGb(8, 2, T("Price for Gable Internal Walls"));
PropDouble dIntPriceDm(9, 2, T("Price for Dormer Internal Walls"));

double dPriceOp[0];		dPriceOp.append(dExtPriceOp);		dPriceOp.append(dIntPriceOp);
double dPrice[0];			dPrice.append(dExtPrice);				dPrice.append(dIntPrice);
double dPriceGb[0];		dPriceGb.append(dExtPriceGb);		dPriceGb.append(dIntPriceGb);
double dPriceDm[0];		dPriceDm.append(dExtPriceDm);		dPriceDm.append(dIntPriceDm);


String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}


String sArrIntCode[0];
String sIntType=psIntType;
sIntType.trimLeft();
sIntType.trimRight();
sIntType=sIntType+";";
for (int i=0; i<sIntType.length(); i++)
{
	String str=sIntType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrIntCode.append(str);
}


//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if (_bOnInsert) {
	if (_kExecuteKey=="") {
		showDialogOnce();
	}
	Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
	_Viewport.append(vp);
	_Pt0=getPoint(T("Please Pick a Point"));
	return;
}



// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

//if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

Element el=vp.element();

if( !el.bIsValid() ){
	return;
}


//-----------------------------------------------------------------------------------------------------------------------------------
//                                      Loop over all elements.

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

Opening op[]=el.opening();

Beam bmAll[]=el.beam();

Display dp(-1); // use color of entity for frame
dp.dimStyle(sDimStyle);

int nPriceIndex=-1;

String sCode = el.code();
if( sArrExtCode.find(sCode) != -1 )
	nPriceIndex=0;
	
if( sArrIntCode.find(sCode) != -1 )
	nPriceIndex=1;


if (nPriceIndex==-1)
{
	return;
}
int nGableWall=FALSE;

Beam bmBottomPlate[0];
Beam bmAnglePlate[0];

String sTypes[0];
sTypes=_BeamTypes;

Plane plnZ (cs.ptOrg(), vz);
PlaneProfile ppOutline (cs);
for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	if (bm.type()==_kSFBottomPlate)
		bmBottomPlate.append(bm);
	if (bm.type()==54)
		bmAnglePlate.append(bm);
	if (bm.type()==55)
		bmAnglePlate.append(bm);
		
	//Create the shape of the beams
	PlaneProfile ppBm=bm.realBody().shadowProfile(plnZ);
	ppBm.shrink(-U(2));
	ppBm.transformBy(U(0.01)*vx.rotateBy(i*123.456,vz));
	ppOutline.unionWith(ppBm);
}

ppOutline.shrink(U(2));
PLine plAll[]=ppOutline.allRings();

PlaneProfile ppEl(cs);

if (plAll.length()>0)
{
	PLine plOutline=plAll[0];
	ppEl.joinRing (plOutline, FALSE);
}
else
{
	ppEl=el.profBrutto(0);
}
double dArea=ppEl.area()/(U(1)*U(1));

dArea=dArea/1000000;

LineSeg lsEl=ppEl.extentInDir(vx);

double dHeight=abs(vy.dotProduct(lsEl.ptStart()-lsEl.ptEnd()));
double dLegth=abs(vx.dotProduct(lsEl.ptStart()-lsEl.ptEnd()));

if (dHeight<dMinHeight)
	dPrice[1]=dIntPriceSm;



double dTotalPriceOp=op.length()*dPriceOp[nPriceIndex];
double dTotalPrice;

if (bmBottomPlate.length()>0) //Yes Bottom Plate
{
	if (abs(bmBottomPlate[0].vecX().dotProduct(el.vecX()))>0.99)//Align to the Element... no Dm
	{
		if (bmAnglePlate.length()>0) //Gable Panel
			dTotalPrice=dPriceGb[nPriceIndex]*dArea;
		else
			dTotalPrice=dPrice[nPriceIndex]*dArea;
	}
	else
	{
		dTotalPrice=dPriceDm[nPriceIndex]*dArea;
	}
}
else
{
	if (bmAnglePlate.length()>0) //Gable Panel
		dTotalPrice=dPriceGb[nPriceIndex]*dArea;
	else
		dTotalPrice=dPrice[nPriceIndex]*dArea;
}


dTotalPrice=dTotalPrice+dTotalPriceOp;


String str="LABOUR COST: ";

String sValue;
sValue.formatUnit(dTotalPrice, 2, 2);
dp.draw(str+sValue, _Pt0 , _XW, _YW, 1, 1);








#End
#BeginThumbnail
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
0H`****`"BBB@`HHHH`__V=&W
`


#End
