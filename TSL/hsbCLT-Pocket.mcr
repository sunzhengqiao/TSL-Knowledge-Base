#Version 8
#BeginDescription
 #Versions
2.1 05.12.2024 HSB-23004: save graphics in file for render in hsbView and make Author: Marsel Nakuci
Version 2.0 25.10.2023 HSB-19449 new option for tool mode proeprty to force housings, new context commands to edit tool settings

Version 1.9 11.09.2023 HSB-19449 new property tool mode to force extrusion tool
Version 1.8 16.03.2021HSB-11214 hsbCLT-Pocket will be exported as free profile as sson as the width is greater or equal then 1000mm. This is primarly to overcome BTL limitations on 4-050 
version value="1.7" date="07may2020" author="thorsten.huck@hsbcad.com"
HSB-7491 bounding contour published for shopdrawings when radius is negative 
HSB-7487 bugfix on negative radius, performance improved by segmented defining contour </version>

HSB-7145 when using a negative radius the tool is now exported as freeprofile (etrusionbody). Tool parameters are taken from hsbCLT-FreeProfile.xml settings


/// This tsl creates a pocket with an optional explicit radius rounding. The Alignment can be adjusted using properties or grips.
/// The dimension of the pocket can be adjusted using the properties or the appropriate context command.
/// Double Click toggles between the face of the tool between the reference and the opposite side.





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 1
#KeyWords CLT;Pocket;Radius;Milling
#BeginContents
/// <History>//region
// #Versions
// 2.1 05.12.2024 HSB-23004: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 2.0 25.10.2023 HSB-19449 new option for tool mode proeprty to force housings, new context commands to edit tool settings , Author Thorsten Huck
// 1.9 11.09.2023 HSB-19449 new property tool mode to force extrusion tool , Author Thorsten Huck
// 1.8 16.03.2021 HSB-11214 hsbCLT-Pocket will be exported as free profile as sson as the width is greater or equal then 1000mm. This is primarly to overcome BTL limitations on 4-050 , Author Thorsten Huck
/// <version value="1.7" date="07may2020" author="thorsten.huck@hsbcad.com"> HSB-7491 bounding contour published for shopdrawings when radius is negative </version>
/// <version value="1.6" date="05may2020" author="thorsten.huck@hsbcad.com"> HSB-7487 bugfix on negative radius, performance improved by segmented defining contour </version>
/// <version value="1.5" date="31mar2020" author="thorsten.huck@hsbcad.com"> HSB-7145 when using a negative radius the tool is now exported as freeprofile (etrusionbody). Tool parameters are taken from hsbCLT-FreeProfile.xml settings </version>
/// <version value="1.4" date="18sep2019" author="thorsten.huck@hsbcad.com"> HSB-5629 A new custom command has been added to toggle between hiding and showing the dimensions in shopdrawing. Requires sd_EntitySymbolDisplay to be active on the viewport placeholder. If the size display is enabled the center index will be shown in yellow to indicate the display mode. </version>
/// <version value="1.3" date="18sep2019" author="thorsten.huck@hsbcad.com"> HSB-5628 new dimrequests published to draw pocket radius in blockspace (sd_EntitySymbolDisplay) as text or ruleset based (sd_TslRequests ) as radial dimension </version>
/// <version value="1.2" date="17jul2019" author="thorsten.huck@hsbcad.com"> HSB-5393 bugfix keep alignment independent from grain direction, HSB-5392 new display of alignmengt, new commands to add/remove radius extension </version>
/// <version value="1.1" date="01Mar2018" author="thorsten.huck@hsbcad.com"> uservoice link updated </version>
/// <version value="1.0" date="09Jan2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, select panel(s) and insertion point and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a pocket with an optional explicit radius rounding. The Alignment can be adjusted using properties or grips.
/// The dimension of the pocket can be adjusted using the properties or the appropriate context command.
/// Double Click toggles between the face of the tool between the reference and the opposite side.
/// </summary>


/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Pocket")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Extend Radius in Direction|") (_TM "|Select pocket|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Remove Extended Radius|") (_TM "|Select pocket|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Remove Panel|") (_TM "|Select pocket|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add Panel|") (_TM "|Select pocket|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Stretch Dimension|") (_TM "|Select pocket|"))) TSLCONTENT
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

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	
//end Constants//endregion
	

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
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
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}		
//End Settings//endregion

//region Read Settings
	String sToolNames[0];
	double dDiameters[0];
	double dLengths[0];
	int nToolIndices[0], bHasXmlSetting;
{ 
	String k;

// Settings approach (1)
	Map m,mapTools= mapSetting.getMap("Tool[]");
	for (int i=0;i<mapTools.length();i++) 
	{ 
		Map m= mapTools.getMap(i);
		
		String name;
		int index, bOk=true;
		double diameter, length;
		k="Diameter";		if (m.hasDouble(k) && m.getDouble(k)>0)	diameter = m.getDouble(k);	else bOk = false;
		k="Length";			if (m.hasDouble(k) && m.getDouble(k)>0)	length = m.getDouble(k);	else bOk = false;
		k="Name";			if (m.hasString(k))	name = m.getString(k);		else bOk = false;
		k="ToolIndex";		if (m.hasInt(k))	index = m.getInt(k); 		else bOk = false;
		
		if (bOk && sToolNames.find(name)<0 && nToolIndices.find(index)<0)
		{
			sToolNames.append(name);
			nToolIndices.append(index);
			dDiameters.append(diameter);
			dLengths.append(length);
			bHasXmlSetting = true;
		}	
	}//next i
}
//End Read Settings//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 2)
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
// geometry
	category = T("|Geometry|");
	String sLengthName= T("(A)   |Length|");	
	PropDouble dLength(nDoubleIndex++, U(200, 8), sLengthName);	
	dLength.setDescription(T("|Defines the length|"));
	dLength.setCategory(category);
	
	String sWidthName=T("(B)   |Width|");	
	PropDouble dWidth(nDoubleIndex++, U(100,4), sWidthName);	
	dWidth.setDescription(T("|Defines the width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("(C)   |Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(20,1), sDepthName);	
	dDepth.setDescription(T("|Defines the depth|") + T(", |0 = complete through|"));
	dDepth.setCategory(category);
	
	String sRadiusName=T("(D)   |Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the rounding radius.|") + T(" |A negative value will create an overshoot|."));
	dRadius.setCategory(category);

	String tTMDefault = T("<|Default|>"), tTMFreeProfile = T("|Free Profile|"),tTMHouse = T("|Housing|"), sToolModes[] ={ tTMDefault,tTMFreeProfile,tTMHouse};
	String sToolModeName=T("|Tool Mode|");	
	PropString sToolMode(2, sToolModes, sToolModeName);	
	sToolMode.setDescription(T("|Defines the ToolMode|"));
	sToolMode.setCategory(category);
	if (sToolModes.find(sToolMode) < 0)sToolMode.set(tTMDefault);

// alignment
	category = T("|Alignment|");
	String sSideName=T("(E)   |Side|");
	String sSides[] = { T("|Reference Side|"), T("|Opposite Side|") };
	PropString sSide(0, sSides, sSideName);	
	sSide.setDescription(T("|Defines the Side.|") + T(" |Double Click will flip sides.|"));
	sSide.setCategory(category);
		
	String sRotationName=T("(F)   |Rotation|");	
	PropDouble dRotation(nDoubleIndex++, 0, sRotationName, _kAngle);	
	dRotation.setDescription(T("|Defines the rotation in the XY plane of the panel.|") + T("|The rotation can also be modified by the grip next to the base point.|") );
	dRotation.setCategory(category);

	String sOrientationName=T("(G)   |Orientation|");		
	String sOrientations[]={ T("1-|front-left|"),T("2-|front-center|"),T("3-|front-right|"),
		T("4-|center-left|"),T("5-|center-center|"),T("6-|center-right|"),
		T("7-|back-left|"), T("8-|back-center|"), T("9-|back-right|")};
	PropString sOrientation(1, sOrientations, sOrientationName,4);	
	sOrientation.setDescription(T("|Defines the orientation in relation to the base point.|"));
	sOrientation.setCategory(category);			
//End Properties//endregion 



//region Jig
	if (_bOnGripPointDrag && (_kExecuteKey=="_PtG0") && _Sip.length()>0)
	{ 
		Sip sip = _Sip[0];
		Vector3d vecZ = sip.vecZ();
		Display dpJig(12);
		PLine plCirc;
		plCirc.createCircle(_Pt0,vecZ, dWidth * .25);
		
		dpJig.draw(plCirc);
		dpJig.color(141);
		
		Point3d ptX = _PtG[0] + vecZ * vecZ.dotProduct(_Pt0 - _PtG[0]);
		Vector3d vecDir = ptX - _Pt0;
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);
		
		Point3d pts[] = Line(_Pt0, -vecDir).orderPoints(plCirc.intersectPoints(Plane(_Pt0, vecPerp)));
		
		if (pts.length()>0)
		{ 
			Point3d pt1 = _PtW + _Map.getVector3d("Grip0");
			Vector3d vecRef = pt1 - _Pt0;
			vecRef.normalize();
			Point3d pt2 = pts[0];
			double dNext = plCirc.getDistAtPoint(pt2)-dEps;
			if (dNext == 0)dNext -= dEps;
			Point3d ptNext = plCirc.getPointAtDist(dNext);
			PLine pl(vecZ);
			pl.addVertex(_Pt0);
			pl.addVertex(pt1);
			pl.addVertex(pt2, ptNext);
			pl.close();
			dpJig.draw(PlaneProfile(pl),_kDrawFilled, 60);
			
			double dAngle = vecDir.angleTo(vecRef);
			String text; text.formatUnit(dAngle, 2, 1);
			text += "°";
			dpJig.draw(text, pt2, _XW, _YW, 0, 0, _kDeviceX);
			
			
		}
		
		return;
		
	}
//End Jig//endregion 
	




// bOnInsert
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
		
	// prompt for panels and its references
		PrEntity ssE(T("|Select panel(s)"), Sip());
		ssE.addAllowedClass(ChildPanel());
	  	Entity ents[0];
	  	if (ssE.go())
			ents.append(ssE.set());

	// collect panels
		Sip sips[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i];
			if (sip.bIsValid() && sips.find(sip)<0)
				sips.append(sip);
		}
		for (int i=0;i<ents.length();i++) 
		{ 
			ChildPanel child = (ChildPanel)ents[i]; 
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				if (sip.bIsValid() && sips.find(sip)<0)
					sips.append(sip); 				
			}
		}		


		if (sips.length()<1)
		{ 
			eraseInstance();
			return;
		}
		
		
	// prepare tsl cloning
		TslInst tslNew;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[] = {};
		Point3d ptsTsl[1];// = {};
		int nProps[]={};
		double dProps[]={dLength, dWidth, dDepth, dRadius, dRotation};
		String sProps[]={sSide,sOrientation};
		Map mapTsl;	
		String sScriptname = scriptName();

		int bRefSide = sSides.find(sSide, 0);
		
	// keep on prompting for points
		while(1)
		{ 
		// prompt for point input
			PrPoint ssP(TN("|Select point|")); 
			if (ssP.go()==_kOk) 
			{ 
				Point3d pt = ssP.value();
				ptsTsl[0] = pt;
				
			// tool pp
				PlaneProfile pp;
				
				
				
			// use only panels which intersect the tool	
				Point3d ptRef;
				Vector3d vecX, vecY, vecZ;
				double dZ;
				gbsTsl.setLength(0);				
				
				for (int i=0;i<sips.length();i++) 
				{ 
					Sip sip= sips[i];
					double _dZ = sip.dH();
					Point3d ptRef2 = sip.ptCenSolid()+sip.vecZ()*.5*(bRefSide?-_dZ:_dZ);

				// first defines ref plane and alignment	
					if (i==0)
					{
						ptRef = ptRef2;
						vecX = sip.vecX();
						vecY = sip.vecY();
						vecZ = sip.vecZ();
						dZ = _dZ;
						
						PLine pl;
						pl.createRectangle(LineSeg(pt-.5*(vecX*dLength+vecY*dWidth),pt+.5*(vecX*dLength+vecY*dWidth)), vecX, vecY);
						
					// rotate
						if (abs(dRotation)>0)
						{ 
							CoordSys cs;
							cs.setToRotation(dRotation, vecZ,pt);
							pl.transformBy(cs);
						}
						
						pp = PlaneProfile(CoordSys(pt, vecX, vecY, vecZ));
						pp.joinRing(pl, _kAdd);

						if (bDebug)
						{ 
							EntPLine epl;
							epl.dbCreate(pl);
							epl.setColor(i);
						}
					
					
					
					}
					else if (!sip.vecZ().isParallelTo(vecZ))
					{ 
						if (bDebug)reportMessage("\n" + scriptName() + ": " + sip.posnum() + " not parallel");
						continue;	
					}
					else if (abs(vecZ.dotProduct(ptRef - ptRef2))>dEps)
					{ 
						if (bDebug)reportMessage("\n" + scriptName() + ": " + sip.posnum() + " not in same plane "+ vecZ.dotProduct(ptRef - ptRef2));
						continue;	
					}

					
				// test intersection
					PlaneProfile ppSip(CoordSys(pt, vecX, vecY, vecZ));
					ppSip.joinRing(sip.plEnvelope(),_kAdd);
					if (bDebug)reportMessage("\n" + scriptName() + ": "  + sip.posnum() +" "  + pp.area() + " area");
					ppSip.intersectWith(pp);
					double dIntersectionArea = ppSip.area();

					if (dIntersectionArea>pow(dEps,2))
					{
						gbsTsl.append(sip);
					}
					else if (bDebug)
						reportMessage("\n" + scriptName() + ": " + sip.posnum() + " is not intersecting Area:" +dIntersectionArea+  " (" +gbsTsl.length()+")");
						
						
				}

				if (gbsTsl.length()>0)
					tslNew.dbCreate(sScriptname , _XU ,_YU,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);	
			}

			else 
				break;
		}
		eraseInstance();
		return;
	}	
// end on insert	__________________
	

// get references
	if (_Sip.length()<0)
	{ 
		reportMessage("\n" + scriptName() + ": "  + T(" |invalid reference|"));
		eraseInstance();
		return;
	}

// sip
	Sip sips[0];
	sips = _Sip;

// get common profile
	PlaneProfile ppCommon(sips.first().coordSys());
	for (int i=0;i<sips.length();i++) 
		ppCommon.joinRing(sips[i].plEnvelope(), _kAdd); 
	for (int i = 0; i < sips.length(); i++)
	{
		PLine plOpenings[] = sips[i].plOpenings();
		for (int j = 0; j < plOpenings.length(); j++)
			ppCommon.joinRing(plOpenings[j], _kSubtract);
	}


// ints
	int nSide = sSides.find(sSide, 0);
	int nOrientation = sOrientations.find(sOrientation);
	if (nOrientation < 0)nOrientation = 4;//center-center
	int bIsMortise, bIsHousing = sToolMode == tTMHouse;
	int bIsExtrusionn = sToolMode == tTMFreeProfile;
	
// orienation offsets
	double dX, dY;
	if (nOrientation<3)dX = -.5;//front
	else if (nOrientation>5)dX = .5;//back	
	if (nOrientation==0 ||nOrientation==3 || nOrientation==6)dY = .5;//left
	else if (nOrientation==2 ||nOrientation==5 || nOrientation==8)dY = -.5;//right		



// get coordSys most aligned to first panel
	Sip sip = sips.first();
	Quader qdr(sip.ptCen(), sip.vecX(), sip.vecY(), sip.vecZ(), sip.solidLength(), sip.solidWidth(), sip.solidHeight(), 0, 0, 0);
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	
	// maybe be a bit weired, but this is needed for compatibility reasons with older versions 
	// HSB-5393 CLT Pocket: do not rotate pocket when grain direction is toggled 
	if (!_Map.hasVector3d("vecX"))
	{
		_Map.setVector3d("vecX", vecX);
		_Map.setVector3d("vecY", vecY);
		_Map.setVector3d("vecZ", vecZ);
	}
	else
	{
		vecX= qdr.vecD(_Map.getVector3d("vecX"));
		vecY= qdr.vecD(_Map.getVector3d("vecY"));
		vecZ= qdr.vecD(_Map.getVector3d("vecZ"));
	}

//	vecX.vis(_Pt0, 1);
//	vecY.vis(_Pt0, 3);
//	vecZ.vis(_Pt0, 150);
	
	
	double dH = sip.dH();
	CoordSys cs(_Pt0, vecX, vecY, vecZ);
	
	Vector3d vecFace = (nSide ? 1 :-1) * vecZ;
	_Pt0 += vecFace * (vecFace.dotProduct(sips[0].ptCenSolid() - _Pt0) + .5 * dH);
	//vecFace.vis(_Pt0, 150);

	
//assignment
// declare a potential element ref
	Element el=sips[0].element();
	if (el.bIsValid())
	{
		assignToElementGroup(el,true,0,'T');
		_Element.append(el);	
	}
	else
		assignToGroups(sips[0], 'T');

	setEraseAndCopyWithBeams(_kBeam0);
	_ThisInst.setHyperlink("https://hsbcad.uservoice.com/knowledgebase/articles/1833748-hsbclt-pocket");
	
// TriggerFlipSide
	String sTriggerFlipSide = T("../|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		if (nSide==0)nSide=1;
		else nSide = 0;
		sSide.set(sSides[nSide]);
		setExecutionLoops(2);
		return;
	}
	if (_kNameLastChangedProp==sSideName)
	{ 
		setExecutionLoops(2);
		return;		
	}
	
// Trigger ExtendRadius//region
	int nExtendRadius = _Map.getInt("ExtendRadius");
	String sTriggerExtendRadius = T("../|Extend Radius in Direction|");
	if (abs(dRadius)>0)
	{ 
		addRecalcTrigger(_kContext, sTriggerExtendRadius );
		if (_bOnRecalc && _kExecuteKey==sTriggerExtendRadius)
		{
			int _nExtendRadius = getInt(T("|Enter index 1-9 to specify extension, 0 to remove extension.| (") + nExtendRadius + ")");
			if (_nExtendRadius >0 && _nExtendRadius < 10 && _nExtendRadius!=5)
				_Map.setInt("ExtendRadius", _nExtendRadius);
			else
				_Map.removeAt("ExtendRadius", true);
			setExecutionLoops(2);
			return;
		}
	
	// Trigger RemoveExtendRadius
		String sTriggerRemoveExtendRadius = T("../|Remove Extended Radius|");
		if (nExtendRadius>0)
			addRecalcTrigger(_kContext, sTriggerRemoveExtendRadius );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveExtendRadius)
		{
			_Map.removeAt("ExtendRadius", true);		
			setExecutionLoops(2);
			return;
		}	
	
		
	}
	else
		_Map.removeAt("ExtendRadius", true);
//endregion	
	


// trigger: add panel
	String sAddPanelTrigger = T("../|Add Panel|");
	addRecalcTrigger(_kContext, sAddPanelTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddPanelTrigger ) 
	{
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents= ssE.set();
		for (int i=0; i<ents.length();i++)	
		{
			Sip sipThis = (Sip)ents[i];
			if (_Sip.find(sipThis)<0)
				_Sip.append(sipThis);	
		}
		setExecutionLoops(2);
		return;
	}

// trigger: remove panel
	if (_Sip.length()>1) 
	{
		String sRemoveTrigger = T("../|Remove Panel|");
		addRecalcTrigger(_kContext, sRemoveTrigger );
		if (_bOnRecalc && _kExecuteKey==sRemoveTrigger) 
		{
			Entity ents[0];
			PrEntity ssE(T("|Select panels|"), Sip());
			if (ssE.go())
				ents= ssE.set();
			for (int i=0; i<ents.length();i++)		
			{
				Sip sipThis = (Sip)ents[i];
				int s = _Sip.find(sipThis);
				if (s>-1 && _Sip.length()>1)
				{
					_Sip.removeAt(s);
					break;	
				}
			}	
			setExecutionLoops(2);	
		}
	}

// rotate
	if (abs(dRotation)>0 && _kNameLastChangedProp!="_PtG0")
	{ 
		cs.setToRotation(dRotation, vecZ,_Pt0);//nSide?dRotation:-dRotation
		vecX.transformBy(cs);
		vecY.transformBy(cs);
	}
	
// rotation grip
	if (_PtG.length()<1)
	{ 
		_PtG.append(_Pt0 + vecY * .25 * dWidth);
	}
	else
	{
		_PtG[0].transformBy(vecZ * vecZ.dotProduct( _Pt0 - _PtG[0]));
	}
	addRecalcTrigger(_kGripPointDrag, "_PtG0");
	
// on _PtG change
	if(_kNameLastChangedProp=="_PtG0")
	{ 
		Vector3d vec = _PtG[0] - _Pt0;
		vec.normalize();

		dRotation.set(vecY.angleTo(vec));
		cs.setToRotation(dRotation, vecZ,_Pt0);
		vecY.transformBy(cs);
		_PtG[0] = _Pt0+vecY*.25 * dWidth;
		setExecutionLoops(2);
		return;
		
	}

// on rotation property change
	if (_kNameLastChangedProp==sRotationName)
	{ 
		_PtG[0] = _Pt0+vecY*.25 * dWidth;
	}

// the reference of the mortise
	Point3d ptRef = _Pt0+vecX * dX*dLength + vecY * dY*dWidth;
	//ptRef.vis(6);



// adjust width or length
// Trigger Stretch
	String sTriggerStretch = T("|Stretch Dimension|");
	addRecalcTrigger(_kContextRoot, sTriggerStretch );
	if (_bOnRecalc && (_kExecuteKey==sTriggerStretch || _kExecuteKey==sDoubleClick))
	{
	// prompt for point input
		Point3d ptX=ptRef;
		PrPoint ssP(TN("|Select point|"), ptRef); 
		if (ssP.go()==_kOk) 
			ptX=ssP.value();
		
	// get extension length/width
		double dDeltaX = vecX.dotProduct(ptX - ptRef);
		double dDeltaY = vecY.dotProduct(ptX - ptRef);
		
	// extent length
		if (abs(dDeltaX)>dEps)
		{
			double dNew = abs(dDeltaX);
			Vector3d vecDir = dDeltaX<0?-vecX:vecX;
			if (nOrientation>2 && nOrientation<6)
			{
				dNew += .5 * dLength;
				_Pt0.transformBy(vecDir * .5*(dNew - dLength));
			}
			else
			{
				if ((nOrientation>5 && dDeltaX<0)   || (nOrientation<3 && dDeltaX>0))
					_Pt0.transformBy(vecDir * (dNew-vecDir.dotProduct(_Pt0-ptRef)));				
				dNew += .5 * dLength;	
			}
			dLength.set(dNew);
		}
	// extent width
		if (abs(dDeltaY)>dEps)
		{ 
			double dNew = abs(dDeltaY);
			Vector3d vecDir = dDeltaY<0?-vecY:vecY;
			if (nOrientation==1 || nOrientation==4 || nOrientation==7)// center
			{
				dNew += .5 * dWidth;
				_Pt0.transformBy(vecDir * .5*(dNew - dWidth));
			}
			else
			{
				if (((nOrientation==0 || nOrientation==3 || nOrientation==6) && dDeltaY<0)   ||
					((nOrientation==2 || nOrientation==5 || nOrientation==8)&& dDeltaY>0))
					_Pt0.transformBy(vecDir * (dNew-vecDir.dotProduct(_Pt0-ptRef)));				
				dNew += .5 * dWidth;	
			}
			dWidth.set(dNew);
		}
		_PtG[0] = _Pt0+vecY*.25 * dWidth;
		setExecutionLoops(2);
		return;
	}	

// get extend flags
	int nExtendLength, nExtendWidth;
	if (nExtendRadius>0 && nExtendRadius<10)
	{ 
		if (nExtendRadius<4)nExtendLength=1;
		else if (nExtendRadius > 6)nExtendLength = -1;
		if (nExtendRadius==1 || nExtendRadius==4 ||  nExtendRadius==7)nExtendWidth = 1;
		else if (nExtendRadius==3 || nExtendRadius==6 || nExtendRadius==9)nExtendWidth = -1;
	}	


// the depth
	double dThisDepth = dDepth <= 0 ? dH : dDepth;
	double dExtLength = abs(nExtendLength*dRadius), dExtWidth=abs(nExtendWidth*dRadius);
	double dDiameter; // 0 if tool assignment has failed
	double dCleanUp;
	int nToolIndex;
	String sToolName;
	double dToolLength;

// find corresponding tool		
// order descending
	for (int i=0;i<dDiameters.length();i++) 
		for (int j=0;j<dDiameters.length()-1;j++) 
		if (dDiameters[j] < dDiameters[j + 1])
		{
			dDiameters.swap(j, j + 1);
			nToolIndices.swap(j, j + 1);	
			sToolNames.swap(j, j + 1);
			dLengths.swap(j, j + 1);			
		}

	for (int i=0;i<dDiameters.length();i++) 
		if (dDiameters[i]<=abs(dRadius)*2)
		{
			dDiameter=dDiameters[i]; 
			nToolIndex = nToolIndices[i];
			sToolName = sToolNames[i];
			dToolLength = dLengths[i];
			break;
		}
		
	if(dDiameter<=0 && dDiameters.length()>0)
	{ 
		dDiameter=dDiameters.last(); 
		nToolIndex = nToolIndices.last();
		sToolName = sToolNames.last();
		dToolLength = dLengths.last();		
	}
		

// the pocket
	if (dLength>dEps && dWidth>dEps && dThisDepth>dEps)
	{ 
	
	// Trigger ShowSize
		
		int bShowSize = _Map.getInt("ShowSize");
		String sTriggerShowSize =bShowSize?T("|Hide Size in Shopdrawing|"):T("|Show Size in Shopdrawing|");
		addRecalcTrigger(_kContext, sTriggerShowSize);
		if (_bOnRecalc && _kExecuteKey==sTriggerShowSize)
		{
			bShowSize = bShowSize ? false : true;
			_Map.setInt("ShowSize", bShowSize);		
			setExecutionLoops(2);
			return;
		}
		String sSize;
		if (bShowSize)sSize = String().formatUnit(dLength, 2, 0) + "x" + String().formatUnit(dWidth, 2, 0) + "\\P" + String().formatUnit(dThisDepth, 2, 0);
	
	
	//region Display
	
	// Display
		int ncText = nSide == 0 ? 6 : 3;
		Display dp(nSide==0?6:3),dpText(ncText);
		dp.showInDxa(true);// HSB-23004
		dpText.showInDxa(true);// HSB-23004
		PlaneProfile pp(CoordSys(_Pt0, vecX, vecY, vecZ));
		
	//End Display//endregion 
	
	//region FREEPROFILE

		
		// HSB-19449
		int bIsFreeProfile = (dWidth>=U(1000) || (dRadius>0 && bIsExtrusionn))?true:false; // force freeprofile to overcome BTL limitation
		int bIsMortise = !bIsFreeProfile;
		if (bIsHousing)
		{
			bIsFreeProfile = false;
			bIsMortise = false;
		}
		
		
		if (dRadius<0)
		{ 

			if (dDiameter>0)
			{
				bIsFreeProfile = true;
				bIsMortise = !bIsFreeProfile;
				bIsHousing = !bIsFreeProfile;
				
				double radius = .5 * dDiameter;
				
				if (dRadius<0)
				{ 
					dExtLength =abs(nExtendLength*radius)*2;
					dExtWidth =abs(nExtendWidth*radius)*2;	
					
					dCleanUp = 2*sqrt(pow(radius, 2) * .5);
				}


				
				
				PLine plTool(-vecZ);//((nSide?1:-1)*vecZ);
				
				Point3d pt0,pt1,pt2,pt3;
		
				pt0 = ptRef - vecX *.5*(dLength+dExtLength)- vecY *.5*(dWidth+dExtWidth);
//				vecX.vis(pt0, 1);
//				vecY.vis(pt0, 3);				
				Vector3d vecA = vecY;
				Vector3d vecB = vecX;
				double dA = dWidth+dExtWidth+dCleanUp;
//				pt0.vis(2);
				//plTool.addVertex(pt0);
				for (int i=0;i<4;i++) 
				{ 
					dA -= 2 * dCleanUp;
					pt1 = pt0+vecA*dA;				//pt1.vis(1);
					pt2 = pt1+vecA*(dCleanUp);		//pt2.vis(3);
					pt3 = pt2 + vecB*dCleanUp;		//pt3.vis(2);
		
					plTool.addVertex(pt1);
					plTool.addVertex(pt3,pt2);			
					
					pt0 = pt3;
					if (i == 0)
					{
						vecA = vecX;
						vecB = - vecY;
						dA = dLength+dExtLength;
					}
					else if (i == 1)
					{
						vecA = -vecY;
						vecB = - vecX;
						dA = dWidth+dExtWidth;
					}
					else if (i == 2)
					{
						vecA = -vecX;
						vecB = vecY;
						dA = dLength+dExtLength;
					}
			 
				}//next i
				plTool.close();						//plTool.vis(5);
				plTool.transformBy(vecX * nExtendLength * radius - vecY * nExtendWidth * radius);
				plTool.offset(-.5*dDiameter);		plTool.vis(2);
				plTool.offset(dDiameter, false);	plTool.vis(4);
				plTool.offset(-.5*dDiameter);		plTool.vis(3);
				
				plTool.flipNormal();
				FreeProfile fp;	//##
				plTool.convertToLineApprox(U(5)); // performance improvement HSB-7487
				fp=FreeProfile(plTool, plTool.vertexPoints(true));
				fp.setMachinePathOnly(false);
				fp.setDepth(dDepth);
				fp.setCncMode(nToolIndex);
				//fp.cuttingBody().vis(6);			
				

				//fp.addMeToGenBeamsIntersect(sips); // HSB-7487 replaced with addTool due to performance	
				for (int i=0;i<sips.length();i++) 
					sips[i].addTool(fp); 				
				pp.joinRing(plTool, _kAdd);
				
				PLine plBox;
				plBox.createRectangle(LineSeg(ptRef - vecX *.5*(dLength+dExtLength)- vecY *.5*(dWidth+dExtWidth),
												ptRef +vecX *.5*(dLength+dExtLength)+ vecY *.5*(dWidth+dExtWidth)),vecX,vecY);
				//plBox.vis(6);
				_Map.setPLine("plTool", plBox);// store before segmmentation
			}
		}
		else if (bIsFreeProfile && dRadius>0)
		{ 
			PLine plBox(vecZ);
			
			double dA = dLength + dExtLength;
			double dAR = dLength + dExtLength - 2 * dRadius;
			double dB = dWidth + dExtWidth;
			double dBR = dWidth + dExtWidth - 2 * dRadius;
			
			Point3d pt, pts[0];
			pt = ptRef + vecX * .5 * dAR - vecY * .5 * dB;	//vecX.vis(pt, 1);vecY.vis(pt, 3);
			plBox.addVertex(pt);
			pt += dRadius * (vecX +vecY);
			plBox.addVertex(pt, tan(22.5));
			if (dBR>dEps)
				pt += vecY * dBR;
			plBox.addVertex(pt);
			pt += dRadius * (-vecX +vecY);
			plBox.addVertex(pt, tan(22.5));			
			if (dAR>dEps)
				pt -= vecX * dAR;
			plBox.addVertex(pt);	
			pt -= dRadius * (vecX +vecY);
			plBox.addVertex(pt, tan(22.5));	
			if (dBR>dEps)
				pt -= vecY * dBR;
			plBox.addVertex(pt);
			pt += dRadius * (vecX -vecY);
			plBox.addVertex(pt, tan(22.5));	
			plBox.close();
			
			
			
			if (dAR>=0 && dBR>=0)
			{ 
				plBox.vis(3);
				plBox.convertToLineApprox(U(5)); // performance improvement HSB-7487
				FreeProfile fp;	//##
				fp=FreeProfile(plBox, plBox.vertexPoints(true));
				fp.setMachinePathOnly(false);
				fp.setDepth(dDepth);
				fp.setCncMode(nToolIndex);
				//fp.cuttingBody().vis(6);			
				
	
				//fp.addMeToGenBeamsIntersect(sips); // HSB-7487 replaced with addTool due to performance	
				for (int i=0;i<sips.length();i++) 
					sips[i].addTool(fp); 				
				pp.joinRing(plBox, _kAdd);	
				
				_Map.setPLine("plTool", plBox);// store before segmmentation
			}
			else
			{
				bIsFreeProfile = false;
				bIsMortise = !bIsHousing;
				_Map.removeAt("plTool", true);
			}
			
			
			
		}
		else
		{ 
			_Map.removeAt("plTool", true);// remove a potential entry
		}
	//End FREEPROFILE//endregion 

	//region MORTISE
		if (bIsMortise && (!dRadius<0 || dCleanUp<=0))
		{ 
			Point3d pt = ptRef;
			pt +=.5*(vecX * nExtendLength *  dRadius-vecY * nExtendWidth * dRadius);//pt.vis(2);	
			
			
			Mortise ms(pt, vecX, vecY, -vecFace, dLength+dExtLength, dWidth+dExtWidth, dThisDepth, 0, 0,1);	
			ms.setRoundType(_kExplicitRadius);
			ms.setExplicitRadius (dRadius);
			ms.addMeToGenBeamsIntersect(sips);	
			pp = ms.cuttingBody().shadowProfile(Plane(_Pt0, vecZ));			
		}

	//End MORTISE//endregion 	
	
	//region HOUSE
		else if (bIsHousing && (!dRadius<0 || dCleanUp<=0))
		{ 
			Point3d pt = ptRef;
			pt +=.5*(vecX * nExtendLength *  dRadius-vecY * nExtendWidth * dRadius);//pt.vis(2);	
			
			double diams[0];//diams = dDiameters;
			if (diams.length()<1)
			{
				FreeProfile fp;
				fp.setCncMode(0);			diams.append(fp.millDiameter());
				fp.setCncMode(2);			diams.append(fp.millDiameter());
			}
			diams=diams.sorted();
			
			int roundType = _kNotRound;
			if (diams.length()>0)
			{ 
				if (dRadius<0 && abs(dRadius)>diams[0])			roundType=_kRelief;//:  relief 
				else if (dRadius<0 && abs(dRadius)>diams[0])	roundType=_kReliefSmall;//:  relief with small diameter
				else if (dRadius>0 && abs(dRadius)>diams[0])	roundType=_kRounded;//:  rounded 
				else if (dRadius>0)								roundType=_kRoundSmall;//:  rounded 				
			}

			House hs(pt, vecX, vecY, -vecFace, dLength+dExtLength, dWidth+dExtWidth, dThisDepth, 0, 0,1);	
			hs.setRoundType(roundType);
			hs.addMeToGenBeamsIntersect(sips);	
			pp = hs.cuttingBody().shadowProfile(Plane(_Pt0, vecZ));			
		}

	//End HOUSE//endregion 
		
	// invalid tool
		pp.intersectWith(PlaneProfile(ppCommon));
		if (pp.area()<pow(dEps,2))
		{ 
			reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
			if (!bDebug)eraseInstance();
			return;				
		}
		
	// draw	
		if (bIsFreeProfile)
		{ 
			String k;
			Map mapDisplay= mapSetting.getMap("Display");
			Map m = mapDisplay;
			int nc=nSide==0?6:3,nt;
			k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);
			k="Color";				if (m.hasInt(k))	nc = m.getInt(k);
			k="ColorRef";			if (m.hasInt(k) && nSide==-1)	nc = m.getInt(k);
//			k="DimStyle";			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k),-1)>-1)	sDimStyle = m.getString(k);
//			k="TextHeight";			if (m.hasDouble(k))	{textHeight = m.getDouble(k);dp.textHeight(textHeight);}

			k="Extrusion";		
			if (mapDisplay.hasMap(k))
			{
				m = mapDisplay.getMap(k);
				k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);
				k="Color";				if (m.hasInt(k))	nc = m.getInt(k);
				k="ColorRef";			if (m.hasInt(k) && nSide==-1)	nc = m.getInt(k);
//				k="DimStyle";			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k),-1)>-1)	sDimStyle = m.getString(k);
//				k="TextHeight";			if (m.hasDouble(k))	textHeight = m.getDouble(k);				
			}

			if (nc == -2)nc = nToolIndex;
			dp.color(nc);
			dp.draw(pp);
			if (nt > 0) dp.draw(pp, _kDrawFilled, nt);			
		}
		else
			dp.draw(pp);
		dp.color(150);
		dp.draw(PLine(ptRef, ptRef-vecFace*dThisDepth));


	// declare dim request map
		Map mapRequests, mapRequest;

	// Radius dimRequest
		if (dRadius!=0)
		{ 
			dpText.addViewDirection(vecFace);
			dpText.addViewDirection(-vecFace);
			
			
			double dTextHeight = U(25);
			if (abs(dRadius) < dTextHeight) dTextHeight = abs(dRadius);
			
			double d = abs(dRadius)>1.5*dTextHeight?dTextHeight:abs(dRadius);
			if (dRadius < 0 && d > dTextHeight)d = dTextHeight;
			
			Point3d pt = ptRef + vecX * (.5 *dLength - d) + vecY * (.5 *dWidth - d);
			
			//Point3d ptC = ptRef + vecX * (.5 * dLength ) + vecY * (.5 * dWidth );ptC.vis(2);
			Point3d ptCenter = ptRef + vecX * (.5 * dLength - abs(dRadius)) + vecY * (.5 * dWidth - abs(dRadius));
			Vector3d vecN = - (vecX + vecY);vecN.normalize();
			Point3d ptChoord = ptCenter -vecN* dRadius ;
			
		// overshoot
			if (dRadius<0)
			{ 
				ptChoord = ptCenter- vecN * (abs(dRadius)/cos(45));
				ptCenter =  ptChoord- vecN * abs(dRadius);
			}
			//ptChoord.vis(3);ptCenter.vis(2);
			
			
			String sText = dDiameter>0?(dRadius<0?-1:1)*dDiameter*.5:dRadius;
			if (bIsMortise)sText = dRadius;
			if (sText.length()>2)
				dTextHeight = dTextHeight / sText.length() * 2;
			dpText.textHeight(dTextHeight);
			//pt.vis(2);
			dpText.draw(sText, pt, vecX, vecY, 0, 0, _kDevice);
			
		// publish text info in a request map
			mapRequest.setInt("Color", ncText);
			mapRequest.setVector3d("AllowedView", vecZ);
			mapRequest.setInt("AlsoReverseDirection", true);		
			//mapRequest.setDouble("textHeight", dTextHeight);
			
			mapRequest.setPoint3d("ptLocation",ptRef);	
			//mapRequest.setPoint3d("ptScale",pt);
			mapRequest.setVector3d("vecX", vecX);
			mapRequest.setVector3d("vecY", vecY );
			mapRequest.setInt("deviceMode", _kDevice);
			mapRequest.setDouble("dXFlag", 0);
			mapRequest.setDouble("dYFlag", 0);			
			mapRequest.setString("text", "R"+sText + "\P" + sSize);	
			mapRequests.appendMap("DimRequest",mapRequest);		

			mapRequest = Map();
			mapRequest.setString("DimRequestRadial", scriptName());
			mapRequest.setString("StereoType", "*");
			mapRequest.setVector3d("AllowedView", vecZ);
			mapRequest.setInt("AlsoReverseDirection", true);
			mapRequest.setPoint3d("ptCenter",ptCenter);	
			mapRequest.setPoint3d("ptChoord",ptChoord);
			mapRequests.appendMap("DimRequest", mapRequest);
		}
		

		
		
	// display coordinate axises
		Point3d ptAxis=ptRef;
		double dXAxis = .5*dLength;	
		double dYAxis = .5*dWidth;
		
	// 	collect placement points
		Point3d pts[0];
		pts.append(ptAxis + vecX * dXAxis-vecY*dYAxis);
		pts.append(ptAxis + vecX * dXAxis);
		pts.append(ptAxis + vecX * dXAxis+vecY*dYAxis);
		pts.append(ptAxis -vecY*dYAxis);
		pts.append(ptAxis );
		pts.append(ptAxis +vecY*dYAxis);		
		pts.append(ptAxis - vecX * dXAxis-vecY*dYAxis);
		pts.append(ptAxis - vecX * dXAxis);
		pts.append(ptAxis - vecX * dXAxis+vecY*dYAxis);		
		
		
		
		PLine plXPos (ptAxis, ptAxis+vecX*dXAxis);
		PLine plXNeg (ptAxis, ptAxis-vecX*dXAxis);
		PLine plYPos (ptAxis, ptAxis+vecY*dYAxis);
		PLine plYNeg (ptAxis, ptAxis-vecY*dYAxis);
		
		Display dpAxis(7);
		dpAxis.showInDxa(true);// HSB-23004
		dpAxis.color(1);		dpAxis.draw(plXPos);
		dpAxis.color(14);		dpAxis.draw(plXNeg);
		dpAxis.color(3);		dpAxis.draw(plYPos);
		dpAxis.color(96);		dpAxis.draw(plYNeg);

		dpAxis.textHeight(U(5));
		for (int i=0;i<pts.length();i++) 
		{ 
			dpAxis.color(bShowSize && i==4 ?2:252);
			dpAxis.draw((i+1),pts[i], vecX, vecY,0,0,_kDevice); 
			 
		}//next i
		
		
	// publish dim requests	
		_Map.setMap("DimRequest[]", mapRequests);		
		
	}
	else
	{ 
		reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

// Store last grip position
	_Map.setVector3d("Grip0", _PtG[0] - _PtW);


//region Trigger
{
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	

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
		nProps.append(nToolIndex);//nToolIndex);
		sProps.append(sToolName);

		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				nToolIndex= tslDialog.propInt(0);
				dDiameter= tslDialog.propDouble(0);
				dToolLength= tslDialog.propDouble(1);
				String _sToolName= tslDialog.propString(0);

			// add if not found
				int nameFound = sToolNames.findNoCase(_sToolName,-1);
				int toolIndexFound = nToolIndices.find(nToolIndex);
				
				// add
				if (nameFound<0 && toolIndexFound<0) // add: name and tool index not found yet
				{ 					
					//reportMessage(TN("|add diam to| ") + dDiameter);
					sToolNames.append(_sToolName);
					dDiameters.append(dDiameter);
					dLengths.append(dToolLength);
					nToolIndices.append(nToolIndex);
				}
				// change properties of tool name if tool index is not found anywhere else
				else if (nameFound>-1 && (toolIndexFound<0 || toolIndexFound==nameFound))
				{ 
					
					sToolNames[nameFound]=_sToolName;
					dDiameters[nameFound]=dDiameter;
					dLengths[nameFound]=dToolLength;
					nToolIndices[nameFound]=nToolIndex;			
				}
				else if (toolIndexFound>-1)
				{ 
					Map mapIn;
					mapIn.setString("Title", T("|Inconsistent Tool Parameters|"));
					mapIn.setString("st", T("|The tool could not be set as index is already used for another tool|"));
					Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowMultilineNotice", mapIn);
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
L]D+64;XPH7FLG_A&@C'R+V:-2?NBMZB@#$C\-PB99);F:4J<C)K;HHH`_]G$
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="968" />
        <int nm="BreakPoint" vl="1154" />
        <int nm="BreakPoint" vl="1050" />
        <int nm="BreakPoint" vl="1059" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23004: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/5/2024 9:53:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19449 new option for tool mode proeprty to force housings, new context commands to edit tool settings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/25/2023 10:08:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19449 new property tool mode to force extrusion tool" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/11/2023 3:57:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11214 hsbCLT-Pocket will be exported as free profile as sson as the width is greater or equal then 1000mm. This is primarly to overcome BTL limitations on 4-050" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/16/2021 10:02:12 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End