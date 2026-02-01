#Version 8
#BeginDescription
Use to Mill around Window and Door Openings
Select an Element and Enter Properties for Milling
This will also place milling lines on the left and right of an element.

Modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com)
Date: 06.09.2018 - version 1.12
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 12
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2004 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Revised: Anno Sportel 041216
* Change:  First revision
*
* Revised: Mick Kelly	
* Change:  Added Mill Lines on Left and Right of Frame
*
* Revised: Anno Sportel 051024	
* Change: Select a set of elements instead of one element.
*
* Revised: Anno Sportel 051101	
* Change: Create a master and slaves.
*
* Revised: Anno Sportel 051101	
* Change: Correct error on milling lines at left and right side.
*              Add milling lines on top-left, top-right, bottom-left, bottom-right
*
* Revised: Anno Sportel 051213	
* Change: Correct error on milling lines at left and right side.
*              Set normal to PLines
*
* Revised: Anno Sportel 051213	
* Change: Adjust milling lines at left and right side of element. 
*              React on gap between sheeting.
*
* Revised: Anno Sportel 060517	
* Change: Add options to turn milling lines on and off.
*
* Revised: Anno Sportel 060824	
* Change: Only mill specified zone.
*
* Revised: Alberto Jena 070926	
* Change: Add Offset of the Panel.
*
*/

//Script uses inches.
Unit(1,"mm");

String categories[] = { T("|Milling data|"), T("|Dimensions|"), T("|Locations|")};

String modes[] = { T("|Opening|"), T("|Opening where sheets intersect|")};
PropString sMode(12, modes, T("|Milling mode|"), 0);
sMode.setCategory(categories[0]);
int nMode = modes.find(sMode,0);

//int nLunit = 4; // architectural (only used for beam length, others depend on hsb_settings)
//int nPrec = 3; // precision (only used for beam length, others depend on hsb_settings)
int arNZone[] = { -5, -4, -3, -2, -1, 1, 2, 3, 4, 5};
PropInt nZone(0,arNZone,T("Zone"),5);
nZone.setCategory(categories[0]);

PropInt nToolingIndex(1,1,T("Tooling index"));
nToolingIndex.setCategory(categories[0]);

String arSSide[]= {T("Left"),T("Right")};
int arNSide[]={_kLeft, _kRight};
PropString strSide(0,arSSide,T("Side"),0);
strSide.setCategory(categories[0]);
int nSide = arNSide[arSSide.find(strSide,0)];

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString strTurn(1,arSTurn,T("Turning direction"),1);
strTurn.setCategory(categories[0]);
int nTurn = arNTurn[arSTurn.find(strTurn,0)];

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={_kNo, _kYes};
PropString strOShoot(2,arSOShoot,T("Overshoot"));
strOShoot.setCategory(categories[0]);
int nOShoot = arNOShoot[arSOShoot.find(strOShoot,0)];

String arSVacuum[]= {T("No"),T("Yes")};
int arNVacuum[]={_kNo, _kYes};
PropString strVacuum(3,arSVacuum,T("Vacuum"),1);
strVacuum.setCategory(categories[0]);
int nVacuum = arNVacuum[arSVacuum.find(strVacuum,0)];
PropDouble millDepth (0,U(9/16),T("Milling Depth")); 
millDepth.setCategory(categories[1]);

PropDouble dOffsetOpening(1, U(0), T("Offset milling around opening"));
dOffsetOpening.setCategory(categories[1]);

PropDouble dOffsetTop(2, U(0), T("Offset milling panel top"));
dOffsetTop.setCategory(categories[1]);

PropDouble dOffsetSide(3, U(0), T("Offset milling panel sides"));
dOffsetSide.setCategory(categories[1]);



String arSYesNo[] = {T("Yes"), T("No")};
int arNYesNo[] = {_kYes, _kNo};

PropString sMillingOnTop(4, arSYesNo, T("Milling on top"));
sMillingOnTop.setCategory(categories[2]);

PropString sMillingOnTopLeft(5, arSYesNo, T("Milling on top-left"));
sMillingOnTopLeft.setCategory(categories[2]);

PropString sMillingOnLeft(6, arSYesNo, T("Milling on left"));
sMillingOnLeft.setCategory(categories[2]);

PropString sMillingOnBottomLeft(7, arSYesNo, T("Milling on bottom-left"));
sMillingOnBottomLeft.setCategory(categories[2]);

PropString sMillingOnBottom(8, arSYesNo, T("Milling on bottom"));
sMillingOnBottom.setCategory(categories[2]);

PropString sMillingOnBottomRight(9, arSYesNo, T("Milling on bottom-right"));
sMillingOnBottomRight.setCategory(categories[2]);

PropString sMillingOnRight(10, arSYesNo, T("Milling on right"));
sMillingOnRight.setCategory(categories[2]);

PropString sMillingOnTopRight(11, arSYesNo, T("Milling on top-right"));
sMillingOnTopRight.setCategory(categories[2]);

PropDouble dEdgeOffsetFromHole(4, U(0), T("Offset from hole edge"));
dEdgeOffsetFromHole.setCategory(categories[1]);

int nMillingOnTop = arNYesNo[arSYesNo.find(sMillingOnTop,0)];
int nMillingOnTopLeft = arNYesNo[arSYesNo.find(sMillingOnTopLeft,0)];
int nMillingOnLeft = arNYesNo[arSYesNo.find(sMillingOnLeft,0)];
int nMillingOnBottomLeft = arNYesNo[arSYesNo.find(sMillingOnBottomLeft,0)];
int nMillingOnBottom = arNYesNo[arSYesNo.find(sMillingOnBottom,0)];
int nMillingOnBottomRight = arNYesNo[arSYesNo.find(sMillingOnBottomRight,0)];
int nMillingOnRight = arNYesNo[arSYesNo.find(sMillingOnRight,0)];
int nMillingOnTopRight = arNYesNo[arSYesNo.find(sMillingOnTopRight,0)];


//Insert done in script
if(_bOnInsert){
	_Element.append(getElement(T("Select an element")));

	//Showdialog
	showDialogOnce();
  
	//Return to drawing
	return;
}

//Check if there are elements selected.
if(_Element.length() == 0){eraseInstance(); return;}

//Assign selected element to el.
Element el = _Element[0];

//Place _Pt0 in origin of element
Point3d elOrg = el.ptOrg();
_Pt0 = elOrg;
Entity dependantEntities[0];

//Define a ccordsys of the element.
CoordSys csEl = el.coordSys();	
//Define a useful set of vectors.
Vector3d vX = csEl.vecX();vX.vis(_Pt0,1);
Vector3d vY = csEl.vecY();vY.vis(_Pt0,3);
Vector3d vZ = csEl.vecZ();vZ.vis(_Pt0,150);
//For debug only
if(_bOnDebug){
	//Take all beams and sheets from the element
	GenBeam arGBm[] = el.genBeam();
	Display dp(-1);
	for(int i=0; i<arGBm.length(); i++){
		Body bd = arGBm[i].realBody();
		dp.color(arGBm[i].color());
		dp.draw(bd);
	}
}

//Get all the beams of this element.
Beam arBm[] = el.beam();
Sheet arSheetsInZone[] = el.sheet(nZone);
PlaneProfile ppSheetsInZone[0];
PlaneProfile ppAllSheetsInZone(csEl);
Plane plElement(elOrg, vZ);
for(int i=0;i<arSheetsInZone.length();i++)
{
	Sheet sheetInZone= arSheetsInZone[i];
	PlaneProfile ppSheet(csEl);
	ppSheet.unionWith(sheetInZone.envelopeBody(FALSE, TRUE).shadowProfile(plElement));
	if (ppSheet.area() < U(1) * U(1)) continue;

	ppAllSheetsInZone.unionWith(ppSheet);
	ppSheetsInZone.append(ppSheet);
}

ppAllSheetsInZone.shrink(U(-10));
ppAllSheetsInZone.shrink(U(10));
	
//Get all the openings of the element.
Opening arOp[] = el.opening();
//Loop over all those openings
for(int i =0; i<arOp.length();i++){
	//Assign current opening to op
	Opening op = arOp[i];
	//Cast op to OpeningSF and assign it to opSf
	OpeningSF opSf = (OpeningSF)op;

	//Get the shape of the opening as a poly line
	PLine plOp = opSf.plShape();
	
	//Move the poliline to to the center of the zone0
	Plane plnMidZone0(elOrg - vZ * el.dBeamWidth() * 0.5, vZ);
	plOp.projectPointsToPlane(plnMidZone0, vZ);
	
	//Get the points of this poly line
	Point3d arPtOp[] = plOp.vertexPoints(TRUE);  
	
	//Calculate the center pointof the opening
	Point3d ptOpCen;
	for(int j=0;j<arPtOp.length();j++){
		Point3d pt = arPtOp[j];
		ptOpCen = ptOpCen + pt;
	}
	ptOpCen = ptOpCen/arPtOp.length();
	ptOpCen.vis(5);
	//calculate the left and right point of the opening.
	Point3d ptLeft = ptOpCen - vX * 0.5 * opSf.width();
	Point3d ptRight = ptOpCen + vX * 0.5 * opSf.width();

	//Find the sill which belongs to this opening.
	//Create a new beam, nothing assigned to it yet.
	Beam bmSills[0];
	Beam bmSill;
	//Loop over all beams
	for(int j=0;j<arBm.length();j++)
	{
		//Assign the current beam to bm.
		Beam bm = arBm[j];
		//Continue if the current beam is NOT a sill.
		if(bm.type() != _kSill)continue;
   
		//Check if the sill belongs to this element.
		double d1 = vX.dotProduct(bm.ptCen() - ptLeft);
		double d2 = vX.dotProduct(bm.ptCen() - ptRight);    
		if( (d1 * d2) < 0 )
		{
			bmSills.append (bm);
		}
	}

	//Sort the sills and bottom plates to get bottom most sill and top most bottom plate
	bmSills = Beam().filterBeamsHalfLineIntersectSort(bmSills, ptOpCen, - vY);
	if (bmSills.length()>0)
		bmSill = bmSills[0];

	//Default gap is set to 0.
	double dGapB = 0;
	//If there is a sill: calculate the gap on the bottom.
	if( bmSill.bIsValid() ){
		dGapB = vY.dotProduct((ptOpCen - vY * 0.5 * opSf.height()) - (bmSill.ptCen() + vY * 0.5 * bmSill.dW()));
	}

	//Total width of the opening, gaps included.
	double dOpW = opSf.width() + 2 * opSf.dGapSide();

	//Calculate the vertexpoints of the opening, all gaps included.
	Point3d ptLL = ptOpCen - vX * (0.5 * dOpW + dOffsetOpening) - vY * (0.5 * opSf.height() + dGapB + dOffsetOpening);
	Point3d ptLR = ptOpCen + vX * (0.5 * dOpW + dOffsetOpening) - vY * (0.5 * opSf.height() + dGapB + dOffsetOpening);
	Point3d ptUR = ptOpCen + vX * (0.5 * dOpW + dOffsetOpening) + vY * (0.5 * opSf.height() + opSf.dGapTop() + dOffsetOpening);
	Point3d ptUL = ptOpCen - vX * (0.5 * dOpW + dOffsetOpening) + vY * (0.5 * opSf.height() + opSf.dGapTop() + dOffsetOpening);

	if (nMode == 0)
	{
		//Create a poly line with those vertex points.
		//Create Pline with a normal.
		PLine plMill(vZ);
		plMill.addVertex(ptLL);
		plMill.addVertex(ptUL);
		plMill.addVertex(ptUR);
		plMill.addVertex(ptLR);
		if (bmSill.bIsValid() == TRUE) {
			//Close the poly line.
			plMill.close();
		}
		plMill.vis(5);
		
		double dDepth = el.zone(nZone).dH();
		ElemMill millOp(nZone, plMill, millDepth, nToolingIndex, nSide, nTurn, nOShoot);
		millOp.setVacuum(nVacuum);
		el.addTool(millOp);
	}
	if(nMode==1)
	{ 
		LineSeg lsOpeningSeg(ptLL, ptUR);
		PLine plOpeningRect;
		plOpeningRect.createRectangle(lsOpeningSeg, vX, vY);
		PlaneProfile ppOpeningRect(csEl);
		ppOpeningRect.joinRing(plOpeningRect, FALSE);
		
		PlaneProfile ppOpeningIntersections(ppOpeningRect);
		
		ppOpeningIntersections.intersectWith(ppAllSheetsInZone);
		ppOpeningRect.vis(3);
		
		PLine plOpeningIntersectionRings[] = ppOpeningIntersections.allRings();
		int nOpeningIntersectionRingOpenings[] = ppOpeningIntersections.ringIsOpening();
		
		PLine plMillings[0];
		for (int j = 0; j < plOpeningIntersectionRings.length(); j++) 
		{
			PLine& plOpeningIntersection = plOpeningIntersectionRings[j];
			if ( nOpeningIntersectionRingOpenings[j] )continue;
			
			Point3d vertices[] = plOpeningIntersection.vertexPoints(TRUE);
			if (vertices.length() == 0) continue;
			
			for(int x = 0 ; x< vertices.length() ; x++)
			{ 
				Point3d& ptStart = vertices[x];
				Point3d& ptEnd = x==vertices.length()-1 ? vertices[0] : vertices[x + 1];
				
				LineSeg lsSeg(ptStart, ptEnd);
				Point3d ptMid = lsSeg.ptMid();
				Vector3d vecSeg = ptEnd - ptStart;
				vecSeg.normalize();
				Vector3d vecOut = vecSeg.crossProduct(vZ);
				
				Point3d ptOut = ptMid + vecOut * U(1);
				vecOut.vis(ptOut);
				ptStart.vis(x);
				ptEnd.vis(x);
				if(ppOpeningRect.pointInProfile(ptOut)==_kPointInProfile)
				{ 
					//Point is inside the opening which means we need to offset this edge
					ptStart.transformBy(-vecOut * dEdgeOffsetFromHole);
					ptEnd.transformBy(-vecOut * dEdgeOffsetFromHole);
				}
			}
			
			PLine plMilling;
			for(int x = 0 ; x< vertices.length() ; x++)
			{ 
				plMilling.addVertex(vertices[x]);
			}
			
			plMilling.close();
			double dDepth = el.zone(nZone).dH();
			ElemMill millOp(nZone, plMilling, millDepth, nToolingIndex, nSide, nTurn, nOShoot);
			millOp.setVacuum(nVacuum);
			el.addTool(millOp);
			
			//Find all the sheets that participated in this milling
			int sheetIndexesForMilling[0];
			for (int x = 0; x < vertices.length(); x++)
			{
				Point3d& ptVertex = vertices[x];
				for (int y = 0; y < ppSheetsInZone.length(); y++)
				{
					PlaneProfile& sheetProfile = ppSheetsInZone[y];
					if(sheetProfile.pointInProfile(ptVertex)==_kPointInProfile && sheetIndexesForMilling.find(y, -1) == -1)
					{ 
						sheetIndexesForMilling.append(y);
					}
				}
			}
			
			for(int x = 0 ; x < sheetIndexesForMilling.length() ; x++)
			{ 
				dependantEntities.append(arSheetsInZone[sheetIndexesForMilling[x]]);
			}
		}
	}
}

ElemZone elZn = el.zone(nZone);
String sCode = elZn.code();
double dGapZn = 0;
if( sCode == "HSB-PL03" ){
	if( elZn.hasVar("gap") ){
		dGapZn = U(elZn.dVar("gap"), "mm");
	}
}
	
	
PlaneProfile pProf(csEl);
pProf.unionWith(el.profBrutto(nZone));

//pProf.shrink(-dOffsetPanel); //AJ

PLine arPlPProf[] = pProf.allRings();
int arBPlIsOpening[] = pProf.ringIsOpening();
	
PLine arPlMill[0];
for(int j=0;j<arPlPProf.length();j++){
	if( arBPlIsOpening[j] )continue;
	
	PLine pl = arPlPProf[j];
	pl.vis(j);
			
	Point3d arPt[0];
	arPt.append( pl.vertexPoints(FALSE) );
		
	for(int k=0;k<(arPt.length()-1);k++){
		Point3d ptThis = arPt[k];
		Point3d ptNext = arPt[k+1];
		
		Vector3d vLine = ptThis - ptNext;
		vLine.normalize();
		vLine.vis(ptNext,1);
		Vector3d vPerp = vZ.crossProduct(vLine);
		vPerp.normalize();
				
		double dVpX = vX.dotProduct(vPerp);
		double dLineX = vX.dotProduct(vLine);

		if( abs(dVpX - 1) < U(0.001) ){
			//Vertical right
			if( nMillingOnRight ){
				ptThis = ptThis - vX * 0.5 * dGapZn + vX * dOffsetSide ;
				ptNext = ptNext - vX * 0.5 * dGapZn + vX * dOffsetSide + vY * dOffsetTop;
				arPlMill.append( PLine(ptThis, ptNext) );
			}
		}
		else if( abs(dVpX +1) < U(0.001) ){
			//Vertical left
			if( nMillingOnLeft ){
				ptThis = ptThis + vX * 0.5 * dGapZn - vX * dOffsetSide + vY * dOffsetTop;
				ptNext = ptNext + vX * 0.5 * dGapZn - vX * dOffsetSide ;
				arPlMill.append( PLine(ptThis, ptNext) );
			}
		}
		else if( abs(dVpX) < U(0.001) ){
			if( vLine.isCodirectionalTo(vX) ){
				//Horizontal top
				if( nMillingOnTop ){
					arPlMill.append( PLine(ptThis + vY * dOffsetTop + vX * dOffsetSide , ptNext + vY * dOffsetTop - vX * dOffsetSide) );
				}
			}
			else{
				//Horizontal bottom
				if( nMillingOnBottom ){
					arPlMill.append( PLine(ptThis - vX * dOffsetSide, ptNext + vX * dOffsetSide) );
				}
			}
		}
		else if( dVpX > 0 && dVpX < 1 ){
			//Right
			if( dLineX > 0 ){
				//Right top
				if( nMillingOnTopRight ){
					arPlMill.append( PLine(ptThis, ptNext) );
				}
			}
			else{
				//Right bottom
				if( nMillingOnBottomRight ){
					arPlMill.append( PLine(ptThis, ptNext) );
				}
			}
		}
		else if( dVpX < 0 && dVpX > -1 ){
			//Left
			if( dLineX > 0 ){
				//Left top
				if( nMillingOnTopLeft ){
					arPlMill.append( PLine(ptThis, ptNext) );
				}
			}
			else{
				//Left bottom
				if( nMillingOnBottomLeft ){
					arPlMill.append( PLine(ptThis, ptNext) );
				}
			}
		}
	}
}
double dDepth = el.zone(nZone).dH();
for( int j=0;j<arPlMill.length();j++ ){
	PLine plMill = arPlMill[j];
	plMill.setNormal(vZ);
	
	ElemMill elemMill(nZone, plMill, dDepth, nToolingIndex, nSide, nTurn, nOShoot);
	elemMill.setVacuum(nVacuum);
	el.addTool(elemMill);
}

assignToElementGroup(el,TRUE,1,'E');

Map dependantEntityArrayMap;
for(int i=0;i<dependantEntities.length();i++)
{
	Entity ent = dependantEntities[i];
	Map dependantEntityMap;
	dependantEntityMap.setEntity("Entity", ent);
	dependantEntityArrayMap.appendMap("DependantEntity", dependantEntityMap);
}

_Map.setMap("DependantEntity[]", dependantEntityArrayMap);
//_Map.showAdd();
#End
#BeginThumbnail













#End
#BeginMapX

#End