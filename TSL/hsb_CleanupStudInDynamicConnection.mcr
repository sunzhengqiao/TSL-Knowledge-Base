#Version 8
#BeginDescription
Moves the left and right studs back to the location of the sheeting zone define by the material.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 11.11.2014  -  version 1.5










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
* date: 29.02.2012
* version 1.0: Release Version
*
* date: 14.03.2012
* version 1.1: Bugfix
*
* date: 07.10.2013
* version 1.2: Add option for when no elements are selected
*
* date: 10.11.2014
* version 1.4: Added support for multiple material.
*
* date: 11.11.2014
* version 1.5: Add property for a gap.
*/

U(1,"mm");	

PropString sMaleWalls (0, "A;B;C;", T("Male Wall Code"));

PropString sFemaleWalls (1, "A;B;C;", T("Female Wall Code"));

PropString sMaterials (2, "Plasterboard", T("Sheet Material"));

PropDouble dWallGap (0, 0, T("Extra Gap"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

_ThisInst.setSequenceNumber(50);

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
	
	String strScriptName = scriptName(); // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[0];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropString.append(sMaleWalls);
	lstPropString.append(sFemaleWalls);
	lstPropString.append(sMaterials);
	lstPropDouble.append (dWallGap);
	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}


if( _Element.length()<=0 )
{
	eraseInstance();
	return;
}

String arSCodeMaleWalls[0];

String s = sMaleWalls+ ";";
int nIndex = 0;
int sIndex = 0;
while(sIndex < s.length()-1)
{
 	String sToken = s.token(nIndex);
	nIndex++;
	if(sToken.length()==0)
	{
		sIndex++;
		continue;
	}
	sIndex = s.find(sToken,0);
	sToken.trimLeft();
	sToken.trimRight();
	sToken.makeUpper();
	arSCodeMaleWalls.append(sToken);
}


String arSCodeMaterials[0];

s = sMaterials+ ";";
nIndex = 0;
sIndex = 0;
while(sIndex < s.length()-1)
{
 	String sToken = s.token(nIndex);
	nIndex++;
	if(sToken.length()==0)
	{
		sIndex++;
		continue;
	}
	sIndex = s.find(sToken,0);	
	sToken.trimLeft();
	sToken.trimRight();
	sToken.makeUpper();
	arSCodeMaterials.append(sToken);
}


String arSCodeFemaleWalls[0];

s = sFemaleWalls+ ";";
nIndex = 0;
sIndex = 0;
while(sIndex < s.length()-1)
{
	String sToken = s.token(nIndex);
	nIndex++;
	if(sToken.length()==0)
	{
		sIndex++;
		continue;
	}
	sIndex = s.find(sToken,0);
	arSCodeFemaleWalls.append(sToken);
}


ElementWallSF el = (ElementWallSF)_Element[0];

if (!el.bIsValid()){
	eraseInstance();
	return;
}

String strElCode=el.code();
String strElNumber=el.number();

int nFound=arSCodeMaleWalls.find(strElCode, -1);

if (nFound==-1 && arSCodeMaleWalls.length()>0)
{
	eraseInstance();
	return;
}

int nErase=false;

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();

_Pt0=ptOrgEl;

TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		tslAll[i].dbErase();
	}
}

double dElThick=abs(el.dPosZOutlineBack());

Line lnFront (ptOrgEl, vx);
//Line lnBack (ptOrgEl-vz*(dElThick), vx);
Plane plnY(ptOrgEl, vy);

//LineSeg lsEl=el.segmentMinMax();

PLine plElement=el.plOutlineWall();

PlaneProfile ppEl(plnY);
ppEl.joinRing(plElement, false);

LineSeg lsEl=ppEl.extentInDir(el.vecX());

double dLen=abs(el.vecX().dotProduct(lsEl.ptStart()-lsEl.ptEnd()));

Point3d ptLeft=ptOrgEl;
Point3d ptRight=ptOrgEl+vx*dLen;ptRight.vis(3);

Beam bmAll[]=el.beam();

Beam bmToCut[0];
Beam bmToStretch[0];

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	if ( bm.type()==_kSFTopPlate 	|| bm.type()==_kSFBottomPlate || bm.type()==_kSFAngledTPLeft || bm.type()==_kSFAngledTPRight )
	{
		bmToCut.append(bm);
	}
	if ( bm.type()==_kSFBlocking)
	{
		bmToStretch.append(bm);
	}
}

if (bmAll.length()<1) return;

Element elAllCon[]=el.getConnectedElements();

String sCorner;
String sJunction[0];
int nCon=0;

for (int e=0; e<elAllCon.length(); e++)
{
	ElementWallSF elC=(ElementWallSF) elAllCon[e];
	if (!elC.bIsValid()) continue;
	
	String strElCodeC=elC.code();
	String strElNumberC=elC.number();

	int nFoundC=arSCodeFemaleWalls.find(strElCodeC, -1);

	if (nFoundC==-1 && arSCodeFemaleWalls.length()>0) continue;
	
	PLine plout=elC.plOutlineWall();
	plout.vis(1);
	//Element vectors
	CoordSys csElC=elC.coordSys();
	Vector3d vxC = csElC.vecX();
	Vector3d vyC = csElC.vecY();
	Vector3d vzC = csElC.vecZ();
	Point3d ptOrgElC=csElC.ptOrg();
	double dElThickC=abs(elC.dPosZOutlineBack());
	Line lnFrontC (ptOrgElC, vxC);
	Line lnBackC (ptOrgElC-vzC*(dElThickC), vxC);
	Point3d ptF,ptB;
	ptF=lnFront.closestPointTo(lnFrontC);
	ptB=lnFront.closestPointTo(lnBackC);
	
	//ptF.vis(1); ptB.vis(2);
	
	Point3d ptJunction;
	Point3d ptFarSide;
	//ptRight.vis();
	double dB=abs(vx.dotProduct(ptFarSide-ptRight));
	//if (abs(vx.dotProduct(ptOrgEl-ptF))>dLen+U(5) || abs(vx.dotProduct(ptOrgEl-ptB))>dLen+U(5))
	//	continue;
	
	if (abs(vx.dotProduct(ptOrgEl-ptF))>abs(vx.dotProduct(ptOrgEl-ptB)))
	{
		ptJunction=ptB;
		ptFarSide=ptF;
	}
	else
	{
		ptJunction=ptF;
		ptFarSide=ptB;
	}
	
	ptJunction.vis(1);
	ptFarSide.vis(2);
	
	//if (vx.dotProduct(ptFarSide-ptOrgEl)<0)
	//	continue;
	
	int nMove=false;
	Point3d ptToMove;
	Vector3d vDirToMove=vx;
	ElemZone elZoneToCheck;
	
	int nCorner=FALSE;
	//Check the connections
	if (abs(vx.dotProduct(ptJunction-ptLeft))<U(5))//Left
	{
		nCorner=TRUE;
		nCon++;
		
		Vector3d vDir(ptFarSide-ptLeft);
		vDir.normalize();
		double dSheetThickness;
		if (elC.vecZ().dotProduct(vDir)>0)//Back
		{
			for (int i=-1; i>-6; i--)
			{
				ElemZone ez=elC.zone(i);
				String sThis=ez.material().makeUpper();
				if ( arSCodeMaterials.find(ez.material().makeUpper(), -1) != -1 && ez.dH()>0)
				{
					ptToMove=lnFront.closestPointTo(ez.ptOrg()+ez.vecZ()*ez.dH());
					elZoneToCheck=ez;
					nMove=true;
				}
			}
		}
		else//Front
		{
			for (int i=1; i<6; i++)
			{
				ElemZone ez=elC.zone(i);
				if ( arSCodeMaterials.find(ez.material().makeUpper(), -1) != -1 && ez.dH()>0)
				{
					ptToMove=lnFront.closestPointTo(ez.ptOrg()+ez.vecZ()*ez.dH());
					elZoneToCheck=ez;
					nMove=true;
				}
			}
		}
		//Move the beams left
		vDirToMove=vx;
	}
	else if (abs(vx.dotProduct(ptJunction-ptRight))<U(5))//Right
	{
		nCorner=TRUE;
		nCon++;

		Vector3d vDir(ptFarSide-ptRight);
		vDir.normalize();
		double dSheetThickness;

		if (elC.vecZ().dotProduct(vDir)>0)//Back
		{
			for (int i=-1; i>-6; i--)
			{
				ElemZone ez=elC.zone(i);
				if (arSCodeMaterials.find(ez.material().makeUpper(), -1) != -1 && ez.dH()>0)
				{
					ptToMove=lnFront.closestPointTo(ez.ptOrg()+ez.vecZ()*ez.dH());//+ez.coordSys().vecZ()*ez.dH()
					elZoneToCheck=ez;
					nMove=true;
				}
			}
		}
		else//Front
		{
			for (int i=1; i<6; i++)
			{
				ElemZone ez=elC.zone(i);
				String sThis=ez.material().makeUpper();
				if (arSCodeMaterials.find(ez.material().makeUpper(), -1) != -1 && ez.dH()>0)
				{
					ptToMove=lnFront.closestPointTo(ez.ptOrg()+ez.vecZ()*ez.dH());//+ez.coordSys().vecZ()*ez.dH()
					elZoneToCheck=ez;
					nMove=true;
				}
			}
		}
		//Move the beams right
		vDirToMove=-vx;
	}
	
	if (nMove)
	{
		Beam bmVer[]=vDirToMove.filterBeamsPerpendicularSort(bmAll);
		Beam bmToMove[0];
		
		PlaneProfile ppZone(plnY);
		
		GenBeam bmZone[]=elC.genBeam(elZoneToCheck.zoneIndex());
		for (int i=0; i<bmZone.length(); i++)
		{
			PlaneProfile ppThisGB=bmZone[i].realBody().shadowProfile(plnY);
			ppZone.unionWith(ppThisGB);
		}
		/*
		ElemZone ez=elZoneToCheck;
		LineSeg lsZone(ez.ptOrg()-ez.coordSys().vecX()*U(10000), ez.ptOrg()+ez.vecZ()*ez.dH()+ez.coordSys().vecX()*U(10000));
		PLine plZone(vy);
		plZone.createRectangle(lsZone, vx, -vz);
		*/
		ppZone.vis();
		
		if (bmVer.length()>0)
		{
			int nValidMove=false;
			for (int i=0; i<bmVer.length(); i++)
			{
				Beam bm=bmVer[i];
				
				if (nValidMove)
				{
					Beam bmPrev=bmVer[i-1];
					if (abs(vx.dotProduct(bmPrev.ptCen()-bm.ptCen()))< ((bmPrev.dD(vx)*0.5)+bm.dD(vx)*0.5)+U(1))
					{
						bmToMove.append(bm);
					}
					else
					{
						break;
					}
				}
				if (i==0)
				{
					PlaneProfile ppBm=bm.realBody().shadowProfile(plnY);
					ppBm.intersectWith(ppZone);
					if (ppBm.area()/U(1)*U(1) > U(5))
					{
						nValidMove=true;
						bmToMove.append(bm);
					}
				}

				nErase=true;
				//bmLeft.append(bmVer[0]);
				//bmRight.append(bmVer[bmVer.length()-1]);
			}
		}
		
		if (bmToMove.length()>0)
		{
			double dDist=0;
			
			//Move the point that define the cut
			ptToMove.transformBy(vDirToMove*dWallGap);
			
			
			for (int i=0; i<bmToMove.length(); i++)
			{
				Beam bm=bmToMove[i];
				if (i==0)
				{
					dDist=abs(vx.dotProduct(bm.ptCen()-vDirToMove*(bm.dD(vx)*0.5)-ptToMove));
					
				}
				bm.transformBy(vDirToMove*dDist);
			}
			//reportNotice("\n"+dDist);
			
			//Stretch Top and Bottom Plate
			
			Cut ct(ptToMove, -vDirToMove);

			Beam bmValidToCut[0];
			bmValidToCut=bmToMove[0].filterBeamsCapsuleIntersect(bmToCut);
			for (int i=0; i<bmValidToCut.length(); i++)
			{
				bmValidToCut[i].addToolStatic(ct, true);
			}
			
			Beam bmValidToStretch[0];
			bmValidToStretch=bmToMove[bmToMove.length()-1].filterBeamsCapsuleIntersect(bmToStretch);
			for (int i=0; i<bmValidToStretch.length(); i++)
			{
				bmValidToStretch[i].stretchStaticTo(bmToMove[bmToMove.length()-1], true);
			}
		}
	}
	ptToMove.vis(2);
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}



#End
#BeginThumbnail






#End