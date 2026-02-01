#Version 8
#BeginDescription
This tsl displays a truck definition and offers methods to maintain truck definitions

#Versions
Version 1.0 17.01.2023 HSB-17564 initial version of truck definition
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.0 17.01.2023 HSB-17564 initial version of truck definition , Author Thorsten Huck

/// <insert Lang=en>
/// Pick insertion point. If no truck definitions are present as style toggle to edit mode via context menu and create a style
/// </insert>

// <summary Lang=en>
// This tsl displays a truckDefinition and offers methods to maintain truck definitions
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TruckDefinition")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Save Definitio|") (_TM "|Select truck definition|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Definition|") (_TM "|Select truck definition|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Load Profile|") (_TM "|Select truck definition|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set truck display|") (_TM "|Select truck definition|"))) TSLCONTENT

//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String tLastInserted =T("|_LastInserted|");
	String tDefault =T("|_Default|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	String kJigInsert = "JigInsert", kJigDrawRectangle= "JigDrawRectangle", kProperties = "Properties", kTruckData="truckData",
		tEditDefinition = T("|Edit Definition|");
	double dXDefault = U(13600);
	double dYDefault = U(2480);
	double dZDefault = U(2700);

	String sDefinitions[] = TruckDefinition().getAllEntryNames().sorted();
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("EditTruck");	

		category = T("|Category|");
			String sDefinitionName=T("|Truck Definition|");	
			PropString sDefinition(nStringIndex++, "", sDefinitionName);	
			sDefinition.setDescription(T("|Defines the Definition|"));
			sDefinition.setCategory(category);

		category = T("|Geometry|");
			String sLengthName=T("|Length|");	
			PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
			dLength.setDescription(T("|Defines the Length|"));
			dLength.setCategory(category);
			
			String sWidthName=T("|Width|");	
			PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
			dWidth.setDescription(T("|Defines the Width|"));
			dWidth.setCategory(category);
			
			String sHeightName=T("|Height|");	
			PropDouble dHeight(nDoubleIndex++, U(0), sHeightName);	
			dHeight.setDescription(T("|Defines the Height|"));
			dHeight.setCategory(category);
			
		category = T("|Load Definitions|");
			String sTaraName=T("|Tara|");	
			PropDouble dTara(nDoubleIndex++, U(0), sTaraName,_kNoUnit);	
			dTara.setDescription(T("|Defines the Tara of the truck|"));
			dTara.setCategory(category);
			
			String sMaxGrossName=T("|Gross Weight|");	
			PropDouble dMaxGross(nDoubleIndex++, U(0), sMaxGrossName,_kNoUnit);	
			dMaxGross.setDescription(T("|Defines the max gross weight|"));
			dMaxGross.setCategory(category);
			
		}			
		return;		
	}
//End DialogMode//endregion

//Part #1 //endregion

//region Part #2

//region Functions
// Creates a planeprofile parallel to _ZW wih a given offset
	PlaneProfile createProfile(Point3d pt1, Point3d pt2, double offset)
	{ 
		CoordSys cs();
		cs.transformBy(_ZW * offset);
		PlaneProfile pp(cs);
		PLine pl;
		pl.createRectangle(LineSeg(pt1, pt2), _XW, _YW);
		pp.joinRing(pl, _kAdd);
		return pp;
	}
	
// get loading volumes from a loading plane by extruding it	
	Body[] getLoadVolumes(PlaneProfile pp, Point3d ptCut)
	{ 
		Body bodies[0];	
//		for (int i=0;i<pps.length();i++) 
//		{ 
//			PlaneProfile pp= pps[i]; 
//			//pp.transformBy(cs);
//			dp.draw(pp, _kDrawFilled);
//			dp.draw(pp);
			
			CoordSys csp = pp.coordSys();
			int bCut = _ZW.dotProduct(ptCut - csp.ptOrg()) > dEps;
			
			PLine rings[] = pp.allRings(true, false);
			
			for (int r=0;r<rings.length();r++) 
			{ 
				Body bd (rings[r],_ZW*U(10e5),1); 
				if (bCut)	bd.addTool(Cut(ptCut, _ZW), 1);
				bodies.append(bd); 
			}//next r
			
//		}//next i
		return bodies;
	}
	
// get the combined planeprofile of all loading volumes on a given face	
	PlaneProfile getVolumeFace(Body bodies[], int face, Quader qdr)
	{ 
		Vector3d vecDir = qdr.vecX();
		if (face == 1)vecDir *= -1;
		else if (face == 2)vecDir =qdr.vecY();
		else if (face == 3)vecDir =-qdr.vecY();
		else if (face == 4)vecDir =qdr.vecZ();
		
		Plane pnFace = qdr.plFaceD(vecDir);
		PlaneProfile ppX;
		for (int i=0;i<bodies.length();i++) 
		{ 
			PlaneProfile pp =bodies[i].extractContactFaceInPlane(pnFace, dEps);
			pp.shrink(-dEps);
			if (ppX.area() < pow(dEps, 2))
				ppX = pp;
			else 
				ppX.unionWith(pp);
			 
		}//next i
		ppX.shrink(dEps);
		return ppX;
	}
	
	EntPLine[] createEntPLine(PlaneProfile pp, int bIsOpening)
	{ 
		EntPLine epls[0];
		PLine rings[] = pp.allRings(!bIsOpening, bIsOpening);
		for (int r=0;r<rings.length();r++) 
		{ 
			EntPLine epl;
			epl.dbCreate(rings[r]);
			if (epl.bIsValid())
			{ 
				epl.setTrueColor(bIsOpening?lightblue:grey);
				epls.append(epl);
			} 
		}//next r	
		return epls;
	}	
	
	
//endregion

//region Properties
	String sDefinitionName=T("|Truck Definition|");	
	PropString sDefinition(nStringIndex++, sDefinitions, sDefinitionName);	
	sDefinition.setDescription(T("|Defines the Definition|"));
	sDefinition.setCategory(category);	
	
	String sDescriptionName=T("|Description|");	
	PropString sDescription(nStringIndex++, "", sDescriptionName);	
	sDescription.setDescription(T("|Defines the description of the truck|"));
	sDescription.setCategory(category);

category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
//End Properties//endregion 

//region JIG
// Jig Insert
	int bJig;
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	    _Pt0 = ptJig;
		_ThisInst.setPropValuesFromMap(_Map.getMap(kProperties));
		bJig = true;
	}
//	else if (_bOnJig && _kExecuteKey==kJigDrawRectangle) 
//	{
//	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
//	    Point3d pt1 = _Map.getPoint3d("pt1");
//		PlaneProfile pp = createProfile(pt1, ptJig, _Map.getDouble("elevation"));
//
//		Display dp(-1);
//		dp.trueColor(darkyellow, 60);
//		dp.draw(pp);
//		dp.draw(pp, _kDrawFilled);
//		return;
//	}
	else if (_bOnJig && _kExecuteKey == kJigDrawRectangle)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Vector3d vecX = _Map.getVector3d("vecX");
		
		if (pts.length()>1)
		{ 
			Point3d pt1=pts[0], pt2=pts[1];
			pt1 = pts[0];
			pt2 = pts[1];

			Line lnX(pt1, vecX);
			Vector3d vecY = ptJig-lnX.closestPointTo(ptJig);
			vecY.normalize();
			Vector3d vecZ = vecX.crossProduct(vecY);
			if (!vecZ.isPerpendicularTo(_ZW) && vecZ.dotProduct(_ZW)<0)
			{ 
				vecX *= -1;
				vecZ *= -1;
			}

			PlaneProfile pp; pp.createRectangle(LineSeg(pt1, ptJig), vecX, vecY);
			
			Display dp(-1);
			dp.trueColor(darkyellow, 60);
			dp.draw(pp);
			dp.draw(pp, _kDrawFilled);
		}
		return;
	}

//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();

	//region Show Jig
		PrPoint ssP(T("|Select location|"));
	    Map mapArgs;
		mapArgs.setMap(kProperties, mapWithPropValues());
	    int nGoJig = -1;
	    while (nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
  
	        if (nGoJig == _kOk)
	        {
	            Point3d pt = ssP.value(); //retrieve the selected point
				
			// create TSL
				TslInst tslNew;				Map mapTsl;
				int bForceModelSpace = true;	
				String sExecuteKey,sCatalogName = tLastInserted;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
			
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
				
				if (sDefinitions.find(sDefinition)<0) // do not insert multiple times when no definition found
					break;
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }			
	//End Show Jig//endregion 

		eraseInstance();
		return;
	}			
//endregion 

//Part #2 //endregion

//region Defaults
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Point3d ptOrg = _Pt0;
	CoordSys cs = CoordSys(ptOrg, vecX, vecY, vecZ);
	CoordSys csInv = cs;
	csInv.invert();
	
	Display dp(-1);
	dp.dimStyle(sDimStyle);
	double textHeight = dTextHeight;
	if (textHeight>0)dp.textHeight(textHeight);
	else textHeight = dp.textHeightForStyle("O", sDimStyle);
	
	TruckDefinition td(sDefinition);
	int bValid = sDefinitions.findNoCase(sDefinition ,- 1) >- 1 && td.bIsValid();
	Quader qdr = td.quader();
	qdr.transformBy(cs);
	double dX = bValid?td.length():dXDefault;
	double dY = bValid?td.width():dYDefault;
	double dZ = bValid?td.height():dZDefault;
	
	Map mapTruckData;
	PlaneProfile pps[0]; 
	if (bValid)
	{
		pps= td.loadProfiles();
		setDependencyOnDictObject(td);
		mapTruckData = td.subMapX(kTruckData);
		_ThisInst.setSubMapX(kTruckData, mapTruckData);
	}
	else // show some kind of default
	{ 
		qdr = Quader(_Pt0, vecX, vecY, vecZ, dX, dY, dZ, 1 , 0, 1);
		PlaneProfile pp;
		pp.createRectangle(LineSeg(_Pt0 - vecY * .5 * dY, _Pt0 + vecX * dX + vecY * .5 * dY), vecX, vecY);
		pp.transformBy(csInv);
		pps.append(pp);
		
		dp.trueColor(red);
		String text = scriptName() + " " + sDefinition;
		text += "\n" + T("|No truck definitions found.|");
		text += "\n" + T("|Please import truck definition styles or create a definition using context command|\n'" + tEditDefinition + "'");
		
		double x = dp.textLengthForStyle(text, sDimStyle, textHeight);
		double y = dp.textHeightForStyle(text, sDimStyle, textHeight);
		
		if (x>0 && y>0)
		{ 
			double d1 = (dXDefault-2*textHeight) / x;
			double d2 = (dYDefault-2*textHeight) / y;	
			double f = d1 < d2 ? d1 : d2;
			dp.textHeight(f*textHeight);
		}
	
		dp.draw(text, ptOrg+vecX*textHeight, vecX, vecY, 1, 0);
		
		
		
	}
	double dTara = mapTruckData.getDouble("Tara");
	double dGros = mapTruckData.getDouble("GrosWeight");
	
//endregion

//region Edit Mode
	int bEditDefinition = _Map.getInt("EditDefinition");
// TriggerEditDefinition	
	String sTriggerEditDefinition =bEditDefinition?T("|Save Definition|"):tEditDefinition;
	addRecalcTrigger(_kContextRoot, sTriggerEditDefinition);
	if (_bOnRecalc && _kExecuteKey==sTriggerEditDefinition)
	{
		bEditDefinition = bEditDefinition ? false : true;
		_Map.setInt("EditDefinition", bEditDefinition);	
		
		if (bEditDefinition)
		{
		// create Dialog instance
			TslInst tslDialog;			Map mapTsl;
			GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

			mapTsl.setInt("DialogMode", 1);
			sProps.append(sDefinition);

			dProps.append(dX);
			dProps.append(dY);
			dProps.append(dZ);

			dProps.append(dTara);
			dProps.append(dGros);

			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					String definition = tslDialog.propString(0);
					
					dX = tslDialog.propDouble(0);
					dY = tslDialog.propDouble(1);
					dZ = tslDialog.propDouble(2);
					
					dTara= tslDialog.propDouble(3);
					dGros= tslDialog.propDouble(4);
					
					mapTruckData.setDouble("Tara", dTara);
					mapTruckData.setDouble("GrosWeight", dGros);
	
				// truck definition exists	
					TruckDefinition td(definition);
					// new definition
					if (sDefinitions.find(definition) < 0)
					{
						td.dbCreate();
						sDefinition.set(definition);
					}
					td.setLength(dX);
					td.setWidth(dY);
					td.setHeight(dZ);	
				
					td.setSubMapX(kTruckData, mapTruckData);
					
				}
				tslDialog.dbErase();
			}
		}
	}

//region Collect defining load plines and reassign to load profiles
		
// Collect entPLines from _Map	
	EntPLine epls[0];
	Entity ents[] = _Map.getEntityArray("Entity[]", "", "Entity");
	for (int i=0;i<ents.length();i++) 
	{ 
		EntPLine epl = (EntPLine)ents[i];
		if (epl.bIsValid())
			epls.append(epl);		 
	}//next i
	int bHasEpl = epls.length() > 0;

// create definining polylines from loadProfiles
	if (bEditDefinition && epls.length()<1)
	{ 
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp= pps[i]; 
			pp.transformBy(cs);
			epls.append(createEntPLine(pp, false));
		}//next i	
		_Map.setEntityArray(epls, true,"Entity[]", "", "Entity");
	}
	
// collect defining envelopes and openings	
	PLine plEnvelopes[0], plOpenings[0];
	for (int i=0;i<epls.length();i++) 
	{ 
		EntPLine epl = (EntPLine)epls[i];
		_Entity.append(epl);
		setDependencyOnEntity(epl);
		
		int bIsOpening = epl.trueColor() == lightblue;
		
		PLine pl = epl.getPLine();
		pl.transformBy(csInv);
		if (bIsOpening)
			plOpenings.append(pl);
		else
			plEnvelopes.append(pl);
	}//next i
	
// rebuild profiles from envelopes and openings	
	PlaneProfile pps2[0];
	for (int i=0;i<plEnvelopes.length();i++) 
	{ 
		PlaneProfile pp(plEnvelopes[i]);
		pps2.append(pp);		 
	}//next i
	for (int i=0;i<pps2.length();i++) 
	{ 
		CoordSys csi = pps2[i].coordSys();
		for (int j=0;j<plOpenings.length();j++) 
		{ 
			CoordSys csj = plOpenings[j].coordSys();
			if (csi.vecZ().isCodirectionalTo(csj.vecZ()))//TODO check offset
			{ 
				pps2[i].joinRing(plOpenings[j], _kSubtract);
			}		 
		}//next i			
	}

// Update and Store
	if (pps2.length()>0)
	{
		pps = pps2;			
		if (bEditDefinition && !bHasEpl)
		{ 
			pushCommandOnCommandStack("HSB_RECALC");
 			pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");	
 			pushCommandOnCommandStack("(Command \"\")");
		}
		else if(!bEditDefinition)
		{ 
			td.setLoadProfiles(pps);
			for (int i=epls.length()-1; i>=0 ; i--) 
			{ 
				EntPLine e = epls[i];
				
				if (e.bIsValid())
				{
					int n = _Entity.find(e);
					if (n >- 1)_Entity.removeAt(n);
					e.dbErase(); 
				}
			}//next i
			_Map.removeAt("Entity[]", true);
		}
	}
// End Collect defining load plines //endregion 

//region Edit Trigger

	if (bEditDefinition)
	{ 
	
	//region TriggerAddLoadProfile
		String sTriggerAddLoadProfile = T("|Add Load Profile|");
		addRecalcTrigger(_kContextRoot, sTriggerAddLoadProfile );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddLoadProfile)
		{
			Point3d pts[0];
		// prompt for point input
			PrPoint ssP(TN("|Pick first point|") + T(", |<Enter> to select existing polylines|")); 
			if (ssP.go()==_kOk) 
			{
				pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG

				ssP = PrPoint (TN("|Pick second point on axis|"),pts.first()); 
				if (ssP.go()==_kOk) 
				{
					pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG
				
					Vector3d vecX1 = pts[1] - pts[0];
					vecX1.normalize();
	
					ssP = PrPoint (T("|Select second point|"));// [RotateX]
				    Map mapArgs;
				    mapArgs.setPoint3dArray("pts", pts);
				    mapArgs.setVector3d("vecX", vecX1);
				    
				    int nGoJig = -1;
				    while (nGoJig != _kOk && nGoJig != _kNone)
				    {
				        nGoJig = ssP.goJig(kJigDrawRectangle, mapArgs); 
				        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
				        
				        if (nGoJig == _kOk)
				        {
				            pts.append(ssP.value()); //retrieve the selected point
				        }
				        else if (nGoJig == _kKeyWord)
				        { 
				            if (ssP.keywordIndex() == 0)
				                mapArgs.setInt("isLeft", TRUE);
				        }
				        else if (nGoJig == _kCancel)
				        { 
				            return; 
				        }
				    }
	
					if (pts.length()>2)
					{ 
						Line lnX(pts[0], vecX1);
						Vector3d vecY1 = pts[2]-lnX.closestPointTo(pts[2]);
						vecY1.normalize();
						Vector3d vecZ1 = vecX1.crossProduct(vecY1);
						if (!vecZ1.isPerpendicularTo(_ZW) && vecZ1.dotProduct(_ZW)<0)
						{ 
							vecX1 *= -1;
							vecZ1 *= -1;
						}
						
						PLine pl; pl.createRectangle(LineSeg(pts[0], pts[2]), vecX1, vecY1);
						if (pl.area()>pow(dEps,2))
						{ 
							EntPLine epl;
							epl.dbCreate(pl);
							epl.setTrueColor(grey);
							_Entity.append(epl);
							
							epls.append(epl);
							_Map.setEntityArray(epls, true,"Entity[]", "", "Entity");
						}
					}
				}
			}
		// Select existing polylines	
			else
			{ 
			// prompt for polylines
				Entity ents[0];
				PrEntity ssEpl(T("|Select polylines|"), EntPLine());
			  	if (ssEpl.go())
					ents.append(ssEpl.set());
					
			// Remove duplicates
				for (int i=ents.length()-1; i>=0 ; i--) 
				{ 
					EntPLine epl = (EntPLine)ents[i];
					if (!epl.bIsValid() || epls.find(epl)>-1)
					{
						ents.removeAt(i); 
						continue;
					}
					epls.append(epl);
				}//next i
				
			// Append
				_Entity.append(ents);
				_Map.setEntityArray(epls, true,"Entity[]", "", "Entity");			
			}

			setExecutionLoops(2);
			return;
		}//endregion	

		String sTriggerDefineDisplay = T("|Set truck display|");
		addRecalcTrigger(_kContextRoot, sTriggerDefineDisplay );
		if (_bOnRecalc && _kExecuteKey == sTriggerDefineDisplay )
		{
			Display adp(-1);
			adp.showInTslInst(0);
			td.setDisplay(adp);
			//adp.draw("Test tekst", _Pt0, _XU, _YU, 0, 0);
			
			PrEntity ssE(T("|Select a set of body entities that define the graphical representation of the truck|"), Entity());
			if (ssE.go()) 
			{
				Entity ents[] = ssE.set();
				for (int e = 0; e < ents.length(); e++)
				{ 
					Body body = ents[e].realBody();
					
					if (body.isNull())
						continue;
					body.transformBy(csInv);	
					adp.draw(body);
				}
			}
			
			td.setDisplay(adp);
			setExecutionLoops(2);
			return;
		}			
	}

//endregion 

//End Edit Mode //endregion 

//region Truck Definition Mode

//region Draw Loading Profiles
	Body bdVolumes[0];
	Point3d ptTop = _Pt0 + vecZ * dZ;
	dp.trueColor(bEditDefinition?darkyellow:grey, bEditDefinition?50:80);
	for (int i=0;i<pps.length();i++) 
	{ 
		PlaneProfile pp= pps[i]; 
		pp.transformBy(cs);
		dp.draw(pp, _kDrawFilled);//bEditDefinition?_kDrawFilled:0);
		dp.draw(pp);
		
	// get loadable volume	
		bdVolumes.append(getLoadVolumes(pp, ptTop)); // must cut at top	
	}//next i
//endregion 


//region Draw Loadable Volume
	int nFaces[] ={ _kXP, _kXN, _kYP, _kYN};
	for (int i=0;i<nFaces.length();i++) 
	{ 
		PlaneProfile pp = getVolumeFace(bdVolumes, nFaces[i], qdr);
		dp.draw(pp);		 
	}//next i		
//endregion 

	//dp.color(1);
	dp.transparency(0);
	dp.draw(td, cs);
	
//endregion 





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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17564 initial version of truck definition" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="1/17/2023 11:04:29 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End