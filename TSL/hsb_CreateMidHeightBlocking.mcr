#Version 8
#BeginDescription
#Versions:
Version 1.27 13/05/2025 HSB-23949: pass on the property "Delete Above Opening" on tsl creation , Author Marsel Nakuci
1.26 24/10/2024 Add option for two rows at one thirds of the studs Author: Robert Pol
1.25 22.06.2023 HSB-18953: Add property to delete blocking above opening 
1.24 28.11.2022 HSB-17053: Fix bug when cutting the blockings
Version 1.23 12.05.2022 HSB-15470 purging infinite blockings
1.22 16.12.2021 HSB-13456: fix creation of blockings
1.21 23.09.2021 HSB-13245: add two extra options {"Mid Height of the Studs","Mid Height of Zone 0"} at property "Height of Blockings"
* version 1.20:  Fix issue with orientation and the the beam size.
* version 1.19:  HSB-6219 Added Feature:  Bugfix beamcut and remove automatic switch of height and width








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 27
#KeyWords Blocking
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
*  the terms and conditions stipulated in the agreement/contractd
*  under which the program has been supplied.
*  
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
* 
* #Versions:
// 1.27 13/05/2025 HSB-23949: pass on the property "Delete Above Opening" on tsl creation , Author Marsel Nakuci
//1.26 24/10/2024 Add option for two rows at one thirds of the studs Author: Robert Pol
// 1.25 22.06.2023 HSB-18953: Add property to delete blocking above opening Author: Marsel Nakuci
// 1.24 28.11.2022 HSB-17053: Fix bug when cutting the blockings Author: Marsel Nakuci
// 1.23 12.05.2022 HSB-15470 purging infinite blockings , Author Thorsten Huck
// Version 1.22 16.12.2021 HSB-13456: fix creation of blockings Author: Marsel Nakuci
// Version 1.21 23.09.2021 HSB-13245: add two extra options {"Mid Height of the Studs","Mid Height of Zone 0"} at property "Height of Blockings" Author: Marsel Nakuci
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 07.05.2010
* version 1.0: Release Version
*
* date: 13.07.2010
* version 1.1: Fix the issue of multiple beams and unlimited beams
*
* date: 07.10.2011
* version 1.2: Add Extra property to define the height of the blockings
*
* date: 14.10.2011
* version 1.3: Add property for the color of the beam
*
* date: 16.12.2011
* version 1.4: Added hsbId=12 for all blockings created 
*
* date: 19.03.2012
* version 1.5: Added blockings at 1/3rds
*
* date: 12.04.2012
* version 1.6: Add a property to cut the blocking flush to the flat studs
*
* date: 06.06.2012
* version 1.9: Fixed blockings going to the angle top plates and minimum distance check with turned studs
*
* date: 19.07.2012
* version 1.10: Ignore points which lie within the profile of vertical beams so you dont end up with beams going into infinity
*
* date: 19.07.2012
* version 1.11: The TSL will stay after generation so the result will persist
*
* date: 12.03.2013
* version 1.12: Bugfix erase instance if a blocking found in opening removed.  Flat studs excluded from vertical beams as they are dealt with later in the code. Implemented Custom command to re-apply blocking.
* 
* date: 28.08.15
* version 1.13: Added Feature: Blocking rotated 90 deg across the length of the wall positioned  Front, Centre, Back
*
* Created by: Mihai Bercuci (mihai.bercuci@hsbcad.com)
* date: 18.10.2017
* version 1.14:  Added Feature:  Cut tolerance
*
* date: 12.05.2020 (nils.gregor@hsbcad.com)
* version 1.18:  HSB-6219 Added Feature:  Full Length
*
* date: 29.05.2020 (nils.gregor@hsbcad.com)
* version 1.19:  HSB-6219 Added Feature:  Bugfix beamcut and remove automatic switch of height and width
*
* date: 10.06.2020 (nils.gregor@hsbcad.com)
* version 1.20:  Bugfix beam orientation and aligment to front and back when the blocking if the full length of the wall.
*/

Unit(1,"mm"); // script uses mm
double dEps = U(0.1);

int nBmType[0];
String sBmName[0];

String sTypes[] = { T("|Between studs|"), T("|Full length of wall|")};
PropString sType(8, sTypes, T("|Type of blocking|")); sType.setCategory("Location");

String sModes[]={T("Mid height"), T("Mid height of the Studs"), T("Mid height of Zone 0"), T("Selected height"), T("Two rows at one thirds"), T("|Two rows at one thirds of the studs|")};
PropString sMode(2,sModes,T("Height of Blockings"),0);sMode.setCategory("Location");

PropDouble dBlockingHeight(0,U(1200),T("Enter the height for blockings"));dBlockingHeight.setCategory("Location");

PropDouble dMinLength(1, U(50), T("Minimum blocking length")); dMinLength.setCategory("Blocking");

PropDouble cutTolerance (2, U(0), T("|Cut tolerance|"));cutTolerance.setCategory("Blocking");

String sArNY[] = {T("No"), T("Yes")};
PropString strCutFlush (3, sArNY,T("Cut the blocking flush to flat studs"));strCutFlush.setCategory("Blocking");

PropString strRotateFlush (4, sArNY,T("Rotate the blocking to flat studs"));strRotateFlush.setCategory("Blocking");

PropString strStager (0, sArNY,T("Stager the Blocking"));strStager.setCategory("Blocking");

// HSB-18953: add property to delete blocking above opening
PropString strDeleteAboveOpening (10, sArNY,T("Delete above opening"));strDeleteAboveOpening.setCategory("Blocking");

PropString strNailing (1, sArNY,T("Set Blocking as NO Nail"));

PropInt nColor(0, 32, T("Beam Color"));

String sJustifications[]={T("|Back|"), T("|Centre|"), T("|Front|")};
PropString sJustification(5,sJustifications,T("|Justification|"),1);sJustification.setCategory("Location");

PropString sRotateBlocking(6, sArNY,T("|Rotate all blocking|"));

String sSizeOptions[] = {T("|Element timber size|"), T("|Specify size|")};
PropString sSizeOption(7, sSizeOptions,T("|Size option|"), 0);sSizeOption.setCategory("Size");
PropDouble dSpecifiedHeight(3, U(38),T("|Blocking width|"));dSpecifiedHeight.setCategory("Size");
PropDouble dSpecifiedWidth(4, U(140),T("|Blocking height|"));dSpecifiedWidth.setCategory("Size");

String sLengthTypes[] ={ T("|Element length|"), T("|Zone 0 length|")};
PropString sLengthType(9, sLengthTypes, T("|Length of blocking depends on|"));sLengthType.setCategory("Size");

if (_bOnDbCreated)
{
	 setPropValuesFromCatalog(_kExecuteKey);
}

int nCutFlush=sArNY.find(strCutFlush);
int nStager=sArNY.find(strStager);
int nRotate=sArNY.find(strRotateFlush);
int nNoNail=sArNY.find(strNailing);
int nMode=sModes.find(sMode);
int nJustification=sJustifications.find(sJustification);
int nRotateBlocking=sArNY.find(sRotateBlocking);
int nSizeOption=sSizeOptions.find(sSizeOption);
int nType = sTypes.find(sType);
// HSB-18953:
int nDeleteAboveOpening=sArNY.find(strDeleteAboveOpening);

int nLengthType = sLengthTypes.find(sLengthType);

if(nType==1)
{
	strRotateFlush.set(sArNY[0]);
	strRotateFlush.setReadOnly(true);
}
else
	strRotateFlush.setReadOnly(false);
	
//double dMinLength=U(50);

if(_bOnInsert)
{
	
	if(insertCycleCount()>1)
	{
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName=scriptName(); // name of the script
	Vector3d vecUcsX=_XW;
	Vector3d vecUcsY=_YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	String lstPropString[0];
	double lstPropDouble[0];
	lstPropString.append(strStager);
	lstPropString.append(strNailing);
	lstPropString.append(sMode);
	lstPropString.append(strCutFlush);
	lstPropString.append(strRotateFlush);
	lstPropString.append(sJustification);
	lstPropString.append(sRotateBlocking);
	lstPropString.append(sSizeOption);
	lstPropString.append(sType);
	lstPropString.append(sLengthType);
	lstPropString.append(strDeleteAboveOpening);// HSB-23949
	
	lstPropDouble.append(dBlockingHeight);
	lstPropDouble.append(dMinLength);
	lstPropDouble.append(cutTolerance);
	lstPropDouble.append(dSpecifiedHeight);
	lstPropDouble.append(dSpecifiedWidth);
	
	lstPropInt.append(nColor);
	
	Map mpToClone;

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	eraseInstance();
	return;
}

double dHeightAr[0];

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

//return;

//if (!_Map.hasString("Hadle"))
//{ 
//	_Map.setString("Handle", _Element[0].handle());
//}
//
//if (_Map.getString("Handle") != _Element[0].handle())
//{ 
//	eraseInstance();
//	return;
//}

if (_bOnElementListModified && (_Element.length()>1)) // at least 2 items in _Element array
{	
	Element elOld = _Element[0];
	_Element.setLength(0);
	_Element.append(elOld); // overwrite 0 entry will replace the existing reference to elem0
}


{
	//Erase all blockings
	Entity entErases[]=_Map.getEntityArray("Blockings","Entry","Name");
	for(int e=entErases.length()-1; e >-1; e--)
		entErases[e].dbErase();
	_Map.removeAt("Blockings", true);
}

Element el=_Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Vector3d vecZOut = (nJustification == 0) ? - vz : vz;
_Pt0=csEl.ptOrg();

int nErase=false;

Point3d ptFront=csEl.ptOrg();
Point3d ptBack=ptFront-vz*U(el.dPosZOutlineBack());

PlaneProfile pp;

int bReport;

{
	_Map=Map();
	Beam bmVer[0];
	GenBeam genbmAll[]=el.genBeam(0);
	Beam bmAll[0];
	for(int g=0 ; g< genbmAll.length() ; g++)
	{ 
		Beam bm = (Beam)genbmAll[g];
		if ( ! bm.bIsValid()) continue;
		 bmAll.append(bm);
	}
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	
	Beam bmAngleLeft[0];
	Beam bmAngleRight[0];
	
	for (int i = 0; i < bmAll.length(); i++)
	{
		if ( bmAll[i].type()==_kSFAngledTPLeft )
		{
			bmAngleLeft.append(bmAll[i]);
		}
		else if( bmAll[i].type()==_kSFAngledTPRight )
		{
			bmAngleRight.append(bmAll[i]);
		}
	}
	
	bmVer.append(bmAngleLeft);
	Beam bmVerticalsSorted[]=vx.filterBeamsPerpendicularSort(bmAll);
	//Need to exclude any flat studs as they are catered for later in the code
	for(int b=0;b<bmVerticalsSorted.length();b++)
	{
		Beam bm=bmVerticalsSorted[b];
		if(bm.dD(vx)<bm.dD(vz))
		{
			bmVer.append(bm);
		}
	}
	bmVer.append(bmAngleRight);

	if (bmVer.length()<1)	
	{
		return;
	}
	
	int bIsElementRoof = ((ElementRoof)el).bIsValid();
	int beamType = bIsElementRoof ? _kBlocking : _kSFBlocking;
	int beamHsbId = bIsElementRoof ? - 1 : 12;
	
	double dBeamWidth=nSizeOption==0 ? el.dBeamWidth() : dSpecifiedWidth;
	double dBeamHeight=nSizeOption==0 ? el.dBeamHeight() : dSpecifiedHeight;
	double dElementDepth = el.dBeamHeight() > el.dBeamWidth() ? el.dBeamHeight() : el.dBeamWidth();
	
	
//	if (dBeamWidth>dBeamHeight)
//	{
//		double dTemp = dBeamWidth;
//		dBeamWidth=dBeamHeight;
//		dBeamHeight=dTemp;
//	}
	
// collect opening pp's
	PlaneProfile ppOp(csEl);
	Opening op[0];
	op = el.opening();
	for (int i = 0; i < op.length(); i++)
	{
		PlaneProfile ppTemp(csEl);
		ppTemp.joinRing(op[i].plShape(), FALSE);
		ppTemp.shrink(- U(5));
		ppOp.unionWith(ppTemp);
	}
	if (bIsElementRoof)
	{
		Group grpFloor = el.elementGroup();
		grpFloor.setNamePart(2, "");
		Entity arEntOpRf[] = grpFloor.collectEntities(true, OpeningRoof(), _kModelSpace);
		for ( int r = 0; r < arEntOpRf.length(); r++)
		{
			Entity ent = arEntOpRf[r];
			OpeningRoof opRf = (OpeningRoof)ent;
			if ( ! opRf.bIsValid() )
				continue;
			PlaneProfile ppTemp(csEl);
			ppTemp.joinRing(opRf.plShape(), FALSE);
			ppTemp.shrink(- U(5));
			
			ppOp.unionWith(ppTemp);
		}
	}

	PlaneProfile ppShapeBeams(csEl);
	Plane plnZ (csEl.ptOrg(), vz);
	
	for (int i=0; i<bmHor.length(); i++)
	{
		Beam bm=bmHor[i];

		PlaneProfile ppBm(csEl);
		ppBm = bm.realBody().extractContactFaceInPlane(plnZ, dBeamHeight);
		
		ppBm .transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
		ppBm.shrink(-U(2));
		ppShapeBeams.unionWith(ppBm);
	}
	
	ppShapeBeams.shrink(U(2));
	ppShapeBeams.unionWith(ppOp);

	LineSeg lsEl=el.segmentMinMax();
	Point3d ptStart=lsEl.ptStart();
	Point3d ptEnd=lsEl.ptEnd();
	Point3d ptElBottom = ptStart;
	Point3d ptElTop = ptEnd;
	if(vy.dotProduct(ptElTop-ptElBottom)<0)
	{ 
		ptElBottom = ptEnd;
		ptElTop = ptStart;
	}
	
	double dElHeight=abs(vy.dotProduct(ptStart-ptEnd));
	ElemZone eZone0 = el.zone(0);
	Beam beams[] = el.beam();
	Beam beamsStuds[] = vx.filterBeamsPerpendicular(beams);
	Beam beamsZone0[]=el.beam();
	double dStudHeight;
	for (int ib=beamsStuds.length()-1; ib>=0 ; ib--) 
	{ 
		if(beamsStuds[ib].type()!=_kStud)
		{ 
			beamsStuds.removeAt(ib);
		}
	}//next ib
	PlaneProfile ppVerticalStuds(Plane(el.ptOrg(), vz));
	for (int ib=0;ib<beamsStuds.length();ib++) 
	{ 
		ppVerticalStuds.unionWith(beamsStuds[ib].envelopeBody().
			shadowProfile(Plane(el.ptOrg(), vz)));
	}//next i
	ppVerticalStuds.vis(4);
	// get extents of profile
	LineSeg segVerticalStuds = ppVerticalStuds.extentInDir(vx);
	Point3d ptStudMid = segVerticalStuds.ptMid();
	
	
//	ptStudMid.vis(5);
	double dHeightStudMid = abs(vy.dotProduct(ptStudMid - csEl.ptOrg()));
	//
	PlaneProfile ppZone0(Plane(el.ptOrg(), vy));
	PLine plEnvelope = el.plEnvelope();
	plEnvelope.vis(2);
	PlaneProfile ppOutline = el.plOutlineWall();
//	ppOutline.transformBy((_XW + _YW) * U(100));
	ppOutline.vis(1);
	{ 
		Point3d ptZoneStart = eZone0.ptOrg();
		Point3d ptZoneEnd = ptZoneStart + eZone0.vecZ() * eZone0.dH();
		Point3d ptZone1, ptZone2;
		{ 
		// get extents of profile
			LineSeg seg = ppOutline.extentInDir(vx);
			ptZone1 = seg.ptStart();
			ptZone1 += vz * vz.dotProduct(ptZoneStart - ptZone1);
			ptZone2 = seg.ptEnd();
			ptZone2 += vz * vz.dotProduct(ptZoneEnd - ptZone2);
		}
		PLine plRecZone0;
		
		plRecZone0.createRectangle(LineSeg(ptZone1, ptZone2), vx, vz);
		ppZone0.joinRing(plRecZone0, _kAdd);
	}
	for (int ib=beamsZone0.length()-1; ib>=0 ; ib--) 
	{ 
		PlaneProfile ppBmI = beamsZone0[ib].envelopeBody(true, true).
			shadowProfile(Plane(el.ptOrg(), vy));
		if(!ppBmI.intersectWith(ppZone0))
		{ 
			beamsZone0.removeAt(ib);
		}
	}//next ib
	PlaneProfile ppVerticalZone0(Plane(el.ptOrg(), vz));
	for (int ib=0;ib<beamsZone0.length();ib++) 
	{ 
		beamsZone0[ib].envelopeBody().vis(5);
		ppVerticalZone0.unionWith(beamsZone0[ib].envelopeBody().
			shadowProfile(Plane(el.ptOrg(), vz)));
	}//next i
	LineSeg segVerticalZone0 = ppVerticalZone0.extentInDir(vx);
	Point3d ptZone0Mid = segVerticalZone0.ptMid();
	double dHeightZone0Mid = abs(vy.dotProduct(ptZone0Mid - csEl.ptOrg()));

ppVerticalZone0.vis(23);


//	return;
	if(nMode==0)
	{
		// mid height of wall
		dHeightAr.append(dElHeight*0.5);
	}
	else if(nMode==1)
	{ 
		// mid height of studs
		dHeightAr.append(dHeightStudMid);
	}
	else if(nMode==2)
	{ 
		// mid height of zone0
		dHeightAr.append(dHeightZone0Mid);
	}
	else if(nMode==3)
	{
		// slected height
		dHeightAr.append(dBlockingHeight);
	}
	else if(nMode==4)
	{
		// two rows at one thirds
		dHeightAr.append(dElHeight*0.3333333);
		dHeightAr.append(dElHeight*0.6666666);
	}
	else if(nMode==5)
	{
		// two rows at one thirds of the studs
		Point3d startPointStuds = segVerticalStuds.ptStart();
		Point3d endPointStuds = segVerticalStuds.ptEnd();
		double heightStuds = abs(vy.dotProduct(endPointStuds - startPointStuds));
		Point3d firstBlockingRowPoint = startPointStuds + vy * 0.3333333 * heightStuds;
		Point3d secondBlockingRowPoint = startPointStuds + vy * 0.6666666 * heightStuds;
		
		dHeightAr.append(abs(vy.dotProduct(firstBlockingRowPoint - csEl.ptOrg())));
		dHeightAr.append(abs(vy.dotProduct(secondBlockingRowPoint - csEl.ptOrg())));
	}
	//reportNotice("\n"+dElHeight);
	
	ptStart=plnZ.closestPointTo(ptStart);
	ptEnd=plnZ.closestPointTo(ptEnd);
	
	Vector3d vAux=ptEnd-ptStart;
	vAux.normalize();
	
	Vector3d vDirection=vx;
	if (vx.dotProduct(vAux)<0)
	{
		vDirection=-vDirection;
	}
	
	Vector3d vecYBlocking=vy;
	Vector3d vecZBlocking=vz;
	if(nRotateBlocking==1)
	{
		vecYBlocking=vz;
	 	vecZBlocking=-vy;
	}
	
	Entity entAllBlockings[0];
	for (int d=0; d<dHeightAr.length(); d++)
	{
		Line ln(csEl.ptOrg()+vy*(dHeightAr[d])-vz*(dElementDepth*0.5), vx);
//		ln.vis(1);
		if(nRotateBlocking==1)
		{
			if(nJustification==0)
			{
				ln=Line(csEl.ptOrg()+vy*(dHeightAr[d])-vz*(dElementDepth-(dBeamHeight*0.5)), vx);
			}
			if(nJustification==2)
			{
				ln=Line(csEl.ptOrg()+vy*(dHeightAr[d])-vz*(dBeamHeight*0.5), vx);
			}
		}
		else
		{ 
			if(nJustification==0)
			{
				ln=Line(csEl.ptOrg()+vy*(dHeightAr[d])-vz*(dElementDepth-(dBeamWidth*0.5)), vx);
			}
			if(nJustification==2)
			{
				ln=Line(csEl.ptOrg()+vy*(dHeightAr[d])-vz*(dBeamWidth*0.5), vx);
			}
		}
		
		if(nLengthType == 1)
		{
			Point3d ptL = bmVer[0].ptCen() - vx * 0.5 * bmVer[0].dD(vx);
			ptStart -= vx * vx.dotProduct(ptStart - ptL);
			
			Point3d ptR = bmVer.last().ptCen() + vx * 0.5 * bmVer.last().dD(vx);
			ptEnd += vx * vx.dotProduct(ptR - ptEnd);
		}
	
		ptStart=ln.closestPointTo(ptStart);
		ptEnd=ln.closestPointTo(ptEnd);
		LineSeg ls(ptStart, ptEnd);
		Point3d ptAux=ls.ptMid();
		double dLengthFullBlock=(ptStart-ptEnd).length();		
		
		Beam bmFullBlock;		
		bmFullBlock.dbCreate(ls.ptMid(), vx, vecYBlocking,vecZBlocking, dLengthFullBlock, dBeamHeight, dBeamWidth , 0, 0, 0);
		bmFullBlock.setGrade(bmAll[0].grade());
		bmFullBlock.setMaterial(bmAll[0].material());
		bmFullBlock.setType(beamType);
		bmFullBlock.setName("BLOCKING");
		bmFullBlock.setHsbId(beamHsbId);

		bmFullBlock.setColor(nColor);
		bmFullBlock.assignToElementGroup(el);
		
		nErase=true;
				
		Beam bmToSplit=bmFullBlock;

		PlaneProfile ppBlocking = bmToSplit.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dElementDepth);
		
		Beam bmVerValid[0];
		for (int b = 0 ; b < bmVer.length(); b++)
		{
			Beam bm=	bmVer[b];
			PlaneProfile ppBm = bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dElementDepth);
			ppBm.intersectWith(ppBlocking);
			if (ppBm.area()/(U(1)*U(1)) > U(10))
				bmVerValid.append(bm);
		}
		
		Beam bmAux[0];
		bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptStart, -vDirection);
		if (bmAux.length()>0)
			bmVerValid.append(bmAux[0]);

		bmAux.setLength(0);
		bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptEnd, vDirection);

		if (bmAux.length()>0)
		{
			bmVerValid.append(bmAux[0]);
		}
		
		for (int i=0; i<bmVerValid.length()-1; i++)
		{
			for (int j=i+1; j<bmVerValid.length(); j++)
			{
				if (bmVerValid[i].handle()==bmVerValid[j].handle())
				{
					bmVerValid.removeAt(i);
					i--;
					break;
				}
			}
		}
		
		//bmVerValid=vx.filterBeamsPerpendicularSort(bmVerValid);

		Point3d ptCentPointBeams[0];

		Point3d ptToSplit[0];
		Beam bmSplit[0];
		//central line in the split beam
		Vector3d vxBm=bmToSplit.vecX();
		Line lnSplitBm(bmToSplit.ptCen(),bmToSplit.vecX()); 

		double dBmH=bmToSplit.dD(bmToSplit.vecY()); 
		double dBmW=bmToSplit.dD(bmToSplit.vecZ());
		//find the points where the beams have intersection

		for(int j=0; j<bmVerValid.length(); j++)
		{
			Point3d ptIntersection[0];
			Body bdAll=bmVerValid[j].envelopeBody(TRUE, TRUE);
			//bdAll.vis();
			ptIntersection.append(bdAll.intersectPoints(lnSplitBm));
					
			if (ptIntersection.length()>1)
			{
				LineSeg ls1 (ptIntersection[0], ptIntersection[ptIntersection.length()-1]);
				ptToSplit.append(ls1.ptMid());
				//ls1.ptMid().vis(2);
				bmSplit.append(bmVerValid[j]);
			}
		}
		
		//Sort points from left to right of element
		ptToSplit=ln.orderPoints(ptToSplit,0);
		
		Beam bmAllBlocking[0];
		int nOffset=0;
		if (nStager)
			nOffset=1;
			
		//create plane profile of all vertical beams
		Plane plVertical(el.ptOrg(),vz);

		PlaneProfile ppVerticalBeams(plVertical);
		
		for(int b=0;b<bmVerValid.length();b++)
		{
			Beam bmCurr=bmVerValid[b];
			Body bd=bmCurr.envelopeBody();
			PlaneProfile pp=bd.shadowProfile(plVertical);
			if(b==0)
			{
				ppVerticalBeams=pp;
			}
			else
			{
				ppVerticalBeams.unionWith(pp);
			}
		}
		
		if (nType == 0)
		{
			for (int j = 0; j < ptToSplit.length() - 1; j++)
			{
				
				//take the points where the nwe beam will be located
				LineSeg ls(ptToSplit[j], ptToSplit[j + 1]);
				Point3d ptFace1 = ptToSplit[j] + bmVerValid[j].dD(vx) * 0.5 * vx; //Gets the face of the left beam
				Point3d ptFace2 = ptToSplit[j + 1] - bmVerValid[j].dD(vx) * 0.5 * vx; //Gets the face of the right beam
				
				//if the midpoint lies inside the beams then its likely that beams are crossing over so ignore that point
				//ppVerticalBeams.vis(1);
				if ((ppVerticalBeams.pointInProfile(ls.ptMid()) == _kPointInProfile || ppVerticalBeams.pointInProfile(ls.ptMid()) == _kPointOnRing))
				{
					continue;
				}
				
				double dNewLength = (ptFace1 - ptFace2).length();
				if (nStager)
				{
					nOffset = pow(-1,j);
				}
				if (dNewLength > dMinLength)
				{
					Beam bmBlock;
//					bmBlock.dbCreate(ls.ptMid(), bmToSplit.vecX(), vecYBlocking, vecZBlocking, (ptToSplit[j] - ptToSplit[j + 1]).length() - dBeamWidth, dBmH, dBmW, 0, nOffset, 0);
					// HSB-13456:
					bmBlock.dbCreate(ls.ptMid(), bmToSplit.vecX(), vecYBlocking, vecZBlocking, dNewLength, dBmH, dBmW, 0, nOffset, 0);
					bmBlock.setType(bmToSplit.type());
					bmBlock.setName(bmToSplit.name());
					bmBlock.setMaterial(bmToSplit.material());
					bmBlock.setGrade(bmToSplit.grade());
					bmBlock.setColor(bmToSplit.color());
					bmBlock.setHsbId(bmToSplit.hsbId());
					bmBlock.assignToElementGroup(el, TRUE, 0, 'Z');
					//ptToSplit[j].vis(2);
					//ptToSplit[j+1].vis(3);
					if (nNoNail)
					{
						bmBlock.setBeamCode("BLOCKING;;;;;;;;NO;");
					}
					
					Beam bmAux1[0];
					bmAux1 = Beam().filterBeamsHalfLineIntersectSort(bmVer, ls.ptMid(), vx);
					if (bmAux1.length() > 0)
					{
						//bmBlock.stretchStaticTo(bmAux1[0], true);
						//bmBlock.stretchStaticTo(bmAux1[0], true);
						Point3d ptbmAux1 = bmAux1[0].ptCen(); //ptbmAux1.vis(1);
						Point3d ptbmBlock = bmBlock.ptCen(); //ptbmBlock.vis();
						
						Line lnX0 (bmAux1[0].ptCen(), bmAux1[0].vecX());
						//Line lnX0 (bmAux1[0].ptCen(), vy);
						Line lnX1 (bmBlock.ptCen(), bmBlock.vecX());
						//Line lnX1 (bmBlock.ptCen(), vx);
						Point3d intersectionPoint = lnX0.closestPointTo(lnX1);
//						intersectionPoint.vis(1);
						Point3d firstCut = intersectionPoint - vx * ((bmAux1[0].dD(bmBlock.vecX()) * 0.5) + cutTolerance);
//						firstCut.vis(1);
						//Point3d secondCut = intersectionPoint - bmBlock.vecX() * ((dBeamWidth  * 0.5)+cutTolerance);
						//firstCut.vis(2);
						
						//secondCut.vis(3);
						//vx.vis(intersectionPoint,8);
						//vy.vis(intersectionPoint,9);
						//vz.vis(intersectionPoint,11); 
						
						Cut ctBeam1(firstCut, vx);
						//ctBeam1.setMustCut(TRUE);
						//Cut ctBeam2(secondCut,   -bmBlock.vecX());
						
						bmBlock.addToolStatic(ctBeam1, _kStretchOnInsert );
						//bmBlock.addTool(ctBeam2);
					}
					
					
					Beam bmAux2[0];
					bmAux2 = Beam().filterBeamsHalfLineIntersectSort(bmVer, ls.ptMid(), - vx);
					if (bmAux2.length() > 0)
					{
						//bmBlock.stretchStaticTo(bmAux2[0], true);
						Line lnX0 (bmAux2[0].ptCen(), bmAux2[0].vecX());
						//Line lnX0 (bmAux2[0].ptCen(), vy);
						Line lnX1 (bmBlock.ptCen(), bmBlock.vecX());
						//Line lnX1 (bmBlock.ptCen(), vx);
						Point3d intersectionPoint = lnX0.closestPointTo(lnX1);
//						intersectionPoint.vis(3);
						// HSB-17053
						Point3d secondCut = intersectionPoint + vx * ((bmAux2[0].dD(bmBlock.vecX()) * 0.5) + cutTolerance);
//						secondCut.vis(3);
						Cut ctBeam2(secondCut, - vx);
						bmBlock.addToolStatic(ctBeam2, _kStretchOnInsert);
					}
					bmAllBlocking.append(bmBlock);
				}
			}
		}
		else
		{			
			PlaneProfile ppBm = bmFullBlock.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dElementDepth);
			PlaneProfile ppCheck = ppBm;
			ppCheck.subtractProfile(ppShapeBeams);
			ppBm.subtractProfile(ppCheck);//ppShapeBeams.vis(2);
			
			PLine plBms[] = ppBm.allRings();
			Point3d ptBCs[0];
			Point3d ptSplits[0];
			
			if (nNoNail)
			{
				bmFullBlock.setBeamCode("BLOCKING;;;;;;;;NO;");
			}
			
			for (int r=0;r<plBms.length();r++) 
			{ 
				PlaneProfile ppBmRing = PlaneProfile(plBms[r]); ppBmRing.vis(3);
				LineSeg seg = ppBmRing.extentInDir(vx);
				Point3d ptStart = seg.ptStart();
				Point3d ptEnd = seg.ptEnd();
				
			// Split the beam
				if(vy.dotProduct(ptEnd - ptStart) > bmFullBlock.dD(vy) - dEps)
				{
					ptSplits.append(ptStart);
					ptSplits.append(ptEnd);
				}
				else
				{
					ptBCs.append(ptStart);
					ptBCs.append(ptEnd);
				}				 
			}//next r
				
			
			Line lnX(ptStart, -vx);
			ptSplits = lnX.orderPoints(ptSplits);

			if(ptSplits.length()%2 == 0)
			{
				for (int c=0;c<ptSplits.length();c+=2) 
				{ 
					Beam bmSplit = bmFullBlock.dbSplit(ptSplits[c], ptSplits[c+1]);
					bmAllBlocking.append(bmSplit);					 
				}//next c					
			}
			else
				reportMessage(T("|No valid result. Cut beam manually|"));
				
			bmAllBlocking.append(bmFullBlock);	
				
			if(ptBCs.length()%2 == 0)
			{
				for (int c=0;c<ptBCs.length();c+=2) 
				{ 
					Point3d ptBC = ptBCs[c] + vz * vz.dotProduct(bmFullBlock.ptCen() - ptBCs[c]); 
					BeamCut bc(ptBC - 0.5 * vy * dEps, vx, vy, vz, vx.dotProduct(ptBCs[c+1] - ptBCs[c]), vy.dotProduct(ptBCs[c+1] - ptBCs[c]) + dEps, bmFullBlock.dD(vz) + dEps, 1, 1, 0);
					
					Beam bmAdds[] = bc.cuttingBody().filterGenBeamsIntersect(bmAllBlocking);
					
					for (int n=0;n<bmAdds.length();n++) 
					{ 
						bmAdds[n].addToolStatic(bc);
						 
					}//next n				 
				}//next c					
			}
			else
				reportMessage(T("|No valid result. Cut beam manually|"));
			
			for (int c=0;c<bmAllBlocking.length();c++) 
			{ 
				Beam bmBlocking = bmAllBlocking[c]; 
				Body bdBlocking = bmBlocking.realBody();
				
				Beam bmIntersects[] = bdBlocking.filterGenBeamsIntersect(bmVer);
				Point3d ptCBl = bmBlocking.ptCen();
				
				for (int v=bmIntersects.length()-1;v > -1;v--) 
				{ 
					Beam bmInter = bmIntersects[v]; 
					Point3d ptCInter = bmInter.ptCen();
					double dDiff = abs(vz.dotProduct(ptCBl - ptCInter));

					if(0.5*(bmBlocking.dD(vz) - bmInter.dD(vz)) - dDiff > -dEps)
					{
						bReport = true;
					}
					else
					{
						Point3d ptBc = (nJustification == 1)	? bmBlocking.ptCen() : bmBlocking.ptCen() + vecZOut*0.5*dEps;	
						BeamCut bc(ptBc, vx, vy, vz, bmBlocking.dL()+dEps, bmBlocking.dD(vy), bmBlocking.dD(vz) + dEps, 0, 0, 0);
						bmInter.addTool(bc); 
					}
					 
				}//next v
				
				 
			}//next c
			
	
		}
		
		int nErasedBeams[0];
			
		if(nType == 0)
		{	
			for (int b = 0 ; b < bmAllBlocking.length(); b++)
			{
				Beam bm=	bmAllBlocking[b];
				PlaneProfile ppBm = bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dElementDepth);
	
				ppBm.intersectWith(ppShapeBeams);
				if (ppBm.area()/(U(1)*U(1)) > U(10))
				{
					bm.dbErase();
					nErasedBeams.append(TRUE);
					//eraseInstance();
				}
				else
				{
					nErasedBeams.append(FALSE);
				}
			}
	
		//Beam bmBc[0];	

			for (int i = 0 ; i < bmAllBlocking.length(); i++)
			{	
				//Check if the blocking has been erased
				if(nErasedBeams[i]) continue;
				
				//PlaneProfile ppBlock(csEl);
				Beam bm=bmAllBlocking[i];
				PlaneProfile ppBlock= bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, el.zone(0).dH());
				//ppSh.shrink(U(5));
				
				for (int b = 0 ; b < bmAll.length(); b++)
				{	
					PlaneProfile ppBm(csEl); 
					ppBm= bmAll[b].realBody().extractContactFaceInPlane(plnZ, el.zone(0).dH());
					ppBm.intersectWith(ppBlock);
					//ppBm.vis();
					if ((ppBm.area()/(U(1)*U(1))) > U(10))
					{
						if (nCutFlush || nRotate)
						{
							if (nRotate)
							{
								//if (vz.dotProduct(bm.ptCen()-bmAll[b].ptCen())<0)
								
								CoordSys csAlignTo;
								csAlignTo.setToAlignCoordSys(bm.ptCen(), bm.vecX(), bm.vecY(), bm.vecZ(), bm.ptCen(), bm.vecX(), bm.vecZ(), -bm.vecY());
								bm.transformBy(csAlignTo);
							}
							else
							{
								bm.stretchStaticTo(bmAll[b], true);
							}
						}
						else
						{
							//reportNotice("TRUE");
							BeamCut bc(bmAll[b].ptCen(),bmAll[b].vecX(),bmAll[b].vecY(),bmAll[b].vecZ(), bmAll[b].dL(), bmAll[b].dW(), bmAll[b].dH()+U(2),0,0,0); 
							bm.addToolStatic(bc);//.addMeToGenBeamsIntersect(bmAllBlocking);
							//bmBc.append(bmVer[b]);
						}
					}
				}
			}
		}	
		
		Point3d ptDisplay[0];
		
		// purge infinte beams
		for (int i=bmAllBlocking.length()-1; i>=0 ; i--) 
		{
			Beam b = bmAllBlocking[i];
			if (b.bIsValid() && b.solidLength()>U(10e3))
			{
				bmAllBlocking.removeAt(i);
				b.dbErase();
			}			
		}


		
		for (int b = 0 ; b < bmAllBlocking.length(); b++)
		{
			Beam bmBlocking=bmAllBlocking[b];
			ptDisplay.append(bmBlocking.ptCen()); 
			if(nType == 0 && nErasedBeams[b]) 
				continue;
			entAllBlockings.append((Entity)bmBlocking);
		}
		_Map.appendPoint3dArray("Points", ptDisplay);
		//Set all new blockings to the map

		if(nType == 0)
			bmToSplit.dbErase();
	}
	
	if(nDeleteAboveOpening)
	{ 
	// delete blocking above opening
		Opening opAll[]=el.opening();
		PlaneProfile ppAboveOpening;
		Plane pnOpening;
		for(int i=0;i<opAll.length();i++)
		{
			Opening op=opAll[i];
			PLine plOpening=op.plShape();
			PlaneProfile ppOpening(plOpening);
			ppOpening.vis(5);
			LineSeg lsOpening=ppOpening.extentInDir(vx);
			lsOpening.vis();
			Point3d ptLineSegmentStart=lsOpening.ptStart();
			Point3d ptLineSegmentEnd=lsOpening.ptEnd();
			
			//Extend end point of Line segment to create a bigger plane profile in the Y Vector of the wall
			Point3d ptNewEndPoint=ptLineSegmentEnd+U(15000)*vy;
			LineSeg lnNewSegment(ptLineSegmentStart,ptNewEndPoint);
			
			//Create Rectangle covering the opening and the beams above the opening
			PLine plAboveOpening;
			plAboveOpening.createRectangle(lnNewSegment,vx,vy);
			ppAboveOpening=PlaneProfile(plAboveOpening);
			
			//Create a Plane that can be used for the shadow profile
			pnOpening=Plane(ptLineSegmentStart,vz);
			
			//Check if any blocking pieces are above the opening, if so delete them.
			for (int i=entAllBlockings.length()-1; i>=0 ; i--) 
			{
				Beam bm=(Beam)entAllBlockings[i];
				Body bd=bm.realBody();
				PlaneProfile ppBeam=bd.shadowProfile(pnOpening);
				ppBeam.vis();
				ppBeam.intersectWith(ppAboveOpening);
					
				if(ppBeam.area()>U(10))
				{
					bm.dbErase();
				}
			}
		}
	}
	
	
	//reportNotice("\n Added " + entAllBlockings.length());
	_Map.setEntityArray(entAllBlockings,false,"Blockings","Entry","Name");
	
	_ThisInst.assignToElementGroup(el, TRUE, 0, 'T');
}

if(bReport)
	reportMessage(T("|No tool, beam would be splitted|"));


Point3d ptToDisplay[0];
if (_Map.hasPoint3dArray("Points"));
for (int i=0; i<_Map.length(); i++)
{
	if (_Map.keyAt(i)=="Points")
		ptToDisplay.append(_Map.getPoint3dArray(i));
}
	
Display dp(-1);

for (int i=0; i<ptToDisplay.length(); i++)
{
	LineSeg ls (ptToDisplay[i]-vx*U(5), ptToDisplay[i]+vx*U(5));
	dp.draw(ls);
}

//if (_bOnElementConstructed || nErase)
//{
//	eraseInstance();
//	return;
//}
//








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
        <int nm="BreakPoint" vl="954" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23949: pass on the property &quot;Delete Above Opening&quot; on tsl creation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="5/13/2025 7:46:12 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option for two rows at one thirds of the studs" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="10/24/2024 9:10:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18953: Add property to delete blocking above opening" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="6/22/2023 2:16:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17053: Fix bug when cutting the blockings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="11/28/2022 11:04:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15470 purging infinite blockings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="5/12/2022 2:23:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13456: fix creation of blockings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="12/16/2021 2:12:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13245: add two extra options {&quot;Mid Height&quot;,&quot;Mid Height of Zone 0&quot;} at property &quot;Height of Blockings&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="9/23/2021 11:49:51 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End