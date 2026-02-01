#Version 8
#BeginDescription
Create rows of blocking between the studs that are at the left and right of a wall T connection.
2.2 22/08/2024 Add property to choose the connecting elements. AJ

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 28.04.2015 - version 2.1




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 08.07.2010
* version 1.0: Release Version
*
* date: 08.07.2010
* version 1.1: Bugfix when male and female wall have the same type and it's a valid connection
* version 1.2: Support corners that are overlaping more than the 50% of the beam
*
* date: 22.09.2010
* version 1.3: Fix issue when the connection is overlaping an existing stud
*
* date: 15.03.2012
* version 1.4: Fix issue with the size of the timbers
*
* date: 29.08.2012
* version 1.5: It will exclude the blocking on the corner connections and only apply it on the T connections
*
* date: 22.01.2012
* version 2.0: This version will check if the wall have a batten zone and will apply some horizontal battens in the connection
*/

Unit(1,"mm"); // script uses mm

//Add The elements that will need this type of connection

PropString sConnectingWalls (0, "NB;LB;PA", T("List of connecting wall codes"));
sConnectingWalls.setDescription("Code of the wall that will have a connection with the primary where the ladder will be created.");

_ThisInst.setSequenceNumber(-20);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

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

if( _Element.length()<1 ){
	eraseInstance();
	return;
}

String sValidElements[0];

String s = sConnectingWalls+ ";";
int nIndex = 0;
int sIndex = 0;
while (sIndex < s.length() - 1) {
	String sToken = s.token(nIndex);
	nIndex++;
	if (sToken.length() == 0) {
		sIndex++;
		continue;
	}
	sIndex = s.find(sToken, 0);
	
	sValidElements.append(sToken);
}

double dHeightAr[]={600, 1200, 1800};

//String sValidElements[]={"NB","LB","PA"};

//-----------------------------------------------------------------------------------------------------------------------------------
//                                      Loop over all elements.

int nColor=32;

ElementWall elWall[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWall el = (ElementWall) _Element[e];
	if (el.bIsValid())
	{
		elWall.append(el);
	}
}

int nErase=false;

for (int j=0; j<elWall.length(); j++)
{
	ElementWall el=elWall[j];
	Element elCon[] = el.getConnectedElements();
	
	//PLine pl0 = el.plEnvelope();
	//LineSeg lsHeight = pl0.extentInDir(el.vecY());
	//double dElementHeight = abs(el.vecY().dotProduct(lsHeight.ptStart() - lsHeight.ptEnd()));
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	PlaneProfile ppEl (el.plOutlineWall());

	LineSeg ls=ppEl.extentInDir(vx);
	
	Point3d ptLeft=ls.ptStart();
	Point3d ptRight=ls.ptEnd();
	
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);

	if (bmVer.length()<1)	
	{
		return;
	}
	for (int i=0; i<bmVer.length(); i++)
	{
		if (bmVer[i].dD(vx)>bmVer[i].dD(vz))
		{
			bmVer.removeAt(i);
			i--;
		}
	}
	
	nErase=true;
	
	double dBeamWidth=el.dBeamWidth();
	double dBeamHeight=el.dBeamHeight();
	
	if (dBeamWidth>dBeamHeight)
	{
		dBeamWidth=el.dBeamHeight();
		dBeamHeight=el.dBeamWidth();
	}
	
	//Check if the wall have a batten zone then it should add only battens instead of blocking beams

	int nBattens=false;
	int nZone=0;	
	
	int nRealZones[]={-5,-4,-3,-2,-1};
	for ( int i=0; i<nRealZones.length(); i++)
	{
		ElemZone elZ=el.zone(nRealZones[i]);
		String sDistribution=elZ.distribution();
		//Ensure the TSL only works on vertical sheets and no other type of distribution
		if(sDistribution==T("Vertical") && elZ.dH()>U(0))
		{
			nBattens=true;
			nZone=nRealZones[i];
			break;
		}
	}
	
	Line lnEl(el.ptOrg()-vz*U(dBeamHeight*0.5), vx);
	Plane plnY(el.ptOrg(), vy);
	PlaneProfile ppBm(plnY);
	
	for (int i=0; i<bmVer.length(); i++)
	{
		ppBm.unionWith(bmVer[i].envelopeBody().shadowProfile(plnY));
	}
	ppBm.shrink(-U(5));
	ppBm.vis();
	for (int c=0; c<elCon.length(); c++)
	{
		//Element elC=elCon[i];//dPosZOutlineFront
		ElementWall elC = (ElementWall) elCon[c];
		if (elC.bIsValid())
		{
			if (sValidElements.find(elC.code(),-1)==-1)
				continue;
			
			PLine plOutline=elC.plOutlineWall();
				
			Line lnElC(elC.ptOrg()+elC.vecZ()*(elC.dPosZOutlineBack()*0.5), elC.vecX());
			
			Point3d ptInter = lnEl.closestPointTo(lnElC);
			ptInter.vis(1);
			
			if (nBattens)
			{
				Sheet shAll[]=el.sheet(nZone);
				
				ElemZone elZ=el.zone(nZone);
				
				//Some values and point needed after
				Point3d ptFront=elZ.coordSys().ptOrg(); //ptFront.vis(1);
				
				CoordSys csRotation=csEl;
				csRotation.setToRotation(-90,vz,csEl.ptOrg());
				
				CoordSys csRingNew=csEl;
				csRingNew.transformBy(csRotation);
				
				if (nZone<0)
				{
					CoordSys csRotationY=csEl;
					csRotationY.setToRotation(180, vy, csEl.ptOrg());
					csRingNew.transformBy(csRotationY);
				}
				
				csRingNew.transformBy(ptFront-csEl.ptOrg());
				
				
				String sMaterial=elZ.material();
				int nColor=elZ.color();
				
				double dBattenWidth=elZ.dVar("width");
				double dBattenThickness=elZ.dH();

				
		
				Plane plnZ (ptFront, -vz);
				
				Point3d ptBattens=plnZ.closestPointTo(ptInter);
				ptBattens.vis();
				
				PlaneProfile ppAllSheets(plnZ);
				
				for (int s=0; s<shAll.length(); s++)
				{
					PlaneProfile ppThisSheet(plnZ);
					ppThisSheet=shAll[s].realBody().shadowProfile(plnZ);
					ppAllSheets.unionWith(ppThisSheet);
				}
				
				for (int c=0; c<dHeightAr.length(); c++)
				{
					Point3d ptBlock=ptBattens+vy*dHeightAr[c];
					
					if ( ppAllSheets.pointInProfile(ptBlock)==_kPointInProfile ) continue; 
					
					LineSeg lsThisRow(ptBlock-vy*dBattenWidth*0.5+vx*U(2000), ptBlock+vy*dBattenWidth*0.5-vx*U(2000));
					
					PLine pln(-vz);
					pln.createRectangle(lsThisRow, vx, vy);
					
					PlaneProfile ppFullBatten(csRingNew);
					ppFullBatten.joinRing(pln, false);
					
					ppFullBatten.subtractProfile(ppAllSheets);
					
					//Loop all the rings and find the one where the point is
					PLine plAllRings[]=ppFullBatten.allRings();
					int bIsOpening[]=ppFullBatten.ringIsOpening();
					
					for (int i=0; i<plAllRings.length(); i++)
					{
						if (bIsOpening[i])
							continue;
						
						PlaneProfile ppThisRing(csRingNew);
						ppThisRing.joinRing(plAllRings[i], false);
						
						if (ppThisRing.pointInProfile(ptBlock) == _kPointInProfile)
						{
							Sheet sh;
							sh.dbCreate(ppThisRing, dBattenThickness, 1);
							sh.setMaterial(sMaterial);
							sh.setColor(nColor);
							sh.assignToElementGroup(el, TRUE, nZone, 'Z');
							break;
						}
					}
					
					
				}
				
			}
			else
			{
			
				double dElWidth=elC.dBeamHeight();
				if (elC.dBeamHeight() < elC.dBeamWidth())
					dElWidth=elC.dBeamWidth();
				
				PlaneProfile ppElBase(el.plOutlineWall());
	
				if (!ppElBase.pointInProfile(ptInter) == _kPointInProfile)
				{
					continue;
				}
				
				if ( (ptInter-ptLeft).length()<dElWidth || (ptInter-ptRight).length()<dElWidth )
					continue;
				
				if (ppBm.pointInProfile(ptInter) == _kPointInProfile)
				{
					ptInter=ppBm.closestPointTo(ptInter);
					ptInter = lnEl.closestPointTo(ptInter);
				}
				
				if (!ppElBase.pointInProfile(ptInter) == _kPointInProfile)
					continue;
				
				ptInter.vis(2);
				for (int c=0; c<dHeightAr.length(); c++)
				{
					Point3d ptBlock=ptInter+vy*dHeightAr[c];
	
					Beam bmFullBlock;
					bmFullBlock.dbCreate(ptBlock, vx, vy, vz, U(10), dBeamWidth, dBeamHeight, 0, 0, 0);
					bmFullBlock.setGrade(bmAll[0].grade());
					bmFullBlock.setMaterial(bmAll[0].material());
					bmFullBlock.setType(_kSFBlocking);
					bmFullBlock.setName("BLOCKING");
					bmFullBlock.setColor(32);
					bmFullBlock.assignToElementGroup(el, TRUE, 0, 'Z');
					Beam bmAux[0];
					bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptBlock, vx);
					if (bmAux.length()>0)
						bmFullBlock.stretchStaticTo(bmAux[0], TRUE);
						
					bmAux.setLength(0);
					bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptBlock, -vx);
					if (bmAux.length()>0)
						bmFullBlock.stretchStaticTo(bmAux[0], TRUE);
	
				}
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
      <str nm="COMMENT" vl="Add property to choose the connecting elements." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="8/22/2024 11:19:26 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End