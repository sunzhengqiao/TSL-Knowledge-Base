#Version 8
#BeginDescription
#Versions:
1.17 02.11.2022 HSB-16838: Use plane profiles from ExtrProfile instead of realBody
Modified by: Alberto Jena
Date: 08.09.2021  -  version 1.16


This tsl places nails in the studs/Joist. This is the master tsl. It inserts a satelite tsl for each nailing position. This nailing position is outputted to the dxa file with a specific index. Depending on the index there might be more than one nail applied.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 17
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
*  hsbSOFT 
*  UK
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
* #Versions:
// 1.17 02.11.2022 HSB-16838: Use plane profiles from ExtrProfile instead of realBody Author: Marsel Nakuci
*
* Created by: Chirag Sawjani ((csawjani@itw-industry.com)
* date: 15.03.2012
* version 1.0: Release Version
*
* date: 22.05.2012
* version 1.1: Bugfix with the floor trimmers benn nail
*
* date: 24.05.2012
* version 1.2: Reduced size of planeprofile around opening when finding module stud and added opening array for finding the relevant module
*
* date: 28.05.2012
* version 1.3: Added check for nails on headers (without jacks) or brace so that no double nail hits the right nail if it happens to be = centres.  Fixed points on spandrels
*
* date: 29.05.2012
* version 1.4: Removed nailing for the brace when there are no jacks and added sill to opening array
*
* date: 07.08.2012
* version 1.5: L Studs with flat on the right side sending a flag to the slave so it can calculate the reference from the right face-beam width
*
* date: 16.10.2012
* version 1.6: Fixed nailing to angle top plates
*
* date: 10.01.2013
* version 1.8: Pushed LOppStud determination to slave
*
* Modified by: Bruno Bortot ((bruno.bortot@hsbcad.com)
* date: 23.02.2017
* version 1.9: Removed no nailing beams from array
*
* date: 26.07.2020
* version 1.11: Fix issue when the header splits the top plate and doesnt need fixing.
*
* date: 26.07.2020
* version 1.13: Made changes on the way that the beams were found to the perpendicullar in floors so the 
* 				TSL doesnt fail when the floor is off by a couple milimiter from top to bottom (not completely rectangular)
*/


//Script uses mm
Unit (1,"mm");
double dEps =U(.1);


_ThisInst.setSequenceNumber(51);
//String sArLayer [] = { T("I-Layer"), T("J-Layer"), T("T-Layer"), T("Z-Layer")};
//PropString sLayer (0, sArLayer, T("|Layer|"));

String sViewDirection[]={T("|Outside|"),T("|Inside|")};
PropString psViewDirection(0,sViewDirection,T("|View Direction|"));
int nViewDirection=sViewDirection.find(psViewDirection,0);

PropDouble dIndex0(0, 20, "Index 1 Position");

PropDouble dIndex1(1, 0, "Index 2 Position");

PropDouble dIndex2(2, 60, "Index 3 Position");

PropDouble dIndex3(3, 100, "Index 4 Position");

PropDouble dHeadBraceSpacing(4, 600, "Header/Brace Nail Spacing");


if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

//Insert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();
	
	//Select a set of walls
	PrEntity ssE(T("Select one, or more elements"), Element());
	if( ssE.go() ){
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
	
	lstPropString.append(psViewDirection);
	
	lstPropDouble.append(dIndex0);
	lstPropDouble.append(dIndex1);
	lstPropDouble.append(dIndex2);
	lstPropDouble.append(dIndex3);
	lstPropDouble.append(dHeadBraceSpacing);
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);
	
	for( int e=0; e<_Element.length(); e++ )
	{
		lstElements.setLength(0);
		lstElements.append(_Element[e]);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	eraseInstance();
	return;
}

//Check element
if(_Element.length()==0 ) //|| _bOnElementDeleted
{
	eraseInstance();
	return;
}

//Add custom command to reaply frame nails
String strChangeEntity = T("Reapply Frame Nails");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	_Map.setInt("ExecutionMode",0);
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

//Find top and bottom plates
int arBmTopPlate[0];
arBmTopPlate.append(_kSFTopPlate);
arBmTopPlate.append(_kTopPlate);
arBmTopPlate.append(_kSFAngledTPLeft);
arBmTopPlate.append(_kSFAngledTPRight);

//General tsl settings
//Name of frame nail tsl
String strScriptName = "hsb_FrameNail"; // name of the script that is inserted by this tsl.
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Entity lstEnts[0];
Beam lstBeams[0];
Point3d lstPoints[0];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];


//Get element
Element elt = _Element[0];

//CoordSys
CoordSys csEl = elt.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = elt.vecX();
Vector3d vyEl = elt.vecY();
Vector3d vzEl = elt.vecZ();

//This vectors are to make the floor beams more tolerant to be at a small angle
Vector3d vNewX=vxEl;
Vector3d vNewY=vyEl;

PLine plEnv=elt.plEnvelope();
Point3d ptVertex[]=plEnv.vertexPoints(true);
Point3d ptCenEl;
ptCenEl.setToAverage(ptVertex);


//Origin point 
_Pt0 = ptEl;

TslInst tslAll[]=elt.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		tslAll[i].dbErase();
		
	}
}

//Element timber widths
double dBeamW=elt.dBeamHeight();
double dBeamH=elt.dBeamWidth();
if(dBeamW>dBeamH)
{
	double dBeamTemp=dBeamH;
	dBeamW=dBeamH;
	dBeamH=dBeamTemp;
}

Plane pln (ptEl , vzEl);

//if (nExecutionMode==0)
{
	ElementWallSF el=(ElementWallSF) elt;
	int nWall=false;
	
	if (el.bIsValid())
	{
		nWall=true;
	}
	
	//Alter the vectors and points of reference depending on the view direction
	Point3d ptElementBase;
	Vector3d vecOutward;
	if(nViewDirection==0)
	{
		ptElementBase=ptEl-vzEl*dBeamH;
		vecOutward=vzEl;
	}
	else if(nViewDirection==1)
	{
		ptElementBase=ptEl;
		vecOutward=-vzEl;
	}
	ptElementBase.vis(1);
	//Erase existing frame nail tsl's
	TslInst arTsl[] = el.tslInst();
	for(int i=0;i<arTsl.length();i++){
		TslInst tsl = arTsl[i];
		if(!tsl.bIsValid()) continue;
		if( tsl.scriptName() == strScriptName ){
			tsl.dbErase();
		}
	}
	
	//Get only beams belonging to zone 0
	GenBeam genBm[]=el.genBeam(0);
	Beam arBm1[0];
	for(int g=0;g<genBm.length();g++)
	{
		Beam bm=(Beam)genBm[g];
		if(bm.bIsValid()) arBm1.append(bm);
		
	}
	
	//Beam arBm[]= NailLine().removeGenBeamsWithNoNailingBeamCode(arBm1);
	Beam arBm[0];
	arBm.append(arBm1);	
	
	Beam bmFiltered[0];
	Beam bmVertical[0];
	Beam bmTopPlate[0];
	Beam bmBottomPlate[0];
	Beam bmHeader[0];
	Beam bmJacks[0];
	Beam bmBrace[0];
//	Beam bmJackOverOpening[0];
//	Beam bmJackUnderOpening[0];
	Beam bmOpenings[0];
	Beam bmCripple[0];
	
	Beam bmFloorJoist[0];

	if (nWall)
	{
		for(int i=0;i<arBm.length();i++)
		{
			Beam bm = arBm[i];
	
			if( arBmTopPlate.find(bm.type(), -1) != -1 )
			{
				bmTopPlate.append(bm);
			}
			else if( bm.type() ==_kSFBottomPlate)
			{
				bmBottomPlate.append(bm);
			}
			else if( bm.type() ==_kHeader || bm.type() ==_kSFPacker)
			{
				bmHeader.append(bm);
				bmOpenings.append(bm);
			}
			else if( bm.type() == _kSFJackOverOpening || bm.type()== _kSFJackUnderOpening)
			{				
				bmJacks.append(bm);
				bmOpenings.append(bm);
			}
			else if( bm.type() == _kSFSupportingBeam )
			{					
				bmCripple.append(bm);
				bmOpenings.append(bm);				
			}
			else if(bm.type()==_kBrace)
			{		
				bmBrace.append(bm);
				bmOpenings.append(bm);				
			}
			else if(bm.type()==_kSFTransom || bm.type()==_kSill)
			{
				bmOpenings.append(bm);
			}
			else if(bm.type()==_kKingStud)
			{
				bmOpenings.append(bm);				
				//Also add it to filtered list as they are not to be considered as part of the frame nailing for openings
				bmFiltered.append(bm);
			}
			else
			{
				//All other beams
				bmFiltered.append(bm);
			}
		}
	}
	else //Floors
	{
		//Beam bmVer[]=vxEl.filterBeamsPerpendicularSort(arBm);
		//Beam bmHor[]=vyEl.filterBeamsPerpendicularSort(arBm);
		Beam bmVer[0];
		Beam bmHor[0];
		for(int i=0; i<arBm.length(); i++)
		{ 
			arBm[i].vecX().vis(arBm[i].ptCen());
			if (abs(vxEl.dotProduct(arBm[i].vecX()))>0.97)
			{ 
				bmHor.append(arBm[i]);
			} 
			else if (abs(vyEl.dotProduct(arBm[i].vecX()))>0.97)
			{ 
				bmVer.append(arBm[i]);
			}
		}

		//Sort the beams
		for (int i = 0; i < bmHor.length() - 1; i++)
		{
			for (int j = i + 1; j < bmHor.length(); j++)
			{
				if (vyEl.dotProduct(bmHor[i].ptCen() - ptElementBase) > vyEl.dotProduct(bmHor[j].ptCen() - ptElementBase))
				bmHor.swap(i, j);
			}
		}
//		for (int i = 0; i < bmHor.length(); i++)
//		{
//			bmHor[i].realBody().vis(i);
//		}
	
		for (int i = 0; i < bmVer.length() - 1; i++)
		{
			for (int j = i + 1; j < bmVer.length(); j++)
			{
				if (vxEl.dotProduct(bmVer[i].ptCen() - ptElementBase) > vxEl.dotProduct(bmVer[j].ptCen() - ptElementBase))
				bmVer.swap(i, j);
			}
		}
		for (int i = 0; i < bmVer.length(); i++)
		{
			bmVer[i].realBody().vis(i);
		}
	

		vNewX=Vector3d();
		vNewY=Vector3d();
		
		for(int i=0; i<bmHor.length(); i++)
		{ 
			vNewX = vNewX + bmHor[i].vecX();
		}
		
		if (vNewX.dotProduct(vxEl)<0)
			vNewX = -vNewX;
		
		vNewX.normalize();
		vNewX.vis(ptElementBase,1);
		
		for(int i=0; i<bmVer.length(); i++)
		{
			vNewY = vNewY + bmVer[i].vecX();
		}
		
		if (vNewY.dotProduct(vyEl)<0)
			vNewY = -vNewY;
		
		vNewY.normalize();
		vNewY.vis(ptElementBase,2);
		
		//bmVer=vNewX.filterBeamsPerpendicularSort(arBm);
		//bmHor=vNewY.filterBeamsPerpendicularSort(arBm);
		
		bmFiltered.append(bmVer);
		Point3d ptBottom;
		Point3d ptTop;
		if (bmHor.length()>0)
		{
			ptBottom=bmHor[0].ptCen();
			ptTop=bmHor[bmHor.length()-1].ptCen();
		}
		for(int i=0;i<bmHor.length();i++)
		{
			Beam bm = bmHor[i];
			
			if (bm.type()==_kEWPBacker_Block)
				continue;
			
			if( bm.type() !=_kBlocking)
			{
				if (vyEl.dotProduct(bm.ptCen()-ptCenEl)>0)
				{
					if (abs(vyEl.dotProduct(bm.ptCen()-ptTop))<U(1))
					{
						bmTopPlate.append(bm);
					}
				}
				else
				{
					if (abs(vyEl.dotProduct(bm.ptCen()-ptBottom))<U(1))
					{
						bmBottomPlate.append(bm);
					}
				}
			}
		}
		bmFloorJoist.append(bmVer);
	}
	
	//Collect all the male beams that have connectoin with female beams - jacks will be marked as having connection with top plate even though there is no contact
	Beam bmFemaleBeams[0];
	Beam bmMaleBeams[0];
	
	//Init Points that will be nailed and their indexes
	Point3d ptNailLines[0];
	int nNailIndexes[0];
	Vector3d vecNailingDirection[0];
	
	//Init Points for Horizontal members
	Beam bmHorizontals[0];
	Point3d ptNailLineHorizontals[0];	
	Point3d ptNailReference[0]; //This is required for the Randek interface as the slave TSL will try to calculate the left of the beam by default
	int nNailIndexesHorizontals[0];	
	Vector3d vecNailingDirectionHorizontals[0];
	
	//Get all the vertical beams from all the filtered beams
	if (nWall)
	{
		bmVertical = vxEl.filterBeamsPerpendicularSort(bmFiltered);
	}
	else
	{
		bmVertical = bmFloorJoist;
	}
	
	
	//Gather all the points where proposed nails would go
	Point3d ptNailPositions[0];
	PlaneProfile ppMaleBeams[0];  //Male beams to be nailed
	Vector3d vecNailingPlanes[0];  
	
	double dZones[]={dIndex0,dIndex1,dIndex2,dIndex3};
	int nYNNail[0];
	
	for(int z=0;z<dZones.length();z++)
	{
		double dZoneSize=dZones[z];

		Point3d pt;			
		if(dZoneSize==0)
		{
			ptNailPositions.append(pt);
			nYNNail.append(false);
		}
		else
		{
			//Get the point from the back face of the element to the point where the nail should go in the vz direction
			pt=ptElementBase+dZoneSize*vzEl;
			ptNailPositions.append(pt);				
			nYNNail.append(true);				
		}

	}

	//First find all the beams that have a contact with the top/bottom plate and add them to the beam arrays
	for(int b=0;b<bmVertical.length();b++)
	{
		Beam bm=bmVertical[b];
		Point3d ptBmCen=bm.ptCen();
		
		if (bm.type()==_kEWPBacker_Block)
			continue;
		
		//Include beams with intersection to top/bottom plate
		Beam arBmIntersectTop[] = bm.filterBeamsCapsuleIntersect(bmTopPlate);
		Beam arBmIntersectBottom[] = bm.filterBeamsCapsuleIntersect(bmBottomPlate);
		
		//In the cases where we have the stud intersecting with multiple top plates, use the Top plate as preference, else pick the first in the list
		if(arBmIntersectTop.length()>1)
		{
			Beam bmTopPlate;
			for(int i=0;i<arBmIntersectTop.length();i++)
			{
				Beam bmIntersect=arBmIntersectTop[i];
				bmIntersect.realBody().vis();
				if(bmIntersect.type()==_kSFTopPlate)
				{
					bmTopPlate=bmIntersect;
				}
			}
			
			if(bmTopPlate.bIsValid())
			{
				//Remove all but the top plate
				arBmIntersectTop.setLength(0);
				arBmIntersectTop.append(bmTopPlate);
			}
			else
			{
				//Remove all except the first
				Beam bmPlate=arBmIntersectTop[0];
				arBmIntersectTop.setLength(0);
				arBmIntersectTop.append(bmPlate);
			}
		}
		
		
		for(int i=0;i<arBmIntersectTop.length();i++)
		{
			Beam bmFemale=arBmIntersectTop[i];
			//Add the beam and its connection
			
			bmMaleBeams.append(bm);
			bmFemaleBeams.append(bmFemale);
		}
		
		for(int i=0;i<arBmIntersectBottom.length();i++)
		{
			Beam bmFemale=arBmIntersectBottom[i];
			//Add the beam and its connection
			bmMaleBeams.append(bm);
			bmFemaleBeams.append(bmFemale);
		}
	}

	//Deal with Jacks in openings, top, bottom and headers only in wall
	if (nWall)
	{
		Opening opEl[] = el.opening();
		Plane plFlat(el.ptOrg(), vyEl);
		for (int o = 0; o < opEl.length(); o++)
		{
			Opening op = opEl[o];
			OpeningSF opSF = (OpeningSF) op;
			
			//Find centre of opening
			PLine plOp = op.plShape();
			
			PlaneProfile ppOp(csEl);
			ppOp.joinRing(plOp, FALSE);
			LineSeg ls = ppOp.extentInDir(vxEl);
			double dGapSideOp = opSF.dGapSide();
			Point3d ptCenterOp = ls.ptMid();
			Point3d ptLeftOp = ls.ptStart() - (dGapSideOp * vxEl);
			Point3d ptRightOp = ls.ptEnd() + (dGapSideOp * vxEl);
			
			ptLeftOp = ptLeftOp.projectPoint(plFlat, 0);
			ptRightOp = ptRightOp.projectPoint(plFlat, 0);
			
			ptLeftOp.vis();
			ptRightOp.vis();
			
			ppOp.joinRing(plOp, false);
			//Shrink by the size of one stud
			ppOp.shrink(-dBeamW);
			
			
			//Find any beam which intersects the extended openings plane profile and has a module (only checking throgh opening beams)
			Beam bmValidIntersection[0];
			String sOpeningModule = "";
			ppOp.vis(2);
			for (int j = 0; j < bmOpenings.length(); j++)
			{
				Beam bmOp = bmOpenings[j];
				PlaneProfile ppBm(csEl);
				ppBm = bmOp.envelopeBody().extractContactFaceInPlane(pln, U(20));
				ppBm.vis(3);
				if (ppBm.intersectWith(ppOp))
				{
					bmValidIntersection.append(bmOp);
					String sModule = bmOp.module();
					if (sModule != "")
					{
						sOpeningModule = sModule;
						break;
					}
				}
			}
			
			//Find all Jacks Below/Above for this opening
			Beam bmOpJacksAbove[0];
			Beam bmOpJacksBelow[0];
			for (int j = 0; j < bmJacks.length(); j++)
			{
				Beam bm = bmJacks[j];
				String sModule = bm.module();
				if (bm.module() == sOpeningModule)
				{
					if (bm.type() == _kSFJackOverOpening) bmOpJacksAbove.append(bm);
					if (bm.type() == _kSFJackUnderOpening) bmOpJacksBelow.append(bm);
				}
			}
			
			//Find all cripples for the opening
			Beam bmOpCripples[0];
			for (int c = 0; c < bmCripple.length(); c++)
			{
				Beam bm = bmCripple[c];
				if (bm.module() == sOpeningModule)
				{
					bmOpCripples.append(bm);
				}
			}
			
			//Cripples will be nailed on the top plate and the bottom plate
			for (int c = 0; c < bmOpCripples.length(); c++)
			{
				Beam bm = bmOpCripples[c];
				
				//Find top plate above Cripple
				Beam bmIntersectTop[] = Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bm.ptCen(), vyEl);
				
				if (bmIntersectTop.length() > 0)
				{
					bmMaleBeams.append(bm);
					bmFemaleBeams.append(bmIntersectTop[0]);
				}
				
				//Find bottom plate above Cripple
				Beam bmIntersectBottom[] = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bm.ptCen() ,- vyEl);
				
				if (bmIntersectBottom.length() > 0)
				{
					bmMaleBeams.append(bm);
					bmFemaleBeams.append(bmIntersectBottom[0]);
				}
			}
			
			
			//Create Nailing Lines for the Headers as it is possible to have header over jacks and we do not want to nail where a header is not if header is above jacks
			Point3d ptHeaderNails[0];
			
			//Jacks 
			
			for (int j = 0; j < bmOpJacksBelow.length(); j++)
			{
				Beam bm = bmOpJacksBelow[j];
				
				//Find bottom plate below Jacks
				Beam bmIntersect[] = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bm.ptCen() ,- vyEl);
				
				if (bmIntersect.length() > 0)
				{
					bmMaleBeams.append(bm);
					bmFemaleBeams.append(bmIntersect[0]);
				}
			}
			
			//Create a planeprofile of the opening so as to the header area above the opening only
			PLine plOpeningFlat(vyEl);
			LineSeg lsOpeningFlat(ptLeftOp, ptRightOp - dBeamH * vzEl);
			plOpeningFlat.createRectangle(lsOpeningFlat, vxEl ,- vzEl);
			plOpeningFlat.vis(5);
			PlaneProfile ppOpening(plOpeningFlat);
			ppOpening.vis(6);
			
			//Get Header Information
			//Create PlaneProfile of all the headers so they can be checked in one go and create one set of points
			PlaneProfile ppHeaders;
			Body bdHeaders;
			Beam bmOpHeader[0];
			
			for (int c = 0; c < bmHeader.length(); c++)
			{
				Beam bm = bmHeader[c];
				if (bm.module() == sOpeningModule)
				{
					bmOpHeader.append(bm);
				}
			}
			
			//Create PlaneProfile of all the headers so they can be checked in one go and create one set of points
			Plane plOutside;
			Plane plInside;
			Vector3d vecPlane;
			Beam bmFemale;
			int nValidHeaderFixing = false;
			
			//Find the top plate above the header
			for (int h = 0; h < bmOpHeader.length(); h++)
			{
				Beam bm = bmOpHeader[h];
				
				//Find top plate above Cripple
				Beam bmIntersect[] = Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bm.ptCen(), vyEl);
				
				if (bmIntersect.length() > 0)
				{
					nValidHeaderFixing = true;
					bmFemale = bmIntersect[0];
					Point3d ptFemaleCen = bmFemale.ptCen();
					
					
					//Top Plate Plane
					Vector3d vecBmX = bmFemale.vecX();
					vecPlane = vecBmX.crossProduct(vzEl);
					
					//Double check the vector direction so that it is the top plate
					if (vecPlane.dotProduct(vyEl) < 0) vecPlane = - vecPlane;
					vecPlane.normalize();
					
					//Project the centrepoint of the beam to the plane
					double dFemaleWidth = bmFemale.dD(vecPlane);
					Point3d ptFaceOfFemale = ptFemaleCen + dFemaleWidth * 0.5 * vecPlane;
					Point3d ptInsideFaceOfFemale = ptFemaleCen - dFemaleWidth * 0.5 * vecPlane;
					plOutside = Plane(ptFaceOfFemale, vecPlane);
					plInside = Plane(ptInsideFaceOfFemale, vecPlane);
					
					plOutside.vis();
					
					if (h == 0)
					{
						ppHeaders = bm.realBody().shadowProfile(plOutside);
						bdHeaders = bm.realBody();
					}
					else
					{
						ppHeaders.unionWith(bm.realBody().shadowProfile(plOutside));
						bdHeaders.combine(bm.realBody());
					}
					
				}
			}
			//In the event where there are no jacks on the bottom or top
			
			
			if (bmOpJacksAbove.length() == 0 && bmOpHeader.length() != 0)
			{
				if (nValidHeaderFixing)
				{
					ppHeaders.intersectWith(ppOpening);
					ppHeaders.vis(7);
					//Add leftmost point
					Point3d ptLeft = ptLeftOp + dBeamW * 0.5 * vxEl - dBeamH * 0.5 * vzEl;
					Line lLeft(ptLeft, vyEl);
					ptLeft = lLeft.intersect(plInside, 0);
					ptLeft = ptLeft.projectPoint(plOutside, 0);
					ptHeaderNails.append(ptLeft);
					vecNailingDirectionHorizontals.append(-vecPlane);
					bmHorizontals.append(bmFemale);
					
					//Add rightmost point
					Point3d ptRight = ptRightOp - dBeamW * 0.5 * vxEl - dBeamH * 0.5 * vzEl;
					Line lRight(ptRight, vyEl);
					ptRight = lRight.intersect(plInside, 0);
					ptRight = ptRight.projectPoint(plOutside, 0);
					ptHeaderNails.append(ptRight);
					vecNailingDirectionHorizontals.append(-vecPlane);
					bmHorizontals.append(bmFemale);
					
					//Add intermediate points
					double dDistanceCheck = abs((ptRight - ptLeft).length());
					int nCounter = 0;
					while (dDistanceCheck > dHeadBraceSpacing && nCounter < 100)
					{
						Point3d ptNewNailLine = ptLeft + dHeadBraceSpacing * vxEl;
						ptLeft = ptNewNailLine;
						
						dDistanceCheck = abs((ptRight - ptNewNailLine).length());
						
						//Need to add a tolerance in case the last nail is very close to the right nail, or else it can nail into the other nail
						if (dDistanceCheck < U(dBeamW * 0.5))
						{
							ptNewNailLine = ptNewNailLine - dBeamW * 0.5 * vxEl;
							ptLeft = ptNewNailLine;
						}
						
						ptHeaderNails.append(ptNewNailLine);
						vecNailingDirectionHorizontals.append(-vecPlane);
						bmHorizontals.append(bmFemale);
						
						nCounter++;
					}
				}
			}
			else
			{
				for (int j = 0; j < bmOpJacksAbove.length(); j++)
				{
					Beam bm = bmOpJacksAbove[j];
					Body bd = bm.realBody();
					Point3d ptJackCen = bm.ptCen();
					
					//Find top plate above Jacks
					Beam bmIntersect[] = Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bm.ptCen(), vyEl);
					
					//Check if there are any headers above the jacks
					//Move the body up a little
					bd.transformBy(U(5) * vyEl);
					int nHeaderIntersect = bd.hasIntersection(bdHeaders);
					
					if (nHeaderIntersect)
					{
						if (bmIntersect.length() > 0)
						{
							//Need to use the headers as points of checking nailing and not the top plate
							ptHeaderNails.append(ptJackCen.projectPoint(plOutside, 0));
							vecNailingDirectionHorizontals.append(-vyEl);
							bmHorizontals.append(bmFemale);
						}
					}
					else
					{
						if (bmIntersect.length() > 0)
						{
							bmMaleBeams.append(bm);
							bmFemaleBeams.append(bmIntersect[0]);
						}
					}
				}
			}
			
			//Add output information into arrays
			for (int h = 0; h < ptHeaderNails.length(); h++)
			{
				Point3d ptNailHor = ptHeaderNails[h];
				ptNailHor.vis();
				
				String sBmNailIndexes = "";
				//			ppHeaders.vis(1);
				for (int n = 0; n < ptNailPositions.length(); n++)
				{
					if ( ! nYNNail[n]) continue;
					Point3d pt = ptNailPositions[n];
					pt.vis(3);
					//Project to centre of each point where the nail is to be added
					Plane plNailLineCen(ptNailHor, vxEl);
					pt = pt.projectPoint(plNailLineCen, 0);
					pt.vis(2);
					int nInProfile = ppHeaders.pointInProfile(pt);
					if (nInProfile != _kPointOutsideProfile)
					{
						int nIndex = n + 1;
						sBmNailIndexes += nIndex;
					}
				}
				//If the beam happens to be outside the zones defined then fire the last nail as default
				if (sBmNailIndexes == "") sBmNailIndexes = 4;
				
				nNailIndexesHorizontals.append(sBmNailIndexes.atoi());
			}
			
			//Add all the Header points to the list of horizontal nail lines
			ptNailLineHorizontals.append(ptHeaderNails);
			
		}//End opening loop
	}
	
	//Add the reference point to the array which is half the normal stud width
	for(int h=0;h<ptNailLineHorizontals.length();h++)
	{
		Point3d ptNailHor=ptNailLineHorizontals[h];			
		ptNailReference.append(ptNailHor-dBeamW*0.5*vxEl);
	}
	
	//Go through each of the Male beams and project them to the plane of the female beam and create the points
	for(int b=0;b<bmMaleBeams.length();b++)
	{
		Beam bmMale=bmMaleBeams[b];
		Beam bmFemale=bmFemaleBeams[b];
		Point3d ptMaleCen=bmMale.ptCen();
		Point3d ptFemaleCen=bmFemale.ptCen();
		Point3d ptMaleBack=bmMale.ptCen()-bmMale.dD(vzEl)*0.5*vzEl;
		
		//Get the plane on the female beam
		Vector3d vecPlane;
		//If Top plate
		if(bmTopPlate.find(bmFemale)!=-1)
		{
			Vector3d vecBmX=bmFemale.vecX();
			vecPlane=vecBmX.crossProduct(vzEl);
			
			//Double check the vector direction so that it is the top plate
			if(vecPlane.dotProduct(vyEl)<0) vecPlane=-vecPlane;
			vecPlane.normalize();
		}
		//Bottom plate
		else if (bmBottomPlate.find(bmFemale)!=-1)
		{
			Vector3d vecBmX=bmFemale.vecX();
			vecPlane=vecBmX.crossProduct(vzEl);
			
			//Double check the vector direction so that it is the bottom plate
			if(vecPlane.dotProduct(vyEl)>0) vecPlane=-vecPlane;
			vecPlane.normalize();			
		}
		
		//vecPlane.vis(ptMaleCen);
		
		//Project the centrepoint of the beam to the plane
		double dFemaleWidth=bmFemale.dD(vecPlane);
		Point3d ptFaceOfFemale=ptFemaleCen+dFemaleWidth*0.5*vecPlane;
		Point3d ptInsideFaceOfFemale=ptFemaleCen-dFemaleWidth*0.5*vecPlane;
		Plane plOutside(ptFaceOfFemale, -vecPlane);
		Plane plInside(ptInsideFaceOfFemale, -vecPlane);		

		//Plane plOutside(ptFaceOfFemale, -bmMale.vecX());
		//Plane plInside(ptInsideFaceOfFemale, -bmMale.vecX());		

		plOutside.vis();
		
		Line lnMaleCen(ptMaleCen,vyEl);
		Point3d ptMaleCenProjected=lnMaleCen.intersect(plInside,0);
		
		//project point to outside face
		ptMaleCenProjected=ptMaleCenProjected.projectPoint(plOutside,0);
		//Find nail indexes based on areas
		//Get Planeprofile of male beam
		PlaneProfile ppBmMale=bmMale.realBody().shadowProfile(plOutside);
		ppBmMale.vis(2);
		
		if (bmMale.extrProfile()!=_kExtrProfRectangular)
		{
		// get plane profiles
			String sExtrProfile = bmMale.extrProfile();
			ExtrProfile extrProfile(sExtrProfile);
			PlaneProfile componentProfiles[]=extrProfile.componentProfiles();
			CoordSys cs;
			cs.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,
				bmMale.ptCen(),bmMale.vecY(),bmMale.vecZ(),bmMale.vecX());
			
			PlaneProfile ppsBm[0];
			PlaneProfile ppBmMaleModif(ppBmMale.coordSys());
			for (int ipp=0;ipp<componentProfiles.length();ipp++) 
			{ 
				PlaneProfile ppI=componentProfiles[ipp];
				ppI.transformBy(cs);
				ppI.shrink(-U(12));
				ppI.shrink(U(12));
				ppI.shrink(U(12));
				if (ppI.area()<pow(dEps,2))continue;
				ppI.shrink(-U(12));
				ppBmMaleModif.unionWith(ppI);
			}//next ipp
			ppBmMale=ppBmMaleModif;
//			ppBmMale.shrink(U(12));
//			ppBmMale.shrink(-U(12));
		}	
		ppBmMale.vis(1);
		//Add final nail lines
		ptNailLines.append(ptMaleCenProjected);
		//ppMaleBeams.append(ppBmMale);
		//vecNailingPlanes.append(vecPlane);

		String sBmNailIndexes="";
		
		for(int n=0;n<ptNailPositions.length();n++)
		{
			if(!nYNNail[n]) continue;
			Point3d pt=ptNailPositions[n];
			pt.vis(3);
			//Project to centre of each point where the nail is to be added
			Plane plNailLineCen(ptMaleCenProjected,vxEl);
			pt=pt.projectPoint(plNailLineCen,0);
			pt.vis(2);
			int nInProfile=ppBmMale.pointInProfile(pt);
			if(nInProfile!=_kPointOutsideProfile)
			{
				int nIndex=n+1;
				sBmNailIndexes+=nIndex;
			}
		}	
		
		//If the beam happens to be outside the zones defined then fire the last nail as default
		if(sBmNailIndexes=="") sBmNailIndexes=4;
		
		nNailIndexes.append(sBmNailIndexes.atoi());
		
		//Send in the nailing direction
		vecNailingDirection.append(-vecPlane);
	}

	//Create child TSLs
	
	//Normal stud
	for(int p=0;p<ptNailLines.length();p++)
	{
		Point3d pt=ptNailLines[p];
		int nIndex=nNailIndexes[p];
		Vector3d vecDirection=vecNailingDirection[p];
		
		lstPropInt.setLength(0);
		lstPropDouble.setLength(0);
		lstPropString.setLength(0);
		lstPoints.setLength(0);
		lstBeams.setLength(0);

		lstBeams.append(bmFemaleBeams[p]);
		lstBeams.append(bmMaleBeams[p]);		


		lstPoints.append(pt);

		lstPropInt.append(nIndex);

		Map mp;
		mp.setVector3d("vy", vecDirection);
		
		TslInst tsl;
		tsl.dbCreate(strScriptName , vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
	}
	
	//Horizontal Studs
	for(int p=0;p<ptNailLineHorizontals.length();p++)
	{
		Point3d pt=ptNailLineHorizontals[p];
		Point3d ptReference=ptNailReference[p];
		int nIndex=nNailIndexesHorizontals[p];
		Vector3d vecDirection=vecNailingDirectionHorizontals[p];
		Beam bm=bmHorizontals[p];
		
		lstPropInt.setLength(0);
		lstPropDouble.setLength(0);
		lstPropString.setLength(0);
		lstPoints.setLength(0);
		lstBeams.setLength(0);

		lstBeams.append(bm);
				
		lstPoints.append(pt);

		lstPropInt.append(nIndex);

		
		Map mp;
		mp.setVector3d("vy", vecDirection);
		mp.setPoint3d("Reference",ptReference);
		
		TslInst tsl;
		tsl.dbCreate(strScriptName , vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
	}
}


Point3d ptDraw = _Pt0;
ptDraw=ptDraw-vzEl*dBeamH;
Display dspl (-1);
//dspl.dimStyle(sDimLayout);

//if (sDispRep!="")
//	dspl.showInDispRep(sDispRep);

PLine pl1(vxEl);
PLine pl2(vyEl);
PLine pl3(vzEl);
PLine pl4(vzEl);
pl1.addVertex(ptDraw+vzEl*U(1));
pl1.addVertex(ptDraw-vzEl*U(1));
pl2.addVertex(ptDraw-vxEl*U(1));
pl2.addVertex(ptDraw+vxEl*U(1));
pl3.addVertex(ptDraw-vyEl*U(1));
pl3.addVertex(ptDraw+vyEl*U(1));

pl4.createCircle(ptDraw, vzEl,U(0.5));

dspl.draw(pl1);
dspl.draw(pl2);
dspl.draw(pl3);
dspl.draw(pl4);

//if (arNNY[sArNY.find(sNailYNCNC,0)]==FALSE)
//{
//	dspl.draw("Nailing", ptDraw, vx, -vz, 1, -2);
//}

_Map.setInt("ExecutionMode",1);


assignToElementGroup(_Element[0], TRUE, 0, 'E');
//eraseInstance();
#End
#BeginThumbnail




















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="20" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16838: Use plane profiles from ExtrProfile instead of realBody" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="11/2/2022 11:04:12 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End