#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
03.11.2017  -  version 1.02
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl converts compound cuts into single cuts
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.02" date="03.11.2017"></version>

/// <history>
/// AS - 1.00 - 17.09.2015 	- Pilot version
/// AS - 1.01 - 31.07.2017 	- Update logo
/// RP - 1.02 - 03.11.2017 	- Add BeamCodeFilter
/// </history>

double dEps = Unit(0.01, "mm");

String categories[] = 
{
	T("|Filters|")
};

int hasProperties = true;
String excludeOrInclude[] = {T("|Exclude|"), T("|Include|")};
PropString excludeString(0, excludeOrInclude, T("|Filter mode|"));
excludeString.setCategory(categories[0]);
excludeString.setDescription(T("|Specify wheter you want to include or exclude the beams matching the filtercriteria|"));
PropString sFilterBC(1,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(categories[0]);
sFilterBC.setDescription(T("|Specify which beams and sheets you want to filter by specifying a beamcode or a list of beamcodes with semicolon as delimeter|"));
// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_E-CompoundToSingleCut");
if( _kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if (hasProperties && (_kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1))
		showDialog();
	setCatalogFromPropValues(T("_LastInserted"));
	
	Element selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if( ssE.go() )
		selectedElements.append(ssE.elementSet());
		
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	for (int e=0;e<selectedElements.length();e++) {
		Element selectedElement = selectedElements[e];
		lstElements[0] = selectedElement;
		
		// There can only be one of these tsl's attached to the element.
		TslInst arTsl[] = selectedElement.tslInst();
		for( int i=0;i<arTsl.length();i++ ){
			TslInst tsl = arTsl[i];
			if( tsl.scriptName() == strScriptName ){
				tsl.dbErase();
			}
		}
		
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

Element el = _Element[0];
_Pt0 = el.ptOrg();

// Assign tsl to the default element layer.
assignToElementGroup(el, true, 0, 'E');

int exclude = false;
if (excludeString == T("|Exclude|"))
	exclude = true;
	
if (manualInserted || _bOnElementConstructed) 
{
	// Rp filter based on beamcode
	Entity beamEntities[0];
	Beam beams[] = el.beam();
	for (int index=0;index<beams.length();index++) 
	{ 
		Entity beamEntity = beams[index]; 
		beamEntities.append(beamEntity);
	}
	
	Entity filteredEntitiesBeamCode[0];

	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntitiesBeamCode.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
	
	for (int b=0;b<filteredEntitiesBeamCode.length();b++) {
		Beam bm = (Beam)filteredEntitiesBeamCode[b];
		
		Vector3d vyBm = bm.vecY();
		Vector3d vzBm = bm.vecZ();	
		if (bm.dD(vyBm) > bm.dD(vzBm)) {
			vyBm = bm.vecZ();
			vzBm = bm.vecY();
		}
		
		AnalysedTool tools[] = bm.analysedTools(2);
		AnalysedCut compoundCuts[] = AnalysedCut().filterToolsOfToolType(tools, _kACCompound);
		
		for (int c=0;c<compoundCuts.length();c++) {
			AnalysedCut compoundCut = compoundCuts[c];
			
			int side = 1;
			if (bm.vecX().dotProduct(compoundCut.normal()) < 0)
				side *= -1;
			
			Point3d bodyPointsInPlane[] = compoundCut.bodyPointsInPlane();
	
			Line lineTowardsCut(bm.ptCen(), bm.vecX() * side);
			
			bodyPointsInPlane = lineTowardsCut.orderPoints(bodyPointsInPlane);			
			if (bodyPointsInPlane.length() == 0)
				continue;
			
			Point3d originSimpleAngledCut = bodyPointsInPlane[0];
			originSimpleAngledCut.vis(3);
			
			Vector3d normalSimpleAngledCut = compoundCut.normal() - vyBm * vyBm.dotProduct(compoundCut.normal());
			normalSimpleAngledCut.normalize();
			
			bm.addToolStatic(Cut(originSimpleAngledCut, normalSimpleAngledCut), _kStretchNot);
		}
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail
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
*Z?+8\E46I7/_V:%%
`


#End