#Version 8
#BeginDescription
Shows a table of edge data for SIPs along with numbering of edges

Modified by: Mihai Bercuci
Date: 09.02.2018  -  version 1.6

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2014 by
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
* Created by: Chirag Sawjani
* date: 11.08.2014
* version 1.0: Release Version
*
* Modified by: Chirag Sawjani
* date: 20.08.2014
* version 1.1: Added property for ofsetting text on edges towards the inside of the SIP
*
* Modified by: Chirag Sawjani
* date: 12.03.2015
* version 1.3: Added letters for edges
*
* Modified by: Chirag Sawjani
* date: 15.05.2015
* version 1.4: Added projection of pockets to table
*
* Modified by: Chirag Sawjani
* date: 20.05.2015
* version 1.5: Lengths are now rounded up to the next mm
*/

U(1,"mm");

String sNumberingModes[] = {T("Numbers"), T("Letters")};

PropString sDimStyle(0,_DimStyles, "Dim Style");
PropString sNumberingMode(1, sNumberingModes, "Numbering mode", 0);

PropInt nColor(0,3,"Color");

PropDouble dOffset(0, U(60), "Edge Offset");
PropDouble dEdgeTextHeight(1, 0, "Edge Text Height");

int nNumberingMode=sNumberingModes.find(sNumberingMode);

if( _bOnInsert ){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	showDialog();

	_Pt0=getPoint("Pick a point");
	_Viewport.append(getViewport(T("Select a viewport")));
	
	return;
}

if( _Viewport.length()==0 ){eraseInstance(); return;}

Viewport vp = _Viewport[0];

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

Point3d ptDraw=_Pt0;
Display dp(nColor);
dp.dimStyle(sDimStyle);

Display dpEdge(nColor);
dpEdge.dimStyle(sDimStyle);
if(dEdgeTextHeight > 0)
{
	dpEdge.textHeight(dEdgeTextHeight);
}

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps

Element el = vp.element();

//Collect the elements and the Vectors
CoordSys cdEl = el.coordSys();
Vector3d vx = cdEl.vecX();
Vector3d vy = cdEl.vecY();
Vector3d vz = cdEl.vecZ();
Point3d ptEl = cdEl.ptOrg();
//cdEl.vis();

Vector3d vXTxt = vx; vXTxt.transformBy(ms2ps);
Vector3d vYTxt = vy; vYTxt.transformBy(ms2ps);
Vector3d vecRead=-vx;
vecRead.transformBy(ms2ps);
vecRead.normalize();

Sip sp[]=el.sip();

Point3d ptCentreOfEdges[0];
double dEdgeLengths[0];
double dEdgeBevelAngle[0];

double dProjectedSegmentLength[0];
String sipReference[0];

for(int s=0;s<sp.length();s++)
{
	Sip sipCurr=sp[s];
	SipEdge spEdges[]=sipCurr.sipEdges();
	for(int e=0;e<spEdges.length();e++)
	{
		SipEdge edge=spEdges[e];
		Vector3d normal=edge.vecNormal();
		//normal.vis(edge.ptMid(), 3);
	}
}



for(int s=0;s<sp.length();s++)
//for(int s=2;s<3;s++)
{

	Sip sipCurr=sp[s];
	SipEdge spEdges[]=sipCurr.sipEdges();
		//Get the length of the edge on the front face
	PLine plCncEnvelope=sipCurr.plShadowCnc();

	Point3d ptVertices[]=plCncEnvelope.vertexPoints(false);
	
	if (ptVertices.length()<1) continue;
	
	Plane plnZ(ptVertices[0], vz);
	
	LineSeg cncSegments[0];
	Vector3d vecSegments[0];
	for(int v=0;v<ptVertices.length()-1;v++)
	{
	
		Point3d ptStartSegment=ptVertices[v];
		Point3d ptEndSegment=ptVertices[v+1];
		LineSeg lnSeg(ptStartSegment, ptEndSegment);
		Vector3d vecSegment=ptEndSegment-ptStartSegment;

		cncSegments.append(lnSeg);
		vecSegments.append(vecSegment);
	}
	
	if(cncSegments.length() <=2)
	{
		continue;
	}	
	
	LineSeg cncSegmentsTemp[0];
	for(int v=0;v<cncSegments.length();v++)
	{
		cncSegmentsTemp.append(cncSegments[v]);
	}
	cncSegmentsTemp.append(cncSegments[0]);
	cncSegmentsTemp.append(cncSegments[1]);
	
	LineSeg cncProjectableSegments[0];
	Vector3d vecProjectableSegments[0];
	for(int v=1;v<cncSegmentsTemp.length()-1;v++)
	{
		LineSeg lsCurr = cncSegmentsTemp[v];
		int nPreviousPassed = false;
		int nNextPassed = false;
		//Previous
		{
			LineSeg lsSeg1=cncSegmentsTemp[v-1];
			LineSeg lsSeg2=lsCurr;
			Vector3d vecSegment1 = lsSeg1.ptEnd() - lsSeg1.ptStart();
			Vector3d vecSegment2 = lsSeg2.ptEnd() - lsSeg2.ptStart();
			double dAngleBetweenVectors = vecSegment2.angleTo(vecSegment1, vz);
			if(dAngleBetweenVectors > 91)
			{
				nPreviousPassed = true;
			}
		}
		//Next
		{
			LineSeg lsSeg1=lsCurr ;
			LineSeg lsSeg2=cncSegmentsTemp[v+1];
			Vector3d vecSegment1 = lsSeg1.ptEnd() - lsSeg1.ptStart();
			Vector3d vecSegment2 = lsSeg2.ptEnd() - lsSeg2.ptStart();
			double dAngleBetweenVectors = vecSegment2.angleTo(vecSegment1, vz);
			if(dAngleBetweenVectors > 91)
			{
				nNextPassed = true;
			}
		}
		
		if(nPreviousPassed && nNextPassed )
		{
			//lsCurr .vis(v);
			cncProjectableSegments.append(lsCurr);
		}
	}	
			
	for(int v=0;v<cncSegments.length();v++)
	{
		LineSeg lsSeg=cncSegments[v];
		Vector3d vecSegment = vecSegments[v];
		Line lnSegment(lsSeg.ptMid(), vecSegment);
		
		double dSegmentLength=vecSegment.length();
		Point3d ptMidSegment=lsSeg.ptMid();
		
		vecSegment.normalize();
		
		Vector3d vecNormalToSegment=vecSegment.crossProduct(vz);
		lsSeg.vis(v);
		//vecNormalToSegment.vis(lnSeg.ptMid(), v);
		
		//Find the edge where the vectors are aligned
		SipEdge spAlignedEdge;
		
 		Point3d ptEdgeStart;
		Point3d ptEdgeEnd;
		Point3d ptEdgeMid;
		Vector3d vecN;
		
		double dMinDistance=U(1500000);
		
		int nExistsInProjectableSegments = -1;
		for(int i = 0; i < cncProjectableSegments.length(); i++)
		{
			if((cncProjectableSegments[i].ptMid() - ptMidSegment).length() < U(0.01))
			{
				cncProjectableSegments[i].vis(4);
				nExistsInProjectableSegments = i;
				break;
			}
		}
		
		
		Point3d projectedPoints[0];
		if(nExistsInProjectableSegments != -1)
		{
			//Check if next and previous segments exist
			int previousIndex=nExistsInProjectableSegments -1;
			LineSeg previousProjectableSegment;
			LineSeg nextProjectableSegment;
			
			if(previousIndex >= 0)
			{
				previousProjectableSegment = cncProjectableSegments[previousIndex];
			}
			else if (previousIndex ==cncProjectableSegments.length()-1)
			{
				previousProjectableSegment = cncProjectableSegments[0];
			}
			else
			{
				previousProjectableSegment = cncProjectableSegments[cncProjectableSegments.length()-1];
			}
			
			int nextIndex = nExistsInProjectableSegments+1;
			if(nextIndex < cncProjectableSegments.length())
			{
				nextProjectableSegment = cncProjectableSegments[nextIndex ] ;
			}
			else
			{
				nextProjectableSegment = cncProjectableSegments[0] ;
			}
			
			
			LineSeg tempSegments[] ={previousProjectableSegment, nextProjectableSegment};
			for(int c=0;c<tempSegments.length();c++)
			{
				LineSeg lsAuxSegment = tempSegments[c];
				Vector3d vecAux = lsAuxSegment.ptEnd() - lsAuxSegment.ptStart();
				lsAuxSegment.vis(v);
	 			Line lnAux(lsAuxSegment .ptMid(), vecAux);
				vecAux.normalize();
				vecSegment.normalize();
				
				if(abs(vecAux.dotProduct(vecSegment) > U(0.99)))
				{
					continue;
				}
						
	  	     		Point3d ptProjectedIntersection = lnSegment.closestPointTo(lnAux);
				//Exclude any points that lie on the cnc pline itself as we are only interested in projected points (for pockets)
				if(plCncEnvelope.isOn(ptProjectedIntersection))
				{
					continue;
				}
				lsAuxSegment.vis(v);
				projectedPoints.append(ptProjectedIntersection);
			}
		}
		
		for(int e=0;e<spEdges.length();e++)
		{
			SipEdge edge=spEdges[e];
			Vector3d vecEdgeSegment=edge.ptEnd()-edge.ptStart();
			vecEdgeSegment.normalize();
			
			Vector3d vProjectionLine (vecEdgeSegment.crossProduct(edge.vecNormal()));
			vProjectionLine.normalize();
			
			Point3d ptMidEdgeToPlane = Line(edge.ptMid(), vProjectionLine).intersect(plnZ, 0);

			if (dMinDistance> (ptMidEdgeToPlane - ptMidSegment).length())
			{
				dMinDistance=(ptMidEdgeToPlane - ptMidSegment).length();
		 		ptEdgeStart=edge.ptStart();
				ptEdgeEnd=edge.ptEnd();
				ptEdgeMid=edge.ptMid();
				vecN=edge.vecNormal();
				//vecN.vis(lsSeg.ptMid(), 1);
			}
		}

		//Vector3d vecN = spAlignedEdge.vecNormal();
	
		vecNormalToSegment.normalize();
		ptCentreOfEdges.append(lsSeg.ptMid() - dOffset*vecNormalToSegment);

		String sSegmentLength = round(dSegmentLength);
		dEdgeLengths.append(sSegmentLength.atof());
		
		// calc bevel.
		//Vector3d vecRef = vz.crossProduct(vecN);
		vecN.normalize();
		//vecN.vis(lnSeg.ptMid(), 1);
		double dBevelAngle = vz.angleTo(vecN);
		
		String sBevelAngle;
		sBevelAngle.formatUnit(90-abs(dBevelAngle), 2, 1);
				
		dEdgeBevelAngle.append(sBevelAngle.atof());
		
		sipReference.append(sipCurr.subLabel());
		//Projected segment
		if(projectedPoints.length() > 0)
		{
			Point3d ptAllPointsInSegment[0];
			for(int x=0;x<projectedPoints.length();x++)
			{
				Point3d projectedPoint = projectedPoints[x];
				projectedPoint.vis(v);
				ptAllPointsInSegment.append(projectedPoint );
			}
			
			ptAllPointsInSegment.append(lsSeg.ptStart());
			ptAllPointsInSegment.append(lsSeg.ptEnd());
			
			ptAllPointsInSegment = lnSegment.orderPoints(ptAllPointsInSegment);
			Point3d ptStartProjectedSegment = ptAllPointsInSegment[0];
			Point3d ptEndProjectedSegment = ptAllPointsInSegment[ptAllPointsInSegment.length()-1];
			double dProjectedLength = abs((ptEndProjectedSegment - ptStartProjectedSegment).length() - dSegmentLength);
			String sProjectedLength=ceil(dProjectedLength);
		
			dProjectedSegmentLength.append(sProjectedLength.atof());
		}
		else
		{
			dProjectedSegmentLength.append(0);
		}
	}
}

//Assign edge codes for each edge
int nEdgeCodes[0];
String sEdgeCodeLetters[0];
int nCurrentEdgeNumber=1;
int currentEdgeChar=1;

for(int p=0;p<dEdgeLengths.length();p++)
{
	int nNext=1;
	int nChar;
	int currentEdgeCharAbs=abs(nCurrentEdgeNumber);
	String sNewChar;
	while (nNext > 0)
	{
		nChar=(currentEdgeCharAbs-1)%26;
		nNext=(currentEdgeCharAbs-1-nChar)/26;
		sNewChar=char('A'+nChar)+sNewChar;
		currentEdgeCharAbs=nNext;
	}

	//First edge
	if(p==0)
	{
		nEdgeCodes.append(nCurrentEdgeNumber);
		sEdgeCodeLetters.append(sNewChar);
		nCurrentEdgeNumber++;
		continue;
	}
	
	double dCurrentEdgeLength=dEdgeLengths[p];
	double dCurrentAngle=dEdgeBevelAngle[p];
	int codeAssigned=false;
	
	for(int c=0;c<nEdgeCodes.length();c++)
	{
		int nAssignedEdgeCode=nEdgeCodes[c];
		String sAssignedEdgeCodeLetter=sEdgeCodeLetters[c];
		double dAssignedEdgeLength=dEdgeLengths[c];
		double dAssignedEdgeAngle=dEdgeBevelAngle[c];
		
		double dLengthDifference=abs(dAssignedEdgeLength-dCurrentEdgeLength);
		double dAngleDifference=abs(dAssignedEdgeAngle-dCurrentAngle);
		
		if(dLengthDifference<U(0.1) && dAngleDifference<U(0.1))
		{
			//Assign same edge code as length and angle are the same
			nEdgeCodes.append(nAssignedEdgeCode);
			sEdgeCodeLetters.append(sAssignedEdgeCodeLetter);
			codeAssigned=true;
			break;
		}
	}
	
	if(codeAssigned)
	{
		continue;
	}
	
	//New edge details found
	nEdgeCodes.append(nCurrentEdgeNumber);
	sEdgeCodeLetters.append(sNewChar);

	//Need to make this AA, AB, etc if it goes over Z	
	nCurrentEdgeNumber++;
}

//Sort based on edge codes
for(int s1=1; s1<nEdgeCodes.length(); s1++)
{
	int s11 = s1;
	for(int s2=s1-1; s2>=0; s2--)
	{
		int bSort = nEdgeCodes[s11] < nEdgeCodes[s2];
		if( bSort )
		{
			nEdgeCodes.swap(s2, s11);
			sEdgeCodeLetters.swap(s2, s11);
			ptCentreOfEdges.swap(s2, s11);
			dEdgeLengths.swap(s2, s11);
			dEdgeBevelAngle.swap(s2, s11);
			dProjectedSegmentLength.swap(s2, s11);
			sipReference.swap(s2,s11);
			s11=s2;
		}
	}
}

//Draw numbers on each edge
for(int c=0;c<ptCentreOfEdges.length();c++)
{
	int nCode=nEdgeCodes[c];
	String sLetter=sEdgeCodeLetters[c];
	
	Point3d ptCentre=ptCentreOfEdges[c];
	ptCentre.transformBy(ms2ps);

	if(nNumberingMode==0)
	{
		dpEdge.draw(nCode, ptCentre, _XW, _YW, 0, 0);
	}
	else
	{
		dpEdge.draw(sLetter, ptCentre, _XW, _YW, 0, 0);		
	}
}

//Prepare table data
String sEdgeHeader="Edge";
String sLengthHeader="Length";
String sBevelAngle="Bevel";

String sTableHeaders[]={sEdgeHeader, sLengthHeader, sBevelAngle};
String sEdgeCodeTableData[0];
String sEdgeCodeLetterTableData[0];
double dEdgeLengthTableData[0];
double dBevelAngleTableData[0];

String sProjectedEdgeCodeTableData[0];
double dProjectedEdgeLengthTableData[0];

int nCurrentEdgeIndex=-1;
for(int c=0;c<ptCentreOfEdges.length();c++)
{
	int nEdgeCode=nEdgeCodes[c];
	double dEdgeLength=dEdgeLengths[c];
	double dBevelAngle=dEdgeBevelAngle[c];
	String sEdgeCodeLetter = sEdgeCodeLetters[c];
	
	if (nCurrentEdgeIndex==nEdgeCode)
	{
		continue;
	}

	sEdgeCodeTableData.append(nEdgeCode);
	sEdgeCodeLetterTableData.append(sEdgeCodeLetter);
	dEdgeLengthTableData.append(dEdgeLength);
	dBevelAngleTableData.append(dBevelAngle);
	nCurrentEdgeIndex=nEdgeCode;
}


for(int i=0;i<dProjectedSegmentLength.length();i++)
{
	double dProjectedLength = dProjectedSegmentLength[i];
	if(dProjectedLength==0)
	{
		continue;
	}
	
	int nEdgeCode = nEdgeCodes[i];
	String sEdgeCodeLetter = sEdgeCodeLetters[i];
	String sipReferenceCurr=sipReference[i];
	
	if(nNumberingMode==0)
	{
		sProjectedEdgeCodeTableData.append(nEdgeCode+"-"+sipReferenceCurr);
	}
	else
	{
		sProjectedEdgeCodeTableData.append(sEdgeCodeLetter+"-"+sipReferenceCurr);
	}
	
	dProjectedEdgeLengthTableData.append(dProjectedLength );
}




//Draw the table
//Create table-entries
//Row index
int nRowIndex = 0;
//Row height
double dRowHeight = 1.5 * dp.textHeightForStyle("1", sDimStyle);

//Point in the midle between the Title and the Heager Row
Point3d ptOrgTable=ptDraw - _YW * 2 * dRowHeight;

//Headers
double dColumnWidths[0];
double dColumnWidthsCumulative[0];

for(int s=0;s<sTableHeaders.length();s++)
{
	String sHeader=sTableHeaders[s];
	double dColumnWidth=1.25 * dp.textLengthForStyle(sHeader, sDimStyle);
	double dCumulativeColumnWidth=dColumnWidthsCumulative.length()==0 ? dColumnWidth : dColumnWidth+dColumnWidthsCumulative[s-1];
	dColumnWidths.append(dColumnWidth);
	dColumnWidthsCumulative.append(dCumulativeColumnWidth);

	//Draw Header
	dp.draw( PLine(ptOrgTable + _YW * 2 * dRowHeight, ptOrgTable + _XW * dCumulativeColumnWidth+ _YW * 2 * dRowHeight) );
	dp.draw( sHeader, ptOrgTable + _XW  *  dCumulativeColumnWidth - _XW * 0.5 * dColumnWidth + _YW * dRowHeight, _XW, _YW, 0, 0);
	dp.draw( PLine(ptOrgTable, ptOrgTable + _XW * dCumulativeColumnWidth) );
	PLine plColumnBorder(ptOrgTable, ptOrgTable + _YW * 2 * dRowHeight);
	dp.draw(plColumnBorder);
	plColumnBorder.transformBy(_XW * dCumulativeColumnWidth);
	dp.draw(plColumnBorder);
}

nRowIndex++;

for(int d=0;d<sEdgeCodeTableData.length();d++)
{
	Point3d ptRow = ptOrgTable - _YW * nRowIndex * dRowHeight;
	
	String sEdgeCode=sEdgeCodeTableData[d];
	String sEdgeCodeLetter=sEdgeCodeLetterTableData[d];
	double dEdgeLength=dEdgeLengthTableData[d];
	double dBevelAngle=dBevelAngleTableData[d];

	for(int s=0;s<dColumnWidths.length();s++)
	{
		double dColumnWidth=dColumnWidths[s];
		double dCumulativeColumnWidth=dColumnWidthsCumulative[s];
		
		String sCellData;
		if(s==0)
		{
			if(nNumberingMode==0)
			{
				sCellData=sEdgeCode;
			}
			else
			{
				sCellData=sEdgeCodeLetter;
			}
		}
		else if(s==1)
		{
			sCellData=dEdgeLength;
		}
		else
		{
			sCellData=dBevelAngle;
		}
		
		dp.draw( sCellData, ptRow + _XW  *  dCumulativeColumnWidth - _XW * 0.5 * dColumnWidth + _YW * 0.5 * dRowHeight, _XW, _YW, 0, 0);
		dp.draw( PLine(ptRow , ptRow + _XW * dCumulativeColumnWidth) );
		PLine plColumnBorder(ptRow , ptRow + _YW * 2 * dRowHeight);
		dp.draw(plColumnBorder);
		plColumnBorder.transformBy(_XW * dCumulativeColumnWidth);
		dp.draw(plColumnBorder);
	}

	nRowIndex++;
}


for(int d=0;d<sProjectedEdgeCodeTableData.length();d++)
{
	Point3d ptRow = ptOrgTable - _YW * nRowIndex * dRowHeight;
	
	String sEdgeCode=sProjectedEdgeCodeTableData[d];
	double dEdgeLength=dProjectedEdgeLengthTableData[d];

	for(int s=0;s<dColumnWidths.length();s++)
	{
		double dColumnWidth=dColumnWidths[s];
		double dCumulativeColumnWidth=dColumnWidthsCumulative[s];
		
		String sCellData;
		if(s==0)
		{
				sCellData=sEdgeCode;
		}
		else if(s==1)
		{
			sCellData=dEdgeLength;
		}

		dp.draw( sCellData, ptRow + _XW  *  dCumulativeColumnWidth - _XW * 0.5 * dColumnWidth + _YW * 0.5 * dRowHeight, _XW, _YW, 0, 0);
		dp.draw( PLine(ptRow , ptRow + _XW * dCumulativeColumnWidth) );
		PLine plColumnBorder(ptRow , ptRow + _YW * 2 * dRowHeight);
		dp.draw(plColumnBorder);
		plColumnBorder.transformBy(_XW * dCumulativeColumnWidth);
		dp.draw(plColumnBorder);
	}

	nRowIndex++;
}


#End
#BeginThumbnail







#End