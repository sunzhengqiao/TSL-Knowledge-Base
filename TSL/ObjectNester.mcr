#Version 8
#BeginDescription
This tsl creates a nesting of ObjectClones, requires TSL ObjectClone

#Versions
Version 1.6 30.10.2024 HSB-22194 new settings for minimal range, new display of minimal range
Version 1.5 18.09.2023 HSB-20086 Adjust transformation when alignment changes
Version 1.4 01.08.2023 HSB-18900 objectNester enhanced to accept uniform visible height and uniform width per row, supports grip based dragging
Version 1.3 24.07.2023 HSB-18900 Polyline dependency removed, new grips to modify size, only one unique height per nesting
Version 1.2 07.07.2023 HSB-18900 parent/child grouping fixed
Version 1.1 05.07.2023 HSB-18900 supports parent/child grouping
Version 1.0 22.06.2023 HSB-18900 initial version of ObjectNester





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.6 30.10.2024 HSB-22194 new settings for minimal range, new display of minimal range , Author Thorsten Huck
// 1.5 18/09/2023 HSB-20086 Adjust transformation when alignment changes. - Author: Anno Sportel
// 1.4 01.08.2023 HSB-18900 objectNester enhanced to accept uniform visible height and uniform width per row, supports grip based dragging , Author Thorsten Huck
// 1.3 24.07.2023 HSB-18900 Polyline dependency removed, new grips to modify size, only one unique height per nesting , Author Thorsten Huck
// 1.2 07.07.2023 HSB-18900 parent/child grouping fixed , Author Thorsten Huck
// 1.1 05.07.2023 HSB-18900 supports parent/child grouping , Author Thorsten Huck
// 1.0 22.06.2023 HSB-18900 initial version of ObjectNester , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities objectClone instances
/// </insert>

// <summary Lang=en>
// This tsl creates a nesting of ObjectClones, requires TSL ObjectClone
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ObjectNester")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Nesting|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Objects|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Objects|") (_TM "|Select Tool|"))) TSLCONTENT
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
	
	
	String sXkeyChild = "Hsb_NestingChild";
	String kCallNester = "CallNester";
	double dRowOffset = U(400);
	
	int nc = 40;
//end Constants//endregion

//END Part #1 //endregion 

//region Part #2

//region FUNCTIONS

//region Function FilterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion




//region Function FindNextFreeNumber
	// returns the next free number starting from the given value
	// nStart: the start number
	int FindNextFreeNumber(int nStart)
	{ 
		int out = nStart<=0?1:nStart;
		
		Entity ents[0];
		String names[] ={ (bDebug ? "ObectNester" : scriptName())};
		TslInst tsls[] = FilterTslsByName(ents, names);
		
	// get existing indices
		int numbers[0];
		for (int i = 0; i < tsls.length(); i++)
		{
			int n = tsls[i].propInt(0);
			if (n>0 && n>=nStart && numbers.find(n)<0)
				numbers.append(n);
		}
		numbers = numbers.sorted();
		
		//reportNotice("\nNumbers: " + numbers);
			
		for (int i=0;i<numbers.length();i++) 
			if (numbers[i]==out)
				out++;
		
		return out;
	}//endregion


//region Function GetNumbers
	// returns the amount of appearances of the given number and the array of numbers in use
	int GetNumbers(TslInst tsls[], int& numbers[], int number )
	{ 

	// Validate number
		numbers.setLength(tsls.length());
		for (int i = 0; i < tsls.length(); i++)
			numbers[i]=tsls[i].propInt(0);

		int num;
		for (int i=0;i<numbers.length();i++) 
			if (numbers[i]==number)
				num++; 

		return num;
	}//endregion


	Map getNestedRow(double stackLength, double gapX, PlaneProfile& shapes[], Entity& items[])
	{ 
		Map mapOut;
		if (shapes.length()<1){ return mapOut;}

		double gapx,dRowLength, dRowHeight;
	
	// append to row
		for (int i=0;i<shapes.length();i++) 
		{ 
			double dX = shapes[i].dX();
			double dY = shapes[i].dY();
			
		// only accept items with the same width	
			if (dRowHeight<dEps)
				dRowHeight = dY;
			else if (abs(dRowHeight-dY)>dEps)
			{ 
				continue;
			}
			
			double dTestLength = dRowLength+dX+(i>0?gapX:0); 
			if (dTestLength<=stackLength)
			{ 
				Map m;
				m.setDouble("dX", dX);
				m.setPlaneProfile("shape", shapes[i]);
				m.setEntity("item", items[i]);
				mapOut.appendMap("rowItem", m);
				dRowLength += dX+gapx;
				gapx = gapX;;
			}	 
		}//next i
		mapOut.setDouble("rowLength", dRowLength);
		
	// remove from arrays
		for (int i=0;i<mapOut.length();i++) 
		{ 
			Map m = mapOut.getMap(i);
			Entity item = m.getEntity("item");
			int n = items.find(item);
			if (n>-1)
			{ 
				items.removeAt(n);
				shapes.removeAt(n);
			}
			 
		}//next i

		return mapOut;
	}
	
	
//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	

		category = T("|Nester Range|");
			String sXRangeName=T("|Min X-Range|");	
			PropDouble dXRange(nDoubleIndex++, U(0), sXRangeName);	
			dXRange.setDescription(T("|Defines the required X-Range of the nester.| "));
			dXRange.setCategory(category);

			String sYRangeName=T("|Min Y-Range|");	
			PropDouble dYRange(nDoubleIndex++, U(0), sYRangeName);	
			dYRange.setDescription(T("|Defines the required Y-Range of the nester.| "));
			dYRange.setCategory(category);

			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 150, sColorName);	
			nColor.setDescription(T("|Defines the color of the min range|"));
			nColor.setCategory(category);
			
			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 150, sColorName);	
			nTransparency.setDescription(T("|Defines the transparency of the required min range|"));
			nTransparency.setCategory(category);			

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
	String sFileName ="ObjectClone";
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
	
	
	
	//region Read Settings
	double dXMinRange=U(6300), dYMinRange=U(860);
	
	int nRangeColor = 150;
	int nRangeTransparency = 60;	
	{
		String k;
		Map m= mapSetting.getMap("Nester");
	
		k="XMin";		if (m.hasDouble(k))	dXMinRange = m.getDouble(k);
		k="YMin";		if (m.hasDouble(k))	dYMinRange = m.getDouble(k);	

		k="Color";			if (m.hasInt(k))	nRangeColor = m.getInt(k);
		k="Transparency";	if (m.hasInt(k))	nRangeTransparency = m.getInt(k);	


	}
	//End Read Settings//endregion 

	
//End Settings//endregion	


//region Painters
	String tDisabledEntry = T("<|Disabled|>");
	String tSelectionPainter =  T("|Object Selection|");

// Get or create default painter definition
	String sPainterCollection = "TSL\\ObjectClone\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0 && name.find(tSelectionPainter,0,false)<0)
			{
				sPainters.append(name);
			}		
		}		 
	}//next i

	{ 
		String name = tSelectionPainter;
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			Entity ents[] = Group().collectEntities(true, Beam(), _kModelSpace);
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid() && ents.length()>0)
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("TslInstance");
					pd.setFilter(" Contains(ScriptName,'ObjectClone')");
				}
			}				
//			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
//			{
//				sPainters.append(name);		
//			}
		}		
	}

	sPainters.sorted();	
	sPainters.insertAt(0, tDisabledEntry);

//endregion

//END Part #2 //endregion 

//region Part #3
//region DimStyles
// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	{ 
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$0", 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
				}
	}	
//endregion 

//region Properties
	String sNumberName=T("|Number|");	
	PropInt nNumber(nIntIndex++, 0, sNumberName);	
	nNumber.setDescription(T("|Defines a unique number of the object nester.|") + 
		T(" |The existing sequence of numbers will be preserved by incrementing the range of affected numbers when created of modified.|")+ 
		T(" |The value of zero signifies that the subsequent available number, commencing from one, will be allocated.|"));
	nNumber.setCategory(category);
	nNumber.setControlsOtherProperties(true);

	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(10000), sLengthName,_kLength);	
	dLength.setDescription(T("|Defines the length of the master|"));
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(3000), sWidthName,_kLength);	
	dWidth.setDescription(T("|Defines the width of the master|"));
	dWidth.setCategory(category);	

	String sOversizeName=T("|Oversize Format Cut|");
	PropDouble dOversize(nDoubleIndex++, U(0), sOversizeName,_kLength);	
	dOversize.setDescription(T("|Defines the outer offset of the raw master.|"));
	dOversize.setCategory(category);

	String tRectNester = T("|Rectangular Nester|"),tObjNester = T("|Object Nester|");;
	String sNesters[] = { tRectNester,tObjNester};
	sNesters = sNesters.sorted();
	if (!_bOnInsert)
		sNesters.insertAt(0, tDisabledEntry);
	String sNesterName=T("|Nester|");	
	PropString sNester(nStringIndex++, sNesters, sNesterName);	
	sNester.setDescription(T("|Defines the Nester|"));
	sNester.setCategory(category);
	if (sNesters.findNoCase(sNester,-1)<0)
		sNester.set(sNesters.first());

category = T("|Object|");
	String sGapXName=T("|X-Gap|");	
	PropDouble dGapX(nDoubleIndex++, U(0), sGapXName,_kLength);	
	dGapX.setDescription(T("|Defines the gap in X-direction between individual objects|"));
	dGapX.setCategory(category);

	String sGapYName=T("|Y-Gap|");	
	PropDouble dGapY(nDoubleIndex++, U(0), sGapYName,_kLength);	
	dGapY.setDescription(T("|Defines the gap in Y-direction between individual objects|"));
	dGapY.setCategory(category);

	String tUnchanged = T("<|Unchanged|>");
	String tZPos = "+Z", tZNeg = "-Z", tYPos = "+Y", tYNeg = "-Y";
	String sAlignments[] = { tUnchanged,tZPos, tYPos, tZNeg, tYNeg};
	String sAlignmentName=T("|Alignmment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the alignmment of the nested object within the master|"));
	sAlignment.setCategory(category);

category = T("|Filter|");
	String sPainterName=T("|Filter|");	
	PropString sPainter(nStringIndex++, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition which will be used to order the objects for nesting|"));
	sPainter.setCategory(category);
	
	String tAscending = T("|Ascending|"), tDescending= T("|Descending|"), sSortings[] ={tAscending, tDescending };
	String sSortingName=T("|Sorting|");	
	PropString sSorting(nStringIndex++,sSortings, sSortingName,1);	
	sSorting.setDescription(T("|Defines the Sorting|"));
	sSorting.setCategory(category);
	
category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "Yield @(Yield)\n@(Height)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the header display|"));
	sFormat.setCategory(category);
	Map mapAdd;
	if (_bOnInsert)
	{ 
		mapAdd.setString("Yield", "85%"); // dummy
		sFormat.setDefinesFormatting("TslInst", mapAdd);
	}

	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(5, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(100), sTextHeightName,_kLength);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);	

//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
		int nStart = FindNextFreeNumber(nNumber);
		
	// prompt for entities
		PrEntity ssE(T("|Select clone objects|"), TslInst());
		if (ssE.go())
			_Entity.append(ssE.set());
			
		PainterDefinition pd(sPainterCollection+tSelectionPainter);
		if (pd.bIsValid())
		{ 
			_Entity= pd.filterAcceptedEntities(_Entity);	
		}
		
		_Map.setInt(kCallNester, true);
		_Pt0 = getPoint();
		
		return;
	}			
//endregion 

//END Part #3 //endregion 

//region Remove remotly Child2Remove
	if (_Map.hasEntity("Child2Remove"))
	{ 
		Entity ent = _Map.getEntity("Child2Remove");
		int n = _Entity.find(ent);
		if (n>-1)
		{
			_Entity.removeAt(n);
			if (bDebug)reportNotice("\nnester has removed child " + ent.uniqueId());
			_Map.removeAt("Child2Remove", true);
		}
	}
	if (_Map.hasEntity("Child2Add"))
	{ 
		Entity ent = _Map.getEntity("Child2Add");
		int n = _Entity.find(ent);
		if (n<0)
		{
			_Entity.append(ent);
			if (bDebug)reportNotice("\nnester " + _ThisInst.uniqueId() + " added " + ent.uniqueId());
			_Map.removeAt("Child2Add", true);
		}
	}	
//endregion 

//region Painter based filtering and sorting
	Entity ents[]=_Entity;
	PainterDefinition pdx(sPainterCollection+tSelectionPainter);
	if (pdx.bIsValid())
	{ 
		ents= pdx.filterAcceptedEntities(_Entity);	
	}


// Collect references of the filtered ents
	Entity entRefs[ents.length()];
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity e = ents[i]; 
		TslInst t = (TslInst)e;
		if (!t.bIsValid()){ continue;}
		Entity _ents[] = t.entity();	
		if (_ents.length()<1){ continue;}
		
		entRefs[i]=_ents.first();
		
	}//next i
	
// filter references
	PainterDefinition pd(sPainterCollection+sPainter);
	String ftr;
	Entity entFilteredRefs[0];
	if (pd.bIsValid())
	{ 
		entFilteredRefs= pd.filterAcceptedEntities(entRefs);
		ftr = pd.format();
	}
	else
		entFilteredRefs = entRefs;
	
// Remove any parent tsl of which the filter of the reference does not match
	for (int i=entRefs.length()-1; i>=0 ; i--) 
	{ 
		Entity ref=entRefs[i];
		if (ref.bIsValid() && entFilteredRefs.find(ref)>-1)
		{ 
			;//valid
		}
		else
		{ 
			entRefs.removeAt(i);
			ents.removeAt(i);
		}
	}//next i
	
//	String tags[0];
//	if (ftr.length()>0)
//		for (int i = 0; i < entRefs.length(); i++)
//		{
//			Entity e = entRefs[i];
//			String tag= e.formatObject(ftr);
//			tags.append(tag);
//		}
//
//// order ascending or descending
	
//	for (int i=0;i<tags.length();i++) 
//		for (int j=0;j<tags.length()-1;j++) 
//			if ((bAscending && tags[j]>tags[j+1]) || (!bAscending && tags[j]<tags[j+1]))
//			{
//				entRefs.swap(j, j + 1);
//				ents.swap(j, j + 1);
//				tags.swap(j, j + 1);
//			}	


//END Painter based filtering and sorting //endregion 

//region Standards
	Display dp(nc);
	dp.dimStyle(sDimStyle);
	double textHeight = dTextHeight;
	if (dTextHeight>0)
		dp.textHeight(textHeight);
	else
		textHeight = dp.textHeightForStyle("O", sDimStyle);
	int bAscending = sSorting == tAscending;
	_ThisInst.setDrawOrderToFront(100);
//endregion 

//region Get/Set Master EntPLine

// set master coordSys
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Point3d ptOrg = _Pt0;	
	ptOrg.setZ(0);
	CoordSys csm();


// get and draw master shape
	PLine plShape;
	plShape.createRectangle(LineSeg(ptOrg, ptOrg+ vecX*dLength + vecY* dWidth), vecX, vecY);

	PlaneProfile ppMaster(csm);
	ppMaster.joinRing(plShape, _kAdd);
	double dSizeX = ppMaster.dX();
	double dSizeY = ppMaster.dY();
	dp.draw(ppMaster);	

	CoordSys csParent(ppMaster.ptMid(), vecX, vecY, vecZ);		csParent.vis(1);
	CoordSys csParentInv = csParent;
	csParentInv.invert();

	PlaneProfile ppMasterNet=ppMaster;
	ppMasterNet.shrink(dOversize);
	double dMasterArea = ppMaster.area();

	if (_bOnDbCreated)
	{
		_Map.setInt(kCallNester, true);
	}	

//endregion 

//region Grip Managment #GM

	
//region Collect Grip Indices
	//_Grip.setLength(0);
	addRecalcTrigger(_kGripPointDrag, "_Grip");
	_ThisInst.setAllowGripAtPt0(true);
	String kGripStretchX="StretchX", kGripStretchY="StretchY",kGripBase="BaseGrip", kGripTag="TagGrip";
	String kGrips[] = {kGripTag, kGripStretchX, kGripStretchY};
	Point3d ptLocs[] = {ptOrg-vecY*2*textHeight, ptOrg + (vecX * dLength + .5 * vecY * dWidth), ptOrg + (vecX * .5 * dLength + vecY * dWidth)};
	int nGrips[] ={-1 ,- 1 ,- 1};
	for (int i=0;i<_Grip.length();i++) 
	{ 
		String name = _Grip[i].name();
		int n = kGrips.findNoCase(name ,- 1);
		if (n>-1)
		{
			Grip& grip = _Grip[n];
			
			if (i==1)
				grip.setPtLoc(Line(ptOrg + vecY*.5 * dWidth, vecX).closestPointTo(grip.ptLoc()));
			else if (i==2)
				grip.setPtLoc(Line(ptOrg + vecX*.5 * dLength, vecY).closestPointTo(grip.ptLoc()));				
			nGrips[i] = n;	 	
		}
	}//next i//endregion 
	
//region Create grips
	for (int i=0;i<kGrips.length();i++) 
	{ 
		int nGrip = nGrips[i];
		if (nGrip<0)
		{ 
			Grip grip;
			grip.setPtLoc(ptLocs[i]);
			grip.setVecX(i==2?vecY:vecX);
			grip.setVecY(i==2?vecX:vecY);
			grip.setColor(i==0?40:4);
			grip.setShapeType(i==0 ? _kGSTCircle : _kGSTArrow);
			grip.setName(kGrips[i]);
			grip.addHideDirection(_XW);
			grip.addHideDirection(-_XW);
			grip.addHideDirection(_YW);
			grip.addHideDirection(-_YW);
			
			_Grip.append(grip);
			nGrips[i] = _Grip.length() - 1;
		}		 
	}//next i//endregion 

//region Grip moved (Size stretched)
	int nMovedGrip = Grip().indexOfMovedGrip(_Grip);
	if (nMovedGrip>0 && _Grip.length()>2)
	{ 
		Grip gripX = _Grip[nGrips[1]];
		Grip gripY = _Grip[nGrips[2]];
			
		double sizeX = vecX.dotProduct(gripX.ptLoc() - ptOrg);
		double sizeY = vecY.dotProduct(gripY.ptLoc() - ptOrg);
		
		if (sizeX>0 && sizeY>0)
		{ 
			PlaneProfile pp;
			pp.createRectangle(LineSeg(ptOrg, ptOrg+ vecX*sizeX + vecY* sizeY), vecX, vecY);
			Display dp(-1);
			dp.trueColor(lightblue);
			dp.draw(pp,_kDrawFilled,90);
			dp.draw(pp);
			
			dLength.set(sizeX);
			dWidth.set(sizeY);			
		}
		
		setExecutionLoops(2);
		return;
	}//endregion 


//endregion 

//region NESTING
	
//region Collect nester childs
// nesting properties
	double dDuration = 1;
	int bNestInOpening = false;
	double dNestRotation = 360;


	double dNetArea;
	NesterCaller nester;
	PlaneProfile ppShapes[ents.length()];
	for (int i=0; i<ents.length(); i++) 
	{
		TslInst t = (TslInst)ents[i];
		if (!t.bIsValid()){ continue;}
		
		if (sAlignment!=tUnchanged && t.propString(2)!=sAlignment)
		{ 
			_Map.setInt(kCallNester, sNester!=tDisabledEntry);
			t.setPropString(2, sAlignment);
			t.transformBy(Vector3d(0, 0, 0));
			//reportNotice("\nforing transform");
		}
		
		Map mapX = t.subMapX(sXkeyChild);
	
	// get shape
		PlaneProfile ppShape;
		if (mapX.hasPlaneProfile("shape"))
		{
			ppShape = mapX.getPlaneProfile("shape");	//ppShape.vis(2);
		}		
		if (ppShape.area()<pow(dEps,2))
		{ 
			continue;
		}
		ppShapes[i] = ppShape;
		dNetArea += ppShape.area();
		
	// manipulate input shape for rect nester	
		if (sNester==tRectNester)
		{ 
			LineSeg seg = ppShape.extentInDir(vecX);
			Point3d ptm = seg.ptMid();
			if (dGapX>dEps || dGapY>dEps)
			{ 
				Vector3d vec = .5 * (vecX * (ppShape.dX() + dGapX) + vecY * (ppShape.dY() + dGapY));
				seg = LineSeg(ptm - vec, ptm + vec);
				ppShape.createRectangle(seg, vecX, vecY);
				ppShape.vis(6);
			}			
		}
		
		NesterChild nc(t.handle(),ppShape);
		nc.setNestInOpenings(bNestInOpening);
		nc.setRotationAllowance(dNestRotation);
		nester.addChild(nc);
	}
	
	//reportNotice("\n_kNameLastChangedProp "+_kNameLastChangedProp + " loop " + _kExecutionLoopCount);
//	if (_kNameLastChangedProp==sAlignmentName)
//	{ 
//		setExecutionLoops(2);
//		return;
//	}


// trigger nesting event	
	int bNest = _Map.getInt(kCallNester);
	String sNestEvents[] = { sSortingName, sOversizeName, sGapXName, sGapYName, sPainter,sAlignmentName};
	if(sNester!=tDisabledEntry &&  sNestEvents.findNoCase(_kNameLastChangedProp,-1)>-1)
	{ 
		//reportNotice("\ntrigger nesting ");
		_Map.setInt(kCallNester, true);
		setExecutionLoops(2);
		return;		
	}


//endregion 

//region Move Items when Base Grip is dragged
	if (_kNameLastChangedProp=="_Pt0")
	{ 
		//Compose parent mapX with Nesting info
		Map mapX = _ThisInst.subMapX("Hsb_NestingParent");
		if (mapX.hasPoint3d("ptOrg"))
		{ 
			Point3d ptFrom = mapX.getPoint3d("ptOrg");
			Point3d ptTo = _Pt0;
			ptTo.setZ(0);
			
			Vector3d vec = ptTo - ptFrom;
			for (int i=0;i<ents.length();i++) 
				ents[i].transformBy(vec); 
			
		}
	}
//endregion 

//region ObjectNester
	if ((bNest) && sNester==tObjNester)// || bDebug
	{ 
		if (bDebug)reportNotice("\nnesting entities " + ents.length());
		_Map.setInt(kCallNester, 0);// reset map based nesting request
		
	// Get Stack Sizes
		double dStackX = dSizeX - 2 * dOversize;
		double dStackY = dSizeY - dOversize;
		double dStackZ = ents.length() > 0 ?ents[0].subMapX(sXkeyChild).getDouble("dZ"): 0;

	//region Accept only items of same visible height -> dump others for left over creation
		Entity entLeftOvers[0];
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			Entity item=ents[i]; 
			if (item.subMapX(sXkeyChild).getDouble("dZ")!=dStackZ)
			{
			// remove frmo entity	
				int n = _Entity.find(item);
				if (n-1)
					_Entity.removeAt(n);
				ents.removeAt(i);
				ppShapes.removeAt(i);				

			// append to left overs
				entLeftOvers.append(item);				

			}
			
		}//next i			
	//endregion 
		
	//region Create left over nesting
		if (entLeftOvers.length()>0)
		{ 
			reportNotice("\nentLeftOvers " + entLeftOvers.length() + " remaining " + ents.length());
			
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Point3d ptsTsl[] = {_Pt0+ _XW*(dSizeX+ 10*textHeight)};
			int nProps[]={nNumber};			
			double dProps[]={dLength, dWidth, dOversize, dGapX,dGapY, dTextHeight};
			String sProps[]={sNester,sAlignment,sPainter,sSorting,sFormat, sDimStyle};
			Map mapTsl;	

		// create new instance withh nesting flag set to true
			mapTsl.setInt(kCallNester, true);
			tslNew.dbCreate(scriptName() , _XW,_YW,gbsTsl, entLeftOvers, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			if (tslNew.bIsValid())
			{ 
				tslNew.transformBy(Vector3d(0, 0, 0));
			}
		}
			
	//endregion 

	// Order remaining descending or ascending by length
		for (int i=0;i<ppShapes.length();i++) 
			for (int j=0;j<ppShapes.length()-1;j++) 
			{
				if (ppShapes[j].dX()<ppShapes[j+1].dX())
				{
					ents.swap(j, j + 1);
					ppShapes.swap(j, j + 1);
				}					
			}


	// Collect rows
		Entity items[0];items = ents;
		if (bDebug)reportNotice("\norder items/ents " + items.length() );
	
		Map mapRows[0];
		double dRowLengths[0];
		int max, cnt = ppShapes.length();
		while (ppShapes.length()>0 && max<=cnt)
		{ 
			Map mapRow = getNestedRow(dStackX, dGapX, ppShapes, items);
			
			double rowLength = mapRow.getDouble("rowLength");
			dRowLengths.append(rowLength);
			mapRows.append(mapRow);	
			max++;
		}
		
	// Order rows by row length	
		for (int i=0;i<dRowLengths.length();i++) 
			for (int j=0;j<dRowLengths.length()-1;j++) 
			{
			// descending	
				if (!bAscending && dRowLengths[j]<dRowLengths[j+1])
				{
					dRowLengths.swap(j, j + 1);
					mapRows.swap(j, j + 1);
				}
			// ascending	
				else if (bAscending && dRowLengths[j]>dRowLengths[j+1])
				{
					dRowLengths.swap(j, j + 1);
					mapRows.swap(j, j + 1);
				}				
			}
	
		
	// Transform to master and reorder items
		items.setLength(0); 
		Point3d ptDatum = csParent.ptOrg() + _XW * (dOversize-.5*dSizeX)-_YW*.5*dSizeY;
		ptDatum.vis(6);
		Point3d ptX = ptDatum;		
		for (int i=0;i<mapRows.length();i++) 		
		{ 
			Map mapRow = mapRows[i];
			double dYRow;;
			for (int j=0;j<mapRow.length();j++) 
			{ 
				if (!mapRow.hasMap(j)){ continue;}
				Map m = mapRow.getMap(j);
				PlaneProfile pp = m.getPlaneProfile("Shape");
				Entity item = m.getEntity("item");
				Point3d ptx = pp.ptMid() - .5 * (_XW * pp.dX() + _YW * pp.dY());
				dYRow = pp.dY();

				CoordSys csj;
				csj.setToTranslation(ptX - ptx);
				csj.transformBy(_XW * j*dGapX);

			// row exceeds max Y
				if (_YW.dotProduct(ptX-ptDatum)+dYRow>=dSizeY)
				{ 
					break;
				}


				if (bDebug)
				{ 
					pp.transformBy(csj);
					pp.vis(j);	
					PLine (ptOrg, pp.ptMid()).vis(i);		
				}
				else 
				{ 
					item.transformBy(csj);
					
				}
				items.append(item);
				
			// next location	
				ptX.transformBy(_XW*pp.dX());

			}//next j
			ptX.transformBy(_XW*_XW.dotProduct(ptDatum-ptX) + _YW*(dYRow+dGapY));

			

		}	
		
		
	//region Create a new instance if items do not fit into current nester
		if (bDebug)reportNotice("\nitems" + items.length() + " remaining ents " + ents.length());
		if (ents.length()>items.length())
		{ 
			
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0-_YW*(dSizeY+ 10*textHeight)};
			int nProps[]={nNumber};			
			double dProps[]={dLength, dWidth, dOversize, dGapX,dGapY, dTextHeight};
			String sProps[]={sNester,sAlignment,sPainter,sSorting,sFormat, sDimStyle};
			Map mapTsl;	

		// assign left over childs	
			for (int i=0;i<ents.length();i++) 
			{ 
				int n =items.find(ents[i]);
				if (n<0)
				{	
					entsTsl.append(ents[i]);
					n =_Entity.find(ents[i]);
					if (n>-1)
						_Entity.removeAt(n);							
				}
			}//next i
			
			if (bDebug)reportNotice("\ncreate for " + entsTsl.length());
		// create new instance withh nesting flag set to true
			mapTsl.setInt(kCallNester, true);
			if (!bDebug)
				tslNew.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
			if (tslNew.bIsValid())
			{
				tslNew.transformBy(Vector3d(0, 0, 0));	
			}
		}
	//endregion 	
		
		
		
		
		

	// update calling instance (yield etc)
		_ThisInst.transformBy(Vector3d(0, 0, 0));
		//_Entity = items;
	}//endregion 

//region RectangularNester
	else if (bNest && sNester==tRectNester)
	{ 
		//reportNotice("\nexecuting rect nester");
		_Map.setInt(kCallNester, false);
				
	// set nester data
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dDuration); //seconds
		//nd.setMinimumSpacing(dGap);
		nd.setChildOffsetX(-.5*dGapX);
		nd.setGenerateDebugOutput(bDebug);
		nd.setNesterToUse(_kNTRectangularNester);

		NesterMaster nm(_ThisInst.handle(), ppMasterNet);
		nester.addMaster(nm);

	//region Log messages
		int bShowLog = bDebug;
		if(bShowLog)
		{ 
			String msg;
			for (int m=0; m<nester.masterCount(); m++) 
				msg+="\n   " +T("|Masterpanel|") + " " + nester.masterOriginatorIdAt(m);
			msg += "\n "+nester.childCount() + " " + T(" | childs to be nested|");
			reportNotice(msg);			
		}			
	//endregion 
		
	//region Do the actual nesting
		int nSuccess = nester.nest(nd, true);
		if (bDebug)reportMessage("\n\n	NestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			reportNotice("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportNotice("\n" + scriptName() + ": " + T("|No dongle present|"));
			setExecutionLoops(2);
			return;
		}		
		
	// collect  nesting results
		///master indices
		int nMasterIndices[] = nester.nesterMasterIndexes();	
		int nLeftOverChilds[] = nester.leftOverChildIndexes();
		int bMasterHasChilds;
		if(bShowLog)reportNotice("\n	MasterIndices: " +nMasterIndices + "\n	LeftOverChilds: "+nLeftOverChilds);
		if(nMasterIndices.length()>0)
		{
			int nIndexMaster = nMasterIndices[0];
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			bMasterHasChilds = nChildIndices.length()>0;
			if(bShowLog)
			{
				reportNotice("\n      "+ (bMasterHasChilds
					?nChildIndices.length() + " " + T("|child panels successfully nested|")
					:T("|No items found to be nested!|")));
			}
		}//endregion 
		
	//region Loop over the nester masters
		for (int m=0; m<nMasterIndices.length(); m++) 
		{
			int nIndexMaster = nMasterIndices[m];
			//if (bDebug)reportMessage("\nResult "+nIndexMaster +": "+nester.masterOriginatorIdAt(nIndexMaster) );
			
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				break;
			}
			
		// locate the childs within the master
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				int nIndexChild = nChildIndices[c];
				String strChild = nester.childOriginatorIdAt(nIndexChild);
				if (bDebug)reportMessage("\n		Child "+nIndexChild+" "+strChild);
				
				Entity ent; ent.setFromHandle(strChild);
				CoordSys cs = csWorldXformIntoMasters[c];
				if(!bDebug)
					ent.transformBy(cs);
				
				//_Entity.append(ent);
			}
		}//endregion 

	//region Create nesting instances for the left overs
		// assign the left over childs to it. make sure that the send in childs decrease at least by 1, unless we end in an infinte loop	
		if (nLeftOverChilds.length()>0 && bMasterHasChilds && nSuccess==_kNROk)
		{
			if(bShowLog)reportNotice("\n      "+nLeftOverChilds.length() + " " +T("|left over items in current nesting attempt|"));

		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={nNumber};			
			double dProps[]={dLength, dWidth, dOversize, dGapX,dGapY, dTextHeight};
			String sProps[]={sNester,sAlignment,sPainter,sSorting,sFormat, sDimStyle};
			Map mapTsl;	
						
		// transform the insert location to next row	
			ptsTsl[0] -= _YW * (dWidth + 3*textHeight + dRowOffset);

		// assign left over childs
			for (int c=0; c<nLeftOverChilds.length(); c++) 
			{
				Entity ent; 
				ent.setFromHandle(nester.childOriginatorIdAt(nLeftOverChilds[c]));
				
				if (ent.bIsValid())
				{
					entsTsl.append(ent);
					if (bDebug) reportMessage("\n		child " + ent.handle() + " assigned to new master");	
					
				// remove current assignment	
					int n = _Entity.find(ent);
					if (n>-1)
						_Entity.removeAt(n);
				}

			}
			if(bShowLog)reportNotice("\n      "+ entsTsl.length() + " " + T("|childs send to new nesting attempt|"));
			
			
		// create new instance withh nesting flag set to true
			mapTsl.setInt(kCallNester, true);
			tslNew.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	

		// update calling instance (yield etc)
			_ThisInst.transformBy(Vector3d(0, 0, 0));


		}			
	//endregion 
	}	
//endregion 

//END NESTING //endregion

//region TRIGGER

//region Trigger CallNester
	String sTriggerCallNester = T("|Nesting|");
	if (sNester != tDisabledEntry)
		addRecalcTrigger(_kContextRoot, sTriggerCallNester );
	if (_bOnRecalc && (_kExecuteKey==sTriggerCallNester || _kExecuteKey==sDoubleClick))
	{
		_Map.setInt(kCallNester, true);		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger AddObjects
	String sTriggerAddObjects = T("|Add Objects|");
	addRecalcTrigger(_kContextRoot, sTriggerAddObjects );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddObjects)
	{
		_Map.setInt(kCallNester, sNester != tDisabledEntry);

	// prompt for entities
		PrEntity ssE(T("|Select clone objects|"), TslInst());
		if (ssE.go())
			_Entity.append(ssE.set());
			
		PainterDefinition pd(sPainterCollection+tSelectionPainter);
		if (pd.bIsValid())
		{ 
			_Entity= pd.filterAcceptedEntities(_Entity);	
		}

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger AddObjects
	String sTriggerRemoveObjects = T("|Remove Objects|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveObjects );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveObjects)
	{
		_Map.setInt(kCallNester, sNester != tDisabledEntry);
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select clone objects|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
			
			
	// get bounds
		PlaneProfile ppx(CoordSys());
		for (int i=0;i<ents.length();i++) 
		{ 
			Map mapX= ents[i].subMapX("Hsb_NestingChild");
			ppx.unionWith(mapX.getPlaneProfile("Shape")); 
		}//next i
		
	// pick new location of removed
		Vector3d vecMove;
		PrPoint ssP(TN("|Pick new location|"), ppx.ptMid()); 
		if (ssP.go()==_kOk) 
		{
			Point3d pt = ssP.value();
			pt.setZ(0);
			vecMove = pt - ppx.ptMid();
		}
	
		for (int i=0;i<ents.length();i++) 
		{ 
			int n= _Entity.find(ents[i]); 
			if (n>-1)
			{
				Entity e = _Entity[n];
				e.removeSubMapX(sXkeyChild);
				_Entity.removeAt(n);
				e.transformBy(vecMove); // force to update
			}
		}//next i
		

		setExecutionLoops(2);
		return;
	}//endregion	

		
//END TRIGGER //endregion 


//region Unique Sequence Number Control
	TslInst nesters[0];
	{ 
		Entity ents[0];
		String names[] ={ (bDebug ? "ObjectNester" : scriptName())};
		nesters= FilterTslsByName(ents, names);
	}

	int nNumbers[0], nNumberAppearance= nNumber<1?0:GetNumbers(nesters, nNumbers, nNumber);

// On modifying the number adjust affected instances	
	if (_kNameLastChangedProp == sNumberName && nNumber>0 && nNumberAppearance>0)	
	{ 
		
	// order by number
		for (int i=0;i<nesters.length();i++) 
			for (int j=0;j<nesters.length()-1;j++) 
			{
				int n1 = nNumbers[j];
				int n2 = nNumbers[j+1];
				
				if (n1>n2)
				{
					nesters.swap(j, j + 1);
					nNumbers.swap(j, j + 1);
				}
			}	
			
	// remove thisInst
		int n = nesters.find(_ThisInst);
		if (n>-1)
		{ 
			nNumbers.removeAt(n);
			nesters.removeAt(n);
		}
			
	// collect stacks to renumber if occupied
		int numbersX[0];
		TslInst nestersX[0];
		int xStart = nNumbers.find(nNumber);
		if (xStart>-1)
		{ 
			for (int i=xStart;i<nesters.length();i++) 
			{ 
				TslInst& t= nesters[i]; 
				int num = t.propInt(0);

				if (numbersX.length()==0 || (numbersX.length()>0 && numbersX.last()==num))
				{
					num++;
					numbersX.append(num);
					nestersX.append(t);
				}
			}//next i			
		}
	
	// Renumber topdown
		for (int i=nestersX.length()-1; i>=0 ; i--) 
		{ 			
			TslInst& t=nestersX[i]; 
			reportMessage("\n" + t.handle()+ T(" |renumbered from| ") + t.propInt(0) + " -> "+ numbersX[i]);
			t.setPropInt(0, numbersX[i]);
		}//next i

		setExecutionLoops(2);
		return;					

	}


// Auto Renumber on Copy or when number is set to <=0	
	if (nNumberAppearance>1 || nNumber<=0)// && 
	{ 
		int newNumber = FindNextFreeNumber(nNumber);
		reportMessage("\n" + _ThisInst.handle()+ T(" |renumbered from| ") + nNumber + " -> "+ newNumber);
		nNumber.set(newNumber);
		setExecutionLoops(2);
		return;
	}
//endregion






//region Draw	

	
	PlaneProfile ppCollision(CoordSys());
	for (int i=0;i<ppShapes.length()-1;i++) 
	{ 
		PlaneProfile pp1 = ppShapes[i]; 	pp1.vis(4);
		for (int j=i+1;j<ppShapes.length();j++) 
		{ 
			PlaneProfile pp2= ppShapes[j];
			pp2.intersectWith(pp1);
			if (pp2.area()>pow(dEps,2))
				ppCollision.unionWith(pp2);
			 
		}//next j
		

	}//next i

	
	if (ppCollision.area()>pow(dEps,2))
	{ 
		Display dpRed(-1);
		dpRed.trueColor(red);
		dpRed.draw(ppCollision);
		dpRed.draw(ppCollision,_kDrawFilled);	
	}

	double yield = dMasterArea > 0 ? round(dNetArea / dMasterArea * 100) : 0;
	mapAdd.setString("Yield", yield+"%");
	
	if (ents.length()>0)
		mapAdd.setDouble("Height", ents[0].subMapX(sXkeyChild).getDouble("dZ"), _kLength);
	
	
	String text =_ThisInst.formatObject(sFormat, mapAdd);	
	if (text.length()<1)
		text = scriptName();
	sFormat.setDefinesFormatting(_ThisInst, mapAdd);	
	if (nGrips[0]>-1)
	{ 
		dp.draw(text,_Grip[nGrips[0]].ptLoc(), _XW, _YW, 1, -1);
	}
	
		
//endregion 

//region Required Minimal Range
	PlaneProfile ppMinRange(CoordSys());
	if (dXMinRange>0 && dYMinRange>0)
	{ 
		PlaneProfile ppShapeAll(CoordSys());
		for (int i=0;i<ppShapes.length();i++) 
		{ 
			PlaneProfile pp = ppShapes[i];
			pp.shrink(-dEps);
			//{Display dpx(3); dpx.draw(pp, _kDrawFilled,20);}
			ppShapeAll.unionWith(pp); // collect with little oversize	 
		}//next i

			
		//ppShapeAll.vis(1);
		ppMinRange.createRectangle(LineSeg(_Pt0, _Pt0 + _XW * dXMinRange + _YW * dYMinRange), _XW, _YW);
		//ppMinRange.vis(2);
		
		PlaneProfile ppIntersection = ppShapeAll;
		
		int bValid;
		if (ppIntersection.intersectWith(ppMinRange))
		{ 
			//{Display dpx(1); dpx.draw(ppShapeAll, _kDrawFilled,20);}	
			ppShapeAll.subtractProfile(ppMinRange);
			Point3d pts[] = ppShapeAll.getGripVertexPoints();
			
			Point3d ptsX[] = Line(_Pt0, _XW).orderPoints(pts, dEps);
			Point3d ptsY[] = Line(_Pt0, _YW).orderPoints(pts, dEps);
			
			int bValidX = ptsX.length() > 0 && _XW.dotProduct(ptsX.last() - _Pt0) > dXMinRange;
			int bValidY = ptsY.length() > 0 && _YW.dotProduct(ptsY.last() - _Pt0) > dYMinRange;
			
			bValid = bValidX && bValidY;
		}
		
		if (!bValid)
		{ 
			dp.color(nRangeColor);
			dp.draw(ppMinRange, _kDrawFilled, nRangeTransparency);
		}
		
		
		
	}
//endregion 




//region Nesting Info

//Set parent/child relations
	double dZ;
	
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity& e = ents[i];
		TslInst t = (TslInst)e;
		if (!t.bIsValid())
		{ 
			continue;
		}

		Entity refs[] = t.entity();
		if (refs.length()<1)
		{ 
			continue;
		}
		
		Map mapX = e.subMapX(sXkeyChild);
		mapX.setString("ParentUid", _ThisInst.uniqueId());
		mapX.setString("ParentHandle", _ThisInst.handle());
		
		PlaneProfile shape = mapX.getPlaneProfile("Shape");
		
		if (mapX.hasDouble("dZ") && dZ < dEps)
			dZ = mapX.getDouble("dZ");
		
		CoordSys csChild = t.coordSys();
		CoordSys csChildRel;
		
		if (sAlignment == tYPos || sAlignment == tYNeg)
		{
			int nSign = (sAlignment == tYPos) ? 1 : -1;
			csChildRel.setToAlignCoordSys(
				ptOrg, csParent.vecX(), csParent.vecY(), csParent.vecZ(),
				shape.ptMid() + csChild.vecZ() * 0.5 * dZ, csChild.vecX(), -nSign *  csChild.vecZ(), +nSign * csChild.vecY());
		}
		else
		{
			int nSign = (sAlignment == tZPos) ? 1 : -1;
			csChildRel.setToAlignCoordSys(
				ptOrg, csParent.vecX(), csParent.vecY(), csParent.vecZ(),
				shape.ptMid() + csChild.vecZ() * 0.5 * dZ, csChild.vecX(), nSign *  csChild.vecY(), -nSign * csChild.vecZ());
		}
		
		mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
		mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
		mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
		mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);
		
		e.setSubMapX(sXkeyChild,mapX);
	
	}//next i	


//Compose parent mapX with Nesting info
	Map mapX;	
	mapX.setPlaneProfile("Shape", ppMaster);
	mapX.setDouble("dZ", dZ); // store thickness of first clone
	mapX.setString("MyUid", _ThisInst.uniqueId());
	mapX.setPoint3d("ptOrg", ptOrg, _kRelative);
	mapX.setVector3d("vecX", csParent.vecX(), _kScalable); // coordsys carries size
	mapX.setVector3d("vecY", csParent.vecY(), _kScalable);
	mapX.setVector3d("vecZ", csParent.vecZ(), _kScalable);
	_ThisInst.setSubMapX("Hsb_NestingParent",mapX);					

//endregion 



//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		dProps.append(dXMinRange);
		dProps.append(dYMinRange);
		nProps.append(nRangeColor);
		nProps.append(nRangeTransparency);
	
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				dXMinRange = tslDialog.propDouble(0);
				dYMinRange = tslDialog.propDouble(1);
				
				nRangeColor = tslDialog.propInt(0);
				nRangeTransparency = tslDialog.propInt(1);

				Map m = mapSetting.getMap("Nester");
				m.setDouble("XMin",dXMinRange);
				m.setDouble("YMin",dYMinRange);
				m.setInt("Color",nRangeColor);
				m.setInt("Transparency",nRangeTransparency);

				mapSetting.setMap("Nester", m);
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
        <int nm="BreakPoint" vl="193" />
        <int nm="BreakPoint" vl="193" />
        <int nm="BreakPoint" vl="1446" />
        <int nm="BreakPoint" vl="1401" />
        <int nm="BreakPoint" vl="842" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22194 new settings for minimal range, new display of minimal range" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/30/2024 5:48:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20086 Adjust transformation when alignment changes." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="9/18/2023 12:00:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 objectNester enhanced to accept uniform visible height and uniform width per row, supports grip based dragging" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/1/2023 12:01:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 Polyline dependency removed, new grips to modify size, only one unique height per nesting" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/24/2023 4:35:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 supports parent/child grouping" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/5/2023 2:49:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 initialversion of ObjectNester" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/22/2023 5:49:07 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End