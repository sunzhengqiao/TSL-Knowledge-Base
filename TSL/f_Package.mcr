#Version 8
#BeginDescription
#Versions:
Version 2.22 22.09.2025 HSB-24602: Add xml parameter "GripDistanceOnInsert" for the definition of text grip , Author: Marsel Nakuci
Version 2.21 21.10.2024 HSB-22813: Fix when saving Datalink  , Author Marsel Nakuci
Version 2.20 10.10.2024 HSB-22794: Provide datalink to the tsl , Author Marsel Nakuci
2.19 09/09/2024 HSB-22608: Add control for group assignment Marsel Nakuci
2.18 27/06/2024 HSB-22319: Change strategy when investigating Top/Bottom flag  Marsel Nakuci
2.17 18/06/2024 HSB-22250: Write specific mapx that contain f_Package to Bottom and top plate Marsel Nakuci
2.16 14/06/2024 HSB-22250: Provide handle for the bottom and top panel in package for KLH Marsel Nakuci
2.15 20.11.2023 HSB-20616: For KLH calculate weight always Author: Marsel Nakuci
2.14 12.09.2023 HSB-19939: Apply contour thickness on the inside 
2.13 10.07.2023 HSB-19483: Apply contour thickness at packages
2.12 28.06.2023 HSB-19334: get from xml flag "PropertyReadOnly" 
2.11 27.06.2023 HSB-19334: On insert set properties ReadOnly for KLH 
2.10 17.02.2023 HSB-17825: provide translation
2.9 03.02.2023 HSB-17789: Draw contour when wrapping is applied 
2.8 20.01.2023 HSB-17551: Modify property "Wrapping" for KLH
HSB-9338 internal variable renaming

Specifies a package in the f_Stacking solution


















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 22
#KeyWords Stacking;Truck;Package;Nesting
#BeginContents
//region PART 1
	
//region History
/// #Versions
// 2.22 22.09.2025 HSB-24602: Add xml parameter "GripDistanceOnInsert" for the definition of text grip , Author: Marsel Nakuci
// 2.21 21.10.2024 HSB-22813: Fix when saving Datalink  , Author Marsel Nakuci
// 2.20 10.10.2024 HSB-22794: Provide datalink to the tsl , Author Marsel Nakuci
// 2.19 09/09/2024 HSB-22608: Add control for group assignment Marsel Nakuci
// 2.18 27/06/2024 HSB-22319: Change strategy when investigating Top/Bottom flag  Marsel Nakuci
// 2.17 18/06/2024 HSB-22250: Write the mapx that contain f_Package to Bottom and top plate Marsel Nakuci
// 2.16 14/06/2024 HSB-22250: Provide handle for the bottom and top panel in package for KLH Marsel Nakuci
// 2.15 20.11.2023 HSB-20616: For KLH calculate weight always Author: Marsel Nakuci
// 2.14 12.09.2023 HSB-19939: Apply contour thickness on the inside Author: Marsel Nakuci
// 2.13 10.07.2023 HSB-19483: Apply contour thickness at packages Author: Marsel Nakuci
// 2.12 28.06.2023 HSB-19334: get from xml flag "PropertyReadOnly" Author: Marsel Nakuci
// 2.11 27.06.2023 HSB-19334: On insert set properties ReadOnly for KLH Author: Marsel Nakuci
// 2.10 17.02.2023 HSB-17825: provide translation Author: Marsel Nakuci
// 2.9 03.02.2023 HSB-17789: Draw contour when wrapping is applied Author: Marsel Nakuci
/// 2.8 20.01.2023 HSB-17551: Modify property "Wrapping" for KLH Author: Marsel Nakuci
/// <version value="2.7" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal variable renaming </version>
///<version value="2.6" date="14apr2020" author="marsel.nakuci@hsbcad.com"> HSB-7032: use for the calculation of weight the entities in f_item </version>
///<version value="2.5" date="07apr2020" author="marsel.nakuci@hsbcad.com"> HSB-7032: write weight in mapX </version>
///<version value="2.4" date="06apr2020" author="marsel.nakuci@hsbcad.com"> HSB-7032: add @(Weight) format </version>
///<version value="2.3" date="31jan2020" author="thorsten.huck@hsbcad.com"> HSB-6527 Wrapping property will be written to stacking property set of defining entity. </version>
/// <version value="2.2" date="04dec2019" author="thorsten.huck@hsbcad.com"> new property 'wrapping' specifies wrapping material. Requires wrapping material definition in settings. </version>
/// <version value="2.1" date="28nov2019" author="thorsten.huck@hsbcad.com"> format resolving enhanced, new context command to add or remove an entry </version>
/// <version value="2.0" date="28may2019" author="thorsten.huck@hsbcad.com"> bugfix sequential colors </version>
/// <version value="1.9" date="08mar2019" author="thorsten.huck@hsbcad.com"> removing items from the package improved </version>
/// <version value="1.8" date="07mar2019" author="thorsten.huck@hsbcad.com"> drawn on Information-Layer </version>
/// <version value="1.7" date="07feb2019" author="thorsten.huck@hsbcad.com"> parent/child naming changed, NOTE: do not update existing entities </version>
/// <version value="1.6" date="20mar2018" author="thorsten.huck@hsbcad.com"> stacking properties not translated for special=0 </version>
/// <version value="1.5" date="20feb2018" author="thorsten.huck@hsbcad.com"> bugfix property set updated, width and height swapped for horizontal stacking </version>
/// <version value="1.4" date="09feb2018" author="thorsten.huck@hsbcad.com"> property set only updated, but not appended or modified </version>
/// <version value="1.3" date="31jan2018" author="thorsten.huck@hsbcad.com"> guide line and multiline behaviour enhanced </version>
/// <version value="1.2" date="30jan2018" author="thorsten.huck@hsbcad.com"> new tagging </version>
/// <version value="1.1" date="30jan2018" author="thorsten.huck@hsbcad.com"> packages can be moved in X-direction via base grip </version>
/// <version value="1.0" date="23aug2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select stacking items, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a package based on items of a truck.
/// </summary>
//End History//endregion 
	
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
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int isKlh=sProjectSpecial=="KLH";
	String kDataLink = "DataLink", kData="Data",kScript="f_Package";
	String tDisabled = T("<|Disabled|>"),tDefaultEntry = T("<|Default|>"), tNoGroupAssignment =T("|No group assigment|");
	String sGroupings[] = { tDefaultEntry, tNoGroupAssignment};
//end constants//endregion
	
//region Variables
// performance test
	int nTick= getTickCount();
	
// get special
	String sSpecials[] ={ "KLH"};
	int nSpecial;
	for (int i=0;i<sSpecials.length();i++) 
	{ 
		if (projectSpecial().find(sSpecials[i],0)>-1)
		{
			nSpecial = i;
			break; 
		} 
	}
	
// stacking family key words
	String sItemX="Hsb_Item";
	String sPackageX="Hsb_Package";
	String sLayerParent="Hsb_LayerParent";
	String sTruckKey="Hsb_TruckParent";
	String sGridKey="Hsb_GridParent";
	String sPackageParent="Hsb_PackageParent";
	String sPropsetName="Stacking";
	
	String sTypes[]={T("|Horizontal|"), T("|Vertical|")};
	
	String sPropsetProperties[]={"Number","Name","Type","Design","Layer Index","Package Number","Package Wrapping"};
	int nPropsetPropertyTypes[]={1,0,0,0,1,1,0};// 0 = string, 1 = int, 2 = double
// translate property names. note this could cause issues when using alternating languages
	if (nSpecial<0)
		for (int i=0;i<sPropsetProperties.length();i++) 
			sPropsetProperties[i]=T("|"+sPropsetProperties[i]+"|"); 
	
// default parameters
	int nColor = 12;
	double dLineThicknessGrid = U(30),dLineThicknessTruck = U(30);
	int nTransparencyGrid = 90,nTransparencyTruck = 60;
	String sLineTypeGrid = "CONTINUOUS", sLineTypeTruck = "CONTINUOUS";
	double dLineTypeScaleGrid= U(1), dLineTypeScaleTruck= U(1);
	double dTextHeight = U(100);
	String sDimStyle;
	double dMaxBedding;
	int nSeqColors[0];
	int nPropertyReadOnly;
	// HSB-19483 map containing contour properties like thickness
	Map mapContour;
//End Variables//endregion 

//region Functions
	//region visPpTransform
	// visualises a planeprofile by moving it
	void visPpTransform(PlaneProfile _pp,Vector3d _vTransform,int _nColor)
	{ 
		PlaneProfile _ppcp = _pp;
		_ppcp.transformBy(_vTransform);
		_ppcp.vis(_nColor);
		return;
	}
//End visPpTransform//endregion 

//region getBottomTopItems
// this will flag the items if they are
// bottom top plate
Map getBottomTopItems(Body _bds[])
{ 
	// it will return tag for each item on list
	// tag can be BottomPanel or TopPanel
	// there will be map for each item
	Map _m;
	
	PlaneProfile ppXs[0], ppZs[0];
	Point3d ptCens[0];
	Vector3d _vUp = _YW;
	for (int i=0;i<_bds.length();i++) 
	{ 
		Body _bdI=_bds[i];
		Point3d _ptcI=_bdI.ptCen();
		_bdI.vis(3);
		ppZs.append(_bdI.shadowProfile(Plane(_ptcI,_vUp)));
		ppXs.append(_bdI.shadowProfile(Plane(_ptcI,_XW)));
		ptCens.append(_ptcI);
	}//next i
	
	for (int i=0;i<_bds.length();i++) 
	{ 
//		TslInst _itemI=_items[i];
		
		Map mi;
		int bTopI=true;
		int bBottI=true;
		
		PlaneProfile _ppZi=ppZs[i];
		PlaneProfile _ppXi=ppXs[i];
		for (int j=0;j<_bds.length();j++) 
		{ 
			if(i==j)
			{
				continue;
			}
			
			PlaneProfile _ppZj=ppZs[j];
			PlaneProfile _ppXj=ppXs[j];
			//
			PlaneProfile ppInterZ=_ppZi;
			PlaneProfile ppInterX=_ppXi;
			if(!ppInterZ.intersectWith(_ppZj))
			{ 
				continue;
			}
			if(_bds[i].volume()<pow(dEps,3))
			{ 
				bBottI=false;
				bTopI=false;
			}
			// intersect in top view
			// it is above or below
			if(_vUp.dotProduct(ptCens[i]-ptCens[j])>U(1))
			{ 
				// it is below
				bBottI=false;
			}
			if(_vUp.dotProduct(ptCens[j]-ptCens[i])>U(1))
			{ 
				// it is above
				bTopI=false;
			}
			if(!bBottI && !bTopI)
			{ 
				break;
			}
		}//next j
	// write the flag
		mi.setInt("Top", bTopI);
		mi.setInt("Bottom", bBottI);
		_m.appendMap("m", mi);
	}//next i
	
	return _m;
}
//End getBottomTopItems//endregion

//region Function getTslsByName
	// returns the amount of all tsl instances with a certain scriptname and modifis the input array
	// tsls: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned
	int getTslsByName(TslInst& tsls[], String names[])
	{ 
		int out;
		
		if (tsls.length()<1)
		{ 
			Entity ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i]; 
				//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)>-1)
					tsls.append(t);
			}//next i
		}
		else
		{ 
			for (int i=tsls.length()-1; i>=0 ; i--) 
			{ 
				TslInst t= (TslInst)tsls[i]; 
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)<0)
					tsls.removeAt(i);
			}//next i			
		}
		
		out = tsls.length();
		return out;
	}
//End getTslsByName //endregion	

//End Functions//endregion 

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
	Map mapPackage;
	String sWraps[] ={};
	{
		String k;
		Map m = mapSetting.getMap("Package");
		mapPackage=m;
		
		k="Color";				if (m.hasInt(k))	nColor = m.getInt(k);
		k="DimStyle";			if (m.hasString(k))	sDimStyle= m.getString(k);
		k="TextHeight";			if (m.hasDouble(k))	dTextHeight= m.getDouble(k);
		// HSB-19483
		k="Contour"; if (m.hasMap(k)) mapContour=m.getMap(k);
		
		{ 
			String disabled = T("<|Disabled|>");
			// HSB-17551
			if(isKlh)disabled=sNoYes[0];
			Map mapWraps= m.getMap("Wrap[]");
			for (int i=0;i<mapWraps.length();i++) 
			{ 
				Map mapWrap = mapWraps.getMap(i);
				// HSB-17825: provide translation
				String name = T(mapWrap.getString("Name"));
				if (name.length()>0 && sWraps.findNoCase(name,-1)<0 && name.find(disabled,0,false)<0)
					sWraps.append(name); 
			}//next i
			sWraps.insertAt(0, disabled);
		}
		
	// prefer package sequential colors
		Map mapColors = mapSetting.getMap("Package\\SequentialColor[]");
	// if nothing found try truck sequential colors
		if (mapColors.length()<1)mapColors= mapSetting.getMap("Truck\\SequentialColor[]");	
		for (int i=0;i<mapColors.length();i++) 
			nSeqColors.append(mapColors.getInt(i)); 	 
		
		m = mapSetting.getMap("Package\\Grid");
		k="Linetype";			if (m.hasString(k))	sLineTypeGrid= m.getString(k);		
		k="LinetypeScale";		if (m.hasDouble(k))	dLineTypeScaleGrid= m.getDouble(k);	
		k="Transparency";		if (m.hasInt(k))	nTransparencyGrid= m.getInt(k);	
		k="LineThickness";		if (m.hasDouble(k))	dLineThicknessGrid= m.getDouble(k);	
		
		m = mapSetting.getMap("Package\\Truck");
		k="Linetype";			if (m.hasString(k))	sLineTypeTruck= m.getString(k);		
		k="LinetypeScale";		if (m.hasDouble(k))	dLineTypeScaleTruck= m.getDouble(k);	
		k="Transparency";		if (m.hasInt(k))	nTransparencyTruck= m.getInt(k);
		k="LineThickness"; if (m.hasDouble(k)) dLineThicknessTruck= m.getDouble(k);
		
	// get propertyset name
		m=mapSetting.getMap("SourceEntity");
		k="PropsetName"; if (m.hasString(k)) sPropsetName= m.getString(k);
		k="PropertyReadOnly"; if (m.hasInt(k)) nPropertyReadOnly= m.getInt(k);
	}
	// HSB-22608: Global Settings
	String sTriggerGlobalSetting = T("|Global Settings|");
	String kGlobalSettings = "GlobalSettings", kGroupAssignment= "GroupAssignment";
	int nGroupAssignment;
	Map mapGlobalSettings = mapPackage.getMap(kGlobalSettings);
	if (mapGlobalSettings.hasInt(kGroupAssignment))
		nGroupAssignment = mapGlobalSettings.getInt(kGroupAssignment);	
//End Read Settings//endregion 
		
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode==4)
	{ 
		setOPMKey("GlobalSettings");	
		
		String sGroupAssignmentName=T("|Group Assignment|");	
		PropString sGroupAssignment(nStringIndex++, sGroupings, sGroupAssignmentName);	
		sGroupAssignment.setDescription(T("|Defines to layer to assign the instance|, ") + tDefaultEntry + T(" = |byEntity|"));
		sGroupAssignment.setCategory(category);
		return;
	}	

//region PROPERTIES
	String sNumberName=T("|Number|");	
	PropInt nNumber(nIntIndex++, 0, sNumberName);	
	nNumber.setDescription(T("|Defines the package number|") + " " + T("|0 = next free number|"));
	nNumber.setCategory(category);
	
	String sInformationName=T("|Information|");	
	PropString sInformation(nStringIndex++, "", sInformationName);	
	sInformation.setDescription(T("|Defines the Information|")+TN("\\n   |separates multiple lines|"));
	sInformation.setCategory(category);
	
	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + TN("|Syntax and keywords|") +
		"\n   @("+T("|Formatinstruction <optional parameter>|) ") +
		TN("   \\P   |separates multiple lines|")+
		TN("|Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);
	
	String sStyleName=T("|Style|");	
	String sStyles[] = {T("|Text only|"), T("|Border|"), T("|Filled Frame|")};
	PropString sStyle(nStringIndex++, sStyles, sStyleName,0);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);	
	
	String sWrapName=T("|Wrapping|");
	PropString sWrap(nStringIndex++, sWraps, sWrapName);	
	sWrap.setDescription(T("|Defines the wrapping of the package.|") + (sWraps.length()==1?T("|NOTE: Please specify wrapping materials in settings definition.|"):""));
	sWrap.setCategory(category);
//End PROPERTIES//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		if(isKlh || nPropertyReadOnly)
		{ 
		// HSB-19334: set properties ReadOnly
			sAttribute.setReadOnly(_kReadOnly);
			sStyle.setReadOnly(_kReadOnly);
//			sWrap.setReadOnly(_kReadOnly);
			_Map.setInt("readOnly",true);
		}
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
		
	// add only items with the same truck reference
		Entity items[0];
		Entity truck;
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
		// validate item
			Entity item = ents[i];
			Entity entRef;
			entRef.setFromHandle(item.subMapX(sItemX).getString("MyUid"));
			if (!entRef.bIsValid())
			{
				continue;
			}
			if(bDebug)reportNotice("\nitem " + item.handle());
			
		// validate layer
			Entity layer;
			layer.setFromHandle(item.subMapX(sLayerParent).getString("MyUid"));
			if (!layer.bIsValid())
			{
				continue;
			}
			if(bDebug)reportNotice("\nlayer " + layer.handle());
		// validate truck
			Entity _truck;
			_truck.setFromHandle(layer.subMapX(sGridKey).getString("MyUid"));
			if (!_truck.bIsValid())
			{
				continue;
			}
			if(bDebug)reportNotice("\ntruck " + _truck.handle());
			
		// assign first valid truck to compare other truck refs	
			if (!truck.bIsValid())
				truck = _truck;
		
		// validate this truck against first assigned
			if (truck!=_truck)	
			if (!_truck.bIsValid())
			{
				continue;
			}			
		
		// all tests passed - use these items to build a package
			items.append(item);
		}
	
	// validate selection set
		if (items.length()<1)
			eraseInstance();
		else
			_Entity = items;
		
	// store reference to truck 
		_Map.setEntity("truck", truck);
		
		return;
	}	
// end on insert	__________________//endregion
	
//End PART 1//endregion 
	
//region Basics
// get entity coordSys
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ= _ZW;
	Point3d ptOrg = _PtW;
	CoordSys csRef(ptOrg, vecX, vecY, vecZ);
	Plane pnZ(ptOrg, vecZ);
	Plane pnY(ptOrg, vecY);

	_ThisInst.setDrawOrderToFront(true);
	setCompareKey(_ThisInst.handle());
	
// set myUID
	String sMyUID = _ThisInst.handle();
	
	int nStyle = sStyles.find(sStyle);
	
// set parent reference to child items
	if (_bOnDbCreated)
	{
		for (int i=_Entity.length()-1;i>=0;i--)	
		{
			Entity item = _Entity[i];
			if (!item.bIsValid())
			{ 
				continue;
			}
		// write parent data to child	
			Map m;
			m.setString("ParentUid", sMyUID);
			m.setPoint3d("ptOrg", _Pt0, _kRelative);
			m.setVector3d("vecX", vecX, _kScalable); // coordsys carries size
			m.setVector3d("vecY", vecY, _kScalable);
			m.setVector3d("vecZ", vecZ, _kScalable);
			item.setSubMapX(sPackageParent,m);// (over)write submapX
		}
		setExecutionLoops(2);
	}		
//End Basics//endregion 
	
//region group assignment
// HSB-22608
//region Trigger GlobalSettings
{ 
	// create TSL
	TslInst tslDialog; 			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	addRecalcTrigger(_kContext, sTriggerGlobalSetting);
	if (_bOnRecalc && _kExecuteKey==sTriggerGlobalSetting)	
	{ 
		mapTsl.setInt("DialogMode",4);
		
		String groupAssignment = sGroupings.length()>nGroupAssignment?sGroupings[nGroupAssignment]:tDefaultEntry;
		sProps.append(groupAssignment);

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				groupAssignment = tslDialog.propString(0);
				nGroupAssignment = sGroupings.findNoCase(groupAssignment, 0);
				
				Map m = mapPackage.getMap(kGlobalSettings);
				m.setInt(kGroupAssignment, nGroupAssignment);								
				mapPackage.setMap(kGlobalSettings, m);
				mapSetting.setMap("Package", mapPackage);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		
	// trigger other instances	to update their layer assignment
		if (nGroupAssignment == 1)
		{
			assignToLayer("0");	
			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
			
			TslInst tsls[0];
			String names[] ={ scriptName()};
			int n = getTslsByName(tsls, names);
			for (int i = 0; i < n; i++)
			{
				TslInst tsl = tsls[i];
				Map m = tsl.map();
				m.setInt("setLayer", true);
				tsl.setMap(m);
				tsl.recalc();
			}//next i
		}
		
		setExecutionLoops(2);
		return;	
	}
	//endregion	
}
//End Dialog Trigger//endregion 

//	if(nGroupAssignment==0)
//	{ 
//		assignToGroups(gb);
//		if(gb1.bIsValid())
//		{ 
//			assignToGroups(gb1);
//			Element el=gb.element();
//			Element el1=gb1.element();
//			if(el.bIsValid() && el1.bIsValid())
//			{ 
//				assignToLayer("0");
//				int nz=gb.myZoneIndex();
//				int nz1=gb1.myZoneIndex();
//				
//				assignToElementGroup(el,true,nz,'Z');
//				assignToElementGroup(el1,false,nz1,'Z');
//			}
//		}
//	}
//	else if (nGroupAssignment==1)
	if (nGroupAssignment==1)
	{ 
		int bSetLayer = _Map.getInt("setLayer");
		if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
		{ 
//			reportNotice("\nflag =" +  bSetLayer);
			assignToLayer("0");
			_Map.removeAt("setLayer", true);
		}
	}
//End group assignment//endregion 
	
//region Trigger add or remove items
// Trigger AddItems
	String sTriggerAddItems = T("|Add Items|");
	addRecalcTrigger(_kContext, sTriggerAddItems );
// Trigger RemoveItems
	String sTriggerRemoveItems = T("|Remove Items|");
	addRecalcTrigger(_kContext, sTriggerRemoveItems );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddItems || _kExecuteKey==sDoubleClick || _kExecuteKey==sTriggerRemoveItems ))
	{
	// prompt for items
		Entity ents[0];
		PrEntity ssE(T("|Select item(s)|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());		
		
	// validate items
		for (int i = ents.length() - 1; i >= 0; i--)
		{
			Entity item = ents[i];
			Entity entRef;
			entRef.setFromHandle(item.subMapX(sItemX).getString("MyUid"));
			if ( ! entRef.bIsValid())
				ents.removeAt(i);
		}

		for (int i=0;i<ents.length();i++) 
		{ 
			Entity item = ents[i];
			int n = _Entity.find(ents[i]);
		// remove
			if (n>-1 && _kExecuteKey==sTriggerRemoveItems)
			{
			// remove parent data against this package
				item.removeSubMapX(sPackageParent);
				_Entity.removeAt(n);
			}
		// add
			else if (n<0 && _kExecuteKey!=sTriggerRemoveItems)
			{	
				_Entity.append(item);
				
			// write parent data to child	
				Map m;
				m.setString("ParentUid", sMyUID);
				m.setPoint3d("ptOrg", _Pt0, _kRelative);
				m.setVector3d("vecX", vecX, _kScalable); // coordsys carries size
				m.setVector3d("vecY", vecY, _kScalable);
				m.setVector3d("vecZ", vecZ, _kScalable);
				item.setSubMapX(sPackageParent,m);// (over)write submapX				
			}
		}		
	
		setExecutionLoops(2);
		return;
	}		
//End Trigger add or remove items//endregion 
	
	if(isKlh || nPropertyReadOnly)
	{ 
		int nReadOnly=!_Map.getInt("readOnly");
		if(nReadOnly)
		{ 
			sAttribute.setReadOnly(_kReadOnly);
			sStyle.setReadOnly(_kReadOnly);
		}
		else
		{ 
			sAttribute.setReadOnly(false);
			sStyle.setReadOnly(false);
		}
		String sTriggerblockProperties = T("|Unblock Properties|");
		if(!nReadOnly)
			sTriggerblockProperties = T("|Block Properties|");
		addRecalcTrigger(_kContextRoot, sTriggerblockProperties);
		if (_bOnRecalc && _kExecuteKey==sTriggerblockProperties)
		{
			_Map.setInt("readOnly",nReadOnly);
			setExecutionLoops(2);
			return;
		}//endregion
	}
	
//region collect items and its references
// collect items and its references
	TslInst items[0];
	Entity entRefs[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent = _Entity[i], entRef;
		entRef.setFromHandle(ent.subMapX(sItemX).getString("MyUid"));
		if (entRef.bIsValid())	
			entRefs.append(entRef);
		else{continue;}
		
		TslInst item = (TslInst)ent;	
		items.append(item); 
		setDependencyOnEntity(item);
	}

// declare and get truck from UID of package
	TslInst truck; 
	if (!truck.bIsValid())
	{ 
		Entity ent;
		ent.setFromHandle(_ThisInst.subMapX(sTruckKey).getString("MyUid"));
		if (ent.bIsValid())
		{
			truck = (TslInst)ent;
			if(bDebug)reportNotice(TN("|truck =| ") + truck.handle());
			if(nGroupAssignment==0)
			{
				assignToGroups(truck, 'I');
			}
		}
	}
	
	//reportMessage("\n Truck " + truck.opmName());		
//End collect items and its references//endregion 
	
// on the event of dragging _Pt0
	if (_kNameLastChangedProp=="_Pt0")
	{ 
		Point3d ptPrev = _PtW + _Map.getVector3d("vecLocation");
		double dX = _XW.dotProduct(_Pt0 - ptPrev);
		double dY = _YW.dotProduct(_Pt0 - ptPrev);
		
		for (int i=0;i<items.length();i++) 
		{ 
			items[i].transformBy(_XW*dX); 
		}
		_Pt0.setY(ptPrev.Y());
		_Map.setVector3d("vecLocation", _Pt0- _PtW);
		setExecutionLoops(2);
		return;
	}
	
	
//region Collect outlines
	Point3d ptsAll[0];
	PlaneProfile ppGrid(csRef),ppTruck(csRef);
	Map mapXtsl;// contains handle for top and bottom panel
	mapXtsl.setString("BottomPanel","!_Unterste Platte im Paket_!");
	mapXtsl.setString("TopPanel","-Oberste Platte im Paket-");
	_ThisInst.setSubMapX("InternalMapX",mapXtsl);
	
	
	Body bdItems[0];
	for (int i=0;i<items.length();i++) 
	{ 
		TslInst item = items[i];
		Body bd = item.realBody();
		bd.vis(1);
		_ZW.vis(bd.ptCen());
	// grid view
		PlaneProfile pp = bd.shadowProfile(Plane(ptOrg, vecZ));
		
		PLine plRings[] = pp.allRings();
		int bIsOp[] = pp.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
			{
				PLine pl;
				pl.createConvexHull(pnZ, plRings[r].vertexPoints(true));
				ppGrid.joinRing(pl,_kAdd);
				if (dLineThicknessGrid>dEps)
				{ 
					pp = PlaneProfile(pl);
					pp.shrink(dLineThicknessGrid);
					ppGrid.subtractProfile(pp);					
				}
			}
			
	// truck view
	// validate layer
		Entity layer;
		layer.setFromHandle(item.subMapX(sLayerParent).getString("MyUid"));
		if (!layer.bIsValid())
		{
			continue;
		}
		double dBeddingHeight = ((TslInst)layer).propDouble(0);
		dMaxBedding = dMaxBedding > dBeddingHeight ?dMaxBedding: dBeddingHeight;

	// validate and/or assign truck
		if (!truck.bIsValid())
		{
			Entity grid;
			grid.setFromHandle(layer.subMapX(sGridKey).getString("MyUid"));
			if (grid.bIsValid())
			{
				TslInst _grid = (TslInst)grid;
				Entity ents[] = _grid.entity();
				for (int i=0;i<ents.length();i++) 
				{ 
					Entity e= ents[i]; 
					if (e.subMapXKeys().find(sTruckKey)>-1)
					{
			
			//			Map m = _ThisInst.subMapX(sTruckKey);
			//			Entity e;
			//			e.setFromHandle(m.getString("MyUid"));
						truck =(TslInst)e;	
						//mapTruck=truck.map();
						setDependencyOnEntity(truck);
						
						if (truck.bIsValid())
						{
							Map m;
							m.setString("MyUid",truck.handle());
							m.setPoint3d("ptOrg", _Pt0, _kRelative);
							m.setVector3d("vecX", vecX, _kScalable); // coordsys carries size
							m.setVector3d("vecY", vecY, _kScalable);
							m.setVector3d("vecZ", vecZ, _kScalable);	
							_ThisInst.setSubMapX(sTruckKey,m);// (over)write submapX			
						}	
						break;
					}		
				}				
			}

			//Entity _truck;
			//_truck.setFromHandle(layer.subMapX(sGridKey).getString("MyUid"));
//			if (_truck.bIsValid())
//			{
//				Map m;
//				m.setString("MyUid",_truck.handle());
//				m.setPoint3d("ptOrg", _Pt0, _kRelative);
//				m.setVector3d("vecX", vecX, _kScalable); // coordsys carries size
//				m.setVector3d("vecY", vecY, _kScalable);
//				m.setVector3d("vecZ", vecZ, _kScalable);	
//				_ThisInst.setSubMapX(sTruckKey,m);// (over)write submapX			
//			}
		}
		
	// get layer2truck transformation
		int row=-1;
		CoordSys cs2Truck;
		Map m =layer.subMapX("Hsb_Layer2Truck");
		if (m.length()>0)
		{
			cs2Truck=CoordSys(m.getPoint3d("ptOrg"), m.getVector3d("vecX"), m.getVector3d("vecY"), m.getVector3d("vecZ"));	
			row = m.getInt("row");	
		}
		else
		{
			bdItems.append(Body());
			continue;
		}
		//HSB-22250
//		if(isKlh)
//		{ 
//			if(row==0)
//			{ 
//				// first, bottom
//				// attach the tsl
//				Map mapXdata;
//				mapXdata.setEntity(kScript,_ThisInst);
//				entRefs[i].setSubMapX("BOTTOMPANEL",mapXdata);
//			}
//			if(row==items.length()-1)
//			{ 
//				// last, top
//				Map mapXdata;
//				mapXdata.setEntity(kScript,_ThisInst);
//				entRefs[i].setSubMapX("TOPPANEL",mapXdata);
//			}
//			if(row!=0 && row!=items.length()-1)
//			{ 
//				entRefs[i].removeSubMapX("TOPPANEL");
//				entRefs[i].removeSubMapX("BOTTOMPANEL");
//			}
//		}
		
		pp=bd.shadowProfile(Plane(ptOrg, vecY));
		pp.transformBy(cs2Truck);
		visPpTransform(pp, vecZ * U(300), 6);
		plRings = pp.allRings();
		bIsOp = pp.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
			{
				PLine pl;
				pl.createConvexHull(pnZ, plRings[r].vertexPoints(true));
				ppTruck.joinRing(pl,_kAdd);
//				if (dLineThicknessGrid>dEps)
//				{ 
//					pp = PlaneProfile(pl);
//					pp.shrink(dLineThicknessGrid);
//					ppTruck.subtractProfile(pp);					
//				}
			}	
			
	// get all vertices and transform to truck view, later on get package sizes from it
		bd.transformBy(cs2Truck);
		bdItems.append(bd);
		ptsAll.append(bd.extremeVertices(vecX));
		ptsAll.append(bd.extremeVertices(vecY));	
		ptsAll.append(bd.extremeVertices(vecZ));

		//bd.vis(4);	
	}


	Map mBottomTopFlags;
	if(isKlh)
	{
		Map _mBottomTopFlags=getBottomTopItems(bdItems);
		mBottomTopFlags=_mBottomTopFlags;
		int bOk=true;
		if(entRefs.length()!=mBottomTopFlags.length())
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Unexpected: Top/Bottom flags not OK|"));
			bOk=false;
		}
		if(bOk)
		{ 
			for (int e=0;e<entRefs.length();e++) 
			{ 
				Map mE=mBottomTopFlags.getMap(e);
				Map mapXdata;
				mapXdata.setEntity(kScript,_ThisInst);
				if(mE.getInt("Bottom"))
				{ 
					// first, bottom
					// attach the tsl
					entRefs[e].setSubMapX("BOTTOMPANEL",mapXdata);
				}
				else
				{ 
					entRefs[e].removeSubMapX("BOTTOMPANEL");
				}
				if(mE.getInt("Top"))
				{ 
					// last, top
					entRefs[e].setSubMapX("TOPPANEL",mapXdata);
				}
				else
				{ 
					entRefs[e].removeSubMapX("TOPPANEL");
				}
				// HSB-22813: Fix when changing Datalink 
				// HSB-22794: always provide datalink
				Map mapX;
				String sKeys[]=entRefs[e].subMapXKeys();
				if(sKeys.findNoCase(kDataLink,-1)>-1)
					mapX=entRefs[e].subMapX(kDataLink);
				mapX.setEntity(kScript,_ThisInst);
				entRefs[e].setSubMapX(kDataLink,mapX);
			}//next e
		}
	}
//End Collect outlines//endregion 
	
	
//region Set number on dbCreated or on lastPropNameChanged
	if (_ThisInst.bIsValid() && (nNumber<=0 || _kNameLastChangedProp==sNumberName) && truck.bIsValid())
	{ 
		//reportMessage("\n"+ scriptName() + " truck is valid="+ truck.bIsValid() +" _kNameLastChangedProp:" + _kNameLastChangedProp);	
	
	// collect all packages assigned to this truck
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			String uid = ents[i].subMapX(sTruckKey).getString("MyUid");
			if (uid.length()<1 || _ThisInst == ents[i])
			{ 
				ents.removeAt(i);
				continue;
			}
			Entity _truck;
			_truck.setFromHandle(uid);
			if (!_truck.bIsValid() || truck!=_truck)
			{ 
				ents.removeAt(i);
			}
		}
		
	// collect existing posnums	
		int nAllPos[0], nNextFree, nThisNumber=nNumber>0?nNumber:1;
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst package = (TslInst)ents[i]; 
			if (package.bIsValid())
			{ 
				int pos = package.propInt(0);
				if (pos>0)
					nAllPos.append(pos);	
			} 
		}
		
	// find next free	
		for (int i=0;i<=nAllPos.length();i++) 
		{ 
			int n = nAllPos.find(nThisNumber);
			if (n<0)
			{ 
				_ThisInst.setPropInt(0,nThisNumber);
				_ThisInst.recalc();
				break;
			}
			else
				nThisNumber++;		 
		}
		
		//reportMessage("\n"+ scriptName() + " truck has other packages="+ ents.length() + " number set to " +_ThisInst.propInt(0));
	}
	
// set sequential color in dependency of package number
	if (nNumber>0)
	{ 
	// set the color
		nColor = nNumber;
		if (nSeqColors.length()>0)
		{
			int n=nNumber;
			while(n>nSeqColors.length()-1)
				n-=nSeqColors.length();
			nColor=nSeqColors[n];
			//reportNotice("\n n " + n + " c " + c);
		}
	}	
//End Set number on dbCreated or on lastPropNameChanged//endregion 


//region get list of available object variables
	Entity ents[] ={ _ThisInst};
	if (truck.bIsValid())ents.append(truck);
	
	String sObjectVariables[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		String _sObjectVariables[0];
		_sObjectVariables.append(ents[i].formatObjectVariables());
		
	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
		{
			String sVariable =_sObjectVariables[j];
			if (i==1)
			{ 
				if (sVariable.find("Project",0,false)>-1 || sVariable.find("Group",0,false)>-1 || sVariable.find("Element",0,false)>-1)
				{	continue;}
				else
					sVariable = "Truck."+sVariable;	
			}
			if(sObjectVariables.find(sVariable)<0)
				sObjectVariables.append(sVariable); 
		}
				
	}//next

//region add custom variables
	for (int i=0;i<ents.length();i++)
	{ 
		String k;
		//k = "Calculate Weight"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "Weight"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "Quantity"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		k = "Length"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "Width"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "Height"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
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
//End add custom variables//endregion 


//End get list of available object variables//endregion 

//region Trigger AddRemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );

	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|0 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String value;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
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
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sAttribute;
	
			// get variable	and append if not already in list	
				String sVariable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sAttribute.find(sVariable, 0);
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
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
//endregion 


// displays
	Display dpTruck(nColor), dpGrid(nColor), dpTxt(nColor);
	dpGrid.lineType(sLineTypeGrid,dLineTypeScaleGrid>0?dLineTypeScaleGrid:1);	
	dpTruck.lineType(sLineTypeTruck,dLineTypeScaleTruck>0?dLineTypeScaleTruck:1);
	dpTxt.dimStyle(sDimStyle);
	double dFactor = 1;
	double dTextHeightStyle = dpTxt.textHeightForStyle("O",sDimStyle);	
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dpTxt.textHeight(dTextHeight);
	}
	dTextHeightStyle=dTextHeightStyle<U(10)?U(10):dTextHeightStyle;	

// predefined mode package
	String sLines[0];
	// weight of the package
	double dWeight;
//region Resolve Format
{ 	
	String sValues[0];	
	String s=  _ThisInst.formatObject(sAttribute);

	int left= s.find("\\P",0);
	while(left>-1)
	{
		sValues.append(s.left(left));
		s = s.right(s.length() - 2-left);
		left= s.find("\\P",0);
	}
	sValues.append(s);	
	
// resolve unknown
	//reportMessage("\n"+ scriptName() + " values i "+i +" " + sValues);
	
	String sDimensions[] ={ "@(LENGTH)", "@(WIDTH)", "@(HEIGHT)"};
	Vector3d vecDimensions[] ={_XW,_ZW,_YW};
	
	if(isKlh)
	{ 
	// HSB-20616: calc weight for klh
		Map mapIO,mapEntities;
//		mapEntities.appendEntity("Entity", _ThisInst);
		for (int ii=0;ii<_Entity.length();ii++) 
		{ 
			// see if it is an f_item and get its entities
			TslInst tslII = (TslInst)_Entity[ii];
			if (tslII.bIsValid() && tslII.scriptName().makeUpper() == "F_ITEM")
			{ 
				// get entities of f_item
				Entity ents[] = tslII.entity();
				for (int jj=0;jj<ents.length();jj++) 
				{ 
					mapEntities.appendEntity("Entity", ents[jj]);
				}//next jj
			}
//							mapEntities.appendEntity("Entity", _Entity[ii]);
		}//next i
		
		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
	}
	
	for (int v= 0; v < sValues.length(); v++)
	{
		String& value = sValues[v];
		int left = value.find("@(", 0);
	// get formatVariables and prefixes
		if (left>-1)
		{ 
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

//					if (sVariable=="@(CALCULATE WEIGHT)")
					if (sVariable == "@(WEIGHT)")
					{
						Map mapIO,mapEntities;
//						mapEntities.appendEntity("Entity", _ThisInst);
						for (int ii=0;ii<_Entity.length();ii++) 
						{ 
							// see if it is an f_item and get its entities
							TslInst tslII = (TslInst)_Entity[ii];
							if (tslII.bIsValid() && tslII.scriptName().makeUpper() == "F_ITEM")
							{ 
								// get entities of f_item
								Entity ents[] = tslII.entity();
								for (int jj=0;jj<ents.length();jj++) 
								{ 
									mapEntities.appendEntity("Entity", ents[jj]);
								}//next jj
							}
//							mapEntities.appendEntity("Entity", _Entity[ii]);
						}//next i
						
						mapIO.setMap("Entity[]",mapEntities);
						TslInst().callMapIO("hsbCenterOfGravity", mapIO);
						dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
						
						String sTxt;
						if (dWeight<10)
							sTxt.formatUnit(dWeight, 2,1);			
						else
							sTxt.formatUnit(dWeight, 2,0);
						sTxt = sTxt + " kg";						
						sTokens.append(sTxt);
					}
					if (sVariable=="@(QUANTITY)")
					{
						sTokens.append(_ThisInst.entity().length());		
					}
					else if (sDimensions.findNoCase(sVariable,-1)>-1)
					{ 
						Vector3d vec = vecDimensions[sDimensions.findNoCase(sVariable,-1)];
						Point3d pts[]= Line(_Pt0, vec).orderPoints(ptsAll);
						double d;
						if (pts.length()>0)
							d = abs(vec.dotProduct(pts.last()-pts.first()));	
						
						String out;
						int nNumDecimal = 0; //TODO 
						out.formatUnit(d, 2, nNumDecimal);
						sTokens.append(out);
					}
					//						
//						if (pts.length()>1)	
//						{
//							dValue =abs(vecs[n-2].dotProduct(pts[0]-pts[pts.length()-1]));
					
					
//						else if (g.bIsValid() && g.bIsKindOf(Beam()))
//						{ 
//							Beam beam = (Beam)g;
//							if (sVariable=="@(SURFACE QUALITY)") sTokens.append(beam.texture());
//						}
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
		//sAppendix += value;
		sLines.append(value);
	}		
}
//End Resolve Format//endregion 

// draw grid outlines
// draw contour as rings
	if (nTransparencyGrid>0 && nTransparencyGrid<100)
		dpGrid.draw(ppGrid, _kDrawFilled, nTransparencyGrid);
// draw solid
	else if (nTransparencyGrid==0)
		dpGrid.draw(ppGrid, _kDrawFilled);
// draw contour wireframe
	else
		dpGrid.draw(ppGrid);

// set _Pt0
// get extents of profile
	LineSeg seg = ppTruck.extentInDir(vecX);
	Point3d ptCen = seg.ptMid();
	if (_bOnDbCreated)
	{
		
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		
		_Pt0=ptCen-.5*(vecX*dX+vecY*dY);
	}
	
	_Pt0.setZ(0);
	if (_PtG.length()<1)
	{
		_PtG.append(ptCen);
		// HSB-24602
		if(mapPackage.hasDouble("GripDistanceOnInsert"))
		{ 
			double dGripDistanceOnInsert=mapPackage.getDouble("GripDistanceOnInsert");
			_PtG[0]+=vecX*vecX.dotProduct(seg.ptStart()+dGripDistanceOnInsert*vecX-_PtG[0]);
		}
	}

// merge truck outlines and draw truck outlines
	ppTruck.shrink(-dMaxBedding);
	ppTruck.shrink(dMaxBedding);
	PlaneProfile ppOuter = ppTruck;

// contour as rings
	if (dLineThicknessTruck>dEps)
	{
	// subtract inner
		PlaneProfile pp = ppTruck;//(cs);
		pp.shrink(dLineThicknessTruck);
		PLine plRings[] = pp.allRings();
		int bIsOp[] = pp.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
			{
				plRings[r].vis(2);
				ppTruck.joinRing(plRings[r],_kSubtract);
			}
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
// draw contour as rings
	if (nTransparencyTruck>0 && nTransparencyTruck<100)
	{
		dpTruck.draw(ppTruck, _kDrawFilled, nTransparencyTruck);
		
		// HSB-19483
		if(bHasPlotViewport)
		if(mapContour.length()>0)
		{ 
			if(mapContour.getDouble("Thickness")>0)
			{ 
				double dThicknessContour=mapContour.getDouble("Thickness");
				PLine pls[]=ppTruck.allRings(true,false);
				for (int ipl=0;ipl<pls.length();ipl++) 
				{ 
					PlaneProfile ppOutter(pls[ipl]);
					PlaneProfile ppInner(pls[ipl]);
					if(!isKlh)
					{ 
						ppOutter.shrink(-.5*dThicknessContour);
						ppInner.shrink(.5*dThicknessContour);
					}
					// HSB-19939: Apply contour thickness on the inside
					if(isKlh)
						ppInner.shrink(dThicknessContour);
					ppOutter.subtractProfile(ppInner);
					dpTruck.draw(ppOutter,_kDrawFilled,0);
				}//next ipl
			}
		}
	}
// draw solid
	else if (nTransparencyTruck==0)
		dpTruck.draw(ppTruck, _kDrawFilled);
// draw contour wireframe
	else
		dpTruck.draw(ppTruck);	
	if(isKlh)
	{ 
		// HSB-17789:
		int nWrap=sWraps.find(sWrap);
		if(nWrap>0)
		{ 
			PlaneProfile ppTruckExtend=ppTruck;
			ppTruckExtend.shrink(-U(4));
			PlaneProfile ppTruckShrink=ppTruck;
			ppTruckShrink.shrink(U(4));
			ppTruckExtend.subtractProfile(ppTruckShrink);
			Display dpWrapp(5);
			dpWrapp.draw(ppTruckExtend,_kDrawFilled);
		}
	}
	int nNumLine = sLines.length();
	double dYFlag;
	if (nNumLine>1)
		dYFlag = 3*(nNumLine-1)*.5;	

// get max XX/Y of tag
	double dXMax;
	double dYMax = dTextHeightStyle*nNumLine;
	for (int i=0;i<nNumLine;i++) 
	{ 
		String& sValue = sLines[i];
		double d=dpTxt.textLengthForStyle(sValue,sDimStyle)*dFactor;
		dXMax=d>dXMax?d:dXMax; 
	}
	dXMax += .6*dTextHeightStyle;
	dYMax += nNumLine*.6*dTextHeightStyle;

	Point3d ptLoc = _PtG[0];
	
// create circle
	PLine plBoundary(_ZW);
	double dRadius = dXMax>dYMax?dXMax*.5:dYMax*.5;
	if (dXMax<=1.6*dYMax && nNumLine<=3)
		plBoundary.createCircle(ptLoc,vecZ, dRadius);
// create rounded boundary
	else
	{ 
		plBoundary.addVertex(ptLoc - .5 * (vecX * dXMax - vecY * dYMax));
		plBoundary.addVertex(ptLoc - .5 * (vecX * dXMax + vecY * dYMax),.25);
		plBoundary.addVertex(ptLoc + .5 * (vecX * dXMax - vecY * dYMax));
		plBoundary.addVertex(ptLoc + .5 * (vecX * dXMax + vecY * dYMax),.25);
		plBoundary.close();
	}
	PlaneProfile ppBoundary(plBoundary);

// draw texts
	for (int i=0;i<nNumLine;i++) 
	{ 
		String& sValue = sLines[i];
		dpTxt.draw(sValue,ptLoc, vecX, vecY,0,dYFlag);
		dYFlag-=3; 
	}

// filled frame	
	if (nStyle>1)
	{
		dpTxt.draw(ppBoundary, _kDrawFilled, 80);
	}
// frame
	if (nStyle>0)
		dpTxt.draw(plBoundary);
		
// leader
// draw guide line if grip is outside
	int bDrawLeader = ppOuter.pointInProfile(ptLoc) == _kPointOutsideProfile;
	
	if (bDrawLeader)
	{ 
		Vector3d vecDir = vecX.dotProduct(ptLoc+vecX*.5*dXMax-ptCen)<0?vecX:- vecX;
		Vector3d vecSide = (_PtG[0] - ptCen).dotProduct(vecY) < 0 ? vecY :- vecY;
		Vector3d vec = ptCen - _PtG[0]; vec.normalize();
	
	// intersection points
		LineSeg segs[] = ppOuter.splitSegments(LineSeg(ptCen,_PtG[0]), true);
		Point3d ptsB[0];
		for (int i=0;i<segs.length();i++) 
		{ 
			ptsB.append(segs[i].ptStart());
			ptsB.append(segs[i].ptEnd());	
		}
		ptsB = Line(ptCen, vec).orderPoints(ptsB);
		
		Point3d pt1 = plBoundary.closestPointTo(ptLoc + vecDir * .5 * dXMax);
		Point3d pt2 = pt1 + vecDir *.5 * dTextHeightStyle;
		Point3d pt3 =ptsB.length()>0?ptsB[0]:ppOuter.closestPointTo(_PtG[0]);

	// test intersection	
		if (ppBoundary.pointInProfile(pt3) == _kPointOutsideProfile)
		{
			vec = pt3 - pt2; vec.normalize();
			Point3d ptsA[] = plBoundary.intersectPoints(Plane(pt3, vec.crossProduct(vecZ)));
			if (ptsA.length()>0 && vecDir.dotProduct(vec)<0)
			{
				pt1 = plBoundary.closestPointTo(_PtG[0]+vecSide * dYMax);
				pt2 = pt1+vecSide*.5 * dTextHeightStyle;
				
			}
			dpTxt.draw(PLine(pt1, pt2, pt3));
		}	
		pt3.vis(3);pt1.vis(5);pt2.vis(2);
	}
	
// Property set of source entities
// get available propertysets
	String sAvailableSets[] = Entity().availablePropSetNames();		
	
// attach / assign and fill with data	
	if (sAvailableSets.find(sPropsetName)>-1)
	for (int i=0;i<entRefs.length();i++) 
	{ 
		Entity ent = entRefs[i]; 

	// check if it is attached
		String sAttachedSets[] = ent.attachedPropSetNames();
		int bIsAttached = sAttachedSets.find(sPropsetName) >-1;
		if (!bIsAttached)
			bIsAttached = ent.attachPropSet(sPropsetName);

	// update property set
		if (bIsAttached)
		{
			Map m= ent.getAttachedPropSetMap(sPropsetName);
		
		// package number			
			String k;
			k = sPropsetProperties[5];
			if (m.hasInt(k) && nNumber != m.getInt(k))
			{
				Map mapNew;
				mapNew.setInt(k, nNumber);
				String s[] = { k};
				if (bDebug)reportMessage("\n" + scriptName() + ": setAttachProp "+ s + " " + mapNew);			
				int bOk = ent.setAttachedPropSetFromMap(sPropsetName, mapNew, s); 
			}
		// package wrapping
			k = sPropsetProperties[6];
			if ((m.hasString(k) && sWrap != m.getString(k)) || !m.hasString(k));
			{
				Map mapNew;
				mapNew.setString(k, sWrap);
				String s[] = {k};
				if (bDebug)reportMessage("\n" + scriptName() + ": setAttachProp "+ s + " " + mapNew);			
				int bOk = ent.setAttachedPropSetFromMap(sPropsetName, mapNew, s); 
			}			
			
		//update property set
//			if (bUpdate)
//			{
//				int bOk =  ent.createPropSetDefinition(sPropsetName, m, true);
//				reportMessage("\n" + scriptName() + ": " +T("|Property Set|") + " " + sPropsetName + " " + (bOk?T("|succesfully created.|"):T("|creation failed.|")));
//				
//			}
			
		 //set map
//			if (bWrite)
//				ent.setAttachedPropSetFromMap(sPropsetName, m);
		}
	}
	
// store location
	_Map.setVector3d("vecLocation", _Pt0- _PtW);

// publish referenced entities
	_Map.setEntityArray(entRefs, false, "EntityRef[]", "", "Handle");
	
// publish in mapX
	Map mapX;
	mapX.setDouble("Weight", dWeight);
	_ThisInst.setSubMapX("MapWeight", mapX);

	if(bDebug)reportMessage("\n		"+ scriptName() + " " + _ThisInst.handle() + " took " + (getTickCount()-nTick)+ " milliseconds");
	
















#End
#BeginThumbnail
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
&%3T4`?_9
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
        <int nm="BreakPoint" vl="1330" />
        <int nm="BreakPoint" vl="1410" />
        <int nm="BreakPoint" vl="868" />
        <int nm="BreakPoint" vl="175" />
        <int nm="BreakPoint" vl="147" />
        <int nm="BreakPoint" vl="917" />
        <int nm="BreakPoint" vl="920" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24602: Add xml parameter &quot;GripDistanceOnInsert&quot; for the definition of text grip" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="9/22/2025 1:27:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22813: Fix when saving Datalink " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="10/21/2024 10:17:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22794: Provide datalink to the tsl" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="10/10/2024 4:21:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22608: Add control for group assignment" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="9/9/2024 3:44:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22319: Change strategy when investigating Top/Bottom flag " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="6/27/2024 2:47:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22250: Write the mapx that contain f_Package to Bottom and top plate" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="6/18/2024 9:46:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22250: Provide handle for the bottom and top panel in package for KLH" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="6/14/2024 1:26:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20616: For KLH calculate weight always" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="11/20/2023 6:14:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19939: Apply contour thickness on the inside" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="9/12/2023 1:41:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19483: Apply contour thickness at packages" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="7/10/2023 11:18:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: get from xml flag &quot;PropertyReadOnly&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="6/28/2023 10:20:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: On insert set properties ReadOnly for KLH" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="6/27/2023 10:06:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17825: provide translation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="2/17/2023 10:30:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17789: Draw contour when wrapping is applied" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/3/2023 9:36:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17551: Modify property &quot;Wrapping&quot; for KLH" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/20/2023 11:03:48 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End