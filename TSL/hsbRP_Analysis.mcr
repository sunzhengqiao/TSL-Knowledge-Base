#Version 8
#BeginDescription
version  value="3.5" date="19may15" author="th">
bugfix sum

bugfix: single roof planes supported 
bugfix: overlapping rooflines are removed


















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 3
#MinorVersion 5
#KeyWords 
#BeginContents
// // ########################################################################
// Script			:  hsbRP_Analysis
// Description	:  analyzises roofplanes, inserts rooflines and roof/eave areas
// Author			:  th@hsbCAD.de
// Date			:	28.04.2005
// ------------------------------------------------------------------------------------------------------------------------------------
// Changes:
// ---------------
// Date		Change By		Description
// ------------------------------------------------------------------------------------------------------------------------------------
// 22.03.07	th@hsbCAD.de	Roofplane openings and free openings (closed pline) added, new property 'Group analysis BOM' added
// 23.03.07	th@hsbCAD.de bugFix roofplane detection, column of graphics scales also to max roof dimension	
//
// COPYRIGHT
//  ---------
//  Copyright (C) 2007 by
//  hsb SYSTEMS gmbh
//  Germany
//
//  The program may be used and/or copied only with the written
//  permission from hsb SYSTEMS gmbh., or in accordance with
//  the terms and conditions stipulated in the agreement/contract
//  under which the program has been supplied.
//
//  All rights reserved.
// #########################################################################



/// History
///<version  value="3.5" date="19may15" author="th"> bugfix sum </version>
///<version  value="3.4" date="18may15" author="th"> duplicate row removed </version>
///<version  value="3.3" date="20apr15" author="th"> new column to display bend angle </version>
///<version  value="3.2" date="10apr14" author="th"> bugfix: single roof planes supported </version>
///<version  value="3.1" date="03apr14" author="th"> bugfix: overlapping rooflines are removed</version>
///<version  value="3.0" date="15may13" author="th"> tolerance for touching roofplanes increased </version>
///<version  value="2.9" date="16feb12" author="th"> bugfix canopy area total take II</version>
///<version  value="2.8" date="09jan12" author="th"> bugfix ridge/hip roof line detection</version>
///<version  value="2.7" date="12dec11" author="th"> bugfix canopy area total</version>
/// Version 2.6   11.02.2011   th@hsbCAD.de
/// bugfix in compliance with hsbRP_Roofline Version 2.3
/// Version 2.5   04.11.2010   th@hsbCAD.de
/// DE   neuer Kontextbefehl um Sonderflächen aus Polylinien zu erzeugen
///      neuer Kontextbefehl um zusätzliche Dachlinien zu erzeugen
/// EN   new context command to add special areas
///      new context command to add individual rooflines
/// Version 2.4   20.08.2008   th@hsbCAD.de
/// DE   Einheiten der Flächenauswertung bei bestimmten Zeichnungseinheiten korrigiert
/// EN   units of area calculation for specific drawing units fixed
/// Version 2.3   22.06.2007   th@hsbCAD.de
/// DE Differenzfläche in Tabelle ergänzt
/// EN brut / net difference added to table
/// Version 2.2   22.06.2007   th@hsbCAD.de
/// DE Kompatibilität hsbCAD Version 12.5
/// EN compatibilty hsbCAD release 12.5
/// Version 2.1   21.06.2007   th@hsbCAD.de
/// DE bugFix Tabelle Dachflächen
/// EN bugFix Schedule data roof areas
/// Version 2.0   23.03.2007   th@hsbCAD.de
/// DE  bugFix Dachflächenberechnung
///    - die Grafikspalte wird nun auch nach den maximalen Dachabmessungen skaliert
/// EN  bugFix roofplane detection, column of graphics scales also to max roof dimension
/// 	
/// Version 1.9   22.03.2007   th@hsbCAD.de
/// DE  Dachflächenfenster und freie Öffnungen (geschlossene Polylinien) ergänzt
///     - neue Eigenschaft 'Gruppe der Analysetabelle' ergänzt.
///     - neuer Kontextbefehl 'Öffnung ergänzen'
///     - bei Dachflächen werden nun die Brutto und Nettoflächen ausgewiesen
/// EN  Roofplane openings and free openings (closed pline) added
///    - new property 'Group analysis BOM' added
///    - new context command to add an opening
///    - roofplane bom now supports brut and net areas
/// 
/// Version 1.8   26.02.2007   th@hsbCAD.de
/// DE Tabellendarstellung erweitert
///    - Traufflächen und Dachflächen werden über das TSL hsbRP_EaveArea
///      dargestellt und ausgewertet
///    (neue schreibgeschützte Eigenschaft 'Typ")
///    - Dachflächen werden gelistet und erhalten eine Minivoransicht
///    - neue Eigenschaften zur Gruppierung und Darstellung
/// EN  table content completly revised
///    - table contains sepearte lsitings of roof areas, eave areas and roof lines
///    - previews are shown for roof areas and eave areas
///    - if a hip or valley rafter cuts the hip/valley line a sectional display of this beam
///      is added
///    - all satellites have a dynmic link to the master
///    - eave areas and roof areas are displayed by TSL hsbRP_EaveArea (new write
///      protected property 'type')
///    - new properties for grouping and display
/// Version 1.7   20.02.2007   th@hsbCAD.de
/// DE Tabellendarstellung vollständig überarbeitet
///    - Tabelle enthält Dachlinien und Traufflächen
///    - schneidet ein Kehl-/ oder Gratsparren die Kontur der
///      Dachlinie, so wird in der Tabelle eine vereinfachte
///      Einzelteilzeichnung erzeugt
///    - dynamische Abhängigkeit zu Satelliten erzeugt
/// Version 1.6   16.01.2007   dt@hsb-cad.com
/// DE dxi Export ergänzt
/// EN dxi export supported
/// Version 1.5   04.12.2006   th@hsbCAD.de
/// DE Erläuterung zur Gruppentrennung korrigiert - es wird nur ein einfacher
///      Backslash benötigt um die Ebenen zu trennen
/// EN Explanation for grouping structure corrected - you need only to enter 
///      a single backslash to seperate the levels
/// Version 1.4   07.11.2006   th@hsbCAD.de
/// DE Schraffur ergänzt
///    - benötigt hsbRP_EaveArea 1.3, hsbRP_Roofline 1.3
/// EN Hatch pattern added
///    - requires  hsbRP_EaveArea 1.3, hsbRP_Roofline 1.3
/// Version 1.3   12.10.2006   th@hsbCAD.de
///    - bugfix
/// Version 1.2   07.06.2006   th@hsbCAD.de
/// DE alle Einheiten in Tabelle verfügbar
/// EN all units in table display supported
/// Version 1.1   12.05.2006   th@hsbCAD.de
/// DE  Kontextbefehle ergänzt
///    - Gruppenzuordnung ergänzt
/// EN  new context commands
///    - groups added
/// Version 1.0   28.04.2005   th@hsbCAD.de
///    - analysiert Dachflächen auf ihre Verschneidungslinien und generiert diese in
///      der  Zeichnung (TSL hsbRP_Roofline)
///    - die optionale Auswahl einer geschlossenen Polylinie, welche die äußere
///      Wandkontur beschreibt, bewirkt zusätzlich die Definition der Traufbereiche
///      (TSL hsbRP_EaveArea)
///    - Datenausgabe optional zusätzlich in MS Excel (benötigt hsbExcel.dvb)
///    - die Option 'Dachlinien und Traufflächen löschen = Ja' löscht nur den
///      Auswahlsatz
/// 
///    - analizes roofplanes for its intersecting lines and generates those in the
///     drawing
///      (TSL hsbRP_Roofline)


// basics and props
	U(1,"mm");
	double dEps = U(.1);
//	PropString sRoofGroup(1,1,T("Roof Group"));
	String sArAreaType[] = {T("|Roof area|"),T("|Eave area|")};
	// hatch pattern
	String sArHatch[0];
	sArHatch.append(T("None"));
	sArHatch.append(_HatchPatterns);	
	PropString sGroupMain(9,"",T("|Group analysis BOM (seperate Level by '\')|"));	
	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(2,sArUnit,"   " + T("|Unit|"),2);	
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(0,nArDecimals,"   " + T("|Decimals|"),2);		
	PropInt nDecimalsArea(3,nArDecimals,"   " + T("|Decimals Area|"),2);
	PropInt nColorTable (5,143,"   " + T("|Color of table|"));	
	PropString sDimStyle(0,_DimStyles,"   " + T("Dimstyle"));
	PropString sDimStyleShop(7,_DimStyles,"   " + T("|Dimstyle Shopdrawing|"));	
		
	PropString sGroup0(4,"",T("|Group Roofline (seperate Level by '\')|"));	//
	PropInt nColor (1,9,"   " + T("|Color|"));		
	PropString sGroup1(5,"",T("|Group Eave Area (seperate Level by '\'|)"));	
	PropInt nColor1 (2,93,"   " + T("|Color|") + " ");	
	PropString sMat(3,"","   " + T("|Material|"));	
	PropString sHatch(6,sArHatch,"   " + T("|Hatch pattern|"));	
	PropDouble dHatchScale(0,U(30),"   " + T("|Hatch scale|"));	
	
	
	PropString sGroup2(1,"",T("|Group Roof area (seperate Level by '\')|"));	
	PropInt nColor2 (4,7,"   " + T("|Color|") + "  ");	
	PropString sHatch2(8,sArHatch,"   " + T("|Hatch pattern|") + " ");	
	PropDouble dHatchScale2(1,U(30),"   " + T("|Hatch scale|") + " ");	
	
	int bDebug;

				
// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		//get roofelement sset	
		PrEntity ssRP(T("Select roofplanes and (optional) hsbRPxx-Tsl's to delete"), ERoofPlane());
		ssRP.addAllowedClass(TslInst());
		ERoofPlane er0[0];
  		if (ssRP.go()){
			Entity ents[0];
    		ents = ssRP.set();
			int nCountERoofs = 0;
			for (int i = 0; i < ents.length(); i++){
				if (ents[i].bIsKindOf(ERoofPlane()))
				{
					// store as entity in global map
					_Map.setEntity("er" + nCountERoofs , ents[i]);
					nCountERoofs++;
				}
				else if(ents[i].bIsKindOf(TslInst()))
				{
					// check tsl name
					TslInst tslDelete;
					tslDelete = (TslInst)ents[i];
					String sScriptName = tslDelete.scriptName();
					sScriptName.makeUpper();
					if (sScriptName == "HSBRP_ROOFLINE" || sScriptName == "HSBRP_EAVEAREA")	
						tslDelete.dbErase();
					
				}
			}
		}	
		//get roofelement sset	
		PrEntity ssRPOp(T("Select (optional) roofplane openings, (optional) plines which describe openings"), ERoofPlaneOpening());
		ssRPOp.addAllowedClass(EntPLine());	

  		if (ssRPOp.go()){
			Entity ents[0];
    		ents = ssRPOp.set();
			int nCountERoofsOpenings = 0;
			for (int i = 0; i < ents.length(); i++){
				if(ents[i].bIsKindOf(ERoofPlaneOpening()))
				{
					// store as entity in global map
					_Map.setEntity("erOp" + nCountERoofsOpenings , ents[i]);
					nCountERoofsOpenings ++;					
				}
				else if(ents[i].bIsKindOf(EntPLine()))
				{
					// store as entity in global map
					_Map.setEntity("erOp" + nCountERoofsOpenings , ents[i]);
					nCountERoofsOpenings ++;					
				}
			}
		}	
		
		// select optional polyline for eave area
		Entity entsPl[0];
		while (entsPl.length() < 1) {
			PrEntity ssE("\n" + T("select optional a closed polyline"), EntPLine()); 
		   if (ssE.go()==_kOk){  // do the actual query
				entsPl = ssE.set();
				_Map.setEntity("plOl", entsPl[0]);
			}
			else // no proper selection
		   		break; // out of infinite while
		}
	//}
		
		_Pt0 = getPoint(T("Insertion point of table"));
		
		return;
	}// end on insert_____________________________________________________________________________________________
	


// add triggers
	String sTrigger[] = {T("Delete Rooflines"), T("Delete Eave Areas"),	T("Delete All"),T("Generate Rooflines"), T("Add individual Roofline"),
		T("Generate Eave Areas"), 	T("Add Area by Polyline"), T("Generate all"),"----------", T("|Add opening|")};
	String sTriggerMsg[] = {T("Select Rooflines"),T("Select Eave Areas"),
		T("Select Eave Areas + Rooflines"), "", "", ""};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger0: delete rooflines
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
		PrEntity ssRP(sTriggerMsg[sTrigger.find(_kExecuteKey)], TslInst());
		if (ssRP.go())
		{
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++){
				TslInst tsl;
				tsl = (TslInst)ents[i];
				if (tsl.scriptName() == "hsbRP_Roofline"){
					reportMessage("\n" + "..." +T("deleting") + " " + tsl.scriptName());
					tsl.dbErase();
				}
			}//next i
		}	// end if go
	}// end if trigger
// trigger1: delete eave areas
	else if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{
		PrEntity ssRP(sTriggerMsg[sTrigger.find(_kExecuteKey)], TslInst());
		if (ssRP.go())
		{
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++){
				TslInst tsl;
				tsl = (TslInst)ents[i];
				if (tsl.scriptName() == "hsbRP_EaveArea")
				{
					// remove from map
					for(int m = 0; m < _Map.length(); m++)
						if (_Map.keyAt(m).left(4) == "EAVE")
						{
							Entity ent = _Map.getEntity(_Map.keyAt(m));
							if (ent.bIsValid())
							{
								TslInst tslMap = (TslInst)ent;
								if (tslMap == tsl)
								{
									_Map.removeAt(m,FALSE);
									reportMessage("\n" + "..." +T("remove eavearea from local database"));
								}
							}
						}
					reportMessage("\n" + "..." +T("deleting") + " " + tsl.scriptName());
					tsl.dbErase();
				}
			}//next i
		}	// end if go
	}// end if trigger	
// trigger2: delete roofline and eave areas
	else if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{
		PrEntity ssRP(sTriggerMsg[sTrigger.find(_kExecuteKey)], TslInst());
		if (ssRP.go())
		{
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++){
				TslInst tsl;
				tsl = (TslInst)ents[i];
				if (tsl.scriptName() == "hsbRP_Roofline" ||tsl.scriptName() == "hsbRP_EaveArea"){
					reportMessage("\n" + "..." +T("deleting") + " " + tsl.scriptName());
					tsl.dbErase();
				}// endif
			}//next i
		}	// end if go
	}// end if trigger		





// trigger8: add opening
	else if (_bOnRecalc && _kExecuteKey==sTrigger[8]) 
	{
		//get roofelement sset	
		PrEntity ssRPOp(T("Select (optional) roofplane openings, (optional) plines which describe openings"), ERoofPlaneOpening());
		ssRPOp.addAllowedClass(EntPLine());	

  		if (ssRPOp.go()){
			Entity ents[0];
    		ents = ssRPOp.set();
			int nCountERoofsOpenings = 0;
			
			
			for (int i = 0; i < ents.length(); i++)
			{
				// find next free index
				int nFree;
				for(int m = 0; m < _Map.length(); m++)
					if (_Map.keyAt(m).left(4) == "erOp")
						nFree++;
						
				// store as entity in global map			
				if(ents[i].bIsKindOf(ERoofPlaneOpening()))
					_Map.setEntity("erOp" + nFree , ents[i]);					
				else if(ents[i].bIsKindOf(EntPLine()))
					_Map.setEntity("erOp" + nFree , ents[i]);
			}
		}
	}

	
	
// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(9);	
	if (nColor1 > 255 || nColor1 < -1) nColor1.set(93);	
		
// find valid roofplane
	ERoofPlane er[0];
	ERoofPlaneOpening erOp[0];
	PLine plErOp[0];
		
	for (int i = 0; i < _Map.length(); i++){
		Entity ent;
		if (_Map.hasEntity("er" + i))
		{
			ent =  _Map.getEntity("er" + i);
			if (_Entity.find(ent)< 0)
				_Entity.append(ent);
			ERoofPlane erp = (ERoofPlane)ent;
			if (erp.bIsValid())
				er.append(erp);
		}
		if (_Map.hasEntity("erOp" + i))
		{
			ent =  _Map.getEntity("erOp" + i);
			if (_Entity.find(ent)< 0)
				_Entity.append(ent);
				
			if (ent.bIsKindOf(ERoofPlaneOpening ()))
			{
				ERoofPlaneOpening erpOp = (ERoofPlaneOpening )ent;
				if (erpOp.bIsValid())
					erOp.append(erpOp);
			}
			else if (ent.bIsKindOf(EntPLine ()))
			{
				EntPLine epl = (EntPLine)ent;
				if (epl.bIsValid())
				{
  					PLine pl = epl.getPLine();
					plErOp.append(pl);
				}
			}
		}
	}
	
// declare standards and collect plines
	CoordSys cs[0];
	Vector3d vx[0],vy[0],vz[0];
	Point3d ptOrg[0];
	PLine pl[0];

	for (int i = 0; i < er.length(); i++){
		cs.append(er[i].coordSys()); 
		ptOrg.append(cs[i].ptOrg());
		vx.append(cs[i].vecX());
		vy.append(cs[i].vecY());
		vz.append(cs[i].vecZ());
		//vx[i].vis(_Pt0,1);
		//vy[i].vis(_Pt0,3);
		vz[i].vis(_Pt0,150);
		pl.append(er[i].plEnvelope());
	}
	


// check if eroofplane is an opening
	int bIsOpening[0];
	int nLinkedRoofplane[pl.length()];
	for (int i = 0; i < pl.length(); i++){	
		nLinkedRoofplane[i] = -1;	
		PlaneProfile ppOl(pl[i]);
		ppOl.vis(i);
		int bIsHole = FALSE;
		for (int j = 0; j < pl.length(); j++){	
			
			// check if not the same eroofs and in same plane
			if (i != j && vz[i].isParallelTo(vz[j]) && 
			    abs(vz[i].dotProduct(ptOrg[i] - ptOrg[j])) < U(0.01)){
				pl[j].vis(3);	
				Point3d ptPl[] = pl[j].vertexPoints(TRUE);
				int nVertexChecker;
				for (int k = 0; k < ptPl.length(); k++){
					if (ppOl.pointInProfile(ptPl[k]) == _kPointInProfile)
						nVertexChecker++;	
				}// next k
				if(nVertexChecker == ptPl.length())
				{
					bIsHole = TRUE;
					nLinkedRoofplane[j] = i;
				}
			}// end if		
		}// next j	
		
		bIsOpening.append(bIsHole);
		if (bIsHole)
			pl[i].vis(2);
		
	}// next i





// trigger6: add eave area by pline
	if (_bOnRecalc && _kExecuteKey==sTrigger[6]) 
	{
	// selection of plines		
		PrEntity ssPl(T("|Select polyline(s)|"), EntPLine());
		Entity entPl[0];
  		if (ssPl.go())	entPl.append(ssPl.set());	
	
		for (int i = 0; i < er.length(); i++)
		{		
			for (int j= 0; j< entPl.length();j++)
			{
				EntPLine epl = (EntPLine)entPl[j];
				PLine plThis = epl.getPLine();
				plThis.projectPointsToPlane(Plane(er[i].coordSys().ptOrg(), er[i].coordSys().vecZ()),_ZW);
				PlaneProfile ppErp(er[i].plEnvelope());
				ppErp.intersectWith(PlaneProfile(plThis));
				
			// valid intersection
				if (ppErp.area()>pow(dEps,2))
				{				
					PLine plPPEave[] = ppErp.allRings();	
					for (int p = 0; p<plPPEave.length(); p++){
						TslInst tsl;
						// declare tsl props
						String strScriptName = "hsbRP_EaveArea"; // name of the script
						
						Vector3d vecUcsX = _XW;
						Vector3d vecUcsY = _YW;
						Beam lstBeams[0];
						Entity lstEntities[0];
						int lstPropInt[0];
						double lstPropDouble[0];
						String lstPropString[0];
				
						lstPropInt.append(nDecimals);
						lstPropInt.append(nColor1);			
						
						Point3d ptEave[0];
						ptEave = plPPEave[p].vertexPoints(TRUE);
						Point3d ptMidEave;
						ptMidEave.setToAverage(ptEave);
						Point3d lstPoints[0];
						lstPoints.append(ptMidEave);
						lstPoints.append(ptMidEave - _XW * U(200));
									
						for (int q = 0; q < ptEave.length(); q++)
							lstPoints.append(ptEave[q]);
						
							
						lstPropString.append(sDimStyle);	
						lstPropString.append(sMat);
						lstPropString.append(sUnit);			
						lstPropString.append(sGroup1);	
						lstPropString.append(T("Roof") + " " + (i+1));	
						lstPropString.append(sHatch);	
						lstPropString.append(sArAreaType[0]);						
						lstPropDouble.append(dHatchScale);	
							
						Map mapTsl;
						mapTsl.setEntity("er", er[i]);				
						tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, 
									lstPropInt, lstPropDouble, lstPropString,TRUE, mapTsl ); // create new instance	
						
						// append the eavearea tsl to the list of linked tsl's
						int nFree;
						for(int m = 0; m < _Map.length(); m++)
							if (_Map.keyAt(m).left(4) == "EAVE")
								nFree++;
						_Map.setEntity("EAVE_"+nFree, tsl);	
						if (_Entity.find(tsl)< 0)
							_Entity.append(tsl);
							
						if (_bOnDebug)reportNotice("\ni" + i + " p:" + p + " free:" + nFree);	
					}	
				}// end if
					
			}// next p
		}// next i
	}











// ints
	int nUnit = sArUnit.find(sUnit);
	int nLUnit = 2;
	if (nUnit> 2)
		nLUnit = 4;	

//Display
	Display dp(nColorTable), dpShop(nColor);
	dp.dimStyle(sDimStyle);
	dpShop.dimStyle(sDimStyleShop);	
	
// find outline
	PLine plOl;
	
	if (_Map.hasEntity("plOl")) {
		Entity ent;
		ent =  _Map.getEntity("plOl");
		Point3d ptGrip[] = ent.gripPoints();
		for (int i = 0; i < ptGrip.length(); i++)
			plOl.addVertex(ptGrip[i]);
		plOl.close();
		plOl.setNormal(_ZW);
	}
			
// declare list of segments and its linked eroofs
	LineSeg lsAr[0];
	String sArTypeList[0];
	ERoofPlane erAr0[0];		
	ERoofPlane erAr1[0];	

// declare predefined opening RL descriptions
	String sOpRLDesc[] = {"",T("|Opening top|"),T("|Opening bottom|"),T("|Opening left|"),T("|Opening right|"),
		T("|Opening left sloped|"),T("|Opening right sloped|")};

	String sArType[] = {T("|Eave|"), T("|Gable End|"), T("|Hip|"), T("|Valley|"), T("|Ridge|"), T("|Rising Eave|"), 
		T("Verfallgrat"),T("|Opening top|"),T("|Opening bottom|"),T("|Opening left|"),T("|Opening right|"),
		T("|Opening left sloped|"),T("|Opening right sloped|"),T("|Wall connection|")};		
		
		
// analyze all roofplanes
	for (int i = 0; i < er.length(); i++){

	// find free openings and eroofplaneopenings in roof
		// collect eroofplaneopenings in roof
		PLine plOp[0];
		for (int j=0;j<erOp.length();j++)
			if (erOp[j].plEnvelope().coordSys().vecZ().isParallelTo(vz[i]))
				plOp.append(erOp[j].plEnvelope());
		// collect and project free openings
		for (int j=0;j<plErOp.length();j++)
		{
			plErOp[j].projectPointsToPlane(Plane(ptOrg[i], vz[i]),_ZW);
			plOp.append(plErOp[j]);
		}
			
		PlaneProfile ppSub[0];
		// collect opening pp's
		for (int j=0;j<plOp.length();j++)
		{
			plOp[j].projectPointsToPlane(Plane(er[i].coordSys().ptOrg(),er[i].coordSys().vecZ()),_ZW);
			PlaneProfile ppOp(plOp[j]);
			PlaneProfile ppEr(er[i].plEnvelope());
			ppOp.intersectWith(ppEr);
			if (ppOp.area() > U(10))
				ppSub.append(ppOp);
					
			//ppOp.vis(5);
		}
		
		// identify linesegs
		for (int j=0;j<ppSub.length();j++)
		{
			PLine plSub[0];
			plSub = ppSub[j].allRings();
			if (plSub.length() < 1) continue;
			Point3d ptMid;
			ptMid.setToAverage(plSub[0].vertexPoints(TRUE));
			Point3d ptSub[] = plSub[0].vertexPoints(FALSE);
			
			
			
			for (int p=0;p<ptSub.length()-1;p++)
			{
				LineSeg ls(ptSub[p], ptSub[p+1]);
				Vector3d  vxRL = ptSub[p+1]-ptSub[p];
				String sSegLength;
				sSegLength.formatUnit(vxRL.length(),2,2);
				vxRL.normalize();									vxRL.vis(ptSub[p],1);
				Vector3d  vyRL = vz[i].crossProduct(vxRL);		vyRL.vis(ptSub[p],2);	

				int nFlip = 1;
				if (vyRL.dotProduct(ptMid - ptSub[p]) < 0)
					nFlip *= -1;

				double dLocX, dLocY;
				dLocX = vx[i].dotProduct(ls.ptMid()- ptMid);
				dLocY = vy[i].dotProduct(ls.ptMid()- ptMid);
				int n;
				// invalid if line is on er.envelope
				if (er[i].plEnvelope().isOn(ls.ptMid()))
					n=0;
				// parallel
				else if (vxRL.isParallelTo(vx[i]))
				{
					// top
					if (dLocY > 0)	n = 1;
					// bottom
					else	n = 2;	
				}
				// orthogonal accelerating
				else if (vxRL.isParallelTo(vy[i]))
				{
					// left
					if (dLocX < 0) n = 3;
					// right
					else
					{
						n = 4;
						ls.vis(4);	
					}	
				}				
				// accelerating
				else
				{
					// left
					if (dLocX < 0 || dLocY < 0) n = 5;
					// right
					else	n = 6;	
				}				

				if (_bOnDebug && n!= 0)
					dp.draw(sOpRLDesc[n] + " " + T("Length") + ": " +sSegLength, ls.ptMid(), -nFlip * vxRL, (nFlip * vxRL).crossProduct(_ZW), 0,2);
				
				else if(n!= 0 && (_bOnDbCreated || (_bOnRecalc && (_kExecuteKey==sTrigger[3] || _kExecuteKey==sTrigger[7]))))
				{
					// declare tsl props
					TslInst tslRL;
					Vector3d vecUcsX = vxRL;
					Vector3d vecUcsY = vyRL;
					Beam lstBeams[0];
					Entity lstEntities[0];
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
					
					lstPropInt.append(nDecimals);	
									
					Point3d lstPoints[0];
					lstPoints.append(ls.ptStart());
					lstPoints.append(ls.ptEnd());	
					if (nFlip == 1)
						lstPoints.swap(0,1);
					lstPropString.append(sDimStyle);	
					lstPropString.append(sOpRLDesc[n]);
					lstPropString.append(sUnit);	
					lstPropString.append(sGroup0);	
					Map mapTsl;
					mapTsl.setEntity("er0", er[i]);
					tslRL.dbCreate("hsbRP_Roofline", vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString, TRUE, mapTsl ); // create new instance
			
					// find next free index
					int nFree;
					for(int m = 0; m < _Map.length(); m++)
						if (_Map.keyAt(m).left(3) == "RL_")
							nFree++;
					
					// append the roofline tsl to the list of linked tsl's
					_Map.setEntity("RL_"+nFree, tslRL);	
					if (_Entity.find(tslRL)< 0)
					_Entity.append(tslRL);
				}// end on create it	
			}// next ptSub
		}// next ppSub
		
		
		

		
		// add tsl eave area as container for roof area calculation
		if(_bOnDbCreated || (_bOnRecalc && _kExecuteKey==sTrigger[7]))
		{
			PLine pl = er[i].plEnvelope();
			TslInst tsl;
			// declare tsl props
			String strScriptName = "hsbRP_EaveArea"; // name of the script
				
			Vector3d vecUcsX = er[i].coordSys().vecX();
			Vector3d vecUcsY = er[i].coordSys().vecY();
			Beam lstBeams[0];
			Entity lstEntities[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			lstPropInt.append(nDecimals);
			lstPropInt.append(nColor2);			
					
			Point3d ptEave[0];
			ptEave = pl.vertexPoints(TRUE);
			Point3d ptMidEave;
			ptMidEave.setToAverage(ptEave);
			Point3d lstPoints[0];
			lstPoints.append(ptMidEave);
			lstPoints.append(ptMidEave - _XW * U(200));
								
			for (int q = 0; q < ptEave.length(); q++)
				lstPoints.append(ptEave[q]);
					
						
			lstPropString.append(sDimStyle);	
			lstPropString.append(sMat);
			lstPropString.append(sUnit);			
			lstPropString.append(sGroup2);	
			lstPropString.append(T("Roof") + " " + (i+1));	
			lstPropString.append(sHatch2);	
			lstPropString.append(sArAreaType[0]);	
			lstPropDouble.append(dHatchScale2);	
						
			Map mapTsl;
			mapTsl.setEntity("er", er[i]);	
			
			// translate subtraction planeprofiles into plines
			int nIndex = 0;
			for (int q = 0; q < ppSub.length(); q++)
			{
				PLine plSub[] = ppSub[q].allRings();
				int nIsOp[] = ppSub[q].ringIsOpening();
				for (int r = 0; r < plSub.length(); r++)	
				{
					if (!nIsOp[r])
					{
						mapTsl.setPLine("plSub"+nIndex, plSub[r]);
						nIndex++;
					}
				}// next r
			}// next q
	
	
	
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString,TRUE, mapTsl ); // create new instance	
					
			// append the eavearea tsl to the list of linked tsl's
			int nFree;
			for(int m = 0; m < _Map.length(); m++)
				if (_Map.keyAt(m).left(4) == "EAVE")
					nFree++;
			_Map.setEntity("EAVE_"+nFree, tsl);	
				if (_Entity.find(tsl)< 0)
					_Entity.append(tsl);
						
			if (_bOnDebug)reportNotice("\ni" + i + " free:" + nFree);				
		}
		
		
		

		
		//Eavearea
		if (_Map.hasEntity("plOl")) {
			// bring outline to roofplane
			plOl.projectPointsToPlane(Plane(ptOrg[i], vz[i]), _ZW);
			PlaneProfile ppOl=(plOl);
			PlaneProfile ppEave(pl[i]);
			ppEave.subtractProfile(ppOl);
		
			int bPPIsOutside = FALSE;
			PLine plEave[] = ppEave.allRings();
			for (int j = 0; j < plEave.length(); j++){
				Point3d ptPlEave[] = plEave[j].vertexPoints(TRUE);
				for (int k = 0; k < ptPlEave.length(); k++){
					int ptIs = ppOl.pointInProfile(ptPlEave[k]);
					if (ptIs == _kPointOutsideProfile)
						bPPIsOutside = TRUE;
				}				
			}
		
			//dp.draw(ppEave,_kDrawFilled);
			if(((_bOnRecalc && (_kExecuteKey==sTrigger[5] || _kExecuteKey==sTrigger[7])) || _bOnDbCreated) && bPPIsOutside){
						

				PLine plPPEave[] = ppEave.allRings();
				
				
				for (int p = 0; p<plPPEave.length(); p++){
					TslInst tsl;
					// declare tsl props
					String strScriptName = "hsbRP_EaveArea"; // name of the script
					
					Vector3d vecUcsX = _XW;
					Vector3d vecUcsY = _YW;
					Beam lstBeams[0];
					Entity lstEntities[0];
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
			
					lstPropInt.append(nDecimals);
					lstPropInt.append(nColor1);			
					
					Point3d ptEave[0];
					ptEave = plPPEave[p].vertexPoints(TRUE);
					Point3d ptMidEave;
					ptMidEave.setToAverage(ptEave);
					Point3d lstPoints[0];
					lstPoints.append(ptMidEave);
					lstPoints.append(ptMidEave - _XW * U(200));
								
					for (int q = 0; q < ptEave.length(); q++)
						lstPoints.append(ptEave[q]);
					
						
					lstPropString.append(sDimStyle);	
					lstPropString.append(sMat);
					lstPropString.append(sUnit);			
					lstPropString.append(sGroup1);	
					lstPropString.append(T("Roof") + " " + (i+1));	
					lstPropString.append(sHatch);	
					lstPropString.append(sArAreaType[1]);						
					lstPropDouble.append(dHatchScale);	
						
					Map mapTsl;
					mapTsl.setEntity("er", er[i]);				
					tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, 
								lstPropInt, lstPropDouble, lstPropString,TRUE, mapTsl ); // create new instance	
					
					// append the eavearea tsl to the list of linked tsl's
					int nFree;
					for(int m = 0; m < _Map.length(); m++)
						if (_Map.keyAt(m).left(4) == "EAVE")
							nFree++;
					_Map.setEntity("EAVE_"+nFree, tsl);	
					if (_Entity.find(tsl)< 0)
						_Entity.append(tsl);
						
					if (_bOnDebug)reportNotice("\ni" + i + " p:" + p + " free:" + nFree);	
				}
			
			}
		}// end Outline for eave area found
		
		
		
		// get segments from roof
		Point3d ptPl[0];
		ptPl = pl[i].vertexPoints(TRUE);
		LineSeg ls[0];
				
		for (int p = 0; p < ptPl.length();  p++){
			int n = p+1;
			if (p == ptPl.length()-1)
				n = 0;
			ls.append(LineSeg(ptPl[p], ptPl[n]));
			ptPl[p].vis(i);
			ptPl[p].vis(i);
					
		}// next p
		
		// check if at least 1 point is on  pline e
		for (int l = 0; l < ls.length();  l++)
		{
			LineSeg seg = ls[l];
			String sType;
			Vector3d vxSeg;
			vxSeg = ls[l].ptEnd() - ls[l].ptStart();
			vxSeg.normalize();
			//vxSeg.vis(ls[l].ptMid(),i);
			// assume all segments are single segments	
			int bSingleSeg = TRUE;
			for (int e = 0; e < er.length(); e++)
			{
			// make sure plines are are different				
				if (i==e)continue;		

			// test if this segment is on the other roof // version  value="3.0" date="15may13" author="th"> tolerance for touching roofplanes increased 
				Point3d ptTest = seg.ptStart();
				int bStartOnOther =pl[e].isOn(ptTest) || (pl[e].closestPointTo(ptTest)-ptTest).length()<dEps;
				ptTest.transformBy(vxSeg * U(1));
				int bStart2OnOther = pl[e].isOn(ptTest) || (pl[e].closestPointTo(ptTest)-ptTest).length()<dEps;
				ptTest = seg.ptEnd();
				int bEndOnOther= pl[e].isOn(ptTest) || (pl[e].closestPointTo(ptTest)-ptTest).length()<dEps;
				ptTest.transformBy(-vxSeg * U(1));
				int bEnd2OnOther= pl[e].isOn(ptTest) || (pl[e].closestPointTo(ptTest)-ptTest).length()<dEps;
				ptTest = seg.ptMid();		
				int bMidOnOther =pl[e].isOn(ptTest) || (pl[e].closestPointTo(ptTest)-ptTest).length()<dEps;
				//seg.transformBy(_ZW*U(100));
				seg.vis(l+1);						
				
				if ( (bStartOnOther  && bStart2OnOther ) ||(bEndOnOther && bEnd2OnOther) ||	bMidOnOther ){
					// segment's vector must point upwards
					if (_ZW.dotProduct(ls[l].ptMid() - (ls[l].ptMid()- vxSeg * U(1))) < 0)
						vxSeg = -vxSeg;
						
					//check hip/valley
					Point3d ptL;
					Vector3d vxN = _ZW.crossProduct(vxSeg);
					vxN.vis(ls[l].ptMid(),i);
					ptL = ls[l].ptMid() + vxN * U(100);
					
					PlaneProfile pp(pl[i]);
					int nIsIn = pp.pointInProfile(ptL);
					int nFlip = 1;
					if (nIsIn == 0)
						nFlip = -1;
					ptL.vis(nIsIn);
					Vector3d vzN = vz[i].crossProduct(nFlip * vz[e]);
					
					if (vxSeg.isPerpendicularTo(_ZW)){//horizontal segment
						ls[l].vis(20);						
						vzN.vis(ls[l].ptMid(),20);
						sType = sArType[4];// ridge
				
					}
					else if (vzN.dotProduct(_ZW) < 0){// hip
						ls[l].vis(2);
						vzN.vis(ls[l].ptMid(),2);
						sType = sArType[2];// hip
					}
					else{// valley
						ls[l].vis(5);
						vzN.vis(ls[l].ptMid(),5);	
						sType =sArType[3];// valley						
					}	
					
					// append segment to list if it's not already in
					int nSegInList = FALSE;
					Vector3d vSegA, vSegB, vSegC, vSegD;
					vSegB = ls[l].ptStart() - ls[l].ptEnd();
					for (int s = 0; s < lsAr.length(); s++){
						double lx, ly, lz, sx, sy, sz;
						lx = ls[l].ptMid().X();
						ly = ls[l].ptMid().Y();
						lz = ls[l].ptMid().Z();	
						sx = lsAr[s].ptMid().X();
						sy = lsAr[s].ptMid().Y();
						sz = lsAr[s].ptMid().Z();	
						//reportNotice("\nL=" + l + " lx:" + lx + " sx:" + sx + " ly:" + ly + " sy:" + sy + " lz:" + lz + " sz:" + sz);
						if ((lx >= sx - U(0.1) && lx <= sx + U(0.1)) && 
							 (ly >= sy - U(0.1) && ly <= sy + U(0.1)) &&
							 (lz >= sz - U(0.1) && lz <= sz + U(0.1)))
							nSegInList = TRUE;
					}
					if (!nSegInList){
						lsAr.append(ls[l]);
						erAr0.append(er[i]);
						erAr1.append(er[e]);	
						sArTypeList.append(sType);
					}
					
					// flag as single segment												
					bSingleSeg = FALSE;
				}
			}// next e

			if (bSingleSeg){
				if (vxSeg.isPerpendicularTo(_ZW)){//horizontal segment
					//ls[l].vis(1);
					sType = sArType[0];// eave						
				}
				else{
					if (vxSeg.isParallelTo(vy[i])){
						ls[l].vis(3);
						sType =sArType[1];// gable end	
					}	
					else{
						ls[l].vis(4);
						sType = sArType[5];// rising eave	 					
					}
				}

				// append segment to list if it's not already in
					lsAr.append(ls[l]);
					erAr0.append(er[i]);
					erAr1.append(er[i]);	
					sArTypeList.append(sType);	
									
			}
			String sSegLength;
			sSegLength.formatUnit(Vector3d(ls[l].ptStart()-ls[l].ptEnd()).length(), 2,0);
			if (_bOnDebug)
				dp.draw("L: " + l +" " + sType + " " + T("Length") + ": " +sSegLength, ls[l].ptMid(), vxSeg, vxSeg.crossProduct(_ZW), 1,2,_kDevice);
			
		}// next l
	}// next i

// end analysis_________________________________________________________________________________	


	
	for (int i = 0; i < lsAr.length(); i++){
		int bAtRidge[0];
		if(sArTypeList[i] == T("Hip Line")){
			for (int j = 0; j < lsAr.length(); j++){
				if(j!=i){
					double dSS,dSE,dEE,dES;
					dSS = Vector3d(lsAr[i].ptStart() - lsAr[j].ptStart()).length();
					dES = Vector3d(lsAr[i].ptEnd() - lsAr[j].ptStart()).length();
					dSE = Vector3d(lsAr[i].ptStart() - lsAr[j].ptEnd()).length();
					dEE = Vector3d(lsAr[i].ptEnd() - lsAr[j].ptEnd()).length();	
					if (sArTypeList[j] == T("Ridge Line") &&
						(dSS <= U(0.1) || dES <= U(0.1) || dSE <= U(0.1) || dEE <= U(0.1) ) )
						bAtRidge.append(TRUE);
				}
			}
		}
		if (bAtRidge.length() == 2){
			sArTypeList[i] = sArType[6];//Verfallgrat
		}				
	}
		
// order by type
	for (int i = 0; i < lsAr.length(); i++)
		for (int j=0; j< lsAr.length()-1; j++)	
			if (sArTypeList[j]>sArTypeList[j+1])
			{
				sArTypeList.swap(j,j+1);
				erAr0.swap(j,j+1);
				erAr1.swap(j,j+1);
				lsAr.swap(j,j+1);	
			}	

// order type by orientation
	for (int i = 0; i < lsAr.length(); i++)
		for (int j=0; j< lsAr.length()-1; j++)	
			if (sArTypeList[j]==sArTypeList[j+1])
			{
				Vector3d vec1 =lsAr[j].ptStart()-lsAr[j].ptEnd();
				Vector3d vec2 =lsAr[j+1].ptStart()-lsAr[j+1].ptEnd();
				if (!vec1.isParallelTo(vec2))
				{
					sArTypeList.swap(j,j+1);
					erAr0.swap(j,j+1);
					erAr1.swap(j,j+1);
					lsAr.swap(j,j+1);
				}	
			}	
			
// order type by length
	for (int i = 0; i < lsAr.length(); i++)
		for (int j=0; j< lsAr.length()-1; j++)	
		{
			Vector3d vec1 =lsAr[j].ptStart()-lsAr[j].ptEnd();
			Vector3d vec2 =lsAr[j+1].ptStart()-lsAr[j+1].ptEnd();			
			if (sArTypeList[j]==sArTypeList[j+1] && vec1.isParallelTo(vec2))
			{
				double d1 = Vector3d(lsAr[j].ptStart()-lsAr[j].ptEnd()).length();
				double d2 = Vector3d(lsAr[j+1].ptStart()-lsAr[j+1].ptEnd()).length();
				if (d1>d2)
				{
					sArTypeList.swap(j,j+1);
					erAr0.swap(j,j+1);
					erAr1.swap(j,j+1);
					lsAr.swap(j,j+1);
				}	
			}	
		}
			
// remove segments which are fully on a segment of same type
	for (int i =lsAr.length()-1;i>=0;i--)//lsAr.length()-1
		for (int j=lsAr.length()-1;j>=1;j--)//
		{
			Vector3d vec1 =lsAr[j].ptStart()-lsAr[j].ptEnd();
			Vector3d vec2 =lsAr[j-1].ptStart()-lsAr[j-1].ptEnd();				
			if (sArTypeList[j]==sArTypeList[j-1] && vec1.isParallelTo(vec2))
			{
				String s = sArTypeList[j];
				double d0 = Vector3d(lsAr[j].ptStart()-lsAr[j].ptEnd()).length();
				double d1 = Vector3d(lsAr[j].closestPointTo(lsAr[j-1].ptStart())-lsAr[j-1].ptStart()).length();
				double d2 = Vector3d(lsAr[j].closestPointTo(lsAr[j-1].ptEnd())-lsAr[j-1].ptEnd()).length();
				if (d1<dEps && d2<dEps)
				{
					lsAr.removeAt(j-1);	
					erAr0.removeAt(j-1);	
					erAr1.removeAt(j-1);	
					sArTypeList.removeAt(j-1);													
				}
			}
			
		}			
			
	
	if(_bOnDbCreated || (_bOnRecalc && (_kExecuteKey==sTrigger[3] || _kExecuteKey==sTrigger[7]))){
		TslInst tslRL;
		// declare tsl props
		String strScriptName = "hsbRP_Roofline"; // name of the script
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEntities[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		
		lstPropInt.append(nDecimals);	


		for (int i = 0; i < lsAr.length(); i++){
			String lstPropString[0];
			Point3d lstPoints[0];
			lstPoints.append(lsAr[i].ptStart());
			lstPoints.append(lsAr[i].ptEnd());	
			lstPropString.append(sDimStyle);	
			lstPropString.append(sArTypeList[i]);
			lstPropString.append(sUnit);	
			lstPropString.append(sGroup0);	
			Map mapTsl;
			mapTsl.setEntity("er0", erAr0[i]);
			mapTsl.setEntity("er1", erAr1[i]);	
			tslRL.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, 
					lstPropInt, lstPropDouble, lstPropString, TRUE, mapTsl ); // create new instance
			
			// append the roofline tsl to the list of linked tsl's
			_Map.setEntity("RL_"+i, tslRL);	
			if (_Entity.find(tslRL)< 0)
				_Entity.append(tslRL);	
		}// next i
	}// end if onDbcreated|| trigger


// add individual roofline
	if(_bOnDbCreated || (_bOnRecalc && _kExecuteKey==sTrigger[4])){

		Point3d lstPoints[0];
		Point3d ptLast = getPoint();
		lstPoints.append(ptLast);
		PrPoint ssP("\n" +T("|Select next point (defines direction)|"),ptLast);
		if (ssP.go()==_kOk)  // do the actual query
		{
			ptLast = ssP.value(); // retrieve the selected point	
			lstPoints.append(ptLast); // append the selected points to the list of grippoints _PtG
		}		


		Map mapTsl;
		
	// prompt for one or two roofplanes	
		PrEntity ssRP(T("|Select roofplane(s)|"), ERoofPlane());
  		if (ssRP.go())
		{			
			Entity ents[0];
			ents = ssRP.set();
			if (ents.length()>0)mapTsl.setEntity("er0", ents[0]);
			if (ents.length()>1)mapTsl.setEntity("er1", ents[1]);			
		}
		
		TslInst tslRL;
		// declare tsl props
		String strScriptName = "hsbRP_Roofline"; // name of the script
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEntities[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		
		lstPropInt.append(nDecimals);	
		
		String lstPropString[0];
		lstPropString.append(sDimStyle);	
		lstPropString.append(sArTypeList[0]);
		lstPropString.append(sUnit);	
		lstPropString.append(sGroup0);

		
		tslRL.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, 
					lstPropInt, lstPropDouble, lstPropString, TRUE, mapTsl ); // create new instance
		
		tslRL.showDialog();
		
		
		int nFree;
		for(int m = 0; m < _Map.length(); m++)
			if (_Map.keyAt(m).left(2) == "RL_")
				nFree++;		

		if (tslRL.bIsValid())
		{
			_Map.setEntity("RL_"+nFree, tslRL);	
			if (_Entity.find(tslRL)< 0)
				_Entity.append(tslRL);
		}	
	}// end if onDbcreated|| trigger



// Group
	if (sGroupMain != "")
	{
		Group gr0();
		gr0.setName(sGroupMain);
		gr0.addEntity(_ThisInst, FALSE);
	}
	if (sGroup0 != "")
	{
		Group gr0();
		gr0.setName(sGroup0);
		gr0.addEntity(_ThisInst, FALSE);
	}
	if (sGroup1 != "")
	{
		Group gr1();
		gr1.setName(sGroup1);
		gr1.addEntity(_ThisInst, FALSE);
	}
	if (sGroup2 != "")
	{
		Group gr2();
		gr2.setName(sGroup2);
		gr2.addEntity(_ThisInst, FALSE);
	}

// start BOM
	String sArRooflineNames[0],sArRooflineLength[0], sArRooflineAngle[0],sArRooflineHipAngle[0];
	double dArRooflineLength[0],dRooflineHipAngles[0];
	String sArRooflinePosnum[0];
	int nBeamPosnum[0], bHasBeam = FALSE;
	TslInst tslRL[0];
	//collect rooflines
	for (int i = 0; i < _Map.length(); i++)
		if (_Map.hasEntity("RL_"+i))
		{
			// cast to tsl
			Entity ent = _Map.getEntity("RL_"+i);
			TslInst myRL 	= (TslInst)ent;
			
			if (myRL.bIsValid())
			{
				String str;
				Map mapSub = myRL.map();
				Map mapBom = mapSub.getMap("TSLBOM");
				sArRooflineNames.append(mapBom.getString("Name"));// type
				dArRooflineLength.append(mapBom.getDouble("Length"));
				sArRooflinePosnum.append(myRL.posnum());	
				
				if (mapBom.getDouble("Angle")!=0)
				{
					str.formatUnit(mapBom.getDouble("Angle"), 2 , nDecimals);
					str = str + "°";	
				}
				sArRooflineAngle.append(str);
				
				str = "";	
				double d;
				if (mapBom.getDouble("AngleHip")!=0)
				{
					d=mapBom.getDouble("AngleHip");
					str.formatUnit(mapBom.getDouble("AngleHip"), 2 , nDecimals);
					str = str + "°";		
				}	
				sArRooflineHipAngle.append(str);
				dRooflineHipAngles.append(d);
				Beam bm[0];
				bm = myRL.beam();	
				if (bm.length() > 0)
				{
					nBeamPosnum.append(bm[0].posnum());
					bHasBeam = TRUE;	
				}
				else
					nBeamPosnum.append(-1);		
				tslRL.append(myRL);		
			}
		}
	// order rooflines
	for (int i = 0; i < sArRooflineNames.length(); i++)
	{
		for (int j = 0; j < sArRooflineNames.length()-1; j++)
		{
			String sComp1, sComp2;
			sComp1 = sArRooflineNames[j] + sArRooflinePosnum[j] + String(nBeamPosnum[j]);
			sComp2 = sArRooflineNames[j+1] + sArRooflinePosnum[j+1] + String(nBeamPosnum[j+1]);
			if (sComp1>sComp2)
			{
				String sTmp = sArRooflineNames[j];
				sArRooflineNames[j] = sArRooflineNames[j+1];
				sArRooflineNames[j+1] = sTmp ;

				double dTmp = dArRooflineLength[j];
				dArRooflineLength[j] = dArRooflineLength[j+1];
				dArRooflineLength[j+1] = dTmp ;

				dTmp = dRooflineHipAngles[j];
				dRooflineHipAngles[j] = dRooflineHipAngles[j+1];
				dRooflineHipAngles[j+1] = dTmp ;
				
				sTmp = sArRooflinePosnum[j];
				sArRooflinePosnum[j] = sArRooflinePosnum[j+1];
				sArRooflinePosnum[j+1] = sTmp ;

				sTmp = sArRooflineAngle[j];
				sArRooflineAngle[j] = sArRooflineAngle[j+1];
				sArRooflineAngle[j+1] = sTmp ;
				
				sTmp = sArRooflineHipAngle[j];
				sArRooflineHipAngle[j] = sArRooflineHipAngle[j+1];
				sArRooflineHipAngle[j+1] = sTmp ;

				int nTmp= nBeamPosnum[j];
				nBeamPosnum[j] = nBeamPosnum[j+1];
				nBeamPosnum[j+1] = nTmp ;

				TslInst tslTmp= tslRL[j];
				tslRL[j] = tslRL[j+1];
				tslRL[j+1] = tslTmp;				
			}
		}
	}	


// collect areas
	String sArEaveMat[0],sArEavePosnum[0];
	double dArEaveArea[0],dArEaveAreaNet[0];
	int nArAreaType[0];
	TslInst tslArea[0];
	PlaneProfile ppTotalRoof, ppTotalEave;
	
	for (int i = 0; i < _Map.length(); i++)
	{
		if (_Map.keyAt(i).find("EAVE",0)>-1)
		{
			// cast to tsl
			Entity ent =  _Map.getEntity(i);// _Map.getEntity("EAVE_"+i);
			TslInst myEave = (TslInst)ent;
			
			if (myEave.bIsValid())
			{
				PLine (myEave.coordSys().ptOrg(),_PtW).vis(6);
				String str;
				Map mapSub = myEave.map();
				//if (_bOnDebug)mapSub.writeToXmlFile("c:\\temp\\aeve"+i+".xml");
				Map mapBom = mapSub.getMap("TSLBOM");
				sArEaveMat.append(mapBom.getString("Mat"));// type
				dArEaveArea.append(mapBom.getDouble("Area"));
				dArEaveAreaNet.append(mapBom.getDouble("AreaNet"));
				sArEavePosnum.append(myEave.posnum());	
				nArAreaType.append(sArAreaType.find(myEave.propString(6)));
				tslArea.append(myEave);
				
				// add rings to total roof shape
				if (myEave.propString(6) == sArAreaType[0])
					if (ppTotalRoof.area() < U(10))
						ppTotalRoof = PlaneProfile(mapBom.getPLine("pl"));
					else
						ppTotalRoof.joinRing(mapBom .getPLine("pl"),_kAdd);
				else
					if (ppTotalEave.area() < U(10))
						ppTotalEave= PlaneProfile(mapBom.getPLine("pl"));
					else
						ppTotalEave.joinRing(mapBom .getPLine("pl"),_kAdd);

			}
		}
	}

	// order eaveareas
	for (int i = 0; i < sArEaveMat.length(); i++)
	{
		for (int j = 0; j < sArEaveMat.length()-1; j++)
		{
			String sComp1, sComp2;
			sComp1 = sArEaveMat[j] + nArAreaType[j];
			sComp2 = sArEaveMat[j+1] + nArAreaType[j+1];
			
			if (sComp1>sComp2)
			{
				String sTmp = sArEaveMat[j];
				sArEaveMat[j] = sArEaveMat[j+1];
				sArEaveMat[j+1] = sTmp ;
				
				sTmp = sArEavePosnum[j];
				sArEavePosnum[j] = sArEavePosnum[j+1];
				sArEavePosnum[j+1] = sTmp ;

				double dTmp = dArEaveArea[j];
				dArEaveArea[j] = dArEaveArea[j+1];
				dArEaveArea[j+1] = dTmp ;

				dTmp = dArEaveAreaNet[j];
				dArEaveAreaNet[j] = dArEaveAreaNet[j+1];
				dArEaveAreaNet[j+1] = dTmp ;
				
				int nTmp = nArAreaType[j];
				nArAreaType[j] = nArAreaType[j+1];
				nArAreaType[j+1] = nTmp ;
				
				TslInst tslTmp= tslArea[j];
				tslArea[j] = tslArea[j+1];
				tslArea[j+1] = tslTmp;		
			}
		}
	}	


// get max width of columns
	double dColWidth[0], dMaxWidth, dRowHeight = dp.textHeightForStyle("O", sDimStyle);
	String sArCol1[0], sArCol2[0], sArCol3[0],sArCol4[0],sArCol5[0],sArCol6[0],sArCol7[0];
	double dArCol3[0];
	int bIsHeader[0];
	TslInst tslCol[0];
	double dSum;
	
// headers roofline
	sArCol1.append(T("|Length of Rooflines|") + " [" + sUnit + "]");
	sArCol2.append("");		
	sArCol3.append("");	
	sArCol4.append("");
	sArCol5.append("");
	sArCol6.append("");
	sArCol7.append("");
	dArCol3.append(0);
	tslCol.append(TslInst());
	bIsHeader.append(TRUE);

	sArCol1.append(T("|Name|"));
	sArCol2.append(T("|Pos|"));		
	sArCol3.append(T("|Length|"));
	sArCol4.append(T("|base angle|"));
	sArCol5.append(T("|hip/valley|"));
	sArCol6.append(T("|section|"));
	sArCol7.append(T("|Bend °|"));	
	dArCol3.append(0);
	tslCol.append(TslInst());
	bIsHeader.append(TRUE);

// add roofline data
	for (int i = 0; i < sArRooflineNames.length()-1; i++)
	{
		String sComp1, sComp2;
		sComp1 = sArRooflineNames[i] + sArRooflineHipAngle[i] + String(nBeamPosnum[i]);
		sComp2 = sArRooflineNames[i+1] + sArRooflineHipAngle[i+1] + String(nBeamPosnum[i+1]);

		if (sComp1 != sComp2)
		{
			//if (dSum == 0)
			//	dSum = dArRooflineLength[i];
			//else
				dSum += dArRooflineLength[i];
			sArCol1.append(sArRooflineNames[i]);
			sArCol2.append(sArRooflinePosnum[i]);
			String sLength;
			sLength.formatUnit(dSum/U(1,sUnit,nLUnit ), nLUnit , nDecimals);
			sArCol3.append(sLength);
			sArCol4.append(sArRooflineAngle[i]);
			sArCol5.append(sArRooflineHipAngle[i]);
			sArCol6.append("");
			
			double dBendAngle = 180-dRooflineHipAngles[i];
			if (dBendAngle>dEps && dBendAngle<180-dEps)
			{
				String str;
				str.formatUnit(dBendAngle, 2 , nDecimals);
				sArCol7.append(str + "°");
			}
			else
				sArCol7.append("");
			tslCol.append(tslRL[i]);
			bIsHeader.append(0);
			dSum = 0;
		}
		else
			dSum = dSum + dArRooflineLength[i];	
			
		if (i == sArRooflineNames.length()-2)
		{
			dSum += dArRooflineLength[i+1];
			sArCol1.append(sArRooflineNames[i+1]);
			sArCol2.append(sArRooflinePosnum[i+1]);				
			String sLength;
			sLength.formatUnit(dSum/U(1,sUnit,nLUnit ), nLUnit , nDecimals);
			sArCol3.append(sLength);
			sArCol4.append(sArRooflineAngle[i+1]);
			sArCol5.append(sArRooflineHipAngle[i+1]);	
			sArCol6.append("");
			double dBendAngle = 180-dRooflineHipAngles[i+1];
			if (dBendAngle>dEps && dBendAngle<180-dEps)
			{
				String str;
				str.formatUnit(dBendAngle, 2 , nDecimals);
				sArCol7.append(str);
			}
			else
				sArCol7.append("");			
			tslCol.append(tslRL[i+1]);			
			bIsHeader.append(0);	
		}		
	}// next i
// END add roofline data	
						
// header eave/roof area
	if (sArEaveMat.length()> 0)
		if(nArAreaType[0] == 0)// roof area
		{
			sArCol1.append(sArAreaType[0] + " [" + sUnit + "2]");
			sArCol1.append(T("|Name|"));
			
		}
		else// eave area
		{
			sArCol1.append(T("|Canopy Area|") + " [" + sUnit + "2]");
			sArCol1.append(T("|Material|"));
		}		
	sArCol2.append("");		
	sArCol3.append("");	
	sArCol4.append("");
	sArCol5.append("");
	sArCol6.append("");
	sArCol7.append("");
	dArCol3.append(0);
	tslCol.append(TslInst());
	bIsHeader.append(TRUE);
	
	sArCol2.append("");		
	sArCol3.append(T("|Brut|"));
	sArCol4.append(T("|Net|"));
	sArCol5.append(T("|Diff. Area|"));
	sArCol6.append("");
	sArCol7.append("");	
	dArCol3.append(0);
	tslCol.append(TslInst());
	bIsHeader.append(TRUE);

// determine the actual area type (roof or eave)
	int nActualType = -1;
	if (sArEaveMat.length()> 0) nActualType = nArAreaType[0];
		
// add area data
	double dSumRoofArea,dSumRoofAreaNet,dSqrt, dSumOuter;
	dSum=0;
	
	for (int i = 0; i < sArEaveMat.length(); i++)
	{
		if (bDebug)reportMessage("\neave " + i + "_______________________");
		
		String sComp1, sComp2;
		if (i<sArEaveMat.length()-1)
		{
			sComp1 = sArEaveMat[i] + nArAreaType[i];
			sComp2 = sArEaveMat[i+1] + nArAreaType[i+1];
	
			if (nArAreaType[i] == 0)
				sComp1 = sComp1 + tslArea[i].propString(4);	//name
			if (nArAreaType[i+1] == 0)
				sComp2 = sComp2 + tslArea[i+1].propString(4);	//name
		}
	// single position output === roofarea
		if (nArAreaType[i] == 0)
		{
			String s= tslArea[i].propString(4);//name
			if (sComp1!=sComp2) s = s+ " " + sArEaveMat[i];
			
			if (sArCol1.find(s)>-1) continue;
			
			dSumRoofArea += dArEaveArea[i];
			dSumRoofAreaNet += dArEaveAreaNet[i];
			sArCol1.append(s);	//name
			if (bDebug)reportMessage("\nadding at 1604: "+"\n	" + sArCol1+ "\n	" + sArCol1[sArCol1.length()-1] + "\n\n");
			sArCol2.append("");								// posnum
			String sArea;
			
			dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dArEaveArea[i]);
			sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);
			sArCol3.append(sArea);
			
			dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dArEaveAreaNet[i]);
			sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);
			sArCol4.append(sArea);
			dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt((dArEaveArea[i]-dArEaveAreaNet[i]));
			sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);
			// suppress zeros
			if (sArea != "0")
				sArCol5.append(sArea);
			else
				sArCol5.append("");
			sArCol6.append("");
			sArCol7.append("");
			tslCol.append(tslArea[i]);
			bIsHeader.append(FALSE);

		// sum roof area
			if (sComp1 != sComp2)
			{
				sArCol1.append(T("|total area|"));
				if (bDebug)reportMessage("\nadding at 1632: " +"\n	" + sArCol1+ "\n	" + sArCol1[sArCol1.length()-1] + "\n\n");
				sArCol2.append("");
				String sArea;
				dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dSumRoofArea);
				sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);
				sArCol3.append(sArea);
				dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dSumRoofAreaNet);
				sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);
				sArCol4.append(sArea);
				sArCol5.append("");
				sArCol6.append("");
				sArCol7.append("");
				tslCol.append(TslInst());
				bIsHeader.append(FALSE);				
			}	

			// Version 3.4 removed
			if (i == sArEaveMat.length()-2)
			{
				dSumRoofArea += dArEaveArea[i+1];
				dSumRoofAreaNet += dArEaveAreaNet[i+1];
				sArCol1.append(tslArea[i+1].propString(4));
				//reportMessage("\nadding at 1650: "+"\n	" + sArCol1+ "\n	" + sArCol1[sArCol1.length()-1] + "\n\n");
				sArCol2.append("");	//sArCol2.append(sArEavePosnum[i+1]);				
				String sArea;
				dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dArEaveArea[i+1]);
				sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);	
				sArCol3.append(sArea);
				dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dArEaveAreaNet[i+1]);
				sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);					
				sArCol4.append(sArea);
				sArCol5.append("");
				sArCol6.append("");
				sArCol7.append("");
				tslCol.append(tslArea[i+1]);
				bIsHeader.append(FALSE);
				
				
				// sum roof area
				if (sComp1 != sComp2)
				{
					sArCol1.append(T("|total area|"));
					reportMessage("\nadding at 1671: "+sArCol1[sArCol1.length()-1]);	
					sArCol2.append("");
					String sArea;
					dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dSumRoofArea);
					sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);		
					sArCol3.append(sArea);
					dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dSumRoofAreaNet);
					sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);						
					sArCol4.append(sArea);
					sArCol5.append("");
					sArCol6.append("");
					sArCol7.append("");
					tslCol.append(TslInst());
					bIsHeader.append(FALSE);				
				}	
				
			}// END if (i == sArEaveMat.length()-2)

		// insert header for area type [1]
			if (i<nArAreaType.length()-2 && nArAreaType[i] != nArAreaType[i+1])
			{
				String sTmp = sArAreaType[0];
				if (nArAreaType[i+1]==1) sTmp =T("|Canopy Area|");
				sArCol1.append(sTmp + " [" + sUnit + "2]");
				sArCol2.append("");		
				sArCol3.append("");	
				sArCol4.append("");
				sArCol5.append("");
				sArCol6.append("");
				sArCol7.append("");
				dArCol3.append(0);
				tslCol.append(TslInst());
				bIsHeader.append(TRUE);
	
				if (nArAreaType[i+1] == 0)
					sArCol1.append("");
				else
					sArCol1.append(T("|Material|"));
				if (bDebug)reportMessage("\nadding at 1713: "+"\n	" + sArCol1+ "\n	" + sArCol1[sArCol1.length()-1] + "\n\n");	
				sArCol2.append("");		
				sArCol3.append(T("|Area|"));
				sArCol4.append("");
				sArCol5.append("");
				sArCol6.append("");
				sArCol7.append("");
				dArCol3.append(0);
				tslCol.append(TslInst());
				bIsHeader.append(TRUE);
			}	
		}
		else// eave areas
		{
			
			if (sComp1 != sComp2)
			{
				dSum += dArEaveArea[i];
				sArCol1.append(sArEaveMat[i]);
				if (bDebug)reportMessage("\nadding at 1726: "+sArCol1[sArCol1.length()-1]);
				sArCol2.append("");//sArCol2.append(sArEavePosnum[i]);
				String sArea;
				dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dSum);
				sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);		
				sArCol3.append(sArea);
				sArCol4.append("");
				sArCol5.append("");
				sArCol6.append("");
				sArCol7.append("");
				tslCol.append(tslArea[i]);
				bIsHeader.append(0);
				dSum = 0;			
			}
			else
				dSum = dSum + dArEaveArea[i];	

			if (i == sArEaveMat.length()-2 || nArAreaType[i]==0)
			{
				// version 2.9
				//if (nArAreaType[i]==0)
					dSum +=dArEaveArea[i+1];					
				//else
				//	dSum =dArEaveArea[i+1];
				if (nArAreaType[i]==0)// type roof
					sArCol1.append(tslArea[i].propString(4));
				else
					sArCol1.append(sArEaveMat[i+1]);
				if (bDebug)reportMessage("\nadding at 1754: "+sArCol1[sArCol1.length()-1]);	
				sArCol2.append("");	//sArCol2.append(sArEavePosnum[i+1]);				
				String sArea;
				dSqrt = U(1,"mm")/U(1,sUnit,nLUnit)*sqrt(dSum);
				sArea.formatUnit(dSqrt*dSqrt , nLUnit , nDecimalsArea);	
				sArCol3.append(sArea);
				sArCol4.append("");
				sArCol5.append("");
				sArCol6.append("");
				sArCol7.append("");
				tslCol.append(tslArea[i+1]);
				bIsHeader.append(0);

			}					
		}// end eave areas
		reportMessage("\nnext...");
	}// next i sArEaveMat		
				
				
	U(1,"mm");
// max width column 0, don't take absolute header		
	for (int i = 1; i < sArCol1.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol1[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	dColWidth.append(dMaxWidth + dRowHeight);

// max width column 1	
	dMaxWidth =0;
	for (int i = 1; i < sArCol2.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol2[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	dColWidth.append(dMaxWidth + dRowHeight);
	
// max width column 2	
	dMaxWidth =0;	
	for (int i = 1; i < sArCol3.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol3[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	dColWidth.append(dMaxWidth + dRowHeight);

// max width column 3	
	dMaxWidth =0;	
	for (int i = 1; i < sArCol4.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol4[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	dColWidth.append(dMaxWidth + dRowHeight);

// max width column 4	
	dMaxWidth =0;	
	for (int i = 1; i < sArCol5.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol5[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	dColWidth.append(dMaxWidth + dRowHeight);

// max width column 5	
	dMaxWidth =U(300);	
	for (int i = 1; i < sArCol6.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol6[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	dColWidth.append(dMaxWidth + dRowHeight);

// max width column 6	
	dMaxWidth =U(300);	
	for (int i = 1; i < sArCol7.length(); i++)
	{
		double dMyWidth = dp.textLengthForStyle(sArCol7[i], sDimStyle);
		if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	}
	
	// complete roof
	LineSeg lsPP = ppTotalRoof.extentInDir(_XW);
	double dHeight = abs(_YW.dotProduct(lsPP.ptStart()-lsPP.ptEnd()));
	double dScale;
	if (dHeight > 0)
		dScale = U(300) / dHeight ;
				
	// max width from roofplane _XW size
	double dMyWidth = abs(_XW.dotProduct(lsPP.ptStart()-lsPP.ptEnd())) * dScale;
	if (dMyWidth > dMaxWidth)	dMaxWidth = dMyWidth;
	
	dColWidth.append(dMaxWidth + dRowHeight);

// START DRAWING TABLE______________________________________________________________________________________________
	Point3d ptRef;
	double dRefOffset;
	Vector3d vxTxtOff = -_XW * 0.2 * dRowHeight;
	// draw row col 5
	// draw this row first to collect dynamic row height
	double dRowH[0];
	for (int i = 0; i < dColWidth.length(); i++)
		dRefOffset += dColWidth[i];
	ptRef = _Pt0 + _XW * dRefOffset;								ptRef.vis(5);
	
	PLine plHor(ptRef, ptRef - _XW * dRefOffset);
	dp.draw(plHor);

	Point3d ptRefOld;
	for (int i = 0; i < sArCol6.length(); i++)
	{
		ptRefOld = ptRef;
		String sScript = tslCol[i].scriptName();
		sScript.makeUpper();
		// draw header
		//reportNotice("\ndraw line " + i + ", header:" + bIsHeader[i]);
		if (bIsHeader[i]) 
		{
			dp.draw(sArCol6[i],ptRef - _XW * 0.5 * dColWidth[5],  _XW, _YW, 0,-1.8);
			ptRef.transformBy(-_YW * dRowHeight * 2);				ptRef.vis(i);
			dRowH.append(dRowHeight * 1.5);
			PLine plHor(ptRef, ptRef - _XW * dRefOffset);
			//dp.color(myCol);
			dp.draw(plHor);
		}
		// draw data
		else
		{
			dRowH.append(dRowHeight);
			double dShopTxtHeight = dpShop.textHeightForStyle("O",sDimStyleShop);
		// add beam related graphics	
			//get the beam
			Beam bm[0];
			bm = tslCol[i].beam();
			if (bm.length() > 0)
			{
				
				PlaneProfile pp = bm[0].realBody().shadowProfile(Plane(bm[0].ptCen(),bm[0].vecX()));
				LineSeg lsPP = pp.extentInDir(bm[0].vecZ());

				double dNewHeight = abs(bm[0].vecZ().dotProduct(lsPP.ptStart()-lsPP.ptEnd()))
					+ 2 * dShopTxtHeight ;
				if (dNewHeight  > dRowH[i])
					dRowH[i]= dNewHeight ;
				Point3d ptCenDraw = ptRef - _XW * 0.5 * dColWidth[5] - _YW * (0.5 * dRowH[i] + dShopTxtHeight);	ptCenDraw.vis(222);

			
				CoordSys cs;
				cs.setToAlignCoordSys(bm[0].ptCen(), bm[0].vecX(),bm[0].vecY(),bm[0].vecZ(),ptCenDraw, _ZW,_XW,_YW);
				pp.transformBy(cs);

				dpShop.color(bm[0].color());
				dpShop.draw(pp);
				dpShop.color(nColorTable);
					
				// get dim points
				PLine pl[] = pp.allRings();
				if (pl.length() > 0)
				{
					DimLine dlHor(ptRef - _YW * 1.5 * dShopTxtHeight , _XW, _YW);
					DimLine dlVer(ptRef - _XW * 1.5 * dShopTxtHeight , _YW, -_XW);
					Point3d pts[] = pl[0].vertexPoints(true);
					Dim dimHor(dlHor,"<>","<>",_kDimPerp);
					Dim dimVer(dlVer,"<>","<>",_kDimDelta);
					dimVer.setDeltaOnTop(FALSE);
					for (int p = 0; p < pts.length(); p++)
					{
						dimHor.append(pts[p]);
						if (_YW.dotProduct(ptCenDraw-pts[p])<0)
							dimVer.append(pts[p]);
					}
					dpShop.draw(dimHor);	
					dpShop.draw(dimVer);	
				}// end valid pl
			}// end valid beam
		// add area related graphics
			else if (sScript == "HSBRP_EAVEAREA")
			{
				

				double dNewHeight = U(300)	+ dShopTxtHeight ;
				if (dNewHeight  > dRowH[i])
					dRowH[i]= dNewHeight ;
				Point3d ptCenDraw = ptRef - _XW * 0.5 * dColWidth[5] - _YW * (0.5 * dRowH[i]);	ptCenDraw.vis(222);
		
				CoordSys cs;
				cs.setToAlignCoordSys(lsPP.ptMid(), _XW,_YW,_ZW,ptCenDraw, _XW * dScale,_YW * dScale,_ZW * dScale);
				PlaneProfile pp = ppTotalRoof;
				pp.transformBy(cs);		
				dpShop.color(nColorTable);		
				dpShop.draw(pp);
				
				// single roofplane
				if (tslCol[i].propString(6) == sArAreaType[0])
				{
					
					Map mapSub = tslCol[i].map();
					Map mapBom = mapSub.getMap("TSLBOM");
					PLine plSingle = mapBom.getPLine("pl");
					pp = PlaneProfile(plSingle);
					
					// subtract openings from hatch area
					for (int m = 0; m < mapSub.length(); m++)
					{
						String sToken = mapSub.keyAt(m);
						if (sToken.left(5) == "plSub")
							pp.subtractProfile(PlaneProfile(mapSub.getPLine(m)));
					}
					
					
				
					dpShop.color(nColor2);
				}
				// eave area
				else
				{
					pp = ppTotalEave;
					pp.subtractProfile(PlaneProfile(plOl));
					dpShop.color(nColor1);
				}
				pp.transformBy(cs);	
				dpShop.draw(pp,_kDrawFilled);
				dpShop.color(nColorTable);
			
			}	
			PLine plHor(ptRef, ptRef - _XW * dRefOffset);
			dp.draw(plHor);
			ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));	
			plHor = PLine(ptRef, ptRef - _XW * dRefOffset);
			dp.draw(plHor);
			ptRef.vis(i);
		}// else: not header
		PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
		dp.draw(plVer);
		
	}// next i
	
	plHor = PLine (ptRef, ptRef - _XW * dRefOffset);
	dp.draw(plHor);	
	// end column 5

								
	// draw rows col 1
		dRefOffset = 0;
		ptRef = _Pt0 + _XW * dRefOffset;					ptRef.vis(0);
		ptRefOld = ptRef;
		for (int i = 0; i < sArCol1.length(); i++)
		{
			
			if (bIsHeader[i]) 
			{
				dp.draw(sArCol1[i],ptRef - vxTxtOff ,  _XW, _YW, 1,-1.8);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.5));
			}
			else
			{
				dp.draw("  " + sArCol1[i],ptRef - vxTxtOff ,  _XW, _YW, 1,-1.3);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));		
			}
			ptRef.vis(i);
			PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
			dp.draw(plVer);
		}
		//plVer = PLine(ptRef, ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef));
		//dp.draw(plVer);

		

	// draw rows col 2
		dRefOffset = dColWidth[0] + dColWidth[1];
		ptRef = _Pt0 + _XW * dRefOffset;					ptRef.vis(1);	
			
		for (int i = 0; i < sArCol2.length(); i++)
		{
			
			if (bIsHeader[i]) 
			{
				dp.draw(sArCol2[i],ptRef + vxTxtOff ,  _XW, _YW, -1.1,-1.8);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.5));
				if (i>0 && !bIsHeader[i-1] || i == 0)ptRefOld = ptRef;		
			}
			else
			{
				dp.draw(sArCol2[i],ptRef + vxTxtOff ,  _XW, _YW, -1.3,-1.3);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));		
			}
			PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
			dp.draw(plVer);
	
			ptRef.vis(i);	
								
		}
	
		
	// draw rows col 3
		dRefOffset += dColWidth[2];
		ptRef = _Pt0 + _XW * dRefOffset;					ptRef.vis(2);
		for (int i = 0; i < sArCol3.length(); i++)
		{
			if (bIsHeader[i]) 
			{
				dp.draw(sArCol3[i],ptRef + vxTxtOff ,  _XW, _YW, -1.1,-1.8);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.5));
				if (i>0 && !bIsHeader[i-1] || i == 0)ptRefOld = ptRef;
			}
			else
			{
				dp.draw(sArCol3[i],ptRef + vxTxtOff ,  _XW, _YW, -1.3,-1.3);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));		
			}
			PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
			dp.draw(plVer);
			ptRef.vis(i);
		}
		//plVer = PLine(ptRef, ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef));
		//dp.draw(plVer);
		
	// draw rows col 4
		dRefOffset += dColWidth[3];
		ptRef = _Pt0 + _XW * dRefOffset;					ptRef.vis(3);
		for (int i = 0; i < sArCol4.length(); i++)
		{
			if (bIsHeader[i]) 
			{
				dp.draw(sArCol4[i],ptRef + vxTxtOff ,  _XW, _YW, -1.1,-1.8);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.5));
				if (i>0 && !bIsHeader[i-1] || i == 0)ptRefOld = ptRef;
			}
			else
			{
				dp.draw(sArCol4[i],ptRef + vxTxtOff ,  _XW, _YW, -1.3,-1.3);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));		
			}
			PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
			dp.draw(plVer);			
			ptRef.vis(i);				
		}
		//plVer = PLine(ptRef, ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef));
		//dp.draw(plVer);	
		
	// draw rows col 5
		dRefOffset += dColWidth[4];
		ptRef = _Pt0 + _XW * dRefOffset;					ptRef.vis(4);
		for (int i = 0; i < sArCol5.length(); i++)
		{
			if (bIsHeader[i]) 
			{
				dp.draw(sArCol5[i],ptRef + vxTxtOff ,  _XW, _YW, -1.1,-1.8);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.5));
				if (i>0 && !bIsHeader[i-1] || i == 0)ptRefOld = ptRef;
			}
			else
			{
				dp.draw(sArCol5[i],ptRef + vxTxtOff ,  _XW, _YW, -1.3,-1.3);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));		
			}	
			PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
			dp.draw(plVer);			
			ptRef.vis(i);	
		}
		
	// draw rows col 6
		dRefOffset += dColWidth[5];
		ptRef = _Pt0 + _XW * dRefOffset;					ptRef.vis(4);
		for (int i = 0; i < sArCol7.length(); i++)
		{
			if (bIsHeader[i]) 
			{
				dp.draw(sArCol7[i],ptRef + vxTxtOff ,  _XW, _YW, -1.1,-1.8);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.5));
				if (i>0 && !bIsHeader[i-1] || i == 0)ptRefOld = ptRef;
			}
			else
			{
				dp.draw(sArCol7[i],ptRef + vxTxtOff ,  _XW, _YW, -1.3,-1.3);
				ptRef.transformBy(-_YW * (dRowH[i] + dRowHeight * 0.4));		
			}	
			PLine plVer(ptRef,ptRefOld );//ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef)
			dp.draw(plVer);			
			ptRef.vis(i);	
		}		
		//plVer = PLine(ptRef, ptRef + _YW * _YW.dotProduct(_Pt0 - ptRef));
		//dp.draw(plVer);	



	
// end BOM

// set dependencies
	for (int i = 0; i < _Entity.length();i++)
		setDependencyOnEntity(_Entity[i]);























#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`<P!S``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`.J!,@#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`***:2%&2<#WH`=16%?^*M*T^\@MIIBS2_Q1C<
MJ>Y/:MI'61`R,&4]"#0`^BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**JWE
M_:V"!KF98\]`3R?H*QY]<N;G]U86K*7X$K_PG/I0!IZAJUKIX"ROF5ONQKRQ
M_"L*2.YU2*6XOY7@M8_F,8;``QTXZ].]:&GZ+AS<7CF65CN.[J#_`)_I4.JW
M!O+E-,ML&(G$I`[^F:`,O1-"AOVDN;A#Y;$E5STY_P`/ZU?30KW3Y)&T^[:-
M7ZKU4>^/6M^SM4L[9(D&`!5B@#G;;Q&\,QM]4@,+K_RT4?*>3VZ^E;T,T<\8
MDA=70]&4Y%17%E;W2%98P??N#6#-9W6AS">S?=`3EX3T(`[>G_UA0!T]%5+&
M_@U"W$L#9'0J>JGT-6Z`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HI"0!DG`K.N=:L+1_+>Y1I,D;%
M.3GT]J`+[,J*68A5`R23@"L&X\0M)-Y6GVYG'(\T_=![?U%5VN+O7)UC19(+
M93RI_CYZG_#_`.M6_:6,%G'MB0`]S0!C6FBSW<_VK4WWR$8`Z8_#M6]%;Q0K
MMC0**EHH`Q]<U&2R@CBMSB>=BJG&2H`R3CO2Z+I@LH?,=B\C\Y)R:J.K:CKX
M8!?L\`V`YSR,YX[?_6KHAP,4`%%%%`!36577:P!'H:=10!S5WID^G71N],D*
M*1\T.,J>_(_SWK3TW5XK\M&5,5PGWHVZ_A6E6#JND2%_M5BQCG7!&WVH`WJ*
MPM.UWS)1:WRK#=9VC'W6/^<?G6X#D9'2@!:***`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BJMWJ%I8ION9TC'8$\G\*HR>)-/2
M+>C229'`5#S0!KD@#)X%8-SKSROY.EPB9CD"4_<SZ57G:^UN7RQ&T-D.H!P6
MYX)/IC_/%;EE80V4"QH,G'+'J:`,B+3-0NE!O;MFY'&<#'T'OZU>BT.SC?>T
M89CU]/\`ZU:E%`#(XDB7:B@"GT44`%9>MW;VUALB)$TY\M".Q(K4KEM887VO
MVMO$,M:G<QQG)/;VH`UM%L!968R!O;DD5ITU0%4`#``Z4Z@`HHHH`****`"B
MBB@#/U#2;>_0AAM;L0*R&.H:&P*?O[55QY1)X]\GZ?SKIZ:Z*Z[6`(]#0!5L
M=1MK^,O`^2#AE/!!^E7*PK_2)(R+BP=HY$'"KT_+O3M,UKSF6UOE6&Z``QGA
M_7'\_I0!MT444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%,9UC0N[
M!549))P`*`&SSQ6L#33.$C49)-<_/J-]JNT::#%"&(:3^(\=/;G^E,DE'B#4
M#`JYM8&QC/WNV<>E='!!';Q+'&H`'I0!D6_A^)L279+R9W'Z^M:"Z99HP98%
M##H<=*N44`-5%0`*H`'84ZBB@`HHHH`****`*6JW?V#3+BY&-R(=H/<]OUK/
MT&T#1?;91^^<DDGU/?\`6D\1W:K%%9`*TDSJ<'L,]?SQ6M91>1:1Q\\#O0!8
MHHHH`****`"BBB@`HHHH`****`"LK5-&AOD+`;9>Q!K5HH`YNQUB:PE%GJN5
M^;;'.W`8>_O71@@C(.152^T^&_A*2#GL<=*Q9;34=(`>RF$D(/,;@D?SX[_C
M0!TU%9&GZ[;WL@@<&"ZQS$_;'7FM>@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**R=
M1UNWT[<G^MG`)$2$9_'TZBL])=:U)S)&WV>+.-@&"!SW]:`-R]OH;"`RSO@=
MAW8^@K`(OM>8!U,-F0#L!QG'?(_STJQ9^'0KF6[F>:0]W8DXZXYK?1%C0*HP
M!0!7L[**RBV1*`3R3ZFK5%%`!1110`4444`%%%5[J[AM(6EG<*JC/J?RH`L4
MR1UBC+N0JJ.23BL.Y\21(WEVUK--(>F5V@^OZ9_*N/\`$WB#4=4M?LMFXC0M
ME]G'`/`SWZ=1C_#.I6A25YNQI2HSJNT%<ZK2XFU'4IM0E!"D_(I[`=._^>:Z
M6N-T35KG3M-M!>HLELZ\SJ>5^H[_`/UC766US#=P)-`X>-QD$5:::NB&FG9D
MU%%%,04444`%%%%`!1110`4444`%%%%`!1110!DZAI$=POF0'RY1R-O&:HV&
MLM8R+9:FQ!!VQSMT;G@'_'VKI*IZAI\5];M&PP3WH`N=N**YGR]8TH*(9!+;
MH,!7&>/KUK0L-;MKV46[_NKG&3&W]#_GI0!K4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%(2`,DX%8-QK;W
M4DEKIT;,V"OG_P`(/M^OY4`;CR)&I9V50.<DXK`U#6I+F4V6E_-)G#RXX7G&
M![TR/0+B\D2?4;EGD48'/';/'X5MVUC!:CY$&3U-`%+3M#@M!YCC?*><GM6J
M`%``&`.U.HH`****`"BBB@`HHI"0!DG`H`6D)`&3P*S;K7=.M#B6Z3()!V_-
MC'7..E<MK7C7>#:Z5&6+=9CT`]L5G4JPIJ\W8TITIU'RP5SHM1UI+=7CM0DL
MP!R6.%7'<GV_I7#SZM>3WC3B4EL;1(PY(^G0#V_QJDAF,>V65G&<[2>`?ITI
MU>%BLTE/W:6B[GO83*HP]ZKJ^W05W>0()9))`GW=[%MOTS2445Y,I.3NV>O&
M*BK(NZ?J<MAN38LL#G+1/_,>A_SS721:=<"#[;H]T46=,_/\V!Z'W'(KCJM6
M>I7FGY%M<-&#U7@K]<'C/'6O1P6/=#W9ZQ_(\W'9>J_OPTE^9V!UZ\MV"SZ<
M\FT9=H^,<^_^/:MFRO8;^V6:$G'=2,%3Z$5EZ)JT6L6I2;8+A<^9&!@8SP1_
MGK^%5)(W\/Z@T\*9M92`Z=/;(]*^BIU(U8J<7HSYNI3E2DX35FCJ:*AM[B*Z
M@2:!P\;#((-35H0%%%%`!1110`4444`%%%%`!1110`4444`'UK)U+1(+U<K\
MD@&`1QQ6M10!S#R:OI+[RS7-NH^ZQ&?KG_/%;ME?V]_%O@D!QU7/(^M6&177
M:P!'H:P;S29K>4W.GN8V'\*C/Z=/2@#H**R--UC[3)]GNX_(NAT4GAL#DBM>
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHK,U#6[6Q
M+1[Q+<`<1(<G\?2@#2)`&2<"LV77+%`PCF\YE&<1\_KTK*2UU#6WW7FZ&VR"
M(LD8_P#BOQ]*U[;1[*UY2%0V<\#O0!C/]OUZ81R1M;VJ')5203VY/Y_Y%=#9
MV,-E$$B0"IPH48``IU`!1110`4444`%%%4[O4[.Q4FXN$0C^'.6_*@"Y2$@#
M)X%<9K7C!X<V]C"?,/\`&V,C\.W&#7,SZMK=[@7%^ZKQE8SM!X]OZUR5\;2H
MNTGJ==#!5JRO%:'H.JZ];:8"K?O)<`[00`,],D\=<?G7,WVO)?-O>X9H1T@C
M4J/7))_S[5SP1FP99&D(&!N[?YQ3^E>97S>5[4E]YZE#)XK6J_N)+JY>[W(Q
MVPDC]T.G'3/K4*1K&,*``*=17DU*LZCO-W/7IT84U:"L%%%%9FH4444`%%%%
M`!6@->U(0K$UR9$4YQ*H8GGN3S^M9]%7"K.F[P=C.I2A45IJYU=K>W.F)'/"
M!/IL_P`P!.73/7VZ\$>H]ZZ>TO[6]5C;RJY4X9<\J?<=JX"QUVZL;,6JI#+%
MN+#S@25SV'/'_P!<U8BU&UNI5&TV,YP!-&WR@]_3;Z?CR:^DH9E1FDI.S_4^
M9KY;6IMN*NOT/0J*YB+5]0T]S#J$#3*#_K(Q\WY=/_K5O6E[!>Q"2"0,OY$?
MA7HGG%FBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#*U31HK^-BI9)/53B
MLZSU:\TZ8VNJ)F-1\LP'/X^M=-5>YM(;I"LB`^^.:`)4=74,C`@]Q3ZY94G\
M/7CM&I>TD.60=N>HKH+.\@OK=9H&R#V(P1]10!9HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHJ*::*WC,DTBQH.K,<`4`2UG7FM6-BVR6<&3&=B<FLR34KC5
MB8=/5XX#P9NA((_3_P#5TJW8Z!:VFUV7=+W.3S_DT`59M1U#42(K"(PQ-UF/
M)(]O3O\`_6JYI^B1V^);@^;.>K&M1(TC&$4*/84^@!H`4``8`[4ZBB@`HHHH
M`**I7VHVVGJIG?#/PJCJ?\_UK`O=4U9X);B();V\8W#WQVW'U[<=Z3:BKL:3
M;LC=GU2PM2ZSW<,;(,E"XW=,].M46\6Z$D+2'48L*2".=WY=:\Q:QDG=I+B=
MY'8Y+,<DGWS4B6$"G)4$]_>O%>;6>Q[4<HNM7J===^-DNALLM\<>>6*G>1Z#
ML*RO[2C\J0"V83..)&FSM)ZGI_6LY8U0850*=7)5S2O/2+LCMHY50AK+5B*B
MH,`8I:**\T](****!A1110`4444`%%%%`!1110`4444`%%%%`'46'BF$QQ6^
MH0N0JA3,#N)[9(Z].O)^E7KC33-`M[H]R1E=R;!U_P`XZ>U<36MHNO2Z4?*9
M!):N^YUQ\PXP2#^77T[5[&#S.47RUGIW/$QF5Q:YZ*U['7:3J[W/^CWT:PW0
M';[K?2MFN;+6NNVQN;%BLRG#!N&4]L@?Y_6K&DZNT[FRO/DNTS@G`\P#T]^1
M7O0G&<5*+NF>#*,H-QDK,W****HD****`"BBB@`HHHH`****`"BBB@`HHHH`
M8\:2+M=017.WNE2Z?*;W3B5<$;@#]X>A'^>WI72TUE#*5(R#P10!0TS58=0A
M`W!9Q]^,GD5HUB7NA*[F:U=HI>H*L0<_6JUMJ]Q8S);ZJ0%.<3$;><]_;G_&
M@#I**:K!E!4Y!IU`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!156[O[:RCWW,RQCL">3^%9,VNM<
MYATV-F+#B4C@9Z8'YT`7M1U:.RQ&,27#<K&#V]ZRHM*O-4;SM1G.W.5B'0#_
M``_^M5S3-#2!S<W#O+,W)+G)K:`P,"@"*"VBMUVQH!ZU-110`444R218HV=V
M"JHR23B@!Q.!D\5F7FN6-F63S1+,,_NHSDY';VK'O-1EU$3;)?L^G)P[L,%A
MZ^O7''?\<51T_6]*M8T:2RG$P'S8"L/SR/Y5C5Q%*DTIRM<VI8>K53<(WL;8
MUNYDCS'9E2V=A<Y'3@G_`/76#+XSNI$,879GI)%%_1C46M>(#?*L%EYD-KM^
M9<!2Q.<@X/3':L2O*Q6:N,N6C]YZV%RE2CS5ON-'^UU,TD[6YFF;G?.^0?JH
M_$#GTI]_X@O=0MOL[K#%"?O+&F-W((ZY].U9=%>;5QU>I=2EH>G3P%"G9QCJ
M@HHHKD.P****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`-7P_JBZ7J!:7=Y,J[&P>G/#8[X_J:ZK4+*WU2W:>SF1I%/WXF!Y'.,BN`I4
M9D=71BK*<@@X(->CA,QEAX\C5T>9B\MC7ESIV9Z'HVJR7(>UNUV74.`2<#S!
MZ@9K9KRF34+MY4EDE+E<<XPPQCG(P<\=S7:Z7KXDC2.]_=$J"LK_`"A^.OM7
MNX;%T\0KPZ'@XG"5,.TI]3H:*/I174<H4444`%%%%`!1110`4444`%%%%`!1
M110`54O;"&^A9)%P2,!AU%6Z*`.96YO="00RQFXA'"D'G''?_/6MRTO8+Z(2
M0-D9((/!!'M4[QI(NUU!'O7.7^E3:?<+?::=KJ?F'9AZ&@#IJ*S]*U2'5+;>
MA42+Q)&&R5-:%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!115'4M2ATZ'<Q#2L#Y<?=C0!-=7D%E"TL\@1%_/\`*L6?
M6;NZD,.FP?*?^6[_`-!^7^%)8Z<^JF._OQ^\(Z`\8],5OPP10+MC0*/:@#$M
M=%=F,U[(9)7P6!.>?\_IVK8@M(+9=L4:J/85/10`4452O-3M[$#S&)<]$3DT
M`7:HZCJ$.FVC7$^=H(`"XR2?3/\`GBLM];OI-_DVBQ1J2=\ASE1W]/UK@M5O
M-5U2ZS-=!DC&U-O`QZX]3_A7)B\2J,-]7L=6$PSKSVT6YV=UX^TNVC/[FY:3
M'RKM7G]:QKGQ5_:SK'-#-#:\$J@!S]<G_/O7.PV2QL'8Y;O5H`#@#%>/+-:J
MT6I[4<JHO5Z&GJFKB]C6WAA$-LAW8/+.>F2>W';W/6LRBBO.JU9U9<\W=GI4
M:,*,>2"L@HHHK,U"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`J:UF6*=?.WF#/[R-3^H'KP/RJ&BKIU)4Y*4
M7JC.I3C4BX26C.HT[66LXV:-WNK0;0RMG?&?_P!7'7M]:Z^WN(KJ%987#(PR
M"*\KAGEMW+Q.4;!'3.1]*Z:R-Q:V\6H6,HEB?'GP#.`V!D<],>OTKZ7`XY8A
M<LM)(^9QV!>'?-'6+.THJK8WL5_;+/">#U!ZJ?0U:KT#S@HHHH`****`"BBB
M@`HHHH`****`"BBB@`IK*&4J1D&G44`<[?:5-:W1OM..R51\PSPPSW'?I5_2
M=46_C*2+Y=RGWT_K6G6#JVE,'^VV:[+B/D$?Y_S_`"`-ZBLS2]62_4Q.-ERG
MWD/&?<5IT`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M4<DB0QM)(X5%&22<`"J=_JMM8(#(^YS]U%Y)_#\#65#:WFL/YE]E(,DK'C``
MZ8]Z`'W6N370>'2T9F886<KE0?8?GUJ>PT9MYGO)&ED8Y^;J*T[:SAM(A'$N
M`!BK%`#54*``,`4ZD)"]2!]:Q=3\2V&FQMF9))<950>.GK2;MJP2;T1LLP49
M8@#WK%U#Q3I6F%TDN/,E50WEQ?,2/:N/U+6)-1B.Z=G9P-NS*HGKP>_^/MBL
M@6L>=S99CR2>237FXG,J=-\L-7^!ZF%RNI57-/1?B=+>>/Y)X773[*6-CP'F
MQ_0FL>+4[U)7E$I5G))+?.3Z9)_^M5<*%&``*6O*JYE7J:)V]#UJ.64*>K5_
M4L7=]<WS(US)O*#"C``'X"J]%%<,I.3O)W9WPA&"Y8JR"BBBI*"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`J>SOKBQEWP.0,@LA/ROCU'>H**J,G%\T79D3@IKEDKH[
M"&,6[KJVGLQMYQ\T9&.`>0?U_P#U5T-C?0:A;B6%P>S#N#W!%><V6IW=@K)!
M)^Z9@S1,,J?\/PQ6O:W"7UV9=,D:RO-A'EDY#<]O7`'3'\LU]-A<PIUDHRTE
M_6Q\QB\NJ4;RCK'^MSNZ*P++7F\_[/J"""3^%\85OKGI^=;W49%>@><+1110
M`4444`%%%%`!1110`4444`%%%%`!1110!@ZKHTLDR7>GOY5PG0CI^51)K5]9
M21KJ<"B)NLJ#&W\,G_(-='4%Q;17,>R5`P]QTH`6WN(KJ%)87#HPR"*FKF+B
MVO-%N/M-JSRPDYDB)X/T]/\`ZU;%AJUIJ"_N9,./O1MPR_A0!?HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`**8S+&A9F"JHR23@`5@3:K=:E*8=,PB!L-*1D
M\'L.U`&Q=7UM9(6N)E3`)P3R?PK#DOK_`%AMEI&]O;G.7/#-]"#_`)Q4]IX=
MC5_.NI&EF)SN8Y/^>U;44,=O'MC4*H_2@#)L_#MM;[&<L[+C&2:V54*``,`5
MG7.N6%JWEM,'DY&R/YCD=JYW6O&=S;*D=A9CS).AF.<#/H#_`%J)SC3CS2V+
MA"527+%:G5W=_:V";KF9(P>@)Y/T%<QJ?BQ3,T-JXC`!^?JQ([8'3\?7VKDC
M=ZC=GS+N[=Y"<Y&`?P].M(B+&,*,"O)KYM%:4E]YZ]#*)/6J[+R+=[JNH7LR
ML9Y%"G/S-G/X=!Q[56EW7#AYFWLO3C`%%%>35Q=:K\4CV*6#HTO@B%%%%<QT
MA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%*C,CJZ,5*G((
M."#244":N;EAJL=Z?LNJL"&P(K@]4/N?P'/Y\=-J&YN=#N#'=R&6V8]?[GN/
M\*XF@[@#L=D)&,J<5ZV&S25./+45UWZGD8K*HU)<U-V\NAZTCK(BNC!E(R".
M]/KS70O$%]ILJ6CC[1$<A03CD]/Q_P`^]=I8:]9WKB([H9B,B.3T^O2O=HUH
M5H\T&>%6H3HRY9HUJ***U,0HHHH`****`"BBB@`HHHH`****`"BBB@!K*&&"
M`1[UCWN@03R&6%FBD_V3CGUS6U10!S*7VJ:5*RW<9N+;.%?HPZ?A6]:7D%["
M)8)`RG\ZE>-)%*NH(K`GT*2VN3=6,K(_MSC\*`.BHKGX]=GMKD0ZE`L:=YU.
M%'US6ZCK(BNC!E89!'>@!]%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%4;S4[2Q(663,AZ(O+'_.*QDN]
M:U.4M;JEK$N1MZD^^>G_`.N@#IBP7J0/K65<Z_8PL5CD\]_2,@@?C50Z%<7<
MHDN[N4X.0-YP#].E:,.DVD1!\L%@<@GL:`,>9-1UT+&X-O:_QQCJ?Q_S^-=!
M:VL=G`$0``#K5;4-4LM)@WW,R1\':F1N;'8#OVKA]0\7W^I!HK,&UBS]\=2/
M\_3K6-;$4Z2O-F]'#U*SM!'0^)?$\6BPB&`[[IQQM(.P>I'X\=ORQ7"?VGJU
M\K"6^NEB(^[YS$'Z\TV&S2,EFRS'DD\U8`"C`&!7SV)Q[J3O$^APN`C2C:7S
M)H;VZAQMFR1R"44\_E3)YY;F4RS.7<]S_3T'M3**XYUZDU:4F_F=L*%*F[PB
ME\@HHHK(V"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****``C/!KH+?4;;5?*M;J(Q73`1I,@^5CVR!T[>O4]*Y^BN
MC#XFIAY7A\SFQ.%IXB/+/Y/L=LM[J^E*8IH#=1K@(Y/S'CVK9L-3M[]2(R5D
M7[T;$;A7*Z;XL\JW$.H1/+M'$JX+'V(/X\Y_QJ:6\T>]=);>Z-I/R1D%".N?
MF''ZU]+2QU"HE:5GYGS%7`UZ;=XW7='945S6G^(50+#?,.``MPI!5^W..G_U
MC72`@C(.174G<Y&K:,6BBBF`4444`%%%%`!1110`4444`%%%%`!1110!5O+*
M"]A,<J`^F16)!%>Z"ABB4SVP'RH221^/^?PKI:,4`8UCK]M=3"WF1X+CIM?H
M3CG!K9[<5GW>CVMT,[`C=B!62;/6=.4_99_-C7HCC=_G`H`Z:BL2PUWS[C[)
M>0FWN,X7NK\>O:MN@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBN=O=:EG=K?2UW/DJTA'3_`'?_`*_]:`-RXN8;2!IIG"(HR37.
MBZU35Y/W.;:UST3[QQ[U/#H4T\BRWUS)(V<X)Z>H^E:<]Y9Z;"HED2-?NJHZ
MGG'`_&@"I9Z%;VN9)3O<G)8^OUJQ<:MIVGD1RW$:-Q\B\D9Z<"N.USQ-/?V[
M6]HR)&_RX#9)'J2#QVX_G6)YD[!=\S$KQD?*3]<=:X<1F%*B^5ZOR._#Y=6K
M+FV7F=Q>^*XHI1%!&.<@O*P4`]N]<AJ6MZU>321K?R11*_'E';G\1V_&JI)9
MBS$L_JQR:6O*Q&:3J+E@K(]7#Y5"F^:;NRL+5I)3-=2O-,WWG<DD_G[59`"C
M`&***\V<Y3=Y,]2%.,%:*"BBBH+"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@!T$C
M0RJZE@N060'[WU_6NETG5I;8%K=FELMW,;_?3)/3GC^7XUS%6+&]FL;E9$=B
MFX&2,-@./0_F?I7H8+'2H/EEK$\W'8&-=<T=)'I=I?6]]'O@<$C[R]U^HJU7
M(.+.ZE,^DWRK-SA%.UB1@]#C(P/3M6MI>N1W8$-R/(N1P5/`8].*^FC.,U>+
MN?,2C*+M)69LT4451(4444`%%%%`!1110`4444`%%%%`!1110`4444`8^M:<
M+BV,D7R2)\PVCJ>U.T?4OM5LL,YQ=1@!\\9[9K6K#U+1C+*MU:.8IXSD%<_Y
M_"@#<HKEXO$,]E*MOJ=NQ4<&9%_F/YUT%M>6]Y$LD$JNIZ8-`%BBBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`***CDECA0O*ZHH[L<"@!Y.!D\5E7>NVEL[0
MQ$SSCC8G8^YK/N=3N-4G-KIS-'"/O3#J>/TQ_2L?5-8LO#T'V2TV7.HXPS*,
MK']??T'Y^\5*BIQYI%TZ<JDN6)LNFIZP^R8>1;\_*A(S]:BO=?TGPW(;5O,F
MN0N66)02/3/(Q_GVKAO[7URZZ7UU&F""!*V3^M-BM=IWRLTDAZLQR:\NKFB4
M?=6IZM'*FY>\]#:G\9ZI?L3#`+2'!&%;+'(]2/H>E9,BSW1#7D[S$'(#'BI`
M`HP!@45Y5;'UJJLWH>M0P%&EJEJ(JA1@#`I:**XSL"BBB@84444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%`EFC7$<F,?PL,CZ>WX445=.I*F^
M:#LS.I3A47+-71TFA^*DC(M;V:3/9GY(QCOWZ_ITQ7;(Z2('1@RGH0:\BDB6
M0`'J.0?0UJ:-J^I6DT5M%+O4D_ZQLAO0<GCKU'M7T&#S*-2T*FC/GL9EDJ=Y
MTM4>F45F:;JJWI,,H$5RHR4]1ZBM.O5/)"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@"&:U@N!B6)6'N*P[[0Q`GVJR;RYHSE<9`]\XZUT5%`&-I>MQ76
MRVN66*]P<IS@X[C-;-9>H:);WHW`!)`,`CM66NH:CH[+%>1O<VXP/,&-P'')
M]?\`/6@#J**AMKF*[@6:%]R,,@U-0`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!3'=(U+.P51U
M).*QO$'B.WT*V!9#-._W(E.,_4]JXN3Q5;7A\R_\XR#)2&,Y7V[\=<=*RG7I
MP=I/4UA0J37-%:'77OB,_O$L(O,*?>E?[J^_T]ZX[4?$2W$B%6>^FC(^8_(G
M^?P%4]0UBZU93:VZ&ULCC*`Y+X_O-U/_`-84R"W2%0`!FO,Q69\NE,]3"Y9S
M*]0LZA?W6H6PME=H[<X++]W/L0#Z\\Y_QIPV<</.,GU-6**\>MBJE9WDSV:&
M%I45:*#I1117.=(4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
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
M`X_IG\:^FRJ_U?YL^6S6WUCY(Z,<#%%%%>D>:%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!5+4M0CTZT
M:9R"W15SU)Z59EECAC,DKA$'4DXKFK=CKVIO,Z9MHSB,X.,<\_C_`)S0`"SU
M+6D/VV01Q=EB)52,C\^G?I6OI^BVU@=R#<V,9-:"J%``&`*=0`4444`%%%%`
M!1110`4444`%%%%`!1110!SFHQ2:9?#4(4+KC#*._M_G]:V[2\@O8!+;R*Z>
MQSBI9(DE0I(H93V-<_)IMQI4\ES8-A&Y=&R0WX4`='15'2]134K03*-K9*LN
M<X(J]0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'.:W^]UFQC9<!07#'UYZ?D/
MSKHAT%<YJ1%_KL-O$PW6V-_!SSS_`$%=&.`*`%HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"N%^(J`VEE(70%)&`4_>.<<CZ8_4>M=U7`_$67$F
ME0D#:SNW3G@`?U_2N?%J]&1T81M5HV.=A),2Y&*?2*-J@>E+7R#W/LDK(***
M*0PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`.P\&2Q?8KI`F)$D#,V!RI'`S^!_.K7AO;--=7*!@KN?O#!QG(_G7+:3?_9$
MO82?EG@90,=6`X_3(_&NV\.H4TM-R[6]*^IRV:EAUY:'R>94W#$R??4UJ***
M[S@"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`***8SK&A=F"JHR2>`!0`[.!D\5AWNM,;DVFGQK+*IVNY/RJ1VQW]/Q
MJM)>W>L2M%9,\5J#C<,JS^^>W;^O6M73=)AT^/`^9_4T`9JZ)=WDZS7MT[#@
M[<D#\JWK>WCMHA'&N%%2T4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!364,I!&13J*`.<NK.YTJ^:\L^8W.98^@8?X^]:]C?0ZA;B6%O9E/53W!'XU
M:=%=2K#(/:N8G@DT/4Q=6^XPR?ZR,<`C_P"M0!U-%1PRI/$LL9RC`$&I*`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@#F[4I_P`)E>#;AMHY_`5TE<U`I_X3&YR&&Y00
MP]ATKI:`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*X#XCJOFZ
M2V[#AI`!Z_=KOZXGQ^$:"TW)EE.Y3GIR!_6L,5'FHR1OA9<M:+\SET^XOTI:
M!THKXX^S04444#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`M6-N&CN+ILA;=!SG^(G`!_#/Y5Z-I;!M.A(X^7IZ5R%E!Y/
MA2>0K@W<HC#8#94>W;G=[YQ76Z3"8--A1L[@.<_E7U674^3#KSU_KY'R68U.
M?$2\M/Z^9?HHHKN.$****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBJ6H:C;Z;#OF;D_=0=6-`#KV^@T^`S3$XZ*HY+'T`K#+
MWFNR<QF&T^\HZ$^Y_P`_RI]M:S:O=?:KK_5Y^11V%=$D:QJ%48`H`AL[2.S@
M6.,8`JQ110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5
M#<6Z7,+1/T/IUJ:B@#EWM+S0R)+1S)`"2T1Z/_@?_K>E;UG?07T`EA8'LR]U
M/H15AT612K#(-<WJ>G2Z=*-0T\8D0<KV([Y'2@#IJ*IV%['?VB3IP3PR]U..
M15R@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@#GH#CQ9."1C&?T`KH:YW5@\&O6EP"`C)MQZD
M9Z_G70CH*`%HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"O-?'^H
M+<7EO#%S]EDPYX(9B.GX?X^E>E5Y3XPL);?5MKE"L\K3*5;)`R>H_&N''RFH
M)1VZ^AW8",'4;EOT]2NA)0$]<4M-C&U`#UIU?+/<^L6P4444AA1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`=!YT;^&-.0,"
M8[EE;J`#R1_Z$/SKM[7BUB!_NBN$M`I\+J&&3]OX'_`!7>6^/L\>/[HKZ_!N
M^'@_(^-QBY<1->9+11172<P4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`45#<W4-G"99W"(.]<^UUJ>K-FT<V]OD@A1\WXGM^%`%_5
M-;BL&\B(>;=-@!!T&>YJKI^DSW,IO-2;?(XY7MCTQ5S3=%ALDR_SR=R>:U:`
M&JJJ,*`![4ZBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"FNBNI5AD&G44`<O/%?:)>27%HBR6KG+H3P`/3T-:EIKUA=
M.D8D,<K#(208-:3*&&&`(]#6;?Z);W<3A%5)&ZMC.:`-2BN9@O+W128KTO/;
MJ.&ZN/Q[_P"?2MZUO+>]A$MM*LB>H/3VH`L4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%07DXMK.:<_P#+
M-"WZ4`8B;[SQ+*6P88<*N.V`<@_F:Z*N>\,6[BWEN)>7E8G/X]Q70T`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`A.!D\5Y9XANO[2\0-)N)6+
MY5&1@`'CIZ\G\17HFL7!MM(NI5;:RQG!]/>O*K-3Y1=^7<Y)]:\S-*W)1Y5U
M/3RJCSUN=]"Q1117S1]0%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`:^B,)7B@P,QNTG7U`[?\!->B*`%``P,5YEX;
M#/XG5>3%Y.&QTSGC/Z_K7IPX`KZS`.^'B?(9@K8B0M%%%=AQA1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%(2`"3T%+7/ZU=O=2MI-J<2LH
M,C9Z#TH`K6X?7-6><O\`Z)"V(P"<'''TKIHXTB4*B@"JNFV*6%FD2@9QDD#O
M5V@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@".6".9=LB!A7-I&V@ZL&7_CSFX;JQ'H:ZBH+J
MU2ZB*.*`)$=9$5T8,K#(([T^N6M)I-!OFM;B0BR894L!A#_A_GBNH!R,CI0`
MM%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%9NN^=_8MUY&-^SG/IW_`$S6E4%U'YMI-'G&Y",XZ<4`4M#*_P!FKM``
MST''85J5A>%Y2^GLG&$;`([UNT`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110!@^+X&N?#-U"APS;<'Z,#_2O/+=3'"$889>"/0UZ?KD:2:-<A\X
M"$@@D8/;I7E\4RW!DF7(5W+#/7&:\;.(KEC+J>UDTGS2CT):***\`^A"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***M::
MBRZK9HZAD:9`5(R"-PJHQYI)=R9RY8MG2:58V]EXGN+:W!V1HN=W))QUSZUU
M]<Y;Q8\87,N!AEQ[\`5T=?:QBHJRV/AY2<G=O4****8@HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`*CDECA3?)(J+ZL<"JM_J5MIRH;A\,Y(1!R6
M.*QH[.YUN[-U=,\4*Y5(@>,?AUS0!/>:Z9B;;3%,LK*<2X^4<_K5G2=+6R3S
M'&96')/7/?FKMM906J@1Q@'U/6K5`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M4[_3X;^+;(,-V;N*P`-0T"489Y[('_5DEV`]<GT_I75TUT5U*L,B@"K8:C;:
MA")+>0'C)0\,OU':KE<Y=Z`T5Q]JT^5H9.3\I_GZCV^E26VNF.;R-100MVD&
M=IY_3ZT`;]%(""`1T-+0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%)U&#2T4`<WH(%OJ-[;J0(DD95`'?/^?RKI*YRT8GQ==J0
M,#!!_"NCH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@"CK)QH]T
M?]@UY:D8BDE12I`<XV]![5Z9K\HCT*[W#.Y"GTSQFO+[0L8-[<LYW$_7FO(S
MAKV<5YGL9,G[23\B>BBBOGCZ,****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`ZGPE>-J5U/+(`9X2$<\DD8P#SW..?I7
M:5P7P^5-^H-G]X9?F]ASC^M=[7V.&DY4HMOH?%XJ*C6DDK!1116Y@%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%8FJZR]N_V2Q59;L\'=]U..]&HZP`[6
M=D^ZY/!8<A/\>_Y5+I>DQVB>=*NZ=^26YQ0!5L=$D=A/J+F:;OGG/^%;J(L:
MA5``'84^B@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*I7^G0WT
M)5E&[UJ[10!S$-_/H;I:72N]MD`2'J@/3Z\UTP((!'0U4U&T%Y:,FW+#D5EZ
M-=FVD_LN>3+H,Q$DY(]/P_R*`.@HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`.<MMO\`PEUQQ\V/3V%='7.V>V7Q/=2QY(4[
M&].!714`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!EZ\R+I,OF
M`%,J"#W&:\SCC,2^6<$H2IQ[5WOB66.1[:U?;MW>:Y)^Z!D9(].O/M7$W$BS
M74TJ`A7D9@#[G->+G%N6'<]K)K\TNQ'1117@GT(4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!TO@*U,(N9R2?/)/L,
M,PKN*X7P5>C[3-9*#F,Y/I@Y(Q^OY5W5?8X:SHQ:['Q>*O[:7-W"BBBMS`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBHIIXK:,R32+&@ZLQP!0!(2`,G@5@ZGJID$
MEE9%FG^ZTJ=$]?Q_EFH)]6N=5=[;3E:.,C!E(PQSZ>G_`-?VK6TS2X;"W0!!
MYF.30!%I6E164*LR@RD#)/:M6BB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`K$UK2S,$NK?Y9HFWC'<CI6W10!E:1JJZA$4D4QW
M,?#H1C.,<CU'(K5KGM3LKBTNEOK$?,O!7MCOD=__`-5:6F:G%J=MYB91UX>-
MN"IH`OT444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5'*XCA
M=BP4*I)).,5)4-S&)K6:)B0'0J<>XH`Q?#,*K;R28RS,3DG)Y///US705@^&
M'9K`H0!L/8]SS6]0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'
M!>-IGM;^%6YCN4`R>VT_7U(KGQTK9^(<<QU#3I2<VX!4`=FSR?Y?E6,.E?-9
MJVZVI]-E-E0T"BBBO,/5"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`***5%:1U1%+,QP%`R2:!-V-OPA`+?5))V4AI<8]QT
M'ZYKT&N1NX?[.U'26<[G$"Q$#IN7OG\376C[HK[.A#DI1CV1\57J>TJREW8M
M%%%:F04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`445AZYJ4D)CLK7/GRD;B!]U3G_``H`?JNK
MFV5H;./S[GH0.=F1P3Z_2JL&CW%^1-J<S/QPG(Q^';_ZU:&G:1#9CS"N93U)
M-:=`$-O:Q6J;(E`%3444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`A`88(R*YW5+*:SF74+-L%,[AVQQD'\O\]^CI
MK*'0JPR",&@"KIU_'J-HL\?!Z,IZJ?2KE<Q=6T^BW)O+4CRG8!X^S#^G^?I6
M]97MO?P"6W<,O3W%`%FBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`*BG8);R,QPH4DG\*EJAK,C1Z/=LF=WED<#.,\4`4?#<92T8Y.&P<'C';^E;
MM97A^,QZ8BD]ZU:`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`X
MGX@RK'#9J5R7;`/IR#_2N8'2NS\<68N-+AE5`TL<F$_$?_6KBHCF-<>E?/YQ
M%\\9=#Z')I)TY1\QU%%%>.>T%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`5L>&+-+O6X]_2%?-QZD$8_4@_A6/5G3KHV.HV
M]P"1Y;`M@`DKT(Y]LUMAY1C5C*6R9AB8RE2E&&[1V.IG?XFLH6.8VCZ$\9R>
M1[__`%JZ(<`5SD_[WQ6%*L/+1,%A[]OS_2NDK[(^+"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BH;BXBM8&FF<(BCDFL)]6O-3F,.G*8XB,B<KD_EV_^O0!JZEJ<.FQ!I#ND
M?A(QU8UFZ)83O/)?7O,KMD`CIU_QI;/P^OG&>\9I)#UW'.?K6\`%``&`*`%H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`&NBR(489!KF+JWDT._^V0%FB<@-&.A&?Z9_STKJ:KWE
MLMW;O$PZC@^AH`?#,D\,<T9RCJ&4^QJ6N:T6[?3[AM+NAM4.WDOC`QQP?UKI
M:`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`JAK.1HUYM(!\EN3]*OUC
M^(SG2FCQGS'53SC'-`#]`W?V6NX8.3^/O6K533XO)L8D)!(49([U;H`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#!\73&W\-74J@[EVXQV.X8-
M>=VPQ`@/&!7HOBQ-_ARZ0#);`'&><UYU:_\`'M']*\/.$_=?0]W)K>\NI+11
M17AGO!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`'4VEW)=:IIUU(=KRP@,0>NTL"3Z9/-=H.E<.D<L%CHBD[6.YCSU
M5FR/TQ7;K]T5]G0;=*+EO9'Q-=)59*.UV+1116ID%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4%U<PV5L]Q
M<.$B099CVJOJ6IPZ="&<@ROQ''GEC_A6-'9ZAJ\@DOV"PJV5C487_/U_2@!I
M6\\03$.?)LE<?N_7!X.>_P!.GY5TEO;16T82)`H`IT,*01A$4`#TJ2@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`SM4TN._A)V_O`.#5/2]1DB<6-\X\T<(Y/WA
MZ&MVL[4M+COEW``2`<&@#1HKF;;4[K2YS;ZCODAW867;RHQT/J..M=!!<17,
M2R0RK(C#(*L"/TH`FHHHH`****`"BBB@`HHHH`****`"BBB@`KG?$3&>:TLT
M^\)!(>>@Y[=ZZ*N7MU:\\63S$[X8AL1AQM(_^OD?Y%`'20J4A13U`%2444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!112$@#)X%`&!XK=TTE5258B
M[X+,,@?*3_,`_A7G\0"Q*!TQ6YXR>]UIE_LR4_9[4,\A5L!B!R?<8R/\\<[9
MW(GCVD;9$X85X><)OE\CW<FLN:_4LT445X9[P4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!2J5#J7!*YY`."1]:2B@35SNM
M2<7>M62QE641;T*G[V<]_3@5T0Z"N1L]HU'2E7=\EFA)))Y/.*Z\<"OMH2YH
MJ7<^'G'EDX]@HHHJB0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBD)`&3P*``D`9/`K$OM>5',%@@GFY&[/R@XX^M5+^]
MEUB?[!8Y^SAL2O\`WO8>W^>E;.GZ;#8Q*%4&3NW<T`9UEHTLMU]MU!S).0`<
MC`X]!VK>`"@`#`%+10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!#
M/;17*;94!%<]+8W>C7'VFQ9GA)^>$GY3_A_^JNGIK*&4@C(-`%+3-3BU*#<H
MV2K_`*R,GE35^N6U2VDTJ\BU"T7Y0WSCGD'KG_&NDAE2>%)8SE'4,#[4`2T4
M44`%%%%`!1110`4444`%%%%`#).(G^AK!\++&;)W1=N6/![>M;-X9!93F+_6
M>6VWC/..*R_#(0:>&7@D`D>E`&Y1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4A(49)P*I:CJEOID`DF)+$X5%Y8_A6/]EN]>&ZXD:*VW!E13CZ9]>@H`
MTKC7K&#<J3":0+D+'SG\>E9DM]JFK*T-O;&WA/RL6Y)!_P#K5K6VD6EL!MC&
MX'(/H?:KZJJC"@`>U`%+3-.BTZSCB1?F`Y/?WKD?$GAA893>Z?'L?J8Q@(WM
MCM_+]37>TUT5U*L,BLZE*%2/+-7-*=6=*7-!GDOER",.R$#O['G@^AX-)7:Z
MIH*@FXMD`&,21CHR^X_#\.HKE9-/98G9)`SQ_P"LB(PXZ\@=QQSC\J^?QF6R
MI>]3U7XH^AP>9QJ^[4TE^94HHHKRSU@HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`***M:;9B_P!2@M=VT.WS'..`,G'O@&JC%RDH
MK=D3FH1<I;(Z<0_8_$EG;@A]EM$C'IG&X9Q765S=S;>3XEMFC4*@B50%X``R
M`,?C725]K%621\0W=W84444Q!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`444UF5%+,0JJ,DGH*`([BXBM(&FF<)&O4FN<N;R[UP
M"VMXI(+9C\Y/WF'_`.NG-,^OZBB1C%G'GGU/K71PPI!&$10`*`*]C81V40"J
M-QZGUJY110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
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
M.RS'$GGW':-3T^OIU'YU0T_29KJZ:^U'YW88P>F/3%6=-T2&T7?)^\D."2W)
MK8`P,"@!JHL:[54`>@%/HHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`R]7T.SUN*..[#8C;<"I`/T^E6++3[73[=8+:
M((B]._O5RB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*BEACGC,<J!U(P014M%`'/7
M.DW5HSSV$SJ3R57_``_S^%<K?6B,\C!5MYQ@F$?<;CDJ>W^[^785Z75"]TNW
MOHBKH`<Y!QT/K]:PKX>%>/+-&^'Q%2A+F@SS'Z45JZCX>?3I&*.=C9.T_='T
M/:LD'(S7R^)PL\/*TMNY]5AL73Q$;P^X6BBBN8Z@HHHH`****`"NH_LF*R\.
M17:,YD8I.Q'N"`!Z8#'G_(Y>NUN1]F\$1DDO^X1CO.>O./H,X'X5ZV413JMM
M;(\?.)M4HI/=FYIL_P!HL(GQ@[1QZ5<JEI84:="5&`5J[7T1\X%%%%`!1110
M`4444`%(2%&2<"EKG-8O&O9ET^U.Y=V)F'\OY4`.O-:>X?[-I@WMNVM*1D+V
MX_Q_QJ[I.EK86Z[_`)I3R3DG%3V6GPV4*JJY8#J>:NT`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`5[NTCO(#'(/H?2N&U;3IK9&6
M2#<H8^3(#C:,]",<YZ]N?QKT&H+JTBNX3'(H(K.K2C5@X2V9I2JRI34X[H\I
M(()!!!'4'M174W>FVUK<B*\C+6I4A)%)#1Y]/\#G^=8.HZ=+IUP$;#Q-S'*O
M1Q_C[5\SB\!4P_O;Q_K<^GPF84\1[NTOZV*E%%%<)Z`4444`%=B]PTG@>.5@
MH(0)@#J`VT?H*Y2SMFO+V&V3.9'"Y`S@=SCV'-=MK,,%CX>6S4(%)6-`W&[N
M3QWZFO9R>$N:4^FWS/#SFI'EC#KO\C3T@!=+MP.FVKU5=.1H[&-6["K5>^>`
M%%%%`!1110`4QF6-"[L%51DDG``IES<PVD#S3N$C09)-<W+<7/B"3RH=T5F&
M&1T9OK^E`$]UJ%QJSFVT]VBAS@S@<MV('I6CI>E)I\(!.]_4U:M+2*SA$<:@
M8]JL4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110!7NK2.[B*./H?2N2U'39[2*6!WDFM).0`,^6<_>&>GX=<GU%=K3)
M(TD7:Z@BIE%3BXRV949.$E*.Z/(U8-D#J#@BG5UVL>%DD99;=V4*<E5'^?\`
M/X5R<R"&<PG=NQ\VY=ISW_S]*^9QF`G0]Y:Q/I\'F,*_NRTD-HHHKSSTC7\,
M?\C#:_5__0#76>)+=YM.1XVP\4@8>^>/ZUP$$\MM,DT+E'0Y!':NMN]6;4/#
M<$RE5E>81R*`<9`)_P`#7O916CRNEUW_`"/G\XHRYE5Z;?F=)92>9:1M@CC'
M-6*KV.?LB9JQ7M'B!1110`53OKZ#3K<S3N`.@4=6/8"J>I:W#92?9HR)+LCA
M!V]S_A]*K6VBO>S+>:A)YKXRO&,?ATH`K6]O/KUT+J[62*%#\D8/&/Z\=ZZ:
M&!+>,1QC`%.1%C4*HP!3J`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KF]>T!+V-I(P`0.HZJ?45TE%
M)I25F--Q=T>5P:7>S[T1%>:($NB'!`['!ZY]!FJU=_JFDD2)>6I*2Q$L,5P]
MS&YN)G\H*-Q8A%P%YZ8[#D"OG\PP"I+VE):=?(^AR_,)59>SJVOT\R"NDM;;
MR_!KS2'&Z?S5V]A]TY_(_I7-UV.B/]H\(74;HI6+S%48Z\;N?Q-9Y3;ZQKV-
M,WO]7T[G0Z>_F6,3\X89&>HJW63X?)_LU<[LY/6M.21(HVDD8*BC)).`!7TI
M\R.Z#)KGKG4Y]4G>TTN3:B':\H[^P]/K4%S?W.M.;6TCDBMSPTG0N/Z?3WK:
MTW38--AV1+@]_P#/X4`16.CP6VV210\H'4\@?2M2BB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`K`U;01=JS0.8W;@[>#@C!&?>M^BC<-MCRB33+ZUN?LTJ>83G8PX)
MQ[>OIZ_I6C8:H;73YM)VLEQ/(<'OTPPQCKQ_G'/;ZCI<&H0LKH-_9O2O,99Y
M+/QI#:(PE>`!<MGKC;C^7TKSOJ*HUE5I?->1Z7UUUJ+I5?D_,]*MY(-+TV/[
M1.JC'5CR>.PK+EN+C6YO)@!2R!(/'+8[GT]A_P#6I]KH,DLHN+Z1G?``&X_R
M_I6_#!%;H$B0*!Z5Z)YHRTM([2$1H/J?6K%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%9QT33SJ9U(VJ&[(&9/7'2M&B@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
2HHHH`****`"BBB@`HHHH`__9
`












#End