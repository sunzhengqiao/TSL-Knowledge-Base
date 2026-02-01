#Version 8
#BeginDescription
This tsl optimizes genbeams.


2.4 20/07/2023 Fix genbeamX not aligned to element Author: Robert Pol

2.3 01/06/2023 Add option to use start and or end as split position Author: Robert Pol

2.2 12/08/2022 Add distribute evenly prop Author: Robert Pol


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords 1
#BeginContents
/// <summary Lang=en>
/// This tsl optimizes genbeams
/// </summary>

/// <insert>
/// Select a set of elements or genbeams.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="14.04.2017"></version>

/// <history>
/// YB - 1.00 - 13.04.2017 -	Pilot version
/// YB - 1.01 - 14.04.2017 - 	Started with setting up the filter
/// YB - 1.02 - 14.04.2017 -	Improved the filter, fixed sheet optimizing
/// RP - 2.00 - 11.11.2020 -	Tsl can be used on element generation, take side from element distribution
// #Versions
//2.4 20/07/2023 Fix genbeamX not aligned to element Author: Robert Pol
//2.3 01/06/2023 Add option to use start and or end as split position Author: Robert Pol
//2.2 12/08/2022 Add distribute evenly prop Author: Robert Pol
//2.1 22/07/2021 add calmapio to give back the newly created entities Author: Robert Pol
/// </history>

U(1,"mm");	
double dEps =U(.1);
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
String toolPathsKey = "ToolPath[]";
String toolPathKey = "ToolPath";
String left = T("|Left|");
String right = T("|Right|");
String center = T("|Center|");
String centerNoBeamInCenter = T("|Center, no beam in center|");
String distributions[] = 
{
	left,
	right,
	center,
	centerNoBeamInCenter
};

int distributionDirections[] = 
{
	1, // Start
	-1, // End
	0, // Center
	0 // Center
};

category = T("|Distribution|");

// Properties
PropString pDistribution(0, distributions, T("|Distribution|"));
pDistribution.setCategory(category);
PropDouble pSplitLength(0, U(5400), T("|Split length|"));
pSplitLength.setCategory(category);
PropDouble pSplitGap(1, U(0), T("|Gap|"));
pSplitGap.setCategory(category);
PropDouble pStartOffset(2, U(0), T("|Start offset|"));
pStartOffset.setCategory(category);
PropDouble pEndOffset(3, U(0), T("|End offset|"));
pEndOffset.setCategory(category);
PropString pDistributeEvenly(2, sNoYes, T("|Distribute evenly|"));
pDistributeEvenly.setCategory(category);
PropString pUseStartAsPosition(3, sNoYes, T("|Split at start|"));
pUseStartAsPosition.setCategory(category);
PropString pUseEndAsPosition(4, sNoYes, T("|Split at end|"));
pUseEndAsPosition.setCategory(category);

category = T("|Filter|");

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString filterDefinition(1, filterDefinitions, T("|Filter definition beams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if((_bOnDbCreated || _bOnMapIO) && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

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
	PrEntity ssE(T("|Select element(s)|") + " <ENTER> " + T("|to select genbeams|"), Element());
  	if (ssE.go())
  	{
		Element arSelectedElements[] = ssE.elementSet();
		if (arSelectedElements.length() == 0) 
		{

			PrEntity ssEBm(T("|Select genbeam(s)|"), GenBeam());
			if (ssEBm.go()) 
			{
				_Entity.append(ssEBm.set());
			}
			
			return;
		}

		_Element.append(arSelectedElements);
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
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
				
	eraseInstance();		
	return;
}	
// end on insert	__________________

if (_bOnMapIO)
{
	_Entity.append(_Map.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}

if (_Entity.length() < 1 && _Element.length() < 1)
{
	reportMessage(TN("|No genbeams or element found|"));
	eraseInstance();
	return;	
}
int distributeEvenly = pDistributeEvenly == T("|Yes|");
// Create an array to store the beams
if(_Element.length() > 0)
{
	GenBeam elementGenBeams[] = _Element[0].genBeam();
	for (int index=0;index<elementGenBeams.length();index++) 
	{ 
		GenBeam genBeam = elementGenBeams[index]; 
		if (_Entity.find(genBeam) != -1) continue;
		_Entity.append(genBeam);
	}
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(_Entity, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 

Entity filteredEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

int distributionDirection = distributionDirections[distributions.find(pDistribution)];
int useStartAsPosition = sNoYes.find(pUseStartAsPosition);
int useEndAsPosition = sNoYes.find(pUseEndAsPosition);
GenBeam resultingGenBeams[0];
for (int index=0;index<filteredEntities.length();index++) 
{ 
	GenBeam genBeam = (GenBeam)filteredEntities[index]; 
	if (! genBeam.bIsValid()) continue;
	
	Sheet sheet = (Sheet)genBeam;
	Beam beam = (Beam)genBeam;
	Sip sip = (Sip)genBeam;
	
	Vector3d genBeamX = genBeam.vecX();
	if (genBeam.solidLength() < genBeam.solidWidth())
	{
		genBeamX = genBeam.vecY();
	}
	
	Element genBeamElement = genBeam.element();
	ElementRoof elementRoof = (ElementRoof)genBeamElement;
	if (elementRoof.bIsValid())
	{
		//Check with x and y of element
		if (genBeamX.dotProduct(genBeamElement.vecX()) * genBeamX.dotProduct(genBeamElement.vecY()) < 0)
		{
			genBeamX *= -1;
		}	
		
		if (elementRoof.beamDistribution().makeUpper() == "R")
		{
			distributionDirection *= -1;
			pDistribution.set(distributions[distributionDirections.find(distributionDirection)]);
		}
	}
	else if (genBeamElement.bIsValid())
	{
		//Check with x and y of element
		if ( genBeamX.dotProduct(genBeamElement.vecX()) * genBeamX.dotProduct(genBeamElement.vecY()) < 0)
		{
			genBeamX *= -1;
			distributionDirection *= -1;
			pDistribution.set(distributions[distributionDirections.find(distributionDirection)]);
		}		
	}

	Vector3d genBeamZ = genBeam.vecZ();
	Vector3d genBeamY = genBeamX.crossProduct(genBeamZ);
	
	Body sheetBody = genBeam.realBody();
	double genBeamLength = sheetBody.lengthInDirection(genBeamX);
	Point3d genBeamCenter = genBeam.ptCen();
	Point3d distributionStart = genBeamCenter - genBeamX * 0.5 * genBeamLength;
	distributionStart.vis(1);
	Point3d distributionEnd = genBeamCenter + genBeamX * 0.5 * genBeamLength;
	distributionEnd.vis(2);
	
	Map distributionMap;
	distributionMap.setPoint3d("StartPosition", distributionStart);
	distributionMap.setPoint3d("EndPosition", distributionEnd);
	distributionMap.setDouble("StartOffset", pStartOffset);
	distributionMap.setDouble("EndOffset", pEndOffset);
	distributionMap.setDouble("SpacingProp", (pSplitGap + pSplitLength));
	distributionMap.setInt("DistributionType", distributions.find(pDistribution));
	distributionMap.setInt("DistributeEvenlyProp", distributeEvenly);
	distributionMap.setInt("UseStartAsPositionProp", useStartAsPosition);
	distributionMap.setInt("UseEndAsPositionProp", useEndAsPosition);
	distributionMap.setDouble("AllowedDistanceBetweenPositions", (pSplitLength - dEps));
	
	int successfullyDistributed = TslInst().callMapIO("HSB_G-Distribution", "Distribute", distributionMap);
	if ( ! successfullyDistributed) {
		reportWarning(T("|Beams could not be distributed!|") + TN("|Make sure that the tsl| ") + "HSB_G-Distribution" + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Point3d distributionPositions[] = distributionMap.getPoint3dArray("DistributionPositions");
	GenBeam genBeamsToSplit[0];
	genBeamsToSplit.append(genBeam);
	for (int index2 = 0; index2 < distributionPositions.length(); index2++)
	{
		Point3d splitPoint = distributionPositions[index2];
		splitPoint.vis(index2);
		
		for (int index3 = 0; index3 < genBeamsToSplit.length(); index3++)
		{
			GenBeam genBeamToSplit = genBeamsToSplit[index3];
			Point3d startPointGenBeamToSplit = genBeamToSplit.ptCen() - genBeamX * genBeamToSplit.realBody().lengthInDirection(genBeamX) * 0.5;
			startPointGenBeamToSplit + genBeamX * dEps;
			Point3d endPointGenBeamToSplit = genBeamToSplit.ptCen() + genBeamX * genBeamToSplit.realBody().lengthInDirection(genBeamX) * 0.5;
			endPointGenBeamToSplit - genBeamX * dEps;
			if (genBeamX.dotProduct(splitPoint - startPointGenBeamToSplit) * genBeamX.dotProduct(splitPoint - endPointGenBeamToSplit) > 0) continue;
			if (sheet.bIsValid())
			{
				Sheet sheetToSplit = (Sheet)genBeamToSplit;
				Sheet newSheetsToSplit[] = sheetToSplit.dbSplit(Plane(splitPoint, genBeamX), pSplitGap);
				for (int index4 = 0; index4 < newSheetsToSplit.length(); index4++)
				{
					Sheet newSheetToSplit = newSheetsToSplit[index4];
					
					if (genBeamsToSplit.find(newSheetToSplit) != -1) continue;
					
					genBeamsToSplit.append(newSheetToSplit);
				}
			}
			else if (sip.bIsValid())
			{
				Sip sipToSplit = (Sip)genBeamToSplit;
				Sip newSipsToSplit[] = sipToSplit.dbSplit(Plane(splitPoint, genBeamX), pSplitGap);
				for (int index4 = 0; index4 < newSipsToSplit.length(); index4++)
				{
					Sip newSipToSplit = newSipsToSplit[index4];
					
					if (genBeamsToSplit.find(newSipToSplit) != -1) continue;
					
					genBeamsToSplit.append(newSipToSplit);
				}				
			}
			else if (beam.bIsValid())
			{
				Beam beamToSplit = (Beam)genBeamToSplit;
				Beam newBeamToSplit = beamToSplit.dbSplit(splitPoint, splitPoint + genBeamX * pSplitGap);
				
				if (genBeamsToSplit.find(newBeamToSplit) != -1 || ! newBeamToSplit.bIsValid()) continue;
				
				genBeamsToSplit.append(newBeamToSplit);
				break;
			}
		}	
	}
	
	for (int g=0;g<genBeamsToSplit.length();g++) 
	{ 
		GenBeam genBeamToSplit = genBeamsToSplit[g]; 
		if (!genBeamToSplit.bIsValid() || resultingGenBeams.find(genBeamToSplit) != -1) continue;
		resultingGenBeams.append(genBeamToSplit);
	}
	
}

_Map.setEntityArray(resultingGenBeams, true, "GenBeams", "GenBeams", "GenBeam");

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
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
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Fix genbeamX not aligned to element" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/20/2023 11:09:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to use start and or end as split position" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/1/2023 2:15:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add distribute evenly prop" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/12/2022 2:38:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="add calmapio to give back the newly created entities" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/22/2021 1:33:01 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End