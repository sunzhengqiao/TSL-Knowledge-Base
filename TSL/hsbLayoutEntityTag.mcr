#Version 8
#BeginDescription
version value="1.9" date="20oct2020" author="thorsten.huck@hsbcad.com"
HSB-9338 internal naming bugfix </version>

performance improved Default no tag area added as context command
HSBCAD-537
new context commands to set format and type variables, functionality extended

Select properties or catalog entry, then select viewport and pick a point outside of paperspace.

/// This tsl creates posnum tags in paperspace. A clash detection resolves overlapping tags.
/// Types and formats can be typed in the appropriate properties, but the context menu supports adding and removing of sub entries
/// Various styles of the tag design are available.
/// Format instructions are written as @(<PROPERTY>), i.e. @(Length). If no format instruction is given the posnum will be displayed.
/// Properties of real numbers support rounding instructions, i.e. @(Length:0) will round the length to zero decimals
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords Layout;Tag; Badge; Number;Description;Label
#BeginContents
/// <History>//region
/// <version value="1.9" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.8" date="13mar2018" author="thorsten.huck@hsbcad.com"> merged </version>
/// <version value="1.7" date="12mar2018" author="thorsten.huck@hsbcad.com"> performance improved </version>
/// <version value="1.6" date="11mar2018" author="thorsten.huck@hsbcad.com"> Default no tag area added as context command </version>
/// <version value="1.4" date="04mar2018" author="thorsten.huck@hsbcad.com"> HSBCAD-537 new context commands to set format and type variables, functionality extended </version>
/// <version value="1.3" date="18feb2018" author="thorsten.huck@hsbcad.com"> new object 'opening supported' </version>
/// <version value="1.2" date="13mar2018" author="thorsten.huck@hsbcad.com"> new property to automatically assign posnums and/or set dependencies </version>
/// <version value="1.1" date="26jan2018" author="thorsten.huck@hsbcad.com"> clash detection enhanced </version>
/// <version value="1.0" date="25jan2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, then select viewport and pick a point outside of paperspace.
/// </insert>

/// <summary Lang=en>
/// This tsl creates posnum tags in paperspace. A clash detection resolves overlapping tags.
/// Types and formats can be typed in the appropriate properties, but the context menu supports adding and removing of sub entries
/// Various styles of the tag design are available.
/// Format instructions are written as @(<PROPERTY>), i.e. @(Length). If no format instruction is given the posnum will be displayed.
/// Properties of real numbers support rounding instructions, i.e. @(Length:0) will round the length to zero decimals
/// </summary>


/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbLayoutEntityTag")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Viewport|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove TSL|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Leader Offset|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add No-Tag Area|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove No-Tag Area|") (_TM "|Select tool|"))) TSLCONTENT
//endregion


	//reportMessage("\nexecuting " + scriptName());

//region constants 
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
//end constants//endregion

	
	// properties content
	String sSourceAttributes[]={"Posnum","Name","Information","Label","Sublabel","Material", "Length", "Width","Height"};

// content
	category = T("|Content|");
	String sTypes[] = { T("|byZone|"),T("|Beam|"), T("|Sheet|"), T("|Panel|"), T("|GenBeam|"),T("|TSL|"),T("|Opening|"), T("|Door|"), T("|Window|"), T("|Window Assembly|")};
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the type of entity which will be collected.|") + T(" |Empty = by current zone, else specify types.|") + T(" |Use context commands to select.|"));
	sType.setCategory(category);

	String sTSLScriptName=T("|TSL Names|");	
	PropString sTSLScript(7, "", sTSLScriptName);	
	sTSLScript.setDescription(T("|Specifies a list of tsl names to be displayed.|") + T(" |Multiple entries to be separated by a semicolon.|"));
	sTSLScript.setCategory(category);

	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by a backslash|") + " '\'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);

	String sZoneName=T("|Zone|");	
	PropString sZone(nStringIndex++, "", sZoneName);	
	sZone.setDescription(T("|Defines the zone which will be collected.|") + T(" |Empty = by current zone, else specify zones.|"));
	sZone.setCategory(category);

// collect types
	
	String sScriptNames[] = TslScript().getAllEntryNames();
	String sExcludeScripts[] ={ "bemassung", "dimension", "layout", "preview", "säge", "projektdaten", "hsb_d","ofgravity",scriptName()};
	for (int i=sScriptNames.length()-1; i>=0 ; i--) 
	{ 
		String s = sScriptNames[i];
		s.makeLower();
		if (s.left(3)=="sd_")
			sScriptNames.removeAt(i);	
		else
		{ 
			for (int j=0;j<sExcludeScripts.length();j++) 
			{ 
				if (s.find(sExcludeScripts[j],0)>-1)
				{ 
					sScriptNames.removeAt(i);	
					break;
				} 	 
			}	
		}
	}
	
// order alphabetically
	for (int i=0;i<sScriptNames.length();i++) 
		for (int j=0;j<sScriptNames.length()-1;j++) 
		{
			String s1 = sScriptNames[j];
			String s2 = sScriptNames[j+1];
			
			if (s1.makeUpper()>s2.makeUpper())
				sScriptNames.swap(j, j + 1);
		}
				
	
	
	
	
// TODO: remove comment to support tsl selection	
	//sTypes.append(sScriptNames);
	

	

//Display
	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -2, sColorName);	
	nColor.setDescription(T("|Defines the color.|") + T(" |-2 = byEntity, -1 = byLayer, 0 = byBlock, >0 = color index|"));
	nColor.setCategory(category);

	String sOrientationName=T("|Orientation|");	
	String sOrientations[] = {T("|byEntity|"), T("|Horizontal|"), T("|Vertical|")};
	PropString sOrientation(nStringIndex++, sOrientations, sOrientationName,0);	
	sOrientation.setDescription(T("|Defines the Orientation|"));
	sOrientation.setCategory(category);
	
	String sStyleName=T("|Style|");	
	String sStyles[] = {T("|Text only|"), T("|Text + Leader|"), T("|Border|"), T("|Border+Leader|"), T("|Filled Frame|"), T("|Filled Frame+Leader|") };
	PropString sStyle(nStringIndex++, sStyles, sStyleName,0);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);

	category = T("|General|");
	String sBehaviourName=T("|Behaviour|");	
	String sBehaviours[] ={ T("|Automatic|"), T("|Automatic PosNum|"), T("|Set Dependencies|"), T("|Disabled|")};
	PropString sBehaviour(nStringIndex++, sBehaviours, sBehaviourName);	
	sBehaviour.setDescription(T("|Defines the behaviour of the tool.|") + TN("|Automatic will generate missing posnums and set a dependency to every beam.|"));
	sBehaviour.setCategory(category);
	
	
	
	
	
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
		
		Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
		_Pt0 = getPoint(T("|Pick a point outside of paperspace|")); // select point
  		_Viewport.append(vp);

		return;
	}	
// end on insert	__________________
	

// performance test
	int nTick;
	if (bDebug)
		nTick = getTickCount();


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
	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps


// check if the viewport has hsb data
	Element el = vp.element();
	ElementMulti em;
	int bIsElementViewport = el.bIsValid();	
	Point3d ptMidEl;
	
	if (bIsElementViewport)
	{ 
		em = (ElementMulti)el;	
		LineSeg segEl = el.segmentMinMax();
		segEl.transformBy(ms2ps);
		ptMidEl = segEl.ptMid();ptMidEl.vis(2);
	}

// scale	
	Vector3d vecScale(1, 0, 0);
	vecScale.transformBy(ps2ms);
	double dScale = vecScale.length();


// get viewdirection in model
	Vector3d vecXView = _XW;	vecXView.transformBy(ps2ms);	vecXView.normalize();
	Vector3d vecYView = _YW;	vecYView.transformBy(ps2ms);	vecYView.normalize();
	Vector3d vecZView = _ZW;	vecZView.transformBy(ps2ms);	vecZView.normalize();
	//vecZView.vis(el.ptOrg(), 4);

	int bIsPlanView = vecZView.isParallelTo(Vector3d(0, 0, 1));


//region Get Priority	
	// the sequence of creation time sets the priority
	String time = _Map.getString("CreationTime");
	if (time.length()<1)
	{ 
		time.formatTime("%Y-%m-%d-%H-%H-%S");
		_Map.setString("CreationTime", time);
		//reportMessage("\n"+_ThisInst + " set to " + time);
	}
	
// collect other instances also attached to this viewport
	Entity entTags[] = Group().collectEntities(true, TslInst(), _kMySpace);
	TslInst tslTags[0];
	String times[0];
	for (int i=entTags.length()-1; i>=0 ; i--) 
	{ 
		TslInst t=(TslInst)entTags[i];
		Entity _ents[] = t.entity();
		if (t.bIsValid() && t.scriptName()==scriptName() && _ents.find(vp)>-1)// make sure it is attached to the same viewport
		{
			String _time = t.map().getString("CreationTime");
			//reportMessage("\n"+t + " has time" + _time);
		// if this time is already present (i.e. if you copy an instance) -> reset time
			if (t==_ThisInst && times.find(_time)>-1)
			{ 
				//reportMessage(TN("|removing| ") + time);
				_Map.removeAt("CreationTime", true);
				setExecutionLoops(2);
				return;
			}
			
			tslTags.append(t);
			times.append(_time);
		}
	}//next i
	
// order alphabetically
	for (int i=0;i<tslTags.length();i++) 
		for (int j=0;j<tslTags.length()-1;j++) 
			if (times[j]>times[j+1])
			{
				times.swap(j, j + 1);
				tslTags.swap(j, j + 1);
			}
	
// prio
	int nPriority = tslTags.find(_ThisInst);
	if (_bOnDbCreated)
	{
		setExecutionLoops(2);
//	// update any lower prio	
//		for (int i=nPriority+1;i<tslTags.length();i++) 
//			tslTags[i].transformBy(Vector3d(0,0,0)); 
	}
	if (nPriority < 0)nPriority = U(10000) + tslTags.length();	
//End Get Priority//endregion 

// world plane in MS
	Plane pn(_PtW, _ZW);
	pn.transformBy(ps2ms);

// ints
	int nOrientation = sOrientations.find(sOrientation);
	int nStyle = sStyles.find(sStyle);
	int bDrawLeader = nStyle % 2 == 1;
	int nActiveZoneIndex = vp.activeZoneIndex();
	int nBehaviour = sBehaviours.find(sBehaviour,0);
	int nType = sTypes.find(sType, 0);
	int bAddScriptAll;
	
	String sAutoAttribute = sAttribute;
	if (sAutoAttribute.length() == 0)
	{
		if (nType<5)sAutoAttribute = "@(PosNum)";
		else if (nType==5)sAutoAttribute = "@(Scriptname)";
		else sAutoAttribute = "@(Width) x @(Height)";
	}
	
//region get list of scriptnames
	String sScripts[0], sSetupText2;
	if (nType != 5)
		sTSLScript.setReadOnly(true);
	else
	{ 
		sScripts = sTSLScript.tokenize(";");		
		
		String allScripts[0];allScripts = sScriptNames;
		

	// Trigger AddRemoveScript//region
		String sTriggerAddRemoveScript = T("|Add/Remove TSL|");
		addRecalcTrigger(_kContext, sTriggerAddRemoveScript );
		if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveScript || _kExecuteKey==sDoubleClick))
		{
			
			String sPrompt ="\n"+ T("|Add (+) or remove (-) tsl|");
			reportNotice(sPrompt);
			
			for (int i = 0; i < allScripts.length(); i++)
			{ 
				int x = i + 1;
				String sAddRemove = sTSLScript.find(allScripts[i],0, false)<0?"(+)" : "(-)";
				String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+": ";
				reportNotice("\n"+sIndex+ + allScripts[i]);
			}
			int nRetVal = getInt(sPrompt)-1;		
			
			
		// select property	
			if (nRetVal>-1 && nRetVal<=allScripts.length())
			{ 
				String thisScript = allScripts[nRetVal];
				String out;
				
				String sTokens[] = sTSLScript.tokenize(";");
				int nToken = sTokens.find(thisScript);
	
			// add
				if (nToken<0)
				{ 
					out = sTSLScript+(sTSLScript.length()>0?";":"")+thisScript;
				}
			// remove
				else
				{ 	
					for (int j=0;j<sTokens.length();j++) 
					{ 
						if (j == nToken)continue;
						out = (out.length()>0?";":"")+sTokens[j]; 	 
					}//next j
					
				}
				sTSLScript.set(out);
				reportMessage("\n" +sTSLScriptName + T(" |is now set to|")+" " +out);	
			}			
				
				
			setExecutionLoops(2);
			return;
		}//endregion	

		
	// take all if nothing selected
		if (sScripts.length()<1)
		{
			sScripts = sScriptNames;
			bAddScriptAll = true;
			sSetupText2 = T(", |all scripts|");
		}
		else
			sSetupText2 = sScripts;
	
	}		


//End // get list of scriptnames//endregion 

//region collect zones
	String sZones[]=sZone.tokenize(";");
	int nZones[0];
	int bEveryZone;
	for (int i=0;i<sZones.length();i++) 
	{ 
		int nZone = sZones[i].atoi();
	// all zones
		if (nZone==99)
		{ 
			bEveryZone = true;
			nZones.setLength(0);
			int n[] ={-5,-4,-3,-2,-1,0,1,2,3,4,5};
			nZones.append(n);
			break;
		}
		
	// support 1-10 syntax	
		if (nZone>5 && nZone<11)
			nZone = 5 - nZone;
		int bIsValid = nZone >- 6 && nZone < 6;
		if (nZones.find(nZone)<0 && bIsValid)
			nZones.append(nZone); 
	}
	if (nZones.length()<1)
		nZones.append(nActiveZoneIndex);
		


//End collect zones//endregion 


// Trigger SelectEntity//region
	int bToggleWallContour = _Map.getInt("ToggleWallContour"); // aflag if the wall outline should be excluded from the label placement
	if (!bIsElementViewport)
	{ 
		String sTriggerAddEntity = T("|Add entities| (") + sType + ")";
		addRecalcTrigger(_kContext, sTriggerAddEntity );

		if (_bOnRecalc && (_kExecuteKey==sTriggerAddEntity || _kExecuteKey==sDoubleClick))
		{
			int bSuccess = Viewport().switchToModelSpace();
			if (bSuccess)
			{ 
			// prompt for entities
				PrEntity ssE;
				if (nType==1)ssE = PrEntity(T("|Select beam(s)|"), Beam());
				else if (nType==2)ssE = PrEntity(T("|Select sheet(s)|"), Sheet());
				else if (nType==3)ssE = PrEntity(T("|Select sip(s)|"), Sip());
				else if (nType==4)ssE = PrEntity(T("|Select genbeam(s)|"), GenBeam());
				else if (nType==5)ssE = PrEntity(T("|Select tsl(s)|"), TslInst());
				else if (nType>=6)ssE = PrEntity(T("|Select opening(s)|"), Opening());			
				if (ssE.go())
				{
					Entity _ents[] = ssE.set();
					reportMessage("\nents " + _ents.length() + " selected");
					_Entity.append(ssE.set());
				}
				bSuccess = Viewport().switchToPaperSpace();	
			}
			setExecutionLoops(2);
			return;		
		}	
		
		if (_Entity.length()>0)
		{ 
			String sTriggerRemoveEntity = T("|Remove entities|");
			addRecalcTrigger(_kContext, sTriggerRemoveEntity );
	
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntity)
			{
				int bSuccess = Viewport().switchToModelSpace();
				if (bSuccess)
				{ 
				// prompt for entities
					PrEntity ssE(T("|Select beam(s)|"), Entity());
					Entity _ents[0];
					if (ssE.go())
						_ents.append(ssE.set());
					
					for (int i=_Entity.length()-1; i>=0 ; i--) 
					{ 
						int n = _ents.find(_Entity[i]);
						if (n>-1)
						{
							reportMessage(TN("|498 removing at| ")+n);
							
							_Entity.removeAt(n);
						}
						
					}//next i	
					bSuccess = Viewport().switchToPaperSpace();	
				}
				setExecutionLoops(2);
				return;		
			}				
		}
		
		
		if (bIsPlanView)
		{ 
		// Trigger ToggleWallContour
			String sTriggerToggleWallContour =bToggleWallContour?T("|Toggle Wall Contour off|"):T("|Toggle Wall Contour on|");
			addRecalcTrigger(_kContext, sTriggerToggleWallContour);
			if (_bOnRecalc && _kExecuteKey==sTriggerToggleWallContour)
			{
				bToggleWallContour = bToggleWallContour ? false : true;
				_Map.setInt("ToggleWallContour", bToggleWallContour);		
				setExecutionLoops(2);
				return;
			}			
		}
		
	}//endregion
	

//region collect entities by selected type
	Entity ents[0];
	Beam beams[0];
	Sheet sheets[0];
	Sip sips[0];
	GenBeam genbeams[0];
	TslInst tsls[0];
	Opening openings[0];
	
	Element walls[0]; // the walls of which the outline is to be excluded from placement
	
//region element viewport
	if (bIsElementViewport)
	{ 
	// Beam
		if (nType==1)
		{		
			beams.append(el.beam());
			
			Beam beamsH[] = el.vecX().filterBeamsPerpendicularSort(beams);
			Beam beamsV[] = el.vecY().filterBeamsPerpendicularSort(beams);
			Beam _beams[0];
			_beams.append(beamsH);
			_beams.append(beamsV);
			for (int i=0;i<beams.length();i++) 
				if (_beams.find(beams[i])<0)
					_beams.append(beams[i]);
			beams = _beams;
			
			
			for (int j=beams.length()-1; j>=0 ; j--) 
			{ 
				Beam e = beams[j];
				if (e.bIsDummy() || (!bEveryZone && nZones.find(e.myZoneIndex())<0))beams.removeAt(j);	
				else {ents.append(e);genbeams.append(e);}
			}//next j	 
			
		}
	// sheet	
		else if (nType==2)
		{
			if (nZones.length()==1 && nZones[0]==nActiveZoneIndex)sheets.append(el.sheet(nActiveZoneIndex));
			else sheets.append(el.sheet());
			for (int j=sheets.length()-1; j>=0 ; j--) 
			{ 
				Sheet e = sheets[j];
				if (e.bIsDummy() || (!bEveryZone && nZones.find(e.myZoneIndex())<0))sheets.removeAt(j);			
				else {ents.append(e);genbeams.append(e);}	
			}//next j	
		}
	// Sip	
		else if (nType==3)
		{
			sips.append(el.sip());
			for (int j=sips.length()-1; j>=0 ; j--) 
			{ 
				Sip e = sips[j];
				if (e.bIsDummy() || (!bEveryZone && nZones.find(e.myZoneIndex())<0))sips.removeAt(j);			
				else {ents.append(e);genbeams.append(e);}	
			}//next j
		}
	// byZone or GenBeam	
		else if (nType==0 || nType==4)
		{
			if (nZones.length()==1 && nZones[0]==nActiveZoneIndex)genbeams.append(el.genBeam(nActiveZoneIndex));
			else genbeams.append(el.genBeam());
			for (int j=genbeams.length()-1; j>=0 ; j--) 
			{ 
				GenBeam e = genbeams[j];
				if (e.bIsDummy() || (!bEveryZone && nZones.find(e.myZoneIndex())<0))genbeams.removeAt(j);
				else ents.append(e);	
			}//next j
		}	
	// TSL	
		else if (nType==5)
		{
			Entity _ents[] = el.elementGroup().collectEntities(true, TslInst(), _kModelSpace);
			for (int j=0;j<_ents.length();j++) 
			{
				TslInst t = (TslInst)_ents[j];
				if (t.bIsValid() && (bAddScriptAll || sScripts.find(t.scriptName())>-1))
				{
					tsls.append(t);
					ents.append(t);	
				}
			}
		}
	// opening	
		else if (nType==6)
		{
			openings.append(el.opening());
			for (int j=0;j<openings.length();j++) 
				ents.append(openings[j]);			
		}
	// door, window or assembly
		else if (nType>=7 && nType<=9)
		{
			Opening _openings[]=el.opening();
			for (int j=0;j<_openings.length();j++) 
			{
				int nOpType = _openings[j].openingType();
				if ((nType == 7 && nOpType == _kDoor) ||
					(nType == 8 && nOpType == _kWindow) ||
					(nType == 9 && nOpType == _kAssembly))
				
				{ 
					ents.append(_openings[j]);
					openings.append(_openings[j]);
				}			
			}
		}		
	}
//End element viewport//endregion	
//region ACA viewport
	else
	{ 
		for (int i=0;i<_Entity.length();i++) 
		{ 
			String type = _Entity[i].typeDxfName();
			Beam bm = (Beam)_Entity[i];
			if (bm.bIsValid() && !bm.bIsDummy())
			{ 
				beams.append(bm);	ents.append(bm);	genbeams.append(bm);
				
				Element e = bm.element(); 
				if (e.bIsValid() && bToggleWallContour && walls.find(e)<0)
					walls.append(e);
				
				continue;
			}
			Sheet sh = (Sheet)_Entity[i];
			if (sh.bIsValid() && !sh.bIsDummy())
			{ 
				sheets.append(sh);		ents.append(sh);	genbeams.append(bm);
				
				Element e = sh.element(); 
				if (e.bIsValid() && bToggleWallContour && walls.find(e)<0)
					walls.append(e);
					
				continue;
			}	
			Sip sip = (Sip)_Entity[i];
			if (sip.bIsValid() && !sip.bIsDummy())
			{ 
				sips.append(sip);		ents.append(sip);	genbeams.append(bm);
				
				Element e = sip.element(); 
				if (e.bIsValid() && bToggleWallContour && walls.find(e)<0)
					walls.append(e);
					
				continue;
			}

			TslInst tsl = (TslInst)_Entity[i];
			if (tsl.bIsValid()&& (bAddScriptAll || sScripts.find(tsl.scriptName())>-1))//(sScriptNames.length()<1 || (sScriptNames.find(tsl.scriptName())>-1) ))
			{ 
//				String s = tsl.scriptName();
//				if (s.length() < 1){continue;				}
//				if (!bAddScriptAll && sScripts.find(s) < 0){continue;}
//
				tsls.append(tsl);		ents.append(tsl);
				
				Element e = tsl.element(); 
				if (e.bIsValid() && bToggleWallContour && walls.find(e)<0)
					walls.append(e);
					
				continue;
			}


			Opening opening = (Opening)_Entity[i];
			if (opening.bIsValid())
			{ 
				openings.append(opening);		ents.append(opening);;
				
				Element e = opening.element(); 
				if (e.bIsValid() && bToggleWallContour && walls.find(e)<0)
					walls.append(e);
					
				continue;
			}

		}//next i
		
	}
//End ACA viewport//endregion	 
	
//End collect entities by selected type//endregion 


//region Get Quantities of all types except openings
	int nQuantities[0];
	String sUniqueKeys[0];
	int bPosNumAssigned;
	int bGroupPosNum = sAttribute.find("@(Quantity)", 0, false) >- 1;
	
	{ 	
		for (int i=0;i<genbeams.length();i++) 
		{ 
			int p = genbeams[i].posnum();
			if (p < 1)
			{
				if (nBehaviour<3)
				{ 
					genbeams[i].assignPosnum(1, true);
					bPosNumAssigned = true;
				}
				continue;
			}
			if (!bGroupPosNum)continue;
			String key = p;
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i	
		for (int i=0;i<tsls.length();i++) 
		{ 
			if (!tsls[i].bIsValid())continue;
			int p = tsls[i].posnum();
			if (p < 1)
			{
				if (nBehaviour<3)
				{ 
					tsls[i].assignPosnum(1, true);
					bPosNumAssigned = true;
				}
				continue;
			}
			if (!bGroupPosNum)continue;
			String key = p;
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i	
		
		if (bPosNumAssigned)
		{ 
			setExecutionLoops(2);
			return;
		}
	}


//End Get Quantities of genbeam types//endregion 

//region get list of available object variables
	String sObjectVariables[0]; Entity entsRef[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		String _sObjectVariables[0];
		int n;

		if (nType==1){n = beams.find(ents[i]); 			if (n>-1)_sObjectVariables.append(beams[n].formatObjectVariables());}
		else if (nType==2){n = sheets.find(ents[i]);	if (n>-1)_sObjectVariables.append(sheets[n].formatObjectVariables());}
		else if (nType==3){n = sips.find(ents[i]); 		if (n>-1)_sObjectVariables.append(sips[n].formatObjectVariables());}
		else if (nType==4){n = genbeams.find(ents[i]); 	if (n>-1)_sObjectVariables.append(genbeams[n].formatObjectVariables());}
		else if (nType==5){n = tsls.find(ents[i]); 		if (n>-1)_sObjectVariables.append(tsls[n].formatObjectVariables());}
		else if (nType==6){n = openings.find(ents[i]); 	if (n>-1)_sObjectVariables.append(openings[n].formatObjectVariables());}
	
	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
			if(sObjectVariables.find(_sObjectVariables[j])<0)
				sObjectVariables.append(_sObjectVariables[j]); 
	}//next
	
// add quantity as object variable
	if (nType != 6)
		sObjectVariables.append("Quantity");		
	if (nType ==3)
	{ 
		sObjectVariables.append("GrainDirectionText");
		sObjectVariables.append("GrainDirectionTextShort");
		sObjectVariables.append("SurfaceQuality");
		sObjectVariables.append("SurfaceQualityTop");
		sObjectVariables.append("SurfaceQualityBottom");
		
	}
				
	
	
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

//region Display
// validate / automatic text height
	if (dTextHeight<=0)
		dTextHeight.set(U(100) * vp.dScale());


	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	double dFactor = 1;
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}	
	
// setup / control display	
	dp.draw(scriptName()+T(": |Zone| ") + nActiveZoneIndex, _Pt0, _XW, _YW, 1, 0);
	dp.draw(sTypeName + ": " + sType + (nType==5?sSetupText2:"") + " ("+ents.length()+"), " + T("|Priority| ")+(nPriority+1),  _Pt0, _XW, _YW, 1, -3);
	
//End Display//endregion 

//region SetLeaderOffset
	double dXLeaderOffset, dYLeaderOffset;
	
	String sTriggerSetLeaderOffset = T("|Set Leader Offset|");
	if (bDrawLeader)
	{
		if (!_Map.hasDouble("XLeaderOffset"))
		{
			dXLeaderOffset= 2* dTextHeightStyle;
			_Map.setDouble("XLeaderOffset", dXLeaderOffset);
			dYLeaderOffset= 2* dTextHeightStyle;
			_Map.setDouble("YLeaderOffset", dYLeaderOffset);	
		}
		else
		{ 
			dXLeaderOffset = _Map.getDouble("XLeaderOffset");
			dYLeaderOffset = _Map.getDouble("YLeaderOffset");		
		}
		addRecalcTrigger(_kContext, sTriggerSetLeaderOffset );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetLeaderOffset)
		{
			dXLeaderOffset = getDouble(T("|Enter X-Offset| (") + dXLeaderOffset + ")");
			dYLeaderOffset = getDouble(T("|Enter Y-Offset| (") + dYLeaderOffset + ")");
			_Map.setDouble("XLeaderOffset", dXLeaderOffset);
			_Map.setDouble("YLeaderOffset", dYLeaderOffset);
			setExecutionLoops(2);
			return;
		}	
	}		
//End SetLeaderOffset//endregion 

// Trigger AddRemoveFormat//region
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
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
			for (int j=0;j<entsRef.length();j++) 
			{ 
				String _value = entsRef[j].formatObject("@(" + key + ")");
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


// Trigger AddDefaultNoTag//region
	int bLimitTagArea = _Map.getInt("LimitTagArea");
	String sTriggerAddDefaultNoTag = bLimitTagArea?T("|within viewport or paperspace|"):T("|Only within viewport|");
	addRecalcTrigger(_kContext, sTriggerAddDefaultNoTag );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddDefaultNoTag)
	{
		bLimitTagArea = bLimitTagArea ? false:true;
		_Map.setInt("LimitTagArea", bLimitTagArea);
		setExecutionLoops(2);
		return;
	}//endregion	


// Trigger AddNoTagArea//region
	String sTriggerAddNoTagArea = T("|Add No-Tag Area|");
	addRecalcTrigger(_kContext, sTriggerAddNoTagArea );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddNoTagArea)
	{
		Point3d pt = getPoint(T("|Pick first corner|"));
	// prompt for second point input
		Point3d pts[0];
		while(pts.length()<1)
		{ 
			PrPoint ssP(TN("|Select opposite corner|"), pt); 
			if (ssP.go()==_kOk) 
				pts.append(ssP.value());
			else
				break;
		}

		if (pts.length()>0)
		{ 
			PlaneProfile pp;
			pp.createRectangle(LineSeg(pt, pts[0]), _XW, _YW);		
			if (pp.area()>pow(dEps,2))
			{
				Map map = _Map.getMap("NoTag[]");
				map.appendPlaneProfile("NoTag", pp);
				_Map.setMap("NoTag[]", map);	
			}
			
		}

		
		setExecutionLoops(2);
		return;
	}//endregion

// Trigger RemoveNoTagArea//region
	if (_Map.hasMap("NoTag[]"))
	{ 
		String sTriggerRemoveNoTagArea = T("|Remove No Tag Area|");
		addRecalcTrigger(_kContext, sTriggerRemoveNoTagArea );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveNoTagArea)
		{
			_Map.removeAt("NoTag[]", true);
			setExecutionLoops(2);
			return;
		}	
	}//endregion	
	


// collect shadow profiles
	PlaneProfile ppShadows[ents.length()];
	double dAreas[ents.length()];
	for (int i=0;i<ents.length();i++) 
	{ 
		GenBeam gb = (GenBeam)ents[i];
		TslInst tsl = (TslInst)ents[i];
		Opening opening = (Opening)ents[i];
		PlaneProfile pp;
		
		if (gb.bIsValid())
			pp = gb.envelopeBody().shadowProfile(pn);
		else if (opening.bIsValid())
		{
			pp = PlaneProfile(opening.plShape());
			if (bIsPlanView)
			{ 
				Element e = opening.element();
				Vector3d vecX = e.vecX(),vecY = e.vecY(),vecZ = e.vecZ();
				LineSeg seg = pp.extentInDir(vecX);
				seg = LineSeg(seg.ptStart() - vecZ* U(10e3), seg.ptEnd()+ vecZ* U(10e3));				
				PlaneProfile ppo; ppo.createRectangle(seg,vecX,vecZ);
				pp.createRectangle(e.segmentMinMax(),vecX,-vecZ);
				pp.intersectWith(ppo);
				pp.transformBy(vecY*vecY.dotProduct(e.ptOrg() - pp.coordSys().ptOrg()));
			}
	
		}
		else if (tsl.bIsValid())
			pp = PlaneProfile(tsl.realBody().shadowProfile(Plane(el.ptOrg(), vecZView)));		
		pp.transformBy(ms2ps);
		dAreas[i] = pp.area();
		pp.vis(i);
		ppShadows[i] = pp;
 
	}
	
// set dependencies
	if (nBehaviour==0 ||nBehaviour==2)
	{
	// remove any dependency to other elements		
		if (bIsElementViewport)
		{ 
			for (int i=_Entity.length()-1; i>=0 ; i--) 
			{ 
				Element _el = _Entity[i].element();
				if (_el.bIsValid()&& _el!=el)
				{
					//reportMessage(TN("|1045 removing at| ")+i);
					_Entity.removeAt(i);	
				}
			}			
		}

	// add dependency
		for (int i=0;i<ents.length();i++) 
		{ 
			_Entity.append(ents[i]);
			setDependencyOnEntity(ents[i]);
		}
	}
// reset dependencies	
	else if (_Entity.length()>1 && bIsElementViewport)
	{ 
	// remove any dependency but not the viewport
		for (int i=_Entity.length()-1; i>=0 ; i--) 
			if(_Entity[i].typeDxfName()!="VIEWPORT")
			{
				//reportMessage(TN("|1065 removing at| ")+i);
				_Entity.removeAt(i);	
			}
	}
	
 //order by size: the smaller the size the harder it gets to place a text on top of it
	for (int i=0;i<ents.length();i++) 
		for (int j=0;j<ents.length()-1;j++) 
		{ 
			if(dAreas[j]>dAreas[j+1])
			{ 
				ents.swap(j, j+1);
				ppShadows.swap(j, j+1);
				dAreas.swap(j, j+1);
			}
		}

// get papersize
//	double dHeight = vp.heightPS();
//	double dWidth = vp.widthPS();
//	int nRows = dHeight / dTextHeight;
//	int nColumns= dWidth/ dTextHeight;
//	Point3d cells[nRows * nColumns];
	Vector3d vecZ = _ZW;

// declare the protected profile
	PlaneProfile ppProtect;
// get protected profile of previous
	{ 
		int n = tslTags.find(_ThisInst);
		if (n>0)
		{ 
			ppProtect = tslTags[n - 1].map().getPlaneProfile("ppProtect");
		}
	}
	
// add outside-viewport-ring 
	PlaneProfile ppVp;
	double dXVp = vp.widthPS();
	double dYVp = vp.heightPS();
	Point3d ptCenVp= vp.ptCenPS();
	ppVp.createRectangle(LineSeg(ptCenVp-.5*(_XW*dXVp+_YW*dYVp),ptCenVp+.5*(_XW*dXVp+_YW*dYVp)),_XW,_YW);

	if (bLimitTagArea)
	{ 
	// get the profile of the viewport
		PlaneProfile ppVp2;
		ppVp2 = ppVp;
		ppVp2.shrink(-10*(dXVp + dYVp));
		ppVp2.subtractProfile(ppVp);
		//ppVp2.vis(3);
		//ppVp.transformBy(ps2ms);
		if (ppProtect.area()<pow(dEps,2))
			ppProtect= ppVp2;
		else
			ppProtect.unionWith(ppVp2);		
	}
	
// append custom blocking profiles	
	if (_Map.hasMap("NoTag[]"))
	{ 
		Map m = _Map.getMap("NoTag[]");
		for (int i=0;i<m.length();i++) 
		{ 
			if (ppProtect.area()<pow(dEps,2))
				ppProtect= m.getPlaneProfile(i);
			else
				ppProtect.unionWith(m.getPlaneProfile(i));	 
		}//next i	
	}
	
// append wall outlines to protection area
	for (int i=0;i<walls.length();i++) 
	{ 
		PLine pl = walls[i].plOutlineWall();
		pl.transformBy(ms2ps);
		ppProtect.joinRing(pl, _kAdd); 
	}//next i
	
	
	//if (bDebug)ppProtect.vis(6);

// declare a map where the leader start points of identical posnums can be stored
	Map mapMultiGuide;
		
// loop entities with values
	for (int i=0;i<ents.length();i++) 
	{ 
	// try casting
		GenBeam g = (GenBeam)ents[i];
		Sip sip = (Sip)ents[i];
		TslInst t= (TslInst)ents[i];
		Opening o = (Opening)ents[i];
		String sUniqueKey;

	//region CoordSys and dimension in modelspace
		CoordSys cs;
		Vector3d vecX, vecY, vecZ;
//		double dX, dY, dZ;
		if (g.bIsValid())
		{ 
			sUniqueKey = g.posnum();
			cs = g.coordSys();
			
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			
			if (vecX.isParallelTo(vecZView))
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				
			}
			else
			{ 
				vecZ = g.vecD(vecZView);			
			}
			vecY = vecX.crossProduct(-vecZ);
						
//			//TODO Filter Test
//			String ss = "@(SolidWidth)<(200)@(SolidLength)>(2000)";
//			String pairs[] = ss.tokenize("()()");
//			String pairs2[] = ss.tokenize("");
//			String pairVals = g.formatObject(ss);

			//dX = g.solidLength(); dY = g.solidWidth(); dZ = g.solidHeight();
		}
		else if (t.bIsValid())
		{ 
			sUniqueKey = t.posnum();
			cs = t.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if (bIsPlanView)
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
//			Body bd = t.realBody();
//			dX = bd.lengthInDirection(vecX); dY = bd.lengthInDirection(vecX); dZ = bd.lengthInDirection(vecX);
//			if (dX < dEps)dX = U(1);if (dY < dEps)dY = U(1);if (dZ < dEps)dZ = U(1);
		}	
		else if (o.bIsValid())
		{ 
			cs = o.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			
			if (bIsPlanView)
			{ 
				vecX = nOrientation==2?vecXView:vecX;	vecX.vis(o.coordSys().ptOrg(), 1);
				vecZ = vecZView;				
				vecY = vecX.crossProduct(-vecZ);			vecY.vis(o.coordSys().ptOrg(), 3);				
			}
//			dX = o.width(); dY = o.height(); dZ = el.dBeamWidth();
		}
		
	// sip specifics	
		Vector3d vecGrain;
		String sqTop,sqBottom; 
		if (sip.bIsValid())
		{
			vecGrain = sip.woodGrainDirection();
			vecGrain.transformBy(ms2ps);
			
			SipStyle style(sip.style());
			sqTop = sip.surfaceQualityOverrideTop();
			if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
			if (sqTop.length() < 1)sqTop = "?";
			int nQualityTop = SurfaceQualityStyle(sqTop).quality();
			
			sqBottom = sip.surfaceQualityOverrideBottom();
			if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
			if (sqBottom.length() < 1)sqBottom = "?";
			int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
		}
			
		
	//End CoordSys and dimension in modelspace//endregion 
	
	// get vecs
		Vector3d vecXI = _XW, vecYI=_YW, vecZI = _ZW;
		if (nOrientation==0)// byEntity
		{ 
			vecXI = vecX; vecXI.transformBy(ms2ps); vecXI.normalize();
			vecYI = vecY; vecYI.transformBy(ms2ps); vecYI.normalize();
			vecZI = vecZ; vecZI.transformBy(ms2ps); vecZI.normalize();
		}
		
	//	ensure readability
		if (bIsPlanView)
		{ 
			if (vecXI.dotProduct(_XW)<0 || vecXI.isCodirectionalTo(-_YW))
			{ 
				vecXI *= -1;
				vecYI *= -1;
			}
		}
		
		
		
	// color
		int c = nColor;
		if (c==-2)c=ents[i].color();
		dp.color(c);
		if (bDebug)ppShadows[i].vis(i);

	// the segment
	// get extents of profile
		LineSeg seg = ppShadows[i].extentInDir(vecXI);
		double dX = abs(vecXI.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecYI.dotProduct(seg.ptStart()-seg.ptEnd()));
		//seg.vis(1);

	// the content
		String sValues[] = ents[i].formatObject(sAutoAttribute).tokenize("\\");
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

					// opening unsupported by formatObject
						if (o.bIsValid())
						{ 
							if (sVariable=="@(WIDTH)") sTokens.append(o.width());
							else if (sVariable=="@(HEIGHT)") sTokens.append(o.height());
							else if (sVariable=="@(RISE)") sTokens.append(o.rise());
						}
						
						//region Sip unsupported by formatObject
						else if (sip.bIsValid())
						{ 
							if (sVariable=="@(QUANTITY)")
							{
								int n = sUniqueKeys.find(String(g.posnum()));
								if (n>0 && nQuantities[n]>1)
									sTokens.append(nQuantities[n] + T("|pcs| "));
							}	
							else if (sVariable=="@(GRAINDIRECTIONTEXT)")
								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")
								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
							else if (sVariable=="@(surfaceQualityBottom)".makeUpper())
								sTokens.append(sqBottom);	
							else if (sVariable=="@(surfaceQualityTop)".makeUpper())
								sTokens.append(sqTop);	
							else if (sVariable=="@(SURFACEQUALITY)")
							{
								String sQualities[] ={sqBottom, sqTop};
								if (sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);	
							}							
						}
						//End Sip unsupported by formatObject//endregion 						
					// genbeam unsupported by formatObject
						else if (g.bIsValid())
						{ 
							if (sVariable=="@(QUANTITY)")
							{
								int n = sUniqueKeys.find(String(g.posnum()));
								if (n>0 && nQuantities[n]>1)
									sTokens.append(nQuantities[n] + T("|pcs| "));
							}
							


						}	
					// tsl unsupported by formatObject
						else if (t.bIsValid())
						{ 
							if (sVariable=="@(QUANTITY)")
							{
								int n = sUniqueKeys.find(String(t.posnum()));
								if (n>-1 && nQuantities[n]>1)
									sTokens.append(nQuantities[n] + T("|pcs| "));
							}
						}	
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
			
	// default location and posnum
		int nPosNum=-1;
		Point3d ptLoc;
		if (g.bIsValid())
		{ 
			ptLoc = g.ptCenSolid();
			ptLoc.transformBy(ms2ps);
			nPosNum = g.posnum();
		}
		else if (o.bIsValid())
		{ 
			ptLoc.setToAverage(o.plShape().vertexPoints(true));
			ptLoc.transformBy(ms2ps);
			
		}
		else if (t.bIsValid())
		{
			ptLoc = t.ptOrg();
			ptLoc.transformBy(ms2ps);
			nPosNum = t.posnum();
		}
		else
			continue;
			
			
	// ignore invisible items
		if (ppVp.pointInProfile(ptLoc) == _kPointOutsideProfile)continue;
			
	// alignment
//		Vector3d vecX = _XW;
//		Vector3d vecY = _YW;
//		if (nOrientation==0 && g.bIsValid()) // byEntity
//		{ 
//			vecX = g.vecX();		vecY = g.vecY();
//			vecX.transformBy(ms2ps);	vecY.transformBy(ms2ps);
//			vecX.normalize();			vecY.normalize();
//			Vector3d vecZView = vecX.crossProduct(vecY);
//			if (!vecZView.isParallelTo(_ZW))	
//			{ 
//				if (vecY.isParallelTo(_ZW))vecY = vecZView;
//				else if (vecX.isParallelTo(_ZW))vecX = vecZView;
//				else
//				{ 
//					vecX = _XW;
//					vecY = _YW;
//				}
//			}
//			if (vecX.isCodirectionalTo(-_YW) || vecX.dotProduct(_XW)<0)	vecX *= -1;
//			vecZView = vecX.crossProduct(vecY);
//			if (!vecZView.isCodirectionalTo(_ZW))
//			{ 
//				vecY *= -1;
//				vecZView *= -1;
//			}
//			//vecX.vis(ptLoc, 1);vecY.vis(ptLoc, 92);vecZView.vis(ptLoc, 150);		
//		}
//		else if (nOrientation==2)// vertical
//		{ 
//			vecX = _YW;
//			vecY = - _XW;
//		}

	// multiline text	
		int nNumLine = sLines.length();
		double dYFlag;
		if (nNumLine>1)
			dYFlag = 3*(nNumLine-1)*.5;		

		double dXMax;
		double dYMax = dTextHeightStyle*nNumLine;
		for (int i=0;i<nNumLine;i++) 
		{ 
			String& sValue = sValues[i];
			double d=dp.textLengthForStyle(sValue,sDimStyle)*dFactor;
			dXMax=d>dXMax?d:dXMax;
			//dp.draw(sValue,ptLoc, vecX, vecY,0,dYFlag);
			//dYFlag-=3; 
		}
		dXMax += .6*dTextHeightStyle;
		dYMax += .6*dTextHeightStyle;

		vecX = vecXI;
		vecY = vecYI;
		vecZ = vecZI;


	// get axis from shadow
		LineSeg segAxis;
		//if (bDrawLeader)
		{ 
		// align default leader offset direction in depedency of element center		
			Vector3d vecYL = vecY;
			if (!vecX.isParallelTo(_XW) && _XW.dotProduct(ptMidEl-ptLoc)<0)
				vecYL *= -1;				
			else if (vecX.isParallelTo(_XW) && _YW.dotProduct(ptMidEl-ptLoc)>0)
				vecYL *= -1;				
			ptLoc.transformBy(vecX * dXLeaderOffset+vecYL * dYLeaderOffset);
			//if (bDebug)ptLoc.transformBy(vecY * 3 * dTextHeightStyle);//-vecX*U(30)+
			LineSeg seg = ppShadows[i].extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()))-2*dTextHeightStyle;
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
			
		// shorten axis segment if axis length is relativly	short
			if (dX<dXMax || 2*dX<dY)
				dX = dEps;
			segAxis = LineSeg(seg.ptMid() - vecX * .5 * dX, seg.ptMid() + vecX * .5 * dX);
			//ppShadows[i].vis(i);
			segAxis.vis(i);
		}


	// create circle
		PLine plBoundary(_ZW);
		double dRadius = dXMax>dYMax?dXMax*.5:dYMax*.5;
		if (dXMax<=1.6*dYMax && nNumLine<=3)
			plBoundary.createCircle(ptLoc,vecZ, dRadius);
		else
		{ 
			plBoundary.addVertex(ptLoc - .5 * (vecX * dXMax - vecY * dYMax));
			plBoundary.addVertex(ptLoc - .5 * (vecX * dXMax + vecY * dYMax),.25);
			plBoundary.addVertex(ptLoc + .5 * (vecX * dXMax - vecY * dYMax));
			plBoundary.addVertex(ptLoc + .5 * (vecX * dXMax + vecY * dYMax),.25);
			plBoundary.close();
		}

	// get/store multiGuideLineLocation
		int bHasMultiGuideLine = sUniqueKey.length()>0 && mapMultiGuide.hasPLine(sUniqueKey);

	//region location check
		{ 
			PLine plBase = plBoundary;
			Point3d ptBase = ptLoc;
			PlaneProfile pp(plBoundary);
			//if(nPosNum==136)	pp.vis(6);
			pp.intersectWith(ppProtect);
			double dArea = pp.area();
			int nCnt=1;	
		
		// check intersection
			int bIntersect = dArea>pow(dEps,2);
			if (!bIntersect)
			{ 
				ppProtect.joinRing(plBoundary,_kAdd);
			}
		
		//region try to resolve intersection
			PlaneProfile pps = ppShadows[i];
			int bOk;
			while(bIntersect && nCnt<100 && dYMax*dScale>0 && !bHasMultiGuideLine)
			{ 
				pps.shrink(-dYMax*dScale);
				LineSeg seg = pps.extentInDir(vecXI);
				double dX = abs(vecXI.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecYI.dotProduct(seg.ptStart()-seg.ptEnd()));
				
				CoordSys csx, csy;
				csx.setToMirroring(Plane(seg.ptMid(), vecXI));
				csy.setToMirroring(Plane(seg.ptMid(), vecYI));
							
			// location will be searched along pline divided by max height interdistance				
				PLine pl(_ZW);	
				
			// beams will be tested by up to 4 plines starting from the center to achieve a posnum near the center
				int nNumSubTest;
				Point3d ptA, ptB;
				if (ents[i].bIsKindOf(Beam()))
				{ 
					nNumSubTest = 4;
					ptA = seg.ptMid() + .5 * (vecYI * .5 * dY);
					pl.addVertex(ptA);
					pl.addVertex(seg.ptMid() + .5*(vecYI*.5*dY+vecXI*dX));
					ptB = seg.ptMid() + .5 * (vecXI * dX);
					pl.addVertex(ptB);					
				}
			// all others go for outer contour	
				else
				{ 
					PLine plRings[] = pps.allRings(true, false);
					if (plRings.length()>0)
					{
						nNumSubTest = 1;
						pl = plRings[0];
						ptA = pl.ptStart();
						ptB = pl.getPointAtDist(pl.length() / 2);
					}
				}

			// loop subtests
				for (int j=0;j<nNumSubTest;j++) 
				{ 
					
//				// skip if start and end is within protected area
//					if (ppProtect.pointInProfile(ptA)==_kPointInProfile && ppProtect.pointInProfile(ptB)==_kPointInProfile)
//					{ 
//						if (j==0 || j==2)pl.transformBy(csx);
//						if (j==1 || j==3)pl.transformBy(csy);	
//						continue;
//					}
					
					pl.vis(j);
					double d;
					while (d<pl.length())
					{ 
						Point3d pt = pl.getPointAtDist(d);//	pt.vis(nCnt);
					
					// first test: point within protected area?
						if (ppProtect.pointInProfile(pt)!=_kPointOutsideProfile)
						{ 
							d += dTextHeightStyle;
							continue;
						}
						
					// second test intersection after transformation
						plBoundary.transformBy(pt-ptLoc);				
						pp=PlaneProfile(plBoundary);
						pp.intersectWith(ppProtect);
						bIntersect = pp.area()>pow(dEps,2);
						if (!bIntersect)
						{ 
							ptLoc.transformBy(pt-ptLoc);
							ppProtect.joinRing(plBoundary,_kAdd);
							bOk = true;
							break;
						}
						else
							plBoundary.transformBy(ptLoc-pt);
						d += dTextHeightStyle;
					} 
					if (bOk || nNumSubTest==1)break;
					if (j==0 || j==2)pl.transformBy(csx);
					if (j==1 || j==3)pl.transformBy(csy);
				}//next j
				
				if (bOk)break;
				//pps.vis(nCnt);seg.vis(1);
				nCnt++;
			}

		
		//End try to resolve intersection	mode A//endregion 
//if(nPosNum==137)ppProtect.vis(i);
		}//endregion
		
		if(!bHasMultiGuideLine && sUniqueKey.length()>0 && sUniqueKeys.find(sUniqueKey)>-1)
		{ 
			mapMultiGuide.setPLine(sUniqueKey, plBoundary);	
			Vector3d vecXL = vecX.dotProduct(ptLoc+vecX*.5*dXMax-segAxis.ptMid())<0?vecX:- vecX;
			mapMultiGuide.setPoint3d("pt_"+sUniqueKey, plBoundary.closestPointTo(ptLoc + vecXL * .5 * dXMax));	
		}
		else if (bHasMultiGuideLine)
			bDrawLeader = true;



	// leader, do not draw if on axis
//  || abs(vecY.dotProduct(ptLoc-segAxis.closestPointTo(ptLoc)))>.5*dYMax	
		if (bDrawLeader)
		{ 
			PLine _plBoundary = bHasMultiGuideLine?mapMultiGuide.getPLine(sUniqueKey):plBoundary;
			Vector3d vecXL = vecX.dotProduct(ptLoc+vecX*.5*dXMax-segAxis.ptMid())<0?vecX:- vecX;
			Point3d pt1 = _plBoundary.closestPointTo(ptLoc + vecXL * .5 * dXMax);
			if (bHasMultiGuideLine && mapMultiGuide.hasPoint3d("pt_"+sUniqueKey))
			{ 
				Point3d pt1B = mapMultiGuide.getPoint3d("pt_"+sUniqueKey);
				double dist = Vector3d(pt1B - pt1).length();
				pt1B.vis(i);
				pt1.vis(i);
				if (dist<3*dTextHeightStyle)
					pt1 = pt1B;
			}
			
			
			Point3d pt2 = pt1 + vecXL *.5 * dTextHeightStyle;				
			Point3d pt3 = segAxis.closestPointTo(pt2 + vecXL *dXLeaderOffset);
			_plBoundary.vis(40);
			if (vecXL.dotProduct(pt3-pt1)<0)
			{ 
				pt1 = _plBoundary.closestPointTo(pt3);
				pt2 = pt1;
			}
			
			if (Vector3d(pt3-pt2).length()>dTextHeightStyle)
				dp.draw(PLine(pt1, pt2, pt3));
				
		
		// draw circle 
			PLine plCirc(_ZW);
			plCirc.createCircle(pt3, _ZW, dTextHeightStyle * .1);
			dp.draw(PlaneProfile(plCirc), _kDrawFilled, 70);
				
		}

		if (!bHasMultiGuideLine)
		{ 	
		// draw lines
			for (int i=0;i<nNumLine;i++) 
			{ 
				String sValue = sValues[i].trimLeft();
				dp.draw(sValue,ptLoc, vecX, vecY,0,dYFlag);
				dYFlag-=3; 
			}		
			
		// filled frame	
			if (nStyle>3 || nPosNum<0)
			{
			// change display color if not numbered and not in automode	
				if (nPosNum < 0 && (g.bIsValid() || t.bIsValid()))
				{
					if (nBehaviour<2)
					{
						setExecutionLoops(2);
					}
					dp.color(c==1?5:1);
				}
				dp.draw(PlaneProfile(plBoundary), _kDrawFilled, 80);
				dp.draw(plBoundary);
			}
		// frame
			if (nStyle>1)
				dp.draw(plBoundary);			
		}
		
		
		
		
	}
	
// execute at last	
	_ThisInst.setSequenceNumber(1000+nPriority);
	
// publish protection area
	_Map.setPlaneProfile("ppProtect", ppProtect);

// performance 
	if (bDebug)
	{ 
		reportMessage("\n" + scriptName() + _ThisInst.handle() +" done in "+ (getTickCount() - nTick) + "ms with priority "+nPriority + " time " + time );
	}

#End
#BeginThumbnail
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
9JL:_,N66NELHFM[*"%MNZ.-5.*L44`?_V3Y?
`




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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End