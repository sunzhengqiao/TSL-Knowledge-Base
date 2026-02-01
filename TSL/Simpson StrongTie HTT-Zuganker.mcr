#Version 8
#BeginDescription
#Versions
2.3 12.12.2023 HSB-20886: Modifications of Markus should only be valid for special Baufritz 
2.2 25.10.2021 HSB-13634 Fix hardware, 
Version 2.1 22.09.2021 HSB-13238 new properties for element format display and fixture , Author Thorsten Huck

version value="2.0" date="14sep2018" author="thorsten.huck@hsbcad.com"
Verbindungsmittel ergänzt
Konturübergabe hsbCNC


DACH
Dieses TSL erzeugt Zuganker vom Typ Simpson StrongTie HTT


EN
This tsl creates anchors the type Simpson StrongTie HTT


#End
#Type O
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords Simpson, Zuganker, Customer, Shareware
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt Zuganker vom Typ Simpson StrongTie HTT
/// </summary>

/// <summary Lang=en>
/// This tsl creates anchors the type Simpson StrongTie HTT
/// </summary>

/// <insert Lang=en>
/// Select 1 or more beams
/// </insert>

/// History
// #Versions
// 2.3 12.12.2023 HSB-20886: Modifications of Markus should only be valid for special Baufritz Author: Marsel Nakuci
// 2.2 25.10.2021 HSB-13634 Fix hardware, Author Marsel Nakuci
// 2.1 22.09.2021 HSB-13238 new properties for element format display and fixture , Author Thorsten Huck
///<version value="2.0" date="14sep2018" author="thorsten.huck@hsbcad.com"> Verbindungsmittel ergänzt </version>
///<version value="1.9" date="13sep2018" author="thorsten.huck@hsbcad.com"> Unterscheidung Holz / Beton, neue Eigenschaft </version>
///<version value="1.8" date="05apr16" author="thorsten.huck@hsbcad.com"> Konturübergabe hsbCNC </version>
///<version value="1.7" date="16mar16" author="thorsten.huck@hsbcad.com"> bugfix Lage in Multiwand </version>
///<version value="1.6" date="21apr15" author="th@hsbCAD.de"> spell correction </version>
///<version value="1.5" date="27feb15" author="th@hsbCAD.de"> bugfix Objektlayer (E) </version>
///<version value="1.4" date="27feb15" author="th@hsbCAD.de"> Benutzerdefinierte Darstellung zusätzlich in Zone 5 auf Wandinfo-Layer  </version>
///<version value="1.3" date="26feb15" author="th@hsbCAD.de"> Benutzerdefinierte Darstellung ergänzt </version>
///<version value="1.2" date="26feb15" author="th@hsbCAD.de"> CNC Kontur in erster Zone der Installtionsseite veröffentlicht </version>
///<version value="1.1" date="26feb15" author="th@hsbCAD.de"> Layout und doppelter Zuganker </version>
///<version value="1.0" date="25feb15" author="th@hsbCAD.de"> initial </version>


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

	String sSpecials[] = {"BAUFRITZ", "RUB"}; // declare a list of supported specials. specials might change behaviour and available properties
	int nSpecial = sSpecials.find(projectSpecial().makeUpper());

//end Constants//endregion

// categories
	String sCategoryTooling=T("|Tooling|");	
	String sCategoryDescription=T("|Description|");	

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="FixtureDefinition";
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

//region Read Settings
	Map mapFixings;
	String sFixings[0], sAllFixings[0];
{
	String k;
	mapFixings = mapSetting.getMap("Fixture[]");
	
	for (int i = 0; i < mapFixings.length(); i++)
	{
		Map m = mapFixings.getMap(i);
		Map mapApps = m.getMap("Application[]");
		
	// get the list where this fixture is applicable to	
		String apps[0];
		for (int i=0;i<mapApps.length();i++)
		{
			String app = mapApps.getString(i);
			if (app.length()>-1 && apps.findNoCase(app,-1)<0)
				apps.append(app);
		}	
		String script = bDebug?"Simpson StrongTie HTT-Zuganker":scriptName();
		int bAllowed = apps.findNoCase(script ,- 1) >- 1;
		
		String name = m.getMapName();
		if (name.length() > 0 && sFixings.findNoCase(name ,- 1) < 0)
		{
			if (bAllowed)
				sFixings.append(name);
			sAllFixings.append(name);	
		}
	}//next i
}
// Fall back to defaults if no fixing settings could be found
	int bUseDefaultFixing = sFixings.length() < 1;
	
//End Read Settings//endregion 


//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
	// add/edit entry	
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey("EditFixing");

			String sArticleName=T("|Article|");	
			PropString sArticle(nStringIndex++, "", sArticleName);	
			sArticle.setDescription(T("|Defines the Article|"));
			sArticle.setCategory(category);
			
			String sManufacturerName=T("|Manufacturer|");	
			PropString sManufacturer(nStringIndex++, "", sManufacturerName);	
			sManufacturer.setDescription(T("|Defines the Manufacturer|"));
			sManufacturer.setCategory(category);
			
			String sDescriptionName=T("|Description|");	
			PropString sDescription(nStringIndex++, "", sDescriptionName);	
			sDescription.setDescription(T("|Defines the Description|"));
			sDescription.setCategory(category);
			
			String sCategoryName=T("|Category|");	
			PropString sCategory(nStringIndex++, "", sCategoryName);	
			sCategory.setDescription(T("|Defines the Category|"));
			sCategory.setCategory(category);
			
			String sModelName=T("|Model|");	
			PropString sModel(nStringIndex++, "", sModelName);	
			sModel.setDescription(T("|Defines the Model|"));
			sModel.setCategory(category);

		category = T("|Geometry|");
			String sScaleXName=T("|Scale X|");	
			PropDouble dScaleX(nDoubleIndex++, U(0), sScaleXName);	
			dScaleX.setDescription(T("|Defines the Scale X|"));
			dScaleX.setCategory(category);
			
			String sScaleYName=T("|Scale Y|");	
			PropDouble dScaleY(nDoubleIndex++, U(0), sScaleYName);	
			dScaleY.setDescription(T("|Defines the Scale Y|"));
			dScaleY.setCategory(category);
			
			String sScaleZName=T("|Scale Z|");	
			PropDouble dScaleZ(nDoubleIndex++, U(0), sScaleZName);	
			dScaleZ.setDescription(T("|Defines the Scale Z|"));
			dScaleZ.setCategory(category);
		}
	// delete entry	
		else if (nDialogMode == 2) //specify index when triggered to get different dialogs
		{
			setOPMKey("RemoveFixing");

			String sArticleName=T("|Article|");	
			PropString sArticle(nStringIndex++, sFixings, sArticleName);	
			sArticle.setDescription(T("|Select article to be removed|"));
			sArticle.setCategory(category);

		}	
	// tag entry to this script
		else if (nDialogMode == 3) //specify index when triggered to get different dialogs
		{
			setOPMKey("TagFixture");

			String sArticleName=T("|Article|");	
			PropString sArticle(nStringIndex++, sAllFixings, sArticleName);	
			sArticle.setDescription(T("|Select article to be tagged|"));
			sArticle.setCategory(category);

		}		
		return;		
	}
//End DialogMode//endregion


	
// geometry and types
	String sTypes[] = {"HTT5", "HTT22"};
	double dYs[]={U(64), U(64)};	// width
	double dXs[]={U(404), U(559)}; // height
	double dZs[]={U(62),U(62)}; // depth
	double dT1 = U(3), dT2=U(11);	
	double dX1 = U(170); // triangle shape
	
	
// properties
	String sTypeName= T("|Type|");
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	int nType = sTypes.find(sType);
	if (nType<0){ nType=0; sType.set(sTypes[nType]);}
	
	
	String sDepthName = T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, 0, sDepthName );		
	dDepth.setDescription(T("|Specifies the milling depth|"));
	dDepth.setCategory(sCategoryTooling);
	
	String sGapName = T("|Gap|");
	PropDouble dGap(nDoubleIndex++, 0, sGapName );		
	dGap.setDescription(T("|Specifies the gap of the milling in length and width|"));
	dGap.setCategory(sCategoryTooling);
	
	String sInterdistanceName = T("|Interdistance|");
	PropDouble dInterdistance(nDoubleIndex++, U(150), sInterdistanceName );		
	dInterdistance.setDescription(T("|Creates two anchors if the value is greater the anchor width with the given inter distance|"));
	dInterdistance.setCategory(category);

	String sFixingName=T("|Fixture|");	
	PropString sFixing(nStringIndex++, "", sFixingName);	
	if (sFixings.length()>0)
	{
		sFixing=PropString(nStringIndex-1, sFixings, sFixingName);
		int n = sFixings.find(sFixing);
		if (n<0){ n=0; sFixing.set(sFixings[n]);}
	}
	sFixing.setDescription(T("|Defines the Fixing|"));
	sFixing.setCategory(category);
	
category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
	
// HSB-20886:
	double dInterdistance1=dInterdistance;
	double dGap1=dGap;
		

// on insert
	if (_bOnInsert)
	{	
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		
		Beam beams[0];
		PrEntity ssB(T("|Select studs|"), Beam());
		if (ssB.go())
			beams= ssB.beamSet(); 
		
	// filter studs and get ref point
		Beam bmStuds[0];
		ElementWall el;
		Point3d ptRef;
		if (beams.length()>0)
		{
			Element e=beams[0].element();
			el=(ElementWall)e;
		}
	/// allow single insertion also not vertical
		if (beams.length()==1 && !el.bIsValid())
			bmStuds=beams;
		else if (el.bIsValid())
			bmStuds = el.vecX().filterBeamsPerpendicularSort(beams);
		else
			bmStuds = _XW.filterBeamsPerpendicularSort(beams);		
				
		if (bmStuds.length()<1)
		{	
			reportNotice("\n" + T("|Invalid selection|"));
			eraseInstance();
			return;
		}
		else
		{
			Element e =  bmStuds[0].element();
			el = (ElementWall)e;	
		}

	// declare the tsl props of the tls
		TslInst tslNew;
		String sScriptNameDim = scriptName(); // name of the script
		Vector3d vecXUcs = _XW;
		Vector3d vecYUcs = _YW;
		GenBeam gbs[1];
		Entity ents[0];
		Point3d pts[1];
		int nProps[0];
		double dProps[]={dDepth, dGap,dInterdistance};
		String sProps[]={sType};
		Map mapTsl;
		double dY = dYs[nType];

	// detect side by a point if selction is based on a interior wall, asswuming first beam to be the main ref
		if (el.bIsValid() && !el.exposed())
		{
			PLine pl;
			ptRef = getPoint(T("|Pick point on desired side|"));
			ptRef = el.plOutlineWall().closestPointTo(ptRef);	
			if (el.vecZ().dotProduct(ptRef-el.ptOrg())<0)
			{
				mapTsl.setInt("flip",true);
			}
		}	
		else if (!el.bIsValid())
			ptRef = getPoint(T("|Pick insertion point"));	
		
	// create instances for each stud
		for (int i=0;i < bmStuds.length();i++)
		{
			Beam bm = bmStuds[i];
			Element e =  bm.element();
			el = (ElementWall)e;	
			Point3d pt = ptRef;
	
			if (el.bIsValid())
			{
				Vector3d vecX = el.vecX();
				pt.transformBy(vecX*vecX.dotProduct(bm.ptCenSolid()-pt));
	
				ents.setLength(0);
				ents.append(el);

				vecXUcs=vecX;
				vecYUcs=el.vecY();
				
			//// limit axis offset for small studs
				//if (dProps[2]>.5*bm.dD(vecX) || dY>bm.dD(vecX))
				//{
					//reportMessage("\n" + T("|Axis Offset reeset for beam|") + " " + bm.posnum());
					//dProps[2] = 0;
				//}
				//else 	
					//dProps[2] = dInterdistance;
			}
			
			gbs[0] =bm;
			pts[0] = pt;
			tslNew.dbCreate(sScriptNameDim , vecXUcs,vecYUcs,gbs, ents, pts, 
								nProps, dProps, sProps, _kModelSpace,mapTsl); 
		}
		
		eraseInstance();
		return;		
	}// end on insert_______________________________________________________________________________________________
	
	
	if(nSpecial==0)
	{ 
		// HSB-20886
		if(nType==1)
		{ 
			dInterdistance.set(U(190));
			dGap.set(U(3));
		}
		if(nType==0)
		{ 
			dInterdistance.set(U(150));
			dGap.set(U(10));
		}
		
		if (_kNameLastChangedProp == T("|Interdistance|") || _kNameLastChangedProp == T("|Gap|"))
		{
			dInterdistance.set(dInterdistance1);
			dGap.set(dGap1);
		}
	}
	
// Element and beam ref
	Beam bm = _Beam[0];
	Element el;
	if (_Element.length()>0)
		el = _Element[0];
	
// get exposed status
	int bExposed;
	if (el.bIsKindOf(ElementWallSF()))
	{
		ElementWallSF sf = (ElementWallSF)el;
		bExposed =sf.exposed();	
	}	
	else if (el.bIsKindOf(ElementMulti()))
	{
		Element elBm = bm.element();
		if (elBm .bIsKindOf(ElementWallSF()))
		{
			ElementWallSF sf = (ElementWallSF)elBm ;
			bExposed =sf.exposed();				
		}	
	}
	
	
// set instance color on creation
	if (_bOnDbCreated)
	{
		int c = 253;
		if(nSpecial==0) c=5;
		_ThisInst.setColor(c);
	}

// add flip side trigger
	int bFlip = _Map.getInt("flip");
	if (el.bIsValid() && !bExposed)
	{
		String sFlipSideTrigger = T("|Flip Side|");
		addRecalcTrigger(_kContext, sFlipSideTrigger );
		if (_bOnRecalc && (_kExecuteKey==sFlipSideTrigger || _kExecuteKey==sDoubleClick) ) 
		{
			if (bFlip) 	bFlip =false;
			else			bFlip = true;	
			_Map.setInt("flip",bFlip);

			setExecutionLoops(2);
			return;
		}
	}

// coordSys: default E-type defaults
	Vector3d vecX = _X0;
	Vector3d vecY = _Y0;
	Vector3d vecZ = _Z0;
	Point3d ptRef = _Pt0;
	
// if element based take element coordSys
	if (el.bIsValid())
	{
		vecX=-el.vecY();
		vecY=el.vecX();
		vecZ=el.vecZ();
		ptRef.transformBy(vecZ*vecZ.dotProduct(el.ptOrg()-ptRef));
		if (bFlip)
		{
			ptRef.transformBy(-vecZ*el.dBeamWidth());
			vecY*=-1;
			vecZ*=-1;	
		}
		ptRef.transformBy(-vecZ*dDepth);	
		assignToElementGroup(el, true,0,'E');
	}
	else
		assignToGroups(bm, 'I');
	//ptRef.transformBy(vecY*dInterdistance);
	
// vis
	vecX.vis(ptRef,1);	vecY.vis(ptRef,3);	vecZ.vis(ptRef,150);

// get the type
	int nColor = _ThisInst.color();	
	double dX = dXs[nType];
	double dY = dYs[nType];
	double dZ = dZs[nType];

// size and location of beamcut
	double dXBc = dX+dGap;
	if(nSpecial==0)
	{
		// HSB-20886
		dXBc = dX+dGap+U(30);
	}
	double dYBc = dY+2*dGap;
	double dZBc = dDepth*2;
	Point3d ptBc = ptRef;	

// collect ref points per anchor
	Point3d ptRefs[0];
	if (dInterdistance>dY)
	{
		ptRefs.append(ptRef-vecY*.5*dInterdistance);
		ptRefs.append(ptRef+vecY*.5*dInterdistance);
		if(nSpecial!=0)
		{ 
			dYBc += dInterdistance;
		}
		else if(nSpecial==0)
		{ 
			// HSB-20886
			if (dInterdistance <=150 || bExposed)
			{ 
				dYBc += dInterdistance;
//				reportMessage("Test" + dInterdistance);
			}
		}
	}
	else
		ptRefs.append(ptRef);


// add a beamcut if specified
	if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
	{
		if(nSpecial!=0)
		{ 
			BeamCut bc(ptBc, vecX, vecY, vecZ,dXBc, dYBc, dZBc, -1,0,1);
			//bc.cuttingBody().vis(nColor);
			
			if (el.bIsValid())
				bc.addMeToGenBeamsIntersect(el.beam());
			else
				bm.addTool(bc);
		}
		else if(nSpecial==0)
		{ 
			if (dInterdistance <=150 || bExposed)
			{ 
				BeamCut bc(ptBc, vecX, vecY, vecZ, dXBc, dYBc, dZBc, - 1, 0, 1);
				if (el.bIsValid())
					bc.addMeToGenBeamsIntersect(el.beam());
				else
					bm.addTool(bc);
			}
			else
			{ 	
				BeamCut bc(ptBc-vecY*.5*dInterdistance, vecX, vecY, vecZ,dXBc, dYBc, dZBc, -1,0,1);
				BeamCut bc1(ptBc+vecY*.5*dInterdistance, vecX, vecY, vecZ,dXBc, dYBc, dZBc, -1,0,1);
				//bc.cuttingBody().vis(nColor);
				if (el.bIsValid())
				{ 
					bc.addMeToGenBeamsIntersect(el.beam());
					bc1.addMeToGenBeamsIntersect(el.beam());
				}
				else
					bm.addTool(bc);	
			}
		}
	}	

// compose the solid
	Body bd(ptRef, vecX,vecY, vecZ, dT2,dY, dZ,-1,0,1);
	bd.addPart(Body(ptRef, vecX,vecY, vecZ, dX,dY, dT1,-1,0,1));
	Point3d ptTriang = ptRef-vecX*dT2;
	PLine plTriang(ptTriang , ptTriang -vecX*dX1, ptTriang +vecZ*dZ);
	plTriang.close();
	plTriang.transformBy(-vecY*.5*dY);
	bd.addPart(Body(plTriang, vecY*dT1,1));
	plTriang.transformBy(vecY*dY);
	bd.addPart(Body(plTriang, vecY*dT1,-1));
	//	bd.vis(2);		
	
// Displays
	Display dpModel(nColor), dpElement(nColor), dpSpecial(nColor);
	double dTxtH = U(75);
	dpModel.elemZone(el, 0, 'I');
	//dpModel.addHideDirection(vecZ);
	//dpModel.addHideDirection(-vecZ);
	//dpModel.addHideDirection(vecY);
	//dpModel.addHideDirection(-vecY);
	
	dpElement.addViewDirection(vecZ);
	dpElement.addViewDirection(-vecZ);
	if(nSpecial==0) 
	{
		
		dpElement.dimStyle("BF 0.2");
		dpElement.textHeight(dTxtH);
	// make it visible on layer J5
		dpSpecial.elemZone(el, 5, 'J');
	}


	
		
// publish dimensions
	_Map.setDouble("dX", dX);// height
	_Map.setDouble("dY", dY);// width
	_Map.setDouble("dZ", dZ);
		
// expose a defining CNC pline
	if(el.bIsValid())
	{
	// collect sheets of first zone on installation side
		int nZone = 1;
		if (bFlip) nZone=-1;
		ElemZone zone = el.zone(nZone);
		Sheet sheets[] = el.sheet(nZone);
		PlaneProfile ppZone;
		for (int s=0;s<sheets.length();s++)
		{
			if (ppZone.area()<pow(dEps,2))
				ppZone = sheets[s].profShape();
			else
				ppZone.unionWith(sheets[s].profShape());	
		}	
	
	// the brutto contour	
		PLine plCNC;
		LineSeg segCNC(ptRef-vecY*.5*dYBc,ptRef+vecY*.5*dYBc-vecX*dXBc );
		plCNC.createRectangle(segCNC, vecY, -vecX);
				
	// the profile of the new sheet
		PlaneProfile ppCNC(CoordSys(zone.ptOrg(), vecX, vecY, vecZ));
		ppCNC.joinRing(plCNC,_kAdd);
		ppCNC.intersectWith(ppZone);
		segCNC=ppCNC.extentInDir(vecX);
		double dX = abs(el.vecX().dotProduct(segCNC.ptStart()-segCNC.ptEnd()));
		double dY = abs(el.vecY().dotProduct(segCNC.ptStart()-segCNC.ptEnd()));
		plCNC=PLine(vecZ);
		plCNC.addVertex(segCNC.ptMid()+el.vecX()*.5*dX-el.vecY()*.5*dY);
		plCNC.addVertex(segCNC.ptMid()+el.vecX()*.5*dX+el.vecY()*.5*dY);
		plCNC.addVertex(segCNC.ptMid()-el.vecX()*.5*dX+el.vecY()*.5*dY);
		plCNC.addVertex(segCNC.ptMid()-el.vecX()*.5*dX-el.vecY()*.5*dY);
		plCNC.close();
		_Map.setPLine("plCNC", plCNC);
		plCNC.vis(40);		
	}

// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	
// declare the groupname of the hardware components
	String sHWGroupName=el.elementGroup().name();
	Map mapAdditionals;
// add main componnent
	{ 
		HardWrComp hwc(sType, ptRefs.length()); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Simpson StrongTie");
		
		hwc.setModel(sType);
		hwc.setName(sType);
//		hwc.setDescription(sHWDescription);
		hwc.setMaterial("SS Grade 33");
		// HSB-13634
		hwc.setNotes("Verbindungsmittel");
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(el);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dX);
		hwc.setDScaleY(dY);
		hwc.setDScaleZ(dZ);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}

	{ 
		HardWrComp hwc(sFixing, ptRefs.length());// the articleNumber and the quantity is mandatory
		hwc.setRepType(_kRTTsl); 
		int nFixing = sFixings.find(sFixing);
		if (nFixing>-1)
		{ 
			String _article = sFixing; _article.makeLower();
			for (int i=0;i<mapFixings.length();i++) 
			{ 
				Map m = mapFixings.getMap(i);
				String name = m.getMapName().makeLower();
				if (name == _article)
				{
					hwc.setManufacturer(m.getString("Manufacturer"));
					hwc.setDescription(m.getString("Description"));
					hwc.setCategory(m.getString("Category"));
					hwc.setModel(m.getString("Model"));
					// HSB-13634
					hwc.setNotes(sFixing);	
					hwc.setGroup(sHWGroupName);	
					
					hwc.setMaterial(m.getString("Material"));
					hwc.setDScaleX(m.getDouble("ScaleX"));
					hwc.setDScaleY(m.getDouble("ScaleY"));
					hwc.setDScaleZ(m.getDouble("ScaleZ"));
					
					break;
				}
			}//next i	
			
			mapAdditionals.setString("ArticleNumber", hwc.articleNumber());
			mapAdditionals.setString("Manufacturer", hwc.manufacturer());
			mapAdditionals.setString("Description", hwc.description());
			mapAdditionals.setString("Category", hwc.category());
		}
		hwcs.append(hwc);		
	}

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion



// draw
	for (int i=0;i<ptRefs.length();i++)
	{
		Body bdThis = bd;
		bdThis.transformBy(ptRefs[i]-ptRef);
		dpModel.draw(bdThis);
		if(nSpecial==0)
			dpSpecial.draw(bdThis);	
	}
	if(el.bIsValid())
	{
		
		String text = _ThisInst.formatObject(sFormat, mapAdditionals);
		dpElement.draw(text, _Pt0,el.vecY().crossProduct(vecZ), el.vecY(), 0, -2, _kDevice);
	}


//region Dialog Trigger
{
	
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	
//region Trigger AddFixing
	String sTriggerAddFixing = T("|Edit Fixing|");
	addRecalcTrigger(_kContext, sTriggerAddFixing );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddFixing)
	{
	
		mapTsl.setInt("DialogMode",1);
		String article = sFixing;
		sProps.append(article);

		int nFixing = sFixings.find(article);
		if (nFixing>-1)
		{ 
			String _article = article; _article.makeLower();
			for (int i=0;i<mapFixings.length();i++) 
			{ 
				Map m = mapFixings.getMap(i);
				String name = m.getMapName().makeLower();
				if (name == _article)
				{
					sProps.append(m.getString("Manufacturer"));
					sProps.append(m.getString("Description"));
					sProps.append(m.getString("Category"));
					sProps.append(m.getString("Model"));
					
					dProps.append(m.getDouble("ScaleX"));
					dProps.append(m.getDouble("ScaleY"));
					dProps.append(m.getDouble("ScaleZ"));
					
					break;
				}
			}//next i			
		}
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				article = tslDialog.propString(0);
				String manufacturer = tslDialog.propString(1);
				String description = tslDialog.propString(2);
				String cat = tslDialog.propString(3);
				String model = tslDialog.propString(4);
				
				double dX = tslDialog.propDouble(0);
				double dY = tslDialog.propDouble(1);
				double dZ = tslDialog.propDouble(2);

			// rewrite settings
				if (article.length()>0)
				{ 
					String _article = article; _article.makeLower();
					Map mapNew, mapApps;			
					for (int i=0;i<mapFixings.length();i++) 
					{ 
						Map m = mapFixings.getMap(i);
						String name = m.getMapName().makeLower();
						if (name == _article)
						{
							mapApps = m.getMap("Application[]"); // a list of tsls where this could be selected
							continue;
						}
						else
							mapNew.appendMap("Fixture", m);
					}//next i
					
				// get the list where this fixture is applicable to	
					String apps[0];
					for (int i=0;i<mapApps.length();i++)
					{
						String app = mapApps.getString(i);
						if (app.length()>-1 && apps.findNoCase(app,-1)<0)
							apps.append(app);
					}
					if (apps.findNoCase(scriptName(),-1)<0)
						mapApps.appendString("Application", scriptName());
					
					
					Map m;
					m.setString("Article",article);
					m.setString("Manufacturer", manufacturer);
					m.setString("Description", description);
					m.setString("Category", cat);
					m.setString("Model", model);
					
					m.setDouble("ScaleX", dX);
					m.setDouble("ScaleY", dY);
					m.setDouble("ScaleZ", dZ);
					
					m.setMap("Application[]", mapApps);
					
					m.setMapName(article);
					mapNew.appendMap("Fixture", m);
					
					mapSetting.setMap("Fixture[]", mapNew);
					if (mo.bIsValid())
						mo.setMap(mapSetting);
					else
					{ 
						mo.dbCreate(mapSetting);
					}
				}
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;		
	}//endregion
	
//region Trigger TagFixing
	if (sAllFixings.length()>0 && sAllFixings.length()!=sFixings.length())
	{ 
		String sTriggerTagFixture = T("|Add Fixture to| ") + scriptName();
		addRecalcTrigger(_kContext, sTriggerTagFixture );
		if (_bOnRecalc && _kExecuteKey==sTriggerTagFixture)
		{
			mapTsl.setInt("DialogMode",3);		
			sProps.append(sAllFixings.first());	
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					String article = tslDialog.propString(0).makeLower();
					
					Map mapNew;
					for (int i = 0; i < mapFixings.length(); i++)
					{
						Map m = mapFixings.getMap(i);
						String name = m.getMapName().makeLower();
						if (name == article)
						{
							Map mapApps = m.getMap("Application[]"); //a list of tsls where this could be selected
							
							// get the list where this fixture is applicable to
							String apps[0];
							for (int i = 0; i < mapApps.length(); i++)
							{
								String app = mapApps.getString(i);
								if (app.length() >- 1 && apps.findNoCase(app ,- 1) < 0)
									apps.append(app);
							}
							
							int n = apps.findNoCase(scriptName() ,- 1);
							if (n < 0)
							{
								apps.append(scriptName());
								mapApps.appendString("Application", scriptName());
							}
							
							m.setMap("Application[]", mapApps);
							
							reportMessage("\n" + article + T(" |is now available for these scripts|: ") + apps);
							
						}
						
						mapNew.appendMap("Fixture", m);
						
						mapSetting.setMap("Fixture[]", mapNew);
						if (mo.bIsValid())
							mo.setMap(mapSetting);
						else
							mo.dbCreate(mapSetting);
					}
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;
		}		
	}
	//endregion

//region Trigger DeleteFixing
	if (sFixings.length()>0)
	{ 
		String sTriggerDeleteFixing = T("|Delete Fixing|");
		addRecalcTrigger(_kContext, sTriggerDeleteFixing );
		if (_bOnRecalc && _kExecuteKey==sTriggerDeleteFixing)
		{
			mapTsl.setInt("DialogMode",2);
			String article = sFixing;
			sProps.append(article);	

			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{
					String _article = tslDialog.propString(0); _article.makeLower();
					Map mapNew;
					for (int i=0;i<mapFixings.length();i++) 
					{ 
						Map m = mapFixings.getMap(i);
						String name = m.getMapName().makeLower();
						if (name == _article)
						{
							continue;
						}
						else
							mapNew.appendMap("Fixture", m);
					}//next i					
				
					if (mapNew.length()<1 & mo.bIsValid())
						mo.dbErase();
					else
					{ 
						mapSetting.setMap("Fixture[]", mapNew);
						if (mo.bIsValid())
							mo.setMap(mapSetting);
						else
						{ 
							mo.dbCreate(mapSetting);
						}						
					}
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;
		}//endregion		
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
			else
				bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)
					reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else
					reportMessage(TN("|Failed to write to| ") + sFullPath);
				
			}
			
			setExecutionLoops(2);
			return;
		}
	}	
	
}

#End
#BeginThumbnail
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
2%K:Q@@8@M'&%)'3@58HH`__9
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
        <int nm="BreakPoint" vl="136" />
        <int nm="BreakPoint" vl="110" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20886: Modifications of Markus should only be valid for special Baufritz" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/12/2023 8:19:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13238 new properties for element format display and fixture" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/22/2021 9:24:35 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End