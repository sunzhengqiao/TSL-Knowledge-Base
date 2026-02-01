#Version 8
#BeginDescription
#Versions
1.7 20.02.2023 HSB-18017: make sure the tsl is updated when language is changed 
1.6 25.11.2022 HSB-17177: add "solid quality" of klhDisplay
1.5 21.11.2022 HSB-17114:If "klhCoating" tsl instances are found, make sure to export their text solid for coating side
1.4 27.09.2022 HSB-16663: If "klhDisplay" tsl instances are found, make sure to export their solid for graindirection
Version 1.3 13.01.2022 HSB-14356 new property to export to SAT or STL format ,
Version 1.2 22.12.2021 HSB-14252 new mode to export CSG model

This TSL creates a sat file of all selected solid entities
(beams, sheets, tsl's with solid representation etc.)






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates a sat file of all selected solid entities
/// (beams, sheets, tsl's with solid representation etc.)
/// </summary>

/// <insert Lang=en>
/// Select entities and press enter. The file will be written to the dwg path
/// If all entities belong to the same element
/// </insert>

/// History
// #Versions
// 1.7 20.02.2023 HSB-18017: make sure the tsl is updated when language is changed Author: Marsel Nakuci
// 1.6 25.11.2022 HSB-17177: add "solid quality" of klhDisplay  Author: Marsel Nakuci
// 1.5 21.11.2022 HSB-17114:If "klhCoating" tsl instances are found, make sure to export their text solid for coating side Author: Marsel Nakuci
// 1.4 27.09.2022 HSB-16663: If "klhDisplay" tsl instances are found, make sure to export their solid for graindirection Author: Marsel Nakuci
// 1.3 13.01.2022 HSB-14356 new property to export to SAT or STL format , Author Thorsten Huck
// 1.2 22.12.2021 HSB-14252 new mode to export CSG model , Author Thorsten Huck
///<version  value="1.1" date="29feb12" author="th@hsbCAD.de">automatic element naming if applicable, new property file name</version>
///<version  value="1.0" date="26apr10" author="th@hsbCAD.de">initial</version>


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	Vector3d vec(1,1,1);
//end Constants//endregion


//region Properties
	String sFileNameName=T("|File Name|");	
	PropString sFileName(nStringIndex++, dwgName(), sFileNameName);	
	sFileName.setDescription(T("|Defines the file name.|") + 
		T(" |The specified may contain format expressions such as @(Name:D\"\") which will create individual files named after the resolving.|"));
	sFileName.setCategory(category);

	String sSolidModeName=T("|Mode|");	
	String sSolidModes[] = { T("|BREP|"), T("|CSG|")};
	PropString sSolidMode(nStringIndex++, sSolidModes, sSolidModeName);	
	sSolidMode.setDescription(T("|Defines the solid model mode.|") + 
		T(" |BREP (Boundary Representation) describes only the oriented surface of a solid as a data structure composed of vertices, edges, and faces.|") + 
		T(" |CSG (Constructive Solid Geometry) describes a solid represented as a Boolean expression of primitive solid objects of a simpler structure.|") + 
		T(" |Using the CSG mode you can (optional) select solids to be used as subtraction of the model|") + 
		T(" |CSG mode resolves certain tools automatically.|"));
	sSolidMode.setCategory(category);
	
	String sFormatName=T("|Format|");
	String sFormats[] = { T("|SAT|"), T("|STL|")};
	PropString sFormat(nStringIndex++, sFormats, sFormatName);	
	sFormat.setDescription(T("|Defines the export format|") + T(", |SAT = Acis Solid, STL = Standard Tesselation Language (3D Printing)|"));
	sFormat.setCategory(category);
//End Properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
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
			showDialog();
		
		int nSolidMode = sSolidModes.find(sSolidMode);
		
	// prompt for entities
		Entity solids[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			solids.append(ssE.set());
	
	
	// remove non solids
		for (int i=solids.length()-1; i>=0 ; i--) 
			if (solids[i].realBody().volume()<pow(dEps,3))
			{
			// HSB-16663:HSB-17114
				TslInst tsl = (TslInst)solids[i];
				if(tsl.bIsValid())
				{ 
					if (tsl.scriptName()=="klhDisplay" || tsl.scriptName()=="klhCoating")
					{
					// keep it for export
						continue;
					}
				}
				solids.removeAt(i); 		
			}
		
		if (nSolidMode==1)
		{ 
			Entity ents[0];
			// TODO allow additional solids to be subtracted
			if (0)
			{ 
				ssE=PrEntity (T("|Select subtraction entities|"), Entity());
				if (ssE.go())
					ents.append(ssE.set());				
			}
	
		// remove non solids
			for (int i=ents.length()-1; i>=0 ; i--) 
				if (ents[i].realBody().volume()<pow(dEps,3))
					ents.removeAt(i); 
			//_Map.setEntityArray(ents, false, "Entity[]", "", "Entity");

		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = sLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[1];
			mapTsl.setInt("mode", 1);
			
			TslInst breps[0];
			for (int i=0;i<solids.length();i++) 
			{ 
				entsTsl[0]= solids[i];
				ptsTsl[0] = solids[i].realBody().ptCen();
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
				
			//	a csg instance has been created
				if (tslNew.bIsValid())
				{ 
					String exportFileName = tslNew.map().getString("exportFileName");

					if (exportFileName.length()>0)
					{ 
						Entity exports[] = {tslNew};
						Map m = tslNew.map();
						Entity entGrain;
						if (m.hasBody("GrainBody"))
						{ 
							entGrain= m.dbCreateBodyEntity("GrainBody", -1, _kBTMassElement);
							if (entGrain.bIsValid())
								exports.append(entGrain);
						}
	
						Entity().createRealBodySatFile(vec, "", exports, exportFileName);
						reportMessage("\n" + scriptName() +" "+ exports.length() + T(" |solids exported to| ") + exportFileName);
						if (entGrain.bIsValid())
							entGrain.dbErase();
						tslNew.dbErase();						
					}
					else
						breps.append(tslNew);
				}
			}//next i
			
			
		// create TSL
			entsTsl.setLength(0);
			for (int i=0;i<breps.length();i++) 
				entsTsl.append(breps[i]); 
			int nProps[]={};			double dProps[]={};				String sProps[]={sFileName, sSolidModes[0]};
			mapTsl.setInt("mode", 0);			
			if(entsTsl.length()>0)
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				

			//_Map.setEntityArray(ents, false, "Entity[]", "", "Entity");	
			
			eraseInstance();
		}
		else
		{ 
			_Entity.append(solids);
		}
	
		
		return;
	}	
// end on insert	__________________//endregion

// mode
	int nMode = _Map.getInt("mode"); // 0 = export, 1= a tsl instance representing a solid with other CSG solids
	
	if (_Entity.length()<1)
	{ 
		eraseInstance();
		return;
	}
	
// HSB-16663: make sure property is set to Yes for solid generation for klhDisplay
// get all klhDisplay TSLs
	TslInst tslKlhDisplays[0];
	int nGrainSchalters[0], nArrowSchalters[0], nSolidQualities[0];
	TslInst tslKlhCoatings[0];
	int nSolidTexts[0];
	for (int ient=0;ient<_Entity.length();ient++) 
	{ 
		TslInst tsl=(TslInst)_Entity[ient];
		if (!tsl.bIsValid())continue;
		if (tsl.scriptName() != "klhDisplay" && tsl.scriptName() != "klhCoating")continue;
		if(tsl.scriptName() == "klhDisplay")
		{ 	
			tslKlhDisplays.append(tsl);
		// remember properties
			// HSB-18017: make sure the tsl is updated when language is changed
			int nIndexTest=sNoYes.find(tsl.propString(3));
			if(nIndexTest<0)tsl.recalcNow();
			nGrainSchalters.append(sNoYes.find(tsl.propString(3)));
			nArrowSchalters.append(sNoYes.find(tsl.propString(4)));
			nSolidQualities.append(sNoYes.find(tsl.propString(8)));
		// set to yes for solid generation
			tsl.setPropString(3,sNoYes[1]);
			tsl.setPropString(4,sNoYes[1]);
			tsl.setPropString(8,sNoYes[1]);
			tsl.recalcNow();
		}
		else if(tsl.scriptName() == "klhCoating")
		{ 
			// HSB-18017: make sure the tsl is updated when language is changed
			int nIndexTest=sNoYes.find(tsl.propString(7));
			if(nIndexTest<0)tsl.recalcNow();
			tslKlhCoatings.append(tsl);
			nSolidTexts.append(sNoYes.find(tsl.propString(7)));
			tsl.setPropString(7,sNoYes[1]);
			tsl.recalcNow();
		}
	}//next ient


// BREP
	if (nMode==0)
	{
		int nFormat = sFormats.find(sFormat);
		String sThisFileName =  _ThisInst.formatObject(sFileName);	
	
	// make sure file does not contain any forbidden characters
		char chars[] ={ '.', ';',':','\\', '/', '&', '"'};
		for (int i=0;i<chars.length();i++) 
		{  
			int x = sThisFileName.find(chars[i], 0);
			int cnt;
			while(x>-1 && cnt<sThisFileName.length())
			{ 
				String left = sThisFileName.left(x);
				String right= sThisFileName.right(sThisFileName.length()-x-1);
				sThisFileName = left + "_" + right;		
				x = sThisFileName.find(chars[i], 0);
				cnt++;
			}			 
		}//next i
		
		if (sThisFileName.find("\\",0)<0)
			sThisFileName = _kPathDwg + "\\" + sThisFileName;		

		if (nFormat==0)
			Entity().createRealBodySatFile(vec, "", _Entity, sThisFileName);
		else if (nFormat==1)
			Entity().createRealBodyStlFile(vec, "", _Entity, sThisFileName);
		
		reportMessage("\n" + scriptName() +" "+ _Entity.length() + T(" |solids exported to| ") + sThisFileName);
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
			TslInst t = (TslInst)_Entity[i];
			if (t.bIsValid() && t.scriptName() == scriptName())
				t.dbErase();
			
		}//next i
		
		// HSB-16663: change properties back to original value
		for (int i=0;i<tslKlhDisplays.length();i++) 
		{ 
			TslInst tsl= tslKlhDisplays[i];
			tsl.setPropString(3,sNoYes[nGrainSchalters[i]]);
			tsl.setPropString(4,sNoYes[nArrowSchalters[i]]);
			tsl.setPropString(8,sNoYes[nSolidQualities[i]]);
			tsl.recalcNow();
		}//next i
	// HSB-17114
		for (int i=0;i<tslKlhCoatings.length();i++) 
		{ 
			TslInst tsl= tslKlhCoatings[i];
			tsl.setPropString(7,sNoYes[nSolidTexts[i]]);
			tsl.recalcNow();
		}//next i
		
		eraseInstance();
		return;
	}

// CSG
	else if (nMode==1)
	{ 
		Entity entDef = _Entity[0];
		Body bd = entDef.realBody();
		Entity tools[] = _Map.getEntityArray("Entity[]", "", "Entity");	
		int bCreateAsOne;
		String sThisFileName = entDef.formatObject(sFileName);
		if (sThisFileName.length()<1)
			sThisFileName = sFileName;
		
	// make sure file does not contain any dots
		int x = sThisFileName.find(".", 0);
		int cnt;
		while(x>-1 && cnt<sThisFileName.length())
		{ 
			String left = sThisFileName.left(x);
			String right= sThisFileName.right(sThisFileName.length()-x-1);
			sThisFileName = left + "_" + right;		
			x = sThisFileName.find(".", 0);
			cnt++;
		}
	
		if (sThisFileName.find("\\",0)<0)
			sThisFileName = _kPathDwg + "\\" + sThisFileName;
				
		GenBeam gb = (GenBeam)entDef;
		Sip sip = (Sip)gb;
		if (gb.bIsValid())
		{ 
		//region FileName resolving
		// Check if this instance will create an individual sat export by fromat expression
			String variables[] = gb.formatObjectVariables();			
			for (int i=0;i<variables.length();i++) 
			{ 
				if (sFileName.find("@("+variables[i],0,false)>-1)
				{ 
					bCreateAsOne = true;
					break;
				}
			}//next i				
		//endregion 	


			AnalysedTool tools[] = gb.analysedTools();
			for (int i=0;i<tools.length();i++) 
			{  
				ToolEnt tent = tools[i].toolEnt();
				if (bDebug)
				{ 
					TslInst t = (TslInst)tent;
					if (t.bIsValid())
						reportNotice("\n" + t.scriptName()+ " " + tools[i].toolType() + " in loop " + _kExecutionLoopCount);					
				}

				
				Map mapAT = AnalysedTool().convertToMap(tools[i]);
				Map map = mapAT.getMap(0).getMap("AnalysedTool"); 
			
			// find potential mapX entries which specify a tool
				Map subMaps = map.getMap("MapX[]");
				for (int j=0;j<subMaps.length();j++) 
				{ 
					Map m = subMaps.getMap(j);
					for (int jj=0;jj<m.length();jj++) 
					{ 
						if (m.hasBody(jj))
						{ 
							Entity ent = m.dbCreateBodyEntity(m.keyAt(jj), -1, _kBT3dSolid);
							if (!ent.bIsValid())
								ent = m.dbCreateBodyEntity(m.keyAt(jj), -1, _kBTSubDMesh);
							if (ent.bIsValid())
							{ 
								Body bdX =ent.realBody();
								bdX.vis(4);
								//reportNotice("\n	" + jj+ " " + bdX.volume());
								bd.addTool(SolidSubtract(bdX, _kSubtract));
								ent.dbErase();								
							}	
						} 	 
					}//next jj
				}//next j
			}//next i
			
//			FreeProfile fps[] = gb.getToolsOfTypeFreeProfile();
//			for (int i=0;i<fps.length();i++) 
//			{ 
//				FreeProfile fp= fps[i]; 
//				String keys[] = fp.subMapXKeys();
//				for (int j=0;j<keys.length();j++) 
//				{ 
//					Map m = fp.subMapX(keys[j]);
//					for (int jj=0;jj<m.length();jj++) 
//					{ 
//						if (m.hasBody(jj))
//						{ 
//							Body bdX = m.getBody(jj);
//							//bdX.vis(3);
//							bd.addTool(SolidSubtract(bdX, _kSubtract));
//						} 	 
//					}//next jj	 
//				}//next j				 
//			}//next i			
		}

		if (bDebug)bd.transformBy(_ZW * U(300));
		Display dp(0);
		dp.draw(bd);
		
		if (bCreateAsOne && sThisFileName.length()>0)
		{ 
			_Map.setString("exportFileName", sThisFileName );
			
			// TODO implement cylinder for grain direction
			if (0 && sip.bIsValid() && !sip.woodGrainDirection().bIsZeroLength())
			{ 
				Vector3d vecDir = sip.woodGrainDirection() * U(75);
				Body bdGrain(sip.ptCen() - vecDir, sip.ptCen() + vecDir, U(10));
				bdGrain.transformBy(sip.vecZ() * sip.dH());
				_Map.setBody("GrainBody", bdGrain);
			}
		}
	}

// HSB-16663: change properties back to original value
	for (int i=0;i<tslKlhDisplays.length();i++) 
	{ 
		TslInst tsl= tslKlhDisplays[i];
		tsl.setPropString(3,sNoYes[nGrainSchalters[i]]);
		tsl.setPropString(4,sNoYes[nArrowSchalters[i]]);
		tsl.setPropString(8,sNoYes[nSolidQualities[i]]);
		tsl.recalcNow();
	}//next i
// HSB-17114
	for (int i=0;i<tslKlhCoatings.length();i++) 
	{ 
		TslInst tsl= tslKlhCoatings[i];
		tsl.setPropString(7,sNoYes[nSolidTexts[i]]);
		tsl.recalcNow();
	}//next i


#End
#BeginThumbnail
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
+*`"@`H`*`"@#_]D`





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
        <int nm="BreakPoint" vl="371" />
        <int nm="BreakPoint" vl="331" />
        <int nm="BreakPoint" vl="247" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18017: make sure the tsl is updated when language is changed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/20/2023 2:38:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17177: add &quot;solid quality&quot; of klhDisplay " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/25/2022 4:03:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17114:If &quot;klhCoating&quot; tsl instances are found, make sure to export their text solid for coating side" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/21/2022 4:05:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16663: If &quot;klhDisplay&quot; tsl instances are found, make sure to export their solid for graindirection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/27/2022 4:38:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14356 new property to export to SAT or STL format" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/13/2022 9:55:25 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14252 new mode to export CSG model" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/22/2021 5:26:17 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End