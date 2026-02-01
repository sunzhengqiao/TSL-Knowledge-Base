#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
17.09.2019  -  version 1.01

This tsl will delete all replica's and replicators and remove the mapx of the elements
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
/// <summary Lang=en>
///This tsl will delete all replica's and replicators and remove the mapx of the elements
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="17.09.2019"></version>

/// <history>
/// RP - 1.00 - 12.07.2017 -	First version
/// RP - 1.01 - 17.09.2019 -	Replica not deleted

/// </history>

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select a position|"));
	
	return;
}

Entity allTsls[] = Group().collectEntities( true, TslInst(), _kModelSpace);


for (int i =0;i< allTsls.length();i++)
{
	TslInst tsl = (TslInst)allTsls[i];
	_Entity.append(tsl);
	
	if (tsl.scriptName() == "HSB_E-Replicator" || tsl.scriptName() == "HSB_E-Replica") 
	{
		tsl.dbErase();
	}
}

Entity allElements[] = Group().collectEntities( true, Element(), _kModelSpace);

for (int index=0;index<allElements.length();index++) 
{ 
	Element el = (Element)allElements[index]; 
	if (el.subMapXKeys().find("Hsb_Production") != -1)
	{
		Map subMapX = el.subMapX("Hsb_Production");
		subMapX.removeAt("MAINELEMENT", true);
		subMapX.removeAt("ORIGINALNUMBER", true);
		subMapX.removeAt("ISMIRRORED", true);
		subMapX.removeAt("Hsb_replicator", true);
		
		el.setSubMapX("Hsb_Production", subMapX);
	}
	if (el.subMapXKeys().find("Replica[]") != -1)
	{
		el.removeSubMapX("Replica[]");
	}
	if (el.subMapXKeys().find("ReplicaMirrored[]") != -1)
	{
		el.removeSubMapX("ReplicaMirrored[]");
	}
}

removeSubMapXProject("Delivery[]");
removeSubMapXProject("Replicators");

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