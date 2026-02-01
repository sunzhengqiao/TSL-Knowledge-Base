#Version 8
#BeginDescription
v1.05_11may2023_JF_Renamed to GE_AB_DIMS 
v1.03_09mar2020_DR_Adapted to better cashing of elements with their anchor sets + sending them as siblings groups to GE_ANCHOR_DIMS in order to aligning or staggering triggers
v1.02_04mar2020_DR_Implemented work with XRefs. Search for anchors TSL now based on search for "ANCHOR" key instead of whole scriptNames 
v1.01_03mar2020_DR_Allows use of XRefs 
v1.00_03mar2020_DR_Release
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
//region history
/// <History>
/// <version value="1.04" date="02apr2020" author="david.rueda@hsbcad.com"> Renamed from GE_ANCHOR_DIMS  </version>
/// <version value="1.03" date="09mar2020" author="david.rueda@hsbcad.com"> Adapted to better cashing of elements with their anchor sets + sending them as siblings groups to GE_ANCHOR_DIMS in order to aligning or staggering triggers </version>
/// <version value="1.02" date="04mar2020" author="david.rueda@hsbcad.com"> Implemented work with XRefs. Search for anchors TSL now based on search for "ANCHOR" key instead of whole scriptNames  </version>
/// <version value="1.01" date="03mar2020" author="david.rueda@hsbcad.com"> Allows use of XRefs  </version>
/// <version value="1.00" date="03mar2020" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Drag area
/// </insert>

/// <summary Lang=en>
/// Description
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|")))
//endregion
{
	// units
	U(1, "inch");
	
	// custom constants (for easy access)
	double dCrossSize = U(10);
	double dCircleDiameter = U(2.5);
	String sANCHOR = T("|ANCHOR|");
	String sMapKeyValue = "Value";
	String sMapKeyLocationMaps = "Locations";
	String sMapKeyLocationMap = "Location";
	String sMapKeyTSLHandle = "TSLHandle";
	Vector3d vDirections[] = { _XW, _YW};
	String sLayers [] ={ "SNAP HOR", "SNAP VER"};
	double dArrowLength = U(200);
	String sMapKeyDimAnchors = "DimAnchors";
	String sMapKeyElement = "Element";
	String sMapKeySiblings = "Siblings";
	
	// new TSLs props // WARNING: Always set mandatory values
	String sTSLChildName = "GE_AB_DIM";
	TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
	GenBeam gbsTsl[] = { };		Point3d ptsTsl[1];
	int nProps[] ={ };			double dProps[] ={ };				String sProps[] ={ };
	// - mandatory values -
	String sMapKeyLocationPoint = "LocationPoint";
	String sMapKeyReferencePoint = "ReferencePoint";
	String sMapKeyImInRegion = "ImInRegion";
	String sMapKeyImOrphan = "ImOrphan";
	String sMapKeyHideMe = "HideMe";
	String sMapKeyIsVertical = "IsVertical";
	String sMapKeyMyElement = "MyElement";
	String sMapKeyDimStyle = "DimStyle";
	String sMapKeyLayer = "Layer";
	String sMapKeyReferenceDirection = "ReferenceDirection";
	
	// constants
	double dEps = U(.001);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
			if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }}
		if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	// Triggers
	// TriggerReload
	int bReload;
	String sTriggerReload = T("|../Reload|");
	addRecalcTrigger(_kContext, sTriggerReload );
	if (_bOnRecalc && _kExecuteKey == sTriggerReload)
	{
		// prompt for elements
		PrEntity ssE(T("|Select element(s) or just hit ENTER to continue (this operation will load new anchors from previous and new selected elements)"), Element());
		ssE.allowNested(true);
		Element elements[0];
		if (ssE.go())
		{
			elements.append(ssE.elementSet());			
		}
		for (int e = 0; e < elements.length(); e++)
		{
			Element element = elements[e];
			if(!element.bIsValid())
				continue;
			if(_Element.find(element, -1)< 0)
				_Element.append(element);
		}//next e
	}
	
	// TriggerHideMissingAnchorsPanel
	String sMapKeyHideMissingAnchors = "HideMissingAnchors";
	int bHideMissingAnchors = _Map.getInt(sMapKeyHideMissingAnchors);
	String sTriggerHideMissingAnchorss[] = { T("../|Hide Missing Anchors|"), T("../|Show Missing Anchors|")};
	String sTriggerHideMissingAnchors = sTriggerHideMissingAnchorss[bHideMissingAnchors];
	addRecalcTrigger(_kContext, sTriggerHideMissingAnchors );
	if (_bOnRecalc && _kExecuteKey == sTriggerHideMissingAnchors )
	{
		bHideMissingAnchors = ! bHideMissingAnchors;
		_Map.setInt(sMapKeyHideMissingAnchors, bHideMissingAnchors);
		setExecutionLoops(2);
		return;
	}
	
	// TriggerReset
	int bReset;
	String sTriggerReset = T("|../Reset|");
	addRecalcTrigger(_kContext, sTriggerReset );
	if (_bOnRecalc && (_kExecuteKey == sTriggerReset))
	{
		bReset = ! bReset;
	}
	
	// TriggerDelete
	int bDelete;
	String sTriggerDelete = T("|../Delete|");
	addRecalcTrigger(_kContext, sTriggerDelete );
	if (_bOnRecalc && _kExecuteKey == sTriggerDelete)
	{
		bDelete = ! bDelete;
	}
	
	// OPM
	String sAlignments[] = { T("|Horizontal|"), T("|Vertical|")};
	String sAlignmentName = T("|Alignment|");
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	
	String sDimStyles[0];sDimStyles = _DimStyles;
	// sort dimstyles
	for (int i = 0; i < sDimStyles.length(); i++)
		for (int j = 0; j < sDimStyles.length() - 1; j++)
		{
			String s1 = sDimStyles[j];
			String s2 = sDimStyles[j + 1];
			if (s1.makeLower() > s2.makeLower())
				sDimStyles.swap(j, j + 1);
		}
	String sDimStyleName = T("|Dimstyle|");
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);
	sDimStyle.setCategory(category);
	
	// bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i = 0; i < sEntries.length(); i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey) >- 1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		PrEntity prssE (T("|Select walls|"), ElementWall());
		prssE.allowNested(true);
		if (prssE.go())
		{
			_Element.append(prssE.elementSet());
		}
		
		_PtG.append(getPoint("\nSelect start point"));
		while (1)
		{
			PrPoint ssP2("\nSelect end point", _PtG[0]);
			if (ssP2.go() == _kOk)
			{
				_PtG.append(ssP2.value());
				break;
			}
		}
		
		_Map.appendMap(sMapKeyLocationMaps, Map());
		return;
	}
	// end on insert	__________________
	
	// resolve properties
	int nAlignment = sAlignments.find(sAlignment, 0);
	String sLayer = sLayers[nAlignment];
	Vector3d vDirection = vDirections[nAlignment];
	int bIsVertical = nAlignment;
	sAlignment.setReadOnly(true);
	
	if (_PtG.length() < 2)
	{
		eraseInstance();
		return;
	}
	
	assignToLayer(sLayer);
	
	_PtG[0].setZ(0);
	_PtG[1].setZ(0);
	_Pt0 = (_PtG[0] + _PtG[1]) / 2;
	Point3d pt1 = _PtG[0] + _XW * _XW.dotProduct(_PtG[1] - _PtG[0]);
	Point3d pt2 = _PtG[0] + _YW * _YW.dotProduct(_PtG[1] - _PtG[0]);
	Display dp(-1);
	if (vDirection.dotProduct((_PtG[1] - _PtG[0])) < 0)
	{
		vDirection *= -1;
	}
	
	// collect realtime  anchor TSL  locations  from drawing
	Map  mapElementAndAnchorsSets; // stores maps containing a set of TSLs which belongs to element.Content type: [mapEx, mapEy, mapEz]		
	for (int e = 0; e < _Element.length(); e++)
	{
		Element element =  _Element[e];
		if ( ! element.bIsValid()) continue;
		
		Point3d ptElMidHeight = element.ptOrg() + element.vecY() * U(1000);
		int bIsPerpendicular = false;
		if ( abs(element.vecX().dotProduct(vDirection)) < dEps)
		{
			bIsPerpendicular = true;
		}
		
		TslInst tsls[] = element.tslInst();
		tsls.append(element.tslInstAttached());
		TslInst tslElementAnchors[0]; // nneds to collect all anchors to later pick only those to be dimensioned (can be 2 only when wall is perpendicular to dim direction)
		TslInst arTemp[0];
		for (int t = 0; t < tsls.length(); t++)
		{
			// validate
			TslInst tsl = tsls[t];
			if (arTemp.find(tsl) >- 1) continue;
			arTemp.append(tsl);
			
			if ( ! tsl.bIsValid() || tsl.scriptName().makeUpper().find(sANCHOR, - 1) < 0 || tsl.scriptName() == _ThisInst.scriptName() || tsl.scriptName() == sTSLChildName)
				continue;
			
			// filter only inside region
			Vector3d vDirX = (_PtG[0] - pt1); vDirX.normalize();
			Vector3d vDirY = (_PtG[0] - pt2); vDirY.normalize();
			if (vDirX.dotProduct(tsl.ptOrg() - pt1) * vDirX.dotProduct(tsl.ptOrg() - _PtG[0]) >= 0 || vDirY.dotProduct(tsl.ptOrg() - pt2) * vDirY.dotProduct(tsl.ptOrg() - _PtG[0]) >= 0 ) //it's not inside'
				continue;
			
			// filter by height
			if (tsl.ptOrg().Z() > ptElMidHeight.Z())
				continue;
			
			tslElementAnchors.append(tsl); // nneds to collect all anchors to later pick only those to be dimensioned (can be 2 only when wall is perpendicular to dim direction)
		}//next t
		
		// collect anchors that will be displayed on this element (could be 2 only if wall)
		TslInst tslElementDimAnchors[0]; 
		// filter by wall direction
		if (bIsPerpendicular) //dim only extremes
		{
			// sort positions, take most left and most right
			double dL = - 1, dR = - 1;
			TslInst tslLeft, tslRight;
			Point3d ptLeft = element.ptOrg() + element.vecX() * 100000;
			Point3d ptRight = element.ptOrg() - element.vecX();
			for (int s = 0; s < tslElementAnchors.length(); s++)
			{
				TslInst tsl = tslElementAnchors[s];
				Point3d ptTsl = tsl.ptOrg();
				
				if (element.vecX().dotProduct(ptLeft - ptTsl) > dL) //most left
				{
					tslLeft = tsl;
					ptLeft = ptTsl;
					dL = element.vecX().dotProduct(ptLeft - ptTsl);
					
				}
				if (element.vecX().dotProduct(ptTsl - ptRight) > dR) //most right
				{
					tslRight = tsl;
					ptRight = ptTsl;
					dR = element.vecX().dotProduct(ptTsl - ptRight);
				}
			}//next s
			
			if (tslLeft.bIsValid())
			{
				tslElementDimAnchors.append(tslLeft);
			}
			
			if (tslRight.bIsValid())
			{
				tslElementDimAnchors.append(tslRight);
			}
		}
		else //dim all anchors
		{
			tslElementDimAnchors.append(tslElementAnchors);
		}
		
		// create subMap
		Map mapElementAndAnchorsSet();
		mapElementAndAnchorsSet.setMapKey(element.handle());
		// store element
		mapElementAndAnchorsSet.setEntity(sMapKeyElement, element);		
		
		// store sibling sets
		Entity entElementDimAnchors[0];
		for (int t = 0; t < tslElementDimAnchors.length(); t++)
		{
			entElementDimAnchors.append(tslElementDimAnchors[t]);
		}//next t
		mapElementAndAnchorsSet.setEntityArray(entElementDimAnchors, false, sMapKeyDimAnchors, sMapKeyDimAnchors, sMapKeyDimAnchors);
		
		// cash subMap
		mapElementAndAnchorsSets.setMap(element.handle(), mapElementAndAnchorsSet);
	}//next e
		
	// reset + delete
	Map mapLocations = _Map.getMap(sMapKeyLocationMaps);
	if (bReset || bDelete)
	{
		for (int m = mapLocations.length() - 1; m >= 0; m--)
		{
			Map mapLocation = mapLocations.getMap(m);
			String sStoredLocationHandle = mapLocation.getString(sMapKeyTSLHandle);
			
			Entity entLocation;
			entLocation.setFromHandle(sStoredLocationHandle);
			if ( ! entLocation.bIsValid())
			{
				continue;
			}
			
			TslInst tslLocation = (TslInst) entLocation;
			if ( ! tslLocation.bIsValid())
			{
				mapLocation.removeAt(m, true);
				if (bDebug) { reportMessage("\n" + scriptName() + ": " + T("|Removing stored location|") + "\n"); }
				continue;
			}
			
			if (bReset || bDelete)
			{
				tslLocation.dbErase();
			}
		}//next m
		
		// reset
		mapLocations = Map();
		_Map.setMap(sMapKeyLocationMaps, mapLocations);
		
		if (bDelete)
		{
			eraseInstance();
			return;
		}
	}
	
	// create model anchors in local list if not found
	TslInst tslInsideRegionAnchors[0];
	for (int m = 0; m < mapElementAndAnchorsSets.length(); m++)
	{
		// collect info
		Map mapElementAndAnchorsSet = mapElementAndAnchorsSets.getMap(m);
		Entity entAnchors[] = mapElementAndAnchorsSet.getEntityArray(sMapKeyDimAnchors, sMapKeyDimAnchors, sMapKeyDimAnchors);
		Entity entity = mapElementAndAnchorsSet.getEntity(sMapKeyElement);
		Element element = (Element) entity;
		if ( ! element.bIsValid())
			continue;
		String sElementNumber = element.code() + "-" + element.number();
		
		// cash info for every anchor found + collect siblings
		TslInst tslSiblings[0]; Entity entSiblings[0];
		for (int e = 0; e < entAnchors.length(); e++)
		{
			Entity entAnchor = entAnchors[e];
			TslInst tslAnchor = (TslInst) entAnchor;
			if ( ! tslAnchor.bIsValid()) //could be deleted
				continue;
			
			tslInsideRegionAnchors.append(tslAnchor);
			
			int bIsLocationOnList;
			Point3d ptAnchor = tslAnchor.ptOrg();
			for (int m = 0; m < mapLocations.length(); m++)
			{
				Map mapLocation = mapLocations.getMap(m);
				Point3d ptLocation = mapLocation.getPoint3d(sMapKeyLocationMap);
				if ((ptAnchor - ptLocation).length() < dEps) //point is on the list
				{
					bIsLocationOnList = true;
					break;
				}
			}//next p
			
			if ( ! bIsLocationOnList) //point not listed, create new and append to list
			{
				// create TSL instance
				Entity entsTsl[0];
				entsTsl.append(element);
				ptsTsl[0] = ptAnchor;
				Map mapTsl;
				mapTsl.setString(sMapKeyLayer , sLayer);
				mapTsl.setString(sMapKeyMyElement, sElementNumber);
				mapTsl.setPoint3d(sMapKeyLocationPoint, ptAnchor , _kAbsolute);
				mapTsl.setPoint3d(sMapKeyReferencePoint, _PtG[0], _kAbsolute);
				mapTsl.setInt(sMapKeyImInRegion, -1);
				mapTsl.setInt(sMapKeyImOrphan, -1);
				mapTsl.setInt(sMapKeyHideMe, -1);
				mapTsl.setInt(sMapKeyIsVertical, -1);
				mapTsl.setString(sMapKeyDimStyle, sDimStyle);
				mapTsl.setVector3d(sMapKeyReferenceDirection, vDirection);				
								
				tslNew.dbCreate(sTSLChildName , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				tslSiblings.append(tslNew);
				entSiblings.append(tslNew);
				
				// store new anchor on local list
				Map mapNewLocation;
				mapNewLocation.setString(sMapKeyLayer , sLayer);
				mapNewLocation.setString(sMapKeyMyElement, sElementNumber);
				mapNewLocation.setString(sMapKeyTSLHandle, tslNew.handle());
				mapNewLocation.setPoint3d(sMapKeyLocationMap, ptAnchor, _kAbsolute);
				mapNewLocation.setString(sMapKeyMyElement, sElementNumber);
				mapLocations.appendMap(sMapKeyLocationMap, mapNewLocation);
				
				if (bDebug) { reportMessage("\n" + scriptName() + "- Created TSL :" + tslNew.handle() + "\n"); }
			}
		}//next e
		
		// append siblings info
		for (int t = 0; t < tslSiblings.length(); t++)
		{
			TslInst tslSibling = tslSiblings[t];
			Map map = tslSibling.map();
			map.setEntityArray(entSiblings, false, sMapKeySiblings, sMapKeySiblings, sMapKeySiblings);
			tslSibling.setMap(map);
		}//next e
	}//next m
	
	// update local list
	_Map.setMap(sMapKeyLocationMaps, mapLocations);
	
	// set locations status / clean local list: remove gone children TSLs 
	for (int m = 0; m < mapLocations.length(); m++)
	{
		// validate
		Map mapLocation = mapLocations.getMap(m);
		Point3d ptLocation = mapLocation.getPoint3d(sMapKeyLocationMap);
		String sStoredHandle = mapLocation.getString(sMapKeyTSLHandle);
		Entity entStoredAnchor;
		entStoredAnchor.setFromHandle(sStoredHandle);
		if ( ! entStoredAnchor.bIsValid())
			continue;
		TslInst tslStoredAnchor = (TslInst) entStoredAnchor;
		if ( ! tslStoredAnchor.bIsValid())
			continue;
		
		Map mapNew = tslStoredAnchor.map();
		
		//listed anchors not in the region anymore.Don't delete them, they might have their own custom info like position
		Vector3d vDirX = (_PtG[0] - pt1); vDirX.normalize();
		Vector3d vDirY = (_PtG[0] - pt2); vDirY.normalize();
		int bImInRegion = true;
		if (vDirX.dotProduct(ptLocation - pt1) * vDirX.dotProduct(ptLocation - _PtG[0]) >= 0 || vDirY.dotProduct(ptLocation - pt2) * vDirY.dotProduct(ptLocation - _PtG[0]) >= 0 ) //it's not inside
		{
			bImInRegion = false;
		}
		
		//listed anchors not in the model anymore.Don't delete them, they might have their own custom info like position
		int bImOrphan = true;
		for (int t = 0; t < tslInsideRegionAnchors.length(); t++)
		{
			if ((ptLocation - tslInsideRegionAnchors[t].ptOrg()).length() < dEps)
			{
				bImOrphan = false;
				break;
			}
		}//next t
		
		int bHideMe = false;
		if (bImOrphan && bHideMissingAnchors)
		{
			bHideMe = true;
		}
		
		mapNew.setPoint3d(sMapKeyReferencePoint, _PtG[0], _kAbsolute);
		mapNew.setInt(sMapKeyImInRegion, bImInRegion);
		mapNew.setInt(sMapKeyImOrphan, bImOrphan);
		mapNew.setInt(sMapKeyHideMe, bHideMe);
		mapNew.setInt(sMapKeyIsVertical, bIsVertical);
		mapNew.setString(sMapKeyDimStyle, sDimStyle);
		mapNew.setVector3d(sMapKeyReferenceDirection, vDirection);
		tslStoredAnchor.setMap(mapNew);
		tslStoredAnchor.recalc();
	}//next m
	
	// update local list
	_Map.setMap(sMapKeyLocationMaps, mapLocations);
	
	// Display
	// rectangle
	PLine plRegion;
	plRegion.createRectangle(LineSeg(_PtG[0], _PtG[1]), _XW, _YW);
	dp.draw(plRegion);
	// cross
	double dXl = dCrossSize; Point3d ptX = _PtG[0]; PLine plTmp (_ZW); plTmp.addVertex(ptX - _XW * dXl * .5); plTmp.addVertex(ptX + _XW * dXl * .5); plTmp.addVertex(ptX);
	plTmp.addVertex(ptX - _YW * dXl * .5); plTmp.addVertex(ptX + _YW * dXl * .5); dp.draw(plTmp); plTmp = PLine (_XW); plTmp.addVertex(ptX - _ZW * dXl * .5); plTmp.addVertex(ptX + _ZW * dXl * .5); dp.draw(plTmp);
	// circle hatch
	PLine plCircle;
	plCircle.createCircle(_PtG[0], _ZW, dCircleDiameter * .5);
	PlaneProfile ppCircle(plCircle);
	Hatch hatchCircle("SOLID", U(1));
	dp.draw(ppCircle, hatchCircle);
	
	Display vecdp(-1);
	vecdp.dimStyle(sDimStyle);
	Vector3d vecD = vDirection;
	vecD.normalize();
	double vecdLength = dArrowLength, vecdArrowFactor = 0.2, vecdCircleFactor = 0.03, vecdRadius = vecdLength * vecdCircleFactor; Point3d vecptStart = _PtG[0], vecptEnd = vecptStart + vecD * vecdLength;
	LineSeg vecls (vecptStart, vecptEnd); vecdp.draw(vecls); Point3d vecptArrowNeck = vecptEnd - vecD * vecdLength * vecdArrowFactor;
	PLine vecplCircle(vecD); vecplCircle.createCircle(vecptArrowNeck, vecD, vecdRadius); vecdp.draw(vecplCircle);
	Vector3d vecvY = (vecplCircle.ptEnd() - vecptArrowNeck); vecvY.normalize();Vector3d vecvZ = vecD.crossProduct(vecvY); LineSeg veclsArrow1 (vecptEnd, vecptArrowNeck + vecvY * vecdRadius); vecdp.draw(veclsArrow1);
	LineSeg veclsArrow2 (vecptEnd, vecptArrowNeck - vecvY * vecdRadius); vecdp.draw(veclsArrow2); LineSeg veclsArrow3 (vecptEnd, vecptArrowNeck + vecvZ * vecdRadius); vecdp.draw(veclsArrow3);
	LineSeg veclsArrow4 (vecptEnd, vecptArrowNeck - vecvZ * vecdRadius); vecdp.draw(veclsArrow4); vecdp.textHeight(vecdLength * .14);
	
	if (bDebug){TslInst tslOut = _ThisInst; Map mapOut = tslOut.map(); String sMapName = tslOut.scriptName() + "_" + tslOut.handle(); String sMapPath = "C:\\Temp\\DebugMaps\\" + sMapName; mapOut.writeToDxxFile(sMapPath + + ".dxx"); reportMessage(sMapName + " was written to " + sMapPath + "\n");}
}
#End
#BeginThumbnail







#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Renamed to GE_AB_DIMS" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="5/11/2023 12:47:32 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End