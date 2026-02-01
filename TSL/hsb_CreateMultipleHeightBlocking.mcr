#Version 8
#BeginDescription
Last modified by: Chirag Sawjani (csawjani@itw-industry.com)
16.07.2018  -  version 1.3








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
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
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 10.09.2009
* version 1.0: Release Version
*
* date: 28.06.2011
* version 1.1: Custom command for recreate the blocking
*
* date: 16.12.2011
* version 1.2: Added hsbId=12 for all blockings created
*
*/

Unit(1,"mm"); // script uses mm

int nBmType[0];
String sBmName[0];

PropDouble dHeightD1(0, U(600), T("Height Blocking Row 1"));
dHeightD1.setDescription(T("Height of the row of Blocking from the starting point to the end point. Set '0' to avoid this row"));

PropDouble dHeightD2(1, U(1200), T("Height Blocking Row 2"));
dHeightD2.setDescription(T("Height of the row of Blocking from the starting point to the end point. Set '0' to avoid this row"));

PropDouble dHeightD3(2, U(1800), T("Height Blocking Row 3"));
dHeightD3.setDescription(T("Height of the row of Blocking from the starting point to the end point. Set '0' to avoid this row"));

PropDouble dHeightD4(3, U(2400), T("Height Blocking Row 4"));
dHeightD4.setDescription(T("Height of the row of Blocking from the starting point to the end point. Set '0' to avoid this row"));

String sArNY[] = {T("No"), T("Yes")};
PropString strStager (0, sArNY,T("Stager the Blocking"));

PropDouble dTolerance(4, U(0), T("|Tolerance|"));
dTolerance.setDescription(T("|Blockings will be cut back by the tolerance value.|"));


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nStager=sArNY.find(strStager);
double dMinLength=U(50);

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	_Element.append(getElement(T("Please select a Element")));
	_Pt0=getPoint(T("Pick Starting Point"));
	_PtG.append(getPoint(T("Pick End Point")));

	_Map.setInt("ExecutionMode",0);

	return;
}

double dHeightAr[0];

if (dHeightD1>0)
	dHeightAr.append(dHeightD1);
if (dHeightD2>0)
	dHeightAr.append(dHeightD2);
if (dHeightD3>0)
	dHeightAr.append(dHeightD3);
if (dHeightD4>0)
	dHeightAr.append(dHeightD4);

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

String strChangeEntity = T("Reapply Blocking");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	_Map.setInt("ExecutionMode", 0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

//Point3d ptToDisplay[0];

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
//_Pt0=csEl.ptOrg();


if (nExecutionMode==0)
{

	for (int i=0; i<_Map.length(); i++)
	{
		if(_Map.keyAt(i)=="bm")
		{
			Entity ent = _Map.getEntity(i);
			ent.dbErase();
		}
	}
	
	_Map=Map();
	
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	if (bmVer.length()<1)	
	{
		return;
	}
	double dBeamWidth=bmVer[0].dD(vx);
	double dBeamHeight=bmVer[0].dD(vz);

// collect opening pp's
	PlaneProfile ppOp(csEl);
	//PlaneProfile ppTemp(cs);
	Opening op[0];
	op = el.opening();
	for (int i = 0; i < op.length(); i++)
	{
		PlaneProfile ppTemp(csEl);
		ppTemp.joinRing(op[i].plShape(), FALSE);
		ppTemp.shrink(- U(5));
		ppOp.unionWith(ppTemp);
	}

	PlaneProfile ppShapeBeams(csEl);
	Plane plnZ (csEl.ptOrg(), vz);
	for (int i=0; i<bmHor.length(); i++)
	{
		Beam bm=bmHor[i];
		if (bm.bIsValid())
		{
			PlaneProfile ppBm(csEl);
			ppBm = bm.realBody().extractContactFaceInPlane(plnZ, dBeamHeight);
			
			ppBm .transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
			ppBm.shrink(-U(2));
			ppShapeBeams.unionWith(ppBm);
		}

	}
	ppShapeBeams.shrink(U(2));
	ppShapeBeams.unionWith(ppOp);
	
	ppShapeBeams.vis();
	
	Point3d ptStart=_Pt0;
	Point3d ptEnd=_PtG[0];
	
	ptStart=plnZ.closestPointTo(ptStart);
	ptEnd=plnZ.closestPointTo(ptEnd);
	
	_Pt0=ptStart;
	_PtG[0]=ptEnd;
	
	Vector3d vAux=ptEnd-ptStart;
	vAux.normalize();
	
	Vector3d vDirection=vx;
	if (vx.dotProduct(vAux)<0)
	{
		vDirection=-vDirection;
		//Point3d ptA=ptStart;
		//ptStart=ptEnd;
		//ptEnd=ptA;
	}
	vDirection.vis(ptStart);
	Point3d ptDisplay[0];
	for (int d=0; d<dHeightAr.length(); d++)
	{
		Line ln(csEl.ptOrg()+vy*(dHeightAr[d])-vz*(dBeamHeight*0.5), vx);
		ptStart=ln.closestPointTo(ptStart);
		ptEnd=ln.closestPointTo(ptEnd);
		LineSeg ls(ptStart, ptEnd);
		Point3d ptAux=ls.ptMid();
		ptAux.vis(1);
		double dLengthFullBlock=(ptStart-ptEnd).length();
		Beam bmFullBlock;
		bmFullBlock.dbCreate(ls.ptMid(), vx, vy, vz, dLengthFullBlock, dBeamWidth, dBeamHeight, 0, 0, 0);
		bmFullBlock.setGrade(bmAll[0].grade());
		bmFullBlock.setMaterial(bmAll[0].material());
		bmFullBlock.setType(_kSFBlocking);
		bmFullBlock.setName("BLOCKING");
		bmFullBlock.setColor(32);
		bmFullBlock.setHsbId(12);

		Beam bmToSplit=bmFullBlock;

		PlaneProfile ppBlocking = bmToSplit.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dBeamHeight);
		
		Beam bmVerValid[0];
		for (int b = 0 ; b < bmVer.length(); b++)
		{
			Beam bm=	bmVer[b];
			PlaneProfile ppBm = bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dBeamHeight);
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
			bmAux[0].realBody().vis();
			bmVerValid.append(bmAux[0]);
		}
		
		bmVerValid=vx.filterBeamsPerpendicularSort(bmVerValid);
		
		Point3d ptCentPointBeams[0];

		Point3d ptToSplit[0];
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
			ptIntersection.append(bdAll.intersectPoints(lnSplitBm));
			
			if (ptIntersection.length()>1)
			{
				LineSeg ls1 (ptIntersection[0], ptIntersection[ptIntersection.length()-1]);
				ptToSplit.append(ls1.ptMid());
			}
			
		}
			
		Beam bmAllBlocking[0];
		int nOffset=0;
		if (nStager)
			nOffset=1;
		
		
		for(int j=0; j<ptToSplit.length()-1; j++)
		{
			//take the points where the nwe beam will be located
			//ptToSplit[j].vis(2);
			
			LineSeg ls(ptToSplit[j], ptToSplit[j+1]);
			ls.ptMid().vis();
			double dNewLength=(ptToSplit[j]-ptToSplit[j+1]).length()-dBeamWidth;
			if (nStager)
			{
				nOffset=pow(-1,j);
			}
			if (dNewLength>dMinLength)
			{
				Beam bmBlock;
				double dBlockingLength = (ptToSplit[j] - ptToSplit[j + 1]).length() - dTolerance - dBeamWidth;
				Point3d ptBmMidPoint = ls.ptMid();
				bmBlock.dbCreate(ptBmMidPoint, bmToSplit.vecX(), vy, vz, dBlockingLength, dBmH, dBmW, 0, nOffset, 0);
				bmBlock.setType(_kSFBlocking);
				bmBlock.setName("BLOCKING");
				bmBlock.setMaterial(bmToSplit.material());
				bmBlock.setGrade(bmToSplit.grade());
				bmBlock.setColor(bmToSplit.color());
				bmBlock.setHsbId(12);
				bmBlock.assignToElementGroup(el, TRUE, 0, 'Z');

				_Map.appendEntity("bm", bmBlock);
				
				bmAllBlocking.append(bmBlock);
			}
		}

		
		for (int b = 0 ; b < bmAllBlocking.length(); b++)
		{
			Beam bm=	bmAllBlocking[b];
			PlaneProfile ppBm = bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dBeamHeight);
			ppBm.intersectWith(ppShapeBeams);
			if (ppBm.area()/(U(1)*U(1)) > U(10))
				bm.dbErase();
		}
	
		//Beam bmBc[0];	
		for (int i = 0 ; i < bmAllBlocking.length(); i++)
		{	
			//PlaneProfile ppBlock(csEl);
			PlaneProfile ppBlock= bmAllBlocking[i].envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, el.zone(0).dH());
			//ppSh.shrink(U(5));
			for (int b = 0 ; b < bmAll.length(); b++)
			{	
				PlaneProfile ppBm(csEl); 
				ppBm= bmAll[b].realBody().extractContactFaceInPlane(plnZ, el.zone(0).dH());
				ppBm.intersectWith(ppBlock);
				ppBm.vis();
				if ((ppBm.area()/(U(1)*U(1))) > U(10))
				{
					//reportNotice("TRUE");
					BeamCut bc(bmAll[b].ptCen(),bmAll[b].vecX(),bmAll[b].vecY(),bmAll[b].vecZ(), bmAll[b].dL(), bmAll[b].dW(), bmAll[b].dH(),0,0,0); 
//					bmAllBlocking[i].addToolStatic(bc);//.addMeToGenBeamsIntersect(bmAllBlocking);
					//bmBc.append(bmVer[b]);
				}
			}
		}

		
		

		for (int b = 0 ; b < bmAllBlocking.length(); b++)
		{
			ptDisplay.append(bmAllBlocking[b].ptCen());
		}
		
		bmToSplit.dbErase();
	}
	
	_Map.appendPoint3dArray("Points", ptDisplay);
	_Map.setInt("ExecutionMode",1);
}


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

assignToElementGroup(el, TRUE, 0, 'E');
//eraseInstance();
//return;








#End
#BeginThumbnail






#End
#BeginMapX

#End