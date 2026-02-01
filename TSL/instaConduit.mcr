#Version 8
#BeginDescription
This tsl creates a conduit between installation cell . It requires the set of tsls: instaCombination, instaCell and instaConduit

#Versions
Version 4.2    06.09.2022    HSB-16090 centered anchoring of combination supported, new property to toggle available anchor node
Version 4.1    06.09.2022    HSB-16089 new command to list all available commands in report dialog
Version 4.0    04.08.2022    HSB-16090 snapping to center of combinations improved 
Version 3.9    29.07.2022    HSB-16090 snapping accepts also center of combination
Version 3.8    26.07.2022    HSB-16095 segemented drills fixed when based on strategy and not connected to bottom or top side
Version 3.7    18.03.2022    HSB-14382 bugfix default strategy, drill support when conduits connects straight to edge in grip mode
Version 3.6    21.01.2022    HSB-14469 bugfix support drill tools in floor elements 
Version 3.5    15.12.2021    HSB-14061 hardware supports strategies with multiple components
Version 3.4    15.12.2021    HSB-14161 bugfixes flip direction, jig on loose conduits
Version 3.3    10.12.2021    HSB-14130 bugfix selection loose genbeams
Version 3.2    06.12.2021    HSB-14061 multiple hardware entries, adding and deleting of entries supported through standard hardware dialog
Version 3.1    01.12.2021    HSB-13729 new settings to control genbeam and combination offsets, solids not facetted
Version 3.0    29.11.2021    HSB-13729 strategies extended
Version 2.9    24.11.2021    HSB-13729 new property 'strategy', new commands added to add/edit/delete a strategy and to import/export settings
Version 2.8    30.09.2021    HSB-13203 supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property
Version 2.7    17.09.2021    HSB-13129 jigging with top or bottom edge direction improved
Version 2.6    16.09.2021    HSB-13129 conduit supports rule based insertion
Version 2.5    20.08.2021    HSB-12825 conduit supports standalone insertion, new command to extend single segmented standalone instances 
Version 2.4    20.07.2021    HSB-12639 new properties to specify a lateral offset of the conduit start and end point
Version 2.3    20.07.2021    HSB-12621 (3) additional group assignment supported
Version 2.2    19.07.2021    HSB-12621 for log walls conduit drills are supported when connecting two vertical cells
Version 2.1    28.06.2021    HSB-12285 polygonal conduits supported for log walls
Version 2.0    25.06.2021    HSB-12285 polygonal conduits supported for SF Walls
Version 1.9    22.04.2021    HSB-11654 a new property 'Zone' has been added to support placement in elements with multiple zones
Version 1.8    31.03.2021    HSB-11413 Debug graphics removed
Version 1.7    30.03.2021    HSB-11413 sharp edges of tool path if radius = 0, HSB-11412 new commands Add/Remove vertex to manipulate tool path
Version 1.6    29.03.2021    HSB-11397 new property 'Radius Contour' to specify the radius polygonal tool path's, OSnap track refers to last vertex
Version 1.5    19.03.2021    HSB-11239 free path and preview jigs enhanced
Version 1.4    17.03.2021    HSB-11239 optional free path added
Version 1.3    16.03.2021    HSB-11218 angled conduits start and end at center of cell
Version 1.2    15.03.2021    HSB-10793 element support added
Version 1.1    02.03.2021    HSB-11000 new properties to specify edge tool
Version 1.0    17.02.2021    HSB-10758 initial version



































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 2
#KeyWords 
#BeginContents
//region Part #1
//region History
// #Versions
// 4.2 06.09.2022 HSB-16090 centered anchoring of combination supported, new property to toggle available anchor node , Author Thorsten Huck
// 4.1 06.09.2022 HSB-16089 new command to list all available commands in report dialog , Author Thorsten Huck
// 4.0 04.08.2022 HSB-16090 snapping to center of combinations improved , Author Thorsten Huck
// 3.9 29.07.2022 HSB-16090 snapping accepts also center of combination , Author Thorsten Huck
// 3.8 26.07.2022 HSB-16095 segemented drills fixed when based on strategy and not connected to bottom or top side , Author Thorsten Huck
// 3.7 18.03.2022 HSB-14382 bugfix default strategy, drill support when conduits connects straight to edge in grip mode , Author Thorsten Huck
// 3.6 21.01.2022 HSB-14469 bugfix support drill tools in floor elements , Author Thorsten Huck
// 3.5 15.12.2021 HSB-14061 hardware supports strategies with multiple components , Author Thorsten Huck
// 3.4 15.12.2021 HSB-14161 bugfixes flip direction, jig on loose conduits , Author Thorsten Huck
// 3.3 10.12.2021 HSB-14130 bugfix selection loose genbeams , Author Thorsten Huck
// 3.2 06.12.2021 HSB-14061 multiple hardware entries, adding and deleting of entries supported through standard hardware dialog , Author Thorsten Huck
// 3.1 01.12.2021 HSB-13729 new settings to control genbeam and combination offsets, solids not facetted , Author Thorsten Huck
// 3.0 29.11.2021 HSB-13729 strategies extended , Author Thorsten Huck]
// 2.9 24.11.2021 HSB-13729 new property 'strategy', new commands added to add/edit/delete a strategy and to import/export settings , Author Thorsten Huck
// 2.8 30.09.2021 HSB-13203 supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property  , Author Thorsten Huck , Author Thorsten Huck
// 2.7 17.09.2021 HSB-13129 jigging with top or bottom edge direction improved , Author Thorsten Huck
// 2.6 16.09.2021 HSB-13129 conduit supports rule based insertion , Author Thorsten Huck
// 2.5 20.08.2021 HSB-12825 conduit supports standalone insertion, new command to extend single segmented standalone instances , Author Thorsten Huck
// 2.4 20.07.2021 HSB-12639 new properties to specify a lateral offset of the conduit start and end point , Author Thorsten Huck
// 2.3 20.07.2021 HSB-12621 (3) additional group assignment supported , Author Thorsten Huck
// 2.2 19.07.2021 HSB-12621 for log walls conduit drills are supported when connecting two vertical cells , Author Thorsten Huck
// 2.1 28.06.2021 HSB-12285 polygonal conduits supported for log walls , Author Thorsten Huck
// 2.0 25.06.2021 HSB-12285 polygonal conduits supported for SF Walls , Author Thorsten Huck
// 1.9 22.04.2021 HSB-11654 a new property 'Zone' has been added to support placement in elements with multiple zones , Author Thorsten Huck
// 1.8 31.03.2021 HSB-11413 Debug graphics removed , Author Thorsten Huck
// 1.7 30.03.2021 HSB-11413 sharp edges of tool path if radius = 0, HSB-11412 new commands Add/Remove vertex to manipulate tool path , Author Thorsten Huck
// 1.6 29.03.2021 HSB-11397 new property 'Radius Contour' to specify the radius polygonal tool path's, OSnap track refers to last vertex , Author Thorsten Huck
// 1.5 19.03.2021 HSB-11239 free path and preview jigs enhanced , Author Thorsten Huck
// 1.4 17.03.2021 HSB-11239 optional free path added , Author Thorsten Huck
// 1.3 16.03.2021 HSB-11218 angled conduits start and end at center of cell , Author Thorsten Huck
// 1.2 15.03.2021 HSB-10793 element support added , Author Thorsten Huck
// 1.1 02.03.2021 HSB-11000 new properties to specify edge tool , Author Thorsten Huck
// 1.0 17.02.2021 HSB-10758 initial version , Author Thorsten Huck
/// <irt Lang=en>
/// no a panel and an insertion point, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a conduit between installation cell . It requires the tsl set instaCombination, instaCell and instaConduit
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaConduit")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Direction|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Tools|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Tools|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset Path|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Connect to Center|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Vertex|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete Vertex|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Strategy|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Strategy|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Strategy Hardware|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete Strategy|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Settings|") (_TM "|Select conduit|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select conduit|"))) TSLCONTENT
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
	String tDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String kStrategy = "Strategy", kTransparency = "Transparency", kDefaultStrategy = T("<|Default|>");
	String kDisabled = T("<|Disabled|>"),kCurrentProfile = T("|Current Profile|"), kBySegment = T("|bySegment|"),kByPath = T("|byPath|");
	String kByCombination = T("|byCombination|");
	String kReferenceSide = T("|Reference Side|");
	String kOppositeSide = T("|Opposite Side|");

	String kSplitSegmentGap ="SplitSegmentGap";
	String kCombiGap ="CombiGap",kSplitSegment ="SplitSegment";
	String kProfile ="Profile";
	String kElementView ="ElementView";
	String kDimStyle ="DimStyle";
	String kTextHeight ="TextHeight";
	String kFormat ="Format";
	String kTagMode ="TagMode";
	String kPlanView ="PlanView";
	String kInstaCell = "instaCell", kInstaConduit = "instaConduit", kInstaCombination = "instaCombination",kSelectNode="SelectNode", kSnaps="Snap[]",kNodes="Node[]",
	tAnchorAny = T("<|Default|>"), tAnchorCell = T("|Cells|"), tAnchorCombination = T("|Combination|");

// distinguish if current background is light or dark	
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
	int green = rgb(19,155,72);;
	
	String sSelectShape = T("|Select Shape|");
	String sTagModes[] = { kDisabled, kBySegment, kByPath };
	
	int bLogger;// = true && !_bOnJig && !_bOnGripPointDrag;//_bOnGripPointDrag;//
	
	//if (bLogger)reportNotice("\nConduit " + _ThisInst.handle() + " starting");
//end Constants//endregion
		
//End Part #1//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>1)
	{ 
	// Set/Add Strategy
		if (nDialogMode == 2 || nDialogMode == 3)
		{
			setOPMKey(_Map.hasString("opmKey")?_Map.getString("opmKey"):"Settings");	
			
			Map mapStrategies = _Map.getMap("Strategy[]");
			String sStrategies[0];
			for (int i=0;i<mapStrategies.length();i++) 
			{ 
				String name = mapStrategies.getString(i);
				if (name.length()>0 && sStrategies.findNoCase(name,-1)<0)
					sStrategies.append(name);	 
			}//next i

			String sNameName=T("|Name|");	
			PropString sName;
			if (nDialogMode==2)
				sName=PropString(nStringIndex++, T("|New Strategy|"), sNameName);					
			else
				sName=PropString(nStringIndex++, sStrategies.sorted(), sNameName);	
			sName.setDescription(T("|Defines the name of the strategy|"));
			sName.setCategory(category);

			String sProfileName=T("|Profile|");				
			String sProfiles[] = {kDisabled,sSelectShape};
			if (_Map.hasPlaneProfile(kProfile))
				sProfiles.append(kCurrentProfile);
			PropString sProfile(nStringIndex++, sProfiles.sorted(), sProfileName);	
			sProfile.setDescription(T("|Defines the profile of the conduit|"));
			sProfile.setCategory(category);


		category = T("|Segments|");
			String sSplitName=T("|Split|");	
			PropString sSplit(nStringIndex++, sNoYes, sSplitName);	
			sSplit.setDescription(T("|Defines the Split|"));
			sSplit.setCategory(category);
			
			String sGapName=T("|Gap Genbeam|");	
			PropDouble dGap(nDoubleIndex++, U(0), sGapName,_kLength);	
			dGap.setDescription(T("|Defines the gap of the splitted segment|"));
			dGap.setCategory(category);

			String sGapCombiName=T("|Gap Combination|");	
			PropDouble dGapCombi(nDoubleIndex++, U(0), sGapCombiName,_kLength);	
			dGapCombi.setDescription(T("|Defines the gap of the to a combination|"));
			dGapCombi.setCategory(category);

		category = T("|Tagging|");
			String sTagModeName=T("|Tag Mode|");	
			PropString sTagMode(nStringIndex++, sTagModes, sTagModeName);	
			sTagMode.setDescription(T("|Defines the Tag Mode|"));
			sTagMode.setCategory(category);

			String sFormatName=T("|Format|");	
			PropString sFormat(nStringIndex++, "@(ArticleNumber)\PL:@(ScaleX:RL0)", sFormatName);	
			sFormat.setDescription(T("|Defines the format how poperties of hardware are resolved.|"));
			sFormat.setCategory(category);

			String sDimStyleName=T("|Dimstyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the dimension style|"));
			sDimStyle.setCategory(category);
			
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(50), sTextHeightName,_kLength);	
			dTextHeight.setDescription(T("|Defines the text height|"));
			dTextHeight.setCategory(category);

		category = T("|Plan View|");
			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 80, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the transparency in plan view.|"));
			nTransparency.setCategory(category);
					
		category = T("|Element View|");	
			PropInt nTransparencyElem(nIntIndex++, 80, sTransparencyName);	
			nTransparencyElem.setDescription(T("|Defines the transparency in element view.|"));
			nTransparencyElem.setCategory(category);			
		}	
	// Delete Strategy
		else if (nDialogMode == 4)
		{
			setOPMKey(_Map.hasString("opmKey")?_Map.getString("opmKey"):"Settings");	
			
			Map mapStrategies = _Map.getMap("Strategy[]");
			String sStrategies[0];
			for (int i=0;i<mapStrategies.length();i++) 
			{ 
				String name = mapStrategies.getString(i);
				if (name.length()>0 && sStrategies.findNoCase(name,-1)<0)
					sStrategies.append(name);	 
			}//next i

			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, sStrategies, sNameName);	
			sName.setDescription(T("|Defines the name of the strategy|"));
			sName.setCategory(category);			
		}		
		
		return;
	}
//End DialogMode//endregion

//region Get Cells and/or Combinations
// get first tslInst from entity
	TslInst cells[0], combinations[0];
	Vector3d vecFaceParent;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		TslInst t = (TslInst)_Entity[i]; 
		if (!t.bIsValid()){ continue;}
		
		String script = t.scriptName();
		if (script.find(kInstaCell,0, false)==0 && script.length()==kInstaCell.length())
		{
			Map m = t.subMapX(kInstaCombination);
			if (m.hasVector3d("vecFace") && vecFaceParent.bIsZeroLength())
				vecFaceParent = m.getVector3d("vecFace");
			cells.append(t);
			setDependencyOnEntity(t);
			//reportNotice("\n" +_ThisInst.handle() + " depends on " + t.scriptName() + " " + t.handle() );
		}
	}

	if (cells.length()<2)
		for (int i=0;i<_Entity.length();i++) 
		{ 
			//if (bLogger)reportNotice("\ntype " + _Entity[i].typeDxfName());
			TslInst t = (TslInst)_Entity[i]; 
			if (!t.bIsValid()){ continue;}

			String script = t.scriptName();
			if (script.find(kInstaCombination,0, false)==0 && script.length()==kInstaCombination.length())
			{
				Map m = t.subMapX(kInstaCombination);
				if (m.hasVector3d("vecFace") && vecFaceParent.bIsZeroLength())
					vecFaceParent = m.getVector3d("vecFace");
				combinations.append(t);
				setDependencyOnEntity(t);
				//reportNotice("\n" +_ThisInst.handle() + " depends on " + t.scriptName() + " " + t.handle() );
			}
		}
	//if (bLogger)reportNotice("\nConduit " + _ThisInst.handle() +"cells/combis: " +cells.length() + "/"+combinations.length());	
	
	Entity ent1, ent2; // the entities where the conduit might be linked to
	{ 
		Vector3d vecN1 = _Map.getVector3d("vecN1");
		if ( ! vecN1.bIsZeroLength())
		{
			Entity e = _Map.getEntity("ent1");
			if (e.bIsValid() && _Entity.find(e)>-1)
				ent1 = e;
		}
		Vector3d vecN2 = _Map.getVector3d("vecN2");
		if ( ! vecN1.bIsZeroLength())
		{
			Entity e = _Map.getEntity("ent2");
			if (e.bIsValid() && _Entity.find(e)>-1)
				ent2 = e;
		}
	}

	vecFaceParent.vis(_Pt0, 70);
//End  Get Cells and/or Combinations//endregion

//region Part #2 JIG

//region Collect nodes when dragging _PtG0 or _PtG1
	String sJigEditPath = "JigEditPath";
	String sJigDeleteVertex= "JigDeleteVertex";
	String sTriggerAddVertex = T("|Add Vertex|");
	int bOnTriggerAddVertex = _bOnRecalc && _kExecuteKey == sTriggerAddVertex;
	String sGripEvents[] = { "_PtG0", "_PtG1"};
	int nGripEvent = sGripEvents.find(_kExecuteKey);
	int nLastChangedEvent = sGripEvents.find(_kNameLastChangedProp);
	int bOnDrag = _bOnGripPointDrag && (nGripEvent==0 || nGripEvent==1);
	int bOnEditPath = _bOnJig && _kExecuteKey == sJigEditPath;
	//Collect nodes of all cells which are available with the references
	Map mapArgs=_Map;

	//if (bLogger)reportNotice("\nConduit " + _ThisInst.handle() +"\n	_GenBeams: " +_GenBeam.length()+"\n	bOnTriggerAddVertex: " +bOnTriggerAddVertex+"\n	bOnEditPath: " +bOnEditPath +"\n	bOnDrag: " +bOnDrag + "\n	LastChangedEvent: " +nLastChangedEvent);
	if ((nLastChangedEvent>-1 || bOnDrag || bOnEditPath || bOnTriggerAddVertex) && _GenBeam.length()>0)
	{ 	
		
	// Get anchor mode from map
		int nAnchorMode = _Map.getInt("AnchorMode"); // 0 = any, 1=cell, 2 = combination
		
		
		//_Map.removeAt("ConnectionType", true);
		GenBeam gb = _GenBeam.first();
		Element el = gb.element();		

	//region Collect all combinations of current element 
		Entity tents[0];
		if (el.bIsValid())
		{ 
			TslInst tsls[]=el.tslInstAttached();
			for (int i=0;i<tsls.length();i++) 
				if (tents.find(tsls[i])<0)
					tents.append(tsls[i]);
		}
	// Collect all combinations of current set of genbeams 	
		else
		{ 
			for (int i=0;i<_GenBeam.length();i++) 
			{ 
				Entity ents[]= _GenBeam[i].eToolsConnected();
				for (int j=0;j<ents.length();j++) 
					if (tents.find(ents[j])<0)
						tents.append(ents[j]);		 
			}//next i			
		}	
	//End Collect combinations//endregion 

	//region Set Nodes
		Map mapNodes,mapCombinationNodes;
		Vector3d vecDir, vecPerp, vecZ;
		double dWidth;
		for (int i=0;i<tents.length();i++) 
		{ 
			TslInst t= (TslInst)tents[i];
			if (!t.bIsValid()){ continue;}
			
			String script = t.scriptName();
			if (script.find(kInstaCombination,0, false)==0 && script.length()==kInstaCombination.length())
			{ 	
				Map map = t.map();
				Vector3d _vecFace = map.getVector3d("vecFace");
				
			// ignore if not on same face //TODO implement a toggle to be able to connect either side
				if (!vecFaceParent.bIsZeroLength() && !_vecFace.bIsZeroLength() && !_vecFace.isCodirectionalTo(vecFaceParent))
				{ 
					//if (bLogger)reportNotice("\n"+i+" refusing because not on same side");
					continue;
				}
				if (vecDir.bIsZeroLength())vecDir = map.getVector3d("vecDir");
				if (vecZ.bIsZeroLength())vecZ = _vecFace;

				
				Map m;
				if (nAnchorMode!=2)
					m= map.getMap("Node[]");
				for (int j=0;j<m.length();j++) 
					mapNodes.appendMap("Node", m.getMap(j)); 
				
				m = t.subMapX(kInstaCombination);
				if (nAnchorMode!=1)
					mapCombinationNodes.appendMap("entry", m);					
					
					
			}
		}//next i
		
		mapArgs.setMap("Node[]", mapNodes);
		mapArgs.setMap("CombinationNode[]", mapCombinationNodes);
	//endregion 

	// set vecs		
		mapArgs.setVector3d("vecZ",vecZ);
		mapArgs.setVector3d("vecDir", vecDir);
		mapArgs.setDouble("Width", dWidth<=0?U(70):dWidth);//_Sip[0].vecX());		
		
	// set ptJig to active grip when dragging	
		if ((nGripEvent==1 || nLastChangedEvent == 1) && _PtG.length()>1)
			mapArgs.setPoint3d("_PtJig", _PtG[1]);
		else
			mapArgs.setPoint3d("_PtJig", _PtG[0]);			
	}	
//End Collect nodes when dragging _Pt0 or _PtG//endregion 

//region JIG Edit Path
	if (bOnEditPath)
	{ 
		if (bLogger)reportNotice("\nedit path mode");
	
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		double radius = _Map.getDouble("radius");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptLogCourses[] = _Map.getPoint3dArray("ptCourse[]"); // potential log course locations
		int numGrip =  _Map.getInt("numGrip");
		int nAppendAt =  _Map.getInt("appendAt");
	
		double dWidth = mapArgs.getDouble("Width");
	    Map mapNodes = mapArgs.getMap("Node[]");
	    
	//region Draw receptor nodes
		Display dp(7),dp2(-1);
		dp2.trueColor(red);
	    double a = dWidth*.5;
	    if (a <= 0)a = U(15);	
		Vector3d vecNormal;
		Point3d ptSnap = ptJig;
	
		PlaneProfile ppSub(CoordSys(ptJig, vecX, vecY, vecZ));
		for (int i=0;i<mapNodes.length();i++) 
		{ 
			Map m= mapNodes.getMap(i);
			Point3d pt = m.getPoint3d("pt");
			Vector3d vecN= m.getVector3d("vecNormal");
			Vector3d vecP = vecN.crossProduct(-vecZ);

	
			PLine pl(pt+vecP*a*.5,pt-vecP*a*.5,pt+vecN * (a*.5/tan(30)));
			pl.close();
			
			PlaneProfile ppSnap;
			ppSnap.createRectangle(LineSeg(pt-vecP*a, pt+vecP*a+vecN*2*a), vecN, vecP);			
			{
				PLine pl(pt - vecN * (a/ tan(45)),pt+vecP*a,pt-vecP*a);
				ppSnap.joinRing(pl, _kAdd);
			}		
			if (bDebug)dp2.draw(ppSnap);
				
		// set color
			if (ppSnap.pointInProfile(ptJig)==_kPointInProfile)
			{
				vecNormal = vecN;
				ptSnap = pt;
				dp2.draw(PlaneProfile(pl),_kDrawFilled);
				ppSub.unionWith(PlaneProfile(pl));
			}
			dp.draw(pl);	 
		}//next i
			
	//End Draw receptor nodes		
	//endregion 


	//region add jig point to path
		if (pts.length()>0)
		{ 
			ptJig+=vecZ*vecZ.dotProduct(pts.first()-ptJig);	
			
//		// snap to log course location if applicable
//			if (ptLogCourses.length()>0)
//			{ 
//				double dist = U(10e5);
//				Point3d ptG = ptJig;
//				for (int j=0;j<ptLogCourses.length();j++) 
//				{ 
//					Point3d ptCourse = ptLogCourses[j]; 
//					double d = abs(vecY.dotProduct(ptCourse-ptJig));
//					if (d<dist)
//					{ 
//						dist = d;
//						ptG = ptCourse;
//				
//					}
//				}//next j	
//				if (abs(vecY.dotProduct(ptG-ptJig))>dEps)
//					ptJig += vecY * vecY.dotProduct(ptG - ptJig);				
//			}		
			pts.insertAt(nAppendAt, ptJig);
			
		}

	//End add jig point to path//endregion 
	

	//region Draw new route
		Display dpJig(-1);
		dpJig.trueColor(darkyellow,50);
		
		PlaneProfile pp(CoordSys(ptJig, vecX, vecY, vecZ));
		for (int i=0;i<pts.length()-1;i++) 
		{ 
			Point3d pt1 = pts[i];
			Point3d pt2 = pts[i+1];
			Vector3d vec = pt2 - pt1;
			if (vec.length()<dEps)continue;
			vec.normalize();
			Vector3d vecN = vec.crossProduct(-vecZ);
			
			PLine pl(vecZ);
			pl.addVertex(pt1 + vecN * radius);
			pl.addVertex(pt2 + vecN * radius);
			pl.addVertex(pt2 - vecN * radius, -tan(45));
			pl.addVertex(pt1 - vecN * radius);
			pl.addVertex(pt1 + vecN * radius, -tan(45));
			pl.close();			 
			pp.joinRing(pl, _kAdd);
		}//next i
		dpJig.draw(pp, _kDrawFilled);			
	//End Draw new route//endregion 


		return;
	}
//End JIG Edit Path//endregion 

//region JIG Delete Vertex
	if (_bOnJig && _kExecuteKey == sJigDeleteVertex)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");	
		double radius = _Map.getDouble("radius");
		
		Display dpJig(-1);
		for (int i=0;i<_PtG.length();i++) 
		{ 
			PLine pl;
			pl.createCircle(_PtG[i], vecZ, radius);
			pl.convertToLineApprox(radius / 20);
			PlaneProfile pp(pl);
			if (pp.pointInProfile(ptJig)!=_kPointOutsideProfile)
			{
				dpJig.trueColor(red,40);
				dpJig.draw(pp, _kDrawFilled);
			}
			else
				dpJig.trueColor(darkyellow,0);
			dpJig.draw(pl); 
		}//next i
		return;
	}	
//endregion 

//region JIG bOnDrag

//region Snap to new node after _PtG0 or _PtG1 has been dragged
	if ((nLastChangedEvent==0 || nLastChangedEvent==1) && !bOnDrag)
	{ 
		if (bLogger)reportNotice("\nSnap to new node after drag");	
		Map mapNodes = mapArgs.getMap("Node[]");

		Vector3d vecZ = mapArgs.getVector3d("vecZ");
		double dWidth = mapArgs.getDouble("Width");
		double a = dWidth*.5;
		if (a <= 0)a = U(14);

//		{ 
//			EntPLine epl;
//			epl.dbCreate(PLine((nLastChangedEvent == 0 ? _PtG[0] : _PtG[1]), _PtW));
//		}	
	
      
    // snap to node
    	int bSuccess;
		for (int i=0;i<mapNodes.length();i++) 
		{ 
			Map m= mapNodes.getMap(i);
			Point3d pt = m.getPoint3d("pt");
			Vector3d vecN= m.getVector3d("vecNormal");
			Vector3d vecP = vecN.crossProduct(-vecZ);
			Entity cell = m.getEntity("cell");

			PlaneProfile ppSnap;
			ppSnap.createRectangle(LineSeg(pt-vecP*a, pt+vecP*a+vecN*2*a), vecN, vecP);			
//			{
//				PLine pl(pt - vecN * (a/ tan(45)),pt + vecP * a,pt - vecP * a);
//				ppSnap.joinRing(pl, _kAdd);
//			}
		
		// snap to first grip _PtG0
			if (nLastChangedEvent == 0 && ppSnap.pointInProfile(_PtG[0])==_kPointInProfile)
			{
			// find cuurent cell
				Entity cellX= _Map.getEntity("cell1");// HSB-14161
				int n = cellX.bIsValid()?_Entity.find(cellX):-1;
				if (n>-1)	_Entity[n] = cell;
				else		_Entity[0]=cell;
				_Map.setInt("nodeIndexA", m.getInt("nodeIndex"));
				_Map.setVector3d("vecN1", m.getVector3d("vecNormal"));
				_Map.setEntity("cell1", cell);
				_PtG[0] = pt;
				bSuccess = true;
//				_Map.removeAt("ConnectionType",true); 
				break;
			}
		// snap to second grip _PtG1
			else if (nLastChangedEvent == 1 && ppSnap.pointInProfile(_PtG[1])==_kPointInProfile)
			{
			// find cuurent cell
				Entity cellX= _Map.getEntity("cell2");// HSB-14161
				int n = cellX.bIsValid()?_Entity.find(cellX):-1;
				if (n>-1)	_Entity[n] = cell;
				else		_Entity[0]=cell;
				_Map.setInt("nodeIndexB", m.getInt("nodeIndex"));
				_Map.setVector3d("vecN2", m.getVector3d("vecNormal"));
				_Map.setEntity("cell2", cell);
				_PtG[1] = pt;
				bSuccess = true;
//				_Map.removeAt("ConnectionType",true); 
				break;
			}	
		}//next i
		if (bLogger && bSuccess)reportNotice("\nsuccessfully snapped to cell");

	//region Combination nodes
		if (!bSuccess)
		{ 	 
			Point3d pt = nLastChangedEvent == 1 ? _PtG[1] : _PtG[0];
			Map mapCombinationNodes = mapArgs.getMap("CombinationNode[]");
			if (bLogger)reportNotice("\nsearching contact in combinNodes (" + mapCombinationNodes.length() +")");
			for (int j=0;j<mapCombinationNodes.length();j++) 
			{ 	
				Map map = mapCombinationNodes.getMap(j);
				Map mapSnaps = map.getMap(kSnaps); 
				Entity t = map.getEntity("ent");
				//if (bLogger)reportNotice("\ncombiNode " +j + " with snaps("+mapSnaps.length()+")" + (t.bIsValid()?"OK":"invalid") );
				for (int i=0;i<mapSnaps.length();i++) 
				{ 
					PlaneProfile ppSnap= mapSnaps.getPlaneProfile(i); 
					//if (bLogger)reportNotice("\n   pp[" + i+"]" +ppSnap.ptMid().X() + " vs " + pt.X() );
				// get snap result
					if (ppSnap.pointInProfile(pt)==_kPointInProfile)
					{
						Vector3d vecN  = ppSnap.coordSys().vecX();
						pt = ppSnap.ptMid()+vecN*.5*ppSnap.dX();

					// find and remove cuurent cell
						Entity cellX= _Map.getEntity(nLastChangedEvent==0?"cell1":"cell2");
						int n = cellX.bIsValid()?_Entity.find(cellX):-1;
						if (n >- 1)_Entity.removeAt(n);
						if (bLogger)reportNotice("\n   cell removed at " + n + " on event index " + nLastChangedEvent);
						
						if (nLastChangedEvent==0)
						{ 
						// remove current nodeIndex
							 _Map.removeAt("nodeIndexA", true);

							_Map.setVector3d("vecN1", vecN);	
							_Map.setEntity("ent1", t);
							_PtG[0] = pt;
						}
						else if (nLastChangedEvent==1)
						{ 
						// remove current nodeIndex
							 _Map.removeAt("nodeIndexB", true);
							 
							_Map.setVector3d("vecN2", vecN);	
							_Map.setEntity("ent2", t);
							_PtG[1] = pt;
						}
						
					// append combination and new connection vector
						_Entity.append(t);	
						_Map.removeAt("ConnectionType", true);
						bSuccess = true;
						if (bLogger)reportNotice("\n   connected " + t.handle() + " on event index " + nLastChangedEvent);
						break;
					}
				}//next i
				if (bSuccess)break;
			}//next j			
		
			
		}//endregion 
//		if (!bSuccess)
//		{ 
//			if (bLogger)reportNotice("\n   trying to snap to combinations " + combinations.length());
//			Point3d pt = nLastChangedEvent == 1 ? _PtG[1] : _PtG[0];
//			for (int i=0;i<combinations.length();i++) 	
//			{ 
//				TslInst t = combinations[i]; 
//				Map m = t.subMapX(kInstaCombination);
//				m = m.getMap(kSnaps);
//				//if (bLogger)reportNotice("\n   map " + m + " keys:" + t.subMapXKeys() + " vs " + kInstaCombination);
//				PlaneProfile pp;
//				for (int j=0;j<m.length();j++) 
//				{
//					if (m.hasPlaneProfile(j)) 
//					{
//						pp = m.getPlaneProfile(j);
//						
//						if (j==0 && pp.pointInProfile(pt)!=_kPointOutsideProfile)
//							bSuccess = true;
//						else if (pp.pointInProfile(pt)==_kPointInProfile)
//							bSuccess = true;
//						
//						if (bSuccess)
//						{
//							Vector3d vecN = pp.coordSys().vecX();
//							pt = pp.ptMid() + vecN * .5 * pp.dX();
//							//if (bLogger)
//							reportNotice("\n  snapped to " +j + " in dir " + vecN);
//							
//							// find and remove cuurent cell
//							Entity cellX= _Map.getEntity(nLastChangedEvent==0?"cell1":"cell2");
//							int n = cellX.bIsValid()?_Entity.find(cellX):-1;
//							if (n >- 1)_Entity.removeAt(n);
//							if (bLogger)reportNotice("\n   cell removed at " + n + " on event index " + nLastChangedEvent);
//							 
//							 // remove current nodeIndex
//							 _Map.removeAt((nLastChangedEvent==0?"nodeIndexA":"nodeIndexB"), true);
//							
//							// append combination and new connection vector
//							_Entity.append(t);
//							
//							if (nLastChangedEvent==0)
//							{ 
//								_Map.setVector3d("vecN1", vecN);	
//								_Map.setEntity("ent1", t);
//								_PtG[0] = pt;
//							}
//							else if (nLastChangedEvent==1)
//							{ 
//								_Map.setVector3d("vecN2", vecN);	
//								_Map.setEntity("ent2", t);
//								_PtG[1] = pt;
//							}														
//							break;
//						}
//					}						
//				}
//				if (bSuccess)
//				{
//					if (nLastChangedEvent == 0)
//					{
//						_Map.removeAt("nodeIndexA", true);
//						_Map.setVector3d("vecN1", pp.coordSys().vecX());
//					}
//
//					if (nLastChangedEvent == 1)
//					{ 
//						_Map.removeAt("nodeIndexB", true);
//						_Map.setVector3d("vecN2", pp.coordSys().vecX());								
//					}					
//					break;
//				}
//				if (bLogger)reportNotice("\nsuccessfully snapped to combination " + t.handle());
//			}	
//
//		}
//		
		if (!bSuccess)
		{ 
			if (nLastChangedEvent == 0)
			{ 
				_Map.removeAt("nodeIndexA", true);
				_Map.removeAt("vecN1", true);
				int n = _Entity.find(_Map.getEntity("cell1"));
				if (n >- 1)_Entity.removeAt(n);
				_Map.setInt("ConnectionType",5); // change to free path
			}
			else if (nLastChangedEvent == 1)
			{ 
				_Map.removeAt("nodeIndexB", true);
				_Map.removeAt("vecN2", true);
				int n = _Entity.find(_Map.getEntity("cell2"));
				if (n >- 1)_Entity.removeAt(n);
				_Map.setInt("ConnectionType",5); // change to free path
			}	
		}		

		setExecutionLoops(2);
		return;
	}
//End Snap to new node when _Pt0 is dragged//endregion 	
	
//region Show receptor nodes
	if (bOnDrag || (_bOnJig && _kExecuteKey==kSelectNode)) 
	{
		Map map = bOnDrag ? mapArgs : _Map;

		Point3d ptBase = map.getPoint3d("_PtBase"); 
	    Point3d ptJig = map.getPoint3d("_PtJig"); // running point
	    Vector3d vecDir = map.getVector3d("vecDir");
	    Vector3d vecX = map.getVector3d("vecX");
	    Vector3d vecY = map.getVector3d("vecY");
	    Vector3d vecZ = map.getVector3d("vecZ");
	    Point3d ptLogCourses[] = _Map.getPoint3dArray("ptCourse[]"); // potential log course locations
	    Map mapNodes = map.getMap("Node[]");
	    double dWidth = map.getDouble("Width");
	    double dDepth = map.getDouble("Depth"); // depth <= 0 means attempt to insert a drill conduit
	    double radius = map.getDouble("Radius");
	    double dOffsetXA = _Map.getDouble("offsetXA");
	    int nConnectionType = _Map.getInt("ConnectionType");


		int bCTNotDefined = nConnectionType == 0;	// 0 = not defined
		int bCTStraight = nConnectionType == 1;	// 1 = angled
		int bCTAngled = nConnectionType == 2;	// 2 = angled
		int bCTDoubleAngled = nConnectionType == 3;	// 3 = double angled
		int bCTStraightToEdge = nConnectionType == 4;	// 4 = straight to edge
		int bCTFreePath = nConnectionType == 5;	// 5 = free path
		int bCTDoubleAngledHorizontal = nConnectionType == 6;	// 6 = double angled (horizontal)	    

	    PlaneProfile ppContour = _Map.getPlaneProfile("Contour");
	    Vector3d vecOrg;
	    if (_Map.hasVector3d("prevLoc") && nGripEvent==0)
	   	{
	   		vecOrg = (_PtW + _Map.getVector3d("prevLoc")) - ptJig;
	   		ppContour.transformBy(vecOrg);
	   	}

	    Display dp(7),dp2(-1);
		dp2.trueColor(red,0);
		
	//region Draw receptor nodes
	    double a = dWidth*.5;
	    if (a <= 0)a = U(15);
	    double a1 = a * .5 / tan(30);
	    double b = a / tan(40);
		Vector3d vecNormal;
		Point3d ptSnap = ptJig;
	
		CoordSys csJig(ptJig, vecX, vecY, vecZ);
		PlaneProfile ppSub(csJig);
		
		//region Cell nodes
		for (int i=0;i<mapNodes.length();i++) 
		{ 
		// get node map	
			Map m= mapNodes.getMap(i);
			Point3d pt = m.getPoint3d("pt");
			Vector3d vecN= m.getVector3d("vecNormal");		
			Vector3d vecP = vecN.crossProduct(-vecZ);

		// triangle to display and overlaying larger snap contour
			PLine pl(pt+vecP*a*.5,pt-vecP*a*.5,pt+vecN * a1);
			pl.close();	
			PlaneProfile ppSnap(csJig);
			ppSnap.createRectangle(LineSeg(pt-vecP*a, pt+vecP*a+vecN*b), vecN, vecP);			
//			{
//				PLine pl(pt - vecN * (a/ tan(45)),pt+vecP*a,pt-vecP*a);//);,pt + vecN * b
//				ppSnap.joinRing(pl, _kAdd);
//			}		
			//if (bDebug)dp2.draw(ppSnap);
				
		// draw snap result if jig within snap range
			if (ppSnap.pointInProfile(ptJig)==_kPointInProfile)
			{
				vecNormal = vecN;
				ptSnap = pt;
				dp2.draw(PlaneProfile(pl),_kDrawFilled);
				ppSub.unionWith(PlaneProfile(pl));	
			}
			dp.draw(pl);				
		}//next i			
		//endregion 
		
		//region Combination nodes
		Map mapCombinationNodes = map.getMap("CombinationNode[]");
		for (int j=0;j<mapCombinationNodes.length();j++) 
		{ 	
			Map mapSnaps = mapCombinationNodes.getMap(j).getMap(kSnaps); 
			for (int i=0;i<mapSnaps.length();i++) 
			{ 
				PlaneProfile ppSnap= mapSnaps.getPlaneProfile(i); 
			// draw snap result
				if (ppSnap.pointInProfile(ptJig)==_kPointInProfile)
				{
					vecNormal = ppSnap.coordSys().vecX();
					ptSnap = ppSnap.ptMid()+vecNormal*.5*ppSnap.dX();
					dp2.draw(ppSnap,_kDrawFilled);
					ppSub.unionWith(ppSnap);	
				}
				dp.draw(ppSnap);
			}//next i			 
		}//next j			
		//endregion 

	//End Draw receptor nodes
	//endregion  

	//region Draw jig route
		if (radius <= 0)return;
		Display dpJig(-1);
		
		int bHasSnap = !vecNormal.bIsZeroLength();
		Vector3d vecN1=_Map.getVector3d("vecN1");
		Vector3d vecN2=_Map.getVector3d("vecN2");
		int nFace = _Map.hasInt("face") ? _Map.getInt("face") : 1;
		
		Vector3d vecYN1 = (vecN1.isParallelTo(vecY)?vecY:vecN1).crossProduct(-vecZ);
		
		Point3d ptGrips[] = _Map.getPoint3dArray("grips"); // will contain the grips on bOninsert

		Point3d ptFrom, ptTo;
		int bInsert, info;
		
		// edit
		if (_PtG.length()>1)
		{ 
			ptGrips = _PtG;
			Point3d pts[0];
			if (nGripEvent==0) // revert the grips
			{ 
				pts.append(ptGrips[1]);
				for (int i=ptGrips.length()-1; i>=0 ; i--) 
				{ 
					if (i == 1)continue;
					pts.append(ptGrips[i]); 
				}//next i
			}
			else
			{ 
				for (int i=0;i<ptGrips.length();i++) 
				{ 
					if (i == 1)continue;
					pts.append(ptGrips[i]); 		 
				}//next i
				pts.append(ptGrips[1]);				
			}
			ptGrips = pts;
		}		
		
		if (ptGrips.length()>0)//_Map.hasPoint3d("node1"))
		{
			ptFrom = ptGrips.first();//_Map.getPoint3d("node1");	
			vecN2 = vecN1;
			bInsert =  _PtG.length()<2;
			info = 1;
		}
		else if (bCTStraightToEdge)
		{
			ptFrom = ptSnap+vecYN1*dOffsetXA;
		}
		
	// no snap to any receptor found
		if (!bHasSnap)
		{
			ptTo = ptJig+vecZ * vecZ.dotProduct(ptFrom - ptJig);
			info = 40;
		// snap to log course location if applicable
			if (ptLogCourses.length()>0)
			{ 
				double dist = U(10e5);
				Point3d ptG = ptTo;
				for (int j=0;j<ptLogCourses.length();j++) 
				{ 
					Point3d ptCourse = ptLogCourses[j]; 
					double d = abs(vecY.dotProduct(ptCourse-ptTo));
					if (d<dist)
					{ 
						dist = d;
						ptG = ptCourse;
				
					}
				}//next j	
				if (abs(vecY.dotProduct(ptG-ptTo))>dEps)
					ptTo += vecY * vecY.dotProduct(ptG - ptTo);	
					
				info = 20;	
			}

			if (!vecN1.bIsZeroLength())
			{
				vecNormal = vecN1;
				Vector3d vecPerp = vecNormal.crossProduct(-vecZ);
				double dX = vecNormal.dotProduct(ptTo-ptFrom);
				double dY = vecPerp.dotProduct(ptTo-ptFrom);
				if (abs(dY) > abs(dX))// simple angled
				{
					vecN2 = vecN1;
					vecNormal = vecPerp; 
				}
				else vecN2 = -vecN1;		 // double angled
				
				info = 30;
			}
			
		}
		else
		{
			info = 3;
			ptTo = ptSnap+vecZ * vecZ.dotProduct(ptFrom - ptSnap);
		}
		
	
	// snap straight to edge if ptJig is closed to the edge or near to start
		Point3d pts[0];
		int bSnapToEdge;	
		if (dDepth<=0 && (bCTNotDefined || bCTStraightToEdge) && !vecN1.bIsZeroLength())
		{ 
			Vector3d vecP = vecN1.crossProduct(-vecZ);
			Point3d ptsContour[] = ppContour.intersectPoints(Plane(ptFrom, vecP), true, true);
			ptsContour = Line(ptFrom, - vecN1).orderPoints(ptsContour, dEps);
			if (ptsContour.length()>0)
			{ 
				double d1 = vecN1.dotProduct(ptJig - ptFrom);
				double d2 = abs(vecN1.dotProduct(ptJig - ptsContour.first()));
				double min = radius * 5;
				if ((d1>0 && d1<min) || d2<min)
				{
					dpJig.trueColor(darkyellow);
					pts.append(ptFrom);
					ptTo = ptsContour.first();
					bSnapToEdge = _PtG.length()<2;
				}
			}
		}
	// grip route		
		if (bCTFreePath || (bInsert && !bHasSnap))
		{ 
			dpJig.trueColor(darkyellow);
			pts = ptGrips;
			info = 40;
		}			
	// auto route
		else if (!bSnapToEdge)
		{ 
			info = 50;
			dpJig.trueColor(darkyellow);
			double dX = vecX.dotProduct(ptTo-ptFrom);
			double dY = vecY.dotProduct(ptTo-ptFrom);

			pts.append(ptFrom);
			if (abs(dX)>dEps && abs(dY)>dEps) // not in line with X or Y
			{ 
				info = 51;
				Point3d pt1, pt2, ptM;
			// double angled	
				if (vecNormal.isParallelTo(vecN2))
				{ 
					ptM = (ptTo + ptFrom) * .5;
					pt1 = ptFrom + vecN2 * vecN2.dotProduct(ptM - ptFrom);
					pt2 = ptTo + vecN2 * vecN2.dotProduct(ptM - ptTo);
					
					pts.append(pt1);
					pts.append(pt2);
					info = 52;
				}
			// single angled	
				else if (Line(ptFrom, vecN2).hasIntersection(Plane(ptTo, vecN2), pt1))
				{
					pts.append(pt1);
					info = 53;
				}
			}				
		}
		else 
		{
			//pts.append(ptFrom);
			//ptTo = ptFrom + vecNormal * U(300);
			info = 60;
		}
		
		
		pts.append(ptTo);
		pts = Plane(ptFrom,vecZ).projectPoints(pts);
			

		
		PlaneProfile pp(CoordSys(ptFrom, vecX, vecY, vecZ));
		for (int i=0;i<pts.length()-1;i++) 
		{ 
			Point3d pt1 = pts[i];
			Point3d pt2 = pts[i+1];
			
			Vector3d vec = pt2 - pt1;
			if (vec.length()<dEps)continue;
			vec.normalize();
			Vector3d vecN = vec.crossProduct(-vecZ);
			
			PLine pl(vecZ);
			pl.addVertex(pt1 + vecN * radius);
			pl.addVertex(pt2 + vecN * radius);
			pl.addVertex(pt2 - vecN * radius, -tan(45));
			pl.addVertex(pt1 - vecN * radius);
			pl.addVertex(pt1 + vecN * radius, -tan(45));
			pl.close();			 
			pp.joinRing(pl, _kAdd);

		}//next i
		pp.subtractProfile(ppSub);
		dpJig.draw(pp);
		dpJig.transparency(60);
		dpJig.draw(pp, _kDrawFilled);
		
//		dpJig.transparency(0);
//		dpJig.draw("CType " +nConnectionType + "info " +info+ 
//		"\PvecN1: " + vecN1+	"\PvecN2: " + vecN2+ "\PvecNormal: " + vecNormal +
//		"\PGrips: "+ptGrips.length() + "\PPtG " + _PtG.length()+ "\Ppts " + pts.length(), ptJig, _XW, _YW, 0, 0, _kDeviceX );
//		
	//End Draw jig route//endregion 
	
	    return;
	}			


//End Show receptor nodes//endregion 

//endregion		
//End Part #2 JIG//endregion  

//region Part #3 Settings, Get Parent,Properties

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="instaConduit";
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
	
// Setting properties	
	Map mapStrategies;
	String sStrategies[0];

{
	
	String k;
	mapStrategies=mapSetting.getMap("Strategy[]");
	for (int i=0;i<mapStrategies.length();i++) 
	{ 
		Map m = mapStrategies.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && sStrategies.findNoCase(name,-1)<0 && name.find(kDefaultStrategy,0,false)<0)
			sStrategies.append(name);	 
	}//next i
	sStrategies = sStrategies.sorted();	
	sStrategies.insertAt(0, kDefaultStrategy);
}


//End Read Settings//endregion 
	
//region Get parent entity
	Element el;
	if (_Element.length() > 0)el = _Element[0];
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg, ptCen;
	double dZ;
	int bHasElement = el.bIsValid(), bHasSip, bIsLogWall, bIsSipWall, bIsSFWall, bIsFloor,bAddElementTool;
	Sip sip, sips[0];
	Beam beams[0]; 
	Sheet sheets[0];
	GenBeam genbeams[0]; genbeams=_GenBeam;

// Get element if not found yet
	if(!bHasElement)
		for (int i=0;i<genbeams.length();i++) 
		{ 
			Element _el = genbeams[i].element(); 
			if (_el.bIsValid())
			{ 
				el = _el;
				_Element.append(_el);
				break;
			}
		}//next i
	
//region Identify wall type if any
	if (el.bIsValid())
	{
		int bTypeCheck = true;	
		if (bTypeCheck)
		{ 
			ElementWallSF elX = (ElementWallSF)el;
			bIsSFWall= elX.bIsValid();
			bAddElementTool = bIsSFWall;
			bTypeCheck = !bIsSFWall;
		}
		if (bTypeCheck)
		{ 
			ElementLog elX = (ElementLog)el;
			bIsLogWall = elX.bIsValid();
			bTypeCheck = !bIsLogWall;
		}
		if (bTypeCheck)
		{ 
			ElementRoof elX = (ElementRoof)el;
			bIsFloor = elX.bIsValid();
			bAddElementTool = bIsFloor;
			bTypeCheck = !bIsFloor;
		}		
		if (!bIsSFWall)
		{ 
			ElementWall elX = (ElementWall)el;
			bIsSipWall = elX.bIsValid();
			bTypeCheck = !bIsSipWall;
		}
		bHasElement = true;
		genbeams = el.genBeam();
		
		assignToElementGroup(el, false, 0, 'E');
		vecX = el.vecX();
		vecY = el.vecY();
		vecZ = el.vecZ();
		ptOrg = el.ptOrg();//ptOrg.vis(2);
		LineSeg seg = el.segmentMinMax();	
		ptCen = seg.ptMid();
		dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));	
		
		if (dZ<=dEps) // strange enough some walls don't have a valid segmentMinMax
		{ 
			seg = PlaneProfile(el.plOutlineWall()).extentInDir(vecX);
			ptCen = seg.ptMid();
			dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
		}
		//seg.vis(6);
	}		
//End Identify wall type if any//endregion 

	else if (genbeams.length()>0) // HSB-14130
	{ 
		GenBeam gb = genbeams.first();
		ptCen = gb.ptCen();
		vecX = gb.vecX();
		vecY = gb.vecY();
		vecZ = gb.vecZ();
		dZ = gb.dD(vecZ);
		
	}
	if (vecFaceParent.bIsZeroLength())vecFaceParent = vecZ;
//endregion 
 
//region Properties, OnINsert and dialogMode

//region Properties

	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(1, sStrategies, sStrategyName);
	sStrategy.setDescription(T("|Defines the strategy how the conduit is interacting with an element|"));
	sStrategy.setCategory(category);
	//sStrategy.setReadOnly(sStrategies.length() < 1 ? _kHidden: false);
	int nStrategy = sStrategies.findNoCase(sStrategy ,- 1);
	if (nStrategy < 0)
	{
		sStrategy.set(kDefaultStrategy); setExecutionLoops(2);
	}

category = T("|Geometry|");
	String sDiameterName=T("|Diameter/Width|");	
	PropDouble dDiameter(nDoubleIndex++, U(30), sDiameterName,_kLength);	
	dDiameter.setDescription(T("|Defines the diameter of a tubular conduit or the the width of a rectangular conduit if depth > 0|"));
	dDiameter.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName,_kLength);	
	dDepth.setDescription(T("|Defines the Depth|") + T("|0 = round, >0 = rectangular|"));
	dDepth.setCategory(category);

	String sRadiusName=T("|Radius Contour|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName,_kLength);	
	dRadius.setDescription(T("|Defines the radius of polygonal conduits.|") +  T("|Not relevant for drilled conduits.|"));
	dRadius.setCategory(category);

category = T("|Edge Tool|");
	String sDiameterEdgeName=T("|Diameter/Width|");	
	PropDouble dDiameterEdge(nDoubleIndex++, U(30), sDiameterEdgeName,_kLength);	
	dDiameterEdge.setDescription(T("|Defines the diameter of an additional tool on the panel edge of a conduit.|"));
	dDiameterEdge.setCategory(category);
	
	String sHeightEdgeName=T("|Height|");	
	PropDouble dHeightEdge(nDoubleIndex++, U(0), sHeightEdgeName,_kLength);	
	dHeightEdge.setDescription(T("|Defines the height of a pocket tool on the edge.|") + T(", |0 = drill|"));
	dHeightEdge.setCategory(category);

	String sDepthEdgeName=T("|Depth|");	
	PropDouble dDepthEdge(nDoubleIndex++, U(0), sDepthEdgeName,_kLength);	
	dDepthEdge.setDescription(T("|Defines the Depth|") + T("|0 = round, >0 = rectangular|"));
	dDepthEdge.setCategory(category);
	
	String sRadiusToolName=T("|Radius|");	
	PropDouble dRadiusTool(nDoubleIndex++, U(0), sRadiusToolName,_kLength);	
	dRadiusTool.setDescription(T("|Defines the Radius|"));
	dRadiusTool.setCategory(category);	
		
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName,_kLength);	
	dOffset.setDescription(T("|Defines the offset in direction of the conduit from the center of the tool|"));
	dOffset.setCategory(category);
	
category = T("|Alignment|");
	String sFaceName=T("|Face|");
	String sFaces[] = { kByCombination, kReferenceSide, kOppositeSide};
	PropString sFace(0, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFaces.find(sFace)==2?-1:1;
	if (!vecFaceParent.bIsZeroLength() && sFace==kByCombination)
	{ 
		nFace = vecFaceParent.isCodirectionalTo(-vecZ) ?- 1 : 1;
	}
	
	String sAnchors[] = { tAnchorAny, tAnchorCell, tAnchorCombination};
	String sAnchorName=T("|Anchor|");	
	PropString sAnchor(2, sAnchors, sAnchorName);	
	sAnchor.setDescription(T("|Defines which anchors will be accesible|"));
	sAnchor.setCategory(category);
	int nAnchor = sAnchors.find(sAnchor); if (nAnchor < 0)sAnchor.set(tAnchorAny);
	
	
	String sZoneName=T("|Zone|");	
	int nZones[0];
	if (_Element.length()>0)
	{ 
		Element el = _Element[0];
		for (int i=-5;i<6;i++) 
			if (i==0 || el.zone(i).dH()>dEps)
				nZones.append(i); 
	}
	else
	{ 
		nZones.append(0);
	}
	PropInt nZone(nIntIndex++, nZones, sZoneName, nZones.find(0));	
	nZone.setDescription(T("|Defines the reference zone of the conduit|") +  T(" |This property is only relevant when working with elements and multiple zones.|"));
	nZone.setCategory(category);
	if (abs(nZone)>0)
	{ 
		int sgn1 = abs(nFace) / nFace;
		int sgn2 = abs(nZone) / nZone;
		if (sgn1!=sgn2)
		{ 
			sFace.set(sgn2<0?kOppositeSide:kReferenceSide);
			nFace *= -1;			
		}
		sFace.setReadOnly(true);
	}
	nZone.setReadOnly(_Element.length() > 0 || bDebug? false: _kHidden);
	
	

	String sOffsetZName=T("|Z-Axis-Offset|");	
	PropDouble dOffsetZ(nDoubleIndex++, U(0), sOffsetZName,_kLength);	
	dOffsetZ.setDescription(T("|Defines the Z-offset from the center for tubular conduits|"));
	dOffsetZ.setCategory(category);	


	String sOffsetXAName=T("|Lateral Offset Start|");	
	PropDouble dOffsetXA(nDoubleIndex++, U(0), sOffsetXAName,_kLength);	
	dOffsetXA.setDescription(T("|Defines the lateral offset from center at the starting point of the conduit|"));
	dOffsetXA.setCategory(category);	
	
	String sOffsetXBName=T("|Lateral Offset End|");	
	PropDouble dOffsetXB(nDoubleIndex++, U(0), sOffsetXBName,_kLength);	
	dOffsetXB.setDescription(T("|Defines the lateral offset from center at the end point of the conduit|"));
	dOffsetXB.setCategory(category);	

category = T("|Element Tools|");
	String sToolIndexName=T("|Tool Index|");	
	PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);	
	nToolIndex.setDescription(T("|Defines the Tool Index|") + T(", |-1 = no element tools|"));
	nToolIndex.setCategory(category);
	if (bHasElement && abs(nZone)>0 && (!bAddElementTool))	nToolIndex.setReadOnly(_kHidden);
	
	int bHasDepth = dDepth > 0;
	double dZConduit =bHasDepth?dDepth: dDiameter;
	
	
//End Properties//endregion 

//region Read Settings

	int bSplitSegment;
	double dSplitSegmentGap, dCombiGap;
	int ntPlan = 80;
	int ntElement = 80;
	double dTextHeight = U(60);
	String sDimStyle;
	String sTagMode = kDisabled;
	String sFormat = "@(ScaleX:RL0)";
	
	//region Hardware
	String sHWArticleNumber = _ThisInst.posnum(),sHWName, sHWDescription, sHWManufacturer,sHWModel,sHWMaterial,sHWCategory = T("|Conduit|");
	double dScaleY = dDiameter;
	double dScaleZ = dZConduit;
	sHWModel = dScaleY + " x " + dScaleZ;
	Map mapHardWares;
		
	//endregion 

	Map mapStrategy;
	Map mapProfile; // the map containing a potential profile definition of a strategy
	PlaneProfile ppProfile;
	

{	
// Strategy	
	String k;
	
	String strategy = sStrategy;
	for (int i=0;i<mapStrategies.length();i++) 
	{ 
		Map m = mapStrategies.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && strategy.makeLower() == name.makeLower())
			mapStrategy = mapStrategies.getMap(i);	 
	}//next i

	
	
	Map m = mapSetting.getMap("PlanView");
	k=kTransparency;		if (m.hasInt(k))		ntPlan = m.getInt(k);
	
	m = mapSetting.getMap(kElementView);
	k=kTransparency;		if (m.hasInt(k))		ntElement = m.getInt(k);


	m = mapStrategy;
	k=kSplitSegmentGap;		if (m.hasDouble(k))		dSplitSegmentGap= m.getDouble(k);
	k=kCombiGap;			if (m.hasDouble(k))		dCombiGap= m.getDouble(k);
	k=kSplitSegment;		if (m.hasInt(k))		bSplitSegment = m.getInt(k);
	k=kProfile;				if (m.hasMap(k))		mapProfile = m.getMap(k);
	k=kProfile;				if (mapProfile.hasPlaneProfile(k))	ppProfile = mapProfile.getPlaneProfile(k);	
	
	//Element View
	k=kElementView;			if (mapStrategy.hasMap(k))	m = mapStrategy.getMap(k);
	k=kTransparency;		if (m.hasInt(k))			ntElement = m.getInt(k);
	k=kDimStyle;			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k),-1)>-1)	sDimStyle = m.getString(k);
	k=kTextHeight;			if (m.hasDouble(k))			dTextHeight = m.getDouble(k);
	k=kFormat;				if (m.hasString(k))			sFormat = m.getString(k);
	
	k = kTagMode;			if (m.hasInt(k)) { int n = m.getInt(k);sTagMode = n >- 1 && n < sTagModes.length() ? sTagModes[n] : kDisabled;}

	// PlanView
	k="PlanView";			if (mapStrategy.hasMap(k))	m = mapStrategy.getMap(k);
	k=kTransparency;		if (m.hasInt(k))	ntPlan = m.getInt(k);	
	
	// Hardware
	k="HardWare[]";			if (mapStrategy.hasMap(k))	mapHardWares = mapStrategy.getMap(k);
}	
	
//endregion 

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
		else{showDialog();}	
		
		nAnchor = sAnchors.find(sAnchor);
		
		
	//region Get Combination		
		Entity ents[0];
		PrEntity ssE(T("|Select combination or other parent entity (Element or Panel)|"), TslInst());
		ssE.addAllowedClass(Sip());
		ssE.addAllowedClass(ElementRoof());
		ssE.addAllowedClass(ElementWall());
	  	if (ssE.go())
			ents.append(ssE.set());
			
		TslInst tslCombi;
		Element el;
		Vector3d vecY, vecZ;
		Point3d ptRef;
		PlaneProfile ppShapeCombi;
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst t=(TslInst)ents[i];
			if (!t.bIsValid()){ continue;}

			String script = t.scriptName();
			if (script.find(kInstaCombination,0, false)==0 && script.length()==kInstaCombination.length())
			{ 
				tslCombi = t;
				break;
			}
		}			

		// HSB-12825
		if (!tslCombi.bIsValid())
		{
		// collect first element of sset
			for (int i=0;i<ents.length();i++) 
			{ 
				Element e=(Element)ents[i];
				if (e.bIsValid())
				{ 
					el = e;
					break;	
				}
			}	

		// collect first element found	of genbeams in sset		
			for (int i=0;i<ents.length();i++) 
			{ 
				GenBeam g=(GenBeam)ents[i];
				 if (!g.bIsValid())continue;
				 
			// collect only genbeams belonging to the same element	
				if (!el.bIsValid())
				{ 
					Element e = g.element();
					if (e.bIsValid())
						el = e;
				}
				_GenBeam.append(g);
			}						
		}
		
		if (tslCombi.bIsValid())
		{ 
			el = tslCombi.element();
			_GenBeam.append(tslCombi.genBeam());
			vecZ = tslCombi.map().getVector3d("vecFace");//el.bIsValid()?el.vecZ(): tslCombi.coordSys().vecZ();	
			vecY = el.vecY();
		}
		else if (el.bIsValid())
		{ 
			vecZ = el.vecZ() * nFace;
			vecY = el.vecY();
			ptRef = el.ptOrg();
		}
		else if (_GenBeam.length()>0)
		{ 
			GenBeam g = _GenBeam[0];
			vecZ = g.vecZ() * nFace;
			vecY = g.vecY();
			ptRef = g.ptCen()+vecZ*.5*g.dH();
		}
		else
		{
			reportMessage(TN("|Could not find a combination or parent entity|"));
			eraseInstance();	
		}		
	//End Get Combination//endregion 

	//region Log Wall Specifics
		Point3d ptLogCourses[0]; 
		ElementLog elLog = (ElementLog)el;
		int bIsLogWall;
		if (elLog.bIsValid())
		{ 
			bIsLogWall = true;			
			for (int i=0;i<elLog.logCourses().length();i++) 
			{ 
				double d = elLog.dHeightFromCourseNr(i);
				Point3d pt = el.ptOrg() + vecY * d;
					ptLogCourses.append(pt);
			}//next i
			
			Beam logs[] = vecY.filterBeamsPerpendicularSort(elLog.beam());
			if (logs.length()>0)
				ptLogCourses.append(logs.last().ptCenSolid()+vecY*.5*elLog.dVisibleHeight());//logs.last().dD(vecY));				
			else if (ptLogCourses.length()>0)
				ptLogCourses.append(ptLogCourses.last()+vecY*elLog.dVisibleHeight());
		}
	//End Log Wall Specifics//endregion 

		Map mapArgs, mapNodes,mapCombinationNodes;
		Point3d ptGrips[0], ptLast;
		int nGoJig = -1;
		double a = dDiameter;

	//region Attach to main node or combination
		if (tslCombi.bIsValid())
		{ 
			Map mapCombi = tslCombi.map();
			ppShapeCombi = mapCombi.getPlaneProfile("Shape");
			
			Map mapXCombi = tslCombi.subMapX(kInstaCombination);
			mapCombinationNodes.appendMap("entry",mapXCombi);
			
			ptRef = tslCombi.ptOrg();
			
			if (nAnchor!=2) // not anchored to combination
				mapNodes = mapCombi.getMap("Node[]");
			else
				mapCombi.removeAt("Node[]", true);
			double dWidth = mapCombi.getDouble("Width"); // expresses the max cell diameter
			_Map.setDouble("Width", dWidth);
			a = dWidth *.5;
	
 			double a1 = a * .5 / tan(30);
	    	double b = a / tan(40);	
			
		    mapArgs = mapCombi;
		    mapArgs.setDouble("Depth", dDepth);
		    if (nAnchor!=1) // not anchored to cells
				mapArgs.setMap("CombinationNode[]",mapCombinationNodes);
	
	
			int bSuccess; // indicates if the snapping was successful
		    PrPoint ssP(T("|Select node|")); // second argument will set _PtBase in map	
		    ssP.setSnapMode(true, 0);
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kSelectNode, mapArgs);     
		        if (nGoJig == _kOk)
		        {
		        	ptLast = ssP.value(); //retrieve the selected point
	 				ptLast += vecZ * vecZ.dotProduct(ptRef - ptLast);
	 				ssP.setSnapMode(false, 0);
	 				
		        // snap to node
					for (int i=0;i<mapNodes.length();i++) 
					{ 
					// get node map		
						Map m= mapNodes.getMap(i);
						Point3d pt = m.getPoint3d("pt");
						Vector3d vecN= m.getVector3d("vecNormal");
						Vector3d vecP = vecN.crossProduct(-vecZ);
					
					// triangle to display and overlaying larger snap contour
						PLine pl(pt+vecP*a*.5,pt-vecP*a*.5,pt+vecN * a1);
						pl.close();	
			
						PlaneProfile ppSnap;
						ppSnap.createRectangle(LineSeg(pt-vecP*a, pt+vecP*a+vecN*2*a), vecN, vecP);			
						{
							PLine pl(pt - vecN * (a/ tan(45)),pt + vecP * a,pt - vecP * a);
							ppSnap.joinRing(pl, _kAdd);
						}			//{ PLine rings[] = ppSnap.allRings();	for (int r=0;r<rings.length();r++) 	{ EntPLine epl;epl.dbCreate(rings[r]);	epl.setColor(r);}}
		
		
					// triangle	
	//					PLine pl(pt+vecP*a,pt-vecP*a,pt+vecN * (a/tan(30)));	pl.close();
	//					PlaneProfile pp(pl);	pp.shrink(-a*3);				pp.transformBy(vecN * a*2);
						
					// snap to node if point in triangle
						if (ppSnap.pointInProfile(ptLast)!=_kPointOutsideProfile)
						{
							Entity cell = m.getEntity("cell");
							_Entity.append(cell); // add the cell to entity when snapped to
							_Map.setInt("nodeIndexA", m.getInt("nodeIndex"));
							_Map.setVector3d("vecN1", vecN);	
							_Map.setEntity("cell1", cell);
							mapArgs.setVector3d("vecN1", vecN);
	
							ptLast = pt;
							bSuccess = true;
							break;
						}
					}//next i 
					
				// snap to combination	
					if (!bSuccess && nAnchor!=1)
					{ 
						if (bLogger)reportNotice("\n  snap to combination...");
						Map m = mapXCombi.getMap(kSnaps);
						PlaneProfile pp;
						for (int j = 0; j < m.length(); j++)
						{
							if (m.hasPlaneProfile(j))
							{
								pp = m.getPlaneProfile(j);
								if (j == 0 && pp.pointInProfile(ptLast) != _kPointOutsideProfile) bSuccess = true;
								else if (pp.pointInProfile(ptLast) == _kPointInProfile)	bSuccess = true;								
							}
							
							if (bSuccess)
							{
								Vector3d vecN = pp.coordSys().vecX();
								Point3d pt = pp.ptMid() + vecN * .5 * pp.dX();

								// append combination and new connection vector
								_Entity.append(tslCombi);
								_Map.setVector3d("vecN1", vecN);
								_Map.setEntity("ent1", tslCombi);
								ptLast = pt;
								if (bLogger)reportNotice("\n  " + tslCombi.scriptName() + " " + tslCombi.handle() + "snapped  at " +j + " in dir " + vecN);
								break;
							}					
						}
					}
					
					ptGrips.append(ptLast);
					mapArgs.setPoint3dArray("grips", ptGrips);
					_PtG.append(ptLast);
		        }
	//	        else if (nGoJig == _kKeyWord)        { ; }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }				
		}
		
	//endregion 	

	//region Append as Standalone
		else
		{ 
			ptLast = getPoint();
			_PtG.append(ptLast);
			mapArgs.setDouble("Depth", dDepth);
			ptGrips.append(ptLast);
			mapArgs.setPoint3dArray("grips", ptGrips);
			
			mapArgs.setPoint3d("_PtBase", ptRef);
			mapArgs.setVector3d("vecX", vecY.crossProduct(vecZ));
			mapArgs.setVector3d("vecY", vecY);
			mapArgs.setVector3d("vecZ", vecZ);
			mapArgs.setDouble("Depth", dDepth); 
			
			PlaneProfile pp(CoordSys(ptRef, vecY.crossProduct(vecZ) , vecY, vecZ));
			if (_GenBeam.length()<1)
				pp.joinRing(el.plEnvelope(), _kAdd);
			else
			{ 
				for (int i=0;i<_GenBeam.length();i++) 
					pp.unionWith(_GenBeam[i].envelopeBody(false, true).shadowProfile(Plane(ptRef, vecZ)));	 
			}
			mapArgs.setPlaneProfile("Contour",pp);
		}
	//endregion 

	//region Collect other combinations
		Entity tents[0];
		if (el.bIsValid())
		{ 
			_Element.append(el);
			TslInst tsls[]=el.tslInstAttached();
			for (int i=0;i<tsls.length();i++) 
				if (tents.find(tsls[i])<0)
					tents.append(tsls[i]);	
		}
		else
		{ 
			for (int i=0;i<_GenBeam.length();i++) 
			{ 
				Entity ents[]= _GenBeam[i].eToolsConnected();
				for (int j=0;j<ents.length();j++) 
					if (tents.find(ents[j])<0)
						tents.append(ents[j]);		 
			}//next i			
		}	

		mapCombinationNodes=Map();
		mapNodes = Map();
		for (int i=0;i<tents.length();i++) 
		{ 
			TslInst t= (TslInst)tents[i];
			if (t.bIsValid() && t.scriptName().makeLower()=="instacombination" && t!=tslCombi)
			{ 	
				Map m = t.subMapX(kInstaCombination);
				if (nAnchor!=1)
					mapCombinationNodes.appendMap("entry", m);
				
				if (nAnchor!=2)
				{ 
					m = t.map().getMap("Node[]");
					for (int j=0;j<m.length();j++) 
						mapNodes.appendMap("Node", m.getMap(j)); 					
				}

			}
		}//next i
	
	//End Collect other combinations//endregion 

	//region Attach to second node/combination or add as free path
		mapArgs.setMap("Node[]", mapNodes);
		mapArgs.setMap("CombinationNode[]", mapCombinationNodes);
		mapArgs.setPoint3dArray("ptCourse[]", ptLogCourses);
		mapArgs.setDouble("radius", dDiameter * .5); //not specifyiing the radius while prompting the first grip suppresses the routing jig to be drawn
	 
	    nGoJig = -1;
	    PrPoint ssP(T("|Select second node or direction|"),ptLast);
	    ssP.setSnapMode(TRUE, 0);
	    while (nGoJig != _kNone)//nGoJig != _kOk && 
	    { 
	    	nGoJig = ssP.goJig(kSelectNode, mapArgs);
	    	
	        if (nGoJig == _kOk)
	        {
	        	ptLast = ssP.value();
				ptLast += vecZ * vecZ.dotProduct(ptRef - ptLast);
				ssP.setSnapMode(false, 0);
				
	        // snap to node
	        	int bSuccess;
				for (int i=0;i<mapNodes.length();i++) 
				{ 
					Map m= mapNodes.getMap(i);
					Point3d pt = m.getPoint3d("pt");
					Vector3d vecN= m.getVector3d("vecNormal");
					Vector3d vecP = vecN.crossProduct(-vecZ);
			
					PlaneProfile ppSnap;
					ppSnap.createRectangle(LineSeg(pt-vecP*a, pt+vecP*a+vecN*2*a), vecN, vecP);			
					{
						PLine pl(pt - vecN * (a/ tan(45)),pt + vecP * a,pt - vecP * a);
						ppSnap.joinRing(pl, _kAdd);
					}			//dp2.draw(pp);

				// snap to node if point in triangle
					if (ppSnap.pointInProfile(ptLast)!=_kPointOutsideProfile)
					{
						Entity cell = m.getEntity("cell");
						_Entity.append(cell);
						_Map.setInt("nodeIndexB", m.getInt("nodeIndex"));
						_Map.setVector3d("vecN2", vecN);
						_Map.setEntity("cell2", cell);
						bSuccess = true;
						ptLast = pt;
						break;
					}
				}//next i 
				
			//region Snap to any combination within the scope of the element or genbeam set
				for (int i=0;i<mapCombinationNodes.length();i++) 
				{ 
					Map m= mapCombinationNodes.getMap(i);
					Entity ent = m.getEntity("ent");
					m = m.getMap(kSnaps);

					PlaneProfile pp;
					for (int j = 0; j < m.length(); j++)
					{
						if (m.hasPlaneProfile(j))
						{
							pp = m.getPlaneProfile(j);							
							if (j == 0 && pp.pointInProfile(ptLast) != _kPointOutsideProfile)bSuccess = true;
							else if (pp.pointInProfile(ptLast) == _kPointInProfile)bSuccess = true;
								
							if (bSuccess)
							{
								Vector3d vecN = pp.coordSys().vecX();
								_Map.setVector3d("vecN2", vecN);
								_Map.setEntity("ent2", ent);
								ptLast = pp.ptMid() + vecN * .5 * pp.dX();
								if (bLogger)reportNotice("\n  " + ent.typeDxfName() + " " + ent.handle() + "snapped  at " +j + " in dir " + vecN);
								break;
							}
						}
					}	
				}
				//endregion
				
			// snap to log grid if logwall
				if (bIsLogWall)
				{ 
					double dist = U(10e5);
					Point3d ptG = ptLast;
					for (int j=0;j<ptLogCourses.length();j++) 
					{ 
						Point3d ptCourse = ptLogCourses[j]; 
						double d = abs(vecY.dotProduct(ptCourse-ptLast));
						if (d<dist)
						{ 
							dist = d;
							ptG = ptCourse;
					
						}
					}//next j	
					if (abs(vecY.dotProduct(ptG-ptLast))>dEps)
						ptLast += vecY * vecY.dotProduct(ptG - ptLast);
				}
				
				ptGrips.append(ptLast);
				mapArgs.setPoint3dArray("grips", ptGrips);
				_PtG.append(ptLast); //retrieve the selected point
			// selected point did not snap to a cell/combination	
				if (!bSuccess)
				{
					mapArgs.setInt("ConnectionType", 5); // the second grip has not been snapped to a cell -> free path
					ssP = PrPoint(T("|Select next node|"),ptLast);
				}
				else
					break;
	        }
//	        else if (nGoJig == _kKeyWord)        { ; }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }	    		    	
	    }
	    
	// set as free path with more then 2 grips
		if (_PtG.length()>2)
		{ 
			
			_Map.setInt("ConnectionType", 5);
			Point3d pts[0];pts = _PtG;
			for (int i=2;i<pts.length();i++) 
				_PtG[i]=pts[i-1]; 

			_PtG[1] = pts.last();
			
//			for (int i=1;i<_PtG.length()-1;i++) // second grip is last in route	
//			{ 
//				_PtG.swap(i, i + 1);
//				 
//			}//next i
			_Pt0 = (_PtG[0] + _PtG[2]);
		}
		else 
		{ 
			_Pt0.setToAverage(_PtG);
		}    
	//End Attach to second node//endregion 	

		return;
	}	
// end on insert	__________________//endregion

//region DialogMode // TODO allow call byCell to insert a conduit on the selected cell
	if (nDialogMode > 0)
	{
	
		return;
	}
//End DialogMode//endregion 
	
//End Properties, OnINsert and dialogMode//endregion 
		
//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger AddEditStrategy
	String sStrategyTriggers[] = { T("|Add Strategy|"), T("|Edit Strategy|")};
	addRecalcTrigger(_kContext, sStrategyTriggers[0] );
	addRecalcTrigger(_kContext, sStrategyTriggers[1]  );	
	int nStrategyTrigger = sStrategyTriggers.findNoCase(_kExecuteKey ,- 1);
	if (_bOnRecalc && nStrategyTrigger>-1)	
	{ 
		mapTsl.setInt("DialogMode",nStrategyTrigger+2);
		mapTsl.setString("opmKey","AddEditStrategy");
		
		Map m;
		for (int i=0;i<sStrategies.length();i++) 
		{
			if (sStrategies[i] == kDefaultStrategy)continue;
			m.appendString(kStrategy,sStrategies[i]); 	
		}
		mapTsl.setMap("Strategy[]",m);

		String name = nStrategyTrigger == 0 ? T("|New Strategy|") : sStrategy;
		sProps.append(name);
		
		if (ppProfile.area()>pow(dEps,2))
		{
			mapTsl.setPlaneProfile(kProfile, ppProfile);
			sProps.append(kCurrentProfile);
		}
		else
			sProps.append(kDisabled);
		sProps.append(bSplitSegment?sNoYes[1]:sNoYes[0]);				
		sProps.append(sTagMode);
		sProps.append(sFormat);
		sProps.append(sDimStyle.length()>0 && _DimStyles.findNoCase(sDimStyle,-1)>-1?sDimStyle:_DimStyles.first());		
		
		nProps.append(ntPlan);
		nProps.append(ntElement);

		dProps.append(dSplitSegmentGap);
		dProps.append(dCombiGap);
		dProps.append(dTextHeight);

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				name = tslDialog.propString(0);
				if (nStrategyTrigger==0)
				{
					if (name == kDefaultStrategy)
					{ 
						tslDialog.dbErase();
						reportNotice(TN("|Invalid name, please try again|"));
						setExecutionLoops(2);
						return;	
					}
					sStrategy.set(name);
				}

				bSplitSegment = sNoYes.find(tslDialog.propString(2), 0);
				dSplitSegmentGap= tslDialog.propDouble(0);
				dCombiGap= tslDialog.propDouble(1);
				sTagMode = tslDialog.propString(3);
				sFormat = tslDialog.propString(4);
				sDimStyle = tslDialog.propString(5);
				dTextHeight = tslDialog.propDouble(2);
	
				ntPlan = tslDialog.propInt(0);
				ntElement = tslDialog.propInt(1);
				
				
			//region Profile Shape
				String shape = tslDialog.propString(1);			
				if (shape == sSelectShape)
				{ 
					mapProfile = Map();
					
				// Get polylines
					Entity ents[0];
					PrEntity ssEpl(T("|Select polylines|"), Entity());
				  	if (ssEpl.go())
						ents.append(ssEpl.set());

					PLine plines[0];
					for (int i=0;i<ents.length();i++) 
					{ 
						PLine pl = ents[i].getPLine();
						if (pl.length()>dEps && pl.area()>pow(dEps,2))
							plines.append(pl);
					}
				// order descending
					for (int i=0;i<plines.length();i++) 
						for (int j=0;j<plines.length()-1;j++) 
							if (plines[j].area()<plines[j+1].area())
							{
								plines.swap(j, j + 1);
								ents.swap(j, j + 1);
							}
					
				// Set profile					
					CoordSys csP;
					if (plines.length()>0)
					{ 
						PLine pl = plines.first();
						if (pl.coordSys().vecZ().isParallelTo(_ZW))
							csP = CoordSys(_Pt0, _XW, _YW, _ZW);
						else
							csP = CoordSys(_Pt0, vecX, vecY, vecZ);
					}
					
					
					PlaneProfile pp(csP);
					for (int i=0;i<plines.length();i++) 
					{ 
						int bIsOpening = PlaneProfile(plines[i]).intersectWith(pp);
						plines[i].projectPointsToPlane(Plane(csP.ptOrg(), csP.vecZ()), csP.vecZ());
						pp.joinRing(plines[i],bIsOpening?_kSubtract:_kAdd);
						
						Map m;
						m.setPLine("pline", plines[i]);
						m.setInt("isOpening", bIsOpening);
						m.setInt("color", ents[i].color());
						mapProfile.appendMap("Ring", m);
						
					}//next i
					mapProfile.setPlaneProfile(kProfile, pp);
					ppProfile = pp;
				}
				else if (shape == kDisabled)
				{
					mapProfile = Map();
					ppProfile = PlaneProfile();
				}
			//endregion 	

			// rewrite		
				Map mapTemp, mapHardWares;
				for (int i=0;i<mapStrategies.length();i++) 
				{ 
					Map m = mapStrategies.getMap(i);
					String _name = m.getMapName();
					if (_name.find(name, 0,false)>-1 && name.length() == _name.length()) 
					{
						mapHardWares = m.getMap("Hardware[]");
						continue;
					}
					mapTemp.appendMap(kStrategy, m);				 
				}//next i
				mapStrategies = mapTemp;

				Map m;
				m.setDouble(kSplitSegmentGap, dSplitSegmentGap);
				m.setDouble(kCombiGap, dCombiGap);
				m.setInt(kSplitSegment, bSplitSegment);
				if (ppProfile.area()>pow(dEps,2))
					m.setMap(kProfile, mapProfile);
					
				Map mapView;
				mapView.setInt(kTransparency, ntPlan);
				m.setMap(kPlanView, mapView);
				
				mapView.setInt(kTransparency, ntElement);
				mapView.setString(kDimStyle, sDimStyle);
				mapView.setString(kFormat, sFormat);
				mapView.setInt(kTagMode, sTagModes.find(sTagMode));
				mapView.setDouble(kTextHeight, dTextHeight);			
				m.setMap(kElementView, mapView);
				
				m.setMap("HardWare[]", mapHardWares);
	
				m.setMapName(name);
				mapStrategies.appendMap(kStrategy, m);
				
			// write to settings and store in mo
				mapSetting.setMap("Strategy[]", mapStrategies);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	
	
	
	

//region Trigger SetHardware
	String sTriggerSetHardware = T("|Set Strategy Hardware|");
	addRecalcTrigger(_kContext, sTriggerSetHardware );
	if (_bOnRecalc && _kExecuteKey == sTriggerSetHardware )
	{
		HardWrComp hwcsCurrent[] = _ThisInst.hardWrComps();
		
	// remove any entry tagged to be a lump	
		for (int i=hwcsCurrent.length()-1; i>=0 ; i--) 
			if (hwcsCurrent[i].dAngleA()>0)
				hwcsCurrent.removeAt(i); 

	    HardWrComp hwcsNew[] = HardWrComp().showDialog(hwcsCurrent);
	    //_ThisInst.setHardWrComps(hwcs);	    
	    
	   // store hardware in map 
	    mapHardWares = Map();
	    for (int i=0;i<hwcsNew.length();i++) 
	    { 
	    	HardWrComp hwc = hwcsNew[i]; 
	    	
	    // misuse the z-offset to index the hardware components. 
	    // If the instance is set to split moe it will assign hardware by segment and therefor multiple compontents of the same type could be attached	
	    	int n = hwc.dAngleA();
	    	if (n > 1)continue;
	    	
	    	Map m;			
			m.setString("ArticleNumber", hwc.articleNumber());
			m.setString("Name", hwc.name());
			m.setString("Decription", hwc.description());
			m.setString("Manufacturer", hwc.manufacturer());
			m.setString("Model", hwc.model());
			m.setString("Material", hwc.material());
			m.setString("Category", hwc.category().length()>0?hwc.category():T("|Conduit|") );
			mapHardWares.appendMap("HardWare", m);	    	 
	    }//next i

	    
	// rewrite		
		Map mapTemp;
		for (int i=0;i<mapStrategies.length();i++) 
		{ 
			Map m = mapStrategies.getMap(i);
			String name = m.getMapName();
			if (name.find(sStrategy,0, false)>-1 && name.length()== sStrategy.length()) 
			{
				m.setMap("HardWare[]", mapHardWares);
				//reportMessage(TN("|Setting hardware of| ") + sStrategy);
			}
			mapTemp.appendMap(kStrategy, m);				 
		}//next i
		mapStrategies = mapTemp;
		
	// write to settings and store in mo
		mapSetting.setMap("Strategy[]", mapStrategies);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);	    
	}

	//endregion	
	
	
//region Trigger DeleteStrategy
	String sTriggerDeleteStrategy = T("|Delete Strategy|");
	addRecalcTrigger(_kContext, sTriggerDeleteStrategy );
	if (_bOnRecalc && _kExecuteKey==sTriggerDeleteStrategy)
	{ 
		mapTsl.setInt("DialogMode",4);
		mapTsl.setString("opmKey","DeleteStrategy");
		
		Map m;
		for (int i=0;i<sStrategies.length();i++) 
			m.appendString(kStrategy,sStrategies[i]); 	
		mapTsl.setMap("Strategy[]",m);

		String name =  sStrategy;
		sProps.append(name);
 
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				name = tslDialog.propString(0);
				
				int n = sStrategies.find(name);
				if (n>-1)
					sStrategies.removeAt(n);
				if (name == sStrategy && sStrategies.length()>0)
					sStrategy.set(sStrategies.first());
				
			// rewrite		
				Map mapTemp;
				for (int i=0;i<mapStrategies.length();i++) 
				{ 
					Map m = mapStrategies.getMap(i);
					if (m.getMapName().makeLower()!=name) 
						mapTemp.appendMap(kStrategy, m);				 
				}//next i
				mapStrategies = mapTemp;
				
			// write to settings and store in mo
				mapSetting.setMap("Strategy[]", mapStrategies);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	
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

//region #Part 4

	_ThisInst.setAllowGripAtPt0(false);
	
//region element properties
	Plane pnZ(ptOrg, vecZ);
	ElementLog elLog;
	ElemZone zone;
	double dZZone;
	
	if (bHasElement)
	{
		zone= el.zone(nZone);
		dZZone= zone.dH();
		
		assignToElementGroup(el, false, 0, 'E');
		LineSeg seg = el.segmentMinMax();	
		ptCen = seg.ptMid();
		dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));	
		
		if (dZ<=dEps) // strange enough some walls don't have a valid segmentMinMax
		{ 
			seg = PlaneProfile(el.plOutlineWall()).extentInDir(vecX);
			ptCen = seg.ptMid();
			dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
			if (dZZone==0)dZZone = dZ;
		}
	
		if (!bHasElement && _GenBeam.length()<1)
		{
			reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
			eraseInstance();
			return;
		}			
	}

	if (_PtG.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Requires at least one grip point.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;		
	}
//endregion 

//region Collect genbeam subtypes
	Point3d ptVerticalExtremes[0];
	Body bodies[0]; // cache the bodies
	PlaneProfile pps[0]; // cache the profiles
	for (int i=0;i<genbeams.length();i++) 
	{ 
		GenBeam gb = genbeams[i];
		Body bd = gb.envelopeBody(true, true);
		bodies.append(bd);
		pps.append(bd.shadowProfile(pnZ));
		Sip sip = (Sip)gb;
		Beam beam= (Beam)gb;
		Sheet sheet= (Sheet)gb;
		if (sip.bIsValid())sips.append(sip);
		else if (beam.bIsValid())beams.append(beam);
		else if (sheet.bIsValid())sheets.append(sheet);
		
		ptVerticalExtremes.append(bodies.last().extremeVertices(vecY));
	}//next i
	ptVerticalExtremes = Line(_Pt0, vecY).orderPoints(ptVerticalExtremes, dEps);
	
	
// GenBeam based, get coordSys and main ref if loose
	if (!bHasElement)
	{ 
		if (ptVerticalExtremes.length() > 0)ptOrg = ptVerticalExtremes.first();
		ptOrg.vis(2);
		
		if (sips.length()>0)
		{ 
			sip = sips.first();
			dZ = sip.dH();
			ptCen = sip.ptCen();
			Vector3d vecXS = sip.vecX();
			Vector3d vecYS = sip.vecY();
			vecZ = sip.vecZ();
			// flattened to XY-World
			if (vecZ.isParallelTo(_ZW) && (vecXS.isParallelTo(_XW) || vecYS.isParallelTo(_XW))) 
				vecX = _XW;	
			// 3D-Model as wall	
			else if (vecZ.isPerpendicularTo(_ZW)) 					
				vecX = _ZW.crossProduct(vecZ);
			vecY = vecX.crossProduct(-vecZ);			
		}
		
		assignToGroups(genbeams.first(), 'T');
		if (genbeams.length()==1)setEraseAndCopyWithBeams(_kBeam0);
	}
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);	

	
//End Collect genbeam subtypes//endregion 
	Vector3d vecFace = nFace * vecZ;	
	Point3d ptFace = ptCen + vecFace * .5 * dZ;vecFace.vis(ptFace,2);
	Point3d ptFaceZone = ptFace;
	if (bHasElement && !bIsLogWall)
	{ 
		ptFaceZone =zone.ptOrg()+vecFace*dZZone;
		if (nZone==0 && nFace==(bIsSipWall?1:-1))
			ptFaceZone -= vecFace * dZZone;			

		ptFaceZone.vis(6);
	}
	CoordSys cs (ptFaceZone, vecX, vecX.crossProduct(-vecFace), vecFace);
	
	//addRecalcTrigger(_kGripPointDrag, "_Pt0");
	for (int i=0;i<_PtG.length();i++) 
	{
		_PtG[i] += vecFace * vecFace.dotProduct(ptFace - _PtG[i]);
		addRecalcTrigger(_kGripPointDrag, "_PtG"+i);
	}	
	
//End  parent entity//endregion 

//region Get Contour
	PlaneProfile ppContour(cs);//CoordSys(ptFaceZone, vecX, vecY, vecZ));
	PlaneProfile ppSips[0];
	Point3d ptLogCourses[0]; 
	
// Sip based
	if (sips.length()>0)
	{ 
		for (int i=0;i<sips.length();i++) 
		{
			PLine pl = sips[i].plEnvelope();
			ppContour.joinRing(pl,_kAdd); 
			
			PlaneProfile pp(cs);
			pp.joinRing(pl, _kAdd);
			ppSips.append(pp);
		}
		ppContour.shrink(-dEps);
		ppContour.shrink(dEps);
		for (int i=0;i<sips.length();i++) 
		{
			PlaneProfile& ppSip = ppSips[i];
			PLine plOpenings[] = sips[i].plOpenings();
			for (int j=0;j<plOpenings.length();j++) 
			{
				PLine pl = plOpenings[j];
				ppContour.joinRing(pl, _kSubtract); 
				ppSip.joinRing(pl, _kSubtract); 
			}
		}
//reportMessage("\nget contour by sips area " + ppContour.area());//XXX		
	}
// Log Wall	
	else if (bIsLogWall)
	{ 
		
		for (int i=0;i<genbeams.length();i++) 
			ppContour.unionWith(pps[i]);	
		ppContour.shrink(-dEps);
		ppContour.shrink(dEps);	

		for (int i=0;i<elLog.logCourses().length();i++) 
		{ 
			double d = elLog.dHeightFromCourseNr(i);
			Point3d pt = ptOrg + vecY * d;
			if (d>0)
			{ 
				pt.vis(i);
				ptLogCourses.append(pt);
			}
		}//next i
		
		Beam logs[] = vecY.filterBeamsPerpendicularSort(elLog.beam());
		if (logs.length()>0)
			ptLogCourses.append(logs.last().ptCen()+vecY*logs.last().dD(vecY)*.5);				
		else if (ptLogCourses.length()>0)
			ptLogCourses.append(ptLogCourses.last()+vecY*elLog.dVisibleHeight());		
		
//reportMessage("\nget contour by log area " + ppContour.area());//XXX		
	}
	else if (bHasElement)
	{ 
		if (abs(nZone)>0)
		{ 
			for (int i=0;i<genbeams.length();i++) 
			{ 
				GenBeam gb = genbeams[i]; 
				if (gb.myZoneIndex() != nZone)continue;
				
				
				PlaneProfile pp = pps[i];
				pp.shrink(-dEps);
				if (ppContour.area()<pow(dEps,2))
					ppContour = pp;
				else	
					ppContour.unionWith(pp);
				
			}//next i
			ppContour.shrink(dEps);	
		}
		
		if (ppContour.area()<pow(dEps,2))
			ppContour.joinRing(el.plEnvelope(), _kAdd); 
//reportMessage("\nget contour by element area " + ppContour.area());//XXX		
	}
	ppContour.vis(2);
	
	
	_Map.setVector3d("vecX", vecX);
	_Map.setVector3d("vecY", vecY);
	_Map.setVector3d("vecZ", vecZ);
	_Map.setDouble("offsetXA", dOffsetXA);
	_Map.setDouble("face", nFace);
	_Map.setDouble("radius", dDiameter*.5);
	_Map.setPlaneProfile("Contour", ppContour);	
//End Get Contour//endregion 

//region Get refs
	Point3d ptFrom=_PtG[0], ptTo=_PtG.length()>1?_PtG[1]:_PtG[0];
	int nIndexA = _Map.getInt("nodeIndexA");
	int nIndexB = _Map.getInt("nodeIndexB");
	Vector3d vecA, vecB;
	TslInst cellA, cellB, combis[0];
	PlaneProfile shapes[0],ppCombiShapes[0];
	for (int i=0;i<cells.length();i++) 
	{ 
		Map mapX = cells[i].subMapX(kInstaCombination);
		
	// collect combination	
		Entity ent = mapX.getEntity("ent");
		TslInst combi= (TslInst)ent;
		if (combi.bIsValid() && combis.find(combi)<0)
		{
			combis.append(combi);
			ppCombiShapes.append(combi.map().getPlaneProfile("Shape"));
		}		
	
	// Collect nodes
		Map mapNodes = mapX.getMap("Node[]");//reportMessage("\n" + _ThisInst.handle() + " mapNodes: " + mapNodes.length());//XXX
		PlaneProfile pp = cells[i].map().getPlaneProfile("Shape");
		shapes.append(pp);
		
		Point3d pts[0];
		for (int j=0;j<mapNodes.length();j++) 
		{ 
			Map m= mapNodes.getMap(j); 
			Point3d pt = m.getPoint3d("pt");			//pt.vis(i);
			int nodeIndex= m.getInt("nodeIndex");
			Vector3d vecNormal = m.getVector3d("vecNormal");
			Entity ent = m.getEntity("cell");
			//vecNormal.vis(pt, j);
			
			Point3d pts[] = Line(pt, vecNormal).orderPoints(pp.intersectPoints(Plane(pt, vecNormal.crossProduct(vecZ)), true, false));
			
		// snap grip to cell location	
			if (i==0 && nodeIndex == nIndexA)
			{ 
				_PtG[0] = pt;
				cellA = (TslInst)ent;
				
				if (pts.length() > 0)pt.setToAverage(pts);
				ptFrom = pt;//vecNormal.vis(ptFrom,j);
				vecA = vecNormal;
				_Map.setVector3d("vecAPrev", vecA);
				break;
			}
			else if (i>0 &&  nodeIndex == nIndexB)
			{ 
				if (_PtG.length() > 1)_PtG[1] = pt;
				cellB = (TslInst)ent;	
				
				if (pts.length() > 0)pt.setToAverage(pts);
				ptTo = pt;
				ptTo.vis(2);
				vecB = vecNormal;
				
				break;
			}	
		}//next j
	}//next i

//region Get Reference to combination if set
	// the reference to a combination with the assignment of vecA  or vecB sets the alignmnet to the center of the combinations boundaries
	if (cells.length()<2)
	{ 
		for (int i=0;i<combinations.length();i++) 	
		{ 
			Map mapCombi= combinations[i].map(); 
			PlaneProfile pp = mapCombi.getPlaneProfile("Shape");
			LineSeg seg = pp.extentInDir(vecX);
			Vector3d vecN1 = _Map.getVector3d("vecN1");
			Vector3d vecN2 = _Map.getVector3d("vecN2");
			if (vecA.bIsZeroLength() && !vecN1.bIsZeroLength())
			{ 
				vecA = vecN1;				
				combis.append(combinations[i]);
				double dN = abs(vecA.dotProduct(seg.ptEnd() - seg.ptStart()));
				ptFrom = pp.ptMid()+vecA*.5*dN;
				
				if (nGripEvent < 0 && _PtG.length()>0)_PtG[0] = ptFrom;
				
			}		
			else if (vecB.bIsZeroLength() && !vecN2.bIsZeroLength())
			{ 
				vecB = vecN2;				
				combis.append(combinations[i]);
				double dN = abs(vecB.dotProduct(seg.ptEnd() - seg.ptStart()));
				ptTo = pp.ptMid()+vecB*.5*dN;
				if (nGripEvent < 0 && _PtG.length()>1)_PtG[1] = ptTo;
			}	
		}
	}
	
	
//endregion 

// set vecA during creation, needed for correct preview during rule based conduit creation
	if (vecA.bIsZeroLength() && _Map.hasVector3d("vecN1") && nIndexA>0 && nIndexB<1)
	{ 
		vecA = _Map.getVector3d("vecN1");
	}

	if (!vecA.bIsZeroLength())
	{ 
		Vector3d vecAY = (vecA.isParallelTo(vecY)?vecX:vecY);
		ptFrom += vecAY * dOffsetXA;
		vecA.vis(ptFrom, 3);
	}
	else if (_Map.hasVector3d("vecAPrev") && cells.length()<1) // get previous alignment if cells have been deleted
	{ 
		vecA = _Map.getVector3d("vecAPrev");
	}
	else if (vecA.bIsZeroLength())
	{ 
		reportMessage(TN("|Unexpected error identifying direction of the conduit.|") + T(" |Tool will be deleted|"));
		eraseInstance();
		return;
	}
	
	if (!vecB.bIsZeroLength())
	{ 
		Vector3d vecBY = (vecB.isParallelTo(vecY)?vecX:vecY);
		ptTo += vecBY * dOffsetXB;
		//vecB.vis(ptFrom, 3);
	}	
	int bIsVerticalConnection = vecA.isParallelTo(vecY) && (vecB.bIsZeroLength() || 
		vecB.isParallelTo(vecY)) ||
		(_PtG.length()==2 && (ptFrom-ptTo).isParallelTo(vecY)); // HSB-14161
	
//End Combination//endregion 

//End #Part 4//endregion 

//region Part #5 Routing, Tooling and Hardware

//region Routing
	PLine plRoute(vecZ);
	plRoute.addVertex(ptFrom);

//region Connecting to cells or combinations
	int nConnectionType = _Map.getInt("ConnectionType");
	int bHasA = !vecA.bIsZeroLength(), bHasB=!vecB.bIsZeroLength();
	
	//reportNotice("\nconnection type " + nConnectionType + " cells " + cells.length());	
	if (nConnectionType == 5 && _PtG.length()>1)
	{ 
		Point3d pt;
		for (int i=0;i<_PtG.length();i++) 
		{ 
			if (i == 1)continue;
			
		// for log walls snap to closest log couse
			if (bIsLogWall && i!=0 && bIsVerticalConnection)
			{ 
				double dist = U(10e5);
				Point3d ptG = _PtG[i];
				for (int j=0;j<ptLogCourses.length();j++) 
				{ 
					Point3d ptCourse = ptLogCourses[j]; 
					double d = abs(vecY.dotProduct(ptCourse-_PtG[i]));
					if (d<dist)
					{ 
						dist = d;
						ptG = ptCourse;
					}
				}//next j
				
				if (abs(vecY.dotProduct(_PtG[i]-ptG))>dEps)
					_PtG[i] += vecY * vecY.dotProduct(ptG - _PtG[i]);

			}
			pt = _PtG[i] + vecZ * vecZ.dotProduct(ptFrom - _PtG[i]);
			
		// offset first point if lateral offset is specified
			if (i==0 && !bIsVerticalConnection)
				pt += vecY * vecY.dotProduct(ptFrom-pt);
			else if (i==0 && bIsVerticalConnection)
				pt += vecX * vecX.dotProduct(ptFrom-pt);			
			
			ptFrom.vis(3);
			plRoute.addVertex(pt);pt.vis(i); 
		}//next i

	// offset last point if lateral offset is specified
		pt = _PtG[1];
		if (bIsVerticalConnection)
			pt += vecX * vecX.dotProduct(ptTo-pt);
		else 
			pt += vecY * vecY.dotProduct(ptTo-pt);
		
		plRoute.addVertex(pt); _PtG[1].vis(1);
	}
	else if (bHasA && bHasB)//cells.length()==2)
	{ 
		
	// properties of edge tool are disabled
		dDiameterEdge.setReadOnly(_kHidden);
		dDepthEdge.setReadOnly(_kHidden);
		dHeightEdge.setReadOnly(_kHidden);
		dOffset.setReadOnly(_kHidden);
		dRadiusTool.setReadOnly(_kHidden);

		Vector3d vecYA = vecA.crossProduct(-vecZ);
		Vector3d vecYB = vecB.crossProduct(-vecZ); //vecB.vis(ptTo, 4);
		if (_PtG.length() < 2) _PtG.append(ptTo);

	// straight
		if (abs(vecYA.dotProduct(ptFrom-ptTo))<dEps)
		{ 
			if (_PtG.length() > 2)_PtG.setLength(2);
			nConnectionType = 1;
			//PLine (ptFrom, ptTo).vis(1);
		}
		
	// double angled
		else if (vecA.isParallelTo(vecB))
		{ 
			if (_PtG.length()<3)
				_PtG.append((ptFrom + ptTo) / 2);	


		// for log walls snap to closest log couse
			if (bIsLogWall)
			{ 
				double dist = U(10e5);
				Point3d ptG = _PtG[2];
				for (int j=0;j<ptLogCourses.length();j++) 
				{ 
					Point3d ptCourse = ptLogCourses[j]; 
					double d = abs(vecY.dotProduct(ptCourse-_PtG[2]));
					if (d<dist)
					{ 
						dist = d;
						ptG = ptCourse;
					}
				}//next j
				if (abs(vecY.dotProduct(_PtG[2]-ptG))>dEps)
					_PtG[2] += vecY * vecY.dotProduct(ptG - _PtG[2]);
			}

			Plane pn(_PtG[2], vecA);
			Point3d pt;
			PLine pl;
			if (Line(ptFrom, vecA).hasIntersection(pn,pt))
			{
				plRoute.addVertex(pt);
				pl.addVertex(pt);
			}
			if (Line(ptTo, vecB).hasIntersection(pn,pt))
			{
				plRoute.addVertex(pt);
				pl.addVertex(pt);
			}
		// relocate grip to mid of segment
			if (pl.length() > dEps)_PtG[2] = pl.ptMid();
			nConnectionType = vecA.isParallelTo(vecX)?6:2;
		}
		
	// simple angled
		else
		{ 
			if (_PtG.length() > 2)_PtG.setLength(2);
			Plane pn(ptTo, vecB);
			Point3d pt;
			if (Line(ptFrom, vecA).hasIntersection(pn,pt))
				plRoute.addVertex(pt);
			else if (Line(ptFrom, vecA).hasIntersection(Plane(ptTo,vecYB),pt))
				plRoute.addVertex(pt);
			nConnectionType = 3;
		}
		
	}	
	
	
	if (_PtG.length()<2 && !bHasB)//nIndexB<1)
	{ 
		Vector3d vecYA = vecA.crossProduct(-vecZ); vecA.vis(ptFrom, 2);
		Line ln(ptFrom ,- vecA);
		Point3d pts[] = ln.orderPoints(ppContour.intersectPoints(Plane(ptFrom, vecYA), true, true), dEps);

		//reportMessage("\npoints " + pts.length() + " vecA "+vecA);//XXX
		if (pts.length()>0)
			ptTo = pts.first()+vecYA*dOffsetXB;

		nConnectionType = 4;
		dOffsetXB.setReadOnly(true);		
	}
	_Map.setInt("ConnectionType",nConnectionType);
	
	
	int bCTNotDefined = nConnectionType == 0;	// 0 = not defined
	int bCTStraight = nConnectionType == 1;	// 1 = angled
	int bCTAngled = nConnectionType == 2;	// 2 = angled
	int bCTDoubleAngled = nConnectionType == 3;	// 3 = double angled
	int bCTStraightToEdge = nConnectionType == 4;	// 4 = straight to edge
	int bCTFreePath = nConnectionType == 5;	// 5 = free path
	int bCTDoubleAngledHorizontal = nConnectionType == 6;	// 6 = double angled (horizontal)		

//End Connecting to cells or combinations//endregion 



	
	
	
	plRoute.addVertex(ptTo);

//
//{ 
//	Display dpp(2);
//	dpp.textHeight(U(10));
//	for (int i=0;i<_PtG.length();i++) 
//	{ 
//		dpp.draw(i,_PtG[i],_XW,_YW,0,0,_kDeviceX); 
//		 
//	}//next i
//	
//}

//End Routing//endregion 

//region Tooling and display
	
	//region Connection Types
	int bSnapToEdge;
	for (int i=0;i<_PtG.length();i++) //HSB-16095
	{ 
		if (i > 1)break;
		Line ln(_PtG[i], vecY);
		Point3d pts[] = ppContour.intersectPoints(Plane(_PtG[i], vecX), true, false);
		if (pts.length()>0 && abs(vecY.dotProduct(pts.first()- _PtG[i]))<dEps)bSnapToEdge = true;
		if (pts.length()>1 && abs(vecY.dotProduct(pts.last()- _PtG[i]))<dEps)bSnapToEdge = true;
	
	}//next i


//	int nConnectionType = _Map.getInt("ConnectionType");
//	int bCTNotDefined = nConnectionType == 0;	// 0 = not defined
//	int bCTStraight = nConnectionType == 1;	// 1 = angled
//	int bCTAngled = nConnectionType == 2;	// 2 = angled
//	int bCTDoubleAngled = nConnectionType == 3;	// 3 = double angled
//	int bCTStraightToEdge = nConnectionType == 4;	// 4 = straight to edge
//	int bCTFreePath = nConnectionType == 5;	// 5 = free path
//	int bCTDoubleAngledHorizontal = nConnectionType == 6;	// 6 = double angled (horizontal)
	
	int bDoDrill;
	if (dDiameter > 0 && !bHasDepth)
	{ 	
		if (bCTStraightToEdge || 
			(bIsLogWall && bIsVerticalConnection) ) //HSB-12621-5 allow drills when connecting vertical
			bDoDrill = true;
	
	// allow drills for standalone conduits if they intersect at least one edge
		else if (!cellA.bIsValid() && !cellB.bIsValid() && _PtG.length()==2 && ppSips.length()>0)
		{ 
			Vector3d vecDir = _PtG[1] - _PtG[0]; vecDir.normalize();
			if (ppContour.pointInProfile(_PtG[0])!=_kPointInProfile || ppContour.pointInProfile(_PtG[1])!=_kPointInProfile)
				bDoDrill = true;
			else
			{ 				
				LineSeg seg(_PtG[0], _PtG[1]);
				for (int i=0;i<ppSips.length();i++) 
				{ 
					PlaneProfile pp = ppSips[i];
					LineSeg segs[]= pp.splitSegments(seg, true);
					for (int j=0;j<segs.length();j++) 
					{ 
						Point3d pt1 = segs[j].ptStart();
						Point3d pt2 = segs[j].ptEnd();
						Point3d pt1N = pp.closestPointTo(pt1);
						Point3d pt2N = pp.closestPointTo(pt2);
						double d1 = abs(vecDir.dotProduct(pt1 - pt1N));
						double d2 = abs(vecDir.dotProduct(pt2 - pt2N));
						
						if (d1<dEps || d2<dEps)
						{
							bDoDrill = true;
							break;
						} 
					}//next j
					if (bDoDrill)break;				 
				}//next i	
			}
			
		//region Trigger ExtendToEdges
			String sTriggerExtendToEdges = T("|Extend to Edges|");
			addRecalcTrigger(_kContextRoot, sTriggerExtendToEdges );
			if (_bOnRecalc && _kExecuteKey==sTriggerExtendToEdges)
			{
				Vector3d vecPerp = vecDir.crossProduct(-vecFace);
				Plane pn(_PtG[0], vecPerp);
				Point3d pts[] = Line(_PtG[0], vecDir).orderPoints(ppContour.intersectPoints(pn, true, false), dEps);
				if (pts.length()>1)
				{ 
					_PtG[0]=pts.first();
					_PtG[1]=pts.last();
				}
				setExecutionLoops(2);
				return;
			}//endregion	

			
		}			
	
	// allow drill if snap to edge // HSB-14382
		else if (bSnapToEdge)
			bDoDrill = true;
			
	}

	int bDoFreeProfile = dDiameter > 0 && dZConduit > 0 && !bDoDrill && 
		(bCTAngled || bCTDoubleAngled || bCTFreePath  || bCTDoubleAngledHorizontal);
	
	int bDoBeamcut = dDiameter > 0 && dZConduit > 0 && 
		(bCTStraight || bCTStraightToEdge || (bCTNotDefined && _PtG.length()==2 && !bIsFloor && !bDoDrill)); // //HSB-14469 //HSB-14382
	
	int bDoEdgeTool = dDiameterEdge > 0 && (
		(_PtG.length()>0 && nIndexA <1 && ppContour.pointInProfile(_PtG[0])!=_kPointInProfile) || 
		(_PtG.length()>1 && nIndexB <1 && ppContour.pointInProfile(_PtG[1])!=_kPointInProfile) ||
		bCTStraightToEdge);

	int bDoBySegment= (bIsSFWall ||bIsFloor) && dDepth==0;		//HSB-14469
	if (bDoFreeProfile && (bIsSFWall ||bIsFloor)  && dDepth==0)	//HSB-14469
	{ 
		bDoBySegment = true;
		bDoFreeProfile = false;
	}
	int bDoBySegmentLog;
	if (!bHasDepth && bIsLogWall && bIsVerticalConnection &&
		(bCTAngled || 
		(bCTFreePath && !bSnapToEdge))) // HSB-14161
	{ 
		bDoBySegmentLog = true;
		bDoDrill = false;
		bDoFreeProfile = false;
	}	

	if (!bDoDrill  && !bDoBySegment && !bDoBySegmentLog)dOffsetZ.setReadOnly(_kHidden);			
	//endregion 

	//region Displays
	int nc=nFace==1?3:4;
	if (bDoDrill)nc = 40;
	else if (bDoFreeProfile)nc = nFace==1?3:4;
	else if (bDoBeamcut)nc = nFace==1?82:142;	
	
	Display dp(nc), dpPlan(nc),dpModel(nc), dpElement(nc);
	dpModel.addHideDirection(vecZ);
	dpModel.addHideDirection(-vecZ);
	dpModel.addHideDirection(vecY);
	dpElement.addViewDirection(vecZ);
	dpElement.addViewDirection(-vecZ);
	dpElement.showInDxa(true);
	dpModel.showInDxa(true);
	
	if (sDimStyle.length()>0)dpElement.dimStyle(sDimStyle);
	if(dTextHeight>0)dpElement.textHeight(dTextHeight);
	dpPlan.addViewDirection(vecY);			
	//endregion 	

	//region Refs
	Point3d ptRef =ptFaceZone;
	if(bDoDrill || (bDoBySegment && !bHasDepth) || bDoBySegmentLog)
	{
		ptRef = ptCen + vecZ * dOffsetZ;
 		if (el.bIsValid() && nZones.length()>1)// an element with multiple zones
			ptRef += vecZ * (vecZ.dotProduct(zone.ptOrg() - ptRef) + dOffsetZ) + zone.vecZ() * .5 * dZZone;
	}	
	Plane pnRef(ptRef, vecZ);//ptRef.vis(2);
	
	ptTo += vecZ * vecZ.dotProduct(ptRef - ptTo);
	ptFrom += vecZ * vecZ.dotProduct(ptRef - ptFrom);
	if (cellA.bIsValid())	
		ptFrom += vecA * vecA.dotProduct(cellA.ptOrg()-ptFrom);

	plRoute.projectPointsToPlane(pnRef, vecZ);
	if (plRoute.coordSys().vecZ().dotProduct(vecFace)<0)
		plRoute.flipNormal();
	PLine plPath = plRoute;
	PlaneProfile ppConduit(cs);			
	//endregion 

	//region Get Profile and resolve rings from submaps	
	int bDrawLinework;
	int bHasProfile = mapProfile.length()>0 && ppProfile.area() > pow(dEps, 2);
	Point3d ptProfile = ptFrom -vecFace*.5*dDepth ;
	PLine plProfileRings[0],plProfileOpenings[0]; int nProfileColors[0];
	
	if (bHasProfile)
	{ 
		for (int i=0;i<mapProfile.length();i++) 
		{ 
			if (!mapProfile.hasMap(i))continue;
			Map m= mapProfile.getMap(i);
			PLine pl = m.getPLine("pline");
			int isOpening = m.getInt("isOpening");
			//pl.transformBy(csP);
			if (isOpening)
				plProfileOpenings.append(pl);
			else
			{
				plProfileRings.append(pl);
				nProfileColors.append(m.getInt("Color")); 
			}
		}//next i
	}	
	else
	{ 
		bDrawLinework = true;
		if (0) // if disabled should alos contribute to solids
		{ 
			ppProfile = PlaneProfile(CoordSys(ptProfile, vecX, -vecZ,vecY));
			PLine pl;
			if (bDoDrill || dDepth<dEps)	
				pl.createCircle(ptProfile, vecY, dDiameter * .5);
			else 
				pl.createRectangle(LineSeg(ptProfile-.5*(vecX*dDiameter+vecZ*dDepth),
				ptProfile + .5 * (vecX * dDiameter + vecZ * dDepth)), vecX ,- vecZ);
	
			ppProfile.joinRing(pl, _kAdd);
			plProfileRings.append(pl);			
		}

		//ppProfile.vis(40);		
	}	

//endregion 
	
//region Tool by...
	Body bdRoutes[0];	int nBodyColors[0]; Point3d ptPathStarts[0];
	PlaneProfile ppSFIntersection(cs);
	
// check if drilling is allowed
	if (bDoDrill)
	{ 
		dRadius.setReadOnly(_kHidden);
		Drill tool(ptTo, ptFrom, dDiameter * .5);
		tool.addMeToGenBeamsIntersect(genbeams);
		
		GenBeam gbs[] = Body(ptTo, ptFrom, dDiameter * .5+dEps).filterGenBeamsIntersect(genbeams);
		for (int i=0;i<gbs.length();i++) 
		{
			int n = genbeams.find(gbs[i]);
			if (n>-1)
				ppSFIntersection.unionWith(pps[n]);
		}

		if (bDrawLinework)
			dp.draw(plRoute);
		
		Vector3d vecXS = ptTo - ptFrom; vecXS.normalize();
		Vector3d vecYS = vecXS.crossProduct(-vecFace);
		ppConduit.createRectangle(LineSeg(ptFrom-vecYS*.5*dDiameter,ptTo+vecYS*.5*dDiameter), vecXS, vecYS);	
		//ppConduit.vis(5);
	}
	
// free profile
	else if (bDoFreeProfile)
	{ 
		plPath = plRoute;
		{ 
			Vector3d vecStart = plPath.getPointAtDist(dEps)-plPath.ptStart(); vecStart.normalize();
			Vector3d vecEnd = plPath.ptEnd()-plRoute.getPointAtDist(plPath.length()-dEps); vecEnd.normalize();
	
			Point3d pts[] = plPath.vertexPoints(true);
			double dXSegs[0], dMaxRadius=dRadius; // the lengths of the segments, radius may not be smaller than neither one
			
			for (int p = 0; p < pts.length() - 1; p++)
				dXSegs.append((pts[p + 1] - pts[p]).length());
	
		// evaluate contour offset: extruding a path has some limitations	
			double dContourOffset = dRadius;
			if (dXSegs.first() <  dDiameter)
			{
				plPath.trim(dXSegs.first(), false);
				vecStart = plPath.getPointAtDist(dEps)-plPath.ptStart(); vecStart.normalize();
			}
			if (dXSegs.last() < dDiameter)
			{
				plPath.trim(dXSegs.last(), true);
				vecEnd = plPath.ptEnd()-plRoute.getPointAtDist(plPath.length()-dEps); vecEnd.normalize();
			}
			
			vecStart.vis(plPath.ptStart(), 3);
			vecEnd.vis(plPath.ptEnd(), 3);
			
			
			dContourOffset = dContourOffset > dMaxRadius? dMaxRadius: dContourOffset;			
			dContourOffset = dContourOffset < .5 * dDiameter ? 0 : dContourOffset;		
	
		// create path with radius	
			if (abs(dContourOffset)>0)
			{ 
				plPath.offset(dContourOffset,true);
				plPath.offset(-2*dContourOffset, true);
				plPath.offset(dContourOffset, true);	
			}			
		}

		double dY= dDiameter * .5;
		double dOffset = dRadius > 0 && dRadius<=dY ? dRadius : dY;

		PLine pl1 = plPath;
		PLine pl2 = plPath;
		
	// pre offset pline with no rounding	
		if (dRadius>0 && dRadius<=dY)
		{ 
			double d = dY - dOffset;
			pl1.offset(d, false);
			pl2.offset(-d, false);
		}
	
	// offset with rounding
		if (dRadius>0)
		{ 
			pl1.offset(dOffset, true);
			pl2.offset(-dOffset, true);			
		}
	// offset no rounding	
		else
		{ 
			pl1.offset(dOffset, false);
			pl2.offset(-dOffset, false);			
		}
		pl2.reverse();//	pl2.vis(3);	
		
	// combine pline 1+2	
		pl1.append(pl2);
		pl1.close();	//pl1.vis(2);			

		
	// draw shape	
		PlaneProfile pp = PlaneProfile(pl1);
		if (shapes.length()>0)pp.subtractProfile(shapes[0]);
		if (shapes.length()>1)pp.subtractProfile(shapes[1]);

		ppConduit = pp;

	// Freeprofile
		FreeProfile tool;
		PLine plTool =pl1;// dRadius>0? pl1 :plRoute;
		plTool.convertToLineApprox(U(5));

		tool=FreeProfile(plTool, plTool.vertexPoints(true));
		tool.setDepth(dZConduit);
		if (dRadius>0)tool.setSolidMillDiameter(dRadius);
		tool.setSolidPathOnly(false);

		Body bd = tool.cuttingBody();	//bd.vis(2);
		if (bd.volume()>pow(dEps,3))
		{ 
			tool.addMeToGenBeamsIntersect(genbeams);
		}

	// draw linework
		if (bDrawLinework)
		{ 
			dp.draw(pp, _kDrawFilled, 80);
			dp.draw(pp);		
			//plRoute2.vis(6);
		
		}
		//dp.draw(bdRoute);

		
	}
// beamcut
	else if (bDoBeamcut)
	{
		Vector3d vecXB = ptTo - ptFrom;	vecXB.normalize();	
		Vector3d vecYB = vecXB.crossProduct(-vecFace);
	vecXB.vis(ptFrom, 1);
	vecYB.vis(ptFrom, 3);
	vecFace.vis(ptFrom, 150);
	
		
		double dL = Vector3d(ptTo - ptFrom).length();
		if (dL<dEps){ eraseInstance(); return;}
		BeamCut tool (ptFrom, vecXB, vecYB, vecFace, dL, dDiameter, dZConduit, 1, 0 ,- 1);
		Body bd = tool.cuttingBody();//()
		bd.vis(2);
		tool.addMeToGenBeamsIntersect(genbeams);
		PlaneProfile pp = bd.shadowProfile(pnRef);		
	
		ppConduit = pp;
		if (shapes.length()>0)pp.subtractProfile(shapes[0]);
		if (shapes.length()>1)pp.subtractProfile(shapes[1]);
		if (bDrawLinework)
		{ 
			dp.draw(pp,_kDrawFilled, 80);
			dp.draw(pp);			
		}
	}
// bySegmentSF
	else if (bDoBySegment)
	{ 
		plPath = plRoute;
		{ 
			Vector3d vecStart = plPath.getPointAtDist(dEps)-plPath.ptStart(); vecStart.normalize();
			Vector3d vecEnd = plPath.ptEnd()-plRoute.getPointAtDist(plPath.length()-dEps); vecEnd.normalize();
	
			Point3d pts[] = plPath.vertexPoints(true);
			double dXSegs[0], dMaxRadius=dRadius; // the lengths of the segments, radius may not be smaller than neither one
			
			for (int p = 0; p < pts.length() - 1; p++)
				dXSegs.append((pts[p + 1] - pts[p]).length());
	
		// evaluate contour offset: extruding a path has some limitations	
			double dContourOffset = dRadius;
			if (dXSegs.first() <  dDiameter)
			{
				plPath.trim(dXSegs.first(), false);
				vecStart = plPath.getPointAtDist(dEps)-plPath.ptStart(); vecStart.normalize();
			}
			if (dXSegs.last() < dDiameter)
			{
				plPath.trim(dXSegs.last(), true);
				vecEnd = plPath.ptEnd()-plRoute.getPointAtDist(plPath.length()-dEps); vecEnd.normalize();
			}
			
			vecStart.vis(plPath.ptStart(), 3);
			vecEnd.vis(plPath.ptEnd(), 3);
			
			
			dContourOffset = dContourOffset > dMaxRadius? dMaxRadius: dContourOffset;			
			dContourOffset = dContourOffset < .5 * dDiameter ? 0 : dContourOffset;		
	
		// create path with radius	
			if (abs(dContourOffset)>0)
			{ 
				plPath.offset(dContourOffset,true);
				plPath.offset(-2*dContourOffset, true);
				plPath.offset(dContourOffset, true);	
			}			
		}
		

		Point3d pts[] = plPath.vertexPoints(true);
		Vector3d vecStart, vecEnd;
		double dXSegs[0], dMaxRadius=dRadius; // the lengths of the segments, radius may not be smaller than neither one
		
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Point3d pt1 = pts[p];
			Point3d pt2 = pts[p+1];
			
			Vector3d vecXS = pt2 - pt1;
			double dXL = vecXS.length(); vecXS.normalize();
			Vector3d vecYS = vecXS.crossProduct(vecFace);

		// get start and end vector and segment length
			if (p == 0)vecStart = vecXS;
			else if (p == pts.length() - 2)vecEnd = vecXS;
			dXSegs.append(dXL);
			if (dXL < dMaxRadius)dMaxRadius = dXL*.5;

			Point3d ptBc = pt1 + vecFace * vecFace.dotProduct(ptFaceZone - pt1);
			Body bdx;
			if (dDepth<=0)
				bdx = Body (pt1, pt2, dDiameter * .5 + dEps);
			else
				bdx = Body(ptBc, vecXS, vecYS, vecFace, dXL, dDiameter, dDepth, 1, 0 ,- 1);
			//bdx.vis(p);
			

			GenBeam gbs[] = bdx.filterGenBeamsIntersect(genbeams);
			
			Drill dr(pt1 - vecXS * U(10e3), pt2 + vecXS * U(10e3), dDiameter * .5);		
			double dXBc = dXL;
			double dYBc =dDiameter; 
			double dZBc =(dDepth>0?dDepth:dDiameter)*.5;
			dZBc += vecFace.dotProduct(ptBc - pt1);			
			if (p>0) // extent at start
			{ 
				ptBc -= vecXS * .5 * dDiameter;
				dXBc += .5 * dDiameter;
			}
			if (pts.length()>2 && p<pts.length()-2)// extent at end
			{ 
				dXBc += .5 * dDiameter;
			}

			BeamCut bc(ptBc, vecXS, vecYS, vecFace, dXBc, dYBc, dZBc, 1, 0 ,- 1);			
			//bc.cuttingBody().vis(2);
			
			for (int i=0;i<gbs.length();i++) 
			{ 
				GenBeam gb= gbs[i]; 
				int n = genbeams.find(gb);
				if (n < 0)continue;
				PlaneProfile pp = pps[n];
				ppSFIntersection.unionWith(pp);
				int bAddBc = (dDepth>0 || pp.pointInProfile(pt1)==_kPointInProfile && pp.pointInProfile(pt1)==_kPointInProfile) || 
					gb.vecX().isParallelTo(vecXS);				 
				if (bAddBc)
					gb.addTool(bc);
				else
					gb.addTool(dr);	 
			}//next i 
		}//next p
		
	// offset no rounding
		PLine pl1 = plPath;
		PLine pl2 = plPath;
		pl1.offset(dDiameter * .5, false);
		pl2.offset(-dDiameter * .5, false);			
		pl2.reverse();	
		int bOk = pl1.append(pl2);
		pl1.close();
		
	// draw element view shape
		PlaneProfile pp(cs);
		pp= PlaneProfile(pl1);
		ppConduit = pp;
		if (shapes.length()>0)pp.subtractProfile(shapes[0]);
		if (shapes.length()>1)pp.subtractProfile(shapes[1]);
		if (bDrawLinework)
		{ 			
			dpElement.draw(pp, _kDrawFilled, ntElement);
			dpElement.draw(pp);
		}
		
		if (dDepth<=dEps && sStrategy==kDefaultStrategy)//HSB-14469
		{ 
			plPath.vis(6);
			PLine pl;
			pl.createCircle(plPath.ptStart(), vecStart, dDiameter*.5);
			pl.vis(4);
			Body bd;
			if (plPath.vertexPoints(true).length()==2)
				bd = Body(plPath.ptStart(), plPath.ptEnd(), dDiameter * .5);
			else
				bd = Body(pl, plPath,32);
			bd.vis(4);
			dpModel.draw(bd);
		}
		//ppConduit.vis(2);
				
		
	}
// bySegmentLog HSB-12285
	else if (bDoBySegmentLog)
	{
		PlaneProfile pp(CoordSys(ptRef, vecX, vecY, vecZ));
		
		Point3d pts[] = plRoute.vertexPoints(true);
		for (int p = 0; p < pts.length() - 1; p++)
		{
			Point3d pt1 = pts[p];
			Point3d pt2 = pts[p + 1];
			
			
			Point3d pt1Dr = pt1;
			Point3d pt2Dr = pt2;
			
			
			Vector3d vecXS = pt2 - pt1;
			double dXL = vecXS.length(); vecXS.normalize();
			Vector3d vecYS = vecXS.crossProduct(vecFace);
			Line ln(pt1, vecXS);
			
		// vertical/aligned drill
			if (!vecXS.isParallelTo(vecX))
			{ 
				Body bdx;				
				if (!vecXS.isParallelTo(vecY))
				{ 
					bdx=Body(pt1-vecXS*dDiameter, pt2+vecXS*dDiameter, dDiameter * .5 + dEps);
					Vector3d vecCut = vecXS.dotProduct(vecY) < 0 ? vecY :-vecY;
					bdx.addTool(Cut(pt1 ,vecCut), 0);
					bdx.addTool(Cut(pt2 ,-vecCut), 0);					
				}
				else
					bdx=Body(pt1, pt2, dDiameter * .5 + dEps);

				bdx.vis(4);
				GenBeam gbs[] = bdx.filterGenBeamsIntersect(genbeams);
				Point3d ptsX[0];
				for (int i=0;i<gbs.length();i++) 
				{ 
					Plane pn (gbs[i].ptCen(), vecY);
					
					ptsX.append(ln.intersect(pn,-.5*gbs[i].dD(vecY)));
					ptsX.append(ln.intersect(pn,.5*gbs[i].dD(vecY)));
				}//next i
				ptsX = Line(_Pt0, vecXS).orderPoints(ptsX, dEps);
				if (ptsX.length()>0)
				{ 
					pt1Dr += vecXS*(vecXS.dotProduct(ptsX.first()-pt1Dr)-dDiameter);
					pt2Dr += vecXS*(vecXS.dotProduct(ptsX.last()-pt2Dr)+dDiameter);
					
					Drill dr(pt1Dr, pt2Dr, dDiameter * .5);
					dr.addMeToGenBeamsIntersect(gbs);
					
				}

				pp.unionWith(bdx.shadowProfile(pnRef));

			}
			else
			{ 
				int n = nFace * (vecXS.isCodirectionalTo(vecX) ?- 1 : 1);
				PLine pl(vecFace);
				pl.addVertex(pt1 - vecXS * .5 * dDiameter);
				pl.addVertex(pt1 +vecY * .5 * dDiameter, n*tan(22.5));
				pl.addVertex(pt2 +vecY * .5 * dDiameter);
				pl.addVertex(pt2 + vecXS * .5 * dDiameter, n*tan(22.5));
				pl.close();
				pp.joinRing(pl, _kAdd);
			}
	
		}//next p
		
		if (shapes.length()>0)pp.subtractProfile(shapes[0]);
		if (shapes.length()>1)pp.subtractProfile(shapes[1]);

		dp.addViewDirection(vecZ);
		dp.addViewDirection(-vecZ);
		dp.draw(pp, _kDrawFilled, 80);
		dp.draw(pp);
		dp.draw(plRoute);
		dpModel.draw(plRoute);
		
	}
	else
	{	
		dp.draw(plPath);
	}

	_Map.setPLine("plRoute", plRoute);		
//endregion 	
	
	
// Hardware Prerequisites//region
// collect existing hardware
	HardWrComp hwcs[0];
	if (!_bOnGripPointDrag)
	{ 
		hwcs= _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			//if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 		
	}


// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
		if (el.bIsValid()) 	sHWGroupName=el.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	//endregion	
	
//region Extrude profile along path
	if (plProfileRings.length()>0 && !_bOnGripPointDrag && plRoute.length()>dEps)
	{ 
		ppConduit.removeAllRings(); // reset if profiles in use
		plPath = plRoute;
		Vector3d vecStart = plPath.getPointAtDist(dEps)-plPath.ptStart(); vecStart.normalize();
		Vector3d vecEnd = plPath.ptEnd()-plRoute.getPointAtDist(plPath.length()-dEps); vecEnd.normalize();

		Point3d pts[] = plPath.vertexPoints(true);
		double dXSegs[0], dMaxRadius=dRadius; // the lengths of the segments, radius may not be smaller than neither one
		
		for (int p = 0; p < pts.length() - 1; p++)
			dXSegs.append((pts[p + 1] - pts[p]).length());

	// evaluate contour offset: extruding a path has some limitations	
		double dContourOffset = dRadius;
		if (dXSegs.first() <  dDiameter)
		{
			plPath.trim(dXSegs.first(), false);
			vecStart = plPath.getPointAtDist(dEps)-plPath.ptStart(); vecStart.normalize();
		}
		if (dXSegs.last() < dDiameter)
		{
			plPath.trim(dXSegs.last(), true);
			vecEnd = plPath.ptEnd()-plRoute.getPointAtDist(plPath.length()-dEps); vecEnd.normalize();
		}
		
		vecStart.vis(plPath.ptStart(), 3);
		vecEnd.vis(plPath.ptEnd(), 3);
		
		
		dContourOffset = dContourOffset > dMaxRadius? dMaxRadius: dContourOffset;			
		dContourOffset = dContourOffset < .5 * dDiameter ? 0 : dContourOffset;		

	// create path with radius	
		if (abs(dContourOffset)>0)
		{ 
			plPath.offset(dContourOffset,true);
			plPath.offset(-2*dContourOffset, true);
			plPath.offset(dContourOffset, true);	
		}
		// convert a copy to be segmented
		PLine plSegPath = plPath;
		plSegPath.convertToLineApprox(U(5));
		Point3d ptsSeg[] = plSegPath.vertexPoints(false);

int tick2,tick1,tick0 = getTickCount();
	// create voids and potential subtractions
		for (int io=0;io<2;io++) 
		{ 
			PLine rings[0]; rings = io==0?plProfileRings:plProfileOpenings;
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine pl = rings[r];
				
				Point3d ptStart = plPath.ptStart(),ptsStart[0];
				Vector3d vecYStart = vecStart.crossProduct(-vecFace);
				
				CoordSys csp=ppProfile.coordSys();
				csp.setToAlignCoordSys(ppProfile.ptMid(), csp.vecX(), csp.vecY(), csp.vecZ(),
					ptStart-vecFace*.5*dDepth, vecYStart,-vecFace,  vecStart);			
				pl.transformBy(csp);
				
			//	pl.vis(1);	
//				pl.convertToLineApprox(U(5));
//				ptsStart = pl.vertexPoints(true);
//				
//				Point3d ptEnd = plPath.ptEnd(),ptsEnd[0];
//				Vector3d vecYEnd = vecEnd.crossProduct(-vecFace);					
//				CoordSys csStartToEnd;
//				csStartToEnd.setToAlignCoordSys(ptStart, vecStart, vecYStart, vecFace, ptEnd, vecEnd,vecYEnd, vecFace);
//				pl.transformBy(csStartToEnd);
//				//pl.vis(2);
//				
//				
//				ptsEnd = pl.vertexPoints(true);//

				Body bd(pl, plPath,32);
//				Body bd(ptsStart, plPath, ptsEnd,32);	//bd.vis(1);
				if (io==0)
				{
					Point3d pt = PlaneProfile(pl).extentInDir(vecYStart).ptMid();//  pt.vis(6);
					ptPathStarts.append(pt);
					bdRoutes.append(bd);
					nBodyColors.append(nProfileColors);
				}
				else if (io==1)
				{
					for (int j=0;j<bdRoutes.length();j++) 
						bdRoutes[j].addTool(SolidSubtract(bd,_kSubtract));// seems to be more stable than subPart						
				}
			}//next r	 
		}//next io		
		
	//region Loop routed bodies
		tick1 = getTickCount();	
		
		for (int i=0;i<bdRoutes.length();i++) 
		{ 
			Body bd = bdRoutes[i];	
			PlaneProfile pp;
			
			if (abs(dSplitSegmentGap)>dEps || abs(dCombiGap)>dEps)
				pp = bd.shadowProfile(Plane(ptFace, vecZ));
			
		// subtract blownup intersections	
			if (abs(dSplitSegmentGap)>dEps)
			{ 
				PlaneProfile ppa = pp;
				ppa.intersectWith(ppSFIntersection);
				PLine rings[] = ppa.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
				{ 
					PlaneProfile ppx(rings[r]);
					ppx.shrink(-dSplitSegmentGap);
					PLine _rings[] = ppx.allRings(true, false);
					if (_rings.length() > 0)rings[r] = _rings.first();
					Body bdx(rings[r], vecZ*U(10e3), 0);
					//bdx.vis(r);
					if (bd.hasIntersection(bdx))
						bd.addTool(SolidSubtract(bdx, _kSubtract));	 
				}//next r
			}
			
			
		// subtract blownup combination intersections	

			if (abs(dCombiGap)>dEps)
			{ 
				for (int j=0;j<ppCombiShapes.length();j++) 
				{ 
					PlaneProfile ppa = pp;
					ppa.intersectWith(ppCombiShapes[j]);
					PLine rings[] = ppa.allRings(true, false);
					for (int r=0;r<rings.length();r++) 
					{ 
						PlaneProfile ppx(rings[r]);
						ppx.shrink(-dCombiGap);
						PLine _rings[] = ppx.allRings(true, false);
						if (_rings.length() > 0)rings[r] = _rings.first();
						Body bdx(rings[r], vecZ*U(10e3), 0);
						//bdx.vis(r);
						if (bd.hasIntersection(bdx))
							bd.addTool(SolidSubtract(bdx, _kSubtract));	 
					}//next r			 
				}//next j
			}			

		// set colors			
			int color = nBodyColors.length()>i?nBodyColors[i]:nc;
			dpElement.color(color);
		
		// offset path of multiple profile rings
			PLine plSegPath = plPath;
			double dSegOffset = (vecStart.crossProduct(vecZ).dotProduct(ptPathStarts[i] - plPath.ptStart()));	
			plSegPath.offset(dSegOffset);
			plSegPath.convertToLineApprox(5);
			//plPath.ptStart().vis(1);ptPathStarts[i].vis(2); plSegPath.vis(3);
			ptsSeg = plSegPath.vertexPoints(true);
			double dYFlag = 0;
			if (abs(dSegOffset) > 0)dYFlag = -dSegOffset / abs(dSegOffset);
		
		// attach hardware by lump			
			Body lumps[] = bd.decomposeIntoLumps();
			tick2 = getTickCount();	
			for (int j=0;j<lumps.length();j++) 
			{ 
				double dScaleX;
				pp = lumps[j].shadowProfile(pnRef);
				
				if (ntElement<100) dpElement.draw(pp, _kDrawFilled, ntElement);
				dpElement.draw(pp);
				
				for (int p=0;p<ptsSeg.length()-1;p++) 
				{ 
					LineSeg seg(ptsSeg[p],ptsSeg[p+1]); 
					LineSeg segs[]=pp.splitSegments(seg, true);
					
					for (int s=0;s<segs.length();s++) 
					{ 
						segs[s].vis(s); 
						dScaleX+=segs[s].length(); 
					}//next s

				}//next p
				
			// add componnent
				if (dScaleX>dEps)
				{ 
					for (int h=0;h<mapHardWares.length();h++) 
					{ 
						Map m = mapHardWares.getMap(h);
						String articleNumber = m.getString("ArticleNumber");
						if (articleNumber.length()<1)
							articleNumber = m.getString("Name") + " " + m.getString("Model") + " " + m.getString("Decription");
						HardWrComp hwc(articleNumber, 1); // the articleNumber and the quantity is mandatory					
						hwc.setManufacturer(m.getString("Manufacturer"));					
						hwc.setModel(m.getString("Model"));
						hwc.setName(m.getString("Name"));
						hwc.setDescription(m.getString("Decription"));
						hwc.setMaterial(m.getString("Material"));
						//hwc.setNotes(sHWNotes);
						
						hwc.setGroup(sHWGroupName);
						hwc.setCategory(m.getString("Category"));
						hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
						
						hwc.setDScaleX(dScaleX);
				//		hwc.setDScaleY(dHWWidth);
				//		hwc.setDScaleZ(dHWHeight);
						hwc.setDAngleA(j);
					// apppend component to the list of components
						hwcs.append(hwc);					
						 
					}//next h
	
				// add tag
					if (sTagMode!=kDisabled)
					{ 
						Map m = mapHardWares.getMap(0);
						m.setDouble("ScaleX", dScaleX);
						String text = _ThisInst.formatObject(sFormat, m);
						if (text.length()>0)
						{ 
							Point3d pt = plSegPath.closestPointTo(pp.ptMid());
							Vector3d vecXT = plSegPath.getTangentAtPoint(pt);
							dpElement.draw(text, pt, vecXT, vecXT.crossProduct(-vecFace), 0, dYFlag, _kDevice);						
						}
					}						
				}

//				Display dp(j);
//				dp.draw(pp, _kDrawFilled, 20);
				 
			}//next j
			
			ppConduit.unionWith(pp);
			dpModel.color(color);
	
		// model	
			dpModel.draw(bd);
		
		// plan
			dpPlan.color(color);
			dpPlan.draw(bd);
			if (ntPlan<100)
			{ 
				//pp= bd.shadowProfile(Plane(_Pt0, vecY));
				
				// fill only start and end
				pp = bd.extractContactFaceInPlane(Plane(plSegPath.ptStart(), vecStart), U(100));// this will fail with combinations wider then 100mm
				dpPlan.draw(pp, _kDrawFilled, ntPlan);
				pp = bd.extractContactFaceInPlane(Plane(plSegPath.ptEnd(), vecEnd), U(100));
				dpPlan.draw(pp, _kDrawFilled, ntPlan);
				//dpPlan.draw(pp);	
			}
//			else
//				dpPlan.draw(bd);
			

		}//next i
			
	//endregion 		
if (bDebug)reportNotice("\ntick " + (tick1-tick0) + " "+(tick2-tick1) + " " + (getTickCount()-tick2) + " = " + (getTickCount()-tick0));		
		
		
	}
//endregion 
//region Default Strategy
	else if (!_bOnGripPointDrag)
	{ 
		double dScaleX = plPath.length();
		
	// add componnent
		if (dScaleX>dEps)
		{ 
			for (int h=0;h<mapHardWares.length();h++) 
			{ 
				Map m = mapHardWares.getMap(h);
				String articleNumber = m.getString("ArticleNumber");
				if (articleNumber.length()<1)
					articleNumber = m.getString("Name") + " " + m.getString("Model") + " " + m.getString("Decription");
				HardWrComp hwc(articleNumber, 1); // the articleNumber and the quantity is mandatory					
				hwc.setManufacturer(m.getString("Manufacturer"));					
				hwc.setModel(m.getString("Model"));
				hwc.setName(m.getString("Name"));
				hwc.setDescription(m.getString("Decription"));
				hwc.setMaterial(m.getString("Material"));
				//hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setCategory(m.getString("Category"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(dScaleX);
		//		hwc.setDScaleY(dHWWidth);
		//		hwc.setDScaleZ(dHWHeight);
				//hwc.setDAngleA(j);
			// apppend component to the list of components
				hwcs.append(hwc);					
				 
			}//next h						
		}
		
	// add tag
		if (dScaleX>dEps && sTagMode!=kDisabled)
		{ 
			Map m = mapHardWares.getMap(0);
			m.setDouble("ScaleX", dScaleX);
			String text = _ThisInst.formatObject(sFormat, m);
			if (text.length()>0)
			{ 
				Point3d pt = plPath.ptMid();
				Vector3d vecXT = plPath.getTangentAtPoint(pt);
				dpElement.draw(text, pt, vecXT, vecXT.crossProduct(-vecFace), 0, 0, _kDevice);				
			}

		}		
		
		
	}
//endregion 

//region Element Tools
	if (bAddElementTool && nToolIndex>-1 && !_bOnGripPointDrag)
	{ 
	//  NoNails
		PLine plNNs[0];
		
		PlaneProfile ppNN = ppConduit;
		for (int i=0;i<ppCombiShapes.length();i++) 
			ppNN.subtractProfile(ppCombiShapes[i]); 
	
		//{ Display dpx(2); dpx.draw(ppNN,_kDrawFilled);}
	
		plNNs = ppNN.allRings(true, false);

		double dHTotal;
		int nOuterZone;
		for (int i=0;i<5;i++) 
		{ 
			int z = nFace * (i + 1);
			ElemZone zone = el.zone(z);
			double dH = zone.dH();
			
			if (dH>dEps)
			{ 
				nOuterZone = z;
				if (abs(z)<=abs(nZone))
					dHTotal += dH;
				for (int j=0;j<plNNs.length();j++) 
				{ 
					plNNs[j].convertToLineApprox(U(100));
					ElemNoNail nn(z, plNNs[j]);					
					//el.addTool(nn); 
				}//next j
			}			 
		}//next i
		
	// milling 
		PLine plTools[] = ppConduit.allRings(true, false);
		if (abs(nZone)>0 && plTools.length()>0)
		{ 
			double dToolDepth = dHTotal;
			PLine plTool = plTools.first();
			ElemMill tool(nZone, plTool, dToolDepth, nToolIndex, _kLeft, _kCCWise, _kNoOverShoot);
			el.addTool(tool);
		}
		
		
		
	}
//endregion 	

//End Tooling//endregion	

//region EdgeTool
	if (bDoEdgeTool)	
	{ 
		Vector3d vecXB = vecX;// ptFrom-ptTo;	vecXB.normalize();  // ptFrom -ptTo will fail on double angled
		Vector3d vecYB = vecY;//vecXB.crossProduct(-vecFace);
		vecXB.vis(ptTo,2);
		Point3d ptMid = ptTo +vecY * dOffset+vecFace*vecFace.dotProduct(ptFaceZone-ptTo);
		
		double dThisDepth = dDepthEdge<=0?vecFace.dotProduct(ptFaceZone-ptTo)+(bDoDrill?.5:1)*dZConduit:dDepthEdge;
		double dToolDepth = dThisDepth + (dDepthEdge<=0?2*dEps:dEps); // consider tolerance issues 
		
		PlaneProfile ppTool(cs);
		
	// Drill
		if (dHeightEdge<=dEps)
		{ 
			Drill tool(ptMid+vecFace*dEps, ptMid-vecFace*dToolDepth, dDiameterEdge * .5);
			tool.addMeToGenBeamsIntersect(genbeams);
			PLine plTool(vecZ);
			plTool.createCircle(ptMid, vecFace, dDiameterEdge * .5);
			ppTool.joinRing(plTool, _kAdd);
			ppTool.intersectWith(ppContour);
			dp.draw(ppTool,_kDrawFilled, 80);
			ppTool.transformBy(-vecFace * dThisDepth);
			dp.draw(ppTool);
			dp.draw(PLine(ptMid, ptMid-vecFace*dThisDepth));
			
			if (abs(nZone)>0 && bAddElementTool)
			{ 
				ElemDrill tool(nZone, ptMid, -vecFace,  dToolDepth, dDiameterEdge, 1);
				el.addTool(tool);				
			}
		}
		
	// Pocket (Mortise)
		else
		{ 
			
			PLine plTool(vecZ);
			if (dThisDepth>dEps)// byCombination
			{
				double radius = dRadiusTool > 0 ? dRadiusTool : 0;
		
		 		if (radius>0)
		 		{ 
					Mortise tool(ptMid, vecXB, -vecYB, -vecFace, dDiameterEdge, dHeightEdge, dThisDepth, 0, 0,1);	
					tool.setRoundType(_kExplicitRadius);
					tool.setExplicitRadius (radius);
					tool.addMeToGenBeamsIntersect(genbeams);	
					//tool.cuttingBody().vis(6);
					ppTool = tool.cuttingBody().shadowProfile(Plane(ptFaceZone, vecZ));		 			
		 		}
		 		else
		 		{ 
					BeamCut tool(ptMid, vecXB, -vecYB, -vecFace, dDiameterEdge, dHeightEdge, dThisDepth, 0, 0,1);	
					tool.addMeToGenBeamsIntersect(genbeams);	
					//tool.cuttingBody().vis(2);
					ppTool = tool.cuttingBody().shadowProfile(Plane(ptFaceZone, vecZ));		 			
		 		}		
	
				ppTool.intersectWith(ppContour);
				dp.draw(ppTool,_kDrawFilled, 80);
			}
			
		//region Element Tools
			PLine plTools[] = ppTool.allRings(true, false);
			if (bAddElementTool)
			{ 
			// No Nail	
				double dHTotal;
				int nOuterZone;
				for (int i=0;i<5;i++) 
				{ 
					int z = nFace * (i + 1);
					ElemZone zone = el.zone(z);
					double dH = zone.dH();
					
					if (dH>dEps)
					{ 
						nOuterZone = z;
						if (abs(z)<=abs(nZone))
							dHTotal += dH;
						for (int j=0;j<plTools.length();j++) 
						{ 
							PLine plNN; 
							plNN.createRectangle(PlaneProfile(plTools[j]).extentInDir(vecX), vecX, vecY);
							ElemNoNail nn(z, plNN);
							el.addTool(nn); 
						}//next j
					}			 
				}//next i
				
				
			// ElemMill
				// only perform segments which are not the contour
				if (abs(nZone)>0)
				for (int i=0;i<plTools.length();i++) 
				{ 
					PLine pl = plTools[i];
					//if (!pl.coordSys().vecZ().isCodirectionalTo(vecZ))pl.flipNormal();
					Point3d pts[] = pl.vertexPoints(false);
					PLine plTool(vecZ);
					for (int p=0;p<pts.length()-1;p++) 
					{ 
						Point3d pt1 = pts[p]; 
						Point3d pt2 = pts[p+1];
						Point3d ptm = (pt1 + pt2) * .5;
						int bIsOn1 = ppContour.pointInProfile(pt1) == _kPointOnRing;
						int bIsOn2 = ppContour.pointInProfile(pt2) == _kPointOnRing;
						int bIsArc = pl.isOn(ptm);
						
					// add tool
						if ((bIsOn1 && bIsOn2) || p==pts.length()-2)
						{
							if (plTool.length()>0)
							{ 
								ElemMill tool(nZone, plTool, dToolDepth, nToolIndex, _kLeft, _kCCWise, _kNoOverShoot);
								el.addTool(tool);
								
								plTool.vis(6);
							}
				
						// reset
							plTool=PLine(vecZ);						
							continue;
						}
						
					// add first vertex	
						if (plTool.length()<dEps)
							plTool.addVertex(pt1);
						
					// add additional vertices	
						if (bIsArc)
						{ 
							Point3d pt3 = pl.getPointAtDist(pl.getDistAtPoint(pt1) + dEps);
							plTool.addVertex(pt2,pt3);
						}
						else
							plTool.addVertex(pt2);
					}//next p
				}//next i				
				
				
			}
		

		//endregion 	
			
			
			
			
		}
		
		
	}
//End EdgeTool//endregion 	
		
//region Hardware 2
// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);
	setCompareKey(mapHardWares.getDxContent(true));	
//endregion  

//region Trigger

//region Trigger FlipDirection
	String sTriggerFlipDirection = T("|Flip Direction|");
	if (nIndexB<1 && bCTStraightToEdge)addRecalcTrigger(_kContextRoot, sTriggerFlipDirection );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection)
	{
		
	// flip by cell index
		if (nIndexA>0)
		{ 
			if (nIndexA == 1)nIndexA=2;
			else if (nIndexA == 2)nIndexA=1;
			else if (nIndexA == 3)nIndexA=4;
			else if (nIndexA == 4)nIndexA=3;
			_Map.setInt("nodeIndexA", nIndexA);
			
			
			if (ppCombiShapes.length()>0)
			{ 
				ppCombiShapes[0].vis(1);
				Point3d pts[] = ppCombiShapes[0].intersectPoints(Plane(_PtG[0], vecA.crossProduct(-vecZ)), true, false);
				pts = Line(_PtG[0], vecA).orderPoints(pts, dEps);
				if (pts.length()>0)
					_PtG[0] = pts[0];
			}		
			
			if (combis.length()>0)
			{ 
				Entity ents[] = combis[0].entity();
				Point3d pts[0]; TslInst allCells[0];
				for (int i=0;i<ents.length();i++) 
				{ 
					TslInst t= (TslInst)ents[i];	
					if (!t.bIsValid()){ continue;}
					String script = t.scriptName();
					
					if (script.find(kInstaCell,0, false)==0 && script.length()==kInstaCell.length())
					{ 
						pts.append(t.ptOrg());
						allCells.append(t);
					}
		 
				}//next i
				
			// order byDirection
				for (int i=0;i<allCells.length();i++) 
					for (int j=0;j<allCells.length()-1;j++) 
					{
						double d1 = vecA.dotProduct(_Pt0 - allCells[j].ptOrg());
						double d2 = vecA.dotProduct(_Pt0 - allCells[j+1].ptOrg());
						
						if (d1<d2)
						{ 
							allCells.swap(j, j + 1);
							pts.swap(j, j + 1);
						}
					}
				if (allCells.length()>0)
				{ 
					int n = _Entity.find(cellA);
					if (n>-1)
					{ 
	//					if (bDebug)allCells[0].ptOrg().vis(2);	
	//					else 
						_Entity[n] = allCells[0];
					}
				}					
			}
		
		
		

		
	
		}
		
	// flip by combination	
		else if (_Map.hasVector3d("vecN1"))
		{
			//reportMessage("direction flipped by combination shapes ");
			Vector3d vecN =_Map.getVector3d("vecN1") ;
			
			PlaneProfile pp;
			if (combinations.length() > 0)
				pp = combinations.first().map().getPlaneProfile("Shape");

			if (pp.area()>pow(dEps,2))
			{ 
				Point3d pts[] = pp.intersectPoints(Plane(_PtG[0], vecN.crossProduct(-vecZ)), true, false);
				pts = Line(_PtG[0], vecN).orderPoints(pts, dEps);
				if (pts.length()>0)
					_PtG[0] = pts[0];
			}				
			
			vecN *= -1;
			_Map.setVector3d("vecN1", vecN) ;			
			
		}

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger ConnectToCenter
	String sTriggerConnectToCenter = T("|Connect to Center|");
	if (nIndexA>0 && nIndexB<1 && bCTStraightToEdge && combis.length()>0)
		addRecalcTrigger(_kContextRoot, sTriggerConnectToCenter );
	if (_bOnRecalc && _kExecuteKey==sTriggerConnectToCenter)
	{
		Vector3d vecN =_Map.getVector3d("vecN1") ;
		Vector3d vecP =vecN.crossProduct(-vecZ);
		_PtG[0] += vecP * vecP.dotProduct(combis.first().map().getPlaneProfile("Shape").ptMid() - _PtG[0]);
		
		_Map.removeAt("nodeIndexA", true);
		
		Entity cell = _Map.getEntity("cell1");
		int n = _Entity.find(cell);
		if (n>-1)
		{ 
			_Entity.removeAt(n);
			_Map.removeAt("cell1", true);
		}
		_Entity.append(combis.first());
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger Edit Path
	if (!bDoDrill)
	{ 

		
		addRecalcTrigger(_kContextRoot, sTriggerAddVertex);
		if (bOnTriggerAddVertex && _PtG.length()>1)
		{
		// Get current cell connection state
			int bHasConnection1 = nIndexA > 0; // TODO what if connected to combinations?
			int bHasConnection2 = nIndexB > 0;
			
			Map mapNodes;
			if (!bHasConnection1 || !bHasConnection2)
				mapNodes = mapArgs.getMap("Node[]");
			double a = mapArgs.getDouble("Width") * .5;
			if (a <= 0)a = U(35);
			
			int nPrevNumGrip = _PtG.length();
			
			// add angled routing grips
			if (bCTAngled || nConnectionType==6)
			{ 
				_PtG.setLength(2);
				Point3d pts[] = plRoute.vertexPoints(true);
				if (pts.length()>2)	_PtG.append(pts[1]);	// angled routing
				if (pts.length()>3)_PtG.append(pts[2]);		// double angled			
			}	
			_Map.setInt("ConnectionType",5);
			
		// get vertices of current route	
			Point3d pts[0]; pts = plRoute.vertexPoints(true);	
	
	
	
		// Prompting	
			int nAppendAt, bHasDoubleConnection;
			Point3d ptLast=_PtG[0];
			if (bHasConnection1 && bHasConnection2 && pts.length()>2)
			{ 
				bHasDoubleConnection = true;
				nAppendAt = pts.length() - 2;
				ptLast =  pts[nAppendAt];	
			}
			else if (bHasConnection1 &&  pts.length()>0) 
			{
				nAppendAt = pts.length();
				ptLast = pts.last();
			}
			else if (bHasConnection2 &&  pts.length()>0) 
			{
				nAppendAt = 0;
				ptLast = pts.first();
			}
			else
				nAppendAt = 0;
			
			
			Map mapJig;
		    mapJig.setDouble("Radius",dDiameter * .5); 
		    mapJig.setVector3d("vecX",vecX);
		    mapJig.setVector3d("vecY",vecY);
		    mapJig.setVector3d("vecZ",vecZ);
			mapJig.setPoint3dArray("pts", pts);
			mapJig.setInt("appendAt", nAppendAt);
	
			String prompt = T("|Add point|");
			if (pts.length()>1)
			{ 
				prompt=T("|Add point [Start/End]|");
			}
			
			
			PrPoint ssP(prompt, ptLast);
			
		    int nGoJig = -1;
		    while (nGoJig != _kNone)
		    {	
				nGoJig = ssP.goJig(sJigEditPath, mapJig); 
		        if (nGoJig == _kOk)
		        {
		            ptLast = ssP.value(); //retrieve the selected point
		            ptLast += vecZ * vecZ.dotProduct(ptFrom - ptLast);
		            
		        // snap  
		        	int bSuccess;
		        // snap to node
					for (int i=0;i<mapNodes.length();i++) 
					{ 
						Map m= mapNodes.getMap(i);
						Point3d pt = m.getPoint3d("pt");
						Vector3d vecN= m.getVector3d("vecNormal");
						Vector3d vecP = vecN.crossProduct(-vecZ);
					
						PlaneProfile ppSnap;
						ppSnap.createRectangle(LineSeg(pt-vecP*a, pt+vecP*a+vecN*2*a), vecN, vecP);			
						{
							PLine pl(pt - vecN * (a/ tan(45)),pt + vecP * a,pt - vecP * a);
							ppSnap.joinRing(pl, _kAdd);
						}
						//{ PLine rings[] = ppSnap.allRings();	for (int r=0;r<rings.length();r++) 	{ EntPLine epl;epl.dbCreate(rings[r]);	epl.setColor(12);}}					
	
					// snap to node if point in triangle
						if (ppSnap.pointInProfile(ptLast)!=_kPointOutsideProfile)
						{
							bSuccess = true;
							Entity cell = m.getEntity("cell");
							_Entity.append(cell); // add the cell to entity when snapped to
							
							if (bHasConnection2)
							{
								_Map.setInt("nodeIndexA", m.getInt("nodeIndex"));
								_Map.setVector3d("vecN1", vecN);	
								_Map.setEntity("cell1", cell);
								mapArgs.setVector3d("vecN1", vecN);	
							}
							else if (bHasConnection1)
							{
								_Map.setInt("nodeIndexB", m.getInt("nodeIndex"));
								_Map.setVector3d("vecN2", vecN);	
								_Map.setEntity("cell2", cell);
								mapArgs.setVector3d("vecN2", vecN);	
							}						
	
							ptLast = pt;
							break;
						}
					}//next i 	            
		            
		        // add before end when double connected
		        	if (bHasDoubleConnection)
		        	{
		        		_PtG.append(ptLast);
		        		pts.insertAt(nAppendAt, ptLast);
		            	nAppendAt++ ;
		            	mapJig.setInt("appendAt", nAppendAt);	        		
		        	}
		            
		        // add a vertex at the beginning of the route    
		            else if (nAppendAt==0)
		            { 
		            	_PtG.insertAt(2, ptLast);
		            	_PtG.swap(0, 2);
		            	if (bSuccess)break;
		            	pts.insertAt(nAppendAt, ptLast);
		            }
		        // add a vertex at the end of the route   
		            else
		            { 
		            	 pts.append(ptLast);
		            	 _PtG.append(ptLast); //append the selected points to the list of grippoints _PtG
		            	 _PtG.swap(1, _PtG.length() - 1);
		            	  if (bSuccess)break;
		            	 nAppendAt++ ;
		            	 mapJig.setInt("appendAt", nAppendAt);
		            }
	//  for (int i=0;i<pts.length();i++) 
	//  { 
	//  	EntPLine epl;
	//  	epl.dbCreate(PLine(pts[i],_PtW));
	//  	epl.setColor(i);
	//   }//next i	            
		           
		            mapJig.setPoint3dArray("pts", pts);
		            mapJig.setInt("numGrip",_PtG.length());
		            ssP=PrPoint (T("|Add point [Remove point]|"), ptLast);
		        }	    		        
		    // keyword
		    	else if (nGoJig == _kKeyWord)
		    	{ 
		    		int keywordIndex = ssP.keywordIndex();
		    		if (keywordIndex==0)// Start
		    			nAppendAt = 0;
		    		else if (keywordIndex==1)// End
		    			nAppendAt = pts.length()-1;
		    			
		    		mapJig.setInt("appendAt", nAppendAt);
		    		ssP=PrPoint (T("(|Add point|"), pts[nAppendAt]);
		    	}
		    // cancel 
		        else if (nGoJig == _kCancel)
		        { 
		        	_PtG.setLength(nPrevNumGrip);
		            break;
		        }
			}// do while		
	
	
	//
			setExecutionLoops(2);
			return;
		}			
	}

	//endregion	

//region Trigger DeleteVertex
	String sTriggerDeleteVertex = T("|Delete Vertex|");
	if (_PtG.length() > 2)
	{
		addRecalcTrigger(_kContextRoot, sTriggerDeleteVertex );
		if (_bOnRecalc && _kExecuteKey == sTriggerDeleteVertex)
		{
			PrPoint ssP(T("|Select vertex|")); //second argument will set _PtBase in map
			
			Map mapJig;
			mapJig.setVector3d("vecX", vecX);
			mapJig.setVector3d("vecY", vecY);
			mapJig.setVector3d("vecZ", vecZ);
			mapJig.setDouble("Radius",dDiameter); 
			
			int nGoJig = - 1;
			while (nGoJig != _kNone && _PtG.length()>2)
			{
				nGoJig = ssP.goJig(sJigDeleteVertex, mapJig);
				if (nGoJig == _kOk)
				{
					Point3d ptPick = ssP.value();
					for (int i=0;i<_PtG.length();i++) 
					{ 
						PLine pl;
						pl.createCircle(_PtG[i], vecZ, dDiameter);
						pl.convertToLineApprox(dDiameter / 20);
						PlaneProfile pp(pl);
						if (pp.pointInProfile(ptPick)!=_kPointOutsideProfile)
						{
							_PtG.removeAt(i);
							nGoJig = _kNone;
							break;
						}

					}//next i						
				}
				
				// cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}//do while
			setExecutionLoops(2);
			return;	
		}
	}
//region Trigger Reset Path
String sTriggerResetPath = T("|Reset Path|");
if (bCTFreePath && cells.length()>1)
{ 
	addRecalcTrigger(_kContextRoot, sTriggerResetPath );
	if (_bOnRecalc && _kExecuteKey==sTriggerResetPath)
	{
		_PtG.setLength(2);	
		_Map.removeAt("ConnectionType", true);
		setExecutionLoops(2);
		return;
	}
}
//endregion		


//region Trigger FlipFace
String sTriggerFlipSide = T("|Flip Face|");
addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
{
	sFace.set(nFace==-1?sFaces[0]:sFaces[1]);
	reportMessage("\n" +nFace +" set to " + sFace);
	setExecutionLoops(2);
	return;
}		
//endregion		

// Trigger ShowHideTool
	int bShowElementTool = _Map.hasInt("ShowElementTool")?_Map.getInt("ShowElementTool"):true;
	String sTriggerShowHideTool =bShowElementTool?T("|Hide Tools|"):T("|Show Tools|");
	addRecalcTrigger(_kContextRoot, sTriggerShowHideTool);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowHideTool)
	{
		bShowElementTool = bShowElementTool ? false : true;
		_Map.setInt("ShowElementTool", bShowElementTool);		
		setExecutionLoops(2);
		return;
	}
	_ThisInst.setShowElementTools(bShowElementTool);





//	HSB-16090
//region Trigger PrintAllCommands
	String sTriggerPrintCommand2 = T("|Show all Commands for UI Creation|");
	addRecalcTrigger(_kContext, sTriggerPrintCommand2 );
	if (_bOnRecalc && _kExecuteKey==sTriggerPrintCommand2)
	{
		String text = TN("|You can create a toolbutton, a palette or a ribbon command using one of the following commands.|")+
			TN("|Copy the corresponding line starting with ^C^C below into the command property of the button definition|");	
		
		String command;
		
		command += TN("|Command to insert a new instance of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"instaConduit\")) TSLCONTENT";
		
		command += TN("\n|Command to insert a new instance of the tool with no dialog using an existing catalog entry, i.e. 'ABC123'|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"instaConduit\" \"ABC123\")) TSLCONTENT";
		
		command += TN("\n|Command to flip the face of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Flip Face|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to revert the direction of the conduit|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Flip Direction|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to reset the path of the conduit|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Reset Path|\") (_TM \"|Select conduit|\"))) TSLCONTENT";

		command += TN("\n|Command to connect the conduit centered|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Connect to Center|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
	
		command += TN("\n|Command to add a vertex to the path of the conduit|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Add Vertex|\") (_TM \"|Select conduit|\"))) TSLCONTENT";

		command += TN("\n|Command to delete a vertex from the path|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Delete Vertex|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to hide potential CNC tools|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Hide Tools|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to show potential CNC tools|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Show Tools|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to add a new strategy|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Add Strategy|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
	
		command += TN("\n|Command to edit an existing strategy|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Edit Strategy|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
	
		command += TN("\n|Command to specify the hardware of a strategy|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Set Strategy Hardware|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
	
		command += TN("\n|Command to delete an existing strategy|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Delete Strategy|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to import settings from file|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Import Settings|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		command += TN("\n|Command to export settings to file|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Export Settings|\") (_TM \"|Select conduit|\"))) TSLCONTENT";
		
		reportNotice(text +"\n\n"+ command);		
		setExecutionLoops(2);
		return;
	}//endregion






//End Trigger//endregion 

//region Publish
	_Map.setVector3d("prevLoc", _Pt0-_PtW);
	_Map.setDouble("radius", dDiameter*.5);
	_Map.setInt("AnchorMode", nAnchor);
//End Publish//endregion 


//endregion 

//Part #5 Routing, Tooling and Hardware //endregion 


//if(bDebug)reportMessage("\n"+ scriptName() + " ending " + _ThisInst.handle() + + " tick: " +getTickCount()+"\n");
































#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@``!34```/H"`(```"`FXT)````"7!(67,```[$
M```.Q`&5*PX;```@`$E$051XG.S=?W!DYUWO^4<SHU\>C;J%D[+C8+H5AXK-
MCNF>%$P"8ZI;C"#4B**[%7ZU0MWSM`E5;2I3>N0$)H20/@T5)^%"YJA([O56
MP#I:AU^UN]:14Z2\M85U!!2W:J%JCBX;BC\2Y@P7[JT0B(^,H>ZR=YG]XW$Z
MQ]UJC7YT]SFG^_WZ@]*T9C3?F+%'GWZ>\_T(`0``````HC9V]^[=J&<`````
M`&#4G8EZ````````0#X'`````"`&R.<``````$2/?`X`````0/3(YP``````
M1(]\#@````!`],CG``````!$CWP.`````$#TR.<``````$2/?`X`````0/3(
MYP``````1(]\#@````!`],CG``````!$CWP.`````$#TR.<``````$2/?`X`
M````0/3(YP``````1(]\#@````!`],CG``````!$CWP.`````$#TR.<`````
M`$2/?`X`````0/3(YP``````1(]\#@````!`],CG``````!$CWP.`````$#T
MR.<``````$2/?`X`````0/3(YP``````1(]\#@````!`],CG``````!$CWP.
M`````$#TR.<``````$2/?`X`````0/3(YP``````1(]\#@````!`],CG````
M``!$CWP.`````$#TR.<``````$2/?`X`````0/3(YP``````1(]\#@````!`
M],CG``````!$CWP.`````$#TR.<``````$2/?`X`````0/3(YP``````1(]\
M#@````!`],CG``````!$CWP.`````$#TR.<``````$2/?`X`````0/3(YP``
M````1(]\#@````!`],CG``````!$CWP.`````$#TR.<``````$2/?`X`````
M0/3.13T`T$N^[[NNZ_M^YZ?2Z70^GP]_``````#Q03['D'`<Q[*LW=W=(_[\
M3":3S6:+Q6(^GR\6B^ETNJ_C`0```,#AQN[>O1OU#,#)!4%@V[9E67?NW#G-
MU\GE<E+*<KF<S69[-!H`````'`/Y'$GE>9YE69N;F[W]LJ5222E5+!9[^V4!
M````X'#D<R2/;=NV;1]XE?WLV;,7+U[\P`<^\/:WO[WM4Y[G!4'0^N#PF_"%
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
M$@$0%_S;"(P*79;F.$[G[C?SQG7*T@``&$WGIBZ(5_\^ZBD`"$$^!T:!?L*\
M<_>;4:W(ZG*2=K^-SXBI-&5I````&$KD<V!H'5*6)E>65=U(TH'Y_\_>_<=%
M5>?[`__@;S><0=?=2D%&^Z'.8(Q[ORFH+:,;8&:7P1_EELD@_JC4RXRZ/]J*
M&:JUK9`9;K69"AR\V)J@#%?7U$H/BD+:70X"0[65AP','Q6'`5/S!]\_CDVG
M00&'8<YPSNOYV,<^9LZ<.7P&D7R?]_OS?F-8&@````!('>)S``FRV^T41147
M%WL<3YCU.\/OY^@??E"457FCWV`R4$D&])+["```````W8#X'$!J:)I.3$P4
M'E$JAA@>3S0^9>@UO=^"^I#^P63P+Y$P!P````#Y0'P.(&61$>.,3R5A6!H`
M````0.!#?`X@65,G3SSTSW?[].DE@2Z_PQR]WP````!`KA"?`TC6M:M7SIUN
M"%8,O2UXB-AKN3D,2P,`````((0@/@>0MFO7KKJX;RY\?UZA#!DP<)#8R_FY
M_L%DH(+T#Q9['0```````0'Q.8#T7?[APK?G+@P.5BH4(>*7NP?U(0.49%`(
M>K\!``````@A/@>0BPNMS9>^;Q6SW!W#T@``````;@[Q.8",\.7NWW_?JE0.
M]5^Y.S\L;=!0TG>@G[XB`````$`OA/@<0':N_'#QVW-?_R)8,40QM&?+W?OT
M)X-_B6%I``````!=@?@<0*:^;W5=_/Y\L"+DMN`>*#C'L#0`````@%N$^!Q`
MOJY=N^KBOKWP_7F%K\K=^_0G`Q1DT%`DS`$`````;A7B<P"YN^R3<O=^@\F@
MH1B6!@````#@-<3G`$"(U^7N&)8&`````.`CB,\!X+I;*W?O.Y`,&HIA:0``
M````OH+X'`!^AB]W'WS;$(5RV`W*W3$L#0````"@9R`^!X`;N'"^Y=*%[W]6
M[MZG/QD40@8HT?L-`````*`G(#X'@!MSE[LK?SVJ_Y#;,2P-`````*!'(0\&
M`!VY_,/%BS]<17`.```@5?T'HYL,0*!`?`X`````(%]]^J*B%B!0(#X'````
M````$!_B<P````````#Q(3X'````````$!_B<P````````#Q(3X'````````
M$!_B<P````````#Q(3X'````````$!_B<P````````#Q(3X'@$[T&S!8["4`
M`````$@?XG,`Z$1?Q.<``````#T/\3D```````"`^!"?`P```````(@/\3D`
M``````"`^!"?`P```````(@/\3D```````"`^!"?`P```````(@/\3D`````
M``"`^!"?`P```````(@/\3D```````"`^!"?`P````#(5U#?_F(O`0"N0WP.
M`````"!?_0<-$7L)`'`=XG,`````````\2$^!P```````!`?XG,`````````
M\2$^!P```````!`?XG,`````````\2$^!P```````!`?XG,`````````\2$^
M!P```````!`?XG,`````````\2$^!P```````!`?XG,`````````\2$^!P``
M`````!`?XG,`@!M(2$A0J50W>Y5EV>>>>RXL+$RCT3S__/-^7!<`````2!;B
M<P"`&[#;[3>,SW?NW/GPPP_/FC5KR)`A'WWT45Y>7G-S<UA8V($#!_R^1@``
M``"0%,3G``"=XS@N(R-#H]'DY^<O6[;,;K?/F3.'$*)0*%:M6K5ERY977GEE
MZM2I)T^>%'NE`````-!;]1-[`0```8VFZ4V;-I64E"0E)>7EY2D4BO;GC!PY
M\JVWWCIV[-C##S_\P`,///OLLQW4Q@,`````W!#B<P"`&^`X;L>.'5:K]=Y[
M[YTS9X[9;.[*N^ZYYYZ"@H+!@P=;K=:@H*">7B0`````2`GB<P#HQ(#;AHF]
M!+_B>[\Q##-CQ@R*HFZ8,!=RN5P??OCAIDV;E$JEP6"8.'&B?]8)`````!*#
M^!P`X+KL[.R<G)S;;KM-K]=W)6'>V-CXQAMO'#]^/#(R,B\O;]JT:800B\72
MXPL%`````"E"?`X`<L>R;$9&1G%Q\8P9,UY^^>61(T=V^I:=.W=NW[Z]J:GI
M\<<?W[ESIQ\6"0````"2A_@<`.1KY\Z=V=G9WW[[K5ZO_^BCCSH]O[&Q<>?.
MG=NV;=-H-/_]W__-)\P!``!ZN[[]!U^]?$'L50``XG,`D!]^6%I14='8L6.7
M+5LV?OSX3M_RX8<?%A86?OKIIPD)"6?/GD7O-P``D)*^`Q"?`P0$Q.<`("/N
M86DK5ZZ\V;`T(9?+5514].Z[[PX?/GSMVK6//?:8?]8)`````#*$^!P`Y.+I
MIY]^__WW'WOLL0,'#G1Z\K%CQPH*"@X=.A0;&WOPX$',,P<```"`GH;X'`#D
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
M><=Q1#'XCLS7$R>,^YT]GY>5[\\S;'69E":$F!`T/C(RDDEI`-S4@9*_6+[_
M5NHJ```]Y9&G$J0NX2J1SX&^KM,!;`\^/.5=[093U6'G,SW[]W_LL=#$9(BF
M```6+TE$0524Y)3_&CZBU\L$````KG/D<P!"")&<G)R2DM+5IXHA@U]Y>:ER
MUIQ;;[N]-ZL"@)Y0^^7G+3:KU%4``'K*_[OW0:E+N$KD<P#M/O_\<XU&\]%'
M'SD??/RQ:<\O7A02^IA450%`M_ORX,<_O^'\SW]^H]2%``"ZW[?_.3'FX7"I
MJ[A*_:0N`(!<C!X]>L^>/9F9F2DI*6UM;1J-1J52^?KZ2ET7`'2_6P<-Z'_+
MS5)7`0#H?M_^YX34)5P]\CF`B]ACN6-&.@```(#>P?QS`*X(YP```$#O(Y\#
M`````"`]\CD``````-(CGP,`````(#WR.0``````TB.?`P`````@/?(Y````
M``#2(Y\#`````"`]\CD``````-(CGP,`````(#WR.0``````TB.?`P`````@
M/?(Y``````#2(Y\#`````"`]\CD``````-(CGP,`````(#WR.0``````TB.?
M`P`````@/?(Y``````#2(Y\#`````""]?E(7````T-M^.-G0V&23N@H``"Y"
M/@<``'W+K;_V.=U".$=?\7+2_[R1\HK450"]YS=#!TI=PM4CGP,`@+[EUM_X
M2ET"T'N^.O+-X&$!4E<!X(KP_#D``````-(CGP,`````(#WR.0``````TB.?
M`P`````@/?(Y``````#2(Y\#`````"`]\CD``````-(CGP,`````(#WR.0``
M````TB.?`P`````@/?(Y``````#2(Y\#`````"`]\CD``````-(CGP,`````
M(#WR.0``````TB.?`P`````@/?(Y``````#2(Y\#`````"`]\CD``````-(C
MGP,`````(#WR.0``````TB.?`P`````@/?(Y``````#2(Y\#`````"`]\CD`
M`````-(CGP,`````(#WR.0``````TB.?`P`````@/?(Y``````#2(Y\#````
M`"`]\CD``````-(CGP,`````(#WR.0``````TB.?`P`````@/?(Y``````#2
M(Y\#`````"`]\CD``````-(CGP,`````(#WR.0``````TB.?`P`````@/?(Y
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
A`)0>^1P`````@-+[/X>)_K-M9ELF`````$E%3D2N0F""







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
        <int nm="BreakPoint" vl="3727" />
        <int nm="BreakPoint" vl="3370" />
        <int nm="BreakPoint" vl="3082" />
        <int nm="BreakPoint" vl="2614" />
        <int nm="BreakPoint" vl="1812" />
        <int nm="BreakPoint" vl="289" />
        <int nm="BreakPoint" vl="3377" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl=" HSB-16090 centered anchoring of combination supported, new property to toggle available anchor node" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="9/6/2022 3:42:24 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16089 new command to list all available commands in report dialog" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/6/2022 10:17:09 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16090 snapping to center of combinations improved" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="8/4/2022 9:53:01 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16090 snapping accepts also center of combination" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="7/29/2022 2:27:18 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16095 segemented drills fixed when based on strategy and not connected to bottom or top side" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="7/26/2022 2:09:47 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14382 bugfix default strategy, drill support when conduits connects straight to edge in grip mode" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="3/18/2022 12:41:04 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14469 bugfix support drill tools in floor elements" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="1/21/2022 12:45:06 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14061 hardware supports strategies with multiple components" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="12/15/2021 4:50:36 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14161 bugfixes flip direction, jig on loose conduits" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="12/15/2021 2:27:06 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14130 bugfix selection loose genbeams" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/10/2021 3:24:36 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14061 multiple hardware entries, adding and deleting of entries supported through standard hardware dialog" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12/6/2021 9:13:28 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13729 new settings to control genbeam and combination offsets, solids not facetted" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/1/2021 5:24:45 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13729 strategies extended" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/29/2021 5:21:53 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13729 new property 'strategy', new commands added to add/edit/delete a strategy and to import/export settings" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="11/24/2021 5:11:09 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13203 supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property  , Author Thorsten Huck" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="9/30/2021 4:35:48 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13129 jigging with top or bottom edge direction improved" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/17/2021 2:44:58 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13129 conduit supports rule based insertion" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="9/16/2021 5:03:15 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12825 conduit supports standalone insertion, new command to extend single segmented standalone instances" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="8/20/2021 2:24:26 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12639 new properties to specify a lateral offset of the conduit start and end point" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="7/20/2021 11:48:06 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12621 (3) additional group assignment supported" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="7/20/2021 8:50:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12621 for log walls conduit drills are supported when connecting two vertical cells" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="7/19/2021 5:04:42 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12285 polygonal conduits supported for log walls" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/28/2021 12:56:44 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12285 polygonal conduits supported fro SF Walls" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/25/2021 4:34:46 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11654 a new property 'Zone' has been added to support placement in elements with multiple zones" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="4/22/2021 10:18:36 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11413 Debug graphics removed" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="3/31/2021 9:29:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11413 sharp edges of tool path if radius = 0, HSB-11412 new commands Add/Remove vertex to manipulate tool path" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="3/30/2021 5:17:45 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11397 new property 'Radius Contour' to specify the radius polygonal tool path's, OSnap track refers to last vertex" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="3/29/2021 3:57:12 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11239 free path and preview jigs enhanced" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="3/19/2021 5:01:19 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End