#Version 8
#BeginDescription
#Versions
1.11 18/06/2025 Add support for non visulising scg items Author: Robert Pol
1.10 11/06/2025 Add support for ifc objects Author: Robert Pol
1.9 07/05/2021 Add medium detail representation for rectangular tubes Author: Robert Pol











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl represents an mep item which is created with Revit Mep. 
/// The mapping of the Revit Mep object to this tsl is done in an extension which is enabled while the model is imported in ACA.
/// </summary>

/// <insert>
/// Will be created when the model is imported in ACA. 
/// </insert>

/// <remark Lang=en>
///  Mep items have to be mapped to this tsl in the 'Revit MEP Converter' extension.
/// </remark>

/// <version  value="1.08" date="29.06.2020"></version>

/// <history>
/// AS - 1.00 - ??.??.???? - Proof of concept created. 
/// AS - 1.04 - 03.12.2019 - Add description.
/// AS - 1.05 - 08.05.2020 - Add  a setting to specify the detail level.
/// AS - 1.06 - 13.05.2020 - Add dim request for the individual items.
/// RP - 1.07 - 18.06.2020 - Add visual styles for invalid body
/// RP - 1.08 - 29.06.2020 - Fix bug where body was displayed and text was shown (text should not show)
/// #Versions
//1.11 18/06/2025 Add support for non visulising scg items Author: Robert Pol
//1.10 11/06/2025 Add support for ifc objects Author: Robert Pol
//1.9 07/05/2021 Add medium detail representation for rectangular tubes Author: Robert Pol
/// </history>

Unit(1,"mm");
double vectorTolerance = U(0.01);

_XE.vis(_Pt0, 1);
_YE.vis(_Pt0, 3);
_ZE.vis(_Pt0, 150);

String highDetail = T("|High detail|");
String mediumDetail = T("|Medium detail|");
String lowDetail = T("|Low detail|");

String solid = T("|Solid|");
String wireFrame = T("|Wireframe|");
String shell = T("|Shell|");


String detailLevels[] = 
{
	highDetail,
	mediumDetail,
	lowDetail
};

String visualStyles[]=
{
	wireFrame,
	shell,
	solid
};

PropString detailLevel(0, detailLevels, T("|Detail level|"), 0);

PropString visualStyle(1, visualStyles, T("|Visual style invalid body|"), 2);

Map mepdata = _Map.getMap("mepdata");

if (mepdata.hasString("executeKey") && _bOnDbCreated)
{
	_kExecuteKey = mepdata.getString("executeKey");
//	_Map.removeAt("executeKey", true);
}

if (mepdata.hasString("catalog") && _bOnDbCreated)
{
	String test = mepdata.getString("catalog");
	setPropValuesFromCatalog(mepdata.getString("catalog"));
//	_Map.removeAt("catalog", true);
	
}

Display mepItemDisplay( -1 );
mepItemDisplay.showInDxa(true);
mepItemDisplay.textHeight(U(25));

if (_Pt0 == _PtW && _bOnDbCreated)
{
	Map coordsysMap = _Map.getMap("source\\CoordSys");
	if (coordsysMap.length() > 0)
	{
		Point3d ptOrg = coordsysMap.getPoint3d("PtOrg");
		ptOrg.vis();
		Vector3d vecX = coordsysMap.getVector3d("vecX");
		vecX.vis(ptOrg);
		Vector3d vecY = coordsysMap.getVector3d("vecY");		
		vecY.vis(ptOrg);		
		Vector3d vecZ = coordsysMap.getVector3d("vecZ");
		vecZ.vis(ptOrg);
		
		_Pt0 = ptOrg;
		_XE = vecX;
		_YE = vecY;
		_ZE = vecZ;
	}
}

int mepItemVisualised = false;
if (detailLevel == highDetail)
{
	Body highDetailBody = _Map.getBody("mepdata\\SimpleBody");
	//highDetailBody.resolveSelfIntersect();
	Body highDetailBodyIfc = _Map.getBody("source\\SimpleBody");
//	highDetailBodyIfc.resolveSelfIntersect();
	int hasIfcBody = _Map.hasBody("source\\SimpleBody");
	Map csgMap = _Map.getMap("source\\CsgItems");
	
	if (! highDetailBody.isNull())
	{
		mepItemDisplay.draw(highDetailBody);
		mepItemVisualised = true;
	}
	else if (hasIfcBody)
	{
		if ( ! highDetailBodyIfc.isNull())
		{
			mepItemDisplay.draw(highDetailBodyIfc);
			mepItemVisualised = true;
		}
		else if (csgMap.length() > 0)
		{
			Body csgBody;
			for (int c = 0; c < csgMap.length(); c++)
			{
				Map csgBodyMap = csgMap.getMap(c);
				Body mappedcsgBody;
				if (csgMap.keyAt(c) == "CsgBrep")
				{
					mappedcsgBody = csgBodyMap.getBody("SimpleBody");
				}
				else if (csgMap.keyAt(c) == "CsgCylinder")
				{
					Point3d point1 = csgBodyMap.getPoint3d("Pt1");
					Point3d point2 = csgBodyMap.getPoint3d("Pt2");
					double radiusCylinder = csgBodyMap.getDouble("dRadius");
					
					mappedcsgBody = Body(point1, point2, radiusCylinder);
				}
				else if (csgMap.keyAt(c) == "CsgQuader")
				{
					Point3d ptOrg = csgBodyMap.getPoint3d("PtOrg");
					Vector3d vecX = csgBodyMap.getVector3d("vecX");
					Vector3d vecY = csgBodyMap.getVector3d("vecY");
					Vector3d vecZ = csgBodyMap.getVector3d("vecZ");
					double dOneUnit = csgBodyMap.getDouble("dOneUnit");
					double dX = csgBodyMap.getDouble("dX");
					double dY = csgBodyMap.getDouble("dY");
					double dZ = csgBodyMap.getDouble("dZ");
					
					mappedcsgBody = Body(ptOrg, vecX, vecY, vecZ, dX, dY, dZ);
					
				}
				
				//mappedcsgBody.resolveSelfIntersect();
				
				if (mappedcsgBody.isNull()) continue;
				
				csgBody += mappedcsgBody;
			}
			
			//csgBody.resolveSelfIntersect();
			
			if ( ! csgBody.isNull())
			{
				mepItemDisplay.draw(csgBody);
				mepItemVisualised = true;
			}
			else
			{
				PLine faces[] = _Map.getBodyFaceLoops("source\\SimpleBody");
				for (int f = 0; f < faces.length(); f++)
				{
					PlaneProfile face(faces[f]);
					mepItemDisplay.draw(face, visualStyles.find(visualStyle));
					mepItemVisualised = true;
				}
			}
		}
		else
		{
			PLine faces[] = _Map.getBodyFaceLoops("source\\SimpleBody");
			for (int f = 0; f < faces.length(); f++)
			{
				PlaneProfile face(faces[f]);
				mepItemDisplay.draw(face, visualStyles.find(visualStyle));
				mepItemVisualised = true;
			}
		}
		
	}
	else if (csgMap.length() > 0)
	{
		Body csgBody;
		for (int c = 0; c < csgMap.length(); c++)
		{
			Map csgBodyMap = csgMap.getMap(c);
			Body mappedcsgBody;
			if (csgMap.keyAt(c) == "CsgBrep")
			{
				mappedcsgBody = csgBodyMap.getBody("SimpleBody");
			}
			else if (csgMap.keyAt(c) == "CsgCylinder")
			{
				Point3d point1 = csgBodyMap.getPoint3d("Pt1");
				Point3d point2 = csgBodyMap.getPoint3d("Pt2");
				double radiusCylinder = csgBodyMap.getDouble("dRadius");
				
				mappedcsgBody = Body(point1, point2, radiusCylinder);
			}
			else if (csgMap.keyAt(c) == "CsgQuader")
			{
				Point3d ptOrg = csgBodyMap.getPoint3d("PtOrg");
				Vector3d vecX = csgBodyMap.getVector3d("vecX");
				Vector3d vecY = csgBodyMap.getVector3d("vecY");
				Vector3d vecZ = csgBodyMap.getVector3d("vecZ");
				double dOneUnit = csgBodyMap.getDouble("dOneUnit");
				double dX = csgBodyMap.getDouble("dX");
				double dY = csgBodyMap.getDouble("dY");
				double dZ = csgBodyMap.getDouble("dZ");
				
				mappedcsgBody = Body(ptOrg, vecX, vecY, vecZ, dX, dY, dZ);
				
			}
			//mappedcsgBody.resolveSelfIntersect();
			
			if (mappedcsgBody.isNull()) continue;
			
			csgBody += mappedcsgBody;
		}
		
		//csgBody.resolveSelfIntersect();
		if ( ! csgBody.isNull())
		{
			mepItemDisplay.draw(csgBody);
			mepItemVisualised = true;
		}
		
	}
	else
	{
		PLine faces[] = _Map.getBodyFaceLoops("mepdata\\SimpleBody");
		for (int f = 0; f < faces.length(); f++)
		{
			PlaneProfile face(faces[f]);
			mepItemDisplay.draw(face, visualStyles.find(visualStyle));
			mepItemVisualised = true;
		}
	}
}

PLine solidLines[0];
double solidLinesRadiusses[0];
double solidLinesWidths[0];
double solidLinesHeights[0];
Map solidLinesMap = _Map.getMap("mepdata\\solidlines[]");
for (int s = 0; s < solidLinesMap.length(); s++)
{
	if (solidLinesMap.keyAt(s).makeLower() != "solidline") continue;
	
	Map map = solidLinesMap.getMap(s);
	solidLines.append(map.getPLine("Line"));
	solidLinesRadiusses.append(map.getDouble("Radius"));
	solidLinesWidths.append(map.getDouble("Width"));
	solidLinesHeights.append(map.getDouble("Height"));
}

 // Use the solid lines for either a medium detail, or a low detail visualisation.
if (!mepItemVisualised)
{
	for (int s = 0; s < solidLines.length(); s++)
	{
		PLine pline = solidLines[s];
		
		// Create a medium detailed body based on the solid lines.
		if (detailLevel == mediumDetail || (detailLevel == highDetail && !mepItemVisualised))
		{
			double radius = solidLinesRadiusses[s];
			double width = solidLinesWidths[s];
			double height = solidLinesHeights[s];
			Point3d pts[] = pline.vertexPoints(true);
			Body mediumDetailBody;
			for (int i = 0; i < pts.length() - 1; i++)
			{
				Vector3d vecExt = pts[i + 1] - pts[i];
				Vector3d vecExtrNormalized = vecExt;
				vecExtrNormalized.normalize();
				PLine line = PLine();
				if (radius > 0)
				{
					line.createCircle(pts[i], vecExt, radius);
				
					Body body( line, vecExt);
					mediumDetailBody.addPart(body);				
				}
				else if (width > 0 && height > 0)
				{
					Vector3d vecZ = _ZE;
					if (abs(_ZE.dotProduct(_ZW)) < vectorTolerance)
					{
						vecZ = _YE;
						
					}
					Vector3d vecY = vecZ.crossProduct(vecExtrNormalized);
					LineSeg lineseg(pts[i] - vecY * 0.5 * width - vecZ * 0.5 * height, pts[i] + vecY * 0.5 * width + vecZ * 0.5 * height);
					line.createRectangle(lineseg, vecY, vecZ);
					Body body( line, vecExt);
					mediumDetailBody.addPart(body);	
				}

			}
			if ( ! mediumDetailBody.isNull())
			{
				mepItemDisplay.draw(mediumDetailBody);
				mepItemVisualised = true;
			}
		}
		
		// Create a low detailed visualisation by drawing the pline.
		if (detailLevel == lowDetail || !mepItemVisualised)
		{
			mepItemDisplay.draw(pline);
			mepItemVisualised = true;
		}
	}
}

if ( ! mepItemVisualised)
{
	mepItemDisplay.draw(T("|MEP| ") , _Pt0, _XE, _YE, 1, 1, _kDevice);
}

String hsbDimensionInfoKey = "Hsb_DimensionInfo";
String dimensionInfosKey = "DimRequest[]";
String dimensionInfoKey = "DimRequest";
String dimensionNameKey = "Stereotype";
String dimensionPointsKey = "Node[]";


Map hsbDimensionInfo = _ThisInst.subMapX(hsbDimensionInfoKey);
Map dimensionInfos;

//region Dimrequest for Connectors
String stereoTypeFormat = "@(RevitId.Category)"; 
String dimensionName = _ThisInst.formatObject(stereoTypeFormat);

Map mepData = _ThisInst.subMapX("MepData");
Map connectors = mepData.getMap("Connector[]");
Point3d dimensionPoints[0];
for (int c = 0; c < connectors.length(); c++)
{
	if (connectors.keyAt(c) != "CONNECTOR") continue;
	
	Map connector = connectors.getMap(c);
	dimensionPoints.append(connector.getPoint3d("PtOrg"));
}

Map dimensionInfo;
dimensionInfo.setString(dimensionNameKey, dimensionName);
dimensionInfo.setPoint3dArray(dimensionPointsKey, dimensionPoints);
dimensionInfos.appendMap(dimensionInfoKey, dimensionInfo);
//End Dimrequest for Connectors//endregion  Connectors

hsbDimensionInfo.setMap(dimensionInfosKey, dimensionInfos);
_ThisInst.setSubMapX(hsbDimensionInfoKey, hsbDimensionInfo);




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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="336" />
        <int nm="BreakPoint" vl="265" />
        <int nm="BreakPoint" vl="232" />
        <int nm="BreakPoint" vl="235" />
        <int nm="BreakPoint" vl="112" />
        <int nm="BreakPoint" vl="121" />
        <int nm="BreakPoint" vl="129" />
        <int nm="BreakPoint" vl="188" />
        <int nm="BreakPoint" vl="169" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add support for non visulising scg items" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="6/18/2025 2:27:48 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add support for ifc objects" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="6/11/2025 1:51:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End