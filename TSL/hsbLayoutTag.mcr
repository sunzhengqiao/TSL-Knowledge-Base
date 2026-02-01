#Version 8
#BeginDescription
version value="1.9" date="13dec2018" author="thorsten.huck@hsbcad.com"
property 'decimals' has been removed: the digits can be controlled via the RLxx flag of the format, see property description
property sets supported
new context command to add panels, format description enhanced 

/// Select a viewport, select properties or catalog entry and press OK to place the instance next to paperspace.
/// Double click instance to select entities in modelspace.
/// If no format variables have been given yet, you can select from a list of available properties via right click custom menu

This tsl creates collsion free tags in paperspace, looking to modelspace entities.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.9" date="13dec2018" author="thorsten.huck@hsbcad.com"> property 'decimals' has been removed: the digits can be controlled via the RLxx flag of the format, see property description </version>
/// <version value="1.8" date="08nov2018" author="thorsten.huck@hsbcad.com"> bugfix </version>
/// <version value="1.7" date="08nov2018" author="thorsten.huck@hsbcad.com"> property sets supported </version>
/// <version value="1.6" date="08nov2018" author="thorsten.huck@hsbcad.com"> new context command to add panels, format description enhanced </version>
/// <version value="1.5" date="13aug2018" author="thorsten.huck@hsbcad.com"> new context command to add tsls </version>
/// <version value="1.4" date="04jul2018" author="thorsten.huck@hsbcad.com"> default selection method on double click changed to beams </version>
/// <version value="1.3" date="05jun2018" author="thorsten.huck@hsbcad.com"> decimal places fixed </version>
/// <version value="1.2" date="30apr2018" author="thorsten.huck@hsbcad.com"> new selection commands to filter beams or sheets </version>
/// <version value="1.1" date="30apr2018" author="thorsten.huck@hsbcad.com"> bugfix double detection </version>
/// <version value="1.0" date="26apr2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select a viewport, select properties or catalog entry and press OK to place the instance next to paperspace.
/// Double click instance to select entities in modelspace.
/// If no format variables have been given yet, you can select from a list of available properties via right click custom menu
/// </insert>

/// <summary Lang=en>
/// This tsl creates collsion free tags in paperspace, looking to modelspace entities.
/// </summary>//endregion


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion


	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "@(Posnum) @(SolidLength)", sAttributeName);	
	sAttribute.setDescription(T("|Defines the format of the composed value.|")+
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
		TN("RL |​Round Local: Rounds a number using the local regional settings..|")
	);
	sAttribute.setCategory(category);

//Display
	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);

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


// Trigger SelectEntities
	String sTriggerSelectEntities = T("|Select Entities|");
	addRecalcTrigger(_kContext, sTriggerSelectEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectEntities)
	{
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entities
			PrEntity ssE(T("|Select entity(s)|"), Entity());
			if (ssE.go())
				_Entity.append(ssE.set());
			bSuccess = Viewport().switchToPaperSpace();	
		}
		setExecutionLoops(2);
		return;
	}	
	
	
// Trigger SelectBeams
	String sTriggerSelectBeams = T("|Select Beam(s)|");
	addRecalcTrigger(_kContext, sTriggerSelectBeams );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSelectBeams || _kExecuteKey==sDoubleClick))
	{
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entities
			PrEntity ssE(T("|Select beam(s)|"), Beam());
			if (ssE.go())
				_Entity.append(ssE.set());
			bSuccess = Viewport().switchToPaperSpace();	
		}
		setExecutionLoops(2);
		return;
	}
	
// Trigger SelectPanels
	String sTriggerSelectPanels = T("|Select Panel(s)|");
	addRecalcTrigger(_kContext, sTriggerSelectPanels );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectPanels)
	{
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entities
			PrEntity ssE(T("|Select panel(s)|"), Sip());
			if (ssE.go())
				_Entity.append(ssE.set());
			bSuccess = Viewport().switchToPaperSpace();	
		}
		setExecutionLoops(2);
		return;
	}	
	
// Trigger SelectSheets
	String sTriggerSelectSheets = T("|Select Sheets|");
	addRecalcTrigger(_kContext, sTriggerSelectSheets );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectSheets)
	{
		String sZoneInput = getString(T("|Specify zones seperated by a semicolon, <Enter> to select from all zones|"));
		String sZones[] = sZoneInput.tokenize(";");
		
		int nZones[0];
		for (int i=0;i<sZones.length();i++) 
		{ 
			int nZone = sZones[i].atoi();
			if (nZone>-6 && nZone<11 && nZone!=0)
			{ 
			// convert to -5 to 5 norm
				if (nZone>5)nZone = 5 - nZone;
				if (nZones.find(nZone)<0)
					nZones.append(nZone);
			}	 
		}

		
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select sheet(s)|"), Sheet());
			if (ssE.go())
				ents.append(ssE.set());
				
			for (int i=0;i<ents.length();i++) 
			{ 
				int nZone =ents[i].myZoneIndex();
				if (nZones.find(nZone)>-1)
				{ 
					_Entity.append(ents[i]);
				}
				 
			}

				
			bSuccess = Viewport().switchToPaperSpace();	
		}
		setExecutionLoops(2);
		return;
	}
	
	
// Trigger SelectTSLs
	String sTriggerSelectTsl = T("|Select TSL's|");
	addRecalcTrigger(_kContext, sTriggerSelectTsl );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectTsl)
	{
		String sScriptNames[] = TslScript().getAllEntryNames();
		String sMsg = T("|Specify tsl's by index seperated by a semicolon, <Enter> to select all|");
		
	// remove some known not suited
		for (int i=sScriptNames.length()-1; i>=0 ; i--) 
		{ 
			String s=sScriptNames[i]; 
			s.makeLower();
			if (s.left(3)=="sd_")
				sScriptNames.removeAt(i);	
			
		}//next i
	
	// order alphabetically
		for (int i=0;i<sScriptNames.length();i++) 
			for (int j=0;j<sScriptNames.length()-1;j++) 
				if (sScriptNames[j]>sScriptNames[j+1])
					sScriptNames.swap(j, j + 1);
		
	// print available tsl names in in the report dialog
		reportNotice("\n" + sMsg);
		for (int i=0;i<sScriptNames.length();i++) 
		{ 
			int nIndex = i + 1;
			String sLine = sScriptNames[i];
			if (i<9)sLine = "  "+nIndex + ".";
			else if (i<99)sLine = " "+nIndex + ".";
			else sLine = nIndex+".";
			sLine += "	"+sScriptNames[i];	
			reportNotice("\n"+sLine); 
			 
		}//next i
		
		
	// get selected	
		String sNameList = getString(sMsg);
		String sIndices[] = sNameList.tokenize(";");
		String sSelectedNames[0];
		for (int i=0;i<sIndices.length();i++) 
		{ 
			int nIndex = sIndices[i].atoi();
			if (nIndex>0 && nIndex<=sScriptNames.length())
			{ 
				sSelectedNames.append(sScriptNames[nIndex-1]);
			}	 
		}
	
	// get all
		if (sNameList.length()==0)
			sSelectedNames = sScriptNames;

		
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select tsl(s)|"), TslInst());
			if (ssE.go())
				ents.append(ssE.set());
				
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst tsl = (TslInst)ents[i];

				if (tsl.bIsValid() && sSelectedNames.find(tsl.scriptName())>-1)
				{ 
					_Entity.append(ents[i]);
				}
				 
			}

				
			bSuccess = Viewport().switchToPaperSpace();	
		}
		setExecutionLoops(2);
		return;
	}	
	


// Trigger RemoveEntities
	String sTriggerRemoveEntities = T("|Remove entities|");
	addRecalcTrigger(_kContext, sTriggerRemoveEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
	{
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select entity(s)|"), Entity());
			if (ssE.go())
				ents.append(ssE.set());
				
			for (int i=0;i<ents.length();i++) 
			{ 
				int n = _Entity.find(ents[i]);
				if (n>-1)
					_Entity.removeAt(n);
				 
			}	
			bSuccess = Viewport().switchToPaperSpace();	
		}
		setExecutionLoops(2);
		return;
	}	



// ints
	int nOrientation = sOrientations.find(sOrientation);
	int nStyle = sStyles.find(sStyle);
	int bDrawLeader = nStyle % 2 == 1;
	

// check if the viewport has hsb data
	//if (!vp.element().bIsValid()) return;

	CoordSys csW(_PtW, _XW, _YW, _ZW);
	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
//	Element el = vp.element();	
//	ElementMulti em = (ElementMulti)el;
	

// get the profile of the viewport
	PlaneProfile ppVp(csW);
	PLine plVp;
	double dX = vp.widthPS();
	double dY = vp.heightPS();
	Point3d ptCen = vp.ptCenPS();
	plVp.createRectangle(LineSeg(ptCen-.5*(_XW*dX+_YW*dY),ptCen+.5*(_XW*dX+_YW*dY)),_XW,_YW);
	ppVp.joinRing(plVp,_kAdd);
	ppVp.transformBy(ps2ms);
	//ppVp.vis(6);


	Vector3d vecZM = _ZW;
	vecZM.transformBy(ps2ms);
	Plane pnWM(ppVp.coordSys().ptOrg(), vecZM);
	
// Display
	Display dp(_ThisInst.color());
	dp.dimStyle(sDimStyle);
	double dFactor = 1;
	double dTextHeightStyle =dp.textHeightForStyle("O",sDimStyle);
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}		
	
// get stored grip locations
	Map mapGrips = _Map.getMap("Grip[]");
	
	
// collect entities within range
	Entity ents[0];
	PlaneProfile pps[0];
	Body bodies[0];
	double dAreas[0];
	String handles[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& ent= _Entity[i]; 
		
	// entity ref of grip index, default = empty;
		String handle;
		if (mapGrips.hasVector3d(ent.handle()))
			handle=ent.handle();	
		
		
		
		Body bd = ent.realBody();
	
	// refuse non solids
		if (bd.volume() < pow(dEps, 3))continue;
		
	// collect profile
		PlaneProfile pp = bd.shadowProfile(pnWM);
		
	// test intersection with transfomed view profile	
		PlaneProfile ppX = pp;
		ppX.intersectWith(ppVp);
		if (ppX.area()<pow(dEps,2))
		{ 
			//pp.vis(1);
			continue;
		}
		else
		{
			ents.append(ent);
			bodies.append(bd);
			ppX.transformBy(ms2ps);
			dAreas.append(ppX.area());
			pps.append(ppX);
			handles.append(handle);
			//ppX.vis(3);
		} 
	}
	
	
// Trigger SetFormat
	String sTriggerSetFormat = T("|Set Format Expression|");
	addRecalcTrigger(_kContext, sTriggerSetFormat );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetFormat)
	{
	// get classes of selected entities
		Entity entsClasses[0];
		String sClasses[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			String sClass= ents[i].typeDxfName(); 
			if (sClasses.find(sClass)<0)
			{ 
				sClasses.append(sClass);
				entsClasses.append(ents[i]);
			}	 
		}
	
	
	// the max number of characters of the property description
		int x = 25;
	
	// show available formatVariables per type
		String sAllVariables[0];
		int nNum=1;
		for (int i=0;i<sClasses.length();i++) 
		{ 
			reportNotice("\n" + T("|Variables for type| ") + sClasses[i]);
			String sVariables[] = entsClasses[i].formatObjectVariables();
			
			
//		// translate and order	
			String sTVariables[0];
			for (int v=0;v<sVariables.length();v++)
				sTVariables.append(T("|"+sVariables[v]+ "|"));
			for (int v=0;v<sTVariables.length();v++)
				for (int j=0;j<sTVariables.length()-1;j++)
					if(sTVariables[j]>sTVariables[j+1])
					{ 
						sTVariables.swap(j, j + 1);
						sVariables.swap(j, j + 1);	
					}
			sAllVariables.append(sVariables);
			
		// show numbered list of variables
			for (int j=0;j<sVariables.length();j++) 
			{ 
				int n = nNum;
				nNum++;// increment over multiple classes
				String sLine = n < 10 ? "  "+n : (n < 100 ? " "+n :n);
				sLine = sLine + " " + sTVariables[j];
				
			// trim line to x characters
				int nNumChars = sLine.length();
				if (nNumChars>x-4)
				{
					sLine = sLine.left(x)+"... ";
					nNumChars = sLine.length();
				}
					
			// append blanks to align preview property	
				for (int k=0;k<x-nNumChars+4;k++) sLine += " ";
				
				sLine += "	" + entsClasses[i].formatObject("@("+sVariables[j]+")");
				reportNotice("\n	" + sLine); 
				 
			} 
		}
		
		String sMsg = T("|Enter the index of the property which you want to add or remove|");
		reportNotice("\n" + sMsg); 
		int nSelected = getInt(sMsg)-1;

		
		if (nSelected>-1 && nSelected<sAllVariables.length())
		{ 
			String sVariable = sAllVariables[nSelected];
			String sFormat = "@(" + sVariable + ")";

			int bAdd = sAttribute.find(sFormat, 0) <0;		
			
			if (bAdd)
			{
				sAttribute.set(sAttribute + (sAttribute.length()>0?" ":"")+sFormat);
				reportMessage("\n"+sAttributeName + T(" |set to|: ") + sAttribute); 
			}
			else
			{ 
				int a=sAttribute.find("@(" + sVariable,0);	
				if (a >-1)
				{
					int b=sAttribute.find(")",a);	
					String left = sAttribute.left(a);
					String right = sAttribute.right(sAttribute.length() - b-1);
					sFormat = left + right;
					sAttribute.set(sFormat.trimLeft().trimRight());
				}
			}			
		}
		setExecutionLoops(2);
		return;
	}	
	
// order by visible area
	for (int i=0;i<ents.length();i++) 
		for (int j=0;j<ents.length()-1;j++) 
			if (dAreas[j]>dAreas[j+1])
			{
				ents.swap(j, j + 1);
				bodies.swap(j, j + 1);
				dAreas.swap(j, j + 1);
				pps.swap(j, j + 1);
				handles.swap(j, j + 1);
			}
	
// order by handle
	if (mapGrips.length()>0)
	{ 
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
				if (handles[j]<handles[j+1])
				{
					ents.swap(j, j + 1);
					bodies.swap(j, j + 1);
					dAreas.swap(j, j + 1);
					pps.swap(j, j + 1);
					handles.swap(j, j + 1);
				}		
	}
			


// Trigger SetLeaderOffset
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

// set fixed location // TODO only on debug
	String sHandleToAdd;
	Point3d ptFrom;
	String sTriggerSetLocation = T("|Move tag|");
	if (bDebug)
		addRecalcTrigger(_kContext, sTriggerSetLocation);
	if (bDebug & _bOnRecalc && _kExecuteKey==sTriggerSetLocation)
	{

		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
		// prompt for entity
			Entity ent = getEntity(T("|Select entity(s)|"));
			sHandleToAdd = ent.handle();
			bSuccess = Viewport().switchToPaperSpace();	
		}
//
//		setExecutionLoops(2);
//		return;
	}




// declare the protected profile
	PlaneProfile ppProtect;


// loop ents to be tagged
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity& ent = ents[i];
		GenBeam gb = (GenBeam)ent;
		String sVariables[] = ent.formatObjectVariables();
		PlaneProfile& pp = pps[i];
		String handle = handles[i];
		//pp.vis(i); 
		LineSeg seg = pp.extentInDir(_XW);

//	// collect text lines
		String sLine= ent.formatObject(sAttribute);
		
	// find muti lines //TODO multiline
		String sLines[] = { sLine};

	// default location
		Point3d ptLoc = seg.ptMid();
		if (handle.length()>0)
		{ 
			ptLoc = _PtW + mapGrips.getVector3d(handle);
		}

	// alignment
		Vector3d vecX = _XW, vecY = _YW, vecZ = _ZW;
		if (nOrientation == 0 && gb.bIsValid())
		{ 
			Vector3d vecXGb = gb.vecX();
			vecXGb.transformBy(ms2ps);
			if (!vecXGb.isParallelTo(_ZW))
			{ 
				vecX = vecXGb.crossProduct(_ZW).crossProduct(-_ZW);
				vecX.normalize();
				vecY = vecX.crossProduct(-_ZW);
				if (vecY.dotProduct(_YW)<0 || (-vecX).isCodirectionalTo(_YW))
				{ 
					vecX *= -1;
					vecY *= -1;
				}
			}
		}
		else if (nOrientation==2)// vertical
		{ 
			vecX = _YW;
			vecY = - _XW;
		}		

	// multiline	
		int nNumLine = sLines.length();
		double dYFlag;
		if (nNumLine>1)
			dYFlag = 3*(nNumLine-1)*.5;	
	
		double dXMax;
		double dYMax = dTextHeightStyle*nNumLine;
		for (int i=0;i<nNumLine;i++) 
		{ 
			String& sLine = sLines[i];
			double d=dp.textLengthForStyle(sLine,sDimStyle)*dFactor;
			dXMax=d>dXMax?d:dXMax;
			//dp.draw(sValue,ptLoc, vecX, vecY,0,dYFlag);
			//dYFlag-=3; 
		}
		dXMax += .6*dTextHeightStyle;
		dYMax += .6*dTextHeightStyle;


	// get axis from shadow
		LineSeg segAxis;
		if (bDrawLeader)
		{ 
		// align default leader offset direction in depedency of vieport center		
			Vector3d vecYL = vecY;
			if (!vecX.isParallelTo(_XW) && _XW.dotProduct(ptCen-ptLoc)<0)
				vecYL *= -1;				
			else if (vecX.isParallelTo(_XW) && _YW.dotProduct(ptCen-ptLoc)>0)
				vecYL *= -1;				
			ptLoc.transformBy(vecX * dXLeaderOffset+vecYL * dYLeaderOffset);
			//if (bDebug)ptLoc.transformBy(vecY * 3 * dTextHeightStyle);//-vecX*U(30)+
			LineSeg seg = pp.extentInDir(vecX);
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
	// create rounded pline
		else
		{ 
			plBoundary.addVertex(ptLoc - .5 * (vecX * dXMax - vecY * dYMax));
			plBoundary.addVertex(ptLoc - .5 * (vecX * dXMax + vecY * dYMax),.25);
			plBoundary.addVertex(ptLoc + .5 * (vecX * dXMax - vecY * dYMax));
			plBoundary.addVertex(ptLoc + .5 * (vecX * dXMax + vecY * dYMax),.25);
			plBoundary.close();
		}


	//region location check
		if (handle.length()<1)
		{ 
			PLine plBase = plBoundary;
			Point3d ptBase = ptLoc;
			PlaneProfile pp(plBoundary);
			//if(nPosNum==136)	pp.vis(6);
			pp.intersectWith(ppProtect);
			double dArea = pp.area();
			int nCnt=1;	
			
			Vector3d vecDir=vecX;
			Vector3d vecPerp=vecY;
			
			double dDir = dXMax;
			
		
		// check intersection
			int bIntersect = dArea>pow(dEps,2);
			if (!bIntersect)
			{ 
				ppProtect.joinRing(plBoundary,_kAdd);
			}
		
		// try to resolve intersection	
			int x=1;
			int nNumSeg = 4;
			while(nCnt<160 && dArea>pow(dEps,2))
			{
			// get offset
				Point3d pts[] = plBase.intersectPoints(Plane(ptBase, vecPerp));
				if (pts.length()>0)
					dDir = .5*(pts[1] - pts[0]).length()+dTextHeightStyle;
			// fall back set base offset value dependent from direction	
				else
					dDir=nCnt%8==0?dXMax*1.2:dYMax;					
								
			// cumulate offset after 360°	
				if(nCnt>0 && nCnt%4==0)
				{
					vecDir *= -1;
					double d=dDir;				
					dDir+=dDir*x;	
					if (nCnt%8==0)
						dDir += d;
					else
						dDir += .5 * d;
					x++;	
					nNumSeg * 2; // incrementing the angles after 2Pi
				}
		
			// test intersection after transformation
				plBoundary.transformBy(vecDir*dDir);
//				if (nPosNum==28 || nPosNum==646)
//					plBoundary.vis(nCnt);				
				pp=PlaneProfile(plBoundary);
				pp.intersectWith(ppProtect);
				dArea = pp.area();
				bIntersect = dArea>pow(dEps,2);
				if (!bIntersect)
				{ 
					ptLoc.transformBy(vecDir*dDir);
					ppProtect.joinRing(plBoundary,_kAdd);
					break;
				}
			// transform back if intersction was found
				else
					plBoundary.transformBy(-vecDir*dDir);					
						
			// align transformation vectors
				double dAngle = 360 / nNumSeg;
				vecDir = vecDir.rotateBy(dAngle,vecZ);
				vecPerp= vecPerp.rotateBy(dAngle,vecZ);
				nCnt++;
			}
			//if(nPosNum==137)ppProtect.vis(i);
		}
	// handle/grip based
		else
		{
			ppProtect.joinRing(plBoundary,_kAdd);

		}//endregion


	// collect point from the entity which shall be moved
		if (sHandleToAdd.length()>0 && sHandleToAdd==handle)
			ptFrom = ptLoc;



	// draw lines
		for (int i=0;i<nNumLine;i++) 
		{ 
			String& sLine = sLines[i];
			dp.draw(sLine,ptLoc, vecX, vecY,0,dYFlag);
			dYFlag-=3; 
		}	

	// filled frame	
		if (nStyle>3)// || nPosNum<0)
		{
//			if (nPosNum < 0)
//			{
//				if (nBehaviour<2)
//					setExecutionLoops(2);
//				dp.color(c==1?6:1);
//			}
			dp.draw(PlaneProfile(plBoundary), _kDrawFilled, 80);
			dp.draw(plBoundary);
		}
	// frame
		if (nStyle>1)
			dp.draw(plBoundary);
			
			
	// leader, do not draw if on axis
		if (bDrawLeader && abs(vecY.dotProduct(ptLoc-segAxis.closestPointTo(ptLoc)))>.5*dYMax)
		{ 
			Vector3d vecXL = vecX.dotProduct(ptLoc+vecX*.5*dXMax-segAxis.ptMid())<0?vecX:- vecX;
			Point3d pt1 = plBoundary.closestPointTo(ptLoc + vecXL * .5 * dXMax);
			Point3d pt2 = pt1 + vecXL *.5 * dTextHeightStyle;
			Point3d pt3 = segAxis.closestPointTo(pt2 + vecXL *dXLeaderOffset);
			
			if (vecXL.dotProduct(pt3-pt1)<0)
			{ 
				pt1 = plBoundary.closestPointTo(pt3);
				pt2 = pt1;
			}
			//pt3.vis(3);pt1.vis(5);
			dp.draw(PLine(pt1, pt2, pt3));
		}			
			

	}
	
	if (_bOnRecalc && _kExecuteKey==sTriggerSetLocation)
	{

	// prompt for point input
		PrPoint ssP(TN("|Select point|"),ptFrom); 
		Point3d ptTo;
		if (ssP.go()==_kOk) 
			ptTo = ssP.value(); // append the selected points to the list of grippoints _PtG
			
		mapGrips.setVector3d(sHandleToAdd, ptTo - _PtW);
		_Map.setMap("Grip[]", mapGrips);
		setExecutionLoops(2);
		return;
	}	
//_Map = Map();

	
// draw something to select	
	String sTexts[0];
	{ 
		sTexts.append(scriptName());
		int n = _Entity.length() - _Viewport.length();
		if (n>0)
			sTexts.append(n + T(" |selected|, ") + ents.length() + T(" |visible|"));	
		else
		{
			sTexts.append(T("|Double click to select beams in modelspace.|"));	
			sTexts.append(T("|Use context menu to use other selection methods.|"));	
		}
			
		if (sAttribute.find("@(",0)<0)
		{
			sTexts.append(T("|Specify format variables.|"));
			if (n>0)sTexts.append(T("|You can also select properties from custom context menu.|"));			
		}
		
		double dYFlag = 1;
		for (int i=0;i<sTexts.length();i++) 
		{ 
			dp.draw(sTexts[i], _Pt0, _XW, _YW, 1, dYFlag);
			dYFlag -= 3;	 
		}
	}
	
	
	
	
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
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
76:W]&T<Z7YC-,)&D`!`7`&*U:*`/_]ET
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="83" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End