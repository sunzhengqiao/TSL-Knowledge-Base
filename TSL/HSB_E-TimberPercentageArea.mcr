#Version 8
#BeginDescription
 This tsl visualizes the outline of zone 0 and calculates the volume of the timbers as a percentage of the total volume
Percentage is added through MapX on the element 
@(ExtendedProperties.TimberPercentage.TimberPercentage)
@(ExtendedProperties.TimberPercentage.TimberPercentageArea)
@(ExtendedProperties.TimberPercentage.TimberPercentageAreaBrutto)
@(ExtendedProperties.TimberPercentage.TimberPercentageAreaWood)
@(ExtendedProperties.TimberPercentage.Name)


#Versions
4.0 15/07/2025 First version Author: Robert Pol



































#End
#Type O
#NumBeamsReq 2
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 0
#KeyWords 
#BeginContents

/// <summary Lang=en>
/// This tsl visualizes the outline of zone 0 and calculates the volume of the timbers as a percentage of the total volume
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>
// #Versions
//4.0 15/07/2025 First version Author: Robert Pol

U(1,"mm");	
double areaTolerance =U(1);
double pointTolerance =U(.1);
double vectorTolerance = U(.01);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String executeKey = "ManualInsert";
String sDisabled = T("<|Disabled|>");

// some default painter definitions are expected. If not existant they will be created automatically
String sPainters[] = PainterDefinition().getAllEntryNames();
sPainters = sPainters.sorted();
sPainters.insertAt(0, sDisabled);
//End Painters//endregion 

category = T("|Filter|");
String sPainterName=T("|Beam Painter Filter|");	
PropString sPainter(nStringIndex++,sPainters, sPainterName);	
sPainter.setDescription(T("|Defines the Painter definition to filter beams|"));
sPainter.setCategory(category);	

String sProfileName=T("|Profile name|");	
PropString sProfile(nStringIndex++,T("|PLINE|"), sProfileName);	
sProfile.setDescription(T("|Specify the name of the profile to be used,|"));
sProfile.setCategory(category);	

category = T("|Style|");
String sDimensionStyleName=T("|Dimension Style|");	
PropString sDimensionStyle(nStringIndex++, _DimStyles, sDimensionStyleName);	
sDimensionStyle.setDescription(T("|Defines the dimstyle for the text of the percentage|"));
sDimensionStyle.setCategory(category);	

String sShowPlaneProfileName =T("|Show Profile|");	
PropString sShowPlaneProfile(nStringIndex++, sNoYes, sShowPlaneProfileName);	
sShowPlaneProfile.setDescription(T("|Defines whether to show or hide the profile for the calculation|"));
sShowPlaneProfile.setCategory(category);	

String sPLineColorName =T("|Pline color|");	
PropInt iColor(nIntIndex++, -1, sPLineColorName);
iColor.setCategory(category);

String arSZoneLayer[] = {
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char arChZoneCharacter[] = {
	'T',
	'I',
	'Z',
	'E'
};

String sTextLayerName =T("|Text Layer|");	
PropString sTextLayer(nStringIndex++, arSZoneLayer, sTextLayerName);
sTextLayer.setCategory(category);

String sBodyLayerName =T("|Body Layer|");	
PropString sBodyLayer(nStringIndex++, arSZoneLayer, sBodyLayerName);
sBodyLayer.setCategory(category);

category = T("|Hatch|");

String sShowHatchName =T("|Show Hatch|");	
PropString sShowHatch(nStringIndex++, sNoYes, sShowHatchName);	
sShowHatch.setDescription(T("|Defines whether to show or hide the hatch of the profile for the calculation|"));
sShowHatch.setCategory(category);	

PropString hatchPattern(nStringIndex++, _HatchPatterns, T("|Hatch|"));
hatchPattern.setCategory(category);
hatchPattern.setDescription(T("|Set the hatch pattern|"));

PropDouble patternScale(nDoubleIndex++, U(1), T("|Hatch scale|"));
patternScale.setCategory(category);
patternScale.setDescription(T("|Set the hatch scale|"));

PropInt hatchColor(nIntIndex++, -1, T("|Hatch Color|"));
hatchColor.setCategory(category);
hatchColor.setDescription(T("|Set the color of the hatch|"));

PropInt hatchZone (nIntIndex++, 0, T("|Show hatch in zone|"), 8);
hatchZone.setCategory(category);
hatchZone.setDescription(T("|Set the zone for the hatch to show|"));

category = T("|Dimensions|");

String sProfileDepth=T("|Profile depth|");	
PropDouble dDepth(nDoubleIndex++, - U(1), sProfileDepth);	
dDepth.setDescription(T("|Specify the depth of the profiles, if empty or smaller then 0, the center of the element will be used|"));
dDepth.setCategory(category);	

//category = T("|Name|");
//
//String sOverrideZone0Name =T("|Override Name Zone 0|");	
//PropString sOverrideZone0(nStringIndex++, "", sOverrideZone0Name);
//sOverrideZone0.setCategory(category);

Map GetNewProfileMap()
{
	Map profileMap;
	PrEntity ssP(T("|Select pline(s)|"), EntPLine());
	if (ssP.go())
	{
		Entity plineEnts[] = ssP.set();
		for (int ep = 0; ep < plineEnts.length(); ep++)
		{
			Entity plineEntity = plineEnts[ep];
			PLine pline = plineEntity.getPLine();
			Map mapRing;
			mapRing.setPLine("Ring", pline);
			mapRing.setInt("IsOpening", false);
			profileMap.appendMap("Ring", mapRing);
		}
	}
	
	return profileMap;
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

//region mapIO: support property dialog input via map on element creation
int bHasPropertyMap = _Map.hasMap("PROPSTRING[]");
if (_bOnMapIO)
{ 
	if (bHasPropertyMap)
		setPropValuesFromMap(_Map);	
	showDialog();
	_Map = mapWithPropValues();
	return;
}
if (_bOnElementDeleted)
{
	// HSB-17068
	eraseInstance();
	return;
}
else if (_bOnElementConstructed && bHasPropertyMap)
{ 
	setPropValuesFromMap(_Map);
	_Map = Map();
}	
	
//End mapIO: support property dialog input via map on element creation//endregion 

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	_Element.append(getElement());
	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _Element[e].vecX();
		Vector3d vecYTsl= _Element[e].vecY();
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		TslInst arTsl[] = _Element[e].tslInst();
		for ( int j = 0; j < arTsl.length(); j++)
		{
			TslInst tsl = arTsl[j];
			if ( ! tsl.bIsValid() || (tsl.scriptName() == scriptName() && tsl.propString(sProfileName) == sProfile))
			{
				tsl.recalcNow(T("|Delete|"));
			}
		}
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		Map planeProfileMap;

		mapTsl.setMap("PlaneProfile", GetNewProfileMap());
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
				
	eraseInstance();		
	return;
}	
// end on insert	__________________

for (int m=0;m<_Map.length();m++)
{
	if (_Map.keyAt(m) != "DimInfo") continue;
	_Map.removeAt(m, true);
	m--;
}
// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

Element element = _Element[0];
CoordSys cs = element.coordSys();
Wall wall = (Wall)element;
if (wall.bIsValid())
{
	cs = wall.coordSysHsb();
}
ElementRoof elementRoof = (ElementRoof)element;
if (elementRoof.bIsValid())
{
	cs = elementRoof.coordSysHsb();
}

Vector3d vecX = element.vecX();
Vector3d vecY = element.vecY();
Vector3d vecZ = element.vecZ();
Point3d ptOrg = element.ptOrg();
assignToElementGroup(element,false, 0,'E');

double elementHeight = element.dBeamWidth();
Beam allBeams[] = element.beam();
Entity allBeamEntities[0];
for (int index = 0; index < allBeams.length(); index++)
{
	Beam beam = allBeams[index];
	allBeamEntities.append(beam);
}

PainterDefinition pd(sPainter);
if (pd.bIsValid())
{
	allBeamEntities = pd.filterAcceptedEntities(allBeamEntities);
}

_ThisInst.setAllowGripAtPt0(false);
	
Map profileMap = _Map.getMap("PlaneProfile");

if (_bOnDbCreated)
{
	String name = profileMap.getString("Name");
	if (name.length() > 0)
	{
		sProfile.set(name);
	}
	
	double depth = profileMap.getDouble("Depth");
	if (depth > 0)
	{
		dDepth.set(depth);
	}
}

Map map = element.subMapX("ExtendedProperties", cs)	;

String previousProfileName = _Map.getString(sProfileName);
int removePreviousProfileName = false;
if (_kNameLastChangedProp == sProfileName)
{
	removePreviousProfileName = true;
}

_Map.setString(sProfileName, sProfile);

for(int p; p<map.length(); p++)
{
	String testIfTimberPercentage = map.keyAt(p);
	if (testIfTimberPercentage.makeUpper() != "TIMBERPERCENTAGE") continue;
	Map timberPercentageMap = map.getMap(p);
	String pLineName = timberPercentageMap.getString("Name");
	if (pLineName != sProfile) continue;
	map.removeAt(p, true);
	break;
}

if (removePreviousProfileName)
{
	for (int p; p < map.length(); p++)
	{
		String testIfTimberPercentage = map.keyAt(p);
		if (testIfTimberPercentage.makeUpper() != "TIMBERPERCENTAGE") continue;
		Map timberPercentageMap = map.getMap(p);
		String pLineName = timberPercentageMap.getString("Name");
		if (pLineName != previousProfileName) continue;
		map.removeAt(p, true);
		break;
	}
}

if (map.length() > 0)
{
	element.setSubMapX("ExtendedProperties", map, cs);
}
else
{
	element.removeSubMapX("ExtendedProperties");
}

addRecalcTrigger(_kContext, T("|Delete|") );
if (_kExecuteKey == T("|Delete|"))
{
	eraseInstance();
	return;
}

Map extendedPropertiesMap = element.subMapX("ExtendedProperties", cs);

addRecalcTrigger(_kContext, T("|Reset PLine|") );
if (_kExecuteKey == T("|Reset PLine|"))
{
	_Map.setMap("PlaneProfile", GetNewProfileMap());
}

addRecalcTrigger(_kContext, T("|Subtract PLine|") );
if (_kExecuteKey == T("|Subtract PLine|"))
{
	
	PrEntity ssP(T("|Select pline(s) to subtract|"), EntPLine());
	if (ssP.go())
	{	
		Entity plineEnts[] = ssP.set();
		for (int ep = 0; ep < plineEnts.length(); ep++)
		{
			Map mapRing;
			
			Entity plineEntity = plineEnts[ep];
			PLine pline = plineEntity.getPLine();
			mapRing.setPLine("Ring", pline);
			mapRing.setInt("IsOpening", true);
			Point3d gripPoints[] = pline.vertexPoints(true);
			
			for (int i = 0; i < gripPoints.length(); i++)
			{
				Point3d gripPoint = gripPoints[i];
				Grip grip(gripPoint);
				grip.setShapeType(_kGSTSquare);
				grip.setIsRelativeToEcs(false);
				grip.setVecX(vecX);
				grip.setVecY(vecY);
				grip.setName(profileMap.length());
				_Grip.append(grip);
			}
			profileMap.appendMap("Ring", mapRing);
		}
		
		_Map.setMap("PlaneProfile", profileMap);
		
	}
}

Display displayBeamProfile(iColor);		 	
displayBeamProfile.elemZone(element, 0, arChZoneCharacter[arSZoneLayer.find(sBodyLayer, 0)]);

Display hatchDisplay(hatchColor);
hatchDisplay.elemZone(element, hatchZone, 'I'); 

// create plane on center of beams
Point3d beamPoints[0];
for (int index = 0; index < allBeamEntities.length(); index++)
{
	Beam beam = (Beam)allBeamEntities[index];
	Body beamBody = beam.realBody();
	beamPoints.append(beam.realBody().allVertices());
}

beamPoints = Line(ptOrg, vecZ).orderPoints(beamPoints);
Point3d elementCenter = element.zone(-1).coordSys().ptOrg() + vecZ * 0.5 * element.dBeamWidth();

if (beamPoints.length() < 2) 
{
	reportMessage(TN("|No beam points found|"));
	return;
}

Map dimInfoMap;

PlaneProfile elementOutline(CoordSys(elementCenter, vecX, vecY, vecZ ));
PlaneProfile elementOutlineBruto(CoordSys(elementCenter, vecX, vecY, vecZ ));

Plane plane(elementCenter, vecZ);

dimInfoMap.setString("SubType", sProfile);
addRecalcTrigger(_kContext, T("|Reset Grips|"));
if (_bOnDbCreated || _kExecuteKey == T("|Reset Grips|"))
{
	_Grip.setLength(0);
	for (int index = 0; index < profileMap.length(); index++)
	{
		Map map = profileMap.getMap(index);
		PLine ring = map.getPLine("Ring");
		
		if ( ring.area() < areaTolerance) continue;
		
		int isOpening = map.getInt("IsOpening");
		//		ring.vis(4);
		elementOutline.joinRing(ring, isOpening);
		
		Point3d gripPoints[] = ring.vertexPoints(true);
		
		for (int i = 0; i < gripPoints.length(); i++)
		{
			Point3d gripPoint = gripPoints[i];
			Grip grip(gripPoint);
			grip.setShapeType(_kGSTSquare);
			grip.setIsRelativeToEcs(false);
			grip.setVecX(vecX);
			grip.setVecY(vecY);
			grip.setName(index);
			_Grip.append(grip);
		}
	}
}

Point3d centerPoint;
if (dDepth > pointTolerance)
{
	 centerPoint = beamPoints[0] + vecZ * dDepth;
}
else
{
	centerPoint = (beamPoints[0] + beamPoints[beamPoints.length() - 1]) / 2;
}

for (int index = 0; index < profileMap.length(); index++)
{
	Map map = profileMap.getMap(index);
	PLine ring(vecZ);
	for (int i=0;i<_Grip.length();i++)
	{
		Grip grip = _Grip[i];
		String test = grip.name();
		if (grip.name() != (String)index) continue;
		
		Point3d locationGrip = grip.ptLoc();
		locationGrip += vecZ * vecZ.dotProduct(centerPoint - locationGrip);
		ring.addVertex(locationGrip);
	}
	
	ring.close();
	ring.vis();
	if ( ring.area() < areaTolerance) continue;
	
	int isOpening = map.getInt("IsOpening");
	//		ring.vis(4);
	elementOutline.joinRing(ring, isOpening);
	elementOutline.vis(index);
	if ( ! isOpening)
	{
		elementOutlineBruto.joinRing(ring, isOpening);
	}
}
elementOutline.vis(3);
double elementArea = elementOutline.area();
if (elementArea < areaTolerance)
{
	reportMessage(TN("|Not a valid area|"));
	return;
}
 
centerPoint.vis();
elementOutline.vis();
elementOutline.transformBy(vecZ * vecZ.dotProduct(centerPoint - elementCenter));
dimInfoMap.setPoint3dArray("Points", elementOutline.getGripVertexPoints());
plane.transformBy(vecZ * vecZ.dotProduct(centerPoint - elementCenter));
plane.vis();
hatchDisplay.draw(elementOutline);

Beam intersectingBeams[0];
for (int index = 0; index < allBeamEntities.length(); index++)
{
	Beam beam = (Beam)allBeamEntities[index];
	Body beamBody = beam.realBody();
	//PlaneProfile beamProfile = beamBody.shadowProfile(plane); //HSB-17068
	PlaneProfile beamProfile = beamBody.getSlice(plane);
	PlaneProfile shadowProfile = beamBody.shadowProfile(plane);
	Map map = beam.subMapX("ExtendedProperties");
	map.setDouble("TotalArea", shadowProfile.area()/1000000);
	beam.setSubMapX("ExtendedProperties", map);
	
	beamProfile.shrink(pointTolerance);
	if ( ! beamProfile.intersectWith(elementOutline)) 
	{
		Map map = beam.subMapX("ExtendedProperties");
		map.setDouble("TimberPercentageArea" + sProfile, U(0));
		beam.setSubMapX("ExtendedProperties", map);
		continue;
	}
	intersectingBeams.append(beam);
	beamPoints.append(beam.realBody().allVertices());
}

double beamArea;
for (int index = 0; index < intersectingBeams.length(); index++)
{
	Beam beam = intersectingBeams[index];
	Body beamBody = beam.realBody();
	PlaneProfile beamProfile = beamBody.getSlice(plane);
	beamProfile.intersectWith(elementOutline);
	Map map = beam.subMapX("ExtendedProperties");
	map.setDouble("TimberPercentageArea" + sProfile, beamProfile.area() / 1000000);
	beam.setSubMapX("ExtendedProperties", map);
	beamArea += beamProfile.area();
	
	if (sShowPlaneProfile == T("|Yes|"))
	 { 
	 	displayBeamProfile.draw(beamProfile);
		beamProfile.vis(1);		 	
	 }	
	 
	 if (sShowHatch == T("|Yes|"))
	 {
	 	Hatch hatch(hatchPattern, patternScale);
	 	hatchDisplay.draw(beamProfile, hatch);
	 }
}

if (beamArea < areaTolerance)
{
	reportMessage(TN("|No valid beam area found|"));
//	return;
}

double percentage = beamArea / elementArea * 100;

String stringPercentage;
stringPercentage.formatUnit(percentage, 2, 2);
Display displayText(iColor);
displayText.dimStyle(sDimensionStyle);
displayText.elemZone(element, 0, arChZoneCharacter[arSZoneLayer.find(sTextLayer, 0)]);
displayText.draw(stringPercentage, elementOutline.ptMid(), vecX, vecY, 0, 0);

if (sShowPlaneProfile == T("|Yes|"))
{
	displayBeamProfile.draw(elementOutline);
}

Map timberPercentageMap;
timberPercentageMap.setDouble("Percentage", percentage);
timberPercentageMap.setDouble("Area", elementArea/1000000);
timberPercentageMap.setDouble("AreaBrutto", elementOutlineBruto.area()/1000000);
timberPercentageMap.setDouble("AreaWood", beamArea/1000000);
timberPercentageMap.setString("Name", sProfile);

_ThisInst.setSubMapX("TimberPercentage", timberPercentageMap);

extendedPropertiesMap.appendMap("TimberPercentage", timberPercentageMap);

_Map.setMap("DimInfo", dimInfoMap);

element.setSubMapX("ExtendedProperties", extendedPropertiesMap, cs);











#End
#BeginThumbnail





































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="576" />
        <int nm="BREAKPOINT" vl="600" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="First version" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/15/2025 11:37:25 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End