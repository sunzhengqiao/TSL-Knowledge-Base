#Version 8
#BeginDescription
#Versions: 
Version 1.22 29/04/2025 HSB-23959: If rafter and blocking is not normal, then do the tooling as block-hiprafter , Author Marsel Nakuci
1.21 28/08/2024 HSB-22591: Expose Kerve properties gapX,gapY on insert Marsel Nakuci
1.20 13.06.2023 HSB-19192: Allow tooling at hip rafter 
1.19 21.03.2023 HSB-18370: Apply beamcut only if depth > dEps 
HSB-7473: delete tsl if disabled is selected at properties of hsbBlocking-Kerve
HSB-7473: avoid groove at hip rafter,add kerve also when wall not generated
HSB-7332: add hsbBlocking-Kerve, add tooling at gratsparren, keep only 1 element when multiple colinear
language independency enhanced

added safety check for plumb conditions 


roofplane detection enhanced when beam belongs to more than one roofplane
added option to influenca alignment when reference object = beam
bugfix blocking alignment
added option to change bottom gap reference
possibility for conic shaped groove added, offset is now calculated horizontally, even for aligned blockings
tooling added, if blocking has bigger offset to plate
added support for rising plates
supports external SF settings file and forces outside direction of wall based insertions accordingly 
sheet stretching further enhanced

DACH
Dieses TSL erzeugt Stellbretter in Abhängigkeit von Wänden oder Pfetten, sowie Stellbrettnuten in den gewählten Sparren

EN
This tsl creates blockings in dependency of walls or plates and selected rafters as well as blocking grooves






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 22
#KeyWords Blocking;Roof;Wall;Abbund
#BeginContents
/// <summary Lang=en>
/// This tsl creates blockings in dependency of walls or plates and selected rafters as well as blocking grooves
/// </summary>

/// <summary Lang=de>
/// Dieses TSL erzeugt Stellbretter in Abhängigkeit von Wänden oder Pfetten, sowie Stellbrettnuten in den gewählten Sparren
/// </summary>

/// <insert Lang=en>
/// Select one or multiple walls plates, select rafters
/// The reference plane is dependent from the select object
/// </insert >

/// <insert Lang=de>
/// Wählen Sie als Referenzobjekt(e) eine oder mehrere Wände bzw.  Pfetten und anschließend die gewünschten Sparren
/// Ist das gewählte Referenzobjekt eine Wand, so ist die Außenseite der Wand die Referenzebene für den horizontalen Versatz. 
/// Bei Pfetten ist die Bezugskante die Außenseite der Pfette.
/// </insert >

/// <remark Lang=en>
/// The tsl supports two modes with different OPM names and with a different set of properties
/// </remark>

/// History
/// #Versions:
// 1.22 29/04/2025 HSB-23959: If rafter and blocking is not normal, then do the tooling as block-hiprafter , Author Marsel Nakuci
// 1.21 28/08/2024 HSB-22591: Expose Kerve properties gapX,gapY on insert Marsel Nakuci
// 1.20 13.06.2023 HSB-19192: Allow tooling at hip rafter Author: Marsel Nakuci
// 1.19 21.03.2023 HSB-18370: Apply beamcut only if depth > dEps Author: Marsel Nakuci
///<version value="1.18" date="05mai20" author="marsel.nakuci@hsbcad.com"> HSB-7473: delete tsl if disabled is selected at properties of hsbBlocking-Kerve </version>
///<version value="1.17" date="04mai20" author="marsel.nakuci@hsbcad.com"> HSB-7473: avoid groove at hip rafter,add kerve also when wall not generated </version>
///<version value="1.16" date="22apr20" author="marsel.nakuci@hsbcad.com"> HSB-7332: add hsbBlocking-Kerve, add tooling at gratsparren, keep only 1 element when multiple colinear </version>
///<version value="1.15" date="25jun18" author="thorsten.huck@hsbcad.com"> language independency enhanced </version>
///<version value="1.12" date="19mar18" author="craig.colomb@hsbcad.com"> Updated PlumbHousing for more accurate machining </version>
///<version value="1.11" date="22dec17" author="thorsten.huck@hsbcad.com"> user will be informed if selected wall is of invalid type </version>
///<version value="1.10" date="19oct17" author="florian.wuermseer@hsbcad.com"> roofplane detection enhanced when beam belongs to more than one roofplane</version>
///<version value="1.9" date="24apr17" author="florian.wuermseer@hsbcad.com"> added option to influenca alignment when reference object = beam</version>
///<version value="1.8" date="19jan17" author="florian.wuermseer@hsbcad.com"> bugfix blocking alignment</version>
///<version value="1.7" date="16jan17" author="florian.wuermseer@hsbcad.com"> added option to change bottom gap reference</version>
///<version value="1.6" date="14dec16" author="florian.wuermseer@hsbcad.com"> possibility for conic shaped groove added, offset is now calculated horizontally, even for aligned blockings</version>
///<version value="1.5" date="14dec16" author="florian.wuermseer@hsbcad.com"> tooling added, if blocking has bigger offset to plate</version>
///<version value="1.4" date="10dec15" author="florian.wuermseer@hsbcad.com"> added support for rising plates </version>
///<version value="1.3" date="10dec15" author="thorsten.huck@hsbCAD.de"> supports external SF settings file and forces outside direction of wall based insertions accordingly </version>
///<version value="1.2" date="13oct15" author="thorsten.huck@hsbCAD.de"> sheet stretching further enhanced </version>
///<version value="1.1" date="12oct15" author="thorsten.huck@hsbCAD.de"> outside detection and sheet stretching enhanced </version>
///<version value="1.0" date="23sep15" author="thorsten.huck@hsbCAD.de"> initial </version>

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion
	
	// HSB-7332: allow tooling everywhere 
//	int nNoToolTypes[] = {_kValleyRafter,_kHipRafter};
	int nNoToolTypes[]={};
	int nRafterTypes[]={_kRafter,_kSlopedRafter,_kHiddenRafter,_kValleyRafter,_kHipRafter};
	//_Map.setInt("mode",1);

// declare custom dictionary entry name
	String sDict = "hsbStickframe";
	String sDictEntry = "SFSettings";

// collect custom settings
	String sLoadSettingsTrigger = T("|Load Settings|");
	String sWriteSettingsTrigger= T("|Write Settings|");
	MapObject mo(sDict ,sDictEntry);
	Map mapSettings;
	String sSettingsPath = _kPathHsbWallDetail+"\\SFSettings.xml";
	
// load settings from external file if not stored or loading has been triggered
	if (!mo.bIsValid() || (_bOnRecalc && _kExecuteKey==sLoadSettingsTrigger))
	{
	/// read data from file
		if (mapSettings.length()<1)
			mapSettings.readFromXmlFile(sSettingsPath);
		
	// write to map object
		if (mapSettings.length()>0)
		{
		// update existing
			if (mo.bIsValid())
			{
				mo.setMap(mapSettings);
				Map mapTslSetting = mapSettings.getMap("TslSetting[]");
				if (mapTslSetting.length()>0 )
				{
					reportMessage("\n" + T("|Loading custom settings for the following tsls:|"));
					for (int i=0;i<mapTslSetting.length();i++)
						reportMessage("\n	" + mapTslSetting.getMap(i).getString("ScriptName"));
				}				
			}
		// create new
			else
				mo.dbCreate(mapSettings);
		}
	// erase existing map object
		else if (mo.bIsValid())
		{
			String sRet = getString("\n" + sSettingsPath + " " + T("|could not be found.|") + " " + T("|Do you want to erase the existing custom settings?|") + " " + T("|NOTE: This can change the existing model!|") + 
			" [" + T("|No|")+"/" +T("|Yes|")+"]");
			if (sRet.length()>0 && sRet.left(1).makeUpper() == T("|Yes|").left(1).makeUpper())
			{
				mo.dbErase();
				reportMessage(T("|Custom settings permanently erased from this drawing.|"));	
			}
		}
	// alert user that custom settings could'nt be found
		else if (_bOnRecalc && _kExecuteKey==sLoadSettingsTrigger)
		{
			reportMessage("\n" + sSettingsPath + " " + T("|could not be found.|"));
		}	
	}	
// read settings from map object
	else 
	{
		mapSettings = mo.map();	
	}
	
// get settings of this script
	Map mapThisSettings;
	String sThisScriptName = scriptName();
	if (sThisScriptName=="__HSB__PREVIEW")sThisScriptName="hsbBlocking";
	sThisScriptName.makeUpper();
	for (int i=0;i<mapSettings.length();i++)
	{
		Map mapTslSettings = mapSettings.getMap("TslSetting[]");
		for (int j=0;j<mapTslSettings.length();j++)
		{
			Map mapTslSetting = mapTslSettings.getMap(j);
			String sMapScriptName = mapTslSetting.getString("ScriptName").makeUpper();
			if (sThisScriptName==sMapScriptName)
			{
				mapThisSettings = mapTslSetting;
				break;
			}	
		}
	}// next i
	
	int nMode = _Map.getInt("mode");
	// 0 = distribution mode
	// 1 = tooling mode
	
// distribution mode
if (nMode==0)
{ 	
	if (bDebug)reportMessage("\n"+scriptName() + " starting...");
// geometry
//0
	String sCategoryGeo = T("|Geometry|");
	String sThicknessName= "A - " + T("|Thickness|");
	PropDouble dThickness(nDoubleIndex++, U(32),sThicknessName);
	dThickness.setDescription(T("|Defines the thickness ogf the blocking|"));
	dThickness.setCategory(sCategoryGeo);	
//1
	String sHeightName= "B - " + T("|Height|");
	PropDouble dHeight(nDoubleIndex++, 0,sHeightName);
	dHeight.setDescription(T("|Defines the height of the raw blocking board, that will be cut to the required size|") + " " + T("|0 = Automatic|"));
	dHeight.setCategory(sCategoryGeo);	

//2
// plane offsets
	String sCategoryPlaneOffset = T("|Roofplane offsets|");
	String sGapTopName= "C - " + T("|Top|");
	PropDouble dGapTop(nDoubleIndex++, U(1),sGapTopName);
	dGapTop.setDescription(T("|Defines the perpendicular offset to the roofplane|"));
	dGapTop.setCategory(sCategoryPlaneOffset);	
//3
	String sGapBottomName= "D - " + T("|Bottom|");
	PropDouble dGapBottom(nDoubleIndex++, 0,sGapBottomName);
	dGapBottom.setDescription(T("|Defines the perpendicular offset to the bottom face of the rafter|") + " (" + T("|Only if reference object is a wall|") + ")");
	dGapBottom.setCategory(sCategoryPlaneOffset);
	
	String sReferenceBottomName= "E - " + T("|Bottom offset reference|");
	String sReferenceBottoms[]= {T("|Outside edge of wall|"), T("|Outside edge of blocking beam|")};
	PropString sReferenceBottom(nStringIndex++, sReferenceBottoms,sReferenceBottomName);
	sReferenceBottom.setDescription(T("|Defines if the bottom offset refers to the wall's outside edge or to the blocking beam's bottom edge|"));
	sReferenceBottom.setCategory(sCategoryPlaneOffset);
	int nReferenceBottom = sReferenceBottoms.find(sReferenceBottom, 0);

// alignment
	String sCategoryAlignment = T("|Alignment|");
	
	String sAlignments[] = {T("|perpendicular to WCS|"), T("|perpendicular to roof|")};
	String sAlignmentName= "F - " + T("|Alignment|");
	PropString sAlignment(nStringIndex++,sAlignments,sAlignmentName);
	sAlignment.setDescription(T("|Sets the orientation of the blocking|"));
	sAlignment.setCategory(sCategoryAlignment );	
//4
	String sOffsetName= "G - " + T("|Horizontal Offset Blocking|");
	PropDouble dOffset(nDoubleIndex++, 0,sOffsetName);
	dOffset.setDescription(T("|Defines the offset from the outer side of the reference object|"));
	dOffset.setCategory(sCategoryAlignment);	

//5
// tooling
	String sCategoryGroove = T("|Blocking groove|");	
	String sDepthName= "I - " + T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(6),sDepthName);
	dDepth.setDescription(T("|Defines the depth of groove|"));
	dDepth.setCategory(sCategoryGroove);	
//6
	String sGapDepthName= "J - " + T("|Gap Depth|");
	PropDouble dGapDepth(nDoubleIndex++, U(1),sGapDepthName);
	dGapDepth.setDescription(T("|Defines the gap in depth of groove|"));
	dGapDepth.setCategory(sCategoryGroove);	
//7	
	String sWidthName= "K - " + T("|Width|");
	PropDouble dWidth(nDoubleIndex++, 0,sWidthName);
	dWidth.setDescription(T("|Defines the Width of the groove|") + " " + T("|0 = automatic|"));
	dWidth.setCategory(sCategoryGroove);	
	
	PropString psAddPlumbHousing(7, sNoYes, T("|Expand Groove to Plumb|"));
	psAddPlumbHousing.setCategory(sCategoryGroove);
	int bDoPlumbHousing = psAddPlumbHousing == sNoYes[1];

// properties
	String sCategoryElement = T("|Element|");	
	String sZoneName= "N - " + T("|Sheeting Zone|");
	int nAllZones[] = {-5,-4,-3,-2,-1,0,1,2,3,4,5};
	PropInt nZone(nIntIndex++,nAllZones,sZoneName);
	nZone.setDescription(T("|Specifies the zone to which sheets will be manipulated during insert.|") + " " + T("|0 = automatic detection: any zone below or further outside will be taken.|"));
	nZone.setCategory(sCategoryElement );

// properties
	String sCategoryAttributes = T("|Attributes|");	
	
	String sMaterialName= "P - " + T("|Material|");
	PropString sMaterial(nStringIndex++,T("|Spruce|"),sMaterialName);
	sMaterial.setDescription(T("|Sets the material of the blocking|"));
	sMaterial.setCategory(sCategoryAttributes);	

	String sGradeName= "Q - " + T("|Grade|");
	PropString sGrade(nStringIndex++,"",sGradeName);
	sGrade.setDescription(T("|Sets the grade of the blocking|"));
	sGrade.setCategory(sCategoryAttributes);		

	String sNameName= "R - " + T("|Name|");
	PropString sName(nStringIndex++,T("|Blocking|"),sNameName);
	sName.setDescription(T("|Sets the name of the blocking|"));
	sName.setCategory(sCategoryAttributes);		

	String sColorName= "S - " + T("|Color|");
	PropInt nColor(nIntIndex++,30,sColorName);
	nColor.setDescription(T("|Specifies the color of the blocking|"));
	nColor.setCategory(sCategoryAttributes);	
//8
	String sConicName= "L - " + T("|Conic Groove|");
	PropDouble dConic(nDoubleIndex++, U(0),sConicName);
	dConic.setDescription(T("|Defines the additional depth for a conic shaped groove|"));
	dConic.setCategory(sCategoryGroove );
//9	
	String sConicOffsetName= "M - " + T("|Start height of conic groove|");
	PropDouble dConicOffset(nDoubleIndex++, U(0),sConicOffsetName);
	dConicOffset.setDescription(T("|Defines the bottom offset, where the conic groove starts|"));
	dConicOffset.setCategory(sCategoryGroove);
	
	String sAlignmentDetections[] = { T("|Automatic|"), T("|Ridge|"), T("|Eaves|")};
	String sAlignmentDetectionName= "H - " + T("|Alignment detection|");
	PropString sAlignmentDetection(nStringIndex++, sAlignmentDetections,sAlignmentDetectionName, 0);
	sAlignmentDetection.setDescription(T("|Defines the if the blocking aligment shall be oriented for a ridge or eaves situation.|") + "\n" + T("|'Automatic' means in the lower half of the element, the eaves situation is used, in the top half, the ridge situation is used|") + "\n(" + T("|Only if reference object is a beam|") + ")");
	sAlignmentDetection.setCategory(sCategoryAlignment);	
	int nAlignmentDetection = sAlignmentDetections.find(sAlignmentDetection);

	String sModifySheetingName= "O - " + T("|Modify sheeting zones|");
	PropString sModifySheeting(nStringIndex++, sNoYes,sModifySheetingName, 0);
	sModifySheeting.setDescription(T("|Defines, if the sheeting zones of a wall shall be stretched to the blocking|") + " (" + T("|Only if reference object is a wall|") + ")");
	sModifySheeting.setCategory(sCategoryElement);	
	int bModifySheeting = sNoYes.find(sModifySheeting,0);
	
	// kerve at the choosen zone 
	String sKerveName="O1 - "+T("|Kerve|");	
	String sKerves[] ={ T("<|Disabled|>"), T("|Outer|") +" "+ T("|Zone|"), T("|Inner|") +" "+T("|Zone|"),
									"-5", "-4", "-3", "-2", "-1", "0", "1", "2", "3", "4", "5"};
	PropString sKerve(nStringIndex++, sKerves, sKerveName);	
	sKerve.setDescription(T("|Defines the Kerve|"));
	sKerve.setCategory(sCategoryElement);
	// HSB-22591
	String sGapXName="O1a - "+T("|Gap|")+" X";	
	PropDouble dGapX(11, U(0), sGapXName);	
	dGapX.setDescription(T("|Defines the GapX|"));
	dGapX.setCategory(sCategoryElement);
	// HSB-22591
	String sGapYName="O1b - "+T("|Gap|")+" Y";	
	PropDouble dGapY(12, U(0), sGapYName);	
	dGapY.setDescription(T("|Defines the GapY|"));
	dGapY.setCategory(sCategoryElement);
//10	
	// HSB-7473 fuge between untenkante of Füllholz and the oberkante von Platte
	String sGapSheetName="O2 - "+T("|Gap Sheet|");	
	PropDouble dGapSheet(nDoubleIndex++, U(0), sGapSheetName);
	dGapSheet.setDescription(T("|Defines the Gap between Sheet and blocking|"));
	dGapSheet.setCategory(sCategoryElement);
	
// for negative offsets always refer to the blocking beam
	if (dOffset < -dThickness)
		nReferenceBottom = 1;
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	// a potential catalog entry name and all available entries
		String sEntry = _kExecuteKey;
		String sEntryUpper = sEntry; sEntryUpper.makeUpper();
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		int nEntry = sEntries.find(sEntryUpper);
		
	// selection set
		Entity entsSet[0];
		PrEntity ssE(T("|Select wall(s) or plate(s)|"), ElementWall());	
		ssE.addAllowedClass(GenBeam());
		while(entsSet.length()<1)
		{ 
			if (ssE.go())
			{
				entsSet= ssE.set();	
			// remove pure walls
				for (int i=entsSet.length()-1; i>=0 ; i--) 
				{ 
					if (!entsSet[i].bIsKindOf(ElementWall()) && entsSet[i].bIsKindOf(Wall()))
					{ 
						reportMessage(TN("|Walls without hsbcad data are not supported.|"));
						entsSet.removeAt(i);
					}
				}
				// HSB-7332 remove walls that are parallel, same direction
				for (int i=entsSet.length()-1; i>=0 ; i--) 
				{ 
					ElementWall eI = (ElementWall) entsSet[i];
					if(!eI.bIsValid())
						continue;
					Vector3d vecXi = eI.vecX();
					Vector3d vecZi = eI.vecZ();
					Point3d ptOrgi = eI.ptOrg();
					for (int j=entsSet.length()-1; j>=0 ; j--) 
					{ 
						ElementWall eJ = (ElementWall) entsSet[j];
						if(!eJ.bIsValid())
							continue;
							
						if(eI==eJ)
							continue;
						Vector3d vecXj = eJ.vecX();
						Vector3d vecZj = eJ.vecZ();
						Point3d ptOrgj = eJ.ptOrg();
						if(!vecXi.isParallelTo(vecXj))
						{ 
							// not parallel, OK
							continue;
						}
						// are parallel
						if(abs(vecZi.dotProduct(vecZj)-1)>dEps)
						{ 
							// not same side, OK
							continue;
						}
						// are parallel and same side
						if(abs(vecZi.dotProduct(ptOrgi-ptOrgj))>dEps)
						{ 
							// different locations
							continue;
						}
						// parallel, same side, same location, remove ei
						entsSet.removeAt(i);
						break;
					}//next j
				}//next i
			}
			else
				break;
		}
		
		if(bDebug)reportMessage("\n"+ scriptName() +" " +entsSet.length() + " entities selected");
		
	// cast sset
		Entity entRefs[0];
		int bWallSelected;
		GenBeam gbsElement[0];
		for (int e=0;e<entsSet.length();e++)
		{
			Entity ent = entsSet[e];
			if(bDebug)reportMessage("\n"+ scriptName() +" e " +e + " " + ent.typeDxfName()  + " is ElementWall:" +ent.bIsKindOf(ElementWall()) + " is Wall" +ent.bIsKindOf(Wall()) );
			if (ent.bIsKindOf(ElementWall()))
			{
				ElementWall el = (ElementWall)ent;
				bWallSelected = true;
				gbsElement.append(el.genBeam());
				entRefs.append(ent);
			}
		}
		if(bDebug)reportMessage("\n"+ scriptName() +" " + entRefs.length() + " element based refs selected");
		
		for (int e=0;e<entsSet.length();e++)
		{
			Entity ent = entsSet[e];
			GenBeam gb = (GenBeam)ent;
			if (!gb.bIsValid())continue;
			
		// skip any genbeam which is found in elements genbeams
			if (gbsElement.find(gb)>-1)continue;
			
			if (ent.bIsKindOf(Beam()))
			{
				Beam bm = (Beam)ent;
//				if (bm.bIsDummy() || !bm.vecX().isPerpendicularTo(_ZW) || nRafterTypes.find(bm.type())>-1)continue;
				if (bm.bIsDummy() || nRafterTypes.find(bm.type())>-1)continue; // v 1.4 --> rising plates allowed, now
				entRefs.append(ent);
			}
			else
			{
//				if (gb.bIsDummy() || !(gb.vecX().isPerpendicularTo(_ZW) || gb.vecY().isPerpendicularTo(_ZW)))continue;	
				if (gb.bIsDummy() || gb.vecY().isPerpendicularTo(_ZW))continue;	// v 1.4 --> rising plates allowed, now
				entRefs.append(ent);
			}
		}
		
	// selection set of female beams (rafters)
		Beam bmMales[0],bmFemales[0];
		if (entRefs.length()>0)
		{
			ssE=PrEntity (T("|Select rafters|"), Beam());
			if (ssE.go())
				bmFemales = ssE.beamSet();
				
			if (bmFemales.length()<2)
			{
				reportMessage("\n" + scriptName() + " " + T("|requires at least 2 rafters.|"));
				eraseInstance();
				return;	
			}
		}// // END IF selection set rafters	
	/// individual selection
		else
		{
			reportMessage("\n" + scriptName() + " " + T("|sorry, not implemented yet.|"));
			eraseInstance();
			return;				
		}	
		
		if (bWallSelected == 0)
		{
			sReferenceBottom.setReadOnly(TRUE);
			nZone.setReadOnly(TRUE);
			sModifySheeting.setReadOnly(TRUE);
			sKerve.setReadOnly(TRUE);
			// HSB-22591
			dGapX.setReadOnly(TRUE);
			dGapY.setReadOnly(TRUE);
			dGapSheet.setReadOnly(TRUE);
		}
		else
		{
			sAlignmentDetection.setReadOnly(TRUE);
		}
		
	// to do: change opmKey if in tooling mode					
	// silent/dialog
		if (nEntry>-1)
			setPropValuesFromCatalog(sEntry);
		else
			showDialog();
		
	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[0];
		Entity ents[0];
		Point3d pts[1];
		int nProps[] = {nZone,nColor};
		double dProps[] = {dThickness,dHeight,dGapTop,dGapBottom,dOffset,dDepth,dGapDepth,dWidth, dConic, dConicOffset, dGapSheet,
			dGapX,dGapY};
		String sProps[] = {sReferenceBottom, sAlignment, sMaterial,sGrade,sName, sAlignmentDetection, sModifySheeting, sKerve};
		Map mapTsl;
		String sScriptname = scriptName();		

	// collect roofplanes
		for (int i = 0; i<bmFemales.length();i++)
			gbs.append(bmFemales[i]);
			
	// create distributions per defing object 
		for (int e = 0; e<entRefs.length();e++)
		{
			ents.setLength(0);
			ents.append(entRefs[e]);
			
			pts[0] = entRefs[e].realBody().ptCen();
			tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, 
				nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance
			
		}// next e
		eraseInstance();	
		return;
	}	
//end on insert________________________________________________________________________________________________________________________________________________________________________end on insert	
//return;/////////////////////
// validate sset
	if (_Entity.length()<1 || _Beam.length()<2)
	{
		reportMessage("\nXXX" + scriptName() + " " + T("|invalid selection set|"));
		eraseInstance();
		return;				
	}
	
// collect rafters
	Beam bmRafters[0];
	bmRafters = _Beam;
	
	for (int r=bmRafters.length()-1 ; r >= 0  ; r--)
	{
		if (_Entity.find(bmRafters[r]) > -1)
			bmRafters.removeAt(r);
	}
// HSB-7473 in bmRafters first must be a rafter not a hiprafter
	if(bmRafters[0].type()==_kHipRafter)
	{ 
		for (int i=1;i<bmRafters.length();i++) 
		{ 
			if(bmRafters[i].type()==_kRafter)
			{ 
				bmRafters.swap(0, i);
				int i0 = _Beam.find(bmRafters[0]);
				int iI = _Beam.find(bmRafters[i]);
				if(i0>-1 && iI>-1)
				{ 
					_Beam.swap(i0, iI);
				}
				break;
			}
		}//next i
	}
	
// collect roofplanes
	Entity entRoofs[] = Group().collectEntities(true, ERoofPlane(),_kModelSpace);
	
// run a reverse search of the rafter assignment
	ERoofPlane erp;
	for (int e=0;e<entRoofs.length();e++)
	{
		ERoofPlane erpTest = (ERoofPlane)entRoofs[e];
		Beam beams[] = erpTest.beam();
		erpTest.coordSys().vecZ().vis(erpTest.coordSys().ptOrg(), 1);
		for (int i=0;i<bmRafters.length();i++)
			if(beams.find(bmRafters[i])>-1)
			{
				// HSB-7473
				if(bmRafters[i].type()==_kHipRafter)
					continue;
				erp = erpTest;
				break;
			}
		if (!erp.bIsValid()) continue;
		Point3d ptRafterTop = (bmRafters[0].ptCenSolid() + bmRafters[0].vecD(_ZW) * .5 * bmRafters[0].dD(_ZW)); ptRafterTop.vis(6);
		Plane pnRp (erp.coordSys().ptOrg(), erp.coordSys().vecZ());
		Point3d ptInRp = pnRp.closestPointTo(ptRafterTop);
		double d = (ptRafterTop - ptInRp).length();
		if ((ptRafterTop - ptInRp).length() < dEps)
			break;
	}
	
// validate roof plane
	if (!erp.bIsValid())
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find the associated roofplane of the selected rafters.|"));
		eraseInstance();	
		return;			
	}
	
// coordSys of roofplane and outer vec
	CoordSys csErp = erp.coordSys();
	Vector3d vecX = csErp.vecY(); vecX.vis(csErp.ptOrg(), 1);
	Vector3d vecY = csErp.vecY(); vecY.vis(csErp.ptOrg(), 3);
	Vector3d vecZ = csErp.vecZ();vecZ.vis(csErp.ptOrg(), 5);
	Vector3d vecYN = vecX.crossProduct(_ZW).crossProduct(-_ZW);
	Plane pnErp(csErp.ptOrg(), vecZ);
	
// purge rafters	
	for (int r=bmRafters.length()-1 ; r >= 0  ; r--)
	{
		if (abs(vecY.dotProduct(bmRafters[r].vecX())) > abs(vecX.dotProduct(bmRafters[r].vecX())))
			bmRafters.removeAt(r);
	}
	
// project roofplane outline
	PlaneProfile ppRange(CoordSys(_PtW, _XW,_YW,_ZW));
	PLine plRange = erp.plEnvelope();
	plRange.projectPointsToPlane(Plane(_PtW,_ZW),_ZW);
	ppRange.joinRing(plRange,_kAdd);
	LineSeg segRange = ppRange.extentInDir(vecX);
	//ppRange.vis(6);
	segRange.vis(222); 
	
// the vector towards the outside
	Vector3d vecOut = -vecY.crossProduct(_ZW).crossProduct(-_ZW);
	vecOut.normalize();
	
/// coordSys of the blocking
	Vector3d vecXB = vecX;
	Vector3d vecYB = vecOut;
	Vector3d vecZB=_ZW;	
	
// properties by index
	int nAlignment=sAlignments.find(sAlignment);
	
// adjust vecZ of blocking
	if (nAlignment ==1)vecZB=vecZ;	
	
// get plane at bottom of rafters with gap
	double dRafterHeight = bmRafters[0].dD(vecZ);
	Plane pnBottom(bmRafters[0].ptCenSolid()-vecZ*(.5*dRafterHeight +dGapBottom), vecZ);
	pnBottom.vis(2);
	
// declare a profile outline range: rafters must intersect this profile in order to get toolings	
	PlaneProfile ppPlanTool(CoordSys(_Pt0, _XW,_YW,_ZW));
	
// get reference object and validate
	int bOk;
	Entity entRef = _Entity[0];

// the reference object as element 	
	ElementWall elRef;
	Vector3d vecXEl,vecYEl,vecZEl;
	Point3d ptOrg = elRef.ptOrg();
	
	Beam bmRef;
	GenBeam gbRef;
	Point3d ptRef=_Pt0;
	
// reference is a wall ____________________________________________________________________________________________________________________________________________________________________reference is a wall
	if (entRef.bIsKindOf(ElementWall()))
	{
		bOk=true;
	// cast and vecs
		elRef = (ElementWall)entRef;
		vecXEl = elRef.vecX();
		vecYEl = elRef.vecY();
		vecZEl = elRef.vecZ();
		ptOrg = elRef.ptOrg();			

	// validate elements alignment
		if (vecXEl.isParallelTo(vecYN))
		{
			reportMessage("\n" + scriptName() + " " + T("|The element may not be parallel with the projected rafter alignment.|") + " " + T("|Tool will be deleted.|"));
			eraseInstance();	
			return;			
		}

	// the default relation is the midpoint of the roofplane segment
		Point3d ptRangeMid= segRange.ptMid();
		
	// the elements outline and midpoint
		PLine plOutlineWall = elRef.plOutlineWall();
		Point3d ptMid; ptMid.setToAverage(plOutlineWall.vertexPoints(true));
		
	// get wall elements of this floor and try to get a floor plan
		Group grFloor(elRef.elementGroup().namePart(0)+"\\"+elRef.elementGroup().namePart(1));
		Entity entsFloor[] = grFloor.collectEntities(true, ElementWall(),_kModelSpace);	
		PlaneProfile ppFloor(CoordSys(ptOrg, _XW,_YW,_ZW));
		for (int i=0;i<entsFloor.length();i++)
		{
			Element el = (Element)entsFloor[i];
			ppFloor.joinRing(el.plOutlineWall(), _kAdd);
			ppFloor.shrink(-dEps);
		// remove all openings
			PLine plRings[] =ppFloor.allRings();
			int bIsOpenings[] =ppFloor.ringIsOpening();
			ppFloor.removeAllRings();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOpenings[r])
					ppFloor.joinRing(plRings[r], _kAdd);
		}
//		ppRange.vis(2);
	
	// get a range from intersection of roof and floor plan
		PlaneProfile ppRange2 = ppFloor;	
		ppRange2 .intersectWith(ppRange);
		LineSeg segRange2 = ppRange2.extentInDir(vecXEl);
		
	// to find out the outside of an element/roofplane combination becomes interesting if no floor plan can be found			
		if (ppRange2.area()>elRef.plOutlineWall().area() && abs(vecZEl.dotProduct(ptMid-segRange2.ptMid()))>dEps)
		{
			segRange=segRange2;
			segRange.vis(211);
			ptRangeMid= segRange.ptMid();
		}
		else
		{
		// get a simple point of gravity of the attached rafters
			Point3d ptGrav, ptGravs[0];
			for (int i=0;i<bmRafters.length();i++)
				ptGravs.append(bmRafters[i].realBody().ptCen());
			ptGrav.setToAverage(ptGravs);
			ptGrav.vis(3);
			ptRangeMid=ptGrav;
		}
		ppRange2 .vis(4);

	// adjust blocking coordSys
//		ptOrg.vis(5);
		Point3d pt1 = Line(ptOrg , _ZW).intersect(pnBottom, 0);
//		pt1.vis(4);
		Point3d pt2= Line(ptOrg +vecXEl *U(100), _ZW).intersect(pnBottom,0);	
		vecXB = pt2-pt1;vecXB.normalize();
//		pt2.vis(4);
		vecYB = vecXB.crossProduct(-vecZB);		
		vecYB.normalize();			
		vecZB = vecXB.crossProduct(vecYB);			

	// the element extreme segment
		LineSeg seg = elRef.segmentMinMax();
		double dZ = abs(vecZEl.dotProduct(seg.ptStart()-seg.ptEnd()));
		
	// swap/set vecOut
		// if settings are available set vecOut accordingls
		if (mapThisSettings.hasInt("ViewingSideExteriorWalls"))
		{
			vecOut = vecZEl;
		// vecOut correspinds to negative vecZ of the element if this value is set to 1
			if (mapThisSettings.getInt("ViewingSideExteriorWalls"))	
				vecOut*=-1;
		}
		else if (vecOut.dotProduct(seg.ptMid()-ptRangeMid)<0)
			vecOut*=-1;
			
	// distinguish relative side of element		
		if (vecOut.dotProduct(vecZEl)<0)
			vecZEl*=-1;

	// calculate reference point, initially based on bottom face location
		ptRef = seg.ptMid()+vecZEl *(.5*dZ);	ptRef.vis(2);
		ptRef = Line(ptRef,_ZW).intersect(pnBottom,0)-vecZEl*dOffset;
		ptRef.vis(3);
		
		if (nReferenceBottom == 1)
		{
			ptRef = seg.ptMid()+vecZEl *(.5*dZ);	ptRef.vis(2);
			ptRef = Line(ptRef-vecZEl*dOffset,_ZW).intersect(pnBottom,0);
			ptRef.vis(3);
		}
		
	// test if this point is within zone 0 and location is based on an existing top plate
		double dTest = elRef.vecZ().dotProduct(ptOrg-ptRef);
		Beam beams[] = elRef.beam();
		if (dTest<=elRef.dBeamWidth() && dTest>0 && beams.length()>0)
		{
		// remove all vertical beams
			for (int i=beams.length()-1;i>=0;i--)
				if (beams[i].vecX().isParallelTo(vecYEl))
					beams.removeAt(i);
		
		// get outmost beam
			Point3d ptMid = seg.ptMid()+elRef.vecZ()*(elRef.vecZ().dotProduct(ptOrg-seg.ptMid())-.5*elRef.dBeamWidth());
			beams = Beam().filterBeamsHalfLineIntersectSort(beams,ptMid, vecYEl);			
			
		// plate related location	
			if (beams.length()>0)
			{
				bmRef = beams[beams.length()-1];
				bmRef .envelopeBody().vis(2);	
				ptRef.transformBy(vecYEl*(vecYEl.dotProduct(bmRef .ptCenSolid()-ptRef)+.5*bmRef .dD(vecYEl)));
				ptRef.vis(6);
			// find intersction to defining beam
				LineBeamIntersect lbi(ptRef, -vecZB, bmRef , 1);
				if (lbi.nNumPoints()>0 && lbi.bHasContact())
				{
					ptRef=lbi.pt1();
				ptRef.vis(22);	
				// get offset to bottom plane and set bottom gap property	
					double dDistToBottom = vecZ.dotProduct(csErp.ptOrg()-ptRef)-dRafterHeight;
					if (abs(dDistToBottom-dGapBottom)>dEps)
					{
						dGapBottom.set(dDistToBottom);
						reportMessage("\n" + sGapBottomName + " " + T("|adjusted to|") + " " + dDistToBottom);
					}
				}
				else
					ptRef= Line(ptRef, vecZB).intersect(pnBottom,0);
				ptRef.vis(22);	
			}
		}
		
	// element outline range: rafters must intersect this range in order to get toolings
		ppPlanTool.joinRing(elRef.plOutlineWall(), _kAdd);		
		
	// get connected walls to this
		Element elConnnects[] = elRef.getConnectedElements();
		for (int i=0;i<elConnnects.length();i++)
			ppPlanTool.joinRing(elConnnects[i].plOutlineWall(), _kAdd);
			
	// add the kerve at selected zone 
		int iKerveIndex = sKerves.find(sKerve);
		if (iKerveIndex > 0)
		{ 
			// it is not selected the Disabled
			int iZoneSelected;
			if(iKerveIndex==1)
			{ 
				// outer zone is selected
				iZoneSelected = -5;
			}
			else if(iKerveIndex==2)
			{ 
				// inner zone is selected
				iZoneSelected == 5;
			}
			else
			{ 
				iZoneSelected = sKerve.atoi();
			}
		}
	}
	
// reference is a beam ____________________________________________________________________________________________________________________________________________________________________reference is a beam
	else if (entRef.bIsKindOf(Beam()))
	{
		bmRef = (Beam)entRef;	
		Point3d ptRefBeam = bmRef.ptCenSolid();
		vecXB=bmRef.vecX();
		vecZB = vecZB.crossProduct(vecXB).crossProduct(-vecXB); // align vector for rising plates
		vecZB.normalize();
		vecYB=vecXB.crossProduct(-vecZB);

	// validate elements alignment
		if (vecXB.isParallelTo(vecYN))
		{
			reportMessage("\n" + scriptName() + " " + T("|The plate may not be parallel with the projected rafter alignment.|")+ " " + T("|Tool will be deleted.|"));
			eraseInstance();	
			return;			
		}
		
	// swap vecOut (only in automatic mode or when set to ridge)
		if (nAlignmentDetection == 1) //ridge mode
			vecOut*=-1;	
		else if (nAlignmentDetection == 0)
			if (vecOut.dotProduct(ptRefBeam - segRange.ptMid())<0)
				vecOut*=-1;		
			
		vecOut.vis(ptRefBeam,2);
		
	// distinguish relative side of plate
		if (vecOut.dotProduct(vecYB)<0)
		{
			vecXB*=-1;
			vecYB*=-1;
		}
		
		ptRef = ptRefBeam+bmRef.vecD(vecOut)*.5*bmRef.dD(vecOut)+bmRef.vecD(_ZW)*.5*bmRef.dD(_ZW);		ptRef.vis(87);
//		ptRef.transformBy(-vecYB*dOffset);	//ptRef.vis(88);   // offset was calculated in blocking direction, now it is calculated really horizontal;
		ptRef.transformBy(-bmRef.vecD(vecOut)*dOffset);	//ptRef.vis(88);
//		Line lnRef (ptRef, _ZW);
//		ptRef = lnRef.intersect(pnBottom, 0);
		ptRef.vis(6);
		
// test if this point is within beam contour area
	double dTest = abs(bmRef.vecD(vecOut).dotProduct(bmRef.ptCen()-ptRef));
	if (dTest<=.5*bmRef.dD(vecOut))
	{
	// find intersction to defining beam
		LineBeamIntersect lbi(ptRef, vecZB, bmRef);
		Point3d pt = lbi.pt1();
		pt.vis(2);
		int n = lbi.nNumPoints();
		if (lbi.nNumPoints()>0 && lbi.bHasContact())
		{
			ptRef=lbi.pt1();
		}
	}
	else
		ptRef= Line(ptRef, _ZW).intersect(pnBottom,0);
	
	ptRef.vis(89);
	
	// plate outline range: rafters must intersect this range in order to get toolings
		ppPlanTool = bmRef.envelopeBody(false, true).shadowProfile(Plane(ptRefBeam, vecZB));

	}
	
// reference is a sheet or sip ___________________________________________________________________________________________________________________________________________________reference is a sheet or sip
	else if (entRef.bIsKindOf(GenBeam()))	// sheet or sip	
	{
		gbRef= (GenBeam)entRef;
		if (gbRef.vecZ().isParallelTo(vecOut))
		{
			bOk=true;
			ptRef = gbRef.ptCenSolid()+vecOut*.5*bmRef.dH();
		}	
	}
	
	vecZ.vis(csErp.ptOrg(),150);
	vecOut.vis(ptRef, 3);	

// get the realbody of a potential plate
	Body bdPlate;
	if (bmRef.bIsValid())
	{
		bdPlate=bmRef.realBody();
		bdPlate.vis(4);
	}
// determine if at ridge
	int bRidge = vecOut.dotProduct(vecY)>0;
	
// the insertion point of the Blocks offsets with the given value
	Point3d ptIns = ptRef;
	ptIns.vis(6);	

// align Block vecs
	if (vecOut.dotProduct(vecYB)<0)
	{
		vecXB*=-1;
		vecYB*=-1;		
	}
			
	vecXB.vis(ptIns,1);
	vecYB.vis(ptIns,96);
	vecZB.vis(ptIns,150);

// vis the tooling profile
	ppPlanTool.vis(64);	
	
// filter intersecting beams
	Point3d ptFilter = Line(ptIns, vecZB).intersect(pnErp,-.5*dRafterHeight);ptFilter .vis(8);
	bmRafters = Beam().filterBeamsHalfLineIntersectSort(bmRafters, ptFilter  -vecXB*U(10e3), vecXB);	
	//bmRafters = Beam().filterBeamsHalfLineIntersectSort(bmRafters, ptIns+vecZB*.5*dRafterHeight -vecXB*U(10e3), vecXB);	
//	return;
	Point3d ptsRafters[0];
	Body bdR;
	for (int i=0;i<bmRafters.length();i++)
	{
		Beam bm = bmRafters[i];
		bdR.addPart(bm.envelopeBody(false, true));
		Point3d pt = Line(ptIns,vecXB).intersect(Plane(bm.ptCenSolid(),bm.vecD(vecXB)),0);
		//pt.vis(i);
		ptsRafters.append(pt);
	}

// the shadow in block view
	PlaneProfile ppR = bdR.shadowProfile(pnBottom);
	//ppR.vis(1);

// prepare distribution
	Body bdBlock;
	PLine plSubtract;
	// collect bmBlocks, Füllhol
	Beam bmBlocks[0];
	
	if (ptsRafters.length()>1)
	{	
		Display dp(40);

	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[2];
		Entity ents[0]; // requires two elements
		Point3d pts[1];
		int nProps[0];
		double dProps[]={dDepth, dGapDepth,dWidth, dConic, dConicOffset};
		String sProps[] ={ sKerve};
		Map mapTsl;
		// tooling mode
		mapTsl.setInt("mode",1);
		mapTsl.setVector3d("vecOut",vecOut);
		mapTsl.setInt("bDoPlumbHousing", bDoPlumbHousing);
		
		String sScriptname = scriptName();

	// set tooling width
		double dYBc = dWidth;
		if (dYBc<=0 || dYBc<dThickness)
			dYBc = dThickness;


	// collect extremes of blocking to create a rectangle below the extreme rafters
		Beam bm1 = bmRafters[0];
		Beam bm2 = bmRafters[bmRafters.length()-1];
		Point3d pt1 = 	Line(ptIns, vecXB).intersect(Plane(bm1.ptCenSolid(), bm1.vecD(vecXB)), -.5*bm1.dD(vecXB));	pt1.vis(6);
		Point3d pt2 = 	Line(ptIns, vecXB).intersect(Plane(bm2.ptCenSolid(), bm2.vecD(vecXB)), .5*bm2.dD(vecXB));	pt2.vis(7);
		
		// HSB-7473 add gap between sheet and blocking (füllholz)
		pt1 -= vecZB * dGapSheet;
//		reportMessage("\n"+ scriptName() + "dGapSheet "+dGapSheet);
		
		plSubtract.createRectangle(LineSeg(pt1,pt2+vecZB*U(10e2)), vecXB, vecZB);
//		plSubtract.vis(6);
		
		double dX = vecXB.dotProduct(pt2-pt1);
		double dY = dThickness;
		double dZ = dHeight;
		if (dZ<=0) dZ=vecZB.dotProduct(Line(ptIns, vecZB).intersect(pnErp, 0)-ptIns);
		
		if (dX>dEps && dY>dEps && dZ>dEps)
		{
			bdBlock = Body ((pt1+pt2)/2, vecXB, vecYB, vecZB, dX, dY, dZ,0,-1,1);
//			bdBlock.vis(30);
	
		// subtract potential plate intersections
			if (bdPlate.volume()>pow(dEps,3))bdBlock.subPart(bdPlate);
			
			PlaneProfile ppB=bdBlock.shadowProfile(Plane(ptIns, vecZB));
			ppB.subtractProfile(ppR);
			ppB.vis(3);
			
		// top cut at ridge or eave vary
			Vector3d vecZCut = vecZB;
			if (bRidge)vecZCut = vecZ;
			Point3d ptCut = Line(ptIns, vecZCut).intersect(pnErp, -dGapTop);
			if (vecZCut.dotProduct(ptCut-ptIns)<dEps)
			{
				reportMessage("\n" + sCategoryPlaneOffset + " " +T("|hinders creation of blocking.|") );
				eraseInstance();
				return;	
			}		
			Cut ctTop(ptCut , vecZCut);
			
		// distribute blockings
			for (int i=0; i< ptsRafters.length()-1;i++)
			{
				Beam bm1 = bmRafters[i];
				Beam bm2 = bmRafters[i+1];
				
				Point3d pt1 = ptsRafters[i]+vecXB*.5*bm1.dD(vecXB);
				Point3d pt2 = ptsRafters[i+1]-vecXB*.5*bm2.dD(vecXB);
				double dX2 = abs(vecXB.dotProduct(pt2-pt1))+2*dDepth;
				Point3d ptM = (pt1+pt2)/2;
			
			// the blocking body	
				Body bd(ptM,vecXB, vecYB, vecZB, dX2, dY, dZ,0,-1,1);
				double dVolumeOriginal = bd.volume();
				if(!bDebug)
					bd.addTool(ctTop,0);
				double dVolumeCut = bd.volume();
				
			// subtract potential plate intersections
				if (bdPlate.volume()>pow(dEps,3))bdBlock.subPart(bdPlate);
			//	bd.vis(5);
							
			/// in debug mode draw the blocking and apply beamcut to the rafters	
				if (bDebug)
				{
					dp.draw(bd);
		
				// apply tools unless exclusion rule applies: beam outside range or in exclude type list
					BeamCut bc(ptM,vecXB, vecYB, vecZB, dX2+2*dGapDepth, dYBc, U(10e3),0,-1,0);
					if (ppPlanTool.pointInProfile(pt1)!=_kPointOutsideProfile && nNoToolTypes.find(bm1.type())<0)
					{
						if(!bDebug)
						bm1.addTool(bc);
					}
					if (ppPlanTool.pointInProfile(pt2)!=_kPointOutsideProfile && nNoToolTypes.find(bm2.type())<0)
					{
						if(!bDebug)
						bm2.addTool(bc);
					}
				}	
				else
				{
				// create the blocking as beam and assign attributes
					Beam bm0;
					if (dHeight <= 0)
						bm0.dbCreate(bd,vecXB, vecYB, vecZB);
						
					else
					{
						bm0.dbCreate(bd,ptM-.5*vecYB*dY+.5*vecZB*dZ,vecXB, vecYB, vecZB, dY, dZ);
					//	apply top cut only if required
						if (dVolumeOriginal - dVolumeCut > pow(dEps, 3))
						{
							if(!bDebug)
							bm0.addToolStatic(ctTop, 0);
						}
					}
					
					bm0.setMaterial(sMaterial);
					bm0.setName(sName);
					bm0.setGrade(sGrade);
					bm0.setColor(nColor);
					bm0.setType(_kBlocking);
					
					if (!bm0.bIsValid())continue;
					
					gbs[0]=bm0;
					// collect bmBlocks
					bmBlocks.append(bm0);
//					if (ppPlanTool.pointInProfile(pt1)!=_kPointOutsideProfile && nNoToolTypes.find(bm1.type())<0)
					if (nNoToolTypes.find(bm1.type())<0)
					{
						vecUcsX = -bm0.vecX();
						vecUcsY = -bm0.vecY();						
						gbs[1]=bm1;
						pts[0] = pt1;
						// pass on the reference (element or beam Pfette)
						ents.setLength(0);
						ents.append(entRef);
						// create TSL
						tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, 
							nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance	
					}

//					if (ppPlanTool.pointInProfile(pt2)!=_kPointOutsideProfile && nNoToolTypes.find(bm2.type())<0)
					if (nNoToolTypes.find(bm2.type())<0)
					{
						vecUcsX = bm0.vecX();
						vecUcsY = bm0.vecY();						
						gbs[1]=bm2;
						pts[0] = pt2;
						// pass on the reference (element or beam Pfette)
						ents.setLength(0);
						ents.append(entRef);
						// create TSL
						tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, 
							nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance	
					}
				}
			}// END IF distribute blockings
			
			dp.draw(ppPlanTool);
			if (bDebug)
				bdBlock.addTool(ctTop,0);
			//dp.draw(bdBlock);
		}
	}
	
	// distribute tsl for the kerve
	if(bmRafters.length()>0 && bmBlocks.length()>0)
	{ 
		bmBlocks.append(bmBlocks[bmBlocks.length() - 1]);
		int iKerveIndex = sKerves.find(sKerve);
		
		if(iKerveIndex>0)
		{ 
		// create TSL
			TslInst tslNew;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[2];	Entity entsTsl[1];		Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};
			// HSB-22591
			double dProps[]={dGapX,dGapY}; 
			String sProps[]={sKerve};
			Map mapTsl;	
			
			for (int i=0;i<bmRafters.length();i++) 
			{ 
				Beam bmI = bmRafters[i];
				// HSB-7473 dont generate kerve for the gratsparren, hip rafter
				if (bmI.type()==_kHipRafter)
					continue;
				gbsTsl[0] = bmI;
				gbsTsl[1] = bmBlocks[i];
				entsTsl[0] = entRef;
				//kerve mode;
				mapTsl.setInt("mode", 2);
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}//next i
		}
	}
// valid element reference: find sheeting zones to be stretched or trimmed	___________________________________________________________________________________________________ sheeting modifications
	if (bModifySheeting && elRef.bIsValid() && ptsRafters.length()>1)
	{
	// vecs
		Vector3d vecXE= elRef.vecX();
		Vector3d vecYE= elRef.vecY();
		Vector3d vecZE= elRef.vecZ();	
		
	// distinguish relative side of element
		int nSide = 1;		
		if (vecOut.dotProduct(vecZE)<0)	nSide *=-1;	
					
	// zone detection
		int nZones[0];
	// a zone is given, and on same side as the blocking
		if (nZone!=0 && nZone*nSide>0)
		{
		// collect any zone further outside
			for (int i=5;i>=abs(nZone);i--)
			{
				ElemZone ez = elRef.zone(i*nSide);
				if (ez.dH()>dEps)	nZones.append(i*nSide);
			}				
		}
	// no zone is specified, take any zone equal or further outside
		else
		{
			Point3d ptX = elRef.zone(nSide).ptOrg();ptX .vis(4);
			double dIns = vecZEl.dotProduct(ptIns-ptX);
		// collect any zone further outside
			for (int i=5;i>0;i--)
			{
				ElemZone ez = elRef.zone(i*nSide);
				Point3d ptZ = ez.ptOrg()+vecZEl*ez.dH();
				double dZone = vecZEl.dotProduct(ptZ-ptX)+dThickness;
				if (dZone>=dIns && ez.dH()>dEps)	
				{
					nZones.append(i*nSide);
					ez.vecZ().vis(ptZ,i);
					ptZ.vis(i);
				}
			}
		}	
		
	// collect extremes of blocking to create a rectangle below the extreme rafters
		Beam bm1 = bmRafters[0];
		Beam bm2 = bmRafters[bmRafters.length()-1];
		Point3d pt1 = 	Line(ptIns, vecXB).intersect(Plane(bm1.ptCenSolid(), bm1.vecD(vecXB)), -.5*bm1.dD(vecXB));	//pt1.vis(6);
		Point3d pt2 = 	Line(ptIns, vecXB).intersect(Plane(bm2.ptCenSolid(), bm2.vecD(vecXB)), .5*bm2.dD(vecXB));		//pt2.vis(7);
		
	// loop zones to be manipulated
		for (int i=0;i<nZones.length();i++)
		{
			int n = nZones[i];
			ElemZone ez = elRef.zone(n);
			Sheet sheets[] = elRef.sheet(n);	
		
		// get total sheet contour
			PlaneProfile ppZone(CoordSys(ez.ptOrg(), vecXE, vecYE, vecZE));
			for (int s=0;s<sheets.length();s++)
			{
				Sheet sheet = sheets[s];
				ppZone.joinRing(sheet.plEnvelope(),_kAdd);					
			}
			//ppZone.vis(51);
			
		// get upper edge
			LineSeg segZone=ppZone.extentInDir(vecXE);
			double dYZone = abs(vecYE.dotProduct(segZone.ptStart()-segZone.ptEnd()));	
			Point3d ptTopZone = segZone.ptMid()+vecYE*(.5*dYZone-U(10));
			
		// create test area on top of zone
			PlaneProfile ppTest(CoordSys(ez.ptOrg(), vecXE, vecYE, vecZE));
			{
				PLine pl;
				LineSeg seg;
				if (vecYE.dotProduct(ptTopZone - pt1) > 0)
					seg=LineSeg(pt1, pt2+vecYE*U(10e2));			
				else
					seg=LineSeg(pt1, pt2-vecYE*vecYE.dotProduct(pt2-ptTopZone));//+vecYE*U(10e2)
				//seg.vis(3);
				pl.createRectangle(seg, vecXE, vecYE);
				ppTest.joinRing(pl, _kAdd);
			}
			//ppTest.vis(2);
			
		// extent per sheet
			for (int s=0;s<sheets.length();s++)
			{
				Sheet sheet = sheets[s];
				PlaneProfile ppSheet =sheet.profShape();
				
			// collect potential openings of this profile to be added again after merging 
				PLine plRings[] = ppSheet.allRings();
				int bIsOp[] = ppSheet.ringIsOpening();
				
				PlaneProfile ppCommon = ppSheet;
				ppCommon.intersectWith(ppTest);	// get the intersection to get common width
				if (ppCommon.area()<pow(dEps,2))continue;
				if (n==-1)ppSheet .vis(56);
				
			//	test if this sheet needs to be stretched
				LineSeg segSheet = ppSheet.extentInDir(vecXE);	
				double dYSheet = abs(vecYE.dotProduct(segSheet.ptStart()-segSheet .ptEnd())); // the height of the common range				
				Point3d ptTop = segSheet.ptMid()+vecYE*.5*dYSheet;
				
				double dY = vecYE.dotProduct(ptIns-ptTop);
				if (dY>dEps)
				{
					ptTop .vis(3);	
					Point3d pts[] = ppSheet.getGripEdgeMidPoints();
					PLine pl = sheet.plEnvelope();
					Point3d ptsStretchs[0];
					for (int p=0; p<pts.length();p++)
					{
						Point3d pt=pts[p];
						if (abs(vecYE.dotProduct(pt-ptTop))>dEps)continue;
						if (dY>dEps)ppSheet.moveGripEdgeMidPointAt(p, vecYE*dY);
						pt.vis();	
					}
				}
				ppSheet.joinRing(plSubtract, _kSubtract);
				//if (n==-1)ppSheet.vis(1);
				plRings = ppSheet.allRings();
				bIsOp = ppSheet.ringIsOpening();
				//ppCommon.vis(s);

			// rebuild sheet
				if (!bDebug)
				{
					for (int r=0; r<plRings.length();r++)
						if (!bIsOp[r])
							sheet.joinRing(plRings[r], _kAdd);	
					for (int r=0; r<plRings.length();r++)
						if (bIsOp[r])
							sheet.joinRing(plRings[r], _kSubtract);				
					sheet.profShape().vis(s);
				}
				sheet.joinRing(plSubtract, _kSubtract);
			}// next s sheet	
		}// next i zone
	}// modify sheeting

// do not erase during debug
	if (!bDebug)
		eraseInstance();	
	return;
}
// END IF distribution mode	

// tool mode
else if (nMode==1)
{ 	
// tooling
	String sCategoryGroove = T("|Blocking groove|");	
	String sDepthName=T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(6),sDepthName);
	dDepth.setDescription(T("|Defines the depth of groove|"));
	dDepth.setCategory(sCategoryGroove );	

	String sGapDepthName=T("|Gap Depth|");
	PropDouble dGapDepth(nDoubleIndex++, U(1),sGapDepthName);
	dGapDepth.setDescription(T("|Defines the gap in depth of groove|"));
	dGapDepth.setCategory(sCategoryGroove );	
	
	String sWidthName=T("|Width|");
	PropDouble dWidth(nDoubleIndex++, 0,sWidthName);
	dWidth.setDescription(T("|Defines the Width of the groove|") + " " + T("|0 = automatic|"));
	dWidth.setCategory(sCategoryGroove );	
	
	String sConicName= T("|Conic Groove|");
	PropDouble dConic(nDoubleIndex++, U(0),sConicName);
	dConic.setDescription(T("|Defines if a conic shaped groove shall be made|"));
	dConic.setCategory(sCategoryGroove );
	
	String sConicOffsetName= T("|Bottom offset of conic groove|");
	PropDouble dConicOffset(nDoubleIndex++, U(0),sConicOffsetName);
	dConicOffset.setDescription(T("|Defines the bottom offset, where the conic groove starts|"));
	dConicOffset.setCategory(sCategoryGroove );	
	
	PropString psDoMaxGroove(0, sNoYes, T("|Maximize Groove|"), 1); 
	int bDoMaxGroove = psDoMaxGroove == sNoYes[1];
	
	PropString psAddPlumbHousing(1, sNoYes, T("|Expand Groove to Plumb|"));
	int bAddPlumbGroove = psAddPlumbHousing == sNoYes[1];
	if(_Map.hasInt("bDoPlumbHousing"))
	{
		bAddPlumbGroove = _Map.getInt("bDoPlumbHousing");
		if (bAddPlumbGroove) psDoMaxGroove.set(sNoYes[1]);
		else psDoMaxGroove.set(sNoYes[0]);
		_Map.removeAt("bDoPlumbHousing", 0);
	}
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// a potential catalog entry name and all available entries
		String sEntry = _kExecuteKey;
		String sEntryUpper = sEntry; sEntryUpper.makeUpper();
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		int nEntry = sEntries.find(sEntryUpper);

	// silent/dialog
		if (nEntry>-1)
			setPropValuesFromCatalog(sEntry);	
		else
			showDialog();
		
		_Beam.append(getBeam(T("|Select male beam|")));
		_Beam.append(getBeam(T("|Select female beam|")));
		return;
	}

// validate sset
	if (_Beam.length()<2)
	{
		reportMessage("\nx2" + scriptName() + " " + T("|invalid selection set|"));
		eraseInstance();
		return;				
	}
	
// set opmkey
	setOPMKey("Groove");
	
// behaves like a T-Type
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	int nNoToolTypes[] = {_kValleyRafter,_kHipRafter};
	
	// HSB-23959: add check for normal connection
	if(nNoToolTypes.find(bm1.type())<0 && abs(bm0.vecX().dotProduct(bm1.vecX()))<0.001)
	{ 
		
		Vector3d vecX0, vecY0, vecZ0, vecX1, vecY1, vecZ1;
		Point3d ptCen0 = bm0.ptCenSolid();
		Point3d ptCen1 = bm1.ptCenSolid();
		vecX0 = bm0.vecX();
		vecZ0 = bm0.vecZ();
		vecX1 = bm1.vecX();
		
		if (vecX0.isParallelTo(vecX1))
		{
			reportMessage("\nx3" + scriptName() + " " + T("|invalid selection set|"));
			eraseInstance();
			return;	
		}
		Point3d ptX0=Line(ptCen0,vecX0).intersect(Plane(ptCen1, bm1.vecD(vecX0)),0);
		if (vecX0.dotProduct(ptX0-ptCen0)<0)
			vecX0*=-1;
		ptX0=Line(ptCen0,vecX0).intersect(Plane(ptCen1,bm1.vecD(vecX0)),-.5*bm1.dD(vecX0));	
		ptX0.vis(3);
		_Pt0=ptX0;
		 
		//_XF0.vis(_Pt0,1);	
		//_YF0.vis(_Pt0,3);	
		vecY0 =vecX0.crossProduct(-vecZ0);
		double dDY0 = bm0.dD(vecY0);
		//vecX0.vis(_Pt0,1);	
		//vecY0.vis(_Pt0,3);	
		//vecZ0.vis(_Pt0,150);	
	
	// if blocking is WCS aligned
		vecZ1=vecX0.crossProduct(_ZW).crossProduct(-_ZW);
		Vector3d vecAngleCalc=vecX0.crossProduct(_ZW).crossProduct(-_ZW);
		
	// if blocking is roofplane aligned
		if (bm0.vecD(_ZW).isParallelTo(bm1.vecD(_ZW)))
		{
			vecZ1 = vecX0.crossProduct(bm1.vecD(_ZW)).crossProduct(-bm1.vecD(_ZW));
			vecAngleCalc = vecX0;
		}
		
		vecAngleCalc.normalize();
		vecZ1.normalize();
		vecZ1.vis(_Pt0,1);
		
		Vector3d vecAngleCalcBase=vecX1.crossProduct(bm1.vecD(_ZW));
		double dAngleCalc=vecAngleCalc.angleTo(vecAngleCalcBase);
		double dRealDepth=abs(dDepth/cos(dAngleCalc))-abs(tan(dAngleCalc)*.5*bm0.dW());
		
	// stretch male
		Plane pn(_Pt0,-vecZ1);
		if(!bDebug)
		bm0.addTool(Cut(_Pt0+vecZ1*dRealDepth,vecZ1),1);
	
	// beamcut female
		Point3d ptBc=_Pt0+vecZ1*(dRealDepth+dGapDepth);
		Vector3d vecXC=vecZ1;
		Vector3d vecYC=vecZ1.crossProduct(-vecZ0); vecYC.normalize();
		Vector3d vecZC=vecXC.crossProduct(bm0.vecD(vecYC));
	
		double dYBc = bm0.dD(vecYC);
		if (!vecX0.isParallelTo(vecZC))
		{
			Point3d ptA=Line(ptCen0-vecY0*.5*dDY0,vecX0).intersect(pn,0);
			Point3d ptB=Line(ptCen0+vecY0*.5*dDY0,vecX0).intersect(pn,0);	
			dYBc=abs(vecYC.dotProduct(ptA-ptB));
			
			Point3d pt1=_L0.intersect(pn,0);
			Point3d pt2=_L0.intersect(pn,-dDepth-dGapDepth);
			double dDelta=vecYC.dotProduct(pt1-pt2);
			dYBc+=abs(dDelta);
			ptBc.transformBy(-vecYC*.5*dDelta);
		}
	
		if (dWidth>dYBc)
			dYBc=dWidth;
	//	vecYC .vis(_Pt0,3);
	//	vecZC .vis(_Pt0,150);	
	
	// get side flag
		Vector3d vecOut=vecY0;
		if (_Map.hasVector3d("vecOut"))
			vecOut=_Map.getVector3d("vecOut");
		vecOut.vis(_Pt0,2);
		int nSide=-1;
		if (vecOut.dotProduct(vecYC)<0)
			nSide*=-1;
				
		ptBc.transformBy(-nSide*vecYC*.5*bm0.dD(vecYC));//bm0.dD(vecYC)
		BeamCut bc(ptBc, vecXC,vecYC,vecZC,2*(dDepth+dGapDepth),dYBc,U(10e3),-1,nSide,0);
		if(!bDebug)
		{
			if(dDepth+dGapDepth>dEps)
				bm1.addTool(bc,_kStretchOnToolChange);
		}
	// calculation of conic shaped groove
		Plane pnTop (bm1.ptCen()+bm1.vecD(vecZC)*.5*bm1.dD(vecZC),bm1.vecD(vecZC));
		Plane pnBottom (bm1.ptCen()-bm1.vecD(vecZC)*.5*bm1.dD(vecZC),bm1.vecD(vecZC));
		Line lnCone (ptBc,vecZC);
		Point3d ptConeTop=lnCone.intersect(pnTop,0);
		Point3d ptCone=lnCone.intersect(pnBottom,0);
		
		double dPitch=abs(bm1.vecD(vecZC).angleTo(vecZC));
		double dPitchedHeight=vecZC.dotProduct(ptConeTop-ptCone);
		
		double dCone=atan(dConic/(dPitchedHeight-dConicOffset));
		
		ptCone.transformBy(vecZC*dConicOffset);
		ptBc.vis(1);
		ptCone.vis(6);
		CoordSys csCone (ptCone,vecXC,vecYC,vecZC);
		csCone.setToRotation(dCone,vecYC,ptCone);
	
		BeamCut bcCone(ptCone,vecXC,vecYC,vecZC,2*U(50),dYBc,U(10e3),-1,nSide,0);
		bcCone.transformBy(csCone);
		
		if (dConic>0)
		{
			if(!bDebug)
			bm1.addTool(bcCone);
		}
		
	 //region  Do Plumb Expansion Groove
	 //##########################################################
	 //##########################################################
	
		if(bAddPlumbGroove)
		{ 
			double dToolTol = U(1, "mm");
			Quader qdBlocking = bm0.quader();
			Quader qdRafter = bm1.quader();
			
			//__since housing might be tilted, first construct the back plane of previous tooling to project to
			//___this housing is rotated when compared to the previous one, so the angle is not quite the same.
			Vector3d vConeBackNormal = vecX0;
			vConeBackNormal.transformBy(csCone);
			if (vConeBackNormal.dotProduct(vecX0) < 0) vConeBackNormal *= -1;
			
			Plane pnHousingBack(ptCone, vConeBackNormal);
			//pnHousingBack.vis(3);
			Plane pnWorld(_Pt0, _ZW);
			
			//__construct rotated vectors for this Beamcut
			Vector3d vOutLevel = vecOut.projectVector(pnWorld);
			Vector3d vUpSlope = vecX1;
			if (vUpSlope.dotProduct(_ZW) < 0) vUpSlope *= - 1;
			if (vOutLevel.dotProduct(vUpSlope) > 0) vOutLevel *= -1;
			
			Vector3d vUpPlumbHouse = _ZW.projectVector(pnHousingBack);
			vUpPlumbHouse.normalize();
			Vector3d vInPlumbHouse = vConeBackNormal;
			
			Vector3d vPerpOut = vecY0;
			if (vPerpOut.dotProduct(vOutLevel) < 0) vPerpOut *= -1;
			//vPerpOut.vis(ptInsideCorner, 3);
			
			//__find lower inside corner of blocking
			Plane pnRafterFace = qdRafter.plFaceD(-vecX0);
			Line lnBlockingInsideCorner = qdBlocking.lnEdgeD(-vecZ0, - vPerpOut);
			//lnBlockingInsideCorner.vis(4);
			Point3d ptInsideCorner = lnBlockingInsideCorner.intersect(pnRafterFace, 0);
			//ptInsideCorner.vis(4);
			
			//__project inside corner to back face of potentially sloped housing
			Point3d ptBackInsideCorner = ptInsideCorner.projectPoint(pnHousingBack, 0, vConeBackNormal);
			
			//__find width and height of plumb beamcut
			Line lnInsideUp(ptBackInsideCorner, vUpPlumbHouse);
			Plane pnRafterTop = qdRafter.plFaceD(vecZ0);
			Point3d ptRafterTop = lnInsideUp.intersect(pnRafterTop, 0);
			//ptRafterTop.vis(2);
			double dHPlumbCut = (ptRafterTop - ptBackInsideCorner).length() + dToolTol;
			
			Plane pnBlockingOutside = qdBlocking.plFaceD(vPerpOut);
			Plane pnInsideBlocking = qdBlocking.plFaceD(-vPerpOut);
			Line lnHorizontal(ptBackInsideCorner, vOutLevel);
			Point3d ptHoriOut = lnHorizontal.intersect(pnBlockingOutside, 0);
			double dWPlumbCut = (ptHoriOut - ptBackInsideCorner).length() - dToolTol;
			
			Body bdRafter = bm1.envelopeBody();
			Quader qdPlumbCut(ptBackInsideCorner, vUpPlumbHouse, vOutLevel, - vInPlumbHouse, dHPlumbCut, dWPlumbCut, U(.1));
			qdPlumbCut.modifyBoxUntilFaceCompletelyOut(-vInPlumbHouse, bdRafter, false);
			
			double dDPlumbCut = qdPlumbCut.dD(vInPlumbHouse) * 1.2;//__overcut for safety and clean tooling
	
			BeamCut bcPlumb(ptBackInsideCorner, vUpPlumbHouse, vOutLevel, vInPlumbHouse, dHPlumbCut, dWPlumbCut, dDPlumbCut, 1, 1, -1);
			if(!bDebug)
			bm1.addTool(bcPlumb);
			bcPlumb.cuttingBody().vis(6);
			
			//__check to see if another cut is required
			Plane pnInsidePlumbCut (ptInsideCorner, vOutLevel);
			Line lnInsideBlockingTopRafter = pnInsideBlocking.intersect(pnRafterTop);
			//lnInsideBlockingTopRafter.vis(1);
			Line lnOutUpPlumbCut = lnInsideUp;
			lnOutUpPlumbCut.transformBy(vOutLevel * dWPlumbCut);
		
			//__find 2nd cut width
			Point3d ptInside2ndCut = lnOutUpPlumbCut.closestPointTo(lnInsideBlockingTopRafter);
			Point3d ptOutside2ndCut = lnInsideBlockingTopRafter.closestPointTo(ptInside2ndCut);
			double dW2ndCut = (ptInside2ndCut - ptOutside2ndCut).length();
			pnInsideBlocking.vis(3);
			lnOutUpPlumbCut.vis(4);
			Vector3d vParallelTest = lnOutUpPlumbCut.vecX().projectVector(pnInsideBlocking);
			
			if(dW2ndCut > 0 && ! vParallelTest.isParallelTo(lnOutUpPlumbCut.vecX()))
			{ 
				//__find max width which does not overshoot
				Point3d ptLowOutsidePlumbCut = lnOutUpPlumbCut.intersect(pnInsideBlocking, 0);
				
				Line lnLowOutsidePlumbCutLevel(ptLowOutsidePlumbCut, vOutLevel );
				Point3d ptBlockingGrooveFace = lnLowOutsidePlumbCutLevel.intersect(pnBlockingOutside, 0);
				double dMaxCutW = (ptBlockingGrooveFace - ptLowOutsidePlumbCut).dotProduct(vOutLevel);
				int iNumSecondaryCuts = dW2ndCut / dMaxCutW + 1;
				
					
				Point3d ptHighOutsidePlumbCut = lnOutUpPlumbCut.intersect(pnRafterTop, 0);
				ptLowOutsidePlumbCut = pnHousingBack.closestPointTo(ptLowOutsidePlumbCut);
				ptHighOutsidePlumbCut = pnHousingBack.closestPointTo(ptHighOutsidePlumbCut);
				ptLowOutsidePlumbCut.vis(3);
				ptHighOutsidePlumbCut.vis(4);
				Vector3d vUp2ndCut = ptHighOutsidePlumbCut - ptLowOutsidePlumbCut;
				double dH2ndCut = vUp2ndCut.length();
				
				Point3d pt2ndCut = ptLowOutsidePlumbCut + vUpPlumbHouse * dH2ndCut / 2 + vOutLevel * dW2ndCut / 2 - vInPlumbHouse * dToolTol;
				pt2ndCut.vis(3);
				vOutLevel.vis(pt2ndCut, 1);
				BeamCut bc2 (ptLowOutsidePlumbCut, vUpPlumbHouse, vOutLevel, vInPlumbHouse, dH2ndCut *1.2, dMaxCutW, dDPlumbCut + dToolTol, 1, 1, -1);
				
				double dBlockingAngle = vecZ0.angleTo(_ZW);
				Vector3d vZ0ProjectBackPlane = vecZ0.projectVector(pnHousingBack);
				vZ0ProjectBackPlane.normalize();
				Vector3d v2ndCutTransform =	 vZ0ProjectBackPlane * (dMaxCutW / sin(dBlockingAngle))*.99;
				//__loop over number of max width secondary cuts and apply/transform
				for(int k=0;k<iNumSecondaryCuts;k++)
				{
					if(!bDebug)
					bm1.addTool(bc2);
					bc2.cuttingBody().vis(4);
					
					bc2.transformBy(v2ndCutTransform);
				}
			}
		}
	
	 //##########################################################
	 //##########################################################
	 //endregion    End Do Plumb Expansion Groove
	
	
		
	////	create groove with several half cuts
	//	double dCuts = dYBc/U(6);
	//	int nCuts = dCuts+1;
	//	HalfCut hc;
	//	Slot sl;
	//	
	//	int nDir = 1;
	//	if (bm0.vecX().dotProduct(vecZ1) < 0)
	//		nDir = -1;
	//	
	//	for(int i=0; i<nCuts; i++)
	//	{
	//		double dOffsetCut = i;
	//		if (i+1 > dCuts)
	//			dOffsetCut = dCuts-1;
	//
	//		hc = HalfCut (ptBc - nDir*vecYC*dOffsetCut*U(6), -nDir*vecYC, vecZ1, TRUE);
	////		hc.setDoSolid(FALSE);
	//		
	//		bm1.addTool(hc);
	//	}
		
		
		
	/// Display
		Display dp(-1);
		
		Plane pnZ0(ptCen0, bm0.vecD(vecZC));
		Plane pnZ1(ptCen1, bm1.vecD(vecZC));
		Line lnZ(_Pt0, vecZC);
		Point3d ptBottoms[0], ptTops[0];
		ptBottoms.append(lnZ.intersect(pnZ0, -.5*bm0.dD(vecZC)));
		ptBottoms.append(lnZ.intersect(pnZ1, -.5*bm1.dD(vecZC)));
		ptBottoms = Line(_Pt0, -vecZC).orderPoints(ptBottoms);
		
		ptTops.append(lnZ.intersect(pnZ0, .5*bm0.dD(vecZC)));
		ptTops.append(lnZ.intersect(pnZ1, .5*bm1.dD(vecZC)));
		ptTops= lnZ.orderPoints(ptTops);
	
		if (ptBottoms.length()>0 && ptTops.length()>0)
		{
			PLine pl(ptBottoms[0], ptTops[0]);
			
		// beams do not touch
			if (vecZC.dotProduct(ptTops[0]-ptBottoms[0])<dEps)
			{
				reportMessage("\n" + _ThisInst.opmName() + " " + T("|no intersection found ebtween beam|") + " " + bm0.posnum() + " + " + bm1.posnum());
				eraseInstance();
				return;	
			}
			
			dp.draw(pl);		
			Point3d pt=(ptBottoms[0]+ ptTops[0])/2;
			pl = PLine(pt, Line(pt, vecX0).intersect(pn,-dDepth-dGapDepth));
			dp.draw(pl);
	
			Point3d pt1 = Line(pt, vecX1).intersect(Plane(pt,vecYC),.5*dDY0);
			Point3d pt2 = Line(pt, vecX1).intersect(Plane(pt,vecYC),-.5*dDY0);
			
			pl = PLine(pt1,pt2);
			dp.draw(pl);
	
			assignToGroups(bm1);
		}
	
	// write settings if none found based on the selected connection
		if (mapThisSettings.length()<1)
		{
		// add write settings trigger
			addRecalcTrigger(_kContext, sWriteSettingsTrigger);
			
		// write trigger action	
			if (_bOnRecalc && _kExecuteKey==sWriteSettingsTrigger)
			{
				Map mapTslSettings = mapSettings.getMap("TslSetting[]");
				Map mapTslSetting;
				mapTslSetting.setString("ScriptName", scriptName());
				mapTslSetting.setInt("Color", _ThisInst.color());
				mapTslSetting.setInt("ViewingSideExteriorWalls", 1); // 0 = opposite, 1 = icon side
				mapTslSettings.appendMap("TslSetting", mapTslSetting);
				mapSettings.setMap("TslSetting[]",mapTslSettings );
				mapSettings.writeToXmlFile(sSettingsPath);
				
				reportNotice("\n******************** " + scriptName() + " ********************");
				reportNotice("\n" + T("|Current settings are stored in|") + "\n\n" + sSettingsPath	+ "\n\n" + T("|Please edit this file with a text editor to modify\nor append values.|"));
				reportNotice("\n**************************************************************");	
				
				setExecutionLoops(2);
				return;
			}
		}
		
	// add update settings trigger
		addRecalcTrigger(_kContext, sLoadSettingsTrigger);
	}
	else
	{ 
		// beamcut for the hipRafter
		// füllholz
		Beam bm0 = _Beam[0];
		Point3d ptCen0 = bm0.ptCenSolid();
		ptCen0.vis(3);
		Vector3d vecX0 = bm0.vecX();
		// hiprafter
		Beam bm1 = _Beam[1];
		Point3d ptCen1 = bm1.ptCenSolid();
		
		// vector of rafter in direction of füllholz
		Vector3d vecRafterBlock = bm1.vecD(bm0.vecX());
		
		Point3d pt1 = Line(ptCen0, vecX0).intersect(Plane(ptCen1 - bm1.vecD(vecX0) * .5 * bm1.dD(vecX0), bm1.vecD(vecX0)), 0);
		Point3d pt2 = Line(ptCen0, vecX0).intersect(Plane(ptCen1 + bm1.vecD(vecX0) * .5 * bm1.dD(vecX0),bm1.vecD(vecX0)), 0);
		pt1.vis(2);
		pt2.vis(2);
		// vector of bm0 in direction of rafter
		Vector3d vecX0Rafter = vecX0;
		// vector of bm1 in direction of vecX0Rafter
		Vector3d vecCut = bm1.vecD(vecX0);
		if((pt1-ptCen0).length()>(pt2-ptCen0).length())
		{ 
			vecX0Rafter *= -1;
			vecCut *= -1;
		}
		
		Point3d pt0=Line(ptCen0, vecX0).intersect(Plane(ptCen1 - bm1.vecD(vecX0Rafter) * .5 * bm1.dD(vecX0Rafter),bm1.vecD(vecX0Rafter)), 0);
		pt0.vis(4);
		// 2 planes, touching plane and penetration plane
		// touching plane
		Plane pn0(pt0, bm1.vecD(vecX0Rafter));
		// penetration plane
		Plane pn1(pt0 + bm1.vecD(vecX0Rafter) * (dDepth + dGapDepth),bm1.vecD(vecX0Rafter));
		// gap plane in opposite direction
		Plane pn2(pt0 -+ bm1.vecD(vecX0Rafter) * (dGapDepth),bm1.vecD(vecX0Rafter));
		
//		pn0.vis(2);
		CoordSys cs0(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
		PlaneProfile pp0(cs0);
		PlaneProfile pp = bm0.envelopeBody().shadowProfile(Plane(ptCen0, vecX0));
		pp.project(pn0, vecX0, dEps);
		pp0.unionWith(pp);
		pp = bm0.envelopeBody().shadowProfile(Plane(ptCen0, vecX0));
//		pp.project(pn1, vecX0, dEps);
		pp.project(pn2, vecX0, dEps);

		pp0.unionWith(pp);
		pp0.vis(4);
		
		// stretch male
		if(!bDebug)
		bm0.addTool(Cut(pt0+bm1.vecD(vecX0Rafter)*(dDepth),bm1.vecD(vecX0Rafter)));
		
		// beamcut
		// get extents of profile
		Vector3d vecXbc = bm1.vecX();
		vecXbc=vecXbc.crossProduct(_ZW);
		vecXbc.normalize();
		vecXbc=vecXbc.crossProduct(_ZW);
		vecXbc.normalize();
		{ 
			// vecXbc in direction of vecx1Up
			Vector3d vecx1Up = bm1.vecX();
			if(vecx1Up.dotProduct(_ZW)<0)
				vecx1Up *= -1;
			if (vecXbc.dotProduct(vecx1Up) < 0)
				vecXbc *= -1;
		}
//		vecXbc.vis(pt0);
		
		Vector3d vecZbc = bm1.vecD(vecX0Rafter);
//		Vector3d vecZbc = bm0.vecD(_ZW);
		Vector3d vecYbc = vecZbc.crossProduct(vecXbc);
		LineSeg seg = pp0.extentInDir(vecXbc);
		Point3d ptBc = seg.ptMid();
//		ptBc.vis(4);
		// get extents of profile
		double dX = abs(vecXbc.dotProduct(seg.ptStart()-seg.ptEnd()));
		// beamcut at the rafter bm1
		BeamCut bc(ptBc, vecXbc, vecYbc, vecZbc, dX, U(1000), (dDepth + dGapDepth),0,0,1 );
		// HSB-19192
//		bc.cuttingBody().vis(3);
		if(!bDebug)
		bm1.addTool(bc);
		_Pt0 = ptBc;
		// beamcut at füllholz
		Point3d ptBc1 = ptBc - vecXbc * .5 * (dX);
		BeamCut bc1(ptBc1, vecYbc, vecZbc, vecXbc, U(1000), (dDepth + dGapDepth), U(100), 0, 1, -1);
		if(!bDebug)
		bm0.addTool(bc1);
		// HSB-23959: 2nd beamcut at blocking
		Point3d ptBc2 = ptBc + vecXbc * .5 * (dX);
		BeamCut bc2(ptBc2, vecYbc, vecZbc, vecXbc, U(1000), (dDepth + dGapDepth), U(100), 0, 1, 1);
		if(!bDebug)
		bm0.addTool(bc2);
		
		assignToGroups(bm1);
		
		// draw
		Display dp(-1);
		LineSeg lsX(ptBc - vecXbc * .5 * dX, ptBc + vecXbc * .5 * dX);
		LineSeg lsY(ptBc - vecYbc * .5 * bm1.dD(vecYbc), ptBc + vecYbc * .5 * bm1.dD(vecYbc));
		LineSeg lsZ(ptBc , ptBc + vecZbc * (dDepth + dGapDepth));
		
		dp.draw(lsX);
		dp.draw(lsY);
		dp.draw(lsZ);
	}
}// end tool mode
// kerve mode
else if (nMode==2)
{ 
	if(_Entity.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No ElementWall found|"));
		eraseInstance();
		return;
	}
	Entity entRef = _Entity[0];
	if (!entRef.bIsKindOf(ElementWall()))
	{ 
		// not an element wall
		eraseInstance();
		return;
	}
	ElementWall elRef = (ElementWall)entRef;
	Vector3d vecXEl = elRef.vecX();
	Vector3d vecYEl = elRef.vecY();
	Vector3d vecZEl = elRef.vecZ();
	Point3d ptOrg = elRef.ptOrg();
	if(_Beam.length()!=2)
	{ 
		// no sparren beam found
		eraseInstance();
		return;
	}
	// rafter
	Beam bm0 = _Beam[0];
	Vector3d vecX = bm0.vecX();
	Vector3d vecY = bm0.vecY();
	Vector3d vecZ = bm0.vecZ();
	Point3d ptCen = bm0.ptCen();
	_Pt0 = ptCen;
	// Füllholz
	Beam bmBlock = _Beam[1];
	setOPMKey("Kerve");
	// kerve
	String sCategoryElement = T("|Element|");
	String sKerveName=T("|Kerve|");	
	String sKerves[] ={ T("<|Disabled|>"), T("|Outer|") +" "+ T("|Zone|"), T("|Inner|") +" "+T("|Zone|"),
									"-5", "-4", "-3", "-2", "-1", "0", "1", "2", "3", "4", "5"};
	PropString sKerve(0, sKerves, sKerveName);	
	sKerve.setDescription(T("|Defines the Kerve|"));
	sKerve.setCategory(sCategoryElement);
	
	String sGapXName=T("|Gap|")+" X";	
	PropDouble dGapX(nDoubleIndex++, U(0), sGapXName);	
	dGapX.setDescription(T("|Defines the GapX|"));
	dGapX.setCategory(category);
	
	String sGapYName=T("|Gap|")+" Y";	
	PropDouble dGapY(nDoubleIndex++, U(0), sGapYName);	
	dGapY.setDescription(T("|Defines the GapY|"));
	dGapY.setCategory(category);
	
	// add the Kerve at the rafter if requested 
	int iKerveIndex = sKerves.find(sKerve);
	if(iKerveIndex==0)
	{ 
		// disabled is selected, delete tsl
		eraseInstance();
		return;
	}
	if (iKerveIndex > 0)
	{ 
		// max min zones
		int iZonesMin[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1};
		int iZoneMin;
		for (int ii=0;ii<iZonesMin.length();ii++) 
		{ 
			ElemZone eZone = elRef.zone(iZonesMin[ii]);
			if(eZone.dH()>0)
			{ 
				iZoneMin = iZonesMin[ii];
				break;
			}
		}//next ii
		int iZonesMax[] ={ 5 ,4 ,3 ,2 ,1};
		int iZoneMax;
		for (int ii=0;ii<iZonesMax.length();ii++) 
		{ 
			ElemZone eZone = elRef.zone(iZonesMax[ii]);
			if(eZone.dH()>0)
			{ 
				iZoneMax = iZonesMax[ii];
				break;
			}
		}//next ii
		
		
		// it is not selected the Disabled
		int iZoneSelected;
		if(iKerveIndex==1)
		{ 
			iZoneSelected = iZoneMin;
			// outer zone is selected
		}
		else if(iKerveIndex==2)
		{ 
			// inner zone is selected
			iZoneSelected = iZoneMax;
			// outer zone is selected
		}
		else
		{ 
			iZoneSelected = sKerve.atoi();
			if(iZoneSelected<iZoneMin)
			{ 
				iZoneSelected = iZoneMin;
				String ss = iZoneSelected;
				int ttt = sKerves.find(ss);
				sKerve.set(sKerves[sKerves.find(ss)]);
			}
			if(iZoneSelected>iZoneMax)
			{ 
				iZoneSelected = iZoneMax;
				String ss = iZoneSelected;
				sKerve.set(sKerves[sKerves.find(ss)]);
			}
		}
		
		Display dp(40);
		// vecX of rafter pointing upward
		Vector3d vecXup = vecX;
		if(vecXup.dotProduct(_ZW)<0)
			vecXup *= -1;
		// vecZ of sheet pointing toward rafter
		Vector3d vecZelRafter = vecZEl;
		if(vecZelRafter.dotProduct(vecXup)>0)
			vecZelRafter *= -1;
		// vec of element pointing upward
		Vector3d vecElUp = vecYEl;
		if(vecElUp.dotProduct(_ZW)<0)
			vecElUp *= -1;
			
		Plane pn(ptCen, vecXEl);
		Point3d ptCorner;
		// get the plates of selected zone
		Sheet sheets[] = elRef.sheet(iZoneSelected);
		
		vecZelRafter.vis(ptCen);
		if(sheets.length()>0)
		{ 
			sheets[0].envelopeBody().vis(5);
			// corner point 
			ptCorner = sheets[0].ptCen() + .5*vecZelRafter * sheets[0].dD(vecZelRafter);
		}
		else
		{ 
			// in xy
			PLine plEnvelope = elRef.plEnvelope();
			plEnvelope.vis(6);
			//
			ptOrg.vis(7);
			Point3d ptFront = ptOrg + vecZEl * elRef.dPosZOutlineFront();
			Point3d ptBack = ptOrg + vecZEl * elRef.dPosZOutlineBack();
			ptFront.vis(6);
			ptBack.vis(6);
			Point3d ptMid = .5 * (ptFront + ptBack);
			
			PlaneProfile ppPlEnvelope(elRef.coordSys());
			ppPlEnvelope.joinRing(plEnvelope, _kAdd);
			
			LineSeg seg = ppPlEnvelope.extentInDir(vecXEl);
			Point3d ptCenQuad = seg.ptMid();
			double dX = abs(vecXEl.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecYEl.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dZ = abs(vecZEl.dotProduct(ptFront - ptBack));
			ptCenQuad += vecZEl * vecZEl.dotProduct(.5*(ptFront+ptBack) - ptCenQuad);
			ptCenQuad.vis(4);
			Quader qd(ptCenQuad, vecXEl, vecYEl, vecZEl, dX, dY, dZ, 0, 0, 0);
			qd.vis(8);
			ptCorner = ptCenQuad + .5*vecZelRafter * qd.dD(vecZelRafter);
		}
	
		ptCorner+=(bmBlock.ptCen()-vecElUp*.5*bmBlock.dD(vecElUp)-ptCorner).dotProduct(vecElUp)*vecElUp;
		ptCorner+=vecXEl*vecXEl.dotProduct(ptCen-ptCorner);
		// add gap
		ptCorner+=dGapX*vecZelRafter+dGapY*vecElUp;
		ptCorner.vis(5);
		
		LineSeg lSeg(ptCorner,ptCorner-vecElUp*U(200)-vecZelRafter*U(200));
		PLine pl;
		pl.createRectangle(lSeg,vecZelRafter,vecElUp);
		PlaneProfile ppBeamCut(pl);
		Body bdRafter=bm0.envelopeBody();
		PlaneProfile ppRafter=bdRafter.shadowProfile(pn);
		ppBeamCut.intersectWith(ppRafter);
		ppBeamCut.vis(3);
		
		if (ppBeamCut.area()>0)
		{ 
			dp.draw(ppBeamCut);
			BeamCut bc(ptCorner,vecZelRafter,vecElUp,vecZelRafter.crossProduct(vecElUp), 
							U(200),U(200),1.5*bm0.dD(vecZelRafter.crossProduct(vecElUp)),
							-1,-1,0);
			if(!bDebug)
			bm0.addTool(bc);
		}
		else
		{ 
			LineSeg lSeg(ptCorner,ptCorner-vecElUp*U(20)-vecZelRafter*U(20));
			PLine pl;
			pl.createRectangle(lSeg,vecZelRafter,vecElUp);
			PlaneProfile ppBeamCut(pl);
			dp.draw(ppBeamCut);
		}
	}
}






#End
#BeginThumbnail
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
F***`"BBB@`HHHH`****`"BBB@`HHHH`****`"FOTIU-?I0!__]FB
`
















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1399" />
        <int nm="BreakPoint" vl="1802" />
        <int nm="BreakPoint" vl="1841" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23959: If rafter and blocking is not normal, then do the tooling as block-hiprafter" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="4/29/2025 9:12:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22591: Expose Kerve properties gapX,gapY on insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="8/28/2024 11:24:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19192: Allow tooling at hip rafter" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="6/13/2023 3:43:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18370: Apply beamcut only if depth &gt; dEps" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="3/21/2023 12:44:39 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End