#Version 8
#BeginDescription
Last modified by: Anno Sportel support.nl@hsbcad.com)
31.10.2019  -  version 1.05

1.6 09/12/2021 Recalc all grouping inf tsls in the drawing. Author: Anno Sportel
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Assign group information to elements
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.05" date="31.10.2019"></version>

/// <history>
/// AS - 1.00 - 31.01.2019-	First revision
/// AS - 1.01 - 31.01.2019-	Trigger show group info tsl.
/// AS - 1.02 - 31.01.2019-	Correct typo in group
/// AS - 1.03 - 01.04.2019-	Support different grouping types.
/// AS - 1.04 - 21.05.2019-	Trigger new show group info tsl.
/// AS - 1.05 - 31.10.2019-	Remove padding of group name.
/// </history>

String groupingInfoTslNames[] = 
{
	"HSB_I-ShowGroupingInformation",
	"Batch & Stack Info"
};

String groupingTypes[] = 
{
	"Batch",
	"Stacking",
	"Truck"
};

// TODO: Externalise the custom grouping types.
String customGroupingTypes[] = 
{
	"",
	"SalesOrder"
};


PropString standardGroupType(0, groupingTypes, T("|Group type|"));
PropString customGroupType(1, customGroupingTypes, T("|Custom group type|"));

PropString groupName(2, "", T("|Group name|"));

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	showDialog();
	
	PrEntity elementSet(T("|Select elements"), Element());
	if (elementSet.go())
	{
		_Element.append(elementSet.elementSet());
	}
	
	return;
}

String groupType = customGroupType != "" ? customGroupType : standardGroupType;

String groupChildKey = "Hsb_" + groupType + "Child";
String parentUIDKey = "ParentUID";

for (int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	
	//region Add group data.
	Map groupData;
	
	String parentUID = groupName;
	//parentUID.format("%03s", groupName);
	groupData.setString(parentUIDKey, parentUID);
		
	el.setSubMapX(groupChildKey, groupData);
	//endregion
}

Entity tslInstEntities[] = Group().collectEntities(true, TslInst(), _kModelSpace);
for (int t=0;t<tslInstEntities.length();t++)
{
	TslInst tsl = (TslInst)tslInstEntities[t];
	if (groupingInfoTslNames.find(tsl.scriptName()) != -1)
	{
		tsl.recalc();
	}
}
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Recalc all grouping inf tsls in the drawing." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="12/9/2021 2:44:01 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End