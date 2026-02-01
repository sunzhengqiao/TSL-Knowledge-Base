#Version 8
#BeginDescription
#Versions:
Version 2.3 03.09.2024 HSB-22614 tag placement improved, color consider pack color if set to -2, new white background, new property access

Version 2.2 28.06.2023 HSB-19334: get from xml flag "PropertyReadOnly" 
Version 2.1 27.06.2023 HSB-19334: On insert set properties to readOnly for KLH 
HSB-9338 internal naming bugfix

accepts any format key, invalid keys are ignored, new line is now specified by '\\'
bugfix new syntax

tags projected to world 
completely revised requires 21.0.32 or higher 

new settings to override default colors of tag linework and background
posnum locations kept static to increase performance, new trigger to update location

This tsl creates tags of stacked items



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords 
#BeginContents
/// <History>//region
/// #Versions:
// 2.3 03.09.2024 HSB-22614 tag placement improved, color consider pack color if set to -2, new white background, new property access , Author Thorsten Huck
// 2.2 28.06.2023 HSB-19334: get from xml flag "PropertyReadOnly" Author: Marsel Nakuci
// 2.1 27.06.2023 HSB-19334: On insert set properties to readOnly for KLH Author: Marsel Nakuci
/// <version value="2.0" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.9" date="07mar2019" author="thorsten.huck@hsbcad.com"> accepts any format key, invalid keys are ignored, new line is now specified by '\\' </version>
/// <version value="1.8" date="06mar2019" author="thorsten.huck@hsbcad.com"> bugfix new syntax </version>
/// <version value="1.7" date="22mar2018" author="thorsten.huck@hsbcad.com"> tags projected to world </version>
/// <version value="1.6" date="21mar2018" author="thorsten.huck@hsbcad.com"> completely revised, requires 21.0.32 or higher </version>
/// <version value="1.5" date="27oct2017" author="thorsten.huck@hsbcad.com"> posnum location prefers horizontal offset </version>
/// <version value="1.4" date="11oct2017" author="thorsten.huck@hsbcad.com"> new settings to override default colors of tag linework and background </version>
/// <version value="1.3" date="11jul2017" author="thorsten.huck@hsbcad.com"> posnum locations kept static to increase performance, new trigger to update location </version>
/// <version value="1.2" date="10jul2017" author="thorsten.huck@hsbcad.com"> bugfix sequential coloring </version>
/// <version value="1.1" date="06jul2017" author="thorsten.huck@hsbcad.com"> the color of the text is using the sequential color of the referenced entity </version>
/// <version value="1.0" date="03jul2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select truck, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates tags of stacked items.
/// </summary>//endregion
	


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

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	int whiteBackground = rgb(255,255,254);
	
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
	
	int bPropertyReadOnly;
//Constants //endregion


//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	

		category = T("|Linework|");
			String sHideLineworkName=T("|Hide Linework|");	
			PropString sHideLinework(nStringIndex++, sNoYes, sHideLineworkName);	
			sHideLinework.setDescription(T("|Defines the linework will be hidden|"));
			sHideLinework.setCategory(category);
			
		category = T("|Background|");
			String sColorBackName=T("|Color|");	
			PropInt nColorBack(nIntIndex++, 7, sColorBackName);	
			nColorBack.setDescription(T("|Defines the color|") + T(", |'16777214' to use almost white true color|"));
			nColorBack.setCategory(category);

			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 1, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the Transparency|"));
			nTransparency.setCategory(category);
			
		category = T("|Guideline|");
			String sLineTypeName=T("|LineType|");	
			PropString sLineType(nStringIndex++, _LineTypes.sorted(), sLineTypeName);	
			sLineType.setDescription(T("|Defines the LineType|"));
			sLineType.setCategory(category);
			
			String sLineTypeScaleName=T("|Linetype Scale|");	
			PropDouble dLineTypeScale(nDoubleIndex++, 1, sLineTypeScaleName,_kNoUnit);	
			dLineTypeScale.setDescription(T("|Defines the scale of the linetype|"));
			dLineTypeScale.setCategory(category);


		}			
		return;		
	}
//End DialogMode//endregion



//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="f_Stacking";
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

	{ 
		String k;
		k="PropertyReadOnly"; if (mapSetting.hasInt(k)) bPropertyReadOnly= mapSetting.getInt(k);
	}
	




//End Settings//endregion	







//region Properties
	int nStartTick;
	if (bDebug)nStartTick=getTickCount();
	
	String sTruckKey = "Hsb_TruckParent";
	
	String sSourceAttributes[]={"Posnum","Name","Information","Label","Sublabel",
		"Material", 
		"Length", "Width","Height"};
	
	String sAttributeDescription =T("|Defines the format of the composed value.|")+
		TN("|Samples|")+
		TN("   @(Label)@(SubLabel)")+
		TN("   @(Label:L2) |the first two characters of Label|")+
		TN("   @(Label:T1; |the second part of Label if value is separated by blanks, i.e. 'EG AW 2' will return AW'|)")+
		TN("   @(Width:RL1) |the rounded value of width with one decimal.|")+
		TN("R |Right: Takes the specified number of characters from the right of the string.|")+
		TN("L |Left: Takes the specified number of characters from the left of the string.|")+
		TN("S |SubString: Given one number will take all characters starting at the position (zero based).|")+
		T(" |Given two numbers will start at the first number and take the second number of characters.|")+
		TN("T |​Tokeniser: Returns the member of a delimited list using the specified index (zero based). A delimiter can be specified as an optional parameter with the default delimiter being the semcolon character..|")+
		TN("# |Rounds a number. Specify the number of decimals to round to. Trailing zero's are removed.|")+
		TN("RL |​Round Local: Rounds a number using the local regional settings..|");
	
// Content
	category=T("|Content|");

	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "@(Posnum)", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + sAttributeDescription + 
		TN("backslash '\\' separates multiple lines|"));
	sAttribute.setCategory(category);

	String sStyleName=T("|Style|");	
	String sStyles[] = {T("|Text only|"), T("|Border|"), T("|Filled Frame|")};
	PropString sStyle(nStringIndex++, sStyles, sStyleName,0);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);
	
// strategy
	category = T("|Strategy|");
	String sStrategies[] = { T("|Stacking Layer|"), T("|Stacking Layer|+") + T("|Grid|")};//, T("|3x3|"), T("|3x3|+") + T("|Grid|")};
	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(nStringIndex++, sStrategies, sStrategyName);	
	sStrategy.setDescription(T("|Defines the Strategy|"));
	sStrategy.setCategory(category);
	
//Display
	category = T("|Display|");
	
	
// order dimstyles
	String sDimStyles[0];sDimStyles = _DimStyles;
	for (int i=0;i<sDimStyles.length();i++)
		for (int j=0;j<sDimStyles.length()-1;j++)
		{
			String s1 = sDimStyles[j];
			String s2 = sDimStyles[j+1];
			if (s1.makeLower()>s2.makeLower())
				sDimStyles.swap(j,j+1);	
		}
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);
	sDimStyle.setCategory(category);	
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -2, sColorName);	
	nColor.setDescription(T("|Defines the color.|") + T(" |-2 = byEntity, -1 = byLayer, 0 = byBlock, >0 = color index|"));
	nColor.setCategory(category);		
//endregion 


//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		Map mapTsl;	
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if(bPropertyReadOnly)
		{ 
		// HSB-19334: set to readOnly
			sAttribute.setReadOnly(_kReadOnly);
			sStyle.setReadOnly(_kReadOnly);
			sStrategy.setReadOnly(_kReadOnly);
			sDimStyle.setReadOnly(_kReadOnly);
			nColor.setReadOnly(_kReadOnly);
			_Map.setInt("readOnly",true);
			mapTsl.setInt("readOnly",true);
		}
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(tLastInserted);					
		}	
		else	
			showDialog();

	// prepare tsl cloning
		TslInst tslNew;			Vector3d vecXTsl= _XE;		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};	Entity entsTsl[1];			Point3d ptsTsl[1];// = {};
		int nProps[]={nColor};	double dProps[]={dTextHeight};			String sProps[]={sAttribute, sStyle,sStrategy, sDimStyle};
//		Map mapTsl;	
		String sScriptname = scriptName();


	// prompt for tsls
		Entity ents[0];
		PrEntity ssE(T("|Select truck(s)|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// insert only on trucks
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst truck=(TslInst)ents[i];
			if (truck.bIsValid() && truck.subMapXKeys().find(sTruckKey)>-1)
			{ 
				entsTsl[0] = truck;
				ptsTsl[0]=truck.ptOrg();
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
				if (tslNew.bIsValid())
					tslNew.setPropValuesFromCatalog(tLastInserted);
			}
		}
		
		
	// erase caller	
		eraseInstance();
		return;
	}			
//endregion 


//region Settings background and linework
	int nColorBackground = whiteBackground;
	int nTransparencyBackground = 1;
	int bHideLinework;
	double dLineTypeScale = 1;
	String sLineType;
	{
		
		
		
		String k;
		Map m= mapSetting.getMap("Tag\\Background");
		k="Color";				if (m.hasInt(k))	nColorBackground = m.getInt(k);
		k="Transparency";		if (m.hasInt(k))	nTransparencyBackground = m.getInt(k);
		
		m= mapSetting.getMap("Tag\\Linework");
		k="Hide";				if (m.hasInt(k))	bHideLinework = m.getInt(k);	
		
		m= mapSetting.getMap("Tag\\Guideline");
		k="LineType";				if (m.hasString(k))	sLineType = m.getString(k);
		k="LineTypeScale";			if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
		if (dLineTypeScale <= 0)dLineTypeScale = 1;
	}	
	
//endregion 



// validate
	if (_Entity.length()<1 || _Entity[0].subMapXKeys().find(sTruckKey)<0)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Not a valid truck reference.|"));
		eraseInstance();
		return;
	}
	
	
// sequential colors
	int nSeqColors[0];
// these colors are used to replace the index colors by the given value.

// prefer package sequential colors
	Map mapColors = mapSetting.getMap("Package\\SequentialColor[]");
// if nothing found try truck sequential colors
	if (mapColors.length()<1)mapColors= mapSetting.getMap("Truck\\SequentialColor[]");	
	for (int i=0;i<mapColors.length();i++) 
		nSeqColors.append(mapColors.getInt(i)); 

	

	
// get truck
	TslInst truck = (TslInst)_Entity[0];
	if (!truck.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Not a valid truck reference.|"));
		eraseInstance();
		return;
	}
	
	if(bPropertyReadOnly)
	{ 
		int nReadOnly=!_Map.getInt("readOnly");
		if(nReadOnly)
		{ 
			sAttribute.setReadOnly(_kReadOnly);
			sStyle.setReadOnly(_kReadOnly);
			sStrategy.setReadOnly(_kReadOnly);
			sDimStyle.setReadOnly(_kReadOnly);
			nColor.setReadOnly(_kReadOnly);
		}
		else
		{ 
			sAttribute.setReadOnly(false);
			sStyle.setReadOnly(false);
			sStrategy.setReadOnly(false);
			sDimStyle.setReadOnly(false);
			nColor.setReadOnly(false);
		}
		String sTriggerblockProperties = T("|Unblock Properties|");
		if(!nReadOnly)
			sTriggerblockProperties = T("|Block Properties|");
		addRecalcTrigger(_kContextRoot, sTriggerblockProperties);
		if (_bOnRecalc && _kExecuteKey==sTriggerblockProperties)
		{
			_Map.setInt("readOnly",nReadOnly);
			setExecutionLoops(2);
			return;
		}//endregion
	}
	
// Trigger Add or Remove Format from property
	String sTriggerAddFormat = T("|Add Format|");
	addRecalcTrigger(_kContext, sTriggerAddFormat);
	String sSetFormatTriggers[0],sTranslatedFormatTriggers[0];
// translate and order	
	for (int i=0;i<sSourceAttributes.length();i++)
	{
		sSetFormatTriggers.append(sSourceAttributes[i]);
		sTranslatedFormatTriggers.append(T("|" + sSourceAttributes[i] + "|"));
	}
	for (int i=1;i<sTranslatedFormatTriggers.length();i++)
		for (int j=1;j<sTranslatedFormatTriggers.length()-1;j++)
			if(sTranslatedFormatTriggers[j]>sTranslatedFormatTriggers[j+1])
			{ 
				sTranslatedFormatTriggers.swap(j, j + 1);
				sSetFormatTriggers.swap(j, j + 1);
				
			}
	
	for (int i=0;i<sSetFormatTriggers.length();i++) 
	{ 
		String sTrigger = sSetFormatTriggers[i];
		String sTransTrigger = sTranslatedFormatTriggers[i];
		String sFormat = "@(" + sTrigger + ")";
		int bAdd = sAttribute.find(sTrigger, 0) <0;
		sTransTrigger = (bAdd ? "   + " : "   - ") + sTransTrigger;
		addRecalcTrigger(_kContext, sTransTrigger);
		int bDebugThis = false;//bDebug && _kExecuteKey != sTransTrigger;
		if ((_bOnRecalc && _kExecuteKey==sTransTrigger) || bDebugThis)
		{
			if (bAdd && !bDebugThis)
			{
				sAttribute.set(sAttribute + (sAttribute.length()>0?";":"")+sFormat);
			}
			else
			{ 
				int a=sAttribute.find("@(" + sSetFormatTriggers[i],0);	
				if (a < 0){continue;}
				int b=sAttribute.find(")",a);	
				String left = sAttribute.left(a);
				String right = sAttribute.right(sAttribute.length() - b-1);
				sFormat = left + right;
				if(!bDebugThis)
					sAttribute.set(sFormat.trimLeft().trimRight());
			}
			if (!bDebugThis)
			{
				setExecutionLoops(2);
				return;
			}
			
		}		
	}
	
	
// coordSys	
	Vector3d vecX=_XW, vecY=_YW, vecZ=_ZW;	
	vecZ.vis(_Pt0,150);
	_ThisInst.setDrawOrderToFront(50);
	Plane pnW(_Pt0,vecZ);
	CoordSys csW(_Pt0, vecX, vecY, vecZ);
	
	int nStyle = sStyles.find(sStyle);
	int nStrategy = sStrategies.find(sStrategy,0);
	
// displays
	Display dpWhite(nColorBackground),dp(nColor);
	if (nColorBackground > 256)dpWhite.trueColor(nColorBackground);

	dp.dimStyle(sDimStyle);
	double dFactor = 1;
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);	
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}
	dTextHeightStyle=dTextHeightStyle<U(10)?U(10):dTextHeightStyle;	
	
// declare protection profile
	PlaneProfile ppProtect(csW);
	
// get referenced item entities
	Entity ents[] = truck.map().getEntityArray("EntityRef[]", "", "Handle");
	
// purge invalid entities
	for (int i=ents.length()-1; i>=0 ; i--) 
	{ 
		Entity ent = ents[i];
		if (!ent.bIsValid())
		{
			ents.removeAt(i); 
			continue;
		}
		
	// get potential item
		Map mapItem = ent.subMapX("Hsb_ItemParent");
		Entity item;
		item.setFromHandle(mapItem.getString("MyUid"));
		
	// get potential layer of item
		if (!item.bIsValid())		
		{
			ents.removeAt(i); 
		}		
	}
	
// get referenced items and layers by handle
	int nNum = ents.length();
	Entity items[0];
	TslInst layers[0];
	int nRefIndices[0];
	String sLayerHandles[0]; int nLayerColors[0], nItemColors[0];
	CoordSys csLayer2Trucks[0];
	int nTagColors[0];
	Body bdAll[0];
	int nLayerHandles[0];
	Point3d ptsLocs[0];
	
//region collect items
	for (int i=0;i<ents.length();i++)
	{
		Entity ent = ents[i];
		
		 
		
		int nLayerHandle = - 1;
		int nTagColor=nColor;
		// get potential item
		Map mapItem = ent.subMapX("Hsb_ItemParent");
		Entity item;
		item.setFromHandle(mapItem.getString("MYUID"));
		Point3d ptLoc = mapItem.getPoint3d("ptCen");
		if (!item.bIsValid())continue;
		
	// find layer and transformation	
		String sLayerHandle = item.subMapX("Hsb_LayerParent").getString("MYUID");
		nLayerHandle = sLayerHandles.find(sLayerHandle);
		CoordSys csLayer2Truck;
		
	// find potential package
		String sPackHandle = item.subMapX("Hsb_PackageParent").getString("ParentUID");
		Entity entPack;
		entPack.setFromHandle(sPackHandle);
		TslInst pack = (TslInst)entPack;

		
	//region layer not collected yet
		int nLayerColor = nColor;
		if (nLayerHandle<0)
		{
			Entity entLayer;	entLayer.setFromHandle(sLayerHandle);
			TslInst layer = (TslInst)entLayer;
			if ( ! layer.bIsValid())continue;
			
		// get row and transformation from grid to truck	
			int row=-1, column=-1;
			
			Map m =layer.subMapX("Hsb_Layer2Truck");
			if (m.length()>0)
			{
				csLayer2Truck=CoordSys(m.getPoint3d("ptOrg"), m.getVector3d("vecX"),m.getVector3d("vecY"), m.getVector3d("vecZ"));	
				row = m.getInt("row");	
				column = m.getInt("column");
				csLayer2Trucks.append(csLayer2Truck);
			}
			else
			{
				continue;
			}
		
		// get sequential color, get text color to seq color by row of layer	
		// set the color
			if (nColor==-2 && nSeqColors.length()>0)
			{
				int n=row;
				if (pack.bIsValid())
					n = pack.propInt(0);
				while(n>nSeqColors.length()-1)
				{
					n-=nSeqColors.length();
				}
				nLayerColor=nSeqColors[n];
			}
			
			
			
			
		// collect layer and layer to truck transformation
			sLayerHandles.append(sLayerHandle);
			nLayerColors.append(nLayerColor);
			nLayerHandle=sLayerHandles.length()-1;
			layers.append(layer);			
		}//endregion
	//region layer is collected
		else
		{ 
			nLayerColor = nColor;
		// get sequential color, get text color to seq color by row of layer	
		// set the color
			if (nColor==-2 && nSeqColors.length()>0)
			{
				int n=0;
				if (pack.bIsValid())
					n = pack.propInt(0);
				while(n>nSeqColors.length()-1)
				{
					n-=nSeqColors.length();
				}
				nLayerColor=nSeqColors[n];
			}			
			
			
			csLayer2Truck = csLayer2Trucks[nLayerHandle];
		}
	//endregion
		
		items.append(item);
		nRefIndices.append(i);// the index to the entity array
		nLayerHandles.append(nLayerHandle);
		nTagColors.append(nLayerColor);//nLayerColors[nLayerHandle]);
		
	// transform location to truck
		ptLoc.transformBy(csLayer2Truck);
		//ptLoc.vis(nTagColors[nLayerHandle]);
		ptsLocs.append(ptLoc);
		
		Body bd = item.realBody();
		bd.transformBy(csLayer2Truck);
		//bd.vis(nLayerHandle);	
		bdAll.append(bd); 
	}
	//endregion
	
//region get list of available object variables
	String sObjectVariables[0]; Entity entsRef[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		String _sObjectVariables[0];
		GenBeam genBeam= (GenBeam)ents[i];
		MassElement me= (MassElement)ents[i];
		MassGroup mg = (MassGroup)ents[i];
		Element el= (Element)ents[i];
		if (genBeam.bIsValid())	_sObjectVariables.append(genBeam.formatObjectVariables());
		else if (me.bIsValid())	_sObjectVariables.append(me.formatObjectVariables());
		else if (mg.bIsValid())	_sObjectVariables.append(mg.formatObjectVariables());
		else if (el.bIsValid())	_sObjectVariables.append(el.formatObjectVariables());
		
	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
			if(sObjectVariables.find(_sObjectVariables[j])<0)
				sObjectVariables.append(_sObjectVariables[j]); 
	}//next
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}
//End get list of available object variables//endregion 
	
// Trigger AddRemoveFormat//region
	String sTriggerAddRemoveFormat =T("|Add/Remove Format|") + T(" (|more entries|)");
	addRecalcTrigger(_kContext, sTriggerAddRemoveFormat );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddRemoveFormat)
	{
		String sPrompt ="\n"+ T("|Select a property by index to add(+) or to remove(-)|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String value;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					value = _value;
					break;
				}
			}//next j
			
			String sAddRemove = sAttribute.find(key,0, false)<0?"(+)" : "(-)";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
			
			reportNotice("\n"+sIndex+keyT + "........: "+ value);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
		
	// select property	
		if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
		{ 
			String newAttrribute = sAttribute;
			
		// get variable	and append if not already in list	
			String var ="@(" + sObjectVariables[nRetVal] + ")";
			int x = sAttribute.find(var, 0);
			if (x>-1)
			{
				int y = sAttribute.find(")", x);
				String left = sAttribute.left(x);
				String right= sAttribute.right(sAttribute.length()-y-1);
				newAttrribute = left + right;
				reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
			}
			else
			{ 
				newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
			}
			sAttribute.set(newAttrribute);
			reportMessage("\n" + sAttributeName + " " + T("|set to|")+" " +sAttribute);	
		}
		setExecutionLoops(2);
		return;
	}//endregion



//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Display settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
	
		sProps.append(sNoYes[bHideLinework]);
		nProps.append(nColorBackground);
		nProps.append(nTransparencyBackground);
		sProps.append(_LineTypes.findNoCase(sLineType,-1)<0?_LineTypes.first():sLineType);
		dProps.append(dLineTypeScale);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				nColorBackground = tslDialog.propInt(0);
				nTransparencyBackground = tslDialog.propInt(1);
				bHideLinework = sNoYes.findNoCase(tslDialog.propString(0),0);
				sLineType = tslDialog.propString(1);
				dLineTypeScale = tslDialog.propDouble(0);
				
				String k = "Tag\\Background";
				Map m = mapSetting.getMap(k);
				m.setInt("Color",nColorBackground);
				m.setInt("Transparency",nTransparencyBackground);
				mapSetting.setMap(k, m);
				
				k = "Tag\\Linework";
				m = mapSetting.getMap(k);
				m.setInt("Hide",bHideLinework);
				mapSetting.setMap(k, m);				
				
				k = "Tag\\Guideline";
				m = mapSetting.getMap(k);
				m.setString("LineType",sLineType);
				m.setDouble("LineTypeScale",dLineTypeScale);
				mapSetting.setMap(k, m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	

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





















	
// collect text tags
	String sTags[0];
	double dXMaxTxt;
	for (int j = 0; j < ents.length(); j++)
	{	
		Entity& ent = ents[j];
		
	// get all available format variables in lower case
		String sFormatVariables[]= ent.formatObjectVariables();
		for (int x=0;x<sFormatVariables.length();x++) sFormatVariables[x] = sFormatVariables[x].makeLower(); 
		
	// gather display texts		
		String sTag;//use\n as token to display multiline text
		// default
		if (sAttribute.length() == 0 && sFormatVariables.find("posnum")>-1)// 
		{
			sTag=ent.formatObject("@(posnum)");
			if (sTag.length()==0)
				sTag = "?";
		}
		// add extra text
		String sTokens[] = sAttribute.tokenize(";");
		String sValue;
		for (int i = 0; i < sTokens.length(); i++)
		{
			String sToken = sTokens[i];
			sValue = sToken;
		// find format expression
			int l = sToken.find("@(",0);
			if (l >- 1)
			{
				int r = sToken.find(")", l);
				int y = sToken.length();
				String left = sToken.left(l);
				String sVariable = sToken.right(y - l - 2).left(r - l - 2).makeLower();
				String right = sToken.right(sToken.length() - r - 1);
				
				// resolve variable
				if (sFormatVariables.find(sVariable) >- 1)
				{
					sValue = ent.formatObject("@(" + sVariable + ")");
					sValue = left + sValue + right;
				}
			}
			sTag += sValue;
		}
		
		
		double d = dp.textLengthForStyle(sTag,sDimStyle)*dFactor;
		if (dXMaxTxt < d)dXMaxTxt = d;
		sTags.append(sTag);
	}
	
	
// loop all layers, collect prime and second items
	PlaneProfile ppLoad(csW);
	int bIsPrimes[bdAll.length()], nNumPrime;
	PlaneProfile ppItems[bdAll.length()];
	for (int i=0;i<sLayerHandles.length();i++) 
	{ 
	// collect bodies and locations of same layer index	
		Body bodies[0];
		Point3d pts[0];
		int nIndices[0]; // the index to the overall array
		for (int b=0;b<bdAll.length();b++) 
		{ 
			if(nLayerHandles[b]==i)
			{
				bodies.append(bdAll[b]);
				pts.append(ptsLocs[b]);
				nIndices.append(b);
			}
		}
		
	// order by elevation	
		for (int a=0;a<bodies.length();a++) 
			for (int b=0;b<bodies.length()-1;b++) 
			{
				double d1 = vecZ.dotProduct(pts[b] - _Pt0);
				double d2 = vecZ.dotProduct(pts[b+1] - _Pt0);
				if (d1<d2)
				{ 
					pts.swap(b, b + 1);
					bodies.swap(b, b + 1);
					nIndices.swap(b, b + 1);
				} 		
			}	
		
		PlaneProfile ppLayer(csW);
		for (int j=0;j<bodies.length();j++) 
		{ 
			int x = nIndices[j];
			PlaneProfile pp = bodies[j].shadowProfile(Plane(pts[j], vecZ));
			PLine pl;
			pl.createConvexHull(pnW, pp.getGripVertexPoints());
			ppLoad.joinRing(pl, _kAdd);
			ppItems[x] = PlaneProfile(pl); // the profile of the item in truck view
			
			//if (i==0)bodies[j].vis(4);
			if(ppLayer.area()<pow(dEps,2))
			{
				ppLayer.joinRing(pl, _kAdd);
				bIsPrimes[x] = true;
				nNumPrime++;
				//bodies[j].vis(3);
			}
			else
			{ 
				PlaneProfile ppInt(pl);
				ppInt.intersectWith(ppLayer);
			/// intersection means the item is not in first view
				if (ppInt.area()<pow(U(10),2))
				{
					//bodies[j].vis(3);
					bIsPrimes[x] = true;
					nNumPrime++;
					ppLayer.joinRing(pl, _kAdd);
				}
			}	 	 
		}				
	}
	ppLoad.shrink(-dEps);
	ppLoad.shrink(dEps);
	ppLoad.vis(2);
	
// get extents of profile
	LineSeg segLoad = ppLoad.extentInDir(vecX);
	double dXLoad = abs(vecX.dotProduct(segLoad.ptStart()-segLoad.ptEnd()));
	double dYLoad = abs(vecY.dotProduct(segLoad.ptStart()-segLoad.ptEnd()));
	
// enable grid display
	int bDrawGrid = ents.length() - nNumPrime > 0;
	
// strategy 0 + 2 without grid
	int nLoops = 1;
	
	if (nStrategy==0 || nStrategy==2)
	{
		nLoops = 2;
		bDrawGrid = false;
	}

// loop twice, run prime entities first
	for (int k=0;k<nLoops;k++) 
	for (int j=0;j<bIsPrimes.length();j++) 
	{ 
		int bIsPrime = bIsPrimes[j]; 
		
	// make sure prime ones are drawn first	
		if (bIsPrime == k)
		{
			continue;
		}
		
		Entity& ent = ents[j];
		Sip sip = (Sip)ent;
		GenBeam gb = (GenBeam)ent;
		MassElement me=(MassElement)ent;
		MassGroup mg=(MassGroup)ent;
		Element el=(Element)ent;

		Body& bd = bdAll[j];
		//dp.color(bDebug?j:nTagColors[j]);
		dp.color(nTagColors[j]);
		
		
		
		
		
		//bd.vis(j);
		
	// the bounding profile of the item on the truck	
		PlaneProfile& pp = ppItems[j];
//		if(bIsPrime)
//			pp.transformBy(vecZ * U(200));
//		else
//			pp.transformBy(-vecZ * U(200));		
//		pp.vis(bIsPrime);
		
	// the content
		String content = ent.formatObject(sAttribute);
		String sValues[] = content.tokenize("\\");
		//reportMessage("\nent " + ent.typeDxfName() + " reports " + sValues);
		
		String sLines[0];
	// resolve unknown and draw 	
		for (int i = 0; i < sValues.length(); i++)
		{
			String& value = sValues[i];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				//String sVariables[] = sLines[i].tokenize("@(*)");
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1).makeUpper();

						//region Sip unsupported by formatObject
						if (sip.bIsValid())
						{ 
							String sqTop,sqBottom; 
							SipStyle style(sip.style());
							sqTop = sip.surfaceQualityOverrideTop();
							if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
							if (sqTop.length() < 1)sqTop = "?";
							int nQualityTop = SurfaceQualityStyle(sqTop).quality();
							
							sqBottom = sip.surfaceQualityOverrideBottom();
							if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
							if (sqBottom.length() < 1)sqBottom = "?";
							int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();		
							
							
							Vector3d vecGrain = sip.woodGrainDirection();
							if (sVariable=="@(GRAINDIRECTIONTEXT)")
								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")
								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
//							else if (sVariable=="@(surfaceQualityBottom)".makeUpper())
//								sTokens.append(sqBottom);	
//							else if (sVariable=="@(surfaceQualityTop)".makeUpper())
//								sTokens.append(sqTop);	
//							else if (sVariable=="@(SURFACEQUALITY)")
//							{
//								String sQualities[] ={sqBottom, sqTop};
//								if (sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
//								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
//								sTokens.append(sQuality);	
//							}							
						}
						//End Sip unsupported by formatObject//endregion 						

						// sTokens.append(XX);


						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}

				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
			sLines.append(value);
		}		
			


	// multiline, write \n separated parts into texts array
//		String sValue = sTags[j];
//		int x1 = sValue.find("\\", 0);
//		while(x1>-1)
//		{ 
//			int x2 = sValue.find("n", x1);
//			if (x2=x1+1)
//			{ 
//				String left = sValue.left(x1);
//				String right = sValue.right(sValue.length()-x2-1);
//				sLines.append(left);
//				sValue = right;
//				x1 = sValue.find("\\", 0);
//			}
//		}
//		if (sValue.length()>0)
//			sLines.append(sValue);


		int nNumLine = sLines.length();
		
	// line displacement flag	
		double dYFlag;
		if (nNumLine>1)
			dYFlag = 3*(nNumLine-1)*.5;	
	
	// get max XX/Y of tag
		double dXMax = dp.textLengthForStyle(content, sDimStyle, dTextHeightStyle);
		double dYMax = dp.textHeightForStyle(content, sDimStyle, dTextHeightStyle);

		Point3d ptLoc = ptsLocs[j];
		
	// create circle
		PLine plBoundary(_ZW);
		double dRadius = dXMax>dYMax?dXMax*.5:dYMax*.5;
//		if (dXMax<=1.6*dYMax && nNumLine<=3)
//			plBoundary.createCircle(ptLoc,vecZ, dRadius);
//	// create rounded boundary
//		else
		{ 
			plBoundary.createRectangle(LineSeg(ptLoc - .5 * (vecX * dXMax - vecY * dYMax), ptLoc + .5 * (vecX * dXMax - vecY * dYMax)), vecX, vecY);
			plBoundary.offset(.1 * dTextHeightStyle, true);
		}
		plBoundary.projectPointsToPlane(pnW, vecZ);
		//plBoundary.vis(j);
		
		
	// test intersection
		
		PlaneProfile ppTest(plBoundary);//ppTest.vis(2);
		ppTest.intersectWith(ppProtect);
		double dArea = ppTest.area();
		double dAreaMax = pow(dTextHeight / 5, 2);
	// check intersection
		int bIntersect = dArea>dAreaMax;
		if (!bIntersect)
		{ 
			ppProtect.joinRing(plBoundary,_kAdd);
		}		
	// try to resolve within bounding item profile
		else
		{
			if (bDebug)bdAll[j].vis(bIsPrime);

		// get extents of profile
			LineSeg seg = ppTest.extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()))+.1*dTextHeightStyle;
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()))+.1*dTextHeightStyle;
			
			
			int nCnt;
			Vector3d vecDir = _XW * dX;
			while (nCnt < 2 && dArea > dAreaMax)
			{ 
				PLine plTest = plBoundary;
				plTest.transformBy(vecDir);
				ppTest=PlaneProfile(plTest);
				
			
				if (ppTest.intersectWith(ppProtect))
				{
					dArea = ppTest.area();
					Vector3d vecDirX = vecDir; vecDirX.normalize();
					if (!vecDirX.isParallelTo(_YW))
					{ 
						
						plTest.transformBy(vecDirX * ppTest.dX());
						vecDir += vecDirX * ppTest.dX();
						ppTest=PlaneProfile(plTest);
						//{ Display dpx(6); dpx.draw(PlaneProfile(plTest),_kDrawFilled, 20);}	
					}
					plTest.vis(nCnt);					
				}
//				dArea = ppTest.area();
				if (ppTest.intersectWith(ppProtect))
				{ 
					;
					//{ Display dpx(4); dpx.draw(ppProtect,_kDrawFilled, 60);}
					//{ Display dpx(2); dpx.draw(PlaneProfile(plTest),_kDrawFilled, 20);}					
				}
			// is valid
				else
				{ 
					dArea = 0;
					plBoundary.transformBy(vecDir);
					ptLoc.transformBy(vecDir);
					plBoundary.vis(3);
					ppProtect.joinRing(plBoundary,_kAdd);
				}
				
			// transformation matrix pattern
				// 1        0
			
				// following deprectaed
				// 5	2	4
				// 1		0
				// 7	3	6
				nCnt++;
//				if (nCnt==2)vecDir = _YW * dY; // 12:00h
//				else if (nCnt==3)vecDir =- _YW * dY; // 06:00h
//				else if (nCnt % 2 == 1)vecDir = -_XW * dX;// to left
//				else vecDir = _XW * dX;// to right
//				
//				if (nCnt > 3)vecDir += _YW * dY;
//				else if (nCnt > 5)vecDir -= _YW * dY;
			}

		}


	// draw texts
		//if (bIsPrime)
		for (int i=0;i<nNumLine;i++) 
		{ 
			String& sText = sLines[i];
			Point3d ptTxt = ptLoc;
			ptTxt.setZ(0);
			dp.draw(sText,ptTxt, vecX, vecY,0,dYFlag);
			dYFlag-=3; 
		}		

	// filled frame	
	
		if (nStyle>1)
		{
			PlaneProfile ppBoundary(plBoundary);
			dpWhite.draw(ppBoundary, _kDrawFilled, nTransparencyBackground);
		}
	// frame
		if (nStyle>0)
			dp.draw(plBoundary);
	}
	
	if (!bDrawGrid) return;




// get num of columns base don max columnwidth and load extents
	int nNumColumn;
	double dColumnWidth = dXMaxTxt * 4;
	if (dColumnWidth < 6 * dTextHeightStyle)dColumnWidth = 6 * dTextHeightStyle;
	if (bDrawGrid && dColumnWidth>0)nNumColumn=dXLoad / (dColumnWidth);
	
	Point3d ptGrid = segLoad.ptMid() - .5 * (vecX * dXLoad - vecY * (dYLoad + U(500)));
	if (vecY.dotProduct(_Pt0-ptGrid)<dEps)
	{ 
		_Pt0 = ptGrid;
	}
	else
	{ 
		ptGrid = _Pt0;
		ptGrid.transformBy(vecX * vecX.dotProduct((segLoad.ptMid() - .5 * vecX * dXLoad) - _Pt0));
	}
	//ptGrid.vis(3);
	
// draw grid
	for (int i=0;i<nNumColumn;i++) 
	{ 
		PLine pl(ptGrid - vecY * U(1000), ptGrid + vecY * U(1000));
		pl.transformBy(vecX * i*dColumnWidth);
		pl.vis(3); 
	}
	
	
	

// assign a column number per non prime member and append to new set of arrays
	int nColumnIndices[0];
	Point3d ptsG[0];
	int nGLayers[0], nGColors[0];
	String sGTags[0];
	for (int j=0;j<bdAll.length();j++) 
	{ 
		if (bIsPrimes[j])continue;
		Body& bd = bdAll[j];
		Point3d pt = bd.ptCen(); //pt.vis(j);
		double d = vecX.dotProduct(pt - ptGrid);
		
		int nColumn = d / dColumnWidth;
		nColumnIndices.append(nColumn);
		ptsG.append(pt);//pt.vis(2);
		nGLayers.append(nLayerHandles[j]);
		sGTags.append(sTags[j]);
		nGColors.append(nTagColors[j]);
	}


// order by layer
	for (int i=0;i<sGTags.length();i++)	
		for (int j=0;j<sGTags.length()-1;j++)
		{ 
			if (nGLayers[j]>nGLayers[j+1])
			{ 
				nColumnIndices.swap(j,j+1);
				ptsG.swap(j,j+1);
				nGLayers.swap(j,j+1);
				sGTags.swap(j,j+1);
				nGColors.swap(j,j+1);

			}
		}

//// order by column
//	for (int i=0;i<sGTags.length();i++)	
//		for (int j=0;j<sGTags.length()-1;j++)
//		{ 
//			if (nColumnIndices[j]>nColumnIndices[j+1])
//			{ 
//				nColumnIndices.swap(j,j+1);
//				ptsG.swap(j,j+1);
//				nGLayers.swap(j,j+1);
//				sGTags.swap(j,j+1);
//				nGColors.swap(j,j+1);
//
//			}
//		}



// draw all tags in a grid
	LineSeg segGuides[0];
	int nColorGuides[0];
	{ 

		double dX = dXMaxTxt+dTextHeightStyle;
		double dY = 1.5 * dTextHeightStyle;
		int nGRows[nNumColumn];
		int nGColumnLayers[0];
		int nNumGridFlag;
		for (int j = 0; j < nNumColumn; j++)
			nGColumnLayers.append(-1);
		for (int j = 0; j < sGTags.length(); j++)
		{
			int& nLayer = nGLayers[j];
			String& sTag = sGTags[j];
			int& nColor = bDebug ? j : nGColors[j];
			int c = nColumnIndices[j];
			
			Point3d ptCen = ptsG[j];
			
			if (nGColumnLayers[c]>-1 && nGColumnLayers[c]!=nLayer)
				nGRows[c]+=1;
			int r = nGRows[c];
			Point3d pt = ptGrid + vecX * (c + .5) * dColumnWidth + vecY*r*dY;
			
			//pt.vis(2);
			
			dp.color(nColor);
			dp.draw(sTag, pt, vecX, vecY, 0, 0);
	
			LineSeg seg(pt-.5*(vecX*dX+vecY*dY), pt+.5*(vecX*dX+vecY*dY));
			//seg.transformBy(.25 * dTextHeightStyle * (-vecX - vecY));
				
				//seg.vis(j);
			PLine pl;
			pl.createRectangle(seg, vecX, vecY);
			ppProtect.joinRing(pl, _kAdd);
//			dp.lineType("Continuous");
			dp.draw(pl);
	
		// guide line
			Point3d ptGuide1 = seg.ptMid() - vecY * .5 * dY - vecX* .5*dTextHeightStyle;
			//Point3d ptGuide2 = ptGuide1+ vecX * (r+1)/2*dTextHeightStyle;
			Point3d ptGuide2 =ptGuide1+vecY*vecY.dotProduct(ptCen-ptGuide1); 
			//PLine plGuide(ptGuide1, ptGuide2);//,ptGuide3);
			LineSeg segGuide(ptGuide1, ptGuide2);
			segGuide.transformBy(vecX * (r * .2*dTextHeightStyle));
//			dp.lineType("Hidden", U(10));
//			dp.draw(plGuide);
			segGuides.append(segGuide);
			nColorGuides.append(nColor);
			
			nGRows[c] += 1;
			nGColumnLayers[c] = nLayer;
			nNumGridFlag++;
		}
		
	// draw guide lines
		if (_LineTypes.find(sLineType)>-1)
		{ 
			dp.lineType(sLineType, dLineTypeScale);
		}
	
		for (int j=0;j<segGuides.length();j++) 
		{ 
			LineSeg segs[] = ppProtect.splitSegments(segGuides[j], false); 
			dp.color(nColorGuides[j]);
			dp.draw(segs);
		}
		
		
		
	}




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
        <int nm="BreakPoint" vl="1430" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22614 tag placement improved, color consider pack color if set to -2, new white background, new property access" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/3/2024 8:23:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: get from xml flag &quot;PropertyReadOnly&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/28/2023 11:12:10 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: On insert set properties to readOnly for KLH" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/27/2023 10:17:49 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End