#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
06.03.2020- version 1.18

This tsl creates an aligned dimension line.


1.19 30/11/2023 Add support for different anchors Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 19
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates an aligned dimension line.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.18" date="06.03.2020"></version>

/// <history>
/// AS - 1.00 - 03.06.2014 -	Pilot version
/// AS - 1.01 - 04.06.2014 -	Add style options
/// AS - 1.02 - 22.06.2014 -	Dimension points can now be linked to objects.
/// AS - 1.03 - 24.06.2014 -	Also set dependency on child entities.
/// AS - 1.04 - 30.06.2014 -	Assign this tsl to a group.
/// AS - 1.05 - 02.07.2014 -	Align text
/// AS - 1.06 - 17.12.2014 -	Add support for property filters when dependant on objects
/// AS - 1.07 - 23.06.2015 -	Draw on beam layer if available.
/// AS - 1.08 - 03.07.2015 -	Multiple start and end points are now supported.
/// AS - 1.09 - 18.01.2016 -	Add support for display represenatations
/// AS - 1.10 - 21.12.2017 -	Add support for linking the tsl to element child items.
/// AS - 1.11 - 21.12.2017 -	Accept multiple reference points
/// FA - 1.12 - 28.06.2018 -	Added a option to use this TSL in paperspace, this will take the scale of the viewport.
/// FA - 1.13 - 14.08.2018	-	Fixed a bug where the dimension in paperspace wouldn't draw angeled and vertical dimensions.
/// FA - 1.14 - 15.08.2018	- 	Added automatic selection of direction and position of the dimline. If you don't select these points on insert it will use pre defined points. 
/// FA - 1.15 - 03.01.2019	- 	Fixed a bug where the continued values wouldn't be displayed.'
/// RP - 1.16 - 22.01.2019- 	If placed on a viewport, dont set the layer, because the current layer should be the vp layer
/// RP - 1.17 - 27.02.2020- 	Fix layer assignment
/// AS - 1.18 - 06.03.2020- 	Export display.
/// </history>

double dEps = Unit(0.01, "mm");
double dPointTolerance = U(1);

//Groupnames
String arSGroupNames[0];
Group arGrp[0];
Group arAllGroups[] = Group().allExistingGroups();
for (int i=0;i<arAllGroups.length();i++) 
{
	Group grp = arAllGroups[i];
	// Only accept floor- and elementgroups.
	if (grp.namePart(1) == "")
		continue;
	arSGroupNames.append(grp.name());
	arGrp.append(grp);
}

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSDimMethod[] =
{
	T("|Delta perpendicular|"),
	T("|Delta parallel|"),
	T("|Continuous perpendicular|"),
	T("|Continuous parallel|"),
	T("|Both perpendicular|"),
	T("|Both parallel|"),
	T("|Delta parallel|, ")+T("|Continuous perpendicular|"),
	T("|Delta perpendicular|, ")+T("|Continuous parallel|")
};
int arNDimMethodDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int arNDimMethodContinuous[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};


String arSSide[] = {T("|Left|"), T("|Right|")};
int arNSide[] = {-1, 1};

PropString sSeperator01(0, "", T("|General|"));
sSeperator01.setReadOnly(true);
PropInt nColor(0, 1, "     "+T("|Color|"));
PropString sLayer(1, "0", "     "+T("|Layer|"));
PropString sAssignToGroup(11, arSGroupNames, "     "+T("|Assign to group|"));
sAssignToGroup.setDescription(T("|The dimension line is assigned exclusively to this group.|"));
PropString sLinkToObjects(10, arSYesNo, "     "+T("|Link to objects|"));
sLinkToObjects.setDescription(T("|Are the points taken from the objects?|"));
PropString showInDisplayRepresentation(12, TslInst().dispRepNames(), "     "+T("|Show in display representation|"));
showInDisplayRepresentation.setDescription(T("|Sets the display representation for drawing the dimension lines.|"));

PropString sSeperator03(2, "", T("|Dimension|"));
sSeperator03.setReadOnly(true);
PropString sDimStyle(3, _DimStyles, "     "+T("|Dimension style|"));
PropString sDimMethod(4,arSDimMethod,"     "+T("|Dimension method|"));


PropString sSeperator02(7, "", T("|Text|"));
sSeperator02.setReadOnly(true);
PropString sTextOverrideDelta(5, "", "     "+T("|Text override delta|"));
PropString sTextOverrideContinuous(6, "", "     "+T("|Text override continuous|"));
PropString sDescription(8, "", "     "+T("|Description|"));
PropString sSideDescription(9, arSSide, "     "+T("|Side description|"));
PropDouble dOffsetDescription(0, U(100), "     "+T("|Offset description|"));


String arSTrigger[] =
{
	T("|Add points|"),
	T("|Remove points|"),
	"     ----------",
	T("|Set direction|"),
	T("|Set reference point|")
};
for( int i=0;i<arSTrigger.length();i++ )
{
	addRecalcTrigger(_kContext, arSTrigger[i] );
}

int lineCounter;
int lineCounter1;
//region _bOnInsert
// Insert a dimension line
if (_bOnInsert)
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	};
	
	showDialog();
	
	int counter = 0;		
	while (true) 
	{
		Point3d ptLast;
		String promptMSG = T("|Select next point|");

		if (counter == 0)
		{
			promptMSG = T("|Select first dimension point or <ENTER> for PaperSpace|");
		}
		counter++;
		PrPoint ssP2(promptMSG, ptLast); 
		if (ssP2.go()==_kOk) { // do the actual query
			ptLast = ssP2.value(); // retrieve the selected point
			_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
		}
		else 
		{ // no proper selection
			break; // out of infinite while
		}

	}
	
	if (_PtG.length() == 1)
	{
		reportError(T("|Can't make a dimension with one point, please try inserting this TSL again.'|"));
		eraseInstance();
		return;
	}
	
	if (_PtG.length() == 0)
	{
		_Viewport.append(getViewport("Select a Viewport"));
		
		Point3d ptLast = getPoint(T("|Select first dimension point|"));
		_PtG.append(ptLast);
		
		while (true) 
		{
			PrPoint ssP2(T("|Select next point|"), ptLast);
			if (ssP2.go() == _kOk) { //do the actual query
				ptLast = ssP2.value(); //retrieve the selected point
				_PtG.append(ptLast); //append the selected points to the list of grippoints _PtG
			}
			else { //no proper selection
				break; //out of infinite while
			}
		}
		
		if (_PtG.length() == 1)
		{
			reportError(T("|Can't make a dimension with one point, please try inserting this TSL again.'|"));
			eraseInstance();
			return;
		}
		
		while (true) 
		{
			PrPoint startDim(T("|Select a position for the dimension line|"));
			if (startDim.go() == _kOk)
			{
				_Pt0 = startDim.value();
				break;
			}
			else
			{
				_Pt0 = Point3d(0, 0, 0);
				break;
			}
		}
		

		Point3d ptDirection;
		while (true) 
		{
			PrPoint ssPDirection(T("|Select a position for the direction|"), _Pt0);
			if (ssPDirection.go() == _kOk) 
			{ //do the actual query
				ptDirection = ssPDirection.value(); //retrieve the selected point
				_Map.setPoint3d("VecX", ptDirection);
				break; //Break out of infinite while.
			}
			else 
			{ //No proper selection.
				break;
			}
		}
		
	}
	else
	{
		while (true) 
		{
			PrPoint startDim(T("|Select a position for the dimension line|"));
			if (startDim.go() == _kOk)
			{
				_Pt0 = startDim.value();
				break;
			}
			else
			{
				_Pt0 = Point3d(0, 0, 0);
				break;
			}
		}
		Point3d ptDirection;
		while (true) {
			PrPoint ssPDirection(T("|Select a position for the direction|"), _Pt0);
			if (ssPDirection.go() == _kOk) 
			{ //do the actual query
				ptDirection = ssPDirection.value(); //retrieve the selected point
				_Map.setPoint3d("VecX", ptDirection);
				break; //Break out of infinite while.
			}
			else 
			{ //No proper selection.
				break;
			}
		}
		
	}
	
	lineCounter = 0;
	lineCounter1 = 1;
	
	return;
}
//endregion

String showInDisplayRepresentations[] = 
{
	showInDisplayRepresentation
};
if (_Viewport.length() < 1)
{
	// Set the tsl to layer 0. The graphics might drawn on a different layer.
	_ThisInst.assignToLayer(sLayer);
	
	Group grp = arGrp[arSGroupNames.find(sAssignToGroup,0)];
	int bAssignToGroup = true; // Make this a property?
	if (bAssignToGroup)
	{
		grp.addEntity(_ThisInst, true, 0, 'D');
	}
	
	//String sDrawOnLayer = "0";
	//if( sLayer != "" );
	//sDrawOnLayer = sLayer;	
}


int nLinkToObjects = arNYesNo[arSYesNo.find(sLinkToObjects,0)];

int nDimMethodDelta = arNDimMethodDelta[arSDimMethod.find(sDimMethod,0)];
int nDimMethodContinuous = arNDimMethodContinuous[arSDimMethod.find(sDimMethod,0)];

int nSideDescription = arNSide[arSSide.find(sSideDescription,0)];

Plane pnWorld(_PtW, _ZW);
Point3d originPoint(0, 0, 0);
if (_Pt0 == originPoint)
{
	_Pt0 = _PtG[0];
}

double dVpScale;
if (_Viewport.length() != 0)
{
	Viewport vp = _Viewport[0];
	
	//Coordinate system
	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); //take the inverse of ms2ps
	dVpScale = ps2ms.scale();
}

// Add new dimension points. Prompt the user to select them.
if( _kExecuteKey == arSTrigger[0] )
{
	Point3d ptLast = getPoint(T("|Select first dimension point|"));
	_PtG.append(ptLast);
	
	while (true)
	{
		PrPoint ssP2(T("|Select next point|"), ptLast); 
		if (ssP2.go()==_kOk) { // do the actual query
			ptLast = ssP2.value(); // retrieve the selected point
			_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
		}
		else 
		{ // no proper selection
			break; // out of infinite while
		}
	}
	
	// Set dimension object to no. Dimpoints are now manually overriden.
	sLinkToObjects.set(arSYesNo[1]);
	nLinkToObjects = arNYesNo[1];
}

// Set the direction. Prompt the user to select two points for the direction.
if (_kExecuteKey == arSTrigger[3]) 
{
	Point3d ptStartDirection = getPoint(T("|Select a position for the dimension line|"));
	Point3d ptEndDirection;
	while (true) {
		PrPoint ssPDirection(T("|Select a position for the direction|"), ptStartDirection); 
		if (ssPDirection.go()==_kOk) 
		{ // do the actual query
			ptEndDirection = ssPDirection.value(); // retrieve the selected point
			
			break; // Break out of infinite while.
		}
		else
		{ // No proper selection.
			reportError(T("|Invalid direction|"));
			break;
		}
	}
	
	Vector3d vNewDirection(ptEndDirection - ptStartDirection);
	if (vNewDirection.length() > dEps) 
	{
		_Map.setPoint3d("VecX", _Pt0 + vNewDirection);
	}
	else
	{
		reportWarning(T("|Points are too close to each other.|") + T(" |The new direction is not set|"));
	}
}

// Project _Pt0 to ground plane.
_Pt0 = pnWorld.closestPointTo(_Pt0);
// Get the direction of the dimline.

Vector3d vxDimLine;
if (!_Map.hasPoint3d("VecX"))
{
	Point3d ptDirection = _PtG[_PtG.length() - 1];
	Point3d firstPoint = _PtG[0];
	Point3d lastPoint = _PtG[_PtG.length() - 1];
	
	Vector3d dimPts = (firstPoint - lastPoint);
	dimPts.normalize();
	
	Plane firstPlane(firstPoint, dimPts);
	Point3d projectedFirstPt = _Pt0.projectPoint(firstPlane, 0);
	
	Vector3d vecPlaneNormal(projectedFirstPt - firstPoint);
	Plane secondPlane(projectedFirstPt, -vecPlaneNormal);
	Point3d projectedLastPt = ptDirection.projectPoint(secondPlane, 0);
	
	Vector3d dirVec(projectedLastPt - projectedFirstPt);
	vxDimLine = dirVec;
	vxDimLine.normalize();
	
}
else
{
	Point3d ptDirection = _Map.getPoint3d("VecX");
	// Project _Pt0 to ground plane.
	ptDirection = pnWorld.closestPointTo(ptDirection);
	vxDimLine = Vector3d(ptDirection - _Pt0);
	vxDimLine.normalize();
}

if ( vxDimLine.dotProduct(_XW) < 0 || vxDimLine.dotProduct(_YW) < 0)
{
    vxDimLine *= -1;
}

Vector3d vyDimLine;
if (_Viewport.length() == 0)
{
	vyDimLine  = _ZU.crossProduct(vxDimLine);
}
else
{
	vyDimLine = _ZW.crossProduct(vxDimLine);
}

// Get the dimension points from the objects.
if (nLinkToObjects)
{
	// The map must contain dimension objects. Otherwise the manual points are kept.
	if (_Map.hasMap("DimensionObjects"))
	{
		Map mapDimensionObjects = _Map.getMap("DimensionObjects");
		
		// Get the entities.
		Entity arEntDim[0];
		for (int i = 0; i < mapDimensionObjects.length(); i++)
		{
			if (mapDimensionObjects.keyAt(i) != "Entity")
				continue;
			arEntDim.append(mapDimensionObjects.getEntity(i));
		}
		
		// Reset the list of points to dimension. 
		_PtG.setLength(0);
		
		// Add start point of dimension line
		Point3d startPoints[0];
		Point3d endPoints[0];
		for (int m = 0; m < _Map.length(); m++)
		{
			if (_Map.keyAt(m) == ("DimRefStart") && _Map.hasPoint3d(m))
			{
				startPoints.append(_Map.getPoint3d(m));
			}
			else if (_Map.keyAt(m) == ("DimRefEnd") && _Map.hasPoint3d(m))
			{
				endPoints.append(_Map.getPoint3d(m));
			}
			else if (_Map.keyAt(m) == ("StartReference") && _Map.hasPoint3d(m))
			{
				startPoints.append(_Map.getPoint3d(m));
			}
			else if (_Map.keyAt(m) == ("OtherReferencePoints") && _Map.hasPoint3dArray(m))
			{
				endPoints.append(_Map.getPoint3dArray(m));
			}
		}
		
		_PtG.append(startPoints);
		
		// Do we have to dimension child items or the specified entities?
		// If the _Map contains a map for child items we go for these child items.
		Map mapChildItems;
		if (_Map.hasMap("ChildItems"))
		{
			mapChildItems = _Map.getMap("ChildItems");
		}
		
		for (int i = 0; i < arEntDim.length(); i++)
		{
			Entity ent = arEntDim[i];
			
			// Is it an element...?
			if (ent.bIsKindOf(Element()))
			{
				Element el = (Element)ent;
				
				if (mapChildItems.length() > 0)
				{
					String childItemType = mapChildItems.getString("Type");
					if (childItemType == "TslInst")
					{
						String tslScriptName = mapChildItems.getString("ScriptName");
						
						// An inclusion filter. Only take the tsl's with matching properties.
						int propertyIndexes[0];
						String propertyValues[0];
						String mapKey;
						String mapValues[0];
						if (mapChildItems.hasMap("PropertyFilter")) {
							
							Map mapPropertyFilter = mapChildItems.getMap("PropertyFilter");
							if (mapPropertyFilter.hasInt("Index"))
							{
								propertyIndexes.append(mapPropertyFilter.getInt("Index"));
								propertyValues.append(mapPropertyFilter.getString("Value"));
							}
							
							if (mapPropertyFilter.getString("FilterType") == "Map")
							{
								mapKey = mapPropertyFilter.getString("Key");
								mapValues.append(mapPropertyFilter.getString("Value").tokenize(";"));
							}
						}
						
						// Try to find tsl's with the specified name attached to this element.
						TslInst elementTsls[] = el.tslInst();
						for (int t =0;t<elementTsls.length();t++)
						{
							TslInst tsl = elementTsls[t];
							if ( ! tsl.bIsValid()) continue;
							
							String thisScriptName = tsl.scriptName();
							if (thisScriptName == tslScriptName)
							{
								
								Point3d tslPoint = tsl.ptOrg();
								int filterUsed = false;
								int validTsl = false;
								for (int k = 0; k < propertyIndexes.length(); k++)
								{
									int propertyIndex = propertyIndexes[k];
									String propertyValue = propertyValues[k];
									
									if (propertyIndex > 0 && propertyValue.length() > 0)
									{
										filterUsed = true;
										if (tsl.propString(propertyIndex) == propertyValue)
										{
											validTsl = true;
											break;
										}
									}
								}
								
								if (mapKey != "" && !filterUsed)
								{
									String nestedKeys[] = mapKey.tokenize(".");
									Map filterMap = tsl.map();
									for (int k = 0; k < (nestedKeys.length() - 1); k++)
									{
										filterMap = filterMap.getMap(nestedKeys[k]);
									}
									String filterValue = filterMap.getString(nestedKeys[nestedKeys.length() - 1]);
									
									filterUsed = true;
									if (mapValues.find(filterValue) != -1)
									{
										validTsl = true;
									}
									
								}
								
								if (filterUsed && validTsl)
								{
									_PtG.append(tsl.gripPoints());
									_PtG.append(tsl.ptOrg());
									// Set dependency on this tsl
									_Entity.append(tsl);
									setDependencyOnEntity(tsl);
								}
							}
						}
					}
				}
				else
				{
					Point3d arPtEl[] = el.plEnvelope().vertexPoints(true);
					Line lnElX(el.ptOrg(), el.vecX());
					arPtEl = lnElX.projectPoints(arPtEl);
					arPtEl = lnElX.orderPoints(arPtEl);
					if (arPtEl.length() > 0) 
					{
						_PtG.append(arPtEl[0]);
						_PtG.append(arPtEl[arPtEl.length() - 1]);
					}
				}
				
				// Set dependency on this element
				_Entity.append(el);
				setDependencyOnEntity(el);
			}
			else if (ent.bIsKindOf(Beam()))
			 { //Or is it a beam... ?
				Beam bm = (Beam)ent;
				
				if (mapChildItems.length() > 0)
				{
					String sChildItemType = mapChildItems.getString("Type");
					if (sChildItemType == "TslInst") {
						String sScriptName = mapChildItems.getString("ScriptName");
						
						// An inclusion filter. Only take the tsl's with matching properties.
						int arNPropertyIndex[0];
						String arSPropertyValue[0];
						if (mapChildItems.hasMap("PropertyFilter")) {
							//// TODO
							// Add support for multiple property filters.
							// Add support for different property types. Strings are only supported at the moment.
							
							Map mapPropertyFilter = mapChildItems.getMap("PropertyFilter");
							arNPropertyIndex.append(mapPropertyFilter.getInt("Index"));
							arSPropertyValue.append(mapPropertyFilter.getString("Value"));
						}
						
						// Try to find tsl's with the specified name attached to this beam.
						Entity arEntTool[] = bm.eToolsConnected();
						for (int j = 0; j < arEntTool.length(); j++)
						{
							TslInst tslTool = (TslInst)arEntTool[j];
							if ( ! tslTool.bIsValid())
								continue;
							
							if (tslTool.scriptName() != sScriptName)
								continue;
							
							int bFilterUsed = false;
							int bValidTsl = false;
							for (int k = 0; k < arNPropertyIndex.length(); k++)
							{
								int nPropertyIndex = arNPropertyIndex[k];
								String sPropertyValue = arSPropertyValue[k];
								
								if (nPropertyIndex < 0 || sPropertyValue == "")
									continue;
								
								bFilterUsed = true;
								if (tslTool.propString(nPropertyIndex) == sPropertyValue) {
									bValidTsl = true;
									break;
								}
							}
							
							if (bFilterUsed && !bValidTsl)
								continue;
							
							_PtG.append(tslTool.ptOrg());
							
							// Set dependency on this tsl
							_Entity.append(tslTool);
							setDependencyOnEntity(tslTool);
						}
					}
				}
				else
				{
					_PtG.append(bm.ptCenSolid() - bm.vecX() * 0.5 * bm.solidLength());
					_PtG.append(bm.ptCenSolid() + bm.vecX() * 0.5 * bm.solidLength());
				}
				
				// Set dependency on this element
				_Entity.append(bm);
				setDependencyOnEntity(bm);
			}
		}
		
		// Add end point of dimension line
		_PtG.append(endPoints);
	}
}


// Remove dimension points. Prompt the user to select them.
if (_kExecuteKey == arSTrigger[1]) {

	// TODO: Add this to a helper tsl to display the grips during this custom action.
	// NOTE: Make sure the helper tsl is deleted if the user cancels out of this command.
	/*
	Display dpCurrentGrips(5);
	double dSymbolSize = U(20);
	for (int i=0;i<_PtG.length();i++) {
		Point3d ptGrip = _PtG[i];
		PLine plGrip(_ZU);
		plGrip.createCircle(ptGrip, _ZU, 0.5 * dSymbolSize);
		dpCurrentGrips.draw(plGrip);
		
		PLine plCross(_ZU);
		plCross.addVertex(ptGrip + _XU * 0.75 * dSymbolSize);
		plCross.addVertex(ptGrip - _XU * 0.75 * dSymbolSize);
		dpCurrentGrips.draw(plCross);
		plCross = PLine(_ZU);
		plCross.addVertex(ptGrip + _YU * 0.75 * dSymbolSize);
		plCross.addVertex(ptGrip - _YU * 0.75 * dSymbolSize);
		dpCurrentGrips.draw(plCross);
	}
	*/
	

	Point3d arPtToDelete[0];
	Point3d ptLast = getPoint(T("|Select a dimension point to delete|"));
	arPtToDelete.append(ptLast);

	while (true) {
		PrPoint ssP2(T("|Select next point|"), ptLast); 
		if (ssP2.go()==_kOk) { // do the actual query
			ptLast = ssP2.value(); // retrieve the selected point
			arPtToDelete.append(ptLast); // append the selected points to the list of grippoints _PtG
		}
		else { // no proper selection
			break; // out of infinite while
		}
	}
	
	Point3d arPtToDim[0];
	for (int i=0;i<_PtG.length();i++) {
		Point3d ptDim = _PtG[i];
//		Plane pnCompare(ptDim, _ZU);
		
		int bDeletePoint = false;
		for (int j=0;j<arPtToDelete.length();j++) {
			Point3d ptToDelete = arPtToDelete[j];
//			// Project point to same plane before the comparison is done.
//			ptToDelete = pnCompare.closestPointTo(ptToDelete);
//			
//			if (Vector3d(ptToDelete - ptDim).length() < dPointTolerance) {
			if (abs(vxDimLine.dotProduct(ptToDelete - ptDim)) < dPointTolerance) {
				bDeletePoint = true;
				break;
			}
		}
		
		if (bDeletePoint)
			continue;
		
		arPtToDim.append(ptDim);
	}
	
	// Clear the dimpoints and add the updated list again.
	_PtG.setLength(0);
	_PtG.append(arPtToDim);
	
	// Set dimension object to no. Dimpoints are now manually overriden.
	sLinkToObjects.set(arSYesNo[1]);
}


// Set the reference point. Prompt the user to select it.
if (_kExecuteKey == arSTrigger[4]) {
	Point3d ptReference = getPoint(T("|Select the reference point|"));
	for (int i=0;i<_PtG.length();i++) {
		Point3d ptDim = _PtG[i];
		if (abs(vxDimLine.dotProduct(ptReference - ptDim)) < dPointTolerance) {
			_PtG.removeAt(i);
			_PtG.insertAt(0, ptDim);
			break;
		}
	}
}

// _Pt0 must be stored.
if (_Map.hasPoint3d("PreviousOrigin")) {
	Point3d ptPreviousOrigin = _Map.getPoint3d("PreviousOrigin");
	
	// The dimpoints must be corrected if _Pt0 is moved.
	Vector3d vMove(_Pt0 - ptPreviousOrigin);
	if( vMove.length() > dEps ){
		for( int i=0;i<_PtG.length();i++ )
			_PtG[i] -= vMove;
	}
}
// Store _Pt0 absolute.
_Map.setPoint3d("PreviousOrigin", _Pt0, _kAbsolute);

if( _PtG.length() < 1 ){
	reportWarning(T("|Not enough points found, dimline cannot be created!|"));
	return;
}

// Draw dimline
String sTextDelta;
String sTextDeltas[0];
double doublesContinuedDim[0];
if (_Viewport.length() == 0)
{
	for (int i = 0; i < _PtG.length() - 1; i++)
	{
		sTextDelta = "<>";
		if (sTextOverrideDelta != "")
		sTextDelta = sTextOverrideDelta;
		sTextDeltas.append(sTextDelta);
	}
}
else
{ 
	Line orderLine(_PtG[0], Vector3d(_PtG[_PtG.length() - 1]- _PtG[0]));
	_PtG = orderLine.orderPoints(_PtG, 0);
	double iDimLength;
	doublesContinuedDim.append(round(iDimLength));
	sTextDelta = "<>";
//	sTextDeltas.append(sTextDelta);
	for (int i =0; i < _PtG.length() - 1; i++)
	{
		LineSeg linePoints(_PtG[i] , _PtG[i+1]);
		iDimLength = linePoints.length();
		iDimLength *= dVpScale;
		sTextDelta = round(iDimLength);
		doublesContinuedDim.append(round(iDimLength));
		if (sTextOverrideDelta != "")
		{
			sTextDelta = sTextOverrideDelta;
		}
		sTextDeltas.append(sTextDelta);
	}
		sTextDelta = "<>";
	sTextDeltas.append(sTextDelta);
}

String sTextContinuous = "<>";

if (sTextOverrideContinuous != "")
{ 
	 sTextContinuous = sTextOverrideContinuous;
}

DimLine dimLine(_Pt0, vxDimLine, vyDimLine);

if (_bOnDebug)
{
	_Pt0.vis(1);
	vxDimLine.vis(_Pt0, 1);
	vyDimLine.vis(_Pt0, 3);
}

Display dpDim(nColor);
dpDim.showInDxa(true);
dpDim.dimStyle(sDimStyle); 

if (_Viewport.length() != 0)
{
	Point3d emptyPoints[0];
	Dim dim(dimLine, emptyPoints, "", "", nDimMethodDelta, nDimMethodContinuous); 
	double continuedStorage = doublesContinuedDim[0];
	
	
	for (int i =0; i < _PtG.length(); i++)
	{
		double db = doublesContinuedDim[i];
		continuedStorage += db;
		String sContinuedDim = continuedStorage;
		if (sTextOverrideContinuous.length() == 0)
		{
			dim.append(_PtG[i], sTextDeltas[i], sContinuedDim);
		}
		else
		{ 
			dim.append(_PtG[i], sTextDeltas[i], sTextContinuous);
		}
	}

	dpDim.draw(dim);
}
else
{ 
	Dim dim(dimLine, _PtG, sTextDelta, sTextContinuous, nDimMethodDelta, nDimMethodContinuous);
	dpDim.draw(dim);
}
// Add description
Line lnDim(_Pt0, -vxDimLine * nSideDescription);
Point3d arPtDim[] = lnDim.projectPoints(_PtG);
arPtDim = lnDim.orderPoints(arPtDim);

if( arPtDim.length() < 1 ){
	reportWarning(T("|Not enough points found, description cannot be added!|"));
	return;
}

Vector3d vxTxt = vxDimLine;
Vector3d vyTxt = vyDimLine;
double dxFlag = nSideDescription;
if (vyTxt.dotProduct(-_XW + _YW) < 0) {
	vxTxt *= -1;
	vyTxt *= -1;
	
	dxFlag *= -1;
}

Point3d ptDescription = arPtDim[0] + vxDimLine * nSideDescription * dOffsetDescription;

for (int d=0;d<showInDisplayRepresentations.length();d++) {
	String displayRepresentation = showInDisplayRepresentations[d];

	Display dpDim(nColor);
	//dpDim.showInDispRep(displayRepresentation);
	dpDim.dimStyle(sDimStyle);
	dpDim.draw(sDescription, ptDescription, vxTxt, vyTxt, dxFlag, 0);
}
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`**1EW*0>_'%>(^(]"U3P?JD4T%U<2V;/BVN9)"3DG
M/E2$\;O[K'ANAYZS)M*Y48\SL>G>(/%EKH<T-HL+WE_,-RVT3`%8QU=B>%7L
M,]3P.^-;3-1@U73;>_MMWDSQATW#!P?\]N*\I\#V5OKVH2B]GFEDWF>Y\Q\-
M,V>$`_A1>,J,>G0\^KK86BJ%6VA"@8`"#BHA.4M4.45%V+611D56^PVO_/O%
M_P!\"C[#:_\`/O%_WP*N\B="SD49%5OL-K_S[Q?]\"C[#:_\^\7_`'P*+R#0
MLY%&15;[#:_\^\7_`'P*/L-K_P`^\7_?`HO(-"SD49%5OL-I_P`^T/\`WP*/
ML-I_S[0_]\"B\@T+.11D56^PVG_/M#_WP*/L-I_S[0_]\"B\@T+.11D56^PV
MG_/M#_WP*/L-I_S[0_\`?`HO(-"SD49%5OL-I_S[0_\`?`H^PVG_`#[0_P#?
M`HO(-"SFC(]:R;B&W>7[/;VT/F?QOY8(0?X^@JS#IMI%$J""-L#JR@DU*E)O
M1#:21=R*,U6^PVG_`#[0_P#?`H^PVG_/M#_WP*J\A:%G(HR*K?8;3_GVA_[X
M%'V&T_Y]H?\`O@47D&A9R*,BJWV&T_Y]H?\`O@4?8;3_`)]H?^^!1>0:%G(H
MJM]AM/\`GVA_[X%-M(HXIKE8T5%WCA1@?=%*[OJ&A;HHHJQ!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`57OK&VU*QFLKR%)K:92
MDD;C(8&K%%`'A_B#0-1\%:S%=6DTAMBX%K=EN<]HI#_>[*QX8<'GKZ3X1\76
M_B.TVOB*^C'[V+IG'!(]O4=OR)WK^QMM3L9K*\A2:VF4I)&XR&!KQC7]`U'P
M5K,5S:32-;%Q]ENR><]HI#TW=E8\,.#SUR:<'=&J:FK,]PHKF/"7BZW\1VFU
M\17T8_>Q=,XX)'MZCM^1/3UHI)JZ,VFG9A1113$%%%%`!1110`4444`%%%%`
M!5&XN'>7[/;_`.L_C?L@_P`?04MS<.TGV:WYF/+,>D8]3_05-;6ZV\8523W)
M/5CZGWK-MR=D4M-6%M;I;QA4R<\DGJ3ZFIZ**M)+1$MW"BBBF`4444`%%%%`
M!5:#_CYNO]\?^@BK-5H/^/FZ_P!\?^@BIENAHLT4450@HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`***S8FGL&*W,[W$3L2)7`!3/\)P`,=@?S]:!I7-
M*BBB@04444`%%%%`!5:_L;;4[&:RO(4FMIE*21N,A@:LT4`>'Z_H&H^"M9AN
M;2:0VQ<"UNR><]HI#TW=@QX8<'GKZ5X2\6V_B.TVMB*^C'[V+IG'&1[>H[?D
M3NW]C;:G8S65Y"DUM,I22-QD,#7C?B3PYJ/@C4X=2L;B62Q#`1W1/SQ-T"2'
MH<]`YZ_=;KDY.+B[Q-4U)69[/<W,-G;27-S*D4$2EY)'8!54<DDGH*K:3K-A
MKEJ;G3[@31`X/RE64XSRK`$<$'D="#7DUSXCO_&=Q;V<\2*D;J([%6(6XFS_
M`*R0GHB\?+S@_P!X[:]1T#0H]#M&7S3/<S$/<3D8WMZ`?PJ.@'\R2349J3T(
ME%QW->BBJ]S,R*$C'[QSA"1E<^]626**BCE#,8S]]1SQC/N/:I:`"BBB@`JE
M<W#M)]FM\&8\LQZ1CU/]!1=7+[_L]N,SGN>B#U/^%36]NEO'M4DD\LQZL?4U
MFVY.R*6FK"WMTMX]JDDGEF/5CZFIZ**M))61.X4444P"BBB@`HHHH`****`"
MJL7RW=P#P6(8>XP!5JHY8A(/0CD,.H-2T-$E%0Q2G=Y<F!(/3HP]14U-.X@H
MHHI@%%%%`!1110`4444`%%%%`!1110`4450S)8RNTLKRV\CD[FQF+/;_`'?Y
M?R!I7.?T/QAIUYJ=]I\=Y+<-#/)EY(]I0;N1QU49P#UXY]:ZQE61"K`%2.0>
MAK)7PSI*Z_\`VW':(E^8RC2+P&SU)'0GWZU9C0:4JQC)LP`%R23%]2>J_P`O
MITE7ZFD^1M<@*QL&".2UL>%8G_5^Q]O0UH4QE61"K`%2,$'H:I*QL'".2UL3
MA7)_U?L?;T-,C<T****9(4444`%%%%`!4-S;0WEM);W$22P2J4DC=<JP/4$=
MQ4U%`'A?B;PC>^"[J&[LKF>33PX\B[W?O+=^BJY_17/!^ZW49]#\%>-8O$,/
MV2[VQ:I$OS(!@2@=64=O=>HSW!!/5W-M#>6TEM<1)+!*I22-U!5E/!!'>O$_
M%GA2[\'ZA'?6$LO]G>8#;W(;Y[9^@1F_16/7.ULYYR<7%W1JFI*S/<J0C(P:
MX_P5XUB\0P_9+O;%JD2Y=`,"4#JRC^:]0?8@GL:T33V,VFG9D$=K%$^]4&_&
M-Q))_,U/113$%4KFY;S!;VXW3'J>R#U-+=7+!UMX!NF;\D'J:DM;9;="`2S-
MRSMU8UFVY.R*2MJPM;9;="`2S-RSMU8^M6***M))61+=PHHHI@%%%-=U12S$
M!1R23@"@!U%(K!U#*05(R"#P:6@`HHHH`****`"BBB@".2(2#T(Y##J#4<<X
M\SR9"!+UQ_>'J*2YN1!A54O*_"(#U_P'O4<5E@,\S;YWY+CC'H!Z`5FWK:)2
M6FI<'2EJ".1E?RI/O]CV85/5IW)"BBBF`4444`%%%%`!1110`4444`4`9+&5
MVFE>6WD<D,V,Q9[<?P^_;O[7B`PP0"#00""",@]15($Z>=K$FU)X/_/+V/\`
ML_R^G1#W`9TXX/-H>A_YY?\`V/\`+Z=+I`88/(-!`88(!!JD"=/.&)-H3P?^
M>7_V/\OIT![ADZ><'FT/0_\`/+_['^7TZ6V59$*L`5(P0>AIQ`88/(-4LG3S
M@Y-H>A_YY?\`V/\`+Z=`-QJLU@P1R6MB<*Y/^K]C[>AK0[4QT61"K`%2,$'H
M:I*QL'".2UL3A')^Y['V]#3#<T****"0HHHH`****`"H;FVAO+:2VN(DE@E4
MI)&ZY5E/4$5-10!X;XK\*7?@_4([ZPEE_L[S`;>Y#?/;/T",?T5CUSM;.>?0
M?!7C6+Q##]DN]L6J1+ET`P)0."RC^:]0?8@GJ[FUAO+:2VN(DE@E4I)&ZY5E
M/4$5XKXH\(W?A+4XKNQNI(]/,@-O=\LUL_14<^G97.>#M8'OG)..J-4U)<K/
M<*I7-T5D\B`!K@]NR#^\?;^=</I_Q!GNM*:VFMQ%K$0VR,1^Z`_YZ#_XGU]L
M$R>"[2YU'4QKL;R)9E702R#YKPD_>_W`1D'OVP.L\_.^6(N3EU9W-M;+;J>2
M[N<N[=6-6***U225D9MW"BBBF`4444`%13QF1`-Q`!R1_>'I4M%`%2S,S$F0
M$*5&588P?;VJW110`4444`%%%%`!5:YN1``JJ7F?A$!Z_P"`]Z+FY$&%52\S
M\(@/7_`>]);6QB+2RMOG?[S8_0>@J)-MV1275A;6QB+2R-OG?[S?T'H*M445
M222$W<CEC$J;3P>H(Z@TV*0Y\N3`D'Y,/45-4<L0D`SD$<JPZ@TFNJ$245#!
M*9-Z,!OC;:V.F<`_UJ:FG<`HHHI@%%%%`!1110`4444`%(0&!!&0>U+10!1!
M.GG:Q)M2>"?^67L?]G^7TZ72`PP1D&@@,"",@]C5($Z>=K$FU)X;_GE['_9_
ME].B'N`)T\X.3:'H?^>7U_V?Y?3I=(##!&0:"`PP1D&J0)T\X8YM#T/_`#R_
M^Q_E].@/<,G3S@\VAZ'_`)Y?_8_R^G2VZ+(A5@"I&"#T-..",'D&J63IQP23
M:'H?^>7_`-C_`"^G0#<:K&P<(Y+6Q.%<_P`'L?;T-:%,=%D0JP!4C!!Z&J2N
M;!PCDM;$X5SU3V/MZ&@-S0HH[44R0HHHH`****`"H;JUAO+:2VN(DE@E4I)&
MZY5E/4$5-10!XCXI\(R^&Y%#2-<:4[;(+F3DP9/$,OJIZ!OP/^UZ1X2\36^M
MVGV=T6WOK=0LMOVQ_>7U'\OR)Z"ZM8+RVDMKB))8)5*21NH*LIZ@BO(/$'A^
M\\&ZE#=VD\@L`X%I>$Y:V8](I3W0YPK'UP?]K%Q<'S1-E)37+(]EHKFO"WBR
MWUV'R)ML&I1C$L!/7'\2^H_E^1/2UK&2:NC)IIV84444Q!1110`4444`%%%%
M`!1110`56N;D0`*JEYGX2,'K_@/>BYN1``JJ7F?A(QW_`,![TEM;&(M+*WF3
MO]YL?H/05#;;LBDNK"VMC$6EE;S)W^\W]!Z"K5%%4DDA-W"BBBF(****`*T'
M_'Q=?]=!_P"@+5FJT'_'Q=?]=!_Z`M6:F.PV%%%%4(****`"BBB@`HHHH`**
M**`"D(#`@C(/4&EHH`H@G3SM8DVAZ$_\LO8_[/\`+Z=,;QOIFK:GH&-%O9K>
M]@?SD2)]OG8!^0GWST/&<9KIB`P((!!Z@U1);3N""UIV/>+Z_P"S_+Z=$UI8
MTA)QDI+=&#X3U#5I-!BNM7LGM,L0T;*04`Z-M/*K['IC/3IU0*NO8@C\Z4$,
M,C!%42#IYR.;0]0/^67N/]G^7TZ"5E8)RYY-VL.R=.."<VAZ'_GE_P#8_P`O
MITMNBR(58`J1@@]#2@JZ]B"/SJF"=.."2;0]#_SR_P#L?Y?3H$[B*QL'".2U
ML3A'/5/8^WH:O]J8Z+(A5@"I&"#T-4PSZ><.2UIV<GF/Z_[/OV[^M`;E^BBB
MF2%%%%`!1110`5#=6L%Y:R6US$DL$JE)(W4%64]01WJ:B@#Q7Q/X8N?"M[#<
M6\\HL%D'V*^#?/:/VCD/=><*Q]=K9S\W>>#O&*ZZAL;Y5@U:!?WD?02C^^GM
MTR.V>X()ZBZM8+RUDMKF))8)5*21NN593U!%>.>)_"]UX5NDNK::8:?$P>UO
ME)+V9S@)(><KSPYSP2&_VLG%Q=XFJDIJTCVGM17$^&_']G>:=<#6I8;&]LHR
M]QO.U'0?\M%]NF1SC(Z@@G&3Q?K^MZM#/I#&"WF;_1+&2`$S1@_-+,2-R+CT
M(P,?>)`JU--7,VFG9GI]%`Z450@HHHH`****`"JUU="!0H4O*QPD8ZL?\/>B
MZNA`H4*7E8X1!U8_X>]-M;4QL9YB'N''S,.@'H/:H<FW9%)=6%K;-%F69@]P
M_P!YAT`[`>PJT.E+13C%)";N%%%%4(****`"BBB@"M!_Q\77_70?^@+5FJT'
M_'Q=?]=!_P"@+5FICL-A1115""BBB@`HHHH`****`"BBB@`HHHH`*#S110!G
MD'3SD<VAZ@?\LO\`['^7TZ7@0X]0:4@$8(J@0=//K:'J!_RR_P#L?Y?3HBMP
M(.GG(YM#U`_Y9>_^[_+Z=+P*NO8@C\Z`0X[$&J)!T\Y'-H>H'_++_P"Q_E].
M@&_J.R=.."<VAZ'_`)Y?_8_R^G2[@$8QD&J]U))]BF>W1991&3&C'`<XX&?<
MUQW@_P`:QZKYUI<V[6ES;DB6V?.8<''?^'/'^S],83DD[%QI2G%R70ZSG3C@
M\V9Z'_GC_P#8_P`OITO4F`1SR#5+G3C@\VAZ'_GC_P#8_P`OIT9GN7J***8@
MHHHH`****`"F2Q1SPO%(BO&X*LK#(8'J"*?10!X=XU\&MH%SOBA9]#.&AG^\
M;)\_<?(_U>3P3G'(/%=A\.-4L9OM5M/A-:.#-O`!D0="A_NC/3MGWR>^EACG
MA>*1%>-P596&0P/4$5Y'XI\(R^')XKS39'BLXF!MYT/S6C=E8_W.<`GIG!R#
MSC*/*^9&T9<RY6>OT5R/@_QDFN1FRO@L&K0C]Y'T60?WU]O4=L]P03UU:QDF
MKHR::=F%%%%,056NKH0*``7E8X1!U8_X>]%U="!0%!>5CA$'5C_A3;6U,;&>
M8AYW')[`>@]JAMMV1275A:VIC8S3$/<./F;L!Z#VJW115122T$W<****8@HH
MHH`****`"BBB@"M!_P`?%T/^F@_]`6K-5HO^/NX_X#_*K-3'8;"BBBJ$%%%%
M`!1110`4444`%%%%`!1110`4444`%(0",$9I:*`,\@Z>>.;0]O\`GE_]C_+Z
M=+P(9>Q!I2`1@C-4"#IY];0]1_SR_P#L?Y?3HBMP(.GG(YM#U'_/+_['^7TZ
M.M],L8KZXOXK:);FY51-*J\R`=,_@?Y>E5O$(U230;K^Q'C74-N82X!!Y!(Y
MXY&1SQS5?1TO=+TFV^W$LS+OG4-GR7/)`Y/R`G'MCCCH=;%)>[>YH@G3C@\V
MAZ'_`)Y?_8_R^G2Z0",'D&F@JZ]B"/SJH"=/.&)-H>A_YY?_`&/\OIT"=PYT
MXX/-H>A_YX__`&/\OITO4AP1@C(-4LG3C@\VAZ'_`)Y?_8_R^G0%N7J***8@
MHHHH`****`"F30QSQ/%(BO&X*LK#(8'J"*?10!Y#XK\*3>'[F.^T^1TM4<&"
M=3\UJW96/=.<`GIG!XZ]?X/\8IKD9LKX"#5(1^\CZ"0?WE]O;MGTP3U<T,<\
M3Q2(KQN"K*PR&!Z@UY#XR\,S^&774]/=UM8F#0S@G=:G/W6/]SG@GIG!XK%Q
M<7>)JI*2M(]BJM=70@4!07E8X1!U8_X5R7A3QPNM67V:ZB,>K1@9AQCS!_>'
MMZCMGZ937/%*Z)>_9;>.*\U4J)+@O)MBM8NOS-@XSV'4]3Q3<[Z(GEMN=9:V
MIC8SS$/.XY/91Z#VJW5/2K[^T]+M;WR)(//C#^7(/F7/:KE:122);N%%%%,0
M4444`%5GN0LYC4!M@W2'/W!V^M6:BF@6;&20`<D`\'V/M0`^-UDC5U.589!]
M:=0.E%`!1110!6B_X^[C_@/\JLU6B_X^[C_@/\JLU$-AL****L04444`%%%%
M`!1110`4444`%%%%`!1110`4444`%(0",$4M%`&>0=//K:'M_P`\O_L?Y?3I
M>!##U!I2`1@C-4#G3CZVAZ_],O\`['^7TZ(K<"#I[9'-H>H_YY?_`&/\OITN
M@JZ]B"/SI00P]15$@Z<<];0]1_SR_P#L?Y?3H!OZC@3IQPQ)M#T/_/+_`.Q_
ME].ET@,,$9!I/E=>Q!'YU3!.GG#$FT/0_P#/+V/^S_+Z=`-PR=..#DVAZ'_G
ME_\`8_R^G2]VI"`PP1D&J63IYP23:'H?^>7_`-C_`"^G0%N7J***8@HHHH`*
M***`"HYH8YX7BE17C=2KJPR&!Z@BI**`/'/&'AMO#%S!?6EP\%J)`+>Y!YM7
M[(Q_N'H"?7!SGF;P+%;ZOJ+P:OY+W4;&XE1B0;F7/^L8=QTXR0..V*]8N+:&
M[MY+>XBCEAD4J\<BAE8'J"#UKQWQ7X4G\)W<=_I\DB::C@PW"GYK%NRL>\9S
M@$_=S@\&L)PL[HVC)25I'LPZ"EKD?!_C%-=C-E>A8-4A'[R/H)!_>7VZ<=L^
MF">NK6,DU=&333LPHHHJA!1110`4444`%%%%`!1110!6B_X^[C_@/\JLU6B_
MX^[C_@/\JLU$-AL****L04444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!2$`C!&:6B@#/.=./K:'_`,A?_8_R^G2\"&'J*4@$8(S5`YTX_P#3H?\`
MR%_]C_+Z=`K<"#IQSUM#U'_/+_['^7TZ7OE=<<$$?G6+XGL-0U70IH-*OVL[
MP8>*13@,1_"3V!K*\(ZIK+Z:[ZSI;V4<;;,L<=.K!3R$S^7;CI-];&BI\T.>
M^IT8)T\X8DVAZ'_GE['_`&?Y?3I=(#+@C(--^5UQP01^=5`3I[88DVAZ'_GE
M['_9_E].C,MP!.GG!)-H>A_YY?\`V/\`+Z=+W44A`*X(R#7(Z'XPT^\U*\TU
M/.@:UD*-#<`*R`'&1SRG\N,\$4FTMRXPE--I;'7T4#I15&84444`%%%%`!4<
MT,<\+Q2HKQNI5U89#`]014E%`'C'BOPI/X3NX[_3Y9$TU'!@N%)W6+=E8]XS
MG`)^[G!R#7<^#_&*:[&;*]"P:I"/WD?02#^\OM[=L]P03U4T,<\+Q2QJ\;J5
M=&&0P/4$5XWXM\(R>%[A+NS>0:6&!AG5COL7SPK-U\O/W6_AZ'(/.4HN+NC6
M+4M)'M%%<7X,\9C6!_9FI$1:K$OI@3@?Q+Z'U'XC(-=3J.I6>DZ=-?W\ZP6T
M*[G=NW^)/0`<DU<9)JZ,Y1<79ENBLO1->L]>M6GM1+&R-MDAF7;)&<`C<,\9
M!!_R:U*H04444`%%%%`!4,\Z01,\C8`_6B>=((F>1L*/UJM##)/*+FY&,?ZN
M,_P^Y]ZB4NB&EU86+R23W#RIL)*X7T&._O5^JT/_`!]W'_`?Y59HAH@EN%%%
M%6(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*0@$8(I:*
M`,\@Z<?^G,_^0?\`['^7TZ7AM([$&E(!&"*H8.G'_IS/_D'_`.Q_E].B*W`@
MZ<?^G0]1_P`\O_L?Y?3I>^5UQP01^=`PP]15$@Z<?^G0]?\`IE_]C_+Z=`-Q
MP)T]MK$FT)X/_/+V/^S_`"^G3)U7P;IVJZ_8ZT2\%W:ON9X3M\X8X5O;^G'2
MNA^5UQP01^=4I)DTE&>>15L1SYCG`A^I_N^_;Z=!I=1QE).\=&.!.GG#$FT/
M0_\`/+_['^7TZ7J3AEYP015($Z<<,2;0]#_SR_\`L?Y?3H"W+U%%%,D****`
M"BBB@`J.:&.>%X98T>-U*NCKD,#U!'<5)10!XOXM\)2^%YTN[.20:4'!AG5C
MOL'SPK-U\O)^5OX<X.0>8WUC6/%FH65E<1B74+<A+>,J5@#X.;B3&>0.PZ9X
MX;(]HFACGA>&6-'CD4JZ.N0P/4$=Q7C?BWPE+X6G2[M))!I0<&&=6.^P?/"L
MW7R\GY6_AS@Y!YQG!K6)M&2DK2/4]!T.'1+,QJYFGE.^>=A@R-].P'0#M[G)
M.K7&>#/&8UD?V9J6(M5B7TP)P.K*.Q]5]\C((-=EVK2,DUH92BXNS%HHHJA!
M4,\Z01-)(V`/UHGG2")G=L`?K5:&&2XE%S<#&/\`5QG^'W/O42ET0TNK"&&2
M>47%P,8_U<9_A]S[U>%`Z4M.,;`W<K1?\?=Q_P`!_E5FJT7_`!]W'_`?Y59I
M0V!A1115B"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`I"`1@BEHH`X?2O&MH?$E_H3V\ULUK,T:QR<'`/WE']TC#`=0#QD8QVJ,L
MB!E(92.#ZU@ZWX0TS7M4L=1N5D2ZLW!62)@I=0<[&..5SS[9.,9.=%U:P<R1
M@FV)RZ#^#_:'MZBIC?J;5'3DDX:/J!!TX_\`3F?_`"%_]C_+Z=+CI'/$T<B+
M)&PP589!%4M4EO#HUS)I2Q2WGE%K=9#\C-CC-9'AHZQ8Z-%-K@V2R$F6(%2+
M;L,;>-N`">3@D]NCOK8CEO&YM`G3VVL2;0]#_P`\O8_[/\OITND!A@@$&F_*
MZXX((_.J@)T]MK$FT)X)_P"67L?]G^7TZ!.X`G3SAB3:'H3_`,LO_L?Y?3I>
M[4A`9<$9!JD"=/.&.;0]#_SR]O\`=_E].@&Y>HHHIB"BBB@`HHHH`*CFACGA
M>&6-)(Y%*NCKD,#U!'<&I**`/%O%OA*7PM.EW:22#2@X,%PK'?8/GY59NOEY
M/ROSMS@Y!Y[7P9XT&L'^S-2Q#JT2YY&T7"C^)1Z^H'U&17830QSPO#-&DD<B
ME71UR&!Z@CN*\A\8>#G\..NHZ<TJZ7&P<,C$R:>PZ,#U,7_H/^[TR<7%WB:J
M2DN61[%4,\Z01,\C84?K7'>$O'"ZG";'566'4X4SE?NW"_WT]_4?CTKJ(87N
M)1<7`QCF.,_P^Y]Z?/?1$N-MPAADN)1<7`QCF.,_P^Y]ZO#I40N8/,DB$L9D
MB`,BAAE0>F1VJ8=*J,;$MW"BBBJ$5HO^/NX_X#_*K-5HO^/NX_X#_*K-1#8;
M"BBBK$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`8I,"EHH`SG1K!S)&";4G+H.?+]Q[>HJ\C)(@9<%6&0?6G8'I5!U>P<R
M1@FU)RZ#_EG[CV]105N!!TX_].A_\A?_`&/\OITN_*ZXX((_`T*RRH&!#*1D
M'UJD<Z<?^G0_^0O_`+'^7TZ(-_4<"=/;:Q)M#T/_`#R]C_L_R^G2Z0&7!`(-
M-^5UP<$$?@:I9?3S@_-9^N>8O_L?Y?3H!N.!.GMAB3:'H?\`GE[?[O\`+Z=+
MU,&UU[$$?@:J`G3VPQS:'H?^>7L?]G^7TZ`MR]1113$%%%%`!1110`4UT5U*
MLH(/!!'6G44`>.^,/!S^')!J.F^8FEH_F`QGY]/?^\O_`$R_]!_W>EM/B5JD
MNGQ:8EK$FLL&#WCD"!(P/]:!_$?]GIGG.*]5=%=2K*"I&"".#7C/BOP3+X99
MKZS=I-(67S$PN7T\]?\`@46?;Y?<9QE.+CK$UC)2]V1T?@SPS,)QK#O-"K;B
MKR?Z^[W??DD/4`X&![`\8`';V$LCLR%41(P`(U7&ST&>GKZ=O6N8\$^+TU6)
M=+OQ'!J4*?*%`"3H/XD_J.WTKM`!C@54'=$25G86BBBK)*T7_'W<?\!_E5FJ
MT7_'W<?\!_E5FHAL-A1115B"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"DP*6B@#/=6L',D8)M2<N@_Y9^X]O45=5
MDE0$896&0?6G8%4'5K!S)&";4G+H/^6?N/;U%!6X<Z<W_3H?_(7_`-C_`"^G
M2\,,/4&LO7(;Z_T&XATB[6VO)$'DSD9"\CZ]1D9]ZYCP3KFK26]U9ZK9S))8
M/Y4S[?ESZJ>_J1Z$$>E3S6=C2--S@YWV.M(.GMD?\>A/(_YY?_8_R^G2Z-KK
MC@@C\#0C)*@92&5AD'UJD0=.;/\`RZ$_]^O_`+'^7TZ49[C@3IYPQ)M#T/\`
MSR]C_L_R^G2]3/E=<<$$?@:J;CIQPQ)M#T/_`#R]C_L_R^G1"W+U%-#!AD'-
M.IB"BBB@`HHHH`*:\:R(590RG@@C@TZB@#Q_Q;X1?PQ.NIZ:&&EQOO&S[U@W
MJ._E?^@_3IV/A'Q>NLQBROB(]1C7H.DP_O+[^WXCVZUT61"K*&4C!!'!%>1>
M+/"<OA>?^TM,WKI:OO\`D)W6+9ZCOY6?^^?ITQE%Q?-$UC)27+(]>'2EKD?"
M'B]=9C%G>D1ZC&.G:4?WE]_;\1[=<.E:1DI*Z(E%Q=F5HO\`C[N/^`_RJS5:
M+_C[N/\`@/\`*K-*&PF%%%%6(****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"DP*6B@#.=&L',B`FU)RZ#_EG[
MCV]JO(R2(&7!!&01WIV!5!U:P<R(";4G+H/^6?N/;VH*W!U>P<R1@FV)RZ#^
M#W'MZBKJ,DJ!E(96&0>QH1ED0,I!4C(/K5)U>P<R1@FV)RZ#^#W'MZB@-Q"3
MIS9'_'H3R/\`GE_]C_+Z=+PVNN.""/SKEO&?A^X\1:3#+IMV\-]:/Y]LROA7
M;T/U['M],U=T;^U+#2;<ZL(Q)C$PB.5C.3@C_9(QGT/MTF^MBW!."DGKV+Y!
MTYLC_CT)Y'_/+_['^7TZ7E8,!@YXH!#KV((JB0=.;(_X]">1_P`\O_L?Y?3H
MR-S0HIJL"!@YIU,D****`"BBB@`IKQK(A1E#*PP01P13J*`/(/%GA.7PM/\`
MVEIF]=+5]P*$[K%L]1W\K_T'Z=.FT/Q_:/I,[ZS,MO<VD1>0]I5'=?4GT'7/
M%=N\:R(490RL,$$9!%>->,/"4WAN\-W90DZ&?G#+R;%\]".OE=QUV\]JQE%Q
M?-$UC)27+(U],U/Q#XC\0P7L'VFQ)97^S;SY4,&>LHZ-(PR,=NV,$UZ>.E<5
M\.+D7&EW2LK":.;$C$YWD@'</PQ7;55*[C=DS5I6"BBBM"`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"DP*6B@#/=6L',B`FU)RR#_`)9^X]O:KJ,LB!E(((R#ZT[`J@ZM8.9$!-J3
MEE'_`"S]Q[>W:@K<1T:P<R1@FU)RZ#_EG[CV]15Y625`RD,I&01T-1R2,;9I
M(5$C;247.`QQP,^]<IX5U+6IX+J\U33Y;&(2F,VKICR\=77U4Y]QP2*5];%*
M+DF^QT1!TYL_\NA_\A?_`&/\OITO###UI$9)8PRD,K#(/K5+!TXY_P"70_\`
MD+_['^7TZ!.X$'3CD?\`'H3R/^>7_P!C_+Z=+RL"!@YH&&'K5$@Z<Q(_X\R>
M?^F7_P!C_+Z=&&YH44U2"!@YIU!(4444`%%%%`!3'C21"KJ&5A@@C((I]%`&
M)X?\,V7AO[8E@9!!<2^:L+-E8>`-J^B]P.V<=*VZ**`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`I,"EHH`SG1K!RZ`FU)RR#_EG[CV]NU7D9'4,N"",@BG8!K/=9+!
MR\2,]LQ^:->2GN/4>WY4%;BNK6#F2,$VQ.70?\L_<>WJ*NJR2H&4AE(R".]$
M;I*BNC!E89!!R#5)U:P<R1@FU)RZ#_EG[CV]10&XA#Z<<JI:T/9>3%]/5?;M
M].EY&21`RD,I&01WH1ED0,I#*1D$=ZI.KV$AEC!-L3ET'5/<>WJ*`W]0(.G-
MD?\`'F>O_3+_`.Q_E].EY2"!@YI$9)4#*0RD9!'>J1!TXY'_`!YG_P`A?_8_
MR^G0#<T**:I!`P<TZ@D****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HP#110!0D1[*1IH5+0,<R1J,E?]I1_,=^HYZW(W26-71@RL,@@Y!IV
M`:SX_P!QJP@CXCFC>4KV#`KR/3.[G\_7**W1B'Q7I5CXGGT1+AA-&0'A*'AF
M4,-GKP1P/7CTKJ8W25%=&#*PR"#D&N3\7^%].URYTV[N/.BN89Q&LT#[&VDY
MP3CU&1Z<XZFMZ+_1]46"/B.:)Y&7L&!7D>F=QS[C/KF5>[3-JD:;A&4;WZBN
MK6#F2,$VQ.70?P>X]O45=1DE0,I#*1D$=Z=@8JA#^XU-[>/B)H_,V_W3G''M
M5F.Z`@Z<<C_CS/\`Y"_^Q_E].EX$$#!I2`15"T_<W\]JG$*(KHO]W)8$#VXZ
B?TQ0&ZN:%%':B@D****`"BBB@`HHHH`****`"BBB@#__V4*(
`

















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
        <int nm="BreakPoint" vl="500" />
        <int nm="BreakPoint" vl="513" />
        <int nm="BreakPoint" vl="506" />
        <int nm="BreakPoint" vl="533" />
        <int nm="BreakPoint" vl="529" />
        <int nm="BreakPoint" vl="549" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add support for different anchors" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="11/30/2023 1:01:06 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End