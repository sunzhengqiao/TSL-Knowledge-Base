#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
18.02.2010  -  version 1.12




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
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
* date: 21.05.2008
* version 1.0: Release Version
*
* date: 30.05.2008
* version 1.1: Add property for the weight of each zone
*
* date: 17.06.2008
* version 1.2: Add Support for Master Panels
*
* date: 20.06.2008
* version 1.3: Set the default values
*
* date: 20.06.2008
* version 1.4: Change the display
*
* date: 06.10.2008
* version 1.5: Change the display
*
* date: 12.11.2008
* version 1.6: Change property name, set of no valid areas from PointLoad
*
* date: 12.11.2008
* version 1.7: Works with n number of headPlates
*
* date: 15.04.2009
* version 1.8: BugFix when the lifting hole is under an angle Plate
*
* date: 22.04.2009
* version 1.9: BugFix when inserted by Split TSL on a Master Panel
*
* date: 27.04.2009
* version 1.10: Avoid the interference of the millings with any Timber
*
* date: 16.02.2009
* version 1.11: Add Grip Point to the lifting holes
*
* date: 18.02.2009
* version 1.12: Bugfix when insert into master panels, and correct the element mill
*/

Unit (1,"mm");
double dEps = U(0.1);

//double arDMass[] = {U(15.0), U(25.0)};//kg/m^2
//String arSWithDoor[] = {T("Without door"), T("With door")};
//PropString sWithDoor(0,arSWithDoor, T("Door"),1);
//double dWeightDoor = arDMass[arSWithDoor.find(sWithDoor,1)];
//String arSWithGlass[] = {T("Without glass"), T("With glass")};
//PropString sWithGlass(1,arSWithGlass, T("Window"),1);
//double dWeightWindow = arDMass[arSWithGlass.find(sWithGlass,1)];

PropDouble dOffSet(0, U(150), T("Min Distance from Panel Edge"));
PropDouble dOffSetCenters(1, U(300), T("Min Distance between Holes"));
dOffSetCenters.setDescription(T("If the Lifting Holes are in a distance less that this one then only one Hole is going to be aplly"));
PropDouble dMaxDis (2, U(3000), T("Max Distance between Holes"));
PropDouble dDiam(3, U(50), T("Diameter Drill"));

PropString sExternalWalls (0, "AA;AB;AC;AD;AG;BH;BG;DH;EA;EB", T("Wall Types To Filter"));
sExternalWalls.setDescription("Please set the wall types that you want to be Mill, use ; to insert more than 1");

PropDouble dSpecificMassZone00(4, 370, T("Timber Weight (Kg/m3)"));
PropDouble dSpecificMassZone01(5, 600, T("Sheeting Zone 1 (kg/m3)"));
PropDouble dSpecificMassZone02(6, 0, T("Sheeting Zone 2 (kg/m3)"));
PropDouble dSpecificMassZone03(7, 0, T("Sheeting Zone 3 (kg/m3)"));
PropDouble dSpecificMassZone04(8, 0, T("Sheeting Zone 4 (kg/m3)"));
PropDouble dSpecificMassZone05(9, 0, T("Sheeting Zone 5 (kg/m3)"));
PropDouble dSpecificMassZone06(10, 600, T("Sheeting Zone 6 (kg/m3)"));
PropDouble dSpecificMassZone07(11, 0, T("Sheeting Zone 7 (kg/m3)"));
PropDouble dSpecificMassZone08(12, 0, T("Sheeting Zone 8 (kg/m3)"));
PropDouble dSpecificMassZone09(13, 0, T("Sheeting Zone 9 (kg/m3)"));
PropDouble dSpecificMassZone10(14, 60, T("Sheeting Zone 10 (kg/m3)"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	if (_kExecuteKey=="")
		showDialogOnce();
}

//double dSpecificMassZone00 = 500; //kg/m3
//double dSpecificMassZone01 = 500; //kg/m3
//double dSpecificMassZone02 = 500; //kg/m3
//double dSpecificMassZone03 = 500; //kg/m3
//double dSpecificMassZone04 = 500; //kg/m3
//double dSpecificMassZone05 = 500; //kg/m3
//double dSpecificMassZone06 = 500; //kg/m3
//double dSpecificMassZone07 = 500; //kg/m3
//double dSpecificMassZone08 = 500; //kg/m3
//double dSpecificMassZone09 = 500; //kg/m3
//double dSpecificMassZone10 = 500; //kg/m3

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

double arDSpecificMass[0];								double arDVolume[0];
arDSpecificMass.append(dSpecificMassZone00);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone01);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone02);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone03);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone04);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone05);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone06);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone07);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone08);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone09);		arDVolume.append(0);
arDSpecificMass.append(dSpecificMassZone10);		arDVolume.append(0);


String arSCodeExternalWalls[0];

String s = sExternalWalls+ ";";
int nIndex = 0;
int sIndex = 0;
while(sIndex < s.length()-1){
  String sToken = s.token(nIndex);
  nIndex++;
  if(sToken.length()==0){
    sIndex++;
    continue;
  }
  sIndex = s.find(sToken,0);

  arSCodeExternalWalls.append(sToken);
}


if( _bOnInsert )
{
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
	
	//lstPropString.append(sWithDoor);
	//lstPropString.append(sWithGlass);
	
	lstPropDouble.append(dOffSet);
	lstPropDouble.append(dOffSetCenters);
	lstPropDouble.append(dMaxDis);
	lstPropDouble.append(dDiam);
	lstPropDouble.append(dSpecificMassZone00);
	lstPropDouble.append(dSpecificMassZone01);
	lstPropDouble.append(dSpecificMassZone02);
	lstPropDouble.append(dSpecificMassZone03);
	lstPropDouble.append(dSpecificMassZone04);
	lstPropDouble.append(dSpecificMassZone05);
	lstPropDouble.append(dSpecificMassZone06);
	lstPropDouble.append(dSpecificMassZone07);
	lstPropDouble.append(dSpecificMassZone08);
	lstPropDouble.append(dSpecificMassZone09);
	lstPropDouble.append(dSpecificMassZone10);
	
	for( int e=0;e<_Element.length();e++ ){
		String sCode = _Element[e].code();
		if( arSCodeExternalWalls.find(sCode, -1) == -1 ) continue;
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}
	
	eraseInstance();
	return;
}

if( _Element.length() == 0 ){eraseInstance(); return;}




Display dp(-1);
dp.textHeight(U(5));


ElementWallSF el= (ElementWallSF) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}
//setDependencyOnEntity(el);

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

Point3d ptElOrg=cs.ptOrg();
_Pt0=ptElOrg;

Line lnX (ptElOrg-vz*U(10), vx);
Plane plnBottom (ptElOrg, vy);

assignToElementGroup(el, TRUE, 0, 'E');


Map mpDrill;
Point3d ptValidDrills[0];
int nMaster=FALSE;

GenBeam gbToDrill[]= el.genBeam(1);
gbToDrill.append (el.genBeam(-1));
gbToDrill.append (el.genBeam(-5));



if (gbToDrill.length()<=0)
	return;

if (_bOnElementConstructed)
{
	_Map=Map();
}


int bOnInsert=TRUE;

if (_Map.hasMap("mpDrill"))
{
	mpDrill=_Map.getMap("mpDrill");
	bOnInsert=FALSE;
}

if (mpDrill.hasInt("nMaster"))
	nMaster=mpDrill.getInt("nMaster");

_Map=Map();

if (bOnInsert==FALSE && nMaster==FALSE)
{
	Point3d ptNewDrillLoc[0];
	for (int i=0; i<_PtG.length(); i++)
		ptNewDrillLoc.append(_PtG[i]);
	_PtG.setLength(0);
	Map mp;
	mpDrill.setPoint3dArray("ptDrill", ptNewDrillLoc);
}

if (mpDrill.hasPoint3dArray("ptDrill"))
{
	ptValidDrills=mpDrill.getPoint3dArray("ptDrill");
}



//There is Not a Master panel and have been executed at least once before
if (!(nMaster==TRUE && ptValidDrills.length()>0) && bOnInsert)
{
	CoordSys csPP (ptElOrg, vx, -vz, vy);
	PlaneProfile ppAllNoValidAreas(csPP);

	//Collect the no valid areas of other TSLs
	TslInst tsl[]=el.tslInstAttached();
	for (int i=0; i<tsl.length(); i++)
	{
		if (!tsl[i].bIsValid())
			continue;

		if (tsl[i].map().hasMap("mpPL"))
		{
			Map mpMain=tsl[i].map();
			for (int m=0; m< mpMain.length(); m++)
			{
				if (mpMain.keyAt(m)=="mpPL")
				{
					Map mp=tsl[i].map().getMap(m);
					PLine plPointLoad=mp.getPLine("plPointLoad");
					PlaneProfile ppNoValidArea (csPP);
					ppNoValidArea.joinRing(plPointLoad, FALSE);
					ppNoValidArea.shrink(-dDiam);
					ppNoValidArea.vis();
					ppAllNoValidAreas.unionWith(ppNoValidArea);
				}
			}
		}
	}
	
	ptValidDrills.setLength(0);
	
	GenBeam arGBm[] = el.genBeam();
	
	Point3d ptCentroid;
	double dWeight = 0;
	
	for( int i=0;i<arGBm.length();i++ ){
		GenBeam gBm = arGBm[i];
		int nThisIndex = arNZoneIndex.find(gBm.myZoneIndex());
		if( nThisIndex == -1 )return;
			
		Body bd(gBm.realBody());
		arDVolume[nThisIndex] = arDVolume[nThisIndex] + bd.volume();
		
		if( i==0 ){
			arBody[nThisIndex] = bd;
		}
		else{
			arBody[nThisIndex].addPart(bd);
		}
	}
	
	//Calculate centroid points of zones
	Point3d arPtCentroid[0];
	double arDWeight[0];
	for( int i=0;i<arDVolume.length();i++ ){
		if( arDVolume[i] == 0 || arDSpecificMass[i]==0)continue;
			
		arPtCentroid.append(arBody[i].ptCen());
			
		arDVolume[i] = arDVolume[i]/1000000000;
		arDWeight.append(arDVolume[i] * arDSpecificMass[i]);
	}
	//Calculate centroid points of openings
	Opening arOp[] = el.opening();
	
	//Calculate THE centroid pointof the element
	for( int i=0;i<arPtCentroid.length();i++ ){
		if( dWeight == 0 ){
			ptCentroid = arPtCentroid[i];
			dWeight = arDWeight[i];
		}
		else{
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
	
	//Find all the beams that ate top plate
	
	int arNTypeTopPlate[] = {
		_kSFTopPlate,
		_kTopPlate,
		_kSFAngledTPLeft,
		_kSFAngledTPRight
	};
	
	Beam arBm[] = el.beam();
	Beam bmTopPlates[0];
	
	for( int i=0;i<arBm.length();i++ ){
		if( arNTypeTopPlate.find(arBm[i].type(), -1) != -1 )
		{
			bmTopPlates.append(arBm[i]);
		} 
	}
	
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(arBm);
	Plane plnY(el.ptOrg(), vy);
	//CoordSys csY (el.ptOrg(), vx, -vz, vy);
	for (int i=0; i<arBm.length(); i++)
	{
		Beam bm=arBm[i];
		int nType=bm.type();
		if (nType==_kSFTopPlate || nType==_kSFBottomPlate || nType== _kTopPlate || nType== _kSFAngledTPLeft || nType== _kSFAngledTPRight || bm.name()=="WRAP")
			continue;
		PlaneProfile ppNoValidArea (csPP);
		ppNoValidArea=arBm[i].envelopeBody().shadowProfile(plnY);
		ppNoValidArea.shrink(-U(dDiam));
		ppNoValidArea.vis();
		ppAllNoValidAreas.unionWith(ppNoValidArea);

	}
	
	Point3d ptAllDrills[0];
	
	double dMinDist=abs(vx.dotProduct(ptMin-ptCentroid));
	if (abs(vx.dotProduct(ptMax-ptCentroid))<dMinDist)
	{
		dMinDist=abs(vx.dotProduct(ptMax-ptCentroid));
	}
	
	dMinDist=dMinDist-dOffSet-dDiam;
	
	if (dMinDist<(dOffSetCenters*0.5))
	{
		ptAllDrills.append(ptCentroid);
	}
	else
	{
		ptAllDrills.append(ptCentroid-vx*dMinDist);
		ptAllDrills.append(ptCentroid+vx*dMinDist);
	}
	
	if (ptAllDrills.length()>1)
	{
		double dDist=abs(vx.dotProduct(ptAllDrills[0]-ptAllDrills[1]));
		if (dDist>dMaxDis)
		{
			dDist=dDist-dMaxDis;
			ptAllDrills[0]=ptAllDrills[0]+(vx*dDist*0.5);
			ptAllDrills[1]=ptAllDrills[1]-(vx*dDist*0.5);
		}
	}
	
	for (int j=0; j<ptAllDrills.length(); j++)
	{
		//for (int i=0; i<ppAllNoValidAreas.length(); i++)
		//{
			ppAllNoValidAreas.vis(2);
			if (ppAllNoValidAreas.pointInProfile(ptAllDrills[j])==_kPointInProfile  )
			{
				PLine plNoValirArea1[]=ppAllNoValidAreas.allRings();
				PLine plNoValirArea=plNoValirArea1[0];
				Point3d ptVertex[]=plNoValirArea.vertexPoints(TRUE);
				ptVertex=lnX.projectPoints(ptVertex);
				ptVertex=lnX.orderPoints(ptVertex);
				ptVertex=plnBottom.projectPoints(ptVertex);
				ptAllDrills[j]=ptVertex[0];
				ptVertex[0].vis(1);
				//break;
			}
		//}
	}

	
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
				if(ptDrill.Z()>ptAllIntersect[0].Z())
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
			for (int j=0; j<bmTopPlates.length(); j++)
			{
				if (abs((bmTopPlates[j].ptCen()-ptAllDrills[i]).length())<dDistToH)
				{
					bmCloseTo=bmTopPlates[j];
				}
			}
			bmValid=bmCloseTo;
			Vector3d vyBm=bmCloseTo.vecD(vy);
			Plane plnZ (bmCloseTo.ptCen()-vyBm*(bmCloseTo.dD(vyBm)*0.5), vyBm);
			ptDrill=lnPt.intersect(plnZ, 0);
			ptDrill.vis();
		}
		Vector3d vyBm=bmValid.vecD(vy);
		double dAng=vyBm.angleTo(vy);
		double da=cos(dAng);
		double dDistToMove=(dDiam*0.5)/cos(dAng);
		ptValidDrills.append(ptDrill-vy*(dDistToMove+U(1)));
	}
}

int nToolIndexDrl=1;

Map mp;
mp.setDouble("dOffSet", dOffSet);
mp.setDouble("dOffSetCenters", dOffSetCenters);
mp.setDouble("dMaxDis", dMaxDis);
mp.setDouble("dDiam", dDiam);
if (nMaster==TRUE)
	mp.setInt("nMaster", TRUE);
else
	mp.setInt("nMaster", FALSE);
mp.setPoint3dArray("ptDrill", ptValidDrills);
_Map.setMap("mpDrill", mp);

double dThick=abs(el.dPosZOutlineBack())+abs(el.dPosZOutlineFront());
dThick=(dThick*0.5)+U(5);
double asd=abs(el.dPosZOutlineFront());
Point3d ptPlane=el.ptOrg()+vz*abs(el.dPosZOutlineFront()); ptPlane.vis();
Plane plnFront (ptPlane, vz);


for (int i=0; i<ptValidDrills.length(); i++)
{
	Line ln1(ptValidDrills[i], vz);
	plnFront.vis();
	Point3d ptDraw=ln1.intersect(plnFront, 0);
	_PtG.append(ptValidDrills[i]);
	
	ptDraw=ptDraw-vz*(dThick);
	ptDraw.vis();
	Drill drl1 (ptValidDrills[i]+vz*U(200), ptValidDrills[i]-vz*U(200), dDiam*0.5);
	drl1.addMeToGenBeamsIntersect(gbToDrill);
	
	ElemDrill drl (1, ptDraw+vz*U(dThick), -vz, U(dThick*2), dDiam,nToolIndexDrl);
	drl.setVacuum(_kNo);
	el.addTool(drl);

	//Display dp(-1);
	//Display something
	double dSize = Unit(25, "mm");
	//Display dspl (-1);
	PLine pl1(_XW);
	PLine pl2(_XW);
	PLine pl3(_XW);
	pl1.addVertex(ptDraw+vx*dSize);
	pl1.addVertex(ptDraw-vx*dSize);
	pl2.addVertex(ptDraw-vy*dSize);
	pl2.addVertex(ptDraw+vy*dSize);
	pl3.addVertex(ptDraw-vz*dSize*4);
	pl3.addVertex(ptDraw+vz*dSize*4);
	 // change linetype to specific linetype
	dp.draw(pl1);
	dp.draw(pl2);
	dp.lineType("DASHED");
	dp.draw(pl3);
	
}





#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#T"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`K-NO$.B6-R]M=ZQI]O.F-T4URB,N1D9!.1
MP0:TJ\NU/3K*\UOXDS75G;SRV]C"\+RQ*S1-]F8Y4D<'@=/04`>G0S1W$,<T
M,B212*'1T8%64C(((Z@T^L?PG_R)NA_]@^W_`/1:UL4`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'*W?Q(\
M)V-[/:7.K;)X)&BD3[/*=K*<$9"X/(KJJ\?U/_DG'C[_`+&"7_T=#7L%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7F]U_R%?BA_P!@
M^'_TE>O2*\WNO^0K\4/^P?#_`.DKT`=AX3_Y$W0_^P?;_P#HM:V*Q_"?_(FZ
M'_V#[?\`]%K6Q0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`>/ZG_P`DX\??]C!+_P"CH:]@KQ_4_P#DG'C[
M_L8)?_1T->P4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`,F=HX9)$B>5E4D1H0&<@=!D@9/N0/>O$+SQ[IJ:GXV\VSU")]7MTMH8Y(E5
MHG2%HV$@W?+\Q[9->Y5R7B3X>:+XFUBUU*Z1XY8V'V@1<?:4`X5CV(X^8<XR
M/0J`/^'NL)J_A&P$5G=PQVMO%;^;.JJLS(H5BF"20".I`_,''54R&&.WACAA
MC2.*-0B(B@*J@8``'0"GT`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%5M0ENX+":6QM4N[E%S'`\OE"0^F[!P?3(
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
D*37O^1=U/_KTE_\`0#7O95_`GZ_H3+[?I_F>GT445SGQQ__9
`





#End
