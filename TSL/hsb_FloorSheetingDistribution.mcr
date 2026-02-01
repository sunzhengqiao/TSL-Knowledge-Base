#Version 8
#BeginDescription
Distributes the sheet above and below openings depending on width and height of available sheets.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 14.09.2012 version 1.4



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
*  Copyright (C) 2012 by
*  hsbSOFT 
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
* Create by: Alberto Jena (aj@hsb-cad.com)
* date: 05-07-2012
* version 1.0: Release Version
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 01-08-2012
* version 1.1: Sheeting split bugfix and added property for ignoring a minimum size of board from waste calculation
*
* date: 08-08-2012
* version 1.2: Add the option to distribute the sheets parallel or perpendicullar to the joist
*
* date: 20-08-2012
* version 1.3: Add a check in case that the sheet that is going to be create is smaller than 1mm
*
* date: 14-09-2012
* version 1.4: Bugfix with a shee been bigger than the full size because the point was inside of the profile of the beam
*/

Unit(1,"mm"); // script uses mm

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones(0, nValidZones, T("Zone to Redistribute the Sheets"));

String sArOr[]={T("Perpendicular to Joist"), T("Parallel to Joist")};
PropString sOrientation(2, sArOr,T("Orientation"));

PropDouble dSheetWidth(0, U(600), T("Sheeting Width"));
PropDouble dSheetLength(1, U(2400), T("Sheeting Length"));

PropDouble dSheetThickness(2, U(22), T("Sheeting Thickness"));

PropDouble dMinimumLength(3, U(100), T("Minimum sheet length"));

PropDouble dMinWidthForWaste(4, U(150), T("Min sheet width for waste calculation"));

PropString sDimStyle(0, _DimStyles, T("Dimension Style"));

String sArYesNo[] = {T("No"), T("Yes")};
PropString strYNWaste (1,sArYesNo,T("Show Waste"), 0);


if (_bOnDbCreated)
{
	setPropValuesFromCatalog(_kExecuteKey);
}

int nZone=nRealZones[nValidZones.find(nZones)];
int nYesNoWaste=sArYesNo.find(strYNWaste);
int nOrientation=sArOr.find(sOrientation);

double dSWidth=dSheetWidth;
double dSLength=dSheetLength;


if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
	
	//Select a set of walls
	PrEntity ssE(T("Select one, or more elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	_Pt0 = getPoint(T("Start distribution point"));
	
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
	
	lstPropInt.append(nZones);

	lstPropDouble.append(dSheetWidth);
	lstPropDouble.append(dSheetLength);
	lstPropDouble.append(dSheetThickness);
	lstPropDouble.append(dMinimumLength);
	lstPropDouble.append(dMinWidthForWaste);
	
	lstPropString.append(sDimStyle);
	lstPropString.append(strYNWaste);
	lstPropString.append(sOrientation);
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);
	
	for( int e=0; e<_Element.length(); e++ )
	{
		lstElements.setLength(0);
		lstElements.append(_Element[e]);
		
		lstPoints.append(_Pt0);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	eraseInstance();
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

String strChangeEntity = T("Redistribute Sheets");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	_Map.setInt("ExecutionMode", 0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

Element el=_Element[0];

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

double dWallDepth=el.dBeamWidth();
double dRefHeight=0;

ElementRoof elR=(ElementRoof) el;
if (elR.bIsValid())
{
	dRefHeight=elR.dReferenceHeight();
}

Point3d ptElOrg=csEl.ptOrg();

Plane plnZ (ptElOrg, vz);

_Pt0=plnZ.closestPointTo(_Pt0);

_Pt0=Line(ptElOrg, vy).closestPointTo(_Pt0);

double dWaste=0;
int nBoards=0;

if (nExecutionMode==0)
{
	//Get all the jacks that exist in the element
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	
	Sheet shAll[]=el.sheet(nZone);
	
	if (shAll.length()==0)
	{
		return;
	}
	
	ElemZone elz=el.zone(nZone);
	
	Point3d ptZoneOrig=elz.ptOrg();
	int nSheetColor=0;
	String sSheetMaterial=elz.material();
	double dSheetTol=0;//ez.dVar("gap");
	double dVertSheetTol=0;//ez.dVar("Vertical gap");

	CoordSys csZone(ptZoneOrig, vy, -vx, vz);

	if (nOrientation)//Parallel
	{
		dSWidth=dSheetLength;
		dSLength=dSheetWidth;
		csZone=CoordSys(ptZoneOrig, vx, vy, vz);
		//reportNotice("\nyes ");
	}
	else
	{
		//reportNotice("\nno ");
	}
	
	//reportNotice("W:"+dSWidth+" L:"+dSLength);
	
	//csZone.vis();
	
	Plane plnZone(ptZoneOrig, vz);
	
	PlaneProfile ppSheets(csZone);
	
	for (int s=0; s<shAll.length(); s++)
	{
		Sheet sh=shAll[s];
		nSheetColor=sh.color();
		PlaneProfile ppSheet(csZone);
		ppSheet=sh.profShape();
		ppSheet.shrink(-U(10));
		ppSheets.unionWith(ppSheet);
	}	
	
	//Erase all the sheets in that zone
	for (int s=0; s<shAll.length(); s++)
	{
		shAll[s].dbErase();
	}
	
	ppSheets.shrink(U(10));
	ppSheets.vis();
	
	double dFloorArea=ppSheets.area();
	
	LineSeg lsUp=ppSheets.extentInDir(vy);
	LineSeg lsSide=ppSheets.extentInDir(vx);
	
	Point3d ptMidFloor=lsUp.ptMid();
	
	Point3d ptBL=Line(lsUp.ptStart(), vx).closestPointTo(Line(lsSide.ptStart(), vy));
	Point3d ptTR=Line(lsUp.ptEnd(), vx).closestPointTo(Line(lsSide.ptEnd(), vy));
	
	ptBL.vis(1);
	ptTR.vis(1);
	
	double dDistToOrg=abs(vy.dotProduct(_Pt0-ptBL));
	
	int nSign=sign(vy.dotProduct(ptBL-_Pt0));
	
	int nTimeToOrg=ceil(dDistToOrg/dSWidth);
	
	Point3d ptDistStart=Line(ptBL, vy).closestPointTo(_Pt0);
	
	if (nTimeToOrg>0 && dDistToOrg>U(1))
	{
		ptDistStart=ptDistStart+vy*(dSWidth*nSign*nTimeToOrg);
	}
	
	ptDistStart.vis(2);
	
	int nCount=0;
	
	double dNextSheetLength=0;
	
	while (vy.dotProduct(ptDistStart-ptTR)<0 && nCount<50)
	{
		Point3d ptSheetStart=ptDistStart;

		Point3d ptTopRow=Line(ptDistStart+vy*dSWidth, vx).closestPointTo(Line(ptTR, vy));
		ptTopRow.vis(87);
		
		LineSeg ls(ptDistStart, ptTopRow);
		PLine plSheetRow(vz);
		plSheetRow.createRectangle(ls, csZone.vecX(), csZone.vecY());
		PlaneProfile ppSheetRow(csZone);
		ppSheetRow.joinRing(plSheetRow, false);
		
		PLine plRings[]=ppSheetRow.allRings();		
		
		Sheet shThisRow[0];
		
		//Go through each ring to find all the various split points
		for(int r=0;r<plRings.length();r++)
		{
			PLine pl=plRings[r];
			//PlaneProfile pp(plnZone);
			PlaneProfile pp(csZone);
			pp.joinRing(pl,false);	
			LineSeg ls=pp.extentInDir(vx);
			Vector3d vecSeg=ls.ptEnd()-ls.ptStart();
			//ls.ptStart().vis();
			Point3d ptSegmentEdge;
			if ((ptMidFloor-ls.ptStart()).length() > (ptMidFloor-ls.ptEnd()).length())
				ptSegmentEdge=ls.ptEnd();
			else
				ptSegmentEdge=ls.ptStart();
				
			Plane plMidY(ptSegmentEdge,vy);
			
			//Get the width and height of the segment
			double dSegWidth=abs(vx.dotProduct(vecSeg));
			double dSegHeight=abs(vy.dotProduct(vecSeg));
			
			//Compare with the Width and Height of the sheet defined in the element
			//If the height of the segment is greater than the sheet width defined, then horizontal distribution is not possible
			//int nFullSheetProfile=true;
			
			//Check if vertical distribution will be required instead of horizontal
			double dSheetHNew=dSWidth;
			double dSheetWNew=dSLength;
			
			
			//Check distance remaining within segment
			Point3d ptElMid=ptElOrg-(dWallDepth*0.50)*vz;
			ptElOrg.vis(3);
			ptElMid.vis();
			Plane plMid(ptElMid,vz);
			double dDistanceCheck=dSegWidth;
			int nLoops=0;
			Point3d ptSplits[0];
			Point3d ptTempShEnd;
			
			int nFullCover=true;
			//while( (dDistanceCheck-dSheetWNew)>U(0.01) && nLoops<50)
			//reportNotice ("\n dNext: "+dNextSheetLength);
			int nRunSplit=false;
			
			if ((dDistanceCheck-dSheetWNew)>U(0.01))
				nRunSplit=true;
			
			if (dNextSheetLength>0 && (dDistanceCheck-dNextSheetLength)>U(0.01))
				nRunSplit=true;
			
			//while( ((dDistanceCheck-dSheetWNew)>U(0.01) || ((dDistanceCheck-dNextSheetLength)>U(0.01))) && nLoops<50)
			while( nRunSplit && nLoops<50)
			{
	
				
				nFullCover=false;
				int bmAuxPosition=0;
				//Using horizontal distribution create sheeting
				//Find a point to the maximum height of the sheet
				
				if(nLoops==0)
				{
					double dAux=dSheetWNew;
					if (dNextSheetLength>0)
					{
						dAux=dNextSheetLength;
					}
					else
					{
						nBoards++;
					}
					
					ptTempShEnd=ls.ptStart()+(dAux*vx);
					ptTempShEnd=ptTempShEnd.projectPoint(plMidY,0);
				}
				else
				{
					if (dNextSheetLength==0)
					{
						nBoards++;
					}

					ptTempShEnd=ptTempShEnd+(dSheetWNew*vx);
					ptTempShEnd=ptTempShEnd.projectPoint(plMidY,0);
					//Point3d ptBL=Line(lsUp.ptStart(), vx).closestPointTo(Line(lsSide.ptStart(), vy));
				}
				
				//ptTempShEnd.vis(1);
				
				//Project point to centre of element
				Point3d ptProjected=ptTempShEnd.projectPoint(plMid,0);
				ptProjected.vis();
				
				double dAAA=vx.dotProduct(ptDistStart-ptProjected);
				//Check if there are any beams to work with
				
				if(bmVer.length()>0)
				{
					Beam bmAux[]=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptProjected,-vx);
					
					bmAux=(-vx).filterBeamsPerpendicularSort(bmAux);
					
					if(bmAux.length()>0)
					{
						Beam bmSheetSplit=bmAux[0];
	
						bmSheetSplit.realBody().vis();
						Plane plProjected(ptProjected,vz);
						PlaneProfile ppBmSheetSplit=bmSheetSplit.realBody().shadowProfile(plProjected);
						//Need to check where the projected point lies as it could be inside a beam and past or on the centre point of the beam
						if(ppBmSheetSplit.pointInProfile(ptProjected)!=_kPointOutsideProfile )
						{
							Vector3d vecDistanceToSheetSplit=bmSheetSplit.ptCen()-ptProjected;
							double dDistToSheetSplit=vecDistanceToSheetSplit.dotProduct(vx);
							//reportNotice("\n SSS "+dDistToSheetSplit);
							
							if(dDistToSheetSplit>U(0.01))//AJ v1.4
							{
								if(bmAux.length()>1)
								{
									//Check if new beam found is the same as the previous beam
									if(bmSheetSplit.handle()!=bmAux[1].handle())
									{
										bmSheetSplit=bmAux[1];
										bmAuxPosition+=1;
									}
								}
							}
						}
						
						Point3d ptBmCen=bmSheetSplit.ptCen();
						ptTempShEnd=ptBmCen;
						//ptTempShEnd.vis(nLoops);
						
						//Check if the previous distance is less than the minimum width
						if (abs(vx.dotProduct(ptSheetStart-ptTempShEnd))<dMinimumLength)//Start with a new board
						{
							double dASD=abs(vx.dotProduct(ptSheetStart-ptTempShEnd));
							//reportNotice("\nyes in here "+dASD);
							
							ptTempShEnd=ptSheetStart+(dSheetWNew*vx);
							ptTempShEnd=ptTempShEnd.projectPoint(plMidY,0);
							
							ptProjected=ptTempShEnd.projectPoint(plMid,0);
							ptProjected.vis();
							
							if ((dDistanceCheck-dSheetWNew)<U(0.01))
							{
								//nBoards++;
								nFullCover=true;
								break;
							}
							

							Beam bmAuxTemp[]=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptProjected,-vx);
							bmAuxTemp=(-vx).filterBeamsPerpendicularSort(bmAuxTemp);
					
							if(bmAuxTemp.length()>0)
							{
								bmSheetSplit=bmAuxTemp[0];
			
								bmSheetSplit.realBody().vis();
								Plane plProjected(ptProjected,vz);
								PlaneProfile ppBmSheetSplit=bmSheetSplit.realBody().shadowProfile(plProjected);
								//Need to check where the projected point lies as it could be inside a beam and past or on the centre point of the beam
								if(ppBmSheetSplit.pointInProfile(ptProjected)!=_kPointOutsideProfile)
								{
									Vector3d vecDistanceToSheetSplit=bmSheetSplit.ptCen()-ptProjected;
									double dDistToSheetSplit=vecDistanceToSheetSplit.dotProduct(vx);
									//reportNotice("\n SSS "+dDistToSheetSplit);
									
									if(dDistToSheetSplit>U(0.01))
									{
										if(bmAuxTemp.length()>1)
										{
											//Check if new beam found is the same as the previous beam
											if(bmSheetSplit.handle()!=bmAuxTemp[1].handle())
											{
												bmSheetSplit=bmAuxTemp[1];
												bmAuxPosition+=1;
											}
										}
									}
								}
							}
							
							ptBmCen=bmSheetSplit.ptCen();
							ptTempShEnd=ptBmCen;
							
							ptTempShEnd.vis(nLoops);	
								
						}
			
						
						dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptBmCen));
						
						//Check if the minimum sheet width criteria is being fulfilled
						if((dDistanceCheck-dMinimumLength)<U(0.01))
						{
							//The current position is giving us a result which is less than the minimum width so move to the next position
							bmAuxPosition++;
							int nInnerLoop=0;
	
							while( (dDistanceCheck-dMinimumLength)<U(0.01)&& nInnerLoop<10)
							{
								//Move to the next beam and try to split there
								if(bmAux.length()>bmAuxPosition)
								{
										Beam bmProposedSplit=bmAux[bmAuxPosition];
										Point3d ptProposedPoint=bmProposedSplit.ptCen();
										ptBmCen=ptProposedPoint;
										ptTempShEnd=ptBmCen;
										dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptBmCen));
										bmAuxPosition++;
										nInnerLoop++;
								}
								else
								{
									//no more beams to split on
									break;
								}
							}
						}
						ptBmCen=ptBmCen.projectPoint(plMidY,0);
						ptSplits.append(ptBmCen);
						ptBmCen.vis(2);
						
						ptSheetStart=ptBmCen;
						
						dWaste+=abs(vx.dotProduct(ptBmCen-ptProjected));
						//reportNotice("\n"+dDistanceCheck);
					}
				}
				else
				{
					Line lnMidProfile(ls.ptMid(),vx);
					dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptTempShEnd));
					Point3d ptSplitPoint=lnMidProfile.closestPointTo(ptTempShEnd);
					if((dDistanceCheck-dMinimumLength)>U(0.01))
					{
						double dSetBack=dMinimumLength-dDistanceCheck;
						ptSplitPoint-=dSetBack*vx;
						dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptSplitPoint));
					}			
						
					ptSplits.append(ptSplitPoint);
					ptSheetStart=ptSplitPoint;				
				}
				
				if ((dDistanceCheck-dSheetWNew)>U(0.01))
					nRunSplit=true;
				else
					nRunSplit=false;

				nLoops++;
			}
			
			ptSheetStart.vis(4);
			
			
			//reportNotice("\nSheet Length Original "+dNextSheetLength);
			//reportNotice("\nDistance Check "+dDistanceCheck);
			double a;
			
			if (nFullCover)
			{
				
				if (dDistanceCheck>=dNextSheetLength)
				{
					nBoards++;
					dNextSheetLength=dSLength-dDistanceCheck;
					a=dNextSheetLength;
					//reportNotice("\nSheet Length A "+a);
				}
				else
				{
					dNextSheetLength=dNextSheetLength-dDistanceCheck;
					a=dNextSheetLength;
					//reportNotice("\nSheet Length B "+a);
				}
			}
			else
			{
				nBoards++;
				//dNextSheetLength=dSLength-dDistanceCheck;
				dNextSheetLength=dSLength-dDistanceCheck;
				a=dNextSheetLength;
				//reportNotice("\nSheet Length C "+a);

			}
			
			//dNextSheetLength=dSLength-dDistanceCheck;
			//dNextSheetLength=dNextSheetLength-dDistanceCheck;

			
			//Get any horizontal splits that need to be done
			Point3d ptHorSplits[0];
			double dVertDistanceCheck=dSegHeight;
			int nLoopsV=0;
			Point3d ptTempShEndVert;
			
			while( (dVertDistanceCheck-dSheetHNew)>U(0.01) && nLoopsV<10)
			{
				//Find a point to the maximum height of the sheet
				if(nLoopsV==0)
				{
					ptTempShEndVert=ls.ptStart()+(dSheetHNew*vy);
				}
				else
				{
					ptTempShEndVert=ptTempShEndVert+(dSheetHNew*vy);
				}
											
				//Project point to centre of wall
				Point3d ptProjected=ptTempShEndVert.projectPoint(plMid,0);
				ptProjected.vis();	
				
				Line lnMidProfile(ls.ptMid(),vy);
				dVertDistanceCheck=abs(vy.dotProduct(ls.ptEnd()-ptTempShEndVert));
				Point3d ptSplitPoint=lnMidProfile.closestPointTo(ptTempShEndVert);
				if(dVertDistanceCheck<dMinimumLength)
				{
					double dSetBack=dMinimumLength-dVertDistanceCheck;				
					ptSplitPoint-=dSetBack*vy;
					dVertDistanceCheck=abs(vy.dotProduct(ls.ptEnd()-ptSplitPoint));
				}		
	
				ptSplitPoint.vis();
				ptHorSplits.append(ptSplitPoint);							
				nLoopsV++;
			}
			
						
			//Calculate translation vector for planeProfile
			Vector3d vecAux1=ptZoneOrig-pp.coordSys().ptOrg();
			double dTranslationMagnitude=vecAux1.dotProduct(vz);
			Vector3d vecTranslation=vz*dTranslationMagnitude;
			pp.transformBy(vecTranslation);
			
			/*
			if(dSWidth>dSLength)
			{
				//dSheetHNew=dSWidth;
				//dSheetWNew=dSLength;
				
				//Rotate the coordinate system for horizontal creation of sheets
				CoordSys csRotation=csEl;
				csRotation.setToRotation(90,vz,csEl.ptOrg());
			
				CoordSys csRingNew=csEl;
				csRingNew.transformBy(csRotation);
				pp=PlaneProfile(csRingNew);
				pp.joinRing(pl,false);	
					
			}
			*/
			//Create Sheet and split based on array of split points
			Sheet sh;
			Sheet shTemp[0];
			Sheet shNewSheets[0];
			
			pp.intersectWith(ppSheets);
			
			LineSeg lsWidthNewSheet=pp.extentInDir(vy);
			double dShWidth=abs(vy.dotProduct(lsWidthNewSheet.ptStart()-lsWidthNewSheet.ptEnd()));
			double dShHeight=abs(vx.dotProduct(lsWidthNewSheet.ptStart()-lsWidthNewSheet.ptEnd()));

			//Check if there are any boards less than the minimum waste width, if so remove those boards
			//reportNotice("\n"+dShWidth);
			//reportNotice("\n"+dShHeight);
			
			if (dShWidth-dMinWidthForWaste<U(1))
			{
				//Need to remove the boards as well as remove the area from the planeprofile so its not considered valid sheeting area
				//reportNotice("\n"+"Remove");
				nBoards-=ptSplits.length()+1;
				pp.vis();
				dFloorArea-=pp.area();
				int b=dFloorArea;
			}			
			
			if (dShWidth>U(1) && dShHeight>U(1))
			{
				if(nZone<0)
				{
					sh.dbCreate(pp,dSheetThickness,-1);
					//shThisRow.append(sh);
				}
				else
				{
					sh.dbCreate(pp,dSheetThickness,1);					
					//shThisRow.append(sh);
				}
				sh.realBody().vis(1);
				sh.setColor(nSheetColor);
				sh.setMaterial(sSheetMaterial);
				sh.assignToElementGroup(el,true,nZone,'Z');
		
				
				//Vertical Splits
				if(ptSplits.length()==0) shNewSheets.append(sh);
				for(int s=0;s<ptSplits.length();s++)
				{
					Point3d pt=ptSplits[s];
		
					pt.vis(5);
					Plane pl(pt,vx);
					if(s==0)
					{
						shTemp=sh.dbSplit(pl,dSheetTol);
						shTemp.append(sh);
						shNewSheets.append(shTemp);
					}
					else //Check from second point onwards
					{
						for(int t=0;t<shTemp.length();t++)
						{
							Sheet shT=shTemp[t];
					
							PlaneProfile ppT(csZone);
							ppT=shT.realBody().shadowProfile(plnZone);
							ppT.vis(5);
							if(ppT.pointInProfile(pt)==_kPointInProfile || ppT.pointInProfile(pt)==_kPointOnRing) 
							{
								shTemp.setLength(0);
								shTemp=shT.dbSplit(pl,dSheetTol);
								shNewSheets.append(shTemp);
								shTemp.append(shT);
								
								continue;
							}
							
						}
					}
					for(int t=0;t<shTemp.length();t++)
					{
						shTemp[t].realBody().vis(2);
						shTemp[t].assignToElementGroup(el,true,nZone,'Z');
						//shThisRow.append(shTemp);
					}						
				}
				//Horizontal Splits
				for(int s=0;s<ptHorSplits.length();s++)
				{
					Point3d pt=ptHorSplits[s];
					
					//Move point up by half the distance of the tolerance so we can be left with a full board below (as per generation)
					if(s==0)
					{
						pt.transformBy(dVertSheetTol*0.5*vy);		
					}
					else
					{
						double dMovePoint=(dVertSheetTol*s)+(dVertSheetTol*0.5);
						pt.transformBy(dMovePoint*vy);		
					}
		
					pt.vis(5);
					Plane pl(pt,vy);
					for(int t=0;t<shNewSheets.length();t++)
					{
						Sheet shT=shNewSheets[t];
						shT.dbSplit(pl,dVertSheetTol);
						//shT.dbSplit(pl,0);
					}
				}
			}
			
			shThisRow=shNewSheets;
		}
	
		if (dNextSheetLength<=dMinimumLength)
		{
			//reportNotice("\nNext Sheet Length"+dNextSheetLength);
			dNextSheetLength=0;
			dWaste+=dNextSheetLength;

		}
		
		reportNotice("\n"+shThisRow.length());
		
		for (int i=0; i<shThisRow.length()-1; i++)
		{
			for (int j=i+1; j<shThisRow.length(); j++)
			{
				if (vx.dotProduct(shThisRow[i].ptCen()-ptBL) > vx.dotProduct(shThisRow[j].ptCen()-ptBL))
				{
					shThisRow.swap(i, j);
				}
			}
		}
		
		for (int i=0; i<shThisRow.length(); i++)
		{
			int nDoDiagonal=false;
			reportNotice("\n"+shThisRow[i].solidLength());
			if (i>0 && i<shThisRow.length()-1)
			{
				if(shThisRow[i].solidLength()<(dSheetLength-U(1)))
				{
					shThisRow[i].setColor(1);
					nDoDiagonal=true;
				}
			}
			if (shThisRow[i].solidLength()>(dSheetLength-U(1)))
			{
				shThisRow[i].setColor(1);
				nDoDiagonal=true;
			}
			if (nDoDiagonal)
			{
				PlaneProfile ppSheet=shThisRow[i].profShape();
				LineSeg ls=ppSheet.extentInDir(vx);
				PLine plDraw(ls.ptStart(), ls.ptEnd());
				EntPLine ent;
				ent.dbCreate(plDraw);
				ent.setColor(1);
				ent.assignToElementGroup(el, true, nZone, 'Z');
			}
		}
	
		ptDistStart+=vy*dSWidth;
		nCount++;
	}
	_Map.setInt("ExecutionMode",1);
	
	double dUseArea=dSWidth*dSLength*nBoards;
	
	double dWasteArea=dUseArea-dFloorArea;
	
	dWasteArea=dWasteArea/1000000;
	
	//reportNotice("\nBoards"+nBoards);
	//reportNotice("\nWaste"+dWasteArea);
	
	_Map.setDouble("dWasteArea", dWasteArea);
}//End Execution Mode

double dWasteArea=_Map.getDouble("dWasteArea");

Display dp(1);
dp.dimStyle(sDimStyle);

PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
pl1.addVertex(_Pt0);
pl1.addVertex(_Pt0-vx*U(100));
pl2.addVertex(_Pt0);
pl2.addVertex(_Pt0-vx*U(45)-vy*U(35));
pl3.addVertex(_Pt0);
pl3.addVertex(_Pt0-vx*U(45)+vy*U(35));

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);

String strVal; 
if(dWasteArea<0) dWasteArea=0;
strVal.formatUnit(dWasteArea, 2, 2);

if (nYesNoWaste)
{
	dp.draw(strVal+"m2", _Pt0, vy, -vx, 1, 1.5);
}

_ThisInst.assignToElementGroup(el, true, 0, 'E');






#End
#BeginThumbnail






#End
