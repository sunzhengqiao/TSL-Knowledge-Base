#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
28.06.2018 - version 1.06
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows elevation marks in paperspace.
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.05" date="03.03.2017"></version>

/// <history>
/// 1.00	- 29.09.2014 -	Pilot version, rewritten HSB-HeightGauges.
/// 1.01	- 30.09.2014 -	Add material filter.
/// 1.02	- 05.02.2015 -	Add filters and display name
/// 1.03	- 20.04.2016 -	Improve detection of openings
/// 1.04	- 21.04.2016 -	Add filter for opening descriptions
/// 1.05	- 03.03.2017 -	Correct direction in openings when using entities instead of outline.
/// 1.06 - 28.06.2018 - 	Added use of HSB_G-FilterGenBeams.mcr
/// </history>

Unit(1,"mm"); // script uses mm
double dEps = U(0.05);


String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSOpeningOutline[] = {T("|Opening outline|"), T("|Beams and sheets around opening|")};
String arSOpeningMarks[] = {T("|Inside opening|"), T("|At element side|"), T("|Ignore openings|")};


// Selection
PropString sSeparator01(0, "", T("|Selection|"));
sSeparator01.setReadOnly(true);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");
PropString genBeamFilterDefinition(14, filterDefinitions, "     "+T("|Filter definition for GenBeams|")); 
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
sFilterBC.setDescription(T("|Beams and sheets with corresponding beam codes are not taken into account.|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
sFilterLabel.setDescription(T("|Beams and sheets with corresponding labels are not taken into account.|"));
PropString sFilterMaterial(9,"","     "+T("|Filter beams and sheets with material|"));
sFilterMaterial.setDescription(T("|Beams and sheets with corresponding materials are not taken into account.|"));
PropString sFilterZn(3, "", "     "+T("|Filter zones|"));
sFilterZn.setDescription(T("|Beams and sheets from these zones are not taken into account.|"));
PropString sFilterOpening(13, "", "     "+T("|Filter openings with description|"));
sFilterOpening.setDescription(T("|Openings with these descriptions are not taken into account.|"));

// Positioning
PropString sSeparator02(4, "", T("|Position|"));
sSeparator02.setReadOnly(true);
PropString sOpeningMarks(5, arSOpeningMarks, "     "+T("|Opening marks|"),0);
sOpeningMarks.setDescription(T("|Sets the position for the opening marks.|"));
PropString sOpeningOutline(6, arSOpeningOutline, "     "+T("|Opening outline|"));
sOpeningOutline.setDescription(T("|Sets the objects which are used to get the opening outline.|"));
PropDouble dDimOff(0,U(300),"     "+T("|Distance to element|"));
dDimOff.setDescription(T("|Sets the offset of the element elevation marks to the element.|"));
PropDouble dExtraDimOffOpening(2,U(0),"     "+T("|Extra offset for opening to element|"));
dExtraDimOffOpening.setDescription(T("|Sets the offset of the opening elevation marks to the element.|"));
PropDouble dDimOffOpening(1,U(300),"     "+T("|Distance to opening side|"));
dDimOffOpening.setDescription(T("|Sets the offset of the opening elevation marks to the side of the opening.|"));

// Style
PropString sSeparator03(7, "", T("|Style|"));
sSeparator03.setReadOnly(true);
PropString sDimStyle(8,_DimStyles,"     "+T("|Dimension style|"));
sDimStyle.setDescription(T("|Sets the dimension style.|"));

/// - Name and description -
/// 
PropString sSeperator14(10, "", T("|Name and description|"));
sSeperator14.setReadOnly(true);
PropInt nColorName(0, -1, "     "+T("|Default name color|"));
nColorName.setDescription(T("|Sets the color of the name displayed at the insertion point of the tsl.|"));
PropInt nColorActiveFilter(1, 30, "     "+T("|Filter other element color|"));
nColorActiveFilter.setDescription(T("|Sets the color of the name displayed at the insertion point of the tsl when another element is excluded by the custom filter.|"));
PropInt nColorActiveFilterThisElement(2, 1, "     "+T("|Filter this element color|"));
nColorActiveFilterThisElement.setDescription(T("|Sets the color of the name displayed at the insertion point of the tsl when this element is excluded by the custom filter.|"));
PropString sDimStyleName(11, _DimStyles, "     "+T("|Dimension style name|"));
sDimStyleName.setDescription(T("|Sets the dimension style used for the name and description.|"));
PropString sInstanceDescription(12, "", "     "+T("|Extra description|"));
sInstanceDescription.setDescription(T("|Sets the description of this tsl.|"));


if (_bOnInsert) {
	showDialog();
		
	Viewport vp = getViewport(T("|Select a viewport|.")); // select viewport
	_Viewport.append(vp);
	
	_Pt0 = getPoint(T("|Select location|"));
	
	return;
}

String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);


// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

Element el = vp.element();


// Add filteer
if( _kExecuteKey == arSTrigger[0] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filteer
if( _kExecuteKey == arSTrigger[2] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") ){
		mapFilterElements = _Map.getMap("FilterElements");
		
		if( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filteer
if( _kExecuteKey == arSTrigger[3] ){
	if( _Map.hasMap("FilterElements") )
		_Map.removeAt("FilterElements", true);
}

Map mapFilterElements;
if( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
if( mapFilterElements.length() > 0 ){
	if( mapFilterElements.hasString(el.handle()) ){
		dpName.color(nColorActiveFilterThisElement);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(nColorActiveFilter);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}


// check if the viewport has hsb data
if (!el.bIsValid()) 
	return;

// resolve props
String sFBC = sFilterBC + ";";
String arSFBC[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);

	arSFBC.append(sTokenBC);
}

String sFLabel = sFilterLabel + ";";
String arSFLabel[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFilterLabel.find(sTokenLabel,0);

	arSFLabel.append(sTokenLabel);
}

String sFMaterial = sFilterMaterial + ";";
String arSFMaterial[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFilterMaterial.find(sTokenMaterial,0);

	arSFMaterial.append(sTokenMaterial);
}

int arNFilterZone[0];
int nIndex = 0;
String sZones = sFilterZn + ";";
int nToken = 0;
String sToken = sZones.token(nToken);
while( sToken != "" ){
	int nZn = sToken.atoi();
	if( nZn == 0 && sToken != "0" ){
		nToken++;
		sToken = sZones.token(nToken);
		continue;
	}
	if( nZn > 5 )
		nZn = 5 - nZn;	
	arNFilterZone.append(nZn);
	
	nToken++;
	sToken = sZones.token(nToken);
}

String sFOpening = sFilterOpening + ";";
sFOpening.makeUpper();
String arSFOpening[0];
int nIndexOpening = 0; 
int sIndexOpening = 0;
while(sIndexOpening < sFOpening.length()-1){
	String sTokenOpening = sFOpening.token(nIndexOpening);
	nIndexOpening++;
	if(sTokenOpening.length()==0){
		sIndexOpening++;
		continue;
	}
	sIndexOpening = sFilterOpening.find(sTokenOpening,0);

	arSFOpening.append(sTokenOpening);
}

int nOpeningMarks = arSOpeningMarks.find(sOpeningMarks,0);
int nOpeningOutline = arSOpeningOutline.find(sOpeningOutline,1);


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
CoordSys csEl = el.coordSys();

Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);

Display dp(-1);
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

//Vector3d vxMs = _XW;
//vxMs.transformBy(ps2ms);
//vxMs.normalize();
//Vector3d vyMs = _YW;
//vyMs.transformBy(ps2ms);
//vyMs.normalize();
//Vector3d vzMs = _ZW;
//vzMs.transformBy(ps2ms);
//vzMs.normalize();

//Vector3d vx = vxMs;//el.vecX();
//Vector3d vy = vyMs;//el.vecY();
//Vector3d vz = vzMs;//el.vecZ();

Plane pnElZ(ptEl, vzEl);
PlaneProfile ppGBm(csEl);

//region filter genBeams (new)
GenBeam genBeams[] = el.genBeam();
Entity genBeamEntities[0];
for (int b = 0; b < genBeams.length(); b++)
{
	GenBeam genBeam = genBeams[b];
	if ( ! genBeam.bIsValid())
		continue;
	
	genBeamEntities.append(genBeam);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam filteredGenBeams[0];
for (int e = 0; e < filteredGenBeamEntities.length(); e++)
{
	GenBeam genBeam = (GenBeam)filteredGenBeamEntities[e];
	if ( ! genBeam.bIsValid()) continue;
	
	filteredGenBeams.append(genBeam);
	
}
//endregion

//internal filter (old)
GenBeam arGBmAll[0]; arGBmAll.append(filteredGenBeams);
GenBeam arGBm[0];
Point3d arPtGBm[0];

for(int i=0; i<arGBmAll.length(); i++){
	GenBeam gBm = arGBmAll[i];
		
	// apply filters
	String sBmCode = gBm.beamCode().token(0);
	String sLabel = gBm.label();
	String sMaterial = gBm.material();
	int nZnIndex = gBm.myZoneIndex();
	
	if( arSFBC.find(sBmCode) != -1 )
		continue;
	if( arSFLabel.find(sLabel) != -1 )
		continue;
	if( arSFMaterial.find(sMaterial) != -1 )
		continue;
	if( arNFilterZone.find(nZnIndex) != -1 )
		continue;
		
	Body bd = gBm.realBody();
	Point3d arPt[] = bd.allVertices();
	arPtGBm.append(arPt);
	
	if (nOpeningOutline == 1) {
		PlaneProfile ppThisGBm(bd.shadowProfile(pnElZ));
		ppThisGBm.shrink(-U(15));
		ppGBm.unionWith(ppThisGBm);
	}
}

ppGBm.shrink(U(15));

PlaneProfile ppGBmPS = ppGBm;
ppGBmPS.transformBy(ms2ps);
ppGBmPS.vis();

Point3d arPtGBmX[] = lnX.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnY.orderPoints(arPtGBm);

if( arPtGBmX.length() < 1 || arPtGBmY.length() < 1 ){
	return;
}

Point3d ptBR = arPtGBmX[arPtGBmX.length() - 1];
Point3d ptTR = ptBR + vyEl * vyEl.dotProduct(arPtGBmY[arPtGBmY.length() - 1] - ptBR);
ptBR += vyEl * vyEl.dotProduct(arPtGBmY[0] - ptBR);
//extreme points calculated

//Fill array with points for calculation of floorheight.
Point3d arPtHeights[0];
arPtHeights.append(ptBR);
arPtHeights.append(ptTR);

Opening arOp[] = el.opening();
Point3d arPtHeightGaugeOpening[0];
int arBIsTransomOpening[0];
int arBIsOpening[0];
for(int i=0; i<arOp.length(); i++){
	OpeningSF op = (OpeningSF)arOp[i];
	
	String sOpDescription = op.openingDescr();
	sOpDescription.makeUpper();
	int bSkipOpening = false;
	for( int j=0;j<arSFOpening.length();j++ ){
		String sFOpening = arSFOpening[j];
		sFOpening.makeUpper();
		if( sFOpening.left(1) == "*" ){
			sFOpening.trimLeft("*");
			if( sFOpening.right(1) == "*" ){
				sFOpening.trimRight("*");
				if( sOpDescription.find(sFOpening, 0) != -1 ){
					bSkipOpening = true;
					break;
				}
			}
			else{
				if( sOpDescription.right(sFOpening.length()) == sFOpening ){
					bSkipOpening = true;
					break;
				}
			}
		}
		else if( sFOpening.right(1) == "*" ){
			sFOpening.trimRight("*");
			if( sOpDescription.find(sFOpening, 0) == 0 ){
				bSkipOpening = true;
				break;
			}
		}
		else{
			if( sOpDescription == sFOpening ){
				bSkipOpening = true;
				break;
			}
		}	
	}	
	
	if( bSkipOpening )
		continue;

	
	PLine plOp = op.plShape();
	Point3d ptOpM = Body(plOp, vzEl).ptCen();
	
	Point3d ptTop = ptOpM + vyEl * 0.5 * op.height();
	Point3d ptBot = ptOpM - vyEl * 0.5 * op.height();
	Point3d ptLeft = ptOpM - vxEl * 0.5 * op.width();
	Point3d ptRight = ptOpM + vxEl * 0.5 * op.width();

	if (nOpeningOutline == 1) {
		LineSeg openingLineSeg(ptOpM + vyEl * vyEl.dotProduct(ptTR - ptOpM), ptOpM + vyEl * vyEl.dotProduct(ptBR - ptOpM));
		LineSeg segments[] = ppGBm.splitSegments(openingLineSeg, false);
		for (int s=0;s<segments.length();s++) {
			LineSeg segment = segments[s];
			
			if ((vyEl.dotProduct(segment.ptStart() - ptOpM) * vyEl.dotProduct(segment.ptEnd() - ptOpM)) > 0)
				continue;
			
			ptBot = segment.ptEnd();
			ptTop = segment.ptStart();
		}	
	}

	ptBot += vxEl * (vxEl.dotProduct(ptLeft - ptBot) + dDimOffOpening);
	ptTop += vxEl * (vxEl.dotProduct(ptLeft - ptTop) + dDimOffOpening);

	arPtHeightGaugeOpening.append(ptBot);
	arBIsTransomOpening.append(false);
		
	arPtHeightGaugeOpening.append(ptTop);
	arBIsTransomOpening.append(true);
}

//Sort points for floor heights.
for( int i=0;i<arPtHeights.length();i++ )
	arBIsOpening.append(false);
Line lnHeights(ptBR + vxEl * dDimOff, vyEl);
if( nOpeningMarks == 1 ){ // At element side
	arPtHeights.append(arPtHeightGaugeOpening);
	for( int i=0;i<arPtHeightGaugeOpening.length();i++ )
		arBIsOpening.append(true);
}
arPtHeights = lnHeights.projectPoints(arPtHeights);
//order points from bottom to top
for(int s1=1;s1<arPtHeights.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( vyEl.dotProduct(arPtHeights[s11] - arPtHeights[s2]) < 0 ){
			arPtHeights.swap(s2, s11);	
			arBIsOpening.swap(s2, s11);
			
			s11=s2;
		}
	}
}
	
int arBIsTransom[0];
if( nOpeningMarks == 0 ){ // Inside opening
	for( int i=0;i<arPtHeights.length();i++ )
		arBIsTransom.append(false);
	arPtHeights.append(arPtHeightGaugeOpening);
	arBIsTransom.append(arBIsTransomOpening);
	for( int i=0;i<arPtHeightGaugeOpening.length();i++ )
		arBIsOpening.append(true);

}

//Distance to element. 
double dDimLeft = dDimOff;
//Distance to element. 
double dDimBottom = dDimOff;

//Place element height dimensions
double dTextHeight = dp.textHeightForStyle("hsbCAD", sDimStyle);
double dTextLength = dp.textLengthForStyle(el.dFloorGroupHeight() + "+", sDimStyle);
for(int i=0;i<arPtHeights.length();i++){
	Point3d ptHeight = arPtHeights[i];
	int bIsTransom = false;
	if( nOpeningMarks == 0 )
		bIsTransom = arBIsTransom[i];
	int bIsOpening = arBIsOpening[i];
	
	if( bIsOpening && nOpeningMarks == 1 && dExtraDimOffOpening != 0.0 )
		ptHeight += vxEl * dExtraDimOffOpening;
	
	double dFlagY = -1;
	Vector3d vxSymbol = _XW;
	Vector3d vySymbol = _YW;
	if( bIsTransom ){
		dFlagY *= -1;
		vySymbol *= -1;
	}
	Vector3d vzSymbol = _ZW;
	
	double dFloorGroupH = ptEl.Z() + vyEl.dotProduct(ptHeight - ptEl);
	ptHeight.transformBy(ms2ps);
	Point3d ptPoly = ptHeight + vySymbol * 2 * dTextHeight;
	PLine plDimFloorH(vzSymbol);
	plDimFloorH.addVertex(ptPoly);
	plDimFloorH.addVertex(ptPoly - vySymbol * 2 * dTextHeight);
	plDimFloorH.addVertex(ptPoly - vySymbol * dTextHeight - vxSymbol * dTextHeight);
	plDimFloorH.addVertex(ptPoly - vySymbol * dTextHeight + vxSymbol * dTextLength);
	dp.draw(plDimFloorH);
	PLine plFloorH(ptHeight - vxSymbol * dTextHeight, ptHeight + vxSymbol * dTextLength);
	dp.draw(plFloorH);
	String sSign = "+";
	if(dFloorGroupH < 0) 
		sSign = "-";
	String sFloorGroupH;
	sFloorGroupH.formatUnit(abs(dFloorGroupH),2,0);
	dp.draw(sFloorGroupH+sSign , ptPoly + vySymbol * 0.25 * dTextHeight + vxSymbol * 0.25 * dTextHeight , _XW, _YW, 1, dFlagY);
}

#End
#BeginThumbnail





















#End
#BeginMapX

#End