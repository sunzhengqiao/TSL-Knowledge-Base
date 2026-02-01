#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
29.01.2013  -  version 1.0

















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a service hatch to wall elements. Default locations are next to opening and at wall connections
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="29.01.2013"></version>

/// <history>
/// AS - 1.00 - 29.01.2013	- Pilot version
/// </history>

double dEps = Unit (0.01,"mm");

PropDouble dMinimumRequiredGap(0, U(200), "     "+T("|Minimum Required Gap|"));

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
	
	PrEntity ssE(TN("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = "HSB_W-ServiceHatch"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", TRUE);
	setCatalogFromPropValues("MasterToSatellite");
	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
	
		lstElements[0] = el;
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

ElementWallSF el = (ElementWallSF)_Element[0];
assignToElementGroup(el, true, 0, 'E');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

_Pt0 = ptEl;

Plane pnElY(ptEl, vyEl);
Plane pnElZ(ptEl, vzEl);

Line lnElX(ptEl - vzEl * 0.5 * el.zone(0).dH(), vxEl);

// Get the openings of this element
Opening arOp[] = el.opening();
// Get the connected elements.
Element arElConnected[] = el.getConnectedElements();

// Stop executing this tsl if there are no connected elements and no openings
if( arOp.length() == 0 && arElConnected.length() == 0 ){
	reportMessage(TN("|No service hatch locations available for wall| ") + el.code() + el.number());
	eraseInstance();
	return;
}

Point3d arPtServiceHatch[0];
Vector3d arVxServiceHatch[0];

// Check if there are valid connections? A connection is valid if this wall is the male wall in the intersection.
// This means that two of the vertex points of this wall has to be on the connecting wall.
PLine plEl = el.plOutlineWall();
Point3d arPtEl[] = plEl.vertexPoints(true);
for( int i=0;i<arElConnected.length();i++ ){
	Element elConnected = arElConnected[i];
	PLine plElConnected = elConnected.plOutlineWall();
	
	int nNrOfPointsOnThisConnectingWall = 0;
	Point3d arPtOnThisConnectionWall[0];
	for( int j=0;j<arPtEl.length();j++ ){
		Point3d pt = arPtEl[j];
		if( plElConnected.isOn(pt) ){
			nNrOfPointsOnThisConnectingWall++;
			arPtOnThisConnectionWall.append(pt);
		}
	}
	
	if( nNrOfPointsOnThisConnectingWall == 2 ){
		Point3d ptWallConnection = (arPtOnThisConnectionWall[0] + arPtOnThisConnectionWall[1])/2;
		Vector3d vxConnection = vxEl;
		if( vxEl.dotProduct(ptWallConnection - ptEl) > U(100) )
			vxConnection *= -1;
		arPtServiceHatch.append(ptWallConnection);
		arVxServiceHatch.append(vxConnection);
	}
}

Beam arBm[] = el.beam();
Sheet arShServiceHatch[] = el.sheet(1);

PlaneProfile ppFrame(csEl);
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	ppFrame.unionWith(bm.envelopeBody().extractContactFaceInPlane(pnElZ, U(1)));
}

// Add opening positions
for( int i=0;i<arOp.length();i++ ){
	Opening op = arOp[i];
	Point3d ptOp = Body(op.plShape(), vzEl).ptCen();
	
	Point3d ptOpLeft = ptOp - vxEl * 0.5 * op.width();
	Point3d ptOpRight = ptOp + vxEl * 0.5 * op.width();
	
	ptOpLeft = lnElX.closestPointTo(ptOpLeft);
	ptOpRight = lnElX.closestPointTo(ptOpRight);
	
	arPtServiceHatch.append(ptOpLeft);
	arVxServiceHatch.append(-vxEl);
	arPtServiceHatch.append(ptOpRight);
	arVxServiceHatch.append(vxEl);
}

//Locations for possible servicehatches
for( int i=0;i<arPtServiceHatch.length();i++ ){
	Point3d ptServiceHatch = arPtServiceHatch[i];
	Vector3d vxServiceHatch = arVxServiceHatch[i];
	
	
	Point3d ptSheetFinder = ptServiceHatch + (vxServiceHatch + vyEl) * U(15);
	ptSheetFinder.vis(1);
	int bEdgeFound = false;
	Sheet shServiceHatch;
	for( int j=0;j<arShServiceHatch.length();j++ ){
		Sheet sh = arShServiceHatch[j];
		PlaneProfile ppSh = sh.profShape();
		
		if( ppSh.pointInProfile(ptSheetFinder) != _kPointInProfile )
			continue;
		
		sh.setColor(6);
		
		// Find the vertical edge of this sheet that can be used as a reference point.
		Point3d arPtEdge[] = ppSh.getGripEdgeMidPoints();
		for( int k=0;k<arPtEdge.length();k++ ){
			Point3d ptEdge = arPtEdge[k];
			ptEdge += vxServiceHatch;
			if( ppSh.pointInProfile(ptEdge) != _kPointInProfile )
				continue;
			
			bEdgeFound = true;
			ptServiceHatch = ptEdge;
			break;
		}
		
		shServiceHatch = sh;
		break;
	}
	
	// No edge found. Should we notify the user?
	if( !bEdgeFound )
		continue;
	
	if( vxEl.dotProduct(vxServiceHatch) > 0 )
		ptServiceHatch.vis(5);
	else
		ptServiceHatch.vis(6);
	
	Line lnServiceHatchX(ptServiceHatch, vxServiceHatch);
	
	// Create a rectangular planeprofile with a small height and the length of the sheet which is found. 
	PlaneProfile ppServiceHatch(csEl);
	PLine plServiceHatch(vzEl);
	plServiceHatch.createRectangle(LineSeg(ptServiceHatch - vyEl * U(5), ptServiceHatch + vxServiceHatch * shServiceHatch.dD(vxServiceHatch) + vyEl * U(5)), vxServiceHatch, vyEl);
	ppServiceHatch.joinRing(plServiceHatch, _kAdd);
	// Subtract the frame profile from the rectangle. The result should be a ring per opening between beams.
	int bValidSubtraction = ppServiceHatch.subtractProfile(ppFrame);
	ppServiceHatch.vis(6);
	
	Point3d arPtValidServiceHatchBeamStart[0];
	Point3d arPtValidServiceHatchBeamEnd[0];
	PLine arPlServiceHatch[] = ppServiceHatch.allRings();	
	for( int j=0;j<arPlServiceHatch.length();j++ ){
		PLine pl = arPlServiceHatch[j];
		Point3d arPtPl[] = pl.vertexPoints(true);
		arPtPl = lnServiceHatchX.orderPoints(arPtPl);
		if( arPtPl.length() < 3 )
			continue;
		double dOpeningLength = vxServiceHatch.dotProduct(arPtPl[arPtPl.length() - 1] - arPtPl[0]);
		if( dOpeningLength >= dMinimumRequiredGap ){
			arPtValidServiceHatchBeamStart.append(arPtPl[0]);	
			arPtValidServiceHatchBeamEnd.append(arPtPl[arPtPl.length() - 1]);	
		}			
	}
	arPtValidServiceHatchBeamStart = lnServiceHatchX.orderPoints(arPtValidServiceHatchBeamStart);
	arPtValidServiceHatchBeamEnd = lnServiceHatchX.orderPoints(arPtValidServiceHatchBeamEnd);
	if( arPtValidServiceHatchBeamEnd.length() < 1 || arPtValidServiceHatchBeamStart.length() < 1 )
		continue;
	if( arPtValidServiceHatchBeamEnd.length() != arPtValidServiceHatchBeamStart.length() )
		continue;
	
	Point3d ptServiceHatchBeamStart = arPtValidServiceHatchBeamStart[0];
	ptServiceHatchBeamStart = lnServiceHatchX.closestPointTo(ptServiceHatchBeamStart);
	ptServiceHatchBeamStart.vis(4);
	
	Point3d ptServiceHatchBeamEnd = arPtValidServiceHatchBeamEnd[0];
	ptServiceHatchBeamEnd = lnServiceHatchX.closestPointTo(ptServiceHatchBeamEnd);
	ptServiceHatchBeamEnd.vis(3);
	
	
}









#End
#BeginThumbnail

#End
