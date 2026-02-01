#Version 8
#BeginDescription
Rip the left and right stud when the king stud is overlapping them or rip the king stud when it is outside of the wall outline.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 17.02.2011 - version 1.2

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
* date: 13.05.2010
* version 1.0: Release Version
*
* date: 17.02.2011
* version 1.2: Extended functionality to rip King studs sticking out of the wall when opening is close to a wall (will not rip cripples)
*
*/

Unit(1,"mm"); // script uses mm

int nBmType[0];
String sBmName[0];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
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


for( int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	if (!el.bIsValid())
		continue;

	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();


	LineSeg ls=el.segmentMinMax();

	Point3d ptElStart=ls.ptStart();
	Point3d ptElEnd=ls.ptEnd();
	Point3d ptElMid=ls.ptMid();

	Plane plnZ (csEl.ptOrg(), vz);
	Plane plnY (csEl.ptOrg(), vy);

	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	
	//Check if the Stud is outside of the element
	PLine plStartEl(vy);
	plStartEl.addVertex(ptElStart+U(500)*vz);
	plStartEl.addVertex(ptElStart+U(500)*vz-U(5000)*vx);
	plStartEl.addVertex(ptElStart-U(500)*vz-U(5000)*vx);
	plStartEl.addVertex(ptElStart-U(500)*vz);

	
	PLine plEndEl(vy);
	plEndEl.addVertex(ptElEnd+U(500)*vz);
	plEndEl.addVertex(ptElEnd+U(500)*vz+U(5000)*vx);
	plEndEl.addVertex(ptElEnd-U(500)*vz+U(5000)*vx);
	plEndEl.addVertex(ptElEnd-U(500)*vz);
	plEndEl.close();


	PlaneProfile ppOutside(plStartEl);
	ppOutside.joinRing(plEndEl,FALSE);
	ppOutside.vis();
	
	Beam bmToErase[0];
	
	Beam bmModules[0];
	Beam bmValids[0];
	for (int b=0; b<bmVer.length(); b++)
	{
		Beam bm=bmVer[b];
		String sMod=bm.module();
		
		if (sMod!="" && bm.type()==_kKingStud)//It's a module & King Stud
		{
			bmModules.append(bm);
		}
		else
		{
			bmValids.append(bm);
		}
	}
	

	for (int b=0; b<bmModules.length(); b++)
	{
		Beam bm=bmModules[b];
		PlaneProfile ppBm (bm.realBody().shadowProfile(plnZ));
		PlaneProfile ppBmX(bm.realBody().shadowProfile(plnY));
		double dBmWidth=bm.dD(vx);
		double dBmArea=ppBmX.area();
		Beam bmNoThis[]=bm.filterGenBeamsNotThis(bmValids);
		
		for (int c=0; c<bmNoThis.length(); c++)
		{
			Beam bmInterfer=bmNoThis[c];
			
			if (bmInterfer.module()=="")
			{
				PlaneProfile ppBeamIntersect(bmInterfer.realBody().shadowProfile(plnZ));
				int nInter=ppBeamIntersect.intersectWith(ppBm);
				
				if (nInter && (ppBeamIntersect.area()/(U(1)*U(1)))>U(5))
				{
					LineSeg ls=ppBeamIntersect.extentInDir(vx);
					double dDistToMove=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
					Vector3d vDir=vx;
					if (vx.dotProduct(bmInterfer.ptCen()-bm.ptCen())<0)
						vDir=-vDir;
					
					bmInterfer.transformBy(vDir*(dDistToMove*0.5));
					double dSixe=bmInterfer.dD(vDir)-dDistToMove;
					bmInterfer.setD(vDir, dSixe);
				}
				
			}
			
		}
			
		//Check if the beam is outside the area of the wall or is slicing the wall
		ppBm=PlaneProfile(bm.realBody().shadowProfile(plnY));
		int nIntersection=ppBm.intersectWith(ppOutside);
		ppBm.vis(1);
		
		if(nIntersection==TRUE)
		{
			//Check the area of the intersection to find out if it is partially in the outer plane profile or totally in the outer planeprofile
			double test=ppBm.area();
			double dCheckBmNIntersectionArea=dBmArea-ppBm.area();
			
			if(dCheckBmNIntersectionArea<U(0.5))  //Beam lies entirely in the planeprofile
			{
				bmToErase.append(bm);
			}
			else
			{
				LineSeg lnIntersection=ppBm.extentInDir(vz);
				Vector3d vecIntersection=lnIntersection.ptEnd()-lnIntersection.ptStart();
				double dWidthToReduce=abs(vecIntersection.dotProduct(vx));
				double dNewWidth=dBmWidth-dWidthToReduce;
					
				//Check which direction the change is going to take place			
				Vector3d vecElOrgToBmCen=ptElMid-bm.ptCen();
				double dCheckDirection=vecElOrgToBmCen.dotProduct(vx);
				if(dCheckDirection>0)
				{
					bm.setD(vx,dNewWidth);
					bm.transformBy(vx*(dWidthToReduce/2));
				}
				else
				{
					bm.setD(vx,dNewWidth);
					bm.transformBy(-vx*(dWidthToReduce/2));
				}
				
			}
			
		}
		
	}
	
	//Erase Beams that are marked for erasure
	for (int b=0; b<bmToErase.length(); b++)
	{
		bmToErase[b].dbErase();
	}
}

if (_bOnElementConstructed)
{
	eraseInstance();
	return;
}

#End
#BeginThumbnail



#End
