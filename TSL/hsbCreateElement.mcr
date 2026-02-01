#Version 8
#BeginDescription
This tsl creates an element of type ElementRoof and assigns entities to detected zones

 #Versions
Version 2.5 10.01.2023 HSB-17018 wording improved
Version 2.4    05.08.2022 HSB-16199 Major update, new properties allow faster and more specific creation of elements
Version 2.3    15.03.2022 HSB-14836: no translation for options
Version 2.2    15.09.2021 HSB-13188: fix the options at the prompt
Version 2.1    09.04.2021 HSB-11500 - Zone 0 assignment corrected
Version 2.0    08.04.2021 HSB-11489 new command line options DrawContour and createRectangle added
Version 1.9    08.04.2021 HSB-11464 various options added to allow shape modifications during insert. Zone assignment enhanced, new preview during insert.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords Element;Beam;Sandwich;Panel
#BeginContents
//region Part #1

//region <History>

// #Versions
// 2.5 10.01.2023 HSB-17018 wording improved , Author Thorsten Huck
// 2.4 05.08.2022 HSB-16199 Major update, new properties allow faster and more specific creation of elements , Author Thorsten Huck
// 2.3 15.03.2022 HSB-14836: no translation for options Author: Marsel Nakuci
// Version 2.2 15.09.2021 HSB-13188: fix the options at the prompt Author: Marsel Nakuci
// 2.1 09.04.2021 HSB-11500 - Zone 0 assignment corrected , Author Thorsten Huck
// 2.0 08.04.2021 HSB-11489 new command line options DrawContour and createRectangle added , Author Thorsten Huck
// 1.9 08.04.2021 HSB-11464 various options added to allow shape modifications during insert. Zone assignment enhanced, new preview during insert. , Author Thorsten Huck
/// <version value="1.8" date="23nov2020" author="alberto.jena@hsbcad.com"> SetPanhand of the selected beams  </version>
/// <version value="1.7" date="10jan2020" author="thorsten.huck@hsbcad.com"> HSB-6318 accepting trusses which overlap zone 0 </version>
/// <version value="1.6" date="09jan2020" author="thorsten.huck@hsbcad.com"> HSB-6318 format variables extended, roofplane support, collection and truss entity support added </version>
/// <version value="1.5" date="20feb2018" author="thorsten.huck@hsbcad.com"> bugfix </version>
/// <version value="1.4" date="20feb2018" author="thorsten.huck@hsbcad.com"> property 'Prefix' renamed and extended: it is now possible to type format expressions to rule the element name, wall alignment added if a defining entity is aligned like wall in model, new prompt to pick main view side</version>
/// <version value="1.3" date="18dec2017" author="thorsten.huck@hsbcad.com"> netto profile set on creation </version>
/// <version value="1.2" date="12apr2017" author="thorsten.huck@hsbcad.com"> zone assignment improved </version>
/// <version value="1.1" date="11apr2017" author="thorsten.huck@hsbcad.com"> new property to toggle exclusive / non exclusive group assignment </version>
/// <version value="1.0" date="10apr2017" author="thorsten.huck@hsbcad.com"> initial </version>


/// <insert Lang=en>
/// Select entities of the element to be created.
/// </insert>

// <summary Lang=en>
// This tsl creates an element of type ElementRoof and assigns entities to detected zones
//	The user can specify a building and floor group as well as an optional prefix of the element number.
// The tsl iterates through all selected beams, sheets and panels (genbeams) and sets zones based on the Z-location
// of a reference genbeam or collection entity.

// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCreateElement")) TSLCONTENT
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
	
	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int lightcyan = rgb(182, 252, 248);
	int darkcyan = rgb(0, 97, 94);
	int lightblue = rgb(199, 228, 255);
	int green = rgb(88,186,72);//19, 155, 72  
	int red = rgb(205,32,39);
	int blue = rgb(39,118,187);
	int orange = rgb(255,63,0);//205,105,40
	int darkyellow = rgb(254, 204, 102);
	
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);	
	
	double dMerge = U(20);
	
	String tDefault = T("<|Default|>"), tNew = T("|Enter new Name|"), tRefByPanel = T("|byPanel|"), tCMBoundary= T("|Bounding Shadow|"), tCMRectangle= T("|Draw Rectangle|"), tCMBlowShrink= T("|Purge Contour|");
	String tSave = T("|Save|"),tSaveExport = T("|Save + Export|"),tDelete = T("|Delete|");  
	String kReferencePlane = "ReferencePlane", kContourMode = "ContourMode";
	
	String sStrategies[0];
	
		
	String sReferencePlanes[] = {tDefault, tRefByPanel };
	String sContourModes[] = {tDefault, tCMBoundary,tCMBlowShrink};//,tCMRectangle
	String sActions[] = {tSave, tSaveExport,tDelete};
//end Constants//endregion

//region bOnJig
	if (_bOnJig && _kExecuteKey=="Jig1") 
	{

	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    
	    Point3d ptOrg = _Map.getPoint3d("ptOrg");
	    Vector3d vecX = _Map.getVector3d("vecX");
	    Vector3d vecY = _Map.getVector3d("vecY");
	    Vector3d vecZ = _Map.getVector3d("vecZ");
	    Entity entDefine = _Map.getEntity("entDefine");
	    int bCreateRectangle = _Map.getInt("createRectangle");
	    Point3d ptsContour[] = _Map.getPoint3dArray("ptsContour");
	    
	    Plane pnView(ptOrg, vecZView);
	    CoordSys csView(ptOrg, vecXView, vecYView, vecZView);
	   
	//region Orbit CoordSys
	    int nFree= _Map.getInt("FreeDir");
	    if(nFree>0)
	    { 
	    	Vector3d vecDir = ptJig - ptOrg;
	    	vecDir.normalize();
	    	
	    	if (nFree ==1)
	    	{ 
	    		if (vecDir.isParallelTo(vecZ))vecZ = -vecX;
	    		vecX = vecDir;
	    		vecY = vecX.crossProduct(-vecZ);	vecY.normalize();
	    		vecZ = vecX.crossProduct(vecY);		vecZ.normalize();
	    	}
	    	else if (nFree ==2)
	    	{ 
	    		if (vecDir.isParallelTo(vecX))vecX = vecY;
	    		vecY = vecDir;
	    		vecZ = vecX.crossProduct(vecY);		vecY.normalize();
	    		vecX = vecY.crossProduct(vecZ);		vecZ.normalize();
	    	}
	    	else if (nFree ==3)
	    	{ 
	    		if (vecDir.isParallelTo(vecX))vecX = vecZ;
	    		vecZ = vecDir;
	    		vecY = vecX.crossProduct(-vecZ);	vecY.normalize();
	    		vecX = vecY.crossProduct(vecZ);		vecX.normalize();
	    	}	    	
	    }			
	//End Orbit CoordSys//endregion 

	    
	    
	// the default contour    
	    PlaneProfile ppContour = _Map.getPlaneProfile("Contour");
	    ppContour.removeAllOpeningRings();
	    PLine rings[] = ppContour.allRings(true,false);
	    
	//region Create Rectangle / Polygon
		if (bCreateRectangle)	
		{
			ppContour.createRectangle(LineSeg(ptOrg, ptJig), vecX, vecY);
			rings = ppContour.allRings(true,false);
		}
		else if (ptsContour.length()>0)
		{ 
			PLine pl(vecZ);
			for (int i=0;i<ptsContour.length();i++) 
			{ 
				Point3d pt = ptsContour[i];
				pt += vecZ * vecZ.dotProduct(ptOrg - pt);
				pl.addVertex(pt);
			}//next i
			
			Point3d pt  = ptJig+vecZ * vecZ.dotProduct(ptOrg - ptJig);;
			pl.addVertex(pt);
			
			if (pl.area()<pow(dEps,2))
				pl.createConvexHull(Plane(ptOrg, vecZ),ptsContour);

			ppContour = PlaneProfile(CoordSys(ptOrg, vecX, vecY, vecZ));
			ppContour.joinRing(pl, _kAdd);
			rings = ppContour.allRings(true,false);
		}	
		
	//End Create Rectangle/ Polygon //endregion     
   
	    double dZ = _Map.getDouble("dZ");
	    double dZNeg = _Map.getDouble("dZNeg");
	    double dZPos = _Map.getDouble("dZPos");

	    Display dpJig(1);
	    dpJig.addViewDirection(vecZView);
	    if (entDefine.bIsValid())
	    { 
	    	PlaneProfile pp = entDefine.realBody().shadowProfile(pnView);
	    	dpJig.draw(pp,_kDrawFilled, 60);
	    	dpJig.draw(pp,_kDrawFilled, 60);
	    }

	    for (int r=0;r<rings.length();r++) 
	    { 
	    // zone 0 solid shadow	
	    	Body bd(rings[r], vecZ*dZ,-1);

	    // element boundaries
	    	dpJig.color(4);
	    	rings[r].transformBy(vecZ * dZNeg);
	    	Body bd2(rings[r], vecZ*(dZPos-dZNeg),1);
	    	LineSeg segs[]= bd2.hideDisplay(csView, false, true, true);
	    	dpJig.draw(segs);
	
		// zone 0 solid shadow
			dpJig.trueColor(bIsDark?darkcyan:lightcyan, 90);
		    dpJig.draw(bd.shadowProfile(pnView), _kDrawFilled, 0);	
	    }//next r
	    dpJig.draw(ppContour, _kDrawFilled, 0);	
	
	    PlaneProfile ppSub = ppContour;
	    ppSub.shrink(U(10));
	    ppContour.subtractProfile(ppSub);
	    dpJig.color(4);
	    dpJig.draw(ppContour, _kDrawFilled, 0);
		dpJig.draw(ppContour, _kDrawFilled, 0);
		dpJig.draw(ppContour, _kDrawFilled, 0);
//
	// draw coordSys
		double dScale = getViewHeight()/20;	
		Vector3d vecs[] ={ vecX, vecY, vecZ};
		for (int i=0;i<vecs.length();i++) 
		{ 
			Vector3d vec = vecs[i];
			Body bd(ptOrg, ptOrg + vec * dScale* 2 / 3 , .02 * dScale);
			bd.addPart(Body(ptOrg + vec * dScale* 2 / 3, ptOrg + vec * dScale, .1 * dScale, dEps));// 
			
			Display dp(i==0?1:(i==1?3:150));
			dp.addViewDirection(vecZView);
			dp.draw(bd.shadowProfile(pnView), _kDrawFilled,50);
			dp.draw(bd);
			
			if (_Map.hasInt("FreeDir") && nFree==0)
			{ 
				bd.transformBy(ptJig - ptOrg);
				dp.draw(bd);
			}
			
		}//next i
		
	// draw text
		String text = _Map.getString("Text");
		if (text.length()>0)
		{ 
			dpJig.color(4);
			dpJig.transparency(0);
			dpJig.textHeight(dScale*.6);
			dpJig.draw(text, ppContour.ptMid(), vecX, vecY,0,0,_kDevice);
		}

		if (0)
		{ 
			Display dp(2);
			dp.textHeight(U(40));
			dp.draw("ptsContour "+ptsContour.length() + "\\P"+_Map, ptJig, _XW, _YW, 1, 0, _kDevice);
		}
	   
	   
	   
	    return;
	}		
//End bOnJig//endregion 
 
//region Properties
// grouping
category = T("|Grouping|");
	String sHouseName=T("|Building Group|");	
	PropString sHouse(0, T("|Building|"), sHouseName);	
	sHouse.setDescription(T("|Defines the main group name|"));
	sHouse.setCategory(category);
	
	String sFloorName=T("|Storey Group|");	
	PropString sFloor(1, T("|Building|"), sFloorName);	
	sFloor.setDescription(T("|Defines the floor group name|"));
	sFloor.setCategory(category);

	String sFormatName=T("|Element Group|");	
	PropString sFormat(3, "EL_@(Number:PL3;0)", sFormatName);	
	sFormat.setDescription(T("|Defines the naming of the element by format expressions.|") + " " + TN("|If no format expression is found the naming will be incremental.|") +
		TN("   |i.e. @(Label) will name the element with contents of the label property of the source entity.|"));
	sFormat.setCategory(category);

category = T("|Geometry|");
	String sReferencePlaneName=T("|Reference Plane|");	
	PropString sReferencePlane(4, sReferencePlanes, sReferencePlaneName);	
	sReferencePlane.setDescription(T("|Defines the reference plane and type of object|")+ T("|Default = first entity defines type and reference plane.|"));
	sReferencePlane.setCategory(category);
	
	String sContourModeName=T("|Contour Mode|");	
	PropString sContourMode(5, sContourModes, sContourModeName);	
	sContourMode.setDescription(T("|Defines the default contour mode|")+ T("|Default = select by preview|"));
	sContourMode.setCategory(category);

	String sBlowupShrinkName=T("|Blowup + Shrink Value|");	
	PropDouble dBlowupShrink(nDoubleIndex++, U(0), sBlowupShrinkName);	
	dBlowupShrink.setDescription(T("|If the appropriate opztion is chosen the contour will be blown up and shrunken by this value which will close finger gaps.|"));
	dBlowupShrink.setCategory(category);

category = T("|Behaviour|");
	String sAddExclusiveName=T("|Add Exclusively|");	
	PropString sAddExclusive(2, sNoYes, sAddExclusiveName,1);	
	sAddExclusive.setDescription(T("|Defines if an entity already assigned to another group is to be exclusive to the new element being created (Yes), or is still be associated with the existing group(s) as well (No).|"));
	sAddExclusive.setCategory(category);

	String sTurnOffName=T("|Turn off new element|");	
	PropString sTurnOff(6, sNoYes, sTurnOffName);	
	sTurnOff.setDescription(T("|Defines if the newly created element group will be turned off|"));
	sTurnOff.setCategory(category);
	
	String sScriptListName=T("|Plugin TSLs|");	
	PropString sScriptList(7, "", sScriptListName);	
	sScriptList.setDescription(T("|Specifies a list of tsls which will be attached to the element.|") +
		T(" |Only TSLs which will operate on an element and which do not require any additional input are supported.|") + 
		T(" |Separate multiple entries by a semicolon ';'|") + 
		T(" |Each tsl may be defined with a catalog entry, to do this append the catalog entry by a question mark '?'|") + 
		T(" |Example|: ") +"tslA?Fox ; tslB?Lion" + T(" |will attach a tslA with te catalog entry 'Fox' and tslB with the entry 'Lion'|")
		);
	sScriptList.setCategory(category);


	double dThickness;
	
	
			
//End Properties//endregion 

//End Part #1 //endregion 

//region OnInsert #1
	if (_bOnInsert)
	{
		//if (insertCycleCount()>1) { eraseInstance(); return; }
		
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
			showDialogOnce();
	}
//endregion 	

//region Group and element collection
// create group if not existant
	String house = sHouse;
	String floor = sFloor;
	String sComposedNumber;
	if (_kCurrentGroup.name()!="")
	{
		String part0 = _kCurrentGroup.namePart(0);
		String part1 = _kCurrentGroup.namePart(1);

		if (house.length()<1)
			house = _kCurrentGroup.namePart(0);

		if (floor.length()<1 && _kCurrentGroup.namePart(1).length()>0)
			floor = _kCurrentGroup.namePart(1);
	}
	if (house.length() < 1)house = T("|Building|");
	if (floor.length() < 1)floor = T("|Level|");
	Group grFloor(house + "\\" + floor);

// get all existing elements of this group
	Entity entsFloor[] = grFloor.collectEntities(true, Element(), _kModelSpace);
	Element elements[0];
	String sNumbers[0];
	for (int i = 0; i < entsFloor.length(); i++)
	{
		Element el = (Element)entsFloor[i];
		if (el.bIsValid())
		{
			elements.append(el);
			sNumbers.append(el.number());
		}
	}
	sNumbers.sorted();		
//endregion 

	
//region OnInsert #2
	if(_bOnInsert)
	{
	// flags	
		int bCMBoundary = sContourMode == tCMBoundary;
		int bCMBlowShrink= sContourMode == tCMBlowShrink;
		int bRefByPanel = sReferencePlane ==tRefByPanel;

	// prompt for entities
		Entity ents[0];
		String prompt = T("|Select entities|");
		if (sReferencePlane == tDefault)
			prompt += T(", |first selected specifies zone 0|");
		PrEntity ssE(prompt , Entity());
		if (ssE.go())
			ents.append(ssE.set());
		if (ents.length()<1)
		{
			eraseInstance();
			return;
		}

	//region Get bodies and defining entity
		GenBeam gbs[0];
		Sip sips[0];
		CollectionEntity ces[0];
		Body bodies[0];
		Entity entDefine;
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity ent = ents[i];
			GenBeam gb = (GenBeam)ent;
			Sip sip = (Sip)ent;
			CollectionEntity ce= (CollectionEntity)ent;
			
			if (sip.bIsValid())
				sips.append(sip);
			else if (gb.bIsValid())
				gbs.append(gb);
			else if (ce.bIsValid())
				ces.append(ce);
			
			if (!entDefine.bIsValid() && (gb.bIsValid() || ce.bIsValid() || sip.bIsValid()))
			{
				entDefine = ent;
			}
			_Entity.append(ent);
			Body bd = ent.realBody();
			bodies.append(bd);			
		}
		
	// overrule defining entity by strategy	
		if (bRefByPanel && sips.length()<1)
			bRefByPanel = false;
		if (bRefByPanel)
		{ 
		// use first sip which returns a value on the formatting
			int bSuccess;
			if (sFormat.find("@(",0,false)>-1)
			{ 
				for (int i=0;i<sips.length();i++) 
				{ 
					String text = sips[i].formatObject(sFormat);
					if (text.length()>0)
					{ 
						entDefine = sips[i];
						bSuccess = true;
						break;
					} 
				}//next i	
			}
		// use first sip which returns a value on the formatting
			if (!bSuccess)
				entDefine = sips.first();			
		}


		Vector3d vecX = _XU, vecY = _YU, vecZ = _ZU;
		Point3d ptOrg = _Pt0;			
	//endregion 	

	//region Zone 0 definition found
		if (entDefine.bIsValid())
		{ 
			_Map.setEntity("entDefine", entDefine);
			
			GenBeam gb = (GenBeam)entDefine;
			Sip sip = (Sip)entDefine;
			CollectionEntity ce= (CollectionEntity)entDefine;
			
			Body bd = entDefine.realBody();

		//region Set coordSys
			if (sip.bIsValid())
			{ 
				vecX = sip.vecX();
				vecY = sip.vecY();
				vecZ = sip.vecZ();
				ptOrg= sip.ptCen()-vecZ*.5*sip.dH();
				
			// override default if reference is a panel with grain direction
				if (!sip.woodGrainDirection().bIsZeroLength())
				{ 
					vecX = sip.woodGrainDirection();
					vecY = vecX.crossProduct(-vecZ);
				}				
			}
			else if (gb.bIsValid())
			{ 
				ptOrg= gb.ptCen();
				vecX = gb.vecX();
				vecY = gb.vecY();
				vecZ = gb.vecZ();				
			}
			else if (ce.bIsValid())
			{ 
				CoordSys cs = ce.coordSys();
				ptOrg= cs.ptOrg();
				vecX = cs.vecX(); // trusses coordSys is perp to element coordSys
				vecY = -cs.vecZ();
				vecZ = cs.vecY();			
			}

			
		// adjust defaults to wall / roof alignments
			if(vecZ.isParallelTo(_ZW)) // flattened or floor
			{ 
				if (vecX.isCodirectionalTo(-_XW))
				{ 
					vecX *= -1;
					vecY *= -1;					
				}
			}
			else if (vecZ.isPerpendicularTo(_ZW))// wall
			{
				if (vecX.isParallelTo(_ZW))// X-pointing upwards
				{ 
					vecY =_ZW;
					vecX = vecY.crossProduct(vecZ);					
				}	
			}
			else if (vecX.dotProduct(_ZW)<0)
			{ 			
				vecX *= -1;
				vecY *= -1;

				if(!vecZ.isPerpendicularTo(_ZW) && vecZ.dotProduct(_ZW)<0) // flip Z
				{ 
					vecZ *= -1;
					vecY *= -1;					
				}
			}

			
			Point3d ptsZ[] = bd.extremeVertices(vecZ);
		    if (!sip.bIsValid())
		    	ptOrg += vecZ * vecZ.dotProduct(ptsZ.last() - ptOrg);			
			
		//End Set coordSys//endregion 	

		// get overall contour
		 	Point3d ptsZExtr[0];		
		    Plane pnZ(ptOrg, vecZ);
		    PlaneProfile ppContour(CoordSys(ptOrg, vecX, vecY, vecZ));
		    for (int i=0;i<bodies.length();i++) 
		    { 
		    	Body& bd = bodies[i];
		    	ptsZExtr.append(bd.extremeVertices(vecZ));
		    	{ 
			    	PlaneProfile ppZ= bd.shadowProfile(pnZ);
		    		ppZ.shrink(-dEps);
		    		ppContour.unionWith(ppZ);	    		
		    	}	 
		    }//next i
			ppContour.shrink(dEps);
			ptsZExtr = Line(ptOrg, vecZ).orderPoints(ptsZExtr, dEps);
				    
		// make sure the profile consists only one ring
			{ 
				PLine rings[] = ppContour.allRings(true, false);
				PlaneProfile pp = ppContour;
				int nCnt;
				while(rings.length()>1 && nCnt<50)
				{
					pp.shrink(-dMerge*(nCnt+1));
					pp.shrink(dMerge*(nCnt+1));
					rings = pp.allRings(true,false);
					nCnt++;
				}
			    ppContour = pp;					
			}
			PlaneProfile ppShadow = ppContour;
			
			
		//region Strategy overrides
			if (dBlowupShrink>0)
			{ 
				ppContour.shrink(-dBlowupShrink);
				ppContour.shrink(dBlowupShrink);				
			}
		
			if (bCMBoundary)
			{ 
				ppContour.createRectangle(ppShadow.extentInDir(vecX), vecX, vecY);
				_Map.setPlaneProfile("Contour", ppContour);			
				return;
			}
			else if (bCMBlowShrink)
			{ 	
				_Map.setPlaneProfile("Contour", ppContour);			
				return;
			}			
			
			
		//endregion 	
			ptOrg = ppContour.ptMid() - .5 * (vecX * ppContour.dX() + vecY * ppContour.dY());

		// set jig arguments
		    Map mapArgs;
		    mapArgs.setVector3d("vecX", vecX); // add all the info you need for Jigging
		    mapArgs.setVector3d("vecY", vecY);
		    mapArgs.setVector3d("vecZ", vecZ);
		    mapArgs.setPoint3d("ptOrg", ptOrg);
			mapArgs.setPlaneProfile("Contour", ppContour);
			mapArgs.setPlaneProfile("Shadow", ppShadow);
			mapArgs.setDouble("dZ", bd.lengthInDirection(vecZ));
			mapArgs.setDouble("BlowupShrink", dBlowupShrink>0?dBlowupShrink:0);
			mapArgs.setEntity("entDefine", entDefine);
			
			mapArgs.setInt("_Highlight", in3dGraphicsMode()); 
			if (ptsZExtr.length()>0)
			{ 
				mapArgs.setDouble("dZNeg", vecZ.dotProduct(ptsZExtr.first()-ptOrg));
				mapArgs.setDouble("dZPos", vecZ.dotProduct(ptsZExtr.last()-ptOrg));				
			}

		//region Show Jig
			// HSB-13188
//			String prompt = T("|Pick datum, <Enter> to accept or [FlipSide/XRotate/YRotate/ZRotate/SelectReference/PurgeContour/rectangularContour/DrawContour/AddEntities/RemoveEntities]|");
//			String prompt = T("|Pick datum, <Enter> to accept or [FlipSide/Xrotate/Yrotate/Zrotate/SelectReference/PurgeContour/rectangularContour/DrawContour/AddEntities/RemoveEntities]|");
			// HSB-14836 no translation for options
			String prompt = T("|Pick datum, <Enter> to accept or|")+" "+ "[FlipSide/Xrotate/Yrotate/Zrotate/MainReference/BoundingShadow/PurgeContour/drawRectangularContour/DrawContour/AddEntities/removeEntities/formatText]";
			PrPoint ssP(prompt); // second argument will set _PtBase in map
		    int nGoJig = -1;
		    while (nGoJig != _kNone) // nGoJig != _kOk && 
		    {
			//region Numbering
			// functions in TSL would just be so nice	
			// get potential element name from source object and purge unresolved variables
				String sComposedNumber,sNumberSource = entDefine.formatObject(sFormat);
				{ 
					int x1 = sNumberSource.find("@(", 0);
					int x2 = sNumberSource.find(")", x1);
					while(x1>-1 && x2>-1)
					{ 
						String left = sNumberSource.left(x1);
						String right= sNumberSource.right(sNumberSource.length()-x2-1);
						sNumberSource = left + right;
						x1 = sNumberSource.find("@(", 0);	
						x2 = sNumberSource.find(")", x1);
					}	
				}
				
			// Identify if source contains a number at the end	
				int number;
				if (sNumberSource.length()>1)
				{ 
					int n1 = sNumberSource.right(1).atoi();
					int n2 = sNumberSource.right(2).atoi();
					int n3 = sNumberSource.right(3).atoi();
					int n4 = sNumberSource.right(4).atoi();
					if (n4 != 0)number=n4;
					else if (n3 != 0)number=n3;
					else if (n2 != 0)number=n2;
					else if (n1 != 0)number=n1;
				}	
				
			// Compose element number	
				if (number>0 && sNumbers.findNoCase(sNumberSource,-1)<0)
					sComposedNumber = sNumberSource;
				else
				{
					ElemNumber elemNum(Element().number());
					elemNum.setSequenceType(_kSTDigits);
					elemNum.setNumber(1);
					elemNum.setPrefix(sNumberSource);
					elemNum.setAmountOfDigits(3);
					sComposedNumber =elemNum.composed();
				}
				mapArgs.setString("Text", sComposedNumber);
			//End Numbering//endregion 
	        		    	
		    	
		    	
		        nGoJig = ssP.goJig("Jig1", mapArgs); 
		        
		        int bHasContour = _Map.hasPlaneProfile("Contour");
		        int bCreateRectangle = mapArgs.getInt("createRectangle");
		        CoordSys csRot;

		        if (nGoJig == _kOk)
		        {
		        	Point3d pt = ssP.value(); //retrieve the selected point
		        	pt += vecZ * vecZ.dotProduct(ptOrg - pt);

		        	if (bCreateRectangle)
		        	{ 
		        		ppContour.createRectangle(LineSeg(ptOrg, pt), vecX, vecY);
		        		_Map.setPlaneProfile("Contour", ppContour);
		        		mapArgs.setPlaneProfile("Contour", ppContour);
		        		mapArgs.removeAt("createRectangle", true);
		        	}
		        // set ptOrg	
		        	else
		        	{ 
			        	ptOrg = pt;
			        	mapArgs.setPoint3d("ptOrg", ptOrg);	
		        	}
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		        	int key = ssP.keywordIndex();
					if (key == 0) // Flip
					{
						vecZ *= -1;
						vecY *= -1;	
					}
					else if (key== 1) // X-Rotate
					{	
						csRot.setToRotation(90, vecX, ptOrg);
						_Map.removeAt("Contour", true);// cannot keep a custom contour
					}
					else if (key == 2) // Y-Rotate
					{ 
						csRot.setToRotation(90, vecY, ptOrg);
						_Map.removeAt("Contour", true); // cannot keep a custom contour
					}			
					else if (key == 3) // Z-Rotate
						csRot.setToRotation(90, vecZ, ptOrg);	
					else if (key == 4) // select defining
					{ 
					// prompt for entities
						Entity ents[0];
						PrEntity ssE(T("|Select reference genbeam or collection entity|"), GenBeam());
						ssE.addAllowedClass(CollectionEntity());
						if (ssE.go())
							ents.append(ssE.set());
						
						for (int i=0;i<ents.length();i++) 
						{ 
							GenBeam gb = (GenBeam)ents[i];
							CollectionEntity ce= (CollectionEntity)ents[i];

							int n = _Entity.find(ents[i]);
							if ((gb.bIsValid() || ce.bIsValid()) && n>-1)
							{ 
								entDefine = ents[i];
								bd = entDefine.realBody();
								mapArgs.setEntity("entDefine", entDefine);
							// Set coordSys	
								if (gb.bIsValid())
								{ 
									ptOrg= gb.ptCen();
									vecX = gb.vecX();
									vecY = gb.vecY();
									vecZ = gb.vecZ();
									
								// override default if reference is a panel with grain direction
									Sip sip =(Sip)gb;
									if (sip.bIsValid() && !sip.woodGrainDirection().bIsZeroLength())
									{ 
										vecX = sip.woodGrainDirection();
										vecY = vecX.crossProduct(-vecZ);
									}				
								}
								else if (ce.bIsValid())
								{ 
									CoordSys cs = ce.coordSys();
									ptOrg= cs.ptOrg();
									vecX = cs.vecX(); // trusses coordSys is perp to element coordSys
									vecY = -cs.vecZ();
									vecZ = cs.vecY();			
								}
								if (n > 0)_Entity.swap(0, n);
								
							}
							 
						}//next i
					}
					else if (key == 5) // bounding shadow
					{ 
						ppContour.createRectangle(ppShadow.extentInDir(vecX), vecX, vecY);
		        		mapArgs.setPlaneProfile("Contour", ppContour);
		        		bCreateRectangle = false;
		        		mapArgs.setInt("createRectangle", bCreateRectangle);
					}
					else if (key == 6) // purge contour
					{ 
						ppContour = mapArgs.getPlaneProfile("Shadow");
						double d = getDouble(T("|Enter blowup and shrink value|") + T(", |0 = none|"));
							
						if (d>0)
					    {
					    	dBlowupShrink.set(d);
					    	mapArgs.setDouble("BlowupShrink", d);	
					    	ppContour.shrink(-d);
					    	ppContour.shrink(d);
					    }	
					    else
					    { 
					    	dBlowupShrink.set(0);
					    	mapArgs.setDouble("BlowupShrink", 0);	
					    	ppContour = mapArgs.getPlaneProfile("Shadow");
					    }
						
						
					}
					else if (key == 7) // create rectangularContour
					{ 
						mapArgs.setInt("createRectangle", true);
					}
					else if (key == 8) // create polygon
					{ 
					//region Nested Jig
						Point3d ptsContour[] ={ ptOrg};
						mapArgs.setPoint3dArray("ptsContour",ptsContour);					
					
						Point3d ptLast=ptOrg;
						PrPoint ssP2(T("|Pick point|"),ptLast); // second argument will set _PtBase in map
					    int nGoJig2 = -1;
					    mapArgs.removeAt("Contour", true); // do not preview current contour
					    while (nGoJig2 != _kNone)
					    {
					        nGoJig2 = ssP2.goJig("Jig1", mapArgs); 
					    	ptsContour = mapArgs.getPoint3dArray("ptsContour");
					        if (nGoJig2 == _kOk)
					        {
					            ptLast = ssP2.value(); //retrieve the selected point
					            ptsContour.append(ptLast);
					            mapArgs.setPoint3dArray("ptsContour",ptsContour);
					            ssP2 = PrPoint(T("|Select next point|"), ptLast);
					        }
					        else if (nGoJig2 == _kCancel)
					        { 
					            return; 
					        }
					    }
					    mapArgs.removeAt("ptsContour", true); // use ppContour as jig
					//End Nested Jig//endregion 
		
					//region Get specified contour
						if (ptsContour.length()>2)
						{ 
							PLine pl(vecZ);
							for (int i=0;i<ptsContour.length();i++) 
							{ 
								Point3d pt = ptsContour[i];
								pt += vecZ * vecZ.dotProduct(ptOrg - pt);
								pl.addVertex(pt);
							}//next i
							pl.close();
							
							if (pl.area()<pow(dEps,2))
								pl.createConvexHull(Plane(ptOrg, vecZ),ptsContour);
							
							if (pl.area()>pow(dEps,2))
							{	
								ppContour = PlaneProfile(CoordSys(ptOrg, vecX, vecY, vecZ));
								ppContour.joinRing(pl, _kAdd);
								//_Map.setPlaneProfile("Contour", ppContour); // model insert
								bHasContour = true;
							}
						}							
					//End Get the specified contour//endregion 
					
						
					}					
					else if (key == 9) // add entities
					{ 
					// prompt for entities
						Entity ents[0];
						PrEntity ssE(T("|Select entities|"), GenBeam());
						ssE.addAllowedClass(CollectionEntity());
						ssE.addAllowedClass(TslInst());
						if (ssE.go())
							ents.append(ssE.set());
							
						for (int i=0;i<ents.length();i++) 
						{ 
							int n =_Entity.find(ents[i]);
							if (n<0)
							{ 
								_Entity.append(ents[i]);
								bodies.append(ents[i].realBody());
							}						 
						}//next i
					}
					else if (key == 10) // remove entities
					{ 
					// prompt for entities
						Entity ents[0];
						PrEntity ssE(T("|Select entities to be removed|"), Entity());
						if (ssE.go())
							ents.append(ssE.set());
							
						for (int i=0;i<ents.length();i++) 
						{ 
							int n =_Entity.find(ents[i]);
							if (n>-1 && _Entity.length()>2 && ents[i]!=entDefine)
							{ 
								_Entity.removeAt(n);
								bodies.removeAt(n);
							}						 
						}//next i
					}		
					else if (key == 11) // formatText
					{ 
						String s = getString(T("|Enter new format or text|") + T("(|Current value =| ")+sFormat+")");
						sFormat.set(s);
					}					
					if (key > 0 && key<4)
					{
						vecX.transformBy(csRot);
						vecY.transformBy(csRot);
						vecZ.transformBy(csRot);
					}
		
				    ptsZ = bd.extremeVertices(vecZ);
		   			ptOrg += vecZ * vecZ.dotProduct(ptsZ.last() - ptOrg);
		    
					if (key > 0 && key < 4)
					{
						
					    Plane pnZ(ptOrg, vecZ);
					    if (!bHasContour)ppContour = PlaneProfile(CoordSys(ptOrg, vecX, vecY, vecZ));
					    ptsZExtr.setLength(0);
					    for (int i=0;i<bodies.length();i++) 
					    { 
					  		Body& bd = bodies[i];
			    			ptsZExtr.append(bd.extremeVertices(vecZ));  
					    	PlaneProfile ppZ= bd.shadowProfile(pnZ);
				    		ppZ.shrink(-dEps);
				    		if (!bHasContour)
				    			ppContour.unionWith(ppZ);	    		
		 
					    }//next i
					    ptsZExtr = Line(ptOrg, vecZ).orderPoints(ptsZExtr, dEps);
					    if (!bHasContour)
					    {
					    	ppContour.shrink(dEps);
					    }
					    
					    
					    mapArgs.setPlaneProfile("Shadow", ppContour);
					    
					    
					    double dBlowShrink = mapArgs.getDouble("BlowupShrink");
					    if (dBlowShrink>0)
					    {
					    	ppContour.shrink(-dBlowShrink);
					    	ppContour.shrink(dBlowShrink);
					    }
					    
					// make sure the profile consists only one ring
						{ 
							PLine rings[] = ppContour.allRings(true, false);
							PlaneProfile pp = ppContour;
							int nCnt;
							while(rings.length()>1 && nCnt<50)
							{
								pp.shrink(-dMerge*(nCnt+1));
								pp.shrink(dMerge*(nCnt+1));
								rings = pp.allRings(true,false);
								nCnt++;
							}
						    ppContour = pp;					
						}
					    
					    
					    
					    ptOrg = ppContour.ptMid() - .5 * (vecX * ppContour.dX() + vecY * ppContour.dY());						
						
						
					}
		    


					mapArgs.setVector3d("vecX", vecX); // add all the info you need for Jigging
				    mapArgs.setVector3d("vecY", vecY);
				    mapArgs.setVector3d("vecZ", vecZ);
				    mapArgs.setPoint3d("ptOrg", ptOrg);
					mapArgs.setPlaneProfile("Contour", ppContour);
					mapArgs.setDouble("dZ", bd.lengthInDirection(vecZ));
					if (ptsZExtr.length()>0)
					{ 
						mapArgs.setDouble("dZNeg", vecZ.dotProduct(ptsZExtr.first()-ptOrg));
						mapArgs.setDouble("dZPos", vecZ.dotProduct(ptsZExtr.last()-ptOrg));				
					}			
					ssP=PrPoint (prompt);

		        }
		        else if (nGoJig == _kCancel)
		        { 
		        	eraseInstance(); // do not insert
		            return; 
		        }
		    }
		//End Show Jig//endregion 
			
			if (ppContour.area()<pow(dEps,2))
			{ 
				reportNotice("\n"+ scriptName() + T(" |Could not detect valid contour|"));
				eraseInstance();
				return;
			}
			_Map.setPlaneProfile("Contour", ppContour);
	
		}
	//End Zone 0 definition found//endregion 	
		
	//region Zone 0 not found
		else if (ents.length()>0)
		{
			Point3d ptLast = getPoint(T("|Select datum|"));
			ptOrg = ptLast;

		//region Show Jig
		// get overall contour
		    Plane pnZ(ptOrg, vecZ);
		    PlaneProfile ppContour(CoordSys(ptOrg, vecX, vecY, vecZ));
		    for (int i=0;i<bodies.length();i++) 
		    { 
		    	PlaneProfile ppZ= bodies[i].shadowProfile(pnZ);
	    		ppZ.shrink(-dEps);
	    		ppContour.unionWith(ppZ);	    		 
		    }//next i
		    ppContour.shrink(-dEps);

			PrPoint ssP(T("|Select datum or point on [XAxis/YAxis/ZAxis]|"), ptOrg); // second argument will set _PtBase in map
		    Map mapArgs;
		    mapArgs.setVector3d("vecX", vecX); // add all the info you need for Jigging
		    mapArgs.setVector3d("vecY", vecY);
		    mapArgs.setVector3d("vecZ", vecZ);
		    mapArgs.setPoint3d("ptOrg", ptOrg);    
			mapArgs.setPlaneProfile("Contour", ppContour);	
			mapArgs.setInt("FreeDir", 0);
		
		    int nGoJig = -1;
		    while (nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig("Jig1", mapArgs); 
		        if (nGoJig == _kOk)
		        {
		            Point3d pt = ssP.value(); //retrieve the selected point
		            
		            Vector3d vecDir = pt - ptOrg;
		            vecDir.normalize();
		            
		            int nFreeDir = mapArgs.getInt("FreeDir");
		            if (nFreeDir == 0)
			            ptOrg = pt;
		            else if (nFreeDir == 1)
		            { 
			    		if (vecDir.isParallelTo(vecZ))vecZ = -vecX;
			    		vecX = vecDir;
			    		vecY = vecX.crossProduct(-vecZ);
			    		vecZ = vecX.crossProduct(vecY);
			    		mapArgs.setInt("FreeDir", 0);
		            }
		            else if (nFreeDir == 2)
		            { 
			    		if (vecDir.isParallelTo(vecZ))vecZ = -vecY;
			    		vecY = vecDir;
			    		vecX = vecY.crossProduct(vecZ);
			    		vecZ = vecX.crossProduct(vecY);
			    		mapArgs.setInt("FreeDir", 0);
		            }
		            else if (nFreeDir == 3)
		            { 
			    		if (vecDir.isParallelTo(vecX))vecX = vecZ;
			    		vecZ = vecDir;
			    		vecY = vecX.crossProduct(-vecZ);
			    		vecX = vecY.crossProduct(vecZ);
			    		mapArgs.setInt("FreeDir", 0);
		            }	
				    mapArgs.setVector3d("vecX", vecX); // add all the info you need for Jigging
				    mapArgs.setVector3d("vecY", vecY);
				    mapArgs.setVector3d("vecZ", vecZ);	
				    
				    
				// get overall contour
				    Plane pnZ(ptOrg, vecZ);
				    PlaneProfile ppContour(CoordSys(ptOrg, vecX, vecY, vecZ));
				    for (int i=0;i<bodies.length();i++) 
				    { 
				    	PlaneProfile ppZ= bodies[i].shadowProfile(pnZ);
			    		ppZ.shrink(-dEps);
			    		ppContour.unionWith(ppZ);	    		 
				    }//next i
				    ppContour.shrink(-dEps);    
				    mapArgs.setPlaneProfile("Contour", ppContour);
  
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		        	int key = ssP.keywordIndex();

				    mapArgs.setInt("FreeDir", key+1);

		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
		//End Show Jig//endregion 
	
		}	
	//End Zone 0 not found//endregion 	

		_Pt0 = ptOrg;
	    _Map.setVector3d("vecX", vecX);
	    _Map.setVector3d("vecY", vecY);
	    _Map.setVector3d("vecZ", vecZ);	

		return;
	}	
// end on insert	__________________//endregion

//region Standards
	CoordSys cs;
	PlaneProfile ppContour;
	int bHasContour;
	if (_Map.hasPlaneProfile("Contour"))
	{ 
		ppContour = _Map.getPlaneProfile("Contour");
		bHasContour = true;
		cs = ppContour.coordSys();
		_Pt0 = cs.ptOrg();
	}
	else
	{ 
		cs = CoordSys(_Pt0,_Map.getVector3d("vecX"),_Map.getVector3d("vecY"),_Map.getVector3d("vecZ"));
		ppContour=PlaneProfile(cs);
	}
	cs.vis(4);
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();

	

	int bExclusive = sNoYes.find(sAddExclusive,1);
	int bTurnOff = sNoYes.find(sTurnOff,1);
//End Standards//endregion 

//region Collect entities
	Entity entDefine = _Map.getEntity("entDefine");

	Body bodies[0];
	int nZoneIndices[0];

	GenBeam gbRef;
	CollectionEntity ceRef;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent = _Entity[i];
		Body bd = ent.realBody();
		if (!entDefine.bIsValid() && bd.volume()>pow(dEps,3))
		{ 
			GenBeam gb = (GenBeam)ent;
			CollectionEntity ce= (CollectionEntity)ent;
			if(gb.bIsValid())
				entDefine = ent;
			else if(ce.bIsValid())
				entDefine = ent;	
		}
		
		bodies.append(bd);
		nZoneIndices.append(999);// indicate that is not mapped to a zone yet
	}
	
	if (entDefine.bIsValid())
	{ 
		GenBeam gb = (GenBeam)entDefine;
		CollectionEntity ce= (CollectionEntity)entDefine;
		if(gb.bIsValid())
			gbRef = gb;
		else if(ce.bIsValid())
			ceRef = ce;	
	}
//End Collect entities//endregion 

//region Build and collect zones
	Entity entZones[0];
	
//region Zone 0
	double dZ = dThickness;
	if (entDefine.bIsValid())
	{ 
		Body bd = entDefine.realBody();
		Point3d ptsZ[] = bd.extremeVertices(vecZ);
		
		if (ptsZ.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + T("|Defining entity does not have valid thickness| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		
		dZ = dThickness<=0?abs(vecZ.dotProduct(ptsZ.first() - ptsZ.last())):dThickness;	
	    ptOrg += vecZ * vecZ.dotProduct(ptsZ.last() - ptOrg);
	 
	// get overall contour
	    Plane pnZ(ptOrg, vecZ);
	    
	    for (int i=0;i<bodies.length();i++) 
	    { 
	    	Point3d pts[]= bodies[i].extremeVertices(vecZ);
	    	if (pts.length() < 1)continue;
	
		    PlaneProfile ppZ= bodies[i].shadowProfile(pnZ);
    		ppZ.shrink(-dEps);
    		if (!bHasContour)ppContour.unionWith(ppZ);
	
	    	double d1 = vecZ.dotProduct(pts.first()-ptsZ.first());
	    	double d2 = vecZ.dotProduct(pts.last()-ptsZ.last());


	    	if (d1>-dEps && d2<dEps)
	    	{    		
	    		nZoneIndices[i] = 0;
	    	}	
	    	else
	    	{ 
	    		entZones.append(_Entity[i]);
	    	}

//			Display dp(2);
//	 		Point3d pt = bodies[i].ptCen();
//	 		dp.draw(_Entity[i].typeDxfName().left(8) + " Z" + nZoneIndices[i] , pt, _XW, _YW, 0, 0, _kDeviceX);


	    }//next i
	    if (!bHasContour)ppContour.shrink(dEps);
		double dBlowShrink = _Map.getDouble("BlowupShrink");
		if (dBlowShrink>0)
		{
			ppContour.shrink(-dBlowShrink);
			ppContour.shrink(dBlowShrink);
		}
	    
	    
	    //ppContour.vis(2);
	}		
//End Zone 0//endregion 

//region Loop both element faces
	int nZones[0];
	double dThicknesses[0];


	for (int f=0;f<2;f++) 
	{ 
		Vector3d vecFace = vecZ;
		int nSide = 1;
		Point3d ptOrgZ = ptOrg;
		if (f==1)
		{ 
			nSide *= -1;
			vecFace*=nSide;	
			ptOrgZ = ptOrg+vecFace*dZ;
		}
		vecFace.vis(ptOrgZ, f);
		
	// collect all solids touching this face
		int cnt = 1;	
		while(cnt<6 && entZones.length()>0)
		{ 
			int nZone = cnt*nSide;
			double dH;
			for (int i=entZones.length()-1; i>=0 ; i--) 
			{ 
				int n=_Entity.find(entZones[i]);
				if (n < 0)continue;
				
				Body bd = bodies[n];
				Point3d pts[] = bd.extremeVertices(vecFace);
				if (pts.length()>0 && abs(vecFace.dotProduct(pts.first()-ptOrgZ))<dEps)
				{ 
					double d = bd.lengthInDirection(vecFace);
					if (dH < d)dH = d;
					nZoneIndices[n] = nZone; 
					bd.ptCen().vis(nZoneIndices[n]+6);
					entZones.removeAt(i);
					continue;
				}		 
			}//next i
			
		// post collect any entity which is within zone Z-boundaries but not touching the base face of the zone
			for (int i=entZones.length()-1; i>=0 ; i--) 
			{ 
				int n=_Entity.find(entZones[i]);
				if (n < 0)continue;
				
				Body bd = bodies[n];
				Point3d pts[] = bd.extremeVertices(vecFace);
				if (pts.length()>0 && vecFace.dotProduct(pts.first()-ptOrgZ)>=-dEps && vecFace.dotProduct(pts.last()-ptOrgZ)<=dH)
				{ 
					nZoneIndices[n] = nZone; 
					bd.ptCen().vis(2);
					entZones.removeAt(i);
					continue;
				}		 
			}//next i			
			
			if (dH>0 && nZones.find(nZone)<0)
			{ 
				nZones.append(nZone);
				dThicknesses.append(dH);
			}
			ptOrgZ += vecFace * dH;
			cnt++;// next zone
		}	
	}//next f	
//End Loop bothe sides//endregion 

//End Build and collect zones//endregion 

//region Get Contour
	ERoofPlane erp;
	PLine plContour;
	if (erp.bIsValid())
		plContour = erp.plEnvelope();
	else
	{ 
	// make sure the profile consists only one ring
		PlaneProfile pp = ppContour;
		PLine plRings[] = pp.allRings(true,false);
		int nCnt;
		while(plRings.length()>1 && nCnt<50)
		{
			pp.shrink(-dMerge*(nCnt+1));
			pp.shrink(dMerge*(nCnt+1));
			plRings = pp.allRings(true,false);
			nCnt++;
		}
		
	// fall back to biggest ring
		for (int r=0;r<plRings.length();r++)
			if (plContour.area()<plRings[r].area())
				plContour = plRings[r];	
	
	}	
	plContour.vis(6);
	
//End Getr Contour//endregion 

//region Numbering


// get potential element name from source object and purge unresolved variables
	String sNumberSource = entDefine.formatObject(sFormat);
	{ 
		int x1 = sNumberSource.find("@(", 0);
		int x2 = sNumberSource.find(")", x1);
		while(x1>-1 && x2>-1)
		{ 
			String left = sNumberSource.left(x1);
			String right= sNumberSource.right(sNumberSource.length()-x2-1);
			sNumberSource = left + right;
			x1 = sNumberSource.find("@(", 0);	
			x2 = sNumberSource.find(")", x1);
		}	
	}
	
// Identify if source contains a number at the end	
	int number;
	if (sNumberSource.length()>1)
	{ 
		int n1 = sNumberSource.right(1).atoi();
		int n2 = sNumberSource.right(2).atoi();
		int n3 = sNumberSource.right(3).atoi();
		int n4 = sNumberSource.right(4).atoi();
		if (n4 != 0)number=n4;
		else if (n3 != 0)number=n3;
		else if (n2 != 0)number=n2;
		else if (n1 != 0)number=n1;
	}	
	
// Compose element number	
	if (number>0 && sNumbers.findNoCase(sNumberSource,-1)<0)
		sComposedNumber = sNumberSource;
	else
	{
		ElemNumber elemNum(Element().number());
		elemNum.setSequenceType(_kSTDigits);
		elemNum.setNumber(1);
		elemNum.setPrefix(sNumberSource);
		elemNum.setAmountOfDigits(3);
		sComposedNumber =elemNum.composed();
	}
//End Numbering//endregion 


//if (sScriptList.length() > 0)
//{
//	String tokens[] = sScriptList.tokenize(";");
//	String sNames[0];
//	String sEntries[0];
//	
//	for (int i = 0; i < tokens.length(); i++)
//	{
//		String s = tokens[i].trimLeft().trimRight();
//		if (s.length() < 1)continue;
//		
//		String nameEntries[] = s.tokenize("?");
//		if (nameEntries.length() < 1)continue;
//		
//		sNames.append(nameEntries[0]);
//		if (nameEntries.length() > 1)
//			sEntries.append(nameEntries[1]);
//		else
//			sEntries.append(sDefault);
//	}//next i
//	return;
//}




//region Create ELement
	if (!bDebug)
	{ 
		String sElementGroupName = house + "\\" + floor+"\\"+sComposedNumber;		
		Group grElement(sElementGroupName);		
		if(!grElement.bExists())
			grElement.dbCreate();		

		ElementRoof elR;
		elR.dbCreate(grElement, plContour);
		
		if (elR.bIsValid())
		{ 
			elR.setVecZ(vecZ);
			elR.setVecY(vecY);
			elR.setDReferenceHeight(-dZ);
			elR.setDBeamWidth(dZ);
			elR.assignToElementGroup(elR, true, 0, 'C');
			
		// set zones	
			for (int i=0;i<nZones.length();i++) 
			{ 
				ElemZone ez;
				ez.setDH(dThicknesses[i]);
				elR.setZone(nZones[i],ez); 
			}//next i
		
			for (int i=0;i<_Entity.length();i++) 
			{ 
				Entity ent = _Entity[i]; 
				GenBeam gb = (GenBeam)ent;
				int zone = nZoneIndices[i];
				if (ent == elR || zone > 5 || zone<-5)continue;		
				ent.assignToElementGroup(elR, bExclusive, zone,'Z');
				if (ent.bIsKindOf(TslInst()))ent.transformBy(Vector3d(0, 0, 0));
				if (gb.bIsValid())gb.setPanhand(elR);	 
			}//next i	

		//region Plugin TSLs
			if (sScriptList.length()>0)
			{ 
				String tokens[] = sScriptList.tokenize(";");
				String sNames[0];
				String sEntries[0];
				
				for (int i=0;i<tokens.length();i++) 
				{ 
					String s = tokens[i].trimLeft().trimRight();
					if (s.length() < 1)continue;
					
					String nameEntries[] = s.tokenize("?");
					if (nameEntries.length() < 1)continue;
					
					sNames.append(nameEntries[0]);
					if (nameEntries.length()>1)
						sEntries.append(nameEntries[1]);
					else
						sEntries.append(sDefault); 
				}//next i
		
			// create TSL
				TslInst tslNew;				Map mapTsl;
				int bForceModelSpace = true;	
				String sExecuteKey;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[]=elR.genBeam();		Entity entsTsl[] = {elR};			Point3d ptsTsl[] = {elR.ptOrg()};
			
				for (int i=0;i<sNames.length();i++) 
				{
					tslNew.dbCreate(sNames[i] , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sEntries[i], bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
					if (tslNew.bIsValid())
						tslNew.transformBy(Vector3d(0, 0, 0));
				}

		
			}
		//endregion 

			if (bTurnOff)
				elR.elementGroup().turnGroupVisibilityOff(true);
			



		}		
	}		
	else
	{ 
		Display dp(2);
		dp.textHeight(U(20));
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity ent = _Entity[i]; 
			int zone = nZoneIndices[i];
	 
	 		Point3d pt = bodies[i].ptCen();
	 		dp.draw(ent.typeDxfName().left(8) + " Z" + zone, pt, _XW, _YW, 0, 0, _kDeviceX);
		}//next i	
	}
	

		


	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}


//endregion 


























#End
#BeginThumbnail
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
<V:-3_"*WJ*`,.+PU"LRR37,LK*<C-;E%%`'_V99"
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
        <int nm="BreakPoint" vl="1403" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17018 wording improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/10/2023 10:59:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16199 Major update, new properties allow faster and more specific creation of elements" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/5/2022 4:22:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14836: no translation for options" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/15/2022 1:44:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13188: fix the options at the prompt" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/15/2021 5:35:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11500 - Zone 0 assignment corrected" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/9/2021 12:15:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11489 new command line options DrawContour and createRectangle added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/8/2021 4:45:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11464 various options added to allow shape modifications during insert. Zone assignment enhanced, new preview during insert." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/8/2021 4:37:21 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End