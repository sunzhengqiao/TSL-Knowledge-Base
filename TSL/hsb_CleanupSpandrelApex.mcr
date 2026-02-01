#Version 8
#BeginDescription
Cuts the angle plate that intersect the bottom plate and if necesary apply a blocking piece,

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 13.11.2012 - version 1.3




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
* date: 19.10.2012
* version 1.3: Release Version
*
*/

_ThisInst.setSequenceNumber(-90);

Unit(1,"mm"); // script uses mm

//String sArNY[] = {T("No"), T("Yes")};

//PropString sExtraBeam (0, sArNY, T("Add extra blocking at apex"));

PropDouble dBmLength (0, U(300), T("|Beam Length|"));
PropString sName (0, "Blocking", T("|Beam Name|"));
PropString sMaterial (1, "CLS", T("|Beam Material|"));
PropString sGrade (2, "C16", T("|Beam Grade|"));


int nBmType[0];
String sBmName[0];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//int nExtraBeam=sArNY.find(sExtraBeam);

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=false;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	if (!el.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Plane plnZ(_Pt0, vz);
	
	Beam bmAll[]=el.beam();
	if (bmAll.length()==0)
		continue;
	
	Beam bmBottom[0];
	Beam bmAllAngle[0];
	
	Beam bmToCheck[0];
	
	Beam bmToStretch[0];
	
	for (int i = 0; i < bmAll.length(); i++)
	{
		int nType=bmAll[i].type();
		if ( nType==_kSFAngledTPLeft || nType==_kSFAngledTPRight )
		{
			bmAllAngle.append(bmAll[i]);
		}
		else if (nType==_kSFBottomPlate)
		{
			bmBottom.append(bmAll[i]);
		}
		else if (nType== _kSFStudLeft || nType== _kSFStudRight)
		{
			bmToCheck.append(bmAll[i]);
		}
		if (nType== _kStud)
		{
			bmToStretch.append(bmAll[i]);
		}
	}
	
	for (int b = 0; b < bmBottom.length(); b++)
	{
		bmBottom[b].realBody().vis(32);
		Beam bmIntersect[]=bmBottom[b].filterBeamsCapsuleIntersect(bmAllAngle);
		Point3d ptTopPlate=bmBottom[b].ptCen()+bmBottom[b].vecD(vy)*(U(bmBottom[b].dD(vy)*0.5));
		Line lnBottom(ptTopPlate, bmBottom[b].vecX());
		
		Vector3d vyBmBottom=bmBottom[b].vecX().crossProduct(bmBottom[b].vecD(vz));
		vyBmBottom.normalize();
			
		if (vyBmBottom.dotProduct(vy)<0)
			vyBmBottom=-vyBmBottom;

		
		
		PlaneProfile ppBottom=bmBottom[b].realBody().shadowProfile(plnZ);
		for (int c = 0; c < bmIntersect.length(); c++)
		{
			Beam bm=bmIntersect[c];
			bm.realBody().vis(32);
			
			Vector3d vyBm=bm.vecX().crossProduct(bm.vecD(vz));
			vyBm.normalize();
			
			if (vyBm.dotProduct(vy)<0)
				vyBm=-vyBm;
			
			vyBm=bm.vecD(vyBm);
			
			
			Point3d ptAngle=bm.ptCen()-vyBm*(U(bm.dD(vyBm)*0.5));
			Line lnAngle(ptAngle, bm.vecX());
			
			Point3d ptTopAngle=bm.ptCen()+vyBm*(U(bm.dD(vyBm)*0.5));
			Line lnTopAngle(ptTopAngle, bm.vecX());
			
			Point3d ptIntersect=lnBottom.closestPointTo(lnAngle);
			ptIntersect.vis(1);
			
			Point3d ptTopIntersect=lnBottom.closestPointTo(lnTopAngle);
			ptTopIntersect.vis(1);
			
			Vector3d vDir(ptIntersect-bm.ptCen());
			vDir.normalize();
			vDir.vis(ptIntersect, 1);

			PlaneProfile ppAngle=bm.realBody().shadowProfile(plnZ);
			ppAngle.intersectWith(ppBottom);
			if (ppAngle.area()/U(1)*U(1) > U(1)*U(1))
			{
				Cut ct(ptTopPlate, -vyBmBottom);
				bm.addToolStatic(ct);
				
				Cut ctBottomPlate(ptTopIntersect, vyBm);
				bmBottom[b].addToolStatic(ctBottomPlate);
				
				for (int i=0; i<bmToCheck.length(); i++)
				{
					PlaneProfile ppThisBeam=bmToCheck[i].realBody().shadowProfile(plnZ);
					ppThisBeam.intersectWith(ppBottom);
					if (ppThisBeam.area()/U(1)*U(1)>U(1)*U(1))
					{
						bmToCheck[i].dbErase();
					}
				}
			}
			else
			{
				Body bd=bm.realBody();
				Point3d ptAllVer[]=bd.extremeVertices(-vDir);
				Point3d ptBaseAngle=ptAllVer[0];
				ptBaseAngle.vis(2);
				double dA=vy.dotProduct(ptBaseAngle-ptTopPlate);
				
				//Plane pln(ptTopPlate, bmBottom[b].vecD(vy));
				
				//PlaneProfile ppSlice=bd.extractContactFaceInPlane(pln, U(1));
				
				//double dArea=ppSlice.area();
				
				//if (ppSlice.area()/U(1)*U(1)<U(5)*U(5))
				{
					
					if (vy.dotProduct(ptBaseAngle-ptTopPlate)<U(5) && vy.dotProduct(ptBaseAngle-ptTopPlate)>U(0))
					{
						Vector3d vxNewBm=bmBottom[b].vecX();
						if (vxNewBm.dotProduct(vDir)<0)
							vxNewBm=-vxNewBm;
						vxNewBm.normalize();
						Vector3d vyNewBm=bmBottom[b].vecD(vyBmBottom);
						Vector3d vzNewBm=vxNewBm.crossProduct(vyNewBm);
						vzNewBm.normalize();
						
						Point3d ptToCreate=lnBottom.closestPointTo(ptBaseAngle);
						
						ptToCreate.vis(3);
						
						Cut ct(ptAngle, vyBm);
						
						if (dBmLength>0)
						{
						
							Beam bm;
							bm.dbCreate(ptToCreate, vxNewBm, vyNewBm, vzNewBm, dBmLength, bmBottom[b].dD(vyBm),bmBottom[b].dD(vzNewBm), -1, 1, 0);
							bm.setColor(32);
							bm.setName(sName);
							bm.setMaterial(sMaterial);
							bm.setGrade(sGrade);
							bm.assignToElementGroup(el, true, 0, 'Z');
							bm.setType(_kSFBlocking);
							bm.addToolStatic(ct);
							
							Beam bmResult[]=Beam().filterBeamsHalfLineIntersectSort(bmToStretch, ptIntersect+vy*U(10), -vxNewBm);
							
							if (bmResult.length()>0)
							{
								Beam bmFirst=bmResult[0];
								if ((abs(vxNewBm.dotProduct(ptIntersect-bmFirst.ptCen()))-bmFirst.dD(vxNewBm)*0.5)<dBmLength)
								{
									Point3d ptCut=bmFirst.ptCen()+(bmFirst.vecD(vxNewBm)*bmFirst.dD(vxNewBm)*0.5);
									Cut ct1(ptCut, -vxNewBm);
									bm.addToolStatic(ct1, _kStretchOnToolChange);
								}
							}
						}
					}
				}
			}
			nErase=true;
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
