#Version 8
#BeginDescription
Distributes the sheet above and below openings depending on width and height of available sheets.

Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 17.11.2015 version 1.0



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
*  Copyright (C) 2015 by
*  hsbcad 
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
* Create by: Alberto Jena (aj@hsb-cad.com)
* date: 17-11-2015
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

PropString sFilterBeams(0, "", T("|Convert Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	if (_kExecuteKey=="")
		showDialogOnce();
	
	//Select a set of walls
	PrEntity ssE(T("Select one, or more elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}


// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";
}

int nErase=false;

for( int e=0; e<_Element.length(); e++ )
{
	if (_Element.length()==0)
	{
		eraseInstance();
		return;
	}
	
	Element el=_Element[e];

	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	Point3d ptElOrg=csEl.ptOrg();
	_Pt0=ptElOrg;
	
	ElementRoof elR=(ElementRoof) el;
	if (!elR.bIsValid())
	{
		continue;
	}

	Plane plnZ (ptElOrg, vz);

	Beam bmAll[]=el.beam();
	Beam bmToRemove[0];
	Beam bmToConvert[0];
	
	if (bmAll.length()==0) continue;
	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if (sBeamFilter.find(bm.beamCode().token(0), -1) != -1 )
		{
			bmToConvert.append(bm);
		}
	}
	
	ElemRoofEdge allEdges[]=elR.elemRoofEdges();
	

	for (int d=0; d<allEdges.length(); d++)
	{
		ElemRoofEdge ere=allEdges[d];
		String sThisEdge=ere.constrDetail();
		
		String sValiableItems[0];
		int nFlip=false;
		while (sThisEdge.length()>0 || sThisEdge.find(";",0)>-1)
		{
			String sToken = sThisEdge.token(0);	
			sToken.trimLeft();
			sToken.trimRight();		
			sToken.makeUpper();
			sValiableItems.append(sToken);
			//double dToken = sToken.atof();
			//int nToken = sToken.atoi();
			int x = sThisEdge.find(";",0);
			sThisEdge.delete(0,x+1);
			sThisEdge.trimLeft();	
			if (x==-1)
				sThisEdge= "";
		}
		
		int nLocationFlip=-1;
		for (int i=0; i<sValiableItems.length(); i++)
		{
			String sAux=sValiableItems[i];
			if (sAux.find("FLIP", -1) != -1)
			{
				nLocationFlip=i;
				break;
			}
		}

		if (nLocationFlip != -1)
		{
			String sVariable=sValiableItems[nLocationFlip-1].mid(7,sValiableItems[nLocationFlip-1].length());
			
			String sValueCode="40DVAR"+sVariable;
			
			int nVarLocation=sValiableItems.find(sValueCode, -1);
			if (nVarLocation != -1)
			{
				String sVarValue=sValiableItems[nVarLocation+1];
				nFlip=sVarValue.atoi();
			}
		}
		
		//Find the closest beam to the edge
		if (nFlip)
		{
			Point3d ptEdge=ere.ptNode();
			Point3d ptEdgeOther=ere.ptNodeOther();

			LineSeg ls(ptEdge, ptEdgeOther);

			Point3d ptMidSeg=ls.ptMid();

			Vector3d vDir=ere.vecDir();
			
			Beam bmPossibleFlip[]=vDir.filterBeamsParallel(bmToConvert);
			Beam bmToFlip;
			double dDistance=99999;
			for (int b=0; b<bmPossibleFlip.length(); b++)
			{
				if ((bmPossibleFlip[b].ptCen()-ptMidSeg).length()<dDistance)
				{
					dDistance=(bmPossibleFlip[b].ptCen()-ptMidSeg).length();
					bmToFlip=bmPossibleFlip[b];
				}
			}
			
			if (bmToFlip.bIsValid())
			{
				CoordSys csNew;
				csNew.setToRotation(180, vz, bmToFlip.ptCen());
				bmToFlip.transformBy(csNew);
				nErase=true;
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