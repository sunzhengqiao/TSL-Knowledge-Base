#Version 8
#BeginDescription
Split wall at ONE or BOTH sides of opening
v1.7: 27.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
// Automatically saved contents for tsl
// Date & time: Monday, 20, August, 2012 3:22:38 AM

/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v1.7: 27.mar.2013: David Rueda (dr@hsb-cad.com)
	- Problem of opening moving because anchor (inside/outside frame) solved (recalculated offset based on opening size plus gaps
* v1.6: 23.ago.2012: David Rueda (dr@hsb-cad.com):
	- Problem of opening moving because anchor (inside/outside frame) solved
	- Collecting beams of module does not depend anymore on header, any horizontal beam will be taken in consideration
	- Wall arrow relocated per element: centered for left and right walls, 2.5' offset left/right from center point for top/bottom walls
	- Redefined vector for right and left side to be element.vecX()
	- Improved collecting of beams around opening by side (top, bottom, left, right)
	- Reference points referenced to studs around opening instead of opening
	- Sheeting controlled for openings with rough dimensions
* v1.5: 23.ago.2012: David Rueda (dr@hsb-cad.com):
	- Version control
* v1.4: 02.feb.2012: David Rueda (dr@hsb-cad.com):
	- Problem with VTP's solved
	- Added functionality for oenings with header BELOW PLATE
* v1.3: 23.jan.2012: David Rueda (dr@hsb-cad.com):
	- Cleaned unnecesary code
* v1.2: 18.jan.2012: David Rueda (dr@hsb-cad.com):
	- Opening's origing point and all related re-calculated due to error on special openings.
	- Walls are not splitted, instead a copy is created and cut
	- Information for surounding beams around opening is not brought from instanced opening, but geometrically, in order to work with openings 
	with porps. brought by catalog and from instanced.
* v1.1: 09.jan.2012: David Rueda (dr@hsb-cad.com): 
	- Move bottom wall's icon when needed to avoid overlapping with top one's.
	- Prompts dialog message "Wall must be framed prior to this operation" when intented to insert tsl and wall is not framed.
	- Swap option sides: 1 for right, 2 for left side of opening.
	- Avoid creation of bottom wall when opening has a sill height < 4in. (doors).
* v1.0: 06.jan.2012: David Rueda (dr@hsb-cad.com): Release
*/

double dTolerance= U(0.0025, 0.001);

if (_bOnInsert) 
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	_Opening.append(getOpening()); // select an opening

	// make sure 0 is a valid index in the _Opening array
	if (_Opening.length()==0) { // if no openings attached
		reportMessage(T("|Not valid opening provided|"));
		eraseInstance(); // just erase from DB
		return;
	}
	
	int nChoice= getInt(T("|Set split type|")+"\t\t[0: "+T("|Both sides of opening|"+" / 1: "+T("|Left Side of opening|")+" / 2: "+T("|Right side of opening|")+"]"));
	_Map.setInt("CHOICE", nChoice);
	_Map.setInt("ExecutionMode",0);
	_Map.setInt("SplitWall",0);
	
	return;
}

int nChoice= _Map.getInt("CHOICE");
int bSplitLeftSide=false;
int bSplitRightSide=false;
int bSplitVertically=false;

if( nChoice==0)
{
	bSplitLeftSide=true;
	bSplitRightSide=true;
	bSplitVertically=true;
}

else if( nChoice== 1)
{
	bSplitLeftSide=true;
	bSplitRightSide=false;
	bSplitVertically=false;
}
else if( nChoice== 2)
{
	bSplitLeftSide=false;
	bSplitRightSide=true;
	bSplitVertically=false;
}
else
{
	reportMessage(T("|Not valid choice, tsl will be deleted|"));
	eraseInstance();
	return;
}

_Map.setInt("SPLIT_LEFT", bSplitLeftSide);
_Map.setInt("SPLIT_RIGHT", bSplitRightSide);

// Split wall - Only needed once
if(_Map.getInt("SplitWall")==0)
{
	// make sure we have the right type of opening
	OpeningSF opSf = (OpeningSF)_Opening[0]; // explicit cast
	if (!opSf.bIsValid()) { // want to keep only the OpeningSF types
		reportMessage(T("|Not valid opening provided|"));
		eraseInstance(); // just erase from DB
		return;
	}
	
	// Get wall from opening
	Element elOriginal= opSf.element();
	CoordSys csEl= elOriginal.coordSys();
	Point3d ptOrg= csEl.ptOrg();
	Vector3d vx= csEl.vecX();
	Vector3d vy= csEl.vecY();
	Vector3d vz= csEl.vecZ();

	PlaneProfile ppEl(elOriginal.plOutlineWall());
	LineSeg ls=ppEl.extentInDir(vx);
	double dWallLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
	double dWallWidth=elOriginal.dBeamHeight();
	double dWallHeight= ((Wall)elOriginal).baseHeight();

	Point3d ptElCen= ptOrg+ vx* dWallLength*.5 + vy* dWallHeight*.5+ vz* dWallWidth*.5;
	
	// Get top, bottom, left and right vertex of opening (including gaps)
	double dOpW= opSf.width();
	double dOpWRough= opSf.widthRough();
	double dOffsetWhenRoughDimension= (dOpWRough-dOpW)/2;
	double dOpH= opSf.height();
	CoordSys csOp = opSf.coordSys();
	Point3d ptOpOrg= csOp.ptOrg();
	Vector3d vxOp = vx;//csOp.vecX();
	Vector3d vyOp = vy;//csOp.vecY();
	Vector3d vzOp = vz;//csOp.vecZ();
	_Pt0= ptOpOrg;	

	// With some openings, ptOrg is not the required. Get a correct value for it
	Line lnX( _Pt0, vxOp);
	PLine plOp= opSf.plShape();
	Point3d ptAllOp[]= plOp.vertexPoints(1);
	ptAllOp= lnX.projectPoints( ptAllOp);
	ptAllOp= lnX.orderPoints( ptAllOp);
	Point3d pt1= ptAllOp[0];
	Point3d pt2= ptAllOp[ptAllOp.length()-1];
	Point3d ptMid= pt1+ vxOp*(abs(vxOp.dotProduct(pt2-pt1))*.5);
	
	_Pt0= ptMid- vxOp* dOpW*.5;
	ptOpOrg= _Pt0;
	
	Point3d ptLeftOp=_Pt0 - vxOp*(opSf.dGapSide()+dTolerance)+vyOp*dOpH*.5;
	Point3d ptRightOp= _Pt0 + vxOp* (dOpW+ opSf.dGapSide()+dTolerance)+vyOp*dOpH*.5;
	Point3d ptBottomOp= _Pt0 - vyOp* (opSf.dGapBottom()+dTolerance);
	Point3d ptTopOp= _Pt0 + vyOp* (dOpH+ opSf.dGapTop()+dTolerance);
	Point3d ptCenOp= ptLeftOp+vx*abs(vx.dotProduct(ptRightOp-ptLeftOp))*.5+vy*abs(vy.dotProduct(ptTopOp-ptRightOp))*.5;


	_Map.setEntity( "OPENING", opSf);
	_Map.setInt("HEADER_BELOW_PLATE", opSf.bHeaderBelowPlate());
	_Map.setPoint3d( "PT_LEFT_OP", ptLeftOp);
	_Map.setPoint3d( "PT_RIGHT_OP", ptRightOp);
	_Map.setPoint3d( "PT_TOP_OP", ptTopOp);
	_Map.setPoint3d( "PT_BOTTOM_OP", ptBottomOp);
	_Map.setPoint3d( "PT_CENTER_OP", ptCenOp);
	_Map.setPLine("PL_OPENING_SHAPE", opSf.plShape());
	_Map.setVector3d("VZ_OPENING", vzOp);
	_Map.setVector3d("ORIGINAL_VX", vx);
	_Map.setDouble("OFFSET_WHEN_ROUGH_DIMENSION", dOffsetWhenRoughDimension); // Per side
	_Map.setDouble("WALL_HEIGHT", dWallHeight);

	Wall wlOriginal=(Wall)elOriginal;
	if(!wlOriginal.bIsValid())
	{
		eraseInstance();
		return;	
	}
	
	// Wall must be framed
	Beam bmAll[]= elOriginal.beam();
	Sheet shAll[]= elOriginal.sheet();
	if(bmAll.length()==0||shAll.length()==0)
	{
		reportNotice("\n"+T("|Error: wall must be framed prior to this operation|"));
		eraseInstance();
		return;
	}
	
	Beam bmAllHorizontal[] = vy.filterBeamsPerpendicular( bmAll);

	_Element.append(elOriginal); //Must be here to avoid duplications
	
	// Collect all beams on this opening's module
	// Get any horizontal to bring module prop
	String sModule;
	Body bdFindAny( ptCenOp, vx, vy, vz, U(50,2), U(10000,400), U(2500,100), 0, 0, 0); 
	for( int b=0; b< bmAllHorizontal.length(); b++)
	{
		Beam bm= bmAllHorizontal[b];
		if( bdFindAny.hasIntersection( bm.realBody()) 
		&& bm.type() != _kBottom && bm.type() != _kSFBottomPlate  && bm.type() != _kTopPlate && bm.type() != _kSFTopPlate && bm.type() != _kSFVeryTopPlate && bm.type())
		{
			sModule= bm.module();
			break;
		}
	}

	Map subMap;
	subMap.setInt("DONT_ERASE_ME", 1);
	
	// Defining beams in module
	Beam bmAllInModule[0], bmAllJacks[0];
	for( int b=0; b< bmAll.length(); b++)
	{
		Beam bm= bmAll[b];
		if( sModule == bm.module())
		{
			bmAllInModule.append(bm);
			if( bm.type() == _kSFSupportingBeam)
				bmAllJacks.append(bm);
		}
	}
	
	// Setting cut points for top plates
	Point3d ptSearch= ptOrg-vz*dWallWidth*.5+vx*vx.dotProduct(ptCenOp- ptOrg)+vy*dOpH*.5;
	Beam bmAllJacksAtLeft[]= Beam().filterBeamsHalfLineIntersectSort(bmAllJacks, ptSearch, -vx);
	Beam bmAllJacksAtRight[]= Beam().filterBeamsHalfLineIntersectSort(bmAllJacks, ptSearch, vx);

	if(bmAllJacksAtLeft.length()==0 || bmAllJacksAtRight.length()==0)
	{
		reportNotice(T("|ERROR: Opening must have jack studs (both sides)|"));
		eraseInstance();
		return;
	}

	Beam bmMostLeftAtLeft= bmAllJacksAtLeft[bmAllJacksAtLeft.length()-1];
	Point3d ptStretchTopsAtLeft= bmMostLeftAtLeft.ptCen()-vx*bmMostLeftAtLeft.dD(vx)*.5;
	Beam bmMostRightAtLeft= bmAllJacksAtLeft[0];
	Point3d ptStretchBottomsAtLeft= bmMostRightAtLeft.ptCen()+vx*bmMostRightAtLeft.dD(vx)*.5;

	Beam bmMostRightAtRight= bmAllJacksAtRight[ bmAllJacksAtRight.length()-1];
	Point3d ptStretchTopsAtRight= bmMostRightAtRight.ptCen()+vx*bmMostRightAtRight.dD(vx)*.5;
	Beam bmMostLeftAtRight= bmAllJacksAtRight[0];
	Point3d ptStretchBottomsAtRight= bmMostLeftAtRight.ptCen()-vx*bmMostLeftAtRight.dD(vx)*.5;

	Point3d ptStretchSheetsAtLeft= ptStretchBottomsAtLeft;
	Point3d ptStretchSheetsAtRight= ptStretchBottomsAtRight;

	_Map.setPoint3d("PT_TO_STRETCH_TOPS_AT_LEFT_OF_OPENING", ptStretchTopsAtLeft);
	_Map.setPoint3d("PT_TO_STRETCH_TOPS_AT_RIGHT_OF_OPENING", ptStretchTopsAtRight);
	_Map.setPoint3d("PT_TO_STRETCH_BOTTOMS_AT_LEFT_OF_OPENING", ptStretchBottomsAtLeft);
	_Map.setPoint3d("PT_TO_STRETCH_BOTTOMS_AT_RIGHT_OF_OPENING", ptStretchBottomsAtRight);
	_Map.setPoint3d("PT_TO_STRETCH_SHEETS_AT_LEFT_OF_OPENING", ptStretchSheetsAtLeft);
	_Map.setPoint3d("PT_TO_STRETCH_SHEETS_AT_RIGHT_OF_OPENING", ptStretchSheetsAtRight);	

	Beam bmAllHorizontalsInModule[]= vy.filterBeamsPerpendicular(bmAllInModule);
	Beam bmAllVerticalsInModule[]= vx.filterBeamsPerpendicular(bmAllInModule);
	
	// Get extreme points along vx of module
	Beam bmVerticalsSorted[]= vx.filterBeamsPerpendicularSort(bmAllVerticalsInModule);
	Beam bmExtremeLeft= bmVerticalsSorted[0];
	Point3d ptExtremeLeftInModule= bmExtremeLeft.ptCen()- vx*bmExtremeLeft.dD(vx)*.5;	
	Beam bmExtremeRight= bmVerticalsSorted[ bmVerticalsSorted.length()-1];
	Point3d ptExtremeRightInModule= bmExtremeRight.ptCen()+ vx*bmExtremeRight.dD(vx)*.5;
	_Map.setPoint3d("PT_EXTREME_LEFT_IN_MODULE", ptExtremeLeftInModule);
	_Map.setPoint3d("PT_EXTREME_RIGHT_IN_MODULE", ptExtremeRightInModule);
	
		
	// Create bodies to search beams around opening
	// Top
	Body bdOpTop( _Pt0+_ZW*dOpH, vxOp, vyOp, vzOp, opSf.width(), U(2500, 100), U(250, 10), 1, 1, 0);
	// Bottom
	Body bdOpBottom( _Pt0, vxOp, vyOp, vzOp, opSf.width(), U(2500, 100), U(250, 10), 1, -1, 0);
	// Left
	Point3d ptBdLeftStart= ptLeftOp;
	ptBdLeftStart.setZ(ptOrg.Z());
	Vector3d vBdX= -vx;
	Vector3d vBdY= _ZW;
	Vector3d vBdZ= vBdX.crossProduct(vBdY);
	double dBdX= U(500, 20);
	double dBdY= wlOriginal.baseHeight();
	double dBdZ= U(254, 10);
	Body bdLeftSearch( ptBdLeftStart, vBdX, vBdY, vBdZ, dBdX, dBdY, dBdZ, 1, 1, 0);
	// Right
	Point3d ptBdRightStart= ptRightOp;
	ptBdRightStart.setZ(ptOrg.Z());
	vBdX= vx;
	vBdY= _ZW;
	vBdZ= vBdX.crossProduct(vBdY);
	Body bdRightSearch( ptBdRightStart, vBdX, vBdY, vBdZ, dBdX, dBdY, dBdZ, 1, 1, 0);

	// Search all horizontal avobe/below opening  (Must be done before splitting walls)
	if(bSplitVertically)
	{
		for( int b=0; b< bmAllHorizontalsInModule.length(); b++)
		{
			Beam bm= bmAllHorizontalsInModule[b];
			Body bdBm= bm.envelopeBody(); 
	
			if( bdOpTop.hasIntersection( bdBm)) 
			{
				bm.setPanhand(_ThisInst);
				subMap.setString("LOCATION","TOP");
				bm.setSubMap("SUBMAP", subMap);
				_Beam.append( bm);																																			//bm.setColor(1);
			}
			else if( bdOpBottom.hasIntersection( bdBm))
			{
				bm.setPanhand(_ThisInst);
				subMap.setString("LOCATION","BOTTOM");
				bm.setSubMap("SUBMAP", subMap);
				_Beam.append( bm);																																			//bm.setColor(2);
			}
		}
	}

	// Search beams at top, bottom, left and right of opening	 (Must be done before splitting walls)
	for( int b=0; b< bmAllVerticalsInModule.length(); b++)
	{
		Beam bm= bmAllVerticalsInModule[b];
		Body bdBm= bm.envelopeBody();
		
		if(bSplitVertically) // Search beams at top and bottom of opening
		{
			// Search all verticals at top of opening
			if( bdOpTop.hasIntersection( bdBm))
			{
				bm.setPanhand(_ThisInst);
				subMap.setString("LOCATION","TOP");
				bm.setSubMap("SUBMAP", subMap);
				_Beam.append( bm);
			}
			// Search all verticals at bottom of opening
			if( bdOpBottom.hasIntersection( bdBm))
			{
				bm.setPanhand(_ThisInst);
				subMap.setString("LOCATION","BOTTOM");
				bm.setSubMap("SUBMAP", subMap);
				_Beam.append( bm);
			}
		}
		if( bSplitLeftSide && bdLeftSearch.hasIntersection( bdBm)) // Search verticals at left side of opening
		{
			bm.setPanhand(_ThisInst);
			subMap.setString("LOCATION","LEFT");
			bm.setSubMap("SUBMAP", subMap);
			_Beam.append( bm);
		}
		if (bSplitRightSide && bdRightSearch.hasIntersection( bdBm) ) // Search verticals at right side of opening
		{
			bm.setPanhand(_ThisInst);
			subMap.setString("LOCATION","RIGHT");
			bm.setSubMap("SUBMAP", subMap);
			_Beam.append( bm);
		}
	}
		
	// Erase all left beams (force to reframe)
	for(int b=0; b< bmAll.length(); b++)
	{
		Beam bm= bmAll[b];
		Map subMap= bm.subMap("SUBMAP");
		int bDontErase= subMap.getInt("DONT_ERASE_ME");
		if( !bDontErase)
			bm.dbErase();
	}

	// Erase sheeting
	for( int s=0; s<shAll.length(); s++)
	{
		shAll[s].dbErase();	
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
									/////////////////////////////////////////////////////////////////////////////////		SPLITTING WALLS	///////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
									
	Element elLeft, elRight, elCenter, elTop, elBottom;
	Map subMapEl;
	Point3d ptSplitLeft= ptLeftOp;
	ptSplitLeft+=vy*vy.dotProduct(ptOrg- ptLeftOp)+vz*vz.dotProduct(ptOrg- ptLeftOp); // ptOrg=Original element's origin
	Point3d ptSplitRight= ptRightOp;
	ptSplitRight+=vy*vy.dotProduct(ptOrg- ptRightOp)+vz*vz.dotProduct(ptOrg- ptRightOp);
	
	// Adding offset for rough dimension
	ptSplitLeft-= vx*dOffsetWhenRoughDimension;
	ptSplitRight+= vx*dOffsetWhenRoughDimension;

	if( bSplitLeftSide)
	{
		// Split wall
		Wall wlNew= wlOriginal.dbCopy();
		Element elNew= (Element)wlNew;
		_Element.append(elNew);
		
		// Cutting original wall (will keep opening) and create a copy without opening
		Point3d ptOriginalStart= wlOriginal.ptStart();
		Point3d ptOriginalEnd= wlOriginal.ptEnd();
		Point3d ptNewStart, ptNewEnd;
		ptNewStart= ptOriginalStart;
		ptNewEnd= ptSplitLeft;
		wlOriginal.setStartEnd( ptNewStart, ptNewEnd, 1);

		ptNewStart= ptSplitLeft;
		ptNewEnd= ptOriginalEnd;
		wlNew.setStartEnd( ptNewStart, ptNewEnd, 1);		

		elCenter= (Element) wlOriginal;			
		elLeft= elNew;
		Point3d ptArrow= PLine(ptNewStart, ptNewEnd).ptMid();
		((ElementWall)elLeft).setPtArrow(ptArrow);

		subMapEl.setString( "POSITION", "CENTER");
		elCenter.setSubMapX("SUBMAP", subMapEl);
		subMapEl.setString( "POSITION", "LEFT");
		elLeft.setSubMapX("SUBMAP", subMapEl);
	}
	if (bSplitRightSide)
	{
		Wall wlToSplit;
		if( bSplitLeftSide)
		{
			wlToSplit= (Wall)elCenter;
		}
		else
		{
			wlToSplit= wlOriginal;
		}	

		if(!wlToSplit.bIsValid())
		{
			eraseInstance();
			return;
		}
		
		Element elToSplit= (Element)wlToSplit;
		// Split wall
		Wall wlNew= wlToSplit.dbCopy();
		Element elNew= (Element)wlNew;
		_Element.append(elNew);
		
		// Cutting original wall (will keep opening)
		Point3d ptOriginalStart= wlToSplit.ptStart();
		Point3d ptOriginalEnd= wlToSplit.ptEnd();
		Point3d ptNewStart, ptNewEnd;

		if( abs(vx.dotProduct( wlToSplit.ptStart()- ptLeftOp)) < abs(vx.dotProduct( wlToSplit.ptEnd()- ptLeftOp)) ) 
		{
			ptNewStart= ptOriginalStart;
			ptNewEnd= ptSplitRight;
			wlOriginal.setStartEnd( ptNewStart, ptNewEnd, 1);
		
			ptNewStart= ptSplitRight;
			ptNewEnd= ptOriginalEnd;
			wlNew.setStartEnd( ptNewStart, ptNewEnd, 1);
		}
		else
		{
			ptNewStart= ptSplitRight;
			ptNewEnd= ptOriginalEnd;
			wlOriginal.setStartEnd( ptNewStart, ptNewEnd, 1);
		
			ptNewStart= ptOriginalStart;
			ptNewEnd= ptSplitRight;
			wlNew.setStartEnd( ptNewStart, ptNewEnd, 1);
		}
						
		elCenter= elToSplit;
		elRight= elNew;
		Point3d ptArrow= PLine(ptNewStart, ptNewEnd).ptMid();
		((ElementWall)elRight).setPtArrow(ptArrow);

		subMapEl.setString( "POSITION", "CENTER");
		elCenter.setSubMapX("SUBMAP", subMapEl);
		subMapEl.setString( "POSITION", "RIGHT");
		elRight.setSubMapX("SUBMAP", subMapEl);
	}	

	if (bSplitVertically) // Both sides
	{
		double dOffsetForArrows= U( 1500, 60);

		// Get info before apply changes
		elTop= elCenter;
		// Moving bottom element's icon
		Point3d ptArrow= PLine(((Wall)elTop).ptStart(), ((Wall)elTop).ptEnd()).ptMid()- vx*dOffsetForArrows/2;
		((ElementWall)elTop).setPtArrow( ptArrow);

		subMapEl.setString( "POSITION", "TOP");
		elTop.setSubMapX("SUBMAP", subMapEl);
		
		// Erase opening
		double dSillHeight= opSf.sillHeight();
		opSf.dbErase();

		double dMinimumHeightToCreateBottomWall= U(100,4);
		if(  dSillHeight >= dMinimumHeightToCreateBottomWall)
		{ 
			elBottom= elCenter.dbCopy();
			subMapEl.setString( "POSITION", "BOTTOM");
			elBottom.setSubMapX("SUBMAP", subMapEl);

			Wall wlBottom= (Wall)elBottom;
			double dBottomElementNewBaseHeight= _ZW.dotProduct(ptBottomOp-elBottom.ptOrg());
			wlBottom.setBaseHeight(dBottomElementNewBaseHeight);
			_Element.append( elBottom);
			
			// Moving bottom element's icon
			ptArrow= PLine(wlBottom.ptStart(), wlBottom.ptEnd()).ptMid()+ vx*dOffsetForArrows/2;
			((ElementWall)elBottom).setPtArrow( ptArrow);
		}
	
		Wall wlTop= (Wall)elTop;
		Point3d ptOriginalTopPoint= elCenter.ptOrg()+_ZW*wlTop.baseHeight();
		double dTopElementNewElevation= _ZW.dotProduct(ptTopOp-elCenter.ptOrg());
		elTop.transformBy(_ZW*dTopElementNewElevation);
		double dTopElementNewBaseHeight= _ZW.dotProduct(ptOriginalTopPoint-elCenter.ptOrg());
		wlTop.setBaseHeight(dTopElementNewBaseHeight);
	}
	
	// Setting panhand	
	for( int b=0; b< _Beam.length(); b++)
	{
		Beam bm= _Beam[b];
		Map subMap= bm.subMap("SUBMAP");
		String sLocation= subMap.getString("LOCATION");
		if( sLocation == "LEFT")
		{
			bm.setPanhand( elLeft);
			bm.assignToElementGroup( elLeft, TRUE, 0, 'Z');
		}

		if( sLocation == "RIGHT")
		{
			bm.setPanhand( elRight);
			bm.assignToElementGroup( elRight, TRUE, 0, 'Z');
		}

		if( sLocation == "TOP")
		{
			bm.setPanhand( elTop);
			bm.assignToElementGroup( elTop, TRUE, 0, 'Z');
		}

		if( sLocation == "BOTTOM")
		{
			bm.setPanhand( elBottom);
			bm.assignToElementGroup( elBottom, TRUE, 0, 'Z');
		}
	}
	
	Vector3d vxBdSearchSheets= _ZW;
	Vector3d vyBdSearchSheets= vx;
	Vector3d vzBdSearchSheets= vxBdSearchSheets.crossProduct( vyBdSearchSheets);
	double dExtraLength= U(50, 2);
	double dBodySearchSheetsLenght=dWallHeight+dExtraLength*2;
	double dBodySearchSheetsWidth=U(10, .5); 
	double dBodySearchSheetsHeight=U(500, 25);
	Point3d ptSearchSheetsAtLeft= ptSplitLeft;
	Point3d ptSearchSheetsAtRight= ptSplitRight;

	_Map.setPoint3d("PT_TO_SEARCH_SHEETS_AT_LEFT_OF_OPENING", ptSearchSheetsAtLeft);
	_Map.setPoint3d("PT_TO_SEARCH_SHEETS_AT_RIGHT_OF_OPENING", ptSearchSheetsAtRight);
	_Map.setVector3d("VX_BODY_SEARCH", vxBdSearchSheets);
	_Map.setVector3d("VY_BODY_SEARCH", vyBdSearchSheets);
	_Map.setVector3d("VZ_BODY_SEARCH", vzBdSearchSheets);
	_Map.setDouble("BODY_SEARCH_LENGTH", dBodySearchSheetsLenght);
	_Map.setDouble("BODY_SEARCH_WIDTH", dBodySearchSheetsWidth);
	_Map.setDouble("BODY_SEARCH_HEIGHT", dBodySearchSheetsHeight);
	
	reportMessage("\n\n"+T("|Wall successfully split. Please re-frame resulting walls.|"));
	_Map.setInt("SplitWall",1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
										/////////////////////////////////////////////////////////////////////////////////		CONSTRUCTING WALLS	///////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if( _bOnElementConstructed)
{
	Element elLeft, elRight, elCenter, elTop, elBottom;
		
	for(int e=0; e< _Element.length(); e++)
	{
		Element el= _Element[e];
		if( !el.bIsValid())
		{
			continue;
		}		
		
		Beam bmAll[]= el.beam();
		if( bmAll.length() ==0)
		{
			reportMessage("\n\nTSL "+scriptName()+ ": " +T("|Wall| ")+ el.number()+ " " +T(" |not framed|") );
			continue;
		}
		
		Map subMap= el.subMapX("SUBMAP");
		Vector3d vxOriginal= _Map.getVector3d("ORIGINAL_VX");
	      double dOffsetWhenRoughDimension= _Map.getDouble("OFFSET_WHEN_ROUGH_DIMENSION"); // Per side
		double dWallHeight= _Map.getDouble("WALL_HEIGHT");
		Point3d ptLeftOp= _Map.getPoint3d( "PT_LEFT_OP");
		Point3d ptRightOp= _Map.getPoint3d( "PT_RIGHT_OP");
		Point3d ptStretchTopsAtLeft= _Map.getPoint3d("PT_TO_STRETCH_TOPS_AT_LEFT_OF_OPENING");
		Point3d ptStretchTopsAtRight= _Map.getPoint3d("PT_TO_STRETCH_TOPS_AT_RIGHT_OF_OPENING");
		Point3d ptStretchBottomsAtLeft= _Map.getPoint3d("PT_TO_STRETCH_BOTTOMS_AT_LEFT_OF_OPENING");
		Point3d ptStretchBottomsAtRight= _Map.getPoint3d("PT_TO_STRETCH_BOTTOMS_AT_RIGHT_OF_OPENING");
		Point3d ptSearchSheetsAtLeft= _Map.getPoint3d("PT_TO_SEARCH_SHEETS_AT_LEFT_OF_OPENING");
		Point3d ptSearchSheetsAtRight= _Map.getPoint3d("PT_TO_SEARCH_SHEETS_AT_RIGHT_OF_OPENING");
		Point3d ptStretchSheetsAtLeft= _Map.getPoint3d("PT_TO_STRETCH_SHEETS_AT_LEFT_OF_OPENING");
		Point3d ptStretchSheetsAtRight= _Map.getPoint3d("PT_TO_STRETCH_SHEETS_AT_RIGHT_OF_OPENING");

		Beam bmAllVerticals[]= el.vecX().filterBeamsPerpendicular( bmAll);
		Beam bmAllHorizontals[]= el.vecY().filterBeamsPerpendicular( bmAll);
		int bEraseBeams= false;
				
		// Define parameters for searching sheets body 
		Vector3d vxBdSearchSheets= _Map.getVector3d("VX_BODY_SEARCH");
		Vector3d vyBdSearchSheets= _Map.getVector3d("VY_BODY_SEARCH");
		Vector3d vzBdSearchSheets= _Map.getVector3d("VZ_BODY_SEARCH");
		double dBodySearchSheetsLength= _Map.getDouble("BODY_SEARCH_LENGTH");
		double dBodySearchSheetsWidth= _Map.getDouble("BODY_SEARCH_WIDTH");
		double dBodySearchSheetsHeight=_Map.getDouble("BODY_SEARCH_HEIGHT");
		
		Sheet shAll[0];
		if(dOffsetWhenRoughDimension>0)
		{
			shAll.append( el.sheet());
		}
		
		if( subMap.getString("POSITION") == "LEFT") ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	LEFT WALL	/////////////////////////////////////////////////
		{
				
			elLeft= el;
			bEraseBeams= true;
			// Work with horizontal beams
			for (int b=0; b< bmAllHorizontals.length(); b++)
			{
				Beam bm= bmAllHorizontals[b];

				Vector3d vCutLeft= bm.vecX();
				if( vCutLeft.dotProduct( ptStretchTopsAtLeft- bm.ptCen()) <0)
					vCutLeft= -vCutLeft;

				if(bm.type() == _kTopPlate || bm.type() == _kSFTopPlate || bm.type() == _kSFVeryTopPlate ) // Stretch bottom plates
				{
					Cut ctLeft( ptStretchTopsAtLeft, vCutLeft);
					bm.addToolStatic( ctLeft, true);
				}
				else if(bm.type() == _kBottom || bm.type() == _kSFBottomPlate)// Stretch bottom plates
				{
					Cut ctLeft( ptStretchBottomsAtLeft, vCutLeft);
					bm.addToolStatic( ctLeft, true);
				}				
			}

			// get closest stud at right of module
			Point3d ptExtremeLeftInModule= _Map.getPoint3d("PT_EXTREME_LEFT_IN_MODULE");
			Beam bmAllAtLeft[]= Beam().filterBeamsHalfLineIntersectSort(bmAllVerticals, ptExtremeLeftInModule-vxOriginal*dTolerance, -vxOriginal);
			Beam bmClosestLeft= bmAllAtLeft[0];
			
			// search sheets at edge, and stretch them				
			Body bdSearchLeft;				
			if( bSplitRightSide)
			{
				Body bdTmp( ptSearchSheetsAtLeft, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
				bdSearchLeft= bdTmp;
			}
			else
			{
				Body bdTmp( ptSearchSheetsAtLeft, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
				bdSearchLeft= bdTmp;
			}
			
			// Do work for every sheeting zone when rough dimension
			if(dOffsetWhenRoughDimension>0)
			{
				for(int z=-5; z<6; z++)
				{	
					if( z==0)
						continue;
	
					ElemZone elz= el.zone(z);
					double dZoneW=elz.dVar("width");
					Sheet shZone[]= el.sheet(z);
	 
					for( int s=0; s< shZone.length(); s++)
					{
						Sheet sh1= shZone[s];
						if( bdSearchLeft.hasIntersection( sh1.realBody()) && sh1.bIsValid()) // Possible sheet to be treated
						{
							Point3d ptLeftSh= sh1.ptCen()+vxOriginal*sh1.dD(vxOriginal)*.5;
							double dDistanceToEdge= vxOriginal.dotProduct(ptStretchSheetsAtLeft-ptLeftSh);
							if( abs( dDistanceToEdge) > dTolerance*2)
							{
								if( dDistanceToEdge >0)   // Sheet must be extended: copied, move copy offset distance and join both sheets. Check if it's longer than allowed width, cut if so
								{																																										
									double dShW= sh1.dD(vxOriginal);																							
									double dWidthIfExtended= dShW+dOffsetWhenRoughDimension;
									Point3d ptCut;
									if( bSplitRightSide)
										ptCut= ptStretchSheetsAtLeft;
									else
										ptCut= ptStretchSheetsAtLeft;
									
									Sheet sh2; sh2=sh1.dbCopy();
									sh2.transformBy( vxOriginal*dOffsetWhenRoughDimension);
									sh1.dbJoin(sh2);
									if( dWidthIfExtended > dZoneW) // sheet will exceed zone width -> must be splitted at stud location
									{
										sh1.dbSplit( Plane(ptCut, vxOriginal), 0);
									}
								}
								// else; // Sheet must be cut, leftover must be erased (???)
							}
						}
					}
				}
			}
		}

		else if( subMap.getString("POSITION") == "RIGHT") ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	RIGHT WALL	/////////////////////////////////////////////////
		{
			elRight= el;
			bEraseBeams= true;
			// Work with horizontal beams
			for (int b=0; b< bmAllHorizontals.length(); b++)
			{
				Beam bm= bmAllHorizontals[b];
				Vector3d vCutRight= bm.vecX();
				if( vCutRight.dotProduct( ptStretchTopsAtRight- bm.ptCen()) <0)
					vCutRight= -vCutRight;

				if(bm.type() == _kTopPlate || bm.type() == _kSFTopPlate || bm.type() == _kSFVeryTopPlate ) // Stretch top plates
				{
					Cut ctRight( ptStretchTopsAtRight, vCutRight);
					bm.addToolStatic( ctRight, true);
				}
				else if(bm.type() == _kBottom || bm.type() == _kSFBottomPlate)// Stretch bottom plates
				{
					Cut ctRight( ptStretchBottomsAtRight, vCutRight);
					bm.addToolStatic( ctRight, true);
				}
			}
			
			// Work with sheeting
			if( dOffsetWhenRoughDimension>0) // Opening measured to inside of frame
			{
				// get closest stud at right of module
				Point3d ptExtremeRightInModule= _Map.getPoint3d("PT_EXTREME_RIGHT_IN_MODULE");
				Beam bmAllAtRight[]= Beam().filterBeamsHalfLineIntersectSort(bmAllVerticals, ptExtremeRightInModule+vxOriginal*dTolerance, vxOriginal);
				Beam bmClosestRight= bmAllAtRight[0];
				
				// search sheets at edge, and stretch them
				Body bdSearchRight;
				if( bSplitLeftSide)
				{
					Body bdTmp( ptSearchSheetsAtRight, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
					bdSearchRight= bdTmp;
				}
				else
				{
					Body bdTmp( ptSearchSheetsAtRight, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
					bdSearchRight= bdTmp;
				}

				// Do work for every sheeting zone
				for(int z=-5; z<6; z++)
				{	
					if( z==0)
						continue;

					ElemZone elz= el.zone(z);
					double dZoneW=elz.dVar("width");
					Sheet shZone[]= el.sheet(z);
					for( int s=0; s< shZone.length(); s++)
					{
						Sheet sh1= shZone[s];
						if( bdSearchRight.hasIntersection( sh1.realBody()) && sh1.bIsValid())
						{
							Point3d ptLeftAtRightSheet= sh1.ptCen()-vxOriginal*sh1.dD(vxOriginal)*.5;
							double dDistanceToEdge= vxOriginal.dotProduct(ptLeftAtRightSheet- ptStretchSheetsAtRight);
							if( abs( dDistanceToEdge) > dTolerance*2)
							{
								if(dDistanceToEdge >0) // Sheet must be copied, move copy offset distance and join both sheets
								{
									double dShW= sh1.dD(vxOriginal);
									double dWidthIfExtended= dShW+dOffsetWhenRoughDimension;
									Point3d ptCut;
									if( bSplitLeftSide)
										ptCut= bmClosestRight.ptCen();
									else
										ptCut= ptStretchSheetsAtRight;
	
									Sheet sh2; sh2=sh1.dbCopy();
									sh2.transformBy( -vxOriginal*dOffsetWhenRoughDimension);
									sh1.dbJoin(sh2);
									if( dWidthIfExtended > dZoneW) // sheet will exceed zone width -> must be splitted at stud location
									{
										sh1.dbSplit( Plane(ptCut, vxOriginal), 0);
									}
								}
							}
							// else; // Sheet must be cut, leftover must be erased (???)
						}
					}
				}
			}
		}

		else if( subMap.getString("POSITION") == "CENTER") ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	CENTER WALL  /////////////////////////////////////////////////
		{
			bEraseBeams= true;
			
			// make sure we have the right type of opening
			OpeningSF opSf = (OpeningSF)_Opening[0]; // explicit cast
			if (!opSf.bIsValid()) { // want to keep only the OpeningSF types
				reportMessage(T("|Not valid opening provided, contact customer support please|"));
				return;
			}
			
			// Get top, bottom, left and right vertex of opening (including gaps)
			double dOpW= opSf.width();
			double dOpH= opSf.height();
			CoordSys csOp = opSf.coordSys();
			Point3d ptOpOrg= csOp.ptOrg();
			Vector3d vxOp = csOp.vecX();
			Vector3d vyOp = csOp.vecY();
			Vector3d vzOp = csOp.vecZ();
			Body bdOpTop( ptOpOrg+_ZW*dOpH, vxOp, vyOp, vzOp, opSf.width(), U(2500, 100), U(250, 10), 1, 1, 0);
			Body bdOpBottom( ptOpOrg, vxOp, vyOp, vzOp, opSf.width(), U(2500, 100), U(250, 10), 1, -1, 0);

			Point3d ptLeftOp= ptOpOrg- vxOp*(opSf.dGapSide()+dTolerance);
			Point3d ptRightOp= ptOpOrg + vxOp* (dOpW+ opSf.dGapSide()+dTolerance);
			Point3d ptBottomOp= ptOpOrg - vyOp* (opSf.dGapBottom()+dTolerance);
			Point3d ptTopOp= ptOpOrg + vyOp* (dOpH+ opSf.dGapTop()+dTolerance);

			int bHeaderBelowPlate= _Map.getInt("HEADER_BELOW_PLATE");			
			if (!bHeaderBelowPlate)
			{
				// Work with horizontal beams
				for (int b=0; b< bmAllHorizontals.length(); b++)
				{
					Beam bm= bmAllHorizontals[b];
					if(bm.type() == _kTopPlate || bm.type() == _kSFTopPlate || bm.type() == _kSFVeryTopPlate ) // Stretch top plates
					{
						if( bSplitLeftSide)
						{	
							Vector3d vCutLeft= bm.vecX();
							if( vCutLeft.dotProduct( ptStretchTopsAtLeft- bm.ptCen()) <0)
								vCutLeft= -vCutLeft;
							Cut ctLeft( ptStretchTopsAtLeft, vCutLeft);
							bm.addToolStatic( ctLeft, true);
						}

						if( bSplitRightSide)
						{	
							Vector3d vCutRight= bm.vecX();
							if( vCutRight.dotProduct( ptStretchTopsAtRight- bm.ptCen()) <0)
								vCutRight= -vCutRight;
							Cut ctRight( ptStretchTopsAtRight, vCutRight);
							bm.addToolStatic( ctRight, true);
						}	
					}
					else if(bm.type() == _kBottom || bm.type() == _kSFBottomPlate)// Stretch bottom plates
					{
						if( bSplitLeftSide)
						{	
							Vector3d vCutLeft= bm.vecX();
							if( vCutLeft.dotProduct( ptStretchBottomsAtLeft- bm.ptCen()) <0)
								vCutLeft= -vCutLeft;
							Cut ctLeft( ptStretchBottomsAtLeft, vCutLeft);
							bm.addToolStatic( ctLeft, true);
						}

						if( bSplitRightSide)
						{	
							Vector3d vCutRight= bm.vecX();
							if( vCutRight.dotProduct( ptStretchBottomsAtRight- bm.ptCen()) <0)
								vCutRight= -vCutRight;
							Cut ctRight( ptStretchBottomsAtRight, vCutRight);
							bm.addToolStatic( ctRight, true);
						}					
					}
				}
				
				// Work with vertical beams
				Beam bmAnyCrippleOnTop, bmAnyCrippleOnBottom, bmAllCripples[0];
				for (int b=0; b< bmAllVerticals.length(); b++)
				{
					Beam bm= bmAllVerticals[b];
					Body bdBm= bm.envelopeBody();
					if( bdBm.hasIntersection( bdOpTop))
					{
						if( bm.type() == _kSFStudLeft || bm.type() == _kSFStudRight ) // Erasing frame on this side
							bm.dbErase();
						else if( bm.type() == _kSFJackOverOpening)
						{
							bmAnyCrippleOnTop=bm;
							bmAllCripples.append(bm);
						}
					}
					if( bdBm.hasIntersection( bdOpBottom))
					{
						if( bm.type() == _kSFStudLeft || bm.type() == _kSFStudRight )
							bm.dbErase();
						else if( bm.type() == _kSFJackUnderOpening)
						{
							bmAnyCrippleOnBottom=bm;
							bmAllCripples.append(bm);
						}
					}
				}
				
				Beam bmNewCripples[0];
				Beam bmNewCrippleOnTop= bmAnyCrippleOnTop.dbCopy();
				Beam bmNewExtraCrippleOnTop= bmAnyCrippleOnTop.dbCopy();
				Beam bmNewCrippleOnBottom= bmAnyCrippleOnBottom.dbCopy();
				Point3d ptRelocate;
				if( bSplitLeftSide)
				{
					if( bmAnyCrippleOnTop.bIsValid())
					{
						ptRelocate=ptStretchBottomsAtLeft+ vxOriginal*bmNewCrippleOnTop.dD(vxOriginal)*.5;
						bmNewCrippleOnTop.transformBy(vxOriginal*vxOriginal.dotProduct(ptRelocate-bmNewCrippleOnTop.ptCen()));
						ptRelocate=ptStretchBottomsAtLeft- vxOriginal*bmNewExtraCrippleOnTop.dD(vxOriginal)*.5;
						bmNewExtraCrippleOnTop.transformBy(vxOriginal*vxOriginal.dotProduct(ptRelocate-bmNewExtraCrippleOnTop.ptCen()));
						bmNewCripples.append(bmNewCrippleOnTop);
						bmNewCripples.append(bmNewExtraCrippleOnTop);
					}
					if( bmAnyCrippleOnBottom.bIsValid())
					{
						ptRelocate=ptStretchBottomsAtLeft+ vxOriginal*bmNewCrippleOnBottom.dD(vxOriginal)*.5;
						bmNewCrippleOnBottom.transformBy(vxOriginal*vxOriginal.dotProduct(ptRelocate-bmNewCrippleOnBottom.ptCen()));
						bmNewCripples.append(bmNewCrippleOnBottom);
					}
				}
				if( bSplitRightSide)
				{
					if( bmAnyCrippleOnTop.bIsValid())
					{
						ptRelocate=ptStretchBottomsAtRight- vxOriginal*bmNewCrippleOnTop.dD(vxOriginal)*.5;
						bmNewCrippleOnTop.transformBy(vxOriginal*vxOriginal.dotProduct(ptRelocate-bmNewCrippleOnTop.ptCen()));						
						ptRelocate=ptStretchBottomsAtRight+ vxOriginal*bmNewExtraCrippleOnTop.dD(vxOriginal)*.5;
						bmNewExtraCrippleOnTop.transformBy(vxOriginal*vxOriginal.dotProduct(ptRelocate-bmNewExtraCrippleOnTop.ptCen()));
						bmNewCripples.append(bmNewCrippleOnTop);
						bmNewCripples.append(bmNewExtraCrippleOnTop);
					}
					if( bmAnyCrippleOnBottom.bIsValid())
					{
						ptRelocate=ptStretchBottomsAtRight- vxOriginal*bmNewCrippleOnBottom.dD(vxOriginal)*.5;
						bmNewCrippleOnBottom.transformBy(vxOriginal*vxOriginal.dotProduct(ptRelocate-bmNewCrippleOnBottom.ptCen()));
						bmNewCripples.append(bmNewCrippleOnBottom);
					}
				}
		
				_Beam.append( bmNewCrippleOnTop);
				_Beam.append( bmNewExtraCrippleOnTop);
				_Beam.append( bmNewCrippleOnBottom);
				
				// Checking interference
				for( int n=0; n<bmNewCripples.length(); n++)
				{
					Beam bmNew= bmNewCripples[n];
					for( int b=0; b<bmAllCripples.length(); b++)
					{
						Beam bmCripple= bmAllCripples[b];
						if( bmNew.realBody().hasIntersection( bmCripple.realBody()))
							bmCripple.dbErase();
					}				
				}				
			
				// Working with sheeting
				if( bSplitLeftSide)
				{
					Body bdSearchLeft( ptSearchSheetsAtLeft, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
					for( int s=0; s< shAll.length(); s++)
					{
						Sheet sh= shAll[s];
						if( bdSearchLeft.hasIntersection( sh.realBody()) && sh.bIsValid() )
						{
							Point3d ptLeftSh= sh.ptCen()-vxOriginal*sh.dD(vxOriginal)*.5;
							double dDistanceToEdge= vxOriginal.dotProduct(ptStretchSheetsAtLeft-ptLeftSh);
							if( abs( dDistanceToEdge) > dTolerance*2)
							{
								if( dDistanceToEdge >0)   // Sheet must be cut, leftover must be erased
								{
									Point3d ptCut= ptStretchSheetsAtLeft;
									Sheet shResulting[]=sh.dbSplit( Plane(ptCut, vxOriginal), 0);
									shResulting.append(sh);
									for( int r=0; r<shResulting.length(); r++)
									{
										Sheet shR= shResulting[r];
										if( vxOriginal.dotProduct(ptStretchSheetsAtLeft-shR.ptCen()) > 0)
											shR.dbErase();
									}									
								}								
							}
						}	
					}
				}
				
				if( bSplitRightSide)
				{
					Body bdSearchRight( ptSearchSheetsAtRight, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
					for( int s=0; s< shAll.length(); s++)
					{
						Sheet sh= shAll[s];
						if( bdSearchRight.hasIntersection( sh.realBody()) && sh.bIsValid() )						
						{
							Point3d ptRightSh= sh.ptCen()+vxOriginal*sh.dD(vxOriginal)*.5;
							double dDistanceToEdge= vxOriginal.dotProduct(ptRightSh- ptStretchSheetsAtRight);
							if( abs( dDistanceToEdge) > dTolerance*2)
							{
								if( dDistanceToEdge >0)   // Sheet must be cut, leftover must be erased
								{
									Point3d ptCut= ptStretchSheetsAtRight;
									Sheet shResulting[]=sh.dbSplit( Plane(ptCut, vxOriginal), 0);
									shResulting.append(sh);
									for( int r=0; r<shResulting.length(); r++)
									{
										Sheet shR= shResulting[r];
										if( vxOriginal.dotProduct(shR.ptCen()- ptStretchSheetsAtRight) > 0)
											shR.dbErase();
									}									
								}								
							}
						}	
					}
				}				
				
			}// end if header below plate
		}

		else if( subMap.getString("POSITION") == "TOP") ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	TOP WALL	/////////////////////////////////////////////////
		{
			elTop= el;
			Beam bmAllCreated[0];
			// Work with vertical beams
			// Replace all vertical beams generated by wall.exe with one of the originals from window framing
			// Get any of the vertical beams from window framing
			Beam bmAnyCripple;
			int bAnyFound= false;
			for (int b=0; b< bmAllVerticals.length(); b++)
			{
				Beam bm= bmAllVerticals[b];
				if( !bm.bIsValid())
					continue;
				Map subMap= bm.subMap("SUBMAP");
				int bDontErase= subMap.getInt("DONT_ERASE_ME");
				if( bDontErase)
				{
					if( !bAnyFound)
					{
						bmAnyCripple= bm;
						bAnyFound= true; // Got any vertical (cripple)
					}
					else
					{							
						bm.dbErase(); // erase all other than any found
					}
				}
				else
					bm.dbErase();
			}
			
			// Reframe cripples			
			// Relocate bmAnyCripple to left side
			Beam bmLeftCripple= bmAnyCripple;
			Point3d ptRelocateLeft= ptStretchBottomsAtLeft+vxOriginal*bmLeftCripple.dD(vxOriginal)*.5;
			bmLeftCripple.transformBy(vxOriginal*(vxOriginal.dotProduct( ptRelocateLeft- bmLeftCripple.ptCen())));
			_Beam.append(bmLeftCripple);
			//bmAllCreated.append(bmLeftCripple);

			// Create extra cripple for holding sheeting on LEFT element
			Beam bmExtraLeftCripple= bmLeftCripple.dbCopy();
			bmExtraLeftCripple.transformBy( -vxOriginal*bmExtraLeftCripple.dD(vxOriginal));
			_Beam.append(bmExtraLeftCripple);
			//bmAllCreated.append(bmExtraLeftCripple);

			// Create cripple for right side 
			Beam bmRightCripple= bmAnyCripple.dbCopy();
			Point3d ptRelocateRight= ptStretchBottomsAtRight-vxOriginal*bmRightCripple.dD(vxOriginal)*.5;
			bmRightCripple.transformBy( vxOriginal*vxOriginal.dotProduct( ptRelocateRight- bmRightCripple.ptCen()));
			_Beam.append(bmRightCripple);
			//bmAllCreated.append(bmRightCripple);
			
			// Create extra cripple for holding sheeting on RIGHT element
			Beam bmExtraRightCripple= bmRightCripple.dbCopy();
			bmExtraRightCripple.transformBy( vxOriginal*bmExtraRightCripple.dD(vxOriginal));
			_Beam.append(bmExtraRightCripple);
			//bmAllCreated.append(bmExtraRightCripple);
			
			// Create cripples for sheeting
			ElemZone elz= el.zone(1);
			double dZoneW=elz.dVar("width");
			if( dZoneW <= 0)
			{
				reportNotice("\n"+T("|ERROR: This should not happen. Please inform any hsb representative...|"));
				eraseInstance();
				return;
			}
			
			Point3d ptStartCripples= ptStretchBottomsAtLeft;
			Point3d ptEndCripples= ptStretchBottomsAtRight- vxOriginal*bmAnyCripple.dD(vxOriginal)*1.5;
			double dMax= abs( vxOriginal.dotProduct( ptStartCripples- ptEndCripples));
			double dActualDistance=0;
			Beam bmEraseMe; // Will be one exceeding
			int nBeamsBewteenSheetExtremes= 2;
			double dDistanceBetweenCripples= dZoneW/(nBeamsBewteenSheetExtremes+1);
			for( int i=1; dActualDistance<=dMax; i++)
			{
				dActualDistance+=dDistanceBetweenCripples;
				Beam bmNewCripple= bmLeftCripple.dbCopy();
				bmNewCripple.transformBy( vxOriginal*dActualDistance);
				bmNewCripple.transformBy( vxOriginal*-bmLeftCripple.dD(vxOriginal)*.5);
				_Beam.append(bmNewCripple);
				bmAllCreated.append(bmNewCripple);
				bmEraseMe= bmNewCripple;	
			}
			
			bmEraseMe.dbErase();
			
			// Adding props to created cripples
			for( int b=0; b< bmAllCreated.length(); b++)
			{
				Beam bm= bmAllCreated[b];
				if( !bm.bIsValid())
					continue;
				bm.assignToElementGroup( elTop, true, 0, 'Z');
			}
	
			// WORK WITH SHEETING
			// LEFT SIDE: Relocate sheeting
			Point3d ptStart= ((Wall)elTop).ptStart();
			Point3d ptEnd= ((Wall)elTop).ptEnd();
			Point3d ptLeftCrippleCen= bmLeftCripple.ptCen();
			Point3d ptStartSheeting;
			if( abs(vxOriginal.dotProduct( ptStart-ptLeftCrippleCen)) < abs(vxOriginal.dotProduct( ptEnd-ptLeftCrippleCen)) )
				ptStartSheeting= ptStart;
			else
				ptStartSheeting= ptEnd;
				
			double dDisplace= abs( vxOriginal.dotProduct( ptStartSheeting- ptLeftCrippleCen))- bmLeftCripple.dD(vxOriginal)*.5;
			for( int s=0; s<shAll.length(); s++)
			{
				Sheet sh= shAll[s];
				sh.transformBy( vxOriginal* dDisplace);
			}
	
			// RIGHT SIDE: cut all exceeding, erase leftovers
			Body bdSearchRight( ptSearchSheetsAtRight, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
					
			for( int s=0; s< shAll.length(); s++)
			{
				Sheet sh1= shAll[s];	
				if( bdSearchRight.hasIntersection( sh1.realBody()))
				{		
					Sheet ResultRight[]= sh1.dbSplit( Plane( ptStretchBottomsAtRight+vxOriginal*dTolerance, vxOriginal), 0);
					if(ResultRight.length()>0)
					{	
						Sheet sh2= ResultRight[0];
						if( vxOriginal.dotProduct( sh1.ptCen()- sh2.ptCen()) <0)
							sh2.dbErase();
						else
							sh1.dbErase();
					}
				}	
			}

			// Work with horizontal beams
			for (int b=0; b< bmAllHorizontals.length(); b++)
			{
				Beam bm= bmAllHorizontals[b];
				Map subMap= bm.subMap("SUBMAP");
				int bDontErase= subMap.getInt("DONT_ERASE_ME");

				// Delete all horizontals that are not tops or headers and are NOT part of assembly
				if(bm.type() != _kTopPlate && bm.type() != _kSFTopPlate && bm.type() != _kSFVeryTopPlate && bm.type() != _kSFAngledTPLeft && bm.type() != _kSFAngledTPRight && bm.type() != _kHeader) 
				{
					if( !bDontErase)
					{
						bm.dbErase();
					}
				}
				else if(bm.type() == _kTopPlate || bm.type() == _kSFTopPlate || bm.type() == _kSFVeryTopPlate || bm.type() == _kSFAngledTPLeft || bm.type() == _kSFAngledTPRight ) // Stretch top plates
				{
					Vector3d vCutLeft= bm.vecX();
					if( vCutLeft.dotProduct( ptStretchTopsAtLeft- bm.ptCen()) <0)
						vCutLeft= -vCutLeft;
					Cut ctLeft( ptStretchTopsAtLeft, vCutLeft);
					bm.addToolStatic( ctLeft, true);

					Vector3d vCutRight= bm.vecX();
					if( vCutRight.dotProduct( ptStretchTopsAtRight- bm.ptCen()) <0)
						vCutRight= -vCutRight;
					Cut ctRight( ptStretchTopsAtRight, vCutRight);
					bm.addToolStatic( ctRight, true);
				}
			}
 		}

		else if( subMap.getString("POSITION") == "BOTTOM") ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	BOTTOM WALL /////////////////////////////////////////////////
		{
			elBottom= el;	
			
			// Work with vertical beams
			// Replace all vertical beams generated by wall.exe with one of the originals from window framing
			// Get any of the vertical beams from window framing
			Beam bmAny, bmAllCripples[0];
			int bAnyFound= false;
			for (int b=0; b< bmAllVerticals.length(); b++)
			{
				Beam bm= bmAllVerticals[b];
				if( !bm.bIsValid())
					continue;
				Map subMap= bm.subMap("SUBMAP");
				int bDontErase= subMap.getInt("DONT_ERASE_ME");
				if( bDontErase)
				{
					if( !bAnyFound)
					{
						bmAny= bm;
						bAnyFound= true;
					}
					else
					{							
						bm.dbErase();
					}
				}
			}
			
			// Make copies of every beam created by wall.exe
			int bAnyMoved= false;
			for (int b=0; b< bmAllVerticals.length(); b++)
			{
				Beam bm= bmAllVerticals[b];
				if( !bm.bIsValid())
					continue;
				Map subMap= bm.subMap("SUBMAP");
				int bDontErase= subMap.getInt("DONT_ERASE_ME");
				if( !bDontErase)
				{
					if( !bAnyMoved) // Move bmAny
					{
						bmAny.transformBy( vxOriginal*vxOriginal.dotProduct(bm.ptCen()- bmAny.ptCen()));
						bmAllCripples.append( bmAny);
						bAnyMoved= true;
					}
					else // Move copy of bmAny
					{
						Beam bmNew= bmAny.dbCopy();
						bmNew.transformBy( vxOriginal*vxOriginal.dotProduct(bm.ptCen()- bmNew.ptCen()));
						_Beam.append( bmNew);
						bmAllCripples.append( bmNew);
					}
					bm.dbErase();
				}
			}	

			// Create 2 extra cripples to nail sheeting 
			Beam bm1, bm2;
			if( !	_Map.getInt("ExecutionMode")) // wall.exe won't erase these
			{
				bmAny= bmAllVerticals[0];
				bm1= bmAny.dbCopy();
				bm1.transformBy(vxOriginal*(vxOriginal.dotProduct(ptLeftOp- bm1.ptCen())+bm1.dD(vxOriginal)*.5));
				bm2= bmAllVerticals[0].dbCopy();
				bm2.transformBy(vxOriginal*(vxOriginal.dotProduct(ptRightOp- bm2.ptCen())-bm2.dD(vxOriginal)*.5));
				_Beam.append( bm1);
				_Beam.append( bm2);
			}
			
			// Check interfierence between cripples and 2 extra created
			for( int b=0; b< bmAllCripples.length(); b++)
			{
				Beam bm= bmAllCripples[b];
				Body bdBm= bm.envelopeBody();
				if( bdBm.hasIntersection( bm1.envelopeBody()) || bdBm.hasIntersection( bm2.envelopeBody()))
				{
					bm.dbErase();
				}
			}

			// Work with horizontal beams
			for (int b=0; b< bmAllHorizontals.length(); b++)
			{
				Beam bm= bmAllHorizontals[b];
				if(bm.type() != _kBottom && bm.type() != _kSFBottomPlate) // Delete all horizontals that are not tops or headers
				{
					Map subMap= bm.subMap("SUBMAP");
					int bDontErase= subMap.getInt("DONT_ERASE_ME");
					if( !bDontErase)
						bm.dbErase();
				}
			}			
		}
		
		if( bEraseBeams)
		{
			for( int i=0; i< bmAllVerticals.length(); i++)
			{
				Beam bm= bmAllVerticals[i];
				Body bdBm= bm.envelopeBody();
				Map subMap= bm.subMap("SUBMAP");
				for( int j= 0; j< _Beam.length(); j++)
				{
					Beam bm1= _Beam[j];
					Body bdBm1= bm1.envelopeBody();
					if( bdBm.hasIntersection(bdBm1) && bm!= bm1)
					{
						int bDontErase= subMap.getInt("DONT_ERASE_ME");
						if( !bDontErase)
						{
							bm.dbErase();	
						}
					}
				}
			}
			for( int i=0; i< bmAllHorizontals.length(); i++)
			{
				Beam bm= bmAllHorizontals[i];
				Body bdBm= bm.envelopeBody();
				for( int j= 0; j< _Beam.length(); j++)
				{
					Beam bm1= _Beam[j];
					Body bdBm1= bm1.envelopeBody();
					if( bdBm.hasIntersection(bdBm1) && bm!= bm1 && ( bm.type() == _kSFBlocking && bm.type() == _kBlocking ) )
					{
						Map subMap= bm.subMap("SUBMAP");
						int bDontErase= subMap.getInt("DONT_ERASE_ME");
						if( !bDontErase)
							bm.dbErase();	
					}
				}
			}
		}
	}
	
	// Setting panhand
	for( int b=0; b< _Beam.length(); b++)
	{
		Beam bm= _Beam[b];
		Map subMap= bm.subMap("SUBMAP");
		String sLocation= subMap.getString("LOCATION");
		if( sLocation == "LEFT")
		{
			bm.setPanhand( elLeft);
			bm.assignToElementGroup( elLeft, TRUE, 0, 'Z');
		}

		if( sLocation == "RIGHT")
		{
			bm.setPanhand( elRight);
			bm.assignToElementGroup( elRight, TRUE, 0, 'Z');
		}

		if( sLocation == "TOP")
		{
			bm.setPanhand( elTop);
			bm.assignToElementGroup( elTop, TRUE, 0, 'Z');
		}

		if( sLocation == "BOTTOM")
		{
			bm.setPanhand( elBottom);
			bm.assignToElementGroup( elBottom, TRUE, 0, 'Z');
		}
	}
	_Map.setInt("ExecutionMode",1);
}

if( _Element.length() == 0)
{
	eraseInstance();
	return;
}

if( _bOnDebug)
{
	Vector3d vxOriginal= _Map.getVector3d("ORIGINAL_VX");
	double bSplitLeftSide= _Map.getInt("SPLIT_LEFT");
	double bSplitRightSide= _Map.getInt("SPLIT_RIGHT");
	Point3d ptLeftOp= _Map.getPoint3d( "PT_LEFT_OP");
	Point3d ptRightOp= _Map.getPoint3d( "PT_RIGHT_OP");
	Point3d ptStretchTopsAtLeft= _Map.getPoint3d("PT_TO_STRETCH_TOPS_AT_LEFT_OF_OPENING");
	Point3d ptStretchTopsAtRight= _Map.getPoint3d("PT_TO_STRETCH_TOPS_AT_RIGHT_OF_OPENING");
	Point3d ptStretchBottomsAtLeft= _Map.getPoint3d("PT_TO_STRETCH_BOTTOMS_AT_LEFT_OF_OPENING");
	Point3d ptStretchBottomsAtRight= _Map.getPoint3d("PT_TO_STRETCH_BOTTOMS_AT_RIGHT_OF_OPENING");
	Point3d ptSearchSheetsAtLeft= _Map.getPoint3d("PT_TO_SEARCH_SHEETS_AT_LEFT_OF_OPENING");
	Point3d ptSearchSheetsAtRight= _Map.getPoint3d("PT_TO_SEARCH_SHEETS_AT_RIGHT_OF_OPENING");
	double dWallHeight= _Map.getDouble("WALL_HEIGHT");
	Point3d ptTopOp= _Map.getPoint3d( "PT_TOP_OP");
	Point3d ptBottomOp= _Map.getPoint3d( "PT_BOTTOM_OP");
	Point3d ptCenOp= _Map.getPoint3d( "PT_CENTER_OP");

	// Define parameters for searching sheets body 
	Vector3d vxBdSearchSheets= _Map.getVector3d("VX_BODY_SEARCH");
	Vector3d vyBdSearchSheets= _Map.getVector3d("VY_BODY_SEARCH");;
	Vector3d vzBdSearchSheets= _Map.getVector3d("VZ_BODY_SEARCH");
	double dBodySearchSheetsLength= _Map.getDouble("BODY_SEARCH_LENGTH");
	double dBodySearchSheetsWidth= _Map.getDouble("BODY_SEARCH_WIDTH");
	double dBodySearchSheetsHeight=_Map.getDouble("BODY_SEARCH_HEIGHT");		
	Point3d ptStretchSheetsAtLeft= _Map.getPoint3d("PT_TO_STRETCH_SHEETS_AT_LEFT_OF_OPENING");
	Point3d ptStretchSheetsAtRight= _Map.getPoint3d("PT_TO_STRETCH_SHEETS_AT_RIGHT_OF_OPENING");

	Point3d ptExtremeLeftInModule= _Map.getPoint3d("PT_EXTREME_LEFT_IN_MODULE");
	Point3d ptExtremeRightInModule= _Map.getPoint3d("PT_EXTREME_RIGHT_IN_MODULE");

	if(bSplitLeftSide)
	{
		Body bdSearchLeft( ptSearchSheetsAtLeft, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
		//ptStretchBottomsAtLeft.vis();
		//ptStretchSheetsAtLeft.vis();
		ptLeftOp.vis();
		ptSearchSheetsAtLeft.vis();
		//ptStretchSheetsAtLeft.vis();
		bdSearchLeft.vis();
		//ptExtremeLeftInModule.vis();
	}
	if(bSplitRightSide)
	{
		Body bdSearchRight( ptSearchSheetsAtRight, vxBdSearchSheets, vyBdSearchSheets, vzBdSearchSheets, dBodySearchSheetsLength, dBodySearchSheetsWidth, dBodySearchSheetsHeight, 1, 0, 0);
		//ptStretchBottomsAtRight.vis();
		//ptStretchSheetsAtRight.vis();
		ptRightOp.vis();
		ptSearchSheetsAtRight.vis();
		//ptStretchSheetsAtRight.vis();
		bdSearchRight.vis();
		//ptExtremeRightInModule.vis();
	}
	ptTopOp.vis();
	ptBottomOp.vis();
	ptCenOp.vis();
}
		
_Pt0= _Element[0].ptOrg();
PLine plOp= _Map.getPLine("PL_OPENING_SHAPE");
Display dp(-1);
dp.draw(plOp);
return;



#End
#BeginThumbnail
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
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#@OBY_P`BI:_]
M?R?^@25J?#G_`)$+3?\`MK_Z->LOXN?\BI:_]?R?^@25J?#G_D0M-_[:_P#H
MUZYE_'?H>[5_Y$T/\?Z,ZFBBBND\(****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@#@OBY_P`BI:_]?R?^@25J?#G_`)$+
M3?\`MK_Z->LOXN?\BI:_]?R?^@25J?#G_D0M-_[:_P#HUZYE_'?H>[5_Y$T/
M\?Z,ZFBBBND\(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@#D_B%H5_K_AV.VTZ-9)XKE9?++A2PVLIP3QGYL\D<`UH>
M#M+N=%\*6%A>!5N(U8NJMD*6=FQGU&<'MGUK<HJ.1<_/U.J6,J/#+#.W*G?S
MN%%%%6<H4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'_
!V444
`




#End
