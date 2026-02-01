#Version 8
#BeginDescription

#Versions: 
Version 3.1 04/11/2025 HSB-24576: Write material as materialdescription, so that hsbCenterOfGravity can perform the weight and cog calculation , Author Marsel Nakuci
Version 3.0 28-3-2023 Add option to fill insulation from the top or bottom of zone 0. When the height is not the same as the height of zone 0. Ronald van Wijngaarden
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
13.05.2020 -  version 2.03




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 1
#KeyWords Insulation,
#BeginContents
/// <summary Lang=en>
/// This tsl adds insulation data to the selected element.
/// </summary>

/// <insert>
/// Select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.03" date="13.05.2020"></version>

/// <history>
/// AS - 1.00 - 24.09.2015 -	First revision
/// AS - 1.01 - 25.09.2015 -	Create insulation, add info for BOM
/// AS - 1.02 - 12.10.2015 -	Save mapBOM in _Map. Correct netto width.
/// AS - 1.03 - 12.10.2015 -	Save sizes as double, set compare key.
/// AS - 1.04 - 12.10.2015 -	Add different visualisations for elevation, plan, side & 3D view.
/// AS - 1.05 - 18.02.2016 -	Set the elemzone for the 3d display.
/// AS - 1.06 - 05.04.2016 -	Add extra length to the insulation.
/// AS - 2.00 - 15.03.2017 - 	Changed insert.
/// AS - 2.01 - 22.06.2017 - 	Element can be attached to element construction tsls.
/// RP - 2.02 - 17.12.2018 - 	Add genbeamfilter (only on insert)
/// Rvw - 2.03- 13.05.2020 -	Get pp from beams using .ShadowProfile() instead of the extractContactFaceInPlane() function with a offset of U(10). Beams with half the height of the element are now also taken in account.
/// </history>

//#Versions
// 3.1 04/11/2025 HSB-24576: Write material as materialdescription, so that hsbCenterOfGravity can perform the weight and cog calculation , Author Marsel Nakuci
//3.0 28-3-2023 Add option to fill insulation from the top or bottom of zone 0. When the height is not the same as the height of zone 0. Ronald van Wijngaarden



double dEps = Unit(0.1,"mm");


//Delete this one if element is reconstructed
if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

int zoneIndexes[] = {0,1,2,3,4,5,6,7,8,9,10};
String hsbLayers[] = {
	"Zone",
	"Info",
	"Dimension",
	"Tooling"
};
char hsbLayerCharacters[] = {
	'Z',
	'I',
	'D',
	'T'
};

String arSTextPosition[] = {
	T("|Top|"),
	T("|Center|"),
	T("|Bottom|")
};
int arNTextPosition[] = {
	1,
	0,
	-1
};
String arSStart[] = {
	T("|Top|"),
	T("|Bottom|")
};

String categories[] = {
	T("|General|"),
	T("|Properties|"),
	T("|Visualisation|")
};
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

PropString genBeamFilterDefinition(3, filterDefinitions, T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinition.setCategory(categories[0]);

PropDouble minimumWidth(0, U(100), T("|Minimum distance between studs|"));
minimumWidth.setCategory(categories[0]);
minimumWidth.setDescription(T("|Sets the minimum allowed width.|"));
PropDouble minimumVolume(1, U(7000000), T("|Minimum volume|"));
minimumVolume.setCategory(categories[0]);
minimumVolume.setDescription(T("|Sets the minimum allowed volume.|"));
minimumVolume.setFormat(_kVolume);

PropInt propZoneIndex(0, zoneIndexes, T("|Zone index|"));
propZoneIndex.setCategory(categories[0]);
propZoneIndex.setDescription(T("|Sets the zone index.|")
	+ TN("|The insulation is assigned to this zone.|"));
PropString hsbLayer(0, hsbLayers, T("|Element layer|"));
hsbLayer.setCategory(categories[0]);
hsbLayer.setDescription(T("|Sets the element layer.|")
	+ TN("|The insulation is assigned to the selected element layer.|"));


PropString insulationMaterial(1, "Insulation", T("|Material|"));
insulationMaterial.setCategory(categories[1]);
insulationMaterial.setDescription(T("|Sets the insulation material.|"));
PropDouble insulationThickness(2, U(250), T("|Thickness|"));
insulationThickness.setCategory(categories[1]);
insulationThickness.setDescription(T("|Sets the insulation thickness.|"));

PropString insulationStartPoint(4, arSStart, T("|Start from top or bottom|"), 0);
insulationStartPoint.setCategory(categories[1]);
insulationStartPoint.setDescription(T("|When the height of insulation is not full height of zone 0, decide here whether the insulation should start at the bottom or top of zone 0.|"));

PropDouble insulationBruttoWidth(3, U(570), T("|Brutto width|"));
insulationBruttoWidth.setCategory(categories[1]);
insulationBruttoWidth.setDescription(T("|The insulation brutto width.|"));
insulationBruttoWidth.setReadOnly(true);
PropDouble insulationNettoWidth(4, U(560), T("|Netto width|"));
insulationNettoWidth.setCategory(categories[1]);
insulationNettoWidth.setDescription(T("|The insulation netto width.|"));
insulationNettoWidth.setReadOnly(true);
PropDouble insulationBruttoLength(5, U(2520), T("|Brutto length|"));
insulationBruttoLength.setCategory(categories[1]);
insulationBruttoLength.setDescription(T("|The insulation brutto length.|"));
insulationBruttoLength.setReadOnly(true);
PropDouble insulationNettoLength(8, U(2500), T("|Netto length|"));
insulationNettoLength.setCategory(categories[1]);
insulationNettoLength.setDescription(T("|The insulation netto length.|"));
insulationNettoLength.setReadOnly(true);
PropInt insulationColor(1, 45, T("|Color|"));
insulationColor.setCategory(categories[1]);
insulationColor.setDescription(T("|Sets the insulation color.|"));


PropString sHatchPattern(2, _HatchPatterns, T("|Hatch pattern|"));
sHatchPattern.setCategory(categories[2]);
sHatchPattern.setDescription(T("|Sets the hatch pattern which is used to visualize the foam.|"));
PropDouble dHatchScale(6, U(30), T("|Scale hatch pattern|"));
dHatchScale.setCategory(categories[2]);
dHatchScale.setDescription(T("|Sets the scale of the hatch pattern.|"));
PropDouble dHatchAngle(7, 45, T("|Angle hatch pattern|"));
dHatchAngle.setCategory(categories[2]);
dHatchAngle.setDescription(T("|Sets the angle of the hatch pattern.|"));
dHatchAngle.setFormat(_kAngle);

String scriptNamesToErase[] = {
	"HSB_E-Insulation"
};
	
// Set properties if inserted with an execute key
String catalognames[] = TslInst().getListOfCatalogNames("HSB_E-Insulation");
if( _bOnDbCreated && catalognames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalognames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssElements(T("|Select elements|"), Element());
	if (ssElements.go()) {
		Element selectedElements[] = ssElements.elementSet();
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam tslBeams[0];
		Entity tslEntities[1];
		
		Point3d tslPoints[0];
		int tslPropInts[0];
		double tslPropDoubles[0];
		String tslPropStrings[0];
		Map tslMap;
		tslMap.setInt("ElementInserted", true);

		for (int e=0;e<selectedElements.length();e++) {
			Element el = selectedElements[e];
			if (!el.bIsValid())
				continue;
			
			CoordSys csEl = el.coordSys();
			Vector3d elX = csEl.vecX();
			Vector3d elY = csEl.vecY();
			
			tslEntities[0] = el;
			
			TslInst existingTsls[] = el.tslInst();
			for (int t=0;t<existingTsls.length();t++) {
				TslInst tsl = existingTsls[t];
				if (scriptNamesToErase.find(tsl.scriptName()) == -1)
					continue;
				
				if (tsl.handle() == _ThisInst.handle())
					continue;
				
				tsl.dbErase();
			}
			
			TslInst insulationTsl;
			insulationTsl.dbCreate( scriptName(), elX, elY, tslBeams, tslEntities, tslPoints, tslPropInts, tslPropDoubles, tslPropStrings, _kModelSpace, tslMap);
		}
	}
	
	eraseInstance();
	return;
}

int elementInserted = false;
if (_Map.hasInt("ElementInserted")) 
{
	elementInserted = _Map.getInt("ElementInserted");
	_Map.removeAt("ElementInserted", true);
}

if (_Element.length() == 0)
{
	eraseInstance();
	return;
}

// set properties from catalog
if (_bOnDbCreated && elementInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

if (_bOnElementConstructed || elementInserted)
{
	Element el = _Element[0];
	
	CoordSys csEl= el.coordSys();
	Point3d elOrg = csEl.ptOrg();
	Vector3d elX = csEl.vecX();
	Vector3d elY = csEl.vecY();
	Vector3d elZ = csEl.vecZ();
	_Pt0 = elOrg;

	//Thickness zone 0
	double zoneThickness = el.zone(0).dH();

	CoordSys csBack = el.zone(-1).coordSys();
	PlaneProfile beamsProfile(csBack);
	PlaneProfile elementProfile = el.profBrutto(0);

	//Plane describing the beam
	Plane pnBack(csBack.ptOrg(),csBack.vecZ());
		
	Opening openings[] = el.opening();
	Entity elementGenBeamEntities[] = el.elementGroup().collectEntities(false, (Beam()), _kModelSpace, false);

	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for( int b=0;b<filteredGenBeamEntities.length();b++ )
	{
		Beam bm = (Beam)filteredGenBeamEntities[b];
		
		PlaneProfile ppBm(csBack);
		//Use shadowprofile to get the body of the beam. Beams with half the height of the element are also taken in account now.
		ppBm = bm.realBody().shadowProfile(pnBack);
		ppBm.shrink(-U(2));
		beamsProfile.unionWith(ppBm);
	}
	beamsProfile.shrink(U(2));
	
	for( int o=0;o<openings.length();o++ )
	{
		OpeningSF op = (OpeningSF) openings[o];
		if (!op.bIsValid())
			 continue;
		
		PlaneProfile openingProfile(csEl);
		openingProfile.joinRing(op.plShape(), _kAdd);
		
		PlaneProfile tempProfile = openingProfile;
		tempProfile.transformBy(elY * op.dGapTop());
		openingProfile.unionWith(tempProfile);
		tempProfile = openingProfile;
		tempProfile.transformBy(-elY * op.dGapBottom());
		openingProfile.unionWith(tempProfile);
		tempProfile = openingProfile;
		tempProfile.transformBy(-elX * op.dGapSide());
		openingProfile.unionWith(tempProfile);
		tempProfile = openingProfile;
		tempProfile.transformBy(elX * op.dGapSide());
		openingProfile.unionWith(tempProfile);
		
		openingProfile.shrink(-U(5));
		openingProfile.shrink(U(5));
		beamsProfile.unionWith(openingProfile);
	}

	beamsProfile.shrink(-U(5));
	beamsProfile.shrink(U(5));
	beamsProfile.vis();
	
	PLine beamRings[] = beamsProfile.allRings();
	int beamRingIsOpening[] = beamsProfile.ringIsOpening();

	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam tslBeams[0];
	Entity tslEntities[] = {el};
	
	Point3d tslPoints[0];
	int tslPropInts[0];
	double tslPropDoubles[0];
	String tslPropStrings[0];
	Map tslMap;
	tslMap.setInt("ManualInserted", true);
	
	for (int r=0;r<beamRings.length();r++) 
	{
		if (!beamRingIsOpening[r])
			continue;
		
		PLine insulationOutline = beamRings[r];
		// Insulation must be inside the element
		Point3d centerInsulation;
		centerInsulation.setToAverage(insulationOutline.vertexPoints(true));	
		if (elementProfile.pointInProfile(centerInsulation) != _kPointInProfile) continue;

		// Insert insulation
		tslMap.setPLine("Outline", insulationOutline);
		TslInst insulationTsl;
		insulationTsl.dbCreate( scriptName(), elX, elY, tslBeams, tslEntities, tslPoints, tslPropInts, tslPropDoubles, tslPropStrings, _kModelSpace, tslMap);
	}
	
	eraseInstance();
	return;
}

genBeamFilterDefinition.setReadOnly(true);
// check execute conditions
if( _Element.length() == 0 )
{
	reportWarning(TN("|No valid element found|!"));
	eraseInstance();
	return;
}
Element el = (Element)_Element[0];
if (!el.bIsValid()) 
{
	reportWarning(TN("|The selected element is not valid|!"));
	eraseInstance();	
	return;
}

// Stop exection if there are no beams generated yet.
Beam beams[] = el.beam();
if (beams.length() == 0) return;

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

// Assign the tsl to the tooling layer of the element.
_ThisInst.assignToLayer("0");
_ThisInst.assignToElementGroup(el, true, 0, 'E');

// Resolve properties.
char hsbLayerCharacter = hsbLayerCharacters[hsbLayers.find(hsbLayer,0)];
int zoneIndex = propZoneIndex;
if (zoneIndex > 5)
{
	zoneIndex = 5 - zoneIndex;
}

int switchTopBottomFill = (insulationStartPoint == "Top") ? false : true;

// Coordsys of the element, determination of side, and repositioning of point.
CoordSys csEl= el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);
Plane pnElZ(ptEl, vzEl);

Point3d zone0Bottom = el.zone(-1).ptOrg();
Plane pnElementBottom (zone0Bottom, vzEl);

if(switchTopBottomFill)
{
	pnElZ = pnElementBottom;
	vzEl *= -1;
}

// Thickness of zone 0
double dTZn0 = el.dBeamWidth();



String arSTrigger[] = 
{ 
	T("|Select outline|")
};
for( int i=0;i<arSTrigger.length();i++ )
{
	addRecalcTrigger(_kContext, arSTrigger[i] );
}

// Add filteer
if( _kExecuteKey == arSTrigger[0] )
{
	EntPLine newEntPLine = getEntPLine(T("|Select new outline|"));
	if (newEntPLine.bIsValid()) 
	{
		PLine newOutline = newEntPLine.getPLine();
		// Verify the normal
		if (abs(abs(newOutline.coordSys().vecZ().dotProduct(vzEl)) - 1) < dEps)
		{
			_Map.setPLine("Outline", newOutline);
		}
		else
		{
			reportMessage(T("|Normal of selected outline is not aligned with z direction of the element.|"));
		}
	}
}

//PLine that describes the shape of the foam
if( !_Map.hasPLine("Outline") )
{
	reportMessage(TN("|Insulation outline is missing|!"));
	eraseInstance();
	return;
}
PLine plInsulation = _Map.getPLine("Outline");
plInsulation.projectPointsToPlane(pnElZ, vzEl);

PlaneProfile ppInsulation(csEl);
ppInsulation.joinRing(plInsulation, _kAdd);

//Points of pline
Point3d arPtInsulation[] = plInsulation.vertexPoints(true);

Point3d arPtInsulationX[] = lnX.orderPoints(arPtInsulation);
Point3d arPtInsulationY[] = lnY.orderPoints(arPtInsulation);
//Check length of arrays
if( arPtInsulationX.length()<2 || arPtInsulationY.length()<2 )
{
	reportMessage(TN("|Insulation outline is invalid|!"));
	eraseInstance();
	return;
}

Line lnXBm(ptEl, vxEl);

Point3d ptLeft=lnXBm.closestPointTo(arPtInsulationX[0]);
Point3d ptRight=lnXBm.closestPointTo(arPtInsulationX[arPtInsulationX.length()-1]);
Point3d ptBL = ptLeft + vyEl * vyEl.dotProduct(arPtInsulationY[0] - ptLeft);
Point3d ptTR = ptRight + vyEl * vyEl.dotProduct(arPtInsulationY[arPtInsulationY.length() - 1] - ptRight);
Point3d ptCenter = (ptBL + ptTR)/2;

//Point3d zone0Bottom = el.zone(-1).ptOrg();
Point3d ptBLbottom = ptBL - vzEl * vzEl.dotProduct(ptBL - zone0Bottom);
Point3d ptTRbottom = ptTR - vzEl * vzEl.dotProduct(ptTR - zone0Bottom);

Point3d ptCenterBottom = (ptBLbottom + ptTRbottom) / 2;
ptCenterBottom.vis();

//ptCenter = ptCenterBottom;

_Pt0 = ptCenter;
_ThisInst.setAllowGripAtPt0(false);

Point3d arPtCenter[] = plInsulation.intersectPoints(Plane(ptCenter, vxEl));
arPtCenter = lnY.orderPoints(arPtCenter);
if (arPtCenter.length() == 0) 
{
	reportNotice(T("|No intersection found for foam outline.|"));
	return;
}

double dHCenter = vyEl.dotProduct(arPtCenter[arPtCenter.length() - 1] - arPtCenter[0]);

//Check if the point doesnt interfere with a flat stud
Beam verticalBeams[] = vxEl.filterBeamsPerpendicularSort(beams);

for (int i=0; i<verticalBeams.length(); i++)
{
	Beam bm = verticalBeams[i];
	Point3d ptLeftBm=bm.ptCen()-bm.vecD(vxEl)*(bm.dD(vxEl)*0.5);
	ptLeftBm=lnXBm.closestPointTo(ptLeftBm);
	Point3d ptRightBm=bm.ptCen()+bm.vecD(vxEl)*(bm.dD(vxEl)*0.5);
	ptRightBm=lnXBm.closestPointTo(ptRightBm);
	PlaneProfile ppBm(csEl);
	ppBm=bm.realBody().shadowProfile(pnElZ);
	ppBm.shrink(U(2));
	ppBm.intersectWith(ppInsulation);
}


Hatch hatchInfo(sHatchPattern,dHatchScale);
hatchInfo.setAngle(dHatchAngle);

plInsulation.vis(1);
Body bdInsulation(plInsulation, -vzEl * insulationThickness);

// Elevation view
Display dpInsulationElevation(insulationColor);
dpInsulationElevation.elemZone(el, zoneIndex, hsbLayerCharacter);
dpInsulationElevation.addViewDirection(vzEl);
dpInsulationElevation.addViewDirection(-vzEl);
dpInsulationElevation.draw(ppInsulation,hatchInfo);
// Plan view
Display dpInsulationPlan(insulationColor);
dpInsulationPlan.elemZone(el, zoneIndex, hsbLayerCharacter);
dpInsulationPlan.addViewDirection(vyEl);
dpInsulationPlan.addViewDirection(-vyEl);
PlaneProfile ppInsulationPlan(CoordSys(ptEl, vxEl, -vzEl, vyEl));
ppInsulationPlan = bdInsulation.getSlice(Plane(bdInsulation.ptCen(), vyEl));
dpInsulationPlan.draw(ppInsulationPlan,hatchInfo);
// Side view
Display dpInsulationSide(insulationColor);
dpInsulationSide.elemZone(el, zoneIndex, hsbLayerCharacter);
dpInsulationSide.addViewDirection(vxEl);
dpInsulationSide.addViewDirection(-vxEl);
PlaneProfile ppInsulationSide(CoordSys(ptEl, vzEl, vyEl, -vxEl));
ppInsulationSide = bdInsulation.getSlice(Plane(bdInsulation.ptCen(), vxEl));
dpInsulationSide.draw(ppInsulationSide,hatchInfo);
// 3D
Display dpInsulation3D(insulationColor);
dpInsulation3D.elemZone(el, zoneIndex, hsbLayerCharacter);
dpInsulation3D.addHideDirection(vxEl);
dpInsulation3D.addHideDirection(-vxEl);
dpInsulation3D.addHideDirection(vyEl);
dpInsulation3D.addHideDirection(-vyEl);
dpInsulation3D.addHideDirection(vzEl);
dpInsulation3D.addHideDirection(-vzEl);
dpInsulation3D.draw(bdInsulation);



// HSB-24576
// The TSL is providing a body
// It will write the material as materialdescription
// hsbCenterOfGravity will get the density from material
_ThisInst.setMaterialDescription(insulationMaterial);

insulationNettoWidth.set(vxEl.dotProduct(ptTR - ptBL));
if (insulationNettoWidth < U(270)) 
{
	insulationBruttoWidth.set(insulationNettoWidth + U(5));
}
else if (insulationNettoWidth > U(560)) 
{
	if (insulationNettoWidth <= U(565))
	{
		insulationBruttoWidth.set(U(570));
	}
	else
	{
		insulationBruttoWidth.set(insulationNettoWidth + U(10));
	}
}
else 
{
	insulationBruttoWidth.set(insulationNettoWidth * 1.017857);
}
insulationNettoLength.set(vyEl.dotProduct(ptTR - ptBL));
if (insulationNettoLength <= U(1200)) 
{
	insulationBruttoLength.set(insulationNettoLength + U(10));
}
else
{
	insulationBruttoLength.set(insulationNettoLength + U(20));
}

// Create a compare key.
String compareKey = insulationColor + "_" + insulationMaterial;
double sizes[] = 
{
	insulationBruttoWidth,
	insulationBruttoLength,
	insulationThickness
};
for (int s=0;s<sizes.length();s++) 
{
	double size = sizes[s];
	String sizeAsText;
	sizeAsText.formatUnit(size, 2, 0);
	compareKey += ("_" + sizeAsText);
}
setCompareKey(compareKey);

Map mapBOM;
mapBOM.setInt("Color", insulationColor);
mapBOM.setString("Material", insulationMaterial);
mapBOM.setDouble("Width", insulationBruttoWidth);
mapBOM.setDouble("NettoWidth", insulationNettoWidth);
mapBOM.setDouble("Length", insulationBruttoLength);
mapBOM.setDouble("NettoLength", insulationNettoLength);
mapBOM.setDouble("Height", insulationThickness);
mapBOM.setDouble("NettoHeight", insulationThickness);

_Map.setMap("BOM", mapBOM);







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
        <int nm="BreakPoint" vl="527" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24576: Write material as materialdescription, so that hsbCenterOfGravity can perform the weight and cog calculation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/4/2025 10:54:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to fill insulation from the top or bottom of zone 0. When the height is not the same as the height of zone 0." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/28/2023 3:26:05 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End