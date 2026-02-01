#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
11.11.2019  -  version 1.06
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl splits a set of beams into predefined lengths.
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.06" date="11.11.2019"></version>

/// <history>
/// AS - 1.00 - 10.07.2015 -	Pilot version
/// AS - 1.01 - 13.07.2015 -	Split the new beam if beam has to split multiple times.
/// AS - 1.02 - 21.08.2015 -	Show properties when tsl is inserted. Add start of implementation of angled cuts.
/// AS - 1.03 - 26.08.2015 -	Angled cuts are now supported.
/// AS - 1.04 - 28.08.2015 - Move single mark off-center for _X0 of marking tsl.
/// AS - 1.05 - 18.09.2015 - Add new beams to wall plate tsl.
/// RP - 1.06 - 11.11.2019 - Do not set the format for the angle
/// </history>

String categories[] = {
	T("|Beam lengths|"),
	T("|Split parameters|")
};

String scriptNameWallplateTsl = "BK_G-Wallplates";
String scriptNameDimensionTsl = "HSB_D-Aligned";
String scriptNameSingleMark = "HSB_T-SingleMark";

PropDouble firstSplitLength(0, U(2700), T("|First split at|"));
firstSplitLength.setCategory(categories[0]);
firstSplitLength.setDescription(T("|Sets the location for the first split.|"));
PropDouble defaultSplitLength(1, U(5400), T("|Default split length|"));
defaultSplitLength.setCategory(categories[0]);
defaultSplitLength.setDescription(T("|Sets the default split length.|"));
PropDouble minimumSplitLength(2, U(600), T("|Minimum split length|"));
minimumSplitLength.setCategory(categories[0]);
minimumSplitLength.setDescription(T("|Sets the minimum allowed split length.|"));

PropDouble splitGap(3, U(0), T("|Gap|"));
splitGap.setCategory(categories[1]);
splitGap.setDescription(T("|Sets the gap to use at the split locations.|"));
PropDouble splitAngle(4, 0, T("|Angle|"));
splitAngle.setCategory(categories[1]);
splitAngle.setDescription(T("|Sets the angle of the splits.|"));
//splitAngle.setFormat(_kAngle);

String yesNo[] = {T("|Yes|"), T("|No|")};
PropString propApplySingleMark(0, yesNo, T("|Apply single mark|"));


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_T-OptimizeBeams");
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
		setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("_LastInserted"));
	
	PrEntity ssBeams(T("|Select beams in spit sequence|"), Beam());
	if (ssBeams.go())
		_Beam.append(ssBeams.beamSet());
	
	return;
}

if (_Beam.length() == 0) {
	reportWarning(T("|No beams selected|"));
	eraseInstance();
	return;
}

int applySingleMark = (yesNo.find(propApplySingleMark,0) == 0);

// A list of dimension tsls that have to be updated when beams are splitted.
TslInst dimensionTsls[0];
TslInst wallplateTsls[0];
Entity allTsls[] = Group().collectEntities(true, TslInst(), _kModelSpace);

for (int t=0;t<allTsls.length();t++) {
	TslInst tsl = (TslInst)allTsls[t];
	if (!tsl.bIsValid())
		continue;
	
	if (tsl.scriptName() == 	scriptNameDimensionTsl)
		dimensionTsls.append(tsl);
	
	if (tsl.scriptName() == scriptNameWallplateTsl)
		wallplateTsls.append(tsl);
}

double firstSplitAt = firstSplitLength;
for (int b=0;b<_Beam.length();b++) {
	Beam bm = _Beam[b];
	
	// Find dimension tsls for this beam.
	TslInst dimensionTslsForThisBeam[0];
	for (int d=0;d<dimensionTsls.length();d++) {
		TslInst dimensionTsl = dimensionTsls[d];
		Map mapTsl = dimensionTsl.map().getMap("DimensionObjects");
		for (int e=0;e<mapTsl.length();e++) {
			if (!(mapTsl.hasEntity(e) && mapTsl.keyAt(e) == "Entity"))
				continue;
			Entity ent = mapTsl.getEntity(e);
			
			if (ent.handle() == bm.handle()) {
				dimensionTslsForThisBeam.append(dimensionTsl);
				break;
			}			
		}
	}
	
	// ...and wallplate tsls for this beam.
	TslInst wallplateTslsForThisBeam[0];
	for (int w=0;w<wallplateTsls.length();w++) {
		TslInst wallplateTsl = wallplateTsls[w];
		Beam wallplates[] = wallplateTsl.beam();
		if (wallplates.find(bm) != -1) {
			wallplateTslsForThisBeam.append(wallplateTsl);
			break;
		}
	}
	
	//reportNotice(TN("|First split at|: ") + firstSplitAt);
	
	Beam beamsToMark[0];
	
	// Split the beam	
	Beam newBeams[0];
	double beamLength = bm.solidLength();
	Point3d startPointBeam = bm.ptCenSolid() - bm.vecX() * 0.5 * beamLength;
	Point3d endPointBeam = bm.ptCenSolid() + bm.vecX() * 0.5 * beamLength;
	
	Vector3d cutNormalStart = -bm.vecX().rotateBy(splitAngle, _ZW);
	Vector3d cutNormalEnd = -cutNormalStart;
	double correctionForAngledCut = 0;
	Vector3d vyBm = _ZW.crossProduct(bm.vecX());
	vyBm.normalize();
	if (splitAngle != 0)
		correctionForAngledCut = abs(tan(splitAngle) * 0.5 * bm.dD(vyBm));
	
	Point3d startPosition = startPointBeam;
	Point3d splitFrom;
	Point3d splitTo;
	if (beamLength > (firstSplitAt + minimumSplitLength - 2 * correctionForAngledCut)) {
		splitTo = startPosition + bm.vecX() * (firstSplitAt - correctionForAngledCut);
		splitFrom = splitTo + bm.vecX() * splitGap;
	
		Beam newBeam = bm.dbSplit(splitFrom, splitTo);
		beamsToMark.append(bm);
		
		if (splitAngle != 0) {
			Cut endCut(splitTo, cutNormalEnd);
			bm.addToolStatic(endCut, _kStretchOnInsert);
			Cut startCut(splitFrom, cutNormalStart);
			newBeam.addToolStatic(startCut, _kStretchOnInsert);
		}
		newBeams.append(newBeam);
		bm = newBeam;
		
		beamLength = bm.solidLength();
				
		int numberOfLoops = 0;
		while (beamLength > defaultSplitLength) {
			if (beamLength > (defaultSplitLength + minimumSplitLength + splitGap - 2 * correctionForAngledCut)) {
				splitTo += bm.vecX() * (defaultSplitLength + splitGap - 2 * correctionForAngledCut);
				splitFrom = splitTo + bm.vecX() * splitGap;
			
				newBeam = bm.dbSplit(splitFrom, splitTo);
				beamsToMark.append(bm);
				
				if (splitAngle != 0) {
					Cut endCut(splitTo, cutNormalEnd);
					bm.addToolStatic(endCut, _kStretchOnInsert);
					Cut startCut(splitFrom, cutNormalStart);
					newBeam.addToolStatic(startCut, _kStretchOnInsert);
				}

				newBeams.append(newBeam);
				bm = newBeam;
			}
			else {
				splitTo = endPointBeam - bm.vecX() * (minimumSplitLength + splitGap - correctionForAngledCut);
				splitFrom = splitTo + bm.vecX() * splitGap;
			
				newBeam = bm.dbSplit(splitFrom, splitTo);
				beamsToMark.append(bm);
				
				if (splitAngle != 0) {
					Cut endCut(splitTo, cutNormalEnd);
					bm.addToolStatic(endCut, _kStretchOnInsert);
					Cut startCut(splitFrom, cutNormalStart);
					newBeam.addToolStatic(startCut, _kStretchOnInsert);
				}

				newBeams.append(newBeam);
				bm = newBeam;
			}
			
			// Update the beam length.
			beamLength = bm.solidLength();
						
			// Make sure we don't end up in an infinte loop.
			numberOfLoops++;
			if (numberOfLoops > 100)
				break;
		}
		
		// Set the length of the next split.
		firstSplitAt = defaultSplitLength - beamLength;
	}
	else if (beamLength > (2 * minimumSplitLength + splitGap - 2 * correctionForAngledCut)) {
		splitTo = endPointBeam - bm.vecX() * (minimumSplitLength + splitGap - correctionForAngledCut);
		splitFrom = splitTo + bm.vecX() * splitGap;
	
		Beam newBeam = bm.dbSplit(splitFrom, splitTo);
		beamsToMark.append(bm);
		
		if (splitAngle != 0) {
			Cut endCut(splitTo, cutNormalEnd);
			bm.addToolStatic(endCut, _kStretchOnInsert);
			Cut startCut(splitFrom, cutNormalStart);
			newBeam.addToolStatic(startCut, _kStretchOnInsert);
		}

		newBeams.append(newBeam);
		bm = newBeam;
		
		firstSplitAt = defaultSplitLength - minimumSplitLength;
	}
	else {
		// Do not split this beam
		firstSplitAt = defaultSplitLength - beamLength;
	}
	beamsToMark.append(bm);
	
	
	for (int d=0;d<dimensionTslsForThisBeam.length();d++) {
		TslInst dimensionTsl = dimensionTslsForThisBeam[d];
		Map mapTsl = dimensionTsl.map();
		Map mapDimensionObjects = mapTsl.getMap("DimensionObjects");
		for (int n=0;n<newBeams.length();n++) {
			Beam newBeam = newBeams[n];
			mapDimensionObjects.appendEntity("Entity", newBeam);
		}
		mapTsl.setMap("DimensionObjects", mapDimensionObjects);
		dimensionTsl.setMap(mapTsl);
		dimensionTsl.recalc();
	}
	
	for (int w=0;w<wallplateTslsForThisBeam.length();w++) {
		TslInst wallplateTsl = wallplateTslsForThisBeam[w];
		Map mapTsl = wallplateTsl.map();
		mapTsl.setInt("AddBeams", true);
		Map mapWithBeamsToAdd;
		for (int n=0;n<newBeams.length();n++) {
			Beam newBeam = newBeams[n];
			mapWithBeamsToAdd.appendEntity("Beam", newBeam);
		}
		mapTsl.setMap("BeamsToAdd", mapWithBeamsToAdd);
		wallplateTsl.setMap(mapTsl);
		wallplateTsl.recalc();
	}
	
	if (applySingleMark) {
		String strScriptName = scriptNameSingleMark;
		Beam lstBeams[1];
		Element lstElements[0];
		
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		
		for (int n=0;n<beamsToMark.length();n++) {
			Beam beamsToMark = beamsToMark[n];
			
			lstBeams[0] = beamsToMark;
			lstPoints[0] = beamsToMark.ptCenSolid() - beamsToMark.vecX() * U(10);
			
			Vector3d vecUcsX(beamsToMark.vecX());
			Vector3d vecUcsY(beamsToMark.vecY());
			
			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			tslNew.assignToGroups(beamsToMark, 'T');
		}
	}
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End