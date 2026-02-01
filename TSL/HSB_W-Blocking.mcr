#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
31.03.2020  -  version 3.01






























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Create blocking between two positions. It can also integrate a beam in the studs.
/// </summary>

/// <insert>
/// Select an element and 2 positions
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="3.01" date="31.03.2020"></version>

/// <history>
/// AS	- 1.00 - 01.09.2008 	- Pilot version
/// AS	- 1.01 - 03.09.2008 	- Add option to reference blocking from a specific position
/// AS	- 1.02 - 09.10.2008 	- Add material and a different beamcode
/// AS	- 1.03 - 20.10.2008 	- Set default material to 'Kortling' 
///									- Add 'Kortling' as grade, add 'Manual' as information, use full beamCode with Code;;;;;;NO;;;
///									- Assign this tsl to the 'tooling-zone 0' layer of the element
/// AS	- 1.04 - 24.10.2008 	- Change minimum length to 45mm
/// AS	- 1.05 - 18.11.2008 	- Add a rotation
/// AS	- 1.06 - 26.11.2008 	- Offset based only on beams in zone 0.
///									- Rotation swaps if its inserted from left to right
///									- Mark start point (_Pt0) with a small circle
/// AS	- 1.07 - 27.11.2008 	- Assign line to another layer (T1 io T0)
/// AS	- 1.08 - 04.12.2008 	- Store state in dwg
/// AS	- 1.09 - 11.12.2008 	- Add toolpalette code
/// AS	- 1.10 - 06.02.2009 	- Correct height of first point.
/// AS	- 1.11 - 19.02.2009 	- Insert of the Cross TSL.
/// AS	- 1.12 - 01.07.2009 	- EraseInstance when element is de-constructed
/// AS	- 1.13 - 31.08.2010 	- Swap width and height
/// AS	- 1.14 - 28.12.2011 	- Correct position of blocking
/// AS	- 1.15 - 10.01.2012 	- Add option for an integrated beam
/// AS	- 1.16 - 12.06.2012 	- Find start and end beam with filterBeamsHalfLineIntersectSort
/// AS	- 1.17 - 20.06.2012 	- Fix bug on inifite beam 
/// AS	- 1.18 - 20.06.2012 	- Offset _Pt0 with 1 mm
/// AS	- 1.19 - 21.06.2012 	- Bufix left point
/// AS	- 2.00 - 17.07.2012 	- Generalize tsl
/// AS	- 2.01 - 26.11.2012 	- Add beamcode filter
/// AS	- 2.02 - 25.01.2013 	- Return if the element is regenerating
/// AS	- 2.03 - 21.01.2014 	- Add proper warning message when offset is not set correctly
/// AS	- 2.04 - 05.03.2014 	- Line can be drawn in both directions now. Multiple heights can be specified.
/// AS	- 2.05 - 05.03.2014 	- Add property to set the name of the blockings
/// AS	- 2.06 - 14.03.2014 	- Take dH of zone 0 as zonethickness.
/// AS	- 2.07 - 07.02.2018 	- Add gap as a property.
/// RP	- 3.00 - 27.03.2020 	- Add genbeamfilter, categories and integratedtooling tsl for integration
/// RP	- 3.01 - 31.03.2020 	- Fix bug in check for insertion of integrated tooling
/// </history>

//Script uses mm
Unit(1,"mm");
double dEps = U(0.1);

//Properties
String arSSide[] = {T("|Front|"), T("|Back|")};
int arNSide[] = {1, -1};
String arSBmCode[] = {"BLF", "BLB"};

String arSReference[] = {T("|Bottom| (up)"), T("|Middle| (up)"), T("|Top| (down)")};

String arSType[] = {T("|Blocking|"), T("|Integrated beam|")};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arBYesNo[] = {_kYes, _kNo};

String integratedToolingTslName = "HSB_T-IntegratedTooling";
String integratedToolingCatalogs[] = TslInst().getListOfCatalogNames(integratedToolingTslName);
integratedToolingCatalogs.insertAt(0, "");

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

/// - Filter -
///
String category =  T("|Filter|");

PropString sFilterBC(9,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(category);

PropString genBeamFilterDefinition(12, filterDefinitions, T("|Filter definition|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

category = T("|Blocking|");

PropDouble dBmW(0, U(45), T("|Beam width|"));
dBmW.setCategory(category);

PropDouble dBmH(1, U(170), T("|Beam height|"));
dBmH.setCategory(category);

PropString sSide(1, arSSide, T("|Side|"),1);
sSide.setCategory(category);

PropString sMaterial(2, "C14", T("|Material|"));
sMaterial.setCategory(category);

PropString sName(11, "Blocking", T("|Name|"));
sName.setCategory(category);

PropDouble dMinLengthBm(2, U(40), T("|Minimum blocking length|"));
dMinLengthBm.setCategory(category);

PropDouble gap(4, U(0), T("|Gap|"));
gap.setCategory(category);

category = T("|Positioning|");

PropString sReferencePoint(4, arSReference, T("|Reference point|"),0);
sReferencePoint.setCategory(category);

PropString sOffsetFromReferencePoint(10, "0", T("|Offset from reference point|"));
sOffsetFromReferencePoint.setCategory(category);
sOffsetFromReferencePoint.setDescription(T("|Multiple positions can be specified|.")+TN("|Use| ';' ")+T("|as a seperator|"));

PropDouble dRotationAngle(3, 0, T("|Rotation|"));
dRotationAngle.setCategory(category);
dRotationAngle.setFormat(_kAngle);

category = T("|Style|");

PropString sType(6, arSType, T("|Type|"));
sType.setCategory(category);

PropString sDrawLine(7, arSYesNo, T("|Draw line|"));
sDrawLine.setCategory(category);

PropString integratedToolingCatalog(13, integratedToolingCatalogs, T("|Integrated tooling catalog|"));
integratedToolingCatalog.setCategory(category);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();

	Element el = getElement(T("|Select an element|"));
	_Element.append(el);
	_Pt0 = getPoint(T("|Select start point|"));

	while (true) {
		PrPoint ssP2(T("|Select end point|"),_Pt0);
		if (ssP2.go()==_kOk) { // do the actual query
			Point3d pt = ssP2.value(); // retrieve the selected point
			_PtG.append(pt); // append the selected points to the list of grippoints _PtG
			break; // out of infinite while
		}
	}

	return;
}

if( _Element.length()==0 || _PtG.length()==0 ){eraseInstance(); return;}
String tokenizedString[] =  sOffsetFromReferencePoint.tokenize(";");
double arDOffsetFromReferencePoint[0];
for (int index=0;index<tokenizedString.length();index++) 
{ 
	arDOffsetFromReferencePoint.append(tokenizedString[index].atof()); 
}


int nSide = arNSide[ arSSide.find(sSide,1) ];
int nReferencePoint = arSReference.find(sReferencePoint,0);
int bDrawLine = arBYesNo[arSYesNo.find(sDrawLine,0)];
String sBeamCode = arSBmCode[ arSSide.find(sSide,1) ] + ";;;;;;;;NO;;;;;";
int bIntegratedBeam = arSType.find(sType,0);

//Delete created beams
for( int i=0;i<_Map.length();i++){
	if(_Map.keyAt(i) != "Blocking" || !_Map.hasEntity(i) )
		continue;
	
	Entity ent = _Map.getEntity(i);
	ent.dbErase();
	_Map.removeAt(i, true);
	i--;
}

//Get the element
Element el = _Element[0];
CoordSys csEl(el.coordSys());
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();


int nSwapRotation = 1;
if( vx.dotProduct(_PtG[0] - _Pt0) < 0 ){
	nSwapRotation = -1;
}

CoordSys csBlocking = el.coordSys();
Vector3d vxBlocking = csBlocking.vecX();
Vector3d vyBlocking = csBlocking.vecZ();
vxBlocking = vxBlocking.rotateBy(nSwapRotation * dRotationAngle, vyBlocking);
Vector3d vzBlocking = vxBlocking.crossProduct(vyBlocking);

vxBlocking.vis(_Pt0, 5);

assignToElementGroup(el, TRUE, 1, 'T');

//Collect all beams
Beam arAllBm[] = el.beam();
Entity filteredBeams[0];
for (int index=0;index<arAllBm.length();index++) 
{ 
	filteredBeams.append((Entity)arAllBm[index]); 
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(filteredBeams, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
filterGenBeamsMap.setInt("Exclude", true);
TslInst().callMapIO("HSB_G-FilterGenBeams", genBeamFilterDefinition, filterGenBeamsMap);
filteredBeams.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));

if( filteredBeams.length() == 0 )
	return;
Beam arBm[0];
Body bdAllBeams;

Point3d arPtBm[0];

for( int i=0;i<filteredBeams.length();i++ ){
	Beam bm = (Beam)filteredBeams[i];
	
	if( bm.myZoneIndex() != 0 )continue;
	
	arBm.append(bm);
	Body bdBm = bm.envelopeBody(true, true);
	bdAllBeams.addPart(bdBm);
	arPtBm.append(bdBm.allVertices());
}
Line lnY(_Pt0, vy);
Point3d arPtBmY[] = lnY.orderPoints(arPtBm);

Line lnZ(_Pt0, vz);
Point3d arPtBmZ[] = lnZ.orderPoints(arPtBm);

if( arPtBmY.length() < 2 ){
	reportWarning(TN("TSL is not able to calculate the reference points. Not enough points found."));
	eraseInstance();
	return;
}
if( arPtBmZ.length() < 2 ){
	reportWarning(TN("TSL is not able to calculate the reference points. Not enough points found."));
	eraseInstance();
	return;
}

Point3d ptBottom = arPtBmY[0];
Point3d ptTop = arPtBmY[arPtBmY.length() - 1];
Point3d ptMiddle = (ptBottom + ptTop)/2;

for (int d = 0; d < arDOffsetFromReferencePoint.length(); d++)
{
	double dOffsetFromReferencePoint = arDOffsetFromReferencePoint[d];
	
	Point3d ptReference = ptBottom + vy * dOffsetFromReferencePoint;//Bottom
	if ( nReferencePoint == 1 )
	{
		ptReference = ptMiddle + vy * dOffsetFromReferencePoint;
	}
	else if ( nReferencePoint == 2 ) 
	{
		ptReference = ptTop - vy * dOffsetFromReferencePoint;
	}
	ptReference += vx * vx.dotProduct(_Pt0 - ptReference);
	ptReference.vis(1);
	//Project points to element
	
	double dHZn0 = el.zone(0).dH();//abs(vz.dotProduct(arPtBmZ[0] - arPtBmZ[arPtBmZ.length() - 1]));//el.dBeamWidth();//.zone(0).dH();
	Point3d p = el.ptOrg();
	p.vis();
	Plane pnProjectPoints(el.ptOrg() - vz * 0.5 * (dHZn0 - nSide * (dHZn0 - dBmW)), vz);
	_Pt0 = _Pt0.projectPoint(pnProjectPoints, 0);
	_Pt0.vis(3);
	_PtG[0] = _PtG[0].projectPoint(pnProjectPoints, 0);
	
	Plane pnHeight(ptReference, vzBlocking);
	Line lnElY(_Pt0, vy);
	_Pt0 = lnElY.intersect(pnHeight, 0);
	lnElY = Line(_PtG[0], vy);
	_PtG[0] = lnElY.intersect(pnHeight, 0);
	
	//Draw line
	Display dp(-1);
	if ( bDrawLine ) {
		PLine plStart(vz);
		plStart.createCircle(_Pt0, vz, U(10));
		dp.draw(plStart);
		dp.draw(PLine(_Pt0, _PtG[0]));
	}
	
	Point3d ptLeft = _Pt0;
	Point3d ptRight = _PtG[0];
	if ( nSwapRotation == -1 ) {
		ptLeft = _PtG[0];
		ptRight = _Pt0;
	}
	
	if ( _bOnDebug ) {
		for ( int b = 0; b < arBm.length(); b++) {
			Beam bm = arBm[b];
			bm.envelopeBody().vis(bm.color());
		}
	}
	
	Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptRight, - vx);
	if ( arBmLeft.length() == 0 ) {
		reportNotice(TN("Startposition cannot be calculated."));
		continue;
	}
	
	Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptLeft, vx);
	if ( arBmRight.length() == 0 ) {
		reportWarning(TN("Endposition cannot be calculated."));
		continue;
	}
	
	Beam arBmIntersect[0];
	for ( int i = 0; i < arBmLeft.length(); i++) {
		Beam bmLeft = arBmLeft[i];
		if ( abs(abs(vxBlocking.dotProduct(bmLeft.vecX())) - 1) < dEps )
			continue;
		
		if ( vx.dotProduct(bmLeft.ptCen() - ptLeft) < 0 ) {
			arBmIntersect.append(bmLeft);
			break;
		}
	}
	
	for ( int i = 0; i < arBmRight.length(); i++) {
		Beam bmRight = arBmRight[i];
		if ( abs(abs(vxBlocking.dotProduct(bmRight.vecX())) - 1) < dEps )
			continue;
		
		arBmIntersect.append(bmRight);
		if ( vx.dotProduct(bmRight.ptCen() - ptRight) > 0 )
			break;
	}
	
	if ( arBmIntersect.length() == 0 ) {
		reportNotice("\n\n" + scriptName());
		reportNotice(TN("|No intersecting beams found in element| ") + el.number() + "!" + TN("|Please check the reference position and offset|."));
		continue;
	}
	
	_Pt0.vis();
	Line lnBlocking(_Pt0, vxBlocking);
	lnBlocking.vis(1);
	
	Beam bmLeft = arBmIntersect[0];
	Beam bmRight = arBmIntersect[arBmIntersect.length() - 1];
	Point3d ptStartFullBeam = lnBlocking.intersect(Plane(bmLeft.ptCen(), bmLeft.vecD(vxBlocking)), - 0.5 * bmLeft.dD(vxBlocking));
	Point3d ptEndFullBeam = lnBlocking.intersect(Plane(bmRight.ptCen(), bmRight.vecD(-vxBlocking)), - 0.5 * bmRight.dD(vxBlocking));
	ptStartFullBeam.vis(1);
	ptEndFullBeam.vis(5);
	
	Point3d arPtFrom[0];
	Point3d arPtTo[0];
	Point3d arPtMid[0];
	double arDL[0];
	
	Opening arOp[] = el.opening();
	PlaneProfile ppOpening(csEl);
	for ( int i = 0; i < arOp.length(); i++)
		ppOpening.joinRing(arOp[i].plShape(), _kAdd);
	
	for ( int i = 0; i < (arBmIntersect.length() - 1); i++) {
		Beam bmThis = arBmIntersect[i];
		Beam bmNext = arBmIntersect[i + 1];
		bmThis.ptCen().vis(1);
		bmNext.ptCen().vis(3);
		if ( bmThis.handle() == bmNext.handle() )
			continue;
		
		if ( vxBlocking.dotProduct(bmNext.ptCen() - bmThis.ptCen()) < 0 )
			continue;
		
		Point3d ptFrom = lnBlocking.intersect(Plane(bmThis.ptCen() + bmThis.vecD(vxBlocking) * 0.5 * bmThis.dD(vxBlocking), bmThis.vecD(vxBlocking)), 0);;
		Point3d ptTo = lnBlocking.intersect(Plane(bmNext.ptCen() - bmNext.vecD(vxBlocking) * 0.5 * bmNext.dD(vxBlocking), bmNext.vecD(vxBlocking)), 0);
		
		double dBmL = Vector3d(ptTo - ptFrom).length();
		if ( dBmL < dMinLengthBm )
			continue;
		Point3d ptInBetween = (ptFrom + ptTo) / 2;
		
		if ( ppOpening.pointInProfile(ptInBetween) != _kPointOutsideProfile )
			continue;
		
		arPtFrom.append(ptFrom);
		arPtTo.append(ptTo);
		arPtMid.append(ptInBetween);
		arDL.append(dBmL);
	}
	
	if ( bIntegratedBeam ) {
		Point3d ptFrom = ptStartFullBeam;
		Point3d ptTo = ptEndFullBeam;
		Point3d ptInBetween = (ptFrom + ptTo) / 2;
		double dBmL = Vector3d(ptTo - ptFrom).length();
		
		arPtFrom.setLength(0);
		arPtTo.setLength(0);
		arPtMid.setLength(0);
		arDL.setLength(0);
		
		arPtFrom.append(ptFrom);
		arPtTo.append(ptTo);
		arPtMid.append(ptInBetween);
		arDL.append(dBmL);
	}
	
	for ( int i = 0; i < arPtMid.length(); i++) {
		Point3d pt = arPtMid[i];
		Point3d ptFrom = arPtFrom[i];
		Point3d ptTo = arPtTo[i];
		
		double dBmL = arDL[i];
		
		Beam bm;
		bm.dbCreate(pt, vxBlocking, vyBlocking, vzBlocking, dBmL, dBmW, dBmH);
		bm.assignToElementGroup(el, TRUE, 0, 'Z');
		bm.setBeamCode(sBeamCode);
		bm.setMaterial(sMaterial);
		bm.setName(sName);
		bm.setColor(32);
		_Map.appendEntity("Blocking", bm);
		
		Cut ctFrom(ptFrom + vxBlocking * gap, - vxBlocking);
		bm.addToolStatic(ctFrom, _kStretchOnToolChange);
		Cut ctTo(ptTo - vxBlocking * gap, vxBlocking);
		bm.addToolStatic(ctTo, _kStretchOnToolChange);
		
		if ( bIntegratedBeam )
		{
			Body maleBody = bm.realBody();
			// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl = _XE;
			Vector3d vecYTsl = _YE;
			GenBeam gbsTsl[0];
			gbsTsl.append(bm);
			for (int index = 0; index < arBmIntersect.length(); index++)
			{
				Beam femaleGenBeam = arBmIntersect[index];
				Body femaleBody = femaleGenBeam.envelopeBody();
				if ( ! femaleBody.hasIntersection(maleBody)) continue;
				gbsTsl.append(femaleGenBeam);
			}
			
			Entity entsTsl[0];
			Point3d ptsTsl[] = { };
			
			Map mapTsl;
			if (integratedToolingCatalog != "")
			{
				tslNew.dbCreate(integratedToolingTslName, vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, integratedToolingCatalog, true, mapTsl, "", "");
			}
			else
			{
				BeamCut bmCut(pt, vxBlocking, vyBlocking, vzBlocking, 1.1 * dBmL, dBmW, dBmH);
				int nNrOfBeamsModified = bmCut.addMeToGenBeamsIntersect(arBmIntersect);
			}
		}
	}
}




























#End
#BeginThumbnail
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
)44`%%%%`'__9
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End