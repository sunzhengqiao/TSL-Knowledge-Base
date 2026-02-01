#Version 8
#BeginDescription
#Versions:
1.7 25/06/2024 HSB-20923: Add property text size; fix position of bracket; allow manual or automatic assignment (global); show qty in plan view Marsel Nakuci
version value="1.6" date="04feb20" author="marsel.nakuci@hsbcad.com" 

HSB-5435: enable rotate180 of second leg when attached at only 1 beam 
HSB-5435: change the favored position in Mode 0 
HSB-5435: hardware export 
HSB-5435: add a default favorite direction for Mode=0 
HSB-5435: make sure there are always map values for iside, ifold, ifold1
HSB-5435:working version
HSB-5435:initial

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <History>//region
///#Versions:
// 1.7 25/06/2024 HSB-20923: Add property text size; fix position of bracket; allow manual or automatic assignment (global); show qty in plan view Marsel Nakuci
/// <version value="1.6" date="04feb20" author="marsel.nakuci@hsbcad.com"> HSB-5435: enable rotate180 of second leg when attached at only 1 beam </version>
/// <version value="1.5" date="29.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435: change the favored position in Mode 0 </version>
/// <version value="1.4" date="29.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435: hardware export </version>
/// <version value="1.3" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435: add a default favorite direction for Mode=0 </version>
/// <version value="1.2" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435: make sure there are always map values for iside, ifold, ifold1 </version>
/// <version value="1.1" date="30.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435: working version </version>
/// <version value="1.0" date="27.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435:initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates FAS framing anchor - Cullen FAS
/// The bracket is inserted at an edge that can be an edge from a single genBeam
/// or an edge from intersection of 2 planes from 2 genBeams.
/// Behaviour will be the same as the GA TSL but additionally the legs indicated 
/// with 1 and 2 will have the possibility to be folded via a custom cimmand
/// "Fold leg 1" and "fold leg 2"
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCullenFAS")) TSLCONTENT
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
//  HSB-20923
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
		
		_dpDraw.draw(_sTxt,_ptTxt,_vx,_vy,nX,1);
		
		return; 
	}
//End drawText//endregion

//region getQty
// get nr of tsls
// when 2 genbeams it gets all CullenFAS tsls that are attached to these 2 genbeams
Map getQty(GenBeam _gbs[])
{ 
	Map _m;
	int _nQty=1;
	if(_gbs.length()==1)
	{ 
		_m.setInt("Qty",1);
		_m.setInt("First",true);
		return _m;
	}
	if(_gbs.length()==2)
	{ 
		// connects 2 genbeams
		// collect all tsls connecting the 2 genbeams
		Entity _ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
		TslInst _tsls[0];
		for (int i=0;i<_ents.length();i++) 
		{ 
			TslInst t= (TslInst)_ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid() && t.scriptName()=="hsbCullenFAS")
			{	
				GenBeam _gbsI[]=t.genBeam();
				if(_gbsI.length()!=2)continue;
				if(_gbs[0]==_gbsI[0] && _gbs[1]==_gbsI[1])
				{
					_tsls.append(t);
				}
			}
		}//next i
	// order alphabetically
		for (int i=0;i<_tsls.length();i++) 
			for (int j=0;j<_tsls.length()-1;j++) 
				if (_tsls[j].handle()>_tsls[j+1].handle())
					_tsls.swap(j, j + 1);
		
		_m.setInt("Qty", _tsls.length());
		if(_tsls.length()>0)
		{ 
			if(_tsls[0].handle()==_ThisInst.handle())
			{ 
				_m.setInt("First",true);
			}
			else
			{ 
				// update the first
				_tsls[0].recalc();
			}
		}
		return _m;
	}
	return _m;
}
//End getQty//endregion 
//End Functions//endregion 

//region Settings
//  HSB-20923
// settings prerequisites
	String sDictionary="hsbTSL";
	String sPath=_kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral=_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName="hsbCullenFAS";
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


//region Properties
//  HSB-20923
	category=T("|Display|");
	String sTextHeightName=T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);
	dTextHeight.setDescription(T("|Defines the Text Height|"));
	dTextHeight.setCategory(category);
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
//		else
//			showDialog();
			
			// prompt for the selection of genBeams
			// there can be 1, 2 or 3 genbeams
			
		// prompt for entities
			Entity ents[0];
			GenBeam gBeams[0];
			PrEntity ssE(T("|Select genBeam(s)|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());
			
			if (ents.length() < 1)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Select at least one genBeam (beam, sheet or panel)|"));
				eraseInstance();
				return;
			}
			
		// get point (grip point needed to define the position of the connection)
			Point3d pt = getPoint(TN("|Select the Point|"));
			
			// initialize _Pt0 with pt
			_Pt0 = pt;
			// save the point at the grip points
			if (_PtG.length() == 0)
			{ 
				_PtG.append(pt);
			}
			else
			{
				_PtG[0] = pt;
			}
			
			for (int i = 0; i < ents.length(); i++)
			{ 
				GenBeam gb = (GenBeam) ents[i];
				if (gb.bIsValid())
				{ 
					_GenBeam.append(gb);
				}
				if (_GenBeam.length() == 2)
				{ 
					// 2 genBeams found, dont append any more
					break;
				}
			}//next i
			
			// initialize indices in _Map
			//for swap in xy; can be -1 and 1
			_Map.setInt("iSide", 1);
			//for folding the 2 legs; can be -1,0,1
			// for first leg
			_Map.setInt("iFold", 0);
			// for second leg
			_Map.setInt("iFold1", 0);
			
		return;
	}
// end on insert	__________________//endregion
	
	
//region validate
	if (_GenBeam.length() < 1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no genBeam (beam, sheet, panel) found|"));
		eraseInstance();
		return;
	}
//End validate//endregion
	
	
//	_GenBeam[0].envelopeBody().vis(1);
	
	
//region add or remove beams
	// add genbeam
	if (_GenBeam.length() < 2)
	{ 
		// Trigger addGenBeam//region
		String sTriggeraddGenBeam = T("|Add genBeam|");
		addRecalcTrigger(_kContext, sTriggeraddGenBeam );
		if (_bOnRecalc && (_kExecuteKey == sTriggeraddGenBeam))
		{
			// prompt selection
			Entity ents[0];
			PrEntity ssE(T("|Select genBeam(s)|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());
			
			for (int i = 0; i < ents.length(); i++)
			{ 
				GenBeam gb = (GenBeam) ents[i];
				if (gb.bIsValid())
				{ 
					if (_GenBeam.find(gb) < 0)
					{ 
						// new genBeam, append it
						_GenBeam.append(gb);
					}
				}
				if (_GenBeam.length() == 3)
				{ 
					// 3 genBeams found, dont append any more
					break;
				}
			}//next i
			
			setExecutionLoops(2);
			return;
		}//endregion
	}
	
	// remove genbeam
	if (_GenBeam.length() > 1)
	{ 
		// Trigger removeGenBeam//region
		String sTriggerremoveGenBeam = T("|Remove genBeam|");
		addRecalcTrigger(_kContext, sTriggerremoveGenBeam );
		if (_bOnRecalc && (_kExecuteKey==sTriggerremoveGenBeam))
		{
			// prompt selection
			Entity ents[0];
			PrEntity ssE(T("|Select genBeam(s)|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());
			
			for (int i = 0; i < ents.length(); i++)
			{ 
				GenBeam gb = (GenBeam) ents[i];
				if (gb.bIsValid())
				{ 
					if (_GenBeam.find(gb) >- 1)
					{ 
						// existing genbeam, remove it
						_GenBeam.removeAt(_GenBeam.find(gb));
					}
				}
				
				if (_GenBeam.length() == 1)
				{ 
					// there should be at least 1 genbeam remaining
					break;
				}
			}//next i
			
			setExecutionLoops(2);
			return;
		}//endregion	
	}
//End add or remove beams//endregion
	
	
	int iMode = _Map.getInt("iMode");
	if (iMode == 0)
	{ 
		_Map.setInt("iMode", 1);
	}
	
//region fill the map values if not found
	
	if ( ! _Map.hasInt("iSide"))
	{ 
		_Map.setInt("iSide", 1);
	}
	if ( ! _Map.hasInt("iFold"))
	{ 
		_Map.setInt("iFold", 0);
	}
	if ( ! _Map.hasInt("iFold1"))
	{ 
		_Map.setInt("iFold1", 0);
	}
//End fill the map values if not found//endregion 	
	
	
//region swap x-y
		
// Trigger swapXY//region
	String sTriggerswapXY = T("|swap X-Y|");
	addRecalcTrigger(_kContext, sTriggerswapXY );
	if (_bOnRecalc && (_kExecuteKey == sTriggerswapXY || _kExecuteKey == sDoubleClick))
	{
		if (_Map.hasInt("iSide"))
		{ 
			int iSide = _Map.getInt("iSide");
			iSide *=-1;
			_Map.setInt("iSide", iSide);
		}
		
		setExecutionLoops(2);
		return;
	}//endregion

//End swap x-y//endregion 
	
	
//region fold legs
	
// Trigger Fold1//region
	String sTriggerFold1 = T("|Fold leg 1|");
	addRecalcTrigger(_kContext, sTriggerFold1 );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFold1))
	{
		if (_Map.hasInt("iFold"))
		{ 
			int iFold = _Map.getInt("iFold");
			
			if (iFold == 0)
			{ 
				iFold = -1;
			}
			else if (iFold == -1)
			{ 
				iFold = 1;
			}
			else if (iFold == 1)
			{ 
				iFold = 0;
			}
			
			_Map.setInt("iFold", iFold);
		}
		
		setExecutionLoops(2);
		return;
	}//endregion
	
// Trigger Fold1//region
	String sTriggerFold2 = T("|Fold leg 2|");
	addRecalcTrigger(_kContext, sTriggerFold2 );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFold2))
	{
		if (_Map.hasInt("iFold1"))
		{ 
			int iFold1 = _Map.getInt("iFold1");
			
			if (iFold1 == 0)
			{ 
				iFold1 = -1;
			}
			else if (iFold1 == -1)
			{ 
				iFold1 = 1;
			}
			else if (iFold1 == 1)
			{ 
				iFold1 = 0;
			}
			
			_Map.setInt("iFold1", iFold1);
		}
		
		setExecutionLoops(2);
		return;
	}//endregion	
	
//End fold legs//endregion 	
	
	
//region evaluate
	
	if(_PtG.length()<1)
	{ 
		// if TSL is created from another TSL, there is no insert so the ptg
		// must be initialized with _Pt0
		_PtG.append(_Pt0);
//		// no point was defined
//		eraseInstance();
//		return;
	}
	_Pt0.vis(4);
	
//End evaluate//endregion 
	
	
//region if _Pt0 is changed, _PtG[0] should not change and it must keep its position
	
	if(_bOnDbCreated)
	{ 
		_Map.setPoint3d("_PtG0", _PtG[0], _kAbsolute);
	}
	
	if (_kNameLastChangedProp != "_PtG0")
	{ 
		// get the saved ptg0
		if(_Map.hasPoint3d("_PtG0"))
		{ 
			_PtG[0] = _Map.getPoint3d("_PtG0");
		}
	}
	_Map.setPoint3d("_PtG0", _PtG[0], _kAbsolute);
	_PtG[0].vis(3);
	
//End if _Pt0 is changed, _PtG[0] should not change and it must keep its position//endregion
	
	
//region some data for first beam
	GenBeam gb = _GenBeam[0];
	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();
	Point3d ptCen = gb.ptCen();
	Point3d ptCenSolid = gb.ptCenSolid();
	double dLength = gb.solidLength();
	double dWidth = gb.solidWidth();
	double dHeight = gb.solidHeight();
	
	vecX.vis(ptCen, 1);
	vecY.vis(ptCen, 3);
	vecZ.vis(ptCen, 150);
	ptCen.vis(10);
//End some data//endregion 
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
	
//region 6 bounding planes for the first beam
	// first genBeam
	double dDimExtrems[] ={ .5 * dLength, .5 * dLength,
							.5 * dWidth, .5 * dWidth,
							.5 * dHeight, .5 * dHeight};
	Vector3d vecExtrems[] ={ vecX, - vecX, vecY ,- vecY, vecZ ,- vecZ};
	Plane planes[0];
	for (int i = 0; i < 6; i++)
	{
		planes.append(Plane(ptCenSolid + dDimExtrems[i] * vecExtrems[i], vecExtrems[i]));
	}
	Quader qd(ptCenSolid, vecX, vecY, vecZ, dLength, dWidth, dHeight);
	qd.vis(4);
//End bounding planes of 2 genBeams//endregion  
	
	
//region 2planes where connection will be generated
	Plane plane0;
	Vector3d vec0;
	Plane plane1;
	Vector3d vec1;
//End 2planes where connection will be generated//endregion
	
	GenBeam gb1;
//region plane0, vec0, plane1, vec1
	int iRotate180 = 0;
	if (_GenBeam.length() == 1)
	{ 
		iRotate180 = _Map.getInt("iRotate180Degrees");
		// add command to rotate the second leg
		// Trigger rotate180Degrees//region
		String sTriggerrotate180Degrees = T("|Rotate 180 degrees|");
		addRecalcTrigger(_kContext, sTriggerrotate180Degrees );
		if (_bOnRecalc && (_kExecuteKey == sTriggerrotate180Degrees || _kExecuteKey == sDoubleClick))
		{
			int ii = _Map.getInt("iRotate180Degrees");
			ii =! ii;
			_Map.setInt("iRotate180Degrees", ii);
			setExecutionLoops(2);
			return;
		}//endregion
		
		// index of first plane
		// index of second plane
		int iPlaneClosest = - 1;
		int iPlaneClosest1 = - 1;
		// only one beam
		double dDistMin = 10e12;
		for (int i = 0; i < planes.length(); i++)
		{ 
			for (int j = 0; j < planes.length(); j++)
			{ 
				// dont consider parallel planes
				if (abs(abs(vecExtrems[i].dotProduct(vecExtrems[j])) - 1) < dEps)
				{ 
					// parallel planes
					continue;
				}
				// line between two planes
				int iHasIntersection = planes[i].hasIntersection(planes[j]);
				if ( ! iHasIntersection)
				{ 
					// no intersection
					continue;
				}
				Line ln = planes[i].intersect(planes[j]);
				double dDist = (ln.closestPointTo(_PtG[0]) - _PtG[0]).length();
				
				if (dDist < dDistMin)
				{ 
					dDistMin = dDist;
					iPlaneClosest = i;
					iPlaneClosest1 = j;
				}
			}
		}
		
		// closest plane between i and j
		plane0 = planes[iPlaneClosest];
		vec0 = vecExtrems[iPlaneClosest];
		plane1 = planes[iPlaneClosest1];
		vec1 = -vecExtrems[iPlaneClosest1];
		if ((plane1.closestPointTo(_PtG[0]) - _PtG[0]).length() < 
			(plane0.closestPointTo(_PtG[0]) - _PtG[0]).length())
		{ 
			plane0 = planes[iPlaneClosest1];
			vec0 = vecExtrems[iPlaneClosest1];
			plane1 = planes[iPlaneClosest];
			vec1 = -vecExtrems[iPlaneClosest];
		}
		
		// project _Pt0 to the edge
		Line ln = plane0.intersect(plane1);
		_Pt0 = ln.closestPointTo(_Pt0);
	}
	else if(_GenBeam.length() == 2)
	{ 
		iRotate180 = 0;
		gb1 = _GenBeam[1];
	
		Vector3d vecX1 = gb1.vecX();
		Vector3d vecY1 = gb1.vecY();
		Vector3d vecZ1 = gb1.vecZ();
		Point3d ptCen1 = gb1.ptCen();
		Point3d ptCenSolid1 = gb1.ptCenSolid();
		
		// genBeam2
		double dLength1 = gb1.solidLength();
		double dWidth1 = gb1.solidWidth();
		double dHeight1 = gb1.solidHeight();
		double dDimExtrems1[] ={ .5 * dLength1, .5 * dLength1,
								.5 * dWidth1, .5 * dWidth1,
								.5 * dHeight1, .5 * dHeight1};
		Vector3d vecExtrems1[] ={ vecX1, - vecX1, vecY1 ,- vecY1, vecZ1 ,- vecZ1};
		Plane planes1[0];
		for (int i = 0; i < 6; i++)
		{
			planes1.append(Plane(ptCenSolid1 + dDimExtrems1[i] * vecExtrems1[i], vecExtrems1[i]));
		}
		Quader qd1(ptCenSolid1, vecX1, vecY1, vecZ1, dLength1, dWidth1, dHeight1);
		qd1.vis(7);
		
		// index of first plane at genBeam0
		// index of second plane  at genBeam1
		int iPlaneClosest = - 1;
		int iPlaneClosest1 = - 1;
		double dDistMin = 10e12;
		for (int i = 0; i < planes.length(); i++)
		{ 
			for (int j = 0; j < planes1.length(); j++)
			{ 
				// dont consider parallel planes
				if (abs(abs(vecExtrems[i].dotProduct(vecExtrems1[j])) - 1) < dEps)
				{ 
					// parallel planes
					continue;
				}
				
				// line between two planes
				int iHasIntersection = planes[i].hasIntersection(planes1[j]);
				if ( ! iHasIntersection)
				{ 
					// no intersection
					continue;
				}
				//  HSB-20923
				Vector3d _vec0 = vecExtrems[i];
				Vector3d _vec1 = vecExtrems1[j];
				// make sure it intersects gb1 from point in direction of vec0 
				// make sure it intersects gb0 from point in direction of vec1 
				Vector3d vDir=_vec0.crossProduct(_vec1);
				vDir.normalize();
				PlaneProfile pp0=gb.envelopeBody().shadowProfile(Plane(_Pt0,vDir));
				PlaneProfile pp1=gb1.envelopeBody().shadowProfile(Plane(_Pt0,vDir));
				
				{ 
					PlaneProfile ppTest(Plane(_Pt0, vDir));
					ppTest.createRectangle(LineSeg(_Pt0+U(1)*_vec0-U(50)*_vec1,
						_Pt0+U(500)*_vec0+U(50)*_vec1),_vec0,_vec1);
					ppTest.vis(1);
					if(!ppTest.intersectWith(pp1))continue;
				}
				{ 
					PlaneProfile ppTest(Plane(_Pt0, vDir));
					ppTest.createRectangle(LineSeg(_Pt0+U(1)*_vec1-U(50)*_vec0,
						_Pt0+U(500)*_vec1+U(50)*_vec0),_vec1,_vec0);
					ppTest.vis(1);
					if(!ppTest.intersectWith(pp0))continue;
				}
				//
				Line ln = planes[i].intersect(planes1[j]);
				double dDist = (ln.closestPointTo(_PtG[0]) - _PtG[0]).length();
				
				if (dDist < dDistMin)
				{ 
					dDistMin = dDist;
					iPlaneClosest = i;
					iPlaneClosest1 = j;
				}
			}//next j
		}//next i
		
		// closest plane between i and j
		plane0 = planes[iPlaneClosest];
		vec0 = vecExtrems[iPlaneClosest];
		plane1 = planes1[iPlaneClosest1];
		vec1 = vecExtrems1[iPlaneClosest1];
	}
	
//End plane0, vec0, plane1, vec1//endregion 
	
//region line between two planes
	
	Line ln = plane0.intersect(plane1);
	Vector3d vecIntersect = ln.vecX();
	
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		_Pt0 = ln.closestPointTo(_Pt0);
	}
	else if (_kNameLastChangedProp == "_PtG0")
	{ 
		// grip point was moved
		// project ptg at the edge found
		_PtG[0] = ln.closestPointTo(_PtG[0]);
		_Pt0 = _PtG[0];
	}

	// if the part is displaced, move the pt0 and ptg0
	// to the found edge
	_Pt0 = ln.closestPointTo(_Pt0);
	_PtG[0] = ln.closestPointTo(_PtG[0]);
	
//End line between two planes//endregion
	

//region group assignment

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

	if(nGroupAssignment==0)
	{ 
		assignToGroups(gb);
		if(gb1.bIsValid())
		{ 
			assignToGroups(gb1);
			Element el=gb.element();
			Element el1=gb1.element();
			if(el.bIsValid() && el1.bIsValid())
			{ 
				assignToLayer("0");
				int nz=gb.myZoneIndex();
				int nz1=gb1.myZoneIndex();
				
				assignToElementGroup(el,true,nz,'Z');
				assignToElementGroup(el1,false,nz1,'Z');
			}
		}
	}
	else if (nGroupAssignment==1)
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


//region create 3d part
	// vector at plane0 normal with the intersection line of 2 planes
	// and pointing away of plane1
	Vector3d vec0Normal = vec0.crossProduct(vecIntersect);
	if (vec0Normal.dotProduct(vec1) < dEps)
	{ 
		vec0Normal *= -1;
	}
	// at plane 1
	Vector3d vec1Normal = vec1.crossProduct(vecIntersect);
	if (vec1Normal.dotProduct(vec0) < dEps)
	{ 
		vec1Normal *= -1;
	}
	
	Vector3d vxBody = vec0Normal;
	Vector3d vyBody = vecIntersect;
	Vector3d vzBody = vec0;
	if((vxBody.crossProduct(vyBody)).dotProduct(vzBody)<dEps)
	{ 
		vyBody *= -1;
	}
	
	if (iMode == 0)
	{ 
		_Map.setInt("iSideDefault", 1);
		// for mode 0 set the iSide according to a favorite position
		// favorite position pointing +_ZW or +_XW
		if (vecIntersect.dotProduct(_ZW) > 0)
		{ 
			_Map.setInt("iSideDefault", - 1);
		}
		else if (abs(vecIntersect.dotProduct(_ZW)) < dEps)
		{ 
			// normal with _ZW, check _XW
			if (vecIntersect.dotProduct(_XW) > 0)
			{ 
				_Map.setInt("iSideDefault", - 1);
			}
			else if (abs(vecIntersect.dotProduct(_XW)) < dEps)
			{ 
				// normal with _XW, check _YW
				if (vecIntersect.dotProduct(_YW) > 0)
				{ 
					_Map.setInt("iSideDefault", - 1);
				}
			}
		}
	}
	
	int iSideDefault = _Map.getInt("iSideDefault");
	int iSide = 1;
	if (_Map.hasInt("iSide"))
	{
		iSide = _Map.getInt("iSide");
	}
	
	// 
	Vector3d vDir = iSide * vecIntersect * iSideDefault;
	double dThickness = U(1.2);
	
	Body bd;
	Display dp(252);
	vec0.vis(_Pt0, 3);
	vec1.vis(_Pt0, 3);
	vDir.vis(_Pt0, 3);
	_Pt0.vis(3);
	
	int iFold = 0;
	if (_Map.hasInt("iFold"))
	{
		iFold = _Map.getInt("iFold");
	}
	
	// first part
	{ 
		// top
		PLine plShape(vec0);
		Point3d pt = _Pt0;
		plShape.addVertex(pt);
		
		pt += vDir * U(3.74) + vec0Normal * U(3.74);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt += vec0Normal * U(34.26);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt += -vDir * U(63.5);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt += -vDir * U(3.74) - vec0Normal * U(3.74);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt -= vec0Normal * U(34.26);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		plShape.close();
		plShape.vis(4);
		
		Body bd0(plShape, vec0 * dThickness, 1);
		bd0.vis(5);
		bd.addPart(bd0);
		
		// display number
		{
			PlaneProfile pp(plShape);
			// get extents of profile
			LineSeg seg = pp.extentInDir(vDir);
			Point3d ptText = seg.ptMid();
			dp.textHeight(25);
			dp.draw("1", ptText, vDir, vec0Normal,0,0);
		}
		
		// folded part
		if (iFold == 0)
		{ 
			PLine plShape(vec0);
			Point3d pt = _Pt0 + vDir * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			
			pt += vDir * U(54.02);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDir * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vec0Normal * U(26.78);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDir * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDir * U(54.02);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			
			Body bd01(plShape, vec0 * dThickness, 1);
			bd01.vis(5);
			bd.addPart(bd01);
		}
		else if (iFold == -1)
		{ 
			// folded in direction of vec0
			Vector3d vPlane = -vDir;
			Vector3d vDirFold = vec0;
			PLine plShape(vPlane);
			Point3d pt = _Pt0 + vDir * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			
			pt += vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDirFold * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vec0Normal * U(26.78);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			
			Body bd01(plShape, -vPlane * dThickness, 1);
			bd01.vis(5);
			bd.addPart(bd01);
		}
		else if (iFold == 1)
		{ 
			// folded in direction of vec0
			Vector3d vPlane = -vDir;
			Vector3d vDirFold = - vec0;
			PLine plShape(vPlane);
			Point3d pt = _Pt0 + vDir * U(3.74) + vec0Normal * U(3.74) - vDirFold * dThickness;
			plShape.addVertex(pt);
			
			pt += vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDirFold * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vec0Normal * U(26.78);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * U(3.74) + vec0Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			
			Body bd01(plShape, -vPlane * dThickness, 1);
			bd01.vis(5);
			bd.addPart(bd01);
		}
	}
	
	
	int iFold1 = 0;
	if (_Map.hasInt("iFold1"))
	{
		iFold1 = _Map.getInt("iFold1");
	}
	
	// second part
	{
		// top
		PLine plShape(vec1);
		Point3d pt = _Pt0;
		plShape.addVertex(pt);
		
		pt += vDir * U(3.74) + vec1Normal * U(3.74);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt += vec1Normal * U(34.26);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt += -vDir * U(63.5);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt += -vDir * U(3.74) - vec1Normal * U(3.74);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		pt -= vec1Normal * U(34.26);
		plShape.addVertex(pt);
		plShape.vis(4);
		
		plShape.close();
		plShape.vis(4);
		
		Body bd1(plShape, vec1 * dThickness, 1);
		bd1.vis(5);
		// rotate
		CoordSys csRot;
		csRot.setToRotation(180, vDir, _Pt0);
		if(iRotate180)bd1.transformBy(csRot);
		bd.addPart(bd1);
		
		// display number
		{
			PlaneProfile pp(plShape);
			// get extents of profile
			LineSeg seg = pp.extentInDir(vDir);
			Point3d ptText = seg.ptMid();
			Vector3d vec1NormalTxt = vec1Normal;
			if(iRotate180)
			{
				ptText.transformBy(csRot);
				vec1NormalTxt.transformBy(csRot);
			}
			dp.textHeight(25);
			dp.draw("2", ptText, vDir, vec1NormalTxt, 0, 0);
		}
		
		// folded part
		if (iFold1 == 0)
		{
			PLine plShape(vec1);
			Point3d pt = _Pt0 + vDir * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			
			pt += vDir * U(54.02);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDir * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vec1Normal * U(26.78);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDir * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDir * U(54.02);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			
			Body bd11(plShape, vec1 * dThickness, 1);
			bd11.vis(5);
			if (iRotate180)bd11.transformBy(csRot);
			bd.addPart(bd11);
		}
		else if (iFold1 == -1)
		{
			// folded in direction of vec0
			Vector3d vPlane = - vDir;
			Vector3d vDirFold = vec1;
			PLine plShape(vPlane);
			Point3d pt = _Pt0 + vDir * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			
			pt += vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDirFold * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vec1Normal * U(26.78);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			
			Body bd01(plShape, - vPlane * dThickness, 1);
			bd01.vis(5);
			if (iRotate180)bd01.transformBy(csRot);
			bd.addPart(bd01);
		}
		else if (iFold1 == 1)
		{
			// folded in direction of vec0
			Vector3d vPlane = - vDir;
			Vector3d vDirFold = - vec1;
			PLine plShape(vPlane);
			Point3d pt = _Pt0 + vDir * U(3.74) + vec1Normal * U(3.74) - vDirFold * dThickness;
			plShape.addVertex(pt);
			
			pt += vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDirFold * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vec1Normal * U(26.78);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * U(3.74) + vec1Normal * U(3.74);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += -vDirFold * (U(54.02) + dThickness);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			
			Body bd01(plShape, - vPlane * dThickness, 1);
			bd01.vis(5);
			if (iRotate180)bd01.transformBy(csRot);
			bd.addPart(bd01);
		}
	}

	dp.draw(bd);
//End create 3d part//endregion

Vector3d vecView=vecIntersect;
if(vecView.isParallelTo(_ZW))
{
	vecView=_ZW;
}
// get quantity of instances 
Map mQty=getQty(_GenBeam);


if(mQty.getInt("First"))
{ 
	String sTxt="FAS";
	if(mQty.getInt("Qty")>1)
	{ 
		sTxt="FAS x "+mQty.getInt("Qty");
	}

// draw txt
	Map mInTxt;
	mInTxt.setVector3d("vecOutter",vec0);
//	mInTxt.setPoint3d("ptBand",ptFB+vecXFB*dLengthBend);
	mInTxt.setPoint3d("ptBand",_Pt0+vec1*U(20));
	// allowed view direction
	mInTxt.setVector3d("vecAllowed", vecView);
	mInTxt.setString("sTxt",sTxt);
	mInTxt.setDouble("dTxtHeight",dTextHeight);
	
	drawText(mInTxt);
}
//region reposition ptg at the upper part of the connector
	
//	vxBody.vis(_Pt0, 1);
//	vyBody.vis(_Pt0, 2);
//	vzBody.vis(_Pt0, 3);
	_PtG[0] = _Pt0 -+ vDir * U(63.5);
	
//End reposition ptg at the upper part of the connector//endregion

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
		Element elHW =gb.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)gb;
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
		
		String sType = "Framing Anchor";
		HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
		
		String sManufacturer = "Cullen";
		hwc.setManufacturer(sManufacturer);
		
//			hwc.setModel(sProductCode);
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		String sMaterial = "galvanised mild steel - Z275";
		hwc.setMaterial(sMaterial);
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(gb);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
//			hwc.setDScaleX(U(180));
//			hwc.setDScaleY(U(85));
//			hwc.setDScaleZ(U(1.2));
	// uncomment to specify area, volume or weight
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
	// annular ringshank nails
	{ 
		String sType = "Annular Ringshank Nails";
		HardWrComp hwc(sType, 18); // the articleNumber and the quantity is mandatory
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(gb);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		// diameter
		hwc.setDScaleX(U(50));
		hwc.setDScaleY(U(3.35));
	// apppend component to the list of components
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
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="1328" />
        <int nm="BREAKPOINT" vl="1333" />
        <int nm="BREAKPOINT" vl="770" />
        <int nm="BREAKPOINT" vl="773" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20923: Add property text size; fix position of bracket; allow manual or automatic assignment (global); show qty in plan view" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="6/25/2024 10:21:55 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End