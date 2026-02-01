#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
17.11.2017  -  version 1.12







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl will join wall plates in the same roofplane. After they are joined they are split into standard lengths. The main length can be set as a property. The property set also provides a minimum length. The last split is not on standard length if the remaining length is less then this minumum length.
/// 
/// Example:
/// A beam with length: 11500 mm
/// Default length: 5400 mm
/// Minimum length: 2700 mm
/// 
/// Splitlocations:
/// 5400 and 8800 mm
/// 
/// Lengths:
/// 5400, 3400 en 2700 mm
/// 
/// After splitting the wall plates into default lengths they will be assigned to the floorgroup. By doing this, the wall plates will be on the loose provide list of the database.
/// 
/// The tsl will distribute anchors per joined wall plate. The distance to the edge must be set as a property. 
/// The anchors will be distributed between the two outer anchors. The maximum distance between the anchors must be set as a property.
/// Different types of anchors will look the same, they can be distinguished from each other by a text. The type can be specified in the properties.
/// Anchors can be moved with a grippoint.
/// </summary>

/// <insert>
/// Inserted by AnchorPlan tsl
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.12" date="17.11.2017"></version>

/// <history>
/// AS - 1.00 - 02.01.2014 -	Pilot version
/// AS - 1.01 - 04.06.2014 -	Add distribution of anchors and dimension options.
/// AS - 1.02 - 22.06.2014 -	Link the dimension lines to the entities.
/// AS - 1.03 - 23.06.2014 -	Add blocknames with 'Anker' in name.
/// AS - 1.04 - 24.06.2014 -	Check on devision by zero.
/// AS - 1.05 - 30.06.2014 -	Add beams to a specified group.
/// AS - 1.06 - 17.12.2014 -	Bugfix split beams. Support dimlines per anchor type. Add recalc triggers.
/// AS - 1.07 - 12.01.2015 -	Combine dimlines if wallplates are at the same height.
/// AS - 1.08 - 07.04.2015 -	Compare positions now with a tolerance. Add option to keep joined wall plates on element deleted. (FogBugzId 943)
/// AS - 1.09 - 08.05.2015 -	Add option for a second anchor distribution. (FogBugzId 1264)
/// AS - 1.10 - 22.05.2015 -	Add blocks with hsb in the name as valid anchor blocks.
/// AS - 1.11 - 27.05.2015 -	Update logo
/// AS - 1.12 - 17.11.2017 -	Also set closests poinst of grid, if the extremes are on grid.
/// </history>

double dEps = Unit(0.01, "mm");

String arSAnchorTsl[] = {
	"HSB_T-Anchor"
};

String arSDimensionTsl[] = {
	"HSB_D-Aligned"
};
String arSCatalogDimension[] = TslInst().getListOfCatalogNames("HSB_D-Aligned");

String arSAnchorBlock[0];
for( int i=0;i<_BlockNames.length();i++ ){
	String sBlockName = _BlockNames[i];
	String sBlockNameUpper = sBlockName.makeUpper();
	
	if (sBlockName.left(2) == "BK") // TODO: Find a way to search for blocks on a generic way.
		arSAnchorBlock.append(sBlockName);
	else if (sBlockNameUpper.find("ANKER", 0) != -1)
		arSAnchorBlock.append(sBlockName);
	else if (sBlockNameUpper.find("HSB", 0) != -1)
		arSAnchorBlock.append(sBlockName);
}

//Groupnames
String arSGroupNames[0];
Group arGrp[0];
Group arAllGroups[] = Group().allExistingGroups();
for (int i=0;i<arAllGroups.length();i++) {
	Group grp = arAllGroups[i];
	// Only accept floor- and elementgroups.
	if (grp.namePart(1) == "")
		continue;
	arSGroupNames.append(grp.name());
	arGrp.append(grp);
}

String arSAnchorDistribution[] = {
	T("|Grid|"),
	T("|Beam extremes|"),
	T("|Beam center|")
};

String arSDimensionReference[] = {
	T("|Grid|"),
	T("|Elements|")
};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator00(17, "", T("|General|"));
sSeperator00.setReadOnly(true);
PropString sName(18, "hsbCAD Wallplates", "     "+T("|Name|"));
sName.setDescription(T("|Sets the name of this instance."));
PropString sDeleteOldBeams(21, arSYesNo, "     "+T("|Delete wallplates when element is unframed|"), 1);
sDeleteOldBeams.setDescription(T("|Delete the joined wall plates when the construction of one of the connected element is deleted.|"));

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sBmCodesToJoin(1, "", "     "+T("|Beam codes to join|"));
PropString sBmNamesToJoin(3, "", "     "+T("|Beam names to join|"));
PropString sAssignToGroup(20, arSGroupNames, "     "+T("|Assign beams to group|"));
sAssignToGroup.setDescription(T("|The beams are assigned exclusively to this group.|"));


PropString sSeperator02(2, "", T("|Split lengths|"));
sSeperator02.setReadOnly(true);
PropDouble dDefaultSplitL (0, U(5100), "     "+T("|Default split length|"));
PropDouble dMinimumSplitL (1, U(2700), "     "+T("|Minimum split length|"));
PropDouble dSplitGap(2, U(0), "     "+T("|Split gap|"));

PropString sSeperator09(23, "", T("|Anchors general|"));
sSeperator09.setReadOnly(true);
PropString sScriptNameAnchor(5, arSAnchorTsl, "     "+T("|Scriptname anchor|"));


PropString sSeperator03(4, "", T("|Anchor| 1"));
sSeperator03.setReadOnly(true);
PropString sBlockNameAnchor1(6, arSAnchorBlock, "     "+T("|Blockname anchor| 1"));
PropDouble dxOffset1(5, U(0), "     "+T("X-|Offset| 1")); 
PropDouble dzOffset1(6, -U(125), "     "+T("Z-|Offset| 1"));


PropString sSeperator04(7, "", T("|Anchor distribution| 1"));
sSeperator04.setReadOnly(true);
PropString sAnchorDistribution1(8, arSAnchorDistribution, "     "+T("|Start distribution| 1"), 1);
PropString sAnchorInCenter1(9, arSYesNo, "     "+T("|Anchor in center| 1"));
sAnchorInCenter1.setDescription(T("|Anchor in center is only used when the distribution starts in beam center|"));
PropDouble dOffsetFromEdge1(3, U(500), "     "+T("|Offset from edge| 1"));
PropDouble dSpacing1(4, U(800), "     "+T("|Spacing| 1"));


PropString sSeperator07(22, "", T("|Anchor| 2"));
sSeperator07.setReadOnly(true);
PropString sApplyAnchor2(28, arSYesNo, "     "+T("|Add anchor| 2"), 1);
PropString sBlockNameAnchor2(24, arSAnchorBlock, "     "+T("|Blockname anchor| 2"));
PropDouble dxOffset2(10, U(0), "     "+T("X-|Offset| 2")); 
PropDouble dzOffset2(11, -U(125), "     "+T("Z-|Offset| 2"));


PropString sSeperator08(25, "", T("|Anchor distribution| 2"));
sSeperator08.setReadOnly(true);
PropString sAnchorDistribution2(26, arSAnchorDistribution, "     "+T("|Start distribution| 2"), 1);
PropString sAnchorInCenter2(27, arSYesNo, "     "+T("|Anchor in center| 2"));
sAnchorInCenter2.setDescription(T("|Anchor in center is only used when the distribution starts in beam center|"));
PropDouble dOffsetFromEdge2(12, U(500), "     "+T("|Offset from edge| 2"));
PropDouble dSpacing2(13, U(800), "     "+T("|Spacing| 2"));


PropString sSeperator05(10, "", T("|Dimension|"));
sSeperator05.setReadOnly(true);
PropString sScriptNameDimensionTsl(11, arSDimensionTsl, "     "+T("|Scriptname dimension|"));
PropString sCatalogDimensionTsl(12, arSCatalogDimension, "     "+T("|Catalog dimension tsl|"));
PropString sDimensionReference(13, arSDimensionReference, "     "+T("|Dimension reference|"));
PropDouble dOffsetDimension(7, U(0), "     "+T("|Offset dimension lines|"));
PropDouble dBetweenDimension(8, U(400), "     "+T("|Distance between dimension lines|"));
PropString sLinkDimensionToObjects(14, arSYesNo, "     "+T("|Link dimension lines to objects|"));


PropString sSeperator06(15, "", T("|Visualization|"));
sSeperator06.setReadOnly(true);
PropString sLayerVisualization(16, "Defpoints", "     "+T("|Layer|"));
sLayerVisualization.setDescription(T("|Assign the symbols and text used for the visualization to this layer.|"));
PropInt nColorVisualization(0, -1, "     "+T("|Color|"));
nColorVisualization.setDescription(T("|Sets the color of the symbols and text used for the visualization.|"));
PropString sDimStyle(19, _DimStyles, "     "+T("|Dimension style|"));
sDimStyle.setDescription(T("|The text style defined in this dimension style is used."));
PropDouble dTxtSize(9, -1, "     "+T("|Text size|"));
dTxtSize.setDescription(T("|Sets the text size.|") + 
	TN("|The size specified in the dimension style is used, if the size is set to zero, or less|"));


String arSTrigger[] = {
	T("|Recalculate all|"),
	T("|Recalculate dimensions|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	showDialog();
	
	PrEntity ssE(T("|Select a set of elements|"), ElementRoof());
	if( ssE.go() )
		_Element.append(ssE.elementSet());
	
	_Pt0 = getPoint(T("|Select insertion point|"));
	
	_Map.setInt("Insert", true);

	return;
}

if( _Element.length() == 0 ){
	reportMessage(TN("|No element selected|!"));
	eraseInstance();
	return;
}

// Assign this tsl to layer 0.
_ThisInst.assignToLayer("0");

Display dp(nColorVisualization);
dp.layer(sLayerVisualization);
dp.dimStyle(sDimStyle);
if (dTxtSize > 0)
	dp.textHeight(dTxtSize);
Point3d ptVisualization = _Pt0;
Vector3d vxTxt = _XW;
Vector3d vyTxt = _YW;
dp.draw(sName, ptVisualization, vxTxt, vyTxt, 1, 1);

// Resolve properties
int bDeleteOldBeams = arNYesNo[arSYesNo.find(sDeleteOldBeams,1)];

String arSBmCodeToJoin[0];
String sList = sBmCodesToJoin + ";";
sList.makeUpper();
int nTokenIndex = 0; 
int sCharacterIndex = 0;
while(sCharacterIndex < sList.length()-1){
	String sToken = sList.token(nTokenIndex);
	nTokenIndex++;
	if(sToken.length()==0){
		sCharacterIndex++;
		continue;
	}
	sCharacterIndex = sList.find(sToken,0);
	sToken.trimLeft();
	sToken.trimRight();
	arSBmCodeToJoin.append(sToken);
}

String arSBmNameToJoin[0];
sList = sBmNamesToJoin + ";";
sList.makeUpper();
nTokenIndex = 0; 
sCharacterIndex = 0;
while(sCharacterIndex < sList.length()-1){
	String sToken = sList.token(nTokenIndex);
	nTokenIndex++;
	if(sToken.length()==0){
		sCharacterIndex++;
		continue;
	}
	sCharacterIndex = sList.find(sToken,0);
	sToken.trimLeft();
	sToken.trimRight();
	arSBmNameToJoin.append(sToken);
}

Group grp = arGrp[arSGroupNames.find(sAssignToGroup,0)];

String arSBlockNameAnchor[] = {
	sBlockNameAnchor1
};
double arDxOffset[] = {
	dxOffset1
};
double arDzOffset[] = {
	dzOffset1
};
int arNAnchorDistribution[] = {
	arSAnchorDistribution.find(sAnchorDistribution1,0)
};
int arBAnchorInCenter[] = {
	arNYesNo[arSYesNo.find(sAnchorInCenter1,0)]
};
double arDOffsetFromEdge[] = {
	dOffsetFromEdge1
};
double arDSpacing[] = {
	dSpacing1
};

int bApplyAnchor2 = arNYesNo[arSYesNo.find(sApplyAnchor2, 1)];
if (bApplyAnchor2) {
	arSBlockNameAnchor.append(sBlockNameAnchor2);
	arDxOffset.append(dxOffset2);
	arDzOffset.append(dzOffset2);
	arNAnchorDistribution.append(arSAnchorDistribution.find(sAnchorDistribution2,0));
	arBAnchorInCenter.append(arNYesNo[arSYesNo.find(sAnchorInCenter2,0)]);
	arDOffsetFromEdge.append(dOffsetFromEdge2);
	arDSpacing.append(dSpacing2);
}

int nDimensionReference = arSDimensionReference.find(sDimensionReference,0);

int nLinkDimensionToObjects = arNYesNo[arSYesNo.find(sLinkDimensionToObjects,0)];

Grid gr;

Point3d arPtElement[0];

Element elRef;
Point3d ptReference;
Vector3d vxReference;
Vector3d vyReference;
Vector3d vzReference;
//Loop over all elements

int bSearchForBeams = (_Beam.length() == 0);

for( int e=0;e<_Element.length();e++ ){
	Element el = _Element[e];
	
	if ((nDimensionReference == 0 || arNAnchorDistribution.find(0) != -1) && !gr.bIsValid())
		gr = el.grid();
	
	//Coordsys and vectors of this element
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	if( e==0 ){
		elRef = el;
		ptReference = ptEl;
		vxReference = vxEl;
		vzReference = _ZW;
		vyReference = vzReference.crossProduct(vxReference);
	}
	
	// Store vertex points of the element.
	arPtElement.append(el.plEnvelope().vertexPoints(true));
	
	if (bSearchForBeams) {
		//beams from this element
		Beam arBm[] = el.beam();
			
		//Loop over all beams in this element.
		for( int i=0;i<arBm.length();i++ ){
			Beam bm = arBm[i];
			String sBmCode = bm.beamCode().token(0).makeUpper();
			String sBmName = bm.name().makeUpper();
			
			if( arSBmCodeToJoin.find(sBmCode) != -1 || arSBmNameToJoin.find(sBmName) != -1 )
				_Beam.append(bm);
		}
	}	
}


double arDYPosition[0];
double arDZPosition[0];
// Only take the valid beams. Some beams might be invalid due to join and split operations.
Beam arBmTmp[0];
arBmTmp.append(_Beam);
_Beam.setLength(0);
for (int i=0;i<arBmTmp.length();i++) {
	Beam bm = arBmTmp[i];
	if (!bm.bIsValid())
		continue;
	_Beam.append(bm);
	arDYPosition.append(vyReference.dotProduct(bm.ptCen() - ptReference));
	arDZPosition.append(vzReference.dotProduct(bm.ptCen() - ptReference));
}

// Check if we have a valid grid
if ((nDimensionReference == 0 || arNAnchorDistribution.find(0) != -1)){
	if (gr.bIsValid()) {
		if (_Entity.find(gr) == -1)
			_Entity.append(gr);
		setDependencyOnEntity(gr);
	}
	else{
		reportWarning(T("|No valid grid found!|"));
		eraseInstance();
		return;
	}
}

Line lnX(ptReference, vxReference);

arPtElement = lnX.projectPoints(arPtElement);
arPtElement = lnX.orderPoints(arPtElement);
if (arPtElement.length() == 0) {
	reportWarning(TN("|Invalid element outlines|!"));
	eraseInstance();
	return;
}

Point3d ptDimRefStart = arPtElement[0];
Point3d ptDimRefEnd = arPtElement[arPtElement.length() - 1];
Point3d ptGrStart;
Point3d ptGrEnd;
if (nDimensionReference == 0 || arNAnchorDistribution.find(0) != -1) { // Start from grid		
	Point3d ptGrOtherStart;
	if (gr.bIsOn(ptDimRefStart,vxReference,dEps)) {
		ptDimRefStart.vis(1);
		gr.hasClosestPointTo(ptDimRefStart, vxReference, ptGrStart, ptGrOtherStart);
	}
	else if (gr.hasClosestPointTo(ptDimRefStart,vxReference,ptGrStart,ptGrOtherStart)) {
		ptGrStart.vis(5);
		ptGrOtherStart.vis(5);
	}
	
	Point3d ptGrOtherEnd;
	if (gr.bIsOn(ptDimRefEnd,vxReference,dEps)) {
		ptDimRefEnd.vis(1);
		gr.hasClosestPointTo(ptDimRefEnd, vxReference, ptGrEnd, ptGrOtherEnd);
	}
	else if (gr.hasClosestPointTo(ptDimRefEnd,vxReference,ptGrEnd,ptGrOtherEnd)) {
		ptGrEnd.vis(3);
		ptGrOtherEnd.vis(3);
	}
}

if (nDimensionReference == 0) {
	ptDimRefStart = ptGrStart;
	ptDimRefEnd = ptGrEnd;
}

CoordSys csElRef = elRef.coordSys();
Vector3d vyElRef = csElRef.vecY();

// Only optimize timbers and recalculate dimension lines in special situations.
int bOptimizeTimbers = false;
int bRecalculateDimlines = false;
// On element constructed...
if (_bOnElementConstructed) {
	bOptimizeTimbers = true;
	bRecalculateDimlines = true;
}
// On insert..
if (_Map.hasInt("Insert")) {
	int bOnInsert = _Map.getInt("Insert");
	bOptimizeTimbers = bOnInsert;
	bRecalculateDimlines = bOnInsert;
	// Remove insert flag.
	_Map.removeAt("Insert", true);
}
// On recalculate all trigger
if (_kExecuteKey == arSTrigger[0]) {
	bOptimizeTimbers = true;
	bRecalculateDimlines = true;
}
// On recalc dimension line trigger
if (_kExecuteKey == arSTrigger[1]) {
	bRecalculateDimlines = true;
}


Map mapWallPlates = _Map.getMap("WallPlates");
// Delete old beams when element is deleted
if (bDeleteOldBeams && _bOnElementDeleted) {
	for (int i=0;i<mapWallPlates.length();i++) {
		if (mapWallPlates.keyAt(i) != "WallPlate" || !mapWallPlates.hasMap(i))
			continue;
		
		Map mapWallPlate = mapWallPlates.getMap(i);
		for (int j=0;j<mapWallPlate.length();j++) {
			if (mapWallPlate.keyAt(j) != "Beam" || !mapWallPlate.hasEntity(j))
				continue;
			
			Entity entBm = mapWallPlate.getEntity(j);
			entBm.dbErase();
		}
	}
}

// Join beams which are in line with each other and split them in prefered lengths
if (bOptimizeTimbers) {
	//Order beams
	for(int s1=1;s1<_Beam.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( vxReference.dotProduct(_Beam[s11].ptCen() - _Beam[s2].ptCen()) < 0 ){
				_Beam.swap(s2, s11);
				arDYPosition.swap(s2, s11);
				arDZPosition.swap(s2, s11);
				
				s11=s2;
			}
		}
	}
	
	for(int s1=1;s1<arDYPosition.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( (arDYPosition[s2] - arDYPosition[s11]) > dEps){
				_Beam.swap(s2, s11);
				arDYPosition.swap(s2, s11);
				arDZPosition.swap(s2, s11);
	
				s11=s2;
			}
		}
	}
	
	for(int s1=1;s1<arDZPosition.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( (arDZPosition[s11] - arDZPosition[s2]) > dEps ){
				_Beam.swap(s2, s11);
				arDYPosition.swap(s2, s11);
				arDZPosition.swap(s2, s11);
	
				s11=s2;
			}
		}
	}
	
	double dPreviousYPosition;
	double dPreviousZPosition;
	
	Beam arBmToOptimize[0];
	for (int i=0; i<_Beam.length();i++ ){
		Beam bm = _Beam[i];
		if (!bm.bIsValid())
			continue;
		
		grp.addEntity(bm, true, 0, 'Z');
		
		double dYPosition = arDYPosition[i];
		double dZPosition = arDZPosition[i];
		if (i==0){
			dPreviousYPosition = dYPosition;
			dPreviousZPosition = dZPosition;
			
			arBmToOptimize.append(bm);
			continue;
		}
		else{
			int bTryToJoin = false;
			if( abs(dYPosition - dPreviousYPosition) < dEps && abs(dZPosition - dPreviousZPosition) < dEps ){
				bTryToJoin = true;
				
				Beam previousBm = arBmToOptimize[arBmToOptimize.length() - 1];
				Point3d ptEndPreviousBm = previousBm.ptCenSolid() + vxReference * 0.5 * previousBm.solidLength();
				ptEndPreviousBm.vis(1);
				Point3d ptStartThisBm = bm.ptCenSolid() - vxReference * 0.5 * bm.solidLength();
				ptStartThisBm.vis(3);
				double d = vxReference.dotProduct(ptStartThisBm - ptEndPreviousBm);
				if( vxReference.dotProduct(ptStartThisBm - ptEndPreviousBm) > U(50) )
					bTryToJoin = false;
			}
			
			
			if( bTryToJoin ){
				int bBmJoined = arBmToOptimize[arBmToOptimize.length() - 1].dbJoin(bm);
				if (!bBmJoined)
					reportMessage("\n"+scriptName() + TN("|Join failed for beams| ") + 
						arBmToOptimize[arBmToOptimize.length() - 1].posnum() + T(" |and| ") + bm.posnum()); 
				continue;
			}
			else{
				dPreviousYPosition = dYPosition;
				dPreviousZPosition = dZPosition;
				
				arBmToOptimize.append(bm);
			}
		}
	}
	
	// Split beams to predefined lengts.
	
	// Reset map with information on wall plates
	mapWallPlates = Map();
	
	double dDefaultSplitLengthWithGap = dDefaultSplitL + dSplitGap;
	double dMinimumSplitLengthWithGap = dMinimumSplitL + dSplitGap;
	for( int i=0;i<arBmToOptimize.length();i++ ){
		Beam bm = arBmToOptimize[i];
		bm.envelopeBody().vis(i);
		Vector3d vyBmRef = _ZW.crossProduct(bm.vecX());
		if( vyBmRef.dotProduct(vyElRef) < 0 )
			vyBmRef *= -1;
		Vector3d vxBmRef = vyBmRef.crossProduct(_ZW);
		
		// Remove existing anchors
		Entity arEntTool[] = bm.eToolsConnected();
		for( int j=0;j<arEntTool.length();j++ ){
			TslInst tslTool = (TslInst)arEntTool[j];
			if( !tslTool.bIsValid() )
				continue;
			
			if( tslTool.scriptName() == sScriptNameAnchor)
				tslTool.dbErase();
		}
		
		// start splitting
		double dBmL = bm.solidLength();
		Point3d ptBmStart = bm.ptCenSolid() - bm.vecX() * 0.5 * dBmL;
		Point3d ptBmEnd = bm.ptCenSolid() + bm.vecX() * 0.5 * dBmL;
		
		//count of normal split locations
		int nNrOfSplitLocations = int((dBmL - 1) / dDefaultSplitLengthWithGap);
		
		double dbRest = dBmL - (nNrOfSplitLocations * dDefaultSplitLengthWithGap);
	
		Point3d ptStart = ptBmStart;
		Point3d ptFrom;
		Point3d ptTo;
		
		if( dbRest < dMinimumSplitL ){ 
			nNrOfSplitLocations--;
			if( nNrOfSplitLocations<0 )
				nNrOfSplitLocations=0;
		}		
		
		Beam arBmSplit[0];
		for( int j=0;j<nNrOfSplitLocations;j++ ){
			ptTo = ptStart + bm.vecX() * dDefaultSplitL;
			ptFrom = ptTo + bm.vecX() * dSplitGap;
			Beam bmNew = bm.dbSplit(ptFrom, ptTo);
			// The original beam Wont be split again. Store it.
		   arBmSplit.append(bm);
			
			// Store the new beam too.
			_Beam.append(bmNew);
			
			bm = bmNew;
			
			ptStart = ptFrom;
		}
	
		dBmL = bm.solidLength();
		if( dBmL > dDefaultSplitL ){
			//So we still have a beam longer then Minimum Lenght, so do the last split
			dbRest = dBmL - dMinimumSplitLengthWithGap;
		
			ptTo = ptStart + bm.vecX() * dbRest;
			ptFrom = ptTo + bm.vecX() * dSplitGap;
			Beam bmNew = bm.dbSplit(ptFrom, ptTo);
			// Store the result from the split.
			arBmSplit.append(bm);
			
			// Store the new beam too.
			_Beam.append(bmNew);
			
			bm = bmNew;
		}
		
		// Store the remaining part too.
		arBmSplit.append(bm);
		
		// Add this data to the map. This is needed for the dimension lines
		Map mapWallPlate;
		for (int j=0;j<arBmSplit.length();j++)
			mapWallPlate.appendEntity("Beam", arBmSplit[j]);
		mapWallPlate.setDouble("HeightInElement", vzReference.dotProduct(bm.ptCen() - ptReference));
		
		for (int a=0;a<arNAnchorDistribution.length();a++) {
			int nAnchorDistribution = arNAnchorDistribution[a];
			double dOffsetFromEdge = arDOffsetFromEdge[a];
			double dSpacing = arDSpacing[a];
			int bAnchorInCenter = arBAnchorInCenter[a];
			double dxOffset = arDxOffset[a];
			double dzOffset = arDzOffset[a];
			String sBlockNameAnchor = arSBlockNameAnchor[a];
			
			Point3d ptStartDistribution = ptGrStart;
			Point3d ptEndDistribution = ptGrEnd;
			
			if (nAnchorDistribution > 0) {
				ptStartDistribution = ptBmStart;
				ptEndDistribution = ptBmEnd;
				
				if (vxReference.dotProduct(ptEndDistribution - ptStartDistribution) < 0) {
					Point3d ptTmp = ptStartDistribution;
					ptStartDistribution = ptEndDistribution;
					ptEndDistribution = ptTmp;
				}
			}
			
			ptStartDistribution += vxReference * dOffsetFromEdge;
			ptEndDistribution -= vxReference * dOffsetFromEdge;
			double dDistributionLength = vxReference.dotProduct(ptEndDistribution - ptStartDistribution);
			if (dDistributionLength <= 0) {
				reportMessage(	TN("\n|Negative Distribution Length|") + 
									TN("|The offset from the edge is too big for the selected beam.|") + 
									TN("|The start of the distribution is set to the center of the beam!|"));
				
				ptStartDistribution = (ptBmStart + ptBmEnd)/2;
			}
			
			double dNrOfSpacings = dDistributionLength/dSpacing;
			int nNrOfSpacings = dDistributionLength/dSpacing;
			
			if( (dNrOfSpacings - nNrOfSpacings) > dEps )
				nNrOfSpacings++;
			
			int nNrOfAnchors = nNrOfSpacings + 1;
			
			// Start distribution in center of beam.
			// Correct the number of anchors if needed.
			if( nAnchorDistribution == 2 ){
				double dOddOrEven = nNrOfAnchors/2.0 - nNrOfAnchors/2;
				int bIsOddNumber = dOddOrEven > dEps;
				if( 
					bAnchorInCenter && !bIsOddNumber || 	// Anchor in center means that the number of anchors must be an odd number.
					!bAnchorInCenter && bIsOddNumber	// Anchor not in center means that the number of anchors must be an even number.
				)
					nNrOfAnchors++;
			}
			
			// Number of anchors must be at least 1.
			// calculate the distance between them.
			double dBetweenAnchors;
			if (nNrOfAnchors > 1) {
				dBetweenAnchors = dDistributionLength/(nNrOfAnchors - 1);
			}
			else {
				dBetweenAnchors = dDistributionLength;
				nNrOfAnchors = 1;
			}
			
			Element lstElements[0];
			Beam lstBeams[1];
			Point3d lstPoints[1];
			int lstPropInt[0];
			double lstPropDouble[] = {
				dxOffset,
				dzOffset
			};
			String lstPropString[] = {
				"",
				sBlockNameAnchor
			};
			
			for( int j=0;j<nNrOfAnchors;j++ ){
				Point3d pt = ptStartDistribution + vxReference * j * dBetweenAnchors;
				pt.vis(j);
				
				// Find beam at this point.
				for( int k=0;k<arBmSplit.length();k++ ){
					Beam bm = arBmSplit[k];
					Point3d ptBmStart = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() + U(5));
					Point3d ptBmEnd = bm.ptCenSolid() + bm.vecX() * (0.5 * bm.solidLength() + U(5));
					
					if( (bm.vecX().dotProduct(ptBmStart - pt) * bm.vecX().dotProduct(ptBmEnd - pt)) < 0 ){
						// Insert anchor
						lstBeams[0] = bm;
						lstPoints[0] = pt;
					
						TslInst tslAnchor;
						tslAnchor.dbCreate(sScriptNameAnchor, vxBmRef ,vyBmRef ,lstBeams, lstElements, lstPoints , lstPropInt, lstPropDouble,lstPropString); // create new instance	
			
						break;
					}
				}
			}
		}
		mapWallPlates.appendMap("WallPlate", mapWallPlate);
		_Map.setMap("WallPlates", mapWallPlates);
	}
}

// Group wall plates at the same height.
for (int i=0;i<mapWallPlates.length();i++) {
	if (mapWallPlates.keyAt(i) != "WallPlate" || !mapWallPlates.hasMap(i))
		continue;
	
	Map mapWallPlateThis = mapWallPlates.getMap(i);
	double dHeightThis = mapWallPlateThis.getDouble("HeightInElement");
	
	for (int j=(i+1);j<mapWallPlates.length();j++) {
		if (mapWallPlates.keyAt(j) != "WallPlate" || !mapWallPlates.hasMap(j))
			continue;
		
		Map mapWallPlateToCompare = mapWallPlates.getMap(j);
		double dHeightToCompare = mapWallPlateToCompare.getDouble("HeightInElement");
		
		if (abs(dHeightThis - dHeightToCompare) < dEps) {
			// Add the beams of the compared map to the map we are comparing with.
			for (int k=0;k<mapWallPlateToCompare.length();k++) {
				if (mapWallPlateToCompare.keyAt(k) != "Beam" || !mapWallPlateToCompare.hasEntity(k))
					continue;
				// Get the entity
				Entity entBm = mapWallPlateToCompare.getEntity(k);
				
				// Add it to the one we are comparing with.
				mapWallPlateThis.appendEntity("Beam", entBm);
			}
			// Add it at the end of the map.
			mapWallPlates.appendMap("WallPlate", mapWallPlateThis);
			// Remove the old one and replace it with the one we just added.
			mapWallPlates.removeAt(i, false);
			
			// Also remove the one we compared, but keep the sequence.
			mapWallPlates.removeAt(j, true);
			j--;
		}
		else {
			continue;
		}
	}
}

// Recalculate dimension lines
if (bRecalculateDimlines) {
	// Delete existing dimension lines.
	for (int i=0;i<_Map.length();i++) {
		if (_Map.keyAt(i) != "Dimension" || !_Map.hasEntity(i))
			continue;
		
		Entity entDim = _Map.getEntity(i);
		entDim.dbErase();
		
		_Map.removeAt(i, true);
		i--;
	}
	
	Element lstElements[0];
	Beam lstBeams[1];
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	Vector3d vxDim = -vxReference;
	Vector3d vyDim = -vyReference;
	
	Point3d ptDimRef = _Pt0 - vyReference * dOffsetDimension;
	for (int i=0;i<mapWallPlates.length();i++) {
		if (mapWallPlates.keyAt(i) != "WallPlate" || !mapWallPlates.hasMap(i))
			continue;
		
		Map mapWallPlate = mapWallPlates.getMap(i);
		
		Beam arBmWallPlate[0];
		Point3d arPtBm[0];
		Point3d arPtAnchorsForThisSetOfBeams[0];
		String arSAnchorType[0];
		for (int j=0;j<mapWallPlate.length();j++) {
			if (mapWallPlate.keyAt(j) != "Beam" || !mapWallPlate.hasEntity(j))
				continue;
			
			Entity entBm = mapWallPlate.getEntity(j);
			Beam bm = (Beam)entBm;
			
			if (!bm.bIsValid())
				continue;
			if (arBmWallPlate.find(bm) != -1)
				continue;
			
			Body bd = bm.realBody();
			bd.transformBy(300 * _ZW);
			bd.vis(j);
			
			arBmWallPlate.append(bm);
			arPtBm.append(bm.ptCenSolid() - bm.vecX() * 0.5 * bm.solidLength());
			arPtBm.append(bm.ptCenSolid() + bm.vecX() * 0.5 * bm.solidLength());
			
			Entity arEntTool[] = bm.eToolsConnected();
			for( int k=0;k<arEntTool.length();k++ ){
				TslInst tslTool = (TslInst)arEntTool[k];
				if( !tslTool.bIsValid() )
					continue;
				
				if( tslTool.scriptName() == sScriptNameAnchor){
					arPtAnchorsForThisSetOfBeams.append(tslTool.ptOrg());
					tslTool.ptOrg().vis(k);
					arSAnchorType.append(tslTool.propString(1));
				}
			}
		}
		
		// Sort anchor points and anchor types.
		for(int s1=1;s1<arPtAnchorsForThisSetOfBeams.length();s1++){
			int s11 = s1;
			for(int s2=s1-1;s2>=0;s2--){
				if( vxDim.dotProduct(arPtAnchorsForThisSetOfBeams[s11] - arPtAnchorsForThisSetOfBeams[s2]) < 0 ){
					arPtAnchorsForThisSetOfBeams.swap(s2, s11);
					arSAnchorType.swap(s2, s11);
					s11=s2;
				}
			}
		}
		for(int s1=1;s1<arSAnchorType.length();s1++){
			int s11 = s1;
			for(int s2=s1-1;s2>=0;s2--){
				if (arSAnchorType[s11] < arSAnchorType[s2]) {
					arPtAnchorsForThisSetOfBeams.swap(s2, s11);
					arSAnchorType.swap(s2, s11);
					s11=s2;
				}
			}
		}
		
		
		// Dimension for wall plates
		lstPoints.setLength(0);
		lstPoints.append(ptDimRef);
		lstPoints.append(ptDimRefStart);
		lstPoints.append(arPtBm);
		lstPoints.append(ptDimRefEnd);
		
		// Clear old content.
		mapTsl = Map();
		mapTsl.setPoint3d("VecX", ptDimRef + vxDim * U(100));
		if (nLinkDimensionToObjects) {
			Map mapDimensionObjects;
			for (int b=0;b<arBmWallPlate.length();b++ ){
				Beam bm = arBmWallPlate[b];
				mapDimensionObjects.appendEntity("Entity", bm);
			}
			mapTsl.setMap("DimensionObjects", mapDimensionObjects);
			mapTsl.setPoint3d("DimRefStart", ptDimRefStart, _kAbsolute);
			mapTsl.setPoint3d("DimRefEnd", ptDimRefEnd, _kAbsolute);
		}
		
		TslInst dimWallPlate;
		dimWallPlate.dbCreate(sScriptNameDimensionTsl, vxDim ,vyDim ,lstBeams, lstElements, lstPoints , lstPropInt, lstPropDouble,lstPropString, _kModelSpace, mapTsl); // create new instance	
		dimWallPlate.setPropValuesFromCatalog(sCatalogDimensionTsl);
		dimWallPlate.setPropString(8, "MP");
		dimWallPlate.setPropString(11, sAssignToGroup);
		_Map.appendEntity("Dimension", dimWallPlate);
		
		ptDimRef -= vyReference * dBetweenDimension;
		
		Point3d arPtAnchor[0];
		String sCurrentAnchorType;
		int bDimLastPoints = false;
		for (int a=0;a<arSAnchorType.length();a++) {
			String sAnchorType = arSAnchorType[a];
			Point3d ptAnchor = arPtAnchorsForThisSetOfBeams[a];
			
			int bPlaceDim = false;
			if (a==0){
				sCurrentAnchorType = sAnchorType;
				arPtAnchor.append(ptAnchor);
				
				if (a == (arPtAnchorsForThisSetOfBeams.length() - 1))
					bPlaceDim = true;
			}
			else if (sCurrentAnchorType != sAnchorType || bDimLastPoints ) {
				bPlaceDim = true;
			}
			else {
				arPtAnchor.append(ptAnchor);
			}
		
			if (bPlaceDim) {
				// Dimension achors for this set of beams.
				lstPoints.setLength(0);
				lstPoints.append(ptDimRef);
				lstPoints.append(ptDimRefStart);
				lstPoints.append(arPtAnchor);
				lstPoints.append(ptDimRefEnd);
				
				// Clear old content.
				mapTsl = Map();
				mapTsl.setPoint3d("VecX", ptDimRef + vxDim * U(100));
				if (nLinkDimensionToObjects) {
					Map mapDimensionObjects;
					
					// Add this map to the map of the tsl. 
					// The dimension tsl will get it's dimension points based on the instructions in this subMapX.
					Map mapChildItems;
					mapChildItems.setString("Type", "TslInst");
					mapChildItems.setString("ScriptName", sScriptNameAnchor);
					
					Map mapPropertyFilter;
					mapPropertyFilter.setInt("Index", 1);
					mapPropertyFilter.setString("Value", sCurrentAnchorType);
					mapChildItems.setMap("PropertyFilter", mapPropertyFilter);
					
					mapTsl.setMap("ChildItems", mapChildItems);
					for (int b=0;b<arBmWallPlate.length();b++ ){
						Beam bm = arBmWallPlate[b];
						mapDimensionObjects.appendEntity("Entity", bm);
					}
					mapTsl.setMap("DimensionObjects", mapDimensionObjects);
					mapTsl.setPoint3d("DimRefStart", ptDimRefStart, _kAbsolute);
					mapTsl.setPoint3d("DimRefEnd", ptDimRefEnd, _kAbsolute);
				}
			
				TslInst dimAnchors;
				dimAnchors.dbCreate(sScriptNameDimensionTsl, vxDim ,vyDim ,lstBeams, lstElements, lstPoints , lstPropInt, lstPropDouble,lstPropString, _kModelSpace, mapTsl); // create new instance	
				dimAnchors.setPropValuesFromCatalog(sCatalogDimensionTsl);
				dimAnchors.setPropString(8, sCurrentAnchorType);
				dimAnchors.setPropString(11, sAssignToGroup);
				_Map.appendEntity("Dimension", dimAnchors);
				
				ptDimRef -= vyReference * dBetweenDimension;
				
				sCurrentAnchorType = sAnchorType;
				arPtAnchor.setLength(0);
				if (a>0 && !bDimLastPoints)
					arPtAnchor.append(ptAnchor);
			}
			
			if (a == (arPtAnchorsForThisSetOfBeams.length() - 1) && arPtAnchor.length() > 0 && !bDimLastPoints ){
				a--;
				bDimLastPoints = true;
			}
		}
	}
	
	// Dimension elements.
	lstPoints.setLength(0);
	lstPoints.append(ptDimRef);
	lstPoints.append(ptDimRefStart);
	lstPoints.append(arPtElement);
	lstPoints.append(ptDimRefEnd);
	
	// Clear old content.
	mapTsl = Map();
	mapTsl.setPoint3d("VecX", ptDimRef + vxDim * U(100));
	if (nLinkDimensionToObjects) {
		Map mapDimensionObjects;
		for (int e=0;e<_Element.length();e++ ){
			Element el = _Element[e];
			mapDimensionObjects.appendEntity("Entity", el);
		}
		mapTsl.setMap("DimensionObjects", mapDimensionObjects);
		mapTsl.setPoint3d("DimRefStart", ptDimRefStart, _kAbsolute);
		mapTsl.setPoint3d("DimRefEnd", ptDimRefEnd, _kAbsolute);
	}
	
	TslInst dimElements;
	dimElements.dbCreate(sScriptNameDimensionTsl, vxDim ,vyDim ,lstBeams, lstElements, lstPoints , lstPropInt, lstPropDouble,lstPropString, _kModelSpace, mapTsl); // create new instance	
	dimElements.setPropValuesFromCatalog(sCatalogDimensionTsl);
	dimElements.setPropString(8, "Elements");
	dimElements.setPropString(11, sAssignToGroup);
	if (nLinkDimensionToObjects)
		dimElements.setPropString(10, T("|Yes|"));
	_Map.appendEntity("Dimension", dimElements);
	
	ptDimRef -= vyReference * dBetweenDimension;
}






#End
#BeginThumbnail
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
4%`!1110`4444`%%%%`!1110!_]E%
`


#End