#Version 8
#BeginDescription
#Versions
2.8 27.11.2023 HSB-20738: Support translation of formats when given inside pipes |Number| 
2.7 10.07.2023 HSB-19479: Check element validity 
Version 2.6 28.09.2021 HSB-10838 full submapX support added, painter definition can filter child entities of element, truss, tsl etc,new hidden property to auto create painter definitions in blank dwgs when catalog entries are used (includes lastInserted) , Author Thorsten Huck
Version 2.5 06.08.2021 HSB-12781 supports collection of all genbeams with the same posnum if in shopdraw relation. Sip panels may show masterpanel data if present (new custom format variables) , Author Thorsten Huck
Version 2.4 08.03.2021 
HSB-11094 display in element layout corrected, new properties CutN, CutNC, CutP, CutPC available on beams , Author Thorsten Huck

Version 2.3 01.03.2021 
HSB-10757 bugfix stacked entities in shopdrawing , Author Thorsten Huck

Version 2.2 26.02.2021
HSB-10836 bugfix of totals not being shown, introduced by HSB-7167 , Author Thorsten Huck

HSB-10433 Alert on invalid format definitions , Author Thorsten Huck
HSB-10181: various bugfixes

This tsl creates one or multiple schedule tables based on formast queries








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 8
#KeyWords Schedule;Report;List;Table;BOM
#BeginContents
//region Part 1
//region History
/// #Versions
// 2.8 27.11.2023 HSB-20738: Support translation of formats when given inside pipes |Number| Author: Marsel Nakuci
// 2.7 10.07.2023 HSB-19479: Check element validity Author: Marsel Nakuci
// 2.6 28.09.2021 HSB-10838 full submapX support added, painter definition can filter child entities of element, truss, tsl etc,new hidden property to auto create painter definitions in blank dwgs when catalog entries are used (includes lastInserted) , Author Thorsten Huck
// 2.5 06.08.2021 HSB-12781 supports collection of all genbeams with the same posnum if in shopdraw relation. Sip panels may show masterpanel data if present (new custom format variables) , Author Thorsten Huck
// 2.4 08.03.2021 HSB-11094 display in element layout corrected, new properties CutN, CutNC, CutP, CutPC available on beams , Author Thorsten Huck
// 2.3 01.03.2021 HSB-10757 bugfix stacked entities in shopdrawing , Author Thorsten Huck
// 2.2 26.02.2021 HSB-10836 bugfix of totals not being shown, introduced by HSB-7167 , Author Thorsten Huck
// 2.1 22.01.2021 HSB-10433 Alert on invalid format definitions , Author Thorsten Huck
/// <version value="2.0" date="17dec2020" author="thorsten.huck@hsbcad.com"> HSB-10181: various bugfixes introduced by HSB-7167 </version>
/// <version value="1.9" date="01dec2020" author="marsel.nakuci@hsbcad.com"> HSB-7167: the default catalog set via trigger will be used without changing the properties </version>
/// <version value="1.8" date="30nov2020" aunothor="marsel.nakuci@hsbcad.com"> HSB-7167: add trigger to set cataloge </version>
/// <version value="1.7" date="27nov2020" author="marsel.nakuci@hsbcad.com"> HSB-7167: fix bug for shopdrawings </version>
/// <version value="1.6" date="28oct2020" author="thorsten.huck@hsbcad.com"> HSB-9335 PivotSchedule resolves stacking items in model space </version>
/// <version value="1.5" date="19oct2020" author="thorsten.huck@hsbcad.com"> HSB-9335 PivotSchedule resolves stacking items if based on multipages, bugfix on adding or removing ´format variables </version>
/// <version value="1.4" date="01oct2020" author="thorsten.huck@hsbcad.com"> HSB-9039 PivotSchedule now supports ACA and hsbcad viewports, as well as beams, sheets, panels and shopdrawings </version>
/// <version value="1.3" date="23sep2020" author="thorsten.huck@hsbcad.com"> HSB-8915 supporting parent stacking data for grouping </version>
/// <version value="1.2" date="21aug2020" author="thorsten.huck@hsbcad.com"> HSB-8618 painter and viewports added, requires hsbcad 23 or higher</version>
/// <version value="1.1" date="21aug2020" author="thorsten.huck@hsbcad.com"> area and weight added to possible total formats</version>
/// <version value="1.0" date="20aug2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, select entities and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates one or multiple schedule tables based on formast queries
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbGridSchedule")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format Header|") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format Group|") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format Value|") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format Total|") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities|") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities|") (_TM "|Select schedule table|"))) TSLCONTENT
//End History//endregion 

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

	String sDictionary = "hsbTSL";
	String sFileName ="hsbPivotSchedule";
	// load the selected cataloge
	MapObject mo(sDictionary ,sFileName);
	
//region Properties
	int nDialogMode= _Map.getInt("DialogMode");
	if(nDialogMode==1)
	{ 
		setOPMKey("SaveConfiguration");
			
		String sConfigurationName=T("|Configuration|");	
		PropString sConfiguration(nStringIndex++, "", sConfigurationName);	
		sConfiguration.setDescription(T("|Defines the name of a configuration|"));
		return;
	}
	
	String sCatalog;
	
	category = T("|General|");
	String sTypeWallSF = T("|Wall Stickframe|");
	String sTypeElement = T("|Element|");
	String sTypeShopdrawing = T("|Shopdrawing|");
	String sTypeBeam = T("|Beam|");
	String sTypeSheet= T("|Sheet|");
	String sTypeSip = T("|Panel|");
	String sTypeGenBeam = T("|GenBeam|");
	String sTypeToolEnt = T("|Tool Entity|");
	String sTypeTslInstance = T("|TslInstance|");

	String sTypeByPainter = T("|byPainter|");//TODO
	
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	
	String sTypes[] ={ T("|Masterpanel|"),T("|Stacking|"),T("|Truss|"),sTypeWallSF,T("|Wall CLT|"), 
		T("|Element Roof/Floor|"),sTypeElement,sTypeShopdrawing, sTypeBeam, sTypeSheet, 
		sTypeSip,sTypeGenBeam, sTypeTslInstance,sTypeToolEnt};
	//if (sPainters.length() > 0)sTypes.append(sTypeByPainter);TODO
	String sSortedTypes[0];
	sSortedTypes= sTypes;
	String sTypeName=T("|Type|");
	String sType;
	PropString sTypeProp(nStringIndex++, sSortedTypes.sorted(), sTypeName);	
	sTypeProp.setDescription(T("|Defines the Type|"));
	sTypeProp.setCategory(category);
	sType = sTypeProp;
	
	String sModes[] = { T("|for each Instance|"), T("|as Collection|")};
	String sModeName=T("|Mode|");
	String sMode;
	PropString sModeProp(nStringIndex++, sModes, sModeName);	
	sModeProp.setDescription(T("|Defines the Mode|"));
	sModeProp.setCategory(category);
	sMode = sModeProp;

	sPainters.insertAt(0, T("|<Disabled>|"));
	String sPainterName=T("|Painter|");
	String sPainter;
	PropString sPainterProp(nStringIndex++, sPainters, sPainterName,0);	
	sPainterProp.setDescription(T("|Defines the Painter|"));
	sPainterProp.setCategory(category);
	sPainter = sPainterProp;

// Formats
	// header
	category = T("|Formats|");
	String sHeaderFormatName=T("|Header|");	
	String sHeaderFormat;
	PropString sHeaderFormatProp(nStringIndex++, "@(ProjectName)", sHeaderFormatName);	
	sHeaderFormatProp.setDescription(T("|Defines the header of the schedule table|") + T("|Format variables like @(ProjectName) are supported.|"));
	sHeaderFormatProp.setCategory(category);
	sHeaderFormat = sHeaderFormatProp;
	// HSB-20738
	if(sHeaderFormat.find("|",-1,true)>-1)
		sHeaderFormat=T(sHeaderFormat);
	
	// group
	String sGroupFormatName=T("|Group|");	
	String sGroupFormat;
	PropString sGroupFormatProp(nStringIndex++, "@(ProjectName)", sGroupFormatName);	
	sGroupFormatProp.setDescription(T("|Defines the group format of the description|"));
	sGroupFormatProp.setCategory(category);
	sGroupFormat = sGroupFormatProp;
	// HSB-20738
	if(sGroupFormat.find("|",-1,true)>-1)
		sGroupFormat=T(sGroupFormat);

// deprecated: replace all dTextHeight by dGroupTextHeight where commented
//	String sGroupTextHeightName=T("|Text Height|");	
//	PropDouble dGroupTextHeight(nDoubleIndex++, U(0), sGroupTextHeightName);	
//	dGroupTextHeight.setDescription(T("|Defines the Text Height|") + T(", |0 = byDimStyle|"));
//	dGroupTextHeight.setCategory(category);	
	
	String sFormatName=T("|Value|");
	String sFormat;
	PropString sFormatProp(nStringIndex++, "@(PosNum)", sFormatName);	
	sFormatProp.setDescription(T("|Defines the format of the data grid|"));
	sFormatProp.setCategory(category);
	sFormat = sFormatProp;
	// HSB-20738
	if(sFormat.find("|",-1,true)>-1)
		sFormat=T(sFormat);
	// Totals
	String sTotalFormatName=T("|Totals|");
	String sTotalFormat;
	PropString sTotalFormatProp(nStringIndex++, "@(Quantity)", sTotalFormatName);	
	sTotalFormatProp.setDescription(T("|Defines the format of the totals|"));
	sTotalFormatProp.setCategory(category);


// Display
	category = T("|Display|");

	String sNumColumnName=T("|Columns|");
	int nMaxNumColumn;
	PropInt nMaxNumColumnProp(nIntIndex++, 5, sNumColumnName);	
	nMaxNumColumnProp.setDescription(T("|Defines the maximal allowed amount of columns|") + T(" |0 = no limit|"));
	nMaxNumColumnProp.setCategory(category);	
	nMaxNumColumn = nMaxNumColumnProp;
	
	String sTextHeightName=T("|Text Height|");
	double dTextHeight;
	PropDouble dTextHeightProp(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeightProp.setDescription(T("|Defines the Text Height|") + T(", |0 = byDimStyle|")) + T("|On viewports the scale of the viewport will be considered.|");
	dTextHeightProp.setCategory(category);		
	dTextHeight = dTextHeightProp;
	
	String sTextColorName=T("|Text Color|");
	int nTextColor;
	PropInt nTextColorProp(nIntIndex++, 0, sTextColorName);	
	nTextColorProp.setDescription(T("|Defines the text color|"));
	nTextColorProp.setCategory(category);
	nTextColor = nTextColorProp;
	
	String sGridColorName=T("|Grid Color|");
	int nGridColor;
	PropInt nGridColorProp(nIntIndex++, 252, sGridColorName);	
	nGridColorProp.setDescription(T("|Defines the color of the grid|") + T(", |-1 = no grid|"));
	nGridColorProp.setCategory(category);
	nGridColor = nGridColorProp;
	
	String sDimStyleName=T("|DimStyle|");
	String sDimStyle;
	PropString sDimStyleProp(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyleProp.setDescription(T("|Defines the DimStyle|"));
	sDimStyleProp.setCategory(category);
	sDimStyle = sDimStyleProp;
	
//region Create Painter by Property
	String sPainterStreamName=T("|Painter Definition|");	
	PropString sPainterStreamProp(nStringIndex++, "", sPainterStreamName);	
	sPainterStreamProp.setDescription(T("|Stores the data of the contact painter definition|"));
	sPainterStreamProp.setCategory(category);
	sPainterStreamProp.setReadOnly(_kHidden);
	String sPainterStream = sPainterStreamProp;

	if (_bOnDbCreated)
	{
		String _stream = sPainterStreamProp;
		if (_stream.length() > 0)
		{
			// get painter definition from property string	
			Map m;
			m.setDxContent(_stream, true);
			String name = m.getString("Name");
			String type = m.getString("Type").makeUpper();
			String filter = m.getString("Filter");
			String format = m.getString("Format");
			
			// create definition if not present	
			if (m.hasString("Name") && m.hasString("Type") && sPainters.findNoCase(name ,- 1) < 0)//name.find(sPainterCollection, 0, false) >- 1 &&
			{
				PainterDefinition pd(name);
				pd.dbCreate();
				pd.setType(type);
				pd.setFilter(filter);
				pd.setFormat(format);
				
				if (pd.bIsValid())
				{
					sPainters.append(name);
					
				}
			}
		}
	}

//End Create Painter by Property//endregion 


//End properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
		// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int bSelectInModel = true;
		
		
	// Paperspace, get a viewport
		if (bInLayoutTab)
		{
		// prompt for entity selection if not an element viewport
			Viewport vp = getViewport(T("|Select a viewport|"));
			Element el = vp.element();
			_Viewport.append(vp);
			if (el.bIsValid())
			{
				bSelectInModel = false;
				if (el.bIsKindOf(ElementWallSF()))sTypeProp.set(sTypeWallSF);
				else sTypeProp.set(sTypeElement);
				sTypeProp.setReadOnly(true);
				_Pt0 = getPoint();
			}
			else
				bSelectInModel = Viewport().switchToModelSpace();
		}
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
		int nType = sTypes.find(sTypeProp);
		
//		reportMessage("\nType " + sTypeProp + "  "+ nType + " " + sTypes);
		
	//region Select shopdraw view
		int bInBlockspaceShopdraw = !bInLayoutTab && Group().collectEntities(true, ShopDrawView(), _kMySpace).length()>0 && nType==7;
		if (bInBlockspaceShopdraw)
		{ 
			_Entity.append(getShopDrawView());
			_Pt0 = getPoint();
		}
	//End Select shopdraw view//endregion 	
	//region Select entities in modelspace
		else if (bSelectInModel)
		{ 
			
			int nMode = sModes.find(sModeProp);
			int bIsGenBeamType=nType>7 && nType<12;		
		//region Model Selection
		// prompt for entities
			Entity ents[0];
			PrEntity ssE;
			if (nType == 0)			ssE = PrEntity(T("|Select masterpanels|"), MasterPanel());
			else if (nType == 1)	ssE = PrEntity(T("|Select stacking entities|"), TslInst());				
			else if (nType == 2)	ssE = PrEntity(T("|Select trusses|"), TrussEntity());
			else if (nType == 3)	ssE = PrEntity(T("|Select stickframe walls|"), ElementWallSF());
			else if (nType == 4)	ssE = PrEntity(T("|Select walls|"), ElementWall());		
			else if (nType == 5)	ssE = PrEntity(T("|Select roof/floor elements|"), ElementRoof());
			else if (nType == 6)	ssE = PrEntity(T("|Select elements|"), Element());	
			else if (nType == 7)	ssE = PrEntity(T("|Select shopdrawing multipages|"), MultiPage());			
			else if (nType == 8)	ssE = PrEntity(T("|Select beams|"), Beam());				
			else if (nType == 9)	ssE = PrEntity(T("|Select sheets|"), Sheet());	
			else if (nType == 10)	ssE = PrEntity(T("|Select panels|"), Sip());	
			else if (nType == 11)	ssE = PrEntity(T("|Select genbeams|"), GenBeam());
			else if (nType == 12)	ssE = PrEntity(T("|Select tsls|"), TslInst());
			else if (nType == 13)	ssE = PrEntity(T("|Select tool entities|"), ToolEnt());
			ssE.allowNested(true);
			if (ssE.go())
			{
				Entity _ents[0];
				_ents.append(ssE.set());	
				
//			// make sure only multipages are taken	
//				if (nType == 7)
//				{ 
//					for (int i=0;i<_ents.length();i++) 
//						if (_ents[i].typeDxfName()=="HSBCAD_MULTIPAGE")
//							_Entity.append(_ents[i]); 
//				}
//			// other types	
//				else	
				_Entity = _ents;
			}
		
		// switch back to paperspace to pick a point in paperspace
			if (bInLayoutTab)	bInPaperSpace = Viewport().switchToPaperSpace();

		// collection mode
			if (nMode==1 || _Entity.length()==1 || bIsGenBeamType) // nMode==1 -> Collection
			{
				_Pt0 = getPoint(bInLayoutTab?T("|Select point in paperspace|"):T("|Select point|"));
				if (bIsGenBeamType)
				{
					nMode = 0;
					sModeProp.set(sModes[nMode]);
				}
			}
		// single instance mode, not supported for genbeams	
			else
			{ 
			// get base offset
				Point3d ptBase;
				Vector3d vecX = _XU, vecY = _YU, vecZ = _ZU;
				if (nType==0 && _Entity.length()>0)
				{ 
					MasterPanel master = (MasterPanel)_Entity.first();
					ptBase = master.ptRef();
				}
				
				else if (nType==1&& _Entity.length()>0)
				{ 
					TslInst tsl = (TslInst)_Entity.first();
					CoordSys cs = tsl.coordSys();
					vecX = cs.vecX();
					vecY = cs.vecY();
					vecZ = cs.vecZ();				
				}
				else if (nType==2&& _Entity.length()>0)
				{ 
					TrussEntity truss= (TrussEntity)_Entity.first();
					CoordSys cs = truss.coordSys();
					vecX = cs.vecX();
					vecY = cs.vecY();
					vecZ = cs.vecZ();				
				}
				else if (nType==12&& _Entity.length()>0)
				{ 
					TslInst tsl = (TslInst)_Entity.first();
					CoordSys cs = tsl.coordSys();
					vecX = cs.vecX();
					vecY = cs.vecY();
					vecZ = cs.vecZ();				
				}
				else if (nType>2&& _Entity.length()>0)
				{ 
					Element el = (Element)_Entity.first();
					if(el.bIsValid())
					{ 
						// HSB-19479: make sure valid element
						ptBase = el.ptOrg();
						vecX = el.vecX();
						vecY = el.vecY();
						vecZ = el.vecZ();
					}
				}
				
			// prompt for point input
				Point3d ptTo;
				PrPoint ssP(TN("|Select relative insertion point|"), ptBase); 
				if (ssP.go()==_kOk) 
					ptTo=ssP.value(); // append the selected points to the list of grippoints _PtG
				
				double dX = vecX.dotProduct(ptTo - ptBase);
				double dY = vecY.dotProduct(ptTo - ptBase);
				double dZ = vecZ.dotProduct(ptTo - ptBase);
	
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XU;			Vector3d vecYTsl= _YU;
				GenBeam gbsTsl[] = {};		Entity entsTsl[1];				Point3d ptsTsl[1];
				int nProps[]={nMaxNumColumn, nTextColor, nGridColor};	double dProps[]={dTextHeightProp};//dGroupTextHeight,
				String sProps[]={sTypeProp, sModeProp,sPainter,sHeaderFormat,sGroupFormat,sFormat,sTotalFormatProp,sDimStyleProp,sPainterStreamProp};
				Map mapTsl;	
	
				vecX = _XU;
				vecY = _YU;
				vecZ = _ZU;
				
				for (int i=0;i<_Entity.length();i++) 
				{ 
					entsTsl[0] = _Entity[i];
					MasterPanel master = (MasterPanel)_Entity[i];
					Element el= (Element)_Entity[i];
					TslInst tsl= (TslInst)_Entity[i];
					TrussEntity truss= (TrussEntity)_Entity[i];
					if (master.bIsValid())
						ptsTsl[0] = master.ptRef();
					else if (tsl.bIsValid())
						ptsTsl[0] = tsl.ptOrg();
					else if (truss.bIsValid())
						ptsTsl[0] = truss.coordSys().ptOrg();
					else if (el.bIsValid())
					{ 
						vecX = el.vecX();
						vecY = el.vecY();
						vecZ = el.vecZ();
						ptsTsl.first() = el.ptOrg();
					}
					ptsTsl.first()+= vecX * dX + vecY * dY + vecZ * dZ;
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}//next index
				eraseInstance();
			}			
		//End Model Selection//endregion 	
		}
	//End Select entities in modelspace//endregion 
			
		return;
	}
// end on insert	__________________//endregion

//region if catalogemode is active
	// load the selected cataloge
	if(_Map.hasString("sCatalog"))
	{
		String scriptName = bDebug ? "hsbPivotSchedule" : scriptName();
		sCatalog = _Map.getString("sCatalog");
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName);	
		if (sEntries.findNoCase(sCatalog,-1)>-1)
		{
//			setPropValuesFromCatalog(sCatalog);
			Map map = TslInst().mapWithPropValuesFromCatalog(scriptName, sCatalog);
			Map mapPropsString = map.getMap("PropString[]");
			Map mapPropsDouble = map.getMap("PropDouble[]");
			Map mapPropsInt = map.getMap("PropInt[]");
			
			String sPropStrings[] ={ sType, sMode, sPainter, sHeaderFormat, 
							sGroupFormat, sFormat, sTotalFormatProp, sDimStyle,sPainterStream};
			double dPropDoubles[] ={ dTextHeight};
			int nPropInts[] ={ nMaxNumColumn, nTextColor, nGridColor};
			
			if(mapPropsString.length()!=sPropStrings.length())
			{ 
				reportMessage(TN("|unexpected|"));
				eraseInstance();
				return;
			}
			if(mapPropsDouble.length()!=dPropDoubles.length())
			{ 
				reportMessage(TN("|unexpected|"));
				eraseInstance();
				return;
			}
			if(mapPropsInt.length()!=nPropInts.length())
			{ 
				reportMessage(TN("|unexpected|"));
				eraseInstance();
				return;
			}
			
			for (int i=0;i<mapPropsString.length();i++) 
				sPropStrings[i] = mapPropsString.getMap(i).getString("strValue");
			for (int i=0;i<mapPropsDouble.length();i++) 
				dPropDoubles[i] = mapPropsDouble.getMap(i).getDouble("dValue");
			for (int i=0;i<mapPropsInt.length();i++) 
				nPropInts[i] = mapPropsInt.getMap(i).getInt("lValue");
			
			sType = sPropStrings[0];
			sMode = sPropStrings[1];
			sPainter = sPropStrings[2];
			sHeaderFormat = sPropStrings[3];
			sGroupFormat = sPropStrings[4];
			sFormat = sPropStrings[5];
			sTotalFormat = sPropStrings[6];
			sDimStyle = sPropStrings[7];
			sPainterStream= sPropStrings[8];
			
			nMaxNumColumn = nPropInts[0];
			nTextColor = nPropInts[1];
			nGridColor = nPropInts[2];
			
			dTextHeight = dPropDoubles[0];
		}
	}
	else
		sTotalFormat = sTotalFormatProp; // HSB-10836 bugfix introduced by HSB-7167
//End if catalogemode is active//endregion 



//region Validate and lock insert dialog properties
	if (_Element.length()<1 && _Entity.length()<1 && _Viewport.length()<1)
	{ 
		reportMessage(TN("|unexpected validation|") + _Entity.length());
		if (!bDebug)eraseInstance();
		return;
	}
	sModeProp.setReadOnly(true);
	sTypeProp.setReadOnly(true);
	int nType = sTypes.find(sType);
	int nMode = sModes.find(sMode);	
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0 && sPainters.length()>0)
	{ 
		sPainterProp.set(sPainters.first());
		setExecutionLoops(2);
		return;
	}


	
	Element elements[0];elements = _Element;

// Get viewport data
	CoordSys ms2ps, ps2ms;
	double dScale = 1;
	// Viewport
	Viewport vp;
	int bIsAcaViewport, bIsHsbViewport;
	
	// Shopdraw Viewport
	MultiPage mp;
	ShopDrawView sdv ;
	Entity entsDefineSet[0],entsShowSet[0],entMultipage;
	int bHasSDV;
	
	// Viewport
	if (_Viewport.length() > 0)
	{
		vp = _Viewport[_Viewport.length() - 1]; //take last element of array
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		Element el=vp.element();
		if (el.bIsValid())
			elements.append(el);
		else
			bIsAcaViewport = true;
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps	
		dScale = vp.dScale();
		bIsHsbViewport = true;
	}
	
	// Shopdraw Viewport
	else if (_Entity.length()>0)
	{ 
		mp = (MultiPage)_Entity[0];
		sdv = (ShopDrawView)_Entity[0];
		if (sdv.bIsValid())
		{ 
		// interprete the list of ViewData in my _Map
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
			int nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
			if (nIndex>-1)
			{ 
				ViewData viewData = viewDatas[nIndex];
//				dXVp = viewData.widthPS();
//				dYVp = viewData.heightPS();
//				ptCenVp= viewData.ptCenPS();
				
				ms2ps = viewData.coordSys();
				ps2ms = ms2ps; ps2ms.invert();
				entsDefineSet = viewData.showSetDefineEntities();
				entsShowSet = viewData.showSetEntities();
//				for (int j=0;j<entsDefineSet.length();j++) 
//				{ 
//					el= (Element)entsDefineSet[j]; 
//					if (el.bIsValid())break;					 
//				}//next j
			}
			
			entMultipage = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			
			bHasSDV = true;
		}
		else if (mp.bIsValid())
		{ 
			setDependencyOnEntity(mp);
		// compose ModelMap, workaround until HSB-9058 is implemented
			ModelMap mm;
			mm.setEntities(_Entity);
			mm.dbComposeMap(ModelMapComposeSettings());
			Map mapMultiPage = mm.map().getMap("Model\\Multipage");
			Map mapObjectCollection = mapMultiPage.getMap("ObjectCollection");
		
		// get define and show sets
			entsShowSet.append(mp.showSet());
			entsDefineSet.append(mp.defineSet());

			
		// maintain location when multipage gets moved	
			Point3d ptOrgMP = mp.coordSys().ptOrg();
			Vector3d vecOrgCurrent = _Pt0 - ptOrgMP;
			Vector3d vecOrgPrevious = _Map.getVector3d("vecOrg");
			if (_kNameLastChangedProp!="_Pt0" && _Map.hasVector3d("vecOrg") && vecOrgCurrent!=vecOrgPrevious)
				_Pt0 = ptOrgMP + vecOrgPrevious;				
			if (!_Map.hasVector3d("vecOrg")|| _kNameLastChangedProp=="_Pt0")
				_Map.setVector3d("vecOrg", vecOrgCurrent);
			ptOrgMP.vis(4);
			
		// autoswitch type if set to shopdraw multipage
			if (nType==7 && entsDefineSet.length()>0)
			{ 
				Entity ent = entsDefineSet.first();
				if (ent.bIsKindOf(MasterPanel()))nType = 0;
				else if (ent.bIsKindOf(TslInst()))
				{
					TslInst tsl = (TslInst)ent;

				// stacking truckPackage
					String keys[] = tsl.subMapXKeys();// subMapX
					if (keys.findNoCase("Hsb_Child[]",-1)>-1)
						nType = 1;
					else
						nType = 12;
				}
				else if (ent.bIsKindOf(TrussEntity()))nType = 2;
				else if (ent.bIsKindOf(ElementWallSF()))nType = 3;
				else if (ent.bIsKindOf(ElementWall()))nType = 4;
				else if (ent.bIsKindOf(ElementRoof()))nType = 5;
				else if (ent.bIsKindOf(Element()))nType = 6;
				
				else if (ent.bIsKindOf(Beam()))nType = 8;
				else if (ent.bIsKindOf(Sheet()))nType = 9;
				else if (ent.bIsKindOf(Sip()))nType = 10;
				else if (ent.bIsKindOf(GenBeam()))nType = 11;
				else if (ent.bIsKindOf(TslInst()))nType = 12;
				else if (ent.bIsKindOf(ToolEnt()))nType = 13;
				sTypeProp.set(sTypes[nType]);
				sType = sTypes[nType];
			}	
		}
	}
	
// generals	
	Entity entThis = entMultipage.bIsValid() ? entMultipage : _ThisInst;
	double textHeight = dTextHeight * dScale;
	
	Vector3d vecX = _XU;
	Vector3d vecY = _YU;
	Vector3d vecZ = _ZU;
//End Validate//endregion 


//region Add Remove Entity Triggers
// Trigger AddEntity
	if (bIsHsbViewport)
	{ 
		vecX = _XW;
		vecY = _YW;
		vecZ = _ZW;
	}
	else if (!bIsHsbViewport)
	{ 
		String sTriggerAddEntity = T("|Add Entities|");
		addRecalcTrigger(_kContextRoot, sTriggerAddEntity );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddEntity)
		{
		// get current space and property ints
			int bInLayoutTab = Viewport().inLayoutTab();
			int bInPaperSpace = Viewport().inPaperSpace();
			int bSelectInModel = true;	
	
		// switch to modelspace
//			reportMessage(
//			"\n bInLayoutTab " + bInLayoutTab + 
//			"\n bInPaperSpace " + bInPaperSpace +
//			"\n bSelectInModel" + bSelectInModel +
//			"\n bIsAcaViewport " + bIsAcaViewport);
			if (bIsAcaViewport && bInPaperSpace) 	bSelectInModel = Viewport().switchToModelSpace();

		// prompt for entities
			PrEntity ssE;
			if (nType == 0)			ssE = PrEntity(T("|Select masterpanels|"), MasterPanel());
			else if (nType == 1)	ssE = PrEntity(T("|Select stacking entities|"), TslInst());				
			else if (nType == 2)	ssE = PrEntity(T("|Select trusses|"), TrussEntity());
			else if (nType == 3)	ssE = PrEntity(T("|Select stickframe walls|"), ElementWallSF());
			else if (nType == 4)	ssE = PrEntity(T("|Select walls|"), ElementWall());		
			else if (nType == 5)	ssE = PrEntity(T("|Select roof/floor elements|"), ElementRoof());
			else if (nType == 6)	ssE = PrEntity(T("|Select elements|"), Element());	
			else if (nType == 7)	ssE = PrEntity(T("|Select shopdrawing multipages|"), Entity());			
			else if (nType == 8)	ssE = PrEntity(T("|Select beams|"), Beam());				
			else if (nType == 9)	ssE = PrEntity(T("|Select sheets|"), Sheet());	
			else if (nType == 10)	ssE = PrEntity(T("|Select panels|"), Sip());	
			else if (nType == 11)	ssE = PrEntity(T("|Select genbeams|"), GenBeam());
			else if (nType == 12)	ssE = PrEntity(T("|Select tsls|"), TslInst());	
			else if (nType == 13)	ssE = PrEntity(T("|Select tool entities|"), ToolEnt());			
			ssE.allowNested(true);
		
			if (ssE.go())
				_Entity.append(ssE.set());		
		
		// switch back to paperspace
			if (bIsAcaViewport && bInLayoutTab) bInPaperSpace = Viewport().switchToPaperSpace();				
			
			setExecutionLoops(2);
			return;
		}
	}

// Trigger RemoveEntity
	if (_Entity.length()>1)
	{ 
		String sTriggerRemoveEntity = T("|Remove Entities|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveEntity );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntity)
		{
		// get current space and property ints
			int bInLayoutTab = Viewport().inLayoutTab();
			int bInPaperSpace = Viewport().inPaperSpace();
			int bSelectInModel = true;		
		// switch to modelspace
			if (bIsAcaViewport && bInPaperSpace) 	bSelectInModel = Viewport().switchToModelSpace();	
			
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select entities|"), Entity());
			if (ssE.go())
				ents.append(ssE.set());
			
			for (int i=0;i<ents.length();i++) 
			{ 
				int n = _Entity.find(ents[i]);
				if (n>-1)_Entity.removeAt(n); 
			}//next i
			
		// switch back to paperspace
			if (bIsAcaViewport && bInLayoutTab) bInPaperSpace = Viewport().switchToPaperSpace();	

			setExecutionLoops(2);
			return;
		}			
	}	
//End Add Remove ENtity Triggers//endregion 




//End Part 1//endregion 

	
//region Collect data entities
	Entity ents[0];
	if (entsShowSet.length()>0)
	{
		ents = entsShowSet;
		
	// replace special showsets
		if (ents.length()==1)
		{ 
			GenBeam gb = (GenBeam)ents.first();
		// TSL	
			TslInst tsl= (TslInst)ents.first();
			if (tsl.bIsValid())
			{ 
			// subMapX
				String keys[] = tsl.subMapXKeys();
				
			// stacking truckPackage
				if (keys.findNoCase("Hsb_Child[]",-1)>-1)
				{ 
					Map map = tsl.subMapX("Hsb_Child[]");
					Entity _ents[]=map.getEntityArray("Entity[]", "", "Entity");
					for (int j=0;j<_ents.length();j++) //HSB-10757 bugfix stacked entities in shopdrawing
					{ 
						if (ents.find(_ents[j])<0)
							ents.append(_ents[j]);
					}//next j					
					if (ents.length() > 0)ents.removeAt(0);// remove the parent entity from showset
				}	
			}
		// Get all genbeams of same posnum if linked to shopdrawing
			else if (gb.bIsValid() && gb.posnum()>-1 && (mp.bIsValid() || entMultipage.bIsValid()))
			{ 
				EntityCollection entCollection=gb.getEntitiesWithPosnum(gb.posnum());
				
				Entity _ents[0];
				if (gb.bIsKindOf(Beam()))
				{
					Beam arr[] = entCollection.beam();
					for (int i=0;i<arr.length();i++) 
						_ents.append(arr[i]); 	
				}
				else if (gb.bIsKindOf(Sheet()))
				{
					Sheet arr[] = entCollection.sheet();
					for (int i=0;i<arr.length();i++) 
						_ents.append(arr[i]); 	
				}
				else if (gb.bIsKindOf(Sip()))
				{
					Sip arr[] = entCollection.sip();
					for (int i=0;i<arr.length();i++) 
						_ents.append(arr[i]); 	
				}
				
				if (_ents.length()>0)
					ents = 	_ents;

			}
		}
	}
	
	
// any element	
	if (elements.length()>0)
	{ 
		for (int i=0;i<elements.length();i++) 
		{ 
			GenBeam gbs[] = elements[i].genBeam();
			for (int j=0;j<gbs.length();j++) 
				if (ents.find(gbs[j])<0)ents.append(gbs[j]); 
			Opening openings[] = elements[i].opening();
			for (int j=0;j<openings.length();j++) 
				if (ents.find(openings[j])<0)ents.append(openings[j]); 		
			TslInst tsls[] = elements[i].tslInstAttached();
			for (int j=0;j<tsls.length();j++) 
			{
				if (tsls[j] == _ThisInst || ents.find(tsls[j])>-1)continue;// avoid circular ref
				ents.append(tsls[j]); 		 
			}
		}//next i
	
	}
// genbeam type
	else if (nType >7 && nType<12 && (!mp.bIsValid() && !bHasSDV))
	{
		ents = _Entity;
		
	}
	else if(entsDefineSet.length()>0)
	{ 
		// HSB-7167: fix bug for shopdrawings
		Entity ent = entsDefineSet.first();
		MasterPanel master = (MasterPanel)ent;
		if (master.bIsValid())
		{ 
			ChildPanel childs[] = master.nestedChildPanels();
			for (int j=0;j<childs.length();j++) 
			{
				Sip sip = childs[j].sipEntity();
				if (ents.find(sip)<0)
					ents.append(sip); 
			}
		}
	// TSL	
		TslInst tsl= (TslInst)ent;
		if (tsl.bIsValid())
		{ 
		// subMapX
			String keys[] = tsl.subMapXKeys();
			
		// stacking truckPackage
			if (nType==1 && keys.findNoCase("Hsb_Child[]",-1)>-1)
			{ 
				Map map = tsl.subMapX("Hsb_Child[]");
				Entity _ents[]=map.getEntityArray("Entity[]", "", "Entity");
				for (int j=0;j<_ents.length();j++) //HSB-10757 bugfix stacked entities in shopdrawing
				{ 
					if (ents.find(_ents[j])<0)
						ents.append(_ents[j]);
				}//next j		
			}	
		}
	// Truss
		TrussEntity truss= (TrussEntity)ent;
		if (truss.bIsValid())
		{ 
			TrussDefinition definition = truss.definition();
			GenBeam gbs[] = definition.genBeam();
			for (int j=0;j<gbs.length();j++) 
				if (ents.find(gbs[j])<0)
					ents.append(gbs[j]); 
				
			TslInst tsls[] = definition.tslInst();
			for (int j=0;j<tsls.length();j++) 
			{
				if (tsls[j] == _ThisInst || ents.find(tsls[j])>-1)continue;// avoid circular ref
				ents.append(tsls[j]); 		 
			}
		}
		
	}
	else
	{ 
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
		// masterpanels	
			MasterPanel master = (MasterPanel)_Entity[i];
			if (master.bIsValid())
			{ 
				ChildPanel childs[] = master.nestedChildPanels();
				for (int j=0;j<childs.length();j++) 
					ents.append(childs[j].sipEntity()); 
				continue;
			}
		// TSL	
			TslInst tsl= (TslInst)_Entity[i];
			if (tsl.bIsValid())
			{ 
			// subMapX
				String keys[] = tsl.subMapXKeys();
				
			// stacking truckPackage
				if (nType==1 && keys.findNoCase("Hsb_Child[]",-1)>-1)
				{ 
					Map map = tsl.subMapX("Hsb_Child[]");
					
					Entity _ents[] = map.getEntityArray("Entity[]", "", "Entity");
					for (int j=0;j<_ents.length();j++) //HSB-10757 bugfix stacked entities in shopdrawing
					{ 
						if (ents.find(_ents[j])<0)
							ents.append(_ents[j]);
					}//next j
					continue;
				}
				else if (nType==12 || nType==13)// TslInstance or ToolEnt
				{ 
					ents.append(_Entity[i]);
				}
				else
					_Entity.removeAt(i);//purge other tsls out of selection set
				continue;	
			}
		// Truss
			TrussEntity truss= (TrussEntity)_Entity[i];
			if (truss.bIsValid())
			{ 
				TrussDefinition definition = truss.definition();
				GenBeam gbs[] = definition.genBeam();
				for (int j=0;j<gbs.length();j++) 
					ents.append(gbs[j]); 
					
				TslInst tsls[] = definition.tslInst();
				for (int j=0;j<tsls.length();j++) 
				{
					if (tsls[j] == _ThisInst)continue;// avoid circular ref
					ents.append(tsls[j]); 		 
				}		
					
				continue;	
			}			
		}//next i	
	}
	

//region entity acceptance
	String sPainterMsg;
	if (nPainter>0)// Accept only entities by painter
	{ 
		PainterDefinition painter(sPainters[nPainter]);
		Entity _ents[] = 	painter.filterAcceptedEntities(ents);	
		
		if (_ents.length() < 1)
		{
			sPainterMsg = T("|The painter| '")+ sPainter + T("' |filters entities of type| " + painter.type()+  T("\n|The painter  contains only the following types|"));
			
			String dxfs[0];
			for (int i=0;i<ents.length();i++) 
			{ 
				String dxf = ents[i].formatObject("@(TypeName)");
				if (dxfs.findNoCase(dxf,-1)<0)
				{
					dxfs.append(dxf);
					sPainterMsg += "\n " + dxf;
				}				 
			}//next i
			reportMessage("\n" + sPainterMsg);
		}
		ents = _ents;
		
	//region Write painter data to properties
		if ((_kNameLastChangedProp==sPainterName || sPainterStreamProp.length()==0) && painter.bIsValid())
		{ 
			Map m;
			m.setString("Name", painter.name());
			m.setString("Type",painter.type());
			m.setString("Filter",painter.filter());	
			m.setString("Format",painter.format());	
			
			sPainterStreamProp.set(m.getDxContent(true));
		}	
	//End Write painter data to properties//endregion 		
	
	}
	else if (nType==1)// stacking
	{ 
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst t =(TslInst)ents[i];
			if (t.bIsValid() && t.realBody().volume()<pow(dEps,3))
				ents.removeAt(i);

		}//next i
	}

	
			
//End entity acceptance//endregion 	

//Remove if no entities found (and not viewport)
	if (ents.length()<1)
	{ 
		String text;
		if (bHasSDV)
		{ 
			text = T("|Shopdraw Setup|");
		}
		else
		{ 
			text = scriptName() + ": " + T("|No entities could be found.|");
			reportMessage("\n"+ text);
			
			if (sPainterMsg.length()>0)
				text += "\\P" + sPainterMsg;		
		}

		Display dp(nTextColor);
		dp.dimStyle(sDimStyle);
		if (textHeight > 0)dp.textHeight(textHeight);
		dp.draw(text, _Pt0, vecX, vecY, 1, -1 );
		return;	
	}	
//End Collect data entities//endregion 

//region Collect all child panels if in panelmode to be able to link masterpanel data later on
	ChildPanel childs[0];
	if (nType==10 || nType==7)
	{ 
		Entity _ents[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);
		for (int i=0;i<_ents.length();i++) 
			childs.append((ChildPanel)_ents[i]); 
	
	}
//endregion 



//region FormatTriggers
	String sAddRemove = T("|Add/Remove Format|");
	String sTriggers[] ={sAddRemove + " " + sHeaderFormatName,sAddRemove+ " " + sGroupFormatName,sAddRemove+ " " + sFormatName,sAddRemove+ " " + sTotalFormatName};
	for (int i=0;i<sTriggers.length();i++) 
		addRecalcTrigger(_kContextRoot, sTriggers[i]); 
		
	int nTrigger = sTriggers.find(_kExecuteKey);//.right(_kExecuteKey.length() - 3));
	if ((_bOnRecalc && nTrigger>-1))// || bDebug)
	{ 
		//reportNotice(TN("|Entering report|"));
	// set entities to resolve the variables against
		// 0 = header, 1 = group, 2=values, 3=totals
		//if (bDebug) nTrigger = 1;
		Entity entsX[] ={entThis};//
		if (nTrigger==1 ||nTrigger==2)entsX = ents;		
//reportNotice(TN("|Entering report ents = |") + entsX.length());		
	//region Collect variables which can be resolved for the selected column
		Map mapAdditionalVariables;
		String sObjectVariables[0];
		String name;

		if (nTrigger==3)// totals
		{ 
			name= "Quantity";
			sObjectVariables.append(name);
			mapAdditionalVariables.appendString(name, ents.length());
			
			name= "Volume";
			sObjectVariables.append(name);
			mapAdditionalVariables.appendString(name, "5.4 m³" + T(" (|Sample|)"));			

			name= "Weight";
			sObjectVariables.append(name);
			mapAdditionalVariables.appendString(name, "98 kg" + T(" (|Sample|)"));			
			
		// area, only for certain classes
			if (ents.length()>0)
			{
				Sip sip = (Sip)ents.first();
				Sheet sheet = (Sheet)ents.first();
				if (sip.bIsValid() || sheet.bIsValid())
				{ 
					name= "Area";
					sObjectVariables.append(name);
					mapAdditionalVariables.appendString(name, "2.8 m²" + T(" (|Sample|)"));					
				}
			}
		}
		else if (entsX.length()>0)
		{
			for (int j=0;j<entsX.length();j++) 
			{ 
				Entity ent = entsX[j]; 
				Beam beam = (Beam)ent;
				Sheet sheet = (Sheet)ent;
				Sip sip = (Sip)ent;
				TslInst tsl = (TslInst)ent;
				
				
				String _ObjectVariables[0];
				if (beam.bIsValid())
				{
					_ObjectVariables= beam.formatObjectVariables();
					
			// append additional / not availabe properties // HSB-11094
					String k;
					k = "CutN"; if (sObjectVariables.find(k)<0) {sObjectVariables.append(k);	mapAdditionalVariables.appendString("CutN",beam.strCutN());}
					k = "CutP"; if (sObjectVariables.find(k) < 0) {sObjectVariables.append(k);	mapAdditionalVariables.appendString("CutP", beam.strCutP());}
					k = "CutNC"; if (sObjectVariables.find(k) < 0) {sObjectVariables.append(k);	mapAdditionalVariables.appendString("CutNC", beam.strCutNC());}
					k = "CutPC"; if (sObjectVariables.find(k) < 0) {sObjectVariables.append(k);	mapAdditionalVariables.appendString("CutPC", beam.strCutPC());}
					
				}
				else if (sheet.bIsValid())
				{
					_ObjectVariables= sheet.formatObjectVariables();
				}
				else if (sip.bIsValid())
				{
					_ObjectVariables= sip.formatObjectVariables();
					
					if (childs.length()>0)
					{ 
						ChildPanel child;
						for (int c=0;c<childs.length();c++) 
						{ 
							if (childs[c].sipEntity()==sip)
							{
								child=childs[c]; 
								break;
							}		 
						}//next c
						if (child.bIsValid())
						{ 
							MasterPanel master = child.getMasterPanel();
							if (master.bIsValid())
							{ 
								String k;
								
								k = "Masterpanel_Number"; if (sObjectVariables.find(k)<0) 
								{
									sObjectVariables.append(k);
									mapAdditionalVariables.appendString(k,master.number());
								}
								k = "Masterpanel_Name"; if (sObjectVariables.find(k)<0) 
								{
									sObjectVariables.append(k);
									mapAdditionalVariables.appendString(k,master.name());
								}	
								k = "Masterpanel_Information"; if (sObjectVariables.find(k)<0) 
								{
									sObjectVariables.append(k);
									mapAdditionalVariables.appendString(k,master.information());
								}											
								k = "Masterpanel_Style"; if (sObjectVariables.find(k)<0) 
								{
									sObjectVariables.append(k);
									mapAdditionalVariables.appendString(k,master.style());
								}											
							}
						}	
					}	
					
					
					
				}
				else if (tsl.bIsValid() && tsl.realBody().volume()>pow(dEps,3))
				{
					_ObjectVariables= tsl.formatObjectVariables();
				}				
				else
				{
					_ObjectVariables= ent.formatObjectVariables();
				}
				
				for (int i=0;i<_ObjectVariables.length();i++) 
				{ 
					if (sObjectVariables.findNoCase(_ObjectVariables[i],-1)<0)
						sObjectVariables.append(_ObjectVariables[i]); 
					 
				}//next i
				
			// append all submapX keys
				String keys[] = ent.subMapXKeys();
				for (int i=0;i<keys.length();i++) 
				{ 
					Map m = ent.subMapX(keys[i]);
					for (int ii=0;ii<m.length();ii++) 
					{ 
						String name = m.keyAt(ii);
						
						if (sObjectVariables.findNoCase(name,-1)<0 && (m.hasDouble(ii) ||m.hasString(ii) || m.hasInt(ii)))
						{
							if (m.hasDouble(ii))mapAdditionalVariables.appendDouble(name,m.getDouble(ii));	
							else if (m.hasString(ii))mapAdditionalVariables.appendString(name,m.getString(ii));
							else if (m.hasInt(ii))mapAdditionalVariables.appendInt(name,m.getInt(ii));
							
							sObjectVariables.append(name);	
						}					 
					}//next ii
					
				}


				
//			// HSB-8915 append additional variables if provided by subMapX
//				name = "AdditionalVariables";
//				if (ent.subMapXKeys().findNoCase(name,-1)>-1)
//				{ 
//					Map m = ent.subMapX(name);
//					for (int i=0;i<m.length();i++) 
//					{ 
//						name = m.keyAt(i);
//						if (sObjectVariables.findNoCase(name,-1)<0 && (m.hasDouble(i) ||m.hasString(i) || m.hasInt(i)))
//						{
//							if (m.hasDouble(i))mapAdditionalVariables.appendDouble(name,m.getDouble(i));	
//							else if (m.hasString(i))mapAdditionalVariables.appendString(name,m.getString(i));
//							else if (m.hasInt(i))mapAdditionalVariables.appendInt(name,m.getInt(i));
//							
//							sObjectVariables.append(name);	
//						}
//											 
//					}//next i			
//				}							 
			}//next j
			
			

		}

		// get translated list of variables
		String sTranslatedVariables[0];
		for (int i=0;i<sObjectVariables.length();i++) 
			sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
		
	// order both arrays alphabetically
		for (int i=0;i<sTranslatedVariables.length();i++) 
			for (int j=0;j<sTranslatedVariables.length()-1;j++) 
				if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
				{
					sObjectVariables.swap(j, j + 1);
					sTranslatedVariables.swap(j, j + 1);
				}			
	//End Collect variables which can be resolved for the selected column//endregion 	
		
	//region Show variables in report dialog and prompt for input
		String sPrompt;
		sPrompt+="\n"+ T("|Select a property by index to add or to remove|") + T(", |Exit with 0|");
		reportNotice(sPrompt);
		String format = sFormat;
		if (nTrigger==0)format = sHeaderFormat;
		else if (nTrigger==1)format = sGroupFormat;
		else if (nTrigger==3)format = sTotalFormat;
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<entsX.length();j++) 
			{ 
				String _value = entsX[j].formatObject("@(" + key + ")", mapAdditionalVariables);
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j
			String sAddRemove = format.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		
		if(_bOnRecalc && !bDebug)
		{ 
			int nRetVal = getInt(sPrompt)-1;		
		// select property	
			while (nRetVal>-1)
			{ 
				if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
				{ 
					String newFormat = sFormat;
					if (nTrigger==0)newFormat = sHeaderFormat;
					else if (nTrigger==1)newFormat = sGroupFormat;
					else if (nTrigger==3)newFormat = sTotalFormat;
					String format= sFormat;
					
				// get variable	and append if not already in list	
					String variable ="@(" + sObjectVariables[nRetVal] + ")";
					int x = format.find(variable, 0);
					if (x>-1)
					{
						int y = format.find(")", x);
						String left = format.left(x);
						String right= format.right(format.length()-y-1);
						newFormat = left + right;
						reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newFormat);				
					}
					else
					{ 
						newFormat+="@(" +sObjectVariables[nRetVal]+")";
					}
					
					// Header
					if (nTrigger==0)
					{ 
						sHeaderFormatProp.set(newFormat);
						sHeaderFormat = newFormat;
						reportMessage("\n" + sHeaderFormatName + " " + T("|set to|")+" " +sHeaderFormat);	
					}
					else if (nTrigger==1)
					{ 
						sGroupFormatProp.set(newFormat);
						sGroupFormat = newFormat;
						reportMessage("\n" + sGroupFormatName + " " + T("|set to|")+" " +sGroupFormat);	
					}
					else if (nTrigger==2)
					{ 
						sFormatProp.set(newFormat);
						sFormat = newFormat;
						reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
					}
					else if (nTrigger==3)
					{ 
						sTotalFormatProp.set(newFormat);
						sTotalFormat = newFormat;
						reportMessage("\n" + sTotalFormatName + " " + T("|set to|")+" " +sTotalFormat);	
					}					
				}
				nRetVal = getInt(sPrompt)-1;
			}	
		//End Show variables in report dialog and prompt for input//endregion 
			setExecutionLoops(2);
			return;			
		}
	}
//End FormatTriggers//endregion 
	

//region Trigger addCatalog
	if (bHasSDV)
	{ 
		// prepare dialog tsl
		TslInst tslDialog;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {};
		int nProps[]={};		double dProps[]={};		String sProps[]={};
		Map mapTsl;
		String sTriggerSelectCatalogDefault = T("|Select Catalog Default|");
		addRecalcTrigger(_kContextRoot, sTriggerSelectCatalogDefault );
		if (_bOnRecalc && _kExecuteKey == sTriggerSelectCatalogDefault)
		{
			
			mapTsl.setInt("DialogMode", 1);
			String sCatalog;
			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			sProps.append("");
			Map mapSetting;
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{
					sCatalog = tslDialog.propString(0);
					_Map.setString("sCatalog", sCatalog);
	//				mapSetting.setString("sCatalog", sCatalog);
	//				if (mo.bIsValid())mo.setMap(mapSetting);
	//				else mo.dbCreate(mapSetting);
				}
				tslDialog.dbErase();
			}//endregion
			setExecutionLoops(2);
			return;
		}		
	}




//region Get groups
	String sGroups[0], sGroupNames[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity ent = ents[i];
	// append all submapX keys
		Map mapAdditionalVariables;
		String keys[] = ent.subMapXKeys();
		for (int i=0;i<keys.length();i++) 
		{ 
			Map m = ent.subMapX(keys[i]);
			for (int ii=0;ii<m.length();ii++) 
			{ 
				String name = m.keyAt(ii);			
				if (m.hasDouble(ii))mapAdditionalVariables.appendDouble(name,m.getDouble(ii));	
				else if (m.hasString(ii))mapAdditionalVariables.appendString(name,m.getString(ii));
				else if (m.hasInt(ii))mapAdditionalVariables.appendInt(name,m.getInt(ii));
			}//next ii
			
		}
		String group = ents[i].formatObject(sGroupFormat,mapAdditionalVariables);
		sGroupNames.append(group);
		if (sGroups.find(group)<0)
			sGroups.append(group);	 
	}//next i
// order alphabetically
	for (int i=0;i<sGroupNames.length();i++) 
		for (int j=0;j<sGroupNames.length()-1;j++) 
			if (sGroupNames[j]>sGroupNames[j+1])
			{
				ents.swap(j, j + 1);
				sGroupNames.swap(j, j + 1);
			}
	for (int i=0;i<sGroups.length();i++) 
		for (int j=0;j<sGroups.length()-1;j++) 
			if (sGroups[j]>sGroups[j+1])
				sGroups.swap(j, j + 1);		
//End get groups//endregion 



//region Get grid geometry and precollect data
	int bDrawGrid = nGridColor >- 1;
	Display dpGroup(nTextColor), dpValue(nTextColor), dpGrid(nGridColor);
	dpGroup.dimStyle(sDimStyle);
	dpValue.dimStyle(sDimStyle);
	
	dpGroup.addHideDirection(vecX);		dpGroup.addHideDirection(-vecX);	dpGroup.addHideDirection(vecY);	dpGroup.addHideDirection(-vecY);
	dpValue.addHideDirection(vecX);		dpValue.addHideDirection(-vecX);	dpValue.addHideDirection(vecY);	dpValue.addHideDirection(-vecY);
	dpGrid.addHideDirection(vecX);		dpGrid.addHideDirection(-vecX);		dpGrid.addHideDirection(vecY);	dpGrid.addHideDirection(-vecY);
	
	if(textHeight>0)dpGroup.textHeight(textHeight);//dGroupTextHeight
	if(textHeight>0)dpValue.textHeight(textHeight);
	
	// use smallest sie as interline distance
	double dYGroup = dpGroup.textHeightForStyle("O", sDimStyle, textHeight );//dGroupTextHeight
	double dYValue = dpValue.textHeightForStyle("O", sDimStyle, textHeight);
	double dD = dYGroup<dYValue?dYGroup:dYValue;
	
// analyse data to distinguish grid sizes
	double dWidths[3]; // 0 = group, 1 = cell data, 2 = totals
	int nMaxNumCell; // the max number of cells of any group
	double dHeightTotal;
	
	Map mapValues[sGroups.length()];
	Map mapSubTotals[sGroups.length()];
	
	for (int i=0;i<sGroups.length();i++)
	{ 
				
	// get width of group column	
		double d = dpGroup.textLengthForStyle(sGroups[i], sDimStyle, textHeight);//dGroupTextHeight
		if (d > dWidths[0])dWidths[0] = d;
	
	// get width of cells of value column
		d = 0;
		int qty;
		double volume, area, weight;
		Map mapValue, mapSubTotal;
		for (int j=0;j<ents.length();j++) 
		{
			Entity ent = ents[j];
			Sip sip = (Sip)ent;
			Sheet sheet= (Sheet)ent;
			Beam beam= (Beam)ent;
			TslInst tsl = (TslInst)ent;
			ToolEnt toolEnt= (ToolEnt)ent;
			
			Map mapAdditionalValues;
			if (beam.bIsValid())
			{ 
				mapAdditionalValues.setString("CutN", beam.strCutN());
				mapAdditionalValues.setString("CutP", beam.strCutP());
				mapAdditionalValues.setString("CutNC", beam.strCutNC());
				mapAdditionalValues.setString("CutPC", beam.strCutPC());
			}
			else if (sip.bIsValid() && childs.length()>0)
			{ 	
				ChildPanel child;
				for (int c=0;c<childs.length();c++) 
				{ 
					if (childs[c].sipEntity()==sip)
					{
						child=childs[c]; 
						break;
					}		 
				}//next c
				if (child.bIsValid())
				{ 
					MasterPanel master = child.getMasterPanel();
					if (master.bIsValid())
					{ 
						mapAdditionalValues.setString("Masterpanel_Number", master.number());
						mapAdditionalValues.setString("Masterpanel_Name", master.name());
						mapAdditionalValues.setString("Masterpanel_Information", master.information());
						mapAdditionalValues.setString("Masterpanel_Style", master.style());
					}
				}	
			}
			
			if (sGroups[i]==sGroupNames[j])
			{
				
				
				qty++;
				String value = ent.formatObject(sFormat,mapAdditionalValues);
			//region Skip and Alert user if format variable unknown HSB-10433
				if (value.length() < 1 || (value == sFormat && sFormat.find("@(", 0) >- 1))
				{
					String typeInfo = ent.typeDxfName();
					if (tsl.bIsValid())typeInfo = tsl.scriptName();
					
					reportMessage(TN("|Could not resolve formatting of| ") + typeInfo);
				
					String tokens[0];
					String s = sFormat;
					int left = s.find("@(", 0);
					if (left >- 1)
					{
						//String sVariables[] = sLines[i].tokenize("@(*)");
						// tokenize does not work for strings like '(@(KEY))'
						while (s.length() > 0)
						{
							left = s.find("@(", 0);
							int right = s.find(")", left);
						// key found at first location	
							if (left == 0 && right > 0)
							{
								String out = s.left(right + 1).makeUpper();
								tokens.append(out);
								s = s.right(s.length() - right - 1);
							}
						// any text inbetween two variables	
							else if (left > 0 && right > 0)
								s = s.right(s.length() - left);
						// any postfix text
							else
								s = "";
						}
					}

					String sObjectVariables[] = ent.formatObjectVariables();
					for (int x=0;x<tokens.length();x++) 
					{ 
						if (tokens[x].find("@(",0,false)>-1 && sObjectVariables.findNoCase(tokens[x],-1)<0)
						{ 
							reportMessage("\n	"+tokens[x] + T(" |unknown|"));
						}
					}//next x
					continue; // skip empty or invalid
				}					
			//End Skip and Alert user if format variable unknown HSB-10433//endregion 	
			
				mapValue.appendString("value",value);	
				
			// width of cell	
				d = dpValue.textLengthForStyle(value, sDimStyle, textHeight);
				if (d > dWidths[1])dWidths[1] = d;
				
				if (qty > nMaxNumCell)nMaxNumCell = qty;
			
			// total data
				volume+=ent.formatObject("@(Volume)").atof()*U(10e-9);
				
				if (sip.bIsValid())		area += sip.plEnvelope().area() * U(10e-6);
				if (sheet.bIsValid())	area += sheet.plEnvelope().area() * U(10e-6);
				else					area+=ent.formatObject("@(Area)").atof();
				
				// calculate the weight	
				if (sTotalFormat.find("@(Weight)",0,false)>-1)
				{ 
					Map mapEnts, mapIO;
					mapEnts.appendEntity("Entity", ent);
					mapIO.setMap("Entity[]",mapEnts);
					TslInst().callMapIO("hsbCenterOfGravity", mapIO);
					weight+= mapIO.getDouble("Weight");// returning the weight
				}	
			}			
		}
		mapSubTotal.setDouble("Volume", volume);
		mapSubTotal.setDouble("Area", area);
		mapSubTotal.setDouble("Weight", weight);
		mapSubTotal.setInt("Quantity", qty);
		
	// get width of total column			
		String total = entThis.formatObject(sTotalFormat, mapSubTotal);
		d = dpValue.textLengthForStyle(total, sDimStyle, textHeight);
		if (d > dWidths[2])dWidths[2] = d;
		if (i==0)dHeightTotal=dpValue.textHeightForStyle(total, sDimStyle, textHeight)+dD;
		mapSubTotals[i] = mapSubTotal;
		mapValues[i] = mapValue; // append data values per group
	}
	
//Resolve Header
	String sHeader = entThis.formatObject(sHeaderFormat);
	double dHeightHeader = dpValue.textHeightForStyle(sHeader, sDimStyle, textHeight)+dD;
	double dWidthHeader = dpValue.textLengthForStyle(sHeader, sDimStyle, textHeight)+dD;
//End analyse data//endregion 		


//region Draw Grid
	double dCellWidth = dWidths[1]+dD;
	double dWidthTotal = dWidths[2]>0?dWidths[2]+dD:0;
	int nNumColumn = nMaxNumColumn == 0 ? nMaxNumCell : (nMaxNumColumn>nMaxNumCell?nMaxNumCell:nMaxNumColumn);
	
	Point3d pt1=_Pt0, pt2=pt1+vecX*(dWidths[0]+dD);
	Point3d pt3 = pt2 + vecX * nNumColumn* dCellWidth;
	Point3d pt4 = pt3 + vecX * +dWidthTotal;
	if (vecX.dotProduct(pt4 - pt1) < dWidthHeader)pt4 = pt1 + vecX * dWidthHeader;
	
	LineSeg seg;
	PLine pl;	
	
// header
	if (sHeader.length()>0)
	{ 
		Point3d ptTxt = (pt1 + pt4) * .5 - .5 *vecY* dHeightHeader;
		dpValue.draw(sHeader,ptTxt, vecX,vecY,0,0);

		if (bDrawGrid)
		{ 
			seg=LineSeg (pt1, pt4-vecY*dHeightHeader);//seg.vis(8);
			pl.createRectangle(seg, vecX, vecY);
			dpGrid.draw(pl);				
		}
		pt1 -= vecY * dHeightHeader;
		pt2 -= vecY * dHeightHeader;
		pt3 -= vecY * dHeightHeader;
		pt4 -= vecY * dHeightHeader;
	}
	
	pt3.vis(3);pt4.vis(4);
	
	int bHasValue;
	for (int i=0;i<sGroups.length();i++) 
	{ 
		pt1.vis(i);pt2.vis(2);

	// collect values from map
		String values[0];
		Map map = mapValues[i];
		for (int j=0;j<map.length();j++) 
			values.append(map.getString(j));
		values = values.sorted();
		if (values.length() < 1)continue;
		bHasValue = true;
		
	// draw group
		Point3d ptTxt = pt1 + .5*(vecX- vecY )* dD;
		double d1 = dpGroup.textHeightForStyle(sGroups[i], sDimStyle, textHeight)+dD;//dGroupTextHeight
		
PLine (ptTxt, pt1,_PtW).vis(1);
	vecX.vis(pt1,1);
	vecY.vis(pt1,3);
		
		dpGroup.draw(sGroups[i],ptTxt, vecX,vecY,1,-1);

	// draw data
		double d2 = dpValue.textHeightForStyle(values.first(), sDimStyle, textHeight)+dD;
		double dOffsetY=(d1>d2?d1:d2);		
		Point3d ptC = pt2;
		for (int j=0;j<values.length();j++) 
		{ 
			ptTxt = ptC + .5*(vecX- vecY )* dD;
			dpValue.draw(values[j],ptTxt, vecX,vecY,1,-1);

			if (bDrawGrid)
			{ 
				seg=LineSeg (ptC, ptC+vecX*dCellWidth-vecY*d2);
				seg.vis(8);
				pl.createRectangle(seg, vecX, vecY);
				dpGrid.draw(pl);				
			}
			int x = nMaxNumColumn>0?(j+1) / nMaxNumColumn:0;			
			if (nMaxNumColumn>0 && x*nMaxNumColumn==j+1 && j<values.length()-1)
				ptC+=vecX*vecX.dotProduct(pt2-ptC)-vecY*d2;
			else 
				ptC += vecX * dCellWidth;			 
		}//next j	
		ptC.vis(40);

	// get max rowheight	
		double dCellsHeight = vecY.dotProduct(pt1-ptC)+d2;
		double dRowHeight = dHeightTotal>dOffsetY?dHeightTotal:dOffsetY;
		dRowHeight = dCellsHeight > dRowHeight ? dCellsHeight : dRowHeight;
		
		pt1 -= vecY * dRowHeight;			
		pt3 += vecY * vecY.dotProduct(pt2 - pt3);//pt3.vis(94);
		pt2 += vecY * vecY.dotProduct(pt1 - pt2);
		
	// draw group box		
		if (bDrawGrid)
		{
			seg = LineSeg (pt1, pt4);//seg.vis(1);
			pl.createRectangle(seg, vecX, vecY);
			dpGrid.draw(pl);

			double dThick = 0.1 * dD;
			Point3d ptA = pt4 + vecY * (vecY.dotProduct(pt1 - pt4) + .5*dThick);
			Point3d ptB = pt1 - vecY *  .5*dThick;
			seg=LineSeg (ptA, ptB);//seg.vis(1);
			PlaneProfile pp;
			pp.createRectangle(seg, vecX, vecY);
			dpGrid.draw(pp,_kDrawFilled);
		}

	// subtotals
		String total = entThis.formatObject(sTotalFormat, mapSubTotals[i]);
		pt4 += vecY*vecY.dotProduct(pt1 -pt4);
		ptTxt = pt4 + .5*(-vecX+ vecY )* dD;
		dpValue.draw(total,ptTxt, vecX,vecY,-1,1);

		if (bDrawGrid)
		{ 
			seg=LineSeg(pt3, pt4);seg.vis(8);
			pl.createRectangle(seg, vecX, vecY);
			dpGrid.draw(pl);			
		}
	}//next i
	
//region Validate HSB-10433
	if (!bHasValue)
	{ 
		if (bHasSDV || _Viewport.length() > 0)
		{
			return;
		}
		else
		{ 
			reportMessage(TN("|Could not collect any values.|"));
			if (!bDebug)eraseInstance();
			return;
		}
	}
//End Validate//endregion 	
	
	
	
// totals
	if (sTotalFormat.length()>0)
	{ 
		pt4 -= vecY * dHeightTotal;
		pt3 += vecY * (vecY.dotProduct(pt4 - pt3) + .5 * dHeightTotal);
		//pt1.vis(1);pt3.vis(3); pt4.vis(4);
		
		if (bDrawGrid)
		{ 
			LineSeg seg(pt1, pt4);//seg.vis(8);
			PLine pl; pl.createRectangle(seg, vecX, vecY);
			dpGrid.draw(pl);			
		}
		
		Map mapTotal;
		double volume, area, weight;
		int qty;
		for (int i=0;i<mapSubTotals.length();i++) 
		{ 
			Map m = mapSubTotals[i]; 
			qty+= m.getInt("Quantity");
			volume += m.getDouble("volume");
			area += m.getDouble("area");
			weight += m.getDouble("weight"); 
		}//next i
		mapTotal.setDouble("volume", volume);
		mapTotal.setDouble("area", area);
		mapTotal.setDouble("weight", weight);
		mapTotal.setInt("Quantity", qty);

		String total = entThis.formatObject(sTotalFormat, mapTotal);
		Point3d ptTxt = pt4 + .5*(-vecX+ vecY )* dD;
		dpValue.draw(total,ptTxt, vecX,vecY,-1,1);
		
		ptTxt = pt3 + .5*(-vecX)* dD;
		
		dpValue.draw("∑",ptTxt, vecX,vecY,-1,0);
	}
//End Draw Grid//endregion 








#End
#BeginThumbnail
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
;#!815<;_![_:$K#EXM1B`````$E%3D2N0F""


















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
        <int nm="BreakPoint" vl="1679" />
        <int nm="BreakPoint" vl="1689" />
        <int nm="BreakPoint" vl="1705" />
        <int nm="BreakPoint" vl="1524" />
        <int nm="BreakPoint" vl="938" />
        <int nm="BreakPoint" vl="782" />
        <int nm="BreakPoint" vl="1206" />
        <int nm="BreakPoint" vl="1671" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20738: Support translation of formats when given inside pipes |Number|" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/27/2023 8:14:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19479: Check element validity" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="7/10/2023 2:39:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10838 full submapX support added, painter definition can filter child entities of element, truss, tsl etc,new hidden property to auto create painter definitions in blank dwgs when catalog entries are used (includes lastInserted)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/28/2021 6:00:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12781 supports collection of all genbeams with the same posnum if in shopdraw relation. Sip panels may show masterpanel data if present (new custom format variables)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/6/2021 10:15:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11094 display in element layout corrected, new properties CutN, CutNC, CutP, CutPC available on beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/8/2021 3:56:05 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End