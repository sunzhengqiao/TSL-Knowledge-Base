#Version 8
#BeginDescription
 This tsl visualizes the outline of zone 0 and calculates the volume of the timbers as a percentage of the total volume
Percentage is added through MapX on the element 
@(ExtendedProperties.TimberPercentage.TimberPercentage)
@(ExtendedProperties.TimberPercentage.TimberPercentageArea)
@(ExtendedProperties.TimberPercentage.TimberPercentageAreaBrutto)
@(ExtendedProperties.TimberPercentage.TimberPercentageAreaWood)
@(ExtendedProperties.TimberPercentage.Name)


#Versions
4.0 15/07/2025 Redo tsl using timberpercentagearea tsls Author: Robert Pol
3.4 16/06/2025 Make sure extended properties are maintained Author: Robert Pol
3.3 27/05/2025 Add option to select multiple plines to add Author: Robert Pol
3.2 19/02/2025 Set new convention for mapx name and add plines to zone -5 Author: Robert Pol
3.1 19/02/2025 Add edit polyline data trigger Author: Robert Pol
3.0 18/02/2025 Add depth Author: Robert Pol
2.14 05/02/2025 Support mirrored elements Author: Robert Pol
2.13 03/12/2024 Add hatch Author: Robert Pol
2.12 08/11/2024 Make sure layer is set outside if statement Author: Robert Pol
2.11 13/09/2024 Make sure tsl always deletes itself Author: Robert Pol
Version 2.10 19-6-2024 Change the display of the ShowProfile property. Now also the beam profiles are shown in red, the outer profile is still drawn but now in yellow. Ronald van Wijngaarden
2.9 03/06/2024 Reset previous change because formatting will take first percentage, all old maps remained on the mapx of the element Author: Robert Pol
Version 2.8 8-2-2024 Get existing mapX with ExtendedData from element, when adding the new information to the ExtendedData. Ronald van Wijngaarden
Version 2.7 18-9-2023 Remove Identifier, use existing property profileName as property to check. Ronald van Wijngaarden
Version 2.6 14-9-2023 Make possible to add the tsl to elementgeneration Ronald van Wijngaarden
Version 2.5 14-9-2023 Add identifier to the tsl to give the user the ability to place multiple instances of the tsl on an element. And remove duplicates when the identifier is the same. Ronald van Wijngaarden
2.4 19/07/2023 Retrieve with cs the zoneprofilemap Author: Robert Pol
2.3 25/04/2023 Add coordsys to mapx to support transformations Author: Robert Pol
2.2 13/02/2023 Fix bug in index to subtract pline Author: Robert Pol
2.1 1/24/2023 Add text data to the TSL  EtH
Version 2.1 24.01.2023 Add text data to the TSL 
Version 2.0 10.01.2023 HSB-17068 shadow reverted to slice

1.9 22/12/2022 Add color and lineweight and woodpercentage an brutoarea
1.8 18.11.2022 HSB-17068 polylines are now purged when element construction is deleted
1.7 15/09/2022 Intersect beamprofile with elementoutline, otherwise percentage is wrong
1.6 15/06/2022 Add diminfo map and set to "E" layer
1.5 09/06/2022 Fix bug on wrong PLinemap
1.4 13/04/2022 Option to add multiple planeProfiles


































#End
#Type O
#NumBeamsReq 2
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 0
#KeyWords 
#BeginContents

/// <summary Lang=en>
/// This tsl visualizes the outline of zone 0 and calculates the volume of the timbers as a percentage of the total volume
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>
// #Versions
//4.0 15/07/2025 Redo tsl using timberpercentagearea tsls Author: Robert Pol
//3.4 16/06/2025 Make sure extended properties are maintained Author: Robert Pol
//3.3 27/05/2025 Add option to select multiple plines to add Author: Robert Pol
//3.2 19/02/2025 Set new convention for mapx name and add plines to zone -5 Author: Robert Pol
//3.1 19/02/2025 Add edit polyline data trigger Author: Robert Pol
//3.0 18/02/2025 Add depth Author: Robert Pol
//2.14 05/02/2025 Support mirrored elements Author: Robert Pol
//2.13 03/12/2024 Add hatch Author: Robert Pol
//2.12 08/11/2024 Make sure layer is set outside if statement Author: Robert Pol
//2.11 13/09/2024 Make sure tsl always deletes itself Author: Robert Pol
//2.10 19-6-2024 Change the display of the ShowProfile property. Now also the beam profiles are shown in red, the outer profile is still drawn but now in yellow. Ronald van Wijngaarden
//2.9 03/06/2024 Reset previous change because formatting will take first percentage, all old maps remained on the mapx of the element Author: Robert Pol
//2.8 8-2-2024 Get existing mapX with ExtendedData from element, when adding the new information to the ExtendedData. Ronald van Wijngaarden
// 2.7 18-9-2023 Remove Identifier, use existing property profileName as property to check. Ronald van Wijngaarden
// 2.6 14-9-2023 Make possible to add the tsl to elementgeneration Ronald van Wijngaarden
//2.5 14-9-2023 Add identifier to the tsl to give the user the ability to place multiple instances of the tsl on an element. And remove duplicates when the identifier is the same. Ronald van Wijngaarden
//2.4 19/07/2023 Retrieve with cs the zoneprofilemap Author: Robert Pol
//2.3 25/04/2023 Add coordsys to mapx to support transformations Author: Robert Pol
//2.2 13/02/2023 Fix bug in index to subtract pline Author: Robert Pol
// 2.1 1/24/2023 Add text data to the TSL  EtH
// 2.0 10.01.2023 HSB-17068 shadow reverted to slice , Author Thorsten Huck
// 1.9 22/12/2022 Add color and lineweight and woodpercentage an brutoarea Author: Robert Pol
// 1.8 18.11.2022 HSB-17068 polylines are now purged when element construction is deleted , Author Thorsten Huck
//1.7 15/09/2022 Intersect beamprofile with elementoutline, otherwise percentage is wrong Author: Robert Pol
//1.6 15/06/2022 Add diminfo map and set to "E" layer Author: Robert Pol
//1.5 09/06/2022 Fix bug on wrong PLinemap Author: Robert Pol

U(1,"mm");	
double pointTolerance =U(.1);
double vectorTolerance = U(.01);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String executeKey = "ManualInsert";
String sDisabled = T("<|Disabled|>");

// some default painter definitions are expected. If not existant they will be created automatically
String sPainters[] = PainterDefinition().getAllEntryNames();
sPainters = sPainters.sorted();
sPainters.insertAt(0, sDisabled);
//End Painters//endregion 

category = T("|Filter|");

String sProfileName=T("|Profile name(s)|");	
PropString sProfile(nStringIndex++,T("|PLINE|"), sProfileName);	
sProfile.setDescription(T("|Specify the name of the profile to be used, if empty the zone0 profile will be used, use a ; as delimeter for multiple profiles|"));
sProfile.setCategory(category);	

String timberPercentageAreaTslName = "HSB_E-TimberPercentageArea";
String timberPercentageAreaTslCatalogs[] = TslInst().getListOfCatalogNames(timberPercentageAreaTslName);

PropString timberPercentageAreaTslCatalog(nStringIndex++, timberPercentageAreaTslCatalogs, T("|Area catalog|"));
timberPercentageAreaTslCatalog.setDescription(T("|The Area catalog.|") + TN("|Use| ") + timberPercentageAreaTslName + T(" |to define the catalogs|."));
timberPercentageAreaTslCatalog.setCategory(category);

category = T("|Dimensions|");

String sProfileDepth=T("|Profile depth(s)|");	
PropString sDepth(nStringIndex++,T("|-1|"), sProfileDepth);	
sDepth.setDescription(T("|Specify the depths of the profiles, if empty or smaller then 0, the center of teh element will be used, use a ; as delimeter for multiple profile depths|"));
sDepth.setCategory(category);	

category = T("|Name|");

String sOverrideZone0Name =T("|Override Name Zone 0|");	
PropString sOverrideZone0(nStringIndex++, "", sOverrideZone0Name);
sOverrideZone0.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

//region mapIO: support property dialog input via map on element creation
int bHasPropertyMap = _Map.hasMap("PROPSTRING[]");
if (_bOnMapIO)
{ 
	if (bHasPropertyMap)
		setPropValuesFromMap(_Map);	
	showDialog();
	_Map = mapWithPropValues();
	return;
}
if (_bOnElementDeleted)
{
	// HSB-17068
	for (int i=_Entity.length()-1; i>=0 ; i--) 
		if (_Entity[i].bIsKindOf(TslInst()))
			_Entity[i].dbErase();

	eraseInstance();
	return;
}
else if (_bOnElementConstructed && bHasPropertyMap)
{ 
	setPropValuesFromMap(_Map);
	_Map = Map();
}	
	
//End mapIO: support property dialog input via map on element creation//endregion 

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		TslInst arTsl[] = _Element[e].tslInst();
		for ( int j = 0; j < arTsl.length(); j++)
		{
			TslInst tsl = arTsl[j];
			if ( ! tsl.bIsValid() || tsl.scriptName() == scriptName())
			{
				tsl.recalcNow(T("|Delete|"));
			}
		}
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
				
	eraseInstance();		
	return;
}	
// end on insert	__________________

for (int m=0;m<_Map.length();m++)
{
	if (_Map.keyAt(m) != "DimInfo") continue;
	_Map.removeAt(m, true);
	m--;
}
// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

Element element = _Element[0];
CoordSys cs = element.coordSys();
Wall wall = (Wall)element;
if (wall.bIsValid())
{
	cs = wall.coordSysHsb();
}
ElementRoof elementRoof = (ElementRoof)element;
if (elementRoof.bIsValid())
{
	cs = elementRoof.coordSysHsb();
}

Vector3d vecX = element.vecX();
Vector3d vecY = element.vecY();
Vector3d vecZ = element.vecZ();
Point3d ptOrg = element.ptOrg();
assignToElementGroup(element,false, 0,'E');
TslInst arTsl[] = element.tslInst();

Map profilesMap;

addRecalcTrigger(_kContext, T("|Reset Profiles|") );
if (_kExecuteKey == executeKey || _bOnElementConstructed || _kExecuteKey == T("|Reset Profiles|"))
{
	for ( int t = 0; t < arTsl.length(); t++) 
	{
		TslInst tsl = arTsl[t];
		if ( ! tsl.bIsValid()) continue;
		if ((tsl.scriptName() == _ThisInst.scriptName() && tsl.handle() != _ThisInst.handle()) || tsl.scriptName() == timberPercentageAreaTslName)
		{
			tsl.recalcNow(T("|Delete|"));
		}
	}
	
	_Pt0 = element.zone(-1).coordSys().ptOrg();
	String zoneProfilesToAdd[] = sProfile.tokenize(";");
	String depthsToAdd[] = sDepth.tokenize(";");

	Map zoneProfiles = element.subMapX("ZoneArea[]", cs);
	for (int p = 0; p < zoneProfiles.length(); p++)
	{
		Map zoneProfile = zoneProfiles.getMap(p);
		for (int m = 0; m < zoneProfile.length(); m++)
		{
			Map plineMap = zoneProfile.getMap(m);
			int indexPline = zoneProfilesToAdd.find(plineMap.getString("NAME"));
			if (indexPline == -1) continue;
			Map profileMap;
			
			if (depthsToAdd.length() > indexPline)
			{
				profileMap.setDouble("Depth", depthsToAdd[indexPline].atof());
			}
			
			PLine allRings[0];
			int areOpening[0];

			for (int z=0;z<plineMap.length();z++)
			{
				if (plineMap.hasPLine(z))
				{
					allRings.append(plineMap.getPLine(z));
					areOpening.append(false);
				}
				else if (plineMap.hasMap(z))
				{
					Map openingMap = plineMap.getMap(z);
					for (int o = 0; o < openingMap.length(); o++)
					{
						if (openingMap.hasPLine(o))
						{
							allRings.append(openingMap.getPLine(o));
							areOpening.append(true);
						}
					}
				}
			}
			
			profileMap.setString("Name", plineMap.getString("NAME"));
			
			for (int index = 0; index < allRings.length(); index++)
			{
				Map mapRing;
				PLine ring = allRings[index];
				mapRing.setPLine("Ring", ring);
				int isOpening = areOpening[index];
				mapRing.setInt("IsOpening", isOpening);
				profileMap.appendMap("Ring", mapRing);
			}
			
			profilesMap.appendMap("PlaneProfile", profileMap);
		}
		
	}
	
	if (profilesMap.length() < 1)
	{
		PlaneProfile elementZone0 = element.profNetto(0);
		if (elementZone0.area() < pointTolerance)
		{
			elementZone0 = PlaneProfile(element.plEnvelope());
		}
		Map profileMap;
		profileMap.setString("Name", sOverrideZone0.length() > 0 ? sOverrideZone0 : "Zone0");
		if (depthsToAdd.length() > 0)
		{
			profileMap.setDouble("Depth", depthsToAdd[0].atof());
		}
		PlaneProfile contour = elementZone0;
		PLine allRings[] = contour.allRings();
		int areOpening[] = contour.ringIsOpening();
		for (int index = 0; index < allRings.length(); index++)
		{
			Map mapRing;
			PLine ring = allRings[index];
			mapRing.setPLine("Ring", ring);
			int isOpening = areOpening[index];
			mapRing.setInt("IsOpening", isOpening);
			profileMap.appendMap("Ring", mapRing);
		}
		profilesMap.appendMap("PlaneProfile", profileMap);
	}
	
	for (int e=0;e<profilesMap.length();e++) 
	{
		Map profileMap = profilesMap.getMap(e);
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(element);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		mapTsl.setMap("PlaneProfile", profileMap);
		
		ptsTsl.append(element.coordSys().ptOrg());
		
		tslNew.dbCreate(timberPercentageAreaTslName,vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, timberPercentageAreaTslCatalog, true, mapTsl, executeKey, "");
	}
}

addRecalcTrigger(_kContext, T("|Delete|") );
if (_kExecuteKey == T("|Delete|"))
{
	for ( int t = 0; t < arTsl.length(); t++) 
	{
		TslInst tsl = arTsl[t];
		
		if (tsl.scriptName() == timberPercentageAreaTslName)
		{
			tsl.recalcNow(T("|Delete|"));
		}
	}
	eraseInstance();
	return;
}

double dSymbolSize = U(25);

// visualisation
Display dpVisualisation(1);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(element, 0, 'I');

Point3d ptSymbol01 = _Pt0 - vecY * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vecX + vecY) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vecX - vecY) * dSymbolSize;

PLine plSymbol01(vecZ);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vecZ);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = vecX + vecY;
vxTxt.normalize();
Vector3d vyTxt = vecZ.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);

{
	Display dpVisualisationPlan(1);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);
	dpVisualisationPlan.elemZone(element, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vecZ * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vecX - vecZ) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vecX + vecZ) * dSymbolSize;
	
	PLine plSymbol01(vecY);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vecY);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = vecX - vecZ;
	vxTxt.normalize();
	Vector3d vyTxt = vecY.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="388" />
        <int nm="BreakPoint" vl="384" />
        <int nm="BreakPoint" vl="391" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Redo tsl using timberpercentagearea tsls" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/15/2025 11:36:37 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Make sure extended properties are maintained" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="6/16/2025 3:46:00 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to select multiple plines to add" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="5/27/2025 3:36:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Set new convention for mapx name and add plines to zone -5" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="2/19/2025 4:28:36 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add edit polyline data trigger" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="2/19/2025 9:14:16 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add depth" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="2/18/2025 7:28:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Support mirrored elements" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="2/5/2025 3:13:02 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add hatch" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="12/3/2024 11:37:50 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Make sure layer is set outside if statement" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="11/8/2024 1:36:29 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Make sure tsl always deletes itself" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="9/13/2024 1:30:58 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Change the display of the ShowProfile property. Now also the beam profiles are shown in red, the outer profile is still drawn but now in yellow." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="6/19/2024 1:37:47 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Reset previous change because formatting will take first percentage, all old maps remained on the mapx of the element" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="6/3/2024 10:33:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Get existing mapX with ExtendedData from element, when adding the new information to the ExtendedData." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/8/2024 9:42:05 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Remove Identifier, use existing property profileName as property to check." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/18/2023 11:38:28 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Make possible to add the tsl to elementgeneration" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="9/14/2023 6:02:06 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add identifier to the tsl to give the user the ability to place multiple instances of the tsl on an element. And remove duplicates when the identifier is the same." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="9/14/2023 2:05:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Retrieve with cs the zoneprofilemap" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="7/19/2023 11:59:19 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add coordsys to mapx to support transformations" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="4/25/2023 11:28:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fix bug in index to subtract pline" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="2/13/2023 1:08:51 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add text data to the TSL " />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="1/24/2023 10:32:54 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17068 shadow reverted to slice" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="1/10/2023 2:52:01 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add color and lineweight and woodpercentage an brutoarea" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="12/22/2022 1:48:11 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17068 polylines are now purged when element construction is deleted" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/18/2022 8:43:48 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Intersect beamprofile with elementoutline, otherwise percentage is wrong" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/15/2022 3:08:32 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add diminfo map and set to &quot;E&quot; layer" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="6/15/2022 9:53:19 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fix bug on wrong PLinemap" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/9/2022 10:02:39 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Option to add multiple planeProfiles" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="4/13/2022 2:52:46 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add custom name for timberpercentage profile" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="2/14/2022 10:51:54 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add volume to extended props of beam and element/ add char" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/9/2021 11:09:53 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End