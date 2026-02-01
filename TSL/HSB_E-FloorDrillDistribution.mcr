#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
15.10.2019  -  version 1.02

Distributes the drilling on a floor element and places drills in beams and ellemmill in sheeting. Draw polyline on element in topview to place the drills on, then select the element(s) where the polyline lies on.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Distributes the drilling on a floor element and places drills in beams and ellemmill in sheeting.
/// </summary>

/// <insert>
/// Select a polyline as distribution line
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="15.10.2019"></version>

/// <history>
/// RVW - 1.00 - 02.10.2019		- Pilot version.
/// RVW - 1.01 - 04.10.2019		- Change creation of the plane profile. Create the plane profile from the Envelope of the Element.
/// RVW - 1.02 - 15.10.2019		- Add drill as beamTool to the beams.
/// </history>


Unit (1, "mm");
double dEps = U(0.1);
int iDrillFirstAndLastPoint = 1;

String yesNo[] = {T("|Yes|"), T("|No|")};
String onOff[] = { T("|On|"), T("|Off|")};

int arNYesNo[] = { _kYes, _kNo};

String arTopBottomDrill[] = {
	T("|Top|"),
	T("|Bottom|"),
	T("|Top and bottom|")
};

String arDistributionType[] = {
	T("|Left|"),
	T("|Right|"),
	T("|Center|")
};

String categories[] = {
	T("|Drilling|"),
	T("|Distribution|"),
	T("|Milling|"),
	T("|Hardware|")
};

//region General drill properties
	PropString dDrillBeam (0, yesNo, T("|Drill beams in zone 0|"), 0);
	dDrillBeam.setDescription(T("|Choose wheter to drill the beams in zone 0 YES or NO|."));
	dDrillBeam.setCategory(categories[0]);
	
	PropDouble dBeamDrillDiameter (0, U(5), T("|Beam drill diameter|"));
	dBeamDrillDiameter.setDescription(T("|Set the drill diameter to use|."));
	dBeamDrillDiameter.setCategory(categories[0]);
	
	PropDouble dDrillDepth (1, U(75), T("|Drill depth|"));
	dDrillDepth.setDescription(T("|Set the depth of the drills|."));
	dDrillDepth.setCategory(categories[0]);
	
	PropInt nZoneElemDrillElemMill (0, 2, T("|Start zone for the drill and mill|"));
	nZoneElemDrillElemMill.setDescription(T("|Set the start zone for the drilling in the beam and milling in the sheet|."));
	nZoneElemDrillElemMill.setCategory(categories[0]);
	
	PropInt nToolingIndexBeam (1, 1, T("|Machine tooling index for drilling beam|"));
	nToolingIndexBeam.setDescription(T("|Set the index for the machine tooling for the drilling in the beam|."));
	nToolingIndexBeam.setCategory(categories[0]);
//End General drill properties//endregion 

//region Distribution properties
	PropDouble dDistributionDistance (2, U(300), T("|Distribution spacing|"));
	dDistributionDistance.setDescription(T("|Set the spacing between the drills|."));
	dDistributionDistance.setCategory(categories[1]);
	
	PropDouble dOffsetFirstPoint (3, U(0), T("|Offset from first point|"));
	dOffsetFirstPoint.setDescription(T("|Set the offset distance from first point to start distribution from|."));
	dOffsetFirstPoint.setCategory(categories[1]);
	
	PropDouble dOffsetLastPoint (4, U(0), T("|Offset from last point|"));
	dOffsetLastPoint.setDescription(T("|Set the offset distance from last point to end distribution to|."));
	dOffsetLastPoint.setCategory(categories[1]);
	
	PropString sDistributionType (2, arDistributionType, T("|Distribution from|"));
	sDistributionType.setDescription(T("|Select from where the distribution should start|."));
	sDistributionType.setCategory(categories[1]);
	
	PropString sDistrEvenly(3,  yesNo, ""+T("|Distribute evenly y/n|"));
	sDistrEvenly.setDescription(T("|Distribute the drills evenly with the spacing as max. spacing|"));
	sDistrEvenly.setCategory(categories[1]);
//End Distribution properties//endregion 

//region ElemMill properties
	PropString sMillSheets (7, yesNo, T("|Mill the sheets|"), 0);
	sMillSheets.setDescription(T("|Choose wheter to mill the sheets YES or NO|."));
	sMillSheets.setCategory(categories[2]);

	PropString sIncludedSheetingZones (5, "", T("|Sheeting zones to mill|"));
	sIncludedSheetingZones.setDescription(T("|Sheeting zones to apply the milling tooling|."));
	sIncludedSheetingZones.setCategory(categories[2]);

	PropDouble dDiameterMillSheets (5, U(10), T("|Diameter sheet milling|"));
	dDiameterMillSheets.setDescription(T("|Set the diameter for the milling in the sheeting|."));
	dDiameterMillSheets.setCategory(categories[2]);
	
	PropInt nToolingIndexSheet (2, 1, T("|Machine tooling index for milling|"));
	nToolingIndexSheet.setDescription(T("|Set the index for the machine tooling for the milling|."));
	nToolingIndexSheet.setCategory(categories[2]);
//End ElemMill properties//endregion

String resetPositions = T("|Reset positions|");
addRecalcTrigger(_kContext, resetPositions);

String deleteDrill = T("|Delete drill|");
addRecalcTrigger(_kContext, deleteDrill);

String addDrill = T("|Add drill|");
addRecalcTrigger(_kContext, addDrill);

int nIncludedSheetingZones[0];
for (int s=0; s<sIncludedSheetingZones.length(); s++)
{
	String token = sIncludedSheetingZones.token(s, ";");
	if(token == "")
	{
		continue;
	}
	int zone = token.atoi();
	nIncludedSheetingZones.append(zone);
}

// order sheetingzones
for (int i = 0; i < nIncludedSheetingZones.length(); i++)
{
	for (int j = 0; j < nIncludedSheetingZones.length()-1; j++)
	{
		if (nIncludedSheetingZones[j]>nIncludedSheetingZones[j+1])
		{
			nIncludedSheetingZones.swap(j, j + 1);
		}
	}
}


//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
		
	EntPLine ssPlines = getEntPLine((TN("|Select a polyline to place drills on|")));
	if(!ssPlines.bIsValid())
	{
		reportMessage(T("|BonInsert is EntPline not valid|"));
	}
	
	EntPLine entPline = (EntPLine)ssPlines;
	
	PLine pline = entPline.getPLine();
	_Map.setPLine("Pline", pline);
	
	PrEntity ssE(TN("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	return;		
}

if (_Element.length() == -1)
{
	return;
}

Element el = _Element[0];
CoordSys elementCoordSys = el.coordSys();
Point3d elOrg = elementCoordSys.ptOrg();
Vector3d elX = elementCoordSys.vecX();
Vector3d elY = elementCoordSys.vecY();
Vector3d elZ = elementCoordSys.vecZ();
assignToElementGroup(el, true, 0, 'E');

int iDrillBeam = arNYesNo[yesNo.find(dDrillBeam, 1)];
int iMillSheets = arNYesNo[yesNo.find(sMillSheets, 1)];

if (_bOnDbCreated || _kExecuteKey == resetPositions)
{
	_PtG.setLength(0);
	Point3d distributionPositions[0];
	Point3d startPosition;
	Point3d endPosition;
	
	PLine pline = _Map.getPLine("pline");
	Point3d vertexPoints[] = pline.vertexPoints(true); 
	for (int p = 0; p < vertexPoints.length(); p++)
	{
		if (p == vertexPoints.length() -1)
		{
			break;
		}
		startPosition = vertexPoints[p];
		endPosition = vertexPoints[p + 1];
		
		Map distributionMap;
		distributionMap.setPoint3d("StartPosition", startPosition); //wordt bepaald door lijst met punten
		distributionMap.setPoint3d("EndPosition", endPosition); //wordt bepaald door lijst met punten
		distributionMap.setDouble("StartOffset", dOffsetFirstPoint); //propdouble
		distributionMap.setDouble("EndOffset", dOffsetLastPoint); //propdouble
		distributionMap.setDouble("SpacingProp", dDistributionDistance);
		distributionMap.setInt("DistributionType", arDistributionType.find(sDistributionType));
		distributionMap.setInt("DistributeEvenlyProp", yesNo.find(sDistrEvenly));
		distributionMap.setInt("UseStartAsPositionProp", iDrillFirstAndLastPoint);
		distributionMap.setInt("UseEndAsPositionProp", iDrillFirstAndLastPoint);
		
		int successfullyDistributed = TslInst().callMapIO("HSB_G-Distribution", "Distribute", distributionMap);
		if ( ! successfullyDistributed) {
			reportWarning(T("|Drills could not be distributed!|") + TN("|Make sure that the tsl| ") + "HSB_G-Distribution" + T(" |is loaded in the drawing|."));
			eraseInstance();
			return;
		}
		distributionPositions.append(distributionMap.getPoint3dArray("DistributionPositions"));
	}
	
	_PtG.append(distributionPositions);
}

reportMessage(_kNameLastChangedProp);


if (_kExecuteKey == deleteDrill)
{
	// prompt for point input to delete
	Point3d deletePoint;
	PrPoint ssP(TN("|Select point|")); 
	if (ssP.go() == _kOk)
	 { 
	 	deletePoint = (ssP.value());
	 }	
	for (int p=0;p<_PtG.length();p++)
	{ 
		PLine pCircleDrill;
		pCircleDrill.createCircle(_PtG[p], elZ, dDiameterMillSheets / 2);
		PlaneProfile ppDrill (pCircleDrill);
		int nPointInProf = ppDrill.pointInProfile(deletePoint);
		if (nPointInProf == 0)
		{
			_PtG.removeAt(p);
		}
	}
}

if (_kExecuteKey == addDrill)
{
	// prompt for point input to add
	Point3d newPoint;
	PrPoint ssP(TN("|Select point|")); 
	if (ssP.go() == _kOk)
	 {
	 	newPoint = (ssP.value());
		_PtG.append(newPoint);
	 }		
}

// get the element plane profiles
PlaneProfile elPlaneProfiles[0];
for (int e = 0; e < _Element.length(); e++)
{
	Element elementP = _Element[e];
//	PlaneProfile pPElement = elementP.profBrutto(0);
	
	PLine envelopePline = elementP.plEnvelope();
	PlaneProfile ppEnvelope(envelopePline);
	elPlaneProfiles.append(ppEnvelope);	
}

for (int dp = 0; dp < _PtG.length(); dp++)
{
	Point3d distributionPosition = _PtG[dp];
	Sheet intersectingSheets[0];
	elementCoordSys.vis(1);
	
	// check via the planeprofile of the elements to which element the drill belongs to
	for (int p=0;p<elPlaneProfiles.length();p++) 
	{ 
		PlaneProfile elPlaneProfile = elPlaneProfiles[p]; 
		elPlaneProfile.vis(3);
		 if (elPlaneProfile.pointInProfile(distributionPosition) != _kPointInProfile) continue;
		Element el = _Element[p];

		// check if the positive zones have sheeting, if so put that zone in array "arZonePlus"
		int arZonePlus[0];
		int iPlus[] = { 1, 2, 3, 4, 5};
		for (int z = 0; z < iPlus.length(); z ++)
		{
			int pZone = iPlus[z];
			if (el.sheet(pZone).length() > 0)
			{
				arZonePlus.append(pZone);
			}
		}
		// check if the negative zones have sheeting, if so put that zone in array "arZoneMin"
		int arZoneMin[0];
		int iMin[] = { - 1, - 2, - 3, - 4, - 5};
		for (int s = 0; s < iMin.length(); s++)
		{
			int mZone = iMin[s];
			if (el.sheet(mZone).length() > 0)
			{
				arZoneMin.append(mZone);
			}
		}
		
		// Set the elemmill start point and the depth from the present zones (first and last) if the user did not choose specific zones for the elemmill.
		int dBottomMilling;
		if (sIncludedSheetingZones == "")
		{
			nZoneElemDrillElemMill == arZonePlus.length()-1;
			dBottomMilling = arZonePlus[0];
		}
		// If the user did choose specific zones for the elemmill make the first zone (seen from 0) the bottompoint/depth for the elemmill.
		else
		{
			dBottomMilling = nIncludedSheetingZones[0];
		}
		
		
		Point3d pTopSheet = distributionPosition + el.vecZ() * el.vecZ().dotProduct(el.zone(nZoneElemDrillElemMill + 1).coordSys().ptOrg() - distributionPosition);
		PLine pMillingCircle;
		// Create circle for the sheet milling and define the length
		pMillingCircle.createCircle(pTopSheet,  el.vecZ(), dDiameterMillSheets/2);
		
		double millingDepth = abs(el.vecZ().dotProduct(pTopSheet - el.zone(dBottomMilling).coordSys().ptOrg())) + U(.1);
		
		Sheet elSheets[0];
		if (sIncludedSheetingZones == "")
		{
			elSheets = el.sheet();
		}
		else
		{
			for (int n = 0; n<nIncludedSheetingZones.length(); n++)
			{
				int zone = nIncludedSheetingZones[n];
				elSheets.append(el.sheet(zone));
			}
		}
		
		Beam elBeam[] = el.beam();
		GenBeam elGenBeams[] = el.genBeam();
		
		Display dP(1);
		Point3d pStartPlineDrill;
		Point3d pEndPlineDrill;
		pStartPlineDrill = pTopSheet;
		pEndPlineDrill = pStartPlineDrill - elZ * (millingDepth);
		PLine dCenterLine (pStartPlineDrill, pEndPlineDrill);
		dP.draw(dCenterLine);
		
		if (iMillSheets)
		{				
		ElemMill elemMill (nZoneElemDrillElemMill, pMillingCircle, millingDepth, nToolingIndexSheet, _kLeft, _kTurnAgainstCourse, _kNo);
		el.addTool(elemMill);
		
		// Check the sheetings that intersect with the sheeting mill
		Body sheetCut(pMillingCircle, - el.vecZ() * millingDepth, 1);
		SolidSubtract sheetSubtract(sheetCut);
		sheetSubtract.addMeToGenBeamsIntersect(elSheets);
		}
	
		if (iDrillBeam)
		{
			ElemDrill elemDrill (nZoneElemDrillElemMill, pTopSheet, - el.vecZ(), dDrillDepth, dBeamDrillDiameter, nToolingIndexBeam);
			el.addTool(elemDrill);
			
			// Create solidSubstract for the beamDrill
			Point3d endDrill = pTopSheet - (el.vecZ() * dDrillDepth);
			Body bBeamDrill (pTopSheet, endDrill, dBeamDrillDiameter / 2);
			SolidSubtract beamDrilling (bBeamDrill);
			
			Drill beamDrill (pTopSheet, endDrill, 0.5 * dBeamDrillDiameter);
			for (int index4=0;index4<elBeam.length();index4++) 
			{
				Beam beam = elBeam[index4];
				Quader beamQuader = beam.quader();
				beamQuader.vis();
				Body beamBody = beamQuader;
				
				if (bBeamDrill.hasIntersection(beamBody))
				{
					beam.addTool(beamDrill, _kStretchOnInsert);
				}
			
			}//next index4
			
			beamDrilling.addMeToGenBeamsIntersect(elBeam);
		}
		break;
	}
}

// make sure the hardware is updated
if (_bOnDbCreated)
	setExecutionLoops(2);




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