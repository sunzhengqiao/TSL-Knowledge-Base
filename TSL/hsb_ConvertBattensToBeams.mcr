#Version 8
#BeginDescription
Convert the sheeting of a specific zone to beams and assign name, material, grade.

Created by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 03.02.2022 - version 1.14

#Versions:
Version 1.15 09/05/2025 HSB-22932: Fix when getting top plates for cut , Author Marsel Nakuci
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 15
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
* date: 12.06.2009
* version 1.0: Release Version
*
* #Versions:
* date: 12.08.2009
* version 1.1: 	Offset the horizontal battens 5mm on openings
*				Fix the interference of vertical batens above and bellow the openings with the horizontal ones.
*
* date: 12.01.2011
* version 1.1: 	Offset the horizontal battens 5mm on openings
*
* date: 22.03.2011
* version 1.3: 	Bugfix
*
* date: 23.03.2011
* version 1.5: 	Change beam type to _kLath
*
* date: 24.07.2012
* version 1.6: 	Analize beam orientation and set the width to be the smallest one.
*
* date: 21.11.2012
* version 1.7: 	Allways set the cs of the battens to have the z vector of the batten align to vz of the element
*
* date: 23.01.2013
* version 1.8: 	Allow it to run in any type of element
*
* date: 09.04.2013
* version 1.9: 	Allow to keep the color of the battens when they are converted.
*
* date: 22.07.2016
* version 1.10: 	Added Beam Code Property.
*
* date: 08.10.2011
* version 1.11: 	Add Align height to Z of the element
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to Convert the Battens"));

PropDouble dDist (0, 0, T("Size to cut the Top of the Battens"));

PropString sAlignHeightToZ (4, sArNY, T("Align height to Z of the element"));
int nAlignHeightToZ = sArNY.find(sAlignHeightToZ, 0);

PropString sOverwrite(5, sArNY, T("Overwrite zone material"), 1);
int nOverwriteMaterial = sArNY.find(sOverwrite, 1);
sOverwrite.setCategory(T("Beam Properties"));

PropString sName(0, "", T("Beam Name"));
sName.setDescription(T("Set the name of the battens"));
sName.setCategory(T("Beam Properties"));

PropString sMaterial(1, "", T("Beam Material"));
sMaterial.setDescription(T("Set the material of the battens"));
sMaterial.setCategory(T("Beam Properties"));

PropString sGrade(2, "", T("Beam Grade"));
sGrade.setDescription(T("Set the grade of the battens"));
sGrade.setCategory(T("Beam Properties"));

PropString sBeamCode(3, "", T("Beam Code"));
sBeamCode.setDescription(T("Set the Beam Code"));
sBeamCode.setCategory(T("Beam Properties"));

PropInt nColor (1, -1, T("Beam Color"));
nColor.setDescription("Set the color of the battens, (-1) will keep the existing color");
nColor.setCategory(T("Beam Properties"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

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
	
	return;
}

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

int nErase=FALSE;

for( int e=0; e<_Element.length(); e++ )
{
	Element el = _Element[e];
	if (!el.bIsValid()) continue;

	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	_Pt0=ptOrgEl;

	//Some values and point needed after
	Point3d ptFront=el.zone(nZone).coordSys().ptOrg(); ptFront.vis(1);
	
	Plane plnFront (ptFront, vz);
	
	PlaneProfile ppAllOpenings[0];
	Point3d ptCentArr[0];
	
	Sheet shAll[]=el.sheet(nZone);
	ElemZone ez=el.zone(nZone);
	
	Beam bmAll[0];	
	Beam bmToCheck[0];
	
	double dBattenWidth=ez.dVar("width");
	double dBattenHeight=ez.dH();

	//reportNotice ("\n"+ bmToCheck.length());
	int nCurrentColor=-1;
	for (int n=0; n<shAll.length(); n++)
	{
		//shAll[n].setDH(ez.dH());
		nCurrentColor=shAll[n].color();
		Body bdSheet=shAll[n].realBody();
		Beam bm;
		bm.dbCreate(bdSheet);
		bm.setName(sName);
		if (nOverwriteMaterial)
		{ 
			bm.setMaterial(sMaterial);
		}
		
		bm.setGrade(sGrade);
		bm.setType(_kBatten);
		String sCompleteBeamCodeSheet = shAll[n].beamCode();
		String sNewCode = sBeamCode;
		sNewCode.trimLeft();
		sNewCode.trimRight();
		if (sNewCode.find(";", 0) != -1)
		{
			reportMessage(T("Beam Code set by Convert Battens to beam TSL is not valid"));
			bm.setBeamCode(sCompleteBeamCodeSheet);
		}
		else
		{
			//Remove the beam code of the sheet
			String sThisCode = sCompleteBeamCodeSheet.token(0);
			sCompleteBeamCodeSheet.delete(0, sThisCode.length());
			String sCompleteNewCode = sNewCode + sCompleteBeamCodeSheet;
			bm.setBeamCode(sCompleteNewCode);
		}
		
		if (nColor>-1)
		{
			bm.setColor(nColor);
		}
		else
		{
			if (nCurrentColor>-1)
				bm.setColor(nCurrentColor);
		}
		bm.assignToElementGroup(el, TRUE, nZone, 'Z');
		bmAll.append(bm);
		
		if (bm.solidLength()<=dDist)
			bm.dbErase();
		else
			bmToCheck.append(bm);
	}
	
	for (int n=0; n<shAll.length(); n++)
	{
		shAll[n].dbErase();
	}
	
	
	//Collect all beams which are bottom plates
	//Beam bmBottomPlate[0];
	for(int i=0;i<bmAll.length();i++)
	{
		Beam bm=bmAll[i];
	
		bm.realBody().vis();
		double dWidth=bm.dW();
		double dHeight=bm.dH();
		
		/*
		Vector3d vxNew=bm.vecX();
		Vector3d vzNew=bm.vecD(vz);
		if (nZone<0)
			vzNew=bm.vecD(-vz);
		Vector3d vyNew=vzNew.crossProduct(vxNew);
		vyNew.normalize();
		CoordSys csNew(bm.ptCen(), vxNew, vyNew, vzNew);
		bm.setCoordSys(csNew);
		*/
		
		//if the width greater than the height, the convetion is wrong and needs to be fixed
		if(dWidth>dHeight)
		{
			CoordSys cs=bm.coordSys();
			CoordSys csRotate=bm.coordSys();
			csRotate.vis(1);
			csRotate.setToRotation(90, bm.vecX(), bm.ptCen());
			
			cs.transformBy(csRotate);
			cs.vis(2);
			
			//apply rotated coordinate system to beam
			bm.setCoordSys(cs);
			
			//Swap the height and width
			bm.setD(cs.vecY(), dHeight);
			bm.setD(cs.vecZ(), dWidth);
		}
		
		if (nAlignHeightToZ)
		{
			if (abs(dHeight-bm.dD(el.vecZ()))<U(0.1))
			{
				CoordSys cs=bm.coordSys();
				CoordSys csRotate=bm.coordSys();
				csRotate.vis(1);
				csRotate.setToRotation(90, bm.vecX(), bm.ptCen());
				
				cs.transformBy(csRotate);
				cs.vis(2);
				
				//apply rotated coordinate system to beam
				bm.setCoordSys(cs);
				
				//Swap the height and width
				bm.setD(cs.vecY(), dWidth);
				bm.setD(cs.vecZ(), dHeight);
			}
		}
	}
	
	if (bmToCheck.length()>0)
		nErase=TRUE;
	
	//if (shAll.length()<=0)
	//	nErase=TRUE;
	Point3d ptTopBattens=el.ptOrg();
	
	for (int n=0; n<bmToCheck.length(); n++)
	{
		Beam bm=bmToCheck[n];
		PlaneProfile ppBm=bm.realBody().shadowProfile(plnFront);
		LineSeg ls=ppBm.extentInDir(vy);
		Point3d ptTop=ls.ptEnd();
		if (ptTop.Z()>ptTopBattens.Z())
			ptTopBattens=ptTop;
	}
	
	ptTopBattens=ptTopBattens-vy*dDist;
	// HSB-22932: don't apply unnecessary cuts at top plates
//	Body bdCut (ptTopBattens, vx, vy, vz, U(10000), U(10), U(200));
	Body bdCut (ptTopBattens+vy*U(0.1),vx,vy,vz,U(10000),U(10),U(200),0,1,0);
	Beam bmToCut[0];
	bmToCut=bdCut.filterGenBeamsIntersect(bmToCheck);
	
	Cut ct(ptTopBattens, vy);
	
	for (int n=0; n<bmToCut.length(); n++)
	{
		bmToCut[n].addToolStatic(ct, _kStretchOnToolChange);
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
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="296" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22932: Fix when getting top plates for cut" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="5/9/2025 3:24:20 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End