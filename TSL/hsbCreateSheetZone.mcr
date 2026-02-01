#Version 8
#BeginDescription
#Versions:
1.5 29/08/2024 HSB-22549: Fix when reseting color; Fix "on top of reference zone" for case with pline Marsel Nakuci
1.4 28/08/2024 HSB-22549: Rename properties; consider new sheets created after pline subtract opeation Marsel Nakuci
version value="1.3" date="14oct2019" author="thorsten.huck@hsbcad.com"> 
HSB-5755 properties reordered and categorized

DACH
Dieses TSL erzeugt und/oder modifiziert Platten einer gewählten Zone. 
Die Form der neuen Platten wird aus der Form der gewählten Platten(-zone) abgeleitet.
Ist mindestens eine Polylinie gewählt worden, so resultieren die neuen Platten 
aus einer Verschneidung mit dieser, die Kontur der Polylinie wird von den Basisplatten 
abgezogen.
Sollte keine Polylinien gewählt sein, so werden die Platten in einen neue Zone kopiert 
und transformiert. Je nach Wahl werden dabei die Basisplatten oder die neuen Platten,
sowie alle daraufliegenden Platten um die angegebene Stärke versetzt.
Das TSL verbleibt mit dem Element in der Zeichnung und wird lediglich bei erzeugter Konstruktion
unsichtbar.
Beim Löschen der Konstruktion werden die ursprünglichen Zoneneinstellungen wieder hergestellt.
Es ist mindestens eine freie Zone auf der Bearbeitungsseite erforderlich.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords Element;Sheet;Zone
#BeginContents

//region <History>
// #Versions:
// 1.5 29/08/2024 HSB-22549: Fix when reseting color; Fix "on top of reference zone" for case with pline Marsel Nakuci
// 1.4 28/08/2024 HSB-22549: Rename properties; consider new sheets created after pline subtract opeation Marsel Nakuci
///<version value="1.3" date="14oct2019" author="thorsten.huck@hsbcad.com"> HSB-5755 properties reordered and categorized  </version>
///<version value="1.0" date="10dec15" author="thorsten.huck@hsbcad.com"> initial </version>


/// <summary Lang=en>
/// This tsl modifies and/or creates a new sheeting zone based on a selected zone. 
/// The contour of an existing zone and its sheets is taken and used as base for newly
/// created sheets. If at least one polyline is selected the newly created sheets are build
/// from the intersection of the drawn contour and the existing sheets. Existing sheets will
/// be cut by the contour.
/// In case no polyline has been selected the new sheets will be based on the sheets of the 
/// selected zone. New sheets or the source sheets will be transformed to a new zone. All overlaying
/// sheets will be transformed or respectivly cut if based on plines.
/// At least one empty zone must be available on tooling side.
/// The tsl will remain resident, but not visible if the construction is build. It will restore
/// previous zone settings on element deleted.
/// </summary>

/// <summary Lang=de>
/// Dieses TSL erzeugt und/oder modifiziert Platten einer gewählten Zone. 
/// Die Form der neuen Platten wird aus der Form der gewählten Platten(-zone) abgeleitet.
/// Ist mindestens eine Polylinie gewählt worden, so resultieren die neuen Platten 
/// aus einer Verschneidung mit dieser, die Kontur der Polylinie wird von den Basisplatten 
/// abgezogen.
/// Sollte keine Polylinien gewählt sein, so werden die Platten in einen neue Zone kopiert 
/// und transformiert. Je nach Wahl werden dabei die Basisplatten oder die neuen Platten,
/// sowie alle daraufliegenden Platten um die angegebene Stärke versetzt.
/// Das TSL verbleibt mit dem Element in der Zeichnung und wird lediglich bei erzeugter Konstruktion
/// unsichtbar.
/// Beim Löschen der Konstruktion werden die ursprünglichen Zoneneinstellungen wieder hergestellt.
/// Es ist mindestens eine freie Zone auf der Bearbeitungsseite erforderlich.
/// </summary>

/// <insert=en>
/// Select a sheet and polylines (both optional), select an element and specify parameters.
/// If the construction was build modifications will perform immediatly, else
/// the modified construction will be created on element creation
/// </insert>



// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion


//region Constants 
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
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion

//region Properties
// source
//	category = T("|Reference|");
	category=T("|Calculation rule|");
// collect original zones
	Map mapZones = _Map;
	int nZones[0];
	int nZonesMap[0];
	for (int i=0; i<mapZones.length();i++)
	{
		if (mapZones.hasMap(i))
		{
			int n = mapZones.getMap(i).getInt("ZoneIndex");
			if (nZonesMap.find(n)<0)
				nZonesMap.append(n);
		}
	}
	if(nZonesMap.length()>0)
	{ 
		nZones.append(nZonesMap);
	}
	else if(nZonesMap.length()==0)
	{ 
		int nZonesAll[]={ -5,-4,-3,-2,-1,1,2,3,4,5};
		nZones.append(nZonesAll);
	}
//	String sRefZoneName=T("|Zone|") ;
	String sRefZoneName=T("|Reference zone|") ;	// Referenzzone
	PropInt nRefZone(nIntIndex++, nZones, sRefZoneName);
	nRefZone.setCategory(category);		

// target
//	category = T("|Sheet|");
//	String sShiftRules[] = {"Referenzzone", T("|On Top of Reference Zone|")};
	String sShiftRules[] = {"Integrated in reference zone", T("|On Top of Reference Zone|")}; // In Referenzone integriert; Oben auf der Referenzzone
//	String sShiftRuleName =T("|Zone|");//T("|Shift to next Zone|") ;	
	String sShiftRuleName =T("|Position of new sheet|");// Position neue Platte
	PropString sShiftRule(nStringIndex++, sShiftRules, sShiftRuleName );
	sShiftRule.setDescription(T("|Specifies wether the source or target object shifts zone assignment.|"));
	sShiftRule.setCategory(category);		

	category = T("|Sheet|");
	String sThicknessName=T("|Thickness|") ;	
	PropDouble dThickness (nDoubleIndex++, 0, sThicknessName);
	dThickness.setDescription(T("|Specifies the new thickness|"));
	dThickness.setCategory(category);

	String sNameName=T("|Name|");	
	PropString sName(nStringIndex++, "", sNameName);
	sName.setCategory(category);	
	
	String sMaterialName=T("|Material|") ;	
	PropString sMaterial(nStringIndex++, "", sMaterialName);
	sMaterial.setCategory(category);	

	String sGradeName=T("|Grade|") ;	
	PropString sGrade(nStringIndex++, "", sGradeName);
	sGrade.setCategory(category);	
	
	String sColorName=T("|Color|") ;	
	PropInt nColor(nIntIndex++, 0, sColorName);
	nColor.setCategory(category);	
//End Properties//endregion

//region bOnInsert
// on insert
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
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}

//	// get selection set
//		PrEntity ssE(T("|Select a sheet of desired zone|")+ " " + T("|(optional)|"), Sheet());
//		Sheet sheets[0];
//		if (ssE.go())
//			sheets= ssE.sheetSet();

	// declare element		
		Element el;
//		if (sheets.length()>0)
//			el = sheets[0].element();

	// element selection via sheet has failed
		if (!el.bIsValid())
			el=getElement();
			
	// collect zones of element
		for (int i=-5;i<6;i++)
		{
			if (i==0 || el.zone(i).dH()<dEps)continue;	
			nZones.append(i);
		}	
		if (nZones.length()<1)
		{
			reportMessage("\n"+ scriptName() + " " + T("|Could not collect element zones.|"));
			eraseInstance();
			return;
		}
		
//	// redeclare RefZone property	
//		nRefZone = PropInt(0, nZones, sRefZoneName);	
//		nRefZone.setCategory(T("|Reference|"));
//		if (sheets.length()>0)
//		{
//			int nSheetZone = sheets[0].myZoneIndex();
//			if (nZones.find(nSheetZone)>-1)
//			nRefZone.set(nSheetZone);		
//		}	
//		if (nZones.find(nRefZone)<0)	
//			nRefZone.set(nZones[0]);	
			
	// select defining pline
	// get selection set
		PrEntity ssEpl(T("|Select polyline(s) which describe the contour to be changed|")+ " " + T("|(optional)|"), EntPLine());
		Entity entsEpls[0];
		if (ssEpl.go())
			entsEpls= ssEpl.set();
		for(int i=0;i<entsEpls.length();i++)	
			_Entity.append(entsEpls[i]);
		
	// collect zone data via modelMap
		ModelMapComposeSettings composeSettings;

	// compose ModelMap
		Entity ents[] = {el};
		ModelMap mm;
		mm.setEntities(ents);
		mm.dbComposeMap(composeSettings);

	// set some import flags
		ModelMapInterpretSettings interpreteSettings;
		interpreteSettings.resolveEntitiesByHandle(TRUE); // default FALSE
		interpreteSettings.resolveElementsByNumber(TRUE); // default FALSE

	// interpret ModelMap
		mm.dbInterpretMap(interpreteSettings);	
		_Map = mm.map().getMap("Model\\ElementWallSF\\ElementWall\\Element\\ElemZone[]");

		_Element.append(el);
		
		showDialog();

		//_Pt0 = getPoint();
		_ThisInst.setColor(3);
		return;
	}	
// end on insert	__________________//endregion	
	
// validate dependencies
	if (_Element.length()<1)	
	{
		reportMessage("\n"+ scriptName() + " " + T("|requires one element|"));
		eraseInstance();
		return;
	}
	Element el = _Element[0];
	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	int nSide = abs(nRefZone)/nRefZone;
	
	assignToElementGroup(el, true, nRefZone, 'E');

// check duplicates of this script on same side
	TslInst tsls[] = el.tslInst();
	if (!_bOnDebug)
	{
		int bFound;
		for (int i=0;i<tsls.length();i++)
		{
			if (tsls[i].scriptName()==scriptName() && tsls[i]!=_ThisInst)
			{
				int nZoneOther=tsls[i].propInt(0);
				if (nZoneOther!=0 && abs(nZoneOther)/nZoneOther==nSide)
				{
					reportMessage("\n" + T("|Element|") + " " + el.number() + " " + T("|tool already attached|"));
					eraseInstance();
					return;
				}
			}
		}
	}
	
	
// add plines trigger
	String sTriggerAddPLine = T("|Add Polyline(s)|");
	addRecalcTrigger(_kContext, sTriggerAddPLine );
	if (_bOnRecalc && _kExecuteKey == sTriggerAddPLine )
	{
	// get selection set
		PrEntity ssEpl(T("|Select polyline(s) which describe the contour to be changed|")+ " " + T("|(optional)|"), EntPLine());
		Entity entsEpls[0];
		if (ssEpl.go())
			entsEpls= ssEpl.set();
		for(int i=0;i<entsEpls.length();i++)	
			if (_Entity.find(entsEpls[i])<0)
				_Entity.append(entsEpls[i]);		
	}


// get optional defining entPline	
	PLine plDefines[0];
	for (int i=0;i<_Entity.length();i++)
	{	
		EntPLine epl;
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(EntPLine()))
		{
			epl =(EntPLine)ent;
			PLine plDefine = epl.getPLine();
			if (!plDefine.coordSys().vecZ().isParallelTo(vecZ))
				continue;
			else
				plDefines.append(plDefine);	
		}
	}

// set a flag if valid plines are found
	int bHasPLines = plDefines.length()>0;
	
// validate free zone: target or source items will be shifted one zone up. Therefor it is required to have at least one more zone available
	if (el.zone(nSide*5).dH()>dEps)
	{
		reportMessage("\n"+ scriptName() + " " + T("|will shift source or target items to a higher zone|") + " " + 
			T("|Therefor it is required that at least one zone on the same side is not used|"));
		eraseInstance();
		return;		
	}	
	
	if (_bOnDebug && 0 )_Map.writeToDxxFile(_kPathDwg + "\\"+ dwgName()+"map.dxx");
	
// properties by index	
	int nShiftRule=sShiftRules.find(sShiftRule,0); // 0= source, 1=target

// the defining zone
	ElemZone elzoSource=el.zone(nRefZone);
	_Pt0 =elzoSource.coordSys().ptOrg();
	_Pt0.vis(1);
	
// collect all sheets
	Sheet sheets[] = el.sheet();
	
// add a display
	Display dp(nColor);
	
// set the defining contour and draw something for unconstructed elements
	PlaneProfile ppDefine(elzoSource.coordSys());
	for (int i=0;i<plDefines.length();i++)
		ppDefine.joinRing(plDefines[i],_kAdd);	
	if (bHasPLines && sheets.length()<1)
	{
		ppDefine.shrink(-dEps);
		ppDefine.shrink(dEps);
		dp.draw(ppDefine);
		ppDefine.vis(2);
	}
	
	if (sheets.length()<1)
	{
		PLine pl(vecY);
		pl.createRectangle(LineSeg(_Pt0-vecX*U(10e4),_Pt0+vecX*U(10e4)+elzoSource.vecZ()*dThickness), vecX,elzoSource.vecZ());
		PlaneProfile pp(pl);
		if (el.bIsKindOf(ElementWall()))pp.intersectWith(PlaneProfile(el.plOutlineWall()));
	// if no pline is selected the new sheets will be moved on top of the source zone	
	// // 0= source, 1=target
		// HSB-22549: fix "on top of reference" with pline
//		if (nShiftRule==1 && !bHasPLines)pp.transformBy(elzoSource.coordSys().vecZ()*elzoSource.dH());
		if (nShiftRule==1)pp.transformBy(elzoSource.coordSys().vecZ()*elzoSource.dH());
		
		dp.draw(pp, _kDrawFilled);
	}	

// on element deleted reset everything
	if (_bOnElementDeleted)
	{
		if (bDebug)reportNotice("\n"+ scriptName() + " OnElementDeleted...");
		for (int i=5;i>=abs(nRefZone);i--)
		{
		// find zone index in map	
			int nZoneSource=i*nSide;
			Map mapZone;	
			for (int j=0;j<mapZones.length();j++)
			{
				Map map = mapZones.getMap(j);
				int nZoneIndex = map.getInt("ZoneIndex");
				if (nZoneIndex==nZoneSource)
				{
					if (bDebug)reportNotice("\n	" + nZoneIndex  + " found in map");
					mapZone=map;
					break;
				}		
			}

		// specify the zone to be manipulated, reset if no data or 
			ElemZone elzo=el.zone(nZoneSource);
			if (mapZone.length()<1)
			{
				if (bDebug)reportNotice("\n	plain resetting " + nZoneSource);
				elzo.setDH(0);
				elzo.setColor(0);
				elzo.setMaterial("");
				elzo.setCode("");
			}
			else
			{
				if (bDebug)reportNotice("\n	resetting by map " + nZoneSource);
			// map entry found, copy zone data
				elzo.setCode(mapZone.getString("Code"));
				elzo.setDH(mapZone.getDouble("DH"));
	
				int nVarIndex;
				for (int j=0;j<mapZone.length();j++) // index 0 zoneIndex, 1= Code, 2= DH
				{
					String sKeyName = mapZone.keyAt(j).makeUpper();
					String sVarName = mapZone.getString(j).makeUpper();
					if (sKeyName == "VARNAME"+nVarIndex)
					{
						if (mapZone.hasInt("NVAR"+nVarIndex))
						{
							int n = mapZone.getInt("NVAR"+nVarIndex++);
							// HSB-22549: fix when setting volor
							if(sVarName=="COLOR")
							{
								elzo.setColor(n);
							}
							
						}
						else if (mapZone.hasDouble("DVAR"+nVarIndex))
							elzo.setDVar(sVarName,mapZone.getDouble("DVAR"+nVarIndex++));
						else if (mapZone.hasString("STRVAR"+nVarIndex))
						{
							String sValue = mapZone.getString("STRVAR"+nVarIndex++);
							elzo.setStrVar(sVarName, sValue);		
						}							
					}
				}// next j				
			}
			el.setZone(nZoneSource,elzo);
		}// next i	
		if (bDebug)reportNotice("\n...OnElementDeleted ended");
	}// END IF  (_bOnElementDeleted)	
	
	else if (_bOnElementConstructed || (_bOnDbCreated && sheets.length()>0))
	{
		if (bDebug)reportNotice("\n"+ scriptName() + " bOnElementConstructed ...");
		
	// the coordSys of the the new sheets
		CoordSys csNew = 	elzoSource.coordSys();
		// 0= source, 1=target
		// HSB-22549: fix "on top of reference" with pline
//		if (nShiftRule==1 && !bHasPLines)csNew.transformBy(elzoSource.coordSys().vecZ()*elzoSource.dH());
		if (nShiftRule==1)csNew.transformBy(elzoSource.coordSys().vecZ()*elzoSource.dH());
		
	// create new sheets		
		for (int s=0;s<sheets.length();s++)
		{
			if (sheets[s].myZoneIndex()!=nRefZone)continue;
			
			PlaneProfile ppSheet=sheets[s].profShape();
			if (bHasPLines)
				ppSheet.intersectWith(ppDefine);
	
		// get all rings
			PLine plRings[] = ppSheet.allRings();
			int bIsOp[] = ppSheet.ringIsOpening();			
	
		// build a planeprofile per outline ring
			for (int r = 0; r < plRings.length(); r++) 
			{
				if (!bIsOp[r])
				{
					PlaneProfile pp(csNew);
					pp.joinRing(plRings[r],_kAdd);
					for (int p= 0; p< plRings.length(); p++) if (bIsOp[p])pp.joinRing(plRings[p],_kSubtract);
						if (pp.area()< pow(U(1),2)) continue;		
					pp.vis(r);
					//pp.transformBy(vecZ*vecZ.dotProduct)
					if (!_bOnDebug)
					{
						Sheet shNew;
						shNew.dbCreate(pp, dThickness,1);
						if (nShiftRule==0)// 0= source, 1=target
							shNew.assignToElementGroup(el, TRUE, nRefZone, 'Z');
						else
							shNew.assignToElementGroup(el, TRUE, nRefZone+nSide, 'Z');
						if (bDebug)reportNotice("\n" + shNew.handle() + " has been assigned to "+ shNew.myZoneIndex());
						shNew.setMaterial(sMaterial);					
						shNew.setGrade(sGrade);	
						shNew.setName(sName);			
						shNew.setColor(nColor);
					}					
				}
			}// next r		
		}// next s of sheets
		
		Sheet sheetsAdded[0];
		for (int s=0;s<sheets.length();s++)
		{
			int nThisZone =sheets[s].myZoneIndex();
			// HSB - 22549: -> || (nShiftRule==1 && nThisZone==nRefZone) 
			// dont cut zone when option "on top of reference zone"
			if (nThisZone==0 || 
				abs(nThisZone)/nThisZone!=nSide || 
				abs(nThisZone)<abs(nRefZone)
				|| (nShiftRule==1 && nThisZone==nRefZone) )continue;			
		// subtract defining contour from sheets which are above the defining zone		
			if (bHasPLines)
			{
				if (bDebug)reportNotice("\n" + sheets[s].handle() + " subtracting contour in zone "+ nThisZone );	
				for (int i=0;i<plDefines.length();i++)
				{
					Sheet sheetsNew[]=sheets[s].joinRing(plDefines[i], _kSubtract);
					// HSB - 22549
					sheetsAdded.append(sheetsNew);
				}
			}
		// transform sheets to new location
			else
			{
				if (nShiftRule==1 && abs(nThisZone)==abs(nRefZone)) continue;
				if (bDebug)reportNotice("\n" + sheets[s].handle() + " transformed by "+ dThickness + " in zone "+ nThisZone );
				sheets[s].transformBy(elzoSource.coordSys().vecZ()*dThickness);
			}
		}
	//HSB - 22549: Include new created sheets after sheets[s].joinRing(plDefines[i], _kSubtract)
		sheets.append(sheetsAdded);
	// loop zones
		for (int i=4;i>=abs(nRefZone);i--) // the outmost supported zone is 4 respectivly -4
		{
		// find zone index in map	
			int nZoneSource=i*nSide;		
			int nZoneTarget=nZoneSource+nSide;
			ElemZone elzoTarget=el.zone(nZoneTarget);
			
			Map mapZone;	
			for (int j=0;j<mapZones.length();j++)
			{
				Map map = mapZones.getMap(j);
				int nZoneIndex = map.getInt("ZoneIndex");
				if (nZoneIndex==nZoneSource)
				{
					if (bDebug)reportNotice("\n	" + nZoneIndex  + " found in map");
					mapZone=map;
					break;
				}		
			}
			
		// override how the zone above the source zone shall be handled
			if (bDebug)reportNotice("\n	Shift Rule " + nShiftRule+ " in zone " + nZoneSource);
			if (nShiftRule==1 && nRefZone==nZoneSource) // shift target
			{
				if (bDebug)reportNotice("\n	setting properties to map");
				mapZone.setDouble("DH", dThickness);
				mapZone.setInt("NVAR1", nColor);
				mapZone.setString("STRVAR0", sMaterial);					
			}		
			else if (nShiftRule==0 && nRefZone==nZoneSource) // shift target
			{
				if (bDebug)reportNotice("\n	setting zone by properties");
				elzoSource.setDH(dThickness);
				elzoSource.setColor(nColor);
				elzoSource.setMaterial(sMaterial);				
			}	
			
		// map entry found, copy zone data
			elzoTarget.setCode(mapZone.getString("Code"));
			elzoTarget.setDH(mapZone.getDouble("DH"));
	
			int nVarIndex;
			for (int j=0;j<mapZone.length();j++) // index 0 zoneIndex, 1= Code, 2= DH
			{
				String sKeyName = mapZone.keyAt(j).makeUpper();
				String sVarName = mapZone.getString(j).makeUpper();
				if (sKeyName == "VARNAME"+nVarIndex)
				{
					if (mapZone.hasInt("NVAR"+nVarIndex))
					{
						int n = mapZone.getInt("NVAR"+nVarIndex++);
						elzoTarget.setColor(n);
					}
					else if (mapZone.hasDouble("DVAR"+nVarIndex))
						elzoTarget.setDVar(sVarName,mapZone.getDouble("DVAR"+nVarIndex++));
					else if (mapZone.hasString("STRVAR"+nVarIndex))
					{
						String sValue = mapZone.getString("STRVAR"+nVarIndex++);
						elzoTarget.setStrVar(sVarName, sValue);		
					}							
				}
			}// next j				
			el.setZone(nZoneTarget,elzoTarget);			
		}// next i
		if (nShiftRule==0)
		{	
			el.setZone(nRefZone,elzoSource);	
		}
		
	// assign original sheets to shifted zones
		for (int i=5;i>=abs(nRefZone);i--)
		{
			int nThisZone=i*nSide;	
			int nShiftZone = nThisZone+nSide;
			if (nThisZone==nRefZone && nShiftRule==1)
				continue;// no reassignment required
			
			for (int s=0;s<sheets.length();s++)
			{
				if (sheets[s].myZoneIndex()!=nThisZone)continue;
				sheets[s].assignToElementGroup(el, TRUE, nShiftZone , 'Z');		
			}
		}
		if (bDebug)reportNotice("\n...bOnElementConstructed ended");		
	}

	
	
	
	
	
	


#End
#BeginThumbnail
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
C.NZIM6Y5%13D`LH`_+FNDLH6MK&"!B"T<84D=.!5BB@#_]GZ
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22549: Fix when reseting color; Fix &quot;on top of reference zone&quot; for case with pline" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="8/29/2024 9:14:53 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22549: Rename properties; consider new sheets created after pline subtract opeation" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="8/28/2024 8:34:18 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End