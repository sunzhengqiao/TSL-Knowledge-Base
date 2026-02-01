#Version 8
#BeginDescription
Overwrites the existing T connection by applying the "hsb_Wall to Wall Connection" TSL

Modify by: Alberto Jena (aj@hsb-cad.com)
Date: 06.10.2009 - version 1.0




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
* date: 06.10.2008
* version 1.0: Release Version
*
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties


//if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	//if (_kExecuteKey=="")
	//	showDialogOnce();
		
	PrEntity ssE("\n"+T("Select 2 Walls Connected"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	if (_Element.length()!=2)
	{
		eraseInstance();
		return;
	}
	
	return;
}



String sCalatog;
if (_Map.hasString("Catalog")) sCalatog= _Map.getString("Catalog");
if (sCalatog!="");
	_kExecuteKey=sCalatog;

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _Element.length()<1 ){
	eraseInstance();
	return;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//                                      Loop over all elements.

int nColor=32;

ElementWallSF elWall[0];
String strWallNames[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (el.bIsValid())
	{
		elWall.append(el);
	}
}

String sWall;
if (_Map.hasString("Wall")) sWall= _Map.getString("Wall");
String sStud;
int nStud=FALSE;
if (_Map.hasString("Stud")) sStud= _Map.getString("Stud");
sStud.makeUpper();
if (sStud=="TRUE") nStud=TRUE;


int nBmTypeValid[0];
nBmTypeValid.append(_kSFStudRight);
nBmTypeValid.append(_kSFStudLeft);
nBmTypeValid.append(_kStud);


ElementWallSF elM;
ElementWallSF elF;
for (int j=0; j<elWall.length(); j++)
{
	ElementWallSF el=elWall[j];
	
	String strNameThis=el.code()+el.number();
	
	double dSpacingBeam=el.spacingBeam();
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	if (bmVer.length()<1)	
	{
		return;
	}
	
	Beam bmValidVer[0];
	for (int i=0; i<bmVer.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBeamType=bm.type();
		if (nBmTypeValid.find(nBeamType, -1) != -1)
			bmValidVer.append(bmVer[i]);
	}
			
	double dBeamWidth=bmVer[0].dD(vx);
	double dBeamHeight=bmVer[0].dD(vz);
	
	Line lnEl(el.ptOrg()-el.vecZ()*U(dBeamHeight*0.5),el.vecX());
	
	Element elCon[] = el.getConnectedElements();
	
	for (int c=0; c<elCon.length(); c++)
	{
		//Element elC=elCon[i];//dPosZOutlineFront
		ElementWall elC = (ElementWall) elCon[c];
		if (elC.bIsValid())
		{
			if (elC.code()!=sWall) continue;
			
			PLine plOutline=elC.plOutlineWall();
			
			Line lnElC(elC.ptOrg()-elC.vecZ()*U(45),elC.vecX());
			//Point3d ptArr[]=el.plOutlineWall().vertexPoints(TRUE);
			//int nIntersection=FALSE;
			
			Point3d ptInter = lnEl.closestPointTo(lnElC);
			
			Point3d ptBlock=ptInter+vy*U(400);
			_Pt0=ptBlock;
			Body bdConnection(ptBlock, vx, vy, vz, U(90), U(200), U(90));
			int nOverWrite=FALSE;
			String sBeamOnIntersection[0];
			
			for (int i=0; i<bmValidVer.length(); i++)
			{
				if (bmValidVer[i].envelopeBody().hasIntersection(bdConnection))
				{
					sBeamOnIntersection.append(bmValidVer[i].handle());
					nOverWrite=TRUE;
				}
			}
			
			Beam bmValidToSearch[0];
			for (int i=0; i<bmValidVer.length(); i++)
			{
				if (sBeamOnIntersection.find(bmValidVer[i].handle(), -1) == -1)
				{
					bmValidToSearch.append(bmValidVer[i]);
				}
			}
			
			
			if (nOverWrite)
			{
				Beam bmLeft;
				Beam bmRight;
				Beam bmAux[0];
				bmAux=Beam().filterBeamsHalfLineIntersectSort(bmValidToSearch, ptBlock, vx);
				if (bmAux.length()>0)
				{
					bmRight=bmAux[0];
				}
					
				bmAux.setLength(0);
				bmAux=Beam().filterBeamsHalfLineIntersectSort(bmValidToSearch, ptBlock, -vx);
				if (bmAux.length()>0)
					bmLeft=bmAux[0];
				
				Body bdA=bmLeft.realBody();bdA.vis(c);
				Body bdB=bmRight.realBody();bdB.vis(c);
				ptInter.vis(1);
				
				if (bmLeft.bIsValid() && bmRight.bIsValid())
				{
					
					if (vx.dotProduct(bmRight.ptCen()-bmLeft.ptCen())>dSpacingBeam+U(5))
					{
						if (nStud)
						{
							Beam bmNew;
							if (bmLeft.type()==_kStud || bmLeft.type()==_kSFStudLeft)
							{
								bmNew=bmLeft.dbCopy();
								bmNew.transformBy(vx*dSpacingBeam);
							}else if (bmRight.type()==_kStud || bmLeft.type()==_kSFStudRight)
							{
								bmNew=bmRight.dbCopy();
								bmNew.transformBy(-vx*dSpacingBeam);
							}
							if (bmNew.bIsValid())
							{
								PLine plCircle(_ZW);
								plCircle.createCircle(bmNew.ptCen(), _ZW, U(dBeamHeight));
								EntPLine pl;
								pl.dbCreate(plCircle);
								pl.setColor(1);
							}
						}
						else
						{
							String strScriptName = "hsb_Wall to Wall Connection"; // name of the script
							Vector3d vecUcsX(1,0,0);
							Vector3d vecUcsY(0,1,0);
							Beam lstBeams[0];
							Element lstElements[0];
							Point3d lstPoints[0];
							int lstPropInt[0];
							double lstPropDouble[0];
							String lstPropString[0];
							lstElements.append(el);
							lstElements.append(elC);
							TslInst tsl;
							Map mpToClone;
							
							mpToClone.setInt("ExecutionMode",0);
							mpToClone.setString("ExecuteKey",_kExecuteKey);
		
							tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone); // create new instance
							tsl.transformBy(_XW*U(1));
							//tsl.showDialog(); // allows the user to input the values of the newly created tsl
		
							
							//reportNotice(_kExecuteKey);
						}
						
					}
				}
			}

		}
	}
}


eraseInstance();
return;

//assignToElementGroup(elF, TRUE, 0, 'I');
//_Map.setInt("nExecutionMode", 1);
/*
Display dp(nColorDisp);
//Display something
double dSize = Unit(25, "mm");
//Display dspl (-1);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
PLine pl4(_ZW);
PLine pl5(_ZW);
Point3d ptDraw=_Pt0;
ptDraw=ptDraw+vx*U(10)+vy*U(10)-vz*U(45);
pl1.addVertex(ptDraw+vx*dSize);
pl1.addVertex(ptDraw-vx*dSize);
pl2.addVertex(ptDraw-vy*dSize);
pl2.addVertex(ptDraw+vy*dSize);
pl3.addVertex(ptDraw-vz*dSize);
pl3.addVertex(ptDraw+vz*dSize);
pl4.addVertex(ptDraw+vx*dSize);
pl4.addVertex(ptDraw+vz*dSize);
pl5.addVertex(ptDraw-vx*dSize);
pl5.addVertex(ptDraw-vz*dSize);

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);
dp.draw(pl4);
dp.draw(pl5);


*/















#End
#BeginThumbnail




#End
