#Version 8
#BeginDescription
#Versions: 
2.6 25/06/2024 HSB-20924: Add property zone, remove command to flip side Marsel Nakuci
2.5 25/06/2024 HSB-20924: Automatic or manual Group assignment; property for text size; add command to swap size Marsel Nakuci
version value="2.4" date="10feb20" author="marsel.nakuci@hsbcad.com" 

HSB-5437, HSB-5436 fix bug at display of text 
HSB-5437, HSB-5436 add display and text field to be displayed
HSB-5437, HSB-5436 add overhang parameter 
HSB-5437, HSB-5436 add offset value to offset it from the face of stud 
HSB-5437, HSB-5436 change name, include also bended straps 
HSB-5437 remove command definition as thre is no such 
HSB-5437 add hardware for nails 
HSB-5437 add hardware 
HSB-5437 initial


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 6
#KeyWords cullen, kingspan, strap, flat, st-st-pfs
#BeginContents
/// <History>//region
///#Versions: 
// 2.6 25/06/2024 HSB-20924: Add property zone, remove command to flip side Marsel Nakuci
// 2.5 25/06/2024 HSB-20924: Automatic or manual Group assignment; property for text size; add command to swap size Marsel Nakuci
/// <version value="2.4" date="10feb20" author="marsel.nakuci@hsbcad.com"> HSB-5437, HSB-5436 fix bug at display of text </version>
/// <version value="2.3" date="07feb20" author="marsel.nakuci@hsbcad.com"> HSB-5437, HSB-5436 add display and text field to be displayed </version>
/// <version value="2.2" date="04feb20" author="marsel.nakuci@hsbcad.com"> HSB-5437, HSB-5436 add overhang parameter </version>
/// <version value="2.1" date="03feb20" author="marsel.nakuci@hsbcad.com"> HSB-5437, HSB-5436 add offset value to offset it from the face of stud </version>
/// <version value="2.0" date="24.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5437, HSB-5436 change name, include also bended straps </version>
/// <version value="1.3" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5437 remove command definition as there is no such </version>
/// <version value="1.2" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5437 add hardware for nails </version>
/// <version value="1.1" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5437 add hardware </version>
/// <version value="1.0" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5437 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// select beams of the wall, TSL will be entered only to the vertical beams of the wall
/// it is positioned always on the outter side of the wall 
/// an offset property is provided to allow to offset it in case sheeting is to be put in between
/// Overhang of the strap is 225mm
/// </insert>

/// <summary Lang=en>
/// This tsl creates cullen flat straps
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCullenStStPfsFlatStrap")) TSLCONTENT
//endregion


//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String tDisabled = T("<|Disabled|>"),tDefaultEntry = T("<|Default|>"), tNoGroupAssignment =T("|No group assigment|");
	String sGroupings[] = { tDefaultEntry, tNoGroupAssignment};
//end constants//endregion

//region Functions
// HSB-20924
//region getTslsByName
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

//region getTextOrientation
// text should continue in the direction of _vx
// vxTxt,vyTxt should have the orientation of reading firection
// nx is calculated fromt _vx the direction the text should run
Map getTextOrientation(Vector3d _vx)
{ 
	Map _m;
	Vector3d _vxTxt=_vx;
	Vector3d _vyTxt=_ZW.crossProduct(_vxTxt);
	
	int _nx=1;
	if(_vx.dotProduct(_XW)<-dEps)
	{ 
		_nx=-1;
		_vxTxt=-_vx;
	}
	else if(_vx.isParallelTo(_YW))
	{ 
		if(_vx.dotProduct(_YW)<0)
		{ 
			_nx=-1;
			_vxTxt=-_vx;
		}
	}
	if(_vyTxt.dotProduct(_YW)<-dEps)
	{ 
		_vyTxt*=-1;
	}
	else if(_vyTxt.isParallelTo(_XW))
	{ 
		if(_vyTxt.dotProduct(_XW)>0)
		{ 
			_vyTxt*=-1;
		}
	}
	_m.setVector3d("vx",_vxTxt);
	_m.setVector3d("vy",_vyTxt);
	_m.setInt("nx", _nx);
	
	return _m;
}
//End getTextOrientation//endregion


String[] getValidZones(Element _el)
{ 
	// It will output the valid zones
	String _sZonesAll[]={"-5","-4","-3","-2","-1","-0","+0","1","2","3","4","5"};
	for (int z=_sZonesAll.length()-1; z>=0 ; z--) 
	{ 
		if(_sZonesAll[z].find("0",-1,false)>-1)continue;
		int nZoneI=_sZonesAll[z].atoi();
		Sheet sheetsZone[]=_el.sheet(nZoneI);
		ElemZone eZoneI=_el.zone(nZoneI);
		if(sheetsZone.length()<1 || eZoneI.dH()<=dEps)
		{ 
			_sZonesAll.removeAt(z);
		}
	}//next z
	return _sZonesAll;
}
//End Functions//endregion 

//region Settings
// HSB-20924
// settings prerequisites
	String sDictionary="hsbTSL";
	String sPath=_kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral=_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName="hsbSimpsonFB";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound=_bOnInsert?sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder):false;
	String sFullPath=sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid())
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
		int nVersion=mapSetting.getInt("GeneralMapObject\\Version");
		String sFile=findFile(sPathGeneral+sFileName+".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall=mapSettingInstall.getMap("GeneralMapObject").getInt("Version");
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|")+scriptName()+
			TN("|Current Version| ")+nVersion+"	"+_kPathDwg + TN("|Other Version| ") +nVersionInstall+"	"+sFile);
	}
	// Global Settings
	String sTriggerGlobalSetting = T("|Global Settings|");
	String kGlobalSettings = "GlobalSettings", kGroupAssignment= "GroupAssignment";
	int nGroupAssignment;
	Map mapGlobalSettings = mapSetting.getMap(kGlobalSettings);
	if (mapGlobalSettings.hasInt(kGroupAssignment))
		nGroupAssignment = mapGlobalSettings.getInt(kGroupAssignment);	
//End Settings//endregion	

//region properties
	String sProduct = "ST-ST-PFS-";
	String sProductCodes[0];
	// ---flat straps---
	sProductCodes.append(sProduct + "800");
	sProductCodes.append(sProduct + "1000");
	sProductCodes.append(sProduct + "1200");
	sProductCodes.append(sProduct + "1300");
	sProductCodes.append(sProduct + "2000");
	// ---bended straps---
	sProduct = "ST-PFS-";
	sProductCodes.append(sProduct + "50");
	sProductCodes.append(sProduct + "75");
	sProductCodes.append(sProduct + "100");
	// --- bended straps -M ---
	sProductCodes.append(sProduct + "50-M");
	sProductCodes.append(sProduct + "75-M");
	sProductCodes.append(sProduct + "100-M");
	// geometric values for bended straps and bended straps M
	double dX1[] ={ U(50), U(75), U(100), U(50), U(75), U(100)};
	double dX2[] ={ U(75), U(75), U(75), U(75), U(75), U(75)};
	double dY[] ={ U(721), U(716), U(711), U(521), U(516), U(511)};
	double dY1[] ={ U(346), U(346), U(346), U(140), U(140), U(140)};
	double dY2[] ={ U(375), U(370), U(365), U(375), U(370), U(365)};
	//
	double dLengths[] ={ U(800), U(1000), U(1200), U(1300), U(2000)};
	double dWidth = U(35);
	double dThickness = U(1.2);
	
	// type of strap
	String sProductCodeName=T("|Product Code|");	
	PropString sProductCode(nStringIndex++, sProductCodes, sProductCodeName);	
	sProductCode.setDescription(T("|Defines the ProductCode|"));
	sProductCode.setCategory(category);
	// add offset value to offset it from the face of the stud
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset from the stud face|"));
	dOffset.setCategory(category);
	
	// overhanging
	String sOverHangName=T("|Overhang|");	
	PropDouble dOverHang(nDoubleIndex++, U(225), sOverHangName);	
	dOverHang.setDescription(T("|Defines the OverHang|"));
	dOverHang.setCategory(category);
	
	String sZonesAll[]={"-5","-4","-3","-2","-1","-0","+0","1","2","3","4","5"};
	String sZoneName=T("|Zone|");	
	PropString sZone(nStringIndex++, sZonesAll, sZoneName);	
	sZone.setDescription(T("|Defines the Zone where the strap will be placed.|"));
	sZone.setCategory(category);
	
	// free text to be shown
	category=T("|Display|");
	String sTextName=T("|Text|");	
	PropString sText(nStringIndex++, "", sTextName);	
	sText.setDescription(T("|Defines the Text|"));
	sText.setCategory(category);
	// HSB-20924
	String sTextHeightName=T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);
//End properties//endregion 

	
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
		
		// prompt the selection of studs where the flat strap will be attached to
		// a beam must belong to an element
		// the strap is only attached at vertical studs
		
	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beam(s)|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
			
		for (int i = 0; i < beams.length(); i++)
		{ 
			Beam bm = beams[i];
			// get element where beam is attached
			Element el = bm.element();
			if(!el.bIsValid())
			{ 
				// beam not attached to any element
				continue;
			}
			
			// accept only those at vertical beams
			//checks if vectors parallel	
			if (abs(abs(bm.vecX().dotProduct(el.vecY())) - 1) > dEps)
			{ 
				// not parallel with vecY, reject it
				continue;
			}
			
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;	
			
			// add property
			sProps.append(sProductCode);
			sProps.append(sZone);
			sProps.append(sText);
			
			dProps.append(dOffset);
			dProps.append(dOverHang);
			dProps.append(dTextHeight);
			// append beam
			gbsTsl.append(bm);
			
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			
		}//next i
		
		eraseInstance();
		return;
	}
	
// end on insert	__________________//endregion

//region some validation
Beam bm;
if(_Beam.length()==1)
{ 
	bm=_Beam[0];
}
if (!bm.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|no valid beam found|"));
	eraseInstance();
	return;
}
//End some validation//endregion 

Point3d ptCen = bm.ptCen();
Vector3d vecX = bm.vecX();
Vector3d vecY = bm.vecY();
Vector3d vecZ = bm.vecZ();

// element where beam is attached
Element el = bm.element();
if ( ! el.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|beam not belonging to an element|"));
	eraseInstance();
	return;
}
Point3d ptOrg = el.ptOrg();
Vector3d vecXel = el.vecX();
Vector3d vecYel = el.vecY();
Vector3d vecZel = el.vecZ();


//region Trigger GlobalSettings
// HSB-20924
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
				
				Map m = mapSetting.getMap(kGlobalSettings);
				m.setInt(kGroupAssignment, nGroupAssignment);								
				mapSetting.setMap(kGlobalSettings, m);
				
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


// check the zone property
// get all valid zones at the wall
String sZonesValid[]=getValidZones(el);
if(sZonesValid.find(sZone)>-1)
{ 
	int nIndexZone=sZonesValid.find(sZone);
	sZone=PropString (1, sZonesValid, sZoneName,nIndexZone);	
}
else if(sZonesValid.find(sZone)<0)
{ 
	if(sZone.find("-",-1)>-1)
	{ 
		// negative zone
		sZone=PropString (1, sZonesValid, sZoneName,0);	
	}
	else if(sZone.find("-",-1)<0)
	{ 
		// positive
		sZone=PropString (1, sZonesValid, sZoneName,sZonesValid.length()-1);	
	}
}
int nZone;
if(sZone.find("0",-1)>-1)nZone=0;
else nZone=sZone.atoi();

//region assign
	//HSB-20924
	// Z general item
	if(nGroupAssignment==0)
	{
		_ThisInst.assignToElementGroup(el, true, nZone, 'Z');
	}

	if (nGroupAssignment==1)
	{ 
		int bSetLayer = _Map.getInt("setLayer");
		
		if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
		{ 
			assignToLayer("0");	
			_Map.removeAt("setLayer", true);
		}
	}
//End assign//endregion 

// overhang always 225 mm

//region plane where the strap will be attached
	Vector3d vecPlane=bm.vecD(vecZ);
	if (vecPlane.dotProduct(vecZ) > 0)
	{ 
		vecPlane*=-1;
	}
	//HSB-20924
//	if(_Map.getInt("Swap"))vecPlane*=-1;
	
	if(sZone.find("+",-1)>-1 || sZone.find("-",-1)<0)vecPlane*=-1;
	
	Point3d ptPlane=ptCen+vecPlane*.5*bm.dD(vecPlane);
	if(sZone.find("0",-1)>-1)
	{ 
		// + or -0
		ptPlane=ptCen+vecPlane*.5*bm.dD(vecPlane);
	}
	else
	{ 
		ElemZone eZone=el.zone(nZone);
		ptPlane=eZone.ptOrg()+eZone.vecZ()*eZone.dH();
	}
	
//	Point3d ptPlane=ptCen+vecPlane*.5*bm.dD(vecPlane);

	Plane pn(ptPlane, vecPlane);
	ptPlane.vis(1);
//End plane where the strap will be attached//endregion 
	
//region selected product code
	
	int iSelectedProduct=sProductCodes.find(sProductCode);
	
//End selected product code//endregion 	

//region Trigger SwapSide
//	String sTriggerSwapSide = T("|Flip Side|");
//	addRecalcTrigger(_kContextRoot, sTriggerSwapSide );
//	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapSide || _kExecuteKey==sDoubleClick))
//	{
//		_Map.setInt("Swap",!_Map.getInt("Swap"));
//		setExecutionLoops(2);
//		return;
//	}
//endregion	

	int nSideFac=1;
//	if(_Map.getInt("Swap"))nSideFac=-1;
	if(sZone.find("+",-1)>-1 || sZone.find("-",-1)<0)nSideFac=-1;
	Vector3d vzStrap;
	Point3d ptBdOutter=_Pt0;// outter point of the strap body
	if (iSelectedProduct < 5)
	{ 
		// selected one of first 5,
		// its a flat strap
		//region create strap part		
		double dLength = dLengths[iSelectedProduct];
		
		Point3d ptStrap = ptCen;
		// project at plane
		ptStrap = pn.closestPointTo(ptStrap);
		
		ptStrap += -vecYel * .5 * bm.solidLength();
//		ptStrap += vecYel * (.5 * dLength - U(225));
		ptStrap += vecYel * (.5 * dLength - dOverHang);
		
		ptStrap.vis(1);
		// direction vectors of the strap
		Vector3d vecXStrap = vecYel;
		Vector3d vecYStrap = vecXel;
		Vector3d vecZStrap = -vecZel;
		vecZStrap*=nSideFac;
		vzStrap=vecZStrap;
		
		vecXStrap.vis(ptStrap);
		vecYStrap.vis(ptStrap);
		vecZStrap.vis(ptStrap);
		
		// change with the offset value
		ptStrap += vecZStrap * dOffset;
		
		Body bd(ptStrap, vecXStrap, vecYStrap, vecZStrap,
						dLength, dWidth, dThickness,
						0, 0, 1);
		
		bd.vis(3);
		Display dp(7);
		dp.draw(bd);
		_Pt0 = ptStrap;
		
		{
			Point3d ptsExtreme[]=bd.extremeVertices(vecZStrap);
			if(ptsExtreme.length()>1)
			{ 
				Point3d ptLast=ptsExtreme.last();
				ptBdOutter=_Pt0;
				ptBdOutter+=vecZStrap*vecZStrap.dotProduct(ptLast-ptBdOutter);
			}
		}
		
		//End create strap part//endregion 

		//region hardware export
			
		// collect existing hardware
			HardWrComp hwcs[] = _ThisInst.hardWrComps();
			
		// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
			for (int i=hwcs.length()-1; i>=0 ; i--) 
				if (hwcs[i].repType() == _kRTTsl)
					hwcs.removeAt(i); 
			
		// declare the groupname of the hardware components
			String sHWGroupName;
			// set group name
			{ 
			// element
				// try to catch the element from the parent entity
				Element elHW =bm.element(); 
				// check if the parent entity is an element
				if (!elHW.bIsValid())
					elHW = (Element)bm;
				if (elHW.bIsValid()) 
					sHWGroupName=elHW.elementGroup().name();
			// loose
				else
				{
					Group groups[] = _ThisInst.groups();
					if (groups.length() > 0)
						sHWGroupName = groups[0].name();
				}
			}
			
		// add main componnent
			{ 
				String sType = "ST-ST-PFS";
				HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
				
				String sManufacturer = "Cullen";
				hwc.setManufacturer(sManufacturer);
				
				hwc.setModel(sProductCode);
		//		hwc.setName(sHWName);
		//		hwc.setDescription(sHWDescription);
				String sMaterial = "Austenitic Stainless Steel";
				hwc.setMaterial(sMaterial);
		//		hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(bm);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(dLength);
				hwc.setDScaleY(dWidth);
				hwc.setDScaleZ(dThickness);
			// uncomment to specify area, volume or weight
			//	hwc.setDAngleA(dHWArea);
			//	hwc.setDAngleB(dHWVolume);
			//	hwc.setDAngleG(dHWWeight);
				
			// apppend component to the list of components
				hwcs.append(hwc);
			}
			
		// nails 12No. Phi3.35x50 mm
			{ 
				String sType = "nails";
				HardWrComp hwc(sType, 12); // the articleNumber and the quantity is mandatory
				
				String sManufacturer = "Cullen";
				hwc.setManufacturer(sManufacturer);
				
		//		hwc.setModel(sProductCode);
		//		hwc.setName(sHWName);
		//		hwc.setDescription(sHWDescription);
				String sMaterial = "Stainless Steel";
				hwc.setMaterial(sMaterial);
		//		hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(bm);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(U(50));
				// diameter
				hwc.setDScaleY(U(3.35));
		//		hwc.setDScaleZ(dThickness);
			// uncomment to specify area, volume or weight
			//	hwc.setDAngleA(dHWArea);
			//	hwc.setDAngleB(dHWVolume);
			//	hwc.setDAngleG(dHWWeight);
				
			// apppend component to the list of components
				hwcs.append(hwc);
			}
			
		// make sure the hardware is updated
			if (_bOnDbCreated)
				setExecutionLoops(2);
			
			_ThisInst.setHardWrComps(hwcs);	
			
		//End hardware export//endregion 
	}
	else if (iSelectedProduct >= 5)
	{ 
		dOffset.setReadOnly(_kHidden);
		// ST-PFS / ST-PFS-M is selected
		// bended strap
		//region create strap part
		Point3d ptStrap = ptCen;
		// project at plane
		ptStrap = pn.closestPointTo(ptStrap);
		
		double _dY1 = dY1[iSelectedProduct - 5];
		double _dY2 = dY2[iSelectedProduct - 5];
		double _dX1 = dX1[iSelectedProduct - 5];
		double _dX2 = dX2[iSelectedProduct - 5];
		
		ptStrap += -vecYel * .5 * bm.solidLength();
//		ptStrap += vecYel * ( _dY1 + _dY2 - U(225) - .5 * _dY1);
		ptStrap += vecYel * ( _dY1 + _dY2 - dOverHang - .5 * _dY1);
		
		ptStrap.vis(1);
		// direction vectors of the strap
		Vector3d vecXStrap = vecYel;
		Vector3d vecYStrap = vecXel;
		Vector3d vecZStrap = -vecZel;
		vecZStrap*=nSideFac;
		vzStrap=vecZStrap;
		
		vecXStrap.vis(ptStrap);
		vecYStrap.vis(ptStrap);
		vecZStrap.vis(ptStrap);
		
		// part at Y1 range
		Body bd(ptStrap, vecXStrap, vecYStrap, vecZStrap,
						_dY1, dWidth, dThickness,
						0, 0, 1);
		bd.vis(3);
		Display dp(7);
		_Pt0 = ptStrap;
		// bended part
		Point3d ptStrap1 = ptStrap -vecYel * (.5 * _dY1+.5*_dY2)+vecZStrap*.5*_dX1;
		ptStrap1.vis(2);
		
		// 
		Vector3d vecXStrap1 = vecXStrap-vecZStrap*(_dX1/_dY2);
		vecXStrap1.normalize();
		Vector3d vecYStrap1 = vecXel;
		vecYStrap1*=nSideFac;
		Vector3d vecZStrap1 = vecXStrap1.crossProduct(vecYStrap1);
		vecXStrap1.vis(ptStrap1);
		vecYStrap1.vis(ptStrap1);
		vecZStrap1.vis(ptStrap1);
		
		// part at Y1 range
		double dLength1 = _dX1 * _dX1 + _dY2 * _dY2;
		dLength1 = sqrt(dLength1);
		Body bd1(ptStrap1, vecXStrap1, vecYStrap1, vecZStrap1,
						dLength1, dWidth, dThickness,
						0, 0, 1);
		bd1.vis(3);
		
		bd.addPart(bd1);
		
		// last part horizontal
		Point3d ptStrap2 = ptStrap - vecYel * (.5 * _dY1 + _dY2) + vecZStrap * (_dX1 + .5 * _dX2);
		ptStrap2.vis(2);
		
		Vector3d vecXStrap2 = vecZStrap;
		Vector3d vecYStrap2 = vecYStrap;
		vecYStrap2*=nSideFac;
		Vector3d vecZStrap2 = vecXStrap2.crossProduct(vecYStrap2);
		vecXStrap2.vis(ptStrap2);
		vecYStrap2.vis(ptStrap2);
		vecZStrap2.vis(ptStrap2);
		
		Body bd2(ptStrap2, vecXStrap2, vecYStrap2, vecZStrap2,
						_dX2, dWidth, dThickness,
						0, 0, -1);
		bd2.vis(3);
		bd.addPart(bd2);
		dp.draw(bd);
		
		{
			Point3d ptsExtreme[]=bd.extremeVertices(vecZStrap);
			if(ptsExtreme.length()>1)
			{ 
				Point3d ptLast=ptsExtreme.last();
				ptBdOutter=_Pt0;
				ptBdOutter+=vecZStrap*vecZStrap.dotProduct(ptLast-ptBdOutter);
			}
		}
		//End create strap part//endregion 
		
		//region hardware export
			
		// collect existing hardware
			HardWrComp hwcs[] = _ThisInst.hardWrComps();
			
		// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
			for (int i=hwcs.length()-1; i>=0 ; i--) 
				if (hwcs[i].repType() == _kRTTsl)
					hwcs.removeAt(i); 
			
		// declare the groupname of the hardware components
			String sHWGroupName;
			// set group name
			{ 
			// element
				// try to catch the element from the parent entity
				Element elHW =bm.element(); 
				// check if the parent entity is an element
				if (!elHW.bIsValid())
					elHW = (Element)bm;
				if (elHW.bIsValid()) 
					sHWGroupName=elHW.elementGroup().name();
			// loose
				else
				{
					Group groups[] = _ThisInst.groups();
					if (groups.length() > 0)
						sHWGroupName = groups[0].name();
				}
			}
			
		// add main componnent
			{ 
				String sType = "ST-PFS";
				if (iSelectedProduct > 7)
				{ 
					sType = "ST-PFS-M";
				}
				
				HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
				
				String sManufacturer = "Cullen";
				hwc.setManufacturer(sManufacturer);
				
				hwc.setModel(sProductCode);
		//		hwc.setName(sHWName);
		//		hwc.setDescription(sHWDescription);
				String sMaterial = "Austenitic Stainless Steel";
				hwc.setMaterial(sMaterial);
		//		hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(bm);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(_dY1 + _dY2);
				hwc.setDScaleY(dWidth);
				hwc.setDScaleZ(dThickness);
			// uncomment to specify area, volume or weight
				
			// apppend component to the list of components
				hwcs.append(hwc);
			}
			
		// nails 6No. Phi3.35x50 mm or 4No Phi3.35x50 mm
			{ 
				String sType = "nails";
				HardWrComp hwc(sType, 6); // the articleNumber and the quantity is mandatory
				if (iSelectedProduct > 7)
				{ 
					hwc.setQuantity(4);
				}
				
				String sManufacturer = "Cullen";
				hwc.setManufacturer(sManufacturer);
				
		//		hwc.setModel(sProductCode);
		//		hwc.setName(sHWName);
		//		hwc.setDescription(sHWDescription);
				String sMaterial = "Stainless Steel";
				hwc.setMaterial(sMaterial);
		//		hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(bm);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(U(50));
				// diameter
				hwc.setDScaleY(U(3.35));
		//		hwc.setDScaleZ(dThickness);
			// uncomment to specify area, volume or weight
			//	hwc.setDAngleA(dHWArea);
			//	hwc.setDAngleB(dHWVolume);
			//	hwc.setDAngleG(dHWWeight);
				
			// apppend component to the list of components
				hwcs.append(hwc);
			}
			
		// make sure the hardware is updated
			if (_bOnDbCreated)
				setExecutionLoops(2);
			
			_ThisInst.setHardWrComps(hwcs);	
			
		//End hardware export//endregion 
	}
	
//region add text display
	//	Display dpPlan(1);
	//	dpPlan.draw("AS", _Pt0, vecXel, vecZel, 0, 0, _kDeviceX);
	//	dpPlan.addViewDirection(vecYel);
	
//		Display dpModel(7);
		Display dpPlane(7);
		dpPlane.addViewDirection(_ZW);
		if(dTextHeight>0)
		{
			dpPlane.textHeight(dTextHeight);
		}
		Map mTxt=getTextOrientation(vzStrap);
		Vector3d vxTxt=mTxt.getVector3d("vx");
		Vector3d vyTxt=mTxt.getVector3d("vy");
		int nx=mTxt.getInt("nx");
		
		if(sText=="")
		{
//			dpModel.draw("AS-" + sProductCode, ptBdOutter, vecXel, vecYel, 0, 0, _kDeviceX);
			dpPlane.draw("AS-" + sProductCode, ptBdOutter+vzStrap*U(20), vxTxt, vyTxt, nx, 0);
		}
		else
		{ 
			
//			dpModel.draw(sText, ptBdOutter, vecXel, vecYel, 0, 0, _kDeviceX);
			dpPlane.draw(sText, ptBdOutter, vxTxt, vyTxt, nx, 0);
		}
	//	dpModel.addHideDirection(vecYel);
//End add text display//endregion 


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
        <int nm="BreakPoint" vl="716" />
        <int nm="BreakPoint" vl="447" />
        <int nm="BreakPoint" vl="466" />
        <int nm="BreakPoint" vl="467" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20924: Add property zone, remove command to flip side" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="6/25/2024 3:10:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20924: Automatic or manual Group assignment; property for text size; add command to swap size" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/25/2024 1:22:08 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End