#Version 8
#BeginDescription
Projects gridlines and lables to a 2d ACA section
V0.10 5/11/2021 Initial release for testing cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 10
#KeyWords Section 2d grid labels
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

Purpose & Function

Map Descriptions

Requirements


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/

//constants
int bIsMetricDwg = U(1, "mm") == 1;//__script units are inches
double dUnitConversion = bIsMetricDwg ? 1 : 1 / 25.4; //__mm to .dwg units
double dAreaConversion = pow(dUnitConversion, 2);
double dVolumeConversion = pow(dUnitConversion, 3);
double dEquivalientTolerance = .01;		
int bInDebug;
bInDebug = projectSpecial() == "db";


PropString psDimstyle(0, _DimStyles, T("|Dimstyle|"));
PropDouble pdTextH(0, 0, T("|Text Height|"));
PropInt piLabelColor(1, 3, T("|Label Color|"));
PropInt piLineColor(0, 8, T("|Line Color|"));
PropDouble pdLabelScale(1, 1.3, T("|Label Scale|"));
PropDouble pdLabelOffset(2, U(12, "inch"), T("|Label Offset|"));


Display dpText(piLabelColor);
Display dpLines(piLineColor);


double dLabelHeight = dpText.textHeightForStyle("!,", psDimstyle) * pdLabelScale;
if (pdTextH > 0) 
{
	dpText.textHeight(pdTextH);
	dLabelHeight = pdTextH * pdLabelScale;
}


if(_bOnInsert)
{ 
	
	showDialogOnce();
	Map mpProps = mapWithPropValues();
	_Map.setMap("mpProps", mpProps);
	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();
	
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[2];
	Point3d lstPoints[0];
	lstPoints.append(_Pt0);
	int lstPropInt[0];
	//lstPropInt.append(nQTY);
	double lstPropDouble[0];
	String lstPropString[0];
	Entity entSections[0];
	
	PrEntity pre(T("|Select Sections|"), Section2d());
	if (pre.go()) entSections = pre.set();
	
	Grid gdSection = getGrid(T("|Select Grid|"));
	lstEnts[0] = gdSection;
	
	for(int i=0; i<entSections.length();i++){
		lstEnts[1] = entSections[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
	}
	
	eraseInstance();
	return;
}



//set properties from map
if(_Map.hasMap("mpProps")){
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps",0);
}

if(_Entity.length() < 2)
{ 
	eraseInstance();
	return;
}

Grid gdSection = (Grid)_Entity[0];
Section2d section =	(Section2d)_Entity[1];

if( ! gdSection.bIsValid() || ! section.bIsValid())
{ 
	eraseInstance();
	return;
}

CoordSys csSection = section.coordSys();
CoordSys csModel2Section = section.modelToSection();

Vector3d vXSection = csSection.vecX();
Vector3d vYSection = csSection.vecY();
Line lnSectionBase (csSection.ptOrg(), vXSection);

CoordSys csGrid = gdSection.coordSys();
Plane pnGrid(csGrid.ptOrg(), csGrid.vecZ());

ClipVolume cv =	 section.clipVolume();
CoordSys csClip = cv.coordSys();
Vector3d vXClip = csClip.vecX();


Body bdClip = cv.clippingBody();
double dClipLength = bdClip.lengthInDirection(vXClip);
PlaneProfile ppClip = bdClip.getSlice(pnGrid);
Point3d ptClipCen = pnGrid.closestPointTo(bdClip.ptCen());
Point3d ptClipStart = ptClipCen - vXClip * dClipLength/2;
Point3d ptClipEnd = ptClipCen + vXClip * dClipLength/2;
LineSeg lsSection(ptClipStart, ptClipEnd);

ptClipStart.vis(3);
ptClipEnd.vis(6);

Point3d ptsGridInt[] = gdSection.intersectPoints(lsSection, vXClip);

for(int i=0;i<ptsGridInt.length();i++)
{
	Point3d ptGrid = ptsGridInt[i];
	Point3d ptGridAtSection = ptGrid;
	ptGridAtSection.transformBy(csModel2Section);
	
	Point3d ptLabelTop = ptGridAtSection - vYSection * pdLabelOffset;
	Point3d ptCenLabel = ptLabelTop - vYSection * dLabelHeight / 2;
	
	String stLabel = gdSection.coordinate(ptGrid, vXClip);
	dpText.draw(stLabel, ptCenLabel, vXSection, vYSection, 0, 0);
	
	PLine plBorder;
	plBorder.createCircle(ptCenLabel, _ZW, dLabelHeight/2); 
	dpLines.draw(plBorder);
	LineSeg lsLeader(ptLabelTop, ptGridAtSection);
	dpLines.draw(lsLeader);
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
      <str nm="Comment" vl="Initial release for testing" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="5/11/2021 11:23:09 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End