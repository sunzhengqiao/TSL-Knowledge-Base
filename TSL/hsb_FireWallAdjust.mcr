#Version 8
#BeginDescription
Creates beams front and back inside of a wall with a gap in between and a full piece of OSB arount the wall and the openings to close it.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 24.03.2009 - version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
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
* date: 24.03.2009
* version 1.0: Release Version
*
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

//String arSCodeExternalWalls[] = { "A", "B", "H", "I"}; //Add more External Walls codes as you request

String sArNY[] = {T("No"), T("Yes")};

PropString psExtType(1, "AA;B;",  T("Code FireWalla"));

PropDouble dOffsetBottom (1, U(400), T("Offset From Bottom"));

PropDouble dOffsetCenters (2, U(500), T("Centers Spacing"));

PropDouble dOSBTh (3, U(9), T("OSB Thickness"));

//PropString sShowNailPlate(12, sArNY, T("Insert Nail Plates"));
//sShowNailPlate.setDescription("");
//int bShowNailPlate = sArNY.find(sShowNailPlate,0);


//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

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

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


if( _Element.length()==0 ){
	eraseInstance();
	return;
}

//Fill and array with the code of the firewalls

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//          Loop over all elements.

ElementWallSF elWall[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (el.bIsValid())
	{
		String sCode = el.code();
		if( sArrExtCode.find(sCode) != -1 )
		{
			elWall.append(el);
		}
	}
}
double dTh=U(1);
double dWi=U(50);
double dLe=U(137);
String sDispRep="";

//Clonning TSL 
TslInst tsl;
String sScriptName = "hsb_MetalPlate"; // name of the script of the Metal Part
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Entity lstEnts[0];
Beam lstBeams[0];
Point3d lstPoints[0];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];

lstPropDouble.append(dTh);
lstPropDouble.append(dWi);
lstPropDouble.append(dLe);
lstPropString.append(sDispRep);
lstPropString.append("Metal Plate");



for( int e=0; e<elWall.length(); e++ )
{
	ElementWallSF el=elWall[e];
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	_Pt0=ptOrgEl;

	//Map to Clone the Metal Part TSL
	Map mp;
	mp.setVector3d("vx", vz);
	mp.setVector3d("vy", vy);
	mp.setVector3d("vz", -vx);

	//Remove old Metal Part TSL
	TslInst tslIns[]=el.tslInstAttached();
	for (int i=0; i<tslIns.length(); i++)
	{
		if (tslIns[i].scriptName()==sScriptName)
			tslIns[i].dbErase();
	}
	
	PLine plEnvEl=el.plEnvelope();
	Point3d ptVertexEl[]=plEnvEl.vertexPoints(FALSE);
	
	//Some values and point needed after
	Point3d ptFront=el.zone(1).coordSys().ptOrg(); ptFront.vis(1);
	Point3d ptBack=el.zone(-1).coordSys().ptOrg(); ptBack.vis(2);
	
	Plane plnFront (ptFront, vz);
	Plane plnBack (ptBack, vz);
	
	double dWallThickness=abs(vz.dotProduct(ptFront-ptBack));
	
	//Organize the beams in diferent Arrays
	Beam bmAll[]=el.beam();
	Beam bmToPlate[0];
	Beam bmToSplit[0];
	
	//String sTypes[0];
	//sTypes=_BeamTypes;
	
	int arNBmTypesToSplit[] = { _kKingStud, _kSFJackUnderOpening, _kSFJackOverOpening, _kSFTransom, _kSill};
	int arNBmTypesToPlate[] = { _kKingStud, _kStud, _kSFStudLeft, _kSFStudRight, _kSFJackUnderOpening, _kSFJackOverOpening};
	
	Beam bmStudValid;
	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nType=bm.type();

		if( arNBmTypesToSplit.find(nType) != -1 )
			bmToSplit.append(bm);
			
		if( arNBmTypesToPlate.find(nType) != -1 )
		{
			if (nType==_kStud)
				bmStudValid=bm;
			bmToPlate.append(bm);
		}
	}
	
	if (!bmStudValid.bIsValid())
		continue;
	
	double dBmWidth=bmStudValid.dD(vx);
	double dBmHeight=bmStudValid.dD(vz);
	
	
	//Collect the openings and find all the beam that bellong to that module and move the studs to allow insertion of OSB
	Opening opAll[]=el.opening();
	
	for (int n=0; n<opAll.length(); n++)
	{
		Opening op=opAll[n];
		PLine plOp=op.plShape();
		Point3d ptAllVertex[]=plOp.vertexPoints(FALSE);
		Point3d ptCenOp;
		ptCenOp.setToAverage(ptAllVertex);
		PlaneProfile ppOp(cs);
		ppOp.joinRing(plOp, FALSE);
		ppOp.shrink(-(dOSBTh*2));
		Beam bmModule;
		for (int j=0; j<bmAll.length(); j++)
		{
			PlaneProfile ppBm=bmAll[j].realBody().shadowProfile(plnFront);
			ppBm.intersectWith(ppOp);
			if (ppBm.area()>U(2)*U(2))
			{
				bmModule=bmAll[j];
				break;
			}
		}
		if (!bmModule.bIsValid())
			continue;
		
		Beam bmThisModule[0];
		
		String sModule=bmModule.module();
		for (int j=0; j<bmAll.length(); j++)
		{
			if (bmAll[j].module()==sModule)
			{
				bmThisModule.append(bmAll[j]);
			}
		}
		Beam bmTransom[0];
		Beam bmSill[0];
		Beam bmJackOver[0];
		Beam bmJackUnder[0];
		Beam bmStudLeft[0];
		Beam bmStudRight[0];
		for (int j=0; j<bmThisModule.length(); j++)
		{
			int nType=bmThisModule[j].type();
			if (nType==_kKingStud || nType==_kStud)
			{
				if (vx.dotProduct(bmThisModule[j].ptCen()-ptCenOp)<0)
					bmStudLeft.append(bmThisModule[j]);
				else
					bmStudRight.append(bmThisModule[j]);
			} else if (nType==_kSFStudLeft)
			{
				bmStudLeft.append(bmThisModule[j]);
			}else if (nType==_kSFStudRight)
			{
				bmStudRight.append(bmThisModule[j]);
			}else if (nType==_kSFJackUnderOpening)
			{
				bmJackUnder.append(bmThisModule[j]);
			}else if (nType==_kSFJackOverOpening)
			{
				bmJackOver.append(bmThisModule[j]);
			}else if (nType==_kSill)
			{
				bmSill.append(bmThisModule[j]);
			}else if (nType==_kSFTransom)
			{
				bmTransom.append(bmThisModule[j]);
			}
		}
		bmStudLeft=vx.filterBeamsPerpendicularSort(bmStudLeft);
		bmStudRight=vx.filterBeamsPerpendicularSort(bmStudRight);
		bmJackUnder=vx.filterBeamsPerpendicularSort(bmJackUnder);
		bmJackOver=vx.filterBeamsPerpendicularSort(bmJackOver);
				
		for (int j=0; j<bmStudLeft.length(); j++)
		{
			bmStudLeft[j].transformBy(-vx*(dOSBTh));
		}
		for (int j=0; j<bmStudRight.length(); j++)
		{
			bmStudRight[j].transformBy(vx*(dOSBTh));
		}
		if (bmJackOver.length()>0)
		{
			bmJackOver[0].transformBy(-vx*(dOSBTh));
		}
		if (bmJackUnder.length()>0)
		{
			bmJackUnder[0].transformBy(-vx*(dOSBTh));
		}
		if (bmSill.length()>0)
		{
			for (int j=0; j<bmSill.length(); j++)
			{
				bmSill[j].transformBy(-vy*(dOSBTh));
				if(bmStudLeft.length()>0)
				{
					bmSill[j].stretchStaticTo(bmStudLeft[bmStudLeft.length()-1], TRUE);
				}
				if(bmStudRight.length()>0)
				{
					bmSill[j].stretchStaticTo(bmStudRight[bmStudRight.length()-1], TRUE);
				}
			}
			for (int j=0; j<bmJackUnder.length(); j++)
			{
				bmJackUnder[j].stretchStaticTo(bmSill[0], TRUE);
			}
		}
		if (bmTransom.length()>0)
		{
			for (int j=0; j<bmTransom.length(); j++)
			{
				bmTransom[j].transformBy(vy*(dOSBTh));
				if(bmStudLeft.length()>0)
				{
					bmTransom[j].stretchStaticTo(bmStudLeft[bmStudLeft.length()-1], TRUE);
				}
				if(bmStudRight.length()>0)
				{
					bmTransom[j].stretchStaticTo(bmStudRight[bmStudRight.length()-1], TRUE);
				}
			}
			for (int j=0; j<bmJackOver.length(); j++)
			{
				bmJackOver[j].stretchStaticTo(bmTransom[0], TRUE);
			}
		}
		
		//Create the OSB Around the Opening
		ptAllVertex=plnFront.projectPoints(ptAllVertex);
		for (int j=0; j<ptAllVertex.length()-1; j++)
		{
			Vector3d vxSh=ptAllVertex[j+1]-ptAllVertex[j];
			double dLen=vxSh.length();
			vxSh.normalize();
			Vector3d vzSh=vxSh.crossProduct(vz);
			vzSh.normalize();
			
			Sheet sh;
			sh.dbCreate(ptAllVertex[j], vxSh, vz, vzSh, dLen, dWallThickness, dOSBTh, 1, -1, 1);
			sh.setMaterial("OSB");
			sh.setName("OSB");
			sh.assignToElementGroup(el, TRUE, 0, 'Z');
		}

	}


	for (int i=0; i<bmToSplit.length(); i++)
	{
		Beam bm=bmToSplit[i];
		if (bm.dD(vz)>(dBmHeight+U(1)))
		{
			bm.setD(vz, dBmHeight);
			Point3d ptAux=bm.ptCen();
			ptAux=plnFront.closestPointTo(ptAux);
			bm.transformBy(vz*abs((vz.dotProduct(ptAux-bm.ptCen()))-dBmHeight*0.5));
			Beam bmNew=bm.dbCopy();
			bmNew.transformBy(-vz*(dWallThickness-dBmHeight));
			if (bm.type()==_kKingStud || bm.type()==_kSFJackUnderOpening || bm.type()==_kSFJackOverOpening)
				bmToPlate.append(bmNew);
		}
	}

	Beam bmFrontTmp[0];
	Beam bmBackTmp[0];
	Beam bmFront[0];
	Beam bmBack[0];

	for (int i=0; i<bmToPlate.length(); i++)
	{
		Beam bm=bmToPlate[i];
		if (abs(vz.dotProduct(bm.ptCen()-ptFront))<dBmHeight) //Front
		{
			bmFrontTmp.append(bm);
		}//Back
		else
		{
			bmBackTmp.append(bm);
		}
	}
	
	for (int i=0; i<bmFrontTmp.length(); i++)
	{
		Beam bm=bmFrontTmp[i];
		Beam bmPosibleBack[0];
		bmPosibleBack=bm.filterBeamsCenterDistanceYZRange(bmBackTmp, U(5), U(dWallThickness));
		
		if (bmPosibleBack.length()!=1)
		{
			for (int j=0; j<bmPosibleBack.length(); j++)
			{
				if (abs(vx.dotProduct(bm.ptCen()-bmPosibleBack[j].ptCen()))>U(3) || abs(vy.dotProduct(bm.ptCen()-bmPosibleBack[j].ptCen()))>U(3))
				{
					bmPosibleBack.removeAt(j);
					j--;
				}
			}
		}
		
		if (bmPosibleBack.length()!=1)
		{
			reportNotice("beam duplicated");
			continue;
		}
		//Create the Plates
		PlaneProfile ppBm=bm.realBody().shadowProfile(plnFront);
		LineSeg ls=ppBm.extentInDir(vy);
		Line lnBm (bm.ptCen(), vy);
		Point3d ptBaseBm=ls.ptStart();
		
		
		
		
		//Create the Sheeting
		if (bm.type()==_kSFJackOverOpening || bm.type()==_kSFJackUnderOpening)
		{
			Plane plnSideBm(bm.ptCen()+vx*bm.dD(vx)*0.5, vx);
			ptBaseBm=plnSideBm.closestPointTo(ptBaseBm);
			ptBaseBm=plnFront.closestPointTo(ptBaseBm);
			
			double dLen=abs(vy.dotProduct(ls.ptStart()-ls.ptEnd()));
			
			Sheet sh;
			sh.dbCreate(ptBaseBm, vy, -vz, -vx, dLen, dWallThickness, dOSBTh, 1, 1, -1);
			sh.setMaterial("OSB");
			sh.setName("OSB");
			sh.assignToElementGroup(el, TRUE, 0, 'Z');
	
			
		}
		else//Create the Metal Plates
		{
			ptBaseBm=ptBaseBm+vy*dOffsetBottom;
			ptBaseBm=lnBm.closestPointTo(ptBaseBm);
			lstBeams.setLength(0);
			lstBeams.append(bm);
			lstBeams.append(bmPosibleBack[0]);
			
			while(ppBm.pointInProfile(ptBaseBm)==_kPointInProfile )
			{
				lstPoints.setLength(0);
				lstPoints.append(ptBaseBm);
	
				tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
				ptBaseBm=ptBaseBm+vy*dOffsetCenters;
			}
		}
		
		
	}
	
	//Create the OSB Around the Element
	ptVertexEl=plnFront.projectPoints(ptVertexEl);
	for (int j=0; j<ptVertexEl.length()-1; j++)
	{
		Vector3d vxSh=ptVertexEl[j+1]-ptVertexEl[j];
		double dLen=vxSh.length();
		vxSh.normalize();
		Vector3d vzSh=vxSh.crossProduct(vz);
		vzSh.normalize();
		
		Sheet sh;
		sh.dbCreate(ptVertexEl[j], vxSh, vz, vzSh, dLen, dWallThickness, dOSBTh, 1, -1, 1);
		sh.setMaterial("OSB");
		sh.setName("OSB");
		sh.assignToElementGroup(el, TRUE, 0, 'Z');
	}
}


//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                 Erase instance

eraseInstance();



#End
#BeginThumbnail
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
>%%%`!1110`4444`%%%%`!1110`4444`%%%%`'__9
`


#End
