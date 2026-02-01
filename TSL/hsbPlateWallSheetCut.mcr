#Version 8
#BeginDescription
version value="2.1" date="10nov2020" author="marsel.nakuci@hsbcad.com"

HSB-9670: Consider all zones when checking the penetration
HSB-7940: reading settings improved, insertion prompt enhanced, bugfix missing zone intersection 

Select purlin and any entity belonging to a wall element, enter properties OK

This tsl creates openings at the sheets of a wall.
If a purlin intersects the wall, the TSL will create openings at the 
sheets of the selected zone
Parameters X1, X2, Y1, Y2 that define the geometry of the opening of the sheet 
can be entered at the properties or defined in an XML file with the same name as the
script name i.e. "hsbPlateWallSheetCut". 
If the properties are not changed from their default values and 
If the XML file exist at the hsbCompany\TSL\Settings directory, 
then the parameters are read from the XML file. 
If the XML file is not found then the default properties are used.
If one of the properties is entered, the parameters are taken from the properties.
A value 0 for the parameters Y1, Y2 means the cut is applied all the way through 
in the Y direction.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 1
#KeyWords rubner, sheet, wall, cut
#BeginContents
/// <History>//region
///<version value="2.1" date="10nov2020" author="marsel.nakuci@hsbcad.com"> HSB-9670: Consider all zones when checking the penetration </version>
///<version value="2.0" date="16jun2020" author="thorsten.huck@hsbcad.com"> HSB-7940: reading settings improved, insertion prompt enhanced, bugfix missing zone intersection </version>
/// <version value="1.9" date="20.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5989: update TSL picture </version>
/// <version value="1.9" date="20.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5989: update TSL picture </version>
/// <version value="1.8" date="20.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5989: add parameter y3 </version>
/// <version value="1.7" date="15.10.2019" author="marsel.nakuci@hsbcad.com"> modifications from email Do 10.10.2019 14:49 </version>
/// <version value="1.6" date="26.09.2019" author="marsel.nakuci@hsbcad.com"> add property offset </version>
/// <version value="1.5" date="25.09.2019" author="marsel.nakuci@hsbcad.com"> remove condition "if (_dX2 < dEps)_dY2 = 0;" </version>
/// <version value="1.4" date="25.09.2019" author="marsel.nakuci@hsbcad.com"> fix bug at _y1, prompt only selection of intersecting beam Pfette and at least one beam of the wall </version>
/// <version value="1.3" date="13.May" author="marsel.nakuci@hsbcad.com"> Bug fix at the enevlope </version>
/// <version value="1.2" date="06.May" author="marsel.nakuci@hsbcad.com"> Picture+cut the sheets that intersect with the envelope of the opening </version>
/// <version value="1.1" date="06.May" author="marsel.nakuci@hsbcad.com"> if no map or xml then take the values in properties </version>
/// <version value="1.0" date="03.May" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select wall and purlin, enter properties OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates openings at the sheets of a wall.
/// If a purlin intersects the wall, the TSL will create openings at the 
/// sheets of the selected zone
/// Parameters X1, X2, Y1, Y2 that define the geometry of the opening of the sheet 
/// can be entered at the properties or defined in an XML file with the same name as the
/// script name i.e. "hsbPlateWallSheetCut". 
/// If the properties are not changed from their default values and 
/// If the XML file exist at the hsbCompany\TSL\Settings directory, 
/// then the parameters are read from the XML file. 
/// If the XML file is not found then the default properties are used.
/// If one of the properties is entered, the parameters are taken from the properties.
/// A value 0 for the parameters Y1, Y2 means the cut is applied all the way through 
/// in the Y direction.
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbPlateWallSheetCut")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

//region properties
	String sX1Name=T("|X1|");	
	PropDouble dX1(nDoubleIndex++, U(0), sX1Name);	
	dX1.setDescription(T("|Defines the X1|"));
	dX1.setCategory(category);
	
	String sY1Name=T("|Y1|");	
	PropDouble dY1(nDoubleIndex++, U(0), sY1Name);	
	dY1.setDescription(T("|Defines the Y1|"));
	dY1.setCategory(category);
	
	String sX2Name=T("|X2|");	
	PropDouble dX2(nDoubleIndex++, U(0), sX2Name);	
	dX2.setDescription(T("|Defines the X2|"));
	dX2.setCategory(category);
	
	String sY2Name=T("|Y2|");	
	PropDouble dY2(nDoubleIndex++, U(0), sY2Name);	
	dY2.setDescription(T("|Defines the Y2|"));
	dY2.setCategory(category);
	
	// y parameter below
	String sY3Name=T("|Y3|");	
	PropDouble dY3(nDoubleIndex++, U(0), sY3Name);
	dY3.setDescription(T("|Defines the Y3|"));
	dY3.setCategory(category);
	// zone where the cut will be applied, 0 apply at ll zones
	String sZoneName=T("|Zone|");	
	int nZones[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 0, 1, 2, 3, 4, 5};
	PropInt nZone(nIntIndex++, nZones, sZoneName, 5);// default zone 1
	nZone.setDescription(T("|Defines the Zone where the sheets are to be cutted|"));
	nZone.setCategory(category);
	
	String sSubseqZoneName=T("|Subsequent Zones|");	
	PropString sSubseqZone(nStringIndex++, sNoYes, sSubseqZoneName);	
	sSubseqZone.setDescription(T("|Should the sheets of subsequent zones from the selected zone be cutted? |"));
	sSubseqZone.setCategory(category);
	
	// property offset
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset|"));
	dOffset.setCategory(category);
	
//End properties//endregion
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbPlateWallSheetCut";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}		
//End Settings//endregion

// bOnInsert//region
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
			
		// prompt for the selection of intersecting beams (Pfete) and the beams belonging to walls
		Beam beams[0];
		PrEntity ssB(T("|Select intersecting beams|"), Beam());
		if (ssB.go())
			beams.append(ssB.beamSet());

	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select walls or entities belonging to a wall|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
			
		// get all the walls from all the selected beams
		ElementWallSF walls[0];
		for (int i = 0; i < ents.length(); i++)
		{ 
			Element el = ents[i].element();
			if (el.bIsValid() && walls.find(el)<0)
			{ 
				ElementWallSF w = (ElementWallSF)el;
				if (w.bIsValid())
					walls.append(w);
			} 
		}//next i

		if(walls.length()<1)
		{ 
			reportMessage(TN("|Could not find any wall.|"));
			eraseInstance();
			return;
		}

	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[1];			Entity entsTsl[1];				Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;

		nProps.append(nZone);
		dProps.append(dX1);
		dProps.append(dY1);
		dProps.append(dX2);
		dProps.append(dY2);
		dProps.append(dY3);
		dProps.append(dOffset);
		sProps.append(sSubseqZone);
		
	// for each intersection of wall with a purlin create a TSL instance
	// loop all beams
		int iTslCount = 0;
		if(beams.length()<1)
		{ 
			reportMessage(TN("|no beam was selected|"));
			eraseInstance();
			return;
		}
		for (int i=0;i<beams.length();i++)// for all selected beams 
		{
			Beam b = beams[i];
			Vector3d vecXBeam = b.vecX();
			Vector3d vecYBeam = b.vecY();
			Vector3d vecZBeam = b.vecZ();
			double dLengthBeam = b.solidLength();
			
			Point3d ptCen = b.ptCen();
			// loop all walls
			
			Line lBeam(ptCen, vecXBeam);
			for (int j=0;j<walls.length();j++)// for all walls 
			{ 
				ElementWallSF w = walls[j];
				Vector3d vecXWall = w.vecX();
				Vector3d vecYWall = w.vecY();
				Vector3d vecZWall = w.vecZ();
				double dWallBeamWidth = w.dBeamWidth();// width corresponds to width of wall
				double dWallBeamHeight = w.dBeamHeight();
				
				ElemZone zone = w.zone(nZone);
				if (zone.dH()<dEps){ continue;}
				// 
				if(abs(vecXBeam.dotProduct(vecXWall))>dEps && abs(vecXBeam.dotProduct(vecYWall))>dEps)
				{
					// wall and beam are not normal to each other
					// skew beams to wall are also supported 
				}
				if (abs(vecXBeam.dotProduct(vecZWall))<dEps)
				{ 
					// beam in the plane of wall, not allowed
//					reportMessage(TN("|Beam lies in the plane of wall, excluded|"));
					continue;
				}
				
				// get point in wall
				Point3d ptOrg = w.ptOrg();// 
//				Point3d ptOrg2 = ptOrg - dWallBeamWidth * vecZWall;
				Point3d ptOrg2 = ptOrg;
				// HSB-9670: Consider all zones when checking the penetration
				ptOrg += w.dPosZOutlineFront() * w.coordSys().vecZ();
				ptOrg2 += w.dPosZOutlineBack() * w.coordSys().vecZ();
				//plane of wall
				Plane planeWall(ptOrg, vecZWall);
				Plane planeWall2(ptOrg2, vecZWall); // plane going through second point ptOrg2
				// check if beam and wall have intersection
				// get the body of the beam
				Body bodyBeam = b.envelopeBody(true, true);
//				Body bodyBeam = b.realBody();
				
				// shadow of the body in xy of wall
				PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
				//PLine plWall = w.plOutlineWall();// outline of element in XY plane
				PlaneProfile ppWall = w.plEnvelope();//if no point is given, point is PtOrg, cut with plane in xy of wall
				// check intersection of 2 planeprofiles
				int isIntersect = pPBeam.intersectWith(ppWall);
				if(!isIntersect)
				{
					// if beam is outside the area of the wall
					reportMessage(TN("|Beam lies outside of the wall area|"));
					continue;
				}
				Point3d ptIntersect;// intersection with first plane
				Point3d ptIntersect2;// intersection with second plane
				//find the intersection point of the beam and the wall
				int iWallHasIntersect = lBeam.hasIntersection(planeWall, ptIntersect); //return TRUE if intersect is found, and set in ptIntersect.
				if(!iWallHasIntersect)
				{
					// no intersection with first plane, try second plane
					reportMessage(TN("|no intersection of beam axis with wall plane, parallel|"));
					continue;
				}
				lBeam.hasIntersection(planeWall2, ptIntersect2);
				// from ptIntersect and ptIntersect2 get the one closer
				Vector3d v1 = ptIntersect - ptCen;
				Vector3d v2 = ptIntersect2 - ptCen;
				double dClosestDistance = v1.length();
				if(v2.length()<dClosestDistance)
				{ 
					dClosestDistance = v2.length();
				}
//				if((.5*dLengthBeam - dClosestDistance)<0.1*dWallBeamWidth)
				// HSB-9670: Consider all zones when checking the penetration
				if((.5*dLengthBeam - dClosestDistance)<dEps)
				{ 
					// beam does not penetrate enough into the wall
					reportMessage(TN("|Beam does not penetrate enough into the wall|"));
					continue;
				}
				// see how deep the beam enteres the wall plane
				
//				//see if beam is long enough to intersect with wall
//				PlaneProfile pp = bodyBeam.getSlice(planeWall); // profile of intersection
//				PlaneProfile pp2 = bodyBeam.getSlice(planeWall2);
//				// make a union of pp and pp2
//				pp.unionWith(pp2); // pp in the plane of ptOrg
//				if (pp.area() < dEps) //pow(dEps, 2))
//				{
//					reportMessage(TN("|No slice between beam and any of wall planes|"));
//					continue;
//				}

				// see if beam intersects zone
				Body bdZone(w.plEnvelope(zone.ptOrg()), zone.vecZ() * zone.dH(), 1);
				if ( ! bdZone.hasIntersection(bodyBeam) && nZone != 0) { continue; }
				iTslCount = iTslCount + 1;
				if (bDebug)reportMessage("\n" + scriptName() + "entering tsl nr. : " + iTslCount);
				ptsTsl[0] = ptIntersect;// intersection with first plane of the wall
				gbsTsl[0] = b;// main beam, Pfette in _Beam[0]
				entsTsl[0] = w;//the wall in _Element[0];
				// create tsl for each beam wall intersection
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}//next j
		}//next i
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion	

//region ints

	int bHasSubsequentZone = sNoYes.find(sSubseqZone,1);	
//End ints//endregion 

//region if no intersecting beam pfette or element
	if(_Beam.length()<1)
	{ 
		// no beam 
		reportMessage(TN("|no intersecting beam found|"));
		eraseInstance();
		return
	}
	
	if(_Element.length()<1)
	{ 
		reportMessage(TN("|no element found|"));
		eraseInstance();
		return;
	}

//End if no intersecting beam pfette or element//endregion

//region zone 0 will cut from inside and outside
		
	if (nZone == 0 && bHasSubsequentZone)
	{ 
		Beam bm = _Beam[0];
		Element el = _Element[0];
		// zone 0 and Yes for subsequent zones 
		// create TSL for inside
		{ 
			// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;	
						
			gbsTsl.append(bm);
			entsTsl.append(el);
			// properties
			nProps.append(-1);
			dProps.append(dX1);
			dProps.append(dY1);
			dProps.append(dX2);
			dProps.append(dY2);
			dProps.append(dY3);
			dProps.append(dOffset);
			sProps.append(sSubseqZone);
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}
		
		// create TSL for outside
		{ 
			// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;	
						
			gbsTsl.append(bm);
			entsTsl.append(el);
			// properties
			nProps.append(1);
			dProps.append(dX1);
			dProps.append(dY1);
			dProps.append(dX2);
			dProps.append(dY2);
			dProps.append(dY3);
			dProps.append(dOffset);
			sProps.append(sSubseqZone);
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}
		eraseInstance();
		return
	}
	else if (nZone == 0 && !bHasSubsequentZone)
	{ 
		eraseInstance();
		return;
	}
//End zone 0 will cut from inside and outside//endregion 


//region check validity of zones
	Element el = _Element[0];
	ElementWall elWall = (ElementWall)el;
	if ( ! elWall.bIsValid())
	{ 
		// 
		reportMessage(TN("|not an ElementWall|"));
		eraseInstance();
		return;
	}
	// 1-exterior, 0-interior
	int iExposed = elWall.exposed();
	
// existing element zones
	int iZonesElement[0];
	
// get all element zones of element excluding 0
	int iZonesAll[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 1, 2, 3, 4, 5};
	for (int i=0;i<iZonesAll.length();i++) 
	{ 
		int iZoneI = iZonesAll[i];
		ElemZone eZone = el.zone(iZoneI);
		if(eZone.dH()>0)
		{ 
		// zone exist
			if(iZonesElement.find(iZoneI)<0)
			{ 
				// zone is new, append it
				iZonesElement.append(iZoneI);
			}
		}
	}//next i
	
	if(iZonesElement.length()<1)
	{ 
		// element has only zone 0
		eraseInstance();
		return;
	}
	if(bDebug)reportMessage("\n"+ scriptName() + " iZonesElement.length(): "+iZonesElement.length());
	if(bDebug)reportMessage("\n"+ scriptName() + " nZone: "+nZone);
	
// if selected zone exists in the element
	ElemZone eZone = el.zone(nZone);
	if (eZone.dH() == 0 || abs(nZone) > 5)
	{
		// selected zone does not exist
		reportMessage(TN("|selected zone does not exist|"));
		eraseInstance();
		return;
	}
	
//End get element zones//endregion 

//region general information
	Beam bm = _Beam[0];
	Point3d ptCen = bm.ptCenSolid();
	Vector3d vecX = bm.vecX();
	Vector3d vecY = bm.vecY();
	Vector3d vecZ = bm.vecZ();
	vecX.vis(ptCen, 1);
	vecY.vis(ptCen, 3);
	vecZ.vis(ptCen, 150);
	_Pt0 = ptCen;

	Point3d ptCenWall = el.ptOrg();
	Vector3d vecXWall = el.vecX();
	Vector3d vecYWall = el.vecY();
	Vector3d vecZWall = el.vecZ();
	vecXWall.vis(ptCenWall,1);
	vecYWall.vis(ptCenWall,3);
	vecZWall.vis(ptCenWall,150);
//End general information//endregion 
		
//region get material of the zone
	GenBeam gbs[] = el.genBeam(nZone);
	if(gbs.length()<1)
	{ 
		reportMessage(TN("|no sheet located in this zone|"));
		eraseInstance();
		return;
	}
	String sMaterial = eZone.material();
	if(bDebug)reportMessage("\n"+ scriptName() + " sMaterial: "+sMaterial);
	if(bDebug)reportMessage("\n"+ scriptName() + " dH: "+eZone.dH());
//End get material of the zone//endregion 
	
//region Get settings
	double _dX1;
	double _dY1;
	double _dX2;
	double _dY2;
	double _dY3;
	if (mapSetting.length() > 0)
	{
		String k;
	// get all zones	
		Map mapZones = mapSetting.getMap("Zone[]");
		
	// find the map of the selected Zone
		Map mapZone;
		for (int i = 0; i < mapZones.length(); i++)
		{
			Map m = mapZones.getMap(i);
			if (mapZones.keyAt(i).makeLower() != "zone" ){continue;}
			
		// zone is not active	
			k = "isActive"; if (m.hasInt(k) && m.getInt(k) == 0){continue;}
		
		// compare index
			k = "Index";	if (!m.hasInt(k)){continue;}
			if (m.getInt(k)==nZone)
			{
				mapZone = m;
				break;
			}
		}
		
	// get materials of this zone (or default)	
		Map mapMaterials, mapMaterial, mapDefaultMaterial;
		k = "Material[]"; if (mapZone.hasMap(k))mapMaterials = mapZone.getMap(k);
		for (int i = 0; i < mapMaterials.length(); i++)
		{
			if (mapMaterials.keyAt(i).makeLower() != "material"){ continue;}
			Map m = mapMaterials.getMap(i);
			
			String sNameMaterial;
			k = "Name"; 	if (m.hasString(k))	sNameMaterial = m.getString(k);
			
		// get default material
			if (sNameMaterial.find("Default",0, false)>-1 && sNameMaterial.length()==7)
				mapDefaultMaterial = m;
			else if (sNameMaterial.find(sMaterial,0, false)>-1 && sNameMaterial.length()==sMaterial.length())	
			{
				mapMaterial = m;
				break;
			}
		}//next j
		if (mapMaterial.length() < 1)mapMaterial = mapDefaultMaterial;

		Map mapThickness = mapMaterial.getMap("Thickness[]");
		Map mThickness;
		for (int i = 0; i < mapThickness.length(); i++)
		{
			Map mThicknessI = mapThickness.getMap(i);
			if (mThicknessI.hasDouble("Thickness") && mapThickness.keyAt(i).makeLower() == "thickness")
			{
				double dThickness = mThicknessI.getDouble("Thickness");
				if (dThickness == eZone.dH())
				{
					if (mThicknessI.hasInt("exposed"))
					{ 
						// there is a definition for exposed
						int iExposedMap = mThicknessI.getInt("exposed");
						if (iExposed == iExposedMap)
						{ 
							mThickness = mThicknessI;
							break;
						}
					}
					else
					{ 
						// no definition for exposed
						// it is valid for both types
						mThickness = mThicknessI;
						break;
					}
				}
			}
		}//next i

		if (mThickness.length()>0)
		{
			String k;
			Map m = mThickness;//.getMap("SubNode[]");
			
			k = "X1";		if (m.hasDouble(k))	_dX1 = m.getDouble(k);
			k = "Y1";		if (m.hasDouble(k))	_dY1 = m.getDouble(k);
			k = "X2";		if (m.hasDouble(k))	_dX2 = m.getDouble(k);
			k = "Y2";		if (m.hasDouble(k))	_dY2 = m.getDouble(k);
			k = "Y3";		if (m.hasDouble(k))	_dY3 = m.getDouble(k);
		}
//
		if (dX1 != 0 || dY1 != 0 || dX2 != 0 || dY2 != 0 || dY3 != 0)
		{
			// get the values from the properties if any of properties !=0
			_dX1 = dX1;
			_dY1 = dY1;
			_dX2 = dX2;
			_dY2 = dY2;
			_dY3 = dY3;
		}
	}
// xml does not exist	
	else
	{ 
		_dX1 = dX1;
		_dY1 = dY1;
		_dX2 = dX2;
		_dY2 = dY2;
		_dY3 = dY3;
	}
	
	
//	if (bDebug)
//	{ 
//		_Pt0 = el.ptOrg();
//		return;
//	}
	
//End Read Settings//endregion 
	
//region envelope plane profile of the purlin, plate intersetion
	Body bmBody = bm.envelopeBody(true, true);
	Body bmRealBody = bm.realBody();
// envelope profile 
	// ptOrgZone is located at the side of the zone closer to the zone 0
	// vecZZone points away from the zone 0
	Point3d ptOrgZone = eZone.ptOrg();
	ptOrgZone.vis(2);
	Vector3d vecZZone = eZone.vecZ();
	vecZZone.vis(ptOrgZone, 1);
	
	// 2 points of 2 sides of the zone
	Point3d ptSide1 = ptOrgZone + vecZZone * dEps;
	Point3d ptSide2 = ptOrgZone + vecZZone * (eZone.dH() - dEps);
	
	Plane pn1(ptSide1, vecZZone);
	Plane pn2(ptSide2, vecZZone);
	PlaneProfile ppPn1 = bmRealBody.getSlice(pn1);
	PlaneProfile ppPn2 = bmRealBody.getSlice(pn2);
//	ppPn1.vis(3);
//	ppPn2.vis(3);
	CoordSys csZone = eZone.coordSys();
	PlaneProfile ppPn12(csZone);
	ppPn12.unionWith(ppPn1);
	ppPn12.unionWith(ppPn2);
	ppPn12.vis(2);
//return;
// apply dimensions _dX1,_dY1
	LineSeg lSeg = ppPn12.extentInDir(vecXWall);
	double dXSeg = abs(vecXWall.dotProduct(lSeg.ptStart()-lSeg.ptEnd()));
	double dYSeg = abs(vecYWall.dotProduct(lSeg.ptStart()-lSeg.ptEnd()));
	lSeg.vis(3);
	// bottom rectangle
	Point3d pt1 = lSeg.ptStart() - vecXWall * _dX1;
	Point3d pt2 = lSeg.ptEnd() + vecXWall * _dX1;
	// pt1 bottom, pt2 top
	if (pt2.dotProduct(vecYWall) < pt1.dotProduct(vecYWall))
	{ 
		Point3d pt = pt1;
		pt1 = pt2;
		pt2 = pt;
	}
	pt2 += vecYWall * _dY1;// vertical
	PLine plRec;
	plRec.createRectangle(LineSeg(pt1 - vecYWall * _dY3, pt2), vecXWall, vecYWall);
	
	plRec.vis(5);
	pt1.vis(2);
	// top rectangle
	Point3d pt1_ = lSeg.ptStart() - vecXWall * _dX2;
	Point3d pt2_ = lSeg.ptEnd() + vecXWall * _dX2;
	if (pt1_.dotProduct(vecYWall) > pt2_.dotProduct(vecYWall))
	{ 
		pt2_ += (dYSeg+_dY1) * vecYWall;// vertical
		pt1_ += _dY1 * vecYWall;
	}
	else
	{ 
		pt1_ += (dYSeg+_dY1) * vecYWall;// vertical
		pt2_ += _dY1 * vecYWall;
	}
	pt2_ += vecYWall * (_dY2 - _dY1);
	
	PLine plRec_;
	plRec_.createRectangle(LineSeg(pt1_, pt2_), vecXWall, vecYWall);
	plRec_.vis(2);
	
	PlaneProfile ppCut(csZone);
	ppCut.joinRing(plRec, false);// bottom rectangle
	ppCut.joinRing(plRec_, false);// top rectangle
	ppCut.vis(3);
// in PLine
	// cutting pline
	PLine plCuts[] = ppCut.allRings(true, false);
	if (plCuts.length()>1 || plCuts.length()<1)
	{ 
		reportMessage(TN("|unexpected error|"));
		eraseInstance();
		return;
	}
	PLine plCut = plCuts[0];
	
//End envelope plane profile of the purlin, plate intersetion//endregion 

//region find the plates to be intersected by the purlin and do the intersection
	
//	Display dp(2);

	for (int i=0;i<gbs.length();i++) 
	{ 
		Sheet sh=(Sheet)gbs[i];
		if(!sh.bIsValid())
		{ 
			continue;
		}
		// check if pfette 
		
		PLine plShEnvelope = sh.plEnvelope();
		PlaneProfile ppShEnvelope(plShEnvelope);
		ppShEnvelope.intersectWith(ppCut);
		plShEnvelope.vis(2);
		if(ppShEnvelope.area()<dEps)
		{ 
			continue;
		}
		
//		Body shBody = sh.envelopeBody(true, true);
//		if(!bmBody.hasIntersection(shBody))
//		{ 
//			continue;
//		}
	// plate is intersected
		Point3d ptCenSh = sh.ptCenSolid();
		Vector3d vecXSh = sh.vecX();
		Vector3d vecYSh = sh.vecY();
		Vector3d vecZSh = sh.vecZ();
		double dH = sh.dH();// dimension in vecZ
		vecXSh.vis(ptCenSh, 1);
		vecYSh.vis(ptCenSh, 3);
		vecZSh.vis(ptCenSh, 150);
		CoordSys cs(sh.coordSys());

		// cut sheet 
		if(!bDebug)
		{ 
			Sheet shSplited[] = sh.joinRing(plCut, true);
			if(shSplited.length()>0)
			{ 
				// sheet is cutted into multiple pieces
			}
		}
		else
		{ 
			// bDebug
			PLine plSheet = sh.plEnvelope(ptCenSh);
			PlaneProfile ppSheet(cs);
			ppSheet.joinRing(plSheet, false);
			ppSheet.subtractProfile(ppCut);
			ppSheet.vis(1);
		}
	}//next i
	
//End find the plates intersected by the purlin//endregion 

//region recursive way
	if (sNoYes.find(sSubseqZone) == 1 && abs(nZone) < 5)
	{ 
		// yes is selected and nZone [-4;4]
		int iZone = nZone;
		if (nZone < 0)
		{ 
			iZone -= 1;
		}
		else
		{ 
			iZone += 1;
		}
		ElemZone eZone = el.zone(iZone);
		if (eZone.dH() >dEps && abs(iZone) <= 5)
		{ 
			nZone.set(iZone);
			// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;	
						
			gbsTsl.append(bm);
			entsTsl.append(el);
			
			// each zone will add the offset for the subsequent zone
			nProps.append(nZone);
			
			dProps.append(dX1 + dOffset);
			// calculate Y1
			if (dY2 > dY1)
			{ 
//				if(dY1>dOffset)
				{ 
					dProps.append(dY1 - dOffset);
				}
//				else
//				{ 
//					dProps.append(0);
//				}
			}
			else
			{ 
				dProps.append(dY1 + dOffset);
			}
			
			dProps.append(dX2 + dOffset);
			dProps.append(dY2 + dOffset);
			dProps.append(dY3 + dOffset);
			dProps.append(dOffset);
			sProps.append(sSubseqZone);
			
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}
	}

//End recursive way//endregion 

	eraseInstance();
	return;
#End
#BeginThumbnail
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
)HH`****`/__9



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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End