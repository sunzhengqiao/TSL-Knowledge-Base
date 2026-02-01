#Version 8
#BeginDescription
#Versions
1.7 08.02.2021 HSB-10652 straight segments of defining polyline not excluded , Author Thorsten Huck
1.6 08.02.2021 
HSB-10652 bugfix tool orientation. Tool definitions can be edited via context commands , Author Thorsten Huck
HSB-10496 visualization improved
HSB-10496 new tool definition to support various alignments

bugfix tool assignment
bugfix polyline projection to surface

This tsl creates a propeller surface tool based on two polylines.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <History>//region
// #Versions
// 1.7 08.02.2021 HSB-10652 straight segments of defining polyline not excluded , Author Thorsten Huck
// 1.6 08.02.2021 HSB-10652 bugfix tool orientation. Tool definitions can be edited via context commands , Author Thorsten Huck
// 1.5 31.01.2021 HSB-10496 visualization improved , Author Thorsten Huck
// 1.4 29.01.2021 HSB-10496 new tool definition to support various alignments , Author Thorsten Huck

/// <version value="1.3" date="19sep2018" author="thorsten.huck@hsbcad.com"> bugfix tool assignment </version>
/// <version value="1.2" date="12mar2018" author="thorsten.huck@hsbcad.com"> bugfix polyline projection to surface </version>
/// <version value="1.1" date="19nov2017" author="thorsten.huck@hsbcad.com"> bugfix tool side, new property tool type, single polyline definition supported </version>
/// <version value="1.0" date="22feb2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity and one or two polylines, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a propeller surface tool based on two polylines.
/// Polylines which are not drawn parallel to the XY-plane of the panel will be projected to the upper and lower surface
/// of the panel.
/// </summary>//endregion


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

//region Variables
	String sDimStyle = _DimStyles.first();
	
	int green = rgb(0,158,0);
	int red = rgb(205,32,39);
	int blue = rgb(0, 102, 204);
	int ncDefining = red, ncBevel=green, nt = 50;
	double dTextHeight = U(50);
//End Variables//endregion 


//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-Freeprofile";
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

//region Variables
// default modes, not used as soon as settings or opmKey catalogs are found	
	String sDefaultModes[] = {T("|Finger Mill|"),T("|Universal Mill|"),T("|Vertical Finger Mill|")};
	double sDefaultDiameters[0];
	double sDefaultLengths[0];
	int nDefaultModes[0];
	if (mapSetting.length()<1)
	{ 
		PLine pl(_Pt0, _Pt0 + _XW * U(100));
		for (int i=0;i<sDefaultModes.length();i++) 
		{ 
			FreeProfile fp(pl,_kLeft);
			fp.setCncMode(i);
			sDefaultDiameters.append(fp.millDiameter());
			sDefaultLengths.append(0);
			nDefaultModes.append(i);			 
		}//next i		
	}
//End variables//endregion 


//region Read Settings
	String sToolNames[0];
	double dDiameters[0];
	double dLengths[0];
	int nToolIndices[0];
{
	String k;
	
	// Settings approach (1)
	Map m, mapTools = mapSetting.getMap("Tool[]");
	for (int i = 0; i < mapTools.length(); i++)
	{
		Map m = mapTools.getMap(i);
		
		String name;
		int index, bOk = true;
		double diameter, length;
		k = "Diameter";		if (m.hasDouble(k) && m.getDouble(k) > 0)	diameter = m.getDouble(k);	else bOk = false;
		k = "Length";			if (m.hasDouble(k) && m.getDouble(k) > 0)	length = m.getDouble(k);	else bOk = false;
		k = "Name";			if (m.hasString(k))	name = m.getString(k);		else bOk = false;
		k = "ToolIndex";		if (m.hasInt(k))	index = m.getInt(k); 		else bOk = false;
		
		if (bOk && sToolNames.find(name) < 0 && nToolIndices.find(index) < 0)
		{
			sToolNames.append(name);
			nToolIndices.append(index);
			dDiameters.append(diameter);
			dLengths.append(length);
		}
	}//next i
}
//End Read Settings//endregion 



//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1)
		{
			category = T("|Display|");
			setOPMKey("Display");
			String spDimStyleName=T("|Dimstyle|");	
			PropString spDimStyle(nStringIndex++, _DimStyles.sorted(), spDimStyleName);	
			spDimStyle.setDescription(T("|Defines the DimStyle|"));
			spDimStyle.setCategory(category);
			
			String spTextHeightName=T("|Text Height|");	
			PropDouble dpTextHeight(nDoubleIndex++, U(50), spTextHeightName);	
			dpTextHeight.setDescription(T("|Defines the TextHeight|"));
			dpTextHeight.setCategory(category);
			
			String sColorName=T("|Color Defining|");	
			PropInt nColor(nIntIndex++, ncDefining, sColorName);	
			nColor.setDescription(T("|Defines the Color of the defining polyline|"));
			nColor.setCategory(category);
			
			String sColorBevName=T("|Color Bevel|");	
			PropInt nColorBev(nIntIndex++, ncBevel, sColorBevName);	
			nColorBev.setDescription(T("|Defines the Color of the secondary polyline|"));
			nColorBev.setCategory(category);			
			
			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, nt, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the transparency|"));
			nTransparency.setCategory(category);			
		}
		else if (nDialogMode == 2)
		{
			category = T("|Tool Definition|");
			setOPMKey("Edit");	
			
			String sDiameterName=T("|Diameter|");	
			PropDouble dDiameter(nDoubleIndex++, U(0), sDiameterName);	
			dDiameter.setDescription(T("|Defines the diameter of the tool|"));
			dDiameter.setCategory(category);
			
			String sLengthName=T("|Length|");	
			PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
			dLength.setDescription(T("|Defines the length of the tool|"));
			dLength.setCategory(category);
			
			String sToolIndexName=T("|ToolIndex|");	
			PropInt nToolIndex(nIntIndex++, 2, sToolIndexName);	
			nToolIndex.setDescription(T("|Defines the toolindex|"));
			nToolIndex.setCategory(category);
			
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, sToolNames, sNameName);	
			sName.setDescription(T("|Defines the name of the tool|"));
			sName.setCategory(category);
			sName.setReadOnly(true);
		}	
		else if (nDialogMode == 3)
		{
			category = T("|Tool Definition|");
			setOPMKey("Add");	
			
			String sDiameterName=T("|Diameter|");	
			PropDouble dDiameter(nDoubleIndex++, U(0), sDiameterName);	
			dDiameter.setDescription(T("|Defines the diameter of the tool|"));
			dDiameter.setCategory(category);
			
			String sLengthName=T("|Length|");	
			PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
			dLength.setDescription(T("|Defines the length of the tool|"));
			dLength.setCategory(category);
			
			String sToolIndexName=T("|ToolIndex|");	
			PropInt nToolIndex(nIntIndex++, 2, sToolIndexName);	
			nToolIndex.setDescription(T("|Defines the toolindex|"));
			nToolIndex.setCategory(category);
			
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, T("|Name of Tool|"), sNameName);	
			sName.setDescription(T("|Defines the name of the tool|"));
			sName.setCategory(category);
		}
		else if (nDialogMode == 4)
		{
			category = T("|Tool Definition|");
			setOPMKey("Remove");	
			
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, sToolNames, sNameName);	
			sName.setDescription(T("|Defines the name of the tool to be removed|"));
			sName.setCategory(category);
		}		
		return;
	}
//End DialogMode//endregion 






//region Properties
	category = T("|Tool|");
	String sToolNameName=T("|Tool|");
	PropString sToolName(nStringIndex++, sToolNames.sorted(), sToolNameName);
	sToolName.setDescription(T("|Defines the CNC Tool|"));
	sToolName.setCategory(category);
	if (sToolNames.findNoCase(sToolName,-1)<0 && sToolNames.length()>0)
	{ 
		sToolName.set(sToolNames.first());
		reportMessage("\n" + scriptName() + ": " +T("|Tool definition not found, changed to| "+sToolName));
	}	
	
	String sAlignments[] ={ T("|Automatic|"), T("|Left|"), T("|Center|"), T("|Right|")};
	int nAlignments[] ={-2, _kLeft, _kCenter, _kRight};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	int nAlignment = sAlignments.find(sAlignment, 0);
	int nMillSide = nAlignment<0?-2:nAlignments[nAlignment];

	
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
		
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());	
	
	// collect polylines
		PrEntity ssEpl(T("|Select polylines|"), EntPLine());
		EntPLine epls[0];
		PLine plines[0];
	  	if (ssEpl.go())
		{
			Entity ents[0];
			ents.append(ssEpl.set());	
			for (int i=0;i<ents.length();i++) 
			{ 
				EntPLine epl= (EntPLine)ents[i]; 
				if (!epl.bIsValid()){ continue;}
				PLine pl = epl.getPLine(); 
				Point3d pts[] = pl.vertexPoints(false);
				if (pts.length() < 2)continue;
				
			// exclude closed plines
				int bIsClosed = Vector3d(pts[0] - pts[pts.length() - 1]).length() < dEps;			
				int bIsStraight = pl.isOn((pts[0] + pts[1]) / 2);			
				if (bIsClosed)
					reportMessage(TN("|Closed polyline not allowed as tool definition|"));					
				else
				{
					epls.append(epl);
					plines.append(pl);
				}
			}//next i
		}		
		if (epls.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + T("|Invalid selection set of polylines.| ")$+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
	
	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[1];		Entity entsTsl[] = {};			Point3d ptsTsl[1];
	
		
	//region Create by panel
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip  = (Sip)ents[i]; 
			if (!sip.bIsValid()){ continue;}
			Point3d ptCen = sip.ptCen();
			Vector3d vecZ = sip.vecZ();
			PlaneProfile ppSip(sip.coordSys());
			ppSip = sip.envelopeBody().shadowProfile(Plane(ptCen, vecZ));

			gbsTsl[0] = sip;
			ptsTsl[0] = sip.ptCen();
			entsTsl.setLength(0);
			
			for (int j=0;j<plines.length();j++) 
			{ 
//				PlaneProfile pp(sip.coordSys());
//				{ 
//					PLine _pl = plines[j];
//					_pl.projectPointsToPlane(Plane(ptCen,vecZ), vecZ);//_pl.coordSys().vecZ());
//					pp.joinRing(_pl, _kAdd);	
//				}
//
//				if (pp.area()<pow(dEps,2))
//				{
//					reportMessage(TN("|Pline| ") + epls[j].handle() + T(" |refused for panel| ") + sip.handle());			
//					continue;
//				}
//				pp.shrink(-dEps*10);
//				pp.intersectWith(ppSip);
//				if (pp.area()<pow(dEps,2))
//				{
//					reportMessage(TN("|Pline| ") + epls[j].handle() + T(" |does not intersect panel| ") + sip.handle());			
//					continue;
//				}				
				
				entsTsl.append(epls[j]);
				if (entsTsl.length() == 2)break;
			}//next j
			
			if (entsTsl.length()>0)
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
		}//next i
			
	//End Create by panel//endregion 	
	
	
	
	
	
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion


//region Panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}

	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCen();
	double dZ = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	Body bdSip = sip.envelopeBody();
	
	assignToGroups(sip, 'T');
	setExecutionLoops(2);
	_ThisInst.setAllowGripAtPt0(false);
	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();

	SipEdge edges[] = sip.sipEdges();
	SipStyle style(sip.style());	
	
	PlaneProfile ppSip(sip.coordSys());
	ppSip = bdSip.shadowProfile(Plane(ptCen, vecZ));	
	Line lnZ (ptCen, vecZ);
	Plane pnRef(ptCen - vecZ * .5 * dZ, vecZ), pnOpp(ptCen + vecZ * .5 * dZ, vecZ);
//End Panel standards//endregion 



//region Collect referenced instances
	EntPLine epls[0];
	PLine plines[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		setDependencyOnEntity(_Entity[i]);
		EntPLine epl = (EntPLine)_Entity[i];	
		if (epl.bIsValid())
		{
			PLine pl = epl.getPLine();
			Point3d pts[] = pl.vertexPoints(false);
			if (pts.length() < 2)continue;
			
			PlaneProfile pp(sip.coordSys());
			{ 
				PLine _pl = pl;
				_pl.projectPointsToPlane(Plane(ptCen,vecZ), pl.coordSys().vecZ());
				pp.joinRing(_pl, _kAdd);	
			}
			
			pp.shrink(-dEps);//pp.vis(2);
			pp.intersectWith(ppSip);
			
		// exclude closed and straight plines
			int bIsClosed = Vector3d(pts[0] - pts[pts.length() - 1]).length() < dEps;
			int bIsStraight = pl.isOn((pts[0] + pts[1]) / 2);	
			if (bIsClosed)
				reportMessage(TN("|Closed polyline not allowed as tool definition|"));
//			else if (pp.area()<pow(dEps,2))
//				reportMessage(TN("|Polyline does not intersect panel|"));				
			else
			{ 
				epls.append(epl); 	
				plines.append(pl);				
			} 
		}
	}//next i
	if (plines.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Invalid polylines selected.|") + " " + T("|Tool will be deleted|"));
		//eraseInstance();
		return;		
	}
//endregion 

//region Tool variables
	PLine plDefining, plBevel;	
	double dMaximumDeviation = U(10);
	int nToolSide = _kLeft;
	
	int nToolIndex = sToolNames.find(sToolName, 0);
	int nCncMode = nToolIndices[nToolIndex];
	double dDiameter = dDiameters[nToolIndex];	
	double dLength = dLengths[nToolIndex];	
	
//End Tool variables//endregion 



//region Single PLine definition
	int bIsSingle = plines.length()==1;
	int bFlipFace = _Map.getInt("flipFace");
	

//End Single PLine definition//endregion 



//region Get face and face assignment
	double dMax1, dMax2, dMin1, dMin2; // the max distance of the pline vertices seen in vecZ
	Vector3d vecFace = vecZ;
	Point3d ptFace = ptCen + .5 * vecZ * dZ;
	
	PLine pl1 = plines[0];
	plDefining = pl1;
	Vector3d vecZ1 = pl1.coordSys().vecZ();
	Point3d pts1[] = lnZ.orderPoints(pl1.vertexPoints(true));
	int b1OnFace;
	if (pts1.length()<2)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Invalid polyline shape.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;			
	}
	else
	{ 
		double d0 = vecZ.dotProduct(pts1.first()-ptCen);
		double d1 = vecZ.dotProduct(pts1.last()-ptCen);
		int sgn0 = d0==0?1:d0/abs(d0);
		int sgn1 = d1==0?1:d1/abs(d1);
		
	// on reference side
		if (d0<0 && d1<0)
			vecFace *= -1;
		else if (abs(d0-d1)<dEps && d0 < 0) // parallel on reference side
			vecFace *= -1;
		else if (abs(d0-d1)>dEps && d0<0) // sloped on reference side
			vecFace *= -1;
		ptFace = ptCen + .5 * vecFace * dZ;
		
	// project to face
		if (abs(d0)>.5*dZ && abs(d1)>.5*dZ && sgn0==sgn1)
		{ 
			pl1.projectPointsToPlane(Plane(ptFace, vecFace), vecZ1);
			plDefining = pl1;
			b1OnFace = true;
		}
		else
		{
			b1OnFace = abs(d0 - d1) < dEps && .5 * dZ-abs(d0) < dEps;	
		}
		
		dMin1 = abs(d0) > abs(d1) ? d1 : d0;
		dMax1 = abs(d0) > abs(d1) ? d0 : d1;
		
		//pl1.vis(1);
		//vecFace.vis(pl1.ptStart(),b1OnFace?3:1);	
	}

//Make sure 2 polylines are available
	PLine pl2;
	int b2OnFace;
	if (bIsSingle)
	{ 
		pl2 = pl1;
		
	// the first polyline is on the face (or outside) -> the second will be on the opposite side	
		if (b1OnFace)
		{
			Plane pn(ptCen - vecFace * .5 * dZ, - vecFace);
			pl2.projectPointsToPlane(pn, -vecFace);
			plBevel = pl2;
		}
	// the first is not on a face -> project to the face
		else
		{
			Plane pn(ptCen + vecFace * .5 * dZ, + vecFace);
			pl2.projectPointsToPlane(pn, vecFace);
			plDefining = pl2;
			plBevel = pl1;
		}
			
		
		b2OnFace = true;
		//pl2.vis(b1OnFace?2:6);	
	}
	else
	{ 
		Vector3d vecFace2 = vecZ;
		
		pl2 = plines[1];
		Vector3d vecZ2 = pl2.coordSys().vecZ();
		
		Point3d pts2[] = lnZ.orderPoints(pl2.vertexPoints(true));
		double d0 = vecZ.dotProduct(pts2.first()-ptCen);
		double d1 = vecZ.dotProduct(pts2.last()-ptCen);
		int sgn0 = d0==0?1:d0/abs(d0);
		int sgn1 = d1==0?1:d1/abs(d1);
		
			
		if (sgn0==-1 && sgn1==-1)// on reference side
			vecFace2 *= -1;
		else if (abs(d0-d1)<dEps && d0 < 0) // parallel on reference side
			vecFace2 *= -1;
		else if (abs(d0-d1)>dEps && d0<0) // sloped on refernce side
			vecFace2 *= -1;	

	// project to face
		if (abs(d0)>.5*dZ && abs(d1)>.5*dZ && sgn0==sgn1)
		{ 
			pl2.projectPointsToPlane(Plane(ptCen+vecFace2*.5*dZ, vecFace2), vecZ2);			
			b2OnFace = true;
		}
		else
		{ 
			b2OnFace = abs(d0 - d1) < dEps && .5 * dZ-abs(d0) < dEps;//&& abs(d0) - .5 * dZ < dEps;			
		}
		plBevel= pl2;
		dMin2 = abs(d0) > abs(d1) ? d1 : d0;
		dMax2 = abs(d0) > abs(d1) ? d0 : d1;	
		//vecFace2.vis(pl2.ptStart(),b2OnFace?93:12);		
		
		//pl2.vis(2);
		
	}
//End Make sure 2 polylines are available//endregion 


// TriggerFlipFace	
	if (bIsSingle || (b1OnFace && b2OnFace) ||  (!b1OnFace && !b2OnFace))
	{ 
		String sTriggerFlipSide = T("|Flip Face|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
		{
			 _Map.setInt("flipFace",!bFlipFace);
			setExecutionLoops(2);
			return;
		}		
	}
	else if (bFlipFace)
	{ 
		bFlipFace = false;
		_Map.removeAt("flipFace", true);
	}



//region Reaassign defining and bevel
	Vector3d vecToolFace = vecFace;
	if (bFlipFace)
	{ 
		PLine pl = plDefining;
		plDefining = plBevel;
		plBevel= pl1;
		vecToolFace *= -1;
	}
	else if (!b1OnFace && !b2OnFace)	// both not on one of the faces
	{ 
		if (abs(dMin1)<abs(dMin2))
		{ 
			plBevel = pl1;
			pl2.projectPointsToPlane(Plane(ptCen+vecFace*.5*dZ, vecFace), pl2.coordSys().vecZ());
			plDefining= pl2;
			
		}
		else
		{ 
			plBevel= pl2;
			pl1.projectPointsToPlane(Plane(ptCen+vecFace*.5*dZ, vecFace), pl2.coordSys().vecZ());
			plDefining  = pl1;			
		}
	}
	else if (!b2OnFace && b1OnFace)
	{ 
		plBevel= pl2;
		plDefining  = pl1;
	}	
	else if (b2OnFace && !b1OnFace)
	{ 
		plBevel= pl1;
		plDefining  = pl2;
	}	
//End Reaassign defining and bevel//endregion 

// ensure that the plines are drawn in the same 'direction'
	{ 	
		Vector3d vec1 = plDefining.ptEnd() - plDefining.ptStart();
		Vector3d vec2 = plBevel.ptEnd() - plBevel.ptStart();
		if(vec1.dotProduct(vec2)<0)
			plBevel.reverse();		
	}


	if (vecToolFace.dotProduct(plDefining.coordSys().vecZ())>0)
		plDefining.flipNormal();
	if (vecToolFace.dotProduct(plBevel.coordSys().vecZ())>0)
		plBevel.flipNormal();
	
	plDefining.vis(1);
	plBevel.vis(3);

// get direction
	ptFace = ptCen + vecToolFace * .5 * dZ;
	PLine plSymPath = plDefining;//
	Vector3d vecDir = plSymPath.getPointAtDist(dEps)-plSymPath.ptStart();
	vecDir.normalize();	
	Vector3d vecPerp = vecDir.crossProduct(-vecToolFace);

//	vecDir.vis(plSymPath.ptStart(), 1);
//	vecPerp.vis(plSymPath.ptStart(), 3);
	vecToolFace.vis(plSymPath.ptStart(), 150);
	Vector3d vecSide = vecPerp;



//region Propeller Tool
	PropellerSurfaceTool tt(plDefining, plBevel,  dDiameter, dMaximumDeviation);
	tt.setMillSide(nMillSide==-2?_kRight:nMillSide);	
	tt.setCncMode(nToolIndex);
	Body bdTool = tt.cuttingBody();
	// test side
	if(nMillSide==-2)
	{ 
	// try right	
		Body bd1 = bdTool;			
		bd1.intersectWith(bdSip);	//bd1.vis(1);
		
	// try left	
		tt.setMillSide(_kLeft);
		Body bd2 = tt.cuttingBody();	
		Body bdX2 = bd2;
		bdX2.intersectWith(bdSip);	//bdX2.vis(2);
		
	// use side with minmal intersectiom	
		if (bd1.volume()<bdX2.volume())
			tt.setMillSide(_kRight);
		else
		{
			bdTool = bd2;
			vecSide *= -1;
		}
	}
	
	//bdTool.intersectWith(bdSip);
	//bdTool.vis(40);
	sip.addTool(tt);
	bdSip.addTool(tt);
//End Propeller Tool//endregion 


//region Display
	Display dp(-1);
	dp.trueColor(ncBevel);
	dp.draw(plBevel);		
	dp.trueColor(ncDefining);
	dp.draw(plDefining);

	
//End Display//endregion 

//region Create display graphics
	Body bdReal = sip.realBodyTry();
	double dSize = U(50);
	
	Point3d ptDef = plDefining.ptStart();
	Vector3d vecZD = plDefining.coordSys().vecZ();
	Plane pnDef(ptDef, vecZD);		vecZD.vis(ptDef, 3);
	PlaneProfile ppDef = bdSip.extractContactFaceInPlane(pnDef,dEps); //ppDef.vis(1);

	{ 
		double dLDef = plDefining.length();
		double dLBev = plBevel.length();
		double dDist = dLDef<U(500)?dLDef/2:U(500);
		int nNum = dLDef / dDist;
		if (nNum<3)
		{ 
			nNum = 3;
			dDist = dLDef / nNum;
		}
		
		double dDistB = dLBev / nNum;
		
		for (int i=0;i<=nNum;i++) 
		{ 
			double d = nNum==i?dLDef-dSize:i * dDist;
			double dBev = nNum==i?dLBev-dSize:i * dDistB;
			
			Point3d pt1 = plDefining.getPointAtDist(d);pt1.vis(2);
			
			if (ppDef.pointInProfile(pt1+vecSide*.25*dSize)==_kPointOutsideProfile)
				vecSide *= -1;
			
		// indicate walking direction on defining pline	
			double d2 = nNum==i?dLDef-.5*dSize:i*dDist+.5*dSize;
			Point3d pt2 = plDefining.getPointAtDist(d2);
			double d3 = nNum==i?dLDef:i*dDist+dSize;
			Point3d pt3 = plDefining.getPointAtDist(d3);
			
			double d3Bev = nNum==i?dLBev:i*dDistB+dSize;
			Point3d pt3Bev = plBevel.getPointAtDist(d3Bev);			
			
			Point3d pt4 = pt1 + vecSide * .25 * dSize;
			PLine pl(vecFace);
			pl.addVertex(pt1);
			pl.addVertex(pt3, pt2);
			pl.addVertex(pt4);
			pl.close();
			PlaneProfile pp(pl);
			if (nMillSide!=_kCenter)
				pp.intersectWith(ppDef);
			
			if (pp.area()>pow(dEps,2))
			{ 
				dp.trueColor(red);
				dp.draw(pp, _kDrawFilled, 70); // draw walking direction
				dp.draw(pp);

				d = plDefining.getDistAtPoint(pt3Bev)+(i<nNum?dEps:-dEps);
				Vector3d vecA = pt3Bev- plDefining.getPointAtDist(d); vecA.normalize();
				Vector3d vecB = pt3Bev - pt3; 
				d = vecB.length()*.5;vecB.normalize();
				d = d > .5 * dSize ? .5 * dSize : d;
				dp.trueColor(blue);
				dp.draw(PLine(pt3,pt3Bev-vecB*d));
				dp.draw(Body(pt3Bev-vecB*d,pt3Bev, .1*d, dEps));
				// 2D approach
//				PLine pl2;
//				pl2.addVertex(pt5-vecB*d);
//				pl2.addVertex(pt5-vecB*d+.1*d*vecA);
//				pl2.addVertex(pt5);
//				pl2.addVertex(pt5-vecB*d-.1*d*vecA);
//				pl2.close();
//				dp.draw(PlaneProfile(pl2),_kDrawFilled, 50);
			}
 
		}//next i		
		
		
	}


//End Create display graphics//endregion 

//region Trigger
{
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	//region Trigger ConfigureDisplay
	String sTriggerConfigureDisplay = T("|Configure Display|");
	// TODO no additional display supported yet, therefor this option is disabled, alos rgb picker not existing yet
	//addRecalcTrigger(_kContextRoot, sTriggerConfigureDisplay );
	if (_bOnRecalc && _kExecuteKey == sTriggerConfigureDisplay)
	{
		// prepare dialog instance
		mapTsl.setInt("DialogMode", 1);
		sProps.append(sDimStyle);		
		
		nProps.append(ncDefining); // color
		nProps.append(ncBevel); // color
		nProps.append(nt); // transparency

		dProps.append(dTextHeight);
		
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				String key = "Display\\Propeller";
				Map map = mapSetting.getMap(key);				
								
				ncDefining= tslDialog.propInt(0);
				ncBevel= tslDialog.propInt(1);
				nt= tslDialog.propInt(2);
				
				sDimStyle = tslDialog.propString(0);
				
				dTextHeight = tslDialog.propDouble(0);
		
				map.setInt("Color", ncDefining);
				map.setInt("ColorRef", ncBevel);
				map.setInt("Transparency", nt);
				map.setString("DimStyle", sDimStyle);
				map.setDouble("TextHeight", dTextHeight);
				mapSetting.setMap(key, map);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion
	
	
	//region Trigger AddTool
	String sTriggerAddTool = T("|Add Tool Definition|");
	addRecalcTrigger(_kContext, sTriggerAddTool );	
	String sTriggerEditTool = T("|Edit Tool Definition|");
	addRecalcTrigger(_kContext, sTriggerEditTool );
	if (_bOnRecalc && (_kExecuteKey == sTriggerEditTool || _kExecuteKey == sTriggerAddTool))
	{
		int bEdit = _kExecuteKey == sTriggerEditTool;
		// prepare dialog instance
		mapTsl.setInt("DialogMode", bEdit?2:3);
		
		dProps.append(dDiameter);		
		dProps.append(dLength);
		nProps.append(nToolIndex);
		sProps.append(sToolName);

		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				nToolIndex= tslDialog.propInt(0);
				dDiameter= tslDialog.propDouble(0);
				dLength= tslDialog.propDouble(1);
				String _sToolName= tslDialog.propString(0);

			// add if not found
				int index = sToolNames.findNoCase(_sToolName,-1);
				if (index<0)
				{ 					
					//reportMessage(TN("|add diam to| ") + dDiameter);
					sToolNames.append(_sToolName);
					dDiameters.append(dDiameter);
					dLengths.append(dLength);
					nToolIndices.append(nToolIndex);
				}
				else
				{ 
					//reportMessage(TN("|change diam to| ") + dDiameter);
					sToolNames[index]=_sToolName;
					dDiameters[index]=dDiameter;
					dLengths[index]=dLength;
					nToolIndices[index]=nToolIndex;			
				}
				
			// write tool map
				Map mapTools;
				for (int i=0;i<sToolNames.length();i++) 
				{ 
					Map mapTool;
					
					mapTool.setInt("ToolIndex", nToolIndices[i]);
					mapTool.setString("Name", sToolNames[i]);
					mapTool.setDouble("Diameter", dDiameters[i]);
					mapTool.setDouble("Length", dLengths[i]);
					
					mapTool.setMapName(sToolNames[i]);
					mapTools.appendMap("Tool", mapTool);
				}//next i
				
				mapSetting.setMap("Tool[]", mapTools);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion	
	
	//region Trigger RemoveTool
	if (sToolNames.length()>1)
	{ 
		String sTriggerRemoveTool = T("|Remove Tool Definition|");
		addRecalcTrigger(_kContext, sTriggerRemoveTool );	
		if (_bOnRecalc && _kExecuteKey == sTriggerRemoveTool)
		{	
			mapTsl.setInt("DialogMode", 4);
			sProps.append(sToolName);

			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{
					String _sToolName= tslDialog.propString(0);
					int index = sToolNames.findNoCase(_sToolName,-1);
					
					if (index>-1)
					{ 
						nToolIndices.removeAt(index);
						sToolNames.removeAt(index);
						dDiameters.removeAt(index);
						dLengths.removeAt(index);
					}
							
					// write tool map
					Map mapTools;
					for (int i=0;i<sToolNames.length();i++) 
					{ 
						Map mapTool;
						
						mapTool.setInt("ToolIndex", nToolIndices[i]);
						mapTool.setString("Name", sToolNames[i]);
						mapTool.setDouble("Diameter", dDiameters[i]);
						mapTool.setDouble("Length", dLengths[i]);
						
						mapTool.setMapName(sToolNames[i]);
						mapTools.appendMap("Tool", mapTool);
					}//next i
					
					mapSetting.setMap("Tool[]", mapTools);
	
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);
		
		
				}
				tslDialog.dbErase();
			}		
			
			setExecutionLoops(2);
			return;
		}//endregion			
	}
	
	
	//region Trigger ImportSettings
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
				else
					bWrite = true;
					
				if (bWrite && mapSetting.length() > 0)
				{ 
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);
					reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				}
				
				setExecutionLoops(2);
				return;
			}
		}
	
	//endregion

	
}//endregion



#End
#BeginThumbnail
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
L:RC?&%"\^U9/_"-B-CY%[-&I/W16]10!AQ>&H5F62:YEE93D9K<HHH`__]DA
`






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <lst nm="MPIDESETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="N" vl="1" />
    </lst>
  </lst>
  <lst nm="mpTslInfo">
    <lst nm="MPTSLINFO" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="743" />
        <int nm="BreakPoint" vl="803" />
        <int nm="BreakPoint" vl="717" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10652 straight segments of defining polyline not excluded" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="2/8/2021 3:11:56 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10652 bugfix tool orientation. Tool definitions can be edited via context commands" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="2/8/2021 2:43:07 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10496 visualization improved" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="1/31/2021 10:21:01 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10496 new tool definition to support various alignments" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="1/29/2021 4:53:26 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End