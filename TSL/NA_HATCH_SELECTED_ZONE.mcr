#Version 8
#BeginDescription
#Versions
V1.0 2/11/2024 Adproperty to blend areas which are on top of another


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
_ThisInst.setAllowGripAtPt0(false);
setMarbleDiameter(4);

//region Drawing model data
//--------------- <Drawing model data> --- start
//---------------

String[] getPainterDefinitionNamesOfType(String inTypeName) {
	String painterDefinitionNamesFiltered[0];
	PainterDefinition painterDefinitionsAll[] = PainterDefinition().getAllEntries();
	for (int i=0; i<painterDefinitionsAll.length(); i++) {
		PainterDefinition& thisPainterDefinition = painterDefinitionsAll[i];
		String thisTypeName = thisPainterDefinition.type();
		if (thisTypeName == inTypeName) {
			painterDefinitionNamesFiltered.append(thisPainterDefinition.name());
		}
	}
	return painterDefinitionNamesFiltered.sorted();
}

String genbeamFilters[] = getPainterDefinitionNamesOfType("GenBeam");


//---------------
//--------------- <Drawing model data> --- end
//endregion

//region OPM properties
//--------------- <OPM properties> --- start
//---------------

String genbeamCategory = "Beams/Sheets to hatch";
String filtersToUse[] = { "None"};
filtersToUse.append(genbeamFilters);
PropString userIncludeFilter(0, filtersToUse, "Include filter", 0);
String description_enUS = "Painter definition of type GenBeam \nAddition filter applied to get a subset of beams/sheets at selected zone "
			 + "\nIf set to None will not apply inclusion(this) filter";
userIncludeFilter.setDescription(description_enUS);
userIncludeFilter.setCategory(genbeamCategory);

PropString userExcludeFilter(1, filtersToUse, "Exclude filter", 0);
description_enUS = "Painter definition of type GenBeam"
			 + "\nSubtraction filter(painter definition) applied to get a subset of dimensioned beams/sheets at selected zone"
			 + "\nIf set to None will not apply exclusion(this) filter"
			 + "\nIf both filters are not None it will get beams/sheets which are at specified zone and sutisfy conditions of include(above) filter,"
			 + "\nthen it will remove genbeams which satisfy exclude(this) fiter";
userExcludeFilter.setDescription(description_enUS);
userExcludeFilter.setCategory(genbeamCategory);

description_enUS = "Zone to which dimensioned beams/sheets belong to:"
			+ "\n0 zone inside element container";
int zonesToUse[] = { 0};
for (int i = 1; i <= 2; i++) {
	description_enUS += "\n";
	for (int k = 1; k <= 5; k++) {
		int iValue = (i == 1 ? 1 : - 1) * k;
		zonesToUse.append(iValue);
		description_enUS += iValue + (k < 5 ? ", " : " ");
	}
	description_enUS += "zones at " + (i == 1 ? "front" : "back") + " of wall container or at " + (i == 1 ? "top" : "back") + " of floor/roof container";
}
PropInt userZone(0, zonesToUse, "Zone", 0);
userZone.setDescription(description_enUS);
userZone.setCategory(genbeamCategory);

String hatchingCategory = "Hatching";
int iDefault = _HatchPatterns.find("ANSI31");
PropString userHatchPattern(2, _HatchPatterns, "Hatch pattern", iDefault);
description_enUS = "If set to SOLID will fill selected beams/sheets with selected colour and transparency.";
userHatchPattern.setDescription(description_enUS);
userHatchPattern.setCategory(hatchingCategory);

PropDouble userHatchScale(0, 1, "Hatch scale");
description_enUS = "Scale of hatch pattern in paper space";
userHatchScale.setFormat(_kNoUnit);
userHatchScale.setDescription(description_enUS);
userHatchScale.setCategory(hatchingCategory);

PropDouble userHatchAngle(1, 0, "Hatch angle");
description_enUS = "Angle of hatch pattern in degrees";
userHatchAngle.setFormat(_kAngle);
userHatchAngle.setDescription(description_enUS);
userHatchAngle.setCategory(hatchingCategory);

PropInt userHatchColour(1, - 1, "Hatch colour");
description_enUS = "Colour of hatch pattern. \nIf set to -1 will use colour of this TSL instance";
userHatchColour.setDescription(description_enUS);
userHatchColour.setCategory(hatchingCategory);

PropInt userHatchTransparency(2, 60, "Hatch transparency");
description_enUS = "If hatch is set to SOLID will use this transparency value.";
userHatchTransparency.setDescription(description_enUS);
userHatchTransparency.setCategory(hatchingCategory);

String yes_no[] = { "Yes", "No"};
PropString userMergeSuperImposed(3, yes_no, "Merge superimposed", 1);
description_enUS = "If set to Yes, will merge areas which are completly on top of each other"; 
userMergeSuperImposed.setDescription(description_enUS);
userMergeSuperImposed.setCategory(hatchingCategory);

//---------------
//--------------- <OPM properties> --- end
//endregion

//region Insert routine
//--------------- <Insert routine> --- start
//---------------

if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	_Viewport.append(getViewport("\n" + "Select element viewport"));
	showDialog();
}

//---------------
//--------------- <Insert routine> --- end
//endregion

//region Validation routine
//--------------- <Validation routine> --- start
//---------------

if (_Viewport.length()<1) {
	reportMessage("\n"+scriptName()+": "+"No valid viewport. Erasing this instance.");
	eraseInstance();
	return;
}

Viewport thisViewPort = _Viewport.first();
Element thisElement = thisViewPort.element();
if (!thisElement.bIsValid() && !_bOnInsert) {
	reportMessage("\n"+"No valid element in viewport");
	return;
}

//---------------
//--------------- <Validation routine> --- end
//endregion

//region Coordinate system data
//--------------- <Coordinate system data> --- start
//---------------

CoordSys modelToPaperTransformation = thisViewPort.coordSys();
CoordSys paperToModelTransformation = modelToPaperTransformation;
paperToModelTransformation.invert();
double viewportScale = paperToModelTransformation.scale();
Vector3d layoutXInModel = _XW;
layoutXInModel.transformBy(paperToModelTransformation);
layoutXInModel.normalize();
Vector3d layoutYInModel = _YW;
layoutYInModel.transformBy(paperToModelTransformation);
layoutYInModel.normalize();
Vector3d layoutZInModel = _ZW;
layoutZInModel.transformBy(paperToModelTransformation);
layoutZInModel.normalize();
 
int drawingIsMetric = U(1, "mm") == 1;
double drawingUnitsToMM(double distance)
{
	double convertionFactor = drawingIsMetric ? 1 : 25.4;
	return distance * convertionFactor;
}
double drawingUnitsToIN(double distance)
{
	double convertionFactor = drawingIsMetric ? 1/25.4 : 1;
	return distance * convertionFactor;
}
double mmToDrawingUnits(double distance)
{
	double convertionFactor = drawingIsMetric ? 1 : 1/25.4;
	return distance * convertionFactor;
}
double inToDrawingUnits(double distance)
{
	double convertionFactor = drawingIsMetric ? 25.4 : 1;
	return distance * convertionFactor;
}

//---------------
//--------------- <Coordinate system data> --- end
//endregion

//region Genbeam functions
//--------------- <Genbeam functions> --- start
//---------------

//function to get genbeams filtered by zone and filters
GenBeam[] getGenbeamsFiltered(int& inSelectedZoneIndex, String& inIncludeFilter, String& inExcludeFilter)
{
	GenBeam outGenbeamFiltered[0];
	if (inSelectedZoneIndex>=0) {
		outGenbeamFiltered.append(thisElement.genBeam(inSelectedZoneIndex));
	}
	else {
		outGenbeamFiltered.append(thisElement.genBeam());
	}

	if (inIncludeFilter != "None" && outGenbeamFiltered.length() >= 1) {
		PainterDefinition includePainterDefinition(inIncludeFilter);
		GenBeam genbeamsIncluded[] = includePainterDefinition.filterAcceptedEntities(outGenbeamFiltered);
		outGenbeamFiltered = genbeamsIncluded;
	}
	if (inExcludeFilter != "None" && outGenbeamFiltered.length() >= 1) {
		PainterDefinition excludePainterDefinition(inExcludeFilter);
		GenBeam genbeamsExclude[] = excludePainterDefinition.filterAcceptedEntities(outGenbeamFiltered);
		if (genbeamsExclude.length() >= 1) {
			for (int i=0; i<genbeamsExclude.length(); i++) {
				GenBeam& thisGenbeam = genbeamsExclude[i];
				int iFindGenbeam = outGenbeamFiltered.find(thisGenbeam);
				if (iFindGenbeam >= 0 && outGenbeamFiltered.length() >= 1) {
					outGenbeamFiltered.removeAt(iFindGenbeam);
				}
			}
		}
	}
	return outGenbeamFiltered;
}

//function to get most aligning vector including length vector from genbeam
Vector3d getAlignedVector(GenBeam& inGenbeam, Vector3d inReferenceVector, int& outIsAlignedWithLength) {
	Vector3d outVector;
	Vector3d genbeamVectors[] = { inGenbeam.vecX(), inGenbeam.vecY(), inGenbeam.vecZ()};
	double minAngle = 180;
	for (int i=0; i<genbeamVectors.length(); i++) {
		Vector3d& thisVector = genbeamVectors[i];
		double thisAngle = thisVector.angleTo(inReferenceVector);
		if (thisAngle > 90) thisAngle = 180 - thisAngle;
		if (thisAngle < minAngle) {
			outVector = thisVector;
			minAngle = thisAngle;
		}
	}
	if (outVector == genbeamVectors[0]) {
		outIsAlignedWithLength = true;	
	}
	if (outVector.dotProduct(inReferenceVector) < 0) {
		outVector *= -1;	
	}
	
	return outVector;
}

//function to get genbeam outline for this viewport
PlaneProfile getGenbeamOutline(GenBeam& inGenbeam)
{
	int isAlignedToLength = false;
	Vector3d thisNormal = getAlignedVector(inGenbeam, -layoutZInModel, isAlignedToLength);
	Point3d extremes[] = inGenbeam.realBody().extremeVertices(thisNormal);
	Plane contactPlane(extremes.last(), thisNormal);
	double distToCen = (contactPlane.ptOrg()-inGenbeam.ptCen()).dotProduct(thisNormal);
	PlaneProfile outOutline = inGenbeam.realBody().extractContactFaceInPlane(contactPlane, distToCen);
	if (!outOutline.bIsValid() && outOutline.area() < mmToDrawingUnits(1)^2) {
		AnalysedTool thisAtools[] = inGenbeam.analysedTools();
		AnalysedCut thisAcuts[] = AnalysedCut().filterToolsOfToolType(thisAtools);
		int useHip = ! isAlignedToLength;
		for (int i=thisAcuts.length()-1; i>=0; i--) {
			AnalysedCut& thisAcut = thisAcuts[i];
			int isHip = thisAcut.toolSubType() == _kACHip;
			if ((useHip && !isHip) || (!useHip && isHip)) {
				thisAcuts.removeAt(i);
			}
		}
		int thisIndexClosest = AnalysedCut().findClosest(thisAcuts, extremes.last());
		if (thisIndexClosest >= 0) {
			AnalysedCut closestAcut = thisAcuts[thisIndexClosest];
			Vector3d thisNormal = closestAcut.normal();
			if (thisNormal.dotProduct(layoutZInModel) > 0) {
				thisNormal *= -1;	
			}
			contactPlane = Plane(extremes.last(), thisNormal);
			distToCen = LineSeg(inGenbeam.ptCen(), contactPlane.closestPointTo(inGenbeam.ptCen())).length();
			outOutline = inGenbeam.realBody().extractContactFaceInPlane(contactPlane, distToCen);
		}
	}
	outOutline.removeAllOpeningRings();
	
	return outOutline;
}

//function to get genbeam outlines for this viewport
PlaneProfile[] getGenbeamOutlines(GenBeam& inGenbeams[])
{
	PlaneProfile outOutlines[0];
	for (int i=0; i<inGenbeams.length(); i++) {
		GenBeam& thisGenbeam = inGenbeams[i];
		PlaneProfile thisOutline = getGenbeamOutline(thisGenbeam);
		outOutlines.append(thisOutline);
	}
	
	return outOutlines;
}

//---------------
//--------------- <Genbeam functions> --- end
//endregion

GenBeam genbeamsToHatch[] = getGenbeamsFiltered(userZone, userIncludeFilter, userExcludeFilter);
PlaneProfile outlinesToHatch[] = getGenbeamOutlines(genbeamsToHatch);
PlaneProfile merged[0];
Display dpHatch(userHatchColour);
for (int i=0; i<genbeamsToHatch.length(); i++) {
	GenBeam& thisGenbeam = genbeamsToHatch[i];
	PlaneProfile thisOutline = outlinesToHatch[i];	
	if (merged.find(thisOutline) >= 0) continue;
	if (userMergeSuperImposed == yes_no[0]) 
	{
		for (int m=i+1; m<outlinesToHatch.length(); m++) {
			PlaneProfile& otherOutline = outlinesToHatch[m];
			PlaneProfile intersectionOutline(otherOutline);
			if (!intersectionOutline.intersectWith(thisOutline)) continue;
			//check if intersection area is completly inside thisOutline
			if (intersectionOutline.area() < mmToDrawingUnits(1)^2) continue;
			intersectionOutline.shrink(mmToDrawingUnits(1));
			Point3d intersectionVertices[] = intersectionOutline.getGripVertexPoints();
			int isInside = true;
			for (int k=0; k<intersectionVertices.length(); k++) {
				Point3d& thisPoint = intersectionVertices[k];
				if (thisOutline.pointInProfile(thisPoint) == _kPointOutsideProfile) {
					isInside = false;
					break;
				}
			}
			if (isInside) {
				thisOutline.unionWith(otherOutline);
				merged.append(otherOutline);
			}
		}
	}
	PlaneProfile outlineToDraw(thisOutline);
	outlineToDraw.transformBy(modelToPaperTransformation);
	dpHatch.draw(outlineToDraw);
	if (userHatchPattern == "SOLID") {
		dpHatch.draw(outlineToDraw, _kDrawFilled, userHatchTransparency);
	}
	else {
		Hatch thisHatch(userHatchPattern, userHatchScale);
		thisHatch.setAngle(userHatchAngle);			
		dpHatch.draw(outlineToDraw, thisHatch);
	}
}
#End
#BeginThumbnail



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Adproperty to blend areas which are on top of another" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/11/2024 8:00:03 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End