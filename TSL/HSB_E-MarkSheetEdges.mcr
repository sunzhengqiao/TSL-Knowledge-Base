#Version 8
#BeginDescription

Last modified by: Robert Pol (support.nl@hsbcad.com)
17.01.2019  -  version 1.03
Marks sheeting edges over beams
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
/// Marks sheeting edges over beams
/// </summary>

/// <insert>
/// Select element(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 13.06.2017	- Pilot version
/// RP - 1.01 -  12.10.2018	- Add option to only add horizontal edges and option for marking of outline
/// RP - 1.02 -  30.10.2018	- Make sure right vector is used and no duplicated tooling is added. Add visualisation
/// RP - 1.03 -  17.01.2019	- Make sure marking is not applied to the edge of the sheet
/// </history>
//endregion

//region basic settings
Unit (1,"mm");
double tolerance=U(0.001);
double pointTolerance=U(0.1);
double vectorTolerance = U(0.01);
int onDebug=true;
int colorOff=58;
String noYes[] = 
{
	T("|No|"),
	T("|Yes|")
};

String yesNo[] = 
{
	T("|Yes|"),
	T("|No|")
};
//endregion

//region OPM
String zoneOptions[]= {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};
PropString zone( 0, zoneOptions, T("|Assign to element zone|"), 6);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString femaleFilterDefinition(1, filterDefinitions, T("|Filter definition female beams|"));
femaleFilterDefinition.setDescription(T("|Filter definition for female beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString femaleBeamCodesToFilter(2, "", T("|Female beam codes to filter|"));
femaleBeamCodesToFilter.setDescription(T("|Filter female beams with these beam codes.|") + TN("|NOTE|: ") + T("|These beam codes are only filtered if the filter definition for female beams is left blank!|"));

PropString onlyUseHorizontalEdges(3, noYes, T("|Only use horizontal edges|"));
onlyUseHorizontalEdges.setDescription(T("|Only use horizontal edges for the marking.|"));

PropString useOutline(4, yesNo, T("|Use Outline for marking|"));
useOutline.setDescription(T("|Specify whether to use the outline of the sheetprofile.|"));

PropInt nColor(0, 4, T("|Color|"));
nColor.setDescription(T("|Specifies the color of the visualisation symbol.|"));

PropDouble dSymbolSize(0, U(40), T("|Symbol size|"));
dSymbolSize.setDescription(T("|Specifies the size of the visualisation symbol.|"));

PropString tslIdentifier(5, "", T("|Identifier|"));
tslIdentifier.setDescription(T("|Only one tsl instance, per identifier, can be attached to an element.|")); 
//endregion

//region bOnInsert
// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) 
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();

	setCatalogFromPropValues(T("_LastInserted"));
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Beam lstBeams[0];
	Entity lstEntities[1];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	//region Select element(s), clone instance per each one
	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
		selectedElements.append(ssE.elementSet());
	
	for (int e=0;e<selectedElements.length();e++)
	{
		Element selectedElement = selectedElements[e];
		if (!selectedElement.bIsValid())
			continue;
		TslInst connectedTsls[] = selectedElement.tslInst();
		for( int t=0;t<connectedTsls.length();t++ ){
			TslInst tsl = connectedTsls[t];
			if( tsl.scriptName() == scriptName() && tsl.propString(0) == tslIdentifier)
				tsl.dbErase();
		}
		lstEntities[0] = selectedElement;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	//endregion

	eraseInstance();
	return;
}
//endregion

//region set properties from master, set manualInserted=true if case
int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));
//endregion

//region Resolve properties
int zoneIndex = zoneOptions.find(zone);
if( zoneIndex > 5 )
	zoneIndex = 5 - zoneIndex;

//endregion

//region Element validation and basic info
if( _Element.length() != 1 )
{
 	eraseInstance();
 	return;
}

Element el = _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
vxEl.vis(elOrg);
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

assignToElementGroup(el, 1, zoneIndex, 'Z');
setDependencyOnEntity(el);
_Pt0=elOrg;
//endregion

Display dp(0);
if(_bOnElementConstructed || manualInserted || onDebug)
{
	// Get all sheets of zone
	Sheet sheets[]= el.sheet(zoneIndex);
	
	// Filter beams to mark
	Beam beams[] = el.beam();	
	Entity beamEntities[0];
	for (int b=0;b<beams.length();b++)
		beamEntities.append(beams[b]);
	
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", femaleBeamCodesToFilter);
	filterGenBeamsMap.setInt("Exclude", true);
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, femaleFilterDefinition, filterGenBeamsMap);
	if (!successfullyFiltered) {
		reportWarning(T("|beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	} 
	
	Entity entitiesToMark[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	Beam beamsToMark[0];
	for (int e=0;e<entitiesToMark.length();e++) 
	{
		Beam beam = (Beam)entitiesToMark[e];
		if (beam.bIsValid())
			beamsToMark.append(beam);
	}
	PlaneProfile profNetto(el.coordSys());
	Point3d sheetPoints[0];
	for (int index=0;index<sheets.length();index++) 
	{ 
		Sheet sh = sheets[index]; 
		PLine pl = sh.plEnvelope(); 
		sheetPoints.append(pl.vertexPoints(true));
	}
	Plane plane(el.zone(zoneIndex).coordSys().ptOrg(), - vzEl);
	PLine convexHull;
	convexHull.createConvexHull(plane, sheetPoints);
	profNetto.joinRing(convexHull, false);
	profNetto.shrink(- U(200));
	profNetto.shrink(U(201));
	profNetto.vis(1);
	
	// add list for linesegments to not have duplicates
	Point3d midPoints[0];
	// Do the work for every sheet
	for (int s=0;s<sheets.length();s++) 
	{ 
		Sheet sheet= sheets[s];
		if(!sheet.bIsValid())
			continue;

		PLine pline= sheet.plEnvelope();
		Point3d vertex[]= pline.vertexPoints(false);
		for (int p=0;p<vertex.length()-1;p++) 
		{ 
			Point3d pt1= vertex[p];
			//pt1.vis(1);
			Point3d pt2= vertex[p+1]; 
			//pt2.vis(2);
			Vector3d v(pt2-pt1);v.normalize();
			v.vis(elOrg);
			if (onlyUseHorizontalEdges == T("|Yes|") && abs(vxEl.dotProduct(v)) < 1 -  vectorTolerance) continue;
			Point3d midPoint = (pt2 + pt1) / 2;
			if (useOutline == T("|No|") && profNetto.pointInProfile(midPoint) == ! _kPointInProfile) continue;
			Beam beamsUnderSheet[]= v.filterBeamsPerpendicular(beamsToMark);
			for (int b=0;b<beamsUnderSheet.length();b++) 
			{ 
				Beam beam= beamsUnderSheet[b];
				Vector3d vecD = beam.vecY();
				if (abs(v.dotProduct(beam.vecZ()) > abs(v.dotProduct(beam.vecY()))))
				{
					vecD = beam.vecZ();
				}
				
				Point3d ptOut=beam.ptCen()+vecD*beam.dD(v)*.5+beam.vecX()*beam.vecX().dotProduct(pt1-beam.ptCen());// Edge 1 of beam
				Point3d ptIn=beam.ptCen()-vecD*beam.dD(v)*.5+beam.vecX()*beam.vecX().dotProduct(pt1-beam.ptCen());// Edge 2 of beam
				if(v.dotProduct(pt2-ptOut)>0 && v.dotProduct(ptOut-pt1)>0// ptOut is between pt1 and pt2
					|| v.dotProduct(pt2-ptIn)>0 && v.dotProduct(ptIn-pt1)>0)// ptIn is between pt1 and pt2
				{ 
					Point3d ptHead= beam.ptCen()+beam.vecX()*beam.dL()*.5;
					Point3d ptTail= beam.ptCen()-beam.vecX()*beam.dL()*.5;
					if(beam.vecX().dotProduct(ptHead-pt2)>0 && beam.vecX().dotProduct(pt2-ptTail)>0) // pt2 is between end and start of beam
					{
						ptOut.transformBy(vzEl * vzEl.dotProduct(el.zone(zoneIndex).coordSys().ptOrg() - ptOut));
						ptIn.transformBy(vzEl * vzEl.dotProduct(el.zone(zoneIndex).coordSys().ptOrg() - ptIn));
						//ptOut.vis(1);
						//ptIn.vis(2);
						Point3d midPoint = (ptIn + ptOut) /2;
						midPoint.vis();
						if (midPoints.find(midPoint) != -1) continue;
						
						PlaneProfile ppFaceBeam = beam.realBody().extractContactFaceInPlane(plane, U(10));
						ppFaceBeam.shrink(pointTolerance);
						ppFaceBeam.vis(s);
						if (ppFaceBeam.pointInProfile(midPoint) != _kPointInProfile) continue;
						MarkerLine mark(ptIn, ptOut,- vzEl);
						mark.exportAsMark(true);
						beam.addTool(mark);
						
//						dp.draw(LineSeg(ptIn, ptOut));
						midPoints.append(midPoint);
					}
				}
			}
		}
	}
}

// visualisation
Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, 0, 'I');

Point3d ptSymbol01 = _Pt0 - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = vxEl + vyEl;
vxTxt.normalize();
Vector3d vyTxt = vzEl.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
dpVisualisation.draw(tslIdentifier, ptSymbol01, vxTxt, vyTxt, -2.1, -1.75);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);
	dpVisualisationPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = vxEl - vzEl;
	vxTxt.normalize();
	Vector3d vyTxt = vyEl.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
	dpVisualisationPlan.draw(tslIdentifier, ptSymbol01, vxTxt, vyTxt, -2.1, -1.75);
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End