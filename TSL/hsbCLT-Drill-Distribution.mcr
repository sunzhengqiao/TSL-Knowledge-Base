#Version 8
#BeginDescription
#Versions
Version 1.1 01.03.2022 HSB-14825 dimension requests prepared
Version 1.0 16.02.2022 HSB-14729 initial version

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Drill;Distribution;Beam;Sheet;Panel;CLT
#BeginContents
//region <History>
// #Versions
// 1.1 01.03.2022 HSB-14825 dimension requests prepared , Author Thorsten Huck
// 1.0 16.02.2022 HSB-14729 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select panels, then select genbeams or polylines. If second selection reains empty one can draw a grip point based definition
/// </insert>

// <summary Lang=en>
// This tsl creates a drill distribution based on intersecion to other genbeams, polylines or grip points
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Drill-Distribution")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit In Place|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Panels|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add secondary objects|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove genbeams|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Convert To Polyline|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Convert To Grip Points|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Convert To Polyline|") (_TM "|Select Tool|"))) TSLCONTENT

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
	
	String kReferenceFace = T("|Reference Face|");
	String kTopFace =  T("|Top Face|");
	String kFormat="Format", kView = "View", kStereotype="Stereotype", kShopdrawing="Shopdrawing", kDisabled=T("<|Disabled|>");
	String kTextCumm = "TextCumm", kTextDelta = "TextDelta", kNode="Node", kNodes="Node[]";	
	String kRevertDirection="revertDirection";
	int nTick = getTickCount();
	
	String sDistributionFormat = "@(Quantity-2)x @("+T("|Diameter|")+")";
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
			
//			String sViewName=T("|View|");	
//			PropString sView(nStringIndex++, sViews, sViewName);	
//			sView.setDescription(T("|Defines the View|"));
//			sView.setCategory(category);
//			int nView = sViews.find(sView);
//			if (nView<0) sView.set(0);


		}		
		return;		
	}
//End DialogMode//endregion


//region Properties
category = T("|Drill|");
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(12), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category);

	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the depth|") + T("|0 = complete through|"));
	dDepth.setCategory(category);

category = T("|Sinkhole|");
	String sDiameterSinkName=T("|Diameter| ");	
	PropDouble dDiameterSink(nDoubleIndex++, U(63), sDiameterSinkName);	
	dDiameterSink.setDescription(T("|Defines the diameter of the sinkhole|"));
	dDiameterSink.setCategory(category);

	String sDepthSinkName=T("|Depth|");	
	PropDouble dDepthSink(nDoubleIndex++, U(0), sDepthSinkName);	
	dDepthSink.setDescription(T("|Defines the depth of the sinkhole|"));
	dDepthSink.setCategory(category);	

category = T("|Distribution|");
	String sDistributionModeName=T("|Mode|");	
	String sDistributionModes[] ={ T("|Fixed|"), T("|Even|")};
	PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);	
	sDistributionMode.setDescription(T("|Defines the DistributionMode|"));
	sDistributionMode.setCategory(category);

	String sInterdistance=T("|Interdistance|") ;	
	PropDouble dInterdistance (nDoubleIndex++, U(1000), sInterdistance);
	dInterdistance.setCategory(category);
	dInterdistance.setDescription(T("|Defines the interdistance or the quantity of connectors|"));


	String sNumRowName=T("|Rows|");	
	PropInt nNumRow(nIntIndex++, 1, sNumRowName);	
	nNumRow.setDescription(T("|Defines the number of rows|"));
	nNumRow.setCategory(category);

	String sRowOffsetListName=T("|Row Offsets|");	
	PropString sRowOffsetList(nStringIndex++, "", sRowOffsetListName);	
	sRowOffsetList.setDescription(T("|Specify offset, separate multiple by a semicolon, i.e. '200;150;200'|"));
	sRowOffsetList.setCategory(category);

	String sColumnOffsetListName=T("|Column Offsets|");	
	PropString sColumnOffsetList(nStringIndex++, "", sColumnOffsetListName);	
	sColumnOffsetList.setDescription(T("|Specify offset, separate multiple by a semicolon, i.e. '200;150;200'|"));
	sColumnOffsetList.setCategory(category);

	
category = T("|Alignment|");
	String sFaceName=T("|Face|");
	String sFaces[] ={ kReferenceFace, kTopFace };
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);

	String sBevelName=T("|Bevel|");	
	PropDouble dBevel(nDoubleIndex++, U(0), sBevelName);	
	dBevel.setDescription(T("|Defines the angle of the drill axis in relation to the selected face.|") +"-90° <"+ sBevelName+" < 90°");
	dBevel.setCategory(category);
	
	String sRotationName=T("|Rotation|");	
	PropDouble dRotation(nDoubleIndex++, U(0), sRotationName);	
	dRotation.setDescription(T("|Defines the rotation of the drill axis perpendicular to the segment on the selected face.| ")+"-90° <"+ sRotationName+" < 90°");
	dRotation.setCategory(category);	
	
	
//End Properties//endregion 

//region References
	Sip sips[0],sipRef;
	GenBeam gbFemales[0];
	Point3d ptFace;
	Plane pnFace;
	Vector3d vecX, vecY,vecZ;
	PLine plines[0];
	EntPLine epls[0];

	String sStereotype = "Bohrung9_50";//"hsbCLT-Drill-Distribution";

//endregion 

//region bOnJig
	int bJig;
	if (_bOnJig && _kExecuteKey== "JigAction") 
	{
		bJig = true;
		
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point

	    ptFace = _Map.getPoint3d("ptFace");
	    vecX = _Map.getVector3d("vecX");
	    vecY = _Map.getVector3d("vecY");
	    vecZ = _Map.getVector3d("vecZ");
	    Point3d pts[] = _Map.getPoint3dArray("pts");
	    
	    setPropValuesFromMap(_Map.getMap("PropertyMap"));
	    
	    PlaneProfile ppRange=_Map.getPlaneProfile("range");

	    Display dp(0),dpText(0), dpRange(0);
	    dp.trueColor(darkyellow);
	    
	    pnFace=Plane(ptFace, vecZ);
	    Line(ptJig, vecZView).hasIntersection(pnFace, ptJig);
	    pts.append(ptJig);
	    pts = pnFace.projectPoints(pts);
    
	    PLine pl(vecZ);
	    for (int i=0;i<pts.length();i++) 
	    { 
	    	pl.addVertex(pts[i]); 
	    	 
	    }//next i
////	    if (pts.length()>1)
////	    	pl.close();
//	
//		dpRange.draw(ppRange, _kDrawFilled);
	    
	    dp.draw(pl);
	    plines.append(pl);

	    
	    if (0)
	    { 
	    	Display dpc(2);
	    	PLine pl;
	    	pl.createCircle(ptFace, vecZ, U(80));
	    	dpc.draw(pl);
	    	pl.createCircle(ptJig, vecZ, U(80));
	    	dpc.draw(pl);
	    	dpc.draw(PLine(ptJig, ptFace));
	    	
	    }

	// do not attempt to draw invalid plines
	    if (pl.length()<dEps)return;
	}	
	else if (_bOnGripPointDrag && (_kExecuteKey.find("_PtG",0,false)>-1))
		bJig = true;
//End bOnJig//endregion 

//region bOnInsert
	int nFace = sFaces.find(sFace)==1?1:-1;
	int nDistributionMode = sDistributionModes.find(sDistributionMode);
	if (nDistributionMode<-1){ sDistributionMode.set(sDistributionModes[0]); setExecutionLoops(2); return;}	
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
		nDistributionMode = sDistributionModes.find(sDistributionMode);
	
	// prompt for main panels
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
				
	// collect sips		
		double dH;
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
					dH = sipRef.dH();

					ptFace = sipRef.ptCen() + .5 * nFace*vecZ * dH;
					sips.append(sip);
				}
				sips.append(sip);
			}	 
		}//next i
		if (sips.length()<1)
		{ 
				reportMessage("\n"+ scriptName() + T("|This tool requires at least one panel| ")+T("|Tool will be deleted.|"));
				eraseInstance();
				return;
		}	
		pnFace = Plane(ptFace, vecZ);

		
	// prompt for secondary panels or plines
		Entity ents2[0];
		PrEntity ssE2(T("|Select intersecting genbeams or polylines|"), GenBeam());
		ssE2.addAllowedClass(EntPLine());
		ssE2.addAllowedClass(BlockRef());
		
		if (ssE2.go())
			ents2.append(ssE2.set());		

		for (int i=0;i<ents2.length();i++) 
		{ 
			//BlockRef bref = (BlockRef)ents2[i];
			EntPLine epl= (EntPLine)ents2[i]; 
			GenBeam gb= (GenBeam)ents2[i]; 
			if (gb.bIsValid() && sips.find(gb)<0) // do not accept primary panels
			{
				gbFemales.append(gb);
			}
//			else if (bref.bIsValid())
//			{ 
//				reportMessage("\nb" +bref.definition());
////				Block block(bref.definition());
////				Entity entsB[] = block.entity();
////				for (int e=0;e<entsB.length();e++) 
////				{ 
////					CoordSys csNew = bref.coordSysScaled();
////					
//// 
////				}//next e
//				_Entity.append(bref);
//			}
			else if (epl.bIsValid())
			{ 
				PLine pl = epl.getPLine();
				if (!pl.coordSys().vecZ().isParallelTo(vecZ)) { continue;}	
				epls.append(epl);
				_Entity.append(epl);
			}
		}//next i
		
	// append female / defining plines	
		if (gbFemales.length() > 0)
		{
			_Map.setEntityArray(gbFemales, true, "Female[]", "", "Female");
		}
	// Pick path if nothing selected	
		if (epls.length()<1 && gbFemales.length()<1)
		{ 
		//region Show Jig
			String prompt = T("|Pick point|");
			PrPoint ssP(prompt); // second argument will set _PtBase in map
		    Map mapArgs;
		    mapArgs.setVector3d("vecX", vecX);
		    mapArgs.setVector3d("vecY", vecY);
		    mapArgs.setVector3d("vecZ", vecZ);
		    mapArgs.setPoint3d("ptFace", ptFace);

			mapArgs.setMap("PropertyMap", mapWithPropValues());
	    	
	    	//mapArgs.setPlaneProfile("range", ppRange);
	    	
	    
		    Point3d pts[0];
		    int nGoJig = -1;
		    while (nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig("JigAction", mapArgs); 
		        nFace = sFace == kReferenceFace ? -1:1;
		        ptFace = sipRef.ptCen() + .5 * nFace*vecZ * sipRef.dH();
		        pnFace = Plane(ptFace, vecZ);
		        if (nGoJig == _kOk)
		        {
		            Point3d pt = ssP.value(); //retrieve the selected point
		            
		        // check if selected point is within range of panel thickness
		        	double d = vecZ.dotProduct(pt - ptFace);
		        	if (abs(d)<=dH)
		        		Line(pt, vecZ).hasIntersection(pnFace, pt);
		        	else
		            	Line(pt, vecZView).hasIntersection(pnFace, pt); 
		            pts.append(pt);
		            mapArgs.setPoint3dArray("pts", pts);
		            prompt = T("|Pick point [Fixed/Even/flipSide]|");
		            
		            Line(pts.last(), vecZ).hasIntersection(pnFace, pt); 
		            ssP=PrPoint (prompt, pt);
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		            if (ssP.keywordIndex() == 0)
		                nDistributionMode = 0;
		            else if (ssP.keywordIndex() == 1)
		                nDistributionMode = 1;
		            else if (ssP.keywordIndex() == 2)
		            { 
		            	sFace.set(sFace == kReferenceFace ? kTopFace:kReferenceFace );
		            	nFace *=-1;
		            	ptFace = sipRef.ptCen() + .5 * nFace*vecZ * sipRef.dH();
		            	pnFace = Plane(ptFace, vecZ);
		            	
		            	for (int i=0;i<pts.length();i++) 
		            		Line(pts[i], vecZ).hasIntersection(pnFace, pts[i]); 
		            	mapArgs.setPoint3dArray("pts", pts);
		            	
		            	mapArgs.setPoint3d("ptFace", ptFace);
		            }		                
		            sDistributionMode.set(sDistributionModes[nDistributionMode]);
		            mapArgs.setMap("PropertyMap", mapWithPropValues());
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }
	    	_PtG.append(pts);	    
		//End Show Jig//endregion 
			
			if(_PtG.length()<2)
			{
				reportMessage("\n"+ scriptName() + T("|requires at two grip points|, ")+T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}
		}	
	}	
// end on insert	__________________//endregion

//region References
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
		
	// get potential secondary genbeams
		Entity entFemales[] =_Map.getEntityArray("Female[]", "", "Female"); 
		for (int i=0;i<entFemales.length();i++) 
		{ 
			GenBeam gb= (GenBeam)entFemales[i]; 
			if (gb.bIsValid() && sips.find(gb)<0)
			{ 
				_Entity.append(gb);
				setDependencyOnEntity(gb);
				gbFemales.append(gb);
			}
		}//next i
		
	// set defining from grips
		if (_PtG.length()>0)
		{ 
			PLine pl(vecZ);
			for (int i=0;i<_PtG.length();i++) 
			{ 
				addRecalcTrigger(_kGripPointDrag, "_PtG"+i);
				pl.addVertex(_PtG[i]); 		 
			}//next i		
			plines.append(pl);
		}
	// get defining plines from entity
		else
		{ 
			for (int i=0;i<_Entity.length();i++) 
			{ 
				BlockRef bref= (BlockRef)_Entity[i];
				EntPLine epl= (EntPLine)_Entity[i]; 
				if (epl.bIsValid())
				{ 
					PLine pl = epl.getPLine();
					if (pl.length()>dEps)
					{ 
						epls.append(epl);
						epl.assignToGroups(sipRef, 'T');
						plines.append(pl);
						setDependencyOnEntity(_Entity[i]);
					}
				}
			}//next i			
		}
	}		

// remove panels not coplanar with ref
	for (int i=sips.length()-1; i>0 ; i--) 
	{ 
		Vector3d vecZi = sips[i].vecZ();
		Point3d ptFacei = sips[i].ptCen() + .5 * nFace*vecZ * sips[i].dH();
		
		if (!vecZ.isParallelTo(vecZi) || vecZ.dotProduct(ptFace-ptFacei)>dEps)
			sips.removeAt(i);
	}//next i

	if (sips.length()<1 && !bJig)
	{ 
		reportMessage("\n"+ scriptName() + T("|requires at least one panel|, ")+T("|Tool will be deleted.|"));			
		eraseInstance();
		return;
	}
	
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
	int bIsThrough = abs(dDepth)<dEps;
	int bHasSink = dDepthSink > dEps && dDiameterSink > dDiameter;
	int bRevertDirection = _Map.getInt(kRevertDirection);
	double radius = dDiameter * .5;
	double radiusSink = dDiameterSink * .5;
	
	if (!bJig)
	{
		_ThisInst.setAllowGripAtPt0(false);
		setCloneDuringBeamSplit(_kAuto);
//		setEraseAndCopyWithBeams(_kBeam0);
		Element el = sipRef.element();
		if (el.bIsValid())
			assignToElementGroup(el, true, 0, 'T');
		else
			assignToGroups(sipRef, 'T');
	}
	
		
	Display dpModel(0);
	dpModel.trueColor(lightblue,bJig?50:70);
	
	
//endregion 

//region Get individual and common profile
	CoordSys csFace(ptFace, vecX, vecY, vecZ);
	Vector3d vecFace = nFace * vecZ;
//	CoordSys cs = csFace;
//	if (abs(dRotation) > dEps)
//	{
//		CoordSys csr;
//		csr.setToRotation(dRotation, vecZ, ptFace);
//		cs.transformBy(csr);
//	}
	pnFace=Plane (ptFace, vecZ*nFace);
	Plane pnOpp(ptFace - vecFace * sipRef.dH(), - vecFace);
	
	PlaneProfile pps[0], ppRange(csFace);	
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
		ppRange.unionWith(pp); 
	}//next i
	ppRange.shrink(dEps);	
	ppRange.vis(3);			
//endregion

//region Get Common range with potential secondary panels and collect intersecting segments
	if (_PtG.length()<1 && epls.length()<1)
	{ 
		for (int i=0;i<gbFemales.length();i++) 
		{ 
			GenBeam gb = gbFemales[i];
			Sip sip = (Sip)gbFemales[i];
			Sheet sheet= (Sheet)gbFemales[i];
			Beam beam = (Beam)gbFemales[i];
			
			Vector3d vecX2 = gb.vecX();
			Vector3d vecY2 = gb.vecY();
			Vector3d vecZ2 = gb.vecZ();
			Point3d ptCen2 = gb.ptCenSolid();
			
		// auto adjust face	
			sFace.setReadOnly(true);
			if (i==0 && vecFace.dotProduct(ptFace-ptCen2)<0)
			{ 
				sFace.set(sFace == kReferenceFace ? kTopFace:kReferenceFace );
				setExecutionLoops(2);
			}
	
			Vector3d vecXC = vecX2;
			
			if (vecZ2.isPerpendicularTo(vecZ))
			{
				if(vecX2.isParallelTo(vecZ))
					vecXC = -vecY2;
				else if(!vecX2.isParallelTo(vecZ) && !vecY2.isParallelTo(vecZ)) // beveled
				{
					vecXC = vecXC.crossProduct(vecZ).crossProduct(-vecZ);
					vecXC.normalize();
				}				
			}
		// coplanar or beveled	
			else
			{ 
				vecXC = vecXC.crossProduct(vecZ).crossProduct(-vecZ);
				vecXC.normalize();
			}
			Vector3d vecYC = vecXC.crossProduct(-vecZ);
	
			CoordSys csSec(ptFace, vecXC, vecYC, vecZ);
			PlaneProfile pp(csSec);
			pp.unionWith(gbFemales[i].envelopeBody(false, true).shadowProfile(pnFace));		
	
	
		// add openings of panel or sheet
			if ((sip.bIsValid() || sheet.bIsValid())&& !vecZ2.isPerpendicularTo(vecZ))
			{ 
				PLine plOpenings[] = sip.bIsValid()?sip.plOpenings():sheet.plOpenings();
				for (int j=0;j<plOpenings.length();j++) 
					pp.joinRing(plOpenings[j],_kSubtract); 			
			}
	
	
			vecXC.vis(pp.ptMid(), 1);
			vecYC.vis(pp.ptMid(), 3);	
			
		// get common and collect split segements
			PlaneProfile pp2 = pp;
			pp2.intersectWith(ppRange);
			Vector3d vecDir =( pp2.dX() > pp2.dY() ? vecXC : vecYC)*  U(10e4);
			LineSeg seg(pp2.ptMid() - vecDir, pp2.ptMid() + vecDir);	//seg.vis(221);
			LineSeg segs[] = pp2.splitSegments(seg, true);
		
			for (int j=0;j<segs.length();j++) 
			{ 
				if (segs[j].length() < dEps)continue;
				PLine pl(vecZ);
				pl.addVertex(segs[j].ptStart());
				pl.addVertex(segs[j].ptEnd());
				plines.append(pl); 
			}//next j
		}//next i
				
	}

//endregion 

//region Edit i place
	String sTriggerEditInPlace = T("|Edit In Place|");
	int bEditInPlace = _bOnRecalc && _kExecuteKey == sTriggerEditInPlace;

	TslInst tslDrill;
	GenBeam gbsTslDrill[] = {};		Entity entsTslDrill[] = {};			Point3d ptsTslDrill[1];
	int nPropsDrill[]={};			
	double dPropsDrill[]={dDiameter, dDepth, dBevel, dRotation, 0, dDiameterSink, dDepthSink,0,0,0};			
	String sPropsDrill[]={sFace, sNoYes[0],"@(Radius)"};
	Map mapTslDrill;	
	
	for (int i=0;i<sips.length();i++) 
	{ 
		gbsTslDrill.append(sips[i]); 
		 
	}//next i
	
				
//endregion 

//region DimRequest
	Map mapRequests;		
//endregion 

//region Distribution




	double dRowOffsets[0];
	String sRowOffsets[] = sRowOffsetList.tokenize(";");
	for (int i=0;i<sRowOffsets.length();i++) 
	{ 
		double d= sRowOffsets[i].atof();
		if (abs(d)>dEps)dRowOffsets.append(d);	 
	}//next i
	double dColumnOffsets[0];
	String sColumnOffsets[] = sColumnOffsetList.tokenize(";");
	for (int i=0;i<sColumnOffsets.length();i++) 
	{ 
		double d= sColumnOffsets[i].atof();
		dColumnOffsets.append(d);	 
	}//next i


	//region Clone plines by row offsets and apply column start offsets
	PLine plines2[0];
	for (int j = 0; j < plines.length(); j++)
	{ 
		double rowOffset;
		int r,c = dColumnOffsets.length()>1?1:0;
		if (dRowOffsets.length() > 0)
		for (int i = 0; i <nNumRow-1; i++)
		{
			rowOffset += dRowOffsets[r];

			PLine pl = plines[j];
			pl.offset(rowOffset, false);
			
			if (c<dColumnOffsets.length())
			{ 
				pl.trim(dColumnOffsets[c], false);
				pl.trim(dColumnOffsets[c], true);	
			}


			pl.vis(i);
			if (pl.length()>dEps)
				plines2.append(pl);	
				
			r++;				
			if (r >= dRowOffsets.length())
				r = 0;
			c++;				
			if (c >= dColumnOffsets.length())
				c = 0;					

		}//next i
		
		if (dColumnOffsets.length() > 0)
		{
			plines[j].trim(dColumnOffsets[0], false);
			plines[j].trim(dColumnOffsets[0], true);					
		}
		
		
	}
	plines.append(plines2);		
//endregion 

	int numDrill;
	for (int j=0;j<plines.length();j++) 
	{ 
		
		PLine& pl = plines[j]; 
		if (pl.length() < dEps)continue;
		pl.projectPointsToPlane(pnFace, vecZ);
		
		if (bRevertDirection)pl.reverse();
		
		
		if (bJig)
		{ 
			dpModel.trueColor(darkyellow, 0);
			dpModel.draw(pl);
			dpModel.trueColor(lightblue, 50);
		}
		else
			dpModel.draw(pl);

		int numColumn = 1;
		double dRange = pl.length();
		double dDist = dInterdistance;
		
		if (nDistributionMode==0 && dDist>0)// fixed
			numColumn = dRange / dDist;
		else if (nDistributionMode==1 && dDist>0 && dRange>0)// even
		{
			numColumn = dRange / dDist+.99;
			dDist = dRange / numColumn;
		}
		
		if (Vector3d(pl.ptStart()-pl.ptEnd()).length()<dEps)
			numColumn--;
		
	//region Add drills and draw
		Point3d ptLocs[0];
		Map mapLocs;
		for (int i=0;i<=numColumn;i++) 
		{ 
			double d = i * dDist;
			Point3d pt = pl.getPointAtDist(d);
			//pt.vis(i);	
			
			Point3d ptA=pt, ptB=pt;
			if (d<= dEps) ptB = pl.getPointAtDist(dEps);
			else if (abs(d-pl.length())<dEps) ptA = pl.getPointAtDist(d-dEps);
			else 
			{
				ptA= pl.getPointAtDist(d-dEps);
				ptB= pl.getPointAtDist(d+dEps);
			}
			
			Vector3d vecXS = ptB - ptA; vecXS.normalize();
			if (vecXS.bIsZeroLength())vecXS = vecX;
			Vector3d vecYS = vecXS.crossProduct(vecZ);			
			
		// create single clone	
			if (bEditInPlace)
			{ 
				ptsTslDrill[0] = pt;				
				tslDrill.dbCreate("hsbCLT-Drill" , vecXS ,vecYS,gbsTslDrill, entsTslDrill, ptsTslDrill, nPropsDrill, dPropsDrill, sPropsDrill,_kModelSpace, mapTslDrill);
				continue;
			}

			Vector3d vecXT = vecXS;
			Vector3d vecZT = -vecFace;
			CoordSys csBevel;
			//vecAxisBevel.vis(_Pt0, 2);
			csBevel.setToRotation(dBevel,-nFace*vecYS,pt);//
			vecXT.transformBy(csBevel);
			vecZT.transformBy(csBevel);
			CoordSys csRot;
			csRot.setToRotation(dRotation,nFace*vecFace,pt);
			vecXT.transformBy(csRot);
			vecZT.transformBy(csRot);
			Vector3d vecYT = vecXT.crossProduct(-vecZT);		//vecZT.vis(pt, 4);			

		// calculate drill extension when beveled
			double deltaDepth = dEps;	
			if (!vecZT.isParallelTo(vecZ))
			{ 
				double d = -vecZT.angleTo(vecFace);//, vecXS);
				int nd = d / 90;
				int sgn = abs(d) / d;

				if (nd*(double(90))==d)		d = 0;
				else if (abs(d) > 270)		d = (360 - abs(d))*sgn;
				else if (abs(d) >= 90)		d -= 180 * sgn;	
				
				d = 90 - d;
				deltaDepth = (bHasSink?radiusSink:radius) / tan(d);
				if (deltaDepth < dEps)deltaDepth = dEps;
			}
	

			PLine circle;
			
		// symbol at end(depth)	
			circle.createCircle(pt, vecZT, radius);
			PlaneProfile pp(CoordSys(pt,vecXT, vecYT, vecZT));
			pp.joinRing(circle, _kAdd);
			
			if (bIsThrough)// complete through
				pp.project(pnOpp, vecZT, dEps);
			else
				pp.transformBy(vecZT * dDepth);
			Point3d pt2 = pp.ptMid();			
			dpModel.draw(pp);
			dpModel.draw(PLine(pt, pt2));
			
		// symbol at start	
			if (bHasSink)
			{ 
				pp=PlaneProfile (CoordSys(pt,vecXT, vecYT, vecZT));
				circle.createCircle(pt, vecZT, radiusSink);
				pp.joinRing(circle, _kAdd);
			}
			pp.project(pnFace, vecZT, dEps);
			
			if (ppRange.pointInProfile(pt)==_kPointOutsideProfile)
			{ 
				Display dpOut(0);
				dpOut.trueColor(red);
				dpOut.draw(pp, _kDrawFilled);	
				continue; // do not add drill
				
			}
			else
				dpModel.draw(pp, _kDrawFilled);
			dpModel.draw(pp);
			
			
		// Tool	
			Point3d ptStart = pt - vecZT * (deltaDepth);				//vecZT.vis(ptStart,5);
			Point3d ptEnd= bIsThrough?pt2+ vecZT * deltaDepth:pt2;
			Point3d ptEndSink= ptStart + vecZT*dDepthSink;
			ptLocs.append(pt);
			
			if (!bJig)
			{ 
				Map m;
				m.setPoint3d("pt", pt);
				m.setPoint3d("ptStart", ptStart);
				m.setPoint3d("ptEnd", ptEnd);
				if (bHasSink)
					m.setPoint3d("ptEndSink", ptEndSink);
				m.setVector3d("vecZT", vecZT);
				mapLocs.appendMap("Location", m);				
			}
			
			
			
			numDrill++;
			if (!bJig)
			{ 				
				Drill drill(ptStart, ptEnd, radius);
				drill.addMeToGenBeamsIntersect(sips);
				drill.addMeToGenBeamsIntersect(gbFemales);
				if (bHasSink)
				{ 
					Drill sink(ptStart, ptEndSink, radiusSink);
					sink.addMeToGenBeamsIntersect(sips);
					sink.addMeToGenBeamsIntersect(gbFemales);
				}
			}
		}//next i
		if (bJig){ continue;}
	//endregion 	

	//region Get segmented plines
		PLine plSegs[0];
		int bIsArcs[0];
		Point3d pts[] = pl.vertexPoints(false);
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Point3d pt1= pts[p];
			Point3d pt2= pts[p+1];
			Point3d ptm= (pt1+pt2)*.5;
			int bIsArc = !pl.isOn(ptm);
			PLine plSeg(vecZ);
			plSeg.addVertex(pt1);
			if (!bIsArc)
				plSeg.addVertex(pt2);
			else
				plSeg.addVertex(pt2, pl.getPointAtDist(pl.getDistAtPoint(pt1)+dEps));
			
			 plSeg.vis(bIsArc);
			 plSegs.append(plSeg);
			 bIsArcs.append(bIsArc);
		}//next p			
	//endregion 

	// Dimrequest
		for (int jj=0;jj<plSegs.length();jj++) 
		{ 
			int bIsArc = bIsArcs[jj]; 
			PLine plSeg = plSegs[jj]; 
			if (plSeg.length() < dEps)continue;
			
			Point3d pt1 = plSeg.ptStart();
			Point3d pt2 = plSeg.ptEnd();
			
			Vector3d vecDimLineDir = pt2 - pt1; vecDimLineDir.normalize();
			Vector3d vecPerpDimLineDir = vecDimLineDir.crossProduct(vecZ);
			if (vecPerpDimLineDir.dotProduct(plSeg.ptMid()-ptFace)<0)
				vecPerpDimLineDir *= -1;
				
			Map mapRequest;	
			int bDimRequestPoint;
			if (vecDimLineDir.isParallelTo(vecX) || vecDimLineDir.isParallelTo(vecY))			
			{
				bDimRequestPoint = true;
				mapRequest.setString("DimRequestPoint", "DimRequestPoint");
			}
			else				
			{
				mapRequest.setString("DimRequestChain", "DimRequestChain");	
				mapRequest.setInt("DisplayModusMiddle", _kDimPar);
				mapRequest.setInt("DisplayModusEnd", _kDimNone);
			}
			mapRequest.setString("ParentUID", sipRef.handle());
			mapRequest.setVector3d("AllowedView", vecZ);	
			mapRequest.setInt("AlsoReverseDirection", true);
			mapRequest.setInt("DeltaOnTop", true);
				

		// collect drill loacations on this segment
			Point3d pts[0];
			for (int p=0;p<mapLocs.length();p++) 
			{ 
				Map m = mapLocs.getMap(p);				
				Point3d pt= m.getPoint3d("pt"); 
				if (plSeg.isOn(pt))
				{ 
					pts.append(pt);		//pt.vis(jj);
				}
				 
			}//next p			
		
//			for (int p=0;p<ptLocs.length();p++) 
//			{ 
//				Point3d pt= ptLocs[p]; 
//				if (plSeg.isOn(pt))
//				{ 
//					pts.append(pt);		//pt.vis(jj);
//				}
//				 
//			}//next p
			
			
			pts = Line(_Pt0, vecDimLineDir).orderPoints(pts);
			
			if (pts.length()>3)
			{ 
				Map mapAdditional;
				mapAdditional.setInt("Quantity", pts.length());
				mapAdditional.setInt("Quantity-2", pts.length() - 2);
				String sDistributionText = _ThisInst.formatObject(sDistributionFormat, mapAdditional); 				

				Map mapNodes; // a map containing submaps with delta and cum node texts and its corresponding point	
				
			// get referenve points
				LineSeg segs[] = ppRange.splitSegments(LineSeg(pt1 - vecDimLineDir * U(10e4), pt1 + vecDimLineDir * U(10e4)), true);
				Point3d ptsX[0];
				for (int p=0;p<segs.length();p++) 
				{ 
					ptsX.append(segs[p].ptStart());
					ptsX.append(segs[p].ptEnd()); 
				}//next p
				ptsX = Line(_Pt0, vecDimLineDir).orderPoints(ptsX);
				
				
			// append node based dimension
				Point3d ptChainRefs[0];
				if (ptsX.length()>1)
				{ 
					Map m;
					Point3d pt;
					
				// ref points
					if (bDimRequestPoint)
					{ 
					// ref 1	
						pt = ptsX.first();								pt.vis(4);
						m.setPoint3d("pt",pt );				
						m.setString(kTextCumm, " "); // suppress 0
						m.setInt("isRef", true);
						mapNodes.appendMap(kNode, m);
						m.removeAt("isRef", true);
					
					// ref 2
						pt = ptsX.last();								pt.vis(4);
						m.setPoint3d("pt", pt);				
						m.setString(kTextCumm, "<>");
						mapNodes.appendMap(kNode, m);										
					}

				// first	
					pt = pts.first();									pt.vis(40);
					m.setPoint3d("pt", pt);
					m.setString(kTextCumm, "<>");
					mapNodes.appendMap(kNode, m);					
					if (!bDimRequestPoint)ptChainRefs.append(pt);

				// last
					pt = pts.last();									pt.vis(40);
					m.setPoint3d("pt", pt);
					m.setString(kTextCumm, "<>");
					mapNodes.appendMap(kNode, m);
					if (!bDimRequestPoint)ptChainRefs.append(pt);
					
				// second
					pt = pts[1];										pt.vis(50);
					m.setPoint3d("pt", pt);
					m.setString(kTextCumm, "<>");
					m.setString(kTextDelta, sDistributionText);
					mapNodes.appendMap(kNode, m);
					
					
					if (!bDimRequestPoint)
						mapRequest.setString("Stereotype", sStereotype);
					else
						mapRequest.setString("Stereotype", jj);
					mapRequest.setVector3d("vecDimLineDir", vecDimLineDir);			vecDimLineDir.vis(plSeg.ptMid(), 1);
					mapRequest.setVector3d("vecPerpDimLineDir", vecPerpDimLineDir);	vecPerpDimLineDir.vis(plSeg.ptMid(), 4);
					mapRequest.setMap(kNodes,mapNodes);
					mapRequests.appendMap("DimRequest",mapRequest);										
				}

			// add orthogonal ref points to any aligned chain
				if (ptChainRefs.length()>0)
				{ 
					mapRequest = Map();
					
					mapRequest.setString("ParentUID", sipRef.handle());
					mapRequest.setVector3d("AllowedView", vecZ);	
					mapRequest.setInt("AlsoReverseDirection", true);
					mapRequest.setInt("DeltaOnTop", true);		

					mapRequest.setString("DimRequestPoint", "DimRequestPoint");
					mapRequest.setString("Stereotype", "Dist");
					for (int xy=0;xy<2;xy++) 
					{ 
						vecDimLineDir = xy == 0 ? vecX : vecY;
						vecPerpDimLineDir = xy == 0 ? vecY :- vecX;						
						if (vecPerpDimLineDir.dotProduct(plSeg.ptMid()-ptFace)<0)
							vecPerpDimLineDir *= -1;
						
						Point3d pts[] = sipRef.envelopeBody().extremeVertices(vecDimLineDir);
						pts.append(ptChainRefs);
						mapRequest.setVector3d("vecDimLineDir", vecDimLineDir);
						mapRequest.setVector3d("vecPerpDimLineDir",vecPerpDimLineDir );
						mapRequest.setPoint3dArray(kNodes, pts);
						mapRequests.appendMap("DimRequest",mapRequest);
					}//next xy
				}
			}		 
		}//next jj

	
	}//next j
	
	if (bJig)return;

// publish dim requests	
//	if (mapRequests.length()>0)
//	{
//		_Map.setMap("DimRequest[]", mapRequests);	
//	}
//	else
//		_Map.removeAt("DimRequest[]", true);



//endregion

//region Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };	


// Trigger FlipSide//region
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		sFace.set(sFace == kReferenceFace ? kTopFace:kReferenceFace );
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RevertDirection
	String sTriggerRevertDirection = T("|Revert Direction|");
	addRecalcTrigger(_kContextRoot, sTriggerRevertDirection );
	if (_bOnRecalc && _kExecuteKey==sTriggerRevertDirection)
	{
		_Map.setInt(kRevertDirection, bRevertDirection?false:true);	
		setExecutionLoops(2);
		return;
	}//endregion	



//region Trigger AddPanel
	String sTriggerAddPanel = T("|Add Panels|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPanel );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPanel)
	{
	// prompt for genbeams
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
				if (gbFemales.find(sip)>-1){ continue;} // skip any female assigned
								
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

//region Trigger AddPanel
	String sTriggerAddSecond = T("|Add secondary objects|");
	addRecalcTrigger(_kContextRoot, sTriggerAddSecond );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddSecond)
	{
	// prompt for genbeams
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());	
		
	// collect genbeams	
		int n;
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb= (GenBeam)ents[i]; ;			
			if (gb.bIsValid())
			{ 
				if (gbFemales.find(gb)>-1 || _Sip.find(gb)>-1){ continue;} // skip any female assigned
				gbFemales.append(gb);
				n++;
			}	 
		}//next i				
		
		if (n>0)
		{
		// remove potential epl
			for (int i=epls.length()-1; i>=0 ; i--) 
			{ 
				int n = _Entity.find(epls[i]);
				if (n>-1)
					_Entity.removeAt(n);
				
			}//next i
			_Map.setEntityArray(gbFemales, true, "Female[]", "", "Female");
		}
		
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger RemoveGenbeam
	String sTriggerGenbeam = T("|Remove genbeams|");
	if (sips.length()>0)
	{
		addRecalcTrigger(_kContextRoot, sTriggerGenbeam );
		if (_bOnRecalc && _kExecuteKey==sTriggerGenbeam)
		{
		// prompt for genbeams
			Entity ents[0];
			PrEntity ssE(T("|Select genbeams|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());			
		
		// collect sips		
			for (int i=0;i<ents.length();i++) 
			{ 
				int n = _Sip.find(ents[i]);
				if (n>-1 && _Sip.length()>1)
				{ 
					_Sip.removeAt(n);
				}
				int f = gbFemales.find(ents[i]);
				if (f>-1 && gbFemales.length()>1)
				{ 
					gbFemales.removeAt(f);
				}
			}//next i			
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	

//region Trigger ConvertToPolyline
	if (epls.length()<1)
	{ 
		String sTriggerConvertToPolyline = T("|Convert To Polyline|");
		addRecalcTrigger(_kContextRoot, sTriggerConvertToPolyline );
		if (_bOnRecalc && _kExecuteKey==sTriggerConvertToPolyline)
		{
			if (_PtG.length() > 0)_PtG.setLength(0);
			if (gbFemales.length()>0)
				_Map.removeAt("Female[]", true);
				
			for (int i=0;i<plines.length();i++) 
			{ 
				EntPLine epl;
				epl.dbCreate(plines[i]);
				if (epl.bIsValid())
				{
					epl.assignToGroups(sipRef, 'T');
					epl.setTrueColor(grey);
					_Entity.append(epl);
				}
				 
			}//next i
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	

//region Trigger ConvertToGrip
	if (_PtG.length()<1)
	{ 
		String sTriggerConvertToGrip = T("|Convert To Grip Points|");
		addRecalcTrigger(_kContextRoot, sTriggerConvertToGrip );
		if (_bOnRecalc && _kExecuteKey==sTriggerConvertToGrip)
		{
		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = sLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
		
			_ThisInst.setCatalogFromPropValues(sCatalogName);
		
			mapTsl.setEntityArray(_Map.getEntityArray("Female[]", "", "Female"), false, "Female[]", "", "Female");
			for (int i=0;i<_Sip.length();i++) 
			{ 
				gbsTsl.append(_Sip[i]); 
			}//next i
			
			for (int i=0;i<plines.length();i++) 
			{ 
				ptsTsl.setLength(0);
				Point3d pt0, pts[] = plines[i].vertexPoints(true);
				pt0.setToAverage(pts);
				ptsTsl.append(pt0);
				ptsTsl.append(pts);
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
			}//next i
			eraseInstance();
			return;
		}		
	}//endregion
	
	

	
	String sTriggerConfigShopdrawing= T("|Configure Shopdrawing|");
	addRecalcTrigger(_kContext, sTriggerConfigShopdrawing );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigShopdrawing)
	{
		mapTsl.setInt("DialogMode",1);
		
		sProps.append(sDistributionFormat);		
		sProps.append(sStereotype);	
		//sProps.append(sViews[nView]);

		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				Map m;
			
//				nView = sViews.find(tslDialog.propString(2));
//				if (nView < 0)nView = 0;
			
				m.setString(kFormat, tslDialog.propString(0));
				m.setString(kStereotype, tslDialog.propString(1));
//				m.setInt(kView, nView);
//				mapSetting.setMap(kShopdrawing, m);
//				
//				if (mo.bIsValid())mo.setMap(mapSetting);
//				else mo.dbCreate(mapSetting);

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
		
	}	
	
	
	
	
	
	
	
	
	
//region Trigger EditInPlace : remove instance after cloning into single ones
	addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
	if (bEditInPlace)
	{ 
		eraseInstance();
		return;
	}//endregion 
}
//endregion 



#End
#BeginThumbnail
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
G;EA@&6-RPP++&),;%EC&F-SX_V-]69UL,T2'`````$E%3D2N0F""

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
        <int nm="BreakPoint" vl="1152" />
        <int nm="BreakPoint" vl="1039" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14825 dimension requests prepared" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/1/2022 8:36:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14729 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/16/2022 5:55:50 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End