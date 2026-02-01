#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
16.09.2009  -  version 1.3



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
* date: 21.07.2009
* version 1.0: Release Version
*
* date: 22.07.2009
* version 1.1: Remove Top and Bottom Plate from the posible beams to strech
*
* date: 11.09.2009
* version 1.2: Change the tool on the angle plates to a birdsmouth
*
* date: 16.09.2009
* version 1.3: BugFix
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropDouble dDepth1 (0, U(10), T("Depth inside Plate"));
dDepth1.setDescription(T("Depth that the Studs are going to be cut inside the top and bottom plate"));

int nBmType[0];

nBmType.append(_kSFAngledTPLeft);				//sBmName.append("TOPPLATE");				nColor.append(32);
nBmType.append(_kSFAngledTPRight);				//sBmName.append("TOPPLATE");				nColor.append(32);
nBmType.append(_kSFTopPlate);						//sBmName.append("TOP PLATE");			nColor.append(32);
nBmType.append(_kSFBottomPlate);					//sBmName.append("BOTTOM PLATE");		nColor.append(32);



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
	
	for (int i=0; i<bmAll.length(); i++)
	{
		if (nBmType.find(bmAll[i].type(),-1) != -1)//|| bmAll[i].type()==_kSFStudLeft || bmAll[i].type()==_kSFStudRight
		{
			bmFemale.append(bmAll[i]);
		}
		else
		{
			bmMale.append(bmAll[i]);
		}
	}
	

	for (int i=0; i<bmFemale.length(); i++)
	{
		Beam bmToCut[0];
		bmFemale[i].realBody().vis(1);
		bmToCut=bmFemale[i].filterBeamsCapsuleIntersect(bmMale);//, U(10), false
		int nBirdsmouth=FALSE;
		
		if (bmFemale[i].type()==_kSFAngledTPLeft || bmFemale[i].type()==_kSFAngledTPRight)
			nBirdsmouth=TRUE;
		
		for (int j=0; j<bmToCut.length(); j++)
		{
			if (bmToCut[j].dD(vx)>bmToCut[j].dD(vz))
				continue;
			if (bmToCut[j].hasTConnection(bmFemale[i], U(10), TRUE))
			{
				Vector3d vCut=bmFemale[i].vecD(bmFemale[i].ptCen()-bmToCut[j].ptCen());
				vCut.vis(bmToCut[j].ptCen(), 2);
				Plane pln (bmFemale[i].ptCen()-vCut*(bmFemale[i].dD(vCut)*0.5), vCut);
				
				Vector3d vNormalCut=bmToCut[j].vecX();
				if (vCut.dotProduct(vNormalCut)<0)
					vNormalCut=-vNormalCut;
				
				Point3d ptTmp1=Line(bmToCut[j].ptCen()-vx*U(bmToCut[j].dD(vx)*0.5), bmToCut[j].vecX()).intersect(pln, 0);
				Point3d ptTmp2=Line(bmToCut[j].ptCen()+vx*U(bmToCut[j].dD(vx)*0.5), bmToCut[j].vecX()).intersect(pln, 0);
				Point3d ptInter;
				if (ptTmp1.Z()>=ptTmp2.Z())
				{
					ptInter=Line(bmToCut[j].ptCen(), bmToCut[j].vecX()).closestPointTo(ptTmp1);
				}
				else
				{
					ptInter=Line(bmToCut[j].ptCen(), bmToCut[j].vecX()).closestPointTo(ptTmp2);
				}
				ptInter.vis();
				
				//Cut ctMale (ptInter+vCut*dDepth1, vCut);
				if (nBirdsmouth)
				{
					Cut ctMale (ptInter, vNormalCut);
					bmToCut[j].addToolStatic(ctMale, TRUE);//_kStretchOnToolChange
					
					BeamCut bcFemale (ptInter, vNormalCut, vz, vNormalCut.crossProduct(vz), U(100), U(300), bmToCut[j].dD(vx), -1,0,0 );
					bcFemale.cuttingBody().vis();
					bmFemale[i].addToolStatic(bcFemale);
					
				}
				else
				{
					Cut ctMale (ptInter+vNormalCut*dDepth1, vNormalCut);
					bmToCut[j].addToolStatic(ctMale, TRUE);//_kStretchOnToolChange
					
					BeamCut bcFemale (ptInter+vNormalCut*dDepth1, vNormalCut, vz, vNormalCut.crossProduct(vz), U(100), U(300), bmToCut[j].dD(vx), -1,0,0 );
					bcFemale.cuttingBody().vis();
					bmFemale[i].addToolStatic(bcFemale);
				}
			}
		}
	}
}

eraseInstance();
return;





#End
#BeginThumbnail







#End
