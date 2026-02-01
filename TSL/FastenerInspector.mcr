#Version 8
#BeginDescription
#Versions
Version 1.1 28.08.2025 HSB-22933 improved version , Author Thorsten Huck
Version 1.0 24.01.2025 HSB-22933 initial version

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 28.08.2025 HSB-22933 improved version , Author Thorsten Huck
// 1.0 24.01.2025 HSB-22933 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select style from list or pick an existing fastenerAssembly entity
/// </insert>

// <summary Lang=en>
// Displays the content of a selected fastenerAssemblyDefinition Style
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "FastenerInspector")) TSLCONTENT
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


//region Functions #FU
	
	
	
//endregion 

//region JIG
	
	
	
//endregion 


//region Properties #PR
	String sDefinitions[] = FastenerAssemblyDef().getAllEntryNames().sorted();

	
	String sDefinitionName=T("|Fastener Style|");	
	PropString sDefinition(0, sDefinitions, sDefinitionName);
	sDefinition.setDescription(T("|Defines the Style|"));
	sDefinition.setCategory(category);	

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(50), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);





//End Properties//endregion 



//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 		
//		Property.setReadOnly(HideCondition?_kHidden:false);
//		Property.setReadOnly(HideCondition?_kHidden:false);
		return;
	}//endregion	

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		String tBySelection = T("<|bySelection|>");
		sDefinitions.insertAt(0, tBySelection);
		sDefinition = PropString (0, sDefinitions, sDefinitionName);

	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
		}
		while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
		{ 
			setReadOnlyFlagOfProperties(); // need to set hidden state
		}	
		setReadOnlyFlagOfProperties();

		if (sDefinition==tBySelection)
		{ 
			FastenerAssemblyEnt fae = getFastenerAssemblyEnt();
			if (fae.bIsValid())
				sDefinition.set(fae.definition());
			else
			{ 
				eraseInstance();	
				return;
			}
		}
		

		_Pt0 = getPoint();
		return;
	}			
//endregion

//region FasterDefinition
	FastenerAssemblyDef fadef(sDefinition);	
	if (!fadef.bIsValid())
	{ 
		reportNotice("\nInvalid Definition");
		eraseInstance();
		return;
	}
	FastenerListComponent flc = fadef.listComponent();
	FastenerArticleData fads[]= flc.articleDataSet();
	FastenerComponentData fcd= flc.componentData();	
	FastenerSimpleComponent fscHeads[] = fadef.headComponents();
	FastenerSimpleComponent fscTails[] = fadef.tailComponents();	
//endregion 


//region Function getComponentDataText
	// returns a string with the componentData content
	String getComponentDataText(FastenerComponentData fcd)
	{ 

		String text;
		text += "Name: "+ fcd.name();
		text += "\nType: "+ fcd.type();
		text += "\nSubType: "+ fcd.subType();
		text += "\nManufacturer: "+ fcd.manufacturer();
		text += "\nModel: "+ fcd.model();
		text += "\nMaterial: "+ fcd.material();
		text += "\nGroup: "+ fcd.group();
			
		return text;
	}//endregion
	
//region Function getComponentDataText
	// returns a string with the componentData content
	String getArticleDataText(FastenerArticleData fad, int bAddDescr)
	{ 

		String description = fad.description();
		if (!bAddDescr && description.length() > 15)description = description.left(15); // limit display

		String text;
		text += (bAddDescr?"Articlenumber: ":"")+ fad.articleNumber();
		text += (bAddDescr?"\nDescription: ":"\n")+ description;
		text += (bAddDescr?"\nType: ":"\n")+ fad.notes();
		text += (bAddDescr?"\nFastenerLength: ":"\n")+ fad.fastenerLength();
		text += (bAddDescr?"\nThreadLength: ":"\n")+ fad.threadLength();
		text += (bAddDescr?"\nminProjectionLength: ":"\n")+ fad.minProjectionLength();
		text += (bAddDescr?"\nmaxProjectionLength: ":"\n")+ fad.maxProjectionLength();
		text += (bAddDescr?"\nGroup: ":"\n")+ fcd.group();

		return text;
	}//endregion	
	
//region Function getFastenerDataArticles
	// returns a string array with articleNumber and length
	String[] getFastenerDataArticles(FastenerArticleData fads[])
	{ 
		String out[0];
		String k;
		for (int i=0;i<fads.length();i++) 
		{ 
			FastenerArticleData& fad = fads[i]; 
			Map map = fad.map();
			String text= "#: "+fad.articleNumber();
			text+= "   D: "+fad.description();
			text+= "   L: "+fad.fastenerLength();
			text+= "   T: "+fad.threadLength();
			text+= "   Min: "+fad.minProjectionLength();
			text+= "   Max: "+fad.maxProjectionLength();
		//
			if (bDebug)
				text += " Map: " + map;			
			else
				text += " Map[" + map.length()+"]";
			
			k = "PilotDiameter"; if (map.hasDouble(k))text += "   PilotDiam: "+map.getDouble(k);
			k = "HeadHeight"; if (map.hasDouble(k))text += "   HeadHeight: "+map.getDouble(k);
			k = "HeadDiameter"; if (map.hasDouble(k))text += "   HeadDiameter: "+map.getDouble(k);
			
			out.append(text);
		}//next i
		
		
		
		return out;
	}//endregion


//region Display
	Display dp(7);
	String dimStyle = _DimStyles.first();
	dp.dimStyle(dimStyle);
	double textHeight = dTextHeight;
	dp.textHeight(textHeight);

	Vector3d vecIndent = _XW * textHeight;
	Vector3d vecNewLine = - _YW * 1.5* textHeight;
	
	Point3d pt = _Pt0;

//endregion 	
		
//region ComponentData
	dp.draw(scriptName()+ ": " + sDefinition, pt, _XW, _YW, 1, -1);
	
	pt += vecIndent+vecNewLine;
	dp.draw("Description: "+fadef.description(), pt, _XW, _YW, 1, -1);
	
	pt += 1.2*vecNewLine;
	dp.draw("FastenerComponentData", pt, _XW, _YW, 1, -1);
	pt += vecIndent+vecNewLine;
	
	String sCompData = getComponentDataText(fcd);
	dp.draw(sCompData, pt, _XW, _YW, 1, -1);
	double dxFCD = dp.textLengthForStyle(sCompData, dimStyle, textHeight)+2*textHeight;
	double dyFCD = dp.textHeightForStyle(sCompData, dimStyle, textHeight);
	
	pt += -vecIndent+vecNewLine-_YW*dyFCD;		
//endregion 	

//region FastenerArticleData
	{ 
		dp.color(40);
		dp.draw("FastenerArticleData [" +fads.length() +"]" , pt, _XW, _YW, 1, -1);
		pt += vecIndent+vecNewLine;		

		String entries[] = getFastenerDataArticles(fads);
		for (int i=0;i<entries.length();i++) 
		{ 
			dp.draw(entries[i], pt, _XW, _YW, 1, -1);
			pt+=vecNewLine; 
			 
		}//next i		
	}//endregion 

//region Head Components
	double dx, dy;
	dp.color(140);
	pt += -vecIndent+vecNewLine;
	dp.draw("HeadComponents [" + fscHeads.length()+"]", pt, _XW, _YW, 1, -1);
	pt += vecIndent+vecNewLine;
	for (int i=0;i<fscHeads.length();i++) 
	{ 
		dp.color(140);
		
		
		FastenerSimpleComponent fsc = fscHeads[i]; 
		String text = getComponentDataText(fsc.componentData());
		
		FastenerArticleData fadHead = fsc.articleData();
		text+="\n\nArticleData\n";
		text += getArticleDataText(fadHead, i == 0);
		
		dp.draw(text, pt, _XW, _YW, 1, -1);		
		double dxi = dp.textLengthForStyle(text, dimStyle, textHeight)+2*textHeight;
		double dyi = dp.textHeightForStyle(text, dimStyle, textHeight)+2*textHeight;

		dy = dy < dyi ? dyi : dy;
		pt += _XW*dxi;

	}//next i		
//endregion 

//region Tail Components
	dp.color(72);
	pt += _XW * _XW.dotProduct(_Pt0 - pt) + vecIndent;
	pt -= _YW * dy;	dy = 0;
	dp.draw("TailComponents [" + fscTails.length()+"]", pt, _XW, _YW, 1, -1);
	pt += vecIndent+vecNewLine;
	for (int i=0;i<fscTails.length();i++) 
	{ 
		FastenerSimpleComponent fsc = fscTails[i]; 
		String text = getComponentDataText(fsc.componentData());
		
		FastenerArticleData fadHead = fsc.articleData();
		text+="\n\nArticleData\n";
		text += getArticleDataText(fadHead, i == 0);
		
		dp.draw(text, pt, _XW, _YW, 1, -1);		
		double dxi = dp.textLengthForStyle(text, dimStyle, textHeight)+2*textHeight;
		double dyi = dp.textHeightForStyle(text, dimStyle, textHeight)+2*textHeight;

		dy = dy < dyi ? dyi : dy;
		pt += _XW*dxi;
		
	}//next i		
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22933 improved version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/28/2025 4:01:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22933 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/24/2025 1:52:16 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End