#Version 8
#BeginDescription
Distributes the sheet above and below openings depending on width and height of available sheets.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 18.09.2017 version 1.3



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
*  Copyright (C) 2017 by
*  hsbcad 
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*/

Unit(1,"mm"); // script uses mm

String sLocations[] = { T("|Top left|"), T("|Top Right|"), T("|Bottom left|"), T("|Bottom right|")};
PropString sLocation(0, sLocations, T("|Distribution location|"), 0);

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones(0, nValidZones, T("Zone to Redistribute the Sheets"));

PropDouble dSheetWidth(0, U(600), T("Sheeting Width"));
PropDouble dSheetLength(1, U(2400), T("Sheeting Length"));

PropDouble dSheetThickness(2, U(22), T("Sheeting Thickness"));

PropDouble dMinimumLength(3, U(100), T("Minimum sheet length"));

PropDouble dMinimumWidth(4, U(150), T("Mininum sheet width"));

PropDouble dTrimWasteLength(5, U(4), T("Trim waste length by"));

//
//String sArYesNo[] = {T("No"), T("Yes")};
//PropString strYNWaste (1,sArYesNo,T("Show Waste"), 0);
//

if (_bOnDbCreated)
{
	setPropValuesFromCatalog(_kExecuteKey);
}

int nZone=nRealZones[nValidZones.find(nZones)];
int nLocation = sLocations.find(sLocation);

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
	
//	_Pt0 = getPoint(T("Start distribution point"));
	
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
	lstPropDouble.append(dMinimumWidth);
	lstPropDouble.append(dTrimWasteLength);
	
	lstPropString.append(sLocation);
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);
	
	for( int e=0; e<_Element.length(); e++ )
	{
		lstElements.setLength(0);
		lstElements.append(_Element[e]);
		
//		lstPoints.append(_Pt0);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	_Map.setInt("ExecutionMode",0);
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



double dWaste=0;
int nBoards=0;

Vector3d vecHorizontalDistributionDirection = vx;
if(nLocation==1 || nLocation == 3) // TR / BR
{ 
	vecHorizontalDistributionDirection = -vx;
}

if (nExecutionMode==0)
{
	_Pt0=ptElOrg;
	
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
	
	CoordSys csZone(ptZoneOrig, vx, vy, vz);
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
	
	Point3d ptBR=Line(ptBL, vx).closestPointTo(Line(ptTR, vy));
	Point3d ptTL=Line(ptTR, vx).closestPointTo(Line(ptBL, vy));
	
	ptBL.vis(1);
	ptBR.vis(1);
	ptTL.vis(1);
	ptTR.vis(1);
	
	double dDistToOrg=abs(vy.dotProduct(ptTR-ptBL));
	
	Point3d ptDistStart;
	Point3d ptDistEnd;
	if(nLocation==0)
	{ 
		ptDistStart = ptTL;
		ptDistEnd = ptBR;
	}
	else if (nLocation == 1)
	{ 
		ptDistStart = ptTR;
		ptDistEnd = ptBL;
	}
	else if (nLocation == 2)
	{ 
		ptDistStart = ptBL;
		ptDistEnd = ptTR;
	}
	else
	{ 
		ptDistStart = ptBR;
		ptDistEnd = ptTL;
	}
	
	_Pt0=ptDistStart;
	
	
	Vector3d vecVerticalDistributionDirection = vy;
	if(nLocation==0 || nLocation==1) // TL / TR
	{ 
		vecVerticalDistributionDirection = -vy;
	}
	ptDistStart.vis(2);
	
	int nCount=0;
	
	Point3d ptElMid=ptElOrg-(dWallDepth*0.50)*vz;
	ptElOrg.vis(3);
	ptElMid.vis();
	Plane plMid(ptElMid,vz);
	
	//Get all vertical sheet splits
	Point3d ptVerticalSheetSplits[0];
	Point3d ptVerticalRowStart = ptDistStart;
	Beam previousBeamSplits[0];
	
	while(true && nCount < 50)
	{ 
		//Get point for with of board
		Point3d ptPotentialSplit = ptVerticalRowStart + vecHorizontalDistributionDirection * dSWidth;
		ptPotentialSplit = Line(ptPotentialSplit, vecVerticalDistributionDirection).closestPointTo(Line(ptDistEnd, vecHorizontalDistributionDirection));
		ptPotentialSplit.vis(1);
		
		if((ptDistEnd - ptPotentialSplit).dotProduct(vecHorizontalDistributionDirection) < 0 )
		{ 
			double lastSheetWidth;
			if(ptVerticalSheetSplits.length() > 0)
			{ 
				lastSheetWidth = (ptDistEnd - ptVerticalSheetSplits[ptVerticalSheetSplits.length() - 1]).dotProduct(vecHorizontalDistributionDirection);
			}
			else
			{ 
				lastSheetWidth = (ptDistEnd - ptDistStart).dotProduct(vecHorizontalDistributionDirection);
			}
		
			//Check the width of the last sheet to see if it is too small
			if(lastSheetWidth - dMinimumWidth < U(-0.01))
			{ 
				//Shrink previous column, if exists & if possible as it too may become too small
				if(ptVerticalSheetSplits.length() > 0 && previousBeamSplits.length()  > 2)
				{
					Point3d ptNewVerticalSplitPositionForPreviousColumn = previousBeamSplits[previousBeamSplits.length() - 2].ptCen();

					//Check the new size of the previous column
					double newWidthOfPreviousColumn;
					if(ptVerticalSheetSplits.length() == 1)
					{ 
						newWidthOfPreviousColumn = (ptNewVerticalSplitPositionForPreviousColumn - ptDistStart).dotProduct(vecHorizontalDistributionDirection);
					}
					else
					{ 
						newWidthOfPreviousColumn = (ptNewVerticalSplitPositionForPreviousColumn - previousBeamSplits[0].ptCen()).dotProduct(vecHorizontalDistributionDirection);
					}
					
					if(newWidthOfPreviousColumn - dMinimumWidth > U(-0.01))
					{ 
						//Redefine previous column's split position
						ptVerticalSheetSplits[ptVerticalSheetSplits.length() - 1] = ptNewVerticalSplitPositionForPreviousColumn;
					}
				}
			}
			
			//Gone past end of distribution point
			break;
		}
		
		LineSeg lsDiagonal(ptVerticalRowStart, ptPotentialSplit);
		Plane plPotentialSplit(ptPotentialSplit, vecHorizontalDistributionDirection);
		Plane plStart(ptVerticalRowStart, vecHorizontalDistributionDirection);
		
		Point3d ptProjectedPotentialSplit=lsDiagonal.ptMid().projectPoint(plPotentialSplit, 0).projectPoint(plMid,0);
		Point3d ptProjectedStart =lsDiagonal.ptMid().projectPoint(plStart, 0).projectPoint(plMid,0);
		ptProjectedStart.vis();
		//		ptProjectedPotentialSplit.vis();
		if(bmVer.length()>0)
		{
			Beam bmAux[]=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptProjectedPotentialSplit, -vecHorizontalDistributionDirection);
			
			bmAux=(-vecHorizontalDistributionDirection).filterBeamsPerpendicularSort(bmAux);
			
			if(bmAux.length()>0)
			{
				Beam bmSheetSplit=bmAux[0];
				
				Plane plProjected(ptProjectedPotentialSplit,vz);
				PlaneProfile ppBmSheetSplit=bmSheetSplit.realBody().shadowProfile(plProjected);
				previousBeamSplits = Beam().filterBeamsHalfLineIntersectSort(bmAux, ptProjectedStart, vecHorizontalDistributionDirection);
				
				//Need to check where the projected point lies as it could be inside a beam and past or on the centre point of the beam
				if(ppBmSheetSplit.pointInProfile(ptProjectedPotentialSplit)!=_kPointOutsideProfile )
				{
					Vector3d vecDistanceToSheetSplit=bmSheetSplit.ptCen()-ptProjectedPotentialSplit;
					double dDistToSheetSplit=vecDistanceToSheetSplit.dotProduct(vecHorizontalDistributionDirection);
					//reportNotice("\n SSS "+dDistToSheetSplit);
					
					if(dDistToSheetSplit>U(0.01))//AJ v1.4
					{
						if(bmAux.length()>1)
						{
							//Check if new beam found is the same as the previous beam
							if(bmSheetSplit.handle()!=bmAux[1].handle())
							{
								bmSheetSplit=bmAux[1];
								//It should have something in it
								if(previousBeamSplits.length() > 0) previousBeamSplits.removeAt(0);
							}
						}
					}
				}
				
				bmSheetSplit.realBody().vis();
				
				Point3d ptBmCen=bmSheetSplit.ptCen();
				//Check the width of the sheet to see if it is too small
				if((ptBmCen - ptVerticalRowStart).dotProduct(vecHorizontalDistributionDirection) - dMinimumWidth < U(-0.01))
				{ 
					//Shrink previous column, if exists & if possible as it too may become too small
					if(ptVerticalSheetSplits.length() > 0 && previousBeamSplits.length()  > 2)
					{
						Point3d ptNewVerticalSplitPositionForPreviousColumn = previousBeamSplits[previousBeamSplits.length() - 2].ptCen();

						//Check the new size of the previous column
						double newWidthOfPreviousColumn;
						if(ptVerticalSheetSplits.length() == 1)
						{ 
							newWidthOfPreviousColumn = (ptNewVerticalSplitPositionForPreviousColumn - ptDistStart).dotProduct(vecHorizontalDistributionDirection);
						}
						else
						{ 
							newWidthOfPreviousColumn = (ptNewVerticalSplitPositionForPreviousColumn - previousBeamSplits[0].ptCen()).dotProduct(vecHorizontalDistributionDirection);
						}
						
						if(newWidthOfPreviousColumn - dMinimumWidth > U(-0.01))
						{ 
							//Redefine previous column's split position
							ptVerticalSheetSplits[ptVerticalSheetSplits.length() - 1] = ptNewVerticalSplitPositionForPreviousColumn;
						}
					}
				}
				
				ptVerticalSheetSplits.append(ptBmCen);
				ptVerticalRowStart = ptBmCen;
			}
		}
		else
		{ 
			break;
		}
		
		nCount++;
	}
	
	//Reset counter
	nCount = 0;
	
	//Define column boundaries
	Point3d ptColumnStarts[0];
	Point3d ptColumnEnds[0];
	if(ptVerticalSheetSplits.length() > 0)
	{ 
		ptColumnStarts.append(ptDistStart);
		ptColumnEnds.append(ptVerticalSheetSplits[0]);
		
		
		for(int i=0;i<ptVerticalSheetSplits.length() - 1; i++)
		{
			Point3d& ptVerticalSheetSplit = ptVerticalSheetSplits[i];
			Point3d& ptNextVerticalSheetSplit = ptVerticalSheetSplits[i + 1];
			
			ptColumnStarts.append(ptVerticalSheetSplit);
			ptColumnEnds.append(ptNextVerticalSheetSplit);
		}
		
		ptColumnStarts.append(ptVerticalSheetSplits[ptVerticalSheetSplits.length() - 1]);
		ptColumnEnds.append(ptDistEnd);
	}
	else
	{ 
		ptColumnStarts.append(ptDistStart);
		ptColumnEnds.append(ptDistEnd);
	}
	
	//Horizontal splits
	int nColumns[0];
	Point3d ptHorizontalSplits[0];
	PlaneProfile ppSheetColumns[0];
	
	double previousColumnLastBoardLength = -1;
	double wasteBoardLength = -1;
	int bUsePreviousColumnLastBoardLength = FALSE;
	for(int i=0;i<ptColumnStarts.length();i++)
	{
		Point3d& ptColumnStart = ptColumnStarts[i];
		Point3d& ptColumnEnd = ptColumnEnds[i];
		
		//Create big rectangle and intersect with sheets to find bounds
		PLine plBigRect;
		plBigRect.createRectangle(LineSeg(ptColumnStart - vecVerticalDistributionDirection * U(10000), ptColumnEnd + vecVerticalDistributionDirection * U(10000)), vecHorizontalDistributionDirection, vecVerticalDistributionDirection);
		
		PlaneProfile ppSheetColumn(csZone);
		ppSheetColumn.joinRing(plBigRect, FALSE);
		ppSheetColumn.intersectWith(ppSheets);
		ppSheetColumns.append(ppSheetColumn);
		
		LineSeg lsSheetColumn = ppSheetColumn.extentInDir(vecVerticalDistributionDirection);
		Point3d ptSheetColumnStart = lsSheetColumn.ptStart();
		Point3d ptSheetColumnEnd = lsSheetColumn.ptEnd();
		Point3d ptSheetColumnMid = lsSheetColumn.ptMid();
		Plane plMidColumn(ptSheetColumnMid, vecHorizontalDistributionDirection);
		
		Point3d ptTempHorizontalSplits[0];
		
		double dColumnLength = (ptSheetColumnEnd - ptSheetColumnStart).dotProduct(vecVerticalDistributionDirection);
		Point3d ptFullBoardStart = ptSheetColumnStart.projectPoint(plMidColumn, 0);
		if(wasteBoardLength != -1)
		{ 
			//Reusable waste
			Point3d ptSplit;
			ptSplit = (ptFullBoardStart + vecVerticalDistributionDirection * (wasteBoardLength));
			ptTempHorizontalSplits.append(ptSplit);
			
			//Redefine column length to start from the end of the waste board
			dColumnLength = dColumnLength - wasteBoardLength;
			ptFullBoardStart = ptSplit;
		}
		
		if(bUsePreviousColumnLastBoardLength && previousColumnLastBoardLength != -1)
		{ 
			//Last board
			Point3d ptSplit;
			ptSplit = (ptFullBoardStart + vecVerticalDistributionDirection * (previousColumnLastBoardLength));
			ptSplit.vis(i);
			ptTempHorizontalSplits.append(ptSplit);
			
			//Redefine column length to start from the end of the waste board
			dColumnLength = dColumnLength - previousColumnLastBoardLength;
			ptFullBoardStart = ptSplit;
			
			bUsePreviousColumnLastBoardLength = FALSE;
		}
		
		double boards = dColumnLength/dSLength;
		int nNumberOfFullBoards = (int)boards; 
		double lastBoardLength = dColumnLength - (nNumberOfFullBoards * dSLength);
		
		for(int j = 1 ; j <= nNumberOfFullBoards; j++)
		{ 
			Point3d ptSplit;
			ptSplit = (ptFullBoardStart + vecVerticalDistributionDirection * (dSLength * j));
			ptTempHorizontalSplits.append(ptSplit);
		}
		
		if(lastBoardLength < dMinimumLength && lastBoardLength > U(0.01))
		{ 
			//Last board smaller than min, shorten previous full sheet (if any)
			if(ptTempHorizontalSplits.length() > 0 )
			{ 
				Point3d& ptLast = ptTempHorizontalSplits[ptTempHorizontalSplits.length() - 1];
				ptLast.transformBy( abs(dMinimumLength - lastBoardLength) * - vecVerticalDistributionDirection);
			}
			
			lastBoardLength = dMinimumLength;
		}
		
		//Check if last boards is the size of a full board
		double remainingBoardLength =abs(lastBoardLength - dSLength) - dTrimWasteLength; 
		if(remainingBoardLength < U(0.01))
		{ 
			//Last board is a full board
			wasteBoardLength = -1;
		}
		else if( remainingBoardLength - dMinimumLength < U(-0.01))
		{ 
			//Waste too small to start next column, start next column with last board length
			bUsePreviousColumnLastBoardLength = TRUE;
			wasteBoardLength = -1;
		}
		else
		{ 
			wasteBoardLength = remainingBoardLength;
		}
		
		previousColumnLastBoardLength = lastBoardLength;
		for(int j = 0 ; j < ptTempHorizontalSplits.length() ; j++)
		{ 
			Point3d& ptHorizontalSplit =ptTempHorizontalSplits[j];
			ptHorizontalSplit.vis(i);
			ptHorizontalSplits.append(ptHorizontalSplit);
			nColumns.append(i);
		}
	}
	
	//Do splits
	for(int i = 0 ; i < ptColumnStarts.length() ; i++)
	{ 
		PlaneProfile& ppSheetColumn = ppSheetColumns[i];
		Sheet sh;
		if(nZone<0)
		{
			sh.dbCreate(ppSheetColumn,dSheetThickness,-1);
		}
		else
		{
			sh.dbCreate(ppSheetColumn,dSheetThickness,1);
		}
		sh.realBody().vis(1);
		sh.setColor(nSheetColor);
		sh.setMaterial(sSheetMaterial);
		sh.assignToElementGroup(el,true,nZone,'Z');
		
		Sheet shNewSheets[] = { sh };
		for(int j = 0 ; j < nColumns.length() ; j++)
		{ 
			int& nColumn = nColumns[j];
			if(nColumn!=i) continue;
			
			Point3d& ptHorizontalSplit = ptHorizontalSplits[j];
			Plane pl(ptHorizontalSplit, vecVerticalDistributionDirection);
			
			for(int x = 0 ; x < shNewSheets.length() ; x++)
			{ 
				shNewSheets.append(shNewSheets[x].dbSplit(pl, 0));
			}
		}
	}
}	

Display dp(1);

PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
pl1.addVertex(_Pt0);
pl1.addVertex(_Pt0-vecHorizontalDistributionDirection*U(100));
pl2.addVertex(_Pt0);
pl2.addVertex(_Pt0-vecHorizontalDistributionDirection*U(45)-vy*U(35));
pl3.addVertex(_Pt0);
pl3.addVertex(_Pt0-vecHorizontalDistributionDirection*U(45)+vy*U(35));

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);

_Map.setInt("ExecutionMode",1);
_ThisInst.assignToElementGroup(el, true, 0, 'E');
#End
#BeginThumbnail












#End