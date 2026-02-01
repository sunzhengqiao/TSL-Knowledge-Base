#Version 8
#BeginDescription
Removes Battens based on certain criteria.

Modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com)
Date: 31.05.2017 - version 1.0
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
*  Copyright (C) 2017 by
*  hsbcad
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbcad, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*/

_ThisInst.setSequenceNumber(-70);

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};
PropDouble dMinimumBattenLength(0, U(600), T("|Minimum length of batten|"));

PropString sYesNoRemoveBattenAtSheetSplit (0, sArNY,T("|Remove battens at sheet splits|"), 1);
int nYesNoRemoveBattenAtSheetSplit = sArNY.find(sYesNoRemoveBattenAtSheetSplit, 0);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
		
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;

}

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

int nErase=false;
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};

for( int e=0; e<_Element.length(); e++ )
{
	ElementWall el = (ElementWall) _Element[e];
	if (!el.bIsValid()) continue;

	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	_Pt0=ptOrgEl;

	for (int x=0; x<nRealZones.length(); x++)
	{
		int& nZone=nRealZones[x];
		ElemZone elZ=el.zone(nZone);

		String sDistribution=elZ.code();
		//Ensure the TSL only works on vertical sheets and no other type of distribution
		//reportNotice("\n"+sDistribution);
		if(sDistribution!="HSB-PL09") continue;
		
		//Find all genbeams shorter than the defined length
		GenBeam gbm[]=el.genBeam(nZone);
		
		Vector3d vzZone=vz;
		int nBack=false;
		if (nZone<0)
		{
			vzZone=-vzZone;
			nBack=true;
		}
		
		//Some values and point needed after
		CoordSys elZoneCoordsys =el.zone(nZone).coordSys(); 
		Point3d ptFront=elZoneCoordsys.ptOrg(); 
		ptFront.vis(1);
		
		Plane plnZ (ptFront, vzZone);
		PlaneProfile ppGenBeams[0];
		for(int i = 0 ; i < gbm.length() ; i++)
		{
			GenBeam& gbCurr = gbm[i];
			Body gbBody = gbCurr.envelopeBody(FALSE, TRUE);
			ppGenBeams.append(gbBody.shadowProfile(plnZ));
		}
		
		GenBeam gbToRemove[0];
		PlaneProfile ppToRemove[0];
		for(int i = 0 ; i < gbm.length() ; i++)
		{
			GenBeam& gbCurr = gbm[i];
			if(gbCurr.dL() > dMinimumBattenLength) continue;
			gbToRemove.append(gbCurr);
			PlaneProfile& ppGenBeam = ppGenBeams[i];
			ppToRemove.append(ppGenBeam);
		}
		
		if(nYesNoRemoveBattenAtSheetSplit)
		{
			//Need to check next zone if there is a sheeting layer and ends of its entity to determine if a 
			//batten needs to be removed
			int nextZone = nZone >= 0 ? nZone + 1 : nZone - 1;
			GenBeam gbmNextZone[] =el.genBeam(nextZone);
			if(gbmNextZone.length() > 0)
			{ 
				CoordSys elNextZoneCoordsys =el.zone(nextZone).coordSys();
				Point3d ptNextZoneFront=elNextZoneCoordsys.ptOrg();
				ptNextZoneFront.vis(1);
				
				Plane plnZNext (ptNextZoneFront, vzZone);
				PlaneProfile ppNextZoneGenBeams[0];
				for(int i = 0 ; i < gbmNextZone.length() ; i++)
				{
					GenBeam& gbCurr = gbmNextZone[i];
					Body gbBody = gbCurr.envelopeBody(FALSE, TRUE);
					PlaneProfile ppGbNext = gbBody.shadowProfile(plnZNext);
					ppNextZoneGenBeams.append(ppGbNext);
					ppGbNext.vis();
				}
				
				for(int i = 0 ; i < ppToRemove.length() ; i++)
				{
					//Check if profile lies completely inside a genbeam profile of the next zone
					//if so remove it
					PlaneProfile& ppCurr = ppToRemove[i];
					LineSeg lsProfile = ppCurr.extentInDir(vz);
					Point3d lsMid = lsProfile.ptMid();
					double dLsWidth = (lsProfile.ptEnd() - lsProfile.ptStart()).dotProduct(vx);
					Point3d ptCheckPoints[] ={ lsMid, lsMid + 0.5 * dLsWidth * vx , lsMid - 0.5 * dLsWidth * vx };
					
					int nMarkForDeletion = FALSE;
					for ( int f = 0 ; f < ppNextZoneGenBeams.length() ; f++)
					{
						int nInProfile = 0;
						PlaneProfile& ppNextZoneGenBeam = ppNextZoneGenBeams[f];
						for( int p = 0 ; p < ptCheckPoints.length() ; p++)
						{
							Point3d& ptCurr = ptCheckPoints[p];
							if(ppNextZoneGenBeam.pointInProfile(ptCurr)==_kPointInProfile)
							{
								nInProfile++;
							}
						}
						
						if(nInProfile==ptCheckPoints.length())
						{
							nMarkForDeletion = TRUE;
							break;
						}
					}
					
					if(nMarkForDeletion)
					{
						ppCurr.vis();
						gbToRemove[i].dbErase();
					}
				}
				
			}
		}
		else
		{
			//Remove short battens
			for(int i = 0 ; i < gbToRemove.length() ; i++)
			{
				GenBeam& gbCurr = gbToRemove[i];
				gbCurr.dbErase();
			}
		}
	}
	
	nErase=true;
}

if (_bOnElementConstructed || nErase)
{
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail

#End