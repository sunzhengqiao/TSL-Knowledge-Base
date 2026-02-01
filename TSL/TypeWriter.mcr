#Version 8
#BeginDescription
#Versions
Version 1.1 05.05.2022 HSB-15212 bugfix, new display modes and xml structure revised , Author Thorsten Huck
Version 1.0 14.06.2021 HSB-12210 TypeWriter initial version

This tsl creates freeprofile tools as type writing of polyline based character set

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
// 1.1 05.05.2022 HSB-15212 bugfix, new display modes and xml structure revised , Author Thorsten Huck
// 1.0 14.06.2021 HSB-12210 TypeWriter initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select genbeam and enter text to be milled
/// </insert>

// <summary Lang=en>
// This tsl creates freeprofiles of a specified character set
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TypeWriter")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Define Character|") (_TM "|Select TypeWriter-Tool|"))) TSLCONTENT
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

// distinguish if current background is light or dark	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	
	int lightblue = rgb(204,204,255);
	int darkblue = rgb(26,50,137);	

	
	int yellow = rgb(241,235,31);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int blue = rgb(69,84,185);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);
	
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);


	int darkyellow = rgb(254, 204, 102);	
	
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	
	double dViewHeight = getViewHeight();

	String tDisabled = T("<|Disabled|>"),kVersal="VersalHeight";
//end Constants//endregion

//region All Settings

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="TypeWriter";
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
	String sFontNames[0];
	Map mapFont,mapFonts = mapSetting.getMap("Font[]");
	for (int i=0;i<mapFonts.length();i++) 
	{ 
		Map m = mapFonts.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && sFontNames.findNoCase(name,-1)<0)
			sFontNames.append(name);	 
	}//next i
	sFontNames = sFontNames.sorted();
	
	if (sFontNames.length()==0)
		sFontNames.append("Standard");
//endregion 	

//region Settings Freeprofile
	String sFileName2 ="hsbCLT-Freeprofile";
	Map mapSetting2;

// compose settings file location
	String sFullPath2 = sPath+"\\"+sFolder+"\\"+sFileName2+".xml";

// read a potential mapObject
	MapObject mo2(sDictionary ,sFileName2);
	if (mo2.bIsValid())
	{
		mapSetting2=mo2.map();
		setDependencyOnDictObject(mo2);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo2.bIsValid() )
	{
		String sFile=findFile(sFullPath2); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName2+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting2.readFromXmlFile(sFile);
			mo2.dbCreate(mapSetting2);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName2 + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + sFile+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings Freeprofile//endregion	

//region Read Settings2
	int bHasXmlSetting;
	String sToolNames[0];
	double dDiameters[0];
	double dLengths[0];
	int nToolIndices[0];
{ 
	String k;
	Map m,mapTools= mapSetting2.getMap("Tool[]");
	for (int i=0;i<mapTools.length();i++) 
	{ 
		Map m= mapTools.getMap(i);
		
		String name;
		int index, bOk=true;
		double diameter, length;
		k="Diameter";		if (m.hasDouble(k) && m.getDouble(k)>0)	diameter = m.getDouble(k);	else bOk = false;
		k="Length";			if (m.hasDouble(k) && m.getDouble(k)>0)	length = m.getDouble(k);	else bOk = false;
		k="Name";			if (m.hasString(k))	name = m.getString(k);		else bOk = false;
		k="ToolIndex";		if (m.hasInt(k))	index = m.getInt(k); 		else bOk = false;
		
		if (bOk && sToolNames.find(name)<0 && nToolIndices.find(index)<0)
		{
			sToolNames.append(name);
			nToolIndices.append(index);
			dDiameters.append(diameter);
			dLengths.append(length);
			bHasXmlSetting = true;
		}	
	}//next i	
	


// append predefined values if no custom list found
	if (sToolNames.length()<1)
	{ 
	// default modes, not used as soon as settings or opmKey catalogs are found	
		String sDefaultModes[] = {T("|Finger Mill|"),T("|Universal Mill|"),T("|Vertical Finger Mill|")};
		double sDefaultDiameters[0];
		double sDefaultLengths[0];
		int nDefaultModes[0];

		PLine pl(_Pt0, _Pt0 + _XW * U(100));
		for (int i=0;i<sDefaultModes.length();i++) 
		{ 
			FreeProfile fp(pl,_kLeft);
			fp.setCncMode(i);
			sDefaultDiameters.append(fp.millDiameter());
			sDefaultLengths.append(0);
			nDefaultModes.append(i);			 
		}//next i		

		for (int i=0;i<sDefaultModes.length();i++) 
		{ 
			int n =sToolNames.find(sDefaultModes[i]); 	
			if (n<0)// && nToolIndices.find(nDefaultModes[i])<0)
			{ 
				sToolNames.append(sDefaultModes[i]);
				nToolIndices.append(nDefaultModes[i]);
				dDiameters.append(sDefaultDiameters[i]);
				dLengths.append(0);// unknown
			}	 
		}//next i

		reportMessage("\n"+ scriptName() + T(": |Unexpected error, please validate your tool definition.| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}	
	sToolNames.sorted();
	sToolNames.insertAt(0, tDisabled);
	
	
}


	
//End Read Settings2//endregion 


//End All Settings//endregion 

//region Properties
category = T("|Text|");

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);

	String sHeightName=T("|Font Height|");	
	PropDouble dHeight(nDoubleIndex++, U(200), sHeightName);	
	dHeight.setDescription(T("|Defines the Height|"));
	dHeight.setCategory(category);
	
	String sPitchName=T("|Pitch Factor|");	
	PropDouble dPitch(nDoubleIndex++, 1, sPitchName);	
	dPitch.setDescription(T("|Scales the pitch|"));
	dPitch.setCategory(category);


	String sFontName=T("|Font|");	
	PropString sFont(nStringIndex++,sFontNames, sFontName);	
	sFont.setDescription(T("|Defines the name of the font|"));
	sFont.setCategory(category);
	if (sFontNames.findNoCase(sFont ,- 1) < 0)sFont.set(sFontNames.first());

	String sPreviewModes[] = { T("|Alphabet|"), T("|Defined Characters|"),sFormatName};
	String sPreviewModeName=T("|Preview Mode|");	
	PropString sPreviewMode(nStringIndex++, sPreviewModes, sPreviewModeName);	
	sPreviewMode.setDescription(T("|Defines the PreviewMode|"));
	sPreviewMode.setCategory(category);
	int nPreviewMode= sPreviewModes.findNoCase(sPreviewMode,-1);	
	
category = T("|Tool|");
	String sToolNameName=T("|Tool|");
	PropString sToolName(nStringIndex++, sToolNames.sorted(), sToolNameName);
	sToolName.setDescription(T("|Defines the CNC Tool|"));
	sToolName.setCategory(category);
	if (sToolNames.findNoCase(sToolName,-1)<0 && sToolNames.length()>0)
	{ 
		sToolName.set(sToolNames.first());
		reportMessage("\n" + scriptName() + ": " +T("|Tool definition not found, changed to| "+sToolName));
	}
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(20), sDepthName);	
	dDepth.setDescription(T("|Defines the depth of the font milling|"));
	dDepth.setCategory(category);

	
category = T("|Character Definition|");
	String sRefHeightName=T("|Height|");	
	PropDouble dRefHeight(nDoubleIndex++, U(100), sRefHeightName);	
	dRefHeight.setDescription(T("|Defines the reference height of the characters|"));
	dRefHeight.setCategory(category);	
	dRefHeight.setReadOnly(nPreviewMode <= 0 ? false : _kHidden);


//End Properties//endregion 



//region Read characters
	double dVersalHeight = U(100);
	for (int i = 0; i < mapFonts.length(); i++)
	{
		Map m = mapFonts.getMap(i);
		String name = m.getMapName();
		if (name.makeUpper() == sFont.makeUpper())
		{
			mapFont = m;
			double d = m.getDouble("VersalHeight");
			dVersalHeight = d > 0 ? d : U(100);
			break;
		}
	}
	Map mapChars= mapFont.getMap("Character[]");	
//endregion 






//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		dRefHeight.setReadOnly(false);	

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

	
	// prompt for genbems
		Entity ents[0];
		PrEntity ssE(T("|Select a genbeam|") + T("|<Enter> to define font|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i]; 
			if (gb.bIsValid())
			{ 
				_GenBeam.append(gb);
				break;
			}		 
		}//next i

		_Pt0 = getPoint();
		return;
	}	
// end on insert	__________________//endregion

//region Standards
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Point3d ptRef = _PtW;
	double dMyDepth = dDepth;
	GenBeam gb;
	Beam bm;
	Sip sip;
	Sheet sheet;
	int bDefMode = true;
	PlaneProfile ppFace;
	if (_GenBeam.length()>0)
	{ 
		bDefMode = mapChars.length()<1;
		gb = _GenBeam[0];
		bm = (Beam)gb;
		sip = (Sip)gb;
		sheet = (Sheet)gb;
		vecX = gb.vecX();
		vecY = gb.vecY();
		vecZ = gb.vecZ();
		
		assignToGroups(gb, 'I');
		
		if (bm.bIsValid())
		{ 
			vecZ = bm.vecD(vecZView);
			vecY = vecX.crossProduct(-vecZ);
		}
		else if (vecZView.dotProduct(vecZ)<0)
		{ 
			vecZ *= -1;
			vecY *= -1;
		}
		
		double dZ = gb.dD(vecZ);
		ptRef = gb.ptCen() + vecZ * .5 * dZ;
		ppFace = gb.realBody().extractContactFaceInPlane(Plane(ptRef, vecZ), dEps);
		if (dMyDepth <= 0)dMyDepth = dZ;
	}



	Plane pn(ptRef, vecZ);
	CoordSys cs(ptRef, vecX, vecY, vecZ);
	Line lnX(ptRef, vecX), lnY(ptRef, vecY);

	int nToolIndex = sToolNames.findNoCase(sToolName, -1)-1;
	int nCncMode;
	double dDiameter;	
	double dLength;	
	if (sToolName!=tDisabled)
	{ 
		nCncMode = nToolIndices[nToolIndex];
		dDiameter = dDiameters[nToolIndex];	
		dLength = dLengths[nToolIndex];		
	}

	Display dpRed(1), dpModel(-1),dpPath(40);
	dpRed.trueColor(red,50);
	dpModel.trueColor(bDefMode?lightblue:darkyellow,50);
	dpModel.textHeight(dHeight>0?dHeight:U(100));
	dpPath.trueColor(darkyellow);
	
	String text;
	if (bDefMode)
		text= _ThisInst.formatObject(sFormat);
	else if (bm.bIsValid())
		text= bm.formatObject(sFormat);
	else if (sheet.bIsValid())
		text= sheet.formatObject(sFormat);
	else if (sip.bIsValid())
		text= sip.formatObject(sFormat);

	Point3d ptChar = _Pt0;
	ptChar += vecZ * vecZ.dotProduct(ptRef - ptChar);
	_Pt0 = ptChar;
	_Pt0.vis(2);
	
//End Standards//endregion 

//region Definition Mode: show all available characters
	String allChar = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzÄäÖöÜü,.-;:_#'*+<>|1234567890ß!§$%&/()=?`´";
	if (bDefMode && text.length()==0)
	{ 
		for (int i = 0; i < allChar.length(); i++)
		{
			String c = allChar.getAt(i);
			for (int j = 0; j < mapChars.length(); j++)
				if (mapChars.nameAt(j) == c)
					text += c;
		}		
	}
	
	
//End Definition Mode//endregion 

//region Scaling
	double dScale = dHeight/dVersalHeight;
	CoordSys csScale;
	csScale.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptRef, vecX* dScale, vecY* dScale, vecZ* dScale);
	
	
//End Scaling//endregion 

//region Use the width of 'i' and 'e' to define the interword spacing
	double dWidth_i = .1 * dVersalHeight*dScale;
	double dWidth_e = dVersalHeight * .75*dScale;
	for (int j=0;j<mapChars.length();j++) 
	{ 
		Map m;
		if (mapChars.nameAt(j)=="i")
		{
			m = mapChars.getMap(j); 
			dWidth_i = m.getPlaneProfile("box").dX()*dScale;
		}
		else if (mapChars.nameAt(j)=="e")
		{
			m = mapChars.getMap(j); 
			dWidth_e = m.getPlaneProfile("box").dX()*dScale;
		}
		if (dWidth_e > 0 && dWidth_i > 0)break;
	}//next j
	
	if (dWidth_e <= 0 || dWidth_i <= 0)
	{
		dWidth_i = .1 * dVersalHeight*dScale;
		dWidth_e = dVersalHeight * .75*dScale;
	}
	
	
	double blank = (dWidth_i+dWidth_e)*.5;
	double pitch = dWidth_i > 0 ? 3*dWidth_i : .1 * dVersalHeight*dScale;
	if (dPitch > 0)blank*= dPitch;
	if (dPitch >= 0)pitch*= dPitch;
	
	
//End Use the width of 'i' and 'e' to define the word spacing//endregion 	

//region Trigger DefineCharacter
	String sTriggerDefineCharacter = T("|Define Character|");
	addRecalcTrigger(_kContextRoot, sTriggerDefineCharacter );
	if (_bOnRecalc && _kExecuteKey==sTriggerDefineCharacter)
	{
		Point3d ptBase = getPoint(T("|Pick point on base line|"));
		ptBase.setZ(0);
		
	// prompt for polylines	
		PrEntity ssEpl(T("|Select polylines|"), EntPLine());
		while(ssEpl.go() && ssEpl.set().length()>0)
		{ 
			Entity ents[0];
			ents.append(ssEpl.set());

			String c = getString(T("|Enter character|"));
			if (c.length()>1)
				c = c.left(1);
			else if (c.length()<1)
			{ 
				continue;
			}	

			PLine plines[0];
			Point3d pts[0];
			for (int i=0;i<ents.length();i++) 
			{ 
				EntPLine epl =(EntPLine)ents[i];
				PLine pl = epl.getPLine();
				pl.projectPointsToPlane(pn, vecZ);
				
				if (!pl.coordSys().vecZ().isParallelTo(vecZ))
				{
					reportNotice(TN("|Polyline needs to be drawn in XY-World|"));
					continue;
				}
				plines.append(pl);				
				pl.convertToLineApprox(dEps);
				pts.append(pl.vertexPoints(true));
			}//next i
			
			if (pts.length()>0)
			{
				Point3d ptsX[] = lnX.orderPoints(pts, dEps);
				Point3d ptsY[] = lnY.orderPoints(pts, dEps);
				double dX, dY;
				if (ptsX.length() > 0) dX = vecX.dotProduct(ptsX.last() - ptsX.first());
				if (ptsY.length() > 0) dY = vecY.dotProduct(ptsY.last() - ptsY.first());
				
				if (dX <= 0) dX = dEps;
		
				Point3d pt = ptsX.first();
				pt += vecY*vecY.dotProduct(ptBase - pt);		
				Vector3d vecOrg = _PtW - pt;
				
			// remove if character exists
				for (int j=0;j<mapChars.length();j++) 
				{ 
					Map m= mapChars.getMap(j); 
					if (m.getMapName()==c)
					{
						mapChars.removeAt(j,true);
						break;
					} 
				}//next j				
				
			// append new character	
				Map m;
				for (int i=0;i<plines.length();i++) 
				{ 
					PLine pl= plines[i]; 
					pl.transformBy(vecOrg);
					m.appendPLine("pline", pl);
					 
				}//next i
				PlaneProfile box;
				box.createRectangle(LineSeg(pt, pt + _XW * dX + _YW * dVersalHeight), _XW, _YW);
				box.transformBy(vecOrg);
				m.appendPlaneProfile("box", box);
				m.setMapName(c);
				mapChars.appendMap("Character", m);
			}
			ssEpl=PrEntity(T("|Select polylines of next character|"), EntPLine());
		}
		
		// remove existing
		for (int i=0;i<mapFonts.length();i++) 
		{ 
			Map m= mapFonts.getMap(i); 
			if (m.getMapName().makeUpper()==sFont)
			{ 
				mapFonts.removeAt(i, true);
				break;
			}
			 
		}//next i
		
		// add new
		mapFont.setDouble(kVersal, dVersalHeight);
		mapFont.setMap("Character[]", mapChars);
		mapFonts.appendMap("Font", mapFont);
		mapSetting.setMap("Font[]", mapFonts);
		
		if (mo.bIsValid())
			mo.setMap(mapSetting);
		else
			mo.dbCreate(mapSetting);
		setExecutionLoops(2);
		return;
	}//endregion	


	if (mapChars.length()<1)
	{ 
		
		dpModel.draw(T("|No character definition found|") + 
			T("\P|Please draw character linework and define characters by RMC command|"), _Pt0,vecX, vecY,1,1);
		text=""; //avoid text parsing, like return;
	}
	
	
	if (nPreviewMode<1)
	{ 
		dpModel.draw(T("|1. Use command _CREATEHLR to convert text into linework.|\P") +
		T("|2. Use command _EXPLODE to explode the resulting block.|\P") +
		T("|3. Use command _PEDIT to convert lines into polylines.|\P") +
		T("|4. Switch to 'Defined Characters' preview mode.|\P") +
		T("|5. Define character by character.|\P") +
		T("|It is recommended to use a simple monotype font|\P\P")+
			allChar, _Pt0,vecX, vecY,1,1);
		text=""; //avoid text parsing, like return;	
	}
	else if (gb.bIsValid() && text.length()<1 && nPreviewMode == 2)
	{ 
		String msg = T("|Enter text or format definition in property| ") + sFormatName;
		if (sToolName==tDisabled)
			msg += "\P" + T("|Select a tool for milling.|");
		dpModel.draw(msg, _Pt0,vecX, vecY,1,1);
		text=""; //avoid text parsing	
	}
	else if (gb.bIsValid() && nPreviewMode == 1)
	{ 
		text = allChar;	
	}	


//region Parse the text
	
	for (int i=0;i<text.length();i++) 
	{ 
		String c = text.getAt(i);
		
	// blank	
		if (c==" ")
		{ 
			ptChar += vecX * blank;
			continue;
		}
	// punctuation	
		else if (c=="." || c=="," || c==";")
		{ 
			ptChar -= vecX * .5*pitch;
		}	
		Vector3d vecChar=ptChar-ptRef;		//ptChar.vis(i);
		
	// get character map	
		Map m;
		for (int j=0;j<mapChars.length();j++) 
			if (mapChars.nameAt(j)==c)
			{
				m = mapChars.getMap(j); 
				break;
			}
	// character definition found
		if (m.length()>0)
		{ 
			CoordSys csX = csScale;		// scale to size
			csX.transformBy(vecChar);	// transform to location

		// collect plines and boundaries of all
			PLine plines[0];
			Point3d pts[0];
			for (int p = 0; p < m.length(); p++)
			{
				if (!m.hasPLine(p))continue;
				PLine pl = m.getPLine(p);
				pl.transformBy(csX);	//pl.vis(6);				
				plines.append(pl);
				
				pl.convertToLineApprox(U(1));				
				pts.append(pl.vertexPoints(true));
			}
			
		// get overall height and width
			Point3d ptsX[] = lnX.orderPoints(pts, dEps);
			Point3d ptsY[] = lnY.orderPoints(pts, dEps);
			double dX, dY;
			
			Point3d ptMid = ptsX.first();
			if (ptsX.length() > 0) 
			{
				dX = vecX.dotProduct(ptsX.last() - ptsX.first());
				ptMid += vecX * vecX.dotProduct((ptsX.first()+ptsX.last())*.5-ptMid);
			}
			if (ptsY.length() > 0) 
			{
				dY = vecY.dotProduct(ptsY.last() - ptsY.first());
				ptMid += vecY * vecY.dotProduct((ptsY.first()+ptsY.last())*.5-ptMid);
			}
			if (dX < 0)dX = U(1); // vertical lines do not return a width
			if (dY < 0)dY = U(1); // horizontal lines do not return a height
		
		// shrink character outline by half diameter
			double f = dY>dDiameter? (dY - dDiameter) / dY:1;
			CoordSys csShrink;
			csShrink.setToAlignCoordSys(ptMid, vecX, vecY, vecZ, ptMid, vecX * f, vecY * f, vecZ * f);

			ptsX.setLength(0);
			for (int j = 0; j < plines.length();j++)
			{
				PLine& pl = plines[j];
				pl.transformBy(csShrink);
				
				PLine pl2 = pl;
				pl2.convertToLineApprox(U(1));				
				ptsX.append(pl2.vertexPoints(true));
			}
			ptsX= lnX.orderPoints(ptsX, dEps); // ptsX.first().vis(7);

		// set horizontal offset of the character			
			Vector3d vecXA = vecX * (.5 * dDiameter - vecX.dotProduct(ptsX.first() - ptChar));
			ptChar += 2*vecXA;

			for (int j=0;j<plines.length();j++) 
			{ 
				PLine pl= plines[j];
				pl.transformBy(vecXA);			//pl.vis(252);
				
				if (pl.length()<dEps)
				{ 
					reportNotice(TN("|Could not resolve path| ") + (j+1) + T("´|of character| '" + c+"'"));
					continue;
				}

				
				int bIsClosed = (pl.ptStart() - pl.ptEnd()).length() < dEps;// || pl.vertexPoints(true).length()>2;				
				if (dY<dEps)
				{ 
					pl.trim(.5 * dDiameter, false);
					pl.trim(.5 * dDiameter, true);
				}
				
			// draw tooling path 	
				dpPath.draw(pl);

				PlaneProfile ppShape(cs);
		
			//region Resolve tool path by segment
//				if (c=="D" || c=="O")
//				{ 
//					Point3d ptsTool[]=pl.vertexPoints(true);	
//					for (int p=1;p<ptsTool.length();p++) 
//					{ 
//						PLine plTool(vecZ);
//						plTool.addVertex(ptsTool[p-1]);
//	
//						double d = (pl.getDistAtPoint(ptsTool[p]) + pl.getDistAtPoint(ptsTool[p - 1])) * .5;
//						Point3d ptx = pl.getPointAtDist(d);
//						Point3d ptm = (ptsTool[p] + ptsTool[p - 1]) * .5;
//						
//						if (Vector3d(ptx-ptm).length()<dEps)// straight
//							plTool.addVertex(ptsTool[p]);
//						else
//						{
//							ptx = pl.closestPointTo(ptx);
//							ptx.vis(6);
//							plTool.addVertex(ptsTool[p], ptx);
//						}
//		
//						FreeProfile fp(plTool,plTool.vertexPoints(true));
//						fp.setDepth(dMyDepth);
//						fp.setMachinePathOnly(true);
//						fp.setSolidPathOnly(true);
//						fp.setSolidMillDiameter(dDiameter);
//						fp.setDoSolid(false);
//						fp.addMeToGenBeamsIntersect(_GenBeam);
//						Body bd = fp.cuttingBody();
//						ppShape.unionWith(bd.getSlice(pn));
//						bd.vis(3);
//					}//next p					
//				}
//				else
				if (sToolName!=tDisabled)
				{ 
					PLine plTool = pl;
					FreeProfile fp(plTool,plTool.vertexPoints(true));
					fp.setDepth(dMyDepth);
					fp.setMachinePathOnly(true);
					fp.setSolidPathOnly(true);
					fp.setSolidMillDiameter(dDiameter);
					fp.setDoSolid(false);
					fp.addMeToGenBeamsIntersect(_GenBeam);
					Body bd = fp.cuttingBody();
					ppShape.unionWith(bd.getSlice(pn));
					bd.vis(3);				
				}
				

				
			//End Resolve tool path by segment//endregion 	
				
				
				
				
			// add empty freetext to contribute to posnum generation
				if (_GenBeam.length()>0)
				{ 					
					int nX = _Pt0.X();
					int nY = _Pt0.X();
		
					FreeText ft("", cs, dHeight, nX, nY);
					gb.addTool(ft);
				
				}
				
				
				

				if (!bIsClosed)
				{ 
				// add endcaps
					Body bd1(pl.ptStart() + vecZ * dEps, pl.ptStart() - vecZ * dMyDepth, dDiameter * .5);
					ppShape.unionWith(bd1.getSlice(pn));
//						SolidSubtract sosu1(bd1);
//						if (_GenBeam.length()>0)sosu1.addMeToGenBeamsIntersect(_GenBeam);	
				
					Body bd2(pl.ptEnd() + vecZ * dEps, pl.ptEnd() - vecZ * dMyDepth, dDiameter * .5);
//						SolidSubtract sosu2(bd2);
//						if (_GenBeam.length()>0)sosu2.addMeToGenBeamsIntersect(_GenBeam);
					ppShape.unionWith(bd2.getSlice(pn));
				}
		
							
				
				if (c=="a" || c=="e" || c=="g" || c=="O" || c=="o" || c=="D") // just a workaround to get a nicer shape
				{
					PlaneProfile ppSub(pl);
					ppSub.shrink(.5*dDiameter); // the pline is already offseted to the center
					ppSub.vis(2);
					ppShape.subtractProfile(ppSub);
				}
		
			// validate tool path on bodies face
				if (bDefMode)
					dpModel.draw(ppShape, _kDrawFilled);
				else if (sToolName!=tDisabled)
				{ 
					PlaneProfile ppOut = ppShape;
					ppShape.intersectWith(ppFace);
					dpModel.draw(ppShape, _kDrawFilled);
					
					ppOut.subtractProfile(ppFace);
					if (ppOut.area()>pow(dEps,2))
					{
						dpRed.draw(ppOut, _kDrawFilled);
						dpRed.draw(ppOut);
					}
					
				}
				

				
//				PLine pl1 = pl;
//				PLine pl2 = pl;
//				
//				PlaneProfile pp(cs);
//				if (bIsClosed)
//				{ 
//					//pl.vis(3);
//					pl1.offset(.5 * dDiameter, true);
//					pl2.offset(-.5*dDiameter, true);
//					
//					pp.joinRing(pl1,_kAdd);
//					pp.joinRing(pl2,_kSubtract);
//					
//					dpRed.draw(pp);
//					continue;
//				}
//				else
//				{ 
//					pl1.offset(.5 * dDiameter);
//					pl2.offset(-.5* dDiameter);
//					pl2.reverse();
//				}
//
//				
//				pl1.vis(4);	
//				pl2.vis(5);				
//			// add pl2 to pl1
//				pts = pl2.vertexPoints(true);
//				for (int p=0;p<pts.length();p++) 
//				{ 
//					if (p==0)
//						pl1.addVertex(pts[p], -tan(45));
//
//					else
//					{ 
//						double d = (pl2.getDistAtPoint(pts[p]) + pl2.getDistAtPoint(pts[p - 1])) * .5;
//						Point3d ptx = pl2.getPointAtDist(d);
//						Point3d ptm = (pts[p] + pts[p - 1]) * .5;
//						
//						if (Vector3d(ptx-ptm).length()<dEps)// straight
//							pl1.addVertex(pts[p]);
//						else
//						{
//							ptx = pl2.closestPointTo(ptx);
//							//ptx.vis(6);
//							pl1.addVertex(pts[p], ptx);
//							
//							//pl1.vis(p);
//							
//						}
//						//ptx.vis(3);
//					}
//					
//					if (p == pts.length()-1)
//					{
//						pl1.addVertex(pl1.ptStart(), -tan(45));						
//					}					
//					
//					
//				}//next p
//				
//				pl1.vis(1);				
//
//				dpRed.draw(pl1);
				
			}//next p
			
			
			
			ptChar += vecX * (dX+pitch);
			vecChar=ptChar-ptRef;		
		}
		 
	}//next i
	
			
//End Parse the text//endregion 

//region Trigger Add GenBeam
	String sTriggerAddGenBeam = T("|Add Genbeam|");
	addRecalcTrigger(_kContextRoot, sTriggerAddGenBeam );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddGenBeam)
	{
		_GenBeam.append(getGenBeam());		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger Remove GenBeam
	String sTriggerRemoveGenBeam = T("|Remove Genbeam|");
	if (_GenBeam.length()>0)
	{
		addRecalcTrigger(_kContextRoot, sTriggerRemoveGenBeam );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveGenBeam)
		{
		// prompt for genbeams
			Entity ents[0];
			PrEntity ssE(T("|Select genbeams|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());
			
			for (int i=0;i<ents.length();i++) 
			{ 
				int n = _GenBeam.find(ents[i]);
				if (n>-1)
					_GenBeam.removeAt(n);
				 
			}//next i
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion

//region Trigger SelectPLines (debug only)
	if (bDebug)
	{ 
		String sTriggerSelectPLines = T("|Select PLines|");
		addRecalcTrigger(_kContextRoot, sTriggerSelectPLines );
		if (_bOnRecalc && _kExecuteKey==sTriggerSelectPLines)
		{
			PrEntity ssEpl(T("|Select polylines|"), EntPLine());
			if(ssEpl.go())
				_Entity.append(ssEpl.set());
				
			_PtG.append(getPoint("Pick base point"));	
				
			setExecutionLoops(2);
			return;
		}	
	
		if (_Entity.length()>0)
		{ 
			Point3d ptBase = _PtG[0];
			ptBase.setZ(0);
			
			PLine plines[0];
			Point3d pts[0];
			for (int i=0;i<_Entity.length();i++) 
			{ 
				EntPLine epl =(EntPLine)_Entity[i];
				PLine pl = epl.getPLine();
				pl.projectPointsToPlane(pn, _ZW);
				
				if (!pl.coordSys().vecZ().isParallelTo(_ZW))
				{
					reportNotice(TN("|Polyline needs to be drawn in XY-World|"));
					continue;
				}
				plines.append(pl);
				
				pl.convertToLineApprox(dEps);
				pts.append(pl.vertexPoints(true));
			}//next i	
			
			if (pts.length()>0)
			{
				Point3d ptsX[] = lnX.orderPoints(pts, dEps);
				Point3d ptsY[] = lnY.orderPoints(pts, dEps);
				double dX, dY;
				if (ptsX.length() > 0) dX = vecX.dotProduct(ptsX.last() - ptsX.first());
				if (ptsY.length() > 0) dY = vecY.dotProduct(ptsY.last() - ptsY.first());
				
				if (dX <= 0) dX = dEps;
		
				Point3d pt = ptsX.first();
				pt += vecY*vecY.dotProduct(ptBase - pt);		
				Vector3d vecOrg = _PtW - pt;
				
				Map m;
				for (int i=0;i<plines.length();i++) 
				{ 
					PLine pl= plines[i]; 
					pl.transformBy(vecOrg);
					pl.vis(6);
					m.appendPLine("pline", pl);
					 
				}//next i
				PlaneProfile box;
				box.createRectangle(LineSeg(pt, pt + vecX * dX + vecY * dRefHeight), vecX, vecY);
				box.transformBy(vecOrg);
				
	//			box.vis(2);
	//			box.transformBy(csScale);
	//			box.vis(3);
	//			box.transformBy(vecChar);
	//			box.vis(4);
	//			m.appendPlaneProfile("box", box);
	//			m.setMapName(c);
	//			mapChars.appendMap(c, m);
			}		
			
			
		}		
	}
//endregion	
	
	
//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	

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
	if (mapSetting.length() > 0 && mapChars.length()>0)
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
        <int nm="BreakPoint" vl="871" />
        <int nm="BreakPoint" vl="671" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15212 bugfix, new display modes and xml structure revised" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/5/2022 11:47:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12210 TypeWriter initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/14/2021 9:50:36 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End