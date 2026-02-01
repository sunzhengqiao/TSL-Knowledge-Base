#Version 8
#BeginDescription
This tsl creates an integrated tooling at intersection of beams.

2.0 24/05/2023 Change selection to match command HSB_LinkTools Author: Robert Pol

1.8 21/03/2022 Change insertion to be able to select multiple male beams. Author: Robert Pol

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents

//region
/// <insert Lang=en>
/// Select 1 tooling malebeam, and multiple female beams where the tooling has to be applied on.
/// </insert>

/// <summary Lang=en>
/// This tsl creates an integrated tooling at intersection of beams.
/// </summary>


/// <version value="1.7" date="01.05.2020" author="robert.pol@hsbcad.com"> initial </version>


/// <History>
/// RVW 	- 1.00 - 25.02.2019 -		Pilot version.
/// RVW	- 1.01 - 16.04.2019 -		Add choice for intersection of beams from male PtCenter or PtCenterSolid.
/// RP   	- 1.02 - 11.03.2020 -		Add option to remove male and make a it a static tool 
/// RP   	- 1.03 - 11.03.2020 -		Add option to make the beamcut square
/// RP   	- 1.04 - 27.03.2020 -		Correct index
/// RP   	- 1.05 - 17.04.2020 -		Make beamcut square before eraseInstance
/// RP   	- 1.06 - 01.05.2020 -		Bugfix where one of the female beams was deleted when using the static option
/// RP   	- 1.07 - 01.05.2020 -		Fix where female was set to dummy.
//#Versions
//2.0 24/05/2023 Change selection to match command HSB_LinkTools Author: Robert Pol
//1.8 21/03/2022 Change insertion to be able to select multiple male beams. Author: Robert Pol
/// </History>

//endregion;

double dEps = U(0.01, "mm");
double pointTolerance = (U(.1));
String category = T("|Geometry|");
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String sYesNo[] = { T("|Yes|"), T("|No|")};
String executeKey = "ManualInsert";
String sJustification[] =
{
	T("|Center|"),
	T("|Top|"),
	T("|Top-Left|"),
	T("|Top-Right|"),
	T("|Left|"),
	T("|Right|"),
	T("|Bottom|"),
	T("|Bottom-Left|"),
	T("|Bottom-Right|")
};

String arChoicePtCen[] = { T("|PtCenter|"), T("|PtCenterSolid|")};

PropString sChoicePtCen (5, arChoicePtCen, T("|Intersection at centerPoint or SolidCenterPoint|."));
sChoicePtCen.setDescription(T("|Choose from where the intersection has to be calculated. From the certerPoint or the SolidCenterPoint of the male beam|."));

PropDouble dAdditionalWidth (0, U(0), T("|Additional width|"));
dAdditionalWidth.setCategory(category);
PropDouble dAdditionalHeight (1, U(0), T("|Additional height|"));
dAdditionalHeight.setCategory(category);

PropString sJustificationChoice (0, sJustification, T("|Justification point|"), 0);
sJustificationChoice.setDescription(T("|Sets the justification point for the additional width/ height|."));
sJustificationChoice.setCategory(category);

PropDouble dOffsetDirX (2, U(0), T("|Offset in X direction|"));
dOffsetDirX.setCategory(category);
PropDouble dOffsetDirY (3, U(0), T("|Offset in Y direction|"));
dOffsetDirY.setCategory(category);
PropDouble dOffsetDirZ (4, U(0), T("|Offset in Z direction|"));
dOffsetDirZ.setCategory(category);
PropDouble dNegFrontOffset (5, U(0), T("|Negative front offset|"));
dNegFrontOffset.setCategory(category);
PropDouble dPosFrontOffset (6, U(0), T("|Positive front offset|"));
dPosFrontOffset.setCategory(category);
PropString sModifyForCNC (1, sYesNo, T("|Modify section for CNC|"), 1);
sModifyForCNC.setCategory(category);
int modifySectionForCnc = sYesNo.find(sModifyForCNC) == 0;
PropString sConvertToDummy (2, sYesNo, T("|Convert to Dummy|"), 1);
sConvertToDummy.setCategory(category);
int convertToDummy = sYesNo.find(sConvertToDummy) == 0;
PropString sConvertToStatic (3, sYesNo, T("|Convert to static tool|"), 1);
sConvertToStatic.setCategory(category);
int convertToStatic = sYesNo.find(sConvertToStatic) == 0;
PropString sConvertToSquare (4, sYesNo, T("|Make beamcut square|"), 1);
sConvertToSquare.setCategory(category);
int convertToSquare = sYesNo.find(sConvertToSquare) == 0;

// bOnInsert//region
if (_bOnInsert)
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
	
	PrEntity ssBmFm(T("|Select a set of female beam(s)|"), Beam());
	Beam femaleBeams[0];
	if (ssBmFm.go())
	{
		femaleBeams.append(ssBmFm.beamSet());
	}
	PrEntity ssBmMl(T("|Select a set of male beam(s)|"), Beam());
	Beam maleBeams[0];
	if (ssBmMl.go())
	{
		maleBeams.append(ssBmMl.beamSet());
	}
	
	for (int m=0;m< maleBeams.length();m++)
	{
		Beam maleBeam = maleBeams[m];
		Body maleBody = maleBeam.realBody();
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[0];
		gbsTsl.append(maleBeam);
		for (int index=0;index<femaleBeams.length();index++) 
		{ 
			Beam femaleBeam = femaleBeams[index]; 
			Body femaleBody = femaleBeam.realBody();
			if (! femaleBody.hasIntersection(maleBody)) continue;
			gbsTsl.append(femaleBeam); 
		}
		
		Entity entsTsl[0];
		Point3d ptsTsl[] = {};

		Map mapTsl;	
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
	eraseInstance();
	return;
}
// end on insert	__________________//endregion

//region Add and remove beam custom action
// Trigger Add beam
String sTriggerAddBeam = T("|Add beam|");
addRecalcTrigger(_kContext, sTriggerAddBeam);
if (_bOnRecalc && (_kExecuteKey==sTriggerAddBeam || _kExecuteKey=="TslDoubleClick"))
{
	Entity ents[0];
	PrEntity ssE(T("|Select female beam(s)"), Beam());
	if (ssE.go())
		ents.append(ssE.set());
		
	for(int e = 0; e < ents.length(); e++)
		_GenBeam.append((Beam)ents[e]);
}	

// Trigger Remove beam
String sTriggerRemoveBeam = T("|Remove beam|");
addRecalcTrigger(_kContext, sTriggerRemoveBeam);
if (_bOnRecalc && (_kExecuteKey==sTriggerRemoveBeam || _kExecuteKey=="TslDoubleClick"))
{
	Entity ents[0];
	PrEntity ssE(T("|Select female beam(s)"), Beam());
	if (ssE.go())
		ents.append(ssE.set());
		
	for(int e = 0; e < ents.length(); e++)
	{
		if(_GenBeam.find((Beam)ents[e]) != -1)
			_GenBeam.removeAt(_GenBeam.find((Beam)ents[e]));
	}
}	
//endregion

if (_GenBeam.length() < 2)
{
	eraseInstance();
	return;
}

GenBeam male = _GenBeam[0];
if (! convertToStatic)
{
	setDependencyOnEntity(male);
}
GenBeam femaleGenBeams[0];
femaleGenBeams.append(_GenBeam);
femaleGenBeams.removeAt(0);
Point3d bmPtCen;
if (sChoicePtCen == "PtCenter")
{
	bmPtCen = male.ptCen();
}
else
{
	bmPtCen = male.ptCenSolid();
}
Vector3d bmMaleX = male.vecX();
Vector3d bmMaleY = male.vecY();
Vector3d bmMaleZ = male.vecZ();

double bmMLength = male.solidLength();

Point3d startPoint = bmPtCen - bmMaleX * (bmMLength / 2 - dNegFrontOffset);
Point3d endPoint = bmPtCen + bmMaleX * (bmMLength / 2 - dPosFrontOffset);

bmMLength = abs(bmMaleX.dotProduct(endPoint - startPoint));
bmPtCen = (startPoint + endPoint) / 2;
Display dp(-1);

double bCutWidt = male.solidWidth() + dAdditionalWidth;
double bCutHeight = male.solidHeight() + dAdditionalHeight;

PLine pline(startPoint, endPoint);
dp.draw(pline);

if (sJustificationChoice == (T("|Top|")))
{
	bmPtCen -= bmMaleZ * dAdditionalHeight *0.5 ;
}
if (sJustificationChoice == (T("|Top-Left|")))
{
	bmPtCen -= bmMaleZ * dAdditionalHeight * 0.5;
	bmPtCen -= bmMaleY * dAdditionalWidth *0.5;
}
if (sJustificationChoice == (T("|Top-Right|")))
{
	bmPtCen -= bmMaleZ * dAdditionalHeight * 0.5;
	bmPtCen += bmMaleY * dAdditionalWidth *0.5;
}
if (sJustificationChoice == (T("|Left|")))
{
	bmPtCen -= bmMaleY * dAdditionalWidth *0.5;
}
if (sJustificationChoice == (T("|Right|")))
{
	bmPtCen += bmMaleY * dAdditionalWidth *0.5;
}
if (sJustificationChoice == (T("|Bottom|")))
{
	bmPtCen += bmMaleZ * dAdditionalHeight * 0.5;
}
if (sJustificationChoice == (T("|Bottom-Left|")))
{
	bmPtCen += bmMaleZ * dAdditionalHeight * 0.5;
	bmPtCen += bmMaleY * dAdditionalWidth *0.5;
}
if (sJustificationChoice == (T("|Bottom-Right|")))
{
	bmPtCen += bmMaleZ * dAdditionalHeight * 0.5;
	bmPtCen -= bmMaleY * dAdditionalWidth *0.5;
}

if (dOffsetDirX > 0)
{
	bmPtCen += bmMaleX * dOffsetDirX;
}
if (dOffsetDirY > 0)
{
	bmPtCen += bmMaleY * dOffsetDirY;
}
if (dOffsetDirZ > 0)
{
	bmPtCen += bmMaleZ * dOffsetDirZ;
}

BeamCut cBmMale (bmPtCen, bmMaleX, bmMaleY, bmMaleZ, bmMLength + pointTolerance, bCutWidt, bCutHeight, 0, 0, 0);
cBmMale.cuttingBody().vis();
cBmMale.setModifySectionForCnC(modifySectionForCnc);
if (convertToStatic && _bOnDbCreated)
{
	for (int index=0;index<femaleGenBeams.length();index++) 
	{ 
		GenBeam genBeam = femaleGenBeams[index]; 
		genBeam.addToolStatic(cBmMale); 
	}
	
	if (convertToSquare)
	{
		Entity beamEntities[0];
		for (int index=0;index<femaleGenBeams.length();index++) 
		{ 
			beamEntities.append(femaleGenBeams[index]);
		}
		
		Map squareBeamCutMap;
		squareBeamCutMap.setEntityArray(beamEntities, false, "Beams", "Beams", "Beam");
		int successfullyFiltered = TslInst().callMapIO("HSB_T-SquareBeamCut", "", squareBeamCutMap);
		if ( ! successfullyFiltered)
		{
			reportWarning(T("|Beams could not be analysed!|") + TN("|Make sure that the tsl| ") + "HSB_T-SquareBeamCut" + T(" |is loaded in the drawing|."));
			eraseInstance();
			return;
		}
	}
	male.dbErase();
	eraseInstance();
	return;
}
else
{
	cBmMale.addMeToGenBeamsIntersect(femaleGenBeams);
}

if (! convertToStatic)
{
	male.setBIsDummy(convertToDummy);
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Change selection to match command HSB_LinkTools" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/24/2023 11:28:38 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Change insertion to be able to select multiple male beams." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="3/21/2022 12:05:18 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End