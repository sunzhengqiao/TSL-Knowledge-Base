#Version 8
#BeginDescription
Last modified by: David De Lombaerde (david.delombaerde@hsbcad.com)
21.04.2020  -  version 1.9 : Backer blocks are automatically integrated tools in beam.








#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
//region History
	
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
* date: 06.08.2008
* version 1.1: Release Version
*
* date: 11.08.2010
* version 1.2: Add plate Height as a property
*
* date: 19.11.2010
* version 1.3: Add the beams to the group of the main beam and also add the option to select ultiple beams in one go
*
* date: 04.04.2011
* version 1.4: Add the option to have a center orientation when the packs are not in the extreme of the joist
*
* date: 21.04.2011
* version 1.5: Changed multiple insert instances to single instances for flexibility of grip points.  Changed edge and mid insert for multiple instances
*
* date: 21.07.2011
* version 1.6: Add beam Code P to the new beams
*
* date: 21.04.2020
* version 1.9: Backer blocs are automatically integrated tools
*/	

//End History//endregion 

//region Constants
	
Unit (1, "mm");
int nValidZones[]={1,2,3,4,5,0,-1,-2,-3,-4,-5};
String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";
String sFind=findFile(sPath);

//End Constants//endregion 

// Validate
if (sFind=="")
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterial[0];

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterial.append(mpMaterial.getString("MATERIAL"));
	}
}

if (sMaterial.length()==0)
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

//region Properties
		
	String sInsertionMode[] = {T("Single Instance"), T("Multiple Instance")};
	PropString sMode(4, sInsertionMode, T("Insertion Mode"), 0);
	
	PropDouble dPlateWidth (0, U(80), T("Backer Block Width"));
	PropDouble dPlateHeight (1, U(150), T("Backer Block Height"));
	PropDouble dBackerThickness (2, U(15), T("Backer Block Thickness"));
	PropDouble dPlateThickness (3, U(15), T("Squeeze Block Thickness"));
	
	String sAllShape[] = {T("Left"), T("Right"), T("Both")};
	PropString sShape(0, sAllShape, T("Location"), 1);
	
	String sAllBeams[] = {T("Backer Block"), T("Squash Block"), T("Both")};
	PropString sBeams(1, sAllBeams, T("Type"), 1);
	
	PropString sNameBacker (2, "Backer Block", T("Beam Name Backer Block"));
	PropString sNameSqueeze (3, "Squash Block", T("Beam Name Squash Block"));
	PropString sBeamMaterial(5, sMaterial, T("Material"));
	PropString sBeamLabel(6, "", T("Label"));
	PropString sBeamInformation(7, "", T("Information"));
	PropString sBackerCode(8, "", T("Backer Block Code"));
	PropString sSquashCode(9, "", T("Squash Block Code"));
	
	PropInt nColor (0, -1, T("Color"));
	PropInt nZones (1, nValidZones, T("Zone"),5);

//End Properties//endregion 

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert)
{
	if (_kExecuteKey=="")
		showDialogOnce();
}

int bShape= sAllShape.find(sShape,0);
int bType= sAllBeams.find(sBeams,0);
int nMode= sInsertionMode.find(sMode,0);
sMode.setReadOnly(TRUE);

if (_bOnInsert)
{
	if (nMode==0)//Single Instance
	{
		_Beam.append(getBeam(T("Select Male Beam")));
		_Pt0=getPoint(T("Please select a point where you need the Packers"));
	}
	else if(nMode==1)//Multiple Instance
	{
		PrEntity ssE("\nSelect a set of beams", Beam());
		if(ssE.go()){
			_Beam.append(ssE.beamSet());
		}
		_Pt0=getPoint(T("Please select a point that define the side of the beam to inser the packs"));
		
		// declare tsl props
		TslInst tsl;
		String strScriptName=scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Element lstElements[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstPropString.append(sShape);
		lstPropString.append(sBeams);
		lstPropString.append(sNameBacker);
		lstPropString.append(sNameSqueeze);
		lstPropString.append("Single Instance");
		lstPropString.append(sBeamLabel);
		lstPropString.append(sBeamMaterial);
		lstPropString.append(sBeamInformation);
		lstPropString.append(sBackerCode);
		lstPropString.append(sSquashCode);
		lstPropString.append(sBeamMaterial);
		
		lstPropInt.append(nColor);
		lstPropInt.append(nZones);
		lstPropDouble.append(dPlateWidth);
		lstPropDouble.append(dPlateHeight);
		lstPropDouble.append(dBackerThickness);
		lstPropDouble.append(dPlateThickness);
		lstPoints.append(_Pt0);
		for( int b=0; b<_Beam.length(); b++ )
		{
			lstBeams.setLength(0);
			lstBeams.append(_Beam[b]);
	
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);

		}
		eraseInstance();
		return;
	}
	
	return;
}

// Validate
if (_Beam.length()<1)
{
	eraseInstance();
	return;
}

Beam bm=_Beam0;

if (_Map.hasEntity("bm"))
{
	Entity ent=_Map.getEntity("bm");
	ent.dbErase();
}
if (_Map.hasEntity("bm2"))
{
	Entity ent=_Map.getEntity("bm2");
	ent.dbErase();
}
if (_Map.hasEntity("bm3"))
{
	Entity ent=_Map.getEntity("bm3");
	ent.dbErase();
}
if (_Map.hasEntity("bm4"))
{
	Entity ent=_Map.getEntity("bm4");
	ent.dbErase();
}

Display dp(nColor);

_Z1.vis(_Pt0, 1);

Line lnBm0 (bm.ptCen(), _X0);
_Pt0=lnBm0.closestPointTo(_Pt0);
	
Point3d ptCenBm=bm.ptCenSolid();
double dAux=bm.solidLength();
Point3d ptLeft=ptCenBm+bm.vecX()*(dAux*0.5);
Point3d ptRight=ptCenBm-bm.vecX()*(dAux*0.5);
/*
if(nMode==1)//Multiple Instance
{

	if ((ptLeft-_Pt0).length() < (ptRight-_Pt0).length())
		_Pt0=ptLeft;
	else
		_Pt0=ptRight;
}
*/

//ptInteriorProfile.vis(2);
Vector3d vx=bm.vecX();
Vector3d vy=bm.vecY();;
Vector3d vz=bm.vecZ();;
if (vx.dotProduct(_X0)<1)
	vx=-vx;

if (vx.dotProduct(bm.ptCen()-_Pt0)>0)
	vx=-vx;

double dWidth=bm.dW();
double dHeight=bm.dH();

Point3d ptUp=_Pt0+vz*(dHeight*0.5);
Point3d ptDown=_Pt0-vz*(dHeight*0.5);

Point3d ptUpFemale=_Pt0+vz*(dHeight*0.5);
Point3d ptDownFemale=_Pt0-vz*(dHeight*0.5);
Point3d ptPlate;
Point3d ptPlate2;

Body bd;
Body bd2;
Body bd3;
Body bd4;

Vector3d vecXBd;
Vector3d vecYBd;
Vector3d vecZBd;

double dWBm=bm.dD(vy);
double dHBm=bm.dD(vz);

ptPlate=_Pt0;

//Project Point to centerline plane
Line lnCen(ptCenBm,vx);
Point3d ptPlateProject=lnCen.closestPointTo(ptPlate);

//Check if user selected point is within the beam span or outside
Vector3d vecPt0PtLeft=ptLeft-ptPlateProject;
Vector3d vecPt0PtRight=ptRight-ptPlateProject;
vecPt0PtLeft.normalize();
vecPt0PtRight.normalize();

if(abs(vecPt0PtLeft.dotProduct(vx)+vecPt0PtRight.dotProduct(-vx))>1.99)
{

	ptPlate=_Pt0+vy*(dWBm*0.5);
	ptPlate2=_Pt0-vy*(dWBm*0.5);
}
else
{
	if ((ptLeft-_Pt0).length() < (ptRight-_Pt0).length())
	{
		_Pt0=ptLeft;
		ptPlate=ptLeft+vy*(dWBm*0.5);
		ptPlate2=ptLeft-vy*(dWBm*0.5);
	}
	else
	{
		_Pt0=ptRight;
		ptPlate=ptRight+vy*(dWBm*0.5);
		ptPlate2=ptRight-vy*(dWBm*0.5);
	}
}

Point3d ptIntersect=_Pt0;
int nOffset=-1;

if ((ptIntersect-ptLeft).length()>U(5) && (ptIntersect-ptRight).length()>U(5))
	nOffset=0;
else
	nOffset=-1;

//ptPlate.vis();
//ptPlate2.vis();
if (bShape==0 || bShape==2)
{
	if (bType==0 || bType==2)
		bd = Body (ptPlate, vx, vz, vy, dPlateWidth, dPlateHeight, dBackerThickness, nOffset, 0, -1);
	if (bType==1 || bType==2)
		bd3 = Body (ptPlate, vx, vz, vy, dPlateWidth, dHBm, dPlateThickness, nOffset, 0, 1);
}

if (bShape==1 || bShape==2)
{
	if (bType==0 || bType==2)
		bd2 = Body  (ptPlate2, vx, vz, vy, dPlateWidth, dPlateHeight, dBackerThickness, nOffset, 0, 1);
	if (bType==1 || bType==2)
		bd4 =  Body (ptPlate2, vx, vz, vy, dPlateWidth, dHBm, dPlateThickness, nOffset, 0, -1);
}

vecXBd=vy;
vecYBd=vz;
vecZBd=_X0;

vecXBd.vis(_Pt0);
vecYBd.vis(_Pt0);
vecZBd.vis(_Pt0);

Element el=bm.element();
Group gr;
if (el.bIsValid())
{
	gr=el.elementGroup();
}

if (bShape==0 || bShape==2)
{
	if (bType==0 || bType==2)
	{
		Beam bmPlate;
		bmPlate.dbCreate(bd);
		bmPlate.setColor(nColor);
		bmPlate.setName(sNameBacker);
		bmPlate.setSubLabel2(bm.subLabel2());
		//bmPlate.setBeamCode("P");
		bmPlate.setType(_kEWPBacker_Block);		
		bmPlate.setMaterial(sBeamMaterial);
		bmPlate.setLabel(sBeamLabel);
		bmPlate.setInformation(sBeamInformation);
		bmPlate.setBeamCode(sBackerCode);		
		
		bd.ptCen().vis();
		
		// We have to bm as selected Beam, on this use BeamCut to integrate the backer block into the beam
		//Point3d ptBeamCut = ptPlate - vy * .5 * dBackerThickness;
		BeamCut bc(bd.ptCen(), vx, vz, vy, dPlateWidth, dPlateHeight, dBackerThickness);
		bm.addTool(bc);
		
		if (el.bIsValid())
		{
			bmPlate.assignToElementGroup(el, TRUE, nZones,'Z');
		}
		_Map.setEntity("bm", bmPlate);
	}	
	if (bType==1 || bType==2)
	{
		Beam bmPlate3;
		bmPlate3.dbCreate(bd3);
		bmPlate3.setColor(nColor);
		bmPlate3.setName(sNameSqueeze);
		bmPlate3.setSubLabel2(bm.subLabel2());
		//bmPlate3.setBeamCode("P");
		bmPlate3.setType(_kEWPSquash_Block);
		bmPlate3.setMaterial(sBeamMaterial);
		bmPlate3.setLabel(sBeamLabel);
		bmPlate3.setInformation(sBeamInformation);
		bmPlate3.setBeamCode(sSquashCode);
		if (el.bIsValid())
		{
			bmPlate3.assignToElementGroup(el, TRUE, nZones,'Z');
		}
		_Map.setEntity("bm3", bmPlate3);
		//if (gr.name()!="")
		//	gr.addEntity(bmPlate3, TRUE);
	}
}

if (bShape==1 || bShape==2)
{
	if (bType==0 || bType==2)
	{
		Beam bmPlate2;
		bmPlate2.dbCreate(bd2);
		bmPlate2.setColor(nColor);
		bmPlate2.setName(sNameBacker);
		bmPlate2.setSubLabel2(bm.subLabel2());
		//bmPlate2.setBeamCode("P");
		bmPlate2.setType(_kEWPBacker_Block);
		bmPlate2.setMaterial(sBeamMaterial);
		bmPlate2.setLabel(sBeamLabel);
		bmPlate2.setInformation(sBeamInformation);
		bmPlate2.setBeamCode(sBackerCode);
		
		vx.vis(ptPlate2, 1);
		vy.vis(ptPlate2, 3);
		vz.vis(ptPlate2, 130);
		
		// We have to bm as selected Beam, on this use BeamCut to integrate the backer block into the beam
		//Point3d ptBeamCut = ptPlate2 + vy * .5 * dBackerThickness;
		BeamCut bc(bd2.ptCen(), vx, vz, vy, dPlateWidth, dPlateHeight, dBackerThickness);
		bm.addTool(bc);
		
		if (el.bIsValid())
		{
			bmPlate2.assignToElementGroup(el, TRUE, nZones,'Z');	
		}
		_Map.setEntity("bm2", bmPlate2);
		//if (gr.name()!="")
		//	gr.addEntity(bmPlate2, TRUE);
	}

	if (bType==1 || bType==2)
	{
		Beam bmPlate4;
		bmPlate4.dbCreate(bd4);
		bmPlate4.setColor(nColor);
		bmPlate4.setName(sNameSqueeze);
		bmPlate4.setSubLabel2(bm.subLabel2());
		//bmPlate4.setBeamCode("P");
		bmPlate4.setType(_kEWPSquash_Block); 
		bmPlate4.setMaterial(sBeamMaterial);
		bmPlate4.setLabel(sBeamLabel);
		bmPlate4.setInformation(sBeamInformation);
		bmPlate4.setBeamCode(sSquashCode);
		if (el.bIsValid())
		{
			bmPlate4.assignToElementGroup(el, TRUE, nZones,'Z');
		}
		_Map.setEntity("bm4", bmPlate4);
		//if (gr.name()!="")
		//	gr.addEntity(bmPlate4, TRUE);
	}
}

dp.draw(bd);
dp.draw(bd2);
dp.draw(bd3);
dp.draw(bd4);

//Display dp(-1);
//Display something
double dSize = Unit(12, "mm");
//Display dspl (-1);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
Point3d ptDraw=_Pt0;
pl1.addVertex(ptDraw+vx*dSize);
pl1.addVertex(ptDraw-vx*dSize);
pl2.addVertex(ptDraw-vy*dSize);
pl2.addVertex(ptDraw+vy*dSize);
pl3.addVertex(ptDraw-vz*dSize);
pl3.addVertex(ptDraw+vz*dSize);
	
dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End