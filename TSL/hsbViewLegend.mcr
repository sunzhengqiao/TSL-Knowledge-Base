#Version 8
#BeginDescription
1.1 24.03.2021 HSB-11326: fix hatch representation Author: Marsel Nakuci
version value="1.0" date="07jan21" author="marsel.nakuci@hsbcad.com"

HSB-10159: initial

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Legend,Hatch
#BeginContents
/// <History>//region
// #Versions:
// Version 1.1 24.03.2021 HSB-11326: fix hatch representation Author: Marsel Nakuci
/// <version value="1.0" date="07jan21" author="marsel.nakuci@hsbcad.com"> HSB-10159: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a display object that shows the legend for the applied hatches in model space, layout space or shopdraw space
/// In model space the tsl prompts the selection of the section cut
/// In layout (paper) space the tsl prompts the selection of the viewport
/// In shopdraw the tsl prompts the selection of a viewport in the shopdrawing
/// TSL will show all hatches from hsbViewHatch TSLs
///
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewLegend")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Hatch||") (_TM "|Select hsbViewLegend TSL|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Hatch||") (_TM "|Select hsbViewLegend TSL|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Erase All Custom Hatches||") (_TM "|Select hsbViewLegend TSL|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Symbol||") (_TM "|Select hsbViewLegend TSL|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Symbol||") (_TM "|Select hsbViewLegend TSL|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove All Symbols||") (_TM "|Select hsbViewLegend TSL|"))) TSLCONTENT
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
	int iDialogMode = _Map.getInt("DialogMode");
	if(iDialogMode==1)
	{ 
		setOPMKey("CustomHatchAdd");
		String sMaterialName=T("|Material|");	
		PropString sMaterial(nStringIndex++, "", sMaterialName);	
		sMaterial.setDescription(T("|Defines the Material|"));
		sMaterial.setCategory(category);
		
		category=T("|Solid Hatch|");
		String sColorName=T("|Color|");	
		int nColors[]={1,2,3};
		PropInt nColor(nIntIndex++, 1, sColorName);	
		nColor.setDescription(T("|Defines the Color|"));
		nColor.setCategory(category);
		
		String sTransparencyName=T("|Transparency|");	
		int nTransparencys[]={1,2,3};
		PropInt nTransparency(nIntIndex++, 0, sTransparencyName);	
		nTransparency.setDescription(T("|Defines the Transparency|"));
		nTransparency.setCategory(category);
		
		category=T("|Pattern Hatch|");
		String sPatternName=T("|Pattern|");	
		PropString sPattern(nStringIndex++, _HatchPatterns, sPatternName);	
		sPattern.setDescription(T("|Defines the Pattern|"));
		sPattern.setCategory(category);
		
		String sScaleName=T("|Scale|");	
		PropDouble dScale(nDoubleIndex++, U(0), sScaleName);	
		dScale.setDescription(T("|Defines the Scale|"));
		dScale.setCategory(category);
		
		String sAngleName=T("|Angle|");	
		PropDouble dAngle(nDoubleIndex++, U(0), sAngleName);	
		dAngle.setDescription(T("|Defines the Angle|"));
		dAngle.setCategory(category);
		return;
	}
	
	if(iDialogMode==2)
	{ 
		// get custom hatches
		Map mapHatchesCustom = _Map.getMap("mapHatchesCustom");
		if(mapHatchesCustom.length()==0)
		{ 
			reportMessage(TN("|unexpected, no custom Hatch definition found|"));
			eraseInstance();
			return;
		}
		
		String sMaterials[0];
		for (int i=0;i<mapHatchesCustom.length();i++) 
		{ 
			Map mapI = mapHatchesCustom.getMap(i);
			sMaterials.append(i+"_"+mapI.getString("sMaterial"));
		}//next i
		
		
		setOPMKey("CustomHatchRemove");
		String sMaterialName=T("|Material|");	
		PropString sMaterial(nStringIndex++, sMaterials, sMaterialName);	
		sMaterial.setDescription(T("|Defines the Material|"));
		sMaterial.setCategory(category);
		return;
	}
	
	if(iDialogMode==3)
	{ 
		// properties for a symbol
		Map mapSymbols = _Map.getMap("mapSymbols");
		
		setOPMKey("SymbolAdd");
		String sSymbolNameName=T("|Symbol Name|");	
		PropString sSymbolName(nStringIndex++, "TXT", sSymbolNameName);	
		sSymbolName.setDescription(T("|Defines the SymbolName|"));
		sSymbolName.setCategory(category);
		
		String sSymbolColorName=T("|Symbol Color|");	
		int nSymbolColors[]={1,2,3};
		PropInt nSymbolColor(nIntIndex++, 0, sSymbolColorName);	
		nSymbolColor.setDescription(T("|Defines the SymbolColor|"));
		nSymbolColor.setCategory(category);
		
		return;
	}
	if(iDialogMode==4)
	{ 
		// get custom hatches
		Map mapSymbols = _Map.getMap("mapSymbols");
		if(mapSymbols.length()==0)
		{ 
			reportMessage(TN("|unexpected, no custom Hatch definition found|"));
			eraseInstance();
			return;
		}
		
		
		String sSymbolNames[0];
		for (int i=0;i<mapSymbols.length();i++) 
		{ 
			Map mapI = mapSymbols.getMap(i);
			sSymbolNames.append(i+"_"+mapI.getString("sSymbolName"));
		}//next i
		
		String sSymbolNameName=T("|Symbol Name|");	
		PropString sSymbolName(nStringIndex++, sSymbolNames, sSymbolNameName);	
		sSymbolName.setDescription(T("|Defines the Symbol Name|"));
		sSymbolName.setCategory(category);
		setOPMKey("SymbolRemove");
		return;
	}
	
	String sTextHeightName=T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);
	// nr columns
	String sColumnsName=T("|Columns|");
	int nColumnss[]={1,2,3};
	PropInt nColumns(nIntIndex++, 1, sColumnsName);	
	nColumns.setDescription(T("|Defines the nr of Columns of the Legend. Must be a positiv number|"));
	nColumns.setCategory(category);
	// column sizes
	String sColSizesName=T("|Column Sizes|");	
	PropString sColSizes(nStringIndex++, "", sColSizesName);	
	sColSizes.setDescription(T("|Defines the Column Sizes. Entries are numbers and can be separated by a semicolon ;|"));
	sColSizes.setCategory(category);
//End Properties//endregion 
	
// bOnInsert//region
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
		
	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();
//		int bInPaperSpace = Viewport().inPaperSpace();
		
	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		if (!bInLayoutTab)
		{
			// not in layout tab, collect shopdrawView entities
			viewEnts = Group().collectEntities(true, ShopDrawView(), _kMySpace);
		}
		
	// distinguish selection mode bySpace
		if (viewEnts.length() > 0)
		{ 
			// we are inside the block definition of
			// shop draw with shopdraw views. Prompt for selecting shopdraw views shows up
			// prompt selection of a shop draw view
			_Entity.append(getShopDrawView());
			
			// prompt selection of an insertion point
			_Pt0 = getPoint(T("|Pick insertion point|"));
		}
		
	// switch to paperspace succeeded: paperspace with viewports
		if (_Entity.length() < 1)
		{ 
			// no shopdrawview was found -> we are in layout or model space
			if (bInLayoutTab)
			{
				// in layout tab, select viewport
				_Viewport.append(getViewport(T("|Select a viewport|")));				
				// prompt selection of an insertion point
				_Pt0 = getPoint(T("|Pick insertion point|"));
			}
			else
			{ 
			// make the properties readonly beacause they are not relevant here
			// we are in model space not in layout space
			// not in layout tab, we are in model space
			// prompt for section2s
				Entity ents[0];
				PrEntity ssE(T("|Select Section2d|"), Section2d());
				if (ssE.go())
					ents.append(ssE.set());
					
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = { };		Entity entsTsl[1];				Point3d ptsTsl[] ={_Pt0};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	
				
				dProps.setLength(0);
				dProps.append(dTextHeight);
				
			// create per section
				for (int i=0;i<ents.length();i++) 
				{ 
					entsTsl[0] = ents[i]; 
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	 
				}//next i
				
				eraseInstance();
				return;
			}
		}
	}
// end on insert	__________________//endregion
	
// in _Entity there can be Section2d or ShopDrawView object
// In _Viewport is the Viewport object
if(_Entity.length()==0 && _Viewport.length()==0)
{ 
	reportMessage(TN("|no entity or viewport found|"));
	eraseInstance();
	return;
}

Display dp(1);
//dp.draw("hsbViewLegend", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
dp.textHeight(dTextHeight);

Section2d section;
ShopDrawView sdv;
Viewport vp;

for (int i=0;i<_Entity.length();i++) 
{ 
	ShopDrawView sdvI = (ShopDrawView)_Entity[i];
	if(sdvI.bIsValid())
	{ 
		sdv = sdvI;
		break;
	}
	Section2d sectionI = (Section2d)_Entity[i];
	if(sectionI.bIsValid())
	{ 
		section = sectionI;
		break;
	}
}//next i

if (_Viewport.length() > 0)
{ 
	vp = _Viewport[0];
}

// collect all entities
Entity entsHatch[0];
Entity entsShowset[0];
ViewData viewData;
int iViewData;
if(sdv.bIsValid())
{ 
	ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0); //2 means verbose
	int nIndex = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view		
	if (nIndex >- 1)
	{ 
		viewData = viewDatas[nIndex];
		iViewData = true;
		entsShowset = viewData.showSetEntities();
	}
}
if (section.bIsValid())
{
	ClipVolume clipVolume = section.clipVolume();
	entsShowset = clipVolume.entitiesInClipVolume(true);
}
if (_Viewport.length() > 0)
{
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Map.setString("ViewHandle", vp);
	Element el = vp.element();
	int nActiveZoneIndex = vp.activeZoneIndex();
	
	if (el.bIsValid())
	{ 
//		elements.append(el);
	// get all element entities
		Beam beams[] = el.beam();
		Sheet sheets[] = el.sheet();
		Sip sips[] = el.sip();
		TslInst tsls[] = el.tslInstAttached();
		Opening openings[] = el.opening();
		for (int i=0;i<beams.length();i++) 
			entsHatch.append(beams[i]);
		for (int i=0;i<sheets.length();i++) 
			entsHatch.append(sheets[i]);
		for (int i=0;i<sips.length();i++) 
			entsHatch.append(sips[i]);
		for (int i=0;i<tsls.length();i++) 
			entsHatch.append(tsls[i]);
		for (int i=0;i<openings.length();i++) 
			entsHatch.append(openings[i]);
	}
}
for (int j = 0; j < entsShowset.length(); j++)
{ 
	Beam beam = (Beam)entsShowset[j];
	if (beam.bIsValid() && entsHatch.find(beam) < 0)
		entsHatch.append(beam);
	Sip sip = (Sip)entsShowset[j];
	if (sip.bIsValid() && entsHatch.find(sip) < 0)
		entsHatch.append(sip);
	Sheet sheet = (Sheet)entsShowset[j];
	if (sheet.bIsValid() && entsHatch.find(sheet) < 0)
		entsHatch.append(sheet);
	TslInst tsl = (TslInst)entsShowset[j];
	if (tsl.bIsValid() && entsHatch.find(tsl) < 0)
		entsHatch.append(tsl);
	Opening opening = (Opening)entsShowset[j];
	if (opening.bIsValid() && entsHatch.find(opening) < 0)
		entsHatch.append(opening);
}//next i

// collect all hsbViewHatching tsls
TslInst tslHsbViewHatchings[0];

Entity ents[] = Group().collectEntities(true, TslInst(), _kMySpace);
if(ents.length()==0)
{ 
	reportMessage(TN("|no hsbViewHatching TSL|"));
	eraseInstance();
	return;
}
//
//
Map mapXexistingViewData;
if(_Viewport.length()>0)
{ 
	for (int i=0;i<ents.length();i++) 
	{ 
		TslInst tslI = (TslInst)ents[i];
		if ( ! tslI.bIsValid()) continue;
		
		if (tslI.scriptName() != "hsbViewHatching") continue;
		// no hatch is used
		if ( ! tslI.map().hasMap("mapHatchesUsed"))continue;
		// entities that are hatched
		Entity entsTsl[] = tslI.map().getEntityArray("entsHatch", "entsHatch", "entsHatch");
		int iFound = true;
		for (int ii=0;ii<entsTsl.length();ii++) 
		{ 
			if(entsHatch.find(entsTsl[ii])<0)
			{ 
				iFound = false;
				break;
			}
		}//next ii
		if (iFound)
		{
			if (tslHsbViewHatchings.find(tslI) < 0)tslHsbViewHatchings.append(tslI);
		}
	}//next i
}
else if(section.bIsValid())
{ 
	for (int i=0;i<ents.length();i++) 
	{ 
		TslInst tslI = (TslInst)ents[i];
		if ( ! tslI.bIsValid()) continue;
		
		if (tslI.scriptName() != "hsbViewHatching") continue;
		// no hatch is used
		if ( ! tslI.map().hasMap("mapHatchesUsed"))continue;
		// entities that are hatched
		Entity entsTslI[] = tslI.entity();
		
		if(section.bIsValid())
		{ 
			for (int ii=0;ii<entsTslI.length();ii++) 
			{ 
				Section2d sectionTsl = (Section2d) entsTslI[ii];
				if (sectionTsl.bIsValid() && sectionTsl == section)
				{ 
					if (tslHsbViewHatchings.find(tslI) < 0)tslHsbViewHatchings.append(tslI);
					break;
				}
			}
		}
	}//next i
}
else if(sdv.bIsValid())
{ 
	Entity entCollector;
	entCollector = _Map.getEntity("Generation\\entCollector");
	if (!entCollector.bIsValid())
		entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
		
	if (!entCollector.bIsValid()) 
	{
		reportMessage("\n"+scriptName() +": entCollector not found");
	}
	else
	{ 
		reportMessage("\n"+scriptName() +": entCollector found");
	}
	
	if(iViewData)
	{ 
		if(entCollector.subMapXKeys().find("hsbViewHatching")>-1)
		{ 
			Map mapXexisting = entCollector.subMapX("hsbViewHatching");
			if(mapXexisting.hasMap(viewData.viewHandle()))
			{ 
				mapXexistingViewData = mapXexisting.getMap(viewData.viewHandle());
			}
		}
	}
}
//

//if(tslHsbViewHatchings.length()==0)
//{ 
//	dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
//}
String sHatchIdentifiers[0];
// collect all hatch maps
Map mapHatches, mapHatchesCustom, mapSymbols;
mapHatchesCustom = _Map.getMap("mapHatchesCustom");
mapSymbols = _Map.getMap("mapSymbols");
if(_Viewport.length()>0 || section.bIsValid())
{ 
	for (int i=0;i<tslHsbViewHatchings.length();i++) 
	{ 
		tslHsbViewHatchings[i].recalc();
		Map mapHatchesTsl = tslHsbViewHatchings[i].map().getMap("mapHatchesUsed");
		Entity entsTsl[] = tslHsbViewHatchings[i].map().getEntityArray("entsHatch", "entsHatch", "entsHatch");
		for (int ii=0;ii<mapHatchesTsl.length();ii++) 
		{ 
			Map mapIi = mapHatchesTsl.getMap(ii);
			String sMaterial = mapIi.getString("sMaterial");
			String sPattern = mapIi.getString("sPattern");
			double dAngle = mapIi.getDouble("dAngle");
			String sAngle = dAngle;sAngle.format("%.2f", dAngle);
			double dScale0 = mapIi.getDouble("dScale");
			String sScale0 = dScale0;sScale0.format("%.4f", dScale0);
			int iColor = mapIi.getInt("iColor");
			int iSolidTransparency = mapIi.getInt("iSolidTransparency");
			
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + iColor + iSolidTransparency;
			if(sHatchIdentifiers.find(sHatchIdentifier)<0)
			{ 
				mapHatches.appendMap("mapHatch", mapIi);
				sHatchIdentifiers.append(sHatchIdentifier);
			}
		}//next ii
	}//next i
}
else if(sdv.bIsValid())
{ 
	for (int i=0;i<mapXexistingViewData.length();i++) 
	{ 
//		tslHsbViewHatchings[i].recalc();
		Map mapHatchesTsl = mapXexistingViewData.getMap(i).getMap("mapHatchesUsed");
		Entity entsTsl[] = mapXexistingViewData.getMap(i).getEntityArray("entsHatch", "entsHatch", "entsHatch");
		for (int ii=0;ii<mapHatchesTsl.length();ii++) 
		{ 
			Map mapIi = mapHatchesTsl.getMap(ii);
			String sMaterial = mapIi.getString("sMaterial");
			String sPattern = mapIi.getString("sPattern");
			double dAngle = mapIi.getDouble("dAngle");
			String sAngle = dAngle;sAngle.format("%.2f", dAngle);
			double dScale0 = mapIi.getDouble("dScale");
			String sScale0 = dScale0;sScale0.format("%.4f", dScale0);
			int iColor = mapIi.getInt("iColor");
			int iSolidTransparency = mapIi.getInt("iSolidTransparency");
			
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + iColor + iSolidTransparency;
			if(sHatchIdentifiers.find(sHatchIdentifier)<0)
			{ 
				mapHatches.appendMap("mapHatch", mapIi);
				sHatchIdentifiers.append(sHatchIdentifier);
			}
		}//next ii
	}//next i
}

// do the hatching
double dSize = 1.3*dTextHeight;
Point3d ptDraw = _Pt0;
if(mapHatches.length()==0)
{ 
	dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
}
Vector3d vecDirY = _YW;
Vector3d vecDirX = _XW;
int iTextOrient = 1;
if(_Viewport.length()>0)
{ 
	_Viewport[0].ptCenPS().vis(3);
	if(_YW.dotProduct(_Pt0-_Viewport[0].ptCenPS())>0)
		vecDirY *= -1;
	if(_XW.dotProduct(_Pt0-_Viewport[0].ptCenPS())>0)
		vecDirX *= -1;	
	if(_XW.dotProduct(_Pt0-_Viewport[0].ptCenPS())>0)
		iTextOrient = -1;
}
Map mapCustoms = _Map.getMap("mapCustoms");
// 
if (nColumns <= 0)nColumns.set(1);
if (mapHatches.length() + mapHatchesCustom.length()+ mapSymbols.length() < nColumns)nColumns.set(mapHatches.length() + mapHatchesCustom.length()+ mapSymbols.length());
if(nColumns==0)
{ 
	setExecutionLoops(2);
	return;
}
int iNrHatches = mapHatches.length() + mapHatchesCustom.length() + mapSymbols.length();
// nr hatches per column
int iNrHatchColumn = iNrHatches / nColumns;
// if 2.3, keep 3
if (iNrHatchColumn * nColumns < iNrHatches)iNrHatchColumn += 1;

double dColSize = dTextHeight*15;
double dColSizes[nColumns];

String sColSizes_ = sColSizes;
sColSizes_.trimLeft();
sColSizes_.trimRight();
String sColSizesTokens[0];

sColSizesTokens = sColSizes_.tokenize(";");

for (int i=0;i<sColSizesTokens.length();i++) 
{ 
	if (i+1 >= nColumns)break;
	dColSizes[i+1] = sColSizesTokens[i].atof();
}//next i
for (int i=sColSizesTokens.length()+1;i<dColSizes.length();i++) 
{ 
	// missing values equal to default value
	dColSizes[i]=dColSize; 
}//next i


int iHatchCount;
int iFinish;
double dLengthDefault = 1.4 * dSize;
double dWidthDefault = dSize;
Point3d ptCol = _Pt0;
for (int i=0;i<nColumns;i++)
{ 
	double dColSizeI=dColSizes[i];
	ptCol+=vecDirX * dColSizeI;
//	Point3d ptCol = _Pt0 + vecDirX * i * dColSizeI;
	for (int j=0;j<iNrHatchColumn;j++) 
	{ 
		iHatchCount++;
		if(iHatchCount>iNrHatches)
		{ 
			iFinish = true;
			break;
		}	
		// 
		Point3d ptDraw = ptCol + 1.2* vecDirY * j * dSize;
		if(iHatchCount<=mapHatches.length())
		{ 
			Map mapI = mapHatches.getMap(iHatchCount-1);
			String sMaterial = mapI.getString("sMaterial");
			String sPattern = mapI.getString("sPattern");
			int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
			sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
			double dScale0 = mapI.getDouble("dScale");
			double dAngle = mapI.getDouble("dAngle");
			Hatch hatch(sPattern, dScale0);
			hatch.setAngle(dAngle);
			int iColor = mapI.getInt("iColor");
			int iSolidTransparency = mapI.getInt("iSolidTransparency");
			dp.color(iColor);
			
			PLine plSquare(_ZW);
			plSquare.createRectangle(LineSeg(ptDraw, ptDraw + vecDirX * 1.4*dSize + vecDirY * dSize), vecDirX, vecDirY);
			plSquare.vis(4);
			// HSB-11326
			PlaneProfile ppSquare(Plane(ptDraw, _ZW));
			ppSquare.joinRing(plSquare,_kAdd);
			dp.draw(ppSquare, _kDrawFilled, iSolidTransparency);
			dp.draw(ppSquare, hatch);
			if (sMaterial == "")sMaterial = "*";
			dp.draw(sMaterial, ptDraw + (1.4*dSize + dTextHeight)*vecDirX+.5*dTextHeight*vecDirY, _XW, _YW,iTextOrient,0);
		}
		else if(iHatchCount<=mapHatches.length()+mapHatchesCustom.length())
		{ 
			Map mapI = mapHatchesCustom.getMap(iHatchCount-mapHatches.length()-1);
			String sMaterial = mapI.getString("sMaterial");
			String sPattern = mapI.getString("sPattern");
			int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
			sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
			double dScale0 = mapI.getDouble("dScale");
			double dAngle = mapI.getDouble("dAngle");
			Hatch hatch(sPattern, dScale0);
			hatch.setAngle(dAngle);
			int iColor = mapI.getInt("iColor");
			int iSolidTransparency = mapI.getInt("iSolidTransparency");
			dp.color(iColor);
			
			PLine plSquare(_ZW);
			plSquare.createRectangle(LineSeg(ptDraw, ptDraw + vecDirX * 1.4*dSize + vecDirY * dSize), vecDirX, vecDirY);
			plSquare.vis(4);
			// HSB-11326
			PlaneProfile ppSquare(Plane(ptDraw, _ZW));
			ppSquare.joinRing(plSquare,_kAdd);
			dp.draw(ppSquare, _kDrawFilled, iSolidTransparency);
			dp.draw(ppSquare, hatch);
			if (sMaterial == "")sMaterial = "*";
			dp.draw(sMaterial, ptDraw + (1.4*dSize + dTextHeight)*vecDirX+.5*dTextHeight*vecDirY, _XW, _YW,iTextOrient,0);
		}
		else if(iHatchCount<=mapHatches.length()+mapHatchesCustom.length()+mapSymbols.length())
		{ 
			Map mapI = mapSymbols.getMap(iHatchCount-mapHatches.length()-mapHatchesCustom.length()-1);
			String sSymbolName = mapI.getString("sSymbolName");
			int iSymbolColor = mapI.getInt("iSymbolColor");
			PLine pls[0];
			for (int iPl=0;iPl<100;iPl++) 
			{ 
				if(mapI.hasPLine(iPl))
				{ 
					pls.append(mapI.getPLine(iPl));
				}
				else
				{ 
					break;
				}
			}//next iPl
			if(pls.length()>0)
			{ 
				// get left bottom and top right
				Point3d ptLeftBottom, ptTopRight;
				{
					// initialize
					Point3d pts[] = pls[0].vertexPoints(true);
					ptLeftBottom = pts[0];
					ptTopRight = pts[0];
				}
				for (int iPl=0;iPl<pls.length();iPl++) 
				{ 
					Point3d pts[] = pls[iPl].vertexPoints(true);
					for (int iPt=0;iPt<pts.length();iPt++) 
					{ 
						if(_XW.dotProduct(pts[iPt]-ptLeftBottom)<0)
						{ 
							ptLeftBottom.setX(_XW.dotProduct(pts[iPt]));
						}
						if(_XW.dotProduct(pts[iPt]-ptTopRight)>0)
						{ 
							ptTopRight.setX(_XW.dotProduct(pts[iPt]));
						}
						if(_YW.dotProduct(pts[iPt]-ptLeftBottom)<0)
						{ 
							ptLeftBottom.setY(_YW.dotProduct(pts[iPt]));
						}
						if(_YW.dotProduct(pts[iPt]-ptTopRight)>0)
						{ 
							ptTopRight.setY(_YW.dotProduct(pts[iPt]));
						}
					}//next iPt
				}//next iPl
				
				Point3d ptMiddle = .5 * (ptLeftBottom + ptTopRight);
				ptMiddle.vis(6);
				ptLeftBottom.vis(10);
				ptTopRight.vis(10);
				double dLength = abs(_XW.dotProduct(ptLeftBottom - ptTopRight));
				double dWidth = abs(_YW.dotProduct(ptLeftBottom - ptTopRight));
				double dScaleFactor = dLengthDefault / dLength;
				if (dWidthDefault / dWidth < dScaleFactor)dScaleFactor = dWidthDefault / dWidth;
				
				PLine plSquare(_ZW);
				plSquare.createRectangle(LineSeg(ptDraw, ptDraw + vecDirX * 1.4*dSize + vecDirY * dSize), vecDirX, vecDirY);
				plSquare.vis(4);
				
				Point3d ptMiddleDefault = .5 * (ptDraw+ptDraw + vecDirX * 1.4*dSize + vecDirY * dSize);
				ptMiddleDefault.vis(9);
				// modify and save
				PLine plsScale[0];
				for (int iPl=0;iPl<pls.length();iPl++) 
				{ 
					Point3d pts[] = pls[iPl].vertexPoints(true);
					PLine plScale(_ZW);
					for (int iPt=0;iPt<pts.length();iPt++) 
					{ 
						Vector3d vecTr = ptMiddleDefault - ptMiddle;
						Point3d pt = vecTr + pts[iPt];
						Point3d ptScale = (pt - ptMiddleDefault) * dScaleFactor + ptMiddleDefault;
//						ptScale.vis(5);
						plScale.addVertex(ptScale);
					}//next i
					plsScale.append(plScale);
				}//next iPl
				//
				dp.color(iSymbolColor);
				for (int iPl=0;iPl<plsScale.length();iPl++) 
				{ 
					 
					 dp.draw(plsScale[iPl]);
				}//next iPl
				dp.draw(sSymbolName, ptDraw + (1.4*dSize + dTextHeight)*vecDirX+.5*dTextHeight*vecDirY, _XW, _YW,iTextOrient,0);
			}
		}
	}//next j
	if (iFinish)break;
}//next i


//for (int i=0;i<mapHatches.length();i++) 
//{ 
//	ptDraw = _Pt0 + 1.2* vecDirY * i * dSize;
//	Map mapI = mapHatches.getMap(i);
//	String sMaterial = mapI.getString("sMaterial");
//	String sPattern = mapI.getString("sPattern");
//	int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
//	sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
//	double dScale0 = mapI.getDouble("dScale0");
//	double dAngle = mapI.getDouble("dAngle");
//	Hatch hatch(sPattern, dScale0);
//	hatch.setAngle(dAngle);
//	int iColor = mapI.getInt("iColor");
//	int iSolidTransparency = mapI.getInt("iSolidTransparency");
//	dp.color(iColor);
//	
//	PLine plSquare(_ZW);
//	plSquare.createRectangle(LineSeg(ptDraw, ptDraw + vecDirX * 1.4*dSize + vecDirY * dSize), vecDirX, vecDirY);
//	plSquare.vis(4);
//	PlaneProfile ppSquare(plSquare);
//	dp.draw(ppSquare, _kDrawFilled, iSolidTransparency);
//	
//	dp.draw(ppSquare, hatch);
//	if (sMaterial == "")sMaterial = "*";
//	dp.draw(sMaterial, ptDraw + (1.4*dSize + dTextHeight)*vecDirX+.5*dTextHeight*vecDirY, _XW, _YW,iTextOrient,0);
//}//next i
ptDraw.vis(1);

//for (int i=0;i<mapCustoms.length();i++) 
//{ 
//	Map mapI = mapCustoms.getMap(i);
//	ptDraw += 1.2 * vecDirY * dSize;
//	ptDraw.vis(1);
//	String sMaterial = mapI.getString("sMaterial");
//	int iColor = mapI.getInt("iColor");
//	dp.color(iColor);
//	PLine plSquare(_ZW);
//	plSquare.createRectangle(LineSeg(ptDraw, ptDraw + vecDirX * 1.4*dSize + vecDirY * dSize), vecDirX, vecDirY);
//	plSquare.vis(4);
//	PlaneProfile ppSquare(plSquare);
//	dp.draw(ppSquare, _kDrawFilled, 0);
//	dp.draw(sMaterial, ptDraw + (dSize + dTextHeight)*vecDirX+.5*dTextHeight*vecDirY, _XW, _YW,iTextOrient,0);
//}//next i
	
	
//// Trigger AddLegend//region
//	String sTriggerAddLegend = T("|Add Legend|");
//	addRecalcTrigger(_kContextRoot, sTriggerAddLegend );
//	if (_bOnRecalc && _kExecuteKey==sTriggerAddLegend)
//	{
//		String sColor = getString("Enter color number");
//		int iColor = sColor.atoi();
//		
//		String sMaterial = getString("Enter material name");
//		
//		Map mapAdd;
//		mapAdd.setString("sMaterial", sMaterial);
//		mapAdd.setInt("iColor", iColor);
//		
//		Map mapCustoms = _Map.getMap("mapCustoms");
//		
//		if(mapCustoms.length()>0)
//		{ 
//			int iExist;
//			for (int i=0;i<mapCustoms.length();i++) 
//			{ 
//				Map mapI = mapCustoms.getMap(i);
//				if(mapI.getString("sMaterial")==sMaterial &&
//					mapI.getInt("iColor")==iColor)
//				{ 
//					iExist = true;
//					reportMessage(TN("|Legend exists|"));
//					setExecutionLoops(2);
//					return;
//					break;
//				}
//			}//next i
//			if(!iExist)
//				mapCustoms.appendMap("mapCustom", mapAdd);
//		}
//		else
//		{ 
//			mapCustoms.appendMap("mapCustom", mapAdd);
//		}
//		
//		_Map.setMap("mapCustoms", mapCustoms);
//		setExecutionLoops(2);
//		return;
//	}//endregion	
//	
//// Trigger RemoveLegend//region
//	if(mapCustoms.length()>0)
//	{
//		String sTriggerRemoveLegend = T("|Remove Legend|");
//		addRecalcTrigger(_kContextRoot, sTriggerRemoveLegend );
//		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveLegend)
//		{
//			String sColor = getString("Enter color number");
//			int iColor = sColor.atoi();
//			
//			String sMaterial = getString("Enter material name");
//			
//			Map mapRemove;
//			mapRemove.setString("sMaterial", sMaterial);
//			mapRemove.setInt("iColor", iColor);
//			
//			Map mapCustoms = _Map.getMap("mapCustoms");
//			
//			if(mapCustoms.length()>0)
//			{ 
//				int iExist;
//				for (int i=mapCustoms.length()-1; i>=0 ; i--) 
//				{ 
//					Map mapI = mapCustoms.getMap(i);
//					if(mapI.getString("sMaterial")==sMaterial &&
//						mapI.getInt("iColor")==iColor)
//					{ 
//						iExist = true;
//						mapCustoms.removeAt(i, false);
//						_Map.setMap("mapCustoms", mapCustoms);
//						setExecutionLoops(2);
//						return;
//						break;
//					}
//				}//next i
//				if(!iExist)
//				{ 
//					reportMessage(TN("|Legend doesnot exist|"));
//				}
//			}
//			else
//			{ 
//				reportMessage(TN("|no custom map found|"));
//			}
//			
//			setExecutionLoops(2);
//			return;
//		}
//	}//endregion

// Trigger AddHatch//region
	String sTriggerAddHatch = T("|Add Hatch|");
	addRecalcTrigger(_kContextRoot, sTriggerAddHatch );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddHatch)
	{
		// prepare dialog tsl
		TslInst tslDialog;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {};
		int nProps[]={};		double dProps[]={};		String sProps[]={};
		Map mapTsl;	
		
		mapTsl.setInt("DialogMode", 1);
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		Map mapHatch;
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			reportMessage("\n"+ scriptName() + " bOk"+bOk);
			
			if (bOk)
			{
//				sCatalog = tslDialog.propString(0);
//				_Map.setString("sCatalog", sCatalog);
				mapHatch.setString("sMaterial", tslDialog.propString(T("|Material|")));
				mapHatch.setInt("iColor", tslDialog.propInt(T("|Color|")));
				mapHatch.setInt("iSolidTransparency", tslDialog.propInt(T("|Transparency|")));
				
				mapHatch.setString("sPattern", tslDialog.propString(T("|Pattern|")));
				mapHatch.setDouble("dScale", tslDialog.propDouble(T("|Scale|")));
				mapHatch.setDouble("dAngle", tslDialog.propDouble(T("|Angle|")));
			}
			tslDialog.dbErase();
		}
		
		// add to mapHatchesCustom
		int iAdd = true;
		for (int i=mapHatchesCustom.length()-1; i>=0 ; i--) 
		{ 
			Map mapIi = mapHatchesCustom.getMap(i);
			String sCustom;
			String sNew;
			{ 
				String sMaterial = mapIi.getString("sMaterial");
				String sPattern = mapIi.getString("sPattern");
				double dAngle = mapIi.getDouble("dAngle");
				String sAngle = dAngle;sAngle.format("%.2f", dAngle);
				double dScale0 = mapIi.getDouble("dScale");
				String sScale0 = dScale0;sScale0.format("%.4f", dScale0);
				int iColor = mapIi.getInt("iColor");
				int iSolidTransparency = mapIi.getInt("iSolidTransparency");
//				sCustom = sMaterial + sPattern + sAngle + sScale0 + iColor + iSolidTransparency;
				sCustom = sMaterial;
			}
			
			{ 
				String sMaterial = mapHatch.getString("sMaterial");
				String sPattern = mapHatch.getString("sPattern");
				double dAngle = mapHatch.getDouble("dAngle");
				String sAngle = dAngle;sAngle.format("%.2f", dAngle);
				double dScale0 = mapHatch.getDouble("dScale");
				String sScale0 = dScale0;sScale0.format("%.4f", dScale0);
				int iColor = mapHatch.getInt("iColor");
				int iSolidTransparency = mapHatch.getInt("iSolidTransparency");
//				sNew = sMaterial + sPattern + sAngle + sScale0 + iColor + iSolidTransparency;
				sNew = sMaterial;
			}
			
			if(sCustom.makeUpper()==sNew.makeUpper())
			{ 
//				reportMessage(TN("|map exists|"));
//				iAdd = false;
//				break;
				// replace entry!!!!
				mapHatchesCustom.removeAt(i,false);
				break;
			}
		}//next i
		
		if(iAdd)
		{ 
			mapHatchesCustom.appendMap("mapHatch", mapHatch);
			_Map.setMap("mapHatchesCustom", mapHatchesCustom);
		}
		
		setExecutionLoops(2);
		return;
	}//endregion


	if(mapHatchesCustom.length()>0)
	{ 
		// Trigger RemoveHatch//region
		String sTriggerRemoveHatch = T("|Remove Hatch|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveHatch );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveHatch)
		{
			if (mapHatchesCustom.length()==0)
			{ 
				reportMessage(TN("|no custom Hatch has been added|"));
			}
			else
			{ 
				// prepare dialog tsl
				TslInst tslDialog;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {};
				int nProps[]={};		double dProps[]={};		String sProps[]={};
				Map mapTsl;	
				
				mapTsl.setInt("DialogMode", 2);
				mapTsl.setMap("mapHatchesCustom", mapHatchesCustom);
				tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				
				int iMapErase=-1;
				if (tslDialog.bIsValid())
				{
					int bOk = tslDialog.showDialog();
					reportMessage("\n"+ scriptName() + " bOk"+bOk);
					
					if (bOk)
					{
						String sMaterialErase = tslDialog.propString(T("|Material|"));
						String sTokens[] = sMaterialErase.tokenize("_");
						iMapErase = sTokens[0].atoi();
					}
					tslDialog.dbErase();
				}
				if(iMapErase+1>mapHatchesCustom.length())
				{ 
					reportMessage(TN("|unexpected|"));
				}
				else if(iMapErase>-1)
				{ 
					mapHatchesCustom.removeAt(iMapErase, false);
					_Map.setMap("mapHatchesCustom", mapHatchesCustom);
				}
			}
			setExecutionLoops(2);
			return;
		}//endregion
		
	// Trigger EraseAllCustomHatches//region
		String sTriggerEraseAllCustomHatches = T("|Erase All Custom Hatches|");
		addRecalcTrigger(_kContextRoot, sTriggerEraseAllCustomHatches );
		if (_bOnRecalc && _kExecuteKey==sTriggerEraseAllCustomHatches)
		{
			
			_Map.removeAt("mapHatchesCustom", false);
			
			setExecutionLoops(2);
			return;
		}//endregion
	}

// Trigger AddSymbol//region
	String sTriggerAddSymbol = T("|Add Symbol|");
	addRecalcTrigger(_kContextRoot, sTriggerAddSymbol );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddSymbol)
	{
		// prompt selection
		
		// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
			
		Map mapSymbol;
		PLine pls[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			EntPLine ePl = (EntPLine)ents[i];
			if(ePl.bIsValid())
			{ 
				PLine pl = ePl.getPLine();
				pls.append(pl);
			}
		}//next i
		
		for (int i=0;i<pls.length();i++) 
		{ 
			mapSymbol.appendPLine(i, pls[i]);
		}//next i
		
		// prompt the dialog for color and text
		// prepare dialog tsl
		TslInst tslDialog;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {};
		int nProps[]={};		double dProps[]={};		String sProps[]={};
		Map mapTsl;	
		
		mapTsl.setInt("DialogMode", 3);
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		String sSymbolName;
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				sSymbolName = tslDialog.propString(T("|Symbol Name|"));
				int iSymbolColor = tslDialog.propInt(T("|Symbol Color|"));
				mapSymbol.setString("sSymbolName", sSymbolName);
				mapSymbol.setInt("iSymbolColor", iSymbolColor);
			}
			tslDialog.dbErase();
		}
		
		String sNew = mapSymbol.getString("sSymbolName");
		
		for (int i=mapSymbols.length()-1; i>=0 ; i--) 
		{ 
			Map mapI = mapSymbols.getMap(i);
			String sCustom = mapI.getString("sSymbolName");
			if(sCustom.makeUpper()==sNew.makeUpper())
			{ 
				mapSymbols.removeAt(i, false);
				break;
			}
		}//next i
		
		mapSymbols.appendMap(sSymbolName, mapSymbol);
		
		_Map.setMap("mapSymbols", mapSymbols);
		setExecutionLoops(2);
		return;
	}//endregion	

if(mapSymbols.length()>0)
{ 
	// Trigger RemoveSymbol//region
		String sTriggerRemoveSymbol = T("|Remove Symbol|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveSymbol );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveSymbol)
		{
			
			if (mapSymbols.length()==0)
			{ 
				reportMessage(TN("|no custom Hatch has been added|"));
			}
			else
			{ 
				// prepare dialog tsl
				TslInst tslDialog;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {};
				int nProps[]={};		double dProps[]={};		String sProps[]={};
				Map mapTsl;	
				
				mapTsl.setInt("DialogMode", 4);
				mapTsl.setMap("mapSymbols", mapSymbols);
				tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				
				int iMapErase=-1;
				if (tslDialog.bIsValid())
				{
					int bOk = tslDialog.showDialog();
					reportMessage("\n"+ scriptName() + " bOk"+bOk);
					
					if (bOk)
					{
						String sMaterialErase = tslDialog.propString(T("|Symbol Name|"));
						String sTokens[] = sMaterialErase.tokenize("_");
						iMapErase = sTokens[0].atoi();
					}
					tslDialog.dbErase();
				}
				if(iMapErase+1>mapSymbols.length())
				{ 
					reportMessage(TN("|unexpected|"));
				}
				else if(iMapErase>-1)
				{ 
					mapSymbols.removeAt(iMapErase, false);
					_Map.setMap("mapSymbols", mapSymbols);
				}
			}
			setExecutionLoops(2);
			return;
		}//endregion	
	
	
// Trigger RemoveAllSymbols//region
	String sTriggerRemoveAllSymbols = T("|Remove All Symbols|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveAllSymbols );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveAllSymbols)
	{
		_Map.removeAt("mapSymbols",false);
		setExecutionLoops(2);
		return;
	}//endregion
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11326: fix hatch representation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/24/2021 9:04:26 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End