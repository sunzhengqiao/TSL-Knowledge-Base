#Version 8
#BeginDescription
version value="1.6" date="09aug2018" author="thorsten.huck@hsbcad.com"
bugfix moving beyond female midpoint
display representation supported
system assignment female beams improved
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.6" date="20Nov2018" author="thorsten.huck@hsbcad.com"> bugfix moving beyond female midpoint, display representation supported, system assignment female beams improved </version>
/// <version value="1.5" date="09aug2018" author="thorsten.huck@hsbcad.com"> HVAC creation assigned to missing branch corrected, hardware output added </version>
/// <version value="1.4" date="19jul2018" author="thorsten.huck@hsbcad.com"> HVAC-System will be created for new branch </version>
/// <version value="1.3" date="18jul2018" author="thorsten.huck@hsbcad.com"> renamed </version>
/// <version value="1.2" date="18jul2018" author="thorsten.huck@hsbcad.com"> insertion with 2 or 3 beams supported, alignment validation and helper lines added </version>
/// <version value="1.1" date="18jul2018" author="thorsten.huck@hsbcad.com"> Layer assignment fixed, main solid diameter taken from female beams </version>
/// <version value="1.0" date="20jun2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

/// <remark Lang=en>
/// Requires settings file HVAC.xml in the <company>\tsl\settings path
/// </remark>

/// <summary Lang=en>
/// This tsl creates a T-connection of ductwork beams. 
/// </summary>

/// commands
// command to insert a T-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HVAC-T")) TSLCONTENT 


//endregion

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

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="HVAC";
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
	
//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
//	// silent/dialog
//		String sKey = _kExecuteKey;
//		sKey.makeUpper();
//
//		if (sKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
//			for(int i=0;i<sEntries.length();i++)
//				sEntries[i] = sEntries[i].makeUpper();	
//			if (sEntries.find(sKey)>-1)
//				setPropValuesFromCatalog(sKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);					
//		}	
//		else	
//			showDialog();
		
		Beam bm0 = getBeam(T("|Select male ductwork|"));
		_Beam.append(bm0);
		
	// prompt for female beams
		Beam beams[0];
		PrEntity ssE(T("|Select female ductwork(s)|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
			
		Beam bm1;	
		for (int i=0;i<beams.length();i++) 
		{ 
			Beam& b = beams[i];
			Vector3d vecX = b.vecX();
		// skip paralell
			if (bm0.vecX().isParallelTo(vecX))
				continue;
		
		// first female
			if (_Beam.length()<2)
			{
				bm1 = b;
				_Beam.append(b);
			}
		// second female
			else if (_Beam.length()<3)
			{ 
				Point3d pt1 = bm1.ptCenSolid();
				Point3d pt2 = b.ptCenSolid();		
				Vector3d vecZ1 = _Beam[1].vecD(_Beam[0].vecX());
			// needs to be parallel and in line with first female
				if (b.vecX().isParallelTo(vecX) && abs(vecZ1.dotProduct(pt1-pt2))<dEps)
				{ 
					_Beam.append(b);
					break;// got 3 beams
				}			
			} 
			 
		}//next i
		if(bDebug)reportMessage("\n"+ scriptName() + " collected " + _Beam.length()  + " beams");
		
		_Map.setInt("mode", _Beam.length()==2?1:0);
		return;
	}	
//End OnInsert//endregion 	


//region Read Settings
	String sDispRepName;
	{
		String k;
		Map m= mapSetting.getMap("Display");
	
		//k="DispRepName";		if (m.hasDouble(k))	dDispRepName = m.getDouble(k);
		//k="DispRepName";		if (m.hasString(k))	sDispRepName = m.getString(k);
		k="DispRepName";		if (m.hasString(k))	sDispRepName = m.getString(k);
		//k="IntEntry";			if (m.hasInt(k))	sIntEntry = m.getInt(k);
	}

// validat dispRepName
	if (sDispRepName.length()>0)
	{ 
		int bFound;
		String sDispRepNameUC = sDispRepName;
		sDispRepNameUC.makeUpper();
		String sDispRepNames[] = _ThisInst.dispRepNames();
		for (int i=0;i<sDispRepNames.length();i++) 
		{ 
			if(sDispRepNameUC== sDispRepNames[i].makeUpper())
			{
				bFound=true;
				break;
			}	 
		}//next i
		if (!bFound)sDispRepName = "";
	}	
//End Read Settings//endregion 


// mode
	int nMode = _Map.getInt("mode");
	if(bDebug)reportMessage("\n"+ scriptName() + " split mode " + nMode);
	// 0 = connection
	// 1 = split
	
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	_Entity.append(bm1);
	setDependencyOnEntity(bm1);
	
// store the vecX1 towards the connection
	Vector3d vecX1 = bm1.vecX();
	assignToGroups(bm1, 'Z');
	Beam bm2;
	if (_Beam.length()>2)
	{
		bm2 = _Beam[2];
	
		if (_Map.hasVector3d("vecX1"))
			vecX1 = _Map.getVector3d("vecX1");
		else
		{ 
			if (vecX1.dotProduct(_Pt0-bm1.ptCenSolid())<0)vecX1 *= -1;
			_Map.setVector3d("vecX1", vecX1);
		}		
	}
	
// validate main duct work assignment of female beams
	Beam bmFemales[] ={ bm1};
	if (bm2.bIsValid())bmFemales.append(bm2);
	TslInst tslParents[bmFemales.length()];
	for (int i=0;i<bmFemales.length();i++) 
	{ 
		Beam& bm= bmFemales[i]; 
		String sKeys[] = bm.subMapXKeys();
		if (sKeys.find("HvacChild") >- 1)
		{
			Map m = bm.subMapX("HvacChild");
			Entity entParent = m.getEntity("HvacParent");
			TslInst tslParent = (TslInst)entParent;
			if (tslParent.bIsValid() && tslParent.entity().find(bm)>-1)
				tslParents[i] = tslParent;
			//if(bDebug
			reportMessage("\n"+ scriptName() + " bm1 tslParent " + (tslParent.bIsValid()?" valid":" invalid"));
		}			
	}//next i

// try to create a new parent instance of the female if missing (only if split has been completed)
	if (bm2.bIsValid())
	{ 
		TslInst tsl0 = tslParents[0];
		TslInst tsl1 = tslParents[1];
		TslInst tslRef = tsl0.bIsValid() ? tsl0 : tsl1;
		if ((!tsl0.bIsValid() && tsl1.bIsValid()) || (tsl0.bIsValid() && !tsl1.bIsValid()))
		{
			GenBeam gbsTsl[0];
			TslInst tslNew;			Entity entsTsl[] = { };
			int nProps[]={};		double dProps[]={};			String sProps[2];
			Map mapTsl;
			Point3d ptsTsl[0];
			if (!tsl0.bIsValid())
			{ 
				gbsTsl.append(bm1);
				ptsTsl.append(bm1.ptCenSolid());
			}
			else if (!tsl1.bIsValid())
			{ 
				gbsTsl.append(bm2);
				ptsTsl.append(bm2.ptCenSolid());
			}			
				
			if (tslRef.bIsValid())
			{ 
				if(bDebug)reportMessage("\nparent to copy values was valid");
				mapTsl = tslRef.map();
				for (int i=0;i<sProps.length();i++) 
					sProps[i] = tslRef.propString(i); 	
			}
			tslNew.dbCreate("HVAC" , _X1 ,_Y1,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}
		 
	}//next i
	
	
	
	//bm0.addTool(Cut(_Pt0, _X0), 1);
	Point3d ptRef = Line(_Pt0, _X0).intersect(Plane(bm1.ptCenSolid(), _Z1),0);
	ptRef.vis(2);

	int bDrawAsLinework = !bm1.isVisible();//_Map.getInt("drawAsLineWork");


// split mode
	if (nMode==1)
	{ 
		bm2 = bm1.dbSplit(_Pt0, _Pt0);
		//bm1.setColor(6);
		
//	// find out which beam has kept the link of the female HVAC
//		int b1HasParent,b2HasParent;
//		String sFamily, sChild;
//		TslInst tslParent1, tslParent2;
//		if (bm1.subMapXKeys().find("HvacChild") >- 1)
//		{
//			Map m = bm1.subMapX("HvacChild");
//			Entity entParent = m.getEntity("HvacParent");
//			tslParent1 = (TslInst)entParent;
//			if (tslParent1.bIsValid() && tslParent1.entity().find(bm1)>-1)
//			{
//				b1HasParent = true;
//				sFamily = m.getString("FamilyName");
//				sChild = m.getString("Name");
//			}
//			if(bDebug)reportMessage("\n"+ scriptName() + " bm1 tslParent " + (b1HasParent?" valid":" invalid"));
//		}
//		if (bm2.subMapXKeys().find("HvacChild") >- 1)
//		{
//			Map m = bm2.subMapX("HvacChild");
//			Entity entParent = m.getEntity("HvacParent");
//			tslParent2 = (TslInst)entParent;
//			if (tslParent2.bIsValid() && tslParent2.entity().find(bm2)>-1)
//			{
//				b2HasParent = true;
//				sFamily = m.getString("FamilyName");
//				sChild = m.getString("Name");
//			}
//			if(bDebug)reportMessage("\n"+ scriptName() + " bm2 tslParent " + (b2HasParent?" valid":" invalid"));
//		}		

		
		_Beam.append(bm2);
		_Map.removeAt("mode", true);

//	// create a new HVAC for the beam which hasn't one assigned	
//		Point3d ptsTsl[1]; 
//		GenBeam gbsTsl[1];
//		Vector3d vecXTsl, vecYTsl;
//		TslInst tslParent;
//		if (!b1HasParent)
//		{
//			gbsTsl[0] = bm1;
//			ptsTsl[0] = bm1.ptCenSolid();
//			vecXTsl = _X1;
//			vecYTsl = _Y1;	
//			tslParent = tslParent2;
//		}
//		else if (!b2HasParent)
//		{
//			gbsTsl[0] = bm2;
//			ptsTsl[0] = bm2.ptCenSolid();
//			vecXTsl = _X2;
//			vecYTsl = _Y2;
//			tslParent = tslParent1;
//		}
//		if (!b1HasParent || !b2HasParent)
//		{
//			TslInst tslNew;			Entity entsTsl[] = { };
//			int nProps[]={};		double dProps[]={};			String sProps[]={sFamily, sChild};
//			Map mapTsl;	
//			if (tslParent.bIsValid())
//			{ 
//				if(bDebug)reportMessage("\nparent to copy values was valid");
//				mapTsl = tslParent.map();
//				for (int i=0;i<sProps.length();i++) 
//					sProps[i] = tslParent.propString(i); 	
//			}
//			tslNew.dbCreate("HVAC" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
//		}
		setExecutionLoops(2);
		return;
	}
	else if (_Beam.length()<3)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|requires 3 beams|"));
		eraseInstance();
		return;
	}


// test if females are in line
	int bOk;
	{ 
		Point3d pt1 = bm1.ptCenSolid();
		Point3d pt2 = bm2.ptCenSolid();		
		Vector3d vecZ1 = _Beam[1].vecD(_Beam[0].vecX());
		bOk = bm1.vecX().isParallelTo(bm2.vecX()) && abs(_Z1.dotProduct(pt1 - pt2)) < dEps && abs(_Y1.dotProduct(pt1 - pt2)) < dEps;	
		
		if (bOk && abs(_Y1.dotProduct(pt1 - _Pt0))>dEps)
			bOk = false;
	}
	
// Display	
	int nColor = bOk?bm0.color():(bm0.color()==1?6:1);
	Display dpModel(nColor), dpPlan(nColor);
	if (sDispRepName.length() > 0) 
	{
		dpPlan.showInDispRep(sDispRepName);
		dpModel.showInDispRep(sDispRepName);
	}
	if(!bDrawAsLinework && bOk)
	{
		dpPlan.addViewDirection(_ZW);
		dpModel.addHideDirection(_ZW);
	}




// get max dimensions
	double dMax0 = bm0.dH() > bm0.dW() ? bm0.dH() : bm0.dW();
	double dMax1 = bm1.dH() > bm1.dW() ? bm1.dH() : bm1.dW();
	double dMax2 = bm2.dH() > bm2.dW() ? bm2.dH() : bm2.dW();
	double dMax12 = dMax1 > dMax2 ? dMax1 : dMax2;
	double dMax123 = dMax0 > dMax12 ? dMax0 : dMax12;
	
	double dWidthMale = bm0.dD(_X1);
	double dWidthFemale = bm1.dD(_X0)>bm2.dD(_X0)?bm1.dD(_X0):bm2.dD(_X0);

// draw warning and helper lines if not codirectioal females
	if (!bOk)
	{ 
		dpModel.draw(T("|Not possible|"), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		dpModel.draw(PLine(_Pt0-_X0*dMax0,_Pt0+_X0*dMax0));
	}


// collect round
	int bIsRound0 = bm0.extrProfile() == _kExtrProfRound;
	int bIsRound1 = bm1.extrProfile() == _kExtrProfRound;
	int bIsRound2 = bm2.extrProfile() == _kExtrProfRound;

// collect connection data
	Body bdT;
	for (int i=0;i<_Beam.length();i++) 
	{
		Beam bm = _Beam[i];
		if (bDebug)bm.envelopeBody().vis(i);
		double dW = bm.dW();
		int bIsRound = bm.extrProfile() == _kExtrProfRound;
		
		PlaneProfile pp = bm.envelopeBody(true, true).shadowProfile(Plane(ptRef, bm.vecX()));
		pp.vis(i);
		double dTLength = bIsRound?dW:U(50);
		Map mapChild = bm.subMapX("HvacChild");
		if (mapChild.length()>0)
		{ 
			String k;
//			k = "Name"; if (mapChild.hasString(k))sName = mapChild.getString(k);
//			k = "Height"; if (mapChild.hasDouble(k))dHeight = mapChild.getDouble(k);
//			k = "Width"; if (mapChild.hasDouble(k))dWidth = mapChild.getDouble(k);
//			k = "Radius"; if (mapChild.hasDouble(k))dRadius = mapChild.getDouble(k);
//			k = "Diameter"; if (mapChild.hasDouble(k))dDiameter = mapChild.getDouble(k);
//			k = "Insulation"; if (mapChild.hasDouble(k))dInsulation = mapChild.getDouble(k);
			k = "T-Length"; if (mapChild.hasDouble(k))dTLength = mapChild.getDouble(k);
		}
		

		
		Point3d pt=ptRef;
		Vector3d vecXBm = bm.vecX();
		if (_bOnDbCreated)
		{ 
			if (vecXBm.dotProduct(_Pt0-bm.ptCenSolid())<0)	vecXBm *= -1;
		}
		else if (i==0 && vecXBm.dotProduct(_Pt0-bm.ptCenSolid())<0)
			vecXBm *= -1;
		else if (i==1)
			vecXBm = vecX1;
		else if (i==2)
			vecXBm = -vecX1;
		
		pt -= vecXBm * dTLength;
		
	// draw as linework
		if (bDrawAsLinework)
			dpModel.draw(PLine(pt, ptRef));
		
		pt.vis(6);
		bm.addTool(Cut(pt, vecXBm), 1);


	//draw helper lines if not codirectioal females
		if (!bOk && i>0)
		{
			pt.vis(5);
			Point3d ptEnd = bm.ptCenSolid() + vecXBm * (.5 * bm.solidLength() - dTLength);
			dpModel.draw(PLine(ptEnd, ptEnd + vecXBm * 2*dTLength));
		}



//
//	// get shape
//		PLine plShape;
//		PLine plRings[] = pp.allRings();
//		int bIsOp[] = pp.ringIsOpening();
//		for (int r=0;r<plRings.length();r++)
//			if (!bIsOp[r] && plShape.area()<plRings[r].area())
//				plShape = plRings[r];

	// build body
		Body bd;
		if (bIsRound)
		{ 
			if (i==0)
			{ 
				pt.vis(40);
				bd=Body(pt,ptRef, dW/2, dMax12/2);	// draw a cone
			}
			else if(i==1 || i==2)
			{ 
				Point3d pt2 = ptRef;
				if (abs(dMax1-dMax2)>dEps)pt2-=vecXBm*.5*dMax0;
				bd=Body(pt,pt2, dW/2, dMax12/2);	
				bd.vis(2);
				if (i==1 && abs(dMax1-dMax2)>dEps)
				{ 
					bd.combine(Body(ptRef-vecXBm*.5*dMax0,ptRef+vecXBm*.5*dMax0,dMax12/2));
				}
			}
		}
		else
		{ 
			double dX = dTLength;
			double dY = bm.dD(_Y0) ;
			double dZ = bm.dD(_Z0);	
			double dX12 = bm1.dD(_X0) > bm2.dD(_X0) ? bm1.dD(_X0) : bm2.dD(_X0);
			if (i > 0)dX -= .5 * bm0.dD(_X1);
			else dX -= .5 * dX12;
			
			if (dX>dEps && dY>dEps && dZ>dEps)
				bd=Body(pt,vecXBm,bm.vecD(_Y0),bm.vecD(_Z0), dX, dY,dZ,1,0,0);
			if (i==0)
			{
				dX = bm1.dD(_X0) > bm2.dD(_X0) ? bm1.dD(_X0) : bm2.dD(_X0);
				double dY = bm0.dD(_X1)+ 2* dTLength;
				double dZ12 = bm1.dD(_Z0) > bm2.dD(_Z0) ? bm1.dD(_Z0) : bm2.dD(_Z0);
				double dZ = bm0.dD(_Z0) > dZ12 ? bm0.dD(_Z0) : dZ12;
				if (dX>dEps && dY>dEps && dZ>dEps)
					bd.combine(Body(ptRef,_X0, _Y0,_Z0, dX, dY, dZ,0,0,0));
			}
		}
		
		//bd.vis(2);
		bdT.combine(bd);	
	}
	
	if(!bDrawAsLinework && bOk)
	{
		dpModel.draw(bdT);
		dpPlan.draw(bdT.shadowProfile(Plane(_Pt0,_ZW)));
	}

// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
		Group groups[] = _ThisInst.groups();
		if (groups.length()>0)
			sHWGroupName=groups[0].name();
	}
	
// add main componnent and compareKey
	{ 
		
		String model, family;
	// get first valid family and child
		double dYs[0];
		for (int i=0;i<_Beam.length();i++) 
		{ 
			Beam& b = _Beam[i];
			Map m = b.subMapX("HvacChild");
			family = m.getString("FamilyName");
			if(model.length()<1)
				model = m.getString("Name");
				
			double dY = m.hasDouble("Diameter") ? m.getDouble("Diameter") : m.getDouble("Width");
			dYs.append(dY);	
		}//next i
		
		double d1,d2,d3;
		if (dYs.length()>2)
		{ 
			d1 = dYs[1] > dYs[2] ? dYs[1] : dYs[2];
			d2 = dYs[0];
			d3 = dYs[1] < dYs[2] ? dYs[1] : dYs[2];
		}
		String articleNumber = "T" + d1 + "-" +d2+"-"+d3;
		setCompareKey(scriptName() + "_" + articleNumber);
		HardWrComp hwc(articleNumber, 1); // the articleNumber and the quantity is mandatory
		
//		hwc.setManufacturer(sHWManufacturer);
		hwc.setModel(model);
		hwc.setName(family);
//		hwc.setDescription(sHWDescription);
//		hwc.setMaterial(sHWMaterial);
//		hwc.setNotes(sHWNotes);
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|HVAC|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(bdT.lengthInDirection(_Z1));
		hwc.setDScaleY(bdT.lengthInDirection(_X1));
		hwc.setDScaleZ(bdT.lengthInDirection(_Y1));
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}



// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion
	
#End
#BeginThumbnail
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
JNGHH`Y.XL==U3:MRJ*BG(!*@#\N:Z6RA:VL8('(+1QA21TX%3T4`?__9
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