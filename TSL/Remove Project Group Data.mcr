#Version 8
#BeginDescription

1.0 22-11-2022 Tsl to remove project grouping data with format Hsb_<grouping type>Child Author: Anno Sportel
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents

// #Versions
// 1.0 22-11-2022 Tsl to remove project grouping data with format Hsb_<grouping type>Child


if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	PrEntity elementSet(T("|Select elements"), Element());
	if (elementSet.go())
	{
		_Element.append(elementSet.elementSet());
	}
		
	return;
}


for (int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	
	String subMapXKeys[] = el.subMapXKeys();
	for (int k=0;k<subMapXKeys.length();k++)
	{
		if (subMapXKeys[k].left(4).makeUpper() == "HSB_" && subMapXKeys[k].right(5).makeUpper() == "CHILD")
		{
			el.removeSubMapX(subMapXKeys[k]);
		}
	}
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Tsl to remove project grouping data with format Hsb_&lt;grouping type&gt;Child" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/22/2022 1:23:13 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End