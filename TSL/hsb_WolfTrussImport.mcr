#Version 8
#BeginDescription
TSL used to import Wolf Trusses from IFC via the Modelmap
































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
String strYesNo[] = {"Yes", "No" };

PropString pTrussGroupName( 1, "Trusses\Ground_Floor", "Truss Group Name", 0 );
PropString pBeamGroupName(2, "Beams\Ground_Floor", "Beam Group Name", 0 );
PropString pTrussFilter(3, "", "Truss Name Filter", 0 );

setPropValuesFromCatalog(_kExecuteKey);
ModelMap mm;

if(_bOnInsert) 
{
	int nCreateTrussLocations = true; 
	int nMetric = ( U(1,"mm") == 1.0 );

	if (_kExecuteKey=="")
	{
		showDialogOnce();
	}

	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbCloudStorage\\hsbSteicoIO.dll";
   	String strType = "hsbCad.IO.Steico.HsbCadIO";
	String strFunction = "ImportWolfIFC";
	Map mapIn;	

	mapIn.setString( "trussGroupName", pTrussGroupName );
	mapIn.setString( "beamGroupname", pBeamGroupName );
	mapIn.setString( "trussFilter", pTrussFilter );
	mapIn.setString( "plateIdFormat", "Nailplate" );
	mapIn.setString( "trussMetalWebMaterialId", "Wstrut" );
	mapIn.setString( "ifcelemenType", "IfcElementAssembly" );

	Map mapRet = callDotNetFunction2( strAssemblyPath, strType, strFunction , mapIn);
	mm.setMap( mapRet  ); 
}
else
{
	mm.setMap( _Map  ); 	
}

ModelMapInterpretSettings mmFlags;
mmFlags.resolveEntitiesByHandle(TRUE); // default FALSE
mmFlags.resolveElementsByNumber(TRUE); // default FALSE
mm.dbInterpretMap(mmFlags);
eraseInstance();

return;

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
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End