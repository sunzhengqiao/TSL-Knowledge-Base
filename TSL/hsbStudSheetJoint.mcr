#Version 8
#BeginDescription
#Versions:
1.4 21.01.2022 HSB-13970: support extrusionProfiles Author: Marsel Nakuci
1.3 24.11.2021 HSB-13646: fix painterstream index Author: Marsel Nakuci
1.2 23.11.2021 HSB-13646: add painter for beams to be excluded Author: Marsel Nakuci
1.1 09.11.2021 HSB-13597: fix investigation of sheet joint points, update blockings when studs are modified Author: Marsel Nakuci

This tsl creates studes at zone 0 of a wall at the position of sheet joints
user enters the desired width for the studs and the zones where the sheets will be investigated
For the sheets of selected zones, the tsl will find the places where sheets join with each other.
In those positions the tsl will create the beam with required width. If an existing stud is there,
the tsl will try to apply to it the required width.
If stud with required width collides with other studs, the tsl will try to move it
If this also fails it will try to apply width of existing beams



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords Tophat,joint,sheet,stud
#BeginContents
/// <History>//region
/// #Versions:
// Version 1.4 21.01.2022 HSB-13970: support extrusionProfiles Author: Marsel Nakuci
// Version 1.3 24.11.2021 HSB-13646: fix painterstream index Author: Marsel Nakuci
// Version 1.2 23.11.2021 HSB-13646: add painter for beams to be excluded Author: Marsel Nakuci
// Version 1.1 09.11.2021 HSB-13597: fix investigation of sheet joint points, update blockings when studs are modified Author: Marsel Nakuci
/// <version value="1.0" date="03dec20" author="marsel.nakuci@hsbcad.com"> HSB-9899: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates studes at zone 0 of a wall at the position of sheet joints
/// user enters the desired width for the studs and the zones where the sheets will be investigated
/// For the sheets of selected zones, the tsl will find the places where sheets join with each other.
/// In those positions the tsl will create the beam with required width. If an existing stud is there,
/// the tsl will try to apply to it the required width.
/// If stud with required width collides with other studs, the tsl will try to move it
/// If this also fails it will try to apply width of existing beams
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
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
	
//region properties
	// width
	String sWidthName=T("|Width|");
	// 0 means equal to width of existing beams
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	// zone to look for sheet connections
	String sZoneName=T("|Zones|");	
	PropString sZone(nStringIndex++, "", sZoneName);	
	sZone.setDescription(T("|Defines the Zones where the Sheeting will be redistributed \nZones must be separated with| ';'"));
	sZone.setCategory(category);
	
	// extrusion profile
	ExtrProfile sExtrusions[] = ExtrProfile().getAllEntries();
	String sExtrusionProfiles[]=ExtrProfile().getAllEntryNames();
//	sExtrusionProfiles.append(sExtrusions);
	if(sExtrusionProfiles.find(T("|Rectangular|"))>-1)
		sExtrusionProfiles.removeAt(sExtrusionProfiles.find(T("|Rectangular|")));
	if(sExtrusionProfiles.find(T("|Round|"))>-1)
		sExtrusionProfiles.removeAt(sExtrusionProfiles.find(T("|Round|")));
	sExtrusionProfiles.sorted();
	sExtrusionProfiles.insertAt(0,"<" + T("|Deactivated|")+">");
	String sExtrusionProfileName=T("|Extrusion Profile|");	
	PropString sExtrusionProfile(nStringIndex++, sExtrusionProfiles, sExtrusionProfileName);	
	sExtrusionProfile.setDescription(T("|Defines the ExtrusionProfile|"));
	sExtrusionProfile.setCategory(category);
	
	// painter definition
	category = T("|Painter|");
	String sPainterCollection = "hsbStudSheetJoint";
	String sAllowedPainterTypes[] = { "Beam", "GenBeam"};
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sPainterDefault = T("<|Disabled|>");
	sPainters.insertAt(0, sPainterDefault);
	for (int i=sPainters.length()-1; i>=0 ; i--) 
	{ 
		String sPainter = sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0 || sPainter.find(sPainterDefault,0,false)>-1)
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
	String sPaintersBeam[0];sPaintersBeam.append(sPainters);
	
	String sPainterBeamStreamName=T("|Painter Definition|");	
	PropString sPainterBeamStream(nStringIndex++, "", sPainterBeamStreamName);	
	sPainterBeamStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sPainterBeamStream.setCategory(category);
	sPainterBeamStream.setReadOnly(bDebug?0:_kHidden);
//End properties//endregion 

// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{ 
	// collect streams	
		String streams[0];
		String sScriptOpmName = bDebug?"hsbStudSheetJoint":scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		int iStreamIndices[] ={2};
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
				if(iStreamIndices.find(index)>-1 && streams.findNoCase(stream,-1)<0)
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
					if(!pd.bIsValid())
					{ 
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
	}
	
	String sReferences[0];
	for (int i=0;i<sPainters.length();i++) 
	{ 
		String entry = sPainters[i];
		entry = entry.right(entry.length() - sPainterCollection.length()-1);	
		if (sReferences.findNoCase(entry,-1)<0)
			sReferences.append(entry);
	}//next i
	sReferences.insertAt(0, sPainterDefault);
	
	String sPainterBeamName=T("|Studs|");	
	PropString sPainterBeam(nStringIndex++, sReferences, sPainterBeamName);	
	sPainterBeam.setDescription(T("|Defines the Painter filter for Beams that are excluded.|"));
	sPainterBeam.setCategory(category);
	
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
		
	// prompt element selections
		PrEntity ssE(T("|Select elements|"), Element());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={}; 
		double dProps[]={dWidth}; 
		String sProps[]={sZone,sExtrusionProfile, sPainterBeamStream,sPainterBeam};
		Map mapTsl;
		
		for (int i=0;i<_Element.length();i++) 
		{ 
			entsTsl.setLength(0);
			entsTsl.append(_Element[i]);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion
//	return
	int iExtrusionProfile = sExtrusionProfiles.find(sExtrusionProfile);
	if(sReferences.find(sPainterBeam)<0)
		sPainterBeam.set(sReferences[0]);
	
	if (_Element.length() != 1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|one element is needed|"));
		eraseInstance();
		return;
	}
//	return
	Element el = _Element[0];
	Point3d ptOrg = el.ptOrg();
	Vector3d vecX = el.vecX();	
	Vector3d vecY = el.vecY();	
	Vector3d vecZ = el.vecZ();
	
	_Pt0 = ptOrg;
	
	Display dp(1);
	dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
	
//region selected zones
	int iZones[0];
	String sZoneTrim = sZone;
	// removes newline, space, and tab characters
	sZoneTrim.trimLeft();
	sZoneTrim.trimRight();
	if(sZoneTrim!="")
	{ 
		String sZoneI = "";
		for (int i=0;i<sZoneTrim.length();i++) 
		{ 
			char charI = sZoneTrim.getAt(i);
			String si = "" + charI;
			if(si!=";")
			{ 
				sZoneI += charI;
			}
			else
			{ 
				iZones.append(sZoneI.atoi());
				sZoneI = "";
			}
		}//next i
		if(sZoneI!="")
		{ 
			iZones.append(sZoneI.atoi());
		}
	}
	else
	{ 
		// if empty, then get all zones in consideration
		int _iZones[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 0, 1, 2, 3, 4, 5};
		iZones = _iZones;
	}
	
	// fix according to -5,-4,-3,-2,-1,0,1,2,3,4,5 from 10,9,8,7,6,5,4,3,2,1,0
	for (int i=iZones.length()-1; i>=0 ; i--) 
	{ 
		if(iZones[i]>5 && iZones[i]<11)
		{ 
			iZones[i] = -(iZones[i] - 5);
		}
		else if(abs(iZones[i])<6)
		{ 
			//-5;5
			continue;
		}
		else
		{ 
			// not allowed
			iZones.removeAt(i);
		}
	}//next i
	
	// remove duplicated
	int iZonesCopy[0];
	iZonesCopy.append(iZones);
	iZones.setLength(0);
	
	for (int i = 0; i < iZonesCopy.length(); i++)
	{ 
		if (iZones.find(iZonesCopy[i]) < 0)
		{
			iZones.append(iZonesCopy[i]);
		}
	}//next i
	
	// leave only those that contain sheets
	for (int i=iZones.length()-1; i>=0 ; i--) 
	{ 
		Sheet sh[] = el.sheet(iZones[i]);
		if (sh.length() == 0)
		{ 
			iZones.removeAt(i);
		}
	}//next i
//End selected zones//endregion
	
	// plane at zone 0
	Plane pn0(el.zone(0).ptOrg(), vecZ);
//	pn0.vis(4);
	// all beams at zone 0
	PlaneProfile pp0(pn0);
	// only studs
	PlaneProfile pp0Studs(pn0);
	// envelope of vertical studs
	PlaneProfile pp0StudsEnvelope(pn0);
	// only the outter contour envelope of all beams
	PlaneProfile pp0NoOpening(pn0);
	// planeprofile of only openings
	PlaneProfile ppOpenings(pn0);
	
	Opening ops[] = el.opening();
	for (int iOp=0;iOp<ops.length();iOp++) 
		ppOpenings.joinRing(ops[iOp].plShape(), _kAdd);
	
	ppOpenings.vis(9);
	Beam beams[] = el.beam();
	// beams to be excluded
	Beam beamsExclude[0];
	if(beams.length()==0)
		return;
	
	PainterDefinition pdBeam;
	if(sPainterBeam!=sPainterDefault)
	{ 
		beamsExclude.append(el.beam());
		pdBeam=PainterDefinition (sPainterCollection+"\\" + sPainterBeam);
		if(pdBeam.bIsValid())
		{ 
			beamsExclude = pdBeam.filterAcceptedEntities(beamsExclude);
		}
	}
//	for (int ib=beams.length()-1; ib>=0 ; ib--) 
//	{ 
//		if(beamsExclude.find(beams[ib])>-1)
//			beams.removeAt(ib);
//		
//	}//next ib
	
	
	
	if (pdBeam.bIsValid())
	{ 
		Map m;
		m.setString("Name", pdBeam.name());
		m.setString("Type",pdBeam.type());
		m.setString("Filter",pdBeam.filter());
		m.setString("Format",pdBeam.format());
		sPainterBeamStream.set(m.getDxContent(true));
	}
	_ThisInst.setCatalogFromPropValues(sLastInserted);
	
	for (int i=beams.length()-1; i>=0 ; i--) 
	{
		if (beams[i].myZoneIndex() != 0)
		{
			beams.removeAt(i);
			continue;
		}
//		beams[i].envelopeBody(false, true).vis(4);
		pp0.unionWith(beams[i].envelopeBody(true, true).shadowProfile(pn0));
		if (beams[i].vecX().isPerpendicularTo(vecY))continue;
		// HSB-13597
		if (!beams[i].vecX().isPerpendicularTo(vecX))continue;
		pp0Studs.unionWith(beams[i].envelopeBody(true, true).shadowProfile(pn0));
	}
	
	Beam beamsStud[0];beamsStud.append(beams);
	beamsStud = vecX.filterBeamsPerpendicularSort(beamsStud);
	
	{ 
		// get extents of profile
		LineSeg seg = pp0Studs.extentInDir(vecX);
		PLine pl(vecZ);
		pl.createRectangle(seg, vecX, vecY);
		pp0StudsEnvelope.joinRing(pl, _kAdd);
	}
	
	PLine pls[] = pp0.allRings(true, false);
//	int iRings[] = pp0.ringIsOpening();
	for (int i=0;i<pls.length();i++) 
		pp0NoOpening.joinRing(pls[i], _kAdd);
	
	Point3d ptExtremeLeft, ptExtremeRight;
	// get extents of profile
	{
		LineSeg seg = pp0NoOpening.extentInDir(vecX);
		ptExtremeLeft = seg.ptStart();
		ptExtremeRight = seg.ptEnd();
		if(vecX.dotProduct(ptExtremeRight-ptExtremeLeft)<0)
		{ 
			ptExtremeLeft = seg.ptEnd();
			ptExtremeRight = seg.ptStart();
		}
	}
	
//	pp0NoOpening.vis(5);
	pp0Studs.vis(3);
//pp0.vis(3);
	
	// get initial point for each zone
	PLine plWall = el.plEnvelope();
//	plWall.vis(4);
	PlaneProfile ppWall(plWall);
	// get extents of profile
	LineSeg seg = ppWall.extentInDir(vecX);
	
//	Point3d ptInitials[0];
//	for (int ii=0;ii<iZones.length();ii++) 
//	{ 
//		ptInitials.append(seg.ptEnd() + vecX * U(1000));
//		ptInitials[ii].vis(3+ii);
//	}//next ii
	
	Line lnX(ptOrg, vecX);
	
	//  HSB-13597: collect modified or new created studs
	Beam bmStudsModified[0];
//	return
	// do for each choosen zone
	for (int ii = 0; ii < iZones.length(); ii++)
	{
		int nZone = iZones[ii];
		ElemZone elzo = el.zone(nZone);
		PlaneProfile pp(elzo.coordSys());
		
		Sheet sh[] = el.sheet(nZone);
		Point3d ptsJoint[0];
		// HSB-13597 collect all joint points
		for (int ish=0;ish<sh.length()-1;ish++) 
		{ 
			Sheet shI = sh[ish]; 
			PlaneProfile ppI(pn0);
			ppI.joinRing(shI.plEnvelope(), _kAdd);
//			ppI.vis(1);
			ppI.shrink(-dEps);
			for (int jsh=ish+1;jsh<sh.length();jsh++) 
			{ 
				Sheet shJ = sh[jsh];
				PlaneProfile ppJ(pn0);
				ppJ.joinRing(shJ.plEnvelope(), _kAdd);
				ppJ.shrink(-dEps);
//				ppJ.vis(2);
				PlaneProfile ppIntersectIj = ppI;
				int iIntersectIj=ppIntersectIj.intersectWith(ppJ);
				if(!iIntersectIj)
				{ 
					continue;
				}
				else
				{ 
				// get extents of profile
					LineSeg segInter = ppIntersectIj.extentInDir(vecX);
					double dX = abs(vecX.dotProduct(segInter.ptStart()-segInter.ptEnd()));
					double dY = abs(vecY.dotProduct(segInter.ptStart()-segInter.ptEnd()));
					if (dX < dEps || dY < U(1))continue;
					
					ptsJoint.append(segInter.ptMid());
				}
			}//next jsh
		}//next ish
		
		
//		for (int i = 0; i < sh.length(); i++)
//		{ 
//			PLine plSheetEnv = sh[i].plEnvelope();
//			Point3d pts[] = plSheetEnv.vertexPoints(true);
//			
//			for (int iP=0;iP<pts.length();iP++) 
//			{ 
////				if(abs(vecX.dotProduct(ptExtremeLeft-pts[iP]))<10*dEps || vecX.dotProduct(ptExtremeLeft-pts[iP])>0
////				|| abs(vecX.dotProduct(pts[iP]-ptExtremeRight))<10*dEps || vecX.dotProduct(pts[iP]-ptExtremeRight)>0)
////				{ 
////					continue;
////				}
////				else
//				{ 
//					ptsJoint.append(pts[iP]);
//				}
//			}//next iP
//		}
		ptsJoint = lnX.projectPoints(ptsJoint);
		ptsJoint = lnX.orderPoints(ptsJoint, 100 * dEps);
		// remove first and last
//		ptsJoint.removeAt(ptsJoint.length() - 1);
//		ptsJoint.removeAt(0);
		for (int iP = 0; iP < ptsJoint.length(); iP++)
		{
			ptsJoint[iP].vis(iP);
		}
		for (int iP=0;iP<ptsJoint.length();iP++) 
		{ 
//			ptsJoint[iP].vis(4);
			// 
			double dWidthBeam = beamsStud[0].dD(vecX);
			if (dWidth > 0)dWidthBeam = dWidth;
			double dHeightBeam = beamsStud[0].dD(vecZ);
			
			PLine pl(vecZ), plExisting(vecZ);
			{ 
				LineSeg lSeg(ptsJoint[iP] - vecX * .5 * dWidthBeam - vecY * U(10e4),
						 ptsJoint[iP] + vecX * .5 * dWidthBeam + vecY * U(10e4));
				pl.createRectangle(lSeg, vecX, vecY);

				LineSeg lSegExisting(ptsJoint[iP] - vecX * .5 * beamsStud[0].dD(vecX) - vecY * U(10e4),
						 ptsJoint[iP] + vecX * .5 * beamsStud[0].dD(vecX) + vecY * U(10e4));
				plExisting.createRectangle(lSegExisting, vecX, vecY);
				plExisting.vis(4);
			}
			
			PlaneProfile ppNew(pn0), ppNewExisting(pn0);
			ppNew.joinRing(pl, _kAdd);
			ppNew.intersectWith(pp0StudsEnvelope);
			ppNew.vis(2);
			ppNewExisting.joinRing(plExisting, _kAdd);
			ppNewExisting.intersectWith(pp0StudsEnvelope);
//			ppNewExisting.transformBy(vecY * U(400));
			ppNewExisting.vis(6);
//			ppNewExisting.transformBy(vecY * U(-400));
			
			PLine plThin(vecZ);
			{ 
				LineSeg lSeg(ptsJoint[iP] - vecX * .5 * dEps - vecY * U(10e4),
						 ptsJoint[iP] + vecX * .5 * dEps + vecY * U(10e4));
				plThin.createRectangle(lSeg, vecX, vecY);
			}
			PlaneProfile ppNewThin(pn0);
			ppNewThin.joinRing(plThin, _kAdd);
			ppNewThin.intersectWith(pp0StudsEnvelope);
			ppNewThin.vis(4);
			
			int iOk;
			// 1- check if existing beam found
			int iExistingFound;
			Beam bmExisting;
			for (int iStud = 0; iStud < beamsStud.length(); iStud++)
			{ 
				PlaneProfile ppIstud(pn0);
				ppIstud.unionWith(beamsStud[iStud].envelopeBody(true, true).shadowProfile(pn0));
				PlaneProfile ppIntersectThin = ppNewThin;
				if(ppIntersectThin.intersectWith(ppIstud))
				{ 
					// existing beam found
					iExistingFound = true;
					bmExisting = beamsStud[iStud];
					String sExtrI = bmExisting.extrProfile();
					// flag to know if found beam is extrusion or not
					int iExtrProfileI = (sExtrI != T("|Rectangular|") && sExtrI != T("|Round|"));
					// 
					// without existing beam
					PlaneProfile pp0StudsRest = pp0Studs;
					pp0StudsRest.subtractProfile(bmExisting.envelopeBody(true, true).shadowProfile(pn0));
					double dWidthExisting = bmExisting.dD(vecX);
//					if(dWidth!=0)
//						bmExisting.setD(vecX, dWidth);
					// pp with new width
					PlaneProfile ppIstudNew(pn0);
					if ((dWidth > 0  && !iExtrProfileI)
					|| (dWidth>0 && iExtrusionProfile==0))
					{ 
						// its rectangular or round and width is defined, use width
						// get extents of profile
						LineSeg seg = ppIstud.extentInDir(vecX);
						double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
						PLine pl(vecZ);
						pl.createRectangle(LineSeg(seg.ptMid() - .5 * dWidth * vecX - .5 * dY * vecY, 
											seg.ptMid() + .5 * dWidth * vecX + .5 * dY * vecY), vecX, vecY);
						ppIstudNew.joinRing(pl, _kAdd);
					}
					else if((dWidth <=0 && iExtrusionProfile!=0) || (iExtrusionProfile!=0 && iExtrProfileI))
					{ 
						// use plane profile
						PlaneProfile ppExtr = ExtrProfile(sExtrusionProfile).planeProfile();
						LineSeg seg = ppExtr.extentInDir(vecX);
						double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
						PLine pl(vecZ);
						pl.createRectangle(LineSeg(seg.ptMid() - .5 * dWidth * vecX - .5 * dY * vecY, 
											seg.ptMid() + .5 * dWidth * vecX + .5 * dY * vecY), vecX, vecY);
						ppIstudNew.joinRing(pl, _kAdd);
						
					}
					ppIstudNew.vis(4);
					
					// check if new dimension intersect existing beam
//					ppIstud = PlaneProfile(pn0);
//					ppIstud.unionWith(bmExisting.envelopeBody(true, true).shadowProfile(pn0));
//					ppIntersect = ppIstud;
					PlaneProfile ppIntersect = ppIstudNew;
					PlaneProfile pp0StudsRestOp = pp0StudsRest;
					pp0StudsRestOp.unionWith(ppOpenings);
//					ppIntersect.vis(1);
					pp0StudsRestOp.vis(5);
					if(!ppIntersect.intersectWith(pp0StudsRestOp))
					{ 
						// no intersection, change the width
						if(dWidth>0 || iExtrusionProfile!=0)
						{
							if (beamsExclude.find(bmExisting) >- 1)continue;
							if((iExtrProfileI && iExtrusionProfile!=0) || (dWidth<=0 && iExtrusionProfile!=0))
							{ 
								bmExisting.setExtrProfile(sExtrusionProfile);
							}
							else if(dWidth>0 && !iExtrProfileI)
							{
								bmExisting.setD(vecX, dWidth);
							}
							else if(dWidth>0 && iExtrProfileI && iExtrusionProfile==0)
							{ 
								bmExisting.setExtrProfile(ExtrProfile(T("|Rectangular|")));
								bmExisting.setD(vecX, dWidth);
							}
							if (bmStudsModified.find(bmExisting) < 0)bmStudsModified.append(bmExisting);
						}
					}
					else
					{ 
						// intersects
						if (ppIntersect.numRings() > 1)
						{ 
							// keep existing width
//							bmExisting.setD(vecX, dWidthExisting);
						}
						else
						{ 
							// displace
							if (beamsExclude.find(bmExisting) >- 1)continue;
							Vector3d vecDisplace = vecX;
							Point3d ptIntersect;
							{
								// get extents of profile
								LineSeg seg = ppIntersect.extentInDir(vecX);
								ptIntersect = seg.ptMid();
								double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
								vecDisplace *= dX;
							}
							if (vecDisplace.dotProduct(ptIntersect - ptsJoint[iP]) > 0)vecDisplace *= -1;
							ppIntersect = ppIstudNew;
							// displace plane profile
							ppIntersect.transformBy(vecDisplace);
							if(!ppIntersect.intersectWith(pp0StudsRestOp))
							{ 
								// no intersection from planeprofile, displace the beam
								bmExisting.transformBy(vecDisplace);
								if(dWidth!=0)
								{
									bmExisting.setD(vecX, dWidth);
									if (bmStudsModified.find(bmExisting) < 0)bmStudsModified.append(bmExisting);
								}
							}
						}
					}
					// existing beam was found
					// dont break there can be more than one beam
//					break;
				}
			}//next iStud
			if(iExistingFound)
			{ 
				// go to next point
				continue;
			}
			// 2-no beam found, create new and check if it collides with existing beams
			int iIntersectStudExisting;
			{ 
				PlaneProfile _pp0Studs = pp0Studs;
				PlaneProfile ppIntersect = ppNew;
				PlaneProfile ppIntersectOp = ppNew;
				ppNew.transformBy(vecY * U(400));
//				ppNew.vis(5);
				ppNew.transformBy(vecY * U(-400));
				
				if(!ppIntersect.intersectWith(pp0Studs) && !ppIntersectOp.intersectWith(ppOpenings))
				{ 
					// no intersection with studs and opening, create stud
					PLine pls[] = ppNew.allRings();
					if(pls.length()==0)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
						eraseInstance();
						return;
					}
					Body bd(pls[0], vecZ * dHeightBeam);
					if(!_bOnDebug)
					{ 
						Beam bmNew;
						bmNew.dbCreate(bd, beamsStud[0].vecX(), beamsStud[0].vecY(), beamsStud[0].vecZ());
						bmNew.setMaterial(beamsStud[0].material());
						bmNew.assignToElementGroup(el, true, 0, 'Z');
		//				bmNew.setColor(beamsStud[0].color());
						bmNew.setColor(1);
						if(dWidth<=0 && iExtrusionProfile)
						{ 
							// 
							bmNew.setExtrProfile(sExtrusionProfile);
						}
						if (bmStudsModified.find(bmNew) < 0)bmStudsModified.append(bmNew);
					}
					
					// go to next point
					continue;
				}
				else
				{ 
					// try to create and move it
					ppIntersect = ppNew;
					PlaneProfile pp0StudsRestOp = pp0Studs;
					pp0StudsRestOp.unionWith(ppOpenings);
					if(ppIntersect.intersectWith(pp0StudsRestOp))
					{ 
						ppIntersect = ppNew;
						ppIntersect.subtractProfile(pp0);
						ppIntersect.subtractProfile(ppOpenings);
						if (ppIntersect.numRings() > 1)
						{ 
							// keep existing width
//							bmExisting.setD(vecX, dWidthExisting);
							ppIntersect = ppNew;
							ppIntersect.transformBy(vecY * U(400));
							ppIntersect.vis(5);
							ppIntersect.transformBy(vecY * U(-400));
							if(!ppIntersect.intersectWith(pp0Studs))
							{ 
								ppIntersect = ppNew;
								ppIntersect.subtractProfile(pp0);
								if(ppIntersect.subtractProfile(ppOpenings))
								{ 
									PLine pls[] = ppIntersect.allRings();
									if(pls.length()==0)
									{ 
										reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
										eraseInstance();
										return;
									}
									for (int iPl=0;iPl<pls.length();iPl++) 
									{ 
										Body bd(pls[iPl], vecZ * dHeightBeam);
										if(!_bOnDebug)
										{ 
											Beam bmNew;
											bmNew.dbCreate(bd, beamsStud[0].vecX(), beamsStud[0].vecY(), beamsStud[0].vecZ());
											bmNew.setMaterial(beamsStud[0].material());
											bmNew.assignToElementGroup(el, true, 0, 'Z');
							//				bmNew.setColor(beamsStud[0].color());
											bmNew.setColor(1);
											if(dWidth<=0 && iExtrusionProfile)
											{ 
												// 
												bmNew.setExtrProfile(sExtrusionProfile);
											}
											if (bmStudsModified.find(bmNew) < 0)bmStudsModified.append(bmNew);
										}
									}//next iPl
								}
							}
						}
						else
						{ 
							ppIntersect = ppNew;
							ppIntersect.intersectWith(pp0StudsRestOp);
							// displace
							Vector3d vecDisplace = vecX;
							Point3d ptIntersect;
							{
								// get extents of profile
								LineSeg seg = ppIntersect.extentInDir(vecX);
								ptIntersect = seg.ptMid();
								double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
								vecDisplace *= dX;
							}
							if (vecDisplace.dotProduct(ptIntersect - ptsJoint[iP]) > 0)vecDisplace *= -1;
							PlaneProfile ppNewDisplace = ppNew;
							ppNewDisplace.transformBy(vecDisplace);
							ppIntersect = ppNewDisplace;
							if (!ppIntersect.intersectWith(pp0StudsRestOp))
							{ 
								// displaced planeprofile dont intersect, create beam
								PLine pls[] = ppNew.allRings();
								Body bd(pls[0], vecZ * dHeightBeam);
								if ( ! _bOnDebug)
								{ 
									Beam bmNew;
									bmNew.dbCreate(bd, beamsStud[0].vecX(), beamsStud[0].vecY(), beamsStud[0].vecZ());
									bmNew.setMaterial(beamsStud[0].material());
									bmNew.assignToElementGroup(el, true, 0, 'Z');
					//				bmNew.setColor(beamsStud[0].color());
									bmNew.setColor(1);
									bmNew.transformBy(vecDisplace);
									if(dWidth<=0 && iExtrusionProfile)
									{ 
										// 
										bmNew.setExtrProfile(sExtrusionProfile);
									}
									if (bmStudsModified.find(bmNew) < 0)bmStudsModified.append(bmNew);
								}
								// next point
								continue
							}
							else if (dWidth > beamsStud[0].dD(vecX))
							{ 
								// try original dimensions dWidthExisting
								ppIntersect = ppNewExisting;
								ppIntersectOp = ppNewExisting;
								if(!ppIntersect.intersectWith(pp0Studs) && !ppIntersectOp.intersectWith(ppOpenings))
								{ 
									// no intersection with studs and opening, create stud
									PLine pls[] = ppNewExisting.allRings();
									if(pls.length()==0)
									{ 
										reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
										eraseInstance();
										return;
									}
									Body bd(pls[0], vecZ * dHeightBeam);
									if(!_bOnDebug)
									{ 
										Beam bmNew;
										bmNew.dbCreate(bd, beamsStud[0].vecX(), beamsStud[0].vecY(), beamsStud[0].vecZ());
										bmNew.setMaterial(beamsStud[0].material());
										bmNew.assignToElementGroup(el, true, 0, 'Z');
						//				bmNew.setColor(beamsStud[0].color());
										bmNew.setColor(1);
										if(dWidth<=0 && iExtrusionProfile)
										{ 
											// 
											bmNew.setExtrProfile(sExtrusionProfile);
										}
										if (bmStudsModified.find(bmNew) < 0)bmStudsModified.append(bmNew);
									}
									// go to next point
									continue;
								}
								else
								{ 
									// try displace
									ppIntersect = ppNewExisting;
									PlaneProfile pp0StudsRestOp = pp0Studs;
									pp0StudsRestOp.unionWith(ppOpenings);
									if (ppIntersect.intersectWith(pp0StudsRestOp))
									{
										if (ppIntersect.numRings() > 1)
										{
											// keep existing width
											//							bmExisting.setD(vecX, dWidthExisting);
										}
										else
										{
											// displace
											Vector3d vecDisplace = vecX;
											Point3d ptIntersect;
											{
												// get extents of profile
												LineSeg seg = ppIntersect.extentInDir(vecX);
												ptIntersect = seg.ptMid();
												double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
												vecDisplace *= dX;
											}
											if (vecDisplace.dotProduct(ptIntersect - ptsJoint[iP]) > 0)vecDisplace *= -1;
											PlaneProfile ppNewDisplace = ppNewExisting;
											ppNewDisplace.transformBy(vecDisplace);
											ppIntersect = ppNewDisplace;
											if ( ! ppIntersect.intersectWith(pp0StudsRestOp))
											{
												// displaced planeprofile dont intersect, create beam
												PLine pls[] = ppNewExisting.allRings();
												Body bd(pls[0], vecZ * dHeightBeam);
												if ( ! _bOnDebug)
												{
													Beam bmNew;
													bmNew.dbCreate(bd, beamsStud[0].vecX(), beamsStud[0].vecY(), beamsStud[0].vecZ());
													bmNew.setMaterial(beamsStud[0].material());
													bmNew.assignToElementGroup(el, true, 0, 'Z');
													//				bmNew.setColor(beamsStud[0].color());
													bmNew.setColor(1);
													bmNew.transformBy(vecDisplace);
													if(dWidth<=0 && iExtrusionProfile)
													{ 
														// 
														bmNew.setExtrProfile(sExtrusionProfile);
													}
													if (bmStudsModified.find(bmNew) < 0)bmStudsModified.append(bmNew);
												}
												// next point
												continue;
											}
										}
									}
								}
							}
						}
					}
					continue;
				}
			}
		}//next iP
	}
//	return
	// check if not vertical beams or blockings intersect the modified/new studs
	// fix blocking cuts
//region  HSB-13597 fix horizontal beams
	PlaneProfile pp0NotStuds(pn0);
	for (int i=0;i<beams.length();i++) 
	{ 
		Beam bmI = beams[i];
		// not studs
		Beam tBeams[] = bmI.filterBeamsTConnection(bmStudsModified, U(20), true);
		if (tBeams.length() == 0)
		{
			continue;
		}
		else
		{ 
			bmI.stretchDynamicTo(tBeams[0]);
		}
	}//next i
	
//endregion //End fix horizontal beams
	eraseInstance();
	return;




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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="695" />
        <int nm="BreakPoint" vl="579" />
        <int nm="BreakPoint" vl="632" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13646: fix painterstream index" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/24/2021 1:25:58 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13646: add painter for beams to be excluded" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="11/23/2021 3:07:09 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13597: fix investigation of sheet joint points, update blockings when studs are modified" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="11/9/2021 2:02:25 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End