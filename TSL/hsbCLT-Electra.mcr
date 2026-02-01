#Version 8
#BeginDescription
#Versions
Version 4.11 22.05.2025 HSB-24009: write flag in mapX for rectangular sockets , Author: Marsel Nakuci
Version 4.10 22.04.2025 HSB-23869: Add stereotypes , Author: Marsel Nakuci
Version 4.9 25.10.2024 HSB-22525: Use triangles for the stretching/"edit in place" grips , Author Marsel Nakuci
Version 4.8 09.10.2024 HSB-22525: Use arrow grip shape for "Edit in place" grips; use color 4 to indicate stretch grip , Author Marsel Nakuci
Version 4.7 02.10.2024 HSB-22525: Add command "Edit in place"/"Disable edit in place" , Author Marsel Nakuci
4.6 03.05.2024 HSB-21969: fix when draging grip point Author: Marsel Nakuci
4.5 02.05.2024 HSB-21969: Show reportnotice if no tagging possible Author: Marsel Nakuci
4.4 23/04/2024 HSB-21889: Add command to tag/untag wirechase conduit beamcuts Marsel Nakuci
4.3 16.02.2024 HSB-18037: Add drill function for cable duct Author: Marsel Nakuci
4.2 08.02.2024 HSB-21382: Fix property names to resolve formatting problems Author: Marsel Nakuci
4.1 07.02.2024 HSB-21382: Add grip points as Grip Author: Marsel Nakuci
Version 4.0 11.04.2022 HSB-15172 bugfix wirechase on beveled edges , Author Thorsten Huck
Version 3.9   09.04.2021 
HSB-11456 tool  references purged when moved by base point and linked to an element  , Author Thorsten Huck

version value="3.8" date="26octt2020" author="nils.gregor@hsbcad.com"> 
HSB-9190 Resolve format issue

HSB-8690 Use translated propertyname.
HSB-8690 Show property: Offset between Installations only if used
HSB-8264 new property 'Format' and 3 new context commands have been added to enable the selction of different display texts
HSB-7757 bugfix Hardware components 

DACH
Dieses TSL erzeugt Bearbeitungen für Elektroinstallationen an CLT Panelen
EN
This TSL creates tools of electrical installations on panels













#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 11
#KeyWords CLT;Electrical;Conduit
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt Bearbeitungen für Elektroinstallationen an CLT Panelen
/// </summary>
/// <insert Lang=de>
/// This TSL creates tools of electrical installations on panels
/// </insert>

/// History
// #Versions
// 4.11 22.05.2025 HSB-24009: write flag in mapX for rectangular sockets , Author: Marsel Nakuci
// 4.10 22.04.2025 HSB-23869: Add stereotypes , Author: Marsel Nakuci
// 4.9 25.10.2024 HSB-22525: Use triangles for the stretching/"edit in place" grips , Author Marsel Nakuci
// 4.8 09.10.2024 HSB-22525: Use arrow grip shape for "Edit in place" grips; use color 4 to indicate stretch grip , Author Marsel Nakuci
// 4.7 02.10.2024 HSB-22525: Add command "Edit in place"/"Disable edit in place" , Author Marsel Nakuci
// 4.6 03.05.2024 HSB-21969: fix when draging grip point Author: Marsel Nakuci
// 4.5 02.05.2024 HSB-21969: Show reportnotice if no tagging possible Author: Marsel Nakuci
// 4.4 23/04/2024 HSB-21889: Add command to tag/untag wirechase conduit beamcuts Marsel Nakuci
// 4.3 16.02.2024 HSB-18037: Add drill function for cable duct Author: Marsel Nakuci
// 4.2 08.02.2024 HSB-21382: Fix property names to resolve formatting problems Author: Marsel Nakuci
// 4.1 07.02.2024 HSB-21382: Add grip points as Grip Author: Marsel Nakuci
// 4.0 11.04.2022 HSB-15172 bugfix wirechase on beveled edges , Author Thorsten Huck
// 3.9 09.04.2021 HSB-11456 tool  references purged when moved by base point and linked to an element  , Author Thorsten Huck
///<version value="3.8" date="26oct2020" author="nils.gregor@hsbcad.com"> HSB-9190 Resolve format issue</version>
///<version value="3.7" date="22sept2020" author="david.delombaerde@hsbcad.com"> HSB-8690 Use translated propertyname</version>
///<version value="3.6" date="16sept2020" author="david.delombaerde@hsbcad.com"> HSB-8690 Show property: offset between installation only if used</version>
///<version value="3.5" date="10aug2020" author="thorsten.huck@hsbcad.com"> HSB-8264 typo and description fixed </version>
///<version value="3.4" date="25jul2020" author="thorsten.huck@hsbcad.com"> HSB-8264 new property 'Format' and 3 new context commands have been added to enable the selection of different display texts </version>
///<version value="3.3" date="06jun2020" author="nils.gregor@hsbcad.com"> HSB-7757 bugfix Hardware components </version>
///<version value="3.2" date="03jun2020" author="thorsten.huck@hsbcad.com"> HSB-7757 elevation and assignment corrected if panel belongs to element and UCS not set to WCS </version>
///<version value="3.1" date="27apr20" author="nils.gregor@hsbcad.com"> HSB-7378 bugfix mandatory articlenumber introduced HSB-6579 </version>
///<version value="3.0" date="06mar20" author="nils.gregor@hsbcad.com"> HSB-6579 Link sip to hardware and add instance to dxa</version>
///<version value="2.9" date="20oct17" author="thorsten.huck@hsbcad.com"> auto correction of invalid interdistance for any multiple installation </version>
///<version value="2.8" date="26jul17" author="thorsten.huck@hsbcad.com"> bugfix tolerances </version>
///<version value="2.7" date="10Jun16" author="florian.wuermseer@hsbcad.com"> slotted hole tool corrected </version>
///<version value="2.6" date="23may16" author="thorsten.huck@hsbcad.com"> hardware assignment changed, properties categorized </version>
///<version value="2.5" date="12Jan16" author="thorsten.huck@hsbcad.com"> insertion via catalog entry supports elevation override in the command line </version>
///<version value="2.4" date="12Jan16" author="thorsten.huck@hsbcad.com"> bugfix and display enhancements if diameter or quantity <= 0 to allow wirechase only tooling </version>
///<version value="2.3" date="03jun15" author="thorsten.huck@hsbcad.com"> behavior on copy and split enhanced, bugfix on paneld deleted if element relation is set </version>
///<version value="2.2" date="11may15" author="thorsten.huck@hsbcad.com"> automatic change to element assignment if selected panel has a valid reference </version>
///<version value="2.1" date="24apr15" author="thorsten.huck@hsbcad.com"> automatic element assignment if selected panel has a valid reference to it (enhances copy behaviour) </version>
///<version value="2.0" date="19feb15" author="thorsten.huck@hsbcad.com"> supports finished floor elevation if defined in submap </version>
///<version value="1.9" date="09feb15" author="thorsten.huck@hsbcad.com"> assignment only to relevant panels element fixed </version>
///<version value="1.8" date="30jan15" author="thorsten.huck@hsbcad.com"> rectangular shapes will publish extreme dimensions for i.e. sd_TslRequests, plan text alignment fixed </version>
///<version value="1.7" date="30jan15" author="thorsten.huck@hsbcad.com"> new point dim requests added to be consumed in shopdraw framework by sd_TslRequests </version>
///<version value="1.6" date="29jan15" author="thorsten.huck@hsbcad.com"> Text in element view supports automatic interference test</version>
///<version value="1.5" date="27jan15" author="thorsten.huck@hsbcad.com"> supports baubit export</version>
///<version value="1.3" date="02dec14" author="thorsten.huck@hsbcad.com"> element view text reorganized: quantities > 1 will show interdistance in the format <elevation>:<interdistance></version>
///<version value="1.2" date="02dec14" author="thorsten.huck@hsbcad.com"> symbols and text of element view is published as tsl based dimRequests </version>
///<version value="1.1" date="01dec14" author="thorsten.huck@hsbcad.com"> initial hardware configuration corrected </version>
///<version value="1.0" date="01dec14" author="thorsten.huck@hsbcad.com"> initial</version>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Electra")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add Entry|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Edit Entry|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Remove Entry|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Flip Side|") (_TM "|Select installation|"))) TSLCONTENT

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
	String _sTagKey="Hsb_Tag";
//end Constants//endregion

//region Functions
	//region getTslsFromEntity
	// this function gets tsls with scriptname that are attached to the entity	
	TslInst[] getTslsFromEntity(String sName, Entity ent)	
	{ 
		TslInst tsls[0];
		TslInst tslsAttached[]=ent.tslInstAttached();
		for (int t=0;t<tslsAttached.length();t++) 
		{ 
			if(tslsAttached[t].scriptName()!=sName)
			{ 
				continue;
			}
			if(!tslsAttached[t].bIsValid())
			{ 
				continue;
			}
			if(tsls.find(tslsAttached[t])<0)
			{ 
				tsls.append(tslsAttached[t]);
			}
		}//next t
		return tsls;
	}
	//End getTslsFromEntity//endregion 
	
	//region getGrips
	// HSB-22525
	// returns grips based on type in _sGripType
	// type cane be
	// "EditInPlaceWirechase"
	// "WirechaseTop" or ""
	Grip[] getGrips(Grip _gripsAll[], String _sGripType)
	{ 
		// returns the grip objects
		// type cane be
		// "EditInPlaceWirechase"
		// "WirechaseTop" or ""
		Grip _gripsReturn[0];
		
		if(_sGripType=="EditInPlaceWirechase")
		{ 
			for (int i=0;i<_gripsAll.length();i++) 
			{ 
				Grip gripI=_gripsAll[i];
				String sNameI=gripI.name();
				if(sNameI.find(_sGripType,-1,false)>-1)
				{ 
					_gripsReturn.append(gripI);
				}
			}//next i
		}
		else if(_sGripType!="EditInPlaceWirechase")
		{ 
			// grips on top view
			for (int i=0;i<_gripsAll.length();i++) 
			{ 
				Grip gripI=_gripsAll[i];
				String sNameI=gripI.name();
				if(sNameI.find("EditInPlaceWirechase",-1,false)<0)
				{ 
					_gripsReturn.append(gripI);
				}
			}//next i
		}
		
		return _gripsReturn;
	}
	//End getGrips//endregion
	
//region fixGripsEditInPlaceOrientation
// top one should point upward, bottom point downward
	void fixGripsEditInPlaceOrientation(Grip& _gripsAll[], Vector3d _vecY)
	{ 
		Grip _gripsEditInPlace[0];
		int _nIndicesEditInPlace[0];
		for (int i=0;i<_gripsAll.length();i++) 
		{ 
			Grip gripI=_gripsAll[i];
			String sNameI=gripI.name();
			if(sNameI.find("EditInPlaceWirechase",-1,false)>-1)
			{ 
				_gripsEditInPlace.append(gripI);
				_nIndicesEditInPlace.append(i);
			}
		}//next i
		
		if(_gripsEditInPlace.length()==2)
		{ 
			_gripsEditInPlace[0].setVecX(-_vecY);
			_gripsEditInPlace[1].setVecX(_vecY);
			if(_vecY.dotProduct(_gripsEditInPlace[0].ptLoc()-_gripsEditInPlace[1].ptLoc())>dEps)
			{ 
				_gripsEditInPlace[0].setVecX(_vecY);
				_gripsEditInPlace[1].setVecX(-_vecY);
			}
			_gripsAll[_nIndicesEditInPlace[0]]=_gripsEditInPlace[0];
			_gripsAll[_nIndicesEditInPlace[1]]=_gripsEditInPlace[1];
		}
		
		return;
	}
//End fixGripsEditInPlaceOrientation//endregion

//region getBcMapDefinition
// returns map with beamcut parameters	
	Map getBcMapDefinition(Point3d _pt, 
		Vector3d _vx,Vector3d _vy,Vector3d _vz,
		double _dx,double _dy,double _dz,
		double _dXflag,double _dYflag,double _dZflag)
	{ 
		Map _mapBc;
		_mapBc.setPoint3d("pt",_pt);
		_mapBc.setVector3d("vx",_vx);
		_mapBc.setVector3d("vy",_vy);
		_mapBc.setVector3d("vz",_vz);
		
		_mapBc.setDouble("dx",_dx);
		_mapBc.setDouble("dy",_dy);
		_mapBc.setDouble("dz",_dz);
		
		_mapBc.setDouble("dXflag",_dXflag);
		_mapBc.setDouble("dYflag",_dYflag);
		_mapBc.setDouble("dZflag",_dZflag);
		
		return _mapBc;
	}
//End getBcMapDefinition//endregion
//End Functions//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName =bDebug?"hsbCLT-Electra":scriptName();
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

//region Add/Edit Dialog Instance
	if (_Map.getInt("mode")==1)	
	{ 
		setOPMKey("Edit");

		String sFormatName=T("|Format|");
		int nFormatIndex = nStringIndex++;
		PropString sFormat(nFormatIndex, "@(Elevation)", sFormatName); // default to elevation
		sFormat.setDescription(T("|Defines the format expression of the text to be displayed|") + T("|i.e. '@(Elevation)' resiolves the elevtaion of the instance.|") + + T(" |Use '\P' for a new line.|")
						+ T(" |To edit the list of values use context commands.|") +T("|The property Offset between Installations is suppressed if the quatity is less than 2. All prefix text containing a colon will be suppressed, too.|"));
		sFormat.setCategory(category);	
		
		return;
	}
//End Add/Edit Dialog Instance//endregion 

//region Properties
	String sCategoryOutput="Electrical";		
	String sAligns[] = { T("|Horizontal|"), T("|Vertical|")};
	double dMerge = U(10);

// Installation Properties	
	String sQtyName = T("|Quantity|");
	int nQtys[] = {0,1,2,3,4,5};
	PropInt nQty(nIntIndex++, nQtys, sQtyName ,1);
	nQty.setDescription(T("|Sets the amount of boxes|"));	
	nQty.setCategory(category);
	
	String sElevationName = T("|Elevation|");
	PropDouble dElevation(nDoubleIndex++, U(350),sElevationName);
	dElevation.setDescription(T("|Sets the elevation.|") + " " + T("|The elevation on more than 3 vertical boxes is set to the second from top|"));	
	dElevation.setCategory(category);
	
	String sShapeName = T("|Tooling Shape|");
	String sShapes[] = {T("|Drill|"),T("|Slotted Hole|"),T("|Rectangular|")};
	PropString sShape(nStringIndex++,sShapes,sShapeName);		
	sShape.setDescription(T("|Defines the shape installation tooling.|"));
	sShape.setCategory(category);
	
	String sAlignName = T("|Alignment|");
	PropString sAlign(nStringIndex++, sAligns, sAlignName ,0);
	sAlign.setDescription(T("|Sets the aligment.|") + " " + T("|The elevation on more than 3 vertical boxes is set to the second from top|"));
	sAlign.setCategory(category);

	String sDiameterName = T("|Diameter|");
	PropDouble dDiameter(nDoubleIndex++, U(70),sDiameterName);	
	dDiameter.setDescription(T("|Sets the diameter.|"));
	dDiameter.setCategory(category);

	String sDepthName = T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(70),sDepthName);	
	dDepth.setDescription(T("|Sets the depth.|"));
	dDepth.setCategory(category);
	
	String sOffsetInstallationName =T("|Offset between Installations|");
	PropDouble dOffsetInstallation(nDoubleIndex++,U(68), sOffsetInstallationName );		
	dOffsetInstallation.setDescription(T("|Sets the Offset between Installations.|"));
	dOffsetInstallation.setCategory(category);

	
// Wirechase Properties
	category = T("|Wirechase|");
	String sWirechaseAlignmnetName=T("|Alignment|")+" "+T("|Wirechase|");
	String sWirechaseAlignmnets[]={T("|bottom left|"),T("|bottom center|"),T("|bottom right|"),T("|both left|"),T("|both center|"),T("|both right|"),T("|top left|"),T("|top center|"),T("|top right|")};
	PropString sWirechaseAlignmnet(nStringIndex++,sWirechaseAlignmnets,sWirechaseAlignmnetName);		
	sWirechaseAlignmnet.setDescription(T("|Defines the orientation of the wirechase milling.|"));
	sWirechaseAlignmnet.setCategory(category);

	String sWcDepthName= T("|Depth|")+" "+T("|Wirechase|");
	PropDouble dWcDepth(nDoubleIndex++,U(27),sWcDepthName );
	dWcDepth.setDescription(T("|Sets the Depth of milling.|"));
	dWcDepth.setCategory(category);
	
//	String sWcWidthName= T("|Width|")+" ";
	String sWcWidthName= T("|Width|");
	PropDouble dWcWidth(nDoubleIndex++,U(57),sWcWidthName);
	dWcWidth.setDescription(T("|Sets the Width of milling.|"));
	dWcWidth.setCategory(category);

	String sWirechaseOffsetXName= "X-" + T("|Offset|");
	PropDouble dWirechaseOffsetX(nDoubleIndex++,U(0),sWirechaseOffsetXName);
	dWirechaseOffsetX.setDescription(T("|Sets an offset in X-direction.|"));
	dWirechaseOffsetX.setCategory(category);

	String sWirechaseOffsetZName= "Z-" + T("|Offset|");
	PropDouble dWirechaseOffsetZ(nDoubleIndex++,U(20),sWirechaseOffsetZName);
	dWirechaseOffsetZ.setDescription(T("|Sets an offset in Z-direction.|") + " " + T("|NOTE: CNC Tooling might be limited.|"));
	dWirechaseOffsetZ.setCategory(category);

	String sWirechaseOvershootName= T("|Overshoot|");
	PropDouble dWirechaseOvershoot(nDoubleIndex++,U(20),sWirechaseOvershootName);
	dWirechaseOvershoot.setDescription(T("|Sets the the overlapping of the wirechase with the outmost drill.|"));
	dWirechaseOvershoot.setCategory(category);

	String sWcSideName= T("|Side|");
	String sWcSides[] = {T("|unchanged|"),T("|opposite Side|")};
	PropString sWcSide(nStringIndex++,sWcSides,sWcSideName);	
	sWcSide.setDescription(T("|Defines the side of the wirechase milling.|"));
	sWcSide.setCategory(category);
	
	// HSB-18037
	String sWirechaseToolShapeName=T("|Wirechase Tool Shape|");
	String sWirechaseToolShapes[]={T("|Rectangular|"),T("|Circular|")};
	PropString sWirechaseToolShape(8,sWirechaseToolShapes,sWirechaseToolShapeName);	
	sWirechaseToolShape.setDescription(T("|Defines the WirechaseToolShape|"));
	sWirechaseToolShape.setCategory(category);
	
// order dimstyles
	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setCategory(category);

	PropDouble dTxtH(nDoubleIndex++,U(40),T("|Text Height|"));	
	dTxtH.setDescription(T("|Overrides the text size of the selected dimstyle.|"));	
	dTxtH.setCategory(category);
	
	String sColorDescription = T("|Defines symbol colors. invalid or empty will display ByBlock.|") + " " + 
		T("|Different colors can be selected by semicolon, the first entry will set plan view color, second entry sets color on element icon side, last entry defines opposite icon side color.|");
	PropString sColor(nStringIndex++, "-1;3;4", T("|Colors|"));		
	sColor.setDescription(sColorDescription);	
	sColor.setCategory(category);	
	
// 	
//region editable combo vs textbox
	String sMapKey = "Entry[]";
	Map mapEntries = mapSetting.getMap(sMapKey);
	String entries[0];
	for (int i=0;i<mapEntries.length();i++) 
	{ 
		String entry = mapEntries.getString(i); 
		if (entry.length()>0 && entries.findNoCase(entry,-1)<0)
			entries.append(entry);
	}//next i
	entries = entries.sorted();

	String sFormatName=T("|Format|");
	int nFormatIndex = nStringIndex++;
	PropString sFormat(nFormatIndex, "@("+sElevationName+")", sFormatName); // default to elevation
	if (entries.length()>0)
	{
		if (sFormat.length()>0 && entries.findNoCase(sFormat,-1)<0)
		{
			entries.append(sFormat);
			entries = entries.sorted();
		}
		sFormat = PropString(nFormatIndex, entries, sFormatName);
	}
	sFormat.setDescription(T("|Defines the format expression of the text to be displayed|") + T("|i.e. '@(Elevation)' resiolves the elevtaion of the instance.|") + + T(" |Use '\P' for a new line.|")
						+ T(" |To edit the list of values use context commands.|") +T("|The property Offset between Installations is suppressed if the quatity is less than 2. All prefix text containing a colon will be suppressed, too.|"));
	sFormat.setCategory(category);		
//editable combo vs textbox//endregion 
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// set properties from catalog
		String sSelectedEntry =_kExecuteKey;
		
	/// validate selected entry
		String sCatalogEntries[] = TslInst().getListOfCatalogNames(scriptName());
		sSelectedEntry.makeUpper();
		int nEntry =-1;
		for(int i=0;i<sCatalogEntries.length();i++)
		{
			String s = sCatalogEntries[i];s.makeUpper();
			if (s==sSelectedEntry){nEntry=i;break;}
		}

		double dNewElevation;
		if (nEntry>-1)
		{
			setPropValuesFromCatalog(_kExecuteKey);	
			
		/// get elevation as string to allow enter as confirmation of an existing value
			String sInput=getString(T("|Elevation|") + " [" + dElevation+"]");
			dNewElevation = sInput.atof();	
			String sCheckInput = dNewElevation;
			if(sInput!=sCheckInput) 
				dNewElevation =dElevation;
			
			dElevation.set(dNewElevation);	
		}
	// show dialog
		else
			showDialog();

	// selection set
		Entity ents[0];
		PrEntity ssE(T("|Select panels or elements which contain panels|"), Sip());	
		ssE.addAllowedClass(Element());
		if (ssE.go())
			ents= ssE.set();

	// detect main object, if an element and a sip was selected the element is prioritized
		Sip sip;
		Element element;
		for(int i = 0;i <ents.length();i++)
		{
			if(ents[i].bIsKindOf(Sip()))
				sip = (Sip)ents[i];
			else if(ents[i].bIsKindOf(ElementWall()))
				element = (Element)ents[i];
			if (element.bIsValid())break;
		}

		if (element.bIsValid())
			_Element.append(element);
		else if (sip.bIsValid())
		{
		// validate if the selected panel belongs to an element wall // HSB-7757
			Element el = sip.element();
			if (el.bIsValid() && el.bIsKindOf(ElementWall()))
				_Element.append(el);
			else
				_Sip.append(sip);		
		}
		
		_Pt0 = getPoint();	
		_Map.setInt("AddHardware", true);
		return;	
	}	
// end on insert	__________________//endregion

//region Standards
// Linked sip
	Sip sipLinked;

// validate element and/or panel link
	Element elThis;
	Sip sips[0];
	if (_Element.length()>0)
	{
		elThis= _Element[0];
		sips=elThis.sip();
		if (_kNameLastChangedProp=="_Pt0" || _bOnRecalc)
		{
			_Sip.setLength(0);
			setExecutionLoops(2);
		}
		//_GenBeam.append(sip);		
	}
	else if (_Sip.length()>0)
	{
		sips = _Sip;
		
		//setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
		elThis= sips[0].element();
	// change assignment: if the element is valid it should be the main ref
		if (!_bOnDbCreated && elThis.bIsValid() && elThis.bIsKindOf(ElementWall()))
		{
			_Element.append(elThis);
			_Sip.setLength(0);
			if (bDebug)reportMessage("\nMain assignment changed from panel to element " + elThis.number());
			setExecutionLoops(2);
			return;	
		}
	}
	if (!elThis.bIsValid() && sips.length()<1)
	{
		reportMessage("\n" + scriptName() + " invalid references");
		eraseInstance();
		return;	
	}		
//End Standards//endregion 

//region Editable Combo/Textbox Format

// Trigger AddEntry//region
	String sTriggerAddEntry = T("../|Add Entry|");
	addRecalcTrigger(_kContext, sTriggerAddEntry );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEntry)
	{
		if (sFormat.length()>0 && mapEntries.length()<1)
		{ 
			mapEntries.appendString("Entry", sFormat);
		}

		String newEntry;// = getString("Enter new value");
		
	// create Add/Edit TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={sFormat};
		Map mapTsl;	
		mapTsl.setInt("mode",1);			
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
		
		if (tslNew.bIsValid())
		{ 
			tslNew.showDialog();
			newEntry = tslNew.propString(0);
			tslNew.dbErase();
		}		
	
		if (newEntry.length()>0 && entries.findNoCase(newEntry,-1)<0)
		{ 
			sFormat.set(newEntry);
			mapEntries.appendString("Entry", newEntry);		
			mapSetting.setMap(sMapKey, mapEntries);
			if (mo.bIsValid())
				mo.setMap(mapSetting);
			else
				mo.dbCreate(mapSetting);					
		}

		setExecutionLoops(2);
		return;
	}//endregion
	
// Trigger EditEntry or RemoveEntry//region
	int nEntry = entries.findNoCase(sFormat ,- 1);
	if (nEntry>-1)
	{ 
		String sTriggerEditEntry = T("../|Edit Entry|");
		addRecalcTrigger(_kContext, sTriggerEditEntry );
		if (_bOnRecalc && _kExecuteKey==sTriggerEditEntry)
		{
			String newEntry;
			
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={};				String sProps[]={sFormat};
			Map mapTsl;	
			mapTsl.setInt("mode",1);			
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
			
			if (tslNew.bIsValid())
			{ 
				tslNew.showDialog();
				newEntry = tslNew.propString(0);
				tslNew.dbErase();
			}

			if (newEntry.length()>0 && entries.findNoCase(newEntry,-1)<0)
			{ 
				entries.removeAt(nEntry);
				entries.append(newEntry);
				sFormat.set(newEntry);
				
				mapEntries = Map();
				for (int i=0;i<entries.length();i++)
					mapEntries.appendString("Entry",entries[i]); 
				mapSetting.setMap(sMapKey, mapEntries);
				
				if (mo.bIsValid())
					mo.setMap(mapSetting);	
				else
					mo.dbCreate(mapSetting);					
			}	
				
			setExecutionLoops(2);
			return;
		}

		String sTriggerRemoveEntry = T("../|Remove Entry|");
		addRecalcTrigger(_kContext, sTriggerRemoveEntry );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntry)
		{
			if (entries.length()<=1)
				mapSetting.removeAt(sMapKey, true);
			else
			{ 
				if (nEntry>0)
					sFormat.set(entries[nEntry - 1]);
				else
					sFormat.set(entries[nEntry +1]);
				entries.removeAt(nEntry);
				mapEntries = Map();
				for (int i=0;i<entries.length();i++)
					mapEntries.appendString("Entry",entries[i]); 
				mapSetting.setMap(sMapKey, mapEntries);
			}
			if (mo.bIsValid())
				mo.setMap(mapSetting);	
			else
				mo.dbCreate(mapSetting);					
			setExecutionLoops(2);
			return;
		}		
	}	//endregion	
	
//End Editable Combo/Textbox Format//endregion
	
// ints
	int nWirechaseAlignment=sWirechaseAlignmnets.find(sWirechaseAlignmnet);// bottom left,center, right, both..., top...
	int nWcVerticalAlignments[]= {0,0,0,1,1,1,2,2,2};
	int nWcHorizontalAlignments[]= {-1,0,1,-1,0,1,-1,0,1};
	int nWcVerticalAlignment= nWcVerticalAlignments[nWirechaseAlignment];
	int nWcHorizontalAlignment= nWcHorizontalAlignments[nWirechaseAlignment];
	int nWcSide = sWcSides.find(sWcSide);
	// HSB-18037
	int nWirechaseToolShape=sWirechaseToolShapes.find(sWirechaseToolShape);
	
	int nAlign = sAligns.find(sAlign);
	int nShape=sShapes.find(sShape);
	int bHasDefiningPLine = _Map.hasPLine("plDefining"); // flag wether the instance contains a pline definition of the wirechase contour
	
	int bAddHardware=_Map.getInt("AddHardware");

// auto correct installation offset
	if (nQty>1 && dOffsetInstallation<=0 && dDiameter>0)
	{ 
		double d = dOffsetInstallation;
		dOffsetInstallation.set(dDiameter);
		reportMessage("\n" + scriptName() + " " + sOffsetInstallationName + " " + T("|adjusted from|") + " " + d +" "+ T("|to|") + " " + dOffsetInstallation);
		setExecutionLoops(2);
		return;
	}

// assign colors
	int nColors[]={0,0,0};
	for (int i=0;i<nColors.length();i++)
		if (sColor.token(i)!="") 
			nColors[i]= sColor.token(i).atoi();

// flag if plan symbol to be displayed
	int bShowPlan=true;;

// the main coordSys and dimensions
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg;
	PlaneProfile ppOutlineWall;
	PLine plEnvelope;
	double dX, dY, dZ;
	PlaneProfile ppEnvelope;	
	
// element based
	if (elThis.bIsValid())
	{
		if (_Element.length()<1)_Element.append(elThis);
		else if (_Element[0]!=elThis)_Element[0]=elThis;
		vecX = elThis.vecX();
		vecY = elThis.vecY();	
		vecZ = elThis.vecZ();
		ptOrg = elThis.ptOrg();
		ppOutlineWall=PlaneProfile(elThis.plOutlineWall());
		plEnvelope = elThis.plEnvelope();plEnvelope .vis(2);
	
	// assign
		assignToElementGroup(elThis, true, 0, 'I');
		
	// get element thickness	
		if (elThis.bIsKindOf(ElementWallSF()))
			dZ = elThis.dBeamWidth();
		else
		{
			LineSeg seg = ppOutlineWall.extentInDir(vecX);
			dZ = abs(vecZ.dotProduct(seg.ptEnd()-seg.ptStart()));	
		}
	
	// override contour if element contains panels
		if (sips.length()>0)
		{
			ppEnvelope=PlaneProfile (CoordSys(ptOrg, vecX, vecY, vecZ));
			for (int i=0;i<sips.length();i++)
				ppEnvelope.unionWith(sips[i].envelopeBody(false, true).shadowProfile(Plane(ptOrg, vecZ)));//joinRing(sips[i].plEnvelope(),_kAdd);
			ppEnvelope.shrink(-dMerge);
			ppEnvelope.shrink(dMerge);
		}	
		exportWithElementDxa(elThis);
	}
// panel based
	else
	{
		Sip sip = sips[0];
		sipLinked = sip;
		Vector3d vecXSip = sip.vecX();
		Vector3d vecYSip = sip.vecY();
		Vector3d vecZSip = sip.vecZ();
		ptOrg = sip.ptCenSolid();
		setEraseAndCopyWithBeams(_kBeam0);
		
	// assign
		assignToGroups(sip, 'I');
				
	// if the panel is perp to world Z a flat wall view convention is assumed
		if (vecZSip.isParallelTo(_ZW))
		{
			vecZ=_ZW;
			vecY=_YW;
			vecX=vecY.crossProduct(vecZ);
			bShowPlan=false;
		}
	// if the panel Z is perp to world Z a 3D  wall view convention is assumed			
		else if (vecZSip.isPerpendicularTo(_ZW))
		{
			vecZ=vecZSip;
			vecY=_ZW;
			vecX=vecY.crossProduct(vecZ);

		}
	// panel coordSys
		else
		{
			vecX=vecXSip;
			vecY=vecYSip;
			vecZ=vecZSip;
			bShowPlan=false;
		}
		
	// bring ptOrg to assumend bottom
		LineSeg seg=(PlaneProfile(sip.plEnvelope()).extentInDir(vecX));
		dX=abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		ptOrg.transformBy(vecY*(vecY.dotProduct(seg.ptMid()-ptOrg)-.5*dY));
		seg.vis(2);	
		
	// create pseudo outlinewall	
		Plane pn(ptOrg,vecY);
		ppOutlineWall = sip.realBody().shadowProfile(pn);
		PLine plOutlineWall;
		plOutlineWall.createConvexHull(pn,ppOutlineWall.getGripVertexPoints() );
		ppOutlineWall=PlaneProfile(plOutlineWall);
		plEnvelope = sip.plEnvelope();	
		ppEnvelope = PlaneProfile (plEnvelope);
	}	
	
// vis
	vecX.vis(ptOrg,1);
	vecY.vis(ptOrg,3);
	vecZ.vis(ptOrg,150);

// get potential finished floor height from submap
	int bFFEChanged;
	double dFFE = _Map.getDouble("ElevationFinishedFloor");
	if (sips.length()>0 && sips[0].subMapKeys().find("FinishedFloor")>-1)
	{
		Map mapSub = sips[0].subMap("FinishedFloor");
		dFFE=mapSub.getDouble("ElevationFinishedFloor");	
	// make sure a change of the finished floor height triggers the location of the tool
		if (abs(dFFE-_Map.getDouble("ElevationFinishedFloor")))
		{
			_Map.setDouble("ElevationFinishedFloor",dFFE);
			bFFEChanged=true;
		}
	}


// envelopes	
	ppOutlineWall.vis(4);
	ppEnvelope .vis(40);
	
// snap ref point to closest outline point
	Point3d ptRef=ppOutlineWall.closestPointTo(_Pt0);
	ptRef.vis(6);
	_Pt0.transformBy(vecZ*vecZ.dotProduct(ptRef-_Pt0));	

// test events for text interference detection (element view)
	int bTestInterference = _bOnDebug || _bOnRecalc || _Map.getInt("bTestInterference");

// on the event of changing the elevation
	if(_kNameLastChangedProp == sElevationName || _bOnDbCreated || bFFEChanged)
	{
		_Pt0=ptRef+vecY*(dElevation+dFFE);	
		bTestInterference=true;
		//reportMessage("\ncase " + 1);
	}

// in case pt0 is outside of the envelope snap to closest
	if (ppEnvelope.pointInProfile(_Pt0)==_kPointOutsideProfile && !elThis.bIsValid())
	{
		Point3d ptNext = ppEnvelope.closestPointTo(_Pt0);
		_Pt0.transformBy(vecX*vecX.dotProduct(ptNext-_Pt0) + vecY*vecY.dotProduct(ptNext-_Pt0));	
		dElevation.set(vecY.dotProduct(_Pt0-ptOrg)-dFFE);
		setExecutionLoops(2);
		//reportMessage("\ncase " + 2);
	}
	
// on the event of dragging _Pt0
	if(_kNameLastChangedProp == "_Pt0")
	{
		dElevation.set(vecY.dotProduct(_Pt0-ptOrg)-dFFE);	
		bTestInterference=true;
		//reportMessage("\ncase " + 3);
	}
	
// validate elevation as the user might have moved the instance
	if(!_bOnDbCreated && _kNameLastChangedProp != "_Pt0" && _kNameLastChangedProp != sElevationName && abs(dElevation-vecY.dotProduct(_Pt0-ptOrg))>dEps)
	{ 
		dElevation.set(vecY.dotProduct(_Pt0-ptOrg)-dFFE);	
		bTestInterference=true;
		//reportMessage("\ncase " + 4);
	}
	
	_Pt0.vis(3);	

// distinguish installation side
	Point3d ptsOutlineWall[] = ppOutlineWall.getGripVertexPoints();				
	int nSide = 1;
	Point3d ptMid = ppOutlineWall.extentInDir(vecX).ptMid();
	//ptMid.setToAverage(ptsOutlineWall); //ptMid.vis(5);
	if(vecZ.dotProduct(_Pt0-ptMid)<0) 
		nSide*=-1;	
	
// the tool vectors	
	Vector3d vecXE = nSide*vecX;
	Vector3d vecYE = vecY;	
	Vector3d vecZE = nSide*vecZ;
	vecZE.vis(_Pt0,40);

// add trigger to flip side
	String sFlipSideTrigger = T("|Flip Side|");
	addRecalcTrigger(_kContext, "../"+sFlipSideTrigger );
	if (_bOnRecalc && (_kExecuteKey==sFlipSideTrigger || _kExecuteKey=="../"+sFlipSideTrigger || _kExecuteKey==sDoubleClick) ) 
	{
		//_Map.setDouble("dGripZ",_Map.getDouble("dGripZ")*-1);
		CoordSys csMirr;
		csMirr.setToMirroring(Plane(ptMid,vecZ));
		_Pt0.transformBy(csMirr);		
		if (_PtG.length()>0)
			_PtG[0].transformBy(csMirr);
		bTestInterference=true;
		_Map.setInt("bTestInterference",bTestInterference);// store value as follwing return will not keep value
		_Map.setInt("GripsFlipSide",true);
		setExecutionLoops(2);
		return;
	}

// create grip
	if (_PtG.length()<1)
	{
		_PtG.append(ptRef+(vecZE)*2*dTxtH);
		_Map.setDouble("dGripX",vecX.dotProduct(_PtG[0]-ptRef));			
		_Map.setDouble("dGripZ",vecZE.dotProduct(_PtG[0]-ptRef));	
	}

// on the event of changing the shape
	String sAddHardwareEvents[] = {sShapeName, sQtyName, sDiameterName, sOffsetInstallationName};
	if(sAddHardwareEvents.find(_kNameLastChangedProp)>-1)
	{
		bAddHardware=true;
		_Map.setInt("AddHardware", bAddHardware);	
		bTestInterference=true;	
	}	

// on the event of dragging _PtG[0]
	if(_kNameLastChangedProp == "_PtG0")
	{
		_Map.setDouble("dGripX",vecX.dotProduct(_PtG[0]-ptRef));			
		_Map.setDouble("dGripZ",vecZE.dotProduct(_PtG[0]-ptRef));		
	}	

// relocate grip
	double dZGripOffset = _Map.getDouble("dGripZ");
	if(_kNameLastChangedProp == "_Pt0" && _Map.hasDouble("dGripZ") )
	{
		_PtG[0]=ptRef+vecX *_Map.getDouble("dGripX")+vecZE*_Map.getDouble("dGripZ");
	}	
	for (int i=0;i<_PtG.length();i++)
		_PtG[i] = _PtG[i]-vecY*vecY.dotProduct(_PtG[i]-ptRef);	
			
// the display
	Display dpPlan(nColors[0]);
	dpPlan.addHideDirection(vecX);
	dpPlan.addHideDirection(-vecX);
	dpPlan.addHideDirection(vecZ);
	dpPlan.addHideDirection(-vecZ);		
	//dpPlan.dimStyle(sDimStyle);
	double dFactor = dpPlan.textHeightForStyle("O",sDimStyle)/dTxtH;
	dpPlan.textHeight(dTxtH);
	
	// element color is dependent from side
	int nElemColor =nColors[1];
	if(nSide==-1) nElemColor =nColors[2];
	Display dpElement(nElemColor);
	if (bShowPlan)
	{
		dpElement.addViewDirection(vecZE);
		dpElement.addViewDirection(-vecZE);
	}	
	dpElement.textHeight(dTxtH);

// wall thickness
	ptsOutlineWall=Line(_Pt0,vecZ).orderPoints(ptsOutlineWall);
	if(ptsOutlineWall.length()>0)
		dZ = abs(vecZ.dotProduct(ptsOutlineWall[0]-ptsOutlineWall[ptsOutlineWall.length()-1]));

// collect other electra instances which operate on the same set of panels
	TslInst tslOthers[0];
	//for (int i=0;i<sips.length();i++)
	//{
		////TslInst tsls[] = sips[i].tslInst();	
	//}

// set wirechase x-reference
	Point3d ptRefWc = _Pt0+vecX*(nWcHorizontalAlignment*(.5*(dDiameter+dWcWidth)+dWirechaseOffsetX));
// horizontal alignment
	if (nAlign ==0 && nWcHorizontalAlignment!=0)
		ptRefWc.transformBy(vecX * nWcHorizontalAlignment*.5*(((nQty-1)*dOffsetInstallation)));
	else if (nWcHorizontalAlignment==0)
		ptRefWc.transformBy(vecX * dWirechaseOffsetX);
	ptRefWc.vis(2);		
//get min/max of envelope
	PLine plRings[] = ppEnvelope.allRings();
	int bIsOp[] = ppEnvelope.ringIsOpening();
	Point3d ptsMinMax[0];
	for (int r=0;r<plRings.length();r++)
	{
		if (bIsOp[r]){continue;}
		PLine pl = plRings[r];
		ptsMinMax.append(pl.intersectPoints(Plane(ptRefWc-vecX*.5*dWcWidth,vecX)));
		ptsMinMax.append(pl.intersectPoints(Plane(ptRefWc+vecX*.5*dWcWidth,vecX)));
	}
	ptsMinMax = Line(ptRefWc,vecY).orderPoints(ptsMinMax);
	
// START WIRECHASE
	double dXBc, dYBc=dWcWidth, dZBc=dWcDepth*2;
	BeamCut bcWirechase;
	Map mapBc;// map that contains wirechase beamcut parameters
	Drill drWirechase;
	Point3d ptWirechase;
	if (ptsMinMax.length()>0)
	{
		ptsMinMax[0].vis(1);
		ptsMinMax[ptsMinMax.length()-1].vis(4);
		ptWirechase=ptRefWc+vecY*vecY.dotProduct(ptsMinMax[0]-ptRefWc);
		
		if (nWcVerticalAlignment==0) // bottom
			dXBc= abs(vecY.dotProduct(_Pt0-ptsMinMax[0]))+dWirechaseOvershoot;	
		else if (nWcVerticalAlignment==1) // bottom+top
			dXBc= abs(vecY.dotProduct(ptsMinMax[ptsMinMax.length()-1]-ptsMinMax[0]));	
		else if (nWcVerticalAlignment==2) // top
		{
			dXBc= abs(vecY.dotProduct(ptsMinMax[ptsMinMax.length()-1]-_Pt0))+dWirechaseOvershoot;
			ptWirechase=ptRefWc-vecY*dWirechaseOvershoot;
		}			
		ptWirechase.transformBy(vecZE*vecZE.dotProduct(_Pt0-ptWirechase));
	
	// z-offset
		double dZFlag;
		if (abs(dWirechaseOffsetZ)>0)
		{
			ptWirechase.transformBy(-vecZE*dWirechaseOffsetZ);
			dZFlag=-1;
			dZBc=dWcDepth;
		}
		if (dXBc>dEps && dYBc>dEps && dZBc>dEps && !bHasDefiningPLine)
		{
		// HSB-22525
		// TriggerEditInPlace
			int bEditInPlace=_Map.getInt("directEdit");
			String sTriggerEditInPlaces[] = {T("|Edit in Place|"),T("|Disable Edit in Place|")};
			String sTriggerEditInPlace = sTriggerEditInPlaces[bEditInPlace];
			addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
			if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace )
			{
				if (bEditInPlace)
				{
					bEditInPlace=false;
	//				_PtG.setLength(0);
					// cleanup grips
					Grip gripsTop[]=getGrips(_Grip,"");
					_Grip.setLength(0);
					_Grip.append(gripsTop);
				}
				else
				{
					bEditInPlace=true;
					// add grips
					// use triangle shape for stretching grips
					Grip grip(ptWirechase);
//					grip.setShapeType(_kGSTArrow);
//					grip.setShapeType(_kGSTTriangle);
					grip.setShapeType(_kGSTTriangleIso);
					
					grip.addViewDirection(vecZE);
					grip.addViewDirection(-vecZE);
					grip.setColor(4);
					grip.setIsStretchPoint(true);
					grip.setIsRelativeToEcs(true);
					
					grip.setVecX(-vecYE);
					grip.setVecY(-vecXE);
					
					grip.setPtLoc(ptWirechase);
					grip.setName("EditInPlaceWireChase1");
					_Grip.append(grip);
					grip.setPtLoc(ptWirechase+vecYE*dXBc);
					grip.setVecX(vecYE);
					grip.setName("EditInPlaceWireChase2");
					_Grip.append(grip);
				}
				_Map.setInt("directEdit",bEditInPlace);
				setExecutionLoops(2);
				return;
			}
			Point3d ptWirechaseBc=ptWirechase;
			double dXBcBc=dXBc;
			if(bEditInPlace)
			{ 
				// HSB-22525: use grips
				// calc from grip points
				Grip gripsEdit[]=getGrips(_Grip, "EditInPlaceWirechase");
				if(gripsEdit.length()>0)
				{
					Point3d ptGripBottom=gripsEdit.first().ptLoc(), ptGripTop=gripsEdit.first().ptLoc();
					for (int p=0;p<gripsEdit.length();p++) 
					{ 
						if(vecYE.dotProduct(gripsEdit[p].ptLoc()-ptGripBottom)<0)
						{ 
							ptGripBottom=gripsEdit[p].ptLoc();
						}
						if(vecYE.dotProduct(gripsEdit[p].ptLoc()-ptGripTop)>0)
						{ 
							ptGripTop=gripsEdit[p].ptLoc();
						}
					}//next p
					
					ptWirechaseBc+=vecYE*vecYE.dotProduct(ptGripBottom-ptWirechaseBc);
					dXBcBc=abs(vecYE.dotProduct(ptGripBottom-ptGripTop));
				}
			}
			if(nWirechaseToolShape==0)
			{ 
				// rectangular, beamcut
				ptWirechase.vis(6);
				vecYE.vis(ptWirechase);
				vecXE.vis(ptWirechase);
				vecZE.vis(ptWirechase);
				
//				bcWirechase=BeamCut(ptWirechase, vecYE,-vecXE,vecZE,dXBc,dYBc, dZBc,1,0,dZFlag);//nWirechaseOffset			
				bcWirechase=BeamCut(ptWirechaseBc, vecYE,-vecXE,vecZE,dXBcBc,dYBc, dZBc,1,0,dZFlag);//nWirechaseOffset
				mapBc=getBcMapDefinition(ptWirechaseBc,vecYE,-vecXE,vecZE,dXBcBc,dYBc, dZBc,1,0,dZFlag);
			// if wirechase should be on opposide side
				if (nWcSide==1)
				{
					CoordSys csMirr;
					csMirr.setToMirroring(Plane(ptMid,vecZ));
					ptWirechase.transformBy(csMirr);
					bcWirechase.transformBy(csMirr);
				}
				bcWirechase.cuttingBody().vis(3);
				Body bdBcWirechase=bcWirechase.cuttingBody();
				//Body bdTool = bcWirechase.cuttingBody();
			//// assign tool only to intersecting panels
				//for (int i=0;i<sips.length();i++)
					//if (sips[i].envelopeBody().hasIntersection(bdTool))
						//sips[i].addTool(bcWirechase);
				int bRawBeamsCalculated;
				Body bdRawReal;
				if(elThis.bIsValid())
				{ 
					// HSB-21889
					TslInst tslRiegelVerteilung;
					TslInst tslRiegelVerteilungs[0];
					if(sips.length()>0)
					{
						for (int s=0;s<sips.length();s++) 
						{ 
							TslInst tslsRiegel[]=getTslsFromEntity("Soligno-RiegelVerteilung",sips[s]);
							if(tslsRiegel.length()>0)
							{ 
								tslRiegelVerteilung=tslsRiegel[0];
								if(tslRiegelVerteilungs.find(tslRiegelVerteilung)<0)
								{ 
									tslRiegelVerteilungs.append(tslRiegelVerteilung);
								}
							}
						}//next s
					}
					if(tslRiegelVerteilungs.length()>0)
					{ 
						for (int t=0;t<tslRiegelVerteilungs.length();t++) 
						{ 
						
							if(tslRiegelVerteilungs[t].map().hasBody("bdRawReal"))
							{ 
								bdRawReal.addPart(tslRiegelVerteilungs[t].map().getBody("bdRawReal"));
								
							}
						}//next t
						if(bdRawReal.volume()>pow(U(5),3))
						{ 
							bRawBeamsCalculated=true;
						}
					}
//					bdRawReal.vis(1);
					String sTriggerTagTools = T("|Tag Tools|");
					// activate trigger if raw beams exist
					if(bRawBeamsCalculated)
					{
						// raw beams are there, tagging of beamcuts possible
						addRecalcTrigger(_kContextRoot, sTriggerTagTools );
					}
					else
					{ 
						// no raw beams found 
						// tagging not possible
						_Map.removeAt("mapToolTags",true);
					}
					bdRawReal.vis(6);
					if (_bOnRecalc && _kExecuteKey==sTriggerTagTools)
					{
						Map mapToolTags;
						Body bdRawBeams=bdRawReal;
//						bdRawBeams.vis(2);
					// cut the beamcuts from the panel
						{
							// check the tool 
							int bFlag=false;
							Map mapI;
							if(bRawBeamsCalculated)
							{ 
								Body bdIntersect=bdBcWirechase;
								if(!bdIntersect.intersectWith(bdRawBeams))
								{ 
									bFlag=true;
								}
								// check the intersection volume
								if(!bFlag)
									if(bdIntersect.volume()<pow(U(5),3))
									{ 
										// tool is not intersecting panel
										// flag for ignore in export
										bFlag=true;
									}
							}
							if(bFlag)
							{ 
								// flag this beamcut
								mapI.setInt("Flag",true);
								reportMessage("\n"+scriptName()+" "+T("|Tool was tagged|"));
								mapToolTags.appendMap("m",mapI);
								_Map.setMap("mapToolTags",mapToolTags);	
							}
							else if(!bFlag)
							{ 
								// HSB-21969:
//								reportMessage("\n"+scriptName()+" "+T("|Tool tagging not possible|"));
								// no flag possible
								_Map.removeAt("mapToolTags",false);
								reportMessage("\n"+scriptName()+": "+"Es wurde kein Werkzeug getagged");
								reportMessage("\n"+scriptName()+": "+"Bitte Rohstäbe überprüfen");
								
//								reportNotice("\n"+scriptName()+": "+"Es wurde kein Werkzeug getagged");
//								reportNotice("\n"+scriptName()+": "+"Bitte Rohstäbe überprüfen");
							}
						}
						setExecutionLoops(2);
						return;
					}//endregion	
				}
				Map mapToolTags;
				if(_Map.hasMap("mapToolTags"))
					mapToolTags=_Map.getMap("mapToolTags");
				int bUseFlagsInMap;
				if(mapToolTags.length()==1)
					bUseFlagsInMap=true;
				
				//region Trigger CleanTags
//				String sTriggerCleanTags = T("|Cleanup Tags|");
				String sTriggerCleanTags ="Tags bereinigen";
				if(bUseFlagsInMap)
				{
					addRecalcTrigger(_kContextRoot, sTriggerCleanTags );
				}
				if (_bOnRecalc && _kExecuteKey==sTriggerCleanTags)
				{
					_Map.removeAt("mapToolTags",true);
					
					setExecutionLoops(2);
					return;
				}//endregion	
				
				int bFlag=false;
				if(bUseFlagsInMap)
				{ 
					Map mi=mapToolTags.getMap(0);
					bFlag=mi.getInt("Flag");
					// verify that nothing has changed at beams
					if(bFlag)
					{ 
						Body bdRawBeams=bdRawReal;
						int _bFlag=false;
						Map mapI;
						if(bRawBeamsCalculated)
						{ 
							Body bdIntersect=bdBcWirechase;
							if(!bdIntersect.intersectWith(bdRawBeams))
							{ 
								_bFlag=true;
							}
							// check the intersection volume
							if(!_bFlag)
								if(bdIntersect.volume()<pow(U(5),3))
								{ 
									// tool is not intersecting panel
									// flag for ignore in export
									_bFlag=true;
								}
						}
						if(_bFlag)
						{ 
							// flag this beamcut
							mapI.setInt("Flag",true);
						}
						
						if(!_bFlag)
						{ 
							mapToolTags=Map();
							mapToolTags.appendMap("m",mapI);
							_Map.setMap("mapToolTags",mapToolTags);
							bFlag=false;
						}
					}
				}
				
				if(bFlag)
				{ 
					Map mapX;
					// HSB-21889
					mapX.setString("Tag","BearbeitungVerdeckterElektrokanal");
					bcWirechase.setSubMapX(_sTagKey,mapX);
				}
				
				bcWirechase.addMeToGenBeamsIntersect(sips);
				if(bEditInPlace)
				{ 
					// save the wirechase beamcut parameters in _map
					// beamcuts all inside panel
					// will not have an AnalysedBeamCut
					_Map.setMap("bcWireChase",mapBc);
				}
				else if(!bEditInPlace)
				{ 
					// remove the parameters
					_Map.removeAt("bcWireChase",true);
				}
			}
			else if(nWirechaseToolShape==1)
			{ 
				// HSB-18037 drill
//				drWirechase=Drill(ptWirechase,ptWirechase+vecYE*dXBc,.5*dYBc);
				// 
//				drWirechase=Drill(ptWirechase,ptWirechase+vecYE*dXBc,.5*dZBc);
				drWirechase=Drill(ptWirechase,ptWirechaseBc+vecYE*dXBcBc,.5*dZBc);
				if(dZFlag==1)drWirechase.transformBy(.5*dZBc*vecZE);
				if(dZFlag==-1)drWirechase.transformBy(-.5*dZBc*vecZE);
				if (nWcSide==1)
				{
					CoordSys csMirr;
					csMirr.setToMirroring(Plane(ptMid,vecZ));
					ptWirechase.transformBy(csMirr);
					drWirechase.transformBy(csMirr);
				}
				drWirechase.addMeToGenBeamsIntersect(sips);
			}
		}
	// HSB-21382
	//region initialize grip points and update on _kNameLastChange
		if(_Grip.length()==0)
		{ 
			// initialize grips in top view for the position of wirechase
			Grip grip(ptWirechase-vecXE*.5*dWcWidth);
//			grip.setShapeType(_kGSTCircle);
			grip.setShapeType(_kGSTSquare);
			
			grip.addViewDirection(vecYE);
			grip.setColor(1);
			grip.setIsStretchPoint(true);
			grip.setIsRelativeToEcs(true);
			grip.setPtLoc(ptWirechase-vecXE*.5*dWcWidth);
			_Grip.append(grip);
			grip.setPtLoc(ptWirechase+vecXE*.5*dWcWidth);
			_Grip.append(grip);
		}
		if(_Grip.length()>=2)
		{ 
			// top grips exis
			String sEventsGrip[]={sWirechaseOffsetXName,sWirechaseOffsetZName,
				sWcWidthName,sWcSideName,sWirechaseAlignmnetName};
			if(sEventsGrip.find(_kNameLastChangedProp)>-1
			|| _Map.getInt("GripsFlipSide"))
			{ 
				Grip grip=_Grip[0];
				grip.setPtLoc(ptWirechase-vecXE*.5*dWcWidth);
				_Grip[0]=grip;
				grip.setPtLoc(ptWirechase+vecXE*.5*dWcWidth);
				_Grip[1]=grip;
				
				_Map.setInt("GripsFlipSide",false);
			}
		}
	//End initialize grip points and update on _kNameLastChange//endregion
	
		
	// get stored defining pline
		if (bHasDefiningPLine)	
			_Map.getPLine("plDefining").vis(1);
	}
	ptWirechase.vis(2);
// HSB-21382: 
//region When grip draged, update properties
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	Grip grip;
	Vector3d vecOffsetApplied;
	int bDrag, bOnDragEnd,bDragTag;
	if (indexOfMovedGrip>-1)
	{ 
		 bDrag=_bOnGripPointDrag && _kExecuteKey=="_Grip";
	   // draging was finished
	    bOnDragEnd=!_bOnGripPointDrag;
	   // grip moved 
	    grip=_Grip[indexOfMovedGrip];
		vecOffsetApplied=grip.vecOffsetApplied();
	}
	if(indexOfMovedGrip>-1 && grip.name().find("EditInPlaceWirechase",-1,false)<0)
	{ 
		// top grips
		int nIndexOtherGrip[]={1,0};
		if(indexOfMovedGrip>-1)
		{ 
			Vector3d vecView=getViewDirection();
			Vector3d vec=vecView*vecView.dotProduct(vecOffsetApplied);
			Vector3d vecZoffset=vecZE*vecZE.dotProduct(vecOffsetApplied);
			Vector3d vecXoffset=vecXE*vecXE.dotProduct(vecOffsetApplied);
			double dXoffset=vecXE.dotProduct(vecOffsetApplied);
			Point3d pt=grip.ptLoc()-vec-vecZoffset;
			// allow only move in plan of view
			_Grip[indexOfMovedGrip].setPtLoc(pt);
			// other grip is also moved with same vecXoffset,
			// width should remain unchanged
			Point3d ptOtherGrip=_Grip[nIndexOtherGrip[indexOfMovedGrip]].ptLoc();
			ptOtherGrip+=vecXoffset;
			_Grip[nIndexOtherGrip[indexOfMovedGrip]].setPtLoc(ptOtherGrip);
			
			Point3d ptMidGrips=.5*(_Grip[0].ptLoc()+_Grip[1].ptLoc());
			// width will not be changed, when grip draged
			double dWcWidthNew=abs(vecXE.dotProduct(_Grip[0].ptLoc()-_Grip[1].ptLoc()));
			dWcWidth.set(dWcWidthNew);
	//		double dWirechaseOffsetXnew=vecXE.dotProduct(ptMidGrips-_Pt0);
			// consider alignment
			int nSign=-1;
			// HSB-21969: fix when draging grip point
			if(nWirechaseAlignment==2 || nWirechaseAlignment==1 
				|| nWirechaseAlignment==7 || nWirechaseAlignment==4
				|| nWirechaseAlignment==5 || nWirechaseAlignment==8)
				nSign=1;
			
			if(nSide==-1)nSign*=-1;
			double dWirechaseOffsetXnew=dWirechaseOffsetX+nSign*dXoffset;
			dWirechaseOffsetX.set(dWirechaseOffsetXnew);
			setExecutionLoops(2);
		}
	}
	else if(grip.name().find("EditInPlaceWirechase",-1,false)>-1)
	{ 
		//HSB-22525: allow only along vecYE
		// edit in place grip
		// remove component in vecx and vecz
		Vector3d vecZoffset=vecZE*vecZE.dotProduct(vecOffsetApplied);
		Vector3d vecXoffset=vecXE*vecXE.dotProduct(vecOffsetApplied);
		Point3d pt=grip.ptLoc()-vecZoffset-vecXoffset;
		_Grip[indexOfMovedGrip].setPtLoc(pt);
		// fix the direction of arrow, top one should point upward, bottom point downward
		fixGripsEditInPlaceOrientation(_Grip,vecYE);
	}
//End When grip draged, update properties//endregion 
// END WIRECHASE


// declare dim request map
	Map mapRequest,mapRequests;
	mapRequest.setInt("Color", nElemColor);
	mapRequest.setVector3d("AllowedView", vecZ);


// START INSTALLATIONS___________________________________________________
// the reading vectors in plan view
	Vector3d vecXRead=vecX, vecYRead=vecZE;	
	if (vecXRead.isParallelTo(_YW) && _YW.dotProduct(vecXRead)<0)
		vecXRead*=-1;	
	else if (_XW.dotProduct(vecXRead)<0)
		vecXRead*=-1;
	vecYRead = vecXRead.crossProduct(-_ZW);
	vecXRead.normalize();
	vecYRead.normalize();

// Element/Panel view	
	Point3d ptStart = _Pt0-vecZE*vecZE.dotProduct(ptRef-_Pt0);
	Point3d ptGuideE = _Pt0+vecXE*(dTxtH+.5*dDiameter); // the end point of the guide line and location of height text
	Vector3d vecDistr = vecX;
	//vecYRead.vis(ptGuideE,2);
	if (nAlign==1)
	{
		vecDistr=-vecY;
		if (nQty>3) ptStart.transformBy(vecY*dOffsetInstallation);
		//ptStart.transformBy(-vecDistr*.5*dDiameter);	
	}
	else
	{
		double d = .5*(nQty-1)*dOffsetInstallation;
		ptStart = _Pt0-vecDistr*d;
		ptGuideE.transformBy(nSide*vecDistr*d);
	}	

// transformation element to plan
	Point3d ptPlan = _PtG[0]+vecZE*dTxtH; 
	if (nAlign==1)
	{
		ptPlan.transformBy(vecZE*(vecDistr.dotProduct(_Pt0-ptStart)+.5*dDiameter));ptPlan.vis(81);
	}
	CoordSys cs2Plan;
	cs2Plan.setToAlignCoordSys(_Pt0,vecXE, vecYE, vecZE, ptPlan,vecX*nSide, -vecZ*nSide, vecY);

// start point of guide line in plan view
	if (nSide==-1 && nAlign==1)	
	{
		int n;
		if (nQty>3)n=2;
		ptPlan.transformBy(vecZE*(nQty-1-n)*dOffsetInstallation);	
		ptPlan.vis(82);
	}
	double dXY[]={(nQty-1)*dOffsetInstallation+dDiameter,dDiameter};
	if (nAlign==1)dXY.swap(0,1);
	Point3d ptGuidePlan1 =ptPlan+nSide*vecXE*.5*dXY[0];	ptGuidePlan1.vis(1);
	Point3d ptGuidePlan2= ptPlan+nSide*vecXE*(.5*dXY[0]+.5*dTxtH);ptGuidePlan2.vis(2);

// draw guideline
	PLine plGuideTxtPlan(ptGuidePlan1,ptGuidePlan2);
	if (dDiameter>dEps && nQty>0)dpPlan.draw(plGuideTxtPlan);
	
// test view for vertical alignments against of plan distribution and store transformation matrix
	Vector3d vecYPlanRead;
	if (nAlign ==1)
	{
		Vector3d vecDistrPlan = vecDistr;
		vecDistrPlan.transformBy(cs2Plan);	
		if (vecDistrPlan.dotProduct(vecYRead)>0)
		{
			int n=nQty-1;
			if (nQty>3)n-=2;		
			vecYPlanRead = vecDistrPlan *n*dOffsetInstallation;
			//plGuide.transformBy(vecDistr *n*dOffsetInstallation);
			//vecDistrPlan.vis(ptGuideE,12);
		}
	}
	
// the first location	
	Point3d ptDrill = ptStart;//
	
// declare the center cross pline
	double dCrossSize = U(5);
	PLine plCross(ptDrill-vecX*dCrossSize,ptDrill+vecX*dCrossSize, ptDrill,ptDrill+vecY*dCrossSize);
	plCross.addVertex(ptDrill-vecY*dCrossSize);

// declare arrays to collect pline graphics
	PLine plGraphics[0];

// declare a pp which describes the boxed tool area
	PlaneProfile ppProtect(CoordSys(ptRef,vecXE, vecYE, vecZE));

// distribute crosses for every tool type
	Point3d ptCross = ptDrill;
	for(int i=0;i<nQty;i++)
	{
	// add dimRequest for non rectangular shapes
		if(nShape!=2)
		{
			mapRequest.setPoint3d("ptLocation", ptCross);
			mapRequest.setVector3d("AllowedView", nSide*vecZ);
			// HSB-23869
			mapRequest.setString("Stereotype","hsbCLT-ElectraDimNonrect");
			mapRequests.appendMap("DimRequest", mapRequest);
		}
		
		if (dDiameter>dEps)
			plGraphics.append(plCross);
		plCross.transformBy(vecDistr*dOffsetInstallation);
		ptCross.transformBy(vecDistr*dOffsetInstallation);
	}
	
// declare the string which stores the width and height of rectangular shapes
	String sTxtLine1, sTxtLine2;
	
// tool drill	
	if (nShape==0 || (nShape==1 && nQty==1) )
	{
		PLine plCirc;
		plCirc.createCircle(ptDrill,vecZE,.5*dDiameter);
		Drill dr(ptDrill+vecZE*dEps,ptDrill-vecZE*dDepth, .5*dDiameter);
		
		for(int i=0;i<nQty;i++)
		{
			//dr.cuttingBody().vis(2);	plCross.vis(3);
			plCirc.vis(80);
			ppProtect.joinRing(plCirc,_kAdd);
			plGraphics.append(plCirc);
			//plGraphics.append(plCross);
			dr.addMeToGenBeamsIntersect(sips);
			dr.transformBy(vecDistr*dOffsetInstallation);
			plCirc.transformBy(vecDistr*dOffsetInstallation);
			//plCross.transformBy(vecDistr*dOffsetInstallation);
		}
	}
// tool slotted hole	
	else if (nShape==1)
	{
		Vector3d vecYDistr = vecDistr.crossProduct(-vecZE);
		vecDistr.normalize();
		vecYDistr.normalize();
		vecZE.normalize();
		
		Point3d ptMs = _Pt0;
	
		double dY = dDiameter;
		double dX = dOffsetInstallation*(nQty-1)+dY;
		PLine pl(vecZE);
		Point3d pt=ptStart;
		vecDistr.vis(pt,1);
		vecYDistr.vis(pt,3);
		vecZE.vis(pt,150);
		
		ptStart.vis(30);
		if (nAlign==1)
		{
			ptMs = ptMs + vecDistr*.5*dOffsetInstallation;
			if (nQty==3 || nQty ==5)
			{
				ptMs.transformBy(-vecY*.5*dOffsetInstallation);
			}
		}
	
		
	// add mortise
		if (dX>dEps && dY>dEps && dDepth*2>dEps)
		{ 
			Mortise ms (ptMs, vecDistr, vecYDistr,-vecZE, dX, dY, dDepth*2, 0,0,0);
			
			ms.setEndType(_kFemaleSide);
			ms.setRoundType(_kRound);
			Body bdTool = ms.cuttingBody();
			bdTool.vis(6);
			ms.addMeToGenBeamsIntersect(sips);		
			
			pt.vis(30);
			
			pt.transformBy(-.5*vecYDistr*dY);pt.vis(1);
			pl.addVertex(pt);
			pt.transformBy(vecYDistr *dY);pt.vis(2);
			pl.addVertex(pt,-1);
			pt.transformBy(vecDistr*(dX-dY));pt.vis(3);					
			pl.addVertex(pt);	
			pt.transformBy(-vecYDistr *dY);	pt.vis(4);	
			pl.addVertex(pt,-1);
			pl.close();
			pl.vis(5);	
			ppProtect.joinRing(pl,_kAdd);
			plGraphics.append(pl);			
		}
	}
// tool rectangular	
	else if (nShape==2)
	{
		Vector3d vecYDistr = vecDistr.crossProduct(-vecZE);
		double dY = dDiameter;
		double dX = dOffsetInstallation*(nQty-1)+dY;
		Point3d pt = ptStart-vecDistr*.5*dDiameter;
		//pt.vis(4);
		PLine pl;
		if (dX>dEps && dY>dEps && dDepth>dEps)
		{			
			BeamCut bc(pt, vecDistr, vecYDistr, vecZE,dX, dY,dDepth*2, 1,0,0);
			bc.cuttingBody().vis(3);
			// HSB-24009
			Map mapXtoolSocket;
			mapXtoolSocket.setInt("bRectangularSocket",true);
			bc.setSubMapX("ToolInfo",mapXtoolSocket);
			bc.addMeToGenBeamsIntersect(sips);

		}

		if (dX>dEps && dY>dEps)
		{
			pl.createRectangle(LineSeg(pt-.5*(vecYDistr*dY),pt+vecDistr*dX+.5*vecYDistr*dY), vecDistr, vecYDistr);
			ppProtect.joinRing(pl,_kAdd);		
			//pl.vis(5);	
			plGraphics.append(pl);			

		// format dimensions
			String s;
			s.formatUnit(dX, sDimStyle);
			sTxtLine2 = s;
			s.formatUnit(dY, sDimStyle);
			sTxtLine2 += "x"+s;	
	
		// append the diagonal as dimrequests
			mapRequest.setPoint3d("ptLocation", pt-.5*vecYDistr*dY);
			mapRequest.setVector3d("AllowedView", nSide*vecZ);
			mapRequests.appendMap("DimRequest", mapRequest);		 
	
			mapRequest.setPoint3d("ptLocation", pt+vecDistr*dX + .5*vecYDistr*dY-vecZE*dDepth);
			// HSB-23869
			mapRequest.setString("Stereotype","hsbCLT-ElectraDimRect");
			mapRequests.appendMap("DimRequest", mapRequest);
		}
	}	
	
// grow the protection area  by 10mm and publish the outer contour for other instances
	ppProtect.shrink(-U(10));
	PLine plProtect;
	plProtect.createRectangle(ppProtect.extentInDir(vecX), vecX, vecY);
	plProtect.vis(251);
	
// declare and draw plan view guide line
	PLine plGuidePlan(ptRef, _PtG[0]);//plGuidePlan.vis(2);
	if (plGuidePlan.length()>dTxtH)
		dpPlan.draw(plGuidePlan);

// set flag for multiline display
	double dYFlag,dXFlag=1.1, dXFlagElem = 1.1;
	if (sTxtLine2.length()>0)	dYFlag=1.5;

// string builder
	String sTxt1,sTxt2,sTxt3, sTxtElem, sTxt4, sTxtTmp;
	double dTxtL1,dTxtL2,dTxtL3, dTxtGap;
	sTxt1=nQty;
	dTxtL1 = dpPlan.textLengthForStyle(sTxt1,sDimStyle)/dFactor;
	sTxt2=sAlign.left(1).makeUpper();
	dTxtL2 = dpPlan.textLengthForStyle(sTxt2,sDimStyle)/dFactor;	
	sTxt3.formatUnit(dElevation,sDimStyle);
	
	
// Don´t show sOffsetInstallation if the quatity is less than two. HSB-9190
	String sSplit[]=sFormat.tokenize(")");
	String sParsedFormat;
	
	for(int i=0; i < sSplit.length();i++)
	{
		if(sSplit[i].find(sOffsetInstallationName, 0) > -1 && sSplit[i].find("@",0) > -1 && nQty < 2)
		{
			String sSuffixs[] = sSplit[i].tokenize(" ");
			
			for(int j=0; j < sSuffixs.length(); j++)
			{
				if(sSuffixs[j].find("@",0) > -1 || sSuffixs[j].find(":",0) > -1)
				{
					continue;				
				}
				else
					sParsedFormat += " " + sSuffixs[j];
			}
			continue;			
		}
			
		if(i == sSplit.length()-1)
		{
			String sRight = sFormat.right(1);
			sParsedFormat += (sRight == ")")? sSplit[i] +")" : sSplit[i];
		}
		else
			sParsedFormat += sSplit[i] +")";
	}
	
	sTxtLine1 = _ThisInst.formatObject(sParsedFormat);// HSB-8264

	sTxt3 = "_" + T("|h=|")+sTxt3;
	dTxtL3 = dpPlan.textLengthForStyle(sTxt3,sDimStyle)/dFactor;
	dTxtGap = dpPlan.textLengthForStyle("..",sDimStyle)/dFactor;

// default location of text in element view
	Point3d ptTxtElement = ptGuideE ;
	
// declare the protection ranges of plan and element view
	PLine plProtectPlan, plProtectElement;
	double dXProtectElement,dYProtectElement;	
	dXProtectElement = dXFlag*dTxtL3;
	dYProtectElement = dTxtH;
	if (sTxtLine2.length()>0)// multi line display plan enad element view
	{
		double d = dpElement.textLengthForStyle(sTxtLine2,sDimStyle)/dFactor;
		if (d>dXProtectElement)
			dXProtectElement =d;
		dYProtectElement *=dYFlag*2;	
	}

// element view protection range
	Point3d ptElement2 =ptTxtElement+vecX*nSide*dXProtectElement ; 
	plProtectElement.createRectangle(LineSeg(ptTxtElement-vecY*.5*dYProtectElement ,ptElement2 +vecY*.5*dYProtectElement ), vecX,vecY);	
	plProtectElement.vis(22);
		
// on creation, debug and recalc collect other instances of theis sip or element
	Vector3d vecMoveElementView= _Map.getVector3d("vecMoveElementView");
	if (bTestInterference)
	{
	// collect other electra instances which operate on the same set of panels or the same element
		TslInst tslOthers[0];
		PlaneProfile ppOthers(CoordSys(ptRef,vecXE, vecYE, vecZE));
		String s1 = scriptName();
		
		if (elThis.bIsValid())
			tslOthers.append(elThis.tslInst());
		else
		{
			for (int i=0;i<sips.length();i++)
			{	
				Entity entTools[] = sips[i].eToolsConnected();	
				for (int e=0;e<entTools.length();e++)
				{
					TslInst tsl = (TslInst)entTools[e];
					if (tsl.bIsValid())	tslOthers.append(tsl);
				}
			}
		}
	// remove this inst and all other non electra instances
		for (int e=tslOthers.length()-1;e>=0;e--)
		{
			TslInst tsl = tslOthers[e];
			double dXOffset = abs(vecX.dotProduct(_Pt0-tsl.ptOrg()));
			String s2 = tsl.scriptName();
			if (tsl==_ThisInst || (s1=="__HSB__PREVIEW" && s2!="hsbCLT-Electra") ||	(s2!=s1 && s1!="__HSB__PREVIEW") || dXOffset>2*dXProtectElement)
			{
				tslOthers.removeAt(e);		
			}			
			else
			{
				tsl.ptOrg().vis(222);
				Map map = tsl.map();
				PLine pl = map.getPLine("plProtectElement"); pl.vis(222);
				ppOthers.joinRing(pl, _kAdd);
				ppOthers.joinRing(map.getPLine("plProtect"), _kAdd);
			}
		}

	// define mirr transformations
		CoordSys csV, csH;
		csH.setToMirroring(Plane(_Pt0, vecX));
		csV.setToMirroring(Plane(_Pt0, vecY));

	// test intersection
		int nCnt, nDir=1;	
		PlaneProfile ppTest(plProtectElement);
		ppTest.intersectWith(ppOthers);
		int nX;
		
		while(nCnt<42 && ppTest.area()<plProtectElement.area() && ppTest.area()>pow(dEps,2))
		{
			//reportMessage("\ntest = " + ppTest.area() + " pro= " + plProtectElement.area());
			if (nDir==1)
				plProtectElement.transformBy(csH);
			else if (nDir==-1)
			{
				if (nCnt==1)
					plProtectElement.transformBy(vecY*dTxtH);
				else if (nX!=1)	
					plProtectElement.transformBy(csV);
				else
				{
					if (nCnt!=1)
						plProtectElement.transformBy(csV);
					plProtectElement.transformBy(vecY*dTxtH);	
				}
			}
			nX++;
			if(nX>3)nX=0;
			nDir*=-1;				
			nCnt++;	
			plProtectElement.vis(nCnt);
			ppTest=PlaneProfile(plProtectElement);
		// make sure transformation will below element base
			if (vecY.dotProduct(ppTest.extentInDir(vecX).ptMid()-ptOrg)<0)
			{
				continue;
			}
			else
			{
				ppTest.intersectWith(ppOthers);
			}
		}
		//ppOthers.vis(6);
		PlaneProfile pp(plProtectElement);
		LineSeg seg = pp.extentInDir(vecX);
		//seg.vis(6);
		
		vecMoveElementView=(seg.ptMid()-vecX*.5*abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd())))-ptTxtElement;
		_Map.setVector3d("vecMoveElementView",vecMoveElementView);
		_Map.removeAt("bTestInterference", true);
		setExecutionLoops(2);
	}	
	//plProtectElement.vis(2);
	if (0 && _bOnDebug)
	{
		dpElement.color(252);
		dpElement.draw(sTxtElem,ptTxtElement ,  vecX,vecY,dXFlagElem,dYFlag);	
		dpElement.color(nElemColor);
	}
	ptTxtElement.transformBy(vecMoveElementView);
	
// invert x orientation of element view description in dependency of location
	if (vecX.dotProduct(ptTxtElement-_Pt0)<0)
	{
		dXFlagElem*=-1;
		ptTxtElement.transformBy(vecX*dXProtectElement);
		CoordSys cs; cs.setToMirroring(Plane(_Pt0,vecX));
		ptGuideE.transformBy(cs);
	}

	PLine plGuideElement( ptGuideE-dXFlagElem*vecXE*dTxtH, ptTxtElement);//,ptGuideE
	dpElement.draw(plGuideElement);	//plGuideElement.vis(1);
	plGraphics.append(plGuideElement);


// loop graphics
	for (int i=0;i<plGraphics.length();i++)
	{
		PLine pl = plGraphics[i];
		mapRequest.setInt("DrawFilled", 0);
		mapRequest.setPLine("pline", pl);
		mapRequests.appendMap("DimRequest",mapRequest);
	
	// half filled in element view
		if (pl.area()>pow(dEps,2))
		{
			Point3d ptMid;
			ptMid.setToAverage(pl.vertexPoints(true));
			LineSeg seg(ptMid-vecX*nQty*dOffsetInstallation,ptMid+vecX*nQty*dOffsetInstallation+vecY*nSide*U(1000));
			PLine plRec;
			plRec.createRectangle(seg,vecX, vecY);
			PlaneProfile pp(plRec);
			pp.intersectWith(PlaneProfile(pl));
			pp.vis(2);
	
		// get half pline
			PLine plines[] = pp.allRings();
			if (plines.length()>0)
			{
				mapRequest.setInt("DrawFilled", _kDrawFilled);
				mapRequest.setPLine("pline", plines[0]);
				// HSB-23869
				mapRequest.setString("Stereotype","hsbCLT-ElectraPl");
				mapRequests.appendMap("DimRequest",mapRequest);
				dpElement.draw(pp,_kDrawFilled);
			}
		}
		
	// transform to plan view and draw
		if (i<plGraphics.length()-1)
		{
			pl.transformBy(cs2Plan);
			dpPlan.draw(pl);
		}
	}// next i

// set standard properties of an request
	mapRequest.removeAt("ptLocation", true);// reset for further requests
	mapRequest.setVector3d("AllowedView", vecZ);

// draw in element view and publish dimrequest text
	Map mapRequestTxt;
	mapRequestTxt.setPoint3d("ptScale", ptGuideE);		
	mapRequestTxt.setInt("deviceMode", _kDevice);		
	mapRequestTxt.setString("dimStyle", sDimStyle);	
	mapRequestTxt.setInt("Color", nElemColor);
	mapRequestTxt.setVector3d("AllowedView", vecZ);				
	mapRequestTxt.setPoint3d("ptLocation",ptTxtElement );		
	mapRequestTxt.setVector3d("vecX", vecX);
	mapRequestTxt.setVector3d("vecY", vecY);
	mapRequestTxt.setDouble("textHeight", dTxtH);
	mapRequestTxt.setDouble("dXFlag", dXFlagElem);
	mapRequestTxt.setDouble("dYFlag", dYFlag);			
	mapRequestTxt.setString("text", sTxtLine1);
	// HSB-23869
	mapRequest.setString("Stereotype","hsbCLT-ElectraTxt");
	mapRequests.appendMap("DimRequest",mapRequestTxt);
	
	dpElement.draw(sTxtLine1,ptTxtElement ,  vecX,vecY,dXFlagElem,dYFlag);

// plan view
	ptGuideE.transformBy(cs2Plan);
	
		
// multi line display plan enad element view
	if (sTxtLine2.length()>0)
	{
		dpPlan.draw(sTxtLine2,ptGuidePlan2,  vecXRead,vecYRead,dXFlag,-dYFlag);
		dpElement.draw(sTxtLine2,ptTxtElement,  vecX,vecY,dXFlagElem,-dYFlag);
		mapRequestTxt.setDouble("dYFlag", -dYFlag);			
		mapRequestTxt.setString("text", sTxtLine2);	
		mapRequests.appendMap("DimRequest",mapRequestTxt);		
	}	

	
// invert alignment
	if (vecXE.dotProduct(vecXRead)<0)dXFlag*=-1;
	if (!vecYPlanRead.bIsZeroLength())ptGuideE.transformBy(vecYPlanRead);
	dpPlan.draw(sTxtLine1,ptGuidePlan2,  vecXRead,vecYRead,nSide*dXFlag,dYFlag);
	

// plan view protection range
	Point3d ptPlan2 =ptGuideE+vecXRead*nSide*dXFlag*dTxtL3; 
	plProtectPlan.createRectangle(LineSeg(ptGuideE -vecYRead*.5*dTxtH,ptPlan2 +vecYRead*.5*dTxtH), vecXRead,vecYRead);	
	plProtectPlan.vis(2);		
	
		
// END INSTALLATIONS	


// trigger add wirechase Note:  not implemented yet
	String sTriggerAddWirechase = T("|Define Wirechase|");
	//addRecalcTrigger(_kContext, sTriggerAddWirechase);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddWirechase )
	{
		
		EntPLine eplJig;
		Point3d ptLast = ptWirechase;	
		Point3d pts[]= {ptWirechase};
		PLine plDefining;
		while (1) 
		{
			String sMsg = T("|Select next point|");
			if (pts.length()==1 && bHasDefiningPLine)sMsg += ", " + T("|<Enter> to remove current definition|");
			PrPoint ssP("\n" + sMsg,ptLast); 
			if (ssP.go()==_kOk) 
			{
			// delete a potential jig	
				if (eplJig.bIsValid())eplJig.dbErase(); 
			// do the actual query
				ptLast = ssP.value(); // retrieve the selected point
				ptLast.transformBy(vecZ*vecZ.dotProduct(ptWirechase-ptLast));
				pts.append(ptLast); // append the selected points to the list of grippoints _PtG

				plDefining=PLine(vecZ);
				for (int i=0;i<pts.length();i++)
					plDefining.addVertex(pts[i]);
				eplJig.dbCreate(plDefining);
				eplJig.setColor(nElemColor);
			}
			// no proper selection
			else 
			{ 
			// delete a potential jig	
				if (eplJig.bIsValid())eplJig.dbErase();			
				break; // out of infinite while
			}
		}
		if (plDefining.length()<=dEps && bHasDefiningPLine)
			_Map.removeAt("plDefining",true);
		else if (plDefining.length()>dEps)
			_Map.setPLine("plDefining",plDefining);
			
		setExecutionLoops(2);
		return;
	}	

// collect all catalog entries and append to custom context to enable hsbRecalcWithKey
	addRecalcTrigger(_kContext, T("|Catalog Entries|"));
	String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
	for (int i=0;i<sEntries.length();i++)
		for (int j=0;j<sEntries.length()-1;j++)
			if(sEntries[j]>sEntries[j+1])sEntries.swap(j,j+1);
			
// arrange entries alphabetically
	for (int i=0;i<sEntries.length();i++)
	{
		String sEntry = sEntries[i];
		if (sEntry==T("|_LastInserted|") || sEntry==T("|_Default|"))continue;
		addRecalcTrigger(_kContext, "   " + sEntry);	
	}

// context trigger fired
	if (_bOnRecalc && sEntries.find(_kExecuteKey.trimLeft())>-1)
	{
		double dThisElevation = dElevation;
		setPropValuesFromCatalog(_kExecuteKey);
		dElevation.set(dThisElevation);
		_Map.setInt("AddHardware", true);			
		setExecutionLoops(2);
		return;
	}
	
	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
	
	// Find sip if elements have been selected
		if(! sipLinked.bIsValid())
		{
			for(int i=0; i < sips.length(); i++)
			{
				int bBreak;
				Entity ents[] = sips[i].eToolsConnected();
				
				for (int j=0;j<ents.length();j++) 
				{ 
					if(ents[j] == _ThisInst)
					{
						sipLinked = sips[i];
						bBreak = true;
						break;
					}
				}//next j
				if(bBreak)
					break;
			}
		}
	
	// declare the groupname of the hardware components
		String sHWGroupName;

		// set group name
		{ 
		// element
			// try to catch the element from the parent entity
			Element elHW = sipLinked.element(); 
		
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
		
	// add main componnent
		{ 
			HardWrComp hwc;
				
			if (nQty > 0)
			{
				String sHWName = sShape;
				int nHWQty = nQty;
				double dX = dDiameter;
				
				if (nShape > 0)
				{
					sHWName = sHWName + " x " + nQty;
					nHWQty = 1;
					dX = nQty * dOffsetInstallation + dDiameter;
				}
	
				hwc = HardWrComp (sHWName, nHWQty); // the articleNumber and the quantity is mandatory HSB-7378 
				
				double dXDia = (nShape == 0)? dDiameter : nQty*dOffsetInstallation + dDiameter;
				hwc.setDScaleX(dXDia);
				hwc.setDScaleY(dDiameter);
				hwc.setDScaleZ(dDepth);		
				hwc.setName(sHWName);		
			}
			else
			{
				String sHWName = T("|Wirechase|");
				int nHWQty = 1;
	
				hwc = HardWrComp (sHWName, nHWQty); // the articleNumber and the quantity is mandatory HSB-7378 
				
				hwc.setDScaleX(dXBc);
				hwc.setDScaleY(dYBc);
				hwc.setDScaleZ(dZBc);		
				hwc.setName(sHWName);		
			}			
				hwc.setGroup(sHWGroupName);
				hwc.setCategory(sCategoryOutput);
				hwc.setLinkedEntity(sipLinked);						
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components	
	
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
		//endregion
	
		
// publish
	_Map.setMap("DimRequest[]", mapRequests);		
	_Map.setVector3d("vzE", vecZE);// publish tool vec Z for other tsl's
	_Map.setPLine("plProtectPlan", plProtectPlan);
	_Map.setPLine("plProtect", plProtect);
	_Map.setPLine("plProtectElement", plProtectElement);


	Map mapDevice;
	mapDevice.setString("Shape",sShape);
	_ThisInst.setSubMapX(sCategoryOutput,mapDevice);	
	
		













#End
#BeginThumbnail
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
I)HU@T"S27$LLTD\\\@`:21V+,<#@#G`'8`#M6A10`4444`%%%%`'_]D`
















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
        <int nm="BreakPoint" vl="1699" />
        <int nm="BreakPoint" vl="1697" />
        <int nm="BreakPoint" vl="1699" />
        <int nm="BreakPoint" vl="1255" />
        <int nm="BreakPoint" vl="1697" />
        <int nm="BreakPoint" vl="1255" />
        <int nm="BreakPoint" vl="1264" />
        <int nm="BreakPoint" vl="955" />
        <int nm="BreakPoint" vl="1605" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24009: write flag in mapX for rectangular sockets" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="5/22/2025 2:24:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23869: Add stereotypes" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="4/22/2025 5:33:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22525: Use triangles for the stretching/&quot;edit in place&quot; grips" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="10/25/2024 8:58:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22525: Use arrow grip shape for &quot;Edit in place&quot; grips; use color 4 to indicate stretch grip" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/9/2024 2:56:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22525: Add command &quot;Edit in place&quot;/&quot;Disable edit in place&quot;" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/2/2024 1:42:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21969: fix when draging grip point" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/3/2024 4:51:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21969: Show reportnotice if no tagging possible" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/2/2024 10:56:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21889: Add command to tag/untag wirechase conduit beamcuts" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/23/2024 10:44:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18037: Add drill function for cable duct" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/16/2024 10:20:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21382: Fix property names to resolve formatting problems" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/8/2024 1:05:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21382: Add grip points as Grip" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/7/2024 2:43:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15172 bugfix wirechase on beveled edges" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/11/2022 8:08:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11456 tool  references purged when moved by base point and linked to an element " />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/9/2021 10:25:08 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End