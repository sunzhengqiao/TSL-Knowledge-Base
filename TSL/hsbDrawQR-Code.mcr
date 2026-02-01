#Version 8
#BeginDescription
#Versions
Version 1.7 25.02.2021 HSB-10913 bugfix when using preset catalog entry in shopdraw mode. You can now control the QR content and the logo type by the selected catalog entry. , Author Thorsten Huck
1.6 22.01.2021 HSB-10325 internal bugfix Thorsten Huck
1.5 15.01.2021 HSB-10325 optional logo drawn in QR

HSB-9706 'Handle' supported as format variable 
HSB-9338 internal naming bugfix

HSB-7944 shopdraw mode supports catalog based override of format variable to enable style independent setup
HSB-7233 context command added to add/remove formatting

QR Code can now also be placed in modelspace. Format description enhanced. 

This tsl creates and draws a QR code in paperspace, shopdraw space or modelspace.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords QR;Code;Barcode
#BeginContents
/// <History>//region
// #Versions
// 1.7 25.02.2021 HSB-10913 bugfix when using preset catalog entry in shopdraw mode. You can now control the QR content and the logo type by the selected catalog entry. , Author Thorsten Huck
// 1.6 22.01.2021 HSB-10325 internal bugfix, Author Thorsten Huck
// 1.5 15.01.2021 HSB-10325 optional logo drawn in QR
/// <version value="1.5" date="13nov2020" author="thorsten.huck@hsbcad.com"> HSB-9706 'Handle' supported as format variable </version>
/// <version value="1.4" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.3" date="06jul2020" author="thorsten.huck@hsbcad.com"> HSB-7944 shopdraw mode supports catalog based override of format variable to enable style independent setup </version>
/// <version value="1.2" date="07apr2020" author="thorsten.huck@hsbcad.com"> HSB-7233 context command added to add/remove formatting </version>
/// <version value="1.1" date="20sep2018" author="thorsten.huck@hsbcad.com"> QR Code can now also be placed in modelspace. Format description enhanced. </version>
/// <version value="1.0" date="14sep2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select an element viewport or a shopdrawing view port and the location of the QR codeand press OK
/// </insert>

/// <summary Lang=en>
/// This tsl draws a QR code in paperspace or shopdraw space.
/// </summary>//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
	//endregion


// Format
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "EL;@(ElementNumber)", sFormatName);
	String sFormatDesc = T("|Defines the text and/or attributes.|") + TN("|Syntax\n	@(<PropertyName>)|") + TN("|Syntax for properties of property sets\n 	<PropertySetName.PropertyName>|\n" + 
	T("|Sample: @(ProjectName) @(Delivery.TruckID) will resolve the project name and a property 'TruckID' of a property set called 'Delivery'|\n"));//// T("|Attributes can also be added or removed by context commands.|");
	sFormat.setDescription(sFormatDesc);
	sFormat.setCategory(category);

	String sModes[] ={ T("|Paperspace|"), T("|Shopdrawing|"), T("|Model|")};
	String sModeName=T("|Mode|");	
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the Mode|"));
	sMode.setCategory(category);

// display
	category = T("|Display|");
	String sSizeName=T("|Size|");	
	PropDouble dSize(nDoubleIndex++, U(25), sSizeName);	
	dSize.setDescription(T("|Defines the size|"));
	dSize.setCategory(category);
	
	String sMarginName=T("|Margin|");	
	PropInt nMargin(nIntIndex++, 4, sMarginName);	
	nMargin.setDescription(T("|Specifies the margin, <default>=4|"));
	nMargin.setCategory(category);

	String sLogoName=T("|Logo|");
	String sLogos[]=  {T("|no logo|"),T("|red|"),T("|yellow|"),T("|green|"),T("|cyan|")};
	PropString sLogo(nStringIndex++, sLogos, sLogoName,1);	
	sLogo.setDescription(T("|Defines the Logo|"));
	sLogo.setCategory(category);
	
	
	
	


// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
		int nMode = sModes.find(sMode);
		
	// paperspace
		if (nMode==0)
		{ 
			Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
			
	  		_Viewport.append(vp);			
		}
	// shopdrawing
		else if (nMode==1)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select a Shopdraw View|"), ShopDrawView());
			
			if (ssE.go())
				ents = ssE.set();		
			if (ents.length()<1)
			{	
				eraseInstance();
				return;
			}			
			_Entity.append(ents[0]);
		}
	// model
		else if (nMode == 2)
		{
			_Entity.append(getEntity());
		}
		else
			eraseInstance();

  		_Pt0 = getPoint(); // select point
  		
		return;
	}	
// end on insert	__________________

// get mode
	int nMode = sModes.find(sMode);
	String sDecode = "www.hsbcad.com";
	Entity entDef;
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Point3d ptRef = _Pt0;
	
	String sActiveFormat = sFormat; // default by property, for shopdrawings could be collected from catalog entry
	String sActiveLogo = sLogo;
	
// paperspace
	if (nMode==0)
	{ 
	// do something for the last appended viewport only
		if (_Viewport.length()==0) 
		{
			Display dp(1);
			dp.textHeight(U(2));
			dp.draw(scriptName() + T(": |please add a viewport|"), _Pt0, _XW, _YW, 1, 0);
			
			
		// Trigger AddViewPort
			String sTriggerAddViewPort = T("|Add Viewport|");
			addRecalcTrigger(_kContext, sTriggerAddViewPort );
			if (_bOnRecalc && (_kExecuteKey==sTriggerAddViewPort || _kExecuteKey==sDoubleClick))
			{
				_Viewport.append(getViewport(T("|Select a viewport|"))); 
				setExecutionLoops(2);
				return;
			}	
			
			
			
			return; // _Viewport array has some elements
		}
		Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Viewport[0] = vp; // make sure the connection to the first one is lost
	
	// check if the viewport has hsb data
		if (!vp.element().bIsValid()) return;
	
		CoordSys ms2ps = vp.coordSys();
		CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
		Element el = vp.element();		
		entDef = el;
		
		ptRef.setZ(0);
	}
	
// shopdrawing
	else if (nMode==1)
	{ 
		String scriptName = bDebug ? "hsbDrawQR-Code" : scriptName();
		String sCatalogEntries[] = TslInst().getListOfCatalogNames(scriptName);
		
	// Trigger SelectCatalogDefault//region
		if (sCatalogEntries.length()>0)
		{ 
			String sTriggerSelectCatalogDefault = T("|Select Catalog Default|");
			addRecalcTrigger(_kContextRoot, sTriggerSelectCatalogDefault );
			if ((_bOnRecalc && _kExecuteKey==sTriggerSelectCatalogDefault))// ||bDebug)
			{
				reportNotice(TN("|Select catalog entry by index to override the format to build QR-Code by a catalog entry.|"));
				reportNotice(TN("|Using a catalog entry enables you to specify the formatting outside of the shopdraw style definition.|"));
				
				String out;
				for (int i=0;i<sCatalogEntries.length();i++) 
				{ 
					String num = i+1;
					if (i+1 < 10) num = " "+num;
					else if (i+1 < 100) num = "  "+num;
					
					Map map = TslInst().mapWithPropValuesFromCatalog(scriptName, sCatalogEntries[i]);
					Map mapProp = map.getMap("PropString[]\\PropString");
					String sFormatCatalog =mapProp.getString("strValue");

					out += "\n"+num + ":	" +sCatalogEntries[i] + "	" +sFormatCatalog; 
					
					
				}//next i
				
				if (_Map.hasString("catalogEntry"))
					out += "\n 0:	" + T(" | reset selected value.|");
				reportNotice("\n"+out);
				
			// get select entry
				int ret = getInt(T("|Select entry by index|"))-1;
				if (ret<0 || ret>sCatalogEntries.length())
				{
					reportMessage("\n"+ scriptName() + T(" |catalog entry removed|"));
					_Map.removeAt("catalogEntry", true);
				}
				else
				{
					//if(bDebug) 
					reportMessage("\n"+ scriptName() + T("|saving catalog entry as default|: ") + sCatalogEntries[ret]);				
					_Map.setString("catalogEntry", sCatalogEntries[ret]);
				}
				
				
				setExecutionLoops(2);
				return;
			}//endregion			
		}


	// get active format if catalog entry is specified
		String sCatalogEntry = _Map.getString("catalogEntry");
		if (sCatalogEntries.findNoCase(sCatalogEntry,-1)>-1)
		{ 
			if(_kShiftKeyPressed) reportMessage("\n"+ scriptName() + " collecting settings from " + sCatalogEntry);
			Map map = TslInst().mapWithPropValuesFromCatalog(scriptName, sCatalogEntry);
			Map mapProp = map.getMap("PropString[]\\PropString");
			String _sActiveFormat =mapProp.getString("strValue");
			if (_sActiveFormat.length()>0)
				sActiveFormat = _sActiveFormat;
				
			mapProp = 	map.getMap("PropString[]").getMap(2);
			String _sActiveLogo =mapProp.getString("strValue");
			if (sLogos.findNoCase(_sActiveLogo,-1)>-1)
				sActiveLogo = _sActiveLogo;
				
		}
		
		
	// the view		
		ShopDrawView sdv;
		for (int i=0; i<_Entity.length(); i++)
		{
			if (_Entity[i].bIsKindOf(ShopDrawView()))
			{
				sdv = (ShopDrawView)_Entity[i];
				break;	
			}
		}
		
		// get view data		
		int bError = 0; // 0 means FALSE = no error
		CoordSys ms2ps, ps2ms;
		if (!bError && !sdv.bIsValid()) bError = 1;
		   
		// interprete the list of ViewData in my _Map
		ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
		int nIndFound = ViewData().findDataForViewport(arViewData, sdv);// find the viewData for my view
		if (!bError && nIndFound<0) bError = 2; // no viewData found
		
		Entity ents[0];
		if (!bError)
		{
			ViewData vwData = arViewData[nIndFound];
			ms2ps = vwData.coordSys(); // transformation to view
		
		// collect the entities of the view
			ents = vwData.showSetDefineEntities();
			if (ents.length()>0)
				entDef = ents[0];
		}
		ptRef.setZ(0);
	}
	
// model
	else if (nMode==2 && _Entity.length()>0)
	{
		vecX = _XU;
		vecY = _YU;
		entDef = _Entity[0];
	}


//region Parse text and display if found
	Entity ents[] = { entDef};
//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	Map mapAdditionalVariables;//HSB-9706
	mapAdditionalVariables.appendString("Handle", entDef.handle());
	String sObjectVariables[] = entDef.formatObjectVariables();

//region Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
	String sCustomVariables[] ={"Handle"};//HSB-9706
	for (int i=0;i<sCustomVariables.length();i++)
	{ 
		String k = sCustomVariables[i];
		if (sObjectVariables.find(k) < 0)
			sObjectVariables.append(k);
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
	//End add custom variables//endregion 
//End get list of available object variables//endregion 

//region Trigger AddRemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			String sAddRemove = sFormat.find(key,0, false)<0?"(+)" : "(-)";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newAttrribute);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion




//region Resolve format by entity
	String text;
	if (sActiveFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  entDef.formatObject(sActiveFormat,mapAdditionalVariables);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
//
//						String s;
//						if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
//						{
//							s.formatUnit(dDiameter*.5,_kLength);
//							sTokens.append(s);
//						}
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
					left = value.find("@(", 0);
				}
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\\P";		 
		}//next j
	}
//		
//End Resolve format by entity//endregion 

//End Parse text and display if founsd//endregion 






	if (entDef.bIsValid())
	{
		if (bDebug)reportNotice("\n" + scriptName() + ": " +entDef.handle() + T(" |the decode text is|\n") + text);
		sDecode = text;//entDef.formatObject(sFormat);
	}
	else
		sDecode += " " + projectName();
	
// draw QR and logo HSB-10325
	int nLogo = sLogos.find(sActiveLogo);
	int nErrCor = 1; // 0 = low, 1 = medium, 2 = high
	int nRoomForImage = 4;// 0 = none, 1,2,3,4,5 ( as % )
	String sQRed;
	if (nLogo==0)
		sQRed= sDecode.qrEncode(nMargin);
	else
		sQRed= sDecode.qrEncode(nMargin, nErrCor, nRoomForImage);//	
	sFormat.setDescription(sFormatDesc + "\n" + T("|QR Result|:\n")+sDecode);
	
	Display dp(256);
	dp.drawQR(sQRed, ptRef, vecX, vecY, 1, 1, dSize);
		
	if (nLogo>0)
	{ 
		double dSizeImg = sQRed.inQrEmbeddedImageSizeFactor() * dSize;
		double dSizeLogo = dSizeImg * 0.9;
		dp.drawHsbLogo(nLogo, ptRef+(vecX+vecY)*.5*dSize, vecX, vecY, 0, 0, dSizeLogo);		
	}

	



#End
#BeginThumbnail
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
C'7=4VK<JBHIR`2H`_+FNELH6MK&"!R"T<84D=.!4]%`'_]E]
`









#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10913 bugfix when using preset catalog entry in shopdraw mode. You can now control the QR content and the logo type by the selected catalog entry." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="2/25/2021 4:36:42 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End