#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
05.11.2020  -  version 3.04



























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to create nail lines on specific zones
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.04" date="05.11.2020"></version>

/// <history>
/// 1.00 - 16.03.2010 - 	Pilot version
/// 1.01 - 13.07.2010 - 	Add different nail spacing for perimeter nail lines
/// 1.02 - 23.09.2010 - 	Add beamcode filter
/// 1.03 - 01.08.2011 - 	Add element filter
/// 1.04 - 23.04.2012 - 	Increase tol.distance to plane for lineseg calculation
/// 1.05 - 06.09.2012 - 	Add option to pick a zone.
/// 2.00 - 12.12.2012 - 	Prepare for localiser
/// 2.01 - 12.02.2013 - 	TSL can be attached to element definition now.
/// 2.02 - 16.09.2014 - 	Add option to apply nailing per sheet.
/// 2.03 - 24.03.2015 - 	Use catalog values of this tsl.
/// 2.04 - 16.11.2015 - 	Allow wild cards for beam filters
/// 2.05 - 21.04.2016 - 	Add label filter
/// 2.06 - 21.04.2016 - 	Add property for distance to sheet edge
/// 2.07 - 06.12.2016 - 	Ignore lines with MapX data indicating that its a glue line.
/// 2.08 - 19.04.2019 - 	Cleanup for naillines on beam edge or sheet edge, function to calculate not always working
/// 2.09 - 19.04.2019 - 	Bugfix on combined beams and wrong planeprofile for getting the midpoint
/// 2.10 - 20.04.2019 - 	Bugfix on length of array upon adding extra naillines
/// 2.11 - 20.04.2019 - 	Bugfix on spacing
/// 3.00 - 05.07.2019 - 	Add filterdefenition and catalogs
/// 3.01 - 21.11.2019 - 	Minimum distance to sheetedge fix
/// 3.02 - 20.04.2020 - 	Only check perimeter naillines for minimum distance
/// 3.03 - 22.09.2020 - 	Add property to delete nailline when distance is smaller then minimumdistance
/// 3.04 - 05.11.2020 - 	Yes/no propertie to add naillines on non sheet edges (this will be glued)
/// </hsitory>


double dEps(Unit(0.01,"mm"));
double pointTolerance = U(.1);
String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};


String arSElementType[] = {T("|Roof|"), T("|Floor|"), T("|Wall|")};
String arSElementTypeCombinations[0];
int jStart = 1;
for( int i=0;i<arSElementType.length();i++ ){
	String sTypeA = arSElementType[i];
	if( arSElementTypeCombinations.find(sTypeA) == -1 )
		arSElementTypeCombinations.append(sTypeA);
	
	int j = jStart;

	while( j<arSElementType.length() ){
		String sTypeB = arSElementType[j];
		
		sTypeA += ";"+sTypeB;
		arSElementTypeCombinations.append(sTypeA);

		j++;
	}
	
	jStart++;
	if( jStart < arSElementType.length() )
		i--;
	else
		jStart = i+2;
}

String arSZnToProcess[] = 
{
	"Zone 0",
	"Zone 1",
	"Zone 2",
	"Zone 3",
	"Zone 4",
	"Zone 5",
	"Zone 6",
	"Zone 7",
	"Zone 8",
	"Zone 9",
	"Zone 10"
};
int arNZnToProcess[] = 
{
	0,
	1,
	2,
	3,
	4,
	5,
	-1,
	-2,
	-3,
	-4,
	-5
};
int arNColorForZnToProcess[] = {
	1,
	2,
	3,
	4,
	6,
	5,// color 5 was in old tsl also set for nailing on zone 6
	7,
	8,
	9,
	10
};

String category =  T("|Selection|");

PropString sApplyToolingToElementType(1, arSElementTypeCombinations, T("|Apply tooling to element type(s)|"),0);
sApplyToolingToElementType.setCategory(category);

category = T("|Filters|");

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");
PropString filterDefinitionGenBeams(9, filterDefinitions, T("|Filter definition genbeams|"));
filterDefinitionGenBeams.setDescription(T("|The filter definition used to filter the beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinitionGenBeams.setCategory(category);

PropString sFilterBC(2,"",T("Filter beams with beamcode"));
sFilterBC.setCategory(category);

PropString sFilterLabel(6,"",T("Filter beams and sheets with label"));
sFilterLabel.setCategory(category);

category = T("|Tooling|");

PropString sApplyToolingTo(4, arSZnToProcess, T("|Apply nailing to|"),2);
sApplyToolingTo.setCategory(category);

PropInt nToolingIndex(0, 10, T("|Toolindex|"));
nToolingIndex.setCategory(category);

PropDouble dPerimeterNailSpacing(0, U(100), T("|Perimeter nail spacing|"));
dPerimeterNailSpacing.setCategory(category);

PropDouble dIntermediateNailSpacing(1, U(200), T("|Intermediate nail spacing|"));
dIntermediateNailSpacing.setCategory(category);

PropDouble dMinimumDistanceTConnection(2, U(10), T("|Minimum distance to t-connection|"));
dMinimumDistanceTConnection.setCategory(category);

PropDouble dMinLengthOfNailLine(3, U(150), T("|Minimum allowed length of nail line|"));
dMinLengthOfNailLine.setCategory(category);

PropString sApplyNailingPerSheet(5, arSYesNo, T("|Apply nailing per sheet|"));
sApplyNailingPerSheet.setCategory(category);

PropDouble dDistEdgeSheetOnSheetJoint(4, U(0), T("|Minimum distance to sheet edge|"));
dDistEdgeSheetOnSheetJoint.setCategory(category);

PropString sAllowNaillinesInMinimumOffsetArea(10, arSYesNo, T("|Apply naillines in area smaller then minimum distance|"));
sAllowNaillinesInMinimumOffsetArea.setCategory(category);

PropString sAllowIntermediateNaillines(11, arSYesNo, T("|Apply intermediate naillines|"));
sAllowIntermediateNaillines.setCategory(category);

double dDistEdgeBeamOnSheetJoint = U(0);


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-Naillines");
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
	PrEntity ssE(T("Select a set of elements"), Element());

	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-Naillines"; // name of the script
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
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName && tsl.propString("     "+T("|Apply nailing to|")) == sApplyToolingTo){
					tsl.dbErase();
				}
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
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

// resolve properties

// nail these zones
int arNZone[0];
int nZnToProcess = arNZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)];
arNZone.append(nZnToProcess);
int arNColorIndex[0];
arNColorIndex.append(arNColorForZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)]);

//Allow merge
int bAllowSheetsToMerge = !arNYesNo[arSYesNo.find(sApplyNailingPerSheet,0)];
int bAllowNaillinesInMinimumOffsetArea = arNYesNo[arSYesNo.find(sAllowNaillinesInMinimumOffsetArea,0)];
int bAllowIntermediateNaillines = arNYesNo[arSYesNo.find(sAllowIntermediateNaillines,0)];

// check if there is a valid element selected.
if( _Element.length()==0 ){
	eraseInstance();
	return;
}

// get element
Element el = _Element[0];

Opening arOp[] = el.opening();

// create coordsys
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
// set origin point
_Pt0 = csEl.ptOrg();

double dz = vz.dotProduct(_ZW);
String sElemType;
if( abs(dz - 1) < dEps ){
	sElemType = T("|Floor|");
}
else if( abs(dz) < dEps ){
	sElemType = T("|Wall|");
}
else{
	sElemType = T("|Roof|");
}

if( sApplyToolingToElementType.find(sElemType,0) == -1 ){
	reportMessage(TN("|Element type filtered out|"+": "+sElemType));
	eraseInstance();
	return;
}

// lines for sorting points
Line lnX(_Pt0, vx);
Line lnY(_Pt0, vy);

// display
Display dp(-1);

// collect beams used for nailing
Beam arBmAll[] = el.beam();
Beam arBm[0];
Sheet sheets[0];

GenBeam genBeams[] = el.genBeam();
Entity genBeamEntities[0];
for (int b = 0; b < genBeams.length(); b++)
{
	genBeamEntities.append(genBeams[b]);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
filterGenBeamsMap.setString("Label[]", sFilterLabel);
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinitionGenBeams, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
genBeamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

for( int i=0;i<genBeamEntities.length();i++ ){
	GenBeam gBm = (GenBeam)genBeamEntities[i];
	
	Beam bm = (Beam)gBm;
	if (bm.bIsValid())
		arBm.append(bm);
	
	Sheet sh = (Sheet)gBm;
	if (sh.bIsValid())
		sheets.append(sh);
}

// uncatagorized beams
Beam arBmOther[0];

// use dummy beams to create valid line segments. dummy beams are erased at the end of this tsl.
Beam arBmDummy[0];

for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	String sBmCode = bm.beamCode();
	int nBmType = bm.type();
	
	// no nail studs
	String sNoNailCode = sBmCode.token(8);
	sNoNailCode.makeUpper();
	if( sNoNailCode == "NO" ){
		continue;
	}
	else{
		// uncategorized
//		bm.envelopeBody().vis();
		arBmOther.append(bm);
	}
}

// remove all nailing lines of nZone with color nColorIndex
for( int i=0;i<arNZone.length();i++ ){
	// zone
	int nZone = arNZone[i];
	// color
	int nColorIndex = arNColorIndex[i];
	
	//remove old naillines
	NailLine nlOld[] = el.nailLine(nZone);
	for( int n=0; n<nlOld.length(); n++ ){
		NailLine nl = nlOld[n];
		if (nl.subMapXKeys().find("hsb_Information") != -1) 
		{
			Map informationMap = nl.subMapX("hsb_Information");
			int isAGlueLine = (informationMap.getString("Type") == "GlueLine");
			
			if (isAGlueLine)
				continue;
		}
		if( nl.zoneIndex() == nZone ){
			nl.dbErase();
		}
	}
	
	//Side of zone
	int nSide = 1;
	if (nZone<0) nSide = -1;
	
	// get coordSys of the back of zone 1 or -1, the surface of the beams
	CoordSys csBeam = el.zone(nSide).coordSys();
	// get the coordSys of the back of the zone to nail
	CoordSys csSheet = el.zone(nZone).coordSys();
	
	Sheet arSh[0];
	// profile of zone	
	PlaneProfile ppZone(csEl);
	Point3d arPtZone[0];
	for( int j=0;j<sheets.length();j++ ){
		Sheet sh = sheets[j];
		if (sh.myZoneIndex() != nZone)
			continue;
		arSh.append(sh);
		
		PlaneProfile ppSh = sh.profShape();
		ppZone.unionWith(ppSh);
		arPtZone.append(ppSh.getGripVertexPoints());
	}
	ppZone.shrink(-U(10));
	ppZone.shrink(U(10));
	
	PlaneProfile ppZoneBrutto(csEl);
	PLine plZoneBrutto(vz);
	plZoneBrutto.createConvexHull(Plane(csSheet.ptOrg(), vz), arPtZone);
	ppZoneBrutto.joinRing(plZoneBrutto, _kAdd);
	
	PlaneProfile ppOpeningZone(csEl);
	ppOpeningZone.unionWith(ppZoneBrutto);
	ppOpeningZone.subtractProfile(ppZone);
	//ppOpeningZone.vis(5);
	
	PLine arPlOpeningZone[] = ppOpeningZone.allRings();

//	ppZone.vis(1);
	PLine arPlZone[] = ppZone.allRings();
	int arBRingIsOpening[] = ppZone.ringIsOpening();
	
	// beams to nail
	Beam arBmToNail[0];
	arBmToNail.append(arBmOther);
		
	//Plane beam
	Plane planeBeam(csBeam.ptOrg(),csBeam.vecZ());
	
	double dTolDistPlaneBeam = U(25);
	double dShrinkDistBeam = dDistEdgeBeamOnSheetJoint;

	//Plane sheet
	Plane planeSheet(csSheet.ptOrg(),csSheet.vecZ());
	double dTolDistPlaneSheet = U(25);
	double dShrinkDistSheet = U(0);
	
	//Shrink naillines
	double dShrinkDistNailLine = dMinimumDistanceTConnection;
	
	double dSpacing = dIntermediateNailSpacing;
	
	// get all naillines and apply filters on these nailines
	LineSeg arSeg[] = NailLine().calculateAllowedNailLineSegments(
		arBmToNail, planeBeam, dTolDistPlaneBeam, dShrinkDistBeam,
		arSh, planeSheet, dTolDistPlaneSheet, dShrinkDistSheet,
		bAllowSheetsToMerge, dShrinkDistNailLine
	);
	
	// now add nailing lines
	NailLine arNL[0];
	for (int n=0; n<arSeg.length(); n++) 
	{
		Point3d ptStartNailLine = arSeg[n].ptStart();
		Point3d ptEndNailLine = arSeg[n].ptEnd();
		
		Vector3d vLine(ptEndNailLine - ptStartNailLine);
		vLine.normalize();
					
		if( Vector3d(ptEndNailLine - ptStartNailLine).length() < dMinLengthOfNailLine )continue;
		
		// make ElemNail tool to be used in the construction of a nailing line
		ElemNail enl(nZone, ptStartNailLine, ptEndNailLine, dSpacing, nToolingIndex);
		// add the nailing line to the database
//		ptStartNailLine.vis(1);
//		ptEndNailLine.vis(3);
		NailLine nl;
		nl.dbCreate(el, enl);
		nl.setColor(nColorIndex); // set color of Nailing line
		arNL.append(nl);
	}	
	NailLine newNailLines[0];
	newNailLines.append(arNL);
	// cleanup for naillines on beam edge or sheet edge, function to calculate not always working...
	NailLine perimeterNaillines[] = NailLine().filterNailLinesCloseToSheetingEdge(arNL, arSh, dDistEdgeSheetOnSheetJoint);
	for( int c=0;c<arNL.length();c++ )
	{
		NailLine nl = arNL[c];
		PLine plNail = nl.plPath();
		Point3d plVertexPoints[] = plNail.vertexPoints(true);
		Point3d startPoint = plVertexPoints[0];
//		startPoint.vis(c);
		Point3d endPoint = plVertexPoints[plVertexPoints.length() -1];
//		endPoint.vis(c);
		Point3d midPoint = (startPoint + endPoint) / 2;
		Vector3d plVector(endPoint - startPoint);
		plVector.normalize();
		
		PlaneProfile ppAllBeam(planeBeam);
		
		Beam intersectingBeams[0];
		PlaneProfile beamProfiles[0];
		for (int index=0;index<arBmToNail.length();index++) 
		{ 
			Beam bm = arBmToNail[index]; 
			if (abs(csBeam.vecZ().dotProduct(bm.vecD(csBeam.vecZ()))) < 1 - dEps) continue;
			if (abs(bm.vecX().dotProduct(plVector)) < 1 - dEps) continue;
			PlaneProfile ppThisBeam = bm.envelopeBody().extractContactFaceInPlane(planeBeam, dTolDistPlaneBeam);
			ppThisBeam.shrink(- pointTolerance);
			if (ppThisBeam.pointInProfile(startPoint) == _kPointInProfile || ppThisBeam.pointInProfile(midPoint) == _kPointInProfile || ppThisBeam.pointInProfile(endPoint) == _kPointInProfile)
			{
				intersectingBeams.append(bm);
				ppAllBeam.unionWith(ppThisBeam);
				beamProfiles.append(ppThisBeam);
			}			
		}
		ppAllBeam.shrink(2 * pointTolerance);
		
		PlaneProfile ppAllSheet(planeSheet);
		PlaneProfile sheetProfiles[0];
		Sheet intersectingSheets[0];
		for (int index=0;index<arSh.length();index++) 
		{ 
			Sheet sh = arSh[index]; 
			if (abs(csSheet.vecZ().dotProduct(sh.vecZ())) < 1 - dEps) continue;
			PlaneProfile ppThisSheet = sh.envelopeBody().extractContactFaceInPlane(planeSheet, dTolDistPlaneSheet);
			ppThisSheet.shrink(- pointTolerance);
			if (ppThisSheet.pointInProfile(startPoint) == _kPointInProfile || ppThisSheet.pointInProfile(midPoint) == _kPointInProfile || ppThisSheet.pointInProfile(endPoint) == _kPointInProfile)
			{
				intersectingSheets.append(sh);
				ppAllSheet.unionWith(ppThisSheet);
				sheetProfiles.append(ppThisSheet);
			}
		}
		
		ppAllSheet.shrink(2 * pointTolerance);
//		ppAllSheet.vis(c);
		//cleanup sheets
		int eraseNailline = false;
		for (int index = 0; index < intersectingSheets.length(); index++)
		{
			Sheet sheet = intersectingSheets[index];
			PlaneProfile sheetProfile = sheetProfiles[index];
			PlaneProfile shrinkedProfile = sheetProfile;
			PlaneProfile sizeTestProfile = shrinkedProfile;
			sizeTestProfile.intersectWith(ppAllBeam);
			if (abs(csBeam.vecZ().crossProduct(plVector).dotProduct(sizeTestProfile.extentInDir(csBeam.vecZ().crossProduct(plVector)).ptStart() - sizeTestProfile.extentInDir(csBeam.vecZ().crossProduct(plVector)).ptEnd())) < dDistEdgeSheetOnSheetJoint && ! bAllowNaillinesInMinimumOffsetArea)
			{
				eraseNailline = true;
				continue;
			}
			shrinkedProfile.shrink(2 * pointTolerance);
			
			if (shrinkedProfile.pointInProfile(startPoint) != _kPointInProfile || shrinkedProfile.pointInProfile(midPoint) != _kPointInProfile || shrinkedProfile.pointInProfile(endPoint) != _kPointInProfile)
			{
				Vector3d perpendicular = csSheet.vecZ().crossProduct(plVector);
				if (perpendicular.dotProduct(midPoint - sheet.ptCen()) < 0)
				{
					perpendicular *= -1;
				}
				sheetProfile.intersectWith(ppAllBeam);
				
				//sheetProfile.vis(1);
				LineSeg lineseg(midPoint - perpendicular * U(1000), midPoint + perpendicular * U(1000));
				LineSeg linesegs[] = sheetProfile.splitSegments(lineseg, true);
				if (linesegs.length() < 1) continue;
				Point3d midPoint = linesegs[0].ptMid();
				//				midPoint.vis();
				NailLine newNailLine = nl.dbCopy();
				newNailLine.transformBy(perpendicular * perpendicular.dotProduct(midPoint - startPoint));
				PLine plNail = newNailLine.plPath();
				Point3d plVertexPoints[] = plNail.vertexPoints(true);
				Point3d startPoint = plVertexPoints[0];
				//		startPoint.vis(c);
				Point3d endPoint = plVertexPoints[plVertexPoints.length() - 1];
				newNailLines.append(newNailLine);
				eraseNailline = true;
				
				shrinkedProfile.shrink(dDistEdgeSheetOnSheetJoint - pointTolerance);
				
				if (shrinkedProfile.pointInProfile(startPoint) != _kPointInProfile || shrinkedProfile.pointInProfile(midPoint) != _kPointInProfile || shrinkedProfile.pointInProfile(endPoint) != _kPointInProfile)
				{
					Vector3d perpendicular = csSheet.vecZ().crossProduct(plVector);
					if (perpendicular.dotProduct(midPoint - sheet.ptCen()) < 0)
					{
						perpendicular *= -1;
					}
					shrinkedProfile.intersectWith(ppAllBeam);
					//sheetProfile.vis(1);
					LineSeg lineseg(midPoint - perpendicular * U(1000), midPoint + perpendicular * U(1000));
					LineSeg linesegs[] = shrinkedProfile.splitSegments(lineseg, true);
					if (linesegs.length() < 1) continue;
					Point3d endPoint = linesegs[0].ptEnd();
					//				midPoint.vis();
					newNailLine.transformBy(perpendicular * perpendicular.dotProduct(endPoint - startPoint));
				}
			}
			else
			{
				shrinkedProfile.shrink(dDistEdgeSheetOnSheetJoint - pointTolerance);
				if (perimeterNaillines.find(nl) == -1 && dDistEdgeSheetOnSheetJoint > 0) break;
				if (shrinkedProfile.pointInProfile(startPoint) != _kPointInProfile || shrinkedProfile.pointInProfile(midPoint) != _kPointInProfile || shrinkedProfile.pointInProfile(endPoint) != _kPointInProfile)
				{
					Vector3d perpendicular = csSheet.vecZ().crossProduct(plVector);
					if (perpendicular.dotProduct(midPoint - sheet.ptCen()) < 0)
					{
						perpendicular *= -1;
					}
					shrinkedProfile.intersectWith(ppAllBeam);
					//sheetProfile.vis(1);
					LineSeg lineseg(midPoint - perpendicular * U(1000), midPoint + perpendicular * U(1000));
					LineSeg linesegs[] = shrinkedProfile.splitSegments(lineseg, true);
					if (linesegs.length() < 1) continue;
					linesegs[0].vis();
					Point3d endPoint = linesegs[0].ptEnd();
					//				midPoint.vis();
					NailLine newNailLine = nl.dbCopy();
					newNailLine.transformBy(perpendicular * perpendicular.dotProduct(endPoint - startPoint));
					newNailLines.append(newNailLine);
					eraseNailline = true;
				}
			}
		}
		
		// cleanup beams
		for (int index=0;index<intersectingBeams.length();index++) 
		{ 
			Beam beam = intersectingBeams[index]; 
			if (abs(beam.vecX().dotProduct(plVector)) < 1 - dEps) continue;
			PlaneProfile beamProfile = beamProfiles[index];
			beamProfile.shrink(2 * pointTolerance);
			if (beamProfile.pointInProfile(startPoint) != _kPointInProfile || beamProfile.pointInProfile(midPoint) != _kPointInProfile || beamProfile.pointInProfile(endPoint) != _kPointInProfile)
			 { 
			 	Vector3d perpendicular = csBeam.vecZ().crossProduct(plVector);
				beamProfile.intersectWith(ppAllSheet);
				//beamProfile.vis(1);
				LineSeg lineseg(midPoint - perpendicular * U(1000), midPoint + perpendicular * U(1000));
				LineSeg linesegs[] = beamProfile.splitSegments(lineseg, true);
				if (linesegs.length() < 1) continue;
				Point3d midPoint = linesegs[0].ptMid();
				NailLine newNailLine = nl.dbCopy();
				newNailLine.transformBy(perpendicular * perpendicular.dotProduct(midPoint - startPoint));
				newNailLines.append(newNailLine);
				eraseNailline = true;
			 }
		}
		
		if (eraseNailline)
		{
			newNailLines.removeAt(newNailLines.find(nl));
			nl.dbErase();
			continue;
		}
	}
	
	if (!bAllowSheetsToMerge)
	{
		NailLine arNLPerimeter[] = NailLine().filterNailLinesCloseToSheetingEdge(newNailLines, arSh, U(40));
		for( int j=0;j<newNailLines.length();j++ )
		{
			NailLine nl = newNailLines[j];
			if (!nl.bIsValid()) continue;
			
			if (arNLPerimeter.find(nl) == -1 && ! bAllowIntermediateNaillines)
			{
				nl.dbErase();
				continue;
			}
			else if (arNLPerimeter.find(nl) != -1)
			{
				nl.setSpacing(dPerimeterNailSpacing);
			}
		}
	}
	else
	{
		ppZone.shrink(U(40));
		for (int index=0;index<newNailLines.length();index++) 
		{ 
			NailLine nl = newNailLines[index]; 
			if (!nl.bIsValid()) continue;
			PLine plNail = nl.plPath();
			Point3d plVertexPoints[] = plNail.vertexPoints(true);
			Point3d startPoint = plVertexPoints[0];
	//		startPoint.vis(c);
			Point3d endPoint = plVertexPoints[plVertexPoints.length() -1];
	//		endPoint.vis(c);
			Point3d midPoint = (startPoint + endPoint) / 2;
			if (ppZone.pointInProfile(midPoint) != _kPointInProfile)
			{
				nl.setSpacing(dPerimeterNailSpacing);
			}
			else if(! bAllowIntermediateNaillines)
			{
				nl.dbErase();
			}
		}
		
	}
}

for( int i=0;i<arBmDummy.length();i++ ){
	Beam bmDummy = arBmDummy[i];
	bmDummy.dbErase();
}

if( _bOnElementConstructed || bManualInsert )
{
	eraseInstance();
}


























#End
#BeginThumbnail
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
M7G#_`.A/755FU)I?RK\D5A*LH4YI=C7HHHKA.4****!!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`$5U<+:6DUPP)6)&<@=2`,US>B
M7UT-=O$N8(T^U3#(1\F-O*#`>XVCKZUT[HLL;1NH9&!5E(R"#VKG]%TRV@US
M4F578P.@C+N6VY09ZGKCC/IQ6U-QY)7._#2IJC44EK;]4&A?\C5XJ_Z^H/\`
MTGCJU%_R-US[V<?_`*&U5="_Y&KQ5_U]0?\`I/'6)9V]PNOQCRKH7X"&20@X
MSO.\D]"NWM],5T5(\TWKT7Y(G`TE.$VW;0[VBBBN$XPHHHH$%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%9&E_P#(;UD?]-(S_P".
M"M>LC3/^0[K/^_%_Z!5QV9TT?X=3T_5%30O^1J\5?]?4'_I/'5I/^1OE][)?
M_0S570O^1J\5?]?4'_I/'5I?^1O?_KR'_H==%?X_^W5^2)PVTO1FQ1117(8!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_
!V110
`
























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