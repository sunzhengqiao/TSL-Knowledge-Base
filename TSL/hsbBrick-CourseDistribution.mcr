#Version 8
#BeginDescription
version value="2.7" date="02oct.2020" author="marsel.nakuci@hsbcad.com" 

HSB-9023: pass on the properties
HSB-5561: when vertical distribution is not possible, accept the minimal joint distribution and cut the last brick 
save in map all other walls for internal walls needed for the calculation of the X-intersections
bug fix at the calculation of course joint
add as readonly the calculated course joint
adabt the name change at hsbBrick-BrickDistributionExterior and hsbBrick-BrickDistributionInterior
save ref point of building as vector so it is imune when pt0 is moved
horizontal distribution splitted into 2 TSL for inter. and ext. walls

vertical distribution starts with joint ends with brick
TSL picture
for each storey generate a separate TSL for internal walls
avoid generation of brick distribution tsls in bdebug

This tsl specifies the vertical distribution of brick courses
By default the grip point is set to the max height of selected walls
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 7
#KeyWords mi casa, brick, course, distribution
#BeginContents
/// <History>//region
/// <version value="2.7" date="02oct.2020" author="marsel.nakuci@hsbcad.com"> HSB-9023: pass on the properties </version>
/// <version value="2.6" date="10.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5561: when vertical distribution is not possible, accept the minimal joint distribution and cut the last brick </version>
/// <version value="2.5" date="21.08.2019" author="marsel.nakuci@hsbcad.com"> save in map all other walls for internal walls needed for the calculation of the X-intersections </version>
/// <version value="2.4" date="27may2019" author="marsel.nakuci@hsbcad.com"> bug fix at the calculation of course joint </version>
/// <version value="2.3" date="26may2019" author="marsel.nakuci@hsbcad.com"> add as readonly the calculated course joint </version>
/// <version value="2.2" date="03may2019" author="marsel.nakuci@hsbcad.com"> adabt the name change at hsbBrick-BrickDistributionExterior and hsbBrick-BrickDistributionInterior </version>
/// <version value="2.1" date="17apr2019" author="marsel.nakuci@hsbcad.com"> save ref point of building as vector so it is imune when pt0 is moved </version>
/// <version value="2.0" date="01apr2019" author="marsel.nakuci@hsbcad.com"> horizontal distribution splitted into 2 TSL for inter. and ext. walls </version>
/// <version value="1.9" date="17mar2019" author="marsel.nakuci@hsbcad.com"> vertical distribution starts with joint ends with brick </version>
/// <version value="1.8" date="07mar2019" author="marsel.nakuci@hsbcad.com"> TSL picture </version>
/// <version value="1.7" date="26feb2019" author="marsel.nakuci@hsbcad.com"> for each storey generate a separate TSL for interior walls </version>
/// <version value="1.6" date="18feb2019" author="marsel.nakuci@hsbcad.com"> avoid generation of brick distribution tsls in bdebug </version>
/// <version value="1.5" date="16feb2019" author="marsel.nakuci@hsbcad.com"> dbuttJointMin and dButtJoinMax saved in tsl instance to be read by hsbBrick-BrickDistribution </version>
/// <version value="1.4" date="18jan2019" author="thorsten.huck@hsbcad.com"> HSBCAD-382 added properties for butt mortar joint, new naming for horizontal distribution </version>
/// <version value="1.3" date="18jan2019" author="Ronald.van.wijngaarden@hsbcad.com""> added snap lines for oppenings  </version>
/// <version value="1.2" date="16jan2019" author="thorsten.huck@hsbcad.com"> added zone property </version>
/// <version value="1.1" date="16jan2019" author="marsel.nakuci@hsbcad.com"> added property for mortar </version>
/// <version value="1.0" date="15jan2019" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select wall elements, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl specifies the vertical distribution of brick courses
/// By default the grip point is set to the max height of selected walls
/// </summary>

/// commands
// command to insert
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBrick-CourseDistribution")) TSLCONTENT
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
//end constants//endregion
	
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbBrickFamilyDefinitions";
	Map mapSetting; // map to contain all families in xml
	
// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml"; // path of xml file
	String sFile=findFile(sFullPath); // static gets the name of the file
	
// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);// read from map object
	if (mo.bIsValid())
	{
		mapSetting=mo.map();// 
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)// read from xml
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}
	// create default settings if nothing found
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid())// default settings
	{
	// add some default data
		Map mapGeneral;
		mapGeneral.setInt("Version", 1);
		mapGeneral.setString("DimStyle", _DimStyles.length()>0?_DimStyles[0]:"");
		mapGeneral.setDouble("TextHeight", U(80));
		mapSetting.setMap("General", mapGeneral);
		
	// brick
		Map mapFamily;
		mapFamily.setString("Name", "M50");
		mapFamily.setDouble("Length", U(188));
		mapFamily.setDouble("Width", U(88));
		mapFamily.setDouble("Height", U(48));
		mapFamily.setInt("Color", 12);
		
		Map mapFamilies;
		mapFamilies.appendMap("Family", mapFamily);
		mapSetting.setMap("Family[]", mapFamilies);		
		
		mapSetting.writeToXmlFile(sFullPath);
		mo.dbCreate(mapSetting);
	}	
//End Settings//endregion


//region get families
	String sFamilies[0];
	Map mapFamilies = mapSetting.getMap("Family[]");// get all families
	Map mapListFamilies[0];
	for (int i=0;i<mapFamilies.length();i++) 
	{ 
		Map m = mapFamilies.getMap(i);
		if (m.hasString("Name") && mapFamilies.keyAt(i).makeLower()=="family")
		{ 
			String sName = m.getString("Name");
			if (sFamilies.find(sName)<0)// if this type does not exist, append it
			{
				mapListFamilies.append(m);// all maps
				sFamilies.append(sName);// all names of each map
			}
		}
	}//next i
// order alphabetically
	for (int i=0;i<sFamilies.length();i++) 
		for (int j=0;j<sFamilies.length()-1;j++) 
			if (sFamilies[j]>sFamilies[j+1])
			{
				sFamilies.swap(j, j + 1);
				mapListFamilies.swap(j, j + 1);
			}
//endregion End get families


//region Properties
	String sFamilyName=T("|Family|");
	PropString sFamily(nStringIndex++, sFamilies, sFamilyName);	// a lis of all family names in sFamilies
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	
	String sZoneName=T("|Zone|");	
	int nZones[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 0, 1, 2, 3, 4, 5};
	PropInt nZone(nIntIndex++, nZones, sZoneName);	
	nZone.setDescription(T("|Defines the zone of the brick laying|"));
	nZone.setCategory(category);
// course distribution	
	category = T("|Mortar Course Joint|");
	String sCourseJointMinName=T("|Minimum|");	
	PropDouble dCourseJointMin(nDoubleIndex++, U(9), sCourseJointMinName);	
	dCourseJointMin.setDescription(T("|Defines the minmal course joint|"));
	dCourseJointMin.setCategory(category);
	
	String sCourseJointMaxName=T("|Maximum|");	
	PropDouble dCourseJointMax(nDoubleIndex++, U(15), sCourseJointMaxName);	
	dCourseJointMax.setDescription(T("|Defines the maximal course joint|"));
	dCourseJointMax.setCategory(category);
	
	String sCourseJointPropName=T("|calculated|");	
	PropDouble dCourseJointProp(nDoubleIndex++, U(0), sCourseJointPropName);	
	dCourseJointProp.setDescription(T("|The calculated course joint|"));
	dCourseJointProp.setCategory(category);
	dCourseJointProp.setReadOnly(true);
	
// butt distribution
	category = T("|Mortar Butt Joint|");
	String sButtJointMinName=T("|Minimum| ");	
	PropDouble dButtJointMin(nDoubleIndex++, U(9), sButtJointMinName);	
	dButtJointMin.setDescription(T("|Defines the minmal course joint|"));
	dButtJointMin.setCategory(category);
	
	String sButtJointMaxName=T("|Maximum| ");	
	PropDouble dButtJointMax(nDoubleIndex++, U(15), sButtJointMaxName);	
	dButtJointMax.setDescription(T("|Defines the maximal course joint|"));
	dButtJointMax.setCategory(category);
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
		else	
			showDialog();
		
	// prompt for elements ElementWall
	// first selected wall decides whether it will be an exterior or interior wall
		PrEntity ssE(T("|Select element(s)|"), ElementWall());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
	// prompt a point selection	
		_Pt0 = getPoint();
		
	// purge invalid elements
		for (int i=_Element.length()-1; i>=0 ; i--) 
		{ 
			if (!_Element[i].bIsKindOf(ElementWall()))
				_Element.removeAt(i); 	
		}//next i
	// depending on the first wall purge remaining walls
	// get type of first wall
		ElementWall ElWall = (ElementWall)_Element[0];
		int isExterior = ElWall.exposed();
	
		for (int i=_Element.length()-1; i>=0 ; i--) 
		{ 
			ElementWall ElWall = (ElementWall)_Element[i];
			int isExteriorI = ElWall.exposed();
			if(isExterior!=isExteriorI)// remove walls not same type as first wall in selection
				_Element.removeAt(i);
				
		}//next i
		// HSB-9023 pass on the properties
	// generate a tsl 
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nZone};
		double dProps[]={dCourseJointMin, dCourseJointMax, dCourseJointProp, dButtJointMin, dButtJointMax};
		String sProps[]={sFamily};
		Map mapTsl;	
		
		
		if(isExterior)
		{ 
			// generate 1 TSL for all exterior walls
			for (int i=0;i<_Element.length();i++) 
			{ 
				entsTsl.append((Entity)_Element[i]);
			}//next i
			// insertion point of the TSL 
			ptsTsl[0] = _Pt0;
			// properties
			// create the TSL in database
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			eraseInstance();
			return
		}
		
	// if interior walls, generate 1 TSL for each storey
	// first get all floors
		int iNrStorys=0;
		String storeys[1];// ={ };
		
		storeys[0] = _Element[0].elementGroup().namePart(1);// start with the first element
		for (int i=1;i<_Element.length();i++) 
		{ 
			String storeyI = _Element[i].elementGroup().namePart(1);
			int index = storeys.find(storeyI);
			if (index<0)// its a new storey level
				storeys.append(storeyI);
		}//next i
		
		// generate a TSL for each storey
		for (int i=0;i<storeys.length();i++) 
		{ 
			Entity entsTsl[] = {};
			// get all walls of this storey
			for (int j=0;j<_Element.length();j++) 
			{
				String storeyI = _Element[j].elementGroup().namePart(1);
				if(storeys[i]==storeyI)
					entsTsl.append((Entity)_Element[j]);
			}//next j
			
			// insertion point
			ptsTsl[0] = _Pt0 + i * _XW * U(3500);
			// properties
			// create the TSL in database
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	
//region validation, if no element selected

// validate selection set
	if (_Element.length()<1)		
	{
		// no element ElementWall in selection
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}
	
//End validation//endregion
	
// if interior walls, categorise according to the storey levels
// for each storey 1 separate TSL

//region get brick data from the choosen family

	int nFamily = sFamilies.find(sFamily);// get integer of family choosen in selection
	if (nFamily<0)
	{ 
		reportMessage("\n" + T("|Invalid family|"));
		eraseInstance();
		return;
	}
	
	// general
	double dTextHeight = U(100);
	int nColor;
	{
		String k;
		Map m = mapSetting.getMap("General");
		k = "Color";		if (m.hasInt(k))	nColor = m.getInt(k);// get 
		k = "TextHeight";	if (m.hasDouble(k))	dTextHeight = m.getDouble(k);
	}	
	
	Map mapFamily = mapListFamilies[nFamily];// get the map of the family choosen
	int nColorBrick = 3;// some default values
	double dLength = U(188), dWidth=U(88), dHeight=U(48);// some default values
	{
		String k;
		Map m = mapFamily;
		k = "Color";	if (m.hasInt(k))	nColorBrick = m.getInt(k);
		k = "Length";	if (m.hasDouble(k))	dLength = m.getDouble(k);
		k = "Width";	if (m.hasDouble(k))	dWidth = m.getDouble(k);
		k = "Height";	if (m.hasDouble(k))	dHeight = m.getDouble(k);
		
		if (dLength<dEps || dWidth < dEps || dHeight<dEps)
		{ 
			reportMessage("\n" + T("|Invalid brick sizes of family| ") + sFamily);
			eraseInstance();
			return;			
		}
	}
//End get brick data//endregion 

//region relevant points for distribution
// collect relevant points for distribution
// for the interior walls we will disregard opening, they will be excluded
	Point3d ptsEl[0];
	Point3d ptsOp[0];
	ElementWall ElWall = (ElementWall)_Element[0];
	int isExterior = ElWall.exposed();
	assignToElementGroup(_Element[0], false, 0, 'E');
	
	for (int i=0;i<_Element.length();i++) 
	{ 
		Element& el = _Element[i];
		LineSeg seg = el.segmentMinMax(); // diagonal of the element
		seg.vis(i);
		//element extreme points		  
		ptsEl.append(seg.ptStart());
		ptsEl.append(seg.ptEnd());
		Vector3d vecX = el.vecX();
		if(isExterior)// openings only for exterior walls
		{ 
			Opening openings[] = el.opening();// get all openings of the element
			for (int j=0;j<openings.length();j++)
			{ 
				if(_Entity.find(openings[j])<0)// if opening not included in _Entity, append it
					_Entity.append(openings[j]);
					
				setDependencyOnEntity(openings[j]);//fire exetution of tsl if openings[j] gets modified
				seg = PlaneProfile(openings[j].plShape()).extentInDir(vecX); 
				//openning extreme points
				ptsOp.append(seg.ptStart());// 
				ptsOp.append(seg.ptEnd()); 
			}//next j
		}
		
	}//next i	
	
// order points vertically
	_Pt0.setZ(0); // _Pt0 always in Z=0
	Line lnZ(_Pt0, _ZW);
	// first points are projected to lnZ which goes through _Pt0
	if(isExterior)
	{ 
		ptsOp = lnZ.orderPoints(lnZ.projectPoints(ptsOp),dEps);// order points with the line of first point and second point
	}
	ptsEl = lnZ.orderPoints(lnZ.projectPoints(ptsEl));

//End relevant points for distribution//endregion 


//region graph and its grip points

// transformation to planview
	// ptBase of the graph
	Point3d ptBase = _Pt0 + (20 * _XW + 5 * _YW) * dTextHeight; 
	CoordSys cs2Plan;
	cs2Plan.setToAlignCoordSys(Point3d(0, 0, 0), _XW, _YW, _ZW, Point3d(0, 0, 0), _XW ,- _ZW, _YW);
	Point3d pt0Y0 = _Pt0;
	pt0Y0.setY(0);  // set Y=0
	Vector3d vecTranslation = ptBase - pt0Y0;
	ptBase.vis(1);
	_Pt0.vis(3);

	if(_PtG.length()>0)
	{ 
		// grip points allowed to move only in line ptBase and _YW direction
		_PtG[0] = Line(ptBase, _YW).closestPointTo(_PtG[0]);
	}
	
//End graph and its grip points//endregion
	
	
//region Draw Vertical Grid
	Display dp(7);
	dp.textHeight(dTextHeight);

// declare extremes
	Point3d ptsExtr[0];
	
// draw element locations bottom, top
	for (int i=0;i<ptsEl.length();i++) 
	{ 
		Point3d pt = ptsEl[i]; 
		String s; s.formatUnit(pt.Z(), 2, 0);
		pt.transformBy(cs2Plan);
		pt.setZ(0);
		pt.transformBy(vecTranslation);
		dp.draw(s, pt, _XW, _YW ,- 2, 0);
		dp.draw(PLine (pt, pt + _XW * 5*dTextHeight));
		
		if (i == 0)ptsExtr.append(pt);// bottom left point
		else if (i == ptsEl.length()-1)ptsExtr.append(pt);// top right point	
	}//next i
	
// draw Box around the graph
	LineSeg segBox(ptsExtr[0] - _XW * 20 * dTextHeight - _YW * 5 * dTextHeight, 
	ptsExtr[ptsExtr.length() - 1] + _XW * 20 * dTextHeight + _YW * 5 * dTextHeight);
	PLine plBox;
	plBox.createRectangle(segBox, _XW, _YW);
	dp.draw(plBox);	
	
// get/add ref point
// by default the ref point will be set to the top height of the building
	Point3d ptRef = _PtG.length()>0?_PtG[0]:ptsExtr[ptsExtr.length() - 1]; // first the top oppening point
	if (_PtG.length() < 1) _PtG.append(ptRef);
	
	ptRef.vis(1);
// draw opening locations
// openings only for exterior walls
	if(isExterior)
	{
		for (int i=0;i<ptsOp.length();i++)
		{ 
			Point3d& pt = ptsOp[i]; 
			String s; s.formatUnit(pt.Z(), 2, 0);
			pt.transformBy(cs2Plan);
			pt.setZ(0);
			pt.transformBy(vecTranslation);
			dp.draw(s, pt, _XW, _YW ,- 2, 0);
			dp.draw(PLine (pt, pt + _XW * dTextHeight));
		}//next i
	}
	dp.color(141);
	
// draw ref location
	ptBase.vis(2);
	dp.color(1);
	{ 
		String s; 
		s.formatUnit(_YW.dotProduct(ptRef-ptBase), 2, 0);
		dp.draw(s, ptRef, _XW, _YW ,- 2, 0);
	}
	dp.draw(PLine (ptRef, ptRef + _XW * dTextHeight));
	
//End Draw VerticalGrid//endregion 	
	
	
//region compute mortar joint
// computation based on the grip point
// 
	Point3d ptBrick = ptsExtr[0];
	ptBrick.vis(1);
	double dRange = _YW.dotProduct(ptRef-ptBrick);
	// distribution starts with joint and ends with brick
	// if division = 4.4, then 4 is not allowed dCourseJoint can not be larger then dCourseJointMax so it is 5
	int nNumMin = dRange / (dHeight + dCourseJointMax) + 1;
	// if division = 4.4 then 5 is not allowed dCourseJoint can not be smaller then dCourseJointMin
	int nNumMax = dRange / (dHeight + dCourseJointMin);
	
	if (nNumMin>nNumMax)
	{
		// no solution possible
		reportMessage(TN("|No optimal solution found for the vertical distribution|"));
		reportMessage(TN("|minimal joint will be accepted|"));
		
		// HSB-5561 accept minimal vertical joint and calc nNumMin and nNumMax
		nNumMax += 1;
		nNumMin = nNumMax;
//		reportMessage(TN("|Increase the wall height or change joint width limits|"));
//		return;
	}
	
	
	//nr of all possible variations
	int nNumVar = nNumMax - nNumMin + 1;
	int nNumVars[0];
	// nNumMin to nNumMax
	for (int i=0;i<nNumVar;i++) 
	{
		nNumVars.append(nNumMin+i); 
	}

	int nNumCourseSelected = _Map.hasInt("NumCourse")?_Map.getInt("NumCourse"):-1;
	if (nNumVars.find(nNumCourseSelected)<0)
		nNumCourseSelected = -1;// no selection is done for the nr of vertical bricks
	// if no selection take the nNumMin as default
	int nNumCourse = nNumCourseSelected < 0 ? nNumMin : nNumCourseSelected;
	
// allow the user to select the amount of courses
	for (int i=0;i<nNumVars.length();i++) 
	{ 
		String sTriggerCourse = nNumVars[i] +T(" |Courses|");
		
		if (nNumVars[i] == nNumCourse)sTriggerCourse += " [x]";
		addRecalcTrigger(_kContext, sTriggerCourse);
		if (_bOnRecalc && (_kExecuteKey==sTriggerCourse || _kExecuteKey==sDoubleClick))
		{
			// if the ith is selected, save it 
			_Map.setInt("NumCourse", nNumVars[i]);
			setExecutionLoops(2);
			return;
		}
	}//next i
	
	double dCourseJoint = dRange/ nNumCourse - dHeight;// joint height for the selected nNumcourse
	// HSB-5561 in case when vertical distribution not possible, accept minimal joint width
	if (dCourseJoint <= dCourseJointMin)
	{ 
		dCourseJoint = dCourseJointMin;
	}
	dCourseJointProp.set(dCourseJoint);
//End compute mortar joint//endregion

// trigger for the ptRefBuilding
// Trigger VARIABLE//region
	String sTriggerAddRefPoint = T("|Select reference point|");
	addRecalcTrigger(_kContext, sTriggerAddRefPoint );
//	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRefPoint))
	if ((_kExecuteKey==sTriggerAddRefPoint))
	{
		Point3d ptRefBuilding = getPoint("click a point for the reference point");
		if(_PtG.length()>1)
		{ 
			// ptg exists
			_PtG[1] = ptRefBuilding;
		}
		else
		{ 
			// normally should never happen in this stage 
			_PtG.append(ptRefBuilding);
		}
	// save in Map as vector so that it does not move when pt0 is moved
		_Map.setVector3d("ptRefBuilding", ptRefBuilding);
		
		setExecutionLoops(2);
		return;
	}//endregion
	
	if(_kNameLastChangedProp=="_Pt0")
	{ 
	// rewrite PtG[1]
		_PtG[1] = _Map.getVector3d("ptRefBuilding");
	}

//region draw bricks in the graph
	Point3d bottomList[0];
	Point3d topList[0];	
	int nNumCourseTotal = _ZW.dotProduct(ptsEl[ptsEl.length() - 1] - ptsEl[0]) / (dHeight + dCourseJoint);
	// ptsExtr contains extreme points in _Pt0 and in height 
	
	dp.color(nColorBrick);
	for (int i=0;i<nNumCourseTotal;i++) 
	{ 
		double dX = dLength;
		if (i % 2 == 1)dX *= .5;
		// segment for drawing the brick, distribution starts with joint and ends with brick
		LineSeg seg(ptBrick + _YW * dCourseJoint, ptBrick + _XW * dX + _YW * (dHeight + dCourseJoint));
		//collect points in the bricks projected to _ZW
		Point3d pp = ptBrick + _YW * dCourseJoint;
		topList.append(pp);	//bottom left point of the brick
		pp = ptBrick + _XW * dX + _YW * (dHeight + dCourseJoint);
		bottomList.append(pp);	//top right point of the brick										 
		PLine pl;
		pl.createRectangle(seg, _XW, _YW);
		dp.draw(PlaneProfile(pl), _kDrawFilled, 60); 
		ptBrick += _YW * (dHeight + dCourseJoint);
	}//next i
//End draw some bricks//endregion 

//region create plane profiles in intersection regions
// relevant only for exterior walls
	if(isExterior)
	{
		for (int i=0;i<_Element.length();i++)
		{ 
			Element& el = _Element[i];
			LineSeg seg = el.segmentMinMax(); //seg.vis(i);
			ptsEl.append(seg.ptStart());
			ptsEl.append(seg.ptEnd());
			Vector3d vecX = el.vecX();
			Opening openings[] = el.opening();
			for (int j=0;j<openings.length();j++)// for each opening of the wall
			{ 
				if(_Entity.find(openings[j])<0)
					_Entity.append(openings[j]);
					
				setDependencyOnEntity(openings[j]);
				seg = PlaneProfile(openings[j].plShape()).extentInDir(vecX); 
				
				double dx = vecX.dotProduct(seg.ptEnd()-seg.ptStart());
				Point3d snapPoint = seg.ptStart()+vecX * dx / 2.0;// middle of opening
				
				PlaneProfile ppOpeningMax = PlaneProfile(openings[j].plShape());
				ppOpeningMax.shrink(-dHeight - dCourseJoint);
				PlaneProfile ppOpeningMin = PlaneProfile(openings[j].plShape());
				ppOpeningMin.shrink(dHeight + dCourseJoint);
				
				ppOpeningMax.subtractProfile(ppOpeningMin);// around the opening +(dHeight + dCourseJoint) -(dHeight + dCourseJoint)
				ppOpeningMax.vis(2);
				Point3d ptOpeningReference = snapPoint + _ZW *_ZW.dotProduct(ptsEl[0] - snapPoint);
				CoordSys plan2Cs;
				plan2Cs.setToAlignCoordSys(Point3d(0,0,0), _XW ,- _ZW, _YW, Point3d(0,0,0), _XW, _YW, _ZW);
				Line lnCenterOpening(snapPoint, el.vecY());
				Point3d pt0(0, 0, 0);
				
				Display dp2(2);
				int found = false; // for false
				for (int k=0;k<bottomList.length();k++)//top right point of the brick
				{ 
					Point3d projectedPoint = bottomList[k];
					projectedPoint.transformBy(-vecTranslation);
					projectedPoint.transformBy(plan2Cs);
					projectedPoint = lnCenterOpening.closestPointTo(projectedPoint);
					//check if it falls in the ppOpeningMax
					
					if(ppOpeningMax.pointInProfile(projectedPoint)==_kPointInProfile)
					{ 
						//if(abs(ptsExtr[0].Z() -(projectedPoint.Z()-dHeight))>0.001)
						{ 
							projectedPoint.vis(1);
							Point3d pleft = projectedPoint - el.vecX() * dTextHeight * 2;
							Point3d pright = projectedPoint + el.vecX() * dTextHeight * 2;
							PLine snapPlineBottom2(pleft, pright);
							Point3d pstartBrick = projectedPoint - el.vecX() * dLength/2;
							Point3d pendBrick = projectedPoint + el.vecX() * dLength/2-el.vecY()*dHeight;
							
							PLine pl;
							LineSeg seg(pstartBrick, pendBrick);
							pl.createRectangle(seg, el.vecX(),el.vecY());
							dp.color(1);
							PlaneProfile pp(pl);
							dp.draw(PlaneProfile(pl), _kDrawFilled, 60); 
							dp2.color(1);
							dp2.draw(snapPlineBottom2);
							found = true;
						}
					}
					else if(found && ppOpeningMax.pointInProfile(projectedPoint)==_kPointOutsideProfile)
					{ 
						break;
					}
				}//next index
				
				dp2.color(2);
				found = false; // for false
				for (int k=topList.length()-1; k>=0 ; k--)//bottom left point of the brick
				{ 
					Point3d projectedPoint = topList[k];
					projectedPoint.transformBy(-vecTranslation);
					projectedPoint.transformBy(plan2Cs);
					projectedPoint = lnCenterOpening.closestPointTo(projectedPoint);
					
					//check if it falls in the ppOpeningMax
					if(ppOpeningMax.pointInProfile(projectedPoint)==_kPointInProfile)
					{
						projectedPoint.vis(1);
						Point3d pleft = projectedPoint - el.vecX() * dTextHeight * 2;
						Point3d pright = projectedPoint + el.vecX() * dTextHeight * 2;
						PLine snapPlineBottom2(pleft, pright);
						
						Point3d pstartBrick = projectedPoint - el.vecX() * dLength/2;
						Point3d pendBrick = projectedPoint + el.vecX() * dLength/2+el.vecY()*dHeight;
						
						PLine pl;
						LineSeg seg(pstartBrick, pendBrick);
						pl.createRectangle(seg, el.vecX(),el.vecY());
						dp.color(1);
						dp.draw(PlaneProfile(pl), _kDrawFilled, 60);
						PlaneProfile pp(pl);
						dp2.color(1);
						dp2.draw(snapPlineBottom2);
						found = true;
					}
					else if(found && ppOpeningMax.pointInProfile(projectedPoint)==_kPointOutsideProfile)
					{ 
						break;
					}
				}//next k
			}//next j
		}//next i
	}

//End create plane profiles in intersection regions//endregion 

//region calculate the reference point
 
	// find the origin reference point of all walls
	// X will be minimum of all walls
	// Y will be minimum of all walls
	
	Point3d ptRefBuilding;
	if(_PtG.length()>1)
	{ 
		// ptRefBuilding in grip point ptG
		ptRefBuilding = _PtG[1];
	}
	else
	{
		// initialize, calc the ptRefBuilding
		ptRefBuilding = _Element[0].ptOrg();
		Wall wall = (Wall)_Element[0];
		ptRefBuilding = wall.ptStart();
		for (int i=0;i<_Element.length();i++) 
		{ 
			Element el = _Element[i];
			Wall walli = (Wall)_Element[i];
			Point3d ptOrg = el.ptOrg();
			// X
			if(walli.ptStart().X()<ptRefBuilding.X())
			{ 
				ptRefBuilding.setX(walli.ptStart().X());
			}
			if(walli.ptEnd().X()<ptRefBuilding.X())
			{ 
				ptRefBuilding.setX(walli.ptEnd().X());
			}
			// Y
			if(walli.ptStart().Y()<ptRefBuilding.Y())
			{ 
				ptRefBuilding.setY(walli.ptStart().Y());
			}
			if(walli.ptEnd().Y()<ptRefBuilding.Y())
			{ 
				ptRefBuilding.setY(walli.ptEnd().Y());
			}
			_PtG.append(ptRefBuilding);
		// save in map
			_Map.setVector3d("ptRefBuilding", ptRefBuilding);
		}//next i
	}
	
//End calculate the reference point//endregion

//region display of the reference point
 	
	// draw a circle at the reference point
	Display dp2(20);
	PLine pl;
	pl.createCircle(ptRefBuilding, _ZW, U(50));
	PlaneProfile pp(pl);
	dp2.color(2);
	dp2.draw(pp,_kDrawFilled, 5);
	
	// publish family data
	Map mapX;
	mapX.setMap("Family", mapFamily);
	mapX.setDouble("CourseJoint", dCourseJoint);// vertical
	mapX.setDouble("dButtJointMin", dButtJointMin);// horizontal min
	mapX.setDouble("dButtJointMax", dButtJointMax);// horizontal max
	// store in mapX to be read by BrickDistribution
	mapX.setPoint3d("ptRefBuilding", ptRefBuilding);
	_ThisInst.setSubMapX("hsbBrickData", mapX);
	
//End display of the reference point//endregion
	
//region create butt distributions on dbCreate
	// _bOnDbCreated will be set to TRUE only during the first execution of the TslInst, 
	// after it has been appended to the Autocad database
	if (_bOnDbCreated)// || bDebug)
	{ 
		Plane planes[0];
		int nIndices[_Element.length()];
		for (int i=0;i<_Element.length();i++) 
		{ 
			Element& el = _Element[i]; 
			Vector3d vecZ = el.vecZ();
			Point3d ptOrg = el.ptOrg();
			Plane pn (ptOrg, vecZ);// element plane in ptorg and xy plane of element
			
			int nIndex=-1;
			for (int j=0;j<planes.length();j++)
			{ 
				Plane pn2= planes[j]; 
				Vector3d vecZ2 = pn2.vecZ();
				Point3d ptOrg2 = pn2.ptOrg();
				if (vecZ.isCodirectionalTo(vecZ2) && abs(vecZ.dotProduct(ptOrg-ptOrg2))<dEps)
				{ 
					nIndex = j;
					break;
				}
			}//next j
			
			if (nIndex==-1)
			{
				planes.append(pn);
				nIndex = planes.length() - 1;
			}
			nIndices[i] = nIndex;
		}//next i

	// create but distributions
	// for exterior walls we will create each TSL for each facade
	// for interior walls we will have each TSL for each wall
		if(isExterior)
		{ 
			for (int i=0;i<planes.length();i++) 
			{
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_ThisInst};	Point3d ptsTsl[] = {};
				int nProps[]={};			double dProps[]={dButtJointMin, dButtJointMax};				String sProps[]={};
				Map mapTsl;	
				 
				for (int j=0;j<nIndices.length();j++) 
				{ 
					if (i!= nIndices[j])continue;
					entsTsl.append(_Element[j]); 
				}//next i	
				
				tslNew.dbCreate("hsbBrick-BrickDistributionExterior" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				if (bDebug)
					reportMessage("\n" + "hsbBrick-BrickDistributionExterior" + (tslNew.bIsValid() ? " ok" : " nok"));
			}
		}
		else
		{
			if(bDebug)reportMessage("\n"+ scriptName() + "_Element.length(): "+_Element.length());
			
			// interior walls we have 1 TSL for each wall
			for (int i = 0; i < _Element.length(); i++)
			{ 
				// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_ThisInst};	Point3d ptsTsl[] = {};
				int nProps[]={};			double dProps[]={dButtJointMin, dButtJointMax};				String sProps[]={};
				Map mapTsl;	
				
				// each wall must know about other walls for the calculation of the intersection
				// collect other walls of _Element[i]
				Entity entsOtherWalls[0];
				for (int j = 0; j < _Element.length(); j++)
				{ 
					if (_Element[i] != _Element[j])
					{ 
						Entity ent = (Entity)_Element[j];
						entsOtherWalls.append(ent);
					}
				}//next j
				// save other walls in map
				if(bDebug)reportMessage("\n"+ scriptName() + " entsOtherWalls.length(): "+entsOtherWalls.length());
				
				mapTsl.setEntityArray(entsOtherWalls, true, "entsOtherWalls", "", "");
				
				entsTsl.append(_Element[i]);
				tslNew.dbCreate("hsbBrick-BrickDistributionInterior" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				if (bDebug)
					reportMessage("\n" + "hsbBrick-BrickDistributionInterior" + (tslNew.bIsValid() ? " ok" : " nok"));
			}//next index
		}
	}
	
//End create butt distributions on dbCreate//endregion 	
#End
#BeginThumbnail
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
'!1110!__V0``






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO">
              <lst nm="TSLINFO">
                <lst nm="TSLINFO" />
              </lst>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End