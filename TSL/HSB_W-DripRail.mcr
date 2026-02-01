#Version 8
#BeginDescription
Last modified by: Nils Gregor (nils.gregor@hsbcad.com)
30jul2020  -  version 1.03
Last modified by: Nils Gregor (nils.gregor@hsbcad.com)
03jul2020  -  version 1.02
Last modified by: Nils Gregor (nils.gregor@hsbcad.com)
29jun2020  -  version 1.01
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
03.03.2015  -  version 1.00

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="03.03.2015"></version>
/// <version  value="1.01" date="29.06.2020"></version>
/// <version  value="1.02" date="03.07.2020"></version>
/// <version  value="1.03" date="30.07.2020"></version>

/// <history>
/// AS - 1.00 - 03.03.2015 -	Pilot version
/// NG - 1.01 29jun2020 - HSB-8140 Bugfix opening size and added sides
/// NG - 1.02 03jul2020 - HSB-8140 Bugfix beamcut. Can beadded multiple times
/// NG - 1.03 30jul2020 - HSB-8140 Changed image and add offset outside

/// </history>

double dEps = Unit(0.01,"mm");

String arSCategory[] = {
	T("|Position|"),
	T("|Tooling|"),
	T("|Drip rail|")
};


PropDouble dOffsetDripRail(0, U(0), T("|Offset from top opening|"));
dOffsetDripRail.setCategory(arSCategory[0]);
dOffsetDripRail.setDescription(T("|Sets the offset from the top of the opening outline.|"));

String sOffsetOutsideName=T("|Offset from outside|");	
PropDouble dOffsetOutside(10, U(0), sOffsetOutsideName);	
dOffsetOutside.setDescription(T("|Defines the offset from the outside of the wall|"));
dOffsetOutside.setCategory(arSCategory[0]);

int arNZoneIndex[] = {1,2,3,4,5,6,7,8,9};
PropInt nZoneDripRail(0, arNZoneIndex, T("|Place drip rail on top of zone|"));
nZoneDripRail.setCategory(arSCategory[0]);
nZoneDripRail.setDescription(T("|Sets the zone to mount the drip rail on.|"));

String sSideNames[] = { T("|Icon side|"), T("Opposite side|")};
String sSideName=T("|Orientation|");	
PropString sSide(2, sSideNames, sSideName);	
sSide.setDescription(T("|Defines the orientation of the drip rail|"));
sSide.setCategory(arSCategory[0]);

String sPositionNames[] = { T("|Top|"), T("|Bottom|")};
String sPositionName=T("|Position|");	
PropString sPosition(3, sPositionNames, sPositionName);	
sPosition.setDescription(T("|Defines the Position of the drip edge towards the opening|"));
sPosition.setCategory(arSCategory[0]);

PropDouble dtDripRail(3, U(8), T("|Thickness drip rail|"));
dtDripRail.setCategory(arSCategory[2]);
dtDripRail.setDescription(T("|Sets the thickness of the drip rail.|"));

PropDouble dExtendToSide(2, U(98), T("|Extend to side of opening|"));
dExtendToSide.setCategory(arSCategory[2]);
dExtendToSide.setDescription(T("|Sets the extends to the side of the opening outline.|"));

PropDouble dhDripRail(1, U(80), T("|Height mounting face|"));
dhDripRail.setCategory(arSCategory[2]);
dhDripRail.setDescription(T("|Sets the height of the mounting face of the drip rail.|"));

PropDouble dAngle(4, 15, T("|Angle angled part|"));
dAngle.setFormat(_kAngle);
dAngle.setCategory(arSCategory[2]);
dAngle.setDescription(T("|Sets the angle of the angled part of the drip rail.|"));

PropDouble dhAngledDripRail(5, U(60), T("|Height angled part|"));
dhAngledDripRail.setCategory(arSCategory[2]);
dhAngledDripRail.setDescription(T("|Sets the height of the angled part of the drip rail.|"));

PropDouble dhFrontDripRail(6, U(60), T("|Height front part|"));
dhFrontDripRail.setCategory(arSCategory[2]);
dhFrontDripRail.setDescription(T("|Sets the height of the front part of the drip rail.|"));

PropInt nColorDripRail(1, 8, T("|Color drip rail|"));
nColorDripRail.setCategory(arSCategory[2]);
nColorDripRail.setDescription(T("|Sets the color of the drip rail"));

PropString sArticle(1, "DR-012345", T("|Article number|"));
sArticle.setCategory(arSCategory[2]);
sArticle.setDescription(T("|Sets the article number.|"));


PropString sZonesToCut(0, "3", T("|Zones to cut|"));
sZonesToCut.setCategory(arSCategory[1]);
sZonesToCut.setDescription(T("|Sets the zones to cut.|") + TN("|Separate the indexes with a semicolon|"));

PropDouble dGapBottom(7, U(2), T("|Gap bottom|"));
dGapBottom.setCategory(arSCategory[1]);
dGapBottom.setDescription(T("|Sets gap at the bottom of the drip rail.|"));

PropDouble dGapTop(8, U(2), T("|Gap top|"));
dGapTop.setCategory(arSCategory[1]);
dGapTop.setDescription(T("|Sets gap at the top of the drip rail.|"));

PropDouble dGapSide(9, U(2), T("|Gap side|"));
dGapSide.setCategory(arSCategory[1]);
dGapSide.setDescription(T("|Sets gap at the side of the drip rail.|"));


String arSAddHardwareEvent[] = {
	T("|Thickness drip rail|"),
	T("|Extend to side of opening|"),
	T("|Height mounting face|"),
	T("|Angle angled part|"),
	T("|Height angled part|"),
	T("|Height front part|"),
	T("|Color drip rail|"),
	T("|Article number|")
};


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_W-DripRail");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	PrEntity ssE(T("|Select one or more openings|"), OpeningSF());
	if (ssE.go()) {
		Entity arSelectedOpenings[] = ssE.set();

		//insertion point
		String strScriptName = "HSB_W-DripRail"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		mapTsl.setInt("ManualInsert", true);
		setCatalogFromPropValues("MasterToSatellite");
		for( int i=0;i<arSelectedOpenings.length();i++ ){
			OpeningSF opSF = (OpeningSF)arSelectedOpenings[i];
			if (!opSF.bIsValid())
				continue;
			
			Element el = opSF.element();
			if (!el.bIsValid())
				continue;
			
//			// Get the attached elements and remove drip rails attached to the selected opening.
//			TslInst arTsl[] = el.tslInst();
//			int bExistingDripRailErased = false;
//			for (int j=0;j<arTsl.length();j++) {
//				TslInst tsl = arTsl[j];
//
//				if (tsl.scriptName() != strScriptName)
//					continue;
//				
//				Entity arEnt[] = tsl.entity();
//				for (int k=0;k<arEnt.length();k++) {
//					if (arEnt[k].handle() == opSF.handle()) {
//						tsl.dbErase();
//						reportMessage(TN("|Existing drip rail removed.|") + TN("|It was attached to element| ") + el.number());
//						bExistingDripRailErased = true;
//						break;
//					}
//				}
//				
//				if (bExistingDripRailErased)
//					break;
//			}
			
			lstEntities[0] = opSF;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage("\n"+nNrOfTslsInserted + T(" |tsl(s) inserted|"));	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

//Check if there is a valid opening present
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

//Get selected opening
OpeningSF op = (OpeningSF)_Entity[0];
if( !op.bIsValid() ){
	eraseInstance();
	return;
}

Element el = op.element();
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

_ThisInst.assignToElementGroup(el, true, 0, 'E');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnElX(ptEl, vxEl);
Line lnElY(ptEl, vyEl);

int nZnDripRail = nZoneDripRail;
if (nZnDripRail > 5)
	nZnDripRail = 5 - nZnDripRail;
	
int nSide = sSideNames.find(sSide);

int arNZnToCut[0];
String sList = sZonesToCut;
sList.trimLeft();
sList.trimRight();
sList += ";";
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	int nListItem = sListItem.atoi();
	if (nListItem > 5)
		nListItem = 5 - nListItem;
	if (nListItem == 0) {
		reportWarning(el.number() + TN("|Zone 0 is not a valid zone to cut out.|"));
		continue;
	}
	arNZnToCut.append(nListItem);
}

int nZnRef = nZnDripRail + 1;
if (nZnDripRail < 0)
	nZnRef = nZnDripRail - 1;
CoordSys csRef = el.zone(nZnRef).coordSys();
Point3d ptRef = csRef.ptOrg();

Point3d arPtOp[] = op.plShape().vertexPoints(true);
Point3d arPtOpX[] = lnElX.orderPoints(arPtOp);
Point3d arPtOpY[] = lnElY.orderPoints(arPtOp);
if ((arPtOpX.length() * arPtOpY.length()) == 0) {
	reportWarning(T("|Invalid opening outline found in element| ") + el.number());
	eraseInstance();
	return;
}

Point3d ptOpBL = arPtOpX[0];
ptOpBL += vyEl * vyEl.dotProduct(arPtOpY[0] - ptOpBL);
ptOpBL += vzEl * vzEl.dotProduct(ptRef - ptOpBL);
Point3d ptOpTR = arPtOpX[arPtOpX.length() - 1];
ptOpTR += vyEl * vyEl.dotProduct(arPtOpY[arPtOpY.length() - 1] - ptOpTR);
ptOpTR += vzEl * vzEl.dotProduct(ptRef - ptOpTR);
Point3d ptOpMid = (ptOpBL + ptOpTR)/2;

LineSeg lnSegOp(ptOpBL, ptOpTR);
lnSegOp.vis(1);

_Pt0 = ptOpMid;

double dwOp = vxEl.dotProduct(ptOpTR - ptOpBL);
double dhOp = vyEl.dotProduct(ptOpTR - ptOpBL);

Point3d ptDripRail = ptOpMid + vyEl * (0.5 * dhOp + dOffsetDripRail) + vzEl * dOffsetOutside;

if (_bOnDebug) {
	PLine plDripRail(vzEl);
	plDripRail.createRectangle(LineSeg(ptDripRail - vxEl * (0.5 * dwOp + dExtendToSide), ptDripRail + vxEl * (0.5 * dwOp + dExtendToSide) + vyEl * dhDripRail), vxEl, vyEl);
	plDripRail.vis(3);
}

Display dpDripRail(nColorDripRail);
dpDripRail.elemZone(el, nZnRef, 'I');

// Part attached to wall
Body bdDripRailMountingArea(ptDripRail, vxEl, vyEl, vzEl, dwOp + 2 * dExtendToSide, dhDripRail, dtDripRail, 0, 1, 1);
//dpDripRail.draw(bdDripRailMountingArea);
// Angled part
Vector3d vyAngled = vyEl.rotateBy(90 + dAngle, vxEl);
Vector3d vzAngled = vzEl.rotateBy(90 + dAngle, vxEl);
vyAngled.vis(ptDripRail, 3);
vzAngled.vis(ptDripRail, 150);
Body bdDripRailAngle(ptDripRail, vxEl, vyAngled, vzAngled, dwOp + 2 * dExtendToSide, dhAngledDripRail, dtDripRail, 0, 1, -1);
//dpDripRail.draw(bdDripRailAngle);
// Front part
Point3d ptDripRailFront = ptDripRail + vyAngled * dhAngledDripRail - vzAngled * dtDripRail;
ptDripRailFront.vis(1);
Body bdDripRailFront(ptDripRailFront, vxEl, vyEl, vzEl, dwOp + 2 * dExtendToSide, dhFrontDripRail, dtDripRail, 0, -1, -1);
//dpDripRail.draw(bdDripRailFront);

Body bdDripRail = bdDripRailMountingArea;
bdDripRail.addPart(bdDripRailAngle);
bdDripRail.addPart(bdDripRailFront);

if(nSide == 1)
{
	CoordSys csRotate = csEl;
	csRotate.setToRotation(180, vyEl, ptDripRail);
	bdDripRail.transformBy(csRotate);	
}

Point3d ptBC = ptDripRail;

if(sPositionNames.find(sPosition) == 1)
{
	bdDripRail.transformBy(-vyEl * dhOp);
	ptBC -= vyEl * dhOp;
}

dpDripRail.draw(bdDripRail);

// Cut the sheeting for the drip rail
if(dhDripRail + dGapBottom + dGapTop > dEps)
{
	BeamCut bmCutDripRail(ptBC - vyEl * dGapBottom, vxEl, vyEl, vzEl, dwOp + 2 * (dExtendToSide + dGapSide), dhDripRail + dGapBottom + dGapTop, U(750), 0, 1, 0);
	for (int i=0;i<arNZnToCut.length();i++) {
		int nZnToCut = arNZnToCut[i];
		// Cut the sheets
		int nGenBeamsCut = bmCutDripRail.addMeToGenBeamsIntersect(el.genBeam(nZnToCut));
	}	
}

// Set flag to create hardware.
int bAddHardware = _bOnDbCreated;
if (_ThisInst.hardWrComps().length() == 0)
	bAddHardware = true;
if (arSAddHardwareEvent.find(_kNameLastChangedProp) != -1)
	bAddHardware = true;

// add hardware if model has changed or on creation
if (bAddHardware) {
	String sArticleNumber = sArticle;

	String sDescription = sArticleNumber;
	sDescription.makeUpper();

	// declare hardware comps for data export
	HardWrComp hwComps[0];
   HardWrComp hw(sArticleNumber, 1);
	
	hw.setCategory(T("|Openings|"));
	hw.setManufacturer("");
	hw.setModel(sArticleNumber);
	hw.setMaterial(T("|Steel, zincated|"));
	hw.setDescription(sDescription);
	hw.setNotes("");
	
	hw.setDScaleX(0);
	hw.setDScaleY(0);
	hw.setDScaleZ(0); 
	hwComps.append(hw);

	_ThisInst.setHardWrComps(hwComps);
}

#End
#BeginThumbnail
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
4`!1110`4444`%%%%`!1110!__]D`

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End