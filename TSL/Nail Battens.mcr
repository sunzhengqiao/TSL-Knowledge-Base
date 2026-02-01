#Version 8
#BeginDescription
Tsl to create nail clusters for battens

#Versions
Version 1.1 05.09.2022 HSB-16323 invalid instances will be purged

Last modified by: Anno Sportel (support.nl@hsbcad.com)
05.09.2019  -  version 1.00

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to create nail clusters for battens
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="04.09.2019"></version>

/// <history>
//#Versions
// 1.1 05.09.2022 HSB-16323 invalid instances will be purged , Author Thorsten Huck
/// AS - 1.00 - 05.09.2019 - Created a tsl that applies nail clusters for batten nailing.
/// </hsitory>

String category = T("|Battens|");

int zoneIndexes[] = { 1, 2, 3, 4, 5 ,- 1 ,- 2 ,- 3 ,- 4. - 5};
PropInt zoneIndexBattens(0, zoneIndexes, T("|Zone index battens|"));
zoneIndexBattens.setDescription(T("|Specifies the zone index of the battens.|") + T(" |Battens in this zone will be nailed|."));
zoneIndexBattens.setCategory(category);

PropInt toolIndex(1, 1, T("|Toolindex nailing|"));
toolIndex.setDescription(T("|Specifies the tool index for the nailing.|"));
toolIndex.setCategory(category);

PropDouble maximumNailSpacing(0, U(400), T("|Maximum nail spacing|"));
maximumNailSpacing.setDescription(T("|Specifies the maximum distance between the nails.|") + T(" |The nails will be distrubuted evenly between the start and end. It will not exceed the maximum nail spacing.|"));
maximumNailSpacing.setCategory(category);

PropDouble offsetFromBattenEnd(1, U(100), T("|Offset from batten end|"));
offsetFromBattenEnd.setDescription(T("|Specifies the nail offset from the batten end.|"));
offsetFromBattenEnd.setCategory(category);

category = T("|Brander|");
int branderZone = 0;
double allowedDistanceFromBattens = U(10);
double minimumLengthNailSegment = U(10);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if(_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if( _bOnInsert ){
	if( insertCycleCount() > 1 )
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	setCatalogFromPropValues(T("_LastInserted"));
	
	Element selectedElement[0];
	PrEntity ssEl(T("Select a set of elements"), Element());
	if( ssEl.go() )
	{
		selectedElement.append(ssEl.elementSet());
	}
	
	String strScriptName = scriptName(); // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[2];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map masl;
	masl.setInt("ManualInserted", true);
	
	ElementWall arElWallThis[0];
	ElementWall arElWallConnected[0];
	Point3d arPtIntersect[0];
	
	for ( int e = 0; e < selectedElement.length(); e++)
	{
		lstElements[0] = selectedElement[e];
		
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, masl);
	}
	
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted"))
	manualInserted = _Map.getInt("ManualInserted");

// set properties from catalog
if (_bOnDbCreated && manualInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

if( _Element.length() != 1 )
{
	
	reportNotice("\n" + scriptName() + TN("|Invalid number of elements selected|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys elementCoordSys = el.coordSys();
Point3d elOrg = elementCoordSys.ptOrg();
Vector3d elX = elementCoordSys.vecX();
Vector3d elY = elementCoordSys.vecY();
Vector3d elZ = elementCoordSys.vecZ();

_Pt0 = elOrg;

CoordSys branderCoordSys = el.zone(zoneIndexBattens).coordSys();
branderCoordSys.vis();
Plane branderPlane(branderCoordSys.ptOrg(), elZ);

// Create brander profile.
PlaneProfile branderProfile(branderCoordSys);

GenBeam branders[] = el.genBeam(branderZone);
for (int b=0;b<branders.length();b++)
{
	GenBeam brander = branders[b];
	PlaneProfile singleBranderProfile = brander.envelopeBody(false, true).extractContactFaceInPlane(branderPlane, allowedDistanceFromBattens);
	singleBranderProfile.shrink(-U(5));
	branderProfile.unionWith(singleBranderProfile);
}

branderProfile.shrink(U(5));
branderProfile.vis(1);

if (branderProfile.area() < U(10)) 
{
	reportMessage(TN("|No valid branders found for nailing battens in element| ") + el.number());
	eraseInstance();
	return;
}

GenBeam battens[] = el.genBeam(zoneIndexBattens);
for (int b=0;b<battens.length();b++)
{
	GenBeam batten = battens[b];
	Point3d battenOrg = batten.ptCenSolid();
	Vector3d battenX = batten.vecX();
	double battenLength = batten.solidLength();
	
	battenX.vis(batten.ptCen(), 1);
	
	PlaneProfile battenProfile(branderCoordSys);
	battenProfile = batten.envelopeBody(false, true).extractContactFaceInPlane(branderPlane, allowedDistanceFromBattens);
	battenProfile.shrink(U(1));
	battenProfile.intersectWith(branderProfile);
	battenProfile.vis(3);
	
	LineSeg battenAxis(battenOrg - battenX * 0.5 * battenLength, battenOrg + battenX * 0.5 * battenLength);
	LineSeg nailSegments[] = battenProfile.splitSegments(battenAxis, true);
	for (int s=0;s<nailSegments.length();s++)
	{
		LineSeg nailSegment(nailSegments[s].ptStart() + battenX * offsetFromBattenEnd, nailSegments[s].ptEnd() - battenX * offsetFromBattenEnd);
		nailSegment.vis(2);
		
		double segmentLength = nailSegment.length();
		if (segmentLength < minimumLengthNailSegment) continue;
		
		int numberOfNails = ceil(segmentLength / maximumNailSpacing) + 1;
		double nailSpacing = segmentLength / numberOfNails;
		
		for (int n=0;n<numberOfNails;n++)
		{
			Point3d nailPosition = nailSegment.ptStart() + battenX * n * nailSpacing;
			Point3d nailPositions[] = { nailPosition};
			ElemNailCluster nailCluster(zoneIndexBattens, nailPositions, toolIndex);
			el.addTool(nailCluster);
		}
	}
}


// visualisation
int visualisationColor = 3;
double symbolSize = U(30);
Display visualisationDisplay(visualisationColor);
visualisationDisplay.textHeight(U(4));
visualisationDisplay.addHideDirection(_ZW);
visualisationDisplay.addHideDirection(-_ZW);
visualisationDisplay.elemZone(el, 0, 'I');

Point3d symbolOrg01 = _Pt0 - elY * 2 * symbolSize;
Point3d symbolOrg02 = symbolOrg01 - (elX + elY) * symbolSize;
Point3d symbolOrg03 = symbolOrg01 + (elX - elY) * symbolSize;

PLine symbol01(elZ);
symbol01.addVertex(_Pt0);
symbol01.addVertex(symbolOrg01);
PLine symbol02(elZ);
symbol02.addVertex(symbolOrg02);
symbol02.addVertex(symbolOrg01);
symbol02.addVertex(symbolOrg03);

visualisationDisplay.draw(symbol01);
visualisationDisplay.draw(symbol02);

Vector3d vxTxt = elX + elY;
vxTxt.normalize();
Vector3d vyTxt = elZ.crossProduct(vxTxt);
visualisationDisplay.draw(scriptName(), symbolOrg01, vxTxt, vyTxt, -1.1, 1.75);

{
	Display visualisationDisplayPlan(visualisationColor);
	visualisationDisplayPlan.textHeight(U(4));
	visualisationDisplayPlan.addViewDirection(_ZW);
	visualisationDisplayPlan.addViewDirection(-_ZW);	
	visualisationDisplayPlan.elemZone(el, 0, 'I');
	
	Point3d symbolOrg01 = _Pt0 + elZ * 2 * symbolSize;
	Point3d symbolOrg02 = symbolOrg01 - (elX - elZ) * symbolSize;
	Point3d symbolOrg03 = symbolOrg01 + (elX + elZ) * symbolSize;
	
	PLine symbol01(elY);
	symbol01.addVertex(_Pt0);
	symbol01.addVertex(symbolOrg01);
	PLine symbol02(elY);
	symbol02.addVertex(symbolOrg02);
	symbol02.addVertex(symbolOrg01);
	symbol02.addVertex(symbolOrg03);
	
	visualisationDisplayPlan.draw(symbol01);
	visualisationDisplayPlan.draw(symbol02);
	
	Vector3d vxTxt = elX - elZ;
	vxTxt.normalize();
	Vector3d vyTxt = elY.crossProduct(vxTxt);
	visualisationDisplayPlan.draw(scriptName(), symbolOrg01, vxTxt, vyTxt, -1.1, 1.75);
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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16323 invalid instances will be purged" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/5/2022 9:25:48 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End