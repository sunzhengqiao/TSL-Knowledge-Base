#Version 8
#BeginDescription
 #Versions
Version 2.0 18.06.2025 HSB-24185 blockspace detection improved
Version 1.9 17.06.2025 HSB-24187 tool naming improved, dialogs in blockspace improved, translation issues fixed
Version 1.8 30.04.2025 HSB-23979 bugfix collecting mortises and freeprofiles
Version 1.7 26.02.2025 HSB-23582 filtering improved, new dispaly 'shapeOnly', new filter mode 'byLocation'

This tsl tags tools on shopdrawings



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 2.0 18.06.2025 HSB-24185 blockspace detection improved , Author Thorsten Huck
// 1.9 17.06.2025 HSB-24187 tool naming improved, dialogs in blockspace improved, translation issues fixed , Author Thorsten Huck
// 1.8 30.04.2025 HSB-23979 bugfix collecting mortises and freeprofiles , Author Thorsten Huck
// 1.7 26.02.2025 HSB-23582 filtering improved, new dispaly 'shapeOnly', new filter mode 'byLocation' , Author Thorsten Huck
// 1.6 05.02.2025 HSB-23466 option to use any subtype prepared , Author Thorsten Huck
// 1.5 31.01.2025 HSB-23393 Beamcut: WidthInView and LengthInView added , Author Thorsten Huck
// 1.4 31.01.2025 HSB-23393 face index detection fixed for free profile and boxed shaped tools , Author Thorsten Huck
// 1.3 28.01.2025 HSB-23412 blockspace creation supported , Author Thorsten Huck
// 1.2 28.01.2025 HSB-23393 new painter driven tool filtering supported , Author Thorsten Huck
// 1.1 27.11.2024 HSB-23066 supports tools of type Drill, Beamcut, Mortise, House, Slot or FreeProfile, filtering, grouping and leader styles added , Author Thorsten Huck
// 1.0 29.10.2024 HSB-22885 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select genbeams or multipages, when in block space of a multipage select orthogonal shopdraw viewports
/// </insert>

// <summary Lang=en>
// This tsl draws tags based on genbeam tools. In addition to the default properties a virtual property 'DepthInView' will be added if applicable
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ToolTag")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Tool Settings|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	



//region Tool Types
	String kAny = "*", kAnyDrill= "_kAD"+kAny, kAnySlot= "_kASl"+kAny, kAnyHousing= "_kAH"+kAny, kAnyBeamcut= "_kABC"+kAny,kAnyMortise= "_kAM"+kAny,kAnyFreeprofile= "_kAFP"+kAny;
	String sPrefixTranslations[] = { T("|Drill|"), T("|Beamcut|"), T("|Housing Tool|"), T("|Mortise|"), T("|Slot|"),T("|Free Profile|")};
	String kAnalysedDrill = "AnalysedDrill",kAnalysedBeamCut = "AnalysedBeamCut",kAnalysedHouse = "AnalysedHouse",kAnalysedMortise = "AnalysedMortise",
		 kAnalysedSlot="AnalysedSlot",  kAnalysedFreeProfile = "AnalysedFreeProfile";
	String sPrefixes[] = { "_kAD", "_kABC", "_kAH","_kAM","_kASl","_kAFP"};
	String sToolTypeNames[] ={ kAnalysedDrill,kAnalysedBeamCut,kAnalysedHouse,kAnalysedMortise,kAnalysedSlot,kAnalysedFreeProfile};

	String sDrillSubtypes[]= { _kADPerpendicular, _kADRotated, _kADTilted, _kADHead, _kAD5Axis};
	String sDrillSubtypesT[]= { T("|Drill, Perpendicular|"), T("|Drill, Rotated|"), T("|Drill, Tilted|"), T("|Drill, Head|"), T("|Drill, 5-Axis|")};
	
	String sBeamcutSubtypes[]= {_kABCSeatCut, _kABCRisingSeatCut, _kABCOpenSeatCut, _kABCLapJoint, _kABCBirdsmouth, _kABCReversedBirdsmouth, _kABCClosedBirdsmouth, _kABCDiagonalSeatCut, _kABCOpenDiagonalSeatCut,_kABCBlindBirdsmouth, _kABCHousing, _kABCHousingThroughout, _kABCHouseRotated, _kABCHouseTilted,_kABCJapaneseHipCut, _kABCHipBirdsmouth, _kABCValleyBirdsmouth, _kABCRisingBirdsmouth,_kABCHoused5Axis, _kABCSimpleHousing, _kABCRabbet, _kABCDado, _kABC5Axis, _kABC5AxisBirdsmouth,	_kABC5AxisBlindBirdsmouth};	
	String sBeamcutSubtypesT[]= {T("|Beamcut, Seat Cut|"), T("|Beamcut, Rising Seat Cut|"), T("|Beamcut, Open Seat Cut|"), T("|Beamcut, Lap Joint|"), T("|Beamcut, Birdsmouth|"),T("|Beamcut, Reversed Birdsmouth|"), T("|Beamcut, Closed Birdsmouth|"), T("|Beamcut, Diagonal Seat Cut|"), T("|Beamcut, Open Diagonal Seat Cut|"), T("|Beamcut, Blind Birdsmouth|"),T("|Beamcut, Housing|"), T("|Beamcut, Housing Throughout|"), T("|Beamcut, House Rotated|"), T("|Beamcut, House Tilted|"), T("|Beamcut, Japanese Hip Cut|"),	T("|Beamcut, Hip Birdsmouth|"), T("|Beamcut, Valley Birdsmouth|"), T("|Beamcut, Rising Birdsmouth|"), T("|Beamcut, Housed 5-Axis|"), T("|Beamcut, Simple Housing|"),T("|Beamcut, Rabbet|"),T("|Beamcut, Dado|"), T("|Beamcut, 5-Axis|"), T("|Beamcut, 5-Axis Birdsmouth|"),	T("|Beamcut, 5-Axis Blind Birdsmouth|")};	

	String sHouseSubtypes[]= {_kAHSimple, _kAHPerpendicular, _kAHRotated, _kAHTilted, _kAH5Axis,_kAHHeadPerpendicular, _kAHHeadSimpleAngled, _kAHHeadSimpleAngledTwisted, _kAHHeadSimpleBeveled, _kAHHeadCompound,_kAHTenonPerpendicular, _kAHTenonSimpleAngled, _kAHTenonSimpleAngledTwisted, _kAHTenonSimpleBeveled, _kAHTenonCompound};
	String sHouseSubtypesT[]= {T("|Housing Tool, Simple|"), T("|Housing Tool, Perpendicular|"), T("|Housing Tool, Rotated|"), T("|Housing Tool, Tilted|"), T("|Housing Tool, 5-Axis|"), T("|Housing Tool, Head Perpendicular|"), T("|Housing Tool, Head Simple Angled|"), T("|Housing Tool, Head Simple Angled Twisted|"), T("|Housing Tool, Head Simple Beveled|"), T("|Housing Tool, Head Compound|"), T("|Housing Tool, Tenon Perpendicular|"), T("|Housing Tool, Tenon Simple Angled|"), T("|Housing Tool, Tenon Simple Angled Twisted|"), T("|Housing Tool, Tenon Simple Beveled|"), T("|Housing Tool, Tenon Compound|")};

	String sMortiseTypesSubtypes[]= {_kAMPerpendicular, _kAMRotated, _kAMTilted, _kAM5Axis, _kAMHeadPerpendicular,	_kAMHeadSimpleAngled, _kAMHeadSimpleAngledTwisted, _kAMHeadSimpleBeveled, _kAMHeadCompound};
	String sMortiseTypesSubtypesT[]= {T("|Mortise, Simple|"), T("|Mortise, Perpendicular|"), T("|Mortise, Rotated|"), T("|Mortise, Tilted|"), T("|Mortise, 5-Axis|"), T("|Mortise, Head Perpendicular|"), T("|Mortise, Head Simple Angled|"), T("|Mortise, Head Simple Angled Twisted|"), T("|Mortise, Head Simple Beveled|"), T("|Mortise, Head Compound|"), T("|Mortise, Tenon Perpendicular|"), T("|Mortise, Tenon Simple Angled|"), T("|Mortise, Tenon Simple Angled Twisted|"), T("|Mortise, Tenon Simple Beveled|"), T("|Mortise, Tenon Compound|")};
	
	String sSlotSubtypes[]= {_kASlPerpendicular, _kASlRotated, _kASlTilted, _kASl5Axis};
	String sSlotSubtypesT[]= {T("|Slot, Perpendicular|"), T("|Slot, Rotated|"), T("|Slot, Tilted|"), T("|Slot, 5-Axis|")};

	String sFreeprofileSubtypes[]= {_kAFPPerpendicular, _kAFP5Axis};
	String sFreeprofileSubtypesT[]= {T("|Freeprofile, Perpendicular|"), T("|Freeprofile, 5-Axis|")};

	// Collect known tool types, append 'any' entries first
	String sToolTypes[] ={ kAnyDrill,kAnyBeamcut,kAnyHousing,kAnyMortise, kAnySlot,kAnyFreeprofile}, sToolTypesT[0];
	for (int i=0;i<sPrefixTranslations.length();i++) 
		sToolTypesT.append(sPrefixTranslations[i]+" *"); 
		 
	sToolTypes.append(sDrillSubtypes);			sToolTypesT.append(sDrillSubtypesT);
	sToolTypes.append(sBeamcutSubtypes);		sToolTypesT.append(sBeamcutSubtypesT);
	sToolTypes.append(sHouseSubtypes);			sToolTypesT.append(sHouseSubtypesT);	
	sToolTypes.append(sMortiseTypesSubtypes);	sToolTypesT.append(sMortiseTypesSubtypesT);
	sToolTypes.append(sSlotSubtypes);			sToolTypesT.append(sSlotSubtypesT);
	sToolTypes.append(sFreeprofileSubtypes);	sToolTypesT.append(sFreeprofileSubtypesT);	

	//region Function TranslateInverse
	// returns the inverse translation of the given value
	String TranslateInverse(String value)
	{ 
		String out = value;
		
		int n = sToolTypes.findNoCase(value,-1);
		if (n>-1)
			out = sToolTypesT[n];
		else 
		{
			n = sToolTypesT.findNoCase(value,-1);
			if (n>-1)
				out = sToolTypes[n];			
		}
		return out;
	}//endregion	




	String kToolDefinitions = "toolDefinitions";
	String kBlockSpaceMode = "isBlockSpaceMode";
	
	String kPainterCollection ="TSL\\ToolTag\\" ;
	String tDisabled = T("<|Disabled|>"), kDisabled = "Disabled";
	String tByLocation = T("<|ByLocation|>"), kByLocation = "ByLocation", tNewDefinition = T("<|New Definition|>");


	String tToolTipToolFilter = T("|Filters the tools by their tool properties |") + TN("|The filter definitions are taken from the painter folder TSL\ToolTag|") + TN("|Filter Definitions referring to other script names than 'ToolTag' will be ignored|");
	String tToolTipFilter = T("|Filters the tools by their parent tool entity or tsl instance|") + TN("|The filter definitions are taken from the painter folder TSL\ToolTag|")+ TN("|Filter Definitions referring to the script names 'ToolTag' will be ignored|");
	String tToolTipCriteria = T("|Filters the tools by tooling criteria such as depth or diameter.|");
	String tToolTipColor = T("|Specifies the color of the tool tag.|");
	String tToolTipTransparency = T("|Specifies the level of transparency of the shape of the tool.|");
	String tToolTipFormat = T("|Defines the format to resolve the data of the filtered tool.|");

//endregion


//end Constants//endregion

//End Part #1 //endregion

//region Functions #FU

//region ArrayToMapFunctions

	//region Function GetDoubleArray
	// returns an array of doubles stored in map
	double[] GetDoubleArray(Map mapIn, int bSorted)
	{ 
		double values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasDouble(i))
				values.append(mapIn.getDouble(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetDoubleArray
	// sets an array of doubles in map
	Map SetDoubleArray(double values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendDouble(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetStringArray
	// returns an array of doubles stored in map
	String[] GetStringArray(Map mapIn, int bSorted)
	{ 
		String values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasString(i))
				values.append(mapIn.getString(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetStringArray
	// sets an array of strings in map
	Map SetStringArray(String values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendString(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));
	
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[])
	{ 
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody("bd", bodies[i]);	
		return mapOut;
	}//endregion

	//region Function GetPlaneProfileArray
	// returns an array of PlaneProfiles stored in map
	PlaneProfile[] GetPlaneProfileArray(Map mapIn)
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPlaneProfile(i))
				pps.append(mapIn.getPlaneProfile(i));
	
		return pps;
	}//endregion

	//region Function SetPlaneProfileArray
	// sets an array of PlaneProfiles in map
	Map SetPlaneProfileArray(PlaneProfile pps[])
	{ 
		Map mapOut;
		for (int i=0;i<pps.length();i++) 
			mapOut.appendPlaneProfile("pp", pps[i]);	
		return mapOut;
	}//endregion

//End ArrayToMapFunctions //endregion 	 	

//region Miscellaneous Functions


//region Function RemoveFromList
	// removes an entry from the list if it can be found
	void RemoveFromList(String& entries[], String value)
	{ 
		int n=entries.findNoCase(value ,- 1);
		if (n>-1)
			entries.removeAt(n);	
		return;
	}//endregion

//region Function CreateDummyInstance
	// returns a new instance which may be used run painter filters
	TslInst CreateDummyInstance(TslInst parent, Entity ents[], int verbose)
	{ 		
		TslInst dummy;
	// try to find in the set of entities	
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t =(TslInst)ents[i]; 
			if (t.bIsValid() && t.scriptName()==scriptName() && t.map().getInt("mode")==3)
				dummy = t;			 
		}//next i
		
	// not found, create a dummy to be able to run painter against it
		if (!dummy.bIsValid())
		{ 	
			TslInst tslNew;				
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = tLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {parent};		Point3d ptsTsl[] = {_Pt0};
			Map mapTsl; mapTsl.setInt("mode", 3);
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
			if (tslNew.bIsValid())
			{
				dummy = tslNew;
				if (verbose==1)reportNotice("\nDummy has been created");
			}
		}		
		return dummy;
	}//endregion

//region Function RoundToStep
	// rounds to a given ceiling, a negative value rounds down, a positive rounds up, sgn will be kept
	double RoundToStep(double value, double step)
	{ 
	// step = 0: do not round	
        if (step == 0)
        {
        	return value;
        }
          
        int sgn = abs(value) / value;
        double quotient = abs(value / step);
        int roundedQuotient =quotient;
        
        int bRoundUp =((step > 0 ? 1 :- 1) * (value > 0 ? 1 :- 1)) > 0;//step<0;// 
        
        if (bRoundUp)
	        roundedQuotient=quotient+ 0.999999999;
		value = roundedQuotient * abs(step)*sgn;
        return value;
	
	}//endregion

//region Function ModifyFormat
	// returns a modified format string based on quantity
	String ModifyFormat(String sFormat, int qty)
	{ 
	// parse format to append x for quantity	
		String format = sFormat;
		if (format.find("@(Quantity)", 0, false)>-1)
		{ 
			if (qty<2)
				format.replace("@(Quantity)", "");	
			else
				format.replace("@(Quantity)", "@(Quantity)x ");	
		}
		if (format.find("@(Quantity:D)", 0, false)>-1)
		{ 
			if (qty<2)
				format.replace("@(Quantity:D)", "");	
			else
				format.replace("@(Quantity:D)", "@(Quantity)x ");	
		}		

		return format;
	}//endregion

//region Function GetPainterFormat
	// returns the format of a painter
	String GetPainterFormat(String def)
	{ 
		PainterDefinition pd(kPainterCollection + def);
		if (pd.bIsValid())
			return pd.format();
		else	
			return "";
	}//endregion


//endregion

//region Multipage Functions

//region Function GetDefiningGenBeam
	// returns the defining genbeam of the multipage
	GenBeam GetDefiningGenBeam(Entity defineSet[])
	{ 
		GenBeam out;
		for (int j=0;j<defineSet.length();j++) 
		{ 
			GenBeam g = (GenBeam)defineSet[j]; 
			if (g.bIsValid())
			{ 
				out = g;
				break;
			}
		}//next j		
		return out;
	}//endregion
	
//region Function CollectPages
	// returns all multipages referring to a genbeam
	MultiPage[] CollectPages(Entity ents[])
	{ 
		MultiPage pages[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			MultiPage page = (MultiPage)ents[i]; 
			if (!page.bIsValid()) { continue;};
			
			GenBeam gb = GetDefiningGenBeam(page.defineSet());
			if (gb.bIsValid())
			{
				pages.append(page);
			}
		}		
		return pages;
	}//endregion

//region Function CollectShopdrawViews
	// returns all ShopDrawViews
	ShopDrawView[] CollectShopdrawViews(Entity ents[])
	{ 
		ShopDrawView sdvs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			ShopDrawView sdv = (ShopDrawView)ents[i]; 
			if (sdv.bIsValid()) 
				sdvs.append(sdv);	
		}		
		return sdvs;
	}//endregion

//region Function GetShopdrawProfiles
	// returns the planeprofiles of the selected shopdrawviews
	PlaneProfile[] GetShopdrawProfiles(ShopDrawView sdvs[])
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<sdvs.length();i++) 
		{ 
			ShopDrawView sdv= sdvs[i]; 

		//Get bounds of viewports		
			PlaneProfile pp(CoordSys());
			Point3d pts[] = sdv.gripPoints();
			Point3d ptCen= sdv.coordSys().ptOrg();
			double dX = U(1000), dY =dX; // something			
			for (int i=0;i<2;i++) 
			{ 
				Vector3d vec = i == 0 ? _XW : _YW;
				pts = Line(_Pt0, vec).orderPoints(pts);
				if (pts.length()>0)	
				{
					double dd = vec.dotProduct(pts.last() - pts.first());
					if (i == 0)dX = dd;
					else dY = dd;
				}
				 
			}//next i
			
			PLine pl;
			Vector3d vec = .5 * (_XW * dX + _YW * dY);
			pl.createRectangle(LineSeg(ptCen - vec, ptCen + vec), _XW, _YW);
			pp.joinRing(pl, _kAdd);		
			//pp.extentInDir(_XW).vis(1);	
			
			pps.append(pp);
				

		}//next i			
		return pps;
	}//endregion

//region Function GetMultiPageViewProfiles
	// returns the planeProfiles of all views of the given page
	PlaneProfile[] GetMultiPageViewProfiles(MultiPage page)
	{ 
		PlaneProfile pps[0];
		MultiPageView views[]=page.views();

		for (int i=0;i<views.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			pp.joinRing(views[i].plShape(),_kAdd); 
			pps.append(pp);
		}//next i
		
		return pps;
	}//endregion



//endregion	
	
//region Analysed Tool Functions

//region Function GetToolType
	// detects the toolType by the subtype
	String GetToolType(String subType)
	{ 
		String type;
		String prefix = subType.left(5).makeUpper();
		if (prefix == "_KABC") type = kAnalysedBeamCut;
		else if (prefix == "_KAFP") type = kAnalysedFreeProfile;
		else if (prefix == "_KASL") type = kAnalysedSlot;
		
		prefix = subType.left(4).makeUpper();
		if (prefix == "_KAD") type = kAnalysedDrill;
		else if (prefix == "_KAH") type = kAnalysedHouse;
		else if (prefix == "_KAM") type = kAnalysedMortise;
		
		//reportNotice("\n" + subType + " returns " +type);
		
		
		return type;
	}//endregion

//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion

//region Function AddAnyType
	// appends a virtual subtype 'any' to collect any subtype
	void AddAnyType(String toolType, String& sToolSubTypes[])
	{ 
		if (toolType.find(kAnalysedBeamCut,0, false)>-1 && sToolSubTypes.findNoCase(sBeamcutSubtypes.first(),-1)<0)
			sToolSubTypes.append(sBeamcutSubtypes.first());
		else if (toolType.find(kAnalysedDrill,0, false)>-1 && sToolSubTypes.findNoCase(sDrillSubtypes.first(),-1)<0)
			sToolSubTypes.append(sDrillSubtypes.first());	
		else if (toolType.find(kAnalysedFreeProfile,0, false)>-1 && sToolSubTypes.findNoCase(sFreeprofileSubtypes.first(),-1)<0)
			sToolSubTypes.append(sFreeprofileSubtypes.first());	
		else if (toolType.find(kAnalysedHouse,0, false)>-1 && sToolSubTypes.findNoCase(sHouseSubtypes.first(),-1)<0)
			sToolSubTypes.append(sHouseSubtypes.first());	
		else if (toolType.find(kAnalysedMortise,0, false)>-1 && sToolSubTypes.findNoCase(sMortiseTypesSubtypes.first(),-1)<0)
			sToolSubTypes.append(sMortiseTypesSubtypes.first());	
		else if (toolType.find(kAnalysedSlot,0, false)>-1 && sToolSubTypes.findNoCase(sSlotSubtypes.first(),-1)<0)
			sToolSubTypes.append(sSlotSubtypes.first());				
		return;
	}//endregion

//region Function GetToolSubTypes
	// returns a list of toolSubtypes and the corresponding quantity in the list of tools
	String[] GetToolSubTypes(GenBeam gb, AnalysedTool& tools[])
	{ 
		String toolSubTypes[0];
		tools.setLength(0);

		AnalysedTool ats[]=gb.analysedTools();
		for (int j=0;j<ats.length();j++) 
		{ 
			String toolSubType =ats[j].toolSubType(); 
			//if (bDebug)			reportNotice("\n" + toolSubType);
		// accept only the supported ones
			if (sToolTypes.findNoCase(toolSubType ,- 1)<0)
			{
				//if (bDebug)				reportNotice(",...refused");
				continue;
			}
					
			int n = toolSubTypes.findNoCase(toolSubType ,- 1);
			if (n<0)
				toolSubTypes.append(toolSubType);
			tools.append(ats[j]);
			
			AddAnyType(ats[j].toolType(), toolSubTypes);
		}//next j			

		return toolSubTypes;
	} //endregion

//region Function FilterToolByToolEnt
	// returns true if the toolEnt of the analysed tool is accepted by the painter definition
	int FilterToolByToolEnt(PainterDefinition pd, AnalysedTool tool)
	{ 
		int accepted;
		ToolEnt tent = tool.toolEnt(), tents[] = {tent};
		if (tent.bIsKindOf(TslInst()) && pd.bIsValid())// TODO check if sufficient
		{ 
			ToolEnt tents[] = pd.filterAcceptedEntities(tents);
			accepted = tents.length()==1;
			//reportNotice("\nFilterToolByToolEnt: " + pd.entryName() + " " + (accepted?" accepted":" refused") + " " + tent.formatObject("@(ScriptName:D) @(DxfName)"));
		}
		else
		{ 
			accepted = true;
			//reportNotice("\nFilterToolByToolEnt: invalid painter definition");
			
		}
		return accepted; 
	}//endregion

//region Function FilterToolsByParentPainter
	// modifies the analysed tools if accepted by the painter definition
	void FilterToolsByParentPainter(PainterDefinition pd, AnalysedTool& tools[])
	{ 
		AnalysedTool out[0];
		for (int i=tools.length()-1; i>=0 ; i--) 
			if (!FilterToolByToolEnt(pd, tools[i]))
				tools.removeAt(i);		
		return out; 
	}//endregion

//region Function GetFaceIndex
	// returns an index which is representing the face X:-1/1, Y:-2/2. Z: -3:3 
	int GetFaceIndex(Quader q, Vector3d vecDir)
	{ 
		int nFaceIndex;
		Vector3d vecFace = q.vecD(vecDir);
		if (vecFace.isCodirectionalTo(q.vecX()))nFaceIndex = 1;
		else if (vecFace.isCodirectionalTo(-q.vecX()))nFaceIndex = -1;
		else if (vecFace.isCodirectionalTo(q.vecY()))nFaceIndex = 2;
		else if (vecFace.isCodirectionalTo(-q.vecY()))nFaceIndex = -2;
		else if (vecFace.isCodirectionalTo(q.vecZ()))nFaceIndex = 3;
		else if (vecFace.isCodirectionalTo(-q.vecZ()))nFaceIndex = -3;	
		
		//q.vecZ().vis(q.pointAt(0, 0, 1), 150);
		vecDir.vis(q.pointAt(0, 0, 0), nFaceIndex+3);
		
		
		
		return nFaceIndex;
	}//endregion

//region Function GetDrillToolFormat
	// returns the mapAdd for an AnalysedDrill
	Map GetDrillToolFormat(AnalysedDrill tool, Vector3d vecZM)
	{ 
		Map out;

		Vector3d vecFace = tool.vecFree();	

		int nFaceIndex = GetFaceIndex(tool.genBeamQuader(), vecFace);

		Point3d pt1 = tool.ptStart();
		Point3d pt2 = tool.ptEndExtreme();
	
		double radius = tool.dRadius();

		out.setPoint3d("ptOnSurface", tool.ptStartExtreme());
		out.setDouble("Depth", tool.dDepth(), _kLength);
		out.setDouble("Diameter", tool.dDiameter(), _kLength);
		out.setDouble("Radius", radius, _kLength);
		
		out.setDouble("Angle", tool.dAngle(), _kNoUnit);
		out.setDouble("Bevel", tool.dBevel(), _kNoUnit);
		out.setInt("FaceIndex", nFaceIndex);
		out.setInt("IsThrough", tool.bThrough());		

		out.setString("SubType", tool.toolSubType());
		out.setString("Type", tool.toolType());

		Body bd(pt1,pt2, radius);
		out.setBody("Body", bd);
		
		if (!vecFace.isPerpendicularTo(vecZM))
		{
			double dD = RoundToStep(abs(vecFace.dotProduct(pt1 - pt2)), U(.5));	
			out.setDouble("DepthInView", dD, _kLength);
		}

		out.setVector3d("vecFace", vecFace);
		return out;
	}//endregion

//region Function GetBeamcutToolFormat
	// returns the mapAdd for an AnalysedBeamCut, AnalysedSlot, AnalysedHouse or AnalaysedMortise
	Map GetBeamcutToolFormat(AnalysedBeamCut tool, Vector3d vecZM)
	{ 
		Map out;

		Quader qdr = tool.quader();
		Point3d pt = qdr.pointAt(0,0,0);
		Vector3d vecFace = qdr.vecD(vecZM);
		if (vecFace.dotProduct(tool.vecSide()) < 0)vecFace *= -1;
		
		tool.genBeam().realBody().vis(252);		
		vecFace.vis(pt, 6);
		vecZM.vis(pt, 6);

		int nFaceIndex = GetFaceIndex(tool.genBeamQuader(), vecFace);

		out.setPoint3d("ptOnSurface", pt);
		out.setDouble("Depth", tool.dDepth(), _kLength);
		out.setDouble("Angle", tool.dAngle(), _kNoUnit);
		out.setDouble("Bevel", tool.dBevel(), _kNoUnit);			
		out.setDouble("Twist", tool.dTwist(), _kNoUnit);

		out.setInt("FaceIndex", nFaceIndex);
		out.setString("SubType", tool.toolSubType());
		out.setString("Type", tool.toolType());
		

		int bIsFreeP = tool.bIsFreeD(vecFace);
		int bIsFreeN = tool.bIsFreeD(-vecFace);		
		if (bIsFreeP || bIsFreeN)
		{ 
			double dD = RoundToStep(qdr.dD(vecZM), U(.5));	
			out.setDouble("DepthInView", dD, _kLength);			
		}
		
		// expose width and length in view
		{ 
			Vector3d vecA = qdr.vecX().isParallelTo(vecFace) ? qdr.vecY() : qdr.vecX();
			Vector3d vecB = vecA.crossProduct(-vecFace);
			
			double dA = RoundToStep(qdr.dD(vecA), U(.5));
			double dB = RoundToStep(qdr.dD(vecB), U(.5));
			
			out.setDouble("WidthInView", dA<dB?dA:dB, _kLength);
			out.setDouble("LengthInView", dA<dB?dB:dA, _kLength);
		}
		
		
		out.setInt("IsThrough", (bIsFreeP && bIsFreeN));			
		
		Body bd = tool.cuttingBody();	//bd.vis(6);
		out.setBody("Body", bd);
		out.setVector3d("vecFace", vecFace);

		return out;
	}//endregion

//region Function GetMortiseToolFormat
	// returns the mapAdd for an AnalysedMortise
	Map GetMortiseToolFormat(AnalysedMortise tool, Vector3d vecZM)
	{ 
		Map out;

		Quader qdr = tool.quader();
		Vector3d vecSide = tool.vecSide();
		Point3d pt = qdr.pointAt(0,0,0);
		Vector3d vecFace = qdr.vecD(vecZM);
		if (vecFace.dotProduct(vecSide) < 0)vecFace *= -1;
		
		int nFaceIndex = GetFaceIndex(tool.genBeamQuader(), vecFace);

		out.setPoint3d("ptOnSurface", pt);
		out.setDouble("Depth", tool.dDepth(), _kLength);
		out.setDouble("Angle", tool.dAngle(), _kNoUnit);
		out.setDouble("Bevel", tool.dBevel(), _kNoUnit);			
		out.setDouble("Twist", tool.dTwist(), _kNoUnit);

		out.setInt("FaceIndex", nFaceIndex);
		out.setString("SubType", tool.toolSubType());
		out.setString("Type", tool.toolType());


		int bIsFreeP = vecSide.dotProduct(vecFace)>0;
		int bIsFreeN = vecSide.dotProduct(vecFace)<0;		
		if (bIsFreeP || bIsFreeN)
		{
			out.setDouble("DepthInView", qdr.dD(vecZM), _kLength);//_ZU
		}
		out.setInt("IsThrough", (bIsFreeP && bIsFreeN));			
		
		Body bd = tool.cuttingBody();	//bd.vis(6);
		out.setBody("Body", bd);
		out.setVector3d("vecFace", vecFace);

		return out;
	}//endregion

//region Function GetSlotToolFormat
	// returns the mapAdd for an AnalysedSlot
	Map GetSlotToolFormat(AnalysedSlot tool, Vector3d vecZM)
	{ 
		Map out;

		Quader qdr = tool.quader();
		Vector3d vecSide = tool.vecSide();
		Point3d pt = tool.ptOnSurface();
		Vector3d vecFace = qdr.vecD(vecZM);
		if (vecFace.dotProduct(vecSide) < 0)vecFace *= -1;
		int nFaceIndex = GetFaceIndex(tool.genBeamQuader(), vecFace);

		out.setPoint3d("ptOnSurface", pt);
		out.setDouble("Depth", tool.dDepth(), _kLength);
		out.setDouble("Angle", tool.dAngle(), _kNoUnit);
		out.setDouble("Bevel", tool.dBevel(), _kNoUnit);			
		out.setDouble("Twist", tool.dTwist(), _kNoUnit);

		out.setInt("FaceIndex", nFaceIndex);
		out.setString("SubType", tool.toolSubType());
		out.setString("Type", tool.toolType());
		
		int bIsFreeP = vecSide.dotProduct(vecFace)>0;
		int bIsFreeN = vecSide.dotProduct(vecFace)<0;		
		if (bIsFreeP || bIsFreeN)
			out.setDouble("DepthInView", qdr.dD(vecZM), _kLength);//_ZU
		out.setInt("IsThrough", (bIsFreeP && bIsFreeN));			
		
		Body bd = tool.cuttingBody();	//bd.vis(6);
		out.setBody("Body", bd);
		out.setVector3d("vecFace", vecFace);

		return out;
	}//endregion

//region Function GetHouseToolFormat
	// returns the mapAdd for an AnalysedHouse
	Map GetHouseToolFormat(AnalysedHouse tool, Vector3d vecZM)
	{ 
		Map out;

		Quader qdr = tool.quader();
		Vector3d vecSide = tool.vecSide();
		Point3d pt = tool.ptOnSurface();
		Vector3d vecFace = qdr.vecD(vecZM);;
		if (vecFace.dotProduct(vecSide) < 0)vecFace *= -1;
		int nFaceIndex = GetFaceIndex(tool.genBeamQuader(), vecFace);

		out.setPoint3d("ptOnSurface", pt);
		out.setDouble("Depth", tool.dDepth(), _kLength);
		out.setDouble("Angle", tool.dAngle(), _kNoUnit);
		out.setDouble("Bevel", tool.dBevel(), _kNoUnit);			
		out.setDouble("Twist", tool.dTwist(), _kNoUnit);

		out.setInt("FaceIndex", nFaceIndex);
		out.setString("SubType", tool.toolSubType());
		out.setString("Type", tool.toolType());
		
		int bIsFreeP = vecSide.dotProduct(vecFace)>0;
		int bIsFreeN = vecSide.dotProduct(vecFace)<0;		
		if (bIsFreeP || bIsFreeN)
			out.setDouble("DepthInView", qdr.dD(vecZM), _kLength);//_ZU
		out.setInt("IsThrough", (bIsFreeP && bIsFreeN));			
		
		Body bd = tool.cuttingBody();	//bd.vis(6);
		out.setBody("Body", bd);
		out.setVector3d("vecFace", vecFace);

		return out;
	}//endregion

//region Function GetHouseToolFormat
	// returns the mapAdd for an AnalysedHouse
	Map GetFreeprofileToolFormat(AnalysedFreeProfile tool, Vector3d vecZM)
	{ 
		Map out;

		Quader qdr = tool.genBeamQuader();
		Vector3d vecSide = tool.vecSide();
		Point3d pt = tool.ptOrg();
		Vector3d vecFace = qdr.vecD(vecZM);;
		if (vecFace.dotProduct(vecSide) < 0)vecFace *= -1;
		
		int nFaceIndex = GetFaceIndex(tool.genBeamQuader(), vecFace);


		PLine plDefining = tool.plDefining();
		//plDefining.vis(3);
		if (!plDefining.isClosed())
		{ 
			PLine pl2 = plDefining;
			pl2.offset(U(2), false);
			pl2.reverse();
			plDefining.append(pl2);
			plDefining.close();
			plDefining.vis(2);
		}

		out.setPoint3d("ptOnSurface", pt);
		out.setDouble("Depth", tool.dDepth(), _kLength);
		out.setDouble("MillDiameter", tool.millDiameter(), _kLength);
		out.setDouble("DefiningLength", plDefining.length(), _kLength);		
		
//		out.setDouble("Angle", tool.dAngle(), _kNoUnit);
//		out.setDouble("Bevel", tool.dBevel(), _kNoUnit);			
//		out.setDouble("Twist", tool.dTwist(), _kNoUnit);
//
		out.setInt("FaceIndex", nFaceIndex);
		out.setInt("CncMode", tool.nCncMode());
		out.setInt("MillSide", tool.nMillSide());
		out.setInt("ClosedContour", plDefining.isClosed());
		
		
		out.setString("SubType", tool.toolSubType());
		out.setString("Type", tool.toolType());
	
		int bIsFreeP = vecSide.dotProduct(vecFace)>0;
		int bIsFreeN = vecSide.dotProduct(vecFace)<0;		
		if (bIsFreeP || bIsFreeN)
			out.setDouble("DepthInView", qdr.dD(vecZM), _kLength);//_ZU
//		out.setInt("IsThrough", (bIsFreeP && bIsFreeN));			

		
		Body bd(plDefining, vecSide * tool.dDepth(), 1);

//
		//bd.vis(6); 
//		tool.genBeam().realBody().vis(150);
		out.setBody("Body", bd);
		out.setVector3d("vecFace", vecFace);

		return out;
	}//endregion

//region Function AcceptTool
	// returns true if a tool is accepted by parent filtering and by subType, virtual type 'any' is also considered
	int AcceptTool(AnalysedTool at, PainterDefinition pd, String sToolType, String sToolSubType)
	{ 		
		String subType = at.toolSubType();
		String toolType = at.toolType();	
		int bParentTslAccepted = FilterToolByToolEnt(pd, at);
		int bAny = sToolSubType.find(kAny, 0, false)>-1;
	
	// ToolSubtype matches or it any selected of this toolType	
		int accept;
		if (bParentTslAccepted && (Equals(subType,sToolSubType) || (bAny && Equals(toolType,sToolType))))
			accept = true;
		
		return accept;
	}//endregion
	
//region Function AppendGroupedToolMap
	// returns
	void AppendGroupedToolMap(Map& mapsX, Map map, String criteria, TslInst me)
	{ 
		Map mapAdd;
		mapAdd.setMap("AnalysedTool", map);
		String key = me.formatObject(criteria, mapAdd);
						
		Map subMaps;
		if (mapsX.hasMap(key))
			subMaps = mapsX.getMap(key);
		subMaps.appendMap("ToolTag"+subMaps.length(), map);
		mapsX.setMap(key, subMaps);					
		return;
	}//endregion

//region Function AcceptFilter
	// returns true if the filter rule accepts the tool defined in map
	int AcceptFilter(Map mapTool, PainterDefinition pd, TslInst me)
	{ 
		if (!pd.bIsValid())
		{
			//reportNotice("\n   invalid painter acceptance");
			return true;//accept if painter is invalid
		}
//		Map mapAdd; 
//		mapAdd.setMap("AnalysedTool", mapTool);
		me.setSubMapX("AnalysedTool", mapTool );
		TslInst tsls[] = {me};
		//tents = Entity().filterAcceptedEntities(tents,filter, mapAdd);
		tsls = pd.filterAcceptedEntities(tsls);
		int bAccept = tsls.length() == 1;
		
		//reportNotice("\n   "+ pd.name() + " , me is " + me.handle() + " " + (bAccept?"":" not ")+ " accepted");
		return bAccept;
		
		////region Function AcceptFilter2
		//	// returns true if the filter rule accepts the tool defined in map
		//	int AcceptFilter2(Map mapTool, String filter, TslInst me)
		//	{ 
		//		Map mapAdd; 
		//		mapAdd.setMap("AnalysedTool", mapTool);
		//		me.setSubMapX("AnalysedTool", mapTool );
		//		ToolEnt tents[] = {me};
		//		tents = Entity().filterAcceptedEntities(tents,filter, mapAdd);
		//		int bAccept = tents.length() == 1;
		//		
		//		reportNotice("\n   "+filter + " "+ (bAccept?"":" not ")+ " accepted");
		////		reportNotice("\n   Me is " + me.handle() + " "+me.scriptName());
		////		reportNotice("\n   "+me.subMapX("AnalysedTool"));
		//		
		//		return bAccept;
		//	}//endregion		
		
	}//endregion



//endregion 

//region PlaneProfile Functions
	
//region Function GetClosestPlaneProfile
	// returns the inde of the closest planeprofile
	int GetClosestPlaneProfile(PlaneProfile pps[], Point3d pt)
	{ 

	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<pps.length();i++) 
	    { 
	    	double d = (pps[i].closestPointTo(pt)-pt).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i

		return n;
	}//endregion	
	
//endregion 

//region Table Functions
	
	
	//region Function GetCellValue
		// returns
		String GetCellValue(Map row, String header)
		{ 
			String out;
			
			for (int i=0;i<row.length();i++) 
			{ 
				String key = row.keyAt(i);
				if (key.find(header,0,false)==0 && key.length()==header.length())
				{ 
					if (row.hasInt(i))
					{
						int n = row.getInt(i);
						if (key.find("Active",0, false)==0)
							out = n == 0 ? T("|False|") : T("|True|");
						else
							out = n;
					}
					else if (row.hasDouble(i))
						out = row.getDouble(i);
					else
					{
						out = row.getString(i);
						int n = sToolTypes.findNoCase(out ,- 1);
						if (n >- 1)
							out = sToolTypesT[n];
						else if (out == kDisabled)
							out = tDisabled;
					}
					break;	
				}	 
			}//next i
	
			return out;
		}//endregion
	
	//region Function DrawColumn
		// Draws a column based on the header and returns the column width
		void DrawColumn(Point3d& pt, Map rows, String header, double heights[], double width, Map mapDisplay)
		{ 
			double dX;
			double textHeight =	mapDisplay.hasDouble("textHeight")?mapDisplay.getDouble("textHeight"):U(50);
			String dimStyle	  = mapDisplay.hasString("dimStyle")?mapDisplay.getString("dimStyle"):_DimStyles.first();
			
			int fillColor =	mapDisplay.hasInt("color")?mapDisplay.getInt("color"):-1;
			int transparency =	mapDisplay.hasInt("transparency")?mapDisplay.getInt("transparency"):0;
			
			Display dp(-1);
			dp.dimStyle(dimStyle);
			dp.textHeight(textHeight);
			
			Vector3d vecMargin =( pt + .5 * (_XW - _YW) * textHeight) - pt;
			
			Point3d pt0 = pt;
			
			dp.draw(header, pt+vecMargin, _XW, _YW, 1 ,- 1);
			pt -= _YW * 2 * textHeight;
			
			PLine pl; pl.createRectangle(LineSeg(pt0, pt+_XW*width),_XW,_YW);
			dp.draw(pl);
			
			
			int rowIndex;
			for (int i=0;i<rows.length();i++) 
			{ 
				String key = rows.keyAt(i);
				if (key.find("errormessages",0,false)>-1){ continue;}
				Map row = rows.getMap(key); 
				
				String value = GetCellValue(row, header);
				dp.draw(value, pt+vecMargin, _XW, _YW, 1 ,- 1);
			
				Point3d pt1 = pt;//pt1.vis(4);
				pt -=_YW*heights[rowIndex++];	
				//pt.vis(6);
				PLine pl; pl.createRectangle(LineSeg(pt, pt1+_XW*width),_XW,_YW);
				dp.draw(pl);
				
//				if (transparency>0 && transparency<100)
//				{ 
//					Display dp2(fillColor);
//					PlaneProfile pp(pl);
//					dp2.draw(pp, _kDrawFilled, transparency);
//				}
				
			}//next i
			
			
		//dWidths
			return ;
		}//endregion		

	//region Function GetRowHeights
		// returns the row heights and the colors / transparencies of each row
		double[] GetRowHeights(Map rows, Map mapDisplay, int& colors[], int& transparencies[])
		{ 
			double out[0];
			double textHeight =	mapDisplay.hasDouble("textHeight")?mapDisplay.getDouble("textHeight"):U(50);
			String dimStyle	  = mapDisplay.hasString("dimStyle")?mapDisplay.getString("dimStyle"):_DimStyles.first();
			
			colors.setLength(0);
			transparencies.setLength(0);
			
			
			Display dp(-1);			
			dp.dimStyle(dimStyle);
			dp.textHeight(textHeight);
			for (int i=0;i<rows.length();i++) 
			{ 
				Map row = rows.getMap(i); 
				colors.append(row.getInt("Color"));
				transparencies.append(row.getInt("Transparency"));				
				
			// Get Row Height by each cell	
				double dY;
				for (int j=0;j<row.length();j++) 
				{ 
					String value = GetCellValue(row, row.keyAt(j)); 
					double dD = dp.textHeightForStyle(value, dimStyle, textHeight) + 2 * textHeight;
					if (dY<dD)
						dY = dD;
				}//next j
				out.append(dY);

			}//next i			
			return out;
		}//endregion

	//region Function GetColumnWidths
		// returns the column widths and deaders
		double[] GetColumnWidths(Map rows, Map mapDisplay, String& headers[])
		{ 
			double out[0];
			double textHeight =	mapDisplay.hasDouble("textHeight")?mapDisplay.getDouble("textHeight"):U(50);
			String dimStyle	  = mapDisplay.hasString("dimStyle")?mapDisplay.getString("dimStyle"):_DimStyles.first();
			
			Display dp(-1);			
			dp.dimStyle(dimStyle);
			dp.textHeight(textHeight);
			
		// Collect headers	
			headers.setLength(0);
			if (rows.length()>0)
			{ 
				Map row = rows.getMap(0);
				for (int i=0;i<row.length();i++) 
					headers.append(row.keyAt(i)); 	
			}
			
		// Collect column widths	
			for (int j=0;j<headers.length();j++) 	
			{ 
			// get dx of header
				double dX=dp.textLengthForStyle(headers[j], dimStyle, textHeight) + 2 * textHeight;;
				for (int i=0;i<rows.length();i++) 
				{ 
				// get dx of cell					
					String value = GetCellValue(rows.getMap(i), headers[j]);
					double dD = dp.textLengthForStyle(value, dimStyle, textHeight) + 2 * textHeight;
					if (dX < dD)dX = dD;					
				}//next i	
				out.append(dX);
			}
	
			return out;
		}//endregion
	
	//region Function DrawTable
		// draws a table
		void DrawTable(Point3d pt, Map rows, Map mapDisplay, String headers[], double widths[], double heights[], int colors[], int transparencies[])
		{ 
			double textHeight =	mapDisplay.hasDouble("textHeight")?mapDisplay.getDouble("textHeight"):U(50);
			String dimStyle	  = mapDisplay.hasString("dimStyle")?mapDisplay.getString("dimStyle"):_DimStyles.first();
			
			Display dp2(-1),dp(-1);			
			dp.dimStyle(dimStyle);
			dp.textHeight(textHeight);
			
			Point3d ptRef = pt;
			Vector3d vecMargin = .5 * (_XW - _YW) * textHeight;
		
		// loop headers
			for (int i = 0; i < headers.length(); i++)
			{ 
				double dx = widths[i];
				dp.draw(T("|"+headers[i]+"|"), pt+vecMargin+_XW*.5*(dx-textHeight), _XW, _YW, 0 ,- 1);
				
				Point3d pt1 = pt;
				pt+=_XW*dx;
				Point3d pt2 = pt;
				
				PLine pl;
				pl.createRectangle(LineSeg(pt1, pt2-_YW*2*textHeight), _XW, _YW);
				dp.draw(pl);				
			
			}
			pt += _XW * _XW.dotProduct(ptRef - pt);
			pt-=_YW*2*textHeight;		
		
		// loop rows
			for (int i = 0; i < rows.length(); i++)
			{
				Map row = rows.getMap(i);
				double dy = heights[i];
				
			// loop colums: collect header and values
				for (int j=0;j<widths.length();j++) 
				{ 
					String header = headers[j];
					String value = GetCellValue(row,header);
					double dx = widths[j];
					
					Point3d pt0 = pt;
					
					int bDrawShape;
					if (header.find("Color",0,false)==0 || header.find("transparency",0,false)==0)
					{
						dp.draw(value, pt+vecMargin+_XW*(dx-textHeight), _XW, _YW, -1 ,- 1);
						
					}
					else if (header.find("Active",0,false)==0)
					{
						dp.draw(value, pt+vecMargin+_XW*.5*(dx-textHeight), _XW, _YW, 0 ,- 1);	
						bDrawShape = true;
					}
					else
						dp.draw(value, pt+vecMargin, _XW, _YW, 1 ,- 1);	
					pt+=_XW*dx;
					
					Point3d pt1 = pt-_YW*dy;
					PLine pl;
					pl.createRectangle(LineSeg(pt0, pt1), _XW, _YW);
					dp.draw(pl);
					
					if (bDrawShape)
					{ 
						dp2.color(colors[i]);
						dp2.draw(PlaneProfile(pl), _kDrawFilled, transparencies[i]);
					}
					
					 
				}//next j
				
				pt += _XW * _XW.dotProduct(ptRef - pt);
				pt-=_YW*dy; 
				
				
			}
			
			
			return;
		}//endregion	
//endregion 

//region Function GetGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int GetGripByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			if (grips[i].name()== name)
			{
				out = i;
				break;
			}	 
		}//next i
		return out;
	}//endregion


//region Function GetGroupedDimstyles
	// returns 2 arrays of same length (translated and source) of dimstyles which match the filter criteria
	// type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String[] GetGroupedDimstyles(int type, String dimStyles[])
	{ 
		String dimStylesUI[0];
		dimStyles.setLength(0);

	// some types are not supported, fall back to linear
		if (type<0 || type>4)
			type = 0;

	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$"+type, 0, false);	// indicating it is an override of the dimstyle
			if (n>-1 && dimStyles.find(dimStyle,-1)<0)
			{
				dimStylesUI.append(dimStyle.left(n)); // trim the appendix
				dimStyles.append(dimStyle);
			}
		}//next i

	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$", 0, false);	// <0 it is not any override of a dimstyle

			if (n<0 && dimStyles.findNoCase(dimStyle)<0 && dimStylesUI.findNoCase(dimStyle)<0) // do not append any parent of a grouped one
			{ 
				dimStylesUI.append(dimStyle);
				dimStyles.append(dimStyle);				
			}
		}
	
	// nothing found
		if (dimStylesUI.length()<1)
		{ 
			dimStylesUI = _DimStyles;
			dimStyles = _DimStyles;	
		}

	// order alphabetically
		for (int i=0;i<dimStylesUI.length();i++) 
			for (int j=0;j<dimStylesUI.length()-1;j++) 
				if (dimStylesUI[j]>dimStylesUI[j+1])
				{
					dimStylesUI.swap(j, j + 1);
					dimStyles.swap(j, j + 1);
				}
		
		return dimStylesUI;
	}//endregion

//region Dialog Functions

//region Function SetItemList
	// returns a map which can be consumed by a comboBox of the dialog service
	// values[]: an array of strings
	Map SetItemList(String values[], String defaultValue)
	{ 
		Map mapOut;
		for (int i=0;i<values.length();i++) 
		{
			String value = values[i];
			mapOut.setString("Item" + (i+1), value);
		}
		if (mapOut.length()<1 && defaultValue.length()>0)
			mapOut.setString("Item1",defaultValue);
		return mapOut;
	}//endregion

//region Function PurgeFolderName
	// returns a map which can be consumed by a comboBox of the dialog service
	// values[]: an array of strings
	// folder: an optional folder to be removed
	String[] PurgeFolderName(String values[], String folder)
	{ 
		String out[0];
		for (int i=0;i<values.length();i++) 
		{
			String value = values[i];
			value.replace(folder, "");
			if (value.length()>0 && out.findNoCase(value,-1)<0)
				out.append(value);	 	
		}
		return out;
	}//endregion

//region Function ShowToolDialog
	// shows the tool settings dialog
	Map ShowToolDialog(Map mapIn)
	{ 		
	//region Dialog config		
		Map rowDefinitions = mapIn.getMap(kRowDefinitions);
		Map rowDefinitionsIn = rowDefinitions;
		
	// config is untranslated
		{
			Map rows;
			for (int i=0;i<rowDefinitions.length();i++) 
			{ 
				if (rowDefinitions.hasMap(i))
				{ 
					Map row = rowDefinitions.getMap(i);
					String subType= row.getString("ToolTag");
					String filter = row.getString("filter");
					String toolFilter = row.getString("toolFilter");
					if (row.hasInt("Active") && subType.length()>0)
					{
						//if (bDebug)reportNotice("\nShowDialog: add row " + subType);
						if (filter==kByLocation)row.setString("filter", tByLocation);
						else if (filter==kDisabled)row.setString("filter", tDisabled);	
						if (toolFilter==kDisabled)row.setString("toolFilter", tDisabled);	
						row.setString("ToolTag", TranslateInverse(subType));
						rows.appendMap("Row"+i,row);
					}
				} 
			}//next i
			rowDefinitions = rows;
		}
	
		int numRows = rowDefinitions.length();
		//reportNotice("\nShowDialog: " + numRows + "rows collected");
		double dHeight =numRows * 40+160;// numRows > 5 ? 1000 : 
		
		
		Map mapDialog ;
	    Map mapDialogConfig ;
	    mapDialogConfig.setString("Title", T("|Tool Selection|"));
	    mapDialogConfig.setDouble("Height", dHeight);
	    mapDialogConfig.setDouble("Width", 1300);
	    mapDialogConfig.setDouble("MaxHeight",1000);
	    mapDialogConfig.setDouble("MaxWidth", 2000);
	    mapDialogConfig.setDouble("MinHeight", 200);
	    mapDialogConfig.setDouble("MinWidth", 800);
	    mapDialogConfig.setInt("AllowRowAdd", 1);
	    
	    mapDialogConfig.setString("Description", T("|Specifies the tools to be displayed|"));
	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);				
	//endregion 
	
	//region Columns
		Map columnDefinitions ;	
    	Map mapTools = mapIn.getMap("ToolTag[]");
    	Map mapFilters = mapIn.getMap("Filter[]");
    	Map mapToolFilters = mapIn.getMap("ToolFilter[]");	

	    Map column1 ;
	    column1.setString(kControlTypeKey, kCheckBox);
	    column1.setString(kHorizontalAlignment, kStretch);
	    column1.setString(kHeader, T("|Active|"));
	    column1.setString("ToolTip", T("|Toggles this rule to be active or diabled.|")); 
	    columnDefinitions.setMap("Active", column1);
	
		Map column2;
	    column2.setString(kControlTypeKey, kComboBox);
	    column2.setString(kHorizontalAlignment, kStretch);
	    column2.setString(kHeader, T("|Tool Description|")); // String kHeader = "Header";
	    column2.setString("ToolTip", T("|Specifies the tool to be consumed.|")); 
	    column2.setMap("Items[]", mapTools);	
	    columnDefinitions.setMap("ToolTag", column2);	
	

	    Map column3;
	    column3.setString(kControlTypeKey, kComboBox);
	    column3.setString(kHorizontalAlignment, kStretch);
	    column3.setString(kHeader, T("|Parent Filter|"));
	    column3.setString("DefaultPlaceholder", tDisabled);	    
	    column3.setString("ToolTip", tToolTipFilter);
	    column3.setMap("Items[]", mapFilters);	
	    columnDefinitions.setMap("Filter", column3);

	    Map column4;
	    column4.setString(kControlTypeKey, kComboBox);
	    column4.setString(kHorizontalAlignment, kStretch);
	    column4.setString(kHeader, T("|Tool Filter|"));
	    column4.setString("DefaultPlaceholder", tDisabled);	    
	    column4.setString("ToolTip", tToolTipToolFilter);
	    column4.setMap("Items[]", mapToolFilters);	
	    columnDefinitions.setMap("ToolFilter", column4);

	    Map column5 ;
	    column5.setString(kControlTypeKey, kTextBox);
	    column5.setString(kHorizontalAlignment, kStretch);
	    column5.setString(kHeader, T("|Display Format|"));
	    column3.setString("DefaultPlaceholder", "@(DepthInView:D)");
	    column5.setString("ToolTip", tToolTipFormat); 
	    columnDefinitions.setMap("Format", column5);

	    Map column6 ;
	    column6.setString(kControlTypeKey, kIntegerBox);
	    column6.setString(kHorizontalAlignment, kStretch);
	    column6.setString(kHeader, T("|Color|"));
	    column6.setString("ToolTip", tToolTipColor);
	    columnDefinitions.setMap("Color", column6);		
		
	    Map column7 ;
	    column7.setString(kControlTypeKey, kIntegerBox);
	    column7.setString(kHorizontalAlignment, kStretch);
	    column7.setString(kHeader, T("|Transparency|"));
	    column7.setString("ToolTip", tToolTipTransparency);
	    columnDefinitions.setMap("Transparency", column7);	

		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);	

	//endregion 	


	//region Rows
	    mapDialog.setMap(kRowDefinitions, rowDefinitions);			
	//endregion 	
	
		Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);
		int bCancel = mapRet.length() < 1;
//		if (mapRet.length()>0)
//		{ 
//			String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
//			mapRet.writeToDxxFile(sFileMap);
//			spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
//		}		

		Map mapOut;
		if (mapRet.length()>0)
		{
		// return is translated, make sure the rows are properly indexed
			Map rows;
			for (int i=0;i<mapRet.length();i++) 
			{ 
				if (mapRet.hasMap(i))
				{ 
					Map row = mapRet.getMap(i);
					
					if (!row.hasString("ToolTag")){ continue;}
					
					String subType= row.getString("ToolTag");
					int bActive = row.getInt("Active");
					//reportNotice("\nrow " + i + " subType " + subType + " active = " + bActive);
					
					String filter = row.getString("filter");
					String toolFilter = row.getString("toolFilter");
					if (subType.length()>0)
					{
						if (filter==tByLocation)row.setString("filter", kByLocation);
						else if (filter==tDisabled)	row.setString("filter", kDisabled);
						
						if (toolFilter==tDisabled)row.setString("toolFilter", kDisabled);	
						
						row.setString("ToolTag", TranslateInverse(subType));
						//reportNotice("....row " + row.getString("ToolTag"));
						
						rows.appendMap("Row:"+i,row);
					}
				} 
			}//next i
			
			if (rows.length()>0)
				mapOut.setMap(kRowDefinitions, rows);				
			else
				mapOut.setMap(kRowDefinitions, rowDefinitionsIn);	
				
			
		}
		else
		{
			if (bCancel)mapOut.setInt("WasCancelled", true);
			mapOut.setMap(kRowDefinitions, rowDefinitionsIn);
			//mapOut.writeToXmlFile("C:\\temp\\mapOutToolTag2.xml");
		}

		//mapOut.writeToXmlFile("C:\\temp\\mapOutToolTag.xml");	
		return mapOut;
	}//endregion



//endregion 

//region Function CollectCollectionPainters
	// returns all painters of a specific folder / collection, if folder not given return all
	// bUseToolFilter: accepts only painters which are targeted to the ToolTag scriptName
	String[] CollectCollectionPainters(String folder, int bUseToolFilter)
	{ 
		String painters[] = PainterDefinition().getAllEntryNames().sorted();
		if (folder.length()>0)			
			for (int i=painters.length()-1; i>=0 ; i--) 
				if (painters[i].find(folder,0,false)<0)
					painters.removeAt(i);	
		
		if (painters.findNoCase(tDisabled,-1)<0)	
			painters.insertAt(0, tDisabled);
		
		
		for (int i=painters.length()-1; i>=0 ; i--) 
		{ 
			PainterDefinition pd(painters[i]);
			String filter;
			if (pd.bIsValid())
			{
				filter = pd.filter();
			}

			int bAccepted;
			if (bUseToolFilter)
			{ 
				if (filter.find("ScriptName",0,false)>-1 && filter.find("ToolTag",0,false)>-1)
					bAccepted = true;
				else
					bAccepted = false;
			}
			else if (!bUseToolFilter)
			{ 
				if (filter.find("ToolTag",0,false)>-1)
					bAccepted = false;
				else
					bAccepted = true;
			}			
			if (!bAccepted)
			{
				painters.removeAt(i);
				continue;
			}			
		}//next i

		return painters;
	}//endregion





//endregion 

//region Part #2

//region JIG

// Jig Insert Multipage
	String kJigInsertMultipage = "JigInsertMultipage";
	if (_bOnJig && _kExecuteKey==kJigInsertMultipage) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		
	    PlaneProfile pps[0];
	    for (int i=0;i<_Map.length();i++) 
	    	if (_Map.hasPlaneProfile(i))
	    		pps.append(_Map.getPlaneProfile(i));
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());

	    
	    Display dp(-1);
	    dp.trueColor(lightblue, 50);

		int n = GetClosestPlaneProfile(pps, ptJig);
	    for (int i=0;i<pps.length();i++)
	    { 
	    	dp.trueColor(n==i?darkyellow:lightblue, n==i?0:50);
	    	dp.draw(pps[i], _kDrawFilled);
	    }

	    return;
	}


// Jig Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
		
  		Map mapDisplay = _Map.getMap("display");
  		Map rowDefinitions = _Map.getMap("rows");
		
		double textHeight =	mapDisplay.hasDouble("textHeight")?mapDisplay.getDouble("textHeight"):U(50);
		String dimStyle	  = mapDisplay.hasString("dimStyle")?mapDisplay.getString("dimStyle"):_DimStyles.first();
		
		Display dp2(-1),dp(150);			
		dp.dimStyle(dimStyle);
		dp.textHeight(textHeight);





	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		String text = _Map.getString("text");
		
	    PlaneProfile pps[0];
	    for (int i=0;i<_Map.length();i++) 
	    	if (_Map.hasPlaneProfile(i))
	    		pps.append(_Map.getPlaneProfile(i));
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());


	// text	
  		dp.draw(text, ptJig, _XW, _YW, 1, -1);	    
	
	// table
		String sHeaders[0];	
		double dWidths[] = GetColumnWidths(rowDefinitions, mapDisplay,sHeaders);//
		
		int colors[0], transparencies[0];
		double dHeights[] = GetRowHeights(rowDefinitions, mapDisplay,colors, transparencies);
		
		Point3d pt = ptJig-_YW*5*textHeight;
		Point3d ptRef = pt;
		
		DrawTable(pt, rowDefinitions, mapDisplay, sHeaders, dWidths, dHeights,colors,transparencies);	
	
	
	
	// viewports 	    
	    dp.trueColor(darkyellow, 50);
	    for (int i=0;i<pps.length();i++)
	    	dp.draw(pps[i], _kDrawFilled);





	    return;
	}
//endregion 
		
//region PreRequisites
	GenBeam gb = _GenBeam.length()>0?_GenBeam[0]:GenBeam();
	MultiPage page, pages[] = CollectPages(_Entity);
	int nViewIndex = _Map.hasInt("viewIndex")?_Map.getInt("viewIndex"):-1;
	CoordSys ms2ps, ps2ms;
	Vector3d vecZM = _ZU;
	if (pages.length()==1 && !gb.bIsValid())
	{
		page = pages.first();
		gb = GetDefiningGenBeam(page.defineSet());
		if (!gb.bIsValid())
		{ 
			reportMessage(TN("|Invalid shopdraw style|"));
			eraseInstance();
			return;			
		}
		MultiPageView views[] = page.views();
		if (nViewIndex>-1 && nViewIndex<views.length())
		{ 
			MultiPageView view = views[nViewIndex];
			ms2ps = view.modelToView();
			ps2ms = ms2ps; ps2ms.invert();
			vecZM.transformBy(ps2ms);
			vecZM.normalize();
		}
		//invalid view index
		else if(nViewIndex>-1)
		{ 
			reportMessage(TN("|Invalid view index|"));
			eraseInstance();
			return;
		}
		
		//nViewIndex<0 means continue with distribution		
	}
	if (page.bIsValid())
	{ 
		setDependencyOnEntity(page);
	}

	AnalysedTool ats[0];
	if (gb.bIsValid())
	{ 
		String toolTypes[]=GetToolSubTypes(gb, ats);
	}
	
	ShopDrawView sdvs[] = CollectShopdrawViews(_Entity);
//endregion 

//region Properties #PR

	String sToolTypeName=T("|Tool Type|");	
	PropString sToolType(0, sToolTypesT, sToolTypeName);	
	sToolType.setDescription(T("|Defines the accepted tool types|"));
	sToolType.setCategory(category);
	

	String sToolPainters[] = CollectCollectionPainters(kPainterCollection, true);
	String sToolFilters[] = PurgeFolderName(sToolPainters, kPainterCollection);
	
	if (sToolFilters.findNoCase(tByLocation,-1)<0)sToolFilters.insertAt(0,tByLocation);
	if (sToolFilters.findNoCase(tDisabled,-1)<0)sToolFilters.insertAt(0,tDisabled);
	String sToolFilterName=T("|Tool Filter|");	
	PropString sToolFilter(7, sToolFilters, sToolFilterName);	
	sToolFilter.setDescription(tToolTipToolFilter);
	sToolFilter.setCategory(category);
	if (sToolFilters.findNoCase(sToolFilter ,- 1) < 0)sToolFilter.set(tDisabled);


	String sPainters[] = CollectCollectionPainters(kPainterCollection, false);
	String sFilters[] = PurgeFolderName(sPainters, kPainterCollection);
	if (sFilters.findNoCase(tDisabled,-1)<0)sFilters.insertAt(0,tDisabled);
	String sFilterName=T("|Parent Tool Filter|");	
	PropString sFilter(5, sFilters, sFilterName);	
	sFilter.setDescription(tToolTipFilter);
	sFilter.setCategory(category);
	if (sFilters.findNoCase(sFilter ,- 1) < 0)sFilter.set(tDisabled);

	String sConfigName=T("|Config|");	
	PropString sConfig(2, "", sConfigName);	
	sConfig.setDescription(T("|Defines the Config|"));
	sConfig.setCategory(category);
	sConfig.setReadOnly(bDebug?false:_kHidden);


// Format
category = T("|Format|");
	String sFormatName=T("|Format|");	
	PropString sFormat(1, "", sFormatName);	
	sFormat.setDescription(T("|Defines the format to be applied when comparing against the filtered tool.|"));
	sFormat.setCategory(category);


// Display
category = T("|Display|");	
	String tSTTextFilled = T("|Text Label|"), tSTTextOnly = T("|Text only|"), tSTTextFilledShape = T("|Text Label + Shape|"), tSTTextOnlyShape = T("|Text only + Shape|"),tSTShapeOnly = T("|Shape only|");
	String sStyles[] = { tSTTextFilled, tSTTextOnly, tSTTextFilledShape, tSTTextOnlyShape,tSTShapeOnly};
	String sStyleName=T("|Style|");	
	PropString sStyle(4, sStyles, sStyleName);	
	sStyle.setDescription(T("|Specifies the parameters for the text and/or the shape, delineating the method by which the text and shape are rendered.|"));
	sStyle.setCategory(category);

	String tLSAll = T("|All|"), tLSPrimary = T("|Primary Only|"), tLSNone = T("|None|"), sLeaderStyles[] ={tLSAll, tLSPrimary, tLSNone};
	String sLeaderStyleName=T("|Leader Style|");	
	PropString sLeaderStyle(6, sLeaderStyles, sLeaderStyleName);	
	sLeaderStyle.setDescription(T("|Specifies the visibility settings for the leader, indicating whether they will be displayed on all instances, solely on the primary tool, or not at all.|"));
	sLeaderStyle.setCategory(category);

	String sDimStyles[] = _DimStyles, sDimStylesUI[] = GetGroupedDimstyles(0, sDimStyles); // type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyleUI(3, sDimStylesUI, sDimStyleName);	
	sDimStyleUI.setDescription(T("|Defines the dimension style.|"));
	sDimStyleUI.setCategory(category);
	String sDimStyle = sDimStyles[sDimStylesUI.findNoCase(sDimStyleUI, 0)];

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height, 0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	double textHeight;if (dTextHeight>0)textHeight=dTextHeight;else{ Display dp(0); textHeight=dp.textHeightForStyle("G", sDimStyle);}

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 72, sColorName);	
	nColor.setDescription(tToolTipColor);
	nColor.setCategory(category);
	
	String sTransparencyName=T("|Transparency|");	
	PropInt nTransparency(nIntIndex++, 0, sTransparencyName);	
	nTransparency.setDescription(tToolTipTransparency);
	nTransparency.setCategory(category);


	String sProps[] ={ sToolType, sFormat, sConfig, sDimStyle,sStyle, sFilter, sLeaderStyle, sToolFilter};
	int nProps[] ={ nColor, nTransparency};
	double dProps[] ={ dTextHeight};

//region Function setProperties
	// sets the readOnlyFlag
	void setProperties(int mode)
	{ 		
		int nReadState = bDebug ? false : _kHidden;
		if (mode==1)// ShopDdrawViewMode
		{ 
			// these properties don't matter for this kind of creation
			
			sToolType.setReadOnly(nReadState);
			sFormat.setReadOnly(nReadState);
			sFilter.setReadOnly(nReadState);
			nTransparency.setReadOnly(nReadState);
			nColor.setReadOnly(nReadState);
			sToolFilter.setReadOnly(nReadState);			
		}
		else
		{ 
			sToolType.setReadOnly(nReadState);			
		}

		
//		Property.setReadOnly(HideCondition?_kHidden:false);
		return;
	}//endregion	
//End Properties//endregion 

//region Config
	
	
	Map mapConfig,rowDefinitions, toolDefinitions;
	if (_bOnInsert)// read last inserted   || bDebug
	{ 		
		Map map = TslInst().mapWithPropValuesFromCatalog(bDebug?"ToolTag":scriptName(), tLastInserted);
		setPropValuesFromMap(map);
	}
	int bOk = mapConfig.setXmlContent(sConfig);
	if (bOk)
	{
		rowDefinitions= mapConfig.getMap(kRowDefinitions);

	// Update RowDefinitions
		for (int i=0;i<rowDefinitions.length();i++) 
		{ 
			String key = rowDefinitions.keyAt(i);
			if (rowDefinitions.hasMap(key))
			{ 
				Map row = rowDefinitions.getMap(i); 				
				if (row.hasString("Filter") && row.getString("Filter").length()<1)
					row.setString("Filter", tDisabled);
				if (!row.hasString("ToolFilter"))
					row.setString("ToolFilter", tDisabled);
				else if (row.hasString("ToolFilter") && row.getString("ToolFilter").length()<1)
					row.setString("ToolFilter", tDisabled);
				
			// keep sequence	
				Map rowx;
				rowx.setInt("Active", row.getInt("Active"));
				rowx.setString("ToolTag", row.getString("ToolTag"));
				rowx.setString("Filter", row.getString("Filter"));
				rowx.setString("ToolFilter", row.getString("ToolFilter"));
				rowx.setString("Format", row.getString("Format"));
				rowx.setInt("Color", row.getInt("Color"));
				rowx.setInt("Transparency", row.getInt("Transparency"));

				rowDefinitions.setMap(key, rowx);
			}

			
		}//next i
		mapConfig.setMap(kRowDefinitions, rowDefinitions);
	}
	mapConfig.setMap("ToolTag[]", SetItemList(sToolTypesT, ""));
	mapConfig.setMap("Filter[]", SetItemList(sFilters, tDefault));
	mapConfig.setMap("ToolFilter[]", SetItemList(sToolFilters, tDefault));	
//endregion 	




//region OnInsert
	
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// determine the current space
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int bInBlockSpace = (getVarInt("BLOCKEDITOR") == 1) || (getVarString("REFEDITNAME") != "");

	//region ShopDdrawViews
		if (bInBlockSpace)
		{
			
		//region Show dialog with existing catalog entries or allow to create a new one
			String entries[] = TslInst().getListOfCatalogNames(scriptName()).sorted();
			RemoveFromList(entries, tDefault);
			if (entries.findNoCase(tNewDefinition,-1)<0)
				entries.insertAt(0, tNewDefinition);			
			
			
			Map mapIn;
			mapIn.setString("Prompt", T("|Select a catalog entry or create a new definition|"));
			mapIn.setString("Title", T("|Tool Tag Settings|"));//__appears in dialog title bar
			mapIn.setString("Alignment", "Left");
			mapIn.setInt("EnableMultipleSelection", false);
			
			
			Map mapItems;	
			String toolTip = T("|The tool tag settings are stored in a catalog entry.|");
			for (int i=0;i<entries.length();i++) 
			{ 
				Map m;
				m.setString("Text", entries[i]);//__"Text" key defines display text for Map entries
				m.setString("ToolTip", toolTip);//__"ToolTip" key defines tooltip text for Map entries
				m.setInt("IsSelected", 0);		
				mapItems.appendMap("item", m);; 				 
			}//next i
			mapIn.setMap("Items[]", mapItems);

			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);
			
			int nSelectedIndex = mapOut.getInt("SelectedIndex");
			
		// Do not insert	
			if (mapOut.getInt("WasCancelled")==true ||nSelectedIndex<0)
			{ 
				eraseInstance();
				return;
			}
		// Show Dialog to create a new set of toolTags	
			else if (nSelectedIndex==0)
			{ 
//				if (mapConfig.length()>0)
//				{ 
//					String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + "Config.dxx";
//					mapConfig.writeToDxxFile(sFileMap);
//					spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
//				}	
				
				
				Map mapDialog = ShowToolDialog(mapConfig);	
				if (!mapDialog.getInt("WasCancelled"))
				{ 
					sConfig.set(mapDialog.getXmlContent());
					setCatalogFromPropValues(tLastInserted);
				}
			}
			else
			{ 
				setPropValuesFromCatalog(entries[nSelectedIndex]);
			}
			if (bDebug) reportMessage("\nmpOptionsOut.getInt(\"SelectedIndex\") = " + mapOut.getInt("SelectedIndex"));				
		//endregion 	

			sDimStyle = sDimStyles[sDimStylesUI.findNoCase(sDimStyleUI, 0)];
			if (dTextHeight > 0)textHeight = dTextHeight; else { Display dp(0); textHeight = dp.textHeightForStyle("G", sDimStyle); }
			
			
			Map mapDisplay;
			mapDisplay.setString("dimStyle", sDimStyle);
			mapDisplay.setDouble("textHeight", textHeight);
			mapDisplay.setInt("color", nColor);
			
			Map rowDefinitions;
			int bOk = mapConfig.setXmlContent(sConfig);
			if (bOk)
				rowDefinitions = mapConfig.getMap(kRowDefinitions);
			
			PrEntity ssE(T("|Select shopdraw viewports|"), ShopDrawView());
			if (ssE.go())
				_Entity.append(ssE.set());
			
			sdvs = CollectShopdrawViews(_Entity);
			PlaneProfile pps[] = GetShopdrawProfiles(sdvs);
			
			String text = scriptName() + " " + T("|specifying tool tags of selected views| (") + sdvs.length() + ")";
			text += "\n" + sStyleName + ": " + sStyle;
			text += "\n" + sLeaderStyleName + ": " + sLeaderStyle;
			
			
			PrPoint ssP(T("|Select location of setup information|"));
			Map mapArgs;
			for (int i = 0; i < pps.length(); i++)
				mapArgs.appendPlaneProfile("pp", pps[i]);
			mapArgs.setString("text", text);
			
			mapArgs.setMap("rows", rowDefinitions);
			mapArgs.setMap("display", mapDisplay);
			
			int nGoJig = - 1;
			while (nGoJig != _kOk && nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(kJigInsert, mapArgs);
				
				if (nGoJig == _kOk)
					_Pt0 = ssP.value(); //retrieve the selected point
				else if (nGoJig == _kCancel)
				{
					eraseInstance(); //do not insert this instance
					return;
				}
			}
		}//End ShopDdrawView //endregion 
	
	//region Model
		else
		{
			// prompt for genbeams or multipages
			String sToolSubTypes[0];
			
			GenBeam gbs[0];
			PrEntity ssE(T("|Select genbeams or multipages|"), GenBeam());
			ssE.addAllowedClass(MultiPage());
			if (ssE.go())
			{
				Entity ents[] = ssE.set();
				for (int i = 0; i < ents.length(); i++)
				{
					GenBeam gb = (GenBeam)ents[i];
					
					if (gb.bIsValid())
					{
						AnalysedTool ats[0];
						String toolSubTypes[] = GetToolSubTypes(gb, ats);
						if (toolSubTypes.length() > 0)
						{
							gbs.append(gb);
							
							for (int j = 0; j < toolSubTypes.length(); j++)
								if (sToolSubTypes.findNoCase(toolSubTypes[j] ,- 1) < 0)
									sToolSubTypes.append(toolSubTypes[j]);
						}
						continue;
					}
					
					MultiPage page = (MultiPage)ents[i];
					if (page.bIsValid())
					{
						pages.append(page);
					}
				}//next i
			}

		//region GenBeams selected
			if (gbs.length() > 0)
			{
				
				//				String toolTypesT[0];
				//				for (int j = 0; j < sToolSubTypes.length(); j++)
				//					toolTypesT.append(GetTranslatedSubtype(sToolSubTypes[j]));
				//				sSubType = PropString (0, toolTypesT, sSubTypeName);
				
				// silent/dialog
				if (_kExecuteKey.length() > 0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey ,- 1) >- 1)
					setPropValuesFromCatalog(_kExecuteKey);
					// standard dialog
				else
					showDialog();
				
				
				String sProps[] ={ sToolType, sFormat, sConfig, sDimStyle, sStyle, sFilter, sLeaderStyle, sToolFilter};
				int nProps[] ={ nColor, nTransparency};
				double dProps[] ={ dTextHeight};
				
				
				// Clone per genbeam and tool
				for (int i = 0; i < gbs.length(); i++)
				{
					GenBeam gb = gbs[i];
					
					AnalysedTool ats[0];
					String toolSubTypes[] = GetToolSubTypes(gb, ats);
					
					for (int j = 0; j < ats.length(); j++)
					{
						AnalysedTool at = ats[j];
						ToolEnt tent = at.toolEnt();
						
						Point3d pt = _Pt0;
						
						AnalysedDrill ad = (AnalysedDrill)at;
						AnalysedBeamCut abc = (AnalysedBeamCut)at;
						AnalysedFreeProfile afp = (AnalysedFreeProfile)at;
						AnalysedHouse ahs = (AnalysedHouse)at;
						AnalysedMortise ams = (AnalysedMortise)at;
						AnalysedSlot asl = (AnalysedSlot)at;
						if (ad.bIsValid())
							pt = ad.ptStartExtreme();
						else if (abc.bIsValid())
							pt = abc.quader().pointAt(0, 0, 0);
						else if (afp.bIsValid())
						{
							PLine pl = afp.plDefining();
							Point3d pts[] = pl.vertexPoints(true);
							pt = pts.length()>0?pts.first():afp.ptOrg();
						}
						else if (ahs.bIsValid())
							pt = ahs.quader().pointAt(0, 0, 0);
						else if (ams.bIsValid())
							pt = ams.quader().pointAt(0, 0, 0);
						else if (asl.bIsValid())
							pt = asl.quader().pointAt(0, 0, 0);							
						// create TSL
						TslInst tslNew;					Vector3d vecXTsl = _XU;			Vector3d vecYTsl = _YU;
						GenBeam gbsTsl[] = { gbs[i]};	Entity entsTsl[] = { };			Point3d ptsTsl[] = { pt};
						
						sProps[0] = TranslateInverse(at.toolSubType());
						
						Map mapTsl;
						
						tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
						
					}//next j
					
				}//next i
				
			}
			//End GenBeams selected //endregion

		//region Pages selected
			else if (pages.length()>0)
			{ 
				
			//region Select multipage view
				PlaneProfile pps[] = GetMultiPageViewProfiles(pages.first());

				PrPoint ssP(T("|Select view|"));
			    Map mapArgs;
			    mapArgs = SetPlaneProfileArray(pps);
			   
			    int nGoJig = -1;
			    while (nGoJig != _kOk && nGoJig != _kNone)
			    {
			        nGoJig = ssP.goJig(kJigInsertMultipage, mapArgs); 
			        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
			        
			        if (nGoJig == _kOk)
			        {
			            Point3d ptPick = ssP.value(); //retrieve the selected point
			            int n = GetClosestPlaneProfile(pps, ptPick);
			            _Map.setInt("viewIndex", n);
			            _Map.setInt("mode", 1);// force distribution
			        }
//			        else if (nGoJig == _kKeyWord)
//			        { 
//			            if (ssP.keywordIndex() == 0)
//			                mapArgs.setInt("isLeft", TRUE);
//			            else 
//			                mapArgs.setInt("isLeft", FALSE);
//			        }
			        else if (nGoJig == _kCancel)
			        { 
			            eraseInstance(); // do not insert this instance
			            return; 
			        }
			    }			
			//endregion 

			// TODO: it could be a set of pages: currently only data taken from first  page	
				GenBeam gb = GetDefiningGenBeam(pages.first().defineSet()); 
				if (!gb.bIsValid())
				{
					reportMessage("\n" + T("|Only multipages of type genbeam supported.|"));
					eraseInstance();
					return;
				}
				
			//region Filter existing tools
				AnalysedTool ats[0];
				String toolSubTypes[]=sToolTypes;//GetToolSubTypes(gb, ats); // 	HSB-23979

			//endregion 	

			//region Build dialog map and show config dialog
				setPropValuesFromCatalog(tLastInserted);	
				int bOk = mapConfig.setXmlContent(sConfig);
				if (bOk)
				{
					rowDefinitions= mapConfig.getMap(kRowDefinitions);
				}	
				mapConfig.setMap("ToolTag[]", SetItemList(sToolTypesT, ""));
				mapConfig.setMap("Filter[]", SetItemList(sFilters, tDefault));
				mapConfig.setMap("ToolFilter[]", SetItemList(sToolFilters, tDefault));
				
				//mapConfig.writeToXmlFile("C:\\temp\\mapDialogIn.xml");
				Map mapDialog = ShowToolDialog(mapConfig);	
				//mapDialog.writeToXmlFile("C:\\temp\\mapDialog.xml");
//				if (mapDialog.length()>0)
//				{ 
//					String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
//					mapDialog.writeToDxxFile(sFileMap);
//					spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
//				}
				if (mapDialog.getInt("WasCancelled"))
				{ 
					eraseInstance();
					return;
				}

			//endregion 

//				// these properties don't matter for this kind of creation
//				sToolType.setReadOnly(_kHidden);
//				sFormat.setReadOnly(_kHidden);
//				sFilter.setReadOnly(_kHidden);
//				nTransparency.setReadOnly(_kHidden);
//				nColor.setReadOnly(_kHidden);
//				sToolFilter.setReadOnly(_kHidden);
//	
//			// silent/dialog
//				if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
//					setPropValuesFromCatalog(_kExecuteKey);						
//			// standard dialog	
//				else	
//					showDialog();
	
	
			// silent/dialog
				if (_kExecuteKey.length() > 0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey ,- 1) >- 1)
				{
					setPropValuesFromCatalog(_kExecuteKey);
					setProperties(1);
				}
			// standard dialog
				else
				{
					setPropValuesFromCatalog(tLastInserted);
					setProperties(1);
					while (showDialog("---") == _kUpdate) //_kUpdate means a controlling property changed.
					{
						setProperties(1); //need to set hidden state
					}
				}	

				sConfig.set(mapDialog.getXmlContent());
				setCatalogFromPropValues(tLastInserted);
				for (int i=0;i<pages.length();i++) 	
					_Entity.append(pages[i]);
//	
//	
//				MultiPage page = pages.first();
//				_Pt0 = page.coordSys().ptOrg();
//	
//				_Entity.append(page);

				// no view index set will continue at: Clone for views and pages

				return;
			}//endregion 			
			
		}//END model //endregion 
			
		return;
	}	
	setProperties((sdvs.length() > 0 ? 1 : 0));
	
	//if (_bOnDbCreated)_ThisInst.setDebug(true);
//endregion

//End Part #2 //endregion 


//region Part #3


//region Display
	int nc = nColor;
	int transparency =nTransparency;
	Display dp(nc), dpWhite(-1),dpText(-1);
	dp.showInDxa(true);
	
	dpWhite.showInDxa(true);
	dpWhite.trueColor(rgb(255, 255, 254));

	if (sStyle==tSTTextOnly || sStyle==tSTTextOnlyShape)
		dpText.color(nc);	
	else
		dpText.trueColor(rgb(0, 0, 0));
	dpText.dimStyle(sDimStyle);	
	dpText.textHeight(textHeight);	
	dpText.showInDxa(true);

	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";	
	_ThisInst.setAllowGripAtPt0(true);
	int nMode = _Map.getInt("mode");
	if (bDebug)dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
//endregion

//region Block Mode #BM
	int bCreatedByBlockspace = _Map.getInt("BlockSpaceCreated");
	if (bCreatedByBlockspace) 
	{ 
		if (_Entity.length()<1) 
		{ 
			return; 
		}
		else
		{
			_Map.removeAt("BlockSpaceCreated", true);
		}		
	}


	if (sdvs.length()>0)
	{ 

	// add shopdraw trigger
		addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet );		

		
		PlaneProfile pps[] = GetShopdrawProfiles(sdvs);

	//region On Generate ShopDrawing
		if (_bOnGenerateShopDrawing)
		{ 
			int bLog=false;
			
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);

			if ( !bIsCreated && entCollector.bIsValid())
			{
				if (bLog)reportNotice("\nBlockSpaceCreation for " + sdvs.length() + " views");
				
				for (int i = 0; i < sdvs.length(); i++)
				{ 
					ShopDrawView sdv = sdvs[i];
					Map mapX=sdv.subMapX("ToolTag");
					int nViewIndex = mapX.hasInt("viewIndex")?mapX.getInt("viewIndex"):-1;

					ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
					int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
					if (nIndFound < 0) { continue; }
					ViewData viewData = viewDatas[nIndFound];
					
				// make sure the view refers to a genbeam	
					GenBeam gb = GetDefiningGenBeam(viewData.showSetDefineEntities());
					if (!gb.bIsValid()) { continue; }
					
				// Transformations
					CoordSys ms2ps = viewData.coordSys();
					CoordSys ps2ms = ms2ps;
					ps2ms.invert();					

				// create TSL
					TslInst tslNew;;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};
					Map mapTsl;	
					mapTsl.setInt("BlockSpaceCreated", true);
					mapTsl.setInt("BlockViewIndex", nViewIndex); // store the relative index of the shopdrawview to make sure only selected views will contribute once
					//mapTsl.setString("ViewHandle", viewData.viewHandle());
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

					if (tslNew.bIsValid())
					{
						tslNew.transformBy(Vector3d(0, 0, 0));
						
					// flag entCollector such that on regenaration no additional instances will be created	
						if (!bIsCreated)
						{
							bIsCreated=true;
							mapTslCreatedFlags.setInt(uid, true);
							entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
						}
					}
				}// next i
			}
			return;			
		}
	//endregion 
	
	
	//region Block Space Display
		else
		{ 
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			
			
			// STore the index of the viewport in relation to all viewports
			Entity viewEnts[]= Group().collectEntities(true, ShopDrawView(), _kMySpace);			
			for (int i=0;i<sdvs.length();i++) 
			{ 
				int n = viewEnts.find(sdvs[i]);
				Map mapX;
				mapX.setInt("viewIndex", n);
				sdvs[i].setSubMapX("ToolTag", mapX);				 
			}//next i
			
			
			String text = scriptName() + " " + T("|specifying tool tags of selected views| (") + sdvs.length() + ")";
			text += "\n"+sStyleName+": " + sStyle;
			text += "\n"+sLeaderStyleName+": " + sLeaderStyle;
			dpText.draw(text, _Pt0, _XW, _YW, 1, -1);
			
			Map mapDisplay;
			mapDisplay.setString("dimStyle", sDimStyle);
			mapDisplay.setDouble("textHeight", textHeight);
			mapDisplay.setInt("color", nColor);

			String sHeaders[0];	
			double dWidths[] = GetColumnWidths(rowDefinitions, mapDisplay,sHeaders);//
			
			int colors[0], transparencies[0];
			double dHeights[] = GetRowHeights(rowDefinitions, mapDisplay,colors, transparencies);
			
			Point3d pt = _Pt0-_YW*5*textHeight;
			Point3d ptRef = pt;
			
			DrawTable(pt, rowDefinitions, mapDisplay, sHeaders, dWidths, dHeights,colors,transparencies);

			Display dpJig(-1);
			dpJig.trueColor(darkyellow, 70);

				
			if (bDrag)
				for (int i=0;i<pps.length();i++) 
				{
					dpJig.draw(pps[i], _kDrawFilled);
					dpJig.draw(pps[i]);
				}

		//region Trigger
		// trigger add view
			String sAddViewTrigger = T("|Add View|");
			addRecalcTrigger(_kContextRoot, sAddViewTrigger );	
			if (_bOnRecalc && _kExecuteKey==sAddViewTrigger )
			{
				PrEntity ssE(T("|Select shopdraw viewports|"), ShopDrawView());
				if (ssE.go()) 
				{
					Entity ents[] = ssE.set();
					for (int e=0; e<ents.length(); e++) 
					{
						ShopDrawView sdv = (ShopDrawView)ents[e];
						if (sdv.bIsValid() && _Entity.find(sdv)<0)
							_Entity.append(sdv);
					}
				}
				setExecutionLoops(2);
			}
		
		// trigger remove view
			String sRemoveViewTrigger = T("|Remove View|");
			addRecalcTrigger(_kContextRoot, sRemoveViewTrigger );
			if (_bOnRecalc && _kExecuteKey==sRemoveViewTrigger )
			{
				ShopDrawView sdv = getShopDrawView();
				int n=_Entity.find(sdv);
				if (n>-1)
					_Entity.removeAt(n);
				setExecutionLoops(2);
			}
		//endregion	
		}
	//endregion 



	}
//endregion 

//region Trigger
	
// Trigger ToggleLeader
	int nLeaderStyle = sLeaderStyles.findNoCase(sLeaderStyle, 0);
	String sTriggerToggleLeader = sLeaderStyleName + " "+(nLeaderStyle==0 ? tLSPrimary : (nLeaderStyle==1 ? tLSNone : tLSAll));
	addRecalcTrigger(_kContextRoot, sTriggerToggleLeader);
	if (_bOnRecalc && (_kExecuteKey==sTriggerToggleLeader || _kExecuteKey== sDoubleClick))
	{
		nLeaderStyle++;
		if (nLeaderStyle>sLeaderStyles.length()-1)
			nLeaderStyle = 0;
		sLeaderStyle.set(sLeaderStyles[nLeaderStyle]);	
		setExecutionLoops(2);
		return;
	}

//region Trigger ToolSettings
	Map mapSetRowDefinitions = _kNameLastChangedProp==sToolTypeName?rowDefinitions:Map();
	String sTriggerToolSettings = T("|Tool Tag Settings|");
	addRecalcTrigger(_kContextRoot, sTriggerToolSettings );
	if (_bOnRecalc && _kExecuteKey==sTriggerToolSettings)
	{

		mapConfig.setMap("ToolTag[]", SetItemList(sToolTypesT,""));
		mapConfig.setMap("Filter[]", SetItemList(sFilters, tDefault));
		mapConfig.setMap("ToolFilter[]", SetItemList(sToolFilters, tDefault));

		//mapConfig.writeToXmlFile("C:\\temp\\mapDialogIn.xml");
		Map mapDialog = ShowToolDialog(mapConfig);	

//		if (mapDialog.length()>0)
//		{ 
//			String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + "Dialog.dxx";
//			mapDialog.writeToDxxFile(sFileMap);
//			spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
//		}


		if (!mapDialog.getInt("WasCancelled"))
		{ 
			sConfig.set(mapDialog.getXmlContent());
			//reportNotice("\nCONFIG: " + sConfig +"\n");
	
			//mapSetRowDefinitions = mapDialog.getMap(kRowDefinitions);	
			setCatalogFromPropValues(tLastInserted);
		}

		setExecutionLoops(2);
		return;
		
	}//endregion
	
	if (sdvs.length()>0)
		return;
//endregion 



//region Reference
	Vector3d vecFace;
	AnalysedTool tools[0];
	String toolSubTypes[0];

// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);

// Filter Definitions
	PainterDefinition pdFilter;
	if (sFilter!=tDisabled)
		pdFilter = PainterDefinition(kPainterCollection + sFilter);
	int bHasFilter = pdFilter.bIsValid();	
	
	
	PainterDefinition pdTool;
	if (sToolFilter!=tDisabled)
		pdTool = PainterDefinition(kPainterCollection + sToolFilter);
	int bHasToolFilter = pdTool.bIsValid();		
	
	//if (bDebug)reportNotice("\nPD "+sFilter + (bHasFilter?" valid":" invalid") );
//endregion 




//region Multipage

//region Clone for views and pages
	if (pages.length()>0 && nViewIndex<0)
	{ 
		for (int i=0;i<pages.length();i++) 
		{ 
			MultiPage page = pages[i]; 
			if (!page.bIsValid()){continue;}
			gb = GetDefiningGenBeam(page.defineSet()); 
			if (!gb.bIsValid()){ continue;}
			
			toolSubTypes=GetToolSubTypes(gb, tools);
			Point3d ptOrg = page.coordSys().ptOrg();
			
			MultiPageView views[] = page.views();
			for (int j=0;j<views.length();j++)
			{ 
				MultiPageView view = views[j];	
				ViewData viewData = view.viewData();
				
				if (_Map.hasInt("BlockViewIndex") && _Map.getInt("BlockViewIndex")!=j)
				{ 
					if (bDebug)reportNotice("\nrefusing BlockViewIndex " + j + " vs " + _Map.getInt("BlockViewIndex"));
					continue;
				}				
				
			// accept only orthogonal views 
				Vector3d vecZV = viewData.coordSys().vecZ();
				if (!vecZV.isParallelTo(_ZW) && !vecZV.isPerpendicularTo(_ZW))
				{ 
					continue;
				}		
				
				ms2ps = view.modelToView();
				ps2ms = ms2ps; ps2ms.invert();
				
				vecZM = _ZW;
				vecZM.transformBy(ps2ms);	vecZM.normalize();
				
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {pages[i]};			
				Map mapTsl;
				Point3d ptsTsl[] = {view.plShape().closestPointTo(_Pt0)};
				mapTsl.setInt("viewIndex", j);
				mapTsl.setInt("mode", 1);
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			
			}//next j
		}//next i
		
		if (!bDebug)
		{ 
			//reportNotice("\npurging distributor instance");
			eraseInstance();
			return;
		}
	}
		
//End Clone for views and pages //endregion 	


// Store relative page location
	if (page.bIsValid())
	{ 
		Point3d ptOrg = page.coordSys().ptOrg();
		Vector3d vecOrg = ptOrg - _PtW;		
		if (_Map.hasVector3d("vecOrg"))
		{ 
			Point3d ptPrevOrg = _Map.getVector3d("vecOrg");
			Vector3d vecPageMove = ptOrg - ptPrevOrg;
			if (!vecPageMove.bIsZeroLength())
			{ 
				_Pt0.transformBy(vecPageMove);
				
				int nGrip = GetGripByName(_Grip, "Tag");
				if (nGrip>-1)
				{ 
					Point3d ptTag = _Grip[nGrip].ptLoc()+vecPageMove; 
					_Grip[nGrip].setPtLoc(ptTag);
				}
				_Map.setVector3d("vecOrg", vecOrg);
				setExecutionLoops(2);
				return;
			}
		}
		else
			_Map.setVector3d("vecOrg", vecOrg);
	
	}
//End Multipage //endregion 

//End Part #3 //endregion

//region GenBeam
	if (gb.bIsValid())
	{ 
		toolSubTypes=GetToolSubTypes(gb, tools);
	}
	else if (nMode!=3)
	{ 
		reportNotice(T("|Could not find a valid genbeam as reference|"));
		eraseInstance();
		return;
	}
//endregion




//region Distribution Modes	#MO1
	if(nMode == 1)
	{
		//bDebug = true;

	//region Painter requires an instance to perform filter methods, but it fails when you run it against _ThisInst
		// to overcome this an additional dummy instance needs to be created. it is dependent on the calling instance and will be purged when done
		TslInst dummy = CreateDummyInstance(this, _Entity, 0);// 0=silent, 1= verbose
		if (!dummy.bIsValid())
		{ 
			reportNotice("\nDummy not found");
			setExecutionLoops(2);
			return;
		}			
	//endregion 

	//region Collect tools which have been specified in one of the rowDefinitions
		AnalysedTool atsX[0];
		for (int i=ats.length()-1; i>=0 ; i--) 
		{ 
			String subType = ats[i].toolSubType();	
			//String subType = ats[i].toolSubType();			

			for (int r=0;r<rowDefinitions.length();r++) 
			{ 
				Map m = rowDefinitions.getMap(r);
				String subTypeRow = m.getString("ToolTag");
				int bActive = m.getInt("active");	
				String format = m.getString("format");
				String filter = m.getString("filter");
				String toolFilter = m.getString("toolFilter");
				String toolTypeRow = GetToolType(subTypeRow);
				PainterDefinition pdParent(kPainterCollection+filter);
				
				
				if (!bActive || format.length()<1){ continue;}	
				if (AcceptTool(ats[i], pdParent, toolTypeRow, subTypeRow))
				{
					if (subTypeRow.find(kAny,0,false)>-1 || subTypeRow==subType)
					{
						atsX.append(ats[i]);
						ats.removeAt(i);
						break; // break r
					}
				}
			}			 
		}//next i
	//endregion 	

	//region Collect Tool Maps and Criterias		
		for (int r=0;r<rowDefinitions.length();r++) 
		{ 
			Map m = rowDefinitions.getMap(r);
			String subTypeRow = m.getString("ToolTag");
			int bActive = m.getInt("active");	
			String format = m.getString("format");
			String filter = m.getString("filter");
			String toolFilter = m.getString("toolFilter");
			int color = m.getInt("Color");
			int transparency = m.getInt("Transparency");
			String toolTypeRow = GetToolType(subTypeRow);
			int bAny = subTypeRow.find(kAny, 0, false)>-1;			
			
		// Get group frmat	
			PainterDefinition pdToolFilter(kPainterCollection+toolFilter);
			String groupFormat = pdToolFilter.format();
			if (groupFormat.length() < 1)groupFormat = r;
			groupFormat = toolTypeRow + groupFormat;
			
			PainterDefinition pdParent(kPainterCollection+filter);
			if (!bActive || format.length()<1){ continue;}	
	
			Map maps; // the collection of all groups of analysed tools
			int c; // debug color

		// Beamcut
			if (Equals(toolTypeRow,kAnalysedBeamCut))
			{ 
				c = 1;			
				for (int i=atsX.length()-1; i>=0 ; i--) 
				{ 	
				// ToolSubtype matches or it any selected of this toolType	
					if (AcceptTool(atsX[i], pdParent, toolTypeRow, subTypeRow))
					{ 		
						AnalysedBeamCut at = (AnalysedBeamCut)atsX[i];
						Map map =GetBeamcutToolFormat(at, vecZM);
						//int bAccept = AcceptFilter(map, pdToolFilter.filter(), dummy);
						int bAccept = pdToolFilter.bIsValid()?AcceptFilter(map, pdToolFilter, dummy):true;						
						if (bAccept)
						{ 
							AppendGroupedToolMap(maps, map, groupFormat, dummy);
							atsX.removeAt(i);							
						}
					}					
				}//next i								
			}
		// Drill	
			else if (Equals(toolTypeRow,kAnalysedDrill))
			{ 	
				c = 2;
				for (int i=atsX.length()-1; i>=0 ; i--) 
				{ 				
				// ToolSubtype matches or it any selected of this toolType	
					if (AcceptTool(atsX[i], pdParent, toolTypeRow, subTypeRow))
					{ 
						AnalysedDrill at = (AnalysedDrill)atsX[i];
						Map map =GetDrillToolFormat(at, vecZM);	
						int bAccept = pdToolFilter.bIsValid()?AcceptFilter(map, pdToolFilter, dummy):true;						
						if (bAccept)
						{ 
							AppendGroupedToolMap(maps, map, groupFormat, dummy);
							atsX.removeAt(i);							
						}
					}					
				}//next i								
			}
		// FreeProfile	
			else if (Equals(toolTypeRow,kAnalysedFreeProfile))
			{ 	
				c = 3;
				for (int i=atsX.length()-1; i>=0 ; i--) 
				{ 				
				// ToolSubtype matches or it any selected of this toolType	
					if (AcceptTool(atsX[i], pdParent, toolTypeRow, subTypeRow))
					{ 
						AnalysedFreeProfile at = (AnalysedFreeProfile)atsX[i];
						Map map =GetFreeprofileToolFormat(at, vecZM);	
						int bAccept = pdToolFilter.bIsValid()?AcceptFilter(map, pdToolFilter, dummy):true;						
						if (bAccept)
						{ 
							AppendGroupedToolMap(maps, map, groupFormat, dummy);
							atsX.removeAt(i);							
						}
					}					
				}//next i								
			}			
		// House	
			else if (Equals(toolTypeRow,kAnalysedHouse))
			{ 	
				c = 4;
				for (int i=atsX.length()-1; i>=0 ; i--) 
				{ 				
				// ToolSubtype matches or it any selected of this toolType	
					if (AcceptTool(atsX[i], pdParent, toolTypeRow, subTypeRow))
					{ 
						AnalysedHouse at = (AnalysedHouse)atsX[i];
						Map map =GetHouseToolFormat(at, vecZM);	
						int bAccept = pdToolFilter.bIsValid()?AcceptFilter(map, pdToolFilter, dummy):true;						
						if (bAccept)
						{ 
							AppendGroupedToolMap(maps, map, groupFormat, dummy);
							atsX.removeAt(i);							
						}
					}					
				}//next i								
			}			
		// Mortise	
			else if (Equals(toolTypeRow,kAnalysedMortise))
			{ 	
				c = 5;
				for (int i=atsX.length()-1; i>=0 ; i--) 
				{ 				
				// ToolSubtype matches or it any selected of this toolType	
					if (AcceptTool(atsX[i], pdParent, toolTypeRow, subTypeRow))
					{ 
						AnalysedMortise at = (AnalysedMortise)atsX[i];
						Map map =GetMortiseToolFormat(at, vecZM);	
						int bAccept = pdToolFilter.bIsValid()?AcceptFilter(map, pdToolFilter, dummy):true;						
						if (bAccept)
						{ 
							AppendGroupedToolMap(maps, map, groupFormat, dummy);
							atsX.removeAt(i);							
						}
					}					
				}//next i								
			}				
		// Slot	
			else if (Equals(toolTypeRow,kAnalysedSlot))
			{ 	
				c = 6;
				for (int i=atsX.length()-1; i>=0 ; i--) 
				{ 				
				// ToolSubtype matches or it any selected of this toolType	
					if (AcceptTool(atsX[i], pdParent, toolTypeRow, subTypeRow))
					{ 
						AnalysedSlot at = (AnalysedSlot)atsX[i];
						Map map =GetSlotToolFormat(at, vecZM);	
						int bAccept = pdToolFilter.bIsValid()?AcceptFilter(map, pdToolFilter, dummy):true;						
						if (bAccept)
						{ 
							AppendGroupedToolMap(maps, map, groupFormat, dummy);
							atsX.removeAt(i);							
						}
					}					
				}//next i								
			}			


			String sProps2[] ={ TranslateInverse(subTypeRow), format, sConfig, sDimStyle, sStyle, filter, sLeaderStyle, toolFilter};
			int nProps2[] ={color, transparency};
			double dProps2[] ={ dTextHeight};

		// create TSL to be distributed by tool subtype
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		
			
			Map mapTsl;
			Point3d ptsTsl[] = {_Pt0};
			mapTsl.setInt("viewIndex", nViewIndex);
			mapTsl.setInt("mode", 2);

			for (int i=0;i<maps.length();i++) 
			{ 
				Map subMap = maps.getMap(i);
				
				mapTsl.setMap("ToolTag[]", subMap);
				if (bDebug)
				{ 	
					for (int j=0;j<subMap.length();j++)
					{ 
						Map m = subMap.getMap(j);
						Point3d pt = m.getPoint3d("ptOnSurface");
						pt.transformBy(ms2ps);
						if (j == 0)ptsTsl[0] = pt;
						Point3d ptOrg = page.bIsValid() ? page.coordSys().ptOrg() : _Pt0;
						PLine (pt, ptOrg).vis(c);	//i+1)*
						dp.draw("x"+toolFilter, pt, _XW+_YW, -_XW+_YW, 1, 0);
					}					
				}
				else
				{				
					Map m = subMap.getMap(0);
					Point3d pt = m.getPoint3d("ptOnSurface");
					pt.transformBy(ms2ps);
					ptsTsl[0] = pt;					
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, _Entity, ptsTsl, nProps2, dProps2, sProps2,_kModelSpace, mapTsl);					 
				}
			}//next i			

		}			
	//endregion 	
 	

		if (bDebug)
			dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
		else
		{
			if (dummy.bIsValid())
				dummy.dbErase();
			eraseInstance();			
		}
		return;	
	}		

//endregion 

//region Model Instance
	else if (nMode == 2) //#MO2
	{
		//bDebug = true;
	
		int bByLocation = sToolFilter == tByLocation;
		_ThisInst.setAllowGripAtPt0(bByLocation);
		
		
		AnalysedBeamCut beamcuts[0];
		AnalysedDrill drills[0];
		AnalysedFreeProfile freeProfiles[0];
		AnalysedHouse houses[0];
		AnalysedMortise mortises[0];
		AnalysedSlot slots[0];
		AnalysedTool tool, atOthers[0];// others = the tools which have been filtered

	//region Re-Collect tools and store in map
		String sCollectEvents[] = { sToolFilterName, sFilterName};
		if (_bOnRecalc || sCollectEvents.findNoCase(_kNameLastChangedProp,-1)>-1) // ||bDebug
		{ 
			TslInst dummy = CreateDummyInstance(this, _Entity, bDebug);// 0=silent, 1= verbose
			
			String toolTypeT = TranslateInverse(sToolType);
			String toolType = GetToolType(toolTypeT);
			
			Map mapTools;
			AnalysedTool toolsX[]=tools;
			FilterToolsByParentPainter(pdFilter, toolsX);
	
			//reportNotice("\nsearching " + toolsX.length() + " out of "+ tools.length());

			if (Equals(toolType,kAnalysedBeamCut))
			{ 
				AnalysedBeamCut ats[]= AnalysedBeamCut().filterToolsOfToolType(toolsX);
				
				if (bByLocation)
				{ 
					Point3d pt = _Pt0; pt.transformBy(ps2ms);
					int n = AnalysedBeamCut().findClosest(ats, pt);
					if (n>-1)
					{
						beamcuts.append(ats[n]);
						Map mapAdd= GetBeamcutToolFormat(ats[n], vecZM);
						mapTools.appendMap("ToolTag", mapAdd);					
					}
				}
				else
				{ 
					for (int i=0;i<ats.length();i++) 
					{ 
						AnalysedBeamCut at = ats[i];
						Map mapAdd= GetBeamcutToolFormat(at, vecZM);
						int bAccept = AcceptFilter(mapAdd, pdTool, dummy);
						if (bAccept)
						{
							//reportNotice("\naccepting " + toolType + " "+ mapAdd.getPoint3d("ptOnSurface") + " " + mapAdd.getInt("FaceIndex"));
							beamcuts.append(at);
							mapTools.appendMap("ToolTag", mapAdd);
						}
					}					
				}
			}
			
			else if (Equals(toolType,kAnalysedDrill))
			{ 
				AnalysedDrill ats[]= AnalysedDrill().filterToolsOfToolType(toolsX);
				
				if (bByLocation)
				{ 
					Point3d pt = _Pt0; pt.transformBy(ps2ms);
					int n = AnalysedDrill().findClosest(ats, pt);
					if (n>-1)
					{
						drills.append(ats[n]);
						Map mapAdd = GetDrillToolFormat(ats[n], vecZM);
						mapTools.appendMap("ToolTag", mapAdd);					
					}
				}
				else
				{
					for (int i = 0; i < ats.length(); i++)
					{
						AnalysedDrill at = ats[i];
						Map mapAdd = GetDrillToolFormat(at, vecZM);
						int bAccept = AcceptFilter(mapAdd, pdTool, dummy);
						if (bAccept)
						{
							//reportNotice("\naccepting " + toolType + " != "+ mapAdd.getPoint3d("ptOnSurface") + " " + mapAdd.getInt("FaceIndex"));
							drills.append(at);
							mapTools.appendMap("ToolTag", mapAdd);
							if (bByLocation) { break; }
						}
					}
				}
			}

			else if (Equals(toolType,kAnalysedFreeProfile))
			{ 
				AnalysedFreeProfile ats[]= AnalysedFreeProfile().filterToolsOfToolType(toolsX);
				
				if (bByLocation)
				{ 
					Point3d pt = _Pt0; pt.transformBy(ps2ms);
					int n = AnalysedFreeProfile().findClosest(ats, pt);
					if (n>-1)
					{
						freeProfiles.append(ats[n]);
						Map mapAdd = GetFreeprofileToolFormat(ats[n], vecZM);
						mapTools.appendMap("ToolTag", mapAdd);					
					}
				}
				else
				{					
					for (int i=0;i<ats.length();i++) 
					{ 
						AnalysedFreeProfile at = ats[i];
						Map mapAdd= GetFreeprofileToolFormat(at, vecZM);
						int bAccept = AcceptFilter(mapAdd, pdTool, dummy);
						if (bAccept)
						{
							//reportNotice("\naccepting " + toolType + " != "+ mapAdd.getPoint3d("ptOnSurface") + " " + mapAdd.getInt("FaceIndex"));
							freeProfiles.append(at);
							mapTools.appendMap("ToolTag", mapAdd);
							if (bByLocation){ break;}
						}
					}
				}
			}

			else if (Equals(toolType,kAnalysedHouse))
			{ 
				AnalysedHouse ats[]= AnalysedHouse().filterToolsOfToolType(toolsX);
				
				if (bByLocation)
				{ 
					Point3d pt = _Pt0; pt.transformBy(ps2ms);
					int n = AnalysedHouse().findClosest(ats, pt);
					if (n>-1)
					{
						houses.append(ats[n]);
						Map mapAdd = GetHouseToolFormat(ats[n], vecZM);
						mapTools.appendMap("ToolTag", mapAdd);					
					}
				}
				else
				{					
					for (int i=0;i<ats.length();i++) 
					{ 
						AnalysedHouse at = ats[i];
						Map mapAdd= GetHouseToolFormat(at, vecZM);
						int bAccept = AcceptFilter(mapAdd, pdTool, dummy);
						if (bAccept)
						{
							//reportNotice("\naccepting " + toolType + " != "+ mapAdd.getPoint3d("ptOnSurface") + " " + mapAdd.getInt("FaceIndex"));
							houses.append(at);
							mapTools.appendMap("ToolTag", mapAdd);
							if (bByLocation){ break;}
						}
					}
				}
			}

			else if (Equals(toolType,kAnalysedMortise))
			{ 
				AnalysedMortise ats[]= AnalysedMortise().filterToolsOfToolType(toolsX);
				
				if (bByLocation)
				{ 
					Point3d pt = _Pt0; pt.transformBy(ps2ms);
					int n = AnalysedMortise().findClosest(ats, pt);
					if (n>-1)
					{
						mortises.append(ats[n]);
						Map mapAdd = GetMortiseToolFormat(ats[n], vecZM);
						mapTools.appendMap("ToolTag", mapAdd);					
					}
				}
				else
				{			
					for (int i=0;i<ats.length();i++) 
					{ 
						AnalysedMortise at = ats[i];
						Map mapAdd= GetMortiseToolFormat(at, vecZM);
						int bAccept = AcceptFilter(mapAdd, pdTool, dummy);
						if (bAccept)
						{
							//reportNotice("\naccepting " + toolType + " != "+ mapAdd.getPoint3d("ptOnSurface") + " " + mapAdd.getInt("FaceIndex"));
							mortises.append(at);
							mapTools.appendMap("ToolTag", mapAdd);
							if (bByLocation){ break;}
						}
					}
				}
			}

			else if (Equals(toolType,kAnalysedSlot))
			{ 
				AnalysedSlot ats[]= AnalysedSlot().filterToolsOfToolType(toolsX);
				
				if (bByLocation)
				{ 
					Point3d pt = _Pt0; pt.transformBy(ps2ms);
					int n = AnalysedSlot().findClosest(ats, pt);
					if (n>-1)
					{
						slots.append(ats[n]);
						Map mapAdd = GetSlotToolFormat(ats[n], vecZM);
						mapTools.appendMap("ToolTag", mapAdd);					
					}
				}
				else
				{
					for (int i=0;i<ats.length();i++) 
					{ 
						AnalysedSlot at = ats[i];
						Map mapAdd= GetSlotToolFormat(at, vecZM);
						int bAccept = AcceptFilter(mapAdd, pdTool, dummy);
						if (bAccept)
						{
							//reportNotice("\naccepting " + toolType + " != "+ mapAdd.getPoint3d("ptOnSurface") + " " + mapAdd.getInt("FaceIndex"));
							slots.append(at);
							mapTools.appendMap("ToolTag", mapAdd);
							if (bByLocation){ break;}
						}
					}
				}
			}

			//reportNotice("\ncollected beamcuts: " + beamcuts.length() +", drills:"+ drills.length()+ " out of "+ tools.length());
			_Map.setMap("ToolTag[]", mapTools);
			
			if (dummy.bIsValid())
				dummy.dbErase();
		}
	//endregion 
	
	//region Collect tools from map
		else
		{ 
			Map mapTools = _Map.getMap("ToolTag[]");
			for (int i=0;i<mapTools.length();i++) 
			{ 
				Map m = mapTools.getMap(i);
				Point3d pt = m.getPoint3d("ptOnSurface");			
				String toolSubType = m.getString("subType");
				String toolType= m.getString("type");
				
				if (Equals(toolType,kAnalysedBeamCut))
				{
					AnalysedBeamCut ats[0];
					ats= AnalysedBeamCut().filterToolsOfToolType(tools, toolSubType);				
					int n = AnalysedBeamCut().findClosest(ats, pt);
					if (n>-1)
						beamcuts.append(ats[n]);				
				}
				else if (Equals(toolType,kAnalysedDrill))
				{
					AnalysedDrill ats[0];
					ats= AnalysedDrill().filterToolsOfToolType(tools, toolSubType);
					
					int n = AnalysedDrill().findClosest(ats, pt);
					if (n>-1)
						drills.append(ats[n]);	
				}			
				else if (Equals(toolType,kAnalysedFreeProfile))
				{
					AnalysedFreeProfile ats[0];
					ats= AnalysedFreeProfile().filterToolsOfToolType(tools, toolSubType);
					
					int n = AnalysedFreeProfile().findClosest(ats, pt);
					if (n>-1)
						freeProfiles.append(ats[n]);	
				}	
				else if (Equals(toolType,kAnalysedHouse))
				{
					AnalysedHouse ats[0];
					ats= AnalysedHouse().filterToolsOfToolType(tools, toolSubType);
					
					int n = AnalysedHouse().findClosest(ats, pt);
					if (n>-1)
						houses.append(ats[n]);	
				}	
				else if (Equals(toolType,kAnalysedMortise))
				{
					AnalysedMortise ats[0];
					ats= AnalysedMortise().filterToolsOfToolType(tools, toolSubType);
					
					int n = AnalysedMortise().findClosest(ats, pt);
					if (n>-1)
						mortises.append(ats[n]);	
				}	
				else if (Equals(toolType,kAnalysedSlot))
				{
					AnalysedSlot ats[0];
					ats= AnalysedSlot().filterToolsOfToolType(tools, toolSubType);
					
					int n = AnalysedSlot().findClosest(ats, pt);
					if (n>-1)
						slots.append(ats[n]);	
				}					
	//			pt.vis(i);			
	//			pt.transformBy(ms2ps);
	//			pt.vis(i);	 
			}//next i			
		}
			
	//endregion 


	// The display text
		String text;
		Point3d ptFace, ptRef = _Pt0;
		Body bdSiblings[0];
		PlaneProfile pps[0], ppOthers[0];
		Vector3d vecX, vecY;
		Vector3d vecXR = _XU;
		Vector3d vecYR = _YU;
		Vector3d vecZR = _ZU;
		double dXOffsetTool, dYOffsetTool;

		Map mapDrag= _Map.getMap("Drag"); // a map storing the params for dragging
		Vector3d vecTag = mapDrag.getVector3d("vecTag");
		Map mapAdd;
	
		Map tags; // a collection identifying each tool collected
	
	
	//region AnalysedTools Interpretation
	
	//region AnalysedBeamCut
		if (beamcuts.length()>0)
		{ 			
			int n = AnalysedBeamCut().findClosest(beamcuts, _Pt0);
			if (n>-1)
			{ 
				AnalysedBeamCut at = beamcuts[n];
				tool = at;
				mapAdd= GetBeamcutToolFormat(at, vecZM);
				ptRef = mapAdd.getPoint3d("ptOnSurface");
				ptRef.transformBy(ms2ps); //ptRef.vis(3);
				tags.appendMap("tag", mapAdd);
				dXOffsetTool = textHeight;
				dYOffsetTool = textHeight;	
				
			}
			for (int i=0;i<beamcuts.length();i++) 
			{ 
				if (i == n)continue;
				AnalysedBeamCut at = beamcuts[i];
				Map map = GetBeamcutToolFormat(at, vecZM);
				tags.appendMap("tag", mapAdd);
				bdSiblings.append(map.getBody("Body"));
			}//next i			
		}//endregion 			

	//region AnalysedDrill	
		if (drills.length()>0)
		{ 
			int n = AnalysedDrill().findClosest(drills, _Pt0);

			if (n>-1)
			{ 
				AnalysedDrill at = drills[n];
				tool = at;
				mapAdd = GetDrillToolFormat(at, vecZM);
				tags.appendMap("tag", mapAdd);
				ptRef = mapAdd.getPoint3d("ptOnSurface");
				ptRef.transformBy(ms2ps); //ptRef.vis(3);
				
				dXOffsetTool = at.dDiameter();
				dYOffsetTool = dXOffsetTool;
			}


			for (int i=0;i<drills.length();i++) 
			{ 
				if (i == n)continue;
				AnalysedDrill at = drills[i];
				Map map = GetDrillToolFormat(at, vecZM);
				tags.appendMap("tag", map);
				bdSiblings.append(map.getBody("Body"));
//				Point3d pt = map.getPoint3d("ptOnSurface");
//				pt.transformBy(ms2ps);
//				PLine pl(ptRef, pt);
//				dp.draw(pl);
				
			}//next i				
		}//endregion 

	//region AnalysedFreeProfile	
		if (freeProfiles.length()>0)
		{ 
			int n = AnalysedFreeProfile().findClosest(freeProfiles, _Pt0);

			if (n>-1)
			{ 
				AnalysedFreeProfile at = freeProfiles[n];
				tool = at;
				Map map = GetFreeprofileToolFormat(at, vecZM);
				mapAdd =map; 
				tags.appendMap("tag", mapAdd);
				ptRef = mapAdd.getPoint3d("ptOnSurface");
				ptRef.transformBy(ms2ps); //ptRef.vis(3);
				
				dXOffsetTool = textHeight;
				dYOffsetTool = textHeight;	
			}


			for (int i=0;i<freeProfiles.length();i++) 
			{ 
				if (i == n)continue;
				AnalysedFreeProfile at = freeProfiles[i];
				Map map = GetFreeprofileToolFormat(at, vecZM);
				tags.appendMap("tag", map);
				bdSiblings.append(map.getBody("Body"));				
			}//next i				
		}//endregion 

	//region AnalysedHouse	
		if (houses.length()>0)
		{ 
			int n = AnalysedHouse().findClosest(houses, _Pt0);

			if (n>-1)
			{ 
				AnalysedHouse at = houses[n];
				tool = at;
				mapAdd = GetHouseToolFormat(at, vecZM);
				tags.appendMap("tag", mapAdd);
				ptRef = mapAdd.getPoint3d("ptOnSurface");
				ptRef.transformBy(ms2ps); //ptRef.vis(3);
				
				dXOffsetTool = textHeight;
				dYOffsetTool = textHeight;	
			}


			for (int i=0;i<houses.length();i++) 
			{ 
				if (i == n)continue;
				AnalysedHouse at = houses[i];
				Map map = GetHouseToolFormat(at, vecZM);
				tags.appendMap("tag", map);
				bdSiblings.append(map.getBody("Body"));				
			}//next i				
		}//endregion 

	//region AnalysedMortise	
		if (mortises.length()>0)
		{ 
			int n = AnalysedMortise().findClosest(mortises, _Pt0);

			if (n>-1)
			{ 
				AnalysedMortise at = mortises[n];
				tool = at;
				mapAdd = GetMortiseToolFormat(at, vecZM);
				tags.appendMap("tag", mapAdd);
				ptRef = mapAdd.getPoint3d("ptOnSurface");
				ptRef.transformBy(ms2ps); //ptRef.vis(3);
				
				dXOffsetTool = textHeight;
				dYOffsetTool = textHeight;	
			}


			for (int i=0;i<mortises.length();i++) 
			{ 
				if (i == n)continue;
				AnalysedMortise at = mortises[i];
				Map map = GetMortiseToolFormat(at, vecZM);
				tags.appendMap("tag", map);
				bdSiblings.append(map.getBody("Body"));				
			}//next i				
		}//endregion 

	//region AnalysedSlot
		if (slots.length()>0)
		{ 
			int n = AnalysedSlot().findClosest(slots, _Pt0);

			if (n>-1)
			{ 
				AnalysedSlot at = slots[n];
				tool = at;
				mapAdd = GetSlotToolFormat(at, vecZM);
				tags.appendMap("tag", mapAdd);
				ptRef = mapAdd.getPoint3d("ptOnSurface");
				ptRef.transformBy(ms2ps); //ptRef.vis(3);
				
				dXOffsetTool = textHeight;
				dYOffsetTool = textHeight;	
			}


			for (int i=0;i<slots.length();i++) 
			{ 
				if (i == n)continue;
				AnalysedSlot at = slots[i];
				Map map = GetSlotToolFormat(at, vecZM);
				tags.appendMap("tag", map);
				bdSiblings.append(map.getBody("Body"));				
			}//next i				
		}//endregion 
			
	//End AnalysedTools Interpretation //endregion 

	//region Get/Set data from mapAdd
		mapAdd.setString("toolSubType", tool.toolSubType());
		mapAdd.setString("toolType", tool.toolType());	
		mapAdd.setString(T("|Tool Subtype|"), T("|"+tool.toolSubType()+"|"));
		mapAdd.setString(T("|Tool Type|"), T("|"+tool.toolType()+"|"));	
		
		ptFace = mapAdd.getPoint3d("ptOnSurface");
		vecFace = mapAdd.getVector3d("vecFace");
		Body bdTool= mapAdd.getBody("Body");			bdTool.vis(4);
	//endregion 

	//region Get Face and orientationand ToolShadow
		Quader qdrGb = tool.genBeamQuader();											//qdrGb.vis(32);	bdTool.vis(211);
		Plane pnFace = qdrGb.plFaceD(vecFace);											//pnFace.vis(3);	
		Line(ptFace, vecFace).hasIntersection(pnFace, ptFace);							//vecFace.vis(ptFace, 2);
		vecX = gb.vecX().isParallelTo(vecFace) ? gb.vecY() : gb.vecX();
		vecY = vecX.crossProduct(-vecFace);

		CoordSys csFace(ptFace, vecX, vecY, vecFace);	//csFace.vis(2);
		PlaneProfile pp(csFace);
		pp.unionWith(bdTool.shadowProfile(pnFace));
		//{ Display dpx(3); dpx.draw(pp,_kDrawFilled,10);}
	
		if (page.bIsValid())
		{ 
			pnFace = Plane(_PtW, _ZW);
			ptFace.transformBy(ms2ps);
			pp.transformBy(ms2ps);
			//pp.project(pnFace, _ZW, dEps);
		}		
		//{ Display dpx(6); dpx.draw(pp,_kDrawFilled,10);}
		
		
		pp.project(pnFace, vecZR, dEps);
		pps.append(pp);
	
	// append siblings	
		for (int i=0;i<bdSiblings.length();i++) 
		{ 
			Body bd = bdSiblings[i]; 
			bd.transformBy(ms2ps);	//bd.vis(6);
			PlaneProfile ppi;
			ppi.unionWith(bd.shadowProfile(pnFace));	
			pps.append(ppi);
		}//next i
		int qty = pps.length();
		mapAdd.setInt("Quantity", qty);		
	//endregion 

	// parse format to append x for quantity	
		String format = sFormat;
		if (format.find("@(Quantity)", 0, false)>-1)
		{ 
			if (qty<2)
				format.replace("@(Quantity)", "");	
			else
				format.replace("@(Quantity)", "@(Quantity)x ");	
		}
		if (format.find("@(Quantity:D)", 0, false)>-1)
		{ 
			if (qty<2)
				format.replace("@(Quantity:D)", "");	
			else
				format.replace("@(Quantity:D)", "@(Quantity)x ");	
		}		

		text = this.formatObject(format, mapAdd);
		sFormat.setDefinesFormatting(gb, mapAdd);

	// Store map for dragging
		
		mapDrag=SetPlaneProfileArray(pps);
		mapDrag.setMap("Add", mapAdd);
		mapDrag.setVector3d("vecX", vecX);
		mapDrag.setVector3d("vecY", vecY);
		
		mapDrag.setString("text", text);
		mapDrag.setVector3d("vecOrg", _Pt0 - _PtW);
		
		Map mapOthers=SetPlaneProfileArray(ppOthers);
		mapDrag.setMap("Other[]", mapOthers);
		
		this.setSubMapX("AnalysedTool", mapAdd);




		if (Vector3d(_Pt0-ptRef).length()>dEps)
			_Pt0 = ptRef;
		double dX = dpText.textLengthForStyle(text, sDimStyle, textHeight);
		double dY = dpText.textHeightForStyle(text, sDimStyle, textHeight);
		Point3d ptTag = ptRef+vecXR*(dXOffsetTool+.5*dX)+vecYR*(dYOffsetTool+.5*dY);
		
	//region Grip Management #GM
		if (!bDrag)
		{ 
			int nGripTag = GetGripByName(_Grip, "Tag");	
			if (nGripTag>-1)
			{
				//double z = ptTagPlan.Z();
				if (_kNameLastChangedProp=="_Pt0" && !vecTag.bIsZeroLength())
				{
					ptTag = _Pt0 +vecTag;
					_Grip[nGripTag].setPtLoc(ptTag);
				}
				else
					ptTag = _Grip[nGripTag].ptLoc();
				//ptTag += vecFace * vecFace.dotProduct(ptFace - ptTag);
				
				if (Vector3d(ptTag-ptRef).length()<.5*textHeight)//// make sure grips don't overlap
				{ 
					ptTag = ptRef+.5*(vecXR+vecYR)*textHeight;
					_Grip[nGripTag].setPtLoc(ptTag);
				}	
				
			// make sure dragging on a page does not move it out of world plane	
				if (page.bIsValid() && abs(ptTag.Z())>0)
				{ 
					ptTag.setZ(0);
					_Grip[nGripTag].setPtLoc(ptTag);
				}
	
				//ptTagPlan.setZ(z);
			}
			else
			{ 
				Grip grip;
		
				if (page.bIsValid())
					ptTag.setZ(0);
				grip.setPtLoc(ptTag);
				grip.setName("Tag");
				grip.setColor(40);
				grip.setShapeType(_kGSTCircle);	
				grip.setIsRelativeToEcs(false);
				grip.setVecX(vecXR);
				grip.setVecY(vecYR);
				
				grip.addHideDirection(vecXR);
				grip.addHideDirection(-vecXR);
				grip.addHideDirection(vecYR);
				grip.addHideDirection(-vecYR);	
				
				grip.setToolTip(T("|Text location, if far away from shape leader will be drawn|"));	
				_Grip.append(grip);
				nGripTag = _Grip.length() - 1;
			}
			
			mapDrag.setVector3d("vecTag", ptTag - _Pt0);
			_Map.setMap("Drag", mapDrag);
		}
	// on drag	
		else
		{
			ptTag = ptRef + mapDrag.getVector3d("vecTag");
			transparency = 10;
			nc = darkyellow;
			if (nc>256)
				dp.trueColor(nc);
			else
				dp.color(nc);
		}
		int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);

	
	//Grip Management //endregion


	//region Draw #DR
	
		Vector3d vecBox = .5 * (vecXR * dX + vecYR * dY);
		PLine plBox; plBox.createRectangle(LineSeg(ptTag-vecBox, ptTag+vecBox), vecXR, vecYR);
		plBox.offset(-.35*textHeight, true);
		
		PlaneProfile ppBox(CoordSys(ptTag, vecXR, vecYR, vecZR));
		ppBox.joinRing(plBox,_kAdd);
		
		//String sStyles[] = { tSTTextFilled, tSTTextOnly, tSTTextFilledShape, tSTTextOnlyShape};
		if (sStyle==tSTTextFilled || sStyle==tSTTextFilledShape)
		{ 
			dpWhite.draw(ppBox, _kDrawFilled, 50);//bDebug?_kDrawAsCurves:_kDrawFilled, 50);
		}
		
		if (sStyle!=tSTShapeOnly)
			dpText.draw(text, ptTag, vecXR, vecYR, 0, 0);//, _kDevice);
	
		if (sStyle==tSTTextOnlyShape || sStyle==tSTTextFilledShape || sStyle==tSTShapeOnly ||bDrag)
		{ 
			for (int i=0;i<pps.length();i++)
			{ 
				if (transparency>=0 && transparency<100)
					dp.draw(pps[i], _kDrawFilled, transparency);
				else
					dp.draw(pps[i]);			
			}	
			
			if(bDrag)
			{ 
				dp.trueColor(lightblue);
				for (int i=0;i<ppOthers.length();i++)
				{ 
					if (transparency>=0 && transparency<100)
						dp.draw(ppOthers[i], _kDrawFilled, transparency);
					else
						dp.draw(ppOthers[i]);			
				}
				dp.trueColor(darkyellow);
			}
		}	
	//endregion 	

	//region Leader
		if (sLeaderStyle!=tLSNone && pp.pointInProfile(ptTag)==_kPointOutsideProfile)
		{ 
	
			for (int i=0;i<pps.length();i++) 
			{ 
				PlaneProfile ppRef = pps[i];	
				//ppRef.vis(3); PLine(ppRef.ptMid(), _Pt0, _PtW).vis(i);
				Vector3d vecLeader = ppRef.ptMid() - ppBox.ptMid();
				vecLeader = vecLeader.crossProduct(vecZR).crossProduct(-vecZR);
				vecLeader.normalize();
				vecLeader.vis(ptTag, 40);	
				
				Vector3d vecXL = (vecXR.dotProduct(vecLeader) < 0 ?- 1 : 1) * vecXR;
				Vector3d vecYL = (vecYR.dotProduct(vecLeader) < 0 ?- 1 : 1) * vecYR;
				
				Point3d ptNext = ppRef.closestPointTo(ptTag);
				
				double dXL = abs(vecXL.dotProduct(ptTag - ptNext));
				double dYL = abs(vecYL.dotProduct(ptTag - ptNext));
		
				vecYL.vis(ptTag, 4);
				
				Point3d pt1 = ptTag + vecXL* .5 * ppBox.dX();
				Point3d pt2 = pt1 + vecXL * .5*textHeight;
				if (dYL>dXL)
				{ 
					pt1 = ptTag + vecYL* .5 * ppBox.dY();	
					pt2 = pt1 + vecYL * .5*textHeight;		
				}
				pt1.vis(1);pt2.vis(2);
				
				if (ppRef.pointInProfile(pt2)==_kPointOutsideProfile)
				{ 
		
					Point3d pt3 = ppRef.closestPointTo(pt2+(vecXL+vecYL)*.25*textHeight);	pt3.vis(3);
					
					pt3 =ppRef.closestPointTo(pt3);
					
					PLine pl(pt1, pt2, pt3);
					if (pl.length()>1.5*textHeight)
						dp.draw(pl);		
				}
				
				if (sLeaderStyle == tLSPrimary)
					break;
			}//next i
	
		}//endregion 
	}
		
//endregion 

//region Dummy Mode to provide an instance to run painter acceptance against
	else if (nMode == 3) //#MO3	
	{
		if (_Entity.length() <1)
		{ 
			//reportNotice("\n" + _ThisInst.handle() + " dummy will be purged" );
			eraseInstance();
			return;
		}
		TslInst parent =  (TslInst)_Entity[0];
		setDependencyOnEntity(parent);
		
		//reportNotice("\n" + _ThisInst.handle() + " dummy executed by parent " + parent.handle());
		
		return;
	}
//endregion 






#End
#BeginThumbnail



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
        <int nm="BreakPoint" vl="3561" />
        <int nm="BreakPoint" vl="2928" />
        <int nm="BreakPoint" vl="2818" />
        <int nm="BreakPoint" vl="2717" />
        <int nm="BreakPoint" vl="2602" />
        <int nm="BreakPoint" vl="2890" />
        <int nm="BreakPoint" vl="3005" />
        <int nm="BreakPoint" vl="2750" />
        <int nm="BreakPoint" vl="2444" />
        <int nm="BreakPoint" vl="2477" />
        <int nm="BreakPoint" vl="1237" />
        <int nm="BreakPoint" vl="1236" />
        <int nm="BreakPoint" vl="1212" />
        <int nm="BreakPoint" vl="3089" />
        <int nm="BreakPoint" vl="2852" />
        <int nm="BreakPoint" vl="3543" />
        <int nm="BreakPoint" vl="3228" />
        <int nm="BreakPoint" vl="3255" />
        <int nm="BreakPoint" vl="3383" />
        <int nm="BreakPoint" vl="2138" />
        <int nm="BreakPoint" vl="3087" />
        <int nm="BreakPoint" vl="3016" />
        <int nm="BreakPoint" vl="2633" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24185 blockspace detection improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/18/2025 8:39:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24187 tool naming improved, dialogs in blockspace improved, translation issues fixed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="6/17/2025 4:11:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23979 bugfix collecting mortises and freeprofiles" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="4/30/2025 8:06:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23582 filtering improved, new dispaly 'shapeOnly', new filter mode 'byLocation'" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/26/2025 12:20:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End