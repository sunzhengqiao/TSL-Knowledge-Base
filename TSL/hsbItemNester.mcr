#Version 8
#BeginDescription
version value="1.2" date="20sep2019" author="thorsten.huck@hsbcad.com"
HSB-5633 isotropic nesting enabled
sip nesting functions and properties added, supports settings

This tsl creates pline based nestings from tsl based items
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Nesting;Nester;Child
#BeginContents
/// <History>//region
/// <version value="1.2" date="20sep2019" author="thorsten.huck@hsbcad.com"> HSB-5633 isotropic nesting enabled </version>
/// <version value="1.1" date="09apr2019" author="thorsten.huck@hsbcad.com"> sip nesting functions and properties added, supports settings </version>
/// <version value="1.0" date="12sep2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select item clones and select location
/// </insert>

/// <summary Lang=en>
/// This tsl creates pline based nestings from tsl based items
/// </summary>//endregion

/// commands
/// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbItemNester")) TSLCONTENT


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

// family key words
	String sItemX = "Hsb_ItemClone";	
	double dNextColumnDist = U(1000);

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbItemClone";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Read Settings
	int nc=_ThisInst.color(), ncGrain=nc, ncText=nc;
	double dXMax, dYMax, dLineTypeScale, _dTextHeight;
	String sLineType,_sDimStyle;
{
	String k;
	Map m;

	k="Nesting\\Display\\Contour";		if (mapSetting.hasMap(k))	m = mapSetting.getMap(k);
	k="LineTypeScale";		if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
	k="LineType";		if (m.hasString(k))	sLineType = m.getString(k);
	k="Color";			if (m.hasInt(k))	nc = m.getInt(k);

	k="Nesting\\Display\\GrainDirection";		if (mapSetting.hasMap(k))	m = mapSetting.getMap(k);
	k="Color";			if (m.hasInt(k))	ncGrain = m.getInt(k);

	k="Nesting\\Display\\Text";		if (mapSetting.hasMap(k))	m = mapSetting.getMap(k);
	k="Color";			if (m.hasInt(k))	ncText = m.getInt(k);
	k="DimStyle";		if (m.hasString(k))	_sDimStyle = m.getString(k);
	k="TextHeight";		if (m.hasDouble(k))	_dTextHeight = m.getDouble(k);

	k="Nesting\\MaxDimension";		if (mapSetting.hasMap(k))	m = mapSetting.getMap(k);
	k="X";		if (m.hasDouble(k))	dXMax = m.getDouble(k);
	k="Y";		if (m.hasDouble(k))	dYMax = m.getDouble(k);

}
//End Read Settings//endregion 


	category = T("|Master|");	
	String sGrainDirections[] ={ T("|Lengthwise|"), T("|Crosswise|"), T("|Isotropic|")};
	String sGrainDirectionName=T("|Grain Direction|");	
	PropString sGrainDirection(2, sGrainDirections, sGrainDirectionName);	
	sGrainDirection.setDescription(T("|Defines the GrainDirection|"));
	sGrainDirection.setCategory(category);

	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(5000), sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(2000), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);	
	
	String sOversizeName=T("|Oversize Format Cut|");
	PropDouble dOversize(nDoubleIndex++, U(0), sOversizeName);	
	dOversize.setDescription(T("|Defines the outer offset of the raw master.|"));
	dOversize.setCategory(category);
	
	String sFaceAlignmentName=T("|Top Face Alignment|");	
	String sFaceAlignments[] = {T("|Unchanged|"), T("|Higher Quality|"), T("|Lower Quality|")};
	PropString sFaceAlignment(3, sFaceAlignments, sFaceAlignmentName,1);						// 6
	sFaceAlignment.setDescription(T("|Defines the alignment of the child panel|"));
	sFaceAlignment.setCategory(category);

	
	category = T("|Item|");
	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);	
	dGap.setDescription(T("|Defines the gap between individual items|"));
	dGap.setCategory(category);
	
// Display
	category = T("|Display|");	
// Format
	String sAttributeName=T("|Format|");	
	PropString sAttribute(1, "|Project| @(ProjectName)\\P@(ProjectName)", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by|") + " '\P'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);	
	
	
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(0, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	if (_DimStyles.find(_sDimStyle)>-1) // if defined in settings use the value as readonly
	{ 
		sDimStyle.setReadOnly(true);
		if (sDimStyle != _sDimStyle)sDimStyle.set(_sDimStyle);
	}
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Overrides the Text Height|") + T(" |0 = by dimstyle|"));			
	if (_dTextHeight>0) // if defined in settings use the value as readonly
	{ 
		dTextHeight.setReadOnly(true);
		if (dTextHeight != _dTextHeight)dTextHeight.set(_dTextHeight);
		dTextHeight.setDescription(T("|Specifies the text height|"));
	}	
	else
		dTextHeight.setDescription(T("|Overrides the Text Height|") + T(" |0 = by dimstyle|"));
	dTextHeight.setCategory(category);		


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
		
	// prompt for references
		Entity ents[0];
		PrEntity ssE(T("|Select item clone(s)|"), TslInst());
		// or any referenced entity (sheets, panels or item(s)) + " " + T("|<Enter> to create new master board|")
//		ssE.addAllowedClass(Sheet());
//		ssE.addAllowedClass(Sip());
//		ssE.addAllowedClass(ChildPanel());		
		if (ssE.go())
			ents = ssE.set();
		
	// purge invalid tsls
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl = (TslInst)ents[i]; 
			if (tsl.bIsValid() && tsl.subMapXKeys().find(sItemX)<0)
				ents.removeAt(i);
			
		}//next i
				
		_Entity.append(ents);
		_Pt0 = getPoint();
		return;
	}	
// end on insert	__________________//endregion
	

// set master coordSys
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	_Pt0 += vecZ * vecZ.dotProduct(_PtW - _Pt0);
	Point3d ptOrg = _Pt0;	
	CoordSys csWorld(_PtW, _XW, _YW, _ZW);
	
// ints
	int nGrainDirection = sGrainDirections.find(sGrainDirection);
	int nFaceAlignment = sFaceAlignments.find(sFaceAlignment);	
	
// get default size
	double dX = dLength;
	double dY = dWidth;
	Vector3d vecXGrain = nGrainDirection == 1 ? vecY : vecX;
	Vector3d vecYGrain = nGrainDirection == 1 ? vecX : vecY;
	CoordSys cs(ptOrg, vecXGrain, vecYGrain, vecXGrain.crossProduct(vecYGrain));

// get and draw master shape
	PLine plShape;
	Entity master = _Map.getEntity("master");
	EntPLine epl;
	if (master.bIsValid())
	{ 
		epl= (EntPLine)master;
		if (epl.color() != nc)epl.setColor(nc);
		plShape = epl.getPLine();
		
	// recreate after dim properties have changed	
		if (_kNameLastChangedProp==sLengthName || _kNameLastChangedProp==sWidthName)
		{ 
			epl.dbErase();
			_Map.setInt("CallOnCreated", true);
			setExecutionLoops(2);
			return;
		}
		_Entity.append(epl);
		
		
	}
	if (plShape.area()<pow(dEps,2))
	{ 
		plShape.createRectangle(LineSeg(_Pt0, _Pt0 + vecX * dX + vecY * dY), vecX, vecY);
		epl.dbCreate(plShape);
		epl.setColor(1);
		 _Map.setEntity("master", epl);
	}
	//dpPlan.draw(plShape);
	
	PlaneProfile ppMaster(cs);
	ppMaster.joinRing(plShape, _kAdd);
	PlaneProfile ppMasterNet=ppMaster;
	LineSeg segMaster = ppMasterNet.extentInDir(_XW);

// get extents of profile
	dX = abs(vecX.dotProduct(segMaster.ptStart()-segMaster.ptEnd()));
	dY = abs(vecY.dotProduct(segMaster.ptStart()-segMaster.ptEnd()));

// validate max dimensions
	if (dXMax<dX-dEps || dYMax<dY-dEps)
	{ 
		nc = 1;
	}


// display
	Display dpPlan(nc);
	dpPlan.dimStyle(sDimStyle);
	dpPlan.textHeight(dTextHeight);	

	double dFactor = 1;
	double dTextHeightStyle = dpPlan.textHeightForStyle("O",sDimStyle);	
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dpPlan.textHeight(dTextHeight);
	}
	dTextHeightStyle=dTextHeightStyle<U(10)?U(10):dTextHeightStyle;	



// update width/length properties and fire nesting
	if (abs(dLength - dX) > dEps)
	{
		dLength.set(dX);
		_Map.setInt("CallOnCreated", true);
	}
	if (abs(dWidth- dY) > dEps)
	{
		dWidth.set(dY);
		_Map.setInt("CallOnCreated", true);
	}
	ppMasterNet.shrink(dOversize);
	//dpPlan.draw(ppMasterNet);
	
// removeItem
	if (_Map.hasEntity("removeItem"))
	{ 
		Entity e = _Map.getEntity("removeItem");
		int n = _Entity.find(e);
		if (n>-1)
			_Entity.removeAt(n);
		_Map.removeAt("removeItem",true);
		reportMessage("..."+(n>-1?T("|successful|"):T("|failed|")));
	}
	

// get tsl items from entity
	TslInst items[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent = _Entity[i];
		setDependencyOnEntity(ent);
		if (ent == epl)continue;
		TslInst tsl= (TslInst)ent;
		if (tsl.bIsValid() && tsl.subMapXKeys().find(sItemX)>-1)
		{
			items.append(tsl);
			setDependencyOnEntity(tsl);
		}
	}
	


//// get formatVariables and prefixes
//	String sArguments[] = sAttribute.tokenize("@(*)");	

//
// collect entities
	Entity ents[0];
	Sip sips[0];
	PlaneProfile ppShapes[0];
	Entity entMainRef;// the entity which defines the material, thickness etc
	double dAreaMain;
	for (int i=0;i<items.length();i++) 
	{
		TslInst item = (TslInst)items[i];
	
		Map m = item.subMapX(sItemX);
		Entity ent;
		ent.setFromHandle(m.getString("UID"));
		if(ent.bIsValid())
		{
			ents.append(ent);	
					
		// get shape
			Map m = item.subMapX(sItemX);
			PlaneProfile ppShape = m.getPlaneProfile("profShape");
			ppShapes.append(ppShape);
			
			if (dAreaMain<ppShape.area())
			{
				dAreaMain = ppShape.area();
				entMainRef = ent;
			}
		}
		else 
			continue;
			
	// control sip alignments
	// rotate grain if required
		Sip sip = (Sip)ent;
		if (sip.bIsValid())
		{ 
		// align grain with master	
			if (!item.coordSys().vecX().isParallelTo(vecXGrain))
			{ 
				CoordSys csRot;
				csRot.setToRotation(90, _ZW, item.realBody().ptCen());
				item.transformBy(csRot);				
			}
			
		// align face with selected face
			if (nFaceAlignment>0)
			{ 
				sips.append(sip);
				
				SipStyle style(sip.style());
				String sqTop = sip.surfaceQualityOverrideTop();
				if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
				if (sqTop.length() < 1)sqTop = "?";
				int nQualityTop = SurfaceQualityStyle(sqTop).quality();
				
				String sqBottom = sip.surfaceQualityOverrideBottom();
				if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
				if (sqBottom.length() < 1)sqBottom = "?";
				int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();				


				Vector3d vecZM = sip.vecZ();
				CoordSys cs2Item;
				cs2Item.setToAlignCoordSys(sip.ptCenSolid(), sip.vecX(), sip.vecY(), sip.vecZ(), item.ptOrg(), item.coordSys().vecX(), item.coordSys().vecY(), item.coordSys().vecZ());
				vecZM.transformBy(cs2Item);
				
				if ((_ZW.isCodirectionalTo(vecZM) && nFaceAlignment==1) || (!_ZW.isCodirectionalTo(vecZM) && nFaceAlignment==2))
				{ 
					CoordSys csRot;
					csRot.setToRotation(180, item.coordSys().vecX(), item.realBody().ptCen());
					item.transformBy(csRot);					
				}
				vecZM.vis(item.ptOrg(),150);

		

			}	
		}
	}	
	
// cast to other genbeam types
	Sheet sheets[0];	
	Beam beams[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Sheet sheet= (Sheet)ents[i];	if (sheet.bIsValid())	{sheets.append(sheet);	continue;}
		Beam beam= (Beam)ents[i];		if (beam.bIsValid())	{beams.append(beam);	continue;} 
	}//next i
	int bDrawGrainPLine = (sips.length() > 0 || sheets.length() > 0) && nGrainDirection<2;
	
	
	
	
	
// draw dimensions
	Point3d ptRef = segMaster.ptMid() - .5 * (_XW * dX + _YW * dY);
	Point3d ptsDim[] = plShape.vertexPoints(true);
	Line lnX, lnY;
	lnX = Line(ptRef, _XW);
	lnY = Line(ptRef, _YW);
	
	Point3d ptsXDim[] = lnX.orderPoints(lnX.projectPoints(ptsDim), dEps);
	Point3d ptsYDim[] = lnY.orderPoints(lnY.projectPoints(ptsDim), dEps);

	DimLine dimLineX(ptRef-_YW*dTextHeightStyle*2,_XW,_YW);
	DimLine dimLineY(ptRef-_XW*dTextHeightStyle*2, _YW, -_XW);
	Dim dimX(dimLineX, ptsXDim, "<>","{<>}",_kDimPar);
	dimX.setDeltaOnTop(false);
	Dim dimY(dimLineY, ptsYDim, "<>","{<>}",_kDimPar);
	dimY.setDeltaOnTop(true);
	dpPlan.draw(dimX);
	dpPlan.draw(dimY);

// collect combined material string and materials
	String sMaterial,sMaterials[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity& ent = ents[i]; 
		String sVariables[] = ent.formatObjectVariables();
		if (sVariables.find("Material"))
		{ 
			String s = ent.formatObject("@(Material)");
			if (s.length()>0 && sMaterials.find(s)<0)
			{
				sMaterials.append(s);
				sMaterial += (sMaterial.length()>0?", ":"")+s;
			}
		}
	}//next i
	
	


// draw header
	Point3d ptTxt = _Pt0 - _YW*4 * dTextHeightStyle;
	
//region Default Header if format is empty
	if (sAttribute.length()<1)
	{ 
		dpPlan.textHeight(dTextHeightStyle * 1.5);
		dpPlan.draw(T("|Project|: ") + projectName(), ptTxt, _XW, _YW, 1, -1);
		ptTxt -= _YW * dTextHeightStyle * 2;
		dpPlan.textHeight(dTextHeightStyle);
		double dYFlag = -1;
		if(sMaterial.length()>0)
		{ 
			dpPlan.draw(sMaterial, ptTxt, _XW, _YW, 1, dYFlag);
			dYFlag -= 3;		
		}
		dpPlan.draw(String().formatTime("%x")+"   "+ projectComment(), ptTxt, _XW, _YW, 1, dYFlag);		
	}
//End Default Header if format is empty//endregion 	
	else
	{ 
		Entity entDef = _ThisInst;
	// the content
		String sValues[0];
		String s= entDef.formatObject(sAttribute);//.tokenize("\P");
		
	// find carriage returns	
		int left= s.find("\\P",0);
		while(left>-1)
		{
			String sub = s.left(left);
			sValues.append(s.left(left));
			s = s.right(s.length() - 2-left);
			left= s.find("\\P",0);
		}
		sValues.append(s);

		String sLines[0];	
	// resolve unknown and draw 
		//reportMessage("\n"+ scriptName() + " values i "+i +" " + sValues);
		for (int i = 0; i < sValues.length(); i++)
		{
			String& value = sValues[i];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				//String sVariables[] = sLines[i].tokenize("@(*)");
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1).makeUpper();

						if (sVariable=="@(CALCULATE WEIGHT)")
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", entDef);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							double n = int(dWeight * 1000);
							dWeight = n/1000;	// to overcome the missing methods on the custom objectvariables						
							sTokens.append(dWeight);
						}
//						else if (sVariable=="@(QUANTITY)")
//						{
//							int n=-1;
//							if (g.bIsValid())n= sUniqueKeys.find(String(g.posnum()));
//							if (t.bIsValid())n= sUniqueKeys.find(String(t.posnum()));
//							if (n>-1)
//							{ 
//								int nQuantity = nQuantities[n];
//							// as tag show only quantity > 1, as header (static) show any value	
//								if ((bHasStaticLoc && nQuantity>0) || (!bHasStaticLoc && nQuantity>1) )
//									sTokens.append(nQuantities[n]);	
//							}	
//						}

						
						//region Sip unsupported by formatObject
//						else if (sip.bIsValid())
//						{ 
//							if (sVariable=="@(GRAINDIRECTIONTEXT)")
//								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
//							else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")
//								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
//							else if (sVariable=="@(surfaceQualityBottom)".makeUpper())
//								sTokens.append(sqBottom);	
//							else if (sVariable=="@(surfaceQualityTop)".makeUpper())
//								sTokens.append(sqTop);	
//							else if (sVariable=="@(SURFACEQUALITY)")
//							{
//								String sQualities[] ={sqBottom, sqTop};
//								if (sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
//								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
//								sTokens.append(sQuality);	
//							}							
//						}
						//End Sip unsupported by formatObject//endregion 						
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}

				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
			if (value.length()>0)
				sLines.append(value);
		}		
		
		int nNumLine = sLines.length();
		
	// rebuild string to be displayed
		String sText;
		for (int i=0;i<nNumLine;i++) 
			sText+= (i>0?"\\P":"")+sLines[i]; 				
		dpPlan.color(ncText);
		dpPlan.draw(sText, ptTxt, _XW, _YW, 1, -1);			
		
		double dTextHeightDisplay = dpPlan.textHeightForStyle(sText, sDimStyle, dTextHeightStyle);
		double dHeightLine = dTextHeightDisplay / nNumLine;	
		
		
	// draw grain direction
		if (bDrawGrainPLine)
		{
			dpPlan.color(ncGrain);
			Point3d ptX;
			if (vecXGrain.isParallelTo(_XW))
				ptX= ptTxt - _YW* (dTextHeightDisplay+dHeightLine)+_XW*2*dHeightLine;
			else
				ptX= ptTxt - _YW* (2*dHeightLine)-_XW*dHeightLine;
			PLine plGrainSymbol(_ZE);
			plGrainSymbol.addVertex(ptX + (vecXGrain * dHeightLine - vecYGrain * dHeightLine*.5));
			plGrainSymbol.addVertex(ptX + (vecXGrain * dHeightLine*2));
			plGrainSymbol.addVertex(ptX + (-vecXGrain * dHeightLine*2));
			plGrainSymbol.addVertex(ptX + (-vecXGrain * dHeightLine + vecYGrain * dHeightLine*.5));
			dpPlan.draw(plGrainSymbol);
		}
	}
	



	
// call nester 
	int bCallOnCreated = _Map.getInt("CallOnCreated");
	if (bCallOnCreated)_Map.removeAt("CallOnCreated", true);
	int bCallNester = bCallOnCreated|| _kNameLastChangedProp==sGapName || _kNameLastChangedProp==sOversizeName || _kNameLastChangedProp==sGrainDirectionName;
	if (_bOnDbCreated)
	{
		_Map.setInt("CallOnCreated", true);
		_ThisInst.setColor(2);
		setExecutionLoops(2);
	}
// nesting properties
	double dNestDuration = 1;
	int bNestInOpening = false;
	double dNestRotation = nGrainDirection<2?180:90;
	int nNestType = _kNTRectangularNester;


//region AddItems
// add show / hide relathion trigger
	String sTriggerAddChild = T("|Add item(s)|");
	addRecalcTrigger(_kContext, sTriggerAddChild);
	if(_kExecuteKey==sTriggerAddChild)
	{
	// get all nesters in this dwg to check existing references
		Entity entNesters[] = Group().collectEntities(true,TslInst(), _kModelSpace);
		TslInst tslNesters[0];
		for (int i=entNesters.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl = (TslInst)entNesters[i];
			if (tsl.scriptName()==scriptName() && tsl!=_ThisInst)
				tslNesters.append(tsl);	
		}//next i

	// prompt for references
		Entity ents[0];
		PrEntity ssE(T("|Select item clone(s)|"), TslInst());	
		if (ssE.go())
			ents = ssE.set();
		
	// add valid items
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl = (TslInst)ents[i]; 
			if ((tsl.bIsValid() && tsl.subMapXKeys().find(sItemX)>-1) && items.find(tsl)<0)
			{ 
				items.append(tsl);
				
			// release link to another nester if existant	
				for (int n=0;n<tslNesters.length();n++) 
				{ 
					TslInst& tslNester = tslNesters[n];
					Entity _ents[] = tslNester.entity();
					if (_ents.find(tsl)>-1)
					{ 
						Map m = tslNester.map();
						m.setEntity("removeItem", tsl);
						reportMessage("\n" + scriptName() + ": " +tsl.handle() +T(" |releaseed from| ") + tslNester.handle() + T(" |and assigned to| ") + _ThisInst.handle());
						tslNester.setMap(m);
						tslNester.transformBy(Vector3d(0, 0, 0));
						break;
					}
					 
				}//next n
			}
			
		}//next i	
		bCallNester = nNestType > 0;	
	}		
//endregion End AddItems


// Trigger CallNester//region
	String sTriggerCallNester = T("|Call Nester|");
	addRecalcTrigger(_kContext, sTriggerCallNester );
	if (_bOnRecalc && (_kExecuteKey==sTriggerCallNester || _kExecuteKey==sDoubleClick))
	{
		bCallNester = true;
	}//endregion	


//region nesting
	if (bCallNester)// || bDebug)
	{
		if (!bDebug)
			_Entity.setLength(0);
		
		// set nester data
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dNestDuration); //seconds
		nd.setMinimumSpacing(dGap);
		nd.setGenerateDebugOutput(bDebug);
		nd.setNesterToUse(nNestType);
	
	// construct a NesterCaller object adding the master and all childs
		NesterCaller nester;
		for (int i=0; i<items.length(); i++) 
		{
			TslInst& item = items[i];
			Map m = item.subMapX(sItemX);
		
		// get shape
			PlaneProfile ppShape;
			if (m.hasPlaneProfile("profShape"))
			{
				ppShape = m.getPlaneProfile("profShape");
				ppShape.vis(2);
			}
				
			NesterChild nc(item.handle(),ppShape);
			nc.setNestInOpenings(bNestInOpening);
			nc.setRotationAllowance(dNestRotation);
			nester.addChild(nc);
		}	
		
		NesterMaster nm(master.handle(), ppMasterNet);
		nester.addMaster(nm);	

	// reporting 
	// user report
		int bShowLog = bDebug;
	//	if (mapSettings.getMap(sDictEntries[0]).hasInt("ShowNestingReport") && !bDebug)
	//		bShowLog =mapSettings.getMap(sDictEntries[0]).getInt("ShowNestingReport");
	
		if(bShowLog)
		{
		// NesterCaller object content
			reportNotice("\n" +T("|Nesting master input|"));	
			for (int m=0; m<nester.masterCount(); m++) 
			{
				NesterMaster master = nester.masterAt(m);
				//if (bDebug)reportMessage("\n		Master "+m+" "+nester.masterOriginatorIdAt(m) + " == " + master.originatorId() );
				reportNotice("\n   " +T("|Masterpanel|") + " " + nester.masterOriginatorIdAt(m));				
			}
			reportNotice("\n      "+nester.childCount() +" " + T("|childs to be nested|") );
			//for (int c=0; c<nester.childCount(); c++) 
			//{
				//NesterChild nc = nester.childAt(c);
				//if (bDebug)reportMessage("\n		Child "+c+" "+nester.childOriginatorIdAt(c) + " == " + nc.originatorId() + " rotationAllowance:"  + nc.rotationAllowance());
			//}
		}// end if (report)

	// do the actual nesting
		int nSuccess = nester.nest(nd, true);
		if (bDebug)reportMessage("\n\n	NestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			reportNotice("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportNotice("\n" + scriptName() + ": " + T("|No dongle present|"));
			setExecutionLoops(2);
			return;
		}

	// collect  nesting results
		///master indices
		int nMasterIndices[] = nester.nesterMasterIndexes();	
		int nLeftOverChilds[] = nester.leftOverChildIndexes();
		int bMasterHasChilds;
		if(bShowLog)reportNotice("\n	MasterIndices: " +nMasterIndices + "\n	LeftOverChilds: "+nLeftOverChilds);
		if(nMasterIndices.length()>0)
		{
			int nIndexMaster = nMasterIndices[0];
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			bMasterHasChilds = nChildIndices.length()>0;
			if(bShowLog)
			{
				if (bMasterHasChilds)
				{
					reportNotice("\n      "+nChildIndices.length() + " " + T("|child panels successfully nested|"));
				}
				else
					reportNotice("\n      "+ T("|No items found to be nested!|"));
			}
		}

	// in case of any left over items copy the master and assign the left over childs to it. make sure that the send in childs decrease at least by 1, unless we end in an infinte loop	
		if (nLeftOverChilds.length()>0 && bMasterHasChilds && nSuccess==_kNROk)
		{
			if(bShowLog)reportNotice("\n      "+nLeftOverChilds.length() + " " +T("|left over citems in current nesting attempt|"));
			//if (bDebug) reportMessage("\n\n		"+_ThisInst.handle() + " preparing nesting clone..");
	
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptRef};
			int nProps[]={};			
			double dProps[]={dLength, dWidth, dOversize, dGap, dTextHeight};
			String sProps[]={sDimStyle, sAttribute,sGrainDirection,sFaceAlignment};
			Map mapTsl;	
									
		// transform the insert location to next row	
			ptsTsl[0] += _XW * (dNextColumnDist + dX);

		// assign left over childs
			for (int c=0; c<nLeftOverChilds.length(); c++) 
			{
				Entity ent; 
				ent.setFromHandle(nester.childOriginatorIdAt(nLeftOverChilds[c]));
				entsTsl.append(ent);
				if (bDebug) reportMessage("\n		child " + ent.handle() + " assigned to new master");
			}
			if(bShowLog)reportNotice("\n      "+ entsTsl.length() + " " + T("|childs send to new nesting attempt|"));
			
			
		// create new instance withh nesting flag set to true
			//mapTsl.setInt("callNester", true);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			//if (bDebug && tslNew.bIsValid()) reportMessage("\n" +tslNew.handle() + " was successfully created.");	
		}

	// in case of any left over items with no valid master assignment move these above the master to inform user
		if (nLeftOverChilds.length()>0 && !bMasterHasChilds)
		{ 
			reportNotice("\n" + scriptName()+ T(": |Warning, could not nest item(s)|"));
			reportNotice("\n	" + T("|Usable master dimensions|: ")+(dX-2*dOversize) + " x " + (dY-2*dOversize));
			Point3d ptTo = ptRef + _YW * (dY+U(500));
		// locate the above the master
			for (int c=0; c<nLeftOverChilds.length(); c++) 
			{
				int nIndexChild = nLeftOverChilds[c];
				String strChild = nester.childOriginatorIdAt(nIndexChild);
				
				
				Entity ent; ent.setFromHandle(strChild);
				TslInst item = (TslInst)ent;
				if ( ! item.bIsValid())continue;
				double dOversize = item.propDouble(0);
				CoordSys cs=item.coordSys();
				Vector3d vecX = cs.vecX();
				Vector3d vecY = cs.vecY();
				Vector3d vecZ = cs.vecZ();
				Body bd = ent.realBody();
				double dXItem = bd.lengthInDirection(_XW);
				double dYItem = bd.lengthInDirection(_YW);
				Point3d pt = ptTo + .5*(_XW*dXItem+_YW*dYItem);
				cs.setToAlignCoordSys(item.ptOrg(), vecX, vecY, vecZ, pt,  vecX, vecY, vecZ);
				if(!bDebug)
					ent.transformBy(cs);
				
				reportNotice("\n	" + T("|Item| ")+(nIndexChild+1)+": "+(dXItem+2*dOversize) + " x " + (dYItem+2*dOversize));	
					
					
					
				ptTo += _XW * (dXItem + U(500));
			}			
		}



	// loop over the nester masters
		for (int m=0; m<nMasterIndices.length(); m++) 
		{
			int nIndexMaster = nMasterIndices[m];
			//if (bDebug)reportMessage("\nResult "+nIndexMaster +": "+nester.masterOriginatorIdAt(nIndexMaster) );
			
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				break;
			}
			
		// locate the childs within the master
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				int nIndexChild = nChildIndices[c];
				String strChild = nester.childOriginatorIdAt(nIndexChild);
				if (bDebug)reportMessage("\n		Child "+nIndexChild+" "+strChild);
				
				Entity ent; ent.setFromHandle(strChild);
				CoordSys cs = csWorldXformIntoMasters[c];
				if(!bDebug)
					ent.transformBy(cs);
				
				_Entity.append(ent);
			}
		}	



	}		



//endregion End nesting

	


	
#End
#BeginThumbnail
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
MI\DNP_9/^:/_`(%'_,MT54^S>,/^A3_\J,5'V;QA_P!"G_Y48J.278/9/^:/
M_@4?\SU&BBBO4/*"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`**HRZG96]_;6$UQ&EW=;O(A)^9]H))`]`!UJ]0`4444`%%%%`!
M115*QU*RU-)7LKB.X2*4PNT9R`XQD9]LB@"[1110`4444`%%%%`!1110`444
M4`%%,9UC0LY"J!DD\`4D<B2QK)&<HPR".XH`DHHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHKB?&WBD:9;FPLY/\`
M391\[#_EBI_]F/;\_2LJU:-&#G(VP^'GB*BIPW9%KOQ`33=0DM+*V2X\OAY"
M^!N[@>N*Y^\^*.IPP,XM[2-1T^5B?YURUI:SWMS';6T;232-A5'6N:UC[2FI
MSVDZ&)[=VC*>A!P:\*.*Q-:3:=E_6A]?3RS!TTH.-Y>?YGT'X*U]O$GAF&_F
M\L7&]HYE08`8'C]"#^-:FMW,MEH.H74)`F@M9)$)&<,%)'\J\I^#.K>5J%]H
M[M\LR">,'^\O##\01_WS7J7B;_D5=8_Z\9__`$`U[M"?-!,^6S&A["O*"VW1
M\^?##4+O5?BSI]W?W,EQ<2"8M)(V2?W3?I[5],U\C^!-?M?"_BZSU>\CFD@M
MUD#+"`6.Y&48R0.I%>EW/[0"+*5M?#S-'V:2[VD_@%./SKMJ0;EHCR:-2,8^
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
1:VLH(&(+1H%)'3@59HH`_]G'
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End