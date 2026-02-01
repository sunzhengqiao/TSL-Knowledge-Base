#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
01.02.2019  -  version 2.01



























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 1
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

/// <version  value="2.01" date="01.02.2019"></version>

/// <history>
/// AS - 1.00 - 02.05.2013 -	Pilot version (based on HSB_W-Integrate Timbers)
/// AS - 1.01 - 06.05.2013 -	Pass female filters to satelite. Check distance between timbers
/// AS - 1.02 - 06.05.2013 -	Remove check for on beams below element.
/// AS - 1.03 - 29.05.2013 -	Use top and bottom as alternative to find intersections
/// AS - 1.04 - 04.10.2013 -	Calculate distance to T-Connection from ptCenSolid i.o. ptCen
/// AS - 1.05 - 04.10.2013 -	Ignore head-to-head connections
/// AS - 1.06 - 09.10.2013 -	Extreme points are now extreme points of body on center line of the beam. (body - line intersect)
/// AS - 1.07 - 06.12.2013 -	Set vPn to be one of the beam vectors
/// AS - 1.08 - 15.01.2014 -	Correct counter in for-loop
/// AS - 1.09 - 31.01.2014 -	Change thumbnail
/// AS - 1.10 - 18.06.2014 -	Make property for marking available
/// AS - 1.11 - 24.03.2015 -	Correct vector of plane for intersection between male and female beam.
/// AS - 1.12 - 08.09.2015 -	Add option for an override depth
/// AS - 1.13 - 17.06.2016 -	Add context command to restore the connections
/// AS - 1.14 - 17.06.2016 -	Add option to always integrate male beams with a specific beamcode.
/// AS - 1.15 - 13.09.2016 -	Add option to set additional width for adjacent connections.
/// RP - 1.16 - 03.10.2018 -	Do not look for extra intersectionpoint if vector that is used is perpendicular to vecx om male beam
/// RP - 1.17 - 12.10.2018 -	Previous check not working because of wrong bracket...
/// RP - 2.00 - 07.01.2019 -	Add filtergenbeam catalog for male and female beams
/// RP - 2.01 - 01.02.2019 -	Add option to set the side of the marking
/// </history>

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

int executeMode = 0; // 0 = default, 1 = insert/recalc

Unit (1,"mm");
double dEps = U(0.05);
double vectorTolerance = U(0.01);

String arSYesNo[] = {T("|Yes|"), T("|No|")};
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

/// - Filter -
///
PropString sSeperator01(0, "", T("|Filter male beams|"));
sSeperator01.setReadOnly(true);
PropString sMaleFilterBC(1,"","     "+T("|Filter male beams with beamcode|"));
PropString sMaleFilterLabel(2,"","     "+T("|Filter male beams with label|"));
PropString sMaleFilterMaterial(3,"","     "+T("|Filter male beams with material|"));
PropString sMaleFilterHsbID(4,"","     "+T("|Filter male beams with hsbID|"));
PropString alwaysIntegrate(15, "", "     "+T("|Always integrate beams with beamcode|"));

PropString genBeamFilterDefinitionMale(16, filterDefinitions, T("|Filter definition for male beams|"));
genBeamFilterDefinitionMale.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sSeperator02(5, "", T("|Filter female beams|"));
sSeperator02.setReadOnly(true);
PropString sFemaleFilterBC(6,"","     "+T("|Filter female beams with beamcode|"));
PropString sFemaleFilterLabel(7,"","     "+T("|Filter female beams with label|"));
PropString sFemaleFilterMaterial(8,"","     "+T("|Filter female beams with material|"));
PropString sFemaleFilterHsbID(9,"","     "+T("|Filter female beams with hsbID|"));

PropString genBeamFilterDefinitionFeMale(17, filterDefinitions, T("|Filter definition for female beams|"));
genBeamFilterDefinitionFeMale.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sSeperator03(10, "", T("|Mill|"));
sSeperator03.setReadOnly(true);
PropDouble dDepth(0,U(3),"     "+T("Depth"));
PropDouble dOverrideDepth(5, U(3),"     "+T("|Override depth|"));
PropString sBmCodeOverrideDepth(14, "", "     "+T("|Beamcode for override depth|"));
sBmCodeOverrideDepth.setDescription(T("|Beams with the specified beamcodes are milled with the override depth|"));
PropDouble dMinimumMillWidth(1, U(25), "     "+T("|Minimum mill width|"));
PropDouble dGapWidth(2,U(1), "     "+T("|Gap width|"));
dGapWidth.setDescription(T("|Gap is applied on both sides|"));
PropDouble dGapLength(3,U(200), "     "+T("|Gap length|"));
dGapLength.setDescription(T("|Gap is applied on both sides|"));
PropDouble extraWidthForAdjacentConnections(6, U(0), "     "+T("|Extra width for adjacent connections|"));


PropString sSeparator05(12, "", T("|Marking|"));
sSeparator05.setReadOnly(true);
PropString sApplyMarking(13, arSYesNo, "     "+T("|Apply marking|"));
String arSInsideOutside[] = {T("|Inside|"), T("|Outside|") };
PropString sMarkingSide(18, arSInsideOutside, "     "+T("|Marking side|"));
PropString sSeperator04(11, "", T("|Visualisation|"));
sSeperator02.setReadOnly(true);
PropInt nColor(0, 2, "     "+T("|Color|"));
PropDouble dSymbolSize(4, U(20), "     "+T("|Symbol size|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-IntegrateTimbers");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

String arSTrigger[] = {
	T("|Restore connection|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	PrEntity ssE(T("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = "HSB_E-IntegrateTimbers"; // name of the script
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
	mapTsl.setInt("ExecuteMode", 1);// 1 == recalc
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
		
		TslInst arTsl[] = el.tslInst();
		for( int i=0;i<arTsl.length();i++ ){
			TslInst tsl = arTsl[i];
			if( tsl.scriptName() == strScriptName )
				tsl.dbErase();
		}
	
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
		_Map.removeAt("MasterToSatellite", true);
	}
}

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'E');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

String strScriptName = "HSB_T-IntegrateTimber"; // name of the script that is inserted by this tsl.

if( _kExecuteKey == arSTrigger[0] ) {
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if( tsl.scriptName() == strScriptName )
			tsl.recalcNow(arSTrigger[0]);
	}
	
	eraseInstance();
	return;	
}

if( _Map.hasInt("ExecuteMode") ){
	executeMode = _Map.getInt("ExecuteMode");
	_Map.removeAt("ExecuteMode", true);
}

if( _bOnRecalc || _bOnElementConstructed || _bOnDebug)
	executeMode = 1;

if( executeMode == 1 ){
	int arNExcludeBmType[] = {
		_kDummyBeam
	};
	
	TslInst arTsl[] = el.tslInst();
	for(int i=0;i<arTsl.length();i++){
		TslInst tsl = arTsl[i];
		if( tsl.scriptName() == strScriptName ){
			tsl.dbErase();
		}
	}
	
	Beam arBm[] = el.beam();
	
	Beam arBmMale[0];
	Beam arBmFemale[0];
	
	Beam alwaysIntegrateBeams[0];

	Entity elementGenBeamEntities[] = el.elementGroup().collectEntities(false, (Beam()), _kModelSpace, false);
	
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", sMaleFilterBC);
	filterGenBeamsMap.setString("Label[]", sMaleFilterLabel);
	filterGenBeamsMap.setString("Material[]", sMaleFilterMaterial);
	filterGenBeamsMap.setString("HsbId[]", sMaleFilterHsbID);
	
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionMale, filterGenBeamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for (int index=0;index<filteredGenBeamEntities.length();index++) 
	{ 
		Entity entity = filteredGenBeamEntities[index]; 
		Beam beam = (Beam)entity;
		arBmMale.append(beam);
	}
	
	filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", sFemaleFilterBC);
	filterGenBeamsMap.setString("Label[]", sFemaleFilterLabel);
	filterGenBeamsMap.setString("Material[]", sFemaleFilterMaterial);
	filterGenBeamsMap.setString("HsbId[]", sFemaleFilterHsbID);
	successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionFeMale, filterGenBeamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	filteredGenBeamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for (int index=0;index<filteredGenBeamEntities.length();index++) 
	{ 
		Entity entity = filteredGenBeamEntities[index]; 
		Beam beam = (Beam)entity;
		arBmFemale.append(beam);
	}
	
	Map includeFilterGenbEamsMap;
	includeFilterGenbEamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	includeFilterGenbEamsMap.setString("BeamCode[]", alwaysIntegrate);
	includeFilterGenbEamsMap.setInt("Exclude", false);
	successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", includeFilterGenbEamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	filteredGenBeamEntities = includeFilterGenbEamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for (int index=0;index<filteredGenBeamEntities.length();index++) 
	{ 
		Entity entity = filteredGenBeamEntities[index]; 
		Beam beam = (Beam)entity;
		arBmMale.insertAt(0, beam);
	}
	
	includeFilterGenbEamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	includeFilterGenbEamsMap.setString("BeamCode[]", sBmCodeOverrideDepth);
	successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", includeFilterGenbEamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}

	filteredGenBeamEntities = includeFilterGenbEamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

	for(int i=0;i<arBmMale.length();i++){
		Beam bm = arBmMale[i];
		int alwaysIntegrateBeam = (alwaysIntegrateBeams.find(bm) != -1);
		Body bdBmMale = bm.envelopeBody(true, true);
	
		//Find female beam for T-connection (bmT). 
		Line lnMale(bm.ptCenSolid(), bm.vecX());
		Line lnMaleTop(bm.ptCenSolid() + bm.vecZ() * 0.3 * bm.dD(bm.vecZ()), bm.vecX());
		Line lnMaleBottom(bm.ptCenSolid() - bm.vecZ() * 0.3 * bm.dD(bm.vecZ()), bm.vecX());
		
		int bTopSet = false;
		int bBottomSet = false;
		double dTop;
		double dBottom;
		Beam bmTop;
		Beam bmBottom;
		
		Beam arBmForTConnection[0];
		if (!alwaysIntegrateBeam)
			arBmForTConnection.append(arBmFemale);
		else
			arBmForTConnection.append(arBm);
		
		for(int j=0;j<arBmForTConnection.length();j++){
			Beam bmT = arBmForTConnection[j];
			
			if( bm == bmT )
				continue;			
			if( bmT.vecX().isParallelTo(bm.vecX()) )
				continue;
			
			Line ln = lnMale;
			Body bdBmT = bmT.realBody();
			bdBmT.vis();
			if( bdBmT.intersectPoints(ln).length() < 1 ){
				ln = lnMaleTop;
				if( bdBmT.intersectPoints(ln).length() < 1 ){
					ln = lnMaleBottom;
					if( bdBmT.intersectPoints(ln).length() < 1 ){
						continue;
					}
				}
			}
					
			Vector3d vPn = el.vecZ().crossProduct(bmT.vecX());
			vPn = bmT.vecD(vPn);
			if( vPn.isPerpendicularTo(bm.vecX()) )
				continue;
			vPn.vis(bmT.ptCen(), 1);
			Point3d ptIntersect = ln.intersect(Plane(bmT.ptCenSolid(), vPn), 0);
			ptIntersect.vis(1);
			
			Vector3d vPn2 = bmT.vecX().crossProduct(vPn);
			if( !vPn2.isPerpendicularTo(bm.vecX()) ) {
				vPn2.vis(bmT.ptCen(), 2);
				
				if (abs(bm.vecX().dotProduct(vPn2)) > vectorTolerance)
				{
					Point3d ptIntersect2 = ln.intersect(Plane(bmT.ptCenSolid(), vPn2), 0);
					ptIntersect2.vis(2);
					// Take the intersection point and vector most far away from the center of the male beam
					if (abs(bm.vecX().dotProduct(ptIntersect2 - bm.ptCenSolid())) > abs(bm.vecX().dotProduct(ptIntersect - bm.ptCenSolid()))) {
						vPn = vPn2;
						ptIntersect = ptIntersect2;
					}
				}
			}
			vPn.vis(bmT.ptCen(), 3);
			ptIntersect.vis(3);

			
			Point3d arPtBmTExtremes[] = bdBmT.intersectPoints(Line(bmT.ptCenSolid(), bmT.vecX()));
			if( arPtBmTExtremes.length() == 0 )
				continue;
			Point3d ptBmMax = arPtBmTExtremes[arPtBmTExtremes.length() - 1];//bmT.ptCenSolid() + bmT.vecX() * 0.5 * bmT.solidLength();
			Point3d ptBmMin = arPtBmTExtremes[0];//bmT.ptCenSolid() - bmT.vecX() * 0.5 * bmT.solidLength();
			ptBmMax.vis(4);
			ptBmMax.vis(4);
			
			//Check if intersection point is at the right side and check if it is a valid intersection point
			if( (bmT.vecX().dotProduct(ptIntersect - ptBmMax) * bmT.vecX().dotProduct(ptIntersect - ptBmMin)) < 0 ){
				Point3d arPtBmMaleExtremes[] = bdBmMale.intersectPoints(Line(bm.ptCenSolid(), bm.vecX()));
				if( arPtBmMaleExtremes.length() == 0 )
					continue;
				
				Point3d ptBmMaleMax = arPtBmMaleExtremes[arPtBmMaleExtremes.length() - 1];//bm.ptCenSolid() + bm.vecX() * 0.5 * bm.solidLength();
				Point3d ptBmMaleMin = arPtBmMaleExtremes[0];//bm.ptCenSolid() - bm.vecX() * 0.5 * bm.solidLength();
				
				ptIntersect.vis(1);
				ptBmMaleMax.vis(3);
				ptBmMaleMin.vis(3);
				// If the point is also between the extremes of the male beam, then its probably a head-to-head connection.
				if( (bm.vecX().dotProduct(ptIntersect - ptBmMaleMax) * bm.vecX().dotProduct(ptIntersect - ptBmMaleMin)) < 0 )
					continue;
				
				//Valid point
				double dDist = bm.vecX().dotProduct(ptIntersect - bm.ptCenSolid());
				if( dDist > 0 ){
					//top
					if( !bTopSet ){
						dTop = dDist;
						bmTop = bmT;
						bTopSet = TRUE;
					}
					else{
						if( (dTop - dDist) > dEps ){
							dTop = dDist;
							bmTop = bmT;
						}
					}
				}
				else{
					//bottom
					if( !bBottomSet ){
						dBottom = dDist;
						bmBottom = bmT;
						bBottomSet = TRUE;
					}
					else{
						if( (dDist - dBottom) > dEps ){
							dBottom = dDist;
							bmBottom = bmT;
						}
					}				
				}			
			}
		}

		if( abs(dTop) > (0.5 * bm.solidLength() + 0.75 * bmTop.dD(bm.vecX())) )
			bmTop = Beam();
		if( abs(dBottom) > (0.5 * bm.solidLength() + 0.75 * bmBottom.dD(bm.vecX())) )
			bmBottom = Beam();
		
		Point3d ptTop = bm.ptCenSolid() + bm.vecX() * dTop;ptTop.vis(3);
		Point3d ptBottom = bm.ptCenSolid() + bm.vecX() * dBottom;ptBottom.vis(6);
			
		//-----------------------------------------------------------------------------------------------------------
		//                                                   General tsl settings
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		lstPropDouble.append(dDepth);
		lstPropDouble.append(dMinimumMillWidth);
		lstPropDouble.append(dGapWidth);
		lstPropDouble.append(dGapLength);
		lstPropDouble.append(extraWidthForAdjacentConnections);

		String lstPropString[0];
		lstPropString.append("");
		lstPropString.append(sFemaleFilterBC);
		lstPropString.append(sFemaleFilterLabel);
		lstPropString.append(sFemaleFilterMaterial);
		lstPropString.append(sFemaleFilterHsbID);
		lstPropString.append("");
		lstPropString.append("");
		lstPropString.append(sApplyMarking);
		lstPropString.append("");
		lstPropString.append(sMarkingSide);
		//-----------------------------------------------------------------------------------------------------------
		//                                                  	Cut at top of beam
		if( bmTop.bIsValid() ){		
			lstBeams.append(bm);
			lstBeams.append(bmTop);
			
			if (filteredGenBeamEntities.find(bmTop) != -1)
				lstPropDouble[0] = dOverrideDepth;
		
			vecUcsX = bm.vecX();
			vecUcsY = el.vecZ().crossProduct(vecUcsX);
				
			TslInst tslCutTop;
			tslCutTop.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, 
									lstPropInt, lstPropDouble, lstPropString ); // create new instance
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                               Cut at bottom of beam
		lstPropDouble[0] = dDepth;
		if( bmBottom.bIsValid() ){
			lstBeams.setLength(0);
			lstBeams.append(bm);
			lstBeams.append(bmBottom);
			
			if (filteredGenBeamEntities.find(bmBottom) != -1)
				lstPropDouble[0] = dOverrideDepth;
				
			vecUcsX = -bm.vecX();
			vecUcsY = el.vecZ().crossProduct(vecUcsX);
			
			TslInst tslCutBottom;
			tslCutBottom.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, 
								lstPropInt, lstPropDouble, lstPropString ); // create new instance
		}
	}
}

// visualisation
Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, 0, 'I');

Point3d ptSymbol01 = _Pt0 - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = vxEl + vyEl;
vxTxt.normalize();
Vector3d vyTxt = vzEl.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);	
	dpVisualisationPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = vxEl - vzEl;
	vxTxt.normalize();
	Vector3d vyTxt = vyEl.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
}

executeMode = 0; // 0 = default, 1 = insert/recalc, 2 = find closest lifting beam


















#End
#BeginThumbnail
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
E9_'!Q^F:>EW!(X02!9#T1QM8_@>:EIKHDB%)$5U/4,,@T`?_V<1_
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