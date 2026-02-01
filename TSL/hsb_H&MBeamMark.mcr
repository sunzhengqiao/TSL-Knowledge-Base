#Version 8
#BeginDescription
Places marks on places where two beams are touching each other. Head-to-head contacts are not considerd.

Modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 20.03.2013 - version 1.4




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
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
* date: 21.07.2011
* version 1.0: Release Version
*
* date: 25.07.2011
* version 1.1: Add Property for location of the mark, left, right, both.
*
* date: 20.03.2013
* version 1.4: Added beam types to exclude during marking
*/

Unit(1,"mm");

int nBmType[0];
String sBmName[0];

nBmType.append(_kSFJackOverOpening);			sBmName.append("S");	
nBmType.append(_kSFJackUnderOpening);			sBmName.append("S");	
nBmType.append(_kCrippleStud);					sBmName.append("S");	
nBmType.append(_kSFTransom);						sBmName.append("S");	
nBmType.append(_kKingStud);						sBmName.append("S");	
nBmType.append(_kSill);								sBmName.append("S");	
nBmType.append(_kSFAngledTPLeft);				sBmName.append("S");	
nBmType.append(_kSFAngledTPRight);				sBmName.append("S");	
nBmType.append(_kSFTopPlate);						sBmName.append("S");	
nBmType.append(_kSFBottomPlate);					sBmName.append("S");	

nBmType.append(_kSFBlocking);						sBmName.append("S");	
nBmType.append(_kSFSupportingBeam);			sBmName.append("S");	
nBmType.append(_kStud);							sBmName.append("S");	
nBmType.append(_kSFStudLeft);						sBmName.append("S");	
nBmType.append(_kSFStudRight);					sBmName.append("S");	
nBmType.append(_kHeader);							sBmName.append("S");	
nBmType.append(_kBrace);							sBmName.append("S");	
nBmType.append(_kLocatingPlate);					sBmName.append("S");	
nBmType.append(_kSFPacker);						sBmName.append("S");	
nBmType.append(_kSFSolePlate);					sBmName.append("S");	

String strSide []={T("Left"),T("Right"), T("Both")};
PropString sSide (0, strSide, T("Marking Side"));
int nSide = strSide.find(sSide);

String sArNY[] = {T("No"), T("Yes")};
PropString sMes(1, "----------", T("Types to exclude when marking"));
sMes.setReadOnly(true);
PropString sbmName00(2, sArNY, T("Jack Over Opening"),0);
PropString sbmName01(3, sArNY, T("Jack Under Opening"),0);
PropString sbmName02(4, sArNY, T("Cripple Stud"),0);
PropString sbmName03(5, sArNY, T("Transom"),0);
PropString sbmName04(6, sArNY, T("King Stud"),0);
PropString sbmName05(7, sArNY, T("Sill"),0);
PropString sbmName06(8, sArNY, T("Angled TopPlate Left"),0);
PropString sbmName07(9, sArNY, T("Angled TopPlate Right"),0);
PropString sbmName08(10, sArNY, T("TopPlate"),0);
PropString sbmName09(11, sArNY, T("Bottom Plate"),0);
PropString sbmName10(12, sArNY, T("Blocking"),0);
PropString sbmName11(13, sArNY, T("Supporting Beam"),0);
PropString sbmName12(14, sArNY, T("Stud"),0);
PropString sbmName13(15, sArNY, T("Stud Left"),0);
PropString sbmName14(16, sArNY, T("Stud Right"),0);
PropString sbmName15(17, sArNY, T("Header"),0);
PropString sbmName16(18, sArNY, T("Brace"),0);
PropString sbmName17(19, sArNY, T("Locating Plate"),0);
PropString sbmName18(20, sArNY, T("Packer"),0);
PropString sbmName19(21, sArNY, T("SolePlate"),0);
PropString sbmName20(22, sArNY, T("HeadBinder/Very Top Plate"),0);

//BEAM TYPES
int nBmTypeExclusions[0];
int arExclude[0];
nBmTypeExclusions.append(_kSFJackOverOpening);
nBmTypeExclusions.append(_kSFJackUnderOpening);
nBmTypeExclusions.append(_kCrippleStud);
nBmTypeExclusions.append(_kSFTransom);
nBmTypeExclusions.append(_kKingStud);
nBmTypeExclusions.append(_kSill);
nBmTypeExclusions.append(_kSFAngledTPLeft);
nBmTypeExclusions.append(_kSFAngledTPRight);
nBmTypeExclusions.append(_kSFTopPlate);
nBmTypeExclusions.append(_kSFBottomPlate);
nBmTypeExclusions.append(_kSFBlocking);
nBmTypeExclusions.append(_kSFSupportingBeam);
nBmTypeExclusions.append(_kStud);
nBmTypeExclusions.append(_kSFStudLeft);
nBmTypeExclusions.append(_kSFStudRight);
nBmTypeExclusions.append(_kHeader);
nBmTypeExclusions.append(_kBrace);
nBmTypeExclusions.append(_kLocatingPlate);
nBmTypeExclusions.append(_kSFPacker);
nBmTypeExclusions.append(_kSFSolePlate);
nBmTypeExclusions.append(_kSFVeryTopPlate);


arExclude.setLength(0);
arExclude.append(sArNY.find(sbmName00));
arExclude.append(sArNY.find(sbmName01));
arExclude.append(sArNY.find(sbmName02));
arExclude.append(sArNY.find(sbmName03));
arExclude.append(sArNY.find(sbmName04));
arExclude.append(sArNY.find(sbmName05));
arExclude.append(sArNY.find(sbmName06));
arExclude.append(sArNY.find(sbmName07));
arExclude.append(sArNY.find(sbmName08));
arExclude.append(sArNY.find(sbmName09));
arExclude.append(sArNY.find(sbmName10));
arExclude.append(sArNY.find(sbmName11));
arExclude.append(sArNY.find(sbmName12));
arExclude.append(sArNY.find(sbmName13));
arExclude.append(sArNY.find(sbmName14));
arExclude.append(sArNY.find(sbmName15));
arExclude.append(sArNY.find(sbmName16));
arExclude.append(sArNY.find(sbmName17));
arExclude.append(sArNY.find(sbmName18));
arExclude.append(sArNY.find(sbmName19));
arExclude.append(sArNY.find(sbmName20));



if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//Insert donde in script.
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\nSelect a set of elements",ElementWall());	
  	if (ssE.go()) { 
		_Element.append(ssE.elementSet());
	}

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
	
	lstPropString.append(sSide);
	lstPropString.append(sMes);
	lstPropString.append(sbmName00);	
	lstPropString.append(sbmName01);
	lstPropString.append(sbmName02);
	lstPropString.append(sbmName03);
	lstPropString.append(sbmName04);
	lstPropString.append(sbmName05);
	lstPropString.append(sbmName06);
	lstPropString.append(sbmName07);
	lstPropString.append(sbmName08);
	lstPropString.append(sbmName09);
	lstPropString.append(sbmName10);
	lstPropString.append(sbmName11);
	lstPropString.append(sbmName12);
	lstPropString.append(sbmName13);
	lstPropString.append(sbmName14);
	lstPropString.append(sbmName15);
	lstPropString.append(sbmName16);
	lstPropString.append(sbmName17);
	lstPropString.append(sbmName18);
	lstPropString.append(sbmName19);
	lstPropString.append(sbmName20);																	
	
	for( int e=0; e<_Element.length(); e++ )
	{
		Element el = _Element[e];
	
		TslInst tslIns[]=el.tslInstAttached();
		for(int i=0;i<tslIns.length();i++)
  		{
			if (tslIns[i].scriptName()==scriptName() && tslIns[i].handle()!=_ThisInst.handle())
			{
				tslIns[i].dbErase();
			}
		}
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}
	eraseInstance();
	return;
}

//Check if there are elements selected. If not erase instance and return to drawing.
if(_Element.length()==0){eraseInstance(); return;}

//Assign selected element to el.
Element el = _Element[0];
//Create coordsys.
CoordSys csEl = el.coordSys();

//Get all beams from this element.
Beam arBm[] = el.beam();
if (arBm.length()==0)
	return;

Display dp(-1);

//place marble on origin of element. (only shown if no display is used in tsl)
_Pt0 = el.ptOrg();

Vector3d vDir=csEl.vecX();
vDir=vDir.rotateBy(15, csEl.vecZ());
vDir.vis(_Pt0, 1);

//Loop over all beams.
for(int i=0; i<arBm.length(); i++)
{
	Beam bm=arBm[i];
	int nType=bm.type();
	int nLocation=nBmType.find(nType);
	if(nLocation!=-1 && nLocation<arExclude.length())
	{
		int nExclude=arExclude[nLocation];
		if(nExclude) continue;
	}

	String strSubLabel = "";
	int strHSBid = bm.type();
	int foundID = nBmTypeExclusions.find(strHSBid, -1);
	if (foundID>-1)
	{
		strSubLabel=sBmName[foundID];
	}
	else
	{
		continue;
	}

	//Define points on both sides of the beam
	Point3d ptBm = bm.ptCen();
	Point3d ptLeft = bm.ptCen() - 0.5 * bm.vecY() * bm.dW();
	Point3d ptRight = bm.ptCen() + 0.5 * bm.vecY() * bm.dW();

	if (vDir.dotProduct(ptLeft-ptRight)>0)
	{
		Point3d ptAux=ptLeft;
		ptLeft=ptRight;
		ptRight=ptAux;
	}
	
	ptLeft.vis(i);
	ptRight.vis(i);
	
	//Define a line through those points in the vecX direction of this beam.
	Line lnBm(ptBm, bm.vecX());
	Line lnLeft(ptLeft, bm.vecX());
	Line lnRight(ptRight, bm.vecX());
	
	//Filter all beams with a T-connection on this beam. dRange is 0.
	Beam arBmT[] = bm.filterBeamsTConnection(arBm, 0.5 * bm.dW(), TRUE);
	
	//Loop over all beams with a T-connection with male beam.
	for(int j=0; j<arBmT.length(); j++)
	{
		//Eliminate head-to-head beams.
		if( arBmT[j].hasTConnection(bm, 0.5 * bm.dW(), TRUE) ) continue;
		
		//Vector in direction of centerpoint of male beam
		Vector3d vecNormalFace = arBmT[j].vecY();
		if( arBmT[j].vecY().dotProduct(bm.ptCen() - arBmT[j].ptCen()) < 0 )
		{
			vecNormalFace = -arBmT[j].vecY();
		}
		
		//Point for plane to find intersection with lines.
		Point3d ptMarkPlane = arBmT[j].ptCen() + 0.5 * vecNormalFace * arBmT[j].dW();
	
		//Define points on beam with a T-connection
		if (abs(lnBm.vecX().dotProduct(arBmT[j].vecY()))<0.01) continue;
	    
		Point3d ptMark = lnBm.intersect(Plane(ptMarkPlane, arBmT[j].vecY()),0);
		Point3d ptMark1 = lnLeft.intersect(Plane(ptMarkPlane, arBmT[j].vecY()),0);
		Point3d ptMark2 = lnRight.intersect(Plane(ptMarkPlane, arBmT[j].vecY()),0);
	
		//Define a Mark-tool which draws two lines on the female beam of the T-connection.
		
		if (nSide==0)//Left
		{
			Mark mark( ptMark1, vecNormalFace);
			//Add tool to the female beam of the T-connection.
			arBmT[j].addTool(mark);			
		}
		else if (nSide==1)//Right
		{
			Mark mark( ptMark2, vecNormalFace);
			//Add tool to the female beam of the T-connection.
			arBmT[j].addTool(mark);	
		}
		else if (nSide==2)//Right
		{
			Mark mark( ptMark1, ptMark2, vecNormalFace);
			//Add tool to the female beam of the T-connection.
			arBmT[j].addTool(mark);
		}
	}
}

assignToElementGroup(el, true, 0, 'E');

//change marble diameter
setMarbleDiameter(U(1));










#End
#BeginThumbnail




#End
