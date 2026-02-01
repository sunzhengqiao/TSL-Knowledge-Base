#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
18.08.2010  -  version 1.0




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
* date: 18.08.2010
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropDouble dDrillDiameter (0, U(25), T("Drill Diameter"));
PropDouble dOffsetTop (1, U(276), T("Offset from Top of the panel"));
PropDouble dSpacing (2, U(74), T("Distance between Drills on Top"));

int nBmType[0];

nBmType.append(_kSFAngledTPLeft);				//sBmName.append("TOPPLATE");				nColor.append(32);
nBmType.append(_kSFAngledTPRight);				//sBmName.append("TOPPLATE");				nColor.append(32);
nBmType.append(_kSFTopPlate);						//sBmName.append("TOP PLATE");			nColor.append(32);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select Elements"),Element());
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
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	CoordSys csEl=el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();
	
	Beam bmAll[]=el.beam();
	if (bmAll.length()<1)	
	{
		return;
	}
	_Pt0=el.ptOrg();
	
	Beam bmFemale[0];
	Beam bmMale[0];	
	
	Point3d ptLeft;
	Point3d ptRight;
	
	for (int i=0; i<bmAll.length(); i++)
	{
		int nBeamType=bmAll[i].type();
		if (nBmType.find(nBeamType,-1) != -1)//|| bmAll[i].type()==_kSFStudLeft || bmAll[i].type()==_kSFStudRight
		{
			bmFemale.append(bmAll[i]);
		}
		else if (nBeamType == _kStud)
		{
			if (bmAll[i].dD(vx)<bmAll[i].dD(vz))
				bmMale.append(bmAll[i]);
		}
		else if (nBeamType == _kSFStudLeft)
		{
			ptLeft=bmAll[i].ptCen();
		}
		else if (nBeamType == _kSFStudRight)
		{
			ptRight=bmAll[i].ptCen();
		}
	}
	
	Beam bmVer[0];
	bmVer=vx.filterBeamsPerpendicularSort(bmMale);
	
	Beam bmValid[0];
	
	if (bmVer.length()>0)
	{
		if (abs(vx.dotProduct(bmVer[0].ptCen() - bmVer[bmVer.length()-1].ptCen()))>U(1000))
		{
			if ((ptLeft-bmVer[0].ptCen()).length()<U(700))
				bmValid.append(bmVer[0]);
	
			if ((ptRight-bmVer[bmVer.length()-1].ptCen()).length()<U(700))
				bmValid.append(bmVer[bmVer.length()-1]);
		}
		else
		{
			bmValid.append(bmVer[0]);
		}
	}
	
	for (int i=0; i<bmFemale.length(); i++)
	{
		Beam bmToDrill[0];
		bmToDrill=bmFemale[i].filterBeamsCapsuleIntersect(bmValid);//, U(10), false
		int nBirdsmouth=FALSE;
		
		for (int j=0; j<bmToDrill.length(); j++)
		{
			if (bmToDrill[j].hasTConnection(bmFemale[i], U(10), TRUE))
			{
				Line lnBm(bmToDrill[j].ptCen(), bmToDrill[j].vecX());
				Line lnTop(bmFemale[i].ptCen(), bmFemale[i].vecX());
				
				Point3d ptIntersection = lnBm.closestPointTo(lnTop);
				ptIntersection.transformBy(vy*(bmFemale[i].dD(vy)*0.5));
				
				Drill drlStud (ptIntersection-vy*dOffsetTop-vx*(U(45)), vx, U(100), dDrillDiameter*0.5);
				
				Drill drlTopLeft (ptIntersection-vx*(dSpacing*0.5), -vy, U(70), dDrillDiameter*0.5);
				Drill drlTopRight (ptIntersection+vx*(dSpacing*0.5), -vy, U(70), dDrillDiameter*0.5);
				
				bmFemale[i].addToolStatic(drlTopLeft);
				bmFemale[i].addToolStatic(drlTopRight);
				
				bmToDrill[j].addToolStatic(drlStud);
				
			}
		}
	}
}

eraseInstance();
return;






#End
#BeginThumbnail








#End
