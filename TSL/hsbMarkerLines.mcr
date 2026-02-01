#Version 8
#BeginDescription
#Versions:
3.9 08.01.2025 HSB-22662: Fix side of markerline Author: Marsel Nakuci
3.8 08.09.2023 HSB-20007: shrink/extend pp to fix it 
3.7 15.05.2023 HSB-18971: Fix double export of Midline marking 
3.6 12.05.2023 20230512: Add some tolerance to the boundary 20mm of drills 
3.5 25.04.2023 HSB-18791: Dont allow drill closer then 20mm to edge/boundary 
3.4 25.04.2023 20230425: remove dependency with other entities; improves performance 
3.3 05.04.2023 HSB-18448: Fix drill point
Version 3.2 15.03.2023 HSB-18330 bugfix detecting solid of curved female beam
3.1 03.03.2023 HSB-18109: Fix side {Front,Back}; fix check when enforcing side marking 
Version 3.0 23.02.2023 HSB-17937 performance on curved beams enhanced, mid marking duplicates removed 
Version 2.9 14.02.2023 HSB-17937 performance enhanced on metalparts and block references which contain genbeams
2.8 09.11.2022 HSB-16807: Fix bug when considering for T-connections
2.7 09.11.2022 HSB-16807: Validate entity before checking the volume
2.6 29.09.2022 HSB-16644: Get plEnvelope of curved beams from realbody to consider also the toolings
2.5 28.09.2022 HSB-16644: fix side of points for MarkerLine; 
2.4 19.09.2022 HSB-16437: Fix for Midline
2.3 19.09.2022 HSB-16437: Support dialog box on insert
2.2 19.09.2022 HSB-16437: add trigger to place marking on sides; support drills on sides
2.1 18.05.2022 HSB-12295: Fix bug for skew beams for midline marking
2.0 23.11.2021 HSB-12295: Midline always available, marking on backside cnc conform.
1.9 03.09.2021 HSB-12295: add option {middle} for side {left,right, both,middle}
1.8 03.09.2021 HSB-12295: add properties side {left,right}; marking type {marking, drill,midline}; drilldepth,drilldiameter
1.7 17/08/2021 Fix bug in check which profile to take
1.6 12/08/2021 Add side/add as mark and fix bug with a sheet not exactly on the edge


This tsl creates marker lines on each edge of the contacting bounds of a connection






















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 9
#KeyWords Marker,MarkerLine,Markierung
#BeginContents
//region History

/// <summary>
/// This tsl creates marker lines on each edge of the contacting bounds of a connection
/// </summary>

/// <insert>
/// Select marking entities(s), then select genbeams to be marked.
/// The insert is done without a dialog shown. One can modify the length of the marker lines as follows:
/// 	individual: select an instance of this tsl in the drawing and change the length property
/// 	set the default value: select an instance of this tsl in the drawing and change the length property, then save the catalog entry _LastInserted
/// 	multiple values: select an instance of this tsl in the drawing and change the length property, then save it with a catalog name (i.e. mySettings), 
///	   create a tool button with the catalog name, i.e. ^C^C(hsb_scriptinsert"hsbT-CornerMarking.mcr" "mySettings")
/// </insert>

/// <insert lang=de>
/// Wählen Sie zuerst die markierenden Objekte und anschließend die Bauteile, welche markiert werden sollen.
/// Das Einfügen erfolgt ohne die Anzeige eines Dialoges und basiert auf Eigenschaften des Kataloges. 
/// Sie können die Länge der Markierlinien wie folgt beeinflussen:
/// 	1) individuell: wählen Sie eine Instanz des TSL's aus und ändern Sie die Eigenschaft 'Länge Markierlinie'
///	2) Vorgabewert setzen: wählen Sie eine Instanz des TSL's aus, rufen Sie über das Kontextmenü den Befehl 'hsbEigenschaften' auf
///      und ändern Sie die Eigenschaft 'Länge Markierlinie'. Speichern Sie die Einstellung als Katalogeintrag 'Vorgabe'
/// 	3) alternative Eigenschaften: verfahren Sie wie unter 2) beschrieben, speichern die Eigenschaften jedoch unter einem 
///      eigenen Namen, z.B. "StandardLang"
///	   Erzeugen Sie nun einen Werkzeug für die Paletten oder Multifunktionsleiste mit folgender Befehlszeile
///        C^C(hsb_scriptinsert"hsbContactMarkerLines.mcr" "StandardLang")
///      Mehr Informationen zu benutzerdefinierten Befehlen finden Sie in der AutoCAD Hilfe 
/// </insert>

/// History
// #Versions:
// 3.9 08.01.2025 HSB-22662: Fix side of markerline Author: Marsel Nakuci
// 3.8 08.09.2023 HSB-20007: shrink/extend pp to fix it Author: Marsel Nakuci
// 3.7 15.05.2023 HSB-18971: Fix double export of Midline marking Author: Marsel Nakuci
// 3.6 12.05.2023 20230512: Add some tolerance to the boundary 20mm of drills Author: Marsel Nakuci
// 3.5 25.04.2023 HSB-18791: Dont allow drill closer then 20mm to edge/boundary Author: Marsel Nakuci
// 3.4 25.04.2023 20230425: remove dependency with other entities; improves performance Author: Marsel Nakuci
// 3.3 05.04.2023 HSB-18448: Fix drill point Author: Marsel Nakuci
// 3.2 15.03.2023 HSB-18330 bugfix detecting solid of curved female beam , Author Thorsten Huck
// 3.1 03.03.2023 HSB-18109: Fix side {Front,Back}; fix check when enforcing side marking Author: Marsel Nakuci
// 3.0 23.02.2023 HSB-17937 performance on curved beams enhanced, mid marking duplicates removed , Author Thorsten Huck
// 2.9 14.02.2023 HSB-17937 performance enhanced on metalparts and block references which contain genbeams. , Author Thorsten Huck
// 2.8 09.11.2022 HSB-16807: Fix bug when considering for T-connections Author: Marsel Nakuci
// 2.7 09.11.2022 HSB-16807: Validate entity before checking the volume Author: Marsel Nakuci
// 2.6 29.09.2022 HSB-16644, HSB-16807: Get plEnvelope of curved beams from realbody to consider also the toolings Author: Marsel Nakuci
// 2.5 28.09.2022 HSB-16644: fix side of points for MarkerLine;  Author: Marsel Nakuci
// 2.4 19.09.2022 HSB-16437: Fix for Midline Author: Marsel Nakuci
// 2.3 19.09.2022 HSB-16437: Support dialog box on insert Author: Marsel Nakuci
// 2.2 19.09.2022 HSB-16437: add trigger to place marking on sides; support drills on sides Author Author: Marsel Nakuci
// 2.1 18.05.2022 HSB-12295: Fix bug for skew beams for midline marking Author: Marsel Nakuci
// 2.0 23.11.2021 HSB-12295: Midline always available, marking on backside cnc conform Author: Author: Nils Gregor
// Version 1.9 03.09.2021 HSB-12295: add option {middle} for side {left,right, both,middle} Author: Marsel Nakuci
// Version 1.8 03.09.2021 HSB-12295: add properties side {left,right}; marking type {marking, drill,midline}; drilldepth,drilldiameter Author: Marsel Nakuci
//1.7 17/08/2021 Fix bug in check which profile to take Author: Robert Pol
//1.6 12/08/2021 Add side/add as mark and fix bug with a sheet not exactly on the edge Author: Robert Pol
// Version 1.5 08.06.2021 HSB-11552: consider profiles from slicing Author: Marsel Nakuci
///<version value="1.4" date=04nov20" author="marsel.nakuci@hsbcad.com"> HSB-9583: bug fix for longitudinally cutted beams </version>
///<version value="1.3" date=24aug17" author="florian.wuermseer@hsbcad.com"> bugfix if marking item is a tsl beam to beam connection, take 2 </version>
///<version value="1.2" date=14aug17" author="thorsten.huck@hsbcad.com"> bugfix if marking item is a tsl beam to beam connection </version>
/// <version  value="1.0" date=08jan14" author="th@hsbCAD.de"> initial </version>
//endregion 

//region constants
	U(1,"mm");
	double dEps = U(0.1);
	double areaTolerance = U(1);
	int bDebug=_bOnDebug;
	String sArNY[] = {T("|No|"), T("|Yes|")};
	String sArSide[] = {T("|Front|"), T("|Back|"), T("|Both|")};
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");
	// parameter of allowing drill close to edge/boundary
	// we will not allow drilling close to edge/boundary
	double _dMarkedFaceShrink=U(20);
	double dMarkedFaceShrink=_dMarkedFaceShrink-dEps;
//End constants//endregion

//region Properties
	String sNameMarkerLength = T("|Marker Length|");
	PropDouble dMarkerLength (0, U(30),sNameMarkerLength );
	dMarkerLength .setDescription(T("|Defines length of the marker line, overlapping segments will be combined.|"));
	
	String sNameMarkeOffset = T("|Marker Offset|");
	PropDouble dMarkerOffset (1, U(0),sNameMarkeOffset );

	String sNameMarkBounds = T("|Mark Boundings|");
	PropString sMarkBounds (0, sArNY,sNameMarkBounds,1);
	sMarkBounds .setDescription(T("|Defines if the marking follows the boundings or the real contour of the marking entity.|"));
	
	String sNameExportAsMark = T("|Export as Mark|");
	PropString sExportAsMark (1, sArNY,sNameExportAsMark,0);
	
	String sNameSide = T("|Side|");
	PropString sSide (2,sArSide,sNameSide,0);
	
	String sNameColor = T("|Color|");
	PropInt nColor (0, 1,sNameColor);
	nColor.setDescription(T("|Defines the color of the symbol display.|") + " " + T("|The color of the marker can be modified in hsbSettings|"));
	
	String category = T("|General|");
	// type of marking
	category = T("|Marking Type|");
	String sTypeName=T("|Type|");
	String sTypes[] ={ T("|Corner|"), T("|Drill|"), T("|Midline|")};
//for curved beams where the marking is done on side, have as options marker;drill
	String sTypesCurved[] ={ T("|Marker|"), T("|Drill|")};
	PropString sType(3, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
	sType.setReadOnly(true);
	
	category = T("|Marking Side|");
	String sSideMarkingName=T("|Side|");
	String sSideMarkings[] ={ T("|Left|"), T("|Right|"), T("|Both|"),T("|Middle|")};
	PropString sSideMarking(4, sSideMarkings, sSideMarkingName);	
	sSideMarking.setDescription(T("|Defines the Marking Side|"));
	sSideMarking.setCategory(category);
	sSideMarking.setReadOnly(true);
	
	category = T("|Drill|");
	String sDiameterDrillName=T("|Diameter|");	
	PropDouble dDiameterDrill(2, U(2), sDiameterDrillName);	
	dDiameterDrill.setDescription(T("|Defines the Diameter of the Drill|"));
	dDiameterDrill.setCategory(category);
	dDiameterDrill.setReadOnly(true);
	
	category = T("|Drill|");
	String sDepthDrillName=T("|Depth|");	
	PropDouble dDepthDrill(3, U(5), sDepthDrillName);	
	dDepthDrill.setDescription(T("|Defines the Depth of the drill|"));
	dDepthDrill.setCategory(category);
	dDepthDrill.setReadOnly(true);
	
	category=T("|Marking Face|");
	String sMarkingFaceName=T("|Face|");
	String sMarkingFaces[]={ T("|Contact|"),T("|Side|")};
	PropString sMarkingFace(5, sMarkingFaces, sMarkingFaceName);	
	sMarkingFace.setDescription(T("|Defines the Marking Face|"));
	sMarkingFace.setCategory(category);
	
	String sMalePrompt =T("|Select marking entity(s) (Solids, roof planes, roof elements or polylines)|");
	String sFemalePrompt =T("|Select genbeams to be marked|");		
//End Properties//endregion 

//region OnInsert
// on insert
	if (_bOnInsert)
	{
//		if (insertCycleCount()>1) { eraseInstance(); return; }	
//		String sEntries[] = _ThisInst.getListOfCatalogNames(scriptName());	
//		for (int i=0;i<sEntries.length();i++)
//			sEntries[i].makeUpper();
//		String sKey = _kExecuteKey.makeUpper();
//		int n = sEntries.find(sKey);
//		if (_kExecuteKey.length()>0 && n>-1)
//			setPropValuesFromCatalog(sEntries[n]);
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
		{
			sType.setReadOnly(false);
			sSideMarking.setReadOnly(false);
			dDiameterDrill.setReadOnly(false);
			dDepthDrill.setReadOnly(false);
			showDialog();
		}
		
	// declare a male and female map
		Map mapMale, mapFemale;
		Entity entMales[0], entFemales[0];
			
	// separate selection
		PrEntity ssMale(sMalePrompt, Entity());
		if (ssMale.go())
			entMales.append(ssMale.set());
		
		PrEntity ssFemale(sFemalePrompt , GenBeam());
		if (ssFemale.go())
			entFemales= ssFemale.set();			

	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[0];
		Entity ents[0];
		Point3d pts[0];
		int nProps[] = {nColor };
		double dProps[] = {dMarkerLength,dMarkerOffset,dDiameterDrill,dDepthDrill };
		String sProps[] = {sMarkBounds,sExportAsMark,sSide,sType,sSideMarking,sMarkingFace};
		Map mapTsl;	
		
		int nMarkingFace = sMarkingFaces.find(sMarkingFace);
	// insert one on one		
		for (int i=0;i<entMales.length();i++)	
		{
		// HSB-16807
			if (!entMales[i].bIsValid() &&
				entMales[i].realBody().volume()< pow(dEps,3) &&
				!entMales[i].bIsKindOf(ElementRoof()) && 
				!entMales[i].bIsKindOf(ERoofPlane()) && 
				!entMales[i].bIsKindOf(EntPLine())
				)continue;
			Map mapMale;
			mapMale.appendEntity("MaleEntity", entMales[i]);
			
			for (int f=0;f<entFemales.length();f++)
			{
				mapTsl=Map();
				
				Map mapFemale;
				mapFemale.appendEntity("FemaleEntity", entFemales[f]);
				
				mapTsl.setMap("MaleEntity[]", mapMale);
				mapTsl.setMap("FemaleEntity[]", mapFemale);
				mapTsl.setInt("MarkFromSide",nMarkingFace);
				
				tslNew.dbCreate(scriptName(), vecUcsX, vecUcsY, gbs, ents, pts, nProps, dProps, sProps, _kModelSpace, mapTsl); // create new instance	
			}	
		}

		eraseInstance();
		return;
	}				
//endregion 

//region Display and flags
// Display
	Display dp(nColor);
	int bOk;	// flag if any marking was attached by this instance
	int bMarkBounds=sArNY.find(sMarkBounds,1);
	int bExportAsMark=sArNY.find(sExportAsMark,1);
			
//endregion 	

//region Get Entities
// declare map
	Map mapMale, mapFemale;
	mapMale = _Map.getMap("MaleEntity[]");
	mapFemale = _Map.getMap("FemaleEntity[]");		
	Entity entMales[0];
	Body bdMales[0],bdFemales[0];
	GenBeam gbFemales[0];
	// 
	int nMarkerType = sTypes.find(sType);// marking, drill, midline
	if(nMarkerType==1)
	{ 
	// HSB-18971 drill
		if(dMarkerLength<_dMarkedFaceShrink)
		{ 
			dMarkerLength.set(_dMarkedFaceShrink);
		}
	}
	int nMarkerSide = sSideMarkings.find(sSideMarking);// left right
	int bUseRealbody = _Map.getInt("UseRealBody"), bHasCollectionEntity, bHasBlockRef,bHasMassElement;
	sMarkingFace.setReadOnly(true);
	int bMarkFromSide=_Map.getInt("MarkFromSide");
	_ThisInst.setDrawOrderToFront(true);

// resolve males and females from map
	for (int i=0;i<mapMale.length();i++)
	{
		Entity ent = mapMale.getEntity(i);
		if (!ent.bIsValid()){ continue;}
		ElementRoof elr = (ElementRoof)ent;
		ERoofPlane erp = (ERoofPlane)ent;
		EntPLine epl = (EntPLine)ent;
		MetalPartCollectionEnt ce= (MetalPartCollectionEnt)ent;
		BlockRef bref= (BlockRef)ent;
		
		if (elr.bIsValid() || epl.bIsValid() || erp.bIsValid())
		{ 
			if (_Entity.find(ent)<0)
				_Entity.append(ent);

			if (entMales.find(ent)<0)
			{
				entMales.append(ent);
				bdMales.append(Body());
			}
			continue;
		}
		
		Body bdi;
		if (ce.bIsValid())
		{ 
			bHasCollectionEntity = true;
			CoordSys cse = ce.coordSys();
			String def = ce.definition();
			MetalPartCollectionDef cd (def);
						
			Entity ents[] = cd.entity();			
			for (int j=0;j<ents.length();j++) 
			{ 
				MassElement me = (MassElement)ents[j];
				MassGroup mg = (MassGroup)ents[j];			
				if (me.bIsValid() || mg.bIsValid())
				{ 
					bHasMassElement = true;
					reportMessage("\n"+scriptName()+": " + def + T(" |at location| ") + cse.ptOrg() + T(" |contains mass elements or massgroups, performance will be reduced|"));					
					break;
				}
				 
			}//next j			
			if (bHasMassElement)
				bdi = ent.realBody();
			else
			{ 
				GenBeam gbs[] = cd.genBeam();			
				Body bdc;
				for (int j=0;j<gbs.length();j++) 
				{ 
					Body bd = gbs[j].envelopeBody(true, true); 
					bd.transformBy(cse);	//bd.vis(3);
					bdc.combine(bd);					 
				}//next j
	
				if (bdc.isNull())
					bdi = ent.realBody();
				else
					bdi = bdc;				
			}

			
		}
		else if (bref.bIsValid())
		{ 
			bHasBlockRef= true;
			CoordSys cse = bref.coordSys();
			String def = bref.definition();
			Block block(def);
			
			Entity ents[] = block.entity();			
			for (int j=0;j<ents.length();j++) 
			{ 
				MassElement me = (MassElement)ents[j];
				MassGroup mg = (MassGroup)ents[j];			
				if (me.bIsValid() || mg.bIsValid())
				{ 
					bHasMassElement = true;
					reportMessage("\n"+scriptName()+": " + def + T(" |at location| ") + cse.ptOrg() + T(" |contains mass elements or massgroups, performance will be reduced|"));					
					break;
				}
				 
			}//next j
			
			if (bHasMassElement)
				bdi = ent.realBody();
			else
			{ 
				GenBeam gbs[] = block.genBeam();
				Body bdc;
				for (int j=0;j<gbs.length();j++) 
				{ 
					Body bd = gbs[j].envelopeBody(true, true); 
					bd.transformBy(cse);	bd.vis(3);
					bdc.combine(bd);					 
				}//next j
	
				if (bdc.isNull())
					bdi = ent.realBody();
				else
					bdi = bdc;				
			}	
		}		
		else
			bdi = ent.realBody();
		
		if (!bdi.isNull())
		{
			if (_Entity.find(ent)<0)
				_Entity.append(ent);
			if (entMales.find(ent)<0)
			{
				entMales.append(ent);
				bdMales.append(bdi);
			}			
		}
	}
	
	for (int i=0;i<mapFemale .length();i++)
	{
		Entity ent = mapFemale.getEntity(i);
		Body bdI=ent.realBody();
	// refuse non solids
		if (!ent.bIsValid() && bdI.volume()< pow(dEps,3))continue;			
		if (ent.bIsValid()) 
		{
			GenBeam gb = (GenBeam)ent;
			if (_Entity.find(ent)<0)
			{
				_Entity.append(ent);
			}
			gbFemales.append(gb);
			bdFemales.append(bdI);
		}
	}	

// set dependecies
//	for(int i=0;i<_Entity.length();i++)
//		setDependencyOnEntity(_Entity[i]);
	
	
//endregion 
	
// add marked entity trigger	
	String sAddMarkedTrigger = T("|Add marked entity|");
	addRecalcTrigger(_kContext, sAddMarkedTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddMarkedTrigger )
	{
		Entity ents[0];
		PrEntity ssFemale(sFemalePrompt , GenBeam());
		if (ssFemale.go())
			ents= ssFemale.set();	
			
		for (int i=0;i<ents.length();i++)
			if (gbFemales.find(ents[i])<0)
			{
				gbFemales.append((GenBeam)ents[i]);
				mapFemale.appendEntity("FemaleEntity", ents[i]);	
			}
		_Map.setMap("FemaleEntity[]", mapFemale);	
		setExecutionLoops(2);				
	}	

// make sure at least one male and female is found
	if (entMales.length()<1 || gbFemales.length()<1) 
	{
		reportMessage("\n"+scriptName()+" "+T("|invalid selection set|"));
		eraseInstance();
		return;
	}

	
//region Trigger MarkFromSide
	String sTriggerMarkFromSide = T("|Enforce Mark From Side|");
	if(bMarkFromSide)
		sTriggerMarkFromSide = T("|Remove Mark From Side|");
	addRecalcTrigger(_kContextRoot, sTriggerMarkFromSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerMarkFromSide)
	{
		_Map.setInt("MarkFromSide",!bMarkFromSide);
		sMarkingFace.set(sMarkingFaces[!bMarkFromSide]);
		setExecutionLoops(2);
		return;
	}
//endregion
	
	
// loop all genbeams to be marked
	for (int i=0;i<gbFemales.length();i++)
	{
		GenBeam gb = gbFemales[i];
		Body bdI=bdFemales[i];
	// if the marked genbeam is a beam and has has a curved style get the envelope	
		PLine plEnvelope;
		int bIsCurved;
		if (gb.bIsKindOf(Beam()))
		{
			Beam bm = (Beam)gb;
			CurvedStyle cstyle(bm.curvedStyle());
			if (cstyle.entryName() !=_kStraight)
			{
				plEnvelope=cstyle.closedCurve();
				CoordSys cs(gb.ptCen(), gb.vecX(),gb.vecZ(),-gb.vecY());//vecX, vecX.crossProduct(-vecZ), vecZ)		
				plEnvelope.transformBy(cs);				
				bIsCurved=true;
			}
			if (bMarkFromSide)
			{
				bIsCurved = true;
			}
		}		
		
		// HSB-18330 catching envelope body failure until HSB-18329 is fixed
		if (bDebug)reportMessage("\ntest markings for genbeam " + gb.posnum());
		Body bdFemale = (bUseRealbody || bIsCurved)?bdI:gb.envelopeBody(true, true); // HSB-17937 replaced realbody
		//bdFemale.transformBy(_XW*U(100));
		bdFemale.vis(2);
		
	// loop marker entitities
	// mark every male on a female if contact is found				
		for (int m=0;m<entMales.length();m++)
		{
			int bMidIsMarked;
		// this male entity
			Entity entMale = entMales[m];
			if(!entMale.bIsValid())continue;
			Body bdMale = bdMales[m];
			Point3d ptCen = bdMale.ptCen(); //ptCen.vis(m);
			Beam bmMale=(Beam)entMales[m];
			
			if (bMarkFromSide || bIsCurved)
			{ 
				Vector3d vecSide = gb.vecY();
				PlaneProfile ppGb=bdFemale.shadowProfile(Plane(gb.ptCen(),vecSide));
				PlaneProfile ppMale=bdMale.shadowProfile(Plane(gb.ptCen(),vecSide));
				ppGb.shrink(dEps);
				ppMale.shrink(dEps);
				if(ppGb.intersectWith(ppMale))
				{ 
					vecSide=gb.vecZ();
				}
				PlaneProfile ppEnvelope=bdFemale.shadowProfile(Plane(gb.ptCen(),vecSide));
				PLine plEnvelopes[] = ppEnvelope.allRings(true, false);
				if(plEnvelopes.length()>0)
					plEnvelope = plEnvelopes[0];
				plEnvelope.vis(1);
			}
		// declare the potential curved state for this marking combination	
			int bUseCurved = bIsCurved;
			
		// the marking direction	
			Vector3d vecDir;
			Point3d ptRef;
			
		// declare these directions as test directions	 
			Vector3d vecs[]={gb.vecY(),gb.vecZ(),-gb.vecY(),-gb.vecZ(),gb.vecX(),-gb.vecX()};
			
		// override vectors if the male is a roofplane, elementroof or pline
			PLine plShape;
			int nIsPlineBased;
			if (entMale.bIsKindOf(ERoofPlane())) nIsPlineBased=1;
			else if (entMale.bIsKindOf(ElementRoof())) nIsPlineBased=2;
			else if (entMale.bIsKindOf(EntPLine())) nIsPlineBased=3;
			if(nIsPlineBased>0)
			{
				if (bDebug)reportMessage("\nmale " + m +" is pline based");
				vecs.setLength(1);
				if (nIsPlineBased==1)//ERoofPlane
				{
					ERoofPlane e = (ERoofPlane)entMale;
					plShape = e.plEnvelope();
					vecs[0] = e.coordSys().vecZ();
				}				
				else if (nIsPlineBased==2)//ElementRoof 
				{
					ElementRoof e = (ElementRoof )entMale;
					plShape = e.plEnvelope();
					vecs[0] = e.vecZ();
				}				
				else if (nIsPlineBased==3)//EntPLine
				{
					EntPLine e = (EntPLine)entMale;
					plShape = e.getPLine();
					vecs[0] = plShape.coordSys().vecZ();
//					vecs[0].vis(plShape.ptStart(),3);
				}
				ptCen.setToAverage(plShape.vertexPoints(true));
				
			// unflag curved if pline is in shape plane
				if (bUseCurved && nIsPlineBased>0 && vecs[0].isParallelTo(gb.vecY()))
				{
					bUseCurved =false;
					if (bDebug)reportMessage("...unflagged to have curved contact");
				}
			}// end if (nIsPlineBased>0)
			else if (entMale.bIsKindOf(TslInst()))
			{ 
				TslInst tsl = (TslInst)entMale;
			
			// test t-connected tsl's
				Beam beams[] = tsl.beam();
				int nFemaleIndex =- 1;
				for (int b=0;b<gbFemales.length();b++) 
				{ 
					int n=beams.find(gbFemales[b]); 
					if (n>-1)
					{ 
						nFemaleIndex = n;
						break;
					}
				}
				if (beams.length() < 2)continue;
			// valid t-connection, use coordSys of male beam
				if (nFemaleIndex>-1)
				{ 
					bmMale = beams[(nFemaleIndex==0?1:0)];
					vecs.setLength(0);
					Vector3d vecTest = bmMale.ptCen() - gb.ptCenSolid();
					if (vecTest.dotProduct(gb.vecD(bmMale.vecX())) > 0)
						vecs.append(gb.vecD(bmMale.vecX()));
						
					else
						vecs.append(-gb.vecD(bmMale.vecX()));
//					vecs[0] = bmMale.vecY();
//					vecs[1] = bmMale.vecZ();
//					vecs[2] = -bmMale.vecY();
//					vecs[3] = -bmMale.vecZ();	
				}
			}
			
		// declare variablea for the contact area and some planeprofiles	
			double dContactArea;
			PlaneProfile ppContact, ppMarkingFace, ppMarkedFace;
			int nInd=-1; // the index of the vector which has the best match
			
		// loop all directions and find best marking match	
			for (int v=0;v<vecs.length();v++)
			{
				Vector3d vecY = vecs[v];
				Vector3d vecX = gb.vecX(); vecX.normalize();
				Vector3d vecZ = vecX.crossProduct(vecY); vecZ.normalize();
				
			// if the male entity is of type beam allign the x vector to its most aligned
				if (bmMale.bIsValid())
				{
					Quader qdrMale(bmMale.ptCen(), bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(), bmMale.solidLength(),bmMale.solidWidth(),bmMale.solidHeight(),0,0,0);
					vecX = qdrMale.vecD(vecX);	
				}

			// initially set the location to the surface of the envelope body
//				Point3d pt = gb.ptCenSolid()+vecY*.5*gb.dD(vecY);
				// HSB-9583: use ptcen instead of ptCenSolid, for cutted beams in length the ptcenSolid is not at half gb,dD()
				Point3d pt=gb.ptCen()+vecY*.5*gb.dD(vecY);
			
			// derive contact plane from curved description.
			// this feature could be supported by this tsl, but hsbCAD does not support this kind of tool yet
			// as a workaround the marking is placed on the perpendicular plane
				if ((bUseCurved && vecs.length()> 1 && (v==1 || v==3)) ||		// if 4 directions are tested, index 1 and 3 are the ones to be manipulated
					(bUseCurved && vecs.length()==1))									// plines, roofplanes and elementroofs have only one test direction
				{	
				// get closest point of male center on the envelope
					Point3d ptNext = plEnvelope.closestPointTo(ptCen);
					
				// take a point nearby on the envelope to get the contact plane
					double dDistAtNext = plEnvelope.getDistAtPoint(ptNext);
					Point3d pt1 = plEnvelope.getPointAtDist(dDistAtNext-dEps);	//pt1.vis(1);
					Point3d pt2 = plEnvelope.getPointAtDist(dDistAtNext+dEps);	//pt2.vis(2);
					Vector3d vecX1 = ptNext-pt1;	vecX1.normalize();
					Vector3d vecX2 = ptNext-pt2;	vecX2.normalize();
					Vector3d vecY1 = vecX1.crossProduct(-vecZ);
					if (vecY.dotProduct(vecY1)<0)vecY1*=-1;
					Vector3d vecY2 = vecX2.crossProduct(-vecZ);
					if (vecY.dotProduct(vecY2)<0)vecY2 *=-1;
					
				// use most aligned with original side vector
					int c;
					if (vecY.dotProduct(vecY1)>vecY.dotProduct(vecY2))
					{
						vecY=vecY1;
						c=1;
					}
					else
					{
						vecY=vecY2;
						c=2;
					}			
					pt = ptNext;
//					vecY.vis(pt,c);
//					plEnvelope.vis(1);
				}

			// the contact plane
				Plane pn(pt, vecY); //pn.vis(2);
				vecX=vecX.crossProduct(vecY).crossProduct(-vecY);	vecX.normalize();
				vecZ=vecX.crossProduct(vecY);						vecZ.normalize();
//				vecX.vis(ptCen, 1);
//				vecY.vis(ptCen, 3);
//				vecZ.vis(ptCen, 150);
				
			// continue if the marking entity center is below the contact plane unless it is plshape based 
			// HSB-11552: or bdMale is not sliced
				PlaneProfile ppMaleSlice = bdMale.getSlice(pn);
				if (vecY.dotProduct(ptCen-pt)<dEps && nIsPlineBased<1 && ppMaleSlice.area()<pow(dEps,2))
				{
					continue;
				}
				
			// get marker profile
				PlaneProfile ppMale;
			// from shape
				if (nIsPlineBased>0)
				{
					plShape.projectPointsToPlane(pn,vecY);
					ppMale=PlaneProfile(plShape);
//					ppMale.vis(211);
				}
			// from body contact
				else
				{
					ppMale= bdMale.extractContactFaceInPlane(pn,dEps);
					// HSB-11552: consider first slicing
					if (ppMale.area()<pow(dEps,2))
						ppMale = bdMale.getSlice(pn);
					if (ppMale.area()<pow(dEps,2))
						ppMale = bdMale.shadowProfile(pn);
				}
				
			// get marked profile from body contact
				PlaneProfile ppFemale = bdFemale.extractContactFaceInPlane(pn,dEps);
				if(ppFemale.area()<pow(dEps,2))
					ppFemale = bdFemale.extractContactFaceInPlane(pn,U(30));
			// debug warning
				if (bDebug && ppFemale.area()<pow(dEps,2))
				{
					reportMessage("\n	female area to small in view " + v + " " + vecs[v] + "\n		collected contact area = " +ppMarkedFace.area() + " should be > 0");
				}
			// adjust marking pp to be rectangular of  bounds if selected
				if(ppMale.area()<pow(dEps,2) && bMarkBounds && (nIsPlineBased<1 || !bUseCurved))
				{
					LineSeg seg=ppMale.extentInDir(vecX);
					PLine plBounds;
					plBounds.createRectangle(seg, vecX, vecZ);
					plBounds.vis(6);
					ppMale=PlaneProfile(plBounds);	
				}
			// debug display of ppMale
				if (bDebug)
				{
					Display dpX(v);
					PlaneProfile pp=ppMale;
					dpX.draw(pp.extentInDir(vecX));
					pp.transformBy(vecY*U(1));
					dpX.draw(pp);
				}	
				ppMale.vis(v);
				ppMale.shrink(-(U(.1) + dMarkerOffset));
			// get intersional profile of marking and marked
				
				PlaneProfile ppInt = ppMale;
				// HSB-20007: sometimes the ppFemale is not a closed pp; the following corrects it
				ppFemale.shrink(U(1));
				ppFemale.shrink(U(-1));
				ppFemale.shrink(U(-1));
				ppFemale.shrink(U(1));
				
				int bIntersect=ppInt.intersectWith(ppFemale);
				
//				ppInt.extentInDir(vecX).vis(v);
				ppMale.shrink(U(.1));
				ppInt.shrink(U(.1));
				
//				dp.draw(ppInt);
				double test = ppInt.area();
			// set direction
				if (ppInt.area()> dContactArea + pow(dEps,2))
				{
					dContactArea=ppInt.area();
					ppContact=ppInt;
					ppMarkingFace=ppMale ; // store the marked face to validate corner points
					ppMarkedFace = ppFemale;
					ptRef = ppContact.extentInDir(vecX).ptMid();
					vecDir=vecY;
					nInd=v;
				}			
			}// next v view
			//_Pt0 = ptRef;
		// check if midline can be selected
		// should/darf be selected only when ppMarkingFace not inside ppMarkedFace
			int bMarkingOutsideMarked = true;
			Point3d ptMiddle, ptMiddle2;
			PlaneProfile ppMarkingFaceOutside(ppMarkingFace.coordSys());
			PlaneProfile ppMarkedFaceOutside(ppMarkedFace.coordSys());
			{ 
				ppMarkingFace.shrink(U(-30));
				PLine plsMarking[] = ppMarkingFace.allRings(true, false);
				PLine plsMarked[] = ppMarkedFace.allRings(true, false);
				for (int ipl=0;ipl<plsMarking.length();ipl++) 
				{ 
					ppMarkingFaceOutside.joinRing(plsMarking[ipl],_kAdd); 
				}//next ipl
				for (int ipl=0;ipl<plsMarked.length();ipl++) 
				{ 
					ppMarkedFaceOutside.joinRing(plsMarked[ipl],_kAdd); 
				}//next ipl
				PlaneProfile ppSubtract = ppMarkingFaceOutside;
				int bSubtract = ppSubtract.subtractProfile(ppMarkedFaceOutside);
				int bMiddlePtFound = true;
				if(ppSubtract.area()>pow(dEps,2))
				{ 
					bMarkingOutsideMarked = true;
					PLine plMarkingFaceOutsides[] = ppMarkingFaceOutside.allRings(true, false);
					if(plMarkingFaceOutsides.length()==0)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
						eraseInstance();
						return;
					}
					PLine plMarkingFaceOutside = plMarkingFaceOutsides[0];
					PLine plMarkedFaceOutsides[] = ppMarkedFaceOutside.allRings(true, false);
					if(plMarkedFaceOutsides.length()==0)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
						eraseInstance();
						return;
					}
					PLine plMarkedFaceOutside = plMarkedFaceOutsides[0];
					Plane pnPl(plMarkingFaceOutside.coordSys().ptOrg(),plMarkingFaceOutside.coordSys().vecZ());
					plMarkingFaceOutside.projectPointsToPlane(pnPl,plMarkingFaceOutside.coordSys().vecZ());
					plMarkedFaceOutside.projectPointsToPlane(pnPl,plMarkingFaceOutside.coordSys().vecZ());
					Point3d pts[] = plMarkingFaceOutside.intersectPLine(plMarkedFaceOutside);
					for (int ipt=0;ipt<pts.length();ipt++) 
					{ 
						ptMiddle += pts[ipt];
					}//next ipt
					if(pts.length()==0)
					{ 
						bMiddlePtFound = false;
						
//						reportMessage("\n"+scriptName()+" "+T("|Unexpected: division by zero|"));
//						eraseInstance();
//						return;
					}
					if(bMiddlePtFound)
					{ 
						ptMiddle /= (pts.length());
					// 
	//					ptMiddle = ppMarkedFaceOutside.closestPointTo(ptMiddle);
	//					ppMarkedFaceOutside.coordSys().vis(3);
						Vector3d vecMiddleDir = gb.vecX().crossProduct(ppSubtract.coordSys().vecZ());
						GenBeam gbMale = (GenBeam)entMale;
						if(gbMale.bIsValid())
						{ 
							Quader qdMale(gbMale.ptCen(), gbMale.vecX(), gbMale.vecY(), gbMale.vecZ(),
								gbMale.dL(), gbMale.dW(), gbMale.dH());
							vecMiddleDir = qdMale.vecD(vecMiddleDir);
						}
						Point3d ptsIntersects[]=plMarkedFaceOutside.intersectPoints(ptMiddle,vecMiddleDir);
						if(ptsIntersects.length()>0)
						{
							Point3d _ptMiddle = ptsIntersects[0];
							double dDist = -U(10e8);
							for (int ipt=0;ipt<ptsIntersects.length();ipt++) 
							{ 
								double dDistI=vecMiddleDir.dotProduct(ptsIntersects[ipt]);
								if(dDistI>dDist)
								{ 
									dDist=dDistI;
									_ptMiddle=ptsIntersects[ipt];
								}
							}//next ipt
							ptMiddle = _ptMiddle;
						}
						
		//				Quader qdMale(bdMale.ptCen(), bdMale.vec)
						Point3d ptMiddle2Test = ptMiddle + vecMiddleDir * U(10);
		//				ptMiddle2Test.vis(6);
						if(ppMarkedFaceOutside.pointInProfile(ptMiddle2Test)==_kPointInProfile)
						{ 
							ptMiddle2 = ptMiddle + vecMiddleDir * dMarkerLength;
						}
						else
						{ 
							ptMiddle2 = ptMiddle - vecMiddleDir * dMarkerLength;
						}
						ppMarkingFace.shrink(U(30));
						ppMarkingFaceOutside=ppMarkingFace;
					}
				}
				if(!bMiddlePtFound || !(ppSubtract.area()>pow(dEps,2)))
				{ 
					bMarkingOutsideMarked = true;
					ppMarkingFace.shrink(U(30));
					ppMarkingFaceOutside=ppMarkingFace;
					ppSubtract = ppMarkingFaceOutside;
					PLine plMarkingFaceOutsides[] = ppMarkingFaceOutside.allRings(true, false);
					if(plMarkingFaceOutsides.length()==0)
					{ 
//						reportMessage("\n"+scriptName()+" "+T("|unexpected: No marking face|"));
						//eraseInstance();
						return;
					}
					PLine plMarkingFaceOutside = plMarkingFaceOutsides[0];
					plMarkingFaceOutside.vis(3);
					PLine plMarkedFaceOutsides[] = ppMarkedFaceOutside.allRings(true, false);
					if(plMarkedFaceOutsides.length()==0)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected: No marked face|"));
						reportMessage("\n"+scriptName()+" "+T("|Instance is deleted|"));
						eraseInstance();
						return;
					}
					
					PLine plMarkedFaceOutside = plMarkedFaceOutsides[0];
//					plMarkingFaceOutside.vis(5);
//					Point3d pts[] = plMarkingFaceOutside.intersectPLine(plMarkedFaceOutside);
//					for (int ipt=0;ipt<pts.length();ipt++) 
//					{ 
//						pts[ipt].vis(3);
//						ptMiddle += pts[ipt];
//					}//next ipt
//					ptMiddle /= (pts.length());
//					ptMiddle.vis(6);
				// 
//					ptMiddle = ppMarkedFaceOutside.closestPointTo(ptMiddle);
//					ppMarkedFaceOutside.coordSys().vis(3);
					Vector3d vecMiddleDir = gb.vecX().crossProduct(ppSubtract.coordSys().vecZ());
					GenBeam gbMale = (GenBeam)entMale;
					if(gbMale.bIsValid())
					{ 
						Quader qdMale(gbMale.ptCen(), gbMale.vecX(), gbMale.vecY(), gbMale.vecZ(),
							gbMale.dL(), gbMale.dW(), gbMale.dH());
						vecMiddleDir = qdMale.vecD(vecMiddleDir);
					}
					else
					{ 
						BlockRef bRef=(BlockRef)entMale;
						if(bRef.bIsValid())
						{ 
							CoordSys csBlock = bRef.coordSys();
							Quader qdMale(csBlock.ptOrg(), csBlock.vecX(), csBlock.vecY(), csBlock.vecZ(),
							U(200), U(200), U(200));
							vecMiddleDir = qdMale.vecD(vecMiddleDir);
						}
					}
					
					ptMiddle=ppMarkingFaceOutside.extentInDir(vecMiddleDir).ptMid();
//					vecMiddleDir.vis(ptMiddle);
//					Point3d ptsIntersects[]=plMarkedFaceOutside.intersectPoints(ptMiddle,vecMiddleDir);
					Point3d ptsIntersects[]=plMarkingFaceOutside.intersectPoints(ptMiddle,vecMiddleDir);
					if(ptsIntersects.length()>0)
					{
						Point3d _ptMiddle = ptsIntersects[0];
						double dDist = -U(10e8);
						for (int ipt=0;ipt<ptsIntersects.length();ipt++) 
						{ 
							double dDistI=vecMiddleDir.dotProduct(ptsIntersects[ipt]);
							if(dDistI>dDist)
							{ 
								dDist=dDistI;
								_ptMiddle=ptsIntersects[ipt];
							}
						}//next ipt
//						_ptMiddle.vis(3);
						ptMiddle = _ptMiddle;
					}
	//				Quader qdMale(bdMale.ptCen(), bdMale.vec)
					Point3d ptMiddle2Test = ptMiddle + vecMiddleDir * U(10);
	//				ppMarkedFaceOutside.transformBy(U(2000) * (_XW + _YW));
	//				ppMarkedFaceOutside.vis(7);
	//				ppMarkedFaceOutside.transformBy(-U(2000) * (_XW + _YW));
	//				ptMiddle2Test.vis(6);
					if(ppMarkedFaceOutside.pointInProfile(ptMiddle2Test)==_kPointInProfile)
					{ 
						ptMiddle2 = ptMiddle + vecMiddleDir * dMarkerLength;
					}
					else
					{ 
						ptMiddle2 = ptMiddle - vecMiddleDir * dMarkerLength;
					}
				}
				
				if (nMarkerType == 2) //Mark middle line
				{
					int bMessage;
//					PlaneProfile ppMarked = ppMarkingFaceOutside;
					PlaneProfile ppMarked = ppMarkedFaceOutside;
					ppMarked.vis(2);
//					ppMarked.intersectWith(ppMarkedFaceOutside);
					ppMarked.intersectWith(ppMarkingFaceOutside);
					if(ppMarked.area() > pow(U(1),2))
					{
						
						CoordSys csEnt = entMale.coordSys();
//						Vector3d vecEnt1 = csEnt.vecX().isParallelTo(vecDir) ? csEnt.vecY() : csEnt.vecX();
						Vector3d vecEnt1 = csEnt.vecX().isPerpendicularTo(vecDir)?csEnt.vecX():csEnt.vecY();
						Vector3d vecEnt2 = vecDir.crossProduct(vecEnt1);
						BlockRef bRef=(BlockRef)entMale;
						if (bRef.bIsValid())
						{
							CoordSys csBlock = bRef.coordSys();
							vecEnt1 = csBlock.vecX().isPerpendicularTo(vecDir)?csBlock.vecX():csBlock.vecY();
							vecEnt2 = vecDir.crossProduct(vecEnt1);
						}
						LineSeg segPP = ppMarked.extentInDir(vecEnt1);
						vecEnt1.vis(ptCen);
						vecEnt2.vis(ptCen);
						ppMarked.createRectangle(segPP, vecEnt1, vecEnt2);
					// project to ppMarkedFace with direction of ppMarkingFace
						PlaneProfile _ppMarked = ppMarked;
						PLine plMarkedOut[] = _ppMarked.allRings(true, false);
						PLine plMarkedOutProj[0],plMarkedInProj[0];
						PLine plMarkedIn[] = _ppMarked.allRings(false, true);
					
						for (int ipl=0;ipl<plMarkedOut.length();ipl++) 
						{ 
							PLine plI= plMarkedOut[ipl];
							plI.projectPointsToPlane(Plane(ppMarkedFace.coordSys().ptOrg(),ppMarkedFace.coordSys().vecZ()),
								ppMarked.coordSys().vecZ()); 
							plMarkedOutProj.append(plI);
						}//next ipl
						for (int ipl=0;ipl<plMarkedIn.length();ipl++) 
						{ 
							PLine plI= plMarkedIn[ipl];
							plI.projectPointsToPlane(Plane(ppMarkedFace.coordSys().ptOrg(),ppMarkedFace.coordSys().vecZ()),
								ppMarked.coordSys().vecZ()); 
							plMarkedInProj.append(plI);
						}//next ipl
						// create in the plane of ppMarkedFace
						ppMarked = PlaneProfile(ppMarkedFace.coordSys());
						for (int ipl=0;ipl<plMarkedOutProj.length();ipl++) 
						{ 
							ppMarked.joinRing(plMarkedOutProj[ipl],_kAdd); 
						}//next ipl
						for (int ipl=0;ipl<plMarkedInProj.length();ipl++) 
						{ 
							ppMarked.joinRing(plMarkedInProj[ipl],_kSubtract); 
						}//next ipl
						
						Point3d ptPPMid = ppMarked.ptMid();
						//region Check marked genbeam in first direction
						LineSeg segsEnt1[] = ppMarkedFaceOutside.splitSegments(LineSeg(ptPPMid - vecEnt1 * U(10000), ptPPMid + vecEnt1 * U(10000)), true);
						if(segsEnt1.length() < 1)
							bMessage = true;
						segsEnt1 = ppMarked.splitSegments(segsEnt1, false);
						double dEnt1;
						for(int is=0; is < segsEnt1.length();is++)
							dEnt1 += segsEnt1[is].length();								
						//End Check marked genbeam in first direction//endregion 
						//region Check marked genbeam in secound direction
						LineSeg segsEnt2[] = ppMarkedFaceOutside.splitSegments(LineSeg(ptPPMid - vecEnt2 * U(10000), ptPPMid + vecEnt2 * U(10000)), true);
						if(segsEnt2.length() < 1)
							bMessage = true;
							
						segsEnt2 = ppMarked.splitSegments(segsEnt2, false);
						double dEnt2;
						for(int is =0; is < segsEnt2.length();is++)
							dEnt2 += segsEnt2[is].length();									
						//End Check marked genbeam in secound direction//endregion 
							
						//region Find most reasonable direction for middle marking and set the points
						LineSeg segs12[0];
						segs12 = (dEnt2 > dEnt1) ? segsEnt1 : segsEnt2;
						Vector3d vec12 = (dEnt2 > dEnt1) ? vecEnt1 : vecEnt2;		
						Vector3d vecMiddleDir;
						if(vecEnt1.isParallelTo(_ZW) || vecEnt2.isParallelTo(_ZW))
						{
							ptMiddle = ptPPMid + _ZW * 0.5 * abs(_ZW.dotProduct(segPP.ptEnd() - segPP.ptStart()));
							ptMiddle2 = ptMiddle - _ZW * dMarkerLength;	
							vecMiddleDir = _ZW;
						}
						else if(segs12.length() < 1)
						{
							ptMiddle = ptPPMid + vec12 * 0.5 * abs(vec12.dotProduct(segPP.ptEnd() - segPP.ptStart()));
							ptMiddle2 = ptMiddle - vec12 * dMarkerLength;
							vecMiddleDir =vec12;
						}
						else if(segs12.length() == 1)
						{
							Vector3d vec(ptPPMid - segs12.first().ptStart());
							vec.normalize();
							ptMiddle = ptPPMid + vec * 0.5 * abs(vec.dotProduct(segPP.ptEnd() - segPP.ptStart()));
							ptMiddle2 = ptMiddle - vec * dMarkerLength;
							vecMiddleDir =vec;
						}	
						else
						{
							double dSmallest = 10000;
							LineSeg segSmallest;
							for(int is =0; is < segs12.length();is++)
							{
								if(segs12[is].length() < dSmallest)
								{
									segSmallest = segs12[is];
									dSmallest = segs12[is].length();
								}
							}
							
							Vector3d vec(segSmallest.ptStart() - ptPPMid);
							vec.normalize();
							double dd = abs(vec.dotProduct(segPP.ptEnd() - segPP.ptStart()));
							ptMiddle = ptPPMid + vec * 0.5 * abs(vec.dotProduct(segPP.ptEnd() - segPP.ptStart()));
							ptMiddle2 = ptMiddle - vec * dMarkerLength;
							vecMiddleDir =vec;
							
							
						}
					// check if point inside the marked area
						if(ppMarkedFaceOutside.pointInProfile(ptMiddle)==_kPointOutsideProfile)
						{ 
							// find the new point
							PLine plMarkedFaceOutsides[] = ppMarkedFaceOutside.allRings(true, false);
							if(plMarkedFaceOutsides.length()==0)
							{ 
								reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
								eraseInstance();
								return;
							}
							
							PLine plMarkedFaceOutside = plMarkedFaceOutsides[0];
							Point3d ptsIntersects[]=plMarkedFaceOutside.intersectPoints(ptMiddle,vecMiddleDir);
							if(ptsIntersects.length()>0)
							{
								Point3d _ptMiddle = ptsIntersects[0];
								double dDist = -U(10e8);
								for (int ipt=0;ipt<ptsIntersects.length();ipt++) 
								{ 
									double dDistI=vecMiddleDir.dotProduct(ptsIntersects[ipt]);
									if(dDistI>dDist)
									{ 
										dDist=dDistI;
										_ptMiddle=ptsIntersects[ipt];
									}
								}//next ipt
		//						_ptMiddle.vis(3);
								ptMiddle = _ptMiddle;
								ptMiddle2 = ptMiddle - vecMiddleDir * dMarkerLength;
							}
						}
						ptMiddle.vis(6);
						ptMiddle2.vis(6);
					}
					else
						bMessage = true;								
					//End Find most reasonable direction for middle marking and set the points//endregion 
					
					if(bMessage)
					{
						reportMessage("\n"+scriptName()+" "+T("|Marking area too small. Instance is deleted|"));
						eraseInstance();
						return;
					}
				}
			}
		// unflag curved
			if (bUseCurved && vecs.length()>1 && (nInd==0 || nInd==2))
			{
			// HSB-18109: this condition only for curved beams, not when it is enforced via trigger
				if(!bMarkFromSide)
				{ 
	//				if(bMarkFromSide)
	//				{ 
	//					_Map.setInt("MarkFromSide", false);
	//					sMarkingFace.set(sMarkingFaces[0]);
	//					reportMessage("\n"+scriptName()+" "+T("|Curved contact not supported|"));
	//				}
					bUseCurved =false;
				}
			}
//			dp.draw(ppContact);	
		// analyse contact face
			Point3d ptsCorner[0];
			// remove openings less then a certain area
			PlaneProfile _ppContact(ppContact.coordSys());
			{ 
				PLine plsOps[] = ppContact.allRings(false, true);
				PLine plsNoOps[] = ppContact.allRings(true, false);
				for (int ipl=0;ipl<plsNoOps.length();ipl++) 
				{ 
					_ppContact.joinRing(plsNoOps[ipl],_kAdd); 
				}//next ipl
//				double dd = pow(U(20), 2);
				for (int ipl=0;ipl<plsOps.length();ipl++) 
				{ 
					if(plsOps[ipl].area()<pow(U(20),2))continue; 
					_ppContact.joinRing(plsOps[ipl],_kSubtract); 
				}//next ipl
				_ppContact.shrink(-U(20));
				_ppContact.shrink(U(20));
				ppContact = _ppContact;
			}
//			ppContact.vis(2);
			if (ppContact.area()>pow(dEps,2))
			{
			// get rings
				PLine plRings[] = ppContact.allRings();
				int bIsOp[] = ppContact.ringIsOpening();			
			// create a hull of all non openings if more than one ring is found
				if (plRings.length()>1)
				{				
					Point3d ptsHull[0];
					for (int r=0;r<plRings.length();r++)
						if (!bIsOp[r]) ptsHull.append(plRings[r].vertexPoints(true));
					PLine plHull;
					plHull.createConvexHull(Plane(ptRef, vecDir), ptsHull);
//					plHull.vis(3);
					ptsCorner=plHull.vertexPoints(true);
				}
				else if (plRings.length()==1)
				{
					ptsCorner=plRings[0].vertexPoints(true);					
				}	
			}// END IF valid contact face

		// set _Pt0 once if multiple markers
			if (ptsCorner.length()>0 && !bOk)
				_Pt0=ptRef;
		// plane of contact parallel with plane of marking we have corner markings
		// if not we have options left right available
//		vecDir.vis(ptRef);
			int bContactParallelMarking;
			{ 
				Vector3d vecContact = ppContact.coordSys().vecZ();
				Vector3d vecMarking = vecDir;
				if (bUseCurved )
				{ 
					vecMarking = gb.vecX().crossProduct(vecDir);
				}
				if(abs(abs(vecContact.dotProduct(vecMarking))-1)<dEps)
					bContactParallelMarking = true;
			}
			if(!bContactParallelMarking)
			{ 
				// left,right both
				sSideMarking.setReadOnly(false);
				int nIndexType = sTypesCurved.find(sType);
				if (nIndexType >- 1)
				{
					// selected sProductis contained in sProducts
					sType=PropString(3,sTypesCurved,sTypeName,nIndexType);
				}
				else
				{
					// 
					sType=PropString(3,sTypesCurved,sTypeName,0);
					sType.set(sTypesCurved[0]);
				}
				sType.setReadOnly(false);
				if(nMarkerType==1)
				{ 
				// drill parameters depth,diameter relevant
					dDepthDrill.setReadOnly(false);
					dDiameterDrill.setReadOnly(false);
				}
				else
				{ 
				// drill parameters depth,diameter not relevant for corner,midline
					dDepthDrill.setReadOnly(true);
					dDiameterDrill.setReadOnly(true);
				}
			}
			else
			{  
				// corner
				// types marking,drill, midline
				sType.setReadOnly(false);
				if(nMarkerType==1)
				{ 
					dDepthDrill.setReadOnly(false);
					dDiameterDrill.setReadOnly(false);
				}
				else
				{ 
					dDepthDrill.setReadOnly(true);
					dDiameterDrill.setReadOnly(true);
				}
				
			}
			int nNumMarkerlines;
			Point3d ptMiddleSide, ptMiddleSide2;
			if(nMarkerSide==3)
			{ 
				// Middle is selected from left,right,both,middle
				for (int ipt=0;ipt<ptsCorner.length();ipt++) 
				{ 
					ptMiddleSide+= ptsCorner[ipt]; 
				}//next ipt
				if(ptsCorner.length()==0)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|unexpected: division by 0|"));
					eraseInstance();
					return;
				}
				ptMiddleSide /= (ptsCorner.length());
			}
			for (int j=0;j<ptsCorner.length();j++)
			{
				Point3d ptCorner = ptsCorner[j];
//				ptCorner.vis(j);
				
				int x = j+1;
				if (j==ptsCorner.length()-1)x=0;
				Vector3d vecXSeg = ptsCorner[x]-ptsCorner[j];
				double d = vecXSeg.length();
				vecXSeg.normalize();
				
				Point3d pt1=ptsCorner[j]; //vecXSeg.vis(pt1,1);
				Point3d pt2=ptsCorner[x]; //pt2.vis(4);
//			ptRef.vis(4);
//			pt1.vis(4);
			// flag if this marked genbeam has received any marking
				int bThisHasMarking;
		
			// mark any shape based not at contact if curved female
				if (bUseCurved )// &&  nIsPlineBased>0)
				{
//					vecDir.vis(pt1);
					Point3d pt3 = pt1-vecDir*dMarkerLength;
					pt3.vis(1);
				// autocorrect direction of markerline if second point would be outside of envelope
					if (PlaneProfile(plEnvelope).pointInProfile(pt3)==_kPointOutsideProfile)pt3 = pt1+vecDir*dMarkerLength;
					Vector3d vecMark = gb.vecX().crossProduct(vecDir);
//					vecMark.vis(pt1);
//					vecDir.vis(pt1);
//					
				// place pline based markers only on one side of the marked entity	
					if(vecMark.dotProduct(pt1-ptRef )<0)
					{
						continue;
					}
//					vecMark.vis(pt3,3);		
				// add the marker	
					int bDrawMarking=false;
					if(!bContactParallelMarking)
					{ 
						int bRightSide = gb.vecX().dotProduct(pt1 - ptRef)>0;
						if((nMarkerSide==1 && bRightSide) ||
							(nMarkerSide==0 && !bRightSide) || nMarkerSide==2 || nMarkerSide==3)
						{ 
							bDrawMarking = true;
						}
					}
					else
					{ 
						bDrawMarking = true;
						// condider type marking, drill, midline
					}
					if ((sSide == T("|Back|") || sSide == T("|Both|")) && bDrawMarking)
					{
						if(nMarkerSide!=3)
						{ 
							// left,right or both
							if(nMarkerType==0)
							{ 
							// mark
								Point3d ptFace=gb.ptCen()+.5*gb.dD(vecMark)*gb.vecD(vecMark);
								Point3d pt1Face=pt1+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-pt1);
								Point3d pt3Face=pt3+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-pt3);
								dp.draw(PLine(pt1Face,pt3Face));
								MarkerLine ml1(pt1Face, pt3Face, vecMark );
								if (bExportAsMark)
								{
									ml1.exportAsMark(true);
								}	
								gb.addTool(ml1);
								nNumMarkerlines++;
								bThisHasMarking=true;
							}
							else
							{ 
								// Drill
								Point3d ptDrill,ptDrill2;
								Point3d ptFace = gb.ptCen()+.5 * gb.dD(vecMark)*gb.vecD(vecMark);
								PlaneProfile ppMarkedFaceShrink(plEnvelope.coordSys());
								ppMarkedFaceShrink.joinRing(plEnvelope,_kAdd); 
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								ppMarkedFaceShrink.vis(2);
								Point3d pt1Face=pt1+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-pt1);
								Point3d pt3Face=pt3+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-pt3);
								if(ppMarkedFaceShrink.pointInProfile(pt1Face)==_kPointInProfile)
								{ 
									ptDrill = pt1Face;
								}
								else if(ppMarkedFaceShrink.pointInProfile(pt3Face)==_kPointInProfile)
								{ 
									ptDrill = pt3Face;
								}
								vecMark.vis(ptDrill);
								ptDrill2 = ptDrill-gb.vecD(vecMark)*dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(vecMark), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(vecMark)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
						}
						else
						{ 
							// middle is selected
							if(nMarkerType==0)
							{ 
//								ptMiddleSide2 = ptMiddleSide - vecDir * dMarkerLength;
								Vector3d vecMiddleDir = vecDir;
								Point3d ptMiddleSide2 = ptMiddleSide + vecDir * dMarkerLength;
								if((pt3-pt1).dotProduct(ptMiddleSide2-ptMiddleSide)<0)
								{ 
									ptMiddleSide2 = ptMiddleSide - vecDir * dMarkerLength;
								}
								
								Point3d ptFace=gb.ptCen()+.5*gb.dD(vecMark)*gb.vecD(vecMark);
								Point3d ptMiddleSideFace=ptMiddleSide
									+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-ptMiddleSide);
								Point3d ptMiddleSide2Face=ptMiddleSide2
									+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-ptMiddleSide2);
								dp.draw(PLine(ptMiddleSideFace,ptMiddleSide2Face));
								MarkerLine ml1(ptMiddleSideFace, ptMiddleSide2Face, vecMark );
								if (bExportAsMark)
								{
									ml1.exportAsMark(true);
								}	
								gb.addTool(ml1);
								nNumMarkerlines++;
								bThisHasMarking=true;
							}
							else
							{ 
							// drill
								Point3d ptDrill,ptDrill2;
								Vector3d vecMiddleDir = vecDir;
								Point3d ptMiddleSide2 = ptMiddleSide + vecDir * dMarkerLength;
								if((pt3-pt1).dotProduct(ptMiddleSide2-ptMiddleSide)<0)
								{ 
									ptMiddleSide2 = ptMiddleSide - vecDir * dMarkerLength;
								}
								Point3d ptFace=gb.ptCen()+.5*gb.dD(vecMark)*gb.vecD(vecMark);
								Point3d ptMiddleSideFace=ptMiddleSide
									+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-ptMiddleSide);
								Point3d ptMiddleSide2Face=ptMiddleSide2
									+gb.vecD(vecMark)*gb.vecD(vecMark).dotProduct(ptFace-ptMiddleSide2);
								PlaneProfile ppMarkedFaceShrink(plEnvelope.coordSys());
								ppMarkedFaceShrink.joinRing(plEnvelope,_kAdd); 
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								if(ppMarkedFaceShrink.pointInProfile(ptMiddleSideFace)==_kPointInProfile)
								{ 
									ptDrill = ptMiddleSideFace;
								}
								else if(ppMarkedFaceShrink.pointInProfile(ptMiddleSide2Face)==_kPointInProfile)
								{ 
									ptDrill = ptMiddleSide2Face;
								}
								ptDrill.vis(1);
								ptDrill2 = ptDrill-gb.vecD(vecMark)*dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(vecMark), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(vecMark)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
						}
					}
					
					if ((sSide == T("|Front|") || sSide == T("|Both|")) && bDrawMarking)
					{
						if(nMarkerSide!=3)
						{ 
							if(nMarkerType==0)
							{ 
							// mark
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecMark) * gb.vecD(-vecMark);
								Point3d pt1Face=pt1+gb.vecD(-vecMark) * gb.vecD(-vecMark).dotProduct(ptFace - pt1);
								Point3d pt3Face=pt3+gb.vecD(-vecMark) * gb.vecD(-vecMark).dotProduct(ptFace - pt3);
								
								MarkerLine ml1(pt1Face, pt3Face, -vecMark );
								if (bExportAsMark)
								{
									ml1.exportAsMark(true);
								}	
								gb.addTool(ml1);
								dp.draw(PLine(pt1Face, pt3Face));
								nNumMarkerlines++;
								bThisHasMarking=true;
							}
							else
							{ 
								// Drill
								Point3d ptDrill,ptDrill2;
								Point3d ptFace = gb.ptCen()+.5 * gb.dD(-vecMark)*gb.vecD(-vecMark);
								PlaneProfile ppMarkedFaceShrink(plEnvelope.coordSys());
								ppMarkedFaceShrink.joinRing(plEnvelope,_kAdd); 
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								Point3d pt1Face=pt1+gb.vecD(-vecMark)*gb.vecD(-vecMark).dotProduct(ptFace-pt1);
								Point3d pt3Face=pt3+gb.vecD(-vecMark)*gb.vecD(-vecMark).dotProduct(ptFace-pt3);
								if(ppMarkedFaceShrink.pointInProfile(pt1Face)==_kPointInProfile)
								{ 
									ptDrill = pt1Face;
								}
								else if(ppMarkedFaceShrink.pointInProfile(pt3Face)==_kPointInProfile)
								{ 
									ptDrill = pt3Face;
								}
								vecMark.vis(ptDrill);
								ptDrill2 = ptDrill-gb.vecD(-vecMark)*dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
								ptDrill.vis(3);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(-vecMark), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(-vecMark)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
						}
						else
						{ 
							// middle is selected
							if(nMarkerType==0)
							{ 
								Vector3d vecMiddleDir = vecDir;
								Point3d ptMiddleSide2 = ptMiddleSide + vecDir * dMarkerLength;
								if((pt3-pt1).dotProduct(ptMiddleSide2-ptMiddleSide)<0)
								{ 
									ptMiddleSide2 = ptMiddleSide - vecDir * dMarkerLength;
								}
								
								
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(-vecMark) * gb.vecD(-vecMark);
								Point3d ptMiddleSideFace=ptMiddleSide
									+gb.vecD(vecMark) * gb.vecD(vecMark).dotProduct(ptFace - ptMiddleSide);
								Point3d ptMiddleSide2Face=ptMiddleSide2
									+gb.vecD(vecMark) * gb.vecD(vecMark).dotProduct(ptFace - ptMiddleSide2);
								dp.draw(PLine(ptMiddleSideFace, ptMiddleSide2Face));	
								MarkerLine ml1(ptMiddleSideFace, ptMiddleSide2Face, -vecMark );
								if (bExportAsMark)
								{
									ml1.exportAsMark(true);
								}	
								gb.addTool(ml1);
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
							else
							{ 
							// drill
								Point3d ptDrill,ptDrill2;
								Vector3d vecMiddleDir = vecDir;
								Point3d ptMiddleSide2 = ptMiddleSide + vecDir * dMarkerLength;
								if((pt3-pt1).dotProduct(ptMiddleSide2-ptMiddleSide)<0)
								{ 
									ptMiddleSide2 = ptMiddleSide - vecDir * dMarkerLength;
								}
								Point3d ptFace=gb.ptCen()+.5*gb.dD(-vecMark)*gb.vecD(-vecMark);
								Point3d ptMiddleSideFace=ptMiddleSide
									+gb.vecD(-vecMark)*gb.vecD(-vecMark).dotProduct(ptFace-ptMiddleSide);
								Point3d ptMiddleSide2Face=ptMiddleSide2
									+gb.vecD(-vecMark)*gb.vecD(-vecMark).dotProduct(ptFace-ptMiddleSide2);
								PlaneProfile ppMarkedFaceShrink(plEnvelope.coordSys());
								ppMarkedFaceShrink.joinRing(plEnvelope,_kAdd); 
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								if(ppMarkedFaceShrink.pointInProfile(ptMiddleSideFace)==_kPointInProfile)
								{ 
									ptDrill = ptMiddleSideFace;
								}
								else if(ppMarkedFaceShrink.pointInProfile(ptMiddleSide2Face)==_kPointInProfile)
								{ 
									ptDrill = ptMiddleSide2Face;
								}
								ptDrill.vis(1);
								ptDrill2 = ptDrill-gb.vecD(-vecMark)*dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(-vecMark), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(-vecMark)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
								nNumMarkerlines++;				
								bThisHasMarking=true;	
							}
						}
					}
				//
					if(bThisHasMarking)
					{ 
						if (nMarkerType==2 || nMarkerSide==3)
						{ 
						// HSB-18971 Midline
							break;
						}
					}
				}
			// marker points are overlapping due to mareker length -> create only one marker line
				else if (2*dMarkerLength>=d && ppMarkingFace.pointInProfile((pt1+pt2)/2)==_kPointOnRing)
				{
					if ((sSide == T("|Back|") || sSide == T("|Both|"))&&nMarkerType!=2)
					{
					// not a midline marking
						//HSB-22662
						MarkerLine ml1(pt1, pt2, -vecDir);
						if (bExportAsMark)
						{
							ml1.exportAsMark(true);
						}	
						gb.addTool(ml1);	
						dp.draw(PLine(pt1, pt2));	
						nNumMarkerlines++;				
						bThisHasMarking=true;
					}
					
					if ((sSide == T("|Front|") || sSide == T("|Both|"))&&nMarkerType!=2)
					{
						//HSB-22662
						MarkerLine ml1(pt1, pt2, vecDir);
						if (bExportAsMark)
						{
							ml1.exportAsMark(true);
						}	
						gb.addTool(ml1);	
						dp.draw(PLine(pt1, pt2));	
						nNumMarkerlines++;				
						bThisHasMarking=true;
					}
				//
					if(bThisHasMarking)
					{ 
						if (nMarkerType==2 || nMarkerSide==3)
						{ 
						// HSB-18971 Midline
							break;
						}
					}
				}
			// marker points are not overlapping -> create corner style marker line	
				else
				{
				// secondary points
					Point3d pt3 = pt1 + vecXSeg*dMarkerLength;				
					Point3d pt4 = pt2 - vecXSeg*dMarkerLength;
//					pt1.vis(1);
//					pt2.vis(1);
//					pt3.vis(1);
//					pt4.vis(1);
				// validate both points on marking face
					int bIsOn1 =  ppMarkingFace.pointInProfile(pt1)==_kPointOnRing;
					int bIsOn2 =  ppMarkingFace.pointInProfile(pt2)==_kPointOnRing;
					int bIsOn3 =  ppMarkingFace.pointInProfile(pt3)==_kPointOnRing;
					int bIsOn4 =  ppMarkingFace.pointInProfile(pt4)==_kPointOnRing;
				// add if both points are on the marking profile
					if (bIsOn1 && bIsOn3)
					{
						if (sSide == T("|Front|") || sSide == T("|Both|"))
						{
							if((bContactParallelMarking && nMarkerType==0)
							|| !bContactParallelMarking)
							{ 
//								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
//								Point3d pt1Face=pt1+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt1);
//								Point3d pt3Face=pt3+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt3);
//								dp.draw(PLine(pt1Face, pt3Face));
//								
//								// marker line
//								MarkerLine ml1(pt1Face, pt3Face, vecDir);
//								if (bExportAsMark)
//								{
//									ml1.exportAsMark(true);
//								}
//								gb.addTool(ml1);	
//								
//								nNumMarkerlines++;				
//								bThisHasMarking=true;
								// marker line
									
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
								Point3d pt1Face=pt1+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt1);
								Point3d pt3Face=pt3+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt3);
								MarkerLine ml1(pt1Face, pt3Face, vecDir);
								if (bExportAsMark)
								{
									ml1.exportAsMark(true);
								}
								gb.addTool(ml1);
								dp.draw(PLine(pt1Face, pt3Face));
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
							else if((bContactParallelMarking && nMarkerType==1))
							{ 
								// drill
								Point3d ptDrill,ptDrill2;
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
								PlaneProfile ppMarkedFaceShrink(ppMarkedFace.coordSys());
								PLine pls[] = ppMarkedFace.allRings(true, false);
								for (int ipl=0;ipl<pls.length();ipl++)
								{ 
									ppMarkedFaceShrink.joinRing(pls[ipl],_kAdd); 
									 
								}//next ipl
								
//								ppMarkedFaceShrink.shrink(U(40));
//								ppMarkedFaceShrink.shrink(U(-40));
								ppMarkedFaceShrink.vis(4);
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								Point3d pt1Face = pt1+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt1);
								Point3d pt3Face = pt3+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt3);
//								pt1Face.vis(2);
								if(ppMarkedFaceShrink.pointInProfile(pt1Face)==_kPointInProfile)
								{ 
									ptDrill = pt1Face;
								}
								else if(ppMarkedFaceShrink.pointInProfile(pt3Face)==_kPointInProfile)
								{ 
									ptDrill = pt3Face;
								}
//								ptDrill.vis(1);
								ptDrill2 = ptDrill - gb.vecD(vecDir) * dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
//								dr.cuttingBody().vis(3);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(vecDir), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(vecDir)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
								nNumMarkerlines++;
								bThisHasMarking=true;
							}
//							else if((bContactParallelMarking && !bMidIsMarked && nMarkerType==2))
							else if((bContactParallelMarking && nMarkerType==2))
							{ 
								// midline
								if(bMarkingOutsideMarked)
								{ 
//									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
//									Plane pnFace(ptFace, gb.vecD(vecDir));
////									Point3d ptMiddleFace=ptMiddle+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle);
////									Point3d ptMiddleFace=ptMiddle+entMale.coordSys().vecX()*entMale.coordSys().vecX().dotProduct(ptFace - ptMiddle);
//									Point3d ptMiddleFace;
//									Line(ptMiddle,entMale.coordSys().vecX()).hasIntersection(pnFace,ptMiddleFace);
////									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle2);
////									Point3d ptMiddle2Face=ptMiddle2+entMale.coordSys().vecX()*entMale.coordSys().vecX().dotProduct(ptFace - ptMiddle2);
//									Point3d ptMiddle2Face;
//									Line(ptMiddle2,entMale.coordSys().vecX()).hasIntersection(pnFace,ptMiddle2Face);
//									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
//									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, vecDir);
//									if (bExportAsMark)
//									{
//										ml1.exportAsMark(true);
//									}
//									gb.addTool(ml1);
//									
//									nNumMarkerlines++;		
//									bMidIsMarked = true;
//									bThisHasMarking=true;
									
									
									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
									Point3d ptMiddleFace=ptMiddle+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle);
									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle2);
									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
									MarkerLine ml1(ptMiddle, ptMiddle2, vecDir);
									if (bExportAsMark)
									{
										ml1.exportAsMark(true);
									}
									gb.addTool(ml1);
									nNumMarkerlines++;				
									bThisHasMarking=true;
								}
//								else
//								{ 
//									// set to marking, middle not possible
//									reportMessage("\n"+scriptName()+" "+sSideMarkings[2]+" "+T("|can not be selected|"));
//									reportMessage("\n"+scriptName()+" "+T("|Property is change to|")+" "+sSideMarkings[0]);
//									sSideMarking.set(sSideMarkings[0]);
//									setExecutionLoops(2);
//									return;
//								}
							}
						}
						
						if (sSide == T("|Back|") || sSide == T("|Both|"))
						{
							if((bContactParallelMarking && nMarkerType==0)
							|| !bContactParallelMarking)
							{
//								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
//								Point3d pt1Face=pt1+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt1);
//								Point3d pt3Face=pt3+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt3);
//								dp.draw(PLine(pt1Face, pt3Face));
//								
//								MarkerLine ml1(pt1Face, pt3Face, - vecDir);
//								if (bExportAsMark)
//								{
//									ml1.exportAsMark(true);
//								}
//								gb.addTool(ml1);
//								
//								nNumMarkerlines++;
//								bThisHasMarking = true;
								
								// corner
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
								Point3d pt1Face=pt1+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt1);
								Point3d pt3Face=pt3+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt3);
								dp.draw(PLine(pt1Face, pt3Face));
								MarkerLine ml1(pt1Face, pt3Face,  -vecDir);
								if (bExportAsMark)
								{
									ml1.exportAsMark(true);
								}
								gb.addTool(ml1);
								nNumMarkerlines++;
								bThisHasMarking = true;
							}
							else if((bContactParallelMarking && nMarkerType==1))
							{ 
								// drill
								Point3d ptDrill,ptDrill2;
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
								PlaneProfile ppMarkedFaceShrink(ppMarkedFace.coordSys());
								PLine pls[] = ppMarkedFace.allRings(true, false);
								for (int ipl=0;ipl<pls.length();ipl++)
								{ 
									ppMarkedFaceShrink.joinRing(pls[ipl],_kAdd); 
									 
								}//next ipl
								
//								ppMarkedFaceShrink.shrink(U(40));
//								ppMarkedFaceShrink.shrink(U(-40));
								ppMarkedFaceShrink.vis(4);
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								Point3d pt1Face = pt1+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt1);
								Point3d pt3Face = pt3+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt3);
//								pt1Face.vis(2);
								if(ppMarkedFaceShrink.pointInProfile(pt1Face)==_kPointInProfile)
								{ 
									ptDrill = pt1Face;
								}
								else if(ppMarkedFaceShrink.pointInProfile(pt3Face)==_kPointInProfile)
								{ 
									ptDrill = pt3Face;
								}
//								ptDrill.vis(1);
								ptDrill2 = ptDrill - gb.vecD(-vecDir) * dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
//								dr.cuttingBody().vis(3);
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(vecDir), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(vecDir)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
//							else if((bContactParallelMarking && !bMidIsMarked && nMarkerType==2))
							else if((bContactParallelMarking && nMarkerType==2))
							{ 
								// midline
								if(bMarkingOutsideMarked)
								{ 
//									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
//									Point3d ptMiddleFace=ptMiddle+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle);
//									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle2);
//									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
//									
//									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, -vecDir);
//									if (bExportAsMark)
//									{
//										ml1.exportAsMark(true);
//									}
//									gb.addTool(ml1);
//									
//									nNumMarkerlines++;		
//									bMidIsMarked = true;
//									bThisHasMarking=true;
									
									
									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
									Point3d ptMiddleFace=ptMiddle+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle);
									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle2);
									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, -vecDir);
									if (bExportAsMark)
									{
										ml1.exportAsMark(true);
									}
									gb.addTool(ml1);
									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
									nNumMarkerlines++;				
									bThisHasMarking=true;
								}
							}
						}
					// dont continue if a midline is found
						if(bThisHasMarking)
						{ 
							if (nMarkerType==2 || nMarkerSide==3)
							{ 
							// HSB-18971 Midline
								break;
							}
						}
					}
				// add if both points are on the marking profile
					if (bIsOn2 && bIsOn4)
					{						
						if (sSide == T("|Front|") || sSide == T("|Both|"))
						{
							if((bContactParallelMarking && nMarkerType==0)
							|| !bContactParallelMarking)
							{
//								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
//								Point3d pt2Face=pt2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt2);
//								Point3d pt4Face=pt4+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt4);
//								dp.draw(PLine(pt2Face, pt4Face));
//								
//								MarkerLine ml2(pt2Face,pt4Face, vecDir);
//								if (bExportAsMark)
//								{
//									ml2.exportAsMark(true);
//								}	
//								gb.addTool(ml2);	
//								
//								nNumMarkerlines++;				
//								bThisHasMarking=true;
								
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
								Point3d pt2Face=pt2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt2);
								Point3d pt4Face=pt4+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt4);
								dp.draw(PLine(pt2Face, pt4Face));
								MarkerLine ml2(pt2Face,pt4Face, vecDir);
								if (bExportAsMark)
								{
									ml2.exportAsMark(true);
								}	
								gb.addTool(ml2);
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
							else if ((bContactParallelMarking && nMarkerType == 1))
							{
								// drill
								Point3d ptDrill,ptDrill2;
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
								PlaneProfile ppMarkedFaceShrink(ppMarkedFace.coordSys());
								PLine pls[] = ppMarkedFace.allRings(true, false);
								for (int ipl=0;ipl<pls.length();ipl++)
								{ 
									ppMarkedFaceShrink.joinRing(pls[ipl],_kAdd); 
									 
								}//next ipl
								
//								ppMarkedFaceShrink.shrink(U(40));
//								ppMarkedFaceShrink.shrink(U(-40));
								ppMarkedFaceShrink.vis(4);
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								Point3d pt2Face = pt2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt2);
								Point3d pt4Face = pt4+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - pt4);
//								pt1Face.vis(2);
								if(ppMarkedFaceShrink.pointInProfile(pt2Face)==_kPointInProfile)
								{ 
									ptDrill = pt2Face;
								}
								else if(ppMarkedFaceShrink.pointInProfile(pt4Face)==_kPointInProfile)
								{ 
									ptDrill = pt4Face;
								}
//								ptDrill.vis(1);
								ptDrill2 = ptDrill - gb.vecD(vecDir) * dDepthDrill;
								Drill dr(ptDrill, ptDrill2, .5 * dDiameterDrill);
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(vecDir), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(vecDir)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
//								dr.cuttingBody().vis(3);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));	
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
//							else if((bContactParallelMarking && !bMidIsMarked && nMarkerType==2))
							else if((bContactParallelMarking && nMarkerType==2))
							{ 
								// midline
								if(bMarkingOutsideMarked)
								{ 
//									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
//									Point3d ptMiddleFace=ptMiddle+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle);
//									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle2);
//									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
//									
//									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, vecDir);
//									if (bExportAsMark)
//									{
//										ml1.exportAsMark(true);
//									}
//									gb.addTool(ml1);
//									
//									nNumMarkerlines++;	
//									bMidIsMarked = true;
//									bThisHasMarking=true;
									
									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(vecDir);
									Point3d ptMiddleFace=ptMiddle+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle);
									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(vecDir) * gb.vecD(vecDir).dotProduct(ptFace - ptMiddle2);
									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, vecDir);
									if (bExportAsMark)
									{
										ml1.exportAsMark(true);
									}
									gb.addTool(ml1);
									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
									nNumMarkerlines++;				
									bThisHasMarking=true;
								}
							}
						}
//						if (sSide == T("|Back|") || sSide == T("|Both|"))
						if (sSide == T("|Back|") || sSide == T("|Both|"))
						{
							if((bContactParallelMarking && nMarkerType==0)
							|| !bContactParallelMarking)
							{ 

//								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
//								Point3d pt2Face=pt2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt2);
//								Point3d pt4Face=pt4+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt4);
//								dp.draw(PLine(pt2Face, pt4Face));
//								
//								MarkerLine ml2(pt2Face,pt4Face, -vecDir);
//								if (bExportAsMark)
//								{
//									ml2.exportAsMark(true);
//								}	
//								gb.addTool(ml2);	
//								nNumMarkerlines++;				
//								bThisHasMarking=true;
									
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
								Point3d pt2Face=pt2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt2);
								Point3d pt4Face=pt4+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt4);
								MarkerLine ml2(pt2Face,pt4Face, -vecDir);
								if (bExportAsMark)
								{
									ml2.exportAsMark(true);
								}	
								gb.addTool(ml2);
								dp.draw(PLine(pt2Face, pt4Face));
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
							else if ((bContactParallelMarking && nMarkerType == 1))
							{
								// drill
								Point3d ptDrill,ptDrill2;
								Point3d ptFace = gb.ptCen() + .5 * gb.dD(-vecDir) * gb.vecD(-vecDir);
								PlaneProfile ppMarkedFaceShrink(ppMarkedFace.coordSys());
								PLine pls[] = ppMarkedFace.allRings(true, false);
								for (int ipl=0;ipl<pls.length();ipl++)
								{ 
									ppMarkedFaceShrink.joinRing(pls[ipl],_kAdd); 
									 
								}//next ipl
								
//								ppMarkedFaceShrink.shrink(U(40));
//								ppMarkedFaceShrink.shrink(U(-40));
								ppMarkedFaceShrink.vis(4);
								ppMarkedFaceShrink.shrink(dMarkedFaceShrink);
								Point3d pt2Face = pt2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt2);
								Point3d pt4Face = pt4+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - pt4);
//								pt1Face.vis(2);
								if(ppMarkedFaceShrink.pointInProfile(pt2Face)==_kPointInProfile)
								{ 
									ptDrill = pt2Face;
								}
								else if(ppMarkedFaceShrink.pointInProfile(pt4Face)==_kPointInProfile)
								{ 
									ptDrill = pt4Face;
								}
//								ptDrill.vis(1);
								ptDrill2 = ptDrill - gb.vecD(-vecDir) * dDepthDrill;
								Drill dr(ptDrill, ptDrill - gb.vecD(-vecDir) * dDepthDrill, .5 * dDiameterDrill);
								PLine plCircle;
								plCircle.createCircle(ptDrill, gb.vecD(vecDir), .5 * dDiameterDrill);
								PlaneProfile ppCircle(Plane(ptDrill, gb.vecD(vecDir)));
								ppCircle.joinRing(plCircle, _kAdd);
								dp.draw(ppCircle, _kDrawFilled);
//								dr.cuttingBody().vis(3);
								gb.addTool(dr);
								dp.draw(PLine(ptDrill, ptDrill2));	
								nNumMarkerlines++;				
								bThisHasMarking=true;
							}
//							else if((bContactParallelMarking && !bMidIsMarked && nMarkerType==2))
							else if((bContactParallelMarking && nMarkerType==2))
							{ 
								// midline
								if(bMarkingOutsideMarked)
								{ 
//									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
//									Point3d ptMiddleFace=ptMiddle+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle);
//									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle2);
//									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
//									
//									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, -vecDir);
//									if (bExportAsMark)
//									{
//										ml1.exportAsMark(true);
//									}
//									gb.addTool(ml1);
//									
//									nNumMarkerlines++;	
//									bMidIsMarked = true;
//									bThisHasMarking=true;
									
									Point3d ptFace = gb.ptCen() + .5 * gb.dD(vecDir) * gb.vecD(-vecDir);
									Point3d ptMiddleFace=ptMiddle+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle);
									Point3d ptMiddle2Face=ptMiddle2+gb.vecD(-vecDir) * gb.vecD(-vecDir).dotProduct(ptFace - ptMiddle2);
									MarkerLine ml1(ptMiddleFace, ptMiddle2Face, -vecDir);
									if (bExportAsMark)
									{
										ml1.exportAsMark(true);
									}
									gb.addTool(ml1);
									dp.draw(PLine(ptMiddleFace, ptMiddle2Face));
									nNumMarkerlines++;				
									bThisHasMarking=true;
								}
							}
						}
					// dont continue if a midline is found
						if(bThisHasMarking)
						{ 
							if (nMarkerType==2 || nMarkerSide==3)
							{ 
							// HSB-18971 Midline
								break;
							}
						}
					}		
				}
			
			// group assignment
				if (bThisHasMarking)
				{
					assignToGroups(gb, 'T');
				}
				if (nMarkerType==2)
				{ 
				// Midline
					break;
				}
			}
			
		// flag this instance to be a valid marking
			if (nNumMarkerlines>0)
				bOk=true;
		}// next m male
		if (bDebug)reportMessage("\ntest markings for genbeam " + gb.posnum() + " ended");	
	}// next i female
	
	if(!bOk && nMarkerType==2)
	{ 
		// midline only works when marking entity and marked entity dont fully intersect
		sType.set(sTypes[0]);
		reportMessage("\n"+scriptName()+" "+T("|Type|")+" "+sTypes[2]+" "+T("|not possible|"));
		reportMessage("\n"+scriptName()+" "+T("|Marking type has been changed back to|")+" "+sTypes[0]);
		setExecutionLoops(2);
		return;
	}
// no valid marking could be placed, alert user and erase instance
	if (!bOk && !bDebug)
	{
		reportMessage("\n" +scriptName()+" "+ T("|Could not place any marking to the selected entities|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}	


// Trigger UseRealCollectionEntity
	{
		String sTriggerUseReal =bUseRealbody?T("|Use envelope shape of definition (fast)|"):T("|Use realbody of definition (slow)|");
		addRecalcTrigger(_kContextRoot, sTriggerUseReal);
		if (_bOnRecalc && _kExecuteKey==sTriggerUseReal)
		{
			bUseRealbody = bUseRealbody ? false : true;
			_Map.setInt("UseRealbody", bUseRealbody);		
			setExecutionLoops(2);
			return;
		}		
	}

return;



#End
#BeginThumbnail
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
<4Y`+*`/RYKI+*%K:Q@@8@M'&%)'3@58HH`__V>N?
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
        <int nm="BreakPoint" vl="1494" />
        <int nm="BreakPoint" vl="1439" />
        <int nm="BreakPoint" vl="1948" />
        <int nm="BreakPoint" vl="1565" />
        <int nm="BreakPoint" vl="1469" />
        <int nm="BreakPoint" vl="1525" />
        <int nm="BreakPoint" vl="1680" />
        <int nm="BreakPoint" vl="1874" />
        <int nm="BreakPoint" vl="2005" />
        <int nm="BreakPoint" vl="2112" />
        <int nm="BreakPoint" vl="1335" />
        <int nm="BreakPoint" vl="1396" />
        <int nm="BreakPoint" vl="1458" />
        <int nm="BreakPoint" vl="1520" />
        <int nm="BreakPoint" vl="1586" />
        <int nm="BreakPoint" vl="1600" />
        <int nm="BreakPoint" vl="1751" />
        <int nm="BreakPoint" vl="1797" />
        <int nm="BreakPoint" vl="1923" />
        <int nm="BreakPoint" vl="1999" />
        <int nm="BreakPoint" vl="2035" />
        <int nm="BreakPoint" vl="1663" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22662: Fix side of markerline" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/8/2025 2:24:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20007: shrink/extend pp to fix it" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/8/2023 1:19:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18971: Mit double export of Midline marking" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="5/15/2023 9:30:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20230512: Add some tolerance to the boundary 20mm of drills" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/12/2023 3:57:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18791: Dont allow drill closer then 20mm to edge/boundary" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="4/25/2023 2:04:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20230425: remove dependency with other entities; improves performance" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/25/2023 8:51:24 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18448: Fix drill point" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/5/2023 9:20:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18330 bugfix detecting solid of curved female beam" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/15/2023 1:49:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18109: Fix side {Front,Back}; fix check when enforcing side marking" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/3/2023 10:50:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17937 performance on curved beams enhanced, mid marking duplicates removed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/23/2023 2:17:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17937 performance enhanced on metalparts and block references which contain genbeams." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/14/2023 1:36:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16807: Fix bug when considering for T-connections" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/9/2022 2:32:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16807: Validate entity before checking the volume" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/9/2022 1:55:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16644: Get plEnvelope of curved beams from realbody to consider also the toolings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/29/2022 8:08:39 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16644: fix side of points for MarkerLine; " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="9/28/2022 5:06:02 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End