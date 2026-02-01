#Version 8
#BeginDescription
#Versions:
1.19 23.02.2023 HSB-18006: cleanup sill and jackUnderOpening when distance smaller then 38
1.18 10.10.2022 HSB-15462: Fix "ptCreatePackerAbT" needed for transformation of the transom
Date: 02.02.2022 - version 1.17
version 1.13: HSB-5535 add packer possibility for the gap between the bottom of opening and the bottom beam. Single beam is created only if all dHeightOne, dHeightTwo,.. are zero. Otherwise a packer is created
version 1.12: HSB-5535 fill gap between openning and header or transom and header with only one beam. fill gap between the opening and the bottom beam if gap < 38mm
Create packing (9mm Sheets)-default value- between the packer and the header if the distance is less than 40mm or between the opening and the header if there is no space for a transom.







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 19
#KeyWords Lintel,CCG,Transom,Packing
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
* ------------------------
*
* #Versions:
// 1.19 23.02.2023 HSB-18006: cleanup sill and jackUnderOpening when distance smaller then 38 Author: Marsel Nakuci
// 1.18 10.10.2022 HSB-15462: Fix "ptCreatePackerAbT" needed for transformation of the transom Author: Marsel Nakuci
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 10.11.2009
* version 1.0: Release Version
*
* date: 10.06.2010
* version 1.1: Remove a report notice
*
* date: 11.06.2010
* version 1.2: Remove the erase instance
*
* date: 11.08.2011
* version 1.3: Fix an issue and convert the packing beams to sheets
*
* date: 23.11.2011
* version 1.4: Fix issue removing jacks when the distance between transom and header was less than 9mm
*
* date: 19.12.2011
* version 1.5: Added option for creating beams or sheets into the one TSL.
*
* date: 31.10.2017
* Created by:  Mihai Bercuci
* version 1.7: Added option for creating 4 type of packing dimensions , and jack min height and refactor the way the packers are added

* date: 23.11.2017
* Created by:  Mihai Bercuci
* version 1.8: Fix the name and material bug for beam

* date: 05.09.2019
* Edited by:  Marsel Nakuci
* version 1.12: HSB-5535 fill gap between openning and header or transom and header with only one beam
*   			fill gap between the opening and the bottom beam if gap < 38mm

* date: 05.09.2019
* Edited by:  Marsel Nakuci
* version 1.13: HSB-5535 add packer possibility for the gap between the bottom of opening and the bottom beam. Single beam is created only if all dHeightOne, dHeightTwo,.. are zero. Otherwise a packer is created 
*/


_ThisInst.setSequenceNumber(-80);

Unit(1,"mm");
double dEps = U(.1);

PropString sName(0, "Name-1", T("|Packing- First Sheet /BeamName:|"));
PropString sMaterial(1, "Material-1", T("|Packing- First Sheet/Beam Material:|"));
PropDouble dHeightOne(0,U(9),T("|Enter the height of packer one:|"));

PropString sName2( 2, "Name-2", T("|Packing- Second Sheet Name:|"));
PropString sMaterial2( 3, "Material-2", T("|Packing- Second Sheet Material:|"));
PropDouble dHeightTwo(1, U(0), T("|Enter the height of packer two:|"));

PropString sName3( 4, "Name-3", T("|Packing- Third Sheet/Beam Name:|"));
PropString sMaterial3( 5, "Material-3", T("|Packing- Third Sheet/Beam Material:|"));
PropDouble dHeightThree(2, U(0), T("|Enter the height of packer three:|"));

PropString sName4(6, "Name-4", T("|Packing- Forth Sheet/Beam Name:|"));
PropString sMaterial4(7, "Material-4", T("|Packing- Forth Sheet Material:|"));
PropDouble dHeightFour(3, U(0), T("|Enter the height of packer four:|"));

PropString sName5(9, "Name-5", T("|Packing- Fifth Sheet/Beam Name:|"));
PropString sMaterial5(10, "Material-5", T("|Packing- Fifth Sheet Material:|"));
PropDouble dHeightFive(5, U(0), T("Enter the height of packer five:|"));

PropString sName6(11, "Name-6", T("|Packing- Sixth Sheet/Beam  Name:|"));
PropString sMaterial6(12, "Material-6", T("|Packing- Sixth Sheet Material:|"));
PropDouble dHeightSix(6,U(0),T("|Enter the height of packer six:|"));

PropDouble minJackLength(4,U(40),T("|Enter the minimum JackLength:|"));

String sObject[]={"Sheet","Beam"};
PropString sCreateObject(8,sObject,T("Select Packers Object"));

int nType = sObject.find(sCreateObject);

//double dBaseH = U(9);
//double dMaxH = U(38);
double dPackerH = dHeightOne;
double dPackerHTwo = dHeightTwo;
double dPackerHThree = dHeightThree;
double dPackerHFour = dHeightFour;
double dPackerHFive = dHeightFive;
double dPackerHSix = dHeightSix;


// HSB-5535
// if all are zero then dont create packer but crete single beam
// if at least one is nonzero then a packer is created
int iCreateSingleBeam = (dHeightOne == 0 && dHeightTwo == 0 && dHeightThree == 0 && dHeightFour == 0 && dHeightFive == 0 && dHeightSix == 0);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


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
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	String lstPropString[0];
	double lstPropDouble[0];
	lstPropString.append(sName);
	lstPropString.append(sMaterial);
	lstPropString.append(sName2);
	lstPropString.append(sMaterial2);
	lstPropString.append(sName3);
	lstPropString.append(sMaterial3);
	lstPropString.append(sName4);
	lstPropString.append(sMaterial4);
	lstPropString.append(sCreateObject);
	lstPropString.append(sName5);
	lstPropString.append(sMaterial5);
	lstPropString.append(sName6);
	lstPropString.append(sMaterial6);
	
	lstPropDouble.append(dHeightOne);
	lstPropDouble.append(dHeightTwo);
	lstPropDouble.append(dHeightThree);
	lstPropDouble.append(dHeightFour);
	lstPropDouble.append(minJackLength); 
	lstPropDouble.append(dHeightFive);
	lstPropDouble.append(dHeightSix);	
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	//_Element.append(getElement(T("Select an element")));
	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}

int nErase = false;

if(_Element.length() == 0)
{
	return;
}

if (_bOnElementConstructed )
{
	_Map.setInt("ExecutionMode",0);

}
int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}
//nExecutionMode = 0;//////////////
if (nExecutionMode == 0)
{
	
	Element el = _Element[0];
	
	CoordSys cs = el.coordSys();
	Vector3d vx = cs.vecX();
	Vector3d vy = cs.vecY();
	Vector3d vz = cs.vecZ();
	
	_Pt0 = el.ptOrg();
	
	//--------------------------------------------------------------------------------------------------------------------
	//                                                             collect packer and transom
	Beam arBm[0]; //declare an array of beams
	
	Beam bmAllTemp[] = el.beam();//get all beams
	
	if (bmAllTemp.length()<1)
	{ 
		return;
	}
	else
	{
		nErase = true;
	}
	
	Sheet shAllTemp[] = el.sheet();//get all sheets
	
	for (int i = 0; i < bmAllTemp.length(); i++)//loop all beams
	{
		if (bmAllTemp[i].myZoneIndex() == 0) //add all beams that dont belong to the element
			
		arBm.append(bmAllTemp[i]);
	}
	
	TslInst tslAll[] = el.tslInstAttached();
	for (int i = 0; i < tslAll.length(); i++)
	{
		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle())
		{
			tslAll[i].dbErase();
		}
	}
	
	Beam arBmPacker[0]; 	//declare arrays for specific beams
	Beam arBmTransom[0];	//declare arrays for specific beams
	Beam arBmHeader[0]; 	//declare arrays for specific beams
	String sModule;
	Beam bmJackOverOp[0]; //declare arrays for specific beams
// HSB-18006
	Beam bmJackUnderOp[0]; //declare arrays for specific beams
	Beam bmSill[0]; //declare arrays for specific beams
	for (int i = 0; i < arBm.length(); i++)
	{
		Beam bm = arBm[i];
		
		if (bm.type() == _kHeader) { //append all beams that are of _kHeader
			arBmHeader.append(bm); //add beams to arBmHeader ??
		}
		
		if (bm.type() == _kSFTransom) {
			arBmTransom.append(bm); //add beams to arBmTransom ??
		}
		if (bm.type() == _kSFJackOverOpening) {
			bmJackOverOp.append(bm); //add beams to bmJackOverOp ??
		}
		if (bm.type() == _kSFJackUnderOpening) {
			bmJackUnderOp.append(bm); //add beams to bmJackOverOp ??
		}
		if (bm.type() == _kSFPacker) {
			arBmPacker.append(bm); //add beams to packers list
		}
		if (bm.type() == _kSill) {
			bmSill.append(bm); //add beams to packers list
		}
	}
	
	Sheet arShPacker[0]; 	//declare arrays for specific sheets
	for (int i = 0; i < shAllTemp.length(); i++)
	{
		Sheet sh = shAllTemp[i];
		
		if (sh.type() == _kSFPacker) {
			arShPacker.append(sh); //add sheets to packers list
		}
	}
	
	//--------------------------------------------------------------------------------------------------------------------
	//                                                collect all openings and calculate packer height
	
	Plane plnZ(el.ptOrg(), vz); //define plane
	//el.ptOrg().vis(8);
	double dElVecZ = el.zone(0).dH(); //get the dh from the zone 0 of the element
	
	Opening arOp[] = el.opening();//get all openings
	
	for (int i = 0; i < arOp.length(); i++)
	{
		//loop all openings
		Opening op = arOp[i];
		Body bdOp(op.plShape(), el.vecZ() * dElVecZ, 0); //define the body of the openning ( not sure what plShape() do)
		Point3d ptOpCen = bdOp.ptCen();//get the center of the opening body
		ptOpCen = plnZ.closestPointTo(ptOpCen);
		
		// point at the bottom of top header
		Point3d ptBaseHeader;
		int nBaseHeaderFound;
		// point at the top of the bottom beam
		Point3d ptTopBottomBeam;
		// point at top of transom beam
		Point3d ptTopTransom = bdOp.ptCen(); //same as ptOpCen
		ptOpCen.vis(5);
		bdOp.vis(3);
		
		double dOpW = op.width(); //oppening width
		
		OpeningSF opSF = (OpeningSF) op; //stick frame give more
		double dGapT = opSF.dGapTop(); //? ?? ?
		double dGapB = opSF.dGapBottom();
		dOpW = dOpW + opSF.dGapSide() * 2;//? ??
		double dTransom=0;
		double dPackerL;
		int nColor = 32;
		
		Beam bmThisTransom;
		
		for (int j = 0; j < arBmTransom.length(); j++) { //loop all arBmTransom
			Beam bm = arBmTransom[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) { //? ?? ? ?
				dTransom = bm.dD(el.vecY()); //most aligned vector in the direction vecY
				ptTopTransom = bm.ptCen() + vy * (bm.dD(vy) * 0.5);//? ??
				dPackerL = bm.dL(); //dimension in vecX direction
				sModule = bm.module(); //? ?? ? ?? ?
				j = arBmTransom.length();//
				bmThisTransom = bm;
			}
		}
		for (int j = 0; j < arBmHeader.length(); j++) {
			Beam bm = arBmHeader[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) {
				ptBaseHeader = bm.ptCen() - vy * bm.dD(vy) * 0.5;
				ptBaseHeader.vis(3);
				nBaseHeaderFound=true;
				sModule = bm.module();
				nColor = bm.color();
				j = arBmHeader.length();
			}
		}
		// get the top point of the bottom plate
		{ 
			Beam bmBottom;
			// all beams in the element
			Beam beams[0];
			beams = bmAllTemp;
			// filter the horizontal beams, remove vertical beams
			Beam beamsHor[0];
			for (int ii = 0; ii < beams.length(); ii++)
			{ 
				Beam bm = beams[ii];
				if (abs(bm.vecX().dotProduct(el.vecX())) < dEps)
				{ 
					// beam bm normal with vecX-> vertical beam
					continue;
				}
				// not a vertical beam, append it to beamsHor
				beamsHor.append(bm);
			}//next ii
			// get the bottom beam
			// ptOpCen is at the center of the width
			Beam beamsHorBott[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor,ptOpCen-vz*U(3), - el.vecY());
			if (beamsHorBott.length() < 1)
			{ 
				// no bottom beam
				reportMessage(TN("|unexpected error, no bottom beam found|"));
				eraseInstance();
				return;
			}
			bmBottom = beamsHorBott[beamsHorBott.length() - 1];
			bmBottom.envelopeBody().vis(6);
			// poit at the top of bottom beam
			ptTopBottomBeam = bmBottom.ptCen() + vy * bmBottom.dD(vy) * .5;
			ptTopBottomBeam.vis(7);
		}
		
		int packerLength = arBmPacker.length();
		
		for (int j = 0; j < arBmPacker.length(); j++) {
			Beam bm = arBmPacker[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) {
				j = arBmPacker.length();
			}
		}
		Beam bmJacksThisOp[0];
		for (int j = 0; j < bmJackOverOp.length(); j++) {
			Beam bm = bmJackOverOp[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) {
				bmJacksThisOp.append(bm);
			}
		}
	// HSB-18006
		Beam bmJacksUnderThisOp[0];
		for (int j = 0; j < bmJackUnderOp.length(); j++) {
			Beam bm = bmJackUnderOp[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) {
				bmJacksUnderThisOp.append(bm);
			}
		}
		Beam bmSillThisOp[0];
		for (int j = 0; j < bmSill.length(); j++) {
			Beam bm = bmSill[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) {
				bmSillThisOp.append(bm);
			}
		}
		
		//Point3d ptTopOp = ptOpCen + el.vecY() * (0.5 * op.height() + dGapT + dTransom) + el.vecZ() * el.vecZ().dotProduct(el.ptOrg() - ptOpCen);
		//define the ptTopOp, top point of openning
		Point3d ptTopOp = ptOpCen + vy * (0.5 * op.height() + dGapT) + vz * vz.dotProduct(el.ptOrg() - ptOpCen);
		ptTopOp.vis(4);
		// define the ptBottomOp, bottom point of openning
		Point3d ptBottomOp = ptOpCen - vy * (.5 * op.height() + dGapB) + vz * vz.dotProduct(el.ptOrg() - ptOpCen);
		ptBottomOp.vis(4);
		
		
		//if(dPackerH > dMaxH)return;
		
		//--------------------------------------------------------------------------------------------------------------
		//                                                          remove packer
		for (int j = 0; j < arBmPacker.length(); j++)
		{
			Beam bm = arBmPacker[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) //? ?
			{
				bm.dbErase();
			}
		}
		
		for (int j = 0; j < arShPacker.length(); j++)
		{
			Sheet sh = arShPacker[j];
			if ( abs(el.vecX().dotProduct(ptOpCen - sh.ptCen())) < 0.5 * dOpW ) //? ?
			{
				sh.dbErase();
			}
		}
		
		if (dTransom < 1)
		{
			dTransom = el.dBeamHeight();
		}
		// if no trasom beam at this opening, then the ptTopTransom is the ptOpCen
		//ptTopTransom.vis();
		//--------------------------------------------------------------------------------------------------------------
		//                                                       create new packers
		// distance from base of header to the top of the opening
		double dDist = abs(vy.dotProduct(ptBaseHeader - ptTopOp));//? ??
		// distance from transom to the base of header
		double dDistAboveTransom = abs(vy.dotProduct(ptBaseHeader - ptTopTransom));//? ?
		// distance from bottom of openning to the bottom plate
		double dDistBelowOppening = vy.dotProduct(ptBottomOp - ptTopBottomBeam);

		//reportNotice("\n distance" + dDistBelowOppening);

		// reference point for packer between header and openning
		Point3d ptCreatePacker = ptBaseHeader;//? ?
		ptCreatePacker = plnZ.closestPointTo(ptCreatePacker);//? ?
		// reference point for packer between transom and header (above transome)
		Point3d ptCreatePackerAbT = plnZ.closestPointTo(ptBaseHeader);//? ?ptTopTransom
		ptCreatePackerAbT.vis(1);
		// reference point for packer between openning and bottom plate (BelowOpenning)
		Point3d ptCreatePackerBeOp = plnZ.closestPointTo(ptBottomOp);
		
		
		int nRemoveJacks = FALSE;
		int nRemoveSillAndJackUnderOpening=false;
		// find the smallest packer////////////////////////////////////////////////////////////
		///////////////////////////////////
		double packerList[] = { dPackerH, dPackerHTwo, dPackerHThree, dPackerHFour, dPackerHFive, dPackerHSix };
		double smallestPacker = 999999;
		for (int i = 0; i < packerList.length(); i++) {
			
			if (packerList[i] > 0) {
				if (packerList[i] < smallestPacker)
				{
					smallestPacker = packerList[i];
				}
			}
		}
		/////////////////////////////////////////////////////////////////////
		
		//sort the packer array
		///////////////////////////////////////////////////////////////////
		int temp = 0;
		
		for (int write = 0; write < packerList.length(); write++)
		{
			for (int sort = 0; sort < packerList.length() - 1; sort++)
			{
				if (packerList[sort] > packerList[sort + 1])
				{
					temp = packerList[sort + 1];
					packerList[sort + 1] = packerList[sort];
					packerList[sort] = temp;
				}
			}
		}
		/////////////////////////////////////////////////////////////////////////////////////////		
		////////////////////////////////////////////////////////////////////////////////////////
		//find the best combination that match the length
		double packerNeeded[0];
		int count = 0;
		
		double openingDistance = dDist;
		if (dDistAboveTransom <= dTransom)
		{
			openingDistance = dDistAboveTransom;//opening distance should be calculate between transom
		}
		//check we have transom
		//reportNotice("\n" +"dTransom: "+ dTransom);
		//reportNotice("\n" +"dDistAboveTransom: "+ dDistAboveTransom);
		//reportNotice("\n" +" packerList.length: "+ packerList.length() );
		
		for (int i = packerList.length() - 1; i >= 0; i--)
		{
			//reportNotice("\n" +" packers by numbers:"+ packerList[i] );
			//reportNotice("\n" +" opening distance:"+ openingDistance );
			double currentPacker = packerList[i];
			double openingCheck = openingDistance;
			if (openingCheck >= (currentPacker - U(0.01)) && currentPacker > 0) {
				
				packerNeeded.append(packerList[i]);
				openingDistance = openingCheck - currentPacker;
				count++;
				i++;
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		
		if (dDist+U(1)<dTransom && nBaseHeaderFound)//
		{
			// this option creates packer between the top opening and the header
			for (int j = 0; j < arBmTransom.length(); j++)
			{
				Beam bm = arBmTransom[j];
				if ( abs(el.vecX().dotProduct(ptOpCen - bm.ptCen())) < 0.5 * dOpW ) {
					bm.dbErase();
				}
			}
			
			if (iCreateSingleBeam)
			{ 
				// height of Packer 1 is set to 0
				// this mean only one beam is drawn
				if (nType == 0)
				{ 
					// sheets
					Sheet bmNew;
					bmNew.dbCreate(ptCreatePacker, el.vecX(), el.vecZ(), - el.vecY(), dOpW, dElVecZ, dDist, 0, - 1, 1);
					bmNew.setModule(sModule);
					bmNew.setName(sName);
					bmNew.setMaterial(sMaterial);
					
					bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
					ptCreatePacker = ptCreatePacker - el.vecY() * dDist;
					bmNew.setColor(nColor);
					bmNew.setType(_kSFPacker);
					bmNew.realBody().vis(i);
					
				}
				else
				{
					// beams
					Beam bmNew;
					bmNew.dbCreate(ptCreatePacker, el.vecX(), el.vecY(), el.vecZ(), dOpW, dDist, dElVecZ, 0, -1, - 1);
					bmNew.setModule(sModule);
					bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
					ptCreatePackerAbT = ptCreatePacker - el.vecY() * dDist;
					bmNew.setColor(nColor);
					bmNew.setType(_kSFPacker);
				}
			}
			else
			{
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				if (dDist < smallestPacker)//No Packer , the gap is smaller then the smallest packer
				{
					//jump
					//this should only be applied if !iCreateSingleBeam
				}
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				else if (dDist > smallestPacker)
				{
					// apply packers
					if (nType == 0)
					{
						for (int i = 0; i < packerNeeded.length(); i++)
						{
							Sheet bmNew;
							bmNew.dbCreate(ptCreatePacker, el.vecX(), el.vecZ(), - el.vecY(), dOpW, dElVecZ, packerNeeded[i], 0, - 1, 1);
							bmNew.setModule(sModule);
							if (packerNeeded[i] == dPackerH)
							{
								bmNew.setName(sName);
								bmNew.setMaterial(sMaterial);
							}
							else if (packerNeeded[i] == dPackerHTwo)
							{
								bmNew.setName(sName2);
								bmNew.setMaterial(sMaterial2);
							}
							else if (packerNeeded[i] == dPackerHThree)
							{
								bmNew.setName(sName3);
								bmNew.setMaterial(sMaterial3);
							}
							else if (packerNeeded[i] == dPackerHFour)
							{
								bmNew.setName(sName4);
								bmNew.setMaterial(sMaterial4);
							}
							else if (packerNeeded[i] == dPackerHFive)
							{
								bmNew.setName(sName5);
								bmNew.setMaterial(sMaterial5);
							}
							else if (packerNeeded[i] == dPackerHSix)
							{
								bmNew.setName(sName6);
								bmNew.setMaterial(sMaterial6);
							}
							
							bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
							ptCreatePacker = ptCreatePacker - el.vecY() * packerNeeded[i];
							bmNew.setColor(nColor);
							bmNew.setType(_kSFPacker);
							bmNew.realBody().vis(i);
						}
					}
					else
					{
						for (int i = 0; i < packerNeeded.length(); i++)
						{
							Beam bmNew;
							bmNew.dbCreate(ptCreatePacker, el.vecX(), el.vecY(), el.vecZ(), dOpW, packerNeeded[i], dElVecZ, 0, - 1, - 1);
							if (packerNeeded[i] == dPackerH)
							{
								bmNew.setName(sName);
								bmNew.setMaterial(sMaterial);
							}
							else if (packerNeeded[i] == dPackerHTwo)
							{
								bmNew.setName(sName2);
								bmNew.setMaterial(sMaterial2);
							}
							else if (packerNeeded[i] == dPackerHThree)
							{
								bmNew.setName(sName3);
								bmNew.setMaterial(sMaterial3);
							}
							else if (packerNeeded[i] == dPackerHFour)
							{
								bmNew.setName(sName4);
								bmNew.setMaterial(sMaterial4);
							}
							else if (packerNeeded[i] == dPackerHFive)
							{
								bmNew.setName(sName5);
								bmNew.setMaterial(sMaterial5);
							}
							else if (packerNeeded[i] == dPackerHSix)
							{
								bmNew.setName(sName6);
								bmNew.setMaterial(sMaterial6);
							}
							bmNew.setModule(sModule);
							bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
							ptCreatePacker = ptCreatePacker - el.vecY() * packerNeeded[i];
							bmNew.setColor(nColor);
							bmNew.setType(_kSFPacker);
							bmNew.realBody().vis(i);
						}
					}
				}
			}
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if (dDistAboveTransom<=dTransom && nBaseHeaderFound) //This Option Create the Packer between the Tansom and the Header
		{
			// always create one beam
			if (iCreateSingleBeam)
			{ 
				// height of Packer 1 is set to 0
				// this mean only one beam is drawn
				if (dDistAboveTransom > dEps)
				{
					nRemoveJacks = TRUE;
					if (nType == 0)
					{ 
						// sheets
						Sheet bmNew;
						ptCreatePackerAbT.vis(1);
						bmNew.dbCreate(ptCreatePackerAbT-vy*dDistAboveTransom, el.vecX(), el.vecZ(), - el.vecY(), dOpW, dElVecZ, dDistAboveTransom, 0, - 1, - 1);
						bmNew.setModule(sModule);
						bmNew.setMaterial(sMaterial);
						bmNew.setName(sName);
						bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
//						ptCreatePackerAbT=ptCreatePackerAbT+el.vecY()*dDistAboveTransom;
						ptCreatePackerAbT=ptCreatePackerAbT-vy*dDistAboveTransom;
						bmNew.setColor(nColor);
						bmNew.setType(_kSFPacker);
					}
					else
					{ 
						// beams
						Beam bmNew;
						bmNew.dbCreate(ptCreatePackerAbT-vy*dDistAboveTransom, el.vecX(), el.vecY(), el.vecZ(), dOpW, dDistAboveTransom, dElVecZ, 0, 1, -1);
						bmNew.setModule(sModule);
						bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
//						ptCreatePackerAbT=ptCreatePackerAbT+el.vecY()*dDistAboveTransom;
						ptCreatePackerAbT=ptCreatePackerAbT-vy*dDistAboveTransom;
						bmNew.setColor(nColor);
						bmNew.setType(_kSFPacker);
					}
				}
			}
			else
			{ 
				// height of packer 1 is defined, apply packers 
			
				if (dDistAboveTransom < smallestPacker)//No Packer
				{
					nRemoveJacks = TRUE;
				}
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				else if (dDistAboveTransom >= smallestPacker)//1 Pack
				{
					nRemoveJacks = TRUE;
					if (nType == 0)
					{
						// sheets
						
						for (int i = 0; i < packerNeeded.length(); i++)
						{
							Sheet bmNew;
							bmNew.dbCreate(ptCreatePackerAbT-vy*packerNeeded[i], el.vecX(), el.vecZ(), - el.vecY(), dOpW, dElVecZ, packerNeeded[i], 0, - 1, - 1);
							bmNew.setModule(sModule);
							if (packerNeeded[i] == dPackerH)
							{
								bmNew.setName(sName);
								bmNew.setMaterial(sMaterial);
							}
							else if (packerNeeded[i] == dPackerHTwo)
							{
								bmNew.setName(sName2);
								bmNew.setMaterial(sMaterial2);
							}
							else if (packerNeeded[i] == dPackerHThree)
							{
								bmNew.setName(sName3);
								bmNew.setMaterial(sMaterial3);
							}
							else if (packerNeeded[i] == dPackerHFour)
							{
								bmNew.setName(sName4);
								bmNew.setMaterial(sMaterial4);
							}
							else if (packerNeeded[i] == dPackerHFive)
							{
								bmNew.setName(sName5);
								bmNew.setMaterial(sMaterial5);
							}
							else if (packerNeeded[i] == dPackerHSix)
							{
								bmNew.setName(sName6);
								bmNew.setMaterial(sMaterial6);
							}
							bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
							ptCreatePackerAbT = ptCreatePackerAbT - el.vecY() * packerNeeded[i];
							bmNew.setColor(nColor);
							bmNew.setType(_kSFPacker);
							bmNew.realBody().vis(i);
						}
					}
					else
					{
						for (int i = 0; i < packerNeeded.length(); i++)
						{
							Beam bmNew;
							bmNew.dbCreate(ptCreatePackerAbT-vy*packerNeeded[i], el.vecX(), el.vecY(), el.vecZ(), dOpW, packerNeeded[i], dElVecZ, 0, 1, - 1);
							if (packerNeeded[i] == dPackerH)
							{
								bmNew.setName(sName);
								bmNew.setMaterial(sMaterial);
							}
							else if (packerNeeded[i] == dPackerHTwo)
							{
								bmNew.setName(sName2);
								bmNew.setMaterial(sMaterial2);
							}
							else if (packerNeeded[i] == dPackerHThree)
							{
								bmNew.setName(sName3);
								bmNew.setMaterial(sMaterial3);
							}
							else if (packerNeeded[i] == dPackerHFour)
							{
								bmNew.setName(sName4);
								bmNew.setMaterial(sMaterial4);
							}
							else if (packerNeeded[i] == dPackerHFive)
							{
								bmNew.setName(sName5);
								bmNew.setMaterial(sMaterial5);
							}
							else if (packerNeeded[i] == dPackerHSix)
							{
								bmNew.setName(sName6);
								bmNew.setMaterial(sMaterial6);
							}
							bmNew.setModule(sModule);
							bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
							ptCreatePackerAbT = ptCreatePackerAbT - el.vecY() * packerNeeded[i];
							bmNew.setColor(nColor);
							bmNew.setType(_kSFPacker);
							bmNew.realBody().vis(i);
						}
					}
				}
				else if (dDistAboveTransom < minJackLength && dTransom < minJackLength)//Copy Transom
				{
					nRemoveJacks = TRUE;
					Beam bmNew;
					bmNew.dbCreate(ptCreatePackerAbT-vy*dTransom, el.vecX(), el.vecY(), el.vecZ(), dOpW, dTransom, dElVecZ, 0, 1, - 1);
					ptCreatePackerAbT=ptCreatePackerAbT-el.vecY()*dTransom;
					bmNew.setModule(sModule);
					bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
					bmNew.setColor(nColor);
					bmNew.setType(_kSFTransom);
					
				}
			}
			
			ptCreatePackerAbT.vis(1);
			ptTopTransom.vis(2);
			
			//Move Transom
			if (vy.dotProduct(ptCreatePackerAbT-ptTopTransom)>dEps)
			{ 
				if (bmThisTransom.bIsValid())
				{ 
					bmThisTransom.transformBy(vy * abs(vy.dotProduct(ptCreatePackerAbT-ptTopTransom)));
				}
			}
		}
		
		if (dDistBelowOppening < U(38) && dDistBelowOppening > dEps)
		{ 
			//reportNotice("\n distance" + dDistBelowOppening);
			// this option creates packer between the bottom of the openning and the bottom beam
			if (iCreateSingleBeam)
			{ 
				// height of Packer 1 is set to 0
				// this mean only one beam is drawn
				if (nType == 0)
				{ 
					// sheets
					Sheet bmNew;
					bmNew.dbCreate(ptCreatePackerBeOp, el.vecX(), el.vecZ(), - el.vecY(), dOpW, dElVecZ, dDistBelowOppening, 0, - 1, 1);
					bmNew.setModule(sModule);
					bmNew.setMaterial(sMaterial);
					bmNew.setName(sName);
					bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
	//				ptCreatePackerAbT = ptCreatePackerAbT + el.vecY() * dPackerH;
	//				ptCreatePackerAbT = ptCreatePackerAbT + el.vecY() * dDistBelowOppening;
					bmNew.setColor(nColor);
					bmNew.setType(_kSFPacker);
				}
				else
				{ 
					// beams
					Beam bmNew;
					ptCreatePackerBeOp.vis(1);
					bmNew.dbCreate(ptCreatePackerBeOp, el.vecX(), el.vecY(), el.vecZ(), dOpW, dDistBelowOppening, dElVecZ, 0, -1, - 1);
					bmNew.setModule(sModule);
					bmNew.setMaterial(sMaterial);
					bmNew.setName(sName);
					bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
					bmNew.envelopeBody().vis(2);
	//				ptCreatePackerAbT = ptCreatePackerAbT + el.vecY() * dDistAboveTransom;
					bmNew.setColor(nColor);
					bmNew.setType(_kSFPacker);
				}
			}
			else
			{ 
				// find the packerNeeded array
				{ 
					packerNeeded.setLength(0);
					double openingDistance = dDistBelowOppening;
					for (int ii = packerList.length() - 1; ii >= 0; ii--)
					{ 
						double currentPacker = packerList[ii];
						double openingCheck = openingDistance;
						if (openingCheck >= (currentPacker - U(0.01)) && currentPacker > 0)
						{ 
							packerNeeded.append(packerList[ii]);
							openingDistance = openingCheck - currentPacker;
							ii++;
						}
						
					}//next ii
				}
				if (dDistBelowOppening < smallestPacker)//No Packer , the gap is smaller then the smallest packer
				{
					//jump
					//this should only be applied if !iCreateSingleBeam
					
				}
				else if(dDistBelowOppening > smallestPacker)
				{ 
					if (nType == 0)
					{ 
						// sheets
						// place at the top of the most bottom beam of the packer
						ptCreatePackerBeOp += -el.vecY() * dDistBelowOppening + packerNeeded[0] * el.vecY();
						for (int ii = 0; ii < packerNeeded.length(); ii++)
						{ 
							ptCreatePackerBeOp.vis(8);
							Sheet bmNew;
							bmNew.dbCreate(ptCreatePackerBeOp, el.vecX(), el.vecZ(), - el.vecY(), dOpW, dElVecZ, packerNeeded[ii], 0, - 1, 1);
							bmNew.setModule(sModule);
							if (packerNeeded[ii] == dPackerH)
							{
								bmNew.setName(sName);
								bmNew.setMaterial(sMaterial);
							}
							else if (packerNeeded[ii] == dPackerHTwo)
							{
								bmNew.setName(sName2);
								bmNew.setMaterial(sMaterial2);
							}
							else if (packerNeeded[ii] == dPackerHThree)
							{
								bmNew.setName(sName3);
								bmNew.setMaterial(sMaterial3);
							}
							else if (packerNeeded[ii] == dPackerHFour)
							{
								bmNew.setName(sName4);
								bmNew.setMaterial(sMaterial4);
							}
							else if (packerNeeded[ii] == dPackerHFive)
							{
								bmNew.setName(sName5);
								bmNew.setMaterial(sMaterial5);
							}
							else if (packerNeeded[ii] == dPackerHSix)
							{
								bmNew.setName(sName6);
								bmNew.setMaterial(sMaterial6);
							}
							bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
							ptCreatePackerBeOp += el.vecY() * packerNeeded[ii];
							bmNew.setColor(nColor);
							bmNew.setType(_kSFPacker); 
							 
						}//next ii
					}
					else
					{ 
						// beams
						// place at the top of the most bottom beam of the packer
						ptCreatePackerBeOp += -el.vecY() * dDistBelowOppening + packerNeeded[0] * el.vecY();
						for (int ii = 0; ii < packerNeeded.length(); ii++)
						{ 
							// beams
							Beam bmNew;
							bmNew.dbCreate(ptCreatePackerBeOp, el.vecX(), el.vecY(), el.vecZ(), dOpW, packerNeeded[ii], dElVecZ, 0, -1, - 1);
							bmNew.setModule(sModule);
							if (packerNeeded[ii] == dPackerH)
							{
								bmNew.setName(sName);
								bmNew.setMaterial(sMaterial);
							}
							else if (packerNeeded[ii] == dPackerHTwo)
							{
								bmNew.setName(sName2);
								bmNew.setMaterial(sMaterial2);
							}
							else if (packerNeeded[ii] == dPackerHThree)
							{
								bmNew.setName(sName3);
								bmNew.setMaterial(sMaterial3);
							}
							else if (packerNeeded[ii] == dPackerHFour)
							{
								bmNew.setName(sName4);
								bmNew.setMaterial(sMaterial4);
							}
							else if (packerNeeded[ii] == dPackerHFive)
							{
								bmNew.setName(sName5);
								bmNew.setMaterial(sMaterial5);
							}
							else if (packerNeeded[ii] == dPackerHSix)
							{
								bmNew.setName(sName6);
								bmNew.setMaterial(sMaterial6);
							}
							
							bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
							bmNew.envelopeBody().vis(2);
							ptCreatePackerBeOp += el.vecY() * packerNeeded[ii];
							bmNew.setColor(nColor);
							bmNew.setType(_kSFPacker); 
						}//next ii
					}
				}
			}
			
		// HSB-18006: if found cleanup sill and jackunder opening
			nRemoveSillAndJackUnderOpening = true;
		}
		if (nRemoveJacks)
		{
			for (int j = 0; j < bmJacksThisOp.length(); j++)
			{
				Beam bm = bmJacksThisOp[j];
				bm.dbErase();
			}
		}
	// HSB-18006: cleanup sills and jack under openings
		if (nRemoveSillAndJackUnderOpening)
		{
			for (int j = 0; j < bmJacksUnderThisOp.length(); j++)
			{
				Beam bm = bmJacksUnderThisOp[j];
				bm.dbErase();
			}
			for (int j = 0; j < bmSillThisOp.length(); j++)
			{
				Beam bm = bmSillThisOp[j];
				bm.dbErase();
			}
		}
		//reportNotice("\nyes"+ op.handle());
	}
	
	
	_ThisInst.assignToElementGroup(el, TRUE, 0, 'T');
	_Map.setInt("ExecutionMode", 1);

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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18006: cleanup sill and jackUnderOpening when distance smaller then 38" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="2/23/2023 6:08:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15462: Fix &quot;ptCreatePackerAbT&quot; needed for transformation of the transom" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="10/10/2022 10:47:54 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End