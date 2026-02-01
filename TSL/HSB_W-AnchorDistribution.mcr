#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
21.12.2017  -  version 1.07
























Version 1.8 3-10-2024 Add .showInDxa and set to true to make in show in hsbMake. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Inserts anchors.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// -
/// </remark>

/// <version  value="1.07" date="21.12.2017"></version>

/// <history>
/// AS - 1.00 - 21.04.2016	- Pilot version
/// AS - 1.01 - 21.04.2016	- Add option to position anchors at top of element. Add subtype for dimension lines created by D-Element
/// AS - 1.02 - 17.06.2016	- Add manual insert mode.
/// AS - 1.03 - 17.06.2016	- Add option for anchors at left and righthand side
/// AS - 1.04 - 27.09.2016	- Show anchors in top view.
/// AS - 1.05 - 21.07.2017	- Hide plan display in elevation view.
/// AS - 1.06 - 21.12.2017	- Distribute over envelope outline of element. Make edge anchors optional.
/// AS - 1.07 - 21.12.2017	- Correct quantity
/// </history>

//#Versions
//1.8 3-10-2024 Add .showInDxa and set to true to make in show in hsbMake. Ronald van Wijngaarden


Unit (1,"mm");
double dEps = U(0.1);

int executeMode = 0; // 0 = default, 1 = insert/recalc, 2 = add, 3 = remove

String categories[] = {
	T("|Anchors|"),
	T("|Anchor distribution|"),
	T("|Style|")
};	

String recalcProperties[0];

String sides[] = {T("|Top|"), T("|Bottom|"), T("|Right|"), T("|Left|")};
int sideIndexes[] = {1,2,3,4};
String yesNo[] = {T("|Yes|"), T("|No|")};
String dimensionModes[] = {T("|No dimension|"), T("|General spacing|"), T("All anchor positions|")};

PropString anchorSymbol(0, "X", T("|Symbol|"));
anchorSymbol.setCategory(categories[0]);
PropString articleNumber(1, "", T("|Article number|"));
articleNumber.setCategory(categories[0]);
PropString subType(7, "", T("|Subtype|"));
subType.setCategory(categories[0]);
subType.setDescription(T("|The subtype is set as dimension information.|") +TN("|The dimension tsl can filter on subtype.|"));

PropString propManualMode(8, yesNo, T("|Select anchor positions manually|"), 1);
recalcProperties.append(T("|Select anchor positions manually|"));
propManualMode.setCategory(categories[1]);
propManualMode.setDescription(T("|The anchor positions have to be selected manually.|") + T(" |The distribution parameters are not used.|"));
PropString propSide(6, sides, T("|Side|"), 1);
recalcProperties.append(T("|Side|"));
propSide.setCategory(categories[1]);
PropDouble maximumCenterSpacing(3, U(1000), T("|Maximum center spacing|"));
recalcProperties.append(T("|Maximum center spacing|"));
maximumCenterSpacing.setCategory(categories[1]);
PropString propDistributeEvenly(4, yesNo, T("|Ditribute evenly|"));
recalcProperties.append(T("|Ditribute evenly|"));
propDistributeEvenly.setCategory(categories[1]);
PropDouble minimumDistanceBetweenAnchors(4, U(300), T("|Minimum allowed distance between anchors|"));
recalcProperties.append(T("|Minimum allowed distance between anchors|"));
minimumDistanceBetweenAnchors.setCategory(categories[1]);
PropString propAnchorsUnderDoor(5, yesNo, T("|Anchors under doors|"), 1);
recalcProperties.append(T("|Anchors under doors|"));
propAnchorsUnderDoor.setCategory(categories[1]);
PropDouble distanceToDoor(5, U(50), T("|Distance to door|"));
recalcProperties.append(T("|Distance to door|"));
distanceToDoor.setCategory(categories[1]);
PropDouble distanceToEdge(6, U(150), T("|Distance to edge|"));
recalcProperties.append(T("|Distance to edge|"));
distanceToEdge.setCategory(categories[1]);
PropString propApplyEdgeAnchors(9, yesNo, T("|Apply anchors at the edge|"), 0);
recalcProperties.append(T("|Apply anchors at the edge|"));
propApplyEdgeAnchors.setCategory(categories[1]);


PropInt anchorColor(0, 1, T("|Color|"));
anchorColor.setCategory(categories[2]);
PropDouble textHeight(0, U(50), T("|Text size|"));
textHeight.setCategory(categories[2]);
PropDouble textHeightDimension(1, U(30), T("|Text size dimension|"));
textHeightDimension.setCategory(categories[2]);
PropDouble offsetFromElementY(2, U(150), T("|Offset from element|"));
offsetFromElementY.setCategory(categories[2]);
PropString propDimensionMode(2, dimensionModes, T("|Dimension|"));
propDimensionMode.setCategory(categories[2]);
PropString propShowAnchors(3, yesNo, T("|Visualize anchors|"));
propShowAnchors.setCategory(categories[2]);


String addHardwareEvents[] = {
	T("|Symbol|"),
	T("|Article number|")
};

String recalcTriggers[] = {
	T("|Recalculate|"),
	T("|Add anchor|"),
	T("|Remove anchor|")
};
for( int i=0;i<recalcTriggers.length();i++ )
	addRecalcTrigger(_kContext, recalcTriggers[i] );

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_W-AnchorDistribution");
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
	
	int manualMode = (yesNo.find(propManualMode, 1) == 0);
	
	if (!manualMode) {
		PrEntity ssElements(T("|Select elements|") + T(" [<Enter, for manual mode|>"), Element());
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
			
			eraseInstance();
			return;		
		}
	}
	else {
		_Element.append(getElement(T("|Select an element|")));
		
		Point3d ptLast = getPoint(T("|Select a position|"));
		Point3d arPtAnchor[] = {
			ptLast
		};
		while( true ){
			PrPoint ssP2(TN("|Select next point|")); 
			if( ssP2.go()==_kOk ){
				ptLast = ssP2.value();
				arPtAnchor.append(ptLast);
			}
			else{
				break;
			}
		}
		
		_PtG.append(arPtAnchor);
		
		return;
	}
}

if (_Element.length() == 0) {
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}
_ThisInst.setAllowGripAtPt0(false);

int manualMode = (yesNo.find(propManualMode, 1) == 0);

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));


if( recalcProperties.find(_kNameLastChangedProp) != -1 )
	executeMode = 1;

if( _bOnElementConstructed || manualInserted)
	executeMode = 1;

// recalculate
if( _kExecuteKey == recalcTriggers[0] )
	executeMode = 1;

// add
if( _kExecuteKey == recalcTriggers[1] )
	executeMode = 2;

// remove
if( _kExecuteKey == recalcTriggers[2] )
	executeMode = 3;

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

ElementWallSF el = (ElementWallSF)_Element[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

assignToElementGroup(el, true, 0, 'E');

int position = sideIndexes[sides.find(propSide, 1)];
int side = 1;
if (position == 2 || position == 4)
	side *= -1;



int distributeEvenly = (yesNo.find(propDistributeEvenly,0) == 0);
int anchorsUnderDoor = (yesNo.find(propAnchorsUnderDoor,1) == 0);
int dimensionMode = dimensionModes.find(propDimensionMode,0);
int showAnchors = (yesNo.find(propShowAnchors,0) == 0);
int applyEdgeAnchors = (yesNo.find(propApplyEdgeAnchors) == 0);

Map mapDimInfo;
if (subType != "")
	mapDimInfo.setString("SubType", subType);
_Map.setMap("DimInfo", mapDimInfo);


CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

Vector3d distributionX = elX;
Vector3d distributionY = elY;
if (position > 2) {
	distributionX = -elY;
	distributionY = elX;
}
_Pt0 = ptEl;

Line lnDistributionX(ptEl, distributionX);
Line lnDistributionY(ptEl, distributionY);

Point3d bottomLeft = ptEl;
Point3d topRight = el.segmentMinMax().ptEnd();
topRight += elZ * elZ.dotProduct(bottomLeft - topRight);
Point3d topLeft = bottomLeft + elY * elY.dotProduct(topRight - bottomLeft);
Point3d bottomRight = topRight + elY * elY.dotProduct(bottomLeft - topRight);

if (position > 2) {
	Point3d temp = bottomLeft;
	bottomLeft = topLeft;	
	topLeft = topRight;
	topRight = bottomRight;
	bottomRight = temp;
}

Display dpAnchor(anchorColor);
dpAnchor.showInDxa(true);
dpAnchor.textHeight(textHeight);
dpAnchor.elemZone(el, 0, 'I');
dpAnchor.addHideDirection(elZ);
dpAnchor.addHideDirection(-elZ);
Display dpAnchorElevation(anchorColor);
dpAnchorElevation.textHeight(textHeight);
dpAnchorElevation.elemZone(el, 0, 'I');
dpAnchorElevation.addViewDirection(elZ);
dpAnchorElevation.addViewDirection(-elZ);

Display dpDimension(anchorColor);
dpDimension.textHeight(textHeightDimension);
dpDimension.elemZone(el, 0, 'I');

if( executeMode == 1 || _bOnDebug ){
	if (!manualMode) {
		PLine plEl = el.plEnvelope();
		Point3d arPtEl[] = plEl.vertexPoints(true);
		Point3d arPtElX[] = lnDistributionX.projectPoints(arPtEl);
		arPtElX = lnDistributionX.orderPoints(arPtElX, U(1));
		if( arPtElX.length() < 2 ){
			eraseInstance();
			return;
		}
		Point3d ptElStart = arPtElX[0];
		Point3d ptElEnd = arPtElX[arPtElX.length() - 1];
		
		Point3d arPtAnchorX[0];
		arPtAnchorX.append(ptElStart + distributionX * distanceToEdge);
		if( !anchorsUnderDoor ){
			Opening arOp[] = el.opening();
			
			//order openings from left to right
			for(int s1=1;s1<arOp.length();s1++){
				int s11 = s1;
				for(int s2=s1-1;s2>=0;s2--){
					if( distributionX.dotProduct(arOp[s11].coordSys().ptOrg() - arOp[s2].coordSys().ptOrg()) < 0 ){
						arOp.swap(s2, s11);
						
						s11=s2;
					}
				}
			}
		
			for( int i=0;i<arOp.length();i++ ){
				Opening op = arOp[i];
				Point3d arPtOp[] = op.plShape().vertexPoints(true);
				Point3d arPtThisOpY[] = lnDistributionY.orderPoints(arPtOp);
				if( arPtThisOpY.length() < 2 )
					continue;
				
				if( distributionY.dotProduct(arPtThisOpY[0] - ptEl) < U(100) ){
					Point3d arPtThisOpX[] = lnDistributionX.projectPoints(arPtOp);
					arPtThisOpX = lnDistributionX.orderPoints(arPtThisOpX, U(1));
					if( arPtThisOpX.length() > 1 ){
						arPtAnchorX.append(arPtThisOpX[0] - distributionX * distanceToDoor);
						arPtAnchorX.append(arPtThisOpX[arPtThisOpX.length() - 1] + distributionX * distanceToDoor);
					}
				}
			}
		}
		arPtAnchorX.append(ptElEnd - distributionX * distanceToEdge);
		
		Point3d arPtAnchor[0];
		for( int i=0;i<(arPtAnchorX.length() - 1);i+=2 ){
			Point3d ptAnchorStart = arPtAnchorX[i];
			Point3d ptAnchorEnd = arPtAnchorX[i + 1];
			
			double dTotalLength = distributionX.dotProduct(ptAnchorEnd - ptAnchorStart);
			if( dTotalLength < 0 )
				continue;
			
			if (dTotalLength < minimumDistanceBetweenAnchors){
				arPtAnchor.append((ptAnchorStart + ptAnchorEnd)/2);
			}
			
			int nNrOfAnchors = int(dTotalLength/maximumCenterSpacing) + 2;
			double dCenterSpacing = dTotalLength/(nNrOfAnchors - 1);
			if (!distributeEvenly)
				dCenterSpacing = maximumCenterSpacing;
				
			for( int j=0;j<nNrOfAnchors;j++ ){
				if( j<(nNrOfAnchors-1) )
					arPtAnchor.append(ptAnchorStart + distributionX * j * dCenterSpacing);
				else
					arPtAnchor.append(ptAnchorEnd);
			}			
		}
		
		//Add achors to the beams.
		_PtG.setLength(0);
		for(int i=0; i<arPtAnchor.length();i++){
			Point3d pt = arPtAnchor[i];
			pt.vis(i);
			
			if ( ! applyEdgeAnchors && (i == 0 || i == (arPtAnchor.length() - 1))) continue;
			
			_PtG.append(pt);	
		}
	}
}

if( executeMode == 2 ){ // Add
	Point3d ptLast = getPoint(T("|Select a position|"));
	Point3d arPtAnchor[] = {
		ptLast
	};
	while( true ){
		PrPoint ssP2(TN("|Select next point|")); 
		if( ssP2.go()==_kOk ){
			ptLast = ssP2.value();
			arPtAnchor.append(ptLast);
		}
		else{
			break;
		}
	}
	
	_PtG.append(arPtAnchor);
}

if( executeMode == 3 ){ // Remove
	Point3d ptLast = getPoint(T("|Select a position|"));
	Point3d arPtAnchorToDelete[] = {
		ptLast
	};
	while( true ){
		PrPoint ssP2(TN("|Select next point|")); 
		if( ssP2.go()==_kOk ){
			ptLast = ssP2.value();
			arPtAnchorToDelete.append(ptLast);
		}
		else{
			break;
		}
	}
	
	Point3d arPtAnchorNew[0];
	for( int i=0;i<_PtG.length();i++ ){
		Point3d pt = _PtG[i];
		
		int bPointDeleted = false;
		for( int j=0;j<arPtAnchorToDelete.length();j++ ){
			Point3d ptToDelete = arPtAnchorToDelete[j];
			if( abs(distributionX.dotProduct(pt - ptToDelete)) < U(2) ){
				bPointDeleted = true;
				break;
			}
		}
		if( bPointDeleted )
			continue;
		
		arPtAnchorNew.append(pt);	
	}
	_PtG.setLength(0);
	_PtG.append(arPtAnchorNew);
}

// Always project points to element X line
//dpAnchor.draw(sDescription, _Pt0 - vxEl * dOffsetFromElementX - vyEl * dOffsetFromElementY, vxEl, vyEl, -1, 0);

Line lnSide(bottomLeft, distributionX);
if (side == 1)
	lnSide = Line(topRight, distributionX);

Point3d ptAverage;
for( int i=0;i<_PtG.length();i++ ){
	_PtG[i] = lnSide.closestPointTo(_PtG[i]);
	ptAverage += _PtG[i];
	
	Point3d ptAnchor = _PtG[i] + distributionY * side * offsetFromElementY;
	if (showAnchors) {
		if (anchorSymbol == "_") {
			dpAnchorElevation.draw(anchorSymbol, ptAnchor, elX, elY, 0, -side, _kDeviceX);
			dpAnchor.draw(anchorSymbol, ptAnchor, elX, -elZ, 0, -side);
		}
		else {
			dpAnchorElevation.draw(anchorSymbol, ptAnchor, elX, elY, 0, 0, _kDeviceX);
			dpAnchor.draw(anchorSymbol, ptAnchor, elX, -elZ, 0, -5);
		}
	
		if (dimensionMode == 1 && i==0) {
			dpAnchor.draw(anchorSymbol+ ": cc " + maximumCenterSpacing+"mm", _Pt0 - distributionY * offsetFromElementY, elX, elY, 1.5, 3 * side);
		}
	}
	
	if (dimensionMode == 2) { 
		double dDist = elX.dotProduct(ptAnchor - ptEl);
		String sDist;
		sDist.formatUnit(dDist, 2, 0);
		dpAnchor.draw(sDist, ptAnchor, elX, elY, 0, 3 * side);
	}
}

if (_PtG.length() == 0) 
{
	Display dp(-1);
	dp.draw(scriptName(), _Pt0, elX, elY, 0, 0);
}

// Set flag to create hardware.
int addHardware = _bOnDbCreated;
HardWrComp hwComps[] = _ThisInst.hardWrComps();
if (hwComps.length() == 0)
{
	addHardware = true;
}
else
{
	HardWrComp hwComp = hwComps[0];
	addHardware = hwComp.quantity() != _PtG.length();
}
if (addHardwareEvents.find(_kNameLastChangedProp) != -1)
{
	addHardware = true;
}

// add hardware if model has changed or on creation
if (addHardware) 
{
	// declare hardware comps for data export
	HardWrComp hwComps[0];
   	HardWrComp hw(articleNumber, _PtG.length());
	
	hw.setCategory(T("|Connectors|"));
	hw.setManufacturer("");
	hw.setModel(articleNumber);
	hw.setMaterial("");
	hw.setDescription(anchorSymbol);
	hw.setDScaleX(0);
	hw.setDScaleY(0);
	hw.setDScaleZ(0); 
	hwComps.append(hw);

	_ThisInst.setHardWrComps(hwComps);
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
      <str nm="Comment" vl="Add .showInDxa and set to true to make in show in hsbMake." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/3/2024 4:02:29 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End