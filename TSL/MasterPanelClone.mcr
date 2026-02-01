#Version 8
#BeginDescription
This tsl creates a solid clone of a masterpanel.

#Versions
Version 1.0 09.11.2022 HSB-17005 initial version of a masterpanel clone


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
// 1.0 09.11.2022 HSB-17005 initial version of a masterpanel clone , Author Thorsten Huck

/// <insert Lang=en>
/// Select masterpanels adn pick a insertion point
/// </insert>

// <summary Lang=en>
// This tsl creates a solid clone of a masterpanel.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MasterPanelClone")) TSLCONTENT

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
	
//end Constants//endregion

//region properties
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(Number)", sFormatName);	
	sFormat.setDescription(T("|Defines the format to display properties|"));
	sFormat.setCategory(category);

	String sSolidColorName=T("|Color|");	
	PropInt nSolidColor(nIntIndex++, 40, sSolidColorName);	
	nSolidColor.setDescription(T("|Defines the Color of the solid|"));
	nSolidColor.setCategory(category);	

// Display
category = T("|Display|");

	
	String sColorName=T("|Text Color|");	
	PropInt nColor(nIntIndex++, 7, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(300), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	
	

//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		sFormat.setDefinesFormatting("MasterPanel");
		
		
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
	
	
	// Collect all existing clones
		Entity entsC[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		MasterPanel masterClones[0];
		for (int i=0;i<entsC.length();i++) 
		{ 
			TslInst t = (TslInst)entsC[i]; 
			if (t.bIsValid() && t.scriptName() == scriptName())
			{ 
				Entity ents[] = t.entity();
				for (int j=0;j<ents.length();j++) 
				{ 
					MasterPanel m= (MasterPanel)ents[j]; 
					if (m.bIsValid() && masterClones.find(m)<0)
						masterClones.append(m);				 
				}//next j			
			}		 
		}//next i

	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), MasterPanel());
		if (ssE.go())
			ents.append(ssE.set());

		_Entity.append(ents);
		_Pt0 = getPoint();
		
		if (bDebug)
		{ 
			return;
		}
		

	//region Distribute
	
	// get overall profile to distinguish reference location
		CoordSys cs();
		PlaneProfile ppAll(cs);
		MasterPanel masters[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity& ent= _Entity[i]; 
			MasterPanel master = (MasterPanel)ent;  
			
			if (masterClones.find(master)>-1)
			{ 
				reportMessage(TN("|Masterpanel| ") + master.number() + T(" |alreday clomed|"));
				continue;
				
			}
			
			PLine pl = master.plShape();
			ppAll.joinRing(pl, _kAdd);
			masters.append(master);
		}//next i
		
		Point3d ptBase = ppAll.ptMid() - _XW * .5 * ppAll.dX() + .5 * _YW * ppAll.dY();
		Vector3d vecTrans = _Pt0 - ptBase;
		
		for (int i=0;i<masters.length();i++) 
		{ 
			MasterPanel master =masters[i];  		
			PLine pl = master.plShape();
			PlaneProfile pp(cs);
			pp.joinRing(pl, _kAdd);
			
			Point3d pt = pp.ptMid() - _XW * .5 * pp.dX();
			
			pt.transformBy(vecTrans);

		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = tLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {master};			Point3d ptsTsl[] = {pt};
		
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			
		}//next i
		
		
		
		
	//endregion 		
		
		
		
		eraseInstance();
		return;
	}			
//endregion 


//region Distribute (debug for bOnInsert)
	if (0 && bDebug)
	{ 
	// get overall profile to distinguish reference location
		CoordSys cs();
		PlaneProfile ppAll(cs);
		MasterPanel masters[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity& ent= _Entity[i]; 
			MasterPanel master = (MasterPanel)ent;  		
			PLine pl = master.plShape();
			ppAll.joinRing(pl, _kAdd);
			masters.append(master);
		}//next i
		
		Point3d ptBase = ppAll.ptMid() - _XW * .5 * ppAll.dX() + .5 * _YW * ppAll.dY();
		Vector3d vecTrans = _Pt0 - ptBase;
		
		for (int i=0;i<masters.length();i++) 
		{ 
			MasterPanel master =masters[i];  		
			PLine pl = master.plShape();
			PlaneProfile pp(cs);
			pp.joinRing(pl, _kAdd);
			
			Point3d pt = pp.ptMid() - _XW * .5 * pp.dX() - .5 * _YW * pp.dY();
			
			pt.transformBy(vecTrans);
			pl.transformBy(vecTrans);
			pl.vis(i);
			
		}//next i	
		return;
	}

//endregion 

//region Validate reference
	
	MasterPanel master;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& ent= _Entity[i]; 
		
		if (!master.bIsValid())
		{ 
			master = (MasterPanel)ent;
			
			
		}
	}//next i	
	
	if (!master.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid masterpanel reference|"));
		eraseInstance();
		return;
	}
//endregion 

//region Clone Solid
	double dZ = master.dThickness();
	CoordSys cs();
	PLine pl = master.plShape();
	PlaneProfile pp(cs);
	pp.joinRing(pl, _kAdd);	
	Point3d ptMid = pp.ptMid();
	Point3d pt = ptMid - _XW * .5 * pp.dX();
	
	Vector3d vecTrans = _Pt0 - pt;
	pl.transformBy(vecTrans);
	ptMid.transformBy(vecTrans);
	Body bd(pl, _ZW *dZ, 1);	//bd.vis(40);
	
//endregion 

//region Display
	sFormat.setDefinesFormatting(master);
	
	String text = master.formatObject(sFormat);
	Point3d ptText = ptMid + _ZW * dZ;
	Display dp(nColor);

	int bUseTextHeight; // to be used for dimensions
	double textHeight = dTextHeight;
	if (dTextHeight<= 0) 
		textHeight = dp.textHeightForStyle("O", sDimStyle);
	else 
	{
		bUseTextHeight = true;
		dp.textHeight(textHeight);
	}
	dp.draw(text, ptText, _XW, _YW, 0, 0,_kDevice);
	
	dp.color(nSolidColor);
	dp.draw(bd);
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
      <str nm="Comment" vl="HSB-17005 initial version of a masterpanel clone" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/9/2022 12:12:27 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End