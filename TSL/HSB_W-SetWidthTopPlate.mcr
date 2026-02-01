#Version 8
#BeginDescription

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
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="05.12.2017"></version>

/// <history>
/// AS - 1.00 - 05.12.2017 -	Pilot version
/// </history>


double vectorTolerance = Unit(0.01, "mm");

PropDouble newWidth(0, U(19), T("|New beam width|"));
newWidth.setDescription(T("|Sets the new width.|"));

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
			
			TslInst connectedTsls[] = selectedElement.tslInst();
			for( int t=0;t<connectedTsls.length();t++ ){
				TslInst tsl = connectedTsls[t];
				if( tsl.scriptName() == scriptName() )
					tsl.dbErase();
			}
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|Invalid or no element selected.|"));
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


if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();
_Pt0 = elOrg;

assignToElementGroup(el, true, 0, 'T');

if (_bOnElementConstructed || manualInserted)
{
	Beam beams[] = el.beam();
	Beam possibleBeamsToChange[0];
	
	for (int b = 0; b < beams.length(); b++)
	{
		Beam bm = beams[b];
		
		if (abs(elY.dotProduct(bm.vecX())) > vectorTolerance) continue;
		
		possibleBeamsToChange.append(bm);
	}
	
	for (int s1 = 1; s1 < possibleBeamsToChange.length(); s1++)
	{
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--)
		{
			if (elY.dotProduct(possibleBeamsToChange[s11].ptCen() - possibleBeamsToChange[s2].ptCen()) < 0)
			{
				possibleBeamsToChange.swap(s2, s11);
				s11 = s2;
			}
		}
	}
	
	if (possibleBeamsToChange.length() > 0 )
	{
		Beam beamToChange = possibleBeamsToChange[possibleBeamsToChange.length() - 1];
		double oldWidth = beamToChange.dD(elY);
		
		beamToChange.setD(beamToChange.vecD(elY), newWidth);
		beamToChange.transformBy(-elY * 0.5 * (oldWidth - newWidth));
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail

#End