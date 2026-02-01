#Version 8
#BeginDescription

1.2 10/03/2023 Add genbeamfilter Author: Robert Pol
2.1 05/06/2024 Make sure markerlines are only applied on a valid surface Author: Robert Pol

2.0 02/04/2024 Add option for horizontal beams and add painter defenitions Author: Robert Pol


2.2 18/06/2024 Add offset for marking Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to create marker lines on a specific zone. The tsl adds lines at the start and end of the studs/rafters/joists.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="12.12.2012"></version>

/// <history>
/// 1.00 - 12.12.2012 - 	Pilot version
/// 1.01 - 12.12.2012 - 	Filter added to exclude modules
// #Versions
//2.2 18/06/2024 Add offset for marking Author: Robert Pol
//2.1 05/06/2024 Make sure markerlines are only applied on a valid surface Author: Robert Pol
//2.0 02/04/2024 Add option for horizontal beams and add painter defenitions Author: Robert Pol
//1.2 10/03/2023 Add genbeamfilter Author: Robert Pol
/// </hsitory>

double dEps(Unit(0.01,"mm"));
String sDisabled = T("|Disabled|");
String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
String arSElementType[] = {T("|Roof|"), T("|Floor|"), T("|Wall|")};
String arSElementTypeCombinations[0];
int jStart = 1;
for( int i=0;i<arSElementType.length();i++ ){
	String sTypeA = arSElementType[i];
	if( arSElementTypeCombinations.find(sTypeA) == -1 )
		arSElementTypeCombinations.append(sTypeA);
	
	int j = jStart;

	while( j<arSElementType.length() ){
		String sTypeB = arSElementType[j];
		
		sTypeA += ";"+sTypeB;
		arSElementTypeCombinations.append(sTypeA);

		j++;
	}
	
	jStart++;
	if( jStart < arSElementType.length() )
		i--;
	else
		jStart = i+2;
}
PropString sApplyToolingToElementType(1, arSElementTypeCombinations, "     "+T("|Apply tooling to element type(s)|"),6);
// filter beams with beamcode
PropString sFilterBC(2,"","     "+T("|Filter beams with beamcode|"));
PropString sExcludeModule(5, arSYesNo, "     "+T("|Exclude modules|"));
// Filter
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = {""}; filterDefinitions.append(TslInst().getListOfCatalogNames(filterDefinitionTslName));

// some default painter definitions are expected. If not existant they will be created automatically
String sPainters[] = PainterDefinition().getAllEntryNames();
sPainters = sPainters.sorted();
sPainters.insertAt(0, sDisabled);
//End Painters//endregion 

PropString filterDefinition(6, filterDefinitions, T("|Filter definition beams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

String sPainterName=T("|Genbeam Painter|");	
PropString sPainter(7,sPainters, sPainterName);	
sPainter.setDescription(T("|Defines the Painter definition to filter genbeams|"));



String arSZnToProcess[] = {
	"Zone 1",
	"Zone 2",
	"Zone 3",
	"Zone 4",
	"Zone 5",
	"Zone 6",
	"Zone 7",
	"Zone 8",
	"Zone 9",
	"Zone 10"
};
int arNZnToProcess[] = {
	1,
	2,
	3,
	4,
	5,
	-1,
	-2,
	-3,
	-4,
	-5
};
String arSDirections[] = {
	T("|Vertical|"),
	T("|Horizontal|")

};
PropString sSeperator02(3, "", T("|Tooling|"));
sSeperator02.setReadOnly(true);
PropDouble dMarkSize(0, U(300), "     "+T("|Length markerline|"));
PropDouble dMarkOffset(1, U(0), "     "+T("|Offset markerline|"));
PropString sApplyToolingTo(4, arSZnToProcess, "     "+T("|Apply tooling to|"),0);
PropString sToolingDirection(5, arSDirections, "     "+T("|Direction|"),0);
PropInt nToolingIndex(0, 10, "     "+T("|Toolindex|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-Markerlines");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	PrEntity ssE(T("|Select a set of elements|"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-Markerlines"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
				
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName && tsl.propString("     "+T("|Apply tooling to|")) == sApplyToolingTo){
					tsl.dbErase();
				}
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsls inserted|."));
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

// resolve properties
int bExcludeModules = arNYesNo[arSYesNo.find(sExcludeModule, 0)];
// nail these zones
int arNZone[0];
int nZnToProcess = arNZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)];
arNZone.append(nZnToProcess);
String arSBmCodeFilter[] = sFilterBC.tokenize(";");
// check if there is a valid element selected.
if( _Element.length()==0 ){
	eraseInstance();
	return;
}

// get element
Element el = _Element[0];

Opening arOp[] = el.opening();

// create coordsys
CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
// set origin point
_Pt0 = csEl.ptOrg();

double dz = vzEl.dotProduct(_ZW);
String sElemType;
if( abs(dz - 1) < dEps ){
	sElemType = T("|Floor|");
}
else if( abs(dz) < dEps ){
	sElemType = T("|Wall|");
}
else{
	sElemType = T("|Roof|");
}

if( sApplyToolingToElementType.find(sElemType,0) == -1 ){
	reportMessage(TN("|Element type filtered out|"+": "+sElemType));
	eraseInstance();
	return;
}

// display
Display dp(-1);

GenBeam arBmToMark[0];
GenBeam arBmAll[] = el.genBeam();
GenBeam filteredBeams[0];
Entity beamEntities[0];

for (int b = 0; b < arBmAll.length(); b++)
{
	beamEntities.append(arBmAll[b]);
}

//region Filter

//Check if the property is filled, if so it will use this beamcode
Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");

int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|Beams could not be filtered|!") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

PainterDefinition pd(sPainter);
if (pd.bIsValid() && sPainter != sDisabled)
{
	beamEntities = pd.filterAcceptedEntities(beamEntities);
}

for (int b = 0; b < beamEntities.length(); b++)
{
	GenBeam filteredBeam = (GenBeam)beamEntities[b];
	
	if( bExcludeModules && filteredBeam.module() != "" ) continue;
	if( arSBmCodeFilter.find(filteredBeam.beamCode().token(0)) != -1 )continue;
	
	filteredBeams.append(filteredBeam);
	
	if(abs(filteredBeam.vecX().dotProduct(vyEl)) > 1 - dEps && sToolingDirection == T("|Vertical|"))
	{
		arBmToMark.append(filteredBeam);
	}
	else if (abs(filteredBeam.vecX().dotProduct(vxEl)) > 1 - dEps && sToolingDirection == T("|Horizontal|"))
	{
		arBmToMark.append(filteredBeam);
	}
}
//endregion

for( int i=0;i<arNZone.length();i++ ){
	// zone
	int nZone = arNZone[i];
	
	GenBeam genBeamsZone[] = el.genBeam(nZone);
	if (pd.bIsValid() && sPainter != sDisabled)
	{
		genBeamsZone = pd.filterAcceptedEntities(genBeamsZone);
	}
	PlaneProfile zoneProfile(csEl);
	for (int z=0;z<genBeamsZone.length();z++)
	{
		GenBeam genBeamZone = genBeamsZone[z];
		PlaneProfile genBeamProfile = genBeamZone.envelopeBody().shadowProfile(Plane(_Pt0, vzEl));
		zoneProfile.unionWith(genBeamProfile);
	}
	
	for( int j=0;j<arBmToMark.length();j++ ){
		GenBeam bm  = arBmToMark[j];
		PlaneProfile beamProfile = bm.envelopeBody().shadowProfile(Plane(_Pt0, vzEl));
		if ( ! beamProfile.intersectWith(zoneProfile)) continue;
		
		Vector3d beamX = bm.vecX();
		LineSeg beamProfileDiagonal = beamProfile.extentInDir(beamX);
		Point3d arPtBm[] = 
		{
			beamProfileDiagonal.ptMid() + beamX * beamX.dotProduct(beamProfileDiagonal.ptStart() - beamProfileDiagonal.ptMid()),
			beamProfileDiagonal.ptMid() + beamX * beamX.dotProduct(beamProfileDiagonal.ptEnd() - beamProfileDiagonal.ptMid())

		};
		Vector3d arVDir[] = {
			beamX,
			- beamX
		};
		
		Vector3d vecPerpendicular =beamX.crossProduct(vzEl);
		for( int k=0;k<arPtBm.length();k++ ){
			Point3d ptStartMark = arPtBm[k] + vecPerpendicular * vecPerpendicular.dotProduct(beamProfileDiagonal.ptStart() - beamProfileDiagonal.ptMid());
			Vector3d vDir = arVDir[k];
			ptStartMark += vDir * dMarkOffset;
			PLine plMark(vzEl);
			plMark.addVertex(ptStartMark);
			plMark.addVertex(ptStartMark + vDir * dMarkSize);
			
			ElemMarker elMarker(nZone, plMark, nToolingIndex);
			el.addTool(elMarker);
			
			plMark.transformBy(vecPerpendicular * vecPerpendicular.dotProduct(beamProfileDiagonal.ptEnd() - beamProfileDiagonal.ptStart()));
			elMarker = ElemMarker(nZone, plMark, nToolingIndex);
			el.addTool(elMarker);
		}		
	}
}

























#End
#BeginThumbnail
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
L^!(_PKZ8HJOK4Q?5X'S0/@IXR!_U%EC_`*^1_A7TO11652K*IN7"FH;'_]E?
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
        <int nm="BreakPoint" vl="241" />
        <int nm="BreakPoint" vl="280" />
        <int nm="BreakPoint" vl="321" />
        <int nm="BreakPoint" vl="275" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add offset for marking" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/18/2024 11:52:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make sure markerlines are only applied on a valid surface" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/5/2024 3:31:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option for horizontal beams and add painter defenitions" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/2/2024 11:13:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add genbeamfilter" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/10/2023 10:08:21 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End