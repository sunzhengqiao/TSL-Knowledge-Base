#Version 8
#BeginDescription
1.6 16.02.2021 HSB-10099: fix bug at trigger addRemoveFormat Author: Marsel Nakuci

HSB-10099: Textheight 0 = scaled to view byDImstyle
HSB-10099: roof elements are supported
HSB-10099: text side on icon side, support elements, change TSL name
HSB-10099: make text height fix, add property format
HSB-10099: fix mapping, remove element code, enhance jig


1.6 16.02.2021 HSB-10099: fix bug at trigger addRemoveFormat Author: Marsel Nakuci
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Multiwall,ElementMulti,floorplan
#BeginContents
/// <History>//region
// #Versions
// V 1.6 16.02.2021 HSB-10099: fix bug at trigger addRemoveFormat Author: Marsel Nakuci
/// <version value="1.5" date="08feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10099: Textheight 0 = scaled to view byDImstyle </version>
/// <version value="1.4" date="05feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10099: roof elements are supported </version>
/// <version value="1.3" date="04feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10099: text side on icon side, support elements, change TSL name </version>
/// <version value="1.2" date="03feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10099: make text height fix, add property format </version>
/// <version value="1.1" date="03feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10099: fix mapping, remove element code, enhance jig </version>
/// <version value="1.0" date="01feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10099: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl can be attached to a viewport that contains multiwalls, walls or roof elementa. The TSL will
/// create a plan view of the elements from the same level as the elements in the viewport
/// and highlight the elements in the viewport.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewFloorplan")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
//end Constants//endregion
	
//region Properties
	String sDimStyleName=T("|Dim Style|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height. 0 = scaled to view byDImstyle|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 0, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(ElementNumber)", sFormatName);	
	sFormat.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by a backslash|") + " '\'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sFormat.setCategory(category);
//End Properties//endregion 
	
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey == strJigAction1)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		PlaneProfile ppAll = _Map.getPlaneProfile("ppAll");
		PlaneProfile ppAllVp = _Map.getPlaneProfile("ppAllVp");
		Display dpJig(7);
		
		if(!_Map.hasPoint3d("ptBase"))
		{ 
			// get extents of profile
			LineSeg seg = ppAll.extentInDir(_XW);
			Vector3d vecTransform = ptJig - seg.ptMid();
			ppAll.transformBy(vecTransform);
			ppAllVp.transformBy(vecTransform);
			
			dpJig.draw(ppAll);
			dpJig.color(nColor);
			dpJig.draw(ppAllVp,_kDrawFilled);
		}
		else
		{ 
			Point3d ptBase = _Map.getPoint3d("ptBase");
			LineSeg seg = ppAll.extentInDir(_XW);
			Vector3d vecTransform = ptBase - seg.ptMid();
			ppAll.transformBy(vecTransform);
			ppAllVp.transformBy(vecTransform);
			// get extents of profile
			seg = ppAll.extentInDir(_XW);
			PlaneProfile ppAllRect(ppAll.coordSys());
			PLine plAllRect(_ZW);
			
			plAllRect.createRectangle(seg, _XW, _YW);
			ppAllRect.joinRing(plAllRect,_kAdd);
			
			PLine pls[] = ppAllRect.allRings(true, false);
			PLine plOuter = pls[0];
			Point3d ptsIntersect[] = plOuter.intersectPoints(ptJig, ptBase - ptJig);
			Point3d ptIntersect;
			if(ptsIntersect.length()==0)
			{ 
				Point3d pts[] = plOuter.vertexPoints(false);
				ptIntersect = pts[0];
			}
			else
			{ 
				ptIntersect = ptsIntersect[0];
			}
			
			if ((ptIntersect - ptBase).dotProduct(ptJig - ptBase) < 0)
				ptIntersect = ptsIntersect[ptsIntersect.length() - 1];
				
			double dScale = (ptJig - ptBase).length() / (ptIntersect-ptBase).length();
			
			PlaneProfile ppAllScale(ppAll.coordSys());
			PLine plsNonOp[] = ppAll.allRings(true, false);
			PLine plsOp[] = ppAll.allRings(false, true);
//			dpJig.draw(ppAll);
			for (int i=0;i<plsNonOp.length();i++) 
			{ 
				Point3d pts[] = plsNonOp[i].vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = ptBase + dScale * (pts[j] - ptBase);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				ppAllScale.joinRing(plI, _kAdd);
			}//next i
			for (int i=0;i<plsOp.length();i++) 
			{ 
				Point3d pts[] = plsOp[i].vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = ptBase + dScale * (pts[j] - ptBase);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				ppAllScale.joinRing(plI, _kSubtract);
			}//next i
			dpJig.draw(ppAllScale);
			
			PlaneProfile ppAllScaleVp(ppAll.coordSys());
			PLine plsNonOpVp[] = ppAllVp.allRings(true, false);
			PLine plsOpVp[] = ppAllVp.allRings(false, true);
//			dpJig.draw(ppAll);
			for (int i=0;i<plsNonOpVp.length();i++) 
			{ 
				Point3d pts[] = plsNonOpVp[i].vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = ptBase + dScale * (pts[j] - ptBase);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				ppAllScaleVp.joinRing(plI, _kAdd);
			}//next i
			for (int i=0;i<plsOpVp.length();i++) 
			{ 
				Point3d pts[] = plsOpVp[i].vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = ptBase + dScale * (pts[j] - ptBase);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				ppAllScaleVp.joinRing(plI, _kSubtract);
			}//next i
			dpJig.color(nColor);
			dpJig.draw(ppAllScaleVp,_kDrawFilled);
		}
	}
	
//region bOnInsert
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
	Viewport vp = getViewport(T("|Select a viewport|"));
	_Viewport.append(vp);
	
	//		_Pt0 = getPoint(T("|Pick insertion point|"));
	
	// silent/dialog
	if (_kExecuteKey.length() > 0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
			setPropValuesFromCatalog(_kExecuteKey);
		else
			setPropValuesFromCatalog(sLastInserted);
	}
	// standard dialog	
	else
		showDialog();
	
		Element el = vp.element();
		if ( ! el.bIsValid())
		{
			reportMessage(TN("|no valid element found|"));
			eraseInstance();
			return;
		}
		// get all elements
		Entity ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		Element eElements[0];
		for (int i = 0; i < ents.length(); i++)
		{
			Element el = (Element)ents[i];
			ElementWall eW = (ElementWall) ents[i];
			ElementRoof eR = (ElementRoof) ents[i];
			if (eW.bIsValid() && eElements.find(eW) < 0)eElements.append(eW);
			if (eR.bIsValid() && eElements.find(eR) < 0)eElements.append(eR);
		}//next i
		if (eElements.length() == 0)
		{
			reportMessage(TN("|no elements found|"));
			eraseInstance();
			return;
		}
		
		ElementMulti eM = (ElementMulti)el;
		// can have elementWall, ElementRoof
		Element eElementsVp[0];
		String sgrpLevels[0];
		if(eM.bIsValid())
		{ 
			// multiwall
			SingleElementRef singleElementRefs[] = eM.singleElementRefs();
			for (int i=0;i<singleElementRefs.length();i++) 
			{ 
				SingleElementRef sEr = singleElementRefs[i];
				String sNumber = sEr.number();
				for (int j=0;j<eElements.length();j++) 
				{ 
					if(eElements[j].number()==singleElementRefs[i].number() && eElementsVp.find(eElements[j])<0)
					{
						eElementsVp.append(eElements[j]);
						Group grpsJ[] = eElements[j].groups();
						for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
						{ 
							if(sgrpLevels.find(grpsJ[iGrp].name())<0)
								sgrpLevels.append(grpsJ[iGrp].name());
							if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
							{ 
								if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
									sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
							}
						}//next iGrp
						break;
					}
				}//next j
			}//next i
		}
		else
		{ 
			// not a multiwall
			ElementWall eW = (ElementWall)el;
			if(eW.bIsValid())
			{
				eElementsVp.append(eW);
				Group grpsJ[] = eW.groups();
				for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
				{ 
					if(sgrpLevels.find(grpsJ[iGrp].name())<0)
						sgrpLevels.append(grpsJ[iGrp].name());
					if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
					{ 
						if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
							sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
					}
				}//next iGrp
			}
			ElementRoof eR = (ElementRoof)el;
			if(eR.bIsValid())
			{
				eElementsVp.append(eR);
				Group grpsJ[] = eR.groups();
				for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
				{ 
					if(sgrpLevels.find(grpsJ[iGrp].name())<0)
						sgrpLevels.append(grpsJ[iGrp].name());
					if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
					{ 
						if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
							sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
					}
				}//next iGrp
			}
		}
		
		// get all walls in same level as eElementsVp
		Element eElementsLevel[0];
		for (int iGrp=0;iGrp<sgrpLevels.length();iGrp++) 
		{ 
			Group grp(sgrpLevels[iGrp]);
			Entity ents[] = grp.collectEntities(true, Element(), _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				Element el = (Element)ents[i];
				ElementWall eW = (ElementWall) ents[i];
				ElementRoof eR = (ElementRoof)ents[i];
				if (eW.bIsValid() && eElementsLevel.find(eW) < 0)
				{
					eElementsLevel.append(eW);
				}
				else if (eR.bIsValid() && eElementsLevel.find(eR) < 0)
				{
					eElementsLevel.append(eR);
				}
			}//next i
		}//next iGrp
		
		CoordSys ms2ps = vp.coordSys();
		Vector3d vecXmodel = Vector3d(1, 0, 0);
		Vector3d vecYmodel = Vector3d(0, 1, 0);
		Vector3d vecZmodel = Vector3d(0, 0, 1);
		Point3d ptOrgModel = Point3d(0, 0, 0);
		ms2ps.setToAlignCoordSys(ptOrgModel, vecXmodel,vecYmodel,vecZmodel,
			vp.coordSys().ptOrg(), _XW*vp.dScale(),_YW*vp.dScale(),_ZW*vp.dScale());
		
		Vector3d vecX = _XW;
		Vector3d vecY = _YW;
		Vector3d vecZ = _ZW;
		CoordSys csWorld(_Pt0, _XW, _YW, _ZW);
		PlaneProfile ppAll(csWorld);
		PlaneProfile ppAllVp(csWorld);
		// find ptCen
		for (int i=0;i<eElementsLevel.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsLevel[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				ppAll.joinRing(plOutlineWall, _kAdd);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eR.plEnvelope();
				plEnvelope.transformBy(ms2ps);
				ppAll.joinRing(plEnvelope, _kAdd);
			}
		}//next i
		for (int i=0;i<eElementsVp.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsVp[i];
			ElementRoof eR = (ElementRoof)eElementsVp[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsVp[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				ppAllVp.joinRing(plOutlineWall, _kAdd);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eR.plEnvelope();
				plEnvelope.transformBy(ms2ps);
				ppAllVp.joinRing(plEnvelope, _kAdd);
			}
		}//next i
		
		
		Map mapArgs;
		mapArgs.setPlaneProfile("ppAll", ppAll);
		mapArgs.setPlaneProfile("ppAllVp", ppAllVp);
		
		String sStringStart = "|Select point [";
		String sStringPrompt = "|Select point|";
		
		PrPoint ssP(sStringPrompt);
		
		int nGoJig = -1;
		int iContinue = true;
		while (iContinue && nGoJig!= _kNone)
		{ 
			nGoJig = ssP.goJig(strJigAction1, mapArgs); 
			if (nGoJig == _kOk)
			{ 
				if(_PtG.length()==1)
				{ 
					_Pt0 = _PtG[0];
					_PtG[0] = ssP.value();
					iContinue = false;
				}
				else
				{ 
					_PtG.append( ssP.value());
					mapArgs.setPoint3d("ptBase", ssP.value());
					ssP = PrPoint(sStringPrompt, ssP.value());
				}
				_Map.setMap("mapJig", mapArgs );
			}
			else if (nGoJig == _kKeyWord)
			{ 
				
			}
			else if (nGoJig == _kCancel)
	        { 
	        	reportMessage("\n"+ scriptName() + " canceled");
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
		}
		return;
	}	
// end on insert	__________________//endregion
//return

	addRecalcTrigger(_kGripPointDrag, "_PtG0");
	if (_bOnGripPointDrag && (_kExecuteKey == "_PtG0"))
	{
		Viewport vp = _Viewport[0];
		Element el = vp.element();
		// get all elements
		Entity ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		Element eElements[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Element el = (Element)ents[i];
			ElementWall eW = (ElementWall) ents[i];
			ElementRoof eR = (ElementRoof) ents[i];
			if (eW.bIsValid() && eElements.find(eW) < 0)eElements.append(eW);
			if (eR.bIsValid() && eElements.find(eR) < 0)eElements.append(eR);
		}//next i
		
		ElementMulti eM = (ElementMulti)el;
		Element eElementsVp[0];
		String sgrpLevels[0];
		if(eM.bIsValid())
		{ 
			// multiwall
			SingleElementRef singleElementRefs[] = eM.singleElementRefs();
			for (int i=0;i<singleElementRefs.length();i++) 
			{ 
				SingleElementRef sEr = singleElementRefs[i];
				String sNumber = sEr.number();
				for (int j=0;j<eElements.length();j++) 
				{ 
					if(eElements[j].number()==singleElementRefs[i].number() && eElementsVp.find(eElements[j])<0)
					{
						eElementsVp.append(eElements[j]);
						Group grpsJ[] = eElements[j].groups();
						for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
						{ 
							if(sgrpLevels.find(grpsJ[iGrp].name())<0)
								sgrpLevels.append(grpsJ[iGrp].name());
							if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
							{ 
								if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
									sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
							}
						}//next iGrp
						break;
					}
				}//next j
			}//next i
		}
		else
		{ 
			// not a multiwall
			ElementWall eW = (ElementWall)el;
			if(eW.bIsValid())
			{
				eElementsVp.append(eW);
				Group grpsJ[] = eW.groups();
				for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
				{ 
					if(sgrpLevels.find(grpsJ[iGrp].name())<0)
						sgrpLevels.append(grpsJ[iGrp].name());
					if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
					{ 
						if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
							sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
					}
				}//next iGrp
			}
			ElementRoof eR = (ElementRoof)el;
			if(eR.bIsValid())
			{
				eElementsVp.append(eR);
				Group grpsJ[] = eR.groups();
				for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
				{ 
					if(sgrpLevels.find(grpsJ[iGrp].name())<0)
						sgrpLevels.append(grpsJ[iGrp].name());
					if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
					{ 
						if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
							sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
					}
				}//next iGrp
			}
		}
		
		// get all walls in same level as eElementVp
		Element eElementsLevel[0];
		for (int iGrp=0;iGrp<sgrpLevels.length();iGrp++) 
		{ 
			Group grp(sgrpLevels[iGrp]);
			Entity ents[] = grp.collectEntities(true, Element(), _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				Element el = (Element)ents[i];
				ElementWall eW = (ElementWall) ents[i];
				ElementRoof eR = (ElementRoof)ents[i];
				if (eW.bIsValid() && eElementsLevel.find(eW) < 0)
				{
					eElementsLevel.append(eW);
				}
				else if (eR.bIsValid() && eElementsLevel.find(eR) < 0)
				{
					eElementsLevel.append(eR);
				}
			}//next i
			 
		}//next iGrp
		
		CoordSys ms2ps = vp.coordSys();
		Vector3d vecXmodel = Vector3d(1, 0, 0);
		Vector3d vecYmodel = Vector3d(0, 1, 0);
		Vector3d vecZmodel = Vector3d(0, 0, 1);
		Point3d ptOrgModel = Point3d(0, 0, 0);
		ms2ps.setToAlignCoordSys(ptOrgModel, vecXmodel,vecYmodel,vecZmodel,
			vp.coordSys().ptOrg(), _XW*vp.dScale(),_YW*vp.dScale(),_ZW*vp.dScale());
		
		Vector3d vecX = _XW;
		Vector3d vecY = _YW;
		Vector3d vecZ = _ZW;
		Display dpLayout(7);
		Display dpText(1);
		CoordSys csWorld(_Pt0, _XW, _YW, _ZW);
		PlaneProfile ppAll(csWorld);
		
		// find ptCen
		for (int i=0;i<eElementsLevel.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsLevel[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				ppAll.joinRing(plOutlineWall, _kAdd);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eR.plEnvelope();
				plEnvelope.transformBy(ms2ps);
				ppAll.joinRing(plEnvelope, _kAdd);
			}
		}//next i
		
		// get extents of profile
		LineSeg seg = ppAll.extentInDir(vecX);
		Point3d ptCen = seg.ptMid();
		ptCen.vis(1);
		_Pt0.vis(3);
		Vector3d vecTransform = _Pt0 - ptCen;
		
		ppAll.transformBy(vecTransform);
		seg = ppAll.extentInDir(vecX);
		ppAll.vis(3);
		PlaneProfile ppAllRect(ppAll.coordSys());
		PLine plAllRect(_ZW);
		plAllRect.createRectangle(seg, _XW, _YW);
		ppAllRect.joinRing(plAllRect,_kAdd);
		ppAllRect.vis(1);
		PLine pls[] = ppAllRect.allRings(true, false);
		PLine plOuter = pls[0];
		Point3d ptsIntersect[] = plOuter.intersectPoints(_PtG[0], _Pt0 - _PtG[0]);
		Point3d ptIntersect;
		if(ptsIntersect.length()==0)
		{ 
			Point3d pts[] = plOuter.vertexPoints(false);
			ptIntersect = pts[0];
		}
		else
		{ 
			ptIntersect = ptsIntersect[0];
		}
		if ((ptIntersect - _Pt0).dotProduct(_PtG[0] - _Pt0) < 0)
			ptIntersect = ptsIntersect[ptsIntersect.length() - 1];
		
		double dScale = (_PtG[0] - _Pt0).length() / (ptIntersect - _Pt0).length();
		
//		dTextHeight.set(dScale * dTextHeight);
		for (int i=0;i<eElementsLevel.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsLevel[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				plOutlineWall.transformBy(vecTransform);
				
				Point3d pts[] = plOutlineWall.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eElementsLevel[i].plEnvelope();
				plEnvelope.transformBy(ms2ps);
				plEnvelope.transformBy(vecTransform);
				
				Point3d pts[] = plEnvelope.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI);
			}
		}//next i
		
		dpLayout.color(nColor);
		for (int i=0;i<eElementsVp.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsVp[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				plOutlineWall.transformBy(vecTransform);
				Point3d pts[] = plOutlineWall.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI, _kDrawFilled);
				
				//
				Vector3d vecYTextLayout = -eElementsVp[i].vecZ();
				vecYTextLayout.transformBy(ms2ps);
				vecYTextLayout.transformBy(vecTransform);
				vecYTextLayout.normalize();
				Vector3d vecXTextLayout = vecYTextLayout.crossProduct(_ZW);
				
				// get extents of profile
				LineSeg seg = ppI.extentInDir(vecXTextLayout);
				double dY = abs(vecYTextLayout.dotProduct(seg.ptStart()-seg.ptEnd()));
	//			String sName = eWallsVp[i].code()+eWallsVp[i].number();
	//			String sName = eWallsVp[i].number();
				String sName = eElementsVp[i].formatObject(sFormat);
				
				Point3d ptText = seg.ptMid() - vecYTextLayout * .5 * dY;
				ptText.vis(4);
				dpText.dimStyle(sDimStyle);
	//			dpText.textHeight(dScale * dTextHeight);
				if(dTextHeight>0)
				{
					dpText.textHeight(dTextHeight);
				}
				else
				{ 
					double dHeight = dpText.textHeightForStyle(sName, sDimStyle);
					dpText.textHeight(dHeight*vp.dScale());
				}
				dpText.draw(sName, ptText, vecXTextLayout, vecYTextLayout, 0 , -2);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eElementsVp[i].plEnvelope();
				plEnvelope.transformBy(ms2ps);
				plEnvelope.transformBy(vecTransform);
				Point3d pts[] = plEnvelope.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI, _kDrawFilled);
				Vector3d vecXTextLayout = _XW;
				Vector3d vecYTextLayout = _YW;
				LineSeg seg = ppI.extentInDir(vecXTextLayout);
				double dY = abs(vecYTextLayout.dotProduct(seg.ptStart()-seg.ptEnd()));
//				Point3d ptText = seg.ptMid()-vecYTextLayout * .5 * dY;
				Point3d ptText = seg.ptMid();
				String sName = eElementsVp[i].formatObject(sFormat);
				dpText.dimStyle(sDimStyle);
				if(dTextHeight>0)
				{
					dpText.textHeight(dTextHeight);
				}
				else
				{ 
					double dHeight = dpText.textHeightForStyle(sName, sDimStyle);
					dpText.textHeight(dHeight*vp.dScale());
				}
				dpText.draw(sName, ptText, vecXTextLayout, vecYTextLayout, 0 , -2);
			}
		}//next i
		return;
	}
	if(!_bOnJig)
	{
		// Trigger AddRemoveFormat//region
		String sTriggerAddRemoveFormat = T("|Add/Remove/Format|");
		addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
			
		Display dp(1);
		String sTriggerAddViewport = T("|Add Viewport|");
		if(_Viewport.length()==0)
		{ 
			reportMessage(TN("|no viewport found|"));
			dp.draw( T("|Add Viewport|"), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
			addRecalcTrigger(_kContextRoot, sTriggerAddViewport );
			return;
		}
		
		Viewport vp = _Viewport[0];
		
		// Trigger AddViewport//region
		if (_bOnRecalc && _kExecuteKey==sTriggerAddViewport)
		{
			Viewport vp = getViewport(T("|Select a viewport|"));
			int iNew = true;
			for (int i=0;i<_Viewport.length();i++) 
			{ 
				ViewData vD = _Viewport[i].viewData();
				if(vD.viewHandle()==vp.viewData().viewHandle())
				{ 
					iNew = false;
					break;
				}
			}//next i
			
	//		if(_Viewport.find(vp)<0)
			if(iNew)
			{
				_Viewport.append(vp);
				reportMessage(TN("|Viewport inserted|"));
			}
			else
			{ 
				reportMessage(TN("|Selected viewport already contained|"));
			}
			setExecutionLoops(2);
			return;
		}//endregion
		
		Element el = vp.element();
		if ( ! el.bIsValid())
		{ 
			dp.draw( T("|Not an element viewport|"), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
			addRecalcTrigger(_kContextRoot, sTriggerAddViewport );
			return;
		}
		
		// get all elements
		Entity ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		Element eElements[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Element el = (Element)ents[i];
			ElementWall eW = (ElementWall) ents[i];
			ElementRoof eR = (ElementRoof) ents[i];
			if (eW.bIsValid() && eElements.find(eW) < 0)eElements.append(eW);
			if (eR.bIsValid() && eElements.find(eR) < 0)eElements.append(eR);
		}//next i
		
		ElementMulti eM = (ElementMulti)el;
//		if ( ! eM.bIsValid())
//		{ 
//			dp.draw( T("|Not a Multiwall element|"), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
//			addRecalcTrigger(_kContextRoot, sTriggerAddViewport );
//			return;
//		}
		// ElementWall in viewport
		Element eElementsVp[0];
		String sgrpLevels[0];
		if(eM.bIsValid())
		{ 
			// multiwall
			SingleElementRef singleElementRefs[] = eM.singleElementRefs();
			for (int i=0;i<singleElementRefs.length();i++) 
			{ 
				SingleElementRef sEr = singleElementRefs[i];
				String sNumber = sEr.number();
				for (int j=0;j<eElements.length();j++) 
				{ 
					if(eElements[j].number()==singleElementRefs[i].number() && eElementsVp.find(eElements[j])<0)
					{
						eElementsVp.append(eElements[j]);
						Group grpsJ[] = eElements[j].groups();
						for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
						{ 
							if(sgrpLevels.find(grpsJ[iGrp].name())<0)
								sgrpLevels.append(grpsJ[iGrp].name());
							if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
							{ 
								if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
									sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
							}
						}//next iGrp
						
						break;
					}
				}//next j
			}//next i
		}
		else
		{ 
			// not a multiwall
			ElementWall eW = (ElementWall)el;
			if(eW.bIsValid())
			{
				eElementsVp.append(eW);
				Group grpsJ[] = eW.groups();
				for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
				{ 
					if(sgrpLevels.find(grpsJ[iGrp].name())<0)
						sgrpLevels.append(grpsJ[iGrp].name());
					if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
					{ 
						if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
							sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
					}
				}//next iGrp
			}
			ElementRoof eR = (ElementRoof)el;
			if(eR.bIsValid())
			{
				eElementsVp.append(eR);
				Group grpsJ[] = eR.groups();
				for (int iGrp=0;iGrp<grpsJ.length();iGrp++) 
				{ 
					if(sgrpLevels.find(grpsJ[iGrp].name())<0)
						sgrpLevels.append(grpsJ[iGrp].name());
					if(grpsJ[iGrp].namePart(0)!="" && grpsJ[iGrp].namePart(1)!="" )
					{ 
						if(sgrpLevels.find(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1))<0)
							sgrpLevels.append(grpsJ[iGrp].namePart(0)+"\\"+grpsJ[iGrp].namePart(1));
					}
				}//next iGrp
			}
		}
		
		// get all walls in same level as eWallsVp
		Element eElementsLevel[0];
		for (int iGrp=0;iGrp<sgrpLevels.length();iGrp++) 
		{ 
			Group grp(sgrpLevels[iGrp]);
			Entity ents[] = grp.collectEntities(true, Element(), _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				Element el = (Element)ents[i];
				ElementWall eW = (ElementWall) ents[i];
				ElementRoof eR = (ElementRoof)ents[i];
				if (eW.bIsValid() && eElementsLevel.find(eW) < 0)
				{
					eElementsLevel.append(eW);
				}
				else if (eR.bIsValid() && eElementsLevel.find(eR) < 0)
				{
					eElementsLevel.append(eR);
				}
			}//next i
			 
		}//next iGrp
		
		CoordSys ms2ps = vp.coordSys();
		Vector3d vecXmodel = Vector3d(1, 0, 0);
		Vector3d vecYmodel = Vector3d(0, 1, 0);
		Vector3d vecZmodel = Vector3d(0, 0, 1);
		Point3d ptOrgModel = Point3d(0, 0, 0);
		ms2ps.setToAlignCoordSys(ptOrgModel, vecXmodel,vecYmodel,vecZmodel,
			vp.coordSys().ptOrg(), _XW*vp.dScale(),_YW*vp.dScale(),_ZW*vp.dScale());
		
		String sObjectVariables[0];
		sObjectVariables.append(eElementsVp[0].formatObjectVariables());
	// get translated list of variables
		String sTranslatedVariables[0];
		for (int i=0;i<sObjectVariables.length();i++) 
			sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|"));
	// order alphabetically
		for (int i=0;i<sTranslatedVariables.length();i++) 
			for (int j=0;j<sTranslatedVariables.length()-1;j++) 
				if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
				{
					sObjectVariables.swap(j, j + 1);
					sTranslatedVariables.swap(j, j + 1);
				}
		
		if (_bOnRecalc && _kExecuteKey==sTriggerAddRemoveFormat)
		{
			String sAttribute = sFormat;
			String sPrompt;
			sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
			reportNotice("\n"+sPrompt);
		
			for (int s=0;s<sObjectVariables.length();s++) 
			{ 
				String key = sObjectVariables[s]; 
				String keyT = sTranslatedVariables[s];
				String sValue;
				for (int j=0;j<ents.length();j++) 
				{ 
					String _value = ents[j].formatObject("@(" + key + ")");
					if (_value.length()>0)
					{ 
						sValue = _value;
						break;
					}
				}//next j
	
				//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
				String sAddRemove = sAttribute.find("@(" + key + ")",0, false)<0?"   " : "√";
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
					sAttribute = sFormat;
					String newAttrribute = sAttribute;
		
				// get variable	and append if not already in list	
					String variable ="@(" + sObjectVariables[nRetVal] + ")";
					int x = sAttribute.find(variable, 0);
					if (x>-1)
					{
						int y = sAttribute.find(")", x);
						String left = sAttribute.left(x);
						String right= sAttribute.right(sAttribute.length()-y-1);
						newAttrribute = left + right;
						reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
					}
					else
					{ 
						newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
									
					}
					sFormat.set(newAttrribute);
					reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +newAttrribute);	
					reportNotice("\n" + sFormatName + " " + T("|set to|")+" " +newAttrribute);	
				}
				
				String sAttribute = sFormat;
				String sPrompt;
				sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
				reportNotice("\n"+sPrompt);
			
				for (int s=0;s<sObjectVariables.length();s++) 
				{ 
					String key = sObjectVariables[s]; 
					String keyT = sTranslatedVariables[s];
					String sValue;
					for (int j=0;j<ents.length();j++) 
					{ 
						String _value = ents[j].formatObject("@(" + key + ")");
						if (_value.length()>0)
						{ 
							sValue = _value;
							break;
						}
					}//next j
		
					//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
					String sAddRemove = sAttribute.find("@(" + key + ")",0, false)<0?"   " : "√";
					int x = s + 1;
					String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
					reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
				}//next i
				
				
				reportNotice("\n"+sPrompt);
				
				nRetVal = getInt(sPrompt)-1;
			}
			
			setExecutionLoops(2);
			return;
		}//endregion
		
		Vector3d vecX = _XW;
		Vector3d vecY = _YW;
		Vector3d vecZ = _ZW;
		
		Display dpLayout(7);
		Display dpText(1);
		CoordSys csWorld(_Pt0, _XW, _YW, _ZW);
		PlaneProfile ppAll(csWorld);
		
		// find ptCen
		for (int i=0;i<eElementsLevel.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsLevel[i].plOutlineWall();
				plOutlineWall.vis(4);
				plOutlineWall.transformBy(ms2ps);
				plOutlineWall.vis(4);
				ppAll.joinRing(plOutlineWall, _kAdd);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eR.plEnvelope();
				plEnvelope.transformBy(ms2ps);
				ppAll.joinRing(plEnvelope, _kAdd);
			}
			
		}//next i
		ppAll.vis(3);
		// get extents of profile
		LineSeg seg = ppAll.extentInDir(vecX);
		Point3d ptCen = seg.ptMid();
		ptCen.vis(1);
		_Pt0.vis(3);
		Vector3d vecTransform = _Pt0 - ptCen;
		
		ppAll.transformBy(vecTransform);
		seg = ppAll.extentInDir(vecX);
		ppAll.vis(3);
		PlaneProfile ppAllRect(ppAll.coordSys());
		PLine plAllRect(_ZW);
		plAllRect.createRectangle(seg, _XW, _YW);
		ppAllRect.joinRing(plAllRect,_kAdd);
		ppAllRect.vis(1);
		PLine pls[] = ppAllRect.allRings(true, false);
		PLine plOuter = pls[0];
		Point3d ptsIntersect[] = plOuter.intersectPoints(_PtG[0], _Pt0 - _PtG[0]);
		Point3d ptIntersect;
		if(ptsIntersect.length()==0)
		{ 
			Point3d pts[] = plOuter.vertexPoints(false);
			ptIntersect = pts[0];
		}
		else
		{ 
			ptIntersect = ptsIntersect[0];
		}
		if ((ptIntersect - _Pt0).dotProduct(_PtG[0] - _Pt0) < 0)
			ptIntersect = ptsIntersect[ptsIntersect.length() - 1];
		
		double dScale = (_PtG[0] - _Pt0).length() / (ptIntersect - _Pt0).length();
		
//		dTextHeight.set(dScale * dTextHeight);
		for (int i=0;i<eElementsLevel.length();i++) 
		{ 
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsLevel[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				plOutlineWall.transformBy(vecTransform);
				
				Point3d pts[] = plOutlineWall.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eR.plEnvelope();
				plEnvelope.transformBy(ms2ps);
				plEnvelope.transformBy(vecTransform);
				
				Point3d pts[] = plEnvelope.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI);
			}
			
		}//next i
		
		dpLayout.color(nColor);
		for (int i=0;i<eElementsVp.length();i++) 
		{ 
			String sNumber = eElementsVp[i].number();
			ElementWall eW = (ElementWall)eElementsLevel[i];
			ElementRoof eR = (ElementRoof)eElementsLevel[i];
			if(eW.bIsValid())
			{ 
				PLine plOutlineWall = eElementsVp[i].plOutlineWall();
				plOutlineWall.transformBy(ms2ps);
				plOutlineWall.transformBy(vecTransform);
				Point3d pts[] = plOutlineWall.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI, _kDrawFilled);
				
				//
	//			Vector3d vecXWall = eWallsVp[i].vecX();
	//			Vector3d vecXTextLayout = vecXWall;
	//			vecXTextLayout.transformBy(ms2ps);
	//			vecXTextLayout.normalize();
	//			if (vecXTextLayout.dotProduct(_XW) < 0)vecXTextLayout *= -1;
	//			if (vecXTextLayout.dotProduct(_XW) == 0 &&  vecXTextLayout.dotProduct(_YW)<0)vecXTextLayout *= -1;
	//			Vector3d vecYTextLayout = _ZW.crossProduct(vecXTextLayout);
				
	//			Point3d ptArrow = eWallsVp[i].ptArrow();
	//			ptArrow.transformBy(ms2ps);
	//			ptArrow.transformBy(vecTransform);
	//			ptArrow = _Pt0 + dScale*(ptArrow - _Pt0);
	//			ptArrow.vis(1);
				
				Vector3d vecYTextLayout = -eElementsVp[i].vecZ();
				vecYTextLayout.transformBy(ms2ps);
				vecYTextLayout.transformBy(vecTransform);
				vecYTextLayout.normalize();
	//			vecYTextLayout.vis(ptArrow);
				Vector3d vecXTextLayout = vecYTextLayout.crossProduct(_ZW);
				// get extents of profile
				LineSeg seg = ppI.extentInDir(vecXTextLayout);
				double dY = abs(vecYTextLayout.dotProduct(seg.ptStart()-seg.ptEnd()));
	//			String sName = eWallsVp[i].code()+eWallsVp[i].number();
	//			String sName = eWallsVp[i].number();
				String sName = eElementsVp[i].formatObject(sFormat);
				Point3d ptText = seg.ptMid() -vecYTextLayout * .5 * dY;
				ptText.vis(4);
				dpText.dimStyle(sDimStyle);
	//			dpText.textHeight(dScale * dTextHeight);
				if(dTextHeight>0)
				{
					dpText.textHeight(dTextHeight);
				}
				else
				{ 
					double dHeight = dpText.textHeightForStyle(sName, sDimStyle);
					dpText.textHeight(dHeight*vp.dScale());
				}
				dpText.draw(sName, ptText, vecXTextLayout, vecYTextLayout, 0 , -2);
			}
			else if(eR.bIsValid())
			{ 
				PLine plEnvelope = eElementsVp[i].plEnvelope();
				plEnvelope.transformBy(ms2ps);
				plEnvelope.transformBy(vecTransform);
				Point3d pts[] = plEnvelope.vertexPoints(false);
				PLine plI(_ZW);
				for (int j=0;j<pts.length();j++) 
				{ 
					Point3d ptJscale = _Pt0 + dScale * (pts[j] - _Pt0);
					plI.addVertex(ptJscale);
				}//next j
				plI.close();
				PlaneProfile ppI(csWorld);
				ppI.joinRing(plI, _kAdd);
		//		ppI.transformBy(vecTransform);
				dpLayout.draw(ppI, _kDrawFilled);
				Vector3d vecXTextLayout = _XW;
				Vector3d vecYTextLayout = _YW;
				LineSeg seg = ppI.extentInDir(vecXTextLayout);
				double dY = abs(vecYTextLayout.dotProduct(seg.ptStart()-seg.ptEnd()));
				seg.vis(4);
//				Point3d ptText = seg.ptMid()-vecYTextLayout * .5 * dY;
				Point3d ptText = seg.ptMid();
				ptText.vis(5);
				String sName = eElementsVp[i].formatObject(sFormat);
				dpText.dimStyle(sDimStyle);
				if(dTextHeight>0)
				{
					dpText.textHeight(dTextHeight);
				}
				else
				{ 
					double dHeight = dpText.textHeightForStyle(sName, sDimStyle);
					dpText.textHeight(dHeight*vp.dScale());
				}
				dpText.draw(sName, ptText, vecXTextLayout, vecYTextLayout, 0 , -2);
			}
		}//next i
	}

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
      <str nm="Comment" vl="HSB-10099: fix bug at trigger addRemoveFormat" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/16/2021 6:40:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10099: Textheight 0 = scaled to view byDImstyle" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/8/2021 1:11:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10099: roof elements are supported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/5/2021 11:35:45 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End