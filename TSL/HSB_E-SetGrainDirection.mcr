#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
10.11.2017  -  version 1.03
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

/// <version  value="1.03" date="10.11.2017"></version>

/// <history>
/// AS - 1.00 - 06.01.2017 -	Pilot version
/// RP - 1.01 - 04.08.2017 -	Add option to flip z axis
/// RP - 1.02 - 18.09.2017 -	Set isotrpic propertie to new sheet 
/// RP - 1.03 - 10.11.2017 -	Element insert
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
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}	
		else	
			showDialog();
		
	// prompt for elements
		PrEntity ssE(T("|Select one or more elements|") + T(" <|Right click to select sheets|>"), Element());
	  	if (ssE.go())
	  	{
			_Element.append(ssE.elementSet());
			if (_Element.length() == 0) 
			{
				PrEntity ssESh(T("|Select sheets|"), Sheet());
				if (ssESh.go()) {
					_Sheet.append(ssESh.sheetSet());
					return;
				}
			}
	  	}

	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[1] ;
		Point3d ptsTsl[1];
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ManualInsert", true);
	
	// insert per element
		for(int i=0;i<_Element.length();i++)
		{
			entsTsl[0]= _Element[i];	
			ptsTsl[0]=_Element[i].ptOrg();
			
			tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
			
		}

		eraseInstance();
		return;
	}	
// end on insert	__________________
// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if (_Element.length() >0)
{
	Element el = _Element[0];
	if (el.bIsValid())
		_Sheet.append(el.sheet());
}
if (_Sheet.length() < 1)
{
	eraseInstance();
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

if (setZaxis == T("|Yes|"))
{

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
		Vector3d zVectorSheet = sh.vecZ();
		
		if (zVectorElement.dotProduct(zVectorSheet) > 1 - vectorTolerance)
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
	}	
}
else	
{ 
	for (int s = 0; s < sheetEntities.length(); s++)
	{
		Sheet sh = (Sheet)sheetEntities[s];
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