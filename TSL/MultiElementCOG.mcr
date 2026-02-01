#Version 8
#BeginDescription
#Versions
Version 1.0 04.10.2021 HSB-12789 initial version , Author Thorsten Huck

This tsl displays the COG of an element. In case of a multi element it displays the COG of the indiviual elements if available
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords Viewport;COG;Multiwall;Multielement;Layout
#BeginContents
//region <History>
// #Versions
// 1.0 04.10.2021 HSB-12789 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select a viewport in paperspace or elements in modelspace
/// </insert>

// <summary Lang=en>
// This tsl displays the COG of an element. In case of a multi element it displays the COG of the indiviual elements if available.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MultiElementCOG")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select Tool|"))) TSLCONTENT
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
//end Constants//endregion



//region Properties
category = T("|Content|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(Weight:RL1)kg", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
	
category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|TextHeight|");	
	PropDouble dTextHeight(nDoubleIndex++, U(3), sTextHeightName, _kLength);	
	dTextHeight.setDescription(T("|Defines the Text Height|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 1, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
category = T("|Symbol|");	
	String sScaleFactorName=T("|Scale Factor|");	
	PropDouble dScaleFactor(nDoubleIndex++,1, sScaleFactorName,_kNoUnit);	
	dScaleFactor.setDescription(T("|Defines the ScaleFactor|"));
	dScaleFactor.setCategory(category);

	String sTransparencyName=T("|Transparency|");	
	PropInt nTransparency(nIntIndex++, 0, sTransparencyName,_kNoUnit);	
	nTransparency.setDescription(T("|Defines the Transparency|"));
	nTransparency.setCategory(category);
	
	
		
	
			
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

	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();


		if (bInLayoutTab)
		{
			_Viewport.append(getViewport(T("|Select a viewport|")));
			_Pt0 = getPoint(T("|Pick a point outside of paperspace|")); 
		}	
	// modelspace: get elements
		else
		{ 
		// prompt for entities
			PrEntity ssE(T("|Select elements|"), Element());
			if (ssE.go())
				_Element.append(ssE.elementSet());

		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = sLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};				

		// create instances per elementmulti
			for (int i=0;i<_Element.length();i++) 
			{ 
				Entity entsTsl[] = {};	
				entsTsl.append(_Element[i]);
				
				Point3d ptsTsl[] = {_Element[i].ptOrg()};
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
			}//next i

			eraseInstance();
		}
		
		return;
	}	
// end on insert	__________________//endregion




// dependencies
	int bHasViewport, bIsMulti;
	Viewport vp;
	Element el;
	ElementMulti em;
	SingleElementRef srefs[0];
	CoordSys ms2ps;	



	if (_Viewport.length()>0)
	{ 
		vp = _Viewport[_Viewport.length()-1];
		_Viewport[0] = vp;
		bHasViewport = true;
		ms2ps = vp.coordSys();
		
	// check if the viewport has hsb data
		el = vp.element();
		em = (ElementMulti)el;		
		if (em.bIsValid())
		{
			srefs = em.singleElementRefs();
			bIsMulti = true;
		}
	}	
	else if (_Element.length()>0)
	{ 
		el = _Element[0];
		em = (ElementMulti)el;
		if (em.bIsValid())
		{
			bIsMulti = true;
			srefs = em.singleElementRefs();
		}
	}
	
		


//region Display		
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	
	if (dTextHeight>0)
		dp.textHeight(dTextHeight);
		
	if (bHasViewport)
	{ 
		String text = scriptName()+ ": ";
		text += sFormat;
		dp.draw(text, _Pt0, _XW, _YW, 1, 0);
	}
	
// Symbol
	double dXY = dTextHeight > 0 ? dTextHeight : dp.textHeightForStyle("O", sDimStyle);
	if (dScaleFactor>0)dXY *= dScaleFactor;
	CoordSys csRot; csRot.setToRotation(45, _ZW, _Pt0);
	Vector3d vec = .5 * dXY * (_XW + _YW);
	PLine plBox; plBox.createRectangle(LineSeg(_Pt0-vec,_Pt0+vec), _XW, _YW);
	plBox.transformBy(csRot);
	Point3d pts[] = plBox.vertexPoints(true);
	PlaneProfile ppSym(plBox);
	PlaneProfile ppSub = ppSym;
	ppSub.shrink(dXY * .1);
	ppSym.subtractProfile(ppSub);

	dXY = PlaneProfile(plBox).extentInDir(_XW).length();		
//endregion 

//region Get potential elements of multiwall (only if in same dwg)
	Element elements[srefs.length()];
	if (em.bIsValid())
	{ 
		String numbers[0];
		for (int j=0;j<srefs.length();j++) 
			numbers.append(srefs[j].number()); 
	
		Entity _ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		for (int i=0;i<_ents.length();i++) 
		{ 
			Element e = (Element)_ents[i];
			int x = numbers.findNoCase(e.number() ,- 1);
			if (e.bIsValid() && x>-1)	
			{
				elements[x]=e;	 
			}
		}//next j			
	}
	// fall back to element mode
	else
		elements = _Element;			
//endregion 

//region Get Object Variables
	Map mapAdditional;
	String sVariables[0];
	Entity entFormat = el;
	if (elements.length()>0)
		entFormat = elements.first();
	sVariables = entFormat.formatObjectVariables();	
	if (sVariables.findNoCase("Weight",-1)<0)
		sVariables.append("Weight");
	sVariables=sVariables.sorted();	
//endregion 



//region Get COG of each (sref or element)

	for (int i=0;i<elements.length();i++) 
	{ 
		Element e = elements[i];
		if (!e.bIsValid())continue;
				
		CoordSys csSingle;
		if (srefs.length()>i)csSingle=srefs[i].coordSys(); 		
		
		CoordSys cs2em;
		cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), csSingle.ptOrg(), csSingle.vecX(), csSingle.vecY(), csSingle.vecZ() );
		
		GenBeam gbs[] = e.genBeam();
		TslInst tsls[] = e.tslInstAttached();
		Opening openings[] = e.opening();
		
		Map mapIO;
		Map mapEntities;
		for (int j=0;j<gbs.length();j++) 
		{
			mapEntities.appendEntity("Entity", gbs[j]);
		
			if (bDebug)
			{ 
				Body bd = gbs[j].realBody();
				bd.transformBy(cs2em);
				bd.transformBy(ms2ps);
				bd.vis(i); 		
			}
			
		}
		for (int j=0;j<openings.length();j++) 
			mapEntities.appendEntity("Entity", openings[j]);			
		
		//mapEntities.appendEntity("Entity", e);
		mapIO.setMap("Entity[]",mapEntities);
		//mapIO.setInt("debug", true);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		Point3d ptCen = mapIO.getPoint3d("ptCen");// returning the center of gravity
		double dWeight = mapIO.getDouble("Weight");// returning the weight
		
		ptCen.transformBy(cs2em);
		ptCen.transformBy(ms2ps);
		//ptCen.vis(3);
		
		
		mapAdditional.setDouble("Weight", dWeight, _kNoUnit);
		
		String text = e.formatObject(sFormat, mapAdditional);

		Vector3d vecSym = ptCen - ppSym.ptMid();
		ppSym.transformBy(vecSym);
		dp.draw(ppSym, _kDrawFilled, nTransparency);
		dp.draw(ppSym);
		dp.draw(ppSym.extentInDir((_XW+_YW)));
		dp.draw(ppSym.extentInDir((-_XW+_YW)));
		
		dp.draw(text, ptCen+_XW*.5*dXY, _XW, _YW, 1, 0);
		 
	}//next i
		
//endregion 	



//region Add/RemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
		sPrompt+="\n"+ T("|Current Format|: ")+ sFormat +  TN("|Select a property by index to add or to remove|") + T(", |0 = Exit, -1 = new Line|");
		reportNotice("\n"+sPrompt);

		for (int s=0;s<sVariables.length();s++) 
		{ 
			String key = sVariables[s]; 
			String value;
			if (mapAdditional.hasString(key))
				value = mapAdditional.getString(key);
			else if (mapAdditional.hasDouble(key))
				value = mapAdditional.getDouble(key);
			else if (mapAdditional.hasInt(key))
				value = mapAdditional.getInt(key);
			else
				value = entFormat.formatObject("@(" + key + ")");

			String sAddRemove = sFormat.find("@(" + key + ")",0, false)<0 ?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+T("|"+key +"|")+ "........: "+ value);
			
		}//next i
		reportNotice("\n"+sPrompt);
		
		int nRetVal = getInt(sPrompt)-1;	

				
	// select property	
		while (nRetVal!=-1)
		{ 
			String newFormat = sFormat;
			if (nRetVal>-1 && nRetVal<=sVariables.length())
			{ 
			// get variable	and append if not already in list	
				String variable ="@(" + sVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newFormat = left + right;
					//reportMessage("\n" + sVariables[nRetVal] + " new: " + newFormat);				
				}
				else
				{ 
					newFormat+="@(" +sVariables[nRetVal]+")";
								
				}
			}
			else if (nRetVal == -2)
			{ 
				if (sFormat.right(2)=="\\P")
				{ 
					newFormat = newFormat.left(newFormat.length() - 2);
				}
				else
					newFormat += "\\P";			
			}
			sFormat.set(newFormat);
			
			String outFormat = "\n" + sFormatName + ": "  + sFormat;
			String outValue= "\n" + T("|Result|: ")+ entFormat.formatObject(sFormat, mapAdditional);
			
			reportMessage(outFormat+outValue);	
			reportNotice(outFormat+outValue);
			
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="255" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12789 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/4/2021 9:48:58 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End