#Version 8
#BeginDescription
Last modified by: Anno Sportel support.nl@hsbcad.com)
25.07.2019  -  version 1.00
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
/// <summary Lang=en>
/// Tsl to draw a block
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="16.07.2019"></version>

/// <history>
/// AS - 1.00 - 16.07.2019-	First revision
/// </history>

String blockNames[0];
String blockLoadNames[0];
blockNames.append(_BlockNames);
blockLoadNames.append(_BlockNames);

String blockSearchPath = "C:\\Temp\\Blocks";
String fileSystemBlocks[] = getFilesInFolder(blockSearchPath);

for (int b=0;b<fileSystemBlocks.length();b++)
{
	String blockName = fileSystemBlocks[b];
	if (blockName.right(3) == "dwg")
	{
		String blockDisplayName = blockName.trimRight(".dwg");
		
		if (blockNames.find(blockDisplayName) != -1) continue;
		
		blockNames.append(blockDisplayName);
		blockLoadNames.append(blockSearchPath + "\\" + blockName);
	}
}

PropString blockName(0, blockNames, T("|Block names|"));

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	showDialog();
	_Pt0 = getPoint(T("|Select insertion point|"));
	
	return;
}

String blockLoadName = blockLoadNames[blockNames.find(blockName)];
Block block(blockLoadName);

Display blockDisplay(-1);
blockDisplay.draw(block, _Pt0);
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