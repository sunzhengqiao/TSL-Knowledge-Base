#Version 8
#BeginDescription

1.3 12/02/2025 Add exporter convention Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl sets the grain direction of sheets. The grain direction is attached as property set.
/// </summary>

/// <insert>
/// Select a set of sheets.
/// </insert>

/// <remark Lang=en>
/// Requires the property set 'hsbGeometryData'. 
/// </remark>
//#Versions
//1.3 12/02/2025 Add exporter convention Author: Robert Pol

/// <version  value="1.02" date="18.08.2017"></version>

/// <history>
/// AS - 1.00 - 06.01.2017 -	Pilot version
/// RP - 1.01 - 04.08.2017 -	Add option to flip z axis
/// RP - 1.02 - 18.09.2017 -	Set isotrpic propertie to new sheet 
/// </history>

double vectorTolerance = Unit(0.01, "mm");

String sNoYes[] = { T("|No|"), T("|Yes|")};
//endregion

String categories[] = 
{
	T("|Filter|"),
	T("|Grain direction|")
};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString filterDefinition(0, filterDefinitions, T("|Filter definition sheets|"));
filterDefinition.setDescription(T("|Filter definition for sheets.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[0]);

String grainDirectionAlignments[] = 
{
	T("|None|"),
	T("|Element| X"),
	T("|Element| Y"),
	T("|Sheet| X"),
	T("|Sheet| Y")
};

PropString alignGrainDirectionWith (1, grainDirectionAlignments, T("|Align grain direction|"));
alignGrainDirectionWith.setCategory(categories[1]);
alignGrainDirectionWith.setDescription(T("|The grain direction will be aligned with the selected vector|"));

PropString setZaxis(2,sNoYes,T("|Set Z axis from Element|"));
setZaxis.setCategory(categories[1]);
setZaxis.setDescription(T("|Set Z axis from Element, z will be iligned with viewside|"));

String propSetName = "hsbGeometryData";


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert)
{
	if (insertCycleCount()>1)
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	PrEntity ssSh(T("|Select sheets|"), Sheet());
	if (ssSh.go())
		_Sheet.append(ssSh.sheetSet());
		
	return;
}

Entity sheetEntities[0];
for (int s=0;s<_Sheet.length();s++)
	sheetEntities.append(_Sheet[s]);

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(sheetEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Sheets could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
sheetEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

Sheet sheets[0];

for (int e = 0; e < sheetEntities.length(); e++)
{
	Sheet sh = (Sheet)sheetEntities[e];
	Element el = sh.element();
	if ( ! sh.bIsValid() || !el.bIsValid() || sh.myZoneIndex() > 0)
	{
		sheets.append(sh);
		continue;
	}

	Vector3d zVectorElement = el.vecZ();
	Vector3d zVectorElemZone = el.zone(sh.myZoneIndex()).coordSys().vecZ();
	Vector3d zVectorSheet = sh.vecZ();
	
	if (zVectorElemZone.dotProduct(zVectorSheet) < -1 + vectorTolerance && setZaxis == T("|Yes|"))
	{
		Sheet newSheet;
		newSheet.dbCreate(sh.realBody(), sh.vecX(), sh.vecY(), sh.vecZ() * -1, false, U(100));
		newSheet.setType(sh.type());
		newSheet.setLabel(sh.label());
		newSheet.setSubLabel(sh.subLabel());
		newSheet.setSubLabel2(sh.subLabel2());
		newSheet.setGrade(sh.grade());
		newSheet.setInformation(sh.information());
		newSheet.setMaterial(sh.material());
		newSheet.setBeamCode(sh.beamCode());
		newSheet.setName(sh.name());
		newSheet.setModule(sh.module());
		newSheet.setHsbId(sh.hsbId());
		newSheet.setColor(sh.color());
		newSheet.setIsotropic(sh.isotropic());

		newSheet.assignToLayer(sh.layerName());
		sheets.append(newSheet);
		sh.dbErase();
	}
	else if (zVectorElemZone.dotProduct(zVectorSheet) < -1 + vectorTolerance)
	{
		Map graindirectionMap;
		graindirectionMap.setInt("ZDirectionSwitch", true);
		sh.setSubMapX("hsbGeometryData", graindirectionMap);
		sheets.append(sh);
	}
	else
	{
		sheets.append(sh);
	}
}	

for (int s=0;s<sheets.length();s++) 
{
	Sheet sh = sheets[s];
	if (!sh.bIsValid())
		continue;
	
	Vector3d vectorToCheckAlignment;
	if (alignGrainDirectionWith == grainDirectionAlignments[1])//x-element
	{
		Element el = sh.element();
		if (!el.bIsValid()) 
		{
			reportNotice(T("|Grain direction could not be set for sheet| ") + sh.posnum() + T(". |The element is not valid|."));
			continue;
		}
		vectorToCheckAlignment = el.vecX();
	}
	else if (alignGrainDirectionWith == grainDirectionAlignments[2])
	{
		Element el = sh.element();
		if (!el.bIsValid()) 
		{
			reportNotice(TN("|Grain direction could not be set for sheet| ") + sh.posnum() + T(". |The element is not valid|."));
			continue;
		}
		vectorToCheckAlignment = el.vecY();
	}
	else if (alignGrainDirectionWith == grainDirectionAlignments[3])
	{
		vectorToCheckAlignment = sh.vecX();
	}
	else if (alignGrainDirectionWith == grainDirectionAlignments[4])
	{
		vectorToCheckAlignment = sh.vecY();
	}
	
	int grainDirection = 0;
	if (alignGrainDirectionWith != grainDirectionAlignments[0]) 
	{
		double lengthInDirection = abs(sh.vecX().dotProduct(vectorToCheckAlignment));
		Vector3d alignedSheetVector = sh.vecX();
		
		double y = abs(sh.vecY().dotProduct(vectorToCheckAlignment));
		if (y>lengthInDirection)
		{
			lengthInDirection = y;
			alignedSheetVector = sh.vecY();
		}
		
		if (abs(abs(alignedSheetVector.dotProduct(sh.vecX())) - 1) < vectorTolerance)
			grainDirection = 1;
		else if (abs(abs(alignedSheetVector.dotProduct(sh.vecY())) - 1) < vectorTolerance)
			grainDirection = 2;
		else
			reportNotice(TN("|Grain direction could not be set for sheet| ") + sh.posnum() + ".");
	}
		
	Map propSetDefinitionMap;
	propSetDefinitionMap.setInt("GrainDirection", grainDirection);
	
	// set grain direction in MapX (Exporter convention)
	Map mapGrainDirection;
	if (grainDirection == 1)
	{
		mapGrainDirection.setVector3d("Direction", sh.vecX());
	}
	else if (grainDirection == 2)
	{
		mapGrainDirection.setVector3d("Direction", sh.vecY());
	}	
	sh.setSubMapX("GrainDirection", mapGrainDirection);
	
	int overwriteExistingProperties = true;
	int propSetExists = sh.createPropSetDefinition(propSetName, propSetDefinitionMap, overwriteExistingProperties);
	if (propSetExists)
		sh.attachPropSet(propSetName);
	else
		reportNotice(TN("|Property set could not be attahced for sheet| ") + sh.posnum() + ".");
}

eraseInstance();
return;

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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add exporter convention" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/12/2025 11:11:33 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End