#Version 8
#BeginDescription
version value="1.2" date="31.jan.20" author="marsel.nakuci@hsbcad.com" 

HSB-6459: bmCloseTo is found as closest with ptAllDrills[i] 

Last modified by: Alberto Jena (alberto.jena@hsbcad.com)
29.02.2017  -  version 1.1




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
*  Copyright (C) 2017 by
*  hsbCAD Ltd.
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbcad, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
/// <version value="1.0" date="31.jan.20" author="marsel.nakuci@hsbcad.com"> HSB-6459: bmCloseTo is found as closest with ptAllDrills[i] </version>
*
* Created by: Alberto Jena (alberto.jena@hsbcad.com)
* date: 28.02.2017
* version 1.0: Release Version
*
*/

Unit (1,"mm");
double dEps = U(0.1);

PropDouble dEdgeOffset (0, U(600), T("Min Distance from edge of the wall"));

int nColor (0, 4, T("Color"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert )
{
	if( insertCycleCount()>1 ) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE("\nSelect a set of elements",Element());
	if(ssE.go()){
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
	
	//lstPropDouble.append(dEdgeOffset);
	//lstPropDouble.append(dOffsetCenters);
//	lstPropDouble.append(dDistanceBetweenStraps);
	lstPropDouble.append(dEdgeOffset);
//	lstPropDouble.append(nCenterHookBeam);
	
	//lstPropInt.append(nColor);
	
	for( int e=0;e<_Element.length();e++ )
	{
		Element el = _Element[e];
		lstElements.setLength(0);
		lstElements.append(el);
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}
	
	eraseInstance();
	return;
}

double dRopeLength=U(1000);

if( _Element.length() == 0 ){eraseInstance(); return;}

Display dp(-1);
dp.textHeight(U(5));

ElementWallSF el= (ElementWallSF) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\nhsbMaterial Table not found, please set the right company folder and rerun this command.");
	eraseInstance();
	return;
}

Map mpMat;
mpMat.readFromXmlFile(sPath);

String sMaterial[0];
double dDensity[0];

if (mpMat.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mpMat.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		sMaterial.append(mpMaterial.getString("MATERIAL").makeUpper());
		dDensity.append(mpMaterial.getDouble("DENSITY"));
	}
}

if (sMaterial.length()==0)
{
	eraseInstance();
	return;
}

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

Point3d ptElOrg=cs.ptOrg();
_Pt0=ptElOrg;

Line lnX (ptElOrg-vz*U(10), vx);
Plane plnBottom (ptElOrg, vy);

TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		tslAll[i].dbErase();
	}
}

//assignToElementGroup(el, TRUE, 0, 'T');
assignToElementGroup(el, TRUE, 0, 'I');


Point3d ptValidDrills[0];

//There is Not a Master panel and have been executed at least once before

CoordSys csPP (ptElOrg, vx, -vz, vy);
PlaneProfile ppAllNoValidAreas(csPP);

ptValidDrills.setLength(0);

GenBeam arGBm[] = el.genBeam();

Point3d ptCentroid;
double dWeight = 0;

// get weight and write to property of propSet if found//region
Map mapIO;
Map mapEntities;
for (int e=0;e<arGBm.length();e++)
    mapEntities.appendEntity("Entity", arGBm[e]);
mapIO.setMap("Entity[]",mapEntities);
TslInst().callMapIO("hsbCenterOfGravity", mapIO);
ptCentroid = mapIO.getPoint3d("ptCen");


_Pt0 = ptCentroid;

PLine plWall = el.plOutlineWall();
Plane pnEl( el.ptOrg() - el.vecZ() * 0.5 * el.zone(0).dH(), el.vecZ() );
Point3d arPtEl[] = plWall.intersectPoints(pnEl);

Line lnSort(el.ptOrg(), el.vecX());
arPtEl = lnSort.orderPoints(arPtEl);

if( arPtEl.length() == 0 )return;
Point3d ptMax = arPtEl[arPtEl.length() - 1];
Point3d ptMin = arPtEl[0];

double dLength=abs(vx.dotProduct(ptMax - ptMin));

//Find all the beams that ate top plate
int arNTypeTopPlate[] = {
	_kSFTopPlate,
	_kTopPlate,
	_kSFAngledTPLeft,
	_kSFAngledTPRight
};

Beam arBm[] = el.beam();
Beam bmTopPlates[0];

for( int i=0;i<arBm.length();i++ )
{
	if( arNTypeTopPlate.find(arBm[i].type(), -1) != -1 )
	{
		bmTopPlates.append(arBm[i]);
	} 
}

Beam bmVer[]=vx.filterBeamsPerpendicularSort(arBm);
Plane plnY(el.ptOrg(), vy);

Point3d ptAllDrills[0];

double dMinDist=abs(vx.dotProduct(ptMin-ptCentroid));
if (abs(vx.dotProduct(ptMax-ptCentroid))<dMinDist)
{
	dMinDist=abs(vx.dotProduct(ptMax-ptCentroid));
}

//Get half the distance of the minimum distance
double dHalfMinDistance = dMinDist * 0.5;
if(dHalfMinDistance < dEdgeOffset)
{
	dHalfMinDistance = dMinDist - dEdgeOffset;
}

ptAllDrills.append(ptCentroid - vx * (dHalfMinDistance));
ptAllDrills.append(ptCentroid + vx * (dHalfMinDistance));

for (int i=0; i<ptAllDrills.length(); i++)
{
	ptAllDrills[i].vis();
	Line lnPt (ptAllDrills[i], vy);
	Point3d ptDrill=ptAllDrills[i]+vy*U(10000);
	int bIntersect=FALSE;
	Beam bmValid;
	for (int j=0; j<bmTopPlates.length(); j++)
	{
		Point3d ptAllIntersect[]=bmTopPlates[j].envelopeBody().intersectPoints(lnPt);
		if (ptAllIntersect.length()>0)
		{
			if(ptDrill.Z()<ptAllIntersect[0].Z())
			{
				ptAllIntersect[0].vis(1);
				ptDrill=ptAllIntersect[0];
				bmValid=bmTopPlates[j];
				bIntersect=TRUE;
			}
		}
	}
	if (bIntersect==FALSE)
	{
		double dDistToH=U(15000);
		Beam bmCloseTo;
		// HSB-6459
		double dDistMax = U(15000);
		for (int j=0; j<bmTopPlates.length(); j++)
		{
			if (abs((bmTopPlates[j].ptCen()-ptAllDrills[i]).length())<dDistMax)
			{
				dDistMax = abs((bmTopPlates[j].ptCen() - ptAllDrills[i]).length());
				bmCloseTo=bmTopPlates[j];
			}
		}
		bmValid=bmCloseTo;
		Vector3d vyBm=bmCloseTo.vecD(vy);
		Plane plnZ (bmCloseTo.ptCen()+vyBm*(bmCloseTo.dD(vyBm)*0.5), vyBm);
		ptDrill=lnPt.intersect(plnZ, 0);
		ptDrill.vis();
	}
	Vector3d vyBm=bmValid.vecD(vy);
	double dAng=vyBm.angleTo(vy);
	double da=cos(dAng);
	double dDistToMove=0;//(dDiam*0.5)/cos(dAng)
	ptValidDrills.append(ptDrill+vy*(dDistToMove+U(1)));
}

double dThick=abs(el.dPosZOutlineBack())+abs(el.dPosZOutlineFront());
dThick=(dThick*0.5)+U(5);

double asd=abs(el.dPosZOutlineFront());
Point3d ptPlane=el.ptOrg()+vz*abs(el.dPosZOutlineFront()); ptPlane.vis();
Plane plnFront (ptPlane, vz);

Display dpToDXA(nColor);

for (int i=0; i<ptValidDrills.length(); i++)
{
	ptValidDrills[i].vis(2);
	Line ln1(ptValidDrills[i], vz);
	//plnFront.vis();
	Point3d ptDraw=ln1.intersect(plnFront, 0);
	
	ptDraw.vis(1);
	
	//Display dp(-1);
	//Display something
	double dSize = Unit(25, "mm");
	//Display dspl (-1);
	PLine pl1(_XW);
	PLine pl2(_XW);
	PLine pl3(_XW);
	pl1.addVertex(ptDraw+vx*dSize+vy*dSize);
	pl1.addVertex(ptDraw);
	pl1.addVertex(ptDraw-vx*dSize+vy*dSize);
	
	
	pl2.addVertex(ptDraw+vx*dSize*0.3+vy*dSize*0.3);
	pl2.addVertex(ptDraw+vx*dSize*0.3+vy*U(100));
	
	pl3.addVertex(ptDraw-vx*dSize*0.3+vy*dSize*0.3);
	pl3.addVertex(ptDraw-vx*dSize*0.3+vy*U(100));
	//pl2.addVertex(ptDraw-vy*dSize);
	//pl2.addVertex(ptDraw+vy*dSize);
	//pl3.addVertex(ptDraw-vz*dSize*4);
	//pl3.addVertex(ptDraw+vz*dSize*4);
	
	 // change linetype to specific linetype
	dp.draw(pl1);
	dp.draw(pl2);
	//dp.lineType("DASHED");
	dp.draw(pl3);
	
	
	dpToDXA.elemZone(el, 0, 'E');
	dpToDXA.showInDxa(true);
	dpToDXA.showInTslInst(_bOnDebug);

	dpToDXA.draw(pl1);
	dpToDXA.draw(pl2);
	dpToDXA.draw(pl3);

}
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
        <int nm="BreakPoint" vl="293" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End