#Version 8
#BeginDescription
#Versions:
1.18 24-11-2022 Add support for zone index, which is now part of the Comment. - Author: Anno Sportel
1.17 05.10.2022 HSB-16441: Support display properties color,text size, leader size Author: Marsel Nakuci
1.16 28-9-2022 Use CommentManagementUI instead of CommentManagement. Author: Anno Sportel
1.15 06.09.2022 HSB-16432: Add property zone to assign it to a particular zone Author: Marsel Nakuci
1.14 16/08/2021 Option added to add comment from catalogue without showing comment dialogue. Author: Anno Sportel
1.13 09/08/2021 Correct text orientation for leader comment. Author: Anno Sportel



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 18
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl create and edits comments.
/// </summary>

/// <insert>
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.10" date="28.08.2020"></version>

/// <history>
/// AS - 1.00 - 
/// ....
/// AS - 1.08 - 26.06.2019 -	Create comment displays when adding comments.
/// AS - 1.09 - 06.03.2020 -	Add support for leaders
/// ....
/// AS - 1.12 - 28.08.2020 -	Only allow a leader comment to be added if there are at least 2 points selected.
// #Versions
// 1.18 24-11-2022 Add support for zone index, which is now part of the Comment. - Author: Anno Sportel
// 1.17 05.10.2022 HSB-16441: Support display properties color,text size, leader size Author: Marsel Nakuci
// 1.16 28-9-2022 Use CommentManagementUI instead of CommentManagement. Author: Anno Sportel
// 1.15 06.09.2022 HSB-16432: Add property zone to assign it to a particular zone Author: Marsel Nakuci
// 1.14 16/08/2021 Option added to add comment from catalogue without showing comment dialogue. Author: Anno Sportel
// 1.13 09/08/2021 Correct text orientation for leader comment. Author: Anno Sportel
/// </history>
Unit(1,"mm");

String commentDisplayScriptName = "hsb_CommentDisplay";

String modelMapKey = "ModelMap";
String commentsKey = "Comment[]";
String commentKey = "Comment";
String commentIdKey = "Id";
String entityKey = "Entity";
String geometryKey = "Geometry";
String geometryTypeKey = "GeometryType";
String locationKey = "Location";
String startPointKey = "StartPoint";
String endPointKey = "EndPoint";
String areaKey = "Location";
String textOriginKey = "TextOrigin";
String textDirectionKey = "TextOrientation";
String textUpDirectionKey = "TextUpDirection";
String zoneIndexKey = "ZoneIndex";
String leaderKey = "Leader";
String showEditCommentsAfterAddModeKey = "ShowEditCommentsAfterAddMode";
String loadFromCatalogueKey = "LoadFromCatalogue";
String commentCatalogueEntryNameKey = "CommentCatalogueEntryName";

String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\CadUtilities\\hsbCommentManagement\\hsbCommentManagementUI.dll";
String strType = "hsbSoft.Cad.UI.CommentManager";
String addCommentFunction = "AddComment";
String editCommentFunction = "EditComments";
String getCommentCatalogueEntriesFunction = "GetCommentCatalogueEntries";

Map mapIn;
Map mapOut;

String category = "|General|";
String executionModes[] = 
{
	T("|Add comment|"),
	T("|Edit comments|")
};
PropString executionModeProp(0, executionModes, T("|Action|: "));
executionModeProp.setDescription(T("|Sets the execution mode of the comment manager.|"));
executionModeProp.setCategory(category);

String showEditCommentsAfterAdding[] = 
{
	T("|No|"),
	T("|Yes|")
};
PropString showEditCommentsAfterAddingProp(3, showEditCommentsAfterAdding, T("|Show Edit Comments|: "), 0);
showEditCommentsAfterAddingProp.setDescription(T("|Shows the Edit Comments List after adding comments|"));
showEditCommentsAfterAddingProp.setCategory(category);

category = "|Add Comment|";
String commentCatalogueEntryNames[] = { "" };
mapOut = callDotNetFunction2(strAssemblyPath, strType, getCommentCatalogueEntriesFunction, mapIn);
for (int i = 0; i < mapOut.length();i++)
{
	if (mapOut.keyAt(i) == commentCatalogueEntryNameKey)
	{
		commentCatalogueEntryNames.append(mapOut.getString(i));
	}
}
PropString commentCatalogueEntryName(4, commentCatalogueEntryNames, T("|Comment Catalogue Entry|"));
commentCatalogueEntryName.setDescription(T("|Adds a comment with the selected comment catalogue entry without showing the comment dialogue if a valid catalogue entry is selected.|"));
commentCatalogueEntryName.setCategory(category);

String locationGeometries[] = 
{
	T("|No location|"),
	T("|Point|"),
	T("|Line segment|"),
	T("|Area|"),
	T("|Leader|")
};
PropString locationGeometryProp(1, locationGeometries, T("|Location geometry|"), 0);
locationGeometryProp.setDescription(T("|Specifies what geometry to use for the location of the comment.|"));
locationGeometryProp.setCategory(category);

category = "|Position & Orientation|";
String textOrientations[] = 
{
	T("|Default|"),
	T("|Horizontal|"),
	T("|Vertical|"),
	T("|Perpendicular|")
};
PropString textOrientationProp(2, textOrientations, T("|Text orientation|"));
textOrientationProp.setDescription(T("|Sets the text direction of the comment.|") + T("|Default text direction for a point and an area is the entity X, for a line its the line direction.|"));
textOrientationProp.setCategory(category);

PropDouble horizontalOffset(0, U(0), T("|Horizontal offset|"));
horizontalOffset.setDescription(T("|Sets the horizontal offset.|") + T("|The offset is relative to the linked geometry, or in the entity X direction if there is no geometry linked.|"));
horizontalOffset.setCategory(category);

PropDouble verticalOffset(1, U(0), T("|Vertical offset|"));
verticalOffset.setDescription(T("|Sets the vertical offset.|") + T("|The offset is relative to the linked geometry, or in the entity Y direction if there is no geometry linked.|"));
verticalOffset.setCategory(category);
// HSB-16441: color, text height, leader size
String sColourName=T("|Colour|");
int nColours[]={1,2,3};
PropInt nColour(0, 1, sColourName);
nColour.setDescription(T("|Defines the Colour|"));
nColour.setCategory(category);

String sTextHeightName=T("|Text Height|");
PropDouble dTextHeight(2, U(50), sTextHeightName);
dTextHeight.setDescription(T("|Defines the Text Height|"));
dTextHeight.setCategory(category);

String sLeaderSizeName=T("|Leader Size|");
PropDouble dLeaderSize(3, U(1), sLeaderSizeName);
dLeaderSize.setDescription(T("|Defines the Leader Size as a scale factor|"));
dLeaderSize.setCategory(category);

// HSB-16432:
category=T("|Assignment|");
String sZoneName=T("|Zone|");
String sZones[]={ "5","4","3","2","1","0","-1","-2","-3","-4","-5"};
PropString sZone(5, sZones, sZoneName,5);	
sZone.setDescription(T("|Defines the Zone|"));
sZone.setCategory(category);

//-------------------------------------------------------------------
// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
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
	
	if ( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
}

int executionMode = executionModes.find(executionModeProp, 0);
int showEditCommentsAfterAddMode = showEditCommentsAfterAdding.find(showEditCommentsAfterAddingProp, 0);

if (_bOnInsert)
{
	int locationGeometry = locationGeometries.find(locationGeometryProp, 0);
	int textOrientation = textOrientations.find(textOrientationProp, 0);

	if (executionMode == 1 || (executionMode == 0 && locationGeometry == 0))
	{
		PrEntity ssE(TN("|Select a set of elements|"), Element());
		if ( ssE.go() )
		{
			_Element.append(ssE.elementSet());
		}
		
		return;
	}
	else
	{
		Element selectedElement = getElement(T("|Select an element|"));
		CoordSys selectedElementCoordSys = selectedElement.coordSys();
		Vector3d selectedElementX = selectedElementCoordSys.vecX();
		Vector3d selectedElementY = selectedElementCoordSys.vecY();
		Vector3d selectedElementZ = selectedElementCoordSys.vecZ();
		_Element.append(selectedElement);
		
		Point3d geometryOrg = selectedElementCoordSys.ptOrg();
		Vector3d geometryX = selectedElementX;
		Vector3d geometryZ = selectedElementZ;
		
		Map geometryMap;
		if (locationGeometry == 1)
		{
			geometryMap.setInt(geometryTypeKey, locationGeometry - 1);
			Point3d commentLocation = getPoint(T("|Select a position|"));
			geometryMap.setPoint3d(locationKey, commentLocation);
			
			geometryOrg = commentLocation;
		}
		else if (locationGeometry == 2)
		{
			geometryMap.setInt(geometryTypeKey, locationGeometry - 1);
			Point3d startPoint = getPoint(T("|Select start of line segment|"));
			geometryMap.setPoint3d(startPointKey, startPoint);
			
			Point3d endPoint;
			PrPoint endPointSelection(TN("|Select end point of line segment|"), startPoint); 
			if (endPointSelection.go()==_kOk) 
			 { ;
				endPoint = endPointSelection.value();
				geometryMap.setPoint3d(endPointKey, endPoint);
			}
			
			Vector3d lineDirection(endPoint - startPoint);
			lineDirection.normalize();
			geometryX = lineDirection;
			
			geometryOrg = (endPoint + startPoint) / 2;
		}
		else if (locationGeometry == 3)
		{
			PLine area(selectedElementZ);
			geometryMap.setInt(geometryTypeKey, locationGeometry - 1);
			PrEntity areaSelectionSet(T("|Select a poly line, right click to select two points as a diagonal|"), EntPLine());
			if (areaSelectionSet.go() == _kOk)
			{
				Entity selectedAreas[] = areaSelectionSet.set();
				if (selectedAreas.length() > 0)
				{
					area = ((EntPLine)selectedAreas[0]).getPLine();
				}
				else
				{ 
					reportMessage(TN("|Invalid area selected.|"));
					eraseInstance();
					return;
				}
			}
			else
			{
				Point3d startPoint = getPoint(T("|Select start of diagonal|"));
				Point3d endPoint;
				PrPoint endPointSelection(TN("|Select end of diagonal|"), startPoint);
				if (endPointSelection.go() == _kOk)
				{
					endPoint = endPointSelection.value();
				}
				endPoint = Plane(startPoint, selectedElementZ).closestPointTo(endPoint);
				
				area.createRectangle(LineSeg(startPoint, endPoint), selectedElementX, selectedElementY);
			}
			
			geometryMap.setPLine(areaKey, area);
			geometryOrg = Body(area, geometryZ, 0).ptCen();
		}
		else if (locationGeometry == 4)
		{
			geometryMap.setInt(geometryTypeKey, locationGeometry - 1);
			Point3d startPoint = getPoint(T("|Select start of leader line|"));
			PLine pline;
			EntPLine pl;
			pline.addVertex(startPoint);

			while (1)
			{
				PrPoint ssP2("\nSelect next point", startPoint);
				if (ssP2.go() == _kOk)
				{
					startPoint = ssP2.value(); //retrieve the selected point
					pline.addVertex(startPoint);
					pl.dbErase();
					pl.dbCreate(pline);
				}
				else
				{
					break;
				}
			}
			pl.dbErase();
			
			if (pline.vertexPoints(true).length() <= 1)
			{
				reportMessage(TN("|Invalid leader selected.|") + T(" |There are at least 2 points required.|"));
				eraseInstance();
				return;
			}

			geometryMap.setPLine(leaderKey, pline);
			Point3d pts[] = pline.vertexPoints(false);
			Vector3d lineDirection = selectedElementX;
			geometryX = lineDirection;
			geometryOrg = pts.last();
		}		
		
		Vector3d geometryY = geometryZ.crossProduct(geometryX);
		geometryY.normalize();
		Point3d textPosition = geometryOrg + geometryX * horizontalOffset + geometryY * verticalOffset;
		Vector3d textDirection = geometryX;

		if (textOrientation == 1)
		{
			textDirection = selectedElementX;
		}
		else if (textOrientation == 2)
		{
			textDirection = selectedElementY;
		}
		else if (textOrientation == 3)
		{
			textDirection = geometryY;
		}
		Vector3d textUpDirection = selectedElementZ.crossProduct(textDirection);
		
		_Map.setPoint3d(textOriginKey, textPosition);
		_Map.setVector3d(textDirectionKey, textDirection);
		_Map.setVector3d(textUpDirectionKey, textUpDirection);
		_Map.setInt(zoneIndexKey, sZone.atoi());
		
		_Map.setMap(geometryKey, geometryMap);
	}
}


if (_Element.length()==0)
{
	eraseInstance();
	return;
}

// set some export flags
ModelMapComposeSettings mmFlags;

// compose ModelMap
ModelMap mm;

Entity ents[0];
for(int i=0;i<_Element.length();i++)
{
	ents.append(_Element[i]);
}
	
mm.setEntities(ents);
mm.dbComposeMap(mmFlags);

////String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\CadUtilities\\hsbCommentManagement\\hsbCommentManagement.dll";
////String strType = "hsbSoft.Cad.UI.CommentManager";
////String addCommentFunction = "AddComment";
////String editCommentFunction = "EditComments";

mapIn = Map();
mapIn.setMap(modelMapKey, mm.map());
if (_Map.hasMap(geometryKey))
{
	mapIn.setMap(geometryKey, _Map.getMap(geometryKey));
}
if (_Map.hasPoint3d(textOriginKey))
{
	mapIn.setPoint3d(textOriginKey, _Map.getPoint3d(textOriginKey));
}
if (_Map.hasVector3d(textDirectionKey))
{
	mapIn.setVector3d(textDirectionKey, _Map.getVector3d(textDirectionKey));
}
if (_Map.hasVector3d(textUpDirectionKey))
{
	mapIn.setVector3d(textUpDirectionKey, _Map.getVector3d(textUpDirectionKey));
}
if (_Map.hasInt(zoneIndexKey))
{
	mapIn.setInt(zoneIndexKey, _Map.getInt(zoneIndexKey));
}

mapIn.setInt(showEditCommentsAfterAddModeKey, showEditCommentsAfterAddMode);
if (executionMode == 0)
{
	mapIn.setString(loadFromCatalogueKey, commentCatalogueEntryName);
}

//mapIn.writeToDxxFile("C:\\Temp\\ToCommentManagerFromManagementTsl.dxx");
mapOut = Map();
mapOut = callDotNetFunction2(strAssemblyPath, strType, executionMode == 0?addCommentFunction:editCommentFunction, mapIn);

//for (int m=0;m<mapOut.length();m++)
//{
//	reportNotice("\nKey: " + mapOut.keyAt(m));
//}

if (mapOut.hasMap(modelMapKey))
{
	// set some import flags
	ModelMapInterpretSettings mmImportFlags;
	mmImportFlags.resolveEntitiesByHandle(TRUE); // default FALSE
	
	// interpret ModelMap
	mm.setMap(mapOut.getMap(modelMapKey));
	//mm.writeToDxxFile("C:\\temp\\test.dxx");
	mm.dbInterpretMap(mmImportFlags);
	
	// report the entities imported/updated/modified
	Entity importedEnts[] = mm.entity();
	reportMessage (TN("|Number of entities imported|: ") + importedEnts.length());
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1, 0, 0);
	Vector3d vecUcsY(0, 1, 0);
	Beam lstBeams[0];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	Map createdComments = mapOut.getMap(commentsKey);
	for (int c=0;c<createdComments.length();c++)
	{
		if (createdComments.keyAt(c) != commentKey) continue;
		
		Map createdComment = createdComments.getMap(c);
		Entity entity = createdComment.getEntity(entityKey);
		String commentId = createdComment.getString(commentIdKey);
		
		lstEntities[0] = entity;
		mapTsl.setString(commentIdKey, createdComment.getString(commentIdKey));
		TslInst commentDisplay;
		commentDisplay.dbCreate(commentDisplayScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	// HSB-16432:
		//commentDisplay.setPropString(3, sZone);
	// Zone is now part of the comment itself. So it will come in to the comment display through the comment management library.
		commentDisplay.setPropInt(0,nColour);
		commentDisplay.setPropDouble(0,dTextHeight);
		commentDisplay.setPropDouble(3,dLeaderSize);
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
      <str nm="COMMENT" vl="Add support for zone index, which is now part of the Comment." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="11/24/2022 9:46:50 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16441: Support display properties color,text size, leader size" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="17" />
      <str nm="DATE" vl="10/5/2022 9:37:39 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Use CommentManagementUI instead of CommentManagement." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="9/28/2022 11:46:48 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16432: Add property zone to assign it to a particular zone" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="9/6/2022 10:43:18 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Option added to add comment from catalogue without showing comment dialogue." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="8/16/2021 2:58:57 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Correct text orientation for leader comment." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="8/9/2021 11:25:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End