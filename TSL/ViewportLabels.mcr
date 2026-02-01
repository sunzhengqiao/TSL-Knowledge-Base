#Version 8
#BeginDescription
#Versions
1.12 10/8/2024 Added collision detection feature. Runs on first insertion, when leaders are turned on, or from Rt-click menu cc
V1.1 2/5/2024 Keep entity type readonly after first dialog shown
V1.0 2/5/2024 Can be applied to Genbeams, Tsl Instances and Openings. 
- Made label formatted property. 
- Added PainterDefinition filters. 
- Changed to use new grip point system. By default label locations will be dynamic(offset from entity). 
- Added triggers to reset grips for current element or all elements, to set static or dynamic for specific label or current element
- Added property to display leader line
0.12 9/26/2023 Bugfix in Reset Grips function cc


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

Purpose & Function

Map Descriptions

Requirements


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/

String yes_no[] = { "Yes", "No" };
String stSpecial = projectSpecial();
int bInDebug = stSpecial == "db" || stSpecial == scriptName();
if(_bOnDebug) bInDebug = true;

String stLabelKey = "stLabel";
String stMapLabelsKey = "mpLabel";

PropString userDimstyle(0, _DimStyles, "Dimstyle");
PropDouble userTextHeight(0, 0, "Text Height Override");
PropString userShowLeader(1, yes_no, "Show Leader", 1);
PropString userActiveZones(2, "0", "Zones to Report");
userActiveZones.setDescription("Comma separated list of Zones to display");
PropInt userColorIndex(0, -1, "Label Color");

String arEntityTypes[] = 
{
	"GenBeam",
	"Beam",
	"Sheet",
	"TslInst",
	"Opening"
};
PropString userEntityType(3, arEntityTypes, "Entity Type", 1);

if(_bOnInsert)
{ 
	_Viewport.append(getViewport("\n Select a viewport to display entity labels"));
	showDialog();	
}
userEntityType.setReadOnly(_kReadOnly);

//function to get all the painter definition names of a certain type
String[] getPainterDefinitionNamesOfType(String inTypeName) {
	String painterDefinitionNamesFiltered[0];
	PainterDefinition painterDefinitionsAll[] = PainterDefinition().getAllEntries();
	for (int i=0; i<painterDefinitionsAll.length(); i++) {
		PainterDefinition& thisPainterDefinition = painterDefinitionsAll[i];
		String thisTypeName = thisPainterDefinition.type();
		if (thisTypeName == inTypeName) {
			painterDefinitionNamesFiltered.append(thisPainterDefinition.name());
		}
	}
	return painterDefinitionNamesFiltered.sorted();
}

String painterDefinitions[] = {"None"};
painterDefinitions.append(getPainterDefinitionNamesOfType(String(userEntityType)));

PropString userLabelFormat(4, "@(mpLabel.stLabel)", "Label Format");
userLabelFormat.setDefinesFormatting(String(userEntityType));
PropString userIncludeFilter(5, painterDefinitions, "Include Filter", 0);
PropString userExcludeFilter(6, painterDefinitions, "Exclude Filter", 0);

if (_bOnInsert) showDialog();

Display labelDisplay(userColorIndex);
labelDisplay.dimStyle(userDimstyle);
double textHeight = userTextHeight;
if (userTextHeight > 0) labelDisplay.textHeight(userTextHeight);
else textHeight = labelDisplay.textHeightForStyle("N/A", userDimstyle);

Viewport activeViewport = _Viewport[0];
CoordSys modelToPaperTranslation = activeViewport.coordSys();
CoordSys paperToModelTranslation = activeViewport.coordSys(); paperToModelTranslation.invert();
Element activeElement = activeViewport.element();

_Pt0 = _PtW;
_ThisInst.setAllowGripAtPt0(false);


String genbeamTypeNames[] = {"GenBeam", "Beam", "Sheet"};
//function to get entity center based on entity type
Point3d getEntityCenter(Entity& inEntity) 
{
	Point3d ptCen;	
	if (genbeamTypeNames.find(userEntityType)>=0) {
		GenBeam thisGenBeam = (GenBeam)inEntity;
		ptCen = thisGenBeam.ptCen();
	}
	else if (userEntityType == "TslInst") {
		TslInst thisTslInst = (TslInst)inEntity;
		ptCen = thisTslInst.ptOrg();
	}
	else if (userEntityType == "Opening") {
		Opening thisOpening = (Opening)inEntity;
		ptCen = thisOpening.plShape().ptMid();
	}
	ptCen.transformBy(modelToPaperTranslation);
	
	return ptCen;
}

//function to correctly record double into string
String doubleToString(double inDouble) 
{
	String stDouble(inDouble);
	if (stDouble.find("E", 0)>=0) stDouble = "0";
	return stDouble;
}

//function to record the current grip array int a map 
void recordGrips() 
{
	Map mapGrips;
	for (int i=0; i<_Grip.length(); i++) {
		Grip& thisGrip = _Grip[i];
		mapGrips.setPoint3d(thisGrip.name(), thisGrip.ptLoc());
	}
	Map mapGripsAll = _Map.getMap("GripsAll");
	mapGripsAll.setMap(activeElement.handle(), mapGrips);
	_Map.setMap("GripsAll", mapGripsAll);
	if (bInDebug) reportMessage("\n grips recorded");
}

//function to read the grip array from a map 
Grip[] readGrips() 
{
	Map mapGripsAll = _Map.getMap("GripsAll");
	Map mapGrips = mapGripsAll.getMap(activeElement.handle());
	Grip grips[0];
	for (int i=0; i<mapGrips.length(); i++) {
		Point3d ptLoc = mapGrips.getPoint3d(i);
		String name = mapGrips.keyAt(i);
		String entityHandle = name.token(0, "@");
		int isStatic = name.token(1, "@").atoi();
		Entity thisEntity; thisEntity.setFromHandle(entityHandle);
		if (thisEntity.bIsValid()) {
			if (!isStatic) {
				String coords = name.token(2, "@");
				Point3d entityCenterOld(coords.token(0, ";").atof(), coords.token(1, ";").atof(), coords.token(2, ";").atof());
				Vector3d vecOffset = ptLoc - entityCenterOld;
				//set grip location relative to entity center using recorded offset
				Point3d ptEntityCen = getEntityCenter(thisEntity);
				ptLoc = ptEntityCen + vecOffset;
				//reset coords record
				coords = doubleToString(ptEntityCen.X()) + ";" + doubleToString(ptEntityCen.Y()) + ";" + doubleToString(ptEntityCen.Z());
				name = entityHandle + "@" + isStatic + "@" + coords;
			}
			Grip thisGrip(ptLoc);
			thisGrip.setName(name);
			grips.append(thisGrip);
		}
	}

	return grips;
}

//function to get grip for specified entity
Grip getGripForEntity(Entity& inEntity, Grip& inGrips[], int& bSuccess)
{
	bSuccess = false;
	Grip entityGrip;
	for (int i=0; i<inGrips.length(); i++) 
	{
		Grip& thisGrip = inGrips[i];
		String thisGripName = thisGrip.name();
		String thisEntityHandle = thisGripName.token(0, "@");
		
		if (thisEntityHandle == inEntity.handle()) 
		{
			bSuccess = true;
			entityGrip = thisGrip;
			break;
		}
	}

	return entityGrip;
}

//function to get label for specified grip
String getLabelForGrip( Grip& inGrip) 
{ 
	String label = "N/A";
	String entityHandle = inGrip.name().token(0, "@");
	Entity entity; entity.setFromHandle(entityHandle);
	if (entity.bIsValid()) label = entity.formatObject(userLabelFormat);
	if (label.find("@", 0) >= 0) label = "N/A";
	
	return label;
}

//function to get grip location areas
PlaneProfile[] getGripLocationAreas()
{
	PlaneProfile gripLocations[0];
	for (int i=0; i<_Grip.length(); i++) {
		Grip& thisGrip = _Grip[i];
		Point3d gripPoint = thisGrip.ptLoc();
		PLine gripOutline;
		gripOutline.createCircle(gripPoint, _ZW, textHeight/2);
		gripLocations.append(PlaneProfile(gripOutline));
	}
	
	return gripLocations;
}

//reset triggers
String resetGripsForCurrentElementTrigger = "Reset grips for current element";
addRecalcTrigger(_kContextRoot, resetGripsForCurrentElementTrigger);
if (_bOnRecalc && _kExecuteKey == resetGripsForCurrentElementTrigger) {
	Map mapGripsAll = _Map.getMap("GripsAll");
	mapGripsAll.removeAt(activeElement.handle(), false);
	_Map.setMap("GripsAll", mapGripsAll);
}
String resetGripsForAllElementsTrigger = "Reset grips for all elements";
addRecalcTrigger(_kContextRoot, resetGripsForAllElementsTrigger);
if (_bOnRecalc && _kExecuteKey == resetGripsForAllElementsTrigger) {
	_Map.setMap("GripsAll", Map());
}
//add delimiter to separate triggers
addRecalcTrigger(_kContextRoot, "----------------------------");
addRecalcTrigger(_kGripPointDrag, "_Grip");
if (_bOnGripPointDrag && _kExecuteKey=="_Grip") 
{
	int indexMoved = Grip().indexOfMovedGrip(_Grip);
	if (bInDebug) reportMessage("\n grip moved: "+indexMoved);
	if (indexMoved>=0) {
		Grip& thisGrip = _Grip[indexMoved];
		String thisLabel = getLabelForGrip(thisGrip);
		labelDisplay.draw(thisLabel, thisGrip.ptLoc(), _XW, _YW, 0, 0);
	}
	return;
}

if (_kNameLastChangedProp=="_Grip")
{ 
	int indexMoved = Grip().indexOfMovedGrip(_Grip);
	if (indexMoved>=0) 
	{
		Grip& thisGrip = _Grip[indexMoved];
		if (bInDebug) reportMessage("\n grip changed: "+thisGrip.name()+" "+thisGrip.ptLoc());
		Map mapGripsAll = _Map.getMap("GripsAll");
		Map mapGrips = mapGripsAll.getMap(activeElement.handle());
		mapGrips.setPoint3d(thisGrip.name(), thisGrip.ptLoc());
		mapGripsAll.setMap(activeElement.handle(), mapGrips);
		_Map.setMap("GripsAll", mapGripsAll);
	}
}

//static/dynamic grip triggers
String drawLocationsTrigger = "Draw grip locations";
if (_bOnJig && _kExecuteKey==drawLocationsTrigger) {
	Display dpTemp(1);
	PlaneProfile gripLocations[] = getGripLocationAreas();
	for (int i=0; i<gripLocations.length(); i++) {
		PlaneProfile& gripLocation = gripLocations[i];
		dpTemp.draw(gripLocation, _kDrawFilled, 60);
	}
	return;	
}

String setGripStaticTrigger = "Set grip static";
addRecalcTrigger(_kContextRoot, setGripStaticTrigger);
String setGripDynamicTrigger = "Set grip dynamic";
addRecalcTrigger(_kContextRoot, setGripDynamicTrigger);
if (_bOnRecalc && (_kExecuteKey == setGripStaticTrigger) || (_kExecuteKey == setGripDynamicTrigger)) {
	int switchToStatic = _kExecuteKey == setGripStaticTrigger;
	PrPoint selector("\n Select grip to make it "+(switchToStatic ? "static" : "dynamic"), activeViewport.ptCenPS());
	int jigStatus = _kNone;
	while (jigStatus == _kNone) {
		jigStatus = selector.goJig(drawLocationsTrigger, Map());
		if (jigStatus == _kOk) {
			Point3d pointSelected = selector.value();
			PlaneProfile gripLocations[] = getGripLocationAreas();
			Grip potentialSelection[0];
			for (int i = 0; i < gripLocations.length(); i++) {
				PlaneProfile& gripLocation = gripLocations[i];
				if (gripLocation.pointInProfile(pointSelected) == _kPointInProfile) {
					Grip& thisGrip = _Grip[i];
					potentialSelection.append(thisGrip);
				}
			}
			
			if (potentialSelection.length() > 0) {
				int closestIndex = 0;
				double closestDistance = activeElement.segmentMinMax().length();
				for (int i = 0; i < potentialSelection.length(); i++) {
					Grip& thisGrip = potentialSelection[i];
					double thisDistance = LineSeg(thisGrip.ptLoc(), pointSelected).length();
					if (thisDistance < closestDistance) {
						closestDistance = thisDistance;
						closestIndex = i;
					}
				}
				Grip& gripToSet = potentialSelection[closestIndex];
				String gripName = gripToSet.name();
				String entityHandle = gripName.token(0, "@");
				if (switchToStatic) {
					gripToSet.setName(entityHandle + "@" + true);
					if (bInDebug) reportMessage("\n" + scriptName() + " - Grip set static: " + entityHandle);
				}
				else {
					Entity thisEntity; thisEntity.setFromHandle(entityHandle);
					Point3d ptCen = getEntityCenter(thisEntity);
					gripToSet.setName(entityHandle + "@" + false + "@" + doubleToString(ptCen.X()) + ";" + doubleToString(ptCen.Y()) + ";" + doubleToString(ptCen.Z()));
					if (bInDebug) reportMessage("\n" + scriptName() + " - Grip set dynamic: " + entityHandle);
				}
				Map mapGripsAll = _Map.getMap("GripsAll");
				Map mapGrips = mapGripsAll.getMap(activeElement.handle());
				for (int i = 0; i < mapGrips.length(); i++) {
					String thisGripName = mapGrips.keyAt(i);
					String thisEntityHandle = thisGripName.token(0, "@");
					if (thisEntityHandle == entityHandle) {
						mapGrips.removeAt(i, false);
						mapGrips.setPoint3d(gripToSet.name(), gripToSet.ptLoc());
						break;
					}
				}
				mapGripsAll.setMap(activeElement.handle(), mapGrips);
				_Map.setMap("GripsAll", mapGripsAll);
			}
		}
	}
}

String setGripsForCurrentElementToStaticTrigger = "Set grips for current element to static";
addRecalcTrigger(_kContextRoot, setGripsForCurrentElementToStaticTrigger);
String setGripsForCurrentElementToDynamicTrigger = "Set grips for current element to dynamic";
addRecalcTrigger(_kContextRoot, setGripsForCurrentElementToDynamicTrigger);
if (_bOnRecalc && (_kExecuteKey == setGripsForCurrentElementToStaticTrigger) || (_kExecuteKey == setGripsForCurrentElementToDynamicTrigger)) {
	int switchToStatic = _kExecuteKey == setGripsForCurrentElementToStaticTrigger;
	for (int i=0; _Grip.length(); i++) {
		Grip& thisGrip = _Grip[i];
		String gripName = thisGrip.name();
		String entityHandle = gripName.token(0, "@");
		if (switchToStatic) {
			thisGrip.setName(entityHandle+"@"+true);
			if (bInDebug) reportMessage("\n"+scriptName()+" - Grip set static: "+entityHandle);
		}
		else {
			thisGrip.setName(entityHandle+"@"+false+"@"+doubleToString(thisGrip.ptLoc().X())+";"+doubleToString(thisGrip.ptLoc().Y())+";"+doubleToString(thisGrip.ptLoc().Z()));
			if (bInDebug) reportMessage("\n"+scriptName()+" - Grip set dynamic: "+entityHandle);
		}
	}
	recordGrips();
}

//always reset clean _Grip storage before assigning active grips
_Grip.setLength(0);
Grip elementGrips[] = readGrips();

//get active entities for labels
Entity activeEntities[0], entitiesAll[0];
Group activeGroup = activeElement.elementGroup();
if (genbeamTypeNames.find(userEntityType)>=0) {
	entitiesAll.append(activeGroup.collectEntities(true, GenBeam(), _kModelSpace));
}
else if (userEntityType == "TslInst") {
	entitiesAll.append(activeGroup.collectEntities(true, TslInst(), _kModelSpace));	
}
else if (userEntityType == "Opening") {
	entitiesAll.append(activeGroup.collectEntities(true, Opening(), _kModelSpace));	
}

String activeZones[] = userActiveZones.tokenize(",");
for (int i=0; i<activeZones.length(); i++) {
	int thisZone = activeZones[i].atoi();
	for (int k=0; k<entitiesAll.length(); k++) {
		Entity& thisEntity = entitiesAll[k];
		if (thisEntity.myZoneIndex() != thisZone) continue;
		activeEntities.append(thisEntity);
	}
}
if (userIncludeFilter != "None" && activeEntities.length() > 0) {
	PainterDefinition thisPainterDefinition(userIncludeFilter);
	activeEntities = thisPainterDefinition.filterAcceptedEntities(activeEntities);
}
if (userExcludeFilter != "None" && activeEntities.length() > 0) {
	PainterDefinition thisPainterDefinition(userExcludeFilter);
	Entity entitiesToExclude[] = thisPainterDefinition.filterAcceptedEntities(activeEntities);
	for (int i=0; i<entitiesToExclude.length(); i++) {
		Entity& thisEntity = entitiesToExclude[i];
		int index = activeEntities.find(thisEntity);
		if (index >= 0) activeEntities.removeAt(index);
	}
} 
if (activeEntities.length()<1) {
	reportMessage("No entities to label");
	setMarbleDiameter(U(1, "inch"));
	return;
}

//get labels and grips for active entities
String activeLabels[0]; Grip activeGrips[0];
for (int i=0; i<activeEntities.length(); i++) {
	Entity& thisEntity = activeEntities[i];
	int bSuccess = false;
	Grip thisGrip = getGripForEntity(thisEntity, elementGrips, bSuccess);
	if (!bSuccess) 
	{
		Point3d ptCen = getEntityCenter(thisEntity);
		thisGrip = Grip(ptCen);
		thisGrip.setName(thisEntity.handle()+"@"+false+"@"+doubleToString(ptCen.X())+";"+doubleToString(ptCen.Y())+";"+doubleToString(ptCen.Z()));
		thisGrip.setIsRelativeToEcs(false);
	}
	
	//if (bInDebug) reportMessage("\n grip: "+thisGrip.name()+" "+thisGrip.ptLoc()+(bSuccess ? " (recorded)" : " (calculated)"));
	activeGrips.append(thisGrip);
	String thisLabel = thisEntity.formatObject(userLabelFormat);
	if (thisLabel.find("@", 0)>=0) thisLabel = "N/A";
	activeLabels.append(thisLabel);
}

//__when leaders are present or user requests update for collisions
int bCheckForCollisions;

if(_kNameLastChangedProp == "Show Leader" && userShowLeader == "Yes")
{ 
	bCheckForCollisions = true;
}

String stCheckCollisionsCommand = T("|Adjust Label Overlap|");
addRecalcTrigger(_kContextRoot, stCheckCollisionsCommand);
if(_kExecuteKey == stCheckCollisionsCommand) bCheckForCollisions = true;


if (_bOnDbCreated) bCheckForCollisions = true;

//bCheckForCollisions = true;
if(bCheckForCollisions)
{ 
	int maxTries = 5;
	PlaneProfile ppLabelAreas;
	
	PlaneProfile createBoundingBox(Point3d ptBoxCen, double dWBox, double dHBox, double dPad)
	{ 
		Point3d ptBL = ptBoxCen - _XW * dWBox / 2 - _YW * dHBox / 2;
		Point3d ptBR = ptBL + _XW * dWBox;
		Point3d ptTR = ptBR + _YW * dHBox;
		Point3d ptTL = ptBL + _YW * dHBox;
		
		PLine plBox(ptBL, ptBR, ptTR, ptTL);
		plBox.addVertex(ptBL);
		PlaneProfile ppBox(plBox);
		ppBox.shrink(-dPad);
		return ppBox;
	}
	
	
	Map mpAllLabels[0];
	String stGroupKey = "mpGroup";
	String stGripKey = "ptGrip";
	String stLabelKey = "stLabel";
	String stBoundingBoxKey = "ppBox";
	String stIndexKey = "iIndex";
	String stAdjustVectorKey = "vAdjust";
	double dAdjustFactor = labelDisplay.textHeightForStyle("qT", userDimstyle);//__simply a guess for now
	
	//__construct a first round of the mpOverlapGroups structure. One label per group
	for(int i=0; i<activeGrips.length(); i++)
	{
		Grip gp = activeGrips[i];
		Point3d ptGrip = gp.ptLoc();
		String stLabel = activeLabels[i];
		double dWLabel = labelDisplay.textLengthForStyle(stLabel, userDimstyle);
		double dHLabel = labelDisplay.textHeightForStyle(stLabel, userDimstyle);	
		
		
		PlaneProfile ppThisLabel = createBoundingBox(ptGrip, dWLabel, dHLabel, U(.05, "inch"));
		Map mpLabel;
		Map mpGroup;
		mpLabel.setPoint3d(stGripKey, ptGrip);
		mpLabel.setString(stLabelKey, stLabel);
		mpLabel.setInt(stIndexKey, i);		
		mpLabel.setPlaneProfile(stBoundingBoxKey, ppThisLabel);
		mpAllLabels.append(mpLabel);
	}
	
	//__check overlapping bounding boxes and construct overlap groups
	//__adjust each label per group, reset to list of all labels, check again
	int iLoopCount;
	while(iLoopCount++ <= maxTries)
	{ 
		Map mpCollectedGroups;
		int iAssignedIndices[0];
		
		for(int i=0;i<mpAllLabels.length();i++)
		{
			if (iAssignedIndices.find(i) >= 0) continue;//__this index was already assigned to group
			Map mpThisLabel =  mpAllLabels[i];
			Map mpGroup;
			mpGroup.appendMap("mp", mpThisLabel);
			
			PlaneProfile ppThisGroup = mpThisLabel.getPlaneProfile(stBoundingBoxKey);
			int bFoundCollision;
			
			for(int k=i+1;k<mpAllLabels.length();k++)
			{
				if (iAssignedIndices.find(k) >= 0) continue;//__this index was already assigned to group
				
				Map mpNext = mpAllLabels[k];//__maps in AllGroups array always have just one entry
				PlaneProfile ppNext = mpNext.getPlaneProfile(stBoundingBoxKey);
				ppNext.intersectWith(ppThisGroup);
				
				if(ppNext.area() > 0)//__collision found
				{ 
					//__record overlapping label
					mpGroup.appendMap("mp", mpNext);
					iAssignedIndices.append(k);
					
					//__update the PlaneProfile defining this group.
					ppNext.unionWith(mpNext.getPlaneProfile(stBoundingBoxKey));
					
					//__note that a group has been created
					bFoundCollision = true;
				}
			}//__end checking this group
			
			//__record to collected groups. Might only have one label entry			
			mpCollectedGroups.appendMap("mp", mpGroup);

		}
		
		Map mpAdjustedLabels[0];
		int bNoAdjustmentsMade = true;
		for(int i=0; i<mpCollectedGroups.length(); i++)
		{
			Map mpGroup = mpCollectedGroups.getMap(i);
			if(mpGroup.length() == 1)//__only a single entry, no adjustment needed, simply record it
			{ 
				mpAdjustedLabels.append(mpGroup.getMap(0));
				continue;
			}
			
			//__more than one entry, need to adjust points and bounding boxes in each
			//__ to try and resolve any overlap
			bNoAdjustmentsMade = false;
			Point3d ptsLabels[0];
			for(int k=0;k<mpGroup.length();k++)
			{
				Map mpLabel = mpGroup.getMap(k);
				Point3d ptLabel = mpLabel.getPoint3d(stGripKey);
				ptsLabels.append(ptLabel);
			}
			
			Point3d ptGroupCen;
			ptGroupCen.setToAverage(ptsLabels);
			
			//__adjust all labels in this group away from center
			for(int k=0;k<mpGroup.length();k++)
			{
				Map mpLabel = mpGroup.getMap(k);
				Point3d ptLabel = mpLabel.getPoint3d(stGripKey);
				Vector3d vAdjust = ptLabel - ptGroupCen;
				ptLabel.transformBy(vAdjust);
				mpLabel.setPoint3d(stGripKey, ptLabel);
				PlaneProfile ppLabel = mpLabel.getPlaneProfile(stBoundingBoxKey);
				ppLabel.transformBy(vAdjust);
				mpLabel.setPlaneProfile(stBoundingBoxKey, ppLabel);
				mpAdjustedLabels.append(mpLabel);
			}			
		}
		
		mpAllLabels = mpAdjustedLabels;
		if (bNoAdjustmentsMade) break;
	}
	
	//__write new locations to activeGrips
	int gripCount = mpAllLabels.length();

	for(int i=0; i<mpAllLabels.length(); i++)
	{
		Map mpLabel = mpAllLabels[i];
		int iPosition = mpLabel.getInt(stIndexKey);
		Point3d ptGrip = mpLabel.getPoint3d(stGripKey);
		activeGrips[iPosition].setPtLoc(ptGrip);
	}
}

//reset _Grip array to active grips
_Grip = activeGrips;


//always record grips
recordGrips();

//display labels
for (int i=0; i<activeLabels.length(); i++) {
	String thisLabel = activeLabels[i];
	Grip thisGrip = activeGrips[i];
	labelDisplay.draw(thisLabel, thisGrip.ptLoc(), _XW, _YW, 0, 0);
	if (userShowLeader == "Yes") {
		Point3d ptCen = getEntityCenter(activeEntities[i]);
		PLine gripOutline;
		gripOutline.createCircle(thisGrip.ptLoc(), _ZW, textHeight/2);
		LineSeg leaderLines[] = PlaneProfile(gripOutline).splitSegments(LineSeg(thisGrip.ptLoc(), ptCen), false);
		if (leaderLines.length()>0) 
			labelDisplay.draw(leaderLines.first());
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
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="564" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Added collision detection feature. Runs on first insertion, when leaders are turned on, or from Rt-click menu" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="10/8/2024 1:59:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Keep entity type readonly after first dialog shown" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/5/2024 2:45:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Can be applied to Genbeams, Tsl Instances and Openings. Made label formatted property. Added PainterDefinition filters. Changed to use new grip point system. By default label locations will be dynamic(offset from entity). Added triggers to reset grips for current element or all elements, to set static or dynamic for specific label or current element" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/5/2024 11:35:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix in Reset Grips function" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="9/26/2023 8:42:45 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End