#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
08.08.2018 - version 2.18
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 18
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

/// <version  value="2.17" date="25.06.2018"></version>

/// <history>
/// AS - 1.00 - 12.04.2011 -	Pilot version
/// AS - 1.01 - 12.04.2011 -	Draw always in boundary of viewport
/// AS - 1.02 - 13.04.2011 -	Take index element section if there are no openings available, but only if index is set to 1.
/// AS - 1.03 - 28.04.2011 -	Add selection filters
/// AS - 1.04 - 28.04.2011 -	Add opening information, section takes longest rafter if no opening is found.
/// AS - 1.05 - 28.04.2011 -	Don't draw a cross when there are no openings
/// AS - 1.06 - 24.05.2011 -	Place index text on a specific layer, could be non-plottable.
/// AS - 1.07 - 24.05.2011 -	Opening description in center of opening.
/// AS - 1.08 - 06.07.2011 -	Draw sheet in zone 6 always complete
/// AS - 2.00 - 03.01.2012 -	Move positioning logic to HSB-SectionManager
/// AS - 2.01 - 12.01.2012 -	Set dependency on manager, add filter options
/// AS - 2.02 - 25.01.2012 -	Remove assignent to element.
/// AS - 2.03 - 25.01.2012 -	Draw section index before checking if element is valid.
/// AS - 2.04 - 26.01.2012 -	Store the viewporthandle before returning on an invalid element.
/// AS - 2.05 - 30.01.2012 -	Add filter for sublabel, sublabel 2, material, grade, name
/// AS - 2.06 - 25.04.2012 -	Add thumbnail
/// AS - 2.07 - 23.05.2012 -	Store tsls in this section, draw CNC_DrillElement tsls.
/// AS - 2.08 - 26.09.2012 -	Set ptOpening in center of intersection of bdOp and bdSection.
/// AS - 2.09 - 25.10.2012 -	Use envelopeBody when the volume of the realbody is 0
/// AS - 2.10 - 31.01.2013 -	Use back of element for opening check.
/// AS - 2.11 - 04.02.2013 -	Draw entities with disprep.
/// AS - 2.12 - 08.05.2013 -	Correct beam intersection check
/// AS - 2.13 - 07.04.2014 -	Draw body by extruding the plane profile if the body intersection returns an invalid body.
/// AS - 2.14 - 10.11.2014 -	Store opening information
/// AS - 2.15 - 25.10.2016 -	Add option to visualise drill on specific element layer.
/// AS - 2.16 - 08.06.2017 -	Add a tolerance for the tool body (cnc-drillelement detection).
/// DR - 2.17 - 25.06.2018 - 	Added use of HSB_G-FilterGenBeams.mcr
/// </history>

//Script uses mm
double dEps = U(.001,"mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString genBeamFilterDefinition(23, filterDefinitions, "     "+T("|Filter definition for FilterGenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterSubLabel(13,"","     "+T("|Filter beams and sheets with sublabel|"));
PropString sFilterSubLabel2(14,"","     "+T("|Filter beams and sheets with sublabel 2|"));
PropString sFilterMaterial(15,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterGrade(16,"","     "+T("|Filter beams and sheets with grade|"));
PropString sFilterName(17,"","     "+T("|Filter beams and sheets with name|"));
PropString sFilterHsbId(11,"","     "+T("|Filter beams and sheets with hsbId|"));
PropString sFilterZone(3, "", "     "+T("|Filter zones|"));
PropString sShowOpeningInfo(12, arSYesNo, "     "+T("|Show opening information|"),0);

PropString sSeparator02(4, "", T("|Element|-")+T("|Section|"));
sSeparator02.setReadOnly(true);
PropString sSectionId(5, "A", "     "+T("|Section Id|"));

PropString sSeparator03(6, "", T("|Style|"));
sSeparator03.setReadOnly(true);
PropString sUseDispRep(20, arSYesNo, "     " + T("|Draw beams and sheets using display representations|"),1);
PropString sDispRepBeam(18, Beam().dispRepNames(), "     "+T("|Display representation beams|"));
PropString sDispRepSheet(19, Sheet().dispRepNames(), "     "+T("|Display representation sheets|"));
PropString sDimStyleError(7, _DimStyles, "     "+T("|Dimension style error|"));
PropString sDimStyle(8, _DimStyles, "     "+T("|Dimension style name|"));
PropString sLayeNoPlot(9, "G-Anno-View", "     "+T("|No-plot layer name|"));
PropString sLineType(10, _LineTypes, "     "+T("|Line type|"));
int nDimColor = -1;


PropString sSeparator04(21, "", T("|Drills|"));
sSeparator04.setReadOnly(true);
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};
String arSZoneChar[] = {
	"Zone",
	"Info",
	"Dimension",
	"Tooling"
};
char arChZoneChar[] = {
	'Z',
	'I',
	'D',
	'T'
};
PropInt nZnIndexDrill(0, arNZoneIndex, "     "+T("|Visualisation zone drill|"),10);
nZnIndexDrill.setDescription(T("|Sets the zone index.|")
	+ TN("|The drill is displayed in this zone.|"));

PropString sZoneCharDrill(22, arSZoneChar, "     "+T("|Visualisation layer drill|"),3);
sZoneCharDrill.setDescription(T("|Sets the element layer.|")
	+ TN("|The drill is displayed on the selected element layer.|"));


if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport(TN("|Select a viewport for this section|")));
	_Viewport.append(getViewport(TN("|Select the viewport of the section manager|")));
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
	
	return;
}
//Is there a viewport selected
if( _Viewport.length() < 2 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];
Viewport vpSectionManager = _Viewport[1];

//Coordinate system
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

TslInst sectionManager;
Entity arEnt[] = Group().collectEntities(true, TslInst(), _kMySpace);
for( int i=0;i<arEnt.length();i++ ){
	TslInst tsl = (TslInst)arEnt[i];
	if( !tsl.bIsValid() )
		continue;
	
	Map mapTsl = tsl.map();
	int bIsSectionManager = false;
	if( mapTsl.hasInt("SectionManager") )
		bIsSectionManager = mapTsl.getInt("SectionManager");
	
	if( !bIsSectionManager )
		continue;
	
	sectionManager = tsl;
	break;
}

CoordSys csToSectionManager = vpSectionManager.coordSys();
CoordSys csToSection = csToSectionManager;
csToSection.invert();

Display dp(-1);
dp.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight

Display dpError(1);
dpError.dimStyle(sDimStyleError);

Display dpNoPlot(161);
dpNoPlot.dimStyle(sDimStyle, dVpScale);
dpNoPlot.layer(sLayeNoPlot);

Display dpCross(nDimColor);
dpCross.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight
dpCross.lineType(sLineType);

Point3d ptVpPs = vp.ptCenPS() - _XW * .5 * vp.widthPS() - _YW * .5 * vp.heightPS();
if( !sectionManager.bIsValid() ){
	dpError.draw(T("|No Section Manager Found!|"), vp.ptCenPS(), _XW, _YW, 0, 0);
	return;
}
else{
	_Entity.append(sectionManager);
	setDependencyOnEntity(sectionManager);
	
	dpNoPlot.draw(T("|Section|: ") + sSectionId, ptVpPs, _XW, _YW, 1.1, 1.5);
}

_Pt0 = ptVpPs;

// store the handle to the linked viewport to the map of this tsl. This is used for the dimenioning tsls to find this section tsl
_Map = Map();
_Map.setString("VPHANDLE", vp.viewData().viewHandle());

// check if the viewport has hsb data
Element el = vp.element();
if( !el.bIsValid() )
	return;

//Element coordSys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Plane pnElZMid(ptEl - vzEl * .5 * el.zone(0).dH(), vzEl);
Plane pnElZBack(ptEl - vzEl * el.zone(0).dH(), vzEl);

Element elSectionManager = vpSectionManager.element();
if( !elSectionManager.bIsValid() )
	return;

// resolve props
// selection
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
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
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSFBC.append(sTokenBC);
}
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
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
String sFSubLabel = sFilterSubLabel + ";";
sFSubLabel.makeUpper();
String arSFSubLabel[0];
int nIndexSubLabel = 0; 
int sIndexSubLabel = 0;
while(sIndexSubLabel < sFSubLabel.length()-1){
	String sTokenSubLabel = sFSubLabel.token(nIndexSubLabel);
	nIndexSubLabel++;
	if(sTokenSubLabel.length()==0){
		sIndexSubLabel++;
		continue;
	}
	sIndexSubLabel = sFilterSubLabel.find(sTokenSubLabel,0);

	arSFSubLabel.append(sTokenSubLabel);
}
String sFSubLabel2 = sFilterSubLabel2 + ";";
sFSubLabel2.makeUpper();
String arSFSubLabel2[0];
int nIndexSubLabel2 = 0; 
int sIndexSubLabel2 = 0;
while(sIndexSubLabel2 < sFSubLabel2.length()-1){
	String sTokenSubLabel2 = sFSubLabel2.token(nIndexSubLabel2);
	nIndexSubLabel2++;
	if(sTokenSubLabel2.length()==0){
		sIndexSubLabel2++;
		continue;
	}
	sIndexSubLabel2 = sFilterSubLabel2.find(sTokenSubLabel2,0);

	arSFSubLabel2.append(sTokenSubLabel2);
}
String sFMaterial = sFilterMaterial + ";";
sFMaterial.makeUpper();
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
String sFGrade = sFilterGrade + ";";
sFGrade.makeUpper();
String arSFGrade[0];
int nIndexGrade = 0; 
int sIndexGrade = 0;
while(sIndexGrade < sFGrade.length()-1){
	String sTokenGrade = sFGrade.token(nIndexGrade);
	nIndexGrade++;
	if(sTokenGrade.length()==0){
		sIndexGrade++;
		continue;
	}
	sIndexGrade = sFilterGrade.find(sTokenGrade,0);

	arSFGrade.append(sTokenGrade);
}
String sFName = sFilterName + ";";
sFName.makeUpper();
String arSFName[0];
int nIndexName = 0; 
int sIndexName = 0;
while(sIndexName < sFName.length()-1){
	String sTokenName = sFName.token(nIndexName);
	nIndexName++;
	if(sTokenName.length()==0){
		sIndexName++;
		continue;
	}
	sIndexName = sFilterName.find(sTokenName,0);

	arSFName.append(sTokenName);
}
String sFHsbId = sFilterHsbId + ";";
sFHsbId.makeUpper();
String arSFHsbId[0];
int nIndexHsbId = 0; 
int sIndexHsbId = 0;
while(sIndexHsbId < sFHsbId.length()-1){
	String sTokenHsbId = sFHsbId.token(nIndexHsbId);
	nIndexHsbId++;
	if(sTokenHsbId.length()==0){
		sIndexHsbId++;
		continue;
	}
	sIndexHsbId = sFilterHsbId.find(sTokenHsbId,0);

	arSFHsbId.append(sTokenHsbId);
}

int arNFilterZone[0];
int nIndex = 0;
String sZones = sFilterZone + ";";
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

int bShowOpeningInfo = arNYesNo[arSYesNo.find(sShowOpeningInfo,0)];
int bUseDispRep = arNYesNo[arSYesNo.find(sUseDispRep,1)];

char chZoneCharDrill = arChZoneChar[arSZoneChar.find(sZoneCharDrill,0)];
int nZoneIndexDrill = nZnIndexDrill;
if (nZoneIndexDrill > 5)
	nZoneIndexDrill = 5 - nZoneIndexDrill;

Map mapSectionManager = sectionManager.map();
Map mapSections = mapSectionManager.getMap(el.handle());
Map section;
for( int i=0;i<mapSections.length();i++ ){
	if( !mapSections.hasMap(i) || mapSections.keyAt(i) != "ElementSection" )
		continue;
	
	Map mapSection = mapSections.getMap(i);
	String sId = mapSection.getString("Id");
	if( sId != sSectionId )
		continue;
	
	section = mapSection;	
	break;
}

if( section.length() == 0 )
	return;

Point3d ptSection = section.getPoint3d("PtOrg");
Vector3d vSectionNormal = section.getVector3d("Normal");
double dSectionDepth = section.getDouble("Depth");

ptSection.transformBy(csToSection);
vSectionNormal.transformBy(csToSection);
vSectionNormal.normalize();

Vector3d vxMs = _XW;
vxMs.transformBy(ps2ms);
vxMs.normalize();
Vector3d vyMs = _YW;
vyMs.transformBy(ps2ms);
vyMs.normalize();
Vector3d vzMs = _ZW;
vzMs.transformBy(ps2ms);
vzMs.normalize();

if( abs(abs(vzMs.dotProduct(vSectionNormal)) - 1) > dEps )
	return;

Point3d ptMs = vp.ptCenPS();
ptMs.transformBy(ps2ms);

PLine plViewport(_ZW);
plViewport.addVertex(vp.ptCenPS() - _XW * 0.5 * vp.widthPS() + _YW * 0.5 * vp.heightPS());
plViewport.addVertex(vp.ptCenPS() - _XW * 0.5 * vp.widthPS() - _YW * 0.5 * vp.heightPS());
plViewport.addVertex(vp.ptCenPS() + _XW * 0.5 * vp.widthPS() - _YW * 0.5 * vp.heightPS());
plViewport.addVertex(vp.ptCenPS() + _XW * 0.5 * vp.widthPS() + _YW * 0.5 * vp.heightPS());
plViewport.close();
plViewport.transformBy(ps2ms);
plViewport.transformBy(vzMs * vzMs.dotProduct(ptSection - ptMs));

Body bdSection(plViewport, vSectionNormal * dSectionDepth, 0);

Display dpSection(-1);

//region filter genBeams (external filter)
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
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam filteredGenBeams[0];
for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam genBeam = (GenBeam)filteredGenBeamEntities[e];
	if (!genBeam.bIsValid()) continue;
	
	filteredGenBeams.append(genBeam);
}
//endregion

//All genbeams (internal filter, after external filter)
GenBeam arGBmAll[0]; arGBmAll.append(filteredGenBeams);
Beam arBm[0];
Beam arBmVertical[0];
Beam arBmHorizontal[0];
Sheet arSh[0];
GenBeam arGBm[0];
for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	if( bm.bIsDummy() )
		continue;
	
	// apply filters
	String sBmCode = gBm.beamCode().token(0);
	String sLabel = gBm.label();
	String sSubLabel = gBm.subLabel();
	String sSubLabel2 = gBm.subLabel2();
	String sMaterial = gBm.material();
	String sGrade = gBm.grade();
	String sName = gBm.name();
	String sHsbId = gBm.hsbId();
	int nZnIndex = gBm.myZoneIndex();
	if( arSFBC.find(sBmCode) != -1 )
		continue;
	if( arSFLabel.find(sLabel) != -1 )
		continue;
	if( arSFSubLabel.find(sSubLabel) != -1 )
		continue;
	if( arSFSubLabel2.find(sSubLabel2) != -1 )
		continue;
	if( arSFMaterial.find(sMaterial) != -1 )
		continue;
	if( arSFGrade.find(sGrade) != -1 )
		continue;
	if( arSFName.find(sName) != -1 )
		continue;
	if( arSFHsbId.find(sHsbId) != -1 )
		continue;
	if( arNFilterZone.find(nZnIndex) != -1 )
		continue;
	
	if( sh.bIsValid() ){
		arSh.append(sh);
	}
	else if( bm.bIsValid() ){
		arBm.append(bm);
		if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps )
			arBmVertical.append(bm);
		if( abs(abs(bm.vecX().dotProduct(vxEl)) - 1) < dEps )
			arBmHorizontal.append(bm);
	}

	arGBm.append(gBm);
}

for( int j=0;j<arGBm.length();j++ ){
	GenBeam gBm = arGBm[j];
	Body bdGBm = gBm.realBody();
	if( bdGBm.volume() < U(1) )
		bdGBm = gBm.envelopeBody(true, true);
	bdGBm.vis();
	
	if( bdGBm.hasIntersection(bdSection) ){
		bdGBm.intersectWith(bdSection);
		if( bdGBm.volume() < U(1) ){
			PlaneProfile ppGBm = gBm.realBody().getSlice(Plane(bdSection.ptCen(), vSectionNormal));
			PLine arPlGBm[] = ppGBm.allRings();
			int arBRingIsOpening[] = ppGBm.ringIsOpening();
			Body bd;
			for( int k=0;k<arPlGBm.length();k++ ){
				PLine pl = arPlGBm[k];
				int bIsOpening = arBRingIsOpening[k];
				
				Body bdThis(pl, vSectionNormal * dSectionDepth, 0);
				if( bIsOpening )
					bd.subPart(bdThis);
				else
					bd.addPart(bdThis);
			}
			bdGBm = bd;
		}
		dpSection.color(gBm.color());
		dpSection.elemZone(el, gBm.myZoneIndex(), 'Z');
		
		bdGBm.transformBy(ms2ps);		
		if( bUseDispRep && gBm.bIsA(Beam()) )
			dpSection.draw((Entity)gBm, ms2ps, sDispRepBeam);
		else if( bUseDispRep && gBm.bIsA(Sheet()) )
			dpSection.draw((Entity)gBm, ms2ps, sDispRepSheet);
		else
			dpSection.draw(bdGBm);
		
		_Map.appendEntity("GENBEAM", gBm);
	}
}

TslInst arTsl[] = el.tslInst();
TslInst arTslDrill[0];
Body copySection = bdSection;
copySection.transformBy(vSectionNormal * 0.5 * el.dBeamHeight());
Body toolSection = copySection;
copySection.transformBy(-vSectionNormal * el.dBeamHeight());
toolSection.addPart(copySection);
for( int i=0;i<arTsl.length();i++ ){
	TslInst tsl = arTsl[i];
	if( !tsl.bIsValid() ){
		tsl.dbErase();
		continue;
	}
	
	Point3d arPtTsl[0];
	arPtTsl.append(tsl.ptOrg());
	arPtTsl.append(tsl.gripPoints());
	
	for( int j=0;j<arPtTsl.length();j++ ){
		Point3d pt = arPtTsl[j];
		Body bdPt(pt, vxEl, vyEl, vzEl);
		bdPt.vis(1);
		bdSection.vis(3);
		if( bdPt.hasIntersection(toolSection) ){
			_Map.appendEntity("TslInst", tsl);
			
			if( tsl.scriptName().makeUpper() == "CNC_DRILLELEMENT" )
				arTslDrill.append(tsl);
			
			break;
		}
	}
}

for( int i=0;i<arTslDrill.length();i++ ){
	TslInst tsl = arTslDrill[i];
	Point3d ptDrillSt = tsl.ptOrg();
	Point3d ptDrillEnd = tsl.gripPoint(0);	
	
	PLine plDrillSt(vzEl);
	plDrillSt.createCircle(ptDrillSt, vzEl, U(12.5));
	PLine plDrillEnd(vzEl);
	plDrillEnd.createCircle(ptDrillEnd, vzEl, U(12.5));
	PLine plLine(ptDrillSt, ptDrillEnd);
	
	dpSection.color(1);
	dpSection.elemZone(el, nZoneIndexDrill, chZoneCharDrill);
	plDrillSt.transformBy(ms2ps);
	plDrillEnd.transformBy(ms2ps);	
	dpSection.draw(plDrillSt);
	dpSection.draw(plDrillEnd);
	dpSection.color(7);
	plLine.transformBy(ms2ps);
	dpSection.draw(plLine);
}

if( bShowOpeningInfo ){
	// Find the openings
	PlaneProfile ppEl(csEl);
	ppEl = el.profNetto(0);
	PLine arPlEl[] = ppEl.allRings();
	int arIsOpening[] = ppEl.ringIsOpening();
	
	Group grpEl = el.elementGroup();
	Group grpFloor(grpEl.namePart(0), grpEl.namePart(1), "" );
	Entity arEntOpRf[] = grpFloor.collectEntities(true, OpeningRoof(), _kModelSpace);
	Point3d arPtOpeningSection[0];
	Vector3d arVNormalOpeningSection[0];
	double arDOpeningSectionDepth[0];
	for( int i=0;i<arEntOpRf.length();i++ ){
		Entity ent = arEntOpRf[i];
		OpeningRoof opRf = (OpeningRoof)ent;
		if( !opRf.bIsValid() )
			continue;
		
		Point3d ptOpRf = Body(opRf.plShape(), _ZW).ptCen();
		Line lnOpRfZ(ptOpRf, _ZW);
		ptOpRf = lnOpRfZ.intersect(pnElZBack,U(0));

PLine q = opRf.plShape();
q.projectPointsToPlane(Plane(ptEl, vzEl), _ZW);
q.transformBy(csToSectionManager);
q.vis();
		
		for( int j=0;j<arPlEl.length();j++ ){
			int isOpening = arIsOpening[j];
			if( !isOpening )
				continue;
			PLine plOp = arPlEl[j];
			
			PlaneProfile ppOp(csEl);
			ppOp.joinRing(plOp, _kAdd);
			
			if( ppOp.pointInProfile(ptOpRf) == _kPointInProfile ){
				Body bdOp(plOp, vzEl, 0);
				if( !bdOp.hasIntersection(bdSection) )
					continue;
				
				bdOp.intersectWith(bdSection);
				
				Beam arBmSection[0];
				Vector3d vSection = vyEl;
				Vector3d vyElPs = vyEl;
				vyElPs.transformBy(ms2ps);
				vyElPs.normalize();
				if( abs(abs(vyElPs.dotProduct(_ZW)) - 1) < dEps ){
					vSection = vxEl;
					arBmSection.append(arBmVertical);
				}
				else{
					arBmSection.append(arBmHorizontal);
				}
				
				Vector3d vxTxt = vSection;
				vxTxt.transformBy(ms2ps);
				vxTxt.normalize();
				if( vxTxt.dotProduct(_XW + _YW) < 0 )
					vxTxt *= -1;
				Vector3d vyTxt = _ZW.crossProduct(vxTxt);

				Point3d ptOpening = Line(bdOp.ptCen(), vSection).intersect(Plane(ptOpRf, vSection), 0);
				Point3d p = ptOpening;
				p.transformBy(csToSectionManager);
				p.vis(1);
				Vector3d v = vSection;
				v.transformBy(csToSectionManager);
				v.vis(p,150);
				
				for( int q=0;q<arBmSection.length();q++){
					Point3d b = arBmSection[q].ptCen();
					b.transformBy(csToSectionManager);
					b.vis(q);
				}

				Point3d ptCheckBeamIntersection = ptOpening + vzEl * vzEl.dotProduct(ptEl - vzEl * 0.5 * el.zone(0).dH() - ptOpening);
				Point3d pb = ptCheckBeamIntersection;
				pb.transformBy(csToSectionManager);
				pb.vis(3);
				
				Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmSection, ptCheckBeamIntersection, -vSection);
				Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmSection, ptCheckBeamIntersection, vSection);
				
				if( arBmBottom.length() * arBmTop.length() > 0 ){
					Beam bmBottom = arBmBottom[0];
					Beam bmTop = arBmTop[0];
					
					Point3d b = bmBottom.ptCen();
					b.transformBy(csToSectionManager);
					b.vis(3);
					
					Vector3d vyBmTop = bmTop.vecY();
					if( vyBmTop.dotProduct(vSection) < 0 )
						vyBmTop *= -1;
					if( abs(vSection.dotProduct(vyBmTop)) < dEps )
						vyBmTop = bmTop.vecD(vSection);
					Plane pnTop(bmTop.ptCen() - vyBmTop * .5 * bmTop.dD(vyBmTop), vyBmTop);
						
					Vector3d vyBmBottom = bmBottom.vecY();
					if( vyBmBottom.dotProduct(vSection) < 0 )
						vyBmBottom *= -1;
					if( abs(vSection.dotProduct(vyBmBottom)) < dEps )
						vyBmBottom = bmBottom.vecD(vSection);
					Plane pnBottom(bmBottom.ptCen() + vyBmBottom * .5 * bmBottom.dD(vyBmBottom), vyBmBottom);
					
					
					Line lnFront(ptSection + vzEl * vzEl.dotProduct(ptEl - ptSection), vSection);
					Line lnBack(ptSection + vzEl * vzEl.dotProduct((ptEl - vzEl * el.zone(0).dH()) - ptSection), vSection);
					
					Point3d ptBottomFront = lnFront.intersect(pnBottom,0);
					Point3d ptBottomBack = lnBack.intersect(pnBottom,0);
					Point3d ptTopBack = lnBack.intersect(pnTop,0);
					Point3d ptTopFront = lnFront.intersect(pnTop,0);
					
					PLine plTF2BB(ptTopFront, ptBottomBack);
					PLine plTB2BF(ptTopBack, ptBottomFront);
					plTF2BB.transformBy(ms2ps);
					plTB2BF.transformBy(ms2ps);
					dpCross.draw(plTF2BB);
					dpCross.draw(plTB2BF);
					
					PLine plTF2BF(ptTopFront, ptBottomFront);
					PLine plTB2BB(ptTopBack, ptBottomBack);
					plTF2BF.transformBy(ms2ps);
					plTB2BB.transformBy(ms2ps);
					dp.draw(plTF2BF);
					dp.draw(plTB2BB);
					
					Point3d ptOpDescription = (ptTopFront + ptBottomBack)/2;
					ptOpDescription.transformBy(ms2ps);
					
					dp.draw(opRf.description(), ptOpDescription, vxTxt, vyTxt, 0, 0);
					
					_Map.appendEntity("OpeningRoof", opRf);
				}
			}
		}	
	}
}

Opening arOp[] = el.opening();
for (int i=0;i<arOp.length();i++) {
	Opening op = arOp[i];
	Body bdOp(op.plShape(), vzEl, 0);
	if (bdOp.hasIntersection(bdSection))
		_Map.appendEntity("Opening", op);
}


TrussEntity entTrussAll[0];
Group grpElement=el.elementGroup();
Entity entElement[]=grpElement.collectEntities(false,TrussEntity(),_kModelSpace);
for(int e=0;e<entElement.length();e++)
{
	//Get the truss entity
	TrussEntity truss=(TrussEntity)entElement[e];
	if(!truss.bIsValid()) continue;
	entTrussAll.append(truss);
}


for( int j=0;j<entTrussAll.length();j++ )
{
	TrussEntity truss = entTrussAll[j];
	if(!truss.bIsValid()) continue;
	
	CoordSys csTruss=truss.coordSys();
	csTruss.vis();
	//Definition
	String sDefinition=truss.definition();
	TrussDefinition trussDef(sDefinition);
	Entity entitiesForTruss[]=trussDef.entity();
	int nEntityColors[0];
	Body bdTruss;
	Body bdTrussEntities[0];
		
	for(int b=0;b<entitiesForTruss.length();b++)
	{
		Entity ent=entitiesForTruss[b];
		if(!ent.bIsValid()) continue;
		
		Body bd=ent.realBody();
		CoordSys csTransform;
		Point3d pt(0,0,0);
		csTransform.setToAlignCoordSys(pt,_XW,_YW,_ZW, csTruss.ptOrg(),csTruss.vecX(),csTruss.vecY(),csTruss.vecZ());
		bd.transformBy(csTransform);
		bdTrussEntities.append(bd);
		bdTruss.combine(bd);
		
		nEntityColors.append(ent.color());
	}
	
	if( bdTruss.volume() < U(1) )
	{
		//Ignore trusses that have no shape
		continue;
	}
	bdSection.vis();
	bdTruss.vis();
	if ( bdTruss.hasIntersection(bdSection) )
	{
		for (int t = 0; t < bdTrussEntities.length(); t++)
		{
			Body bdTrussEntity = bdTrussEntities[t];
			bdTrussEntity.vis();
			if ( bdTrussEntity.volume() < U(1) )
			{
				continue;
			}
			int& nColor = nEntityColors[t];
			
			dpSection.color(nColor);
			dpSection.elemZone(el, truss.myZoneIndex(), 'Z');
			
			bdTrussEntity.transformBy(ms2ps);
			dpSection.draw(bdTrussEntity);
		}
		
		_Map.appendEntity("TRUSSENTITY", truss);
	}
}
#End
#BeginThumbnail
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
=H`2BEHH`2BEHH#02BEHH#02BEHH#02BEHH#0_]E:
`













#End
#BeginMapX

#End