#Version 8
#BeginDescription
GE_PLOT_TAG_CUT_UNCUT_SHEATHING
v1.0: 07.jul.2014: David Rueda (dr@hsb-cad.com)
Tags 'X' uncut sheathing pieces and '/ ' to cut pieces (default values are 8'x 4' but user can modify it)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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

* v1.0: 07.jul.2014: David Rueda (dr@hsb-cad.com)
	- Release
*/

U(1, "inch");
double dTolerance=U(.01);

String sNoYes[] = {T("No"), T("Yes")};

PropDouble dL1 (0, U(96), T("Sheathing length"));
PropDouble dW1 (1, U(48), T("Sheathing width"));
PropString sDrawSheathingPLine(0,sNoYes,T("|Draw Sheathing Perimeter|"),1);
int nDrawPLine=sNoYes.find(sDrawSheathingPLine,0);

String sColors[0]; int nColors[0];
sColors.append(T("|Dark Brown|")+" ("+"32)");					nColors.append(32);
sColors.append(T("|Light Brown|")+" ("+"40)");					nColors.append(40);
sColors.append(T("|White|"));										nColors.append(0);
sColors.append(T("|Red|"));										nColors.append(1);
sColors.append(T("|Yellow|"));									nColors.append(2);
sColors.append(T("|Green|"));										nColors.append(3);
sColors.append(T("|Cyan|"));										nColors.append(4);
sColors.append(T("|Blue|"));										nColors.append(5);
sColors.append(T("|Magenta|"));									nColors.append(6);
sColors.append(T("|Black|"));										nColors.append(7);
PropString sColor(1, sColors, T("|Color|"), 7);
int nIndex= sColors.find(sColor, 7);
int nColor= nColors[nIndex];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport(T("Select a viewport")));
	showDialog(T("|_Default|"));
	return;
}

if (_Viewport.length()==0) 
	return;

Viewport vp= _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) 
	return;

_Pt0=vp.ptCenPS()-_XW*vp.widthPS()*.5-_YW*vp.heightPS()*.5;

_Pt0.vis();

setMarbleDiameter(U(1));


int nZoneIndex;
Entity entAll[0];	

// coordSys
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();
Element el= vp.element();
nZoneIndex = vp.activeZoneIndex();

if( !el.bIsValid() )return;

//Element vectors
CoordSys csEl=el.coordSys();
Point3d ptElOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

//CoordSys coordvp = vp.coordSys();
Vector3d VecX = ms2ps.vecX();
Vector3d VecY = ms2ps.vecY();
Vector3d VecZ = ms2ps.vecZ();

Display dp(nColor);
Sheet shAll[]=el.sheet();

double dArea=dL1*dW1;

for(int s=0;s<shAll.length();s++)
{
	Sheet sh=shAll[s];
	if( !sh.bIsValid())
	{
		continue;
	}

	PLine plSh=sh.plEnvelope();
	double dShArea= plSh.area()/(U(1)*U(1));
	PLine plShPS=plSh;
	plShPS.transformBy(ms2ps);
	if(nDrawPLine)
		dp.draw(plShPS);

	Point3d ptAll[]=plSh.vertexPoints(1);
	if( ptAll.length()==4 && abs(dArea-dShArea)<dTolerance) // Sheet has only 4 vertex and needed area but don't know if has proper sizes, might be uncut piece
	{
		double dL= sh.solidLength();
		double dW= sh.solidWidth();
		if( 
			(
				abs(dL-dL1)<dTolerance 
				&& 
				abs(dW-dW1)<dTolerance
			) 
		|| 
			(
				abs(dL-dW1)<dTolerance 
				&& 
				abs(dW-dL1)<dTolerance
			)
		) // Is uncut piece
		{
			PLine pl1(ptAll[0],ptAll[2]);
			pl1.transformBy(ms2ps);
			dp.draw(pl1);
			PLine pl2(ptAll[1],ptAll[3]);
			pl2.transformBy(ms2ps);
			dp.draw(pl2);
		}
	}
	else // is cut piece, must find extreme vertex to draw single line
	{
		// Find most lower point
		double dMinY=U(100000), dMaxY=-U(1);
		Point3d ptBottom, ptTop;
		for(int p=0;p<ptAll.length();p++)
		{
			Point3d pt=ptAll[p];
			if(dMinY>pt.Z())
			{
				dMinY=pt.Z();
				ptBottom=pt;

			}
			if(dMaxY<pt.Z())
			{
				dMaxY=pt.Z();
				ptTop=pt;
			}
		}
		
		// Get all bottoms and tops to search most left
		Point3d ptAllBottoms[0],ptAllTops[0];
		for(int p=0;p<ptAll.length();p++)
		{
			Point3d pt=ptAll[p];
			if(abs(ptBottom.Z()-pt.Z())<dTolerance)
			{
				ptAllBottoms.append(pt);
			}
			if(abs(ptTop.Z()-pt.Z())<dTolerance)
			{
				ptAllTops.append(pt);
			}
		}
		
		// Search most left point of bottoms
		Point3d ptBottomLeft;
		double dMinX=U(100000);
		for(int p=0;p<ptAllBottoms.length();p++)
		{
			Point3d pt=ptAllBottoms[p];
			if(dMinX>vx.dotProduct(pt-ptElOrg))
			{
				dMinX=vx.dotProduct(pt-ptElOrg);
				ptBottomLeft=pt;
			}
		}
		
		// Search most right point of tops
		Point3d ptTopRight;
		double dMaxX=0;
		for(int p=0;p<ptAllTops.length();p++)
		{
			Point3d pt=ptAllTops[p];
			if(dMaxX<vx.dotProduct(pt-ptElOrg))
			{
				dMaxX=vx.dotProduct(pt-ptElOrg);
				ptTopRight=pt;
			}
		}
		
		PLine plDiag(ptBottomLeft,ptTopRight);
		plDiag.transformBy(ms2ps);
		dp.draw(plDiag);
	}
}

return;
#End
#BeginThumbnail

#End
