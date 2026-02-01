#Version 8
#BeginDescription
This tsl creates a fulcrum mill on a genbeam
Version 1.1 11.11.2022 HSB-16528 bugfix rotation extrusion , Author Thorsten Huck

Version 1.0 11.11.2022 HSB-16528 initial version of frustrum mill

#End
#Type O
#NumBeamsReq 1
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
// 1.1 11.11.2022 HSB-16528 bugfix rotation extrusion , Author Thorsten Huck
// 1.0 11.11.2022 HSB-16528 initial version of frustrum mill , Author Thorsten Huck

/// <insert Lang=en>
/// Select genbeam and pick insertion point
/// </insert>

// <summary Lang=en>
// This tsl creates a fulcrum mill on a genbeam
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "FrustrumMill")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select Tool|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
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
	int darkyellow3D = bIsDark?rgb(157, 137, 88):rgb(254,234,185);
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
//endregion 	
	
//end Constants//endregion

//region References
	Point3d ptFace;
	Plane pnFace;
	Vector3d vecX, vecY,vecZ,vecFace;
	GenBeam gbRef;
	double dH;
	
	PlaneProfile ppRange;
	int bDrag = _bOnGripPointDrag && (_kExecuteKey.find("_PtG" ,0,false) >- 1 || _kExecuteKey == "_Pt0");
//endregion 

//region JIG
	String kJigSelectFace = "JigSelectFace", kJigLocation = "JigPickLocation";
	
	int bJig;
	if (_bOnJig && _kExecuteKey== kJigSelectFace)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		int bFront = ! _Map.hasInt("showFront") ? true : _Map.getInt("showFront");
		Map mapFaces = _Map.getMap("Face[]");
		PlaneProfile pps[0];
		
		double dDist = U(10e5);
		int index = - 1;
		for (int i = 0; i < mapFaces.length(); i++)
		{
			PlaneProfile pp = mapFaces.getPlaneProfile(i);
			CoordSys cs = pp.coordSys();
			Vector3d vecZ = cs.vecZ();
			Point3d ptOrg = cs.ptOrg();
			
//			Display dpx(i);
//			dpx.draw(PLine(pp.ptMid(), pp.ptMid() + vecZ * U(200)));

			double dFront = vecZ.dotProduct(vecZView);
			if ((dFront > 0 && bFront) || (dFront < 0 && !bFront))
			{
				Point3d pt = ptJig;
				Line(ptJig, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);//
				if (pp.pointInProfile(pt)==_kPointInProfile)
					index = pps.length();
				pps.append(pp);
			}
		}
		
		Display dp(-1);
		if (index < 0 && pps.length() > 0)index = 0;
		for (int i = 0; i < pps.length(); i++)
		{
			PlaneProfile pp = pps[i];
			
			if (in3dGraphicsMode())
			{ 
				pp.transformBy(pp.coordSys().vecZ() *10*dEps);
				dp.trueColor(i == index?darkyellow3D:lightblue);				
			}
			else
			{ 
				dp.trueColor(i == index?darkyellow:lightblue,0);	
				dp.draw(pp);
				dp.trueColor(i == index?darkyellow:lightblue,75);				
			}
			dp.draw(pp, _kDrawFilled);
		}//next i

		return;		
	}		
	
	
	else if (_bOnJig && _kExecuteKey== kJigLocation)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		PlaneProfile ppShadow = _Map.getPlaneProfile("pp");
		double dRadius1 = _Map.getDouble("Diameter1")*.5;
		double dRadius2 = _Map.getDouble("Diameter2")*.5;
		double depth = _Map.getDouble("depth");
		Point3d ptsZ[] = _Map.getPoint3dArray("pts");
		
		
		CoordSys cs = ppShadow.coordSys();
		Vector3d vecXT = cs.vecX();
		Vector3d vecYT = cs.vecY();
		vecFace = cs.vecZ();
		Plane pn(cs.ptOrg(), vecFace);

		Point3d pt = ptJig;
		
	// project by view if not within Z-Bounds	
		if (ptsZ.length()>1)
		{ 
			double d1 = vecFace.dotProduct(ptsZ.last()-ptJig);
			double d2 = vecFace.dotProduct(ptJig-ptsZ.first());
			if (d1<0 || d2<0)
				Line(pt, vecZView).hasIntersection(pn, pt);
				
		}
		Line(pt, vecFace).hasIntersection(pn, pt);

		Display dp(-1);
		dp.trueColor(white);
		PlaneProfile ppToolShadow(cs);
		PLine pl;
		pl.createCircle(pt, cs.vecZ(), dRadius1);
		ppToolShadow.joinRing(pl, _kAdd);
		int bOk = ppToolShadow.intersectWith(ppShadow);

		{ 
			PlaneProfile pp = ppShadow;
			pp.joinRing(pl, _kSubtract);
			dp.trueColor(lightblue, 90);
			dp.draw(pp, _kDrawFilled);
		}
		


	//region Draw X-Y Dimensions
		if (bOk)
		{ 
			dp.trueColor(white, 0);
			dp.textHeight(dViewHeight * .02);
			Point3d pts[] = ppShadow.intersectPoints(Plane(pt, vecXT), true, true);
			pts.insertAt(0, pt);
			Vector3d vecXD = vecYT;
			Vector3d vecYD = vecXT; 			
			for (int i=0;i<2;i++) 
			{ 
				Vector3d vecZD = vecXD.crossProduct(vecYD);
				if (vecZD.dotProduct(vecZView) < 0)
					vecYD*=-1;
					
				DimLine dl(pt, vecXD, vecYD);
				dl.setUseDisplayTextHeight(true);
				Dim dim(dl,  pts, "<>",  "<>", _kDimPar, _kDimNone); 
				dim.setReadDirection(5*vecYView - vecXView);
				dp.draw(dim);				
				
				pts = ppShadow.intersectPoints(Plane(pt, vecYT), true, true);
				pts.insertAt(0, pt);
				vecXD = vecXT;
				vecYD = vecYT;
			}//next i			
		}
			
	//endregion

		dp.trueColor((bOk ?darkyellow: red),0);
		Body bd(pt+vecFace*dEps, pt - vecFace * depth, dRadius1, dRadius2);
		dp.draw(bd);


		return;
	}
	
	
//endregion 

//region Properties

category = T("|Geometry|");
	String sDiameter1Name=T("|Diameter| 1");	
	PropDouble dDiameter1(nDoubleIndex++, U(100), sDiameter1Name);	
	dDiameter1.setDescription(T("|Defines Diameter| 1"));
	dDiameter1.setCategory(category);
	double dRadius1 = dDiameter1 * .5;
	
	String sDiameter2Name=T("|Diameter| 2");	
	PropDouble dDiameter2(nDoubleIndex++, U(120), sDiameter2Name);	
	dDiameter2.setDescription(T("|Defines Diameter| 2"));
	dDiameter2.setCategory(category);	
	double dRadius2 = dDiameter2 * .5;
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(40), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
	

category = T("|Alignment|");
	String tReferenceFace = T("|Bottom Face|");
	String tTopFace =  T("|Top Face|");	
	String sFaceName=T("|Face|");	
	String sFaces[] ={ tReferenceFace, tTopFace };
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);	
	
category = T("|Tooling|");
	String sToolIndexName=T("|CNC Tool Index|");	
	PropInt nToolIndex(nIntIndex++, 0, sToolIndexName);	
	nToolIndex.setDescription(T("|Defines the CNC tool index which is used to identify the tool on the machine.|") + T(" |This value must match with te index specified in the corresponding machine export.|"));
	nToolIndex.setCategory(category);

	String sToolDiameterName=T("|Tool Diameter|");	
	PropDouble dToolDiameter(nDoubleIndex++, U(40), sToolDiameterName);	
	dToolDiameter.setDescription(T("|Defines the Tool Diameter which is used cor the graphics display.|") + T(" |The tool diameter on the machine is set by the tool index.|"));
	dToolDiameter.setCategory(category);
	if (dToolDiameter < dEps)dToolDiameter.set(U(40));
	
	


//endregion 

//region OnInsert #1
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
		_GenBeam.append(getGenBeam());

	}			
//endregion 

//region Get Reference

	if (_GenBeam.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + T(" |Invalid selection set.|"));
		eraseInstance();
		return;
	}
	else 
		gbRef = _GenBeam[0];
		
	// Flags
	int nFace = sFace == tReferenceFace ?- 1 : 1;
	int bRefIsSip = gbRef.bIsKindOf(Sip());
	int bRefIsBeam = gbRef.bIsKindOf(Beam());	

	vecX = gbRef.vecX();
	vecY = gbRef.vecY();
	vecZ = gbRef.vecZ();
	
	Body bd = gbRef.envelopeBody(false, true);
	Quader qdr(gbRef.ptCen(), vecX, vecY, vecZ, gbRef.solidLength(), gbRef.solidWidth(), gbRef.solidHeight(), 0, 0, 0);
	Point3d ptExtremes[0];
	ptExtremes.append(qdr.pointAt(-1, - 1 ,- 1));
	ptExtremes.append(qdr.pointAt(1,1 ,1));		
//endregion 

//region OnInsert #2
	if(_bOnInsert)
	{

	//Face selection if view direction not orthogonal to one of the 4 faces of the ref genbeam

	// Get face of insertion
		int bIsOrthoView = gbRef.vecD(vecZView).isParallelTo(vecZView);	
		vecFace = bIsOrthoView?vecZView:gbRef.vecD(vecZView);

	//region set face
		if (vecFace.isParallelTo(vecX) ||(bRefIsSip && vecZView.isPerpendicularTo(vecZ)))
		{
			reportMessage("\n"+ scriptName() + T(" |Insertion not supported in current view, please change view direction| ")+T("|Tool will not be inserted.|"));
			eraseInstance();
			return;
		}	

	// no face selection on panels
		if (bRefIsSip)
		{ 
			vecFace=vecZ*nFace; 
		}
		else if (!bIsOrthoView)
		{
			int nFaceIndex = - 1;
			
		// default to pick a face on viewing side	
			int bFront = true; 
			if (bRefIsBeam && nFace == -1) // back faces if beam and bottom selected
				bFront = false;
			else if (bRefIsSip  &&  nFace == -1)//qdr.vecD(vecZView).dotProduct(vecZ)<0) // back faces
				bFront = false;
				
			Map mapArgs, mapFaces;
			mapArgs.setInt("_Highlight", in3dGraphicsMode()); 
			mapArgs.setInt("showFront", bFront);		
	
		// Set Faces and profiles
			Vector3d vecFaces[0];
			if (bRefIsBeam)
			{ 
				Vector3d vecs[] ={ gbRef.vecY(), gbRef.vecZ() , - gbRef.vecY(), - gbRef.vecZ()};
				vecFaces = vecs;
			}
			else // sip or sheet
			{ 
				Vector3d vecs[] ={ gbRef.vecZ() ,- gbRef.vecZ()};
				vecFaces = vecs;				
			}
						
			PlaneProfile ppFace,pps[0];//yz-y-z
			for (int i=0;i<vecFaces.length();i++) 
			{ 
				Vector3d vecFaceI = vecFaces[i];	
				Plane pn (gbRef.ptCen() + vecFaceI * .5 * gbRef.dD(vecFaceI), vecFaceI);
				PlaneProfile pp = bd.extractContactFaceInPlane(pn, U(1)); 
			
			// append secondary profiles	
//				for (int j=1;j<genbeams.length();j++) 
//				{ 
//					Body bdj= genbeams[j].envelopeBody(true, true);
//					PlaneProfile ppj = bdj.extractContactFaceInPlane(pn, U(1));
//					//getSlice(pn);
//					ppj.shrink(-dEps);
//					pp.unionWith(ppj);
//					 
//				}//next j

				pps.append(pp);
				mapFaces.appendPlaneProfile("pp", pp);
				
				if (bIsOrthoView && vecFace.isCodirectionalTo(vecFaceI))
				{
					nFaceIndex = i;
					ppFace = pp;
					mapArgs.setInt("FaceIndex", nFaceIndex);
				}
				
			}//next i
			mapArgs.setMap("Face[]", mapFaces);				
			
		//Face selection
			int nGoJig = -1;
			PrPoint ssP(T("|Select face|")+ T(" |[Flip side]|"));
			ssP.setSnapMode(TRUE, 0); // turn off snaps
		    while (!bIsOrthoView && nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigSelectFace, mapArgs); 
	
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value();
					int index;
					for (int i=0;i<pps.length();i++) 
					{
						PlaneProfile pp = pps[i];
						CoordSys cs = pp.coordSys();
						Vector3d vecZ = cs.vecZ();
						if (vecZ.isPerpendicularTo(vecZView))continue;
						Point3d ptOrg = cs.ptOrg();
						double dFront = vecZ.dotProduct(vecZView);
						if((dFront>0 && bFront) || (dFront<0 && !bFront)) // accept only profiles in view wirection or opposite
						{
							Point3d pt = ptPick;
							Line(pt, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);
							if (pp.pointInProfile(pt)==_kPointInProfile)
								index = i;
						}
					}    
		            
		            if (index>-1)
		            { 
		            	vecFace = gbRef.vecD(pps[index].coordSys().vecZ());	
		            	mapArgs.setInt("FaceIndex", index);
		            	nFaceIndex = index;
		            	ppFace = pps[index];	
		            }  
		        } 
		    	else if (nGoJig == _kKeyWord)
		        { 
		        // toggle in or opposite view	
		            if (ssP.keywordIndex() == 0)
		            {
		            	bFront =!bFront;
		            	mapArgs.setInt("showFront", bFront);
		            }    
		        }   
		        else
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
			//End Face selection		
			ssP.setSnapMode(false, 0); // turn on snaps	
	
		}
		// orthogonal view, set ref or top side
		else
		{ 
			vecFace*=nFace; 
		}
		
		dH = gbRef.dD(vecFace);
		
		ptExtremes = Line(_Pt0, vecFace).orderPoints(ptExtremes);
		if (ptExtremes.length()>0)
			ptFace = ptExtremes.last();
		else
			ptFace = gbRef.ptCen() + .5 * vecFace * dH;
		pnFace = Plane(ptFace, vecFace);

			
	//endregion Face selection


	//region Show Jig
		PrPoint ssP(T("|Select point [Flip Side]|")); // second argument will set _PtBase in map
	    Map mapArgs;
	    mapArgs.setPlaneProfile("pp", gbRef.envelopeBody(true, true).extractContactFaceInPlane(pnFace, dEps));
		mapArgs.setDouble("Diameter1",dDiameter1);
		mapArgs.setDouble("Diameter2",dDiameter2);
		mapArgs.setDouble("depth",dDepth);
		mapArgs.setPoint3dArray("pts", ptExtremes);
		
	    int nGoJig = -1;
	    while (nGoJig != _kNone)//nGoJig != _kOk && 
	    {
	        nGoJig = ssP.goJig(kJigLocation, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick  = ssP.value(); //retrieve the selected point
	            
			// project by view if not within Z-Bounds	
				if (ptExtremes.length()>1)
				{ 
					double d1 = vecFace.dotProduct(ptExtremes.last()-ptPick);
					double d2 = vecFace.dotProduct(ptPick-ptExtremes.first());
					if (d1<0 || d2<0)
						Line(ptPick, vecZView).hasIntersection(pnFace, ptPick);
						
				}
				Line(ptPick, vecFace).hasIntersection(pnFace, ptPick);
			
			
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {gbRef};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptPick};
				int nProps[]={nToolIndex};			
				double dProps[]={dDiameter1,dDiameter2,dDepth,dToolDiameter};				
				String sProps[]={sFace};
				Map mapTsl;	

            // on beams the reference face is specified on insert andn not dependent from beam coordSys
				if (bRefIsBeam)
					mapTsl.setVector3d("vecFace", -vecFace);
            
            	tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
  
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	            {
	            	sFace.set(sFace == tReferenceFace ? tTopFace : tReferenceFace);
	            	vecFace *= -1;
	            	ptExtremes = Line(_Pt0, vecFace).orderPoints(ptExtremes);
	            
	            	if (ptExtremes.length()>0)
						ptFace = ptExtremes.last();
					else
						ptFace = gbRef.ptCen() + .5 * vecFace * dH;
	            	
	            	pnFace = Plane(ptFace, vecFace);
	            	mapArgs.setPoint3dArray("pts", ptExtremes);
	            	mapArgs.setPlaneProfile("pp", gbRef.envelopeBody(true, true).extractContactFaceInPlane(pnFace, dEps));
	            }
	        }
	        else if (nGoJig == _kCancel)
	        { 
	           
	            return; 
	        }
	    }			
	//End Show Jig//endregion 

		eraseInstance(); // do not insert this instance
		return;
	}			
//endregion 

//region Standards
	if (!bDrag)
	{ 
		setEraseAndCopyWithBeams(_kBeam0);
		assignToGroups(gbRef, 'T');
		addRecalcTrigger(_kGripPointDrag, "_Pt0");		
	}

	if (bRefIsBeam && _Beam.find(gbRef)<0)
		_Beam.append((Beam)gbRef);
	else if (bRefIsSip && _Sip.find(gbRef)<0)
		_Sip.append((Sip)gbRef);
	
	vecFace = _Map.hasVector3d("vecFace")?_Map.getVector3d("vecFace"):vecZ;
	vecFace *= nFace;
	
	ptExtremes = Line(_Pt0, vecFace).orderPoints(ptExtremes);
	
	ptExtremes[0].vis(1);
	ptExtremes[1].vis(2);
	
	
	if (ptExtremes.length()>0)
		ptFace = ptExtremes.last();
	else
		ptFace = gbRef.ptCen() + .5 * vecFace * dH;
	pnFace = Plane(ptFace, vecFace);
	Line(_Pt0, vecFace).hasIntersection(pnFace, _Pt0);
	
	Vector3d vecYT = (vecFace.isParallelTo(vecY)?nFace*vecZ :vecY)*nFace;
	Vector3d vecXT = vecYT.crossProduct(vecFace);

	CoordSys csT(_Pt0, vecXT, vecYT, vecFace);
	PlaneProfile ppShadow (csT);
	ppShadow.unionWith(gbRef.envelopeBody(true, true).extractContactFaceInPlane(pnFace, dEps));
	
	ppShadow.vis(6);
//endregion 

//region Tool PLines
	PLine pl1(vecFace), pl2(vecFace), circle1, circle2;
	Point3d pt = _Pt0;
	pt += vecFace * vecFace.dotProduct(ptFace - pt);		vecFace.vis(pt, 4);
	
	pl1.addVertex(pt + vecXT * dRadius1);
	pl1.addVertex(pt - vecXT * dRadius1,pt + vecYT * dRadius1 );

	//circle1.createCircle(pt, vecFace, dRadius1);  // VErsion 1.1 bugfix rotation extrusion: start of circle must match ptStart of path
	circle1 = pl1;
	circle1.addVertex(pt + vecXT * dRadius1,pt - vecYT * dRadius1);
	circle1.close();
	
	pl2.addVertex(pt + vecXT * dRadius2);
	pl2.addVertex(pt - vecXT * dRadius2,pt + vecYT * dRadius2 );
	pl2.transformBy(-vecFace * dDepth);
	
	circle2.createCircle(pt, vecFace, dRadius2);
	circle2.transformBy(-vecFace * dDepth);
	
	PlaneProfile ppToolShadow(csT);
	ppToolShadow.joinRing(circle1, _kAdd);
	_Map.setPlaneProfile("ppTool", ppToolShadow); // publish for temp dim	
	ppToolShadow.joinRing(circle2, _kAdd);
	ppToolShadow.vis(4);
	int bOk = ppToolShadow.intersectWith(ppShadow);

	if (!bOk && !bDrag)
	{ 
		reportMessage("\n" + scriptName() + T(" |outside of reference contour, tool purged|"));
		eraseInstance();
		return;	
	}
//endregion 

//region Create tool body
	// propeller surface seems to ignore tool shape
	int bIsConic = abs(dRadius1 - dRadius2) > dEps;
	int bIsSmallOutside = dDiameter1 < dDiameter2;
	Body bdTool;
	PLine plRotation(vecYT);
	double dInnerRadius, dDeltaDepth;
	if (bIsConic && bIsSmallOutside)
	{ 
		double b = dRadius2 - dRadius1;
		double c = dDepth;
		double alpha = atan(c/b);
		double c2 = dToolDiameter;
		double b2 = c2 * cos(alpha);
		double a2 = b2 * tan(alpha);

		Point3d ptn = pt - vecXT * dRadius2 - vecFace * c + vecXT * a2 - vecFace * b2;
		dInnerRadius = abs(vecXT.dotProduct(ptn - pt));
		dDeltaDepth = vecFace.dotProduct(pt - ptn)-dDepth;

		c -= dDeltaDepth;

		PLine pl(vecYT);
		pl.addVertex(pt-vecXT*dRadius1);
		pl.addVertex(pt-vecXT*dRadius2-vecFace*c);
		ptn = pt - vecXT * dRadius2 - vecFace * c + vecXT * a2 - vecFace * b2;
		pl.addVertex(ptn);
		
	// the shape for the solidSubtract needs to be torus alike	
		plRotation = pl;
		plRotation.addVertex(ptn+vecXT*.5*dInnerRadius);
		plRotation.addVertex(pt-vecXT*.5*dInnerRadius+vecFace*.5*dInnerRadius);
		plRotation.close();
		
		pl.addVertex(ptn+vecXT*dInnerRadius);
		pl.addVertex(pt);
		pl.close();		//pl.vis(2);		pl.ptStart().vis(5);		circle1.ptStart().vis(6);
		bdTool=Body(pl, circle1, 32);
		bdTool.vis(3);
		
		circle2.transformBy(vecFace * dDeltaDepth);
		circle2.vis(6);
		
	}
	

//endregion 



//region Display
	Display dp(dDepth<=0?1:(nFace==-1?72:132));

	if (bDrag)
	{ 
		dp.trueColor(bOk ? (in3dGraphicsMode()?lightblue:darkyellow): red);
		dp.draw(bdTool);
	
	
	//region Collect other frustrums within range // TODO
		TslInst tsls[0];

		for (int i=0;i<_GenBeam.length();i++) 
		{
			TslInst _tsls[] = _GenBeam[i].tslInstAttached();
			for (int j=0;j<_tsls.length();j++) 
				if (tsls.find(_tsls[j])<0)
					tsls.append(_tsls[j]); 
		}
			

		//reportNotice(("\nfound " + tsls.length()));
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst t = tsls[i]; 
			//reportNotice("\n script"+ t.scriptName());
			if (t.bIsValid() && t.scriptName()==scriptName() && t!=_ThisInst)
			{ 
				Map m = t.map();
				
				PlaneProfile pp = m.getPlaneProfile("ppTool");
				if (pp.coordSys().vecZ().isParallelTo(vecFace))
					ppShadow.subtractProfile(pp);
			}
			 
		}//next i	
	//endregion 

	//region Draw X-Y Dimensions
		if (bOk)
		{ 
			dp.trueColor(white);
			dp.textHeight(dViewHeight * .02);
			Point3d pts[] = ppShadow.intersectPoints(Plane(pt, vecXT), true, true);
			pts.insertAt(0, pt);
			Vector3d vecXD = vecYT;
			Vector3d vecYD = vecXT; 
			for (int i=0;i<2;i++) 
			{ 
				Vector3d vecZD = vecXD.crossProduct(vecYD);
				if (vecZD.dotProduct(vecZView) < 0)
					vecYD*=-1;
					
				DimLine dl(pt, vecXD, vecYD);
				dl.setUseDisplayTextHeight(true);
				Dim dim(dl,  pts, "<>",  "<>", _kDimPar, _kDimNone); 
				dim.setReadDirection(5*vecYView - vecXView);
				dp.draw(dim);				
				
				pts = ppShadow.intersectPoints(Plane(pt, vecYT), true, true);
				pts.insertAt(0, pt);
				vecXD = vecXT;
				vecYD = vecYT;
			}//next i				
		}
		

	//endregion 	
		

		
		return;
	}

	else
	{ 
		
		dp.draw(circle1);
		dp.draw(circle2);	
		dp.draw(PLine (pt, pt -vecFace*dDepth));	
	}



//endregion 







//region Tools
	if (dDepth>0)
	{ 
	//Propeller Tool
		if (bIsConic)
		{ 
			double dMaximumDeviation = U(10);
			int nToolSide = _kLeft;
		
			PropellerSurfaceTool tt(pl1, pl2,  dToolDiameter, dMaximumDeviation);
			tt.setMillSide(_kLeft);	
			tt.setCncMode(nToolIndex);
			Body bdTool = tt.cuttingBody();
			//bdTool.vis(6);
		
			tt.setDoSolid(bIsSmallOutside?false:true);
			gbRef.addTool(tt);
			
			CoordSys csRot; csRot.setToRotation(180, vecFace, pt);
			tt.transformBy(csRot);
			gbRef.addTool(tt);			
		}

	
	

	//Drill
		Drill dr(pt, pt-vecFace*dDepth, bIsSmallOutside?dInnerRadius:dRadius2);
		dr.addMeToGenBeamsIntersect(_GenBeam);	

		if (bIsSmallOutside)
		{ 
		// Solid Tool: it must be a torus alike shape to be accepted as tool
			Body bdx(plRotation, circle1, 32);
			SolidSubtract sosu(bdx, _kSubtract);
			//bdx.vis(6);
			for (int i=0;i<_GenBeam.length();i++) 
			{ 
				_GenBeam[i].addTool(sosu);
				 
			}//next i			
		}

		
		
	}

//endregion 


// Trigger FlipSide//region
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		sFace.set(sFace == tReferenceFace ? tTopFace : tReferenceFace);
		setExecutionLoops(2);
		return;
	}//endregion	




#End
#BeginThumbnail
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
40`4`%`!0`4`%`!0`4`%`!0!__]D`

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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16528 bugfix rotation extrusion" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="11/11/2022 2:32:43 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16528 initial version of frustrum mill" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/11/2022 10:21:38 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End