#Version 8
#BeginDescription

Version 1.0 26.04.2022 HSB-15328 inital version , Author Thorsten Huck
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.0 26.04.2022 HSB-15328 inital version , Author Thorsten Huck

/// <insert Lang=en>
/// Fire the command in block space of a multipage
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "sd_ModelTslCreator")) TSLCONTENT
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
		//if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String tDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
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
	
	
	
//end Constants//endregion


//region Properties
	String scriptNames[]= TslScript().getAllEntryNames();
	for (int i=scriptNames.length()-1; i>=0 ; i--) 
		if (scriptNames[i].find("sdMS_",0,false)<0)
			scriptNames.removeAt(i); 
	scriptNames.append("DrillPatternDimension");
	String sScriptName=T("|Script|");	
	PropString sScript(nStringIndex++, scriptNames.sorted(), sScriptName);	
	sScript.setDescription(T("|Defines the Script|"));
	sScript.setCategory(category);

	String entries[0];
	entries = TslInst().getListOfCatalogNames(sScript);
	if (entries.length() < 1)entries.append(tDefault);
	String sEntryName=T("|Catalog Entry|");	
	PropString sEntry(nStringIndex++, entries, sEntryName);	
	sEntry.setDescription(T("|Defines the catalog name to specify the property values|"));
	sEntry.setCategory(category);
	if (entries.findNoCase(sEntry ,- 1) < 0)sEntry.set(tDefault);
//End Properties//endregion 


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }


	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();

	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		String err=scriptName() + T(" |can only be inserted in the block definition of a multipage with at least one shopdraw viewport.|");
		if (!bInLayoutTab)
		{
			viewEnts= Group().collectEntities(true, ShopDrawView(), _kMySpace);
			if (viewEnts.length()>0)
				err = "";
		}
		if (err.length()>0)
		{ 
			reportNotice("\n"+err + TN("|Tool will not be inserted.|"));
			eraseInstance();
			return;
		}


		sEntry.setReadOnly(scriptNames.length()>1);	
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
		
		if (scriptNames.length()>1)
		{ 
			sScript.setReadOnly(true);
			sEntry.setReadOnly(false);
			entries = TslInst().getListOfCatalogNames(sScript);
			sEntry = PropString(1, entries, sEntryName);
			showDialog();			
		}

		_Entity.append(viewEnts[0]);
		_Pt0 = getPoint(T("|Pick pint to place setup info|"));		
		
		return;
	}	
// end on insert	__________________//endregion
	
	
	Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
	Map map = entCollector.subMapX(scriptName());
	String key = sScript + "_" + sEntry;
	int bCreated = map.getInt(key);
reportMessage("\n"+scriptName() + " "+key + " " + bCreated);
	if(_bOnGenerateShopDrawing)
	{ 
		if (entCollector.bIsValid() && !bCreated)
		{ 
		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};
	
			tslNew.dbCreate(sScript , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sEntry, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
		
			if (tslNew.bIsValid())
			{		
				tslNew.transformBy(Vector3d(0, 0, 0));
				map.setInt(key, true);
				entCollector.setSubMapX(scriptName(), map); // store the state that the tsl has been created to avoid duplicates when regenerating the mp
			}			
		}
	}
	else//_when not in Shopdraw generation, draw text as display/reference
	{
		 // use the style and size specified in the shopdraw style
		Display dp(3); // green
		dp.textHeight(U(40));
		dp.draw(sScript + ": " + sEntry, _Pt0-_YW*U(20), _XU, _YU, 1.1, -1);
		dp.draw(PLine (_Pt0, _Pt0 - _YW * U(80)));
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15328 inital version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="4/26/2022 1:46:02 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End