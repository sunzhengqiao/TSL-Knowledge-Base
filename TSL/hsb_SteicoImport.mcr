#Version 8
#BeginDescription
TSL used to import Steico Joists from IFC via the Modelmap
































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
String strYesNo[] = {"Yes", "No" };

PropString pIJoistGroupName( 1, "I-Joists\Ground_Floor", "IJoist Group Name", 0 );
PropString pMemberGroupName(2, "Member\Ground_Floor", "Member Group Name", 0 );
PropString pBeamGroupName( 3, "Beams\Ground_Floor", "Beam Group Name", 0 );
PropString pNogginGroupName( 4, "Noggins\Ground_Floor", "Noggin Group Name", 0 );
PropString pBlockingProupName( 5, "Blocking\Ground_Floor", "Blocking Group Name", 0 );
PropString pSacrJoistGroupName( 6, "Sacrificial Joists\Ground_Floor", "Sacrificial Joists Group Name", 0 );
PropString pEndDeviceGroupName(7, "End Device\Ground_Floor", "Device Group Name", 0 );
PropString pRimboardGroupName(8, "Rimboard\Ground_Floor", "Rimboard Group Name", 0 );

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
	String strFunction = "ImportCadModel";
	Map mapIn;	

	reportMessage(strAssemblyPath);

	mapIn.setString( "ijoistGroupname", pIJoistGroupName );
	mapIn.setString( "memberGroupname", pMemberGroupName );
	mapIn.setString( "beamGroupname", pBeamGroupName );
	mapIn.setString( "nogginGroupname", pNogginGroupName );
	mapIn.setString( "blockingGroupname", pBlockingProupName );
	mapIn.setString( "sacrJoistGroupname", pSacrJoistGroupName );
	mapIn.setString( "endDeviceGroupname", pEndDeviceGroupName );
	mapIn.setString( "rimboardGroupName", pRimboardGroupName );
	mapIn.setString( "memberTypePropertyFormat", "@(member properties.type)" );
	mapIn.setString( "memberDescPropertyFormat", "@(member properties.desc)" );
	mapIn.setString( "endDeviceTypePropertyFormat", "@(type)" );
	mapIn.setString( "ijoistTypePropertyFormat", "@(material)" );
	
	mapIn.setString( "ijoistPropertyName", "i-joist" );
	mapIn.setString( "memberPropertyName", "member" );
	mapIn.setString( "beamPropertyName", "beam" );
	mapIn.setString( "nogginPropertyName", "noggin" );
	mapIn.setString( "blockingPropertyName", "blocking" );
	mapIn.setString( "sacrjoistPropertyName", "sacrificial joist" );
	mapIn.setString( "endDevicePropertyName", "end device" );
	mapIn.setString( "rimboardPropertyName", "rimboard" );

	mapIn.setString( "extProfFormatNameSplit", "SJL,SJW" );

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