#Version 8
#BeginDescription
Creates a post with plates in zone 0 of a wall.

#Versions
Version 1.5    27.05.2021    HSB-12021 bugfix if amount of bottom and top rail are not of same length , Author Thorsten Huck















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 - 2017 by hsbcad
* 
*  The program may be used and/or copied only with the written
*  permission from hsbCAD, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
*
* Create by: Alberto Jena (aj@hsb-cad.com)
* date: 07.05.2014
* version 1.00 Release Version
* Create by: Anno Sportel (anno.sportel@hsbcad.com)
* date: 16.10.2014
* version 1.0: 
* Create by: Anno Sportel (anno.sportel@hsbcad.com)
* date: 10.02.2016
* version 1.02: Add split types and gap. 
* Create by: Anno Sportel (anno.sportel@hsbcad.com)
* date: 17.02.2016
* version 1.03: Correct property indexes. 
* Modified by: Anno Sportel (anno.sportel@hsbcad.com)
* date: 31.01.2017
* version 1.04: Set default sizes for post
*
*/
// #Versions
// 1.5 27.05.2021 HSB-12021 bugfix if amount of bottom and top rail are not of same length , Author Thorsten Huck





Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

double dTolerance=U(1);

PropString sProfile(0, ExtrProfile().getAllEntryNames(), T("|Extrusion profile name|"));
PropDouble postWidth(13, U(70), T("|Default post width|"));
postWidth.setDescription(T("|The default post width.|") + TN("|This is only used for rectangular and round extrusion profiles.|"));
PropDouble postHeight(14, U(70), T("|Default post height|"));
postHeight.setDescription(T("|The default post width.|") + TN("|This is only used for rectangular and round extrusion profiles.|"));

//Alignment
String arSAlign[] = {T("|Left|"), T("|Center|"), T("|Right|")};
int arNAlign[] = {0, 1, 2};
PropString sAlign(1, arSAlign, T("|Alignment|"),1);

PropDouble dOffsetTop(0, U(0), T("|Offset top|"));
PropDouble dOffsetBottom(1, U(0), T("|Offset bottom|"));

//Plate Top Properties
PropString sPlateTopSeparator(2, "", T("|Top plate|"),0);
sPlateTopSeparator.setReadOnly(true);
PropString sPlateTop(3, sArNY, "     "+T("|Create plate top|"),0);
PropDouble dPlateTopWidth(2, U(1500), "     "+T("|Plate top width|"));
PropDouble dPlateTopHeight(3, U(150), "     "+T("|Plate top height|"));
PropDouble dPlateTopThickness(4, U(250), "     "+T("|Plate top thickness|"));

PropDouble dPlateTopOffsetX(5, U(0), "     "+T("|Plate top offset| X"));
PropDouble dPlateTopOffsetY(6, U(0), "     "+T("|Plate top offset| Y"));

//Plate Bottom Properties
PropString sPlateBottomSeparator(4, "", T("|Bottom plate|"),0);
sPlateBottomSeparator.setReadOnly(true);
PropString sPlateBottom(5, sArNY, "     "+T("|Create plate bottom|"),0);
PropDouble dPlateBottomWidth(7, U(1500), "     "+T("|Plate bottom width|"));
PropDouble dPlateBottomHeight(8, U(150), "     "+T("|Plate bottom height|"));
PropDouble dPlateBottomThickness(9, U(250), "     "+T("|Plate bottom thickness|"));
PropDouble dPlateBottomOffsetX(10, U(0), "     "+T("|Plate Bottom offset| X"));
PropDouble dPlateBottomOffsetY(11, U(0), "     "+T("|Plate bottom offset| Y"));

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("|Zone to assign the plates|"));

PropString sSplitSeparator(8, "", T("|Split top and bottom rail|"));
sSplitSeparator.setReadOnly(true);
String splitTypes[] = {T("|Do not split|"), T("|Split at plate|"), T("|Split at post|")};
PropString splitTypeBottom(6, splitTypes, "     "+T("|Split type bottom|"));
PropString splitTypeTop(7, splitTypes, "     "+T("|Split type top|"));
PropDouble dSplitGap(12, U(0), "     "+T("|Split gap|"));


// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	//Getting walls	
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Please select Element"),ElementWall());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWall el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}

	if(_Element.length()==0){
		eraseInstance();
		return;
	}
	
	_Pt0=getPoint(T("Pick a reference point to insert post"));

	return;
}	

if (_Element.length() == 0)
{
	reportMessage(T("No selected walls. TSL will be deleted"));
	eraseInstance(); 
	return; 
}

int nAlign = arNAlign[arSAlign.find(sAlign,1)];

int bTopPlate = sArNY.find(sPlateTop,0);
int bBottomPlate = sArNY.find(sPlateBottom,0);

int bSplitAtTopPlate = (splitTypes.find(splitTypeTop) == 1);
int bSplitAtBottomPlate = (splitTypes.find(splitTypeBottom) == 1);

int bSplitTopRail = (splitTypes.find(splitTypeTop) > 0);
int bSplitBottomRail = (splitTypes.find(splitTypeBottom) > 0);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

// Find among all the _Element entries the element which is closest to _Pt0.

// The _bOnElementListModified will be TRUE after wall-splitting-in-length, or integrate tsl as tooling to element.

if (_bOnElementListModified && (_Element.length()>1)) // at least 2 items in _Element array
{
	reportMessage("\n"+scriptName()+" bOnElementListModified value: "+_bOnElementListModified);
	// now find closest among these elements, for that project the point into the XY plane of each element
	
	int nIndexWinner = -1;
	double dDistWinner;
	
	for (int e=0; e<_Element.length(); e++)
	{
		Element elE = _Element[e];
		CoordSys csElE = elE.coordSys(_Pt0);
	
		Point3d ptE = csElE.ptOrg(); // project point into XY plane of elE
		PlaneProfile ppEn = PlaneProfile(elE.plEnvelope());
	
		// but if point is not inside the envelope, find the closest point on the envelope
		if (ppEn.pointInProfile(ptE)!=_kPointInProfile) ptE = ppEn.closestPointTo(ptE);
	
		double dDistE = Vector3d(ptE-_Pt0).length();
	
		if (nIndexWinner==-1 || dDistE<=dDistWinner)
		{
			nIndexWinner = e;
			dDistWinner = dDistE;
		}
	}
	
	if (nIndexWinner>0) // the new winner is has not index 0 (or -1)
	{
		Element elNew = _Element[nIndexWinner];
		Element elOld = _Element[0];
		reportMessage("\n"+scriptName()+" moved from "+elOld.number()+ " to "+elNew.number());
		_Element[0] = elNew; // overwrite 0 entry will replace the existing reference to elem0
	}
}

Beam bmCreated[0];


//Remove all the entities that werer created in the previous run
for (int i=0; i<_Map.length(); i++)
{
	if(_Map.hasEntity("bm"+i))
	{
		Entity ent = _Map.getEntity("bm"+i);
		//return;
		ent.dbErase();
	}
	if(_Map.hasEntity("sheet"+i))
	{
		Entity ent = _Map.getEntity("sheet"+i);
		//return;
		ent.dbErase();
	}
	if(_Map.hasEntity("bmLeft"+i))
	{
		Entity ent = _Map.getEntity("bmLeft"+i);
		Entity entB;
		int nJoin=false;
		if(_Map.hasEntity("bmRight"+i))
		{
			entB=_Map.getEntity("bmRight"+i);
			nJoin=true;
		}
		if (nJoin)
		{
			Beam bmA=(Beam) ent;
			Beam bmB=(Beam) entB;
			
			if (bmA.bIsValid() && bmB.bIsValid())
			{
				bmA.dbJoin(bmB);
			}
		}
	}
}

_Map=Map();

//if(_Map.hasEntity("bmToSplit")){
// Entity ent1 = _Map.getEntity("bmToSplit");
//  Beam bm1 = (Beam)ent1;
//  Entity ent2 = _Map.getEntity("bmSplitted");
//  Beam bm2 = (Beam)ent2;
//  bm1.dbJoin(bm2);
//}



for(int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();

	double dBmW=el.dBeamWidth();
	double dBmH=el.dBeamHeight();

	if (dBmW>dBmH)
	{
		dBmW=el.dBeamHeight();
		dBmH=el.dBeamWidth();
	}
	
	
	//Get all the beam and calculate which ones can not be delete
	Beam bmAll[]=el.beam();
	if (bmAll.length()==0)
		continue;
	
	Plane plnY(el.ptOrg(), vy);
	Plane plnZ(el.ptOrg(), vz);
	
	_Pt0=plnZ.closestPointTo(_Pt0);
	_Pt0=plnY.closestPointTo(_Pt0);
	
	Beam bmVer[]= vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmFix[0];
	Beam bmTopPlates[0];
	Beam bmBottomPlates[0];
	Beam bmCripples[0];
	Beam bmBlocking[0];
	Beam bmToCheckDeletion[0];
	
	for(int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBmType=bm.type();
		if (nBmType==_kSFTopPlate || nBmType==_kSFAngledTPLeft || nBmType==_kSFAngledTPRight) 
		{
			Body bd=bm.envelopeBody(false, true);
			bmTopPlates.append(bm);
		}
		else if (nBmType==_kSFBottomPlate)
		{
			Body bd=bm.realBody();
			bmBottomPlates.append(bm);
		}
		/*
		else if (nBmType== _kSFSupportingBeam)
		{
			Body bd=bm.realBody();
			bmCripples.append(bm);
		}
		else if (nBmType== _kSFBlocking)
		{
			bmBlocking.append(bm);
		}
		*/
	}
	
	//Calculate the size off the profile post
	ExtrProfile ext (sProfile);
	
	PlaneProfile ppExtProfile=ext.planeProfile();
	LineSeg lsX=ppExtProfile.extentInDir(_XW);
	LineSeg lsY=ppExtProfile.extentInDir(_YW);
	double dProfileWidth = postWidth;
	double dProfileHeight = postHeight;
	if (sProfile != _kExtrProfRectangular && sProfile != _kExtrProfRound)
	{ 
		dProfileWidth = abs(_XW.dotProduct(lsX.ptStart()-lsX.ptEnd()));
		dProfileHeight = abs(_YW.dotProduct(lsX.ptStart()-lsX.ptEnd()));
	}
	
	//Calculate the left and right point on the side of the post for the alignment
	Point3d ptLeft=_Pt0-(vx*dProfileWidth)*0.5;
	Point3d ptRight=_Pt0+(vx*dProfileWidth)*0.5;
	Point3d ptNewCenter=_Pt0;
	int nSide=0;
	if (nAlign==0)//Left
	{
		ptLeft.transformBy(-vx*(dProfileWidth*0.5));
		ptRight.transformBy(-vx*(dProfileWidth*0.5));
		ptNewCenter.transformBy(-vx*(dProfileWidth*0.5));
		nSide=-1;
	}
	if (nAlign==2)//Right
	{
		ptLeft.transformBy(vx*(dProfileWidth*0.5));
		ptRight.transformBy(vx*(dProfileWidth*0.5));
		ptNewCenter.transformBy(+vx*(dProfileWidth*0.5));
		nSide=1;
	}

	Point3d ptRef=ptNewCenter-vz*(dBmH*0.5);
	
	//Find All the top plates
	Beam bmTopPlateAux[]=Beam().filterBeamsHalfLineIntersectSort(bmTopPlates, ptRef, vy);
	if (bmTopPlateAux.length()<1)
		return;
	
	Beam bmTopPlate=bmTopPlateAux[bmTopPlateAux.length()-1];
	

	//Find All the bottom plates
	Beam bmBottomPlateAux[]=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlates, ptRef, -vy);
	if (bmBottomPlateAux.length()<1)
		return;
	
	Beam bmBottomPlate=bmBottomPlateAux[bmBottomPlateAux.length()-1];//HSB-12021

	//Top and Bottom point in the location of the post
	Point3d ptTopFlush=bmTopPlate.ptCen()+vy*(bmTopPlate.dD(vy)*0.5);
	Point3d ptBottomFlush=bmBottomPlate.ptCen()-vy*(bmBottomPlate.dD(vy)*0.5);
	Line ln (_Pt0, vy);
	ptTopFlush=ln.closestPointTo(ptTopFlush);
	ptBottomFlush=ln.closestPointTo(ptBottomFlush);
	
	//Calculate left and right of the top plate
	Point3d ptRefTopPlate=ptNewCenter+vx*dPlateTopOffsetX-vz*dPlateTopOffsetY;
	Point3d ptLeftPlateTop=ptRefTopPlate-(vx*dPlateTopWidth)*0.5;
	Point3d ptRightPlateTop=ptRefTopPlate+(vx*dPlateTopWidth)*0.5;

	//Calculate left and right of the bottom plate
	Point3d ptRefBottomPlate=ptNewCenter+vx*dPlateBottomOffsetX-vz*dPlateBottomOffsetY;
	Point3d ptLeftPlateBottom=ptRefBottomPlate-(vx*dPlateBottomWidth)*0.5;
	Point3d ptRightPlateBottom=ptRefBottomPlate+(vx*dPlateBottomWidth)*0.5;


	//Calculate the points to split top and bottom if necesary
	Point3d ptSplitTopLeft=ptLeft - vx * dSplitGap;
	Point3d ptSplitTopRight=ptRight + vx * dSplitGap;
	
	if (bTopPlate && bSplitAtTopPlate)
	{
		if ((ptLeftPlateTop-ptLeft).dotProduct(vx)<0)
			ptSplitTopLeft=ptLeftPlateTop - vx * dSplitGap;
	
		if ((ptRightPlateTop-ptRight).dotProduct(vx)>0)
			ptSplitTopRight=ptRightPlateTop + vx * dSplitGap;	
	}
	
	Point3d ptSplitBottomLeft=ptLeft - vx * dSplitGap;
	Point3d ptSplitBottomRight=ptRight + vx * dSplitGap;
	
	if (bBottomPlate && bSplitAtBottomPlate)
	{
		if ((ptLeftPlateBottom-ptLeft).dotProduct(vx)<0)
			ptSplitBottomLeft=ptLeftPlateBottom - vx * dSplitGap;
		
		if ((ptRightPlateBottom-ptRight).dotProduct(vx)>0)
			ptSplitBottomRight=ptRightPlateBottom + vx * dSplitGap;		
	}
	
	//Split top plate
	int nCounter=1;
	if (bSplitTopRail) {
		for(int i=0; i<bmTopPlateAux.length(); i++)
		{
			if ((ptSplitTopRight-ptSplitTopLeft).dotProduct(bmTopPlateAux[i].vecX())>0)
			{
				Beam bm=bmTopPlateAux[i].dbSplit(ptSplitTopRight, ptSplitTopLeft);
				_Map.setEntity("bmLeft"+nCounter, bmTopPlateAux[i]);
				_Map.setEntity("bmRight"+nCounter, bm);
				nCounter++;
	
			}
			else
			{
				Beam bm=bmTopPlateAux[i].dbSplit(ptSplitTopLeft, ptSplitTopRight);
				_Map.setEntity("bmLeft"+nCounter, bmTopPlateAux[i]);
				_Map.setEntity("bmRight"+nCounter, bm);
				nCounter++;
			}
	
		}
	}
	
	if (bSplitBottomRail) {
		//Split bottom plate
		for(int i=0; i<bmBottomPlateAux.length(); i++)
		{
			if ((ptSplitBottomRight-ptSplitBottomLeft).dotProduct(bmBottomPlateAux[i].vecX())>0)
			{
				Beam bm=bmBottomPlateAux[i].dbSplit(ptSplitBottomRight, ptSplitBottomLeft);
				_Map.setEntity("bmLeft"+nCounter, bmBottomPlateAux[i]);
				_Map.setEntity("bmRight"+nCounter, bm);
				nCounter++;
			}
			else
			{
				Beam bm=bmBottomPlateAux[i].dbSplit(ptSplitBottomLeft, ptSplitBottomRight);
				_Map.setEntity("bmLeft"+nCounter, bmBottomPlateAux[i]);
				_Map.setEntity("bmRight"+nCounter, bm);
				nCounter++;
			}
		}
	}
	
	//Calculate the length of the post
	Point3d ptTopBeam=ptTopFlush+vy*(dOffsetTop);
	Point3d ptBottomBeam=ptBottomFlush-vy*(dOffsetBottom);
	
	ptTopBeam.vis(1);
	ptBottomBeam.vis(1);
	
	if (bTopPlate)
		ptTopBeam=ptTopBeam-vy*dPlateTopThickness;

	if (bBottomPlate)
		ptBottomBeam=ptBottomBeam+vy*dPlateBottomThickness;
	
	double dBeamLength=abs(vy.dotProduct(ptTopBeam-ptBottomBeam));
	
	//Create the Post
	
	Point3d ptCreatePost=ptBottomBeam;
	Beam bmNew;
	bmNew.dbCreate(ptCreatePost, vy, vx, -vz, dBeamLength, dProfileWidth, dProfileHeight, 1, nSide, 1);
	bmNew.setExtrProfile(sProfile);
	bmNew.setName("Koker");
	bmNew.setInformation(sProfile);
	bmNew.setLabel("Metaal");
		
	bmNew.setBeamCode(""+";");
	bmNew.setType(_kPost);
	//bmNew.setHsbId("114");
	bmNew.assignToElementGroup(el, true, 0, 'Z');
	
	bmNew.setColor(210);
	
	bmCreated.append(bmNew);
	
	//Create Top Plate
	if (bTopPlate)
	{
		Plane plnTop(ptTopFlush+vy*(dOffsetTop), vy);
		PlaneProfile ppTop(plnTop);
		PLine plTop(-vy);
		LineSeg lsTopSheet(ptLeftPlateTop, ptRightPlateTop-vz*dPlateTopHeight);
		plTop.createRectangle(lsTopSheet, vx, -vz);
		ppTop.joinRing(plTop, false);
		Sheet shTop;
		shTop.dbCreate(ppTop, dPlateTopThickness, -1);
		
		shTop.setMaterial("Steel");
		shTop.setColor(210);
		
		shTop.assignToElementGroup(el, true, nZone, 'Z');
		
		_Map.setEntity("sheet1", shTop);
	}
	
	//Create Bottom Plate
	if (bBottomPlate)
	{
		Plane plnBottom(ptBottomFlush-vy*(dOffsetBottom), vy);
		PlaneProfile ppBottom(plnBottom);
		PLine plBottom(vy);
		LineSeg lsBottomSheet(ptLeftPlateBottom, ptRightPlateBottom-vz*dPlateBottomHeight);
		plBottom.createRectangle(lsBottomSheet, vx, -vz);
		ppBottom.joinRing(plBottom, false);
		Sheet shBottom;
		shBottom.dbCreate(ppBottom, dPlateBottomThickness, 1);
		
		shBottom.setMaterial("Steel");
		shBottom.setColor(210);
		
		shBottom.assignToElementGroup(el, true, nZone, 'Z');
		
		_Map.setEntity("sheet2", shBottom);
	}

	//Simple Display
	Display dp(-1);
	LineSeg ls(ptNewCenter, ptNewCenter-vz*U(dProfileHeight));
	LineSeg ls2(ptNewCenter, ptNewCenter+vy*U(dProfileHeight));

	dp.draw(ls);
	dp.draw(ls2);
	
}

//Store all the beams that are been created to the map
for (int n=0; n<bmCreated.length(); n++)
{
	_Map.setEntity("bm"+n, bmCreated[n]);
}

//eraseInstance();
//return;















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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="352" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12021 bugfix if amount of bottom and top rail are not of same length" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/27/2021 9:39:25 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End