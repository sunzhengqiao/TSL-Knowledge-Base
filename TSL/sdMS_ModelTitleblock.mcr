#Version 8
#BeginDescription
version value="1.1" date="06aug2019" author="thorsten.huck@hsbcad.com"
error reporting enhanced

This tsl requires an instance 'sd_ViewDataExporter' in the block definition of the multipage.
The insertion is typically done by this instance but could also be inserted manually in model.
Select multipage, select properties or catalog entry and press OK

This tsl displays the properties of an object which are defined by the tsl sd_PropertySetDisplay
within the defining view block. 
In contradiction to standard definitions of multipages this allows an instant update of the 
properties to be displayed without the necessity to regenerate the multipage.
The display mode of the pplace holders 'sd_PropertySetDisplay' should be set to 'Model Title Block'.

An instance 'sd_ViewDataExporter' in the block definition of the multipage is mandatory
It is also requiered to have a block reference with place holders of 'sd_PropertySetDisplay' which are set to mode
'Model Title Block'.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Shopdrawing,Titleblock;Schriftkopf;Model;ETZ
#BeginContents
/// <History>//region
/// <version value="1.1" date="06aug2019" author="thorsten.huck@hsbcad.com"> error reporting enhanced </version>
/// <version value="1.0" date="10nov2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// The insertion is typically done by this instance but could also be inserted manually in model.
/// Select multipage, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl displays the properties of an object which are defined by the tsl sd_PropertySetDisplay
/// within the defining view block. 
/// In contradiction to standard definitions of multipages this allows an instant update of the 
/// properties to be displayed without the necessity to regenerate the multipage.
/// </summary>//endregion

/// <remark Lang=en>
/// This tsl requires an instance 'sd_ViewDataExporter' in the block definition of the multipage.
/// It also requieres a block reference with place holders of 'sd_PropertySetDisplay' which are set to mode
/// 'Model Title Block'.
/// </remark>

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

	String sDisplayModeName=T("|Mode|");	

	String sBlockName=T("|Block|");	
	PropString sBlock(nStringIndex++, _BlockNames, sBlockName);	
	sBlock.setDescription(T("|Defines the Block|"));
	sBlock.setCategory(category);

	String sDisplayModes[] ={ T("|Multipage|"), T("|Model Title Block|")};
	
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
		
	// SelectMultipage
		Entity ent = getEntity(T("|Select multipage|"));

		
	// get potential multipage as the entCollector
		if (ent.bIsValid() && ent.typeDxfName()=="HSBCAD_MULTIPAGE")
			_Entity.append(ent);
		else
			eraseInstance();
		return;		
	}	
// end on insert	__________________
	
// // Viewport Data: declare the view data, later passed in through the entCollector
	ViewData viewDatas[0];

	
	if (_Entity.length()<1)
	{
		_ThisInst.transformBy(Vector3d(0,0,0));
		setExecutionLoops(2);
		return;
	}


// validate
	Entity entCollector;
	if (_Entity.length()<1 || _Entity[0].typeDxfName()!="HSBCAD_MULTIPAGE")
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|could not get multipage.|") + ":  " + _Entity);
		eraseInstance();
		return;
	}
	else
	{
		entCollector = _Entity[0];
		setDependencyOnEntity(entCollector);
	}	

// get coordSys from entCollector
	CoordSys csEntCollector = entCollector.coordSys();	
	_Pt0 = csEntCollector.ptOrg();
	
// get view data from the entColllector
	Map mapShopdrawData=entCollector.subMapX("mpShopdrawData");
	Map mapViewData = mapShopdrawData.getMap(_kOnGenerateShopDrawing + "\\ViewData[]");
	viewDatas = ViewData().convertFromSubMap( mapShopdrawData, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 2); 

// get defining entity from first view
	Entity entDefines[0];
	for (int i=0;i<viewDatas.length();i++) 
	{ 
		ViewData viewData = viewDatas[i];
		Entity ents[] = viewData.showSetDefineEntities();
		if (ents.length()>0)
		{ 
			entDefines = ents;
			break;
		}
	}
	if(bDebug)reportMessage("\n"+ scriptName() + " " + entDefines.length() + " defining entities " + entDefines);
	
	
// store defining entities in map	
	Map mapEntities;
	for (int e=0;e<entDefines.length();e++) 
	{ 	
		Entity ent = entDefines[e];
		_Entity.append(ent);
		setDependencyOnEntity(ent);
		mapEntities.appendEntity("Entity", entDefines[e]);	 
	}

// counter of detected instances
	int nCnt;

// collect block contents
	Block block(sBlock);
	CoordSys csBlock;
	csBlock.setToTranslation(_Pt0 - _PtW);
	LineSeg seg = block.getExtents();
	seg.vis(6);

	TslInst tsls[] = block.tslInst();
	int bReportWarning;
// loop tls to draw by mapIO
	for (int i=0;i<tsls.length();i++) 
	{ 
		TslInst tsl = tsls[i];
		
		String scriptName = tsl.scriptName().makeUpper();
		
		if ("sd_PropertySetDisplay".makeUpper()==scriptName)
		{ 	
		// test display mode and do not display if in multipage mode
			Map map = tsl.map();
			int nDisplayMode;
			if (map.hasInt("DisplayMode")) nDisplayMode = map.getInt("DisplayMode");
			else if (tsl.hasPropString(9))
			{ 
				int _nDisplayMode = sDisplayModes.find(tsl.propString(9));
				if (_nDisplayMode<0)
				{
					bReportWarning = true;
					nDisplayMode = 0;
				}
				else
					nDisplayMode = _nDisplayMode;
			}
			
			if (nDisplayMode<1)
			{ 
				continue;
			}

			Map mapIO;
			mapIO.setMap("Entity[]",mapEntities);
			mapIO.setInt("debug", bDebug);
		// get properties
			Map mapProperties = tsl.mapWithPropValues();
			
		// report properties
			if(0 && bDebug)
			{
				reportMessage("\n	Properties of " + tsl.scriptName() + tsl.handle());
				for (int k=0;k<mapProperties.length();k++)
				{ 
					Map m = mapProperties.getMap(k);
					for (int p=0;p<m.length();p++)
					{ 
						Map m2 = m.getMap(p);
						for (int j=0;j<m2.length();j++) 
						{ 
							String k = m2.keyAt(j);
							String v;
							if (m2.hasString(j)) v = m2.getString(j);
							else if (m2.hasDouble(j)) v = m2.getDouble(j);
							else if (m2.hasInt(j)) v = m2.getInt(j);
							reportMessage("\n		" + k + ": " + v); 
						}
					}	
				}
			}
			
			mapIO.setMap("Properties", mapProperties);
			TslInst().callMapIO(scriptName, mapIO);
			
		// draw by mapIO
			Display dp(tsl.hasPropInt(0)?tsl.propInt(0):0);//T("|Color|")));
			double dTxtH = tsl.propDouble(0)?tsl.propDouble(0):U(100);
			if (tsl.hasPropString(0))
				dp.dimStyle(tsl.propString(0));//T("|Dimstyle|")));
			dp.textHeight(dTxtH);//T("|Text Height|")));
			nCnt++;// increment the counter
		// loop lines
			for (int j=0;j<mapIO.length();j++) 
			{ 
				Map m = mapIO.getMap(j); 
				Point3d ptTxt = tsl.ptOrg();//m.getPoint3d("ptTxt");
				//ptTxt.vis(5);tsl.ptOrg().vis(6);
				ptTxt.transformBy(csBlock);
				ptTxt.setZ(0);
				if (bDebug)dp.draw(PLine(_Pt0,ptTxt));
				double dXFlag = m.getDouble("dXFlag");
				double dYFlag = m.getDouble("dYFlag");
				String sTxt = m.getString("Text");
				dp.draw(sTxt, ptTxt, _XE, _YE, dXFlag, dYFlag);
			}
		}	
	}
	
	
// report warning 
	if (bReportWarning)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|the requested value could not be found.|") + T(" |Please edit block definition of shopdrawing and recalculate the defining tsls.|"));
		
	}
	
// check if this is drawing anything at all
	if (nCnt<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|No references of PropertySetDisplay placeholders are found in the defining block|") + " " + sBlock + "." + 
		TN("|Are you referring to the correct block reference or does the block not contain placeholders set to title block mode?|"));
		if (!bDebug)eraseInstance();
		return;
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="156" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End