#Version 8
#BeginDescription
Modified by: Anno Sportel (support.nl@hsbcad.com)
Date: 23.09.2020  -  version 1.03
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl assigns mep items to an element if they are intersecting with the elevation and plan profile of the element.
// Assign mep items to the module if they are inside the module bounds and not assigned to an element. 
// Modules are grouped by MapX content off the element, its grouping on @(text.modul).
/// </summary>

/// <insert>
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="23.09.2020"></version>

/// <history>
/// AS - 1.00 - 13.05.2020 - Pilot version. 
/// AS - 1.01 - 14.05.2020 - Use profiles to determine if the mep item belongs to the element.
/// AS - 1.02 - 28.06.2020 - Assign mep items to floorgroup if they are inside the module bounds and not assigned to an element.
///					 Rename from assignMepItemsToElement to assignMepItemsToGroup.
/// AS - 1.03 - 23.09.2020 - Process the mep items per module.
/// </history>


if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
}

String moduleNameFormat = "@(text.modul)";

Entity elementsAsEntity[] = Group().collectEntities(true, Element(), _kModelSpace);
if (elementsAsEntity.length() == 0) 
{
	eraseInstance();
	return;
}
Entity tslInstances[] = Group().collectEntities(true, TslInst(), _kModelSpace);

// List of unique module names
String moduleNames[0];

// A list of indexes refering to one of the modules names.
int moduleIndexes[0];
Element elements[0];
for (int i = 0; i < elementsAsEntity.length(); i++)
{
	Element el = (Element)elementsAsEntity[i];
	if ( ! el.bIsValid()) continue;
	
	String moduleName = el.formatObject(moduleNameFormat);
	
	int moduleIndex = moduleNames.find(moduleName);
	if (moduleIndex == -1)
	{
		moduleNames.append(moduleName);
		moduleIndex = moduleNames.length() - 1;
	}
	moduleIndexes.append(moduleIndex);
	elements.append(el);
}
	
for(int s1=1;s1<moduleIndexes.length();s1++)
{
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--)
	{
		if( moduleIndexes[s11] < moduleIndexes[s2] )
		{
			moduleIndexes.swap(s2, s11);
			elements.swap(s2, s11);
			s11=s2;
		}
	}
}

int tslInstancesCheckedForMepItems = false;
int mepItemAssignmentIndicators[0];

Element moduleElements[0];
int previousModuleIndex = 0;
for (int m = 0; m < moduleIndexes.length(); m++)
{
	int moduleIndex = moduleIndexes[m];
	
	Element el = elements[m];
	if (moduleIndex == previousModuleIndex)
	{
		moduleElements.append(el);
		if (m < (moduleIndexes.length() - 1)) continue;
	}
	
	String moduleName = moduleNames[previousModuleIndex];
	
	// Process this module
	Point3d elementExtremes[0];
	
	TslInst mepItems[0];
	int numberOfMepItemsAssignedToElements = 0;
	for (int e = 0; e < moduleElements.length(); e++)
	{
		Element el = moduleElements[e];
		if ( ! el.bIsValid()) continue;
		
		CoordSys cs = el.coordSys();
		Vector3d elX = cs.vecX();
		Vector3d elY = cs.vecY();
		Vector3d elZ = cs.vecZ();
		CoordSys csFront = el.zone(99).coordSys();
		CoordSys csBack = el.zone(-99).coordSys();
		double elementThickness = elZ.dotProduct(csFront.ptOrg() - csBack.ptOrg());
		if (elementThickness == 0) continue;
		
		LineSeg elementMinMax = el.segmentMinMax();
		elementExtremes.append(elementMinMax.ptStart());
		elementExtremes.append(elementMinMax.ptEnd());
		PlaneProfile elementElevationProfile = el.profBrutto(0);
		if (elementElevationProfile.area() == 0)
		{
			PLine elementElevationOutline(elZ);
			elementElevationOutline.createRectangle(elementMinMax, elX, elY);
			elementElevationProfile = PlaneProfile(elementElevationOutline);
		}
		PLine elementPlanOutline(elY);
		elementPlanOutline.createRectangle(elementMinMax, elX, - elZ);
		PlaneProfile elementPlanProfile(elementPlanOutline);
		
		// Build a list of mep items while going over the first element. This list will be used for all the other elements.
		if ( ! tslInstancesCheckedForMepItems)
		{
			for (int t = 0; t < tslInstances.length(); t++)
			{
				TslInst tsl = (TslInst)tslInstances[t];
				if ( ! tsl.bIsValid()) continue;
				
				int isMepItem = tsl.scriptName().makeLower() == "mepitem";
				if ( ! isMepItem) continue;
				
				mepItems.append(tsl);
//				// Reset group assignment
//				Group assignedToGroups[] = tsl.groups();
//				for (int g=0;g<assignedToGroups.length();g++)
//				{
//					Group mepGroup = assignedToGroups[g];
//					if (mepGroup.name().find("MEP", 0) != -1)
//					{
//						mepGroup.addEntity(tsl, true, 0, 'I');
//						break;
//					}
//				}
				
				int mepItemIsAssigned = false;
				if (elementElevationProfile.pointInProfile(tsl.ptOrg()) == _kPointInProfile && elementPlanProfile.pointInProfile(tsl.ptOrg()) == _kPointInProfile)
				{
					tsl.assignToElementGroup(el, false, 0, 'I');
					mepItemIsAssigned = true;
					numberOfMepItemsAssignedToElements++;
				}
				mepItemAssignmentIndicators.append(mepItemIsAssigned);
			}
		}
		else
		{
			for (int t = 0; t < mepItems.length(); t++)
			{
				if (mepItemAssignmentIndicators[t]) continue;
				TslInst mepItem = mepItems[t];
				
				if (elementElevationProfile.pointInProfile(mepItem.ptOrg()) == _kPointInProfile && elementPlanProfile.pointInProfile(mepItem.ptOrg()) == _kPointInProfile)
				{
					mepItem.assignToElementGroup(el, false, 0, 'I');
					mepItemAssignmentIndicators[t] = true;
					numberOfMepItemsAssignedToElements++;
				}
			}
		}
	}
	
	if (numberOfMepItemsAssignedToElements > 0)
	{
		reportMessage("\n" + scriptName() + " - " + numberOfMepItemsAssignedToElements + T(" |mep items are assigned to an element in module| ") + moduleName);
	}
	
	// Only process valid modules.
	if (moduleName.find("@", 0) != -1) continue;
	if (moduleName == "") continue;
	
	Vector3d moduleX = _XW;
	Vector3d moduleY = _YW;
	Vector3d moduleZ = _ZW;
	
	Point3d elementExtremesX[] = Line(_Pt0, moduleX).orderPoints(elementExtremes);
	Point3d elementExtremesY[] = Line(_Pt0, moduleY).orderPoints(elementExtremes);
	Point3d elementExtremesZ[] = Line(_Pt0, moduleZ).orderPoints(elementExtremes);
	if ((elementExtremesX.length() * elementExtremesY.length() * elementExtremesZ.length()) == 0) return;
	
	Point3d moduleMin = elementExtremesX.first() + moduleY * moduleY.dotProduct(elementExtremesY.first() - elementExtremesX.first())
	 + moduleZ * moduleZ.dotProduct(elementExtremesZ.first() - elementExtremesX.first());
	Point3d moduleMax = elementExtremesX.last() + moduleY * moduleY.dotProduct(elementExtremesY.last() - elementExtremesX.last())
	 + moduleZ * moduleZ.dotProduct(elementExtremesZ.last() - elementExtremesX.last());
	LineSeg moduleMinMax(moduleMin, moduleMax);
//	moduleMinMax.vis(moduleIndex);
	PLine modulePlanOutline(moduleZ);
	modulePlanOutline.createRectangle(moduleMinMax, moduleX, moduleY);
	PlaneProfile modulePlanProfile(modulePlanOutline);
//	modulePlanProfile.vis(moduleIndex);
	
	PLine moduleElevationOutline(moduleY);
	moduleElevationOutline.createRectangle(moduleMinMax, moduleX, moduleZ);
	PlaneProfile moduleElevationProfile(moduleElevationOutline);
//	moduleElevationProfile.vis(moduleIndex);
	
	int numberOfMepItemsAssignedToModules = 0;
	for (int t = 0; t < mepItems.length(); t++)
	{
		if (mepItemAssignmentIndicators[t]) continue;
		TslInst mepItem = mepItems[t];
		
		if (moduleElevationProfile.pointInProfile(mepItem.ptOrg()) == _kPointInProfile && modulePlanProfile.pointInProfile(mepItem.ptOrg()) == _kPointInProfile)
		{
			mepItem.assignToElementFloorGroup((Element)moduleElements.first(), false, 0, 'I');
			mepItemAssignmentIndicators[t] = true;
			numberOfMepItemsAssignedToModules++;
		}
	}
	
	if (numberOfMepItemsAssignedToModules > 0)
	{
		reportMessage("\n" + scriptName() + " - " + numberOfMepItemsAssignedToModules + T(" |mep items are assigned to module| ") + moduleName);
	}
	
	// Reset settings for next module to be processed.
	previousModuleIndex = moduleIndex;
	moduleElements.setLength(0);
	moduleElements.append(el);
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End