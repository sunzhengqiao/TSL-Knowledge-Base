#Version 8
#BeginDescription
Draw and X on the opening that have a point load over them.

Modified by: Chirag Sawjani (cs@itw-industry.com)
Date: 25.05.2011 - version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
* Created by: Chirag Sawjani (cs@itw-industry.com)
* date: 25.05.2011
* version 1.0: Release Version
*/


Unit(1,"mm"); // script uses mm

PropString psDimstyle(0,_DimStyles,"Enter a Dimstyle");

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	PrEntity ssE("\n"+T("Select an Opening"),Opening());
	
	if(ssE.go())
	{
		Entity ent[]=ssE.set();
		for(int i=0;i<ent.length();i++)
		{
			Entity eCurr=ent[0];
			Opening op=(Opening)eCurr;
			if(op.bIsValid())
			{
				_Opening.append(op);
			}
		}
	}
	return;
}

Display dp1(1);
Display dp2(1);
dp2.dimStyle(psDimstyle);

CoordSys cs;
Point3d ptOpOrig;
Element el;
Opening op;
Vector3d vx;
Vector3d vy;
Vector3d vz;
double dOpWidth;
double dOpHeight;

if(_Opening.length()>0)
{
		op=_Opening[0];
		cs=op.coordSys();
		el=op.element();
		ptOpOrig=cs.ptOrg();
		vx=cs.vecX();
		vy=cs.vecY();
		vz=cs.vecZ();
		dOpWidth=op.width();
		dOpHeight=op.height();
		
		//Check if a TSL instance already exists in the opening
		TslInst tslOpening[]=op.tslInstAttached();
		for(int i=0;i<tslOpening.length();i++)
		{
			TslInst tsl=tslOpening[i];
			if(tsl.scriptName()==_ThisInst.scriptName() && tsl.handle()!=_ThisInst.handle())
			{
				eraseInstance();
				return;
			}
		}

}
else
{
	eraseInstance();
	return;
}

cs.vis();
//Get Opening Outline
PLine plOpening=op.plShape();
Point3d ptOpVertices[]=plOpening.vertexPoints(true);

Line lnHorizontal(ptOpOrig,vx);
Line lnVertical(ptOpOrig,vy);

Point3d ptHorizontalPoints[]=lnHorizontal.orderPoints(ptOpVertices);
Point3d ptVerticalPoints[]=lnVertical.orderPoints(ptOpVertices);

//Find the bottom left point
Line lnBottomHorizontal;
Point3d ptBottom;
Point3d ptBottomLeft;
if(ptVerticalPoints.length()>0)
{
	ptBottom=ptVerticalPoints[0];
	lnBottomHorizontal=Line(ptBottom,vx);
}
if(ptHorizontalPoints.length()>0)
{
	ptBottomLeft=lnBottomHorizontal.closestPointTo(ptHorizontalPoints[0]);
}

//Create Cross in Elevation
LineSeg lsCross1(ptBottomLeft,ptBottomLeft+(dOpWidth*vx)+(dOpHeight*vy));
LineSeg lsCross2(ptBottomLeft+(dOpWidth*vx),ptBottomLeft+(dOpHeight*vy));
_Pt0=lsCross1.ptMid();
//Do not show cross in plan view
dp1.addHideDirection(vy);
dp1.draw(lsCross1);
dp1.draw(lsCross2);

//Do not show text in any view except plan and elevation
dp2.addViewDirection(vy);
dp2.addViewDirection(vz);
String strWarning="PL Above Opening";
Point3d ptTextPosition=lsCross1.ptMid()+(U(5)*vy)-(U(200)*vz);
dp2.draw(strWarning,ptTextPosition,vx,vz,0,0,_kDevice);

assignToElementGroup(el, TRUE, 0, 'I');

#End
#BeginThumbnail


#End
