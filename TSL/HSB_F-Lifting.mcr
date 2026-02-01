#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
15.02.2019  -  version 1.10

This tsl adds a grid of lifting positions to a floor element. The grid can be adjusted with grip points.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a grid of lifting positions to a floor element. The grid can be adjusted with grip points.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.10" date="15.02.2019"></version>

/// <history>
/// AS - 1.00 - 21.04.2015	- Pilot version
/// AS - 1.01 - 22.04.2015	- Add elemDrill as tool
/// AS - 1.02 - 05.11.2015	- Add drill to other beams at the same location as the column beam. Column beam might be split.
/// AS - 1.03 - 06.11.2015	- Support 4 rows
/// AS - 1.04 - 24.11.2015	- Add property for minimum distance to the element edges, avoid vertical beams, drill toching rafters too.
/// AS - 1.05 - 04.02.2016	- Hide origin point
/// AS - 1.06 - 10.03.2016	- Only add touching beams if they are intersecting with the actual tool position.
/// AS - 1.07 - 10.03.2016	- Change warning into notification.
/// RVW - 1.08 - 04.01.2019	- Change vyEl / vxEl depending on the user liftingside choice.
/// RVW - 1.09 - 07.02.2019	- Add option to filter beams from the lifting drill.
/// RVW - 1.10 - 15.02.2019 	- Add check that the tsl cant be executed twice with the same identifier in one element.
/// </history>


double dEps = Unit(0.01,"mm");

String arSCategory[] = {
	T("|Lifting grid|"),
	T("|Drill in beam|"),
	T("|Lifting symbol|"),
	T("|Drill in sheeting|")
};


String arLiftingSide[] = {
	T ("|Allign with joist|"),
	T ("|Perpendiculair with joist|")
};


int arNZoneIndex[] = {
	0,1,2,3,4,5,6,7,8,9,10
};

int arNSheetIndex[] = {
	1,2,3,4,5,6,7,8,9,10
};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
PropString tslIdentifier (4, "Pos 1", " " + T("  |General|"));
tslIdentifier.setDescription(T("|Only one tsl instance, per identifier, can be attached to an element.|"));

int arNNROfRows[] = {2,3,4};
PropString liftingSide(2, arLiftingSide, T ("|Lifting side|"), 0);
liftingSide.setCategory(arSCategory[0]);
PropInt nNrOfRows(0, arNNROfRows, T("|Number of lifting rows|"));
nNrOfRows.setCategory(arSCategory[0]);
PropInt nNrOfColumns(1, 2,  T("|Number of lifting columns|"));
nNrOfColumns.setReadOnly(true);
nNrOfColumns.setCategory(arSCategory[0]);
PropDouble minimumDistanceFromElementEdge(8, U(100), T("|Minimum distance from the edge of the element|"));
minimumDistanceFromElementEdge.setCategory(arSCategory[0]);

PropString fFilterBeamCodes (3, "", T("|Filter beamcodes|"));
fFilterBeamCodes.setCategory(arSCategory[1]);
PropDouble dDrillDiameterBeam(4,  U(30), T("|Drill diameter beam|"));
dDrillDiameterBeam.setCategory(arSCategory[1]);

PropInt nZoneIndexToDrill(5, arNSheetIndex, T("|Drill sheeting in zone|"));
nZoneIndexToDrill.setCategory(arSCategory[3]);
PropDouble dOffsetSheetDrill(6,  U(30), T("|Offset drill sheeting|"));
dOffsetSheetDrill.setCategory(arSCategory[3]);
PropDouble dDrillDiameterSheet(5,  U(30), T("|Drill diameter sheeting|"));
dDrillDiameterSheet.setCategory(arSCategory[3]);
PropDouble dExtraDepthDrillSheet(7, U(1), T("|Extra depth drill sheeting|"));
dExtraDepthDrillSheet.setCategory(arSCategory[3]);
PropInt nToolIndexDrillSheet(4, 1, T("|Tool index drill sheeting|"));
nToolIndexDrillSheet.setCategory(arSCategory[3]);

PropInt nZoneIndex(2, arNZoneIndex, T("|Assign to zone|"));
nZoneIndex.setCategory(arSCategory[2]);
PropDouble dWSymbol(0, U(100), T("|Symbol width|"));
dWSymbol.setCategory(arSCategory[2]);
PropDouble dHSymbol(1, U(100), T("|Symbol height|"));
dHSymbol.setCategory(arSCategory[2]);
PropInt nColorSymbol(3, 2, T("|Symbol color|"));
nColorSymbol.setCategory(arSCategory[2]);
PropString sHatchPattern(0, _HatchPatterns,T("|Hatch pattern|"));
sHatchPattern.setCategory(arSCategory[2]);
PropDouble dHatchScale(2, U(1), T("|Hatch scale|"));
dHatchScale.setCategory(arSCategory[2]);
PropString sDescription(1, "", T("|Description|"));
sDescription.setCategory(arSCategory[2]);
PropDouble dTextSize(3, U(100), T("|Text size|"));
dTextSize.setCategory(arSCategory[2]);



// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_F-Lifting");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


if ( _bOnInsert )
{
	if ( insertCycleCount() > 1 )
	{
		eraseInstance();
		return;
	}
	
	// show the dialog if no catalog in use
	if ( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 ) {
		if ( _kExecuteKey != "" )
			reportMessage("\n" + scriptName() + TN("|Catalog key| ") + _kExecuteKey + T(" |not found|!"));
		showDialog();
	}
	else {
		setPropValuesFromCatalog(_kExecuteKey);
	}
	
	Element selectedElements[0];
	PrEntity ssEl(T("Select a set of elements"), Element());
	if ( ssEl.go() )
	{
		selectedElements.append(ssEl.elementSet());
	}
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1, 0, 0);
	Vector3d vecUcsY(0, 1, 0);
	Beam lstBeams[0];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", true);
	setCatalogFromPropValues("MasterToSatellite");
	
	for (int e = 0; e < selectedElements.length(); e++)
	{
		Element selectedElement = selectedElements[e];
		if ( ! selectedElement.bIsValid()) continue;
		
		TslInst arTsl[] = selectedElement.tslInst();
		for ( int j = 0; j < arTsl.length(); j++)
		{
			TslInst tsl = arTsl[j];
			if ( ! tsl.bIsValid() || (tsl.scriptName() == strScriptName && tsl.propString(15) == tslIdentifier))
			{
				tsl.dbErase();
			}
		}
		
		lstEntities[0]	= selectedElement;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		
		eraseInstance();
		return;
	}
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

if( _Element.length() == 0 ){
	reportNotice("\n" + scriptName() + TN("|No element selected|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
if( !el.bIsValid() ){
	reportNotice("\n" + scriptName() + TN("|Invalid element found|!"));
	eraseInstance();
	return;
}

tslIdentifier.setReadOnly(true);

TslInst arTsl[] = el.tslInst();
for( int t=0;t<arTsl.length();t++ )
{
	TslInst tsl = arTsl[t];
	if (tsl.scriptName() != scriptName() || tsl.propString(4) != tslIdentifier || tsl.handle() == _ThisInst.handle()) continue;
	{
		tsl.dbErase();
	}	
}


int nZnIndex = nZoneIndex;
if( nZnIndex > 5 )
	nZnIndex = 5 - nZnIndex;

int nZnIndexToDrill = nZoneIndexToDrill;
if( nZnIndexToDrill > 5 )
	nZnIndexToDrill = 5 - nZnIndexToDrill;

Hatch hatch(sHatchPattern, dHatchScale);

_ThisInst.assignToElementGroup(el, true, 0, 'E');


//CoordSys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

//Switch vxEl and vyEl if ("|Allign with joist|") is not chosen.
if(liftingSide != T ("|Allign with joist|"))
{
	vyEl = csEl.vecX();
	vxEl = csEl.vecY();
}

// Drill parameters
CoordSys csTopOfZnToDrill = el.zone(nZnIndexToDrill + 1).coordSys();
if (nZnIndexToDrill < 0)
	csTopOfZnToDrill = el.zone(nZnIndexToDrill - 1).coordSys();
Point3d ptOnTopOfZnToDrill = csTopOfZnToDrill.ptOrg();

Vector3d vDrillDirection = -csTopOfZnToDrill.vecZ();
double dDrillDepth = el.zone(nZnIndexToDrill).dH() + dExtraDepthDrillSheet;

Line lnElX(ptEl, vxEl);
Line lnElY(ptEl, vyEl);

Point3d arPtEl[] = el.plEnvelope().vertexPoints(true);
Point3d arPtElX[] = lnElX.orderPoints(arPtEl);
Point3d arPtElY[] = lnElY.orderPoints(arPtEl);

Point3d ptBL = arPtElX[0];
ptBL += vyEl * vyEl.dotProduct(arPtElY[0] - ptBL);
Point3d ptTR = arPtElX[arPtElX.length() - 1];
ptTR += vyEl * vyEl.dotProduct(arPtElY[arPtElY.length() - 1] - ptTR);

LineSeg lnMinMax(ptBL, ptTR);

//Create displays
Display dp(-1);
if( _bOnDebug )
	dp.draw(lnMinMax);

Display dpSymbol(nColorSymbol);
dpSymbol.elemZone(el, nZnIndex, 'I');
dpSymbol.textHeight(dTextSize);

// Find reference point for zone.
Point3d ptZn = ptEl;
if( nZnIndex < 0 )
	ptZn = el.zone(nZnIndex - 1).coordSys().ptOrg();
if( nZnIndex > 0 )
	ptZn = el.zone(nZnIndex + 1).coordSys().ptOrg();
Plane pnZn(ptZn, vzEl);

// Find the rafters.
Beam arBm[] = el.beam();
Beam arBmRafter[0];
Beam arBmBlocking[0];
Entity genBeams[0];

// Append all the beams in the genBeams entity array
for (int b = 0; b<arBm.length(); b++)
{
	genBeams.append(arBm[b]);
}

if (fFilterBeamCodes != "")
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(genBeams, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", fFilterBeamCodes);
	filterGenBeamsMap.setInt("Exclude", true);
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMap);
	if ( ! successfullyFiltered) {
		reportNotice(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	genBeams = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
}


PlaneProfile ppBlocking(csEl);

for( int i=0;i<genBeams.length();i++ ){
	Beam bm = (Beam)genBeams[i];	

	if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps ) {
		if (abs(vxEl.dotProduct(ptBL - bm.ptCen())) < minimumDistanceFromElementEdge || abs(vxEl.dotProduct(ptTR - bm.ptCen())) < minimumDistanceFromElementEdge)
			continue;
		arBmRafter.append(bm);
	}
	else if( abs(abs(bm.vecX().dotProduct(vxEl)) - 1) < dEps ) {
		arBmBlocking.append(bm);
		
		Point3d ptBlockBL = bm.ptCen() - vyEl * 0.5 * bm.dD(vyEl);
		ptBlockBL += vxEl * vxEl.dotProduct((ptBL - vxEl * U(100)) - ptBlockBL);
		Point3d ptBlockTR = bm.ptCen() + vyEl * 0.5 * bm.dD(vyEl);
		ptBlockTR += vxEl * vxEl.dotProduct((ptTR + vxEl * U(100)) - ptBlockTR);
		
		PlaneProfile ppBlock(csEl);
		PLine plBlock(vzEl);
		plBlock.createRectangle(LineSeg(ptBlockBL, ptBlockTR), vxEl, vyEl);
		ppBlock.joinRing(plBlock, _kAdd);
		ppBlocking.unionWith(ppBlock);
	}
}
ppBlocking.shrink(-0.5 * dDrillDiameterSheet);
ppBlocking.vis(3);

// TODO: This should be the center of gravity.
Point3d ptReference = lnMinMax.ptMid();
_ThisInst.setAllowGripAtPt0(false);

if( _kNameLastChangedProp == T("|Number of lifting rows|") ){
	Point3d arPtColumn[0];
	if( _PtG.length() >= nNrOfColumns ){
		for( int i=0;i<nNrOfColumns;i++ )
			arPtColumn.append(_PtG[i]);
		
		_PtG.setLength(0);
		for( int i=0;i<arPtColumn.length();i++ )
			_PtG.append(arPtColumn[i]);
	}
	else{
		_PtG.setLength(0);
	}
}

if( _PtG.length() == 0 || _kNameLastChangedProp == T ("|Lifting side|")){ 
	// Add columns.
	_PtG.setLength(0);
	_PtG.append(ptBL);
	_PtG.append(ptTR);
}

if( _PtG.length() == nNrOfColumns ){
	// Add the rows.
	if (nNrOfRows == 4) {
		_PtG.append((ptTR + ptBL)/5);
		_PtG.append(2 * (ptTR + ptBL)/5);
		_PtG.append(3 * (ptTR + ptBL)/5);
		_PtG.append(4 * (ptTR + ptBL)/5);
	}
	else {
		_PtG.append((ptReference + ptBL)/2);
		if( nNrOfRows == 3 )
			_PtG.append(ptReference);
		_PtG.append((ptReference + ptTR)/2);
	}
}

// Project the column grips top the bottom and to the closest rafter.
Beam arBmColumn[0];
for( int i=0;i<nNrOfColumns;i++ ){
	_PtG[i] += vyEl * vyEl.dotProduct(ptBL - _PtG[i]);
	
	// Find the closest rafter.
	double dClosest;
	Beam bmClosest;
	for( int j=0;j<arBmRafter.length();j++ ){
		Beam bmRafter = arBmRafter[j];
		double dToThisRafter = vxEl.dotProduct(bmRafter.ptCen() - _PtG[i]);
		if( !bmClosest.bIsValid() ){
			dClosest = abs(dToThisRafter);
			bmClosest = bmRafter;
		}
		else{
			if( abs(dToThisRafter) < dClosest ){
				dClosest = abs(dToThisRafter);
				bmClosest = bmRafter;
			}
		}
	}
	
	if( bmClosest.bIsValid() ){
		_PtG[i] += vxEl * vxEl.dotProduct(bmClosest.ptCen() - _PtG[i]);
		arBmColumn.append(bmClosest);
	}
	else{
		reportNotice("\n" + scriptName() + TN("|No closest beam found|!"));
		dp.draw(lnMinMax);
		return;
	}
	_PtG[i] = pnZn.closestPointTo(_PtG[i]);
}

// Project the rows to the side, avoid blockings
for( int i=nNrOfColumns;i<_PtG.length();i++ ){
	_PtG[i] += vxEl * vxEl.dotProduct(ptBL - _PtG[i]);
	Point3d pt = _PtG[i];
	
	if (ppBlocking.pointInProfile(pt) == _kPointInProfile) {
		Point3d pt = ppBlocking.closestPointTo(pt);
		pt.vis(1);
		_PtG[i] = pt;
	}	
	
	_PtG[i] = pnZn.closestPointTo(_PtG[i]);
}

Sheet arSh[] = el.sheet();
// Find the lifting points.
for( int i=0;i<nNrOfColumns;i++ ){
	Point3d ptColumn = _PtG[i];
	Line lnColumn(ptColumn, vyEl);
	
	Beam bmColumn = arBmColumn[i];
	bmColumn.envelopeBody().vis(3);
	for( int j=nNrOfColumns;j<_PtG.length();j++ ){
		Point3d ptRow = _PtG[j];
		
		Point3d ptToolPosition = lnColumn.intersect(Plane(ptRow, vyEl), U(0));
		ptToolPosition = Line(bmColumn.ptCen(), bmColumn.vecX()).closestPointTo(ptToolPosition);
		
		// Drill beams
		// Find touching rafters.
		Beam touchingRafters[] = bmColumn.filterBeamsCapsuleIntersect(arBmRafter);
		Beam touchingRaftersForThisPosition[0];		
		
		Point3d drillExtremes[] = {
			bmColumn.ptCen() - vxEl * 0.5 * bmColumn.dD(vxEl),
			bmColumn.ptCen() + vxEl * 0.5 * bmColumn.dD(vxEl)
		};
		for (int t=0;t<touchingRafters.length();t++) {
			Beam bm = touchingRafters[t];

			if (bm.handle() == bmColumn.handle())
				continue;
			if (abs(vxEl.dotProduct(bm.ptCen() - bmColumn.ptCen())) >  0.75 * (bmColumn.dD(vxEl) + bm.dD(vxEl)))
				continue;
			
			Point3d bmStart = bm.ptCenSolid() - bm.vecX() * 0.5 * bm.solidLength();
			Point3d bmEnd = bm.ptCenSolid() + bm.vecX() * 0.5 * bm.solidLength();
			if ((vyEl.dotProduct(ptToolPosition - bmStart) * vyEl.dotProduct(ptToolPosition - bmEnd)) > 0)
				continue;
			
			drillExtremes.append(bm.ptCen() - vxEl * 0.5 * bm.dD(vxEl));
			drillExtremes.append(bm.ptCen() + vxEl * 0.5 * bm.dD(vxEl));
	
			touchingRaftersForThisPosition.append(bm);
								
		}
		drillExtremes = lnElX.orderPoints(drillExtremes);
		if (drillExtremes.length() == 0)
			continue;
		
		Point3d startDrill = ptToolPosition + vxEl * vxEl.dotProduct(drillExtremes[0] - ptToolPosition);
		Point3d endDrill = ptToolPosition + vxEl * vxEl.dotProduct(drillExtremes[drillExtremes.length() - 1] - ptToolPosition);
		ptToolPosition = (startDrill + endDrill)/2;
		
		Drill drill(startDrill - vxEl * U(5), endDrill + vxEl * U(5), 0.5 * dDrillDiameterBeam);
		bmColumn.addTool(drill);
		
		for (int t=0;t<touchingRaftersForThisPosition.length();t++)
			touchingRaftersForThisPosition[t].addTool(drill);
		
		// Apply drill to other beams at this location. Column beam might be split.
		for (int r=0;r<arBmRafter.length();r++) {
			Beam bm = arBmRafter[r];
			if (bm.handle() == bmColumn.handle())
				continue;
			if (abs(vxEl.dotProduct(bm.ptCen() - bmColumn.ptCen())) < U(5))
				bm.addTool(drill);
		}
		
		// Drill sheets
		Point3d sheetDrillPositions[] = {
			startDrill - vxEl * .5 * dDrillDiameterSheet,
			endDrill + vxEl * .5 * dDrillDiameterSheet
		};
		int sides[] = {-1,1};
		for (int k=0;k<sheetDrillPositions.length();k++) {
			Point3d ptDrillSheet = sheetDrillPositions[k] + vxEl * sides[k] * dOffsetSheetDrill;
			ptDrillSheet += vzEl * (vzEl.dotProduct(ptOnTopOfZnToDrill - ptDrillSheet) + U(0.01));
		
			Drill drillSheet(ptDrillSheet, ptDrillSheet - vzEl * dDrillDepth, 0.5 * dDrillDiameterSheet);
			drillSheet.cuttingBody().vis(3);
			drillSheet.addMeToGenBeamsIntersect(arSh);
			
			ElemDrill elemDrillSheet(nZnIndexToDrill, ptDrillSheet, vDrillDirection, dDrillDepth, dDrillDiameterSheet, nToolIndexDrillSheet);
			el.addTool(elemDrillSheet);
		}
		
		Point3d ptLiftingSymbol = ptToolPosition + vzEl * vzEl.dotProduct(el.zone(20).coordSys().ptOrg() - ptToolPosition);
		PLine plSymbol(vzEl);
		plSymbol.createRectangle(
			LineSeg(
				ptLiftingSymbol - vxEl * 0.5 * dWSymbol - vyEl * 0.5 * dHSymbol, 
				ptLiftingSymbol + vxEl * 0.5 * dWSymbol + vyEl * 0.5 * dHSymbol), 
			vxEl, vyEl
		);
		PlaneProfile ppSymbol(plSymbol);
		dpSymbol.draw(ppSymbol);
		dpSymbol.draw(ppSymbol, hatch);
		
		dpSymbol.draw(sDescription, ptLiftingSymbol + vyEl * 0.6 * dHSymbol, vxEl, vyEl, 0, 1);
	}
}




#End
#BeginThumbnail













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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End