#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
11.03.2020  -  version 2.03

This tsl adds a HSB_T-IntegratedTooling tsl to the male beams. The HSB_T-IntegratedTooling tsl will create beamcuts on the feamle beams.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords 
#BeginContents
//region Revision history
/// <summary Lang=en>
/// This tsl stretches a cut beam.
/// </summary>

/// <insert>
/// Select a set of elements.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.03" date="11.03.2020"></version>

/// <history>
/// YB 		- 1.00 - 13.06.2017 -	Pilot version
/// YB 		- 1.01 - 13.06.2017 - 	Multiple female beams can now be inside one TSL, changed the way of filtering.
/// YB 		- 1.02 - 14.06.2017 - 	Added option to set male beams to dummy beams.
/// YB 		- 1.03 - 19.06.2017 - 	Added a filter for the dummy beams.
/// YB 		- 1.04 - 19.06.2017 - 	Added a name filter, added two custom actions.
/// YB 		- 1.05 - 20.06.2017 - 	Fixed the name filter.
/// YB 		- 1.06 - 20.06.2017 - 	Female beamcode and name can now be changed in properties.
/// YB 		- 1.07 - 20.06.2017 - 	Changed to multi element insert.
/// RVW 		- 2.00 - 26.02.2019 - 	Add option to override properties from dsp variables.
/// RP	 	- 2.01 - 12.04.2019 - 	Check if body has intersection
/// RP	 	- 2.02 - 11.03.2020 - 	Add option to remove male and make a it a static tool
/// RP   		- 2.03 - 11.03.2020 -		Add option to make the beamcut square
/// </history>
//endregion

//region OPM
double dEps = U(0.01, "mm");
double pointTolerance = (U(.1));
double vectorTolerance = Unit(0.01, "mm");
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String sYesNo[] = { T("|Yes|"), T("|No|")};
String executeKey = "ManualInsert";
String category = T("|Geometry|");
String integratedToolingTslName = "HSB_T-IntegratedTooling";
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

String sJustification[] =
{
	T("|Center|"),
	T("|Top|"),
	T("|Top-Left|"),
	T("|Top-Right|"),
	T("|Left|"),
	T("|Right|"),
	T("|Bottom|"),
	T("|Bottom-Left|"),
	T("|Bottom-Right|")
};


PropDouble dAdditionalWidth (0, U(0), T("|Additional width|"));
dAdditionalWidth.setCategory(category);
PropInt variableAdditionalWidth(0, -1, T("|Additional width variable override|"));
variableAdditionalWidth.setCategory(category);
variableAdditionalWidth.setDescription(T("|Specify the variable to look up in dsp for the additional width|"));

PropDouble dAdditionalHeight (1, U(0), T("|Additional height|"));
dAdditionalHeight.setCategory(category);
PropInt variableAdditionalHeight(1, -1, T("|Additional height variable override|"));
variableAdditionalHeight.setCategory(category);
variableAdditionalHeight.setDescription(T("|Specify the variable to look up in dsp for the additional height|"));

PropString sJustificationChoice (0, sJustification, T("|Justification point|"), 0);
sJustificationChoice.setDescription(T("|Sets the justification point for the additional width/ height|."));
sJustificationChoice.setCategory(category);

PropDouble dOffsetDirX (2, U(0), T("|Offset in X direction|"));
dOffsetDirX.setCategory(category);
PropInt variableAdditionalOffsetDirX(2, -1, T("|Additional offset X axis variable override|"));
variableAdditionalOffsetDirX.setCategory(category);
variableAdditionalOffsetDirX.setDescription(T("|Specify the variable to look up in dsp for the additional offset on the X axis|"));

PropDouble dOffsetDirY (3, U(0), T("|Offset in Y direction|"));
dOffsetDirY.setCategory(category);
PropInt variableAdditionalOffsetDirY(3, -1, T("|Additional offset Y axis variable override|"));
variableAdditionalOffsetDirY.setCategory(category);
variableAdditionalOffsetDirY.setDescription(T("|Specify the variable to look up in dsp for the additional offset on the Y axis|"));

PropDouble dOffsetDirZ (4, U(0), T("|Offset in Z direction|"));
dOffsetDirZ.setCategory(category);
PropInt variableAdditionalOffsetDirZ(4, -1, T("|Additional offset Z axis variable override|"));
variableAdditionalOffsetDirZ.setCategory(category);
variableAdditionalOffsetDirZ.setDescription(T("|Specify the variable to look up in dsp for the additional offset on the Z axis|"));

PropDouble dNegFrontOffset (5, U(0), T("|Negative front offset|"));
dNegFrontOffset.setCategory(category);
PropInt variableAdditionalNegFrontOffset(5, -1, T("|Additional negative front offset override|"));
variableAdditionalNegFrontOffset.setCategory(category);
variableAdditionalNegFrontOffset.setDescription(T("|Specify the variable to look up in dsp for the additional negative front offset override|"));

PropDouble dPosFrontOffset (6, U(0), T("|Positive front offset|"));
dPosFrontOffset.setCategory(category);
PropInt variableAdditionalPosFrontOffset(6, -1, T("|Additional positive front offset override|"));
variableAdditionalPosFrontOffset.setCategory(category);
variableAdditionalPosFrontOffset.setDescription(T("|Specify the variable to look up in dsp for the additional positive front offset override|"));

PropString sModifyForCNC (1, sYesNo, T("|Modify section for CNC|"), 1);
sModifyForCNC.setCategory(category);
int modifySectionForCnc = sYesNo.find(sModifyForCNC) == 0;
PropString sConvertToDummy (2, sYesNo, T("|Convert to Dummy|"), 1);
sConvertToDummy.setCategory(category);
int convertToDummy = sYesNo.find(sConvertToDummy) == 0;
PropString sConvertToStatic (5, sYesNo, T("|Convert to static tool|"), 1);
sConvertToStatic.setCategory(category);
int convertToStatic = sYesNo.find(sConvertToStatic) == 0;
PropString sConvertToSquare (6, sYesNo, T("|Make beamcut square|"), 1);
sConvertToSquare.setCategory(category);
int convertToSquare = sYesNo.find(sConvertToSquare) == 0;
PropString genBeamFilterDefinitionMale(3, filterDefinitions, T("|Filter definition for male beams|"));
genBeamFilterDefinitionMale.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
PropString genBeamFilterDefinitionFeMale(4, filterDefinitions, T("|Filter definition for female beams|"));
genBeamFilterDefinitionFeMale.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
//endregion

double additionalWidth;
double additionalHeight;
double offsetDirX;
double offsetDirY;
double offsetDirZ;
double negFrontOffset;
double posFrontOffset;

_ThisInst.setSequenceNumber(3000);
// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if(catalogNames.find(_kExecuteKey) == -1 && _kExecuteKey != "")
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if( _Map.hasString("DspToTsl") && _bOnElementConstructed && !_bOnDebug)
{
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	double propDoubles[0];
	int intDoubles[0];
	
	additionalWidth = dAdditionalWidth;
	propDoubles.append(additionalWidth);
	intDoubles.append(variableAdditionalWidth);
	
	additionalHeight = dAdditionalHeight;
	propDoubles.append(additionalHeight);
	intDoubles.append(variableAdditionalHeight);
	
	offsetDirX = dOffsetDirX;
	propDoubles.append(offsetDirX);
	intDoubles.append(variableAdditionalOffsetDirX);
	
	offsetDirY = dOffsetDirY;
	propDoubles.append(offsetDirY);
	intDoubles.append(variableAdditionalOffsetDirY);
	
	offsetDirZ = dOffsetDirZ;
	propDoubles.append(offsetDirZ);
	intDoubles.append(variableAdditionalOffsetDirZ);
	
	negFrontOffset = dNegFrontOffset;
	propDoubles.append(negFrontOffset);
	intDoubles.append(variableAdditionalNegFrontOffset);
	
	posFrontOffset = dPosFrontOffset;
	propDoubles.append(posFrontOffset);
	intDoubles.append(variableAdditionalPosFrontOffset);
	
	if (_PtG.length() == 0) 
	{
		reportMessage("\n" + scriptName() + ": " +T("|No grippoints found. TSL Will be erased|"));
		eraseInstance();
		return;
	}
	_Pt0.vis(1);
	for (int i=0;i<_PtG.length();i++)
		_PtG[i].vis(2+i);
	
	if (_PtG.length() < 2)
		_PtG.append((_Pt0 + _PtG[0])/2);
	
	if (_Map.hasPoint3d("PtG0") && _Map.hasPoint3d("PtG1")) 
	{
		// Reset the grippoints to the detail line.
		_PtG[0] = _Map.getPoint3d("PtG0");
		_PtG[1] = _Map.getPoint3d("PtG1");
	}
	else 
	{
		// Reorganize the points passed in through the generator. 
		// _Pt0 muts become the anchor for the text. The grippoints will be the 2 points on the detail line.
		Point3d ptOrg = _PtG[1];
		Point3d ptGrip0 = _Pt0;
		Point3d ptGrip1 = _PtG[0];
	
		Vector3d vLn(ptGrip0 - ptGrip1);
		vLn.normalize();
		Line lnDetail(_PtG[1], vLn);
		Line lnText(_Pt0, vLn);
		
		ptGrip0 = lnDetail.closestPointTo(ptGrip0);
		ptGrip1 = lnDetail.closestPointTo(ptGrip1);
		ptOrg = lnText.closestPointTo(ptOrg);
		
		// Store the points on the detail line.
		_Map.setPoint3d("PtG0", ptGrip0, _kAbsolute);
		_Map.setPoint3d("PtG1", ptGrip1, _kAbsolute);
		
		// Set _Pt0 to the text position and the grippoints to the start and end of the detail.
		_Pt0 = ptOrg;
		_PtG[0] = ptGrip0;
		_PtG[1] = ptGrip1;
	}
	if(_Element.length()==0||_PtG.length()<1)
	{
		reportMessage(TN("|No Element or PTG found|"));
		return;
	}
	
	Element el = _Element[0];
	assignToElementGroup(el, true, 0, 'E');
	
	//int bPublishDetailInformation = arNYesNo[arSYesNo.find(sPublishDetailInformation, 1)];
	
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	Plane zPlane(ptEl, vzEl);
	Line lnX(ptEl, vxEl);
	
	PLine plElOutline = el.plEnvelope();
	plElOutline.transformBy(-vzEl * el.dBeamWidth());
	plElOutline.vis();
	
	// Find roofedge for this tsl and get the construction detail.
	Vector3d vY = (_PtG[1] - _PtG[0]);
	vY.normalize();
	Vector3d vZ = el.vecZ();
	Vector3d vX = vY.crossProduct(vZ);
	
	Group elementGroup = el.elementGroup();
	Entity roofOpeningEntities[] = Group(elementGroup.namePart(0), elementGroup.namePart(1), "").collectEntities(true, OpeningRoof(), _kModelSpace);
	
	//Display dpDebug(1);
	//dpDebug.textHeight(U(25));
	//dpDebug.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);
	
	Point3d ptOnDetailLine = (_PtG[1] + _PtG[0])/2;
	if( el.bIsKindOf(ElementRoof()) ){
		ElementRoof elR = (ElementRoof)el;
		ElemRoofEdge arElRoofEdge[]=elR.elemRoofEdges();
		
		OpeningRoof roofOpenings[0];
		PlaneProfile elementProfile(csEl);
		elementProfile.joinRing(el.plEnvelope(), _kAdd);
		elementProfile.vis(1);
		// Find the openings for this roof element and add the detail line information for these details.
		for (int e=0;e<roofOpeningEntities.length();e++)
		{
			OpeningRoof roofOpening = (OpeningRoof)roofOpeningEntities[e];
			PLine roofOpeningShape = roofOpening.plShape();
			roofOpeningShape.projectPointsToPlane(zPlane, _ZW);
			
			PlaneProfile openingProfile(csEl);
			openingProfile.joinRing(roofOpeningShape, _kAdd);
			openingProfile.vis(e);
			
			if (openingProfile.intersectWith(elementProfile))
			{
				roofOpenings.append(roofOpening);
			}
		}	
		
		Vector3d arVDirection[0];
		Point3d arPtNode[0];
		Point3d arPtNodeOther[0];
		String arSDetail[0];
		
		for (int r=0;r<roofOpenings.length();r++)
		{
			OpeningRoof roofOpening = roofOpenings[r];
			PLine openingShape = roofOpening.plShape();
			openingShape.projectPointsToPlane(zPlane, _ZW);
			Point3d midPoint;
			midPoint.setToAverage(openingShape.vertexPoints(false));
			double heightOpening = roofOpening.dTopHeight();
			midPoint += vyEl * roofOpening.dOpeningHeight() * 0.5;
			Point3d topPoint(midPoint.X(), midPoint.Y(), heightOpening);
			openingShape.transformBy(vyEl * (vyEl.dotProduct(topPoint - midPoint)));
			Point3d openingVertices[] = openingShape.vertexPoints(false);
			for (int v = 0; v < (openingVertices.length() - 1); v++)
			{
				Point3d from = openingVertices[v];
				Point3d to = openingVertices[v + 1];
				to.vis(1);
				from.vis(1);
				Vector3d direction(to - from);
				direction.normalize();
				Vector3d normal = vzEl.crossProduct(direction);
				double xComponent = vxEl.dotProduct(normal);
				double yComponent = vyEl.dotProduct(normal);
				
				arVDirection.append(direction);
				arPtNode.append(from);
				arPtNodeOther.append(to);
				String detail;
				if (abs(xComponent) < vectorTolerance)
				{
					if (yComponent > vectorTolerance)
					{
						detail = roofOpening.constrDetailTop();
					}
					else
					{
						detail = roofOpening.constrDetailBottom();
					}
				}
				else if (abs(yComponent) < vectorTolerance)
				{
					if (xComponent > vectorTolerance)
					{
						detail = roofOpening.constrDetailLeft();
					}
					else
					{
						detail = roofOpening.constrDetailRight();
					}
				}
				else
				{
					if (yComponent > vectorTolerance)
					{
						detail = roofOpening.constrDetailTopAngled();
					}
					else
					{
						detail = roofOpening.constrDetailBottomAngled();
					}
				}
				arSDetail.append(detail);
	//			dpDebug.draw(PLine(to, from));
			}
		}
		
		for( int j=0;j<arElRoofEdge.length();j++ ){
			ElemRoofEdge elRoofEdge = arElRoofEdge[j];
			arVDirection.append(elRoofEdge.vecDir());
			arPtNode.append(elRoofEdge.ptNode());
			arPtNodeOther.append(elRoofEdge.ptNodeOther());
			arSDetail.append(elRoofEdge.constrDetail());	
		}
		
		
		
		// Add the suporting details....
		double arDHSupportingDetail[0];
		String arSSupportingDetail[0];
		arDHSupportingDetail.append(elR.dKneeWallHeight());		arSSupportingDetail.append(elR.constrDetailKneeWall());
		arDHSupportingDetail.append(elR.dKneeWallHeight2());	arSSupportingDetail.append(elR.constrDetailKneeWall2());
		arDHSupportingDetail.append(elR.dWallPlateHeight());		arSSupportingDetail.append(elR.constrDetailWallPlate());
		arDHSupportingDetail.append(elR.dWallPlateHeight2());	arSSupportingDetail.append(elR.constrDetailWallPlate2());
		arDHSupportingDetail.append(elR.dStrutHeight());			arSSupportingDetail.append(elR.constrDetailStrut());
		arDHSupportingDetail.append(elR.dStrutHeight2());			arSSupportingDetail.append(elR.constrDetailStrut2());
		
		for (int j=0;j<arDHSupportingDetail.length();j++) {
			double dDetailH = arDHSupportingDetail[j];
			String sDetail = arSSupportingDetail[j];
			if (sDetail.length() == 0)
				continue;
			
			Plane pn(_PtW + _ZW * dDetailH, _ZW);
			Point3d arPtDetail[] = plElOutline.intersectPoints(pn);
			arPtDetail = lnX.orderPoints(arPtDetail);
			
			if (arPtDetail.length() < 2)
				continue;
			
			arVDirection.append(vxEl);
			arPtNode.append(arPtDetail[0]);
			arPtNodeOther.append(arPtDetail[arPtDetail.length() - 1]);
			arSDetail.append(sDetail);
		}
	
		double dMin = U(9999999);
		for( int j=0;j<arVDirection.length();j++ ){
			Vector3d vDirection = arVDirection[j];
			Point3d ptNode = arPtNode[j];
			Point3d ptNodeOther = arPtNodeOther[j];
			String sDetail = arSDetail[j];
			
			if( abs(abs(vY.dotProduct(vDirection)) - 1) < dEps ){
				double dDist = vX.dotProduct(ptOnDetailLine - ptNode);
				if( abs(dDist) < dMin ){
					dMin = abs(dDist);
					_Map.setString("DET", sDetail);
					_PtG[0] = ptNode;
					_PtG[1] = ptNodeOther;
				}
			}
		}
	}

	for (int d = 0; d < propDoubles.length(); d++)
	{
		double thisDouble = propDoubles[d];
		int thisInt = intDoubles[d];
		// Set properties if this tsl was inserted from DSP. This check is only done after the first run.
		if ( thisInt > 0)
		{
			String dspValue;
			if ( _Map.hasString("DET") )
			{
				dspValue = _Map.getString("DET");
			}
			
			
			if ( dspValue.token(0) == "\CODE" )
			{
				if ( thisInt == 0 )
				{
					dspValue = dspValue.token(1);
				}
				else
				{
					String sKey = "STRVAR" + (thisInt - 1);
					int nIndex = dspValue.find(sKey, 0);
					if (nIndex == -1 )
					{
						sKey = "40DVAR" + (thisInt - 1);
						nIndex = dspValue.find(sKey, 0);
						if (nIndex == -1 )
						{
							reportMessage("\n" + scriptName() + ": " + T("|Catalog index not found|"));
							eraseInstance();
							return;
						}
					}
					
					nIndex += sKey.length() + 1;
					dspValue = dspValue.mid(nIndex, dspValue.length() - 1);
					dspValue = dspValue.token(0);

				}
			}
			else
			{
				dspValue = dspValue.token(thisInt);
			}

			if (dspValue == "" )
			{
				reportMessage("\n" + scriptName() + ": " + T("|Catalogname not found|"));
			}
			else if (d==0)
			{
				additionalWidth = dspValue.atof(_kLength);
			}
			else if (d==1)
			{
				additionalHeight = dspValue.atof(_kLength);
			}
			else if (d==2)
			{
				offsetDirX = dspValue.atof(_kLength);
			}
			else if (d==3)
			{
				offsetDirY = dspValue.atof(_kLength);
			}
			else if (d==4)
			{
				offsetDirZ = dspValue.atof(_kLength);
			}
			else if (d==5)
			{
				negFrontOffset = dspValue.atof(_kLength);
			}
			else if (d==6)
			{
				posFrontOffset = dspValue.atof(_kLength);
			}
		}
	}
	_Map.removeAt("DspToTsl", true);
}

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
				
	eraseInstance();		
	return;
}	
// end on insert	__________________

if (variableAdditionalWidth < 1 && additionalWidth <= 0)
{
	additionalWidth = dAdditionalWidth;
}
if (variableAdditionalHeight < 1 && additionalHeight <= 0)
{
	additionalHeight = dAdditionalHeight;
}
if (variableAdditionalOffsetDirX < 1 && offsetDirX <= 0)
{
	offsetDirX = dOffsetDirX;
}
if (variableAdditionalOffsetDirY < 1 && offsetDirY <= 0)
{
	offsetDirY = dOffsetDirY;
}
if (variableAdditionalOffsetDirZ < 1 && offsetDirZ <= 0)
{
	offsetDirZ = dOffsetDirZ;
}
if (variableAdditionalNegFrontOffset < 1 && negFrontOffset <= 0)
{
	negFrontOffset = dNegFrontOffset;
}
if (variableAdditionalPosFrontOffset < 1 && posFrontOffset <= 0)
{
	posFrontOffset = dPosFrontOffset;
}

int nProps[]={};
double dProps[]={};
dProps.append(additionalWidth);
dProps.append(additionalHeight);
dProps.append(offsetDirX);
dProps.append(offsetDirY);
dProps.append(offsetDirZ);
dProps.append(negFrontOffset);
dProps.append(posFrontOffset);

String sProps[]={};
sProps.append(sJustificationChoice);
sProps.append(sModifyForCNC);
sProps.append(sConvertToDummy);
sProps.append(sConvertToStatic);
sProps.append(sConvertToSquare);

// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
	Element el = _Element[0];
	Entity elementGenBeamEntities[] = el.elementGroup().collectEntities(false, (GenBeam()), _kModelSpace, false);
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionMale, filterGenBeamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Entity filteredGenBeamMaleEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	
	filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionFeMale, filterGenBeamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Entity filteredGenBeamFeMaleEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	
	for (int index=0;index<filteredGenBeamMaleEntities.length();index++) 
	{ 
		Entity entity = filteredGenBeamMaleEntities[index]; 
		GenBeam genBeam = (GenBeam)entity;
		Body maleBody = genBeam.realBody();
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[0];
		gbsTsl.append(genBeam);
		for (int index=0;index<filteredGenBeamFeMaleEntities.length();index++) 
		{ 
			GenBeam femaleGenBeam = (GenBeam)filteredGenBeamFeMaleEntities[index]; 
			Body femaleBody = femaleGenBeam.realBody();
			if (! femaleBody.hasIntersection(maleBody)) continue;
			gbsTsl.append(femaleGenBeam); 
		}
		
		Entity entsTsl[0];
		Point3d ptsTsl[] = {};

		Map mapTsl;	
		
		tslNew.dbCreate(integratedToolingTslName, vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, true, mapTsl);
	}
}

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
	eraseInstance();
	return;
}

return;
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End