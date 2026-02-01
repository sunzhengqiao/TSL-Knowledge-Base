#Version 8
#BeginDescription
version value="1.0" date="18aug2020" author="geoffroy.cenni@hsbcad.com"> initial
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords screw catalog;Tie Down;
#BeginContents
/// <History>//region
/// <version value="1.0" date="18aug2020" author="geoffroy.cenni@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TieDown" "Mitek?StudLok")) TSLCONTENT

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
	String sDisabled = T("<|Disabled|>");
	String k;
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="ScrewCatalog";
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
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}		
//End Settings//endregion

//region Read Settings
	String sManufacturers[0];
	{
		Map m,mapManufacturers= mapSetting.getMap("Manufacturer[]");
		for (int i=0;i<mapManufacturers.length();i++) 
		{ 
			m = mapManufacturers.getMap(i); 
			String manufacturer;
			k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
			if (manufacturer.length()>0 && sManufacturers.findNoCase(manufacturer,-1)<0)
				sManufacturers.append(manufacturer);
		}//next i
	}
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
//End Read Settings//endregion 

//region Properties
	category = T("|Filter|");
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	sPainters.insertAt(0, sDisabled);
	String sPainterName=T("|Painter|");	
	PropString sPainter(nStringIndex++, sPainters, sPainterName);	
	sPainter.setDescription(T("|A filter which will use painter definitions|"));
	sPainter.setCategory(category);	
	
	String sScrewAngledName=T("|Is Angled|");	
	PropString sScrewAngled(nStringIndex++, sNoYes, sScrewAngledName, 0);	
	sScrewAngled.setDescription(T("|Defines if the Screw is angled or perpendicular|"));
	sScrewAngled.setCategory(T("|Rotation|"));

	category = T("|General|");
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);	
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);	

	String sFamilies[0];
	String sFamilyName=T("|Family|");	
	int nIndexFamily = nStringIndex++;

	String sLengthName=T("|Length|");	
	int nIndexLength = nDoubleIndex++;
	double dLengths[0];
	
	String sMaterials[0];
	String sMaterial;
	
	String sURLs[0];
	String sURL;
	
	String sArticleNumbers[0];
	String sArticleNumber;
	
	String sDescriptions[0];
	String sDescription;
	
	int iColors[0];
	int iColor;
	
	double dThreadDiameters[0];
	double dThreadDiameter;
	
	double dHeadDiameters[0];
	double dHeadDiameter;
	
	double dHeadLengths[0];
	double dHeadLength;
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// tokens given by the executeKey to preselect manufacturer and family	
		String sTokens[] = _kExecuteKey.tokenize("?");
		int bHasToken = sTokens.length() > 0;

		Map m,mapManufacturer,mapFamilies, mapFamily;
		int n = -1;
		if (bHasToken)n=sManufacturers.findNoCase(sTokens.first() ,- 1);
		int bManufacturerIsValid = bHasToken && sTokens.length()>0 && n>-1 && sManufacturers[n].length()==sTokens.first().length();

	// manufacturer given by token entry
		if (bManufacturerIsValid)
		{		
			sManufacturer.set(sManufacturers[n]);
			//reportNotice("\nManufacturer set to " + sManufacturer);
		}
	// prompt user to select the manufacturer	
		else
		{ 
			//setOPMKey("SelectManufacturer");
			if(sManufacturers.length() > 1) showDialog();				
			if(sManufacturers.length() == 1) sManufacturer.set(sManufacturers[0]);
		}

	//region collect families of this manufacturer
		Map mapManufacturers;
		mapManufacturers= mapSetting.getMap("Manufacturer[]");
		for (int i=0;i<mapManufacturers.length();i++) 
		{ 
			m = mapManufacturers.getMap(i); 
			String manufacturer;
			k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
			
			if (sManufacturer==manufacturer)
			{ 
				mapManufacturer = m;
				k="Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);
				for (int j=0;j<mapFamilies.length();j++) 
				{ 
					m = mapFamilies.getMap(j); 
					String name;
					k="Name";		if (m.hasString(k))	name = m.getString(k);
					
					if (name.length()>0 && sFamilies.findNoCase(name,-1)<0)
					{
						sFamilies.append(name);
					}
					
				}//next j
				break;
			}	
		}//next i				
	//End collect families of this manufacturer//endregion 

		category = T("|Product|");
		if(sManufacturers.length() > 1) sManufacturer.setReadOnly(true);
		PropString sFamily(nIndexFamily, sFamilies, sFamilyName);

	// family given by token entry
		int bFamilyIsValid = sTokens.length()>1 && sFamilies.findNoCase(sTokens[1],-1)>-1;
		if (bFamilyIsValid)
		{
			int n = sFamilies.findNoCase(sTokens[1] ,- 1);
			sFamily.set(sFamilies[n]);
			//reportNotice("\nsFamily set to " + sFamily);
		}
		else
		{ 
			//setOPMKey("SelectFamily");
			if(sFamilies.length() > 1) showDialog();				
			if(sFamilies.length() == 1) sFamily.set(sFamilies[0]);
		}

	//region collect products of this family
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			m = mapFamilies.getMap(i);
			String family;
			k = "Name";		if (m.hasString(k))	family = m.getString(k);

			if (sFamily == family)
			{
				mapFamily = m;
				Map mapProducts;
				k="Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
				
				for (int j=0;j<mapProducts.length();j++) 
				{ 
					double length;
					m = mapProducts.getMap(j); // getting the product by index
					k="Length";		if (m.hasDouble(k))	length = m.getDouble(k);
					if (length>0 && dLengths.find(length)<0)
						dLengths.append(length);
				}//next j
				
				
				break;
			}
		}
	//endregion 
		if(sFamilies.length() > 1) sFamily.setReadOnly(true);
		//setOPMKey("");
		PropDouble dLength(nIndexLength, dLengths, sLengthName);
		showDialog("---");


	//region Selection
	// default prompt for walls
		Entity ents[0];
		PrEntity ssE(T("|Select wall(s) and truss(es)|"), ElementWallSF());
		ssE.addAllowedClass(TrussEntity());
		if (ssE.go())
			ents.append(ssE.set());
		
		ElementWallSF Walls[0];
		TrussEntity Trusses[0];
			
		for (int i=0;i<ents.length();i++) 
		{ 
			ElementWallSF wall = (ElementWallSF)ents[i];
			if ( wall.bIsValid())  Walls.append(wall);
			
			TrussEntity truss = (TrussEntity)ents[i];
			if ( truss.bIsValid())  Trusses.append(truss);
		}//next i
		
		if (Walls.length() < 1 || Trusses.length() < 1)
		{ 
			_Beam.append(getBeam(T("|Select Truss beam|")));
			_Beam.append(getBeam(T("|Select Wall beam|")));
		}
		else
		{ 
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[2];				Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={dLength};		String sProps[]={sPainter, sScrewAngled, sManufacturer, sFamily};
			Map mapTsl;	
			mapTsl.setInt("mode", 1); // 0 = beam/beam, 1 = element	truss/wall		
				
			//Loop through all walls	
			for (int i = 0; i < Walls.length(); i++)
			{
				entsTsl[0] = Walls[i];
				
				//Loop through all trusses
				for (int j = 0; j < Trusses.length(); j++)
				{
					entsTsl[1] = Trusses[j];
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				}
				 
			}//next i
			eraseInstance();
		}
		
		
	//End Selection//endregion 

		if (bDebug)_Pt0 = getPoint();
		
		return;
	}	
// end on insert	__________________//endregion

//region adding Properties
	Map m,mapManufacturer,mapFamilies, mapFamily;
	Map mapManufacturers;
	mapManufacturers= mapSetting.getMap("Manufacturer[]");
	for (int i=0;i<mapManufacturers.length();i++) 
	{ 
		m = mapManufacturers.getMap(i); 
		String manufacturer;
		k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
		
		if (sManufacturer==manufacturer)
		{ 
			mapManufacturer = m;
			k="Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);		
			
			for (int j=0;j<mapFamilies.length();j++) 
			{ 
				m = mapFamilies.getMap(j); 
				String name;
				k="Name";		if (m.hasString(k))	name = m.getString(k);
				
				if (name.length()>0 && sFamilies.findNoCase(name,-1)<0)
					sFamilies.append(name);
			}//next j
			break;
		}	
	}//next i
		
	sManufacturer.setReadOnly(true);
	
	PropString sFamily(nIndexFamily, sFamilies, sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	sFamily.setReadOnly(true);
	setOPMKey(sFamily);
	for (int i = 0; i < mapFamilies.length(); i++)
	{
		m = mapFamilies.getMap(i);
		String family;
		k = "Name";		if (m.hasString(k))	family = m.getString(k);

		if (sFamily == family)
		{
			Map mapProducts;
			k="Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
			
			for (int j=0;j<mapProducts.length();j++) 
			{ 
				double length;
				Map m2 = mapProducts.getMap(j); // getting the product by index
				k="Length";				if (m2.hasDouble(k))	length = m2.getDouble(k);
				
				if (length>0 && dLengths.find(length)<0)
				{
					double dTempHeadDia, dTempThreadDia, dTempHeadLength;
					k = "Diameter Thread";	if(m.hasDouble(k)) dTempThreadDia = m.getDouble(k);
					k = "Diameter Head";	if(m.hasDouble(k)) dTempHeadDia = m.getDouble(k);
					k = "Length Head";		if(m.hasDouble(k)) dTempHeadLength = m.getDouble(k);
					if (dTempHeadDia == 0 || dTempThreadDia == 0 || dTempHeadLength == 0) continue;
					dThreadDiameters.append(dTempThreadDia);
					dHeadDiameters.append(dTempHeadDia);
					dHeadLengths.append(dTempHeadLength);
					
					dLengths.append(length);
					k = "Material";			sMaterials.append(m.hasString(k) ? m.getString(k) : "");
					k = "url";				sURLs.append(m.hasString(k) ? m.getString(k) : "");
					k = "ArticleNumber";	sArticleNumbers.append(m2.hasString(k) ? m2.getString(k) : "");
					k = "Description";		sDescriptions.append(m2.hasString(k) ? m2.getString(k) : "");
					k = "Color";			iColors.append(m2.hasInt(k) ? m2.getInt(k) : 252);
				}
			}//next j
			
			break;
		}
	}	
	
	PropDouble dLength(nIndexLength, dLengths, sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);
//endregion	

	int iProductIndex = dLengths.find(dLength);
	sMaterial = sMaterials[iProductIndex];
	sURL = sURLs[iProductIndex];
	_ThisInst.setHyperlink(sURL);
	sArticleNumber = sArticleNumbers[iProductIndex];
	sDescription = sDescriptions[iProductIndex];
	iColor = iColors[iProductIndex];
	dThreadDiameter = dThreadDiameters[iProductIndex];
	dHeadDiameter = dHeadDiameters[iProductIndex];
	dHeadLength = dHeadLengths[iProductIndex];

// get mode
	int nMode = _Map.getInt("mode"); // 0 = beam/beam, 1 = element	
	PainterDefinition painter;
	int nPainter = sPainters.find(sPainter);
	if (nPainter>0)
		painter = PainterDefinition(sPainter);
	
// beam/beam
	if (nMode==0)
	{ 
		TrussEntity truss;
		Element el;
		if(_Entity.length() > 0 )
		{ 
			truss = (TrussEntity)_Entity[0];
			el = (Element)_Entity[1];
		}
		
		if(truss.bIsValid() && _Beam.length() <1)
		{
			reportMessage("\n" + scriptName() + ": " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		if(!truss.bIsValid() && _Beam.length() <2)
		{
			reportMessage("\n" + scriptName() + ": " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		
		Vector3d vecXC, vecYC, vecZC;
		Vector3d vecY, vecX , vecZ;
		Point3d ptCommonCen, ptConnection;
		Beam bmsWallIS[0], bmsWallFemales[0];
		PlaneProfile ppCommon;
		Vector3d vecXS, vecYS, vecZS;
		Entity etools[0];
		
		if(truss.bIsValid() && el.bIsValid())
		{ 
			// set dependency and group assignment
			setDependencyOnEntity(el);
			assignToGroups(el, 'I');
			
			//Get vectors
			CoordSys csTruss = truss.coordSys();
			Vector3d vecYT = csTruss.vecY();
			Vector3d vecXT = csTruss.vecX();
			Vector3d vecZT = csTruss.vecZ();
			vecY = el.vecY();
			vecX = el.vecX();
			vecZ = el.vecZ();
			
			//Visualize vecs
			vecYT.vis(csTruss.ptOrg(), 1);
			vecXT.vis(csTruss.ptOrg(), 3);
			vecZT.vis(csTruss.ptOrg(), 140);
			vecY.vis(el.ptOrg(), 1);
			vecX.vis(el.ptOrg(), 3);
			vecZ.vis(el.ptOrg(), 140);
			
			//Get common profile intersection
			PlaneProfile ppWall(el.plOutlineWall());
			Body bdTruss = truss.realBody();
			PlaneProfile ppTruss = bdTruss.shadowProfile(Plane(el.ptOrg(), vecY ));
			ppCommon = ppWall;
			ppCommon.intersectWith(ppTruss);
			
			//Get Top and Bottom point Wall/Truss
			Body bdWall = el.realBody();
			Point3d ptsWall[] = bdWall.allVertices();
			Point3d ptWallTop = ptsWall[0];
			Point3d ptWallBottom = ptsWall[0];
			for (int i = 0; i < ptsWall.length(); i++)
			{
				Point3d pt = ptsWall[i];
				if (pt.Z() > ptWallTop.Z()) ptWallTop = pt;
				if (pt.Z() < ptWallBottom.Z()) ptWallBottom = pt;
			}//next i
			Point3d ptsTruss[] = bdTruss.allVertices();
			Point3d ptTrussTop = ptsTruss[0];
			Point3d ptTrussBottom = ptsTruss[0];
			for (int i = 0; i < ptsTruss.length(); i++)
			{
				Point3d pt = ptsTruss[i];
				if (pt.Z() > ptTrussTop.Z()) ptTrussTop = pt;
				if (pt.Z() < ptTrussBottom.Z()) ptTrussBottom = pt;
			}//next i
			
			//Get all beams in wall & truss
			Beam bmsWall[] = el.beam();
			
			//Common center point on top of wall
			ptCommonCen = ppCommon.ptMid() + vecY * vecY.dotProduct(ptWallTop - ppCommon.ptMid());
//ptCommonCen.vis(6);
			
			//Set Intersect body for screw
			Body bdTest(ptCommonCen, vecX, vecZ, vecY, ppCommon.dX(), ppCommon.dY(), dLength, 0, 0, 0);
bdTest.vis(6);
	
			//Get all intersection wall beams
			bmsWallIS = bdTest.filterGenBeamsIntersect(bmsWall);
			bmsWallFemales = vecY.filterBeamsPerpendicularSort(bmsWallIS);
			
			vecXC = bmsWallFemales[0].vecD(ptCommonCen -csTruss.ptOrg());
			vecYC = vecXC.crossProduct(-_ZW);
			vecZC = _ZW;
			
			etools = bmsWallFemales[0].eToolsConnected();
		}
		else if (_Beam.length() == 2)
		{
			//return;
			Beam bmFemale = _Beam0; //Truss
			Beam bmMale = _Beam1; //Wall
			
			// set dependency and group assignment
			setDependencyOnEntity(bmMale);
			assignToGroups(bmMale, 'I');
			
			etools = bmMale.eToolsConnected();
			
			Vector3d vecYT = bmFemale.vecY();
			Vector3d vecXT = bmFemale.vecX();
			Vector3d vecZT = bmFemale.vecZ();
			vecY = bmMale.vecY();
			vecX = bmMale.vecX();
			vecZ = bmMale.vecZ();	
		
			//Get common profile intersection
			Body bdWall = bmMale.realBody();
			PlaneProfile ppWall = bdWall.shadowProfile(Plane(bmMale.ptRef(), vecY ));
//ppWall.vis(6);
			double dWallPP = ppWall.area();
			Body bdTruss = bmFemale.realBody();
			PlaneProfile ppTruss = bdTruss.shadowProfile(Plane(bmMale.ptRef(), vecY ));
//ppTruss.vis(6);
			double dTrussPP = ppTruss.area();
			ppCommon = ppWall;
			ppCommon.intersectWith(ppTruss);
			
			//Check if common profile is valid
			if(ppCommon.area() < pow(dEps,2))
			{ 
				eraseInstance();
				return;
			}
			ppCommon.vis(6);	
			
			//Get Top and Bottom point Wall/Truss
			Point3d ptsWall[] = bdWall.allVertices();
			Point3d ptWallTop = ptsWall[0];
			Point3d ptWallBottom = ptsWall[0];
			for (int i=0;i<ptsWall.length();i++) 
			{ 
				Point3d pt = ptsWall[i]; 
				if(pt.Z() > ptWallTop.Z()) ptWallTop = pt;
				if(pt.Z() < ptWallBottom.Z()) ptWallBottom = pt; 
			}//next i
			Point3d ptsTruss[] = bdTruss.allVertices();
			Point3d ptTrussTop = ptsTruss[0];
			Point3d ptTrussBottom = ptsTruss[0];
			for (int i=0;i<ptsTruss.length();i++) 
			{ 
				Point3d pt = ptsTruss[i]; 
				if(pt.Z() > ptTrussTop.Z()) ptTrussTop = pt;
				if(pt.Z() < ptTrussBottom.Z()) ptTrussBottom = pt; 
			}//next i
			
//ptTrussBottom.vis(6);
//ptWallTop.vis(6);
			
			//Check Z distance between Wall and truss
			if(abs(vecY.dotProduct(ptTrussBottom - ptWallTop)) > dEps)
			{ 
				eraseInstance();
				return;
			}
			
		//Get all beams in wall & truss
			Beam bmsWall[0];
			bmsWall.append(bmMale);
			
			//Common center point on top of wall
			ptCommonCen = ppCommon.ptMid() + vecY * vecY.dotProduct(ptWallTop - ppCommon.ptMid());
			ptCommonCen.vis(6);
			
			//Set Intersect body for screw
			Body bdTest(ptCommonCen, vecX, vecZ, vecY, ppCommon.dX(), ppCommon.dY(), dLength*2, 0, 0, 0);
			bdTest.vis(6);
	
			//Get all intersection wall beams
			bmsWallIS = bdTest.filterGenBeamsIntersect(bmsWall);
			
			//Visualize
			for (int j=0;j<bmsWallIS.length();j++) 
			{ 
				Beam bm = bmsWallIS[j]; 
				bm.realBody().vis(j); 
				
			}//next j
	
			vecXC = bmsWallIS[0].vecD(ptCommonCen -bmFemale.ptRef());
			vecYC = vecXC.crossProduct(-_ZW);
			vecZC = _ZW;
			
			
			vecXT = bmMale.vecX();
			Point3d pt;
			int bOK = Line(bmMale.ptCen(), vecXT).hasIntersection(Plane(bmFemale.ptCen(), bmFemale.vecD(vecXT)), pt);
			if ( ! bOK)
			{
				reportMessage("\n" + scriptName() + ": " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}
			
			if (vecXT.dotProduct(pt - bmMale.ptCen()) < 0)
			{
				vecXT = - vecXT;
			}
			double dDiameter = U(8);
			bOK = Line(bmMale.ptCen(), vecXT).hasIntersection(Plane(bmFemale.ptCen() + bmFemale.vecD(vecXT) * .5 * bmFemale.dD(vecXT), bmFemale.vecD(vecXT)), pt);
			_Pt0 = pt;
		}
		else
		{ 
			reportMessage("\n" + scriptName() + ": " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
			
		{
			//Point3d pt
			vecXC.vis(ptCommonCen, 1);
			vecYC.vis(ptCommonCen, 3);
			vecZC.vis(ptCommonCen, 160);
			
			//Get Max Female beams and if there is an vertical
			double dHeightBeamsVert = 0;
			int bHasVertical = 0;
			for (int j=0;j<bmsWallIS.length();j++) 
			{ 
				Beam bm = bmsWallIS[j]; 
				if(bm.vecY().isParallelTo(vecYC))
				{ 
					Vector3d vecBMWall = bm.vecY();
					vecBMWall.vis(ptCommonCen, 6);
					bm.realBody().vis(j);
					bHasVertical = 1;
				}
				else
				{ 
					double dvecx = bm.dD(vecXC);
					double dvecy = bm.dD(vecYC);
					double dvecz = bm.dD(vecZC);
					
					dHeightBeamsVert += bm.dD(vecZC);
				}
			}//next jfm
			
			vecXS = vecXC;
			vecYS = vecYC;
			vecZS = vecZC;		
	
			//User Input
			double dOffsetVert = 90;
			double dOffsetHor = 0;
			int bIsAngled = sNoYes.find(sScrewAngled);
			
			//Technical rules
			double dMaxOffsetVert = 76;
			double dMaxDistSide = 3.5;
			double dAngle = 22.5;
			
			//Calc
			dMaxOffsetVert = dHeightBeamsVert < dMaxOffsetVert ? dHeightBeamsVert : dMaxOffsetVert;
			dMaxOffsetVert = dMaxOffsetVert < dOffsetVert ? dMaxOffsetVert : dOffsetVert;
			double dMaxOffsetHor = ppCommon.dX() / 2 - dMaxDistSide;
			dOffsetHor = dOffsetHor > dMaxOffsetHor ? dMaxOffsetHor : ( dOffsetHor < - dMaxOffsetHor ? - dMaxOffsetHor : dOffsetHor );
			bIsAngled = bHasVertical ? 1 : bIsAngled;
			if(bHasVertical)
			{ 
				sScrewAngled.set(T("|Yes|"));
			}
			if(bIsAngled)
			{
				ptConnection = ptCommonCen - vecXS * ppCommon.dY() *.5 - vecZS * dMaxOffsetVert - vecYS * dOffsetHor;
				vecZS = vecZS.rotateBy(-90 + dAngle, vecYS);
				vecXS = vecYS.crossProduct(vecZS);
			}
			else
			{ 
				ptConnection = ptCommonCen - vecYS * dOffsetHor - vecZS * dHeightBeamsVert;
				vecZS = vecZS.rotateBy(-90, vecYS);
				vecXS = vecYS.crossProduct(vecZS);
				
				//point below hor beam?
			}
	
			//Point3d pt
			vecXS.vis(ptConnection, 1);
			vecYS.vis(ptConnection, 3);
			vecZS.vis(ptConnection, 160);
			
			//Place screw
			
		}
		
		
		{
			Point3d pt = ptConnection;
			Vector3d vecXT = vecXS;
			
			int bIsScrewSunk = 1;
			int bIsHeadIncludedInThreadLength = 1;
			
			Point3d ptHeadBottom = bIsScrewSunk ? pt : pt - vecXS * dHeadLength;
			Point3d ptThreadTop = bIsScrewSunk ? pt + vecXS * dHeadLength : pt;
			Point3d ptThreadBottom = bIsHeadIncludedInThreadLength ? ptThreadTop + vecXT * (dLength - dHeadLength) : ptThreadTop + vecXT * dLength;
			ptHeadBottom.vis(6);
			ptThreadTop.vis(6);
			ptThreadBottom.vis(6);
			
//			//Check if thread length can reach the post
//			double dMaleHeight = bmMale.dL();
//			double dDistanceToPost = vecXT.dotProduct(ptThreadTop - bmMale.ptCen()) - bmMale.dL() * .5;
//			if (dDistanceToPost > dLength)
//			{
//				eraseInstance();
//				return;
//			}
//			
			//Check if tool has already been implemented on same location
			//Entity etools[] = bmMale.eToolsConnected();

			//return;
//			for (int i = 0; i < etools.length(); i++)
//			{
//				TslInst tsl = (TslInst)etools[i];
//				String temp = tsl.scriptName();
//				if ( ! tsl.bIsValid() || _ThisInst == tsl) continue;
//				if (_ThisInst.ptOrg() == tsl.ptOrg())
//				{
//					eraseInstance();
//					return;
//				}
//			}//next i
			
			Body bdThread(ptThreadTop, ptThreadBottom, dThreadDiameter);
			bdThread.vis(6);
			
			Display dp(252);
			dp.draw(bdThread);
			
			Body bdHead(ptHeadBottom, ptThreadTop, dHeadDiameter);
			bdHead.vis(6);
			
			dp.color(iColor); //default 252
			dp.draw(bdHead);
		}
	
	// Hardware//region
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
			Element elHW =_ThisInst.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)_ThisInst;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
		
	// add main componnent
		{ 
			HardWrComp hwc(sArticleNumber, 1); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sFamily);
			hwc.setName(sDescription);
			hwc.setDescription(sDescription);
			hwc.setMaterial(sMaterial);
			//hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_ThisInst);	
			hwc.setCategory(T("|Fixture|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dLength);
			hwc.setDScaleY(dThreadDiameter);
			//hwc.setDScaleZ(dHWHeight);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
		//endregion
	
	}
// element: find beam/beam relations in TRUSS & WALL
	else if (nMode==1)
	{ 
	// create TSL
	
		TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
		GenBeam gbsTsl[1];			Entity entsTsl[2];			Point3d ptsTsl[] = { };
		int nProps[] ={ };			double dProps[] ={ dLength};		String sProps[] ={ sPainter, sScrewAngled, sManufacturer, sFamily};
		Map mapTsl;
		
		//Get Wall
		if (_Element.length() < 0)
		{
			eraseInstance();
			return;
		}
		Element el = _Element[0];
		
		//Get Truss
		TrussEntity truss;
		for (int i = 0; i < _Entity.length(); i++)
		{
			TrussEntity _truss = (TrussEntity)_Entity[i];
			if (_truss.bIsValid())
			{
				truss = _truss;
				break;
			}
		}//next
		if ( ! truss.bIsValid())
		{
			eraseInstance();
			return;
		}
		
		//Get vectors
		CoordSys csTruss = truss.coordSys();
		Vector3d vecYT = csTruss.vecY();
		Vector3d vecXT = csTruss.vecX();
		Vector3d vecZT = csTruss.vecZ();
		Vector3d vecY = el.vecY();
		Vector3d vecX = el.vecX();
		Vector3d vecZ = el.vecZ();
		
		//Check if truss and wall are perpendicular
		if (vecX.isParallelTo(vecXT))
		{
			eraseInstance();
			return;
		}
		
		//Get common profile intersection
		PlaneProfile ppWall(el.plOutlineWall());
		Body bdTruss = truss.realBody();
		PlaneProfile ppTruss = bdTruss.shadowProfile(Plane(el.ptOrg(), vecY ));
		PlaneProfile ppCommon = ppWall;
		ppCommon.intersectWith(ppTruss);
		
		//Check if common profile is valid
		if (ppCommon.area() < pow(dEps, 2))
		{
			eraseInstance();
			return;
		}
		ppCommon.vis(6);
		
		//Get Top and Bottom point Wall/Truss
		Body bdWall = el.realBody();
		Point3d ptsWall[] = bdWall.allVertices();
		Point3d ptWallTop = ptsWall[0];
		Point3d ptWallBottom = ptsWall[0];
		for (int i = 0; i < ptsWall.length(); i++)
		{
			Point3d pt = ptsWall[i];
			if (pt.Z() > ptWallTop.Z()) ptWallTop = pt;
			if (pt.Z() < ptWallBottom.Z()) ptWallBottom = pt;
		}//next i
		Point3d ptsTruss[] = bdTruss.allVertices();
		Point3d ptTrussTop = ptsTruss[0];
		Point3d ptTrussBottom = ptsTruss[0];
		for (int i = 0; i < ptsTruss.length(); i++)
		{
			Point3d pt = ptsTruss[i];
			if (pt.Z() > ptTrussTop.Z()) ptTrussTop = pt;
			if (pt.Z() < ptTrussBottom.Z()) ptTrussBottom = pt;
		}//next i
		
		ptTrussBottom.vis(6);
		ptWallTop.vis(6);
		
		//Check Z distance between Wall and truss
		if (abs(vecY.dotProduct(ptTrussBottom - ptWallTop)) > dEps)
		{
			eraseInstance();
			return;
		}
		
//Get all beams in wall & truss
		Beam bmsWall[] = el.beam();
		
		//Common center point on top of wall
		Point3d ptCommonCen = ppCommon.ptMid() + vecY * vecY.dotProduct(ptWallTop - ppCommon.ptMid());
//ptCommonCen.vis(6);
		
		//Set Intersect body for screw
		Body bdTest(ptCommonCen, vecX, vecZ, vecY, ppCommon.dX(), ppCommon.dY(), dLength, 0, 0, 0);
//bdTest.vis(6);

		//Get all intersection wall beams
		Beam bmsWallIS[] = bdTest.filterGenBeamsIntersect(bmsWall);
		Beam bmsWallFemales[] = vecY.filterBeamsPerpendicularSort(bmsWallIS);
		
		if(bmsWallFemales.length() < 1)
		{ 
			if (bDebug) reportMessage("\nFailes on wall females filter");
			eraseInstance();
			return;
		}
				
		gbsTsl[0] = bmsWallFemales[0];
		entsTsl[0] = truss;
		entsTsl[1] = el;
		if ( ! bDebug) tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		eraseInstance();
		return;
	}
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
        <int nm="BREAKPOINT" vl="654" />
        <int nm="BREAKPOINT" vl="836" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End