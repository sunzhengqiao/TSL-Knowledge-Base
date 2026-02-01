#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
23.11.2020 - version 2.18


















#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 2
#MinorVersion 18
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl integrates the beams in the connecting beams.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.18" date="23.11.2020"></version>

/// <history>
/// AS - 1.00 - 22.04.2013 -	Pilot version.
/// AS - 1.01 - 23.04.2013 -	Buxfix on Z offset and size.
/// AS - 1.02 - 23.04.2013 -	Add gaplength again.
/// AS - 1.03 - 02.05.2013 -	Add extra cut if the integration causes the beam to go over the top face of the female beam.
/// AS - 1.04 - 02.05.2013 -	Check for interference of other beams.
/// AS - 1.05 - 02.05.2013 -	Use clean width and height for interference check.
/// AS - 1.06 - 06.05.2013 -	Add filters for female beam.
/// AS - 1.07 - 13.05.2013 -	Change intersection check.
/// AS - 2.00 - 16.05.2013 -	Persist data.
/// AS - 2.01 - 29.05.2013 -	Store state in dwg, do not recalc on dwgin.
/// AS - 2.02 - 27.09.2013 -	Extend mill if its at the end of a beam.
/// AS - 2.03 - 04.10.2013 -	Change defaults
/// AS - 2.04 - 04.10.2013 -	Change tolerance for T-Connection cut. Recalc is now working again. (dDepth + dEps)
/// AS - 2.05 - 30.01.2014 -	Allow cutting planes with 4 or more vertices.
/// AS - 2.06 - 30.01.2014 -	Create convex hull for cuts with more than 4 points. Check on 4 points after that.
/// AS - 2.07 - 10.06.2014 -	Optimize convex hull before checking the number of points. Set default cut position to _Pt0 + depth.
/// AS - 2.08 - 12.06.2014 -	Add option to insert marking.
/// AS - 2.09 - 10.07.2014 -	Set the cutting point to the beamcut position
/// AS - 2.10 - 14.07.2015 -	Cuts to preserve cannot be on other side of beam and also not be perpendicular
/// AS - 2.11 - 08.09.2015 -	Update thumbnail
/// AS - 2.12 - 15.09.2015 -	Do not preserve cuts in the _Z1 direction. Properties can be set through execute key. (FogBugzId 1894)
/// AS - 2.13 - 03.11.2015 -	Correct position cut for angled connections.
/// AS - 2.14 - 17.06.2016 -	Add context command to restore the connection.
/// AS - 2.15 - 12.07.2016 -	Add option to increase the width for adjacent connections.
/// RP - 2.16 - 01.02.2018 -	Add option to set the side of the marking
/// RP - 2.17 - 27.05.2019 -	Extra check for normal of face marking
/// RP - 2.18 - 23.11.2020 -	Set the posnum directly because otherwise there will be a depenency problem.
/// </history>

double dEps(Unit(0.01,"mm"));


/// - Triggers -
///
String arSTrigger[] = {
	T("|Restore connection|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


int nExecuteMode = 0; //0 = Default; 1 = Delete
if( _kExecuteKey == arSTrigger[0] )
	nExecuteMode = 1;

if( _Map.hasInt("ExecuteMode") ){
	nExecuteMode = _Map.getInt("ExecuteMode");
	_Map.removeAt("ExecuteMode", true);
}

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

setMarbleDiameter(U(1));

PropString sSeparator01(0, "", T("|Filter female beams|"));
sSeparator01.setReadOnly(true);
PropString sFemaleFilterBC(1,"","     "+T("|Filter female beams with beamcode|"));
PropString sFemaleFilterLabel(2,"","     "+T("|Filter female beams with label|"));
PropString sFemaleFilterMaterial(3,"","     "+T("|Filter female beams with material|"));
PropString sFemaleFilterHsbID(4,"","     "+T("|Filter female beams with hsbID|"));


PropString sSeparator02(5, "", T("|Tool|"));
sSeparator02.setReadOnly(true);
PropDouble dDepth(0,U(3),"     "+T("Depth"));
PropDouble dMinimumMillWidth(1, U(25), "     "+T("|Minimum mill width|"));
PropDouble dGapW(2,U(1), "     "+T("|Gap width|"));
dGapW.setDescription(T("|Extra milling width|"));
PropDouble dGapL(3, U(200), "     "+T("|Gap length|"));
dGapL.setDescription(T("|Extra milling length|"));
PropDouble extraWidthForAdjacentConnections(4, U(0), "     "+T("|Extra width for adjacent connections|"));

PropString sSeparator03(6, "", T("|Marking|"));
sSeparator03.setReadOnly(true);
PropString sApplyMarking(7, arSYesNo, "     "+T("|Apply marking|"));
String arSInsideOutside[] = {T("|Inside|"), T("|Outside|") };
PropString sMarkingSide(9, arSInsideOutside, "     "+T("|Marking side|"));
PropString sSeparator04(8, "", T("|Visualisation|"));
sSeparator04.setReadOnly(true);
PropInt symbolColor(0, 3, "     " + T("|Symbol color|"));
PropInt symbolColorAdjacentConnections(1, 72, "     " + T("|Symbol color adjacent connections|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_T-IntegrateTimber");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

double dMinimumRequiredVolume = U(100);

String sFemaleFBC = sFemaleFilterBC + ";";
sFemaleFBC.makeUpper();
String arSFemaleExcludeBC[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFemaleFBC.length()-1){
	String sTokenBC = sFemaleFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFemaleFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSFemaleExcludeBC.append(sTokenBC);
}
String sFemaleFLabel = sFemaleFilterLabel + ";";
sFemaleFLabel.makeUpper();
String arSFemaleExcludeLbl[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFemaleFLabel.length()-1){
	String sTokenLabel = sFemaleFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFemaleFLabel.find(sTokenLabel,0);

	arSFemaleExcludeLbl.append(sTokenLabel);
}
String sFemaleFMaterial = sFemaleFilterMaterial + ";";
sFemaleFMaterial.makeUpper();
String arSFemaleExcludeMat[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFemaleFMaterial.length()-1){
	String sTokenMaterial = sFemaleFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFemaleFMaterial.find(sTokenMaterial,0);

	arSFemaleExcludeMat.append(sTokenMaterial);
}

String sFemaleFHsbId = sFemaleFilterHsbID + ";";
sFemaleFHsbId.makeUpper();
String arSFemaleExcludeHsbId[0];
int nIndexHsbId = 0; 
int sIndexHsbId = 0;
while(sIndexHsbId < sFemaleFHsbId.length()-1){
	String sTokenHsbId = sFemaleFHsbId.token(nIndexHsbId);
	nIndexHsbId++;
	if(sTokenHsbId.length()==0){
		sIndexHsbId++;
		continue;
	}
	sIndexHsbId = sFemaleFHsbId.find(sTokenHsbId,0);

	arSFemaleExcludeHsbId.append(sTokenHsbId);
}

int bApplyMarking = arNYesNo[arSYesNo.find(sApplyMarking,0)];

Element el = _Beam0.element();
Beam arBm[0];
if( el.bIsValid() ){
	assignToElementGroup(el, true, 0, 'T');
	arBm.append(el.beam());
}
else{
	Entity arEnt[] = Group().collectEntities(true, Beam(), _kModelSpace);
	for( int i=0;i<arEnt.length();i++ ){
		Entity ent = arEnt[i];
		Beam bm = (Beam)ent;
		if( bm.bIsValid() )
			arBm.append(bm);
	}
}
Beam arBmFemale[0];
for(int i=0;i<arBm.length();i++){
	Beam bm = arBm[i];
	
	int bExcludeBeam = false;

	//Exclude dummies
	if( bm.bIsDummy() )
		continue;
	
	//Exclude labels
	String sLabel = bm.label().makeUpper();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( arSFemaleExcludeLbl.find(sLabel)!= -1 ){
		bExcludeBeam = true;
	}
	else{
		for( int j=0;j<arSFemaleExcludeLbl.length();j++ ){
			String sExclLbl = arSFemaleExcludeLbl[j];
			String sExclLblTrimmed = sExclLbl;
			sExclLblTrimmed.trimLeft("*");
			sExclLblTrimmed.trimRight("*");
			if( sExclLblTrimmed == "" )
				continue;
			if( sExclLbl.left(1) == "*" && sExclLbl.right(1) == "*" && sLabel.find(sExclLblTrimmed, 0) != -1 )
				bExcludeBeam = true;
			else if( sExclLbl.left(1) == "*" && sLabel.right(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeBeam = true;
			else if( sExclLbl.right(1) == "*" && sLabel.left(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeBeam = true;
		}
	}
	if( bExcludeBeam )
		continue;
	
	//Exclude material
	String sMaterial = bm.material().makeUpper();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( arSFemaleExcludeMat.find(sMaterial)!= -1 ){
		bExcludeBeam = true;
	}
	else{
		for( int j=0;j<arSFemaleExcludeMat.length();j++ ){
			String sExclMat = arSFemaleExcludeMat[j];
			String sExclMatTrimmed = sExclMat;
			sExclMatTrimmed.trimLeft("*");
			sExclMatTrimmed.trimRight("*");
			if( sExclMatTrimmed == "" )
				continue;
			if( sExclMat.left(1) == "*" && sExclMat.right(1) == "*" && sMaterial.find(sExclMatTrimmed, 0) != -1 )
				bExcludeBeam = true;
			else if( sExclMat.left(1) == "*" && sMaterial.right(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeBeam = true;
			else if( sExclMat.right(1) == "*" && sMaterial.left(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeBeam = true;
		}
	}
	if( bExcludeBeam )
		continue;

	//Exclude hsbId
	String sHsbId = bm.hsbId().makeUpper();
	sHsbId.trimLeft();
	sHsbId.trimRight();
	if( arSFemaleExcludeHsbId.find(sHsbId)!= -1 ){
		bExcludeBeam = true;
	}
	else{
		for( int j=0;j<arSFemaleExcludeHsbId.length();j++ ){
			String sExclHsbId = arSFemaleExcludeHsbId[j];
			String sExclHsbIdTrimmed = sExclHsbId;
			sExclHsbIdTrimmed.trimLeft("*");
			sExclHsbIdTrimmed.trimRight("*");
			if( sExclHsbIdTrimmed == "" )
				continue;
			if( sExclHsbId.left(1) == "*" && sExclHsbId.right(1) == "*" && sHsbId.find(sExclHsbIdTrimmed, 0) != -1 )
				bExcludeBeam = true;
			else if( sExclHsbId.left(1) == "*" && sHsbId.right(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeBeam = true;
			else if( sExclHsbId.right(1) == "*" && sHsbId.left(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeBeam = true;
		}
	}
	if( bExcludeBeam )
		continue;

	
	//Exclude beamcodes
	String sBmCode = bm.beamCode().token(0).makeUpper();
	sBmCode.trimLeft();
	sBmCode.trimRight();
	
	if( arSFemaleExcludeBC.find(sBmCode)!= -1 ){
		bExcludeBeam = true;
	}
	else{
		for( int j=0;j<arSFemaleExcludeBC.length();j++ ){
			String sExclBC = arSFemaleExcludeBC[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" )
				continue;
			if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
				bExcludeBeam = true;
			else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeBeam = true;
			else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeBeam = true;
		}
	}
	if( bExcludeBeam )
		continue;
			
	arBmFemale.append(bm);
}

_X0.vis(_Pt0,1);

double dGapWidth = 2 * dGapW;
double dGapLength = 2 * dGapL;

//Vector3d vX1 = _X1;
//Vector3d vY1 = _Y1;
//Vector3d vZ1 = _Z1;

if( _X0.isPerpendicularTo(_Z1) ){
	reportMessage(TN("|Invalid T Connection found|!"));
	eraseInstance();
	return;
}

int bRunScriptTwice = false;
Cut arCutOriginal[0];
for( int j=0;j<_Map.length();j++ ){
	if( !(_Map.hasMap(j) && _Map.keyAt(j) == "OriginalCut") )
		continue;
	
	Map mapCut = _Map.getMap(j);
	
	Point3d ptCut = mapCut.getPoint3d("PtCut");
	Vector3d vCut = mapCut.getVector3d("Normal");
	Cut cutOriginal(ptCut, vCut);
	arCutOriginal.append(cutOriginal);
}

for( int i=0;i<arCutOriginal.length();i++ ){
	Cut cut = arCutOriginal[i];
	int nStretchType = _kStretchOnInsert;
	if( i>0 )
		nStretchType = _kStretchNot;
	
	_Beam0.addTool(cut, nStretchType);
	
//	reportNotice("\nReset cuts");
	bRunScriptTwice = true;
}
_Map = Map();

if( nExecuteMode == 1 ){// Delete
	_Beam0.stretchStaticTo(_Beam1, _kStretchOnInsert);

	eraseInstance();
	return;
}

if( bRunScriptTwice ){
	setExecutionLoops(2);
	return;
}

Point3d ptCut;
if (abs(_X0.dotProduct(_Z1)) < U(0.01)) {
	ptCut = _Pt0 + _Z1 * dDepth;
}
else {
	ptCut = Line(_Pt0, _X0).intersect(Plane(_Pt0, _Z1), dDepth);
}

ptCut.vis();

Point3d arPt0[] = {_Pt0};
Point3d arPt1[] = {_Pt1};
Point3d arPt2[] = {_Pt2};
Point3d arPt3[] = {_Pt3};
Point3d arPt4[] = {_Pt4};
Vector3d arVZ1[] = {_Z1};
Beam arBeam1[] = {_Beam1};
Point3d arPtCut[] = {ptCut};

//Check if there are cuts which have to be preserved.
AnalysedTool arTool[] = _Beam0.analysedTools();
AnalysedCut arCut[] = AnalysedCut().filterToolsOfToolType(arTool);

for( int i=0;i<arCut.length();i++ ){
	AnalysedCut aCut = arCut[i];
	Point3d ptCutOrg = aCut.ptOrg();
	Vector3d vCutNormal = aCut.normal();
	vCutNormal.vis(ptCutOrg, 3);

	// Cut must be on this side. So it cannot be negative (other side) or zero (perpendicular)
	if( vCutNormal.dotProduct(_X0) < U(0.01) )
		continue;
	// Ignore cuts in the same direction as the integration cut
	if (abs(vCutNormal.dotProduct(_Z1) - 1) < U(0.01))
		continue;
		
	// Find the center of the cut.
	Point3d arPtInCuttingPlane[] = aCut.bodyPointsInPlane();
	// Only accept cutting planes with 4 vertices.
	if( arPtInCuttingPlane.length() < 4 )
		continue;
	
	// It could be a cut for a I-joist. Try to retrieve the convexhull
	if( arPtInCuttingPlane.length() > 4 ){
		PLine plConvexHull(vCutNormal);
		plConvexHull.createConvexHull(Plane(ptCutOrg, vCutNormal), arPtInCuttingPlane);
		arPtInCuttingPlane = plConvexHull.vertexPoints(false);
		
		//Remove duplicate points.
		if (arPtInCuttingPlane.length() <= 0)
			continue;
		Point3d ptLast = arPtInCuttingPlane[0];
		Point3d arPtOptimized[] = {ptLast};
		for (int j=0;j<(arPtInCuttingPlane.length() - 1);j++) {
			Point3d ptThis = arPtInCuttingPlane[j];
			Point3d ptNext = arPtInCuttingPlane[j+1];
			
			Vector3d vToThis(ptThis - ptLast);
			// Skip points which are very close to the previous point
			if (vToThis.length() < dEps)
				continue;
			vToThis.normalize();
			Vector3d vToNext(ptNext - ptThis);
			vToNext.normalize();
			// Skip points which are in line with each other.
			if ((vToNext.crossProduct(vToThis)).length() < dEps) 
				continue;
			
			arPtOptimized.append(ptThis);
			ptLast = ptThis;
		}
		arPtInCuttingPlane = arPtOptimized;
		
		if( arPtInCuttingPlane.length() != 4 )
			continue;
	}
		
	// Calculate the center of the cutting plane.
	Point3d ptCenterCut;
	PLine plCut(vCutNormal);
	for( int j=0;j<arPtInCuttingPlane.length();j++ ){
		Point3d pt = arPtInCuttingPlane[j];
		plCut.addVertex(pt);
		ptCenterCut += pt;
	}
	ptCenterCut /= arPtInCuttingPlane.length();
	ptCenterCut.vis(3);
	vCutNormal.vis(ptCenterCut, i);	
	
	Map mapCut;
	// Is it the cut for this T-Connection? - Yes: store it. - No: ignore it.
	if( abs(vCutNormal.dotProduct(_Z1) - 1) < dEps && abs(_Z1.dotProduct(_Pt0 - ptCutOrg)) < (dDepth + dEps) ){
		ptCut = Line(ptCenterCut, _X0).intersect(Plane(_Pt0 + _Z1 * dDepth, _Z1), U(0));
		ptCut.vis(4);
		
		//Override default
		arPt0[0] = ptCenterCut;
		arPt1[0] = arPtInCuttingPlane[0];
		arPt2[0] = arPtInCuttingPlane[1];
		arPt3[0] = arPtInCuttingPlane[2];
		arPt4[0] = arPtInCuttingPlane[3];
		arVZ1[0] = vCutNormal;
		arBeam1[0] = _Beam1;
		arPtCut[0] = ptCut;
		
		mapCut.setPoint3d("PtCut", ptCutOrg);
		mapCut.setVector3d("Normal", vCutNormal);
		_Map.appendMap("OriginalCut", mapCut);

		continue;
	}
	
	// Apply preserved cuts again. Add them to the list of T-connections if it makes a T-connection.
	// Create body to find intersection.
	plCut.close();
	Body bdCut(plCut, vCutNormal);
	bdCut.vis(3);
	// Try to find intersection
	Beam beam1;
	for( int j=0;j<arBmFemale.length();j++ ){
		Beam bmFemale = arBmFemale[j];
		if( arBeam1.find(bmFemale) != -1 )
			continue;
		Body bdFemale = bmFemale.envelopeBody(true, true);
		
		int bIntersected = bdFemale.intersectWith(bdCut);
		if( bIntersected && bdFemale.volume() > dMinimumRequiredVolume )
			beam1 = bmFemale;		
	}
	
	// Cut position, will be changed if a female beam is found.
	Point3d ptCutToPreserve = ptCutOrg;
	// Add the female beam and the other parameters to the arrays used for the integration.
	if( beam1.bIsValid() ){
		// Change cut position.
		ptCutToPreserve = Line(ptCenterCut, _X0).intersect(Plane(ptCenterCut + vCutNormal * dDepth, vCutNormal), U(0));
		
		arPt0.append(ptCenterCut);
		arPt1.append(arPtInCuttingPlane[0]);
		arPt2.append(arPtInCuttingPlane[1]);
		arPt3.append(arPtInCuttingPlane[2]);
		arPt4.append(arPtInCuttingPlane[3]);
		arVZ1.append(vCutNormal);
		arBeam1.append(beam1);
		arPtCut.append(ptCutToPreserve);
		
		mapCut.setPoint3d("PtCut", ptCutOrg);
		mapCut.setVector3d("Normal", vCutNormal);
		_Map.appendMap("OriginalCut", mapCut);
	}	
	vCutNormal.vis(ptCutOrg,i);

	Map mapPreservedCut;
	mapPreservedCut.setPoint3d("PtCut", ptCutToPreserve);
	mapPreservedCut.setVector3d("Normal", vCutNormal);
	_Map.appendMap("PreservedCut", mapPreservedCut);
}


Cut cut(ptCut, _Z1);
_Beam0.addTool(cut, _kStretchOnToolChange);

for( int i=0;i<_Map.length();i++ ){
	if( !(_Map.hasMap(i) && _Map.keyAt(i) == "PreservedCut") )
		continue;
	
	Map mapPreservedCut = _Map.getMap(i);
	Point3d ptCut = mapPreservedCut.getPoint3d("PtCut");
	Vector3d vCut = mapPreservedCut.getVector3d("Normal");
	Cut cut(ptCut, vCut);
	_Beam0.addTool(cut, _kStretchNot);
}

// Apply extra cut if new extreme point of beam exceeds the face of the female beam.
// This is only apply if it wasn't exceeding before.
double dyOrder = _X0.dotProduct(_Y1);
if( abs(dyOrder) > dEps ){
	Vector3d vyOrder = _Y1;
	if( dyOrder < 0 )
		vyOrder *= -1;
	
	Point3d ptFemaleFaceTop = _Ptc + vyOrder * 0.5 * _Beam1.dD(vyOrder);
	ptFemaleFaceTop.vis(3);
	
	Line lnOrder(_Pt0, vyOrder);
	Point3d arPtMaleFace[] = {
		_Pt1, _Pt2, _Pt3, _Pt4
	};
	arPtMaleFace = lnOrder.orderPoints(arPtMaleFace);
	Point3d ptMaleFaceTop = arPtMaleFace[arPtMaleFace.length() - 1];
	ptMaleFaceTop.vis(4);
	
	double dToMaleFaceTop = vyOrder.dotProduct(ptMaleFaceTop - ptFemaleFaceTop);
	
	if( abs(dToMaleFaceTop) < dEps ){
		Cut cutExtra(ptFemaleFaceTop, vyOrder);
		_Beam0.addTool(cutExtra, _kStretchNot);
	}
}

for( int i=0;i<arPt0.length();i++ ){
	Point3d pt0 = arPt0[i];
	Point3d pt1 = arPt1[i];
	Point3d pt2 = arPt2[i];
	Point3d pt3 = arPt3[i];
	Point3d pt4 = arPt4[i];
	Vector3d vZ1 = arVZ1[i];
	Beam beam1 = arBeam1[i];
	Point3d ptCut = arPtCut[i];
	ptCut.vis(6);	
	//Define directions for connection
	Vector3d v1To2 = pt2 - pt1;
	Vector3d v1To4 = pt4 - pt1;
	double d1To2 = v1To2.length();
	double d1To4 = v1To4.length();
	
	Vector3d vxConnection = vZ1;
	Vector3d vzConnection = v1To2;
	if( d1To4 > d1To2 )
		vzConnection = v1To4;
	vzConnection.normalize();
	Vector3d vyConnection = vzConnection.crossProduct(vxConnection);
	
	Point3d arPtCorners[] = {
		pt1,
		pt2,
		pt3,
		pt4
	};
	Point3d arPtCornersZ[] = Line(pt0, vzConnection).orderPoints(arPtCorners);
	if( arPtCornersZ.length() == 0 ){
		eraseInstance();
		return;
	}
	
	double dH0 = vzConnection.dotProduct(arPtCornersZ[arPtCornersZ.length() - 1] - arPtCornersZ[0]);
	double dW0 = _Beam0.dD(vyConnection);
	
	Plane pnY(pt0, vyConnection);
	Plane pnZ(pt0, vzConnection);
	Point3d ptHelper = pt0 + _X0;
	Vector3d vxProjectedY = ptHelper - pt0;
	vxProjectedY = vxProjectedY.projectVector(pnY);
	vxProjectedY.normalize();
	Vector3d vxProjectedZ = ptHelper - pt0;
	vxProjectedZ = vxProjectedZ.projectVector(pnZ);
	vxProjectedZ.normalize();
	vxProjectedZ.vis(pt0, 150);
	
	vxConnection.vis(pt0, 1);
	vyConnection.vis(pt0, 3);
	vzConnection.vis(pt0, 150);
	
	//Angles from male axis projected to the connection planes and the main connection direction.
	double dAngleZ = vxConnection.angleTo(vxProjectedZ, vzConnection);
	double dAngleY = vxConnection.angleTo(vxProjectedY, vyConnection);
	
	//Width and length of beamcut
	double dWMill = (dW0 + dGapWidth)/cos(dAngleZ) + dDepth * abs(tan(dAngleZ));
	if (extraWidthForAdjacentConnections > U(0)) {
		Entity tools[] = beam1.eToolsConnected();
		_Map.setInt("IsAdjacentConnection", false);
		
//		reportNotice(TN("|Tools attached to|: ") + beam1.handle() +"\tRequested by: " + _ThisInst.handle());
		for (int t=0;t<tools.length();t++) {
			TslInst toolTsl = (TslInst)tools[t];
			if (!toolTsl.bIsValid())
				continue;
			
			// Not this tsl...
			if (toolTsl.handle() == _ThisInst.handle())
				continue;
			
//			reportNotice("\nTool tsl: " + toolTsl.scriptName() + " ~ " + toolTsl.handle());
			// Must be a tsl with the same name as this tsl.
			if (toolTsl.scriptName() != scriptName())
				continue;
			
//			reportNotice("\nDist: " + Vector3d(toolTsl.ptOrg() - pt0).length() + " ?> " + dWMill);
			// Is this tool close to the other tool?
			if (Vector3d(toolTsl.ptOrg() - pt0).length() > dWMill)
				continue;
			
			symbolColor = symbolColorAdjacentConnections;
			dWMill = (dW0 + dGapWidth + 2 * extraWidthForAdjacentConnections)/cos(dAngleZ) + dDepth * abs(tan(dAngleZ));
			
			_Map.setInt("IsAdjacentConnection", true);
			
			// Trigger the other tsl if it is not aware that it is an adjacent connection.
			int isAware = false;
			Map toolMap = toolTsl.map();
			if (toolMap.hasInt("IsAdjacentConnection"))
				isAware = toolMap.getInt("IsAdjacentConnection");
			// Make it aware if needed.
			if (!isAware)
				toolTsl.recalc();
		}
	}
		
	if( dWMill < dMinimumMillWidth )
		dWMill = dMinimumMillWidth;
	double dHMill = (dH0 + dGapLength) + dDepth * abs(tan(dAngleY));
	if( dHMill < dMinimumMillWidth )
		dHMill = dMinimumMillWidth;
	
	//Offset cut position with the depth transformed to the connection angles (0.5 * depth * tan(connectionAngle))
	int nSideY = 1;
	if( vyConnection.dotProduct(_X0) > 0 )
		nSideY *= -1;
	int nSideZ = 1;
	if( vzConnection.dotProduct(_X0) > 0 )
		nSideZ *= -1;
	Point3d ptBmCut = ptCut 
								+ vyConnection * nSideY * 0.5 * dDepth * abs(tan(dAngleZ)) 
								+ vzConnection * nSideZ * 0.5 * dDepth * abs(tan(dAngleY));

	Point3d ptBmStart = beam1.ptCenSolid() - 0.5 * beam1.vecX() * beam1.solidLength();
	Point3d ptBmEnd = beam1.ptCenSolid() + 0.5 * beam1.vecX() * beam1.solidLength();
	ptBmStart.vis(1);
	ptBmEnd.vis(1);
	double dToEnd = vyConnection.dotProduct(ptBmEnd - ptBmCut);
	double dToStart = vyConnection.dotProduct(ptBmCut - ptBmStart);
	double dFlagY = 0;
	if( abs(dToEnd) < dW0 ){
		if( dToEnd < 0 ){
			ptBmCut += vyConnection * 0.5 * dWMill;
			dWMill *= 2;
			dFlagY = -1;
		}
		else{
			ptBmCut -= vyConnection * 0.5 * dWMill;
			dWMill *= 2;
			dFlagY = 1;
		}
	}
	if( abs(dToStart) < dW0 ){
		if( dToStart < 0 ){
			ptBmCut -= vyConnection * 0.5 * dWMill;
			dWMill *= 2;
			dFlagY = 1;
		}
		else{
			ptBmCut += vyConnection * 0.5 * dWMill;
			dWMill *= 2;
			dFlagY = -1;
		}
	}
	
	//Beamcut
	ptBmCut.vis(6);
	BeamCut bmCut(ptBmCut, vxConnection, vyConnection, vzConnection, 2 * dDepth, dWMill, dHMill, -1, dFlagY, 0);
	beam1.addTool(bmCut);
	bmCut.cuttingBody().vis(3);
	
	if (bApplyMarking) 
	{
		String posnum = T("|" + _Beam[0].posnum() + "|");
		Vector3d markingFaceNormal = beam1.vecD(-el.vecZ());
		if (markingFaceNormal.dotProduct(-el.vecZ()) < 0)
		{
			markingFaceNormal *= -1;
		}
		if (sMarkingSide == T("|Outside|"))
		{
			markingFaceNormal = beam1.vecD(el.vecZ());
			if (markingFaceNormal.dotProduct(el.vecZ()) < 0)
			{
				markingFaceNormal *= -1;
			}
		}
		Mark mark(ptBmCut, markingFaceNormal, posnum);
		mark.suppressLine();
//		mark.setPosnumBeam(_Beam0);
		beam1.addTool(mark);
	}
	
	//Check for interference with other beams.
	Body bdInterference(ptBmCut + vxConnection * U(1), vxConnection, vyConnection, vzConnection, dDepth + U(1), dW0, dH0, -1, 0, 0);
	for( int j=0;j<arBmFemale.length();j++ ){
		Beam bm  = arBmFemale[j];
		if( bm.handle() == _Beam0.handle() || arBeam1.find(bm) != -1 )
			continue;
		if( abs(abs(bm.vecX().dotProduct(_Beam0.vecX())) - 1) < dEps )
			continue;
		
		if( bdInterference.hasIntersection(bm.realBody()) ){//envelopeBody(true, true)) )
			bm.envelopeBody().vis();
			bm.addTool(bmCut);
		}
	}
	
	//Visualization
	PLine plCross(vxConnection);
	plCross.addVertex(pt0 + vyConnection * 0.45 * dWMill);
	plCross.addVertex(pt0 - vyConnection * 0.45 * dWMill);
	plCross.addVertex(pt0);
	plCross.addVertex(pt0 + vzConnection * 0.45 * dHMill);
	plCross.addVertex(pt0 - vzConnection * 0.45 * dHMill);
	
	PLine plCircle(vxConnection);
	plCircle.createCircle(pt0, vxConnection, 0.25 * dWMill);
	
	Display dpSymbol(symbolColor);
	dpSymbol.draw(plCross);
	dpSymbol.draw(plCircle);
}













#End
#BeginThumbnail
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
D!_G([T;Z"VU+]%064S7-A;SN`&DB5R!TR1FIZS*"BBB@#__9
`






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End