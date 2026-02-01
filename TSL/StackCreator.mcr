#Version 8
#BeginDescription
Last modified by: Anno Sportel support.nl@hsbcad.com)
31.10.2019  -  version 1.02

1.3 09/12/2021 Recalc all grouping info tsls in the drawing. Author: Anno Sportel
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Create stacks. The stacks are auto numbered.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="31.10.2019"></version>

/// <history>
/// AS - 1.00 - 16.07.2019-	First revision
/// AS - 1.01 - 18.09.2019-	Rename StackingSequencer to StackSequencer
/// AS - 1.02 - 31.10.2019-	Rename to StackCreator.
/// </history>

String groupType = "STACKING";
String parentUIDKey = "ParentUID";
String sequenceKey = "Seq";

if (_bOnInsert)
{
	Entity entities[] = Group().collectEntities(true, Entity(), _kModelSpace);
	
	String parentUIDs[0];
	for (int e = 0; e < entities.length(); e++)
	{
		Entity entity = entities[e];
		String mapXKeys[] = entity.subMapXKeys();
		
		for (int m = 0; m < mapXKeys.length(); m++)
		{
			String mapXKey = mapXKeys[m];
			if (mapXKey.left(4).makeUpper() == "HSB_" && mapXKey.right(5).makeUpper() == "CHILD")
			{
				Map groupingChildMap = entity.subMapX(mapXKey);
				String groupingType = mapXKey.mid(4, mapXKey.length() - 9).makeUpper();
				if (groupingType != groupType) continue;
				
				parentUIDs.append(groupingChildMap.getString(parentUIDKey));
			}
		}
	}
	
	// Sort grouped entities by parent.
	for (int s1 = 1; s1 < parentUIDs.length(); s1++)
	{
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--)
		{
			if ( parentUIDs[s11] < parentUIDs[s2] )
			{
				parentUIDs.swap(s2, s11);				
				s11 = s2;
			}
		}
	}
	
	String nextGroupName = "1";
	if (parentUIDs.length() > 0)
	{
		int lastGroupNumber = parentUIDs[parentUIDs.length() - 1].atoi();
		nextGroupName = lastGroupNumber + 1;
	}
	_Map.setString("GroupName", nextGroupName);

	PrEntity elementSet(T("|Select elements"), Element());
	if (elementSet.go())
	{
		_Element.append(elementSet.elementSet());
	}
	
	return;
}

String groupChildKey = "Hsb_StackingChild";
String groupName = _Map.getString("GroupName");
for (int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	
	//region Add group data.
	Map groupData;
	
	String parentUID;
	parentUID.format("%03s", groupName);
	groupData.setString(parentUIDKey, parentUID);
	
	int sequenceNumber = e;
	Map content;
	content.setInt(sequenceKey, sequenceNumber);
	groupData.setMap("Content", content);
		
	el.setSubMapX(groupChildKey, groupData);
	//endregion
}

String groupingInfoTslNames[] = 
{
	"HSB_I-ShowGroupingInformation",
	"Batch & Stack Info"
};
Entity tslInstEntities[] = Group().collectEntities(true, TslInst(), _kModelSpace);
for (int t=0;t<tslInstEntities.length();t++)
{
	TslInst tsl = (TslInst)tslInstEntities[t];
	
	if (groupingInfoTslNames.find(tsl.scriptName()) != -1)
	{
		tsl.recalc();
	}
}

TslInst productionSequenceTsl;
String strScriptName = "StackSequencer";
Vector3d vecUcsX (1, 0, 0);
Vector3d vecUcsY (0, 1, 0);
Point3d lstPoints[0];
Beam lstBeams[0];
Element lstElements[0];
int lstPropInt[0];
double lstPropdouble[0];
String lstPropString[0];
Map mapTsl;
productionSequenceTsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstElements, lstPoints, "", _kModelSpace, mapTsl, "", "OnInsert");

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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Recalc all grouping info tsls in the drawing." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/9/2021 2:39:01 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End