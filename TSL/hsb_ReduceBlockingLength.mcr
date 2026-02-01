#Version 8
#BeginDescription
Reduces the length of blockings on either side by a defined distance

#Versions
1.15 22/10/2025 Add property for a diferent gap to truss entities. Alberto Jena
1.14 24.03.2023 HSB-14096: Improve code for truss entities; use bodyExtents for the quader 
1.13 20.03.2023 HSB-18369: Dont consider parallel beams as stretchTo beams 
1.12 20.03.2023 HSB-18369: Stetch the beam only if the "distance" larger then the existing gap 
1.11 10.05.2022 HSB-15431: support stretching at truss entities 
1.10 09.05.2022 HSB-15431: fix bug  
1.9 25.03.2021
bugfix when the blocking was not recognize as horizontal but it was , Author Alberto Jena

1.8 11.02.2021 HSB-10726 
bugfix blockings in element Y-direction also supported , Author Thorsten Huck






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 15
#KeyWords 
#BeginContents
// #Versions
// 1.14 24.03.2023 HSB-14096: Improve code for truss entities; use bodyExtents for the quader Author: Marsel Nakuci
// 1.13 20.03.2023 HSB-18369: Dont consider parallel beams as stretchTo beams Author: Marsel Nakuci
// 1.12 20.03.2023 HSB-18369: Stetch the beam only if the "distance" larger then the existing gap Author: Marsel Nakuci
// 1.11 10.05.2022 HSB-15431: support stretching at truss entities Author: Marsel Nakuci
// 1.10 09.05.2022 HSB-15431: fix bug  Author: Marsel Nakuci
// 1.8 11.02.2021 HSB-10726 bugfix blockings in element Y-direction also supported , Author Thorsten Huck
// 1.9 25.03.2021 bugfix when the X vector of the beam was not recognized to be parallel to X of the element , Author Alberto Jena


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
* --------------------------------
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 07.04.2010
* version 1.0: Release Version.
*
* date: 22.04.2010
* version 1.1: Add a Map on the beams so it can not be reduce twice by mistake
*
* date: 18.05.2010
* version 1.2: Fix with Sequence and erase Instance
*
* date: 02.02.2012
* version 1.3: Add a property so the beams can be reduce multiple times
*
* date: 25.04.2019
* version 1.5: RP: change vector for angled blocking
*
* date: 17.01.2020
* version 1.6: AS: Add stretchOnInsert when adding the cuts to the beam.
///<version value="1.7" date="15may2020" author="thorsten.huck@hsbcad.com"> out of range error fixed </version>
*/

_ThisInst.setSequenceNumber(50);

Unit (1,"mm");

//Properties
PropDouble dReduceDist (0, U(1), "Gap to beams");
dReduceDist.setDescription(T("This value will be the gap between the blocking and any studs on each side."));

PropDouble dReduceDistTruss (1, U(1), "Gap to truss entities");
dReduceDistTruss.setDescription(T("This value will be the gap between the blocking and any truss entity on each side."));

//String sArYesNo[] = {T("No"), T("Yes")};
//PropString sReduce(0, sArYesNo, T("Allow to reduce multiple times"), 0);
//sReduce.setDescription(T("If this option is set to yes it will reduce the size of the blocking/dwans even if it was done before"));
//
//int bReduce= sArYesNo.find(sReduce);

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

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

int arNBmTypesToReduce[] = { _kSFBlocking, _kBlocking};

int nErase=false;

//return;
for( int e=0; e<_Element.length(); e++ )
{
	Element el=_Element[e];
	if (!el.bIsValid())
		continue;

	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	
	_Pt0 = ptOrgEl;
	
	Entity entsAll[0];
	Beam bmToReduce[0];
	Beam bmAll[]=el.beam();
	
	TrussEntity trussesAll[0];
	Group grpI = el.elementGroup();
	Entity entTrussesI[]=grpI.collectEntities(true,TrussEntity(),_kModelSpace);
	for (int itruss=0;itruss<entTrussesI.length();itruss++) 
	{ 
		TrussEntity trussI=(TrussEntity)entTrussesI[itruss];
		if ( ! trussI.bIsValid())continue;
		if (trussesAll.find(trussI) < 0)
		{
			trussesAll.append(trussI);
		}
	}//next itruss
	for (int ib=0;ib<bmAll.length();ib++) 
	{ 
		entsAll.append(bmAll[ib]);
	}//next ib
	for (int ib=0;ib<trussesAll.length();ib++) 
	{ 
		entsAll.append(trussesAll[ib]);
	}//next ib
	
//	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
//	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll); // HSB-10726


	Entity entToStretchTo[0];
	Beam bmToStretchTo[0];
	
//	for (int i=0; i<bmAll.length(); i++)
	for (int i=0; i<entsAll.length(); i++)
	{
		Entity entI=entsAll[i];
		Beam bm = (Beam)entI;
		if(bm.bIsValid())
		{ 
//		Beam bm=bmAll[i];
			int nType=bm.type();
			if( arNBmTypesToReduce.find(nType) != -1)
			{
				//Map mp=bm.subMap("mpReduce");
				//if (!mp.hasInt("nReduce") || bReduce)
				{
					bmToReduce.append(bm);
					
				}
			}
			entToStretchTo.append(bm);
		}
		else
		{ 
			entToStretchTo.append(entI);
		}
//		else
//		{
//			bmToStretchTo.append(bm);
//		}
		// HSB-15431:
//		bmToStretchTo.append(bm);
	}

	for (int i=0; i<bmToReduce.length(); i++)
	{
		Beam bm=bmToReduce[i];
		//bm.envelopeBody().vis(2);
		Vector3d vxBm=bm.vecX();
		Point3d ptBmLeft=bm.ptCen()+.5*bm.vecX()*bm.dL();
		Point3d ptBmRight=bm.ptCen()-.5*bm.vecX()*bm.dL();
		//int bIsX = vxBm.isParallelTo(vx);//HSB-10726
		
		//Beam bmToStretchLeft[]=Beam().filterBeamsHalfLineIntersectSort((bIsX?bmVer:bmHor), bm.ptCen(), vxBm);//HSB-10726
		// HSB-15431:
//		Beam _bmToStretchTo[0];
//		_bmToStretchTo.append(bmToStretchTo);
//		int iThisBm = bmToStretchTo.find(bm);
//		if(iThisBm>-1)_bmToStretchTo.removeAt(iThisBm);
		
		Entity _entToStretchTo[0];
		_entToStretchTo.append(entToStretchTo);
		int iThisBm = entToStretchTo.find(bm);
		if(iThisBm>-1)_entToStretchTo.removeAt(iThisBm);
		
//		Beam bmToStretchLeft[]=Beam().filterBeamsHalfLineIntersectSort(_bmToStretchTo, bm.ptCen(), vxBm);//HSB-10726
		// left
		Entity entToStretchLeft;
		Quader quaderToStretchLeft;
		double dClosestLeft = U(10e7);
		int iStretchLeft;
		// right
		Entity entToStretchRight;
		Quader quaderToStretchRight;
		double dClosestRight = U(10e7);
		int iStretchRight;
		
		int nEntityTypeLeft = 0; //0 = Beam - 1 = Truss;
		int nEntityTypeRight = 0; //0 = Beam - 1 = Truss;
		
		// 
		for (int ient=0;ient<_entToStretchTo.length();ient++) 
		{ 
			Body bd;
			Beam bmI = (Beam)_entToStretchTo[ient];
			TrussEntity trussI=(TrussEntity)_entToStretchTo[ient];
			if(bmI.bIsValid())
			{
				// beam
				Body bdI = bmI.envelopeBody();
				bdI.vis(3);
			// HSB-18369
				if (bmI.vecX().isParallelTo(bm.vecX()))continue;
				Quader qdI(bmI.ptCen(),bmI.vecX(),bmI.vecY(),bmI.vecZ(),bmI.dL(),bmI.dW(),bmI.dH(),0,0,0);
				qdI.vis(1);
				// in direction vxBm
				Point3d ptIntersectLeft;
				int iIntersectLeft = bdI.rayIntersection(bm.ptCen(), bm.vecX(), ptIntersectLeft);
				
				if ( iIntersectLeft)
				{
					nEntityTypeLeft = 0;
					if(abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()))<dClosestLeft)
					{ 
					// HSB-18369
						//if(abs(bm.vecX().dotProduct(ptIntersectLeft-ptBmLeft))<dReduceDist)
						{ 
							ptBmLeft.vis(1);
							dClosestLeft=abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()));
							quaderToStretchLeft=qdI;
							entToStretchLeft=bmI;
							iStretchLeft=true;
						}
					}
				}
				Point3d ptIntersectRight;
				int iIntersectRight = bdI.rayIntersection(bm.ptCen(), -bm.vecX(), ptIntersectRight);
				if ( iIntersectRight)
				{
					nEntityTypeRight = 0;
					if(abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()))<dClosestRight)
					{ 
					// HSB-18369
						//if(abs(bm.vecX().dotProduct(ptIntersectRight-ptBmRight))<dReduceDist)
						{ 
							dClosestRight=abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()));
							quaderToStretchRight=qdI;
							entToStretchRight=bmI;
							iStretchRight=true;
						}
					}
				}
			}
			else if(trussI.bIsValid())
			{ 
			// truss
//				CoordSys csTruss = trussI.coordSys();
//				Vector3d vecXt = csTruss.vecX();
//				Vector3d vecYt = csTruss.vecY();
//				Vector3d vecZt = csTruss.vecZ();
//				Point3d ptOrgTruss = trussI.ptOrg();
//				String strDefinition = trussI.definition();
//				TrussDefinition trussDefinition(strDefinition);
//				Beam beamsTruss[] = trussDefinition.beam();
//				Body bdTruss;
//				for (int i=0;i<beamsTruss.length();i++) 
//				{ 
//			//		beamsTruss[i].envelopeBody().vis(4);
//					bdTruss.addPart(beamsTruss[i].envelopeBody());
//				}//next i
//				bdTruss.transformBy(csTruss);
//				Point3d ptCenBd = bdTruss.ptCen();
//				PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
//				LineSeg segX = ppX.extentInDir(vecYt);
//				Point3d ptCenX = segX.ptMid();
//				Point3d ptCenTruss = ptCenX;
//				PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
//				LineSeg segY = ppY.extentInDir(vecXt);
//				ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
//				double dLx = bdTruss.lengthInDirection(vecXt);
//				double dLy = bdTruss.lengthInDirection(vecYt);
//				double dLz = bdTruss.lengthInDirection(vecZt);
//				Quader qdI(ptCenTruss,vecXt,vecYt,vecZt,dLx,dLy,dLz,0,0,0);
			// HSB-14096: quader of all entities now available
				//Body bdI = trussI.realBody();
				//Quader qdI = bdI.quader();
				Quader qdI=trussI.bodyExtents();
				qdI.vis(2);
				Body bdI(qdI);
				Point3d ptIntersectLeft;
				
				int iIntersectLeft=bdI.rayIntersection(bm.ptCen(),bm.vecX(),ptIntersectLeft);
				if (iIntersectLeft)
				{
					nEntityTypeLeft = 1;
					if(abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()))<dClosestLeft)
					{ 
					// HSB-18369
						//if(abs(bm.vecX().dotProduct(ptIntersectLeft-ptBmLeft))<dReduceDist)
						{ 
							dClosestLeft=abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()));
							quaderToStretchLeft=qdI;
							entToStretchLeft=trussI;
							iStretchLeft=true;
						}
					}
				}
				Point3d ptIntersectRight;
				int iIntersectRight=bdI.rayIntersection(bm.ptCen(),-bm.vecX(),ptIntersectRight);
				if (iIntersectRight)
				{
					nEntityTypeRight = 1;
					if(abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()))<dClosestRight)
					{ 
					// HSB-18369
						//if(abs(bm.vecX().dotProduct(ptIntersectRight-ptBmRight))<dReduceDist)
						{ 
							dClosestRight=abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()));
							quaderToStretchRight=qdI;
							entToStretchRight=trussI;
							iStretchRight=true;
						}
					}
				}
			}
		}//next ient
		//entToStretchLeft.realBody().vis(3);
		//entToStretchRight.realBody().vis(3);
//		if (bmToStretchLeft.length()>0)
		if(iStretchLeft)
		{
			double dNewGap = dReduceDist;
			if (nEntityTypeLeft==1) dNewGap = dReduceDistTruss;
//			Point3d ptAllLeft[]=bmToStretchLeft[0].envelopeBody(FALSE, TRUE).intersectPoints(Line (bm.ptCen(), vxBm));
			Body bdLeft(quaderToStretchLeft);
			Point3d ptAllLeft[]=bdLeft.intersectPoints(Line (bm.ptCen(), vxBm));
			if (ptAllLeft.length()>0)
			{
				Point3d ptCutLeft=ptAllLeft[0];
//				Vector3d cutVecLeft = bmToStretchLeft[0].vecX().crossProduct(bmToStretchLeft[0].vecD(el.vecZ()));
				Vector3d cutVecLeft = quaderToStretchLeft.vecX().crossProduct(quaderToStretchLeft.vecD(el.vecZ()));
				if (cutVecLeft.dotProduct(vxBm) < 0)
				{
					cutVecLeft *= -1;
				}
				ptCutLeft=ptCutLeft-cutVecLeft*dNewGap;
				Cut ctLeft (ptCutLeft, cutVecLeft);
				//cutVecLeft.vis(ptCutLeft, 3);	
				//bm.realBody().vis(2);
				bm.addToolStatic(ctLeft, _kStretchOnInsert);
			}
		}
		
		//Beam bmToStretchRight[]=Beam().filterBeamsHalfLineIntersectSort((bIsX?bmVer:bmHor), bm.ptCen(), -vxBm);//HSB-10726
//		Beam bmToStretchRight[]=Beam().filterBeamsHalfLineIntersectSort(_bmToStretchTo, bm.ptCen(), -vxBm);//HSB-10726
//		if (bmToStretchRight.length()>0)
		if(iStretchRight)
		{
			double dNewGap = dReduceDist;
			if (nEntityTypeRight==1) dNewGap = dReduceDistTruss;
//			Point3d ptAllRight[]=bmToStretchRight[0].envelopeBody(FALSE, TRUE).intersectPoints(Line (bm.ptCen(), -vxBm));
			Body bdRight(quaderToStretchRight);
			Point3d ptAllRight[]=bdRight.intersectPoints(Line (bm.ptCen(), -vxBm));
			if (ptAllRight.length()>0)
			{
				Point3d ptCutRight=ptAllRight[0];
//				Vector3d cutVecRight = bmToStretchRight[0].vecX().crossProduct(bmToStretchRight[0].vecD(el.vecZ()));//version value="1.7"
				Vector3d cutVecRight = quaderToStretchRight.vecX().crossProduct(quaderToStretchRight.vecD(el.vecZ()));
				if (cutVecRight.dotProduct(vxBm) > 0)
				{
					cutVecRight *= -1;
				}
				ptCutRight=ptCutRight - cutVecRight*dNewGap;
				Cut ctRight (ptCutRight, cutVecRight);
//
//				bm.realBody().vis(i);
//				cutVecRight.vis(ptCutRight, 2);					
				bm.addToolStatic(ctRight, _kStretchOnInsert);
			}
		}
//		Map mp;
//		mp.setInt("nReduce", TRUE);
//		bm.setSubMap("mpReduce", mp);
		nErase=true;
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add property for a diferent gap to truss entities." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="10/22/2025 12:07:43 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14096: Improve code for truss entities; use bodyExtents for the quader" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="3/24/2023 1:03:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18369: Dont consider parallel beams as stretchTo beams" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="3/20/2023 5:59:39 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18369: Stetch the beam only if the &quot;distance&quot; larger then the existing gap" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="3/20/2023 5:01:22 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15431: support stretching at truss entities" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="5/10/2022 9:22:24 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15431: fix bug " />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="5/9/2022 4:57:10 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10726 bugfix blockings in element Y-direction also supported" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/11/2021 4:53:42 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End