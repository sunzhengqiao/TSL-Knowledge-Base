#Version 8
#BeginDescription
Set's the edgel of the SIPs always to be square

Modified by: CS (chirag.sawjani@hsbcad.com)
Date: 22.11.2015  -  version 1.1



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* Last modified by: AJ
* 22.11.2015  -  version 1.1
*
*/


Unit(1,"mm");

_ThisInst.setSequenceNumber(-150);

PropDouble dEdgeRecessDepth(0,U(50),T("|Enter the recess depth for edges|"));

if (_bOnInsert) {
	//Select main SIP panel
	PrEntity ssE("\nSelect Element",Element());

	if (ssE.go()) { 
		Entity ents[0];
    		ents = ssE.set(); 
    		for (int i=0; i<ents.length(); i++) { 
			 Element el = (Element)ents[i];   
			if (el.bIsValid()) { 
			 _Element.append(el);  
			}		
		}
	}

	return;
}

//Check if there are any beams in the element
if(_Element.length()==0)
{
	eraseInstance();
	return;
}

for (int e=0; e<_Element.length(); e++)
{

	Element el=_Element[e];
	
	if (!el.bIsValid()) continue;
	
	Sip sipAll[]=el.sip();
	Beam beamAll[]=el.beam();
	if(sipAll.length()==0)
	{
		continue;
	}
	
	_Pt0=el.ptOrg();
	
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	
	Beam bmModified[0];
	
	for(int s=0;s<sipAll.length();s++)
	{
		Sip sp=sipAll[s];
		if(!sp.bIsValid()) continue;
		PlaneProfile ppSip(sp.plShadow());
		Plane plSip(sp.ptCen(), vz);
		
		Beam bmForSip[0];
		for(int b=0;b<beamAll.length();b++)
		{
			Beam bm=beamAll[b];
			PlaneProfile ppBm = bm.envelopeBody().shadowProfile(plSip);
			if(ppBm.intersectWith(ppSip))
			{
				bmForSip.append(bm);
			}
		}
		
		SipEdge spAllEdges[]=sp.sipEdges();
		
		Point3d ptCenSP=sp.ptCen();
		ptCenSP.vis(1);
		
		for (int i=0; i<spAllEdges.length(); i++)
		{
			SipEdge spEdge=spAllEdges[i];
			
			PLine plEdgeA=spEdge.plEdge();
			Vector3d vEdgeNormal=spEdge.vecNormal();
			Point3d ptEdgeStart=spEdge.ptStart();
			Point3d ptEdgeEnd=spEdge.ptEnd();
			Point3d ptEdgeMid=spEdge.ptMid();
			vEdgeNormal.normalize();
			Beam test[]=sp.lumberInstallList();
	
			double dA=abs(vEdgeNormal.dotProduct(vz));
			
			if (abs(vEdgeNormal.dotProduct(vz))>0.01)
			{
				//Find the beam that is for thi edge
				PLine plTestCase;
				plTestCase.createCircle(ptEdgeMid, vz, U(10));
				PlaneProfile ppTestCase(plTestCase);
				Beam bmForEdge;
				for(int b=0;b<bmForSip.length();b++)
				{
					Beam bm=bmForSip[b];
					if(bm.envelopeBody().shadowProfile(plSip).intersectWith(ppTestCase))
					{
						bmForEdge=bm;
					}
				}
				
				if(!bmForEdge.bIsValid()) continue; //Did not find an edge beam to work with.  This should not happen!!
			
				plEdgeA.vis(i);
				vEdgeNormal.vis(ptEdgeMid, i);
				sp.ptCen().vis(3);
				
				//Find the top and bottom planes
				Plane plnTop (sp.ptCen()-sp.vecZ()*(sp.dH()*0.5), sp.vecZ());
				Plane plnBottom (sp.ptCen()+sp.vecZ()*(sp.dH()*0.5), sp.vecZ());
				
				Plane plnEdge (ptEdgeMid, vEdgeNormal);
				
				Line lnTop=plnTop.intersect(plnEdge);
				Line lnBottom=plnBottom.intersect(plnEdge);
				
				
				Vector3d vxEdge=ptEdgeStart-ptEdgeEnd;
				vxEdge.normalize();
	
				Plane plnMiddle(ptEdgeMid, vxEdge);
				
				Point3d ptEdgeTop=lnTop.intersect(plnMiddle, 0);
				Point3d ptEdgeBottom=lnBottom.intersect(plnMiddle, 0);
	
				ptEdgeTop.vis(5);
				ptEdgeBottom.vis(6);
				
				Vector3d vNewNormalEdge=vxEdge.crossProduct(vz);
				
				if (vNewNormalEdge.dotProduct(vEdgeNormal)<0)
					vNewNormalEdge=-vNewNormalEdge;
				
				vNewNormalEdge.vis(ptEdgeMid, 2);			
				
				Point3d ptToCheck=ptEdgeMid-vNewNormalEdge*U(200);
				
				Point3d ptMidNewEdge;
				if ((ptToCheck-ptEdgeTop).length() < (ptToCheck-ptEdgeBottom).length())
				{
					ptMidNewEdge=ptEdgeTop;
				}
				else
				{
					ptMidNewEdge=ptEdgeBottom;
				}
	
				if(bmModified.find(bmForEdge)==-1)
				{
					Point3d ptMidAtNewRecessDepth = ptMidNewEdge - vNewNormalEdge * dEdgeRecessDepth;
					ptMidAtNewRecessDepth.vis(1);
					bmForEdge.realBody().vis();
					double dCurrentBeamWidth = bmForEdge.dD(vNewNormalEdge);
					double dHalfWidthOfBeam =  dCurrentBeamWidth * 0.5;
					double dBeamCenToRecessDepth = (bmForEdge.ptCen() - ptMidAtNewRecessDepth).dotProduct(vNewNormalEdge);
					double dDifference = dBeamCenToRecessDepth - dHalfWidthOfBeam;
					bmForEdge.setD(vNewNormalEdge, dCurrentBeamWidth + (dDifference*2 ));
					//bmForEdge.transformBy(vNewNormalEdge * dDifference);
					bmModified.append(bmForEdge);
				}
				
				Plane plnNewEdge (ptMidNewEdge, vNewNormalEdge);
				
				sp.stretchEdgeTo(ptEdgeMid, plnNewEdge);
				
			}
		}
	}
}
eraseInstance();
return;








#End
#BeginThumbnail



#End