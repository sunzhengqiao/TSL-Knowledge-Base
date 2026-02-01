#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
14.07.2016  -  version 1.00

This tsl creates insulation objects in the frame.


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
/// 
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="14.07.2016"></version>

/// <history>
/// AS - 1.00 - 14.07.2016 -	First revision
/// </history>

double dEps = Unit(0.1,"mm");


PropInt sequenceNumber(0, 0, T("|Sequence number|"));
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));

int zoneIndexes[] = {1,2,3,4,5,6,7,8,9,10};
PropInt propZnIndex(1, zoneIndexes, T("|Zone index|"));
PropInt propSheetColor(2, -1, T("|Sheet color|"));
PropString sheetMaterial(0, "", T("|Sheet material|"));

PropDouble gap(0, 1, T("|Gap|"));
gap.setDescription(T("|The gap with other sheets in this zone|"));


// Set properties if inserted with an execute key
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

int sheetColor = propSheetColor;
int znIndex = propZnIndex;
if (znIndex > 5)
	znIndex = 5 - znIndex;

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

// Set the sequence number
_ThisInst.setSequenceNumber(sequenceNumber);

if( _bOnDebug || _bOnElementConstructed || manualInserted ){
	Element el = _Element[0];
	
	String scriptNamesToErase[] = {
		scriptName()
	};
	
	TslInst existingTsls[] = el.tslInst();
	for (int t=0;t<existingTsls.length();t++) {
		TslInst tsl = existingTsls[t];
		if (scriptNamesToErase.find(tsl.scriptName()) == -1)
			continue;
		
		if (tsl.handle() == _ThisInst.handle())
			continue;
		
		tsl.dbErase();
	}

	CoordSys csEl= el.coordSys();
	Point3d elOrg = csEl.ptOrg();
	Vector3d elX = csEl.vecX();
	Vector3d elY = csEl.vecY();
	Vector3d elZ = csEl.vecZ();
	_Pt0 = elOrg;
	
	String validSplitMaterials[] = {
		"OSB-KLEMLEKT",
		"OSB KLEMLEKT",
		"OSB_KLEMLEKT",
		"OSB"
	};

	Sheet sheetsFromZone[] = el.sheet(znIndex);
	
	PlaneProfile zoneProfile(el.coordSys());
	Sheet sheetsToSplit[0];
	for (int s=0;s<sheetsFromZone.length();s++) {
		Sheet sh = sheetsFromZone[s];
		
		if (validSplitMaterials.find(sh.material().makeUpper()) != -1) {
			sheetsToSplit.append(sh);
		}
		else {
			PlaneProfile sheetProfile(el.coordSys());
			sheetProfile.unionWith(sh.profShape());
			sheetProfile.shrink(-U(5));
			
			zoneProfile.unionWith(sheetProfile);
		}
	}
	zoneProfile.shrink(U(5));
	zoneProfile.shrink(-gap);
	zoneProfile.vis();

	for (int k=0;k<sheetsToSplit.length();k++) {
		Sheet sheetToSplit = sheetsToSplit[k];
		double thickness = sheetToSplit.dD(elZ);
		
		PlaneProfile sheetProfile = sheetToSplit.profShape();

		sheetProfile.subtractProfile(zoneProfile);
		sheetProfile.vis(5);
		
		if (sheetColor == -1)
			sheetColor = sheetToSplit.color();
		
		PLine newSheetRings[] = sheetProfile.allRings();
		for (int r=0;r<newSheetRings.length();r++) {
			PLine newSheetRing = newSheetRings[r];
			Sheet newSheet;
			PlaneProfile newSheetProfile(el.zone(znIndex).coordSys());
			newSheetProfile.joinRing(newSheetRing, _kAdd);
			
			newSheet.dbCreate(newSheetProfile, thickness, 1);
			newSheet.assignToElementGroup(el, true, znIndex, 'Z');
			newSheet.setColor(sheetColor);
			newSheet.setMaterial(sheetMaterial);
		}
		
		sheetToSplit.dbErase();
	}	
	
	eraseInstance();
	return;
}










#End
#BeginThumbnail


















#End