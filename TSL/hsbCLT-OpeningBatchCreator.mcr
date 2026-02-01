#Version 8
#BeginDescription
This tsl creates multiple instances of hsbCLT-Opening to modify openings. It requires qualified catalog entries of hsbCLT-Opening.

#Versions
Version 1.0 09.09.2022 HSB-16458 initial version
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.0 09.09.2022 HSB-16458 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select panels and filter / select openings on screen
/// </insert>

// <summary Lang=en>
// This tsl creates multiple instances of hsbCLT-Opening to modify openings. It requires qualified catalog entries of hsbCLT-Opening.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-OpeningBatchCreator")) TSLCONTENT
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
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int lightgreen = rgb(127,255,0);
	int green = rgb(19,155,72);	
	int darkgreen = rgb(64,146,2);

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
	
	String kJigShowOpening = "jigShowOpening", tDisabled = T("<|Disabled|>"),tByCatalog = T("|byCatalog|"),
	kFaceRef = T("|Reference Side|"), kFaceOpp = T("|Opposite Side|"),kCloning = "isCloning", kBatchIndex = "batchIndex";
	double dBlowUpShrink = U(250);
	String script = "hsbCLT-Opening";

//endregion 	
	
//end Constants//endregion

//region JIG

//region ShowOpening
	if (_bOnJig && _kExecuteKey==kJigShowOpening) 
	{
	//_ThisInst.setDebug(TRUE);
	    Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		String sAreaFilter = _Map.getString("AreaFilter");

		Display dp(-1), dp2(-1);
		
	// draw area filter setting at cursor	
		dp.trueColor(red,0);
		dp.textHeight(dViewHeight/40);
		if (sAreaFilter!="0" && sAreaFilter.length()>0)
			dp.draw(sAreaFilter, ptJig, vecXView, vecYView, 1.2, 1.2 );

	// find shape at jig location
		for (int i=0;i<_Map.length();i++) 
		{ 
			Map m= _Map.getMap(i);
	
			PlaneProfile ppShape = m.getPlaneProfile("shape");
			PLine plContour= m.getPLine("contour");
			PlaneProfile ppContour(plContour);
			
			PLine plShape;
			PLine rings[] = ppShape.allRings(true, false);
			if (rings.length() > 0)plShape = rings.first();
			double dZ = m.getDouble("dZ");
			
			CoordSys cs = ppShape.coordSys();
			Vector3d vecX = cs.vecX();	
			Vector3d vecY = cs.vecY();	
			Vector3d vecZ = cs.vecZ();			
			
			Vector3d vecFree = m.getVector3d("vecFree");
			int bIsDoor = !vecFree.bIsZeroLength();


			Point3d pt=ptJig;
			Line(ptJig,vecZView).hasIntersection(Plane(cs.ptOrg(), vecZ),pt);

			if (ppShape.pointInProfile(pt)==_kPointInProfile)
			{	
				dp.trueColor(darkyellow,50);
				dp.draw(ppShape, _kDrawFilled);
				dp.trueColor(darkyellow,0);
				dp.draw(ppShape);
			}
			else
			{ 
				PlaneProfile pp2 = ppShape;
				pp2.shrink(U(50));
				PlaneProfile pp1 = ppShape;
				pp1.subtractProfile(pp2);
				
				dp.trueColor(lightblue,50);
				dp.draw(ppShape, _kDrawFilled);
				if (bIsDoor) //Door
					dp.trueColor(blue,0);
				else
					dp.trueColor(purple,0);					
				dp.draw(pp1,_kDrawFilled);
				dp.trueColor(lightblue,50);
			}
			dp.draw(ppShape.extentInDir(cs.vecX()));
			
			if (plShape.area()>pow(dEps,2) && dZ > 0)
			{ 
				Body bd(plShape, vecZ * dZ, 1);
				dp.draw(bd);
			}			
			
			
		}//next i
	    return;
	}		
//End bOnJig//endregion 


//endregion 


//region Catalog entries collection
	String entries[]= TslInst().getListOfCatalogNames("hsbCLT-Opening");
	{ 
		int n = entries.findNoCase(tDisabled);
		if (n >- 1)entries.removeAt(n);
		n = entries.findNoCase(tLastInserted);
		if (n >- 1)entries.removeAt(n);
		n = entries.findNoCase(tDefault);
		if (n >- 1)entries.removeAt(n);
		
	}
	
	if (entries.length()<2)
	{ 
		reportNotice(TN("|This tool creates multiple instances of the tool| ") + script);
		reportNotice(TN("|It requires catalog entries which specify the different properties of a batch creation.|"));
		reportNotice(TN("|Please specify catalog entries and try again.|"));
		eraseInstance();
		return;
	}
	entries.insertAt(0, tDisabled);		
//endregion 


//region Properties	
category = T("|Batch Rules|");	
	String sStrategy1Name=T("|Strategy| 1");	
	PropString sStrategy1(nStringIndex++, entries, sStrategy1Name);	
	sStrategy1.setDescription(T("|Defines the first strategy based on a catalog entry to be applied to the opening|"));
	sStrategy1.setCategory(category);
	
	String sStrategy2Name=T("|Strategy| 2");	
	PropString sStrategy2(nStringIndex++, entries, sStrategy2Name);	
	sStrategy2.setDescription(T("|Defines the second strategy based on a catalog entry to be applied to the opening|"));
	sStrategy2.setCategory(category);	
		
	String sStrategy3Name=T("|Strategy| 3");	
	PropString sStrategy3(nStringIndex++, entries, sStrategy3Name);	
	sStrategy3.setDescription(T("|Defines the third strategy based on a catalog entry to be applied to the opening|"));
	sStrategy3.setCategory(category);	
	
category = T("|General|");
	String sAreaFilterName=T("|Filter by Area|");	
	PropString sAreaFilter(nStringIndex++, "", sAreaFilterName);	
	sAreaFilter.setDescription(T("|Shapes matching the filter condition are accepted.|") + 
		T("|Specify area in m² (metric) or drawing units (imperial) with leading logical condition, i.e. <=0.7|") );
	sAreaFilter.setCategory(category);	
	
	String sFaceName=T("|Face|");
	String sFaces[] = { tByCatalog,kFaceRef, kFaceOpp};
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFaces.find(sFace)==2?1:-1;	
	
	
//endregion 



//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();

	//region Get Area and logical expression of filter area
		int nLogical; // 0: undefined, 1: <, 2: <= 3:> 4:>= 5:=
		double dArea;
		int bIsMetric = U(1000) == 1000 || U(1000) == 100 || U(1000) == 10 || U(1000) == 1;
		if (sAreaFilter.length()>1)
		{ 
			String s = sAreaFilter; s.trimLeft().trimRight();
			String s1 = s.left(1);
			String s2 = s.left(2).right(1);
			if (s1 == "<")nLogical = s2 == "=" ? 2 : 1;// smaller equal , smaller
			else if (s1 == ">")nLogical = s2 == "=" ? 4 : 3; // greater equal, greater 
			else if (s1 == "=")nLogical = 5; // equal
			
			int n;
			if (nLogical == 1 || nLogical == 3 || nLogical == 5)n = 1;
			else if (nLogical == 2 || nLogical == 4)n = 2;
			
			String s3 = s.right(s.length() - n).trimLeft().trimRight();
			dArea = s3.atof();
		}			
	//endregion 

	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
	// loop selection set and collect shapes to be replaced
	// a set of 4 arrays with a one to one relation will be collected 
		Sip sips[0];				// the panel
		PlaneProfile ppShapes[0];	// the shape to be added to the panel
		PLine plContours[0];		// the contour to be of the modified
		Vector3d vecFrees[0];		// the free direction of a door/cutout alike ring		

		for (int i = 0; i < ents.length(); i++)
		{
			Sip sip = (Sip)ents[i];
			Vector3d vecX = sip.vecX();
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ();
			Point3d ptCen = sip.ptCenSolid();
			double dZ = sip.dH();
			PLine plEnvelope = sip.plEnvelope();
			CoordSys cs = CoordSys(ptCen-vecZ*.5*dZ, vecX, vecY, vecZ);
			Plane pnZ(ptCen-vecZ*.5*dZ, vecZ);

		//Start snippet #1
		// the shape of the original panel
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(plEnvelope,_kAdd);

			PlaneProfile ppHull(cs);
			{
				PLine pl;pl.createConvexHull(pnZ, plEnvelope.vertexPoints(true));
				ppHull.joinRing(pl,_kAdd);					//ppHull.vis(3);
			}
			
		// get door and cut outs	
			PlaneProfile ppDoor(cs);
			ppDoor = ppHull;
			ppDoor.subtractProfile(ppEnvelope);
	
		// Collect rings of the ppDoor
			PLine rings[]=ppDoor.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile ppShape(cs);
				ppShape.joinRing(rings[r], _kAdd);			//ppShape.vis(1);
				Vector3d vecXD = cs.vecX() * (.5 * ppShape.dX() + dEps);
				Vector3d vecYD = cs.vecY() * (.5 * ppShape.dY() + dEps);
				
			// count free directions
				int num;
				Vector3d vecFree, vecs[] = {vecXD, vecYD, -vecXD, -vecYD};
				for (int i=0;i<vecs.length();i++) 
				{ 
					Point3d pt = ppShape.ptMid(); 
					pt.transformBy(vecs[i]);
					if (ppEnvelope.pointInProfile(pt)==_kPointOutsideProfile)
					{ 
						vecFree = vecs[i]; vecFree.normalize();
						num++;
					}
				}//next i
				
				if (num==1)
				{
					ppShapes.append(ppShape);					ppShape.extentInDir(vecX).vis(30);		
					plContours.append(rings[r]);
					sips.append(sip);
					vecFrees.append(vecFree);		
					vecFree.vis(ppShape.ptMid(), 1);
				}	
			}//next r
	
		// the boxed shape of the panel	
			PlaneProfile ppSipBox(cs);
			ppSipBox.createRectangle(ppEnvelope.extentInDir(vecX), vecX, vecY);
		
		// collect windows / openings	
			PLine plOpenings[] = sip.plOpenings();
			//reportNotice("\n" + sip.handle() + " num of openings " + plOpenings.length());
			for (int j=0;j<plOpenings.length();j++) 
			{ 
				PlaneProfile ppShape(cs);
				ppShape.joinRing(plOpenings[j],_kAdd);
				ppShapes.append(ppShape);					ppShape.extentInDir(vecX).vis(161);		
				plContours.append(plOpenings[j]);
				sips.append(sip);
				vecFrees.append(Vector3d(0,0,0)); // zero length means opening
			}//next j	
		}
		
	// Set Jig Map
		Map mapArgs;
		mapArgs.setString("AreaFilter", sAreaFilter);
		for (int i=0;i<sips.length();i++) 
		{ 	
		// check if this is to be filtered
			if (dArea>0)
			{ 
				double area = plContours[i].area();
				if (bIsMetric)area/=U(10e5,"mm");

				int bSkip;
				if (nLogical <= 2 && dArea < area){continue;}
				else if (nLogical == 2 && dArea <= area){continue;}
				else if (nLogical == 3 && dArea > area){continue;}
				else if (nLogical == 4 && dArea >= area){continue;}
				else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
			}

			Map mapArg;
			mapArg.setPlaneProfile("shape", ppShapes[i]);
			mapArg.setPLine("contour", plContours[i]);
			mapArg.setVector3d("vecFree", vecFrees[i]);
			//mapArg.setInt("Strategy", strategy);
			mapArg.setDouble("dZ", sips[i].dH());
			mapArgs.appendMap("Tool", mapArg);
		}//next i
		
		
		
	// Prompt to pick individual openings
		String prompt;
		PrPoint ssP(T("|Select Opening or all [Polylines/Openings/Cutouts/setArea]|"));//[Polylines/Openings/Cutouts/Shapes/setArea]|"));
		ssP.setSnapMode(TRUE, 0); // turn off all snaps
		int bInsertAll;

	// Jig
		int nGoJig = -1;
		while (nGoJig != _kNone)
		{ 
			nGoJig = ssP.goJig(kJigShowOpening, mapArgs); 
			
		//region Jig: point picked
			if (nGoJig == _kOk)
			{
				Point3d ptPick = ssP.value();
				
			// loop arrays to identify shape and contour
				for (int i=sips.length()-1; i>=0 ; i--) 
				{ 
				// check if this is to be filtered
					if (dArea>0)
					{ 
						double area = plContours[i].area();
						if (bIsMetric)area/=U(10e5,"mm");
		
						int bSkip;
						if (nLogical <= 2 && dArea < area){continue;}
						else if (nLogical == 2 && dArea <= area){continue;}
						else if (nLogical == 3 && dArea > area){continue;}
						else if (nLogical == 4 && dArea >= area){continue;}
						else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
					}	

					PLine plContour = plContours[i];
					PlaneProfile ppContour(plContour);
					
				// project picked point to plane	
					CoordSys cs = ppContour.coordSys();
					Point3d pt=ptPick;
					Line(ptPick,vecZView).hasIntersection(Plane(cs.ptOrg(), cs.vecZ()),pt);
					if (ppContour.pointInProfile(pt)==_kPointOutsideProfile){ continue;}
					
					PlaneProfile ppShape = ppShapes[i];					
					int bIsDoor = !vecFrees[i].bIsZeroLength();
					Sip sip = sips[i];
					Vector3d vecX = sip.vecX();
					Vector3d vecY = sip.vecY();

				// create TSL
					TslInst tslNew;				Map mapTsl;
					int bForceModelSpace = true;	
					String sExecuteKey,sCatalogName = tLastInserted;
					String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
					GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			
					Point3d ptsTsl[] = {ppShape.extentInDir(sip.vecX()).ptMid()};
				
					mapTsl.setPlaneProfile("shape",ppShape);//PlaneProfile(plContour));//
					mapTsl.setInt("isDoor", bIsDoor);

					tslNew.dbCreate(scriptName() ,vecX ,vecY,gbsTsl, entsTsl, ptsTsl, sCatalogName, 
						bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
					
				// remove inserted	
					ppShapes.removeAt(i);
					plContours.removeAt(i);
					vecFrees.removeAt(i);
					sips.removeAt(i);

				// recompose mapArgs
					mapArgs=Map();
					for (int ii=0;ii<sips.length();ii++) 
					{ 
					// check if this is to be filtered
						if (dArea>0)
						{ 
							double area = plContours[ii].area();
							if (bIsMetric)area/=U(10e5,"mm");
			
							int bSkip;
							if (nLogical <= 2 && dArea < area){continue;}
							else if (nLogical == 2 && dArea <= area){continue;}
							else if (nLogical == 3 && dArea > area){continue;}
							else if (nLogical == 4 && dArea >= area){continue;}
							else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
						}	

						Map mapArg;
						mapArg.setPlaneProfile("shape", ppShapes[ii]);
						mapArg.setPLine("contour", plContours[ii]);
						mapArg.setVector3d("vecFree", vecFrees[ii]);
						//mapArg.setInt("Strategy", strategy);
						mapArg.setDouble("dZ", sips[ii].dH());
						mapArgs.appendMap("Tool", mapArg);
					}//next i
				}//next i				
			}				
		//End Jig: point picked//endregion 	

		//region Jig: keyword
			else if (nGoJig == _kKeyWord)
			{ 
				int keywordIndex = ssP.keywordIndex();
				if (keywordIndex ==0)	// Polyline
				{ 
				// collect closed polylines
					PrEntity ssEpl(T("|Select polylines|"), Entity());
					Entity ents[0];
				  	if (ssEpl.go())
						ents.append(ssEpl.set());

					Map mapPLines;
					for (int i=0;i<ents.length();i++) 
					{ 
						//EntPLine epl = (EntPLine)ents[i];
						PLine pl = ents[i].getPLine();
						if (pl.area()>pow(dEps,2))
							mapPLines.appendPLine(ents[i].handle(), pl);
						 
					}//next i
					
					if (mapPLines.length()>0)
					{
						bInsertAll = true;
						mapArgs.appendMap("PLine[]", mapPLines);
						nGoJig = _kNone;
					}	
				}
				if (keywordIndex ==1 || keywordIndex ==2)	// all Openings, Doors or any shapes
				{ 					
				// remove all doors
					for (int i=sips.length()-1; i>=0 ; i--) 
					{ 
						int bIsDoor = !vecFrees[i].bIsZeroLength();
						if ((bIsDoor && keywordIndex==1) || (!bIsDoor && keywordIndex==2))
						{ 
							sips.removeAt(i);
							ppShapes.removeAt(i);
							plContours.removeAt(i);
							vecFrees.removeAt(i);
							
						}	
					}//next i
					bInsertAll = true;
					nGoJig = _kNone;
					break;
				}
				else if (keywordIndex ==3)
				{ 
					String sNewAreaFilter = getString(TN("|Specify area in m² (metric) or drawing units (imperial) with leading logical condition, i.e. <=0.7|"));
				
				
					if (sNewAreaFilter.length()>1)
					{ 
						String s = sNewAreaFilter; s.trimLeft().trimRight();
						String s1 = s.left(1);
						String s2 = s.left(2).right(1);
						if (s1 == "<")nLogical = s2 == "=" ? 2 : 1;// smaller equal , smaller
						else if (s1 == ">")nLogical = s2 == "=" ? 4 : 3; // greater equal, greater 
						else if (s1 == "=")nLogical = 5; // equal
						
						int n;
						if (nLogical == 1 || nLogical == 3 || nLogical == 5)n = 1;
						else if (nLogical == 2 || nLogical == 4)n = 2;
						
						String s3 = s.right(s.length() - n).trimLeft().trimRight();
						dArea = s3.atof();
						
						sAreaFilter.set(sNewAreaFilter);
						mapArgs=Map();
						mapArgs.setString("AreaFilter", sAreaFilter);
						for (int i=0;i<sips.length();i++) 
						{ 	
						// check if this is to be filtered
							if (dArea>0)
							{ 
								double area = plContours[i].area();
								if (bIsMetric)area/=U(10e5,"mm");
				
								int bSkip;
								if (nLogical <= 2 && dArea < area){continue;}
								else if (nLogical == 2 && dArea <= area){continue;}
								else if (nLogical == 3 && dArea > area){continue;}
								else if (nLogical == 4 && dArea >= area){continue;}
								else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
							}
				
							Map mapArg;
							mapArg.setPlaneProfile("shape", ppShapes[i]);
							mapArg.setPLine("contour", plContours[i]);
							mapArg.setInt("isDoor", !vecFrees[i]. bIsZeroLength());
							//mapArg.setInt("Strategy", strategy);
							mapArg.setDouble("dZ", sips[i].dH());
							mapArgs.appendMap("Tool", mapArg);
						}//next i							
	
					}
					else
					{ 
						mapArgs.setString("AreaFilter", "0");
						sAreaFilter.set("");
					}

				}
			}
		//End Jig: keyword//endregion 

		// Jig: cancel
	        else if (nGoJig == _kCancel)
	        {
	        	break;	
	        }

		}


	//region Collect sips and plines
		Map mapPLines = mapArgs.getMap("PLine[]");
		if (mapPLines.length()>0)
		{ 
			//reportNotice("\npline detection active");
			sips.setLength(0);
			ppShapes.setLength(0);
			plContours.setLength(0);
			vecFrees.setLength(0);
			
		// get profiles
			PlaneProfile pps[0];
			for (int i=0;i<mapPLines.length();i++) 
				if (mapPLines.hasPLine(i))
					pps.append(PlaneProfile(mapPLines.getPLine(i))); 
	
		// collect intersections with sips from sset
			for (int s=0;s<ents.length();s++) 
			{ 
				Sip sip =(Sip)ents[s];
				for (int i=0;i<pps.length();i++) 
				{ 
					PlaneProfile ppSip(sip.coordSys());
					ppSip.joinRing(sip.plEnvelope(),_kAdd);
					PlaneProfile pp1(sip.coordSys());
					pp1.unionWith(pps[i]);
					
					PlaneProfile pp2 = pp1;
					pp2.intersectWith(ppSip);
					
					PLine rings[] = pp1.allRings(true, false);
					if (pp2.area()>pow(dEps,2) && rings.length()>0)
					{ 
						sips.append(sip);
						ppShapes.append(pp1);
						plContours.append(rings.first());
						vecFrees.append(Vector3d(0,0,0));
					}
				}//next i 
			}//next s
		}
	//End Collect sips and plines//endregion 

	//region Insert all
		if (bInsertAll)
		{ 
			reportNotice("\n" + scriptName() + " " + sips.length() + T(" |shapes selected for batch creation|") + TN("|Please wait|"));
			
			int num;
      		for (int i=0;i<sips.length();i++) 
			{ 
			// check if this is to be filtered
				if (dArea>dEps)
				{ 
					double area = plContours[i].area();
					if (bIsMetric)area/=U(10e5,"mm");
	
					int bSkip;
					if (nLogical <= 2 && dArea < area){continue;}
					else if (nLogical == 2 && dArea <= area){continue;}
					else if (nLogical == 3 && dArea > area){continue;}
					else if (nLogical == 4 && dArea >= area){continue;}
					else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
				}	
				
				Sip sip = sips[i];
				Vector3d vecX = sip.vecX();
				Vector3d vecY = sip.vecX();
				
				PlaneProfile ppShape =ppShapes[i];
				PLine plContour = plContours[i];
				int bIsDoor = !vecFrees[i].bIsZeroLength();
				
			// create TSL
				TslInst tslNew;				Map mapTsl;
				int bForceModelSpace = true;	
				String sExecuteKey,sCatalogName = tLastInserted;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			
				Point3d ptsTsl[] = {ppShape.extentInDir(vecX).ptMid()};
			
				mapTsl.setPlaneProfile("shape", ppShape);
				//mapTsl.setPLine("contour", plContour);
				mapTsl.setVector3d("vecFree", vecFrees[i]);		
				mapTsl.setInt("isDoor", !vecFrees[i].bIsZeroLength());	
				
				tslNew.dbCreate(scriptName() , vecX, vecY,gbsTsl, entsTsl, ptsTsl, sCatalogName,bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
				
				num++;
//				
//				if (tslNew.bIsValid())
//				{
//					tslNew.recalcNow();
//				}
			}//next i			
			reportNotice("\n" +num + T(" |batch calls executed, done.|"));
		}
	//End Insert all//endregion  
	    
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
	//reportNotice("\n\nExecuting " + _ThisInst.handle() + " in loop " + _kExecutionLoopCount);

	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	Vector3d vecFace = nFace * vecZ;	vecFace.vis(ptCen,2);
	Point3d ptFace = ptCen + vecFace * .5 * dZ;
	Plane pnFace(ptFace, vecZ);
	_Pt0 += vecFace * vecFace.dotProduct(ptFace - _Pt0);

	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();
	Body bdEnv = sip.envelopeBody(false, true);
	Plane pnZ(ptCen, vecZ);
	CoordSys cs = CoordSys(ptFace, vecX, vecY, vecZ); cs.vis(2);

	PlaneProfile ppShape(cs);
	PlaneProfile ppShapeTool(cs);
	ppShape.unionWith(_Map.getPlaneProfile("shape"));	ppShape.vis(40);


//End Panel standards//endregion 


//region Debug Contour detection
	if (0)
	{
	// a set of 4 arrays with a one to one relation will be collected 
		Sip sips[0];				// the panel
		PlaneProfile ppShapes[0];	// the shape to be added to the panel
		PLine plContours[0];		// the contour to be of the modified
		Vector3d vecFrees[0];		// the free direction of a door/cutout alike ring	

	//Start snippet #1
	// the shape of the original panel
		PlaneProfile ppEnvelope(cs);
		ppEnvelope.joinRing(plEnvelope, _kAdd);			//ppEnvelope.vis(2);

		PlaneProfile ppHull(cs);
		{
			PLine pl;pl.createConvexHull(pnZ, plEnvelope.vertexPoints(true));
			ppHull.joinRing(pl,_kAdd);					//ppHull.vis(3);
		}
		
	// get door and cut outs	
		PlaneProfile ppDoor(cs);
		ppDoor = ppHull;
		ppDoor.subtractProfile(ppEnvelope);

	// Collect rings of the ppDoor
		PLine rings[]=ppDoor.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile ppShape(cs);
			ppShape.joinRing(rings[r], _kAdd);			//ppShape.vis(1);
			Vector3d vecXD = cs.vecX() * (.5 * ppShape.dX() + dEps);
			Vector3d vecYD = cs.vecY() * (.5 * ppShape.dY() + dEps);
			
		// count free directions
			int num;
			Vector3d vecFree, vecs[] = {vecXD, vecYD, -vecXD, -vecYD};
			for (int i=0;i<vecs.length();i++) 
			{ 
				Point3d pt = ppShape.ptMid(); 
				pt.transformBy(vecs[i]);
				if (ppEnvelope.pointInProfile(pt)==_kPointOutsideProfile)
				{ 
					vecFree = vecs[i]; vecFree.normalize();
					num++;
				}
			}//next i
			
			if (num==1)
			{
				ppShapes.append(ppShape);					ppShape.extentInDir(vecX).vis(30);		
				plContours.append(rings[r]);
				sips.append(sip);
				vecFrees.append(vecFree);		
				vecFree.vis(ppShape.ptMid(), 1);
			}	
		}//next r

	// the boxed shape of the panel	
		PlaneProfile ppSipBox(cs);
		ppSipBox.createRectangle(ppEnvelope.extentInDir(vecX), vecX, vecY);
	
	// collect windows / openings	
		PLine plOpenings[] = sip.plOpenings();
		//reportNotice("\n" + sip.handle() + " num of openings " + plOpenings.length());
		for (int j=0;j<plOpenings.length();j++) 
		{ 
			PlaneProfile ppShape(cs);
			ppShape.joinRing(plOpenings[j],_kAdd);
			ppShapes.append(ppShape);					ppShape.extentInDir(vecX).vis(161);		
			plContours.append(plOpenings[j]);
			sips.append(sip);
			vecFrees.append(Vector3d(0,0,0)); // zero length means opening
		}//next j
	}
//endregion 

//region Create batch clones
	TslInst tslNew;				Map mapTsl;
	int bForceModelSpace = true;	
	String sExecuteKey,sCatalogName = tLastInserted;
	String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
	GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			
	Point3d ptsTsl[] = {ppShape.extentInDir(vecX).ptMid()};	
	
	mapTsl.setPlaneProfile("shape", ppShape);
	mapTsl.setInt("isDoor", _Map.getInt("isDoor"));

	if (bDebug)
	{ 
		Display dp(1); dp.textHeight(U(50));
		String text;
		text += sStrategy1 != tDisabled ? "\\P"+sStrategy1 : "";
		text += sStrategy2 != tDisabled ? "\\P"+sStrategy2 : "";
		text += sStrategy3 != tDisabled ? "\\P"+sStrategy3 : "";
		
		dp.draw(text, _Pt0, _XW, _YW, 0, 0, _kDevice);
	}
	else
	{ 
		int n;
		if (sStrategy1!=tDisabled)
		{
			reportNotice(".");
			if (bDebug)reportNotice("\n	" + T("|creating| ") + sStrategy1);
			mapTsl.setInt(kBatchIndex, n++);
			tslNew.dbCreate(script , vecX, vecY,gbsTsl, entsTsl, ptsTsl, sStrategy1,bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			if (tslNew.bIsValid() && sFace!=tByCatalog && tslNew.propString(1)!=sFace)
			{
				tslNew.setPropString(1, sFace);
				//tslNew.recalcNow();
			}	
		}
		if (sStrategy2!=tDisabled)
		{
			reportNotice(".");
			if (bDebug)reportNotice("\n	" + T("|creating| ") + sStrategy2);
			mapTsl.setInt(kBatchIndex, n++);
			tslNew.dbCreate(script , vecX, vecY,gbsTsl, entsTsl, ptsTsl, sStrategy2,bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			if (tslNew.bIsValid() && sFace!=tByCatalog && tslNew.propString(1)!=sFace)
			{
				tslNew.setPropString(1, sFace);
				//tslNew.recalcNow();
			}
		}
		if (sStrategy3!=tDisabled)
		{
			reportNotice(".");
			if (bDebug)reportNotice("\n	" + T("|creating| ") + sStrategy3);
			mapTsl.setInt(kBatchIndex, n++);
			tslNew.dbCreate(scriptName() , vecX, vecY,gbsTsl, entsTsl, ptsTsl, sStrategy3,bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			if (tslNew.bIsValid() && sFace!=tByCatalog && tslNew.propString(1)!=sFace)
			{
				tslNew.setPropString(1, sFace);
				//tslNew.recalcNow();
			}
		}	
		eraseInstance();
		return;
	}

	
//endregion 

#End
#BeginThumbnail
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
8_PLP``Z)B=,==@XY`````$E%3D2N0F""





#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16458 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="9/9/2022 11:05:15 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End