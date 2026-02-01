#Version 8
#BeginDescription
#Versions
Version 1.8 31.10.2024 HSB-22323 bugfix purging on insert
Version 1.7 30.10.2024 HSB-22323 supports weight, purges duplicates, settings to control tag location
Version 1.6 24.10.2023 HSB-20438 default tag location set to middle
Version 1.5 02.08.2023 HSB-18900 bugfix initial distribution
Version 1.4 01.08.2023 HSB-18900 grip based assigning
Version 1.3 24.07.2023 HSB-18900 visible height published
Version 1.2 06.07.2023 HSB-18900 parent/child grouping fixed
Version 1.1 05.07.2023 HSB-18900 supports parent/child grouping
Version 1.0 22.06.2023 HSB-18900 initial version of ObjectClone






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
//region Part #1

//region History
// #Versions
// 1.8 31.10.2024 HSB-22323 bugfix purging on insert , Author Thorsten Huck
// 1.7 30.10.2024 HSB-22323 supports weight, purges duplicates, settings to control tag location , Author Thorsten Huck
// 1.6 24.10.2023 HSB-20438 default tag location set to middle , Author Thorsten Huck
// 1.5 02.08.2023 HSB-18900 bugfix initial distribution , Author Thorsten Huck
// 1.4 01.08.2023 HSB-18900 grip based assigning , Author Thorsten Huck
// 1.3 24.07.2023 HSB-18900 visible height published , Author Thorsten Huck
// 1.1 05.07.2023 HSB-18900 parent/child grouping fixed , Author Thorsten Huck
// 1.1 05.07.2023 HSB-18900 supports parent/child grouping , Author Thorsten Huck
// 1.0 22.06.2023 HSB-18900 initial version of ObjectClone , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities and pick location
/// </insert>

// <summary Lang=en>
// This tsl creates a clone of an entity and transforms its representation into XY-World plane
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ObjectClone")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Relation|") (_TM "|Select Object Clone|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Relation|") (_TM "|Select Object Clone|"))) TSLCONTENT
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

	String sXKey = "ObjectClone";
	String tSelectionPainter =  T("|Object Selection|");
	
	String tMAbsolute=T("|Absolute|"), tMRelative=T("|Relative|"), sModes[] = {tMAbsolute,tMRelative};
//end Constants//endregion

//END Part #1 //endregion 

//region FUNCTIONS
	TslInst[] collectTsls(String scriptName, double dZ)
	{ 
		TslInst out[0];
		scriptName=scriptName.makeLower();
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i];
			if (t.bIsValid() && t.scriptName().makeLower()==scriptName)
			{
				if (dZ<=dEps)
					out.append(t);	
				else
				{ 
					Map m = t.subMapX("Hsb_NestingParent");
					double dz = m.getDouble("dZ");
					if (abs(dZ-dz)<dEps)
					{ 
						out.append(t);	
					}
				}
			}
		}//next i		
		return out;
	}	
	PlaneProfile[] getNesterShapes(TslInst tsls[])
	{ 
		PlaneProfile out[0];
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst t= (TslInst)tsls[i];
			Map m = t.subMapX("Hsb_NestingParent");
			out.append(m.getPlaneProfile("Shape"));		 
		}//next i		
		return out;
	}	
	
	int getIndexMaxIntersetion(PlaneProfile ppShape, PlaneProfile pps[])
	{ 
		int out=-1;
		double dMax;
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp = pps[i];
			pp.intersectWith(ppShape);
			double area = pp.area();
			if (area>dMax)
			{ 
				out = i;
				dMax = area;
			}
		}//next i
		return out;
	}

//region Function HasDuplicate
	// returns if a script of the given scriptname is attached to the entity
	// this: the tslInstance which runs the test
	// ent: the entity to test the associations
	// scriptName: optional scriptName
	int HasDuplicate(Entity ent, TslInst this, String scriptName)
	{ 
		int out;
		
		if (scriptName.length()<1 && this.bIsValid())
			scriptName = this.scriptName();
		else if (scriptName.length()<1)
			scriptName = scriptName();
		scriptName.makeLower();
	
		TslInst tsls[] = ent.tslInstAttached();
		for (int j= 0; j < tsls.length(); j++)
		{ 
			TslInst t = tsls[j];
			
			if (t.entity().length()>1){ continue;}// ignore instances which do the distribution
			String scriptNameB = t.scriptName(); scriptNameB.makeLower();
			if (scriptName == scriptNameB && t!=this)
			{ 
				//if (bDebug)reportMessage("\n" + ent.handle() + T(" |is an duplicate of an existing| ") + scriptName + " " + this.handle() + " vs " + t.handle());
				out = true;
				break;	
			}
		}
		return out;
	}//endregion	
	
	
	
	
//endregion 

//region Part #2

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	
			
			String desc = T("|The selected mode specifies if an absolute offset or a fraction of the corresponding clone dimension is used.|");

		category = T("|Tag Position|");
			String sXOffsetName=T("|X-Offset Tag|");	
			PropDouble dXOffset(nDoubleIndex++, U(0), sXOffsetName);	
			dXOffset.setDescription(T("|Defines the default X-offset of the tag seen from the upper left corner.| ") + desc);
			dXOffset.setCategory(category);
		
			String sXModeName=T("|X-Offset Mode|");	
			PropString sXMode(nStringIndex++, sModes, sXModeName);	
			sXMode.setDescription(T("|Defines if the offset is absolute or relative|"));
			sXMode.setCategory(category);

			String sYOffsetName=T("|Y-Offset Tag|");	
			PropDouble dYOffset(nDoubleIndex++, U(0), sYOffsetName);	
			dYOffset.setDescription(T("|Defines the default X-offset of the tag seen from the upper left corner.| ")+desc);
			dYOffset.setCategory(category);

			String sYModeName=T("|Y-Offset Mode|");	
			PropString sYMode(nStringIndex++, sModes, sYModeName);	
			sYMode.setDescription(T("|Defines if the offset is absolute or relative|"));
			sYMode.setCategory(category);
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
	double dXOffset, dYOffset;
	int bXRelative, bYRelative;
	{
		String k;
		Map m= mapSetting.getMap("Tag");
	
		k="XOffset";		if (m.hasDouble(k))	dXOffset = m.getDouble(k);
		k="YOffset";		if (m.hasDouble(k))	dYOffset = m.getDouble(k);	
		
		k="XMode";		if (m.hasInt(k))	bXRelative = m.getInt(k);
		k="YMode";		if (m.hasInt(k))	bYRelative = m.getInt(k);
		
		
	}
	//End Read Settings//endregion 

	
//End Settings//endregion	

//region Painters

	String tDisabledEntry = T("<|Disabled|>");
	String tBeamByLength = T("<|Beam by Length|>");
	String tSheetByLength = T("<|Sheet by Length|>");

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
			if (sPainters.findNoCase(name,-1)<0 && name!=tSelectionPainter)
			{
				sPainters.append(name);
			}

				
		}		 
	}//next i

	{ 
		String name = tBeamByLength;
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
					pd.setType("Beam");
					//pd.setFilter("");
					pd.setFormat("@(SolidLength:RL0:PL5;0)");
				}
			}				
			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}
		}		
	}
	{ 
		String name = tSheetByLength;
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			Entity ents[] = Group().collectEntities(true, Sheet(), _kModelSpace);
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid() && ents.length()>0)
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Sheet");
					//pd.setFilter("");
					pd.setFormat("@(SolidLength:RL0:PL5;0)");
				}
			}				
			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}
		}		
	}

	sPainters.sorted();	
	sPainters.insertAt(0, tDisabledEntry);

//endregion

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

category = T("|Filter|");
	String sPainterName=T("|Filter|");	
	PropString sPainter(nStringIndex++, sPainters, sPainterName,2);	
	sPainter.setDescription(T("|Defines the painter definition which will be used to filter solids to be converted to beams|"));
	sPainter.setCategory(category);
	
	String tAscending = T("|Ascending|"), tDescending= T("|Descending|"), sSortings[] ={tAscending, tDescending };
	String sSortingName=T("|Sorting|");	
	PropString sSorting(nStringIndex++,sSortings, sSortingName);	
	sSorting.setDescription(T("|Defines the Sorting|"));
	sSorting.setCategory(category);

category = T("|General|");
	String tZPos = "+Z", tZNeg = "-Z", tYPos = "+Y", tYNeg = "-Y";
	String sAlignments[] = { tZPos, tYPos, tZNeg, tYNeg};
	String sAlignmentName=T("|Alignmment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignmment|"));
	sAlignment.setCategory(category);

	
category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the header display|"));
	sFormat.setCategory(category);
	Map mapAdd;
	if (_bOnInsert)
	{ 
		mapAdd.setString("Yield", "85%"); // dummy
		sFormat.setDefinesFormatting("TslInst", mapAdd);
	}

	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(50), sTextHeightName,_kLength);	
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
		
		
	// prompt for entities
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			_Entity.append(ssE.set());
		
		PainterDefinition pd(sPainterCollection+sPainter);
		if (pd.bIsValid())
			_Entity= pd.filterAcceptedEntities(_Entity);
		
		_Pt0 = getPoint();
		
		return;
	}			
//endregion 

//END Part #2 //endregion 

//region Painter based filtering and sorting
	PainterDefinition pd(sPainterCollection+sPainter);
	int nGroupIndices[_Entity.length()]; // indicating to which group the entity belongs to
	if (pd.bIsValid() && _Entity.length()>1)
	{
		_Entity= pd.filterAcceptedEntities(_Entity);
		nGroupIndices.setLength(_Entity.length());
		String ftr = pd.format();
		
	//region Collect tags based on given format
		String tags[0];
		if (ftr.length()>0)
			for (int i = 0; i < _Entity.length(); i++)
			{
				Entity e = _Entity[i];
				String tag= e.formatObject(ftr);
				tags.append(tag);
			}

	// order ascending or descending
		int bAscending = sSorting == tAscending;
		for (int i=0;i<tags.length();i++) 
			for (int j=0;j<tags.length()-1;j++) 
				if ((bAscending && tags[j]>tags[j+1]) || (!bAscending && tags[j]<tags[j+1]))
				{
					_Entity.swap(j, j + 1);
					tags.swap(j, j + 1);
				}

	// Collect group indices
		int index;
		for (int i=0;i<tags.length();i++) 
		{ 
			if (i>0 && tags[i]!=tags[i-1])
			{ 
				index++;
			}
			nGroupIndices[i] = index;
		}
	//endregion			
	}
	if(_Entity.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no reference found|"));	
		eraseInstance();
		return;
	}
//endregion 

//region Standards
	CoordSys csW();
	_Pt0.setZ(0);
	Display dp(-1),dpWhite(-1), dpText(-1);
	dpWhite.trueColor(rgb(255, 255, 254), 60);
	dpText.trueColor(rgb(0,0,0));
	dpText.dimStyle(sDimStyle);
	double textHeight = dTextHeight;
	if (textHeight>0)
		dpText.textHeight(textHeight);
	else
		textHeight = dpText.textHeightForStyle("O", sDimStyle);
		
	double dRowOffset = U(50);	
	
	// create instance distribution
	int bDistribute = _Entity.length() > 1;// && !bDebug;

//endregion 

//region Draw transformed items
	Point3d ptX = _Pt0;
	int num;
// Define nesting shape
	PlaneProfile ppShape(csW);
	double dX, dY, dZ;
	int bIsSolid,bIs2D;
	Body bd; 
	PLine pl;
	
	CoordSys ms2ps, ps2ms;
	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		
		Point3d ptRef = ptX;
		
		CoordSys cs();
		Point3d ptOrg = cs.ptOrg();

		Entity& e = _Entity[i]; 
		GenBeam gb = (GenBeam)e;

		EntPLine epl = (EntPLine)e;
		if (bDistribute)
			ppShape=PlaneProfile (csW);
		else
			setDependencyOnEntity(e);
		
		if (gb.bIsValid())
		{ 
			bd = e.realBody();
			cs = CoordSys(gb.ptCenSolid(), gb.vecX(), gb.vecY(), gb.vecZ());
			ptOrg = cs.ptOrg();
		}							
		else if (epl.bIsValid())
		{ 
			pl = epl.getPLine();
			cs = pl.coordSys();
			PlaneProfile pp(cs);
			pp.joinRing(pl, _kAdd);
			ptOrg=pp.ptMid();
			Vector3d vecX=cs.vecX(), vecY=cs.vecY(), vecZ=cs.vecZ();
			
			if (vecZ.isParallelTo(_ZW) || vecZ.isParallelTo(_YW))
				vecX = _XW;
			vecY = vecX.crossProduct(-vecZ);	
			cs = CoordSys(ptOrg, vecX, vecY, vecZ);
		}	
		
		if (bd.isNull() && pl.length()<dEps)
		{ 
			if(bDebug)reportNotice("\n" + _Entity[i].typeName() + T(" |not supported|"));
			continue;
		}

	//region Alignment
		Vector3d vecX=cs.vecX(), vecY=cs.vecY(), vecZ=cs.vecZ();
		if (sAlignment==tZNeg)
		{ 
			vecY *= -1;
			vecZ *= -1;
		}
		else if (sAlignment==tYPos)
		{ 
			vecZ=cs.vecY();
			vecY = vecX.crossProduct(-vecZ);
		}		
		else if (sAlignment==tYPos)
		{ 
			vecZ=-cs.vecY();
			vecY = vecX.crossProduct(-vecZ);
		}		
				
	//endregion 	

		
		
	// Solid
		if (!bd.isNull())
		{ 
			bIsSolid = true;
			double dZ = bd.lengthInDirection(vecZ);
			ptRef += _ZW * .5 * dZ;
		}
		else if (pl.length()>dEps)
		{ 
			bIs2D = true;
		}
	
	// Transformation	
		
		
		ms2ps.setToAlignCoordSys(cs.ptOrg(), vecX, vecY, vecZ, ptRef, _XW, _YW, _ZW);
		ps2ms = ms2ps;
		ps2ms.invert();		
		

	

			
	// Solid
		if (bIsSolid)
		{ 
			ptRef.vis(1);
			bd.transformBy(ms2ps);		
			ppShape.unionWith(bd.shadowProfile(Plane(_Pt0, _ZW)));			
					
		}
	
	// PLine derived
		else if (bIs2D)
		{ 
			pl.transformBy(ms2ps);
			ppShape.joinRing(pl,_kAdd);	
			
		}
			
		
		dX = ppShape.dX();
		dY = ppShape.dY();
		dZ = bd.isNull()?0:bd.lengthInDirection(_ZW);
		Vector3d vec = .5 * ( _XW * dX - _YW * dY);
		ppShape.transformBy(vec);
		bd.transformBy(vec);
		ms2ps.transformBy(vec);

	// create individual items	
		if (bDistribute && !bDebug)
		{ 
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {e};			Point3d ptsTsl[] = {ptRef};
			int nProps[]={};			
			double dProps[]={dTextHeight};	
			String sProps[]={sPainter,sSorting,sAlignment,sFormat,sDimStyle};
			Map mapTsl;	
						
			tslNew.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
		}

		
	//region Draw Relation
		if (_Map.getInt("ShowRelation"))
		{
			Display dpr(e.color());
			
			Point3d pts[] ={ ptOrg};
			Point3d ptm = (ptOrg + ptRef) * .5;
			
			double dx = _XW.dotProduct(ptm - ptOrg);
			double dy = _YW.dotProduct(ptm - ptOrg);
			double dz = _ZW.dotProduct(ptRef - ptOrg);
			
			pts.append(pts.last() + _XW * dx);
			pts.append(pts.last() + _YW * dy);
			
			if (abs(dz)>dEps)
				pts.append(pts.last() + _ZW * dz);

			
			dx = _XW.dotProduct(ptRef-ptm);
			dy = _YW.dotProduct(ptRef-ptm);
			pts.append(pts.last() + _XW * dx);
//			pts.append(pts.last() + _YW * dy);
			pts.append(ptRef);
			
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				PLine route(pts[p], pts[p + 1]);
				dpr.draw(route);
				 
			}//next i		
		}
	//endregion 	

		ptX -= _YW * (dY+dRowOffset);	
	// offset next if in different group	
		if (i<nGroupIndices.length()-2 && nGroupIndices[i]!=nGroupIndices[i+1])
		{ 
			ptX -= _YW * 2*dRowOffset;
		}
		
		
	}//next i

	if (bDistribute)
	{ 
		if (!bDebug)eraseInstance();
		return;
	}

//endregion 


// check for duplictates
	Entity& e = _Entity[0];
	if (!_bOnGripPointDrag && !bDebug && HasDuplicate(e, _ThisInst, ""))
	{ 
		reportMessage("\n" +  T("|purging duplicate linked to| ") + e.typeDxfName() + " " + e.handle());
		eraseInstance();
		return;		
	}


//region Get Weight and COG
	double dWeight;
	Point3d ptCOG;
	{ 
		Map mapIO;
		Map mapEntities;
		mapEntities.appendEntity("Entity", _Entity[0]);
		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		ptCOG = mapIO.getPoint3d("ptCen");// returning the center of gravity
		dWeight = mapIO.getDouble("Weight");// returning the weight		
		ptCOG.vis(1);
		ptCOG.transformBy(ms2ps);
	}
	ptCOG.vis(1);
	
//endregion 



//region Append data to submpaX	
	dp.color(e.color());
	
	// Get parent nester if existant
	Map mapX =_ThisInst.subMapX("Hsb_NestingChild");
	String parentUID = mapX.getString("ParentHandle");
	Entity parent; parent.setFromHandle(parentUID);	
	PlaneProfile ppNesterShape = mapX.getPlaneProfile("Shape");	
	TslInst tslNester = (TslInst)parent;
	
	if (!bDebug)
	{ 
		Map m = _ThisInst.subMapX("Hsb_NestingChild");
		m.setDouble("dZ", dZ);
		m.setString("Entity", e.uniqueId());
		m.setPlaneProfile("Shape", ppShape);	
		_ThisInst.setSubMapX("Hsb_NestingChild",m);	
	}



//endregion 

//region Grip Management #GM
	//_Grip.setLength(0);
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	_ThisInst.setAllowGripAtPt0(false);
	String kGripTag="Tag", kGripDrag="Drag";
	String kGrips[] = { kGripTag, kGripDrag};
	int nGrips[] ={-1,-1};
	Point3d ptLocs[] ={ _Pt0, _Pt0-_YW*ppShape.dY()};
_Pt0.vis(6);	
	{ 
		Point3d& pt = ptLocs[0];
		
		pt += _XW*dXOffset * (bXRelative?ppShape.dX():1);
		pt -= _YW*dYOffset * (bYRelative?ppShape.dY():1);
		
	}
	ptLocs[0].vis(2);

	for (int i=0;i<_Grip.length();i++) 
	{ 
		Point3d pt = _Grip[i].ptLoc();
		pt.setZ(0);
		_Grip[i].setPtLoc(pt);
		
		int n = kGrips.findNoCase(_Grip[i].name() ,- 1);
		if (n >- 1)nGrips[n] = i;	 	
	}	
	
//Create grips
	for (int i=0;i<kGrips.length();i++) 
	{ 
		if (nGrips[i]<0)
		{ 
			Grip grip;
			grip.setPtLoc(ptLocs[i]);
			grip.setVecX(_XW);
			grip.setVecY(_YW);
			grip.setColor(i==0?40:4);
			grip.setShapeType(i==0 ? _kGSTCircle : _kGSTStar);
			grip.setName(kGrips[i]);
			
			if (i==0)
				grip.setToolTip(T("|Moves the location of the tag|"));
			else if (i==1 && parent.bIsValid())
				grip.setToolTip(T("|Drag clone within highlighted nesters or drag outside to release from nester|"));
			else if (i==1)
				grip.setToolTip(T("|Drag into one of the highlighted nesters to assign to a nester|"));

			grip.addHideDirection(_XW);
			grip.addHideDirection(-_XW);
			grip.addHideDirection(_YW);
			grip.addHideDirection(-_YW);
			
			_Grip.append(grip);
			nGrips[i] = _Grip.length() - 1;
		}
	}//next i	
	
	int nGripTag = nGrips[0];
	int nGripDrag = nGrips[1];
	
	Point3d ptTag = nGripTag >- 1 ? _Grip[nGripTag].ptLoc() : ptLocs[0];

	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip); 
	int bTagGripMoved = indexOfMovedGrip >-1 && indexOfMovedGrip == nGripTag;
	int bDrag = indexOfMovedGrip >-1 && indexOfMovedGrip == nGripDrag;
//endregion 

//region Drag
	Point3d ptDrag;	
	Vector3d vecDrag; 
	if (ptLocs.length()>1)
	{
		ptDrag= nGripDrag >- 1 ? _Grip[nGripDrag].ptLoc() : ptLocs[1];
		vecDrag =ptDrag- ptLocs[1]; 
	}

	// during dragging
	if (bDrag)	
	{ 
		TslInst tsls[] = collectTsls("ObjectNester", dZ);	
		PlaneProfile pps[] = getNesterShapes(tsls);


		Display dp(-1);
		dp.trueColor(darkyellow);
		ppShape.transformBy(vecDrag);

		int indexMax=getIndexMaxIntersetion(ppShape,pps);
		
	// no intersection	
		if (indexMax==-1)
		{
			dp.trueColor(red);
			dp.draw(ppShape);
			dp.draw(ppShape, _kDrawFilled, 60);
		}
		else
		{ 
		// draw available nesters	
			for (int i=0;i<pps.length();i++) 
			{ 
				PlaneProfile pp = pps[i]; 
				dp.trueColor(indexMax == i?darkyellow:lightblue);
				dp.draw(pp, _kDrawFilled, 80);
			}//next i	
			
			dp.trueColor(green);
			dp.draw(ppShape);
			dp.draw(ppShape, _kDrawFilled, 60);
			
			
		}
		setExecutionLoops(2);
		return;
	}
	// after dragging
	else if(!vecDrag.bIsZeroLength())
	{ 	
		//reportNotice("\ndrag event !");
		if (tslNester.bIsValid())
		{ 
			Map m = tslNester.subMapX("Hsb_NestingParent");
			ppNesterShape = m.getPlaneProfile("Shape");
		}

	//region Remove from parent if no intersection could be found
		ppShape.transformBy(vecDrag);		
		int bRemoveFromNester;
		if (ppNesterShape.area()>pow(dEps,2))
		{ 
			PlaneProfile ppx = ppShape;
			ppx.intersectWith(ppNesterShape);	
			bRemoveFromNester = ppx.area() < pow(dEps, 2);			
		}
		if (bRemoveFromNester)
		{ 
			Map mapParent = tslNester.map();
			mapParent.setEntity("Child2Remove", _ThisInst);
			tslNester.setMap(mapParent);
			

			_ThisInst.removeSubMapX("Hsb_NestingChild");
		}	
		tslNester.transformBy(Vector3d(0, 0, 0));
	//endregion 

	//region Update this instance
		_Pt0.transformBy(vecDrag);
		_Grip.removeAt(nGripDrag);
		pushCommandOnCommandStack("_HSB_Recalc");
		pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");			
	//endregion 
	

	// adding to new nester
		TslInst tsls[] = collectTsls("ObjectNester", dZ);	
		PlaneProfile pps[] = getNesterShapes(tsls);
		int indexMax=getIndexMaxIntersetion(ppShape,pps);
	
		if (indexMax>-1 && (tsls[indexMax]!=tslNester))
		{ 
			//reportNotice("\nadding to index " +indexMax);
			tslNester = tsls[indexMax];
			Map mapParent = tslNester.map();
			mapParent.setEntity("Child2Add", _ThisInst);
			tslNester.setMap(mapParent);
			tslNester.transformBy(Vector3d(0, 0, 0));
			parent = tslNester;
		}




	}

//endregion 

//region Draw


// Draw potential collsions
//	if (tslNester.bIsValid())
//	{ 
//		Display dpRed(-1);
//		dpRed.trueColor(red);
//		Entity clones[] = tslNester.entity();
//		for (int i=0;i<clones.length();i++) 
//		{ 
//			if (clones[i] == _ThisInst){continue;}
//			Map mapX= clones[i].subMapX("Hsb_NestingChild");
//			
//			PlaneProfile ppx = mapX.getPlaneProfile("Shape");
//			ppx.intersectWith(ppShape);
//			if (ppx.area()>pow(dEps,2))
//			{ 
//				dpRed.draw(ppx, _kDrawFilled, 10);
//			}			 
//		}//next i
//	}

	if (bIsSolid)
		dp.draw(bd);
	else if (bIs2D)
		dp.draw(ppShape);	

	dp.draw(ppShape, _kDrawFilled, parent.bIsValid()?90:30);	

	mapAdd.setDouble("VisibleHeight", dZ);
	mapAdd.setDouble("Weight", dWeight,_kNoUnit);
	Point3d ptTxt = ptTag + .3 * textHeight * (_XW - _YW);
	String text = e.formatObject(sFormat, mapAdd);
	sFormat.setDefinesFormatting(e, mapAdd);

	PLine plBox; plBox.createRectangle(LineSeg(ptTxt, ptTxt+ _XW * dpText.textLengthForStyle(text, sDimStyle, textHeight) 
		- _YW * dpText.textHeightForStyle(text, sDimStyle, textHeight)), _XW, _YW);
	plBox.offset(textHeight * .2, true);;
	//plBox.vis(6);
	dpWhite.draw(PlaneProfile(plBox), _kDrawFilled, 20);

	dpText.draw(text, ptTxt, _XW, _YW, 1 ,- 1);
	dpText.draw(plBox);			
//endregion 

//region Trigger ShowRelation
	int bShowRelation = _Map.getInt("ShowRelation");
	String sTriggerShowRelation =bShowRelation?T("|Hide Relation|"):T("|Show Relation|");
	addRecalcTrigger(_kContextRoot, sTriggerShowRelation);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowRelation)
	{
		bShowRelation = bShowRelation ? false : true;
		_Map.setInt("ShowRelation", bShowRelation);		
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Settings|");
	addRecalcTrigger(_kContextRoot, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		dProps.append(dXOffset);
		dProps.append(dYOffset);
		
		sProps.append(bXRelative ? tMRelative : tMAbsolute);
		sProps.append(bYRelative ? tMRelative : tMAbsolute);
	
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				dXOffset = tslDialog.propDouble(0);
				dYOffset = tslDialog.propDouble(1);
				
				bXRelative = tslDialog.propString(0)==tMRelative?true:false;
				bYRelative = tslDialog.propString(1)==tMRelative?true:false;
				
				Map m = mapSetting.getMap("Tag");
				m.setDouble("XOffset",dXOffset);
				m.setInt("XMode",bXRelative);
				m.setDouble("YOffset",dYOffset);
				m.setInt("YMode",bYRelative);

				mapSetting.setMap("Tag", m);
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
        <int nm="BreakPoint" vl="979" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22323 bugfix purging on insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/31/2024 8:58:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22323 supports weight, purges duplicates, settings to control tag location" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/30/2024 4:17:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20438 default tag location set to middle" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/24/2023 8:17:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 bugfix initial distribution" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/2/2023 10:13:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 grip based assigning" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/1/2023 11:59:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 visible height published" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/24/2023 4:39:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 supports parent/child grouping" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/5/2023 2:51:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18900 initial version of ObjectClone" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/22/2023 5:51:19 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End