#Version 8
#BeginDescription
#Versions:
1.11 24.05.2022 HSB-15525: add display and grip points to manually define the splitting points Author: Marsel Nakuci
1.10 16.02.2022 Add the beam Locating Plate to the list of beams that need spliting Author: Alberto Jena
1.9 10.11.2021 HSB-13696: Add the beams blocking and SFBlocking to the list of beams that need spliting Author: Alberto Jena
1.8 20.09.2021 HSB-12788: fix bug when splitting at studs; fix bug when setting the beamcode; avoid same splitting point for two close beams Author: Marsel Nakuci
1.7 17.09.2021 HSB-12788: new property "side of clear space of stud" with 3 options {"both","left",right"} Author: Marsel Nakuci
version value="1.6" date="07apr2021" author="nils.gregor@hsbcad.com"> 
HSB-11462 Bugfix endless loop

Split plates on walls avoiding modules and studs for internal rows, with option to alternate split locations to external rows and set sorted beam codes. 
Can also be used to reset plates to original framing length.

commmand to create button:
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HSB_W-SplitPlates_Enhanced")) TSLCONTENT



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 11
#KeyWords Plate,Split
#BeginContents
//region history
/// <History>
/// #Versions:
// 1.11 24.05.2022 HSB-15525: add display and grip points to manually define the splitting points Author: Marsel Nakuci
// Version 1.10 16.02.2022 Add the beam Locating Plate to the list of beams that need spliting Author: Alberto Jena
// Version 1.9 10.11.2021 HSB-13696: Add the beams blocking and SFBlocking to the list of beams that need spliting Author: Alberto Jena
// Version 1.8 20.09.2021 HSB-12788: fix bug when splitting at studs; fix bug when setting the beamcode; avoid same splitting point for two close beams Author: Marsel Nakuci
// Version 1.7 17.09.2021 HSB-12788: new property "side of clear space of stud" with 3 options {"both","left",right"} Author: Marsel Nakuci
/// <version value="1.6" date="07apr2021" author="nils.gregor@hsbcad.com"> HSB-11462 Bugfix endless loop</version>
/// <version value="1.5" date="25mar2021" author="nils.gregor@hsbcad.com"> HSB-11223 filter plates by centerpoint of first plate</version>
/// <version value="1.4" date="25mar2021" author="nils.gregor@hsbcad.com"> HSB-11223 Added beamtype verybottomplate</version>
/// <version value="1.3" date="23mar2021" author="nils.gregor@hsbcad.com"> HSB-11278 no beamcode overwrite at default. HSB-11223 bugfix on element creation</version>
/// <version value="1.2" date="17mar2021" author="nils.gregor@hsbcad.com"> HSB-11223 Bugfix inaccuracy of searchpoint</version>
/// <version value="1.1" date="26feb2021" author="nils.gregor@hsbcad.com"> Added property add to label and beamcode suffix direction choice</version>
/// <version value="1.00" date="18apr2019" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select walls(s)
/// </insert>

/// <summary Lang=en>
/// Split plates on walls avoiding modules and studs for internal rows, with option to alternate split locations to external rows and set sorted beam codes. Can also be used to reset plates to original framing length
/// </summary>

//endregion
{
	//region props and bOnInsert	
	int bDebugSegments = false;
//	int bSplitPlates = !_bOnDebug;//(debug)
	int bSplitPlates = true;//(debug)
	U(1, "mm");
	double dEps = U(.1);
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
	String category = T("|General|");
	String sNoYes[] = { T("No"), T("Yes")};
	String sFirstRun = "FirstRun";
	String sCreatorTSL = "CreatorTSL";
	String sSpliceBlock = T("|SPLICE BLOCK|");
	String sBottomRowsCode = "B";
	String sTopRowsCode = "T";
	String sOtherBeamsRowCode = "O";
	String sRowCodes[0];
	Display dp(1);
	
	PropDouble dMaxLength(nDoubleIndex++, U(4800), T("Maximum length"));
	dMaxLength.setCategory(category);
	PropDouble dSizeOpeningModule(nDoubleIndex++, U(605), T("Opening module dimensions greater than"));
	dSizeOpeningModule.setCategory(category);
	PropDouble dDistOpeningModule(nDoubleIndex++, U(269), T("Split distance to opening module"));
	dDistOpeningModule.setCategory(category);
	PropDouble dDistSmallModule(nDoubleIndex++, U(119), T("Split distance to small module"));
	dDistSmallModule.setCategory(category);
	PropDouble dDistStud(nDoubleIndex++, U(119), T("Split distance to stud"));
	dDistStud.setCategory(category);
	
	// HSB-12788: new property 
	String sSideClearSpaceStudName=T("|Side of Stud Clear Space|");	
	String sSideClearSpaceStuds[] ={ T("|both|"), T("|left|"), T("|right|")};
	PropString sSideClearSpaceStud(nStringIndex++, sSideClearSpaceStuds, sSideClearSpaceStudName);	
	sSideClearSpaceStud.setDescription(T("|Defines the Side of Side of Stud Clear Space|"));
	sSideClearSpaceStud.setCategory(category);
	
	category = T("|Aditional options|");
	String sSplitLocations[] = { T("|Same|"), T("|Opposite|")};
	String sSplitLocationName = T("|Split Location|");
	PropString sSplitLocation(nStringIndex++, sSplitLocations, sSplitLocationName, 1);
	sSplitLocation.setDescription(T("|Defines if splits are aligned or opposite from bottom to top plates|"));
	sSplitLocation.setCategory(category);
	
	String sSplitExternalsOnStudName = T("|Split on stud|");
	PropString sSplitExternalsOnStud(nStringIndex++, sNoYes, sSplitExternalsOnStudName, 0);
	sSplitExternalsOnStud.setDescription(T("|Defines if splits on very top/bottom plates are over a stud, also can split Blocking|"));
	sSplitExternalsOnStud.setCategory(category);
	
	String sSpliceBlocksName = T("|Create splice blocks|");
	PropString sSpliceBlocks(nStringIndex++, sNoYes, sSpliceBlocksName, 1);
	sSpliceBlocks.setDescription(T("|Will Create Splice blocks in the location of the splits|"));
	sSpliceBlocks.setCategory(category);
	
	String sSetBeamCodeNames[] = { T("|No|"), T("|Left to Right|"), T("|Right to Left|")};
	String sSetBeamCodeName = T("|Set BeamCode|");
	PropString sSetBeamCode(nStringIndex++, sSetBeamCodeNames, sSetBeamCodeName, 1);
	sSetBeamCode.setDescription(T("Set a beamcode. The direction discribes the raise of the suffix"));
	sSetBeamCode.setCategory(category);
	
	String sAddBeamCodeToLableName=T("|Write BeamCode suffix to Label|");	
	PropString sAddBeamCodeToLable(nStringIndex++, sNoYes, sAddBeamCodeToLableName);	
	sAddBeamCodeToLable.setDescription(T("|Writes the suffix of the beam code to the Label|"));
	sAddBeamCodeToLable.setCategory(category);
	
	
	category = T("|Reset|");
	
	String sResetName = T("|Reset plates|");
	PropString sReset(nStringIndex++, sNoYes, sResetName, 0);
	sReset.setDescription(T("|Reset plates to original lengths|"));
	sReset.setCategory(category);
	
	category = T("|Debug|");
	
	String sPreviewName = T("|Preview mode|");
	PropString sPreview(nStringIndex++, sNoYes, sPreviewName, 1);
	sPreview.setDescription(T("|Allows the user to change settings without removing TSL|"));
	sPreview.setCategory(category);
	
	String sShowRegionsName = T("|Show non split regions|");
	PropString sShowRegions(nStringIndex++, sNoYes, sShowRegionsName, 1);
	sShowRegions.setDescription(T("|Show non split regions|"));
	sShowRegions.setCategory(category);
	
	int nSpliceBlocks = sNoYes.find(sSpliceBlocks, 0);
	int nSetBeamCode = sSetBeamCodeNames.find(sSetBeamCode, 0);
	int nAddBeamCodeToLable = sNoYes.find(sAddBeamCodeToLable, 0);
	int nSideClearSpaceStud = sSideClearSpaceStuds.find(sSideClearSpaceStud);
	int nSplitLocation = sSplitLocations.find(sSplitLocation, 0);
	int nSplitExternalsOnStud = sNoYes.find(sSplitExternalsOnStud, 0);
	int nReset = sNoYes.find(sReset, 0);
	int nPreview = sNoYes.find(sPreview, 0);
	int nShowRegions = sNoYes.find(sShowRegions, 0);
//	return
	// TriggerSplitPlates//region
	String sTriggerSplitPlates = T("|../Split Plates|");
	addRecalcTrigger(_kContext, sTriggerSplitPlates );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSplitPlates || _kExecuteKey==sDoubleClick))
	{
		;// just want to recalculate
	}//endregion	
	
	
	// TriggerReset//region
	String sTriggerReset = T("|../Reset Plates|");
	addRecalcTrigger(_kContext, sTriggerReset );
	if (_bOnRecalc && (_kExecuteKey == sTriggerReset || _kExecuteKey == sDoubleClick))
	{
		nReset = true;
	}//endregion
	
	// TriggerResetAndDelete//region
	String sTriggerResetAndDelete = T("|../Reset Plates And Delete|");
	addRecalcTrigger(_kContext, sTriggerResetAndDelete );
	if (_bOnRecalc && (_kExecuteKey == sTriggerResetAndDelete))
	{
		nReset = true;
		nPreview = false;
	}//endregion
	
	// TriggerDelete//region
	String sTriggerDelete = T("|../Delete|");
	addRecalcTrigger(_kContext, sTriggerDelete );
	if (_bOnRecalc && (_kExecuteKey == sTriggerDelete))
	{
		nPreview = false;
	}//endregion
	
	
	_ThisInst.setSequenceNumber(110);
	
	if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);
	
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i = 0; i < sEntries.length(); i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey) >- 1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		setCatalogFromPropValues(sLastInserted);
		
		PrEntity ssE(T("|Select element(s)|"), ElementWallSF());
		if (ssE.go())
			_Element.append(ssE.elementSet());
		
		TslInst tslNew;
		Vector3d vecXTsl = _XE;	Vector3d vecYTsl = _YE;
		GenBeam gbsTsl[] = { };	Entity entsTsl[1];//= { };
		Point3d ptsTsl[1];//= { };
		int nProps[] ={ };		double dProps[] ={ dMaxLength, dSizeOpeningModule, dDistOpeningModule, dDistSmallModule, dDistStud};
		String sProps[] ={ sSideClearSpaceStud, sSplitLocation, sSplitExternalsOnStud, sSpliceBlocks, sSetBeamCode, sAddBeamCodeToLable, sReset};
		Map mapTsl;				String sScriptname = scriptName();
		mapTsl.setInt(sFirstRun, true);
		
		for (int i = 0; i < _Element.length(); i++)
		{
			TslInst tsls[] = _Element[i].tslInstAttached();
			int bInserted;
			for ( int t = 0; t < tsls.length(); t++)
			{
				TslInst tsl = tsls[t];
				
				// TSL is already present on element
				if ( tsl.scriptName() == scriptName())
				{
					bInserted = true;
					break;
				}
			}
			
			if (bInserted)
			{
				reportMessage("\n" + scriptName() + T(" - |Error on element| " ) + _Element[i].code() + "-" + _Element[i].number() + T(": |TSL is already present|\n"));
				continue;
			}
			
			entsTsl[0] = _Element[i];
			ptsTsl[0] = _Element[i].ptOrg();
			tslNew.dbCreate(sScriptname , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl,
			nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			// set props by last entry
			if (tslNew.bIsValid())
				tslNew.setPropValuesFromCatalog(sLastInserted);
		}
		
		eraseInstance();
		return;
	}
	//endregion props and bOnInsert
	
	//region validation and basics	
	if ( _Element.length() != 1 )
	{
		eraseInstance();
		return;
	}
	
	ElementWall el = (ElementWall)_Element[0];
	if ( ! el.bIsValid())
	{
		eraseInstance();
		return;
	}
		
	CoordSys cs = el.coordSys();
	Point3d ptOrg = _Pt0 = cs.ptOrg();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	assignToElementGroup(el, true, 0, 'E');
	int bFirstRun = _Map.getInt(sFirstRun); _Map.setInt(bFirstRun, false);
	
	LineSeg lsElMinMax = el.segmentMinMax();
	double dLengthEl = abs(vecX.dotProduct(lsElMinMax.ptStart() - lsElMinMax.ptEnd()));
	double dHeightEl = abs(vecY.dotProduct(lsElMinMax.ptStart() - lsElMinMax.ptEnd()));
	double dWidthEl = abs(vecZ.dotProduct(lsElMinMax.ptStart() - lsElMinMax.ptEnd()));
	
	Point3d ptBackTopRightEl = ptOrg + vecX * dLengthEl + vecY * dHeightEl - vecZ * dWidthEl;
	Point3d ptCenterEl = ptOrg + vecX * dLengthEl * .5 + vecY * dHeightEl * .5 - vecZ * dWidthEl * .5; //3D center of whole body
	
	Beam bmAllBeams[] = el.beam();
	Beam bmVerticals[] = vecX.filterBeamsPerpendicularSort(bmAllBeams);
	Beam bmHorizontals[] = vecY.filterBeamsPerpendicularSort(bmAllBeams);
	
	// Draw Point3d
	Display dpX (3); double dXl = U(500); Point3d ptX = _Pt0; PLine plTmp (_ZW); plTmp.addVertex(ptX - _XW * dXl * .5); plTmp.addVertex(ptX + _XW * dXl * .5); plTmp.addVertex(ptX);
	plTmp.addVertex(ptX - _YW * dXl * .5); plTmp.addVertex(ptX + _YW * dXl * .5); dpX.draw(plTmp); plTmp = PLine (_XW); plTmp.addVertex(ptX - _ZW * dXl * .5); plTmp.addVertex(ptX + _ZW * dXl * .5); dpX.draw(plTmp);
	//endregion validation and basics
	
	//region Find no splitting regions
	
	//---------------------------------------------------------------------------------------------------------------------
	//                          Find start and end of modules and fill an array with studs
	Beam bmModuleBeams[0];
	int nModuleIndexes[0];
	String sModuleNames[0];
	Beam bmStuds[0], bmNoStuds[0];
	
	// collect studs and modules
	for ( int i = 0; i < bmAllBeams.length(); i++)
	{
		Beam bm = bmAllBeams[i];
		
		String sModule = bm.name("module");
		if ( bm.type() == _kStud ) {
			bmStuds.append(bm);
			bm.envelopeBody().vis(3);
		}
		else
		{
			bmNoStuds.append(bm);
			if ( bm.name("module") != "" )
			{
				bmModuleBeams.append(bm);
				bm.envelopeBody().vis(150);
				
				if ( sModuleNames.find(sModule) == -1 ) {
					sModuleNames.append(sModule);
				}
				
				nModuleIndexes.append( sModuleNames.find(sModule) );
			}
		}
	}
	// sModuleNames contains al different module names
	// nModuleIndexes containsindex to sModuleNames for all module beams
	bmStuds = vecX.filterBeamsPerpendicularSort(bmStuds);
	
	double dMinModules[sModuleNames.length()];
	double dMaxModules[sModuleNames.length()];
	int bMinMaxSets[sModuleNames.length()];
	for ( int i = 0; i < bMinMaxSets.length(); i++)
	{
		bMinMaxSets[i] = FALSE;
	}
	
	for ( int i = 0; i < bmModuleBeams.length(); i++)
	{
		Beam bm = bmModuleBeams[i];
//		bm.envelopeBody().vis(2);
		int nIndex = nModuleIndexes[i];
		
		Point3d arPtBm[] = bm.realBody().allVertices();
		Plane pn(el.ptOrg() , vecY);
		arPtBm = pn.projectPoints(arPtBm);
		
		for ( int i = 0; i < arPtBm.length(); i++)
		{
			Point3d pt = arPtBm[i];
			double dDist = vecX.dotProduct( pt - el.ptOrg() );
			
			if ( ! bMinMaxSets[nIndex] )
			{
				bMinMaxSets[nIndex] = TRUE;
				// minimum distance to element origin
				// max distance to element origin for all module beams
				dMinModules[nIndex] = dDist;
				dMaxModules[nIndex] = dDist;
			}
			else
			{
				if ( (dMinModules[nIndex] - dDist) > dEps )
				{
					dMinModules[nIndex] = dDist;
				}
				if ( (dDist - dMaxModules[nIndex]) > dEps )
				{
					dMaxModules[nIndex] = dDist;
				}
			}
		}
	}
	
	// offset from each beam with dDistSmallModule or dDistOpeningModule
	// offset must not be larger then dMaxModules[i] - dMinModules[i]
	Point3d ptMinModules[0];
	Point3d ptMaxModules[0];
	for ( int i = 0; i < sModuleNames.length(); i++)
	{
		if ( (dMaxModules[i] - dMinModules[i]) > dSizeOpeningModule )
		{
			ptMinModules.append(el.ptOrg() + vecX * (dMinModules[i] - dDistOpeningModule));
			ptMaxModules.append(el.ptOrg() + vecX * (dMaxModules[i] + dDistOpeningModule));
		}
		else
		{
			ptMinModules.append(el.ptOrg() + vecX * (dMinModules[i] - dDistSmallModule));
			ptMaxModules.append(el.ptOrg() + vecX * (dMaxModules[i] + dDistSmallModule));
		}
	}
	
	for ( int i = 0; i < ptMinModules.length(); i++)
	{ //non split zone from all modules (i = each module)
		Point3d pt0 = ptMinModules[i]; pt0.setZ(ptCenterEl.Z()); //start point includying offset from module
		Point3d pt1 = ptMaxModules[i]; pt1.setZ(ptCenterEl.Z()); //end point includying offset from module
		Point3d (pt0 + _ZW * 0).vis(150);
		Point3d (pt1 + _ZW * 0).vis(150);
	}
	
	//---------------------------------------------------------------------------------------------------------------------
	//                                                      Find start and end of studs
	Point3d ptMinStuds[0];
	Point3d ptMaxStuds[0];
	for ( int i = 0; i < bmStuds.length(); i++)
	{
		Beam bm = bmStuds[i];
		
		//non split zone for each stud
		// distinguish between both sides or left or right sides !!!!!
		if(nSideClearSpaceStud==0)
		{ 
			// both
			ptMinStuds.append( bm.ptCen() - vecX * dDistStud );
			ptMaxStuds.append( bm.ptCen() + vecX * dDistStud );
		}
		else if(nSideClearSpaceStud==1)
		{ 
			// left
			ptMinStuds.append( bm.ptCen() - vecX * dDistStud );
			ptMaxStuds.append( bm.ptCen() + vecX * 0 );
		}
		else if(nSideClearSpaceStud)
		{ 
			// right
			ptMinStuds.append( bm.ptCen() - vecX * 0 );
			ptMaxStuds.append( bm.ptCen() + vecX * dDistStud );
		}
		
		Point3d(bm.ptCen() - vecX * dDistStud).vis();
		Point3d(bm.ptCen() + vecX * dDistStud).vis();
	}
	
	//---------------------------------------------------------------------------------------------------------------------
	//                 Combine array's with min and max points and sort them from left to right
	
	Point3d ptMins[0];
	Point3d ptMaxs[0];
	ptMins.append(ptMinModules);
	ptMins.append(ptMinStuds);
	ptMaxs.append(ptMaxModules);
	ptMaxs.append(ptMaxStuds);
	
	Point3d ptSort;
	for (int s1 = 1; s1 < ptMins.length(); s1++)
	{
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--)
		{
			if ( vecX.dotProduct( ptMins[s11] - el.ptOrg() ) < vecX.dotProduct( ptMins[s2] - el.ptOrg() ) )
			{
				ptSort = ptMins[s2];			ptMins[s2] = ptMins[s11];				ptMins[s11] = ptSort;
				ptSort = ptMaxs[s2];		ptMaxs[s2] = ptMaxs[s11];		ptMaxs[s11] = ptSort;
				
				s11 = s2;
			}
		}
	}
	
	// project these points to a line for preview
	double dOffset = U(125);
	Point3d ptLn = ptOrg - _ZW * dOffset * 2;
	for (int i = 0; i < ptMins.length(); i++)
	{
		ptMins[i].setZ(ptLn.Z());
		ptMaxs[i].setZ(ptLn.Z());
	}
	
	// join related segments
	LineSeg lsDisplayedLines[0];
	for (int i = 0; i < ptMins.length() - 1; i++)
	{
		ptLn = ptOrg - _ZW * dOffset * 2;
		
		Point3d ptMini = ptMins[i];
		Point3d ptMaxi = ptMaxs[i];
		
		if (bDebugSegments)
		{
			LineSeg ls(ptMaxi, ptMini); ls.vis(1); lsDisplayedLines.append(ls);
		}
		
		for (int j = i + 1; j < ptMins.length(); j++)
		{
			ptLn -= _ZW * dOffset;
			Point3d ptMinj = ptMins[j];
			Point3d ptMaxj = ptMaxs[j];
			ptMinj.setZ(ptLn.Z());ptMaxj.setZ(ptLn.Z()); //(debug)
			
			if (bDebugSegments)
			{
				LineSeg ls (ptMaxj, ptMinj); ls.vis(4); lsDisplayedLines.append(ls);
			}
			
			//check if lineSeg must be joined
			int bMinjContained, bMaxjContained;
			Vector3d vDir = vecX;
			if (vDir.dotProduct(ptMinj - ptMini) * vDir.dotProduct(ptMinj - ptMaxi) < 0 ) //ptMinj is between ptMini and ptMaxi when projected between the 2
			{
				bMinjContained = true;
			}
			
			if (vDir.dotProduct(ptMaxj - ptMini) * vDir.dotProduct(ptMaxj - ptMaxi) < 0 ) //ptMaxj is between ptMini and ptMaxi when projected between the 2
			{
				bMaxjContained = true;
			}
			
			if (bMinjContained && bMaxjContained)
			{
				ptMins.removeAt(j);
				ptMaxs.removeAt(j);
				i--;
				if (bDebugSegments) { LineSeg(ptMaxj, ptMinj).vis(1); } //turn off
				break;
			}
			else if (bMinjContained)
			{
				ptMaxs[i] = ptMaxs[j];
				ptMins.removeAt(j);
				ptMaxs.removeAt(j);
				i--;
				break;
			}
		}
		
		if (bDebugSegments)
		{
			for (int s = 0; s < lsDisplayedLines.length(); s++)
			{
				LineSeg ls = lsDisplayedLines[s];
				ls.vis(58);
			}//next index
		}
	}//next index
	
	// Validate that longer segment is short/equals to plate's max length set by user. Debug regions
	LineSeg lsNoSplitRegions[0];
	double dMinimumSplitLength;
	for (int i = 0; i < ptMins.length(); i++)
	{
		LineSeg lsRegion = LineSeg(ptMins[i], ptMaxs[i]);
		lsNoSplitRegions.append(lsRegion);
		if (dMinimumSplitLength < lsRegion.length())
			dMinimumSplitLength = lsRegion.length();
		
		if (nShowRegions || bDebug)
		{
			dp.draw(lsRegion);
		}
	}
	
	if (dMaxLength < dMinimumSplitLength)
	{
		String sMinimumSplitLength;
		sMinimumSplitLength.formatUnit(dMinimumSplitLength, 2, 0);
		reportWarning(T("Minimum split length is") + sMinimumSplitLength);
		eraseInstance();
		return;
	}
	
	LineSeg lsNoSplitInvertedRegions[0];
	for (int s = lsNoSplitRegions.length() - 1; s >= 0; s--)
	{
		lsNoSplitInvertedRegions.append(LineSeg(lsNoSplitRegions[s].ptEnd(), lsNoSplitRegions[s].ptStart()));
	}//next s
	//endregion Find no splitting regions
	
	//region Collect and join plates, reset beam code // remove previous splices created by this TSL
	String s[0];
	int a;
	Beam bmPlates[0];
	for (int b = 0; b < bmAllBeams.length(); b++)
	{
		Beam bm = bmAllBeams[b];
		
		if(s.find( _BeamTypes[bm.type()]  ,-1) < 0)
			s.append(_BeamTypes[bm.type()]);
		
		if (bm.type() == _kTopPlate || bm.type() == _kSFTopPlate || bm.type() == _kPanelTopPlate || bm.type() == _kSFVeryTopPlate || bm.type() == _kSFVeryTopSlopedPlate  || bm.type() == _kPanelCapStrip
			 || bm.type() == _kSFAngledTPLeft || bm.type() == _kSFAngledTPRight || bm.type() == _kBottom || bm.type() == _kPanelBottomPlate || bm.type() == _kSFBottomPlate || bm.type() == _kSFVeryBottomPlate || bm.type() == _kSFBlocking
			 || bm.type() == _kLocatingPlate)
			{
				bmPlates.append(bm);
				if(nSetBeamCode > 0)
					bm.setBeamCode(";;;;;;;;;;;;");
			}
			else if (bm.type() == _kBlocking && bm.name() == sSpliceBlock)
			{
				bm.dbErase();
				bmAllBeams.removeAt(b);
				b--;
			}
	}

	
	// join split plates
	Beam bmNewPlates[0];
	for (int i = 0; i < bmPlates.length(); i++)
	{
		Beam bm0 = bmPlates[i];
		if (bmNewPlates.find(bm0, - 1) < 0)
		{
			bmNewPlates.append(bm0);
		}
		
		for (int j = i + 1; j < bmPlates.length(); j++)
		{
			Beam bm1 = bmPlates[j];
			PlaneProfile pp0 = bm0.envelopeBody().getSlice(Plane(bm0.ptCen(), bm0.vecD(_ZW)));
			pp0.shrink(-U(1));
			PlaneProfile pp1 = bm1.envelopeBody().getSlice(Plane(bm0.ptCen(), bm0.vecD(_ZW)));
			pp1.shrink(-U(1));
			
			// must be parallel, at same height and in length contact
			if ( ! bm0.vecX().isParallelTo(bm1.vecX()) || abs(bm0.vecD(_ZW).dotProduct(bm0.ptCen() - bm1.ptCen())) > dEps || !pp0.intersectWith(pp1) || bm0 == bm1)
				continue;
			
			bmPlates.removeAt(j);
			bm0.dbJoin(bm1);
			j = i;
		}//next index
	}//next index
	
//	if (nReset)
//	{
//		if ( ! nPreview)
//		{
//			eraseInstance();
//		}
//		
//		return;
//	}
	
	//plates number may changed, collect again
	Beam bmTopAndVeryTopPlates[0], bmBottomAndVeryBottomPlates[0];
	Beam bmOtherLongBeams[0];
	for (int b = 0; b < bmNewPlates.length(); b++)
	{
		Beam bm = bmPlates[b];
		if (bm.type() == _kTopPlate || bm.type() == _kSFTopPlate || bm.type() == _kPanelTopPlate || bm.type() == _kSFVeryTopPlate || bm.type() == _kSFVeryTopSlopedPlate || bm.type() == _kPanelCapStrip
			 || bm.type() == _kSFAngledTPLeft || bm.type() == _kSFAngledTPRight )
			{
				bmTopAndVeryTopPlates.append(bm);
			}
			else if (bm.type() == _kBottom || bm.type() == _kPanelBottomPlate || bm.type() == _kSFBottomPlate || bm.type() == _kSFVeryBottomPlate) 
			{
				bmBottomAndVeryBottomPlates.append(bm);
			}
			else if (bm.type() == _kSFBlocking || bm.type() == _kBlocking || bm.type() == _kBrace || bm.type() == _kLocatingPlate)
			{ 
				bmOtherLongBeams.append(bm);
			}
	}
	//endregion Get plates, join them, group them by type and orientation
	
	//region Get bottom plates (bmBPS), very bottom plates (bmVBPs), top plates (bmTPs) and very top plates (bmVTPs)	
	Beam bmVTPs[0];//Very top plates
	Beam bmTPs[0];//Top plates
	Beam bmBPs[0];//Bottom plates
	Beam bmVBPs[0];//very Bottom plates
	Beam bmLongBeams[0];//very Bottom plates
	
	// Searching for lower and higher bottom plates
	Beam bmTmpBottomPlates[0];
	bmTmpBottomPlates.append(bmBottomAndVeryBottomPlates);
	
	for (int b = 0; b < bmTmpBottomPlates.length(); b++)
	{
		Beam bmCurrentGroup[0];
		Beam bmCurrent = bmTmpBottomPlates[b];
		bmCurrentGroup.append(bmCurrent);
		if (bmTmpBottomPlates.length() > b)
		{
			for (int c = b + 1; c < bmTmpBottomPlates.length(); c++)//Group all aligned and paralalell beams
			{
				Beam bmNext = bmTmpBottomPlates[c];
				if (bmCurrent.vecX().isParallelTo(bmNext.vecX()) && abs(bmCurrent.vecX().dotProduct(bmCurrent.ptCen() - bmNext.ptCen())) < dEps)
				{
					bmCurrentGroup.append(bmNext);
					bmTmpBottomPlates.removeAt(c);
					c--;
				}
			}
		}
		
		// Setting increasing beamcodes to every beam in group
		Vector3d vRef = bmCurrent.vecD(_ZW);
		bmCurrentGroup = vRef.filterBeamsPerpendicularSort(bmCurrentGroup);
		for (int d = 0; d < bmCurrentGroup.length(); d++)
		{
			Beam bm = bmCurrentGroup[d];
			if (d == bmCurrentGroup.length() - 1)
			{
				bmBPs.append(bm);
			}
			else
			{
				bmVBPs.append(bm);
			}
			
			if (nSetBeamCode)
			{
				String sBeamCode = sBottomRowsCode + String(d + 1);
				bm.setBeamCode(sBeamCode);
				if (sRowCodes.find(sBeamCode, - 1) < 0)
				{
					sRowCodes.append(sBeamCode);
				}
			}
		}
	}
	
	// Searching for lower and higher top plates even if they're angled
	Beam bmTopPlatesTmp[0];
	bmTopPlatesTmp.append(bmTopAndVeryTopPlates);
	
	for (int b = 0; b < bmTopPlatesTmp.length(); b++)
	{
		Beam bmCurrentGroup[0];
		Beam bmCurrent = bmTopPlatesTmp[b];
		bmCurrentGroup.append(bmCurrent);
		if (bmTopPlatesTmp.length() > b)
		{
			for (int c = b + 1; c < bmTopPlatesTmp.length(); c++)//Group all aligned and paralalell beams
			{
				Beam bmNext = bmTopPlatesTmp[c];
				if (bmCurrent.vecX().isParallelTo(bmNext.vecX()))
				{
					bmCurrentGroup.append(bmNext);
					bmTopPlatesTmp.removeAt(c);
					c--;
				}
			}
		}
		
		// Get higher and lower beams for every group
		Vector3d vRef = bmCurrent.vecD(-_ZW);
		bmCurrentGroup = vRef.filterBeamsPerpendicularSort(bmCurrentGroup);
		
		// Setting increasing beamcodes to every beam in group
		for (int d = 0; d < bmCurrentGroup.length(); d++)
		{
			Beam bm = bmCurrentGroup[d];
			if (d == bmCurrentGroup.length() - 1)
			{
				bmTPs.append(bm);
			}
			else
			{
				bmVTPs.append(bm);
			}
			
			if (nSetBeamCode)
			{
				String sBeamCode = sTopRowsCode + String(d + 1);
				bm.setBeamCode(sBeamCode);
				if (sRowCodes.find(sBeamCode, - 1) < 0)
				{
					sRowCodes.append(sBeamCode);
				}
			}
		}
	}
	
	// Searching for lower and higher brace even if they're angled
	Beam bmLongBeamsTmp[0];
	bmLongBeamsTmp.append(bmOtherLongBeams);
	
	for (int b = 0; b < bmLongBeamsTmp.length(); b++)
	{
		Beam bmCurrentGroup[0];
		Beam bmCurrent = bmLongBeamsTmp[b];
		bmCurrentGroup.append(bmCurrent);
		if (bmLongBeamsTmp.length() > b)
		{
			for (int c = b + 1; c < bmLongBeamsTmp.length(); c++)//Group all aligned and paralalell beams
			{
				Beam bmNext = bmLongBeamsTmp[c];
				if (bmCurrent.vecX().isParallelTo(bmNext.vecX()))
				{
					bmCurrentGroup.append(bmNext);
					bmLongBeamsTmp.removeAt(c);
					c--;
				}
			}
		}
		
		// Get higher and lower beams for every group
		Vector3d vRef = bmCurrent.vecD(-_ZW);
		bmCurrentGroup = vRef.filterBeamsPerpendicularSort(bmCurrentGroup);
		
		// Setting increasing beamcodes to every beam in group
		for (int d = 0; d < bmCurrentGroup.length(); d++)
		{
			
			Beam bm = bmCurrentGroup[d];
			{
				bmLongBeams.append(bm);
			}
			
			if (nSetBeamCode)
			{
				String sBeamCode = sOtherBeamsRowCode + String(0 + 1);
				bm.setBeamCode(sBeamCode);
				if (sRowCodes.find(sBeamCode, - 1) < 0)
				{
					sRowCodes.append(sBeamCode);
				}
			}
		}
	}
	
	//endregion Get bottom plates (bmBPS), very bottom plates (bmVBPs), top plates (bmTPs) and very top plates (bmVTPs)
	
	//region get valid studs 
	Beam arBmValidStuds[0];
	for ( int i = 0; i < bmStuds.length(); i++)
	{
		Beam bm = bmStuds[i];
		bm.envelopeBody().vis(1);
		//stud must go from bottom to top plates
		int bBottom, bTop;
		Beam bmFilteredBeams[] = bm.filterBeamsHalfLineIntersectSort(bmNoStuds, bm.ptCen(), - _ZW);
		if (bmFilteredBeams.length() > 0 && bmBPs.find(bmFilteredBeams[0], - 1) >= 0)
			bBottom = true;
		bmFilteredBeams = bm.filterBeamsHalfLineIntersectSort(bmNoStuds, bm.ptCen(), _ZW);
		if (bmFilteredBeams.length() > 0 && bmTPs.find(bmFilteredBeams[0], - 1) >= 0)
			bTop = true;
		
		if (bBottom && bTop)
		{
			arBmValidStuds.append(bm);
			bm.envelopeBody().vis(3);
			
		}
	}
	//endregion get valid studs
//	return
	//region split internal plates	
	Beam bmInternalPlates [0];
	bmInternalPlates.append(bmBPs);
	bmInternalPlates.append(bmTPs);
	int nBreakCount;
	Point3d ptSplitsInternalPlates[0];
	
	
	Point3d ptSplitsBottom[0],ptSplitsTop[0],ptSplitsInternal[0];
	Point3d ptSplitsVBPs[0],ptSplitsVTPs[0],ptSplitsLongBeams[0],ptSplitsExternal[0];
//	return
	int iFirstTime=!_Map.getInt("FirstTime");
	int iManualSplit=_Map.getInt("ManualSplit");
	if(iFirstTime)
	{ 
		// HSB-15525
		// at first time it will check if the solution of TSL can be accepted
		_Map.setInt("FirstTime", true);
		// check the splitting points if they collide with each other
		for (int b = 0; b < bmInternalPlates.length(); b++)
		{
			Beam bm = bmInternalPlates[b];
			
			if (bm.dL() <= dMaxLength) continue;
			
			int bPlateIsAtTop = false;
			if (_ZW.dotProduct(bm.ptCenSolid() - ptCenterEl) > 0)
				bPlateIsAtTop = true;
			
			Vector3d vecXBm = bm.vecX();
			if (vecXBm.dotProduct(vecX) < 0)
				vecXBm *= -1; //always from left to right
			
			LineSeg lsInternalPlatesRegions[0];
			lsInternalPlatesRegions.append(lsNoSplitRegions);
			if (bPlateIsAtTop && nSplitLocation == 1) //opposite split locations
			{
				vecXBm *= -1;
				lsInternalPlatesRegions.setLength(0);
				lsInternalPlatesRegions.append(lsNoSplitInvertedRegions);
			}
			
			Point3d pts[] = bm.realBody().extremeVertices(vecXBm);
			if (pts.length() == 0) continue;
			
			Point3d ptStartBm = pts[0], ptEndBm = pts[pts.length() - 1]; //left and right from beam sorted from left to right of element
			ptStartBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptStartBm - bm.ptCenSolid());
			ptEndBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptEndBm - bm.ptCenSolid());
			
			if (bDebug)
			{
				//			bm.realBody().vis(1);
				//			ptStartBm.vis(); ptEndBm.vis();
				//			vecXBm.vis(bm.ptCen());
			}
			
			// shadow project segments on beam
			LineSeg lsBmRegions[0];
			Plane plnBm (bm.ptCenSolid(), bm.vecD(_ZW));
			for (int s = 0; s < lsInternalPlatesRegions.length(); s++)
			{
				LineSeg lsInternalPlatesRegion = lsInternalPlatesRegions[s];
				
				// shadow project points to beams axis
				Point3d ptStartRegion = lsInternalPlatesRegion.ptStart();
				ptStartRegion = Line(ptStartRegion, _ZW).intersect(plnBm, 0);
				Point3d ptEndRegion = lsInternalPlatesRegion.ptEnd();
				ptEndRegion = Line(ptEndRegion, _ZW).intersect(plnBm, 0);
				
				// check if _region is useless for this beam (it's out of scope)
				if ((vecXBm.dotProduct(ptStartRegion - ptStartBm) < 0 && vecXBm.dotProduct(ptEndRegion - ptStartBm) < 0) ||
					(vecXBm.dotProduct(ptStartRegion - ptEndBm) > 0 && vecXBm.dotProduct(ptEndRegion - ptEndBm) > 0))
				continue;
				
				//find new start
				Point3d ptStartNew;
				if (vecXBm.dotProduct(ptStartBm - ptStartRegion) < 0)
				{
					ptStartNew = ptStartRegion;
				}
				else
				{
					ptStartNew = ptStartBm;
				}
				
				// find new end
				Point3d ptEndNew;
				if (vecXBm.dotProduct(ptEndBm - ptEndRegion) < 0)
				{
					ptEndNew = ptEndBm;
				}
				else
				{
					ptEndNew = ptEndRegion;
				}
				//ptStartRegion.vis(); ptEndRegion.vis();
				
				lsBmRegions.append(LineSeg(ptStartNew, ptEndNew));
				LineSeg(ptStartNew, ptEndNew).vis(s);
			}//next s
			
			Point3d ptSplit;
			double dDistance;
			for (int r = 0; r < lsBmRegions.length(); r++)
			{
				Point3d ptMid;
				if (r == 0)
				{
					ptMid = LineSeg(ptStartBm, lsBmRegions[r].ptStart()).ptMid();
				}
				else
				{
					ptMid = LineSeg(lsBmRegions[r - 1].ptEnd(), lsBmRegions[r].ptStart()).ptMid();
				}
				
				dDistance = abs(vecXBm.dotProduct(ptMid - ptStartBm));
				if (dDistance > dMaxLength)
					break;
				
				ptSplit = ptMid;
			}//next r
			
			
			ptSplit.vis(1);
			// HSB-15525
			if(bPlateIsAtTop)
			{ 
				ptSplitsTop.append(ptSplit);
			}
			else if(!bPlateIsAtTop)
			{ 
				ptSplitsBottom.append(ptSplit);
			}
			// 
			ptSplitsInternal.append(ptSplit);
			ptSplitsInternalPlates.append(ptSplit);
			
			if (bSplitPlates)
			{
				//
				Beam bmNew = bm.dbSplit(ptSplit, ptSplit);
				if(bmNew.dL() > U(1))
					bmInternalPlates.append(bmNew);
				if (bPlateIsAtTop)
				{
					bmTPs.append(bmNew);
				}
				else
				{
					bmBPs.append(bmNew);
				}
				
				b = - 1;
			}
			
			// create splice blocks
			if (nSpliceBlocks && !bDebug)
			{
				Line ln(bm.ptCen(), bm.vecX());
				Point3d ptSplice = ln.closestPointTo(ptSplit);
				double dBmWidth = bm.dD(vecY);
				double dBmHeight = bm.dD(vecZ);
				
				if (bPlateIsAtTop)
					ptSplice.transformBy(bm.vecD(_ZW) * - dBmWidth);
				else
					ptSplice.transformBy(bm.vecD(_ZW) * dBmWidth);
				
				Beam bmSplice;
				bmSplice.dbCreate(ptSplice, bm.vecX(), bm.vecY(), bm.vecZ(), U(50), bm.dW(), bm.dH(), 0, 0, 0);
				bmSplice.setColor(bm.color());
				bmSplice.setMaterial(bm.material());
				bmSplice.setGrade(bm.grade());
				bmSplice.setName(sSpliceBlock);
				bmSplice.setType(_kBlocking);
				bmSplice.assignToElementGroup(el, true, 0, 'E');
				
				Beam bmAux[0];
				bmAux = Beam().filterBeamsHalfLineIntersectSort(bmVerticals, ptSplice, bm.vecX());
				if (bmAux.length() > 0)
					bmSplice.stretchStaticTo(bmAux[0], TRUE);
				
				bmAux.setLength(0);
				bmAux = Beam().filterBeamsHalfLineIntersectSort(bmVerticals, ptSplice, - bm.vecX());
				if (bmAux.length() > 0)
					bmSplice.stretchStaticTo(bmAux[0], TRUE);
			}
			
			nBreakCount++;
			if(nBreakCount == 100)
				break;
		}//next b
		//endregion split internal plates
		
		//region re - define non split regions to non stud regions 
		LineSeg lsNoStudRegions[0];
		if (nSplitExternalsOnStud)
		{
			//collect all zones that are not stud
			for ( int i = 0; i < arBmValidStuds.length(); i++) {
				Beam bm = arBmValidStuds[i];
				if (i == 0)
				{
					lsNoStudRegions.append(LineSeg(ptOrg, bm.ptCen() - vecX * bm.dD(vecX) * .5 ));
				}
				else if (i == arBmValidStuds.length() - 1)
				{
					lsNoStudRegions.append(LineSeg(arBmValidStuds[i - 1].ptCen() + vecX * arBmValidStuds[i - 1].dD(vecX) * .5, bm.ptCen() - vecX * bm.dD(vecX) * .5));
					lsNoStudRegions.append(LineSeg(bm.ptCen() + vecX * bm.dD(vecX) * .5, ptOrg + vecX * dLengthEl));
				}
				else
				{
					lsNoStudRegions.append(LineSeg(arBmValidStuds[i - 1].ptCen() + vecX * arBmValidStuds[i - 1].dD(vecX) * .5, bm.ptCen() - vecX * bm.dD(vecX) * .5));
				}
			}
			
			//alignt regions
			Point3d ptAlign = ptOrg - _ZW * U(250);
			LineSeg lsTmp[0];
			for (int t = 0; t < lsNoStudRegions.length(); t++)
			{
				Point3d ptStart = lsNoStudRegions[t].ptStart();
				ptStart.setZ(ptAlign.Z());
				Point3d ptEnd = lsNoStudRegions[t].ptEnd();
				ptEnd.setZ(ptAlign.Z());
				lsTmp.append(LineSeg(ptStart, ptEnd));
			}//next t
			lsNoStudRegions = lsTmp;
			
			lsNoSplitRegions.setLength(0);
			lsNoSplitRegions.append(lsNoStudRegions);
			lsNoSplitInvertedRegions.setLength(0);
			for (int s = lsNoSplitRegions.length() - 1; s >= 0; s--)
			{
				lsNoSplitInvertedRegions.append(LineSeg(lsNoSplitRegions[s].ptEnd(), lsNoSplitRegions[s].ptStart()));
			}//next s
		}
		
		for (int t = 0; t < lsNoStudRegions.length(); t++)
		{
			lsNoStudRegions[t].vis(2);
			
		}//next t
		//endregion re - define non split regions to non stud regions
		
	//	return
		//region split external plates (very top/bottoms)
		Beam bmExternalPlates [0];
		// VeryBottomPlates, VeryTopPlates
		bmExternalPlates.append(bmVBPs);
		bmExternalPlates.append(bmVTPs);
		bmExternalPlates.append(bmLongBeams);
		nBreakCount = 0;
		
		for (int b = 0; b < bmExternalPlates.length(); b++)
		{
			Beam bm = bmExternalPlates[b];
			if (bm.dL() <= dMaxLength) continue;
			
			int bPlateIsAtTop = false;
			if (_ZW.dotProduct(bm.ptCenSolid() - ptCenterEl) > 0)
				bPlateIsAtTop = true;
			
			Vector3d vecXBm = bm.vecX();
			if (vecXBm.dotProduct(vecX) > 0)
				vecXBm *= -1; //always from right to left (opposite to internal plates)
			
			LineSeg lsExternalPlatesRegions[0];
			lsExternalPlatesRegions.append(lsNoSplitInvertedRegions);
			if (bPlateIsAtTop && nSplitLocation == 1) //opposite split locations
			{
				vecXBm *= -1;
				lsExternalPlatesRegions.setLength(0);
				lsExternalPlatesRegions.append(lsNoSplitRegions);
			}
			
			Point3d pts[] = bm.realBody().extremeVertices(vecXBm);
			if (pts.length() == 0) continue;
			
			Point3d ptStartBm = pts[0], ptEndBm = pts[pts.length() - 1]; //left and right from beam sorted from left to right of element
			ptStartBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptStartBm - bm.ptCenSolid());
			ptEndBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptEndBm - bm.ptCenSolid());
			
			if (bDebug)
			{
				//			bm.realBody().vis(2);
							ptStartBm.vis(); ptEndBm.vis();
				//			vecXBm.vis(bm.ptCen());
			}
			
			// shadow project segments on beam
			LineSeg lsBmRegions[0];
			Plane plnBm (bm.ptCenSolid(), bm.vecD(_ZW));
			for (int s = 0; s < lsExternalPlatesRegions.length(); s++)
			{
				LineSeg lsExternalPlatesRegion = lsExternalPlatesRegions[s];
				
				// shadow project points to beams axis
				Point3d ptStartRegion = lsExternalPlatesRegion.ptStart();
				ptStartRegion = Line(ptStartRegion, _ZW).intersect(plnBm, 0);
				Point3d ptEndRegion = lsExternalPlatesRegion.ptEnd();
				ptEndRegion = Line(ptEndRegion, _ZW).intersect(plnBm, 0);
				
				// check if _region is useless for this beam (it's out of scope)
				if ((vecXBm.dotProduct(ptStartRegion - ptStartBm) < 0 && vecXBm.dotProduct(ptEndRegion - ptStartBm) < 0) ||
					(vecXBm.dotProduct(ptStartRegion - ptEndBm) > 0 && vecXBm.dotProduct(ptEndRegion - ptEndBm) > 0))
				continue;
				
				//find new start
				Point3d ptStartNew;
				if (vecXBm.dotProduct(ptStartBm - ptStartRegion) < 0)
				{
					ptStartNew = ptStartRegion;
				}
				else
				{
					ptStartNew = ptStartBm;
				}
				
				// find new end
				Point3d ptEndNew;
				if (vecXBm.dotProduct(ptEndBm - ptEndRegion) < 0)
				{
					ptEndNew = ptEndBm;
				}
				else
				{
					ptEndNew = ptEndRegion;
				}
				ptStartRegion.vis(); ptEndRegion.vis();
				
				lsBmRegions.append(LineSeg(ptStartNew, ptEndNew));
				LineSeg(ptStartNew, ptEndNew).vis(s);
			}//next s
			
			Point3d ptSplit;
			double dDistance;
			int iSameStud;
			int iPointFound;
			for (int r = 0; r < lsBmRegions.length(); r++)
			{
				Point3d ptMid;
				if (r == 0)
				{
					ptMid = LineSeg(ptStartBm, lsBmRegions[r].ptStart()).ptMid();
				}
				else
				{
					ptMid = LineSeg(lsBmRegions[r - 1].ptEnd(), lsBmRegions[r].ptStart()).ptMid();
				}
				
				// check if ptMid same as an existing ptSplit of internal plates
				int iSamePoint;
				for (int ipt=0;ipt<ptSplitsInternalPlates.length();ipt++) 
				{ 
					double dDist=abs(vecX.dotProduct(ptSplitsInternalPlates[ipt]-ptMid)); 
					if(dDist<U(5))
					{ 
						if (r == 0)
						{
							ptMid = ptStartBm;
						}
						else
						{
							ptMid = lsBmRegions[r - 1].ptEnd();
						}
						break;
					}
				}//next ipt
				
				
				dDistance = abs(vecXBm.dotProduct(ptMid - ptStartBm));
				
				// check if start of beam and ptmid are at the same stud
				int iSameStudI = false;
				{ 
					PlaneProfile pp(Plane(ptStartBm, vecZ));
					PlaneProfile ppStartBm(pp.coordSys());
					PlaneProfile ppPtMid(pp.coordSys());
					PLine plStartBm;
					plStartBm.createRectangle(LineSeg(ptStartBm-U(1)*vecX-U(1000)*vecY,
						ptStartBm + U(1) * vecX + U(1000) * vecY), vecX, vecY);
					ppStartBm.joinRing(plStartBm, _kAdd);
					PLine plPtMid;
					plPtMid.createRectangle(LineSeg(ptMid-U(1)*vecX-U(1000)*vecY,
						ptMid + U(1) * vecX + U(1000) * vecY), vecX, vecY);
					ppPtMid.joinRing(plPtMid, _kAdd);
					PlaneProfile ppStud(pp.coordSys());
					for (int ist=0;ist<arBmValidStuds.length();ist++) 
					{ 
						PlaneProfile ppStudI=arBmValidStuds[ist].envelopeBody().shadowProfile(
							Plane(ptStartBm, vecZ));
						PlaneProfile ppIntersectStartBm = ppStartBm;
						PlaneProfile ppIntersectPtMid = ppPtMid;
						if(ppIntersectStartBm.intersectWith(ppStudI) && 
							ppIntersectPtMid.intersectWith(ppStudI))
						{ 
							iSameStudI = true;
							break;
						}
					}//next ist
					
				}
				if (iSameStudI)continue;
				if (dDistance > dMaxLength && !iSameStudI && iPointFound)
					break;
				
				iPointFound = true;
				iSameStud = iSameStudI;
				ptSplit = ptMid;
				
			}//next r
			if(iSameStud || !iPointFound)
			{
				// next plate, this one not valid
				continue
			}
			int iVBPs, iVTPs, iLongBeams;
			if(bmVBPs.find(bm)>-1)
			{ 
				iVBPs=true;
				ptSplitsVBPs.append(ptSplit);
			}
			else if(bmVTPs.find(bm)>-1)
			{ 
				iVTPs=true;
				ptSplitsVTPs.append(ptSplit);
				
			}
			else if(bmLongBeams.find(bm)>-1)
			{ 
				iLongBeams=true;
				ptSplitsLongBeams.append(ptSplit);
			}
			ptSplit.vis(2);
			ptSplitsExternal.append(ptSplit);
			//
			if (bSplitPlates)
			{
				//
				Beam bmNew = bm.dbSplit(ptSplit, ptSplit); 
				if(bmNew.dL() > U(1))
					bmExternalPlates.append(bmNew);
				
				if (bPlateIsAtTop)
				{
					bmVTPs.append(bmNew);
				}
				else
				{
					bmVBPs.append(bmNew);
				}
				
				b = - 1;
			}
			
			nBreakCount++;
			if(nBreakCount == 100)
				break;				
		}//next b
		//endregion split external plates
		
		// check if points close to each other and load manual preview
		int iManual;
		for (int ipt=0;ipt<ptSplitsBottom.length();ipt++) 
		{ 
			Point3d ptI = ptSplitsBottom[ipt];
			for (int jpt=0;jpt<ptSplitsTop.length();jpt++) 
			{ 
				Point3d ptJ = ptSplitsTop[jpt]; 
				if(abs(vecX.dotProduct(ptI-ptJ))<U(1800))
				{ 
					iManual = true;
					break;
				}
			}//next jpt
			if (iManual)break;
		}//next ipt
		if(!iManual)
		{ 
			// check very bottom with bottom plates
			for (int ipt=0;ipt<ptSplitsVBPs.length();ipt++) 
			{ 
				Point3d ptI = ptSplitsVBPs[ipt];
				for (int jpt=0;jpt<ptSplitsBottom.length();jpt++) 
				{ 
					Point3d ptJ = ptSplitsBottom[jpt]; 
					if(abs(vecX.dotProduct(ptI-ptJ))<U(1800))
					{ 
						iManual = true;
						break;
					}
				}//next jpt
				if (iManual)break;
			}//next ipt
		}
		if(!iManual)
		{ 
			// check very top with top plates
			for (int ipt=0;ipt<ptSplitsVTPs.length();ipt++) 
			{ 
				Point3d ptI = ptSplitsVTPs[ipt];
				for (int jpt=0;jpt<ptSplitsTop.length();jpt++) 
				{ 
					Point3d ptJ = ptSplitsTop[jpt]; 
					if(abs(vecX.dotProduct(ptI-ptJ))<U(1800))
					{ 
						iManual = true;
						break;
					}
				}//next jpt
				if (iManual)break;
			}//next ipt
		}
		// 
		if(iManual)
		{ 
			// manual positioning is required
			_Map.setPoint3dArray("ptSplitsBottom", ptSplitsBottom);
			_Map.setPoint3dArray("ptSplitsTop", ptSplitsTop);
			_Map.setPoint3dArray("ptSplitsInternal", ptSplitsInternal);
			//
			_Map.setPoint3dArray("ptSplitsVBPs", ptSplitsVBPs);
			_Map.setPoint3dArray("ptSplitsVTPs", ptSplitsVTPs);
			_Map.setPoint3dArray("ptSplitsLongBeams", ptSplitsLongBeams);
			_Map.setPoint3dArray("ptSplitsExternal", ptSplitsExternal);
			_Map.setInt("ManualSplit",iManual);
		}
	}// (iFirstTime)
	
	if(iManualSplit)
	{ 
		// if solution of TSL can not be accepted, then this preview is display
		// to allow customer to define the splitting points
		Point3d _ptSplitsInternal[] = _Map.getPoint3dArray("ptSplitsInternal");
		Point3d _ptSplitsExternal[] = _Map.getPoint3dArray("ptSplitsExternal");
		Point3d _ptsAll[0];
		_ptsAll.append(_ptSplitsInternal);
		_ptsAll.append(_ptSplitsExternal);
		for (int ipt=0;ipt<_ptSplitsInternal.length();ipt++) 
		{ 
			_ptSplitsInternal[ipt].vis(1); 
			 
		}//next ipt
		if(_PtG.length()==0)
		{ 
			_PtG.append(_ptSplitsInternal);
			_PtG.append(_ptSplitsExternal);
		}
		
		for (int ipt=0;ipt<_PtG.length();ipt++) 
		{ 
			Line lnI(_ptsAll[ipt], vecX);
			_PtG[ipt]=lnI.closestPointTo(_PtG[ipt]);
		}//next ipt
		for (int ipt=0;ipt<_PtG.length();ipt++) 
		{ 
			String sNameI = "_PtG" + ipt;
			addRecalcTrigger(_kGripPointDrag, sNameI);
			if(_kNameLastChangedProp==sNameI)
			{ 
				for (int jpt=0;jpt<_PtG.length();jpt++) 
				{ 
					if (ipt == jpt)continue;
					if(abs(vecX.dotProduct(_PtG[ipt]-_PtG[jpt]))<dEps)
					{ 
						_PtG[ipt] += vecX*U(10);
					}
				}//next jpt
				
				break;
			}
		}//next ipt
		
		Display dp(6);
		for (int ipt=0;ipt<_PtG.length();ipt++) 
		{ 
			PlaneProfile ppFront(Plane(_PtG[ipt], vecZ));
			ppFront.createRectangle(LineSeg(_PtG[ipt]-vecX*U(10)-vecY*U(15),
				_PtG[ipt]+vecX*U(10)+vecY*U(15)),vecX,vecY);
			dp.draw(ppFront, _kDrawFilled);
		}//next ipt
		
	//region Trigger AcceptSolution
		String sTriggerAcceptSolution = T("|Accept Solution|");
		addRecalcTrigger(_kContextRoot, sTriggerAcceptSolution );
		if (_bOnRecalc && _kExecuteKey==sTriggerAcceptSolution)
		{
			
			_Map.setInt("ManualSplit", false);
			setExecutionLoops(2);
			return;
		}//endregion
		
		return;
	}
	
	// either the splitting points are defined manually or the TSL
	// suggestion is correct and no manual editing was needed
//	return
	Point3d ptSplitsAll[0];
	for (int b = 0; b < bmInternalPlates.length(); b++)
	{
		Beam bm = bmInternalPlates[b];
		
		if (bm.dL() <= dMaxLength) continue;
		
		int bPlateIsAtTop = false;
		if (_ZW.dotProduct(bm.ptCenSolid() - ptCenterEl) > 0)
			bPlateIsAtTop = true;
		
		Vector3d vecXBm = bm.vecX();
		if (vecXBm.dotProduct(vecX) < 0)
			vecXBm *= -1; //always from left to right
		
		LineSeg lsInternalPlatesRegions[0];
		lsInternalPlatesRegions.append(lsNoSplitRegions);
		if (bPlateIsAtTop && nSplitLocation == 1) //opposite split locations
		{
			vecXBm *= -1;
			lsInternalPlatesRegions.setLength(0);
			lsInternalPlatesRegions.append(lsNoSplitInvertedRegions);
		}
		
		Point3d pts[] = bm.realBody().extremeVertices(vecXBm);
		if (pts.length() == 0) continue;
		
		Point3d ptStartBm = pts[0], ptEndBm = pts[pts.length() - 1]; //left and right from beam sorted from left to right of element
		ptStartBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptStartBm - bm.ptCenSolid());
		ptEndBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptEndBm - bm.ptCenSolid());
		
		if (bDebug)
		{
			//			bm.realBody().vis(1);
			//			ptStartBm.vis(); ptEndBm.vis();
			//			vecXBm.vis(bm.ptCen());
		}
		
		// shadow project segments on beam
		LineSeg lsBmRegions[0];
		Plane plnBm (bm.ptCenSolid(), bm.vecD(_ZW));
		for (int s = 0; s < lsInternalPlatesRegions.length(); s++)
		{
			LineSeg lsInternalPlatesRegion = lsInternalPlatesRegions[s];
			
			// shadow project points to beams axis
			Point3d ptStartRegion = lsInternalPlatesRegion.ptStart();
			ptStartRegion = Line(ptStartRegion, _ZW).intersect(plnBm, 0);
			Point3d ptEndRegion = lsInternalPlatesRegion.ptEnd();
			ptEndRegion = Line(ptEndRegion, _ZW).intersect(plnBm, 0);
			
			// check if _region is useless for this beam (it's out of scope)
			if ((vecXBm.dotProduct(ptStartRegion - ptStartBm) < 0 && vecXBm.dotProduct(ptEndRegion - ptStartBm) < 0) ||
				(vecXBm.dotProduct(ptStartRegion - ptEndBm) > 0 && vecXBm.dotProduct(ptEndRegion - ptEndBm) > 0))
			continue;
			
			//find new start
			Point3d ptStartNew;
			if (vecXBm.dotProduct(ptStartBm - ptStartRegion) < 0)
			{
				ptStartNew = ptStartRegion;
			}
			else
			{
				ptStartNew = ptStartBm;
			}
			
			// find new end
			Point3d ptEndNew;
			if (vecXBm.dotProduct(ptEndBm - ptEndRegion) < 0)
			{
				ptEndNew = ptEndBm;
			}
			else
			{
				ptEndNew = ptEndRegion;
			}
			//ptStartRegion.vis(); ptEndRegion.vis();
			
			lsBmRegions.append(LineSeg(ptStartNew, ptEndNew));
			LineSeg(ptStartNew, ptEndNew).vis(s);
		}//next s
		
		Point3d ptSplit;
		double dDistance;
		for (int r = 0; r < lsBmRegions.length(); r++)
		{
			Point3d ptMid;
			if (r == 0)
			{
				ptMid = LineSeg(ptStartBm, lsBmRegions[r].ptStart()).ptMid();
			}
			else
			{
				ptMid = LineSeg(lsBmRegions[r - 1].ptEnd(), lsBmRegions[r].ptStart()).ptMid();
			}
			
			dDistance = abs(vecXBm.dotProduct(ptMid - ptStartBm));
			if (dDistance > dMaxLength)
				break;
			
			ptSplit = ptMid;
		}//next r
		
		
		ptSplit.vis(1);
		ptSplitsAll.append(ptSplit);
		if(_PtG.length()>0)
		{ 
			ptSplit=_PtG[ptSplitsAll.length()-1];
		}
		// HSB-15525
		if(bPlateIsAtTop)
		{ 
			ptSplitsTop.append(ptSplit);
		}
		else if(!bPlateIsAtTop)
		{ 
			ptSplitsBottom.append(ptSplit);
		}
		// 
		ptSplitsInternalPlates.append(ptSplit);
		if (bSplitPlates)
		{
			
			//
			Beam bmNew = bm.dbSplit(ptSplit, ptSplit);
			if(bmNew.dL() > U(1))
				bmInternalPlates.append(bmNew);
			if (bPlateIsAtTop)
			{
				bmTPs.append(bmNew);
			}
			else
			{
				bmBPs.append(bmNew);
			}
			
			b = - 1;
		}
		
		// create splice blocks
		if (nSpliceBlocks && !bDebug)
		{
			Line ln(bm.ptCen(), bm.vecX());
			Point3d ptSplice = ln.closestPointTo(ptSplit);
			double dBmWidth = bm.dD(vecY);
			double dBmHeight = bm.dD(vecZ);
			
			if (bPlateIsAtTop)
				ptSplice.transformBy(bm.vecD(_ZW) * - dBmWidth);
			else
				ptSplice.transformBy(bm.vecD(_ZW) * dBmWidth);
			
			Beam bmSplice;
			bmSplice.dbCreate(ptSplice, bm.vecX(), bm.vecY(), bm.vecZ(), U(50), bm.dW(), bm.dH(), 0, 0, 0);
			bmSplice.setColor(bm.color());
			bmSplice.setMaterial(bm.material());
			bmSplice.setGrade(bm.grade());
			bmSplice.setName(sSpliceBlock);
			bmSplice.setType(_kBlocking);
			bmSplice.assignToElementGroup(el, true, 0, 'E');
			
			Beam bmAux[0];
			bmAux = Beam().filterBeamsHalfLineIntersectSort(bmVerticals, ptSplice, bm.vecX());
			if (bmAux.length() > 0)
				bmSplice.stretchStaticTo(bmAux[0], TRUE);
			
			bmAux.setLength(0);
			bmAux = Beam().filterBeamsHalfLineIntersectSort(bmVerticals, ptSplice, - bm.vecX());
			if (bmAux.length() > 0)
				bmSplice.stretchStaticTo(bmAux[0], TRUE);
		}
		
		nBreakCount++;
		if(nBreakCount == 100)
			break;
	}//next b
	//endregion split internal plates
	
	//region re - define non split regions to non stud regions 
	LineSeg lsNoStudRegions[0];
	if (nSplitExternalsOnStud)
	{
		//collect all zones that are not stud
		for ( int i = 0; i < arBmValidStuds.length(); i++) {
			Beam bm = arBmValidStuds[i];
			if (i == 0)
			{
				lsNoStudRegions.append(LineSeg(ptOrg, bm.ptCen() - vecX * bm.dD(vecX) * .5 ));
			}
			else if (i == arBmValidStuds.length() - 1)
			{
				lsNoStudRegions.append(LineSeg(arBmValidStuds[i - 1].ptCen() + vecX * arBmValidStuds[i - 1].dD(vecX) * .5, bm.ptCen() - vecX * bm.dD(vecX) * .5));
				lsNoStudRegions.append(LineSeg(bm.ptCen() + vecX * bm.dD(vecX) * .5, ptOrg + vecX * dLengthEl));
			}
			else
			{
				lsNoStudRegions.append(LineSeg(arBmValidStuds[i - 1].ptCen() + vecX * arBmValidStuds[i - 1].dD(vecX) * .5, bm.ptCen() - vecX * bm.dD(vecX) * .5));
			}
		}
		
		//alignt regions
		Point3d ptAlign = ptOrg - _ZW * U(250);
		LineSeg lsTmp[0];
		for (int t = 0; t < lsNoStudRegions.length(); t++)
		{
			Point3d ptStart = lsNoStudRegions[t].ptStart();
			ptStart.setZ(ptAlign.Z());
			Point3d ptEnd = lsNoStudRegions[t].ptEnd();
			ptEnd.setZ(ptAlign.Z());
			lsTmp.append(LineSeg(ptStart, ptEnd));
		}//next t
		lsNoStudRegions = lsTmp;
		
		lsNoSplitRegions.setLength(0);
		lsNoSplitRegions.append(lsNoStudRegions);
		lsNoSplitInvertedRegions.setLength(0);
		for (int s = lsNoSplitRegions.length() - 1; s >= 0; s--)
		{
			lsNoSplitInvertedRegions.append(LineSeg(lsNoSplitRegions[s].ptEnd(), lsNoSplitRegions[s].ptStart()));
		}//next s
	}
	
	for (int t = 0; t < lsNoStudRegions.length(); t++)
	{
		lsNoStudRegions[t].vis(2);
		
	}//next t
	//endregion re - define non split regions to non stud regions
	
//	return
	//region split external plates (very top/bottoms)
	Beam bmExternalPlates [0];
	// VeryBottomPlates, VeryTopPlates
	bmExternalPlates.append(bmVBPs);
	bmExternalPlates.append(bmVTPs);
	bmExternalPlates.append(bmLongBeams);
	nBreakCount = 0;
	
	
	for (int b = 0; b < bmExternalPlates.length(); b++)
	{
		Beam bm = bmExternalPlates[b];
		if (bm.dL() <= dMaxLength) continue;
		
		int bPlateIsAtTop = false;
		if (_ZW.dotProduct(bm.ptCenSolid() - ptCenterEl) > 0)
			bPlateIsAtTop = true;
		
		Vector3d vecXBm = bm.vecX();
		if (vecXBm.dotProduct(vecX) > 0)
			vecXBm *= -1; //always from right to left (opposite to internal plates)
		
		LineSeg lsExternalPlatesRegions[0];
		lsExternalPlatesRegions.append(lsNoSplitInvertedRegions);
		if (bPlateIsAtTop && nSplitLocation == 1) //opposite split locations
		{
			vecXBm *= -1;
			lsExternalPlatesRegions.setLength(0);
			lsExternalPlatesRegions.append(lsNoSplitRegions);
		}
		
		Point3d pts[] = bm.realBody().extremeVertices(vecXBm);
		if (pts.length() == 0) continue;
		
		Point3d ptStartBm = pts[0], ptEndBm = pts[pts.length() - 1]; //left and right from beam sorted from left to right of element
		ptStartBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptStartBm - bm.ptCenSolid());
		ptEndBm = bm.ptCenSolid() + vecXBm * vecXBm.dotProduct(ptEndBm - bm.ptCenSolid());
		
		if (bDebug)
		{
			//			bm.realBody().vis(2);
						ptStartBm.vis(); ptEndBm.vis();
			//			vecXBm.vis(bm.ptCen());
		}
		
		// shadow project segments on beam
		LineSeg lsBmRegions[0];
		Plane plnBm (bm.ptCenSolid(), bm.vecD(_ZW));
		for (int s = 0; s < lsExternalPlatesRegions.length(); s++)
		{
			LineSeg lsExternalPlatesRegion = lsExternalPlatesRegions[s];
			
			// shadow project points to beams axis
			Point3d ptStartRegion = lsExternalPlatesRegion.ptStart();
			ptStartRegion = Line(ptStartRegion, _ZW).intersect(plnBm, 0);
			Point3d ptEndRegion = lsExternalPlatesRegion.ptEnd();
			ptEndRegion = Line(ptEndRegion, _ZW).intersect(plnBm, 0);
			
			// check if _region is useless for this beam (it's out of scope)
			if ((vecXBm.dotProduct(ptStartRegion - ptStartBm) < 0 && vecXBm.dotProduct(ptEndRegion - ptStartBm) < 0) ||
				(vecXBm.dotProduct(ptStartRegion - ptEndBm) > 0 && vecXBm.dotProduct(ptEndRegion - ptEndBm) > 0))
			continue;
			
			//find new start
			Point3d ptStartNew;
			if (vecXBm.dotProduct(ptStartBm - ptStartRegion) < 0)
			{
				ptStartNew = ptStartRegion;
			}
			else
			{
				ptStartNew = ptStartBm;
			}
			
			// find new end
			Point3d ptEndNew;
			if (vecXBm.dotProduct(ptEndBm - ptEndRegion) < 0)
			{
				ptEndNew = ptEndBm;
			}
			else
			{
				ptEndNew = ptEndRegion;
			}
			ptStartRegion.vis(); ptEndRegion.vis();
			
			lsBmRegions.append(LineSeg(ptStartNew, ptEndNew));
			LineSeg(ptStartNew, ptEndNew).vis(s);
		}//next s
		
		Point3d ptSplit;
		double dDistance;
		int iSameStud;
		int iPointFound;
		for (int r = 0; r < lsBmRegions.length(); r++)
		{
			Point3d ptMid;
			if (r == 0)
			{
				ptMid = LineSeg(ptStartBm, lsBmRegions[r].ptStart()).ptMid();
			}
			else
			{
				ptMid = LineSeg(lsBmRegions[r - 1].ptEnd(), lsBmRegions[r].ptStart()).ptMid();
			}
			
			// check if ptMid same as an existing ptSplit of internal plates
			int iSamePoint;
			for (int ipt=0;ipt<ptSplitsInternalPlates.length();ipt++) 
			{ 
				double dDist=abs(vecX.dotProduct(ptSplitsInternalPlates[ipt]-ptMid)); 
				if(dDist<U(5))
				{ 
					if (r == 0)
					{
						ptMid = ptStartBm;
					}
					else
					{
						ptMid = lsBmRegions[r - 1].ptEnd();
					}
					break;
				}
			}//next ipt
			
			
			dDistance = abs(vecXBm.dotProduct(ptMid - ptStartBm));
			
			// check if start of beam and ptmid are at the same stud
			int iSameStudI = false;
			{ 
				PlaneProfile pp(Plane(ptStartBm, vecZ));
				PlaneProfile ppStartBm(pp.coordSys());
				PlaneProfile ppPtMid(pp.coordSys());
				PLine plStartBm;
				plStartBm.createRectangle(LineSeg(ptStartBm-U(1)*vecX-U(1000)*vecY,
					ptStartBm + U(1) * vecX + U(1000) * vecY), vecX, vecY);
				ppStartBm.joinRing(plStartBm, _kAdd);
				PLine plPtMid;
				plPtMid.createRectangle(LineSeg(ptMid-U(1)*vecX-U(1000)*vecY,
					ptMid + U(1) * vecX + U(1000) * vecY), vecX, vecY);
				ppPtMid.joinRing(plPtMid, _kAdd);
				PlaneProfile ppStud(pp.coordSys());
				for (int ist=0;ist<arBmValidStuds.length();ist++) 
				{ 
					PlaneProfile ppStudI=arBmValidStuds[ist].envelopeBody().shadowProfile(
						Plane(ptStartBm, vecZ));
					PlaneProfile ppIntersectStartBm = ppStartBm;
					PlaneProfile ppIntersectPtMid = ppPtMid;
					if(ppIntersectStartBm.intersectWith(ppStudI) && 
						ppIntersectPtMid.intersectWith(ppStudI))
					{ 
						iSameStudI = true;
						break;
					}
				}//next ist
			}
			if (iSameStudI)continue;
			if (dDistance > dMaxLength && !iSameStudI && iPointFound)
				break;
			
			iPointFound = true;
			iSameStud = iSameStudI;
			ptSplit = ptMid;
			
			
		}//next r
		if(iSameStud || !iPointFound)
		{
			// next plate, this one not valid
			continue
		}
		
		int iVBPs, iVTPs, iLongBeams;
		if(bmVBPs.find(bm)>-1)
		{ 
			iVBPs=true;
			ptSplitsVBPs.append(ptSplit);
		}
		else if(bmVTPs.find(bm)>-1)
		{ 
			iVTPs=true;
			ptSplitsVTPs.append(ptSplit);
			
		}
		else if(bmLongBeams.find(bm)>-1)
		{ 
			iLongBeams=true;
			ptSplitsLongBeams.append(ptSplit);
		}
		ptSplit.vis(2);
		ptSplitsAll.append(ptSplit);
		if(_PtG.length()>0)
		{ 
			ptSplit=_PtG[ptSplitsAll.length()-1];
		}
		if (bSplitPlates)
		{
			Beam bmNew = bm.dbSplit(ptSplit, ptSplit); 
			if(bmNew.dL() > U(1))
				bmExternalPlates.append(bmNew);
			
			if (bPlateIsAtTop)
			{
				bmVTPs.append(bmNew);
			}
			else
			{
				bmVBPs.append(bmNew);
			}
			
			b = - 1;
		}
		
		nBreakCount++;
		if(nBreakCount == 100)
			break;				
	}//next b
	//endregion split external plates	
	
	//	//region complete beam code
	String sBeamLabels[] ={ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P","Q","R","S","T","U","V","W","X","Y","Z"};
	
	bmBottomAndVeryBottomPlates.setLength(0);
	bmBottomAndVeryBottomPlates.append(bmBPs);
	bmBottomAndVeryBottomPlates.append(bmVBPs);
	bmBottomAndVeryBottomPlates.append(bmTPs);
	bmBottomAndVeryBottomPlates.append(bmVTPs);
	bmBottomAndVeryBottomPlates.append(bmLongBeams);

	for (int c = 0; c < sRowCodes.length(); c++)
	{
		String sCode = sRowCodes[c];
		Beam bmCurrentRow[0];
		for (int b = 0; b < bmBottomAndVeryBottomPlates.length(); b++)
		{
			Beam bm = bmBottomAndVeryBottomPlates[b];
			if (bm.beamCode() == sCode)
			{
				bmCurrentRow.append(bm);
			}
		}//next b
		
		if (bmCurrentRow.length() == 0)
			continue;
			
		Point3d pt = bmCurrentRow[0].ptCen();
		pt += vecX * vecX.dotProduct(ptOrg - bmCurrentRow[0].ptCen());
		
		bmCurrentRow = Beam().filterBeamsHalfLineIntersectSort(bmCurrentRow, pt, vecX);
		for (int b = 0; b < bmCurrentRow.length(); b++)
		{
			Beam bm = bmCurrentRow[b];

			int n = (nSetBeamCode == 2) ? bmCurrentRow.length() - 1 - b : b;
			
			if(n < 26)
			{
				bm.setBeamCode(bm.beamCode() + "-" + sBeamLabels[n]);	
				
				if(nAddBeamCodeToLable)
				{
					bm.setLabel(sBeamLabels[n] );
				}
			}
			else
			{
				// HSB-12788: if nr of beams > 50
				int iMultiple = n / 25;
				String sL;
				for (int iCount=0;iCount<iMultiple;iCount++) 
				{ 
					sL += sBeamLabels[25];
				}//next iCount
				
				sL += sBeamLabels[n - iMultiple*25];
				bm.setBeamCode(bm.beamCode() + "-" + sL);	
				
				if(nAddBeamCodeToLable)
				{
					bm.setLabel(sL);
				}
			}
		}//next b
	}//next c
	
	//endregion complete beam code
	if (bDebug)
	{
		for (int b = 0; b < bmBPs.length(); b++)
		{
			Beam bm = bmBPs[b];
			bm.envelopeBody().vis(1);
			
		}//next index
		
		for (int b = 0; b < bmTPs.length(); b++)
		{
			Beam bm = bmTPs[b];
			bm.envelopeBody().vis(1);
			
		}//next index
		
		for (int b = 0; b < bmVTPs.length(); b++)
		{
			Beam bm = bmVTPs[b];
			bm.envelopeBody().vis(2);
		}//next index
		
		for (int b = 0; b < bmVBPs.length(); b++)
		{
			Beam bm = bmVBPs[b];
			bm.envelopeBody().vis(2);
			
		}//next index
	}
	
	if ( ! nPreview && !_bOnDbCreated)
	{
		eraseInstance();
		return;
	}
}



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``,"`@,"`@,#`P,$`P,$!0@%!00$
M!0H'!P8(#`H,#`L*"PL-#A(0#0X1#@L+$!80$1,4%145#`\7&!84&!(4%13_
MVP!#`0,$!`4$!0D%!0D4#0L-%!04%!04%!04%!04%!04%!04%!04%!04%!04
M%!04%!04%!04%!04%!04%!04%!04%!3_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#]4Z***`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`**R]6\4:1H=]IECJ&I6UG>:G,;>
MRMYI0LES(%+%47JQ"@DXZ`5J4"N%%%%`PHHHH`***R]%\3Z1XBFU&+2M2M=1
M?3[@VEV+642>1,%#&-B.C`,N1U&:!7-2BBB@84444`%%%%`!1110`4444`%%
M,FF2WB>25UCC0;F=S@`#J2:CLKV#4K2&ZM95GMYE#QRH<JRGH0?2@">BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBO'OVA_C9%\,M!.GZ?*K>([Y#Y*CG[.AX,I]^NT>H)[5R8K%4L'1E7K.R7]6
M/0P&!KYEB887#J\I?U=^2ZE/XK?M0Z3\.?$$FBVFGG6KR%?W[+/Y:1/_`'/N
MG)'?TZ=<X\KUK]N74[&SFN5T'3[.*,$L\\KR`>G3;DU\_0PWFO:HL4227E]=
M2X"C+/([']22:\@^+6H:G;^)[[0+ZVDT\Z7.T$MM)PQD4X)/]/;GO7YC#.,S
MS"LW3GR0OT2T\KVW/Z#PO"&2X6G&E5IJ=2VK;>O=VO:US]0_V8/C@_QZ^'+Z
M[=0V]KJ5O>2VMS;V^0JXPR'!)/*,O?J#7H?CC6)_#O@O7]5M0ANK'3[BZB$@
MRN](V9<CTR!7P%_P3=^(7]C?$36_"<\I$&LVHG@4GCSH<G`'NC/_`-\"ON_X
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
@Z"\%Z3/H/A'1M-NMOVFTM(X9/+.5W*H!P?2MJB@#_]D`

















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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15525: add display and grip points to manually define the splitting points" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="5/24/2022 3:41:31 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13696: Add blocking to the list of beams that can be split" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="11/10/2021 3:35:55 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12788: fix bug when splitting at studs; fix bug when setting the beamcode; avoid same splitting point for two close beams" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="9/20/2021 7:39:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12788: new property &quot;side of clear space of stud&quot; with 3 options {&quot;both&quot;,&quot;left&quot;,right&quot;}" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/17/2021 10:03:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11223 Bugfix inaccuracy of searchpoint" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/17/2021 9:03:28 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End