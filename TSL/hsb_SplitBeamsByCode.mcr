#Version 8
#BeginDescription
Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 04.09.2017 - version 1.1

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
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
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 01.08.2014
* version 1.0: Release Version
*


*/

Unit(1,"mm"); // script uses mm

double dMinLength=U(20);

PropString sFilterBlocking(0, "", T("|Code beams to split|"));
sFilterBlocking.setDescription(T("|If this is empty it will use all the beams. Separate multiple entries by semicolon| ';'"));

PropString sFilterIntersection(1, "", T("|Code beams that intersect|"));
sFilterIntersection.setDescription(T("|Separate multiple entries by|") +" ';'");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	PrEntity ssE(T("Please select elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
 			_Element.append(el);
 		 }
 	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=false;


// transform filter tsl property into array
String sBlockingCodes[0];
String sList = sFilterBlocking;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBlockingCodes.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";
}


// transform filter tsl property into array
String sIntersectingCodes[0];
sList = sFilterIntersection;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sIntersectingCodes.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";
}



for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();

	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	if (bmAll.length()<1)	
	{
		return;
	}
	
	double dGR=0;
	
	String sExProfile="";
	for (int i=0; i< bmVer.length(); i++)
	{
		Beam bm=bmVer[i];
		if (bm.extrProfile()!= _kExtrProfRectangular)
		{
			sExProfile=bm.extrProfile();
			break;
		}
	}
	
	Beam bmToSplit[0];
	Beam bmBlocking[0];
	
	double dBeamWidth=bmVer[0].dD(vx);
	double dBeamHeight=bmVer[0].dD(vz);
	
	Plane plnZ (csEl.ptOrg(), vz);
	PlaneProfile ppBeamsToSplit(csEl);
	
	for (int i=0; i<bmAll.length(); i++)
	{
		String sCode=bmAll[i].beamCode().token(0);
		sCode.makeUpper();
		if (sBlockingCodes.find(sCode, -1) != -1)
		{
			bmToSplit.append(bmAll[i]);
		}
		else if(sBlockingCodes.length()==0 && sIntersectingCodes.find(sCode, -1) == -1)
		{ 
			bmToSplit.append(bmAll[i]);
		}

		if (sIntersectingCodes.find(sCode, -1) != -1)
		{
			bmBlocking.append(bmAll[i]);
			dGR=bmAll[i].dW();
		}
	}
	
	
	for (int i=0; i<bmToSplit.length(); i++)
	{
		
		Point3d ptSplit[0];
		Beam bmS=bmToSplit[i];
		Vector3d vxSplit=bmS.vecX();
		PlaneProfile pptS(plnZ);
		pptS=bmS.envelopeBody(false, true).shadowProfile(plnZ);
		pptS.vis(i);
		
		Line lnS(bmS.ptCen(), bmS.vecX());
		for (int j=0; j<bmBlocking.length(); j++)
		{
			Beam bmB=bmBlocking[j];
			Line lnB(bmB.ptCen(), bmB.vecX());
			PlaneProfile ppBlockingBeam(plnZ);
			ppBlockingBeam=bmB.realBody().shadowProfile(plnZ);
			ppBlockingBeam.vis();
			
			Point3d ptIntersection=lnB.closestPointTo(lnS);
			if (ppBlockingBeam.pointInProfile(ptIntersection)== _kPointInProfile)
			{ 
				ptIntersection.vis(j);
				ptSplit.append(ptIntersection);
			}
		}
		
		ptSplit=lnS.orderPoints(ptSplit, U(2));
		ptSplit=plnZ.projectPoints(ptSplit);
		for (int p=0; p<ptSplit.length(); p++)
		{
			Point3d pt=ptSplit[p];
			pt.vis(p);
			
			if (pptS.pointInProfile(pt)== _kPointInProfile)
			{
				Beam bmRes=bmS.dbSplit(pt+vxSplit*dGR*0.5, pt-vxSplit*dGR*0.5);
				if (bmRes.solidLength()>bmS.solidLength())
				{
					bmS=bmRes;
					vxSplit=bmRes.vecX();
					pptS=bmRes.envelopeBody(false, true).shadowProfile(plnZ);
//					reportNotice("\nbmResLength "+bmRes.solidLength());
					if (bmRes.solidLength()>U(25000))
					{ 
						bmRes.dbErase();
					}

				}
				else
				{
					vxSplit=bmS.vecX();
					pptS=bmS.envelopeBody(false, true).shadowProfile(plnZ);
//					reportNotice("\nbmResLength "+bmS.solidLength());
					if (bmS.solidLength()>U(25000))
					{ 
						bmS.dbErase();
					}
				}
				
			}
		}
	}
	nErase=true;
}


if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}
















#End
#BeginThumbnail



#End