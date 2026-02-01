#Version 8
#BeginDescription
#Versions
Version 8.6 08/10/2025 HSB-24692: Anchor bolt: Fix depth in terms of bolt offset; fix drill position from edge in terms of OffsetEdgeOverride , Author Marsel Nakuci
Version 8.5 07.10.2025 HSB-24692: Fix when applying ZOffsetRabbetEdge at beveled edges , Author: Marsel Nakuci
Version 8.4 10/09/2025 HSB-24493: Add criteria for thickness in xml "MinThickness", "MaxThickness" , Author Marsel Nakuci
Version 8.3 20/08/2025 HSB-24434: Improve function for getting realBody of panel , Author Marsel Nakuci
Version 8.2 20/08/2025 HSB-24434: Add warning fro lifting strap at walls when different lengths , Author Marsel Nakuci
Version 8.1 20/08/2025 HSB-24434: For walls make sure to get the highest point , Author Marsel Nakuci
Version 8.0 26.05.2025 HSB-24092 The tool now takes into account the contact surfaces of the reference and opposite sides to determine the edge clearances.

Version 7.12 28.04.2025 HSB-23963 new command to specify a secondary association, Text can be rotated and realigned with new parameters 'Rotation, XFlag, YFlag' supported on family level in subnode 'Text'
Version 7.11 08.01.2025 HSB-22470: Fix when finding edge point for "Steel anchor" (lifting bolt)
Version 7.10 05.12.2024 HSB-23000: save graphics in file for render in hsbView and make
Version 7.9 10.04.2024 HSB-21860 The current panel export functionality now includes support for the 'DataLink' reference, allowing the accessibility of properties pertaining to the appearance of the initial lifting device
Version 7.8 15.01.2024 HSB-21123 hardware exposure enhanced, properties may be specified per child
Version 7.7 26.10.2023 Schmid Schrauben Rapid T-Lift 12&16 added
Version 7.6 08.05.2023    HSB-18919 property 'MinThickness' excludes item selection if not matching panel thickness
Version 7.5 03.05.2022    HSB-15401 a new RMC toggle has been added to suppress/add tooling
Version 7.4 11.01.2021    HSB-14334: fix double drills
Version 7.3 26.11.2021    HSB-13393 supports tool description format export, new context commands to set, import and export settings
Version 7.2 22.07.2021    HSB-12569: replace old Sihga Pick with Pitzl powerclamp
Version 7.1 20.07.2021    HSB-12647 supporting custom families on lisp based insert
Version 7.0 20.07.2021    HSB-12630 bugfix empty selection set

Version 6.9 19.07.2021    HSB-12630 single panel selection allowws multiple insert with different lifting direction
Version 6.8 07.06.2021    HSB-10390: use the translated family name when finding family from execute key




















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 8
#MinorVersion 6
#KeyWords lifting device;CLT;strap;Würth;Steel anchor;Rampa
#BeginContents
//region PART 1

//region History
// #Versions
// 8.6 08/10/2025 HSB-24692: Anchor bolt: Fix depth in terms of bolt offset; fix drill position from edge in terms of OffsetEdgeOverride , Author Marsel Nakuci
// 8.5 07.10.2025 HSB-24692: Fix when applying ZOffsetRabbetEdge at beveled edges , Author: Marsel Nakuci
// 8.4 10/09/2025 HSB-24493: Add criteria for thickness in xml "MinThickness", "MaxThickness" , Author Marsel Nakuci
// 8.3 20/08/2025 HSB-24434: Improve function for getting realBody of panel , Author Marsel Nakuci
// 8.2 20/08/2025 HSB-24434: Add warning fro lifting strap at walls when different lengths , Author Marsel Nakuci
// 8.1 20/08/2025 HSB-24434: For walls make sure to get the highest point , Author Marsel Nakuci
// 8.0 26.05.2025 HSB-24092 The tool now takes into account the contact surfaces of the reference and opposite sides to determine the edge clearances. , Author Thorsten Huck
// 7.12 28.04.2025 HSB-23963 new command to specify a secondary association, Text can be rotated and realigned with new parameters 'Rotation, XFlag, YFlag' supported on family level in subnode 'Text'. , Author Thorsten Huck
// 7.11 08.01.2025 HSB-22470: Fix when finding edge point for "Steel anchor" (lifting bolt) Author: Marsel Nakuci
// 7.10 05.12.2024 HSB-23000: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 7.9 10.04.2024 HSB-21860 The current panel export functionality now includes support for the 'DataLink' reference, allowing the accessibility of properties pertaining to the appearance of the initial lifting device. , Author Thorsten Huck
// 7.8 15.01.2024 HSB-21123 hardware exposure enhanced, properties may be specified per child , Author Thorsten Huck
// 7.7 26.10.2023 HSB-20473 Schmid Schrauben Rapid T-Lift 12&16 added, Author Stefan Kärger
// 7.6 08.05.2023 HSB-18919 property 'MinThickness' excludes item selection if not matching panel thickness , Author Thorsten Huck
// 7.5 03.05.2022 HSB-15401 a new RMC toggle has been added to suppress/add tooling , Author Thorsten Huck
// 7.4 11.01.2021 HSB-14334: fix double drills, Author Marsel Nakuci
// 7.3 26.11.2021 HSB-13393 supports tool description format export, new context commands to set, import and export settings , Author Thorsten Huck
// Version 7.2 22.07.2021 HSB-12569: replace old Sihga Pick with Pitzl powerclamp Author: Marsel Nakuci
// 7.1 20.07.2021 HSB-12647 supporting custom families on lisp based insert , Author Thorsten Huck
// 7.0 20.07.2021 HSB-12630 bugfix empty selection set , Author Thorsten Huck
// 6.9 19.07.2021 HSB-12630 single panel selection allowws multiple insert with different lifting direction , Author Thorsten Huck
// Version 6.8 07.06.2021 HSB-10390: use the translated family name when finding family from execute key  Author: Marsel Nakuci
/// <version value="6.7" date="19aug2020" author="thorsten.huck@hsbcad.com"> bugfix HSBCAD-8611 bugfix range detection </version>
/// <version value="6.6" date="20apr2020" author="thorsten.huck@hsbcad.com"> bugfix HSBCAD-6791 family assignment fixed with localized ribbon commands using the <Family>?<CatalogEntry> syntax </version>
/// <version value="6.5" date="11mar2020" author="thorsten.huck@hsbcad.com"> bugfix HSBCAD-6958 wall associations consider surface quality for default side </version>
/// <version value="6.4" date="06feb2020" author="thorsten.huck@hsbcad.com"> HSB-6558 hardware output changed to type tsl, parent panel added to output</version>
/// <version value="6.3" date="12sep2019" author="thorsten.huck@hsbcad.com"> bugfix HSBCAD-5563 </version>
/// <version value="6.2" date="17sep2019" author="thorsten.huck@hsbcad.com"> bugfix HSBCAD-5563, Family names are translated if embraced with pipes, HSB-5672 supports default settings from <hsbcad>\content\general\tsl\settings </version>
/// <version value="6.1" date="12sep2019" author="thorsten.huck@hsbcad.com"> bugfix HSBCAD-5563 </version>
/// <version value="6.0" date="05sep2019" author="thorsten.huck@hsbcad.com"> HSBCAD-5563, HSBCAD-5570, HSB-5562 new variable 'InterdistanceAngle' exposed to a child to specify an rotation angle of potential double drills,new variable 'HideDescriptionShopdraw' exposed to a family to hide description in shopdrawings, new variable 'MaxRange' exposed to a general, family and child level as cascading definition to specify a maximal range of device intersecrtion. This tool requires at least build 21.4.41 or hsbDesign22 build 22.0.75. </version>
/// <version value="5.9" date="13may2019" author="thorsten.huck@hsbcad.com"> HSBCAD-5019 bugfix variable 'MinThickness' </version>
/// <version value="5.8" date="13may2019" author="thorsten.huck@hsbcad.com"> HSBCAD-5019 new variable 'MinThickness' to specify minimal required panel thickness for each child of any family. If not specified thickness test will be disabled </version>
/// <version value="5.7" date="23apr2019" author="thorsten.huck@hsbcad.com"> HSBCAD-311 default edge offset value of type 'Sihga Pick' (walls) changed to 250mm, customer overrides can be set through catalog values </version>
/// <version value="5.6" date="16apr2019" author="thorsten.huck@hsbcad.com"> new default type 'Sihga Pick' added, insert mechanism enhanced </version>
/// <version value="5.5" date="27mar2019" author="thorsten.huck@hsbcad.com"> rule type 'lifting steel anchor' new parameter "ZOffsetRabbetEdge" specifies additional offset of edge drill against a potential rabbet edge to avoid oscillation issues </version>
/// <version value="5.4" date="27mar2019" author="thorsten.huck@hsbcad.com"> rule type 'lifting strap': if in range of an opening the device can be replaced by a tool free device. The article will be prefixed with an 'L' to indicate the loose state with upon request</version>
/// <version value="5.3" date="04jul2018" author="thorsten.huck@hsbcad.com"> properties fixed for tsl manager usage </version>
/// <version value="5.2" date="17apr2018" author="thorsten.huck@hsbcad.com"> steel anchor non orthogonal edges fixed </version>
/// <version value="5.1" date="17apr2018" author="thorsten.huck@hsbcad.com"> optional marking drill uses optional parameters from hsbGrainDirection settings. settings file location generalized to company\tsl\settings, supports hsbtslSettingsIO </version>
/// <version value="5.0" date="21feb2018" author="thorsten.huck@hsbcad.com"> bugfix II tolerance additional marking drill </version>
/// <version value="4.9" date="21feb2018" author="thorsten.huck@hsbcad.com"> bugfix tolerance additional marking drill </version>
/// <version value="4.8" date="21feb2018" author="thorsten.huck@hsbcad.com"> new context commands to add and set an additional marking drill for family rule 0 in roof/floor association </version>
/// <version value="4.7" date="11dec2017" author="thorsten.huck@hsbcad.com"> edit in place supports the changing or adding lifting directions, bugfix rule steel anchor on roof/floor associations </version>
/// <version value="4.6" date="11dec2017" author="thorsten.huck@hsbcad.com"> edit in place supports the changing of the selected family </version>
/// <version value="4.5" date="14Oct2017" author="thorsten.huck@hsbcad.com"> bugfix steel anchor </version>
/// <version value="4.4" date="12Oct2017" author="thorsten.huck@hsbcad.com"> bugfix small wall panels </version>
/// <version value="4.3" date="21Sep2017" author="thorsten.huck@hsbcad.com"> bugfix small wall panels orientation steel anchor </version>
/// <version value="4.2" date="20Sep2017" author="thorsten.huck@hsbcad.com"> bugfix small wall panels offset </version>
/// <version value="4.1" date="09aug2017" author="thorsten.huck@hsbcad.com"> Steel anchor, child rule 1, edit in place supports small wings of panel location </version>
/// <version value="4.0" date="08aug2017" author="thorsten.huck@hsbcad.com"> tolerance workaround added to parallelism test </version>
/// <version value="3.9" date="08aug2017" author="thorsten.huck@hsbcad.com"> new child rule type '1': edge drill considers bounding box to specify start point of edge drill </version>
/// <version value="3.8" date="08aug2017" author="thorsten.huck@hsbcad.com"> new child rule type '1' supports edit in place to override extreme boundary locations </version>
/// <version value="3.7" date="24jul2017" author="thorsten.huck@hsbcad.com"> bugfix </version>
/// <version value="3.6" date="24jul2017" author="thorsten.huck@hsbcad.com"> new child rule type '1' locations strictly set to extreme boundaries </version>
/// <version value="3.5" date="21jul2017" author="thorsten.huck@hsbcad.com"> new child rule type '1' added to support steel anchors at upper panel corners when associated to a wall </version>
/// <version value="3.4" date="26may2017" author="thorsten.huck@hsbcad.com"> rule type 'Steel anchor' peg drill length extended if placement at tongue/groove (male and female side) </version>
/// <version value="3.3" date="24may2017" author="thorsten.huck@hsbcad.com"> rule type 'Steel anchor' peg drill length extended if placement at tongue/groove </version>
/// <version value="3.2" date="24may2017" author="thorsten.huck@hsbcad.com"> rule type 'Würth' orientation of quader tool shapes on gable walls with bevels fixed II </version>
/// <version value="3.1" date="24may2017" author="thorsten.huck@hsbcad.com"> rule type 'Steel anchor' male axis location corrected </version>
/// <version value="3.0" date="23may2017" author="thorsten.huck@hsbcad.com"> rule type 'Würth' orientation of quader tool shapes on gable walls with bevels fixed </version>
/// <version value="2.9" date="23may2017" author="thorsten.huck@hsbcad.com"> case 4471 workaround implemented, remove if case is resolved </version>
/// <version value="2.8" date="23may2017" author="thorsten.huck@hsbcad.com"> rule type 'Steel anchor' new tests to relocate edge drill if tongue-groove connection applies </version>
/// <version value="2.7" date="03may2017" author="thorsten.huck@hsbcad.com"> rule type 'Würth' orientation of quader tool shapes on gable walls fixed </version>
/// <version value="2.6" date="02may2017" author="thorsten.huck@hsbcad.com"> interdistance honours edge offset, warning if placement outside of panel </version>
/// <version value="2.5" date="02may2017" author="thorsten.huck@hsbcad.com"> bugfix location on small triangular and small vertical wall panels </version>
/// <version value="2.4" date="04apr2017" author="thorsten.huck@hsbcad.com"> bugfix location on small panels </version>
/// <version value="2.3" date="27feb2017" author="thorsten.huck@hsbcad.com"> external parameters support 'Interdistance' and 'EdgeOffset', bugfix edge collection </version>
/// <version value="2.2" date="13feb2017" author="thorsten.huck@hsbcad.com"> bugfix rule 1: new dimension filtering set (sd_drillPattern). only main alignment is considered </version>
/// <version value="2.1" date="13feb2017" author="thorsten.huck@hsbcad.com"> new dimension filtering set (sd_drillPattern). only main alignment is considered </version>
/// <version value="2.0" date="08feb2017" author="thorsten.huck@hsbcad.com"> rule type 'Rampa' supports wall association with alignment to gable and bevel </version>
/// <version value="1.9" date="08feb2017" author="thorsten.huck@hsbcad.com"> lap detection supports edge offset of main drill if edge drill is within range of rabbet/lap tool </version>
/// <version value="1.8" date="08feb2017" author="thorsten.huck@hsbcad.com"> 'edit in place' supports all modes.  </version>
/// <version value="1.7" date="07feb2017" author="thorsten.huck@hsbcad.com"> rule type steel anchor supports lap detection and repositioning </version>
/// <version value="1.6" date="07feb2017" author="thorsten.huck@hsbcad.com"> new context command 'edit in place' creates single devices </version>
/// <version value="1.5" date="06feb2017" author="thorsten.huck@hsbcad.com"> new methods to influece text display in shopdrawing (sd_drillPattern) </version>
/// <version value="1.4" date="06feb2017" author="thorsten.huck@hsbcad.com"> device proper located with small panels, rampa rule type restriction removed, hardware export enabled </version>
/// <version value="1.3" date="20dec2016" author="thorsten.huck@hsbcad.com"> type based insertion added </version>
/// <version value="1.2" date="20dec2016" author="thorsten.huck@hsbcad.com"> loop type added, wall orientations fixed </version>
/// <version value="1.1" date="20dec2016" author="thorsten.huck@hsbcad.com"> steel anchor parameters modified </version>
/// <version value="1.0" date="20dec2016" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>
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
	String sAuto = T("|Automatic|");
	String sNA = T("|Not Applicable|");

//region Dialog Service
	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";	

	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType", kLabelType = "Label", kHeader = "Title", kIntegerBox = "IntegerBox", kTextBox = "TextBox", kDoubleBox = "DoubleBox", kComboBox = "ComboBox", kCheckBox = "CheckBox";
	String kHorizontalAlignment = "HorizontalAlignment", kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";	

//	String tToolTipColor = T("|Specifies the color of the override.|");
//	String tToolTipTransparency = T("|Specifies the level of transparency of the shape of the tool.|");	
//endregion 

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int darkgrey = rgb(173,173,173);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);
	int doveblue = rgb(106,172,215);	

	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int lightpetrol = rgb(61,194,192);
	
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 
	
	String kDataLink = "DataLink";
//end constants//endregion

//region Functions #FU

	//region General Functions
	
//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion	

//region visPp
	void visPp(PlaneProfile _pp,Vector3d _vec)
	{ 
		_pp.transformBy(_vec);
		_pp.vis(6);
		_pp.transformBy(-_vec);
		return;
	}
//End visPp//endregion

//region visBd
	void visBd(Body _bd, Vector3d _vec)
	{ 
		_bd.transformBy(_vec);
		_bd.vis(6);
		_bd.transformBy(-_vec);
		return;
	}
//end visBd//endregion

	//endregion 

	//region Map Functions

//region Function FilterChildsWithAssociation
	// returns a map with childs of the given association 1=wall, 2 = roof/floor
	// a negative value indicates that the filter works exclusivly
	Map FilterChildsWithAssociation(Map mapIn, int association)
	{ 
		Map mapOut, childs = mapIn.getMap("Child[]");	
		for (int i=0;i<childs.length();i++) 
		{ 
			Map child= childs.getMap(i);
			int assoc =child.getInt("Association"); 
			if (association>0 && assoc==association)
				mapOut.appendMap("Child", child); 
			else if (association<0 && (assoc!=-association || assoc==0)) // assoc = 0 means automatic, allows 1 or 2
				mapOut.appendMap("Child", child); 
		}//next i		
		return mapOut;
	}//endregion

//region Function FilterFamiliesWithAssociation
	// returns a map with families with childs of the given association 1=wall, 2 = roof/floor
	// a negative value indicates that the filter works exclusivly
	Map FilterFamiliesWithAssociation(Map mapIn, int association)
	{ 
		Map mapOut;
		Map families = mapIn.getMap("Family[]");	
		for (int i=0;i<families.length();i++) 
		{ 
			Map family= families.getMap(i);			
			Map childs = FilterChildsWithAssociation(family, association);	
			if (childs.length()>0)
				mapOut.appendMap("Family", family); 
		}//next i		
		return mapOut;		
	}//endregion
	
//region Function GetFamilyNames
	// returns the names of the families in the given map
	String[] GetFamilyNames(Map mapIn)
	{ 
		String names[0];
		for(int i=0;i<mapIn.length();i++)
		{
			Map family= mapIn.getMap(i);
			String name = T(family.getString("Name"));
			if (name.length()>0 && names.findNoCase(name,-1)<0)
				names.append(name);
		}
		return names;
	}//endregion	
			
	//endregion 

	//region Panel Functions

//region Function GetRealBody
	// returns the realbody of the panel excluding the tools of this inst
	int GetRealBody(Sip sip, Body& bdReal, Body& bdEnv, TslInst this)
	{ 
		bdEnv = sip.envelopeBody(false, true);
		bdReal = sip.realBodyTry(sip.vecX()+sip.vecY()+sip.vecZ());
		int bOk;
		AnalysedTool tools[] = sip.analysedTools();
		for (int i=tools.length()-1; i>=0 ; i--) 
			if (tools[i].toolEnt() != this)
				tools.removeAt(i);
		AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);		
		for (int i=0;i<drills.length();i++) 
		{ 
			AnalysedDrill t = drills[i];			
			Body bd(t.ptStartExtreme(),t.ptEndExtreme(), t.dRadius()+dEps);
			int bIntersect=bd.intersectWith(bdEnv);
			double dVolPrev=bdReal.volume();
			bdReal.addPart(bd);	
			if(dVolPrev>bdReal.volume()+pow(U(10),3))
			{ 
				bOk=false;
			}
		}//next i

		AnalysedBeamCut beamcuts[]= AnalysedBeamCut().filterToolsOfToolType(tools);		
		for (int i=0;i<beamcuts.length();i++) 
		{ 
			AnalysedBeamCut t = beamcuts[i];			
			Quader q = t.quader();
			Body bd(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
			int bIntersect=bd.intersectWith(bdEnv);
			double dVolPrev=bdReal.volume();
			bdReal.addPart(bd);
			if(dVolPrev>bdReal.volume()+pow(U(10),3))
			{ 
				bOk=false;
			}
		}//next i

		return bOk;
	}//endregion

//region Function CollectPanels
	// returns the panels which are referenced by the given entities
	void CollectPanels(Sip& panels[], Entity ents[])
	{ 
		for(int i = 0;i <ents.length();i++)
		{
			if(ents[i].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)ents[i];
				if (panels.find(sip)<0)
					panels.append(sip);
			}
			else if(ents[i].bIsKindOf(Element()))
			{
				Element el = (Element)ents[i];
				Sip childs[]=el.sip();
				for(int c= 0;c<childs.length();c++)
				{
					Sip sip = childs[c];					
					if (panels.find(sip)<0) 
						panels.append(sip);
				}					
			}
		}		
		return;
	}//endregion

//region Function GetSiblings
	// returns all tsl instances with a certain scriptname
	// sip: the panel to get the siblings from
	// name: the name of the tsl to be returned
	TslInst[] GetSiblings(Sip sip, String name)
	{ 
		TslInst out[0];

		Entity ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
		String names[] = { name};
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i];
			if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)>-1)
			{ 
				GenBeam gbs[] = t.genBeam();
				if (gbs.find(sip)>-1)
					out.append(t);
			}
					
		}//next i

		return out;
	
	}//End GetSiblings //endregion	
	
//region calcBodyWithoutLiftingTools1

// returns the body without the
// lifting tools
// returns planeprofile of tools
// pp of body without tools
	Map calcBodyWithoutLiftingTools1(Sip _sip,Body& _bdRealNoLifting,
		PlaneProfile& _ppTools, PlaneProfile& _ppNoTools,TslInst this)
	{ 
		Map _mOut;
		
		Vector3d _vx=_sip.vecX();
		Vector3d _vy=_sip.vecY();
		Vector3d _vz=_sip.vecZ();
		Point3d _ptCen=_sip.ptCen();
		double _dH=_sip.dH();
		
//		Body _bdEnv=_sip.envelopeBody(true,false);
		Body _bdEnv=_sip.envelopeBody(false,false);
		
		Body _bdEnvEdges=_bdEnv;
		int _bEdgesSkewed;
		Body _bdEdges;
		// make sure it does not have edges skewed
		{ 
			PlaneProfile _ppShadow=_bdEnv.shadowProfile(Plane(_ptCen,_vz));
			PLine _plsOut[]=_ppShadow.allRings(true,false);
			PLine _plsOps[]=_ppShadow.allRings(false,true);
			
			Body _bd(_plsOut[0],_vz*_dH,0);
			for (int i=0;i<_plsOps.length();i++) 
			{ 
				Body _bdOp(_plsOps[i],_vz*_dH);
				_bd.subPart(_bdOp);
			}//next i
			
//			_bd.vis(6);
			if(abs(_bd.volume()-_bdEnv.volume())>pow(U(1),3))
			{ 
				// there are skewed edges
				// get the _bd
				_bdEnv=_bd;
				_bEdgesSkewed=true;
				_bdEdges=_bd;
				_bdEdges.subPart(_bdEnv);
			}
		}
		Body _bdEnvOrig=_bdEnv;
		_bdEnv=_bdEnvEdges;
		AnalysedTool tools[] = _sip.analysedTools();
		
		AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(tools);
		AnalysedDoubleCut doubleCuts[] = AnalysedDoubleCut().filterToolsOfToolType(tools);
		AnalysedMortise mortises[] = AnalysedMortise().filterToolsOfToolType(tools);
		AnalysedRabbet rabbets[] = AnalysedRabbet().filterToolsOfToolType(tools);
		AnalysedSlot slots[] = AnalysedSlot().filterToolsOfToolType(tools);
		AnalysedHouse houses[] = AnalysedHouse().filterToolsOfToolType(tools);
		AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);
		AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
		//HSB-12403
		AnalysedFreeProfile freeProfiles[] = AnalysedFreeProfile().filterToolsOfToolType(tools);
		AnalysedPropellerSurface propellerSurfaces[] = AnalysedPropellerSurface().filterToolsOfToolType(tools);
		//region apply tools
		for (int i=0;i<beamcuts.length();i++) 
		{ 
			Map _mi=beamcuts[i].mapInternal();
			BeamCut tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
			else
			{ 
				Body bdCut=beamcuts[i].cuttingBody();
				_bdEnv.subPart(bdCut);
			}
		}//next i
		for (int i=0;i<doubleCuts.length();i++) 
		{ 
			Map _mi=doubleCuts[i].mapInternal();
			DoubleCut tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		for (int i=0;i<mortises.length();i++) 
		{ 
			Map _mi=mortises[i].mapInternal();
			Mortise tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		for (int i=0;i<rabbets.length();i++) 
		{ 
			Map _mi=rabbets[i].mapInternal();
			Rabbet tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		for (int i=0;i<slots.length();i++) 
		{ 
			Map _mi=slots[i].mapInternal();
			Slot tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		for (int i=0;i<houses.length();i++) 
		{ 
			Map _mi=houses[i].mapInternal();
			House tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		for (int i=0;i<cuts.length();i++) 
		{ 
			Map _mi=cuts[i].mapInternal();
			Cut tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
			else
			{ 
				Cut ct(cuts[i].ptOrg(),cuts[i].normal());
				_bdEnv.addTool(ct);
			}
		}//next i
		for (int i=0;i<freeProfiles.length();i++) 
		{ 
			Map _mi=freeProfiles[i].mapInternal();
			FreeProfile tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		for (int i=0;i<propellerSurfaces.length();i++) 
		{ 
//			Map _mi=propellerSurfaces[i].mapInternal();
//			PropellerSurface tooli;
//			int bSuccess=tooli.setFromMap(_mi);
//			if(bSuccess)
//			{ 
//				_bdEnv.addTool(tooli);
//			}
			
			PropellerSurfaceTool p;
//			p.setFromMap(propellerSurfaces[it].mapInternal());
			
			// HSB-19191
			PLine plDefiningPropeller = propellerSurfaces[i].plDefining();
			PLine plBevelPropeller = propellerSurfaces[i].plBevel();
			Vector3d vecZPropeller = propellerSurfaces[i].vecZ();
			Vector3d vecSidePropeller = propellerSurfaces[i].vecSide();
			int nCncModePropeller = propellerSurfaces[i].nCncMode();
			int nMillSidePropeller = propellerSurfaces[i].nMillSide();
			
			p=PropellerSurfaceTool (plDefiningPropeller, plBevelPropeller, U(40), U(2));
			p.setCncMode(nCncModePropeller);
			p.setMillSide(nMillSidePropeller);
			//
			_bdEnv.addTool(p);
		}//next i
		for (int i=0;i<drills.length();i++) 
		{ 
			Map _mi=drills[i].mapInternal();
			if(drills[i].subMapXKeys().find("MapxToolType")>-1)
			{ 
				
				Map mxi=drills[i].subMapX("ToolType");
				if(mxi.getString("ToolType")=="hsbCLT-Lifter")
				{ 
					continue;
				}
			}
			if(drills[i].toolEnt()==this)
			{ 
				continue;
			}
			Drill tooli;
			int bSuccess=tooli.setFromMap(_mi);
			if(bSuccess)
			{ 
				_bdEnv.addTool(tooli);
			}
		}//next i
		//endregion apply tools
		
//		visBd(_bdEnv,_vz*U(600));
		
		_bdRealNoLifting=_bdEnv;
		Body _bdTools=_bdEnvOrig-_bdEnv;
//		PlaneProfile _ppTools=_bdTools.shadowProfile(Plane(_ptCen,_vz));
		_ppTools=_bdTools.shadowProfile(Plane(_ptCen,_vz));
		PlaneProfile _ppAll=_bdEnvOrig.shadowProfile(Plane(_ptCen,_vz));
//		PlaneProfile _ppNoTools=_ppAll;
		_ppNoTools=_ppAll;
		_ppNoTools.subtractProfile(_ppTools);

//		_mOut.setBody("bdRealNoLifting", _bdEnv);
//		_mOut.setPlaneProfile("ppTools", _ppTools);
//		_mOut.setPlaneProfile("ppNoTools", _ppNoTools);
		
		return _mOut;
	}
//End calcBodyWithoutLiftingTools1//endregion


//region drawError
// it draws the cross and the text of the error	
void drawError(Sip s, Map _min,Body b)
{ 
	Vector3d vx=s.vecX();
	Vector3d vy=s.vecY();
	Vector3d vz=s.vecZ();
	Point3d ptC=s.ptCen();
	
//	Body b;
//	if(_min.hasBody("bd"))
//		b=_min.getBody("bd");
//	else
//		b=s.envelopeBody();
	
	String _sError="Error";
	if(_min.hasString("sError"))
		_sError=_min.getString("sError");
	
	
	PlaneProfile ppShadow = b.shadowProfile(Plane(ptC,vz));
	LineSeg seg=ppShadow.extentInDir(vx);
	
	PLine pl;
	pl.addVertex(seg.ptStart());
	pl.addVertex(seg.ptEnd());
	pl.addVertex(seg.ptMid());
	seg = ppShadow.extentInDir(vy);
	pl.addVertex(seg.ptStart());
	pl.addVertex(seg.ptEnd());
	
	Vector3d vecXRead=-vx+vy;
	vecXRead.normalize();
	Vector3d vecYRead = vecXRead.crossProduct(-_ZW);
	vecYRead.normalize();
	Display dpErr(6);
	dpErr.draw(_sError, seg.ptMid(), vecXRead, vecYRead, 0, 0, _kDevice);
	dpErr.draw(pl);
	// HSB-24206
	if(_min.hasMap("mapWarningDisplays"))
	{ 
		Map _mapWarningDisplays=_min.getMap("mapWarningDisplays");
		for (int i=0;i<_mapWarningDisplays.length();i++) 
		{ 
			Map mi=_mapWarningDisplays.getMap(i);
			if(mi.hasPlaneProfile("pp"))
			{ 
				PlaneProfile _pp=mi.getPlaneProfile("pp");
				Display dpPp(6);
				dpPp.draw(_pp);
				dpPp.draw(_pp,_kDrawFilled);
			}
			if(mi.hasPLine("pl"))
			{ 
				PLine _pl=mi.getPLine("pl");
				Display dpPl(5);
				dpPl.draw(_pl);
			}
			if(mi.hasBody("bd"))
			{ 
				Body _bd=mi.getBody("bd");
				Display dpBd(6);
				dpBd.draw(_bd);
			}
		}//next m
	}
	
	return;
}
//End drawError//endregion

	
	//endregion 

//endregion #FU

//region Show lifting directions jig
	if (_bOnJig && _kExecuteKey == "ShowDirection")
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		PlaneProfile pp = _Map.getPlaneProfile("Shadow");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		double dL = _Map.getDouble("dL");
		int nMode = _Map.getInt("Mode");
		Point3d ptMid =_Map.getPoint3d("ptMid");;// pp.extentInDir(vecX).ptMid();
		Map mapDirections = _Map.getMap("LiftDirection[]");

		Line(ptJig, vecZ).hasIntersection(Plane(ptMid, vecZ), ptJig);
		
		double dW = dL * .2;
		
		Quader qdr(ptMid, vecX, vecY, vecZ, U(1), U(1), U(1), 0, 0, 0);
		
		Vector3d vecJig = ptJig - ptMid;
		if (vecJig.bIsZeroLength())vecJig = vecX;
		vecJig=qdr.vecD(vecJig);

		int nJigDir=-1;
		Vector3d vecLifts[0];

		for (int i=0;i<mapDirections.length();i++) 
		{
			Vector3d vec = mapDirections.getVector3d(i);
			vecLifts.append(vec); 
			if (vec.isCodirectionalTo(vecJig))
			{
				nJigDir =i;
			}
		}
			
	// add jig direction if missing		
		if (nJigDir<0)
		{
			vecLifts.append(vecJig);
			nJigDir = vecLifts.length() - 1;
		}
			
		Display dp(-1);
		

		for (int i=0;i<vecLifts.length();i++) 
		{ 
			Vector3d vecA = vecLifts[i];
			Vector3d vecB = vecA.crossProduct(-vecZ);

			PLine pl(vecZ);		
			pl.addVertex(ptMid+vecA*dL);
			pl.addVertex(ptMid+vecA*(dL-2*dW)+vecB*dW*2);
			pl.addVertex(ptMid+vecA*(dL-2*dW)+vecB*dW);
			pl.addVertex(ptMid+vecB*dW);
			pl.addVertex(ptMid-vecB*dW);
			pl.addVertex(ptMid + vecA * (dL - 2 * dW) - vecB * dW);
			pl.addVertex(ptMid+vecA*(dL-2*dW)-vecB*dW*2);			
			pl.close();
			pl.transformBy(vecA * dW);

			if (nMode==0)
				dp.trueColor(vecA.isCodirectionalTo(vecJig)?lightblue:red, 50);	

			else if (nMode>1)
				dp.trueColor(vecA.isCodirectionalTo(vecJig)?lightblue:red, 50);	
//			else if (nMode==2)
//			{
//				if (vecA.isCodirectionalTo(vecJig) && i==nJigDir)
//					dp.trueColor(red, 50);				
//
//				else
//					dp.trueColor(i==nJigDir?lightblue:green, 50);			
//			}
			dp.draw(PlaneProfile(pl),_kDrawFilled);
			dp.draw(pl);
			dp.textHeight(U(100));
			//dp.draw(i + "-" + nJigDir, ptMid+vecA*dL, _XW, _YW, 1, 0);
			 
		}//next i


		return;
	}		
//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey(_Map.hasString("opmKey")?_Map.getString("opmKey"):"Settings");

			
		category = T("|Tool Description|");
			String sFormatName=T("|Format|");	
			PropString sFormat(nStringIndex++, "@("+T("|Type|")+")", sFormatName);	
			sFormat.setDescription(T("|Defines the format which will be resolved to write the tool description.|") + 
				T(" |You can use format expressions like @(Type) to resolve any property of the TSL.|") + 
				T(" |Any text can be used as prefix or postfix.|"));
			sFormat.setCategory(category);

			String sMapNameName=T("|MapX Key|");	
			PropString sMapName(nStringIndex++, "TimberTec", sMapNameName);	
			sMapName.setDescription(T("|Defines the name of the mapX entry.|") + 
				T(" |This name needs to be set in conjunction with the entry name to resolve the tool description in an exporter definition.|"));
			sMapName.setCategory(category);
			
			String sEntryName=T("|Entry Name|");	
			PropString sEntry(nStringIndex++, "LiftingDevice", sEntryName);	
			sEntry.setDescription(T("|Defines the name of the entry.|")+
				T(" |This name needs to be set in conjunction with the mapX name to resolve the tool description in an exporter definition.|"));
			sEntry.setCategory(category);
		}
		return;
	}
//End DialogMode//endregion


//region Default map
	Map mapFamilies,mapDefault;
	String sFamilies[] = {T("|Lifting Strap|"), T("|Rampa|"), T("|Wuerth|"), T("|Steel Anchor|"), T("|Schmid Schrauben|")};
	String sPitzlName = "Pitzl";
	String sFamilyNames[] = {"Lifting Strap", "Rampa", "Wuerth", "Steel Anchor", "Schmid Schrauben",sPitzlName};// version value="6.6" bugfix HSBCAD-6791
	
// set Pitzl default	
	Map mapPitzl;
	{ 
		Map mapChild, mapChilds;
		
		mapChild.setString("Name", "Pitzl PC D40-90");
		mapChild.setInt("Color", 253);
		mapChild.setDouble("Diameter", U(40));
		mapChild.setDouble("Depth", U(93));
		mapChild.setDouble("MaxLoad", 1500);
		mapChild.setDouble("EdgeOffset", U(200));
		mapChild.setDouble("MinThickness", U(60));
		mapChild.setInt("Association", 1);
		mapChilds.appendMap("Child", mapChild);
		
		mapChild.setString("Name", "Pitzl PC D40-90");
		mapChild.setInt("Color", 253);
		mapChild.setDouble("Diameter", U(40));
		mapChild.setDouble("Depth", U(93));
		mapChild.setDouble("MaxLoad", 1500);
		mapChild.setDouble("EdgeOffset", U(200));
		mapChild.setDouble("MinThickness", U(60));
		mapChild.setInt("Association", 2);
		mapChilds.appendMap("Child", mapChild);
		
//		mapChild.setString("Name", "Sihga V");
//		mapChild.setInt("Color", 253);
//		mapChild.setDouble("Diameter", U(50));
//		mapChild.setDouble("Depth", U(75));
//		mapChild.setDouble("MaxLoad", 580);
//		mapChild.setDouble("EdgeOffset", U(250));
//		mapChild.setInt("Association", 1);
//		mapChilds.appendMap("Child", mapChild);
//		
//		mapChild.setString("Name", "Sihga H");
//		mapChild.setInt("Color", 253);
//		mapChild.setDouble("Diameter", U(50));
//		mapChild.setDouble("Depth", U(75));
//		mapChild.setDouble("MaxLoad", 810);
//		mapChild.setDouble("EdgeOffset", U(250));
//		mapChild.setInt("Association", 2);
//		mapChilds.appendMap("Child", mapChild);	
		
		mapPitzl.setString("Name", sPitzlName);
		mapPitzl.setInt("Rule", 1);
		mapPitzl.setMap("Child[]", mapChilds);	
	}

// loop default families	
	for(int i=0;i<sFamilies.length();i++)
	{
		Map f;
		f.setString("Name",sFamilies[i]);

		String childs[0];
		double dCLoads[0], diameters[0], depths[0];
		int assocs[0]; // 0 = auto, 1 = wall, 2 = roof/floor
		if (i==0)
		{
			String s[] = {"H1","H1.1", "H2","H2.1"};		childs = s;
			double d1[] = {800,2000, 1600,4000};			dCLoads= d1;
			double d2[] = {U(30),U(30), U(30),U(30)};	diameters= d2;
			double d3[] = {U(0),U(0), U(0),U(0)};			depths= d3;
			int n[] = {0,0,0,0};										assocs=n;
		}
		else if (i==1)
		{
			String s[] = {"R1", "R2", "R3"};					childs = s;
			double d1[] = {600,800,900};							dCLoads= d1;
			double d2[] = {U(15),U(15), U(15),U(15)};	diameters= d2;
			double d3[] = {U(60),U(60), U(60),U(60)};	depths= d3;
			int n[] = {0,0,0};											assocs=n;
		}
		else if (i==2)
		{
			String s[] = {"S1","S1.1", "S2","S2.1"};	childs = s;
			double d1[] = {800,1200,1600,4000};			dCLoads= d1;
			double d2[] = {U(99),U(99), U(99),U(9)};	diameters= d2;
			double d3[] = {U(30),U(30), U(30),U(30)};	depths= d3;
			int n[] = {0,0,0};										assocs=n;
		}
		else if (i==3)
		{
			String s[] = {"W1", "W2", "W3", "W4", "W4.1"};	childs = s;
			double d1[] = {300,500,800,600,600};			dCLoads= d1;
			double d2[] = {U(99),U(99), U(99),U(99),U(99)};	diameters= d2;
			double d3[] = {U(-20),U(-20), U(-20),U(-20),U(-20)};	depths= d3;
			int n[] = {0,0,0,1,1};									assocs=n;
		}				
		
		Map mapChilds;		
		for(int j=0;j<childs.length();j++)
		{
			Map c;
			c.setString("Name",childs[j]);
			c.setInt("Color",i);
			c.setDouble("EdgeOffset", U(200));
			if (diameters.length()>j)c.setDouble("Diameter", diameters[j],_kLength);
			if (depths.length()>j)c.setDouble("Depth", depths[j],_kLength);
			if (dCLoads.length()>j)c.setDouble("MaxLoad", dCLoads[j],_kNoUnit);
			if (assocs.length()>j)c.setInt("Association", assocs[j]);
			mapChilds.appendMap("Child", c);
		}
		f.setInt("Rule", i);
		f.appendMap("Child[]", mapChilds);
		mapFamilies.appendMap("Family", f);
	}// next i
	
// add Pitzl to defaults
	mapFamilies.appendMap("Family", mapPitzl);
	sFamilies.append(sPitzlName);
	mapDefault.setMap("Family[]", mapFamilies);
	//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbCLT-Lifter";
	Map mapSetting;

// find settings file in company folder
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)	bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath);
	// if no settings file could be found in company try to find it in the installation path
	if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");
	
// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
	
	// build a default map if no settings are found
	int bExportDefaultSetting;
	if (mapSetting.length()<1)
	{ 
		mapSetting = mapDefault;
		bExportDefaultSetting = true;
	}
//endregion

//region Read Settings
	Map mapGeneral;
	
// Tool Description Format	
	String sFormatTool = "@("+T("|Type|")+")";
	String sMapXName = "TimberTec";
	String sKeyName = "LiftingDevice";	
	
{
	String k;
	Map m= mapSetting;//.getMap("SubNode[]");
	k = "Family[]";			if (mapSetting.hasMap(k))mapFamilies = mapSetting.getMap(k);

// reset default sFamilies	
	if (mapFamilies.length()>0)
	{
		String families[] = GetFamilyNames(mapFamilies);
		sFamilies = families;
//	// build sFamily collection from map
//		for(int i=0;i<mapFamilies.length();i++)
//			sFamilies.append(T(mapFamilies.getMap(i).getString("Name")));
	}
	
// append Pitzl if not found in settings
	{ 
		String sName = T(mapPitzl.getString("Name"));
		if (sFamilies.find(sName)<0)
		{ 
			sFamilies.append(sName);
			mapFamilies.appendMap("Family", mapPitzl);
		}
	}
	k = "General"; if (mapSetting.hasMap(k))mapGeneral = mapSetting.getMap(k);

	// Tool description format
	m= mapSetting.getMap("ToolDescriptionFormat");
	k="Format";		if (m.hasString(k) )	sFormatTool = m.getString(k);
	k="MapName";	if (m.hasString(k) )	sMapXName = m.getString(k);
	k="KeyName";	if (m.hasString(k) && m.getString(k).length()>0)	sKeyName = m.getString(k);


}
//End Read Settings//endregion 

//region Properties
//detect family type
	int nFamily=0; // default family type
	if (_Map.hasInt("Family"))
		nFamily = _Map.getInt("Family");


// categories
	String sCategoryAlignment = T("|Alignment|");
	String sCategoryModel = T("|Model|");		
	String sCategoryTooling = T("|Tooling|");		

// TOOLING
	category = sCategoryTooling;
	String sDiameterName=T("|Diameter|");
	int nDiameterOverrideIndex = nDoubleIndex++;// store index for redeclaration
	PropDouble dDiameterOverride(nDiameterOverrideIndex, 0, sDiameterName);	
	dDiameterOverride.setCategory(category);
	dDiameterOverride.setDescription(T("|Specifies an override of the default value.|"));
	
	String sDepthName=T("|Depth|");
	int nDepthIndex = nDoubleIndex++;// store index for redeclaration
	PropDouble dDepthOverride (nDepthIndex, 0, sDepthName);	
	dDepthOverride.setCategory(category);
	String sDepthOverrideDescription = T("|Specifies an override of the default value.|");
	dDepthOverride.setDescription(sDepthOverrideDescription);
	
// // ALIGNMENT
	category = sCategoryAlignment;

// qty
	String sQuantityName=T("|Quantity|");
	int nQuantityIndex = nIntIndex++;// store index for redeclaration
	PropInt nQuantity(nQuantityIndex, 0, sQuantityName,0);	
	nQuantity.setDescription(T("|Specifies the amount of lifting devices.|") + " " + T("|0 = automatic|"));
	nQuantity.setCategory(category);	

// edge offset property
	String sOffsetEdgeName=T("|Edge Offset|");
	int nOffsetEdgeIndex = nDoubleIndex++;// store index for redeclaration
	PropDouble dOffsetEdgeOverride(nOffsetEdgeIndex, 0, sOffsetEdgeName);	
	dOffsetEdgeOverride.setCategory(category);
	dOffsetEdgeOverride.setDescription(T("|Defines offset to the panel edge.|") + " " + T("|0 = automatic|"));
	
	// distribution offset property
	String sDistributionOffsetName=T("|Distribution Offset|");
	int nDistributionOffsetindex = nStringIndex++;// store index for redeclaration
	PropString sDistributionOffset(nDistributionOffsetindex, "1/3", sDistributionOffsetName);	
	sDistributionOffset.setCategory(category);
	sDistributionOffset.setDescription(T("|Defines offset if more than 1 device is required.|") + " " + T("|Enter a relation to the CLT dimension i.e. '1/3' or the offset itself|") + " " + T("|0 = automatic|"));
	
// MODEL
	category= sCategoryModel;
	
// association
	String sAssociationName=T("|Association|");
	String tASWall = T("|Wall|") ,tASFloor = T("|Roof/Floor|");
	String sAssociationShorts[] = {"Auto","Wall", "Roof/Floor"};
	String sAssociations[] = {sAuto, tASWall, tASFloor};
	int nAssociationIndex = nStringIndex++;// store index for redeclaration
	PropString sAssociation(nAssociationIndex, sAssociations, sAssociationName,0);	
	String sAssociationDescription = T("|Defines the associated type of the panel.|");
	sAssociation.setDescription(sAssociationDescription);
	sAssociation.setCategory(category);

	int nChildIndex = nStringIndex++;// store index for redeclaration
	
// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl= _XE;
	Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[1];// = {};
	Entity entsTsl[] = {};
	Point3d ptsTsl[1];// = {};
	int nProps[]={nQuantity};
	double dProps[]={dDiameterOverride,dDepthOverride,dOffsetEdgeOverride};
	String sProps[]={sDistributionOffset,sAssociation};
	Map mapTsl;	
	String sScriptname = scriptName();
	//endregion

//End PART 1//endregion 

//region PART 2

//region OnInsert
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// silent/dialog
		String sEntry;
		String sEntryFamily;
		int bIsValidEntry; // a flag which indicates that the given catalog entry exists
		int bIsSingle;
		
	//region search for token of catalog entry and get tokenized value	
		String sTokens[] = _kExecuteKey.tokenize("?");
		if (sTokens.length()>1)
		{
			sEntryFamily =  T(sTokens[0].trimLeft().trimRight());
			sEntry =  T(sTokens[1].trimLeft().trimRight());
			//reportMessage("\nDefault entry family " + sEntryFamily + " Entry" + sEntry);
		}
		else
			sEntry =  _kExecuteKey;		

	// search key for tokens
		// single insertion
		if (sEntry.find("Single",0, false)>-1)
			bIsSingle=true;		
	// test if family name can be found in key
		else
		{
			for (int i=0;i<sFamilies.length();i++) //sFamilyNames
			{ 
				
				String sFamily =sFamilies[i];// // use translation HSB-10390 T(sFamilyNames[i]);
				//reportMessage("\nFamily " + sFamily + " vs entry " + sEntryFamily);
				if (sEntryFamily.find(sFamily,0,false)>-1)
				{
					//reportMessage("\n" + sFamily + " found entry: " + sEntryFamily);
					nFamily=i;	
					setOPMKey(sFamily);
					mapTsl.setInt("Family",nFamily);
					String sOpmName = scriptName() + "-" + sFamily;
					if (sEntry.length()>0)
					{
						String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);	
						int nEntry = sEntries.findNoCase(sEntry ,- 1);
						if (nEntry>-1)
						{ 
							bIsValidEntry=true;			
							break;								
						}
					}
					if (bIsValidEntry)break;
				} 
			}
		}			
	//endregion 		
		
	// alert first usage
		if (!bIsValidEntry && sEntry==sDefault)
		{ 
			reportNotice(TN("|Information|")+  "\n" + scriptName() + "-" + sFamilies[nFamily] + "\n" +
			TN("|It seems that you are calling this command the first time.|") + 
			TN("|We will save the current properties as default catalog entry, which will be used in the future.|")+ 
			TN("|You can change these settings through the property dialog and by saving the default entry.|"));	
		}

	// child property
	// Family
		Map mapFamily = mapFamilies.getMap(nFamily);
		int nRule=mapFamily.getInt("Rule");
		if (nRule <0 || nRule >3) nRule = 0; // only 4 rules known

		
	// childs property
		String sAllChilds[0];
		Map mapChilds = mapFamily.getMap("Child[]");
		for(int j=0;j<mapChilds.length();j++)
		{
			Map c=mapChilds.getMap(j);
			sAllChilds.append(c.getString("Name"));
		}// next j
		sAllChilds.insertAt(0,sAuto);
		String sChildName=T("|Type|");	
		PropString sChild(nChildIndex, sAllChilds, sChildName);
		String sChildDescription = T("|Defines the subtype of the lifting Family.|");
		sChild.setDescription(sChildDescription);
		sChild.setCategory(category);	
	
	// Edge drill overrides
		if (nRule==3)
		{ 
			category = T("|Edge Drill|");//XX
			String sDefaultValueMsg = T("|0 = use defaults|");
			String sDepthEdgePropName=T("|Depth|")+" ";
			PropDouble dDepthEdgeProp(nDoubleIndex++, U(0), sDepthEdgePropName);	
			dDepthEdgeProp.setCategory(category);
			dDepthEdgeProp.setDescription(T("|Defines the depth of the edge drill.|") + " " + sDefaultValueMsg);	
			
			String sDiameterEdgeName=T("|Diameter|")+" ";
			PropDouble dDiameterEdgeProp(nDoubleIndex++, U(0), sDiameterEdgeName);	
			dDiameterEdgeProp.setCategory(category);
			dDiameterEdgeProp.setDescription(T("|Defines the Diameter of the edge drill.|")+ " " + sDefaultValueMsg);
	
			String sOffsetEdgePropName=T("|Z-Offset|");
			PropDouble dZOffsetEdgeProp(nDoubleIndex++, U(0), sOffsetEdgePropName);	
			dZOffsetEdgeProp.setCategory(category);
			dZOffsetEdgeProp.setDescription(T("|Defines the Offset of the edge drill.|") + " " + sDefaultValueMsg);		
		}
	

	// show the dialog if no catalog in use
		//reportMessage("\nbIsValidEntry:" + bIsValidEntry + " opmKey = " +_ThisInst.opmName());
		if (bIsValidEntry)
		{
			int b=setPropValuesFromCatalog(sEntry);
			//reportMessage("\nb:" + b);
			if(sEntry.find(sDefault,0, false)<0)
				showDialog(sEntry);	
		} 
		else
		{
			showDialog("---");
		}
		
		
		
		setOPMKey(sFamilies[nFamily]);
		setCatalogFromPropValues(sLastInserted);

	// append the selected child		
		sProps.append(sChild);	

		int nAssociation; // 0 = automatic, 1=Wall, 2 = Floor/roof
			
		
	// selection set
		Entity ents[0];
		PrEntity ssE(T("|Select CLT panels or elements|"), Sip());	
		ssE.addAllowedClass(Element());
		if (ssE.go())
			ents= ssE.set();	


	// collect sips	
		Sip sips[0];
		CollectPanels(sips, ents);
	
	// remove those sips which do have already an instance attached	
		if (sips.length()>1)
		{ 
			for(int i = sips.length()-1;i>=0;i--)
			{
				Entity ents[] = sips[i].eToolsConnected();
				for(int c= 0;c<ents.length();c++)	
				{
					TslInst tsl = (TslInst)ents[c];
					if (tsl.bIsValid() && scriptName() == tsl.scriptName())
					{
						reportMessage("\n" + T("|Panel|") + " " +sips[i].posnum() + ": " + T("|Tool already attached.|") + " " + T("|Panel will be removed from selection set|"));
						sips.removeAt(i);
						break;	
					}	
				}		
			}			
		}
	// collect existing lifting directions	
		else if (sips.length()==1)
		{ 
			Sip sip = sips.first();
			Vector3d vecX = sip.vecX();
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ();
			
			Point3d ptX = sip.ptCen();
			Entity ents[] = sip.eToolsConnected();
			Vector3d vecLifts[0];
			Map mapDirections;
			for(int c= 0;c<ents.length();c++)	
			{
				TslInst tsl = (TslInst)ents[c];
				if (tsl.bIsValid() && scriptName() == tsl.scriptName())
				{
					Map m = tsl.map().getMap("LiftDirection[]");
					for (int j=0;j<m.length();j++) 
					{
						Vector3d vec = m.getVector3d(j);
						vecLifts.append(vec); 
						mapDirections.appendVector3d("vecLift", vec);
					}
				}	
			}			
			

			Map mapArgs;
			mapArgs.setPlaneProfile("Shadow", PlaneProfile(sip.plEnvelope()));
			mapArgs.setMap("LiftDirection[]", mapDirections);
			mapArgs.setPoint3d("ptMid", ptX);
			mapArgs.setVector3d("vecX", vecX);
			mapArgs.setVector3d("vecY", vecY);
			mapArgs.setVector3d("vecZ", vecZ);
			mapArgs.setInt("Mode", 2);// 0= set, 1 = add, 2 = add new style
			mapArgs.setDouble("dL", U(300));


		//Set/Add direction
			
			String prompt = T("|Select point in lifting direction|");
			PrPoint ssP(prompt,ptX );	
			int nGoJig = -1;
			while (nGoJig != _kNone && nGoJig != _kOk)
			{
				nGoJig = ssP.goJig("ShowDirection", mapArgs);
				
			//Jig: point picked
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value(); 
					
					Vector3d vec = ptLast-ptX;
					if (!vec.bIsZeroLength())
					{
						Quader qdr(sip.ptCenSolid(), vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), sip.solidHeight(),0,0,0);
						vec=qdr.vecD(vec);
					}

					
				// test if found in set existing of directions
					int bFound;
					for (int i=0;i<vecLifts.length();i++) 
					{ 
						if(vec.isCodirectionalTo(vecLifts[i]))
						{
							bFound=true;
							break;
						}
					}				

				// set as new direction
					if (!bFound)
					{
						Map m;
						m.setVector3d("LiftDirection", vec);
						mapTsl.setMap("LiftDirection[]",m);
						
					}					
					else
					{ 
						reportMessage("\n" + T("|Cannot append another device to an existing lifting direction|"));
						eraseInstance();
						return;
					}
					
					
				}			
			// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					eraseInstance();
					break;
				}
			}
			



		}


	// loop panels
		for(int i = 0;i <sips.length();i++)
		{
			if (bDebug)reportMessage("\n" + sips[i].name() + " to be created");
			gbsTsl[0] = sips[i];
			vecXTsl= sips[i].vecX();
			vecYTsl= sips[i].vecY();
			ptsTsl[0] = sips[i].ptCenSolid(); // distributions will have _Pt0 at ptCen

			
			if(bDebug)reportMessage("\n"+ scriptName() + " will be cloned" + 
				"\n	vecX  	" + vecXTsl+
				"\n	vecY  	" + vecYTsl+
				"\n	GenBeams 	(" + gbsTsl.length()+")" +
				"\n	Entities 	(" + entsTsl.length()+")"+
				"\n	Points   	(" + ptsTsl.length()+")"+
				"\n	PropInt  	(" + nProps.length()+")"+ ((nProps.length()==nIntIndex) ? " OK" : (" Warning: should be " + nIntIndex))+
				"\n	PropDouble	(" + dProps.length()+")"+ ((dProps.length()==nDoubleIndex) ? " OK" : (" Warning: should be " + nDoubleIndex))+
				"\n	PropString	(" + sProps.length()+")"+ ((sProps.length()==nStringIndex) ? " OK" : (" Warning: should be " + nStringIndex))+
				"\n	Map      	(" + mapTsl.length()+") " + mapTsl+"\n"+sProps);			

		
		// create device
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
			if (tslNew.bIsValid())
			{
				if(bDebug)reportMessage("\n" + tslNew.handle() + " created");
				tslNew.setPropValuesFromCatalog(sLastInserted);
			}	
		}
	
	// erase the calling instance	
		eraseInstance();
		return;
	}
// end on insert	___________________________________________________________________________________________________________________________________________________	
		
//endregion 

//region Get Flags and standards
// mode
	int nMode = _Map.getInt("mode");
	// 0 = collection
	// 1 = individual device
	
// Family
	Map mapFamily = mapFamilies.getMap(nFamily);
	int nRule=mapFamily.getInt("Rule");
	if (nRule <0 || nRule >3) nRule = 0; // only 4 rules known
	
	// get family properties
	int bIsPitzl = sFamilies[nFamily] == sPitzlName;
	int bHideDescriptionShopdraw = mapFamily.getInt("HideDescriptionShopdraw"); // HSBCAD-5570
	String sSecondaryFamily = mapFamily.getString("secondaryFamily");	
	double minHorizontalOffset = mapFamily.getDouble("minHorizontalOffset");
	
	double dRotationText;
	double dXTextFlag = 1, dYTextFlag = 0;
	if (mapFamily.hasMap("Text"))
	{ 
		Map m = mapFamily.getMap("Text");
		dRotationText = m.getDouble("Rotation");
		dXTextFlag = m.getDouble("XFlag");
		dYTextFlag = m.getDouble("YFlag");		
	}
	
//	return;
// get and validate references
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + " " + T("|requires a panel.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}	
	else if (sFamilies.length()<1)
	{
		reportMessage("\n" + scriptName() + " " + T("|No Family definition found.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}		
	else if (nFamily>=sFamilies.length() || nFamily<0)
	{
		reportMessage("\n" + scriptName() + " " + T("|Invalid Family definition found.|") + " " + T("|Tool will be deleted.|"));
		//eraseInstance();
		return;	
	}
		
//endregion 


// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);

//region Sip standards
	Element element;
	Sip sip = _Sip[0];
	element= sip.element();
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();	
	Point3d ptOrg = sip.ptCenSolid();
	Point3d ptCenSip = sip.ptCen();
	double dH = sip.dH();	
	PLine plShadow = sip.plShadow();
	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();
	String sPanelPosText = T("|Panel|") + " " + sip.posnum()+"/"+sip.name();
	CoordSys csSip = sip.coordSys();
	PlaneProfile ppShadow(csSip);
	ppShadow.joinRing(plShadow,_kAdd);
	SipEdge edges[0];
	edges = sip.sipEdges();
	
	PlaneProfile ppOpening(csSip);
	for (int i=0;i<plOpenings.length();i++) 
		ppOpening.joinRing(plOpenings[i], _kAdd); 	
		
		
	Body bdXReal, bdXEnv;
	int bSuccess=GetRealBody(sip, bdXReal, bdXEnv, this);
	
	Body bdRealNoLifting;
	PlaneProfile ppTools,ppNoTools;
	if(!bSuccess)
	{ 
		Map mBdRealNoLifting=calcBodyWithoutLiftingTools1(sip,bdRealNoLifting,ppTools,ppNoTools,this);
		bdXReal=bdRealNoLifting;
	}
	PlaneProfile ppMinShadow(csSip);
	ppMinShadow.unionWith(bdXReal.extractContactFaceInPlane(Plane(ptCenSip - vecZ * .5 * dH, - vecZ), dEps));
	ppMinShadow.intersectWith(bdXReal.extractContactFaceInPlane(Plane(ptCenSip + vecZ * .5 * dH, vecZ), dEps));
	//{Display dpx(1); dpx.draw(ppMinShadow, _kDrawFilled,20);}
	ppShadow = ppMinShadow;
	// HSB-24434: needed for calculating strap length at walls
	PlaneProfile ppShadowOutter=bdXReal.shadowProfile(Plane(ptCenSip,vecZ));
//endregion 


	
	
//region Surface Quality
	SipStyle style(sip.style());
	String sqTop = sip.surfaceQualityOverrideTop();
	if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
	if (sqTop.length() < 1)sqTop = "?";
	int nQualityTop = SurfaceQualityStyle(sqTop).quality();
	
	String sqBottom = sip.surfaceQualityOverrideBottom();
	if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
	if (sqBottom.length() < 1)sqBottom = "?";
	int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();		
//End Surface Quality//endregion 	

//region Childs property
	String sAllChilds[0], sAllUnfilteredChilds[0];
	Map mapChilds = mapFamily.getMap("Child[]");
	for(int j=0;j<mapChilds.length();j++)
	{
		Map c=mapChilds.getMap(j);
		double dMinThickness = c.getDouble("MinThickness");
		String name = c.getString("Name");
		if (!(dMinThickness > 0 && dMinThickness > dH))
			sAllChilds.append(name);
		sAllUnfilteredChilds.append(name);
	}// next j
	if (sAllChilds.length()<1) // make sure list is not empty
		sAllChilds = sAllUnfilteredChilds;

	if (nMode==0)
		sAllChilds.insertAt(0,sAuto);
	String sChildName=T("|Type|");	
	PropString sChild(nChildIndex, sAllChilds, sChildName);
	String sChildDescription = T("|Defines the subtype of the lifting Family.|");
	sChild.setDescription(sChildDescription);
	sChild.setCategory(category);		
//endregion 

//region Collect edge relevant tools (tsls) for rule type 3
	TslInst tslsConnected[0];
	
	if (nRule==3)
	{
		Entity tents[] = sip.eToolsConnected();
		for (int i=0;i<tents.length();i++) 
		{ 
			TslInst tsl = (TslInst)tents[i];
			if (!tsl.bIsValid())continue;
			Map map = tsl.map();
			if (tsl.bIsValid() && _ThisInst!=tsl && map.hasVector3d("vecDir") && map.hasPoint3dArray("maleLocations"))
			{
				tslsConnected.append(tsl);	
				if (bDebug)reportMessage("\n"+ "Connected edge tool " + tsl.scriptName());
			}	 
		}
	}		
//endregion 

//region Individual device________________________________________________________________________________________________________
	if (nMode==1)
	{
		setEraseAndCopyWithBeams(_kBeam0);
		nQuantity.set(1);
		nQuantity.setReadOnly(true);
		dOffsetEdgeOverride.setReadOnly(true);
		sDistributionOffset.set(0);
		sDistributionOffset.setReadOnly(true);

		
		if (_kNameLastChangedProp=="_Pt0")
		{
			PLine pl = plShadow;
			pl.projectPointsToPlane(Plane(_Pt0,vecZ),vecZ);
			Vector3d vec = _Pt0 - pl.closestPointTo(_Pt0);
			if (ppShadow.pointInProfile(_Pt0)!=_kPointInProfile)
			{
				Vector3d vec2 = -vec;
				vec2.normalize();
				_Pt0.transformBy(vec2*dOffsetEdgeOverride-vec);	
			}
		
			else
			{
				double d = vec.length();
				dOffsetEdgeOverride.set(d);				
			}
			setExecutionLoops(2);
			return;
		}
		
		//ptsLoc.append(_Pt0);
	}
			
//endregion 

//region Assignment, grouping and OPM	
	assignToGroups(sip);
	setDependencyOnEntity(sip);
	String sFamily = sFamilies[nFamily];
	setOPMKey(sFamily);

// declare dim request map
	Map mapRequest,mapRequests;
	mapRequest.setVector3d("AllowedView", vecZ);


// get distribution distance
	double dDistributionOffset, dDistributionRelation;
	int n = sDistributionOffset.find("/",0);
	if (n>-1)
	{
		int nChars = sDistributionOffset.length();
		String sLeft = sDistributionOffset.left(n).trimLeft().trimRight();
		String sRight = sDistributionOffset.right(nChars-n-1).trimLeft().trimRight();
		double dA = sLeft.atof();
		double dB = sRight.atof();
		if (dA>0 && dB>0)
			dDistributionRelation=(dA/dB);
	}
	else
		dDistributionRelation=sDistributionOffset.atof();	

// get property set names
	String sAttachedPropSetNames[] = sip.attachedPropSetNames();
	String sAvailableProSetNames[] = sip.availablePropSetNames();
	
// identify association
	int nAssociationOverride = sAssociations.find(sAssociation);// 0 = automatic, 1= wall, 2 = floor/roof
	if (nAssociationOverride<0){sAssociation.set(sAssociations[0]); setExecutionLoops(2);return;}
	int nAssociation = nAssociationOverride;
	
// set association from the association set with the CLT
	if (nAssociationOverride==0)
	{
	
	// read potential association
		Map mapExtenedProperties = sip.subMap("ExtendedProperties");
		if (mapExtenedProperties.hasInt("IsFloor"))
		{ 
			nAssociation = mapExtenedProperties.getInt("IsFloor") + 1;
		}
	// legacy	
		else
		{ 
			for(int i=0;i<sAttachedPropSetNames.length();i++)
			{
				Map map = sip.getAttachedPropSetMap(sAttachedPropSetNames[i]);
				String value, key;
				key = map.hasString("Association")?"Association":T("|Association|");
				if (map.hasString(key))
				{
					value=T(map.getString(key)).makeUpper();	
					for(int j=0;j<sAssociationShorts.length();j++)
					{
						if(value==T(sAssociationShorts[j]).makeUpper() || value==sAssociationShorts[j].makeUpper())
						{
							nAssociation=j;
							value="OK";
							break;
						}
					}// next i
					if (value=="OK")break;	
				}
			}			
		}
	}
	
// no association set
	if (nAssociation==0)
	{
	// test wall nAssociation
		if(element.bIsValid() && element.bIsKindOf(ElementWall()))
			nAssociation = 1;			
	// any upright panel is considered to be a wall
		else if (vecZ.isPerpendicularTo(_ZW))
			nAssociation = 1;
	// any panel with a bevel is considered to be roof panel
		else if (!vecZ.isPerpendicularTo(_ZW) && !vecZ.isPerpendicularTo(_XW))
			nAssociation = 2;
	// any panel with a perp to ZW and any elevation above world 0 is considered to be floor panel
		else if (vecZ.isPerpendicularTo(_ZW) && _ZW.dotProduct(ptOrg-_PtW)>.5*dH)
			nAssociation = 2;
	// default assoc will be wall
		else	
			nAssociation = 1;	
	
	// display selected association in description of  property
		if(nAssociation>-1)
			sAssociation.setDescription(sAssociationDescription + " " + T("|Selected Association|") +": "+ sAssociations[nAssociation]);
	}	
	
	// Store Association in Map, used to filter existing tools
	_Map.setInt("Association", nAssociation);
	
//	if(nAssociation==1)
//	{ 
//		// HSB-24434: wall calculate realbody without lifting tools
//		Map mBdRealNoLifting=calcBodyWithoutLiftingTools1(sip,bdRealNoLifting,ppTools,ppNoTools);
//	}

//Set edge offset property to read only for certain wall assocs 
// 0 = Hebeschlaufe, 1 = Rampa, 2 = Würth,  3 = Stahlanker
	if (nAssociation==1 && (nRule==1 || nRule==2))
		dOffsetEdgeOverride.setReadOnly(true);

//set the reference side for the lifting device
	Vector3d vecFace = -vecZ;
	if (nAssociation ==2) // 1.6
		vecFace *=-1;
	else if (nQualityBottom>nQualityTop)
		vecFace *=-1;
		
//endregion 



//region Clone Secondary Devive on creation
	if ((_bOnDbCreated || bDebug) && sFamilies.findNoCase(sSecondaryFamily,-1)>-1)
	{ 
		int nAssociationSecondary = nAssociation == 1 ? 2 : 1;
		Map mapSecondaries = FilterFamiliesWithAssociation(mapSetting, -nAssociation); //negative = exclude given assoc
		String sSecondaryFamilies[] = GetFamilyNames(mapSecondaries);
		int nSecondaryFamily = sSecondaryFamilies.findNoCase(sSecondaryFamily ,- 1);
		
		int nProps2[]={nQuantity};
		double dProps2[]={dDiameterOverride,dDepthOverride,dOffsetEdgeOverride};
		String sProps2[]={sDistributionOffset,(nAssociation==1?tASFloor:tASWall),sAuto};		
	
		if (bDebug)
		{
			int g = nSecondaryFamily;
		}
		else if (nSecondaryFamily>-1)
		{ 
		// prepare tsl cloning
			TslInst tslNew;
			GenBeam gbsTsl[] = {sip};
			Entity entsTsl[] = {};
			Point3d ptsTsl[] = {_Pt0};

			Map mapTsl = _Map;
			mapTsl.setInt("Family",nSecondaryFamily);
			//mapTsl.setInt("Association",nAssociationSecondary);
		
		// create device
			tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps2, dProps2, sProps2,_kModelSpace, mapTsl);	
			if (tslNew.bIsValid())
				tslNew.transformBy(Vector3d(0, 0, 0));
			else
				reportNotice("\nsecondary creation failed");				

		}	
	}
//endregion 








//region Add flip trigger
	String sTriggerFlipSide = T("|Flip Side|");
	int bFlip = _Map.getInt("flip");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide);
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick)) 
	{
		if (bFlip)	bFlip =false;
		else bFlip=true;
		_Map.setInt("flip",bFlip);		
	}
	if (bFlip)
		vecFace*=-1;
	Plane pnZ(sip.ptCenSolid(), vecFace);	
	vecFace.vis(pnZ.ptOrg(),2);
//endregion

// set replacement flag for rule types
	int nReplaceFamily=-1;

//region Get weight and write to property of propSet if found
	Map mapIO;
	Map mapEntities;
	mapEntities.appendEntity("Entity", sip);
	mapIO.setMap("Entity[]",mapEntities);
	TslInst().callMapIO("hsbCenterOfGravity", mapIO);
	Point3d ptCen = mapIO.getPoint3d("ptCen");// returning the center of gravity
	double dNetWeight= mapIO.getDouble("Weight");// returning the weight
	
// set _Pt0 in device collection mode
	if (nMode==0)
		_Pt0 = ptCen;
//endregion

// collect childs matching association and their load capabilities
	double dCLoads[0];
	String sCNames[0];
	int nChildRules[0];
	//
	double dCMinThicknesses[0];
	double dCMaxThicknesses[0];
	
	Map mapChildCollection[0];
	for(int j=0;j<mapChilds.length();j++)
	{
		Map c=mapChilds.getMap(j);
		int assoc = c.getInt("Association");
		String sName = c.getString("Name");
		
		double dMinThickness = c.getDouble("MinThickness");
		if (dMinThickness > 0 && dMinThickness > dH)
		{
			continue; // skip entries which have required a thickness test and do not match
		}
		if (assoc == nAssociation || assoc==0)
		{
			sCNames.append(c.getString("Name"));
			dCLoads.append(c.getDouble("MaxLoad"));
			nChildRules.append(c.getInt("ChildRule"));
			// HSB-24493
			if(c.hasDouble("MinThickness"))
			{
				dCMinThicknesses.append(c.getDouble("MinThickness"));
			}
			else if(!c.hasDouble("MinThickness"))
			{ 
				dCMinThicknesses.append(-U(1.0));
			}
			if(c.hasDouble("MaxThickness"))
			{
				dCMaxThicknesses.append(c.getDouble("MaxThickness"));
			}
			else if(!c.hasDouble("MaxThickness"))
			{ 
				dCMaxThicknesses.append(U(-1));
			}
			// 
			mapChildCollection.append(c);
		}
	}// next j	
	
// order by load
	for(int i=0;i<dCLoads.length();i++)
		for(int j=0;j<dCLoads.length()-1;j++)
			if (dCLoads[j]>dCLoads[j+1])
			{
				dCLoads.swap(j,j+1);
				sCNames.swap(j,j+1);
				nChildRules.swap(j,j+1);
				// HSB-24493
				dCMinThicknesses.swap(j,j+1);
				dCMaxThicknesses.swap(j,j+1);
				// 
				mapChildCollection.swap(j,j+1);
			}// next j	

// restore map of valid and ordered childs
	mapChilds=Map();
	for(int i=0;i<dCLoads.length();i++)
		mapChilds.appendMap(sCNames[i],mapChildCollection[i]);

// validate childs and dCLoads
	if (dCLoads.length()<1 ||dCLoads.length()!=sCNames.length())		
	{
		int nPreviousFamily = _Map.hasInt("previousFamily")?_Map.getInt("previousFamily"):-1;
		reportMessage("\n" + scriptName() + ": " +sPanelPosText + " " + T("|Could not find matching data for|") + " " + sFamily + " / " + sChild);
	
	// reset to previous, but make sure it will not try this a second a time	
		if (nPreviousFamily>-1)
		{
			reportMessage("\n"+T("|Family reset to|") + " " + sFamilies[nPreviousFamily]);
			_Map.setInt("Family",nPreviousFamily);
			_Map.removeAt("previousFamily", true);
			setExecutionLoops(2);
			return;
		}
		else
		{
			if (nMode==1)("\n"+T("|Check assignment of splitted panels.|"));
			reportMessage("\n"+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
	}
	
// get selected child	
	int nChild = sCNames.find(sChild);// <0 means automatic
//	if(sSecondaryFamily.length()<1)
//	{ 
//		Display dp(1);
//		dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0, _kDeviceX);
//		return;
//	}
	
	
	int bAutoChild = sAllChilds.find(sChild)==0 || nChild<0;

// reset to automatic mode if selected type is not valid or does not match association
	if (sChild!=sAllChilds[0] && nChild<0)
	{
		if (nMode==0)
		{
			reportMessage("\n" + scriptName() + ": " +sPanelPosText + " " + T("|The selected type|") + " " + sChild + " " + T("|is not valid for the current association.|") + " " +
			T("|The type will be reset to automatic mode.|"));
			
			sChild.set(sAllChilds[0]);	
		}
		else if (sCNames.length()>0)
		{
			reportMessage("\n" + scriptName() + ": " +sPanelPosText + " " + T("|The selected type|") + " " + sChild + " " + T("|is not valid for the current association.|") + " " +
			T("|The type will be reset to| ") + sCNames[0]);
			sChild.set(sCNames[0]);	
		}
		setExecutionLoops(2);
		return;
	}

// flag the state of a corner location based on the child rule
// child rule 1 means it will be a lifting device located on each corner of a wall panel
	int bAtCorner=!bAutoChild && nChildRules.length()>nChild && nChildRules[nChild]==1;
	if (bAtCorner)
	{ 
		if(sDistributionOffset!=sNA)
			sDistributionOffset.set(sNA);
		sDistributionOffset.setReadOnly(true);
	}
	else if (sDistributionOffset==sNA)
		sDistributionOffset.set("1/3");

//region collect lifting directions
	Vector3d vecLifts[0];
	Map mapDirections= _Map.getMap("LiftDirection[]");
	for(int i=0;i<mapDirections.length();i++)
	{
		Vector3d vec = mapDirections.getVector3d(i);//vec.vis(_Pt0, 1);
		if (!vec.bIsZeroLength())vecLifts.append(vec);
	}// next i
	
	if (vecLifts.length()<1)
	{
		Vector3d vec = vecY;
		vecX.vis(_Pt0, 1);
		vecY.vis(_Pt0, 3);
		
	// append default wall lifting direction
		if (nAssociation==1 && vecZ.isPerpendicularTo(_ZW))
		{
			double d0 = vecX.dotProduct(_ZW);
			double d1 = vecY.dotProduct(_ZW);

			if (vecX.isParallelTo(_ZW) || vecY.isParallelTo(_ZW))
				vec=_ZW;
			else if (vec.dotProduct(_ZW)<0)
				vec*=-1;
		// workaround for isParallelTo with slightly rotated vectors
			else if (abs(d0)<dEps*10e5 ||abs(d1)<dEps*10e5)
				vec=_ZW;				
			vecLifts.append(vec);	
		}	
	// append default wall lifting direction
		else if (nAssociation==1)
		{
			double d0 = vecX.dotProduct(_ZW);
			double d1 = vecY.dotProduct(_ZW);			
			if (vecX.isParallelTo(_XW)|| vecX.isParallelTo(_YW))
				vec=_YW;
		// workaround for isParallelTo with slightly rotated vectors
			else if (abs(d0)<dEps*10e5 ||abs(d1)<dEps*10e5)
				vec=_ZW;	
			vecLifts.append(vec);	
		}
	// append default floor/roof lifting direction
		else if (nAssociation==2)
		{
			vec = vecZ;
			if (vec.dotProduct(_ZW)<0)vec*=-1;
			vecLifts.append(vec);	
		}
		else
			vecLifts.append(vec);
		//vec.vis(ptOrg,2);
		
		for (int i=0;i<vecLifts.length();i++) 
			mapDirections.appendVector3d("LiftDirection", vecLifts[i]); 
		_Map.setMap("LiftDirection[]",mapDirections);
	}
	
//endregion
	

//region add triggers to add or remove a lifting direction, blocked if in corner state
	if ((nMode==0 && !bAtCorner) || nMode==1)
	{
	// TRIGGER change lifting direction
		String sTriggerSetDirection= T("|Set lifting direction|");
		String sTriggerAddDirection= T("|Add lifting direction|");
		addRecalcTrigger(_kContextRoot, sTriggerSetDirection);
		addRecalcTrigger(_kContextRoot, sTriggerAddDirection);
		
		String sTriggerDirections[]={sTriggerSetDirection,sTriggerAddDirection };
		int nTriggerDirection = sTriggerDirections.find(_kExecuteKey);
		if (_bOnRecalc && nTriggerDirection>-1)	
		{
			Map mapArgs;
			mapArgs.setPlaneProfile("Shadow", ppShadow);
			mapArgs.setMap("LiftDirection[]", mapDirections);
			mapArgs.setPoint3d("ptMid", _Pt0);
			mapArgs.setVector3d("vecX", vecX);
			mapArgs.setVector3d("vecY", vecY);
			mapArgs.setVector3d("vecZ", vecZ);
			mapArgs.setInt("Add", nTriggerDirection==1);
			mapArgs.setDouble("dL", U(300));

		//Set/Add direction
			String prompt = T("|Select point in lifting direction|");
			PrPoint ssP(prompt, _Pt0);	
			int nGoJig = -1;
			while (nGoJig != _kNone && nGoJig != _kOk)
			{
				nGoJig = ssP.goJig("ShowDirection", mapArgs);
				
			//Jig: point picked
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value(); 
					
					Vector3d vec = ptLast-_Pt0;
					if (!vec.bIsZeroLength())
					{
						Quader qdr(sip.ptCenSolid(), vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), sip.solidHeight(),0,0,0);
						vec=qdr.vecD(vec);
					}
				
				// reset any direction being set
					if (nTriggerDirection==0)
						mapDirections=Map();
					
				// test if found in set of directions
					int bFound;
					if (!vec.isParallelTo(vecZ))
					{
						for (int i=0;i<mapDirections.length();i++) 
						{ 
							if(vec.isCodirectionalTo(mapDirections.getVector3d(i)))
							{
								bFound=true;
								break;
							}
						}				
					}
					
				// append to list of mapDirections
					if (!bFound)
					{
					// in add mode append the default direction
						if (nTriggerDirection==1 && mapDirections.length()<1 && vecLifts.length()>0 && !vecLifts[0].isCodirectionalTo(vec))
							mapDirections.appendVector3d("LiftDirection", vecLifts[0]);	
					
						mapDirections.appendVector3d("LiftDirection", vec);
						_Map.setMap("LiftDirection[]",mapDirections);
					}					
					
					
					
				}
		        else if (nGoJig == _kKeyWord)
		        { 
		            
		            if (ssP.keywordIndex() == 0)
		            	;
		        } 			
			// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}			

			setExecutionLoops(2);
			return;
		}
		
//	// TRIGGER remove lifting direction
//		String sTriggerRemoveDirection= T("|Remove lifting direction|");
//		if (mapDirections.length()>1)
//			sTriggerRemoveDirection= T("|Reset lifting direction|");
//		if (mapDirections.length()>0 && nAssociation!=2)
//			addRecalcTrigger(_kContextRoot, sTriggerRemoveDirection);
//		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveDirection)	
//		{
//		// reset
//			if (mapDirections.length()==1)
//				_Map.removeAt("LiftDirection[]",true);
//		// remove
//			else
//			{ 
//				PrPoint ssP("\n" + T("|Select point in lifting direction|"),_Pt0); 
//				if (ssP.go()==_kOk) 
//				{ // do the actual query
//					Point3d ptLast = ssP.value(); // retrieve the selected point
//					Vector3d vec = ptLast-_Pt0;
//					if (!vec.bIsZeroLength())
//					{
//						Quader qdr(sip.ptCenSolid(), vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), sip.solidHeight(),0,0,0);
//						vec=qdr.vecD(vec);
//					}
//				// test if found in set of directions
//					int nFound=-1;
//					if (!vec.isParallelTo(vecZ))
//					{
//						for (int i=0;i<mapDirections.length();i++) 
//						{ 
//							if(vec.isCodirectionalTo(mapDirections.getVector3d(i)))
//							{
//								nFound=i;
//								break;
//							}
//						}				
//					}
//					
//				// append to list of mapDirections
//					if (nFound>-1)
//					{
//						mapDirections.removeAt(nFound, true);
//						_Map.setMap("LiftDirection[]",mapDirections);
//					}
//				}
//			}
//			setExecutionLoops(2);
//			return;
//		}		
	}//endregion
	

// General settings and Display
	Display dp(6);
	dp.showInDxa(true);// HSB-23000
	double dTxtHeight, dMaxRange;
	String sDimStyle;
	{ 
		String k;
		Map m = mapGeneral;
		k = "TextHeight";	if (m.hasDouble(k)) dTxtHeight = m.getDouble(k);
		k = "DimStyle";		if (m.hasString(k)) sDimStyle = m.getString(k);
		
		if (_DimStyles.findNoCase(sDimStyle)>-1)dp.dimStyle(sDimStyle);
		if (dTxtHeight>0)dp.textHeight(dTxtHeight);
		
	// max range: can be defined on general, family or child level	
		k = "MaxRange";		if (m.hasDouble(k)) dMaxRange = m.getDouble(k);
		m = mapFamily;		if (m.hasDouble(k)) dMaxRange = m.getDouble(k);
	}
	// HSB-22470
	Body bdReal;// sip realbody
	PlaneProfile ppReal,ppRealExtend;
//region calculate the required amount of devices and/or detect required type
	int nNumDevices[vecLifts.length()];
	Map mapLocations[vecLifts.length()];
	int nChildDetected;

	for(int i=0;i<vecLifts.length();i++)
	{
	// the lifting coordSys
		Vector3d vecYLift= vecLifts[i];		
		Vector3d vecXLift= vecYLift.crossProduct(vecZ);
		if (vecYLift.isParallelTo(vecZ))
		{
		// get extents
			LineSeg seg = ppShadow.extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));			
			vecXLift = (dX>=dY)?vecX:vecY;
		}

	// the related profile coordSys
		Vector3d vecXP = vecXLift;
		Vector3d vecYP = vecXP.crossProduct(-vecZ);
		
	// get extents
		LineSeg seg = ppShadow.extentInDir(vecXLift); //seg.vis(2);
		double dX = abs(vecXP.dotProduct(seg.ptStart()-seg.ptEnd()))-minHorizontalOffset+2*dEps; // add tolerance for later split segs
		double dY = abs(vecYP.dotProduct(seg.ptStart()-seg.ptEnd()));	
		
	// declare selected type
		int nStart=bAutoChild?0:nChild;
		nChildDetected=bAutoChild?-1:nChild;
		
		int nMaxDefaultDevices=1;
		//nFamily; 0=H, 1=R, 2=W, 3=S
		//nAssociation: 0 = automatic, 1=Wall, 2 = Floor/roof
		if (nAssociation==1 && (dX>=U(2000)) )// wall with two devices  // || dNetWeight>200)
			nMaxDefaultDevices=2;
		else if (nAssociation==2 && dX>=U(8000) && dH<=U(80) && nFamily==1)// rampa in a floor/roof receives an additional third device: version  value="2.0" date="28jan16"
			nMaxDefaultDevices=3;			
		else if (nAssociation==2)// default floor roof
			nMaxDefaultDevices=4;			
		int numDevices = nQuantity>0?nQuantity:nMaxDefaultDevices;
		
	// calculate requested num of devices
		if (nMode==1)
		{
			numDevices=1;
			nChildDetected=nChild;//sAllChilds.find(sChild,1);
		}
		else if (!bAutoChild && bAtCorner)
		{
			numDevices=2;
		}
		else if (!bAutoChild)
		{
			double dLoad = dCLoads[nChild];
			numDevices=nQuantity>0?nQuantity:nMaxDefaultDevices;
			for(int k=0;k<nMaxDefaultDevices;k++)
			{
				if (nQuantity>0 && numDevices==nQuantity)
				{
					break;
				}
				else if (dLoad*numDevices <dNetWeight)
				{
					numDevices++;
				}
				else
				{
					break;
				}		
			}	
		}
	// detect type
		else
		{
		// increase amount of devices until something found
			int nCnt;
			while(nCnt<10)
			{	
				
				for(int j=0;j<dCLoads.length();j++)
				{
					for(int k=0;k<nMaxDefaultDevices;k++)
					{
						if (dCLoads[j]*numDevices >dNetWeight)
						{
							// HSB-24493: check if thickness criteria present
							if(dCMinThicknesses[j]>-1)
							{ 
								if(dH<dCMinThicknesses[j])
								{ 
									nCnt++;	
									continue;
								}
							}
							if(dCMaxThicknesses[j]>-1)
							{ 
								if(dH>dCMaxThicknesses[j])
								{ 
									nCnt++;	
									continue;
								}
							}
							// pass all tests
							nChildDetected=j;
							nCnt=10;
							break;
						}	
//						else if (nQuantity<=0)
//							numDevices ++;
					}// next k
					if (nCnt==10)
					{
						break;					
					}
//					else
//						numDevices = nQuantity;	
				}// next j
				if (nChildDetected<0)	
					numDevices ++;
				nCnt++;	
			}				
			
		}

//	// if not in auto mode make sure the detected child matches the selected
		int bChildIsValid;
		if (nChildDetected<dCLoads.length() && nChildDetected>-1 )
			bChildIsValid= numDevices*dCLoads[nChildDetected]>dNetWeight;
//	Deprecated version 1.4
//		else if (nRule==1)
//		{ 
//			nReplaceFamily = 0;
//			reportMessage("\n" + scriptName() + ": " +T("|The family|") + " " + sFamily + " " + T("|is not applicable|"));
//			continue;
//		}
	// set num of columns depending from association
		int numColumns = numDevices;
		if (nAssociation==2 && numDevices>2 && nMode==0)
			numColumns =(numDevices+1)/2;
		
		//if (dNetWeight<dCLoads[0])numColumns =1;
		vecYLift.vis(ptOrg,nChildDetected);
		vecXP.vis(ptOrg,nChildDetected);
		vecYP.vis(ptOrg,4);

	// set color by selected
		double dOffsetEdge = dOffsetEdgeOverride;
		Map mapChild = mapChilds.getMap(nChildDetected);
		{ 
			String k; 
			Map m = mapChild;
			k = "MaxRange";		if (m.hasDouble(k)) dMaxRange = m.getDouble(k);
			k = "Color";		if (m.hasInt(k)) 	dp.color(m.getInt(k));
			k = "EdgeOffset";	if (m.hasDouble(k)) dOffsetEdge = dOffsetEdgeOverride<=0?mapChild.getDouble(k):dOffsetEdgeOverride;
			
		}

	// get profile
		int bAlert;// if the range cannot be set due to geometry and settings give a graphical alert to the user
	// range profile
		PLine pl;
		pl.createRectangle(LineSeg(ptCen-(.5*vecXP*dX+vecYP*dY),ptCen+(.5*vecXP*dX+vecYP*dY)), vecXP, vecYP);//pl.vis(2);
		PlaneProfile ppRange= ppShadow;
		int bSmallRange = dX-dEps<dOffsetEdge*2 || dY-dEps<dOffsetEdge*2; // version 2.4
		if (!bSmallRange)
			ppRange.shrink(dOffsetEdge);
		//ppRange.extentInDir(vecX).vis(3);		
			
	// on small triangles this still could lead to an invalid range. // LifterTestCases.dwg Case1
		if (ppRange.area()<pow(U(1),2) && ppShadow.area()>pow(U(1),2))
		{
			ppRange= ppShadow;	
			bSmallRange=true;
			bAlert=true;
		}
		
	// case 4471
	// shrinking the  contour results in a segment by segment offset instead of a contour offset
	// this work around will not solve this in all scenarious
	// https://hsbcadbvba-my.sharepoint.com/personal/thorsten_huck_hsbcad_com/_layouts/15/guestaccess.aspx?docid=1b5e27866cef149c68918a35e0b6111e4&authkey=AS0gfpwxivqR2T47e59Y8eY
		if(1)
		{
			PlaneProfile ppTemp = ppRange;
			PLine pl;
			double dX = sip.solidLength()-2*dOffsetEdge;
			double dY = sip.solidWidth()-2*dOffsetEdge;
			// version 4.7: changing seg.ptMid() from pptCen
			pl.createRectangle(LineSeg(seg.ptMid()-.5*(vecX*dX+vecY*dY),seg.ptMid()+.5*(vecX*dX+vecY*dY)), vecX, vecY);
			pl.vis(1);
			
			//HSBCAD-8611 use modified pp only if valid
			ppTemp.intersectWith(PlaneProfile(pl));
			if (ppTemp.area()>pow(dEps,2))
				ppRange = ppTemp;
		}
		//ppRange.extentInDir(vecX).vis(3);	

		ppRange.intersectWith(PlaneProfile(pl));
		// ppRange.vis(222);
		
	// get extents
		seg = ppRange.extentInDir(vecXLift); //seg.vis(i);
		
		if (!bAtCorner)
		{ 
		// get min equidistance	
			double d1 = abs(vecXP.dotProduct(seg.ptStart()-ptCen))*2;
			double d2 = abs(vecXP.dotProduct(seg.ptEnd()-ptCen))*2;		
			dX = d1<d2?d1:d2;	
			dY = abs(vecYP.dotProduct(seg.ptStart()-seg.ptEnd()));	
			
		// triangled shapes could return locations too  closed to each other LifterTestCases.dwg Case2
			if (dX<dOffsetEdge && numColumns>1)
			{
				ppRange= ppShadow;	
				bSmallRange=true;
				bAlert=true;
				ppRange.intersectWith(PlaneProfile(pl));
		
			// get extents
				seg = ppRange.extentInDir(vecXLift); //seg.vis(i);
				// get min equidistance	
				double d1 = abs(vecXP.dotProduct(seg.ptStart()-ptCen))*2;
				double d2 = abs(vecXP.dotProduct(seg.ptEnd()-ptCen))*2;		
				dX = d1<d2?d1:d2;	
				dY = abs(vecYP.dotProduct(seg.ptStart()-seg.ptEnd()));	
	
			}			
		}
		
		pl.createRectangle(LineSeg(ptCen-(.5*vecXP*dX+vecYP*dY),ptCen+(.5*vecXP*dX+vecYP*dY)), vecXP, vecYP);//pl.vis(2);
		ppRange.intersectWith(PlaneProfile(pl));	
		//ppRange.vis(3);	
		dX-=2*dEps;	
		
	// optimal interdistance and local distribution offset
		double dInterdistance = dX;
		if (!bAtCorner)
		{ 
			if (numColumns>1)
				dInterdistance = (dX+(bSmallRange?0:2*dOffsetEdge))/(numColumns-1);// version 2.6
			if (nMode==1)
				dInterdistance=0;			
			else if (dDistributionRelation>0 && dDistributionRelation<=dInterdistance && dDistributionRelation<1)
				dInterdistance = dDistributionRelation*(dX+(bSmallRange?0:2*dOffsetEdge));// version 2.6
			else
				dInterdistance = dDistributionRelation;			
		}

	// set max range
		if (dMaxRange > 0 && dInterdistance > dMaxRange)dInterdistance = dMaxRange;

		nNumDevices[i] = numColumns;

	// create a triangle distribution if uneven and roof assoc	
		int mod = numDevices%2;
	
	// find locations by split locations
		Point3d ptsLocs[0];
		Point3d ptLoc = _Pt0;
		if (nMode==0)
		{
			// 0 = collection
			// 1 = individual device
			// strap length for walls
			double dStrapLengthWall;
			ptLoc=ptCen-vecXP*(numColumns-1)/2*dInterdistance;
			for(int p=0;p<numColumns;p++)
			{
				//ptLoc.vis(p);
				LineSeg segs[] = ppRange.splitSegments(LineSeg(ptLoc-vecYP*dY,ptLoc+vecYP*dY), true);
				//if (bDebug)dp.draw(segs);
				Point3d pts[0];
				for(int s=0;s<segs.length();s++)
				{
					pts.append(segs[s].ptStart());
					pts.append(segs[s].ptEnd());				
				}
				pts = Line(_Pt0, -vecYP).orderPoints(pts);
				
			// snap to closest if outside
				if(pts.length()==0)
				{
					//
					if(nAssociation==1)
					{ 
						// HSB-24434: make sure to take the upper intersection
						Point3d ptClosest=ppRange.closestPointTo(ptLoc);
						Plane pn(ptClosest,vecXP);
						Point3d ptsInter[]=ppRange.intersectPoints(pn,true,false);
						if(ptsInter.length()>0)
						{
							ptsInter=Line(ptsInter.first(),vecYP).orderPoints(ptsInter);
							pts.append(ptsInter.last());
						}
					}
					else
					{ 
						// 
						pts.append(ppRange.closestPointTo(ptLoc));	
					}
				}
				
				
			// wall	
				if (nAssociation==1 && pts.length()>0)
				{
					Point3d pt = pts[0];
					pt.vis(p);
					if (bSmallRange && dX<dY)// version 2.5: small vertical walls LifterTestCases.dwg Case3
					{
						//double _dY = abs(vecYP.dotProduct(pts[1]-pts[0]));
						//version value="4.2" date="20Sep2017" author="thorsten.huck@hsbcad.com"> bugfix small wall panels offset
//						if (_dY>dOffsetEdge && ppRange.pointInProfile(pt-vecYP*dOffsetEdge)!=_kPointOutsideProfile)
//							pt.transformBy(-vecYP*dOffsetEdge);
					}
					else if (bSmallRange)// version 2.4
						pt.setToAverage(pts);//pts[0].transformBy(-vecYLift*dOffsetEdge);
					// 
					if(nFamily==0)
					{ 
						// HSB-24434: lifting strap
						double dStrapLengthWallI;
						Plane pn(pt,vecXP);
						Point3d ptsInter[]=ppShadowOutter.intersectPoints(pn,true,false);
						Point3d ptEdge;
						if(ptsInter.length()>0)
						{ 
							ptsInter=Line(ptsInter.first(),vecYP).orderPoints(ptsInter);
							ptEdge=ptsInter.last();
							dStrapLengthWallI=abs(vecYP.dotProduct(pt-ptEdge));
							if(dStrapLengthWall<dEps)dStrapLengthWall=dStrapLengthWallI;
							if(abs(dStrapLengthWall-dStrapLengthWallI)>U(10))
							{ 
								// different strap lengths noted, show warning
								Map min;
								min.setString("sError",T("|Different lifting strap lengths noted. \PAdjust the distribution|"));
								drawError(sip, min,bdXEnv);
							}
						}
					}
					ptsLocs.append(pt);
				}
			// roof	
				if (nAssociation==2 && pts.length()>0)
				{
				// 1 device
					if (numDevices==1 || numDevices>3)
						ptsLocs.append(pts[0]);	
					
				// diagonal ( 2 devices )
					else if (numDevices==2)
					{
						if (p==0)
							ptsLocs.append(pts[0]);
						else if (pts.length()>1)
							ptsLocs.append(pts[pts.length()-1]);	
					}	
					else if (numDevices==3)
					{
						if (p==0)
						{
							ptsLocs.append(pts[0]);
							if (pts.length()>1)ptsLocs.append(pts[pts.length()-1]);	
						}
						else if (pts.length()>1)
							ptsLocs.append((pts[0]+pts[pts.length()-1])/2);	
						else
							ptsLocs.append(pts[0]);	
					}	
				// more then 3 devices	
					if (numDevices>3 && pts.length()>1)
						ptsLocs.append(pts[pts.length()-1]);
				}
		
				ptLoc.transformBy(vecXP*dInterdistance );
			}// next p
		}
		else
			ptsLocs.append(_Pt0);
			

				
	// display selected child in debug		
		if(0 && bDebug)
		{
			for(int p=0;p<ptsLocs.length();p++)
			{
				dp.draw(dCLoads[nChildDetected], ptsLocs[p], vecXP, vecYP,0,1.5);
				dp.draw(dNetWeight+"kg", ptsLocs[p], vecXP, vecYP,0,-1.5);
				
				PLine(ptsLocs[p],ptCen).vis(p);
			}
		}
//	
	// draw warning
		if(!bChildIsValid && nChildDetected>-1 && nMode==0)
		{
		// report warning
			String sWeight; sWeight.formatUnit(dNetWeight,2,1);
			reportMessage("\n" + scriptName() + ": " + sPanelPosText+" " + 
				T("|The maximum load of|") + " " + sCNames[nChildDetected] + " "+ ptsLocs.length()+"x"+dCLoads[nChildDetected] +"kg"+  + " " + T("|cannot carry the weight of|")+ " "+sWeight+"kg");
		}
			
		mapLocations[i].setPoint3dArray("ptsLocs", ptsLocs);
		mapLocations[i].setMap("child", mapChild);
		mapLocations[i].setInt("Alert", !bChildIsValid ||bAlert);
	}//endregion next i

// add triggers to change family
	String sChangeFamilies[0];sChangeFamilies= sFamilies;
	sChangeFamilies.removeAt(nFamily);// remove the current family

	//if (nMode==0)
	for (int i=0;i<sChangeFamilies.length();i++)
	{
		String sTrigger = "-> "+sChangeFamilies[i];
		addRecalcTrigger(_kContext, sTrigger);
		if ((_bOnRecalc && _kExecuteKey==sTrigger) || (nReplaceFamily>-1)) 
		{
			sTrigger.trimLeft();
		// store the previous family: in case the new one fails	it can be reset to the previous
			_Map.setInt("previousFamily", nFamily);
			int nNewFamily = sFamilies.find(sChangeFamilies[i]);
			
			// this should never be hit since //	Deprecated version 1.4
			if (nReplaceFamily>-1)
				nNewFamily = nReplaceFamily;
				
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= vecX;
			Vector3d vecYTsl= vecY;
			GenBeam gbsTsl[] = {sip};
			Entity entsTsl[] = {};
			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={nQuantity};
			double dProps[]={dDiameterOverride,dDepthOverride,dOffsetEdgeOverride};
			String sProps[]={sDistributionOffset,sChild,sAssociation};
			Map mapTsl = _Map;
			mapTsl.setInt("Family",nNewFamily);
			
			String sScriptname = scriptName();			
		// create device
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
			tslNew.transformBy(Vector3d(0, 0, 0));
			eraseInstance();
			return;		
		}
	}

// trigger show in shopdraw
	if (mapGeneral.hasInt("RequestShopdraw") && _bOnDbCreated)
		_Map.setInt("RequestShopdraw",mapGeneral.getInt("RequestShopdraw"));	
	int bShowDimRequest = _Map.getInt("RequestShopdraw");
	String sTriggerShopdraw = bShowDimRequest?T("|Hide Dimension in Shopdrawing|"):T("|Show Dimension in Shopdrawing|");	
	addRecalcTrigger(_kContext, sTriggerShopdraw);
	if (_bOnRecalc && _kExecuteKey==sTriggerShopdraw) 
	{
		if (bShowDimRequest)	bShowDimRequest =false;
		else bShowDimRequest=true;
		_Map.setInt("RequestShopdraw",bShowDimRequest);	
		setExecutionLoops(2);
		return;
	}
	
// triggers to add/remove or flip an additional marking drill
	int bAddMarkDrill = _Map.getInt("MarkDrill");
	String sTriggerToggleMarkDrill =bAddMarkDrill?T("|Remove Marking Drill|"):T("|Add Marking Drill|");
	
// add trigger only for R0 'Hebeschlaufe' and Association Roof/Floor	
	if (nFamily==0 && nAssociation==2)
		addRecalcTrigger(_kContextRoot, sTriggerToggleMarkDrill);
	if (_bOnRecalc && _kExecuteKey==sTriggerToggleMarkDrill)
	{
		bAddMarkDrill = bAddMarkDrill ? false : true;
		_Map.setInt("MarkDrill", bAddMarkDrill);

		
		setExecutionLoops(2);
		return;
	}
	
// Trigger to control depth or alignment
	double dMarkDrillDepth = _Map.hasDouble("MarkDrillDepth") ?_Map.getDouble("MarkDrillDepth"): U(10);	

// Trigger SetMarkingDepth
	if (bAddMarkDrill)
	{ 
		String sTriggerSetMarkingDepth = T("|Set Marking Depth/Alignment|");
		addRecalcTrigger(_kContextRoot, sTriggerSetMarkingDepth );
		if (_bOnRecalc && (_kExecuteKey==sTriggerSetMarkingDepth || _kExecuteKey==sDoubleClick))
		{
			dMarkDrillDepth = getDouble(T("|Depth of marking drill, sign flips side| (") + dMarkDrillDepth + ")");
			_Map.setDouble("MarkDrillDepth", dMarkDrillDepth);	
			
		// remove if depth set to 0 
			if (dMarkDrillDepth==0)
			{
				_Map.removeAt("MarkDrillDepth", true);
				_Map.removeAt("MarkDrill", true);
				reportMessage(TN("|Marking Drill removed.|"));
				
			}
			setExecutionLoops(2);
			return;
		}		
	}

// Trigger ToolOff
	int bToolOff = _Map.getInt("ToolOff");
	String sTriggerToolOff =bToolOff?T("|Add CNC tooling|"):T("|No CNC tooling|");
	addRecalcTrigger(_kContextRoot, sTriggerToolOff);
	if (_bOnRecalc && _kExecuteKey==sTriggerToolOff)
	{
		bToolOff = bToolOff ? false : true;
		_Map.setInt("ToolOff", bToolOff);		
		setExecutionLoops(2);
		return;
	}
	




// add edit in place trigger
	int bCreateSingles;
	if(nMode==0)
	{
		String sTriggerEditInPlace= T("|Edit in Place|");
		addRecalcTrigger(_kContextRoot, sTriggerEditInPlace);
		if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace) 
		{
			setCatalogFromPropValues(sLastInserted);	
			vecXTsl =vecX;
			vecXTsl =vecY;

			gbsTsl[0] = sip;
			mapTsl = _Map;
			mapTsl.setInt("mode",1);
			mapTsl.setInt("Family",nFamily);
			bCreateSingles=true;
			//bDebug=true;
		}
	}// end if add edit in place trigger


// set a flag if all relevant properties are in auto mode. if in auto mode the shopdraw requests will suppress the description
	int bAutoMode = dDiameterOverride<=0 && dDepthOverride<=0;



// FAMILY TYPE OVERRIDES
	Display dpErr(1);
	dpErr.showInDxa(true);// HSB-23000
	if(bDebug)dpErr.draw(_ThisInst.opmName(),_Pt0, _XW,_YW,0,0,_kDeviceX);


// get firstOrDefault
	double dDefaultDiameter =U(30);
	if (mapLocations.length()>0)
	{
		double d = mapLocations[0].getMap("child").getDouble("Diameter");
		if (d<=0) d=mapLocations[0].getMap("child").getDouble("Width");
		dDefaultDiameter = abs(d)<dEps?U(30):d;
	}


// define a pline cross for visualization//region
	PLine plCross(vecFace);
	plCross.addVertex(_Pt0);
	plCross.addVertex(_Pt0-vecX*dDefaultDiameter*.7);
	plCross.addVertex(_Pt0+vecX*dDefaultDiameter*.7);
	plCross.addVertex(_Pt0);
	plCross.addVertex(_Pt0-vecY*dDefaultDiameter*.7);
	plCross.addVertex(_Pt0+vecY*dDefaultDiameter*.7);	
	
// rotate by 45°
	CoordSys csRot;
	csRot.setToRotation(45,vecZ,_Pt0);
	plCross.transformBy(csRot);	
	//plCross.vis(40);
//endregion

// alert profile
	PlaneProfile ppAlert(CoordSys(_Pt0,vecX, vecY, vecZ));
	{
		PLine plAlert;
		plAlert.createCircle(_Pt0,vecZ,dDefaultDiameter);
		ppAlert.joinRing(plAlert, _kAdd);
		plAlert.createCircle(_Pt0,vecZ,dDefaultDiameter*.7);
		ppAlert.joinRing(plAlert, _kSubtract);		
	}


// collection of edge vectors, used to specify exlusive dimension requests
	Vector3d vecEdges[0];

// declare hardware components	
	int nQty;

	Point3d ptsDimLocs[0];
	CoordSys csDimLocs[0];
	int bAlert;
	double dTxtOffset;
	String sTxt;

// get some parameters from first entry
	String sArticle;
	Map mapDevice;
	int nColor;
	if(mapLocations.length()>0)
	{
		Map mapChild = mapLocations[0].getMap("child");
		mapDevice = mapChild;
		sArticle =  mapChild.getString("Name");
		nColor = mapChild.getInt("Color");
	}
//End PART 2//endregion 		

//region PART 3 Rules
// R0: RULE HEBESCHLAUFE
	if (nRule == 0) 
	{
		category = sCategoryTooling;
		String sInterdistanceName=T("|Interdistance|");
		PropDouble dInterdistanceOverride(nDoubleIndex++, U(0), sInterdistanceName);	
		dInterdistanceOverride.setCategory(category);
		dInterdistanceOverride.setDescription(T("|Defines the interdistance of a double drill.|") + " " + T("|Only applicable for floor/roof sAssociations and type Hebeschlaufe.|"));	
		if (nAssociation!=2)
		{ 
			dInterdistanceOverride.setReadOnly(true);
			if (abs(dInterdistanceOverride)>0)
				dInterdistanceOverride.set(0);
		}

	
	// get bounding envelope contour
		PLine plBox;
		Body bdEnv= sip.envelopeBody();
		PlaneProfile ppEnv = bdEnv.shadowProfile(pnZ);

	// get extents of profile
		LineSeg segEnv = ppEnv.extentInDir(vecX);
		double dXEnv = abs(vecX.dotProduct(segEnv.ptStart()-segEnv.ptEnd()));
		double dYEnv = abs(vecY.dotProduct(segEnv.ptStart()-segEnv.ptEnd()));
		plBox.createRectangle(segEnv, vecX, vecY);
		//plBox.vis(2);


	// enlarge opening
		PlaneProfile _ppOpening = ppOpening;
		if (mapLocations.length()>0)
		{ 
			Map mapChild = mapLocations[0].getMap("child");
			double dShrink = dDiameterOverride>0?dDiameterOverride:mapChild.getDouble("Diameter");
			_ppOpening.shrink(-dShrink);
		}
		//_ppOpening.vis(4);
	
	// count the potential intersections with an opening and get the potential flag of loose devices
		int nNumIntersect;
		int bIsLooseDevice = _Map.getInt("IsLooseDevice");
		
		double dDiameter,dDiameterEdge, dDrillDepth,dInterdistance,dInterdistanceAngle;
		
		for (int i=0;i<mapLocations.length();i++) 
		{ 
			Point3d ptsLocs[] = mapLocations[i].getPoint3dArray("ptsLocs");
			Map mapChild = mapLocations[i].getMap("child");

			Vector3d vecLift = vecLifts[i].isParallelTo(vecZ)?vecX:vecLifts[i];
			Vector3d vecEdge = vecLift;
			Vector3d vecLiftPerp = vecLift.crossProduct(-vecFace);
			bAlert=mapLocations[i].getInt("Alert");
			nQty+=ptsLocs.length();	

		// realign vecLift for roof/floor associations
			if (nAssociation==2)
			{ 
				vecLift = vecLiftPerp;
			}

			dDiameter = dDiameterOverride>0?dDiameterOverride:mapChild.getDouble("Diameter");
			double dValue = dDepthOverride<=0?mapChild.getDouble("Depth"):dDepthOverride;
			dDrillDepth = dValue<=0?dH:dValue;

			dInterdistance=dInterdistanceOverride>0?dInterdistanceOverride:mapChild.getDouble("Interdistance");
			dInterdistanceAngle=mapChild.getDouble("InterdistanceAngle"); // HSB-5563
			double dInterdistanceDelta = abs(dInterdistanceAngle)>0?dInterdistance * tan(dInterdistanceAngle):0;
			
		// get mapX entry of tool HSB-13393
			Map mapAdditional;
			mapAdditional.setString(T("|Type|"), mapChild.getString("Name") );
			String sToolDescription = _ThisInst.formatObject(sFormatTool,mapAdditional);

			for (int p=0;p<ptsLocs.length();p++) 
			{
				Point3d ptLoc = ptsLocs[p];
				ptLoc.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptLoc)+.5*dH));// vecLift.vis(ptLoc,i);

			// test if location is within an opening
				int bAddTool = true;
				if (_ppOpening.pointInProfile(ptLoc)==_kPointInProfile)
				{ 
					//_ppOpening.vis(4);	
					nNumIntersect++;
					
					if (!bIsLooseDevice)
					{ 
						PlaneProfile pp; pp.createRectangle(LineSeg(ptLoc - (vecX +vecY) * U(100), ptLoc + (vecX +vecY) * U(100)), vecX, vecY);
						Display dpErr(1);
						dpErr.showInDxa(true);// HSB-23000
						dpErr.draw(pp,_kDrawFilled, 30);						
					}
					else
					{
						sArticle="L"+sArticle;
						mapDevice.setString("Name",sArticle);
						mapDevice.setDouble("Diameter",0);
						mapDevice.setDouble("Depth",0);	
						bAddTool = false;
					}
				}

			// create individuals
				if(bCreateSingles)
				{
					ptsTsl[0] = ptLoc;
					nProps[0]=1;

				// set lifting direction
					Map mapDirections;
					mapDirections.appendVector3d("LiftDirection", vecLift);
					mapTsl.setMap("LiftDirection[]", mapDirections);
					if (bIsLooseDevice)
						mapTsl.setInt("IsLooseDevice", bIsLooseDevice);
					
				// create device
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
					if (tslNew.bIsValid())
					{
						tslNew.setPropValuesFromCatalog(sLastInserted);
						tslNew.setPropInt(0,1); // qty
						tslNew.setPropString(nChildIndex,sArticle);// child
						if(bDebug)reportMessage("\n rule " + nRule +" succesfully created with child " + tslNew.propString(nChildIndex));
					}
					continue;
				}

				ptsDimLocs.append(ptLoc);
				
			// add additonal drill tool
				Point3d ptNext = plBox.closestPointTo(ptLoc);
				ptNext.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptNext)+.5*dH));	
				Point3d pt1 = ptLoc+vecZ*vecZ.dotProduct(ptNext-ptLoc);//pt1.vis(6);
				Vector3d vecNormal = ptNext-pt1;//vecDir;	
				vecNormal.normalize();
				//vecNormal.vis(pt1,6);
				vecEdge = vecNormal;
				Vector3d vecPerp = vecNormal.crossProduct(vecZ); // 6.2 use perp vec instead of vecX
				
			// get sign of potential location offset when angled double drill is required
				double _dInterdistanceDelta =dInterdistanceDelta * (vecPerp.dotProduct(ptCen - ptLoc) > 0 ? 1 :- 1);				
				
			// add the tool
				if (bAddTool && !bToolOff)
				{ 
					Point3d pt = ptLoc+vecPerp*.5*_dInterdistanceDelta;//// HSB-5563
					Drill drill(pt,pt-vecFace*dDrillDepth, dDiameter*.5); //drill.cuttingBody().vis(5);	
					// HSB-24434:
//					{ 
//						Map mapXdrill;
//						mapXdrill.setString("ToolType","hsbCLT-Lifter");
//						drill.setSubMapX("MapxToolType",mapXdrill);
//					}
				// HSB-13393 write tool description format	
					if (sMapXName.length()>0 && sKeyName.length()>0 && sToolDescription.length()>0)
					{ 
						Map mapX;
						mapX.setString(sKeyName, sToolDescription);
						drill.setSubMapX(sMapXName,mapX);				
					}		
					sip.addTool(drill);
					// HSB-14334:
					if (dInterdistance>0)
					{
						drill.transformBy(-vecNormal*dInterdistance-vecPerp*_dInterdistanceDelta);// HSB-5563
						sip.addTool(drill);
					}						
				}
			
			// add marking drill
				if (bAddMarkDrill && p==0)
				{ 
					Vector3d vec = dMarkDrillDepth<0?-vecZ:vecZ;
					Point3d pt = ptLoc - vecNormal * .5*dInterdistance;
					pt.transformBy(vec * (vec.dotProduct(ptOrg - pt) + .5 * dH));
					pt.vis(3);
					Drill drMark(pt,pt-vec*abs(dMarkDrillDepth), dDiameter*.5);
					// HSB-24434:
//					{ 
//						Map mapXdrill;
//						mapXdrill.setString("ToolType","hsbCLT-Lifter");
//						drMark.setSubMapX("MapxToolType",mapXdrill);
//					}
					sip.addTool(drMark);
					
				// add symbol and description
	
				// read potential settings of a marking drill from grain direction settings
					// read a potential mapObject
					MapObject mo2(sDictionary ,"hsbGrainDirection");
					int nMarkColor = 12;
					double dMarkTextHeight = dTxtHeight;
					String sDescription = "X";
					if (mo2.bIsValid())
					{
						Map m;
						m=mo2.map().getMap("MarkingDrill");;
						setDependencyOnDictObject(mo2);
						
					// parameters of marking drill
						nMarkColor = m.getInt("color");
						dMarkTextHeight= m.getDouble("textHeight");	
						sDescription = m.getString("description");
					}					
					
				// add symbol
					double dRadius = dDiameter * .5;
					PLine pl(pt + (vecX + vecY) *dRadius, pt - (vecX + vecY)* dRadius, pt, pt -(vecX -vecY) * dRadius);
					pl.addVertex(pt + (vecX - vecY) * dRadius);
					
					Display dp(nMarkColor);
					dp.showInDxa(true);// HSB-23000
					if (dMarkTextHeight > 0)dp.textHeight(dMarkTextHeight);
					
					{ 
						dp.draw(pl);
						mapRequest = Map();
						mapRequest.setInt("Color", nMarkColor);
						mapRequest.setVector3d("AllowedView", vecZ);				
						mapRequest.setPLine("pline", pl);	
						mapRequests.appendMap("DimRequest",mapRequest);						
					}
	
					if (sDescription.length() > 0)
					{
						double d =.3*dMarkTextHeight /dRadius;
						dp.draw(sDescription,pt , vecX, vecY, d, d, _kDevice);
						
						mapRequest = Map();
						mapRequest.setInt("Color", nMarkColor);
						mapRequest.setVector3d("AllowedView", vecZ);
						mapRequest.setInt("AlsoReverseDirection", true);		
						mapRequest.setDouble("textHeight", dMarkTextHeight);				
						mapRequest.setPoint3d("ptLocation",pt );		
						mapRequest.setDouble("dXFlag", d);
						mapRequest.setDouble("dYFlag", d);			
						mapRequest.setString("text", sDescription);	
						mapRequests.appendMap("DimRequest",mapRequest);	
					}				
				}

			// string builder for dimRequests			
				sTxt = bAutoMode?sArticle:sArticle + " ø" + dDiameter + "x" + dDrillDepth;	
				vecEdge.vis(ptLoc,2);
				vecEdges.append(vecEdge);
			}
		}// next i	
		
	// store overrides
		if (!bIsLooseDevice && nNumIntersect<1)
		{ 
			mapDevice.setDouble("Diameter",dDiameter);
			mapDevice.setDouble("Depth",dDrillDepth);			
		}
		dTxtOffset=dDiameter;
		
	// Trigger LooseDevice
		String sTriggerLooseDevice = bIsLooseDevice? T("|Remove loose lifting device|")  :T("|Add loose lifting device|");
		if (nNumIntersect>0)
		{ 
			addRecalcTrigger(_kContextRoot, sTriggerLooseDevice );
			if (_bOnRecalc && _kExecuteKey==sTriggerLooseDevice)
			{
			// remove the entry	
				if (bIsLooseDevice)
					_Map.removeAt("IsLooseDevice", true);
			// add override to map
				else
					_Map.setInt("IsLooseDevice", true);
				setExecutionLoops(2);
				return;
			}	
		}
	}

// R1: RULE RAMPA
	else if (nRule == 1) 
	{
		double dScaleZ;
		double dDiameter;
		double dDrillDepth;

		for (int i=0;i<mapLocations.length();i++) 
		{ 
			Point3d ptsLocs[] = mapLocations[i].getPoint3dArray("ptsLocs");
			Map mapChild = mapLocations[i].getMap("child");
			Vector3d vecLift = vecLifts[i].isParallelTo(vecZ)?vecY:vecLifts[i];
			Vector3d vecLiftPerp = vecLift.crossProduct(-vecFace);		
			nQty+=ptsLocs.length();	
			
			dDiameter = dDiameterOverride>0?dDiameterOverride:mapChild.getDouble("Diameter");
			dScaleZ=mapChild.getDouble("Depth");
			dDrillDepth = dDepthOverride<=0?dScaleZ:dDepthOverride;
			
		// get mapX entry of tool HSB-13393
			Map mapAdditional;
			mapAdditional.setString(T("|Type|"), mapChild.getString("Name") );
			mapAdditional.setDouble(T("|Diameter|"), dDiameter );
			String sToolDescription = _ThisInst.formatObject(sFormatTool,mapAdditional);	

		// loop locations
			for (int p=0;p<ptsLocs.length();p++) 
			{
				Point3d ptLoc = ptsLocs[p];
				Vector3d vecZTool = -vecFace; // roof/floor
				Vector3d vecEdge = vecLift;
				//vecEdge.vis(ptLoc,3);
				double dThisDrillDepth = dDrillDepth; // could vary for gable walls or beveled edges with wall association
			// wall mode
				if (nAssociation==1)
				{	
					vecZTool=-vecLift;

				// test alignment of the closest edge
					double dDist = plShadow.length();
					SipEdge edgeX;
					for (int e=0;e<edges.length();e++)
					{
						SipEdge edge = edges[e];
						PLine pl = edge.plEdge();pl.vis(e);
						double d=(pl.closestPointTo(ptLoc)-ptLoc).length();
						Vector3d vec = edge.vecNormal().crossProduct(vecFace).crossProduct(-vecFace);
						if (d<dDist && vecZTool.dotProduct(vec)<0 && !vecZTool.isPerpendicularTo(vec))
						{
							dDist=d;
							edgeX=edge;	
						}
					}
					

				// align with edge if not parallel
					Plane pnEdge(ptLoc,-vecZTool);
					if (edgeX.plEdge().length()>0)
					{
						//edgeX.plEdge().vis(2);
						Vector3d vecNormal = edgeX.vecNormal();
						pnEdge=Plane(edgeX.ptMid(), vecNormal);
						vecZTool = -vecNormal.crossProduct(vecZ).crossProduct(-vecZ);
						vecZTool.normalize();
						Point3d pts[] = Line(ptLoc,-vecLift).orderPoints(plShadow.intersectPoints(Plane (ptLoc,vecLiftPerp)));
						if (pts.length()>0)ptLoc = pts[0];
					}
					ptLoc.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptLoc)));	
				
				// add extra drill depth if beveled
					if (!vecZTool.isParallelTo(pnEdge.vecZ()))
					{
						Point3d pt = Line(ptLoc,vecZTool).intersect(pnEdge,0);
						Point3d pt2 = Line(ptLoc+vecZ*.5*dDiameter,vecZTool).intersect(pnEdge,0);
						//pt.vis(2);
						double d = vecZTool.dotProduct(pt-ptLoc);
						d += abs(d-vecZTool.dotProduct(pt2-ptLoc));
						dThisDrillDepth+=d;
					}					
					
				//transform to the edge of the panel
					if (i==0 && p==0)
					{
						CoordSys cs;
						cs.setToAlignCoordSys(ptLoc, vecX, vecY, vecZ, ptLoc, vecFace.crossProduct(vecZTool), vecFace, -vecZTool);
						plCross.transformBy(cs);
					}		
				}			
			// roof/floor mode
				else
				{
				
					ptLoc.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptLoc)+.5*dH)); ptLoc.vis(i);
				}
			// create individuals
				if(bCreateSingles)
				{
					ptsTsl[0] = ptLoc;
					nProps[0]=1;

				// set lifting direction
					Map mapDirections;
					mapDirections.appendVector3d("LiftDirection", vecLift);
					mapTsl.setMap("LiftDirection[]", mapDirections);
					
				// create device
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
					if (tslNew.bIsValid())
					{
						tslNew.setPropValuesFromCatalog(sLastInserted);
						tslNew.setPropInt(0,1); // qty
						tslNew.setPropString(nChildIndex,sArticle);// child
						if(bDebug)reportMessage("\n rule " + nRule +" succesfully created with child " + tslNew.propString(nChildIndex));
					}
					continue;
				}
				ptsDimLocs.append(ptLoc);

			// add the tool
				if (!bToolOff)
				{ 
					Drill drill(ptLoc,ptLoc+vecZTool*dThisDrillDepth, dDiameter*.5);drill.cuttingBody().vis(5);
					// HSB-13393 write tool description format
					if (sMapXName.length() > 0 && sKeyName.length() > 0 && sToolDescription.length() > 0)
					{
						Map mapX;
						mapX.setString(sKeyName, sToolDescription);
						drill.setSubMapX(sMapXName, mapX);
					}
					sip.addTool(drill);					
				}

			// string builder for dimRequests			
				sTxt = bAutoMode?sArticle:sArticle + " ø" + dDiameter + "x" + dDrillDepth;
				vecZTool.vis(ptLoc,2);	
				vecEdges.append(vecEdge);
				
			// draw Pitzl Pick lifting device
				if(bIsPitzl)	
				{
					Body bdModelLift;			
					bdModelLift = Body (ptLoc, ptLoc + vecZTool * U(68), U(25));
					bdModelLift = bdModelLift + Body (ptLoc, ptLoc - vecZTool * U(26), U(47));
					bdModelLift = bdModelLift + Body (ptLoc - vecZTool * U(26), ptLoc - vecZTool * U(45), U(33));
					bdModelLift = bdModelLift + Body (ptLoc - vecZTool * U(45), ptLoc - vecZTool * U(82), U(16));
					dp.draw(bdModelLift);				
				}						
			}
		}// next i
	
	// store overrides
		mapDevice.setDouble("Diameter",dDiameter);
		mapDevice.setDouble("Depth",dDrillDepth);
		dTxtOffset=dDiameter;
	}	

// R2: RULE WÜRTH
	else if (nRule == 2) 
	{
		double dXTool, dYTool,dZTool;

		category = sCategoryTooling;
		String sWidthName=T("|Width|");
		int nYOverrideIndex = nDoubleIndex++;// store index for redeclaration
		PropDouble dYOverride(nYOverrideIndex, 0, sWidthName);	
		dYOverride.setCategory(category);
		dYOverride.setDescription(T("|Specifies an override of the default value.|"));


	// override property name if beamcut definition found
		if (mapLocations.length()>0 && mapLocations[0].getMap("child").hasDouble("Width"))
		{
			dDiameterOverride = PropDouble(0, 0, T("|Length|"));
			dDepthOverride =PropDouble (nDepthIndex, 0, sDepthName);
			dYOverride =PropDouble (nYOverrideIndex, 0, sWidthName);	

			nQuantity = PropInt (nQuantityIndex, 0, sQuantityName,0);	
			dOffsetEdgeOverride = PropDouble (nOffsetEdgeIndex, U(200), sOffsetEdgeName);	
			sDistributionOffset = PropString (nDistributionOffsetindex, "", sDistributionOffsetName);

			sChild = PropString (nChildIndex, sAllChilds, sChildName);
			sAssociation= PropString(nAssociationIndex, sAssociations, sAssociationName,0);
		}
		else
			dYOverride.setReadOnly(true);

		int bIsDrill,bIsBeamcut;
		for (int i=0;i<mapLocations.length();i++) 
		{ 
			Point3d ptsLocs[] = mapLocations[i].getPoint3dArray("ptsLocs");
			Map mapChild = mapLocations[i].getMap("child");
			Vector3d vecLift = vecLifts[i].isParallelTo(vecZ)?vecY:vecLifts[i];
			Vector3d vecLiftPerp = vecLift.crossProduct(-vecFace);
			vecLift.vis(_Pt0, 2);
			nQty+=ptsLocs.length();	

		// drill
			if (mapChild.hasDouble("Diameter"))
			{ 
				bIsDrill=true;
				dXTool = dDiameterOverride>0?dDiameterOverride:mapChild.getDouble("Diameter");	
				dYTool = dXTool;
			}
		// beamcut
			else if (mapChild.hasDouble("Length") || mapChild.hasDouble("Width"))
			{ 
				bIsBeamcut=true;
				dXTool = dDiameterOverride>0?dDiameterOverride:mapChild.getDouble("Length");
				dYTool = dYOverride>0?dYOverride:mapChild.getDouble("Width");
			}

		// get mapX entry of tool HSB-13393
			Map mapAdditional;
			mapAdditional.setString(T("|Type|"), mapChild.getString("Name") );
			if (bIsDrill)mapAdditional.setDouble(T("|Diameter|"), dXTool );
			if (bIsBeamcut)
			{
				mapAdditional.setDouble("Length", dXTool );
				mapAdditional.setDouble("Width", dYTool );		
			}			
			String sToolDescription = _ThisInst.formatObject(sFormatTool,mapAdditional);


			
			for (int p=0;p<ptsLocs.length();p++) 
			{
				dZTool = dDepthOverride<=0?mapChild.getDouble("Depth"):dDepthOverride;
				Point3d ptLoc = ptsLocs[p];
				Vector3d vecZTool = -vecFace;
				Vector3d vecEdge = vecLift;
				Plane pnLoc(ptLoc, vecZTool);
				
			// wall mode
				if (nAssociation==1)
				{	
					vecZTool=-vecLift;

				// test alignment of the closest edge
					double dDist = plShadow.length();
					SipEdge edgeX;
					for (int e=0;e<edges.length();e++)
					{
						SipEdge edge = edges[e];
						PLine pl = edge.plEdge();
						double d=(pl.closestPointTo(ptLoc)-ptLoc).length();
						Vector3d vec = edge.vecNormal().crossProduct(vecFace).crossProduct(-vecFace);
						if (d<dDist && vecZTool.dotProduct(vec)<0 && !vecZTool.isPerpendicularTo(vec))
						{
							dDist=d;
							edgeX=edge;	
						}
					}
					

				// align with edge if not parallel
					if (edgeX.plEdge().length()>0)
					{
						edgeX.plEdge().vis(2);
						vecZTool = -edgeX.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
						vecZTool.normalize();
						plShadow.vis(222);
						Point3d pts[] = Line(ptLoc,-vecLift).orderPoints(plShadow.intersectPoints(Plane (ptLoc,vecLiftPerp)));//
						if (pts.length()>0)ptLoc = pts[0];
						
						pnLoc=Plane(edgeX.ptMid(), edgeX.vecNormal());

						
						vecLiftPerp.vis(ptLoc,4);
					}
					ptLoc.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptLoc)));
					
				// project to beveled edge (case 5)
				// https://hsbcadbvba-my.sharepoint.com/personal/thorsten_huck_hsbcad_com/_layouts/15/guestaccess.aspx?docid=16629704e52c944d3a94b3386220fd15a&authkey=AYjPZ_d4ThNCimuciQdzVX8
					int bOk = Line(ptLoc, vecLift).hasIntersection(pnLoc,ptLoc);
					vecZTool.vis(ptLoc,2);
					
				// add additional depth if beveled
					{
						Point3d pt1 = ptLoc+.5*vecZ*dYTool;
						Point3d pt2;
						int bOk = Line(pt1, vecLift).hasIntersection(pnLoc,pt2);
						double dExtraDepth = bOk?abs(vecZTool.dotProduct(pt1-pt2)):0;
						dZTool+=dExtraDepth;
					}
				}
			// roof/floor mode	
				else
					ptLoc.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptLoc)+.5*dH)); 
				
			// create individuals
				if(bCreateSingles)
				{
					ptsTsl[0]=ptLoc;
					nProps[0]=1;
					
				// set lifting direction
					Map mapDirections;
					mapDirections.appendVector3d("LiftDirection", vecLift);
					mapTsl.setMap("LiftDirection[]", mapDirections);
					
				// create device
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);	
					
					if (tslNew.bIsValid())
					{
						tslNew.setPropValuesFromCatalog(sLastInserted);
						tslNew.setPropInt(0,1); // qty
						tslNew.setPropString(nChildIndex,sArticle);// child
						if(bDebug)reportMessage("\n rule " + nRule+ " succesfully created with child " + tslNew.propString(nChildIndex));
					}
					continue;
				}
				
				ptLoc.vis(i);
				ptsDimLocs.append(ptLoc);	
				
			// set local coordSys // 2.7
				Vector3d vecXTool = vecZ.crossProduct(-vecZTool);vecXTool.normalize();
				Vector3d vecYTool = vecXTool.crossProduct(vecZTool);vecYTool.normalize();
				csDimLocs.append(CoordSys(ptLoc, vecXTool, vecYTool, vecZTool));
				
			// add the drill
				if (bIsDrill && !bToolOff)
				{
					Drill drill(ptLoc-vecZTool*dZTool,ptLoc+vecZTool*dZTool, dXTool*.5);//drill.cuttingBody().vis(5);
					// HSB-13393 write tool description format
					if (sMapXName.length()>0 && sKeyName.length()>0 && sToolDescription.length()>0)
					{ 
						Map mapX;
						mapX.setString(sKeyName, sToolDescription);
						drill.setSubMapX(sMapXName,mapX);
					}
					
					sip.addTool(drill);
					
				// string builder for dimRequests			
					sTxt = bAutoMode?sArticle:sArticle + " ø" + dXTool + "x" + dZTool;					
				}
			// add the beamcut
					if (bIsBeamcut && !bToolOff)
					{
						BeamCut bc(ptLoc, vecXTool, vecYTool, vecZTool, dXTool, dYTool, dZTool * 2, 0, 0, 0 );//bc.cuttingBody().vis(5);

						// HSB-13393 write tool description format
						if (sMapXName.length() > 0 && sKeyName.length() > 0 && sToolDescription.length() > 0)
						{
							Map mapX;
							mapX.setString(sKeyName, sToolDescription);
							bc.setSubMapX(sMapXName, mapX);
						}
						sip.addTool(bc);
					
				// redefine cross for quader tools
					if (i==0 && p==0)
					{
						Quader qdr(ptLoc,vecXTool, vecYTool, vecZTool,dXTool, dYTool, dZTool*2, 0,0,0 );
						plCross = PLine(vecZ);
						plCross.addVertex(qdr.pointAt(0,0,0));
						plCross.addVertex(qdr.pointAt(1,0,0));
						plCross.addVertex(qdr.pointAt(-1,0,0));
						plCross.addVertex(qdr.pointAt(0,0,0));	
						plCross.addVertex(qdr.pointAt(0,-1,0));
						plCross.addVertex(qdr.pointAt(0,1,0));
					}
				// string builder for dimRequests			
					sTxt = bAutoMode?sArticle:sArticle+" "+dXTool+"x"+dYTool+"x"+dZTool;	
				}
				
				vecEdge.vis(ptLoc,2);
				vecEdges.append(vecEdge);
			}
		}
	// store overrides
		if (bIsBeamcut)
		{
			mapDevice.setDouble("Length",dXTool);
			mapDevice.setDouble("Width",dYTool);
		}
		else if (bIsDrill)
		{
			mapDevice.setDouble("Diameter",dXTool);
		}
		mapDevice.setDouble("Depth",dZTool);
		dTxtOffset=dXTool;
	}// END IF _____ WÜRTH	_____ WÜRTH	_____ WÜRTH	_____ WÜRTH	
	
// R3: RULE STEEL ANCHOR
	else if (nRule==3) 
	{
	// Edge drill overrides
		category =T("|Edge Drill|");
		String sDefaultValueMsg = T("|0 = use defaults|");
		String sDepthEdgePropName=T("|Depth|")+" ";
		PropDouble dDepthEdgeProp(nDoubleIndex++, U(0), sDepthEdgePropName);	
		dDepthEdgeProp.setCategory(category);
		dDepthEdgeProp.setDescription(T("|Defines the depth of the edge drill.|") + " " + sDefaultValueMsg);	
		
		String sDiameterEdgeName=T("|Diameter|")+" ";
		PropDouble dDiameterEdgeProp(nDoubleIndex++, U(0), sDiameterEdgeName);	
		dDiameterEdgeProp.setCategory(category);
		dDiameterEdgeProp.setDescription(T("|Defines the Diameter of the edge drill.|")+ " " + sDefaultValueMsg);
		
		String sOffsetEdgePropName=T("|Z-Offset|");
		PropDouble dZOffsetEdgeProp(nDoubleIndex++, U(0), sOffsetEdgePropName);	
		dZOffsetEdgeProp.setCategory(category);
		String sOffsetEdgeDescription = T("|Defines the Offset of the edge drill.|") + " " + sDefaultValueMsg;
		
	// redeclare properties for a better user experience / sequence of properties
		{ 
			nQuantity = PropInt (nQuantityIndex, 0, sQuantityName,0);	
			dOffsetEdgeOverride = PropDouble (nOffsetEdgeIndex, U(200), sOffsetEdgeName);	
			sDistributionOffset = PropString (nDistributionOffsetindex, "", sDistributionOffsetName);
	
			sChild = PropString (nChildIndex, sAllChilds, sChildName);
			sAssociation= PropString(nAssociationIndex, sAssociations, sAssociationName,0);
		}
		
		double dDiameter,dDiameterEdge, dDrillDepth,dDepthEdge, dZOffsetEdge, dValue,dDrillDepthThis;

	// a negative value means half panel thickness + value
		dValue = dDepthOverride==0?mapDevice.getDouble("Depth"):dDepthOverride;
		dDrillDepth = dValue<0?dH*.5-dValue:dValue;
		dDepthOverride.setDescription(sDepthOverrideDescription + " (" + dDrillDepth+")");
		
	// a negative value means half location measured from depth of main drill, positive measured from face	
		dValue= abs(dZOffsetEdgeProp)>0?dZOffsetEdgeProp:mapDevice.getDouble("ZOffsetEdge");
		dZOffsetEdge = dValue<0?dDrillDepth+dValue:dValue;
		dZOffsetEdgeProp.setDescription(sOffsetEdgeDescription + " (" + dZOffsetEdge+")");	
		
		dDiameter = dDiameterOverride>0?dDiameterOverride:mapDevice.getDouble("Diameter");
		dDiameterEdge = dDiameterEdgeProp>0?dDiameterEdgeProp:mapDevice.getDouble("DiameterEdge");
		
	// get rabbet edge offset value
		double dZOffsetRabbetEdge;
		{ 
			String k;
			Map m = mapFamily;
		// family level	
			k = "ZOffsetRabbetEdge"; if (m.hasDouble(k))dZOffsetRabbetEdge = m.getDouble(k);
		// ovrride family level if specified in child level
			m = mapDevice;
			k = "ZOffsetRabbetEdge"; if (m.hasDouble(k))dZOffsetRabbetEdge = m.getDouble(k);
		}
		
	// get bounding envelope contour
		PLine plEnvelope;
		Body bdEnv= sip.envelopeBody();
		
	// get a body representing all solid tools	
		// HSB-22470
		bdReal=bdXReal;//HSB-24092   sip.realBody();
		Body bdInt=bdEnv;
		bdInt.subPart(bdReal);//bdInt.vis(4);
		
		PlaneProfile ppEnv = bdEnv.shadowProfile(pnZ);
		// HSB-22470
		ppReal=bdReal.shadowProfile(pnZ);
		ppRealExtend=ppReal;ppRealExtend.shrink(-dEps);
	// get extents of profile
		LineSeg segEnv = ppEnv.extentInDir(vecX);
		double dXEnv = abs(vecX.dotProduct(segEnv.ptStart()-segEnv.ptEnd()));
		double dYEnv = abs(vecY.dotProduct(segEnv.ptStart()-segEnv.ptEnd()));
		plEnvelope.createRectangle(segEnv, vecX, vecY);
		
		PLine _plShadow=plShadow;
		_plShadow.projectPointsToPlane(pnZ, vecZ);
		//plEnvelope.vis(6);
	
	// loop locations
		for (int i=0;i<mapLocations.length();i++) 
		{ 
			Point3d ptsLocs[] = mapLocations[i].getPoint3dArray("ptsLocs");
			Map mapChild = mapLocations[i].getMap("child");
			Vector3d vecLift = vecLifts[i].isParallelTo(vecZ)?(nAssociation==2?vecY:vecX):vecLifts[i];
			Vector3d vecLiftPerp = vecLift.crossProduct(-vecFace);
			int bAlert=mapLocations[i].getInt("Alert");
			
		// get mapX entry of tool HSB-13393
			Map mapAdditional;
			mapAdditional.setString(T("|Type|"), mapChild.getString("Name") );
			String sToolDescription = _ThisInst.formatObject(sFormatTool,mapAdditional);
			
		// reposition locations if at corner
			if (bAtCorner && nQuantity>1)
			{ 
				ptsLocs.setLength(0);
				ptsLocs.append(segEnv.ptStart());
				ptsLocs.append(segEnv.ptEnd());
				Vector3d _vecX = vecLift.crossProduct(vecZ);
				Line(ptCen,_vecX).orderPoints(ptsLocs);
				if (ptsLocs.length()>0)ptsLocs[0].transformBy(_vecX*dOffsetEdgeOverride);
				if (ptsLocs.length()>1)ptsLocs[1].transformBy(-_vecX*dOffsetEdgeOverride);			
			}
			
			nQty+=ptsLocs.length();	
			
			for (int p=0;p<ptsLocs.length();p++) 
			{
				Point3d ptLoc = ptsLocs[p];ptLoc.vis(4);
				Vector3d vecDrill = vecFace;
				
			// get edge vector
				Vector3d vecEdge;
				Point3d ptNext=ptLoc;
				if (!bAtCorner)
				{ 
				// version value="4.3" date="21Sep2017" author="thorsten.huck@hsbcad.com"> bugfix small wall panels orientation steel anchor
					Point3d pts[]=Line(ptLoc,-vecLift).orderPoints(_plShadow.intersectPoints(Plane(ptLoc, vecLiftPerp)));

				// distiguish vecEdge by closest point	
					if (pts.length()>1 && abs(vecLift.dotProduct(ptLoc-pts[0])) > abs(vecLift.dotProduct(ptLoc-pts[1])))
					{ 
						vecLift *= -1;
						vecLiftPerp *= -1;
						pts.swap(0, 1);
					}	
					if (p==1)
					{ 
						vecLift.vis(pts[0],1);
						vecLiftPerp.vis(pts[0],3);
					}	
					else
					{
						vecLift.vis(ptLoc,1);
						vecLiftPerp.vis(ptLoc,3);					
					}

					
					if (pts.length()>0)
						ptNext = pts[0];
					//ptNext = _plShadow.closestPointTo(ptLoc); // version 4.2, version 2.8 plBox 	
					ptNext.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptNext)+.5*dH-dZOffsetEdge));	ptNext.vis(4);
					Point3d pt1 = ptLoc+vecZ*vecZ.dotProduct(ptNext-ptLoc);pt1.vis(6);
					vecEdge = ptNext-pt1;//vecDir;
					vecEdge.normalize();
					if (vecEdge.dotProduct(ptNext-ptLoc)<0)vecEdge*=-1;
					
					//ptLoc.transformBy(vecXEdge*vecXEdge.dotProduct(ptLoc-ptNext));
					ptLoc.transformBy(vecFace*(vecFace.dotProduct(ptOrg-ptLoc)+.5*dH)); 
				}			
			// special rule at corner
				else
				{ 
					Point3d pts[]=Line(ptLoc,-vecLift).orderPoints(plEnvelope.intersectPoints(Plane(ptLoc, vecLiftPerp)));
					if (pts.length()>0)
					{ 
						//pts[0].vis(4);
						vecDrill=vecLift;	
						ptLoc.transformBy(vecLift*vecLift.dotProduct(pts[0]-ptLoc));
						vecEdge = -vecLift.crossProduct(vecZ);
						
					// test location by a small intersection profile // version 4.1
						Point3d ptMidRef = segEnv.ptMid();
						if (bAtCorner && nQuantity==1)
						{ 
							PlaneProfile ppTest = ppShadow;
							PLine pl;
							pl.createRectangle(LineSeg(ptLoc - vecEdge * U(10e4) - vecLift * dZOffsetEdge, ptLoc + vecEdge * U(10e4) + vecLift * dZOffsetEdge), vecEdge, vecLift);
							pl.vis(3);
							ppTest.intersectWith(PlaneProfile(pl));
							if (ppTest.area()>pow(dEps,2))
								ptMidRef = ppTest.extentInDir(vecEdge).ptMid();
//							ppTest.transformBy(vecZ * U(200));
//							ppTest.vis(4);
						}
						
						
						if (vecEdge.dotProduct(ptLoc-ptMidRef)<0) // right corner
							vecEdge*=-1;
							
					// find extreme point in edge direction		
						Body bd(ptLoc, ptLoc + vecEdge * U(10e3), dDiameterEdge * .5);
						bd.transformBy(-vecLift*dZOffsetEdge);
						//bd.vis(6);
						bd.intersectWith(bdEnv);
						Point3d _pts[] = bd.extremeVertices(-vecEdge);
						double _dOffsetEdgeOverride=dOffsetEdgeOverride;
						if (_pts.length()>0)
						{ 
							_dOffsetEdgeOverride=vecEdge.dotProduct(_pts[0]-ptLoc);	
						}	
						ptNext = ptLoc+vecEdge*_dOffsetEdgeOverride-vecLift*dZOffsetEdge;
						//ptNext.transformBy(vecLift*(vecLift.dotProduct(ptLoc-ptNext)-dZOffsetEdge)+vecZ*vecZ.dotProduct(ptLoc-ptNext));
					}
					
				}
				
			// get the perpendicular vecEdge
				double d1 = _plShadow.getDistAtPoint(ptNext);
				Point3d ptNext2 = _plShadow.getPointAtDist((abs(_plShadow.length() - d1) < U(10) ?d1-U(10) : d1+U(10)));
				ptNext2.vis(3);
				Vector3d vecXEdge = ptNext2 - ptNext; vecXEdge.normalize();
				if (!vecXEdge.isPerpendicularTo(vecEdge))
				{
					ptNext.transformBy(vecXEdge * vecXEdge.dotProduct(ptLoc - ptNext));
					vecEdge = vecEdge.crossProduct(-vecXEdge).crossProduct(vecXEdge);
				}
				
				vecEdges.append(vecEdge);
				vecEdge.vis(ptNext,2);ptLoc.vis(i);
				
			// a negative value means extend drill through other drill
				dValue = abs(dDepthEdgeProp)>0?dDepthEdgeProp:mapDevice.getDouble("DepthEdge");
				
			// a negative value means extend drill through other drill
				dDepthEdge = dValue<0?vecEdge.length()-dValue+.5*dDiameter:dValue;
				
			// create individuals
				if(bCreateSingles)
				{
					ptsTsl[0] = ptLoc;
					nProps[0]=1;
					
				// set lifting direction
					Map mapDirections;
					if (bAtCorner && nAssociation == 1)//version 4.7; && nAssociation==1) added
						mapDirections.appendVector3d("LiftDirection", vecLift);
					else
						mapDirections.appendVector3d("LiftDirection", vecEdge);
					mapTsl.setMap("LiftDirection[]", mapDirections);
					
				// create device
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
					if (tslNew.bIsValid())
					{
						tslNew.setPropValuesFromCatalog(sLastInserted);
						tslNew.setPropInt(0,1); // qty
						tslNew.setPropString(nChildIndex,sArticle);// child
						if(bDebug)reportMessage("\n succesfully created with child " + tslNew.propString(nChildIndex));
					}
					continue;
				}				

			// extended edge tool test variables
				Point3d ptEdge = ptNext;
				double dToolEdgeDepth;
				Plane pnEdge(ptNext,vecEdge);

				int bAutoZOffsetEdge = dZOffsetEdgeProp==0;

			// find potential edge tool
				if (bAutoZOffsetEdge)
				{
					for (int j=0;j<tslsConnected.length();j++) 
					{ 
						String sScriptNameJ=tslsConnected[j].scriptName();
						Map m = tslsConnected[j].map();
						double dToolDepth = tslsConnected[j].propDouble(7);
						//if(bDebug)
						
						Vector3d vecDir = m.getVector3d("vecDir"); 
						Point3d ptsMaleLocations[]=m.getPoint3dArray("maleLocations");
						Point3d ptsFemaleLocations[]=m.getPoint3dArray("femaleLocations");
						if (ptsMaleLocations.length()<1 || ptsFemaleLocations.length()<1)continue;
						
						Point3d pt;
						if (vecDir.isCodirectionalTo(vecEdge) && abs(vecEdge.dotProduct(ptEdge-ptsMaleLocations[0])<10*dEps))
						{
							pt.setToAverage(ptsMaleLocations);
							Point3d ptNew = ptEdge;
							ptNew.transformBy(vecFace*vecFace.dotProduct(pt-ptEdge)+vecEdge*vecEdge.dotProduct(pt-ptEdge));
							// HSB-22470: check that pt from the edge tsl
							// falls inside the real body
							if(ppRealExtend.pointInProfile(ptNew)!=_kPointOutsideProfile)
							{	
								ptEdge=ptNew;
								vecDir.vis(pt,96);	
								bAutoZOffsetEdge=false;
								dToolEdgeDepth=dToolDepth;
							}
							break;
						}
						
						
						pt = ptsFemaleLocations[0];
						vecDir.vis(pt,3);
						if (vecDir.isParallelTo(vecEdge)&& abs(vecEdge.dotProduct(ptEdge-ptsFemaleLocations[0])<dToolDepth+dEps))
						{
							if (bDebug)reportMessage("\nfemale relocation dToolDepth " + dToolDepth);
							Point3d ptNew = ptEdge;
							ptNew.transformBy(vecFace*vecFace.dotProduct(pt-ptEdge)+vecEdge*vecEdge.dotProduct(pt-ptEdge));
							// HSB-22470: check that pt from the edge tsl
							// falls inside the real body
							if(ppRealExtend.pointInProfile(ptNew)!=_kPointOutsideProfile)
							{
								ptEdge=ptNew;
								vecDir.vis(ptEdge,3);
								bAutoZOffsetEdge=false;
								dToolEdgeDepth=dToolDepth;
							}
							break;
						}
					}
				}

			// run geometry test for lap joints etc
				if(bAutoZOffsetEdge && !bAtCorner)
				{
					PLine plCirc;
					plCirc.createCircle(ptNext, vecEdge, dDiameterEdge*.5);
					PlaneProfile ppCirc(plCirc);ppCirc.vis(6);
					PlaneProfile ppEdge = bdReal.extractContactFaceInPlane(pnEdge, dEps);
					ppEdge.intersectWith(ppCirc);//ppEdge.vis(222);		
					if (bDebug)reportMessage("\nrunning geometry relocation");
				// run test if contact of circle is not 100%
					if (abs(ppEdge.area()-plCirc.area())>pow(U(1),2))
					{
						//Vector3d vecXEdge = vecEdge.crossProduct(vecZ);
						vecXEdge.vis(ptNext, 1);
						// get a body without the drill hole itself 
						Body bdBox(ptNext, vecEdge, vecXEdge, vecZ, dDepthEdge, dDiameterEdge+dEps,dH,-1,0,0 );
						bdBox.intersectWith(bdReal);
						bdBox.vis(6);
						PlaneProfile ppBox=bdBox.shadowProfile(Plane(ptNext, vecXEdge));ppBox.vis(p);
						PLine plRings[] = ppBox.allRings();
						int bIsOp[] = ppBox.ringIsOpening();
						bdBox = Body();
						for (int r=0;r<plRings.length();r++)
							if (!bIsOp[r])
								bdBox.addPart(Body(plRings[r],vecXEdge*dDiameterEdge,0));bdBox.vis(6);
							
							// get contact at edge
							double dTol = dEps;
							{
								LineSeg seg = ppBox.extentInDir(vecEdge);
								Point3d pt = seg.ptMid()+vecEdge*.5*abs(vecEdge.dotProduct(seg.ptEnd()-seg.ptStart()));
								double d = vecEdge.dotProduct(ptNext-pt);
								if(d>dTol)dTol+=d;
							}
						ppEdge = bdBox.extractContactFaceInPlane(pnEdge,dTol);ppEdge.vis(2);
						
						ppEdge.createRectangle(LineSeg(ppEdge.extentInDir(vecXEdge)), vecXEdge, vecEdge.crossProduct(vecXEdge));
//						plRings = ppEdge.allRings(true, false);
//						ppEdge.removeAllRings();
//						for (int r=plRings.length()-1;r>=0;r--)
//							if (!bIsOp[r])
//								ppEdge.joinRing(plRings[r],_kAdd);

					// get intersecting contact at edge
						PlaneProfile ppX = ppEdge;
						ppX.intersectWith(PlaneProfile(plCirc));ppX.vis(p);
						
					// get extents of profile
					
						LineSeg seg = ppX.extentInDir(vecXEdge);
						double dY = abs(vecFace.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dMove = dDiameterEdge - dY + dEps;
						int bBoltMoved;
						// HSB-24692 V8.6
						if (dY>0 && abs(dMove)>dEps)
						{
							dMove += dZOffsetRabbetEdge;
							ptEdge.transformBy(vecFace*dMove);	
							bBoltMoved=true;
						}
						else
						{
							// HSB-24692: consider the case when skewed cut at beveled edges
							Body bdDrill(plCirc,-vecEdge*U(50));
							Body bdIntersect=bdDrill;
							bdIntersect.intersectWith(bdBox);
//							bdIntersect.vis(3);
//							bdDrill.vis(5);
//							ptEdge.vis(3);
							ppX=bdIntersect.shadowProfile(pnEdge);
							seg = ppX.extentInDir(vecXEdge);
							dY = abs(vecFace.dotProduct(seg.ptStart()-seg.ptEnd()));
							dMove = dDiameterEdge - dY + dEps;
							if (dY>0 && abs(dMove)>dEps)
							{
								dMove += dZOffsetRabbetEdge;
								ptEdge.transformBy(vecFace*dMove);	
								ptEdge.vis(1);
								bBoltMoved=true;
							}
						}
						if(bBoltMoved)
						{ 
							// check the ptLoc from ptEdge
							// must be dOffsetEdgeOverride from ptEdge in vecEdge
							if(dOffsetEdgeOverride>dEps)
							{ 
								if(abs(vecEdge.dotProduct(ptEdge-ptLoc)-dOffsetEdgeOverride)>dEps)
								{ 
									Point3d ptLocNew=ptEdge-vecEdge*dOffsetEdgeOverride;
									ptLoc+=vecEdge*vecEdge.dotProduct(ptLocNew-ptLoc);
								}
							}
						}
					// get (potential) rabbet depth	
						
						LineSeg segs[] = ppBox.splitSegments(LineSeg(ptEdge+vecEdge*dEps,ptEdge-vecEdge*2*dDepthEdge), true);
						Point3d pts[0];
						for (int s=0;s<segs.length();s++) 
						{ 
							pts.append(segs[s].ptStart());
							pts.append(segs[s].ptEnd());
						}
						pts = Line(ptEdge,-vecEdge).orderPoints(pts);
						if (pts.length()>1)
						{
							dToolEdgeDepth = vecEdge.dotProduct(ptEdge-pts[0]);
//							ptLoc.transformBy(-vecEdge*dToolEdgeDepth);// HSB-24692
						}
					}
				}
				
			// add the tool	
				dDrillDepthThis=dDrillDepth;// HSB-24692 V8.6
				if(mapDevice.getDouble("Depth")<0)
				{ 
					// HSB-24692 V8.6 depth must be with a certain distance from the anchor bolt
					double dDepthThis=abs(vecDrill.dotProduct(ptEdge-ptLoc))-mapDevice.getDouble("Depth");
					if(abs(dDepthThis-dDrillDepth)>dEps)
					{ 
						dDrillDepthThis=dDepthThis;
					}
				}
				if (!bToolOff)//HSB-15401
				{ 
//					Drill drill(ptLoc,ptLoc-vecDrill*dDrillDepth, dDiameter*.5);//drill.cuttingBody().vis(5);
					Drill drill(ptLoc,ptLoc-vecDrill*dDrillDepthThis, dDiameter*.5);//drill.cuttingBody().vis(5);
					// HSB-13393 write tool description format
					if (sMapXName.length() > 0 && sKeyName.length() > 0 && sToolDescription.length() > 0)
					{
						Map mapX;
						mapX.setString(sKeyName, sToolDescription);
						drill.setSubMapX(sMapXName, mapX);
					}
					
					sip.addTool(drill);
					
					Drill drill2(ptEdge+vecEdge*dEps,ptEdge-vecEdge*(dDepthEdge+dToolEdgeDepth), dDiameterEdge*.5);drill2.cuttingBody().vis(5);
					// add the edge drill tool	
					// HSB-13393 write tool description format	
					if (sMapXName.length()>0 && sKeyName.length()>0 && sToolDescription.length()>0)
					{ 
						Map mapX;
						mapX.setString(sKeyName, sToolDescription);
						drill2.setSubMapX(sMapXName,mapX);				
					}				
					sip.addTool(drill2);					
				}

			// string builder for dimRequests			
//				sTxt = bAutoMode?sArticle:sArticle + " ø" + dDiameter + "x" + dDrillDepth;
				sTxt = bAutoMode?sArticle:sArticle + " ø" + dDiameter + "x" + dDrillDepthThis;// HSB-24692 V8.6
				
			// append non standard edge drill
				if (dDepthEdgeProp>0 || dDiameterEdgeProp>0)
				{
					sTxt += " ø" + dDiameterEdge + "x" + dDepthEdge;
				}	
				
			// store global locations
				ptsDimLocs.append(ptLoc);	

			// set local coordSys //3.4
				if (bAtCorner)
				{
					Vector3d vecXTool = vecZ.crossProduct(-vecLift);vecXTool.normalize();
					Vector3d vecYTool = vecXTool.crossProduct(vecLift);vecYTool.normalize();
					csDimLocs.append(CoordSys(ptLoc, vecXTool, vecYTool, vecLift));
				}
			}
		}// next i
		
	// store overrides	
		mapDevice.setDouble("DiameterEdge",dDiameterEdge);
		mapDevice.setDouble("Diameter",dDiameter);
//		mapDevice.setDouble("Depth",dDrillDepth);
		mapDevice.setDouble("Depth",dDrillDepthThis);// HSB-24692 V8.6
		mapDevice.setDouble("DepthEdge",dDepthEdge);
		dTxtOffset=dDiameter;

	}// END IF _____ STEEL ANCHOR	_____ STEEL ANCHOR	_____ STEEL ANCHOR	_____ STEEL ANCHOR	

//End PART 3 Rules//endregion 

//region PART 4 
// erase instance after generating individual devices
	if (bCreateSingles)
	{
		eraseInstance();
		return;
	}


// get real shadow including openings
	ppShadow.shrink(-dEps);
	for (int i=0;i<plOpenings.length();i++) 
	{ 
		ppShadow.joinRing(plOpenings[i],_kSubtract); 
		 
	}
	
// draw symbols, texts and add dimRequests all dim locations
	for (int i=0;i<ptsDimLocs.length();i++) 
	{ 
		Point3d ptLoc = ptsDimLocs[i]; 
		
	// symbol for quader tool shapes LifterTestCases.dwg Case5
		if (csDimLocs.length()>i)
		{
			CoordSys cs=plCross.coordSys();
			cs.setToAlignCoordSys(cs.ptOrg(),cs.vecX(),cs.vecY(),cs.vecZ(),csDimLocs[i].ptOrg(),csDimLocs[i].vecX(),csDimLocs[i].vecY(),csDimLocs[i].vecZ());
			plCross.transformBy(cs);
		}
	// standard symbol
		else
			plCross.transformBy(ptLoc-plCross.ptStart());
		dp.draw(plCross);
		if (!bHideDescriptionShopdraw) // HSBCAD-5570
		{ 
			mapRequest.setInt("Color", nColor);
			mapRequest.setPLine("pline", plCross);
			mapRequests.appendMap("DimRequest",mapRequest);				
		}

	
	// test if in range, rule 0 is tested in rule itself
		if (ppShadow.pointInProfile(ptLoc)!=_kPointInProfile && nRule != 0)
		{
			PLine pl;
			pl.createConvexHull(pnZ,plCross.vertexPoints(true));
			PlaneProfile pp(pl);
			pp.shrink(-dTxtHeight);
			pp.joinRing(pl,_kSubtract);
			dpErr.draw(pp,_kDrawFilled);
		}
	
	
	// draw potential alert
		if (bAlert)
		{
			ppAlert.transformBy(ptLoc-ppAlert.coordSys().ptOrg());	
			dpErr.draw(ppAlert,_kDrawFilled);
		}

	// text
		Point3d ptTxt = ptLoc;
		if (dRotationText==0)
		{
			ptTxt+= vecX * (dTxtOffset + U(5));
			if(nRule==0 && nAssociation==2)
				ptTxt.transformBy(vecY*(dTxtOffset+U(5)));						
		}

		
		Vector3d vecXTxt = vecX;
		Vector3d vecYTxt = vecY;
		{ 
			CoordSys rot;
			rot.setToRotation(dRotationText, vecZ, ptTxt);
			vecXTxt.transformBy(rot);
			vecYTxt.transformBy(rot);			
		}
		
		vecY.vis(ptTxt, 40);
		
		
		dp.draw(sArticle, ptTxt, vecXTxt, vecYTxt,dXTextFlag,dYTextFlag,_kDevice);
		if (!bHideDescriptionShopdraw) // HSBCAD-5570
		{ 
			Map mapRequestTxt;
			//mapRequestTxt.setPoint3d("ptScale", ptLoc+vecX*);		
			mapRequestTxt.setInt("deviceMode", _kDevice);		
			mapRequestTxt.setInt("Color", nColor);
			mapRequestTxt.setVector3d("AllowedView", vecZ);				
			mapRequestTxt.setPoint3d("ptLocation",ptTxt);	
			mapRequestTxt.setVector3d("vecX", vecXTxt);
			mapRequestTxt.setVector3d("vecY", vecYTxt);
			mapRequestTxt.setDouble("dXFlag", dXTextFlag);
			mapRequestTxt.setDouble("dYFlag", dYTextFlag);	
			mapRequestTxt.setString("text", sTxt);
			mapRequests.appendMap("DimRequest",mapRequestTxt);			
		}
	}
	
// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	int bRTTypeFound;
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
		{
			bRTTypeFound = true;
			hwcs.removeAt(i); 
		}
// since 6.4 the hardware is defined as RTTsl, make sure any hardware attached as RTUser from previous versiopns is removed		
	if (!bRTTypeFound)
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTUser)
				hwcs.removeAt(i); 		

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =sip.element(); 
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}




// hardware
	int bIsLoose = sArticle.left(1) == "L";
	if (mapDevice.hasMap("Hardware[]"))
	{
		String k;
		Map mapHW=mapDevice.getMap("Hardware[]");
		for (int m=0;m<mapHW.length();m++) 
		{ 
			Map map = mapHW.getMap(m);
			
			String articleNumber, category, material, description, manufacturer, model, notes, name;
			
			k = "articleNumber"; 	if (map.hasString(k))	articleNumber = map.getString(k); else articleNumber = sArticle;
			k = "category"; 		if (map.hasString(k))	category = map.getString(k); else category = "LiftingDevice";
			k = "material"; 		if (map.hasString(k))	material = map.getString(k);
			k = "description"; 		if (map.hasString(k))	description = map.getString(k);	else description = (bIsLoose?T("|Loose| "):"")+sFamily;
			k = "manufacturer"; 	if (map.hasString(k))	manufacturer = map.getString(k);
			k = "model"; 			if (map.hasString(k))	model = map.getString(k);
			k = "notes"; 			if (map.hasString(k))	notes = map.getString(k);
			k = "name"; 			if (map.hasString(k))	name = map.getString(k);

			if (bToolOff)notes = notes+ (notes.length()>0?";":"")+("No CNC");

			double dScaleX = map.getDouble("scaleX");
			double dScaleY = map.getDouble("scaleY");
			double dScaleZ = map.getDouble("scaleZ");
			
			int quantity = nQty;
			k = "quantity";			if (map.hasInt(k))	quantity = map.getInt(k);

			HardWrComp hwc(articleNumber, quantity>0?quantity:1); // the articleNumber and the quantity is mandatory	
			
			hwc.setCategory(category);
			hwc.setMaterial(material);
			hwc.setDescription(description);
			hwc.setManufacturer(manufacturer);
			hwc.setModel(model);
			hwc.setNotes(notes);
			hwc.setNotes(name);

			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(sip);	
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
//			double dScaleX;
//			if (map.hasString("ScaleX"))
//			{
//				String s = map.getString("ScaleX");
//				if (mapDevice.hasDouble(s))dScaleX=mapDevice.getDouble(s);	
//				else dScaleX=s.atof();
//			}
//			hwc.setDScaleX(dScaleX);
//			double dScaleY;
//			if (map.hasString("ScaleY"))
//			{
//				String s = map.getString("ScaleY");
//				if (mapDevice.hasDouble(s)) dScaleY=mapDevice.getDouble(s);	
//				else dScaleY=s.atof();	
//			}
//			hwc.setDScaleY(dScaleY);
//			double dScaleZ;
//			if (map.hasString("ScaleZ"))
//			{
//				String s = map.getString("ScaleZ");
//				if (mapDevice.hasDouble(s)) dScaleZ=mapDevice.getDouble(s);	
//				else dScaleZ=s.atof();	
//			}
			
			hwc.setDScaleX(dScaleX);
			hwc.setDScaleY(dScaleY);
			hwc.setDScaleZ(dScaleZ);
			hwcs.append(hwc);// apppend component to the list of components
		}	
	}
	else
	{
		HardWrComp hwc(sArticle , nQty);	
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(sip);	
		hwc.setCategory("LiftingDevice");
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		if (bIsLoose)	hwc.setDescription(T("|Loose| ")+sFamily);			
		else			hwc.setDescription(sFamily);
		hwc.setDScaleX(0);
		hwc.setDScaleY(0);
		hwc.setDScaleZ(0);	
		hwcs.append(hwc);// apppend component to the list of components		
	}

	



// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	setCompareKey(sFamilies[nFamily] + "_" + sChild + "_" + dDiameterOverride + "_" + dDepthOverride);
	//endregion

// shopdraw flag
	if (mapRequests.length()>0)
		_Map.setMap("DimRequest[]", mapRequests);
	else
		_Map.removeAt("DimRequest[]", true);
	_Map.setInt("Family", nFamily);
	
// hinder supported shopdraw tsls to create other dimrequests then specified by the perp vectors
	if (bShowDimRequest)
	{
		Map mapPerps;
		for (int i=0;i<vecEdges.length();i++) 
			mapPerps.appendVector3d("vecDimPerp", vecEdges[i]); 
		_Map.setMap("DimPerp[]", mapPerps);
		_Map.removeAt("AddToMultipage", true);
	}
	else
	{
		_Map.removeAt("DimPerp[]", true);
		_Map.setInt("AddToMultipage", false);
	}
	
	//_Map.setInt("AddToMultipage", bShowDimRequest); // this attempt turns dimensioning on or off
	
	_Map.setInt("SuppressDescription", true);  // sd_drillPattern will suppress any text on single drills

//endregion


//region DataLink
	// only the first of any siblig is used as reference
	TslInst siblings[] = GetSiblings(sip,  bDebug?sFileName:scriptName());
	if (siblings.length()>0 && siblings.first()==_ThisInst)
	{ 
		Map m = sip.subMapX(kDataLink);
		m.setEntity(sFileName, _ThisInst);
		sip.setSubMapX(kDataLink, m);		
	}	
//endregion 


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerSetting = T("|Tool Description Settings|");
	addRecalcTrigger(_kContext, sTriggerSetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		mapTsl.setString("opmKey","Settings");

		sProps.append(sFormatTool);		
		sProps.append(sMapXName);
		sProps.append(sKeyName);
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				sFormatTool = tslDialog.propString(0);
				sMapXName = tslDialog.propString(1);
				sKeyName = tslDialog.propString(2);				
			
			// append this entry
				Map m;
				m.setString("Format",sFormatTool);
				m.setString("MapName",sMapXName);
				m.setString("KeyName",sKeyName);

			// write to settings and store in mo
				mapSetting.setMap("ToolDescriptionFormat", m);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	





//region Trigger ConfigureSecondaryDevice
	String sTriggerConfigureSecondaryDevice = T("|Configure Secondary Lifting Device|");
	addRecalcTrigger(_kContext, sTriggerConfigureSecondaryDevice);
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigureSecondaryDevice)
	{
		
	//region Set options
		Map mapItems;

		String tNone = T("<|None|>");
		Map mapSecondaries = FilterFamiliesWithAssociation(mapSetting, -1); //negative = exclude given assoc
		String sSecondaryFamilies[] = GetFamilyNames(mapSecondaries).sorted();
		sSecondaryFamilies.insertAt(0, tNone);

		if (sSecondaryFamilies.findNoCase(sSecondaryFamily,-1)<0)
			sSecondaryFamily = tNone;

		for (int i=0;i<sSecondaryFamilies.length();i++) 
		{ 
			Map mapItem;
			mapItem.setString("Text", sSecondaryFamilies[i]);
			//mapItem.setString("ToolTip", fullPath);//__only Map entries can declare ToolTips
			mapItem.setInt("IsSelected", Equals(sSecondaryFamilies[i], sSecondaryFamily));
//			if (Equals(sFType,sTypes[i]))
//				
//			else if (nMode>0 && Equals(sCType,sTypes[i]))
//				mapItem.setInt("IsSelected", i);				
			mapItems.appendMap("mp", mapItem);
		}//next i			
	//endregion		
		
	//region Show Options
		Map mapIn; 
		mapIn.setMap("Items[]", mapItems);
		mapIn.setString("Title", T("|Secondary Lifting Device|"));
		mapIn.setString("Prompt", T("|Choose a lifting device that will be added to the current lifting system.|") + 
			TN("|It will be created each time the in-use lifting device is attached to a panel.|") + 
			TN("|The devices listed below are sorted if their type supports the opposite association strategy.|"));

		mapIn.setInt("EnableMultipleSelection", false);
//		mapIn.setInt("ShowSelectAll", false);
		
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapIn);	
		
		int selected = mapOut.getInt("SelectedIndex");
		if (selected>0)
		{ 
			for (int i=0;i<mapFamilies.length();i++) 
			{ 
				Map mapFamily= mapFamilies.getMap(i); 
				String name = T(mapFamily.getString("Name"));
				if (Equals(name, sFamily))
				{ 
					Map mapNew = mapFamily;
					mapFamilies.removeAt(i, true);
					if (selected == 0)
					{ 
						mapNew.removeAt("secondaryFamily", true);					
					}
					else
					{ 
						mapNew.setString("secondaryFamily", sSecondaryFamilies[selected]);					
					}	
					mapFamilies.appendMap("Family", mapNew);
					mapFamilies.moveLastTo(i);
					break;
				}
	
			}//next i
			
		// write to settings and store in mo
			mapSetting.setMap("Family[]", mapFamilies);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}
		
	
	//endregion 		
		
			
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
}
//End Dialog Trigger//endregion 








#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$``("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("
M`@("`@,#`@(#`@("`P0#`P,#!`0$`@,$!`0$!`,$!`,!`@("`@("`@("`@,"
M`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`__$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`2P!D`,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`/W\H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
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
I!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!_]D`


































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
        <int nm="BreakPoint" vl="3912" />
        <int nm="BreakPoint" vl="2790" />
        <int nm="BreakPoint" vl="4340" />
        <int nm="BreakPoint" vl="3624" />
        <int nm="BreakPoint" vl="1688" />
        <int nm="BreakPoint" vl="1699" />
        <int nm="BreakPoint" vl="3998" />
        <int nm="BreakPoint" vl="2929" />
        <int nm="BreakPoint" vl="3359" />
        <int nm="BreakPoint" vl="2464" />
        <int nm="BreakPoint" vl="264" />
        <int nm="BreakPoint" vl="528" />
        <int nm="BreakPoint" vl="2786" />
        <int nm="BreakPoint" vl="2237" />
        <int nm="BreakPoint" vl="2220" />
        <int nm="BreakPoint" vl="3472" />
        <int nm="BreakPoint" vl="3715" />
        <int nm="BreakPoint" vl="3784" />
        <int nm="BreakPoint" vl="3813" />
        <int nm="BreakPoint" vl="3706" />
        <int nm="BreakPoint" vl="3705" />
        <int nm="BreakPoint" vl="3536" />
        <int nm="BreakPoint" vl="2905" />
        <int nm="BreakPoint" vl="3860" />
        <int nm="BreakPoint" vl="3850" />
        <int nm="BreakPoint" vl="2822" />
        <int nm="BreakPoint" vl="3841" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24692: Anchor bolt: Fix depth in terms of bolt offset; fix drill position from edge in terms of OffsetEdgeOverride" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/8/2025 9:46:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24692: Fix when applying ZOffsetRabbetEdge at beveled edges" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/7/2025 9:03:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24493: Add criteria for thickness in xml &quot;MinThickness&quot;, &quot;MaxThickness&quot;" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/10/2025 2:14:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24434: Improve function for getting realBody of panel" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="8/20/2025 2:52:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24434: Add warning fro lifting strap at walls when different lengths" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/20/2025 1:49:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24434: For walls make sure to get the highest point" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/20/2025 11:24:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24092 The tool now takes into account the contact surfaces of the reference and opposite sides to determine the edge clearances." />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/26/2025 11:02:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23963 new command to specify a secondary association, Text can be rotated and realigned with new parameters 'Rotation, XFlag, YFlag' supported on family level in subnode 'Text'." />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="4/28/2025 4:12:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22470: Fix when finding edge point for &quot;Steel anchor&quot; (lifting bolt)" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="1/8/2025 9:45:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23000: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="12/5/2024 9:29:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21860 The current panel export functionality now includes support for the 'DataLink' reference, allowing the accessibility of properties pertaining to the appearance of the initial lifting device." />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/10/2024 4:06:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21123 hardware exposure enhanced, properties may be specified per child" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/15/2024 11:09:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20473 Schmidd Schrauben Rapid T-Lift 12&amp;16 added" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/26/2023 3:00:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18919 property 'MinThickness' excludes item selection if not matching panel thickness" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/8/2023 12:19:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15401 a new RMC toggle has been added to suppress/add tooling" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/3/2022 5:17:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="11.01.2022" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/11/2022 6:26:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13393 supports tool description format export, new context commands to set, import and export settings" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/26/2021 3:29:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12569: replace old Sihga Pick with Pitzl powerclamp" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="7/22/2021 10:51:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12647 supporting custom families on lisp based insert" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/20/2021 2:24:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12630 bugfix empty selection set" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="7/20/2021 11:18:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12630 single panel selection allowws multiple insert with different lifting direction" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="7/19/2021 4:43:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10390: use the translated family name when finding family from execute key " />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/7/2021 1:31:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End