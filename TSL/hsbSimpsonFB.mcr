#Version 8
#BeginDescription
#Versions
1.1 24/06/2024 HSB-20925: Add offset below property; add text size property; support xml Marsel Nakuci
version value="1.0" date="24.10.2019" author="marsel.nakuci@hsbcad.com" 
HSB-5442 initial


This TSL inserts fixing bands
The band parameters are defined in an xml file
Some tipical fixing bands can be Simpson FB,FB20,FB20s
The script can be used on single studs or on ElementWalls
When inserted on elementwalls the script will insert fixing band at each stud
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords simpson, fb, fixing band, kingspan
#BeginContents
/// <History>//region
/// #Versions:
// 1.1 24/06/2024 1.1 24/06/2024 HSB-20925: Add offset below property; add text size property; support xml Marsel Nakuci
/// <version value="1.0" date="24.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5442 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbSimpsonFB")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
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

//region Function collectTslsByName
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
//End collectTslsByName //endregion	

//region drawText
// draws the product code
	void drawText(Map _mIn)
	{ 
		Display _dpDraw(0);
		if(_mIn.hasVector3d("vecAllowed"))
		{ 
			_dpDraw.addViewDirection(_mIn.getVector3d("vecAllowed"));
		}
		if(_mIn.hasDouble("dTxtHeight"))
		{ 
			if(_mIn.getDouble("dTxtHeight")>0)
			{ 
				_dpDraw.textHeight(_mIn.getDouble("dTxtHeight"));
			}
		}
		Vector3d _vecOutter=_mIn.getVector3d("vecOutter");
		Vector3d _vx=_vecOutter;
		int nX=1;
		
		if(_XW.dotProduct(_vecOutter)<-dEps)
		{ 
			_vx*=-1;
			nX=-1;
		}
		else if(abs(_XW.dotProduct(_vecOutter))<.1*dEps)
		{ 
			if(_YW.dotProduct(_vecOutter)<-dEps)
			{ 
				_vx*=-1;
				nX=-1;
			}
		}
		Point3d _ptBand=_mIn.getPoint3d("ptBand");
		_ptBand.vis(3);
		Point3d _ptTxt=_ptBand+U(10)*_vecOutter;
		
		Vector3d _vy=_ZW.crossProduct(_vx);
		_vy.normalize();
		
		_vx.vis(_ptTxt);
		_vy.vis(_ptTxt);
		
		String _sTxt=_mIn.getString("sTxt");
		
		_dpDraw.draw(_sTxt,_ptTxt,_vx,_vy,nX,0);
		
		return; 
	}
//End drawText//endregion

//region getHardwareFixers
// gets the maps of fixers from the xml
HardWrComp[] getHardwareFixers(Map _mapProduct)
{ 
	HardWrComp _hwcs[0];
	
	Map mapFixtures=_mapProduct.getMap("Fixture[]");
	for (int m=0;m<mapFixtures.length();m++) 
	{ 
		Map mi=mapFixtures.getMap(m);
	}//next m
}
//End getHardwareFixers//endregion 
//End Functions//endregion 


//region Settings
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

//region properties
	Map mapProducts=mapSetting.getMap("Product[]");
	String sProductCodesMap[0];
	for (int m=0;m<mapProducts.length();m++) 
	{ 
		Map mi=mapProducts.getMap(m);
		String sk=mi.getMapName();
		if(sk!="")
		{ 
			if(sProductCodesMap.find(sk)<0)
			{ 
				sProductCodesMap.append(sk);
			}
		}
	}//next m
	
	String sProductCodes[0];
	int bXmlDefinition;
	//
	
	double dWidths[] ={ U(20), U(20), U(20)};
	double dThicknesses[] ={ U(0.9), U(0.9), U(1.0)};
	String sMaterials[] ={ "Galvanised Steel", "Galvanised Steel", "Stainless Steel"};
	if(sProductCodesMap.length()==0)
	{ 
		String sProduct = "FB";
		sProductCodes.append(sProduct);
		sProductCodes.append(sProduct + "20A");
		sProductCodes.append(sProduct + "20S");
		double dLength = U(60);
	}
	else if(sProductCodesMap.length()>0)
	{ 
		bXmlDefinition=true;
		sProductCodes.append(sProductCodesMap);
	}
	
	// product code
	String sProductCodeName=T("|Product Code|");	
	PropString sProductCode(nStringIndex++, sProductCodes, sProductCodeName);	
	sProductCode.setDescription(T("|Defines the ProductCode|"));
	sProductCode.setCategory(category);
	
	// overall length
	String sLengthOverallName=T("|Length Overall|");	
	PropDouble dLengthOverall(nDoubleIndex++, U(80), sLengthOverallName);	
	dLengthOverall.setDescription(T("|Defines the Overall Length of the band|"));
	dLengthOverall.setCategory(category);
	
	// bend length
	String sLengthBendName=T("|Length Bend|");	
	PropDouble dLengthBend(nDoubleIndex++, U(60), sLengthBendName);	
	dLengthBend.setDescription(T("|Defines the bend Length at the bottom|"));
	dLengthBend.setCategory(category);
	// 
	category=T("|Position|");
	String sOffsetBelowName=T("|Offset Below|");
	PropDouble dOffsetBelow(nDoubleIndex++, U(0), sOffsetBelowName);
	dOffsetBelow.setDescription(T("|Defines the Offset below the wall|"));
	dOffsetBelow.setCategory(category);
	category=T("|Display|");
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
		
		// prompt the selection of studs where the fixing band will be applied to
		// a beam must belong to an element
		// the fixing band can only be applied to a vertical stud
		
		
	// prompt selection of beams and walls
	// prompt for selection of beams and walls
		Entity ents[0];
		PrEntity ssE(T("|Select beam(s) and wall(s)| "), Beam());
		ssE.addAllowedClass(Element());
		if (ssE.go())
			ents.append(ssE.set());
			
		Beam beams[0];
		Element elements[0];
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Beam bm = (Beam) ents[i];
			if (bm.bIsValid())
			{ 
				if (beams.find(bm) < 0)
				{ 
					beams.append(bm);
				}
			}
			Element el = (Element) ents[i];
			if (el.bIsValid())
			{ 
				if(elements.find(el)<0)
				{ 
					elements.append(el);
				}
			}
		}//next i
		
		// append beams of elements at beams
		for (int i = 0; i < elements.length(); i++)
		{ 
			Element el = elements[i];
			Beam beamsEl[] = el.beam();
			for (int j=0;j<beamsEl.length();j++) 
			{ 
				Beam bm = beamsEl[j];
				if (bm.bIsValid())
				{ 
					if (beams.find(bm) < 0)
					{ 
						beams.append(bm);
					}
				}
			}//next j
		}//next i
		
		
			
		
//	// prompt for beams
//		Beam beams[0];
//		PrEntity ssE(T("|Select beam(s)|"), Beam());
//		if (ssE.go())
//			beams.append(ssE.beamSet());
//			
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
			// on insert check the properties
			if (dLengthOverall <= dLengthBend)
			{ 
				dLengthOverall.set(dLengthBend + dEps);
			}
			dProps.append(dLengthOverall);
			dProps.append(dLengthBend);
			// 
			dProps.append(dOffsetBelow);
			dProps.append(dTextHeight);
			
			// append beam
			gbsTsl.append(bm);
			// create tsl
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			
		}//next i
	
		eraseInstance();
		return;
	}
	
// end on insert	__________________//endregion


//region some validation
	
	if (_Beam.length() == 0)
	{ 
		reportMessage(TN("|no valid beam found|"));
		eraseInstance();
		return;
	}
//End some validation//endregion 


//region property validation at the beginning
	if (_kNameLastChangedProp == sLengthBendName)
	{ 
		if (dLengthBend <= 0)
		{ 
			dLengthBend.set(dEps);
		}
	}
	if (_kNameLastChangedProp == sLengthOverallName)
	{ 
		if (dLengthOverall <= dLengthBend)
		{ 
			dLengthOverall.set(dLengthBend+dEps);
		}
	}
//End property validation at the beginning//endregion 

if (_Beam.length() == 0)
{ 
	reportMessage(TN("|no beam|"));
	eraseInstance();
	return;
}
Beam bm = _Beam[0];

if ( ! bm.bIsValid())
{ 
	reportMessage(TN("|no valid beam|"));
	eraseInstance();
	return;
}

Point3d ptCen = bm.ptCen();
Vector3d vecX = bm.vecX();
Vector3d vecY = bm.vecY();
Vector3d vecZ = bm.vecZ();

// element where beam is attached
Element el = bm.element();
if ( ! el.bIsValid())
{ 
	reportMessage(TN("|beam not belonging to an element|"));
	eraseInstance();
	return;
}

Point3d ptOrg=el.ptOrg();
Vector3d vecXel=el.vecX();
Vector3d vecYel=el.vecY();
Vector3d vecZel=el.vecZ();

Map mapProduct;
if(bXmlDefinition)
{ 
	for (int m=0;m<mapProducts.length();m++) 
	{ 
		Map mi=mapProducts.getMap(m);
		if(mi.getMapName()==sProductCode)
		{ 
			mapProduct=mi;
			break;
		}
	}//next m
}
if(mapProduct.hasString("URL"))
{ 
	String sUrl=mapProduct.hasString("URL");
	sUrl.trimLeft();
	sUrl.trimRight();
	if(sUrl!="")
	{ 
		_ThisInst.setHyperlink(sUrl);
	}
}
//region plane where the strap will be attached
	
	Vector3d vecPlane = bm.vecD(vecZ);
	if (vecPlane.dotProduct(vecZ) > 0)
	{ 
		// vecPlane in the opposite direction of vecZ
		vecPlane *= -1;
	}
	
	Point3d ptPlaneOut = ptCen + vecPlane * .5*bm.dD(vecPlane);
	Point3d ptPlaneIn = ptCen - vecPlane * .5*bm.dD(vecPlane);
	
//End plane where the strap will be attached//endregion 
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

//region assign
	
	// Z general item
	if(nGroupAssignment==0)
	{
		_ThisInst.assignToElementGroup(el, true, 0, 'Z');
	}

	if (nGroupAssignment==1)
	{ 
		int bSetLayer = _Map.getInt("setLayer");
		
		if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
		{ 
//			reportNotice("\nflag =" +  bSetLayer);
			assignToLayer("0");	
			_Map.removeAt("setLayer", true);
		}
//			String layer = _ThisInst.layerName();
//			if (layer.find("~",0,false)>-1) // assuming a layer consisting a tilde is an hsb group layer previously assigned
//			{ 
//				assignToLayer("0");	
//			}
	}		
//End assign//endregion 
	
//region selected product code
	
	int iSelectedProduct = sProductCodes.find(sProductCode);
	
//End selected product code//endregion 	

//region create part
	
	// plane on the outside face
	Plane pnOut(ptPlaneOut, vecPlane);
	Plane pnIn(ptPlaneIn, vecPlane);
	
	Point3d ptFB = ptCen;
	// project at plane
	ptFB = pnOut.closestPointTo(ptFB);
	
	ptFB += -vecYel * .5 * bm.solidLength();
	ptFB.vis(1);
	
	
	_Pt0 = ptFB;
	
	if(dOffsetBelow!=0)
	{ 
		ptFB-=dOffsetBelow*vecYel;
	}
	
	// direction vectors of the strap
	// -vecZel
	Vector3d vecXFB = vecPlane;
	Vector3d vecYFB = vecXel;
	Vector3d vecZFB = vecXFB.crossProduct(vecYFB);
	
	// part at the bottom
	vecXFB.vis(ptFB);
	vecYFB.vis(ptFB);
	vecZFB.vis(ptFB);
	
	double dWidth,dThickness;
	if(bXmlDefinition)
	{ 
		dWidth=mapProduct.getDouble("DScaleY");
		dThickness=mapProduct.getDouble("DScaleZ");
	}
	else if(!bXmlDefinition)
	{ 
		dWidth=dWidths[iSelectedProduct];
		dThickness=dThicknesses[iSelectedProduct];
	}
	
	Body bd (ptFB, vecXFB, vecYFB, vecZFB,
		 dLengthBend, dWidth, dThickness,
			1, 0, -1);
	
	bd.vis(1);
	
	// draw txt
	Map mInTxt;
	mInTxt.setVector3d("vecOutter",vecXFB);
	mInTxt.setPoint3d("ptBand",ptFB+vecXFB*dLengthBend);
	mInTxt.setVector3d("vecAllowed", vecYel);
	mInTxt.setString("sTxt",sProductCode);
	mInTxt.setDouble("dTxtHeight",dTextHeight);
	
	drawText(mInTxt);


	// vertical part at the stud
	Vector3d vecXFB1 = vecZFB;
	Vector3d vecYFB1 = vecYFB;
	Vector3d vecZFB1 = - vecXFB;
	
	if ((dLengthOverall - dLengthBend) > 0)
	{ 
		Body bd1 (ptFB, vecXFB1, vecYFB1, vecZFB1,
		 	(dLengthOverall-dLengthBend), dWidth, dThickness,
				-1, 0, -1);
	
		bd1.vis(2);
		bd.addPart(bd1);
	}
	
	
	Plane pnMirror(ptCen, vecPlane);
	CoordSys csMirror;
	csMirror.setToMirroring(pnMirror);
	
	Body bd2 = bd;
	bd2.transformBy(csMirror);
	bd2.vis(1);
	
	bd.addPart(bd2);
	
	Display dp(7);
	dp.draw(bd);
	
	// drawtext
	ptFB.transformBy(csMirror);
	vecXFB.transformBy(csMirror);
	ptFB.vis(1);
	mInTxt.setVector3d("vecOutter",vecXFB);
	mInTxt.setPoint3d("ptBand",ptFB+vecXFB*dLengthBend);
	drawText(mInTxt);
	
//End create part//endregion 
	
	
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
			
			String sType = sProductCode;
			
			HardWrComp hwc(sType, 2); // the articleNumber and the quantity is mandatory
			
			String sManufacturer = "Simpson-Strong-Tie";
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sProductCode);
	//		hwc.setName(sHWName);
	//		hwc.setDescription(sHWDescription);
			String sMaterial = sMaterials[iSelectedProduct];
			hwc.setMaterial(sMaterial);
	//		hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dLengthOverall);
			hwc.setDScaleY(dWidth);
			hwc.setDScaleZ(dThickness);
		// uncomment to specify area, volume or weight
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
		
		// add the fixers
		HardWrComp hwcFixers[]=getHardwareFixers(mapProduct);
		
		
	// nails 6No. Phi3.35x50 mm or 4No Phi3.35x50 mm
		{ 
			String sType = "nails";
			HardWrComp hwc(sType, 12); // the articleNumber and the quantity is mandatory

//			
			String sManufacturer = "Cullen";
			hwc.setManufacturer(sManufacturer);
//			
//	//		hwc.setModel(sProductCode);
//	//		hwc.setName(sHWName);
//	//		hwc.setDescription(sHWDescription);
//			String sMaterial = "Stainless Steel";
//			hwc.setMaterial(sMaterial);
//	//		hwc.setNotes(sHWNotes);
//			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm);
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			hwc.setDScaleX(U(50));
//			// diameter
			hwc.setDScaleY(U(3.35));
//	//		hwc.setDScaleZ(dThickness);
//		// uncomment to specify area, volume or weight
//		//	hwc.setDAngleA(dHWArea);
//		//	hwc.setDAngleB(dHWVolume);
//		//	hwc.setDAngleG(dHWWeight);
//			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	// Fischer FAZ II 8/30 Anchor 
		{ 
			String sType = "Fischer FAZ II 8/30 Anchor";
			HardWrComp hwc(sType, 2); // the articleNumber and the quantity is mandatory

//			String sManufacturer = "Cullen";
//			hwc.setManufacturer(sManufacturer);
//			
//	//		hwc.setModel(sProductCode);
//	//		hwc.setName(sHWName);
//	//		hwc.setDescription(sHWDescription);
//			String sMaterial = "Stainless Steel";
//			hwc.setMaterial(sMaterial);
//	//		hwc.setNotes(sHWNotes);
//			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm);
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			hwc.setDScaleX(U(50));
//			// diameter
//			hwc.setDScaleY(U(3.35));
//	//		hwc.setDScaleZ(dThickness);
//		// uncomment to specify area, volume or weight
//		//	hwc.setDAngleA(dHWArea);
//		//	hwc.setDAngleB(dHWVolume);
//		//	hwc.setDAngleG(dHWWeight);
//			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	// 80x40x10 Washer
		{ 
			String sType = "80x40x10mm Washer";
			HardWrComp hwc(sType, 2); // the articleNumber and the quantity is mandatory
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm);
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwcs.append(hwc);
			
		}
		
	// make sure the hardware is updated
		if (_bOnDbCreated)
			setExecutionLoops(2);
		
		_ThisInst.setHardWrComps(hwcs);	
			
//End hardware export//endregion


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
        <int nm="BreakPoint" vl="692" />
        <int nm="BreakPoint" vl="629" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="1.1 24/06/2024 HSB-20925: Add offset below property; add text size property; support xml" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/24/2024 3:05:33 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End