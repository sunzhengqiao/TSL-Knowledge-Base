#Version 8
#BeginDescription
1.5 22.06.2021 HSB-12290: fix bug when calculationg the closest top plate Author: Marsel Nakuci
Last modified by: Alberto Jena (aj@hsb-cad.com)
23.03.2021  -  version 1.4

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
*  Copyright (C) 2014 by
*  hsbCAD Ltd.
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* #Versions
// Version 1.5 22.06.2021 HSB-12290: fix bug when calculationg the closest top plate Author: Marsel Nakuci
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (alberto.jena@hsbcad.com)
* date: 08.12.2014
* version 1.0: Release Version
*
*/

Unit (1,"mm");
double dEps = U(0.1);

//PropDouble dOffsetCenters (1, U(300), T("Min Distance between holes"));
//dOffsetCenters.setDescription(T("If the lifting holes are in a distance less that this one then only one hole is going to be aplly"));


PropDouble dDistanceBetweenStraps (0, U(1200), T("Distance between straps"));
PropDouble dEdgeOffset (1, U(600), T("Min Distance from edge of the wall"));
PropDouble nCenterHookBeam (2, U(600), T("Centers lifting beam hooks"));

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
	lstPropDouble.append(dDistanceBetweenStraps);
	lstPropDouble.append(dEdgeOffset);
	lstPropDouble.append(nCenterHookBeam);
	
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

Body arBody[0];				int arNZoneIndex[0];
arBody.append(Body());		arNZoneIndex.append(0);
arBody.append(Body());		arNZoneIndex.append(1);
arBody.append(Body());		arNZoneIndex.append(2);	
arBody.append(Body());		arNZoneIndex.append(3);
arBody.append(Body());		arNZoneIndex.append(4);
arBody.append(Body());		arNZoneIndex.append(5);
arBody.append(Body());		arNZoneIndex.append(-1);
arBody.append(Body());		arNZoneIndex.append(-2);
arBody.append(Body());		arNZoneIndex.append(-3);
arBody.append(Body());		arNZoneIndex.append(-4);
arBody.append(Body());		arNZoneIndex.append(-5);


double arDDensity[0];
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);
arDDensity.append(0);	


double arDVolume[0];
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);
arDVolume.append(0);


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

assignToElementGroup(el, TRUE, 0, 'T');

Point3d ptValidDrills[0];

//There is Not a Master panel and have been executed at least once before

CoordSys csPP (ptElOrg, vx, -vz, vy);
PlaneProfile ppAllNoValidAreas(csPP);

ptValidDrills.setLength(0);

GenBeam arGBm[] = el.genBeam();

Point3d ptCentroid;
double dWeight = 0;

for( int i=0;i<arGBm.length();i++ ){
	GenBeam gBm = arGBm[i];
	int nThisIndex = arNZoneIndex.find(gBm.myZoneIndex());
	if( nThisIndex == -1 )return;
		
	Body bd(gBm.envelopeBody(false, false));
	arDVolume[nThisIndex] = arDVolume[nThisIndex] + bd.volume();
	
	String sThisMaterial=gBm.material();
	sThisMaterial.trimLeft();
	sThisMaterial.trimRight();
	sThisMaterial.makeUpper();
	int nDensityLocation=sMaterial.find(sThisMaterial, -1);
	
	if (nDensityLocation==-1)
	{
		arDDensity[nThisIndex]=500;
	}
	else if (arDDensity[nThisIndex]==0)
	{
		arDDensity[nThisIndex]=dDensity[nDensityLocation];
	}
	
	if( i==0 )
	{
		arBody[nThisIndex] = bd;
	}
	else
	{
		arBody[nThisIndex].addPart(bd);
	}
}

//Calculate centroid points of zones
Point3d arPtCentroid[0];
double arDWeight[0];
for( int i=0;i<arDVolume.length();i++ )
{
	if( arDVolume[i] == 0 || arDDensity[i]==0) continue;
		
	arPtCentroid.append(arBody[i].ptCen());
	arDVolume[i] = arDVolume[i]/1000000000;
	arDWeight.append(arDVolume[i] * arDDensity[i]);
}


//Calculate centroid points of openings
Opening arOp[] = el.opening();
for (int i=0; i<arOp.length(); i++)
{
	Opening op=arOp[i];
	Map mpOp=op.subMapX("HSB_OpeningInfo");
	
	int nFitted=mpOp.getInt("FactoryFitted");
	if (nFitted==true)
	{
		//Calculale center point of the opening
		PLine opShape=op.plShape();
		Point3d ptOpAll[]=opShape.vertexPoints(true);
		Point3d ptOpCenter;
		ptOpCenter.setToAverage(ptOpAll);
		ptOpCenter.vis(1);
		
		double dThisOpWeight=mpOp.getDouble("TotalWeight");
		
		arPtCentroid.append(ptOpCenter);
		arDWeight.append(dThisOpWeight);
	}
}



//Calculate THE centroid point of the element
for( int i=0;i<arPtCentroid.length();i++ )
{
	if( dWeight == 0 )
	{
		ptCentroid = arPtCentroid[i];
		dWeight = arDWeight[i];
	}
	else
	{
		Vector3d vec(ptCentroid - arPtCentroid[i]);
		double dFraction =  1 - 1/(dWeight/arDWeight[i] +1);
		ptCentroid = arPtCentroid[i] + vec * dFraction;
		dWeight = dWeight + arDWeight[i];
	}		
}

ptCentroid.vis(2);

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

//Beam bmVer[]=vx.filterBeamsPerpendicularSort(arBm);
//Plane plnY(el.ptOrg(), vy);

Point3d ptAllDrills[0];

double dMinDist=abs(vx.dotProduct(ptMin-ptCentroid));
if (abs(vx.dotProduct(ptMax-ptCentroid))<dMinDist)
{
	dMinDist=abs(vx.dotProduct(ptMax-ptCentroid));
}

dMinDist=dMinDist-dEdgeOffset-nCenterHookBeam;

double dModule=dMinDist/nCenterHookBeam;

dModule=round(dModule);

int nValue=(int) dModule;
if (nValue>4) nValue=4;

if (nValue<=0 && dLength<=U(1200))
{
	ptAllDrills.append(ptCentroid);
}
else if (nValue<=0 && dLength>U(1200))
{
	ptAllDrills.append(ptCentroid-vx*(nCenterHookBeam));
	ptAllDrills.append(ptCentroid+vx*(nCenterHookBeam));

}
else 
{
	Point3d ptMidLeft=ptCentroid-vx*(nCenterHookBeam*nValue);
	ptAllDrills.append(ptMidLeft-vx*(dDistanceBetweenStraps*0.5));
	ptAllDrills.append(ptMidLeft+vx*(dDistanceBetweenStraps*0.5));
	
	Point3d ptMidRight=ptCentroid+vx*(nCenterHookBeam*nValue);
	ptAllDrills.append(ptMidRight-vx*(dDistanceBetweenStraps*0.5));
	ptAllDrills.append(ptMidRight+vx*(dDistanceBetweenStraps*0.5));
}

//dMinDist=dMinDist-dEdgeOffset-dDiam;
/*
if (dMinDist<(dOffsetCenters*0.5))
{
	ptAllDrills.append(ptCentroid);
}
else
{
	ptAllDrills.append(ptCentroid-vx*dMinDist);
	ptAllDrills.append(ptCentroid+vx*dMinDist);
}
*/



for (int i=0; i<ptAllDrills.length(); i++)
{
	ptAllDrills[i].vis(1+i);
	Line lnPt (ptAllDrills[i], vy);
	Point3d ptDrill=ptAllDrills[i]+vy*U(10000);
	int bIntersect=FALSE;
	Beam bmValid;
	for (int j=0; j<bmTopPlates.length(); j++)
	{
		Point3d ptAllIntersect[]=bmTopPlates[j].envelopeBody().intersectPoints(lnPt);
//		bmTopPlates[j].envelopeBody().vis(4);
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
		// find the closest top plate
//		if (bmTopPlates.length() > 0)bmCloseTo = bmTopPlates[0];
		double dDistMin = U(10e5);
		for (int j=0; j<bmTopPlates.length(); j++)
		{
//			if (abs((bmTopPlates[j].ptCen()-ptAllDrills[i]).length())<dDistToH)
//			{
//				bmCloseTo=bmTopPlates[j];
//			}
			// HSB-12290
			Vector3d vyBm=bmTopPlates[j].vecD(vy);
			Plane plnZ (bmTopPlates[j].ptCen()+vyBm*(bmTopPlates[j].dD(vyBm)*0.5), vyBm);
			Point3d ptIntersect=lnPt.intersect(plnZ, 0);
			double dDistI = abs(vy.dotProduct(ptIntersect - ptAllDrills[i]));
			if(abs(vy.dotProduct(ptIntersect-ptAllDrills[i]))<dDistMin)
			{
				dDistMin = dDistI;
				bmCloseTo = bmTopPlates[j];
			}
		}
		bmValid=bmCloseTo;
		Vector3d vyBm=bmCloseTo.vecD(vy);
		bmCloseTo.envelopeBody().vis(6);
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
        <int nm="BreakPoint" vl="395" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12290: fix bug when calculationg the closest top plate" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/22/2021 10:33:23 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End