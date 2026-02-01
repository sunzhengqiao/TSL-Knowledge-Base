#Version 8
#BeginDescription
Dimension the length of the wall and place the dimension line on the symbol side of the wall.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 23.05.2011 - version 1.5
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2010 by
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
* date: 08.03.2010
* version 1.0: Release Version
*
* Modified by: Jonathan Hand (jhand@itw-industry.com)
* date: 15.03.2010 
*  version 1.1:	Decimal Place removed from wall length
*
* date: 16.03.2010
* version 1.2: Assign the TSL to the element and to the display layer
*
* date: 24.03.2010
* version 1.3: This TSL wont be number anymore
*
* date: 23.05.2011
* version 1.5: Fix issue when the wall is split
*/

Unit(1,"mm"); // script uses mm

PropString sDimStyle(0, _DimStyles, T("Dimension Style"));

PropDouble dOffset (0, U(350), "Offset");

PropString sDispRep(1, "", T("Show Dim in Disp Rep"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	
	//_Pt0=getPoint("Select the Location for the Material Table");
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = scriptName(); // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[0];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropString.append(sDimStyle);
	lstPropString.append(sDispRep);

	lstPropDouble.append(dOffset);
	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}
	
	eraseInstance();
	return;
}


//-----------------------------------------------------------------------------------------------------------------------
//                                                 Add selected beams to local array arBm

if (_Element.length()==0)
{
	eraseInstance();
	return;
}


//////////////////////////////////		Relocate TSL when a wall is split		//////////////////////////////////
// Find among all the _Element entries the element which is closest to _Pt0.
// The _bOnElementListModified will be TRUE after wall-splitting-in-length, or integrate tsl as tooling to element.

if (_bOnElementListModified && (_Element.length()>1)) // at least 2 items in _Element array
{
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

	if (nIndexWinner>0)  // the new winner is has not index 0 (or -1)
	{
		Element elNew = _Element[nIndexWinner];
		Element elOld = _Element[0];
		_Element.setLength(0);
		_Element.append(elNew); // overwrite 0 entry will replace the existing reference to elem0
	
	}
}


ElementWallSF el = (ElementWallSF) _Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();
Point3d ptOrgEl=cs.ptOrg();

Wall wl= (Wall) el;

if (!wl.bIsValid())
{
	eraseInstance();
	return;
}

Point3d ptToDim[0];
ptToDim.append(wl.ptStart());
ptToDim.append(wl.ptEnd());

Point3d ptSideArrow=el.ptArrow();

Vector3d vYdir=-vz;
if ((ptOrgEl-ptSideArrow).dotProduct(vYdir)<0)
	vYdir=-vYdir;

Vector3d vXdir=vYdir.crossProduct(_ZW);


ptSideArrow=ptSideArrow-vYdir*dOffset;

if (_bOnInsert || _bOnDbCreated)
	_Pt0=ptSideArrow;

double dDist=0;
dDist=abs(vx.dotProduct(wl.ptStart()-wl.ptEnd()));

String sDist;
sDist.formatUnit(dDist,2,0);

Display dp(-1);
dp.dimStyle(sDimStyle);
if (sDispRep!="")
	dp.showInDispRep(sDispRep);

dp.draw("("+sDist+")", ptSideArrow, vXdir, vYdir, 0, 0);

assignToElementGroup(el, TRUE, 0, 'D');


//DimLine dimLine(ptSideArrow-vYdir*dOffset, vXdir, vYdir);
//Dim dim(dimLine, ptToDim, "<>", "<>", _kDimDelta);
//dim.setDeltaOnTop(FALSE);
//dp.draw(dim);








#End
#BeginThumbnail






#End
