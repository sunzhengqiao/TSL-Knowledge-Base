#Version 8
#BeginDescription
This tsl converts solids into beams and/or solids into free drills

#Versions
Version 1.0 02.06.2023 HSB-19105 Initial version of CSG-Converter to convert solids into beams with drills
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.0 02.06.2023 HSB-19105 Initial version of CSG-Converter to convert solids into beams with drills , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities to be converted and the appropriate painter definitions
/// </insert>

// <summary Lang=en>
// This tsl converts solids into beams and/or solids into free drills
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "CSG-Converter")) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	
	String tDisabledEntry = T("<|Disabled|>");
	String tBySelection = T("<|bySelection|>");
	String sDefaultBeam = T("|Solid To Beam|");
	String sDefaultDrill = T("|Solid To Drill|");
	
//end Constants//endregion

//region Painters
// Get or create default painter definition
	String sPainterCollection = "TSL\\Conversion\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)
			{
				sPainters.append(name);
			}

				
		}		 
	}//next i

	{ 
		String name = sDefaultBeam;
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Solid3d");
					pd.setFilter("LayerName = 'jmd_gl28' or LayerName = 'jmd_gl75' or Contains(LayerName,'Z0')");
					pd.setFormat("Beam");
				}
			}				
			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}
		}		
	}

	{ 
		String name = sDefaultDrill;
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Solid3d");
					pd.setFilter("LayerName = 'jmd_coulage' or LayerName = 'jmd_M16' or Contains(LayerName,'jmd_M20') or Contains(LayerName,'jmd_ed_m20_32')");
					pd.setFormat("Drill");
				}
			}				
			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}	
		}		
	}

	sPainters.sorted();
	sPainters.insertAt(0, tBySelection);	
	sPainters.insertAt(0, tDisabledEntry);

//endregion

//region Properties
	if (sPainters.length()<1)
	{ 
		reportNotice("\n**** " + scriptName() + " ****");
		reportNotice("\n" + T("|This tool is based on painter definitions of groups, but this drawing does not contain any valid definition.|"));
		reportNotice("\n" + T("|Please create painter definitions based on groups and try again.|"));
		reportNotice("\n" + T("|The definitions need to be created in folder named| ") + sPainterCollection);
		eraseInstance();
		return;		
	}


category = T("|Filter|");
	String sPainterName=T("|Beam Conversion|");	
	PropString sPainter(nStringIndex++, sPainters, sPainterName,2);	
	sPainter.setDescription(T("|Defines the painter definition which will be used to filter solids to be converted to beams|"));
	sPainter.setCategory(category);

	String sPainterDrillName=T("|Drill Conversion|");	
	PropString sPainterDrill(nStringIndex++, sPainters, sPainterDrillName,3);	
	sPainterDrill.setDescription(T("|Defines the painter definition which will be used to filter solids to be converted to drills|"));
	sPainterDrill.setCategory(category);


category = T("|Beam Property Mapping|");
	String sPropMappings[] = {tDisabledEntry, T("|Name|"), T("|Material|"), T("|Grade|"), T("|Information|"), T("|Label|"), T("|SubLabel|"), T("|SubLabel2|")};

	String sSeparatorName=T("|Separator|");	
	PropString sSeparator(nStringIndex++, "_", sSeparatorName);	
	sSeparator.setDescription(T("|Defines the Separator to identify tokens within the layer name|"));
	sSeparator.setCategory(category);

	String sToken1Name=T("|Token| 1");	
	PropString sToken1(nStringIndex++, sPropMappings, sToken1Name);	
	sToken1.setDescription(T("|Defines the Token| 1"));
	sToken1.setCategory(category);
	
	String sToken2Name=T("|Token| 2");	
	PropString sToken2(nStringIndex++, sPropMappings, sToken2Name);	
	sToken2.setDescription(T("|Defines the Token| 2"));
	sToken2.setCategory(category);

	String sToken3Name=T("|Token| 3");	
	PropString sToken3(nStringIndex++, sPropMappings, sToken3Name);	
	sToken3.setDescription(T("|Defines the Token| 3"));
	sToken3.setCategory(category);	
//
//category = T("|General|");
//
//	String sHideName=T("|Set source invisible|");	
//	PropString sHide(nStringIndex++, sNoYes, sHideName,1);	
//	sHide.setDescription(T("|Defines wether a successfully converted blockreference will be invisible after conversion (use _HSB_SHOWOBJECTS to unhide)|"));
//	sHide.setCategory(category);
//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	// selection mode: either entities get filtered by painter or user selects explicitly the items to be converted
		int bSelectBeamSolids = sPainter==tBySelection;
		int bSelectDrillSolids = sPainterDrill==tBySelection;
		int bSelectSolids = (sPainterDrill != tDisabledEntry && !bSelectDrillSolids) || (sPainter != tDisabledEntry && !bSelectBeamSolids);		
		Entity entsAll[0];
		
	// prompt for entities: _Entity will be filtered by the corresponding painters
		if (bSelectSolids)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select solids|"), Entity());
			if (ssE.go())
				ents.append(ssE.set());
				
			for (int i=0;i<ents.length();i++) 
			{ 
				Body bd = ents[i].realBody(); 
				if (bd.isNull())
				{ 
					continue;//reportNotice("\n" + ents[i].typeName() + " " + ents[i].handle() + T(" |is not a solid|"));
				}
				_Entity.append(ents[i]);
				entsAll.append(ents[i]);
			}//next i	
			
		// reduce set if bySelection is active
			if (bSelectBeamSolids)
			{ 
				PainterDefinition pd(sPainterCollection+sPainterDrill);
				_Entity= pd.filterAcceptedEntities(_Entity);
				entsAll= pd.filterAcceptedEntities(entsAll);
			}
			else if (bSelectDrillSolids)
			{ 
				PainterDefinition pd(sPainterCollection+sPainter);
				_Entity= pd.filterAcceptedEntities(_Entity);
				entsAll= pd.filterAcceptedEntities(entsAll);
			}				
		}
		
	// prompt individual selection of beam solids
		if (bSelectBeamSolids)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select solids for beam conversion|"), Entity());
			if (ssE.go())
				ents.append(ssE.set());	
				
		// remove if in other selection set or not a solid		
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				Body bd = ents[i].realBody();
				if (entsAll.find(ents[i])>-1 || bd.isNull())
					ents.removeAt(i);
				else
					entsAll.append(ents[i]);
			}//next i
	
			_Map.setEntityArray(ents, false, "Solid2Beam[]", "", "Solid2Beam");
		}
	// prompt individual selection of drill solids
		if (bSelectDrillSolids)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select solids for drill conversion|"), Entity());
			if (ssE.go())
				ents.append(ssE.set());	
			
		// remove if in other selection set or not a solid		
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				Body bd = ents[i].realBody();
				if (entsAll.find(ents[i])>-1 || bd.isNull())
					ents.removeAt(i);
				else
					entsAll.append(ents[i]);
			}//next i
				
			_Map.setEntityArray(ents, false, "Solid2Drill[]", "", "Solid2Drill");
		}		

	// prompt for beams if either already converted or exist
		if (sPainterDrill!=tDisabledEntry && sPainter==tDisabledEntry)
		{ 
		// prompt for beams
			Beam beams[0];
			PrEntity ssE(T("|Select beams|"), Beam());
			if (ssE.go())
				_Beam.append(ssE.beamSet());					
		}


		if (bDebug)
			_Pt0 = getPoint();

		return;
	}			
//endregion 

//region Filter / Get entities
	int bCreateBeams, bCreateDrills;		
	Entity entBeams[0],entDrills[0];
	if (sPainter!=tDisabledEntry && sPainter!=tBySelection)
	{
		PainterDefinition pd(sPainterCollection+sPainter);
		entBeams= pd.filterAcceptedEntities(_Entity);
		bCreateBeams = entBeams.length() > 0;
	}
	else if (sPainter==tBySelection)
	{ 
		entBeams = _Map.getEntityArray("Solid2Beam[]", "", "Solid2Beam");
		bCreateBeams = entBeams.length() > 0;
	}
	
	if (sPainterDrill!=tDisabledEntry && sPainterDrill!=tBySelection)
	{
		PainterDefinition pd(sPainterCollection+sPainterDrill);
		entDrills= pd.filterAcceptedEntities(_Entity);
		bCreateDrills = entDrills.length() > 0;
	}	
	else if (sPainterDrill==tBySelection)
	{ 
		entDrills = _Map.getEntityArray("Solid2Drill[]", "", "Solid2Drill");
		bCreateDrills = entDrills.length() > 0;
	}
	
	if (!bCreateBeams && bCreateDrills && _Beam.length()<1)
	{ 
		Entity ents[] = Group().collectEntities(true, Beam(), _kModelSpace);
		for (int i=0;i<ents.length();i++)
		{ 
			Beam b = (Beam)ents[i];
			if (b.bIsValid())
				_Beam.append(b);
		}
		bCreateDrills = _Beam.length() > 0;
	}

	Beam beams[0];beams = _Beam;


	
	String msg = "\n**** " + scriptName() + " ****";
	if (bCreateBeams)
		msg += "\n" + entBeams.length() + T(" |solids to be converted into beams|");
	if (bCreateDrills)
		msg += "\n" + entDrills.length() + T(" |solids to be converted into drills|");	
	if (beams.length()>0)
		msg += "\n" + beams.length() + (beams.length()==1?T(" |existing beam selected to add drills|"):T(" |existing beams selected to add drills|"));
	reportNotice(msg);

	String sProperties[] = { sToken1, sToken2, sToken3};
//endregion 

//region Convert solids to beam	
	int numBeam;
	for (int i=0;i<entBeams.length();i++) 
	{ 
		Entity e = entBeams[i];
		Point3d pts[] = e.gripPoints();
		Body bd = e.realBody(); 
		String layerName = e.layerName();
		
		String tokens[0];
		if (sSeparator.length()>0 && layerName.find(sSeparator,0,false)>-1)
			tokens= layerName.tokenize(sSeparator);
		
		
	// exclude non solids, cylinders and descriptive solids
		if (bd.isNull() || pts.length()==2)
		{
			continue;
		}
		
	// check the entity has a conversion tag which is valid
		Map m = e.subMapX("CSG-Conversion");
		Entity ec = m.getEntity("bm");
		if (ec.bIsValid() && sPainter!=tBySelection) // allow creation when in bySelection
		{
			reportNotice("\n" + T("|Solid already converted to beam| ") + e.handle() + "->" + ec.handle());
			continue;
		}

		if (bDebug)
		{ 
			bd.vis(2);

		}
		else
		{ 
			Beam bm;
			bm.dbCreate(bd, true);
			if (bm.bIsValid())
			{ 
			// store converted entity against source	
				m.setEntity("bm", bm);
				e.setSubMapX("CSG-Conversion", m); 
				
				bm.setColor(e.color());	
				bm.assignToLayer(layerName);	
				
				
			// property mapping	
				for (int x=0;x<sProperties.length();x++) 
				{ 
					String property = sProperties[x];
					int n = sPropMappings.findNoCase(property,-1)-1;
					
					if (n == 0 && tokens.length()>x)bm.setName(tokens[x]);
					else if (n == 1 && tokens.length()>x )bm.setMaterial(tokens[x]);
					else if (n == 2 && tokens.length()>x)bm.setGrade(tokens[x]);
					else if (n == 3 && tokens.length()>x)bm.setInformation(tokens[x]);
					else if (n == 4 && tokens.length()>x)bm.setLabel(tokens[x]);
					else if (n == 5 && tokens.length()>x)bm.setSubLabel(tokens[x]);
					else if (n == 6 && tokens.length()>x)bm.setSubLabel2(tokens[x]);
				}//next x
	
				beams.append(bm);
				numBeam++;
	
			}
		}		 
	}//next i

	if (numBeam>0)
		reportNotice("\n" + numBeam + T(" |beams created|"));

	if (beams.length()<1)
	{ 
		return;
	}

//endregion 

//region Convert solids to drill

// create TSL
	TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
	Entity entsTsl[] = {};		Point3d ptsTsl[3];
	int nProps[]={};			double dProps[1];				String sProps[]={};
	Map mapTsl;	

	reportNotice("\n" + T(" |Analysing drills| (")+entDrills.length() + T(") |Please wait...|"));
			
	int numDrill;
	for (int i=0;i<entDrills.length();i++) 
	{ 
		Entity e = entDrills[i];
		Point3d pts[] = e.gripPoints();
		Body bd = e.realBody(); 
		String layer = e.layerName();
		
	// exclude non solids, cylinders and descriptive solids
		if (bd.isNull())
		{
			continue;
		}

//	// check the entity has a conversion tag which is valid
//		Map m = e.subMapX("CSG-Conversion");
//		Entity ec = m.getEntity("tsl");
//		if (ec.bIsValid()&& sPainterDrill!=tBySelection) // allow creation when in bySelection
//		{
//			reportNotice("\n" + T("|Solid already converted to tsl| ") + e.handle() + "->" + ec.handle());
//			continue;
//		}



	// if the solid doesn't have only two grips representing the axis go for intermediate beam conversion to get length and axis	
		double diameter, dL;
		Vector3d vecX;
		if (pts.length()!=2)
		{ 
			Beam bm;
			bm.dbCreate(bd, true);
			if (bm.bIsValid())
			{ 
				vecX = bm.vecX();
				dL = bm.solidLength();
				pts.setLength(0);
				pts.append(bm.ptCen() - bm.vecX() * .5 * dL);
				pts.append(bm.ptCen() + bm.vecX() * .5 * dL);
				
				diameter = bm.dW();
				bm.dbErase();
			}
		}
	// Derive drill properties	
		else
		{ 
			vecX= pts.last() - pts.first();
			dL = vecX.length();
			vecX.normalize();
			double vol = bd.volume();
			diameter = sqrt(vol / (dL * 3.1415926535897932384626433))*2; 
		}

		Point3d ptRef; ptRef.setToAverage(pts);
		PLine pl(pts.first(), pts.last()); 
		dProps[0] = round(diameter);


	// Find beams which intersect the solid
		Beam bmDrills[] = bd.filterGenBeamsIntersect(beams);
		if (bmDrills.length()>0)
		{ 
			GenBeam gbsTsl[0];
			for (int j=0;j<bmDrills.length();j++) 
				gbsTsl.append(bmDrills[j]); 

			ptsTsl[0] = ptRef;
			ptsTsl[1] = pts.first();
			ptsTsl[2] = pts.last();
			
			
			if (bDebug)
				pl.vis(3);				
			else
			{
				tslNew.dbCreate("FreeDrill" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				if (tslNew.bIsValid())
				{
//				// store converted entity against source	
//					m.setEntity("tsl", tslNew);
//					e.setSubMapX("CSG-Conversion", m); 
					
					
					numDrill++;
				}
			}
		}
		else
		{ 
			pl.vis(1);
		}		
	}//next i
	if (numDrill>0)
		reportNotice("\n" + numDrill + T(" |drills created|"));


	if (!bDebug)
		eraseInstance();
	
//endregion 
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="487" />
        <int nm="BREAKPOINT" vl="352" />
        <int nm="BREAKPOINT" vl="386" />
        <int nm="BREAKPOINT" vl="369" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19105 Initial version of CSG-Converter to convert solids into beams with drills" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/2/2023 10:16:32 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End