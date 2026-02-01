#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
10.07.2014  -  version 2.01





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows the genbeams which are present in the drawing
/// </summary>

/// <insert>
/// Cross select
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.01" date="10.07.2014"></version>

/// <history>
/// AS - 1.00 - 07.06.2011 -	Pilot version
/// AS - 1.01 - 20.06.2011 -	Add filters
/// AS - 1.02 - 20.06.2011 -	Add a width sort for the sheets
/// AS - 1.03 - 20.06.2011 -	Ignore small differences in sheetsize
/// AS - 1.04 - 20.06.2011 -	Swap length and width for sheet size
/// AS - 1.05 - 22.06.2011 -	Update filters
/// AS - 1.06 - 16.09.2011 -	Increase column width
/// AS - 1.07 - 01.12.2011 -	Set category index to grade of beam/sheet
/// AS - 1.08 - 20.12.2011 -	Add Id of tsl to grade
/// AS - 1.09 - 18.01.2012 -	Add Id and Catagory to individual parts of the tsl.
/// AS - 2.00 - 12.03.2013 -	Update to localizer
/// AS - 2.01 - 10.07.2014 -	Force it layer 0 during insert. Include only works if at least one filter is used.
/// </history>

double dEps = Unit(0.01, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
String arSSelectionMethod[] = {
	T("|Manual| (")+T("|cross|-")+T("|select|")
};
PropString sSelection(1, arSSelectionMethod, "     "+T("|Selection method|"));

PropString sSeperator02(2, "", T("|Filters|"));
sSeperator02.setReadOnly(true);
String arSFilterMode[] = {T("|Include|"), T("|Exlude|")};
PropString sFilterMode(3, arSFilterMode, "     "+T("|Filter mode|"),1);
PropString sCaseSensitive(4, arSYesNo, "     "+T("|Case sensitive|"),1);
PropString sFilterName(5, "", "     "+T("|Name|"));
PropString sFilterBeamCode(6, "", "     "+T("|Beamcode|"));
PropString sFilterMaterial(7, "", "     "+T("|Material|"));
PropString sFilterLabel(8, "", "     "+T("|Label|"));
PropString sFilterHsbID(9, "", "     "+T("|Hsb ID|"));
PropString sFilterZone(10, "", "     "+T("|Zone|"));

PropString sSeperator03(11, "", T("|Style|"));
sSeperator03.setReadOnly(true);
PropString sDimStyleBreakDown(12, _DimStyles, "     "+T("|Dimension style groups|"));
PropString sDimStyleContent(13, _DimStyles, "     "+T("|Dimension style content|"));
PropInt nColorBreakDown(0, 1, "     "+T("|Color groups|"));
PropInt nColorContent(1, -1, "     "+T("|Color content|"));
PropInt nColorGrid(2, -1, "     "+T("|Color lines|"));

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" )
		showDialog();
	
	int nSelectionMethod = arSSelectionMethod.find(sSelection,0);
	if( nSelectionMethod == 0 ){
		PrEntity ssE(T("|Select a set of timbers and sheets|"), GenBeam());
		if( ssE.go() ){
			Entity arEnt[] = ssE.set();
			
			for( int i=0;i<arEnt.length();i++ ){
				Entity ent = arEnt[i];
				int bIsGenBeam = ent.bIsKindOf(GenBeam());
				int bIsBeam = ent.bIsKindOf(Beam());
				int bIsSheet = ent.bIsKindOf(Sheet());
				
				if( bIsGenBeam ){
					_GenBeam.append((GenBeam)ent);
					if( bIsBeam )
						_Beam.append((Beam)ent);
					if( bIsSheet )
						_Sheet.append((Sheet)ent);
				}
			}
		}
	}
	else{
		reportWarning(T("|Invalid selection method|!"));
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select a position for the report|"));
	
	int nId = -1;
	Entity arEntTsl[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for( int i=0;i<arEntTsl.length();i++ ){
		TslInst tsl = (TslInst)arEntTsl[i];
		if( !tsl.bIsValid() )
			continue;
		if( tsl.scriptName() != "HSB_G-UsedMaterial" )
			continue;
		
		Map mapTsl = tsl.map();
		int nTslId = mapTsl.getInt("Id");
		if( nTslId > nId )
			nId = nTslId;
	}
	_Map.setInt("Id", nId + 1);
	
	// Force it to layer 0 during insert
	assignToLayer("0");
	
	return;
}

if( _GenBeam.length() == 0 ){
	reportWarning(T("|No timbers or sheets included in the selection set.|"));
	eraseInstance();
	return;
}

int nId = _Map.getInt("Id");

int nFilterMode = arSFilterMode.find(sFilterMode, 0);
int bCaseSensitive = arNYesNo[arSYesNo.find(sCaseSensitive,1)];

int bAllFiltersEmpty = true;

//Name
String sFName = sFilterName + ";";
if( !bCaseSensitive )
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
if (bAllFiltersEmpty && arSFName.length() > 0)
	bAllFiltersEmpty = false;
	
//BeamCode
String sFBeamCode = sFilterBeamCode + ";";
if( !bCaseSensitive )
	sFBeamCode.makeUpper();
String arSFBeamCode[0];
int nIndexBeamCode = 0; 
int sIndexBeamCode = 0;
while(sIndexBeamCode < sFBeamCode.length()-1){
	String sTokenBeamCode = sFBeamCode.token(nIndexBeamCode);
	nIndexBeamCode++;
	if(sTokenBeamCode.length()==0){
		sIndexBeamCode++;
		continue;
	}
	sIndexBeamCode = sFilterBeamCode.find(sTokenBeamCode,0);

	arSFBeamCode.append(sTokenBeamCode);
}
if (bAllFiltersEmpty && arSFBeamCode.length() > 0)
	bAllFiltersEmpty = false;

//Material
String sFMaterial = sFilterMaterial + ";";
if( !bCaseSensitive )
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
if (bAllFiltersEmpty && arSFMaterial.length() > 0)
	bAllFiltersEmpty = false;

//Label
String sFLabel = sFilterLabel + ";";
if( !bCaseSensitive )
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
if (bAllFiltersEmpty && arSFLabel.length() > 0)
	bAllFiltersEmpty = false;

//HsbID
String sFHsbID = sFilterHsbID + ";";
if( !bCaseSensitive )
	sFHsbID.makeUpper();
String arSFHsbID[0];
int nIndexHsbID = 0; 
int sIndexHsbID = 0;
while(sIndexHsbID < sFHsbID.length()-1){
	String sTokenHsbID = sFHsbID.token(nIndexHsbID);
	nIndexHsbID++;
	if(sTokenHsbID.length()==0){
		sIndexHsbID++;
		continue;
	}
	sIndexHsbID = sFilterHsbID.find(sTokenHsbID,0);

	arSFHsbID.append(sTokenHsbID);
}
if (bAllFiltersEmpty && arSFHsbID.length() > 0)
	bAllFiltersEmpty = false;

//Zone
String sFZone = sFilterZone + ";";
int arNFZone[0];
int nIndexZone = 0; 
int sIndexZone = 0;
while(sIndexZone < sFZone.length()-1){
	String sTokenZone = sFZone.token(nIndexZone);
	nIndexZone++;
	if(sTokenZone.length()==0){
		sIndexZone++;
		continue;
	}
	sIndexZone = sFilterZone.find(sTokenZone,0);

	int nZone = sTokenZone.atoi();
	if( nZone > 5 )
		nZone = 5 - nZone;
	arNFZone.append(nZone);
}
if (bAllFiltersEmpty && arNFZone.length() > 0)
	bAllFiltersEmpty = false;


GenBeam arGBmAll[0];
arGBmAll.append(_GenBeam);

Beam arBm[0];
Sheet arSh[0];
String arSShSize[0];

String sColumnW;

for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];

	String sName = gBm.name();
	sName.trimLeft();
	sName.trimRight();
	if( !bCaseSensitive )
		sName.makeUpper();
	int bName = false;
	for( int j=0;j<arSFName.length();j++ ){
		String sFName = arSFName[j];
		if( sFName.left(1) == "*" ){
			sFName.trimLeft("*");
			if( sFName.right(1) == "*" ){
				sFName.trimRight("*");
				if( sName.find(sFName, 0) != -1 ){
					bName = true;
					break;
				}
			}
			else{
				if( sName.right(sFName.length()) == sFName ){
					bName = true;
					break;
				}
			}
		}
		else if( sFName.right(1) == "*" ){
			sFName.trimRight("*");
			if( sName.find(sFName, 0) == 0 ){
				bName = true;
				break;
			}
		}
		else{
			if( sName == sFName ){
				bName = true;
				break;
			}
		}	
	}	
	String sBeamCode = gBm.beamCode().token(0);
	sBeamCode.trimLeft();
	sBeamCode.trimRight();
	if( !bCaseSensitive )
		sBeamCode.makeUpper();
	int bBeamCode = false;
	for( int j=0;j<arSFBeamCode.length();j++ ){
		String sFBeamCode = arSFBeamCode[j];
		if( sFBeamCode.left(1) == "*" ){
			sFBeamCode.trimLeft("*");
			if( sFBeamCode.right(1) == "*" ){
				sFBeamCode.trimRight("*");
				if( sBeamCode.find(sFBeamCode, 0) != -1 ){
					bBeamCode = true;
					break;
				}
			}
			else{
				if( sBeamCode.right(sFBeamCode.length()) == sFBeamCode ){
					bBeamCode = true;
					break;
				}
			}
		}
		else if( sFBeamCode.right(1) == "*" ){
			sFBeamCode.trimRight("*");
			if( sBeamCode.find(sFBeamCode, 0) == 0 ){
				bBeamCode = true;
				break;
			}
		}
		else{
			if( sBeamCode == sFBeamCode ){
				bBeamCode = true;
				break;
			}
		}	
	}
	String sMaterial = gBm.material();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( !bCaseSensitive )
		sMaterial.makeUpper();
	
	if( sMaterial.length() > sColumnW.length() )
		sColumnW = sMaterial;
	int bMaterial = false;
	for( int j=0;j<arSFMaterial.length();j++ ){
		String sFMaterial = arSFMaterial[j];
		if( sFMaterial.left(1) == "*" ){
			sFMaterial.trimLeft("*");
			if( sFMaterial.right(1) == "*" ){
				sFMaterial.trimRight("*");
				if( sMaterial.find(sFMaterial, 0) != -1 ){
					bMaterial = true;
					break;
				}
			}
			else{
				if( sMaterial.right(sFMaterial.length()) == sFMaterial ){
					bMaterial = true;
					break;
				}
			}
		}
		else if( sFMaterial.right(1) == "*" ){
			sFMaterial.trimRight("*");
			if( sMaterial.find(sFMaterial, 0) == 0 ){
				bMaterial = true;
				break;
			}
		}
		else{
			if( sMaterial == sFMaterial ){
				bMaterial = true;
				break;
			}
		}	
	}
	String sLabel = gBm.label();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( !bCaseSensitive )
		sLabel.makeUpper();
	int bLabel = false;
	for( int j=0;j<arSFLabel.length();j++ ){
		String sFLabel = arSFLabel[j];
		if( sFLabel.left(1) == "*" ){
			sFLabel.trimLeft("*");
			if( sFLabel.right(1) == "*" ){
				sFLabel.trimRight("*");
				if( sLabel.find(sFLabel, 0) != -1 ){
					bLabel = true;
					break;
				}
			}
			else{
				if( sLabel.right(sFLabel.length()) == sFLabel ){
					bLabel = true;
					break;
				}
			}
		}
		else if( sFLabel.right(1) == "*" ){
			sFLabel.trimRight("*");
			if( sLabel.find(sFLabel, 0) == 0 ){
				bLabel = true;
				break;
			}
		}
		else{
			if( sLabel == sFLabel ){
				bLabel = true;
				break;
			}
		}	
	}
	String sHsbID = gBm.hsbId();
	sHsbID.trimLeft();
	sHsbID.trimRight();
	if( !bCaseSensitive )
		sHsbID.makeUpper();
	int bHsbID = false;
	for( int j=0;j<arSFHsbID.length();j++ ){
		String sFHsbID = arSFHsbID[j];
		if( sFHsbID.left(1) == "*" ){
			sFHsbID.trimLeft("*");
			if( sFHsbID.right(1) == "*" ){
				sFHsbID.trimRight("*");
				if( sHsbID.find(sFHsbID, 0) != -1 ){
					bHsbID = true;
					break;
				}
			}
			else{
				if( sHsbID.right(sFHsbID.length()) == sFHsbID ){
					bHsbID = true;
					break;
				}
			}
		}
		else if( sFHsbID.right(1) == "*" ){
			sFHsbID.trimRight("*");
			if( sHsbID.find(sFHsbID, 0) == 0 ){
				bHsbID = true;
				break;
			}
		}
		else{
			if( sHsbID == sFHsbID ){
				bHsbID = true;
				break;
			}
		}	
	}
	
	int bZone = false;
	if( arNFZone.find(gBm.myZoneIndex()) != -1 )
		bZone = true;
	
	if( bName || bBeamCode || bMaterial || bLabel || bHsbID || bZone ){
		if( nFilterMode == 1 ){//Exclude
			continue;
		}
	}
	else{
		if( !bAllFiltersEmpty && nFilterMode == 0 ){//Include
			continue;
		}
	}
	
	int bIsBeam = gBm.bIsKindOf(Beam());
	int bIsSheet = gBm.bIsKindOf(Sheet());
			
	if( bIsBeam ){
		arBm.append((Beam)gBm);
	}
	if( bIsSheet ){
		Sheet sh = (Sheet)gBm;
		double dShL = sh.solidLength();
		double dShW = sh.solidWidth();
//		if( dShL < dShW ){
//			double dTmp = dShL;
//			dShL = dShW;
//			dShW = dTmp;
//		}
		String sShL;
		sShL.formatUnit(dShL, 2, 0);
		String sShW;
		sShW.formatUnit(dShW, 2, 0);
		String sShSize = sShL + " x " + sShW;
		
		arSShSize.append(sShSize);
		arSh.append(sh);
	}
}

Display dpBreakDown(nColorBreakDown);
dpBreakDown.dimStyle(sDimStyleBreakDown);
Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyleContent);
Display dpGrid(nColorGrid);

double dCharW = dpBreakDown.textLengthForStyle("0", sDimStyleBreakDown);
double dCharH = dpBreakDown.textHeightForStyle("0", sDimStyleBreakDown);
double dRowW = dpBreakDown.textLengthForStyle(sColumnW, sDimStyleBreakDown) + 40 * dCharW;//50 * dCharW;
double dRowH = 2 * dCharH;

Point3d ptCategory = _Pt0;

String arSBreakDownBeams[arBm.length()];
String arSBreakDownBeamsSort[arBm.length()];
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	double dBmW = bm.solidWidth();
	double dBmH = bm.solidHeight();
	if( dBmW > dBmH ){
		double dTmp = dBmW;
		dBmW = dBmH;
		dBmH = dTmp;
	}
	String sBmW;
	sBmW.formatUnit(dBmW, 2, 0);
	String sBmH;
	sBmH.formatUnit(dBmH, 2, 0);
	String sLabel = bm.label();	
	arSBreakDownBeams[i] = sBmW + "x" + sBmH;
	if( sLabel.length() > 0 )
		arSBreakDownBeams[i] += " - " + sLabel;
	
	while( sBmW.token(0,".").length() < 4 )
		sBmW = "0" + sBmW;
	while( sBmH.token(0,".").length() < 4 )
		sBmH = "0" + sBmH;
	arSBreakDownBeamsSort[i] = sBmW + "x" + sBmH;
	if( sLabel.length() > 0 )
		arSBreakDownBeamsSort[i] += " - " + sLabel;
}

//Order beams
for(int s1=1;s1<arBm.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arBm[s11].solidLength() < arBm[s2].solidLength() ){
			arBm.swap(s2, s11);
			arSBreakDownBeams.swap(s2, s11);
			arSBreakDownBeamsSort.swap(s2, s11);
			
			s11=s2;
		}
	}
}
for(int s1=1;s1<arBm.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arSBreakDownBeamsSort[s11] < arSBreakDownBeamsSort[s2] ){
			arBm.swap(s2, s11);
			arSBreakDownBeams.swap(s2, s11);
			arSBreakDownBeamsSort.swap(s2, s11);

			s11=s2;
		}
	}
}

int nCategory = 100;
if( arSBreakDownBeams.length() > 0 ){
	double dCharW = dpBreakDown.textLengthForStyle("0", sDimStyleBreakDown);
	double dCharH = dpBreakDown.textHeightForStyle("0", sDimStyleBreakDown);
	double dRowW = dpBreakDown.textLengthForStyle(sColumnW, sDimStyleBreakDown) + 40 * dCharW;//50 * dCharW;
	double dRowH = 2 * dCharH;
	
	PLine plRow(ptCategory, ptCategory + _XW * dRowW);
	Point3d ptRow = ptCategory - _YW * .5 * dRowH + _XW * dCharW;
	
	//Header.
	dpBreakDown.draw("TOTAL TIMBERS", ptRow, _XW, _YW, 1, 0);
	dpGrid.draw(plRow);
	plRow.transformBy(-_YW * dRowH);
	dpGrid.draw(plRow);
	plRow.transformBy(-_YW * 0.1 * dRowH);
	//dpGrid.draw(plRow);
	ptRow -= _YW * 1.1 * dRowH;

	//Breakdown
	String sBreakDown;
	Point3d ptBreakDown = ptRow;
	ptRow -= _YW * dRowH;	
	double dTotalBmLengthThisBreakDown = 0;	
	
	//Sub-items
	String sCurrentBmL;
	int nAmountThisBmLength = 0;
	Point3d ptSubItem = ptRow + _XW * dCharW;
	
	for( int i=0;i<arSBreakDownBeams.length();i++ ){
		Beam bm = arBm[i];
		
		double dBmL = bm.solidLength();
		String sBmL;
		sBmL.formatUnit(dBmL, 2, 0);
		
		if( i==0 ){
			sBreakDown = arSBreakDownBeams[i];
			sCurrentBmL = sBmL;
		}
		else if( sBreakDown != arSBreakDownBeams[i] ){ //Close current breakdowmn. Reset values for next breakdown.		
			dpBreakDown.draw(sBreakDown, ptBreakDown, _XW, _YW, 1, 0);
			String sTotalBmLengthThisBreakDown;
			sTotalBmLengthThisBreakDown.formatUnit(dTotalBmLengthThisBreakDown/1000, 2, 3);
			dpBreakDown.draw(sTotalBmLengthThisBreakDown + "m", ptBreakDown + _XW * (dRowW - 2 * dCharW), _XW, _YW, -1, 0);
			
			dpContent.draw(nId+"-"+nCategory + ": " +sCurrentBmL, ptSubItem, _XW, _YW, 1, 0);
			dpContent.draw(nAmountThisBmLength, ptSubItem + _XW * (dRowW - 4 * dCharW), _XW, _YW, -1, 0);
			
			nCategory = 100*(int(nCategory/100) + 1);
			
			dpGrid.draw(plRow);
			plRow.transformBy(-_YW * dRowH);
			dpGrid.draw(plRow);
			plRow.transformBy(_YW * _YW.dotProduct(ptRow - ptBreakDown));
			
			ptRow -= _YW * dRowH;
			ptBreakDown = ptRow;
			ptRow -= _YW * dRowH;
			ptSubItem = ptRow + _XW * dCharW;
			
			sBreakDown = arSBreakDownBeams[i];
			dTotalBmLengthThisBreakDown = 0;
			nAmountThisBmLength = 0;
			sCurrentBmL = sBmL;
		}
		
		if( sBmL != sCurrentBmL ){ //Close this beamlength. Reset values for next beamlength.
			dpContent.draw(nId+"-"+nCategory + ": " +sCurrentBmL, ptSubItem, _XW, _YW, 1, 0);
			dpContent.draw(nAmountThisBmLength, ptSubItem + _XW * (dRowW - 4 * dCharW), _XW, _YW, -1, 0);
			
			ptRow -= _YW * dRowH;
		
			nAmountThisBmLength = 0;
			sCurrentBmL = sBmL;
			nCategory++;
			ptSubItem = ptRow + _XW * dCharW;
		}
		
		bm.setGrade(nId+"-"+nCategory);
		
		nAmountThisBmLength++;
		dTotalBmLengthThisBreakDown += dBmL;
	}
	
	// Draw last breakdown
	dpBreakDown.draw(sBreakDown, ptBreakDown, _XW, _YW, 1, 0);
	String sTotalBmLengthThisBreakDown;
	sTotalBmLengthThisBreakDown.formatUnit(dTotalBmLengthThisBreakDown/1000, 2, 3);
	dpBreakDown.draw(sTotalBmLengthThisBreakDown + "m", ptBreakDown + _XW * (dRowW - 2 * dCharW), _XW, _YW, -1, 0);
	
	dpContent.draw(nId+"-"+nCategory + ": " +sCurrentBmL, ptSubItem, _XW, _YW, 1, 0);
	dpContent.draw(nAmountThisBmLength, ptSubItem + _XW * (dRowW - 4 * dCharW), _XW, _YW, -1, 0);

	dpGrid.draw(plRow);
	plRow.transformBy(-_YW * dRowH);
	dpGrid.draw(plRow);
	plRow.transformBy(_YW * _YW.dotProduct(ptRow - ptBreakDown));

	dpGrid.draw(plRow);
	
	ptCategory = ptRow - _YW * 2.5 * dRowH - _XW * dCharW;
}


String arSBreakDownSheets[arSh.length()];
String arSBreakDownSheetsSort[arSh.length()];
for( int i=0;i<arSh.length();i++ ){
	Sheet sh = arSh[i];
	
	double dShT = sh.solidHeight();
	String sMaterial = sh.material();
	
	String sShT;
	sShT.formatUnit(dShT, 2, 1);
	
	arSBreakDownSheets[i] = sShT + "mm";
	if( sMaterial.length() > 0 )
		arSBreakDownSheets[i] += " - " + sMaterial;
	
	while( sShT.token(0,".").length() < 4 )
		sShT = "0" + sShT;
	arSBreakDownSheetsSort[i] = sShT + "mm";
	if( sMaterial.length() > 0 )
		arSBreakDownSheetsSort[i] += " - " + sMaterial;
}

//Order sheets
for(int s1=1;s1<arSh.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		String sShSizeS11 = arSShSize[s11];
		String sShLS11 = sShSizeS11.token(0,"x");
		sShLS11.trimLeft();
		sShLS11.trimRight();
		while( sShLS11.length() < 6 )
			sShLS11 = "0"+sShLS11;
		String sShWS11 = sShSizeS11.token(1,"x");
		sShWS11.trimLeft();
		sShWS11.trimRight();
		while( sShWS11.length() < 6 )
			sShWS11 = "0"+sShWS11;
		sShSizeS11 = sShLS11 + "x" + sShWS11;
		
		String sShSizeS2 = arSShSize[s2];
		String sShLS2 = sShSizeS2.token(0,"x");
		sShLS2.trimLeft();
		sShLS2.trimRight();
		while( sShLS2.length() < 6 )
			sShLS2 = "0"+sShLS2;
		String sShWS2 = sShSizeS2.token(1,"x");
		sShWS2.trimLeft();
		sShWS2.trimRight();
		while( sShWS2.length() < 6 )
			sShWS2 = "0"+sShWS2;
		sShSizeS2 = sShLS2 + "x" + sShWS2;
		
		if( sShSizeS11 > sShSizeS2 ){
			arSh.swap(s2, s11);
			arSShSize.swap(s2, s11);
			arSBreakDownSheets.swap(s2, s11);
			arSBreakDownSheetsSort.swap(s2, s11);
			
			s11=s2;
		}
	}
}

for(int s1=1;s1<arSh.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arSBreakDownSheetsSort[s11] < arSBreakDownSheetsSort[s2] ){
			arSh.swap(s2, s11);
			arSShSize.swap(s2, s11);
			arSBreakDownSheets.swap(s2, s11);
			arSBreakDownSheetsSort.swap(s2, s11);

			s11=s2;
		}
	}
}

nCategory = 100*(int(nCategory/100) + 1);
if( arSBreakDownSheets.length() > 0 ){
	PLine plRow(ptCategory, ptCategory + _XW * dRowW);
	Point3d ptRow = ptCategory - _YW * .5 * dRowH + _XW * dCharW;
	
	//Header.
	dpBreakDown.draw("TOTAL SHEETING", ptRow, _XW, _YW, 1, 0);
	dpGrid.draw(plRow);	
	plRow.transformBy(-_YW * dRowH);
	dpGrid.draw(plRow);
	plRow.transformBy(-_YW * 0.1 * dRowH);
	//dpGrid.draw(plRow);
	ptRow -= _YW * 1.1 * dRowH;

	//Breakdown
	String sBreakDown;
	Point3d ptBreakDown = ptRow;
	ptRow -= _YW * dRowH;	
	double dTotalShAreaThisBreakDown = 0;	
	
	//Sub-items
	String sCurrentShSize;
	int nAmountThisShSize = 0;
	Point3d ptSubItem = ptRow + _XW * dCharW;
	
	for( int i=0;i<arSBreakDownSheets.length();i++ ){
		Sheet sh = arSh[i];
		String sShSize = arSShSize[i];
		
		if( i==0 ){
			sBreakDown = arSBreakDownSheets[i];
			sCurrentShSize = sShSize;
		}
		else if( sBreakDown != arSBreakDownSheets[i] ){ //Close current breakdowmn. Reset values for next breakdown.		
			dpBreakDown.draw(sBreakDown, ptBreakDown, _XW, _YW, 1, 0);
			String sTotalShAreaThisBreakDown;
			sTotalShAreaThisBreakDown.formatUnit(dTotalShAreaThisBreakDown/1000000, 2, 3);
			dpBreakDown.draw(sTotalShAreaThisBreakDown + "m²", ptBreakDown + _XW * (dRowW - 2 * dCharW), _XW, _YW, -1, 0);
			
			dpContent.draw(nId+"-"+nCategory + ": " +sCurrentShSize, ptSubItem, _XW, _YW, 1, 0);
			dpContent.draw(nAmountThisShSize, ptSubItem + _XW * (dRowW - 4 * dCharW), _XW, _YW, -1, 0);
			
			nCategory = 100*(int(nCategory/100) + 1);
			
			dpGrid.draw(plRow);
			plRow.transformBy(-_YW * dRowH);
			dpGrid.draw(plRow);
			plRow.transformBy(_YW * _YW.dotProduct(ptRow - ptBreakDown));
			
			ptRow -= _YW * dRowH;
			ptBreakDown = ptRow;
			ptRow -= _YW * dRowH;
			ptSubItem = ptRow + _XW * dCharW;
			
			sBreakDown = arSBreakDownSheets[i];
			dTotalShAreaThisBreakDown = 0;
			nAmountThisShSize = 0;
			sCurrentShSize = sShSize;
		}
				
		if( sShSize != sCurrentShSize ){ //Close this sheetsize. Reset values for next sheetsize.
			dpContent.draw(nId+"-"+nCategory + ": " +sCurrentShSize, ptSubItem, _XW, _YW, 1, 0);
			dpContent.draw(nAmountThisShSize, ptSubItem + _XW * (dRowW - 4 * dCharW), _XW, _YW, -1, 0);
			
			ptRow -= _YW * dRowH;
		
			nAmountThisShSize = 0;
			sCurrentShSize = sShSize;
			nCategory++;

			ptSubItem = ptRow + _XW * dCharW;
		}
		sh.setGrade(nId+"-"+nCategory);
		
		nAmountThisShSize++;
		dTotalShAreaThisBreakDown += sh.plEnvelope().area();
	}
	
	dpBreakDown.draw(sBreakDown, ptBreakDown, _XW, _YW, 1, 0);
	String sTotalShAreaThisBreakDown;
	sTotalShAreaThisBreakDown.formatUnit(dTotalShAreaThisBreakDown/1000000, 2, 3);
	dpBreakDown.draw(sTotalShAreaThisBreakDown + "m²", ptBreakDown + _XW * (dRowW - 2 * dCharW), _XW, _YW, -1, 0);

	dpContent.draw(nId+"-"+nCategory + ": " +sCurrentShSize, ptSubItem, _XW, _YW, 1, 0);
	dpContent.draw(nAmountThisShSize, ptSubItem + _XW * (dRowW - 4 * dCharW), _XW, _YW, -1, 0);

	dpGrid.draw(plRow);
	plRow.transformBy(-_YW * dRowH);
	dpGrid.draw(plRow);
	plRow.transformBy(_YW * _YW.dotProduct(ptRow - ptBreakDown));
	dpGrid.draw(plRow);
}







#End
#BeginThumbnail






#End