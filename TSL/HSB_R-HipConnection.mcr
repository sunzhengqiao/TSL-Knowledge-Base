#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
14.02.2014  -  version 1.00

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
/// Create a hip connection. The hip of the lower elements is extended over the upper elements.
/// </summary>

/// <insert>
/// Select a set of elements.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="14.02.2014"></version>

/// <history>
/// AS - 1.00 - 14.02.2014 -  Pilot version.
/// </hsitory>


double dEps = Unit(0.01, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Hip connection|"));
sSeperator01.setReadOnly(true);
PropString sBmCodeHK(1, "HK-01", "     "+T("|Beamcode hip|"));
PropDouble dOvershootLength(0, U(200), "     "+T("|Overshoot length|"));

PropString sSeperator02(2, "", T("|Ridge connection|"));
sSeperator02.setReadOnly(true);
PropString sSquareOff(3, arSYesNo, "     "+T("|Square off at ridge|"));
PropDouble dOffsetCutTop(1, U(20), "     "+T("|Offset cut at ridge|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-HipConnection");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


if( _bOnInsert ){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	// show the dialog if no catalog in use
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 ){
		if( _kExecuteKey != "" )
			reportMessage("\n"+scriptName() + TN("|Catalog key| ") + _kExecuteKey + T(" |not found|!"));
		showDialog();
	}
	else{
		setPropValuesFromCatalog(_kExecuteKey);
	}
		
	PrEntity ssElRf(T("|Select a set of elements|"), ElementRoof());
	if( ssElRf.go() )
		_Element.append(ssElRf.elementSet());
	
	return;
}

if( _Element.length() < 1 ){
	reportWarning(TN("|There is at least one elements required|!"));
	eraseInstance();
	return;
}

int bSquareOffAtRidge = arNYesNo[arSYesNo.find(sSquareOff)];

String arSBmCodeHK[] = {
	sBmCodeHK
};

_Pt0 = _Element[0].ptOrg();

Beam arBmHip[0];
int arBmIsProcessed[0];
Point3d arPtElementMin[0];
Point3d arPtElementMax[0];

for( int e=0;e<_Element.length();e++ ){
	Element el = _Element[e];
	
	//beams from this element
	Beam arBm[] = el.beam();
		
	//Loop over all beams in this element.
	//Store the extremes of the element.
	Point3d arPtElement[0];
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
			
		String sBmCode = bm.beamCode().token(0).makeUpper();
		String sBmName = bm.name().makeUpper();
		
		if( arSBmCodeHK.find(sBmCode) != -1 ){
			arBmHip.append(bm);
			arBmIsProcessed.append(false);
		}
		else{
			arPtElement.append(bm.envelopeBody(true, true).allVertices());
		}
	}
	
	Point3d arPtElementX[] = Line(el.ptOrg(), el.vecX()).orderPoints(arPtElement);
	Point3d arPtElementY[] = Line(el.ptOrg(), el.vecY()).orderPoints(arPtElement);

	if( (arPtElementX.length() * arPtElementY.length()) <= 0 ){
		reportMessage("\n"+scriptName()+TN("|Extremes of element not found|!"));
		eraseInstance();
		return;
	}
	
	Point3d ptBL = arPtElementX[0] + el.vecY() * el.vecY().dotProduct(arPtElementY[0] - arPtElementX[0]);
	Point3d ptTR = arPtElementX[arPtElementX.length() - 1] + el.vecY() * el.vecY().dotProduct(arPtElementY[arPtElementY.length() - 1] - arPtElementX[arPtElementX.length() - 1]);
	arPtElementMin.append(ptBL);
	arPtElementMax.append(ptTR);
}

for( int i=0;i<arBmHip.length();i++ ){
	if( arBmIsProcessed[i] )
		continue;
	
	Beam bmMain = arBmHip[i];
	Point3d ptMain = bmMain.ptCen();
	Vector3d vxMain = bmMain.vecX(); // vxMain points towards the ridge.
	if( _ZW.dotProduct(vxMain) < 0 )
		vxMain *= -1;
	Vector3d vyMain = bmMain.vecY();
	Vector3d vzMain = vxMain.crossProduct(vyMain);
	
	Point3d arPtBm[] = bmMain.envelopeBody(true, true).allVertices();
	Vector3d vSort = bmMain.element().vecX();
	if( vxMain.dotProduct(vSort) < 0 )
		vSort *= -1;
	Point3d arPtBmX[] = Line(ptMain, vSort).orderPoints(arPtBm);
	Point3d arPtBmMax[0];
	for( int j=arPtBmX.length() - 1;j>0;j-- ){
		Point3d pt = arPtBmX[j];
		if( arPtBmMax.length() == 0 )
			arPtBmMax.append(pt);
		
		if( abs(vSort.dotProduct(pt - arPtBmMax[arPtBmMax.length() - 1])) > dEps )
			break;
			
		arPtBmMax.append(pt);
	}
	arPtBmMax = Line(ptMain, bmMain.element().vecY()).orderPoints(arPtBmMax);
	if( arPtBmMax.length() == 0 ){
		reportMessage("\n"+scriptName()+TN("|Reference point not found|!"));
		eraseInstance();
		return;
	}
	Point3d ptBmRef = arPtBmMax[0];
	
	Point3d arPtHipReference[] = {
		ptBmRef
	};
	Beam arBmThisHip[] = {
		bmMain
	};
	
	for( int j=0;j<arBmHip.length();j++ ){
		if( i==j )
			continue;
		if( arBmIsProcessed[j] )
			continue;
		
		Beam bmSub = arBmHip[j];
		Point3d ptSub = bmSub.ptCen();
		Vector3d vxSub = bmSub.vecX();
		Vector3d vySub = bmSub.vecY();
		Vector3d vzSub = bmSub.vecZ();
		
		// Sub-beam must be aligned with main-beam.
		// X-axis aligned?
		if( abs(abs(vxMain.dotProduct(vxSub)) - 1) > dEps )
			continue;
		// Not rotated?
		if( abs(abs(vyMain.dotProduct(vySub)) - 1) > dEps )
			continue;
		// Do they line up...
		if( abs(vyMain.dotProduct(ptMain - ptSub)) > dEps )
			continue;
		// ... in both directions?
		if( abs(vzMain.dotProduct(ptMain - ptSub)) > dEps )
			continue;
		
		Point3d arPtBm[] = bmSub.envelopeBody(true, true).allVertices();
		Vector3d vSort = bmSub.element().vecX();
		if( vxMain.dotProduct(vSort) < 0 )
			vSort *= -1;
		Point3d arPtBmX[] = Line(ptSub, vSort).orderPoints(arPtBm);
		Point3d arPtBmMax[0];
		for( int j=arPtBmX.length() - 1;j>0;j-- ){
			Point3d pt = arPtBmX[j];
			if( arPtBmMax.length() == 0 )
				arPtBmMax.append(pt);
			
			if( abs(vSort.dotProduct(pt - arPtBmMax[arPtBmMax.length() - 1])) > dEps )
				break;
				
			arPtBmMax.append(pt);
		}
		arPtBmMax = Line(ptMain, bmSub.element().vecY()).orderPoints(arPtBmMax);
		if( arPtBmMax.length() == 0 ){
			reportMessage("\n"+scriptName()+TN("|Reference point not found|!"));
			eraseInstance();
			return;
		}
		Point3d ptBmRef = arPtBmMax[0];

		
		arBmThisHip.append(bmSub);
		arPtHipReference.append(ptBmRef);
	}
	
//	// Ignore single beam hips.
//	if( arBmThisHip.length() < 2 )
//		continue;
	
	//Order beams in the main x direction.
	for(int s1=1;s1<arBmThisHip.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( vxMain.dotProduct(arPtHipReference[s11] - arPtHipReference[s2]) < 0 ){
				arPtHipReference.swap(s2, s11);
				arBmThisHip.swap(s2, s11);
				
				s11=s2;
			}
		}
	}
	
	// Start joining and cutting beams.
	for( int j=0;j<arBmThisHip.length();j++ ){
		Beam bmA = arBmThisHip[j];
		bmA.envelopeBody().vis(j+1);
		// Element and element extremes
		Element elBmA = bmA.element();
		int nElBmAIndex = _Element.find(elBmA);
		if( nElBmAIndex == -1 ){
			reportWarning(TN("|Element not found in list of selected elements|!"));
			continue;
		}
		Point3d ptElBmAMin = arPtElementMin[nElBmAIndex];
		Point3d ptElBmAMax = arPtElementMax[nElBmAIndex];
		Point3d ptBmARef = arPtHipReference[j];
		
		// Beam index
		int nBmAIndex = arBmHip.find(bmA);
		if( nBmAIndex == -1 ){
			reportWarning(TN("|Beam not found in list of beams to join|!"));
			continue;
		}
		
		for( int k=1;k<arBmThisHip.length();k++ ){
			Beam bmB = arBmThisHip[k];
			// Element and element extremes
			Element elBmB = bmB.element();
			int nElBmBIndex = _Element.find(elBmB);
			if( nElBmBIndex == -1 ){
				reportWarning(TN("|Element not found in list of selected elements|!"));
				continue;
			}
			Point3d ptElBmBMin = arPtElementMin[nElBmBIndex];
			Point3d ptElBmBMax = arPtElementMax[nElBmBIndex];
			Point3d ptBmBRef = arPtHipReference[k];

			// Beam index
			int nBmBIndex = arBmHip.find(bmB);
			if( nBmBIndex == -1 ){
				reportWarning(TN("|Beam not found in list of beams to join|!"));
				continue;
			}
			
			// Apply cuts
			// Split beam at element edge. Offset split location with specified value
			Point3d ptElementEdgeA = ptElBmAMax;
			Point3d ptElementEdgeB = ptElBmBMin;
			if( elBmA.vecX().dotProduct(vxMain) < 0 ){ // Right-hand side hip.
				ptElementEdgeA = ptElBmAMin;
				ptElementEdgeB = ptElBmBMax;
			}
			ptElementEdgeA.vis();
			ptElementEdgeB.vis();
			Point3d ptTo = Line(ptBmARef, vxMain).intersect(Plane(ptElementEdgeA, elBmA.vecX()), U(0)) + vxMain * dOvershootLength;
			Point3d ptFrom = Line(ptBmARef, vxMain).intersect(Plane(ptElementEdgeB, elBmB.vecX()), U(0)) + vxMain * dOvershootLength;
//			Point3d ptTo = ptBmARef + vxMain * dOvershootLength;
//			Point3d ptFrom = ptBmBRef + vxMain * dOvershootLength;
			ptFrom.vis();
			ptTo.vis();
			
			Vector3d vxTo = vxMain;//elBmA.vecX();
			if( vxTo.dotProduct(vxMain) < 0 )
				vxTo *= -1;
			Cut cutTo(ptTo, vxTo);
			bmA.addToolStatic(cutTo, _kStretchOnInsert);
			
			Vector3d vxFrom = -vxTo;
			Cut cutFrom(ptFrom, vxFrom);
			bmB.addToolStatic(cutFrom, _kStretchOnInsert);
			
			// Mark beams as joined.
			if( k==1 )
				arBmIsProcessed[nBmAIndex] = true;
			arBmIsProcessed[nBmBIndex] = true;
			
			// Make the beam closest to the ridge the new 'bm'.
			bmA = bmB;
			// Move to the next element edges.
			ptElBmAMin = ptElBmBMin;
			ptElBmAMax = ptElBmBMax;
		}
		
		// Make last hip perpendicular
		if( bSquareOffAtRidge ){
			Beam bmTopHip = arBmThisHip[arBmThisHip.length() - 1];
			Point3d ptHipReference = arPtHipReference[arBmThisHip.length() - 1];
			Cut cutTop(ptHipReference - vxMain * dOffsetCutTop, vxMain);
			bmTopHip.addToolStatic(cutTop, _kStretchOnInsert);
		}
		
		// Move to next hip.
		break;
	}
}

// Job's done.
eraseInstance();
#End
#BeginThumbnail

#End
