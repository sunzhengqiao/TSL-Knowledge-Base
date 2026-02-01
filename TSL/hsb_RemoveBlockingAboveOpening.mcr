#Version 8
#BeginDescription
Remove blocking above blocking excluding some beams by code.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 11.08.2011 - version 1.1


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
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
* date: 04.02.2011
* version 1.0: Release Version
*
* Modifed by: Alberto Jena (aj@hsb-cad.com)
* date: 11.08.2011
* version 1.1: Change sequence Number
*
*/

_ThisInst.setSequenceNumber(-120);

Unit(1,"mm"); // script uses mm

PropString sFilterBeams(0, "D", T("|Filter Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}


// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;
int bBmFilter;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";	
}

if (sBeamFilter.length() > 0)
	bBmFilter=TRUE;

int nErase=FALSE;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
			
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Beam bmAll[]=el.beam();
	Opening opAll[]=el.opening();
	Beam bmBlocking[0];
	PlaneProfile ppAboveOpening;
	Plane pnOpening;
	if (bmAll.length()<1)	
	{
		continue;
	}
	else
	{
		nErase=TRUE;
	}
	
	for(int i=0;i<bmAll.length();i++)
	{
		Beam bm=bmAll[i];
		String sBeamCode=bm.beamCode();
		if(bm.type()==_kSFBlocking && sBeamFilter.find(sBeamCode.token(0))==-1)
		{
				bmBlocking.append(bm);
		}
	}
	
	for(int i=0;i<opAll.length();i++)
	{
		Opening op=opAll[i];
		PLine plOpening=op.plShape();
		PlaneProfile ppOpening(plOpening);
		ppOpening.vis(5);
		LineSeg lsOpening=ppOpening.extentInDir(vx);
		lsOpening.vis();
		Point3d ptLineSegmentStart=lsOpening.ptStart();
		Point3d ptLineSegmentEnd=lsOpening.ptEnd();
		
		//Extend end point of Line segment to create a bigger plane profile in the Y Vector of the wall
		Point3d ptNewEndPoint=ptLineSegmentEnd+U(15000)*vy;
		LineSeg lnNewSegment(ptLineSegmentStart,ptNewEndPoint);
		
		//Create Rectangle covering the opening and the beams above the opening
		PLine plAboveOpening;
		plAboveOpening.createRectangle(lnNewSegment,vx,vy);
		ppAboveOpening=PlaneProfile(plAboveOpening);
		
		//Create a Plane that can be used for the shadow profile
		pnOpening=Plane(ptLineSegmentStart,vz);
		
		//Check if any blocking pieces are above the opening, if so delete them.
		for(int i=0;i<bmBlocking.length();i++)
		{
			Beam bm=bmBlocking[i];
			Body bd=bm.realBody();
			PlaneProfile ppBeam=bd.shadowProfile(pnOpening);
			ppBeam.vis();
			ppBeam.intersectWith(ppAboveOpening);
				
			if(ppBeam.area()>U(10))
			{
				bm.dbErase();
			}
		}
	}
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}




#End
#BeginThumbnail


#End
