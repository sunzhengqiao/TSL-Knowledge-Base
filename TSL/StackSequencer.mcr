#Version 8
#BeginDescription
Last modified by: Anno Sportel support.nl@hsbcad.com)
13.01.2021  -  version 1.06

1.7 09/12/2021 Trigger all grouping info tsls in the drawing. Author: Anno Sportel
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates production sequence lines with arrows which indicate the sequence.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.06" date="13.01.2021"></version>

/// <history>
/// AS	- 1.00 - 16.07.2019 -	Drawsequence as profile.
/// AS	- 1.01 - 18.07.2019 -	Add options to 'Add', 'Remove' and 'Resequece' items.
/// AS	- 1.02 - 18.09.2019 -	Make this tsl a stacking parent.
/// AS	- 1.03 - 30.10.2019 -	Also make existing stacks a stacking parent.
/// AS	- 1.04 - 30.10.2019 -	Add option to resequence stacks
/// AS	- 1.05 - 31.10.2019 -	Rename to StackSequencer.
/// AS	- 1.06 - 13.01.2021 -	Assign to tooling layer of floorgroup from reference element.
/// </history>

String groupParentKey = "Hsb_StackingParent";
String myUIDKey = "MyUID";
String groupChildKey = "hsb_StackingChild";
String groupingTypeKey = "GroupingType";
String parentUIDKey = "ParentUID";
String contentKey = "Content";
String sequenceKey = "Seq";
String pointsArrayKey = "Points";

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	Entity entities[] = Group().collectEntities(true, Entity(), _kModelSpace);
	
	String groupingTypes[0];
	
	String parentUIDs[0];
	String groupUIDs[0];
	int groupingTypeIndexes[0];
	String sortKeys[0];
	Element elements[0];
	Point3d referencePoints[0];

	for (int e = 0; e < entities.length(); e++)
	{
		Entity entity = entities[e];		
		if ( ! entity.bIsKindOf(Element())) continue;
		
		String mapXKeys[] = entity.subMapXKeys();
		for (int m = 0; m < mapXKeys.length(); m++)
		{
			String mapXKey = mapXKeys[m];
			if (mapXKey.left(4).makeUpper() == "HSB_" && mapXKey.right(5).makeUpper() == "CHILD")
			{
				Map groupingChildMap = entity.subMapX(mapXKey);
				String groupingType = mapXKey.mid(4, mapXKey.length() - 9);
				if (groupingType.makeUpper() != "STACKING") continue;
				int groupingTypeIndex = groupingTypes.find(groupingType);
				if (groupingTypeIndex == -1)
				{
					groupingTypes.append(groupingType);
					groupingTypeIndex = groupingTypes.length() - 1;
				}
				
				groupingTypeIndexes.append(groupingTypeIndex);
				elements.append((Element)entity);
				String parentUID = groupingChildMap.getString(parentUIDKey);
				parentUIDs.append(parentUID);
				Map content = groupingChildMap.getMap(contentKey);
				int sequenceNumber = content.getInt(sequenceKey);
				
				String paddedGroupingTypeIndex;
				paddedGroupingTypeIndex.format("%04s", (String)groupingTypeIndex);
				String paddedParentUID;
				paddedParentUID.format("%09s", parentUID);
				String paddedSequenceNumber;
				paddedSequenceNumber.format("%04s", (String)sequenceNumber);
				groupUIDs.append(parentUID);
				sortKeys.append(paddedGroupingTypeIndex + "_" + paddedParentUID + "_" + paddedSequenceNumber);
				
				Point3d referencePoint = entity.coordSys().ptOrg();
				if (entity.bIsKindOf(Element()))
				{
					Element element = (Element)entity;
					referencePoint = element.segmentMinMax().ptMid();
				}
				referencePoints.append(referencePoint);
			}
		}
	}
	
	for (int s1 = 1; s1 < sortKeys.length(); s1++)
	{
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--)
		{
			if ( sortKeys[s11] < sortKeys[s2] )
			{
				sortKeys.swap(s2, s11);
				parentUIDs.swap(s2, s11);
				groupingTypeIndexes.swap(s2, s11);
				elements.swap(s2, s11);
				groupUIDs.swap(s2, s11);
				referencePoints.swap(s2, s11);
				s11 = s2;
			}
		}
	}
	
	TslInst tslNew;
	String strScriptName = scriptName();
	Vector3d vecUcsX (1, 0, 0);
	Vector3d vecUcsY (0, 1, 0);
	Point3d lstPoints[1];
	Beam lstBeams[0];
	Element lstElements[0];
	int lstPropInt[0];
	double lstPropdouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	Entity existingTsls[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for (int t = 0; t < existingTsls.length(); t++)
	{
		TslInst tsl = (TslInst)existingTsls[t];
		if (tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle())
		{
			tsl.dbErase();
		}
	}
	
	String previousGroupUID = "";
	String previousGroupingType = "";
	Point3d sequencePoints[0];
	Element groupElements[0];
	
	int groupIndex = -1;
	for (int b = 0; b < groupUIDs.length(); b++)
	{
		String parentUID = parentUIDs[b];
		String groupUID = groupUIDs[b];
		String groupingType = groupingTypes[groupingTypeIndexes[b]];
		
		Point3d referencePoint = referencePoints[b];
		Element element = elements[b];
		
		if (previousGroupUID != "" && (groupUID != previousGroupUID || b == groupUIDs.length() - 1))
		{
			if (b == groupUIDs.length() - 1)
			{
				sequencePoints.append(referencePoint);
				groupElements.append(element);
			}
			if (sequencePoints.length() == 0) continue;
			// Create tsl with sequence points
			lstPoints[0] = sequencePoints[0];
			
			lstElements.setLength(0);
			lstElements = groupElements;
			
			mapTsl.setPoint3dArray(pointsArrayKey, sequencePoints);
			mapTsl.setString(parentUIDKey, previousGroupUID);
			mapTsl.setString(groupingTypeKey, previousGroupingType);
			
			tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropdouble, lstPropString, _kModelSpace, mapTsl);
			
			Map stackingParentMap;
			stackingParentMap.setString(myUIDKey, previousGroupUID);
			Map stackingParentContent;
			stackingParentContent.setInt(sequenceKey, ++groupIndex);
			stackingParentMap.setMap(contentKey, stackingParentContent);
			tslNew.setSubMapX(groupParentKey, stackingParentMap);
			
			// Reset list of points
			sequencePoints.setLength(0);
			groupElements.setLength(0);
		}
		
		sequencePoints.append(referencePoint);
		groupElements.append(element);
		
		previousGroupUID = groupUID;
		previousGroupingType = groupingType;
	}
	eraseInstance();
	return;
}

_ThisInst.setAllowGripAtPt0(false);

String groupingType = _Map.getString(groupingTypeKey);
String parentUID = _Map.getString(parentUIDKey);

Map stackingParentMap = _ThisInst.subMapX(groupParentKey);
if ( ! stackingParentMap.hasString(myUIDKey)) 
{
	stackingParentMap.setString(myUIDKey, parentUID);
	
	int lastKnownStackingParentSequence = 0;
	Entity allTsls[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for (int t = 0; t < allTsls.length(); t++)
	{
		TslInst tsl = (TslInst)allTsls[t];
		if (tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle())
		{
			Map otherStackingParentMap = tsl.subMapX(groupParentKey);
			if (otherStackingParentMap.hasMap(contentKey))
			{
				Map otherStackingContent = otherStackingParentMap.getMap(contentKey);
				int otherStackingParentSequence = otherStackingContent.getInt(sequenceKey);
				if (otherStackingParentSequence > lastKnownStackingParentSequence)
				{
					lastKnownStackingParentSequence = otherStackingParentSequence;
				}
			}
		}
	}
	
	Map stackingParentContent;
	stackingParentContent.setInt(sequenceKey, ++lastKnownStackingParentSequence);
	stackingParentMap.setMap(contentKey, stackingParentContent);
	_ThisInst.setSubMapX(groupParentKey, stackingParentMap);
}


String addElementsCommand = T("../|Add elements|");
addRecalcTrigger(_kContext, addElementsCommand);
String removeElementsCommand = T("../|Remove elements|");
addRecalcTrigger(_kContext, removeElementsCommand);
String resequenceElementsCommand = T("../|Resequence elements|");
addRecalcTrigger(_kContext, resequenceElementsCommand);

String resequenceStacksCommand = T("../|Resequence stacks|");
addRecalcTrigger(_kContext, resequenceStacksCommand);

int refreshDrawProductionSequence = false;
if (_kExecuteKey == addElementsCommand || _kExecuteKey == removeElementsCommand || _kExecuteKey == resequenceElementsCommand)
{
	int add = _kExecuteKey == addElementsCommand;
	int remove = _kExecuteKey == removeElementsCommand;
	int resequence = _kExecuteKey == resequenceElementsCommand;
	
	String action = add ? T("|add|") : (remove ? T("|remove|") : T("|resequence|"));
	PrEntity elementSelectionSet(T("|Select elements to| ") + action, Element());
	if (elementSelectionSet.go())
	{
		int lastSequenceNumber = - 1;
		if (add)
		{
			for (int e = 0; e < _Element.length(); e++)
			{
				Element groupElement = _Element[e];
				Map groupData = groupElement.subMapX(groupChildKey);
				Map content = groupData.getMap(contentKey);
				int sequenceNumber = content.getInt(sequenceKey);
				lastSequenceNumber = sequenceNumber > lastSequenceNumber ? sequenceNumber : lastSequenceNumber;
			}
		}
		Point3d pointsArray[] = _Map.getPoint3dArray(pointsArrayKey);
		
		// Add
		Element addedElements[0];
		Point3d addedPoints[0];
		// Resequence
		int resequenceNumber = - 1;
		Element resequencedElements[0];
		Point3d resquencedPoints[0];
		
		Element selectedElements[] = elementSelectionSet.elementSet();
		for (int e = 0; e < selectedElements.length(); e++)
		{
			Element el = selectedElements[e];
			if (add)
			{
				Map content;
				content.setInt(sequenceKey, ++lastSequenceNumber);
				Map groupData;
				groupData.setString(parentUIDKey, parentUID);
				groupData.setMap(contentKey, content);
				el.setSubMapX(groupChildKey, groupData);
				addedElements.append(el);
				addedPoints.append(el.segmentMinMax().ptMid());
			}
			else if (remove)
			{
				if (_Element.find(el) == -1) continue;
				
				Map groupData = el.subMapX(groupChildKey);
				if (groupData.getString(parentUIDKey) != parentUID) continue;

				el.removeSubMapX(groupChildKey);
			}
			else if (resequence)
			{
				if (_Element.find(el) == -1) continue;
				
				Map groupData = el.subMapX(groupChildKey);
				if (groupData.getString(parentUIDKey) != parentUID) continue;
				Map content = groupData.getMap(contentKey);
				content.setInt(sequenceKey, ++resequenceNumber);
				groupData.setMap(contentKey, content);
				el.setSubMapX(groupChildKey, groupData);
								
				resequencedElements.append(el);
				resquencedPoints.append(el.segmentMinMax().ptMid());
			}
		}
		if (add)
		{
			pointsArray.append(addedPoints);
			_Map.setPoint3dArray(pointsArrayKey, pointsArray);
			_Element.append(addedElements);
		}
		else if (resequence)
		{
			for (int e=0;e<_Element.length();e++)
			{
				Element el = _Element[e];
				if (resequencedElements.find(el) == -1)
				{
					Map groupData = el.subMapX(groupChildKey);
					Map content = groupData.getMap(contentKey);
					content.setInt(sequenceKey, resequencedElements.length());
					groupData.setMap(contentKey, content);
					el.setSubMapX(groupChildKey, groupData);
					
					resequencedElements.append(el);
					resquencedPoints.append(el.segmentMinMax().ptMid());
				}
			}
			_Map.setPoint3dArray(pointsArrayKey, pointsArray);
			_Element.append(addedElements);
		}
	}
	
	refreshDrawProductionSequence = true;
}
String groupingInfoTslNames[] = 
{
	"HSB_I-ShowGroupingInformation",
	"Batch & Stack Info"
};

if (_kExecuteKey == resequenceStacksCommand)
{
	
	
	TslInst stacks[0];
	int stackSequences[0];
	
	TslInst groupingInfoTsls[0];
	Entity allTsls[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for (int t = 0; t < allTsls.length(); t++)
	{
		TslInst tsl = (TslInst)allTsls[t];
		String subMapXKeys[] = tsl.subMapXKeys();
		if (subMapXKeys.find(groupParentKey) != -1)
		{
			stacks.append(tsl);
			Map stackingParentMap = tsl.subMapX(groupParentKey);
			Map stackContent = stackingParentMap.getMap(contentKey);
			stackSequences.append(stackContent.getInt(sequenceKey));
		}
		
		if (groupingInfoTslNames.find(tsl.scriptName()) != -1)
		{
			groupingInfoTsls.append(tsl);
		}
	}
	
	for (int s1 = 1; s1 < stackSequences.length(); s1++)
	{
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--)
		{
			if ( stackSequences[s11] < stackSequences[s2] )
			{
				stackSequences.swap(s2, s11);
				stacks.swap(s2, s11);
				s11 = s2;
			}
		}
	}
	
	PrEntity stackSelectionSet(T("|Select stacks to resequence|") , TslInst());
	if (stackSelectionSet.go())
	{
		Entity stackSet[] = stackSelectionSet.set();
		TslInst resequencedStacks[0];
		for (int s = 0; s < stackSet.length(); s++)
		{
			TslInst stack = (TslInst)stackSet[s];
			Map stackingParentMap = stack.subMapX(groupParentKey);
			Map stackContent = stackingParentMap.getMap(contentKey);
			stackContent.setInt(sequenceKey, s);
			stackingParentMap.setMap(contentKey, stackContent);
			stack.setSubMapX(groupParentKey, stackingParentMap);
			
			resequencedStacks.append(stack);
		}
		
		for (int s=0;s<stacks.length();s++)
		{
			TslInst stack = stacks[s];
			if (resequencedStacks.find(stack) != -1) continue;
			
			Map stackingParentMap = stack.subMapX(groupParentKey);
			Map stackContent = stackingParentMap.getMap(contentKey);
			stackContent.setInt(sequenceKey, resequencedStacks.length());
			stackingParentMap.setMap(contentKey, stackContent);
			stack.setSubMapX(groupParentKey, stackingParentMap);
			
			resequencedStacks.append(stack);
		}
	}
	
	for (int g = 0; g < groupingInfoTsls.length(); g++)
	{
		TslInst groupingInfo = groupingInfoTsls[g];
		if (groupingInfo.bIsValid())
		{
			groupingInfo.recalc();
		}
	}
}


if (_Map.hasPoint3dArray(pointsArrayKey))
{
	Point3d pointsArray[] = _Map.getPoint3dArray(pointsArrayKey);
	Element elements[0];
	elements.append(_Element);
	
	if (elements.length() > 0)
	{
		Element referenceElement = elements[0];
		assignToElementFloorGroup(referenceElement, true, 0, 'T');
	}
	
	Display dp(40);
	
	double arrowLength = U(150);
	double arrowWidth = U(65);
	double lineWidth = U(25);
	
	PlaneProfile sequenceProfile(CoordSys(_PtW, _XW, _YW, _ZW));
	for (int p = 1; p < pointsArray.length(); p++)
	{
		Point3d from = pointsArray[p - 1];
		Point3d to = pointsArray[p];
		Point3d mid = (from + to)/2;
		
		Vector3d segmentX(to - from);
		segmentX.normalize();
		Vector3d segmentY = _ZW.crossProduct(segmentX);
		
		double radius = p == 1 ? U(65) : U(35);
		PLine circle(_ZW);
		circle.createCircle(from, _ZW, radius);
		PlaneProfile circleProfile(circle);
		sequenceProfile.unionWith(circleProfile);
				
		LineSeg segment(from - segmentY * 0.5 * lineWidth, to + segmentY * 0.5 * lineWidth);
		PLine rectangle(_ZW);
		rectangle.createRectangle(segment, segmentX, segmentY);
		PlaneProfile rectangleProfile(rectangle);
		sequenceProfile.unionWith(rectangleProfile);
		
		PLine arrow(_ZW);
		arrow.addVertex(mid - segmentX * arrowLength + segmentY * arrowWidth);
		arrow.addVertex(mid);
		arrow.addVertex(mid - segmentX * arrowLength - segmentY * arrowWidth);
		arrow.close();
		PlaneProfile arrowProfile(arrow);
		sequenceProfile.unionWith(arrowProfile);
		
		if (p == (pointsArray.length() - 1))
		{
			PLine arrow(_ZW);
			arrow.addVertex(to - segmentX * 0.5 * arrowLength + segmentY * arrowWidth);
			arrow.addVertex(to + segmentX * 0.5 * arrowLength);
			arrow.addVertex(to - segmentX * 0.5 * arrowLength - segmentY * arrowWidth);
			arrow.close();
			PlaneProfile arrowProfile(arrow);
			sequenceProfile.unionWith(arrowProfile);
		}
	}
	dp.draw(sequenceProfile, _kDrawFilled, 25);
	dp.color(18);
	dp.draw(parentUID, pointsArray[0], _XW, _YW, 0, 0);
}

if (refreshDrawProductionSequence)
{
	TslInst productionSequenceTsl;
	String strScriptName = scriptName();
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

	Entity tslInstEntities[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for (int t = 0; t < tslInstEntities.length(); t++)
	{
		TslInst tsl = (TslInst)tslInstEntities[t];
		if (groupingInfoTslNames.find(tsl.scriptName()) != -1)
		{
			tsl.recalc();
		}
	}
	
	eraseInstance();
	return;
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
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Trigger all grouping info tsls in the drawing." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="12/9/2021 2:32:16 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End