#Version 8
#BeginDescription
Last modified by Anno Sportel  (anno.sportel@hsbcad.com).
14.09.2016  -  version 1.04



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// Requires HSB_G-FilterGenBeams for filtering.
/// </remark>

/// <version  value="1.04" date="14.09.2016"></version>

/// <history>
/// AS - 1.00 - 07.05.2014 - 	Pilot version
/// AS - 1.01 - 16.10.2014 - 	Add width height and length as nameformats. Support a total row.
/// AS - 1.02 - 06.09.2016 - 	Add filter options.
/// AS - 1.03 - 14.09.2016 - 	Order by element number, use profbrutto as area instead of bounding box.
/// AS - 1.04 - 14.09.2016 - 	Add recalc triggers to add and remove elements if selection mode is set to select elements..
/// </hsitory>

Unit (1,"mm");

String arSInsertType[] = {
	T("|Select entire project|"),
	T("|Select floor level in floor level list|"),
	T("|Select current floor level|"),
	T("|Select elements in drawing|")
};

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sInsertType(1, arSInsertType, "     "+T("|Selection mode|"),3);

PropString beamCodesToExclude(10, "", "     " + T("|Beam codes to exclude|"));
PropString materialsToExclude(11, "", "     " + T("|Materials to exclude|"));
PropString labelsToExclude(12, "", "     " + T("|Labels to exclude|"));

String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ElementTable");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
}

int nInsertType = arSInsertType.find(sInsertType, 3);
sInsertType.setReadOnly(true);

String arSNameFloorGroup[] = {""};
Group arFloorGroup[0];
Group arAllGroups[] = Group().allExistingGroups();
for( int i=0;i<arAllGroups.length();i++ ){
	Group grp = arAllGroups[i];
	if( grp.namePart(2) == "" && grp.namePart(1) != ""){
		arSNameFloorGroup.append(grp.name());
		arFloorGroup.append(grp);
	}
}
PropString sNameFloorGroup(2, arSNameFloorGroup, "     "+T("|Floorgroup|"),0);
if( nInsertType != 1 )
	sNameFloorGroup.setReadOnly(true);

String recalcTriggers[0];
if (nInsertType == 3) {
	recalcTriggers.append(T("|Add elements|"));
	recalcTriggers.append(T("|Remove elements|"));
}
for( int i=0;i<recalcTriggers.length();i++ )
	addRecalcTrigger(_kContext, recalcTriggers[i] );	

PropString sSeperator02(3, "", T("|Table|"));
sSeperator02.setReadOnly(true);
String arSTitle[] = {
	T("|Project name|/")+T("|Project number|")
};
PropString sPropTitle(4, arSTitle, "     "+T("|Title|"));
PropString sSubtitle(5, "", "     "+T("|Subtitle|"));

//TODO: Externalize the list of headers and column formats.
String arSColumnHeader[] = {
	"Element",
	"Barcode",
	"Dikte [mm]",
	"Hoogte [mm]",
	"Lengte [mm]",
	"Brutto opp. [m²]",
	"Versterkingen",
	"Electra",
	"Datum  "
};
String arSColumnContentFormat[] = {
	"@(ProjectNumber)/@(ElementNumber)",
	"*@(ProjectNumber)/@(ElementNumber)*",
	"@(Width)",
	"@(Height)",
	"@(Length)",
	"*@(Area)*",
	"",
	"",
	""
};
int arBIsBarCodeColumn[] = {
	false,
	true,
	false,
	false,
	false,
	true,
	false,
	false,
	false
};
int arBAddTotalRow[] = {
	false,
	false,
	false,
	false,
	true,
	false,
	false,
	false,
	false
};

PropString sSeperator03(6, "", T("|Style|"));
sSeperator03.setReadOnly(true);
PropString sDimStyleHeader(7, _DimStyles, "     "+T("|Dimension style header|"));
PropString sDimStyleContent(8, _DimStyles, "     "+T("|Dimension style content|"));
PropString sDimStyleBarCode(9, _DimStyles, "     "+T("|Dimension style barcodes|"));
PropInt nColorHeader(0, -1, "     "+T("|Color header|"));
PropInt nColorContent(1, -1, "     "+T("|Color content|"));
PropInt nColorTable(2, -1, "     "+T("|Color Table|"));

if( _bOnInsert ){
	if( (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1) )
		showDialog(); 
	
	Entity arEntSelected[0];
	if( nInsertType == 0 ){//Select entire project
		// Take all elements from an empty group. This means that it will take the elements from the entire drawing.
		arEntSelected.append(Group().collectEntities(true, Element(), _kModelSpace));
	}
	else if( nInsertType == 1 ){//Select floor level in floor level list
		Group grpFloor = arFloorGroup[arSNameFloorGroup.find(sNameFloorGroup,1) - 1];
		// Take all elements from the selected group.
		arEntSelected.append(grpFloor.collectEntities(true, Element(), _kModelSpace));
	}
	else if( nInsertType == 2 ){//Select current group
		Group grpCurrent = _kCurrentGroup;
		if( grpCurrent.namePart(2) == "" && grpCurrent.namePart(1) != "" )
			// Take all elements from the selected group.
			arEntSelected.append(grpCurrent.collectEntities(true, Element(), _kModelSpace));
	}
	else if( nInsertType == 3 ){//Select elements
		PrEntity ssE(T("|Select one or more elements|"), Element());
		if( ssE.go() )
			arEntSelected.append(ssE.set());
	}
	
	for( int i=0;i<arEntSelected.length();i++ ){
		Entity ent = arEntSelected[i];
		Element el = (Element)ent;

		// Element entities need to be collected unless we are selecting entities in which case
		// if only an element is selected then that is what we will export.
		if( el.bIsValid() )
			_Element.append(el);	
	}
	
	_Pt0 = getPoint(T("|Select a position for the table|"));
	
	return;
}

if (_kExecuteKey == recalcTriggers[0] || _kExecuteKey == recalcTriggers[1]) {
	String prompt = T("|Select one or more elements to add|");
	int addElements = true;
	if (_kExecuteKey == recalcTriggers[1]) {
		prompt = T("|Select one or more elements to remove|");
		addElements = false;
	}
	
	Element selectedElements[0];
	PrEntity ssE(prompt, Element());
	if( ssE.go() )
		selectedElements.append(ssE.elementSet());
		
	for (int s=0;s<selectedElements.length();s++) {
		Element el = selectedElements[s];
		int elementIndex = _Element.find(el);
		if (addElements && elementIndex == -1)
			_Element.append(el);
		else if (!addElements && elementIndex != -1)
			_Element.removeAt(elementIndex);
	}
}

Display dpTable(nColorTable);
Display dpHeader(nColorHeader);
dpHeader.dimStyle(sDimStyleHeader);
Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyleContent);
Display dpBarCodeContent(nColorContent);
dpBarCodeContent.dimStyle(sDimStyleBarCode);

double dExtraWColumn = dpContent.textLengthForStyle("XX", sDimStyleContent);

double arDWColumn[0];
for( int i=0;i<arSColumnHeader.length();i++ ){
	String sHeader = arSColumnHeader[i];
	double dWHeader = dpHeader.textLengthForStyle(sHeader, sDimStyleHeader);
	if( arDWColumn.length() == i ){
		arDWColumn.append(dWHeader + dExtraWColumn);
	}
	else{
		if( arDWColumn[i] < (dWHeader + dExtraWColumn))
			arDWColumn[i] = (dWHeader + dExtraWColumn);
	}
}

// Sort by elementname
for(int s1=1;s1<_Element.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( _Element[s11].number() < _Element[s2].number() ){
			_Element.swap(s2, s11);
			s11=s2;
		}
	}
}

Map arMapRow[0];
double arDTotals[arSColumnContentFormat.length()];
for( int i=0;i<_Element.length();i++ ){
	Element el = _Element[i];
	
	GenBeam arGBm[] = el.genBeam();
	if (beamCodesToExclude.length() > 0 || materialsToExclude.length() > 0 || labelsToExclude.length() > 0) {
		Entity genBeamEntities[0];
		for (int g=0;g<arGBm.length();g++)
			genBeamEntities.append(arGBm[g]);
//		reportNotice("\nElement: " + el.number() + "\tNumber of beams: " + genBeamEntities.length()); 
		Map filterGenBeamsMap;
		filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
		filterGenBeamsMap.setString("BeamCode[]", beamCodesToExclude);
		filterGenBeamsMap.setString("Material[]", materialsToExclude);
		filterGenBeamsMap.setString("Label[]", labelsToExclude);
		filterGenBeamsMap.setInt("Exclude", true);
		int successfullyFiltered = TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
		if (!successfullyFiltered) {
			reportWarning(TN("|Beams could not be filtered|!") + TN("|Make sure that the tsl| ") + "HSB_G-FilterGenBeams" + T(" |is loaded in the drawing|."));
		}
		else{
			Entity filteredGenBeams[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
			arGBm.setLength(0);
			for (int g=0;g<filteredGenBeams.length();g++) {
				GenBeam gBm = (GenBeam)filteredGenBeams[g];
				if (gBm.bIsValid())
					arGBm.append(gBm);
			}
		}
//		reportNotice("\tNumber of beams: " + arGBm.length()); 
	}
	
	Point3d arPtGBm[0];
	double dElWidth;
	double dElHeight;
	double dElLength;	
	
	Map mapRow;
	for( int j=0;j<arSColumnContentFormat.length();j++ ){
		String sColumnContentFormat = arSColumnContentFormat[j];
		int bIsBarCodeColumn = arBIsBarCodeColumn[j];
		int bAddTotalRow = arBAddTotalRow[j];
		
		String sColumnContent = "";
		if (sColumnContentFormat.find("@",0) != -1) {
			String sList = sColumnContentFormat + "@";
			int nTokenIndex = 0; 
			int nCharacterIndex = 0;
			while(nCharacterIndex < sList.length()-1){
				String sListItem = sList.token(nTokenIndex,"@");
				nTokenIndex++;
				if(sListItem.length()==0){
					nCharacterIndex++;
					continue;
				}
				nCharacterIndex = sList.find(sListItem,0);
				sListItem.trimLeft();
				sListItem.trimRight();
				
				int nIndexProjectNumber = sListItem.find("(ProjectNumber)",0);
				int nIndexElementNumber = sListItem.find("(ElementNumber)",0);
				int nIndexWidth = sListItem.find("(Width)",0);
				int nIndexHeight = sListItem.find("(Height)",0);
				int nIndexLength = sListItem.find("(Length)",0);
				int nIndexElementArea = sListItem.find("(Area)",0);
				// Do we have to resolve the project number?
				if( nIndexProjectNumber != -1 ){
					String sPrefix = sListItem.left(nIndexProjectNumber);
					String sPostfix = sListItem.right(sListItem.length() - (nIndexProjectNumber + "(ProjectNumber)".length()));
					
					sListItem = sPrefix + projectNumber() + sPostfix;
				}
				// Do we have to resolve the element number?
				if( nIndexElementNumber != -1 ){
					String sPrefix = sListItem.left(nIndexElementNumber);
					String sPostfix = sListItem.right(sListItem.length() - (nIndexElementNumber + "(ElementNumber)".length()));
					
					String sElNumber = el.number();
					while( sElNumber.length() < 3 )
						sElNumber = "0" + sElNumber;
					sListItem = sPrefix + sElNumber + sPostfix;
				}
				// Do we have to resolve the width?
				if( nIndexWidth != -1 ){
					String sPrefix = sListItem.left(nIndexElementArea);
					String sPostfix = sListItem.right(sListItem.length() - (nIndexWidth+ "(Width)".length()));
					String sResolvedProperty = "Width";
					
					if (arPtGBm.length() == 0) {
						for (int k=0;k<arGBm.length();k++) {
							GenBeam gBm = arGBm[k];
							arPtGBm.append(gBm.envelopeBody(false, true).allVertices());
						}
					}			
					Point3d arPtElZ[] = Line(el.ptOrg(), el.vecZ()).orderPoints(arPtGBm);
					if (arPtElZ.length() > 0) {
						dElWidth = el.vecZ().dotProduct(arPtElZ[arPtElZ.length() - 1] - arPtElZ[0]);
						sResolvedProperty.formatUnit(dElWidth, 2, 0);
					}				
					
					if (bAddTotalRow)
						arDTotals[j] += dElWidth;
					
					sListItem = sPrefix + sResolvedProperty + sPostfix;
				}
				// Do we have to resolve the height?
				if( nIndexHeight != -1 ){
					String sPrefix = sListItem.left(nIndexElementArea);
					String sPostfix = sListItem.right(sListItem.length() - (nIndexHeight+ "(Height)".length()));
					String sResolvedProperty = "Height";
					
					if (arPtGBm.length() == 0) {
						for (int k=0;k<arGBm.length();k++) {
							GenBeam gBm = arGBm[k];
							arPtGBm.append(gBm.envelopeBody(false, true).allVertices());
						}
					}			
					Point3d arPtElY[] = Line(el.ptOrg(), el.vecY()).orderPoints(arPtGBm);
					if (arPtElY.length() > 0) {
						dElHeight = el.vecY().dotProduct(arPtElY[arPtElY.length() - 1] - arPtElY[0]);
						sResolvedProperty.formatUnit(dElHeight, 2, 0);
					}
					
					if (bAddTotalRow)
						arDTotals[j] += dElHeight;
					
					sListItem = sPrefix + sResolvedProperty + sPostfix;
				}
				// Do we have to resolve the length?
				if( nIndexLength != -1 ){
					String sPrefix = sListItem.left(nIndexElementArea);
					String sPostfix = sListItem.right(sListItem.length() - (nIndexLength+ "(Length)".length()));
					String sResolvedProperty = "Length";
					
					if (arPtGBm.length() == 0) {
						for (int k=0;k<arGBm.length();k++) {
							GenBeam gBm = arGBm[k];
							arPtGBm.append(gBm.envelopeBody(false, true).allVertices());
						}
					}			
					Point3d arPtElX[] = Line(el.ptOrg(), el.vecX()).orderPoints(arPtGBm);
					if (arPtElX.length() > 0) {
						dElLength = el.vecX().dotProduct(arPtElX[arPtElX.length() - 1] - arPtElX[0]);
						sResolvedProperty.formatUnit(dElLength, 2, 0);
					}
					
					if (bAddTotalRow)
						arDTotals[j] += dElLength;
					
					sListItem = sPrefix + sResolvedProperty + sPostfix;
				}
				
				// Do we have to resolve the element area?
				if( nIndexElementArea != -1 ){
					String sPrefix = sListItem.left(nIndexElementArea);
					String sPostfix = sListItem.right(sListItem.length() - (nIndexElementArea + "(Area)".length()));
					
					// Calculate the area
					double dArea = el.profBrutto(0).area();// Request from Stefaan to get the main outline as area: dElLength * dElHeight;
					if (dArea <= 0) {
						dArea = el.plEnvelope().area();
					
						PlaneProfile ppEl(el.plEnvelope());
						Beam arBm[] = el.beam();
						Plane pnElZ(el.ptOrg(), el.vecZ());
						for( int i=0;i<arBm.length();i++ ){
							Beam bm = arBm[i];
							PlaneProfile ppThisBm = bm.envelopeBody().shadowProfile(pnElZ);
							ppThisBm.shrink(-U(0.01));
							CoordSys csRotate;
							csRotate.setToRotation(0.01, el.vecZ(), bm.ptCen());
							ppThisBm.transformBy(csRotate);
							ppEl.unionWith(ppThisBm);			
						}
						ppEl.shrink(U(0.01));
										
						PLine arPlEl[] = ppEl.allRings();
						PLine plElOutline;
						int arBRingIsOpening[] = ppEl.ringIsOpening();
						for( int i=0;i<arPlEl.length();i++ ){
							if( arBRingIsOpening[i] )
								continue;
							
							PLine pl = arPlEl[i];
							if( pl.area() > plElOutline.area() )
								plElOutline = pl;
						}
						dArea = plElOutline.area();
					}
									
					if (bAddTotalRow)
						arDTotals[j] += dArea;
					
					dArea /= 1000000;
					String sElArea;
					sElArea.formatUnit(dArea, 2, 3);
					sListItem = sPrefix + sElArea + sPostfix;
				}
				sColumnContent += sListItem;
			}
		}
		
		double dWColumn = dpContent.textLengthForStyle(sColumnContent, sDimStyleContent);
		if( bIsBarCodeColumn )
			dWColumn = dpBarCodeContent.textLengthForStyle(sColumnContent, sDimStyleBarCode);
		if( arDWColumn.length() == j ){
			arDWColumn.append(dWColumn + dExtraWColumn);
		}
		else{
			if( arDWColumn[j] < (dWColumn + dExtraWColumn) )
				arDWColumn[j] = (dWColumn + dExtraWColumn);
		}
		
		mapRow.appendString("Column", sColumnContent);
	}
	arMapRow.append(mapRow);
}

int bTableHasTotalRow = (arBAddTotalRow.find(true) != -1);
if (bTableHasTotalRow) {
	Map mapTotalRow;
	for (int i=0;i<arDTotals.length();i++) {
		String sTotal = "";
		if (arBAddTotalRow[i]) {
			double dTotal = arDTotals[i];
			sTotal.formatUnit(dTotal, 2, 0);
		}
		mapTotalRow.appendString("Column", sTotal);
	}
	arMapRow.append(mapTotalRow);
}

// Start drawing the table.
double dRowHeight = 2 * dpContent.textHeightForStyle("hsbCAD", sDimStyleContent);
double dRowHeightBarCode = 2 * dpBarCodeContent.textHeightForStyle("hsbCAD", sDimStyleBarCode);
if( dRowHeightBarCode > dRowHeight )
	dRowHeight = dRowHeightBarCode;
	
double dTableWidth;
for( int i=0;i<arDWColumn.length();i++ )
	dTableWidth += arDWColumn[i];
	
Point3d ptTxtThisRow = _Pt0 + _XU * 0.5 * dExtraWColumn - _YU * 0.5 * dRowHeight;

PLine plRow(_Pt0, _Pt0 + _XU * dTableWidth);
dpTable.draw(plRow);
PLine plFirstColumn(_Pt0, _Pt0 - _YU * dRowHeight);


// Draw the title
String sTitle;
if( arSTitle.find(sPropTitle) == 0 )
	sTitle = projectName() + "/" + projectNumber();
dpHeader.draw(sTitle, ptTxtThisRow, _XU, _YU, 1, 0);
ptTxtThisRow -= _YU * dRowHeight;
plRow.transformBy(-_YU * dRowHeight);

PLine plColumn = plFirstColumn;
dpTable.draw(plColumn);
plColumn.transformBy(_XU * dTableWidth);
dpTable.draw(plColumn);
plFirstColumn.transformBy(-_YU * dRowHeight);

// Draw the subtitle
dpHeader.draw(sSubtitle, ptTxtThisRow, _XU, _YU, 1, 0);
ptTxtThisRow -= _YU * dRowHeight;
plRow.transformBy(-_YU * dRowHeight);
dpTable.draw(plRow);

plColumn = plFirstColumn;
dpTable.draw(plColumn);
plColumn.transformBy(_XU * dTableWidth);
dpTable.draw(plColumn);
plFirstColumn.transformBy(-_YU * dRowHeight);

// Draw the headers
Point3d ptTxtColumn = ptTxtThisRow;
plColumn = plFirstColumn;
dpTable.draw(plColumn);
for( int i=0;i<arSColumnHeader.length();i++ ){
	String sHeader = arSColumnHeader[i];
	double dWColumn = arDWColumn[i];
	
	dpHeader.draw(sHeader, ptTxtColumn, _XU, _YU, 1, 0);
	ptTxtColumn += _XU * dWColumn;
	
	plColumn.transformBy(_XU * dWColumn);
	dpTable.draw(plColumn);
}
ptTxtThisRow -= _YU * dRowHeight;
plRow.transformBy(-_YU * dRowHeight);
dpTable.draw(plRow);
ptTxtColumn = ptTxtThisRow;
plFirstColumn.transformBy(-_YU * dRowHeight);

// Draw the content
for( int i=0;i<arMapRow.length();i++ ){
	Map mapRow = arMapRow[i];
	int nColumnIndex = 0;
	
	plColumn = plFirstColumn;
	dpTable.draw(plColumn);
	
	for( int j=0;j<mapRow.length();j++ ){
		if( mapRow.keyAt(j) != "Column" || !mapRow.hasString(j) )
			continue;
		
		String sColumn = mapRow.getString(j);		
		double dWColumn = arDWColumn[nColumnIndex];
		int bIsBarCodeColumn = arBIsBarCodeColumn[nColumnIndex];
		
		if( bIsBarCodeColumn )
			dpBarCodeContent.draw(sColumn, ptTxtColumn, _XU, _YU, 1, 0);
		else
			dpContent.draw(sColumn, ptTxtColumn, _XU, _YU, 1, 0);
		ptTxtColumn += _XU * dWColumn;
		
		plColumn.transformBy(_XU * dWColumn);
		dpTable.draw(plColumn);
		
		nColumnIndex++;
	}
	
	ptTxtThisRow -= _YU * dRowHeight;
	plRow.transformBy(-_YU * dRowHeight);
	dpTable.draw(plRow);
	ptTxtColumn = ptTxtThisRow;
	plFirstColumn.transformBy(-_YU * dRowHeight);
	
	if (bTableHasTotalRow && i == (arMapRow.length() - 1)) {
		plRow.transformBy(_YU * 0.9 * dRowHeight);
		dpTable.draw(plRow);
	}
}

#End
#BeginThumbnail
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
0@`HHHH`****`"BBB@#__V:):
`





#End