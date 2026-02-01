#Version 8
#BeginDescription
#Versions
Version 1.5 09.12.2021 HSB-14123 supports plugInGroup extension and default import, new command to create basic panel , Author Thorsten Huck




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <History>//region
// #Versions
// 1.5 09.12.2021 HSB-14123 supports plugInGroup extension and default import, new command to create basic panel , Author Thorsten Huck
/// <version value="1.4" date="02oct18" author="thorsten.huck@hsbcad.com"> alignment panel creation fixed </version>
/// <version value="1.3" date="02oct18" author="thorsten.huck@hsbcad.com"> MapX Export supports also area and volume </version>
/// <version value="1.2" date="02oct18" author="thorsten.huck@hsbcad.com"> MapX Export supported </version>
/// <version value="1.1" date="14sep18" author="thorsten.huck@hsbcad.com"> automatic conversion deactivated </version>
/// </History>

/// <insert Lang=en>
/// Search IFC file, configure types and and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl calls the IFC import utility and creates body importer tsls which can be used to generate various types of solids or genbeam types
/// </summary>//endregion


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
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
	//endregion


	if (bDebug)reportMessage("\n" + scriptName() + " " + _kExecuteKey + " " + _ThisInst.handle());

	String strMapOnly = "source";
	String strKeyOnly = "body";
	String strMapKey = strMapOnly + "\\" + strKeyOnly;
	String strMapKeyHsbType = strMapOnly + "\\" + "HsbType";
	String strHsbTypes[] = {"BEAM","SHEET","SIP"};	
	String strPanelCreateTsl = "hsbSolid2PanelConversion";

	
// on insert
	if (_bOnInsert)
	{	
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// constants
		String strAssemblyPath = _kPathHsbInstall+"\\Utilities\\hsbCloudStorage\\hsbIFCtoMapConfigurator.exe";  
		String strType = "hsbCad.hsbIFCtoMapConfigurator.HsbCadIO"; 
		String strFunction = "RunConfigurator";  
		Map mapOut;
		Map mapIn= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapOut);	

//		Map mapIn;
//		mapIn.writeToDxxFile(_kPathDwg+"\\IFC2Model.dxx");
//		mapIn.readFromDxxFile(_kPathDwg+"\\IFC2Model.dxx");

	// import model map
		ModelMap mm;
		mm.setMap(mapIn);

	//set some import flags
		ModelMapInterpretSettings mmFlags;
		mmFlags.resolveEntitiesByHandle(false); // default FALSE
		mmFlags.resolveElementsByNumber(false); // default FALSE
		//mmFlags.setBeamTypeNameAndColorFromHsbId(TRUE); // default FALSE
	
	// interpret ModelMap
		mm.dbInterpretMap(mmFlags);
	
		reportMessage("\n" + scriptName() + ": " +mm.entity().length() + " " + T("|entities imported.|"));
		
		eraseInstance();
		return;		
	}// end on insert_______________________________________________________________________________________________

	
// collect potential metaData
	Map mapSource = _Map.getMap("source");
	Map mapMeta = mapSource.getMap("propertysets\\metadata");
	String guid = mapSource.getString("GUID");
	
	String strHsbType = _Map.getString(strMapKeyHsbType);
	strHsbType.makeUpper();
	int nHsbType = strHsbTypes.find(strHsbType);
	
// get the body	from map
	String kBody = "body";
	int bHasBody = mapSource.hasBody(kBody);
	Body bd;
	if (bHasBody)
		bd = mapSource.getBody(kBody);
	else
	{ 
		kBody = "bodyOriginal";
		bHasBody = mapSource.hasBody(kBody);
		if (bHasBody)
			bd = mapSource.getBody(kBody);
	}
	if (bd.volume() < pow(dEps, 3))
	{
		reportMessage("\n" + guid + T("|failed to get body|") + T(", |entry| ") +T(", |Key| ") + kBody+ (bHasBody?T(" |found|"):T(" |not found|")));
		bHasBody = false;
	}
	
// get potential element assignment
	Element el = _ThisInst.element();

// get coordSys
	Vector3d vecX = _XE;
	Vector3d vecY = _YE;
	Vector3d vecZ = _ZE;
	
// fix coordinate system coming from ifc import
	if (_bOnDbCreated)
		setExecutionLoops(2);
	//if (bHasBody && (!_Map.hasInt("AdjustedCoordSys") && !_bOnDbCreated) ||_bOnRecalc)
	{ 
		//reportMessage(TN("|Adjust coordSys|") + _ThisInst.handle());
		
		Beam bm;
		bm.dbCreate(bd, true, true);// use the rounded bounding body
		if (bm.bIsValid())
		{ 
			vecX = bm.vecX();
			vecY = bm.vecY();
			vecZ = bm.vecZ();
		
		// treat like a panel
			if (nHsbType==2 ||nHsbType==-1)
			{ 
			// make Z the smallest dimension	
				if (bm.solidWidth()<bm.solidHeight())
				{ 
					vecY = -bm.vecZ();;
					vecZ = bm.vecY();
				}
			// if element alike orientation make it upright
				if (vecZ.isParallelTo(_ZW) && !vecZ.isCodirectionalTo(_ZW))
				{ 
					vecX *= -1;
					vecZ *= -1;
				}				
			}
		// erase temp beam
//			_XE = vecX;
//			_YE = vecY;
//			_ZE = vecZ;	
			//_Map.setInt("AdjustedCoordSys", true);
			bm.dbErase();
		}	
	}
	

	vecX.vis(_Pt0,1);
	vecY.vis(_Pt0,3);
	vecZ.vis(_Pt0,150);


// copy source data to mapX
	double dX, dY, dZ;
	if (bHasBody)
	{ 
		Map mapX;
		dX = bd.lengthInDirection(vecX);
		dY = bd.lengthInDirection(vecY);
		dZ = bd.lengthInDirection(vecZ);
		
		mapX.setVector3d("vecX", vecX);
		mapX.setVector3d("vecY", vecY);
		mapX.setVector3d("vecZ", vecZ);
		
		mapX.setDouble("SolidLength", dX);
		mapX.setDouble("SolidWidth", dY);
		mapX.setDouble("SolidHeight", dZ);	
		
		mapX.setDouble("Area", bd.shadowProfile(Plane(_Pt0,vecZ)).area(), _kArea);
		mapX.setDouble("Volume", bd.volume(), _kVolume);

		mapX.setMap("PropertySets", mapSource.getMap("PropertySets"));
		_ThisInst.setSubMapX("IfcData", mapX);
	}


// set auto convert on _bOnDbCreated
	int bCreate;// = (_bOnDbCreated && strHsbTypes.find(strHsbType)>-1 && bHasBody);
	
// debug commands
	if (bDebug)
	{
		String strChangeEntity = T("|set map from beam solid|");
		addRecalcTrigger(_kContextRoot, strChangeEntity );
		if (_bOnRecalc && _kExecuteKey==strChangeEntity) 
		{
			Beam bm  = getBeam();	
			Map map;
			map.setBody(strKeyOnly, bm.realBody());
			_Map.setMap(strMapOnly,map);
		}
	
		String strChangeEntity0 = T("|reset map|");
		addRecalcTrigger(_kContextRoot, strChangeEntity0 );
		if (_bOnRecalc && _kExecuteKey==strChangeEntity0) 
		{
			Map map;
		  	_Map.setMap(strMapOnly,map);
		}
	
		String strChangeEntity1 = T("|show map (in debug only)|");
		addRecalcTrigger(_kContextRoot, strChangeEntity1 );
		if (_bOnRecalc && _kExecuteKey==strChangeEntity1) 
		{
			_Map.showAdd();
		}
	}

// trigger convert into solid
	String sTriggerConvert2Acis = T("|Convert into acis solid|");
	if (bHasBody)
		addRecalcTrigger(_kContextRoot, sTriggerConvert2Acis );
	if (_bOnRecalc && _kExecuteKey==sTriggerConvert2Acis) 
	{
		bd.dbCreateAs3dSolid(-1);
		eraseInstance();
		return;
	}

// trigger convert into mass element
	String sTriggerConvert2MassElement = T("|Convert into mass element|");
	if (bHasBody)
		addRecalcTrigger(_kContextRoot, sTriggerConvert2MassElement );
	if (_bOnRecalc && _kExecuteKey==sTriggerConvert2MassElement) 
	{
		bd.dbCreateAsMassElement(CoordSys(),-1);
		eraseInstance();
		return;
	}
// trigger create solid
	String sTriggerCreateAcis = T("|Create acis solid|");
	if (bHasBody)
		addRecalcTrigger(_kContextRoot, sTriggerCreateAcis );
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateAcis) 
	{
		bd.dbCreateAs3dSolid(-1);
	}
// trigger create mass element	
	String sTriggerCreateMassElement = T("|Create mass element|");
	if (bHasBody)
		addRecalcTrigger(_kContextRoot, sTriggerCreateMassElement );
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateMassElement) 
	{
		bd.dbCreateAsMassElement(CoordSys(),-1);
	}
	
// declare genbeam to assign metaData
	GenBeam gb;
	
// trigger create beam
	String sTriggerCreateBeam = T("|Create Beam|");
	if (bHasBody)	
		addRecalcTrigger(_kContextRoot, sTriggerCreateBeam);
	if ((bCreate && nHsbType==0) || (_bOnRecalc && _kExecuteKey==sTriggerCreateBeam))
	{
		Entity entSolid = bd.dbCreateAs3dSolid(-1);
		entSolid.setIsVisible(FALSE);	
		
		Beam bm;
		bm.dbCreate(bd, vecX, vecY, vecZ, TRUE);
		bm.dbCreate(bd, TRUE);
		Vector3d vx, vy, vz;
		vx = bm.vecX();
		vy = bm.vecY();
		vz = bm.vecZ();
		if (bm.dW() < bm.dH())
		{
			bm.dbErase();
			bm.dbCreate(bd, vx, vz, -vy, TRUE);
		}
		if (bm.bIsValid())
		{
			gb = bm;
		}
		else
			_ThisInst.setColor(1);
	}

// trigger create sheet
	String sTriggerCreateSheet = T("|Create Sheet|");
	if (bHasBody)
		addRecalcTrigger(_kContextRoot, sTriggerCreateSheet);
	if ((bCreate && nHsbType==1) || (_bOnRecalc && _kExecuteKey==sTriggerCreateSheet))
	{
		Sheet sh;
		sh.dbCreate(bd, TRUE, U(100));
		if (sh.bIsValid())
		{
			gb = sh;
		}
		else
			_ThisInst.setColor(1);
	}


// trigger create panel
	String sSipTriggers[] = {T("|Create panel|") ,T("|Create basic panel|")};
	if (bHasBody)
	{
		for (int e=0;e<sSipTriggers.length();e++) 
		{ 
			String trigger = sSipTriggers[e]; 
			addRecalcTrigger(_kContextRoot,trigger);

			if ((bCreate && nHsbType==2) || (_bOnRecalc && _kExecuteKey==trigger)) 
			{
				Entity entSolid = bd.dbCreateAs3dSolid(-1);
				entSolid.setIsVisible(FALSE);
				
				int bSuccess;
				Beam bm;
				bm.dbCreate(bd,vecX,vecY,vecZ, TRUE,e==0?false:true); // distinguish between basic and full conversion

			// acceptance tag
				int nAccept; // 0 = break attempt, 1=accept, >1 multiple
			
			// preload sip style if defined in metaData and not present in this dwg
				String sStyleName = mapMeta.getString("SipStyle");
				String sStyleNames[] = SipStyle().getAllEntryNames();
				int nStyleName =sStyleNames.find(sStyleName);
				if (mapMeta.hasString("SipStyle") && nStyleName<0 && sStyleName.length()>0)
				{
				// get external path to definition dwg
					String defaultPath = _kPathHsbCompany+"\\Sips\\PanelStyles.dwg";
					String path = findFile(defaultPath);			
					
				// try to import panel style
					String err;
					if (path.length()>0)
					{
						String sEntries[] = SipStyle().getAllEntryNamesFromDwg(path);
						if (sEntries.find(sStyleName)>-1)
							err = SipStyle().importFromDwg(path , sStyleName, false); 
						else
							err = sStyleName + " " + T("|not found in style definition drawing.|");
					}
					else
						err = T("|Style definition drawing not found.|");
				// alert if import failed
					if (err.length()>0)
						reportMessage("\n************** "+scriptName() + "**************\n" + 
							T("|An error occured while importing the panel style|") + "\n" + 
							sStyleName + " " + T("|could not be found in|") + " " + defaultPath + "\n" +T("|Error|") +": " + err + 
							"\n******************************************************");
					else
					{
						nAccept=1;
						sStyleNames = SipStyle().getAllEntryNames();
						nStyleName =sStyleNames.find(sStyleName);
						if(bDebug)reportMessage("\nStyle " + sStyleName + " with index " + nStyleName + " imported");
					}
				}
				if(bDebug)reportMessage("\nStyle " + sStyleName + " with index " + nStyleName + " detected");
				
			// test sip styles and thicknesses for default acceptance tag
				if (nAccept!=1)
				{
					double dThickness = bm.dH();
					SipStyle styles[] = SipStyle().getAllEntries();		
					for (int i=0 ; i < styles.length() ; i++) 
					{
						double d = styles[i].dThickness();
					    if(abs(d-dThickness)<dEps)
					    {
					    	nAccept++; 
					    	if (bDebug)reportMessage("\nthickness type " +d);
					    }
					}
				}
				
			// create new style	
				if (nAccept<1)
				{ 
					double dThickness = bm.dH();
					if (sStyleName.length()<1)
						sStyleName.formatUnit(dThickness, 2, 0);
					SipStyle style(sStyleName);
					style.dbCreate(dThickness);
					if (style.bIsValid())
					{
						sStyleName = style.entryName();
						nAccept = 1;
						sStyleNames.append(sStyleName);
						nStyleName = sStyleNames.find(sStyleName);
					}
				}
				
				
		
			// convert by valid style 
				if (nAccept>0)
				{
					String strScriptName = strPanelCreateTsl ; // name of the script
					Vector3d vecUcsX = _XW;
					Vector3d vecUcsY = _YW;
					Beam lstBeams[0];
					Element lstElements[0];
					Point3d ptAr[0];
					Map mapTsl;
					
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
					
					lstBeams.append(bm); 
					if (nStyleName>-1)
						lstPropString.append(sStyleNames[nStyleName]);
					
					mapTsl.setEntity("mainSolid", entSolid);
					if (e==0)mapTsl.setEntity("bodyImporter", _ThisInst);// keep the reference to the bodyimporter such that the converter can erase the entity when conversion is accepted
					
					if (mapMeta.length()>0)
						mapTsl.setMap("metaData",mapMeta);
					ptAr.append(bd.ptCen());
					
					TslInst tsl;
					tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstElements, ptAr, 
						lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl); // create new instance
		
					if (tsl.bIsValid())
					{
						tsl.setPropValuesFromCatalog(T("|_LastInserted|"));
						if (nStyleName>-1)
							tsl.setPropString(0,sStyleNames[nStyleName]);				
					// set acceptance flag
						if (nAccept==1)
						{
							Map map = tsl.map();
							map.setInt("ConversionAccepted", nAccept==1?true:false);
							tsl.setMap(map);
							bSuccess=true;
						}
					}
				}// end if valid style found
				else
				{
					reportMessage("\n" + T("|Could not find any matching panel style.|"));
					bm.dbErase();
				}
		
				if (bSuccess)
				{
				// erase if in full conversion mode	
					if (e==0)
					{ 
						eraseInstance();
						return;						
					}

				}
			// conversion attempt has failed, set information color	
				else
				{
					_ThisInst.setColor(1);
				}
			}// end if create sip



		}//next i
		
		
	}

// assign meta data to beam and sheet
	if (gb.bIsValid())
	{
	// name assignment
		if (mapMeta.hasString("Name"))gb.setName(mapMeta.getString("Name"));
	// material assignment
		if (mapMeta.hasString("Material"))gb.setMaterial(mapMeta.getString("Material"));
	// label assignment
		if (mapMeta.hasString("Label"))gb.setLabel(mapMeta.getString("Label"));
	// SubLabel assignment
		if (mapMeta.hasString("SubLabel"))gb.setSubLabel(mapMeta.getString("SubLabel"));
	// SubLabel2 assignment
		if (mapMeta.hasString("SubLabel2"))gb.setSubLabel2(mapMeta.getString("SubLabel2"));
	// grade assignment
		if (mapMeta.hasString("Grade"))gb.setGrade(mapMeta.getString("Grade"));		
	// information assignment
		if (mapMeta.hasString("Information"))gb.setInformation(mapMeta.getString("Information"));	
	
	
		if(el.bIsValid())
		{
			gb.assignToElementGroup(el, true,_ThisInst.myZoneIndex(),'Z');
		}
		
		
	// erase bodyImporter if conversion solid matches importer solid
		double d = gb.solidLength();// make sure the solid is valid		
		Body bdGb = gb.realBody();
		Point3d pts1[] = bd.allVertices();
		Point3d pts2[] = bdGb.allVertices();
		
		int bOk;
		if (pts1.length()==pts2.length() && pts1.length()>0)
		{
			bOk=true;
			for (int i=0 ; i < pts1.length() ; i++) 
			{ 
				int bMatch;
			    Point3d pt1 = pts1[i]; 
			    for (int j=0 ; j< pts2.length() ; j++) 
			    {
			   		if (Vector3d(pts1[i]-pts2[j]).length()<dEps)
			    	{
			    		bMatch=true;
			    		break;
			    	}
			    }
			    if (!bMatch)
			    {
			    	bOk=false;
			    	break;
			    }
			}
		}
	// conversion succeeded
		if (bOk)
		{
			reportMessage("\n" + scriptName() + ": " +T("|succesful|"));
			eraseInstance();
			return;		
		}
	// conversion has mismatches	
		else
		{
			reportMessage("\n" + scriptName() + ": " +T("|Conversion has mismatches|"));		
			_ThisInst.setColor(1);
		}		
	}

// standard display
	Display dp(-1);
	double dTxtH = U(30);
	dp.textHeight(dTxtH);
	dp.draw(bd);
	
// collect values to be displayed
	String sValues[0], sKeys[0];	
	if (bHasBody)
	{
		sKeys.append(T("|Length|"));	sValues.append(dX);
		sKeys.append(T("|Width|"));		sValues.append(dY);
		sKeys.append(T("|Height|"));	sValues.append(dZ);	
	}
	else
	{ 
		dp.color(1);
		dp.draw(PLine(_Pt0, _Pt0+U(100)*(_XE+_YE+_ZE))); // just draw a small line segment as well
		sKeys.append(T("|Warning|"));	sValues.append(T("|Import failed|") + " " + kBody);
		sKeys.append(T("|GUID|"));	sValues.append(guid);
	}
	for (int i=0 ; i < mapMeta.length() ; i++) 
	{ 
	    String key = mapMeta.keyAt(i); 
	    String value;
	    if (mapMeta.hasInt(i))
	    	value = mapMeta.getInt(i);
	    else if (mapMeta.hasDouble(i))
	    	value = mapMeta.getDouble(i);
	    else
	    	value = mapMeta.getString(i); 
	    if(value.length()>0)
	    {
	    	sKeys.append(key);
	    	sValues.append(value);
	    }
	}
	
// draw potential meta data
    bd.transformBy(-_Pt0);
    Point3d pt = bd.ptCen();
    pt += _Pt0;
    pt.vis(5);		
	if (_bOnDbCreated)
		_Pt0 = pt;	
	
	double dYFlag = sValues.length()/2*3;
	for (int i=0 ; i < sValues.length() ; i++) 
	{ 
    	dp.draw(sKeys[i]+": " + sValues[i], pt,vecX,vecY,1,dYFlag,_kDeviceX);
	    dYFlag-=3;	
	}	
	
	if (bHasBody)
	{	
	// trigger addTool
		String sTriggerAddTool = T("|Add Tool|");
		if (bDebug)addRecalcTrigger(_kContextRoot, sTriggerAddTool );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddTool)
		{
		// the bounding box Body
			Body bdBounding(bd.ptCen(),vecX, vecY, vecZ, bd.lengthInDirection(vecX),bd.lengthInDirection(vecY), bd.lengthInDirection(vecZ), 0,0,0);
			
		
		// prompt for polylines
			Entity ents[0];
			PrEntity ssE(T("|Select solid tool(s)"), Entity());
		  	if (ssE.go())
				ents.append(ssE.set());
			for (int i=0 ; i < ents.length() ; i++) 
			{ 
			    Entity ent = ents[i]; 
			    Body bdTool = ent.realBody();
			    if (bdTool.volume()>pow(U(1),3) && bdTool.hasIntersection(bdBounding))
			    	_Entity.append(ent);
			}	
			setExecutionLoops(2);
		}
	}



// triggers to visualize orignal body & bad faces
	String sTriggerVisualizeOriginalBody = T("|Visualize original body|");
	addRecalcTrigger(_kContextRoot, sTriggerVisualizeOriginalBody );

	if (_bOnRecalc && _kExecuteKey==sTriggerVisualizeOriginalBody) 
	{		
		dp.color(3);
		PlaneProfile profiles[] = mapSource.getBodyAsPlaneProfilesList(kBody);
		for(int p = 0; p < profiles.length(); p++)
			dp.draw(profiles[p]);
		return;
	}
	
	
	int bHasBadFace;
	for (int i = 0; i < mapSource.length(); ++i)
	{ 
		String keyName = mapSource.keyAt(i);
		if (keyName == "BadFace")
		{ 
			bHasBadFace = true;
			break;
		}
	}
	String sTriggerVisualizeBadFaces = T("|Visualize bad faces|");
	if (bHasBadFace)
		addRecalcTrigger(_kContextRoot, sTriggerVisualizeBadFaces );
	if (_bOnRecalc && _kExecuteKey==sTriggerVisualizeBadFaces) 
	{
		dp.color(1);
		for (int i = 0; i < mapSource.length(); ++i)
		{
			String keyName = mapSource.keyAt(i);
			if (keyName == "BadFace")
			{
				PlaneProfile planeProfile = mapSource.getPlaneProfile(i);
				dp.draw(planeProfile);
			}
		}
		return;
	}









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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14123 supports plugInGroup extension and default import, new command to create basic panel" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="12/9/2021 4:22:36 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End