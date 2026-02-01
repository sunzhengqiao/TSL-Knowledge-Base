#Version 8
#BeginDescription
#Versions:
1.27 28/11/2024 Make sure when a comment is copied, all props are also set to match the original tsl Author: Robert Pol
1.26 08/02/2024 Hardcode option to see area from back with inside display Author: Robert Pol
1.25 22/11/2023 Add option to show lines and area from the back Author: Robert Pol
1.24 29/11/2022 Align the comment to the front of the zone and fix issue with the zone assignement. AJ
1.23 28.11.2022 HSB-17074: Change opacity to transparency
1.22 24-11-2022 Add support for zone index, which is now part of the Comment. 
1.21 06.10.2022 HSB-16441: Add command "Add/Remove leader"
1.20 05.10.2022 HSB-16441: support leader size 
1.19 28-9-2022 Use CommentManagementUI instead of CommentManagement.
1.18 28-9-2022 Remove All Comments | Also remove comments that were removed by ACA delete. TODO: Remove all SubMapX interaction from tsl. Use comment management instead. 
1.17 06.09.2022 HSB-16432: add property zone to assign it to a particular zone
V1.16 5/18/2022 Added triggers to erase coment(s) from element
V1.15 5/18/2022 Changed copy comment dialogs to work with multiple selection
Date: 28.08.2020  -  version 1.14

















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 27
#KeyWords 
#BeginContents

/// <summary Lang=en>
/// This tsl displays comments which are attached to the elements as metadata.
/// </summary>

/// <insert>
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>
/// #Versions:
//1.27 28/11/2024 Make sure when a comment is copied, all props are also set to match the original tsl Author: Robert Pol
//1.26 08/02/2024 Hardcode option to see area from back with inside display Author: Robert Pol
//1.25 22/11/2023 Add option to show lines and area from the back Author: Robert Pol
// 1.24 29/11/2022 Align the comment to the front of the zone and fix issue with the zone assignement. AJ
// 1.23 28.11.2022 HSB-17074: Change opacity to transparency Author: Marsel Nakuci
// 1.22 24-11-2022 Add support for zone index, which is now part of the Comment. - Author: Anno Sportel
// 1.21 06.10.2022 HSB-16441: Add command "Add/Remove leader" Author: Marsel Nakuci
// 1.20 05.10.2022 HSB-16441: support leader size Author: Marsel Nakuci
// 1.19 28-9-2022 Use CommentManagementUI instead of CommentManagement. Author: Anno Sportel
// 1.18 28-9-2022 Remove All Comments | Also remove comments that were removed by ACA delete. TODO: Remove all SubMapX interaction from tsl. Use comment management instead. Author: Anno Sportel
// 1.17 06.09.2022 HSB-16432: add property zone to assign it to a particular zone Author: Marsel Nakuci
/// <version  value="1.13" date="19.03.2020"></version>

/// <history>
/// AS - 1.00 - 25.06.2019 -	Tsl to display comments created.
/// AS - 1.01 - 25.06.2019 -	Add grip to point comment
/// AS - 1.02 - 26.06.2019 -	Add offset properties. 
/// AS - 1.03 - 26.06.2019 -	Edit sends id in an array to the edit command.
/// AS - 1.04 - 02.07.2019 -	Reverse the direction of the vertical and horizontal allignment.
/// AS - 1.05 - 28.08.2019 -	Correct multiline text.
/// AS - 1.06 - 04.09.2019 -	Add point visualisation. Create new comment Id when copied. Bugfix area move and copy.
/// AS - 1.07 - 05.09.2019 - 	Respect visualisation type for text.
/// AS - 1.08 - 05.09.2019 - 	Add option to change direction of comment.
/// AS - 1.09 - 13.11.2019 - 	Align text with device.
/// AS - 1.10 - 06.03.2020 - 	Leader uses Units.
/// FA - 1.11 - 17.03.2020 - 	Added Custom action to copy comment to element. 
/// FA - 1.12 - 18.03.2020 - 	Added Custom action to copy one single comment to element.
/// AS - 1.13 - 19.03.2020 - 	Transform map instead of individual entries.
/// AS - 1.14 - 28.08.2020 -	Protect leader against invalid grip movements.
/// </history>

Unit(1,"mm");
double dEps =U(.1);
double pointTolerance = U(0.1);

String modelMapKey = "ModelMap";

String commentsMapKey = "Hsb_Comment";
String commentsKey = "Comment[]";
String commentKey = "Comment";
String commentIdsKey = "Id[]";
String commentIdKey = "Id";
String commentLinesKey = "Comment[]";
String commentLineKey = "Comment";
String tagsKey = "Tag[]";
String tagKey = "Tag";
String locationKey = "Location";
String geometryTypeKey = "GeometryType";
String geometryKey = "Geometry";
String startPointKey = "StartPoint";
String endPointKey = "EndPoint";
String textOriginKey = "TextOrigin";
String textOrienationKey = "TextOrientation";
String horizontalTextAlignmentKey = "HorizontalTextAlignment";
String verticalTextAlignmentKey = "VerticalTextAlignment";
String zoneIndexKey = "ZoneIndex";
String visualisationKey = "Visualisation";
String leaderKey = "Leader";

String category = T("|Position & Orientation|");
String textOrientations[] = 
{
	T("|Unchanged|"),
	T("|Default|"),
	T("|Horizontal|"),
	T("|Vertical|"),
	T("|Perpendicular|")
};
PropString textOrientationProp(2, textOrientations, T("|Text orientation|"));
textOrientationProp.setDescription(T("|Sets the text direction of the comment.|") + T("|Default text direction for a point and an area is the entity X, for a line its the line direction.|"));
textOrientationProp.setCategory(category);

PropDouble horizontalOffset(1, U(0), T("|Horizontal offset|"));
horizontalOffset.setDescription(T("|Sets the horizontal offset.|") + T("|The offset is relative to the linked geometry, or in the entity X direction if there is no geometry linked.|"));
horizontalOffset.setCategory(category);

PropDouble verticalOffset(2, U(0), T("|Vertical offset|"));
verticalOffset.setDescription(T("|Sets the vertical offset.|") + T("|The offset is relative to the linked geometry, or in the entity Y direction if there is no geometry linked.|"));
verticalOffset.setCategory(category);

category = T("|Comment style|");
PropInt commentColor(0, 1, T("|Colour|"));
commentColor.setCategory(category);

PropDouble commentTextHeight(0, U(50), T("|Text height|"));
commentTextHeight.setCategory(category);

// HSB-16441: 
String sLeaderSizeName=T("|Leader Size|");
PropDouble dLeaderSize(3, U(1), sLeaderSizeName);
dLeaderSize.setDescription(T("|Defines the Leader Size|"));
dLeaderSize.setReadOnly(true);
dLeaderSize.setCategory(category);
// 
category = T("|Area profile|");
String gripTypes[] = {T("|Edge|"), T("|Corner|")};
PropString gripTypeProp(1, gripTypes, T("|Active grippoints|"));
gripTypeProp.setCategory(category);

String noYes[] = { T("|No|"), T("|Yes|")};
PropString drawAreaCommentFilledProp(0, noYes, T("|Draw area filled|"), 1);
drawAreaCommentFilledProp.setCategory(category);
// HSB-17074
PropInt opacityAreaComment(1, 50, T("|Transparency|"));
opacityAreaComment.setCategory(category);

// HSB-16432: 
category=T("|Assignment|");
String sZoneName=T("|Zone|");
String sZones[]={ "5","4","3","2","1","0","-1","-2","-3","-4","-5"};
PropString sZone(3,sZones,sZoneName,5);
sZone.setDescription(T("|Defines the Zone|"));
sZone.setCategory(category);

//region Jigging
		
String strJigAction = "strJigAction";
if (_bOnJig && _kExecuteKey == strJigAction)
{ 
	Vector3d vecView = getViewDirection();
	Point3d ptStart=_Map.getPoint3d("ptStart");
	Display dpjig(3);
	
	Point3d ptJig = _Map.getPoint3d("_PtJig");
	Point3d ptG1 = _Map.getPoint3d("ptG1");
	
	// newly inserted points
	Point3d pts[]=_Map.getPoint3dArray("pts");
	Point3d ptsExist[]=_Map.getPoint3dArray("ptsExist");
	int nModeJig = _Map.getInt("ModeJig");
	
	ptJig=Line(ptJig,vecView).intersect(Plane(ptG1,vecView),U(0));
	if(nModeJig==0)
	{ 
		//Add mode
		for (int i=0;i<pts.length();i++) 
		{ 
			dpjig.draw(LineSeg(ptStart,pts[i]));
		}//next i
		dpjig.draw(LineSeg(ptStart,ptJig));
	}
	else if(nModeJig==1)
	{ 
		for (int i=0;i<pts.length();i++) 
		{ 
			dpjig.draw(LineSeg(ptStart,pts[i]));
		}//next i
//		dpjig.draw(LineSeg(ptStart,ptJig));
		// delete mode is selected
		// show the closest selected point
		int nExistPointsFound = -1;
		int nNewPointsFound = -1;
		double dMin = 10e19;
		for (int iEx=0;iEx<ptsExist.length();iEx++) 
		{ 
			double dI=(ptsExist[iEx]-ptJig).length();
			if(dI<dMin)
			{ 
				dMin=dI;
				nExistPointsFound=iEx;
			}
		}//next iEx
		for (int iNew=0;iNew<pts.length();iNew++) 
		{ 
			double dI=(pts[iNew]-ptJig).length(); 
			if(dI<dMin)
			{ 
				dMin=dI;
				nNewPointsFound=iNew;
				nExistPointsFound=-1;
			}
		}//next iNew
		
		Point3d ptDelete=ptJig;
		if(nExistPointsFound>-1)
			ptDelete=ptsExist[nExistPointsFound];
		if(nNewPointsFound>-1)
			ptDelete=pts[nNewPointsFound];
			
		PLine plcircle(vecView);
		plcircle.createCircle(ptDelete,vecView,U(20));
		PlaneProfile ppCircle(Plane(ptDelete,vecView));
		ppCircle.joinRing(plcircle,_kAdd);
		dpjig.color(1);
		dpjig.draw(ppCircle,_kDrawFilled);
	}
	
	return;
}

//End Jigging//endregion
String arSTrigger[] = 
{	
	T("|Copy comment to Element(s)|"),
	T("|Copy all comments to Element(s)|"),
	"------------------------------------------",
	T("|Edit comment|"),
	"-------------------------------------------",
	T("|Erase comment from Element|"),
	T("|Erase all comments from Element|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContextRoot, arSTrigger[i] );

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	PrEntity elementSelectionSet(T("|Select a set of elements|"), Element());
	if (elementSelectionSet.go())
	{
		Element selectedElements[] = elementSelectionSet.elementSet();
		
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
		
		for (int e = 0; e < selectedElements.length(); e++)
		{
			Element selectedElement = selectedElements[e];
			if ( ! selectedElement.bIsValid()) continue;
			
			// Remove existing comment displays.
			TslInst attachedTsls[] = selectedElement.tslInst();
			for (int t = 0; t < attachedTsls.length(); t++)
			{
				TslInst tsl = attachedTsls[t];
				if (tsl.scriptName() == strScriptName)
				{
					tsl.dbErase();
				}
			}
			
			lstEntities[0] = selectedElement;
			
			Map commentsMap = selectedElement.subMapX(commentsMapKey);
			Map comments = commentsMap.getMap(commentsKey);
			for (int c = 0; c < comments.length(); c++)
			{
				Map comment = comments.getMap(c);
				mapTsl.setString(commentIdKey, comment.getString(commentIdKey));
				
				TslInst tslNew;
				tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			}
		}
	}
	
	eraseInstance();
	return;
}
String commentId = _Map.getString(commentIdKey);
if (_Element.length()==0)
{
	eraseInstance();
	return;
}

if(_kExecuteKey == arSTrigger[0])
{
	Element originalElement = _Element[0];
	PrEntity sse("\n"+T("|Select an element(s) to which this comment should be copied.|"), Element());
	Element elems[0];
	if (sse.go()) elems.append(sse.elementSet().filterValid());
	if (!elems.length())
	{
		reportMessage("\n" + T("No elements found!"));
		return;
	}
	for (int t = 0; t < elems.length(); t++) {
		Element newElement = elems[t];
		// Get the element MapX data (if it exists)
		Map commentsMap = originalElement.subMapX(commentsMapKey);
		Map newMapX = newElement.subMapX(commentsMapKey);
		Map newCommentsMap = newMapX.getMap(commentsKey);
		String oldCommentId = _Map.getString(commentIdKey);
		Map comments = commentsMap.getMap(commentsKey);
		Map newComment;
		
		//Get the selected comment to append to the element MapX
		for (int c = 0; c < comments.length(); c++)
		{
			Map thisComment = comments.getMap(c);
			if (oldCommentId == thisComment.getString(commentIdKey))
			{
				newComment = thisComment;
				break;
			}
		}
		
		//Create a new GUID for the copied comment
		String newCommentId = createNewGuid();
		newComment.removeAt(commentIdKey, true);
		newComment.setString(commentIdKey, newCommentId);
		
		CoordSys toNewElement;
		toNewElement.setToAlignCoordSys(	originalElement.ptOrg(), originalElement.vecX(), originalElement.vecY(), originalElement.vecZ(),
		newElement.ptOrg(), newElement.vecX(), newElement.vecY(), newElement.vecZ());
		
		newComment.transformBy(toNewElement);
		
		//Append new data to new comment and add to the element SubMapX
		newCommentsMap.appendMap(commentKey, newComment);
		newMapX.setMap(commentsKey, newCommentsMap);
		newElement.setSubMapX(commentsMapKey, newMapX);
		
		//Create the comment display tsl
		String strScriptName = scriptName();
		Vector3d vecUcsX(1, 0, 0);
		Vector3d vecUcsY(0, 1, 0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setString(commentIdKey, newComment.getString(commentIdKey));
		
		lstEntities[0] = newElement;
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
	}
}

if(_kExecuteKey == arSTrigger[1])
{
	//Get Original element to get all the comments.
	Element originalElement = _Element[0];
	PrEntity sse("\n"+T("|Select an element(s) to which all the comments should be copied.|"), Element());
	Element elems[0];
	if (sse.go()) elems.append(sse.elementSet().filterValid());
	if (!elems.length())
	{
		reportMessage("\n" + T("No elements found!"));
		return;
	}	
	for (int t = 0; t < elems.length(); t++) {
		Element newElement = elems[t];
		//Get MapX data of the original Element.
		Map commentsMap = originalElement.subMapX(commentsMapKey);
		Map newMapX;
		Map newCommentsMap;
		Map comments = commentsMap.getMap(commentsKey);
		for (int c = 0; c < comments.length(); c++)
		{
			Map comment = comments.getMap(c);
			
			//Create a new GUID for the comment
			String commentId = createNewGuid();
			comment.removeAt(commentIdKey, true);
			comment.setString(commentIdKey, commentId);
			
			CoordSys toNewElement;
			toNewElement.setToAlignCoordSys(	originalElement.ptOrg(), originalElement.vecX(), originalElement.vecY(), originalElement.vecZ(),
			newElement.ptOrg(), newElement.vecX(), newElement.vecY(), newElement.vecZ());
			
			comment.transformBy(toNewElement);
			
			//Append new location and new comments to the map.
			newCommentsMap.appendMap(commentKey, comment);
		}
		newMapX.setMap(commentsKey, newCommentsMap);
		newElement.setSubMapX(commentsMapKey, newMapX);
		
		for (int comm = 0; comm < newCommentsMap.length(); comm++)
		{
			//Create the comment display TSL for each newly added comment
			String strScriptName = scriptName();
			Vector3d vecUcsX(1, 0, 0);
			Vector3d vecUcsY(0, 1, 0);
			Beam lstBeams[0];
			Entity lstEntities[1];
			
			Point3d lstPoints[1];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			Map mapTsl;
			
			lstEntities[0] = newElement;
			Map comment = newCommentsMap.getMap(comm);
			mapTsl.setString(commentIdKey, comment.getString(commentIdKey));
			
			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
		}
	}
}

if (_kExecuteKey == arSTrigger[6])
{
	Element originalElement = _Element[0];
	TslInst commentOthers[] = TslInst().filterAcceptedEntities(originalElement.tslInst(), "(Scriptname == '"+scriptName()+"')");
	for (int c=0; c<commentOthers.length(); c++) {
		TslInst tsl = commentOthers[c];
		if (tsl != _ThisInst)
			tsl.dbErase();
	}
	originalElement.removeSubMapX(commentsMapKey);
	eraseInstance();
	return;
}

if (_kExecuteKey == arSTrigger[5])
{
	Element originalElement = _Element[0];
	Map commentsMap = originalElement.subMapX(commentsMapKey);
	Map comments = commentsMap.getMap(commentsKey);
	for (int c=0; c<comments.length(); c++) {
		Map comment = comments.getMap(c);
		if (commentId == comment.getString(commentIdKey)){
			comments.removeAt(c, false);
			commentsMap.setMap(commentsKey, comments);
			originalElement.setSubMapX(commentsMapKey, commentsMap);
			break;
		}
	}
	commentsMap = originalElement.subMapX(commentsMapKey);
	commentsMap.writeToDxxFile(_kPathDwg + "\\commentTEst.dxx");
	eraseInstance();
	return;
}

double storedHorizontalOffset = _Map.getDouble("HorizontalOffset");
double storedVerticalOffset = _Map.getDouble("VerticalOffset");
int offsetsAreChanged = (storedHorizontalOffset != horizontalOffset) || (storedVerticalOffset != verticalOffset);

int drawAreaCommentFilled = noYes.find(drawAreaCommentFilledProp, 1);
int gripType = gripTypes.find(gripTypeProp,0);

Element el = _Element[0];

_Pt0 = el.ptOrg();
CoordSys elementCoordsys = el.coordSys();
Vector3d elementX = elementCoordsys.vecX();
Vector3d elementY = elementCoordsys.vecY();
Vector3d elementZ = elementCoordsys.vecZ();
Vector3d normal = elementZ;

Display commentDisplay(commentColor);
commentDisplay.textHeight(commentTextHeight);
commentDisplay.addHideDirection(-normal);

Display commentDisplayInside(commentColor);
commentDisplayInside.textHeight(commentTextHeight);
commentDisplayInside.addViewDirection(-normal);

Display commentDisplayLocation(commentColor);
commentDisplayLocation.textHeight(commentTextHeight);
commentDisplayLocation.addHideDirection(normal);

String doubleClick= "TslDoubleClick";
addRecalcTrigger(_kContextRoot, arSTrigger[3]);
if (_kExecuteKey == arSTrigger[3] || _kExecuteKey == doubleClick)
{
	// set some export flags
	ModelMapComposeSettings mmFlags;
	
	// compose ModelMap
	ModelMap mm;
	
	Entity ents[] = {el};
	
	mm.setEntities(ents);
	mm.dbComposeMap(mmFlags);
	
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\CadUtilities\\hsbCommentManagement\\hsbCommentManagementUI.dll";
	String strType = "hsbSoft.Cad.UI.CommentManager";
	String editCommentFunction = "EditComment";
	
	Map mapIn;
	Map ids;
	ids.setString(commentIdKey, commentId);
	mapIn.setMap(commentIdsKey, ids);
	mapIn.setMap(modelMapKey, mm.map());
		
//	mapIn.writeToDxxFile("C:\\Temp\\ToCommentManager.dxx");
	Map mapOut;
	mapOut = callDotNetFunction2(strAssemblyPath, strType, editCommentFunction, mapIn);
	
	if (mapOut.hasMap(modelMapKey))
	{
		// set some import flags
		ModelMapInterpretSettings mmImportFlags;
		mmImportFlags.resolveEntitiesByHandle(TRUE); //default FALSE
		
		// interpret ModelMap
		mm.setMap(mapOut.getMap(modelMapKey));
		//mm.writeToDxxFile("C:\\temp\\test.dxx");
		mm.dbInterpretMap(mmImportFlags);
		
		// report the entities imported/updated/modified
		Entity importedEnts[] = mm.entity();
		reportMessage (TN("|Number of entities imported|: ") + importedEnts.length());
	}
}

int commentIndex = - 1;
Map commentsMap = el.subMapX(commentsMapKey);
Map comments = commentsMap.getMap(commentsKey);
Map comment;
for (int c = 0; c < comments.length(); c++)
{
	Map thisComment = comments.getMap(c);
	if (commentId == thisComment.getString(commentIdKey))
	{
		comment = thisComment;
		commentIndex = c;
		if ( ! _Map.getInt("ZoneIndexSet"))
		{
			sZone.set(comment.getInt(zoneIndexKey));
			_Map.setInt("ZoneIndexSet", true);
		}
		break;
	}
}


int nZones[]={ 5,4,3,2,1,0,-1,-2,-3,-4,-5};
int nZone=nZones[sZones.find(sZone)];

//Planee to project the comment
Point3d ptZoneFront;
if (nZone>-1)
	ptZoneFront= el.zone(nZone+1).ptOrg();
else
	ptZoneFront= el.zone(nZone-1).ptOrg();
ptZoneFront.vis(1);
Plane plnZoneFront(ptZoneFront, normal);

int nProjectPoints = false;
if (abs(_ZU.dotProduct(normal))>0.99)
	nProjectPoints = true;

//assignToElementGroup(el, true, 0, 'E');
// HSB-16432
assignToElementGroup(el, true, nZone, 'I');
////if(nZone!=0)
////	assignToElementGroup(el,true,nZone,'E');
////else
////	assignToElementGroup(el,true,nZone,'T');
////
// Change the ID if the element is copied.
String storedHandle = _Map.getString("Handle");
String elementHandle = _Map.getString("ElementHandle");
if (elementHandle != "" && elementHandle != el.handle())
{
	commentId = createNewGuid();
	_Map.setString(commentIdKey, commentId);
	comment.setString(commentIdKey, commentId);
	storedHandle = "";
}
_Map.setString("ElementHandle", el.handle());

// Copy the comment if this comment display turns out to be a copied comment display.
if (storedHandle != "" && storedHandle != _ThisInst.handle())
{
	// Copy the comment, by assigning a new id to it.
	commentId = createNewGuid();
	_Map.setString(commentIdKey, commentId);
	comment.setString(commentIdKey, commentId);
	// ... and appending it to the list of comments.
	comments.appendMap(commentKey, comment);
	commentIndex = comments.length() - 1;
}
_Map.setString("Handle", _ThisInst.handle());


//_PtG.setLength(0);
int resetGripPoints = (_PtG.length() == 0);

Point3d textOrigin = comment.getPoint3d(textOriginKey);
textOrigin = plnZoneFront.closestPointTo(textOrigin);
if (resetGripPoints)
{
	_PtG.append(textOrigin);
}

Map commentLines = comment.getMap(commentLinesKey);
String tags[0];
Map tagsMap = comment.getMap(tagsKey);
for (int t = 0; t < tagsMap.length(); t++)
{
	if (tagsMap.keyAt(t) != tagKey.makeUpper()) continue;
	tags.append(tagsMap.getString(t));
}

Map locationMap = comment.getMap(locationKey);
String geometryType = locationMap.getString(geometryTypeKey);
Map geometryMap = locationMap.getMap(geometryKey);

Point3d geometryOrigin = elementCoordsys.ptOrg();
Vector3d geometryX = elementCoordsys.vecX();
Vector3d geometryY = elementCoordsys.vecY();

int horizontalTextAlignment = (comment.getInt(horizontalTextAlignmentKey) - 1) * -1; // 0 = Right, 1 = Center, 2 = Left
int verticalTextAlignment = (comment.getInt(verticalTextAlignmentKey) - 1) * -1; // 0 = Top, 1 = Center, 2 = Bottom

Vector3d textDirection = comment.getVector3d(textOrienationKey);
int textOrientation = textOrientations.find(textOrientationProp, 0);
if (textOrientation == 1)
{
	textDirection = geometryX;
}
else if (textOrientation == 2)
{
	textDirection = elementX;
}
else if (textOrientation == 3)
{
	textDirection = elementY;
}
else if (textOrientation == 4)
{
	textDirection = geometryY;
}

if (geometryType == "Area")
{
	PLine areaOutline(elementZ);
	if (_Map.hasPLine(locationKey))
	{
		areaOutline = _Map.getPLine(locationKey);
	}
	else
	{
		areaOutline = geometryMap.getPLine(locationKey);
	}
	areaOutline.projectPointsToPlane(plnZoneFront, elementZ);
	_Map.setPLine(locationKey, areaOutline);
	
	PlaneProfile areaProfile(areaOutline);
	
	// Get the points based on the 'grip-type'. Corner or edge points.
	Point3d areaGrips[0];
	if ( gripType == 0 )
	{
		areaGrips.append(areaProfile.getGripEdgeMidPoints());
	}
	else if ( gripType == 1 )
	{
		areaGrips.append(areaProfile.getGripVertexPoints());
	}

// Reset the list of grippoints if one of the related properties is changed.
	if (_kNameLastChangedProp == T("|Active grippoints|") )
	{
		Point3d textOrigin = _PtG[0];
		textOrigin = plnZoneFront.closestPointTo(textOrigin);
		_PtG.setLength(0);
		_PtG.append(textOrigin);
	}

// Set the grippoints.
	if ( _PtG.length() == 1 )
	{
		_PtG.append(areaGrips);
	}

// Update the planeprofile if one of the grippoints is moved.
	if ( _kNameLastChangedProp.left(4) == "_PtG" && _kNameLastChangedProp.right(2) != "G0") 
	{
		int indexMovedGrip = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
		int movedSuccessfully = false;
		//_PtG[indexMovedGrip] = areaProfile.closestPointTo(_PtG[indexMovedGrip]);
		if ( gripType == 0 )
		{
			movedSuccessfully = areaProfile.moveGripEdgeMidPointAt(indexMovedGrip - 1, _PtG[indexMovedGrip] - areaGrips[indexMovedGrip - 1]);
		}
		else if ( gripType == 1 )
		{
			movedSuccessfully = areaProfile.moveGripVertexPointAt(indexMovedGrip - 1, _PtG[indexMovedGrip] - areaGrips[indexMovedGrip - 1]);
		}
	}
	
	commentDisplay.draw(areaProfile, drawAreaCommentFilled ? _kDrawFilled : _kDrawAsCurves, opacityAreaComment);
	commentDisplayInside.draw(areaProfile, drawAreaCommentFilled ? _kDrawFilled : _kDrawAsCurves, opacityAreaComment);
	PLine areaOutlines[] = areaProfile.allRings();
	if(areaOutlines.length() > 0)
	{
		areaOutline = areaOutlines[0];
	}
	
	geometryMap.setPLine(locationKey, areaOutline);
	
	geometryOrigin = Body(areaOutline, normal, 0).ptCen();
}
else if (geometryType == "Line")
{
	Point3d start = geometryMap.getPoint3d(startPointKey);
	start=plnZoneFront.closestPointTo(start);
	Point3d end = geometryMap.getPoint3d(endPointKey);
	end=plnZoneFront.closestPointTo(end);
		
	if (resetGripPoints)
	{
		_PtG.append(start);
		_PtG.append(end);
	}
	
	if (_PtG.length() < 3)
	{
		reportNotice("|Invalid line selected.|");
		eraseInstance();
		return;
	}
	LineSeg line(_PtG[1], _PtG[2]);
	commentDisplay.draw(line);
	commentDisplayLocation.draw(line);
	
	geometryMap.setPoint3d(startPointKey, _PtG[1]);
	geometryMap.setPoint3d(endPointKey, _PtG[2]);
	
	geometryOrigin = (_PtG[1] + _PtG[2]) / 2;
	
	geometryX = Vector3d(_PtG[2] - _PtG[1]);
	geometryX.normalize();
	geometryY = normal.crossProduct(geometryX);
}
else if (geometryType == "Point")
{
	Point3d point = geometryMap.getPoint3d(locationKey);
	point=plnZoneFront.closestPointTo(point);
	if (_PtG.length() < 2)
	{
		_PtG.append(point);
	}
	
	double pointSize = U(5);
	
	PLine rectangle(elementZ);
	rectangle.createRectangle(LineSeg(_PtG[1] - (elementX + elementY) * pointSize, _PtG[1] + (elementX + elementY) * pointSize), elementX, elementY);
	commentDisplay.draw(rectangle);
	commentDisplayLocation.draw(rectangle);
	Vector3d directions[] = { elementX, elementY, - elementX, - elementY};
	for (int d=0;d<directions.length();d++)
	{
		Vector3d direction = directions[d];
		PLine crossHair(_PtG[1] + direction * pointSize, _PtG[1] + direction * 5 * pointSize);
		commentDisplay.draw(crossHair);
		commentDisplayLocation.draw(crossHair);
	}
	
	geometryMap.setPoint3d(locationKey, _PtG[1]);
	geometryOrigin = _PtG[1];
}
else if (geometryType == "Leader")
{
	PLine pline = geometryMap.getPLine(leaderKey);
	pline.projectPointsToPlane(plnZoneFront, elementZ);
	Point3d vertexPts[] = pline.vertexPoints(true);

	if ( _PtG.length() == 1 )
	{
		_PtG.append(vertexPts);
	}
	else 
	{
		PLine pl(pline.coordSys().vecZ());
		// Remove duplicate points
		Point3d referencePoints[] = { _PtG[0]};
		for (int i = 1; i < _PtG.length(); i++)
		{
			for (int r = 0; r < referencePoints.length(); r++)
			{
				if ((referencePoints[r] - _PtG[i]).length() < pointTolerance)
				{
					_PtG.removeAt(i);
					i--;
					break;
				}
			}
			referencePoints.append( _PtG[i]);
			if(_Map.hasPoint3dArray("pts") && i==3)break;
			pl.addVertex(_PtG[i]);
		}
		// The pline requires at least 2 vertices. If it doesn't have 2 vertices we will restore the leader with its previously stored pline.
		if (pl.vertexPoints(true).length() < 2 || _PtG.length()  < 3)
		{
			Point3d location = _PtG[0];
			_PtG.setLength(0);
			_PtG.append(location);
			_PtG.append(vertexPts);
		}
		else // Update the pline with the current grip point locations.
		{
			pline = pl;
		}
	}
	if (_PtG.length()  < 3)
	{
		reportNotice("|Invalid leader selected.|");
		eraseInstance();
		return;
	}
	
	// Drawing the landing line from the last point in the text direction.
	Point3d landingStartPt = _PtG.last();
	Point3d lastButOnePt = _PtG[_PtG.length() - 2];
	if(_Map.hasPoint3dArray("pts"))
	{ 
		landingStartPt = _PtG[2];
		lastButOnePt = _PtG[1];
	}
	Vector3d vecZ(0, 0, 1);
	Vector3d vecDir = geometryX;
	
	double d1 = elementX.dotProduct(landingStartPt - elementCoordsys.ptOrg());
	double d2 = elementX.dotProduct(lastButOnePt - elementCoordsys.ptOrg());
	if (d1 < d2) 
	{
		vecDir *= -1;
		horizontalTextAlignment *= -1;
	}
	Point3d landingEndPt = landingStartPt + vecDir * U(100);
	LineSeg landingLine(landingStartPt, landingEndPt);
	commentDisplay.draw(landingLine);
	commentDisplayLocation.draw(landingLine);
	_PtG[0] = landingEndPt;
	
	geometryOrigin = _PtG[0] ;
	commentDisplay.draw(pline);
	commentDisplayLocation.draw(pline);
	geometryMap.setPLine(leaderKey, pline);
	
	// Add an arrow to the start if only two points in pline.
	if (vertexPts.length() == 2) 
	{
		double dArrowL=U(20);
		dArrowL= dLeaderSize;
		double dArrowW=U(10);
		dArrowW=.5*dLeaderSize;
		Point3d pts[]=_Map.getPoint3dArray("pts");
//		if(pts.length()>0)
		{ 
			if(_PtG.length()==3)
				_PtG.append(pts);
			for (int i=0;i<_PtG.length()-3;i++) 
			{ 
				commentDisplay.draw(LineSeg(_PtG[0],_PtG[3+i]));
				commentDisplayLocation.draw(LineSeg(_PtG[0],_PtG[3+i]));
				_PtG[3+i].vis(3);
				Vector3d vecLine(_PtG[3+i]-_PtG[0]);
				vecLine*=-1;
				vecLine.normalize();
				vecLine.vis(_PtG[3+i]);
				Vector3d vecX(1,0,0);
				Vector3d vecY=vecLine.crossProduct(normal);
				vecY.normalize();
				
				Point3d pt1=_PtG[3+i]+vecLine*dArrowL+vecY*dArrowW;
				Point3d pt2=_PtG[3+i]+vecLine*dArrowL-vecY*dArrowW;
				LineSeg line1(_PtG[3+i],pt1);
				commentDisplay.draw(line1);
				commentDisplayLocation.draw(line1);
				LineSeg line2(_PtG[3+i],pt2);
				commentDisplay.draw(line2);
				commentDisplayLocation.draw(line2);
			}//next i
		}
		// 
		dLeaderSize.setReadOnly(false);
		
		
		Vector3d vecLine(_PtG[2] - _PtG[1]);
		vecLine.normalize();
	
		Vector3d vecX(1, 0, 0);
		Vector3d vecY = vecLine.crossProduct(normal);
		vecY.normalize();
		Point3d pt1=_PtG[1]+vecLine*dArrowL+vecY*dArrowW;
		Point3d pt2=_PtG[1]+vecLine*dArrowL-vecY*dArrowW;
	
		LineSeg line1(_PtG[1],pt1);
		commentDisplay.draw(line1);
		commentDisplayLocation.draw(line1);
		LineSeg line2(_PtG[1],pt2);
		commentDisplay.draw(line2);
		commentDisplayLocation.draw(line2);
		
		// trigger to add extra leaders "Add leader"
	//region Trigger Add leader
		String sTriggerAddLeader = T("|Add/Remove leader|");
		addRecalcTrigger(_kContextRoot, sTriggerAddLeader );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddLeader)
		{
			String sStringStart = "|Add point or [";
			String sDelete = "Delete/Finish]|";
			String sStringStartDelete = "|Remove point or [";
			String sAdd = "Add/Finish]|";
			String sStringStart2 = "|Add point or [";
			String sStringStart2Delete = "|Remove point or [";
			String sStringOption = "Undo/Remove/Finish]|";
			String sStringOptionDelete = "Undo/Add/Finish]|";
			
			String sStringPrompt = T(sStringStart+sDelete);
		// prompt for point input
			PrPoint ssP(sStringPrompt); 
			Map mapArgs;
			int nGoJig = -1;
			
			// new points to be added
			Point3d _pts[0];
			// existing points
			Point3d ptsExist[0];
			for (int ip=3;ip<_PtG.length();ip++) 
			{ 
				ptsExist.append(_PtG[ip]);
			}//next ip
			
		// End of line is _PtG[1]
			
			mapArgs.setPoint3d("ptStart",_PtG[0]);
			mapArgs.setPoint3dArray("ptsExist",ptsExist);
			// insertion mode
			int nModeJig = 0;
			mapArgs.setInt("ModeJig",nModeJig);
			mapArgs.setPoint3d("ptG1",_PtG[1]);
			int nStart = true;
			
			Point3d ptsRemovedExist[0];
			Point3d ptsRemovedNews[0];
			int iLastRemovedExistNew = 0;
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast=Line(ptLast,vecView).intersect(Plane(_PtG[1],vecView),U(0));
					if(nModeJig==0)
					{ 
					// insertion mode
						_pts.append(ptLast);
						mapArgs.setPoint3dArray("pts",_pts);
						if(_pts.length()>0)
						{ 
							String sStringPrompt = sStringStart2+sStringOption;
							ssP = PrPoint(sStringPrompt);
							nStart = false;
						}
					}
					else if(nModeJig==1)
					{ 
					// delete mode
						int nExistPointsFound = -1;
						int nNewPointsFound = -1;
						double dMin = 10e9;
						for (int iEx=0;iEx<ptsExist.length();iEx++) 
						{ 
							double dI=(ptsExist[iEx]-ptLast).length();
							if(dI<dMin)
							{ 
								dMin=dI;
								nExistPointsFound=iEx;
								
							}
						}//next iEx
						for (int iNew=0;iNew<_pts.length();iNew++) 
						{ 
							double dI=(_pts[iNew]-ptLast).length(); 
							if(dI<dMin)
							{ 
								dMin=dI;
								nNewPointsFound=iNew;
								nExistPointsFound=-1;
								
							}
						}//next iNew
						if(nExistPointsFound>-1)
						{
							ptsRemovedExist.append(ptsExist[nExistPointsFound]);
							ptsExist.removeAt(nExistPointsFound);
							iLastRemovedExistNew = 0;
						}
						if(nNewPointsFound>-1)
						{
							ptsRemovedNews.append(_pts[nNewPointsFound]);
							_pts.removeAt(nNewPointsFound);
							iLastRemovedExistNew = 1;
						}
							
						mapArgs.setPoint3dArray("ptsExist",ptsExist);
						mapArgs.setPoint3dArray("pts",_pts);
					}
				}
				else if(nGoJig==_kKeyWord)
				{ 
					if (ssP.keywordIndex()==0)
					{
					// Undo is selected
						if(nModeJig==0)
						{ 
							// Add mode
							if(nStart)
							{ 
								// we are in start add
								// remove is selected
								String sStringPrompt = sStringStartDelete+sAdd;
								ssP = PrPoint(sStringPrompt);
								nModeJig = 1;
								mapArgs.setInt("ModeJig",nModeJig);
							}
							else if(!nStart)
							{ 
								// we are in add undo is slected
								// Undo os selected
								if(_pts.length()>0)
								{
									_pts.removeAt(_pts.length()-1);
								}
								mapArgs.setPoint3dArray("pts",_pts);
								if(_pts.length()==0)
								{ 
									String sStringPrompt=sStringStart+sDelete;
									ssP = PrPoint(sStringPrompt);
									nStart = true;
								}
							}
						}
						else if(nModeJig==1)
						{ 
							// we are in remove
							if(nStart)
							{ 
								// we are in start remove
								// add is selected
								String sStringPrompt = sStringStart+sDelete;
								ssP = PrPoint(sStringPrompt);
								nModeJig = 0;
								mapArgs.setInt("ModeJig",nModeJig);
							}
							else if(!nStart)
							{ 
								// we are in remove and undo is selected
								if(ptsRemovedExist.length()>0 || ptsRemovedExist.length()>0)
								{ 
									if(iLastRemovedExistNew==0)
									{ 
										// last deleted point was existing
										ptsExist.append(ptsRemovedExist.last());
										ptsRemovedExist.removeAt(ptsRemovedExist.length()-1);
									}
									else if(iLastRemovedExistNew==1)
									{ 
										// last deleted point was from new points
										_pts.append(ptsRemovedNews.last());
										ptsRemovedNews.removeAt(ptsRemovedNews.length()-1);
									}
									mapArgs.setPoint3dArray("ptsExist",ptsExist);
									mapArgs.setPoint3dArray("pts",_pts);
									if(ptsRemovedExist.length()==0 && ptsRemovedExist.length()==0)
									{ 
										String sStringPrompt=sStringStartDelete+sAdd;
										ssP = PrPoint(sStringPrompt);
										nStart = true;
									}
								}
								
							}
						}
					}
					else if(ssP.keywordIndex()==1)
					{ 
						if(!nStart)
						{ 
						// Add or Remove is selected
						
							// remove or add is choosen
							if(nModeJig==0)
							{ 
								// we are in add and remove is selected
								String sStringPrompt=sStringStart2Delete+sStringOptionDelete;
								ssP=PrPoint(sStringPrompt);
								nModeJig=1;
								mapArgs.setInt("ModeJig",nModeJig);
							}
							else if(nModeJig==1)
							{ 
								String sStringPrompt=sStringStart2+sStringOption;
								ssP=PrPoint(sStringPrompt);
								nModeJig=0;
								mapArgs.setInt("ModeJig",nModeJig);
							}
						}
						else if(nStart)
						{ 
						// Finish is selected
							nGoJig = _kNone;
							_Map.setPoint3dArray("pts",_pts);
							// modify grip points
		//					int nGripsKeep[_PtG.length()-3];
							int nGripsKeep[0];
							nGripsKeep.setLength(_PtG.length()-3);
							int nKeeps = 0;
							for (int ig=_PtG.length()-1; ig>=3 ; ig--) 
							{ 
								for (int jp=ptsExist.length()-1; jp>=0 ; jp--) 
								{ 
									if((ptsExist[jp]-_PtG[ig]).length()<dEps)
									{ 
										nGripsKeep[ig-3]=true;
										nKeeps+=1;
										ptsExist.removeAt(jp);
										break;
									}
								}//next jp
							}//next ig
							
							for (int ig=_PtG.length()-1; ig>=3 ; ig--) 
							{ 
								if(nGripsKeep[ig-3]==0)
								{ 
									_PtG.removeAt(ig);
								}
							}//next ig
							if(_pts.length()>0)
							{
								_PtG.append(_pts);
							}
							if(_PtG.length()==3)
							{ 
								_Map.removeAt("pts",true);
							}
						}
					}
					else if(ssP.keywordIndex()==2)
					{ 
						_Map.setPoint3dArray("pts",_pts);
						// modify grip points
	//					int nGripsKeep[_PtG.length()-3];
						int nGripsKeep[0];
						nGripsKeep.setLength(_PtG.length()-3);
						int nKeeps = 0;
						for (int ig=_PtG.length()-1; ig>=3 ; ig--) 
						{ 
							for (int jp=ptsExist.length()-1; jp>=0 ; jp--) 
							{ 
								if((ptsExist[jp]-_PtG[ig]).length()<dEps)
								{ 
									nGripsKeep[ig-3]=true;
									nKeeps+=1;
									ptsExist.removeAt(jp);
									break;
								}
							}//next jp
						}//next ig
						for (int ig=_PtG.length()-1; ig>=3 ; ig--) 
						{ 
							if(nGripsKeep[ig-3]==0)
							{ 
								_PtG.removeAt(ig);
							}
						}//next ig
						
						if(_pts.length()>0)
						{
							_PtG.append(_pts);
						}
						if(_PtG.length()==3)
						{ 
							_Map.removeAt("pts",true);
						}
						nGoJig = _kNone;
					}
				}
				else if(nGoJig==_kCancel)
				{ 
					nGoJig = _kNone;
				}
				else if(nGoJig==_kNone)
				{ 
				// confirm
					_Map.setPoint3dArray("pts",_pts);
					// modify grip points
//					int nGripsKeep[_PtG.length()-3];
					int nGripsKeep[0];
					nGripsKeep.setLength(_PtG.length()-3);
					int nKeeps = 0;
					for (int ig=_PtG.length()-1; ig>=3 ; ig--) 
					{ 
						for (int jp=ptsExist.length()-1; jp>=0 ; jp--) 
						{ 
							if((ptsExist[jp]-_PtG[ig]).length()<dEps)
							{ 
								nGripsKeep[ig-3]=true;
								nKeeps+=1;
								ptsExist.removeAt(jp);
								break;
							}
						}//next jp
					}//next ig
					
					for (int ig=_PtG.length()-1; ig>=3 ; ig--) 
					{ 
						if(nGripsKeep[ig-3]==0)
						{ 
							_PtG.removeAt(ig);
						}
					}//next ig
					if(_pts.length()>0)
					{
						_PtG.append(_pts);
					}
					if(_PtG.length()==3)
					{ 
						_Map.removeAt("pts",true);
					}
				}
			}
			
			setExecutionLoops(2);
			return;
		}//endregion
		
	}
	else
		dLeaderSize.setReadOnly(true);
}
else
{
////	 No location. Nothing to draw.
	eraseInstance();
	return;
}

if (offsetsAreChanged)
{
	_PtG[0]=geometryOrigin+geometryX*horizontalOffset+geometryY*verticalOffset;
}

geometryX.vis(_PtG[0], 1);
geometryY.vis(_PtG[0], 3);

locationMap.setMap(geometryKey, geometryMap);
comment.setMap(locationKey, locationMap);

Vector3d textUpDirection = normal.crossProduct(textDirection);

// Note: the visualisation is only affecting text.
int visualisation = comment.getInt(visualisationKey); // 0 = Visible, 1 = Collapsed, 2 = None

_ThisInst.setAllowGripAtPt0(false);

String linesToDisplay[0];
for (int l = 0; l < commentLines.length(); l++)
{
	String s = commentLines.keyAt(l).makeLower();
	if ( commentLines.keyAt(l).makeLower() != commentLineKey.makeLower()) continue;
	linesToDisplay.append(commentLines.getString(l));
}

if (visualisation == 0)
{
	for (int l = 0; l < linesToDisplay.length(); l++)
	{
		double verticalFlag = verticalTextAlignment;
		if (verticalTextAlignment == 0)
		{
			verticalFlag += (0.5 * linesToDisplay.length() - l - 0.5) * 3;
		}
		else if (verticalTextAlignment > 0)
		{
			verticalFlag += (linesToDisplay.length() - 1 - l) * 3;
		}
		else
		{
			verticalFlag = verticalTextAlignment - l * 3;
		}
		
		String commentLine = linesToDisplay[l];
		commentDisplay.draw(commentLine, _PtG[0], textDirection, textUpDirection, horizontalTextAlignment, verticalFlag);
		commentDisplayInside.draw(commentLine, _PtG[0], textDirection, textUpDirection, horizontalTextAlignment, verticalFlag, _kDevice);
	}
}
else if (visualisation == 1)
{
	double collapsedRadius = U(50);
	PLine circle(elementZ);
	circle.createCircle(_PtG[0], elementZ, collapsedRadius);
	PlaneProfile collapsedSymbol(elementCoordsys);
	collapsedSymbol.joinRing(circle, _kAdd);

	PLine dot(elementZ);
	dot.createCircle(_PtG[0] + elementY * 0.5 * collapsedRadius, elementZ,  0.2* collapsedRadius);
	collapsedSymbol.joinRing(dot, _kSubtract);
	
	PLine infoBar(elementZ);
	infoBar.createRectangle(LineSeg(_PtG[0] - elementX * 0.2 * collapsedRadius - elementY * 0.7 * collapsedRadius, _PtG[0] + elementX * 0.2 * collapsedRadius + elementY * 0.2 * collapsedRadius), elementX, elementY);
	collapsedSymbol.joinRing(infoBar, _kSubtract);
	
	PlaneProfile infoSymbol(elementCoordsys);
	infoSymbol.joinRing(dot, _kAdd);
	infoSymbol.joinRing(infoBar, _kAdd);
	
	Display collapsedDisplay = commentDisplay;
	collapsedDisplay.color(5);
	collapsedDisplay.draw(collapsedSymbol, _kDrawFilled);
	collapsedDisplay.color(255);
	collapsedDisplay.draw(infoSymbol, _kDrawFilled);
}


comment.setPoint3d(textOriginKey, _PtG[0]);
comment.setVector3d(textOrienationKey, textDirection);
comment.setInt(zoneIndexKey, nZone);
comments.appendMap(commentKey, comment);
comments.removeAt(commentIndex, false);
commentsMap.setMap(commentsKey, comments);
el.setSubMapX(commentsMapKey, commentsMap);

double currentHorizontalOffset = geometryX.dotProduct(_PtG[0] - geometryOrigin);
horizontalOffset.set(currentHorizontalOffset);
_Map.setDouble("HorizontalOffset", currentHorizontalOffset);
double currentVerticalOffset = geometryY.dotProduct(_PtG[0] - geometryOrigin);
verticalOffset.set(currentVerticalOffset);
_Map.setDouble("VerticalOffset", currentVerticalOffset);

textOrientationProp.set(textOrientations[0]);











#End
#BeginThumbnail




























#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
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
      <str nm="Comment" vl="Make sure when a comment is copied, all props are also set to match the original tsl" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="11/28/2024 9:35:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Hardcode option to see area from back with inside display" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="2/8/2024 9:50:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to show lines and area from the back" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="11/22/2023 12:05:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Align the comment to the front of the zone and fix issue with the zone assignement." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="11/29/2022 10:55:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17074: Change opacity to transparency" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="11/28/2022 8:59:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add support for zone index, which is now part of the Comment." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="11/24/2022 9:49:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16441: Add command &quot;Add/Remove leader&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="10/6/2022 7:42:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16441: support leader size" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="10/5/2022 9:39:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Use CommentManagementUI instead of CommentManagement." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="9/28/2022 11:44:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Remove All Comments | Also remove comments that were removed by ACA delete. TODO: Remove all SubMapX interaction from tsl. Use comment management instead." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="9/28/2022 7:54:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16432: add property zone to assign it to a particular zone" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="9/6/2022 11:34:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added triggers to erase coment(s) from element" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="5/18/2022 12:50:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Changed copy comment dialogs to work with multiple selection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="5/18/2022 12:03:23 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End