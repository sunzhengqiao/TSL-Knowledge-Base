#Version 8
#BeginDescription
This tsl calculates and displays the insulation of an element

#Versions
Version 3.17 15/04/2025 HSB-23868: Add filter for Baufritz , Author Marsel Nakuci
Version 3.16 06/03/2025 HSB-23324: Make sure for roof elements the opening objects are projected from below , Author Marsel Nakuci
Version 3.15 06.02.2025 HSB-23324: Consider roof openings , Author: Marsel Nakuci
Version 3.14 06.02.2025 HSB-23324: Consider openings that are created after merging icon and opposite planeprofiles , Author: Marsel Nakuci
Version 3.13 24.01.2025 hsbMF-4779: Fix function that applies offset , Author: Marsel Nakuci
3.12 07.01.2025 HSB-22315: When Insulation Sheets are created the tsl Instance will not be considered for weight calculation Author: Marsel Nakuci
3.11 05.12.2024 HSB-23048: In elevation apply tolerance only on left and right; Dont apply tolerance on top and bottom Author: Marsel Nakuci
3.10 03/09/2024 HSB-22516: Add property "R-value" (ability to reduce rate of heat flow); value will be written in grade of insulation sheet Marsel Nakuci
3.9 31.05.2024 HSB-21103: remove tolerance in thickness Author: Marsel Nakuci
3.8 22/05/2024 HSB-21991: reorganise code  Marsel Nakuci
3.7 29/04/2024 HSB-21103: Change property name "Strategy"-> "Thickness variable": Add description Marsel Nakuci
3.6 25.04.2024 HSB-21103: 20240425: For insulation with fix thickness, make sure the insulation remains inside the zone; should not be outside of the zone space Author: Marsel Nakuci
3.5 05.04.2024 HSB-21103: Fix display and sheet generation when tolerance is used 
3.4 19/03/2024 HSB-21103: Add property "Gap" to apply gap around the insulation
3.3 11/03/2024 HSB-21590: (For Baufritz:) Newly inserted TSL instance at same zone will replace existing 
3.2 26.09.2023 HSB-19615: For Baufritz consider zone 6 as contour for the insulation 
Version 3.1 05.07.2023 HSB-19440 new context commands to disable/enable invetory database and to export settings, created sheet materials will be modified on property change , Author Thorsten Huck
3.0 04.07.2023 HSB-19440 bugfix for elements being created by TSL with a negative reference  height

2.28 30.06.2023 HSB-19139: remove remaining of convex hull from the insulaiton pp 
2.27 20.06.2023 HSB-18860: Use the property color for sheet if color in xml <=-3 
2.26 07.06.2023 HSB-19077: Keep insulation group from element group separated for Baufritz
2.25 12.05.2023 HSB-18801: Enter wait state if no element beam found (beams without panhand state)
2.24 13.03.2023 HSB-18309: Make sure insulation sheeting doesnot collides with corner female walls connected to this wall
2.23 15.02.2023 HSB-17824: Regen after changing group visibility in console 
2.22 14.12.2022 HSB-17354: If one side of the sheet zones - or + is open then it will be considered as eave area 
2.21 14.12.2022 HSB-17354: read from _Map to turn off Insulation groups; remove insulation at eave areas (Traufe, Ortgänge)
2.20 18.10.2022 HSB-16841: improve insulation when beams dont create a closed contour 
2.19 18.10.2022 HSB-16841: Support extra group assignment 
2.18 16.09.2022 HSB-12334: fix when investigating possible insulation thicknesses 
2.17 06.09.2022 HSB-16426: Improve voids from horizontal beams 
2.16 05.09.2022 HSB-16426: fix when filling voids 
2.15 02.09.2022 HSB-16061: shrink profile of insulation with 1mm to avoid tolerance errors when subtracting other beam bodies 
2.14 10.06.2022 HSB-15703: show description instead of article number, additional xml parameters 
2.13 27.05.2022 HSB-15541: Add property Strategy {<Default>,Rigid} to decide how the insulation will be cutted 
Version 2.12 09.03.2022 HSB-14868 material properties written to sheet entities, inventory groups can be specified in settings
Version 2.11 15.12.2021 HSB-14132: internal fix
Version 2.10 02.12.2021 HSB-13327: support multiple layers, add painter filter for walls
Version 2.9 10.11.2021 HSB-13713 loose contour detection improved
Version 2.8    29.07.2021    HSB-12741 model display not hidden anymore in Z and Y view of element
Version 2.7    30.06.2021    HSB-12469 bugfix insulation spanning into gable elements
Version 2.6    28.05.2021    HSB-12022 insulation detection enhanced for lath zones.
Version 2.5    07.05.2021    HSB-11781 insulation considers entities which are not fully spanning the zone thickness. 

Redundant property purged.
***NOTE***  It is recoomended to replcae existing instances with a new instance. 
When using the tsl as a construction plugin one should call the dialog once to update the properties , 


version value="2.4" date="20apr2021" 
HSB-11628 Bugfix error report.

HSB-HSB-8423 Tsl instance can be added once per zone, improvement of contour, add property to select different zone for contour, add property for assignement, hardware contains zone number in the notice.
HSB-7005 plan view hatch fixed
HSB-7005 solid default display disabled, transparency working for all patterns </version>
HSB-7005 new property to specify max height (walls only), new property to control transparency
HSB-8224 only items intersecting the zone considered for calculation
HSB-8223 Zone alignment fixed

HSB-7520: bug: write volume in m3, prompt to select Floor contour for Dach/Decke Elementen, add display for _ZW viewdirection
HSB-7238: write volume in m3
HSB-7238: read volumes from mapX











































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 17
#KeyWords insulation, Dämmung
#BeginContents
//region History
/// <History>
// #Versions
// 3.17 15/04/2025 HSB-23868: Add filter for Baufritz , Author Marsel Nakuci
// 3.16 06/03/2025 HSB-23324: Make sure for roof elements the opening objects are projected from below , Author Marsel Nakuci
// 3.15 06.02.2025 HSB-23324: Consider roof openings , Author: Marsel Nakuci
// 3.14 06.02.2025 HSB-23324: Consider openings that are created after merging icon and opposite planeprofiles , Author: Marsel Nakuci
// 3.13 24.01.2025 hsbMF-4779: Fix function that applies offset , Author: Marsel Nakuci
// 3.12 07.01.2025 HSB-22315: When Insulation Sheets are created the tsl Instance will not be considered for weight calculation Author: Marsel Nakuci
// 3.11 05.12.2024 HSB-23048: In elevation apply tolerance only on left and right; Dont apply tolerance on top and bottom Author: Marsel Nakuci
// 3.10 03/09/2024 HSB-22516: Add property "R-value" (ability to reduce rate of heat flow); value will be written in grade of insulation sheet Marsel Nakuci
// 3.9 31.05.2024 HSB-21103: remove tolerance in thickness Author: Marsel Nakuci
// 3.8 22/05/2024 HSB-21991: reorganise code  Marsel Nakuci
// 3.7 29/04/2024 HSB-21103: Change property name "Strategy"-> "Thickness variable": Add description Marsel Nakuci
// 3.6 25.04.2024 HSB-21103: 20240425: For insulation with fix thickness, make sure the insulation remains inside the zone; should not be outside of the zone space Author: Marsel Nakuci
// 3.5 05.04.2024 HSB-21103: Fix display and sheet generation when tolerance is used Author: Marsel Nakuci
// 3.4 19/03/2024 HSB-21103: Add property "Gap" to apply gap around the insulation Marsel Nakuci
// 3.3 11/03/2024 HSB-21590: (For Baufritz:) Newly inserted TSL instance at same zone will replace existing Marsel Nakuci
// 3.2 26.09.2023 HSB-19615: For Baufritz consider zone 6 as contour for the insulation Author: Marsel Nakuci
// 3.1 05.07.2023 HSB-19440 new context commands to disable/enable invetory database and to export settings, created sheet materials will be modified on property change , Author Thorsten Huck
// 3.0 04.07.2023 HSB-19440 bugfix for elements being created by TSL with a negative reference  height , Author Thorsten Huck
// 2.28 30.06.2023 HSB-19139: remove remaining of convex hull from the insulaiton pp Author: Marsel Nakuci
// 2.27 20.06.2023 HSB-18860: Use the property color for sheet if color in xml <=-3 Author: Marsel Nakuci
// 2.26 07.06.2023 HSB-19077: Keep insulation group from element group separated for Baufritz Author: Marsel Nakuci
// 2.25 12.05.2023 HSB-18801: Enter wait state if no element beam found (beams without panhand state) Author: Marsel Nakuci
// 2.24 13.03.2023 HSB-18309: Make sure insulation sheeting doesnot collides with corner female walls connected to this wall Author: Marsel Nakuci
// 2.23 15.02.2023 HSB-17824: Regen after changing group visibility in console Author: Marsel Nakuci
// 2.22 14.12.2022 HSB-17354: If one side of the sheet zones - or + is open then it will be considered as eave area Author: Marsel Nakuci
// 2.21 14.12.2022 HSB-17354: read from _Map to turn off Insulation groups; remove insulation at eave areas (Traufe, Ortgänge) Author: Marsel Nakuci
// 2.20 18.10.2022 HSB-16841: improve insulation when beams dont create a closed contour Author: Marsel Nakuci
// 2.19 18.10.2022 HSB-16841: Support extra group assignment Author: Marsel Nakuci
// 2.18 16.09.2022 HSB-12334: fix when investigating possible insulation thicknesses Author: Marsel Nakuci
// 2.17 06.09.2022 HSB-16426: Improve voids from horizontal beams Author: Marsel Nakuci
// 2.16 05.09.2022 HSB-16426: fix when filling voids Author: Marsel Nakuci
// 2.15 02.09.2022 HSB-16061: shrink profile of insulation with 1mm to avoid tolerance errors when subtracting other beam bodies Author: Marsel Nakuci
// 2.14 10.06.2022 HSB-15703: show description instead of article number, additional xml parameters Author: Marsel Nakuci
// 2.13 27.05.2022 HSB-15541: Add property Strategy {<Default>,Rigid} to decide how the insulation will be cutted Author: Marsel Nakuci
// 2.12 09.03.2022 HSB-14868 material properties written to sheet entities, inventory groups can be specified in settings , Author Thorsten Huck
// Version 2.11 15.12.2021 HSB-14132: 10^9is written as 1e9 Author: Marsel Nakuci
// Version 2.10 02.12.2021 HSB-13327: support multiple layers, add painter filter for walls Author: Marsel Nakuci
// 2.9 10.11.2021 HSB-13713 loose contour detection improved , Author Thorsten Huck
// 2.8 29.07.2021 HSB-12741 model display not hidden anymore in Z and Y view of element , Author Thorsten Huck
// 2.7 30.06.2021 HSB-12469 bugfix insulation spanning into gable elements , Author Thorsten Huck
// 2.6 28.05.2021 HSB-12022 insulation detection enhanced for lath zones. , Author Thorsten Huck
// 2.5 07.05.2021 HSB-11781 insulation considers entities which are not fully spanning the zone thickness. 
// Redundant property purged.
// NOTE: It is recoomended to replcae existing instances with a new instance. When using the tsl as a construction plugin one should call the dialog once to update the properties , Author Thorsten Huck

/// <version value="2.4" date="20apr2021" author="nils.gregor@hsbcad.com"> HSB-11628 Bugfix error report.
/// <version value="2.3" date="12oct2020" author="nils.gregor@hsbcad.com"> HSB-HSB-8423 Bugfix merging PlaneProfile. Removed property to select different zone for contour.
/// <version value="2.2" date="30sep2020" author="nils.gregor@hsbcad.com"> HSB-HSB-8423 Tsl instance can be added once per zone, improvement of contour, add property to select different zone for contour, add property for assignement, hardware contains zone number in the notice.
/// <version value="2.1" date="12aug2020" author="thorsten.huck@hsbcad.com"> HSB-7005 plan view hatch fixed </version>
/// <version value="2.0" date="11aug2020" author="thorsten.huck@hsbcad.com"> HSB-7005 solid default display disabled, transparency working for all patterns </version>
/// <version value="1.9" date="14jul2020" author="thorsten.huck@hsbcad.com"> HSB-7005 new property to specify max height (walls only), new property to control transparency, HSB-8224 only items intersecting the zone considered for calculation, HSB-8223 Zone alignment fixed   </version>
/// <version value="1.8" date="12mai20" author="marsel.nakuci@hsbcad.com"> HSB-7520: bug: write volume in m3, prompt to select Floor contour for Dach/Decke Elementen, add display for _ZW viewdirection </version>
/// <version value="1.7" date="09apr20" author="marsel.nakuci@hsbcad.com"> HSB-7238: write volume in m3 </version>
/// <version value="1.6" date="09apr20" author="marsel.nakuci@hsbcad.com"> HSB-7238: read volumes from mapX </version>
/// <version value="1.5" date="12mar2020" author="marsel.nakuci@hsbcad.com"> HSB-6910: read information from element TSL, fix bug at openings, subtract openings for each plRing </version>
/// <version value="1.4" date="05mar2020" author="thorsten.huck@hsbcad.com"> material written to materialDescription property to enable COG calculation</version>
/// <version value="1.3" date="21dec2018" author="thorsten.huck@hsbcad.com"> supports hsb inventory, any  zone and distribution </version>
/// <version value="1.0" date="08mar2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// select properties or catalog entry and press OK, Select elements
/// </insert>

/// <summary Lang=en>
/// This tsl calculates and displays the insulation of an element based on the subtraction of the contour with the designated zone

// Commands
// commmand to create insulation
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbElementInsulation")) TSLCONTENT
// command to create individual instances per field
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Insulation in Place|") (_TM "|Select insulation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Area||") (_TM "|Select insulation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Subtract Area|") (_TM "|Select insulation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Inventory|") (_TM "|Select insulation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Erase Insulation Sheeting|") (_TM "|Select insulation|"))) TSLCONTENT
//endregion
	
//region constants 
	U(1,"mm");
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
// function declaration
	String strAssemblyPath=_kPathHsbInstall+"\\Utilities\\hsbLooseMaterials\\hsbLooseMaterialsUI.dll";
	String strType="hsbCad.LooseMaterials.UI.MapTransaction"; 
	String strFunction="GetItems";
	String sProject=projectSpecial();
	
	int bIsBaufritz=sProject.makeUpper()=="BAUFRITZ";
	String tMajorGroup = T("|Ancillary|");
	String tMinorGroup = T("|Insulation|");
//end constants//endregion

//region Functions

//region visPp
//
	void visPp(PlaneProfile _pp,Vector3d _vec)
	{ 
		_pp.transformBy(_vec);
		_pp.vis(6);
		_pp.transformBy(-_vec);
		return;
	}
//End visPp//endregion

//region applySideTolerance
// HSB-23048
	void applySideTolerance(PlaneProfile& _pp, 
		double _dTol, Vector3d _vec)
	{ 
		// _vec -> direction where the tolerance is applied
		// 
		Vector3d _vz=_pp.coordSys().vecZ();
		_vec=_vz.crossProduct(_vec.crossProduct(_vz));
		_vec.normalize();
		Vector3d _vx=_vec.crossProduct(_vz);
		
//	// get extents of profile
//		LineSeg _seg = _pp.extentInDir(_vec);
//		Point3d _ptL=_seg.ptStart();
//		Point3d _ptR=_seg.ptEnd();
//		
//		
//		PlaneProfile _ppSubL(_pp.coordSys());
//		PlaneProfile _ppSubR(_pp.coordSys());
//		
//		_ppSubL.createRectangle(LineSeg(_ptL-_vec*_dTol-_vx*U(10e6),
//			_ptL+_vec*_dTol+_vx*U(10e6)),_vec,_vx);
//		_ppSubR.createRectangle(LineSeg(_ptR-_vec*_dTol-_vx*U(10e6),
//			_ptR+_vec*_dTol+_vx*U(10e6)),_vec,_vx);
//			
//		_pp.subtractProfile(_ppSubL);
//		_pp.subtractProfile(_ppSubR);

		// move the mid points of the planeprofile
		Point3d _ptMids[]=_pp.getGripEdgeMidPoints();
		Point3d _pts[]=_pp.getGripVertexPoints();
		// hsbMF-4779
		if(_pts.length()==0)
		{ 
			return;
		}
		
		// if the normal of edge is most aligned with _vec
		// then it will be moved on the inside
		if(_pts.length()!=_ptMids.length())
		{ 
			// not expected, there should be the same nr of points
			return;
		}
		//
		Point3d _ptsThis[]=_pts;
		_pts.setLength(0);
		_pts.append(_ptsThis.last());
		_pts.append(_ptsThis);
		
//		_pts.insertAt(0,_pts.last());
//		_pts.append(_pts.first());
		
		for (int i=0;i<_ptMids.length();i++) 
		{ 
//			_ptMids[i].vis(1);
//			_pts[i].vis(2);
//			_pts[i+1].vis(3);
			Vector3d _vecDiri=_pts[i+1]-_pts[i];
			_vecDiri.normalize();
			Vector3d _vecNi=_vz.crossProduct(_vecDiri);
			_vecNi.normalize();
			
			if(abs(_vecNi.dotProduct(_vec))<abs(_vecDiri.dotProduct(_vec)))
			{ 
				// continue;
				continue;
			}
			// most aligned with the normal of edge
			// move it
			Vector3d _vMove=_vecNi;
			
			Point3d _ptTest=_ptMids[i]+_vMove*U(5);
			if(_pp.pointInProfile(_ptTest)==_kPointOutsideProfile)
			{ 
				_vMove*=-1;
			}
			
			_pp.moveGripEdgeMidPointAt(i,_vMove*_dTol);
		}//next i
		
		return;
	}
//End applySideTolerance//endregion
//End Functions//endregion 

//region Settings
	// in xml are given global parameters
	// insulation representation by a sheeting or not
	// for element TSL user must insert one tsl for each layer
	// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbElementInsulation";
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



//region Read inventory
// collect article map from inventory if inventory exists
	String sArticles[0];
	int nArticleIndices[0];
	
	String sInventoy = findFile(_kPathHsbCompany + "\\Inventory\\Inventory.db");
	String sMajorGroup = tMajorGroup;
	String sMinorGroup= tMinorGroup;
	int bReadDB=true;
	{ 
		String k;
		Map m;
		k = "Inventory"; 	if (mapSetting.hasMap(k) )m = mapSetting.getMap(k);
		k = "ReadDatabase";	if (m.hasInt(k))bReadDB = m.getInt(k);
		k = "MajorGroup"; 	if (m.hasString(k)&& m.getString(k)!="")sMajorGroup = m.getString(k);
		k = "MinorGroup"; 	if (m.hasString(k)&& m.getString(k)!="")sMinorGroup = m.getString(k);
	}
	Map mapItems=bReadDB? _Map.getMap("Item[]"):Map();
	
	if(sInventoy.length()>0 && findFile(strAssemblyPath)!="")
	{	
		if ((_bOnInsert || _bOnDebug || _bOnDbCreated) && bReadDB)
		{ 
			Map mapIn;
			mapIn.setString("MajorGroupName",sMajorGroup);
			mapIn.setString("MinorGroupName",sMinorGroup);
			Map mapOut=callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
			mapItems=mapOut.getMap("Item[]");
			_Map.setMap("Item[]", mapItems);
		}

		for (int i=0;i<mapItems.length();i++) 
		{ 
			Map m= mapItems.getMap(i);
//			String s = m.getString("InventoryNumber");
			String s = m.getString("Description");
			if (sArticles.find(s)<0)
			{
				sArticles.append(s);
				nArticleIndices.append(i);
			}	 
		}//next i
	}
//End Read inventory//endregion 
	
	String sPainterCollection = "hsbElementInsulation";
	String sAllowedPainterTypes[] = { "Element", "ElementWall", "ElementWallStickFrame","ElementRoof"};
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sPainterDefault = T("<|Disabled|>");
	sPainters.insertAt(0, sPainterDefault);
	for (int i=sPainters.length()-1; i>=0 ; i--) 
	{ 
		String sPainter = sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0 || sPainter.find(sPainterDefault,0,false)>-1)
		{ 
			sPainters.removeAt(i);
			continue;
		}
		PainterDefinition pd(sPainter);
		if (sAllowedPainterTypes.findNoCase(pd.type())<0)
		{ 
			sPainters.removeAt(i);
			continue;
		}
	}//next i
	sPainters = sPainters.sorted();
	
	String sPainterStreamName=T("|Painter Definition|");
	PropString sPainterStream(6, "", sPainterStreamName);
	sPainterStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sPainterStream.setCategory(category);
	sPainterStream.setReadOnly(bDebug?0:_kHidden);
	// on insert, elementConstructed or dbCreated
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{ 
	// collect streams	
		String streams[0];
		String sScriptOpmName = bDebug?"hsbElementInsulation":scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		int iStreamIndices[] ={1};
		for (int i=0;i<entries.length();i++) 
		{ 
			String& entry = entries[i]; 
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j=0;j<mapProp.length();j++) 
			{ 
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if(iStreamIndices.find(index)>-1 && streams.findNoCase(stream,-1)<0)
				{ 
					streams.append(stream);
				}
			}//next j 
		}//next i
		
	// process streams
		for (int i=0;i<streams.length();i++) 
		{ 	
			String& stream = streams[i];
			String _painters[0];
			_painters = sPainters;
			if (stream.length()>0)
			{ 
			// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				
			// create definition if not present	
				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
					_painters.findNoCase(name,-1)<0)
				{ 
					PainterDefinition pd(name);
					if(!pd.bIsValid())
					{ 
						pd.dbCreate();
						pd.setType(type);
						pd.setFilter(filter);
						pd.setFormat(format);
						
						if (pd.bIsValid())
						{ 
							sPainters.append(name);
						}
					}
				}
			}
		}
	}
	
//region Properties
	category = T("|Insulation|");
	String sArticleName=T("|Article|");	
	PropString sArticle(nStringIndex++, "", sArticleName);
	sArticle.setCategory(category);
	int nArticle = -1;
	if (sArticles.length()>0)
	{ 
		sArticle = PropString(0, sArticles, sArticleName);	
		nArticle = sArticles.find(sArticle);
		if (nArticle<0)
		{ 
			nArticle = 0;
			sArticle.set(sArticles[nArticle]);
		}
		//sArticle.setDescription(T("|Defines the Article|"));
	}
//	else 
	sArticle.setDescription(T("|Defines the Article|") + 
		TN("|This tool supports articles of the hsbInventory.|") + 
		TN("|Articles need to be defined within the mayor group| '") +tMajorGroup +"'." + T(" |The minor group must be named| '") + tMinorGroup+ "'");
	
	String sMaterialName=T("|Material|");	
	PropString sMaterial(nStringIndex++, "", sMaterialName);
	sMaterial.setDescription(T("|Defines the Material|"));
	sMaterial.setCategory(category);
	
	if (!bReadDB && _kNameLastChangedProp==sMaterialName && _Map.hasMap("Item[]"))
	{ 
		_Map.removeAt("Item[]", true);
		setExecutionLoops(2);
		return;
	}
	
	String sManufacturerName=T("|Manufacturer|");
	PropString sManufacturer(nStringIndex++, "", sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	
	String sThicknessName=T("|Thickness|");	
	PropDouble dThickness(nDoubleIndex++, U(0), sThicknessName);
	dThickness.setDescription(T("|Defines the thickness of the insulation|") + T(", |0 = by zone 0|"));
	dThickness.setCategory(category);
	
	String sHeightName=T("|Height|");
	PropDouble dHeight(3, U(0), sHeightName);
	dHeight.setDescription(T("|Defines the max. height of the insulation seen from the wall floor outline|") + T(", |0 = complete Height|") + T("|Not applicable for roof or floor elements.|"));
	dHeight.setCategory(category);
	
// set to read only and set values if artticle of inventory has been found
	Map mapItem;
	if (nArticle>-1)
	{ 
		mapItem = mapItems.getMap(nArticleIndices[nArticle]);
		String _sMaterial = mapItem.getString("Material");
		String _sManufacturer = mapItem.getString("SupplierNumber");
		double _dThickness = mapItem.getDouble("Height");
		
		if (_sMaterial!="")
		{ 
			sMaterial.setReadOnly(true);
			if (sMaterial != _sMaterial)
				sMaterial.set(_sMaterial);
		}
		else if (_kNameLastChangedProp==sArticleName)
			sMaterial.set(_sMaterial);
		
		if (_sManufacturer!="")
		{ 
			sManufacturer.setReadOnly(true);
			if (sManufacturer != _sManufacturer)
				sManufacturer.set(_sManufacturer);
		}
		else if (_kNameLastChangedProp==_sManufacturer)
			sManufacturer.set(_sManufacturer);
		
		if (_dThickness>0)
		{ 
			dThickness.setReadOnly(true);
			if (dThickness != _dThickness)
				dThickness.set(_dThickness);
		}	
		else if (_kNameLastChangedProp==sArticleName)
			dThickness.set(0);
			
		if (_kNameLastChangedProp==sArticleName)
		{ 
			setExecutionLoops(2);
		}
	}
	
	category = T("|General|");
	
	String sZoneName=T("|Zone|");
	int nZones[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
	// purge non existant zones
	if (_Element.length()>0)
	{ 
		Element el = _Element[0];
		for (int i=nZones.length()-1; i>=0 ; i--) 
			if (el.zone(nZones[i]).dH()<dEps)
				nZones.removeAt(i);	
		if (nZones.length() < 1){reportMessage("\n" + scriptName() + ": " + T("|Unexpected error no zone.|"));eraseInstance();return;}
	}
	PropInt nZone(nIntIndex++, nZones, sZoneName,5);	
	nZone.setDescription(T("|Defines the Zone|"));
	nZone.setCategory(category);
	
	// auto correct zone to the next existing
	if (nZones.find(nZone) < 0)
	{ 
		int nSgn = nZone / abs(nZone);
		int n = nSgn < 0 ? nZones[0] : nZones[nZones.length() - 1];
		nZone.set(n);
	}
	
	String sAlignments[] = { T("|disabled|"),T("|horizontal|"),T("|vertical|") };
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the distribution alignment|"));
	sAlignment.setCategory(category);
	int nAlignment = sAlignments.find(sAlignment, 0);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 41, sColorName);
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	String sTransparencyName=T("|Transparency|");
	PropInt nTransparency(2, 0, sTransparencyName);	
	nTransparency.setDescription(T("|Defines the transparency of a solid filling in plan and element view.|") + T(" |Value must be >0 and <100|"));
	nTransparency.setCategory(category);
	
	String sPatterns[0];
	sPatterns = _HatchPatterns.sorted();
	sPatterns.insertAt(0, T("|disabled|"));
	
	category = T("|Element View|");
	String sHatchElementName=T("|Pattern|");	
	PropString sHatchElement(nStringIndex++, sPatterns, sHatchElementName);	
	sHatchElement.setDescription(T("|Defines the HatchElement|"));
	sHatchElement.setCategory(category);
	
	String sScaleElementName=T("|Pattern Scale|");
	PropDouble dScaleElement(nDoubleIndex++, 1, sScaleElementName);
	dScaleElement.setDescription(T("|Defines the scale factor of the hatch pattern|"));
	dScaleElement.setCategory(category);
	
	category = T("|Plan View|");
	String sHatchPlanName=T("|Pattern| ");
	PropString sHatchPlan(nStringIndex++, sPatterns, sHatchPlanName);
	sHatchPlan.setDescription(T("|Defines the HatchPlan|"));
	sHatchPlan.setCategory(category);
	
	String sScalePlanName=T("|Pattern Scale| ");
	PropDouble dScalePlan(nDoubleIndex++, 1, sScalePlanName);
	dScalePlan.setDescription(T("|Defines the scale factor of the hatch pattern|"));
	dScalePlan.setCategory(category);
	
	category = T("|Painter|");
	String sReferences[0];
	for (int i=0;i<sPainters.length();i++) 
	{ 
		String entry = sPainters[i];
		entry = entry.right(entry.length() - sPainterCollection.length()-1);
		if (sReferences.findNoCase(entry,-1)<0)
			sReferences.append(entry);
	}//next i
	sReferences.insertAt(0, sPainterDefault);
	// 
	String sPainterWallName=T("|Walls|");
	PropString sPainterWall(7, sReferences, sPainterWallName);
	sPainterWall.setDescription(T("|Defines the Painter filter for Beams that are excluded.|"));
	sPainterWall.setCategory(category);
	
	// HSB-15541
	// rigid means the insulation will be cut if colliding with existing blocks or other small pieces of beams
	// insulation will stop there, will not fit into small spaces
//	String sStrategyName=T("|Strategy|");
	String sStrategyName=T("|Thickness Variable|");
	String sStrategys[]={T("<|Default|>"),T("|Rigid|") };
	PropString sStrategy(8, sStrategys, sStrategyName);
	sStrategy.setDescription(T("|The default variable permits insulation to be positioned across the entire zone, even in regions with limitations like flat studs, which decrease the zone thickness below the insulation stock thickness. The rigid variable places insulation solely where there is sufficient width for the insulation stock thickness, leaving gaps if obstacles like flat studs reduce the available space at or below that of the insulation stock thickness.|"));
	sStrategy.setCategory(T("|Insulation|"));
	
	category=T("|Instance|");
	String sDeleteInstanceName=T("|Delete Instance|");
	PropString sDeleteInstance(9, sNoYes, sDeleteInstanceName);
	sDeleteInstance.setDescription(T("|Delete instance after insertion or not|"));
	sDeleteInstance.setCategory(category);
	
	category = T("|Insulation|");
	String sToleranceName=T("|Tolerance|");	
	PropString sTolerance(10, "0", sToleranceName);	
	sTolerance.setDescription(T("|Applies a gap around the insulation. The gap will only be aplied on vertical edges in element view.|"));
	sTolerance.setCategory(category);
	
	//HSB - 22516 : R - value is a kind of thermal coefficien; rate of heat dT/heat flux
	String sRvalueName=T("|R-Value|");	
	PropString sRvalue(11, "", sRvalueName);	
	sRvalue.setDescription(T("|Defines the R-value of the insulation. This value will be written at the property grade of sheet, when insulation sheets get created.|"));
	sRvalue.setCategory(category);
//End Properties//endregion 
	
	
//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);
			showDialog();
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}
	}
//End mapIO: support property dialog input via map on element creation//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return;}
		
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
		{
			setPropValuesFromCatalog(sLastInserted);
			if (sArticles.length()>0)
			{ 
				String sByArticle = T("|byArticle|");
				sMaterial.set(sByArticle);
				sManufacturer.set(sByArticle);
				dThickness.set(0);
				
				sMaterial.setReadOnly(true);
				sManufacturer.setReadOnly(true);
				dThickness.setReadOnly(true);
			}
			showDialog("---");
		}
		
	// prompt for elements
		PrEntity ssE(T("|Select element(s)|"), Element());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
	// prompt selection of outter contour polylines
		PrEntity ssEpl(T("|Select polyline(s) that define the outter contour|"), EntPLine());
		Entity entPlines[0];
	  	if (ssEpl.go())
			entPlines.append(ssEpl.set());
		Map m;
		m.setInt("Mode", _kAdd);
		m.setString("Type", "FloorContour");
		for (int i=0;i<entPlines.length();i++) 
		{ 
			entPlines[i].setSubMapX(scriptName(), m);
			_Entity.append(entPlines[i]); 
		}//next i
		
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE; Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {}; Entity entsTsl[0];
		Point3d ptsTsl[1];
		int nProps[]={nZone,nColor,nTransparency}; 
		double dProps[]={dThickness,dScaleElement,dScalePlan, dHeight};		
		String sProps[]={sArticle,sMaterial,sManufacturer,sAlignment,sHatchElement,sHatchPlan, 
			sPainterStream, sPainterWall,sStrategy,sDeleteInstance,sTolerance,sRvalue};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		// filter elements by painter
		PainterDefinition pdWall;
		if(sPainterWall!=sPainterDefault)
		{ 
			pdWall = PainterDefinition (sPainterCollection + "\\" + sPainterWall);
			if(pdWall.bIsValid())
			{ 
				_Element = pdWall.filterAcceptedEntities(_Element);
			}
		}
	// insert per element
		for(int i=0;i<_Element.length();i++)
		{
			entsTsl.setLength(0);
			entsTsl.append(_Element[i]);
			for (int ii=0;ii<entPlines.length();ii++) 
			{ 
				entsTsl.append(entPlines[ii]);
			}//next ii
			
			ptsTsl[0]=_Element[i].ptOrg();
			tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
			
			if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
		}
		
		eraseInstance();
		return;
	}
//End bOnInsert//endregion 
	
	if(sReferences.find(sPainterWall)<0)
		sPainterWall.set(sReferences[0]);
	
	int iStrategy=sStrategys.find(sStrategy);
	PainterDefinition pdWall;
	if(sPainterWall!=sPainterDefault)
	{ 
		pdWall = PainterDefinition (sPainterCollection + "\\" + sPainterWall);
		if(pdWall.bIsValid())
		{ 
			_Element = pdWall.filterAcceptedEntities(_Element);
		}
	}
	if (pdWall.bIsValid())
	{ 
		Map m;
		m.setString("Name", pdWall.name());
		m.setString("Type",pdWall.type());
		m.setString("Filter",pdWall.filter());
		m.setString("Format",pdWall.format());
		sPainterStream.set(m.getDxContent(true));
	}
	_ThisInst.setCatalogFromPropValues(sLastInserted);
//region validate and declare element variables
	if (_Element.length()<1)
	{
		reportMessage("\n"+scriptName()+" "+T("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
	Element el=_Element[0];
	CoordSys cs=el.coordSys();
	Vector3d vecX=cs.vecX();
	Vector3d vecY=cs.vecY();
	Vector3d vecZ=cs.vecZ();
	Point3d ptOrg=cs.ptOrg();

	// HSB-23868: Add filter for Baufritz
	if(bIsBaufritz && nZone == 0 && sMaterial=="Hobelspäne")
	{ 
		if(el.code()=="M" || el.code()=="N" || el.code()=="O" || el.code()=="P" || el.code()=="H" || el.code()=="I")
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Element |" )+ el.number()+" "+T("|is not insulated|"));
			eraseInstance();
			return;
		}
	}
	
	if(bIsBaufritz && sMaterial=="Holzweichfaser Zone 2")
	{ 
		if(el.code()=="F" || el.code()=="G" ||el.code()=="J" || el.code()=="K" || el.code()=="L" || el.code()=="M" || 
		el.code()=="N" || el.code()=="O" || el.code()=="P" || el.code()=="H" || el.code()=="I")
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Element |" )+ el.number()+" "+T("|is not insulated in Zone 2|"));
			eraseInstance();
			return;
		}
	}

	 // HSB-19440 zone placement wrong when elements created by hsbCreateELement
	double dReferenceHeight;
	ElementRoof elRoof = (ElementRoof)el;
	if (elRoof.bIsValid())
		dReferenceHeight = elRoof.dReferenceHeight();
	
	double dTol,dTolThickness;
	if(sTolerance!="" && sTolerance!="0")
	{ 
		dTol=sTolerance.atof();
	}
	
	int bEditInPlace=_Map.getInt("directEdit");
//	_Pt0.vis(3);
// check if already attached
//	if (_bOnDbCreated && !bEditInPlace)
//	{ 
//		TslInst tsls[] = el.tslInstAttached();
//		for (int i=0;i<tsls.length();i++) 
//		{ 
//			TslInst& tsl= tsls[i]; 
//			if (tsl.bIsValid() && tsl.scriptName() == scriptName() && tsl!=_ThisInst)
//			{ 
//				if(tsl.propInt(sZoneName) == nZone)
//				{
//					reportMessage("\n" + scriptName() + ": " +T("|is already attached to the element| ") + el.number());
//					eraseInstance();
//					return;					
//				}
//			}
//		}
//		// HSB-13327: collect all TSLs of same zone
//	}
	
//pattern is matched by wall codes; there can be different patterns for different wall codes
//region get mapPattern for the wall
//	String sCode = el.code();
	sDeleteInstance.setReadOnly(_kHidden);
	int bDeleteInstance=sNoYes.find(sDeleteInstance);
	Map mapPattern;int iMapPatternFound;
	Map mapPatternDefault; int iMapPatternDefaultFound;
	Map mapGroup=mapSetting.getMap("Group");
	String sObjectName=mapGroup.getString("ObjectName");
	Map mapPatterns = mapSetting.getMap("Pattern[]");
	for (int i=0;i<mapPatterns.length();i++)
	{ 
		Map mapI = mapPatterns.getMap(i);
		String sCode= mapI.getMap("Wall").getString("Code");
		String sCodes[] = sCode.tokenize(";");
		if(sCodes.find(el.code())>-1)
		{ 
			// pattern found
			mapPattern = mapI;
			iMapPatternFound = true;
			break;
		}
	}//next i
	for (int i=0;i<mapPatterns.length();i++)
	{ 
		Map mapI = mapPatterns.getMap(i);
		String sCode= mapI.getMap("Wall").getString("Code");
		String sCodes[] = sCode.tokenize(";");
		if(sCodes.find("*")>-1)
		{ 
			// pattern found
			mapPatternDefault = mapI;
			iMapPatternDefaultFound = true;
			break;
		}
	}//next i
	// use the default map if map not found
	if(!iMapPatternFound && iMapPatternDefaultFound)
	{ 
		mapPattern = mapPatternDefault;
	}
//End get mapPattern for the wall//endregion 
	if(!bIsBaufritz)
		assignToElementGroup(el,true, nZone,'I');// assign to element info sublayer	
// HSB-16841:
	if(sObjectName!="")
	{ 
		Group grpsEl[]=el.groups();
		String sLevel="Level";
//		String sLevelBaufritz;
		if(grpsEl[0].namePart(1)!="")
		{ 
			sLevel=grpsEl[0].namePart(1);
//			sLevelBaufritz=sLevel;
			// HSB-19077
			if(bIsBaufritz)
				sLevel=grpsEl[0].namePart(1)+"_ins";
		}
		String sGrpName=sObjectName+"\\"+sLevel;
		Group grpInsulation(sGrpName);
		if(!grpInsulation.bExists())
		{ 
			grpInsulation.dbCreate();
		}
		
		if(!bIsBaufritz)
		{
			grpInsulation.addEntity(_ThisInst, false);
		}
		else if(bIsBaufritz)
		{
		// HSB-19077
			grpInsulation.addEntity(_ThisInst, true);
			// HSB-21991
			// delete previous groups named after sLevelBaufritz from previous version of tsl
//			String sGrpName=sObjectName+"\\"+sLevelBaufritz;
//			Group grpInsulation(sGrpName);
//			if(grpInsulation.bExists())
//				grpInsulation.dbErase();
		}
		if(_bOnDbCreated)
		{ 
			if(_Map.getInt("InsulationGroupVisibilityOff"))
			{ 
			// HSB-17354:
				if(grpInsulation.groupVisibility(true)!=_kIsOff)
				{
					grpInsulation.turnGroupVisibilityOff(true);
					pushCommandOnCommandStack("Regen");
				}
			}
		}
	}
	setDependencyOnEntity(el);
	_ThisInst.setMaterialDescription(sMaterial);
	_ThisInst.setDrawOrderToFront(false);
	
	// control transparency	
	if (_kNameLastChangedProp==sTransparencyName || _bOnDbCreated)
	{ 
		if (nTransparency>0 && nTransparency<100)
			_ThisInst.setTransparency(nTransparency);
		else if (_ThisInst.transparency()!=0)
			_ThisInst.setTransparency(0);		
	}
	else if (_ThisInst.transparency()!=nTransparency)
		nTransparency.set(_ThisInst.transparency());
	double dZ =el.dBeamWidth();
	Plane pnZ(ptOrg,vecZ);
	PLine plEnvelope=el.plEnvelope();
	LineSeg segMinMax=el.segmentMinMax();
	double dX=abs(vecX.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
	double dY=abs(vecY.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
	Point3d ptRef=ptOrg;
	if (bEditInPlace)
		ptRef=_Pt0;
	Vector3d vecZT=-vecZ;
	
// specify thicknesses
	int bIsLathZone; String sLathDistributions[] = { "Horizontal Lath", "Vertical Lath"};
	if (abs(nZone)>0)
	{ 
		ElemZone elzo=el.zone(nZone);
		bIsLathZone=sLathDistributions.findNoCase(elzo.distribution(),-1)>-1;
		ptRef=elzo.ptOrg();
		if (bEditInPlace)
			ptRef=_Pt0;
		dZ=elzo.dH();
		vecZT=elzo.vecZ();

	// HSB-19440 consider referenceheight
		if (dReferenceHeight<0)
			ptRef -= vecZ * dReferenceHeight;

		pnZ = Plane(ptRef, vecZT);ptRef.vis(2);
		plEnvelope = el.plEnvelope(ptRef);		//plEnvelope.vis(2);
		cs=CoordSys(ptRef,vecY.crossProduct(elzo.vecZ()),vecY,vecZT);
	}
	else
	{ 
//		ptRef += vecZT * dPosition;
//		cs.transformBy(cs.vecZ() * cs.vecZ().dotProduct(ptRef - cs.ptOrg()));
	}
	if(bEditInPlace)
	{ 
		cs.transformBy(cs.vecX()*cs.vecX().dotProduct(ptRef-cs.ptOrg()));
		cs.transformBy(cs.vecY()*cs.vecY().dotProduct(ptRef-cs.ptOrg()));
	}
	
	double dInsulationThickness=dThickness>0?dThickness:dZ;
	double dDisplayThickness=dInsulationThickness>dZ?dZ:dInsulationThickness;
	
	// store to _Map to have it accesible for other TSLs
	_Map.setDouble("InsulationThickness", dInsulationThickness);
	
	// collect all TSLs and sort them, existing TSLs have priority towards the newly entered
	// to avoid redundancy only the first TSL will do the sorting
	// each TSL has dependency to the first TSL
	if(_bOnDbCreated && !bEditInPlace)
	{ 
		// on creation but not edit in place
		// keep only existing TSLs
		TslInst tslsExisting[] = el.tslInstAttached();
		for (int i=tslsExisting.length()-1; i>=0 ; i--) 
		{ 
			TslInst& tsl= tslsExisting[i]; 
			if (!tsl.bIsValid() || tsl.scriptName() != scriptName() 
				|| tsl==_ThisInst || tsl.propInt(sZoneName) != nZone)
			{ 
				tslsExisting.removeAt(i);
			}
		}
		int iPositionsExisting[0];
		double dPosition;
		for (int i=0;i<tslsExisting.length();i++) 
		{ 
			int iPositionI=tslsExisting[i].map().getInt("iPosition");
			if(tslsExisting[i].map().hasDouble("InsulationThickness"))
			{ 
				if(iPositionsExisting.find(iPositionI)<0)
				{
					dPosition+= tslsExisting[i].map().getDouble("InsulationThickness");
					iPositionsExisting.append(iPositionI);
				}
			}
		}//next i
		_Map.setInt("iPosition",tslsExisting.length());
		_Map.setDouble("dPosition",dPosition);
		Point3d ptRef0=ptRef+vecZT*dPosition;
		_Pt0.transformBy(vecZ*vecZ.dotProduct(ptRef0-_Pt0));
		_Map.setPoint3d("Pt0Absolute",_Pt0,_kAbsolute);
	}
	int iPosition;
	double dPosition;
	if(_Map.hasInt("iPosition") && !bEditInPlace)
	{ 
		iPosition=_Map.getInt("iPosition");
		// 
		TslInst tslsExisting[]=el.tslInstAttached();
		for (int i=tslsExisting.length()-1;i>=0;i--) 
		{ 
			TslInst& tsl= tslsExisting[i]; 
			if (!tsl.bIsValid() || tsl.scriptName() != scriptName() 
				|| tsl==_ThisInst || tsl.propInt(sZoneName) != nZone)
			{ 
				tslsExisting.removeAt(i);
			}
		}
		int iPositionsSmaller[0];
		for (int i=0;i<iPosition;i++) 
		{ 
			iPositionsSmaller.append(i);
		}//next i
		
		for (int i=0;i<tslsExisting.length();i++) 
		{ 
			if(tslsExisting[i].map().hasDouble("InsulationThickness")
			&& tslsExisting[i].map().hasInt("iPosition"))
			{ 
				int iPositionI=tslsExisting[i].map().getInt("iPosition");
				if(iPositionI<iPosition)
				{
					if(iPositionsSmaller.find(iPositionI)>-1)
					{
						dPosition+=tslsExisting[i].map().getDouble("InsulationThickness");
						iPositionsSmaller.removeAt(iPositionsSmaller.find(iPositionI));
					}
				}
			}
		}//next i
	}
	
	int iMoved;
	Point3d pt0Absolute=_Map.getPoint3d("Pt0Absolute");
	if(abs(vecZT.dotProduct(_Pt0-pt0Absolute))>dEps)
		iMoved=true;
	
	int iPositionMax;
	if(!bEditInPlace)
	{ 
		// get all insulation TSLs	
		TslInst tslsAll[]=el.tslInstAttached();
		for (int i=tslsAll.length()-1; i>=0 ; i--) 
		{ 
			TslInst& tsl=tslsAll[i]; 
			if (!tsl.bIsValid() || tsl.scriptName() != scriptName() 
				|| tsl.propInt(sZoneName) != nZone)
			{ 
				tslsAll.removeAt(i);
			}
			else
			{ 
				if(tsl.map().hasInt("iPosition"))
				{ 
					int iPositionI=tsl.map().getInt("iPosition");
					if(iPositionI>iPositionMax)
						iPositionMax=iPositionI;
				}
			}
		}
		
		for (int i=0;i<tslsAll.length();i++) 
		{ 
			if( tslsAll[i]!=_ThisInst)
			{ 
				if(_Entity.find(tslsAll[i])<0)
				{ 
					_Entity.append(tslsAll[i]);
				}	
				setDependencyOnEntity(tslsAll[i]);
			}
		}//next i
		
		if(iPositionMax+1>tslsAll.length())
		{ 
			// deleted tsl, resort tsls
		// order alphabetically
			for (int i=0;i<tslsAll.length();i++) 
				for (int j=0;j<tslsAll.length()-1;j++) 
					if (tslsAll[j].map().getInt("iPosition") >
							tslsAll[j+1].map().getInt("iPosition"))
						tslsAll.swap(j,j+1);
			for (int i=0;i<tslsAll.length();i++) 
			{ 
				Map mapI=tslsAll[i].map();
				mapI.setInt("iPosition",i);
				tslsAll[i].setMap(mapI);
				tslsAll[i].recalcNow();
			}//next i
			
			int iIndexThis=tslsAll.find(_ThisInst);
			if(iIndexThis>-1)
			{ 
				_Map.setInt("iPosition",iIndexThis);
			}
			dPosition=0;
			for (int i=0;i<tslsAll.length();i++) 
			{ 
				if(tslsAll[i].map().hasDouble("InsulationThickness")
				&& tslsAll[i].map().hasInt("iPosition"))
				{ 
					int iPositionI=tslsAll[i].map().getInt("iPosition");
					if(iPositionI<iIndexThis)
						dPosition+=tslsAll[i].map().getDouble("InsulationThickness");
				}
			}//next i
		}
	
	// calculate when moved
		if((_kNameLastChangedProp=="_Pt0" || iMoved) && !bEditInPlace)
		{ 
			// recalc iPositions for all TSLs
			
			// sort according to pt0 in direction of vecZt
		// order alphabetically
			for (int i=0;i<tslsAll.length();i++) 
				for (int j=0;j<tslsAll.length()-1;j++) 
					if (vecZT.dotProduct(tslsAll[j].ptOrg()-tslsAll[j+1].ptOrg())>0)
						tslsAll.swap(j,j+1);
			
			for (int i=0;i<tslsAll.length();i++) 
			{ 
				Map mapI=tslsAll[i].map();
				mapI.setInt("iPosition",i);
				tslsAll[i].setMap(mapI);
				tslsAll[i].recalcNow();
			}//next i
			
			
			int iIndexThis=tslsAll.find(_ThisInst);
			if(iIndexThis>-1)
			{ 
				_Map.setInt("iPosition",iIndexThis);
			}
			dPosition=0;
			for (int i=0;i<tslsAll.length();i++) 
			{ 
				if(tslsAll[i].map().hasDouble("InsulationThickness")
				&& tslsAll[i].map().hasInt("iPosition"))
				{ 
					int iPositionI=tslsAll[i].map().getInt("iPosition");
					if(iPositionI<iIndexThis)
						dPosition+=tslsAll[i].map().getDouble("InsulationThickness");
				}
			}//next i
	//		setExecutionLoops(2);
	//		return;
		}
	}
	// dPosition calculated, update ptRef and cs
	if(!bEditInPlace)
	{ 
		ptRef+=vecZT*dPosition;
		cs.transformBy(cs.vecZ()*cs.vecZ().dotProduct(ptRef-cs.ptOrg()));
	}
	
//region some insulation parameters
	// by default create sheet
	int bCreateSheet=true;
	bCreateSheet=mapPattern.getInt("CreateSheet");
	// HSB-15703: by default assigning zone same as geometric zone
	int nZoneAssignment=nZone;
	if(mapPattern.hasMap("ZoneMapping[]"))
	{ 
		Map mapZoneMappings=mapPattern.getMap("ZoneMapping[]");
		for (int im=0;im<mapZoneMappings.length();im++) 
		{ 
			Map mapI=mapZoneMappings.getMap(im);
			if(mapI.hasInt("GeometricZone") && mapI.hasInt("AssigningZone"))
			{ 
				if(mapI.getInt("GeometricZone")==nZone)
				{ 
					nZoneAssignment=mapI.getInt("AssigningZone");
				}
			}
		}//next im
		if(nZoneAssignment>5 && nZoneAssignment<11)
		{ 
			nZoneAssignment=5-nZoneAssignment;
		}
	}
	int nSheetColor=-3;
	// HSB-18860
	if(nColor>-3)
		nSheetColor=nColor;
	if(mapPattern.hasInt("SheetColor"))
	{ 
		// HSB-15703
		// HSB-18860
		if(mapPattern.getInt("SheetColor")>-3)
			nSheetColor=mapPattern.getInt("SheetColor");
	}
	if(!bDeleteInstance)
	if(bCreateSheet && (_kNameLastChangedProp=="_Pt0" || iMoved))
	{ 
		// update position sheeting
		for (int i=0;i<200;i++) 
		{ 
			String sKey="entSheet"+i;
			if(_Map.hasEntity(sKey))
			{ 
				Entity entI=_Map.getEntity(sKey);
				Sheet shI=(Sheet)entI;
				if(shI.bIsValid())
				{ 
					shI.transformBy(vecZT*vecZT.dotProduct(cs.ptOrg()+.5*vecZT*shI.dD(vecZT) - shI.coordSys().ptOrg()));
				}
//				entI.dbErase();
//				_Map.removeAt(sKey, true);
			}
		}//next i
	}
	// HSB-15703 get all available thicknesses sorted from max->min and corresponding indices
	double dThicknesses[0];
	int iThicknessIndices[0];
	for (int i=0;i<mapItems.length();i++) 
	{ 
		Map m= mapItems.getMap(i);
		if (m.getDouble("Height") <=dEps)continue;
		dThicknesses.append(m.getDouble("Height"));
		iThicknessIndices.append(i);
	}//next i
	// order from largest to smallest
		for (int i=0;i<dThicknesses.length();i++) 
			for (int j=0;j<dThicknesses.length()-1;j++) 
				if (dThicknesses[j]<dThicknesses[j+1])
				{
					dThicknesses.swap(j, j + 1);
					iThicknessIndices.swap(j, j + 1);
				}
	
//End some insulation parameters//endregion 
	Plane pnZ2(ptRef + vecZT * dZ, vecZT);pnZ2.vis(6);
	CoordSys cs2(ptRef + vecZT * dZ, vecX, vecY, vecZ);
	
	// pt0 ony fixed for non edit in place, for edit in place freely modifiable
	if(!bEditInPlace)
	{
		_Pt0.transformBy(vecZ*vecZ.dotProduct(ptRef-_Pt0));
	}
	_Map.setPoint3d("Pt0Absolute", _Pt0, _kAbsolute);
//End Element//endregion 
	
// make sure the articlenumber contains a value
	String sArticleNumber = sArticle.length() > 0 ? sArticle : T("|Insulation|");
// Display
	Display dpModel(nColor), dpElement(nColor), dpPlan(nColor), dpWorldZ(nColor);
	dpModel.textHeight(U(80));
	
	dpElement.addViewDirection(vecZ);
	dpElement.addViewDirection(-vecZ);
	
	dpPlan.addViewDirection(vecY);
	dpPlan.addViewDirection(-vecY);
	
//	dpModel.addHideDirection(vecZ);	// HSB-12741
//	dpModel.addHideDirection(-vecZ);
//	dpModel.addHideDirection(-vecY);
	
	// from top
	dpWorldZ.addViewDirection(_ZW);
	dpWorldZ.addViewDirection(-_ZW);
	
	int nPatternElement = sPatterns.find(sHatchElement,0);
	int nPatternPlan = sPatterns.find(sHatchPlan,0);
	
	if (dScaleElement < dEps)dScaleElement.set(U(1));
	if (dScalePlan < dEps)dScalePlan.set(U(1));	
	Hatch hatchElement(sHatchElement, dScaleElement);
	Hatch hatchPlan(sHatchPlan, dScalePlan);
	
// 	prepared to show section line
//	Display dpInfo(nColor);
//	dpInfo.textHeight(U(80));
//	dpInfo.elemZone(el, 0, 'T');



// get genbeams of element
	GenBeam gbs[] = el.genBeam();
	GenBeam genbeams[] = el.genBeam(nZone);
	int bZoneIsEmpty = gbs.length() > 0 && genbeams.length() < 1;
	
// get additional genbeams of adjacent elements
	ElementWall elw = (ElementWall)el;
	
// HSB-12469: this should be obsolete with changes from HSB-11781
//	Body bdZone;	
//	if (elw.bIsValid() && 0) 
//	{ 
//		Group gr(el.elementGroup().namePart(0));
//		
//	// get interscetion test body of zone
//		LineSeg seg(ptRef-vecX*U(1000), ptRef + vecX * (dX+U(1000)) + vecZT * dZ);
//		PLine plZone; plZone.createRectangle(seg, vecX, vecZ);
//
//		Body bdTest(plZone, vecY*dY, 1);
//		
//	// filter by zone intersection	HSB-8224
//		Point3d ptExtremes[0];
//		for (int i=genbeams.length()-1; i>=0 ; i--) 
//		{ 
//			Body bd = genbeams[i].envelopeBody();
//			if (!bd.hasIntersection(bdTest))
//			{
//				//genbeams[i].envelopeBody().vis(6);
//				genbeams.removeAt(i); 
//			}
//			else
//				ptExtremes.append(bd.extremeVertices(vecX));
//			
//		}//next i
//		ptExtremes = Line(_Pt0, vecX).orderPoints(ptExtremes, dEps);
//		
//	// collect elements of this group and find adjacent genbeams		
//		if (ptExtremes.length()>1)
//		{ 
//			double dX = vecX.dotProduct(ptExtremes.last() - ptExtremes.first());
//			Point3d _ptRef = ptExtremes.first();
//			_ptRef += vecZ * vecZ.dotProduct(ptRef - _ptRef)+vecY*vecY.dotProduct(ptRef-_ptRef);
//			seg=LineSeg(_ptRef-vecX*U(10), _ptRef + vecX * (dX+U(10)) + vecZT * dZ);
//			plZone.createRectangle(seg, vecX, vecZ);	
//			bdTest=Body (plZone, vecY*dY, 1);
//			bdTest.vis(151);
//			
//			Entity ents[]=gr.collectEntities(true, ElementWall(), _kModelSpace); 
//			for (int i=0;i<ents.length();i++) 
//			{ 
//				Element el2 = (Element)ents[i]; 
//				if (ents[i] == el || !el2.bIsValid())continue;
//				genbeams.append(bdTest.filterGenBeamsIntersect(el2.genBeam(nZone)));
//			}
//		}
//
//	// get zone body if this zone does not contain any beams
//		if (bZoneIsEmpty)
//		{ 
//			bdZone = Body(plEnvelope, vecZT * dZ);
//			//bdZone.vis(2);
//		}
//	}
	
// HSB-18801:make sure the element has genbeams that are not panhand
	GenBeam genbeamsNotPanhand[0];
	for (int ig=0;ig<genbeams.length();ig++) 
	{ 
		if(!genbeams[ig].panhand().bIsValid())
		{ 
			genbeamsNotPanhand.append(genbeams[ig]);
		}
	}//next ig
	
// wait state if no genbeams are found
	if (genbeams.length()<1 && genbeamsNotPanhand.length()<1)
	{ 
		dpModel.draw(scriptName(),segMinMax.ptMid(),vecX,vecY,0,0,_kDevice);
		return;
	}
	
// base contour
	PlaneProfile ppFrame(cs);
// HSB-18309: get connected elements, create ppConnected
	PlaneProfile ppConnected(cs);
	if(elw.bIsValid())
	{ 
		Element elConnections[]=elw.getConnectedElements();
	// consider only famale walls
		Element elFemales[0];
		Element el0=el;
		Plane pn0(el0.ptOrg(),el0.vecY());
		PLine plOutlineWall0=el0.plOutlineWall();
		plOutlineWall0.projectPointsToPlane(pn0,el0.vecY());
		Vector3d vecX0=el0.vecX();
		for (int icon=0;icon<elConnections.length();icon++) 
		{ 
			Element el1=elConnections[icon];
			Vector3d vecX1=el1.vecX();
			PLine plOutlineWall1=el1.plOutlineWall();
			plOutlineWall1.projectPointsToPlane(pn0,el0.vecY());
			int nOnThis=0,nOnOther=0;
			Point3d ptsOnThis[0],ptsOnOther[0];
			Point3d ptsThis[]=plOutlineWall0.vertexPoints(true);
			Point3d ptsOther[]=plOutlineWall1.vertexPoints(true);
			{ 
				for (int p=0;p<ptsOther.length();p++)
				{
					double d=(ptsOther[p]-plOutlineWall0.closestPointTo(ptsOther[p])).length();
					if (d<dEps)
					{
						ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
						nOnThis++;// count points of wall in el1 that are connected with wall in el0
					}
				}
				// points from this wall at other wall 
				for (int p=0;p<ptsThis.length();p++)
				{
					double d=(ptsThis[p]-plOutlineWall1.closestPointTo(ptsThis[p])).length();
					if (d<dEps)
					{
						ptsOnOther.append(ptsThis[p]);
						nOnOther++;
					}
				}
			}
			if((nOnThis==1 && nOnOther==2) || (nOnThis==2 && nOnOther==2))
			{ 
			// connected element is female element in the corner
				if(elFemales.find(el1)<0)
				{ 
					elFemales.append(el1);
				}
			}
		}//next icon
		for (int iel=0;iel<elFemales.length();iel++)
		{ 
			Element elI=elFemales[iel];
			Body bdI(elI.plOutlineWall(),elI.vecY()*U(5000));
			ppConnected.unionWith(bdI.shadowProfile(Plane(el0.ptOrg(),el0.vecZ())));
		}//next iel
	}
	
//region Get insulation profile

	//HSB-19440
	int bMonitorSheetMaterial = _kNameLastChangedProp == sMaterialName || _kNameLastChangedProp == sArticleName;

	PlaneProfile ppInsulation(cs);
	PLine plRings[0];
//HSB-11781 new approach of calculating the insualtion area
	// Strategy: get contact faces of both sides and calculate union
	// to collect door alike openings / finger shape profiles free directions of rings having no 'outer border'' are tested
	PlaneProfile ppIcon(cs), ppOpp(cs); ppOpp.transformBy(vecZT*dZ);
	Body bodies[genbeams.length()];
	for (int i=genbeams.length()-1; i>=0 ; i--) 
	{ 
		GenBeam& gb=genbeams[i];
		if (!gb.bIsValid() || gb.myZoneIndex()!=nZone || gb.bIsDummy())
		{
			genbeams.removeAt(i);
			bodies.removeAt(i);
			continue;
		}
		// dont consider sheets representing insulation
		Sheet shI = (Sheet)gb;
		if(shI.bIsValid())
		{ 
			if(shI.label()=="InsulationSheet")
			{ 
			// monitor sheet properties //HSB-19440
				if (bMonitorSheetMaterial && shI.material()!=sMaterial)
				{
					shI.setMaterial(sMaterial);
					shI.setInformation(sManufacturer);
				}

			// part of insulation sheets, remove it
				genbeams.removeAt(i);
				bodies.removeAt(i);
				continue;
			}
		}
		Body bd=gb.envelopeBody(false,true); bd.vis(252);
		bodies[i]=bd;
		
		PlaneProfile ppA=bd.getSlice(pnZ);
		//HSB-13713 instead of just taking the contact face consider slice as well
		ppA.unionWith(bd.extractContactFaceInPlane(pnZ,dEps));
		PlaneProfile ppB=bd.getSlice(pnZ2);
		ppB.unionWith(bd.extractContactFaceInPlane(pnZ2,dEps));
		
		ppA.shrink(-dEps);
		ppB.shrink(-dEps);
		
		ppIcon.unionWith(ppA);
		ppOpp.unionWith(ppB);
	}
// HSB-16061
	ppIcon.shrink(dEps);
	ppIcon.shrink(dEps);
	ppIcon.shrink(-dEps);
	ppIcon.shrink(-dEps);
	ppIcon.shrink(dEps);
	
	ppOpp.shrink(dEps);
	ppOpp.shrink(dEps);
	ppOpp.shrink(-dEps);
	ppOpp.shrink(-dEps);
	ppOpp.shrink(dEps);
	ppFrame = ppIcon;
	ppFrame.intersectWith(ppOpp);
	
//	visPp(ppIcon,vecZ*U(300));
//	visPp(ppOpp,vecZ*U(400));
	// HSB-23324
	// consider openings that are created
	// after merging icon and opp planeprofiles
	PLine plRingsExtra[0];
	{ 
		PlaneProfile ppTot=ppIcon;
		ppTot.unionWith(ppOpp);
		
		PLine plOutIcons[]=ppIcon.allRings(true,false);
		PLine plOutOpps[]=ppOpp.allRings(true,false);
		
		PlaneProfile ppOutIcon(ppIcon.coordSys());
		PlaneProfile ppOutOpp(ppIcon.coordSys());
		if(plOutIcons.length()>0)
		{ 
			ppOutIcon=PlaneProfile(plOutIcons.first());
			for (int i=1;i<plOutIcons.length();i++) 
			{ 
				ppOutIcon.joinRing(plOutIcons[i],_kAdd);
			}//next i
		}
		if(plOutOpps.length()>0)
		{ 
			ppOutOpp=PlaneProfile(plOutOpps.first());
			for (int i=1;i<plOutOpps.length();i++) 
			{ 
				ppOutOpp.joinRing(plOutOpps[i],_kAdd);
			}//next i
		}
//		visPp(ppOutIcon,vecZ*U(300));
//		visPp(ppOutOpp,vecZ*U(500));
		//
		PLine plRingsIn[]=ppTot.allRings(false,true);
		for (int i=0;i<plRingsIn.length();i++) 
		{ 
			PlaneProfile ppI(plRingsIn[i]);
			PlaneProfile ppSubIcon=ppI;
			PlaneProfile ppSubOpp=ppI;
			ppSubIcon.subtractProfile(ppOutIcon);
			if(ppSubIcon.area()<pow(U(1),2))
			{ 
				continue;
			}
			ppSubOpp.subtractProfile(ppOutOpp);
			if(ppSubOpp.area()<pow(U(1),2))
			{ 
				continue;
			}
			//
//			plRingsIn[i].vis(2);
			plRingsExtra.append(plRingsIn[i]);
		}//next i
	}
	
	//HSB-19615
	PLine rings6[0];
	if(bIsBaufritz)
	{ 
		// consider zone 6 as contour for the insulation
		Sheet sheets6[]=el.sheet(-1);
		PlaneProfile ppSh6(ppInsulation.coordSys());
		for (int ish=0;ish<sheets6.length();ish++) 
		{ 
			PlaneProfile ppI=sheets6[ish].profShape();
			ppI.shrink(-U(2));
			ppSh6.unionWith(ppI);
		}//next ish
		ppSh6.shrink(U(2));
		rings6.append(ppSh6.allRings(true,false));
	}
	// loop faces
	for (int j=0;j<2;j++)
	{ 
	// get all opening rings of this face
		PlaneProfile ppFace=j==0?ppIcon:ppOpp;
		PLine rings[]=ppFace.allRings(false, true);
		// HSB-23324
		if(j==0)
		{ 
			if(plRingsExtra.length()>0)
			rings.append(plRingsExtra);
		}
		//HSB-19615: include in insulation rings those of sheet in -1
		if(bIsBaufritz)rings.append(rings6);
		PlaneProfile ppFaceContour=ppFace;
		ppFaceContour.removeAllOpeningRings();
		
		// HSB-16841
		PLine plsFaceContour[]=ppFaceContour.allRings(true,false);
		PlaneProfile ppX(j==0?cs:cs2);
		
		// HSB-12022
		if (bIsLathZone)
		{ 
			Point3d pts[]=ppFaceContour.getGripVertexPoints();
			PLine pl(vecZ);
			pl.createConvexHull(pnZ,pts);//pl.vis(6);
			ppFaceContour.removeAllRings();
			ppFaceContour.joinRing(pl, _kAdd); //ppFaceContour.vis(2);
			
			PlaneProfile pp=ppFaceContour;
			pp.shrink(dEps);
			ppFaceContour.shrink(-U(100));
			ppFaceContour.subtractProfile(pp);
			ppFaceContour.unionWith(ppFace);
			
			rings=ppFaceContour.allRings(false, true);
			
		// reconstruct a profile of all opening rings
			for (int i=0;i<rings.length();i++)
				ppX.joinRing(rings[i], _kAdd);
		}
		else
		{ 
		// get rings which stick out of a bounding box	
			PlaneProfile pp(cs);
			pp.createRectangle(ppFace.extentInDir(vecX), vecX, vecY);
		// test for gable walls
			// HSB-19139: calculate convex hull
			Point3d pts[]=ppFaceContour.getGripVertexPoints();
			PLine plConvexHull(vecZ);
			plConvexHull.createConvexHull(pnZ,pts);
			PlaneProfile ppRemainConvexHull;
			if(plsFaceContour.length()>0)
			{ 
				plConvexHull=plsFaceContour[0];
				ppRemainConvexHull=pp;
				ppRemainConvexHull.joinRing(plConvexHull,_kSubtract);
//				ppRemainConvexHull.vis(2);
			}
			PlaneProfile ppConvexHull;
			pp.subtractProfile(ppFaceContour);
			if(ppRemainConvexHull.area()>pow(dEps,2))
			{ 
				pp.subtractProfile(ppRemainConvexHull);
			}
			//HSB-13713 blowup and shrink to get individual rings on loose contours
			pp.shrink(U(25));
			pp.shrink(-U(25));
			
		// reconstruct a profile of all opening rings		
			for (int i=0;i<rings.length();i++) 
				ppX.joinRing(rings[i], _kAdd);
			
		// add rings which stick out and have no more then 1 free direction	
			rings=pp.allRings(true, false);
			for (int i=0;i<rings.length();i++) 
			{
				Body bd (rings[i],vecZ*U(50),0); // HSB-12022 improvement to find free direction, planeProfile extents could fail on triangles
				
				Point3d ptCen=bd.ptCen();
				int freeDir;
				Vector3d dirs[]={ vecX,vecY,-vecX,-vecY};
				for (int j=0;j<dirs.length();j++)
				{ 
					LineSeg segTest(ptCen,ptCen+dirs[j]*U(10e4));//
					LineSeg segs[]=ppFace.splitSegments(segTest,true);
					if (segs.length()<1)
					{	
						//dirs[j].vis(ptCen, i);
						freeDir++;
					}
					else if (bDebug)
					{
						Display dp(j);
						dp.draw(segs);
					}
				}//next j
			// HSB-16841
				if (freeDir<2 && plsFaceContour.length()==1)
				{ 
//					bd.vis(2);
					ppX.joinRing(rings[i], _kAdd);
				}
				else if(plsFaceContour.length()>=1)
				{ 
					ppX.joinRing(rings[i], _kAdd); 
				}
//				else
//					bd.vis(1);
			}
		}
		
	// reassign the result
		//ppX.vis(1);
		if (j==0) ppIcon=ppX;
		else if (j==1) ppOpp=ppX;
	}//next j
	
	//
//	{
//		PLine plsOutIcon[]=ppIcon.allRings(true,false);
//		PLine plsInIcon[]=ppIcon.allRings(false,true);
//		
//		PLine plsOutOpp[]=ppOpp.allRings(true,false);
//		PLine plsInOpp[]=ppOpp.allRings(false,true);
//		for (int i=0;i<plsOutIcon.length();i++) 
//		{ 
//			ppInsulation.joinRing(plsOutIcon[i],_kAdd); 
//		}//next i
//		for (int i=0;i<plsOutOpp.length();i++) 
//		{ 
//			ppInsulation.joinRing(plsOutOpp[i],_kAdd); 
//		}//next i
//		
//	}
	//
//	Opening openings[] = el.opening();
//	for (int i=0;i<openings.length();i++) 
//	{
//		ppIcon.joinRing(openings[i].plShape(), _kSubtract); 
//		ppOpp.joinRing(openings[i].plShape(), _kSubtract); 
//	}
	ppInsulation.unionWith(ppIcon);
	ppInsulation.unionWith(ppOpp);
// HSB-18309: remove the connected female walls 
	if(ppConnected.area()>pow(dEps,2))
	{ 
		ppInsulation.subtractProfile(ppConnected);
	}
//End HSB-11781
//End Get insulation profile//endregion 
	
// Functionality only used if ppFrame has no inner rings
	ElementRoof eRoof = (ElementRoof) el;
	PLine plFrame[] = ppFrame.allRings(false,true);
	if(eRoof.bIsValid() && plFrame.length() < 1)
	{ 
		dHeight.setReadOnly(true);
		if (dHeight != 0)dHeight.set(0);
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			EntPLine epl = (EntPLine)_Entity[i]; 
			if (epl.bIsValid())
			{ 
				Map m = epl.subMapX(scriptName());
//				Map m = epl.subMapX("hsbElementInsulation");
				int nMode = m.getInt("Mode");
				if (epl.bIsValid() && m.getString("Type")=="FloorContour")
				{ 
					PLine pl = epl.getPLine();
					Plane pnElement(el.ptOrg(), vecZ);
					pl.projectPointsToPlane(pnElement, _ZW);
					pl.close();
					if (pl.area()>pow(dEps,2))
					{ 
						setDependencyOnEntity(epl);
						// floorContour pline is assigned to all groups
						if(!bIsBaufritz)
							epl.assignToElementGroup(el, false, 0, 'T');
						ppInsulation.joinRing(pl, nMode);	
					}
				}
			}
		}//next i
		if(ppInsulation.area()>pow(dEps,2))
		{ 
			// take the intersection of plEnvelope with FloorContour
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(el.plEnvelope(), _kAdd);
			ppInsulation.intersectWith(ppEnvelope);
		}
		// remove ppframe
		if(ppInsulation.area()>pow(dEps,2))
			ppInsulation.subtractProfile(ppFrame);
	}
	
// post process frame if still no insulation area was found, but more than 1 item found
	if(ppInsulation.area()<pow(dEps,2) && genbeams.length()>1)
	{
		PLine plHull;
		plHull.createConvexHull(pnZ, ppFrame.getGripVertexPoints());
		//plHull.vis(2);
		ppInsulation.joinRing(plHull, _kAdd);
		ppInsulation.subtractProfile(ppFrame);
	}
// HSB-16061: 
	ppInsulation.shrink(U(3));
	ppInsulation.shrink(-U(3));
	ppInsulation.shrink(-U(3));
	ppInsulation.shrink(U(3));
// subtract all openings
	Opening openings[] = el.opening();
	for (int i=0;i<openings.length();i++) 
	{
		ppInsulation.joinRing(openings[i].plShape(), _kSubtract); 
	}
// HSB-23324: get OpeningRoof objects
	OpeningRoof opRoofs[0];
	if(el.bIsKindOf(ElementRoof()))
	{ 
		Group grpsEl[]=el.groups();
		for (int g=0;g<grpsEl.length();g++) 
		{ 
			Entity entOpRoofs[]=grpsEl[g].collectEntities(true,OpeningRoof(),_kModelSpace);
			for (int e=0;e<entOpRoofs.length();e++) 
			{ 
				OpeningRoof opRoofE=(OpeningRoof) entOpRoofs[e]; 
				if(opRoofE.bIsValid() && opRoofs.find(opRoofE)<0)
				{ 
					opRoofs.append(opRoofE);
				}
			}//next e
		}//next g
		Plane pnProjectOpenings=pnZ;
		// project to the bottom plane, openings are defined horizontally at bottom
		// and they get projected upward
		Point3d ptZ, ptZ2;
		int b0=Line(ptOrg,_ZW).hasIntersection(pnZ,ptZ);
		int b2=Line(ptOrg,_ZW).hasIntersection(pnZ2,ptZ2);
		if(_ZW.dotProduct(ptZ-ptZ2)>dEps)
		{ 
			pnProjectOpenings=pnZ2;
		}
		for (int o=0;o<opRoofs.length();o++) 
		{ 
			OpeningRoof opRoofI=opRoofs[o];
			PLine plO=opRoofI.plShape();
	//		plO.vis(2);
	//		plO.projectPointsToPlane(pnZ,opRoofI.coordSys().vecZ());
			plO.projectPointsToPlane(pnProjectOpenings,opRoofI.coordSys().vecZ());
	//		plO.vis(1);
			ppInsulation.joinRing(plO, _kSubtract); 
		}//next o
	}
	//{Display dpx(1); dpx.draw(ppInsulation,_kDrawFilled);}
// get polylines from entity
	PLine plSubtracts[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		EntPLine epl = (EntPLine)_Entity[i]; 
		Map m = epl.subMapX(scriptName());
		// dont consider FloorContour plines
		if(m.getString("Type")=="FloorContour")
			continue;
		int nMode = m.getInt("Mode");
		if (epl.bIsValid())
		{
			PLine pl = epl.getPLine();
			pl.close();
			if (pl.area()>pow(dEps,2))
			{ 
				setDependencyOnEntity(epl);
				if(!bIsBaufritz)
					epl.assignToElementGroup(el, true, 0, 'T');
				ppInsulation.joinRing(pl, nMode);	
			}
		}
	}
	
	// HSB-6910 scan all entities of element and see if polyline is published
	// when not all zone with insulation, pl is subtracted and instead 
	// volume is written
	// extra volumes
	double dVolInsulationAdd;
	{ 
		TslInst tsls[] = el.tslInstAttached();
		for (int i = tsls.length() - 1; i >= 0; i--)
		{ 
			TslInst tslI = tsls[i];

			if(nZone == 0)
			{
				Map mapX = tslI.subMapX("hsbElementInsulation[]");
				if(mapX.length() < 1 )continue;
				
				for (int j=0;j<mapX.length();j++) 
				{ 
					Map mapXj = mapX.getMap(j);
					PLine pl = mapXj.getPLine("pl");
					int nMode = mapXj.getInt("Mode");
					ppInsulation.joinRing(pl, nMode);
					if(mapXj.hasDouble("dVol"))
						dVolInsulationAdd += mapXj.getDouble("dVol");
				}//next j				
			}
		}//next i
	}
	//HSB - 13327: remove like in hsb_ApplyInsulation
	{ 
		//subtrach area of any TSL
		TslInst tlsAll[]=el.tslInstAttached();
		for (int i=tlsAll.length()-1; i>=0 ; i--) 
		{
			String sName = tlsAll[i].scriptName();
			if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
			{
				//TODO: Check if there is for the same zone
				//tlsAll[i].dbErase();
				if(bIsBaufritz)
				{ 
				// for baufritz, delete existing insulation tsl
					if(tlsAll[i].propInt(0)==nZone)
					{ 
					// HSB-21590:: same zone delete existing
						tlsAll[i].dbErase();
						reportMessage("\n"+scriptName()+" "+T("|TSL for this zone already inserted, existing instance will be replaced|"));
					}
				}
			}
		}
		
		for (int i=0; i<tlsAll.length(); i++)
		{
			if(!tlsAll[i].bIsValid())continue;
			String sName = tlsAll[i].scriptName();
			if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
			{
				//TODO: Check if there is for the same zone
				//tlsAll[i].dbErase();
			}
			else//if (sName=="hsb_Vent")
			{
				Map mp=tlsAll[i].map();
				if (mp.hasPLine("noinsulation"))
				{ 
					PLine plToSubstract = mp.getPLine("noinsulation");
					ppInsulation.joinRing(plToSubstract, _kSubtract);
				}
			}
		}
	}
	
// HSB-17354: subtract eave area of Ortgang and Traufe
	if(_Map.getInt("RemoveEaveArea"))
	{ 
	// get hsbRoofData-EaveArea TSL
//		Entity entsTsl[]=Group().collectEntities(true,TslInst(),_kModelSpace);
//		TslInst tslRoofDatas[0];
//		TslInst tslRoofDataFound;
//		int nRoofDataFound;
//		for (int i=0;i<entsTsl.length();i++) 
//		{ 
//			TslInst tsl=(TslInst)entsTsl[i];
//			if(tsl.bIsValid()&&tsl.scriptName()=="hsbRoofData")
//			{ 
//				int nModeTsl=tsl.map().getInt("mode");
//				if(nModeTsl!=0)continue;
//				// eave area
//				ERoofPlane erp;
//				Entity entsTsl[]=tsl.entity();
//				for (int j=0;j<entsTsl.length();j++) 
//				{ 
//					ERoofPlane erpTsl=(ERoofPlane)entsTsl[j];
//					if(!erpTsl.bIsValid())continue;
//					
//					PlaneProfile ppErp(erpTsl.coordSys());
//					ppErp.joinRing(erpTsl.plEnvelope(),_kAdd);
////					ppErp.vis(2);
//					if(ppErp.intersectWith(ppInsulation))
//					{ 
//						tslRoofDataFound=tsl;
//						nRoofDataFound=true;
//						break;
//					}
//				}//next j
//				if(nRoofDataFound)break;
//			}
//		}//next i
//		ppInsulation.vis(6);
//		if(nRoofDataFound && tslRoofDataFound.bIsValid())
//		{ 
//			Map mapPls=tslRoofDataFound.map().getMap("PLine[]");
//			PLine plContoursEave[0], plOpeningsEave[0];
//			for (int im=0;im<mapPls.length();im++) 
//			{ 
//				if(mapPls.hasPLine("contour"))
//				{ 
////					plContoursEave.append(mapPls.getPLine("contour"));
//					ppInsulation.joinRing(mapPls.getPLine("contour"),_kSubtract);
//				}
////				else if(mapPls.hasPLine("opening"))
////				{ 
////					plOpeningsEave.append(mapPls.getPLine("opening"));
////				}
//			}//next im
//		}
	// Insulation wil be calculated as intersection of + and negative zones
	// eave area of Ortgang and Traufe results from difference 
		PlaneProfile ppPositive(pnZ),ppNegative(pnZ);
		int nZonesPositive[]={1,2,3,4,5};
		int nZonesNegative[]={-1,-2,-3,-4,-5};
		for (int iz=0;iz<nZonesPositive.length();iz++) 
		{ 
			Sheet sheets[]=el.sheet(nZonesPositive[iz]);
			for (int sh=0;sh<sheets.length();sh++) 
			{ 
				PlaneProfile ppI=sheets[sh].profShape();
				ppI.shrink(-U(2));
				ppPositive.unionWith(ppI);
			}//next sh
		}//next iz
		ppPositive.shrink(U(2));
		for (int iz=0;iz<nZonesNegative.length();iz++) 
		{ 
			Sheet sheets[]=el.sheet(nZonesNegative[iz]);
			for (int sh=0;sh<sheets.length();sh++) 
			{ 
				PlaneProfile ppI=sheets[sh].profShape();
				ppI.shrink(-U(2));
				ppNegative.unionWith(ppI);
			}//next sh
		}//next iz
		ppNegative.shrink(U(2));
		
		ppPositive.intersectWith(ppNegative);
		ppInsulation.intersectWith(ppPositive);
	}
	
//	ppInsulation.vis(2);
	if (ppInsulation.area()<pow(dEps,2))
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No insulation possible|"));
		if (!bDebug)eraseInstance();
		return;
	}
	
// subtract area above given height
	if (dHeight>0 && elw.bIsValid())
	{ 
		PLine pl;
		pl.createRectangle(LineSeg(ptOrg - vecX * U(10e4), ptOrg + (vecX + vecY) * U(10e4)), vecX, vecY);
		pl.transformBy(vecY * dHeight);
		ppInsulation.joinRing(pl, _kSubtract);
	}
	
	if (!bCreateSheet)
	{
		// delete possible sheeting
		for (int i = 0; i < 200; i++)
		{
			String sKey = "entSheet" + i;
			if (_Map.hasEntity(sKey))
			{
				Entity entI = _Map.getEntity(sKey);
				entI.dbErase();
				_Map.removeAt(sKey, true);
			}
		}
	}//endregion	
//region Trigger EraseSheeting
	String sTriggerEraseSheeting = T("|Erase Insulation Sheeting|");
//	addRecalcTrigger(_kContextRoot, sTriggerEraseSheeting );
	if (_bOnRecalc && _kExecuteKey==sTriggerEraseSheeting || _kNameLastChangedProp==sAlignmentName)
	{
		// delete possible sheeting
		for (int i = 0; i < 200; i++)
		{
			String sKey = "entSheet" + i;
			if (_Map.hasEntity(sKey))
			{
				Entity entI = _Map.getEntity(sKey);
				entI.dbErase();
				_Map.removeAt(sKey, true);
			}
		}
		setExecutionLoops(2);
		return;
	}//endregion	
	
	
// Trigger SubtractArea//region
	String sTriggerFloorContour = T("|Select Floor Contour|");
	addRecalcTrigger(_kContext, sTriggerFloorContour );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFloorContour))
	{
	// prompt for polylines
		Entity ents[0];
		PrEntity ssEpl(T("|Select polyline(s)|"), EntPLine());
	  	if (ssEpl.go())
			ents.append(ssEpl.set());
		
		Map m;
		m.setInt("Mode", _kAdd);
		m.setString("Type", "FloorContour");
		for (int i=0;i<ents.length();i++) 
		{ 
			if(_Entity.find(ents[i])<0)
			{
				ents[i].setSubMapX(scriptName(), m);
				_Entity.append(ents[i]); 
			}	 
		}//next i
		setExecutionLoops(2);
		return;
	}//endregion

// Trigger SubtractArea//region
	String sTriggerSubtractArea = T("|Subtract Area|");
	addRecalcTrigger(_kContext, sTriggerSubtractArea );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSubtractArea || _kExecuteKey==sDoubleClick))
	{
	// prompt for polylines
		Entity ents[0];
		PrEntity ssEpl(T("|Select polyline(s)|"), EntPLine());
	  	if (ssEpl.go())
			ents.append(ssEpl.set());
		
		Map m;
		m.setInt("Mode", _kSubtract);
		for (int i=0;i<ents.length();i++) 
		{ 
			if(_Entity.find(ents[i])<0)
			{
				ents[i].setSubMapX(scriptName(), m);
				_Entity.append(ents[i]); 
			}	 
		}//next i
		setExecutionLoops(2);
		return;
	}//endregion	

// Trigger AddArea//region
	String sTriggerAddArea = T("|Add Area|");
	addRecalcTrigger(_kContext, sTriggerAddArea );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddArea)
	{
	// prompt for polylines
		Entity ents[0];
		PrEntity ssEpl(T("|Select polyline(s)|"), EntPLine());
	  	if (ssEpl.go())
			ents.append(ssEpl.set());
		
		Map m;
		m.setInt("Mode", _kAdd);
		for (int i=0;i<ents.length();i++) 
		{ 
			if(_Entity.find(ents[i])<0)
			{
				ents[i].setSubMapX(scriptName(), m);
				_Entity.append(ents[i]); 
			}	 
		}//next i
		setExecutionLoops(2);
		return;
	}//endregion
	
	
// TriggerEditInPlacePanel
	int bCreate;
	if (!bEditInPlace)
	{ 
		String sTriggerEditInPlace = T("|Edit Insulation in Place|");//sTriggerEditInPlaces[bEditInPlace];
		addRecalcTrigger(_kContext, sTriggerEditInPlace );
		if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace )
		{
			bCreate=true;
		}		
	}
	
// edit in place mode
	if (bEditInPlace)
	{ 
		PLine plRing(vecZ);
		for (int i=0;i<_PtG.length();i++) 
		{ 
			_PtG[i].transformBy(vecZ*vecZ.dotProduct(ptOrg-_PtG[i]));
			plRing.addVertex(_PtG[i]);
		}
		plRing.close();
	// invalid
		if (plRing.area()<pow(dEps,2))
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Invalid area.|"));
			if (!bDebug)eraseInstance();
			return;
		}
		
		PlaneProfile pp(cs);
		pp.joinRing(plRing,_kAdd);
		ppInsulation.intersectWith(pp);
	}
// create a  stock insulation profile to distribute sheet alike insualtions
	double dLength, dWidth;
	String sDescription;
	PlaneProfile ppStock(cs);
	Vector3d vecDir = vecY;
	Vector3d vecPerp = vecX;
	if (nAlignment>0)
	{ 
		vecDir=nAlignment == 1 ? vecX : vecY;
		vecPerp=nAlignment == 1 ? vecY : vecX;	
		
		if (mapItem.length()>0)
		{ 
			dLength = mapItem.getDouble("Length");
			dWidth = mapItem.getDouble("Width");
			sDescription = mapItem.getString("Description");
	
			PLine plStock;
			plStock.createRectangle(LineSeg(ptRef, ptRef + vecDir * dLength + vecPerp * dWidth), vecDir, vecPerp);
			//plStock.vis(6);
			ppStock.joinRing(plStock, _kAdd);
		}		
	}
	
// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName = el.elementGroup().name();
	//endregion
	
	Display dp1(4);
// draw
//	ppInsulation.vis(1);
	plRings = ppInsulation.allRings(true,false);
	PLine plOpenings[]= ppInsulation.allRings(false,true);

	Vector3d vecYsheet = cs.vecY();
	Vector3d vecZsheet = vecZT;
	Vector3d vecXsheet = vecYsheet.crossProduct(vecZsheet);
	vecXsheet.normalize();
	CoordSys csSheet(_Pt0, vecXsheet, vecYsheet, vecZsheet);
	Sheet sheetsZonsAssignment[] = el.sheet(nZoneAssignment);
	int iCount;
	double dVolInsulation = 0;
	for (int i=0;i<plRings.length();i++) 
	{ 
		PlaneProfile pp(cs);
		pp.joinRing(plRings[i], _kAdd);
		for (int ii=0;ii<plOpenings.length();ii++)//HSB-6910 subtract openings for each plRing
			pp.joinRing(plOpenings[ii], _kSubtract);

	// ignore little gaps HSB-12469
		pp.shrink(U(10));
		pp.shrink(-U(10));
		LineSeg seg =pp.extentInDir(vecX);	
		PlaneProfile pps[0];
		if (ppStock.area()>pow(dEps,2))
		{ 
			double dDir = abs(vecDir.dotProduct(seg.ptStart() - seg.ptEnd()));
			double dPerp = abs(vecPerp.dotProduct(seg.ptStart() - seg.ptEnd()));
			Point3d pt = seg.ptMid() - .5 * (vecDir * dDir + vecPerp * dPerp);
			//pp.vis(3);
		// transform stock pp to lower left
			ppStock.transformBy(pt - ppStock.coordSys().ptOrg());
			int nMax;
			while(pp.area()>pow(dEps,2) && nMax<100)
			{ 
				PlaneProfile ppX = pp;
				ppX.intersectWith(ppStock);
				if (ppX.area()>pow(dEps,2))
				{ 
					//ppX.vis(nMax);
					pps.append(ppX);
					ppStock.transformBy(vecDir*dLength);
					pp.subtractProfile(ppX);
				}
			
			// next column
				else
				{ 
					seg=pp.extentInDir(vecX);
					dDir = abs(vecDir.dotProduct(seg.ptStart() - seg.ptEnd()));
					dPerp = abs(vecPerp.dotProduct(seg.ptStart() - seg.ptEnd()));
					pt = seg.ptMid() - .5 * (vecDir * dDir + vecPerp * dPerp);
					ppStock.transformBy(pt - ppStock.coordSys().ptOrg());
				}
				nMax++;
			}	
		}
		else
		{
			pps.append(pp);
		}
		
	// HSB-15541
		// planeprofile in plan view of each sheet
		PlaneProfile ppPlans[0];
		// planeprofile considering all zone thickness
		PlaneProfile ppPlansZone[0];
		if(iStrategy==1)
		{ 
			// rigid strategy is selected
			PlaneProfile ppsNew[0];
			for (int ipp=0;ipp<pps.length();ipp++) 
			{ 
				PlaneProfile ppX = pps[ipp]; 
				ppX.shrink(U(1));
				ppX.shrink(-U(1));
				ppX.shrink(-U(1));
				ppX.shrink(U(1));
				LineSeg seg =ppX.extentInDir(vecX);
				PLine plRingsX[] = ppX.allRings(true, false);
				//HSB-6910
				if (plRingsX.length() <= 0)continue;
				PLine plX = plRingsX.length() > 0 ? plRingsX[0]: plRings[i];
				if(bEditInPlace)
				{ 
					plX.transformBy(vecZT * vecZT.dotProduct(_Pt0 - ppX.coordSys().ptOrg()));
				}
				
				Body bd(plX, vecZT * dDisplayThickness, 1);
				Body bdZone(plX, vecZT * dZ, 1);
				GenBeam gbIntersects[] = bd.filterGenBeamsIntersect(genbeams);
				
				PlaneProfile ppPlan = bd.shadowProfile(Plane(ptOrg, vecY));
				PlaneProfile ppPlanNoStud = bd.shadowProfile(Plane(ptOrg, vecY));
				PlaneProfile ppPlanNoStudZone = bdZone.shadowProfile(Plane(ptOrg, vecY));
				// Points for each stud intersecting insulation
				Point3d pts[0];
				Point3d ptMin, ptMax;
				ptMin = ppPlan.extentInDir(vecX).ptStart();
				ptMax = ppPlan.extentInDir(vecX).ptEnd();
				//
				pts.append(ptMin);
				pts.append(ptMax);
				for (int igb=0;igb<gbIntersects.length();igb++) 
				{ 
					Body bdI = gbIntersects[igb].envelopeBody(false, true);
					PlaneProfile ppI=bdI.shadowProfile(Plane(ptOrg, vecY));
					ppPlanNoStud.subtractProfile(ppI);
					ppPlanNoStudZone.subtractProfile(ppI);
					ppPlanNoStud.shrink(U(2));
					ppPlanNoStud.shrink(U(-2));
					ppPlanNoStud.shrink(U(-2));
					ppPlanNoStud.shrink(U(2));
					ppPlanNoStudZone.shrink(U(2));
					ppPlanNoStudZone.shrink(U(-2));
					ppPlanNoStudZone.shrink(U(-2));
					ppPlanNoStudZone.shrink(U(2));
					Point3d ptMinI = ppI.extentInDir(vecX).ptStart();
					Point3d ptMaxI = ppI.extentInDir(vecX).ptEnd();
					
					if(vecX.dotProduct(ptMinI-ptMin)>0)
					{ 
						pts.append(ptMinI);
					}
					if(vecX.dotProduct(ptMaxI-ptMax)<0)
					{ 
						pts.append(ptMaxI);
					}
				}//next igb
				
				pts = Line(ptMin, vecX).orderPoints(pts, dEps);
				
				if(pts.length()>2)
				{ 
					// more then 1 plane profile
					for (int jpt=0;jpt<pts.length()-1;jpt++) 
					{ 
						Point3d pt1=pts[jpt];
						Point3d pt2=pts[jpt+1];
					// plane planeprofile
						PlaneProfile ppStrip(ppPlan.coordSys());
						ppStrip.createRectangle(LineSeg(
							pt1-vecZ*U(10e4),pt2+vecZ*U(10e4)),vecZ,vecX);
						PlaneProfile ppStripZone=ppStrip;
						ppStrip.intersectWith(ppPlanNoStud);
						ppStripZone.intersectWith(ppPlanNoStudZone);
						ppPlans.append(ppStrip);
						ppPlansZone.append(ppStripZone);
					// vertical ppX
						PlaneProfile ppXstrip(ppX.coordSys());
						ppXstrip.createRectangle(LineSeg(
						pt1-vecY*U(10e4),pt2+vecY*U(10e4)),vecX,vecY);
						ppXstrip.intersectWith(ppX);
						ppsNew.append(ppXstrip);
//						ppXstrip.vis(2);
					}//next jpt
				}
				else
				{ 
					ppsNew.append(ppX);
				}
			}//next ipp
			// fix pps
			pps.setLength(0);
			pps.append(ppsNew);
		}
		
	// do per insulation item
		for (int j=0;j<pps.length();j++) 
		{ 
			PlaneProfile ppX = pps[j];
			if(dTol!=0)
			{ 
//				ppX.shrink(dTol);
				// HSB-23048: Apply only left anf right
				applySideTolerance(ppX,dTol,vecX);
			}
			// HSB-16061:
//			ppX.shrink(U(1));
			LineSeg seg=ppX.extentInDir(vecX);
			PLine plRingsX[]=ppX.allRings(true, false);
			//HSB-6910
			if (plRingsX.length() <= 0)continue;
			PLine plX=plRingsX.length()>0?plRingsX[0]:plRings[i];
			if(bEditInPlace)
			{ 
				plX.transformBy(vecZT*vecZT.dotProduct(_Pt0-ppX.coordSys().ptOrg()));
			}
		// create single
			if (bCreate)
			{ 
			// TODO add stock shape	
				
			// prepare tsl cloning
				TslInst tslNew;
				Vector3d vecXTsl=vecX; Vector3d vecYTsl=vecY;
				GenBeam gbsTsl[]={}; 
				Entity entsTsl[]={el}; 
				seg.ptMid().vis(3);
				Point3d ptsTsl[]={seg.ptMid()};
				int nProps[]={nZone,nColor,nTransparency};	
				double dProps[]={dThickness,dScaleElement,dScalePlan,dHeight};
				String sProps[]={sArticle,sMaterial,sManufacturer,sAlignment,sHatchElement,sHatchPlan, 
					sPainterStream, sPainterWall,sStrategy};
				Map mapTsl;
				mapTsl.setInt("directEdit", true);
				// layer position 
				mapTsl.setInt("iPosition", _Map.getInt("iPosition"));
				mapTsl.setPoint3d("Pt0Absolute", ptsTsl[0], _kAbsolute);
				String sScriptname=scriptName();
				
			// add vertices
//				ptsTsl.append(plRings[i].vertexPoints(true));
				
				ptsTsl.append(plX.vertexPoints(true));
//				for (int ipt=0;ipt<ptsTsl.length();ipt++) 
//				{ 
//					ptsTsl[ipt].vis(1); 
//				}//next ipt
				
				tslNew.dbCreate(sScriptname,vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
					nProps,dProps,sProps,_kModelSpace,mapTsl);
			}
			
			CoordSys csSheet_=csSheet;// in the case when ppPlans.length()>0
			double dInsulationThickness_=dInsulationThickness;
			Body bd, bdZone;
			if(ppPlans.length()==0)
			{
				// no intersection with studs
				if(plX.area()<pow(dEps,2))
				{ 
					continue;
				}
				if(dDisplayThickness<dEps)
				{ 
					continue;
				}
				
				if(dTolThickness==0 && dThickness!=0)
				{ 
					bd=Body(plX,vecZT*dDisplayThickness,1);		//bd.vis(70);
					bdZone=Body(plX,vecZT*dZ,1);		//bd.vis(70);
				}
				else if(dTolThickness!=0 && dThickness!=0)
				{ 
					bd=Body(plX,vecZT*dDisplayThickness,1);		//bd.vis(70);
					bdZone=Body(plX,vecZT*dZ,1);		//bd.vis(70);
					bd.transformBy(vecZT*dTolThickness);
					bdZone.transformBy(vecZT*dTolThickness);
				}
				else
				{ 
					bd=Body(plX,vecZT*(dDisplayThickness-2*dTolThickness),1);		//bd.vis(70);
					bdZone=Body(plX,vecZT*(dZ-2*dTolThickness),1);		//bd.vis(70);
					bd.transformBy(vecZT*dTolThickness);
					bdZone.transformBy(vecZT*dTolThickness);
				}
			}
			else if(ppPlans.length()>0)
			{ 
				// intersects with studs
//				PlaneProfile ppPlan = ppPlans[j];
				PlaneProfile ppPlan=ppPlansZone[j];
			// get extents of profile
				Point3d ptSheet=ppPlan.extentInDir(vecZT).ptStart();
				plX.transformBy(vecZT*vecZT.dotProduct(ptSheet-ppX.coordSys().ptOrg()));
				// get extents of profile
				LineSeg seg = ppPlan.extentInDir(vecZT);
				double dDisplayThickness_=abs(vecZT.dotProduct(seg.ptStart()-seg.ptEnd()));
				// 
				if(dInsulationThickness-dDisplayThickness_>dEps)
					dInsulationThickness_=U(90);
				else dInsulationThickness_=dInsulationThickness;
			
				if(dInsulationThickness-dDisplayThickness_>dEps && dThickness==0)
				{ 
					// HSB-15703 check if some from inventory fit and replace 90
					for (int it=0;it<dThicknesses.length();it++) 
					{ 
						if(dThicknesses[it]<=dDisplayThickness_)
						{ 
							dInsulationThickness_=dThicknesses[it];
							break;
						}
					}//next it
				}
				
				if(dDisplayThickness_<dEps)
				{ 
					continue;
				}
				
				dDisplayThickness_=dDisplayThickness_>dInsulationThickness_?dInsulationThickness_:dDisplayThickness_;
				//
				csSheet_.transformBy(vecZT*vecZT.dotProduct(ptSheet-csSheet.ptOrg()));
				if(dTolThickness==0 && dThickness!=0)
				{
					bd=Body (plX, vecZT*dDisplayThickness_, 1);
				}
				else if(dTolThickness!=0 && dThickness!=0)
				{ 
					bd=Body (plX, vecZT*dDisplayThickness_, 1);
					bd.transformBy(vecZT*dTolThickness);
				}
				else
				{ 
					bd=Body (plX, vecZT*(dDisplayThickness_-2*dTolThickness),1);
					bd.transformBy(vecZT*dTolThickness);
				}
			}
		//region get intersecting / partial overtlappings HSB-11781
			GenBeam gbIntersects[]=bd.filterGenBeamsIntersect(genbeams);
			GenBeam gbIntersectsZone[]=bdZone.filterGenBeamsIntersect(genbeams);
			for (int jj=0;jj<gbIntersects.length();jj++)
			{ 
				Body bdSub = gbIntersects[jj].envelopeBody(false, true);
				bd.subPart(bdSub);
			}//next jj
			for (int jj=0;jj<gbIntersectsZone.length();jj++)
			{ 
				Body bdSub = gbIntersectsZone[jj].envelopeBody(false, true);
				bdZone.subPart(bdSub);
			}//next jj
		// reconstruct profile from both faces
			if (gbIntersects.length()>0)
			{ 
				Plane pnBack(ptRef + vecZT * dDisplayThickness, vecZT);
				PlaneProfile pp(cs);
				pp.unionWith(bd.extractContactFaceInPlane(pnZ, dEps));
				pp.unionWith(bd.extractContactFaceInPlane(pnBack, dEps));
//				ppX = pp;
				// HSB-23324
				if(pp.area()>pow(U(10),2))
				{ 
					ppX = pp;
				}
			}
		//End get intersecting / partial overtlappings HSB-11781//endregion 
			
			if(bCreateSheet)
			{ 
				PlaneProfile ppSheet;
				ppSheet=PlaneProfile (csSheet);
				// HSB-15541
				if(ppPlans.length()>0)ppSheet=PlaneProfile (csSheet_);
				ppSheet.unionWith(ppX);
				LineSeg seg = ppSheet.extentInDir(vecX);
				double dZbd = abs(bd.lengthInDirection(vecZ));
				double dZbdZone = abs(bdZone.lengthInDirection(vecZ));
				if(mapPattern.hasDouble("MinWidthHeight"))
				{ 
					double dMinWidthHeight = mapPattern.getDouble("MinWidthHeight");
				// get extents of profile
					double dXbd = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
					double dYbd = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
					if(dXbd<dMinWidthHeight || dYbd<dMinWidthHeight)
					{ 
						// small piece not allowed
						continue;
					}
				}
				//HSB-16426:
				// HSB-12334
				if(iStrategy==1 && dThicknesses.length()>0 && dThickness==0)
				{ 
					if (dZbd < dThicknesses[dThicknesses.length()-1]
					&& dZbdZone< dThicknesses[dThicknesses.length()-1])continue;
				}
				// 
				if(dThickness>0 && dZbd<dThickness-U(1)  && dZbd<dInsulationThickness_-U(1))
				{ 
					// HSB-21103: 20240425: make sure body enough to support insulation
					continue;
				}
				String sKey="entSheet"+iCount;
				Entity entSheetMap=_Map.getEntity(sKey);
				Sheet shMap=(Sheet)entSheetMap;
				
			// erase existing sheet if article from inventory list is changed // HSB-14868
				String sCreateEvents[]={sToleranceName};
				int bCreateEvent=sCreateEvents.findNoCase(_kNameLastChangedProp,-1)>-1 || bDebug;
				if ((shMap.bIsValid() && _kNameLastChangedProp==sArticleName && mapItems.length())
					|| bCreateEvent)
				{
					shMap.dbErase();
					_Map.removeAt(sKey,true);
				}
				
				if(shMap.bIsValid())
				{ 
					// HSB-14868
					if (_kNameLastChangedProp==sMaterialName)shMap.setMaterial(sMaterial);
					
					if (_kNameLastChangedProp==sManufacturerName)shMap.setInformation(sManufacturer);
					
					Point3d ptCs = bEditInPlace ? _Pt0 : cs.ptOrg();
					if(abs(vecZT.dotProduct(ptCs+.5*vecZT*shMap.dD(vecZT)- shMap.coordSys().ptOrg()))>dEps && dTolThickness==0)
					{ 
						// move
//						shMap.transformBy(vecZT * vecZT.dotProduct(
//							cs.ptOrg()+.5*vecZT*shMap.dD(vecZT) - shMap.coordSys().ptOrg()));
						if(!bDeleteInstance)
						{ 
							//
							shMap.transformBy(vecZT * vecZT.dotProduct(
								ppSheet.coordSys().ptOrg()+.5*vecZT*shMap.dD(vecZT) - shMap.coordSys().ptOrg()));
						}
					}
					iCount++;
				}
				else if(!shMap.bIsValid())
				{ 
					// create new sheet
					Sheet shNew;
				// HSB-16426: check if an existing sheet is found and delete if
					{
						Body bdNew;
						PLine plBdNew;
						PLine plsNew[] = ppSheet.allRings(true, false);
						if (plsNew.length() > 0)
							plBdNew = plsNew[0];
						bdNew = Body(plBdNew, ppSheet.coordSys().vecZ() * dInsulationThickness, 1);
						bdNew.vis(3);
						PlaneProfile ppXnew = bdNew.shadowProfile(Plane(ptOrg, vecX));
						ppXnew.shrink(U(1));
						ppXnew.vis(1);
						PlaneProfile ppYnew = bdNew.shadowProfile(Plane(ptOrg, vecY));
						ppYnew.shrink(U(1));
						ppYnew.vis(1);
						PlaneProfile ppZnew = bdNew.shadowProfile(Plane(ptOrg, vecZ));
						ppZnew.shrink(U(1));
						ppZnew.vis(1);
						for (int ish = sheetsZonsAssignment.length() - 1; ish >= 0; ish--)
						{
							if (sheetsZonsAssignment[ish].label() != "InsulationSheet")continue;
							Body bdI = sheetsZonsAssignment[ish].envelopeBody(true, false);
							PlaneProfile ppXi = bdI.shadowProfile(Plane(ptOrg, vecX));
							ppXi.shrink(U(1));
							ppXi.vis(3);
							PlaneProfile ppYi = bdI.shadowProfile(Plane(ptOrg, vecY));
							ppYi.shrink(U(1));
							ppYi.vis(3);
							PlaneProfile ppZi = bdI.shadowProfile(Plane(ptOrg, vecZ));
							ppZi.shrink(U(1));
							ppZi.vis(3);
							if (ppXi.intersectWith(ppXnew) && ppYi.intersectWith(ppYnew)
								 && ppZi.intersectWith(ppZnew))
							{
								sheetsZonsAssignment[ish].dbErase();
								sheetsZonsAssignment.removeAt(ish);
							}
						}//next ish
					}
					// HSB-15541
					PlaneProfile ppBdy=bd.shadowProfile(Plane(ptRef,vecY));
					PlaneProfile ppBdyZone=bdZone.shadowProfile(Plane(ptRef,vecY));
					LineSeg segPpBdy=ppBdy.extentInDir(vecX);
					double dZppBdy=abs(vecZ.dotProduct(segPpBdy.ptStart()-segPpBdy.ptEnd()));
					if(ppPlans.length()==0)
					{
					// voids from horizontal beams
					// check if thickness of insulation bd >=dInsulationThickness
						PlaneProfile ppBdy=bd.shadowProfile(Plane(ptRef,vecY));
						PlaneProfile ppBdyZone=bdZone.shadowProfile(Plane(ptRef,vecY));
						{ 
						// get extents of profile
							LineSeg segPpBdy=ppBdy.extentInDir(vecX);
							segPpBdy.vis(2);
							double dZppBdy=abs(vecZ.dotProduct(segPpBdy.ptStart()-segPpBdy.ptEnd()));
							int iIntersected;
							PLine plContours[]=ppBdy.allRings(true,false);
							PLine plContoursZone[]=ppBdyZone.allRings(true,false);
							
							if((dZppBdy<(dInsulationThickness-U(1)) &&  dZppBdy<(dInsulationThickness-2*dTolThickness-U(1)))
								|| (plContours.length()>1 && plContoursZone.length()>0))
							{
							// intersected by existing horizontal beams, many voids to be filled 
								iIntersected = true;
//								continue;
							}
							
//							if(dZppBdy<(dInsulationThickness-U(1)))
							if(iIntersected && iStrategy==1)
							{ 
							// work with the full bdZone
								ppBdy=bdZone.shadowProfile(Plane(ptRef,vecY));
								plContours.setLength(0);
								plContours=ppBdy.allRings(true,false);
								if(plContours.length()>0)
								{ 
								// more then one contour
									for (int ipl=0;ipl<plContours.length();ipl++) 
									{ 
										PLine plIpl=plContours[ipl];
										PlaneProfile ppIpl(ppBdy.coordSys());
										ppIpl.joinRing(plIpl,_kAdd);
										Point3d ptIpl=ppIpl.extentInDir(vecZT).ptStart();
										ptIpl.vis(3);
										CoordSys csShI = csSheet;
										csShI.transformBy(vecZT*vecZT.dotProduct(ptIpl-csSheet.ptOrg()));
										
										double dZppBdyI=abs(vecZT.dotProduct(ppIpl.extentInDir(vecZT).ptStart()
												-ppIpl.extentInDir(vecZT).ptEnd()));
										
										PlaneProfile ppSheetI(csShI);
										ppSheetI.unionWith(ppSheet);
										ppSheetI.transformBy(vecZT*vecZT.dotProduct(ptIpl-ppSheetI.coordSys().ptOrg()));
										ppSheetI.vis(6);
										double dThicknessThis=dThickness;
										if(dThickness==0)
										for (int it=0;it<dThicknesses.length();it++) 
										{ 
											if(dThicknesses[it]<=dZppBdyI)
											{ 
												dThicknessThis=dThicknesses[it];
												break;
											}
										}//next it
										if(dThicknessThis>U(0))
										{ 
											if(dTolThickness==0 || dThickness!=0)
											{
												shNew.dbCreate(ppSheetI, dThicknessThis,1);
											}
											else if(dTolThickness!=0 && dThickness!=0)
											{ 
												shNew.dbCreate(ppSheetI, dThicknessThis,1);
												shNew.transformBy(dTolThickness*ppSheetI.coordSys().vecZ());
											}
											else if(dThickness==0)
											{ 
												shNew.dbCreate(ppSheetI, dThicknessThis-2*dTol,1);
												shNew.transformBy(dTolThickness*ppSheetI.coordSys().vecZ());
											}
										}
									}//next ipl
								}
							}
							else
							{ 
							// full insulation thickness
								if(dTolThickness==0 && dThickness!=0)
								{
									shNew.dbCreate(ppSheet,dInsulationThickness,1);
								}
								else if(dTolThickness!=0 && dThickness!=0)
								{ 
									shNew.dbCreate(ppSheet,dInsulationThickness,1);
									shNew.transformBy(dTolThickness*ppSheet.coordSys().vecZ());
								}
								else
								{ 
									shNew.dbCreate(ppSheet,dInsulationThickness-2*dTolThickness,1);
									shNew.transformBy(dTolThickness*ppSheet.coordSys().vecZ());
								}
							}
						}
//						shNew.dbCreate(ppSheet, dInsulationThickness,1);
					}
					else if(ppPlans.length()>0)
					{
					// insulation interrupted by vertical studs
						if(dThickness>0 && dZppBdy<dThickness-U(1) && dZppBdy<dInsulationThickness_-U(1))
						{ 
							// HSB-21103: 20240425: make sure body enough to support insulation
							continue;
						}
						if(dTolThickness==0 && dThickness!=0)
						{
							shNew.dbCreate(ppSheet,dInsulationThickness_,1);
						}
						else if(dTolThickness!=0 && dThickness!=0)
						{ 
							shNew.dbCreate(ppSheet,dInsulationThickness_,1);
							shNew.transformBy(dTolThickness*ppSheet.coordSys().vecZ());
						}
						else
						{ 
							shNew.dbCreate(ppSheet,dInsulationThickness_-2*dTol,1);
							shNew.transformBy(dTolThickness*ppSheet.coordSys().vecZ());
						}
					}
//					String sSheetName = mapItem.getString("Description");
//					String sSheetMaterial = mapItem.getString("Material");
//					shNew.assignToElementGroup(el, TRUE, nZone, 'Z');
					if(!bIsBaufritz)
						shNew.assignToElementGroup(el,TRUE,nZoneAssignment,'Z');
					shNew.setMaterial(sMaterial); // HSB-148968
//					shNew.setName(sDescription);
					
					// HSB-22516: write article at name
					if(sArticle!="")
					{ 
						shNew.setName(sArticle);
					}
					shNew.setInformation(sManufacturer);
					shNew.setLabel("InsulationSheet");
					if(nSheetColor>-2)
						shNew.setColor(nSheetColor);
					else if (nSheetColor==-2)
					{
						// HSB-18860 by zone
						shNew.setColor(el.zone(nZoneAssignment).color());
					}
					// HSB-22516
					if(sRvalue!="")
					{
						// write the rate of heat of the insulation
						shNew.setGrade(sRvalue);
					}
					Map mp;
					mp.setInt("Erase", true);
					shNew.setSubMapX("Insulation", mp);
					
					_Map.setEntity(sKey, shNew);
					iCount++;
				}
			}
			
		// draw
			// when using hatch sometimes some areas might not be hatched
			// use pattern NET if this occurs
		// Element View	
			dpElement.draw(ppX);		
			if (sHatchElement=="SOLID")
				dpElement.draw(ppX, _kDrawFilled);
			else if (nPatternElement>0)
				dpElement.draw(ppX, hatchElement);
		//Plan View
			PlaneProfile ppPlan=bd.shadowProfile(Plane(ptOrg, vecY));
			PlaneProfile ppWorldZ=bd.shadowProfile(Plane(ptOrg, _ZW));
			dpPlan.draw(pp);
			
			if (sHatchPlan=="SOLID")
			{
				dpWorldZ.draw(ppPlan, _kDrawFilled);
				if (!vecY.isParallelTo(_ZW))
					dpPlan.draw(ppPlan, _kDrawFilled);			
			}
			if (nPatternPlan>0)
				dpPlan.draw(ppPlan, hatchPlan);	
			//Model
			dpModel.color(j);
			dpModel.draw(bd);
//			
//			{ 
//				bd.transformBy(vecZ * U(500));
//				dpModel.draw(bd);
//			}
			
		// add componnent
			{ 				
				HardWrComp hwc(sArticleNumber, 1); // the articleNumber and the quantity is mandatory
				
				hwc.setManufacturer(sManufacturer);			
				hwc.setDescription(sDescription);
				hwc.setMaterial(sMaterial);
				hwc.setNotes(T("|Zone| " + nZone));
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(el);	
				hwc.setCategory(T("|Insulation|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				double dX=abs(vecDir.dotProduct(seg.ptEnd()-seg.ptStart()));
				double dY=abs(vecPerp.dotProduct(seg.ptEnd()-seg.ptStart()));
				
				hwc.setDScaleX(dX);
				hwc.setDScaleY(dY);
				hwc.setDScaleZ(dInsulationThickness);
				hwc.setDOffsetX(ppX.area()/pow(U(1000),2));
				// get total volume to write in mapXof element
				dVolInsulation+=(dX*dY*dInsulationThickness);
			// apppend component to the list of components
				hwcs.append(hwc);
			}			
		}//next j
	}
	dVolInsulation+=dVolInsulationAdd;
	// distinguish what element it is ElementWall or ElementRoof
	String sElementType;
	int isExposed=true;
	int isHorizontal=true;
	{ 
		ElementWall ew=(ElementWall)el;
		if(ew.bIsValid())
		{
			sElementType="ElementWall";
			isExposed=ew.exposed();
		}
		ElementRoof er=(ElementRoof)el;
		if(er.bIsValid())
		{
			sElementType="ElementRoof";
			if(!er.vecZ().isParallelTo(_ZW))
				isHorizontal=false;
		}
	}
	// HSB-6910 write in mapx of element
	Map m;
	// HSB-14132
	m.setDouble("dVolInsulation", dVolInsulation/(1e9));
	m.setString("Manufacturer", sManufacturer);
	m.setString("Description", sDescription);
	m.setString("Material", sMaterial);
	// element type
	m.setString("ElementType", sElementType);
	m.setInt("Exposed", isExposed);
	m.setInt("Horizontal", isHorizontal);
	el.setSubMapX("insulationInfo", m);
	
// erase creator
	if (bCreate)
	{ 
		// cleanup sheets
		for (int i=0;i<200;i++) 
		{ 
			String sKey="entSheet"+i;
			if(_Map.hasEntity(sKey))
			{ 
				Entity entI = _Map.getEntity(sKey);
				entI.dbErase();
				_Map.removeAt(sKey, true);
			}
		}//next i
		
		//reportMessage(TN("|erase me|"));
		eraseInstance();
		return;
	}
	if(bCreateSheet && !bDeleteInstance)
	{ 
		// HSB-22315:
		// sheets are created and instance will remain
		// write 0 weigth explicitely at tsl instance
		Map mapXweight;
		mapXweight.setDouble("Weight",0);
		mapXweight.setPoint3d("Center",_Pt0);
		_ThisInst.setSubMapX("CenterOfGravity",mapXweight);
	}
	else if(!bDeleteInstance)
	{ 
		_ThisInst.removeSubMapX("CenterOfGravity");
	}
	
// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
	_ThisInst.setHardWrComps(hwcs);	
	
// Trigger EditInventory//region
	String sTriggerEditInventory = T("|Edit Inventory|");
	addRecalcTrigger(_kContext, "_____________________" );
	if (findFile(strAssemblyPath)!="")
		addRecalcTrigger(_kContext, sTriggerEditInventory );
	if (_bOnRecalc && _kExecuteKey==sTriggerEditInventory)
	{
	//Collect data
		Map mpIn;
		Map mapOut = callDotNetFunction2(strAssemblyPath, strType, "ShowInventoryEditorDialog", mpIn);
		setExecutionLoops(2);
		return;
	}//endregion	
	
	// Trigger Database
		String sTriggerDatabase =bReadDB?T("|Database off|"):T("|Database on|");
		addRecalcTrigger(_kContext, sTriggerDatabase);
		if (_bOnRecalc && _kExecuteKey==sTriggerDatabase)
		{
			bReadDB = !bReadDB;
			String k;
			Map m;
			k = "Inventory"; 	if (mapSetting.hasMap(k) )m = mapSetting.getMap(k);
			m.setInt("ReadDatabase", bReadDB);
			mapSetting.setMap("Inventory", m);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);
				
			if (!bReadDB && _Map.hasMap("Item[]"))
				_Map.removeAt("Item[]", true);	

			setExecutionLoops(2);
			return;
		}

	_ThisInst.setAllowGripAtPt0(false);	
	
	if(bDeleteInstance)
	{ 
		eraseInstance();
		return;
	}


//region Dialog Trigger //HSB-19440
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

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
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
M_L5Q5,!)?"[FJJI[HQHIK=ONM_WU4S+N7Y66JESX5U.W^:!HYU_V?E:L[SKB
MQF\N59(V_NLM<TH58?$B_=>J9M+'MIVUJHIJD?\`%5R.ZAD^ZRTXSC;4&F.V
MM3MM'WOXJ-W\-5IT$PVTY8]WWFHH7=_%1:/40[R_]JG;67^*J\MU#"NUFK+N
M=69FVQ_*M-<JV$S4GNH;=?WC?-_=K'N]:9OW<:[5:J(-Q?W/E6T;7$K?PK_#
M6_8^!Y)6\[4[C;_TQA_^*K6-&<]M`;BCG$^U7\WEVT,DTG]U:Z'3?!4TNV34
M9O+7_GG'][_OJNPM+&VL(?)M85AC]%JS773PL(ZO<S<VRK9:?:Z?%Y=K`D2>
MB]ZM445TI6V("BBBF`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%12V\-PFV:-9%_P!I
M:EHI-)Z,#GKOPG8S;FM]UNW^S]VL*Y\-:I:?-#&LRK_=;YJ[ZBN>>$I3Z6+5
M22/,X[ZXMY/+965E_A:KT.J+]V1:[>YL[>[CVSPQR+_M+6%>>$+28'[--)!_
ML]5KCE@91=XNYHJJZHSVOH5CW;JS;G6&;Y8UVU+<>%M7@5EC\NXC_P!ZI;'P
M3=W#[]2N/)C_`.><)W,?^!4H4*K>J$Y(P6DDN)ECC62:9O\`EFOS-71Z;X,F
ME99M1D\M?^>,==58:59:9%Y=I`L?]YL?,WXU=KMIX>,=R'-LJV6GVNG0>5:P
MK&GHO>K5%%="5B`HHHI@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!15&?4[*VO[
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
95C7YERRUTME$UO900MMW1QJIQ5BB@#__V?+\
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
        <int nm="BreakPoint" vl="2752" />
        <int nm="BreakPoint" vl="2729" />
        <int nm="BreakPoint" vl="2732" />
        <int nm="BreakPoint" vl="2697" />
        <int nm="BreakPoint" vl="2710" />
        <int nm="BreakPoint" vl="2381" />
        <int nm="BreakPoint" vl="2384" />
        <int nm="BreakPoint" vl="2388" />
        <int nm="BreakPoint" vl="2662" />
        <int nm="BreakPoint" vl="2639" />
        <int nm="BreakPoint" vl="2642" />
        <int nm="BreakPoint" vl="2607" />
        <int nm="BreakPoint" vl="2620" />
        <int nm="BreakPoint" vl="2012" />
        <int nm="BreakPoint" vl="1926" />
        <int nm="BreakPoint" vl="1853" />
        <int nm="BreakPoint" vl="1768" />
        <int nm="BreakPoint" vl="1723" />
        <int nm="BreakPoint" vl="1714" />
        <int nm="BreakPoint" vl="1707" />
        <int nm="BreakPoint" vl="1708" />
        <int nm="BreakPoint" vl="1809" />
        <int nm="BreakPoint" vl="1808" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23868: Add filter for Baufritz" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="4/15/2025 8:17:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23324: Make sure for roof elements the opening objects are projected from below" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="3/6/2025 11:36:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23324: Consider roof openings" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="2/6/2025 4:14:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23324: Consider openings that are created after merging icon and opposite planeprofiles" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="2/6/2025 3:04:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="hsbMF-4779: Fix function that applies offset" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="1/24/2025 4:48:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22315: When Insulation Sheets are created the tsl Instance will not be considered for weight calculation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="1/7/2025 1:36:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23048: In elevation apply tolerance only on left and right; Dont apply tolerance on top and bottom" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="12/5/2024 1:28:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22516: Add property &quot;R-value&quot; (ability to reduce rate of heat flow); value will be written in grade of insulation sheet" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="9/3/2024 11:52:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21103: remove tolerance in thickness" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="5/31/2024 2:19:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21991: reorganise code " />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="5/22/2024 8:11:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21103: Change property name &quot;Strategy&quot;-&gt; &quot;Thickness variable&quot;: Add description" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="4/29/2024 8:19:10 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21103: 20240425: For insulation with fix thickness, make sure the insulation remains inside the zone; should not be outside of the zone space" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="4/25/2024 10:33:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21103: Fix display and sheet generation when tolerance is used" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="4/5/2024 10:53:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21103: Add property &quot;Gap&quot; to apply gap around the insulation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/19/2024 11:40:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21590: (For Baufritz:) Newly inserted TSL instance at same zone will replace existing" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/11/2024 9:28:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19615: For Baufritz consider zone 6 as contour for the insulation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/26/2023 10:22:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19440 new context commands to disable/enable invetory database and to export settings, created sheet materials will be modified on property change" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/5/2023 9:37:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19440 bugfix for elements being created by TSL with a negative reference  height" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="7/4/2023 11:51:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19139: remove remaining of convex hull from the insulaiton pp" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="6/30/2023 1:47:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18860: Use the property color for sheet if color in xml &lt;=-3" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="6/20/2023 10:53:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19077: Keep insulation group from element group separated for Baufritz" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="6/7/2023 8:52:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18801: Enter wait state if no element beam found (beams without panhand state)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="5/12/2023 10:48:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18309: Make sure insulation sheeting doesnot collides with corner female walls connected to this wall" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="3/13/2023 11:56:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17824: Regen after changing group visibility in console" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="2/15/2023 5:01:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17354: If one side of the sheet zones - or + is open then it will be considered as eave area" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="12/14/2022 1:46:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17354: read from _Map to turn off Insulation groups; remove insulation at eave areas (Traufe, Ortgänge)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="12/14/2022 9:16:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16841: improve insulation when beams dont create a closed contour" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="10/18/2022 3:40:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16841: Support extra group assignment" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="10/18/2022 10:37:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12334: fix when investigating possible insulation thicknesses" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="9/16/2022 2:49:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16426: Improve voids from horizontal beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="9/6/2022 4:19:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16426: fix when filling voids" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="9/5/2022 5:11:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16061: shrink profile of insulation with 1mm to avoid tolerance errors when subtracting other beam bodies" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="9/2/2022 10:02:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15703: show description instead of article number, additional xml parameters" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="6/10/2022 12:50:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15541: Add property Strategy {&lt;Default&gt;,Rigid} to decide how the insulation will be cutted" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="5/27/2022 1:44:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14868 material properties written to sheet entities, inventory groups can be specified in settings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/9/2022 10:26:12 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14132: 10^9is written as 1e9" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="12/15/2021 1:44:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13327: support multiple layers, add painter filter for walls" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="12/2/2021 12:17:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13713 loose contour detection improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/10/2021 12:33:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12741 model display not hidden anymore in Z and Y view of element" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="7/29/2021 8:58:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12469 bugfix insulation spanning into gable elements" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/30/2021 3:44:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12022 insualtion detection enhanced for lath zones." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/28/2021 1:51:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11781 insulation considers entities which are not fully spanning the zone thickness. Redundant property purged.NOTE: It is recoomended to replcae existing instances with a new instance. When using the tsl as a construction plugin one should call the dialog once to update the properties" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/7/2021 11:49:19 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End