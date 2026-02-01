#Version 8
#BeginDescription
version  value="4.3" date="18apr12" author="th@hsbCAD.de"
tsl dim accepts also a map entry 'ptRef'


/// new option 'special mode'
///    Default: standard dimension behaviour
///    Openings embraced by genBeams: the size of embraced openings will be dimensioned. potential gaps up to 5mm will be closed






















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 4
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt eine freie Bemassung von Stäben, Platten, Dachflächen, Polylinien, TSL's, Bohrungen
/// </summary>

/// <insert Lang=de>
/// Einfügepunkt und Richtung wählen, anschließend (optional) Punkte und/oder Bemassungsobjekte wählen
/// </insert>

/// <remark Lang=de>
/// bitte beachten Sie die Versionsinformationen in der Dokumenation dieses Befehls
/// </remark>

/// <remark Lang=en>
/// please review the release notes of the documentation
/// </remark>


/// History
///<version  value="4.3" date="18apr12" author="th@hsbCAD.de">tsl dim accepts also a map entry 'ptRef'</version>
///<version  value="4.2" date="12jan12" author="th@hsbCAD.de">bugfix dimsides</version>
/// Version 4.1   th@hsbCAD.de   04.04.2011
/// new option 'special mode'
///    Default: standard dimension behaviour
///    Openings embraced by genBeams: the size of embraced openings will be dimensioned. potential gaps up to 5mm will be closed
/// Version 4.0   th@hsbCAD.de   22.03.2011
/// Entity collection from submap 'Entity[]' added
/// Version 3.9   th@hsbCAD.de   29.11.2010
/// - if the tsl is called without an execution key the dialog will be shown
/// - if the tsl is called dwith an execution key, i.e. ^C^C(hsb_scriptinsert "hsbTslDim" "MyExecutionStyle") no dialog will be shown
/// - any tsl can be dimensioned. the program will try to dimension a published pline from a tsl. if no pline is found it 
///   will dimension the origin of the tsl. in case a certain tsl name is given only this tsl style will be used
/// Version 3.8   th@hsbCAD.de   24.09.2009
/// - new option to display the dimline in modelspace (default is planview of dimenioning plane)
/// Version 3.7   th@hsbCAD.de   30.07.2009
/// - TSL and Drill dimensioning strictly separated.
/// Version 3.6   th@hsbCAD.de   29.05.2009
///    - TSL dimensioning enhanced, new option to choose between tsl's of linked entities and tsl's of a potential
///    linked element
/// Version 3.5   th@hsbCAD.de   25.05.2009
///    - translation
/// Version 3.4   th@hsbCAD.de   23.04.2009
///    - Leserichtung korrigiert
/// Version 3.3   th@hsbCAD.de   23.04.2009
///    - optional filtering vector for auto search tsl's (TSL Name) appended
/// Version 3.2   th@hsbCAD.de   16.04.2009
/// Version 3.1   th@hsbCAD.de   25.03.2009
/// Version 3.0   th@hsbCAD.de   19.09.2008
/// DE   Aliase werden nach 20 Zeichen am nächsten Leerzeichen umgebrochen
/// EN   the description alias will be written in multiple lines if it exceeds 20 characters
/// 
/// DE  erzeugt eine Bemassungslinie
///    - bitte beachten Sie die Versionsinformationen in der Dokumenation dieses Befehls
/// EN  creates a dimension line
///    - please review the release notes of the documentation
/// 
/// 26.03.08  th@hsbCAD.de  linear scale factor introduced, automatic scaling if dependent from one tslInst which contains scalefactor
/// 10.03.08  th@hsbCAD.de  plines from tsl map will be dimensioned
/// 26.10.07  th@hsbCAD.de  automated drill dimensioning included (supported type HSB_ESURFACEDRILL)
///								tsl dimnensioning added
///								drill and tsl dimensioning added to shopdraw
/// 23.10.07  th@hsbCAD.de  group assignment enhanced: the instance will be appended to all groups of selected entities
/// 23.10.07  th@hsbCAD.de  group assignment deleted
/// 30.07.07	th@hsbCAD.de	tsl will be assigned to group of first entity of selection set
/// 26.07.07	th@hsbCAD.de	argument of mirrored read direction forced to be valid
/// 26.07.07	th@hsbCAD.de	bugfix pline
/// 05.07.07	th@hsbCAD.de	executionloops on edit grips = 2
/// 05.12.06	th@hsbCAD.de	entity dependent dimensioning added
/// 27.02.06	th@hsbCAD.de	beams can be dimensioned along it's axis
/// 28.02.06	th@hsbCAD.de	bugfix direct editing

// basics and props
	U(1,"mm");
	double dEps = U(.1);
	String sArNY[] = { T("|No|"), T("|Yes|")};

	String sArDisplayMode[] = {T("|Parallel|"),T("|Perpendicular|"),T("|None|")};
	PropString sDisplayModeDelta(1,sArDisplayMode,T("|Display mode|") + " " + T("|Delta|"));
	PropString sDisplayModeChain(2,sArDisplayMode,T("|Display mode|") + " " + T("|Chain|"));	

	PropString sMirrorDim(3,sArNY,T("|Mirror read direction|"));	
	PropString sDeltaOnTop(7,sArNY,T("|Delta on Top|"));	
	PropString sAlias(4,"",T("|Description Alias|"));
			
	PropInt nColor (0,9,T("|Color|"));	
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));
		
	int nArDimSide[] = {_kLeft, _kRight, _kLeftAndRight,_kCenter};	
	String sArDimSide[] = {T("|Left|"), T("|Right|"), T("|left And right|"),T("|Center|")};	
	
	PropDouble dLinearScale(0,1,T("|Linear Scale Factor|"));
	
	PropString sTslToDim(5,"",T("|TSL Name|"));	
	sTslToDim.setDescription(T("|Separate multiple TSL entries by|") + " ';'");

	String sArAddDims[] = {T("|None|"),T("|Drills|"),  T("|TSL's|"), T("|TSL's also from linked Element|")};
	PropString sAddDims(6,sArAddDims,T("|additional dimpoints|"));	
	PropString sShowInModel(8,sArNY,T("|Show in Modelspace|"));	

// mode property
	String sArSpecialMode[] = {T("|Default|"), T("|Opening embraced by GenBeams|")};
	// 0 = default dim
	// 1 = if the sset contains genbeams which are embracing areas the linesegments of these areas will be dimensioned
	PropString sSpecialMode(9,sArSpecialMode,T("|Mode|"));		
	String sSupportedDxfTypes[] = {"HSB_ESURFACEDRILL"};	

		
// some ints on dim props			
	int nDispDelta = _kDimNone, nDispChain = _kDimNone;
	if (sDisplayModeDelta == sArDisplayMode[0])	
		nDispDelta = _kDimPar;
	else if (sDisplayModeDelta == sArDisplayMode[1])	
		nDispDelta = _kDimPerp;
	if (sDisplayModeChain == sArDisplayMode[0])	
		nDispChain = _kDimPar;
	else if (sDisplayModeChain == sArDisplayMode[1])	
		nDispChain = _kDimPerp;		

	int bDeltaOnTop = sArNY.find(sDeltaOnTop);
	int nAddDims = sArAddDims.find(sAddDims);
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		if (_kExecuteKey=="")
		{
			showDialog(T("|_LastInserted|"));
		}
		else
	// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);		
		
		
		
		_Pt0 = getPoint(T("|Select insertion point|"));
		while (1) {
			PrPoint ssP("\n" + T("|Next point|") + " " + T("(Defines Direction)"),_Pt0); 
			if (ssP.go()==_kOk) // do the actual query
				_PtG.append(ssP.value()); // retrieve the selected point
			break;	
		}
		
		Vector3d vx = _PtG[0] - _Pt0;
		vx.normalize();
		_Map.setVector3d("vx", vx);
		
		if (_PtG.length() < 1)
		{
			eraseInstance();
			return;				
		}
		
		
		_PtG.setLength(0);
		while (1) {
			PrPoint ssP2("\n" + T("Select dim point")); 
			if (ssP2.go()==_kOk) // do the actual query
				_PtG.append(ssP2.value()); // retrieve the selected point	
			else // no proper selection
				break; // out of infinite while	
		}	
		
		
	// store all grips in map
		for (int i = 0; i < _PtG.length(); i++)
			_Map.setVector3d("v" + i, _PtG[i] - _PtW);

	// collect entities
		PrEntity ssE(T("Select entities") + " " + T("(optional)"), Beam());
		ssE.addAllowedClass(Sheet());
		ssE.addAllowedClass(ERoofPlane());				
		ssE.addAllowedClass(Sip());			
		ssE.addAllowedClass(EntPLine());			
		ssE.addAllowedClass(TslInst());
		Entity ents[0];
		if (ssE.go()) 
			ents= ssE.set();
		_Entity.append(ents);

		if (ents.length()>0)
		{
		
			//assignToGroups(ents[0]);
			int nRetVal = getInt(T("Dimpoints of entities on") + " " + sArDimSide + " " + T("(Default = 2)"));
			if (nRetVal < 0 || nRetVal > 3)
				nRetVal = 2;
		
			for (int i = 0; i < ents.length(); i++)
			{
				_Map.setInt("dimSide_" + ents[i].handle(), nRetVal);
			}
		}

		return;	
	}// end bOnInsert
	//_________________________________________________________________________________________________________________________

// declare standards		
	Vector3d vx, vy, vz;
	vx = _Map.getVector3d("vx");
	vz = _ZE;
	vy = vz.crossProduct(vx);
	vx.vis(_Pt0, 1);
	vy.vis(_Pt0, 3);
	vz.vis(_Pt0, 150);	



// on creation set special mode if stored in map
	if (_bOnDbCreated && _Map.hasInt("specialMode"))
	{
		int n = _Map.getInt("specialMode");
		if (n<sArSpecialMode.length())
			sSpecialMode.set(sArSpecialMode[n]);
	}

// ints
	int nShowInModel =sArNY.find(sShowInModel);
	int nSpecialMode = sArSpecialMode.find(sSpecialMode);

// collect entities from map if it has any in the submap Entity[]
	Map mapEnts = _Map.getMap("Entity[]");
	for(int i=0;i<mapEnts.length();i++)
	{
		Entity ent =mapEnts.getEntity(i);
		if (ent.bIsValid() && _Entity.find(ent)<0)
			_Entity.append(ent);	
	}
	 
// control scale factor if only one entity determines dependecy
	if (_Entity.length()==1)
	{
		Entity ent = _Entity[0];
		if (ent.bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst)ent;
			Map map = tsl.map();
			if (map.hasDouble("scale"))
				dLinearScale.set(map.getDouble("scale"))	;
		}	
	}


// control scale factor
	if (dLinearScale<=0)
		dLinearScale.set(1);

// collect tsl entries to array
	String sTslNames[0],sList;
	sList = sTslToDim;
	sList.trimLeft();
	sList.trimRight();	
	while (sList.length()>0 || sList.find(";",0)>-1)
	{
		String sToken = sList.token(0);	
		sToken.trimLeft();
		sToken.trimRight();		
		sToken.makeUpper();
		sTslNames.append(sToken);
		int x = sList.find(";",0);
		sList.delete(0,x+1);
		sList.trimLeft();	
		if (x==-1)
			sList = "";	
	}
	

// add triggers
	String sTrigger[] = {T("|Add Points|"),"   " + T("|Delete Points|"),"   " + T("|Set reference point|"),"   " + T("Mirror Read Direction"), 
		T("|Add entities|"), "   " + T("|Add beams|"),"   " +  T("|Add sheets|"),"   " +  T("|Add roofplanes|"), "   " + T("|Add sips|"), 
		"   " + T("|Add plines|"),"   " + T("|Add Tsl's|"),T("|Remove entities|"),T("|Edit points of entities|")};//, T("Remove Point")
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);


// trigger0: add dim point
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
		int nStartGrip = _PtG.length();
		while (1) {
			PrPoint ssP2("\n" + T("Select dim point")); 
			if (ssP2.go()==_kOk) // do the actual query
				_PtG.append(ssP2.value()); // retrieve the selected point	
			else // no proper selection
				break; // out of infinite while	
		}
		// store all grips in map
		for (int i = nStartGrip; i < _PtG.length(); i++)
			_Map.setVector3d("v" + i, _PtG[i] - _PtW);
	}
// trigger1: delete point
	if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{
		Point3d ptDelete[0];
		while (1) {
			PrPoint ssP("\n" + T("Select points")); 	
			if (ssP.go()==_kOk) // do the actual query
			{
				Point3d ptRef = ssP.value();
				int n;
				double dDist = U(100000);
				for (int i = 0; i < _PtG.length(); i++)
					if (abs(vx.dotProduct(_PtG[i]-ptRef ))< dDist )
					{
						n=i;
						dDist = abs(vx.dotProduct(_PtG[i]-ptRef));
					}	
				if (dDist < U(1000))
				{
					_Map.removeAt("v"+n, TRUE);
					_PtG.removeAt(n);
				}
			}
			else
				break;
		}
	}

// trigger2: set ref point
	if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{
		Point3d ptRef = getPoint(T("|Set reference point|"));
		_Map.setPoint3d("ptRef", ptRef );
	}
	
// trigger3: mirror readdirection
	if (_bOnRecalc && _kExecuteKey==sTrigger[3]) 
	{
		if (sMirrorDim == sArNY[0])
			sMirrorDim.set(sArNY[1]);
		else
			sMirrorDim.set(sArNY[0]);			
	}


// trigger4-10: add entities
	if (_bOnRecalc && (_kExecuteKey==sTrigger[4] || _kExecuteKey==sTrigger[5] || _kExecuteKey==sTrigger[6] || _kExecuteKey==sTrigger[7] || _kExecuteKey==sTrigger[8] || _kExecuteKey==sTrigger[9] || _kExecuteKey==sTrigger[10])) 
	{
		PrEntity ssE;
		if (_kExecuteKey==sTrigger[4])
		{
			ssE = PrEntity(T("Select entities"), Beam());
			ssE.addAllowedClass(Sheet());
			ssE.addAllowedClass(ERoofPlane());				
			ssE.addAllowedClass(Sip());			
			ssE.addAllowedClass(EntPLine());			
			ssE.addAllowedClass(TslInst());	
		}
		if (_kExecuteKey==sTrigger[5])
			ssE = PrEntity(T("Select beams"), Beam());
		else if (_kExecuteKey==sTrigger[6])
			ssE = PrEntity(T("Select sheets"), Sheet());
		else if (_kExecuteKey==sTrigger[7])
			ssE = PrEntity(T("Select roofplanes"), ERoofPlane());
		else if (_kExecuteKey==sTrigger[8])
			ssE = PrEntity(T("Select sips"), Sip());
		else if (_kExecuteKey==sTrigger[9])
			ssE = PrEntity(T("Select plines"), EntPLine());
		else if (_kExecuteKey==sTrigger[10])
			ssE = PrEntity(T("Select Tsl's"), TslInst());

		Entity ents[0];
		if (ssE.go()) 
			ents= ssE.set();		

		_Entity.append(ents);
		if (ents.length()>0)
		{
			//assignToGroups(ents[0]);
			int nRetVal = getInt(T("|Dimpoints of entities on|") + " " + sArDimSide);// + " " + T("|(Default = 2)|"));
			if (nRetVal < 0 || nRetVal > 3)
				nRetVal = 2;
		
			for (int i = 0; i < ents.length(); i++)
			{
				_Map.setInt("dimSide_" + ents[i].handle(), nRetVal);//TH 25.03.2009  nArDimSide[nRetVal]);
				Group grEnt[0];
				grEnt = ents[i].groups();
				for (int g = 0; g < grEnt.length(); g++)	
					grEnt[g].addEntity(_ThisInst, false, ents[i].myZoneIndex(),'D');
		}
		}	
	}
		
// trigger11: remove entities
	if (_bOnRecalc && _kExecuteKey==sTrigger[11]) 
	{
		PrEntity ssE(T("|Select entities|"), Beam());
		ssE.addAllowedClass(Sheet());
		ssE.addAllowedClass(ERoofPlane());		
		ssE.addAllowedClass(Sip());			
		ssE.addAllowedClass(EntPLine());				
		Entity ents[0];
		if (ssE.go()) 
			ents= ssE.set();
		for (int i = 0; i < ents.length(); i++)
		{
			// remove the dimside entry
			if (_Map.hasInt("dimSide_" + ents[i].handle()))
				_Map.removeAt("dimSide_" + ents[i].handle(),TRUE);
			// remove the entity itself
			int n = _Entity.find(ents[i]);		
			if (n>-1)	
				_Entity.removeAt(n);	
		}
	}	
		
	
// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(6);


// ints
	int nMirrorDim = sArNY.find(sMirrorDim);
	// force a valid setting if arguments have not been send proper by optional master tsl
	if (nMirrorDim < 0)
	{
		nMirrorDim = 0;
		sMirrorDim.set(sArNY[0]);		
	}
	
// Display
	Display dp(nColor);
	if (!nShowInModel)
		dp.addViewDirection(vz);	
	dp.dimStyle(sDimStyle, 1/dLinearScale);	


// relocate grip if _Pt0 has moved
	if (_kNameLastChangedProp == "_Pt0")
		for (int i = 0; i < _Map.length(); i++)
			if (_Map.hasVector3d("v" +i) && _PtG.length() > i)
				_PtG[i] =  _PtW + _Map.getVector3d("v" +i);


// store all vectors to grips in map
	for (int i = 0; i < _PtG.length(); i++)
		if (_kNameLastChangedProp == "_PtG" + i)
			_Map.setVector3d("v" + i, _PtG[i] - _PtW);

// check pts in map - if point has been added by hsbTslDimLineAddPoint
	Point3d ptMap[0];
	ptMap = _Map.getPoint3dArray("pts");
	// loop all grips but not _Pt0
	for (int i = 1; i < ptMap.length(); i++)
		if (i > _PtG.length())
		{
			_Map.setVector3d("v" + (i-1), ptMap[i] - _PtW);
			_PtG.append(ptMap[i]);				
		}	
		
// check map if there are points to be removed
	if (_Map.hasPoint3dArray("pts"))
	{
		//delete all grips
		_PtG.setLength(0);
		for (int i = 1; i < ptMap.length(); i++)	
		{
			// remove map entryand referenced vector
			if(_Map.hasInt("remove"+i))
			{
				_Map.removeAt("remove"+i, TRUE);	
				_Map.removeAt("v"+i, TRUE);	
			}
			// append grip and vector to origin
			else
			{
				_Map.setVector3d("v" + (i-1), ptMap[i] - _PtW);
				_PtG.append(ptMap[i]);				
			}	
		}	
		// remove all map grips
		_Map.removeAt("pts", TRUE);		
	}




// dim point collection
	Point3d ptDim[0], ptDimEnts[0], ptDrill[0], ptTsl[0];
	ptDim.append(_PtG);
//Ø

			
// make up a dimline
	DimLine dl(_Pt0, vx, vy);	
	String sTslName= sTslToDim;
	sTslName.makeUpper();

// assign and set dependency
	GenBeam gbSpecialMode[0];
	for (int i = 0; i < _Entity.length(); i++)
	{	
		setDependencyOnEntity(_Entity[i]);
		Entity ent = _Entity[i];
		if (_bOnDbCreated)
		{
			Group grEnt[0];
			grEnt = ent.groups();
			for (int g = 0; g < grEnt.length(); g++)	
				grEnt[g].addEntity(_ThisInst, false, ent.myZoneIndex(),'D');
		}	
		
		if (ent.bIsKindOf(GenBeam()))
			gbSpecialMode.append((GenBeam)ent);
	}


// collect dimpoints from entities
	if (nSpecialMode==0 || gbSpecialMode.length()<1)
	{
		for (int i = 0; i < _Entity.length(); i++)
		{	
			Entity ent = _Entity[i];
			int n = 2;
			String sHandle = ent.handle();
			// check mapped dimside
				if (_Map.hasInt("dimSide_"+sHandle ))
					n = _Map.getInt("dimSide_"+sHandle);
			
			if (ent.bIsKindOf(Beam()))
			{
				Beam bmDim[0];	
				bmDim.append((Beam)ent);
				if (bmDim.length() > 0)
				{
					if (bmDim[0].vecX().isParallelTo(vx))
					{
						Point3d ptExtr[] = bmDim[0].realBody().extremeVertices(vx);	
						if ((n == 0 || n==2) && ptExtr.length() >0)// left or leftandright
							ptDimEnts.append(ptExtr[0]);	
						if ((n == 1 || n==2) && ptExtr.length() >0)// left or leftandright
							ptDimEnts.append(ptExtr[ptExtr.length()-1]);
						if ((n == 3) && ptExtr.length() >0)// left or leftandright
							ptDimEnts.append((ptExtr[0] + ptExtr[ptExtr.length()-1])/2);
					}				
					else
					{
						if (n > 3)´
						{
							ptDimEnts.append(dl.collectDimPoints(bmDim, 2));	
							ptDimEnts.append(dl.collectDimPoints(bmDim, 3));	
						}
						else
							ptDimEnts.append(dl.collectDimPoints(bmDim, nArDimSide[n]));	
						
					}
				}
			}	
			else if (ent.bIsKindOf(Sheet()))
			{
				Sheet shDim[0];	
				shDim.append((Sheet)ent);
				ptDimEnts.append(dl.collectDimPoints(shDim, nArDimSide[n]));
			}			
			else if (ent.bIsKindOf(Sip()))
			{
				Sip sipDim[0];	
				sipDim.append((Sip)ent);
				ptDimEnts.append(dl.collectDimPoints(sipDim, nArDimSide[n]));
			}	
			else if (ent.bIsKindOf(ERoofPlane()))
			{
				ERoofPlane erp=(ERoofPlane)ent;
				PLine plDim[0];
				plDim.append(erp.plEnvelope());	
				ptDimEnts.append(dl.collectDimPoints(plDim, nArDimSide[n]));
			}	
			else if (ent.bIsKindOf(EntPLine()))
			{
				EntPLine epl=(EntPLine)ent;
				PLine plDim[0];
				plDim.append(epl.getPLine());	
				ptDimEnts.append(dl.collectDimPoints(plDim, nArDimSide[n]));
			}	
			else if (ent.bIsKindOf(TslInst()))
			{
				TslInst tsl=(TslInst)ent;
				Map map = tsl.map();
				Point3d pt = tsl.ptOrg();
				Map mapPl = map.getMap("plines");
				
			// three dim approaches possible
			// #1 the tsl publishes a ref point to dim
				if(map.hasPoint3d("ptRef")) 
				{
					pt = map.getPoint3d("ptRef");
					ptDimEnts.append(pt);
				}
			// #2 the tsl publishes a pline to be dimensioned	
				else if (mapPl.length()>0)
				{
					PLine plDim[0];
					for (int p = 0; p < mapPl.length();p++)
						if (mapPl.hasPLine("pline"+p))
							plDim.append(mapPl.getPLine("pline"+p));	
					ptDimEnts.append(dl.collectDimPoints(plDim, nArDimSide[n]));
				}
			// #3 no defining plines found, collect all _Pt0's of selected tsl	
				else if ((sTslToDim!="" && tsl.scriptName().makeUpper()==sTslName) || sTslName=="")
				{
				// default takes origin
					Point3d pt = tsl.ptOrg();
				// if ref point is set replace origin
					if(map.hasPoint3d("ptRef")) pt = map.getPoint3d("ptRef");
					ptDimEnts.append(pt);
				}	
			}	
			else if (ent.typeDxfName() == "3DSOLID")
			{
				Point3d ptExtr[] = ent.realBody().extremeVertices(vx);	
				if ((n == 0 || n==2) && ptExtr.length() >0)// left or leftandright
					ptDimEnts.append(ptExtr[0]);	
				if ((n == 1 || n==2) && ptExtr.length() >0)// left or leftandright
					ptDimEnts.append(ptExtr[ptExtr.length()-1]);
				if ((n == 3) && ptExtr.length() >0)// left or leftandright
					ptDimEnts.append((ptExtr[0] + ptExtr[ptExtr.length()-1])/2);
			}
			
			
					
			if (ent.bIsKindOf(GenBeam()))
			{	
				GenBeam gb = (GenBeam)ent;
				TslInst tsl[0];
				// collect drill dimpoints from toolents
				Entity entTool[] = gb.eToolsConnected();
				for(int t=0; t<entTool.length(); t++)
				{
					String sToolDxfName = entTool[t].typeDxfName();	
					if (sSupportedDxfTypes.find(sToolDxfName)>-1 && nAddDims==1)
					{
						ToolEnt tent = (ToolEnt)entTool[t];
						if (tent.bIsValid())
							ptDrill.append(tent.ptOrg());
						Map map = entTool[t].getAutoPropertyMap();
						dp.showInShopDraw(ent);
					}
					else if (entTool[t].bIsKindOf(TslInst()))
						tsl.append((TslInst)entTool[t]);
				}
						
				// collect also tsl's which are linked to a linked element
				Element elTest = gb.element();
				if (elTest.bIsValid() && nAddDims==3)
					tsl.append(elTest.tslInstAttached());
				for(int t=0; t<tsl.length(); t++)
				{
					String myName = tsl[t].scriptName();	
					myName.makeUpper();
					for(int s=0; s<sTslNames.length(); s++)
					{
						if (sTslNames[s]==myName)
						{
							if (tsl[t].map().hasVector3d("normal"))
							{
								Vector3d vecNormal;
								vecNormal=	tsl[t].map().getVector3d("normal");
								if (!vecNormal.isParallelTo(vy))
									continue;	
							}
							ptTsl.append(tsl[t].ptOrg());
							dp.showInShopDraw(ent);
						}
					}
				}
			}
		}	
	}// end special mode == 0

// special mode  embraced contour
	else
	{
		double dMergeTol = U(5);
		PlaneProfile ppShadow (CoordSys(_Pt0,vx,vy,vz));
		for(int g=0; g<gbSpecialMode.length(); g++)	
		{
			Body bd = gbSpecialMode[g].realBody();
			PlaneProfile pp=bd.shadowProfile(Plane(gbSpecialMode[g].ptCen(),vz));
			pp.shrink(-dMergeTol );
			if (ppShadow.area()<pow(dEps,2))
				ppShadow=pp;
			else
				ppShadow.unionWith(pp);
		}
		ppShadow.shrink(dMergeTol);
		ppShadow.vis(2);
		
	// collect openings
		PLine plRings[] = ppShadow.allRings();
		int bIsOp[]=ppShadow.ringIsOpening();
		for(int r=0; r<plRings.length(); r++)	
			if (bIsOp[r])
			{
				LineSeg ls = PlaneProfile(plRings[r]).extentInDir(vx);
				ls.vis(3);
				ptDimEnts.append(ls.ptStart());
				ptDimEnts.append(ls.ptEnd());	
			}
	}



	
// trigger12: edit points of entities
	if (_bOnRecalc && _kExecuteKey==sTrigger[12]) 
	{
		// convert all entity dimpoints to grips
		for (int i = 0; i < ptDimEnts.length();i++)
		{
			_PtG.append(ptDimEnts[i]);
			_Map.setVector3d("v" + _PtG[_PtG.length()-1], _PtG[_PtG.length()-1] - _PtW);
		}
		//ptDimEnts.setLength(0);
		
		// remove all entities
		Entity ents[0];
		ents = _Entity;
		for (int i = 0; i < ents.length(); i++)
		{
			// remove the dimside entry
			if (_Map.hasInt("dimSide_" + ents[i].handle()))
				_Map.removeAt("dimSide_" + ents[i].handle(),TRUE);
			// remove the entity itself
			int n = _Entity.find(ents[i]);		
			if (n>-1)	
				_Entity.removeAt(n);	
		}
		
		// ensure that it will be updated
		setExecutionLoops(2);
	}	
// end trigger 12

	
// append all entity dimpoins	
	ptDim.append(ptDimEnts);
	
	
// order dim points if no grips are given
	if (_PtG.length() < 1 && !_Map.hasPoint3d("ptRef"))
		ptDim = Line(_Pt0,vx).orderPoints(ptDim);	
	// reference point is given
	else if(_Map.hasPoint3d("ptRef") && ptDim.length() > 0)
	{
		Point3d ptRef = _Map.getPoint3d("ptRef");
		int n;
		double dDist = U(100000);
		for (int i = 0; i < ptDim.length(); i++)
			if (abs(vx.dotProduct(ptDim[i]-ptRef))< dDist )
			{
				n=i;
				dDist = abs(vx.dotProduct(ptDim[i]-ptRef));
			}
		Point3d ptTmp = ptDim[0];
		ptDim[0] = ptDim[n];
		ptDim[n] = ptTmp ;		
	}

// append drills and tsl's
	if(nAddDims == 1 || nAddDims == 2)
		ptDim.append(ptDrill);	
	if(nAddDims == 2 || nAddDims == 3 || nAddDims == 4)
		ptDim.append(ptTsl);		
	
//the dimline	
	Dim dim= Dim(dl,  ptDim, "<>",  "<>",nDispDelta,nDispChain);
	Vector3d vRead = -vx+vy;

// the reading vectors
	Vector3d vxRead=vx, vyRead=vy;	
	if (_XE.dotProduct(vxRead)<0)vxRead*=-1;
	if (_YE.dotProduct(vyRead)<0)vyRead*=-1;
	vxRead.vis(_Pt0,1);
	vyRead.vis(_Pt0,3);	
	vRead = vxRead+vyRead; 
	
	/*double dX = vx.dotProduct(_XE);
	double dY = vx.dotProduct(_YE);	
	
	if (dX < 0 && dY > 0)
		vRead = vx-vy;
	else if (dX < 0 && dY < 0)
		vRead = -vx-vy;	
	else if (dX > 0 && dY == 0)
		vRead = -vx+vy;	
	else if (dX == 0 && dY == 1)
		vRead = vx+vy;
	else if (dX > 0 && dY > 0)
		vRead = vx+vy;*/
	if (nMirrorDim)
	{
		CoordSys csMirr;
		csMirr.setToMirroring(Line(_Pt0,vx));
		vRead.transformBy(csMirr);
		//vRead = -vRead ;
	}
	vRead.vis(_Pt0,1);
	dim.setReadDirection(vRead);
	dim.setDeltaOnTop(bDeltaOnTop);	
	dp.draw(dim);



// description alias
	int nXAlign=-1, nYAlign=0;
//	if (vx.dotProduct(_Pt0 - _PtG[0]) < 0)
//		nXAlign = 1;
	nXAlign = 1;
	if (sAlias.length()> 0 && sAlias.length()< 20)
		dp.draw(sAlias, _Pt0, vx, vy, nXAlign,0,_kDevice);	
	else
	{
		// separate the string to be displayed in multiple lines
		String sArAlias[0];
		String sRest = sAlias;
		int nChars = 	sRest.length();
		int nMinChar = 20;
		while (nChars>0)
		{
			// find next space
			int nSpace = sRest.find(" ",nMinChar);
			nMinChar = nSpace;
			if (nSpace<0)
			{
				sArAlias.append(sRest);
				sRest = "";
			}
			else
			{
				sArAlias.append(sRest.left(nSpace));
				sRest = sRest.right(sRest.length()-nSpace-1);
			}
			nChars = 	sRest.length();
		}
		
		
		for (int i = 0; i < sArAlias.length(); i++)
		{
			double d = .5*(sArAlias.length()-1)*3-i*3;
			dp.draw(sArAlias[i], _Pt0, vx, vy, nXAlign,d,_kDevice);	
		}
		
		
	}
	
// debug
	for (int p = 0; p < _PtG.length(); p++)
		_PtG[p].vis(p);	
		
		
//assignToMapGroups
	for (int i = 0; i < _Map.length(); i++)
		if (_Map.hasString("gr"+i))
		{
			Group gr(_Map.getString("gr"+i))	;
			gr.addEntity(_ThisInst, false,0, 'D');	
		}

		
//on debug
	if (_bOnDebug)
	{
		dp.textHeight(U(20));
		dp.color(5);
		dp.draw("X" + vx.dotProduct(_XW), _Pt0 - vx * U(50), _XW,_YW,0,0,_kDeviceX);
		dp.draw("Y" + vx.dotProduct(_YW), _Pt0- vx * U(50), _XW,_YW,0,-3,_kDeviceX);
	}






























#End
#BeginThumbnail
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
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`Y^1
M%LO%<,BJH^U(48CKZ\_E705@WBFZ\2V<8!'D9<D-C(Q_CBMZ@`HHHH`*P=&!
M?5]1N.H>0C/TX_I6]6#X=(C:\MVD9Y(YB"6')^M`&]1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%,D8)&S$X`&2:`,/2MMQKEY<@L1&H1<G@9//\`*M^L708P
MIO9,?,TN,@YR`./YUM4`%%%%`!7/:4#%XAU1)'R[/D`GMC(_0UT-<_$1_P`)
M=."/FV#D'MM'7]:`.@HHHH`****`"LF;Q%I-M*8IKU$D&<J0>,?A6M7F]WIB
MW%O)J!0.?,VR''?UX]\C\JF<G%70XJ[L=@WB72!`9A>*T8ZE5)QSCTXJF?&&
MG,9!#N?9G!)"@_\`UJXQ;:%3D1C-2!%4Y"@5A[=]C3V:.QB\1RR*K+ILC(3]
MZ-PPQG'IS_\`6I[^*;*"=8KI9+<D9!<#^77%<92%%)R5!H]N^P>S._M]?TFZ
M!\J_@)'4%L$?@:23Q!I4<>_[:C)C.Z,%Q^8!KSQK2%L_(,GJ::;*`H5\L=*/
M;OL'LSU&RO(+^U2YMG\R%\[6P1G!QW^E6:P/#*"SM9=-RW^C-\N_@X/_`-?/
MYUOUTF04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`#6947+$`>IJ
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
M9"\SS3MQ]Y\?RQF@"T=6L]P`E4CU!'%,FUW3H`I:X7!.!@U.-,L5;(M(@?78
M*3^RK#C-E`<#'*`T`)%JMG)MQ,HW?=R>M/&HVAE\L3J7SC`J.72+"50#;(I7
MH4^4C\13#H6G'GR#G.<[VS_.@"[]HAZ>:GYU7FU.T@<*TRY)QP>E5/\`A&M,
MW;C'(6QC/FM_C4L>AZ=%&R"V#!N"78L?S)XH`O17$4P!C<-D9&*EK#E\/JKA
MK.ZD@P1\G5<#M3%37[5/^6%QS_"V"1^-`&_16'G7I=PV11+C^)AG]*:NE:K*
MFVXU-0">0B9Q]":`-DS1*VTR*".V::MW`Q($J\>O%9@\.V[2;IKFYE&,;2^!
M^GUJ0^'=.(P(I`?42L/ZT`:/VF#_`)ZI^=*LT3G"R*3Z`UBR>%K&0Y1[F+C&
M%E./UYI8O#44(PE[=#WW#G]*`-S</45$\T0#*9%!],UFKH(4Y%_=?BP_PJ)O
M"]I+)OGN+J0]_GQD>AQ0`[P^JC[<V/F,Y!/<\5MU4LM/M[!'2W5@KG<=S%N?
MQJW0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
$4`?_V110
`







#End
