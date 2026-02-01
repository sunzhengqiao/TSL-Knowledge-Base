#Version 8
#BeginDescription
#Versions
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 10
#KeyWords 
#BeginContents
//region <History>
// #Versions

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TraceMultipageShowSet")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	
//end Constants//endregion


//region Functions #FU
	
	
	
//endregion 

//region JIG
	
	
	
//endregion 


//region Properties #PR


	
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
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}	
			setReadOnlyFlagOfProperties();			
		}

		_Entity.append(getMultiPage());
		_Pt0 = getPoint();
		
		return;
	}			
//endregion

//region Standards

	MultiPage page = _Entity.length() < 1 ? MultiPage() : (MultiPage)_Entity[0];
	if (!page.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid selection set|"));
		eraseInstance();
		return;
		
	}
	
	MultiPageView views[] = page.views();
//endregion 



//region Display
	Display dp(40);
	String dimStyle = _DimStyles.first();
	double textHeight = U(60);
	dp.dimStyle(dimStyle);
	dp.textHeight(textHeight);
	
	Point3d pt = _Pt0;	pt.vis(40);
	Vector3d vecLineFeed = - _YW * 1.5*textHeight;
//endregion 


//region Loop Views
	String text;
	
	dp.draw(T("|Page Define Set|"), pt, _XW, _YW, 1, 0);
	pt += vecLineFeed;
	
	Entity entDefines[] = page.defineSet();
	for (int i=0;i<entDefines.length();i++) 
	{ 
		text=entDefines[i].formatObject("  @(TypeName) @(posnum:d)@(scriptName:d)@(Definition:D)");	
		dp.draw(text, pt, _XW, _YW, 1, 0);
		pt += vecLineFeed;
		 
	}//next i

	pt += .5*vecLineFeed;
	text=T("|Page Show Set|");	
	dp.draw(text, pt, _XW, _YW, 1, 0);
	pt += vecLineFeed;				pt.vis(40);
	Entity showSet[] = page.showSet();
	for (int i=0;i<showSet.length();i++) 
	{ 
		pt.vis(i);
		text=showSet[i].formatObject("  @(TypeName) @(posnum:d)@(scriptName:d)@(Definition:D)"); 
		dp.draw(text, pt, _XW, _YW, 1, 0);
		pt += vecLineFeed; 
	}//next i

	pt += .5*vecLineFeed;
	text=T("|Views|");
	dp.draw(text, pt, _XW, _YW, 1, 0);
	pt += vecLineFeed;pt.vis(40);
	
	
//region Function DrawGuideLine
	// returns the closest location on the target and draws the guide line
	Point3d DrawGuideLine(Point3d pt, PlaneProfile pp, int color)
	{ 
		
		Point3d pt1 = pp.closestPointTo(pt);
		Point3d ptm = (pt1+pt)*.5;
		Point3d pt2 = pt - _XW * .25*_XW.dotProduct(ptm - pt1);
		Point3d pt3 = pt1 + _XW * .25*_XW.dotProduct(ptm - pt1);
		PLine pl(pt,pt2, pt3, pt1);
		Display dp(color);
		dp.draw(pl);
		//dp.draw(pp,_kDrawFilled, 60);
		
		return pt1;
	}//endregion	
	
//region Function GetBodyFromQuader
	// returns the body of a quader
	Body GetBodyFromQuader(Quader qdr)
	{ 
		CoordSys cs = qdr.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		Body bd(qdr.pointAt(0, 0, 0), vecX, vecY, vecZ, qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);		
		return bd;
	}//endregion
	
	
	for (int v=0;v<views.length();v++) 
	{ 
		MultiPageView view= views[v];
		CoordSys ms2ps = view.modelToView();
		
		
		
		PlaneProfile pp(view.plShape());
		pt += .5*vecLineFeed;
		text=" View" +(v+1);		
		Point3d pt1 = DrawGuideLine(pt, pp, 40);
		
		
		dp.draw(text, pt, _XW, _YW, 1, 0);
		pt += vecLineFeed;
		Entity showSet[] = view.showSet();
		for (int i=0;i<showSet.length();i++) 
		{ 
			pt.vis(i);
			text=showSet[i].formatObject("  @(TypeName) @(posnum:d)@(scriptName:d)@(Definition:D) @(isDummy:D)"); 
			
			if (v==0)
			{ 
				Body bd = GetBodyFromQuader(showSet[i].bodyExtents());	
				PlaneProfile ppModel = bd.shadowProfile(Plane(_PtW, _ZW));
				
				bd.transformBy(ms2ps);
				PlaneProfile pp = bd.shadowProfile(Plane(_PtW, _ZW));
				Point3d pt1 = DrawGuideLine(pt, pp, i+1);
				
				pt1 = DrawGuideLine(pt, ppModel, i+1);
			}


			dp.draw(text, pt, _XW, _YW, 1, 0);
			pt += vecLineFeed; 
		}//next i			
		 
	}//next v
	

	
	
	//dp.draw(text, _Pt0, _XW, _YW, 1, 0);
	
	
	
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
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End