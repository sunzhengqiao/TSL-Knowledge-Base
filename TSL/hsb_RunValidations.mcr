#Version 8
#BeginDescription
Runs validations from the model.
2.1 21/09/2021 Take all entities from the element Author: Robert Pol












2.2 29/08/2022 Always take all groups Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
#KeyWords BOM, labels in paperspace
#BeginContents
/// version
// #Versions
//2.2 29/08/2022 Always take all groups Author: Robert Pol
//2.1 21/09/2021 Take all entities from the element Author: Robert Pol
/// version

Unit (1,"mm");//script uses mm

String sVersion=hsbOEVersion();sVersion.makeUpper();

String strAssemblyPath;


strAssemblyPath=_kPathHsbInstall + "\\Utilities\\hsbValidation\\hsbValidationTSL.dll";

String strType = "hsbCad.Validation.TSLValidationRunner";

String strGroupFunction = "GetGroups";

String strInAr[0];
strInAr.append(_kPathHsbCompany);


String sAllGroups[] = callDotNetFunction1(strAssemblyPath, strType, strGroupFunction , strInAr);

PropString sGroupName (0, sAllGroups, T("Test Group"));

//Properties
//Select dimstyle

String sProjectNumber=projectNumber();

//Collect data

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
		
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	return;
}

strAssemblyPath=_kPathHsbInstall + "\\Utilities.Acad\\hsbValidation\\hsbValidationInspectorAcad.dll";
strType = "hsbValidationInspector.MapTransaction";
// set some export flags
ModelMapComposeSettings mmFlags;
mmFlags.addSolidInfo(true); // default FALSE
mmFlags.addAnalysedToolInfo(true); // default FALSE
mmFlags.addElemToolInfo(true); // default FALSE
mmFlags.addConstructionToolInfo(true); // default FALSE
mmFlags.addHardwareInfo(true); // default FALSE
mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(true); // default FALSE
mmFlags.addCollectionDefinitions(true); // default FALSE
mmFlags.addAllGroups(true);

String strDestinationFolder = _kPathDwg;

Entity allEntities[0];
for (int i=0; i<_Element.length(); i++)
{
	if (_Element[i].bIsValid())
	{
		Entity ents[]=_Element[i].elementGroup().collectEntities(true, (Entity()), _kModelSpace, false);
		for(int j=0 ; j < ents.length() ; j++)
		{
			Entity ent = ents[j];
			if (ent.bIsValid())
			{
				allEntities.append(ent);
			}
		}
		allEntities.append(_Element[i]);
		
	}
}

ModelMap mm;
mm.setEntities(allEntities);
mm.dbComposeMap(mmFlags);

Map mapIn();
mapIn.setMap("ModelMap", mm.map());
mapIn.setInt("AllResults", true);
mapIn.setString("GroupName", sGroupName);
mapIn.setString("CompanyPath", _kPathHsbCompany);

String strFunction = "LaunchValidationInspector";

Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);

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
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Always take all groups" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/29/2022 3:22:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Take all entities from the element" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/21/2021 10:27:49 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End