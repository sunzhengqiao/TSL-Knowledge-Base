#Version 8
#BeginDescription
Description
This tsl labels the beams of the element (optional) and adds marking and identification to them.
 
Insert
To insert the tsl, one or more elements can be selected. The tsl will insert an instance of itself to each selected element.
The tsl can also be attached to the element definition. If its attached to the element definition it will be executed automatically when the element is generated.











3.25 20/09/2022 Replace reportwarning with reportmessage Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 25
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl numbers beams of an element (optional) and adds marking and identification to them
/// </summary>

/// <insert>
/// To insert the tsl, one or more elements can be selected. The tsl will insert an instance of itself to each selected element.
/// The tsl can also be attached to the element definition. If its attached to the element definition it will be executed automatically when the element is generated.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.23" date="04.07.2019"></version>

/// <history>
/// AS - 1.00 - 11.04.2012 -	Pilot version
/// AS - 1.01 - 19.04.2012 -	Add marking and identification
/// AS - 1.02 - 19.04.2012 -	Assign to element
/// AS - 1.03 - 19.04.2012 -	Add comment
/// AS - 1.04 - 24.05.2012 -	Marking faceNormal corected.
/// AS - 2.00 - 23.07.2012 -	Rename tsl and make numbering optional.
/// AS - 2.01 - 28.08.2012 -	Renumber when numbering is switched on. Add option to place marking on connecting faceNormal.
/// AS - 2.02 - 30.10.2012 -	Add multiple options to beam Id
/// AS - 2.03 - 05.03.2013 -	Use "<MYPOS>" instead of posnum();
/// AS - 2.04 - 14.06.2013 - Fix translation keys.
/// AS - 2.05 - 08.07.2014 - Add option to suppress the marking text
/// AS - 2.06 - 17.07.2015 - Add option to mark supporting beams
/// AS - 2.07 - 23.11.2015 - Marker lines and text can now be on different faces.
/// AS - 2.08 - 23.11.2015 - Position identification at largest spot available.
/// AS - 2.09 - 05.04.2016 - Add filter options for male and female beams.
/// AS - 2.10 - 13.04.2016 - Add tolerance for perpendicular and parallel vector comparison for marking.
/// AS - 2.11 - 18.05.2016 - Use center of solid for marking of supporting beams. Some supporting beams are extrusion profiles with an off-center axis.
/// AS - 2.12 - 09.06.2016 - Only setPosnumBeam if needed.
/// AS - 2.13 - 22.06.2016 - Allow tsl multiple times at an element. TSL indentifier must be different for each of the instances.
/// AS - 2.14 - 11.07.2016 - Label is no longer cleared when apply numbering is disabled.
/// AS - 2.15 - 12.09.2016 - Improve insert routine
/// AS - 3.00 - 25.11.2016 - Rewrite tsl
/// AS - 3.01 - 07.12.2016 - Update filters, shrink male body before searching for intersections.
/// AS - 3.02 - 09.12.2016 - Extend filter options. 
/// AS - 3.03 - 23.12.2016 - Remove existing tsl if it is attached to the element again with the same identifier.
/// AS - 3.04 - 23.12.2016 - Calculate body transformation factors relative to beam sizes. Improve calculation of mark positions.
/// AS - 3.05 - 24.01.2017 - Do not move maleBody back and forth to find possible female beams.
/// AS - 3.06 - 24.01.2017 - Take direction of smallest dimension of male beam as bmY.
/// AS - 3.07 - 14.03.2017 - Export markerline as mark.
/// AS - 3.08 - 02.05.2017 - Add message if marking face is swapped because of tool. Find connecting face based on intersecting body.
/// AS - 3.09 - 02.05.2017 - Undo debug changes.
/// AS - 3.10 - 15.08.2017 - Comment out check to swap direction when male y is bigger then male Z
/// RP - 3.11 - 28.08.2017 - Different check on taking either maleY or maleZ as vector
/// RP - 3.12 - 28.08.2017 - Also do check in positive direction
/// RP - 3.13 - 27.09.2017 - Check for intersection done on dummybody 2mm extended...
/// RP - 3.14 - 28.09.2017 - Cean up code together with Anno and add option to not allow markerlines and add position of text
/// RP - 3.15 - 03.10.2017 - Used 4 instead of 2 mm for transformation, 2 mm was correct from an older tsl
/// RP - 3.16 - 13.11.2017 - Do check if vecy is not perpendicular to x of female beam to support kneewall beams
/// RP - 3.17 - 23.01.2018 - Override beam identification with contentformat tsl
/// RP - 3.18 - 07.02.2018 - Use planeprofile of realbody below the rafter to get the points for supporting beams
/// RP - 3.19 - 23.02.2018 - Make above change an option and use mastertosattalite to do master-slave insert
/// RP - 3.20 - 23.02.2018 - Redo the mastertosattelite with the lastinserted method.
/// RP - 3.21 - 15.03.2018 - Use ptCenSolid instead of ptCen for getting supporting beams because of extrusion profile
/// RP - 3.22 - 21.09.2018 - Add option to set reference for machining
/// RP - 3.23 - 04.07.2019 - Add a setting to export the markerlines with text as 1 tool
/// NG - 3.24 - 23.11.2021 - HSB-11473 changed marking text to a string that accepts format.
//#Versions
//3.25 20/09/2022 Replace reportwarning with reportmessage Author: Robert Pol
/// </history>

int log = false;

double tolerance = Unit(0.01, "mm");
double vectorTolerance = U(0.01);
double pointTolerance = U(0.01);

String categories[] = 
{
	T("|Filters|"),
	T("|Identification|"),
	T("|Marking|"),
	T("|Visualisation|")
};

String preferredFaces[] = {T("|Outside|"), T("|Inside|")};
int preferredFaceFlags[] = {1, -1};

String markingFaces[] = {T("|Reference side|"), T("|Connecting face|")};

String markingTexts[] = {
	T("|Position number|"),
	T("|No text|")
};

String position[] = 
{
	T("|Center|"),
	T("|Start|"),
	T("|End|")
};

String arSUCS[] = {T("|Use beam ucs|"), T("|Use element ucs|")};

int arNPosition[] = {0, -1, 1};
String yesNo[] = {T("|Yes|"), T("|No|")};
String noYes[] = {T("|No|"), T("|Yes|")};
String inExclude[] = {T("|Include|"), T("|Exclude|")};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");


PropString tslIdentifier(0, "", T("|Identifier|"));
tslIdentifier.setDescription(T("|Only one tsl instance, per identifier, can be attached to an element.|")); 

PropString preferredFaceProp(1, preferredFaces, T("|Preferred beam face|"));
preferredFaceProp.setDescription(T("|Sets the prefered marking face.|") + TN("|The face which is most aligned with the inside, or outside, of the element is used.|"));


PropString femaleFilterDefinition(11, filterDefinitions, T("|Filter definition female beams|"));
femaleFilterDefinition.setDescription(T("|Filter definition for female beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
femaleFilterDefinition.setCategory(categories[0]);

PropString femaleBeamCodesToFilter(2, "", T("|Female beam codes to filter|"));
femaleBeamCodesToFilter.setDescription(T("|Filter female beams with these beam codes.|") + TN("|NOTE|: ") + T("|These beam codes are only filtered if the filter definition for female beams is left blank!|"));
femaleBeamCodesToFilter.setCategory(categories[0]);

PropString maleFilterDefinition(12, filterDefinitions, T("|Filter definition male beams|"));
maleFilterDefinition.setDescription(T("|Filter definition for male beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
maleFilterDefinition.setCategory(categories[0]);

PropString maleBeamCodesToFilter(3, "", T("|Male beam codes to filter|"));
maleBeamCodesToFilter.setDescription(T("|Filter male beams with these beam codes.|") + TN("|NOTE|: ") + T("|These beam codes are only filtered if the filter definition for male beams is left blank!|"));
maleBeamCodesToFilter.setCategory(categories[0]);



PropString addBeamIdentificationProp(4, yesNo,T("|Add beam identification|"));
addBeamIdentificationProp.setCategory(categories[1]);
addBeamIdentificationProp.setDescription(T("|Specifies whether beam identification should be added.|"));

PropDouble dMinLengthBeamId(0, U(0), T("|Add beam ID for beams longer than|"));
dMinLengthBeamId.setReadOnly(true);
dMinLengthBeamId.setCategory(categories[1]);
dMinLengthBeamId.setDescription(T("|Sets the required beam length for the ID to be printed on the beam.|"));

PropDouble dMinLengthElNumber(1, U(250), T("|Add element number for beams longer than|"));
dMinLengthElNumber.setCategory(categories[1]);
dMinLengthElNumber.setDescription(T("|Sets the required beam length for the element number to be printed on the beam.|"));

PropDouble dMinLengthProjectNumber(2, U(500), T("|Add project number for beams longer than|"));
dMinLengthProjectNumber.setCategory(categories[1]);
dMinLengthProjectNumber.setDescription(T("|Sets the required beam length for the project number to be printed on the beam.|"));

PropString overrideBeamIdentification(5, "", T("|Override beam identification|"));
overrideBeamIdentification.setCategory(categories[1]);
overrideBeamIdentification.setDescription(T("|Sets the override for the identification.|"));

PropString positionIdentification(14, position, T("|Position Text|"));
positionIdentification.setCategory(categories[1]);
positionIdentification.setDescription(T("|Specify the position for the text.|"));

PropDouble dOffset(4, U(0), T("|Offset Text|"));
dOffset.setCategory(categories[1]);
dOffset.setDescription(T("|Specify the offset for the text.|"));

PropString sUcs(15, arSUCS, T("|UCS used for position|"));
sUcs.setCategory(categories[1]);
sUcs.setDescription(T("|Specify which ucs is used for positioning the text.|"));

PropString recalculatePositions(16, yesNo,T("|Recalculate Position|"));
recalculatePositions.setCategory(categories[1]);
recalculatePositions.setDescription(T("|Specifies whether the identification is moved when clashing with intersecting marks.|"));


PropString addBeamMarkingProp(6, yesNo, T("|Add beam marking|"));
addBeamMarkingProp.setCategory(categories[2]);
addBeamMarkingProp.setDescription(T("|Specifies whether beam marking should be added.|"));

PropString markSupportingBeamsProp(7, yesNo, T("|Mark supporting beams|"),1);
markSupportingBeamsProp.setCategory(categories[2]);
markSupportingBeamsProp.setDescription(T("|Specifies whether supporting beams should be marked on the frame.|") + TN("|The general marking should be enabled too.|"));

PropString markTouchingFaceProp(17, noYes, T("|Mark touching face|"),1);
markTouchingFaceProp.setCategory(categories[2]);
markTouchingFaceProp.setDescription(T("|Specifies whether supporting beams should be marked on the touching face or their complete width/height.|"));

PropString allowMarkerlineString(13, yesNo, T("|Allow Markerline|"),1);
allowMarkerlineString.setCategory(categories[2]);
allowMarkerlineString.setDescription(T("|Allow a markerline. A markerline can be angled, a mark cannot|"));

PropString markerLinesFace(8, markingFaces, T("|Face marking|"));
markerLinesFace.setCategory(categories[2]);
markerLinesFace.setDescription(T("|Specifies the face for the marking.|"));

PropString markingTextFace(9, markingFaces, T("|Face marking text|"));
markingTextFace.setCategory(categories[2]);
markingTextFace.setDescription(T("|Specifies the face for the marking text.|"));

//PropString sMarkingText(10, markingTexts, T("|Marking text|"));
PropString sMarkingText(10, "", T("|Marking text|"));
sMarkingText.setCategory(categories[2]);
sMarkingText.setDescription(T("|Specifies what should be used as marking text.|"));

PropString setReferenceFaceString(18, noYes, T("|Set reference face|"));
setReferenceFaceString.setCategory(categories[2]);
setReferenceFaceString.setDescription(T("|Specifies whether the reference for machining will be set to the face of the marking or identification.|"));

PropString sAddLineAndTextAsOneTool(19, noYes, T("|Add markerline and text as one tool|"), 1);
sAddLineAndTextAsOneTool.setCategory(categories[2]);
sAddLineAndTextAsOneTool.setDescription(T("|Specifies whether the the text is a seperate mark.|"));

PropInt nColor(0, 4, T("|Color|"));
nColor.setCategory(categories[3]);
nColor.setDescription(T("|Specifies the color of the visualisation symbol.|"));

PropDouble dSymbolSize(3, U(40), T("|Symbol size|"));
dSymbolSize.setCategory(categories[3]);
dSymbolSize.setDescription(T("|Specifies the size of the visualisation symbol.|"));


double faceOffsetMarkerLine = U(0);


if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssElements(T("|Select elements|"), Element());
	if (ssElements.go()) {
		Element selectedElements[] = ssElements.elementSet();
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);

		for (int e=0;e<selectedElements.length();e++) {
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
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportNotice(T("|Invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));


if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

assignToElementGroup(el, true, 0, 'T');

TslInst arTsl[] = el.tslInst();
for( int t=0;t<arTsl.length();t++ ){
	TslInst tsl = arTsl[t];
	if( tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle() && tsl.propString(T("|Identifier|")) == tslIdentifier)
		tsl.dbErase();
}

int addLineAndTextAsOneTool = noYes.find(sAddLineAndTextAsOneTool);

//Position
int preferredFace = preferredFaceFlags[preferredFaces.find(preferredFaceProp,0)];
int nIdPosition = arNPosition[position.find(positionIdentification,1)];
int nUcs = arSUCS.find(sUcs,0);
//int bForceToSmallSideOfBeam = arNYesNo[yesNo.find(sForceToSmallSideOfBeam,0)];
//Identification
int addBeamIdentification = yesNo.find(addBeamIdentificationProp,0) == 0;
//Marking
int addBeamMarking = yesNo.find(addBeamMarkingProp,0) == 0;
int markSupportingBeams = yesNo.find(markSupportingBeamsProp,0) == 0;

int markerLineFaceIndex = markingFaces.find(markerLinesFace, 0);
int areMarkerLinesOnConnectingFace = (markerLineFaceIndex == 1);

int markingTextFaceIndex = markingFaces.find(markingTextFace, 0);
int nMarkingText = markingTexts.find(sMarkingText,0);
int setReferenceFace = noYes.find(setReferenceFaceString, 0);
int allowMarkerline = yesNo.find(allowMarkerlineString, 0) == 0;
Vector3d preferredFaceNormal = vzEl * preferredFace;


Beam beams[] = el.beam();
// Store supporting beams for marking.
Beam supportingBeams[0];
Point3d ptBackFrame = el.zone(-1).coordSys().ptOrg();
Entity beamEntities[0];{ }
for (int b=0;b<beams.length();b++)
{
	beamEntities.append(beams[b]);
}


Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", femaleBeamCodesToFilter);
filterGenBeamsMap.setInt("Exclude", true);
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, femaleFilterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportNotice(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
Entity femaleBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam femaleBeams[0];
for (int e=0;e<femaleBeamEntities.length();e++) 
{
	Beam bm = (Beam)femaleBeamEntities[e];
	if (!bm.bIsValid()) continue;
	
	femaleBeams.append(bm);
	if (vzEl.dotProduct(bm.ptCenSolid() - ptBackFrame) < 0)
		supportingBeams.append(bm);
}

filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", maleBeamCodesToFilter);
filterGenBeamsMap.setInt("Exclude", true);
successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, maleFilterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportNotice(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
Entity maleBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam maleBeams[0];
for (int e=0;e<maleBeamEntities.length();e++) 
{
	Beam bm = (Beam)maleBeamEntities[e];
	if (bm.bIsValid())
		maleBeams.append(bm);
}

//  Find the marking face of the female beams. Store the face as a submap of the beam.
for( int i=0;i<femaleBeams.length();i++ ){
	Beam bmFemale = femaleBeams[i];
	
	Vector3d vyBm = bmFemale.vecY();
	Vector3d vzBm = bmFemale.vecZ();
	
	double dBmW = bmFemale.solidWidth();
	double dBmH = bmFemale.solidHeight();
	
	if( dBmW > dBmH ){
		double dTmp = dBmW;
		dBmW = dBmH;
		dBmH = dTmp;
		
		Vector3d vTmp = vyBm;
		vyBm = vzBm;
		vzBm = vTmp;
	}
	
	Vector3d faceNormal = vzBm;
	if( faceNormal.dotProduct(preferredFaceNormal) < 0 )
		faceNormal *= -1;

	// Swap face to the other side if the current face has a tool applied.	
	Point3d arPtBm[] = bmFemale.realBody().getSlice(Plane(bmFemale.ptCen(), bmFemale.vecX())).getGripVertexPoints();
	arPtBm = Line(bmFemale.ptCen(), faceNormal).orderPoints(arPtBm);	
	if( arPtBm.length() == 0 )
		continue;
	
	double dFrom;	
	Point3d ptFrom = arPtBm[0];
	for( int j=1;j<arPtBm.length();j++ ){
		Point3d ptBm = arPtBm[j];
		if( abs(faceNormal.dotProduct(ptBm - ptFrom)) > tolerance )
			break;
		
		dFrom = abs(faceNormal.crossProduct(bmFemale.vecX()).dotProduct(ptBm - ptFrom));
	}
	
	double dTo;
	Point3d ptTo = arPtBm[arPtBm.length() - 1];
	for( int j=(arPtBm.length() - 2);j>0;j-- ){
		Point3d ptBm = arPtBm[j];
		if( abs(faceNormal.dotProduct(ptBm - ptTo)) > tolerance )
			break;
		
		dTo = abs(faceNormal.crossProduct(bmFemale.vecX()).dotProduct(ptBm - ptTo));
	}
	
	if( (dFrom - dTo) > tolerance )
	{
		String thisSide = preferredFace == 1 ? T("|outside|") : T("|inside|");
		String otherSide = preferredFace == -1 ? T("|outside|") : T("|inside|");
		reportMessage(TN("|Marking is moved to the| ") + otherSide + T(" |for beam| ") + bmFemale.posnum() + T(". |It has a tool on the| ") + thisSide + ".");
		
		faceNormal *= -1;	
	}
	
	faceNormal.vis(bmFemale.ptCen(), 3);
	
	// Store faceNormal
	Map mapMarking = bmFemale.subMap("Marking");
	mapMarking.setVector3d("Face", faceNormal);
	bmFemale.setSubMap("Marking", mapMarking);
}


// Add beam marking and identification.
if( addBeamMarking || addBeamIdentification ){
	double dTextHeightMarker = 0;
	for( int i=0;i<maleBeams.length();i++ )
	{
		Beam bmMale = maleBeams[i];
		
		Vector3d maleX = bmMale.vecX();
		Line lnBmX(bmMale.ptCen(), maleX);
		
		if (addBeamMarking) 
		{
			// TODO: Find connecting beams with a transformed body of the male beam.
//			Body bdBm = bmMale.envelopeBody(false, true);
//			Point3d arPtExtremes[] = bdBm.intersectPoints(lnBmX);
//			if( arPtExtremes.length() < 2 )
//				continue;
//			Point3d ptLeft = arPtExtremes[0];
//			Point3d ptRight = arPtExtremes[arPtExtremes.length() - 1];
//			double dBdSize = U(1);
//			Body bdLeft(ptLeft, bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(), dBdSize, dBdSize, dBdSize, -1, 0, 0);
//			Body bdRight(ptRight, bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(), dBdSize, dBdSize, dBdSize, 1, 0, 0);
//			bdLeft.vis(1);
//			bdRight.vis(4);
//			
//			Beam arBmT[0];
//			for( int j=0;j<femaleBeams.length();j++ )
//			{
//				Beam bmFemale = femaleBeams[j];
//					
//				if( bmFemale.handle() == bmMale.handle() )
//					continue;
//				
//				Beam bmNotThis = bmFemale;
//				if( bmNotThis.vecX().isParallelTo(bmMale.vecX()) )
//					continue;
//				
//				Body bdBmNotThis = bmNotThis.envelopeBody(FALSE, TRUE);
//				if( bdLeft.hasIntersection(bdBmNotThis) || bdRight.hasIntersection(bdBmNotThis) )
//					arBmT.append(bmNotThis);
//			}
			
			Beam arBmT[0];
			Body bmTBodies[0];
			Body intersectingBodies[0];
			
			Vector3d connectingFaceNormals[0];
			Body maleBmBody = bmMale.realBody();
			
			Body maleBmBodyForCheck = bmMale.realBody();

			double xFactor = (bmMale.solidLength() + U(20))/bmMale.solidLength();
			double yFactor = (bmMale.solidWidth() - U(10))/bmMale.solidWidth();
			double zFactor = (bmMale.solidHeight() - U(10))/bmMale.solidHeight();
			
			CoordSys bodyTransformation;
			bodyTransformation.setToAlignCoordSys(bmMale.ptCenSolid(), bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(), bmMale.ptCenSolid(), xFactor * bmMale.vecX(), yFactor * bmMale.vecY(), zFactor * bmMale.vecZ());
			maleBmBody.transformBy(bodyTransformation);
			maleBmBody.vis(2);

			if (log)
				reportNotice("\nMale: " + bmMale.posnum());

			for (int f=0;f<femaleBeams.length();f++ )
			{
				Beam femaleBm = femaleBeams[f];
				if (log)
					reportNotice("\nPossible female: " + femaleBm.posnum());
				if (femaleBm.handle() == bmMale.handle())
					continue;
				if (abs(abs(maleX.dotProduct(femaleBm.vecX())) - 1) < vectorTolerance)
					continue;				
				
				Body femaleBmBody = femaleBm.realBody();
				femaleBmBody.vis(3);
				maleBmBody.transformBy(maleX * U(2));
				if (maleBmBody.hasIntersection(femaleBmBody))
				{
					arBmT.append(femaleBm);
					bmTBodies.append(femaleBmBody);
					Body intersectingMaleBmBody = maleBmBody;
					intersectingMaleBmBody.intersectWith(femaleBmBody);
					intersectingBodies.append(intersectingMaleBmBody);
				}
				else
				{
					maleBmBody.transformBy(-maleX * U(2));
					if (maleBmBody.hasIntersection(femaleBmBody))
					{
						arBmT.append(femaleBm);
						bmTBodies.append(femaleBmBody);
						Body intersectingMaleBmBody = maleBmBody;
						intersectingMaleBmBody.intersectWith(femaleBmBody);
						intersectingBodies.append(intersectingMaleBmBody);
					}
				}
			}
				
	
			for( int j=0;j<arBmT.length();j++ )
			{
				Beam bmT = arBmT[j];
				Body bmTBody = bmTBodies[j];
				Body intersectingBody = intersectingBodies[j];
				
				if (log)
					reportNotice("\nMale: " + bmMale.posnum() + "\tbmT: " + bmT.posnum());
				
				if( bmMale.handle() == bmT.handle() )
					continue;
				
				Vector3d possibleFaceVectors[0];
				Vector3d vy = bmT.vecY();
				Vector3d vz = bmT.vecZ();
				if (abs(maleX.dotProduct(bmT.vecY())) > vectorTolerance)
					possibleFaceVectors.append(bmT.vecY());
				if (abs(maleX.dotProduct(bmT.vecZ())) > vectorTolerance)
					possibleFaceVectors.append(bmT.vecZ());	
				
				if (possibleFaceVectors.length() == 0)
				{
					reportNotice(TN("|The connecting face could not be found for the connection between beams| ") + bmMale.posnum() + T(" |and| ") + bmT.posnum() + ".");
					continue;
				}
				
				Vector3d connectingFaceVector;// = bmT.vecD(maleX);
				double minIntersectingSizeInDirection;
				for (int v=0;v<possibleFaceVectors.length();v++)
				{
					Vector3d possibleFaceVector = possibleFaceVectors[v];
					double intersectingSizeInDirection = intersectingBody.lengthInDirection(possibleFaceVector);
					if (v==0 || intersectingSizeInDirection < minIntersectingSizeInDirection)
					{
						connectingFaceVector = possibleFaceVector;
						minIntersectingSizeInDirection = intersectingSizeInDirection;
					}
				}
				
				//Vector3d connectingFaceVector = bmT.vecD(maleX);
				Point3d ptIntersect = lnBmX.intersect(Plane(bmT.ptCenSolid(), connectingFaceVector),0);
				if( connectingFaceVector.dotProduct(ptIntersect - bmMale.ptCenSolid()) > 0)
					connectingFaceVector *= -1;
				
				Plane pnMark(bmT.ptCen() + connectingFaceVector * 0.5 * bmT.dD(connectingFaceVector), connectingFaceVector);
				
				Vector3d maleZ = bmMale.vecD(vzEl);
				Vector3d maleY = maleZ.crossProduct(maleX);
				Vector3d bmTZ = bmT.vecD(vzEl);
				
				int areBeamsPerpendicular = abs(bmMale.vecX().dotProduct(bmT.vecX())) < vectorTolerance;
				int areZVectorsAligned = abs(abs(maleZ.dotProduct(bmTZ)) - 1) < vectorTolerance;
				int areBeamsInElementXYPlane = (abs(bmMale.vecX().dotProduct(vzEl)) < vectorTolerance && abs(bmT.vecX().dotProduct(vzEl)) < vectorTolerance);
								
				int useMarkerLines = areMarkerLinesOnConnectingFace && !areZVectorsAligned;

				if (useMarkerLines) 
				{
					// Add a MarkerLine, use the smallest dimension of the male beam to find the marker locations.
					
					// Project the markerline vector to the connecting face.
					Vector3d markerLineX = maleZ;
					Vector3d markerLineY = maleY;
					if (bmMale.dD(maleZ) < bmMale.dD(maleY))
					{
						markerLineX = maleY;
						markerLineY = maleZ;
					}
					if (!areBeamsInElementXYPlane && !areBeamsPerpendicular) 
					{
						Vector3d temp = markerLineX;
						markerLineX = markerLineY;
						markerLineY = temp;
					}
					Point3d markerLinePosition1 = bmMale.ptCenSolid() - markerLineY * 0.5 * bmMale.dD(markerLineY);
					Point3d markerLinePosition2 = bmMale.ptCenSolid() + markerLineY * 0.5 * bmMale.dD(markerLineY);
					markerLinePosition1 = Line(markerLinePosition1, maleX).intersect(pnMark, U(0));
					markerLinePosition2 = Line(markerLinePosition2, maleX).intersect(pnMark, U(0));
					markerLinePosition1.vis(1);	
					markerLinePosition2.vis(3);
					
					Point3d markerLinePositions[] = 
					{
						markerLinePosition1,
						markerLinePosition2
					};
					
					// Project marker line X vector to the connecting plane.
					Point3d markerLineXProjection = bmMale.ptCenSolid() + markerLineX * U(10);
					markerLineXProjection = Line(markerLineXProjection, maleX).intersect(Plane(bmMale.ptCenSolid(), connectingFaceVector), U(0));
					markerLineX = Vector3d(markerLineXProjection - bmMale.ptCenSolid());
					markerLineX.normalize();
					
					Vector3d bmTmarkingX = bmT.vecD(markerLineX);
					
					// if markerline not allowed skip the angled marking
					if ((abs(markerLineX.dotProduct(bmTmarkingX)) < 1 - vectorTolerance && abs(markerLineX.dotProduct(bmTmarkingX)) > vectorTolerance) && !allowMarkerline)
						continue;
						
					double bmTsizeX = bmT.dD(markerLineX);
					Plane topFace(bmT.ptCenSolid() + bmTmarkingX * 0.5 * bmTsizeX, bmTmarkingX);
					Plane bottomFace(bmT.ptCenSolid() - bmTmarkingX * 0.5 * bmTsizeX, -bmTmarkingX);
					
					if (abs(bmTmarkingX.dotProduct(markerLineX)) < vectorTolerance) 
					{
						if (log)
							reportNotice(TN("|No valid location found for the markerlines of beam| ") + bmMale.posnum() + T(" |on beam| ") + bmT.posnum() + ".");
						continue;
					}
					
					for (int m=0;m<markerLinePositions.length();m++) 
					{
						Point3d markerLinePosition = markerLinePositions[m];
						Point3d markerLineStart = Line(markerLinePosition, markerLineX).intersect(topFace, faceOffsetMarkerLine);
						Point3d markerLineEnd = Line(markerLinePosition, markerLineX).intersect(bottomFace, faceOffsetMarkerLine);
						
						MarkerLine markerLine(markerLineStart, markerLineEnd, connectingFaceVector);
						markerLine.exportAsMark(true);
						bmT.addTool(markerLine);
						
					}
					if (addBeamMarking && setReferenceFace)
					{
						bmT.setReferenceFace(connectingFaceVector);	
					}
				}
				else
				{
					Map mapMarking = bmT.subMap("Marking");
					Vector3d vFaceMarkerLines = mapMarking.getVector3d("Face");
					if( markerLineFaceIndex == 1 )
						vFaceMarkerLines = connectingFaceVector;
					
					Plane pnFace(bmT.ptCenSolid() + vFaceMarkerLines * 0.5 * bmT.dD(vFaceMarkerLines), vFaceMarkerLines);
				
					Vector3d vyBm = maleY;
					vyBm.vis(bmMale.ptCen(), 1);
					
					
					// RP add dummy points for check on which vector to use
					Point3d ptMarkDummyYneg = bmMale.ptCenSolid() - vyBm * 0.5 * bmMale.dD(vyBm);
					ptMarkDummyYneg.vis(1);
					
					Point3d ptMarkDummyZneg = bmMale.ptCenSolid() - maleZ * 0.5 * bmMale.dD(maleZ);
					ptMarkDummyZneg.vis(1);
					
					Point3d ptMarkDummyYpos = bmMale.ptCenSolid() + vyBm * 0.5 * bmMale.dD(vyBm);
					ptMarkDummyYpos.vis(1);
					
					Point3d ptMarkDummyZpos = bmMale.ptCenSolid() + maleZ * 0.5 * bmMale.dD(maleZ);
					ptMarkDummyZpos.vis(1);
					
					// RP if the dotproduct in the element z vector from the centre of the male beam to the Y dummypoint is bigger then the same dotproduct for the Z dummypoint, switch y and z
					if (abs(vzEl.dotProduct(bmMale.ptCenSolid() - ptMarkDummyYneg) > abs(vzEl.dotProduct(bmMale.ptCenSolid() - ptMarkDummyZneg))) || abs(vzEl.dotProduct(bmMale.ptCenSolid() - ptMarkDummyYpos) > abs(vzEl.dotProduct(bmMale.ptCenSolid() - ptMarkDummyZpos))) || abs(vyBm.dotProduct(bmT.vecX())) <  vectorTolerance)
						vyBm = maleZ;
					
					Point3d ptMark1 = bmMale.ptCenSolid() - vyBm * 0.5 * bmMale.dD(vyBm);
					ptMark1.vis(1);
					Point3d ptMark2 = bmMale.ptCenSolid() + vyBm * 0.5 * bmMale.dD(vyBm);
					ptMark2.vis(2);
					
					if (areMarkerLinesOnConnectingFace) 
					{
						Line lnMark1(ptMark1, maleX);
						Line lnMark2(ptMark2, maleX);
						
						ptMark1 = lnMark1.intersect(pnMark,0);
						ptMark2 = lnMark2.intersect(pnMark,0);
					}
					else
					{
						Plane pnMark1(ptMark1, vyBm);
						Plane pnMark2(ptMark2, vyBm);
						Line lnMark1 = pnMark1.intersect(pnMark);
						Line lnMark2 = pnMark2.intersect(pnMark);
						
						lnMark1.vis(1);
						
						Plane pnBmT = pnFace;
						if (abs(pnFace.normal().dotProduct(lnMark1.vecX())) < vectorTolerance)
							pnBmT = Plane(bmT.ptCenSolid(), lnMark1.vecX());
						ptMark1 = lnMark1.intersect(pnBmT,0);
						ptMark2 = lnMark2.intersect(pnBmT,0);
					}

					if(markingTexts[0] == sMarkingText)
					{
						sMarkingText .set("@(PosNum)");
					}					
					else if(markingTexts[1] == sMarkingText)
					{
						sMarkingText.set("");
					}
					
					String sToolText = bmMale.formatObject(sMarkingText);					
					
					addLineAndTextAsOneTool = addLineAndTextAsOneTool && !(nMarkingText != 1 && markerLineFaceIndex != markingTextFaceIndex);
					String sMarkingText = "";
					if (! addLineAndTextAsOneTool) 
					{
						Vector3d vFaceMarkingText = mapMarking.getVector3d("Face");
						if( markingTextFaceIndex == 1 )
							vFaceMarkingText = connectingFaceVector;
						
						Mark mrkText((ptMark1 + ptMark2)/2, vFaceMarkingText, sToolText);
						mrkText.setTextHeight(dTextHeightMarker);
//						if (nMarkingText == 0)
//							mrkText.setPosnumBeam(bmMale);
						mrkText.suppressLine();
						bmT.addTool(mrkText);
						
						Mark mrkLines(ptMark1, ptMark2, vFaceMarkerLines);
						bmT.addTool(mrkLines);
					}
					else 
					{
						Mark mrk(ptMark1, ptMark2, vFaceMarkerLines, sToolText);
						mrk.setTextHeight(dTextHeightMarker);
//						if (nMarkingText == 0)
//							mrk.setPosnumBeam(bmMale);
						bmT.addTool(mrk);
					}
					
					if (addBeamMarking && setReferenceFace)
					{
						bmT.setReferenceFace(vFaceMarkerLines);	
					}
				}
			}
		}
		
		// Only apply identification to beams in the filtered list.
		if (femaleBeams.find(bmMale) == -1)
			continue;
		
		// ---------------------------------
		//       IDENTIFICATION
		// ---------------------------------
		
		if( addBeamIdentification ){
			Map mapMarking = bmMale.subMap("Marking");
			Vector3d vFaceIdentification = mapMarking.getVector3d("Face");			
			
			// ProjectNumber-ElementNumber/BmLabel
			double dBmL = bmMale.solidLength();
			String sBeamId = "<MYPOS>";
			
			String arSId[0];	
			if( dBmL >= dMinLengthProjectNumber )
				arSId.append(projectNumber());
			if( dBmL >=  dMinLengthElNumber )
				arSId.append(el.number());
			if( dBmL >= dMinLengthBeamId )
				arSId.append(sBeamId);
			
			String sId;
			for( int j=0;j<arSId.length();j++ ){
				String sSeperator = "-";
				if( j == (arSId.length() - 2) )
					sSeperator = "/";
				
				sId += arSId[j];
				if( j < (arSId.length() - 1) )
					sId += sSeperator;
			}
			
			// Implementation for Støren Treindustri. I need to make this available through properties...
			int beamTypesWithWallNumber[] = {
				_kSFTopPlate,
				_kSFBottomPlate,
				_kSFAngledTPLeft,
				_kSFAngledTPRight
			};
			if (overrideBeamIdentification != "") 
			{
				Entity entity = (Entity)bmMale;
				Map contentFormatMap;
				contentFormatMap.setString("FormatContent", overrideBeamIdentification);
				contentFormatMap.setEntity("FormatEntity", entity);
				int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
				if(!succeeded)
					reportNotice(T("|Please make sure that the tsl HSB_G-ContentFormat is loaded in the drawing|"));
				sId = contentFormatMap.getString("FormatContent");
			}
			
			Vector3d vyBm = bmMale.vecD(vzEl).crossProduct(maleX);
			vyBm.normalize();
			Plane pnBmY(bmMale.ptCen(), vyBm);
			Point3d markPositions[0];
			Beam connectingBeams[] = bmMale.filterBeamsCapsuleIntersect(femaleBeams);
			for (int c=0;c<connectingBeams.length();c++) {
				Beam connectingBeam = connectingBeams[c];
				if (abs(vyBm.dotProduct(connectingBeam.vecX())) < tolerance)
					continue;
				markPositions.append(Line(connectingBeam.ptCen(), connectingBeam.vecX()).intersect(pnBmY, 0));
			}			
			
			markPositions = lnBmX.orderPoints(markPositions);		
			
			Vector3d vxPosition = bmMale.vecX();
			if( nUcs == 1 )
			{
				if( vxPosition.dotProduct(vxEl + vyEl) < 0 )
					vxPosition *= -1;
			}
			
			Point3d idPosition;
			
			if (recalculatePositions == T("|No|"))
				idPosition = bmMale.ptCen() + vxPosition * nIdPosition * 0.5 * bmMale.solidLength();
			else
				idPosition = bmMale.ptCen();
			
			if( nIdPosition == 0 )
				idPosition += vxPosition * dOffset;
					else
				idPosition += vxPosition * -nIdPosition * dOffset;
			double maximumAvailableSpace = 0;		
			
			if (recalculatePositions == T("|Yes|"))
			{
				for (int m=0;m<(markPositions.length() - 1);m++) {
					Point3d this = markPositions[m];
					Point3d next = markPositions[m+1];
					
					double availableSpace = (next - this).length();
					if (availableSpace > maximumAvailableSpace) {
						maximumAvailableSpace = availableSpace;
						idPosition = (this + next)/2;
					}
				}
			}
			
			if( sId.length() > 0 ){
				Mark markId(idPosition, vFaceIdentification, sId);
				markId.suppressLine();
				bmMale.addTool(markId);
			}
			
			if (! addBeamMarking && setReferenceFace)
			{
				bmMale.setReferenceFace(vFaceIdentification);	
			}
		}			
	}
}
// Marking for supporting beams
double dTextHeightMarker = 0;
if (markSupportingBeams) {
	for (int i=0;i<supportingBeams.length();i++) {
		Beam bmSupporting = supportingBeams[i];
		Body bdBmSupporting = bmSupporting.envelopeBody();
		
		if (markTouchingFaceProp == T("|Yes|"))
		{
			bdBmSupporting = bmSupporting.realBody();
		}
		
		bdBmSupporting.transformBy(vzEl);
		bdBmSupporting.vis(1);
		Line zLine(el.ptOrg(), el.vecZ());
		Point3d sortedPoints[] = bdBmSupporting.allVertices();
		sortedPoints = zLine.projectPoints(sortedPoints);
		sortedPoints = zLine.orderPoints(sortedPoints);

		PlaneProfile planeProfile(el.zone(-1).coordSys());
		if (abs(abs(vzEl.dotProduct(bmSupporting.vecD(vzEl)) - 1)) < vectorTolerance)
		{
		   	// Take face
		   	planeProfile = bdBmSupporting.extractContactFaceInPlane(Plane(sortedPoints[sortedPoints.length() - 1], bmSupporting.vecD(vzEl)), U(1));
		}
		else
		{
		   	// Take slice
		   	Plane zPlane(sortedPoints[sortedPoints.length() -1] - vzEl * pointTolerance, el.vecZ());
		   	planeProfile = bdBmSupporting.getSlice(zPlane);
			zPlane.vis(3);
		}

		PLine allPlines[] = planeProfile.allRings();
		if (allPlines.length() < 0)
		{
			reportMessage(TN("|Beam not found below rafters:| ") + bmSupporting.posnum());
			continue;
		} 
		
		PLine firstPline = allPlines[0];
		Point3d allPoints[] = firstPline.vertexPoints(true);
		Line xLine(el.ptOrg(), el.vecY());
		allPoints = xLine.orderPoints(allPoints);
		Point3d firstPoint = allPoints[0];
		Point3d lastPoint = allPoints[allPoints.length() - 1];
		Vector3d vyBmSupporting = vzEl.crossProduct(bmSupporting.vecX());
		Line lnMark1(firstPoint, bmSupporting.vecX());
		Line lnMark2(lastPoint, bmSupporting.vecX());
		lnMark1.vis(1);
		lnMark2.vis(1);
		
		for (int j=0;j<femaleBeams.length();j++) {
			Beam bm = femaleBeams[j];
			if (bm.handle() == bmSupporting.handle())
				continue;
			
			Body bdBm = bm.envelopeBody();
			if (!bdBm.hasIntersection(bdBmSupporting))
				continue;
			
			// Project marker points to face plane of male beam
			Map mapMarking = bm.subMap("Marking");
			Vector3d faceNormal = mapMarking.getVector3d("Face");
			faceNormal.vis(bm.ptCen(), 1);
			
			Vector3d vyBm = vzEl.crossProduct(bm.vecX());
			if (abs(vyBm.dotProduct(bmSupporting.vecX())) < tolerance)
				continue;
			Plane pnBm(bm.ptCen(), vyBm);
			
			Point3d ptMark1 = lnMark1.intersect(pnBm,0);
			Point3d ptMark2 = lnMark2.intersect(pnBm,0);
			
			Vector3d vecBottom2Top = faceNormal.crossProduct(bm.vecX());
			vecBottom2Top.normalize();
			vecBottom2Top.vis(ptMark1);

			Vector3d vecReadUp = vxEl + vyEl;
			int nTextDir = 0; 
			if (vecReadUp.dotProduct(vecBottom2Top) < 0) 
				nTextDir = 1; // means upside down

			Mark mrk(ptMark1, ptMark2, faceNormal, bm.label());
			mrk.setTextHeight(dTextHeightMarker);
			mrk.setTextPosition(_kCenter, _kCenter, nTextDir);

			bm.addTool(mrk);
			
			if (setReferenceFace)
			{
				bm.setReferenceFace(faceNormal);	
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
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
40PHHHH`****`"BBB@`HHHH`__]E/
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Replace reportwarning with reportmessage" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="9/20/2022 9:55:45 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End