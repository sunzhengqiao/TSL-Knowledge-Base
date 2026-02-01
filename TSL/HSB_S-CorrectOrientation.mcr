#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
04.05.2016  -  version 1.00

This tsl rotates the x-axis of the sips 90 degrees, if the width is greater than the length.
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
/// Changes the x-axis of the sips if the width is greater than the length.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// -
/// </remark>

/// <version  value="1.00" date="04.05.2016"></version>

/// <history>
/// AS - 1.00 - 04.05.2016	- Pilot version
/// </history>

Unit (1,"mm");

_ThisInst.setSequenceNumber(-1000);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_S-CorrectOrientation");
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
	
	Sip sips[] = el.sip();
	for (int s=0;s<sips.length();s++) {
		Sip sip = sips[s];
		
		double sipW = sip.dW();
		double sipL = sip.dL();
		
		if (sipW > sipL)
			sip.setXAxisDirectionInXYPlane(sip.vecY());
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail

#End