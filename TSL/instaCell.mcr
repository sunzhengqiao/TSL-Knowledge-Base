#Version 8
#BeginDescription
This tsl creates a single installation cell to be combined in an instaCombination. It requires the tsl set instaCombination, instaCell and instaConduit

#Versions
Version 3.4 17.01.2024 HSB-20506 layer assignment on zone 0 = Z-Layer

Version 3.3    14.11.2022    HSB-16092 tool update on copy adn move improved
Version 3.2    06.09.2022    HSB-16089 new command to list all available commands in report dialog
Version 3.1    29.07.2022    HSB-16903 storing hardware against a block only available on instances with a valid block selected
Version 3.0    13.12.2021    HSB-14130 bugfix selection loose genbeams
Version 2.9    07.12.2021    HSB-14039 block assignment independent from current UCS
Version 2.8    06.12.2021    HSB-13202 uses default hardware dialog to add/edit/remove entries
Version 2.7    02.12.2021    HSB-13202 new command to hide/show tools, block management improved
Version 2.6    01.12.2021    HSB-13729 new solid display of drill tools
Version 2.5    08.10.2021    HSB-13446 face indicated by half circle display
Version 2.4    29.09.2021    HSB-13203 element tools supported if elmenet is of type stickframe wall or roof element
Version 2.3    17.09.2021    HSB-13129 performance enhancements if dwg contains many blocks, block definitions cached in mapObject
Version 2.2    16.09.2021    HSB-13129 conduit supports rule based insertion
Version 2.1    20.07.2021    HSB-12638 new shape 'octagon' added
Version 2.0    20.07.2021    HSB-12621 (3) additional group assignment supported
Version 1.9    20.07.2021    HSB-12641 mortsie and beamcut tools display outline when in byCombination mode
Version 1.8    25.06.2021    HSB-12286 uniform block scaling, HSB-12284 new properties to support different tools: drill, mortise and beamcut
Version 1.7    18.06.2021    HSB-12298 bugfix default insert
Version 1.6   29.03.2021     HSB-11286 bugfix path location of non imported blocks
Version 1.5   26.03.2021     HSB-11329 bugfix default display
Version 1.4   25.03.2021     HSB-11329 hardware added to block definition
Version 1.3   21.03.2021     HSB-11286 custom block definition and display added
Version 1.2   15.03.2021     HSB-10793 element support added
Version 1.1    02.03.2021    HSB-11022 drill tolerances added
Version 1.0   17.02.2021     HSB-10758 initial version































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords Electra;Sanitary;Sip;Installation;CLT;BSP
#BeginContents
//region History
// #Versions
// 3.4 17.01.2024 HSB-20506 layer assignment on zone 0 = Z-Layer , Author Thorsten Huck
// 3.3 14.11.2022 HSB-16092 tool update on copy adn move improved , Author Thorsten Huck
// 3.2 06.09.2022 HSB-16089 new command to list all available commands in report dialog , Author Thorsten Huck
// 3.1 29.07.2022 HSB-16903 storing hardware against a block only available on instances with a valid block selected , Author Thorsten Huck
// 3.0 13.12.2021 HSB-14130 bugfix selection loose genbeams , Author Thorsten Huck
// 2.9 07.12.2021 HSB-14039 block assignment independent from current UCS , Author Thorsten Huck
// 2.8 06.12.2021 HSB-13202 uses default hardware dialog to add/edit/remove entries , Author Thorsten Huck
// 2.7 02.12.2021 HSB-13202 new command to hide/show tools, block management improved , Author Thorsten Huck
// 2.6 01.12.2021 HSB-13729 new solid display of drill tools , Author Thorsten Huck
// 2.5 08.10.2021 HSB-13446 face indicated by half circle display , Author Thorsten Huck
// 2.4 29.09.2021 HSB-13203 element tools supported if elmenet is of type stickframe wall or roof element , Author Thorsten Huck
// 2.3 17.09.2021 HSB-13129 performance enhancements if dwg contains many blocks, block definitions cached in mapObject , Author Thorsten Huck
// 2.2 16.09.2021 HSB-13129 conduit supports rule based insertion , Author Thorsten Huck
// 2.1 20.07.2021 HSB-12638 new shape 'octagon' added , Author Thorsten Huck
// 2.0 20.07.2021 HSB-12621 (3) additional group assignment supported , Author Thorsten Huck
// 1.9 20.07.2021 HSB-12641 mortsie and beamcut tools display outline when in byCombination mode , Author Thorsten Huck
// 1.8 25.06.2021 HSB-12286 uniform block scaling, HSB-12284 new properties to support different tools: drill, mortise and beamcut , Author Thorsten Huck
// 1.7 18.06.2021 HSB-12298 bugfix default insert , Author Thorsten Huck
// 1.6 29.03.2021 HSB-11286 bugfix path location of non imported blocks , Author Thorsten Huck
// 1.5 26.03.2021 HSB-11329 bugfix default display , Author Thorsten Huck
// 1.4 25.03.2021 HSB-11329 hardware added to block definition , Author Thorsten Huck
// 1.3 21.03.2021 HSB-11286 custom block definition and display added , Author Thorsten Huck
// 1.2 15.03.2021 HSB-10793 element support added , Author Thorsten Huck
// 1.1 02.03.2021 HSB-11022 drill tolerances added , Author Thorsten Huck
// 1.0 17.02.2021 HSB-10758 initial version , Author Thorsten Huck 

/// <insert Lang=en>
/// Select a panel and an insertion point, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a single installation cell to be combined in an instaCombination. It requires the tsl set instaCombination, instaCell and instaConduit
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCell")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Tools|") (_TM "|Select tools|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Tools|") (_TM "|Select tools|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Width <-> Height|") (_TM "|Select cell|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set block definition|") (_TM "|Select cell|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Store hardware in block definition|") (_TM "|Select cell|"))) TSLCONTENT

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
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sInstaCombination = "instaCombination".makeUpper();
	String sToolings[] ={T("|byCell|"), T("|byCell with Mill|")};	
	int nc = 3;
	String tDisabled = T("<|Disabled|>");
	String sDefaultBlockPath = _kPathHsbCompany + "\\Block\\insta"; // the path where blocks are collected from
	String sCustomBlockPath;
	
	double dTextHeight = U(60);	
	//reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle() + " tick:" +getTickCount());
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey("BlockData");

			String sDefinitionName=T("|Blockname|");	
			PropString sDefinition(nStringIndex++, "TXT", sDefinitionName);	
			sDefinition.setDescription(T("|Defines the name of the block|"));
			sDefinition.setCategory(category);

			String sCategoryName = T("|Category|");
			PropString sCategory(nStringIndex++, T("|Electra|"), sCategoryName);
			sCategory.setDescription(T("|Defines the category, which will contribute to the ordering of the entries.|"));
			sCategory.setCategory(category);

			String sSubCategoryName = T("|Sub Category|");
			PropString sSubCategory(nStringIndex++, T("|Switches|"), sSubCategoryName);
			sSubCategory.setDescription(T("|Defines the sub category, which will contribute to the ordering of the entries.|"));
			sSubCategory.setCategory(category);
			
//			String sSizeName=T("|Size|");	
//			PropDouble dSize(nDoubleIndex++, U(70), sSizeName);	
//			dSize.setDescription(T("|Defines the size of all blocks|"));
//			dSize.setCategory(category);

			_Pt0 = _PtW;
			Display dp(-1); // draw nothing
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
	String sFileName ="instaCombination";
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
	String sBlockPath = sDefaultBlockPath;
	String sInstaBlockNames[0]; // a list of blocks which contain insta classification data
	
	// plan view
	double dScalePlan = 1;
	double dTextHeightPlan = dTextHeight;
	String sDimStylePlan;
	int nColorPlan=nc;
	int nColorPlanSymbol = 0;// byBlock

	// element view
	double dScaleElement = 1;
	double dTextHeightElement = dTextHeight;
	String sDimStyleElement;
	int nColorElement=nc;
	int nColorElementOpposite = 4;
	int nColorElementSymbol = 3;// byBlock
	int bHalfFill = true; // show the cell half filled: on top if icon side, on bottom if opposite side
	double dSymbolOffsetElement=999; // 999 means by cell	
	
	
	
{
	String k;
	Map m= mapSetting.getMap("Cell");

	
	//k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
	k="BlockPath";			if (m.hasString(k))	sCustomBlockPath = m.getString(k);
	//k="IntEntry";			if (m.hasInt(k))	sIntEntry = m.getInt(k);
	
	if (sCustomBlockPath.length()>0 && getFilesInFolder(sCustomBlockPath, "*.dwg").length()>0)
		sBlockPath = sCustomBlockPath;
		
//// get registerd insta blockknames		/ not completely implemented
//	m = m.getMap("Blockname[]");
//	for (int i=0;i<m.length();i++) 
//	{ 
//		String key = m.keyAt(i);
//		String value = m.getString(i);
//		if (key.find("Blockname",0,false)>-1 && value.length()>0 && sInstaBlockNames.findNoCase(value,-1)>-1)
//			sInstaBlockNames.append(value);	 
//	}//next i
	
	
	Map mapCombination = mapSetting.getMap("Combination");
	{ 
		Map m = mapCombination.getMap("Planview");
		k = "Color"; if (m.hasInt(k)) nColorPlan = m.getInt(k);
		k = "DimStyle"; if (m.hasString(k)) sDimStylePlan = m.getString(k);
		k = "TextHeight"; if (m.hasDouble(k)) dTextHeightPlan = m.getDouble(k);	
		k = "Scale"; if (m.hasDouble(k)) dScalePlan = m.getDouble(k);
		k = "ColorSymbol"; if (m.hasInt(k)) nColorPlanSymbol = m.getInt(k);
	}	
	{ 
		Map m = mapCombination.getMap("Elementview");
		k = "Color"; if (m.hasInt(k)) nColorElement = m.getInt(k);
		k = "ColorOpposite"; if (m.hasInt(k)) nColorElementOpposite = m.getInt(k);
		k = "DimStyle"; if (m.hasString(k)) sDimStyleElement = m.getString(k);
		k = "TextHeight"; if (m.hasDouble(k)) dTextHeightElement = m.getDouble(k);	
		k = "Scale"; if (m.hasDouble(k)) dScaleElement = m.getDouble(k);
		k = "ColorSymbol"; if (m.hasInt(k)) nColorElementSymbol = m.getInt(k);
		k = "HalfFill"; if (m.hasInt(k)) bHalfFill = m.getInt(k);
	}		
}
//End Read Settings//endregion 

//region Get parent entity
	Element el;
	if (_Element.length() > 0)el = _Element[0];
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg, ptCen;
	double dZ;
	int bHasElement = el.bIsValid(), bHasSip, bIsLogWall, bIsSipWall, bIsSFWall, bIsFloor,bAddElementTool;
	Sip sip, sips[0];
	Beam beams[0]; 
	Sheet sheets[0];
	GenBeam genbeams[0]; genbeams=_GenBeam;

// Get element if not found yet
	if(!bHasElement)
	for (int i=0;i<genbeams.length();i++) 
	{ 
		Element _el = genbeams[i].element(); 
		if (_el.bIsValid())
		{ 
			el = _el;
			_Element.append(_el);
			break;
		}
	}//next i
	
//region Identify wall type if any
	if (el.bIsValid())
	{
		int bTypeCheck = true;	
		if (bTypeCheck)
		{ 
			ElementWallSF elX = (ElementWallSF)el;
			bIsSFWall= elX.bIsValid();
			bAddElementTool = bIsSFWall;
			bTypeCheck = !bIsSFWall;
		}
		if (bTypeCheck)
		{ 
			ElementLog elX = (ElementLog)el;
			bIsLogWall = elX.bIsValid();
			bTypeCheck = !bIsLogWall;
		}
		if (bTypeCheck)
		{ 
			ElementRoof elX = (ElementRoof)el;
			bIsFloor = elX.bIsValid();
			bAddElementTool = bIsSFWall;
			bTypeCheck = !bIsFloor;
		}		
		if (!bIsSFWall)
		{ 
			ElementWall elX = (ElementWall)el;
			bIsSipWall = elX.bIsValid();
			bTypeCheck = !bIsSipWall;
		}
		bHasElement = true;
		genbeams = el.genBeam();
		
		//assignToElementGroup(el, false, 0, 'E');
		vecX = el.vecX();
		vecY = el.vecY();
		vecZ = el.vecZ();
		ptOrg = el.ptOrg();
		LineSeg seg = el.segmentMinMax();	
		ptCen = seg.ptMid();
		dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));	
		
		if (dZ<=dEps) // strange enough some walls don't have a valid segmentMinMax
		{ 
			seg = PlaneProfile(el.plOutlineWall()).extentInDir(vecX);
			ptCen = seg.ptMid();
			dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
		}
		//seg.vis(6);
	}		
//End Identify wall type if any//endregion 

//End  parent entity//endregion 


//region Properties	
category = T("|Tool|");
	String sToolName=T("|Tool|");	
	String sTools[] ={ T("|Drill|"), T("|Mortise|"), T("|Beamcut|"), T("|Octagon|")};
	PropString sTool(1, sTools, sToolName);	
	sTool.setDescription(T("|Defines the Tool|"));
	sTool.setCategory(category);
	int nTool = sTools.find(sTool);
	if (nTool < 0) { nTool = 0; sTool.set(sTools[nTool]);}
	int bIsOctagon = nTool == 3;
	int bIsDrill = nTool == 0;
	int bIsBeamcut = nTool == 2;
	int bIsMortise = nTool == 1;
	
	
// Drill	
	String sDiameterName=(bIsDrill || bIsOctagon)?T("|Diameter|"):T("|Width|");		
	PropDouble dDiameter(0, U(68), sDiameterName);	
	dDiameter.setDescription(nTool==0?T("|Defines the diameter of a drill|"): T("|Defines the width of the tool|"));
	dDiameter.setCategory(category);
	
// Beamcut or Mortise	
	String sHeightName=bIsOctagon?T("|Tangent Height|"):T("|Height|");	
	PropDouble dHeight(4, U(68), sHeightName);	
	dHeight.setDescription(bIsOctagon?T("|Defines the tangent height, 0 = even octagon|"):T("|Defines the height of the tool|"));
	dHeight.setCategory(category);
	dHeight.setReadOnly(!bIsDrill ? false : _kHidden);

// all tools
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(1, U(68), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|")+ T(", |0 = complete through|"));
	dDepth.setCategory(category);
	
// Mortise
	String sToolRadiusName=T("|Radius|");	
	PropDouble dToolRadius(5, 0, sToolRadiusName);	
	dToolRadius.setDescription(T("|Defines the explicit radius of a mortise if height > 0|"));
	dToolRadius.setCategory(category);	
	dToolRadius.setReadOnly(bIsMortise ? false : _kHidden);

	String sToolIndexName=T("|Tool Index|");	
	PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);	
	nToolIndex.setDescription(T("|Defines the Tool Index|"));
	nToolIndex.setCategory(category);
	if (bHasElement && (!bAddElementTool))	nToolIndex.setReadOnly(_kHidden);

// 2nd drill
	String sDiameter2Name=T("|Diameter Through Drill|");
	PropDouble dDiameter2(2, U(0), sDiameter2Name);	
	dDiameter2.setDescription(T("|Defines the diameter of a optional through drill|") + T("|0 = none|"));
	dDiameter2.setCategory(category);	
	
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(3, U(1), sOffsetName);	
	dOffset.setDescription(T("|Defines the offset to next cell|"));
	dOffset.setCategory(category);	


category = T("|Model|");
	String sBlocks[0];
	String sBlockNames[0];
	String sBlockCats[0], sBlockSubCats[0], sBlockPaths[0];
	String sBlockName=T("|Blockname|");
	
//region Cache valid blocks in mapObject
	String sDictionaryBlock = "hsbTSLBlock";
	String sDictEntry = "2DBlock";
	MapObject moBlock2D(sDictionaryBlock, sDictEntry);
	int bHasBlock2D = moBlock2D.bIsValid();
	Map mapBlock2D;
	if (bHasBlock2D)
	{ 
		mapBlock2D = moBlock2D.map();
		setDependencyOnDictObject(moBlock2D);	
		
	// collect blocks from cache
		Map _mapBlock2D; int bRewrite;// rewrite purged map
		for (int j=0;j<mapBlock2D.length();j++) 
		{ 
			Map m = mapBlock2D.getMap(j);
			String name = m.getMapName();
			if (_BlockNames.findNoCase(name ,- 1) < 0 ||
				sBlocks.findNoCase(name ,- 1) >-1)
			{
				bRewrite = true;
				continue;
			}
			
			_mapBlock2D.appendMap("Block", m);
			
			sBlocks.append(name);
			sBlockCats.append(m.getString("Category"));
			sBlockSubCats.append(m.getString("SubCategory"));
			sBlockPaths.append(m.getString("Path"));			 
		}//next j
		
	// rewrite purged map
		if (bRewrite)
			moBlock2D.setMap(_mapBlock2D);
	
	}
	else
	{
		// allow only blocks which are tagged with a blockData instance of instaCell	
		for (int j = 0; j < _BlockNames.length(); j++)
		{
			// exclude anonymous blocks	
			if (_BlockNames[j].left(1) == "*")continue;
			
			Block block(_BlockNames[j]);
			Entity ents[] = block.entity();
			for (int i = 0; i < ents.length(); i++)
			{
				TslInst t = (TslInst)ents[i];
				if (t.bIsValid() && t.scriptName() == (bDebug ? "instaCell" : scriptName()))
				{
					sBlocks.append(_BlockNames[j]);
					sBlockCats.append(t.propString(1));
					sBlockSubCats.append(t.propString(2));
					sBlockPaths.append("");
					
					Map m;
					m.setString("Category", t.propString(1));
					m.setString("SubCategory", t.propString(2));
					m.setString("Path", "");
					m.setMapName(_BlockNames[j]);
					
					mapBlock2D.appendMap("Block", m);
					
					break; //i
				}
			}//next i
		}//next j
	}

// append any block in the block search paths
	// get folder list
	String folders[] ={ sBlockPath};
	String foldersCat[] = getFoldersInFolder(sBlockPath);
	for (int i=0;i<foldersCat.length();i++) 
	{ 
		String folderCat = sBlockPath+"\\"+foldersCat[i];
		folders.append(folderCat);
		String foldersSub[] = getFoldersInFolder(folderCat);
		for (int i=0;i<foldersSub.length();i++) 
		{ 
			String folderSub = folderCat+"\\"+foldersSub[i];
			folders.append(folderSub);	 
		}//next i 
	}//next i
	
	
	// get files from folders
	for (int j=0;j<folders.length();j++) 
	{ 
		String tokens[] = folders[j].tokenize("\\");
		int n = tokens.findNoCase("insta" ,- 1);
		String files[] = getFilesInFolder(folders[j], "*.dwg");
		for (int i=0;i<files.length();i++) 
		{ 
			String file = files[i].left(files[i].length()-4);// remove ".dwg" 
			if (sBlocks.find(file)<0)
			{ 
				sBlocks.append(file);
				
				String category, subCategory, path;
				if (n>-1)
				{ 
					if (tokens.length() > n)category = tokens[n + 1];
					if (tokens.length() > n+1)subCategory = tokens[n + 2];
					
				}
				path = folders[j] + "\\" + files[i];
				
				sBlockCats.append(category);
				sBlockSubCats.append(subCategory);
				sBlockPaths.append(path);
				
				if (!bHasBlock2D)
				{ 
					Map m;
					m.setString("Category", category);
					m.setString("SubCategory", subCategory);
					m.setString("Path", path);
					m.setMapName(file);
	
					mapBlock2D.appendMap("Block", m);						
				}					
			}
		}//next i	
	}

	if (!bHasBlock2D && mapBlock2D.length()>0)
		moBlock2D.dbCreate(mapBlock2D);
//endregion 	
	
	
	
	if(0)
	{ 
		int nTick = getTickCount();
		
	// allow only blocks which are tagged with a blockData instance of instaCell
		
		for (int j=0;j<_BlockNames.length();j++) 
		{ 
		// exclude anonymous blocks	
			if (_BlockNames[j].left(1) == "*")continue;
			
			Block block(_BlockNames[j]);
			Entity ents[] = block.entity();
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i];
				if (t.bIsValid() && t.scriptName() == (bDebug ? "instaCell" : scriptName()))
				{ 
					sBlocks.append(_BlockNames[j]);
					sBlockCats.append(t.propString(1));
					sBlockSubCats.append(t.propString(2));
					sBlockPaths.append("");
					break;
				}
			}//next i				
		}//next j
	
	// append any block in the block search paths
		// get folder list
		String folders[] ={ sBlockPath};
		String foldersCat[] = getFoldersInFolder(sBlockPath);
		for (int i=0;i<foldersCat.length();i++) 
		{ 
			String folderCat = sBlockPath+"\\"+foldersCat[i];
			folders.append(folderCat);
			String foldersSub[] = getFoldersInFolder(folderCat);
			for (int i=0;i<foldersSub.length();i++) 
			{ 
				String folderSub = folderCat+"\\"+foldersSub[i];
				folders.append(folderSub);	 
			}//next i 
		}//next i
		
		
		// get files from folders
		for (int j=0;j<folders.length();j++) 
		{ 
			String tokens[] = folders[j].tokenize("\\");
			int n = tokens.findNoCase("insta" ,- 1);
			String files[] = getFilesInFolder(folders[j], "*.dwg");
			for (int i=0;i<files.length();i++) 
			{ 
				String file = files[i].left(files[i].length()-4);// remove ".dwg" 
				if (sBlocks.find(file)<0)
				{ 
					sBlocks.append(file);
					
					String category, subCategory;
					if (n>-1)
					{ 
						if (tokens.length() > n)category = tokens[n + 1];
						if (tokens.length() > n+1)subCategory = tokens[n + 2];
						
					}
					
					sBlockCats.append(category);
					sBlockSubCats.append(subCategory);
					sBlockPaths.append(folders[j]+"\\"+files[i]);
				}
			}//next i	
		}
		
		reportNotice("\n" + scriptName() + " " + _ThisInst.handle()+ " block took " +(getTickCount()-nTick)+"ms") ;
	}
	
// order alphabetically
	for (int i=0;i<sBlocks.length();i++) 
		for (int j=0;j<sBlocks.length()-1;j++) 
			if (sBlocks[j]>sBlocks[j+1])
			{
				sBlocks.swap(j, j + 1);
				sBlockSubCats.swap(j, j + 1);
				sBlockCats.swap(j, j + 1);
				sBlockPaths.swap(j, j + 1);
			}
	


	
	//sBlocks = sBlocks.sorted();
	sBlocks.insertAt(0, tDisabled);sBlockSubCats.insertAt(0, "");sBlockCats.insertAt(0, "");;sBlockPaths.insertAt(0, "");
	PropString sBlock(0, sBlocks, sBlockName);	
	sBlock.setDescription(T("|Defines the Type|"));
	sBlock.setCategory(category);
	int nBlock = sBlocks.find(sBlock);
	if (nBlock<0) // disable block display
	{ 
		nBlock = 0;
		sBlock.set(sBlocks.first());
	}

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
		
	// prompt for tsls
		Entity ents[0];
		PrEntity ssE(T("|Select combination|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// loop tsls
		TslInst tslCombi;
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst t=(TslInst)ents[i];
			if (t.bIsValid() && t.scriptName().makeUpper() == sInstaCombination)
			{ 
				tslCombi = t;
				break;
			}
		}
			
		if (tslCombi.bIsValid())
		{ 
			_Pt0 = getPoint();
			_Entity.append(tslCombi);

			_GenBeam =tslCombi.genBeam();	
		}
		else
		{
			reportMessage(TN("|Could not find combination|"));
			eraseInstance();
			
		}
		return;
	}	
// end on insert	__________________//endregion

//region Get Combination
	setExecutionLoops(2);
	_ThisInst.setSequenceNumber(10);
	
// get first tslInst from entity
	TslInst tslParent;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		TslInst t = (TslInst)_Entity[i]; 
		if(t.bIsValid() && t.scriptName().makeUpper() == sInstaCombination)
		{
			tslParent = t;
			setDependencyOnEntity(t);
			if (bDebug)reportMessage("\n"+ scriptName() + " "+ _ThisInst.handle() + " depends on " + sInstaCombination + " " + t.handle());
			break;
		}
	}
// validate tsl
	if (!tslParent.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " + T("|no valid tsl found|"));
		eraseInstance();
		return;
	}		
	Map mapParent = tslParent.map();
	int bByCombination = sToolings.findNoCase(tslParent.propString(4) ,- 1) <0;

// register me as child
	Entity cells[] = mapParent.getEntityArray("Cell[]","", "Cell");
	if (cells.find(_ThisInst) < 0)
	{
		cells.append(_ThisInst);
		mapParent.setEntityArray(cells, false, "Cell[]", "", "Cell");
		tslParent.setMap(mapParent);
		//tslParent.transformBy(Vector3d(0, 0, 0));	
		tslParent.recalc();
		setExecutionLoops(2);
	}
//End Get Combination//endregion 
	


	if (!bHasElement && _GenBeam.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
//region Collect genbeam subtypes
	Point3d ptVerticalExtremes[0];
	Body bodies[0]; // cache the bodies
	for (int i=0;i<genbeams.length();i++) 
	{ 
		GenBeam gb = genbeams[i];
		bodies.append(gb.envelopeBody(true, true));
		Sip sip = (Sip)gb;
		Beam beam= (Beam)gb;
		Sheet sheet= (Sheet)gb;
		if (sip.bIsValid())sips.append(sip);
		else if (beam.bIsValid())beams.append(beam);
		else if (sheet.bIsValid())sheets.append(sheet);
		
		ptVerticalExtremes.append(bodies.last().extremeVertices(vecY));
	}//next i
	ptVerticalExtremes = Line(_Pt0, vecY).orderPoints(ptVerticalExtremes, dEps);
	
	
// GenBeam based, get coordSys and main ref if loose
	if (!bHasElement)
	{ 
		if (genbeams.length()<1)
		{ 
			reportNotice(scriptName() + T(" |unexpected error|: ") + T("|No element and no genbeam found.|"));
			eraseInstance();
			return;
		}
		
		
		
		if (ptVerticalExtremes.length() > 0)ptOrg = ptVerticalExtremes.first();
		ptOrg.vis(2);
		
		if (sips.length()>0)
		{ 
			sip = sips.first();
			dZ = sip.dH();
			ptCen = sip.ptCen();
			Vector3d vecXS = sip.vecX();
			Vector3d vecYS = sip.vecY();
			vecZ = sip.vecZ();
			// flattened to XY-World
			if (vecZ.isParallelTo(_ZW) && (vecXS.isParallelTo(_XW) || vecYS.isParallelTo(_XW))) 
				vecX = _XW;	
			// 3D-Model as wall	
			else if (vecZ.isPerpendicularTo(_ZW)) 					
				vecX = _ZW.crossProduct(vecZ);
			else // HSB-14130
				vecX = vecXS;
			vecY = vecX.crossProduct(-vecZ);			
		}
		else
		{ 
			GenBeam gb = genbeams.first();
			vecX = gb.vecX();
			vecY = gb.vecY();
			vecZ = gb.vecZ();
			dZ = gb.solidHeight();
			ptCen = gb.ptCen();
			
		}
		
		assignToGroups(genbeams.first(), 'T');
		if (genbeams.length()==1)setEraseAndCopyWithBeams(_kBeam0);
	}
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);	
//End Collect genbeam subtypes//endregion 


	
//region Import block and set category from folder if not tagged
	if (_kNameLastChangedProp==sBlockName && nBlock>0)	
	{ 
		if (_BlockNames.findNoCase(sBlock,-1)<0 && sBlockPaths.length()>nBlock)
		{ 
			
			String sCategory, sSubCategory,path = sBlockPaths[nBlock];
			Block block(path);
			
			LineSeg seg = block.getExtents();
			Entity ents[] = block.entity();
			//if (bDebug)			reportNotice("\nImporting " + path + " ents " + ents.length());				
			
			TslInst tslBlockData;
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t = (TslInst)ents[i];
				if (t.bIsValid() && t.scriptName()==scriptName())
				{
					tslBlockData = t;
				if (bDebug)reportNotice("\nImport has blockdata");			
					break;
				}
			}//next i
			
			if (!tslBlockData.bIsValid())
			{
				if (bDebug)reportNotice("\nImport has no blockdata");		
			// create TSL
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_PtW};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	mapTsl.setInt("DialogMode",1);
			
				sProps.append(sBlock);
				sProps.append(sBlockCats[nBlock]);
				sProps.append(sBlockSubCats[nBlock]);
				tslBlockData.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				if (bDebug)reportNotice("\nnew blockdata created");
				if (tslBlockData.bIsValid())
					ents.append(tslBlockData);
				int errCode = Block().writeEntitySetIntoDwg(path, ents, _PtW);
				if (errCode != 0)
					reportMessage(TN("|Error code|: ")+errCode);
				else
				{
					Block blockNew(path);
					LineSeg seg = blockNew.getExtents();
					tslParent.transformBy(Vector3d(0,0,0));	
				}
				if (tslBlockData.bIsValid())tslBlockData.dbErase();
			}
			
			setExecutionLoops(2);
			return;
			
		}
	}
	// reset to desabled if not found
	if (_BlockNames.findNoCase(sBlock,-1)<0 && sBlock!=tDisabled)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Setting block to| ") + tDisabled);
		sBlock.set(tDisabled);
		setExecutionLoops(2);
		return;
	}
//End Import block and set category from folder if not tagged//endregion 

//region Events
	if (_kNameLastChangedProp==sToolName)
	{ 
	// auto preset height	
		if ((bIsMortise || bIsBeamcut) && dHeight <= 0)
		{
			dHeight.set(dDiameter);
		}		
		else if ((bIsDrill || bIsOctagon) && dHeight > 0) // drill
		{
			dHeight.set(0);
		}
		else if ((bIsOctagon) && dHeight >= dDiameter) // octagon
		{
			dHeight.set(0);
		}			
	}
	if (bIsMortise || bIsBeamcut && dDiameter != dHeight)
	{
		//SwapWidthHeight
		String sTriggerSwapWidthHeight = T("|Swap Width <-> Height|");
		addRecalcTrigger(_kContextRoot, sTriggerSwapWidthHeight );
		if (_bOnRecalc && _kExecuteKey == sTriggerSwapWidthHeight)
		{
			double d = dHeight;
			dHeight.set(dDiameter);
			dDiameter.set(d);
			setExecutionLoops(2);
			return;
		}
	}
//End Events//endregion 



// get parent coordSys	
	Vector3d vecDir=vecX, vecPerp=vecY, vecFace = vecZ;
	{ 
		Map m = mapParent;
		String k;
		k = "vecDir"; 	if (m.hasVector3d(k)) vecDir = m.getVector3d(k);
		k = "vecPerp"; 	if (m.hasVector3d(k)) vecPerp = m.getVector3d(k);		
		k = "vecFace";	
		if (m.hasVector3d(k)) 
		{
			vecFace = m.getVector3d(k);
			_Pt0 += vecFace * vecFace.dotProduct(tslParent.ptOrg() - _Pt0);
		}
		else if (_Map.hasVector3d(k))
			vecFace = _Map.getVector3d(k); // get initial face direction during creation 
	}
	int nFace = vecFace.isCodirectionalTo(vecZ) ? 1 :- 1;
	
//reportNotice("\nvecFace = " + vecFace  + " nFace " + nFace +"\n"+
//		" vecDir " + vecDir + " vecPerp " + vecPerp + "\nmapP " + mapParent);
//
	vecDir = vecPerp.crossProduct(vecFace);
	CoordSys cs(_Pt0, vecDir, vecPerp, vecFace);

// Display
	int nColor = bByCombination?252:(nFace==1?nColorElementSymbol:nColorElementOpposite);
	Display dpModel(nColor), dpPlan(nColor),dpElement(nColor);
	dpModel.showInDxa(true);
	dpPlan.showInDxa(true);
	
	dpElement.addHideDirection(vecX);
	dpElement.addHideDirection(-vecX);
	dpElement.addHideDirection(vecY);
	dpElement.addHideDirection(-vecY);
	
	dpPlan.addViewDirection(vecY);
	dpPlan.addViewDirection(-vecY);
	
	dpModel.addHideDirection(vecY);
	dpModel.addHideDirection(-vecY);
	
// Tool
	PlaneProfile ppCellShape(cs);
	PlaneProfile ppShape(cs);
	
	Point3d ptStart = _Pt0;
	Point3d ptEnd = _Pt0 - vecFace * dDepth;
	
	PLine plTool(vecZ);
	
//region Drills
	double dRadius;
	PLine plCircle;
	
	if (dDiameter2 > dEps)
	{ 
		dRadius = dDiameter2 * .5;
		Point3d ptEnd2 = ptStart - vecFace * dZ;
		Drill dr(ptStart+vecFace*dEps, ptEnd2-vecFace*dEps, dRadius);
		dr.addMeToGenBeamsIntersect(genbeams);
		//dr.cuttingBody().vis(2);
		plCircle.createCircle(ptStart, vecFace, dRadius);
		plCircle.transformBy(-vecFace * dZ);
		dpModel.draw(plCircle);
		
		PLine pl(ptStart, ptEnd2);
		dpModel.draw(pl);
		dpPlan.draw(pl);
		
	}		
	
	
	if (bIsDrill && dDepth > dEps && dDiameter2<dDiameter)
	{ 		
		dRadius = dDiameter * .5;
		
		plCircle.createCircle(ptStart, vecFace, dRadius);
		ppShape.joinRing(plCircle, _kAdd);
		//dpModel.draw(plCircle);	
		plCircle.convertToLineApprox(dRadius / 20);
		if (!bByCombination)
		{ 
			Drill dr(ptStart+vecFace*dEps, ptEnd, dRadius);
			dr.addMeToGenBeamsIntersect(genbeams);	
			//dr.cuttingBody().vis(2);
		}			
		plCircle.transformBy(-vecFace * dDepth);
		dpModel.draw(plCircle);
		if (!bByCombination)
		{
			Body bd (plCircle, vecFace * dDepth , 1);
			dpModel.draw(bd);
			dpModel.draw(PlaneProfile(plCircle), _kDrawFilled, 90);
			
			dpPlan.draw(bd.shadowProfile(Plane(_Pt0, vecY)));
		}
		
		if (dDiameter2 <=0)
		{
			PLine pl(ptStart, ptEnd);
			dpModel.draw(pl);
			dpPlan.draw(pl);
			
		}

		
		double dXY = dDiameter + 2 * dOffset;
		Vector3d vec = .5 * (vecDir * dXY + vecPerp * dXY);
		ppCellShape.createRectangle(LineSeg(_Pt0-vec,_Pt0+vec), vecDir, vecPerp);	
	}		
	
	
//endregion 

//region Beamcut/Mortise
	else if (bIsMortise || bIsBeamcut) // Mortise Beamcut
	{ 
		double dWidth = dDiameter;
		Vector3d vecXT = -vecX * nFace;
		Vector3d vecYT = vecY;
		Vector3d vecZT = -vecZ * nFace;
		vecZT.vis(ptStart, 2);

		Body bd;
		if (bIsMortise)
		{ 
			Mortise tool(ptStart, vecXT, vecYT, vecZT, dWidth, dHeight, dDepth, 0, 0 ,1 );
			if (dToolRadius>0)
			{
				tool.setRoundType(_kExplicitRadius);
				tool.setExplicitRadius(dToolRadius);
			}
			if (!bByCombination)tool.addMeToGenBeamsIntersect(genbeams);
			bd=tool.cuttingBody(); //bd.vis(3);			
		}
		else if (bIsBeamcut)
		{ 
			BeamCut tool(ptStart, vecXT, vecYT, vecZT, dWidth, dHeight, 2*dDepth, 0, 0 ,0 );
			if (!bByCombination)tool.addMeToGenBeamsIntersect(genbeams);
			bd=tool.cuttingBody();// bd.vis(4);			
		}
		
		Vector3d vecCell = vecXT * (.5*dWidth +  dOffset)+vecYT * (.5*dHeight +  dOffset);	
		ppCellShape.createRectangle(LineSeg(ptStart-vecCell,ptStart+vecCell), vecDir, vecPerp);
		ppShape.unionWith(bd.shadowProfile(Plane(_Pt0,vecZT)));

	// set CNC tool shape for element tools HSB-13203
		PLine plTools[] = ppShape.allRings(true, false);
		if (plTools.length() > 0)
		{
			plTool = plTools.first();
			if (!plTool.coordSys().vecZ().isCodirectionalTo(vecZ))
				plTool.flipNormal();
		}
		
		
		
		ppShape.vis(211);
	}		
//endregion 
	
//region Octagon 
	else if (bIsOctagon) // added HSB-12638
	{ 	
		Vector3d vecZT = -vecZ * nFace;
		
		double r = dDiameter * .5;
		double a = dHeight<=0 || dHeight>=dDiameter?r * tan(22.5):dHeight*.5;
		Vector3d vecs[] ={ -vecX, vecY, vecX, - vecY};
		for (int i=0;i<vecs.length();i++) 
		{ 
			Vector3d vecA = vecs[i];
			Vector3d vecB = vecA.crossProduct(-vecZ);
			plTool.addVertex(ptStart + vecA * r + vecB * a);
			plTool.addVertex(ptStart + vecA * r - vecB * a);
			
			 
		}//next i
		plTool.close();
		plTool.vis(4);vecZT.vis(_Pt0, 3);

		FreeProfile tool(plTool,_kRight);
		tool.setDepth(dDepth);
		tool.setMachinePathOnly(false);		
		if (!bByCombination)
		{
			tool.cuttingBody().vis(4);
			tool.addMeToGenBeamsIntersect(genbeams);
		}

		double dXY = dDiameter + 2 * dOffset;
		Vector3d vec = .5 * (vecDir * dXY + vecPerp * dXY);
		ppCellShape.createRectangle(LineSeg(_Pt0-vec,_Pt0+vec), vecDir, vecPerp);
		ppShape.joinRing(plTool, _kAdd);
	
		//ppShape.vis(211);
	}	
	
// draw shape and half shape to indicate face in element view
	dpModel.draw(ppShape);
	if (!bByCombination)
	{
		dpModel.draw(ppShape, _kDrawFilled, 90);	
		
		if (!bByCombination && !bIsDrill)
		{
			dpModel.draw(Body(plTool, vecFace * dDepth ,-1));
		}
		
		
	}
	{ 	
		int c = nFace == 1 ? nColorElementSymbol : nColorElementOpposite;
		if (c >256)dpModel.trueColor(c);
		else dpModel.color(c);
		PlaneProfile pp; pp.createRectangle(ppShape.extentInDir(vecX), vecX, vecY);
		pp.transformBy(nFace * .5 * vecY * pp.dY());
		pp.intersectWith(ppShape);
		dpModel.draw(pp, _kDrawFilled, 30);	
		
	}		
	
	
	
	
//endregion 

//region Element Tools
	if (bAddElementTool && !bByCombination)
	{
		double dHTotal;
		int nOuterZone;
		for (int i=0;i<5;i++) 
		{ 
			int nZone = nFace * (i + 1);
			ElemZone zone = el.zone(nZone);
			double dH = zone.dH();
			
			if (dH>dEps)
			{ 
				nOuterZone = nZone;
				dHTotal += dH;
//				ElemNoNail nn(nZone, plNN);
//				el.addTool(nn);
			}			 
		}//next i			
	
	// Drill
		if (bIsDrill)
		{ 
			double dToolDepth = dHTotal;
			ElemDrill tool(nOuterZone, ptStart, -vecFace,  dToolDepth, dDiameter, nToolIndex);
			el.addTool(tool);			
		}
		
	// Milling Line	
		else if(bIsOctagon ||bIsMortise || bIsBeamcut)
		{ 
			double dToolDepth = dHTotal;
			ElemMill tool(nOuterZone, plTool, dToolDepth, nToolIndex, nOuterZone<0?_kRight:_kLeft, _kCCWise, _kNoOverShoot);
			el.addTool(tool);			
		}
		assignToElementGroup(el, true, nOuterZone, nOuterZone==0?'Z':'E');
	}
	else if (bHasElement)	
		assignToElementGroup(el, true, 0, 'Z');

//endregion 


//region Custom Dimrequest
	Map mapRequests;
	if (!bByCombination)
	{ 	
		LineSeg seg = ppCellShape.extentInDir(vecDir);
		Point3d pts[] = { seg.ptStart(),seg.ptEnd()};
		
		Map m;
		m.setVector3d("vecDimLineDir", vecDir);
		m.setVector3d("vecPerpDimLineDir", vecPerp);
		m.setVector3d("AllowedView", vecFace);
		m.setPoint3dArray("Node[]",pts);
		m.setString("Stereotype", _ThisInst.scriptName());
		m.setEntity("ParentEnt", _ThisInst);
		m.setInt("AlsoReverseDirection", true);
		mapRequests.appendMap("DimRequest", m);			
		m.setVector3d("vecDimLineDir", vecPerp);
		m.setVector3d("vecPerpDimLineDir", - vecDir);
		mapRequests.appendMap("DimRequest", m);	
	}
	{ 
		Map mapX; 
		mapX.setMap("DimRequest[]", mapRequests);
		_ThisInst.setSubMapX("Hsb_DimensionInfo", mapX);		
	}
//End Custom Dimrequest//endregion 


	//dpModel.draw(ppShape);
	_Map.setPlaneProfile("ShapeBox", ppCellShape);
	_Map.setPlaneProfile("Shape", ppShape);

//region Block Element View Display and Hardware
	if (nBlock > 0)
	{ 
		Block block(sBlocks[nBlock]);
		LineSeg seg = block.getExtents();
		double dX = abs(_XW.dotProduct(seg.ptEnd() - seg.ptStart()));
		double dY = abs(_YW.dotProduct(seg.ptEnd() - seg.ptStart()));
		double dMax = (dX < dY ? dY : dX) * 1.1; dMax = dMax <= 0 ? 1 : dMax;
		double scale = dTextHeightElement / dMax * dScaleElement;	
		
		Vector3d vecSide = nFace * vecPerp * .5* (ppCellShape.dY()+dMax*scale);

		Point3d pt = _Pt0 - vecSide;

		dpElement.draw(block, pt, vecX*scale, vecY*scale, vecZ*scale);	

	//region Get and set hardware of block definition
		Entity ents[] = block.entity();
		HardWrComp hwcsBlock[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i];
			if (t.bIsValid() && t.scriptName()==scriptName())
			{ 
				hwcsBlock = t.hardWrComps();
				break;
			}
		}//next i	
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		for (int i=hwcs.length()-1; i>=0 ; i--) if (hwcs[i].repType() == _kRTTsl)	hwcs.removeAt(i); 
		String sHWGroupName;	// declare the groupname of the hardware components
		Group groups[] = _ThisInst.groups();
		if (el.bIsValid())sHWGroupName = el.elementGroup().name();
		else if (groups.length())sHWGroupName = groups[0].name();
	
		for (int i=0;i<hwcsBlock.length();i++) 
		{ 
			hwcsBlock[i].setRepType(_kRTTsl); 
			hwcs.append(hwcsBlock[i]); 
		}//next i
		for (int i=0;i<hwcs.length();i++) 
			hwcs[i].setGroup(sHWGroupName);

		_ThisInst.setHardWrComps(hwcs);				
	//End Get and set hardware of block definition//endregion 
		
	}
//End Block Display and Hardware//endregion 

// Trigger ShowHideTool
	int bShowElementTool = _Map.hasInt("ShowElementTool")?_Map.getInt("ShowElementTool"):true;
	String sTriggerShowHideTool =bShowElementTool?T("|Hide Tools|"):T("|Show Tools|");
	addRecalcTrigger(_kContextRoot, sTriggerShowHideTool);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowHideTool)
	{
		bShowElementTool = bShowElementTool ? false : true;
		_Map.setInt("ShowElementTool", bShowElementTool);		
		setExecutionLoops(2);
		return;
	}
	_ThisInst.setShowElementTools(bShowElementTool);


//End Trigger//endregion 


//reportMessage("\n"+ scriptName() + " end " + _ThisInst.handle() + " tick:" +getTickCount());

//region Write DWG Trigger
{
	
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };


//region Trigger AddRule
	String sTriggerAddBlock= T("|Set block definition|");
	addRecalcTrigger(_kContextRoot, sTriggerAddBlock );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddBlock)
	{
		BlockRef bref = getBlockRef(T("|Select block reference|"));	
		Map mapCell = mapSetting.getMap("Cell");	

		String sDefinition = bref.definition();
		String sCategory, sSubCategory;
		
		mapTsl.setInt("DialogMode",1);
		sProps.append(sDefinition);
		ptsTsl[0] = _PtW;
//		sProps.append(sCat);
//		sProps.append(sSubCat);
//
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				String sNewDefinition= tslDialog.propString(0);		
				if (sNewDefinition.length()<1)
					sNewDefinition = sDefinition;
				sCategory = tslDialog.propString(1);
				sSubCategory = tslDialog.propString(2);
				
				String path = sBlockPath;
		
			// validate block subfolder
				String folders[] = getFoldersInFolder(_kPathHsbCompany + "\\Block");
				if (folders.findNoCase("insta" ,- 1) < 0)
					makeFolder(_kPathHsbCompany + "\\Block\\insta");
				
			// check category folder
				folders = getFoldersInFolder(path);
				if (folders.findNoCase(sCategory ,- 1) < 0)
					makeFolder(path + "\\" + sCategory);
				if (sCategory.length()>0)path+="\\"+sCategory;	
					
			 // check sub category folder
				folders = getFoldersInFolder(path+"\\"+sCategory);
				if (folders.findNoCase(sSubCategory,-1)<0)
					makeFolder(path + "\\" + sSubCategory);					
				if (sSubCategory.length()>0)path+="\\"+sSubCategory;	
	
			// get all entities of the block	
				Block block(sDefinition);
				Entity ents[] = block.entity();
				TslInst tslBlockData;
				for (int i=0;i<ents.length();i++) 
				{ 
					TslInst t = (TslInst)ents[i];
					if (t.bIsValid() && t.scriptName()==scriptName())
						tslBlockData = t;
				}//next i
				
			// add a new BlockData tsl to the block entities					
				if (!tslBlockData.bIsValid())
				{
					tslDialog.setHardWrComps(_ThisInst.hardWrComps());
					//ents.append(tslDialog);
					block.addEntity(tslDialog);
				}
				
				
			// in case name has changed copy and rename block definition			
			// append the new definition as file name
				path+="\\"+sNewDefinition+".dwg";			
				if (sNewDefinition!=sDefinition)
				{ 
					//reportNotice("\nnew block: " + sDefinition + " vs " + sNewDefinition);
					Block blockNew(sDefinition);
					blockNew.dbRename(sNewDefinition);
					block = blockNew;
				}
				
				int errCode = block.writeToDwg(path);//HSB-14039 writeToDwg creates block def at _PtW vs writeEntitySetIntoDwg(path, ents, _PtW) uses current UCS
				if (errCode != 0)
					reportMessage(TN("|Error code|: ")+errCode);
				else
				{
				// add to block cache
					int bAdd = true;
					for (int i=0;i<mapBlock2D.length();i++) 
					{ 
						Map m = mapBlock2D.getMap(i);
						String name = m.getMapName().makeLower();
						
						if (name==sNewDefinition.makeLower())
						{ 
							bAdd = false;
							break;
						}	 
					}//next i
					if (bAdd)
					{ 
						Map m;
						m.setString("Category", sCategory);
						m.setString("SubCategory", sSubCategory);
						m.setString("Path", path);
						m.setMapName(sBlock);
		
						mapBlock2D.appendMap("Block", m);	
						if (bHasBlock2D)
							moBlock2D.setMap(mapBlock2D);
						else
							moBlock2D.dbCreate(mapBlock2D);
						
					}
					sBlock.set(sNewDefinition);
					tslParent.transformBy(Vector3d(0,0,0));	
				}
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;			
	}
	//endregion	

//region Trigger SetExportData
	String sTriggerSetExportData = T("|Store hardware in block definition|");
	if (sBlock != tDisabled)addRecalcTrigger(_kContextRoot, sTriggerSetExportData );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetExportData)
	{
		
		HardWrComp hwcs[] = HardWrComp().showDialog(_ThisInst.hardWrComps());
		_ThisInst.setHardWrComps(hwcs);
		
	// get entities of block and find potential block data tsl instance	
		String sDefinition = sBlock,sCategory, sSubCategory;
		Block block(sDefinition);
		Entity ents[] = block.entity();
		TslInst tslBlockData;
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t = (TslInst)ents[i];
			if (t.bIsValid() && t.scriptName()==scriptName())
			{
				//reportNotice(TN("|tslBlockData tsl found in block|"));
				tslBlockData = t;
				sCategory = tslBlockData.propString(1);
				sSubCategory = tslBlockData.propString(2);				
				break;
			}
		}//next i
		
	// no block data found in block entities, create one and append to block
		int bAddBlockData;
		if (!tslBlockData.bIsValid())
		{ 
			mapTsl.setInt("DialogMode",1);
			sProps.append(sBlock);
			sProps.append(T("|Electra|"));
			sProps.append(T("|Switches|"));	//
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		
			if (tslDialog.bIsValid())
			{
				ents.append(tslDialog);
				tslBlockData = tslDialog;
				bAddBlockData = true;
			}
		}

	// write entities to dwg
		if (tslBlockData.bIsValid())
		{ 
			
			int bOk = tslBlockData.showDialog();
			if (bOk)
			{
				// clone hardware from current instance to block data instance
				HardWrComp hwcs[]= _ThisInst.hardWrComps();
	
			// make sure all hardware is tagged as tsl driven type
				for (int i = 0; i < hwcs.length(); i++)hwcs[i].setRepType(_kRTTsl);
					_ThisInst.setHardWrComps(hwcs);
				
				for (int i = 0; i < hwcs.length(); i++)hwcs[i].setGroup("");
				tslBlockData.setHardWrComps(hwcs);
				
				String sNewDefinition = tslBlockData.propString(0);
				sCategory = tslBlockData.propString(1);
				sSubCategory = tslBlockData.propString(2);

				String path = sBlockPath;
				
				// validate block subfolder
				String folders[] = getFoldersInFolder(_kPathHsbCompany + "\\Block");
				if (folders.findNoCase("insta" ,- 1) < 0)
					makeFolder(_kPathHsbCompany + "\\Block\\insta");
				
				// check category folder
				folders = getFoldersInFolder(path);
				if (folders.findNoCase(sCategory ,- 1) < 0)
					makeFolder(path + "\\" + sCategory);
				if (sCategory.length() > 0)path += "\\" + sCategory;
				
				// check sub category folder
				folders = getFoldersInFolder(path + "\\" + sCategory);
				if (folders.findNoCase(sSubCategory ,- 1) < 0)
					makeFolder(path + "\\" + sSubCategory);
				if (sSubCategory.length() > 0)path += "\\" + sSubCategory;
				
				// append the new definition as file name
				path += "\\" + sNewDefinition + ".dwg";
				if (sNewDefinition!=sDefinition)
				{ 
					//reportNotice("\nnew block: " + sDefinition + " vs " + sNewDefinition);
					Block blockNew(sDefinition);
					blockNew.dbRename(sNewDefinition);
					block = blockNew;
				}
				if (bAddBlockData)
					block.addEntity(tslBlockData);
	
				// write file
				int errCode =  block.writeToDwg(path);//HSB-14039 writeToDwg creates block def at _PtW vs Block().writeEntitySetIntoDwg(path, ents, _PtW);
				
				if (errCode != 0)
					reportMessage(TN("|Error code| A: ") + errCode);
				else
				{ 
					tslParent.transformBy(Vector3d(0, 0, 0));
					
				// find all cells with the same block and update
					ents = Group().collectEntities(true, TslInst(), _kModelSpace);
					for (int i=0;i<ents.length();i++) 
					{ 
						TslInst t= (TslInst)ents[i]; 
						if (t.bIsValid() && t.scriptName()==scriptName() && t.propString(sBlockName) == sBlock)
							t.transformBy(Vector3d(0, 0, 0));						 
					}//next i
				}
			}
		}
		if (tslDialog.bIsValid())
			tslDialog.dbErase();	

		setExecutionLoops(2);
		return;
	}//endregion	




// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCell")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Tools|") (_TM "|Select tools|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Tools|") (_TM "|Select tools|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Width <-> Height|") (_TM "|Select cell|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set block definition|") (_TM "|Select cell|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Store hardware in block definition|") (_TM "|Select cell|"))) TSLCONTENT



//	HSB-16089
//region Trigger PrintAllCommands
	String sTriggerPrintCommand2 = T("|Show all Commands for UI Creation|");
	addRecalcTrigger(_kContext, sTriggerPrintCommand2 );
	if (_bOnRecalc && _kExecuteKey==sTriggerPrintCommand2)
	{
		String text = TN("|You can create a toolbutton, a palette or a ribbon command using one of the following commands.|")+
			TN("|Copy the corresponding line starting with ^C^C below into the command property of the button definition|");	
		
		String command;
		
		command += TN("|Command to insert a new instance of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"instaCell\")) TSLCONTENT";
		
		command += TN("\n|Command to insert a new instance of the tool with no dialog using an existing catalog entry, i.e. 'ABC123'|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"instaCell\" \"ABC123\")) TSLCONTENT";

		command += TN("\n|Command to specify a block definition|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Set block definition|\") (_TM \"|Select cell|\"))) TSLCONTENT";
		
		command += TN("\n|Command to store hardare in an existing block definition|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Store hardware in block definition|\") (_TM \"|Select cell|\"))) TSLCONTENT";

		command += TN("\n|Command to swap width and height (mortise or beamcut tool only)|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Swap Width <-> Height|\") (_TM \"|Select cell|\"))) TSLCONTENT";
		
		command += TN("\n|Command to hide potential CNC tools|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Hide Tools|\") (_TM \"|Select cell|\"))) TSLCONTENT";
		
		command += TN("\n|Command to show potential CNC tools|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Show Tools|\") (_TM \"|Select cell|\"))) TSLCONTENT";

		reportNotice(text +"\n\n"+ command);		
		setExecutionLoops(2);
		return;
	}//endregion



}


//endregion	




//if(bDebug)reportMessage("\n"+ scriptName() + " ending " + _ThisInst.handle() + + " tick:" +getTickCount());





















#End
#BeginThumbnail
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
CG?>][WWOQ1=?C&I5V?\'M?MGT;W&EUH`````245.1*Y"8((`





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
        <int nm="BreakPoint" vl="1179" />
        <int nm="BreakPoint" vl="1037" />
        <int nm="BreakPoint" vl="571" />
        <int nm="BreakPoint" vl="413" />
        <int nm="BreakPoint" vl="298" />
        <int nm="BreakPoint" vl="1076" />
        <int nm="BreakPoint" vl="1034" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20506 layer assignment on zone 0 = Z-Layer" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/17/2024 5:09:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16092 tool update on copy adn move improved" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/14/2022 2:56:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16089 new command to list all available commands in report dialog" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/6/2022 10:36:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16903 storing hardware against a block only available on instances with a valid block selected" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/29/2022 9:51:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14130 bugfix selection loose genbeams" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/13/2021 3:26:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14039 block assignment independent from current UCS" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/7/2021 8:52:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13202 uses default hardware dialog to add/edit/remove entries" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/6/2021 9:27:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13202 new command to hide/show tools, block management improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/2/2021 4:58:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13729 new solid display of drill tools" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/1/2021 5:22:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13446 face indicated by half circle display" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/8/2021 9:36:33 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13203 element tools supported if elmenet is of type stickframe wall or roof element" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/29/2021 5:10:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13129 performance enhancements if dwg contains many blocks, block definitions cached in mapObject" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/17/2021 11:35:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13129 conduit supports rule based insertion" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/16/2021 5:05:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12638 new shape 'octagon' added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/20/2021 10:04:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12621 (3) additional group assignment supported" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="7/20/2021 8:49:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12641 mortsie and beamcut tools display outline when in byCombination mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="7/20/2021 8:43:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12286 uniform block scaling, HSB-12284 new properties to support different tools: drill, mortise and beamcut" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/25/2021 11:34:33 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12298 bugfix default insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/18/2021 11:25:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11286 bugfix path location of non imported blocks" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/29/2021 4:15:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11329 bugfix default display" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/26/2021 9:52:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11329 hardware added to block definition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/25/2021 5:17:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11286 custom block definition and display added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/21/2021 5:43:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10793 element support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/15/2021 5:07:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="1HSB-11022 drill tolerances added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/2/2021 5:05:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="1.0 17.02.2021 HSB-10758 initial version , Author Thorsten Huck" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/17/2021 4:57:21 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End