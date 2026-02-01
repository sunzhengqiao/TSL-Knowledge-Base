#Version 8
#BeginDescription
This Tsl tool creates the multi elements in the drawing. All parts of the multi elements can be adjusted.
The data is created by the Tsl tool hsbMultiwallManager. 

1.4 22.02.2022 HSB-14360 Add option to handle updates and refresh multiwall Author: Nils Gregor

1.5 24.02.2022 HSB-14360 Bugfix: Multi element stays now in same group. Author: Nils Gregor

1.6 04/11/2022 Add option to only recalc 1 group Author: Robert Pol

Version 1.7 15-1-2025 Add property to show multiElement names. Ronald van Wijngaarden

Version 1.8 5-2-2025 Move drawing of the multiElementNames outside of the CreateMultiElements loop to make it more flexible. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates the multielements based on the meta data which is attached to the single elements. It processes all elements in the drawing.
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// The map x data needs to be present in a map with "hsb_Multiwall" as key. 
/// The transformation vectors are stored as points in this map.
/// </remark>

/// <version  value="1.00" date="24.05.2019"></version>

/// <history>
/// AS - 1.00 - 23.05.2019	- Pilot version
/// AS - 1.01 - 24.05.2019	- Only allow one instance of the manager in the drawing. Set bounding box.
/// </history>

//#Versions
//1.8 5-2-2025 Move drawing of the multiElementNames outside of the CreateMultiElements loop to make it more flexible. Ronald van Wijngaarden
//1.7 15-1-2025 Add property to show multiElement names. Ronald van Wijngaarden



	Unit (0.001, "mm");
	
	String groupsToCheck[] = 
	{
		T("|All|"),
		T("|This|")
	};
	
	String sYesNo[] = 
	{
		T("|Yes|"),
		T("|No|")
	};
	
	String category = T("|Spacing|");
	PropDouble verticalOffset (0, U(4000), T(" Vertical offset between multielements"));
	verticalOffset.setCategory(category);
	PropDouble horizontalOffset (1, U(0), T(" Horizontal offset between multielements"));
	horizontalOffset.setCategory(category);
	
	category = T("|Assignment|");
	Group allGroups[] = Group().allExistingGroups();
	Group floorGroups[0];
	String floorGroupNames[0];
	for (int g=0;g<allGroups.length();g++)
	{
		Group group = allGroups[g];
		if (group.namePart(1) != "" && group.namePart(2) == "")
		{
			floorGroups.append(group);
			floorGroupNames.append(group.name());
		}
	}
	String sortedFloorGroupNames[] = floorGroupNames.sorted();
	
	PropString multielementFloorGroupName(0, sortedFloorGroupNames, T("|Assign to group|"));
	multielementFloorGroupName.setCategory(category);
	
	PropString singleelementFloorGroupName(2, sortedFloorGroupNames, T("|Single elements group|"));
	multielementFloorGroupName.setCategory(category);
	
	PropString groupingFormat(1, "", T("|Grouping format|"));
	groupingFormat.setDescription(T("|Specifies the format for grouping the multi-elements|"));
	
	PropString pGroupsToCheck(3, groupsToCheck, T("|Groups to check|"));
	pGroupsToCheck.setDescription(T("|Specifies whether to check all groups or just the groups from this tsl|"));
	
	PropString pShowMultiElementNames(4, sYesNo, T("|Show MultiElement Names|"), 1);
	pShowMultiElementNames.setDescription(T("|Show the multiElement Names on the left side of the multiElements.|"));
	
	int bUpadteExisting = true;
	int bUpdateSingle = false;


	if (_bOnInsert) 
	{
		if (insertCycleCount()>1) 
		{
			eraseInstance();
			return;
		}
		
		showDialogOnce();
		
		Group singleelementFloorGroup = floorGroups[floorGroupNames.find(singleelementFloorGroupName, 0)];
	
		Entity allElements[]=Group().collectEntities(true, Element(), _kModel);
		if (pGroupsToCheck == T("|This|"))
		{
			allElements = singleelementFloorGroup.collectEntities(true, Element(), _kModelSpace);
		}
		
		for (int e = 0; e < allElements.length(); e++)
		{
			Element el = (Element)allElements[e];
			
			if (el.bIsValid())
			{
				Map mp = el.subMapX("hsb_Multiwall");
				if (mp.length() > 0)
				{
					_Element.append(el);
				}
			}
		}
	
		_Pt0=getPoint(T("|Pick a point|"));
		_Map.setInt("Inserted", true);
	
		return;
	}

	int createMultielements = false;
	if (_Map.hasInt("Inserted"))
	{
		createMultielements = _Map.getInt("Inserted");
		_Map.removeAt("Inserted", true);
	}
	
	Group multielementFloorGroup = floorGroups[floorGroupNames.find(multielementFloorGroupName, 0)];
	Group singleelementFloorGroup = floorGroups[floorGroupNames.find(singleelementFloorGroupName, 0)];
	
	String doubleClickAction = "TslDoubleClick";
	String refreshMulitElementsCommand = T("../|Refresh all Multielements|");
	String updateMulitElementsCommand = "update Multielements";
	addRecalcTrigger(_kContext, refreshMulitElementsCommand );
	if (_bOnRecalc && (_kExecuteKey == refreshMulitElementsCommand || _kExecuteKey == doubleClickAction || _kExecuteKey == updateMulitElementsCommand) || _bOnDebug)
	{
		_Element.setLength(0);
		String sElementNumbers[0];
		
		if(_kExecuteKey == updateMulitElementsCommand)
		{
			Entity _mulitiElements[] = Group().collectEntities(true, ElementMulti(), _kModelSpace);
			if (pGroupsToCheck == T("|This|"))
			{
				_mulitiElements = multielementFloorGroup.collectEntities(true, ElementMulti(), _kModelSpace);
			}
			
			for (int i = 0; i < _mulitiElements.length(); i++)
			{
				ElementMulti multielement = (ElementMulti)_mulitiElements[i];
				SingleElementRef singleElementRefs[] = multielement.singleElementRefs();
				for ( int j = 0; j < singleElementRefs.length(); j++)
				{
					sElementNumbers.append(singleElementRefs[j].number());
				}
			}			
			bUpadteExisting = false;
		}
		
		Entity allElements[] = Group().collectEntities(true, Element(), _kModel);
		if (pGroupsToCheck == T("|This|"))
		{
			allElements = singleelementFloorGroup.collectEntities(true, Element(), _kModelSpace);
		}
		
		for (int e = 0; e < allElements.length(); e++)
		{
			Element el = (Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp = el.subMapX("hsb_Multiwall");
				if (mp.length() > 0 && sElementNumbers.find(el.number(), -1) < 0)
				{
					_Element.append(el);
				}
			}
		}
		createMultielements = true;
	}
	
	String sSelectedMultiElement;
	Group grSelectedMultiElement;
	String refreshSingleMulitElementCommand = T("../|Refresh selected Multielement|");
	addRecalcTrigger(_kContext, refreshSingleMulitElementCommand);
	if (_bOnRecalc && _kExecuteKey == refreshSingleMulitElementCommand)
	{
		_Element.setLength(0);
		String sElementNumbers[0];
		ElementMulti multielement = getElementMulti(T("|Select Multielement|"));
		sSelectedMultiElement = multielement.number();
		grSelectedMultiElement = multielement.elementGroup();
		
		SingleElementRef singleElementRefs[] = multielement.singleElementRefs();
		for ( int j = 0; j < singleElementRefs.length(); j++)
		{
			sElementNumbers.append(singleElementRefs[j].number());
			
			Entity multielementEntities[] = singleElementRefs[j].entitiesFromMultiElementBuild();
			for (int k = 0; k < multielementEntities.length(); k++)
			{
				Entity multielementEntity = multielementEntities[k];
				multielementEntity.dbErase();			
			}
		}
		
		Group selectedElementGroup = multielement.elementGroup();	
		multielement.dbErase();
		selectedElementGroup.dbErase();
	
		bUpadteExisting = false;
		
		Entity allElements[] = Group().collectEntities(true, Element(), _kModel);
		if (pGroupsToCheck == T("|This|"))
		{
			allElements = singleelementFloorGroup.collectEntities(true, Element(), _kModelSpace);
		}
		
		for (int e = 0; e < allElements.length(); e++)
		{
			Element el = (Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp = el.subMapX("hsb_Multiwall");
				if (mp.length() > 0 && sElementNumbers.find(el.number(), -1) > -1)
				{
					_Element.append(el);
				}
			}
		}
		createMultielements = true;
		bUpdateSingle = true;
		
	}

	String deleteMultielementMetaData = T("|Delete Multielement Metadata|");
	addRecalcTrigger(_kContext, deleteMultielementMetaData);
	if (_bOnRecalc && _kExecuteKey==deleteMultielementMetaData)
	{
		_Element.setLength(0);
		
		Entity allElements[]=Group().collectEntities(true, Element(), _kModel);
		if (pGroupsToCheck == T("|This|"))
		{
			allElements = singleelementFloorGroup.collectEntities(true, Element(), _kModelSpace);
		}
		
		for (int e=0; e<allElements.length(); e++)
		{
			Element el=(Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp=el.subMapX("hsb_Multiwall");
				if (mp.length()>0)
				{
					el.removeSubMapX("hsb_Multiwall");
				}
			}
		}
		
		createMultielements = true;
	}

	Display dp(-1);
	
	dp.textHeight(U(500));
	dp.draw(T("|Multielement Manager|"), _Pt0, _XW, _YW, 1, 1);
	
	
	if (createMultielements || _bOnDebug)
	{
		Map mapMultiPosition;
		
		Entity _tsls[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		if (pGroupsToCheck == T("|This|"))
		{
			_tsls = multielementFloorGroup.collectEntities(true, TslInst(), _kModelSpace);
		}
		
		for (int t = 0; t < _tsls.length(); t++)
		{
			TslInst tsl = (TslInst)_tsls[t];
			if (tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle())
			{
				tsl.dbErase();
			}
		}
		
		if(bUpadteExisting)
		{
			Entity _mulitiElements[] = Group().collectEntities(true, ElementMulti(), _kModelSpace);
			if (pGroupsToCheck == T("|This|"))
			{
				_mulitiElements = multielementFloorGroup.collectEntities(true, ElementMulti(), _kModelSpace);
			}
			
			for (int i = 0; i < _mulitiElements.length(); i++)
			{
				ElementMulti multielement = (ElementMulti)_mulitiElements[i];
				SingleElementRef singleElementRefs[] = multielement.singleElementRefs();
				for ( int j = 0; j < singleElementRefs.length(); j++)
				{
					Entity multielementEntities[] = singleElementRefs[j].entitiesFromMultiElementBuild();
					for (int k = 0; k < multielementEntities.length(); k++)
					{
						Entity multielementEntity = multielementEntities[k];
						multielementEntity.dbErase();
					}
				}
				Group multielementGroup = multielement.elementGroup();
				multielement.dbErase();
				multielementGroup.dbErase();
			}		
		}
		
		String singlElementNumbers[0];
		String multiElementNumbers[0];
		String multiElementGroupingKeys[0];
		Element singleElements[0];
		CoordSys singleInMultiCoordSystems[0];
		for (int e = 0; e < _Element.length(); e++)
		{
			Element el = _Element[e];
			Map mp = el.subMapX("hsb_Multiwall");
			
			Point3d pt = mp.getPoint3d("PtOrg");
			Vector3d vx = mp.getPoint3d("VecX");
			Vector3d vy = mp.getPoint3d("VecY");
			Vector3d vz = mp.getPoint3d("VecZ");
			vx.normalize();
			vy.normalize();
			vz.normalize();
			
			CoordSys singleInMultiCoordSystem(pt, vx, vy, vz);
			if ( mp.hasString("Number"))
			{
				singlElementNumbers.append(el.number());
				multiElementNumbers.append(mp.getString("Number"));
				singleElements.append(el);
				singleInMultiCoordSystems.append(singleInMultiCoordSystem);
				if (groupingFormat != "")
				{
					String groupingKey = el.formatObject(groupingFormat);
					multiElementGroupingKeys.append(groupingKey);
				}
				else
				{
					multiElementGroupingKeys.append("");
				}
			}
		}
		
		for (int s1 = 1; s1 < multiElementNumbers.length(); s1++)
		{
			int s11 = s1;
			for (int s2 = s1 - 1; s2 >= 0; s2--)
			{
				if ( multiElementNumbers[s11] < multiElementNumbers[s2] )
				{
					multiElementNumbers.swap(s2, s11);
					singlElementNumbers.swap(s2, s11);
					singleElements.swap(s2, s11);
					singleInMultiCoordSystems.swap(s2, s11);
					multiElementGroupingKeys.swap(s2, s11);
					s11 = s2;
				}
			}
		}
		
		if (groupingFormat != "")
		{
			for (int s1 = 1; s1 < multiElementGroupingKeys.length(); s1++)
			{
				int s11 = s1;
				for (int s2 = s1 - 1; s2 >= 0; s2--)
				{
					if ( multiElementGroupingKeys[s11] < multiElementGroupingKeys[s2] )
					{
						multiElementNumbers.swap(s2, s11);
						singlElementNumbers.swap(s2, s11);
						singleElements.swap(s2, s11);
						singleInMultiCoordSystems.swap(s2, s11);
						multiElementGroupingKeys.swap(s2, s11);
						s11 = s2;
					}
				}
			}
		}
		
		CoordSys multiElementCoordSys(_Pt0, _XW, _YW, _ZW);
		
		if(!bUpadteExisting)
		{
			mapMultiPosition = _Map.getMap("MultielementPositions");
		
			if(mapMultiPosition.length() > 0)
			{
				if(!bUpdateSingle)
				{
					Point3d ptLastPos = mapMultiPosition.getPoint3d(mapMultiPosition.length() - 1);
					double dToNewPos = _YW.dotProduct(_Pt0 - ptLastPos);
					multiElementCoordSys.transformBy(-_YW * dToNewPos);					
				}
				else
				{
					if(mapMultiPosition.hasPoint3d(sSelectedMultiElement))
					{
						Point3d ptSelectedME = mapMultiPosition.getPoint3d(sSelectedMultiElement);		
						double dToNewPos = _YW.dotProduct(_Pt0 - ptSelectedME) - verticalOffset;
						multiElementCoordSys.transformBy(-_YW * dToNewPos);	
					}
				}
			}
		}
		
		String currentMultielementNumber;
		ElementMulti currentMultiElememt;
		double groupWidth = 0;
		String currentMultiElementGroupingKey = "";
		
		for (int m = 0; m < multiElementNumbers.length(); m++)
		{
			String multiElementNumber = multiElementNumbers[m];
			String multiElementGroupingKey = multiElementGroupingKeys[m];
			
			String singleElementNumber = singlElementNumbers[m];
			Element singleElement = singleElements[m];
			CoordSys singleInMultiCoordSystem = singleInMultiCoordSystems[m];
			
			if (m == 0 || currentMultielementNumber != multiElementNumber)
			{
				if (m!=0 || bUpdateSingle)
				{
					// Calculate the bounds
					Point3d singleElementRefsVertices[0];
					SingleElementRef singleElementRefs[] = currentMultiElememt.singleElementRefs();
					Point3d min, max;
					for (int s = 0; s < singleElementRefs.length(); s++)
					{
						LineSeg minMax = singleElementRefs[s].segmentMinMax();
						if (s == 0 || _XW.dotProduct(minMax.ptStart() - min) < 0)
						{
							min = minMax.ptStart();
						}
						if (s == 0 || _XW.dotProduct(minMax.ptEnd() - max) > 0)
						{
							max = minMax.ptEnd();
						}
					}
					
					double sizeX = _XW.dotProduct(max - min);
					double sizeY = _YW.dotProduct(max - min);
					
					currentMultiElememt.setDXMax(sizeX);
					currentMultiElememt.setDYMax(sizeY);
					
					if (sizeX > groupWidth)
					{
						groupWidth = sizeX;
					}
				}
				if (m>0 && multiElementGroupingKey != currentMultiElementGroupingKey)
				{
					multiElementCoordSys.transformBy(_YW * _YW.dotProduct(_Pt0 - multiElementCoordSys.ptOrg()) + _XW * (groupWidth + horizontalOffset));
					groupWidth = 0;
				}
				
				currentMultiElementGroupingKey = multiElementGroupingKey;				
				multiElementCoordSys.transformBy( - _YW * verticalOffset);			
				mapMultiPosition.setPoint3d(multiElementNumber, multiElementCoordSys.ptOrg());
				
				// Create the first multi element
				Group multielementGroup(multielementFloorGroup.namePart(0), multielementFloorGroup.namePart(1), multiElementNumber);
				currentMultiElememt.dbCreate(multielementGroup, multiElementCoordSys);				
				currentMultielementNumber = multiElementNumber;
			}
			// Add the single element
			currentMultiElememt.insertSingleElement(_kCurrentDatabase, singleElementNumber, singleInMultiCoordSystem, Map());
			
			double yHeight = U(0);
			
			if (m == (multiElementNumbers.length() - 1))
			{
				// Calculate the bounds
				Point3d singleElementRefsVertices[0];
				SingleElementRef singleElementRefs[] = currentMultiElememt.singleElementRefs();
				Point3d min, max;
				for (int s = 0; s < singleElementRefs.length(); s++)
				{
					LineSeg minMax = singleElementRefs[s].segmentMinMax();
					if (s == 0 || _XW.dotProduct(minMax.ptStart() - min) < 0)
					{
						min = minMax.ptStart();
					}
					if (s == 0 || _XW.dotProduct(minMax.ptEnd() - max) > 0)
					{
						max = minMax.ptEnd();
					}
				}
				
				currentMultiElememt.setDXMax(_XW.dotProduct(max - min));
				currentMultiElememt.setDYMax(_YW.dotProduct(max - min));
			}
		}
		
		_Map.setString("LastRefreshed", String().formatTime("%d-%m-%Y, %H:%M"));
		_Map.setMap("MultielementPositions", mapMultiPosition);
	}
	
	//Show multiElementNames
	Entity multiElementsToCheck[] = Group().collectEntities(true, ElementMulti(), _kModelSpace);
	if (pShowMultiElementNames == "Yes")
	{
		for (int i = 0; i < multiElementsToCheck.length(); i++)
		{
			ElementMulti multielement = (ElementMulti)multiElementsToCheck[i];
			String multiElementName = multielement.element().number();
			
			Point3d ptInformation = multielement.ptOrg() - (multielement.vecX() * U(2000)) + (multielement.vecY() * (U(200)));
			ptInformation.vis();
			dp.draw(multiElementName, ptInformation, _XW, _YW, - 1, 1);
			
		}
	}
	
	
	dp.color(1);
	dp.textHeight(U(250));
	dp.draw(_Map.getString("LastRefreshed"), _Pt0, _XW, _YW, 1, -1.25);
	
	if (pGroupsToCheck == T("|This|"))
	{
		dp.draw(singleelementFloorGroupName, _Pt0, _XW, _YW, 1, -3.75);
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
      <str nm="Comment" vl="Move drawing of the multiElementNames outside of the CreateMultiElements loop to make it more flexible." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/5/2025 1:39:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add property to show multiElement names." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/15/2025 5:03:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to only recalc 1 group" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/4/2022 1:38:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14360 Bugfix: Multi element stays now in same group." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/24/2022 1:37:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14360 Add option to handle updates and refresh multiwall" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/22/2022 10:52:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Option added to visualise multi elements in groups. " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/28/2021 12:07:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Normalize vectors which were stored in MapX as points and therefore in drawing units." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/9/2021 1:30:11 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End