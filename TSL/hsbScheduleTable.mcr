#Version 8
#BeginDescription
#Versions
Version 4.1 19/08/2025 HSB-24456: Reactivate property "Alignment" {top/bottom} , Author Marsel Nakuci
Version 4.0 05.06.2025 HSB-24134 counting quantity improved for nested items of metalparts
Version 3.9 24.03.2025 HSB-23719 drawing hardware color and transparency improved
Version 3.8 06.02.2025 HSB-21627 Property 'Number' resolves as integer or text
Version 3.7 30.01.2025 HSB-23421 Hardware supports simple queries equal '=' and not equal '!=', summary type added for hardware
Version 3.6 16.01.2025 HSB-23330 analysedDrill parameters appended
Version 3.5 16.12.2024 HSB-23136 supports batch shopdrawing
Version 3.4 10.12.2024 HSB-22758 Additional header overrides implemented, new commands in custom context menu to specify additional headers 
Version 3.3 10.12.2024 HSB-23136 supports insertion on multipages and creation via block space instance. new jigs to rescale and move schedule table
Version 3.2 29.11.2024 HSB-22953 supports blockrefs, new property to allow XRef/Block nested selection
Version 3.1 28.11.2024 HSB-22560  debug message removed
Version 3.0 19.11.2024 HSB-22560 accepting modelDescription / model of tsls, consuming sequential colors if defined for dependent entity
Version 2.9 08.11.2024 HSB-22936 FastenerAssemblyEnt support added
Version 2.8 17.10.2024 HSB-20933 nested reports extended
Version 2.7 16.10.2024 HSB-21627 nested reports based on elements and tsls supported. custom hierachical header definitions supported via settings file, new property to filter child entities when using nested reports
Version 2.6 24.09.2024 HSB-22718 accepts entities referenced by stack objects
Version 2.5 13.09.2024 HSB-22667 use buffered report if report definition cannot be found in company folder
Version 2.4 10.09.2024 HSB-22641 supports additional property export of hardware components via map content streamed to the notes property
Version 2.3 14.08.2024 HSB-22529 summarized hardware supports color coding via tokenized notes
Version 2.2 17.06.2024 HSB-22211 supporting implictly summary type function for metalPartCollections

Version 2.1 25.03.2024 HSB-21702 Erase instance in shopdraw if invalid data; dont show table 
Version 2.0 26.02.2024 HSB-21522 bugfix duplictaed quantity of element genbeam lists
Version 1.9 07.02.2024 HSB-21386 bugfix collecting hardware with query, collecting nested tools from genbeams
Version 1.8 05.02.2024 HSB-21276 grade display fixed
Version 1.7 24.11.2023 HSB-20703 sub-nested entities further enhanced (stacking)
Version 1.6 23.11.2023 HSB-20703 bugfix crashing acad, nested entities enhanced, grip behaviour enhanced, new property to toggle header appearance
Version 1.5 22.11.2023 HSB-20701 quantity fixed
Version 1.4 17.11.2023 HSB-20449 hardware added, new property painter added
Version 1.3 14.11.2023 HSB-20550 bounding shape published
Version 1.2 08.11.2023 HSB-20449 tsl property support added
Version 1.1 25.10.2023 HSB-20449 viewport support added
Version 1.0 24.10.2023 HSB-20449 innitial version of hsbScheduleTable































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 1
#KeyWords 
#BeginContents
//region Part #1


//region <History>
// #Versions
// 4.1 19/08/2025 HSB-24456: Reactivate property "Alignment" {top/bottom} , Author Marsel Nakuci
// 4.0 05.06.2025 HSB-24134 counting quantity improved for nested items of metalparts , Author Thorsten Huck
// 3.9 24.03.2025 HSB-23719 drawing hardware color and transparency improved , Author Thorsten Huck
// 3.8 06.02.2025 HSB-21627 Property 'Number' resolves as integer or text , Author Thorsten Huck
// 3.7 30.01.2025 HSB-23421 Hardware supports simple queries equal '=' and not equal '!=', summary type added for hardware , Author Thorsten Huck
// 3.6 16.01.2025 HSB-23330 analysedDrill parameters appended , Author Thorsten Huck
// 3.5 16.12.2024 HSB-23136 supports batch shopdrawing , Author Thorsten Huck
// 3.4 10.12.2024 HSB-22758 Additional header overrides implemented, new commands in custom context menu to specify additional headers , Author Thorsten Huck
// 3.3 10.12.2024 HSB-23136 supports insertion on multipages and creation via block space instance. new jigs to rescale and move schedule table. , Author Thorsten Huck
// 3.2 29.11.2024 HSB-22953 supports blockrefs, new property to allow XRef/Block nested selection , Author Thorsten Huck
// 3.1 28.11.2024 HSB-22560 debug message removed , Author Thorsten Huck
// 3.0 19.11.2024 HSB-22560 accepting modelDescription / model of tsls, consuming sequential colors if defined for dependent entity , Author Thorsten Huck
// 2.9 08.11.2024 HSB-22936 FastenerAssemblyEnt support added , Author Thorsten Huck
// 2.8 17.10.2024 HSB-20933 nested reports extended , Author Thorsten Huck
// 2.7 16.10.2024 HSB-21627 nested reports based on elements and tsls supported. custom hierachical header definitions supported via settings file, new property to filter child entities when using nested reports , Author Thorsten Huck
// 2.6 24.09.2024 HSB-22718 accepts entities referenced by stack objects , Author Thorsten Huck
// 2.5 13.09.2024 HSB-22667 use buffered report if report definition cannot be found in company folder , Author Thorsten Huck
// 2.4 10.09.2024 HSB-22641 supports additional property export of hardware components via map content streamed to the notes property , Author Thorsten Huck
// 2.3 14.08.2024 HSB-22529 summarized hardware supports color coding via tokenized notes , Author Thorsten Huck
// 2.2 17.06.2024 HSB-22211 supporting implictly summary type function for metalPartCollections, Author Thorsten Huck
// 2.1 25.03.2024 HSB-21702 Erase instance in shopdraw if invalid data; dont show table Marsel Nakuci
// 2.0 26.02.2024 HSB-21522 bugfix duplictaed quantity of element genbeam lists , Author Thorsten Huck
// 1.9 07.02.2024 HSB-21386 bugfix collecting hardware with query, collecting nested tools from genbeams  , Author Thorsten Huck
// 1.8 05.02.2024 HSB-21276 grade display fixed , Author Thorsten Huck
// 1.7 24.11.2023 HSB-20703 sub-nested entities further enhanced (stacking) , Author Thorsten Huck
// 1.6 23.11.2023 HSB-20703 bugfix crashing acad, nested entities enhanced, grip behaviour enhanced, new property to toggle header appearance , Author Thorsten Huck
// 1.5 22.11.2023 HSB-20701 quantity fixed , Author Thorsten Huck
// 1.4 17.11.2023 HSB-20449 hardware added, new property painter added , Author Thorsten Huck
// 1.3 14.11.2023 HSB-20550 bounding shape published , Author Thorsten Huck
// 1.2 08.11.2023 HSB-20449 tsl property support added , Author Thorsten Huck
// 1.1 25.10.2023 HSB-20449 viewport support added , Author Thorsten Huck
// 1.0 24.10.2023 HSB-20449 innitial version of hsbScheduleTable , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities and specify desired report
/// </insert>

// <summary Lang=en>
// This tsl creates a schedule table based on excel report definitions
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbScheduleTable")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Select Report") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Update Report Definition") (_TM "|Select schedule table|"))) TSLCONTENT

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
	String tYes = T("|Yes|"), tNo = T("|No|");
	String sNoYes[] = { tNo, tYes};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";	

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
	
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbExcel\\hsbExcel.dll";
	String strType = "hsbSoft.Cad.Reporting.ReportTslHelper";
	String kAscending = "Ascending", kDescending = "Descending";
	String kSummary = "Sum", kUnknown = "Unknown", kNone = "None";
	String tAll = T("|All partial reports|");
	Display dpTxt(-1), dpBackGround(-1);
	
	String kBlockSpaceMode = "BlockSpaceMode";
	int indexOfMovedGrip =  Grip().indexOfMovedGrip(_Grip);
	
	String tToolTipEnd = T("|Dragging horizontal will resize columns|") + TN("|Dragging vertical will resize text height|") + TN("|Dragging non orthogonal will scale textheight and columns|");


//region Dialog config
	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType";
	String kHorizontalAlignment = "HorizontalAlignment";
	String kLabelType = "Label";
	String kHeader = "Title";
	String kIntegerBox = "IntegerBox";
	String kTextBox = "TextBox";
	String kDoubleBox = "DoubleBox";
	String kComboBox = "ComboBox";
	String kCheckBox = "CheckBox";
	String kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";	
	//endregion




//end Constants//endregion
		
//EndPart #1 //endregion 

//region Functions

//region ArrayToMapFunctions


	//region Function GetMapKeys
		// returns
		String[] GetMapKeys(Map m)
		{ 
			String out[0];
			for (int i=0;i<m.length();i++) 
			{ 
				String key= m.keyAt(i);
				out.append(key);			 
			}//next j		
			return out;
		}//endregion


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

	//region Entity functions

//region Function isStackTsl
	// returns an integer for the detected stack tsl <0= not a stack tsl, 1 = stackItem, 2=stackPack, 3 = stackENtity, 4=stackSpacer 
	int isStackTsl(Entity ent)
	{ 
		int index;
		TslInst t = (TslInst)ent;
		if (t.bIsValid())
		{ 
			String script = t.scriptName();
			if (script.find("StackItem", 0,false)>-1)
				index = 1;
			else if (script.find("StackPack", 0,false)>-1)
				index = 2;
			else if (script.find("StackEntity", 0,false)>-1)
				index = 3;
			else if (script.find("StackSpacer", 0,false)>-1)
				index = 4;
				
			
		}
		return index;
	}//endregion

//region Function FilterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion

//region Function AppendXRefEntities
	// searches for xrefs and appends content of xref entities to an array of entities avoiding duplicates
	void AppendXRefEntities(Entity& ents[], Entity entsAdd[])
	{ 

	// Find BlockRefs and append its entities
		for (int i=0;i<entsAdd.length();i++) 
		{ 
			BlockRef bref = (BlockRef)entsAdd[i];		
			if (bref.bIsValid())
			{
				Block block(bref.definition());
				Entity entRefs[] = block.entity();
				
			// Append entities which are part of an xref
				for (int i=0;i<entRefs.length();i++) 
					if(ents.find(entRefs[i])<0 && entRefs[i].xrefName().length()>0)
					{
						ents.append(entRefs[i]); 
					}
			}
		}//next i	
		

		return;
	}//endregion


//region Function TokensToMap
	// returns a map with the tokenized values and returns tokenized color and/or transparency
	Map TokensToMap(String input, int& colorIndex, int& transparency)
	{ 
		String sIntKeys[] = { "ColorIndex", "Qty", "QtyPosNum", "Quantity", "Transparency", "Pos", "PosNum"};
		String sDblKeys[] = { "Length", "Width", "Height", "ScaleX", "ScaleY", "ScaleZ", "Diameter"};
			
		Map mapOut;
		
		String tokens[] = input.tokenize(";");
		if (tokens.length()>1) // it contains at least 2 entries
		{ 
			for (int i=0;i<tokens.length();i=i+2) 
			{ 
				if (i>tokens.length()-2){ break;}
				
				String key= tokens[i];
				String value = tokens[i+1];
				
				if (sIntKeys.findNoCase(key,-1)>-1)
					mapOut.setInt(key, value.atoi());
				else if (sDblKeys.findNoCase(key,-1)>-1)
					mapOut.setDouble(key, value.atof(), _kLength);
				else if (key.find("area",0,false)>-1)
					mapOut.setDouble(key, value.atof(), _kArea);
				else if (key.find("volume",0,false)>-1)
					mapOut.setDouble(key, value.atof(), _kVolume);	
				else
					mapOut.setString(key, value);
			}//next i
		
		
		// modify color and transparency if given
			int nKey;
			
		// get color index	
			nKey= tokens.findNoCase("ColorIndex",-1);
			if (nKey>-1 && nKey<tokens.length())
			{ 
				colorIndex = tokens[nKey + 1].atoi();
			}
		// get transparency	
			nKey = tokens.findNoCase("Transparency",-1);
			if (nKey>-1 && nKey<tokens.length())
			{ 
				transparency = tokens[nKey + 1].atoi();
			}		
		
		
		
		}

		
		return mapOut;
	}//endregion



//	//region Function addTslEntities
//	// appends additional entities of a tsl
//	// t: the tslInstance to 
//	void addNestedEntities(Entity parents[], Entity& ents[])
//	{ 
//
//		for (int j=0;j<parents.length();j++) 
//		{ 
//			Entity parent = parents[j]; 
//
//			TslInst t =(TslInst)parent; 		
//			if (t.bIsValid())
//			{ 
//				GenBeam gbs[] = t.genBeam();
//				for (int i=0;i<gbs.length();i++) 
//					if (!gbs[i].bIsDummy() && ents.find(gbs[i])<0 && parents.find(gbs[i])<0)
//						ents.append(gbs[i]);
//		
//				Entity entsT[] = t.entity();
//				for (int i=0;i<entsT.length();i++) 
//					if (ents.find(entsT[i])<0 && parents.find(entsT[i])<0)
//						ents.append(entsT[i]);	
//				continue;
//			}
//
//			MetalPartCollectionEnt ce =(MetalPartCollectionEnt)parent; 		
//			if (ce.bIsValid())
//			{ 
//				MetalPartCollectionDef cd(ce.definition());
//				GenBeam gbs[] = cd.genBeam();
//				for (int i=0;i<gbs.length();i++) 
//					if (!gbs[i].bIsDummy() && ents.find(gbs[i])<0 && parents.find(gbs[i])<0)
//						ents.append(gbs[i]);
//		
//				Entity entsT[] = cd.entity();
//				for (int i=0;i<entsT.length();i++) 
//					if (ents.find(entsT[i])<0 && parents.find(entsT[i])<0)
//						ents.append(entsT[i]);			
//				continue;
//			}
//			Element el=(Element)parent; 		
//			if (el.bIsValid())
//			{ 
//				GenBeam gbs[] = el.genBeam();
//				for (int i=0;i<gbs.length();i++) 
//					if (!gbs[i].bIsDummy() && ents.find(gbs[i])<0 && parents.find(gbs[i])<0)
//						ents.append(gbs[i]);
//
//				{
//					Opening list[] = el.opening();
//					for (int i=0;i<list.length();i++) 
//						if (ents.find(list[i])<0 && parents.find(list[i])<0)
//							ents.append(list[i]);					
//				}
//				{
//					TslInst list[] = el.tslInstAttached();
//					for (int i=0;i<list.length();i++) 
//						if (ents.find(list[i])<0 && parents.find(list[i])<0)
//							ents.append(list[i]);					
//				}
//				{
//					NailLine list[] = el.nailLine();
//					for (int i=0;i<list.length();i++) 
//						if (ents.find(list[i])<0 && parents.find(list[i])<0)
//							ents.append(list[i]);					
//				}						
//				{
//					SawLine list[] = el.sawLine();
//					for (int i=0;i<list.length();i++) 
//						if (ents.find(list[i])<0 && parents.find(list[i])<0)
//							ents.append(list[i]);					
//				}								
//				continue;
//			}	
//			MasterPanel master =(MasterPanel)parent; 		
//			if (master.bIsValid())
//			{ 
//				ChildPanel childs[] = master.nestedChildPanels();
//				for (int i=0;i<childs.length();i++) 
//				{
//					Sip panel = childs[i].sipEntity();
//					if (ents.find(panel)<0 && parents.find(panel)<0)
//						ents.append(panel);
//				}	
//				continue;
//			}				
//		}//next j
//		
//		//reportNotice("\naddNestedEntities: " +parents.length() + " + "+ents.length());
//
//		return;
//	}//End addTslEntities //endregion

	//region Function addNestedEntities
	// appends additional entities of a tsl
	// t: the tslInstance to 
	void addNestedEntities(Entity parent, Entity& ents[])
	{ 
		int bLog = bDebug;
		
		
		GenBeam g =(GenBeam)parent; 		
		if (g.bIsValid())
		{ 
			Entity entsT[] = g.eToolsConnected();
			if(bLog)reportNotice("\naddNestedEntities: "+ parent.formatObject("@(scriptName:D) @(Type:D) @(Style:D) @(Name:D) ") + entsT.length()); 
			for (int i=0;i<entsT.length();i++) 
				if (ents.find(entsT[i])<0 && parent!=entsT[i])
					ents.append(entsT[i]);	
			return;
		}		
		
		
		TslInst t =(TslInst)parent; 		
		if (t.bIsValid())
		{ 
			GenBeam gbs[] = t.genBeam();
			if(bLog)reportNotice("\naddNestedEntities: "+ parent.formatObject("@(scriptName:D) @(Type:D) @(Style:D) @(Name:D) ") + gbs.length()); 
			 	
			
			for (int i=0;i<gbs.length();i++) 
				if (!gbs[i].bIsDummy() && ents.find(gbs[i])<0)
					ents.append(gbs[i]);
	
			Entity entsT[] = t.entity();
			for (int i=0;i<entsT.length();i++) 
			{
				if(bLog)reportNotice("\naddNestedEntities: "+ parent.formatObject("@(scriptName:D) @(Type:D) @(Style:D) @(Name:D) ") + entsT.length());
				if (ents.find(entsT[i])<0 && parent!=entsT[i])
				{
					ents.append(entsT[i]);	
				}				
			}

			return;
		}

		MetalPartCollectionEnt ce =(MetalPartCollectionEnt)parent; 		
		if (ce.bIsValid())
		{ 
			MetalPartCollectionDef cd(ce.definition());
			GenBeam gbs[] = cd.genBeam();
			for (int i=0;i<gbs.length();i++) 
				if (!gbs[i].bIsDummy())// HSB-24134 && ents.find(gbs[i])<0)
					ents.append(gbs[i]);

			Entity entsT[] = cd.entity();
			for (int i=0;i<entsT.length();i++) 
				if (parent!=entsT[i])//  HSB-24134  ents.find(entsT[i])<0 && 
					ents.append(entsT[i]);			
			return;
		}
	
		MasterPanel master =(MasterPanel)parent; 		
		if (master.bIsValid())
		{ 
			ChildPanel childs[] = master.nestedChildPanels();
			for (int i=0;i<childs.length();i++) 
			{
				Sip panel = childs[i].sipEntity();
				if (ents.find(panel)<0)
					ents.append(panel);
			}	
			return;
		}				


		Element el=(Element)parent; 		
		if (el.bIsValid())
		{ 
			if(bLog)reportNotice("\naddNestedEntities: "+parent.typeDxfName()+" "+ parent.formatObject("@(scriptName:D) @(Type:D) @(Style:D) @(Name:D)"));

			GenBeam gbs[] = el.genBeam();
			for (int i=0;i<gbs.length();i++) 
				if (!gbs[i].bIsDummy() && ents.find(gbs[i])<0)
					ents.append(gbs[i]);

			{
				Opening list[] = el.opening();
				for (int i=0;i<list.length();i++) 
					if (ents.find(list[i])<0)
						ents.append(list[i]);					
			}
			{
				TslInst list[] = el.tslInstAttached();
				for (int i=0;i<list.length();i++) 
					if (ents.find(list[i])<0)
						ents.append(list[i]);					
			}
			{
				NailLine list[] = el.nailLine();
				for (int i=0;i<list.length();i++) 
					if (ents.find(list[i])<0)
						ents.append(list[i]);					
			}						
			{
				SawLine list[] = el.sawLine();
				for (int i=0;i<list.length();i++) 
					if (ents.find(list[i])<0)
						ents.append(list[i]);					
			}	
			{
				Entity list[] = el.elementGroup().collectEntities(true, BlockRef(), _kModelSpace, false);
				for (int i=0;i<list.length();i++) 
					if (ents.find(list[i])<0)
						ents.append(list[i]);					
			}			
			
			
			
			
			
			return;
		}

		return;
	}//endregion

//region Function OrderQuantifyEntities
	// orders entitities by given sort directions and properties and returns the quantity if numbered
	// ents: the entities to be ordered
	
	int[] OrderQuantifyEntities(Entity& ents[],Map mapIn, String sSortingArgs[], int bSortingDescendings[], int nSortingIndices[])
	{ 
		Map mapNestRefs=mapIn.getMap("nestingRef");
		
		int quantities[0]; 
		Entity entsX[0];
		
	//region order sorting args in reverse order
		for (int i=0;i<nSortingIndices.length();i++) 
			for (int j=0;j<nSortingIndices.length()-1;j++) 
				if (nSortingIndices[j]<nSortingIndices[j+1])
				{
					nSortingIndices.swap(j, j + 1);
					sSortingArgs.swap(j, j + 1);	
					bSortingDescendings.swap(j, j + 1);
				}
	//endregion 

	//region collect unique entities and count	
		String keys[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e= ents[i];
			TslInst t = (TslInst)e;
			String key = e.typeName() + "_" + e.handle();
			int pos = e.formatObject("@(PosNum)").atoi();
			if (t.bIsValid())
				pos = t.posnum();
			String style = e.formatObject("@(Definition:D)@(ArticleNumber:D)");// TODO metalPartCollectionStyle
			
									
			//region HSB-24134 count childs of metalparts by parents
				int qty = 1;	// quantity of entities	
			
			// Child entities of a metalpart appear only once even if multiple parents are in the selection set
			// to count the parent quantity search for the handle in the nestedRefs map and count the parents
			// the key includes the typeName for a better debugging readability
				if (mapNestRefs.hasMap(key))
				{ 
					Map mapRef = mapNestRefs.getMap(key);
					Entity refs[]= mapRef.getEntityArray("ents", "", "ent");
					int n = refs.length();
					if (n>0)
						qty *= n;	
				}
			//endregion 
			
			
			if (pos>0)
				key = e.typeName() + "_"+pos;
			else if (style.length()>0)
				key = e.typeName() + "_"+style;
				
			int n = keys.findNoCase(key ,- 1);
			if (n<0)
			{ 
				keys.append(key);
				entsX.append(e);
				quantities.append(qty);
			}
			else
			{ 
				quantities[n] += qty;
			}
		}//next i
		ents = entsX;
	//endregion 
	
	//region order by args
		for (int x=0;x<sSortingArgs.length();x++) 
		{ 
			String arg = sSortingArgs[x]; 
			if (arg.right(1)==")")
			{ 
				arg = arg.left(arg.length() - 1);
				arg += ":PL10;0)";
			}
			int bDescending= bSortingDescendings[x]; 
//			reportNotice("\nSorting by: " +arg);
			
			String values[0];
			for (int i=0;i<ents.length();i++) 
			{
				Map mapAdd;
				TslInst t = (TslInst)ents[i];
				if (t.bIsValid())
				{ 
					mapAdd.setString("ModelDescription", t.modelDescription());
					mapAdd.setString("Model", t.modelDescription());
					mapAdd.setInt("PosNum", t.posnum());
					
				}
				values.append(ents[i].formatObject(arg, mapAdd));
			}

		// order alphabetically
			for (int i=0;i<values.length();i++) 
				for (int j=0;j<values.length()-1;j++) 
					if (((values[j]>values[j+1]) && !bDescending) || (values[j]<values[j+1] && bDescending))
					{
						quantities.swap(j, j + 1);
						values.swap(j, j + 1);
						ents.swap(j, j + 1);
					} 
		
//			for (int i=0;i<ents.length();i++) 
//				reportNotice("\n  "+ents[i].handle() + " by arg: "+ arg + " value: "+ values[i] + " qty: " + quantities[i]);		
		}//next i
	//endregion 

		return quantities;
	}//endregion
		
	//endregion 

	//region Report Functions

//region Function RowHasContent
	// returns
	int RowHasContent(Map cells)
	{ 
		int bRowHasContent;
		for (int i=0;i<cells.length();i++) 
		{ 
			Map cell = cells.getMap(i);
			String text = cell.getString("text").trimLeft().trimRight();
			if (text.length()>0)
			{ 
				bRowHasContent = true;
				break;
			}
		}//next i
		
		return bRowHasContent;
	}//endregion

//region Function HardWrCompToMap
	// returns the hardware component as map
	Map HardWrCompToMap(HardWrComp hwc)
	{ 
		Map m;

		m.setString("ArticleNumber", hwc.articleNumber());
		m.setString("Name", hwc.name());
		m.setString("Description", hwc.description());
		m.setString("Manufacturer", hwc.manufacturer());
		m.setString("Model", hwc.model());
		m.setString("Material", hwc.material());
		m.setString("Category", hwc.category());
		m.setString("Group", hwc.group());
		m.setString("Notes", hwc.notes());
		m.setString("RepType", hwc.repType());
		m.setString("CountType",hwc.countType());		
		
		m.setInt("Quantity", hwc.quantity());

	
		m.setDouble("ScaleX", hwc.dScaleX(), _kLength);
		m.setDouble("ScaleY", hwc.dScaleY(), _kLength);
		m.setDouble("ScaleZ", hwc.dScaleZ(), _kLength);

		m.setEntity("linkedEntity", hwc.linkedEntity() );
		
		return m;
	}//endregion


//region Function GetGripIndexByName
	// returns the index of a grip by a given name
	int GetGripIndexByName(String name)
	{ 
		int out=-1;		
		for (int i=0;i<_Grip.length();i++) 
			if (_Grip[i].name()==name)
			{
				out=i;
				break;
			}

		
		return out;
	}//endregion

//region Function getSubReports
	String[] getSubReports(String report)
	{ 
		String out[0];
		
	// GetReportSections
		// CallDotNet1 method that accepts the following parameters in the input array.
		// Index 0 - the full path of the company folder.
		// Index 1 - the name of the report to get the sections for.
		String args[0];
		args.append(_kPathHsbCompany);	
		args.append(report);	
		out = callDotNetFunction1(strAssemblyPath, strType, "GetReportSections", args);
		out.sorted();
		if (out.length()>1)
			out.insertAt(0,tAll);
		return out;
	}//endregion

//region Function getReports
	// returns all existing reports
	String[] getReports()
	{ 
		String out[0];
		
		// CallDotNet1 method that accepts the following parameters in the input array.
		// Index 0 - the full path of the company folder.
		// all reports are returned
		String args[0];
		args.append(_kPathHsbCompany);
		out = callDotNetFunction1(strAssemblyPath, strType, "Reports", args);		
		
		out.sorted();
		return out;
	}//endregion
	
	//region Function getReportSections
	// returns
	// t: the tslInstance to 
	void getReportSections(String report, Map& mapDefs)
	{ 

	// GetReportSections
		// CallDotNet1 method that accepts the following parameters in the input array.
		// Index 0 - the full path of the company folder.
		// Index 1 - the name of the report to get the sections for.
		String args[0];
		args.append(_kPathHsbCompany);	
		args.append(report);	
		String sections[] = callDotNetFunction1(strAssemblyPath, strType, "GetReportSections", args);
		sections.sorted();
		
		Map m;
		m.setString("report", report);
		if (sections.length()>1)
		{ 
			sections.insertAt(0,tAll);
			for (int j=0;j<sections.length();j++) 
			{ 
				m.setString("section", sections[j]);
				mapDefs.appendMap("Def", m);	 
			}//next j			
		}
		else
			mapDefs.appendMap("Def", m);

		return;

	}//End getReportSections //endregion	
		
	//region Function getDefNames
	// returns
	// t: the tslInstance to 
	String[] getDefNames(Map mapDefs, String& reports[], String& sections[])
	{ 
		String out[0];
		
		
		for (int i=0;i<mapDefs.length();i++) 
		{ 
			Map m = mapDefs.getMap(i);
			String report = m.getString("report");
			String section= m.getString("section");
			
			reports.append(report);
			sections.append(section);

			out.append(report + (section.length()>0?"-":"") + section);
			 
		}//next i

		return out;
	}//End getDefNames //endregion
	
//region Function GetReportMapFromCompany
	// returns the report definition as map
	// report: the name of the report
	Map GetReportMapFromCompany(String report)
	{ 
		Map mapIn;
		mapIn.setString("ReportName", report);	
		mapIn.setString("CompanyPath", _kPathHsbCompany);	
		Map mapReport = callDotNetFunction2(strAssemblyPath, strType, "GetReportDefinition", mapIn);
		return mapReport;
	} //endregion	

//region Function GetCellExtents
	// draws a cell and returns its shape
	void GetCellExtents(PlaneProfile& pp, String text, Map mapDisplay)
	{ 
		String dimStyle = mapDisplay.getString("dimStyle");
		double textHeight = mapDisplay.getDouble("textHeight");

		Display dp(-1);
		dp.dimStyle(dimStyle);
		if (textHeight>0)dp.textHeight(textHeight);
		else textHeight=dp.textHeightForStyle("G", dimStyle);

		double marginX = textHeight;
		double marginY = textHeight;

		double dX = dp.textLengthForStyle(text, dimStyle, textHeight);
		double dY = dp.textHeightForStyle(text, dimStyle, textHeight);
		if (dX<dEps || dY<dEps)
			return;
	
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Point3d ptLoc = cs.ptOrg();
		
		Vector3d vec = .5 * (vecX * (dX+marginX)-vecY* (dY+marginY));

		Point3d ptCen = ptLoc + vec;
		pp.createRectangle(LineSeg(ptCen-vec, ptCen+vec), vecX, vecY);

		return ;
	}//endregion

//region Function getCellExtents
	// draws a cell and returns its shape
	PlaneProfile getCellExtents(String text, Point3d ptLoc, Vector3d vecX, Vector3d vecY, Display display, double textHeight, String dimStyle)
	{ 
		display.dimStyle(dimStyle);
		if (textHeight>0)display.textHeight(textHeight);
		
		double marginX = textHeight;// * .5;
		double marginY = textHeight;

		double dX = display.textLengthForStyle(text, dimStyle, textHeight);
		double dY = display.textHeightForStyle(text, dimStyle, textHeight);
		if (dX<dEps || dY<dEps)
			return PlaneProfile();
	
		Vector3d vecZ = vecY.crossProduct(vecY);
		CoordSys cs(ptLoc, vecX, vecY, vecZ);
		Vector3d vec = .5 * (vecX * (dX+marginX)-vecY* (dY+marginY));

		Point3d ptCen = ptLoc + vec;
		Point3d ptTxt = ptCen;//ptCen +vecX*alignHorizontal*.5*dX;	//ptTxt.vis(6);
		PlaneProfile pp(cs); 
		pp.createRectangle(LineSeg(ptCen-vec, ptCen+vec), vecX, vecY);

		return pp;
	}//endregion

//region Function GetEntitiesOfType
	// returns the entities of the specified type
	// query: an experession which can be used as filter of a painterdefinition
	Entity[] GetEntitiesOfType(Entity ents[], String typeName, String query)
	{ 
		Entity out[0];
		
		String type = "Entity";

		if (typeName.find("Sip", 0, false) >- 1)type = "Panel";
		else if (typeName.find("Beam", 0, false) >- 1)type = "Beam";
		else if (typeName.find("Sheet", 0, false) >- 1)type = "Sheet";		
		else if (typeName.find("CollectionEntity", 0, false) >- 1)type = "MetalPartCollectionEntity";
		else if (typeName.find("TslInstance", 0, false) >- 1)type = "TslInstance";
		else if (typeName.find("ElementWallStickFrame", 0, false) >- 1)type = "ElementWallStickFrame";
		else if (typeName.find("ElementRoof", 0, false) >- 1)type = "ElementRoof";
		else if (typeName.find("HardwareComponent", 0, false) >- 1)type = "ToolEnt";
		else if (typeName.find("MasterPanel", 0, false) >- 1)type = "MasterPanel";
		else if (typeName.find("FastenerAssembly", 0, false) >- 1)type = "FastenerAssembly";

		String tempName = "__ReportDef__";
		PainterDefinition pd(tempName);
		if (!pd.bIsValid())
			pd.dbCreate();

		if (pd.bIsValid())
		{ 
			pd.setType(type);
			if (query.length()>0 && type!="ToolEnt") // HSB-21386
			{
				pd.setFilter(query);
			}
			out = pd.filterAcceptedEntities(ents);
			pd.dbErase();
		}

//		if(bDebug)
//			for (int i=0;i<out.length();i++) 
//				reportNotice("\nGetEntitiesOfType: accepting " +i + " " +out[i].typeDxfName()); 

		return out;
	}//endregion

	//region Function getFormatArgument
	// returns the formatting argument from property or mapkey/path	
	// propName: the name of the property
	// sMapKey: the submapx key
	// sMapPath: the path of the submapx
	// valueType: 0=string <default>, 1=double, 2=int
	
	String getFormatArgument(Map mapColumn, String rowType, int& alignment)//String propName, String sMapKey, String sMapPath, int nRounding, String lengthUnit, int& valueType)
	{ 
		String arg;

		Map m = mapColumn;
		String propName = m.getString("PropertyName");
		
		
		
		
 	// formatting does not resolve path Genbeam.XX
		if (rowType.find("HardwareComponent",0,false)>-1 && propName.find("GenBeam.",0, false)>-1)
			propName.replace("GenBeam.", "");		
		else if (rowType.find("Analysed",0,false)>-1 && propName.find("GenBeam.",0, false)>-1)
			propName.replace("GenBeam.", "");	


		String headerName= m.getString("DisplayName");
		String lengthUnit = m.getString("LengthUnit");
		String sortDirection = m.getString("SortDirection");
		String sMapKey = m.getString("MapKey");
		String sMapPath = m.getString("MapPath");
		String summaryType= m.getString("SummaryType");
		String summaryFunction= m.getString("SummaryFunction");
		
		int unitType = m.hasInt("UnitType")?m.getInt("UnitType"):-1;
		int sortIndex = m.getInt("SortIndex");
		int rounding = m.getInt("Rounding");				
		int bDescending = m.getString("SortDirection") == kDescending;
		int indexColumn = m.getInt("Column");

		int bByFormat = propName.find("*Format", 0, false) >- 1 && sMapKey.find("@(",0,false)>-1;
		int bByText = propName.find("*Text", 0, false) >- 1 && sMapKey.length()>0;
		int bByPosNum = (propName.find("*QtyPosNum", 0, false) >- 1  || propName.find("Qty", 0, false) >- 1 ) && sMapKey.length()<1;

	// force type of some known properties
		String sInts[] ={ "PosNum", "*Qty", "*QtyPosnum", "Amount", "Quantity", "Item.ZoneIndex", "Number"};
		String sStrings[] ={ "Coating","Name", "Material","Model", "Label", "SubLabel", "SubLabel2", "Information", "Description", "ArticleNumber", "Manufacturer","Style", "Group", 
			"Manufacturer", "Grade", "Type", "Subtype", "Definition", "HostID","Definition.Name", "Description", "Item.Name"};		
		String sDoubles[] ={ "ScaleX","ScaleY","ScaleZ", "Length", "Area", "Volume", "Perimeter", "Cubature", "Weight"};

		int bAsInt, bAsString,bAsDouble;
			
		if (bByFormat)
		{ 
			bAsDouble = lengthUnit != kUnknown;
	
			if (!bAsDouble)
			{ 
				String tokens[] = sMapKey.tokenize(".");
				String key = tokens.length() > 0 ? tokens.last() : sMapKey;
				for (int i=0;i<sInts.length();i++) 
				{ 
					if (key.find(sInts[i],0,false)>-1)
					{ 
						//reportNotice("\nkey found " + key);
						bAsInt = true;
						break;
					}
				}//next i				
			}

			bAsString = !bAsDouble && !bAsInt;
		}
		else if (bByText)
		{ 
			bAsString = true;
		}
		else if (bByPosNum)
		{ 
			bAsInt = true;
		}		
		else
		{	
			
		// purge potential pipes	
			if (propName.find("|",0, false)>-1)	
				propName.replace("|", "");
			
			bAsInt= propName.length()>0 && sInts.findNoCase(propName ,- 1) >- 1;
			bAsString = propName.length()>0 && sStrings.findNoCase(propName ,- 1) >- 1;
			bAsDouble = !bAsString && !bAsInt && (unitType >- 1 || sDoubles.findNoCase(propName ,- 1) >- 1);

		}
//reportNotice("\n"+bByFormat+" prop " + propName +"-"+sMapKey+ " " +bAsInt+bAsDouble+bAsString + " bByPosNumbb/ByText/ByFormat:"+bByPosNum+bByText+bByFormat);
		alignment = bAsString ?- 1 : (bAsDouble?1:0);

		int bAddRounding = !bAsString && !bAsInt && lengthUnit!=kUnknown && rounding>-1;
		
		String convUnit;
		if (lengthUnit!=kUnknown && !bAsString && !bAsInt)
		{ 
			if (lengthUnit=="Millimeter")
				convUnit = ":CU;mm";
			else if (lengthUnit=="Centimeter")
				convUnit = ":CU;cm";	
			else if (lengthUnit=="Meter")
				convUnit = ":CU;m";	
			else if (lengthUnit=="Feet")
				convUnit = ":CU;ft";
			else if (lengthUnit=="Inch")
				convUnit = ":CU;in";	
		}
	

		
	//Special: convert some property names
		if (propName.find("SurfaceQuality",0,false)>-1 && propName.find("StyleName",0,false)>-1)
			propName = propName.left(propName.length() - 4);
		

		if ((propName.find("SurfaceQualityBottom",0,false)==0 || propName.find("SurfaceQualityTop",0,false)==0) &&  propName.right(5).makeUpper()!="STYLE")
			propName += "Style";
		else if (propName.find("Group.Name",0,false)>-1)
		{
			int n1 = propName.find("Group.Name", 0 ,false);
			int n2 = propName.find(".", n1 ,false);
			propName = propName.left(n2)+propName.right(propName.length()-n2-1);
		}
		else if (sMapKey.find("Group.Name",0,false)>-1)
		{
			int n1 = sMapKey.find("Group.Name", 0 ,false);
			int n2 = sMapKey.find(".", n1 ,false);
			sMapKey = sMapKey.left(n2)+sMapKey.right(sMapKey.length()-n2-1);
		}
		else if (propName.find("Item.Name",0,false)==0)
			propName = "BlockName";
		else if (propName.find("Item.ZoneIndex",0,false)==0)
			propName = "ZoneIndex";			
	//Text
		if (bByText)
			arg = sMapKey;
	//PosNum
		else if (bByPosNum)
			arg = "@(*Qty:D)";			
	// TslProperty
		else if (propName.find("*TslProperty",0,-1)>-1)
		{ 
		
			arg = "@(" +sMapPath;
			if (bAddRounding)
				arg += ":RL" + rounding;			
			arg+= ":D;" + "\"" +"---"+"\"" + ")";
		}
	// format given
		else if (sMapKey.find("@(",0,false)>-1)
		{
			arg = sMapKey;
//			int nLeft = sMapKey.find("@(", 0 ,false);
//			int nRight = sMapKey.find(")", nLeft+1 ,false);
//			
			if (arg.left(1)=="'")
				arg = arg.right(arg.length() - 1);

			if (arg.find(":CU",0,false)<0 && convUnit.length()>0 && arg.right(1)==")")
			{ 
				arg = arg.left(arg.length() - 1);
				arg += convUnit + ")";
			}

			if (arg.find(":RL",0,false)<0 && bAddRounding && arg.right(1)==")")
			{ 
				arg = arg.left(arg.length() - 1);
				arg += ":RL" + rounding + ")";
			}
			
			if (arg.find(":D",0,false)<0 && arg.right(1)==")")
			{ 
				arg = arg.left(arg.length() - 1);
				arg += ":D)";
			}			
			
		}
	// property set
		else if (sMapKey.length()>0 && sMapPath.length()>0)
		{
			arg = "@(" + sMapKey + "." + sMapPath;
			arg += convUnit;
			if (bAddRounding)
				arg += ":RL" + rounding;
				
			arg+= ":D;" + "\"" +"---"+"\"" + ")";							
		}
	/// empty column
		else if (propName.length()<1)
		{ 
			arg = "    ";
		}
	// default: byProperty name
		else
		{
			arg = "@(" + propName;
			arg += convUnit;
			if (bAddRounding)
				arg += ":RL" + rounding;					
			arg+= ":D;" + "\"" +"---"+"\"" + ")";	
		}

//reportNotice("\n" +sMapKey+" " +propName+   " Column " + indexColumn+ ": " + arg + " alignment = "+ alignment);
		return arg;
	} //endregion

	//endregion 

	//region Draw Functions


//region Function DrawInvalidSymbol
	// draws the invalid / delete cross
	void DrawInvalidSymbol(PlaneProfile pp)
	{ 
		CoordSys cs = pp.coordSys();
		Vector3d vecZ = cs.vecZ();
		Point3d pt = pp.ptMid();
		double size = getViewHeight() / 30;
		Vector3d vec = cs.vecX() * size + cs.vecY() * .1 * size;
		PlaneProfile ppx; ppx.createRectangle(LineSeg(pt - vec, pt + vec), cs.vecX(), cs.vecY());
		vec = cs.vecY() * size + cs.vecX() * .1 * size;
		PlaneProfile ppy; ppy.createRectangle(LineSeg(pt - vec, pt + vec), cs.vecX(), cs.vecY());
		ppx.unionWith(ppy);
		CoordSys rot; rot.setToRotation(45, vecZ, pt);
		ppx.transformBy(rot);
	
		Display dp(-1);
		dp.trueColor(red);
		dp.draw(ppx, _kDrawFilled, 30);
		dp.draw(ppx);
		
		return;
	}//endregion


//region Function DrawCell
	// draws a cell and returns its shape
	void DrawCell(String text, PlaneProfile pp, Display displayX, Display dispBack, int color, int colorBack,int colorBorder,  int transparency, double textHeight, String dimStyle, int alignHorizontal, String dispReps[])
	{ 
		Display display(color);
		display.dimStyle(dimStyle);
		if (textHeight>0)display.textHeight(textHeight);

		double marginX = textHeight * .5;
		double marginY = textHeight;

		double dX = pp.dX();
		double dY = pp.dY();
		if (dX<dEps || dY<dEps)
			return PlaneProfile();
	
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();

		display.addHideDirection(vecX);
		display.addHideDirection(-vecX);
		display.addHideDirection(vecY);
		display.addHideDirection(-vecY);


		// trim text if extending cell width
		int numChars = text.length();
		double dXText = display.textLengthForStyle(text, dimStyle, textHeight);
		while (numChars>2 && dXText>dX-marginX)
		{ 
			numChars--;
			text = text.left(numChars);
			dXText = display.textLengthForStyle(text, dimStyle, textHeight);
		}


		Point3d ptCen = pp.ptMid();
		Point3d ptTxt = ptCen +vecX*alignHorizontal*(.5*dX-marginX);	//ptTxt.vis(6);


		String dispRepNames[] = _ThisInst.dispRepNames();
//		
//		for (int i=0;i<dispRepNames.length();i++) 
//		{ 
//			Display dp(1);
////			dp = display;
//
//
//		dp.dimStyle(dimStyle);
//		if (textHeight>0)dp.textHeight(textHeight);
//
//			dp.showInDispRep(dispRepNames[i]); 
//			dispBack.showInDispRep(dispRepNames[i]); 
//			
		if (colorBack < 256)	dispBack.color(colorBack);
		else					dispBack.trueColor(colorBack);			
		if (transparency>0)
			dispBack.draw(pp, _kDrawFilled,transparency);
		
		if (color < 256)	display.color(color);
		else				display.trueColor(color);
		display.transparency(0);
		display.draw(text, ptTxt, vecX, vecY, -alignHorizontal ,0);	
		
		if (colorBorder < 256)	display.color(colorBorder);
		else					display.trueColor(colorBorder);			
		display.draw(pp);	
		
		
		for (int i=0;i<dispReps.length();i++) 
		{ 
			Display dp2(1),dp(1);
			dp.dimStyle(dimStyle);
			if (textHeight>0)dp.textHeight(textHeight);
			dp.showInDispRep(dispReps[i]);
			dp2.showInDispRep(dispReps[i]);
			
			if (colorBack < 256)	dp2.color(colorBack);
			else					dp2.trueColor(colorBack);			
			if (transparency>0)
				dp2.draw(pp, _kDrawFilled,transparency);
			
			if (color < 256)	dp.color(color);
			else				dp.trueColor(color);
			dp.transparency(0);
			dp.draw(text, ptTxt, vecX, vecY, -alignHorizontal ,0);	
			
			if (colorBorder < 256)	dp.color(colorBorder);
			else					dp.trueColor(colorBorder);			
			dp.draw(pp);					
		}

		return;
	}//endregion

			
	//endregion 

	//region Shopdraw Functions

//region Function FindClosestView
	// returns the view with the closest origin
	MultiPageView FindClosestView(Point3d ptRef, MultiPage page, PlaneProfile& ppView)
	{ 
		ptRef.setZ(0);
		MultiPageView view,views[]=page.views();
		
		double dist = U(10e10);
		for (int i=0;i<views.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			pp.joinRing(views[i].plShape(),_kAdd); 
			Point3d pt = pp.ptMid()-.5*(_XW*pp.dX()+_YW*pp.dY()); 
			
			double d = (pt - ptRef).length();
			if (d<dist)
			{ 
				dist = d;
				view = views[i];
				ppView = pp;
			}
		}//next i
		
		return view;
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


	//endregion 

	//region Mixed Functions


//region Function GetOrderedColumnGrips
	// returns the order list of column grid locations
	Point3d[] GetOrderedColumnGripLocations(Grip grips[])
	{ 
		Point3d pts[0]; int inds[0];
		for (int i=0;i<grips.length();i++) 
		{ 
			Grip g = grips[i]; 
			String name = g.name();
			if (name.find("Column_", 0, false)>-1)
			{ 
				String tokens[] = name.tokenize("_");
				inds.append(tokens[1].atoi());
				pts.append(g.ptLoc());
			}
		}//next i	
		
	// order by column index
		for (int i=0;i<pts.length();i++) 
			for (int j=0;j<pts.length()-1-i;j++) 
				if (inds[j]>inds[j+1])
				{
					inds.swap(j, j + 1);
					pts.swap(j, j + 1);
				}

		return pts;
	}//endregion

//region Function SetSequenceColor
	// returns the sequential color if defined, else original color is used
	void SetSequenceColor(int& color, Map mapColors)
	{ 
		int colors[] = GetIntArray(mapColors, false);
		if (colors.length()>0)
		{ 
			int n=color;
			while(n>colors.length()-1)
				n-=colors.length();
			color=colors[n];			
		}				
		return;
	}//endregion
	
//region Function GetSubmapByName
	// returns a submap if name matches string called name
	Map GetSubmapByName(Map mapParent, String nameSubmap)
	{ 
		Map out;
		
		nameSubmap = nameSubmap.makeUpper();	
		for (int i=0;i<mapParent.length();i++) 
		{ 
			Map m = mapParent.getMap(i);
			String name = m.getString("name").makeUpper();
			if (name == nameSubmap)
			{ 
				out = m;
				break;
			}			 
		}//next i	
		return out;
	}//endregion

//region Function GetColumn
	// enriches the map of the column
	void GetColumnHeader(Map& mapColumn, String rowType,CoordSys cs, Map mapDisplay)
	{ 
		Map m = mapColumn;
		String propName = m.getString("PropertyName");
		String headerName= m.getString("DisplayName");
		String lengthUnit = m.getString("LengthUnit");
		String sortDirection = m.getString("SortDirection");
		String key = m.getString("MapKey");
		String path = m.getString("MapPath");
		String summaryType= m.getString("SummaryType");
		String summaryFunction= m.getString("SummaryFunction");
		
		int unitType = m.getInt("UnitType");
		int sortIndex = m.getInt("SortIndex");
		int rounding = m.getInt("Rounding");				
		int bDescending = m.getString("SortDirection") == kDescending;
		int indexColumn = m.getInt("Column");

			
		int alignment;//default center
		String ftr = getFormatArgument(m, rowType,alignment);
//		if (bDebug)
//			reportNotice("\n"+indexColumn + " "+ headerName+ " resolves with format " +ftr+ " rounding " + rounding);

		String text = headerName;// + "\n" + sPropName;
		if (text.find("|",0, false)>-1)text = T(text);
		
		PlaneProfile pp(cs);
		GetCellExtents(pp, text, mapDisplay);

	// enrich column map
		mapColumn.setInt("alignment", alignment);
		mapColumn.setDouble("dX", pp.dX());
		mapColumn.setDouble("dY", pp.dY());
		mapColumn.setString("formatToResolve", ftr);
		mapColumn.setString("text", text);
		mapColumn.setPlaneProfile("pp", pp);
		
		return;
	}//endregion

//region Function HardwareCompSummarize
	// returns
	HardWrComp[] HardwareCompSummarize(HardWrComp hwcs[], int bAddSums[])
	{ 
		bAddSums.setLength(4);
		int bAddSum;
		for (int i=0;i<bAddSums.length();i++) 
		{ 
			if (bAddSums[i])
			{
				bAddSum=true;
				break;				
			}	 
		}//next i
		
		
		
	// summarize
		HardWrComp hwcsX[0];
		String articles[0];//in synch with hwcs
		for (int i=0;i<hwcs.length();i++)  
		{ 
			HardWrComp hwc = hwcs[i]; 
			int qty = hwc.quantity();
			String article = hwc.articleNumber();
			int n = articles.findNoCase(article ,- 1);
			if (n<0 || !bAddSum)
			{
				hwcsX.append(hwc);
				articles.append(article);
			}
		// increment summarizeable fields	
			else
			{ 
				HardWrComp& hwx = hwcsX[n];
				 
				if(bAddSums[0])
					hwx.setDScaleX(hwx.dScaleX() + hwc.dScaleX()*qty);
				if(bAddSums[1])
					hwx.setDScaleY(hwx.dScaleY() + hwc.dScaleY()*qty);	
				if(bAddSums[2])
					hwx.setDScaleZ(hwx.dScaleZ() + hwc.dScaleZ()*qty);	
				if(bAddSums[3])
					hwx.setQuantity(hwx.quantity() + qty);										

			}
		}//next h	
		
		//reportNotice("\nHWC summarized " + hwcsX.length() + " articles = "  + articles.length());
		
		return hwcsX;
	}//endregion




//endregion 

	//region Dialogs
	
//region Function ShowHeaderConfigDialog
	// shows the header config dialog
	Map ShowHeaderConfigDialog(Map mapIn, Map mapColumns)
	{ 
		
	//region dialog config		
		Map rowDefinitions = mapIn.getMap(kRowDefinitions);
		int numRows = rowDefinitions.length();
		double dHeight = numRows > 5 ? 1000 : numRows * 50+150;

		Map mapDialog ;
	    Map mapDialogConfig ;
	    mapDialogConfig.setString("Title", T("|Header Descriptions|"));
	    mapDialogConfig.setDouble("Height", dHeight);
	    mapDialogConfig.setDouble("Width", 1200);
	    mapDialogConfig.setDouble("MaxHeight",1000);
	    mapDialogConfig.setDouble("MaxWidth", 3000);
	    mapDialogConfig.setDouble("MinHeight", numRows*50+120);
	    mapDialogConfig.setDouble("MinWidth", 800);
	    mapDialogConfig.setInt("AllowRowAdd", 1);
	    
	    mapDialogConfig.setString("Description", T("|Specifies additional header descriptions, format arguments are supported, i.e. @(Projectname) will resolve the corresponding hsbcad settings property. |") +
	    TN("|Multiple rows can be designated in which any empty columns will be condensed as spanning columns with the previous defined column|") +
	    TN("|The header will be positioned centrally over the spanning columns.|"));
	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);				
	//endregion 		
		
	//region Columns	
		
		Map columnDefinitions;
		for (int i=0;i<mapColumns.length();i++) 
		{ 
			Map m = mapColumns.getMap(i);
		   
			Map column;
		    column.setString(kControlTypeKey, kTextBox);
		    column.setString(kHorizontalAlignment, kStretch);
		    column.setString(kHeader,m.getString("DisplayName"));
	    	//column4.setString("ToolTip", tToolTipCriteria);   
		    columnDefinitions.setMap("Column"+i, column);
				 
		}//next i
		
		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);			
	//endregion 		


	//region Rows
	    mapDialog.setMap(kRowDefinitions, rowDefinitions);			
	//endregion 

		Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);
		
		return mapRet;
	}//endregion	
	
	
	
	
	//End Dialogs //endregion 

//END Functions //endregion 


//region Part #2

//region PreRequisites Painters and Dimstyles

	//region Painters

	String tDisabledEntry = T("<|Disabled|>");
	String tBySelection = T("<|bySelection|>");

// Get or create default painter definition
	String sPainterCollection;// = "TSL\\Raum\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sPainterCollection.length()<1 || sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid()){continue;}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)// && name!=tSelectionPainter)
				sPainters.append(name);
		}		 
	}//next i
	
//// Create Default Painters	
//	if (_bOnInsert || _bOnRecalc)
//	{ 
//		String types[] ={"Beam", "Panel"};
//		String names[] ={tPDBeams, tPDPanels};
//		String formats[] =
//		{
//			"@(SolidLength:RL0:PL5;0)_@(SolidHeight:RL0:PL5;0)", 
//			"@(SolidHeight:RL0:PL3;0)_@(SolidLength:RL0:PL5;0)_@(SolidWidth:RL0:PL5;0)"
//		};
//		for (int i=0;i<types.length();i++) 
//			createPainter(sPainters, types[i], "", formats[i], sPainterCollection, names[i]);	
//	}

	sPainters.sorted();	
	sPainters.insertAt(0, tDisabledEntry);
	//END Painters //endregion

	//region DimStyles
	// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	{ 
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$0", 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
				}
	}//endregion
		
//PreRequisites //endregion 

//region Properties
	String sSubReports[0],sReports[] = getReports();	
	String sReportName=T("|Report Definition|");	
	PropString sReport(0, sReports, sReportName);
	int bIsStaticEntry;
	if (!_bOnInsert)
	{
		Map mapReport = _Map.getMap("ReportDefinition");
		String sStoredReport = mapReport.getMapName();
		
	// append entry of stored report 	
		bIsStaticEntry= sStoredReport.length()>0 && sReports.findNoCase(sStoredReport ,- 1)<0;
		if (bIsStaticEntry)
		{
			sReports.insertAt(0, sStoredReport);
			sReport = PropString (0, sReports, sReportName);
			sReport.set(sStoredReport);
		}			
	}
	sReport.setCategory(category);

	if (bIsStaticEntry)
	{ 
		Map mapReport = _Map.getMap("ReportDefinition");
		Map mapSections = mapReport.getMap("SectionCollection[]");
		for (int i=0;i<mapSections.length();i++) 
		{ 
			Map m = mapSections.getMap(i);
			String subReport = m.getString("SheetName");
			if (subReport.length()>0 && sSubReports.findNoCase(subReport,-1)<0)
				sSubReports.append(subReport);	 
		}//next i
		
	}
	else if (!bIsStaticEntry && sReport.length()>0 && indexOfMovedGrip<0)
		sSubReports = getSubReports(sReport);
		
	String sSubReportName=T("|Sub Report|");	
	PropString sSubReport(1, sSubReports, sSubReportName);	
	sSubReport.setDescription(T("|Defines the SubReport|"));
	sSubReport.setCategory(category);
	
	if (!bIsStaticEntry && sSubReports.length()>0 && sSubReports.findNoCase(sSubReport,-1)<0)
		sSubReport.set(sSubReports.first());
	//sSubReport.setReadOnly(sSubReports.length() < 2 || bIsStaticEntry? _kHidden: true);

	String sPainterName=T("|Filter|");	
	PropString sPainter(5, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter the entities|"));
	sPainter.setCategory(category);

	String sChildPainterName=T("|Child Objects Filter|");	
	PropString sChildPainter(7, sPainters, sChildPainterName);	
	sChildPainter.setDescription(T("|Defines the painter definition which is used to selectively filter the items within the parent object container, such as the beams of an element.|"));
	sChildPainter.setCategory(category);

	String sAllowNestedName=T("|Allow selection in XRef|");	
	PropString sAllowNested(8, sNoYes, sAllowNestedName,0);	
	sAllowNested.setDescription(T("|Defines whether the selection of entities also allows entities within block references or XRefs|"));
	sAllowNested.setCategory(category);
	if (sNoYes.findNoCase(sAllowNested ,- 1) < 0) sAllowNested.set(sNoYes[0]);

category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(2, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(100), sTextHeightName,_kLength);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 0, sColorName);	
	nColor.setDescription(T("|Defines the color|, ") + T("|0 = byReference|"));
	nColor.setCategory(category);

	String tStyleDefault = T("|Default|"), tStylePattern = T("|Pattern|"), tStylePatternHighlight=  T("|Pattern + Highlight 1st column|"), tStyleHighlight=T("|Highlight 1st column|"), sStyles[] ={tStyleDefault, tStylePattern, tStylePatternHighlight, tStyleHighlight };
	String sStyleName=T("|Style|");	
	PropString sStyle(3, sStyles, sStyleName);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);

	String tABottom= T("|Bottom|"), tATop = T("|Top|"), sAlignments[] = {tABottom, tATop};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(4, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines how the table aligns to the insertion point|"));
	sAlignment.setCategory(category);
//	sAlignment.setReadOnly(_kHidden); // TODO to be reimplemented //HSB-24456


category = T("|Page Header|");
//	String sDescriptionName=T("|Description|");	
//	PropString sDescription(7, T("|Schedule Table| ")+ "@(TypeName:D)", sDescriptionName);	
//	sDescription.setDescription(T("|Defines the header of the schedule table|"));
//	sDescription.setCategory(category);
//	sDescription.setDefinesFormatting(_ThisInst);
	
	String tGrid = T("|Grid Lines|"),tHeaderMain = T("|Main Page Header|"), tHeaderAll=  T("|All Page Headers|"), tHeaderNone=T("|None|"), 
		sHeaders[] ={tHeaderMain,tHeaderAll, tHeaderNone };
	String sHeaderName=T("|Page Header|");	
	PropString sHeader(6, sHeaders, sHeaderName);	
	sHeader.setDescription(T("|Defines which headers to be shown|"));
	sHeader.setCategory(category);


	int nProps[]={nColor};			
	double dProps[]={dTextHeight};				
	String sProps[]={sReport,sSubReport, sDimStyle,sStyle,sAlignment,sPainter,sHeader,sChildPainter,sAllowNested };



//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		sSubReport.setReadOnly(_kHidden);

	// get all reports
		Map mapDefs;
		for (int i=0;i<sReports.length();i++) 
			getReportSections(sReports[i], mapDefs); 			

	// get combined report / section names
		String reports[0], sections[0]; 
		String names[] = getDefNames(mapDefs, reports, sections);

		sReport = PropString (0, names, sReportName);
		sReport.setDescription(T("|Defines the Report Definition|"));	


	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int bInBlockSpace, bHasSDV;
		
	// find out if we are block space and have some shopdraw viewports
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			entsSDV= Group().collectEntities(true, ShopDrawView(), _kMySpace);
		
		// shopdraw viewports found and no genbeams or multipages are found
			if (entsSDV.length()>0)
			{ 
				bHasSDV = true;
				Entity ents[]= Group().collectEntities(true, GenBeam(), _kMySpace);
				ents.append(Group().collectEntities(true, MultiPage(), _kMySpace));
				if (ents.length()<1)
				{ 
					bInBlockSpace = true;
				}
			}
		}
//		reportNotice("\nbInLayoutTab+bInPaperSpace+bInBlockSpace"+bInLayoutTab+bInPaperSpace+bInBlockSpace);
//		reportNotice("\nmySPace"+Group().collectEntities(true, ShopDrawView(), _kMySpace).length()
//		+"\n sdvs:"+entsSDV.length() + " modle"+ Group().collectEntities(true, ShopDrawView(), _kModelSpace).length());


	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	// identify selected subreport from combined list		
		int n = names.findNoCase(sReport ,- 1);		
		if (n >- 1 && sections.length()>n)
		{
			sReport.set(reports[n]);
			sSubReport.set(sections[n]);
		}



	//region Prompt for references
		Entity ents[0], showSet[0];
		MultiPage page;
		Section2d section; ClipVolume clipVolume;
		int bHasPage, bIsViewport, bIsHsbViewport, bHasSection;
		Element el;
		
	// Paperspace Viewport	
		if (bInLayoutTab && bInPaperSpace)
		{
			Viewport vp;
			_Viewport.append(getViewport(T("|Select a viewport|")));
			vp = _Viewport[_Viewport.length()-1]; 
			//dScale = vp.dScale();
			bIsViewport=true;			
		}
	// Model
		else
		{ 
		// prompt for entities
			PrEntity ssE;
			if (bInBlockSpace)
			{ 
				ssE = PrEntity(T("|Select shopdraw viewports|"), ShopDrawView());
			}	
			else
			{ 
				ssE = PrEntity(T("|Select entities|"), Entity());
				if (sAllowNested==sNoYes[1])
					ssE.allowNested(true);
			}						
			if (ssE.go())
				ents.append(ssE.set());		
			
		// set to block space
			if (bInBlockSpace || bHasSDV)
			{ 
				ShopDrawView sdvs[0];
				for (int i=0;i<ents.length();i++) 
				{ 
					ShopDrawView sdv= (ShopDrawView)ents[i]; 
					if (sdv.bIsValid())
					{
						_Entity.append(sdv);
						_Pt0 = getPoint();			
						_Map.setInt(kBlockSpaceMode,true);
						return;
					}	 
				}//next i
			}			
		}

	// if a multipage or an element has been selected, ignore the rest of the sset			
		for (int i=0;i<ents.length();i++) 
		{ 
			page = (MultiPage)ents[i]; 
			section = (Section2d)ents[i]; 
			if (page.bIsValid())
			{
				bHasPage = true;
				_Entity.append(page);
				break;
			}
			else if (section.bIsValid())
			{
				bHasSection = true;	
				_Entity.append(section);
				break;
			}			
			el = (Element)ents[i]; 
		}//next i		

		if (!bHasPage && !bHasSection)
		{ 
			_Entity = ents;
		}

	//endregion 

	// store copy of report definition
		Map mapReport = GetReportMapFromCompany(sReport).getMap("ReportDefinition");
		mapReport.setMapName(sReport);
		_Map.setMap("ReportDefinition", mapReport);
		_Pt0 = getPoint();
		return;
	}			
//endregion 

//region Events
	if (_bOnDbCreated)setExecutionLoops(2);	

//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbScheduleTable";
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
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
	

//region Function GetHierarchicalHeaders
	// returns a map with flattened structure of headers (if defined in settings)
	Map GetHierarchicalHeaders(String reportName, String sectionName)
	{ 
		Map out;
		
		String k;
		Map report = GetSubmapByName(mapSetting.getMap("Report[]"), reportName);
		Map section = GetSubmapByName(report, sectionName);
		Map headers = section.getMap("HierarchicalHeaders[]");

		return headers;
	}//endregion

	

//End Settings//endregion	

//EndPart #2 //endregion 


//region Part #3

//region Standards
	Map mapReport, mapSections, mapHeaders;
	if (indexOfMovedGrip<0)
	{ 
		sReport.setReadOnly(_kReadOnly);
		sReport.setDescription(T("|The name of the current report definition.|") + T("|Doubleclick to change definition|"));	
	
	// Read additional settings for current report
		Map mapReportSetting = GetSubmapByName(mapSetting.getMap("Report[]"), sReport);
		Map mapSectionSetting = GetSubmapByName(mapReportSetting, sSubReport);
		mapHeaders = mapSectionSetting.getMap("HierarchicalHeaders[]");
//		if (mapHeaders.length()>0)
//			_Map.setMap("HierarchicalHeaders[]", mapHeaders);
//		else if (_Map.hasMap("HierarchicalHeaders[]"))
//			mapHeaders = _Map.getMap("HierarchicalHeaders[]");
		
	// Get report definition	
		mapReport = _Map.getMap("ReportDefinition");		
		if (mapReport.length()<1)
		{ 
			mapReport = GetReportMapFromCompany(sReport).getMap("ReportDefinition");
			_Map.setMap("ReportDefinition", mapReport);
		}
		mapSections = mapReport.getMap("SectionCollection[]");
		if (mapSections.length()<1)
		{ 
			reportNotice("\n" + sReport + T(": |could not find any definitions|"));
			if (!bDebug)eraseInstance();
			return;
		}
		
	//region Trigger ExportReport
		String sTriggerExportReport = T("|Export Report|");
		if (bDebug)addRecalcTrigger(_kContextRoot, sTriggerExportReport );
		if (_bOnRecalc && _kExecuteKey==sTriggerExportReport)
		{
			mapReport.writeToXmlFile("c:\\temp\\report.xml");		
			setExecutionLoops(2);
			return;
		}//endregion	
	
	}



	Display dp(nColor);
	dp.dimStyle(dimStyle);
	double textHeight = dTextHeight;
	if(textHeight<0)
		textHeight = dp.textHeightForStyle("O", dimStyle);
	else
		dp.textHeight(textHeight);

	
	
	
	int bIsHsbViewport, bIsViewport = _Viewport.length()>0;
	int bAddPattern = sStyle == tStylePattern || sStyle == tStylePatternHighlight;
	int bAddHighlight = sStyle == tStylePatternHighlight || sStyle == tStyleHighlight;
	int bHeaderMain = sHeader == tHeaderMain, bHeaderAll = sHeader == tHeaderAll, bHeaderNone = sHeader == tHeaderNone;

	Vector3d vecX = bIsViewport?_XW:_XU;
	Vector3d vecY = bIsViewport?_YW:_YU;
	Vector3d vecZ = bIsViewport?_ZW:_ZU;
	
	dp.addHideDirection(vecX);
	dp.addHideDirection(-vecX);
	dp.addHideDirection(vecY);
	dp.addHideDirection(-vecY);
	
	CoordSys ms2ps, ps2ms;
	
	int nDirY = sAlignment == tABottom ? 1 :- 1;
	Vector3d vecYDir = nDirY*vecY;	
	Line lnX(_Pt0, vecX);
	if (bDebug)dp.draw(scriptName(), _Pt0, _XW, _YW, 1, nDirY*2);

	Grip grips[0]; int nColumns[0], nGripIndices[0]; double dGripColumnWidths[0];
	int bDrag= _bOnGripPointDrag && _kExecuteKey=="_Grip";


	int bCreatedByBlockspace = _Map.getInt("BlockSpaceCreated");
	if (bCreatedByBlockspace) 
	{ 
		if (_Entity.length()<1) 
			return; 
		else
		{
			_Map.removeAt("BlockSpaceCreated", true);

		}
	}
	// set grips by map
	if(_Map.hasMap("ColumnWidths"))
	{ 
		_Grip.setLength(0);
		Map m = _Map.getMap("ColumnWidths"); 
		dGripColumnWidths = GetDoubleArray(m,false);
		
		//reportNotice("colums: " + dGripColumnWidths);
		_Map.removeAt("ColumnWidths", true);		
	}

//endregion 

//region Collect showset
	int bHasSDV, bHasPage, bHasSection;

	MultiPage page = _Entity.length()>0?(MultiPage)_Entity[0]:MultiPage();
	ShopDrawView sdvs[0],sdv =_Entity.length()>0? (ShopDrawView)_Entity[0]:ShopDrawView();		
	Section2d section= _Entity.length()>0?(Section2d)_Entity[0]:Section2d(); 
	ClipVolume clip;

	
	Entity showSet[0];
	Element el;
	
	PlaneProfile ppSDVs[0];
	Entity entsAllNested[0];

// Viewport Mode
	if (bIsViewport)
	{ 
		Viewport vp= _Viewport[_Viewport.length()-1];
		el = vp.element();
		bIsHsbViewport = el.bIsValid();
		_Pt0.setZ(0);	
		ms2ps = vp.coordSys();
		
	// reset entity array on setting viewport layout
		if (bIsHsbViewport)
		{ 
			showSet.setLength(0); // remove viewport
			showSet.append(el);
		}		
	}	
	else if (_Entity.length()<1)
	{ 
		reportNotice("\n" + T("|Invalid reference.|"));
		eraseInstance();
		return;
	}
	
// Shopdraw View
	if (sdv.bIsValid())
	{ 
		bHasSDV = true;
		sdvs.append(sdv);
		ppSDVs = GetShopdrawProfiles(sdvs);		
	}
	else if (page.bIsValid())
	{ 
		//reportNotice(TN("|Starting page mode|"));

		bHasPage = true;
		setDependencyOnEntity(page);

	//region Keep Location when dragging page
		Point3d ptOrg = page.coordSys().ptOrg();
		Vector3d vecOrg = ptOrg - _PtW;		
		if (_Map.hasVector3d("vecOrg"))
		{ 
			Point3d ptPrevOrg = _Map.getVector3d("vecOrg");
			Vector3d vecPageMove = ptOrg - ptPrevOrg;
			if (!vecPageMove.bIsZeroLength())
			{ 
			// this script uses setIsRelativeToEcs(false)  by default, during the page move this needs to be deactivated
				for (int i=0;i<_Grip.length();i++) 
					_Grip[i].setIsRelativeToEcs(true); 
				_Pt0.transformBy(vecPageMove);

				_Map.setVector3d("vecOrg", vecOrg);
				setExecutionLoops(2);
				return;
			}
		}
		else
			_Map.setVector3d("vecOrg", vecOrg);			
	//endregion 		
		
		MultiPageView views[0];	
		PlaneProfile ppView;
		MultiPageView view = FindClosestView(_Pt0, page, ppView);
		if(ppView.dX()<dEps)
		{ 
			reportMessage("\n" + scriptName() + T("|Unexpected error|"));
			eraseInstance();
			return;
		}
		
		if (bDrag)// highlight linked view during drag
		{ 
			Display dp(-1);
			dp.trueColor(orange);
			dp.draw(ppView);
		}	
		

		showSet = view.showSet();
		ms2ps = view.modelToView();	
	}
	else if (section.bIsValid())
	{
		
		clip = section.clipVolume();
		bHasSection = section.bIsValid() && clip.bIsValid();
		showSet = clip.entitiesInClipVolume(sAllowNested==tYes);

	}
	else if(!bIsViewport)
		showSet = _Entity;

//region Collect and append nested items
	Entity entsNested[0];
	Map mapNestRefs; // TODO
	for (int i=0;i<showSet.length();i++) 
	{
		Entity e= showSet[i];
		String dxf = e.typeDxfName();
		MasterPanel master = (MasterPanel)e;
		ChildPanel child= (ChildPanel)e;
		MetalPartCollectionEnt ce= (MetalPartCollectionEnt)e;

		int bIsAssemblyDef = e.formatObject("@(scriptName:D)").makeUpper()==("ASSEMBLYDEFINITION");

		// HSB-24134 collect parents for each nested
		if (sPainter!=tDisabledEntry && ce.bIsValid())
		{		
			Entity nestings[0];
			addNestedEntities(e, nestings);
			
			for (int j=0;j<nestings.length();j++) 
			{ 
				String key = nestings[j].typeName()+ "_"+nestings[j].handle(); 
				Map m = mapNestRefs.getMap(key);
				Entity ents[0];
				if (mapNestRefs.hasMap(key))
					ents= m.getEntityArray("ents", "", "ent");	
				ents.append(ce);
				m.setEntityArray(ents, true, "ents", "", "ent");
				mapNestRefs.setMap(key, m);
			}//next j
			
			entsNested.append(nestings);
		}
		else if (sPainter!=tDisabledEntry || bIsAssemblyDef)
		{
			addNestedEntities(e, entsNested);
		}
			
		if (isStackTsl(e)==3 || isStackTsl(e)==2)//stackEntity or stackPack
		{ 
			TslInst t = (TslInst)e;
			addNestedEntities(e, entsNested);
		}
		else if (master.bIsValid() || child.bIsValid())
		{ 
			addNestedEntities(e, entsNested);
		}
		
	}
	
	// add potential packages from stackEntity
	for (int i=0;i<entsNested.length();i++) 
	{ 
		Entity e= entsNested[i];
		if (isStackTsl(e)==2)
			addNestedEntities(e, entsNested);
	}
	
	// add potential items from stackPack
	for (int i=0;i<entsNested.length();i++) 
	{ 
		Entity e= entsNested[i];
		if (isStackTsl(e)==1)
			addNestedEntities(e, entsNested);
	}		
	
	{ 
		Entity ents1[0], ents2[0];
		ents1 = entsNested;
		for (int j=0;j<2;j++) 
		{ 
			for (int i=0;i<ents1.length();i++) 
			{ 
				Entity e= ents1[i];
				TslInst t = (TslInst)e;
//					if (t.bIsValid() && t.scriptName().left(5).makeUpper()=="STACK")
//					{
//						addNestedEntities(e, ents2);
//					}
				if (t.bIsValid() && t.scriptName().left(5).makeUpper()=="SDR-T")//left(18).makeUpper()=="ASSEMBLYDEFINITION")
				{
					addNestedEntities(e, ents2);						
				}				
			}
			entsNested.append(ents2);
			ents1 = ents2;
			ents2.setLength(0);
		}//next j
	}
	
	showSet.append(entsNested);		
	entsAllNested.append(entsNested);	
	// HSB-21522 purge set: avoid duplicates
	{ 
		Entity temps[0];
		for (int i=0;i<showSet.length();i++) 
			if (temps.find(showSet[i])<0)
				temps.append(showSet[i]);
		showSet = temps;		
	}
	
//		if (bDebug)
//			for (int i=0;i<showSet.length();i++) 
//				reportNotice("\n"+i + " " + showSet[i].formatObject("@(ScriptName:D) @(TypeName:D)")); 
	
	
	if (sPainter!=tDisabledEntry)
	{ 
		PainterDefinition pd(sPainter);
		if (pd.bIsValid())
			showSet = pd.filterAcceptedEntities(showSet);
	}
//endregion 


//endregion 


//region Collect additional dispReps if the parent requests multiple displays
	String sDispRepNames[0];
	{ 
		String names[0];
		TslInst tsls[]  = FilterTslsByName(showSet, names);
		for (int i=0;i<tsls.length();i++) 
		{ 
			Map m  = tsls[i].map(); 
			String dispRep = m.getString("DispRep2");
			if (dispRep.length()>0 && sDispRepNames.findNoCase(dispRep,-1)<0)
				sDispRepNames.append(dispRep);
		}//next i	
	}		
//endregion 


//region Grip Management #GM

	//_Grip.setLength(0);
	Point3d ptLoc = _Pt0;	ptLoc.vis(1);
	
	int bOnDragEnd, bDragLocation,bDragEndLocation, bMoved;
	Grip grip;
	Vector3d vecOffsetApplied;
		
	if (indexOfMovedGrip>-1)
	{ 
		grip = _Grip[indexOfMovedGrip];
		vecOffsetApplied = grip.vecOffsetApplied();		
		bOnDragEnd = !_bOnGripPointDrag;	
		bDragLocation = grip.name() == "Location";
		bDragEndLocation = grip.name() == "End";
	}
	else
	{ 
		addRecalcTrigger(_kGripPointDrag, "_Grip");	
		_ThisInst.setAllowGripAtPt0(bDebug);	
		
		for (int i=0;i<_Grip.length();i++) 
			_Grip[i].setIsRelativeToEcs(false); 		
		
		
	}
	//reportNotice("\ndrags"+bDrag+bOnDragEnd+bDragLocation+bDragEndLocation);



//region Dragging Grips
	if (bDrag)
	{ 

		int ind1 = GetGripIndexByName("Location");
		Point3d ptStart = ind1 >- 1 ? _Grip[ind1].ptLoc() : _Pt0;

		int ind2 = GetGripIndexByName("End");
		Point3d ptEnd = ind2 >- 1 ? _Grip[ind2].ptLoc() : _PtW;
		
		// Drag location
		if (indexOfMovedGrip == ind1)
		{ 
			Point3d pt1 = ptStart;
			Point3d pt2 = ptEnd + vecOffsetApplied;
			PlaneProfile pp;
			pp.createRectangle(LineSeg(ptStart, pt2), vecX, vecY);
			dp.trueColor(lightblue, 50);
			dp.draw(pp, _kDrawFilled);
			return;
		}
		// Resize
		else if (indexOfMovedGrip == ind2)
		{ 
			Point3d pt1 = ptStart;
			Point3d pt2 = ptEnd - vecOffsetApplied;

			double columns[0];
			Point3d pts[] = GetOrderedColumnGripLocations(_Grip);
			for (int i=0;i<pts.length();i++) 
			{ 
				double dX = vecX.dotProduct(pts[i]-(i==0?ptStart:pts[i-1]));
				columns.append(dX);
				 
			}//next i

			double dX = abs(vecX.dotProduct(pt2 - pt1));
			double dY = abs(vecY.dotProduct(pt2 - pt1));
			double dYNew = abs(vecY.dotProduct(ptEnd - pt1));
			double dDeltaX = vecX.dotProduct(vecOffsetApplied);
			double dDeltaY = vecY.dotProduct(vecOffsetApplied);
			
			int numRow = _Map.getInt("numTotalRow");
			double rowHeight = numRow > 0 ? dYNew / numRow : 0;
			
			if ((dDeltaX<0 && abs(dDeltaX)>=dX) || (dDeltaY>=dY))
			{ 
				DrawInvalidSymbol(PlaneProfile (CoordSys(ptEnd, vecX, vecY, vecZ)));
				return;
			}
			
		// Resize Columns	
			if (vecOffsetApplied.isParallelTo(vecX))
			{ 
				dp.trueColor(darkyellow);
			}
		// Resize TextHeight	
			else if (vecOffsetApplied.isParallelTo(vecY))
			{ 
				dp.trueColor(green);
			}			
		// Resize Varia	
			else
			{ 
				dp.trueColor(lightblue);
			}

			PlaneProfile pp;
			pp.createRectangle(LineSeg(ptStart, ptEnd), vecX, vecY);
			dp.draw(pp, _kDrawFilled,80);
			
		// Draw Grid	
			double f = (dX > 0) ? dDeltaX / dX : 0;
			f += 1;

			Point3d  pta = pt1;
			for (int i = 0; i < columns.length(); i++)
			{
				double d = columns[i] * f;
				if (d < dEps) { continue; }
				pta += vecX * d;
				Point3d ptb = pta + vecY * (vecY.dotProduct(ptEnd - ptStart));	
				dp.draw(PLine(pta, ptb));
				
			}//next i
			pta = pt1;
			for (int i=0;i<numRow;i++) 
			{ 
				pta -= vecY * rowHeight;
				Point3d ptb = pta + vecX * (vecX.dotProduct(ptEnd - ptStart));
				dp.draw(PLine(pta, ptb)); 
				 
			}//next i

			
			
			return;
		}		
		
		//Column Width
		else if (grip.name().find("Column", 0, false)>-1)
		{ 
			String tokens[] = grip.name().tokenize("_");

			int nPrevious = tokens[1].atoi()-1;
			if (nPrevious>-1)
				nPrevious = GetGripIndexByName("Column_" + nPrevious);
			
			Point3d pt1 = nPrevious<0?ptLoc:_Grip[nPrevious].ptLoc();
			Point3d pt2 = grip.ptLoc();
			pt2+=vecY*vecY.dotProduct(ptEnd-pt2);
			double dx = vecX.dotProduct(pt2 - pt1);
			if (dx<=dEps)
			{ 
				dp.trueColor(red);
				PLine pl(pt1, pt1 + vecYDir * 2*textHeight);
				dp.draw(pl);
				return;
			}
			
			dp.trueColor(lightblue, 50);
		
			PlaneProfile pp;	 
			pp.createRectangle(LineSeg(pt1, pt2), vecX, vecY);
			dp.draw(pp, _kDrawFilled);
	//		
	//		setExecutionLoops(2);
			return;
		}		
	}

//endregion 

// Collect and order column grips
	

	if (_Grip.length() < 1)
	{
		{ 
			Grip g;
			g.setPtLoc(_Pt0);
			g.setVecX(vecX);
			g.setVecY(vecY);			
			g.addHideDirection(vecX);
			g.addHideDirection(vecY);			
			g.setColor(40);
			g.setShapeType(_kGSTCircle);
			g.setName("Location");
			g.setIsRelativeToEcs(false);
			g.setToolTip(T("|Moves the location of the schedule table|"));				
			_Grip.append(g); 
			g.setColor(9);
			g.setShapeType(_kGSTCircle);		
			g.setPtLoc(_Pt0+ (vecX+vecY)*textHeight);
			g.setName("End");
			g.setIsRelativeToEcs(false);
			g.setToolTip(tToolTipEnd);				
			_Grip.append(g); 			
		}		
	}
	else
	{ 
		
		for (int i = 0; i < _Grip.length(); i++)
		{
			Grip& g = _Grip[i];
			//reportNotice("\n2321 Ecs" + g.isRelativeToEcs());
			String name = g.name();
			if (name.find("Location", 0, false) == 0)
				ptLoc = g.ptLoc();
			else if (name.find("Column", 0, false) == 0)
			{
				String tokens[] = name.tokenize("_");
				int c = tokens[1].atoi();
				grips.append(g);
				nColumns.append(c);
				nGripIndices.append(i);
				dGripColumnWidths.append(textHeight*10);
			}
		}

	// order by column index
		for (int i=0;i<grips.length();i++) 
			for (int j=0;j<grips.length()-1-i;j++) 
				if (nColumns[j]>nColumns[j+1])
				{	
					grips.swap(j, j + 1);
					nColumns.swap(j, j + 1);
					nGripIndices.swap(j, j + 1);
					dGripColumnWidths.swap(j, j + 1);
				}

		if (!bOnDragEnd && !bDrag)
			for (int i=0;i<grips.length();i++) 
			{ 
				Grip& g = grips[i];
				int c = nColumns[i];
				int n = nGripIndices[i];
				Point3d pt = lnX.closestPointTo(g.ptLoc());
				Point3d ptPrev = (i == 0 ? _Pt0 : grips[i - 1].ptLoc());
				double dx = vecX.dotProduct(pt - ptPrev);
				if (dx<dEps)
				{ 
					pt = ptPrev + vecYDir * (i + 1) * textHeight / 8;	pt.vis(i);
					dx = 0;
				}
	
				dGripColumnWidths[i] = dx;
				if (_Grip.length()>n)
				{
					_Grip[n].setPtLoc(pt);
					_Grip[n].setColor(dx<=0?253:4);
					g.setPtLoc(pt);
				}
			}//next i

	}	


	if (bOnDragEnd)
	{
		Grip g = grip;
		String name = g.name();
		if (bDragLocation)
		{
			for (int i=0;i<_Grip.length();i++) 
				if (_Grip[i].name().find("Column",0,false)>-1)
					_Grip[i].setIsRelativeToEcs(true);	
			_Pt0.transformBy(g.ptLoc()- _Pt0);
		}
		else if (bDragEndLocation)
		{
			int ind1 = GetGripIndexByName("Location");
			Point3d ptStart = ind1 >- 1 ? _Grip[ind1].ptLoc() : _Pt0;			
			Point3d ptEnd = g.ptLoc();
			
			Point3d pt1 = ptStart;
			Point3d pt2 = ptEnd - vecOffsetApplied;

			double dX = abs(vecX.dotProduct(pt2 - pt1));
			double dY = abs(vecY.dotProduct(pt2 - pt1));
			double dYNew = abs(vecY.dotProduct(ptEnd - pt1));
			double dDeltaX = vecX.dotProduct(vecOffsetApplied);
			double dDeltaY = vecY.dotProduct(vecOffsetApplied);


			double fx = (dX > 0) ? dDeltaX / dX : 0;
			fx += 1;

			double fy = (dY > 0) ? -dDeltaY / dY : 0;
			fy += 1;

			double columns[0];
			Point3d pts[] = GetOrderedColumnGripLocations(_Grip);
			for (int i=0;i<pts.length();i++) 
			{ 
				double dX = vecX.dotProduct(pts[i]-(i==0?ptStart:pts[i-1]))*fx;
				columns.append(dX);
				 
			}//next i
			Map mapColumnWidths = SetDoubleArray(columns, "");
			


		// Resize Columns	
			if (vecOffsetApplied.isParallelTo(vecX))
			{ 
				_Map.setMap("ColumnWidths",mapColumnWidths); 
			}
		// Resize TextHeight	
			else if (vecOffsetApplied.isParallelTo(vecY))
			{ 
				dTextHeight.set(dTextHeight * fy);
			}			
		// Resize Varia	
			else
			{ 
				_Map.setMap("ColumnWidths",mapColumnWidths); 
				dTextHeight.set(dTextHeight * fy);
			}			
			
			
//			for (int i=0;i<_Grip.length();i++) 
//				_Grip[i].setIsRelativeToEcs(true);	
//			_Pt0 += vecOffsetApplied;
		}		
		else if (name.find("Column",0,false)>-1 && vecOffsetApplied.dotProduct(vecX)>0)
		{ 
			String tokens[] = name.tokenize("_");

			int this = tokens[1].atoi();
			for (int i=this+1;i<grips.length();i++) 
			{
				int n = nGripIndices[i];
				_Grip[n].setPtLoc(_Grip[n].ptLoc()+vecOffsetApplied);
			}
		}
	
			
		setExecutionLoops(2);
		return;
	}
	
	
	
	
	
//End Grip Management #GM //endregion 


	int bCreateSubReport = !bDebug && sSubReport == tAll && _kExecutionLoopCount==1;
	String sHeaderText;// = sDescription;
	double dYHeader = dp.textHeightForStyle(sHeaderText, dimStyle, textHeight) + textHeight;	
	Point3d ptx = ptLoc; // offset by headerheight

	Map mapDisplay;
	mapDisplay.setString("dimStyle", dimStyle);
	mapDisplay.setDouble("textHeight", textHeight);
	mapDisplay.setInt("color", nColor);
	mapDisplay.setVector3d("vecX", vecX);
	mapDisplay.setVector3d("vecY", vecY);
	mapDisplay.setVector3d("vecZ", vecZ);
	mapDisplay.setInt("AddPattern", bAddPattern);
	mapDisplay.setInt("AddHighlight", bAddHighlight);
	mapDisplay.setInt("HeaderMain", bHeaderMain);
	mapDisplay.setInt("HasSDV", bHasSDV);
	mapDisplay.setMap("DispRep[]", SetStringArray(sDispRepNames, "") );
	mapDisplay.setMap("columnWidth[]", SetDoubleArray(dGripColumnWidths, "Width") );
	
//region Functions 2

//region Function DrawRow #DR
	// returns and draws the cells of a row
	// ptx: location of row
	// 
	Map DrawRow(Map mapRow, Map mapDisplay, Point3d& ptx, double& dColumnWidths[], int& rowIndex, int bAsHeader,
		int bDoDrawing)
	{ 
		if (bDebug)reportNotice("\nDraw row " +rowIndex + " in level " + mapRow.getInt("Level"));

		Vector3d vecX = mapDisplay.getVector3d("vecX");
		Vector3d vecY = mapDisplay.getVector3d("vecY");
//		int nColor = mapDisplay.getInt("color");
//		int bAddHighlight = mapDisplay.getInt("AddHighlight");
//		int bAddPattern = mapDisplay.getInt("AddPattern");
//		int bHasSDV = mapDisplay.getInt("HasSDV");
//		String textHeight = mapDisplay.getDouble("textHeight");
//		String dimStyle = mapDisplay.getString("dimStyle");
//		String sDispRepNames[] = GetStringArray(mapDisplay.getMap("DispRep[]", false);
//		Display dp(nColor);
		// HSB-24456
		// bDoDrawing -> flag to indicate whether it should do drawing or only run without drawing
		
		int bSetColumnsWidth = dColumnWidths.length() < 1;

		double rowHeight = mapRow.getDouble("rowHeight");
		Entity e = mapRow.getEntity("ent");
		int qty = mapRow.hasInt("*Qty") ? mapRow.getInt("*Qty") : 1;
		Map mapRowData = mapRow.getMap("RowData");
		Map cells = mapRow.getMap("Cell[]");
		
		// HSB-23126
		int bHasContent=bAsHeader;
		String sCellTexts[cells.length()];
		for (int i=0;i<cells.length();i++) 
		{ 
			Map cell = cells.getMap(i);
			String text = cell.getString("text");
			
			Map mapNotes; // will become the map of the hardwareComp once HSB-22781 is solved
			if (mapRowData.length()>0)
			{
				text = _ThisInst.formatObject(cell.getString("formatToResolve"),mapRowData);
				
				int bHasDxContent = mapNotes.setDxContent(_ThisInst.formatObject("@(Notes:D)",mapRowData), true);
				
				
				
			}
			else if (e.bIsValid())
			{
				Map mapAdd;
				mapAdd.setInt("*Qty", qty);
			
				BlockRef bref = (BlockRef)e;
				if (e.bIsKindOf(Element()))
				{ 
					Element el = (Element)e;
					LineSeg seg = el.segmentMinMax();
					mapAdd.setDouble("BoundingLength", el.vecX().dotProduct(seg.ptEnd() - seg.ptStart()));
					mapAdd.setDouble("BoundingWidth", el.vecZ().dotProduct(seg.ptEnd() - seg.ptStart()));
					mapAdd.setDouble("BoundingHeight", el.vecY().dotProduct(seg.ptEnd() - seg.ptStart()));
					
					mapAdd.setString("Number", el.number());
					mapAdd.setString("Information", el.information());
				}
				else if (e.bIsKindOf(FastenerAssemblyEnt()))
				{ 
					FastenerAssemblyEnt fae = (FastenerAssemblyEnt)e;
					FastenerAssemblyDef fad(fae.definition());
					FastenerSimpleComponent fsc = fad.mainComponent(fae.articleNumber()); 
					FastenerArticleData articleData = fsc.articleData();
					mapAdd.setDouble("ThreadLength", articleData.threadLength());
					mapAdd.setDouble("fastenerLength", articleData.fastenerLength());
					mapAdd.setDouble("minProjectionLength", articleData.minProjectionLength());
					mapAdd.setDouble("maxProjectionLength", articleData.maxProjectionLength());
		
					
					FastenerComponentData componentData = fsc.componentData();
					mapAdd.setString("material", componentData.material());
					mapAdd.setString("category", componentData.category());
					mapAdd.setString("coating", componentData.coating());
					mapAdd.setString("norm", componentData.norm());
					mapAdd.setString("grade", componentData.grade());
					mapAdd.setString("type", componentData.type());
					mapAdd.setString("subType", componentData.subType());
					mapAdd.setString("model", componentData.model());
					mapAdd.setString("manufacturer", componentData.manufacturer());
					
					mapAdd.setDouble("mainDiameter", componentData.mainDiameter(),_kLength);
					mapAdd.setDouble("sinkDiameter", componentData.sinkDiameter(),_kLength);
					
				}				
				else if (e.bIsKindOf(TslInst()))
				{ 
					TslInst t = (TslInst)e;
					mapAdd.setString("ModelDescription", t.modelDescription());
					mapAdd.setString("Model", t.modelDescription());
					mapAdd.setString("PosNum", t.posnum());
				}
				else if (bref.bIsValid())
				{ 
					mapAdd.setString("Definition", bref.definition());
					mapAdd.setString("ZoneIndex", bref.myZoneIndex());
				}
				text = e.formatObject(cell.getString("formatToResolve"),mapAdd);
			}
			
			text = text.trimLeft().trimRight();
			sCellTexts[i] = text;
			if (text.length()>0)
			{
				bHasContent = true;
			}
		}
		
		if (bDebug)reportNotice("\nrowIndex:"+rowIndex);


		if (bHasContent)//HSB-23136
		{ 
			rowIndex++;
			if (bDebug)reportNotice("...ok");
			for (int i=0;i<cells.length();i++) 
			{ 					
				Map cell = cells.getMap(i);
				
				if (bSetColumnsWidth)
					dColumnWidths.append(cell.getDouble("dX"));
				
				int alignment = bAsHeader?0:cell.getInt("alignmment"); 
				int columnIndex = cell.getInt("columnIndex"); 
				String text = sCellTexts[i];//cell.getString("text");
				
				int textColor= nColor == -2 ? e.color() : nColor;
				int borderColor= nColor == -2 ? e.color() : nColor;
				int fillColor = 0;
				int nTransparencyFill= 0;			
				
				Map mapNotes; // will become the map of the hardwareComp once HSB-22781 is solved
				if (mapRowData.length()>0)
				{
					int bHasDxContent = mapNotes.setDxContent(_ThisInst.formatObject("@(Notes:D)",mapRowData), true);
//
//					String k;
//					k = "ColorIndex"; 	if (mapNotes.hasInt(k))cell.setInt(k,mapNotes.getInt(k)); 
//					k = "Transparency"; if (mapNotes.hasInt(k))cell.setInt(k,mapNotes.getInt(k));	


				}

				
				double columnWidth = columnIndex>dColumnWidths.length()-1?U(500):dColumnWidths[columnIndex];
				PlaneProfile pp;
				pp.createRectangle(LineSeg(ptx, ptx + vecX * columnWidth - vecY * rowHeight), vecX, vecY);
				//pp.vis(2);

				if (bAddHighlight && columnIndex==0)
				{ 
	
				// byCellMap
					if (cell.hasInt("ColorIndex"))
					{ 
						fillColor = cell.getInt("ColorIndex"); // 0 if it hasn't the entry
						nTransparencyFill= cell.hasInt("Transparency")?cell.getInt("Transparency"):(fillColor>0?30:0); 							
					}
				// byEntity	
					else if (e.bIsValid())
					{ 
						int c = e.color();
						TslInst t = (TslInst)e;
						Element el = (Element)e;
						Opening op = (Opening)e;
						
					// get color of stack tsl	
						if (isStackTsl(e)>0)
						{
							Map m = t.map();
							c=m.hasInt("color")?m.getInt("color"):e.color();
						}
					// use color of linked reference	
						else if (e.subMapX("DataLink").length()>0)
						{ 
							if (e.subMapX("DataLink").getEntity("StackPack").bIsValid())
								c=e.formatObject("@(DataLink.StackPack.ColorIndex:D)").atoi();
							else if (e.subMapX("DataLink").getEntity("StackItem").bIsValid())
								c=e.formatObject("@(DataLink.StackItem.ColorIndex:D)").atoi();				
							else if (e.subMapX("DataLink").getEntity("StackEntity").bIsValid())
								c=e.formatObject("@(DataLink.StackEntity.ColorIndex:D)").atoi();						
						}
						else if (el.bIsValid())
							c = 4;
						else if (op.bIsValid())
							c = 150;
						else if (t.bIsValid())//HSB-22560
						{ 
							if (t.modelDescription().length()==1)
							{ 
								String desc = t.modelDescription().makeUpper();
								char ch = desc.getAt(0);
								c = ch - 'A';							
							}
							
						// Try getting sequential color definition by scriptName entry in dictionary	
							String kTagSeqColor="Tag\\SequentialColor[]";
							String entry = bDebug?"GenericHanger":t.scriptName();
							MapObject mo("hsbTSL" ,entry);
							Map map = mo.map();
							Map mapColors = map.getMap(kTagSeqColor);
							SetSequenceColor(c, mapColors);	// zero based, keep current if not found
						}
						if (c > 0)
						{
							fillColor = c;
							nTransparencyFill = 30;
							
							if (fillColor == 7 || fillColor == 255)
								textColor=250;
							else 
								textColor=7;
						}							
					}
	
				// byNotesMap until HSB-22781 is solved
					else if (mapNotes.length()>0)
					{ 
	
						String k;
						k = "ColorIndex"; 
						if (mapNotes.hasInt(k)) fillColor=mapNotes.getInt(k);
						else if (mapNotes.hasString(k)) fillColor=mapNotes.getString(k).atoi();
						k = "Transparency"; 
						if (mapNotes.hasInt(k)) nTransparencyFill=mapNotes.getInt(k);	
						else if (mapNotes.hasString(k)) nTransparencyFill=mapNotes.getString(k).atoi();
					}
				}
				else if (bAddPattern && rowIndex>0 && rowIndex%2==0)
				{ 
					fillColor = lightblue;
					nTransparencyFill = 60;
				}
				if(bDoDrawing)
				{
					// HSB-24456
					DrawCell(text, pp, dp, dpBackGround, textColor, fillColor,borderColor, nTransparencyFill,  textHeight, dimStyle, alignment, sDispRepNames);
				}
				
				cell.setString("text", text);
				cells.appendMap("cell", cell);
				cells.swapLastWith(i);
				cells.removeAt(cells.length() - 1, true);
	
				
				// HSB-21702
				if(bHasSDV)
					if(text.find("@",-1,false)>-1)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|Invalid data found in shopdraw, instance will be deleted|"));
						eraseInstance();
						return;
					}
				ptx += vecX*pp.dX();
			}//next i
	
			
//			rowIndex++; //TODO
			ptx += vecX*vecX.dotProduct(ptLoc - ptx) - vecY * rowHeight; 			
		}
//		else
//		{
//			rowIndex--;
//		}
	
		return cells;
	}//endregion

	
//region Function GetTypeOfRow
	// returns the type of the row
	void GetTypeOfRow(Map rowDefinition)
	{ 		
		String rowType = rowDefinition.getString("Type");
		{ 
			String tokens[] = rowType.tokenize(".");
			rowType = tokens.length() > 0 ? tokens.last() : rowType;
		}		
		return rowType;
	}//endregion

//region Function GetRowDef
	// collects the row of definition
	Map GetRowDef(Map rowDefinition, Map mapDisplay, Point3d& ptRow, int& rowIndex, Entity showSet[], int bDrawHeader, int bIsSetup,
		int bDoDrawing)
	{ 
		Vector3d vecX = mapDisplay.getVector3d("vecX");
		Vector3d vecY = mapDisplay.getVector3d("vecY");
		Vector3d vecZ = mapDisplay.getVector3d("vecZ");
		CoordSys csRow (ptRow, vecX, vecY, vecZ);

		String rowName = rowDefinition.getString("Name");
		String query = rowDefinition.getString("Query");
		Map columns = rowDefinition.getMap("Columns[]");
		String rowType = GetTypeOfRow(rowDefinition);
		Entity ents[] = GetEntitiesOfType(showSet, rowType, query);

		//reportNotice("\nGetRowDef: rowName: " + rowName+ " query: "+query+ " rowType: "+rowType +" showset/ents: "+showSet.length()+"/"+ents.length() + " bIsSetup:"+bIsSetup);
		if (ents.length()<1 && !bIsSetup)
		{
			return Map();
		}

		// HSB-24456
		// bDoDrawing -> flag to indicate whether it should do drawing or only run without drawing

	//region Collect columns
		Map mapCells;
		double rowHeight;
		double colWidths[0];
		
	// list of sorting properties	
		String sSortingArgs[0];
		int bSortingDescendings[0];
		int nSortingIndices[0];		
		
	// list of summarize columns
		int nSummarizeTypeColumns[0];
		int nSummarizeFunctionColumns[0];
		
	// lists of formatting argument and width per column	
		String ftrs[0]; 		
		
		for (int i = 0; i < columns.length(); i++)
		{
			Map m = columns.getMap(i);
			
			GetColumnHeader(m, rowType, csRow, mapDisplay);
			columns.appendMap("Column", m);
			columns.swapLastWith(i);
			columns.removeAt(columns.length() - 1, true);
			
			String ftr = m.getString("formatToResolve");
			ftrs.append(ftr);			
			int nSortIndex = m.getInt("SortIndex");
			if (nSortIndex>-1)
			{ 
				nSortingIndices.append(nSortIndex);
				bSortingDescendings.append(m.getString("SortDirection") == kDescending);
				sSortingArgs.append(ftr);
			}

			if (m.getString("SummaryType").makeUpper()=="SUM")
				nSummarizeTypeColumns.append(i);
			if (m.getString("SummaryFunction").makeUpper()=="SUM")
				nSummarizeFunctionColumns.append(i);			

			
			PlaneProfile pp = m.getPlaneProfile("pp");
			double dX = pp.dX();
			double dY = pp.dY();	
			rowHeight = rowHeight < dY ? dY:rowHeight;	
			colWidths.append(dX);
			
			Map mapCell=m;
			mapCell.setInt("columnIndex", i);
			mapCell.setInt("alignmment", m.getInt("alignment"));
			mapCell.setDouble("dX", dX);
			mapCell.setDouble("dY", dY);
			mapCell.setString("text", m.getString("text"));
			mapCell.setMapName(i);
			mapCells.appendMap("Cell", mapCell);	
		}// next i column			
	//endregion 

		Map mapRow = rowDefinition;
		mapRow.setEntityArray(ents, true, "ent[]", "", "ent");
		mapRow.appendMap("ColumnWidth[]", SetDoubleArray(colWidths, "Width") );
		mapRow.appendMap("formatToResolve[]", SetStringArray(ftrs, "ftr") );
		mapRow.appendMap("sortingArgs[]", SetStringArray(sSortingArgs, "ftr") );
		mapRow.appendMap("sortingDescending[]", SetIntArray(bSortingDescendings, "ftr") );
		mapRow.appendMap("sortingIndex[]", SetIntArray(nSortingIndices, "ftr") );
		mapRow.appendMap("summaryTypeIndex[]", SetIntArray(nSummarizeTypeColumns, "summaryTypeIndex") );
		mapRow.appendMap("summaryFunctionIndex[]", SetIntArray(nSummarizeFunctionColumns, "summaryFunctionIndex") );
		
		mapRow.setDouble("RowHeight", rowHeight);
		mapRow.setMap("Cell[]", mapCells);

		if (bDrawHeader)
		{ 
			//rowIndex++;//TODO XX
			double gripColumnWidths[] = GetDoubleArray(mapDisplay.getMap("columnWidth[]"), false);
			Map cells=DrawRow(mapRow, mapDisplay, ptRow, gripColumnWidths, rowIndex, true,bDoDrawing);	
			
			int RowHasContent = RowHasContent(cells);
			
			if (dGripColumnWidths.length()<1 && bIsSetup)//HSB-23136
				dGripColumnWidths = gripColumnWidths;
		}

		//ptRow-=vecY * rowHeight; 

		return mapRow;
	}//endregion

//region Function DrawSummaryRow
	// draws a row with summary values
	void DrawSummaryRow(Map mapRow, Map mapDisplay, double dSummaries[], double dColumnWidths[], Point3d& ptx,
		int bDoDrawing)
	{ 
		Point3d pt1 = ptx;
		
		Vector3d vecX = mapDisplay.getVector3d("vecX");
		Vector3d vecY = mapDisplay.getVector3d("vecY");
	
		int textColor = mapDisplay.getInt("color");
		int fillColor, borderColor, nTransparencyFill,alignment=1;
	
		Display dpx(textColor);//);
		dpx.addHideDirection(vecX);
		dpx.addHideDirection(-vecX);
		dpx.addHideDirection(vecY);
		dpx.addHideDirection(-vecY);
//		
		dpx.dimStyle(mapDisplay.getString("dimStyle"));
		dpx.textHeight(mapDisplay.getDouble("textHeight"));
		
		// HSB-24456
		// bDoDrawing -> flag to indicate whether it should do drawing or only run without drawing
		
		int nSummaryFunctions[] = GetIntArray(mapRow.getMap("summaryFunctionIndex[]"), false);

		double rowHeight = mapRow.getDouble("rowHeight");
		Map cells = mapRow.getMap("Cell[]");
		for (int i=0;i<dColumnWidths.length();i++) 
		{ 
			Map cell = cells.getMap(i);
			if (cell.hasInt("alignment"))alignment=cell.getInt("alignment");
			
			
			String text;
			int n = nSummaryFunctions.find(i);
//			if (n>-1 && dSummaries.length()>n)
			if (n>-1)
			{
				text = dSummaries[n];				
				PlaneProfile pp; pp.createRectangle(LineSeg(ptx, ptx + vecX * dColumnWidths[i] - vecY * rowHeight), vecX, vecY);
				if(bDoDrawing)
				{
					DrawCell(text, pp, dp, dpBackGround, textColor, fillColor,borderColor, nTransparencyFill,  textHeight, dimStyle, alignment, sDispRepNames);					
				}
			}
			ptx += vecX * dColumnWidths[i];
		}//next i
		
		Point3d pt2 = ptx- vecY * rowHeight;
		
		// draw bounding box
		PlaneProfile pp; 
		pp.createRectangle(LineSeg(pt1, pt2), vecX, vecY);			
		if(bDoDrawing)
		{
			// HSB-24456
			DrawCell("", pp, dp, dpBackGround, textColor, fillColor,borderColor, nTransparencyFill,  textHeight, dimStyle, alignment, sDispRepNames);
		}

		ptx += vecX*vecX.dotProduct(ptLoc - ptx) - vecY * rowHeight; 
		
		return;
	}//endregion

//region Function GetCellByColumn
	// returns a cell of the corresponding column
	Map GetCellByColumn(Map cells, int column)
	{ 
		Map cell;
		for (int i=0;i<cells.length();i++) 
		{ 
			Map m = cells.getMap(i);
			int n = m.getInt("columnIndex");
			if (n==column)
				cell = m;	
			 
		}//next i
		
		return cell;
	}//endregion

//region Function CollectSums
	// sums the cell value to the corresponding entry
	void CollectSums(Map cells, int columns[], double& summaries[])
	{ 
		summaries.setLength(columns.length());
		for (int i=0;i<columns.length();i++) 
		{ 
			int n = columns[i];			
			Map cell = GetCellByColumn(cells, n);
			double d = cell.getString("text").atof(); 
			summaries[i] += d;
		}//next j3			

		return;
	}//endregion

//region Function CollectChildEntities
	// returns the child entities of the parent. entities will be filtered if painter matches childType
	Entity[] CollectChildEntities(Entity parent, String childType, String painter)
	{ 
		Entity out[0];		
		PainterDefinition pd(painter);
		int bByPainter = pd.bIsValid();// && pd.type()==childType;


		Element el = (Element)parent;
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)parent;
		MetalPartCollectionDef cd = ce.bIsValid() ? ce.definition() : MetalPartCollectionDef();
		MasterPanel master = (MasterPanel)parent;
		TslInst tsl = (TslInst)parent;

	// Collect child entities and append later by cast
		Entity entsC[0]; entsC = cd.bIsValid()?cd.entity():(tsl.bIsValid()?tsl.entity():entsC);
		

	// Beam: Element, CollectionEntity, TslInst
		if (childType.find("Beam",0,false)>-1)
		{ 
			Beam ents[0];	ents = el.bIsValid() ? el.beam() : (cd.bIsValid()?cd.beam():(tsl.bIsValid()?tsl.beam():ents));			
			// append if added dto entity array of parent
			for (int i=0;i<entsC.length();i++) 
			{
				Beam e = (Beam)entsC[i];
				if (e.bIsValid() && ents.find(e)<0)
					ents.append(e); 
			}
					

			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				if (!ents[i].bIsDummy())
					out.append(ents[i]); 	
		}
	// Sheet: Element, CollectionEntity, TslInst
		else if (childType.find("Sheet",0,false)>-1)
		{ 
			Sheet ents[0];	ents = el.bIsValid() ? el.sheet() : (cd.bIsValid()?cd.sheet():(tsl.bIsValid()?tsl.sheet():ents));
			// append if added dto entity array of parent
			for (int i=0;i<entsC.length();i++) 
			{
				Sheet e = (Sheet)entsC[i];
				if (e.bIsValid() && ents.find(e)<0)
					ents.append(e); 
			}		
			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				if (!ents[i].bIsDummy())
					out.append(ents[i]); 	
		}			
	// Panel: Element, CollectionEntity, MasterPanel, TslInst
		else if (childType.find("Panel",0,false)>-1 || childType.find("Sip",0,false)>-1)
		{ 
			Sip ents[0];	
			if (master.bIsValid())
			{ 
				ChildPanel childs[] = master.nestedChildPanels();
				for (int i=0;i<childs.length();i++) 
					ents.append(childs[i].sipEntity()); 				
			}
			else
			{ 
				ents = el.bIsValid() ? el.sip() : (cd.bIsValid()?cd.sip():(tsl.bIsValid()?tsl.sip():ents));
				// append if added dto entity array of parent
				for (int i=0;i<entsC.length();i++) 
				{
					Sip e = (Sip)entsC[i];
					if (e.bIsValid() && ents.find(e)<0)
						ents.append(e); 
				}			
			}
					
			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				if (!ents[i].bIsDummy())
					out.append(ents[i]); 	
		}	
	// GenBeam: Element, CollectionEntity
		else if (childType.find("Genbeam",0,false)>-1)
		{ 
			GenBeam ents[0];	ents = el.bIsValid() ? el.genBeam() : (cd.bIsValid()?cd.genBeam():ents);
			// append if added dto entity array of parent
			for (int i=0;i<entsC.length();i++) 
			{
				GenBeam e = (GenBeam)entsC[i];
				if (e.bIsValid() && ents.find(e)<0)
					ents.append(e); 
			}			
			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				if (!ents[i].bIsDummy())
					out.append(ents[i]); 	
		}			
	// Opening: Element
		else if (childType.find("Opening",0,false)>-1)
		{ 
			Opening ents[0];	ents = el.bIsValid() ? el.opening():ents;
			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				out.append(ents[i]); 	
		}			
	// TSL: Element, CollectionEntity
		else if (childType.find("TslInst",0,false)>-1)
		{ 
			TslInst ents[0];	ents = el.bIsValid() ? el.tslInst() : (cd.bIsValid()?cd.tslInst():ents);
			// append if added dto entity array of parent
			for (int i=0;i<entsC.length();i++) 
			{
				TslInst e = (TslInst)entsC[i];
				if (e.bIsValid() && ents.find(e)<0)
					ents.append(e); 
			}		
			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				out.append(ents[i]); 	
		}								
	// Entity: CollectionEntity, TslInst
		else if (childType.find("Entity",0,false)>-1)
		{ 
			Entity ents[] = entsC;//cd.bIsValid()?cd.entity():(tsl.bIsValid()?tsl.entity():ents);
			if(bByPainter)
				ents = pd.filterAcceptedEntities(ents);	
			for (int i=0;i<ents.length();i++) 
				out.append(ents[i]); 	
		}

		//reportNotice("\nCollectChildEntities: " + out.length() + " collected");
		return out;
	}//endregion

//region Function CollectRowContent
	// collects the content of a row and draws it
	void CollectRowContent(Map mapIn, int& numRows, double& dSummaries[], int nQtyParent,
		int bDoDrawing)
	{ 
		
		Map mapRow=mapIn.getMap("row");
		Map mapDisplay=mapIn.getMap("display");
		Map mapNestRefs=mapIn.getMap("nestingRef");
		
		String sSortingArgs[] = GetStringArray(mapRow.getMap("sortingArgs[]"), false);
		int bSortingDescendings[] = GetIntArray(mapRow.getMap("sortingDescending[]"), false);
		int nSortingIndices[] = GetIntArray(mapRow.getMap("sortingIndex[]"), false);		
		
		String ftrs[] = GetStringArray(mapRow.getMap("formatToResolve[]"), false);
		int nSummaryFunctionIndices[] = GetIntArray(mapRow.getMap("summaryFunctionIndex[]"), false);
		int nSummaryTypes[] = GetIntArray(mapRow.getMap("summaryTypeIndex[]"), false);
		
		int level = mapRow.getInt("Level");
		String rowType = GetTypeOfRow(mapRow);
		int bTypeOfHardware = rowType.find("HardwareComp", 0, false) >- 1;
		int bTypeOfTool = rowType.find("Analysed", 0, false) >- 1;
		int bTypeOfElement = rowType.find("Element", 0, false) >- 1;

		Entity ents[] = mapRow.getEntityArray("ent[]","", "ent");
		int quantities[] = OrderQuantifyEntities(ents, mapIn, sSortingArgs, bSortingDescendings, nSortingIndices);

	//region Query
		// supporting simple queries: isEqual isNotEqual
		String query = mapRow.getString("Query");
		String delimiter; int nModeOperator;
		if (query.find("!=", 0, false) >- 1){delimiter = "!=";nModeOperator=2;}
		else if (query.find("=", 0, false) >- 1){delimiter = "="; nModeOperator=1;}
		String sQueryKey, sQueryValue;
		String tokens[] = query.tokenize(delimiter);
		if (tokens.length()==2)
		{ 
			sQueryKey = tokens.first().trimLeft().trimRight();
			sQueryValue = tokens.last().trimLeft().trimRight().makeUpper();
			sQueryValue.replace("'", "");
		}			
	//endregion 

		// HSB-24456
		// bDoDrawing -> flag to indicate whether it should do drawing or only run without drawing
		
	//region Hardware
		if (bTypeOfHardware)
		{ 
			
		 	int bAddSums[4];
			for (int f=0;f<ftrs.length();f++) 
			{ 
				if (ftrs[f].find("ScaleX",0, false)>-1 && nSummaryTypes.find(f)>-1)
					bAddSums[0] = true;
				if (ftrs[f].find("ScaleY",0, false)>-1 && nSummaryTypes.find(f)>-1)
					bAddSums[1] = true;	 
				if (ftrs[f].find("ScaleZ",0, false)>-1 && nSummaryTypes.find(f)>-1)
					bAddSums[2] = true;
				if (ftrs[f].find("Quantity",0, false)>-1 && nSummaryTypes.find(f)>-1)
					bAddSums[3] = true; 							
			}//next f			
			
		// Collect all hardware
			HardWrComp hwcs[0];
			for (int i = 0; i < ents.length(); i++)
			{
				ToolEnt tent = (ToolEnt)ents[i];
				if (tent.bIsValid())
					hwcs.append(tent.hardWrComps());
			}
			
		// Remove by Query
			if (sQueryKey.length()>0 && sQueryValue.length()>0)
				for (int i=hwcs.length()-1; i>=0 ; i--) 
				{ 
					HardWrComp& hwc=hwcs[i]; 
					Map m = HardWrCompToMap(hwc);
					
					String keys[] = GetMapKeys(m);
					int n = keys.findNoCase(sQueryKey ,- 1);
					if (n>-1)
					{ 
						String value = m.getString(keys[n]).trimLeft().trimRight().makeUpper();
						if (value==sQueryValue && nModeOperator==2)
							hwcs.removeAt(i);
						if (value!=sQueryValue && nModeOperator==1)
							hwcs.removeAt(i);		
					}
					else
						hwcs.removeAt(i);
				}//next i
			
		// Summarize
			if (bAddSums[0]+bAddSums[1]+bAddSums[2]+bAddSums[3]>0)
			{ 
				hwcs=HardwareCompSummarize(hwcs, bAddSums);	
			}
			
			for (int i=0;i<hwcs.length();i++) 
			{ 
				Map m = HardWrCompToMap(hwcs[i]);
				Map mapRowData = mapRow;
				mapRowData.setMap("RowData", m);

				Map cells=DrawRow(mapRowData, mapDisplay, ptx, dGripColumnWidths, numRows, false,bDoDrawing);
	
				if (nSummaryFunctionIndices.length()>0)
					CollectSums(cells, nSummaryFunctionIndices, dSummaries);
			}//next i
			
			return;
		}
			
	//endregion 	


		
		int bRowHasContent; // flag if at least one row contains display data
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& ent = ents[i];
			
		// Collect potential hardware
			HardWrComp hwcs[0];
//			if (bTypeOfHardware)
//			{ 
// 				ToolEnt tent = (ToolEnt)ent;
// 				if (tent.bIsValid())
// 				{ 
// 					int bAddSums[4];
// 					for (int f=0;f<ftrs.length();f++) 
// 					{ 
// 						if (ftrs[f].find("ScaleX",0, false)>-1 && nSummaryFunctionIndices.find(f)>-1)
// 							bAddSums[0] = true;
// 						if (ftrs[f].find("ScaleY",0, false)>-1 && nSummaryFunctionIndices.find(f)>-1)
// 							bAddSums[1] = true;	 
// 						if (ftrs[f].find("ScaleZ",0, false)>-1 && nSummaryFunctionIndices.find(f)>-1)
// 							bAddSums[2] = true;
// 						if (ftrs[f].find("Quantity",0, false)>-1 && nSummaryFunctionIndices.find(f)>-1)
// 							bAddSums[3] = true; 							
//					}//next f
// 					
// 					hwcs = HardwareCompSummarize(tent.hardWrComps(), bAddSums);	
// 					
//					for (int j2=0;j2<hwcs.length();j2++) 
//					{ 
//						Map m = HardWrCompToMap(hwcs[j2]);
//						Map mapRowData = mapRow;
//						mapRowData.setMap("RowData", m);
//
//						Map cells=DrawRow(mapRowData, mapDisplay, ptx, dGripColumnWidths, numRows, false);
//			
//						if (nSummaryFunctionIndices.length()>0)
//							CollectSums(cells, nSummaryFunctionIndices, dSummaries);
//					}//next j2 					
// 				} 
//			}
//			else 
			if (bTypeOfTool && ent.bIsKindOf(GenBeam()))
			{ 
				GenBeam gb = (GenBeam)ent;
				AnalysedTool tools[] = gb.analysedTools();
				
				for (int ii=0;ii<tools.length();ii++) 
				{ 
					AnalysedTool tool = tools[ii]; 
					String toolType = tool.toolType();
					if (toolType.makeUpper()!=rowType.makeUpper())
					{ 
						continue;
					}
					Map m = tool.mapInternal();
					
					AnalysedDrill drill = (AnalysedDrill)tool;
					AnalysedSlot slot = (AnalysedSlot)tool;
					AnalysedBeamCut beamcut= (AnalysedBeamCut)tool;
					
				// AnalysedDrill			
					if (drill.bIsValid())
					{
						m.setDouble("Diameter", drill.dDiameter());
						m.setDouble("Radius", drill.dRadius());
						m.setDouble("Depth", drill.dDepth());
						m.setDouble("Angle", drill.dAngle());
						m.setDouble("Bevel", drill.dBevel());
						m.setInt("isThrough", drill.bThrough());
					}
				// AnalysedSlot			
					else if (slot.bIsValid())
					{
						m.setDouble("Depth", slot.dDepth());
						m.setDouble("Angle", slot.dAngle());
						m.setDouble("Bevel", slot.dBevel());
						m.setDouble("Twist", slot.dTwist());
					}
				// AnalysedBeamCut			
					else if (beamcut.bIsValid())
					{
						m.setDouble("Depth", beamcut.dDepth());
						m.setDouble("Angle", beamcut.dAngle());
						m.setDouble("Bevel", beamcut.dBevel());
						m.setDouble("Twist", beamcut.dTwist());
						
					}					
					
					else
						m = tool.mapInternal();
					m.setInt("*Qty", 1);
					
					Map mapRowData = mapRow;
					mapRowData.setString("Type", tool.toolType());
					mapRowData.setString("SubType", tool.toolSubType());
					mapRowData.setMap("RowData", m);

					Map cells=DrawRow(mapRowData, mapDisplay, ptx, dGripColumnWidths, numRows, false,true); 
										
					//if (bDebug)reportNotice("\n"+(level ==1?"   ":"")+"Collecting row: " +rowType + " tool.toolType()"+tool.toolType());
				}//next ii
			}
		// Add entity row
			else if (!bTypeOfTool)
			{ 
				Map m = mapRow;
				m.setEntity("ent",ent );			
				m.setInt("*Qty",  quantities[i]*nQtyParent);	
				//m.setInt("*QtyPosNum", quantities[i]); // TODO questionable

				Map cells=DrawRow(m,mapDisplay, ptx, dGripColumnWidths, numRows, false,true);
				
				int bRowHasContent = RowHasContent(cells);
				if (!bRowHasContent)
				{ 
					continue;
				}

				
				if (nSummaryFunctionIndices.length()>0)
					CollectSums(cells, nSummaryFunctionIndices, dSummaries);
				
 			// Get Child Rows
 				Map mapChildRows = mapRow.getMap("RowDefinition[]");					
 				for (int j2=0;j2<mapChildRows.length();j2++) 
				{
					Map rowDefinition = mapChildRows.getMap(j2);
					String childType = GetTypeOfRow(rowDefinition);

					Entity entChilds[0];
					if (childType.find("HardwareComp", 0, false)==0 || childType.find("Analysed", 0, false)==0) 
					{
						entChilds.append(ent);
					}
					else
					{
						Entity ents[]=CollectChildEntities(ent, childType, sChildPainter);
						entChilds = ents;						
					}
					
					Map mapChildRow = GetRowDef(rowDefinition, mapDisplay, ptx, numRows, entChilds,bHeaderAll, bHasSDV,true);
					if (mapChildRow.length()<1)
					{
						continue;
					}
					
					double dChildSummaries[0];
					int nChildSummaryFunctions[] = GetIntArray(mapChildRow.getMap("summaryFunctionIndex[]"), false);
					dChildSummaries.setLength(nChildSummaryFunctions.length());						
					
					//reportNotice("\n"+(level ==1?"   ":"")+"Collecting child row: " +childType + " childs sset("+entChilds.length()+")");
					mapChildRow.setInt("Level", level+1);
					
					Map mapIn;
					mapIn.setMap("row", mapChildRow);
					mapIn.setMap("display", mapDisplay);
					mapIn.setMap("nestingRef", mapNestRefs);					
					
					CollectRowContent(mapIn, numRows,dChildSummaries,quantities[i],true);
					
					if(dChildSummaries.length()>0)
					{
						//ptx += vecX * vecX.dotProduct(ptLoc - ptx);
						DrawSummaryRow(mapChildRow, mapDisplay, dChildSummaries, dGripColumnWidths, ptx,true);
						numRows++;
					}	
				}
 				
 				
			}	
		}//next i



		return;
	}//endregion
	
//End Functions 2 endregion 

//EndPart #3 //endregion


//region Block Mode // ShopDrawView  
	if (sdv.bIsValid())
	{ 
		
		
	// add shopdraw trigger
		addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet );			
		
	//region On Generate ShopDrawing
		if (_bOnGenerateShopDrawing)
		{

			int bLog=false;
			if (bLog)reportNotice("\nBlockSpaceCreation starting " + _bOnGenerateShopDrawing);

		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);
	
			if (!bIsCreated && entCollector.bIsValid())
			{
				if (bLog)reportNotice("\nBlockSpaceCreation for " + sdvs.length() + " views");
				
				for (int i = 0; i < sdvs.length(); i++)
				{
					ShopDrawView _sdv = sdvs[i];

					ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
					int nIndFound = ViewData().findDataForViewport(viewDatas, _sdv);//find the viewData for my view
					if (nIndFound < 0) 
					{
						reportMessage(TN("|No viewdata found|"));						
						continue; 
					}
					ViewData viewData = viewDatas[nIndFound];


				// Transformations
					CoordSys ms2ps = viewData.coordSys();
					CoordSys ps2ms = ms2ps;
					ps2ms.invert();					

					PlaneProfile pp = ppSDVs[i];
					double dX = pp.dX();
					double dY = pp.dY();

					Point3d ptLoc = _Pt0;
					MultiPage page =(MultiPage)entCollector;
					if (page.bIsValid())
						ptLoc.transformBy(page.coordSys().ptOrg() - _PtW);

				// create TSL
					TslInst tslNew;;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			
					Point3d ptsTsl[] = {ptLoc};
					Map mapTsl, mapColumnWidths;
					mapTsl.setVector3d("vecOrg",  page.coordSys().ptOrg()- _PtW); // relocate to multipage
					
					mapTsl.setInt("BlockSpaceCreated", true);
					mapColumnWidths = SetDoubleArray(dGripColumnWidths, "");	
					mapTsl.setMap("ColumnWidths", mapColumnWidths);
					
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

					break;// only one view required
				}// next i
			}


			return;
		}//endregion
	
	//region Block Space Display
		else
		{ 
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing

			Display dpJig(-1);
			dpJig.trueColor(darkyellow, 70);	
			if (bDrag)// || bDebug)
				for (int i=0;i<ppSDVs.length();i++) 
				{
					dpJig.draw(ppSDVs[i], _kDrawFilled);
					dpJig.draw(ppSDVs[i]);
				}

		}//endregion		

	}
//End Block Mode // ShopDrawView  //endregion 

//region Specify Hierachical Headers
	for (int j=0;j<mapSections.length();j++) 
	{ 
		Map mapSection= mapSections.getMap(j);
		String sectionName = mapSection.getString("SheetName");
		
		// Move Code for debug here
		// .....
	
	//region Trigger SpecifyHeader
		String sTriggerSpecifyHeader = T("|Specify Header| " + "'"+sectionName+"'");
		addRecalcTrigger(_kContext, sTriggerSpecifyHeader );
		if (_bOnRecalc && _kExecuteKey==sTriggerSpecifyHeader)
		{
			
		//region Move this code for debug
			Map mapColumns = mapSection.getMap("RowDefinition[]\\RowDefinition\\Columns[]");
			Map mapHeaders = GetHierarchicalHeaders(sReport, sectionName);
			
			//translate headers into rowDefinitions for Dialog
			Map mapIn, rows;
			for (int i=0;i<mapHeaders.length();i++) 
			{ 
				Map m=mapHeaders.getMap(i);
				int inds[] = GetIntArray(m.getMap("Column[]"), false);
				String captions[] = GetStringArray(m.getMap("Caption[]"), false);
				
				Map row;
				for (int c=0;c<mapColumns.length();c++) 
				{ 
					String caption;
					int n = inds.find(c);
					if (n>-1)
						caption = captions[n];
					row.appendString("Column"+c, caption);				 
				}//next c
				rows.appendMap("Row" + i, row);	
			}//next i
			mapIn.setMap(kRowDefinitions, rows);				
		//endregion 			
			
			Map mapRet = ShowHeaderConfigDialog(mapIn, mapColumns);			
			if (bDebug)mapRet.writeToXmlFile("C:\\Temp\\scheduleTableDialogReturn.xml");
			
		//region rowDefinitions of Dialog translate into headers
			if (mapRet.length()>0 && !mapRet.getInt("WasCancelled"))
			{ 
				Map mapHeaders;
				int level = mapRet.length() - 1;
				for (int i=0;i<mapRet.length();i++) 
				{ 
					Map row = mapRet.getMap(i);
					
					
					int inds[0];
					String captions[0];
					for (int j=0;j<row.length();j++) 
					{ 
						String caption = row.getString(j);
						if (caption.length()>0)
						{ 
							captions.append(caption);
							inds.append(j);
						} 
					}//next j
	
					if (inds.length()>0)
					{ 
						Map mapHeader;
						mapHeader.setInt("Level", level);
						mapHeader.appendMap("Column[]", SetIntArray(inds, "Column"));
						mapHeader.appendMap("Caption[]", SetStringArray(captions, "Caption"));
						
						mapHeaders.appendMap("HierarchicalHeader", mapHeader);						
					}

					level--;
				}//next i
				
				
				if (bDebug)mapHeaders.writeToXmlFile("C:\\Temp\\scheduleTableHeader.xml");	
				// keep a copy in _Map
				_Map.setMap("HierarchicalHeaders[]", mapHeaders);
				
				Map mapReport;
				Map mapSection;
				mapSection.setString("Name", sectionName);
				mapSection.setMap("HierarchicalHeaders[]",mapHeaders);
				
				mapReport.setString("Name", sReport);
				mapReport.setMap("Section", mapSection);
				
				Map mapReports = mapSetting.getMap("Report[]");
				for (int i=mapReports.length()-1; i>=0 ; i--) 
				{ 
					Map m = mapReports.getMap(i);
					if (sReport.find(m.getString("Name"), 0, false)==0)
					{ 
						mapReports.removeAt(i, true);
						break;
					} 					 
				}//next i
				
				mapReports.appendMap("Report", mapReport);
				mapSetting.setMap("Report[]", mapReports);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				//reportMessage(TN("|Headers stored in setting| ") + sReport + "/" + sectionName + "\n" + mapSetting);
			}

							
		//endregion 	

			
			setExecutionLoops(2);
			return;
		}//endregion		 
	}//next j	
//endregion 





//region Function GetMaxRowHeight
	// returns
	double GetMaxRowHeight(String texts[], double margin, Map mapDisplay)
	{ 
		double textHeight = mapDisplay.getDouble("textHeight");
		String dimStyle = mapDisplay.getString("dimStyle");
		Display dp(-1);
		dp.dimStyle(dimStyle);
		dp.textHeight(textHeight);
		
		double height = textHeight;
		for (int i=0;i<texts.length();i++) 
		{ 
			double dY = dp.textHeightForStyle(texts[i], dimStyle, textHeight);
			if (dY>height)
				height = dY;
		}//next i
		height += 2 * margin;
		
		return height;
	}//endregion

//region #Main


	double dTableHeight, dTableWidth;
	int nNumTotalRow;
	for (int jj=0;jj<mapSections.length();jj++) 
	{ 
		Map mapSection = mapSections.getMap(jj);
		String sSectionName = mapSection.getString("SheetName");
		if (sSubReport!=tAll && sSectionName!=sSubReport)
		{
			continue;
		}		
		
	//region Draw Hierachical Headers
		if (dGripColumnWidths.length()>0)
		{ 
			Map mapHierachicalHeaders = GetHierarchicalHeaders(sReport, sSectionName);
			
			for (int i=0;i<mapHierachicalHeaders.length();i++) 
			{ 
				Map mapHeader = mapHierachicalHeaders.getMap(i);
				
				int columns[] = GetIntArray(mapHeader.getMap("Column[]"), false);
				String captions[] = GetStringArray(mapHeader.getMap("Caption[]"), false);
				double rowHeight = GetMaxRowHeight(captions, textHeight, mapDisplay);



				int startColumn = 0;
				int endColumn = dGripColumnWidths.length()-1;

			// append empty cell if first column is not specified
				if (columns.length()>0 && columns.first()>startColumn)
				{ 
					columns.insertAt(0,0);
					captions.insertAt(0,"");
				}
				
			// append empty cell if last column is not specified
//				if (columns.length()>1 && columns.last()<endColumn)
//				{ 
//					columns.append(endColumn);
//					captions.append("");
//				}
				
				for (int c=0;c<columns.length();c++) 
				{ 
					int lastColumn = endColumn;
					if (c<columns.length()-1)
						lastColumn = columns[c+1]-1;
		
					double width;
					for (int d=startColumn;d<dGripColumnWidths.length();d++)
					{
						width += dGripColumnWidths[d];
						if (d == lastColumn) break;
					}
		
					PlaneProfile pp;
					pp.createRectangle(LineSeg(ptx, ptx + vecX * width - vecY * rowHeight), vecX, vecY);
									
					int textColor= nColor;
					int borderColor= nColor;
					int fillColor = 0;
					int nTransparencyFill= 0;

					String text = _ThisInst.formatObject(captions[c]);
					
					DrawCell(text, pp, dp, dpBackGround, textColor, fillColor,borderColor, nTransparencyFill,  textHeight, dimStyle, 0, sDispRepNames); // alignment of headers always centered
					ptx += vecX * width;
					startColumn = lastColumn+1;//endColumn+1; 
				}//next c
				
				ptx += vecX * vecX.dotProduct(ptLoc - ptx) - vecY * rowHeight;

			}//next i			
		}
	//Draw Hierachical Headers //endregion 	

		Map mapRowDefinitions = mapSection.getMap("RowDefinition[]");
		
		if(sAlignment==tATop)
		{
			// HSB-24456
			// for top alignment, calculate table height beforehand
			// needed to update ptx
			// get table height
			int numRows;
			Point3d _ptx=ptx;
			for (int j = 0; j < mapRowDefinitions.length(); j++)
			{
				int bDrawHeader = !bHeaderNone;
				Map mapRow = GetRowDef(mapRowDefinitions.getMap(j), mapDisplay, ptx, numRows, showSet, bDrawHeader, bHasSDV,
					false);	
				if (mapRow.length()<1)
				{
					continue;
				}
				int nSummaryFunctions[] = GetIntArray(mapRow.getMap("summaryFunctionIndex[]"), false);
				double dSummaries[nSummaryFunctions.length()];			
				
				Map mapIn;
				mapIn.setMap("row", mapRow);
				mapIn.setMap("display", mapDisplay);
				mapIn.setMap("nestingRef", mapNestRefs);
				
				CollectRowContent(mapIn, numRows, dSummaries,1,false);
				if(dSummaries.length()>0)
				{
					DrawSummaryRow(mapRow, mapDisplay, dSummaries, dGripColumnWidths, ptx,false);
					numRows++;
				}
			//region Grip creation: column width grips
				if (!bCreateSubReport)
				{ 
					Point3d pt = ptLoc;
					for (int i=0;i<dGripColumnWidths.length();i++) 
					{ 
						pt += vecX * dGripColumnWidths[i];
						
						String name = "Column_" + i;
						if (GetGripIndexByName(name)<0)
						{ 
							Grip g;
							g.setPtLoc(pt);
							g.setVecX(vecX);
							g.setVecY(vecY);			
							g.addHideDirection(vecX);
							g.addHideDirection(vecY);			
							g.setColor(4);
							g.setShapeType(_kGSTDiamond);
							g.setName("Column_"+i);
							g.setToolTip(T("|Defines the width of the column|"));	
							g.setIsRelativeToEcs(true);
							_Grip.append(g);						
						}
					}//next i			
				}				
			//endregion
		
			}// next j row definition
			dTableHeight=vecY.dotProduct(ptLoc-ptx);
			ptx=_ptx;
			if (sAlignment==tATop)
				ptx += vecY * dTableHeight;
		}
		
		int numRows;
		for (int j = 0; j < mapRowDefinitions.length(); j++)
		{
			int bDrawHeader = !bHeaderNone;
			Map mapRow = GetRowDef(mapRowDefinitions.getMap(j), mapDisplay, ptx, numRows, showSet, bDrawHeader, bHasSDV,
				true);
			if (mapRow.length()<1)
			{
				continue;
			}
			int nSummaryFunctions[] = GetIntArray(mapRow.getMap("summaryFunctionIndex[]"), false);
			double dSummaries[nSummaryFunctions.length()];			
			
			Map mapIn;
			mapIn.setMap("row", mapRow);
			mapIn.setMap("display", mapDisplay);
			mapIn.setMap("nestingRef", mapNestRefs);
			
			CollectRowContent(mapIn, numRows, dSummaries,1,true);
			if(dSummaries.length()>0)
			{
				DrawSummaryRow(mapRow, mapDisplay, dSummaries, dGripColumnWidths, ptx,true);
				numRows++;
			}
			//ptx.vis(2);
		//region Grip creation: column width grips
			if (!bCreateSubReport)
			{ 
				Point3d pt = ptLoc;
				for (int i=0;i<dGripColumnWidths.length();i++) 
				{ 
					pt += vecX * dGripColumnWidths[i];
					
					String name = "Column_" + i;
					if (GetGripIndexByName(name)<0)
					{ 
						Grip g;
						g.setPtLoc(pt);
						g.setVecX(vecX);
						g.setVecY(vecY);			
						g.addHideDirection(vecX);
						g.addHideDirection(vecY);			
						g.setColor(4);
						g.setShapeType(_kGSTDiamond);
						g.setName("Column_"+i);
						g.setToolTip(T("|Defines the width of the column|"));	
						g.setIsRelativeToEcs(true);
						_Grip.append(g);
					}
				}//next i
			}
		//endregion 
		}// next j row definition
		
	// set end grip, used to identity table dimensions during drag
		if(sAlignment==tABottom)
		{
			// HSB-24456
			dTableHeight = vecY.dotProduct(ptLoc - ptx);
		}
		{ 
			for (int i=0;i<dGripColumnWidths.length();i++) 
				dTableWidth+=dGripColumnWidths[i]; 
			int n = GetGripIndexByName("End");
			if (n>-1)
			{ 
				_Grip[n].setPtLoc(ptLoc+vecX*dTableWidth-vecYDir*dTableHeight);
			}
		}
		
		nNumTotalRow += numRows;
	}	
	
	//reportNotice("\nnumRows" + numRows);	
	_Map.setInt("NumTotalRow", nNumTotalRow );
//endregion 

//region Purge Instance
	if ((bHasPage || bHasSection) && nNumTotalRow<2)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Could not find any content, schedule table will be deleted.|"));		
		eraseInstance();
		return;
	}
//endregion 

	{ 
		int n = GetGripIndexByName("End");
		PlaneProfile ppScheduleRange; ppScheduleRange.createRectangle(LineSeg(_Pt0, _Grip[n].ptLoc()), vecX, vecY);
		_Map.setPlaneProfile("Shape", ppScheduleRange);		//ppScheduleRange.vis(6);
	}
	
	if (bCreateSubReport)
	{ 
		eraseInstance();
		return;
	}
//endregion 



//region TRIGGER


//region Trigger AddEntities
	String sTriggerAddEntities = T("|Add Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerAddEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEntities)
	{	
	// prompt for entities
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			_Entity.append(ssE.set());

		setExecutionLoops(2);
		return;
	}//endregion	

	String sTriggerRemoveEntities = T("|Remove Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
	{
	
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());

		for (int i = 0; i < ents.length(); i++)
		{
			int n = _Entity.find(ents[i]);
			if (n >- 1)
				_Entity.removeAt(n);
		}
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger SelectReport
	String sTriggerSelectReport = T("|Select Report|");
	addRecalcTrigger(_kContextRoot, sTriggerSelectReport );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSelectReport || _kExecuteKey==sDoubleClick))
	{

		Map mapDefs;
		{ 
			for (int i=0;i<sReports.length();i++) 
				getReportSections(sReports[i], mapDefs); 			
		}

			
		String reports[0], sections[0]; 
		String names[] = getDefNames(mapDefs, reports, sections);
		int nSelected = names.findNoCase(sReport ,- 1);

		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Report Definitions|"));
		mapIn.setString("Prompt", T("|Select a new report definition.|"));
		mapIn.setInt("EnableMultipleSelection", false);
		if (nSelected>-1)mapIn.setInt("IsSelected", nSelected);
		
		for (int i = 0; i < names.length(); i++)
		{ 
			
			Map m;
			m.setString("Text", names[i]);
			//m.setString("ToolTip", sScriptNames[i]);
			//m.setInt("IsSelected", sScripts.find(sScriptNames[i])>-1?1:0);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);
		
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		if (mapOut.length()>0)
		{ 
			nSelected = mapOut.getInt("SelectedIndex");
			
			if (nSelected>-1)
			{ 
				sReport.set(reports[nSelected]);
				sSubReport.set(sections[nSelected]);
			}
	
			Map mapReport = GetReportMapFromCompany(sReport).getMap("ReportDefinition");
			mapReport.setMapName(sReport);
			_Map.setMap("ReportDefinition", mapReport);	
		}

		_Grip.setLength(0);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger UpdateReportDefinition
	String sTriggerUpdateReportDefinition = T("|Update Report Definition|");
	if (!bIsStaticEntry)addRecalcTrigger(_kContextRoot, sTriggerUpdateReportDefinition );
	if (_bOnRecalc && _kExecuteKey==sTriggerUpdateReportDefinition)
	{
		Map mapReport = GetReportMapFromCompany(sReport).getMap("ReportDefinition");
		mapReport.setMapName(sReport);
		_Map.setMap("ReportDefinition", mapReport);
		setExecutionLoops(2);
		return;
	}//endregion	



//endregion 


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };


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
        <int nm="BreakPoint" vl="520" />
        <int nm="BreakPoint" vl="1286" />
        <int nm="BreakPoint" vl="875" />
        <int nm="BreakPoint" vl="489" />
        <int nm="BreakPoint" vl="599" />
        <int nm="BreakPoint" vl="624" />
        <int nm="BreakPoint" vl="1217" />
        <int nm="BreakPoint" vl="529" />
        <int nm="BreakPoint" vl="1116" />
        <int nm="BreakPoint" vl="1174" />
        <int nm="BreakPoint" vl="1119" />
        <int nm="BreakPoint" vl="1112" />
        <int nm="BreakPoint" vl="1071" />
        <int nm="BreakPoint" vl="700" />
        <int nm="BreakPoint" vl="712" />
        <int nm="BreakPoint" vl="1140" />
        <int nm="BreakPoint" vl="1224" />
        <int nm="BreakPoint" vl="1180" />
        <int nm="BreakPoint" vl="2232" />
        <int nm="BreakPoint" vl="4063" />
        <int nm="BreakPoint" vl="3628" />
        <int nm="BreakPoint" vl="1583" />
        <int nm="BreakPoint" vl="1578" />
        <int nm="BreakPoint" vl="4049" />
        <int nm="BreakPoint" vl="3143" />
        <int nm="BreakPoint" vl="1529" />
        <int nm="BreakPoint" vl="3500" />
        <int nm="BreakPoint" vl="2952" />
        <int nm="BreakPoint" vl="2932" />
        <int nm="BreakPoint" vl="3040" />
        <int nm="BreakPoint" vl="2976" />
        <int nm="BreakPoint" vl="2982" />
        <int nm="BreakPoint" vl="3055" />
        <int nm="BreakPoint" vl="2439" />
        <int nm="BreakPoint" vl="4177" />
        <int nm="BreakPoint" vl="4166" />
        <int nm="BreakPoint" vl="3674" />
        <int nm="BreakPoint" vl="3478" />
        <int nm="BreakPoint" vl="4236" />
        <int nm="BreakPoint" vl="4218" />
        <int nm="BreakPoint" vl="4185" />
        <int nm="BreakPoint" vl="4163" />
        <int nm="BreakPoint" vl="3197" />
        <int nm="BreakPoint" vl="3200" />
        <int nm="BreakPoint" vl="3201" />
        <int nm="BreakPoint" vl="4151" />
        <int nm="BreakPoint" vl="4090" />
        <int nm="BreakPoint" vl="4115" />
        <int nm="BreakPoint" vl="3551" />
        <int nm="BreakPoint" vl="4159" />
        <int nm="BreakPoint" vl="4225" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24456: Reactivate property &quot;Alignment&quot; {top/bottom}" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/19/2025 2:40:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24134 counting quantity improved for nested items of metalparts" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/5/2025 9:34:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23719 drawing hardware color and transparency improved" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="3/24/2025 1:35:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21627 Property 'Number' resolves as integer or text" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/6/2025 9:28:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23421 Hardware supports simple queries equal '=' and not equal '!=', summary type added for hardware" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/30/2025 5:03:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23330 analysedDrill parameters appended" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="1/16/2025 4:23:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23136 supports batch shopdrawing" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="12/16/2024 9:28:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22758 Header overrides reimplemented, new commands in custom context menu to specify additional header descriptions" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/10/2024 5:21:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23136 supports insertion on multipages and creation via block space instance. new jigs to rescale and move schedule table." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/10/2024 12:10:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22953 supports blockrefs, new property to allow XRef/Block nested selection" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/29/2024 11:31:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22560  debug message removed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/28/2024 8:59:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22560 accepting modelDescription / model of tsls, consuming sequential colors if defined for dependent entity" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/19/2024 5:17:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22936 FastenerAssemblyEnt support added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/8/2024 4:24:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20933 nested reports extended" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/17/2024 1:29:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21627 nested reports based on elements and tsls supported. custom hierachical header definitions supported via settings file, new property to filter child entities when using nested reports" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/16/2024 11:34:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22718 accepts entities referenced by stack objects" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/24/2024 5:56:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22667 use buffered report if report definition cannot be found in company folder" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="9/13/2024 10:05:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22641 supports additional property export of hardware components via map content streamed to the notes property" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/10/2024 11:35:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22529 summarized hardware supports color coding via tokenized notes" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="8/14/2024 2:07:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22211 supporting summary type function" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/17/2024 4:24:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21702: Erase instance in shopdraw if invalid data; dont show table" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/25/2024 10:09:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21522 bugfix duplictaed quantity of element genbeam lists" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/26/2024 3:57:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21386 bugfix collecting hardware with query, collecting nested tools from genbeams " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/7/2024 3:35:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21276 grade display fixed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/5/2024 2:51:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20703 sub-nested entities further enhanced (stacking)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/24/2023 4:10:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20703 bugfix crashing acad, nested entities enhanced, grip behaviour enhanced, new property to toggle header appearance" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/23/2023 4:33:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20701 quantity fixed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/22/2023 9:50:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20449 hardware added, new property painter added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="11/17/2023 3:55:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 bounding shape published" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/14/2023 4:08:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20449 tsl property support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/8/2023 4:40:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20449 viewport support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="10/25/2023 11:51:25 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20449 innitial version of hsbScheduleTable" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/24/2023 3:39:45 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End