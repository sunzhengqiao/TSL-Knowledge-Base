#Version 8
#BeginDescription
Convert a stud with code “BOXBLOCK” into 2 pieces of 200mm length on top and bottom of the panel.

Modified by: Mick Kelly (mkelly@itw-industry.com)
Date: 01.09.2010 - version 1.4

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
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
* date: 21.07.2009
* version 1.01: Release Version
*
* date: 30.06.2010
* version 1.2: Allow it to run from the wall details on generation
*
* date: 01.07.2010
* version 1.3: Assign _KLog to set BeamType Name
*
* date: 01.09.2010
* version 1.4: Set the beams as modules
*/

Unit(1,"mm"); // script uses mm
/*
String sArNY[] = {T("No"), T("Yes")};

PropString sColor(0, sArNY, T("Set Default Color"),0);
sColor.setDescription(T("Set All the beam with Default Color"));
int bColor = sArNY.find(sColor,0);

PropString sModule(1, sArNY, T("Set Module Beam with Default Color"),0);
sModule.setDescription(T("Overwrite the Module Beam Color"));
int bModule = sArNY.find(sModule,0);


PropInt nColorDef (0, 7, T("Default Color"));
nColorDef.setDescription("");
*/

double dLen=U(200);

String sName="Box Block";
String sMaterial="CLS";
String sGrade="C16";

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	//if (_kExecuteKey=="")
	//	showDialogOnce();

	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	//if (insertCycleCount()>1) { eraseInstance(); return; }
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
	
	Plane plnZ (csEl.ptOrg(), vz);
	
	Beam bmAll[]=el.beam();
	if (bmAll.length()<1)	
	{
		continue;
	}
	
	_Pt0=el.ptOrg();

	Beam bmToSplit[0];
		
	for (int i=0; i<bmAll.length(); i++)
	{
		String sCode=bmAll[i].beamCode().token(0);
		sCode.makeUpper();
		
		if (sCode=="BOXBLOCK")//|| bmAll[i].type()==_kSFStudLeft || bmAll[i].type()==_kSFStudRight
		{
			bmToSplit.append(bmAll[i]);
		}
	}
	
	for (int i=0; i<bmToSplit.length(); i++)
	{
		Beam bm=bmToSplit[i];
		bm.setName(sName);
		bm.setMaterial(sMaterial);
		bm.setGrade(sGrade);
		bm.setType(_kLog);
		String sModule=bm.module();
		
		if (abs(bm.vecX().dotProduct(vy))<0.99)
			continue;
		
		Body bdBeam=bm.realBody();
		PlaneProfile ppBm(csEl);
		ppBm=bdBeam.shadowProfile(plnZ);
		LineSeg ls=ppBm.extentInDir(vy);
		Point3d ptSplitTop=ls.ptEnd();
		ptSplitTop=ptSplitTop-vy*dLen;			
		Point3d ptSplitBottom=ls.ptStart();
		ptSplitBottom=ptSplitBottom+vy*dLen;	
		
		if (bm.vecX().dotProduct(vy)>0)
			bm.dbSplit(ptSplitTop, ptSplitBottom);
		else
			bm.dbSplit(ptSplitBottom, ptSplitTop);
			
		Line ln (bm.ptCen(), vy);
		
		ptSplitTop=ln.closestPointTo(ptSplitTop);
		ptSplitBottom=ln.closestPointTo(ptSplitBottom);
		double dDist=(ptSplitTop-ptSplitBottom).length();
		dDist=(dDist-(dLen*0.5))/3;
		
		Beam bmTop;
		bmTop.dbCreate(ptSplitTop-vy*(dDist), vy, vz, vx, dLen, bm.dD(vz), bm.dD(vx));
		bmTop.setName(sName);
		bmTop.setMaterial(sMaterial);
		bmTop.setGrade(sGrade);
		bmTop.setColor(bm.color());
		bmTop.setModule(sModule);
		bmTop.assignToElementGroup(el, TRUE, 0, 'Z');
		bmTop.setType(_kLog);


		Beam bmBottom;
		bmBottom.dbCreate(ptSplitBottom+vy*(dDist), vy, vz, vx, dLen, bm.dD(vz), bm.dD(vx));
		bmBottom.setName(sName);
		bmBottom.setMaterial(sMaterial);
		bmBottom.setGrade(sGrade);
		bmBottom.setColor(bm.color());
		bmTop.setModule(sModule);
		bmBottom.assignToElementGroup(el, TRUE, 0, 'Z');
		bmBottom.setType(_kLog);
	}
}


if (_bOnElementConstructed)
{
	eraseInstance();
	return;
}


#End
#BeginThumbnail






#End
