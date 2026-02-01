#Version 8
#BeginDescription
#Versions
Version 1.4 19.10.2023 HSB-20373 bugfix on insert
Version 1.3 17.10.2023 HSB-20373 sectional edits improved, distribution rules enhanced, new grips
Version 1.2 02.02.2022 HSB-14553 dimpoints patterns enhanced
Version 1.1 01.02.2022 HSB-14553 dimpoints published, new context command to configure shopdrawing
Version 1.0 19.01.2022 HSB-14429 inital version

This tool creates a slot distribution on coplanar panels




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.4 19.10.2023 HSB-20373 bugfix on insert , Author Thorsten Huck
// 1.3 17.10.2023 HSB-20373 sectional edits improved, distribution rules enhanced, new grips , Author Thorsten Huck
// 1.2 02.02.2022 HSB-14553 dimpoints patterns enhanced , Author Thorsten Huck
// 1.1 01.02.2022 HSB-14553 dimpoints published, new context command to configure shopdrawing , Author Thorsten Huck
// 1.0 19.01.2022 HSB-14429 inital version , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities panels and specify properties
/// </insert>

// <summary Lang=en>
// This tsl creates a slot distribution on a set of coplanar panels
// </summary>	
// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Slot-Distribution")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Panels|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Panels|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit in Place|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Configure Shopdrawing|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Settings|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select Tool|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
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
	
	String kFormat="Format", kView = "View", kStereotype="Stereotype", kShopdrawing="Shopdrawing", kDisabled=T("<|Disabled|>");
	String sViews[] = { T("|XY-View|"), T("|Section|")};
	String sDistributionFormat = "@(Quantity-2)x  @(Width) / @(Depth)"+ "  >@(Angle)°";
	String kTextCumm = "TextCumm", kTextDelta = "TextDelta", kNode="Node", kNodes="Node[]";
//endregion 	
	
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey("Shopdrawing");

			String sDimStereotypes[0];
			{ 
				String styles[] = MultiPageStyle().getAllEntryNames();
				for (int i=0;i<styles.length();i++) 
				{ 
					MultiPageStyle mps(styles[i]);
					String stereotypes[] = mps.getListOfStereotypeOverridesChainDim();
					for (int j=0;j<stereotypes.length();j++) 
					{ 
						if (sDimStereotypes.findNoCase(stereotypes[j],-1)<0)
							sDimStereotypes.append(stereotypes[j]); 			 
					}//next j	

				}//next i

				sDimStereotypes = sDimStereotypes.sorted();
				sDimStereotypes.insertAt(0, "*");	
				sDimStereotypes.insertAt(0,kDisabled);					
			}	

		category = T("|Dimension|");	
			String sFormatName=T("|Format|");	
			PropString sFormat(nStringIndex++, sDistributionFormat, sFormatName);	
			sFormat.setDescription(T("|Defines the Format|"));
			sFormat.setCategory(category);
			
			String sStereotypeName=T("|Stereotype|");	
			PropString sStereotype(nStringIndex++, sDimStereotypes, sStereotypeName);	
			sStereotype.setDescription(T("|Defines the stereotype|"));
			sStereotype.setCategory(category);
			
			String sViewName=T("|View|");	
			PropString sView(nStringIndex++, sViews, sViewName);	
			sView.setDescription(T("|Defines the View|"));
			sView.setCategory(category);
			int nView = sViews.find(sView);
			if (nView<0) sView.set(0);


		}		
		return;		
	}
//End DialogMode//endregion

//region Functions

//endregion 


//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-Slot-Distribution";
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
	

	String sStereotype = "*";
	int nView;
{
	String k;
	Map m= mapSetting.getMap(kShopdrawing);

	k=kView;		if (m.hasInt(k))		nView = m.getInt(k);
	k=kFormat;		if (m.hasString(k))		sDistributionFormat = m.getString(k);
	k=kStereotype;	if (m.hasString(k))		sStereotype = m.getString(k);
}	
//End Read Settings//endregion 


//region Properties
category = T("|Geometry|");
		
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(8), sWidthName, _kLength);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(16), sDepthName, _kLength);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
		
category = T("|Alignment|");
	String sFaceName=T("|Face|");
	String sFaces[] = { T("|Reference Side|"), T("|Opposite Side|")};
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFaces.find(sFace)==1?1:-1;

	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(19.5), sAngleName, _kAngle);	
	dAngle.setDescription(T("|Defines the angle of the slot to the normal of the face|") + T(", |must be in range of -90 > Value < 90|"));
	dAngle.setCategory(category);			

category = T("|Distribution|");
	String sInterdistanceName=T("|Interdistance|");	
	PropDouble dInterdistance(nDoubleIndex++, U(60), sInterdistanceName);	
	dInterdistance.setDescription(T("|Defines the Interdistance|"));
	dInterdistance.setCategory(category);

	String sDistributionModeName=T("|Mode|");	
	String sDistributionModes[] ={ T("|Fixed|"), T("|Even|")};
	PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);	
	sDistributionMode.setDescription(T("|Defines the DistributionMode|"));
	sDistributionMode.setCategory(category);
	int nDistributionMode = sDistributionModes.find(sDistributionMode);
	if (nDistributionMode<-1){ sDistributionMode.set(sDistributionModes[0]); setExecutionLoops(2); return;}	

	String sRotationName=T("|Rotation|");	
	PropDouble dRotation(nDoubleIndex++, U(0), sRotationName, _kAngle);	
	dRotation.setDescription(T("|Defines the rotation of the slot distribution|"));
	dRotation.setCategory(category);		
	
category = T("|Distribution Offsets|");
	String sLeftName=T("|Left|");	
	PropDouble dLeft(nDoubleIndex++, U(0), sLeftName);	
	dLeft.setDescription(T("|Defines the Left|"));
	dLeft.setCategory(category);
	
	String sRightName=T("|Right|");	
	PropDouble dRight(nDoubleIndex++, U(0), sRightName);	
	dRight.setDescription(T("|Defines the Right|"));
	dRight.setCategory(category);
	
	String sBottomName=T("|Bottom|");	
	PropDouble dBottom(nDoubleIndex++, U(0), sBottomName);	
	dBottom.setDescription(T("|Defines the Bottom|"));
	dBottom.setCategory(category);	
	
	String sTopName=T("|Top|");	
	PropDouble dTop(nDoubleIndex++, U(0), sTopName);	
	dTop.setDescription(T("|Defines the Top|"));
	dTop.setCategory(category);
//End Properties//endregion 

//region References
	Sip sips[0], sipRef;
	Point3d ptFace;
	Vector3d vecX, vecY,vecZ;
//endregion 

//region bOnInsert #1
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
		
		nFace = sFaces.find(sFace)==1?1:-1;
	
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
	// collect sips		
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i]; 
			if (sip.bIsValid())
			{ 
				Vector3d vecXi = sip.vecX();
				Vector3d vecYi = sip.vecZ();				
				Vector3d vecZi = sip.vecZ();
				if (!sipRef.bIsValid())
				{
					sipRef = sip;
					vecX = sipRef.vecX();
					vecY = sipRef.vecY();
					vecZ = sipRef.vecZ();

					ptFace = sipRef.ptCen() + .5 * nFace*vecZ * sipRef.dH();
					sips.append(sip);
				}
				sips.append(sip);
			}	 
		}//next i
	}	
	else
	{ 
		sips = _Sip;
		if(sips.length()>0)
		{
			sipRef = sips.first();		
			vecX = sipRef.vecX();
			vecY = sipRef.vecY();
			vecZ = sipRef.vecZ();

			ptFace = sipRef.ptCen() + .5 * nFace*vecZ * sipRef.dH();			
		}
	}


// end on insert	__________________//endregion		
		
//region References
	// remove panels not coplanar with ref
	for (int i=sips.length()-1; i>0 ; i--) 
	{ 
		Vector3d vecZi = sips[i].vecZ();
		Point3d ptFacei = sips[i].ptCen() + .5 * nFace*vecZ * sips[i].dH();
		
		if (!vecZ.isParallelTo(vecZi) || vecZ.dotProduct(ptFace-ptFacei)>dEps)
			sips.removeAt(i);
	}//next i

	if (sips.length()<1)
	{ 
		eraseInstance();
		return;
	}
	
//endregion 	
		
//region Get individual and common profile
	CoordSys csFace(ptFace, vecX, vecY, vecZ);
	CoordSys cs = csFace;
	if (abs(dRotation) > dEps)
	{
		CoordSys csr;
		csr.setToRotation(dRotation, vecZ, ptFace);
		cs.transformBy(csr);
	}
	Plane pnFace(ptFace, vecZ * nFace);
	
	
	PlaneProfile pps[0], ppCommon(csFace);	
	for (int i=0;i<sips.length();i++) 
	{ 
		PlaneProfile pp(csFace);
		pp = sips[i].envelopeBody(false, true).extractContactFaceInPlane(pnFace, dEps);		
		//pp.joinRing(sips[i].plEnvelope(), _kAdd);
		
		PLine plOpenings[] = sips[i].plOpenings();
		for (int j=0;j<plOpenings.length();j++) 
			pp.joinRing(plOpenings[j],_kSubtract); 
		
		pps.append(pp);
		pp.shrink(-dEps);
		ppCommon.unionWith(pp); 
	}//next i
	ppCommon.shrink(dEps);	

	PlaneProfile ppBoundary = ppCommon;

	//region Apply offsets
	double dOffsets[] ={  dBottom, dTop,dLeft, dRight};
	Vector3d vecDirs[] ={ -csFace.vecY(), csFace.vecY(),-csFace.vecX(), csFace.vecX()};
//	cs.vecX().vis(sipRef.ptCen(), 1);
//	cs.vecY().vis(sipRef.ptCen(), 3);

//	int inds[0]; 
//	for (int j=0;j<vecDirs.length();j++) 
//	{ 
//		Vector3d vecDir= vecDirs[j]; 
//		int indsDir[0];
//		Vector3d vecMoves[0];
//		Point3d pts[] = ppCommon.getGripEdgeMidPoints();
//		PLine rings[] = ppCommon.allRings(true, false);	
//		for (int p=0;p<pts.length();p++) 
//		{ 
//			Point3d pt = pts[p]; 
//			for (int r=0;r<rings.length();r++) 
//			{ 
//				PLine ring= rings[r]; 
//				if (ring.isOn(pt))
//				{ 
//					double d0 = ring.getDistAtPoint(pt);
//					double d1 = d0 + dEps;
//					Point3d pt2 = ring.getPointAtDist(d1);
//					Vector3d vecXS = pt2 - pt;
//					vecXS.normalize();
//					Vector3d vecYS = vecXS.crossProduct(-vecZ);
//					if (ppCommon.pointInProfile(pt+vecYS*dEps)==_kPointInProfile)
//					{ 
//						vecYS *= -1;
//						vecXS *= -1;
//					}
//					
//					if(inds.find(p)>-1){ continue;} // do not stretch grip again
//					if(j>1 && !vecYS.isParallelTo(vecDir) && vecDir.dotProduct(vecYS)<.5){ continue;} // left/right only if slithly beveled
//
//					
//					if (vecDir.dotProduct(vecYS)>.1 && dOffsets[j]>dEps) // && !vecDir.isParallelTo(vecXS))
//					{ 
//						vecDir.vis(pt, j);
//						inds.append(p);
//						indsDir.append(p);
//						vecMoves.append(-vecYS);
//						vecMoves[vecMoves.length()-1].vis(pt,4);
//					}
//					
//				}
//			}//next r			
//		}//next p
//		
//		for (int p=0;p<indsDir.length();p++) 
//		{ 
//			ppCommon.moveGripEdgeMidPointAt(indsDir[p], vecMoves[p]*dOffsets[j]); 
//			ppCommon.vis(j); 
//		}//next p
//	}//next j
	
	PlaneProfile ppRec(cs); 
	if (_Grip.length()>1)
	{
		ppRec.createRectangle(LineSeg(_Grip[0].ptLoc(), _Grip[1].ptLoc()), vecX, vecY);
		ppCommon.intersectWith(ppRec);
	}
	ppRec.vis(4);
	
	ppCommon.shrink(-dEps); // workaround until HSB-14432 is fixed
	ppCommon.shrink(dEps);
	ppCommon.vis(2);			
	//endregion 

	LineSeg segCommon = ppCommon.extentInDir(vecX);
	LineSeg segBoundary = ppBoundary.extentInDir(vecX);
	segCommon.vis(1);

	double dX = ppCommon.dX();
	double dY = ppCommon.dY();
	
	double dXBoundary = ppBoundary.dX();
	double dYBoundary = ppBoundary.dY();


//endregion 

//region Distribution

	double dRange = abs(cs.vecY().dotProduct(segCommon.ptEnd() - segCommon.ptStart()));
	double dDist = dInterdistance;
	double dVisibleWidth = dWidth/cos(dAngle);
	int numRow = 1;
	
	if (dX-dDist>0)
		numRow = (dRange - dDist) / (dVisibleWidth + dDist) + (nDistributionMode==1?1.999:0);		
	
	if (nDistributionMode==0)// && (dRange - 2*dVisibleWidth>dDist)) //fixed
	{
		numRow++;
		
		double d0 = dVisibleWidth + dDist;
		double d1 = dRange - numRow * dVisibleWidth - (numRow - 1) * dDist;
		if ((d1-d0)<dEps && abs(d0-d1)>dEps)
			numRow--;
		
		
	}
	else if (nDistributionMode==1 && numRow>1) // even	
		dDist = (dRange - numRow * dVisibleWidth) / (numRow - 1);

	int bRevertDirection = _Map.getInt("RevertDirection");
	Vector3d vecDistr = cs.vecY()*(bRevertDirection?-1:1);
	Point3d pt = segCommon.ptMid() - vecDistr * (.5 * dRange-.5*dVisibleWidth);

	LineSeg segs[0];
	PlaneProfile ppSlots[0];
	for (int i=0;i<=numRow;i++) 
	{ 

		PlaneProfile pp(cs);
		pp.createRectangle(LineSeg(pt - cs.vecX() * U(10e4)-cs.vecY()*.5*dVisibleWidth,
			pt + cs.vecX() * U(10e4)+cs.vecY()*.5*dVisibleWidth),
			cs.vecX(), cs.vecY());
			
		if(i==0 || i==numRow){;pp.vis(3);	}
		pt.vis(6);
		
		pp.intersectWith(ppCommon); 
		
		PLine rings[] = pp.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(rings[r], _kAdd);
			
			ppSlots.append(pp);
//			LineSeg seg (pp.ptMid() - cs.vecX() * .5 * pp.dX(), pp.ptMid() + cs.vecX() * .5 * pp.dX());
//			segs.append(seg);
//			 
		}//next r

		
		//segs.append(ppCommon.splitSegments(seg, true));
		pt += vecDistr * (dDist+dVisibleWidth);
		 
	}//next i
cs.vecY().vis(pt,2);
//endregion 

//region bOnInsert #2
	if(_bOnInsert)
	{
		_Sip.append(sips);
		_Pt0 = ptFace;
		return;
	}	
// end on insert	__________________//endregion

//region General
	_ThisInst.setAllowGripAtPt0(false);
	//setEraseAndCopyWithBeams(_kBeam0);
	setCloneDuringBeamSplit(_kAuto);
	Element el = sipRef.element();
	if (el.bIsValid())
		assignToElementGroup(el, true, 0, 'T');
	else
		assignToGroups(sipRef);
	

//endregion 


//region Grips
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	//_Grip.setLength(0);
	_ThisInst.setAllowGripAtPt0(false);	
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	Grip grip;
	Vector3d vecOffsetApplied;
	int bDrag, bOnDragEnd,bDragTag;

	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;		
		grip = _Grip[indexOfMovedGrip];
		vecOffsetApplied = grip.vecOffsetApplied();
	}	

	Point3d pts[0];
	if(_Grip.length()<1)
	{ 
		if (_PtG.length()>1) // legacy
		{ 
			pts.append(_PtG);
		}
		else
		{ 
			pts.append(segCommon.ptStart());
			pts.append(segCommon.ptEnd());
		}

		for (int p = 0; p < pts.length(); p++)
		{
			Point3d pt = pts[p];
			
			Grip grip;
			grip.setPtLoc(pt);
			grip.setVecX(vecX);
			grip.setVecY(vecY);			
			grip.setName("loc_" + p);
			grip.setToolTip(T("|Modifies the range of the slot distribution|"));
			grip.setColor(3);
			grip.setShapeType(_kGSTAcad);
							
			_Grip.append(grip); 						
		}
		_PtG.setLength(0);
	}	
	else
	{ 
		for (int i=0;i<_Grip.length();i++) 
		{ 
			Grip& g= _Grip[i]; 
			Point3d pt = g.ptLoc();
			pt += vecZ * vecZ.dotProduct(ptFace - pt);
			
			if (bOnDragEnd && vecZView.isParallelTo(cs.vecX()) && i == indexOfMovedGrip)
			{ 
				Vector3d vec= vecZView * vecZView.dotProduct(vecOffsetApplied);
				setExecutionLoops(2);
				pt -= vec;
			}

			g.setPtLoc(pt);
					
			String name = g.name();
			if (name.find("loc_",0,false)==0)
				pts.append(pt);			 
		}//next i
	}
	
	
	pts = Line(_Pt0, vecX).orderPoints(pts);
	pts = Line(_Pt0, vecY).orderPoints(pts);
	if (pts.length()<2)
	{ 
		
		return;
	}
	
	Point3d ptLeftBottom = segBoundary.ptMid() - .5 * (vecX * dXBoundary + vecY * dYBoundary);
	Point3d ptRightTop = segBoundary.ptMid() + .5 * (vecX * dXBoundary + vecY * dYBoundary);
	
	ptLeftBottom.vis(2);
	ptRightTop.vis(2);
	
	if (bOnDragEnd && abs(Vector3d(grip.ptLoc()-pts[0]).length())<dEps)
	{ 
		dLeft.set(vecX.dotProduct(pts[0] - ptLeftBottom));
		dBottom.set(vecY.dotProduct(pts[0] - ptLeftBottom));	
		setExecutionLoops(2);
		return;
	}
	else if (bOnDragEnd && abs(Vector3d(grip.ptLoc()-pts[1]).length())<dEps)//_kNameLastChangedProp=="_PtG1")
	{ 
		dRight.set((-vecX).dotProduct(pts[1] - ptRightTop));
		dTop.set((-vecY).dotProduct(pts[1] - ptRightTop));	
		setExecutionLoops(2);
		return;		
	}

	double left = vecX.dotProduct(ptLeftBottom - pts[0]);
	if (_kNameLastChangedProp==sLeftName)// || left!=dLeft)
	{ 
		pts[0].transformBy(vecX * (left + dLeft));
		_Grip[0].setPtLoc(pts[0]);
		setExecutionLoops(2);
	}
	double right = vecX.dotProduct(ptRightTop - pts[1]);
	if (_kNameLastChangedProp==sRightName)// || right!=dRight)
	{ 
		pts[1].transformBy(vecX * (right - dRight));
		_Grip[1].setPtLoc(pts[0]);
		setExecutionLoops(2);
	}
	double bottom = vecY.dotProduct(ptLeftBottom - pts[0]);
	if (_kNameLastChangedProp==sBottomName)// || bottom!=dBottom)
	{ 
		pts[0].transformBy(vecY * (bottom + dBottom));
		_Grip[0].setPtLoc(pts[0]);
		setExecutionLoops(2);
	}
	double top = vecY.dotProduct(ptRightTop - pts[1]);
	if (_kNameLastChangedProp==sTopName)// || top!=dTop)
	{ 
		pts[1].transformBy(vecY * (top - dTop));
		_Grip[1].setPtLoc(pts[0]);
		setExecutionLoops(2);
	}

//endregion 



//region Trigger

// Trigger FlipSide//region
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick)) 
	{
		sFace.set((sFace == sFaces[0] ? sFaces[1] : sFaces[0]));
		setExecutionLoops(2);
		return;
	}//endregion		
	
	
//region Trigger RevertDirection
	String sTriggerRevertDirection = T("|Revert Direction|");
	if (nDistributionMode==0)addRecalcTrigger(_kContextRoot, sTriggerRevertDirection );
	if (_bOnRecalc && _kExecuteKey==sTriggerRevertDirection)
	{
		_Map.setInt("RevertDirection", !bRevertDirection);		
		setExecutionLoops(2);
		return;
	}//endregion	


	
//region Trigger AddPanel
	String sTriggerAddPanel = T("|Add Panels|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPanel );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPanel)
	{
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());	
			
			
	// collect sips		
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i]; 
			if (sip.bIsValid())
			{ 
				Vector3d vecZi = sip.vecZ();
				Point3d ptFacei = sip.ptCen() + .5 * nFace*vecZ * sip.dH();
		
				if (!vecZ.isParallelTo(vecZi) || 
					vecZ.dotProduct(ptFace-ptFacei)>dEps || 
					_Sip.find(sip)>-1)
				{ 
					continue;
				}		

				_Sip.append(sip);
			}	 
		}//next i				
			
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemovePanel
	String sTriggerRemovePanel = T("|Remove Panels|");
	if (sips.length()>0)
	{
		addRecalcTrigger(_kContextRoot, sTriggerRemovePanel );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemovePanel)
		{
		// prompt for sips
			Entity ents[0];
			PrEntity ssE(T("|Select panels|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());			
				
				
		// collect sips		
			for (int i=0;i<ents.length();i++) 
			{ 
				int n = _Sip.find(ents[i]);
				if (n>-1)
				{ 
					_Sip.removeAt(n);
				}
				if (_Sip.length()==1)
					break;
			}//next i			
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	
	
// TriggerEditInPlacePanel
	
	String sTriggerEditInPlace = T("|Edit in Place|");
	addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
	int bEditInPlace = _bOnRecalc && _kExecuteKey == sTriggerEditInPlace;

// create TSL
	TslInst tslNew;
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};

	
	int nProps[]={};			double dProps[]={0,dWidth, dDepth, dAngle};
	String sProps[]={T("|Center|"), sFace};
	Map mapTsl;	
				
	
	
//endregion 	

//region Display and node dims
	Display dpElement(nFace == -1?5:40),dpSection(nFace == -1?5:40), dpLine(1);//blueish/ brownish
	dpElement.addHideDirection(cs.vecX());
	dpElement.addHideDirection(-cs.vecX());
	dpSection.addViewDirection(cs.vecX());
	dpSection.addViewDirection(-cs.vecX());	

	Map mapAdditional;
	mapAdditional.setInt("Quantity", numRow);
	mapAdditional.setInt("Quantity-2", numRow - 2);
	String sDistributionText = _ThisInst.formatObject(sDistributionFormat, mapAdditional); 

	Map mapNodes; // a map containing submaps with delta and cum node texts and its corresponding point
	{ 
		Map m;
		m.setPoint3d("pt", ptLeftBottom);
		m.setString(kTextCumm, " "); // suppress 0
		m.setInt("isRef", true);
		mapNodes.appendMap(kNode, m);
	}
	{ 
		Map m;
		m.setPoint3d("pt", ptRightTop);
		m.setString(kTextCumm, "<>");
		mapNodes.appendMap(kNode, m);
	}	
//endregion 



//region Tooling

	Vector3d vecXT = -nFace*cs.vecX();
	Vector3d vecYT = cs.vecY();
	Vector3d vecZT = -nFace*cs.vecZ();


	// angle
	CoordSys csT(ptFace, vecXT, vecYT, vecZT);
	if (abs(dAngle)>0)
	{ 
		CoordSys csRot;
		csRot.setToRotation(dAngle, -vecXT, ptFace);
		csT.transformBy(csRot);
		vecXT = csT.vecX();
		vecYT = csT.vecY();
		vecZT = csT.vecZ();	
	}	


	vecXT.vis(_Pt0, 1);
	vecYT.vis(_Pt0, 3);//cs.vecY().vis(_Pt0, 93);
	vecZT.vis(_Pt0, 150);

	PlaneProfile ppSection;
	{
		PLine pl;
		pl.createRectangle(LineSeg(_Pt0 - vecZT * dDepth - vecYT * .5 * dWidth, _Pt0 + vecZT * dDepth + vecYT * .5 * dWidth), vecZT, vecYT);
		ppSection = PlaneProfile(pl);
		PlaneProfile pp; pp.createRectangle(LineSeg(_Pt0 -cs.vecY()* 2*dWidth, _Pt0- vecZ*nFace*2*dWidth+cs.vecY()* 2*dWidth), cs.vecY(), vecZ);
		pp.vis(7);
		ppSection.intersectWith(pp);
		ppSection.vis(3);
	}
	

	if (dWidth>dEps && dDepth>dEps)
	{ 
		for (int j=0;j<ppSlots.length();j++) 
		{ 
			PlaneProfile& pp = ppSlots[j];
			//segs[j].vis(4); 
			Point3d ptSlot = pp.ptMid();
			Point3d pt1 = ptSlot - vecXT * .5 * pp.dX();pt1.vis(3);
			Point3d pt2 = ptSlot + vecXT * .5 * pp.dX();
		
		// dimpoints
			if (j==0 || j==1)
			{
				Point3d pt = pt1 - pp.coordSys().vecY() * .5 * pp.dY();
				Map m;
				m.setPoint3d("pt", pt);
				if (j==1)
					m.setString(kTextDelta, sDistributionText);
				//m.setString(kTextDelta, "<>");
				//m.setString(kTextCumm, "<>");
				//m.setInt("isRef", false);
				mapNodes.appendMap(kNode, m);
			}
			if (j==0 || j==ppSlots.length()-1)
			{
				Point3d pt = pt1 + pp.coordSys().vecY() * .5 * pp.dY();
				Map m;
				m.setPoint3d("pt", pt);
				
				mapNodes.appendMap(kNode, m);			
			}
			
			
			double dLength = pp.dX();//segs[j].length();
			if (dLength < dEps)continue;

		// create single instamce
			if (bEditInPlace)
			{ 
				Point3d ptsTsl[] = {ptSlot, pt1, pt2};
				dProps[0] = dLength;
				tslNew.dbCreate("hsbCLT-Slot" , vecXT ,vecYT,sips, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}
		// add tool	
			else
			{ 
				LineSeg segs[] = pp.splitSegments(LineSeg(pt1,pt2), true);
				dpLine.draw(segs);
				
				dpElement.draw(pp, _kDrawFilled, 90);
				dpElement.draw(pp);
				
				PlaneProfile pp2 = ppSection;
				pp2.transformBy(ptSlot - _Pt0);
				
				dpSection.color(nFace == -1 ? 5 : 40);
				dpSection.draw(pp2, _kDrawFilled, 90);
				dpSection.draw(pp2);
				dpSection.color(1);
				dpSection.draw(PLine(ptSlot, ptSlot+vecZT*dDepth));
				
				Slot slot(ptSlot, vecXT, vecYT, vecZT, dLength, dWidth, dDepth*2, 0, 0, 0);//nFace*nAlignment	
				slot.addMeToGenBeamsIntersect(sips);
				//slot.cuttingBody().vis(3);					

			}


		}//next j		
	}
	
	if (bEditInPlace)
	{ 
		eraseInstance();
		return;
	}
//endregion 


//region Map Requests
	Map mapRequests;

	Map mapRequest;
	mapRequest.setString("DimRequestPoint", "DimRequestPoint");
	mapRequest.setString("Stereotype", sStereotype);
	mapRequest.setString("ParentUID", sipRef.handle());
	mapRequest.setMap(kNodes,mapNodes);
	mapRequest.setInt("AlsoReverseDirection", true);
	mapRequest.setVector3d("vecDimLineDir", cs.vecY());//vecXT.crossProduct(-vecZ));(vecXT.crossProduct(-vecZ)).vis(ptLeftBottom, 7);
	if (nView == 0)
	{ 
		mapRequest.setVector3d("AllowedView", vecZ);	
		mapRequest.setVector3d("vecPerpDimLineDir",vecXT );
	}
	else
	{ 
		mapRequest.setVector3d("AllowedView", vecXT);
		mapRequest.setVector3d("vecPerpDimLineDir", nFace*vecZ);
	}
	mapRequests.appendMap("DimRequest",mapRequest);


// publish dim requests	
	if (mapRequests.length()>0)
	{
		_Map.setMap("DimRequest[]", mapRequests);	
	}
	else
		_Map.removeAt("DimRequest[]", true);





//endregion 


// Dialogs	
{ 

	
	
	
	
	
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	String sTriggerConfigShopdrawing= T("|Configure Shopdrawing|");
	addRecalcTrigger(_kContext, sTriggerConfigShopdrawing );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigShopdrawing)
	{
		mapTsl.setInt("DialogMode",1);
		
		sProps.append(sDistributionFormat);		
		sProps.append(sStereotype);	
		sProps.append(sViews[nView]);

		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				Map m;
			
				nView = sViews.find(tslDialog.propString(2));
				if (nView < 0)nView = 0;
			
				m.setString(kFormat, tslDialog.propString(0));
				m.setString(kStereotype, tslDialog.propString(1));
				m.setInt(kView, nView);
				mapSetting.setMap(kShopdrawing, m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
		
	}

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

//endregion	











#End
#BeginThumbnail
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
,@`H`*`"@`H`*`/_9



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
        <int nm="BreakPoint" vl="488" />
        <int nm="BreakPoint" vl="524" />
        <int nm="BreakPoint" vl="520" />
        <int nm="BreakPoint" vl="625" />
        <int nm="BreakPoint" vl="564" />
        <int nm="BreakPoint" vl="476" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20373 bugfix on insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/19/2023 8:30:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20373 sectional edits improved, distribution rules enhanced, new grips" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/17/2023 5:31:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14553 dimpoints patterns enhanced" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/2/2022 9:39:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14553 dimpoints published, new context command to configure shopdrawing" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/1/2022 10:29:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14429 inital version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/19/2022 2:49:53 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End