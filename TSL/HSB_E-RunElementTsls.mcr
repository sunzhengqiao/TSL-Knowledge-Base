#Version 8
#BeginDescription
Last modified by: Robert Pol(support.nl@hsbcad.com)
12.10.2018 - version 2.05

This tsl can run multiple element tsls. This can be configured in a .xml file: hsbCompany\TSL\Settings\RunElementTslsConfigurations.xml
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
// constants //region
/// <summary Lang=en>
/// Description
/// </summary>

/// <insert>
/// Specify insert
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.05" date="12-10-2018"></version>

/// <history>
/// RP - 1.00 - 22-02-2018 -  Pilot version.
/// RP - 1.01 - 22-02-2018 -  Redo tsl with reading of xml, because when tsl is deleted afterwards, propvalues are not set from catalog
/// RP - 1.02 - 02-03-2018 -  Redo tsl with new dbCreate function in tsl
/// RP - 1.03 - 17-05-2018 -  Add property for xml file name
/// RP - 1.04 - 17-05-2018 -  Remove reportnotice
/// FA  - 2.00 - 11-06-2018 -	  Now reading, creating and writing to a submap in the settings folder called "RunElementTsls". This is also created when executing the TSL. 
/// RP  - 2.01 - 02-08-2018 -	  Add allowed type
/// RP  - 2.02 - 07-09-2018 -	  Remove allowed type and add entity filter
/// RP  - 2.03 - 10-09-2018 -	  Only use 1 file, this will support thorstens tsl to import and export setting into a drawing.
/// RP  - 2.04 - 11-10-2018 -	  Add list of filtercatalogs, cascade mode.
/// RP  - 2.05 - 12-10-2018 -	  List of catalogs not working.
/// </history>
//endregion

U(1,"mm");	
double dEps =U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
//endregion

String filterDefinitionTslName = "HSB_G-FilterEntities";
String RunElementTslsConfigurationsSetKey = "RunElementTslsConfigurationSet[]";
String RunElementTslsConfigurationsKey = "RunElementTslsConfiguration[]";
String RunElementTslsConfigurationKey = "RunElementTslsConfiguration";
String tslName = "TslName";
String tslFilterKey = "FilterCatalog[]";
String tslCatalog = "TslCatalog";
String filterCatalog = "FilterCatalog";

String fileName =_kPathHsbCompany + "\\Tsl\\Settings\\RunElementTslsConfigurations" + ".xml";

Map configurationsMaps;
configurationsMaps.readFromXmlFile(fileName);
String setNames[0];
for (int m=0;m<configurationsMaps.length();m++) 
{ 
	Map configurationsMap = configurationsMaps.getMap(m);
	setNames.append(configurationsMap.getMapName());
}

PropString setName(0, setNames, T("|Configuration set|"));
setName.setDescription(T("|The configuration set that will be executed|"));

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
		{
			setPropValuesFromCatalog(sKey);
		}
		else
		{
			setPropValuesFromCatalog(T("|_LastInserted|"));					
			sKey = T("|_LastInserted|");
		}
	}	
	else	
	{
		showDialog();
		sKey = T("|_LastInserted|");
	}

// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
		_Element.append(ssE.elementSet());

// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl= _XE;
	Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[] = {};
	Entity entsTsl[1] ;
	Point3d ptsTsl[1];

	Map mapTsl;	
	String sScriptname = scriptName();
		
// insert per element
	for(int i=0;i<_Element.length();i++)
	{
		entsTsl[0]= _Element[i];	
		ptsTsl[0]=_Element[i].ptOrg();
		
		tslNew.dbCreate(sScriptname, vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sKey, true, mapTsl, sKey,  "OnDbCreated"); 
		
		if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
	}

	eraseInstance();
	return;
}	
// end on insert	__________________

// validate 1 element
if (_Element.length()<1)
{
	reportMessage("\n" + scriptName() + ": " +T("|Invalid element.|"));
	eraseInstance();
	return;	
}

if (findFile(fileName) == "")
{
	int folderExists = makeFolder(_kPathHsbCompany + "\\Tsl\\Settings");
	if (!folderExists)
	{
		reportError(T("|Folder does not exist.|\n") + _kPathHsbCompany + "\\Tsl\\Settings");
		eraseInstance();
		return;
	}
	
	// ***********************************************************
	// Default set of element tsl configurations.
	// ***********************************************************
	Map RunElementTslsConfigurationSet;
	RunElementTslsConfigurationSet.setMapKey(RunElementTslsConfigurationsSetKey);
	Map RunElementTslsConfigurations;
	RunElementTslsConfigurations.setMapName("Example");
	
	Map RunElementTslsConfiguration;
	RunElementTslsConfiguration.setString(tslName, "HSB_E-Identification&Marking");
	RunElementTslsConfiguration.setString(tslCatalog, "_Default");
	Map filterCatalogsMap;
	filterCatalogsMap.appendString(filterCatalog, "_Default");
	filterCatalogsMap.appendString(filterCatalog, "_LastInserted");
	RunElementTslsConfiguration.setMap(tslFilterKey, filterCatalogsMap);
	RunElementTslsConfigurations.appendMap(RunElementTslsConfigurationKey, RunElementTslsConfiguration);
	
	RunElementTslsConfiguration.setString(tslName, "HSB_E-BeamToSheet");
	RunElementTslsConfiguration.setString(tslCatalog, "_Default");
	Map filterCatalogsMap2;
	filterCatalogsMap2.appendString(filterCatalog, "_Default");
	filterCatalogsMap2.appendString(filterCatalog, "_LastInserted");
	RunElementTslsConfiguration.setMap(tslFilterKey, filterCatalogsMap2);
	RunElementTslsConfigurations.appendMap(RunElementTslsConfigurationKey, RunElementTslsConfiguration);
	
	RunElementTslsConfiguration.setString(tslName, "HSB-Brace");
	RunElementTslsConfiguration.setString(tslCatalog, "_Default");
	Map filterCatalogsMap3;
	filterCatalogsMap3.appendString(filterCatalog, "_Default");
	filterCatalogsMap3.appendString(filterCatalog, "_LastInserted");
	RunElementTslsConfiguration.setMap(tslFilterKey, filterCatalogsMap3);
	RunElementTslsConfigurations.appendMap(RunElementTslsConfigurationKey, RunElementTslsConfiguration);
	
	RunElementTslsConfigurationSet.appendMap(RunElementTslsConfigurationsKey, RunElementTslsConfigurations);
	int writtenSuccessfully = RunElementTslsConfigurationSet.writeToXmlFile(fileName);
	
	reportNotice(TN("|Default run element tsls configurations file created|: ") + fileName);
}
	
Element el = _Element[0];
Vector3d vecX = el.vecX();
Vector3d vecY = el.vecY();
Vector3d vecZ = el.vecZ();
Point3d ptOrg = el.ptOrg();	
	
_Pt0 = ptOrg;

if (findFile(fileName).length()<4)
{
	reportMessage("\n" + scriptName() + ": " +T("|Configuration file not found.|"));
	eraseInstance();
	return;	
}

Map elementTslsMapSet;
elementTslsMapSet.readFromXmlFile(fileName);
for (int index=0;index<elementTslsMapSet.length();index++) 
{ 
	Map elementTslsMap = elementTslsMapSet.getMap(index); 
	if (elementTslsMap.getMapName() != setName) continue;
	
	for (int m = 0; m < elementTslsMap.length(); m++)
	{
		Map elementTslMap = elementTslsMap.getMap(m);
		if (elementTslMap.getMapKey() != "RunElementTslsConfiguration") continue;

		String thisTslName = elementTslMap.getString(tslName);
		Map tslCatalogsMap = elementTslMap.getMap(tslFilterKey);
		String thisTslCatalog = elementTslMap.getString(tslCatalog);
		Entity filteredEntities[0];
		filteredEntities.append(_Entity);
		
		for (int c=0;c<tslCatalogsMap.length();c++) 
		{ 
			String thisTslFilterCatalog = tslCatalogsMap.getString(c);
			
			Map filterEntitiesMap;
			filterEntitiesMap.setEntityArray(filteredEntities, false, "Entity", "Entity", "Entity");
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, thisTslFilterCatalog, filterEntitiesMap);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			
			filteredEntities = filterEntitiesMap.getEntityArray("Entity", "Entity", "Entity");
		}
		
		for (int f = 0; f < filteredEntities.length(); f++)
		{
			Entity entity = filteredEntities[f];
			
			// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl = _XE;
			Vector3d vecYTsl = _YE;
			GenBeam gbsTsl[] = { };
			Entity entsTsl[1];
			Point3d ptsTsl[1];
			Map mapTsl;
			
			entsTsl[0] = entity;
			ptsTsl[0] = entity.coordSys().ptOrg();
			
			tslNew.dbCreate(thisTslName, vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, thisTslCatalog, _kModelSpace, mapTsl, thisTslCatalog, "OnElementConstructed");
		}
	}
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End