#Version 8
#BeginDescription
This tsl will apply a cnc tooling on sheetedges
1.7 18/01/2022 skip openings Author: Robert Pol

1.6 06/01/2022 Add check for negative zones (pline needs to be reversed) Author: Robert Pol

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
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

/// <version  value="1.04" date="17-06-2020"></version>

/// <history>
/// RP - 1.00 - ????????? -  Pilot version.
/// RP - 1.01 - 18-12-2019 -  Pilot version.
/// RP - 1.02 - 19-05-2020 -  Check if counterclockwise
/// RP - 1.03 - 29-05-2020 -  Add the cnc export tool per edge
/// RP - 1.04 - 17-06-2020 -  Fix in bug counterclockwise
/// RP - 1.05 - 06-01-2021 -  Another fix in bug counterclockwise
//#Versions
//1.7 18/01/2022 skip openings Author: Robert Pol
//1.6 06/01/2022 Add check for negative zones (pline needs to be reversed) Author: Robert Pol
/// </history>
//endregion

U(1,"mm");	
double dEps =U(.1);
double vectorTolerance = U(.01);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
//endregion

String addLineSegment = T("|Add linesegment|");
addRecalcTrigger(_kContext, addLineSegment);
String removeLineSegment = T("|Remove lineSegment|");
addRecalcTrigger(_kContext, removeLineSegment);
String delete = T("Delete");
addRecalcTrigger(_kContext, delete);

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) 
	{ 
		eraseInstance(); return; 
	}

	_Sheet.append(getSheet());
	
	int ok = true;
	while (ok)
	{
		PrPoint ssP(TN("|Select point|"));
		if (ssP.go() == _kOk)
		{
			_PtG.append(ssP.value()); //append the selected points to the list of grippoints _PtG
		}
		else
		{
			ok = false;
		}
	}

	return;
}

if (_Sheet.length() < 1)
{
	eraseInstance();
	return;
}

Sheet sheet = _Sheet[0];	
_Pt0 = sheet.ptCen();

if (_kExecuteKey == delete)
{
	eraseInstance();
	return;
}

if (_kExecuteKey == addLineSegment)
{
	_PtG.append(getPoint());
}

if (_kExecuteKey == removeLineSegment)
{
	_PtG.removeAt(_PtG.find(getPoint()));
}

setDependencyOnEntity(sheet);
Entity tsls[] = sheet.eToolsConnected();

for (int index=0;index<tsls.length();index++) 
{ 
	Entity entTsl = tsls[index]; 
	TslInst tsl = (TslInst)entTsl;
	if ( ! tsl.bIsValid() || tsl.scriptName() != scriptName() || tsl == _ThisInst) continue;
	tsl.dbErase();
}
 
PlaneProfile sheetProfile = sheet.profShape();
Vector3d sheetZ = sheet.vecZ();
PLine profilePlines[] = sheetProfile.allRings();

Display display(-1);

int ringsAreOpening[] = sheetProfile.ringIsOpening();

for (int index=0;index<profilePlines.length();index++) 
{ 
	PLine pline = profilePlines[index]; 
	Element sheetElement = sheet.element();
	if (sheetElement.bIsValid())
	{
		if (sheet.vecZ().dotProduct(sheetElement.zone(sheet.myZoneIndex()).coordSys().vecZ()) < -1 + vectorTolerance)
		{
			pline.reverse();
			sheetZ *= -1;
		}
	}
	
	int ringIsOpening = ringsAreOpening[index];
	if (ringIsOpening) continue;		
	Point3d plineVertexPoints[] = pline.vertexPoints(false);
	
	if (plineVertexPoints.length() < 2) continue;
	// make sure the pline is counterclockwise
	for (int index3 = 0; index3 < plineVertexPoints.length() - 1; index3++)
	{
		Point3d vertexPoint = plineVertexPoints[index3];
		Point3d nextVertexPoint = plineVertexPoints[index3 + 1];
		
		Point3d mid = (vertexPoint + nextVertexPoint) / 2;
		Vector3d direction(nextVertexPoint - vertexPoint);
		direction.normalize();
		direction.vis(mid, 1);
		Vector3d normal = sheetZ.crossProduct(direction);
		normal.vis(mid, 2);
		if (ringIsOpening)
		{
			normal *= -1;
		}
		
		Point3d pointOutsideProfile = mid + normal;
		
		if (sheetProfile.pointInProfile(pointOutsideProfile) != _kPointInProfile)
		{
			pline.reverse();
			break;
		}
	}
	plineVertexPoints = pline.vertexPoints(false);
	for (int index4 = 0; index4 < plineVertexPoints.length() - 1; index4++)
	{
		Point3d vertexPoint = plineVertexPoints[index4];
		Point3d nextVertexPoint = plineVertexPoints[index4 + 1];
		
		PLine vertexPline(vertexPoint, nextVertexPoint);
		
		for (int index2 = 0; index2 < _PtG.length(); index2++)
		{
			Point3d point = _PtG[index2];
			point.projectPoint(Plane(sheetProfile.coordSys().ptOrg(), sheetZ), U(0));
			Point3d pointOnProfshape = sheetProfile.closestPointTo(point);
			
			Map toolMap;
			
			if (vertexPline.isOn(pointOnProfshape))
			{
				Vector3d plvec(nextVertexPoint - vertexPoint);
				plvec.normalize();
				plvec.vis((nextVertexPoint + vertexPoint)/2);
				toolMap.appendPLine("PLine", vertexPline);
				CncExport cncExport("RoundingTool", toolMap);
				sheet.addTool(cncExport);
				display.draw(vertexPline);
				break;
			}
		}
		
	}
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
      <str nm="Comment" vl="skip openings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/18/2022 3:45:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add check for negative zones (pline needs to be reversed)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="1/6/2022 11:49:43 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End