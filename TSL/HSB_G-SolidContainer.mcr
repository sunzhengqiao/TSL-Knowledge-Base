#Version 8
#BeginDescription
<version value="1.12" date=25jan2020" author="david.rueda@hsbcad.com">

PLEASE NOTICE: 
- Posnum display is green if a valid body was found in TSL's _Map, else will be red
- TSL cannot be manually added. Please use property dialog for catalogs creation.
- Available formatted variables: 
@(Handler)
@(Posnum)
@(Length)
@(Width)
@(Height)
@(Volume)
@(Grade)
@(Profile)
@(Material)
@(Label)
@(SubLabel)
@(SubLabel2)
@(Beamcode)
@(Type)
@(Information)
@(Name)
@(PosnumAndText)
@(Layer)
@(HsbId)
@(Module)
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
/// <History>
/// <version value="1.12" date=25jan2020" author="david.rueda@hsbcad.com"> View property simplified to be "|Nothing|"), T("|Imported body|"), T("|Difference|"), now TSL shows all differences (A-B and B-A). Removed false volume dfferences due to solid substactions. Added volume tolerance of 15 cubic cm as default (to be overwritten by value stored in _Map), this tolerance is now applied to every lump of body difference  </version>
/// <version value="1.11" date=14jan2020" author="david.rueda@hsbcad.com"> _Pt0 not allowed to be grip point, so user cannot relocate TSL (it will relocate imported body and make bigger difference). Now TSL will remove previous instances of itself arrached to same entity</version>
/// <version value="1.10" date=19nov2019" author="david.rueda@hsbcad.com"> Added properties: <Text Offset>, <Group>, <Custom Text> (with formatted variables and regular text)</version>
/// <version value="1.09" date=21oct2019" author="david.rueda@hsbcad.com"> Imported body visible even when volume difference is zero  
// - Messages for letting user know that volumes are same or not improved </version>
/// <version value="1.08" date=18oct2019" author="david.rueda@hsbcad.com"> Report message when volumes are the same 
// - Report message when volume is different, showing area in cubic mm, cm and meters
// - Added property <Display Face Loops on Error> (No, Yes) </version>
/// <version value="1.07" date=18oct2019" author="david.rueda@hsbcad.com"> Removed manual creation of new instances but leaving option to show property dialog to store catalogs (report message to let user know it's not allowed') 
// - Removed properties: <write .dxx file>, <remove duplicateds> and <show genBeam body> (redundant)
// - Added display color and offset direction properties - Replaced property Show Faces by view options
// - Added error messages for customer understanding </version>
/// <version value="1.06" date=16oct2019" author="david.rueda@hsbcad.com"> Body to display from _Map first read as body, if fails then constructed by face faceloops  </version>
/// <version value="1.05" date=14oct2019" author="david.rueda@hsbcad.com"> Show body now shows real body from GenBeam  </version>
/// <version value="1.04" date=09oct2019" author="david.rueda@hsbcad.com"> Added option to not delete previous instances of TSL on same genBeam  </version>
/// <version value="1.03" date=07oct2019" author="david.rueda@hsbcad.com"> Added faces visualization  </version>
/// <version value="1.02" date=30sep2019" author="david.rueda@hsbcad.com"> Removed code to read string PosNum from _Map  </version>
/// <version value="1.01" date=24sep2019" author="david.rueda@hsbcad.com"> Posnum can be set from _Map, added option to show body/write _Map to .dxx</version>
/// 																	   Bugfix when user drag and drop _Pt0 and displayed body was oddly relocated
/// <version value="1.00" date="23sep2019" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select genBeam(s)
/// </insert>

/// <summary Lang=en>
/// </summary>

{
	// constants //region
	U(1, "mm");
	double dEps = U(.1);
	double dMinVolume = U(3375000); //15 cubic cm
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
			if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }}
		if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
	}
	
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String sBodyDisplay = T("|Body|");
	String sTextDisplay = T("|Text|");
	String sGeneral = T("|General|");
	String category = sGeneral;
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sRealSolid = "RealSolid";
	String sVolumeToleranceKeyName = "VolumeTolerance"; //in mm
	
	String sTab = " ";
	int nColors[0]; String sColors[0];
	nColors.append(-1); sColors.append(T("|Default|"));
	nColors.append(1); sColors.append(T("|Red|"));
	nColors.append(2); sColors.append(T("|Yellow|"));
	nColors.append(3); sColors.append(T("|Green|"));
	nColors.append(4); sColors.append(T("|Cyan|"));
	nColors.append(5); sColors.append(T("|Blue|"));
	nColors.append(6); sColors.append(T("|Magenta|"));
	nColors.append(0); sColors.append(T("|White|"));
	nColors.append(7); sColors.append(T("|Black|"));
	nColors.append(8); sColors.append(T("|Gray|"));
	nColors.append(32); sColors.append(T("|Dark brown|"));
	nColors.append(40); sColors.append(T("|Light brown|"));
	
	int bDeleteDuplicateds = true;
	
	//endregion
	
	// OPM
	String sTextHeightName = T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(200), sTextHeightName);
	dTextHeight.setDescription(T("|Defines the Text Height|"));
	dTextHeight.setCategory(sTextDisplay);
	
	String sViews[] = { T("|Nothing|"), T("|Imported body|"), T("|Difference|")};
	String sViewName = T("|View|");
	PropString sView(nStringIndex++, sViews, sViewName, 2);
	sView.setDescription(T("|Defines the View|"));
	sView.setCategory(sBodyDisplay);
	
	String sColorName = T("|Color|");
	PropString sColor(nStringIndex++, sColors, sColorName, 2);
	sColor.setDescription(T("|Defines the Color|"));
	sColor.setCategory(sGeneral);
	
	String sOffsetName = T("|Offset|");
	PropDouble dOffset(nDoubleIndex++, U(300), sOffsetName);
	dOffset.setDescription(T("|Defines the Offset value|"));
	dOffset.setCategory(sBodyDisplay);
	
	String sOffsetDirections[] = { T("|X|"), T("|-X|"), T("|Y|"), T("|-Y|"), T("|Z|"), T("|-Z|")};
	String sOffsetDirectionName = T("|Offset Direction|") + T(" (|GenBeam|)");
	PropString sOffsetDirection(nStringIndex++, sOffsetDirections, sOffsetDirectionName, 4);
	sOffsetDirection.setDescription(T("|Defines the Offset Direction|. ") + T("|Notice|: ") + T("|Direction is relative to GenBeam's vectors|"));
	sOffsetDirection.setCategory(sBodyDisplay);
	
	String sShowImportErrorName = T("|Show Import Error|");
	PropString sShowImportError(nStringIndex++, sNoYes, sShowImportErrorName, 1);
	sShowImportError.setDescription(T("|Shows face loops if not valid body was stored in map|"));
	sShowImportError.setCategory(sBodyDisplay);
	
	String sOffsetTextName = T("|Text Offset|");
	PropDouble dOffsetText(nDoubleIndex++, U(350), sOffsetTextName);
	dOffsetText.setDescription(T("|Defines the Text Offset|"));
	dOffsetText.setCategory(sTextDisplay);
	
	String sFrmVarNames[0], sFrmVarValues[0];
	String sAtHandler = "@(Handler)"; sFrmVarNames.append(sAtHandler);
	String sAtPosnum = "@(Posnum)"; sFrmVarNames.append(sAtPosnum);
	String sAtLength = "@(Length)"; sFrmVarNames.append(sAtLength);
	String sAtWidth = "@(Width)"; sFrmVarNames.append(sAtWidth);
	String sAtHeight = "@(Height)"; sFrmVarNames.append(sAtHeight);
	String sAtVolume = "@(Volume)"; sFrmVarNames.append(sAtVolume);
	String sAtGrade = "@(Grade)"; sFrmVarNames.append(sAtGrade);
	String sAtProfile = "@(Profile)"; sFrmVarNames.append(sAtProfile);
	String sAtMaterial = "@(Material)"; sFrmVarNames.append(sAtMaterial);
	String sAtLabel = "@(Label)"; sFrmVarNames.append(sAtLabel);
	String sAtSubLabel = "@(SubLabel)"; sFrmVarNames.append(sAtSubLabel);
	String sAtSubLabel2 = "@(SubLabel2)"; sFrmVarNames.append(sAtSubLabel2);
	String sAtBeamcode = "@(Beamcode)"; sFrmVarNames.append(sAtBeamcode);
	String sAtType = "@(Type)"; sFrmVarNames.append(sAtType);
	String sAtInformation = "@(Information)"; sFrmVarNames.append(sAtInformation);
	String sAtName = "@(Name)"; sFrmVarNames.append(sAtName);
	String sAtPosnumAndText = "@(PosnumAndText)"; sFrmVarNames.append(sAtPosnumAndText);
	String sAtLayer = "@(Layer)"; sFrmVarNames.append(sAtLayer);
	String sAtHsbId = "@(HsbId)"; sFrmVarNames.append(sAtHsbId);
	String sAtModule = "@(Module)"; sFrmVarNames.append(sAtModule);
	
	String sFrmVarList;
	for (int s = 0; s < sFrmVarNames.length(); s++)
	{
		sFrmVarList += "\n" + sFrmVarNames[s];
	}//next s
	//reportNotice(T("\n|- Available formatted variables|: ") + sFrmVarList); // for description
	
	String sFormattedVariableName = T("|Custom Text|");
	PropString sFormattedVariable(nStringIndex++, "", sFormattedVariableName);
	sFormattedVariable.setDescription(T("|Defines the custom text to display including the usage of Formatted Variables|. ") + T("|If no one is found then text will be displayed as it is|. "));
	sFormattedVariable.setCategory(sTextDisplay);
	
	// collect group names for property
	Group groups[0];
	String sGroups[0];
	Group sExistingGroups[] = Group().allExistingGroups();
	for ( int i = 0; i < sExistingGroups.length(); i++) {
		Group group = sExistingGroups[i];
		groups.append(group);
		sGroups.append(group.name());
	}
	//order element left to right
	for (int s1 = 1; s1 < sGroups.length(); s1++) {
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--) {
			if ( sGroups[s11] < sGroups[s2] )
			{
				groups.swap(s2, s11);
				sGroups.swap(s2, s11);
				s11 = s2;
			}
		}
	}
	
	String sGroupName = T("|Group|");
	PropString sGroup(nStringIndex++, sGroups, sGroupName);
	sGroup.setDescription(T("|Defines the Group|"));
	sGroup.setCategory(sGeneral);
	
	Group group = groups[sGroups.find(sGroup, 0)];
	if (group.bExists())
	{
		group.addEntity(_ThisInst, true, 0, 'I');
	}
	
	// bOnInsert//region
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1)
		{
			eraseInstance();
			return;
		}
		
		showDialog();
		
		if ( ! bDebug)
		{
			reportMessage("\n" + scriptName() + ": " + T("|TSL cannot be manually added|. ") + T("|Please use property dialog for catalogs creation|") + "\n");
			eraseInstance();
			return;
		}
		
		// prompt for beams
		PrEntity ssE(T("|Select GenBeam(s)|"), GenBeam());
		Entity entities[0];
		if (ssE.go())
			entities.append(ssE.set());
		
		// create TSL
		TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
		GenBeam gbsTsl[1];		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
		int nProps[] ={ };
		double dProps[] ={ dTextHeight, dOffset, dOffsetText};
		String sProps[] ={ sView, sColor, sOffsetDirection, sShowImportError, sFormattedVariable, sGroup};
		Map mapTsl;
		
		for (int e = 0; e < entities.length(); e++)
		{
			Entity ent = entities[e];
			GenBeam genBeam = (GenBeam) ent;
			if ( ! genBeam.bIsValid())
				continue;
			
			gbsTsl[0] = genBeam;
			
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}//next e
		
		eraseInstance();
		return;
	}
	// end on insert	__________________//endregion
	
	// resolve properties
	int nView = sViews.find(sView, 0);
	int nColor = nColors[sColors.find(sColor, 0)];
	int nOffsetDirection = sOffsetDirections.find(sOffsetDirection, 0);
	int nShowImportError = sNoYes.find(sShowImportError, 0);
	
	if (_bOnDbCreated)
	{
		setPropValuesFromCatalog(sLastInserted);
		setExecutionLoops(2);
	}
	
	// validations
	if (_GenBeam.length() == 0)
	{
		if (bDebug)
			reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|not valid genBeams stored on _GenBeam|\n"));
		
		eraseInstance();
		return;
	}
	
	GenBeam genBeam = _GenBeam[0];
	if ( ! genBeam.bIsValid())
	{
		if (bDebug)
			reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|not valid genBeam at _GenBeam[0]|\n"));
		
		eraseInstance();
		return;
	}
	
	String sGenBeamType, sBeam = T("|Beam|"), sSheet = T("|Sheet|"), sPanel = T("|Panel|");
	Beam beam = (Beam) genBeam;
	Sheet sheet = (Sheet) genBeam;
	Sip sip = (Sip) genBeam;
	if (beam.bIsValid())
		sGenBeamType = sBeam;
	else if (sheet.bIsValid())
		sGenBeamType = sSheet;
	else if (sip.bIsValid())
		sGenBeamType = sPanel;
	else
	{
		reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|GenBeam| ") + genBeam.handle() + T(", |Type coud not be defined|"));
		eraseInstance();
		return;
		
	}
	
	Entity entGenBeam = (Entity) genBeam;
	Vector3d vecX = genBeam.vecX();
	Vector3d vecY = genBeam.vecY();
	Vector3d vecZ = genBeam.vecZ();
	
	Element element = genBeam.element();
	
	_Pt0 = genBeam.ptCen();
	_ThisInst.setAllowGripAtPt0(0);
	setDependencyOnEntity(entGenBeam);
	
	String sElementNumber = "";
	if (element.bIsValid())
	{
		sElementNumber = element.number();
		if (element.code() != "")
		{
			sElementNumber += "-" + element.code();
		}
	}
	
	String sInfoMessage = "\n" + scriptName() + " - " + sGenBeamType + " " + genBeam.handle() + ": ";
	if (sElementNumber != "")
		sInfoMessage += T("|at element| ") + sElementNumber + ". ";
	
	Body bdReal = genBeam.realBodyTry();
	if (bdReal.isNull() || bdReal.volume() < dMinVolume)
	{
		sInfoMessage += T("|Not valid real body from GenBeam|. ") + T("|Displaying envelope body instead|. ");
		reportMessage(sInfoMessage);
		
		Display dpX (1); double dXl = U(1000); Point3d ptX = _Pt0; PLine plTmp (_ZW); plTmp.addVertex(ptX - _XW * dXl * .5); plTmp.addVertex(ptX + _XW * dXl * .5); plTmp.addVertex(ptX);
		plTmp.addVertex(ptX - _YW * dXl * .5); plTmp.addVertex(ptX + _YW * dXl * .5); dpX.draw(plTmp); plTmp = PLine (_XW); plTmp.addVertex(ptX - _ZW * dXl * .5); plTmp.addVertex(ptX + _ZW * dXl * .5); dpX.draw(plTmp);
		dpX.draw(genBeam.envelopeBody());
		return;
	}
	
	if (bDebug) { reportMessage("\n" + scriptName() + ": " + T("|genBeam.realBodyTry().volume()|: ") + genBeam.realBodyTry().volume() + "\n"); }

	// Erasing all TSL's attached
	if (bDeleteDuplicateds)
	{
		Map subMap = entGenBeam.subMap(scriptName());
		for ( int e = subMap.length() - 1; e >= 0; e--)
		{
			String sKey = subMap.keyAt(e);
			Entity ent = subMap.getEntity(sKey);
			TslInst tsl = (TslInst)ent;
			if ( ! tsl.bIsValid())
				continue;
			
			if (sKey != _ThisInst.handle())
			{
				// Erase if has same name
				tsl.dbErase();
				reportMessage("\n" + scriptName() + ": " + T("|Entity found and erased|") + "\n");
				
			}
		}
		
		// Add keys and submap to future deletions at insertion
		subMap.setEntity(_ThisInst.handle(), _ThisInst);
		entGenBeam.setSubMap(scriptName(), subMap);
	}
	
	// get imported body, set text color
	int nTextColor = 3;
	Body bdImported;
	int bIsValidImportedBody;
	if ( ! _Map.hasBody(sRealSolid))
	{
		nTextColor = 1;
		sInfoMessage += T("|Importing failure|: ") + T("|Not valid body stored in Map|. ");
		reportMessage(sInfoMessage);
	}
	else
	{
		bdImported = _Map.getBody(sRealSolid);
		if (bdImported.volume() > dMinVolume)
		{
			bIsValidImportedBody = true;
			if (bDebug) { reportMessage("\n" + scriptName() + ": " + T("|bdImported.volume()|: ") + bdImported.volume() + "\n"); 		}
		}
		else
		{
			nTextColor = 1;
			sInfoMessage += T("|Importing failure|: ") + T("|Not valid body stored in Map|. ");
			reportMessage(sInfoMessage);
		}
	}

	// display text
	Display dpText(nTextColor);
	dpText.textHeight(dTextHeight);
	
	// formatted variables
	sFrmVarValues.append(genBeam.handle());
	sFrmVarValues.append(genBeam.posnum());
	sFrmVarValues.append(genBeam.solidLength());
	sFrmVarValues.append(genBeam.solidWidth());
	sFrmVarValues.append(genBeam.solidHeight());
	sFrmVarValues.append(genBeam.volume());
	sFrmVarValues.append(genBeam.name("Grade"));
	sFrmVarValues.append(genBeam.name("Profile"));
	sFrmVarValues.append(genBeam.name("Material"));
	sFrmVarValues.append(genBeam.name("Label"));
	sFrmVarValues.append(genBeam.name("SubLabel"));
	sFrmVarValues.append(genBeam.name("SubLabel2"));
	sFrmVarValues.append(genBeam.name("Beamcode"));
	sFrmVarValues.append(genBeam.name("Type"));
	sFrmVarValues.append(genBeam.name("Information"));
	sFrmVarValues.append(genBeam.name("Name"));
	sFrmVarValues.append(genBeam.name("PosnumAndText"));
	sFrmVarValues.append(genBeam.name("Layer"));
	sFrmVarValues.append(genBeam.name("HsbId"));
	sFrmVarValues.append(genBeam.name("Module"));
	
	if (sFrmVarNames.length() != sFrmVarValues.length())
	{
		reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|Not all values for formatted variables are set|\n"));
		// Draw Point3d
		Display dpX (1); double dXl = U(500); Point3d ptX = _Pt0; PLine plTmp (_ZW); plTmp.addVertex(ptX - _XW * dXl * .5); plTmp.addVertex(ptX + _XW * dXl * .5); plTmp.addVertex(ptX);
		plTmp.addVertex(ptX - _YW * dXl * .5); plTmp.addVertex(ptX + _YW * dXl * .5); dpX.draw(plTmp); plTmp = PLine (_XW); plTmp.addVertex(ptX - _ZW * dXl * .5); plTmp.addVertex(ptX + _ZW * dXl * .5); dpX.draw(plTmp);
		return;
	}
	
	String sTextMessage = "";
	String sDisplayMesssage = "";
	int bVariableFound = false;
	String sFormattedVariableUpper = sFormattedVariable;
	sFormattedVariableUpper.makeUpper();
	Vector3d vecOffsetDir = genBeam.vecX();
	Point3d ptDrawText = genBeam.ptCenSolid() + vecOffsetDir * dOffsetText;
	for (int s = 0; s < sFrmVarNames.length(); s++)
	{
		String sNameUpper = sFrmVarNames[s];
		sNameUpper.makeUpper();
		
		if (sFormattedVariableUpper.find(sNameUpper, - 1) >= 0)
		{
			bVariableFound = true;
			String sName = sFrmVarNames[s]; sName.delete(0, 2); sName.delete(sName.length() - 1, 1);
			String sNewLine = sName + ": " + sFrmVarValues[s];
			sTextMessage += sNewLine + "; ";
			dpText.draw(sNewLine, ptDrawText , genBeam.vecY(), genBeam.vecX(), 0, 0, _kDevice);
			ptDrawText += vecOffsetDir * dTextHeight * 2;
		}
	}//next s
	
	if ( bVariableFound)
	{
		reportMessage(sTextMessage);
	}
	else
	{
		String sDisplay = sFormattedVariable;
		if (sDisplay == "")
		{
			sDisplay = genBeam.posnum();
			if (sDisplay == "")
			{
				sDisplay = "-1";
			}
		}
		
		dpText.draw(sDisplay, _Pt0 + genBeam.vecX() * dOffsetText, genBeam.vecY(), genBeam.vecX(), 0, 0, _kDevice);
	}
	
	// display bodies
	Display dpBodies(nColor);
	Vector3d vecOffsetDirections[] ={ genBeam.vecX(), - genBeam.vecX(), genBeam.vecY(), - genBeam.vecY(), genBeam.vecZ(), - genBeam.vecZ()};
	Vector3d vOffset = vecOffsetDirections[nOffsetDirection];
	double dVolTolerance = U(1000);
	if (_Map.hasDouble(sVolumeToleranceKeyName))
	{
		dVolTolerance = _Map.getDouble(sVolumeToleranceKeyName);
	}

	if (nView > 0) // nView[0]=nothing
	{
		if (bIsValidImportedBody)
		{
			int bVolumesAreEqual, bDrawBody;
			double dVolumeDifference = abs(bdReal.volume() - bdImported.volume());
			if (dVolumeDifference < dVolTolerance)
				bVolumesAreEqual = true;
			
			if (nView == 1) //Imported body
			{
				Body bdDisplay = bdImported;
				bdDisplay.transformBy(vOffset * dOffset);
				dpBodies.draw(bdDisplay);
			}
			else if ( ! bVolumesAreEqual) //show difference if volumes are not the same
			{
				// collect A-B
				Body bdLumps[0];
				Body bd0 = bdReal;
				Body bd1 = bdImported;
				bd0.subPart(bd1);
				bdLumps.append(bd0.decomposeIntoLumps());
				// collect B-A
				bd0 = bdImported;
				bd1 = bdReal;
				bd0.subPart(bd1);
				bdLumps.append(bd0.decomposeIntoLumps());
				
				dVolumeDifference = 0;
				for (int b = 0; b < bdLumps.length(); b++)
				{
					Body bdLump = bdLumps[b];
					double dVolume = bdLump.volume();					
					if (dVolume > dMinVolume)
					{
						bdLump.transformBy(vOffset * dOffset);
						dpBodies.draw(bdLump);
						dVolumeDifference += dVolume;
						
						if (bDebug)
						{
							reportMessage("\n" + scriptName() + ": _" + T("|dVolume|: ") + dVolume + "\n");
						}
					}
				}//next b
				
				if (dVolumeDifference == 0)
				{
					bVolumesAreEqual = true;
				}
			}
			
			// report message 
			if ( bVolumesAreEqual)
			{
				if ( ! _bOnDbCreated )
				{
					sInfoMessage += T("|Solids have same volume|. ");
					reportMessage(sInfoMessage);
				}
			}
			else
			{
				sInfoMessage += T("|Volume difference|: ") + dVolumeDifference + "mm3 = ";
				dVolumeDifference = dVolumeDifference / 1000;
				sInfoMessage += dVolumeDifference + "cm3 = ";
				dVolumeDifference = dVolumeDifference / 1000000;
				sInfoMessage += dVolumeDifference + "m3. ";
				reportMessage(sInfoMessage);
			}
		}
		else if (nShowImportError) 
		{
			PLine plFaces[] = _Map.getBodyFaceLoops(sRealSolid);
			for (int i = 0; i < plFaces.length(); i++)
			{
				PLine plFace = plFaces[i];
				PlaneProfile profFace(plFace);
				profFace.transformBy(vOffset * dOffset);
				dpText.draw(profFace, _kDrawAsShell);
			}
			
			sInfoMessage += T("|Not valid body resulted after importing from Map, showing face loops instead|. ");
			reportMessage(sInfoMessage);
		}
	}
	
	if (bDebug)
	{
		// Display coordSys in model
		Vector3d vectors[] ={ vecX, vecY, vecZ};	int nVecColors[] ={ 1, 3, 150}; double dVecL = U(400);
		for (int v = 0; v < vectors.length(); v++)
		{
			int nColor = v + 1; if(vectors.length() == nVecColors.length()) { nColor = nVecColors[v];} Display vecXdp(nColor);
			Vector3d vecXD = vectors[v]; vecXD.normalize(); double vecXdArrowFactor = 0.2, vecXdCircleFactor = 0.1, vecXdRadius = dVecL * vecXdCircleFactor;
			Point3d vecXptStart = _Pt0, vecXptEnd = vecXptStart + vecXD * dVecL, vecXptArrowNeck = vecXptEnd - vecXD * dVecL * vecXdArrowFactor;
			PLine vecXplCircle(vecXD); vecXplCircle.createCircle(vecXptArrowNeck, vecXD, vecXdRadius); vecXdp.draw(vecXplCircle);
			Vector3d vecXvY = (vecXplCircle.ptEnd() - vecXptArrowNeck); vecXvY.normalize();Vector3d vecXvZ = vecXD.crossProduct(vecXvY);
			LineSeg vecXls (vecXptStart, vecXptEnd); vecXdp.draw(vecXls);
			LineSeg vecXlsArrow1 (vecXptEnd, vecXptArrowNeck + vecXvY * vecXdRadius); vecXdp.draw(vecXlsArrow1);
			LineSeg vecXlsArrow2 (vecXptEnd, vecXptArrowNeck - vecXvY * vecXdRadius); vecXdp.draw(vecXlsArrow2); LineSeg vecXlsArrow3 (vecXptEnd, vecXptArrowNeck + vecXvZ * vecXdRadius); vecXdp.draw(vecXlsArrow3);
			LineSeg vecXlsArrow4 (vecXptEnd, vecXptArrowNeck - vecXvZ * vecXdRadius); vecXdp.draw(vecXlsArrow4); vecXdp.textHeight(dVecL * .14);
		}//next v
	}
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO">
              <lst nm="TSLINFO">
                <lst nm="TSLINFO">
                  <lst nm="TSLINFO">
                    <lst nm="TSLINFO">
                      <lst nm="TSLINFO">
                        <lst nm="TSLINFO">
                          <lst nm="TSLINFO">
                            <lst nm="TSLINFO">
                              <lst nm="TSLINFO" />
                            </lst>
                          </lst>
                        </lst>
                      </lst>
                    </lst>
                  </lst>
                </lst>
              </lst>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End