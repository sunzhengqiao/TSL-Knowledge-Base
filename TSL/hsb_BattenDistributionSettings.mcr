#Version 8
#BeginDescription
Settings for batten distribution construction plugin

Modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com)

Date: 20.10.2015: version 1.0
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2015 by
*  hsbcad
*  
*
*  The program may be used and/or copied only with the written
*  permission from hsbcad, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Chirag Sawjani (chirag.sawjani@hsbcad.com)
* Date: 20.10.2015
* version 1.0: Initial settings for batten distribution construction plugin
*
*/

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};

PropInt nZoneCount (0, nValidZones, T("|Zone to apply battens to|"), 0);
PropInt nColour (1, 1, T("|Colour|"));

PropString sMaterial (0, "CLS", T("|Material|"));
PropDouble dZoneThickness (9, 10, T("|Zone thickness|"));

PropDouble dBattenWidth (0, 38, T("|Batten width|"));
PropDouble dTopBattenWidth (1, 38, T("|Top batten width|"));
PropDouble dBottomBattenWidth (2, 38, T("|Bottom batten width|"));
PropDouble dLeftOffset (3, 0, T("|Left offset|"));
PropDouble dRightOffset (4, 0, T("|Right offset|"));
PropDouble dTopOffset (5, 0, T("|Top offset|"));
PropDouble dBottomOffset (6, 0, T("|Bottom offset|"));

PropDouble dTopGap (7, 0, T("|Top gap|"));
dTopGap.setDescription(T("|Gap between top batten and vertical battens|"));
PropDouble dBottomGap (8, 0, T("|Bottom gap|"));
dBottomGap .setDescription(T("|Gap between bottom batten and vertical battens|"));


String sGeneralCategory = T("|General|");
String sDimensionsCategory = T("|Dimensions|");
String sOptions = T("|Options|");

//General
nZoneCount.setCategory(sGeneralCategory);
nColour.setCategory(sGeneralCategory);
sMaterial.setCategory(sGeneralCategory);
dZoneThickness.setCategory(sGeneralCategory);

//Dimensions
dBattenWidth.setCategory(sDimensionsCategory);
dTopBattenWidth.setCategory(sDimensionsCategory);
dBottomBattenWidth.setCategory(sDimensionsCategory);
dLeftOffset.setCategory(sDimensionsCategory);
dRightOffset.setCategory(sDimensionsCategory);
dTopOffset.setCategory(sDimensionsCategory);
dBottomOffset.setCategory(sDimensionsCategory);

//Options
dTopGap.setCategory(sOptions);
dBottomGap.setCategory(sOptions);

int nRealZone = nRealZones[nValidZones.find(nZoneCount)];

if (_bOnInsert) {
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Please select Elements"),ElementWallSF());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWall el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

for(int e=0;e < _Element.length(); e++)
{
	
	Element el = _Element[e];
	if (!el.bIsValid()) continue;

	ElemZone ez = el.zone(nRealZone);
	
	String distributionCode="HSB-PL100";
	ez.setCode(distributionCode);
	ez.setColor(nColour);
	ez.setMaterial("Material");
	ez.setDH(dZoneThickness);
	
	el.setZone(nRealZone, ez);
		
	Map zoneMap;
	zoneMap.setInt("ZoneIndex", nRealZone);
	zoneMap.setString("DistributionCode", distributionCode);
	zoneMap.setDouble("BattenWidth", dBattenWidth, _kLength);
	zoneMap.setDouble("TopBattenWidth", dTopBattenWidth, _kLength);
	zoneMap.setDouble("BottomBattenWidth", dBottomBattenWidth, _kLength);
	zoneMap.setInt("TopPlate", dTopBattenWidth > 0 );
	zoneMap.setInt("BottomPlate", dBottomBattenWidth > 0 );
	zoneMap.setDouble("LeftOffset", dLeftOffset, _kLength);
	zoneMap.setDouble("RightOffset", dRightOffset, _kLength);
	zoneMap.setDouble("TopOffset", dTopOffset, _kLength);
	zoneMap.setDouble("BottomOffset", dBottomOffset, _kLength);
	zoneMap.setDouble("TopGap", dTopGap, _kLength);
	zoneMap.setDouble("BottomGap", dBottomGap, _kLength);
	zoneMap.setInt("Color", nColour);
	
	String sElemZoneArrayKey = "ElemZone[]";
	String sElemZoneKey = "ElemZone";
	Map elementSubMap = el.subMapX(sElemZoneArrayKey);

	Map elemZones;

	if(elementSubMap.hasMap(sElemZoneKey))
	{
		Map newElemMap;
		int bMapExists = false;
		for(int i=0  ; i<elementSubMap.length() ; i++)
		{
			if(elementSubMap.keyAt(i) != sElemZoneKey.makeUpper())
			{
				continue;
			}
			
			Map mp = elementSubMap.getMap(i);
			if(mp.getInt("ZoneIndex")==nRealZone)
			{
				bMapExists = true;
			}
		}
			
		
		if(!bMapExists)
		{
			newElemMap = elementSubMap;
			newElemMap.appendMap(sElemZoneKey, zoneMap); //new
		}
		else
		{
			for(int i=0  ; i<elementSubMap.length() ; i++)
			{
				if(elementSubMap.keyAt(i) != sElemZoneKey.makeUpper())
				{
					continue;
				}
				
				Map mp = elementSubMap.getMap(i);
				if(mp.getInt("ZoneIndex")==nRealZone)
				{
					newElemMap.appendMap(sElemZoneKey, zoneMap); // overwrite
				}
				else
				{
					newElemMap.appendMap(sElemZoneKey, mp); //existing
				}
			}
		}
		
		el.setSubMapX(sElemZoneArrayKey, newElemMap);
	}
	else	
	{
		elemZones.appendMap(sElemZoneKey, zoneMap);
		el.setSubMapX(sElemZoneArrayKey, elemZones);
	}
}

eraseInstance();
#End
#BeginThumbnail

#End