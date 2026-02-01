#Version 8
#BeginDescription
Splits battens on a specific zone based on a maximum length while reusing waste for the next row.

Created by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 19.04.2021 - version 1.3
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
_ThisInst.setSequenceNumber(20);

Unit(1,"mm"); // script uses mm
//
String sLocations[] = { T("|Top left|"), T("|Top Right|"), T("|Bottom left|"), T("|Bottom right|")};
PropString sLocation(0, sLocations, T("|Distribution location|"), 0);

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones(0, nValidZones, T("Zone to Redistribute the Battens"));

PropDouble dMaximumLength(0, U(4800), T("Maximum batten length"));
PropDouble dMinimumLength(1, U(100), T("Minimum batten length"));
PropDouble dTrimWasteLength(2, U(4), T("Trim waste length by"));

PropString sFilterMaterial(1, "", T("|Filter Material|"));

String sCutTypes[] = { T("|Angled cut|"), T("|Straight cut|")};
PropString sCutType(2, sCutTypes, T("|Cut orientation|"), 0);
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
int nCutType = sCutTypes.find(sCutType);

//
//double dSWidth=dSheetWidth;
//double dSLength=dSheetLength;


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

	lstPropDouble.append(dMaximumLength);
	lstPropDouble.append(dMinimumLength);
	lstPropDouble.append(dTrimWasteLength);
	
	lstPropString.append(sLocation);
	lstPropString.append(sFilterMaterial);
	lstPropString.append(sCutType);
	
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

int nErase=FALSE;

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
Point3d ptDistributionOrigin = csEl.ptOrg();
Vector3d vecHor = vx;
Vector3d vecVer = vy;

if(nLocation==1 || nLocation == 3) // TR / BR
{ 
	vecHor = -vx;
}

if(nLocation==0 || nLocation == 1) // TL / TR
{ 
	vecVer = -vy;
}

_Pt0=ptElOrg;
	
//Get all the vertical studs that exist in the element
GenBeam genbmAll[]=el.genBeam(0);
Beam bmAll[0];
for(int i=0;i<genbmAll.length();i++)
{
	Beam bm = (Beam)genbmAll[i];
	if ( ! bm.bIsValid()) continue;
	bmAll.append(bm);
}

Beam bmVer[]=vecHor.filterBeamsPerpendicularSort(bmAll);
Point3d ptVerticalCenters[0];
for(int i=0;i<bmVer.length();i++)
{
	Beam bmVerCurr = bmVer[i];
	ptVerticalCenters.append(bmVerCurr.ptCen());
}

String sFilterMat[0];
String sArray = sFilterMaterial;
while (sArray.length()>0 || sArray.find(";",0)>-1)
{
	String sToken = sArray.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sFilterMat.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sArray.find(";",0);
	sArray.delete(0,x+1);
	sArray.trimLeft();	
	if (x==-1)
		sArray = "";	
}

//Get all the battens in the zone
GenBeam genBmToSplit[] = el.genBeam(nZone);

Beam bmToSplit[0];
for (int i = 0; i < genBmToSplit.length(); i++)
{
	Beam bm = (Beam)genBmToSplit[i];
	if ( ! bm.bIsValid()) continue;
	
	String sMyMat = bm.material();
	sMyMat.trimLeft();
	sMyMat.trimRight();
	sMyMat.makeUpper();
	if ((sFilterMat.length() > 0 && sFilterMat.find(sMyMat ,- 1) < 0))
	{
		continue;
	}
	
	bmToSplit.append(bm);
}

//Sort battens vertically
for(int s1=1;s1<bmToSplit.length();s1++)
{
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--)
	{
		if( (bmToSplit[s11].ptCen() - ptDistributionOrigin).dotProduct(vecVer) < (bmToSplit[s2].ptCen() - ptDistributionOrigin).dotProduct(vecVer) )
		{
			bmToSplit.swap(s2, s11);
			s11=s2;
		}
	}
}

//Establish rows of battens
int nRowNumbers[0];

Point3d ptRow;
int nCurrentRowNumber;
Plane plVertical(ptDistributionOrigin, vecHor);
for(int i=0;i<bmToSplit.length();i++)
{
	Beam bm = bmToSplit[i];
	Point3d ptCenOnPlane = bm.ptCen().projectPoint(plVertical, 0);
	if(i==0)
	{
		ptRow = ptCenOnPlane;
		nCurrentRowNumber = 0;
		nRowNumbers.append(nCurrentRowNumber);
		continue;
	}
	
	//Check if the point of the beam is near ptRow
	if((ptCenOnPlane - ptRow).length() <= U(0.01))
	{ 
		//Beam in same row as previous
		nRowNumbers.append(nCurrentRowNumber);
		continue;
	}
	
	//Beam in new row
	nCurrentRowNumber++;
	ptRow = ptCenOnPlane;
	nRowNumbers.append(nCurrentRowNumber);
}

//Horizontally sort beams in their rows
if (nRowNumbers.length() > 0)
{
	int nMaximumRowNumber = nRowNumbers[nRowNumbers.length() - 1];
	
	for (int rowNumber = 0; rowNumber <= nMaximumRowNumber; rowNumber++)
	{
		Beam bmsForRow[0];
		int indexForBeamInRow[0];
		for (int j = 0; j < nRowNumbers.length(); j++)
		{
			if (nRowNumbers[j] != rowNumber) continue;
			bmsForRow.append(bmToSplit[j]);
			indexForBeamInRow.append(j);
		}
		
		for (int s1 = 1; s1 < indexForBeamInRow.length(); s1++)
		{
			int s11 = s1;
			for (int s2 = s1 - 1; s2 >= 0; s2--)
			{
				if ( (bmToSplit[s11].ptCen() - ptDistributionOrigin).dotProduct(vecHor) < (bmToSplit[s2].ptCen() - ptDistributionOrigin).dotProduct(vecHor) )
				{
					bmToSplit.swap(s2, s11);
					//No need to sort the nRowNumbers because we should be dealing with just one row number.
					s11 = s2;
				}
			}
		}
		
	}
}


//Build up split points for each row
int nSplitPointRowNumbers[0];
Point3d ptSplitPoints[0];
Beam bmSplitPointBeams[0];  // Beam to do the split on
nCurrentRowNumber = 0;

double dRemainingLengthFromMaximum;
for (int i = 0; i < bmToSplit.length(); i++)
{
	Beam bm = bmToSplit[i];
	Plane plBmCen(bm.ptCen(), vecVer);
	
	// With 45 degree angle cuts we need to reduce the distance where the point is going to lie from the maximum
	double splitBmHeight = bm.dD(vecVer);
	double dOriginalMaximumLengthAdjusted = dMaximumLength - (splitBmHeight * 0.5);
	double dMaximumLengthAdjusted = dOriginalMaximumLengthAdjusted;
	
	int& nRowNumber = nRowNumbers[i];
	int bOnNewRow = FALSE;
	if (nCurrentRowNumber != nRowNumber)
	{
		//We are on a new row - need to flag to check for waste
		nCurrentRowNumber = nRowNumber;
		bOnNewRow = dRemainingLengthFromMaximum > 0;
		dRemainingLengthFromMaximum = dRemainingLengthFromMaximum - dTrimWasteLength;
	}
	
	bm.realBody().vis();
	
	//If we are using angle cuts then the maximum length is going to be 
	double dTest = bm.vecX().dotProduct(vecHor);
	double dSolidLength = bm.solidLength();
	double dHorLength =  dTest > U(0.99) || dTest < U(-0.99)  ? dSolidLength : bm.dD(vecHor);
	if(dSolidLength <= dMaximumLength)
	{ 
		//No splits required
		if(dRemainingLengthFromMaximum > 0)
		{ 
			//Previous beam had a length less than the max length, so no splits were required
			dRemainingLengthFromMaximum = dRemainingLengthFromMaximum - dSolidLength;  //Use remaining length in next row
		}
		else
		{ 
			dRemainingLengthFromMaximum = dMaximumLengthAdjusted - dSolidLength;  //Use remaining length in next row
		}
		continue;
	}
	
	//Find split points
	Point3d ptBmStart = bm.ptCen() - vecHor * dHorLength * 0.5;
	Point3d ptBmEnd = bm.ptCen() + vecHor * dHorLength * 0.5;
	
	double dRemainingLength = dHorLength;
	Point3d ptSplitPoint = ptBmStart;
	int nLoopCount = 0;
	
	while(dRemainingLength > dMaximumLengthAdjusted && nLoopCount < 50)
	{ 
		//If we are on the next loop then the dMaximumLengthAdjusted needs to increase because you have a cut at the start and a cut at the end
		if(nLoopCount==1)
		{ 
			dMaximumLengthAdjusted -= (splitBmHeight * 0.5);
		}
		
		Point3d ptNewSplitPoint = bOnNewRow ? ptSplitPoint + vecHor * dRemainingLengthFromMaximum :  ptSplitPoint + vecHor * dMaximumLengthAdjusted;
		
		ptNewSplitPoint.vis(0);
		if (bOnNewRow) bOnNewRow = FALSE;
		
		//Find nearest stud to split on
		int nStudSplitIndex = - 1;
		int nSafetyCounter = 0;
		for (int j = 0; j < ptVerticalCenters.length(); j++)
		{
			Point3d& ptVertical = ptVerticalCenters[j];
			Vector3d vecAux = ptVertical - ptNewSplitPoint;
			if(vecAux.dotProduct(vecHor) > U(0.01) && j > 0)
			{ 
				//Previous point is the nearest split point
				nStudSplitIndex = j - 1;
				ptNewSplitPoint = ptVerticalCenters[nStudSplitIndex];
				ptNewSplitPoint = ptNewSplitPoint.projectPoint(plBmCen, 0);
				
				if((ptNewSplitPoint - ptBmStart).dotProduct(vecHor) < dMinimumLength && nSafetyCounter < 50)
				{ 
					//Piece that is going to be created is too small
					ptNewSplitPoint = ptSplitPoint + vecHor * dMaximumLengthAdjusted;
					j = 0;
					nSafetyCounter++;
					continue;
				}
				break;
			}
		}
		
		//Check if the previous row's split points lie at the same point we intend to split on
		for (int j = 0; j < nSplitPointRowNumbers.length(); j++)
		{ 
			int& nSplitPointRowNumber = nSplitPointRowNumbers[j];
			if (nSplitPointRowNumber != nRowNumber - 1) continue;
			
			Point3d& ptPreviousRowSplitPoint = ptSplitPoints[j];
			Vector3d vecAux = ptPreviousRowSplitPoint - ptNewSplitPoint;
			if(vecAux.dotProduct(vecHor) < U(0.01) && vecAux.dotProduct(vecHor) > U(-0.01) && nStudSplitIndex > 0)
			{ 
				//Current split point is in the same line as the previous row's split point
				ptNewSplitPoint = ptVerticalCenters[nStudSplitIndex - 1];
				ptNewSplitPoint = ptNewSplitPoint.projectPoint(plBmCen, 0);
				break;
			}
		}
		
		dRemainingLength = (ptBmEnd - ptNewSplitPoint).dotProduct(vecHor);
		dRemainingLengthFromMaximum = dOriginalMaximumLengthAdjusted - dRemainingLength;
		
		if (dRemainingLength < U(0.01)) break; // split point is at edge of beam
		
		int bLastPieceRedefined = FALSE;
		if (dRemainingLength < dMinimumLength)
		{
			//The last piece is too small and we need to get another split point
			ptNewSplitPoint = ptBmEnd - vecHor * dMinimumLength;
			
			//Find nearest stud to split on
			for (int j = 0; j < ptVerticalCenters.length(); j++)
			{
				Point3d & ptVertical = ptVerticalCenters[j];
				Vector3d vecAux = ptVertical - ptNewSplitPoint;
				if (vecAux.dotProduct(vecHor) > U(0.01) && j > 0)
				{
					//Previous point is the nearest split point
					nStudSplitIndex = j - 1;
					ptNewSplitPoint = ptVerticalCenters[nStudSplitIndex];
					ptNewSplitPoint = ptNewSplitPoint.projectPoint(plBmCen, 0);
					break;
				}
			}
			
			//Check if the previous row's split points lie at the same point we intend to split on
			for (int j = 0; j < nSplitPointRowNumbers.length(); j++)
			{
				int & nSplitPointRowNumber = nSplitPointRowNumbers[j];
				if (nSplitPointRowNumber != nRowNumber - 1) continue;
				
				Point3d & ptPreviousRowSplitPoint = ptSplitPoints[j];
				Vector3d vecAux = ptPreviousRowSplitPoint - ptNewSplitPoint;
				if (vecAux.dotProduct(vecHor) < U(0.01) && vecAux.dotProduct(vecHor) > U(-0.01) && nStudSplitIndex > 0)
				{
					//Current split point is in the same line as the previous row's split point
					ptNewSplitPoint = ptVerticalCenters[nStudSplitIndex - 1];
					ptNewSplitPoint = ptNewSplitPoint.projectPoint(plBmCen, 0);
					break;
				}
			}
			
			dRemainingLength = (ptBmEnd - ptNewSplitPoint).dotProduct(vecHor);
			dRemainingLengthFromMaximum = dOriginalMaximumLengthAdjusted - dRemainingLength;
			
			bLastPieceRedefined = TRUE;
		}
		
		ptNewSplitPoint.vis(nLoopCount + 1);
		
		nSplitPointRowNumbers.append(nRowNumber);
		ptSplitPoints.append(ptNewSplitPoint);
		bmSplitPointBeams.append(bm);
		
		nLoopCount++;
		ptSplitPoint = ptNewSplitPoint;
		
		if(dRemainingLengthFromMaximum < dMinimumLength) 
		{ 
		 	//Waste too small to reuse
		 	dRemainingLengthFromMaximum = 0;
		}
		
		//Last piece has already been sorted out
		if (bLastPieceRedefined) break;
	}
}

//Do splits
Beam bmAlreadySplit[0];
for(int i=0;i<bmSplitPointBeams.length();i++)
{
	Beam bm = bmSplitPointBeams[i];
	if (bmAlreadySplit.find(bm) != -1) continue; //Beam already split
	
	Point3d ptSplitsForBeam[0];
	for (int j = 0; j < ptSplitPoints.length(); j++)
	{
		if (bmSplitPointBeams[j] != bm) continue;
		Point3d & ptSplitPoint = ptSplitPoints[j];
		ptSplitsForBeam.append(ptSplitPoint);
	}
	
	Beam splitBeam = bm;
	for (int j = 0; j < ptSplitsForBeam.length(); j++)
	{
		Point3d& ptSplit = ptSplitsForBeam[j];
		Beam returnedBeam = splitBeam.dbSplit(ptSplit, ptSplit, vecHor);
		
		//Add cuts to the beams
		Vector3d vCut = vecHor + vecVer;
		if (nCutType==1)
		{ 
			vCut = vecHor;
			
		}
		vCut.normalize();
		Plane plCut(ptSplit, vCut);
		Cut ctEnd(plCut, ptSplit + vecHor, 1);
		splitBeam.addToolStatic(ctEnd, _kStretchOnInsert);
		
		Cut ctStart(plCut, ptSplit - vecHor, 1);
		returnedBeam.addToolStatic(ctStart, _kStretchOnInsert);
		
		splitBeam = returnedBeam;
	}
	
	bmAlreadySplit.append(bm);
}

if (genbmAll.length() > 0) nErase = TRUE;

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
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End