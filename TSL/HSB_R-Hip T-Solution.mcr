#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
11.09.2013  -  version 1.05





























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl changes the connection between hip and ridge
/// </summary>

/// <insert>
/// Manual: Select a set of elements. The tsl is reinserted for each element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.05" date="11.09.2013"></version>

/// <history>
/// AS - 1.00 - 12.06.2013 -	Pilot version
/// AS - 1.01 - 13.06.2013 -	Apply cuts for angled beams
/// AS - 1.02 - 17.06.2013 -	TSL can be attached to element definition now.
/// AS - 1.03 - 19.06.2013 -	Add support for hip=hip connection
/// AS - 1.04 - 10.09.2013 -	Set sequenceNumber
/// AS - 1.05 - 11.09.2013 -	Correct hip-hip solution for angled hips
/// </history>

// Script uses mm
double dEps = U(.001,"mm");

_ThisInst.setSequenceNumber(500);

// Properties
PropString sSeperator01(0, "", T("|Hip|"));
sSeperator01.setReadOnly(true);
PropString sBmCodeHip(1, "HK-01", "     "+T("|Beamcode hip|"));

PropString sSeperator02(2, "", T("|Ridge|"));
sSeperator02.setReadOnly(true);
PropString sBmCodeRidge(3, "NK-01", "     "+T("|Beamcode ridge|"));

PropString sSeperator03(4, "", T("|T-Solution|"));
sSeperator03.setReadOnly(true);
PropDouble dMinimumLengthShortRafter(0, U(250), "     "+T("|Minimum length short rafter|"));
PropDouble dPreferedLengthShortRafter(1, U(1000), "     "+T("|Length short rafter|"));
PropString sBmCodeShortRafter(5, "HK-R", "     "+T("|Beamcode short rafter|"));
PropString sBmCodeTrim(6, "HK-T", "     "+T("|Beamcode trim|"));

PropString sSeperator04(7, "", T("|Hip-hip Solution|"));
sSeperator04.setReadOnly(true);
PropDouble dExtendRafter(2, U(100), "     "+T("|Extend rafter from hip|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-Hip T-Solution");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;	
	PrEntity ssE(T("|Select one or more elements|"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_R-Hip T-Solution"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		mapTsl.setInt("ManualInsert", true);
		setCatalogFromPropValues("MasterToSatellite");
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsls inserted|"));
	
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

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

// Check if there is a valid element present.
if( _Element.length() == 0 ){
	reportMessage("\n"+scriptName()+T(": |No element selected|!"));
	eraseInstance();
	return;
}

// Get selected element.
Element el = _Element[0];
if (!el.bIsValid()) {
	reportMessage("\n"+scriptName()+T(": |Invalid element found|!"));
	eraseInstance();
	return;
}
_ThisInst.assignToElementGroup(el, true, 0, 'E');

if (bManualInsert || _bOnElementConstructed) {
	// Resolve properties
	double dMinLShortRafter = dMinimumLengthShortRafter;
	if (dMinLShortRafter < U(1))
		dMinLShortRafter = U(1);
	double dPrefLShortRafter = dPreferedLengthShortRafter;
	if (dPrefLShortRafter < U(1))
		dPrefLShortRafter = U(100);
	
	// Coordinate system of this element.
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	_Pt0 = ptEl;
	
	Vector3d vyElProjected = _ZW.crossProduct(vxEl);
	vyElProjected.vis(_Pt0, 3);
	
	Plane pnElBack(el.zone(-1).coordSys().ptOrg(), vzEl);
	
	
	double dBmW = el.dBeamHeight();
	double dBmH = el.dBeamWidth();
	
	// Find the hip and ridge beams
	Beam arBmAll[] = el.beam();
	Beam arBm[0]; // List of beams after the filters are applied.
	Beam arBmHip[0]; // Beams with a hip code.
	Beam arBmRidge[0]; // Beams with a ridge code.
	Beam arBmHor[0]; // may be used as possible trim.
	Beam arBmVert[0];
	Beam arBmAngled[0]; // cut at the short rafter
	Beam arBmExistingTSolutions[0];
	
	for (int i=0;i<arBmAll.length();i++) {
		Beam bm = arBmAll[i];
		
		String sBmCode = bm.beamCode().token(0);
		String sHsbId = bm.hsbId();
		
		if (sHsbId == "70000" || sHsbId == "70001") {
			arBmExistingTSolutions.append(bm);
			continue;
		}
		
		if (sBmCode == sBmCodeHip)
			arBmHip.append(bm);
		if (sBmCode == sBmCodeRidge)
			arBmRidge.append(bm);
		
		if (abs(bm.vecX().dotProduct(vyEl)) < dEps)
			arBmHor.append(bm);
		else if (abs(bm.vecX().dotProduct(vxEl)) < dEps)
			arBmVert.append(bm);
		else
			arBmAngled.append(bm);
		
		arBm.append(bm);
	}
	
	Point3d arPtTSolution[0]; //Possible points for hip t-solution.
	int arNHipSide[0];
	Beam arBmRidgeForThisPoint[0];
	Beam arBmHipForThisPoint[0];
	for (int i=0;i<arBmRidge.length();i++) {
		Beam bmRidge = arBmRidge[i];
		
		Point3d ptRidge = bmRidge.ptCen() + bmRidge.vecD(vyElProjected) * 0.5 * bmRidge.dD(vyElProjected);
		Line lnRidge = Plane(ptRidge, vyElProjected).intersect(pnElBack);
		
		for (int j=0;j<arBmHip.length();j++) {
			Beam bmHip = arBmHip[j];
			
			// vxHip points from overhang to rigde.
			Vector3d vxHip = bmHip.vecX();
			if (vxHip.dotProduct(vyEl) < 0)
				vxHip *= -1;
			Vector3d vyHip = vzEl.crossProduct(vxHip);
			vyHip = bmHip.vecD(vyHip);
			vyHip.normalize();
			
			// Vectors cannot be perpendicular.
			if( abs(lnRidge.vecX().dotProduct(vyHip)) < dEps )
				continue;
			
			// Hip side
			int nHipSide = 1; // left hip
			if (vxHip.dotProduct(vxEl) < 0) {
				nHipSide *= -1;
			}
			
			// Reference point on hip.
			Point3d ptHip = bmHip.ptCen() + bmHip.vecD(vyHip) * nHipSide * 0.5 * bmHip.dD(vyHip);
			bmHip.realBody().vis(3);
			vyHip.vis(ptHip,5);
			
			
			// Find intersection with ridge.
			Plane pnHip(ptHip, vyHip);
			Point3d ptTSolution = lnRidge.intersect(pnHip,0);
			arPtTSolution.append(ptTSolution);
			arNHipSide.append(nHipSide);
			arBmRidgeForThisPoint.append(bmRidge);
			arBmHipForThisPoint.append(bmHip);
			
			ptTSolution.vis(j+1);
		}
	}
	
	for (int i=0;i<arPtTSolution.length();i++) {
		Point3d ptTSolution = arPtTSolution[i];
		int nHipSide = arNHipSide[i];
		Beam bmRidge = arBmRidgeForThisPoint[i];
		Beam bmHip = arBmHipForThisPoint[i];
		
		Point3d ptPossibleTrim = ptTSolution - vyEl * dMinLShortRafter;
		int bPossibleTrimAnalyzed = false;
		Beam bmTrim;
		Beam arBmPossibleTrim[] = Beam().filterBeamsHalfLineIntersectSort(arBmHor, ptTSolution + vzEl * 0.5 * dBmH + vxEl * nHipSide * 0.5 * dBmW, -vyEl);
		if (arBmPossibleTrim.length() > 0) {
			bPossibleTrimAnalyzed = true;
	
			Beam bmPossibleTrim = arBmPossibleTrim[0];
			Vector3d arVPlane[] = {
				bmPossibleTrim.vecY(),
				bmPossibleTrim.vecZ()
			};
			
			for (int j=0;j<arVPlane.length();j++) {
				Vector3d vPlane = arVPlane[j];
				if (abs(vPlane.dotProduct(vyEl)) < dEps)
					continue;
				if (vPlane.dotProduct(vyEl) < 0) 
					vPlane *= -1;
				
				Point3d ptPlane = bmPossibleTrim.ptCen() + vPlane * 0.5 * bmPossibleTrim.dD(vPlane);
				
				Point3d pt = Line(ptTSolution, vyEl).intersect(Plane(ptPlane, vPlane), U(0));
				pt.vis(6);
				if (vyEl.dotProduct(pt - ptPossibleTrim) < 0){
					ptPossibleTrim = pt;
					bmTrim = bmPossibleTrim;
				}
			}
		}
	
		double dToTrim = vyEl.dotProduct(ptTSolution - ptPossibleTrim);
		int bTrimRequired = true;
		if (bPossibleTrimAnalyzed && dToTrim < dPrefLShortRafter)
			bTrimRequired = false;
		
		Body arBdThisTSolution[0];
		Beam bmShortRafter;
		bmShortRafter.dbCreate(ptTSolution, vyEl, -vxEl, vzEl, dMinLShortRafter, dBmW, dBmH, -1, -nHipSide, 1);
		bmShortRafter.setColor(32);
		bmShortRafter.setBeamCode(sBmCodeShortRafter);
		bmShortRafter.assignToElementGroup(el, true, 0, 'Z');
		bmShortRafter.setHsbId("70000");
		
		if (bTrimRequired) {
			Point3d ptTrim = ptTSolution - vyEl * dPrefLShortRafter;
			
			bmTrim = Beam(); 
			bmTrim.dbCreate(ptTrim, vxEl, vyEl, vzEl, dBmW, dBmW, dBmH, 1, -1, 1);
			Beam arBmTrimLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBm, bmTrim.ptCen(), -vxEl);
			if (arBmTrimLeft.length() > 0)
				bmTrim.stretchStaticTo(arBmTrimLeft[0], _kStretchOnInsert);
			Beam arBmTrimRight[] = Beam().filterBeamsHalfLineIntersectSort(arBm, bmTrim.ptCen(), vxEl);
			if (arBmTrimRight.length() > 0)
				bmTrim.stretchStaticTo(arBmTrimRight[0], _kStretchOnInsert);
			bmTrim.setColor(32);
			bmTrim.setBeamCode(sBmCodeTrim);
			bmTrim.setHsbId("70001");
			bmTrim.assignToElementGroup(el, true, 0, 'Z');
			arBdThisTSolution.append(bmTrim.envelopeBody(true, true));
		}
		
		bmShortRafter.stretchStaticTo(bmTrim, _kStretchOnInsert);
		bmShortRafter.stretchStaticTo(bmRidge, _kStretchOnInsert);
		arBdThisTSolution.append(bmShortRafter.envelopeBody(true, true));
		
		Cut cutRidge(ptTSolution, -vxEl * nHipSide);
		bmRidge.addToolStatic(cutRidge, _kStretchOnInsert);
		
		Cut cutHip(ptTSolution, vxEl * nHipSide);
		bmHip.addToolStatic(cutHip, _kStretchOnInsert);
		
		Body bdShortRafter(ptTSolution, vyEl, -vxEl, vzEl, bmShortRafter.solidLength(), dBmW, dBmH, 0, -nHipSide, 1);
		for (int j=0;j<arBmAngled.length();j++) {
			Beam bmAngled = arBmAngled[j];
			if (bdShortRafter.hasIntersection(bmAngled.envelopeBody(true, true))) {
				if ((nHipSide * vxEl).dotProduct(ptTSolution - bmAngled.ptCen()) > 0) {
					bmAngled.addToolStatic(cutHip, _kStretchOnInsert);
				}
				else {
					Cut cutAngled(ptTSolution + vxEl * nHipSide * dBmW, -vxEl * nHipSide);
					bmAngled.addToolStatic(cutAngled, _kStretchOnInsert);
				}			
			}
		}
		
		// Remove existing T-Solutions that overlap with this one.	
		for (int j=0;j<arBmExistingTSolutions.length();j++) {
			Beam bmExisting = arBmExistingTSolutions[j];
			Body bdExisting = bmExisting.envelopeBody(true, true);
			
			for (int k=0;k<arBdThisTSolution.length();k++) {
				Body bd = arBdThisTSolution[k];
				if (bdExisting.hasIntersection(bd)) {
					bmExisting.dbErase();
					break;
				}				
			}
		}
	}
	
	if( arBmRidge.length() == 0 ){
		Point3d arPtTSolution[0]; //Possible points for hip t-solution.
		int arNHipSide[0];
		Beam arBmRidgeForThisPoint[0];
		Beam arBmHipForThisPoint[0];
		for (int i=0;i<arBmHip.length();i++) {
			Beam bmHipA = arBmHip[i];
			
			Vector3d vxHipA = bmHipA.vecX();
			if (vxHipA.dotProduct(vyEl) < 0)
				vxHipA *= -1;
			
			Vector3d vyHipA = vzEl.crossProduct(vxHipA);
				vyHipA.normalize();
			
			// Hip side
			int nHipSideA = 1; // left hip
			if (vxHipA.dotProduct(vxEl) < 0) {
				nHipSideA *= -1;
			}
			
			int bHipHipSet = false;
			for (int j=0;j<arBmHip.length();j++) {
				// Skip this hip beam
				if( i==j )
					continue;
				
				Beam bmHipB = arBmHip[j];
				Vector3d vxHipB = bmHipB.vecX();
				if (vxHipB.dotProduct(vyEl) < 0)
					vxHipB *= -1;
				
				// Hip beams cannot be aligned.
				if( abs(vxHipA.dotProduct(vxHipB) - 1) < dEps )
					continue;
				
				Vector3d vyHipB = vzEl.crossProduct(vxHipB);
				vyHipB.normalize();
				
				// Hip side
				int nHipSideB = 1; // left hip
				if (vxHipB.dotProduct(vxEl) < 0) {
					nHipSideB *= -1;
				}
				
				// Reference point on hip.
				Point3d ptHipA = bmHipA.ptCen() + bmHipA.vecD(vyHipA) * nHipSideA * 0.5 * bmHipA.dD(vyHipA);
				Point3d ptHipB = bmHipB.ptCen() + bmHipB.vecD(vyHipB) * nHipSideB * 0.5 * bmHipB.dD(vyHipB);
	
				// Find intersection with ridge.
				Line lnHipA(ptHipA, vxHipA);
				Plane pnHipB(ptHipB, vyHipB);
				Point3d ptHipHip = lnHipA.intersect(pnHipB,0);
				
				// Find vertical beam closest to this point.
				Beam bmVertical;
				double dClosest = U(999999);
				for (int k=0;k<arBmVert.length();k++) {
					Beam bmThis = arBmVert[k];
					
					double dToThis = vxEl.dotProduct(bmThis.ptCen() - ptHipHip);
					if (abs(dToThis) < dClosest) {
						dClosest = dToThis;
						bmVertical = bmThis;
					}
				}
				ptHipHip.vis(j+1);
				
				
				if( dClosest < U(10) ){
					// Extend the vertical beam.
					bmVertical.envelopeBody().vis();
					
					Cut cut(ptHipHip + vyEl * dExtendRafter, vyElProjected);
					bmVertical.addToolStatic(cut, _kStretchOnInsert);
					
					
					
					Body bdVertical = bmVertical.envelopeBody(true, true);
					bdVertical.transformBy(vyEl * 0.5 * bmVertical.solidLength());
					for (int j=0;j<arBmAngled.length();j++) {
						Beam bmAngled = arBmAngled[j];
						if (bdVertical.hasIntersection(bmAngled.envelopeBody(true, true))) {
							if (vxEl.dotProduct(ptHipHip - bmAngled.ptCen()) > 0) {
								Cut cutLeft(ptHipHip - vxEl * 0.5 * bmVertical.dD(vxEl), vxEl);
								bmAngled.addToolStatic(cutLeft, _kStretchOnInsert);
							}
							else {
								Cut cutRight(ptHipHip + vxEl * 0.5 * bmVertical.dD(vxEl), -vxEl);
								bmAngled.addToolStatic(cutRight, _kStretchOnInsert);
							}			
						}
					}				
				}
				else{
					// Create a short rafter with a trimmer.
					
				}
				
				bHipHipSet = true;
				break;
			}
			
			if (bHipHipSet)
				break;
		}
	}
	
	eraseInstance();
}



#End
#BeginThumbnail



#End
