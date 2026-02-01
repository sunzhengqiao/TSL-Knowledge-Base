#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
09.05.2017  -  version 1.01
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
/// Show element quantity on element.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="08.07.2016"></version>

/// <history>
/// AS - 1.00 - 08.07.2016 -  Pilot version.
/// v1.01: 09.05.2017 David Rueda (david.rueda@hsbcad.com)	- _Pt0 set to elOrg (for easy debug)
/// </hsitory>

String categories[] = {
	T("|Style|")
};

PropString prefix(1, "", T("|Prefix|"));

PropString dimStyle(0, _DimStyles, T("|Dimension style|"));
dimStyle.setCategory(categories[0]);
PropDouble textSize(0, -(1), T("|Text size|"));
textSize.setCategory(categories[0]);
PropInt textColor(0, -1, T("|Text color|"));
textColor.setCategory(categories[0]);

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

Display display(textColor);
display.dimStyle(dimStyle);
if (textSize > 0)
	display.textHeight(textSize);

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

_Pt0=elOrg;
assignToElementGroup(el, true, 0, 'T');

Point3d textLocation = elOrg;
Vector3d textDirection = elX;
Vector3d textUpDirection = elY;

String text = prefix;
text += el.quantity();
display.draw(text, textLocation, textDirection, textUpDirection, 1, 1);

#End
#BeginThumbnail


#End