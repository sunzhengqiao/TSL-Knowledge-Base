#Version 8
#BeginDescription
version value="2.5" date="21Nov2018" author="thorsten.huck@hsbcad.com"
minor bugfix reading settings 

bugfix purging references on splitting a system
coordinate systems fixed
new prompt to align first vertical segment
tag data published

parent reference set to child
hardware export added
linework display corrected
automatic creation of default catalog entries
dialog behaviour improved

This tsl assigns HVAC data to a set of beams
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
//region Part 1

//region Header

/// <History>
/// <version value="2.5" date="21Nov2018" author="thorsten.huck@hsbcad.com"> minor bugfix reading settings </version>
/// <version value="2.4" date="20Nov2018" author="thorsten.huck@hsbcad.com"> bugfix purging references on splitting a system </version>
/// <version value="2.3" date="25oct2018" author="thorsten.huck@hsbcad.com"> coordinate systems fixed, new prompt to align first vertical segment, tag data published </version>
/// <version value="2.2" date="09aug2018" author="thorsten.huck@hsbcad.com"> parent reference set to child, hardware export added, linework display corrected </version>
/// <version value="2.1" date="08aug2018" author="thorsten.huck@hsbcad.com"> automatic creation of default catalog entries </version>
/// <version value="2.0" date="08aug2018" author="thorsten.huck@hsbcad.com"> dialog behaviour improved </version>
/// <version value="1.9" date="07aug2018" author="thorsten.huck@hsbcad.com"> renamed to HVAC, opm Names introduced </version>
/// <version value="1.8" date="20jun2018" author="thorsten.huck@hsbcad.com"> references published </version>
/// <version value="1.7" date="19Jul2018" author="thorsten.huck@hsbcad.com"> automatic detection and flow recognition enhanced, commands to add, remove and combine are now obsolete </version>
/// <version value="1.6" date="17jul2018" author="thorsten.huck@hsbcad.com"> sequencing further enhanced, new custom command to combine two systems, new custom command for color override </version>
/// <version value="1.5" date="21jun2018" author="thorsten.huck@hsbcad.com"> sequencing of system enhanced </version>
/// <version value="1.3" date="20jun2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

/// <remark Lang=en>
/// Requires settings file HVAC.xml in the <company>\tsl\settings path
/// </remark>

/// <summary Lang=en>
/// This tsl assigns HVAC data to a set of beams. 
/// </summary>

/// commands
// command to insert and assign
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HVAC")) TSLCONTENT 
// command to insert and assign with a given family
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HVAC" "<FAMILYNAME>")) TSLCONTENT 
// command to insert and assign with a given family and child name
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HVAC" "<FAMILYNAME>?<ENTRYNAME>")) TSLCONTENT 
// command to toggle one or multiple ductworks to 3D appearance
// ^C^C(defun c:TSLCONTENT() (hsb_recalcTslWithKey (_TM "|3D Ductwork|") (_TM "|Select ductwork(s)|"))) TSLCONTENT
// command to toggle one or multiple ductworks to linework appearance
// ^C^C(defun c:TSLCONTENT() (hsb_recalcTslWithKey (_TM "|Linework|") (_TM "|Select ductwork(s)|"))) TSLCONTENT
// command to erase an entire ductwork with all references
// ^C^C(defun c:TSLCONTENT() (hsb_recalcTslWithKey (_TM "|Erase|") (_TM "|Select ductwork(s)|"))) TSLCONTENT

//End Header//endregion 

//region Constants
	U(1,"mm");	
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
//End Constants//endregion 	

//region MAPIO collect connections iterating through attached tools
	// concept 
	// starting from one base beam the next beam will be marked if it connects on positive or negative X-direction
	// once marked it will hand over this information to potential next beam. Doing this we know all beams connecting to the start or end of the base beam
	// looking to the direction of the connected beam towards the previous we now know if the flow direction needs to be flipped in relation o the coordSys of the base beam
	if (_bOnMapIO)// || (bDebug && _Beam.length()>0))
	{ 
		int bDebugIO=bDebug;
		//if(bDebugIO)reportMessage("\nmapIO executes " + bDebug);
		
		Beam bm;
		Entity entDef = _Map.getEntity("entDef");
		bm = (Beam)entDef;
			
	// validate beam
		if (!bm.bIsValid())
		{ 
			reportMessage("\nmapIO failed due to invalid beam.");
			return;
		}
		if(bDebugIO)reportMessage("\nSearching connections of " + bm.posnum());

	// get beam properties and axis
		Vector3d vecX = bm.vecX();
		Vector3d vecY = bm.vecY();
		Vector3d vecZ = bm.vecZ();
		Point3d ptCen = bm.ptCenSolid();
		double dX = bm.solidLength();
		PLine plAxis(ptCen - vecX * .5 * dX, ptCen + vecX * .5 * dX);
		plAxis.vis(2);
		
	// get connected beams of this stream
		Entity entTslRefs[] = _Map.getEntityArray("TslRef[]", "", "TslRef");
		Entity entRefs[] = _Map.getEntityArray("BeamRef[]", "", "BeamRef");//ptDirs and ptDirs to be of same length !!
		Point3d ptDirs[] = _Map.getPoint3dArray("PtDir[]");
		
	// find out if this beam is tail or head connected in raltion to the base beam => 0 = is base beam	
		int x = entRefs.find(bm);
		if (x<0)
		{ 
			reportMessage("\nmapIO failed ref beam not in list.");
			return;
		}		
		int nBaseTailHead = ptDirs[x].Y(); // -1 = tail, 0 = base, 1 = head 
		
	// get connected beams via connected tsls
		Entity eTools[] = bm.eToolsConnected();	
		for (int e=0;e<eTools.length();e++)
		{
			TslInst tsl= (TslInst)eTools[e];
			if (!tsl.bIsValid())continue;
			Map map = tsl.map();
			String k = "ptConnect[]";
			Point3d pts[]=map.getPoint3dArray(k);
			if(bDebugIO)reportMessage("\n	"+tsl.scriptName() + " " + tsl.handle() +" " + pts.length() + + " connection points");
			if (pts.length() != 2)continue;
		
		// find connection
			int nTailHeadA;// 0 = not found, -1 =Start, 1=end +vecX
			Point3d ptB; // the connection point to the other beam
			for (int p=0;p<pts.length();p++) 
			{ 
			// connection found	
				if (plAxis.isOn(pts[p]))
				{ 
					nTailHeadA = vecX.dotProduct(pts[p] - ptCen)>0?1:-1;
					ptB = p == 0 ? pts[1] : pts[0];
					break;
				}	 
			}//next p
			
		// get connected beams
			if (bDebugIO)reportMessage("\n tsl connects in direction " + nTailHeadA);
			Beam bmConnections[] = tsl.beam();
			for (int i=0;i<bmConnections.length();i++) 
			{ 
				Beam& b= bmConnections[i];
				if (bDebugIO)reportMessage("\n ...connecting" +b.posnum());
				if (b != bm && entRefs.find(b)<0)
				{
				// get beam properties and axis
					Vector3d vecXB = b.vecX();
					Point3d ptCenB = b.ptCenSolid();
					double dXB = b.solidLength();
					PLine plBAxis(ptCenB - vecXB * .5 * dXB, ptCenB + vecXB * .5 * dXB);					
	
				//	if (bDebugIO)
				//	{ 
				//		EntPLine epl;
				//		epl.dbCreate(plBAxis);
				//	}
	
				// connection found	
					int nTailHeadB;
					if (plBAxis.isOn(ptB))
					{ 
						nTailHeadB = vecXB.dotProduct(ptB - ptCenB)>0?1:-1;
						
					}	
					if(bDebugIO)reportMessage("\n	Beam " + bm.posnum() + " connects with head/tip" + nTailHeadB);

					int nThisTailHead = nBaseTailHead == 0 ? nTailHeadA : nBaseTailHead;
					int nFlipXDir =- nThisTailHead * nTailHeadB;
					//if(bDebugIO)reportMessage("\n	nBaseTailHead: " +nBaseTailHead + " nTailHeadA: " +nTailHeadA +" nThisTailHead: " +nThisTailHead +" nFlipXDir: " +nFlipXDir);
					
					entRefs.append(b);
					ptDirs.append(Point3d(nFlipXDir,nThisTailHead,0));
					entTslRefs.append(tsl);
					
					
					Map mapIO;
					mapIO.setEntity("entDef",b);
					mapIO.setEntityArray(entTslRefs, false, "TslRef[]", "", "TslRef");
					mapIO.setEntityArray(entRefs, false, "BeamRef[]", "", "BeamRef");
					mapIO.setPoint3dArray("PtDir[]", ptDirs);
					TslInst().callMapIO(scriptName(), mapIO);	
									
				// get new list of referenced beams
					Entity entNewRefs[] = mapIO.getEntityArray("BeamRef[]", "", "BeamRef");
					Point3d ptNewDirs[] = mapIO.getPoint3dArray("PtDir[]");	
					for (int j=0;j<entNewRefs.length();j++) 
					{ 
						if (entRefs.find(entNewRefs[j])>-1) continue;
						entRefs.append(entNewRefs[j]);
						ptDirs.append(ptNewDirs[j]);
					}
					Entity entNewTslRefs[] = mapIO.getEntityArray("TslRef[]", "", "TslRef");
					for (int j=0;j<entNewTslRefs.length();j++) 
					{ 
						if (entTslRefs.find(entNewTslRefs[j])>-1) continue;
						entTslRefs.append(entNewTslRefs[j]);
					}					
					break; // should be only one beam
				}
			}//next i
			//tsl.ptOrg().vis(nDir + 1);
		}// next e eTools

		Map mapOut;
		mapOut.setEntityArray(entRefs, false, "BeamRef[]", "", "BeamRef");
		mapOut.setPoint3dArray("PtDir[]",ptDirs);
		mapOut.setEntityArray(entTslRefs, false, "TslRef[]", "", "TslRef");
		_Map = mapOut;
		return;
	}
//End MapIO//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="HVAC";
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
// Get dispReps and properties  
// defaults
	String sDimStyle = _DimStyles.length() > 0 ? _DimStyles[0] : "";
	double dTextHeight = U(100);

	String sDispReps[] = _ThisInst.dispRepNames();
	String sDispRep;

// properties
	int nColor=1,nColorText=255, nt; // color and transparency
	double dWidth; // 
	double dHeight, dLineTypeScale, dPatternScale, dPatternAngle,dFlowOffset, dFlowSize;
	double dRadius;// specifies the bending radius of tubular duct work
	double dDiameter, dInsulation; // the diameter of tubular duct work
	String sPattern, sLineType;
	String sHWArticleNumber, sHWModel, sHWManufacturer, sHWDescription, sHWCategory, sHWNotes,sHWMaterial;

// collect Families from settings file
	String sFamilies[0], sTFamilies[0];
	Map mapFamilies[0];
	{
	// Family[]	
		String k;
		Map m= mapSetting.getMap("Family[]");
		for (int i=0;i<m.length();i++) 
		{ 
			Map m2 = m.getMap(i);
			String sFamily = m2.getString("Name");
			if (sFamilies.find(sFamily)<0)
			{ 
				mapFamilies.append(m2);
				sFamilies.append(sFamily);
				sTFamilies.append(T(sFamily));
			} 
		}
		
	// order alphabetically
		for (int i=0;i<sFamilies.length();i++) 
			for (int j=0;j<sFamilies.length()-1;j++)
			if (sFamilies[j]>sFamilies[j+1])
			{ 
				sFamilies.swap(j, j+1);
				sTFamilies.swap(j, j+1);
				mapFamilies.swap(j, j+1); 
			}

	// DISPLAY	
		m= mapSetting.getMap("Display");
		k="TextHeight";			if (m.hasDouble(k))	dTextHeight = m.getDouble(k);
		k="DispRepName";		if (m.hasString(k) && TslInst().dispRepNames().find(m.getString(k))>-1)	sDispRep = m.getString(k);
		k="DimStyle";			if (m.hasString(k) && _DimStyles.find(m.getString(k))>-1)	sDimStyle = m.getString(k);		
	}		


//End Read Settings//endregion 

//region Properties
// Properties
	String sFamilyName=T("|Family|");	
	PropString sFamily(nStringIndex++, sTFamilies, sFamilyName,0);	
	sFamily.setDescription(T("|Defines the Duct Work|"));
	sFamily.setCategory(category);

	int nFamily = sTFamilies.find(sFamily);
	Map mapFamily; if (nFamily >- 1)mapFamily = mapFamilies[nFamily];
// collect childs of selected family
	String sChilds[0];
	Map mapChilds=mapFamily.getMap("Child[]");
	for (int i=0;i<mapChilds.length();i++) 
	{ 
		Map mapChild = mapChilds.getMap(i); 
		String sChild = T(mapChild.getString("Name"));
		if (sChild.length()>0 && sChilds.find(sChild)<0)
			sChilds.append(sChild);	 
	}

// order alphabetically
	for (int i=0;i<sChilds.length();i++) 
		for (int j=0;j<sChilds.length()-1;j++)
		if (sChilds[j]>sChilds[j+1])
		{ 
			sChilds.swap(j, j+1);
		}

	String sChildName=T("|Model|");	
	PropString sChild(nStringIndex++, sChilds, sChildName,0);	
	sChild.setDescription(T("|Defines the Duct Work|"));
	sChild.setCategory(category);		
//End Properties//endregion 

//region OnInsert
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// get insert key
		String sKey = _kExecuteKey;
		sKey.makeUpper();

	// Beam based insertion: prompt for beams when convert key is found
		int bBeamAssignment = sKey.find("BEAMASSIGN", 0) >- 1;			
		if (bBeamAssignment)
		{
			Beam beams[0];
			PrEntity ssE(T("|Select beam(s)|"), Beam());
			if (ssE.go())
				beams.append(ssE.beamSet());
				
		// Preselect family and child if map can be found
			int bPreselected;
			for (int i=0;i<beams.length();i++) 
			{ 
				Beam& bm = beams[i]; 
				Map mapChild = bm.subMapX("HvacChild");
				String sThisFamily= mapChild.getString("FamilyName");
				String sThisChild = mapChild.getString("Name");
				
				//reportMessage("\nsThisFamily: " + sThisFamily + " child" + sThisChild);
			// find family	
				int nFamily = sFamilies.find(sThisFamily);
				if (nFamily>-1)
				{ 
					sFamily.set(sThisFamily);
				// find child of family
					Map _mapChilds=mapFamilies[nFamily].getMap("Child[]");
					for (int i=0;i<_mapChilds.length();i++) 
					{ 
						Map m = _mapChilds.getMap(i); 
						if (sThisChild==m.getString("Name"))
						{
							sChild.set(sThisChild);	 
							bPreselected = true;
							break;
						}
					}
				}
			}
			
		// Show dialogs to select family and child
			if (!bPreselected)
			{ 
			// lock child property
				sChild.setReadOnly(true);
				
			// silent/dialog	
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
					
			// get properties of selected Family	
				nFamily = sTFamilies.find(sFamily,0);
				if (nFamily<0)
				{
					reportMessage(TN("|Invalid definition|"));
					eraseInstance();
				}
			// valid family	
				else 
				{
				// collect childs of selected family
					String sChilds[0];
					Map mapChilds=mapFamilies[nFamily].getMap("Child[]");
					for (int i=0;i<mapChilds.length();i++) 
					{ 
						Map mapChild = mapChilds.getMap(i); 
						String sChild = T(mapChild.getString("Name"));
						if (sChild.length()>0 && sChilds.find(sChild)<0)
							sChilds.append(sChild);	 
					}
				
				// order alphabetically
					for (int i=0;i<sChilds.length();i++) 
						for (int j=0;j<sChilds.length()-1;j++)
						if (sChilds[j]>sChilds[j+1])
						{ 
							sChilds.swap(j, j+1);
						}
				
					String sChildName=T("|Type|");	
					sChild=PropString (1, sChilds, sChildName,0);	
					
				// un-lock properties	
					sChild.setReadOnly(false);
					sFamily.setReadOnly(true);
					if (sKey.length()<1)
					{
					// use the untranslated family name as opm key
						String s = sFamilies[nFamily];
						if (s.left(1) == "|")s = s.right(s.length() - 1);
						if (s.right(1) == "|")s = s.left(s.length() - 1);
						int x = s.find(" ", 0);
						while(x>-1)
						{ 
							s = s.left(x) + s.right(s.length() - x-1);
							x = s.find(" ", 0);
						}
						setOPMKey(s);	
						showDialog();
					}
				}					
			}	
			
		// create an HVAC based on selected beams
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[1];			Entity entsTsl[] = {};			Point3d ptsTsl[1];
			int nProps[]={};			double dProps[]={};				String sProps[]={sFamily, sChild};
			Map mapTsl;	
			
			for (int i=0;i<beams.length();i++) 
			{ 
				Beam& b = beams[i];
				gbsTsl[0]=b; 
				ptsTsl[0] = b.ptCen();
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			}//next i
			eraseInstance();
			return;		
		}
	
	// Specify dialogs 
	// Get opm name by tokenized convention i.e. <FamilyName>?<CatalogEntry>
		String sTokens[] = _kExecuteKey.tokenize("?");
		String sOpmKey = sTokens.length() > 0 ? sTokens[0] : "";
		//reportMessage("\n" + scriptName() + ": " +sOpmKey + " tokens:" + sTokens);
		
	// validate potential opmKey -> it should be one of the family names
		if (sOpmKey.length()>1)
		{ 
			String s1 = sOpmKey;
			s1.makeUpper();
			int bOk;
			for (int i = 0; i < sFamilies.length(); i++)
			{
				String s2 = sFamilies[i];
				s2.makeUpper();
				if (s1 == s2)
				{
					bOk = true;
					sFamily.set(T(sFamilies[i]));
					setOPMKey(sFamilies[i]);
					sFamily.setReadOnly(true);
					break;
				}	 
			}//next i
		// the opmKey does not match any family name -> reset
			if (!bOk)
			{
				reportMessage("\n" + scriptName() + ": " +T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of families.|"));
				sOpmKey = "";
			}
		}
		
	// try to get entries of the family	
		int bShowChildDialog, bWriteDefaultCatalogs;
		if (sOpmKey.length()>1 && sTokens.length()>1)
		{
			String sOpmName = scriptName() + "-" + sOpmKey;

			String sEntry = sTokens[1];
			sEntry.makeUpper();
			String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);
			//reportMessage("\ntry to get entries of the family opmName = "+sOpmName+ "\nentries " + sEntries);
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
		// silent: entry found	
			if (sEntries.find(sEntry)>-1)
			{
				setPropValuesFromCatalog(sTokens[1]);
				//reportMessage("\n silent entry" + sTokens[1]);
			}
		// entry not found, show dialog with preset family
			else
				bShowChildDialog=true;
		}
	// family found as opmKey, but no catalog entry found, show dialog with preset family
		else if (sOpmKey.length()>1)
		{ 
			//reportMessage("\n family found but no child" + sFamily + " " +sTokens[0]);
			bShowChildDialog = true;
			bWriteDefaultCatalogs = true;
		}
	// no family and no catalog entry found, show 2 step dialogs
		else
		{
			sChild.set("---");
			sChild.setReadOnly(true);
			showDialog("---");	
			setOPMKey(sFamily);			
			bShowChildDialog = true;
			bWriteDefaultCatalogs = true;
		}
			
	// show child / model dialog		
		if (bShowChildDialog)
		{ 
		// get properties of selected Family	
			nFamily = sTFamilies.find(sFamily,0);
			if (nFamily<0)
			{
				reportMessage(TN("|Invalid definition|"));
				eraseInstance();
			}
		// valid family	
			else 
			{
			// collect childs of selected family
				String sChilds[0];
				Map mapChilds=mapFamilies[nFamily].getMap("Child[]");
				for (int i=0;i<mapChilds.length();i++) 
				{ 
					Map mapChild = mapChilds.getMap(i); 
					String sChild = T(mapChild.getString("Name"));
					if (sChild.length()>0 && sChilds.find(sChild)<0)
						sChilds.append(sChild);	 
				}
			
			// order alphabetically
				for (int i=0;i<sChilds.length();i++) 
					for (int j=0;j<sChilds.length()-1;j++)
					if (sChilds[j]>sChilds[j+1])
					{ 
						sChilds.swap(j, j+1);
					}
			
				String sChildName=T("|Type|");	
				sChild=PropString (1, sChilds, sChildName,0);	
				
			// un-lock properties	
				sChild.setReadOnly(false);
				sFamily.setReadOnly(true);
				showDialog();
			}	
		}
		
		
	// write default catalogs
		if (bWriteDefaultCatalogs)
		{ 
		// buffer current values
			String sCurrentFamily = sFamily;
			String sCurrentChild = sChild;
			
		// writing default catalog entries
			String sNotices[0];
			
			for (int f=0;f<sFamilies.length();f++) 
			{ 
				sFamily.set(sFamilies[f]);
				setOPMKey(sFamily);
				String sOpmName = scriptName()+"-"+sFamily;
				String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);
				
				String sEntriesNotice = T("	|Family| ") + sFamily + T(" |has the following entries|: " + sEntries);
				
			// collect childs of selected family
				String _sChilds[0];
				Map mapChilds=mapFamilies[f].getMap("Child[]");

				for (int i=0;i<mapChilds.length();i++) 
				{ 
					Map mapChild = mapChilds.getMap(i); 
					String _sChild = T(mapChild.getString("Name"));
					
					if (_sChild.length()>0 && _sChilds.find(_sChild)<0)
					{
					// create new entry
						String sChildNotice;
						if (sEntries.find(_sChild)<0)
						{ 
							sChildNotice =T("		") + _sChild +T(" |entry created|");
							sChild.set(_sChild);
							setCatalogFromPropValues(_sChild);
							
							if (sEntriesNotice.length() > 0)
							{
								sNotices.append(sEntriesNotice);
								sEntriesNotice = "";
							}
							sNotices.append(sChildNotice);								
						}
						_sChilds.append(_sChild);	 
					}
				}
			}//next i
			
			if (sNotices.length()>0)
				sNotices.insertAt(0, scriptName() + T(": |writing missing default catalog entries of| ") +sFamilies.length()+ T(" |families|"));
				
			for (int i=0;i<sNotices.length();i++) 
			{ 
				reportNotice("\n" +sNotices[i]);
			 
			}//next i
			
			sFamily.set(sCurrentFamily);
			setOPMKey(sFamily);
			sChild.set(sCurrentChild);
		}
		
		

	// Get family data	
		nFamily = sTFamilies.find(sFamily);
		mapFamily; if (nFamily >- 1)mapFamily = mapFamilies[nFamily];
	
	// family data	
		Map m = mapFamilies[nFamily];
		String k;
		k="Color";			if (m.hasInt(k))	nColor = m.getInt(k);
		k="LineType";		if (m.hasString(k))	sLineType = m.getString(k);
		k="LineTypeScale";	if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);

		Map mapChilds=mapFamily.getMap("Child[]");
		for (int i=0;i<mapChilds.length();i++) 
		{ 
			Map mapChild = mapChilds.getMap(i); 
			String sChild = T(mapChild.getString("Name"));
			if (sChild.length()>0 && sChilds.find(sChild)<0)
				sChilds.append(sChild);	 
		}
		
		// order alphabetically
		for (int i=0;i<sChilds.length();i++) 
			for (int j=0;j<sChilds.length()-1;j++)
			if (sChilds[j]>sChilds[j+1])
			{ 
				sChilds.swap(j, j+1);
			}		
		
		
	// Get selected child map and its data 
		Map mapChild;
		for (int i=0;i<mapChilds.length();i++) 
		{ 
			Map m = mapChilds.getMap(i);
			if (m.getString("Name")==sChild)
			{ 
				mapChild = m;
			// append family name to support preselection of existing ductworks	
				mapChild.setString("FamilyName", sFamily);
				break;
			}	 
		}
	
		if (mapChild.length()<1)
		{ 
			reportMessage(TN("|Unexpected error reading child data of family| ")+sFamily + " / " + sChild + "\n"+ mapFamilies);
			eraseInstance();
			return;	
		}
		else
		{ 
			Map m = mapChild;
			String k;
			k="Height";		if (m.hasDouble(k))	dHeight = m.getDouble(k);
			k="Width";		if (m.hasDouble(k))	dWidth = m.getDouble(k);
			k="Radius";		if (m.hasDouble(k))	dRadius = m.getDouble(k);
			k="Diameter";	if (m.hasDouble(k))	dDiameter = m.getDouble(k);
			k="Insulation";	if (m.hasDouble(k))	dInsulation = m.getDouble(k);
		}
		double dThisDiameter = dDiameter + 2 * dInsulation;
		String sName = mapChild.getString("Name");
		double dFlowSize = U(150);			
	
	// Get potential flows
		int nSelectedFlow = _Map.getInt("SelectedFlow");
		Map mapFlows = mapChild.getMap("Flow[]");
		Map mapFlow = mapFlows.getMap(nSelectedFlow);
		int nFeedDir = 1;
		{ 
			Map m = mapFlow;
			String k;
			k="Color";			if (m.hasInt(k))	nColor = m.getInt(k);
			k="LineType";		if (m.hasString(k))	sLineType = m.getString(k);
			k="LineTypeScale";	if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
			k="SymbolSize";		if (m.hasDouble(k))	dFlowSize = m.getDouble(k);
			k="Feed";			if (m.hasInt(k))	nFeedDir = m.getInt(k);
		}		
	
	// Set insert UCS
		Vector3d vecX = _XU; 
		Vector3d vecY = _YU; 
		Vector3d vecZ = _ZU; 

	// declare option string
		String sElevation;
	
	// get elevation from current group if set
		double dElevation;
		if (_kCurrentGroup.namePart(1) !="")
		{
			Group gr = _kCurrentGroup.namePart(0) +"\\" + _kCurrentGroup.namePart(1);
			dElevation = gr.dFloorHeight();
		}
		
		
	// prompt for point input
		Point3d ptNew;
		PrPoint ssP(TN("|Select point|") + T(" |<Enter> to specify elevation|")); 
		if (ssP.go()==_kOk) 
		{
			ptNew=ssP.value();
			dElevation = ptNew.Z();
		}
	// prompt for elevation	
		else
		{ 
			sElevation= getString(T("|Elevation|")+ " (" + T("|<Enter>|") + "=" +dElevation + ")");
			if (sElevation!="")
				dElevation = sElevation.atof();		
			ptNew = getPoint();
			ptNew.transformBy(vecZ*vecZ.dotProduct((_PtW+vecZ*dElevation)-ptNew));	
				
		}
	// append first grip
		_PtG.append(ptNew);

		//dElevation = _PtG.Z();
		Point3d ptLast = ptNew;
		String sMsg=TN("|Pick next point, <Enter> to change elevation|");
		String sMsg3D=TN("|Pick next point in 3D, <Enter> to change mode|");
		EntPLine eplJigs[0];
		int b3D;
		int nExitCounter;
		
	// the previous created beam specifies the alignment of the new beam 	
		Point3d pt1=ptLast, pt2;
		Beam bmP;
		GenBeam genbeams[0];
		TslInst tslGConnectors[0];
		while (1)
		{
			int bExit;
			String sPrompt = sMsg+ " " + dElevation;
			if (b3D)
				sPrompt =sMsg3D;
			
			PrPoint ssP(sPrompt,ptLast); 
			if (ssP.go()==_kOk) 
			{
				Point3d ptNew = ssP.value();
			// plan view mode keeps the elevation unless the selected point has only a different z componnet	
				if (!b3D)
				{
					Point3d pt = ptNew;
					double dZ = vecZ.dotProduct(ptNew-ptLast);
					ptNew.transformBy(vecZ*vecZ.dotProduct((_PtW+vecZ*dElevation)-ptNew));
					
					if (abs(dZ)>dEps && Vector3d(ptNew-ptLast).length()<dEps)
					{	
						dElevation = vecZ.dotProduct(pt-_PtW);
						ptNew = pt;
						if (bDebug) reportMessage("\nvertical pick = " +dElevation);
					}
					else
					{
						if (bDebug) reportMessage("\nEleveation kept = " +dElevation);
					}
				}
				else
					dElevation = vecZ.dotProduct(ptNew-_PtW);
					
				_PtG.append(ptNew); // append the selected points to the list of grippoints _PtG		
				pt2 = ptNew;
				
//				// add jig segment
//					EntPLine epl;
//					PLine pl(_PtG[_PtG.length()-2],_PtG[_PtG.length()-1]);
//					if (pl.length()>dEps)
//					{
//						epl.dbCreate(pl);
//						epl.setColor(nColor);
//						eplJigs.append(epl);
//					}	
				ptLast = _PtG[_PtG.length()-1];
				nExitCounter=0;					
			}
			else if (nExitCounter>0)
				bExit=true;
			else
			{
				if (b3D)
					sElevation= getString(T("|Elevation|") +" [" + T("|End|")+"]: " +dElevation).makeUpper();				
				else
					sElevation= getString(T("|New Elevation| (") +dElevation+ T(") [|Point3D|]") +  T(" |<Enter> to exit|")).makeUpper();//dElevation
				if (bDebug) reportMessage("\nyou have entered = " +sElevation + " as input");
				
			// enter -> take current value or prepare exit
				if (sElevation=="")
				{
					bExit=true;
//						bExit= nExitCounter>0;
//						nExitCounter++;
//						if (bDebug) reportMessage("\nreturn value = empty");
//						if (b3D)b3D=false;
				}
			// exit
				else if (sElevation.left(1)=="E")
				{
					bExit=true;
				}
			// switch to 3D mode
				else if (sElevation.left(1)=="P")
				{
					nExitCounter=0;
					if (bDebug) reportMessage("\nreturn value = 3D");
					b3D=true;
					continue;
				}
			// any input but no P, E or blank assumes anew elevation as input
				else
				{
					nExitCounter=0;
					b3D=false;
					double dNewElevation = sElevation.atof();
					
					if (bDebug) reportMessage("\nNewElevation  = " + dNewElevation );
				/// append vertical segment
					if (abs(dNewElevation-dElevation)>dEps)
					{
						if (bDebug) reportMessage("\nadding new point" );
						Point3d ptNew = _PtG[_PtG.length()-1];
						ptNew.transformBy(vecZ*vecZ.dotProduct((_PtW+vecZ*dNewElevation)-ptNew));	
						_PtG.append(ptNew);
						pt2 = ptNew;
						ptLast = _PtG[_PtG.length()-1];
//						// add jig segment
//							EntPLine epl;
//							PLine pl(_PtG[_PtG.length()-2],_PtG[_PtG.length()-1]);
//							if (pl.length()>dEps)
//							{
//								epl.dbCreate(pl);
//								epl.setColor(2);
//								eplJigs.append(epl);
//							}		
					}
					dElevation = dNewElevation;	
				}
			}			
			if (bExit)
			{
				if (bDebug) reportMessage("return value = exit");
//					for (int i=eplJigs.length()-1;i>=0;i--)
//						if (eplJigs[i].bIsValid())
//							eplJigs[i].dbErase();				
				break;					
			}


		// set dimensions	
			double dY=dWidth, dZ=dHeight;
			if (dThisDiameter>0)
			{ 
				dY = dThisDiameter;
				dZ = dThisDiameter;
			}
			

		// create beam
			Vector3d vecX = pt2 - pt1;
			double dX = vecX.length();
			pt1 = pt2;
			vecX.normalize();
			
			int bHasPrevious = bmP.bIsValid();

			if (bDebug)reportMessage("\n" + scriptName() + " vecX " +vecX+ (bHasPrevious?("EP "+ bmP.extrProfile() + " vs " +_kExtrProfRound):""));
			
		// vertical segement?
			Vector3d vecY,vecZ;
			int nCase = -1;
		// too short	
			if (dX<dEps)
			{
				reportMessage("\n" + scriptName() + ": " +T("|invalid length, try again.|"));
				nCase = 0;
				continue;
			}
			
			
			if (bHasPrevious)
			{ 
				Vector3d vecXP = bmP.vecX();
				Vector3d vecYP = bmP.vecY();
				Vector3d vecZP = bmP.vecZ();
			// parallel	
				if (vecX.isParallelTo(vecXP))
				{ 
					vecY = vecYP;
					vecZ = vecZP;
					nCase = 1;
				}
			// same plane Y
				else if (vecX.crossProduct(vecXP).isParallelTo(vecYP))
				{ 
					vecZ = vecX.crossProduct(vecYP);
					vecY = vecX.crossProduct(-vecZ);
					nCase = 2;
				}
			// same plane Z
				else if (vecX.crossProduct(vecXP).isParallelTo(vecZP))
				{ 
					vecY = vecX.crossProduct(-vecZP);
					vecZ = vecX.crossProduct(vecY);
					nCase = 3;
				}	
			// ZP parallel X
				else if (vecX.isParallelTo(vecXP))
				{ 
					vecZ = vecX.crossProduct(vecYP)*(vecX.isCodirectionalTo(vecXP)?1:-1);
					vecY = vecX.crossProduct(-vecZ);
					nCase = 4;
				}
			// rising	
				else
				{ 
					Vector3d vecXN = vecX.crossProduct(vecYP).crossProduct(-vecYP); vecXN.normalize();
					vecZ = vecXN.crossProduct(vecYP);
					vecY = vecX.crossProduct(-vecZ);
					vecZ = vecX.crossProduct(vecY);
					nCase = 5;
				}				
			}
			else
			{ 
			// first beam horizontal	
				if (!vecX.isParallelTo(_ZU))
				{
					vecZ = _ZU;
					vecY = vecX.crossProduct(-vecZ);
					nCase = 6;
				}
			// first beam vertical
				else
				{
					vecY = _YU;
				// get orientation if not round
					if (dThisDiameter<=0)
					{ 
					// prompt for point input
						Point3d pts[0];
						PrPoint ssP(TN("|Specify width direction|") + T(", |<Enter> = Y-UCS|"),ptNew); 
						if (ssP.go()==_kOk) 
							pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG
						
						if (pts.length()>0 && !Vector3d(ptNew-pts[0]).bIsZeroLength())
						{ 
							Point3d pt = pts[0];
							pt += _ZU * _ZU.dotProduct(ptNew - pt);
							vecY = pt - ptNew;
							vecY.normalize();
						}						
					}
					vecZ = vecX.crossProduct(vecY);
					nCase = 7;
				}			
			}
						
			if (bDebug)reportMessage("\n" + scriptName() + " vector assignment case: " +nCase + "\n	"+vecX+ "\n	"+vecY+ "\n	"+vecZ);
			

		
		// create beam
			Beam bmN;
			if (dX>dEps && dY>dEps && dZ>dEps)
			{ 
				bmN.dbCreate(_PtG[_PtG.length() - 1], vecX, vecY, vecZ, dX,dY, dZ ,- 1, 0, 0);
				if (!bmN.bIsValid())continue;
				bmN.setSubMapX("HvacChild", mapChild);
				bmN.setColor(nColor);
				bmN.setName(sChild);
			// set extr prof	
				if (dThisDiameter>0)
				{ 
					bmN.setExtrProfile(_kExtrProfRound);
				}
				genbeams.append(bmN);
				
			// add connector
				if (bmP.bIsValid() && !vecX.isParallelTo(bmP.vecX()))
				{ 
				// prepare tsl cloning
					TslInst tslNew;
					GenBeam gbsTsl[] = {bmN,bmP};	Entity entsTsl[] = {};		Point3d ptsTsl[] = {};
					int nProps[]={};		double dProps[]={};					String sProps[]={};
					Map mapTsl;	
					tslNew.dbCreate("HVAC-G" , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);
							
					if(tslNew.bIsValid())
						tslGConnectors.append(tslNew);	
							
				}
				
			// create hvac system
				if (!bmP.bIsValid())
				{ 
					TslInst tslNew;			Entity entsTsl[] = {};		Point3d ptsTsl[] = {genbeams[0].ptCenSolid()};
					int nProps[]={};		double dProps[]={};			String sProps[]={sFamily, sChild};
					Map mapTsl;	
					
					tslNew.dbCreate("HVAC" , vecX ,vecY,genbeams, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);
					
					if (bDebug && tslNew.bIsValid())
					{ 
						reportMessage("\nHVAC System created with " + genbeams.length() + " returning " + tslNew.genBeam()+"!");
					}
					
					for (int t=0;t<tslGConnectors.length();t++) 
						tslGConnectors[t].recalc();//transformBy(Vector3d(0, 0, 0)); 
				}	
				bmP = bmN;
			}
			else
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|invalid dimensions, please check your configuration.|"));
				
			}

		}//end while		

		eraseInstance();
		return;		
	}	
// end on insert	__________________		


//End OnInsert//endregion 	

		


//End Part 1//endregion 

//region Part 2


// Standards of beam
	if (_Beam.length()<1)
	{ 
		reportMessage(TN("|Invalid reference|"));
		eraseInstance();
		return;
	}
	Beam bm = _Beam[0];
	Vector3d vecX = bm.vecX();
	Vector3d vecY = bm.vecY();
	Vector3d vecZ = bm.vecZ();
	Point3d ptCen = bm.ptCenSolid();
	double dX = bm.solidLength();
	PLine plAxis(ptCen - vecX * .5 * dX, ptCen + vecX * .5 * dX);
	//_Pt0 = plAxis.closestPointTo(_Pt0);
	assignToGroups(bm, 'I');

// Get selected child map and its data 
// get properties of selected Family	
	if (nFamily<0)
	{
		reportMessage(TN("|Invalid definition|"));
		eraseInstance();
		return;
	}
	if (!bDebug)sFamily.setReadOnly(true);
	setOPMKey(sFamily);

	Map mapChild;
	for (int i=0;i<mapChilds.length();i++) 
	{ 
		Map m = mapChilds.getMap(i);
		if (m.getString("Name")==sChild)
		{ 
			mapChild = m;
		// append family name to support preselection of existing ductworks	
			mapChild.setString("FamilyName", sFamily);
			break;
		}	 
	}

// get properties from family level
	{ 
		Map m = mapFamily;
		String k;
		k="SymbolOffset";	if (m.hasDouble(k))	dFlowOffset = m.getDouble(k);
		k="SymbolSize";		if (m.hasDouble(k))	dFlowSize = m.getDouble(k);
		k="ColorText";		if (m.hasInt(k))	nColorText = m.getInt(k);
	}


	if (mapChild.length()<1)
	{ 
		reportMessage(TN("|Unexpected error reading child data|"));
		eraseInstance();
		return;	
	}
	else
	{ 
		Map m = mapChild;
		String k;
		k="Height";		if (m.hasDouble(k))	dHeight = m.getDouble(k);
		k="Width";		if (m.hasDouble(k))	dWidth = m.getDouble(k);
		k="Radius";		if (m.hasDouble(k))	dRadius = m.getDouble(k);
		k="Diameter";	if (m.hasDouble(k))	dDiameter = m.getDouble(k);
		k="Insulation";	if (m.hasDouble(k))	dInsulation = m.getDouble(k);
		
		
	}
	double dThisDiameter = dDiameter + 2 * dInsulation;
	String sName = mapChild.getString("Name");
	

// Get potential flows
	int nSelectedFlow = _Map.getInt("SelectedFlow");
	Map mapFlows = mapChild.getMap("Flow[]");
	Map mapFlow = mapFlows.getMap(nSelectedFlow);
	int nFeedDir = 1;
	{ 
		Map m = mapFlow;
		String k;
		k="Color";			if (m.hasInt(k))	nColor = m.getInt(k);
		k="ColorText";		if (m.hasInt(k))	nColorText = m.getInt(k);
		k="LineType";		if (m.hasString(k))	sLineType = m.getString(k);
		k="LineTypeScale";	if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
		k="SymbolOffset";	if (m.hasDouble(k))	dFlowOffset = m.getDouble(k);
		k="SymbolSize";		if (m.hasDouble(k))	dFlowSize = m.getDouble(k);
		k="Feed";			if (m.hasInt(k))	nFeedDir = m.getInt(k);
	}
	
// get overrides
	if (_Map.hasMap("Override"))
	{ 
		Map m = _Map.getMap("Override");
		String k;
		k="Color";			if (m.hasInt(k))	nColor = m.getInt(k);
		k="SymbolSize";		if (m.hasDouble(k))	dFlowSize = m.getDouble(k);
	}


// _Pt0	
	if (_bOnDbCreated && abs(dFlowOffset)>dEps)	_Pt0 = ptCen + vecY*dFlowOffset;
	if (_kNameLastChangedProp == "_Pt0")
	{
		reportMessage(TN("|enter _kNameLastChangedProp=_Pt0|"));
		
		setExecutionLoops(2);
	}
//	else
//	{
//		double d = vecY.dotProduct(_Pt0 - ptCen);
//		reportMessage(TN("|enter d=| ")+d);
//		if (abs(dFlowOffset-abs(d))>dEps)
//			_Pt0 = ptCen + vecY*dFlowOffset;	
//	}
	if (_kNameLastChangedProp == sFamilyName)setExecutionLoops(2);

//End Part 2//endregion 	

//region Triggers

// Trigger select feed direction
	for (int i=0;i<mapFlows.length();i++) 
	{ 
		Map m = mapFlows.getMap(i);
		String sName = m.getString("Name");
		if (i == nSelectedFlow)continue;
		
	// Trigger select feed
		String sTriggerSelectFeed = "-> "+sName;
		addRecalcTrigger(_kContext, sTriggerSelectFeed );
		if (_bOnRecalc && _kExecuteKey==sTriggerSelectFeed)
		{
			_Map.setInt("SelectedFlow", i);

			setExecutionLoops(2);
			return;
		}	 
	}		
//End Trigger select feed direction

// Trigger Flip Flow
	int bFlipFlow = _Map.getInt("flip");
	String sTriggerFlipSide = T("|Swap Flow|") + T(" (|Doubleclick|)");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		if (bFlipFlow)bFlipFlow=false;
		else bFlipFlow=true;
		 _Map.setInt("flip",bFlipFlow);
		 
		setExecutionLoops(2);
		return;
	}			
//End Trigger Flip Flow

// Trigger ColorOverride
	String sTriggerColorOverride = T("|Set special color|");
	addRecalcTrigger(_kContext, sTriggerColorOverride );
	if (_bOnRecalc && _kExecuteKey==sTriggerColorOverride)
	{
		String k="Color";
		int n = getInt(T("|Enter color index|") + T(", |Index < 0 = remove special color|"));
		
		Map m = _Map.getMap("Override");
		if (m.hasInt(k) && n<0)
			m.removeAt(k, true);
		else
			m.setInt(k, n);	
		_Map.setMap("Override", m);
		setExecutionLoops(2);
		return;
	}	
	
// Trigger ToggleLinework
	int bDrawAsLinework = _Map.getInt("drawAsLineWork");
	String sTriggerToggleLinework =bDrawAsLinework?T("|3D Ductwork|"):T("|Linework|");
	addRecalcTrigger(_kContext, sTriggerToggleLinework);
	if (_bOnRecalc && _kExecuteKey==sTriggerToggleLinework)
	{
		bDrawAsLinework = bDrawAsLinework ? false : true;
		_Map.setInt("drawAsLineWork", bDrawAsLinework);	
		setExecutionLoops(2);
		return;
	}		
//End Trigger ToggleLinework	
//End Triggers//endregion

//region HVAC Connections
// find HVAC connections
	Entity entRefs[] ={bm};
	Point3d ptDirs[] = { Point3d(0, 0, 0)};// 0= this beam, 1=this beam connects to the positive x of the previous
	Map mapIO;
	mapIO.setEntity("entDef",bm);
	mapIO.setEntityArray(entRefs, false, "BeamRef[]", "", "BeamRef");
	mapIO.setPoint3dArray("PtDir[]", ptDirs);
	TslInst().callMapIO(scriptName(), mapIO);	

// get a list of all referenced beams
	Entity entAllRefs[] = mapIO.getEntityArray("BeamRef[]", "", "BeamRef");
	Point3d ptAllDirs[] = mapIO.getPoint3dArray("PtDir[]");
	Entity entAllTslRefs[] = mapIO.getEntityArray("TslRef[]", "", "TslRef");

// Purge any beam of _Entity which is not in the list of BeamRef[]
	for (int i=_Entity.length()-1; i>=0 ; i--) 
		if(_Entity[i].bIsKindOf(Beam()) && entAllRefs.find(_Entity[i])<0)
			_Entity.removeAt(i);	
	for (int i=_Beam.length()-1; i>=0 ; i--) 
		if(_Beam[i].bIsKindOf(Beam()) && entAllRefs.find(_Beam[i])<0)
			_Beam.removeAt(i);	

// Trigger Erase
	String sTriggerErase = T("|Erase|");
	addRecalcTrigger(_kContext, sTriggerErase );
	if (_bOnRecalc && _kExecuteKey==sTriggerErase)
	{
		for (int i=0;i<entAllRefs.length();i++) 
		{ 
			entAllRefs[i].dbErase(); 
			 
		}//next i
		eraseInstance();
		return;
	}	



// collect beam refs which have an HVAC attached to find out if this is the master
	Beam bmRefs[] = { bm};
	for (int i=0;i<entAllRefs.length();i++) 
	{ 
		Beam b= (Beam)entAllRefs[i];
		if (bm == b)continue; // thisinst has an hvac
		
		Entity eTools[] = b.eToolsConnected();
		int bHasHvac;
		for (int e = 0; e < eTools.length(); e++)
		{	
			TslInst tsl = (TslInst)eTools[e];
			if (tsl.bIsValid() && tsl.scriptName() == scriptName())
			{
				bHasHvac = true;
				bmRefs.append(b);
				break;
			}
		}
	}//next i

// order by handle
	for (int i=0;i<bmRefs.length();i++) 
		for (int j=0;j<bmRefs.length()-1;j++) 
			if (bmRefs[j].handle()>bmRefs[j+1].handle())
				bmRefs.swap(j, j + 1);

// flag me as master 
	int bIsMaster = bmRefs[0] == bm;
	
// kill me if I'm not the master
	if (!bIsMaster)
	{ 
		eraseInstance();
		return;
	}		


//End HVAC Connections//endregion 


// Display	
	Display dpPlan(nColor), dpTxt(nColorText), dpModel(nColor), dpSymbol(nColorText);
	dpSymbol.dimStyle(sDimStyle);
	dpSymbol.textHeight(dTextHeight);
	dpPlan.addViewDirection(_ZW);
	dpModel.addHideDirection(_ZW);
	

// get offset direction and offset value
	double dSymOffset;
	{ 
		Point3d ptX = Line(ptCen, vecX).closestPointTo(_Pt0);
		Vector3d vec = bm.vecD(_Pt0-ptX).isParallelTo(vecY)?vecY:vecZ;
		dSymOffset = vec.dotProduct(_Pt0-ptX);
	}
	if (bFlipFlow)dSymOffset *= -1;


// collect length of HVAC system
	double dStreamLength;

// collect shadow profile
	PlaneProfile ppPlan(CoordSys(ptCen, _XW, _YW, _ZW));
	Plane pnZ(ptCen, _ZW);

	for (int i=0;i<entAllTslRefs.length();i++) 
	{ 
		Entity ent = entAllTslRefs[i];
	
	// collect stream length component
		TslInst tsl = (TslInst)ent;
		if (tsl.bIsValid())	
		{ 
			Map m = tsl.map();
			if(m.hasPLine("plHvac"))
			{
				PLine pl = m.getPLine("plHvac");
				dStreamLength += pl.length();
			// draw linework
				if (bDrawAsLinework)
				{ 
					dpPlan.draw(pl);
				}	
			}
		}
		
		//ent.transformBy(Vector3d(0,0,0));
	// draw linework
		if (bDrawAsLinework)
		{ 
			;
		}
	// get plan shadow	
		else
		{ 
			Body bd = ent.realBody(_XW+_YW+_ZW);
			PlaneProfile pp = bd.shadowProfile(pnZ);
			PLine plRings[] = pp.allRings();
			int bIsOp[] = pp.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
					ppPlan.joinRing(plRings[r],_kAdd);				
		}
	}

// show the stream line	;
	for (int i=0;i<entAllRefs.length();i++) 
	{ 
		Beam b = (Beam)entAllRefs[i];
		_Entity.append(b);
		setDependencyOnEntity(b);
		
		
		Body bd=b.envelopeBody(true, true);
		PlaneProfile pp = bd.shadowProfile(pnZ);
		pp.vis(2);
		Vector3d vec = b.vecX() * U(10e4);
		LineSeg segs[]=pp.splitSegments(LineSeg(b.ptCenSolid()-vec ,b.ptCenSolid()+vec), true);
	
	// cummulate output length
		for (int s=0;s<segs.length();s++) 
		{ 
			dStreamLength+=segs[s].length();
			
		// publish tag data	
			if(s==0)
			{
				Map m; m.setPLine("plHvac",PLine(segs[s].ptStart(), segs[s].ptEnd()));
				b.setSubMapX("HVAC", m);
			}
		}//next s
		
		
	
	// draw linework
		if (bDrawAsLinework)
		{ 
			b.setIsVisible(false);
			dpPlan.draw(segs);		
		}
	// collect shadows
		else
		{ 
			b.setIsVisible(true);
		// get plan shadow
			PLine plRings[] = pp.allRings();
			int bIsOp[] = pp.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
					ppPlan.joinRing(plRings[r],_kAdd);
		}

		
		if (bDebug)bd.vis(i);
		int nFlipXDir= ptAllDirs[i].X();
		nFlipXDir = abs(nFlipXDir) == 1 ? nFlipXDir : 1;
		
		if (bFlipFlow) nFlipXDir *= -1;
		
		Vector3d vecXFlow = b.vecX() * nFlipXDir;
		Vector3d vecYFlow = vecXFlow.isParallelTo(_ZW)?b.vecD(-_YW):vecXFlow.crossProduct(-_ZW);
		
	// ref point on beam
		Point3d ptTxt = b.ptCen()+vecYFlow*dSymOffset;
		String sTxt = bm.extrProfile() == _kExtrProfRound ? "Ø" + dDiameter : bm.dW() + "x" + bm.dH();
		if (bDebug)sTxt += " ptDir:" + ptAllDirs[i];
		dpTxt.draw(sTxt, ptTxt, vecXFlow, vecYFlow, 1.2, 0, _kDevice);
	
	// create an arrow pline
		PLine plArrow;
		Body bdArrow;
		{
			double dArrowSize = dFlowSize;
			Point3d pt = ptTxt - vecXFlow * .5 * dFlowSize;pt.vis(2);
			Vector3d vecX =vecXFlow, vecY=b.vecY();
			plArrow=PLine(pt+vecX*.5*dArrowSize,pt+vecX*.25*dArrowSize+vecY*.1*dArrowSize,pt+vecX*.3*dArrowSize+vecY*.02*dArrowSize,pt-vecX*.3*dArrowSize+vecY*.02*dArrowSize);
			plArrow.addVertex(pt-vecX*.3*dArrowSize-vecY*.02*dArrowSize);
			plArrow.addVertex(pt+vecX*.3*dArrowSize-vecY*.02*dArrowSize);
			plArrow.addVertex(pt+vecX*.25*dArrowSize-vecY*.1*dArrowSize);
			plArrow.close();//plArrow.vis(2);	
			bdArrow = Body(pt+vecXFlow*.5*dArrowSize, pt +vecXFlow * .25 * dArrowSize, dEps, .1 * dArrowSize);
			bdArrow.addPart(Body(pt+vecXFlow * .25 * dArrowSize, pt - vecXFlow * .25* dArrowSize, .02 * dArrowSize));
			//bdArrow.transformBy(_XW * U(100));
			
			bdArrow.vis(5);
		}
		//dpSymbol.draw(plArrow);
		dpSymbol.draw(bdArrow);
		dpModel.draw(plArrow);
		
	// set diameter
		if (dThisDiameter>0)
		{
			if (abs(b.dW()-dThisDiameter)>dEps)
				b.setD(b.vecY(), dThisDiameter);
			if (abs(b.dH()-dThisDiameter)>dEps)
				b.setD(b.vecZ(), dThisDiameter);				
		}
	// set width / height	
		else
		{ 
		// set width
			if (abs(b.dW()-dWidth)>dEps)
				b.setD(b.vecY(), dWidth);
	
		// set height
			if (dHeight>0 && abs(b.dH()-dHeight)>dEps)
				b.setD(b.vecZ(), dHeight);			
		}

	// set extr prof	
		ExtrProfile ep = b.extrProfile();
		if (dThisDiameter>0 && ep.entryName()!=_kExtrProfRound)
		{ 
			b.setExtrProfile(_kExtrProfRound);
		}
		else if (dHeight>0 && ep.entryName()!=_kExtrProfRectangular)
		{ 
			b.setExtrProfile(_kExtrProfRectangular);
		}
		
//	// set color
		if (b.color()!=nColor)
		{ 
			b.setColor(nColor);	
			b.transformBy(Vector3d(0, 0, 0)); // transformning the beam triggers attached tsl to execute (and change color as well)
		}
	
	// set name
		if (b.name()!=sName)
		{ 
			b.setName(sName);
		}		
		mapChild.setEntity("HvacParent", _ThisInst);
		b.setSubMapX("HvacChild", mapChild);
		
		Map mapFlow;
		mapFlow.setInt("Direction", b.vecX().isCodirectionalTo(vecXFlow) ? 1 :- 1);
		b.setSubMapX("Flow", mapFlow);

	}//next i
	dpPlan.draw(ppPlan);
	
//End find HVAC connections

// Hardware
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
		Group groups[] = _ThisInst.groups();
		if (groups.length()>0)
			sHWGroupName=groups[0].name();
	}
	
// add main componnent and compareKey
	{ 
		String articleNumber= sFamily+ " " + sChild + " " + mapFlow.getString("Name");
		setCompareKey(scriptName() + "_" + articleNumber);
		
		HardWrComp hwc(articleNumber, 1); // the articleNumber and the quantity is mandatory
		
//		hwc.setManufacturer(sHWManufacturer);
		hwc.setModel(sChild);
		hwc.setName(sFamily);
		hwc.setDescription(T("|Ductwork|"));
//		hwc.setMaterial(sHWMaterial);
//		hwc.setNotes(sHWNotes);
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|HVAC|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dStreamLength);
		hwc.setDScaleY(dThisDiameter>0?dThisDiameter:dWidth);
		hwc.setDScaleZ(dThisDiameter>0?dThisDiameter:dHeight);
		
	// apppend component to the list of components
		hwcs.append(hwc);			

	}



// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
		

	
// publish references
	_Map.setMap("HVAC Collection", mapIO);
#End
#BeginThumbnail
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
!V>7Y
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End