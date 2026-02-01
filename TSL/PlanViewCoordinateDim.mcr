#Version 8
#BeginDescription
#Versions
Version 1.0    07.06.2021    HSB-10714 initial version , Author Thorsten Huck


This tsl creates plan view coordinate dimension tags
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
// 1.0 07.06.2021 HSB-10714 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select a paperspace viewport and select a reference method
/// </insert>

// <summary Lang=en>
// This tsl creates plan view coordinate dimension tags.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "PlanViewCoordinateDim")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Move Tagt|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset Locations|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set datum|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Walls|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add beams|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add openings|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add TSLs|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove entities|") (_TM "|Select dimension|"))) TSLCONTENT
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
	
	String sPainterCollection = "PlanViewCoordinateDim";
	String sAllowedPainterTypes[] = { "ElementWall", "ElementWallStickframe", "ElementLog"};
	String sBySelection = T("|bySelection|");
	String sSubXKey = "ViewProtect";
	int nSequenceOffset = 500; // a default offset to start all sequences, will be different i.e. for hsbViewDimension
	
// distinguish if current background is light or dark	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	
	int lightblue = rgb(204,204,255);
	int darkblue = rgb(26,50,137);	

	
	int yellow = rgb(241,235,31);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int blue = rgb(69,84,185);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);
	
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);


	int darkyellow = rgb(254, 204, 102);	
	
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	
	double dViewHeight = getViewHeight();	
	
//end Constants//endregion

//region bOnJig
	if (_bOnJig && _kExecuteKey=="JigMove") 
	{
		Plane pnW(_PtW, _ZW);
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    Line(ptJig, _ZW).hasIntersection(pnW, ptJig);
	    
	    int bMove = _Map.hasPlaneProfile("ppMove");
	    PlaneProfile ppMove = _Map.getPlaneProfile("ppMove");
	    
	    PlaneProfile pps[0];
	    Map mapBoundaries = _Map.getMap("Boundary[]");
	    for (int i=0;i<mapBoundaries.length();i++) 
	    	pps.append(mapBoundaries.getPlaneProfile(i)); 

	// get closest
		Point3d ptSnap = bMove ?ppMove.extentInDir(_XW).ptMid(): ptJig;
		int indexRef = -1;
		double dist = U(10e5);
		for (int i=0;i<pps.length();i++) 
		{ 
			double d = Vector3d(pps[i].closestPointTo(ptSnap) - ptSnap).length();
			if (d<dist)
			{ 
				dist = d;
				indexRef = i;
			}
		}

	// draw boundaries
		Display dp(-1), dpGrey(-1);		
		dpGrey.trueColor(grey);
		for (int i=0;i<pps.length();i++) 
		{ 
			dp.trueColor(i==indexRef?darkyellow:lightblue, 50);
			dp.draw(pps[i], _kDrawFilled); 
			dpGrey.draw(pps[i]); 
		}//next i
		
	// draw new location when moving
		if (bMove)
		{ 
			Display dpRed(-1);
			dpRed.trueColor(red, 50);
			
			Point3d pt = ppMove.extentInDir(_XW).ptMid();
			ppMove.transformBy(ptJig - pt);
			dpRed.draw(ppMove,_kDrawFilled);
			dpGrey.draw(ppMove)	;
		}
		
	    
	    return;
	}		
//End bOnJig//endregion 

//region Properties
	// Collect painters
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();	
	for (int i=sPainters.length()-1; i>=0 ; i--) 
	{ 
		String sPainter = sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0 || sPainter.find(sBySelection,0,false)>-1)
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

//region painter stream
	String sPainterStreamName=T("|Painter Definition|");	
	PropString sPainterStream(4, "", sPainterStreamName);	
	sPainterStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sPainterStream.setCategory(category);
	sPainterStream.setReadOnly(bDebug?0:_kHidden);

	// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert)
	{ 
	// collect streams	
		String streams[0];
		String sScriptOpmName = bDebug?"PlanViewCoordinateDim":scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
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
				if (index== 4 && streams.findNoCase(stream,-1)<0)
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

//End Create Painter by Property//endregion 

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "X: @(ChoordX) \PY: @(ChoordY)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the tag|"));
	sFormat.setCategory(category);

	String sStrategies[] = { T("|Default|"), T("|Start|"), T("|End|"), T("|Start+End|"), T("|Center|")};
	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(nStringIndex++, sStrategies, sStrategyName);	
	sStrategy.setDescription(T("|Defines the strategy of the dimension mode|"));
	sStrategy.setCategory(category);
	int nStrategy = sStrategies.find(sStrategy);
	

	String sReferences[0];
	for (int i=0;i<sPainters.length();i++) 
	{ 
		String entry = sPainters[i];
		entry = entry.right(entry.length() - sPainterCollection.length()-1);	
		if (sReferences.findNoCase(entry,-1)<0)
			sReferences.append(entry);
	}//next i
	sReferences.insertAt(0, sBySelection);
	String sReferenceName=T("|Reference|");	
	PropString sReference(nStringIndex++, sReferences, sReferenceName);	
	sReference.setDescription(T("|Defines the Reference|"));
	sReference.setCategory(category);
	if (sReferences.findNoCase(sReference,-1)<0)
		sReference.set(sBySelection);



	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);


	String sSequenceName=T("|Sequence|");
	PropInt nSequence(nIntIndex++, 0, sSequenceName);	
	nSequence.setDescription(T("|Defines the sequence how collisions with dimlines and tags will be resolved.| ") + T("|-1 = Disabled, 0 = Automatic|"));
	nSequence.setCategory(category);

//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
		
	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		if (!bInLayoutTab )
		{ 
			reportNotice(TN("|This tool works only in paperspace.|"));
			eraseInstance();
			return;
		}
		
	// get viewport
		if (!bInPaperSpace)
			bInPaperSpace = Viewport().switchToPaperSpace();	
		if (!bInPaperSpace )
		{ 
			reportNotice(TN("|This tool works only in paperspace.|"));
			eraseInstance();
			return;
		}
		
		_Viewport.append(getViewport(T("|Select a viewport|")));

	// get datum in modelspace
		int bInModel = Viewport().switchToModelSpace();
		if (bInModel)
		{ 
			Point3d pt = getPoint(T("|Pick datum|"));
			_Map.setVector3d("vecDatum",pt - _PtW);
		}
		bInPaperSpace = Viewport().switchToPaperSpace();
		_Pt0 = _Viewport[0].ptCenPS() +_XW * .5 * _Viewport[0].widthPS()+_YW * .5 * _Viewport[0].heightPS();

		return;
	}	
// end on insert	__________________//endregion
		
//End Part #1//endregion 

//region Part #2

//region Viewport Data

	if (_Viewport.length()<1)
	{ 
		reportNotice(TN("|Could not find assigned viewport.|"));
		eraseInstance();
		return;
	}
	
	//region Sequencing: Order tagging entities by sequence number
	if (nSequence > 0)_ThisInst.setSequenceNumber(nSequence);
	Entity entTags[]= Group().collectEntities(true, TslInst(), _kMySpace);	

// order by sequence number
	TslInst tslSeqs[0];
	int nSequences[0];
	for (int i=0;i<entTags.length();i++) 
	{ 
		TslInst t = (TslInst)entTags[i];
		if (t.bIsValid() && t.sequenceNumber()>=0 && 
			t.subMapXKeys().find(sSubXKey) >-1)// sSubXKey qualifies tsls with protection area
			{
				tslSeqs.append(t);
				nSequences.append(t.sequenceNumber());
			}
	}
	for (int i=0;i<tslSeqs.length();i++) 
		for (int j=0;j<tslSeqs.length()-1;j++) 
			if (nSequences[j]>nSequences[j+1])
			{
				tslSeqs.swap(j, j + 1);
				nSequences.swap(j, j + 1);
			}
				
// set sequence number during relevant events
	if (nSequence==0)//(_bOnDbCreated || _kNameLastChangedProp==sSequenceName) && 
	{ 
		int nNext = nSequenceOffset;
		for (int i=0;i<nSequences.length();i++) 
			if (nSequences.find(nNext)>-1)
			{
				//reportMessage("\n" + _ThisInst.handle()+ ": "+ nNext + " found in " +nSequences);
				nNext++;
			}
		nSequence.set(nNext);
		if (bDebug)reportMessage("\n" + _ThisInst.handle() + " sequence number set to " + nSequence);
		setExecutionLoops(2);
		return;
	}

// add/remove dependency to any sequenced tsl with a lower sequence number
	int nThisIndex = tslSeqs.find(_ThisInst);
	
	if (bDebug && tslSeqs.length()>1)reportNotice("\n" + scriptName() + " "+_ThisInst.handle() + " with sequence " + nSequence + " rank " + nThisIndex+ " depends on");
	for (int i=0;i<tslSeqs.length();i++) 
	{ 
		TslInst t = tslSeqs[i];
		int x = _Entity.find(t);
		if(i<nThisIndex)
		{ 
			_Entity.append(t);
			setDependencyOnEntity(t);
			if (bDebug)reportNotice("\n	" + t.handle() +" "+t.scriptName()+ " with sequence " + t.sequenceNumber());
		}
		else if (x>-1)
			_Entity.removeAt(x);		 
	}//next i
	
//End Sequencing: Order tagging entities by sequence number//endregion 	
	
	Viewport vp=_Viewport[_Viewport.length()-1]; 
	_Viewport[0] = vp; // make sure the connection to the first one is lost
	if (_bOnDbCreated) assignToLayer("0");
	
	CoordSys ms2ps, ps2ms;
	ms2ps = vp.coordSys();
	ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps	
		
	int bIsAcaViewport;
	double dScale = vp.dScale();
	double dEpsPS =  dScale<1?dEps * dScale:dEps;
	double dXVp= vp.widthPS(), dYVp= vp.heightPS();
	int nActiveZoneIndex = vp.activeZoneIndex();
	Point3d ptCenVp=vp.ptCenPS();
	
	int bBySelection = sReference == sBySelection;
	
	PlaneProfile ppVP;
	ppVP.createRectangle(LineSeg(ptCenVp-.5*(_XW*dXVp+_YW*dYVp), ptCenVp+.5*(_XW*dXVp+_YW*dYVp)), _XW, _YW);
	
	Map mapLocations = _Map.getMap("Location[]");
	if (_kNameLastChangedProp==sReferenceName)
	{
		_Map.removeAt("Location[]", true);	
		mapLocations = Map();
	}
//End Viewport Data//endregion

//region Trigger SetDatum
	String sTriggerSetDatum = T("|Set datum|");
	addRecalcTrigger(_kContextRoot, sTriggerSetDatum );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetDatum)
	{
		int bInModel = Viewport().switchToModelSpace();
		if (bInModel)
		{ 
			Point3d pt = getPoint(T("|Pick datum|"));
			_Map.setVector3d("vecDatum",pt - _PtW);
		}
		Viewport().switchToPaperSpace();				
		setExecutionLoops(2);
		return;
	}//endregion	

//region Collect entities
	Entity ents[0];
	PainterDefinition pd;
	if (bBySelection)
	{ 
	// Trigger AddWalls
		String sTriggerAddWall = T("|Add Walls|");
		addRecalcTrigger(_kContextRoot, sTriggerAddWall );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddWall)
		{
			int bOk = Viewport().switchToModelSpace();
			if (bOk)
			{ 
				Entity _ents[0];
			// prompt for elements
				PrEntity ssE(T("|Select walls|"), ElementWall());
			  	if (ssE.go())
					_ents.append(ssE.set());
				
				for (int i=0;i<_ents.length();i++) 
					if (_Entity.find(_ents[i])<0)
						_Entity.append(_ents[i]); 
	
			}
			bOk = Viewport().switchToPaperSpace();
			_Map.removeAt("Location[]", true);	
			setExecutionLoops(2);
			return;
		}	
	
	// Trigger AddBeam
		String sTriggerAddBeam = T("|Add beams|");
		addRecalcTrigger(_kContextRoot, sTriggerAddBeam );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddBeam)
		{
			int bOk = Viewport().switchToModelSpace();
			if (bOk)
			{ 
				Entity _ents[0];
			// prompt for elements
				PrEntity ssE(T("|Select beams|"), Beam());
			  	if (ssE.go())
					_ents.append(ssE.set());
				
				for (int i=0;i<_ents.length();i++) 
					if (_Entity.find(_ents[i])<0)
						_Entity.append(_ents[i]); 
	
			}
			bOk = Viewport().switchToPaperSpace();
			_Map.removeAt("Location[]", true);	
			setExecutionLoops(2);
			return;
		}		
	
	
	// Trigger AddTSLs
		String sTriggerAddTSL = T("|Add TSLs|");
		addRecalcTrigger(_kContextRoot, sTriggerAddTSL );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddTSL)
		{
			int bOk = Viewport().switchToModelSpace();
			if (bOk)
			{ 
				Entity _ents[0];
				PrEntity ssE(T("|Select tsls|"), TslInst());
			  	if (ssE.go())
					_ents.append(ssE.set());
				
				for (int i=0;i<_ents.length();i++) 
					if (_Entity.find(_ents[i])<0)
						_Entity.append(_ents[i]); 
	
			}
			bOk = Viewport().switchToPaperSpace();
			_Map.removeAt("Location[]", true);	
			setExecutionLoops(2);
			return;
		}	
		
	// Trigger AddOpening
		String sTriggerAddOpening = T("|Add openings|");
		addRecalcTrigger(_kContextRoot, sTriggerAddBeam );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddBeam)
		{
			int bOk = Viewport().switchToModelSpace();
			if (bOk)
			{ 
				Entity _ents[0];
				PrEntity ssE(T("|Select openings|"), Opening());
			  	if (ssE.go())
					_ents.append(ssE.set());
				
				for (int i=0;i<_ents.length();i++) 
					if (_Entity.find(_ents[i])<0)
						_Entity.append(_ents[i]); 
	
			}
			bOk = Viewport().switchToPaperSpace();
			_Map.removeAt("Location[]", true);	
			setExecutionLoops(2);
			return;
		}		
		
		
	
//	// Trigger AddEntities
//		String sTriggerAddEntity = T("|Add entities|");
//		addRecalcTrigger(_kContextRoot, sTriggerAddEntity);
//		if (_bOnRecalc && _kExecuteKey==sTriggerAddEntity)
//		{
//			int bOk = Viewport().switchToModelSpace();
//			if (bOk)
//			{ 
//				Entity _ents[0];
//			// prompt for elements
//				PrEntity ssE(T("|Select beams|"), Entity());
//			  	if (ssE.go())
//					_ents.append(ssE.set());
//				
//				for (int i=0;i<_ents.length();i++) 
//					if (_Entity.find(_ents[i])<0)
//						_Entity.append(_ents[i]); 
//	
//			}
//			bOk = Viewport().switchToPaperSpace();
//			_Map.removeAt("Location[]", true);	
//			setExecutionLoops(2);
//			return;
//		}		
//	
		
	
	// Trigger RemoveEntity
		if (_Entity.length()>0)
		{ 

			String sTriggerRemoveEntity = T("|Remove entities|");
			addRecalcTrigger(_kContextRoot, sTriggerRemoveEntity );
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntity)
			{
				int bOk = Viewport().switchToModelSpace();
				Entity _ents[0];
				PrEntity ssE(T("|Select entities|"), Entity());
			  	if (ssE.go())
					_ents.append(ssE.set());	
				
				for (int i=0;i<_ents.length();i++) 
				{ 
					int n = _Entity.find(_ents[i]);
					if (n>-1)
						_Entity.removeAt(n);
					 
				}//next i
				
				bOk = Viewport().switchToPaperSpace();
				_Map.removeAt("Location[]", true);	
				setExecutionLoops(2);
				return;
			}					

		}

		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity& ent = _Entity[i];
			if (ent.typeDxfName() == "VIEWPORT")continue;
			if (entTags.find(ent)<0) // avoid tagging tsls to be included
			{
				//reportMessage("\nadding " + ent.typeDxfName());
				ents.append(ent);
			}
		}//next i
		
		
		
	}
	else
	{ 
		pd=PainterDefinition(sPainterCollection+"\\" + sReference);
		if (pd.bIsValid())
		{ 
			Entity _ents[] = Group().collectEntities(true, ElementWall(), _kModelSpace);
			ents.append(pd.filterAcceptedEntities(_ents));	
		}
	}

//End Collect entities//endregion 

//region Display
	Display dp(_ThisInst.color());
	dp.dimStyle(sDimStyle);
	double textHeight = dp.textHeightForStyle("O", sDimStyle);//*dScale;
	if (dTextHeight>0)
	{
		textHeight = dTextHeight;
	}
	dp.textHeight(textHeight);
	
	double dHeightModel = abs(textHeight) / dScale;
	
	Vector3d vecXModel = _XW;	vecXModel.transformBy(ps2ms); 	vecXModel.normalize(); // model X
	Vector3d vecYModel = _YW;	vecYModel.transformBy(ps2ms); 	vecYModel.normalize(); // model Y
	Vector3d vecZModel = _ZW;	vecZModel.transformBy(ps2ms); 	vecZModel.normalize(); // model Z
	Plane pnZModel(_PtW, vecZModel);
	CoordSys csW(_PtW, _XW, _YW, _ZW);
//End Display//endregion 
	
//region Protection area by sequence
	// collect protection areas of sequnced tagging tsl with a higher or equal sequence number
	PlaneProfile ppProtect(csW);
	for (int i=0;i<tslSeqs.length();i++) 
	{ 
		TslInst t = tslSeqs[i]; 
		if (!t.bIsValid() || t==_ThisInst) {continue;}// validate tsl
		String s = t.scriptName();
		int n = t.sequenceNumber();
		if (n<nSequence || (n==nSequence && t.handle()>_ThisInst.handle()))
		{ 
			Map m = t.subMapX(sSubXKey);
			PlaneProfile pp =m.getPlaneProfile("ppProtect");
			if (pp.area() < pow(dEpsPS, 2)) { continue};
			
			if (ppProtect.area() < pow(dEpsPS, 2))	ppProtect = pp;
			else ppProtect.unionWith(pp);
		}
	}//next i
	if (ppProtect.area()>pow(dEpsPS,2))ppProtect.vis(bIsDark?4:1);		
//End Protection area by sequence//endregion 

//region Create a fibonacci spiral for clash detection
	PLine fibonacci(_ZW);	
	{ 
		Point3d pt1 = _PtW;
		Vector3d vecDir = _XW;
		Vector3d vecPerp = _YW;
		Vector3d vecRot = vecDir.crossProduct(vecPerp);
		CoordSys csRot; csRot.setToRotation(90, vecRot, pt1);
		
		double dSize = textHeight;
		double dMaxSize = (dXVp>dYVp?dXVp:dYVp)/10;
		int num = dMaxSize / dSize * 4 + 1;
		num = num < 2 ? 2 : num;
		
		Point3d pts[0];
		for (int i=1;i<num;i++) 
		{ 
			double dXY = (i - 1 + i) * dSize/8;
			pt1 -= vecDir * dXY;		
			if (i==1)pts.append(pt1 + vecDir * dXY);
			Point3d pt2 = pt1 + vecPerp * dXY;
			pts.append(pt2);
			vecDir.transformBy(csRot);
			vecPerp.transformBy(csRot);
	
			pt1=pt2;	 
		}//next 0

		fibonacci.addVertex(pts[0]);
		for (int i=1;i<pts.length();i++) 
			fibonacci.addVertex(pts[i], tan(22.5));
			
		//fibonacci.vis(30);
	}	
//End Create a fibonacci spiral for clash detection//endregion 	

//End Part #2//endregion 


//region Collect data
	Point3d ptDatum = _PtW + _Map.getVector3d("vecDatum");
	int numNotInView;
	Map mapAdditionals;	
	Map maps[0], maps2[0];// maps2 = non orthogonal entities
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity& ent=ents[i];
		CoordSys cs;
		PlaneProfile pp;
		
		GenBeam gb= (GenBeam)ent; 
		ElementWall wall= (ElementWall)ent; 
		Opening opening= (Opening)ent; 
		TslInst tsl = (TslInst)ent;	
		Element el = ent.element();;
		if (gb.bIsValid())
		{ 
			cs = gb.coordSys();
			pp = gb.envelopeBody(true, true).shadowProfile(pnZModel);
		}
		else if (wall.bIsValid())
		{ 
			cs = wall.coordSys();
			//pp = PlaneProfile(CoordSys(cs.ptOrg(), cs.vecX(), - cs.vecZ(), cs.vecY()));
			pp.joinRing(wall.plOutlineWall(),_kAdd);
		}
		else if (opening.bIsValid())
		{ 
			el = opening.element();
			if (!el.bIsValid())continue;
			
			cs = opening.coordSys();
			PLine pl = opening.plShape();
			pl.projectPointsToPlane(Plane(el.ptOrg(), el.vecZ()), el.vecZ());
			Body bd(pl, el.vecZ() * el.dBeamWidth() ,- 1);
			pp = bd.shadowProfile(pnZModel);;
		}		
		else if (tsl.bIsValid())
		{ 
			cs = tsl.coordSys();
			pp = tsl.realBody().shadowProfile(pnZModel);
			if (pp.area()<pow(dEps,2)) // support non solids
				pp.createRectangle(LineSeg(cs.ptOrg()-dHeightModel*(_XW+_YW),cs.ptOrg()+dHeightModel*(_XW+_YW)), _XW, _YW);
		}

		
	// reset coordSys 
		Point3d ptModel = cs.ptOrg();
		Point3d ptPaper = ptModel;
		ptPaper.transformBy(ms2ps);ptPaper.setZ(0);
		
	// to element
		if (el.bIsValid())
			cs = CoordSys(ptModel, el.vecX(), -el.vecZ(), el.vecY());
	// to ps2ms alignment if vecX is parallel with view (i.e. a beam drawn as post)
		else if (vecZModel.isParallelTo(cs.vecX()))
			cs = CoordSys(ptModel, vecXModel, vecYModel, vecZModel);

		cs.transformBy(ms2ps);
		pp.transformBy(ms2ps);	
		
		Vector3d vecX = cs.vecX();	vecX.normalize();
		Vector3d vecY = cs.vecY();	vecY.normalize();
		Vector3d vecZ = cs.vecZ();	vecZ.normalize();		
		
		PlaneProfile ppPaper(CoordSys(ptPaper, vecX, vecY, vecZ));
		ppPaper.unionWith(pp);ppPaper.vis(i);
		LineSeg segPaper = ppPaper.extentInDir(vecX);
		
	// collect dimpoints
		int bIsOrtho = vecX.isParallelTo(_XW) || vecX.isParallelTo(_YW);
		Point3d ptsDim[] ={segPaper.ptStart()}; // default
	
		if (!bIsOrtho)		ptsDim.append(segPaper.ptEnd());	// default (non ortho)
		if (nStrategy == 1)	ptsDim.setLength(1);				//start		
		else if (nStrategy == 2)								//end
		{
			ptsDim.setLength(1);
			ptsDim[0]=segPaper.ptEnd();
		}
		else if (nStrategy == 4)								//center
		{
			ptsDim.setLength(1);
			ptsDim[0]=segPaper.ptMid();
		}
		
	// refuse any tag outside of paperspace extents
		if (ppVP.pointInProfile(ptPaper)==_kPointOutsideProfile)
			numNotInView++;
	// find location
		else
		{
			Map m;
			m.setEntity("ent", ent);
			m.setPlaneProfile("pp", ppPaper);
			m.setPoint3dArray("pts", ptsDim);
			
			Point3d ptOrg = cs.ptOrg(); ptOrg.setZ(0);
			m.setPoint3d("ptOrg", ptOrg);
			m.setVector3d("vecX", vecX);
			m.setVector3d("vecY", vecY);
			m.setVector3d("vecZ", vecZ);
			
			if (bIsOrtho)
				maps.append(m);
			else
			{
				//reportNotice("\ncollecting "+ maps2.length()+ " "+ent.handle());
				maps2.append(m);				
			}

		}
		
	// append blownup shadow to protected area
		ppPaper.shrink(-textHeight*.5); // add an additional offset	
		ppProtect.unionWith(ppPaper);		

	// append wall arrow to protected area
		ElementWall elw = (ElementWall)el;
		if (elw.bIsValid())
		{ 
			PLine pl;
			Point3d pt = elw.ptArrow();
			pl.createRectangle(LineSeg(pt - el.vecX() * dHeightModel, 
				pt + el.vecX() *dHeightModel+el.vecZ()*dHeightModel), el.vecX(), el.vecZ());
			pl.transformBy(ms2ps);
			ppProtect.joinRing(pl, _kAdd);
		}


	}//next i
	ppProtect.vis(1);
	
	PlaneProfile ppBoundaries[0];
//End Collect data//endregion 	

//region Non orthogonal entities
	double dMergeGap = U(200)*dScale;
	{ 
		Plane planes[0];	
		for (int i=0;i<maps2.length();i++) 
		{ 
			Map m = maps2[i];
			
			Point3d ptOrg = m.getPoint3d("ptOrg");
			Vector3d vecX = m.getVector3d("vecX");
			Vector3d vecY = m.getVector3d("vecY");
			Vector3d vecZ = m.getVector3d("vecZ");
			CoordSys cs(ptOrg, vecX, vecY, vecZ);

//			PlaneProfile pp(cs);
//			pp.unionWith(m.getPlaneProfile("pp"));
			PlaneProfile pp = m.getPlaneProfile("pp");
			Point3d pts[] = m.getPoint3dArray("pts");

			Vector3d vecDir = vecX;
			if (vecDir.dotProduct(_YW) > 0)vecDir *=- 1;
			pts = Line(ptOrg, vecDir).orderPoints(pts);
			if (pts.length() < 1)continue;
			Point3d pt = pts.first();
			
		// skip any which is already collected	
			int bOk = true;
			for (int j=0;j<planes.length();j++)
			{ 
				Plane pn = planes[j];
				if (!vecY.isCodirectionalTo(pn.vecZ()))continue; // not same plane
				double d = abs(vecY.dotProduct(ptOrg - pn.ptOrg()));	
				if (d<dEpsPS)
				{
					bOk=false;
					break;;
				}
				PLine (ptOrg, pn.ptOrg()).vis(1);

			}
			if (!bOk)continue;
			
		// append this to collected planes	
			planes.append(Plane(ptOrg, vecY));
			int indices[0];
			indices.append(i);

		// append any other in same plane
			for (int j=i+1;j<maps2.length();j++)
			{ 
				Map m2 = maps2[j];
				Point3d ptOrg2 = m2.getPoint3d("ptOrg");
				Vector3d vecY2 = m2.getVector3d("vecY");
				if (!vecY.isCodirectionalTo(vecY2))continue; // not same plane
				double d = abs(vecY.dotProduct(ptOrg- ptOrg2));
				if (d>dEpsPS)
				{
					continue;
				}
				
				indices.append(j);
				//PlaneProfile pp2 = m2.getPlaneProfile("pp"); pp2.vis(i);
			}
			
		// build a merged profile to detect entities which should be grouped
			PlaneProfile ppPlane(cs);
			for (int j=0;j<indices.length();j++) 
			{ 
				int index = indices[j];
				Map m2 = maps2[index];
				PlaneProfile pp2 = m2.getPlaneProfile("pp");
				pp2.shrink(-dMergeGap);		//pp2.vis(40);
				ppPlane.unionWith(pp2);
			}//next j
			//ppPlane.vis(6);
			
		// group those which fall into the same ring profile
			PLine rings[] = ppPlane.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile ppr(CoordSys(ptOrg, vecX, vecY, vecZ));
				ppr.joinRing(rings[r],_kAdd);
				int indicesGroup[0]; Point3d ptsDir[0];
				for (int j=0;j<indices.length();j++) 
				{ 
					int index = indices[j];
					Point3d ptOrg2 = maps2[index].getPoint3d("ptOrg");					
					if (ppr.pointInProfile(ptOrg2)==_kPointInProfile)
					{ 
						indicesGroup.append(index);
						ptsDir.append(ptOrg2);
					}
				}//next j				
				
			// order along X of group			
				for (int a=0;a<indicesGroup.length();a++) 
					for (int b=0;b<indicesGroup.length()-1;b++) 
					{ 
						Point3d ptA = ptsDir[b];
						Point3d ptB = ptsDir[b+1];
						if (vecDir.dotProduct(pt-ptA) < vecDir.dotProduct(pt-ptB))
						{
							indicesGroup.swap(b, b + 1);
							ptsDir.swap(b, b + 1);
						}
					}
					
			// create a box around the group set
				PlaneProfile ppBox;
				ppBox.createRectangle(ppr.extentInDir(_XW), _XW, _YW);			//ppBox.vis(5);
				Point3d ptMid = ppBox.ptMid();
				
			// Get text boundings	
				double dYFirst;
				Point3d ptText = ptMid;
				PlaneProfile ppTextBoundary(csW);
				for (int j=0;j<indicesGroup.length();j++) 
				{ 
					int index = indicesGroup[j];
					Map m2 = maps2[index];
					Entity ent2 = m2.getEntity("ent");
					PlaneProfile pp2 = m2.getPlaneProfile("pp");
					Vector3d vecX2 = m2.getVector3d("vecX");
					Vector3d vecY2 = m2.getVector3d("vecY");
					Vector3d vecZ2 = m2.getVector3d("vecZ");
				
					Point3d pts2[] = m2.getPoint3dArray("pts");
					pts2 = Line(ptOrg, vecDir).orderPoints(pts2);
					if (pts2.length() < 1)continue;
										
					for (int p=0;p<pts2.length();p++) 
					{ 
						Point3d ptDimModel = pts2[p];
						ptDimModel.transformBy(ps2ms);
		
					// add additional formatting variables	
						double dXDim = _XW.dotProduct(ptDimModel - ptDatum);
						double dYDim = _YW.dotProduct(ptDimModel - ptDatum);
						mapAdditionals.setDouble("ChoordX", dXDim);
						mapAdditionals.setDouble("ChoordY", dYDim);
				
						String text = ent2.formatObject(sFormat, mapAdditionals);					
 						//text += j<indicesGroup.length()-1 && p==pts2.length()-1?"\\P ":"";
						double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
						double dY = dp.textHeightForStyle(text, sDimStyle, textHeight)+.5*textHeight;
						if (j<indicesGroup.length()-1 && p==pts2.length()-1)dY+=textHeight;
						if (j == 0 && p == 0)dYFirst = dY; // store height of first text
						PlaneProfile ppt(csW);
						ppt.createRectangle(LineSeg(ptText+.5*_YW*dY, ptText + _XW * dX - .5*_YW * dY), _XW, _YW);	//ppt.vis(j);
						ppTextBoundary.unionWith(ppt);
						
						ptText.transformBy(-_YW * (dY));
					}//next p
				}
				ppTextBoundary.shrink(-.5 * textHeight); // margin	
				Point3d ptLoc =ppBox.ptMid() + _XW * .5*(ppBox.dX()+textHeight) + _YW*(.5*ppTextBoundary.dY());
				
				ppTextBoundary.transformBy(ptLoc - ppBox.ptMid());	//ppTextBoundary.vis(254);
				ptText = ptLoc;
				double dXFlag = _XW.dotProduct(ptText - ptMid) < 0 ? -1 : 1;

			// Collision test
				PlaneProfile ppClash = ppProtect;
				int bClash = ppClash.intersectWith(ppTextBoundary);
				int max; 

				if (bClash)
				{ 
					fibonacci.transformBy(ptText - fibonacci.ptStart());
					double distAt = textHeight;
					int max;
					
					PLine plDebug(ptText);
					while(bClash && max<fibonacci.length() / textHeight)// break if no clash or end of fibonacci spiral
					{ 
						Point3d pt = fibonacci.getPointAtDist(distAt);
						distAt += textHeight;
						max++;				
						plDebug.addVertex(pt);				
						if (ppProtect.pointInProfile(pt)!=_kPointOutsideProfile)// skip if point within protected range
						{ 
							//PLine(pt, ptText).vis(12);
							continue;
						}
						
						PlaneProfile pp = ppTextBoundary; //ppTextBoundary.vis(5);
						pp.transformBy(pt - ptLoc);
						ppClash = ppProtect;
						bClash = ppClash.intersectWith(pp);		
						if (!bClash)
						{ 
							Point3d ptX = pp.extentInDir(_XW).ptMid();
							dXFlag = _XW.dotProduct(ptX - ptMid) < 0 ? -1 : 1;
							ppTextBoundary = pp;	pp.vis(3);
							ptText = ptX - _XW * .5 * (pp.dX()-textHeight) *dXFlag;
							ptText += _YW * .5 * (ppTextBoundary.dY() - dYFirst-textHeight);
							//PLine(ptText, ptMid).vis(5);			
							break;
						}
		
					}
					//if (plDebug.length() > 0)plDebug.vis(i);	
				}


				
			// check if location has been manipulated
				int indexRef = ppBoundaries.length();
				if (mapLocations.hasVector3d("vecMove"+indexRef))
				{ 
					
					Point3d ptTo = _PtW + mapLocations.getVector3d("vecMove" + indexRef);
					Vector3d vec = ptTo-ptText;
					ptText.transformBy(vec);
					dXFlag = _XW.dotProduct(ptText - ptMid) < 0 ? -1 : 1;
					
					ppTextBoundary.transformBy(vec);
					ptText += _XW*_XW.dotProduct(ppTextBoundary.ptMid()-ptText)-_XW*.5*(ppTextBoundary.dX()*dXFlag + textHeight);
				}	
				
				
				
				
				//ppTextBoundary.vis(bClash);
				//PLine(ptText, ptOrg).vis(5);
				for (int j=0;j<indicesGroup.length();j++) 
				{ 
					int index = indicesGroup[j];
					Map m2 = maps2[index];
					Point3d pts2[] = m2.getPoint3dArray("pts");
					pts2 = Line(ptOrg, vecDir).orderPoints(pts2);
					if (pts2.length() < 1)continue;	
					
					Entity ent2 = m2.getEntity("ent");
					for (int p=0;p<pts2.length();p++) 
					{ 
						Point3d pt1 = pts2[p];	
						Point3d pt2 = ptText - dXFlag*_XW*.5 * textHeight;
						Point3d ptDimModel = pt1;
						ptDimModel.transformBy(ps2ms);
		
					// add additional formatting variables	
						Map mapAdditionals;	
						double dXDim = _XW.dotProduct(ptDimModel - ptDatum);
						double dYDim = _YW.dotProduct(ptDimModel - ptDatum);
						mapAdditionals.setDouble("ChoordX", dXDim);
						mapAdditionals.setDouble("ChoordY", dYDim);
				
						String text = ent2.formatObject(sFormat, mapAdditionals);					
						//text += j<indicesGroup.length()-1 && p==pts2.length()-1?"\\P ":"";
						
						dp.draw(text, ptText, _XW, _YW, dXFlag ,0);
						dp.draw(PLine(pt1,pt2, ptText));
						//arrow
						{ 
							Vector3d vecA = pt1-pt2; vecA.normalize();
							Vector3d vecB = vecA.crossProduct(-_ZW);
							PLine arrow(_ZW);
							arrow.addVertex(pt1);
							arrow.addVertex(pt1-.5*textHeight*(vecA+vecB*.2));
							arrow.addVertex(pt1-.5*textHeight*(vecA-vecB*.2));
							arrow.close();//			arrow.vis(3);
							dp.draw(PlaneProfile(arrow), _kDrawFilled);
						}						
						
						
						double dY = dp.textHeightForStyle(text, sDimStyle, textHeight)+.5*textHeight;
						if (j<indicesGroup.length()-1 && p==pts2.length()-1)dY+=textHeight;
						ptText.transformBy(-_YW * (dY));
					}//next p					
				}
				
				//ppTextBoundary.shrink(-.5*textHeight);
				ppBoundaries.append(ppTextBoundary); // collect the text boundary for jigging
				ppProtect.unionWith(ppTextBoundary);
				ppTextBoundary.vis(254);

			}//next r
		}//next i		
	}
	
//End Non orthogonal entities//endregion 

//region Orthogonal entities
{ 
// order by location and area
	{
		double areas[0];
		Point3d ptMids[0];
		for (int i = 0; i < maps.length(); i++)
		{
			PlaneProfile pp = maps[i].getPlaneProfile("pp");
			areas.append(pp.area());
			ptMids.append(pp.extentInDir(_XW).ptMid());
		}
		for (int i=0;i<maps.length();i++) 
			for (int j=0;j<maps.length()-1;j++) 
			{ 
				double d1 = _XW.dotProduct(ptMids[j] - _PtW);
				double d2 = _XW.dotProduct(ptMids[j+1] - _PtW);
				if (d1>d2)
				{
					maps.swap(j, j + 1);
					areas.swap(j, j + 1);
					ptMids.swap(j, j + 1);
				}
			}
						
		for (int i=0;i<maps.length();i++) 
			for (int j=0;j<maps.length()-1;j++) 
				if (_YW.dotProduct(ptMids[j]-_PtW)<_YW.dotProduct(ptMids[j+1]-_PtW))
				{
					maps.swap(j, j + 1);
					areas.swap(j, j + 1);
					ptMids.swap(j, j + 1);
				}		
		
			
		for (int i=0;i<maps.length();i++) 
			for (int j=0;j<maps.length()-1;j++) 
				if (areas[j]-areas[j+1]>pow(dEpsPS,2))
				{
					maps.swap(j, j + 1);
					areas.swap(j, j + 1);
					ptMids.swap(j, j + 1);
				}
	}


	for (int i = 0; i < maps.length(); i++)
	{
		Map m = maps[i];
		Entity ent = m.getEntity("ent");
		PlaneProfile pp = m.getPlaneProfile("pp");
		PlaneProfile ppMargin = pp; ppMargin.shrink(-dHeightModel);//ppMargin.vis(5);
		Point3d ptOrg = m.getPoint3d("ptOrg");
		Vector3d vecX = m.getVector3d("vecX");
		Vector3d vecY = m.getVector3d("vecY");
		Vector3d vecZ = m.getVector3d("vecZ");
//		vecY.vis(ptOrg, 3);
		
		Point3d pts[] = m.getPoint3dArray("pts");
		if (pts.length() < 1)continue;
		
	// get text and textbox size
		String text;
		for (int p=0;p<pts.length();p++) 
		{ 
			Point3d ptDimModel = pts[p];
			ptDimModel.transformBy(ps2ms);

		// add additional formatting variables			
			double dXDim = _XW.dotProduct(ptDimModel - ptDatum);
			double dYDim = _YW.dotProduct(ptDimModel - ptDatum);
			mapAdditionals.setDouble("ChoordX", dXDim);
			mapAdditionals.setDouble("ChoordY", dYDim);
	
			text+= ent.formatObject(sFormat, mapAdditionals);					

			if (pts.length()>1 && p< pts.length()-1)
				text += "\\P";
		}
		double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
		double dY = dp.textHeightForStyle(text, sDimStyle, textHeight);
		
		Point3d ptLoc = pts.first();
		ptLoc+=vecY*(vecY.dotProduct(pp.ptMid()-ptLoc));
		double dXFlag = vecX.isCodirectionalTo(-_XW) ||vecY.isCodirectionalTo(-_XW)?-1:1;
		if (vecX.isParallelTo(_YW))ptLoc += vecX * 1.5*textHeight + vecY * .5*dX;		
		else if (vecX.isParallelTo(_XW))ptLoc += vecX * 1.5*textHeight + vecY * (.5*dY+textHeight);
//		
//		
	// default location	
		PlaneProfile ppTextBoundary(csW);
		Point3d ptText = ptLoc;
		ppTextBoundary.createRectangle(LineSeg(ptText+.5*_YW*dY, ptText + dXFlag*_XW * dX - .5*_YW * dY), _XW, _YW);
		PlaneProfile ppClash = ppProtect;
		int bClash = ppClash.intersectWith(ppTextBoundary);
		int max;
		
		//PLine (ptText, ptOrg).vis(3);
		//ppProtect.vis(5);		
		if (bClash)
		{ 
			fibonacci.transformBy(ptText - fibonacci.ptStart());
			double distAt = textHeight;
			int max;
			
			PLine plDebug(ptText);
			while(bClash && max<fibonacci.length() / textHeight)// break if no clash or end of fibonacci spiral
			{ 
				Point3d pt = fibonacci.getPointAtDist(distAt);
				distAt += textHeight;
				max++;				
				plDebug.addVertex(pt);				
				if (ppProtect.pointInProfile(pt)!=_kPointOutsideProfile)// skip if point within protected range
				{ 
					//PLine(pt, ptText).vis(12);
					continue;
				}
				
				PlaneProfile pp = ppTextBoundary; //ppTextBoundary.vis(5);
				pp.transformBy(pt - ptLoc);
				ppClash = ppProtect;
				bClash = ppClash.intersectWith(pp);		
				if (!bClash)
				{ 
					Point3d ptX = pp.extentInDir(_XW).ptMid();
					dXFlag = _XW.dotProduct(ptX - ptOrg) < 0 ? -1 : 1;
					ptText = ptX - _XW * .5 * pp.dX() *dXFlag;
					ppTextBoundary = pp;	pp.vis(3);
					break;
				}

			}
			//if (plDebug.length() > 0)plDebug.vis(i);	
		}

	// check if location has been manipulated
		int indexRef = ppBoundaries.length();
		if (mapLocations.hasVector3d("vecMove"+indexRef))
		{ 
			Point3d ptTo = _PtW + mapLocations.getVector3d("vecMove" + indexRef)-_XW*.5*dX;
			Vector3d vec = ptTo-ptText;
			ptText.transformBy(vec);
			ppTextBoundary.transformBy(vec);
		}

	//draw text and guide line

		
		Point3d pt1 = pts.first();	
		Point3d pt2 = ptText - dXFlag*_XW*.5 * textHeight;	
		dp.draw(text, ptText, _XW, _YW, dXFlag ,0);
		dp.draw(PLine(pt1,pt2, ptText));
		//arrow
		{ 
			Vector3d vecA = pt1-pt2; vecA.normalize();
			Vector3d vecB = vecA.crossProduct(-_ZW);
			PLine arrow(_ZW);
			arrow.addVertex(pt1);
			arrow.addVertex(pt1-.5*textHeight*(vecA+vecB*.2));
			arrow.addVertex(pt1-.5*textHeight*(vecA-vecB*.2));
			arrow.close();//			arrow.vis(3);
			dp.draw(PlaneProfile(arrow), _kDrawFilled);
		}
		
		
		ppTextBoundary.shrink(-.5*textHeight);	
		ppBoundaries.append(ppTextBoundary); // collect the text boundary for jigging

		//ppTextBoundary.vis(40);
		ppProtect.unionWith(ppTextBoundary);
	}	
}

//End Orthogonal entities//endregion 

//region Trigger AddRemoveFormat


	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveFormat))
	{
		
		String sObjectVariables[0]; 
		for (int i=0;i<ents.length();i++) 
		{ 
			String vars[]= ents[i].formatObjectVariables();
			for (int j=0;j<vars.length();j++) 
				if (sObjectVariables.findNoCase(vars[j],-1)<0)
					sObjectVariables.append(vars[j]); 	 
		}//next i
		
		//sObjectVariables.append(elements.first().formatObjectVariables());
		for (int i=0;i<mapAdditionals.length();i++) 
		{ 
			String s = mapAdditionals.keyAt(i); 
			if (sObjectVariables.find(s)<0)
				sObjectVariables.append(s);
		}//next i
		
	// get translated list of variables
		String sTranslatedVariables[0];
		for (int i=0;i<sObjectVariables.length();i++) 
			sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 		

	// order alphabetically
		for (int i=0;i<sTranslatedVariables.length();i++) 
			for (int j=0;j<sTranslatedVariables.length()-1;j++) 
				if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
				{
					sTranslatedVariables.swap(j, j + 1);
					sObjectVariables.swap(j, j + 1);
				}


		String sPrompt;
		sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
		reportNotice("\n"+sPrompt);

		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			if (mapAdditionals.hasString(key))
				sValue = mapAdditionals.getString(key);
			else if (mapAdditionals.hasDouble(key))
				sValue = mapAdditionals.getDouble(key);
			else if (mapAdditionals.hasInt(key))
				sValue = mapAdditionals.getInt(key);
				
//			for (int j=0;j<elements.length();j++) 
//			{ 
//				String _value = elements[j].formatObject("@(" + key + ")");
//				if (_value.length()>0)
//				{ 
//					sValue = _value;
//					break;
//				}
//			}//next j

			//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		reportNotice("\n"+sPrompt);
		
		int nRetVal = getInt(sPrompt)-1;	

				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newFormat = sFormat;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newFormat = left + right;
					//reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newFormat);				
				}
				else
				{ 
					newFormat+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newFormat);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
				reportNotice("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}
//endregion

//region Trigger MoveTag
	String sTriggerMoveTag = T("|Move Tag|");
	addRecalcTrigger(_kContextRoot, sTriggerMoveTag );
	if (_bOnRecalc && (_kExecuteKey==sTriggerMoveTag || _kExecuteKey==sDoubleClick))
	{

		PrPoint ssP(T("|Select tag|"));
	    Map mapArgs;
	    mapArgs.setPoint3d("ptBase", _Pt0); // add all the info you need for Jigging
	    Map mapBoundaries;
	    for (int i=0;i<ppBoundaries.length();i++) 
	    { 
	    	mapBoundaries.appendPlaneProfile("pp",ppBoundaries[i]); 
	    	 
	    }//next i
	    mapArgs.setMap("Boundary[]", mapBoundaries);
	    int nGoJig = -1;
	    
	    Point3d ptFrom;
	    int indexRef = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig("JigMove", mapArgs); 
       
	        if (nGoJig == _kOk)
	        {
	            Point3d pt = ssP.value(); //retrieve the selected point
	    	// get closest				
				double dist = U(10e5);
				for (int i=0;i<ppBoundaries.length();i++) 
				{ 
					double d = Vector3d(ppBoundaries[i].closestPointTo(pt) - pt).length();
					if (d<dist)
					{ 
						dist = d;
						indexRef = i;
					}
				}        
	            
	            if (indexRef>-1)
	            { 
	            	mapArgs.setPlaneProfile("ppMove",ppBoundaries[indexRef]); 
	            	ptFrom = ppBoundaries[indexRef].extentInDir(_XW).ptMid();
	            }
	            
	            
	            //_PtG.append(ptLast); //append the selected points to the list of grippoints _PtG
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            //eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }			

		
		if (mapArgs.hasPlaneProfile("ppMove") && indexRef>-1)
		{ 
			PrPoint ssP(T("|Select new location|"), ptFrom);
			Point3d ptTo = ptFrom;
			nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig("JigMove", mapArgs); 
	       
		        if (nGoJig == _kOk)
		        {
		            ptTo = ssP.value(); //retrieve the selected point
		            
		            Vector3d vec = ptTo - _PtW;
		            mapLocations.setVector3d("vecMove" + indexRef, vec);
		            _Map.setMap("Location[]", mapLocations);
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            //eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
		}


		setExecutionLoops(2);
		return;
	}
	//endregion	

//region Trigger ResetLocation
	if (mapLocations.length()>0)
	{ 
		String sTriggerResetLocation = T("|Reset Locations|");
		addRecalcTrigger(_kContextRoot, sTriggerResetLocation );
		if (_bOnRecalc && _kExecuteKey==sTriggerResetLocation)
		{
			mapLocations = Map();
			_Map.removeAt("Location[]", true);		
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	

//region Write painter data to properties
	if ((_kNameLastChangedProp==sReferenceName || sPainterStream.length()==0)&& pd.bIsValid())
	{ 
		Map m;
		m.setString("Name", pd.name());
		m.setString("Type",pd.type());
		m.setString("Filter",pd.filter());	
		m.setString("Format",pd.format());	
		
		sPainterStream.set(m.getDxContent(true));
		
		_ThisInst.setCatalogFromPropValues(sLastInserted);
	}	
//End Write painter data to properties//endregion 



//region Info
	String info = scriptName();
	info += "\\P" +T("|Reference|: " + sReference);
	if (ents.length()<1 && bBySelection)
		info += "\\P" +T("|Please select entities by RMC command or select a reference byPainter|");		
	else
		info += "\\P" +T("|Entities| (" + ents.length()+ ")");
		
	if (numNotInView>0)
		info += "\\P" +numNotInView + (numNotInView==1?T(" |entity is not visible in viewport|"):T(" |entities are not visible in viewport|"));
		
	dp.draw(info, _Pt0, _XW, _YW, 1, 0);	
	
// publish protection area
	{ 
		ppProtect.vis(0);
		Map mapX;
		mapX.setPlaneProfile("ppProtect", ppProtect);
		mapX.setInt("Priority", nSequence);//HSB-8276
		_ThisInst.setSubMapX(sSubXKey, mapX);
	}
//End Info//endregion 

#End
#BeginThumbnail







#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="875" />
        <int nm="BreakPoint" vl="890" />
        <int nm="BreakPoint" vl="895" />
        <int nm="BreakPoint" vl="901" />
        <int nm="BreakPoint" vl="915" />
        <int nm="BreakPoint" vl="855" />
        <int nm="BreakPoint" vl="792" />
        <int nm="BreakPoint" vl="698" />
        <int nm="BreakPoint" vl="211" />
        <int nm="BreakPoint" vl="171" />
        <int nm="BreakPoint" vl="195" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10714 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/7/2021 8:56:52 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End