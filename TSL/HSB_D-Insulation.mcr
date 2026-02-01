#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
28.06.2018 - version 1.03

Description
This tsl add dimension lines for the insulation. It provides the user with the option to add an extra width to the insulation.
E.g.: When there is 600 mm between two studs the dimension line could show 605 mm.
 
Insert
A viewport has to be selected when the tsl is inserted. The user also has to pick a position. The name of the tsl is drawn at this position. So a location outside the printarea is preferred.
 
Remarks
The tsl can only be used to dimension insulation between vertical oriented beams. 
E.g.: Studs in a wall, or rafters in a roof element.



































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl add dimension lines for the insulation. It provides the user with the option to add an extra width to the insulation.
/// E.g.: When there is 600 mm between two studs the dimension line could show 605 mm.
/// </summary>

/// <insert>
/// A viewport has to be selected when the tsl is inserted. 
/// The user also has to pick a position. The name of the tsl is drawn at this position. So a location outside the printarea is preferred.
/// </insert>

/// <remark Lang=en>
/// The tsl can only be used to dimension insulation between vertical oriented beams. 
/// E.g.: Studs in a wall, or rafters in a roof element.
/// </remark>

/// <custom Lang=en>
/// There are some custom options to filter the dimension from a particular element.
/// </custom>
/// <version  value="1.02" date="09.02.2012"></version>

/// <history>
/// AS - 1.00 - 06.02.2012 -	First revision
/// AS - 1.01 - 08.02.2012 -	First revision
/// AS - 1.02 - 09.02.2012 -	Find extremes in vp directions
/// DR - 1.03 - 28.06.2018	- Added use of HSB_G-FilterGenBeams.mcr
/// </history>

double dEps = U(0.01,"mm"); // script uses mm

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

/// - Filter -
///
PropString sSeperator01(0, "", T("|Filter|"));
sSeperator01.setReadOnly(true);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");
PropString genBeamFilterDefinition(14, filterDefinitions, "     "+T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(3,"","     "+T("|Filter beams and sheets with material|"));


/// - Dimension object -
/// 
PropString sSeperator02(4, "", T("|Dimension object|"));
sSeperator02.setReadOnly(true);
String sArObject[]={
	T("|Insulation|")
};
PropString sObject(5,sArObject,"     "+T("|Dimension object|"));
PropDouble dAddExtraSize(0, U(5), "     "+T("|Extra width for insulation|"));
PropDouble dMinimumSize(3, U(5), "     "+T("|Ignore dimensions smaller than|"));

/// - Positioning -
PropString sSeperator03(6, "", T("|Positioning|"));
sSeperator03.setReadOnly(true);
//Used to set the distance to the element.
PropString sUsePSUnits(7, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropDouble dDimLineOffset(1, U(300),"     "+T("|Offset dimension line|"));
PropDouble dTextOffset(2, U(100),"     "+T("|Offset text|"));
//Used to set the dimension line to specific side of the element.
String arSPosition[] = {
	T("|Horizontal bottom|"),
	T("|Horizontal top|")
};
PropString sPosition(8,arSPosition,"     "+T("|Position|"));


/// - Style -
/// 
PropString sSeperator04(9, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropString sDeltaOnTop(10, arSYesNo, "     "+T("|Delta on top|"),0);
PropString sDimStyle(11,_DimStyles,"     "+T("|Dimension style|"),1);

//Used to set the dimension Method
String arSDimMethod[] ={
	T("|Delta perpendicular|"),
	T("|Delta parallel|")
};
int arNDimMethodDelta[] = {_kDimPerp, _kDimPar};
int arNDimMethodCum[] = {_kDimNone,_kDimNone};
PropString sDimMethod(12,arSDimMethod,"     "+T("|Dimension method|"));

PropString sDescription(13, "", "     "+T("|Description|"));

if (_bOnInsert) {
	Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
	_Viewport.append(vp);
	_Pt0 = getPoint(T("|Select a position|"));
	
	showDialogOnce();
	return;
}

// do something for the last appended viewport only
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];
Element el = vp.element();

String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


Display dpName(-1);
dpName.textHeight(U(5));
dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

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
		dpName.color(1);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(30);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSExcludeBmCode[0];
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
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSExcludeBmCode.append(sTokenBC);
}

String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSExcludeLabel[0];
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

	arSExcludeLabel.append(sTokenLabel);
}

String sFMaterial = sFilterMaterial + ";";
sFMaterial.makeUpper();
String arSExcludeMaterial[0];
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

	arSExcludeMaterial.append(sTokenMaterial);
}

int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimLineOffset;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;
double dOffsetText = dTextOffset;
if( bUsePSUnits )
	dOffsetText *= dVpScale;
int nPosition = arSPosition.find(sPosition,0);
int nDimMethodDelta = arNDimMethodDelta[arSDimMethod.find(sDimMethod,0)];
int nDimMethodCum = arNDimMethodCum[arSDimMethod.find(sDimMethod,0)];
int nDeltaOnTop = arNYesNo[arSYesNo.find(sDeltaOnTop,0)];

// Coordinate systems in use
// Element
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnXEl(ptEl, vxEl);
Line lnYEl(ptEl, vyEl);
Plane pnZEl(ptEl, vzEl);

// Paperspace x-y-z transformed to modelspace
Vector3d vxms = _XW;
vxms.transformBy(ps2ms);
vxms.normalize();
Vector3d vyms = _YW;
vyms.transformBy(ps2ms);
vyms.normalize();
Vector3d vzms = _ZW;
vzms.transformBy(ps2ms);
vzms.normalize();

Line lnX(ptEl, vxms);
Line lnY(ptEl, vyms);

// Display
Display dpDim(-1);
dpDim.dimStyle(sDimStyle, dVpScale);

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
Beam arBm[0];
Point3d arPtGBm[0];
for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	
	String sBmCode = gBm.beamCode().token(0);
	sBmCode.trimLeft();
	sBmCode.trimRight();
	if( arSExcludeBmCode.find(sBmCode) != -1 )
		continue;
	
	String sLabel = gBm.label();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( arSExcludeLabel.find(sLabel) != -1 )
		continue;
	
	String sMaterial = gBm.material();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( arSExcludeMaterial.find(sMaterial) != -1 )
		continue;
		
	Beam bm = (Beam)gBm;
	if( bm.bIsValid() )
		arBm.append(bm);
		
	arPtGBm.append(gBm.envelopeBody(true, true).allVertices());
}
Beam arBmVertSorted[] = vxEl.filterBeamsPerpendicularSort(arBm);


// Find the element extremes for this viewport
Point3d arPtGBmX[] = lnX.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnY.orderPoints(arPtGBm);
if( arPtGBmX.length() * arPtGBmY.length() == 0 )
	return;
Point3d ptLeft = arPtGBmX[0];
Point3d ptRight = arPtGBmX[arPtGBmX.length() - 1];
Point3d ptBottom = arPtGBmY[0];
Point3d ptTop = arPtGBmY[arPtGBmY.length() - 1];
Point3d ptTL = ptLeft + vyms * vyms.dotProduct(ptTop - ptLeft);
Point3d ptBL = ptLeft + vyms * vyms.dotProduct(ptBottom - ptLeft);
Point3d ptBR = ptRight + vyms * vyms.dotProduct(ptBottom - ptRight);
Point3d ptTR = ptRight + vyms * vyms.dotProduct(ptTop - ptRight);

Point3d pt = ptBL;
pt.transformBy(ms2ps);
pt.vis(1);

// Set position and vectors for dimension lines
Point3d ptDim = ptBL;
Vector3d vxDim = vxms;
Vector3d vyDim = vyms;
Vector3d vOffsetDim = -vyDim;

if( nPosition == 1){//hor.top
	ptDim = ptTL;
	vOffsetDim = vyDim;
}
Line lnDim(ptDim, vxDim);
ptDim += vOffsetDim * dOffsetDim - vxDim * dOffsetText;

PlaneProfile ppInsulation = el.profBrutto(0);
ppInsulation.shrink(-U(100));

for( int i=0;i<arBmVertSorted.length();i++ ){
	Beam bm = arBmVertSorted[i];
	PlaneProfile ppBm = bm.envelopeBody(false, true).extractContactFaceInPlane(pnZEl, U(10));
	ppInsulation.subtractProfile(ppBm);
}
ppInsulation.shrink(-U(5));
ppInsulation.shrink(U(5));

PlaneProfile p = ppInsulation;
p.transformBy(ms2ps);
p.vis(1);

PLine arPlInsulation[] = ppInsulation.allRings();
int arBRingIsOpening[] = ppInsulation.ringIsOpening();

Point3d arPtStartStudArea[0];
Point3d arPtEndStudArea[0];
for( int i=0;i<arPlInsulation.length();i++ ){
	int bRingIsOpening = arBRingIsOpening[i];
	if( !bRingIsOpening )
		continue;
	
	PLine plStudArea = arPlInsulation[i];
	Point3d arPtStudArea[] = plStudArea.vertexPoints(true);
	Point3d arPtStudAreaX[] = lnXEl.projectPoints(arPtStudArea);
	arPtStudAreaX = lnXEl.orderPoints(arPtStudAreaX);
	
	if( arPtStudAreaX.length() < 2 )
		continue;
	
	arPtStartStudArea.append(arPtStudAreaX[0]);
	arPtEndStudArea.append(arPtStudAreaX[arPtStudAreaX.length() - 1]);
}
arPtStartStudArea = lnXEl.orderPoints(arPtStartStudArea);
arPtEndStudArea = lnXEl.orderPoints(arPtEndStudArea);
if( arPtStartStudArea.length() == 0 || arPtEndStudArea.length() == 0 || arPtStartStudArea.length() != arPtEndStudArea.length() )
	return

for( int i=0;i<(arPtStartStudArea.length() - 1);i++ ){
	Point3d arPtDim[] = {
		arPtEndStudArea[i],
		arPtStartStudArea[i+1]
	};
	
	arPtDim = lnDim.projectPoints(arPtDim);
	
	double dInsulation = vxDim.dotProduct(arPtDim[1] - arPtDim[0]);
	if( dInsulation <= dMinimumSize )
		continue;
	dInsulation += dAddExtraSize;
	String sInsulation;
	sInsulation.formatUnit(dInsulation, 2, 0);
	
	DimLine dimLine(ptDim, vxDim, vyDim);
	Dim dim(dimLine, arPtDim, sInsulation, "<>", nDimMethodDelta, nDimMethodCum);
	dim.setDeltaOnTop(nDeltaOnTop);
	dim.transformBy(ms2ps);
	dpDim.draw(dim);
}

Point3d ptTxt = ptDim;
ptTxt.transformBy(ms2ps);
Vector3d vxTxt = vxDim;
vxTxt.transformBy(ms2ps);
Vector3d vyTxt = vyDim;
vyTxt.transformBy(ms2ps);

dpDim.draw(sDescription, ptTxt, vxTxt, vyTxt, -1, 0);




#End
#BeginThumbnail
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
`




#End
#BeginMapX

#End