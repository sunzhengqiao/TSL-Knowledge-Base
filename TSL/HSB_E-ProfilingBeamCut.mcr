#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
22.03.2017  -  version 1.01
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a beamcut to a set of beams over the full length
/// </summary>

/// <insert>
/// Select a set of beams
/// </insert>

/// <remark Lang=en>
/// This tsl requires a filter created with the HSB_G-FilterGenBeams tsl.
/// </remark>

/// <version  value="1.01" date="22.03.2017"></version>

/// <history>
/// YB - 1.00 - 21.03.2017 -	First revision.
/// AS - 1.01 - 22.03.2017 -	Add sizes as properties. Place origin of beamcut inside beam.
/// </history>

double vectorTolerance = U(0.01, "mm");
double beamCutExtentOutsideBeam = U(1);

String categories[] = 
{
	T("|Position|"),
	T("|Size|")
};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString filterDefinition(0, filterDefinitions, T("|Filter definition beams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

// Sides used to give the vectors the right directions.
int sides[] = {1, -1};
String frontBackOptions[] = {T("|Front|"), T("|Back|")};
PropString frontBackProp(2, frontBackOptions, T("Milling side"), 1);
frontBackProp.setDescription(T("|Specifies whether the milling is applied to the front or the back of the element.|") + 
							 TN("|Front| : ") + T("|Zone 1 to 5|") + 
							 TN("|Back| : ") + T("|Zone 6 to 10|"));
frontBackProp.setCategory(categories[0]);

String insideOutsideOptions[] = { "Outside", "Inside"};
PropString insideOutsideProp(3, insideOutsideOptions, T("|Side relative to element center|"));
insideOutsideProp.setDescription(T("|Specifies whether the tool is applied to the inside or outside of the selected beams.|") +
								 TN("|Inside and outside is reletive to the element center.|"));
insideOutsideProp.setCategory(categories[0]);

PropDouble beamCutY(0, U(10), T("|Width beam cut|"));
beamCutY.setDescription(T("|Sets the width of the beam cut.|"));
beamCutY.setCategory(categories[1]);

PropDouble beamCutZ(1, U(10), T("|Depth beam cut|"));
beamCutZ.setDescription(T("|Sets the depth of the beam cut.|"));
beamCutZ.setCategory(categories[1]);

String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
 	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	 if (insertCycleCount() > 1) {
 	 	eraseInstance();
 		return;
	 }
 
 	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
 	 	showDialog();
	 setCatalogFromPropValues(T("_LastInserted"));
 
 	Element  selectedElements[0];
	 PrEntity ssE(T("|Select elements|"), Element());
	 if (ssE.go())
  		selectedElements.append(ssE.elementSet());
 
 	String strScriptName = scriptName();
 	Vector3d vecUcsX(1,0,0);
 	Vector3d vecUcsY(0,1,0);
 	Beam lstBeams[0];
 	Entity lstEntities[1];
 
 	Point3d lstPoints[0];
 	int lstPropInt[0];
 	double lstPropDouble[0];
 	String lstPropString[0];
	 Map mapTsl;
	 mapTsl.setInt("ManualInserted", true);

 	for (int e=0;e<selectedElements.length();e++) {
  		Element selectedElement = selectedElements[e];
 		 if (!selectedElement.bIsValid())
  			 continue;
  
 		 lstEntities[0] = selectedElement;
  
  		TslInst tslNew;
		  tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
 	}
 
 	eraseInstance();
	 return;
}

if( _Element.length() != 1 ){
 	reportWarning(TN("|No element selected!|"));
 	eraseInstance();
 	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	 manualInserted = _Map.getInt("ManualInserted");
}

// set properties from catalog
if (_bOnDbCreated && manualInserted) 
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
	
	// Resolve properties.
	int frontBack = sides[frontBackOptions.find(frontBackProp, 1)];
	int insideOutside = sides[insideOutsideOptions.find(insideOutsideProp, 0)];
	
	// Get the selected element and set _Pt0
	Element el = (Element)_Entity[0];
	_Pt0 = el.ptOrg();
	
	// Get all beams from the element
	Beam beams[] = el.beam();
	
	// Add all beams to an entity array
	Entity beamEntities[0];
	for (int b=0;b<beams.length();b++)
		beamEntities.append(beams[b]);
	
	// Filter the beams
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
	if (!successfullyFiltered) {
		reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	// Get back the filtered beams
	beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	
	CoordSys csEl = el.coordSys();
	Vector3d elX = el.vecX();
	Vector3d elY = el.vecY();
	Vector3d elZ = el.vecZ();
	
	// Get the mid point of the element
	LineSeg elMinMax = el.segmentMinMax();
	Point3d elMidPoint = elMinMax.ptMid();
	elMidPoint.vis();
	
	for(int b = 0; b < beamEntities.length(); b++)
	{
		// Get the beam, and create a plane profile of zone 0
		Beam bm = (Beam)beamEntities[b];
		if (!bm.bIsValid())
			continue;
		
		PlaneProfile pp = el.profBrutto(0);
		
		// Create the beam vectors
		Vector3d bmX = bm.vecX();
		Vector3d bmZ = elZ;
		Vector3d bmY = elZ.crossProduct(bmX);
		
		bmX.vis(bm.ptCen(), 1);
		bmY.vis(bm.ptCen(), 3);
		bmZ.vis(bm.ptCen(), 150);
		// Set a point in or outside of the plane
		Point3d directionCheck = bm.ptCen() + bmY * U(100);
		
		// Check wether the point is inside or outisde of the plane, if it is inside, rotate the UCS
		if(pp.pointInProfile(directionCheck) == _kPointInProfile)
		{
			bmX *= -1;
			bmY *= -1;
		}
		
		double beamCutLength = bm.solidLength() + 2 * beamCutExtentOutsideBeam;
		
		Point3d cutOrg = bm.ptCenSolid() + bmY * insideOutside * (0.5 * bm.dD(bmY) - beamCutY) + bmZ * frontBack * (0.5 * bm.dD(bmZ) - beamCutZ);
		cutOrg.vis();
		
		BeamCut beamCut(cutOrg, bmX, bmY, bmZ, beamCutLength, 2 * beamCutY, 2 * beamCutZ, 0, insideOutside, frontBack);
		bm.addToolStatic(beamCut);
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail


#End