#Version 8
#BeginDescription
 #Versions
Version 1.1 19.05.2021 HSB-11919 Turning direction and overshoot added for saw and milling (also as abbreviation) , Author Thorsten Huck
Version 1.0    19.05.2021    HSB-11919 initial version , Author Thorsten Huck

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 19.05.2021 HSB-11919 Turning direction and overshoot added for saw and milling (also as abbreviation) , Author Thorsten Huck
// 1.0 19.05.2021 HSB-11919 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select viewport or element
/// </insert>

// <summary Lang=en>
// This tsl creates tags of element tools such as element saw, element mill, element drill and nailing lines.
// Although it is mainly designed to work with hsbcad viewports in paperspace you may attach it in model or as plugin tsl
// One 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ElementToolTag")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select element tool tag entity|"))) TSLCONTENT
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
	
	String sSides[] = { T("|Left|"), T("|Center|"), T("|Right|")};
	String sTurnings[] = { T("|Against course|"), T("|With Course|")}; // gegenlauf, gleichlauf
	String sShortTurnings[] = { T("|CCW|"), T("|CW|")}; // gegenlauf, gleichlauf	
	double dTextOffsetFactor = .75;
//end Constants//endregion

//region Properties
	String sZoneName=T("|Zone|");	
	PropInt nZone;
	if (_Element.length()>0)
	{ 
		int zones[0];
		Element el = _Element[0];
		for (int z=-5;z<6;z++) 
			if (el.zone(z).dH()>dEps)
				zones.append(z);
		nZone=PropInt(nIntIndex++, zones, sZoneName);
		if (zones.find(nZone) < 0)nZone.set(0);
	}
	else
		nZone=PropInt(nIntIndex++, 0, sZoneName);	
	nZone.setDescription(T("|Defines the Zone|")+ T(", |0 = all zones|"));
	nZone.setCategory(category);

	String sToolName=T("|Tool|");	
	String sTools[] ={T("|Saw Line|"), T("|Milling Line|"), T("|Element Drill|"), T("|Nailing Line|")};
	PropString sTool(nStringIndex++, sTools.sorted(), sToolName);	
	sTool.setDescription(T("|Defines the Tool|"));
	sTool.setCategory(category);
	
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|")+ T("|Empty = default format|"));
	sFormat.setCategory(category);

category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|, ") + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 0, sColorName);	
	nColor.setDescription(T("|Defines the Color|")+ T(", |0 = byZone|") + T(", |-1 = byToolindex|"));
	nColor.setCategory(category);

	String sLayerName=T("|Layer|");	
	String sLayers[] ={ "I", "T", "E", "C", "J"};
	char cLayers[] ={ 'I', 'T', 'E', 'C', 'J'};
	PropString sLayer(nStringIndex++, sLayers.sorted(), sLayerName,2);	
	sLayer.setDescription(T("|Defines the sublayer|"));
	sLayer.setCategory(category);
	int nLayer = sLayers.find(sLayer);
	
	
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
		
	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		if (!bInLayoutTab)viewEnts= Group().collectEntities(true, ShopDrawView(), _kMySpace);

	// distinguish selection mode bySpace
		if (viewEnts.length()>0)
			_Entity.append(getShopDrawView());	
	
	// distinguish selection mode bySpace
		if (viewEnts.length()>0)
			_Entity.append(getShopDrawView());
	// switch to paperspace succeeded: paperspace with viewports
		if (_Entity.length()<1)
		{ 
		// Prerequisites to create TSL with catalog
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = sLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};			
			
			int bHasSection;
			
		// paperspace get viewPort
			if (bInLayoutTab)
			{
				_Viewport.append(getViewport(T("|Select a viewport|")));	

			// prompt for entity selection if not an element viewport	
				Element el;
				if(_Viewport.length()>0 && !_Viewport[0].element().bIsValid())
				{
					int bSuccess = Viewport().switchToModelSpace();
					if (bSuccess)
					{ 
					// prompt for entities
						PrEntity ssE(T("|Select elements|"), Element());
						if (ssE.go())
						{
							_Element.append(ssE.elementSet());
						}
						bSuccess = Viewport().switchToPaperSpace();	
					}
				}
				else
					el = _Viewport[0].element();

				_Pt0 = getPoint(T("|Pick insertion point|"));
			}
		
		// modelspace: get Section2d or element
			else
			{
			// prompt for entities
				Entity ents[0];
				PrEntity ssE(T("|Select elements or sections|"), Section2d());
				ssE.addAllowedClass(Element());
				ssE.addAllowedClass(GenBeam());
				if (ssE.go())
					ents.append(ssE.set());	

			// create per entity
				for (int i=0;i<ents.length();i++) 
				{ 
					Element el = (Element)ents[i];
					GenBeam gb= (GenBeam)ents[i];
					Section2d section = (Section2d)ents[i];
					
					if (el.bIsValid() && _Element.find(el)<0)
						_Element.append(el);
					else if (gb.bIsValid())
					{ 
						el = gb.element();
						if (el.bIsValid() && _Element.find(el)<0)
							_Element.append(el);
					}						
					else if (section.bIsValid())
					{ 
						bHasSection = true;
						ptsTsl.setLength(0);
						ptsTsl.append(section.coordSys().ptOrg());
						entsTsl.setLength(0);
						entsTsl.append(section);
						tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);	 
					} 
				}//next i				
	
			}
		
		//region Create per element
			if (_Element.length()>0)
			{ 
				// Prerequisites to create TSL with properties
					TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
					int nProps[]={0, nColor};			double dProps[]={dTextHeight};				String sProps[]={sTool, sDimStyle,sLayer};
					Map mapTsl;	

				for (int i=0;i<_Element.length();i++) 
				{ 
					Element el = _Element[i];
					entsTsl[0] = el;
					int zones[0];
					if (nZone==0)
					{ 
						for (int z=-5;z<6;z++) 
							if (z!= 0 && el.zone(z).dH()>dEps)
								zones.append(z);
					}
					else
						zones.append(nZone);
					
					for (int z=0;z<zones.length();z++) 
					{ 
						nProps[0] = zones[z];
						ptsTsl[0] = el.zone(z).ptOrg();
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	 
					}//next z
 
				}//next i	
				eraseInstance();
				return;
			}
					
		//End Create per element//endregion 
			if (bHasSection)
			{ 
				eraseInstance();
				return;				
			}
		
		}
		else 
			_Pt0 = getPoint(T("|Pick insertion point|"));
		return;
	}	
// end on insert	__________________//endregion

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

//region Standards
	// on creation
	if (_bOnDbCreated)setExecutionLoops(2);
	//if (nSequence > 0)_ThisInst.setSequenceNumber(nSequence);
	//_ThisInst.setSequenceNumber(500);
	
// some variables
	double dXVp, dYVp; // X/Y of viewport/shopdrawviewport
	Point3d ptCenVp=_Pt0;
	int nActiveZoneIndex = 99;
	int nc = _ThisInst.color();	
	
	Point3d ptDatum = _Pt0;
	Element elements[0];
	elements = _Element;
	CoordSys ms2ps, ps2ms;
	CoordSys csW(_PtW, _XW, _YW, _ZW);
	PlaneProfile ppView(csW);
	Entity entTags[0];
	

//End Standards//endregion 	

//region Viewport or Model
// Get viewport data
	Viewport vp;
	int bIsAcaViewport, bPaperspace;
	double dScale = 1;
	if (_Viewport.length()>0)
	{ 
		bPaperspace = true;
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Map.setString("ViewHandle", vp);
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	
		dXVp = vp.widthPS();
		dYVp = vp.heightPS();
		ptCenVp= vp.ptCenPS();	
		dScale = vp.dScale();
		
		
		ppView.createRectangle(LineSeg(ptCenVp - .5 * (_XW * dXVp + _YW * dYVp), ptCenVp + .5 * (_XW * dXVp + _YW * dYVp)), _XW, _YW);

	// HSBCAD Viewport
		Element el = vp.element();
		if (el.bIsValid())
		{ 
			elements.append(el);
			ptDatum = el.ptOrg();
			nActiveZoneIndex = vp.activeZoneIndex();
			
			if (nZone!=nActiveZoneIndex)
			{ 
				nZone.set(nActiveZoneIndex);	
			}
			nZone.setReadOnly(_kHidden);
		}
	// ACA Viewport	
		else
		{
			for (int i=0;i<_Entity.length();i++) 
			{ 
				Element el = (Element)_Entity[i]; 
				if (el.bIsValid())
				{ 
					elements.append(el);
					setDependencyOnEntity(el);
				}
				 
			}//next i
			bIsAcaViewport = true;
		}
		entTags= Group().collectEntities(true, TslInst(), _kMySpace);
		
	// make sure it is assigned to layer 0 on creation
		if (_bOnDbCreated) assignToLayer("0");		
	}
// Get scale if not viewport
	else	
	{ 
		if (elements.length()<1)
		{ 
			eraseInstance();
			return;
		}
		else 
			assignToElementGroup(elements.first(), true, nZone, cLayers[nLayer] );
		_ThisInst.setAllowGripAtPt0(false);
		
		
		
		
		Vector3d vecScale(1, 0, 0);
		vecScale.transformBy(ps2ms);
		dScale = vecScale.length();	
		
	}		
//End Viewport or Model//endregion 
	
//region Displays
	Display dp(nColor), dpInfo(nColor);
	dp.dimStyle(sDimStyle);
	dpInfo.dimStyle(sDimStyle);
	double textHeight = dTextHeight * dScale;
	if (textHeight==0)
		textHeight = dp.textHeightForStyle("O", sDimStyle)*dScale;
	dp.textHeight(textHeight);	
	dpInfo.textHeight(textHeight);		
//End Display//endregion 	
	
//region Collect tools
	int nTool = sTools.find(sTool);
	int cnt;
	String format = sFormat;
	Map mapAdditionals;
	
	for (int i=0;i<elements.length();i++) 
	{ 
		
	//region Element and zones				
		Element el= elements[i]; 
		CoordSys cs = el.coordSys();
		int zones[0];
		if (nZone==0) // all zones
		{ 
			for (int z=-5;z<6;z++) 
				if (z!= 0 && el.zone(z).dH()>dEps)
					zones.append(z);
		}
		else
			zones.append(nZone);
	//End Element and zones//endregion 		
	
// This is only releavnt if collision testing is required	
//	//region Collect zone profiles
//		Plane pnZ(el.ptOrg(), el.vecZ());
//		PlaneProfile pps[0]; int indices[0];
//		for (int z=0;z<zones.length();z++) 
//		{ 
//			int zone = zones[z];
//			PlaneProfile pp(cs);
//			GenBeam gbs[] = el.genBeam(zone);
//			for (int j=0;j<gbs.length();j++) 
//			{ 
//				if (gbs[j].bIsDummy())continue;
//				PlaneProfile _pp = gbs[j].envelopeBody(false,true).shadowProfile(pnZ);
//				_pp.shrink(-dEps);
//				pp.unionWith(_pp);
//				
//			}//next j
//			pp.shrink(dEps);
//			if (pp.area()>pow(dEps,2))
//			{ 
//				pp.transformBy(ms2ps);
//				pps.append(pp);
//				indices.append(zone);
//			}		 
//		}//next z			
//	//End Collect zone profiles//endregion 

	// PS transformation
		cs.transformBy(ms2ps);
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();

	// Tools
		
	// ElemSaw
		if (nTool == 0)
		{
			if (sFormat.length() == 0)format = "@(Depth) - @(ToolIndex)";
			ElemSaw saws[] = el.getToolsOfTypeSaw();

			for (int j=saws.length()-1; j>=0 ; j--) 
			{ 
			// tool properties	
				ElemSaw t=saws[j]; 
				int zoneIndex = t.zoneIndex();
				if (zones.find(zoneIndex) < 0)continue;
				double depth = t.depth();
				int nSide;
				if (t.sideIsLeft())nSide = -1;
				else if (t.sideIsRight())nSide=1;
				if (t.sideIsCenter())nSide=0;			
				String side = nSide>-1?sSides[nSide+1]:"";

				PLine plShape = t.plShape();
				plShape.transformBy(ms2ps);


				ElemZone zone = el.zone(zoneIndex);
				Vector3d vecXZone = vecX * (zoneIndex < 0 ?- 1 : 1);
				Vector3d vecZT = zone.vecZ();
				vecZT.transformBy(ms2ps);vecZT.normalize();	
				
				Point3d ptMid = plShape.ptMid();
				Vector3d vecXT = plShape.getPointAtDist(plShape.getDistAtPoint(ptMid) + dEps) - ptMid; vecXT.normalize();
				Vector3d vecYT = vecXT.crossProduct(-vecZT);

				Map m;
				m.setDouble("Depth", depth);
				m.setDouble("Angle", t.angle());
				m.setInt("ZoneIndex", t.zoneIndex());
				m.setString("Vacuum", sNoYes[t.vacuum()]);
				m.setString("Overshoot", sNoYes[t.overShoot()]);
				m.setString("Abbreviation Overshoot", t.overShoot()?"<>":"><");
				m.setString("Turning Direction", sTurnings[t.turningDirectionWith()]);	
				m.setString("Abbreviation Turning Direction", sShortTurnings[t.turningDirectionWith()]);
				
				m.setInt("Toolindex", t.toolIndex());
				m.setDouble("Length", plShape.length());
				m.setString("Side", side);				
				mapAdditionals = m;
				
				PLine pl2 = plShape;
				plShape.offset(U(1), true);
				pl2.offset(-U(1), true);
				pl2.reverse();
				Point3d pts[] = pl2.vertexPoints(true);
				for (int p=0;p<pts.length();p++) 
					plShape.addVertex(pts[p]); 
				plShape.close();
				plShape.transformBy(ms2ps);
				plShape.vis(j);

				String text = el.formatObject(format, m);
				
//			// get zone profile	
//				Vector3d vecSide = vecYT;
//				PlaneProfile pp;
//				int index = indices.find(zoneIndex);
//				if (index>-1)
//				{ 
//					pp = pps[index];					
//					if(pp.pointInProfile(ptMid+vecYT*dEps)==_kPointInProfile)
//						vecSide *= -1;	
//				}
//				pp.vis(3);
				int flip = nSide == -1 ?- 1 : 1;
				Point3d ptTxt = ptMid+flip*vecYT*textHeight*dTextOffsetFactor;			
				if (bPaperspace)ptTxt.setZ(0);


				if (nColor == 0)dp.color(zone.color());
				else if (nColor <0)dp.color(t.toolIndex());
				dp.elemZone(el, zoneIndex, cLayers[nLayer]);				
				Vector3d vecXRead = vecXT;
				if (vecXRead.isCodirectionalTo(-vecY)|| vecXT.dotProduct(vecXZone)<0) vecXRead *= -1;							
				dp.draw(text, ptTxt, vecXRead, vecXRead.crossProduct(-vecZT), 0, 0,_kDevice);
				
				cnt++;
			}//next j

		}
	// ElemMill	
		else if (nTool == 1)
		{
			if (sFormat.length() == 0)format = "@(Depth) - @(ToolIndex)";
			ElemMill mills[] = el.getToolsOfTypeMill();

			for (int j=mills.length()-1; j>=0 ; j--) 
			{ 
			// tool properties	
				ElemMill t=mills[j]; 
				int zoneIndex = t.zoneIndex();
				if (zones.find(zoneIndex) < 0)continue;
				double depth = t.depth();
				int nSide;
				if (t.sideIsLeft())nSide = -1;
				else if (t.sideIsRight())nSide=1;
				if (t.sideIsCenter())nSide=0;			
				String side = nSide>-1?sSides[nSide+1]:"";

				PLine plShape = t.plShape();
				plShape.convertToLineApprox(U(10));
				plShape.transformBy(ms2ps);


				ElemZone zone = el.zone(zoneIndex);
				Vector3d vecXZone = vecX * (zoneIndex < 0 ?- 1 : 1);
				Vector3d vecZT = zone.vecZ();
				vecZT.transformBy(ms2ps);vecZT.normalize();	
				
				Point3d ptMid = plShape.ptMid();
				Point3d pts[] = plShape.vertexPoints(true);
				if (pts.length()>2) ptMid = (pts[0] + pts[1]) * .5; // make sure mid point is mid of a segment
				Vector3d vecXT = plShape.getPointAtDist(plShape.getDistAtPoint(ptMid) + dEps) - ptMid; vecXT.normalize();
				if (vecXT.isCodirectionalTo(-vecY) || vecXT.dotProduct(vecXZone)<0)vecXT *= -1;
				Vector3d vecYT = vecXT.crossProduct(-vecZT);

				Map m;
				m.setDouble("Depth", depth);
				//m.setDouble("Angle", t.angle());
				m.setInt("ZoneIndex", t.zoneIndex());
				m.setString("Vacuum", sNoYes[t.vacuum()]);
				m.setString("Overshoot", sNoYes[t.overShoot()]);
				m.setString("Abbreviation Overshoot", t.overShoot()?"<>":"><");
				m.setString("Turning Direction", sTurnings[t.turningDirectionWith()]);
				m.setString("Abbreviation Turning Direction", sShortTurnings[t.turningDirectionWith()]);
				m.setInt("Toolindex", t.toolIndex());
				m.setDouble("Length", plShape.length());
				m.setString("Side", side);				
				mapAdditionals = m;
								
//				PLine pl2 = plShape;
//				plShape.offset(U(1), true);
//				pl2.offset(-U(1), true);
//				pl2.reverse();
//				pts = pl2.vertexPoints(true);
//				for (int p=0;p<pts.length();p++) 
//					plShape.addVertex(pts[p]); 
//				plShape.close();
				//plShape.transformBy(ms2ps);
				plShape.vis(j);
				String text = el.formatObject(format, m);
				
//			// get zone profile	
//				Vector3d vecSide = vecYT;
//				PlaneProfile pp;
//				int index = indices.find(zoneIndex);
//				if (index>-1)
//				{ 
//					pp = pps[index];					
//					if(pp.pointInProfile(ptMid+vecYT*dEps)==_kPointInProfile)
//						vecSide *= -1;	
//				}
//				pp.vis(3);
				int flip = nSide == -1 ?- 1 : 1;
				Point3d ptTxt = ptMid+flip*vecYT*textHeight*dTextOffsetFactor;			
				if (bPaperspace)ptTxt.setZ(0);

				if (nColor == 0)dp.color(zone.color());
				else if (nColor <0)dp.color(t.toolIndex());
				
				dp.elemZone(el, zoneIndex, cLayers[nLayer]);				
				Vector3d vecXRead = vecXT;
				if (vecXRead.isCodirectionalTo(-vecY)|| vecXT.dotProduct(vecXZone)<0) vecXRead *= -1;							
				dp.draw(text, ptTxt, vecXRead, vecXRead.crossProduct(-vecZT), 0, 0,_kDevice);
				
				cnt++;
			}//next j


		}
	// ElemDrill	
		else if (nTool == 2)
		{
			if (sFormat.length() == 0)format = "ø@(Diameter)\P@(Depth)";
			ElemDrill drills[] = el.getToolsOfTypeDrill();
			
			for (int j = drills.length() - 1; j >= 0; j--)
			{
				// tool properties	
				ElemDrill t = drills[j];
				int zoneIndex = t.zoneIndex();
				if (zones.find(zoneIndex) < 0)continue;
				ElemZone zone = el.zone(zoneIndex);
				
				Point3d ptMid = t.location();

				PLine plShape; plShape.createCircle(ptMid, zone.vecZ(), t.diameter());
				plShape.transformBy(ms2ps);
				ptMid.transformBy(ms2ps);

				
				Vector3d vecXZone = vecX * (zoneIndex < 0 ?- 1 : 1);
				Vector3d vecZT = zone.vecZ();
				vecZT.transformBy(ms2ps);vecZT.normalize();
				
				Vector3d vecXT = vecXZone;
				Vector3d vecYT = vecXT.crossProduct(-vecZT);
	
				Map m;
				m.setInt("ZoneIndex", t.zoneIndex());
				m.setInt("Toolindex", t.toolIndex());
				m.setDouble("Diameter", t.diameter());
				m.setDouble("Depth", t.depth());
				mapAdditionals = m;

				String text = el.formatObject(format, m);
				Point3d ptTxt = ptMid;			
				if (bPaperspace)ptTxt.setZ(0);

				if (nColor == 0)dp.color(zone.color());
				else if (nColor <0)dp.color(t.toolIndex());
				dp.elemZone(el, zoneIndex, cLayers[nLayer]);
				dp.draw(text, ptTxt, vecXT, vecYT, 0, 0,_kDevice);
				
				cnt++;	
	
			}// next j of drills
		}		
	// ElemNail	
		else if (nTool == 3)
		{
			if (sFormat.length() == 0)format = "<-> @(Spacing) - @(ToolIndex)";
			ElemNail nails[] = el.getToolsOfTypeNail();

			for (int j=nails.length()-1; j>=0 ; j--) 
			{ 
			// tool properties	
				ElemNail t=nails[j]; 
				int zoneIndex = t.zoneIndex();
				if (zones.find(zoneIndex) < 0)continue;

				PLine plShape = t.plShape();
				plShape.transformBy(ms2ps);

				ElemZone zone = el.zone(zoneIndex);
				Vector3d vecXZone = vecX * (zoneIndex < 0 ?- 1 : 1);
				Vector3d vecZT = zone.vecZ();
				vecZT.transformBy(ms2ps);vecZT.normalize();	
				
				Point3d ptMid = plShape.ptMid();
				Point3d pts[] = plShape.vertexPoints(true);
				if (pts.length()>2) ptMid = (pts[0] + pts[1]) * .5; // make sure mid point is mid of a segment
				Vector3d vecXT = plShape.getPointAtDist(plShape.getDistAtPoint(ptMid) + dEps) - ptMid; vecXT.normalize();
				if (vecXT.isCodirectionalTo(-vecY) || vecXT.dotProduct(vecXZone)<0)vecXT *= -1;
				Vector3d vecYT = vecXT.crossProduct(-vecZT);

				Map m;
				//m.setDouble("Angle", t.angle());
				m.setInt("ZoneIndex", t.zoneIndex());
				m.setInt("Toolindex", t.toolIndex());
				m.setDouble("Length", plShape.length());
				m.setDouble("Spacing", t.spacing());
				mapAdditionals = m;


				String text = el.formatObject(format, m);
				
			// get zone profile	
				Vector3d vecSide = vecYT;
				Point3d ptTxt = ptMid+vecSide*textHeight;			
				if (bPaperspace)ptTxt.setZ(0);

				if (nColor == 0)dp.color(zone.color());
				else if (nColor <0)dp.color(t.toolIndex());
				dp.elemZone(el, zoneIndex, cLayers[nLayer]);
				dp.draw(text, ptTxt, vecXT, vecYT, 0, 0,_kDevice);
				
				cnt++;
			}//next j



		}			
	}//next i
	

//End Collect tools//endregion 	
	
//region Paperspace Info
	if (bPaperspace)
	{ 
		Display dp;
		String text = scriptName();
		text += "\P" + T("|Zone|: ") + nZone;
		text += "\P" + T("|Tool|: ") + sTool + " ("+cnt+ ")";
		text += "\P" + sFormatName + ": "+format;
		dpInfo.draw(text, _Pt0, _XW, _YW, 1, -1);
	}
	else if (cnt<1)
	{ 
		reportMessage("\n"+ scriptName() + T("|No tools found| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
//End Paperspace Info//endregion 

//region Trigger AddRemoveFormat
	String sObjectVariables[0]; 
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

	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
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
			if (mapAdditionals.hasInt(key))
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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11919 Turning direction and overshoot added for saw and milling (also as abbreviation)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/19/2021 12:40:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11919 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/19/2021 10:26:51 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End