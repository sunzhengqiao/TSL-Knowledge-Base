#Version 8
#BeginDescription




1.0 06/03/2024 First Version Author: Robert Pol

1.1 16/07/2025 Rename prop Author: Robert Pol
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

//#Versions
//1.1 16/07/2025 Rename prop Author: Robert Pol
//1.0 06/03/2024 First Version Author: Robert Pol

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
String executeKey = "ManualInsert";
String squareBeamCutTslName = "HSB_T-SquareBeamCut";

PropString pBeamCodesBeamCutBeam(nStringIndex++, "FREES", T("|BeamCode(s)|"));
pBeamCodesBeamCutBeam.setDescription(T("|Specify the beamcodes using ; as seperator|."));
pBeamCodesBeamCutBeam.setCategory(category);

_ThisInst.setSequenceNumber(1600);

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
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
		}
		else
		{
			setPropValuesFromCatalog(sLastInserted);
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
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

// insert per element
	for(int i=0;i<_Element.length();i++)
	{
		entsTsl[0]= _Element[i];	
		ptsTsl[0]=_Element[i].ptOrg();
		
		tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
		
		if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
	}

	eraseInstance();
	return;
}	
// end on insert	__________________
	
// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

String beamCodesBeamCutBeam[] = pBeamCodesBeamCutBeam.tokenize(";");

Element el = _Element[0];
CoordSys cs = el.coordSys();
Vector3d vecX = cs.vecX();
Vector3d vecY = cs.vecY();
Vector3d vecZ = cs.vecZ();
Point3d ptOrg = cs.ptOrg();
assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer

Beam beams[] = el.beam();
Beam beamCutBeams[0];
for (int b=0;b<beams.length();b++)
{
	Beam beam = beams[b];
	if (! beam.bIsValid() || beamCodesBeamCutBeam.find(beam.beamCode()) == -1) continue;
	beamCutBeams.append(beam);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamCutBeams, false, "Beams", "Beams", "Beam");

int successfullyFiltered = TslInst().callMapIO(squareBeamCutTslName, "", filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|Beams could not be processed!|") + TN("|Make sure that the tsl| ") + squareBeamCutTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("Beams", "Beams", "Beam");

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
	eraseInstance();
	return;
}






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
      <str nm="Comment" vl="Rename prop" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/16/2025 1:41:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="First Version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/6/2024 2:39:30 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End