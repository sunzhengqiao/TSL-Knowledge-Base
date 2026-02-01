#Version 8
#BeginDescription
Sets the edge detail overide for walls which have predefined overides in the 'O' column depending on the sheet thickness of the connecting wall

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 15.09.2010  -  version 1.1






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* date: 30.08.2010
* version 1.0: Release Version
*
* date: 15.09.2010
* version 1.1: BugFix with wrong setting on the right custom detail
*/

U(1,"mm");	

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

int nSize[]={9, 12, 15, 18, 19, 22, 28, 30, 35, 60, 92};
String sDetail[]={"6","7","8","9","10","11","12","13","14","15","16"};


if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	//if (_kExecuteKey=="")
		//showDialogOnce();
	
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

Wall wl=(Wall) el;

double dLen=abs(el.vecX().dotProduct(wl.ptStart()-wl.ptEnd()));

Point3d ptLeft=ptOrgEl;
Point3d ptRight=ptOrgEl+vx*dLen;ptRight.vis(3);

Element elAllCon[]=el.getConnectedElements();

String sCorner;
String sJunction[0];
int nCon=0;

for (int e=0; e<elAllCon.length(); e++)
{
	ElementWallSF elC=(ElementWallSF) elAllCon[e];
	if (!elC.bIsValid()) continue;
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
	if (abs(vx.dotProduct(ptOrgEl-ptF))>dLen+U(5) || abs(vx.dotProduct(ptOrgEl-ptB))>dLen+U(5))
		continue;
	
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
				dSheetThickness+=ez.dH();
			}
		}
		else//Front
		{
			for (int i=1; i<6; i++)
			{
				ElemZone ez=elC.zone(i);
				dSheetThickness+=ez.dH();
			}
		}
	
		int nTh=(int)dSheetThickness;
		int nLoc=-1;
		for (int i=0; i<nSize.length();i++)
		{
			if (nSize[i]==nTh)
			{
				nLoc=i;
				break;
			}
		}
		if (nLoc!=-1)
		{
			String sCode=el.code();
			sCode+="O";
			sCode+=sDetail[nLoc];
			el.setConstrDetailLeft(sCode);
		}
	}
	else if (abs(vx.dotProduct(ptJunction-ptRight))<U(5))
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
				dSheetThickness+=ez.dH();
			}
		}
		else//Front
		{
			for (int i=1; i<6; i++)
			{
				ElemZone ez=elC.zone(i);
				dSheetThickness+=ez.dH();
			}
		}
		
		int nTh=(int)dSheetThickness;
		int nLoc=-1;
		for (int i=0; i<nSize.length();i++)
		{
			if (nSize[i]==nTh)
			{
				nLoc=i;
				break;
			}
		}

		if (nLoc!=-1)
		{
			String sCode=el.code();
			sCode+="O";
			sCode+=sDetail[nLoc];
			el.setConstrDetailRight(sCode);
		}
	}
}


//eraseInstance();
//return;







#End
#BeginThumbnail


#End
