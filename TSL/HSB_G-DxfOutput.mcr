#Version 8
#BeginDescription

2.5 17/03/2022 Add option to not use dwgpath Author: Robert Pol
2.6 20/02/2025 Add option to export full body Author: Robert Pol

Version2.4 28-5-2021 Make the amount of points a property. Customer wishes to have more points, to have several tools also considered. Making it a property give the user the flexibility, and does nog create chaos at other users. , Author Ronald van Wijngaarden

Version2.3 7-5-2021 Change maximum arPtPl.length() amount of points to 10. Electricitypoint holes where not drawn. , Author Ronald van Wijngaarden




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a dxf output for beams and sheets. Each beam, or sheet, is outputted as a polyline to a dxf file. 
/// The name of the dxf file is: elementNumber_beam/sheetNumber
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
///
/// </remark>

/// <version  value="1.04" date="28.05.2021"></version>

/// <history>
/// AS - 1.00 - 26.05.2014 - Pilot version
/// FA - 2.00 - 17.07.2018 - Added selection of another view what to draw, also added filtering with "HSB_G-FilterGenBeams.mcr".
///					     - Also added different views for the dxf, and you can also give the .dxf file a name with "HSB_G-ContentFormat"
/// RP - 2.01 - 18.07.2018 - Declare display in for loop and add check for duplicate exportnames
/// RP - 2.02 - 02.04.2019 - Seperate curved style beams, because needs arcs as outpout
///Rvw -2.03 - 07.05.2021 - Change maximum arPtPl.length() amount of points to 10. Electricitypoint holes where not drawn.
///Rvw -2.04 - 28.05.2021 - Make the amount of points a property. Customer wishes to have more points, to have several tools also considered. Making it a property give the user the flexibility, and does not create a different usage of the tsl for other users.

//#Versions
//2.6 20/02/2025 Add option to export full body Author: Robert Pol

/// </history>

Display dpDebug(2);
String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};
String arProfiles[] = {T("|Section View|"), T("|Front View|")};

int arBExclude[] = {_kNo, _kYes};
String arSFilterType[] = {T("|Include|"), T("|Exclude|")};
String vectors[] = 
{
	T("|Entity X|"), 		//0
	T("|Entity Y|"), 		//1
	T("|Entity Z|"), 		//2
	T("|Element X|"),	 	//3
	T("|Element Y|"),		//4
	T("|Element Z|"), 		//5
	T("|World X|"), 		//6
	T("|World Y|"), 		//7
	T("|World Z|") 		//8
};

String contentFormatTslName = "HSB_G-ContentFormat";
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = {""};
filterDefinitions.append(TslInst().getListOfCatalogNames(filterDefinitionTslName));

String categories[] = { T("|Selection|"), T("|Output|")};

PropString filterDefinition(10, filterDefinitions, T("|Filter definition beams|"), 0);
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[0]);
PropString sFilterType(1, arSFilterType, T("|Filter type|"));
sFilterType.setDescription(T("|Include: Only beams with the entered beamcode will be used.|") + TN("|Exclude: Beams with the entered beamcode won't be used.|"));
sFilterType.setCategory(categories[0]);
PropString sFilterBC(2,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(categories[0]);
PropString sFilterName(3,"",T("|Filter beams and sheets with name|"));
sFilterName.setCategory(categories[0]);
PropString sFilterLabel(4,"",T("|Filter beams and sheets with label|"));
sFilterLabel.setCategory(categories[0]);
PropString sFilterMaterial(5,"",T("|Filter beams and sheets with material|"));
sFilterMaterial.setCategory(categories[0]);
PropString sFilterHsbID(6,"",T("|Filter beams and sheets with hsbID|"));
sFilterHsbID.setCategory(categories[0]);
PropString sFilterZone(7, "", T("|Filter zones|"));
sFilterZone.setCategory(categories[0]);
PropDouble dPointsAnalyzer (0, U(6), T("|Max amount of points to analyse|"));
dPointsAnalyzer.setDescription(T("|Give in the max amount of points to analyse, default this is 6. When having round tools in sheeting more points can be needed to show the tool in the dxf output.|"));
dPointsAnalyzer.setCategory(categories[0]);

int arVersions[] = {_kVersionCurrent, _kVersion2000, _kVersion2004, _kVersion2007, _kVersion2010 };
PropInt pVersion(0,arVersions,T("|Dxf version|"));
pVersion.setDescription(T("|Sets the format the Dxf file is saved to. Leave it to '0' if you want to save it to the current version.|"));
pVersion.setCategory(categories[1]);
PropString sAlignement(9,vectors, T("|Section from|"));	
sAlignement.setDescription(T("|Defines the alignement of the section exported to dxf|"));
sAlignement.setCategory(categories[1]);
PropString sExportFullBody(13, arSYesNo, T("|Export body|"), 1);
sExportFullBody.setDescription(T("|Specify whether the full body should be exported instead of a 2d surface"));
sExportFullBody.setCategory(categories[1]);
PropString sFileName(11, "@(Position number)", T("|File name|"));
sFileName.setDescription(T("|Specify the file name of the to be created| .dxf| file|.") + TN("|You can use HSB_G-ContentFormat to specify the file name by using @(Material)"));
PropString sStartWithDwgPath(12, arSYesNo, T("|File in Dwg path|"));
sStartWithDwgPath.setDescription(T("|Specify whether the file should be created in the dwg folder, otherwise you should manually set a different path"));

// Get catalog names
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
 {
 	setPropValuesFromCatalog(_kExecuteKey);
 }
 
if( _bOnInsert )
{
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
		setCatalogFromPropValues(T("_LastInserted"));
	}
			
	PrEntity ssE(T("|Select a set of elements or <ENTER> to select genbeams.|"), Element());
	if ( ssE.go() )
		_Element.append(ssE.elementSet());
		if (_Element.length() == 0) 
		{

			
			PrEntity ssEGBm(T("|Select genbeams|"), GenBeam());
			if (ssEGBm.go())
			{
				_Beam.append(ssEGBm.beamSet());
				_Sheet.append(ssEGBm.sheetSet());
				return;
			}
		}
		
		return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted"))
{
	 manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// Set properties from catalog
if (_bOnDbCreated && manualInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}


// Resolve properties.
int bAllFiltersEmpty = true;

addRecalcTrigger(_kContext, "Write to dxf");

String filterDef = filterDefinition;

int bExlude = arBExclude[arSFilterType.find(sFilterType,1)];
int bStartInDwgPath = sStartWithDwgPath == T("|Yes|");
int bExportFullBody = sExportFullBody == T("|Yes|");
Element arEl[0];
arEl.append(_Element);

Point3d worldPtOrg(0, 0, 0);
CoordSys worldCs(worldPtOrg, _XW, _YW, _ZW);

GenBeam arGBm[0];
Beam arBm[0];
Sheet arSh[0];

Beam collectedBeams[0];
collectedBeams.append(_Beam);
Sheet collectedSheets[0];
collectedSheets.append(_Sheet);

for(int b = 0; b < collectedBeams.length(); b++)
{
	arGBm.append(collectedBeams[b]);
}
for(int s = 0; s < collectedSheets.length(); s++)
{
	arGBm.append(collectedSheets[s]);
}

int bRelativeToPt0 = false;
if (arEl.length() != 0)
{
	for ( int e = 0; e < arEl.length(); e++) {
		Element el = arEl[e];
		
		GenBeam beams[] = el.genBeam();
		GenBeam filteredBeams[0];
		Entity beamEntities[0];
		
		for (int b = 0; b < beams.length(); b++)
		{
			GenBeam gbm = beams[b];
			if (gbm.bIsDummy()) { continue; }
			
			beamEntities.append(beams[b]);
		}
		
		Map filterGenBeamsMap;
		filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
		int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDef, filterGenBeamsMap);
		if ( ! successfullyFiltered)
		{
			reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
			eraseInstance();
			return;
		}
		
		beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		
		if (sFilterBC.length() != 0)
		{
			Map filterGenBeamsBeamCode;
			filterGenBeamsBeamCode.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
			filterGenBeamsBeamCode.setString("BeamCode[]", sFilterBC);
			filterGenBeamsBeamCode.setInt("Exclude", bExlude);
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsBeamCode);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			beamEntities = filterGenBeamsBeamCode.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		}
		if (sFilterName.length() != 0)
		{
			Map filterGenBeamsName;
			filterGenBeamsName.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
			filterGenBeamsName.setString("Name[]", sFilterName);
			filterGenBeamsName.setInt("Exclude", bExlude);
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsName);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			
			beamEntities = filterGenBeamsName.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		}
		if (sFilterLabel.length() != 0)
		{
			Map filterGenBeamsLabel;
			filterGenBeamsLabel.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
			filterGenBeamsLabel.setString("Label[]", sFilterLabel);
			filterGenBeamsLabel.setInt("Exclude", bExlude);
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsLabel);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			
			beamEntities = filterGenBeamsLabel.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		}
		if (sFilterMaterial.length() != 0)
		{
			Map filterGenBeamsMaterial;
			filterGenBeamsMaterial.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
			filterGenBeamsMaterial.setString("Material[]", sFilterMaterial);
			filterGenBeamsMaterial.setInt("Exclude", bExlude);
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMaterial);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			
			beamEntities = filterGenBeamsMaterial.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		}
		if (sFilterHsbID.length() != 0)
		{
			Map filterGenBeamshsbId;
			filterGenBeamshsbId.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
			filterGenBeamshsbId.setString("HsbId[]", sFilterHsbID);
			filterGenBeamshsbId.setInt("Exclude", bExlude);
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamshsbId);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			
			beamEntities = filterGenBeamshsbId.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		}
		if (sFilterZone.length() != 0)
		{
			Map filterGenBeamsZone;
			filterGenBeamsZone.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
			filterGenBeamsZone.setString("Zone[]", sFilterZone);
			filterGenBeamsZone.setInt("Exclude", bExlude);
			int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsZone);
			if ( ! successfullyFiltered)
			{
				reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
				eraseInstance();
				return;
			}
			
			beamEntities = filterGenBeamsZone.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		}
		
		for (int e = 0; e < beamEntities.length(); e++)
		{
			Entity ent = beamEntities[e];
			
			GenBeam gBm = (GenBeam)ent;
			if (gBm.bIsValid() )
				arGBm.append(gBm);
			
			Beam bm = (Beam)ent;
			if (bm.bIsValid() )
				arBm.append(bm);
			
			Sheet sh = (Sheet)ent;
			if (sh.bIsValid() )
				arSh.append(sh);
		}
	}
}
else
{
	if (arGBm.length() != 0)
	{
		for(int i = 0; i < arGBm.length();i++)
		{
			GenBeam gBm = arGBm[i];
			
			Beam bm = (Beam)gBm;
			if (bm.bIsValid() )
				arBm.append(bm);
			
			Sheet sh = (Sheet)gBm;
			if (sh.bIsValid() )
				arSh.append(sh);
		}
	}
}

String usedFormats[0];

for (int i =0; i < arGBm.length(); i++)
{
	GenBeam gBm = arGBm[i];
	Element el = gBm.element();
	Display dpDxf(-1);
	if ((sAlignement == vectors[3] || sAlignement == vectors[4] || sAlignement == vectors[5]) && ! el.bIsValid())
	{
		reportMessage(TN("|Element not valid for entity|: ") + gBm.handle());
		continue;
	}
	
	Vector3d vecZDir = gBm.coordSys().vecX();
	Vector3d vecXDir = gBm.coordSys().vecY();
	Vector3d vecYDir = gBm.coordSys().vecZ();
	if (sAlignement == vectors[1])
	{
		vecZDir = gBm.coordSys().vecY();
		vecXDir = gBm.coordSys().vecX();
		vecYDir = gBm.coordSys().vecZ();
	}
	else if (sAlignement == vectors[2])
	{
		vecZDir = gBm.coordSys().vecZ();
		vecXDir = gBm.coordSys().vecX();
		vecYDir = gBm.coordSys().vecY();
	}
	else if (sAlignement == vectors[3])
	{
		vecZDir = el.vecX();
		vecXDir = el.vecY();
		vecYDir = el.vecZ();
	}
	else if (sAlignement == vectors[4])
	{
		vecZDir = el.vecY();
		vecXDir = el.vecX();
		vecYDir = el.vecZ();			
	}
	else if (sAlignement == vectors[5])
	{
		vecZDir = el.vecZ();
		vecXDir = el.vecX();
		vecYDir = el.vecY();			
	}
	else if (sAlignement == vectors[6])
	{
		vecZDir = _XW;
		vecXDir = _YW;
		vecYDir = _ZW;
	}
	else if (sAlignement == vectors[7])
	{
		vecZDir = _YW;
		vecXDir = _XW;
		vecYDir = _ZW;			
	}
	else if (sAlignement == vectors[8])
	{
		vecZDir = _ZW;
		vecXDir = _XW;
		vecYDir = _YW;
	}
	
	CoordSys csToDefinePlane(gBm.coordSys().ptOrg(), vecXDir, vecYDir, vecZDir);
	CoordSys csToOrg = csToDefinePlane;
	csToOrg.invert();
	Plane plane(gBm.coordSys().ptOrg(), vecZDir); 
	
	PLine arPlGBm[0];
	String arSLayer[0];
	int arBRingIsOpening[0];
	
	Body bdGBmEnvelope = gBm.realBody();
//	bdGBmEnvelope.vis();
	plane.vis();
	PlaneProfile ppGBmEnvelope = bdGBmEnvelope.shadowProfile(plane);
	ppGBmEnvelope.vis(2);
	
	PLine arPlGBmEnvelope[] = ppGBmEnvelope.allRings();
	int arBPlGBmEnvelopeIsOpening[] = ppGBmEnvelope.ringIsOpening();
	Beam beam = (Beam)gBm;
	if (beam.bIsValid() && beam.curvedStyle() != _kStraight)
	{
		CurvedStyle curvedStyle(beam.curvedStyle());
		
		PLine outLine = curvedStyle.closedCurve();
		CoordSys curvedBeamCoordSys(beam.ptRef(), beam.vecX(), beam.vecZ(), - beam.vecY());
		outLine.transformBy(curvedBeamCoordSys);
		PlaneProfile pp(outLine);
		ppGBmEnvelope.shrink(-U(.1));
		//ppGBmEnvelope.vis(1);
		pp.intersectWith(ppGBmEnvelope);
		pp.vis(2);
		
		PLine plines[] = pp.allRings();
		PLine newOutLine = plines[0];
		newOutLine.transformBy(csToOrg);
		arPlGBm.append(newOutLine);
		arBRingIsOpening.append(false);
		arSLayer.append("hsbMain");		
	}
	else
	{
		for ( int j = 0; j < arPlGBmEnvelope.length(); j++)
		{
			PLine pl = arPlGBmEnvelope[j];
			int bIsOpening = arBPlGBmEnvelopeIsOpening[j];
			
			if ( bIsOpening)
			{
				// It is an opening.
				PlaneProfile ppThisRing(ppGBmEnvelope.coordSys());
				ppThisRing.joinRing(pl, _kAdd);
				
				// Its an opening. Add it as a main opening.
				pl.transformBy(csToOrg);
				arPlGBm.append(pl);
				arBRingIsOpening.append(true);
				arSLayer.append("hsbMain");
			}
			else 
			{
				// Its not an opening. Add it as a main ring.
				pl.transformBy(csToOrg);
				arPlGBm.append(pl);
				arBRingIsOpening.append(false);
				arSLayer.append("hsbMain");
			}
		}
	}

		
	Point3d arPtCen[0];
	for ( int j = 0; j < arPlGBm.length(); j++) {
		PLine plGbm = arPlGBm[j];
		int bRingIsOpening = arBRingIsOpening[j];
		String sLayer = arSLayer[j];
		if ( sLayer == "" )
			sLayer = "hsbMain";
		
		double maxAmountOfPoints = dPointsAnalyzer;
		Point3d arPtPl[] = plGbm.vertexPoints(TRUE);
		if ( arPtPl.length() == 0 || (arPtPl.length() > maxAmountOfPoints && bRingIsOpening) )
			continue;
		
		dpDxf.layer(sLayer);
		if (bExportFullBody)
		{
			bdGBmEnvelope.transformBy(csToOrg);
			dpDxf.draw(bdGBmEnvelope);
		}
		else
		{
			dpDxf.draw(plGbm);
		}
	}
	
	String strName = bStartInDwgPath ? _kPathDwg + "\\" : "";
	Map contentFormatMap;
	contentFormatMap.setString("FormatContent", sFileName);
	contentFormatMap.setEntity("FormatEntity", gBm);
	int succeeded = TslInst().callMapIO(contentFormatTslName, "", contentFormatMap);
	if(!succeeded)
	{
		reportNotice(T("|Please make sure that the tsl HSB_G-ContentFormat is loaded in the drawing|"));
	}
	String formattedString = contentFormatMap.getString("FormatContent");
	
	if (usedFormats.find(formattedString) != -1) continue;
	
	strName += formattedString;
	
	usedFormats.append(formattedString);
	
	String newStrName = "";
	int s = 0;
	for (int s = 0; s < strName.length(); s++)
	{
		char c = strName.getAt(s);
		
		if(c == ';' )
		{
			newStrName += '_';
		}
		else
		{
			newStrName += c;
		}
	}
	
	newStrName += ".dxf";
	dpDxf.writeToDxfFile(newStrName, bRelativeToPt0, pVersion);
	reportMessage(TN("|File created|: ") + newStrName);
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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add option to export full body" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/20/2025 10:20:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to not use dwgpath" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/17/2022 11:22:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make the amount of points a property. Customer wishes to have more points, to have several tools also considered. Making it a property give the user the flexibility, and does nog create chaos at other users." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/28/2021 1:23:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Change maximum arPtPl.length() amount of points to 10. Electricitypoint holes where not drawn." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/7/2021 10:39:56 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End