#Version 8
#BeginDescription
#Versions:
3.13 12.09.2023 HSB-19939: Apply contour thickness on the inside
3.12 30.08.2023 HSB-18638: Add extra masterOversize extend (-shrink) to the ppMaster, before nesting 
3.11 10.07.2023 HSB-19483: Apply thickness to contour 
3.10 26.06.2023 HSB-18638: Add nesting parameters in xml "Layer" 
3.9 20.02.2023 HSB-18017: Dont write layer separation here 
3.8 24.01.2023 HSB-17656: for KLH: write "L" in mapX for layer separation
version value="3.7" date=30oct2020" author="thorsten.huck@hsbcad.com"
HSB-9342 debug message removed
HSB-9342 new grip in truck section to move vertical alignment
requires version 23 or higher

EN
Select properties or catalog entry and press OK, select stackable items and insertion point






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 13
#KeyWords Stacking;Truck;Nesting;Delivery
#BeginContents

//region PART 1
		
//region History
/// #Versions:
// 3.13 12.09.2023 HSB-19939: Apply contour thickness on the inside Author: Marsel Nakuci
// 3.12 30.08.2023 HSB-18638: Add extra masterOversize extend (-shrink) to the ppMaster, before nesting Author: Marsel Nakuci
// 3.11 10.07.2023 HSB-19483: Apply thickness to contour Author: Marsel Nakuci
// 3.10 26.06.2023 HSB-18638: Add nesting parameters in xml "Layer" Author: Marsel Nakuci
// 3.9 20.02.2023 HSB-18017: Dont write layer separation here Author: Marsel Nakuci
// 3.8 24.01.2023 HSB-17656: for KLH: write "L" in mapX for layer separation Author: Marsel Nakuci
/// <version value="3.7" date=30oct2020" author="thorsten.huck@hsbcad.com"> HSB-9342 debug message removed </version>
/// <version value="3.6" date=20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9342 new grip in truck section to move vertical alignment, requires version 23 or higher </version>
/// <version value="3.5" date=28nov2019" author="thorsten.huck@hsbcad.com"> HSB-5802 items can be placed within openings of another item </version>
/// <version value="3.4" date=24oct2019" author="thorsten.huck@hsbcad.com"> debug message removed </version>
/// <version value="3.3" date=07mar2019" author="thorsten.huck@hsbcad.com"> if nesting is enabled it will use the max truck or grid range to nest items </version>
/// <version value="3.2" date=07mar2019" author="thorsten.huck@hsbcad.com"> debug pline removed </version>
/// <version value="3.1" date=06mar2019" author="thorsten.huck@hsbcad.com"> add item bugfix </version>
/// <version value="3.0" date=07feb2019" author="thorsten.huck@hsbcad.com"> parent/child naming changed, NOTE: do not update existing entities </version>
/// <version value="2.9" date=23aug2017" author="thorsten.huck@hsbcad.com"> packages supported </version>
/// <version value="2.8" date="04aug2017" author="thorsten.huck@hsbcad.com"> 2.7 rolled back, remote new layer assignment added </version>
/// <version value="2.7" date="11jul2017" author="thorsten.huck@hsbcad.com"> items nested inside openings will not show as interference</version>
/// <version value="2.6" date="05jul2017" author="thorsten.huck@hsbcad.com"> bugfix adding items </version>
/// <version value="2.5" date="28jun2017" author="thorsten.huck@hsbcad.com"> tagging added </version>
/// <version value="2.4" date="26jun2017" author="thorsten.huck@hsbcad.com"> intereference color uses value of settings </version>
/// <version value="2.3" date="11may2017" author="thorsten.huck@hsbcad.com"> description slightly offseted </version>
/// <version value="2.2" date="07apr2017" author="thorsten.huck@hsbcad.com"> minor bugfixes </version>
/// <version value="2.1" date="06apr2017" author="thorsten.huck@hsbcad.com"> alignemnet added, new dependencies </version>
/// <version value="2.0" date="20mar2017" author="thorsten.huck@hsbcad.com"> grip location enhanced </version>
/// <version value="1.9" date="13mar2017" author="thorsten.huck@hsbcad.com"> nesting on insert added, grip location truck dependent </version>
/// <version value="1.8" date="07mar2017" author="thorsten.huck@hsbcad.com"> the previously called term 'Stack' is now called 'Layer'</version>
/// <version value="1.7" date="03mar2017" author="thorsten.huck@hsbcad.com"> adding and removing items enhanced </version>
/// <version value="1.6" date="20feb2017" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.5" date="15feb2017" author="thorsten.huck@hsbcad.com"> external settings added </version>
/// <version value="1.4" date="13feb2017" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.3" date="03feb2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK, select stackable items and insertion point
/// </insert>

/// <summary Lang=en>
/// This tsl creates a stack of stackable items and shows it in XY World.
/// A stack can be assigned to a truck or it can be created by a custom command
/// (double click) and the selection of stackable items
//End History//endregion 

//region Constants 
	U(1,"mm");
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = {T("|No|"), T("|Yes|")};
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int isKlh=sProjectSpecial=="KLH";

// nester constants
	double dNesterDuration = 1;
	double dNesterSpacing = U(0);
	int bNestInOpening = false;
	String sNestAction= T("|Nesting|") ;// the trigger string of the nesting action

// stacking family key words
	String sItemX = "Hsb_Item";
	String sTruckKey = "Hsb_TruckParent";
	String sGridKey = "Hsb_GridParent";
	String sPropsetProperties[] ={T("|Package Number|"),T("|Truck ID|"), T("|Type|"),T("|Design|")};
	int nPropsetPropertyTypes[] ={1,0,0,0};// 0 = string, 1 = int, 2 = double
	
// truck constants 
	//LayerInterference
	int nColorInterfere = 242; 	
	int nTransparencyInterfere=50;	
	String sLineTypeInterfere = "CONTINUOUS";
	double dLineTypeScaleInterfere = U(1);	
	
//endregion

//region Properties
	int nStartTick;
	//if (bDebug)
	nStartTick=getTickCount();
	
//	String sLengthName=T("|Length|");	
//	PropDouble dLength(nDoubleIndex++, U(6000), sLengthName);	
//	dLength.setDescription(T("|Defines the Length|"));
//	dLength.setCategory(category);
//	
//	String sWidthName=T("|Width|");	
//	PropDouble dWidth(nDoubleIndex++, U(3000), sWidthName);	
//	dWidth.setDescription(T("|Defines the Width|"));
//	dWidth.setCategory(category);
//
//	String sHeightName=T("|Height|");	
//	PropDouble dHeight(nDoubleIndex++, U(0), sHeightName);	
//	dHeight.setDescription(T("|Defines the Height|"));
//	dHeight.setCategory(category);


//region HSB-18638: DialogMode
	int nDialogmode=_Map.getInt("DialogMode");
	if(nDialogmode==1)
	{ 
	// Nesting dialog
		String sOpmKey = "Nesting";
		setOPMKey(sOpmKey);
		category=T("|Nesting|");
		String sSpacingName=T("|Spacing|");
		PropDouble dSpacing(nDoubleIndex++, U(0), sSpacingName);
		dSpacing.setDescription(T("|Defines the Spacing|"));
		dSpacing.setCategory(category);
		
		String sNestInOpeningName=T("|NestInOpening|");
		PropString sNestInOpening(nStringIndex++, sNoYes, sNestInOpeningName);
		sNestInOpening.setDescription(T("|Defines the NestInOpening|"));
		sNestInOpening.setCategory(category);
		
		return;
	}
//End DialogMode//endregion 


// Bedding
	category = T("|Bedding|");
	String sHeightBeddingName=T("|Height|") + " ";	
	PropDouble dHeightBedding(nDoubleIndex++, U(80), sHeightBeddingName);	
	dHeightBedding.setDescription(T("|Defines the Height|"));
	dHeightBedding.setCategory(category);

// nester
	category = T("|Nester|");

// nester type	
	String sNesterTypeName=T("|Nester Type|");	
	int nNesterTypes[] = {-1,_kNTAutoNesterV5, _kNTRectangularNester};
	String sNesterTypes[] = { T("|Disabled|"), T("|Autonester|"), T("|Rectangular Nester|")};
	PropString sNesterType(nStringIndex++, sNesterTypes, sNesterTypeName,2);	
	sNesterType.setDescription(T("|Defines the Nester Type|"));
	sNesterType.setCategory(category);

	double dRotations[] = {360,90,180,0};
	String sRotations[] ={T("|forbidden|"), T("|90°|"), T("|180°|"), T("|any angle|")}; 
	String sRotationName = T("|Rotation|");
	PropString sRotation(nStringIndex++,sRotations, sRotationName, 2);
	sRotation.setCategory(category);	

	category = T("|Information|");
	String sInformationName = T("|Text|");
	PropString sInformation(nStringIndex++,"", sInformationName);
	sInformation.setCategory(category);
	
// display defaults
	String sLineTypes[0];sLineTypes = _LineTypes;
	String sLineType = sLineTypes.length()>0?sLineTypes[0]:"";
	double dLineTypeScale=U(1);
	int nColor = 40;
	double dTxtH = U(40);
	
	double dColumnOffset = U(1000);
	double dRowOffset = U(1000);
	String sTypes[] = { T("|Horizontal|"), T("|Vertical|")};
	
	double dLengthTruck = U(18000);
	double dWidthTruck = U(4000);
	// HSB-19483 map containing contour properties like thickness
	Map mapContour;
//End Properties//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="f_Stacking";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Read Settings
Map mapNesting;
{
// Layer
	Map m = mapSetting.getMap("Layer");
	String k;
		
	k = "Color";			if (m.hasInt(k))nColor=m.getInt(k);
	k = "TextHeight";		if (m.hasDouble(k))	dTxtH = m.getDouble(k);
	k = "LineType";			if (sLineTypes.find(m.getString(k))>0)	sLineType = m.getString(k);
	k = "LineTypeScale";	if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
	// HSB-19483
	k="Contour"; if (m.hasMap(k)) mapContour=m.getMap(k);
	
	// HSB-18638: 
	mapNesting=m.getMap("Nesting");
	k="Spacing"; if (mapNesting.hasDouble(k)) dNesterSpacing=mapNesting.getDouble(k);
	k="NestInOpening"; if (mapNesting.hasInt(k)) bNestInOpening=mapNesting.getInt(k);
	// 
	m = mapSetting.getMap("Grid");
	k="ColumnOffset";		if (m.hasDouble(k))	dColumnOffset = m.getDouble(k);
	k="RowOffset";			if (m.hasDouble(k))	dColumnOffset = m.getDouble(k);
	
	m = mapSetting.getMap("Truck");
	k="MaxLength";		if (m.hasDouble(k))	dLengthTruck = m.getDouble(k);
	k="MaxWidth";		if (m.hasDouble(k))	dWidthTruck = m.getDouble(k);		
	
	//LayerInterference
	Map g = m.getMap("LayerInterference");
	k="Color";				if (g.hasInt(k))	nColorInterfere = g.getInt(k);
	k="Linetype";			if (g.hasString(k))	sLineTypeInterfere = g.getString(k);		
	k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleInterfere = g.getDouble(k);	
	k="Transparency";		if (g.hasInt(k))	nTransparencyInterfere = g.getInt(k);
}
//End Read Settings//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)
				setPropValuesFromCatalog(sKey);
			else
				showDialog();
		}		
		else
			showDialog();

	// prompt for items
		Entity ents[0];
		PrEntity ssE(T("|Select item(s)|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());

	// add only items
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			Entity ent = ents[i];		
			Map m = ent.subMapX(sItemX);
			Entity entRef;
			entRef.setFromHandle(m.getString("MyUid"));
			if (entRef.bIsValid())
				_Entity.append(ent);
		}


		_Pt0 = getPoint();	
		return;
	}		
//End OnINsert//endregion 

//End PART 1//endregion 

//region PART 2


//region GripPointDragActions, V23up  only
	for (int i=0;i<_PtG.length();i++) 
	{ 
		addRecalcTrigger(_kGripPointDrag, "_PtG"+i);	
		if (_bOnGripPointDrag && _kExecuteKey=="_PtG"+i) 
		{ 
			Display dp(150);
			double d = dTxtH;
			Point3d pt = _PtG[i];
			Vector3d vecA = .125 * dTxtH * _XW;
			Vector3d vecB = .5 * dTxtH * _YW;
			PLine pl(_ZW);
			
			pl.addVertex(pt + vecA+.25*vecB);
			pl.addVertex(pt + vecB);
			pl.addVertex(pt - vecA+.25*vecB);
			
			pl.addVertex(pt - .25*vecA+.5*vecB);
			pl.addVertex(pt - .25*vecA-.5*vecB);
			
			pl.addVertex(pt - vecA-.25*vecB);
			pl.addVertex(pt - vecB);
			pl.addVertex(pt + vecA-.25*vecB);
			
			pl.addVertex(pt + .25*vecA-.5*vecB);
			pl.addVertex(pt + .25*vecA+.5*vecB);	
		
			pl.close();
			dp.draw(PlaneProfile(pl), _kDrawFilled, 60);
			return;
		}	
	}	
//End GripPointDragActions//endregion 

//region HSB-18638: Trigger ModifyNestingParameters
	String sTriggerModifyNestingParameters = T("|Modify Nesting Parameters|");
	addRecalcTrigger(_kContextRoot, sTriggerModifyNestingParameters );
	if (_bOnRecalc && _kExecuteKey==sTriggerModifyNestingParameters)
	{
		// create TSL
		TslInst tslDialog;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={}; double dProps[1]; String sProps[1];
		Map mapTsl;
		
		mapTsl.setInt("DialogMode", 1);
		dProps[0]=mapNesting.getDouble("Spacing");
		sProps[0]=sNoYes[0];
		if(mapNesting.getInt("NestInOpening")>0)
			sProps[0]=sNoYes[1];
		
		tslDialog.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
			ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			
		if(tslDialog.bIsValid())
		{ 
			int bOk=tslDialog.showDialog();
			if(bOk)
			{ 
				// modify the mapSetting
				Map mapSettingNew;mapSettingNew.setMapKey("root");
				Map mapLayerNew;
				mapLayerNew=mapSetting.getMap("Layer");
				mapLayerNew.removeAt("Nesting", true);
				Map mapNestingNew;
				mapNestingNew.setMapKey("Nesting");
				mapNestingNew.setDouble("Spacing",tslDialog.propDouble(0));
				mapNestingNew.setInt("NestInOpening",sNoYes.find(tslDialog.propString(0)));
				mapLayerNew.appendMap("Nesting",mapNestingNew);
				
				mapSettingNew.appendMap("Truck",mapSetting.getMap("Truck"));
				mapSettingNew.appendMap("Layer",mapLayerNew);
				mapSettingNew.appendMap("Package",mapSetting.getMap("Package"));
				mapSettingNew.appendMap("SourceEntity",mapSetting.getMap("SourceEntity"));
				mapSettingNew.appendMap("Item",mapSetting.getMap("Item"));
				mapSettingNew.appendMap("GeneralMapObject",mapSetting.getMap("GeneralMapObject"));
				
				if(mo.bIsValid())
					mo.setMap(mapSettingNew);
				else 
					mo.dbCreate(mapSettingNew);
			}
			tslDialog.dbErase();
		}
			
		
		setExecutionLoops(2);
		return;
	}//endregion	



//region Basics
// validate item ref
	if (_Entity.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|"));
		eraseInstance();
		return;	
	}
	
// set model coordSys	
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	_Pt0.setZ(0);
	Point3d ptOrg = _Pt0;	
	CoordSys csW(ptOrg, vecX, vecY, vecZ);
	Plane pnZ(ptOrg, vecZ);

// set myMyUid
	String sMyMyUid = _ThisInst.handle();

// get the potential link to the truck entity
	TslInst truck;
	//reportMessage("\n" + scriptName() + " "+_ThisInst.subMapXKeys());
	if (_ThisInst.subMapXKeys().find(sGridKey)>-1)// 
	{
		Map m = _ThisInst.subMapX(sGridKey);
		Entity e;
		e.setFromHandle(m.getString("MyUid"));
		truck =(TslInst)e;	
	}
	
// truck data
	PlaneProfile ppGrid;
	int nType, nAlignment;
	double dHeightTruck;
	if (truck.bIsValid())
	{
		Map map = truck.map();
		nType = map.getInt("type");		
		dLengthTruck = truck.propDouble(0);
		dWidthTruck = truck.propDouble(1);
		dHeightTruck = truck.propDouble(2);
		ppGrid = map.getPlaneProfile("grid");
		nAlignment =  map.getInt("alignment");
	}
	else
	{
		//nAlignment =  -1;
		_PtG.setLength(0);
		_Map.removeAt("vec0",true);
		_Map.removeAt("vec1",true);
	}

// find a potential truck entity on insert by location
	int bTruckIsLinked = truck.bIsValid();
	if (bTruckIsLinked && truck.entity().find(_ThisInst)<0)
		bTruckIsLinked = false;
	
	if ((_bOnDbCreated || _kNameLastChangedProp=="_Pt0") && !bTruckIsLinked)
	{ 
		
		
		Entity ents[] = Group().collectEntities(true, TslInst(),_kModelSpace);
		if(bDebug)reportMessage("\n"+ scriptName() + " tsls found in dwg: " + ents.length());
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst tsl= (TslInst)ents[i];
			if (tsl.bIsValid())
			{
				Map map = tsl.map();
				if (!map.getInt("isGrid") || !map.hasPlaneProfile("grid"))
				{continue;}
				
				if(bDebug)reportMessage("\n	truck found ");
				PlaneProfile _ppGrid = map.getPlaneProfile("grid");
				//ppGrid.vis(2);
				if (_ppGrid.pointInProfile(_Pt0)!=_kPointOutsideProfile)
				{
					truck = tsl;
					ppGrid = _ppGrid;
					
				// write parent data to child	
					Map m;
					m.setString("MyUid", truck.handle());
					m.setPoint3d("ptOrg", _Pt0, _kRelative);
					m.setVector3d("vecX", vecX*truck.propDouble(0), _kScalable); // coordsys carries size
					m.setVector3d("vecY", vecY*truck.propDouble(1), _kScalable);
					m.setVector3d("vecZ", vecZ*truck.propDouble(2), _kScalable);
					//m.setMap("PackageData", mapData);
					_ThisInst.setSubMapX(sGridKey,m);// (over)write submapX
					
				// append _ThisInst remotely to _Entity of the truck
					if(bDebug)reportMessage("\n	add me to _Entity array");
					map.setEntity("newLayer", _ThisInst);
					truck.setMap(map);
					truck.transformBy(Vector3d(0,0,0));
					bTruckIsLinked = true;
					break;
				}
			}	 
		}
		
		if (!bTruckIsLinked)
			reportMessage("\n"+ scriptName() + ": " + T("|This layer is not linked to any truck.|") + " " + T("|Drag the layer into a truck cell to assign it.|"));
	}

// the outline of the stacking layer
	Point3d ptPlan = _Pt0;
	ptPlan.setZ(0);
	PLine plLayer;
	plLayer.createRectangle(LineSeg(ptPlan, ptPlan + vecX* nAlignment*dLengthTruck+ vecY*dWidthTruck), vecX, vecY);
	PlaneProfile ppLayer(csW);
	ppLayer.joinRing(plLayer,_kAdd);
	ppLayer.joinRing(_Map.getPLine("plContour"),_kAdd);
	ppLayer.vis(2);
	
// properties by index
	int nNesterType;
	{
		int n = sNesterTypes.find(sNesterType);
		if (n>-1 && n<nNesterTypes.length())
			nNesterType=nNesterTypes[n];
	}
	int nRotation = sRotations.find(sRotation);	
	double dNesterRotation;
	if (nRotation>-1 && dRotations.length()>nRotation)
		dNesterRotation = dRotations[nRotation];


// set parent reference to childs
	if (_bOnDbCreated)
	{
		for (int i=_Entity.length()-1;i>=0;i--)	
		{
			Entity entChild = _Entity[i];
			
		// write parent data to child	
			Map m;
			m.setString("MyUid", sMyMyUid);
			m.setPoint3d("ptOrg", _Pt0, _kRelative);
			m.setVector3d("vecX", vecX, _kScalable); // coordsys carries size
			m.setVector3d("vecY", vecY, _kScalable);
			m.setVector3d("vecZ", vecZ, _kScalable);
			//m.setMap("PackageData", mapData);
			entChild.setSubMapX("Hsb_LayerParent",m);// (over)write submapX
		}	
	}		
//End Basics//endregion 

//region Triggers to add or remove items
// TriggerAdd
	String sTriggerAdd = T("|Add Item(s)|")+ " (" + T("|Doubleclick|") + ")";
	addRecalcTrigger(_kContext, sTriggerAdd );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAdd || _kExecuteKey==sDoubleClick))
	{
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + sTriggerAdd);
		
	// get items
		Entity ents[0];
		PrEntity ssE(T("|Select item(s)|")+", " + T("|<Enter> to assign by location|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// get all items
		int bByLocation;
		if (ents.length()<1)
		{
			ents = Group().collectEntities(true, TslInst(),_kModelSpace);
			bByLocation = true;
		}
			
	// remove linked or non items
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
		// avoid duplicates
			Entity ent= ents[i]; 
			if (_Entity.find(ent)>-1)
			{
				ents.removeAt(i);
				continue;
			}

		// remove invalid
			Entity entRef;
			entRef.setFromHandle(ent.subMapX(sItemX).getString("MyUid"));
			reportMessage("\n	ent " + ((TslInst)ent).scriptName());
			
			//	ents.removeAt(i);	
		}// next i
		
	// get maximised cell stacking-layer area by truck
		PlaneProfile _ppLayer = ppLayer;
		if (truck.bIsValid())
		{
			//if(bDebug)reportMessage("\n	truck is valid");
			PlaneProfile ppGrid = truck.map().getPlaneProfile("Grid");
		// find relevant ring of grid
			PLine plRings[] = ppGrid.allRings(true, false);
			if(bDebug)reportMessage("\n	" + plRings.length() + " grid plines");
			for (int r=0;r<plRings.length();r++)
			{
//				if (bDebug)
//				{ 
//					EntPLine epl;
//					epl.dbCreate(plRings[r]);
//				}
//
				PlaneProfile _ppGrid(csW);
				_ppGrid.joinRing(plRings[r],_kAdd);
				_ppGrid.intersectWith(_ppLayer);
				if (_ppGrid.area()>pow(dEps,2))
				{
					_ppLayer.joinRing(plRings[r],_kAdd);	
//					EntPLine epl;
//					epl.dbCreate(plRings[r]);
//					epl.setColor(4);
//					reportMessage("\n	" + r + " grid pline added " + _ppLayer.area());
					break;
				}
			}
		}
	// use max truck dimensions
		else
		{
		// get extents of profile
			LineSeg seg = _ppLayer.extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		
		// lower left corner of max truck dimensions
			Point3d pt1 = seg.ptMid() - .5 * (vecX * dX + vecY * dY);
			seg = LineSeg(pt1, pt1 + vecX * dLengthTruck + vecY * dWidthTruck);
			_ppLayer.createRectangle(seg, vecX, vecY);	
		}

	// remove items not intersecting the contour
		for (int i=ents.length()-1; i>=0 ; i--) 
		{
			PlaneProfile pp = ents[i].realBody().shadowProfile(pnZ);
			pp.intersectWith(_ppLayer);
			if (pp.area()<pow(dEps,2))
			{
				//if(bDebug)	reportMessage("\n	removing ent i " + i);
				ents.removeAt(i);
			}
		}

	// append new items
		if(bDebug)reportMessage("\nappending new ents: " + ents.length());
		
		for (int i=0;i<ents.length();i++)	
		{
			Entity ent = ents[i];			
		// write parent data to child	
			Map m;
			m.setString("MyUid", sMyMyUid);
			m.setPoint3d("ptOrg", _Pt0, _kRelative);
			m.setVector3d("vecX", vecX, _kScalable); // coordsys could carry size
			m.setVector3d("vecY", vecY, _kScalable);
			m.setVector3d("vecZ", vecZ, _kScalable);
			//m.setMap("PackageData", mapData);
			ent.setSubMapX("Hsb_LayerParent",m);	//(over)write submapX	
			ent.transformBy(Vector3d(0, 0, 0));
		}	
		
		_Entity.append(ents);
	// flag the nester to be executed	
		if (nNesterType>-1)
			_Map.setInt("callNester",true);
		setExecutionLoops(2);
		return;
		
	}// END TriggerAdd
	
// TriggerRemove
	String sTriggerRemove = T("|Remove Item(s)|");
	addRecalcTrigger(_kContext, sTriggerRemove );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemove)
	{
	// get items
		Entity ents[0];
		PrEntity ssE(T("|Select item(s)|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());	
			
	// remove items
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity ent = ents[i]; 
			int n = _Entity.find(ent);
			if (n>-1)
			{
				ent.removeSubMapX("Hsb_LayerParent");
				ent.removeSubMapX("Hsb_TruckChild");
				_Entity.removeAt(n);
			}
			ent.transformBy(Vector3d(0, 0, 0));
		}
		setExecutionLoops(2);
		return;			
	}// END sTriggerRemove
	
//End Triggers to add or remove items//endregion 
	
//region Collect childs
	for (int i=_Entity.length()-1;i>=0;i--)
	{
		Entity ent = _Entity[i];
		Map m = ent.subMapX("Hsb_LayerParent");
		String sParentMyUid = m.getString("MyUid");
	// this package and the ParentMyUid of the child are not identical -> the entity will be removed from _Entity
		if (sParentMyUid.length()>0 && sParentMyUid != sMyMyUid)
		{
			//if (bDebug)
			reportMessage("\n" + scriptName() + " "  + sMyMyUid + " differs from parentMyUid " + sParentMyUid);
			if (!_bOnDebug)
				_Entity.removeAt(i);
			continue;	
		}
	// append dependency
		setDependencyOnEntity(ent);	
	}// next i

	Entity childs[0];
	childs= _Entity;

// set color by item
	int nInstColor = _ThisInst.color();
	if (childs.length()>0 && childs[0].color()!=nInstColor)
		_ThisInst.setColor(childs[0].color());


// validate grip position
// get grid extents as profile: use this to validate grip locations
//	if (_PtG.length()>0 && ppGrid.area()>pow(dEps,2))
//	{
//		PLine pl;
//		pl.createRectangle(ppGrid.extentInDir(vecX),vecX, vecY);
//		PlaneProfile ppGridExtents(csW);
//		ppGridExtents.joinRing(pl,_kAdd);
//	ppGridExtents.vis(2);	
//		int bInGrid =ppGridExtents.pointInProfile(_PtG[0])!=_kPointOutsideProfile; 
//		if (!bInGrid)
//		{
//			if(bDebug)reportMessage("\n"+ scriptName() + " invalid grip location");
//			_PtG.setLength(0);
//			_Map.removeAt("vec0", true);
//		}
//
//	}		
//End collect childs//endregion 

//region Dragging, Nesting and ALignment
// on the event of dragging _Pt0
	if(_kNameLastChangedProp=="_Pt0")
	{
	// remove potential grip
		if (_PtG.length()>0)
		{
			_PtG.setLength(0);	
			_Map.removeAt("vec0", true);
			_Map.removeAt("vec1", true);
		}
		
	// relocate childs
		if(_Map.hasVector3d("vecPt0"))
		{
			Point3d ptPrevious = _PtW+ _Map.getVector3d("vecPt0");
			Vector3d vec = _Pt0-ptPrevious;
			//if(bDebug)reportMessage("\n	"+ scriptName() + " transforming childs by " + vec);
			
			for (int i=0;i<childs.length();i++) 
				childs[i].transformBy(vec);
				
		
//		// keep _PtG[0] at X-Location
//			double dXMove = _XW.dotProduct(vec);
//			if (_PtG.length()>0 && abs(dXMove)>dEps)_PtG[0] -= _XW * dXMove;			
		}
		 
	}
	
//region Dragging grip 0 or 1
	if (_kNameLastChangedProp=="_PtG0")
	{ 
		Point3d pt = _PtW + _Map.getVector3d("vec0");
		double dYMove = _YW.dotProduct(_PtG[0] - pt);
		if (abs(dYMove)>dEps)
			_PtG[1] = _PtW+_Map.getVector3d("vec1")+_YW * dYMove;
	}
	if (_kNameLastChangedProp=="_PtG1")
	{ 
		Point3d pt = _PtW + _Map.getVector3d("vec1");
//		double dXMove = _XW.dotProduct(_PtG[1] - pt);
//		if (abs(dXMove)>dEps)
//		{
//			Vector3d vec = _XW * dXMove;
//			_Pt0= _PtW+ _Map.getVector3d("vecPt0")+vec;
//			for (int i=0;i<childs.length();i++) 
//				childs[i].transformBy(vec);
//		}
		double dYMove = _YW.dotProduct(_PtG[1] - pt);
		if (abs(dYMove)>dEps)
			_PtG[0] = _PtW+_Map.getVector3d("vec0")+_YW * dYMove;			
	}	
//End Dragging grip 0//endregion 	
	
	
// set grip by vector
	if(_PtG.length()<1 && _Map.hasVector3d("vec0"))
	{
		_PtG.append(_PtW+_Map.getVector3d("vec0")); 		
	}
	if(_PtG.length()==1 && _Map.hasVector3d("vec1"))
	{
		_PtG.append(_PtW+_Map.getVector3d("vec1")); 		
	}	
	
	
// relocate grips
	for (int i=0;i<_PtG.length();i++) 
		_PtG[i].setZ(0);

	
// get calllNester flag: this flag is set by another instance
	int bCallNester = _Map.getInt("callNester");

// nester action
	addRecalcTrigger(_kContext, sNestAction);
	int bNest = nNesterType > 0 && childs.length()>0 && ((_bOnRecalc && _kExecuteKey==sNestAction) || _bOnDbCreated || bCallNester);
	
// start nesting	
	if(bNest)
	{	
		if(bDebug)reportMessage("\n Start nesting requested by"+ 
			"\n		"+sNestAction+": " +_kExecuteKey+ 
			"\n		_bOnDbCreated: "+_bOnDbCreated+ 
			"\n		bCallNester: "+bCallNester);
	
	
	// set nester data
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dNesterDuration); // seconds
		
		nd.setMinimumSpacing(dNesterSpacing);
		nd.setGenerateDebugOutput(false);
		nd.setNesterToUse(nNesterType);
		// 
		nd.setChildOffsetX(U(0));
		nd.setChildOffsetY(U(0));
		
	// construct a NesterCaller object adding masters and childs
		NesterCaller nester;
		for (int s=0; s<childs.length(); s++) 
		{
			Entity e= childs[s];
			PlaneProfile pp = e.realBody().shadowProfile(pnZ);

			NesterChild nc(e.handle(),pp);
			nc.setNestInOpenings(bNestInOpening);
			nc.setRotationAllowance(dNesterRotation);
			nester.addChild(nc);
		}	
		
		
	// get master planeprofile
		PlaneProfile ppMaster = ppLayer;
		if (truck.bIsValid())
		{
			PlaneProfile ppGrid = truck.map().getPlaneProfile("Grid");
		// find relevant ring of grid
			PLine plRings[] = ppGrid.allRings(true, false);
			for (int r=0;r<plRings.length();r++)
			{
				PlaneProfile _ppGrid(csW);
				_ppGrid.joinRing(plRings[r],_kAdd);
				_ppGrid.intersectWith(ppMaster);
				if (_ppGrid.area()>pow(dEps,2))
				{
					ppMaster.joinRing(plRings[r],_kAdd);	
					break;
				}
			}
		}
	// use max truck dimensions
		else
		{
		// get extents of profile
			LineSeg seg = ppMaster.extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		
		// lower left corner of max truck dimensions
			Point3d pt1 = seg.ptMid() - .5 * (vecX * dX + vecY * dY);
			seg = LineSeg(pt1, pt1 + vecX * dLengthTruck + vecY * dWidthTruck);
			ppMaster.createRectangle(seg, vecX, vecY);	
		}		

	// the nester master
	// HSB-18638: Add extra extend to the ppMaster
		ppMaster.shrink(-U(100));
		ppMaster.transformBy(vecX*U(100));
		ppMaster.transformBy(vecY*U(100));
		NesterMaster nm(sMyMyUid, ppMaster);
		nester.addMaster(nm);
	
	// reporting 
		int bShowLog = bDebug;
		if(bShowLog)
		{
		// NesterCaller object content
			reportMessage("\n	" + scriptName() +" " +T("|Nesting master input|"));	
			for (int m=0; m<nester.masterCount(); m++) 
			{
				NesterMaster master = nester.masterAt(m);
				//if (bDebug)reportMessage("\n		Master "+m+" "+nester.masterOriginatorIdAt(m) + " == " + master.originatorId() );
				reportMessage("\n   " +T("|Masterpanel|") + " " + nester.masterOriginatorIdAt(m));				
			}
			reportMessage("\n      "+nester.childCount() +" " + T("|childs to be nested|") );
			//for (int c=0; c<nester.childCount(); c++) 
			//{
				//NesterChild nc = nester.childAt(c);
				//if (bDebug)reportMessage("\n		Child "+c+" "+nester.childOriginatorIdAt(c) + " == " + nc.originatorId() + " rotationAllowance:"  + nc.rotationAllowance());
			//}
		}// end if (report)	
		
	// do the actual nesting
		int nSuccess = nester.nest(nd, true);
		if (bDebug)reportMessage("\n\n	NestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			reportMessage("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportMessage("\n" + scriptName() + ": " + T("|No dongle present|"));
			setExecutionLoops(2);
			return;
		}	
		
	// collect some nesting results
		///master indices
		
		
		int nMasterIndices[] = nester.nesterMasterIndexes();
		int nLeftOverChilds[] = nester.leftOverChildIndexes();
		int bMasterHasChilds;
		if(nMasterIndices.length()>0)
		{
			int nIndexMaster = nMasterIndices[0];
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			bMasterHasChilds = nChildIndices.length()>0;
			if(bShowLog)
			{
				if (bMasterHasChilds)
				{
					reportMessage("\n      "+nChildIndices.length() + " " + T("|childs successfully nested|"));
				}
				else
					reportMessage("\n      "+ T("|No childs nested!|"));
			}
		}		
		
	// loop over the nester masters
		for (int m=0; m<nMasterIndices.length(); m++) 
		{
			int nIndexMaster = nMasterIndices[m];
			//if (bDebug)reportMessage("\nResult "+nIndexMaster +": "+nester.masterOriginatorIdAt(nIndexMaster) );
			
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportMessage("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
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
				ent.transformBy(cs);
			}
		}	
		
		_Map.removeAt("callNester",true);
		
	}// end if nesting


// Z/Y-Layer action
	String sStackAction = T("|Auto Alignment|");
	addRecalcTrigger(_kContext, sStackAction);
	//int bStackAction;
	if(_bOnRecalc && _kExecuteKey==sStackAction)
	{
		_PtG.setLength(0);
		_Map.removeAt("vec0", true);
		_Map.removeAt("vec1", true);
		setExecutionLoops(2);
		return;
		//bStackAction=true;
	}		
//End Dragging, Nesting and ALignment//endregion 

//End PART 2//endregion 


//region Grip Management
// get layer to truck transformation
	{ 
		if (!bDebug)
			_Map.setEntity("thisLayer", _ThisInst);
	}
{ 
	TslInst layer = _ThisInst;
	if (bDebug && _Map.hasEntity("thisLayer"))
	{ 
		Entity e = _Map.getEntity("thisLayer");
		layer = (TslInst)e;
		if (!layer.bIsValid())layer = _ThisInst;
	}
	
	if (layer.subMapXKeys().findNoCase("Hsb_Layer2Truck",-1)>-1)
	{ 
		Map m = layer.subMapX("Hsb_Layer2Truck");

		CoordSys csLayer2Truck(m.getPoint3d("ptOrg"), m.getVector3d("vecX"),m.getVector3d("vecY"), m.getVector3d("vecZ"));

		Point3d ptLayer = layer.ptOrg();
		ptLayer.vis(2);
		Point3d ptLayerTruck = ptLayer;
		ptLayerTruck.transformBy(csLayer2Truck);
		ptLayerTruck -= _YW * dHeightBedding;
		ptLayerTruck.vis(2);
		
		
		PLine (ptLayer, ptLayerTruck).vis(2);

	// set second grip by layer to truck transformation
		if(_PtG.length()==1)
		{
			_PtG.append(ptLayerTruck); 		
		}
	}	
	
}
//End Grip Management//endregion 

	if(isKlh)
	{ 
	// HSB-17656
		String sLayerSeparation="L (Lagentrennung / Layer separation)";
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel child=(ChildPanel)childs[i];
			TslInst tslItem=(TslInst)childs[i];
			Sip sips[0];
			if(child.bIsValid())
			{
				Sip sip=child.sipEntity();
				sips.append(sip);
			}
			else if(tslItem.bIsValid())
			{ 
				Entity entsItem[]=tslItem.entity();
				for (int ient=0;ient<entsItem.length();ient++) 
				{ 
					Sip sip=(Sip) entsItem[ient];
					if(sip.bIsValid())sips.append(sip);
				}//next ient
			}
		}//next i
	}

// set display
	Display dp(nColor), dpInterference(nColorInterfere);
	dp.lineType(sLineType, dLineTypeScale);
	dp.textHeight(dTxtH);
	dpInterference.lineType(sLineTypeInterfere, dLineTypeScaleInterfere);

//region Collect profiles of childs and order by visible gros area
	// cache the bodies and profiles
	Body bdChilds[0];
	PlaneProfile ppChilds[0],ppChildContours[0] ;
	for (int i=0;i<childs.length();i++) 
	{ 
		Body bd = childs[i].realBody();
		PlaneProfile pp=bd.shadowProfile(pnZ);
		bdChilds.append(bd);
		ppChilds.append(pp);
		pp.removeAllOpeningRings();
		ppChildContours.append(pp);
	}
	
// order by size
	for (int i=0;i<childs.length();i++) 
		for (int j=0;j<childs.length()-1;j++) 
		{
			if (ppChildContours[j].area()<ppChildContours[j+1].area())
			{ 
				childs.swap(j, j + 1);
				bdChilds.swap(j, j + 1);
				ppChildContours.swap(j, j + 1);
				ppChilds.swap(j, j + 1);
			}
		}

//	if (bDebug)
//		for (int i=0;i<childs.length();i++) 
//		{ 
//			PlaneProfile pp = ppChildContours[i];
//			pp.transformBy(vecZ * U(1000));
//			pp.vis(i);	
//		}
//End Collect profiles of childs and order by visible gros area//endregion 
	

// collect stack body and shadow of all nested items and of potential interferences
	Body bdStack;
	PlaneProfile ppItemShadow(csW);
	for (int i=0;i<childs.length();i++) 
	{
		bdStack.combine(bdChilds[i]);
		PlaneProfile pp=ppChilds[i];
		PLine plRings[] = pp.allRings();
		int bIsOp[] = pp.ringIsOpening();

	// display interference	
		PlaneProfile ppInterference=ppItemShadow;
		ppInterference.intersectWith(pp);
		if (ppInterference.area()>pow(dEps,2))
			dpInterference.draw(ppInterference, _kDrawFilled);
		
	// add rings	
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
				ppItemShadow.joinRing(plRings[r],_kAdd);

	// subtract greater openings			
		for (int r=0;r<plRings.length();r++)
			if (bIsOp[r] && plRings[r].area()>pow(U(200),2))
				ppItemShadow.joinRing(plRings[r],_kSubtract);
	}
	
	int bHasPlotViewport=true;
	if(isKlh)bHasPlotViewport=false;
	
	if(isKlh)
	if(truck.bIsValid())
		if (mapContour.length() > 0)
		{
			if (mapContour.getDouble("Thickness") > 0)
			{
				Entity entsTruck[]=truck.entity();
				for (int i=0;i<entsTruck.length();i++)
				{ 
					PlotViewport p=(PlotViewport)entsTruck[i];
					if(p.bIsValid())
					{ 
						bHasPlotViewport=true;
						break;
					}
				}
			}
		}
// set contour by shadow
	PLine plContour = plLayer;
	if (ppItemShadow.area()>pow(dEps,2))
	{
		plContour.createRectangle(ppItemShadow.extentInDir(vecX), vecX, vecY);
		dp.draw(plContour);
		// HSB-19483
		if(bHasPlotViewport)
		if(mapContour.length()>0)
		{ 
			if(mapContour.getDouble("Thickness")>0)
			{ 
				double dThicknessContour=mapContour.getDouble("Thickness");
				PlaneProfile ppOutter(plContour);
				PlaneProfile ppInner(plContour);
				if(!isKlh)
				{ 
					ppOutter.shrink(-.5*dThicknessContour);
					ppInner.shrink(.5*dThicknessContour);
				}
				// HSB-19939: Apply contour thickness on the inside
				if(isKlh)
					ppInner.shrink(dThicknessContour);
				ppOutter.subtractProfile(ppInner);
				dp.draw(ppOutter,_kDrawFilled);
			}
		}
	}
// draw boundaries	
	else
		dp.draw(plLayer);
	//ppItemShadow.vis(3);


// display referenced items
	Point3d ptTxt = _Pt0;
	ptTxt.transformBy(-vecY*dTxtH);
	String sInfo = T("|Layer|") + " "+(_Map.hasInt("Row")?_Map.getInt("Row")+1:"?");
	//if (bDebug)sInfo +=" " + sMyMyUid
	dp.draw(sInfo, ptTxt, vecX, vecY, nAlignment,-1);
	dp.draw(sInformation, ptTxt, vecX, vecY, nAlignment,-4);

	for (int i=0;i<childs.length();i++) 
	{ 
		dp.color(6);
		Entity ent= childs[i]; 
		CoordSys cs;
	
	// get child relation of child
		Map m = ent.subMapX("Hsb_LayerChild");
		Entity entItem;
		entItem.setFromHandle(m.getString("MyUid"));
		setDependencyOnEntity(entItem);
		ptTxt.transformBy(-vecY*2*dTxtH);
		dp.draw(entItem.typeDxfName() + " "+entItem.handle(), ptTxt,vecX, vecY, 1,0);
		//dp.color(i);
		//dp.draw(PLine(ptTxt, m.getPoint3d("ptOrg")));	
	}
	
// display truck ref
	Point3d ptTruckRef = _Pt0;
	if (truck.bIsValid())
	{
		ptTruckRef = truck.ptOrg();
		if (bDebug)
			dp.draw(truck.scriptName() + " "+truck.handle(), _Pt0,vecX, vecY, nAlignment,0);

	
	// draw layer info at grip	
		if (nType==0 && _PtG.length()>0)
			dp.draw(sInfo, _PtG[0], vecX, vecY, 1,0);
		else if(_PtG.length()>0)
			dp.draw(sInfo, _PtG[0], vecY, -vecX, -1.2,0);	
	}
		
		
// store grips absolute
	for (int i=0;i<_PtG.length();i++) 
	{ 
		_Map.setVector3d("vec"+i,_PtG[i]-_PtW); 	 
	}
		

// flag this as layer
	_Map.setInt("isLayer", true);
	_Map.setPLine("plContour", plContour);
	_Map.setBody("bdStack", bdStack);
	_Map.setVector3d("vecPt0", _Pt0-_PtW);

// performance
	if(bDebug)	reportMessage("\n		"+ scriptName()+ " " + sMyMyUid + " ended " + (getTickCount()-nStartTick) + "ms");






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
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
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
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19939: Apply contour thickness on the inside" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="9/12/2023 1:39:34 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18638: Add extra masterOversize extend (-shrink) to the ppMaster, before nesting" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="8/30/2023 11:46:51 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19483: Apply thickness to contour" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="7/10/2023 11:41:56 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18638: Add nesting parameters in xml &quot;Layer&quot;" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="6/26/2023 10:44:37 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18017: Dont write layer separation here" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/20/2023 1:41:55 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17656: write &quot;L&quot; in mapX for layer separation" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="1/24/2023 3:53:32 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End