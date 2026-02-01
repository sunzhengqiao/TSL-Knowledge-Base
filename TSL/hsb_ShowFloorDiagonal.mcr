#Version 8
#BeginDescription
Shows a diagonal dimension for floor cassettes.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 29.04.2021  -  version 1.3


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 11.04.2011
* version 1.0: Release Version
*
* date: 06.07.2011
* version 1.1: Fix direction of Text
*
* date: 24.11.2014
* version 1.2: Add filter by code
*
* date: 24.11.2021
* version 1.3: Change extractContactFaceInPlane for shadowProfile
*/

Unit(1,"mm"); // script uses mm

int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

PropString strDimStyle(0,_DimStyles ,"Dim style");
PropDouble dbTH(0,1,"Text Heigth");

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to calculate diagonal"));
int nZoneIndex=nRealZones[nValidZones.find(nZones, 0)];

PropString sFilterExcludeBMC(1,"",T("Exclude Beam With BeamCode"));
sFilterExcludeBMC.setDescription(T("Set the code of the extra beams that you want to show int the beam dimension at the bottom of the panel. To add more than 1 use ';' after each code"));

PropInt iColor(1,3,"Color");

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
		
	Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
	_Viewport.append(vp);

	return;
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(1));

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;


String arSCodeBeams[0];

String s = sFilterExcludeBMC + ";";
int nIndex = 0;
int sIndex = 0;
while(sIndex < s.length()-1)
{
 	String sToken = s.token(nIndex);
	nIndex++;
	if(sToken.length()==0)
	{
		sIndex++;
		continue;
	}
	sIndex = s.find(sToken,0);	
	sToken.trimLeft();
	sToken.trimRight();
	sToken.makeUpper();
	arSCodeBeams.append(sToken);
}


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();

Display dp(iColor); // use color red
dp.dimStyle(strDimStyle, ps2ms.scale()); // dimstyle was adjusted for display in paper space, sets textHeight
dp.textHeight(dbTH);

//Vectors in paper space
Vector3d vxps = _XW;//vx; vxps.transformBy(ms2ps);
Vector3d vyps = _YW;//vy; vyps.transformBy(ms2ps);
Vector3d vzps = _ZW;//vz; vzps.transformBy(ms2ps);



//******/*********/*********
// collect the items

Point3d ptEnv[0];
if (nZoneIndex!=0)
{
	Sheet arSheet[0];
	arSheet = el.sheet(nZoneIndex);
	for (int i=0; i<arSheet.length(); i++)
	{
		// loop over list items
		Sheet sh = arSheet[i];

		PLine plEnv = sh.plEnvelope();
		ptEnv.append(plEnv.vertexPoints(TRUE));
	}
}

//oooooooooooooooooooooooooooooo
Beam arBm[] = el.beam();
if (arBm.length()<=0)
	return;

Plane pn(el.ptOrg(), el.vecZ());


// get PP
PlaneProfile pp(pn);
PlaneProfile ppContour(pn);

for (int i = 0 ; i < arBm.length(); i++)
{
	Beam bm=arBm[i];
	String sBMCode=bm.beamCode().token(0);
	sBMCode.makeUpper();
	if (arSCodeBeams.find(sBMCode, -1) != -1)
	{
		continue;
	}
	
	Body bd = bm.envelopeBody(false, true);
	PlaneProfile ppBm(pn);
	ppBm = bd.shadowProfile(pn); //ppBm = bd.extractContactFaceInPlane(pn, U(5));
	ppBm.shrink(-U(5));
	ppContour.unionWith(ppBm);
}
ppContour.shrink(U(5));

// find outer contour
PLine plContour, plAllContour[0];
plAllContour = ppContour.allRings();
	
for (int i = 0 ; i < plAllContour.length(); i++)
	if (plAllContour[i].area() > plContour.area())
		plContour = plAllContour[i];
	
ppContour = PlaneProfile(plContour);
		
PLine plElement=plContour;//Best

Point3d ptExtEle[0];
if (nZoneIndex==0)
{
	ptExtEle=plElement.vertexPoints(TRUE);
}
else
{
	ptExtEle=ptEnv;
}


/////////////////Diagonal
Point3d ptStart1,ptStart2,ptEnd1,ptEnd2;
double dDistance1, dDistance2;
PLine plDiag1, plDiag2;

if(ptExtEle.length()>2)
{//If element is not a triangle
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
}


Point3d ptDiagonal[0];
ptDiagonal.append(ptStart1);
ptDiagonal.append(ptEnd1);

Vector3d vecDirec(ptStart1-ptEnd1);
vecDirec.normalize();

Vector3d vXText=vecDirec;
vXText.transformBy(ms2ps);
if (vxps.dotProduct(vXText)<0)
{
	vecDirec=-vecDirec;
	vXText=-vXText;
}

Vector3d vecDirec1(vzps.crossProduct (vXText));
vecDirec1.transformBy(ps2ms);
vecDirec1.normalize();

vecDirec1.vis(ptStart1);


// dimline
DimLine dlDiag(ptStart1, vecDirec, vecDirec1);
Dim dimDiag (dlDiag, ptDiagonal, "<>",  "<>", _kDimDelta, _kDimNone);
//dimDiag.setDeltaOnTop(TRUE);
dimDiag.transformBy(ms2ps);
//dimDiag .setReadDirection(_ZW);

dp.draw(dimDiag);



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