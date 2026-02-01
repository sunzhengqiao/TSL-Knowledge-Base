#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
31.08.2016  -  version 1.00

This tsl converts beams into dummy beams.
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
/// This tsl converts beams into dummy beams
/// </summary>

/// <insert>
/// Select a set of elements. The tsl can also be attached to the element definition.
/// </insert>

/// <remark Lang=en>
/// Uses HSB_G-FilterGenBeams to retrieve the list of filtered beams.
/// </remark>

/// <version  value="1.00" date="31.08.2016"></version>

/// <history>
/// AS - 1.00 - 31.08.2016 - First revision
/// </history>

String categories[] = {
	T("|Beam filter|"),
	T("|Generation|")
};

PropInt sequenceForGeneration(0, 0, T("|Sequence number|"));
sequenceForGeneration.setDescription(T("|The sequence number is used to sort the list of tsls during the generation of the element.|"));
sequenceForGeneration.setCategory(categories[1]);
// Set the sequence for execution on generate construction.
_ThisInst.setSequenceNumber(sequenceForGeneration);

PropString beamCodesToConvert(0, "DUMMY*", T("|Beam codes to convert|"));
beamCodesToConvert.setDescription(T("|Sets the beam codes of the beams to convert.|"));
beamCodesToConvert.setCategory(categories[0]);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssElements(T("|Select elements|"), Element());
	if (ssElements.go()) {
		Element selectedElements[] = ssElements.elementSet();
		
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

if (_bOnElementConstructed || manualInserted) {
	Element el = _Element[0];
	
	Entity beamEntities[0];
	Beam beams[] = el.beam();
	for (int b=0;b<beams.length();b++)
		beamEntities.append(beams[b]);
	
	Entity entitiesToConvert[0];
	
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", beamCodesToConvert);
	filterGenBeamsMap.setInt("Exclude", false);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	entitiesToConvert.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
	
	for (int b=0;b<entitiesToConvert.length();b++) {
		Beam bm = (Beam)entitiesToConvert[b];
		if (!bm.bIsValid())
			continue;
		
		bm.setBIsDummy(true);
	}
	
	eraseInstance();
	return;
}


#End
#BeginThumbnail

#End