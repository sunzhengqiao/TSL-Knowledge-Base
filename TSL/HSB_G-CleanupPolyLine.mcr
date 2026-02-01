#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
02.11.2018  -  version 1.02
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl does a cleanup on a poly line.
/// </summary>

/// <insert>
/// Select a poly line
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="05.04.2018"></version>

/// <history>
/// AS - 1.00 - 23.11.2017 -	First revision.
/// AS - 1.01 - 05.04.2018 -	Add option to close resulting pline
/// AS - 1.02 - 02.11.2018 -	Add second vertice to list of vertices
/// </history>

double vectorTolerance = Unit(0.01, "mm");

int logLevel = -1;
if (_Map.hasInt("LogLevel"))
{
	logLevel = _Map.getInt("LogLevel");
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if (_bOnInsert) 
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	EntPLine selectedPLine = getEntPLine(T("|Select a poly line|"));
	
	_Map.setPLine("PLine", selectedPLine.getPLine());
	_Map.setInt("ManualInsert", true);

	return;
}

int manualInsert = _Map.getInt("ManualInsert");

if (_bOnMapIO || manualInsert || _bOnDebug) 
{
	PLine pLine = _Map.getPLine("PLine");
	Point3d vertices[] = pLine.vertexPoints(false);
	
	Point3d previousVertex = vertices[0];
	PLine cleanedupPLine(pLine.coordSys().vecZ());
	vertices.append(vertices[1]);
	for ( int v = 1; v < (vertices.length() - 1); v++)
	{
		Point3d thisVertex = vertices[v];
		Point3d nextVertex = vertices[v + 1];

		Vector3d towardsThis(thisVertex - previousVertex);
		
		if ( logLevel == 1 )
		{
			reportNotice("\n" + v + ": " + towardsThis.length());
		}
		
		if ( towardsThis.length() < U(0.5) ) continue;
		towardsThis.normalize();
		
		Vector3d awayFromThis(nextVertex - thisVertex);
		
		if ( logLevel == 1 )
		{
			reportNotice("\n" + v + ": " + awayFromThis.length());
		}
		
		if ( awayFromThis.length() < U(0.5) ) continue;
		awayFromThis.normalize();
		
		if ( logLevel == 1 )
		{
			reportNotice("\n" + v + ": " + abs(towardsThis.dotProduct(awayFromThis) - 1));
		}
		
		if ( abs(towardsThis.dotProduct(awayFromThis) - 1) < vectorTolerance ) continue;
		
		previousVertex = thisVertex;
		previousVertex.vis(v);
		
		cleanedupPLine.addVertex(thisVertex);
	}
	
	int closeResult;
	if (_Map.hasInt("CloseResult"))
	{
		closeResult = _Map.getInt("CloseResult");
	}
	if (closeResult)
	{
		cleanedupPLine.close();
	}
	
	PLine cleanPL = cleanedupPLine;
	cleanPL.transformBy(_ZW * 25);
	cleanPL.vis(1);
	
	_Map.setPLine("PLine", cleanedupPLine);

	if (manualInsert)
	{
		reportMessage(cleanedupPLine);
		eraseInstance();
	}
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End