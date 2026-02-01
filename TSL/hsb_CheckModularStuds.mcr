#Version 8
#BeginDescription
Creates a stud or circle when centres between studs have been exceeded

Modify by: Alberto Jena (aj@hsb-cad.com)
Date: 31.10.2018 - version 1.2



















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  UK
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
* date: 03.04.2012
* version 1.0: Release Version
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 12.07.2013
* version 1.1: Added option for showing circle insead of creating a beam, and added extrusion profile to new beams created
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 31.10.2018
* version 1.2: Addition of Units for dia of circle in metric & imperial 
*
*/

U(1,"mm");	



_ThisInst.setSequenceNumber(120);

String sOptions[]={"Create Stud", "Show Circle"};
PropString strOptions (0,sOptions,T("Select Option"),0);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

PropInt nColor(0,1,T("Circle Colour"));

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
	
	lstPropInt.append(nColor);
	lstPropString.append(strOptions);
	//lstPropString.append(sFemaleWalls);
	//lstPropString.append(sMaterial);
	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];

		TslInst tslAll[]=el.tslInstAttached();
		 for (int i=0; i<tslAll.length(); i++)
		 {
			  if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
			  {
				   tslAll[i].dbErase();
			  }
		 }	
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}


int nOption=sOptions.find(strOptions,0);
strOptions.setReadOnly(true);

if( _Element.length()<=0 )
{
	eraseInstance();
	return;
}

ElementWallSF el = (ElementWallSF)_Element[0];

if (!el.bIsValid()){
	eraseInstance();
	return;
}

String strElCode=el.code();
String strElNumber=el.number();

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();

_Pt0=ptOrgEl;

Plane pln(ptOrgEl, vz);

PlaneProfile ppOp(pln);

Opening opAll[]=el.opening();
for (int n=0; n<opAll.length(); n++)
{
	OpeningSF op=(OpeningSF) opAll[n];
	if (!op.bIsValid())
		continue;
	
	PLine plOp=op.plShape();
	Point3d ptAllVertex[]=plOp.vertexPoints(FALSE);

	Point3d ptCenOp;
	ptCenOp.setToAverage(ptAllVertex);
		
	Line lnX (ptCenOp, vx);
	
	ptAllVertex=lnX.projectPoints(ptAllVertex);
	ptAllVertex=lnX.orderPoints(ptAllVertex);
	
	LineSeg lsOp(ptAllVertex[0]-vy*U(4000), ptAllVertex[ptAllVertex.length()-1]+vy*U(4000));
	
	PLine plOpNew(vz);
	plOpNew.createRectangle(lsOp, vx, vy);
	
	ppOp.joinRing(plOpNew, FALSE);
}

ppOp.vis();

double dElThick=abs(el.dPosZOutlineBack());

Line lnFront (ptOrgEl, vx);
//Line lnBack (ptOrgEl-vz*(dElThick), vx);
Plane plnY(ptOrgEl, vy);

LineSeg lsEl=el.segmentMinMax();

double dLen=abs(el.vecX().dotProduct(lsEl.ptStart()-lsEl.ptEnd()));

Point3d ptLeft=ptOrgEl;
Point3d ptRight=ptOrgEl+vx*dLen;ptRight.vis(3);

//Get beams from zone 0
Beam bmAll[0];
GenBeam gbmAll[]=el.genBeam(0);
for(int g=0;g<gbmAll.length();g++)
{
	Beam bm=(Beam)gbmAll[g];
	if(bm.bIsValid())
	{
		bmAll.append(bm);
	}
}

if(bmAll.length()==0) return;

double dBmWidth=el.dBeamWidth();
double dBmHeight=el.dBeamHeight();
	
//Check which is the smallest section width.
if(dBmWidth>dBmHeight)
{
	 dBmWidth=el.dBeamHeight();
	dBmHeight=el.dBeamWidth();
}


Beam bmTop[0];
Beam bmBottom[0];
Beam bmBlocking[0];

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	if ( bm.type()==_kSFTopPlate || bm.type()==_kSFAngledTPLeft || bm.type()==_kSFAngledTPRight )
	{
		bmTop.append(bm);
	}
	if ( bm.type()==_kSFBottomPlate)
	{
		bmBottom.append(bm);
	}
	if ( bm.type()==_kSFBlocking)
	{
		bmBlocking.append(bm);
	}
}

Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);

if (bmVer.length()<1) return;

Beam bmToCheck[0];
for (int i=0; i<bmVer.length(); i++)
{
	Beam bm=bmVer[i];
	if (bm.dD(vz)>bm.dD(vx))
	{
		bmToCheck.append(bm);
	}
}

double dTolerance=U(1);
double dSpacing=el.spacingBeam();

dSpacing=dSpacing+dTolerance;

Point3d ptToCreate[0];

Beam bmForInfo;

for (int i=0; i<bmToCheck.length()-1; i++)
{
	Beam bm=bmToCheck[i];
	Beam bmNext=bmToCheck[i+1];
	bm.realBody().vis();
	if (abs(vx.dotProduct(bmNext.ptCen()-bm.ptCen()))>dSpacing)
	{
		LineSeg ls(bmNext.ptCen(), bm.ptCen());
		Point3d ptAux=ls.ptMid();
		ptAux.vis();
		if (ppOp.pointInProfile(ptAux)==_kPointInProfile)
		{
			continue;
		}
		else
		{	
			ptToCreate.append(ls.ptMid());
			bmForInfo=bm;
		}
	}
}



int nErase=false;
Beam bmCreated[0];
if(nOption==0)
{
	for (int i=0; i<ptToCreate.length(); i++)
	{
		Beam bmNew;
		bmNew.dbCreate(ptToCreate[i], vy, vx, -vz, U(50), dBmWidth, dBmHeight, 0, 0, 0);
		bmNew.setName(bmForInfo.name());
		bmNew.setMaterial(bmForInfo.material());
		bmNew.setGrade(bmForInfo.grade());
		bmNew.setType(_kStud);
		bmNew.setExtrProfile(bmForInfo.extrProfile());
	
		bmNew.setColor(bmForInfo.color());
		bmNew.assignToElementGroup(el, true, 0, 'Z');
		
		Beam bmAux1[0];
		bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmTop, bmNew.ptCen(), vy);
		if (bmAux1.length()>0)
			bmNew.stretchStaticTo(bmAux1[0], true);
		
		Beam bmAux2[0];
		bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottom, bmNew.ptCen(), -vy);
		if (bmAux2.length()>0)
			bmNew.stretchStaticTo(bmAux2[0], true);
		
		bmCreated.append(bmNew);
		
		
	}
	
	for (int i=0; i<bmCreated.length(); i++)
	{
		Beam bm=bmCreated[i];
		Point3d ptL=bm.ptCen()-vx*(dBmWidth*0.5);
		Point3d ptR=bm.ptCen()+vx*(dBmWidth*0.5);
		Beam bmResult[]=bm.filterBeamsCapsuleIntersect(bmBlocking);
		if (bmResult.length()>0)
		{
			for (int j=0; j<bmResult.length(); j++)
			{
				if (bmResult[j].vecX().dotProduct(vx)>0)
					bmResult[j].dbSplit(ptR, ptL);
				else
					bmResult[j].dbSplit(ptL, ptR);
			}
		}
		
	}
	nErase=true;
}

Display dp(nColor);

if(nOption==1)
{
	nErase=false;
	if(ptToCreate.length()==0)
	{
		eraseInstance();
		return;
	}

	
	for (int i=0; i<ptToCreate.length(); i++)
	{
	
		Point3d ptErrCen=ptToCreate[i];
		PLine pLine(vy);
		pLine.createCircle(ptErrCen, vy, U(100,10));
		dp.draw(pLine);
		
		
		
	}
	reportNotice("\n" + T("Maximum spacing exceeded in wall: ") +el.code()+el.number());
}

assignToElementGroup(el, true);

if (nErase)
{
	eraseInstance();
	return;
}





#End
#BeginThumbnail






#End