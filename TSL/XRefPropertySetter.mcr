#Version 8
#BeginDescription
This tsl stores overrides of properties against the xref. Values can be prefixed, appended or replaced

#Versions
Version 1.5 27.03.2023 HSB-18472 XRefPropertySetter supports also Masterpanels
Version 1.4 17.02.2023 HSB-17947 V25 compatible
Version 1.3 16.02.2023 HSB-17947 overrides properties of xref based elements or genbeams






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.5 27.03.2023 HSB-18472 XRefPropertySetter supports also Masterpanels , Author Thorsten Huck
// 1.4 17.02.2023 HSB-17947 V25 compatible , Author Thorsten Huck
// 1.3 16.02.2023 HSB-17947 overrides properties of xref based elements or genbeams , Author Thorsten Huck

/// <insert Lang=en>
/// Select elements and/or genbeams of external references
/// </insert>

// <summary Lang=en>
// This tsl stores overrides of properties against the xref. Values can be prefixed, appended or replaced
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "XRefPropertySetteer")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset+Erase|") (_TM "|Select tool|"))) TSLCONTENT
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
	
	String sExcludes[]={"DrawingProperties", "UniqueID", "Handle", "ElementDepth","ElementHeight", "ElementLength", "TypeName", "ZoneIndex",
		"Width", "Height", "Length","SolidWidth", "SolidHeight", "SolidLength", "Volume", "isDummy", "Beamcode", "CNCSplinterfree",
		"ColorIndex","HostID", "HsbID", "isLoose", "ExtraWidth"};


	String tDisabled = T("<|Disabled|>");
	String tAppend =T("|Append|"), tPrefix = T("|Prefix|"), tReplace= T("|Replace|"), sModes[] = {tAppend,tPrefix, tReplace};

//end Constants//endregion



////region Test XRef Models for the presence of genbeams, masterpanels and/or elements
	int bHasElement, bHasGenbeam, bHasMasterpanel;
	AcadDatabase dbs[] = _kCurrentDatabase.xrefDatabases();
	dbs.append(_kCurrentDatabase);
	for (int i=0;i<dbs.length();i++) 
	{ 
		AcadDatabase& db = dbs[i]; 
		Group gr = Group(db, "");
		
		if (!bHasGenbeam)
		{ 
			Entity ents[] = gr.collectEntities(true, GenBeam(), _kAllSpaces);
			if (ents.length()>0)
				bHasGenbeam = true;
		}
		if (!bHasElement)
		{ 
			Entity ents[] = gr.collectEntities(true, Element(), _kAllSpaces);
			if (ents.length()>0)
				bHasElement = true;
		}		
		if (!bHasMasterpanel)
		{ 
			Entity ents[] = gr.collectEntities(true, MasterPanel(), _kAllSpaces);
			if (ents.length()>0)
				bHasMasterpanel = true;
		}
	}//next i
	
	
	
	Entity entAllBrefs[] = Group().collectEntities(true, BlockRef(), _kModelSpace);
//	int bHasElement, bHasGenbeam, bHasMasterpanel;
//	for (int i=0;i<entAllBrefs.length();i++) 
//	{ 
//		BlockRef bref = (BlockRef)entAllBrefs[i];
//		//if (!bref.bIsValid()){ continue;}
////		
//		Group gr(bref.database(), "");
////		Entity entsE[] = gr.collectEntities(true, Element(), _kAllSpaces);
//		Entity entsG[] = gr.collectEntities(true, GenBeam(), _kAllSpaces);
////
////		
//		Block block(bref.definition());
////		
//		if (!bHasGenbeam)
//		{ 
//			bHasGenbeam = block.genBeam().length() > 0;
//		}
//
// 
//		Entity ents[] = block.entity();
//		for (int j=0;j<ents.length();j++) 
//		{ 
//			if (!bHasElement && ents[j].bIsKindOf(Element()))
//			{ 
//				bHasElement = true;
//			}
//			else if (!bHasMasterpanel && ents[j].bIsKindOf(MasterPanel()))
//			{ 
//				bHasMasterpanel = true;
//			}			
//			if (bHasElement && bHasMasterpanel)
//			{ 
//				break;
//			}
//		}//next j							
//	}//next i
	
	
	if (!bHasGenbeam && !bHasElement && !bHasMasterpanel)
	{ 
		reportNotice(TN("|Could not find any genbeam or element in any XRef.|"));
		reportNotice(TN("|Tool will not be inserted.|"));
		eraseInstance();
		return;
	}
////endregion 

	

//region Properties
category = T("|Element|");
	String sElemProperties[0];
	if (entAllBrefs.length()>0) 
		sElemProperties=entAllBrefs.first().formatObjectVariables("Element").sorted();
		
	// purge some
	for (int i=sElemProperties.length()-1; i>=0 ; i--) 
	{ 
		String s=sElemProperties[i]; 
		if (sExcludes.findNoCase(s,-1)>-1)sElemProperties.removeAt(i);
		else if (s.find("DetailPath",0,false)>-1)sElemProperties.removeAt(i);
		else if (s.left(15).makeLower() == "hsb_xrefcontent") sElemProperties.removeAt(i);
		else if (s.left(20).makeLower() == "hsbresponsibilityset") sElemProperties.removeAt(i);
		else if (s.left(5).makeLower() == "group") sElemProperties.removeAt(i);
		else if (s.left(4).makeLower() == "size") sElemProperties.removeAt(i);
		else if (s.left(4).makeLower() == "line") sElemProperties.removeAt(i);
		
	}//next i
	
	sElemProperties.insertAt(0, tDisabled);
	String sElemPropertyName=T("|Property|");	
	PropString sElemProperty(nStringIndex++, sElemProperties, sElemPropertyName);	
	sElemProperty.setDescription(T("|Defines the property to set|"));
	sElemProperty.setCategory(category);
	sElemProperty.setReadOnly(bHasElement|| bDebug ? false : _kHidden);
	if (!bHasElement)sElemProperty.set(tDisabled);
	
	String sElemValueName=T("|Value|");	
	PropString sElemValue(nStringIndex++, "", sElemValueName);	
	sElemValue.setDescription(T("|Defines the value to be assigned|"));
	sElemValue.setCategory(category);
	sElemValue.setReadOnly(bHasElement || bDebug ? false : _kHidden);
	
	String sElemModeName=T("|Mode|");	
	PropString sElemMode(nStringIndex++, sModes, sElemModeName);	
	sElemMode.setDescription(T("|Defines the ElemMode|"));
	sElemMode.setCategory(category);
	sElemMode.setReadOnly(bHasElement|| bDebug  ? false : _kHidden);

category = T("|GenBeam|");
	String sGbProperties[0];
	if (entAllBrefs.length()>0) 
		sGbProperties=entAllBrefs.first().formatObjectVariables("GenBeam").sorted();	

	// purge some
	for (int i=sGbProperties.length()-1; i>=0 ; i--) 
	{ 
		String s=sGbProperties[i]; 
		if (sExcludes.findNoCase(s,-1)>-1)sGbProperties.removeAt(i);
		else if (s.find("DetailPath",0,false)>-1)sGbProperties.removeAt(i);
		else if (s.left(15).makeLower() == "hsb_xrefcontent") sGbProperties.removeAt(i);
		else if (s.left(20).makeLower() == "hsbresponsibilityset") sGbProperties.removeAt(i);
		else if (s.left(5).makeLower() == "group") sGbProperties.removeAt(i);
		else if (s.left(4).makeLower() == "size") sGbProperties.removeAt(i);
		else if (s.left(4).makeLower() == "line") sGbProperties.removeAt(i);
		else if (s.left(6).makeLower() == "posnum") sGbProperties.removeAt(i);
		else if (s.left(7).makeLower() == "element") sGbProperties.removeAt(i); // should use element properties
		
	}//next i
	
	sGbProperties.insertAt(0, tDisabled);
	String sGbPropertyName=T("|Property|");	
	PropString sGbProperty(nStringIndex++, sGbProperties, sGbPropertyName);	
	sGbProperty.setDescription(T("|Defines the property to set|"));
	sGbProperty.setCategory(category);
	sGbProperty.setReadOnly(bHasGenbeam || bDebug ? false : _kHidden);
	if (!bHasGenbeam)sGbProperty.set(tDisabled);
	
	
	String sGbValueName=T("|Value|");	
	PropString sGbValue(nStringIndex++, "", sGbValueName);	
	sGbValue.setDescription(T("|Defines the value to be assigned|"));
	sGbValue.setCategory(category);
	sGbValue.setReadOnly(bHasGenbeam || bDebug ? false : _kHidden);
	
	String sGbModeName=T("|Mode|");	
	PropString sGbMode(nStringIndex++, sModes, sGbModeName);	
	sGbMode.setDescription(T("|Defines the ElemMode|"));
	sGbMode.setCategory(category);	
	sGbMode.setReadOnly(bHasGenbeam || bDebug ? false : _kHidden);


category = T("|Masterpanel|");
	String sMasterPanelProperties[0];
	if (entAllBrefs.length()>0) 
		sMasterPanelProperties=entAllBrefs.first().formatObjectVariables("MasterPanel").sorted();	

	// purge some
	for (int i=sMasterPanelProperties.length()-1; i>=0 ; i--) 
	{ 
		String s=sMasterPanelProperties[i]; 
		if (sExcludes.findNoCase(s,-1)>-1)sMasterPanelProperties.removeAt(i);
		else if (s.find("DetailPath",0,false)>-1)sMasterPanelProperties.removeAt(i);
		else if (s.left(15).makeLower() == "hsb_xrefcontent") sMasterPanelProperties.removeAt(i);
		else if (s.left(20).makeLower() == "hsbresponsibilityset") sMasterPanelProperties.removeAt(i);
		else if (s.left(5).makeLower() == "group") sMasterPanelProperties.removeAt(i);
		else if (s.left(4).makeLower() == "size") sMasterPanelProperties.removeAt(i);
		else if (s.left(4).makeLower() == "line") sMasterPanelProperties.removeAt(i);
		else if (s.left(7).makeLower() == "element") sMasterPanelProperties.removeAt(i); // should use element properties
		
	}//next i
	
	sMasterPanelProperties.insertAt(0, tDisabled);
	String sMasterPanelPropertyName=T("|Property|");	
	PropString sMasterPanelProperty(nStringIndex++, sMasterPanelProperties, sMasterPanelPropertyName);	
	sMasterPanelProperty.setDescription(T("|Defines the property to set|"));
	sMasterPanelProperty.setCategory(category);
	sMasterPanelProperty.setReadOnly(bHasGenbeam || bDebug ? false : _kHidden);
	if (!bHasGenbeam)sMasterPanelProperty.set(tDisabled);
	
	
	String sMasterPanelValueName=T("|Value|");	
	PropString sMasterPanelValue(nStringIndex++, "", sMasterPanelValueName);	
	sMasterPanelValue.setDescription(T("|Defines the value to be assigned|"));
	sMasterPanelValue.setCategory(category);
	sMasterPanelValue.setReadOnly(bHasGenbeam || bDebug ? false : _kHidden);
	
	String sMasterPanelModeName=T("|Mode|");	
	PropString sMasterPanelMode(nStringIndex++, sModes, sMasterPanelModeName);	
	sMasterPanelMode.setDescription(T("|Defines the ElemMode|"));
	sMasterPanelMode.setCategory(category);	
	sMasterPanelMode.setReadOnly(bHasGenbeam || bDebug ? false : _kHidden);




category = T("|Display|");
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(200), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -1, sColorName);	
	nColor.setDescription(T("|Defines the color|"));
	nColor.setCategory(category);


//region Selection Mode
	int nSelectMode;
	int nSelectTypes[] ={false, false, false};
	int bHasTypes[] ={bHasElement, bHasGenbeam, bHasMasterpanel};
	for (int i=0;i<bHasTypes.length();i++) 
		if (bHasTypes[i])
			nSelectMode += pow(2,i);

	for (int i=2; i>=0 ; i--) 
	{ 
		int n = pow(2, i);
		if (nSelectMode>=n)
		{ 
			nSelectMode -= n;
			nSelectTypes[i] = true;
		}
		else
			nSelectTypes[i] = false;
	}//next i

	String prompt = T("|Select xrefs of type| "), prompt2;
	for (int i=0;i<nSelectTypes.length();i++) 
		if(nSelectTypes[i])
		{
			String s = i == 0 ? T("|Element|") : (i == 1 ? T("|Genbeam|") : T("|Masterpanel|"));
			prompt +=(prompt2.length()>0?", ":"")+s;
			prompt2 = s;
		}		
//endregion 


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


		nSelectMode = 0;
		int nSelectTypes[] ={false, false, false};
		int bHasTypes[] ={sElemProperty != tDisabled && bHasElement, 
			sGbProperty != tDisabled && bHasGenbeam, 
			sMasterPanelProperty != tDisabled && bHasMasterpanel};
		for (int i=0;i<bHasTypes.length();i++) 
			if (bHasTypes[i])
				nSelectMode += pow(2,i);
	
		int bSelectOk;
		for (int i=2; i>=0 ; i--) 
		{ 
			int n = pow(2, i);
			if (nSelectMode>=n)
			{ 
				nSelectMode -= n;
				nSelectTypes[i] = true;
				bSelectOk = true;
			}
			else
				nSelectTypes[i] = false;
		}//next i
	
		String prompt = T("|Select xrefs of type| "), prompt2;
		for (int i=0;i<nSelectTypes.length();i++) 
			if(nSelectTypes[i])
			{
				String s = i == 0 ? T("|Element|") : (i == 1 ? T("|Genbeam|") : T("|Masterpanel|"));
				prompt +=(prompt2.length()>0?", ":"")+s;
				prompt2 = s;
			}	
			
		if (!bSelectOk)
		{ 
			eraseInstance();
			return;
		}
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE;
		int n;
		for (int i=0;i<nSelectTypes.length();i++) 
		{ 
			if(nSelectTypes[i])
			{ 
				if (n==0)
					ssE = PrEntity(prompt, (i==0?Element():i==1?GenBeam():MasterPanel()));
				else
					ssE.addAllowedClass((i==0?Element():i==1?GenBeam():MasterPanel()));	
				n++;
			}
		}	
		ssE.allowNested(true);
//
//
//
//
//
//
//	
//		Entity ents[0];
//		PrEntity ssE;
//		if(nSelectMode==1)
//		{
//			ssE = PrEntity(T("|Select external elements|"), Element());
//		}
//		else if(nSelectMode==2)
//		{
//			ssE = PrEntity(T("|Select external genbeams|"), GenBeam());
//		}		
//		else if(nSelectMode==3)
//		{
//			ssE = PrEntity(T("|Select external elements and genbeams|"), Element());
//			ssE.addAllowedClass(GenBeam());
//		}		
//
//		ssE.addAllowedClass(MasterPanel());
//		ssE.allowNested(true);
		
		if (ssE.go())
			ents.append(ssE.set());
		
		if (ents.length()>0)
		{ 
			_Entity = ents;
			_Pt0 = getPoint();
		}
		else
			eraseInstance();
		
		return;
	}			
//endregion 

//region General
	addRecalcTrigger(_kGripPointDrag, "_Pt0");	
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	if (sElemProperty != tDisabled)
		nSelectMode++;
	if (sGbProperty != tDisabled)
		nSelectMode=nSelectMode+2;
		
//endregion 


//region Collect XRef entities
	BlockRef bref, brefs[0];
	Entity ents[0]; ents = _Entity;//block.entity();
	Element elements[0];
	GenBeam genbeams[0];
	MasterPanel masters[0];
	
	for (int j=0;j<ents.length();j++) 
	{ 
		Element el = (Element)ents[j];
		if (el.bIsValid())
		{ 
			elements.append(el);
			continue;
		}			
		
		GenBeam gb = (GenBeam)ents[j];
		if (gb.bIsValid())
		{ 
			genbeams.append(gb);
			continue;
		}	
		MasterPanel master = (MasterPanel)ents[j];
		if (master.bIsValid())
		{ 
			masters.append(master);
			continue;
		}		
	}
//endregion 

//region Element
	for (int j=0;j<elements.length();j++) 
	{ 
		Element el = elements[j];
		if (el.bIsValid())
		{ 		
		// Get current value
			String fullValue = el.formatObject("@(" + sElemProperty + ")");
			String value = fullValue;
			String elemProperty = sElemProperty;
			if (elemProperty.find("ElementNumber",0,false)==0)
			{
				elemProperty = "Number";	
				String tokens[] = fullValue.tokenize("|");
				if (tokens.length()<2)
				{
					continue;
				}
				value = tokens[1];
			}
			String key = "EntityProperties\\" + elemProperty;
			
		// set desired value
			String newValue;
			if (sElemMode==tPrefix)
				newValue += sElemValue;
			newValue += value;
			if (sElemMode==tAppend)
				newValue += sElemValue;
			else if (sElemMode==tReplace)
				newValue =sElemValue;			
			
			value = newValue;
		
		//Get xref
			Entity entXRef = el.blockRef();//bref;// //
			bref = (BlockRef)entXRef;
			String sXRefName = el.xrefName();
			if (!entXRef.bIsValid() || sXRefName=="")
			{
				continue;
			}			
			if (bref.bIsValid() && brefs.find(bref)<0) // collect all brefs in use
			{
				brefs.append(bref);
				_Entity.append(bref);
			}
		
		//Get existing data
			Map mapXRef = entXRef.subMapX("hsb_XRefContent");	
			Map mapEntContent;

			for (int i = 0; i < mapXRef.length(); i++)
			{
				Map m = mapXRef.getMap(i);
				Entity xRefEnt = m.getEntity("XRefEntity");
				
				if (xRefEnt == el)
				{
					mapEntContent = m;
					mapXRef.removeAt(i, true);
					break;
				}
			}
			
			//reportMessage("\n" + scriptName() + T(" |Element| ") +el.number() + T(" |sets| ")+ sElemProperty + " = " + value);
			
			mapEntContent.setEntity("XRefEntity", el);
			mapEntContent.setString(key, value);
			mapXRef.appendMap("xRefContent", mapEntContent);
			entXRef.setSubMapX("hsb_XRefContent", mapXRef);
		}		
	}//next j		
//endregion 	

//region Genbeam
	for (int j=0;j<genbeams.length();j++) 
	{ 
		GenBeam gb = genbeams[j];
		if (gb.bIsValid())
		{ 		
		// Get current value
			String value = gb.formatObject("@(" + sGbProperty + ")");
			String key = "EntityProperties\\" + sGbProperty;
			
		// set desired value
			String newValue;
			if (sGbMode==tPrefix)
				newValue += sGbValue;
			newValue += value;
			if (sGbMode==tAppend)
				newValue += sGbValue;
			else if (sGbMode==tReplace)
				newValue =sGbValue;			
			
			value = newValue;
		
		//Get xref
			Entity entXRef = gb.blockRef();//bref;// //
			bref = (BlockRef)entXRef;
			String sXRefName = gb.xrefName();
			if (!entXRef.bIsValid() || sXRefName=="")
			{
				continue;
			}
			if (bref.bIsValid() && brefs.find(bref)<0) // collect all brefs in use
			{
				brefs.append(bref);
				_Entity.append(bref);
			}

		//Get existing data
			Map mapXRef = entXRef.subMapX("hsb_XRefContent");	
			Map mapEntContent;

			for (int i = 0; i < mapXRef.length(); i++)
			{
				Map m = mapXRef.getMap(i);
				Entity xRefEnt = m.getEntity("XRefEntity");
				
				if (xRefEnt == gb)
				{
					mapEntContent = m;
					mapXRef.removeAt(i, true);
					break;
				}
			}
			
			//reportMessage("\n" + scriptName() + T(" |GenBeam| ") +gb.posnum() + T(" |sets| ")+ sGbProperty + " = " + value);
			
			mapEntContent.setEntity("XRefEntity", gb);			
			mapEntContent.setString(key, value);	
			mapXRef.appendMap("xRefContent", mapEntContent);
			entXRef.setSubMapX("hsb_XRefContent", mapXRef);
			
		}		
	}//next j		
//endregion 


//region Master
	for (int j=0;j<masters.length();j++) 
	{ 
		MasterPanel master = masters[j];
		if (master.bIsValid())
		{ 		
		// Get current value
			String value = master.formatObject("@(" + sMasterPanelProperty + ")");
			String key = "EntityProperties\\" + sMasterPanelProperty;
			
		// set desired value
			String newValue;
			if (sMasterPanelMode==tPrefix)
				newValue += sMasterPanelValue;
			newValue += value;
			if (sMasterPanelMode==tAppend)
				newValue += sMasterPanelValue;
			else if (sMasterPanelMode==tReplace)
				newValue =sMasterPanelValue;			
			
			value = newValue;
		
		//Get xref
			Entity entXRef = master.blockRef();//bref;// //
			bref = (BlockRef)entXRef;
			String sXRefName = master.xrefName();
			if (!entXRef.bIsValid() || sXRefName=="")
			{
				continue;
			}
			if (bref.bIsValid() && brefs.find(bref)<0) // collect all brefs in use
			{
				brefs.append(bref);
				_Entity.append(bref);
			}

		//Get existing data
			Map mapXRef = entXRef.subMapX("hsb_XRefContent");	
			Map mapEntContent;

			for (int i = 0; i < mapXRef.length(); i++)
			{
				Map m = mapXRef.getMap(i);
				Entity xRefEnt = m.getEntity("XRefEntity");
				
				if (xRefEnt == master)
				{
					mapEntContent = m;
					mapXRef.removeAt(i, true);
					break;
				}
			}
			
			//reportMessage("\n" + scriptName() + T(" |Masterpanel| ") +master.number() + T(" |sets| ")+ sMasterpanelProperty + " = " + value);
			
			mapEntContent.setEntity("XRefEntity", master);			
			mapEntContent.setString(key, value);	
			mapXRef.appendMap("xRefContent", mapEntContent);
			entXRef.setSubMapX("hsb_XRefContent", mapXRef);
			
		}		
	}//next j		
//endregion 


//region Display
	Display dp(nColor);
	String dimStyle = _DimStyles.first();
	double textHeight = dTextHeight<=0?dp.textHeightForStyle("O", dimStyle):dTextHeight;
	dp.dimStyle(dimStyle);
	dp.textHeight(textHeight);
	String text;
	
	if (sElemProperty!=tDisabled)
	{ 
		if (sElemMode==tPrefix)
			text += sElemValue;
		text += "<"+sElemProperty+">";
		if (sElemMode==tAppend)
			text += sElemValue;
		else if (sElemMode==tReplace)
			text += "="+sElemValue;			

		for (int i=0;i<brefs.length();i++) 
		{ 
			int num;
			for (int j=0;j<elements.length();j++) 
			{ 
				Entity e = elements[j].blockRef(); 
				if (e==brefs[i])
					num++;
			}//next j
			int x = entAllBrefs.find(brefs[i])+1;
			text += TN("   |XRef| ") +x + T(" |Element| (") + num+ ") "; 
		}//next i


	}
	if (sGbProperty!=tDisabled)
	{ 
		if (nSelectMode == 3)text += "\\P";
		
		
		if (sGbMode==tPrefix)
			text += sGbValue;
		text += "<"+sGbProperty+">";
		if (sGbMode==tAppend)
			text += sGbValue;
		else if (sGbMode==tReplace)
			text += "="+sGbValue;		

		for (int i=0;i<brefs.length();i++) 
		{ 
			int num;
			for (int j=0;j<genbeams.length();j++) 
			{ 
				Entity e = genbeams[j].blockRef(); 
				if (e==brefs[i])
					num ++;
			}//next j
			int x = entAllBrefs.find(brefs[i])+1;
			text += TN("   |XRef| ") + x + T(" |Genbeam| (") + num+ ") "; 
		}//next i		
	}	
	if (sMasterPanelProperty!=tDisabled)
	{ 
		if (nSelectMode == 3)text += "\\P";
		
		
		if (sMasterPanelMode==tPrefix)
			text += sMasterPanelValue;
		text += "<"+sMasterPanelProperty+">";
		if (sMasterPanelMode==tAppend)
			text += sMasterPanelValue;
		else if (sMasterPanelMode==tReplace)
			text += "="+sMasterPanelValue;		

		for (int i=0;i<brefs.length();i++) 
		{ 
			int num;
			for (int j=0;j<masters.length();j++) 
			{ 
				Entity e = masters[j].blockRef(); 
				if (e==brefs[i])
					num ++;
			}//next j
			int x = entAllBrefs.find(brefs[i])+1;
			text += TN("   |XRef| ") + x + T(" |Masterpanel| (") + num+ ") "; 
		}//next i		
	}



	// draw text
	double dX = dp.textLengthForStyle(text, dimStyle, textHeight);
	double dY = dp.textHeightForStyle(text, dimStyle, textHeight);
	dp.draw(text, _Pt0-_YW*.5*textHeight, _XW, _YW, 1 ,-1);
	PLine pl(_Pt0, _Pt0 + _XW * dX);
	pl.transformBy(-_YW * (dY+textHeight));
	dp.draw(pl);

	int nIndices[brefs.length()];
	{ 
		for (int i=0;i<brefs.length();i++) 
			for (int i2=0;i2<entAllBrefs.length();i2++) 
				if (brefs[i]==entAllBrefs[i2])
				{
					nIndices[i]=i2+1;
					break;
				}		 	
	}

	// draw boundary of xrefs
	for (int i=0;i<brefs.length();i++) 
	{ 
		Block block(brefs[i].definition());
		PlaneProfile pp(CoordSys(_Pt0, _XW, _YW, _ZW));
		LineSeg seg = block.getExtents();
		seg.transformBy(brefs[i].coordSys());
		
		pp.createRectangle(seg, _XW, _YW);
		pp.shrink(-textHeight);
		if (!bDrag)
		{ 
			PlaneProfile pp1 = pp;
			pp.shrink(-.1* textHeight);
			pp.subtractProfile(pp1);			
		}

		dp.draw(pp, _kDrawFilled, 60);
		
		String text = T("|XRef| ") + nIndices[i];
		double dX = dp.textLengthForStyle(text, dimStyle, textHeight)*1.5;
		
		Point3d pt = pp.ptMid() - .5 * (_XW *pp.dX() + _YW * pp.dY())-_YW*.5*textHeight;
		
	// skip (move) location if multiple attached	
		TslInst tsls[] = brefs[i].tslInstAttached();
		int n;
		for (int j=0;j<tsls.length();j++) 
		{ 
			TslInst& t = tsls[j];
			if (t.bIsValid() && t.scriptName() == scriptName() && t==_ThisInst)
			{
				n = j;
				break;
			}
		}//next j
		if (n>0)
		{ 
			continue;
		}
//		pt += _XW * n * dX;
		
		dp.draw(text,pt, _XW,_YW,1,-1); 
	}//next i
	





//endregion 

//region Trigger 

//region AddEntities
	String sTriggerAddEntities = T("|Add Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerAddEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEntities)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE;
		int n;
		for (int i=0;i<nSelectTypes.length();i++) 
		{ 
			if(nSelectTypes[i])
			{ 
				if (n==0)
					ssE = PrEntity(prompt, (i==0?Element():i==1?GenBeam():MasterPanel()));
				else
					ssE.addAllowedClass((i==0?Element():i==1?GenBeam():MasterPanel()));	
				n++;
			}
		}	
		ssE.allowNested(true);
		
		if (ssE.go())
			ents.append(ssE.set());


		for (int i=0;i<ents.length();i++) 
			if (_Entity.find(ents[i])<0)
				_Entity.append(ents[i]); 

		setExecutionLoops(2);
		return;
	}		
//endregion 

//region Trigger RemoveEntities
	String sTriggerRemoveEntities = T("|Remove Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE;
		int n;
		for (int i=0;i<nSelectTypes.length();i++) 
		{ 
			if(nSelectTypes[i])
			{ 
				if (n==0)
					ssE = PrEntity(prompt, (i==0?Element():i==1?GenBeam():MasterPanel()));
				else
					ssE.addAllowedClass((i==0?Element():i==1?GenBeam():MasterPanel()));	
				n++;
			}
		}	
		ssE.allowNested(true);
		
		if (ssE.go())
			ents.append(ssE.set());


		for (int i=0;i<ents.length();i++) 
		{
			int n = _Entity.find(ents[i]);
			if (n>-1)
				_Entity.removeAt(n);
		}

		setExecutionLoops(2);
		return;				
	}//endregion		

//region Trigger ResetErase
	String sTriggerResetErase = T("|Reset+Erase|");
	addRecalcTrigger(_kContextRoot, sTriggerResetErase );
	if (_bOnRecalc && _kExecuteKey==sTriggerResetErase)
	{
	// Collect all property setters active on the associated brefs
		for (int i=0;i<brefs.length();i++) 
		{ 
			Entity e= brefs[i]; 
			TslInst tsls[] = e.tslInstAttached();
			
			for (int j=tsls.length()-1; j>=0 ; j--) 
			{ 
				TslInst& t = tsls[j];
				String s=t.scriptName(); 
				if (t.bIsValid() && !bDebug && _ThisInst!=t && t.scriptName() == scriptName())
					t.dbErase();
			}//next j
			e.removeSubMapX("hsb_XRefContent");
			e.transformBy(Vector3d(0, 0, 0));
		}//next i
		eraseInstance();				
		return;
	}//endregion	

//endregion	

// Store this location
	_Map.setVector3d("vecOrg", _Pt0 - _PtW);



//
//Map m = bref.subMapX("hsb_XRefContent");
//
//Map map = bref.getAutoPropertyMap();










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
        <int nm="BREAKPOINT" vl="943" />
        <int nm="BREAKPOINT" vl="740" />
        <int nm="BREAKPOINT" vl="787" />
        <int nm="BREAKPOINT" vl="319" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18472 XRefPropertySetter supports also Masterpanels" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="3/27/2023 2:48:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17947 V25 compatible" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="2/17/2023 9:50:56 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17947 overrides properties of xref based elements or genbeams" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="2/16/2023 2:05:46 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End