#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
04.03.2021-  version 1.07

Change the internal sheeting of roof elements.
The tsl can change the material of sheets behind knee walls.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Change the internal sheeting of roof elements. The tsl can change the material of sheets behind knee walls, or above the upper floor.
/// </summary>

/// <insert>
/// Select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.07" date="04.03.2021"></version>

/// <history>
/// AS - 1.00 - 24.08.2015 -  Pilot version.
/// AS - 1.01 - 01.11.2016 -  Add option for an upper supporting beam.
/// YB - 1.02 - 04.04.2017 -  Fixed the TSL, and added a thickness variable.
/// AS - 1.03 - 20.04.2017 -  Extend properties to set.
/// AS - 1.04 - 11.05.2017 -  Correct sheet position if thickness changes.
/// YB - 1.05 - 19.05.2017 -  Set the properties correctly.
/// YB - 1.06 - 06.07.2017 -  Add option for between supporting beams
///Rvw- 1.07 - 04.03.2021 - Change reportError to ReportMessage.
/// </history>

double vectorTolerance = Unit(0.01, "mm");

String categories[] = 
{
	T("|Selection|"),
	T("|Lower supporting beam|"),
	T("|Upper supporting beam|"),
	T("|Between supporting beam|")
};

String arSNoYes[] = { T("|No|"), T("|Yes|")};

int zones[] = {6,7,8,9,10};
PropInt znIndex(0, zones, T("|Zone index|"));
znIndex.setDescription(T("|Sets the zone to change|"));
znIndex.setCategory(categories[0]);

// Lower supporting beam properties

PropString beamCodeLowerSupportingBeam(0, "", T("|Beamcode of lower supporting beam|"));
beamCodeLowerSupportingBeam.setDescription(T("|Change material for sheeting below this beam.|"));
beamCodeLowerSupportingBeam.setCategory(categories[1]);

PropInt colorBelowSupportingBeam(1, 52, T("|Color below supporting beam|"));
colorBelowSupportingBeam.setDescription(T("|Sets the color of the sheeting below the specified supporting beam.|"));
colorBelowSupportingBeam.setCategory(categories[1]);

PropString nameBelowSupportingBeam(4, "", T("|Name below supporting beam|"));
nameBelowSupportingBeam.setDescription(T("|Sets the name of the sheeting below the specified supporting beam.|"));
nameBelowSupportingBeam.setCategory(categories[1]);

PropString materialBelowSupportingBeam(1, "", T("|Material below supporting beam|"));
materialBelowSupportingBeam.setDescription(T("|Sets the material of the sheeting below the specified supporting beam.|"));
materialBelowSupportingBeam.setCategory(categories[1]);

PropString gradeBelowSupportingBeam(5, "", T("|Grade below supporting beam|"));
gradeBelowSupportingBeam.setDescription(T("|Sets the grade of the sheeting below the specified supporting beam.|"));
gradeBelowSupportingBeam.setCategory(categories[1]);

PropString informationBelowSupportingBeam(6, "", T("|Information below supporting beam|"));
informationBelowSupportingBeam.setDescription(T("|Sets the information of the sheeting below the specified supporting beam.|"));
informationBelowSupportingBeam.setCategory(categories[1]);

PropString labelBelowSupportingBeam(7, "", T("|Label below supporting beam|"));
labelBelowSupportingBeam.setDescription(T("|Sets the label of the sheeting below the specified supporting beam.|"));
labelBelowSupportingBeam.setCategory(categories[1]);

PropString subLabelBelowSupportingBeam(8, "", T("|Sublabel below supporting beam|"));
subLabelBelowSupportingBeam.setDescription(T("|Sets the sublabel of the sheeting below the specified supporting beam.|"));
subLabelBelowSupportingBeam.setCategory(categories[1]);

PropString subLabel2BelowSupportingBeam(9, "", T("|Sublabel2 below supporting beam|"));
subLabel2BelowSupportingBeam.setDescription(T("|Sets the sublabel2 of the sheeting below the specified supporting beam.|"));
subLabel2BelowSupportingBeam.setCategory(categories[1]);

PropString beamCodeBelowSupportingBeam(10, "", T("|Beamcode below supporting beam|"));
beamCodeBelowSupportingBeam.setDescription(T("|Sets the beamcode of the sheeting below the specified supporting beam.|"));
beamCodeBelowSupportingBeam.setCategory(categories[1]);

PropDouble thicknessBelowSupportingBeam(0, U(11), T("|Thickness below supporting beam|"));
thicknessBelowSupportingBeam.setDescription(T("|Sets the thickness of the sheeting below the specified supporting beam.|"));
thicknessBelowSupportingBeam.setCategory(categories[1]);

// Upper supporting beam properties

PropString beamCodeUpperSupportingBeam(2, "", T("|Beamcode of upper supporting beam|"));
beamCodeUpperSupportingBeam.setDescription(T("|Change material for sheeting above this beam.|"));
beamCodeUpperSupportingBeam.setCategory(categories[2]);

PropInt colorAboveSupportingBeam(2, 52, T("|Color above supporting beam|"));
colorAboveSupportingBeam.setDescription(T("|Sets the color of the sheeting above the specified supporting beam.|"));
colorAboveSupportingBeam.setCategory(categories[2]);

PropString nameAboveSupportingBeam(11, "", T("|Name above supporting beam|"));
nameAboveSupportingBeam.setDescription(T("|Sets the name of the sheeting above the specified supporting beam.|"));
nameAboveSupportingBeam.setCategory(categories[2]);

PropString materialAboveSupportingBeam(3, "", T("|Material above supporting beam|"));
materialAboveSupportingBeam.setDescription(T("|Sets the material of the sheeting above the specified supporting beam.|"));
materialAboveSupportingBeam.setCategory(categories[2]);

PropString gradeAboveSupportingBeam(12, "", T("|Grade above supporting beam|"));
gradeAboveSupportingBeam.setDescription(T("|Sets the grade of the sheeting above the specified supporting beam.|"));
gradeAboveSupportingBeam.setCategory(categories[2]);

PropString informationAboveSupportingBeam(13, "", T("|Information above supporting beam|"));
informationAboveSupportingBeam.setDescription(T("|Sets the information of the sheeting above the specified supporting beam.|"));
informationAboveSupportingBeam.setCategory(categories[2]);

PropString labelAboveSupportingBeam(14, "", T("|Label above supporting beam|"));
labelAboveSupportingBeam.setDescription(T("|Sets the label of the sheeting above the specified supporting beam.|"));
labelAboveSupportingBeam.setCategory(categories[2]);

PropString subLabelAboveSupportingBeam(15, "", T("|Sublabel above supporting beam|"));
subLabelAboveSupportingBeam.setDescription(T("|Sets the sublabel of the sheeting above the specified supporting beam.|"));
subLabelAboveSupportingBeam.setCategory(categories[2]);

PropString subLabel2AboveSupportingBeam(16, "", T("|Sublabel2 above supporting beam|"));
subLabel2AboveSupportingBeam.setDescription(T("|Sets the sublabel2 of the sheeting above the specified supporting beam.|"));
subLabel2AboveSupportingBeam.setCategory(categories[2]);

PropString beamCodeAboveSupportingBeam(17, "", T("|Beamcode above supporting beam|"));
beamCodeAboveSupportingBeam.setDescription(T("|Sets the beamcode of the sheeting above the specified supporting beam.|"));
beamCodeAboveSupportingBeam.setCategory(categories[2]);

PropDouble thicknessAboveSupportingBeam(1, U(11), T("|Thickness above supporting beam|"));
thicknessAboveSupportingBeam.setDescription(T("|Sets the thickness of the sheeting above the specified supporting beam.|"));
thicknessAboveSupportingBeam.setCategory(categories[2]);

// Between supporting beams

PropString applyBetweenSupportingBeams(26, arSNoYes, T("|Change between sheets|"));
applyBetweenSupportingBeams.setCategory(categories[3]);
applyBetweenSupportingBeams.setDescription(T("|Specifies if the sheets between the supporting beams should be changed.|"));

PropInt colorBetweenSupportingBeam(3, 52, T("|Color between supporting beam|"));
colorBetweenSupportingBeam.setDescription(T("|Sets the color of the sheeting between the specified supporting beam.|"));
colorBetweenSupportingBeam.setCategory(categories[3]);

PropString nameBetweenSupportingBeam(18, "", T("|Name between supporting beam|"));
nameBetweenSupportingBeam.setDescription(T("|Sets the name of the sheeting between the specified supporting beam.|"));
nameBetweenSupportingBeam.setCategory(categories[3]);

PropString materialBetweenSupportingBeam(19, "", T("|Material between supporting beam|"));
materialBetweenSupportingBeam.setDescription(T("|Sets the material of the sheeting between the specified supporting beam.|"));
materialBetweenSupportingBeam.setCategory(categories[3]);

PropString gradeBetweenSupportingBeam(20, "", T("|Grade between supporting beam|"));
gradeBetweenSupportingBeam.setDescription(T("|Sets the grade of the sheeting between the specified supporting beam.|"));
gradeBetweenSupportingBeam.setCategory(categories[3]);

PropString informationBetweenSupportingBeam(21, "", T("|Information between supporting beam|"));
informationBetweenSupportingBeam.setDescription(T("|Sets the information of the sheeting between the specified supporting beam.|"));
informationBetweenSupportingBeam.setCategory(categories[3]);

PropString labelBetweenSupportingBeam(22, "", T("|Label between supporting beam|"));
labelBetweenSupportingBeam.setDescription(T("|Sets the label of the sheeting between the specified supporting beam.|"));
labelBetweenSupportingBeam.setCategory(categories[3]);

PropString subLabelBetweenSupportingBeam(23, "", T("|Sublabel between supporting beam|"));
subLabelBetweenSupportingBeam.setDescription(T("|Sets the sublabel of the sheeting between the specified supporting beam.|"));
subLabelBetweenSupportingBeam.setCategory(categories[3]);

PropString subLabel2BetweenSupportingBeam(24, "", T("|Sublabel2 between supporting beam|"));
subLabel2BetweenSupportingBeam.setDescription(T("|Sets the sublabel2 of the sheeting between the specified supporting beam.|"));
subLabel2BetweenSupportingBeam.setCategory(categories[3]);

PropString beamCodeBetweenSupportingBeam(25, "", T("|Beamcode between supporting beam|"));
beamCodeBetweenSupportingBeam.setDescription(T("|Sets the beamcode of the sheeting between the specified supporting beam.|"));
beamCodeBetweenSupportingBeam.setCategory(categories[3]);

PropDouble thicknessBetweenSupportingBeam(2, U(11), T("|Thickness between supporting beam|"));
thicknessBetweenSupportingBeam.setDescription(T("|Sets the thickness of the sheeting between the specified supporting beam.|"));
thicknessBetweenSupportingBeam.setCategory(categories[3]);

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
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportMessage(T("|invalid or no element selected.|"));
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
	
// Resolve properties
int bApplyBetween = arSNoYes.find(applyBetweenSupportingBeams, 0) == 1;

Element el = _Element[0];

CoordSys csEl = el.coordSys();
Point3d elOrg  = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

assignToElementGroup(el, true, -1, 'I');
	

if (_bOnElementConstructed || manualInserted || _bOnDebug)  
{
	int zoneIndex = znIndex;
	if (zoneIndex > 5)
		zoneIndex = 5 - zoneIndex;
	
	_Pt0 = el.ptOrg();
	
	Beam beams[] = el.beam();
	Beam lowerSupportingBeam, upperSupportingBeam;
	for (int b=0;b<beams.length();b++) {
		Beam bm = beams[b];
		
		String beamCode = bm.beamCode().token(0);
		//reportNotice("\nBC: " + beamCode);
		if (beamCode != beamCodeLowerSupportingBeam && beamCode != beamCodeUpperSupportingBeam)
			continue;
		
		if (abs(el.vecY().dotProduct(bm.vecX())) > vectorTolerance)
			continue;
		
		if (beamCode == beamCodeLowerSupportingBeam && beamCode != "")
			lowerSupportingBeam = bm;
		else if(beamCode == beamCodeUpperSupportingBeam && beamCode != "")
			upperSupportingBeam = bm;
	}
	
	
	Sheet sheets[] = el.sheet(zoneIndex);
	for (int s=0;s<sheets.length();s++) {
		Sheet sh = sheets[s];
		if(!sh.bIsValid())
			continue;
		Point3d ptcen = sh.ptCen();
		if(bApplyBetween)
		{
			sh.setColor(colorBetweenSupportingBeam);
			sh.setName(nameBetweenSupportingBeam);
			sh.setMaterial(materialBetweenSupportingBeam);
			sh.setGrade(gradeBetweenSupportingBeam);
			sh.setInformation(informationBetweenSupportingBeam);
			sh.setLabel(labelBetweenSupportingBeam);
			sh.setSubLabel(subLabelBetweenSupportingBeam);
			sh.setSubLabel2(subLabel2BetweenSupportingBeam);
			sh.setBeamCode(beamCodeBetweenSupportingBeam);
			
			double originalThickness = sh.dH();
			if (originalThickness != thicknessBetweenSupportingBeam)
			{
				sh.setDH(thicknessBelowSupportingBeam);
				sh.transformBy(-elZ * (thicknessBelowSupportingBeam - originalThickness));
			}
		}
		if (lowerSupportingBeam.bIsValid()) 
		{
			if (el.vecY().dotProduct(lowerSupportingBeam.ptCen() - sh.ptCen()) > 0) 
			{
				sh.setColor(colorBelowSupportingBeam);
				sh.setName(nameBelowSupportingBeam);
				sh.setMaterial(materialBelowSupportingBeam);
				sh.setGrade(gradeBelowSupportingBeam);
				sh.setInformation(informationBelowSupportingBeam);
				sh.setLabel(labelBelowSupportingBeam);
				sh.setSubLabel(subLabelBelowSupportingBeam);
				sh.setSubLabel2(subLabel2BelowSupportingBeam);
				sh.setBeamCode(beamCodeBelowSupportingBeam);
				
				double originalThickness = sh.dH();
				if (originalThickness != thicknessBelowSupportingBeam)
				{
					sh.setDH(thicknessBelowSupportingBeam);
					sh.transformBy(-elZ * (thicknessBelowSupportingBeam - originalThickness));
				}
				
				sh.envelopeBody().vis(150);
			}
		}
		if (upperSupportingBeam.bIsValid()) 
		{
			if (el.vecY().dotProduct(upperSupportingBeam.ptCen() - sh.ptCen()) < 0) 
			{
				sh.setColor(colorAboveSupportingBeam);
				sh.setName(nameAboveSupportingBeam);
				sh.setMaterial(materialAboveSupportingBeam);
				sh.setGrade(gradeAboveSupportingBeam);
				sh.setInformation(informationAboveSupportingBeam);
				sh.setLabel(labelAboveSupportingBeam);
				sh.setSubLabel(subLabelAboveSupportingBeam);
				sh.setSubLabel2(subLabel2AboveSupportingBeam);
				sh.setBeamCode(beamCodeAboveSupportingBeam);
				
				double originalThickness = sh.dH();
				if (originalThickness != thicknessAboveSupportingBeam)
				{
					sh.setDH(thicknessAboveSupportingBeam);
					sh.transformBy(-elZ * (thicknessAboveSupportingBeam - originalThickness));
				}
			}
		}	
	}
	
	//eraseInstance();
//	return;
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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Change reportError to ReportMessage." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/4/2021 3:13:39 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End