#Version 8
#BeginDescription
#Versions
Version 1.9 12.12.2024 HSB-23173 The explanation of the wall filter has been made more descriptive
Version 1.8 22.07.2021 HSB-12665 floor / wall intersections corrected for walls not intersecting the floor envelope vertices

version value="1.7" date="20may2020" author="thorsten.huck@hsbcad.com"
HSB-7693 merging version conflicts, special output fixed 

HSB-7585 bugfix filter wall elements
HSB-6670 bugfix alignment if only one vertex of roofelement intersects
HSB-6670 bugfix alignment polygonal elements

This tsl creates markings on the top plates of any wall element which is connected to a floor element.
Markings are placed on the icon side of the wall.
The walls can be filtered by their exposed state (optional).
Joists with an extrusion profile can be filtered by the content of their information property (optional). 
If a joist filter is specified only joists containing this value are considered, else all profiled joists are taken.


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords ElementRoof;Floor;Decke;Mark;Marking;Markierung;Stereotype
#BeginContents
/// <History>//region
// #Versions
// 1.9 12.12.2024 HSB-23173 The explanation of the wall filter has been made more descriptive. , Author Thorsten Huck
// 1.8 22.07.2021 HSB-12665 floor / wall intersections corrected for walls not intersecting the floor envelope vertices , Author Thorsten Huck
/// <version value="1.7" date="20may2020" author="thorsten.huck@hsbcad.com"> HSB-7693 merging version conflicts, special output fixed </version>
/// <version value="1.6" date="13may2020" author="thorsten.huck@hsbcad.com"> HSB-7585 bugfix filter wall elements </version>
/// <version value="1.5" date="20mar2020" author="thorsten.huck@hsbcad.com"> HSB-6670 bugfix alignment if only one vertex of roofelement intersects </version>
/// <version value="1.4" date="13feb2020" author="thorsten.huck@hsbcad.com"> HSB-6670 bugfix alignment polygonal elements </version>
/// <version value="1.3" date="31jan2020" author="thorsten.huck@hsbcad.com"> HSB-6504 bugfix detecting markable beams </version>
/// <version value="1.2" date="30jan2020" author="thorsten.huck@hsbcad.com"> HSB-6504 duplicates will be removed, loose joists are collected by parent floor group</version>
/// <version value="1.1" date="05dec2019" author="thorsten.huck@hsbcad.com"> HSB-6131 stereotype dimensions added </version>
/// <version value="1.0" date="18nov2019" author="thorsten.huck@hsbcad.com"> HSB-5978 initial </version>
/// </History>

/// <insert Lang=en>
/// Select floor elements, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates markings on the top plates of any wall element which is connected to a floor element.
/// Markings are placed on the icon side of the wall.
/// The walls can be filtered by their exposed state (optional).
/// Joists with an extrusion profile can be filtered by the content of their information property (optional). 
/// If a joist filter is specified only joists containing this value are considered, else all profiled joists are taken.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbFloorToWallMarking")) TSLCONTENT
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
	String sWallFilterName=T("|Wall Filter|");	
	String sWallFilters[] ={T("|Any|"), T("|Exterior Walls|"), T("|Interior Walls|")};
	PropString sWallFilter(nStringIndex++, sWallFilters, sWallFilterName,1);	
	sWallFilter.setDescription(T("|Defines a filter of the walls based on their exposed state.|"));
	sWallFilter.setCategory(category);
	
	String sJoistFilterName=T("|Joist Filter|");	
	PropString sJoistFilter(nStringIndex++, "", sJoistFilterName);	
	sJoistFilter.setDescription(T("|Defines the Joist Filter.| ") + T("|Specify a text value which should be found in the information field of a potential joist.|"));
	sJoistFilter.setCategory(category);	
//End Properties//endregion 

//region onInsert
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
		
	// prompt for elements
		PrEntity ssE(T("|Select element(s)|"), ElementRoof());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());

	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;	Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1] ;
		Point3d ptsTsl[1];
		int nProps[]={};		double dProps[]={};		String sProps[]={sWallFilter,sJoistFilter};
		Map mapTsl;	
		String sScriptname = scriptName();

			
	// insert per element
		for(int i=0;i<_Element.length();i++)
		{
			entsTsl[0]= _Element[i];	
			ptsTsl[0]=_Element[i].ptOrg();
			
			tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			
			if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
		}


		eraseInstance();
		return;
	}	
//End onInsert//endregion 

//region All modes
	int nMode = _Map.getInt("mode");
	// 0 = distribution mode
	// 1 = floor element -> top plate marking mode
	// 2 = floor beam -> top plate marking mode
	
	int nWallFilter = sWallFilters.find(sWallFilter, 0);// 0 = any, 1 = exposed, 2 !=exposed
	
	String _sJoistFilter = sJoistFilter.trimLeft().trimRight().makeUpper();
	int bJoistFilter = _sJoistFilter.length()>0;
	
	
// validate and declare floor element
	ElementRoof el;
	ElementWall wall;
	for (int i=0;i<_Element.length();i++) 
	{ 
		if (!el.bIsValid())	el= (ElementRoof)_Element[i]; 
		else if (!wall.bIsValid())	wall= (ElementWall)_Element[i]; 
	}//next i
	
	if (_Element.length()<1 && nMode!=0)
	{
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
	
// get roof element if applicable
	CoordSys cs;
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg;
	PLine plEnvelope;
	PlaneProfile ppFloor;
	if (el.bIsValid())
	{ 
		cs = el.coordSys();
		vecX = cs.vecX();
		vecY = cs.vecY();
		vecZ = cs.vecZ();
		ptOrg = cs.ptOrg();

		plEnvelope = el.plEnvelope();plEnvelope.vis(132);
		ppFloor=PlaneProfile (cs);
		ppFloor.joinRing(plEnvelope, _kAdd);
	}

// get wall if applicable	
	CoordSys csWall;
	Vector3d vecXW, vecYW, vecZW;
	Point3d ptOrgW = wall.ptOrg();
	PLine plOutlineWall;
	PlaneProfile ppOutlineWall;
	if (wall.bIsValid())
	{ 
		csWall = wall.coordSys();
		vecXW = csWall.vecX();
		vecYW = csWall.vecY();
		vecZW = csWall.vecZ();
		ptOrgW = wall.ptOrg();		
		plOutlineWall= wall.plOutlineWall();
		ppOutlineWall=PlaneProfile(plOutlineWall);		
		assignToElementGroup(wall,true, 0,'E');// assign to element tool sublayer
	}
	
//region Remove Duplicates if not in distribution mode
	if (_Beam.length()>0 && wall.bIsValid() && nMode!=0)
	{ 
		TslInst tsls[] = wall.tslInstAttached();
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst& t=tsls[i];
			String s = t.scriptName();
			if (t.scriptName() != "hsbFloorToWallMarking")continue;//)scriptName()
			Map m = t.map();
			int _nMode = m.getInt("mode");
			if (_nMode != nMode)continue;
			
			Entity ents[] = t.entity();
			if (_nMode == 1 && ents.find(el) < 0){continue;}
			else if (_nMode == 2 && ents.find(wall) <0){continue;}	
			
			Beam beams[] = t.beam();
			if (beams.length()>0 && beams.find(_Beam[0])>-1 && _ThisInst!=t)
			{ 
				if (!bDebug)
				{
					eraseInstance();
					return;
				}
			}
		}//next i	
	}
//End Remove Duplicates if not in distribution mode//endregion 	
	
	

// Display and marking locations
	Display dp(4);
	Point3d ptMarks[0];
	Map mapRequests; 
//End  general mode//endregion 
		
//region Mode 0: Distribution
	if (nMode==0)
	{ 
	
	// get steel joists of floor
		Beam joists[0];
		if (el.bIsValid())
		{
			joists= vecZ.filterBeamsPerpendicularSort(el.beam());	
			
			Group grFloor = el.elementGroup();
			//String floorName = grFloor.namePart(0) + "\\" + grFloor.namePart(1);
			grFloor=Group(grFloor.namePart(0)); //+ "\\" + grFloor.namePart(1));
			Entity ents[] = grFloor.collectEntities(true, Beam(), _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				Beam b = (Beam)ents[i]; 
				if (joists.find(b)<0 && b.information().find(_sJoistFilter,0,false)>-1)
				{
					b.envelopeBody(true,true).vis(2);
					joists.append(b);
				}
				 
			}//next i
			
		}
			
	// Filter steel joists	
		for (int i=joists.length()-1; i>=0 ; i--) 
		{ 
			
			String extrProf = joists[i].extrProfile();
			String sInfo = joists[i].information().makeUpper();
			
			if(joists[i].myZoneIndex()!=0 ||
				extrProf==_kExtrProfRound || 
				extrProf==_kExtrProfRectangular ||
				(bJoistFilter && sInfo.find(_sJoistFilter,0,false)<0))
				joists.removeAt(i);	
			else
			{
				joists[i].envelopeBody(true,true).vis(2);
			}
		}//next i

	// collect all wall elements intersecting this
		Entity ents[] = Group().collectEntities(true, ElementWall(), _kModelSpace);
		
	// ignore any wall not intersecting the outline of the floor element
		for (int i=0;i<ents.length();i++) 
		{ 
		// validate type
			ElementWall wall = (ElementWall)ents[i];
			if (!wall.bIsValid()) continue;
			Vector3d vecXW = wall.vecX();
			Vector3d vecYW = wall.vecY();
			Vector3d vecZW = wall.vecZ();
			CoordSys csWall = wall.coordSys();
			Point3d ptOrgW = wall.ptOrg();
		// validate exposed
			if ((wall.exposed() && nWallFilter == 2) || ( ! wall.exposed() && nWallFilter == 1))continue;
		
		// validate intersection
			PLine plOutlineWall = wall.plOutlineWall();
			PlaneProfile ppOutlineWall(plOutlineWall);
			PlaneProfile _ppFloor = ppFloor;
			_ppFloor.intersectWith(PlaneProfile(plOutlineWall));
			if (_ppFloor.area() < pow(dEps, 2))continue;
			
			PLine plOutlineWallProj = plOutlineWall;
			plOutlineWallProj.projectPointsToPlane(Plane(ptOrg, vecZ), vecZ);
			
			plOutlineWallProj.vis(2);
			
		// validate vertical range
			LineSeg seg = wall.segmentMinMax();
			Point3d ptTop = seg.ptEnd();
			double dDist = vecYW.dotProduct(ptOrg - ptTop);
			if (dDist > U(500) || dDist < 0)continue; // version value="1.6" date="13may2020" author="thorsten.huck@hsbcad.com"> HSB-7585 bugfix filter wall elements
			seg.vis(i);
			
		// get top plates of wall
			PlaneProfile pp(csWall);
			Beam plates[] = vecYW.filterBeamsPerpendicularSort(wall.beam());
			for (int j=plates.length()-1; j>=0 ; j--) 
			{ 
				Beam& b = plates[j]; 
				
			// exclude any profile beam
				if (b.extrProfile()!=_kExtrProfRectangular)
				{ 
					plates.removeAt(j);
					continue;				
				}
				PLine pl(vecZW);
				Point3d pt = b.ptCen() + vecYW * .5 * b.dD(vecYW);
				pt += vecYW * vecYW.dotProduct(ptOrgW - pt);
				double dX = b.solidLength() * .5;
				pl.createRectangle(LineSeg(pt-vecXW*dX, pt+vecXW*dX+vecYW*U(10e4)),vecXW, vecYW);				//pl.vis(j);

				PlaneProfile _pp(csWall);
				_pp.joinRing(pl, _kAdd);
				
				double area = pp.area();
				if (area<pow(dEps,2))
					pp.joinRing(pl, _kAdd);
				else
				{ 
					_pp.unionWith(pp);//					_pp.vis(1);
					if (_pp.area()>area+pow(dEps,2))
						pp.joinRing(pl, _kAdd);
					else
					{
						plates.removeAt(j);
						continue;
					}
				}
				b.envelopeBody().vis(j);	
			}//next j		
			
			//pp.vis(i);
			
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {el, wall};	Point3d ptsTsl[1];// = {};
			int nProps[]={};			double dProps[]={};				String sProps[]={sWallFilter,sJoistFilter};
			Map mapTsl;	

		// Create single instances for each plate
			for (int j=0;j<plates.length();j++) 
			{ 
				Beam& plate= plates[j]; 
				Point3d ptCenP = plate.ptCen();
				Plane pnMark(ptCenP + vecZW * .5 * plate.dD(vecZW), plate.vecD(vecZW));
				
				PlaneProfile pp2 = plate.envelopeBody(true, true).shadowProfile(Plane(ptCenP,vecYW));		
				
			//region // joist/plate connection
				mapTsl.setInt("mode", 2);				
				for (int k=0;k<joists.length();k++) 
				{ 
					Beam& joist= joists[k]; 
					Point3d ptCenJ = joist.ptCen();
					Plane pn(ptCenJ, vecYW);
					PlaneProfile ppJ = joist.envelopeBody(true, true).shadowProfile(pn);

					ppJ.intersectWith(pp2);
					if (ppJ.area()>pow(dEps,2))
					{ 
						for (int lr=0;lr<2;lr++) 
						{ 
							Point3d pt=ptCenJ+joist.vecD((lr==0?-1:1)*vecXW)*.5*joist.dD(vecXW);
							if (Line(pt, joist.vecX()).hasIntersection(pnMark, pt))
							{ 
								if (bDebug)
									pt.vis(lr);
								else
								{
									gbsTsl.setLength(0);
									gbsTsl.append(joist);
									gbsTsl.append(plate);
									ptsTsl[0] = pt;
									tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
									break; // one instance serves all markings derived from the joist
								}
							}	 
						}//next lr
						//pnMark.vis(2);
					}	 				
				}//next k					
			//End // joist/plate connection//endregion 

				
			//region floor element/plate connection
				mapTsl.setInt("mode", 1);

		
				Point3d vertices[] = plEnvelope.intersectPLine(plOutlineWallProj); // HSB-12665
				for (int k=vertices.length()-1; k>=0 ; k--) 
				{ 
					Point3d pt= vertices[k]; 
					if (!Line(pt, vecZW).hasIntersection(pnMark, pt))
						vertices.removeAt(k); 
					else
						vertices[k] = pt;
				}//next k

				
				
				//= ppFloor.getGripVertexPoints();
				for (int k=0;k<vertices.length();k++) 
				{ 
					Point3d pt= vertices[k]; 
					if (ppOutlineWall.pointInProfile(pt) == _kPointOutsideProfile)continue;
					ppOutlineWall.vis(i);
					if (bDebug)
					{
						pt.vis(k);	
						break;
					}
					else
					{
						gbsTsl.setLength(0);
						gbsTsl.append(plate);
						ptsTsl[0] = pt;
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						break; // one instance serves all markings derived from the floor envelope
					}				
				}//next k	
			//End floor element/plate connection//endregion 
			}//next j
		}//next i
		if(!bDebug)eraseInstance();
		return;
	}
//End Mode 0: Distribution//endregion 	
	
//region Mode 1: floor to plate connection
	else if (nMode==1)
	{ 
		_Pt0.vis(nMode);
		
		if (_Beam.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + ": "+T("|Invalid beam reference.| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		Beam plate = _Beam[0];

		Point3d ptCenP = plate.ptCen();
		Plane pnPlate(ptCenP, vecYW);
		PlaneProfile ppPlate = plate.envelopeBody(false, true).shadowProfile(pnPlate);
		Plane pnMark(ptCenP + vecZW * .5 * plate.dD(vecZW), plate.vecD(vecZW));

		plEnvelope.projectPointsToPlane(pnPlate, vecYW);
		PLine rings[] = ppPlate.allRings(true, false);//HSB-12665
		Point3d vertices[0];
		for (int r=0;r<rings.length();r++) 
			vertices.append(rings[r].intersectPLine(plEnvelope)); 


		Point3d ptsDim[0];		
		for (int k = 0; k < vertices.length(); k++)
		{
			Point3d pt = vertices[k];
			if (ppOutlineWall.pointInProfile(pt) == _kPointOutsideProfile)continue;
			ppOutlineWall.vis(4);
			if (Line(pt, vecZW).hasIntersection(pnMark, pt))
			{
				LineSeg segs[] = ppPlate.splitSegments(LineSeg(pt - vecZW * U(10e4), pt + vecZW * U(10e4)), true);
				if (segs.length() < 1)continue;
				ptsDim.append(pt);
			}
		}
		
	// append dim requests
		ptsDim = Line(_Pt0, vecXW).orderPoints(ptsDim, dEps);
		Point3d ptMid;ptMid.setToAverage(ptsDim);
		if (ptsDim.length()==1)
		{
			Point3d pt = plEnvelope.closestPointTo(ptsDim.first());// ptsDim.first(); // HSB-7693
			PlaneProfile ppEnvelope(plEnvelope);
			PlaneProfile ppRect; ppRect.createRectangle(LineSeg(pt - vecXW * U(10e4), pt + vecXW * U(10e4) - vecZW * dEps), vecXW, - vecZW);
			ppRect.intersectWith(ppEnvelope);
			//ppRect.vis(3);
			ptMid = ppRect.extentInDir(vecXW).ptMid();
		}
		for (int k=0;k<ptsDim.length();k++) 
		{ 
			Point3d pt = ptsDim[k]; 
			pt.vis(3);	
			Mark mrk( pt, vecZW);
			plate.addTool(mrk);
			ptMarks.append(pt);
			dp.draw(PLine(pt, pt + vecYW * .5 * plate.dD(vecYW)));
			
		// add text request
			int nDir = (vecXW.dotProduct(pt - ptMid) > 0 ? -1 : 1);
			Map mapRequest;
			String text = el.number();
			if (text.left(3) == "EG_" || text.left(3) == "DG_") text = text.right(text.length() - 3);
	
			mapRequest.setString("text",text);
			mapRequest.setString("Stereotype",scriptName());
			mapRequest.setVector3d("AllowedView", vecZW);
			mapRequest.setVector3d("vecX", vecXW);
			mapRequest.setVector3d("vecY", vecYW);
			mapRequest.setPoint3d("ptLocation", pt+vecXW*nDir*U(120));
			mapRequest.setInt("ProjectToDimline", true);
			mapRequest.setInt("AlsoReverseDirection", false);				
			mapRequest.setDouble("dXFlag",nDir);
			mapRequest.setDouble("dYFlag", 1);
			mapRequests.appendMap("DimRequest", mapRequest);
			
		// debug
			if (bDebug)
			{ 
				Display dp(40);
				dp.textHeight(U(100));
				dp.draw(text, mapRequest.getPoint3d("ptLocation"), vecXW, vecYW, nDir, 1);
			}

		}//next k	
	}
//End Mode 1: floor to plate connection//endregion 	

//region Mode 2: joist to plate connection
	else if (nMode==2)
	{ 
		
		_Pt0.vis(nMode);
		if (_Beam.length()<2)
		{ 
			reportMessage("\n"+ scriptName() + ": "+T("|Invalid beam reference.| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		
		
	// the joist	
		Beam joist = _Beam[0];
		dp.color(joist.color());
		Point3d ptCenJ = joist.ptCen();
		Vector3d vecXJ = joist.vecX();
		
	// the plate	
		Beam plate = _Beam[1];
		Point3d ptCenP = plate.ptCen();		
		Plane pnMark(ptCenP + vecZW * .5 * plate.dD(vecZW), plate.vecD(vecZW));
		Plane pnPlate(ptCenP, vecYW);
		
	// validate projection
		PlaneProfile ppJ = joist.envelopeBody(false, true).shadowProfile(Plane(ptCenP, vecYW));
		ppJ.intersectWith(ppOutlineWall);
		if (ppJ.area()<pow(dEps,2))
		{ 
			reportMessage("\n"+ scriptName() + ": "+  T("|No intersection found between| ") + el.number() + " & " +joist.posnum()+  T(" |Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		ppJ.vis(6);

	

	// collect markings left and right
		Point3d pts[0];
		for (int lr=0;lr<2;lr++) 
		{ 
			Point3d pt=ptCenJ+joist.vecD((lr==0?-1:1)*vecXW)*.5*joist.dD(vecXW);
			Line(pt, vecYW).hasIntersection(pnPlate, pt);
			pts.append(pt);
			if (Line(pt, joist.vecX()).hasIntersection(pnMark, pt))
			{ 
				Mark mrk( pt, vecZW);
				plate.addTool(mrk);
				ptMarks.append(pt);
				dp.draw(PLine(pt, pt + vecYW * .5 * plate.dD(vecYW)));
			}	 
		}//next lr	
		
	// add text request
		Point3d ptLoc; ptLoc.setToAverage(pts);
		Map mapRequest;
		mapRequest.setString("text",joist.name());
		mapRequest.setString("Stereotype",scriptName());
		mapRequest.setVector3d("AllowedView", vecZW);
		mapRequest.setVector3d("vecX", vecXW);
		mapRequest.setVector3d("vecY", vecYW);
		mapRequest.setPoint3d("ptLocation", ptLoc);
		mapRequest.setInt("ProjectToDimline", true);
		mapRequest.setInt("AlsoReverseDirection", false);				
		mapRequest.setDouble("dXFlag",0);
		mapRequest.setDouble("dYFlag", 1);
		mapRequests.appendMap("DimRequest", mapRequest);		
		
		
	}
//End Mode 2: joist to plate connection//endregion 

//region All modes: cleanup or publishing
	if (ptMarks.length()>0)
	{ 
		_Pt0 = ptMarks[0];
		
	// declare dim request map for shopdrawings
		Map mapRequest;
		mapRequest.setString("DimRequestPoint","DimRequestPoint");
		mapRequest.setString("Stereotype",scriptName());
		mapRequest.setVector3d("AllowedView", vecZW);
		mapRequest.setVector3d("vecDimLineDir", vecXW);
		mapRequest.setVector3d("vecPerpDimLineDir", vecYW);
		mapRequest.setVector3d("AllowedView", vecZW);
		mapRequest.setPoint3dArray("Node[]", ptMarks);
		mapRequest.setInt("AlsoReverseDirection", true);
		mapRequests.appendMap("DimRequest", mapRequest);

	}
	else
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no marks could be found| ") + el.number());
		if (!bDebug)eraseInstance();
		return;
	}
	
	if (mapRequests.length()>0)
	{ 
		Map mapDimInfo;
		mapDimInfo.setMap("DimRequest[]", mapRequests);		
		_ThisInst.setSubMapX("Hsb_DimensionInfo", mapDimInfo);			
	}	
//End Mode 1 + 2: cleanup or publishing//endregion 

//region Special
	if (projectSpecial().makeUpper().find("Lux",0, false)>-1 && wall.bIsValid())
	{ 
		Map mapItem;	
		mapItem.setInt("Quantity",ptMarks.length());		
		ElemItem item(0,"Deckenmarkierung",_Pt0,wall.vecX(),mapItem);
		item.setShow(_kNo);
		wall.addTool(item);
		exportWithElementDxa(wall);		
	}
//End Special//endregion 

#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@```4X```$I"`(```!SP%S<````"7!(67,```[$
M```.Q`&5*PX;```$ATE$051XG.W=3:[24`"`43&LQ6V\53AW)TUWXMQ5L`S=
M#`Z8&*,^Z`^W\ITS(B'<7)I^O12:<KI>KQ^`5_=Q]`2`9Y`Z)$@=$J0."5*'
M!*E#@M0A0>J0('5(D#HD2!T2I`X)4H<$J4."U"%!ZI`@=4B0.B2<3Z-G`/^[
M>^[9-CPTJSILX'*Y+'CJF:0."5*'!*E#PGG]7>#G>=Y@(KRT:9I&3V&PX7^W
M8%6'!*E#@M0A0>J0('5(D#HD2!T2SNN'>-6?3)]_O<"K;DF.8(/47]5OX>U1
MOK9Y&JG?ZY;E5L&+G">3^F/6!R]RAO"UW!*+<]4YHTA]H6F:'NU6YPPD]2?1
M.6-)?94[`]8YPTE]K7<SUCE'(/4-B)GCD_J^'`4X"*E#@M2W\<?5VY+.<4@=
M$J0."5*'!*EOQIDY1R9U2)`Z)$@=$J0."5*'!*E#@M0A0>J0('5(D#HD2!T2
MI`X)4H<$J4."U"%!ZI`@=4B0.B1('1*D#@E2AP2I0X+4(4'JD"!U2)`Z)$@=
M$J0."5*'!*E#@M0A0>J0('5(D#HD2!T2I`X)4H<$J4."U"%!ZI`@=4B0.B1(
M'1*D#@E2AP2I0X+4(4'JD"!U2)`Z)$@=$J0."5*'!*E#@M0A0>J0('5(D#HD
M2!T2I`X)4H<$J4."U"%!ZI`@=4B0.B1('1*D#@E2AP2I0X+4(4'JD"!U2)`Z
M)$@=$J0."5*'!*E#@M0A0>J0('5(D#HD2!T2I`X)4H<$J4."U"%!ZI`@=4B0
M.B1('1*D#@E2AP2I0X+4(4'JFYGG>?04X*^D#@E2AP2I0X+4=^3LG>.0^C94
MS<%)?5\.`1R$U#>@9XY/ZFN]V[D#`4<@]6=0.\-)?97[&U8[8TE]N4?K53L#
M27V)>9Z7=:MV1I'ZPU;FJG:&.(^>P/]DJTIOXTS3M,EH<`^IOV._1?C7D67/
MWE:E?KE<WM[>?")=[^6WX31-M[UE]$2ZG*M#@M0A0>J0('5(D#HD2!T2I`X)
M&UQ"X_(/.#ZK.B1('1*D#@E2AP2I0X+4(4'JD"!U2)`Z)$@=$J0."5*'!*E#
M@M0A0>J0('5(D#HD2!T2I`X)4H<$J4."U"%!ZI`@=4B0.B1('1*D#@E2AP2I
M0X+4(4'JD"!U2)`Z)$@=$J0."5*'!*E#@M0A0>J0('5(D#HD2!T2I`X)4H<$
MJ4."U"'A]/WKYV6O_/3EV^W!CZ4CT/':>\L_WMUQWKA5'1*D#@E2AP2I0X+4
M(4'JD"!U2)`Z)$@=$J0."5*'!*E#@M0A0>J0('5(D#HD2!T2I`X)4H<$J4."
MU"%!ZI`@=4B0.B1('1*D#@E2AP2I0X+4(4'JD"!U2)`Z)$@=$J0."5*'!*E#
M@M0A0>J0('5(D#HD2!T2I`X)4H<$J4."U"%!ZI`@=4B0.B1('1*D#@E2AP2I
M0X+4(4'JD"!U2)`Z)$@=$J0."5*'!*E#@M0A0>J0('5(D#HD2!T2I`X)4H<$
MJ4."U"%!ZI`@=4@X7:_7T7,`=F=5AP2I0X+4(4'JD"!U2)`Z)$@=$J0."5*'
6A)\U@G>Q?=S!1`````!)14Y$KD)@@@``








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
        <int nm="BreakPoint" vl="479" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23173 The explanation of the wall filter has been made more descriptive." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/12/2024 9:23:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12665 floor / wall intersections corrected for walls not intersecting the floor envelope vertices" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="7/22/2021 10:32:05 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End