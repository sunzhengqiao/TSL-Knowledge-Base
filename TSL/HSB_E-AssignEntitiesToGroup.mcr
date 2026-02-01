#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)

06.09.2018  -  version 1.02

This tsl assigns entities from an element to a specified group
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

/// <version  value="1.02" date="06-09-2018"></version>

/// <history>
/// RP - 1.00 - 07-06-2018 -  Pilot version.
/// RP - 1.01 - 07-06-2018 -  set catolog from executekey
/// RP - 1.02 - 06-09-2018 -  Add entity selection

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
String filterDefinitionTslName = "HSB_G-FilterEntities";
String executeKey = "ManualInsert";

_ThisInst.setSequenceNumber(2000);

String filterEntitiesCatalogs[0];
filterEntitiesCatalogs.append("");
filterEntitiesCatalogs.append(TslInst().getListOfCatalogNames(filterDefinitionTslName));

PropString filterEntitiesCatalog(nStringIndex++, filterEntitiesCatalogs, T("|Entity filter catalog|"));	
filterEntitiesCatalog.setDescription(T("|Select the catalog to filter the entities from the element|"));
filterEntitiesCatalog.setCategory(category);

PropString groupFormat(nStringIndex++, "@(GroupLevel1)\@(GroupLevel2)", T("|Group format|"));	
groupFormat.setDescription(T("|Specify the format of the group to where the entities should be added|") + TN("|Please make sure to use \ between the different group name parts|"));
groupFormat.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

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
	Entity selection[0];
	int selectionIsElement;
	
	PrEntity ssE(T("|Select a set of elements|") + T(" |or <ENTER> to select entities|"), Element());
	if (ssE.go()) 
	{
		if(ssE.set().length() ==0)
		{
			PrEntity ssEBm(T("|Select entities|"), Entity());
			if (ssEBm.go()) 
			{
				selection.append(ssEBm.set());
			}
		}
		else
		{
			selectionIsElement = true;
			selection.append(ssE.set());
		}
	}
	
	if (selection.length() < 1)
	{
		eraseInstance();
		return;
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

			
	if(bDebug)reportMessage("\n"+ scriptName() + " will be cloned" + 
		"\n	vecX  	" + vecXTsl+
		"\n	vecY  	" + vecYTsl+
		"\n	GenBeams 	(" + gbsTsl.length()+")" +
		"\n	Entities 	(" + entsTsl.length()+")"+
		"\n	Points   	(" + ptsTsl.length()+")"+
		"\n	PropInt  	(" + nProps.length()+")"+ ((nProps.length()==nIntIndex) ? " OK" : (" Warning: should be " + nIntIndex))+
		"\n	PropDouble	(" + dProps.length()+")"+ ((dProps.length()==nDoubleIndex) ? " OK" : (" Warning: should be " + nDoubleIndex))+
		"\n	PropString	(" + sProps.length()+")"+ ((sProps.length()==nStringIndex) ? " OK" : (" Warning: should be " + nStringIndex))+
		"\n	Map      	(" + mapTsl.length()+") " + mapTsl+"\n");			

		
// insert per element
	for(int i=0;i<selection.length();i++)
	{
		Element el = (Element)selection[i];
		if ( ! el.bIsValid())
		{
			_Entity.append(selection[i]);
			continue;
		}
		entsTsl[0]= el;	
		ptsTsl[0]=el.ptOrg();
		
		tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
		
		if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +el.number());
	}
	
	if (selectionIsElement)
	{
		eraseInstance();
		return;
	}

}	
// end on insert	__________________
	
if (_Entity.length() < 1)
{
	reportMessage(TN("|No Entities found.|"));
	eraseInstance();
	return;	
}	

// validate and declare element variables
if (_Element.length()>0)
{
	Element el = _Element[0];
	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer
	
	_Entity.append(el.elementGroup().collectEntities(false, (Entity()), _kModelSpace, false));
}


Entity filteredEntities[0];
Map filterEntitiesMap;
filterEntitiesMap.setEntityArray(_Entity, false, "Entity", "Entity", "Entity");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterEntitiesCatalog, filterEntitiesMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
filteredEntities.append(filterEntitiesMap.getEntityArray("Entity", "Entity", "Entity"));

for (int index=0;index<filteredEntities.length();index++) 
{ 
	Entity entity = filteredEntities[index]; 
	String groupName; 
	 
	 Map contentFormatMap;
	contentFormatMap.setString("FormatContent", groupFormat);
	contentFormatMap.setEntity("FormatEntity", entity);
	int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
	if(!succeeded)
	{
		reportNotice(T("|Please make sure that the tsl HSB_G-ContentFormat is loaded in the drawing|"));
	}

	groupName = contentFormatMap.getString("FormatContent");
	
	String allGroupNames[0];
	
	Group allGroups[] = Group().allExistingGroups();
	
	for (int i=0;i<allGroups.length();i++) 
	{ 
		Group group = allGroups[i]; 
		allGroupNames.append(group.name()); 
	}
	
	int groupIndex = allGroupNames.find(groupName);
	Group group;
	if (groupIndex != -1)
	{
		group = allGroups[groupIndex];
	}
	
	if (groupName == "" || groupIndex == -1)
	{
		if (groupName == "") continue;
		Group newGroup(groupName);
		newGroup.dbCreate();
		group = newGroup;
		reportMessage(TN("|Groupname not found for entity|: ") + entity.handle() + T("|Group| ") + groupName + T("|has been created|"));
	}
	
	if ( ! group.bExists()) continue;
	
	group.addEntity(entity, true);
}

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
	eraseInstance();
	return;
}

#End
#BeginThumbnail



#End
#BeginMapX

#End