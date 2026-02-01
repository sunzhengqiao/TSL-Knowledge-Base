#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
03.07.2018 - version 2.06

Dimensions the beams of a module. The origin point of the dimension is the point closest to the insertion point of this tsl. 
This tsl can be added to a shopdraw layout, modelspace or paperspace. 
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Dimensions the beams of a module. The origin point of the dimension is the point closest to the insertion point of this tsl. 
/// This tsl can be added to a shopdraw layout, modelspace or paperspace. 
/// </summary>

/// <insert>
/// Select a position and an element, viewport or shopdrawview
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="2.05" date="11.03.2015"></version>

/// <history>
/// KR - 1.00 - 28.01.2008 	- Pilot version
/// KR - 1.01 - 28.01.2008 	- Pilot version
/// KR - 1.02 - 28.01.2008 	- Pilot version
/// AS - 2.00 - 27.11.2013 	- Add filter options, rename tsl, group props
/// AS - 2.01 - 20.02.2014 	- Only show dimline when there are points to dimension.
///									- Add filter for multiple beam id's.
/// AS - 2.02 - 20.02.2014 	- Add context menu optio to show the list of beamtypes.
/// AS - 2.03 - 24.03.2014 	- Bugfix type filter
/// AS - 2.04 - 25.03.2014 	- Add reference object
/// AS - 2.05 - 11.03.2015 	- Respect filter in all occasions
/// DR - 2.06 - 03.07.2018	- Added use of HSB_G-FilterGenBeams.mcr
/// </history>

double dEps = Unit(0.01,"mm");


String sModelSpace = T("|model space|");
String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = {sModelSpace , sPaperSpace , sShopdrawSpace };

String arSInExclude[] = {T("|Include|"), T("|Exclude|")};

String sArShowOpening[] = {
	T("|yes|"), 
	T("|no|"), 
	T("|yes|") + " + " + T("|dimension line|"), 
	T("|no|") + " + " + T("|dimension line|")
};

int kHorizontal=0, kVertical = 1;
String sArDirection[] = { T("|horizontal|"), T("|vertical|") };

String sArPointType[]={T("|left|"),T("|center|"),T("|right|"), T("|left and right|"), T("|maximum|")};
int nArPointType[]={_kLeft, _kCenter, _kRight, _kLeftAndRight, _kLeftAndRight};

String sAr2[] = {
	T("|delta perpendicular|"),
	T("|delta parallel|"),
	T("|running perpendicular|"),
	T("|running parallel|"), 
	T("|both perpendicular|"),
	T("|both parallel|"), 
	T("|delta parallel, running perpendicular|"), 
	T("|delta perpendicular, running parallel|")
	};
int nAr2Delta[] = {_kDimPerp, _kDimPar,0,0,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nAr2Cum[] = {0,0,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};
String sArNoYes[] = { T("|no|"), T("|yes|") };



PropString sSeperator01(0, "", T("|Selected space|"));
sSeperator01.setReadOnly(true);
PropString sSpace(1,sArSpace,"     "+T("|Drawing space|"));


PropString sSeperator02(2, "", T("|Selection|"));
sSeperator02.setReadOnly(true);
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

PropString genBeamFilterDefinition(21, filterDefinitions, "     "+T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sInExcludeFilters(3, arSInExclude, "     "+T("|Include|")+T("/|exclude|"),1);
PropString sFilterBC(4,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(5,"","     "+T("|Filter beams with label|"));
PropString sFilterType(6, _BeamTypes, "     "+T("|Filter beams with beam type|"));
PropString sFilterBmTypeID(16, "", "     "+T("|Filter beams with beam type id|"));
sFilterBmTypeID.setDescription(T("|Specify a list of beam type Id's, seperated by| ';'"));
PropDouble dWidthSmallerThan(0, U(0), "     "+T("|Filter beams with a width smaller than|"));
dWidthSmallerThan.setDescription(T("|This value will only be used if its greater than zero|"));


PropString sSeperator03(7, "", T("|Dimension object|"));
sSeperator03.setReadOnly(true);
PropString sShowOpening(8, sArShowOpening, "     "+T("|Opening dimension|"),1);


PropString sSeperator04(9, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropString sDirection(10,sArDirection,"     "+T("|Dimension direction|"));
PropString sPointType(11,sArPointType,"     "+T("|Beam points|"));
PropString sCombineTouchingBeams(12, sArNoYes, "     "+T("|Combine touching beams|"));
PropString s2(13,sAr2,"     "+T("|Orientation|"));
PropString sDeltaOnTop(14, sArNoYes, "     "+T("|Delta on top|"),1);
PropString sDimStyle(15,_DimStyles,"     "+T("|Dimension style|"));
PropInt nDimColor(0,92,"     "+T("|Color|"));

PropString sSeperator05(17, "", T("|Reference|"));
sSeperator05.setReadOnly(true);
String arSReferenceObject[] = {
	T("|No reference|"),
	T("|Beam with beam type|")
};
PropString sReferenceObject(18, arSReferenceObject, "     "+T("|Reference object|"));
PropString sReferenceBeamType(19, _BeamTypes, "     "+T("|Reference beam type|"));
PropString sPointTypeReference(20, sArPointType, "     "+T("|Reference points|"));

String arSTrigger[] = {
	T("|Show list of beam types|")
};

for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

if( _kExecuteKey == arSTrigger[0] ){
	reportNotice(TN("|Beam types|"));
	reportNotice("\n--------------------");
	for( int i=0;i<_BeamTypes.length();i++ )
		reportNotice("\n"+i+": "+_BeamTypes[i]);
}



// ---------------------------------------------------------

if (_bOnInsert) {
	if (insertCycleCount()>1) { eraseInstance(); return; } // only insert once
	showDialog();
  _Pt0 = getPoint(T("|Select location of dim line|")); // select point

	if (sSpace==sModelSpace) {
		Element el = getElement	();
		_Element.append(el);
	}
	else if (sSpace==sPaperSpace){
  		Viewport vp = getViewport(T("|Select the viewport from which the element is taken|")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace==sShopdrawSpace){
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}

	return;
}

// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
{
	if (_Viewport.length()>0)
		sSpace.set(sPaperSpace);
	else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
		sSpace.set(sShopdrawSpace);
	else
		sSpace.set(sModelSpace);
	sSpace.setReadOnly(TRUE);
}

int bError = 0; // 0 means FALSE = no error

// set of variables that change depending on the type of space
CoordSys ms2ps; // default to identity transformation
GenBeam arGBeam[0];
Element el;

if (sSpace==sShopdrawSpace) 
{
	ShopDrawView sv;
	if (_Entity.length()>0) sv = (ShopDrawView)_Entity[0];
	if (!bError && !sv.bIsValid()) bError = 1;
			
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (!bError && nIndFound<0) bError = 2; // no viewData found
	
	if (!bError) {
		ViewData vwData = arViewData[nIndFound];
		Entity arEnt[] = vwData.showSetEntities();
		
		// collect all the module beams
		for (int i = 0; i < arEnt.length(); i++){
			Entity ent = arEnt[i];
			
			if (arEnt[i].bIsKindOf(GenBeam())) { // take only genbeams
				GenBeam gbX = (GenBeam)arEnt[i];
				if (gbX .module()!="") { // take only module beams
					arGBeam.append(gbX);
					el = gbX.element();
				}
			}
		}
		
		ms2ps = vwData.coordSys(); // transformation to view
	}
}

// if it is a viewport
else if (sSpace==sPaperSpace)
{
	if (!bError && _Viewport.length()==0) bError = 3;
	if (!bError) {
		Viewport vp = _Viewport[0];
		el = vp.element();	
		GenBeam arGBeamEl[] = el.genBeam();
		
		// find all module beams
		for (int g=0; g<arGBeamEl.length(); g++) {
			GenBeam gb = arGBeamEl[g];
			if (gb.module()!="") {
				arGBeam.append(gb);
			}
		}
				
		ms2ps = vp.coordSys();
	}
}

else if (sSpace==sModelSpace)
{
	if (!bError && _Element.length()==0) bError = 4;
	if (!bError) {
		el = _Element[0];
		GenBeam arGBeamEl[] = el.genBeam();
		
		// find all module beams
		for (int g=0; g<arGBeamEl.length(); g++) {
			GenBeam gb = arGBeamEl[g];
			if (gb.module()!="") {
				arGBeam.append(gb);
			}
		}
	}
}

// ---

// Resolve properties
//selection
int bExclude = arSInExclude.find(sInExcludeFilters,1);
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
String sFBmTypeID = sFilterBmTypeID + ";";
int arNFBmType[0];
int nIndexBmTypeID = 0; 
int sIndexBmTypeID = 0;
while(sIndexBmTypeID < sFBmTypeID.length()-1){
	String sTokenBmTypeID = sFBmTypeID.token(nIndexBmTypeID);
	nIndexBmTypeID++;
	if(sTokenBmTypeID.length()==0){
		sIndexBmTypeID++;
		continue;
	}
	sIndexBmTypeID = sFilterBmTypeID.find(sTokenBmTypeID,0);

	arNFBmType.append(sTokenBmTypeID.atoi());
}


int nBeamType = _BeamTypes.find(sFilterType);
arNFBmType.append(nBeamType);
int iShowOpening= sArShowOpening.find(sShowOpening,0);
int bShowOpeningData = (iShowOpening==0 || iShowOpening==2);
int bShowOpeningDim = (iShowOpening==2 || iShowOpening==3);
int nDirection = sArDirection.find(sDirection,0);
int nPointType = nArPointType[sArPointType.find(sPointType,0)];
int bPointTypeMaximum = (sArPointType.find(sPointType,0)==4);
int bCombineTouchingBeams = sArNoYes.find(sCombineTouchingBeams,0);
int nDeltaOnTop= sArNoYes.find(sDeltaOnTop,0);
int n2Delta = nAr2Delta[sAr2.find(s2,0)];
int n2Cum = nAr2Cum[sAr2.find(s2,0)];
if (nDimColor < -1 || nDimColor > 255) nDimColor.set(-1); 
int nReference = arSReferenceObject.find(sReferenceObject);
int nPointTypeReference = nArPointType[sArPointType.find(sPointTypeReference,0)];

if (!bError && !el.bIsValid()) bError = 5;
if (!bError && arGBeam.length()==0) bError = 6;

if (_bOnDebug) reportMessage("Number of genbeams found in module "+arGBeam.length());

//region filter genBeams (new)
GenBeam genBeams[0]; genBeams.append(arGBeam);
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
arGBeam = filteredGenBeams;
//endregion

//internal filter (old)
GenBeam arGBm[0];
Beam arBmHor[0];
Beam arBmVer[0];
Beam arBmOther[0];
Beam arBm[0];
Sheet arSh[0];
Beam arBmReference[0];
for(int i=0;i<arGBeam.length();i++){
	GenBeam gBm = arGBeam[i];
	Beam bm = (Beam)gBm;
	
	// apply filters
	String sBmCode = gBm.beamCode().token(0);
	String sLabel = gBm.label();
	int nBmType = gBm.type();
	
	if( nReference == 1 && nBmType == _BeamTypes.find(sReferenceBeamType) )
		arBmReference.append(bm);
	
	int bFilterGenBeam = false;
	if( arSFBC.find(sBmCode) != -1 )
		bFilterGenBeam = true;
	if( arSFLabel.find(sLabel) != -1 )
		bFilterGenBeam = true;
	if( arNFBmType.find(nBmType) != -1 )// == gBm.type() )
		bFilterGenBeam = true;
	if( dWidthSmallerThan > U(0) && gBm.solidWidth() < dWidthSmallerThan )
		bFilterGenBeam = true;
	
	if( (bFilterGenBeam && !bExclude) || (!bFilterGenBeam && bExclude) ){
		if( bm.bIsValid() ){
			arGBm.append(gBm);
		}
	}
}


// coordinate system variables
CoordSys csEl = el.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();

Vector3d vxElPs = vxEl; vxElPs.transformBy(ms2ps);
Vector3d vyElPs= vyEl; vyElPs.transformBy(ms2ps);
Vector3d vzElPs= vzEl; vzElPs.transformBy(ms2ps);
Line lnElX(ptEl,vxEl);


// if modelspace, project _Pt0 onto element
if (sSpace==sModelSpace) 
	_Pt0 -= vzEl.dotProduct(_Pt0-ptEl)*vzEl;
Point3d pt0Ms = _Pt0; // _Pt0 is in fact a point in paperspace (if (sSpace==sModelSpace) ps2ms is identity transformation anyway 
pt0Ms.transformBy(ps2ms);

pt0Ms.vis(1);

// direction of dim in MS
Vector3d vDimX = _XW;
Vector3d vDimY = _YW;
vDimX.transformBy(ps2ms);
vDimY.transformBy(ps2ms);
if (sSpace==sModelSpace) {
	vDimX = vxEl;
	vDimY = vyEl;
}
if (nDirection==kVertical) {
	Vector3d vTemp = vDimX;
	vDimX = vDimY;
	vDimY = -vTemp;
}

// Dimension read direction in PS
Vector3d vDimReadPS = -_XW + _YW;
if (sSpace==sModelSpace) {
	vDimReadPS = -vxEl + vyEl;
} 


// collect the openings to be dimensioned
Opening opAr[0]; // list of openings, could be none, only one, or multiple
if (sSpace==sShopdrawSpace) {
	// find an approximate center point of the opening from the centerpoints of the beams
	Point3d ptCenOpeningApprox;
	if (!bError) {
		Point3d pnts[arGBm.length()];
		for (int g=0; g<arGBm.length(); g++) {
			GenBeam gb = arGBm[g];
			pnts[g] = gb.ptCen();
		}
		pnts = lnElX.orderPoints(pnts,U(0.1));
		if (pnts.length()>0) {
			Point3d pt1 = pnts[0];
			Point3d pt2 = pnts[pnts.length()-1];
			ptCenOpeningApprox= pt1 + 0.5*(pt2-pt1);
		}
		else bError = 7;
	}
	
	// find an opening that covers the approximate center (in element x direction)
	if (!bError) {
		Opening opTheOne;
		Opening arOpEl[] = el.opening();
		for (int o=0; o<arOpEl.length(); o++) {
			Opening open = arOpEl[o];
			Point3d pnts[] = open.plShape().vertexPoints(TRUE);
			pnts = lnElX.orderPoints(pnts,U(1));
			if (pnts.length()>0) {
				Point3d pt1 = pnts[0];
				Point3d pt2 = pnts[pnts.length()-1];
				// check if the point ptCenOpeningApp is in between pt1 and pt2 (use the sign of dotproducts for that)
				if (vxEl.dotProduct(ptCenOpeningApprox-pt1)*vxEl.dotProduct(ptCenOpeningApprox-pt2) < 0) { // point is in between
					opTheOne = open;
					break; // found the one, stop looking
				}
			}
		}
		if (opTheOne.bIsValid()) {
			opAr.append(opTheOne);
		}
	}
}
else { // sPaperSpace or sModelSpace
	if (!bError)
		opAr = el.opening();
}


// Display
setMarbleDiameter(U(4));// set the diameter of the 3 circles, shown during dragging

// dimstyle scale need to be set correct according to the space
double dScale = ps2ms.scale();

Display dp(nDimColor);
dp.dimStyle(sDimStyle,dScale); // dimstyle was adjusted for display in paper space, sets textHeight

// draw the opening information
if (!bError) {
	if (bShowOpeningData || bShowOpeningDim) {
	
		// check if this view can support opening data
		Vector3d vDimZ = vDimX.crossProduct(vDimY);
		if (!vDimZ.isParallelTo(vzEl)) { // report to user that properties are not compatible with view
			reportMessage(TN("|This view cannot support to show opening info. Wrong orientation.|"));
		}
		else {
			
			// orient the vDimOpX with vxEl
			Vector3d vDimOpXMs = vDimX;
			Vector3d vDimOpYMs = vDimY;
			if (abs(vDimY.dotProduct(vxEl))>abs(vDimX.dotProduct(vxEl))) {
				vDimOpXMs = vDimY;
				vDimOpYMs = vDimX;
			}
			
			Vector3d vDimOpXPs = vDimOpXMs;
			Vector3d vDimOpYPs = vDimOpYMs;
			vDimOpXPs.transformBy(ms2ps);
			vDimOpYPs.transformBy(ms2ps);
			
			for (int o=0; o<opAr .length(); o++) {
				Opening open = opAr [o];
			
				CoordSys csOp = open.coordSys();
				PLine plop = open.plShape();
				Point3d pOp[] = plop.vertexPoints(TRUE);
				
// for display of header information 2011.06
				
				OpeningSF op=(OpeningSF)opAr[o];
				if (!op.bIsValid())
				continue;
				String sHeaderDescription =op.descrPlate();
				sHeaderDescription=ElementWallSF().findDescriptionForDetCode(sHeaderDescription);
					
				//START Opening Description
				if(bShowOpeningData) {
					Vector3d vSym = pOp[2] - pOp[0];
					vSym.normalize();
					Point3d pTxt = (pOp[2] + pOp[0])/2;
					vSym.transformBy(ms2ps);
					pTxt.transformBy(ms2ps);
					dp.draw(open.height() + "/" + open.width(),pTxt,vDimOpXPs,vDimOpYPs,0,4);
					dp.draw(T("|sill height:|") + open.sillHeight(), pTxt,vDimOpXPs,vDimOpYPs,0,7);
					dp.draw(T("|head height:|") + open.headHeight(), pTxt,vDimOpXPs,vDimOpYPs,0,10);
					dp.draw(sHeaderDescription, pTxt,vDimOpXPs,vDimOpYPs,0,13);			//2011.06 YT	
					
				}
				
				if(bShowOpeningDim && pOp.length() > 0) {
				
					Point3d pOpRef[0];
					//pOpRef.append(pRef);
					pOpRef.append(pOp);
					Display dpOp(nDimColor);
					dpOp.dimStyle(sDimStyle,dScale);
					Point3d ptDimLineLocation = csOp.ptOrg() + vxEl * U(100)+ vyEl * U(100);
					{
						DimLine lnOpMs(ptDimLineLocation, vDimOpXMs, vDimOpYMs);
						Dim dimOp(lnOpMs,pOpRef,"<>","<>",TRUE,FALSE); // def in MS
						dimOp.transformBy(ms2ps); // transfrom the dim from MS to PS
						dimOp.setReadDirection(vDimReadPS);
						dimOp.setDeltaOnTop(nDeltaOnTop);
						dpOp.draw(dimOp);
					}
					{
						DimLine lnOpMs(ptDimLineLocation, vDimOpYMs, -vDimOpXMs);
						Dim dimOp(lnOpMs,pOpRef,"<>","<>",TRUE,FALSE); // def in MS
						dimOp.transformBy(ms2ps); // transfrom the dim from MS to PS
						dimOp.setReadDirection(vDimReadPS);
						dimOp.setDeltaOnTop(nDeltaOnTop);
						dpOp.draw(dimOp);
					}
				}	
			}		
		}
	}
}

// there is one centerpoint taken to descide between top and bottom points for the dimension line
Point3d ptOpeningCenter; 
if (!bError) {
	if (opAr.length()>0) {
			Opening opTheOne = opAr[0];
			Point3d pnts[] = opTheOne.plShape().vertexPoints(TRUE);
			ptOpeningCenter.setToAverage(pnts);
	}
	else
		bError = 8;
}

Point3d ptDimSide = ptOpeningCenter;
double dDimDist = 0;
// filter out the beams that are on the correct side of the ptOpeningCenter point
GenBeam arGBeamDim[0];
if (!bError) {
	if (nDirection==kVertical) {
		arGBeamDim= arGBm;
	}
	else { // must be top or bottom
		Vector3d vecOk = vyEl;
		if (vecOk.dotProduct(ptOpeningCenter-pt0Ms)<0) vecOk = -vecOk;
		
		// descide upon the end points of the beam, use the filtered list of beams
		for (int b=0; b<arGBm.length(); b++) {
			Beam bm = (Beam) arGBm[b];
			if (!bm.bIsValid()) continue;
			
			Point3d ptL = bm.ptCen()+0.5*bm.dL()*bm.vecX();
			Point3d ptR = bm.ptCen()-0.5*bm.dL()*bm.vecX();
			if ((vecOk.dotProduct(ptL-ptOpeningCenter)<0)||(vecOk.dotProduct(ptR-ptOpeningCenter)<0)) {
				arGBeamDim.append(bm);
				
				if( vecOk.dotProduct(ptOpeningCenter - ptL) > dDimDist ){
					dDimDist = vecOk.dotProduct(ptL - ptDimSide);
					ptDimSide = ptL;
				}
				if( vecOk.dotProduct(ptOpeningCenter - ptR) > dDimDist ){
					dDimDist = vecOk.dotProduct(ptR - ptDimSide);
					ptDimSide = ptR;
				}
			}
		}
	}
	
}

// draw the dimension line to dimension the beams
if (!bError) 
{
	// need to orient the points from the insertion point pt0Ms on.
	// also use the ptOpeningCenter to decide direction
	Vector3d vecOrient = vDimX;
	if (vecOrient.dotProduct(ptOpeningCenter-pt0Ms)<0) 
		vecOrient = -vecOrient;
		
	Line lnOrder(pt0Ms, vecOrient);		
	lnOrder.vis(5);
	DimLine lnMs(pt0Ms, vDimX, vDimY );// dimline in model space
	
	
	Point3d pntsMs[0];
	if( !bCombineTouchingBeams ){
		pntsMs = lnMs.collectDimPoints(arGBeamDim,nPointType);
	}
	else{
		PlaneProfile ppBms(CoordSys(ptEl, vxEl, -vzEl, vyEl));		
		for( int i=0;i<arGBeamDim.length();i++ ){
			Beam bm = (Beam)arGBeamDim[i];
			if( !bm.bIsValid() )
				continue;
			if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) > dEps )
				continue;
			Body bdBm = bm.realBody();
			ppBms.unionWith(bdBm.shadowProfile(Plane(ptEl, vyEl)));
		}
		
		//Combine rings which are close to each other
		ppBms.shrink(-U(0.01));
		ppBms.shrink(U(0.01));
		ppBms.vis(5);
		//Take the required points from each ring
		PLine arPlBms[] = ppBms.allRings();
		for( int i=0;i<arPlBms.length();i++ ){
			PLine pl = arPlBms[i];
			
			Point3d arPtPl[] = pl.vertexPoints(true);
			Point3d arPtPlX[] = lnOrder.orderPoints(arPtPl);
			if( arPtPlX.length() < 2 )
				continue;
			
			Point3d ptLeft = arPtPlX[0];
			Point3d ptRight = arPtPlX[arPtPlX.length() - 1];
			Point3d ptCenter = (ptLeft + ptRight)/2;
			
			if( nPointType == _kLeft || nPointType == _kLeftAndRight )
				pntsMs.append(ptLeft);
			if( nPointType == _kRight || nPointType == _kLeftAndRight )
				pntsMs.append(ptRight);
			if( nPointType == _kCenter )
				pntsMs.append(ptCenter);
		}
	}
	
	

	
	// project points on XY plane
	Vector3d vDimZ = vDimX.crossProduct(vDimY);
	pntsMs = Plane(pt0Ms,vDimZ).projectPoints(pntsMs);
	pntsMs = Plane(ptDimSide,vDimY).projectPoints(pntsMs);
	lnOrder.vis(1);
	for(int i=0;i<pntsMs.length();i++)
		pntsMs[i].vis(i);
	pntsMs = lnOrder.orderPoints(pntsMs,U(0.1));
	
	// if dimension only min max, then replace the array of points with just the first and last one
	if (bPointTypeMaximum && pntsMs.length()>2) {
		Point3d ptMM[0];
		ptMM.append(pntsMs[0]);
		ptMM.append(pntsMs[pntsMs.length()-1]);
		pntsMs = ptMM;
	}
	
	// Add reference points
	Point3d arPtRef[0];
	for( int i=0;i<arBmReference.length();i++ )
		arPtRef.append(arBmReference[i].envelopeBody(true, true).allVertices());
		
	Point3d arPtRefX[] = lnOrder.orderPoints(arPtRef);
	if( arPtRefX.length() > 1 ){
		Point3d ptRefLeft = arPtRefX[0];
		Point3d ptRefRight = arPtRefX[arPtRefX.length() - 1];
		Point3d ptRefCenter = (ptRefLeft + ptRefRight)/2;
		
		if( nPointTypeReference == _kLeft || nPointTypeReference == _kLeftAndRight )
			pntsMs.insertAt(0, ptRefLeft);
		if( nPointTypeReference == _kRight || nPointTypeReference == _kLeftAndRight )
			pntsMs.insertAt(0, ptRefRight);
		if( nPointTypeReference == _kCenter )
			pntsMs.insertAt(0, ptRefCenter);
	}

	
	if( pntsMs.length() > 1 ){
		Dim dim(lnMs,pntsMs,"<>","<>",n2Delta,n2Cum); // def in MS
		dim.transformBy(ms2ps); // transfrom the dim from MS to PS
		dim.setReadDirection(vDimReadPS);
		dim.setDeltaOnTop(nDeltaOnTop);
		dp.draw(dim);
	}
}

if (bError) {
	Vector3d vX = _XU, vY = _YU;
	if (nDirection==kVertical) { vX = _YU; vY = -_XU; }
	dp.draw(scriptName() + " has error code: "+ bError, _Pt0, vX, vY, 1,1);
}

		
	








#End
#BeginThumbnail








#End
#BeginMapX

#End