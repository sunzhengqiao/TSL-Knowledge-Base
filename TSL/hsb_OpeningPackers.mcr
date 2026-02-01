#Version 8
#BeginDescription
//EN
This tsl creates sheeting at the inside (reveal) of openings. The side(s) as well as the outside zone can be defined.
Since version 1.3 covering boards in front of the opening can be created, too.
The tsl can be used maunally by selecting openings or it can be attached to elements/ openings using the details.

//DACH
Das Tsl erzeugt Laibungsplatten in einer Öffnung. Die Position, sowie der Startpunkt der Platten sind frei wählbar.
Ab Version 1.3 können auch Blendbretter vor der Öffnung erstellt werden.
Das Tsl kann manuell jeder Öffnung hinzugefügt oder an Öffnungen, sowie Elemeten in den Wandetails angeheftet werden.

1.8 21.02.2023 HSB-17931: bugfix ignore parallel beams. Author Nils Gregor
1.7 16.02.2023 HSB-17931:  bugfix wait for genBeam of elements. Author Nils Gregor
1.6 12.02.2023 HSB-17931: hsbOpeningPackers await element construction and add properties to define base points. Author Nils Gregor
1.5 22.06.2021 HSB-12291: assign text to layer "T" not printable Author: Marsel Nakuci
version value="1.4" date="15jan21" author="marsel.nakuci@hsbcad.com">HSB-10022: add mapIo
version value="1.3" date="21jun20" author="nils.gregor@hsbcad.com">HSB-7977 Add option covering board


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords opening,Öffnung,packer,Laibungsplatte
#BeginContents
/// <History>//region
// #Versions:
///1.8 21.02.2023 HSB-17931: bugfix ignore parallel beams. Author Nils Gregor
///1.7 16.02.2023 HSB-17931:  bugfix wait for genBeam of elements. Author Nils Gregor
/// 1.6 12.02.2023 HSB-17931: hsbOpeningPackers await element construction and add properties to define base points. Author: Nils Gregor
/// 1.5 22.06.2021 HSB-12291: assign text to layer "T" not printable Author: Marsel Nakuci
/// <version value="1.4" date="15jan21" author="marsel.nakuci@hsbcad.com">HSB-10022: add mapIo, dont always load properties from lastInserted </version>
/// <version value="1.3" date="21jun20" author="nils.gregor@hsbcad.com">HSB-7977 Add option covering board </version>
/// <version value="1.2" date="28apr20" author="nils.gregor@hsbcad.com">HSB-6678 Added German description </version>
/// <version value="1.1" date="11mar20" author="nils.gregor@hsbcad.com">HSB-6678 changed some texts for translation </version>
/// <version value="1.0" date="11mar20" author="nils.gregor@hsbcad.com">HSB-6678 initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK, select openings
/// </insert>

/// <summary Lang=en>
/// This tsl creates sheeting at the inside (reveal) of openings. The side(s) as well as the outside zone can be defined.
/// Since version 1.3 covering boards in front of the opening can be created, too.
/// The tsl can be used maunally by selecting openings or it can be attached to elements/ openings using the details.
/// </summary>

/// <summary Lang=de>
/// Das Tsl erzeugt Laibungsplatten in einer Öffnung. Die Position, sowie der Startpunkt der Platten sind frei wählbar.
/// Ab Version 1.3 können auch Blendbretter vor der Öffnung erstellt werden.
/// Das Tsl kann manuell jeder Öffnung hinzugefügt oder an Öffnungen, sowie Elemeten in den Wandetails angeheftet werden.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_OpeningPackers")) TSLCONTENT
//endregion


//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|Sheet definition|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

	String sFunctionNames[] = { T("|Packer|"), T("|Covering board|")};
	String sFunctionName=T("|Insert as|");	
	PropString sFunction(nStringIndex++, sFunctionNames, sFunctionName);	
	sFunction.setDescription(T("|Defines the position of the boards. Packers are inside the opening, Covering boards cover the opening from the outside|"));
	sFunction.setCategory(category);
	int nFunction = sFunctionNames.find(sFunction);
	
	String sWidthName=T("|Width|");	
	PropString sWidth(nStringIndex++, "100", sWidthName);	
	sWidth.setDescription(T("|Defines the width of the board. Using one value set all widths. Using a semicolon separated sequence sets the width for: top; bottom; right; left independent|"));
	sWidth.setCategory(category);
	
	String sHeightName=T("|Thickness|");	
	PropString sHeight(nStringIndex++, "20", sHeightName);	
	sHeight.setDescription(T("|Defines the thickness of the board. Using one value set all thicknesses. Using a semicolon separated sequence sets the thickness for: top; bottom; right; left independent|"));
	sHeight.setCategory(category);
	
	String sGapEndName=T("|Gap at the ends|");	
	PropString sGapEnd(nStringIndex++, "", sGapEndName);	
	sGapEnd.setDescription(T("|Defines the Gap at the end of the sheet. Using one value, the gap is on all ends. Use a semicolon separated sequence to define an individual gap. eg: top; bottom; right; left|"));
	sGapEnd.setCategory(category);

	String sGapOpName=T("|Gap to opening|");	
	PropString sGapOp(nStringIndex++, "", sGapOpName);	
	sGapOp.setDescription(T("|Defines the Gap to the opening Using one value, the gap is on all sides. Use a semicolon separated sequence to define an individual gap. eg: top; bottom; right; left|"));
	sGapOp.setCategory(category);
	
	String sPropsName=T("|Sheet properties|");	
	PropString sProps(nStringIndex++, "", sPropsName);	
	sProps.setDescription(T("|Set sheet property. The properties are separated by a semicolon. Empty properties need a blank. Sequence:| ColourIndex; Name; Material; Grade; Information; Label; SubLabel; Beamcode. E.g: 2;Packer;OSB; ;on site"));
	sProps.setCategory(category);
	
	String sAsignZoneName=T("|Assign to zone|");	
	int nAsignZones[]={-5, -4, -3, -2, -1, 0, 1,2,3,4 ,5};
	PropInt nAsignZone(nIntIndex++, nAsignZones, sAsignZoneName);	
	nAsignZone.setDescription(T("|Defines the zone where the sheets are asigned to|"));
	nAsignZone.setCategory(category);

	category = T("|Sheet position|");
	
	String sZoneName=T("|Zone to align sheet to|");	
	int nZones[]={-5, -4, -3, -2, -1, 0, 1,2,3,4 ,5, 6 };
	PropInt nZone(nIntIndex++, nZones, sZoneName);	
	nZone.setDescription(T("|Defines the zone the sheet is aligned to. Negative zones are aligned to outside zone, positive are algined to inside zone. That´s what zone 6 is good for|"));
	nZone.setCategory(category);
	
	String sOffsetName=T("|Offset to zone|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the offset to the zone. The sheet is algined to in wall Z direction (towards outside is positive)|"));
	dOffset.setCategory(category);
	
	String sSheetLRName=T("|Create a vertical sheet(s)|");	
	String sSheetLRNames[] = { T("|None|"), T("|Left|"), T("|Right|"), T("|Both|")};
	PropString sSheetLR(nStringIndex++, sSheetLRNames, sSheetLRName);	
	sSheetLR.setDescription(T("|Defines the vertical sheets|"));
	sSheetLR.setCategory(category);
	
	String sSheetTBName=T("|Create a horizontal sheet(s)|");	
	String sSheetTBNames[] = { T("|None|"), T("|Bottom|"), T("|Top|"), T("|Both|")};
	PropString sSheetTB(nStringIndex++, sSheetTBNames, sSheetTBName);	
	sSheetTB.setDescription(T("|Defines the horizontal sheets|"));
	sSheetTB.setCategory(category);

	String sReferenceNames[] = { T("|Construction|"), T("Opening")};
	String sReferenceName=T("|Reference|");	
	PropString sReference(9, sReferenceNames, sReferenceName);	
	sReference.setDescription(T("|Defines the reference for the position of the packers. Construction uses the closest beams to the opening. Otherwise the outside of the opening is used.|"));
	sReference.setCategory(category);
	int nReference = sReferenceNames.find(sReference);
	
	String sIgnoreParallelBeamsName=T("|Ignore parallel beams|");	
	PropString sIgnoreParallelBeams(10, sNoYes, sIgnoreParallelBeamsName);	
	sIgnoreParallelBeams.setDescription(T("|Defines for Reference = Construction, if parallel beams should be considered.|"));
	sIgnoreParallelBeams.setCategory(category);
	int nIgnoreParallelBeams = sNoYes.find(sIgnoreParallelBeams);	
	
	category = T("|Behavior of Tsl instance|");
	
	String sDeleteName=T("|Delete TSL after insertion|");	
	PropString sDelete(nStringIndex++, sNoYes, sDeleteName,1);	
	sDelete.setDescription(T("|Defines if the Tsl stays in the drawing, or is deleted afterwards|"));
	sDelete.setCategory(category);	
	
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
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
//	// set last entry
//		setCatalogFromPropValues(sLastInserted);
			
	// collect male beams or elements to insert on every connection
		PrEntity ssE(T("|Select opening(s)|"), Opening());
		if (ssE.go())
			_Entity.append(ssE.set());	
	
	
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;	Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};	Entity entsTsl[1];// = {};
		Point3d ptsTsl[1];// = {};
		int nProps[] ={ nAsignZone, nZone};		
		double dProps[] ={ dOffset};	
		String sProps[] ={sFunction, sWidth, sHeight, sGapEnd, sGapOp, sProps, sSheetLR, sSheetTB, sDelete, sReference, sIgnoreParallelBeams};
		Map mapTsl;				String sScriptname = scriptName();
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			entsTsl[0]= _Entity[i]; 
			ptsTsl[0]=_Entity[i].coordSys().ptOrg();
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				 nProps, dProps, sProps,_kModelSpace, mapTsl);
		
//		// set props by last entry	
//			if (tslNew.bIsValid())
//				tslNew.setPropValuesFromCatalog(sLastInserted);
		}
			
		eraseInstance();
		return;
	}
// end on insert	__________________
	
//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
			{
				setPropValuesFromMap(_Map);
			}
			showDialog("---");
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
//End mapIO: support property dialog input via map on element creation//endregion 
	
	Opening op;
	Element el;
	int bErase;
	
	int nSheetLR = sSheetLRNames.find(sSheetLR);
	int nSheetTB = sSheetTBNames.find(sSheetTB);
	
	if(_Entity.length() > 0)
	{
		if(_Entity[0].bIsKindOf(Opening()))
		{
			op = (Opening)_Entity[0];
			el = op.element();
		}
		else if(_Entity[0].bIsKindOf(Element()))
		{
			// when triggered by element calculation
			el = (Element)_Entity[0];
			Opening ops[] = el.opening();
				
			if(ops.length() == 1)
				op = ops[0];
			else if(ops.length() > 1)
			{
			// prepare tsl cloning
				TslInst tslNew;
				Vector3d vecXTsl= _XE;	Vector3d vecYTsl= _YE;
				GenBeam gbsTsl[] = {};	Entity entsTsl[1];// = {};
				Point3d ptsTsl[1];// = {};
				int nProps[] ={ nAsignZone, nZone};		
				double dProps[] ={dOffset};	
				String sProps[] ={sFunction, sWidth, sHeight, sGapEnd, sGapOp, sProps, sSheetLR, sSheetTB, sDelete};
				Map mapTsl;				String sScriptname = scriptName();
					
				for (int i=0;i<ops.length();i++) 
				{ 
					entsTsl[0]= ops[i]; 
					ptsTsl[0]=ops[i].coordSys().ptOrg();
					tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						 nProps, dProps, sProps,_kModelSpace, mapTsl);
							 
				// properties are set by mapIo
//				// set props by last entry	
//					if (tslNew.bIsValid())
//						tslNew.setPropValuesFromCatalog(sLastInserted);
				}	
				
				eraseInstance();
				return;
			}
			else
				bErase = true;
		}			
	}
	else
		bErase = true;
				
// validate selection set
	if (bErase)		
	{
		//if(_Element.length() > 0)
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}	
	
	//Wait until wall calculation.
	if (el.genBeam().length() < 1 && nReference== 0) return;
	
//region Delete sheets of previous run
	{ 
		Entity entsSh[] = _Map.getEntityArray("Sheet", "Name", "Entry");
				
		for (int i=entsSh.length()-1; i > -1;i--) 
		{ 
			entsSh[i].dbErase();		 
		}//next i	
	}
//End Delete sheets of previous run//endregion 
		
		
// Element standards
	CoordSys cs =el.coordSys();
	Point3d ptOrg = cs.ptOrg();	
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptZ0Mid = el.zone(0).ptOrg() + vecZ * 0.5 * el.zone(0).dH(); ptZ0Mid.vis(6);
	assignToElementGroup(el, true,nAsignZone,'Z');
	
// Opening standards
	CoordSys csOp = op.coordSys();
	Vector3d vecXOp = csOp.vecX();
	Vector3d vecYOp = csOp.vecY();
	Vector3d vecZOp = csOp.vecZ();
	Point3d ptOpOrg = csOp.ptOrg();	
	double dToZ0 = vecZ.dotProduct(ptZ0Mid - ptOpOrg);
	Point3d ptOpMid = ptOpOrg + 0.5 * vecXOp * op.width() + 0.5 * vecYOp * op.height() + vecZ * dToZ0;ptOpMid.vis(1);
		
// Display text representation
	Display dp(-1);
	Point3d ptTxt = ptOrg + vecX * vecX.dotProduct(ptOpOrg - ptOrg);
	ptTxt = el.plOutlineWall().closestPointTo(ptTxt);
	dp.textHeight(U(30));
	// HSB-12291 assign to tooling not printable
	dp.elemZone(el, 0, 'T');
	dp.draw(scriptName(), ptTxt + vecZ * U(60), vecX, -vecZ, 0, 0);
	dp.draw(PLine(ptTxt, ptTxt + vecZ * U(40)));
	
// Create int for PropString sDelete
	int nDelete = sNoYes.find(sDelete);
		
	Point3d ptZRef = el.zone(nZone).ptOrg();	
	int nSign =  -1;
	
	if(nZone > 0)
	{
		if(nZone == 6)
			ptZRef += vecZ * el.zone(nZone-1).dH();
		nSign = 1;
	}
	else if (nZone < 0)
	{
		ptZRef -= vecZ * el.zone(nZone).dH();		
	}
	
// Get all gap values and fill missing values. In case of 1 given value this is taken for all
	String sWidthArray[] = sWidth.tokenize(";");
	String sHeightArray[] = sHeight.tokenize(";");
	String sGapEndArray[] = sGapEnd.tokenize(";");
	String sGapOpArray[] = sGapOp.tokenize(";");
	double dWidths[0];
	double dHeights[0];
	double dEndGaps[0];
	double dOpGaps[0];
	
	for (int i=0; i < 4;i++) 
	{ 
		double dGap;
		if(sWidthArray.length() == 1)
			dGap = sWidthArray[0].atof();
		else if(i < sWidthArray.length())
			dGap = sWidthArray[i].atof();
		dWidths.append(dGap);
		
		dGap = 0;
		if(sHeightArray.length() == 1)
			dGap = sHeightArray[0].atof();
		else if(i < sHeightArray.length())
			dGap = sHeightArray[i].atof();
		dHeights.append(dGap);
			
		dGap = 0;
		if(sGapEndArray.length() == 1)
			dGap = sGapEndArray[0].atof();
		else if(i < sGapEndArray.length())
			dGap = sGapEndArray[i].atof();
		dEndGaps.append(dGap);
		
		dGap = 0;
		if(sGapOpArray.length() == 1)
			dGap = sGapOpArray[0].atof();
		else if(i < sGapOpArray.length())
			dGap = sGapOpArray[i].atof();
		dOpGaps.append(dGap);		
	}//next i
	
	int nOrderArray[] = { 2, 0, 3, 1};

	
//Get surounding beams and points for packers
	Beam bmAll[] = el.beam();
	Point3d ptsPackers[0];
	Vector3d vecHeight[] = { vecXOp, vecYOp, - vecXOp, -vecYOp};
	Vector3d vecLength[] = { vecYOp, vecXOp, vecYOp, vecXOp};
	double dOpDiams[] = { 0.5 * op.width(), 0.5 * op.height()};
		
	for (int i=0;i<4;i++) 
	{ 
		Point3d ptZRef1 = (nFunction == 0)? 	ptZRef - vecZ * (dOffset + nSign * 0.5 * dWidths[nOrderArray[i]]) : ptZRef + vecZ * (dOffset + nSign * 0.5 * dHeights[nOrderArray[i]]);	
		
		Beam bmsLine[] = Beam().filterBeamsHalfLineIntersectSort(bmAll, ptOpMid, vecHeight[i]);
		
		if(nIgnoreParallelBeams && nReference == 0)
		{
			for (int j = 0; j < bmsLine.length();j++)
			{
				if(bmsLine[j].vecX().isParallelTo(vecHeight[i]))
				{
					bmsLine.removeAt(j);
					j--;
					if(bmsLine.length() >j)
					{
						continue;
					}
				}
				break;
			}
		}
		
		if(bmsLine.length() > 0 && nReference == 0)
		{
			Point3d pt = bmsLine[0].ptCen() - vecHeight[i] * (0.5 * bmsLine[0].dD(vecHeight[i]));
			pt -= vecZ * vecZ.dotProduct(pt - ptZRef1) + vecLength[i] * vecLength[i].dotProduct(pt - ptOpMid);
			ptsPackers.append(pt);		
							vecHeight[i].vis( pt, i+1);
		}
		else
		{
			ptsPackers.append(ptOpMid + vecHeight[i] * dOpDiams[i % 2] - vecZ * vecZ.dotProduct(ptOpMid - ptZRef1));
		}
		 ptsPackers[i].vis(i+1);
	}//next i
	
	if(ptsPackers.length() != 4)
		bErase = true;
	
	// validate selection set
	if (bErase)		
	{
		//if(_Element.length() > 0)
		reportMessage("\n" + scriptName() + " " + T("|could not find beams around opening.|"));
		eraseInstance();
		return;				
	}	
	
// Calculate length of the packers
	double dLength[0];
	dLength.append((ptsPackers[1] - ptsPackers[3]).length());
	dLength.append((ptsPackers[0] - ptsPackers[2]).length());
	dLength.append(dLength[0]);
	dLength.append(dLength[1]);	
	
//Create packers
	Entity entsSh[0];
	
// Get all properties of the sheet and fill missing values
	String sPropArray[] = sProps.tokenize(";");
	
	for (int i=sPropArray.length()-1;i<9;i++) 
	{ 
		sPropArray.append("");	 
	}//next i	

		
	int nContunes[0];
	if (nSheetLR == 0 || nSheetLR == 1)
		nContunes.append(0);
	if (nSheetTB == 0 || nSheetTB == 1)
		nContunes.append(1);
	if(nSheetLR == 0 || nSheetLR == 2)
		nContunes.append(2);
	if (nSheetTB == 0 || nSheetTB == 2)
		nContunes.append(3);	
	

//Create the sheets 		
	for (int i=0;i<4;i++) 
	{ 
		if(nContunes.find(i) > -1)
			continue;
			
		double dPtSh = (nFunction == 0) ?	dHeights[nOrderArray[i]] : - dWidths[nOrderArray[i]];
			
		int nI = (i % 2 == 0) ? 1 : 0;
		double dGap1 = (nI == 1) ? dEndGaps[0] + dOpGaps[0] : dEndGaps[2] + dOpGaps[2];
		double dGap2 = (nI == 1) ? dEndGaps[1] + dOpGaps[1] : dEndGaps[3] + dOpGaps[3];
		Vector3d vecL = vecLength[i];
		Vector3d vecH = vecHeight[i];
			
		double dUsedLength = dLength[i] - dGap1 - dGap2;
			
		if(dUsedLength < dEps)
		{
			reportMessage("\n" + scriptName() + " " + T("|Opening is to small or gap is to big|"));	
			continue;
		}
		
		Point3d ptSh = ptsPackers[i] + vecL * (vecL.dotProduct(ptsPackers[nI] - ptsPackers[i]) - 0.5 * (dLength[i] + dGap1 - dGap2)) - vecH * dOpGaps[nOrderArray[i]];
		
		Sheet sh;
		sh.dbCreate(ptSh - vecHeight[i] * 0.5 * dPtSh, vecL, vecHeight[i], -nSign * vecZ, dUsedLength, dWidths[nOrderArray[i]], dHeights[nOrderArray[i]]);
		
		if(nFunction == 0)
		{
			CoordSys csSh = cs;
			csSh.setToRotation(90, vecLength[i], ptSh - vecHeight[i] * 0.5 * dHeights[nOrderArray[i]]);
			sh.transformBy(csSh);			
		}

		
	//Set sheet properties
		int nColor = sPropArray[0].atoi();
		if(nColor < -1 || nColor > 254)
			nColor = - 1;
		sh.setColor(nColor);
		sh.setName(sPropArray[1]); // sets the new value
		sh.setMaterial(sPropArray[2]); // sets the new value
		sh.setGrade(sPropArray[3]); // sets the new value
		sh.setInformation(sPropArray[4]); // sets the new value
		sh.setLabel(sPropArray[5]); // sets the label
		sh.setSubLabel(sPropArray[6]); // sets the sub label
		sh.setBeamCode(sPropArray[7]); // sets the new value
		
		sh.assignToElementGroup(el, true, nAsignZone, 'Z');
		entsSh.append(sh);
	}//next i
	
	_Map.setEntityArray(entsSh, false, "Sheet", "Name", "Entry");

// HSB-12291
//Delete the instance
	if(nDelete == 1)
	{
		eraseInstance();
		return;
	}
	






	
	

#End
#BeginThumbnail
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
144`%%%%`!1110`4444`?_]D`











#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17931: bugfix ignore parallel beams." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/21/2023 6:21:08 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17931: bugfix wait for genBeam of elements." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="2/16/2023 11:38:33 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17931: hsbOpeningPackers await element construction and add properties to define base points. " />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="2/12/2023 9:29:07 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12291: assign text to layer &quot;T&quot; not printable" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/22/2021 1:17:38 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End