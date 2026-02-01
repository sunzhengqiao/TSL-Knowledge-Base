#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
13.07.2020 -  version 1.03

This tsl visualizes the original body of an entity comming from an external source.
The original body needs to be stored in a mapx called "HSBImportData""
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

/// <version  value="1.03" date="13-07-2020"></version>

/// <history>
/// RP - 1.00 - 18-06-2020 -  Pilot version.
/// RP - 1.01 - 22-06-2020 -  Add body in map to be able to transform and add custom convert to body importer
/// RP - 1.02 - 06-07-2020 -  Add offsets
/// RP - 1.03 - 13-07-2020 -  Add _Map on dbcreate

/// </history>
//endregion

U(1,"mm");	
double volumeTolerance = U(0.01, "mm");
double pointTolerance = U(0.1);
double vectorTolerance = U(0.01);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String solid = T("|Solid|");
String wireFrame = T("|Wireframe|");
String shell = T("|Shell|");

String visualStyles[]=
{
	wireFrame,
	shell,
	solid
};
//endregion

PropString visualStyle(0, visualStyles, T("|Visual style invalid body|"), 2);
visualStyle.setCategory(category);

PropDouble offset(0, U(0), "Offset");
offset.setDescription(T("|Defines the Offset value|"));
offset.setCategory(category);

String offsetDirections[] = { T("|X|"), T("|-X|"), T("|Y|"), T("|-Y|"), T("|Z|"), T("|-Z|")};
PropString offsetDirection(1, offsetDirections, T("|Offset Direction|"), 4);
offsetDirection.setDescription(T("|Defines the Offset Direction|. ") + T("|Notice|: ") + T("|Direction is relative to entity vectors|"));
offsetDirection.setCategory(category);
	
// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	_Entity.append(getEntity());
	
	return;
}	
// end on insert	__________________

String triggerConvertToBodyImporter = T("../|Convert to body importer|");
addRecalcTrigger(_kContext, triggerConvertToBodyImporter);
if (_bOnRecalc && (_kExecuteKey==triggerConvertToBodyImporter || _kExecuteKey==sDoubleClick))
{
// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl= _XE;
	Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[] = {};
	Entity entsTsl[] = {};
	Point3d ptsTsl[] = {};
	int nProps[]={};
	double dProps[]={};
	String sProps[]={};
	String sScriptname = "bodyImporter";
	Map mapTsl;
	mapTsl.setMap("Source", _Map.getMap("Source"));
	ptsTsl.append(_Pt0);
	
	tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
	
	eraseInstance();
	return;
			
}

Entity entity = _Entity[0];
_ThisInst.assignToLayer(entity.layerName());

if(_bOnDbCreated)
{
	_Pt0 = entity.coordSys().ptOrg();
	_XE = entity.coordSys().vecX();
	_YE = entity.coordSys().vecY();
	_ZE = entity.coordSys().vecZ();
	
	Map importmap = entity.subMapX("HsbImportData");
	if (importmap.length() < 1)
	{
		reportMessage(TN("|No original body found for entity: |") + entity.handle());
		eraseInstance();
		return;
	}
	_Map.setMap("Source", importmap);
}	

Body originalBody = _Map.getMap("Source").getBody("Body");
	
Display originalBodyDisplay(2);

Vector3d vecOffsetDirections[] ={ entity.coordSys().vecX(), - entity.coordSys().vecX(), entity.coordSys().vecY(), - entity.coordSys().vecY(), entity.coordSys().vecZ(), - entity.coordSys().vecZ()};
Vector3d offsetDirectionVector = vecOffsetDirections[offsetDirections.find(offsetDirection, 0)];

if (originalBody.isNull())
{
	PlaneProfile bodyFaceLoops[] = _Map.getMap("Source").getBodyAsPlaneProfilesList("Body");
		
	for (int index = 0; index < bodyFaceLoops.length(); index++)
	{
		PlaneProfile faceLoop = bodyFaceLoops[index];
		faceLoop.transformBy(offsetDirectionVector * offset);
		originalBodyDisplay.draw(faceLoop, visualStyles.find(visualStyle));
	}
		
	originalBodyDisplay.draw(TN("|Invalid Body| "), _Pt0 , entity.coordSys().vecY(), entity.coordSys().vecX(), 0, 0, _kDevice);
	return;
}
else 
{
	originalBody.transformBy(offsetDirectionVector * offset);
	originalBodyDisplay.draw(originalBody);
}

originalBodyDisplay.draw(scriptName(), _Pt0 , _YE, _XE, 0, 0, _kDevice);
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