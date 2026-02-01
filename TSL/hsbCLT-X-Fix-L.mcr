#Version 8
#BeginDescription
#Versions
1.6 05.12.2024 HSB-23003: save graphics in file for render in hsbView and make Author: Marsel Nakuci
Version 1.5 18.01.2022 HSB-14406 description text corrected for block or rule set consumption
Version 1.4 17.01.2022 HSB-14406 pline display in shopdrawings when tool not shown
Version 1.3 22.12.2021 HSB-14233 faro export unified
Version 1.2    22.12.2021   HSB-14233 supports tool description format, Faro-, Share-, Make-Exports, Dove or Freeprofile tool via tool index, new method to define shapes
Version 1.1    14.04.2021   HSB-11513 drawing of additional graphics supported, context command added for setup
Version 1.0    13.04.2021   HSB-11513 new tool to create X-Fix-L connections

This tsl creates an X-Fix-L Connection





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
//region Part #1
//region <History>
// #Versions
// 1.6 05.12.2024 HSB-23003: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 1.5 18.01.2022 HSB-14406 description text corrected for block or rule set consumption , Author Thorsten Huck
// 1.4 17.01.2022 HSB-14406 pline display in shopdrawings when tool not shown , Author Thorsten Huck
// 1.3 22.12.2021 HSB-14233 faro export unified , Author Thorsten Huck
// 1.2 22.12.2021 HSB-14233 supports tool description format, Faro-, Share-, Make-Exports, Dove or Freeprofile tool via tool index, new method to define shapes , Author Thorsten Huck
// 1.1 14.04.2021 HSB-11513 drawing of additional graphics supported, context command added for setup , Author Thorsten Huck
// 1.0 13.04.2021 HSB-11513 new tool to create X-Fix-L connections , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities parallel, mitred or T-Connected panels
/// </insert>

// <summary Lang=en>
// This tsl creates an X-Fix-L Connection
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT--X-Fix-L")) TSLCONTENT

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
	
	String sDefaultEntry = T("<|Default|>");
	int nc = 40;	
	
	String kDisabled = T("<|Disabled|>");
	String kSelectShape = T("|Select Shape|"), kCurrentShape = T("|Current Shape|");
	String kType =	"Type", kShape = "Shape", kColor = "Color", kToolIndex = "ToolIndex", 
		kMaxLength = "MaxLength", kXWidth = "XWidth", kZDepth="ZDepth",
		kHiddenLine="HiddenLine", kColorHidden="ColorHidden",kLineType="LineType",kLineScale="LineScale";

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
	
//end Constants//endregion


//region JIG
//region bOnJig
	if (_bOnJig && _kExecuteKey=="JigAction") 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    ptJig.setZ(0);
	    
	    PlaneProfile ppShape = _Map.getPlaneProfile(kShape);
	    PlaneProfile ppTool = _Map.getPlaneProfile("tool");
	    int color = _Map.getInt(kColor);
	    
	    Point3d ptRef = ppShape.ptMid();
	    ptRef.setZ(0);
	    Vector3d vec = ptJig - ptRef;
	    ppShape.transformBy(vec);
	    ppTool.transformBy(vec);
	    
	    PlaneProfile ppToolMirr = ppTool;
	    CoordSys csMirr; csMirr.setToMirroring(Plane(ptJig, _XW));
	    ppToolMirr.transformBy(csMirr);

	    PlaneProfile ppA = _Map.getPlaneProfile("contourA");
	    PlaneProfile ppB = _Map.getPlaneProfile("contourB");

	    Display dp1(-1), dp2(-1), dp3(-1);
	    dp1.trueColor(red);
	    dp2.color(color);
	    dp3.trueColor(darkyellow,50);
	    
	    dp1.draw(ppTool);
	    dp2.draw(ppShape, _kDrawFilled,50);
	    
	    ppA.subtractProfile(ppTool);
	    ppB.subtractProfile(ppTool);
	    ppA.subtractProfile(ppToolMirr);
	    ppB.subtractProfile(ppToolMirr);

	    dp3.draw(ppA, _kDrawFilled);
	    dp3.draw(ppB, _kDrawFilled);
	    
	    dp3.trueColor(white);
	    dp3.transparency(0);
	    dp3.draw(ppA);
	    dp3.draw(ppB);
   
//	    _ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
//	    //ptJig.vis(1);
//	    
//	    double radius =U(100);
//
//	    Display dpJ(1);
//	    dpJ.textHeight(U(100));
//	    PLine plCir; 
//	    plCir.createCircle(ptJig, _ZU, radius);
//	    dpJ.draw(plCir);
	    
	    return;
	}		
//End bOnJig//endregion 
		
//endregion 




//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-X-Fix-L";
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
//End Settings//endregion	

//region Read Settings
	Map mapTypes;
	String sTypes[] = { sDefaultEntry};


	double dTextHeight = U(60);
	double dYOffsetText = dTextHeight;
	String sStereotypeText="Text", sStereotypeDove="X-Fix";
	int nColorText= nc;
	String sTextFormat = "@(" + T("|Type|") + ")";
	String sLineType;
	double dLineScale;
	int nColorHidden;
	Map mapAdditionalVariables;	
	
	{
		String k;
			

	// Shopdrawing
		Map m= mapSetting.getMap("Shopdrawing");
		k = "TextHeight"; if (m.hasDouble(k)) dTextHeight = m.getDouble(k);
		k = "YOffsetText"; if (m.hasDouble(k)) dYOffsetText = m.getDouble(k);
		k = "ColorText"; if (m.hasInt(k)) nColorText = m.getInt(k);
		k = "TextFormat"; if (m.hasString(k)) sTextFormat = m.getString(k);
		k = "StereotypeText"; if (m.hasString(k)) sStereotypeText = m.getString(k);
		k = "StereotypeDove"; if (m.hasString(k)) sStereotypeDove = m.getString(k);
 
		k = kHiddenLine; 	if (m.hasMap(k)) 	m = m.getMap(k);
		k = kLineScale; 	if (m.hasDouble(k))	dLineScale = m.getDouble(k);
		k = kColorHidden; 	if (m.hasInt(k))	nColorHidden= m.getInt(k);
		k = kLineType; 		if (m.hasString(k))	sLineType = m.getString(k);
		
		
		
	// Get types from settings
		k="Type[]";		if (mapSetting.hasMap(k))	mapTypes = mapSetting.getMap(k);
		
		String types[0];
		for (int i=0;i<mapTypes.length();i++) 
		{ 
			Map m = mapTypes.getMap(i);
			String type  = m.getString(kType);
			if (types.findNoCase(type,-1)<0)
				types.append(type);
		}//next i
		types = types.sorted();
		if (types.length()>0)
			sTypes = types;		
	}
//End Read Settings//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey("Edit Type");

			String sShapeName=T("|Type|");	
			PropString sShape(nStringIndex++, T("|Shape Name|"), sShapeName);	
			sShape.setDescription(T("|Defines the name of the type|"));
			sShape.setCategory(category);
			
			int bHasShape = _Map.getInt("hasShape");
			String sSelectionName=T("|Selection|");	
			String sSelections[] = { kSelectShape};
			if (bHasShape)
				sSelections.append(kCurrentShape);
			sSelections = sSelections.sorted();	
			PropString sSelection(nStringIndex++, sSelections, sSelectionName);	
			sSelection.setDescription(T("|Defines if the type will be edited or redefined|"));
			sSelection.setCategory(category);
			//if (bHasShape)sSelection.set(kCurrentShape);
			
			String sToolIndexName=T("|Tool Index|");	
			PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);	
			nToolIndex.setDescription(T("|Defines the Tool Index|") + T(", |0 = Dovetail Tool|"));
			nToolIndex.setCategory(category);

		category = T("|Display|");
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 40, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);
	
			String sMaxLengthName=T("|MaxLength|");	
			PropDouble dMaxLength(nDoubleIndex++, U(0), sMaxLengthName);	
			dMaxLength.setDescription(T("|Defines the maximal length of the X-Fix|") + T(", |0 = unlimited|"));
			dMaxLength.setCategory(category);

		category = T("|Dovetail|");
			String sWidthName=T("|Width|");	
			PropDouble dWidth(nDoubleIndex++, U(24.7466), sWidthName);	
			dWidth.setDescription(T("|Defines the width of the dovetail tool|")+  T(", |0 = byShape|, ")+ T("|Only applicable if| ") + sToolIndexName + " = 0");
			dWidth.setCategory(category);
			
			String sDepthName=T("|Depth|");	
			PropDouble dDepth(nDoubleIndex++, U(41.0637), sDepthName);	
			dDepth.setDescription(T("|Defines the depth of the dovetail tool|")+  T(", |0 = byShape|, ")+ T("|Only applicable if| ") + sToolIndexName + " = 0");
			dDepth.setCategory(category);
			
			
			
			


			
		}
		if (nDialogMode == 2)
		{
			setOPMKey("Delete Shape");

			String sShapeName=T("|Shape|");	
			PropString sShape(nStringIndex++, sTypes, sShapeName);	
			sShape.setDescription(T("|Defines the name of the shape|"));
			sShape.setCategory(category);
		}
		if (nDialogMode == 3)
		{
			setOPMKey("Shopdrawing");
			
			
			String sTextStereotypes[0], sDimStereotypes[0];
			{ 
				String styles[] = MultiPageStyle().getAllEntryNames();
				for (int i=0;i<styles.length();i++) 
				{ 
					MultiPageStyle mps(styles[i]);
					String stereotypes[] = mps.getListOfStereotypeOverrides();
					for (int j=0;j<stereotypes.length();j++) 
					{ 
						if (sTextStereotypes.findNoCase(stereotypes[j],-1)<0)
							sTextStereotypes.append(stereotypes[j]); 			 
					}//next j	

					stereotypes = mps.getListOfStereotypeOverridesChainDim();
					for (int j=0;j<stereotypes.length();j++) 
					{ 
						if (sDimStereotypes.findNoCase(stereotypes[j],-1)<0)
							sDimStereotypes.append(stereotypes[j]); 			 
					}//next j	

				}//next i
				sTextStereotypes = sTextStereotypes.sorted();
				sTextStereotypes.insertAt(0, "*");	
				sTextStereotypes.insertAt(0,kDisabled);	
				
				sDimStereotypes = sDimStereotypes.sorted();
				sDimStereotypes.insertAt(0, "*");	
				sDimStereotypes.insertAt(0,kDisabled);					
			}	

			category = T("|Text|");	
			String sFormatName=T("|Format|");	
			PropString sFormat(nStringIndex++, sTextFormat, sFormatName);	
			sFormat.setDescription(T("|Defines the Format|"));
			sFormat.setCategory(category);
			
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight.setDescription(T("|Defines the TextHeight|"));
			dTextHeight.setCategory(category);
			
			String sTextOffsetName=T("|Offset|");	
			PropDouble dTextOffset(nDoubleIndex++, U(0), sTextOffsetName);	
			dTextOffset.setDescription(T("|Defines the vertical offset to the dove base line|"));
			dTextOffset.setCategory(category);
			
			String sStereotypeName=T("|Stereotype|");	
			PropString sStereotype(nStringIndex++, sTextStereotypes, sStereotypeName);	
			sStereotype.setDescription(T("|Defines the stereotype|"));
			sStereotype.setCategory(category);
			
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, nColorText, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);

			category = T("|Symbol|");	
			String sStereotypeSymbolName=T("|Stereotype|");	
			PropString sStereotypeSymbol(nStringIndex++,sDimStereotypes, sStereotypeSymbolName);	
			sStereotypeSymbol.setDescription(T("|Defines the stereotype of the dove graphics|"));
			sStereotypeSymbol.setCategory(category);
			
		category = T("|Hidden Line|");
			String sLineTypeName=T("|Line Type|");	
			PropString sLineType(nStringIndex++, _LineTypes.sorted(), sLineTypeName);	
			sLineType.setDescription(T("|Defines the LineType|"));
			sLineType.setCategory(category);
			
			String sLineScaleName=T("|Scale Factor|");	
			PropDouble dLineScale(nDoubleIndex++, 1, sLineScaleName,_kNoUnit);	
			dLineScale.setDescription(T("|Defines the scale factor of the linetype|"));
			dLineScale.setCategory(category);
			
			String sColorHiddenName=T("|Color| ");	
			PropInt nColorHidden(nIntIndex++, 7, sColorHiddenName);	
			nColorHidden.setDescription(T("|Defines the ColorHidden|"));
			nColorHidden.setCategory(category);


		}		
		return;		
	}
//End DialogMode//endregion

//region Properties
// Type
	String sTypeName=T("|Type|");		
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);

// Alignment	
	category = T("|Alignment|");
	String sAxisOffsetName=T("|Axis Offset|");	
	PropDouble dAxisOffset(nDoubleIndex++, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the Axis Offset|"));
	dAxisOffset.setCategory(category);
	
// Chamfer
	category = T("|Chamfer|");
	String sChamferRefName=T("|Reference Side|");	
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);	
	dChamferRef.setDescription(T("|Defines the chamfer on the reference side|"));
	dChamferRef.setCategory(category);
	
	String sChamferOppName=T("|Opposite Side|");	
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);	
	dChamferOpp.setDescription(T("|Defines the chamfer on the opposite side|"));
	dChamferOpp.setCategory(category);

// Relief Cut
	category = T("|Relief Cut|");
	String sReliefRefName=T("|Reference Side|");	
	PropDouble dReliefRef(nDoubleIndex++, U(0), sReliefRefName);	
	dReliefRef.setDescription(T("|Defines the relief cut on the reference side|"));
	dReliefRef.setCategory(category);
	
	String sReliefOppName=T("|Opposite Side|");	
	PropDouble dReliefOpp(nDoubleIndex++, U(0), sReliefOppName);	
	dReliefOpp.setDescription(T("|Defines the relief cut on the opposite side|"));
	dReliefOpp.setCategory(category);




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
		
		
		
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());	
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip  =(Sip) ents[i]; 
			if (sip.bIsValid())
				_Sip.append(sip);
		}//next i

	// Distribute
		if (_Sip.length()>2)
		{ 
			for (int i=0;i<_Sip.length()-1;i++) 
			{ 
				Sip sipA = _Sip[i];
				TslInst tslsA[] = sipA.tslInstAttached();
			reportMessage("\nA has " + tslsA.length());	
				
				for (int j=i+1;j<_Sip.length();j++)
				{ 
					Sip sipB = _Sip[j];
					
					
				// create TSL
					TslInst tslNew;				Map mapTsl;
					int bForceModelSpace = true;	
					String sExecuteKey,sCatalogName = sLastInserted;
					String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
					GenBeam gbsTsl[] = {_Sip[i], _Sip[j]};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Sip[i].ptCen()};
				
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 			
				}
			}
			eraseInstance();
			return;
		}
		else if (_Sip.length()<2)
		{ 
			reportMessage("\n"+ scriptName() + T("|This tool requires at 2 panels| ")$+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}

		return;
	}	
// end on insert	__________________//endregion

//End Part #1//endregion 


//region Get Panels and tooling coordSys
	_ThisInst.setAllowGripAtPt0(false);
	Sip sips[0]; sips = _Sip;
	Vector3d vecXC, vecYC, vecZC;
	Point3d ptRef = _Pt0;
	
	if (sips.length()<2)
	{ 
		reportMessage("\n"+ scriptName() + T("|This tool requires at 2 panels| ")$+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
// Get Type map
	Map mapType;
	int bIsDefault = true;
	for (int i=0;i<mapTypes.length();i++) 
	{ 
		Map m = mapTypes.getMap(i);
		String type  = m.getString(kType);
		if (type.find(sType,0,false)==0 && type.length() == sType.length())
		{ 
			bIsDefault = false;
			mapType = m;
			break;
		}		 
	}//next i
	
	int nColor = nc;
	PLine plShape, plTool;
	int nToolIndex = 1;
	double dMaxLength;
	double dXWidth = U(24.7466);
	double dZDepth = U(41.0637);	
	if (!bIsDefault)
	{ 
		String k;
		Map m = mapType;
		k = kToolIndex; 	if (m.hasInt(k))	nToolIndex = m.getInt(k);
		k = kColor; 		if (m.hasInt(k)) 	nColor = m.getInt(k);
		k = kShape; 		if (m.hasPLine(k))	plShape = m.getPLine(k);
		k = "Tool"; 		if (m.hasPLine(k))	plTool = m.getPLine(k);
		k = kMaxLength; 	if (m.hasDouble(k))	dMaxLength = m.getDouble(k);
		k = kXWidth; 	if (m.hasDouble(k))		dXWidth = m.getDouble(k);
		k = kZDepth; 	if (m.hasDouble(k))		dZDepth = m.getDouble(k);
		if (nToolIndex <= 0)
		{
			bIsDefault = true; // use dovetail tool
		}		
	}
	
//region Get potential tool formatting
	Map mapX;
	String sMapXKey;
	if (mapType.hasMap("ToolDescriptionFormat"))
	{ 
		String k;
		Map mapFormats, m;
					
		k="ToolDescriptionFormat";		if (mapType.hasMap(k))	m = mapType.getMap(k);
		k="Format[]";					if (m.hasMap(k))		mapFormats = m.getMap(k);
		k="MapName";					if (m.hasString(k))		sMapXKey = m.getString(k);

		for (int i=0;i<mapFormats.length();i++) 
		{ 
			m = mapFormats.getMap(i);
			//m = mapFormats.getMap(i);
			String key, format;
			k="KeyName";	if (m.hasString(k))	key = m.getString(k);
			k="Format";		if (m.hasString(k))	format = m.getString(k);
			if (key.length()>0 && format.length()>0)
				mapX.setString(key, format);
			 
		}//next i
	}
	
// write tool data to mapX
	// keys and formats being defined in the Format[] definition of the settings
	// the value of each format will be replaced by the resolved value of the key
	Map mapAdditional;
	mapAdditional.setString("Type", sType);
	mapAdditional.setInt("ToolIndex", nToolIndex);
	
	for (int i=0;i<mapX.length();i++) 
	{ 
		String format = mapX.getString(i);
		if (format.length()>0)
			mapX.setString(mapX.keyAt(i), _ThisInst.formatObject(format, mapAdditional));		 
	}//next i		
//endregion 	
	
	

//endregion

//region Detect connection
	Sip sipA=sips[0], sipB=sips[1];
	
	CoordSys csA = sipA.coordSys();
	Point3d ptOrgA = csA.ptOrg();
	Vector3d vecXA = csA.vecX();
	Vector3d vecZA = csA.vecZ();
	Body bdA = sipA.envelopeBody();//false, true);
	Point3d ptCenA = sipA.ptCen();
	double dZA = sipA.dH();	
	
	PlaneProfile ppA =bdA.getSlice(Plane(csA.ptOrg(), csA.vecZ()));
	LineSeg segA = ppA.extentInDir(sipA.vecX());
	//ppA.vis(1);

	assignToGroups(sipA, 'T');
	Group groups[] = _ThisInst.groups();
	assignToGroups(sipB, 'T');
	//Group grB = _ThisInst.groups().first();
	if (groups.length()>0)
		groups[0].addEntity(_ThisInst, false, 0, 'T');
	
	Quader qdrA(ptCenA, sipA.vecX(), sipA.vecY(), sipA.vecZ(), sipA.solidLength(), sipA.solidWidth(),sipA.solidHeight(), 0, 0, 0);

	CoordSys csB = sipB.coordSys();
	Point3d ptOrgB = csB.ptOrg();
	Vector3d vecXB = csB.vecX();
	Vector3d vecZB = csB.vecZ();
	Body bdB = sipB.envelopeBody();//false, true);
	Point3d ptCenB = sipB.ptCen();
	PlaneProfile ppB = bdB.getSlice(Plane(csB.ptOrg(), vecZB));
	LineSeg segB = ppB.extentInDir(sipB.vecX());	
	//ppB.vis(2); 	



// Connection coordSys
	int bIsParallel = vecZA.isParallelTo(vecZB);
	if (bIsParallel && abs(vecZA.dotProduct(ptOrgA - ptOrgB))>dEps)
	{
		eraseInstance();
		return;
	}
	int bIsPerpendicular = vecZA.isPerpendicularTo(vecZB);
	int bIsTConnection;
	int bIsOn;


// Evaluate parallel or mitred connections				
	Point3d ptsB[] = ppB.getGripVertexPoints();				
	for (int p=0;p<ptsB.length();p++) 
	{ 
		Point3d pt = ptsB[p];
		if (ppA.pointInProfile(pt)==_kPointOnRing && abs(csA.vecZ().dotProduct(csA.ptOrg()-pt))<dEps)
		{
			ptRef = pt;
			bIsOn = true;
			//ppA.vis(1);
			
			
			if (!bIsParallel)
			{
				vecYC = vecZA.crossProduct(vecZB);vecYC.normalize();
				Point3d pt = segA.ptMid();
				pt += vecYC * vecYC.dotProduct(ptRef- pt);
				
				Vector3d vecCA = ptRef - pt;
				vecCA.normalize();
				
				pt = segB.ptMid();
				pt += vecYC * vecYC.dotProduct(ptRef - pt);
				
				Vector3d vecCB = ptRef - pt;
				vecCB.normalize();
				
				vecXC = -vecCA - vecCB; vecXC.normalize();							
			}

			break;
		}				 
	}//next p




// Parallel connection
	if (bIsParallel)
	{ 
		if (!bIsOn)
		{ 
			reportMessage("\nError: Not a valid parallel connection");				
			//eraseInstance();
			return;
		}		
	
		vecZC = qdrA.vecD(sipB.ptCen() - sipA.ptCen());
		vecYC = vecZC.crossProduct(-vecZA);
		vecXC = vecYC.crossProduct(vecZC);

	}
// Mitred of T-Connection	
	else
	{
		vecYC = vecZA.crossProduct(vecZB);vecYC.normalize();
		
	// Get Y shadow profiles
		PlaneProfile ppYA, ppYB;
		if (bIsPerpendicular && !bIsOn)
		{ 
			vecXC = vecYC.crossProduct(vecZB);
			vecZC = vecXC.crossProduct(vecYC);
			
			ppYA = bdA.shadowProfile(Plane(ptOrgA, vecYC));		//ppYA.vis(2);
			ppYB = bdB.shadowProfile(Plane(ptOrgA, vecYC));		//ppYB.vis(20);
			PlaneProfile pp = ppYA;
			pp.intersectWith(ppYB);
			if (pp.area()>pow(dEps,2))// refuse overlappings
			{ 
				reportMessage("\nError: Overlapping connection");				
				eraseInstance();
				return;
			}
			
			pp = ppYA;
			pp.shrink(-dEps);
			pp.intersectWith(ppYB);
			if (pp.area()>pow(dEps,2))
			{ 
			// test male/female	
				LineSeg segsB[] = ppYA.splitSegments(LineSeg(ptOrgB-vecZC*U(10e4),ptOrgB+vecZC*U(10e4)), true);
				LineSeg segsA[] = ppYB.splitSegments(LineSeg(ptOrgA-vecZC*U(10e4),ptOrgA+vecZC*U(10e4)), true);
				if (segsA.length()>0) // A is male
				{ 
					ptRef = segsA.first().ptStart();
					vecXC = vecYC.crossProduct(vecZB);
					bIsTConnection = true;
				}
				else if  (segsB.length()>0) // B is male
				{ 
					_Sip.swap(0, 1);
					setExecutionLoops(2);
					return;
				}
				else
				{ 
					;// should not happen
				}
	
			}
			else
			{ 
				reportMessage("\nError: Not a valid T-connection");				
				eraseInstance();
				return;
			}			
			
		}
		else if (!bIsOn)
		{ 
			reportMessage("\nError: Not a valid Mitre-connection");	
			eraseInstance();
			return;
		}


		
		
	}
	
	vecZC = vecXC.crossProduct(vecYC);
	

//End Detect connection//endregion 

//region Get type data
	double dYHeight;
	
	double dAlfa;


	PLine plSolid, plToolModel;
	if (sType==sDefaultEntry)
	{ 
		plSolid=PLine (vecYC);
		Point3d pt = ptRef + vecXC * dAxisOffset;
		double dXWidth2 = dXWidth<U(20)?U(35):U(47);
		plSolid.addVertex(pt + vecXC * .5 * dXWidth);
		plSolid.addVertex(pt + vecXC * .5 * dXWidth2+vecZC*dZDepth);
		plSolid.addVertex(pt - vecXC * .5 * dXWidth2+vecZC*dZDepth);
		plSolid.addVertex(pt - vecXC * .5 * dXWidth);
		plSolid.addVertex(pt - vecXC * .5 * dXWidth2-vecZC*dZDepth);
		plSolid.addVertex(pt + vecXC * .5 * dXWidth2-vecZC*dZDepth);
		plSolid.close();
	}
// transform shape and detect width and depth from shape	
	else
	{ 
		Point3d pt = ptRef + vecXC * dAxisOffset;
		plSolid = plShape;
		plToolModel = plTool;
		Point3d ptX;ptX.setToAverage(plSolid.vertexPoints(true));
		CoordSys cs;
		cs.setToAlignCoordSys(ptX,_XW,_YW,_ZW, pt, vecZC, vecXC, vecYC);
		plSolid.transformBy(cs);
		if (plSolid.coordSys().vecZ().isCodirectionalTo(vecYC))
			plSolid.flipNormal();		
		
		plToolModel.transformBy(cs);
		if (plToolModel.coordSys().vecZ().isCodirectionalTo(vecYC))
			plToolModel.flipNormal();			


		 { 
			PLine pl = plToolModel.area() > pow(dEps, 2) ? plToolModel: plSolid;
			PlaneProfile pp(CoordSys(pt, vecZC, - vecXC, vecYC));
			pp.joinRing(plToolModel, _kAdd);
			PLine plRec; plRec.createRectangle(LineSeg(pt - vecXC * U(10e3), pt + vecXC * U(10e3) - vecZC * U(10e3)), vecXC, vecZC);
			pp.joinRing(plRec, _kSubtract);
	
			Point3d pts[0];
			pts= pp.intersectPoints(Plane(pt, vecZC), true, false);
			if (dXWidth<=0 && pts.length()>0)
				dXWidth = abs(vecXC.dotProduct(pts.last() - pts.first()));
			pts= pp.intersectPoints(Plane(pt, vecXC), true, false);
			if (dZDepth<=0 && pts.length()>0)
				dZDepth = abs(vecZC.dotProduct(pts.last() - pts.first()))*.5;		 	
		 }

	}
	
	if (plSolid.area()<pow(dEps,2))
	{ 
		reportMessage("\n"+ scriptName() + T("|Invalid shape contour detected| ")$+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
//endregion

//region Get common range
	Plane pn(ptRef, vecZC);
	Body bdInt(plSolid, vecYC * U(10e4), 0);
	Body bdIntA=bdA, bdIntB = bdB;
	bdIntA.intersectWith(bdInt);//bdIntA.vis(2);
	bdIntB.intersectWith(bdInt);//bdIntA.vis(4);
	double dLengthA, dLengthB;
	Point3d ptMid = ptRef;
	{
		Point3d ptsX[0], pts[0];
		
	// male
		pts= bdIntA.extremeVertices(vecYC);
		pts = Line(ptRef, vecYC).orderPoints(pts, dEps);
		if (pts.length()>0)	dLengthA = abs(vecYC.dotProduct(pts.last() - pts.first()));
		ptsX.append(pts);

	// male
		pts= bdIntB.extremeVertices(vecYC);
		pts = Line(ptRef, vecYC).orderPoints(pts, dEps);
		if (pts.length()>0)	dLengthB = abs(vecYC.dotProduct(pts.last() - pts.first()));
		ptsX.append(pts);
		
	// total
		ptsX = Line(ptRef, vecYC).orderPoints(ptsX, dEps);
		if (ptsX.length()>0)
		{
			dYHeight = abs(vecYC.dotProduct(ptsX.last() - ptsX.first()));
			ptMid += vecYC * vecYC.dotProduct(((ptsX.last() +ptsX.first())*.5)-ptMid);
		}
	}
	
	
	PlaneProfile ppC(CoordSys(ptRef, vecXC, vecYC, vecZC));
	ppC.unionWith(bdIntA.shadowProfile(pn));
	PlaneProfile ppCB = bdIntB.shadowProfile(pn);
	ppC.intersectWith(ppCB);
	
	if (dYHeight<pow(dEps,2))
	{ 
		reportMessage("\nno common range");
		eraseInstance();
		return;
	}
	
	ptRef = ppC.ptMid()+vecYC*.5*ppC.dY();
	_Pt0 = ptRef;
	vecXC.vis(ptRef, 1);
	vecYC.vis(ptRef, 3);						
	vecZC.vis(ptRef, 150);
	
	ppC.vis(40);
	CoordSys csMirr; csMirr.setToMirroring(Line(_Pt0, vecXC));	
	
//End Get common range//endregion 		

//region Trigger
// Trigger ShowTooling
	int bShowTooling = _Map.getInt("ShowTooling");
	String sTriggerShowTooling =bShowTooling?T("|Hide Tooling|"):T("|Show Tooling|");

	addRecalcTrigger(_kContextRoot, sTriggerShowTooling);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowTooling)
	{
		bShowTooling = bShowTooling ? false : true;
		_Map.setInt("ShowTooling", bShowTooling);		
		setExecutionLoops(2);
		return;
	}	
	
// Dialogs	
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

//region Trigger AddShape
	String sTriggerAddShape= T("|Edit Shape|");
	addRecalcTrigger(_kContext, sTriggerAddShape );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddShape)
	{
		int bHasShape = plShape.area() >pow(dEps,2) && plTool.area() >pow(dEps,2);
		String type = bHasShape?sType:T("|Type|");
		int color = nColor;
		int toolIndex = nToolIndex;
		double maxLength= dMaxLength;
		
		mapTsl.setInt("DialogMode",1);
		mapTsl.setInt("hasShape",bHasShape);
		
		sProps.append(type);
		sProps.append(bHasShape?kCurrentShape:kSelectShape);
		nProps.append(toolIndex);
		
		nProps.append(color);
		dProps.append(maxLength);
		
		dProps.append(dXWidth);
		dProps.append(dZDepth);
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bSelect;
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				type = tslDialog.propString(0);
				bSelect = tslDialog.propString(1) == kSelectShape;
				toolIndex= tslDialog.propInt(0);
				
				color = tslDialog.propInt(1);
				maxLength =tslDialog.propDouble(0);
							
				dXWidth=tslDialog.propDouble(1);
				dZDepth=tslDialog.propDouble(2);

			}
			tslDialog.dbErase();
			
			int bWriteSetting = bOk;
			if (bOk && bSelect)
			{
				reportNotice(TN("|To define a new type two polylines drawn in XY-World and a reference location are required.|") +
				TN("|1. The first polyline describes the symmetric shape of the solid|") +
				TN("|2. The second polyline describes the shape of the tool for one side and must be drawn in positive X-Direction|") +
				TN("|3. Pick the reference location of the tool|"));
				
				EntPLine epl1 = getEntPLine(T("|Select a shape polyline (drawn in XY-World)|"));
				EntPLine epl2 = getEntPLine(T("|Select a tool polyline (drawn in XY-World)|"));
				
				CoordSys cs;
				PlaneProfile ppShape(cs), ppTool(cs), pp3(cs);
				plTool = epl2.getPLine();
				plShape = epl1.getPLine();
				ppShape.joinRing(plShape, _kAdd);
				ppTool.joinRing(plTool, _kAdd);
				
				Point3d ptRef = ppShape.ptMid();
				ptRef.setZ(0);
				
				CoordSys cs2W;
				cs2W.setToAlignCoordSys(_Pt0, vecZC, vecXC, vecYC, ptRef, _XW, _YW, _ZW);
				PlaneProfile ppAY = bdA.shadowProfile(Plane(_Pt0, vecYC));
				PlaneProfile ppBY = bdB.shadowProfile(Plane(_Pt0, vecYC));
				ppAY.transformBy(cs2W);
				ppBY.transformBy(cs2W);
				
				// limit to double size of shape
				PlaneProfile ppX;
				double dX = ppShape.dX();
				double dY = ppShape.dY();
				
				ppX.createRectangle(LineSeg(ptRef - _XW * dX - _YW * dY, ptRef + _XW * dX + _YW * dX), _XW, _YW);
				ppAY.intersectWith(ppX);
				ppBY.intersectWith(ppX);
				
				bWriteSetting = ppShape.area() > pow(dEps, 2) && ppTool.area() > pow(dEps, 2);
				
				//region Show Jig
				PrPoint ssP(T("|Pick reference location|") + T(", |<Enter> to use midpoint of shape|"), ptRef);
				Map mapArgs;
				mapArgs.setPlaneProfile(kShape, ppShape);
				mapArgs.setPlaneProfile("tool", ppTool);
				
				mapArgs.setPlaneProfile("contourA", ppAY);
				mapArgs.setPlaneProfile("contourB", ppBY);
				
				mapArgs.setInt(kColor, color);
				
				int nGoJig = - 1;
				while (nGoJig != _kOk && nGoJig != _kNone)
				{
					nGoJig = ssP.goJig("JigAction", mapArgs);
					if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
					
					if (nGoJig == _kOk)
					{
						ptRef = ssP.value(); //retrieve the selected point
						ptRef.setZ(0);
					}
					else if (nGoJig == _kCancel)
					{
						bWriteSetting = false;
						return;
					}
				}
				//End Show Jig//endregion
			}
			
		// write settings
			if (bWriteSetting)
			{ 
				Map mapTemp;
				for (int i=0;i<mapTypes.length();i++) 
				{ 
					Map m= mapTypes.getMap(i);
					String _type  = m.getString(kType);
					if (type.find(_type,0,false)==0 && type.length() == _type.length())
					{ 
						continue;
					}					
					mapTemp.appendMap(kType, m);	 
				}//next i
				mapTypes = mapTemp;
				
				Map mapType;
				mapType.setString(kType, type);
				mapType.setPLine(kShape, plShape);
				mapType.setPLine("Tool", plTool);
				mapType.setInt(kColor, color);
				mapType.setInt(kToolIndex, toolIndex);
				mapType.setDouble(kMaxLength, maxLength);
				mapType.setDouble(kXWidth, dXWidth);
				mapType.setDouble(kZDepth, dZDepth);
				mapTypes.appendMap(kType, mapType);
				
				sType.set(type);
				
				mapSetting.setMap("Type[]", mapTypes);					
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			
		}
		setExecutionLoops(2);
		return;
		
	}
//endregion	

	String sTriggerDeleteShape= T("|Delete Shape|");
	addRecalcTrigger(_kContext, sTriggerDeleteShape );
	if (_bOnRecalc && _kExecuteKey==sTriggerDeleteShape)
	{
		mapTsl.setInt("DialogMode",2);
		sProps.append(sType);
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				String type= tslDialog.propString(0).makeLower();	
				
				Map _mapTypes;
				for (int i=0;i<mapTypes.length();i++) 
				{ 
					Map m= mapTypes.getMap(i); 
					String _type = m.getString(kType).makeLower();
					
					if (_type!=type)
						_mapTypes.appendMap(kType, m);
					 
				}//next i
				mapTypes = _mapTypes;

				mapSetting.setMap("Type[]", mapTypes);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
		
	}
	
	String sTriggerConfigShopdrawing= T("|Configure Shopdrawing|");
	addRecalcTrigger(_kContext, sTriggerConfigShopdrawing );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigShopdrawing)
	{
		mapTsl.setInt("DialogMode",3);
		
		dProps.append(dTextHeight);	
		dProps.append(dYOffsetText);	
		
		sProps.append(sTextFormat);	
		sProps.append(sStereotypeText);	
		sProps.append(sStereotypeDove);
		
		nProps.append(nColorText);	
		
		dProps.append(dLineScale);	
		sProps.append(sLineType);	
		nProps.append(nColorHidden);
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				Map m;
				m.setDouble("TextHeight", tslDialog.propDouble(0));
				m.setDouble("YOffsetText", tslDialog.propDouble(1));
				
				m.setString("TextFormat", tslDialog.propString(0));
				m.setString("StereotypeText", tslDialog.propString(1));
				m.setString("StereotypeDove", tslDialog.propString(2));
				
				m.setInt("ColorText", tslDialog.propInt(0));
				
				Map subMap;
				subMap.setInt(kColorHidden, tslDialog.propInt(1));
				subMap.setString(kLineType, tslDialog.propString(3));
				subMap.setDouble(kLineScale, tslDialog.propDouble(2));
				m.setMap(kHiddenLine, subMap);
				
				mapSetting.setMap("Shopdrawing", m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
		
	}

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

//endregion	

//region Get Tool Solid
	PlaneProfile ppToolSolid(CoordSys(ptMid, vecXC, -vecZC, vecYC));
	{
		PLine pl = plToolModel;
		ppToolSolid.joinRing(pl, _kAdd);	
		pl.transformBy(csMirr);
		ppToolSolid.joinRing(pl, _kAdd);
	}
	//ppToolSolid.vis(3);
	PLine rings[] = ppToolSolid.allRings(true, false);
	
	Body bdTool;
	if (rings.length()>0)
	{ 
		bdTool=Body(rings.first(), vecYC * (dYHeight + 2*dEps), 0);
		
		if (bShowTooling && bIsDefault)
		{ 
			SolidSubtract sosu(bdTool,_kSubtract);
			//sosu.cuttingBody().vis(2);
			sips[0].addTool(sosu);
			sips[1].addTool(sosu);
		}		
//		Body bdInt = bdA;
//		bdInt.intersectWith(bd);
//		bdTool = bdInt;
//		
//		bdInt = bdB;
//		bdInt.intersectWith(bd);
//		bdTool.combine(bdInt);				
		//bdTool.vis(6);
		

	}
	
	Plane pnYC(_Pt0, vecYC);
	PlaneProfile ppYA = bdA.shadowProfile(pnYC);
	PlaneProfile ppYB = bdB.shadowProfile(pnYC);
		
//endregion 


//region Tools
// Export Tool Body	
	Map mapFaro;
	if (bdTool.volume()>pow(dEps,3))
	{ 
		mapFaro.setBody("ToolSolid", bdTool);//bdTool.vis(6);
		mapFaro.setInt("Tolerance", 75);		
	}
	
	
// Doves
	if (bIsDefault)
	{ 
		Dove dvMale(ptRef,vecXC,vecYC,-vecZC,dXWidth,dYHeight,dZDepth, dAlfa,_kFemaleEnd);
		dvMale.setContinuousMortise(true);
		dvMale.setDoSolid(false);//bShowTooling	
		
	// HSB-14226
		if (sMapXKey.length()>0 && mapX.length()>0)
			dvMale.setSubMapX(sMapXKey, mapX);	
		if (mapFaro.length()>0)
			dvMale.setSubMapX("Faro", mapFaro);
		
		sips[0].addTool(dvMale);
		
		Dove dvFemale(ptRef,vecXC,vecYC,vecZC,dXWidth,dYHeight,dZDepth, dAlfa,bIsTConnection?_kFemaleSide:_kFemaleEnd);
		dvFemale.setContinuousMortise(true);
		dvFemale.setDoSolid(false);//bShowTooling	

	// HSB-14226
		if (sMapXKey.length()>0 && mapX.length()>0)
			dvFemale.setSubMapX(sMapXKey, mapX);	
		if (mapFaro.length()>0)
			dvFemale.setSubMapX("Faro", mapFaro);
		
		sips[1].addTool(dvFemale);		
	}
// Freeprofile Tool
	else
	{ 
		
		
		FreeProfile fp1(plToolModel, _Pt0);
		//fp1.setDepth(dOffsetZ);
		fp1.setCncMode(nToolIndex);
		fp1.setCutDefiningAsOne(true);
		fp1.setDoSolid(bShowTooling);
		if (mapFaro.length()>0)
			fp1.setSubMapX("Faro", mapFaro);
		
	// HSB-14226
		if (sMapXKey.length()>0 && mapX.length()>0)
			fp1.setSubMapX(sMapXKey, mapX);

		sips[1].addTool(fp1);

		plToolModel.transformBy(csMirr);
		if (!plToolModel.coordSys().vecZ().isCodirectionalTo(vecYC))
			plToolModel.flipNormal();

		FreeProfile fp0(plToolModel, _Pt0);
		//fp0.setDepth(dOffsetZ);
		fp0.setCncMode(nToolIndex);
		fp0.setCutDefiningAsOne(true);
		fp0.setDoSolid(bShowTooling);
		if (mapFaro.length()>0)
			fp0.setSubMapX("Faro", mapFaro);
	
	// HSB-14226
		if (sMapXKey.length()>0 && mapX.length()>0)
			fp0.setSubMapX(sMapXKey, mapX);
		
		sips[0].addTool(fp0);		
		
	}

	
// Chamfers	
	double dChamfers[] = { dChamferRef, dChamferOpp};
	for (int i=0;i<dChamfers.length();i++) 
	{ 
		double c = dChamfers[i]; 
		if (c<dEps)
		{ 
			continue;
		}
		
		
		int nFace = i == 0 ?- 1 : 1;
		Vector3d vecFace = vecZA * nFace;	
		if (bIsPerpendicular)
		{
			if (vecFace.dotProduct(vecXC)<0)
				c *= 2;
			else 
				continue;
		}
		Plane pn(sipA.ptCen()+vecFace*.5*sipA.dH(), vecFace);
		
		Vector3d vecXBc = vecXC;
		if (vecXBc.dotProduct(vecFace) < 0)vecXBc *= -1;
		Vector3d vecYBc = vecXC.crossProduct(vecYC);
		Point3d pt;
		
		double a = c* sin(45);
		if (Line(ptMid, vecXC).hasIntersection(pn, pt))
		{ 
			CoordSys cs;
			if (!bIsParallel && !bIsPerpendicular)
			{
				Point3d pt1 = pt - vecXBc * a;pt1.vis(7);
				cs.setToRotation(45*-nFace, vecYC, pt1);
				Vector3d vec = vecXBc;
				vec.transformBy(cs);
				Point3d pt2 = pt1 + vec * c;
				pt2.vis(2);
				
				Point3d pt3;
				Line(pt2, vecXC).hasIntersection(pn, pt3);
				pt3.vis(3); 
				
				double d = vecXBc.dotProduct(pt3 - pt2);
				pt += vecXBc * d;
				
			}
			
			
			//pt.vis(i);
			
			BeamCut bc(pt, vecXBc,vecYBc, vecYC, c, c, dYHeight * 1.2, 0, 0, 0);
			cs.setToRotation(45, vecYC, pt);
			bc.transformBy(cs);
			
			//bc.cuttingBody().vis(1);
			Body bd = bc.cuttingBody();
			PlaneProfile ppBc = bd.shadowProfile(pnYC);
			ppYA.subtractProfile(ppBc);
			ppYB.subtractProfile(ppBc);
			
			
			
			
			if (bIsTConnection)
				sipA.addTool(bc);
			else
				bc.addMeToGenBeamsIntersect(sips);
		}
		
		
		 
	}//next i

//region Relief Cut
	if (dReliefRef>dEps || dReliefOpp>dEps)
	{ 
		Point3d ptCenA = sipA.ptCen();
		double dZA = sipA.dH();
		double a2 = dChamferOpp* sin(45);
		
		Point3d pt1, pt2;
		
		Vector3d vecRef = vecXC;
		if (vecRef.dotProduct(vecZA) < 0)vecRef *= -1;
		
		Vector3d vecDir = qdrA.vecD(vecZC);
		{ 
			Point3d pt = ptCenA;
			pt += vecYC * vecYC.dotProduct(ptMid - pt);
			if (vecDir.dotProduct(ptMid - pt) < 0)vecDir *= -1;
		}
		
		Plane pnRef(ptCenA - vecZA*(.5*dZA-dChamferRef * sin(45)), vecZA);
		int bOk1 = Line(ptMid, vecRef).hasIntersection(pnRef, pt1);
		
		Plane pnOpp(ptCenA +vecZA*(.5*dZA-dChamferOpp * sin(45)), vecZA);
		int bOk2 = Line(ptMid, -vecRef).hasIntersection(pnOpp, pt2);		
		
	// Male/Female
		for (int i=0;i<2;i++) 
		{ 
			int n = i == 0 ? 1 :- 1;
			
			Point3d pt3 = pt1 - n*vecDir * .5 * dReliefRef;pt3.vis(4);
			Point3d pt4 = pt2 - n*vecDir * .5 * dReliefOpp;pt4.vis(5);
			Vector3d vecX = pt4 - pt3; vecX.normalize();
			Vector3d vecY= vecX.crossProduct(-vecDir); vecY.normalize();
			Vector3d vecZ= n*vecX.crossProduct(vecY); vecZ.normalize();
			//vecZ.vis(pt1,150);
			
			Cut ct(pt3, vecZ);
			if (sips.length()>i)sips[i].addTool(ct, 1);
			
		}
	}		
//End Relief Cut//endregion 

//End Tools//endregion 


//region Display
	int nt = 60;
	Display dp(nColor), dpElement(nColor);
	dp.showInDxa(true);
	dp.addHideDirection(vecZA);
	dp.addHideDirection(-vecZA);
	dp.showInDxa(true);// HSB-23003
	dpElement.showInDxa(true);
	dpElement.addViewDirection(vecZA);
	dpElement.addViewDirection(-vecZA);
	dpElement.showInDxa(true);// HSB-23003
	
	
	plSolid.transformBy(vecYC * vecYC.dotProduct(ptMid - plSolid.coordSys().ptOrg()));
	PlaneProfile pp(CoordSys(ptMid, vecXC, -vecZC, vecYC));
	pp.joinRing(plSolid,_kAdd);
	PlaneProfile ppSub=pp;
	ppSub.shrink(U(2));
	pp.subtractProfile(ppSub);
	dp.draw(pp, _kDrawFilled, nt);

	Body bdShape(plSolid, vecYC * 2*dYHeight, 0);
	{ 
		Body bdInt = bdA;
		bdInt.intersectWith(bdShape);
		Body bdX = bdInt;
		
		bdInt = bdB;
		bdInt.intersectWith(bdShape);
		bdX.combine(bdInt);
		if (dMaxLength>0 && bdX.lengthInDirection(vecYC)>dMaxLength)
			dp.color(1);
		bdShape = bdX;	
		dp.draw(bdShape);	
			
	}




// draw section in element view
	PlaneProfile ppToolShadowZ = bdTool.shadowProfile(Plane(_Pt0, vecZA));
	PlaneProfile ppShapeShadowZ = bdShape.shadowProfile(Plane(_Pt0, vecZA));
	dpElement.draw(ppToolShadowZ);
	dpElement.draw(ppToolShadowZ, _kDrawFilled,90);

	PLine plinesA[0], plinesB[0]; // segmented plines of the the tool shape per panel
	for (int i=0;i<2;i++) 
	{ 
		PlaneProfile ppToolY = i==0?ppYA:ppYB;
		ppToolY.intersectWith(ppToolSolid);
		PLine rings[] = ppToolY.allRings(true, false);
		if (rings.length()>0)
		{ 
			PLine plines[0];
			PLine ring = rings.first();
			Point3d pts[] = ring.vertexPoints(false);
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p+1];
				Point3d ptm = (pt1 + pt2) * .5;
				if (abs(vecZC.dotProduct(ptm - _Pt0)) < dEps)continue;
				PLine pl(vecYC);
				pl.addVertex(pt1);
				if (ring.isOn(ptm))
					pl.addVertex(pt2);
				else
					pl.addVertex(pt2, ring.getPointAtDist(ring.getDistAtPoint(pt1)+dEps));
				//pl.vis(p); 
				plines.append(pl); 
			}//next p
			if (i == 0)plinesA = plines;
			else plinesB = plines;
		}
	}
	
	//ppToolAY.vis(1);
//	ppBox.vis(3);

//End Display//endregion 

// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =sipA.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)sipA;
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
		HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Greenethic");
		
		hwc.setModel(sType);
		hwc.setName(sType);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(sipA);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(bdShape.lengthInDirection(vecYC));
		hwc.setDScaleY(pp.dX());
		hwc.setDScaleZ(pp.dY());
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}



// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion





//region Map Requests
	Map mapRequests;
	
// redraw tool shape
	if (!bShowTooling)
	{ 
		Map mapRequest;
		mapRequest.setInt(kColor, nColor);
		mapRequest.setVector3d("AllowedView", vecYC);	
		mapRequest.setInt("AlsoReverseDirection",true);		
		mapRequest.setString("Stereotype", sStereotypeDove);	
		mapRequest.setInt(kColor, 242);
		for (int i=0;i<2;i++) 
		{ 	
			PLine plines[0];
			plines = i == 0 ? plinesA : plinesB;
			mapRequest.setString("ParentUID", i==0?sipA.handle():sipB.handle());
			for (int j=0;j<plines.length();j++) 
			{ 
				//plines[j].projectPointsToPlane(Plane((i==0?sipA.ptCen():sipB.ptCen()), vecYC), vecYC);
				plines[j].vis(3);
				mapRequest.setPLine("PLine", plines[j]);
				mapRequests.appendMap("DimRequest",mapRequest);		 
			}//next j
		}	
	}
	
// Dimension
	for (int i=0;i<2;i++) 
	{ 	
		Vector3d vecPerpDim = vecZC;
		Sip sipParent = sipA;
		if (i==1)
		{ 
			vecPerpDim *= -1;
			sipParent = sipB;
		}
//				_Sip[k].plEnvelope().vis(k + 2);
//				(vecDir).vis(pt, 2);
		Map mapRequest;
		mapRequest.setString("DimRequestPoint", "DimRequestPoint");
		mapRequest.setString("Stereotype", sStereotypeDove);
		mapRequest.setPoint3d("ptRef",ptRef );
		mapRequest.setVector3d("vecDimLineDir", vecPerpDim.crossProduct(vecYC) );//
		mapRequest.setVector3d("vecPerpDimLineDir", vecPerpDim);
		//legacy sd_EntitySymbolDisplay
		mapRequest.setVector3d("vecX", vecPerpDim.crossProduct(vecYC) );//vecDimLineDir
		mapRequest.setVector3d("vecY", vecPerpDim);	//vecPerpDimLineDir		
		
		mapRequest.setString("ParentUID", sipParent.handle());
		mapRequest.setInt("Color", 242);
		mapRequest.setVector3d("AllowedView", vecYC);				
		mapRequest.setInt("AlsoReverseDirection", true);
		
		mapRequests.appendMap("DimRequest",mapRequest);					
	
	}	
	

// Text
	{
		String text;
		Map mapRequest;

		mapRequest.setInt(kColor, nColorText);
		if (dTextHeight>0)mapRequest.setDouble("textHeight", dTextHeight);
		mapRequest.setVector3d("AllowedView", vecZA);	
		mapRequest.setInt("AlsoReverseDirection",true);
		mapRequest.setInt("deviceMode",_kDevice);
		mapRequest.setDouble("dXFlag",0);
		mapRequest.setDouble("dYFlag",0);
		mapRequest.setString("Stereotype", sStereotypeText);

	// male	
		mapAdditionalVariables.setDouble("Length", dLengthA);
		text = _ThisInst.formatObject(sTextFormat, mapAdditionalVariables);
		mapRequest.setString("text", text);
		mapRequest.setString("ParentUID", sipA.handle());
		mapRequest.setPoint3d("ptLocation", ptMid+vecZC*dYOffsetText);
		mapRequest.setVector3d("vecX", vecZC.crossProduct(-vecZA));
		mapRequest.setVector3d("vecY", vecZC);		
		mapRequests.appendMap("DimRequest",mapRequest);

	// female
		mapAdditionalVariables.setDouble("Length", dLengthB);
		text = _ThisInst.formatObject(sTextFormat, mapAdditionalVariables);	
		mapRequest.setString("text", text);
		mapRequest.setString("ParentUID", sipB.handle());
		mapRequest.setPoint3d("ptLocation", ptMid - vecZC * dYOffsetText); //Point3d(ptMid - vecZC * dYOffsetText).vis(7);
		mapRequest.setVector3d("vecX", -vecZC.crossProduct(-vecZA));
		mapRequest.setVector3d("vecY", -vecZC);		
		mapRequests.appendMap("DimRequest",mapRequest);	

		
	// tool shadow in vecZ
		//ppToolShadowZ.vis(2);
		LineSeg segs[0];
		{ 
			Point3d pts[] = ppToolShadowZ.getGripVertexPoints();
			for (int p=0;p<pts.length();p++) 
			{ 
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p<pts.length()-1?p+1:0];
				LineSeg seg(pt2,pt1);
				if ((pt2-pt1).isParallelTo(vecYC))
					segs.append(seg); 
			}//next p			
		}




		
		
	// vecZ view	
		PlaneProfile ppA = bdA.shadowProfile(Plane(_Pt0, vecXC));
		PlaneProfile ppB = bdB.shadowProfile(Plane(_Pt0, vecXC));
		mapRequest = Map();
		mapRequest.setString("ParentUID", sipA.handle());
		mapRequest.setString("lineType", sLineType);
		mapRequest.setDouble("lineTypeScale", dLineScale);
		mapRequest.setInt("Color", nColorHidden);
		mapRequest.setVector3d("AllowedView", vecXC);
		mapRequest.setInt("AlsoReverseDirection", true);		
		for (int i=0;i<segs.length();i++) 
		{ 
			mapRequest.setString("ParentUID", sipA.handle());
			LineSeg _segs[] = ppA.splitSegments(segs[i], true);
			for (int ii=0;ii<_segs.length();ii++) 
			{ 
				LineSeg seg= _segs[ii]; 
				mapRequest.setPLine("pline", PLine(seg.ptStart(), seg.ptEnd()));
				mapRequests.appendMap("DimRequest",mapRequest);
			}//next ii
			//segs[i].vis(6); 

			mapRequest.setString("ParentUID", sipB.handle());
			_segs = ppB.splitSegments(segs[i], true);
			for (int ii=0;ii<_segs.length();ii++) 
			{ 
				LineSeg seg= _segs[ii]; 
				mapRequest.setPLine("pline", PLine(seg.ptStart(), seg.ptEnd()));
				mapRequests.appendMap("DimRequest",mapRequest);
			}//next ii
		}//next i
	
		

	}
	
// publish dim requests	
	if (mapRequests.length()>0)
	{
		_Map.setMap("DimRequest[]", mapRequests);	
	}
	else
		_Map.removeAt("DimRequest[]", true);
//End Map Requests//endregion 











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
        <int nm="BreakPoint" vl="690" />
        <int nm="BreakPoint" vl="737" />
        <int nm="BreakPoint" vl="733" />
        <int nm="BreakPoint" vl="654" />
        <int nm="BreakPoint" vl="187" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23003: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/5/2024 9:50:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14406 description text corrected for block or rule set consumption" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/18/2022 9:52:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14406 pline display in shopdrawings when tool not shown" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/17/2022 3:37:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14233 faro export unified" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/22/2021 5:17:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14233 supports tool description format, Faro-, Share-, Make-Exports, Dove or Freeprofile tool via tool index, new method to define shapes" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/22/2021 11:40:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11513 drawing of additional graphics supported, context command added for setup" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/14/2021 10:28:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11513 new tool to create X-Fix-L connections" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/13/2021 5:02:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End