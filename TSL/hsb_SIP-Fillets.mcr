#Version 8
#BeginDescription
Last modified by: Alberto Jena (ajena@itw-industry.com)
05.09.2013  -  version 1.0
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
*  Copyright (C) 2012 by
*  ITW Industry 
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 05.09.2013
* version 1.0: Release Version
*
*/



if (_bOnInsert) 
{
	
	PrEntity ssE(T("|Select a set of roof elements|"), ERoofPlane());
	if (ssE.go())
	{
		Entity ssElementRoof[] = ssE.set();
		for (int i=0; i<ssElementRoof.length(); i++)
		{
			ERoofPlane roofpl = (ERoofPlane) ssElementRoof[i];

			if (roofpl.bIsValid())
			{
				_Entity.append(roofpl);
			}
		}
	}

	return;
}

if (_Entity.length()==0)
{
	eraseInstance();
	return;
}

PLine plRoof[0];
Element elRoof[0];
CoordSys csRoof[0];

for (int i=0; i<_Entity.length(); i++)
{
	ERoofPlane roofpl = (ERoofPlane)_Entity[i];

	if (!roofpl.bIsValid()) continue;
	
	Element el=(Element) roofpl;
	
	if (el.bIsValid())
	{
		plRoof.append(roofpl.plEnvelope());
		elRoof.append(el);
		csRoof.append(roofpl.coordSys());
	}
}

String sHandle[0];

for (int e=0; e<elRoof.length()-1; e++)
{
	plRoof[e].vis(e);
	Plane plnThis(csRoof[e].ptOrg(), csRoof[e].vecZ());
	
	PlaneProfile ppThis(csRoof[e]);
	ppThis.joinRing(plRoof[e], false);
	
	for (int x=e+1; x<elRoof.length(); x++)
	{
		Plane plnNext(csRoof[x].ptOrg(), csRoof[x].vecZ());
		
		PlaneProfile ppNext(csRoof[x]);
		ppNext.joinRing(plRoof[x], false);
		
		Line lnIntersection=plnThis.intersect(plnNext);
		
		//lnIntersection.vis();
		
		Point3d ptThis[]=plRoof[e].intersectPoints(lnIntersection);
		Point3d ptNext[]=plRoof[x].intersectPoints(lnIntersection);
		
		Point3d ptIntersection[]=plRoof[e].intersectPLine(plRoof[x]);
		
		for (int i=0; i<ptIntersection.length(); i++)
		{
			Point3d pt=ptIntersection[i];
			pt.vis();
		}
		
		if (ptIntersection.length()>1)
		{
			LineSeg ls(ptIntersection[0], ptIntersection[ptIntersection.length()-1]);
			Vector3d vDir=ptIntersection[0]-ptIntersection[ptIntersection.length()-1];
			vDir.normalize();
			
			Beam bmThis[]=elRoof[e].beam();
			Beam bmNext[]=elRoof[x].beam();
			

			
			double dMinThis=U(5000);
			double dMinNext=U(5000);
			
			Beam bmToAdjustThis[0];
			Beam bmToAdjustNext[0];
			
			for (int i=0; i<bmThis.length(); i++)
			{
				if ( abs(bmThis[i].vecX().dotProduct(vDir)) > 0.99 && (ls.ptMid()-bmThis[i].ptCen()).length()< dMinThis)
				{
					bmToAdjustThis.setLength(0);
					bmToAdjustThis.append(bmThis[i]);
					dMinThis=(ls.ptMid()-bmThis[i].ptCen()).length();
				}
			}
			for (int i=0; i<bmNext.length(); i++)
			{
				if ( abs(bmNext[i].vecX().dotProduct(vDir)) > 0.99 && (ls.ptMid()-bmNext[i].ptCen()).length()< dMinNext)
				{
					bmToAdjustNext.setLength(0);
					bmToAdjustNext.append(bmNext[i]);
					dMinNext=(ls.ptMid()-bmNext[i].ptCen()).length();
				}
			}
			
			if (bmToAdjustThis.length()>0 && bmToAdjustNext.length()>0)
			{
				Beam bmA=bmToAdjustThis[0];
				Beam bmB=bmToAdjustNext[0];
				
				for (int i=0; i<bmToAdjustThis.length(); i++) bmToAdjustThis[i].realBody().vis(2);
				for (int i=0; i<bmToAdjustNext.length(); i++) bmToAdjustNext[i].realBody().vis(3);
				
				Vector3d vyThis=vDir.crossProduct(csRoof[e].vecZ());
				Vector3d vyNext=vDir.crossProduct(csRoof[x].vecZ());
				
				Point3d ptTestThis=ls.ptMid();ptTestThis.transformBy(vyThis*U(1));
				Point3d ptTestNext=ls.ptMid();ptTestNext.transformBy(vyNext*U(1));
				
				if (ppThis.pointInProfile(ptTestThis) == _kPointInProfile) vyThis=-vyThis;
				if (ppNext.pointInProfile(ptTestNext) == _kPointInProfile) vyNext=-vyNext;
				
				//if (vyThis.dotProduct(csRoof[e].vecZ())<0) vyThis=-vyThis;
				//if (vyNext.dotProduct(csRoof[x].vecZ())<0) vyNext=-vyNext;
				
				
				vyThis.normalize(); vyThis.vis(bmA.ptCen());
				vyNext.normalize(); vyNext.vis(bmB.ptCen());
				
				Vector3d vzCut=vyThis+vyNext; vzCut.normalize();vzCut.vis(bmA.ptCen());
				Vector3d vyCut=vzCut.crossProduct(vDir); vyCut.normalize();
				
				Vector3d vTemp=bmA.ptCen()-ls.ptMid();
				
				if (vTemp.dotProduct(vyCut)>0)
				{
					vyCut=-vyCut;
				}
				
				vyCut.vis(bmA.ptCen());
				
				bmA.transformBy(bmA.vecD(vyThis)*((U(140)-bmA.dD(vyThis))*0.5));
				bmB.transformBy(bmB.vecD(vyNext)*((U(140)-bmB.dD(vyNext))*0.5));
				
				Cut ctA(ls.ptMid(), vyCut);
				Cut ctB(ls.ptMid(), -vyCut);
				
				bmA.setD(vyThis, U(140));
				bmB.setD(vyNext, U(140));
				

				
				bmA.addToolStatic(ctA, true);
				bmB.addToolStatic(ctB, true);
				
			}
			
			ls.transformBy(_ZW*U(1));
			ls.vis(2);
		}
		
	}
}

eraseInstance();
return;

#End
#BeginThumbnail

#End
