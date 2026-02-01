#Version 8
#BeginDescription
version value="1.0" - Initial version date="5may20" author="david.delombaerde@hsbcad.com"
version value="1.1" - changed the defintion of the contour polyline for a curved beam, from a ShadowProfile to a CurvedStyle="14jul20" author="david.delombaerde@hsbcad.com"
version value="1.2" - path option gives error when segment is too small. Small segments are now being skipped while creating the path. ="23jul20 Author="david.delombaerde@hsbcad.com"
version value="1.3" - Changed the way the propellertool was defined from segments to working with the complete contour. ="03aug20" author="david.delombaerde@hsbcad.com"

Description:
Set the properties and select a beam. When user picks path as insertion mode, the user will need to pick two points on the beam and the direction of the path.
When the user has selected the circumference as insertion mode, the fillet will be drawn around the circumference of the beam. 
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="5may20" author="david.delombaerde@hsbcad.com"> initial version </version>
/// <version value="1.1" - changed the defintion of the contour polyline for a curved beam, from a ShadowProfile to a CurvedStyle="14jul20" author="david.delombaerde@hsbcad.com"</versions>
/// <version value="1.2" - path option gives error when segment is too small. Small segments are now being skipped while creating the path. ="23jul20" author="david.delombaerde@hsbcad.com"</versions>
/// <version value="1.3" - Changed the way the propellertool was defined from segments to working with the complete contour ="03aug20" author="david.delombaerde@hsbcad.com"</versions>
/// </History>

/// <insert Lang=en>
/// Set the properties and select a beam. When user picks path as insertion mode, the user will need to pick two points on the beam and the direction of the path.
/// When the user has selected the circumference as insertion mode, the fillet will be drawn around the circumference of the beam. 
/// </insert>

/// <summary Lang=en>
/// This tsl creates a fillet around the circumference of a beam or along a path selected by the user.
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbFillet")) TSLCONTENT

//endregion
	
//region constants 

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
	
//end constants//endregion

//region properties

	// Set the insertion mode
	String sModeName="(A)   "+T("|Insertion Mode|");
	String sModes[] = {T("|Circumference|"), T("|Path|")};// T("|Openings|"), T("|Contour|") + " & " + T("|Openings|")
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the Mode|"));
	sMode.setCategory(category);
	
	// Set the alignment side
	String sAlignmentName="(B)   "+T("|Alignment|");	
	String sAlignments[] = {T("|Reference Side|"), T("|Opposite Side|"), T("|Both Sides|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	
	// Set the distance of the filet
	String sFiletName ="(C)  "+ T("|Depth|");
	PropDouble dFilet(nDoubleIndex++, U(4), sFiletName);
	sAlignment.setDescription(T("|Defines the Depth|"));
	dFilet.setCategory(category);
	
	// Tool Settings
	category = T("|Tool Settings|");
	
	String sToolIndexName=T("|ToolIndex|");		
	PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);	
	nToolIndex.setDescription(T("|Defines the ToolIndex|"));
	nToolIndex.setCategory(category);
		
	// Set the tool radius
	String sToolRadiusName=T("|Radius|");	
	PropDouble dToolRadius(nDoubleIndex++, U(80), sToolRadiusName);	
	dToolRadius.setDescription(T("|Defines the tool radius|"));
	dToolRadius.setCategory(category);
		
//End properties//endregion 

// bOnInsert//region

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
		
		// Set alignment from selection dialog
		int nAlignment = sAlignments.find(sAlignment,0);
		// Set different colors for each type of alignment
		int nColor = (nAlignment == 1 ? 4 : 3);
		// Set mode from selection dialog
		int nMode = sModes.find(sMode);
		
		// prompt user for selection beams
		PrEntity ssE(T("|Select beam(s)|"), Beam());
		
		// validation of selection & set collection
		if(ssE.go())
			_Beam = ssE.beamSet();		
		
		// create TSL
		TslInst tslNew;					GenBeam gbsTsl[1];						Entity entsTsl[] = { };
		Point3d ptsTsl[1];				int nProps[] ={nToolIndex };				double dProps[] = { dFilet, dToolRadius}; //dAccuracy
		String sProps[1];				Map mapTsl;							String sScriptname = scriptName();
			
		// Selection mode = Circumference
		if (nMode == 0)
		{ 
			// distribute tsl instances
			for (int i=0;i<_Beam.length();i++) 
			{ 
				ptsTsl.setLength(0);
				gbsTsl.setLength(0);
				sProps.append(sAlignment);
				
				Beam beam = _Beam[i]; 	
				ptsTsl.append(_Beam[i].ptCen());
				gbsTsl.append(_Beam[i]);
												
				tslNew.dbCreate(scriptName() , _Beam[i].vecX() ,_Beam[i].vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
				
			}//next i
			
		}
		// Selection mode = Path
		else if(nMode == 1)
		{ 
			// set instance on the first beam
			Beam beam = _Beam[0];
			Vector3d vecX = beam.vecX();
			Vector3d vecY = beam.vecZ();
			Vector3d vecZ = beam.vecY();			
			Point3d ptCen = beam.ptCenSolid();
			double dZ = beam.dD(vecZ);
			CoordSys cs(ptCen - vecY * .5 * dZ, vecX, vecY, vecZ);
				
			// get realbody of beam instance
			Body bd = beam.realBody();
			//Body bd = beam.envelopeBody();
			// get planeprofiel of real body
			PlaneProfile ppShadow = bd.shadowProfile(Plane(ptCen - vecZ * .5 * dZ, vecZ));	
			// get all the rings from the plane profile not including openings
			PLine rings[] = ppShadow.allRings(true, false);
			
			int bIsCurvedBeam = true;
			// Get closedcurve from curvedbeam
			if(beam.curvedStyle() == _kStraight)
				bIsCurvedBeam = false;
				
			CoordSys csBm = beam.coordSys();
			Point3d ptBmRef = beam.ptRef();			
			PLine plClosedCurve;
			
			if(bIsCurvedBeam)
			{ 
				// Get CurvedStyle from beam
				CurvedStyle thisCurvedStyle(beam.curvedStyle());
				// Close the CurvedStyle
				plClosedCurve = thisCurvedStyle.closedCurve();		
				
				// Set position of PLine on center beam
				CoordSys csToBm;
				csToBm.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptBmRef, vecX, vecY, - vecZ);		
				plClosedCurve.transformBy(csToBm);		
				
				// Position the PLine on the top plane of the beam reference side
				Vector3d vecTranslation = vecZ * .5 * dZ;		
				plClosedCurve.transformBy(-vecTranslation);		
			}
				
			// prompt user to select first point on beam
			_Pt0 = getPoint(TN("|Select first point on beam|"));
			_Pt0.transformBy(vecZ * vecZ.dotProduct(ptCen - _Pt0));
			
			PLine plRing;
			
			if(bIsCurvedBeam > 0)
			{ 
				PlaneProfile pp(plClosedCurve);	
				ppShadow.shrink(-U(.1));	
				pp.intersectWith(ppShadow);	
				PLine plines[] = pp.allRings();	
				plRing = plines.first();
			}
			else
			{ 
				plRing = rings.first();
			}
				
			if(plRing.length() > 0)
				_Pt0 = plRing.closestPointTo(_Pt0);		
			else
			{
				reportMessage("\n" + scriptName() + ": " +T("|Unexpected error.|"));
				eraseInstance();
				return;
			}

			Point3d ptLast = _Pt0;
			// prompt user to select second point on the same ring	
			PrPoint ssP("\n" + T("|Select next point on same ring|"), _Pt0);
				
			if(ssP.go() == _kOk)
			{
				// do the actual query
				ptLast = ssP.value();	 //  retrieve the selected point
				ptLast.transformBy(vecZ * vecZ.dotProduct(_Pt0 - ptLast));
				ptLast = plRing.closestPointTo(ptLast);
				// append the selected points to the list of grippoints _PtG
				_PtG.append(ptLast);
			}
			else
			{
				eraseInstance();
				return;
			}	
			
			// get distAt
			Point3d ptsPick[] = { _Pt0, _PtG[0]};
			double dDists[] = { plRing.getDistAtPoint(_Pt0), plRing.getDistAtPoint(_PtG[0])};
			if(dDists[0] > dDists[1])
			{ 
				dDists.swap(0, 1);
				ptsPick.swap(0, 1);
			}
			double dLength = plRing.length();
				
			// get vertices of ring
			Point3d pts[] = plRing.vertexPoints(true);
				
			// collect two plines: clockwise and counter clockwise contour tracking
			PLine plTracks[0];
				
			// Track clockwise
			Point3d ptsTrack[] = { ptsPick[0]};
			for (int i=0;i<pts.length();i++) 
			{ 
				Point3d pt = pts[i]; 
				double dDistAt = plRing.getDistAtPoint(pt);
				if(dDistAt < dDists[1] && dDistAt > dDists[0])
					ptsTrack.append(pt);
				else if(dDistAt >= dDists[1] && dDistAt > dDists[0])
				{ 
					ptsTrack.append(ptsPick[1]);
					break;
				}
			}//next i
				
			PLine pl(vecZ);
			for (int i=0;i<ptsTrack.length();i++) 
				pl.addVertex(ptsTrack[i]); 	
			plTracks.append(pl);
				
			// Track counter clockwise
			ptsTrack.setLength(0);
			ptsTrack.append(ptsPick[1]);
				
			// add points until end of pline	
			for (int i=0;i<pts.length();i++) 
			{ 
				double dDistAt = plRing.getDistAtPoint(pts[i]);
				if (dDistAt>dDists[1] && dDistAt<dLength)
					ptsTrack.append(pts[i]);
			}
				
			// add points until start	
			for (int i=0;i<pts.length();i++) 
			{ 
				double dDistAt = plRing.getDistAtPoint(pts[i]);
				if (dDistAt<dDists[0] && dDists[0]>dEps)
					ptsTrack.append(pts[i]);
				else if (dDistAt>=dDists[0] || dDists[0]<dEps)
				{
					ptsTrack.append(ptsPick[0]);
					break;
				}	
			}
			
			pl=PLine(vecZ);
			for (int i=0;i<ptsTrack.length();i++)
				pl.addVertex(ptsTrack[i]);
			plTracks.append(pl);
			
			// start and end point coincide
			EntPLine epl;
			if (Vector3d(ptsPick[0]-ptsPick[1]).length()<dEps)
			{
				epl.dbCreate(plRing);
				epl.setColor(nColor);
			}
			// prompt to swap direction of tracked path	
			else
			{ 
				int bSwap = true;
				while(bSwap)
				{
					if (epl.bIsValid())
						epl.dbErase();
					epl.dbCreate(plTracks[0]);
					epl.setColor(nColor);
					String sInput = getString(T("|Enter to insert accept path or|")+ " " +"[" + T("|SwapDirection|")+"/" +  "]").makeUpper();
					if (sInput.length()>0 && sInput.left(1)==T("|SwapDirection|").makeUpper().left(1))
						plTracks.swap(0,1);
					else
						bSwap=false;
						
				}
			}
			
			// redefine polyline to match the curved contour
			Point3d ptsDef[] = plTracks[0].vertexPoints(true);
			PLine plFinished(vecZ);
			EntPLine eplFinished;
			
			if(bIsCurvedBeam)
			{ 
				for (int i = 0; i < ptsDef.length() - 1; i++)
			{ 
				Point3d pt1 = ptsDef[i]; 
				Point3d pt2 = ptsDef[i + 1];
				Point3d ptMid = (pt1 + pt2) / 2;
				
				if(plRing.isOn(ptMid))
				{ 
					plFinished.addVertex(pt1);
					plFinished.addVertex(pt2);			
				}
				else
				{
					// Get Radius
					double d1 = plRing.getDistAtPoint(pt1);
					double d2 = plRing.getDistAtPoint(pt2);
					PLine pl(vecZ);
					pl.addVertex(pt1);
					double dDistAt = (d1 + d2) / 2;
						
					Point3d ptX = plRing.getPointAtDist(dDistAt);
//					ptX.vis(5);
							
					Vector3d vecXS = pt2 - pt1;
					double s = vecXS.length();
					vecXS.normalize();
							
					Vector3d vecYH = ptX - ptMid;
					PLine (ptX, ptMid).vis(5);	
					double h = vecYH.length();
					vecYH.normalize();
							
					Vector3d vecYS = vecXS.crossProduct(-vecZ);
					int nDir = vecYS.dotProduct(vecYH) < 0 ? 1 :- 1;
							
					double r = (4 * pow(h, 2) + pow(s, 2)) / (8 * h); 
					double a = 2 * acos(1 - h / r); 
					double bulge = tan(nDir * a / 4);
					plFinished.addVertex(pt1);
					plFinished.addVertex(pt2, bulge);				
				}		
				
			}	
			
				eplFinished.dbCreate(plFinished);
				eplFinished.setColor(nColor);
			}
			else
			{ 
				eplFinished.dbCreate(plTracks[0]);
				eplFinished.setColor(nColor);
			}
			
			// create TSL
			TslInst tslNew;					GenBeam gbsTsl[1];				Entity entsTsl[1];
			Point3d ptsTsl[1];				int nProps[] ={nToolIndex};		double dProps[] = { dFilet, dToolRadius}; //dAccuracy
			String sProps[1];				Map mapTsl;					String sScriptname = scriptName();
			
			gbsTsl.append(beam);
			ptsTsl.append(beam.ptCen());
			entsTsl.append(eplFinished);
			sProps.append(sAlignment);
			tslNew.dbCreate(scriptName() ,beam.vecX() ,beam.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	

			epl.dbErase();
			
		}
		eraseInstance();
		return;
	}	
	
// end on insert	__________________//endregion

//region validate GenBeam collection

	if(_GenBeam.length() < 1)
	{ 
		eraseInstance();
		return;
	}
	
//End Validate GenBeam collection//endregion

//region calculate offset distance dA
	
	//region Setup to get Maximum tool depth
	
		// Create points for rectangle
		Point3d ptBLeft		= _Pt0;
		Point3d ptBRight 	= _Pt0 + dToolRadius * _XW ;
		Point3d ptTRight	= _Pt0 + dToolRadius * (_XW + _ZW);
		Point3d ptTLeft		= _Pt0 + dToolRadius *  _ZW;
		
		//Create Rectangle - Length sides = dToolRadius
		PLine plRec(_ZW);
		plRec.addVertex(ptBLeft);
		plRec.addVertex(ptBRight);
		plRec.addVertex(ptTRight);
		plRec.addVertex(ptTLeft);
		plRec.close();
		//plRec.vis(6);
			 
		// Add Diagonal rectangle
		PLine plDia(_ZW);
		plDia.addVertex(ptTRight);
		plDia.addVertex(ptBLeft);
		//plDia.vis(3);
		
		// Create Circle - Radius = dToolRadius
		PLine plCirc(_ZW);
		plCirc.createCircle(ptBLeft, _YW, dToolRadius);
			
		//  Get intersection between diagonal and circle
		Point3d ptIntersect[] = plDia.intersectPLine(plCirc);
		
		// Get length of segment this is the maximum depth value
		LineSeg seg(ptTRight, ptIntersect.first());
		double dMax = seg.length();
				
	//End Setup to get Maximum tool depth//endregion 
	
	//region Get dA distance
		
		// Get user distance to transform circle
		double dDist = dMax - dFilet;
		
		// Create vector along diagonal
		Vector3d vDia = ptTRight - ptBLeft;
		vDia.normalize();
		
		// Reposition the circle
		plCirc.transformBy(vDia * dDist);
		//plCirc.vis(150);
		
		// PLine to get horizontal intersection with circle
		PLine pldA(_ZW);
		pldA.addVertex(ptTRight);
		pldA.addVertex(ptTLeft);
		//pldA.vis(60);
		
		// Get intersection point with circle
		ptIntersect.setLength(0);
		ptIntersect = pldA.intersectPLine(plCirc);
		
		// dA value
		double dA;
		if(ptIntersect.length() < 1)
		{ 
			reportMessage(TN("|Depth of tool is not valid. Depth will be set to the maximum depth.|"));
			dFilet.set(dMax);
			dA = dToolRadius;
		}
		else
		{
			LineSeg segdA(ptTRight, ptIntersect.first());
			dA = segdA.length();
		}
		
	//End Get dA //endregion 
		
//End Calculate offset distance dA//endregion 

//region set standards
			
	Beam beam = (Beam)_GenBeam[0];
		
	CoordSys csBm = beam.coordSys();
	Point3d ptBmRef = beam.ptRef();
	Vector3d vxBm = csBm.vecX();
	Vector3d vyBm = csBm.vecY();
	Vector3d vzBm = csBm.vecZ();
	Point3d ptBmOrg = csBm.ptOrg();
		
	int bIsCurvedBeam = true;
	
	// Check if beam has curves in it
	if(beam.curvedStyle() == _kStraight)
		bIsCurvedBeam = false;
			
	PLine plClosedCurve;
	
	// Set dependency on beam length = when beam length changes the tsl gets recalculated
	setDependencyOnBeamLength(beam);
	
	 Vector3d vecX = beam.vecX(); Vector3d vecY = beam.vecZ(); Vector3d vecZ = beam.vecY();
	 Point3d ptCen = beam.ptCenSolid();	
	 double dZ = beam.dD(vecZ);
	 CoordSys cs (ptCen - vecZ * .5 * dZ, vecX, vecY, vecZ );
	
	if(bIsCurvedBeam)
	{ 
		// Get CurvedStyle from beam
		CurvedStyle thisCurvedStyle(beam.curvedStyle());
		// Close the CurvedStyle
		plClosedCurve = thisCurvedStyle.closedCurve();		
		
		// Set position of PLine on center beam
		CoordSys csToBm;
		csToBm.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptBmRef, vxBm, vzBm, - vyBm);		
		plClosedCurve.transformBy(csToBm);		
		
		// Position the PLine on the top plane of the beam reference side
		Vector3d vecTranslation = vecZ * .5 * dZ;		
		plClosedCurve.transformBy(-vecTranslation);		
		//plClosedCurve.vis(1);
	}
	
	_Pt0 = ptCen;
	
	// Create shadowprofile of beam on 1 side	
	Body bd = beam.realBody();
	//Body bd = beam.envelopeBody();
	PlaneProfile ppShadow = bd.shadowProfile(Plane(ptCen - vecZ * .5 * dZ, vecZ));
	PLine rings[] = ppShadow.allRings(true, false);
	
	int nAlignment = sAlignments.find(sAlignment);
	int nColor = (nAlignment == 1 ? 4 : 3);
	int nSide = nAlignment == 1 ? 1 :- 1;
		
//End Set Standards//endregion 

//region define PolyLine and Faces
		
	PLine plDefining;
	if (_Entity.length() < 1) 		// Circumference selected by user
	{ 
		if(bIsCurvedBeam > 0)
		{		
			PlaneProfile pp(plClosedCurve);	
			ppShadow.shrink(-U(.1));	
			pp.intersectWith(ppShadow);	
			PLine plines[] = pp.allRings();	
			plDefining = plines.first();					
		}
		else
		{ 
			plDefining = rings.first();	
		}		
	}
	else		// Path selected by user
	{	
		EntPLine epl;
		Point3d ptsArcs[0]; 
	
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity ent = _Entity[i]; 			
			if (ent.bIsKindOf(EntPLine()))
			{

				if(bIsCurvedBeam > 0)
				{ 
					// contour of the beam with right curve
					PlaneProfile pp(plClosedCurve);	
					ppShadow.shrink(-U(.1));	
					pp.intersectWith(ppShadow);	
					PLine plines[] = pp.allRings();
					PLine plAnalyze = plines.first();
//					plAnalyze.vis(5);
					
					epl = (EntPLine)ent;
					PLine plPath = epl.getPLine();					
//					plPath.vis(30);
					
					// Need to rebuild plDefining
					Point3d ptsDef[] = plPath.vertexPoints(true);
					PLine plFinished(vecZ);
					
					for (int i=0; i<ptsDef.length() - 1; i++) 
					{ 
						Point3d pt1 = ptsDef[i]; 
						Point3d pt2 = ptsDef[i + 1];
						Point3d ptMid = (pt1 + pt2) / 2;
						
						if(plAnalyze.isOn(ptMid))
						{ 
							plFinished.addVertex(pt1);
							plFinished.addVertex(pt2);
							
						}
						else
						{ 
//							pt1.vis(1); ptMid.vis(1); pt2.vis(1);
							
							// Get Radius
							double d1 = plAnalyze.getDistAtPoint(pt1);
							double d2 = plAnalyze.getDistAtPoint(pt2);
							PLine pl(vecZ);
							pl.addVertex(pt1);
							double dDistAt = (d1 + d2) / 2;
							
							Point3d ptX = plAnalyze.getPointAtDist(dDistAt);
//							ptX.vis(5);
							
							Vector3d vecXS = pt2 - pt1;
							double s = vecXS.length();
							vecXS.normalize();
							
							Vector3d vecYH = ptX - ptMid;
							PLine (ptX, ptMid).vis(5);	
							double h = vecYH.length();
							vecYH.normalize();
							
							Vector3d vecYS = vecXS.crossProduct(-vecZ);
							int nDir = vecYS.dotProduct(vecYH) < 0 ? 1 :- 1;
							
							double r = (4 * pow(h, 2) + pow(s, 2)) / (8 * h); 
							double a = 2 * acos(1 - h / r); 
							double bulge = tan(nDir * a / 4);
							plFinished.addVertex(pt1);
							plFinished.addVertex(pt2, bulge);

						}
						 
					}//next i
					
//					plFinished.vis(1);
					plFinished.reverse();
					plDefining = plFinished;
					
				}
				else
				{ 
					epl = (EntPLine)ent;
					plDefining = epl.getPLine();	
				}
				
				bIsCurvedBeam = false;	
					
				//End Old code//endregion 			

			}		
		}//next i
	}
	//plDefining.vis(1);
	
	// Validate the defining polyline
	if(plDefining.length() < dEps)
	{ 
		reportMessage("\n" + scriptName() + ": " + T("auto erasing"));
		eraseEntity();
		return;	
	}
	
	// Specify the faces
	Plane pnFaces[0];
	if(nAlignment !=  1)
		pnFaces.append(Plane(ptCen - vecZ * .5 * dZ, - vecZ));
	if(nAlignment != 0)
		pnFaces.append(Plane(ptCen + vecZ * .5 * dZ, vecZ));

//End Define PolyLine//endregion 

//region loop through faces
	
	// Loop through the faces
	for (int f=0;f<pnFaces.length();f++) 
	{ 	
		//region setting up Filet SolidSubstract
		
		Plane pn = pnFaces[f]; 
		// Set standards
		vecX = pn.vecX(); vecY = pn.vecY(); vecZ = pn.vecZ();
		vecX.vis(ptCen, 1);  vecY.vis(ptCen, 3); vecZ.vis(ptCen, 150);
		
		// check if face is the reference face
		int bIsReferenceFace = beam.vecY().isCodirectionalTo(-vecZ);
				
		// set coordsys and get shadow profile of body
		CoordSys cs(pn.ptOrg(), vecX, vecY, vecZ);
		PlaneProfile ppFace = bd.shadowProfile(pn);		
				
		// set tool polyline, convert arc to lines
		// project polyline to plane
		PLine plTool = plDefining;	
				
		//plTool.convertToLineApprox(U(80));
		plTool.convertToLineApprox(U(5));
		plTool.projectPointsToPlane(pn, vecZ);
		
		plDefining.projectPointsToPlane(pn, vecZ);
		
		// check if polyline is closed
		Point3d pts[] = plTool.vertexPoints(false);
		if (pts.length() < 2) continue;
		int bIsClosed = Vector3d(pts[0] - pts[pts.length() - 1]).length() < dEps;
		
		// declare display
		Display dp(vecZ.isCodirectionalTo(beam.vecY()) ? 4 : 3);
		dp.draw(plTool);
		
		//region Add the fillet body
				
			PLine plPath = plTool;
			Point3d ptsC[] = plPath.vertexPoints(true);
			Point3d ptStart = ptsC[0];
			Point3d ptSecond = ptsC[1];			
			Point3d ptMidC = (ptSecond + ptStart) / 2;			
			//ptMidC.vis(221);
			
			Vector3d vecZS = vecZ;
			Vector3d vecXS = plPath.getTangentAtPoint(ptMidC);			
			Vector3d vecYS = vecZS.crossProduct(vecXS);
			
			//vecXS.vis(ptMidC, 1);  vecYS.vis(ptMidC, 3); vecZS.vis(ptMidC, 150);
			
			//region Define polyline contour of body
				
				PLine plSosu(vecZS);				
				plSosu.addVertex(ptMidC);
				Point3d ptNext = ptMidC - dA * (vecYS + vecXS);
				plSosu.addVertex(ptNext, tan(22.5));
				ptNext -= vecXS * dA;
				plSosu.addVertex(ptNext);
				ptNext += vecYS * (2*dA);
				plSosu.addVertex(ptNext);		
				ptNext += vecXS * (2*dA);
				plSosu.addVertex(ptNext);	
				plSosu.close();	
				//plSosu.vis(1);
				CoordSys cs2 = plSosu.coordSys();
				//plSosu.vis(1);
				
			//End Define polyline contour of body//endregion 
										
			//region Set orientation of body
					
				// Check vecXS vs vecY
				double dcoodirectional = vecY.dotProduct(vecXS);
				if(bIsCurvedBeam)
				{ 
					if(bIsReferenceFace)
					{ 
						cs2.setToRotation(180, vecXS, ptMidC);
						plSosu.transformBy(cs2);
						cs2.setToRotation(90, vecYS, ptMidC);
						plSosu.transformBy(cs2);
						cs2.setToTranslation(dA * - vecZS);
						plSosu.transformBy(cs2);
					}
					else
					{ 
						cs2.setToRotation(90, vecYS, ptMidC);
						plSosu.transformBy(cs2);
						cs2.setToTranslation(dA * - vecZS);
						plSosu.transformBy(cs2);
					}
				}
				else
				{ 
					if(bIsReferenceFace)
					{ 
						cs2.setToRotation(90, vecYS, ptMidC);
						plSosu.transformBy(cs2);
						cs2.setToTranslation(dA * - vecZS);
						plSosu.transformBy(cs2);
					}
					else
					{
						cs2.setToRotation(180, vecXS, ptMidC);
						plSosu.transformBy(cs2);
						cs2.setToRotation(90, vecYS, ptMidC);
						plSosu.transformBy(cs2);
						cs2.setToTranslation(dA * - vecZS);
						plSosu.transformBy(cs2);
					}
				}
					
				//plSosu.vis(1);
					
			//End Set orientation of body//endregion 
					
			//region Split plPath in separate PLines and creation Sosu
					
				SolidSubtract sosus[0];
					
				if (bIsClosed) //Polyline is closed
				{
					PLine plPath1;						
					plPath1.addVertex(ptMidC);
						
					for (int i = 1; i < pts.length(); i++)
					{
						if (i != 1)
						{
							PLine plCheck;
							plCheck.addVertex(pts[i]);
							plCheck.addVertex(pts[i - 1]);
							
							if (plCheck.length() > 1)
							{ 
								plPath1.addVertex(pts[i]);	
							}
						}
						else
						{
							plPath1.addVertex(pts[i]);	
						}
					}
					
					PLine plPath2;
					plPath2.addVertex(ptMidC);
					plPath2.addVertex(pts[0]);
						
					// Create bodies
					Body bdSosu1(plSosu, plPath1, 16);
					//bdSosu1.vis(1);	
					Body bdSosu2(plSosu, plPath2, 16);
					//bdSosu2.vis(1);
						
					// Create SolidSubstract and add them to the collection
					SolidSubtract sosu1(bdSosu1, _kSubtract);
					sosus.append(sosu1);
					SolidSubtract sosu2(bdSosu2, _kSubtract);
					sosus.append(sosu2);
				}
				else // User has selected path on the beam
				{
						
					PLine plPath3;
					plPath3.addVertex(ptMidC);
						
					for(int i = 1; i < pts.length(); i++)
					{ 
							
						if (i != 1)
						{ 	 
							PLine plCheck;
							plCheck.addVertex(pts[i]);
							plCheck.addVertex(pts[i - 1]);
								
							if (plCheck.length() > 1)
							{ 
								plPath3.addVertex(pts[i]);	
							}				
						}
						else
						{
							plPath3.addVertex(pts[i]);	
						}
							
					}
						
					PLine plPath4;
					plPath4.addVertex(ptMidC);
					plPath4.addVertex(pts[0]);
																		
					Body bdSosu3(plSosu, plPath3, 16);
					if (bdSosu3.isNull())
						reportMessage(TN("|Error while creating SolidBody. SolidBody isNull|"));
							
					Body bdSosu4(plSosu, plPath4, 16);	
					if (bdSosu4.isNull())
						reportMessage(TN("|Error while creating SolidBody. SolidBody isNull|"));

					SolidSubtract sosu3(bdSosu3, _kSubtract);
					sosus.append(sosu3);
					
					SolidSubtract sosu4(bdSosu4, _kSubtract);
					sosus.append(sosu4);
				}	
															
				for (int s=0;s<sosus.length();s++) 
				{ 
					SolidSubtract sosu = sosus[s];
					beam.addTool(sosu);
					 
				}//next s
				
			//End Split plPath in separate PLines and creation Sosu//endregion 	
							
		//End add the fillet body//endregion 
		
		//End setting up Fillet Solidsubstract//endregion 
		
		//region prepare for Display
			
			// Set toolside
			int nSide = 1;
			{
				Point3d pt1 = pts[0];
				Point3d pt2 = pts[1];
								
				Point3d ptMid = (pt1 + pt2) / 2;
				Vector3d vecXP = pt2 - pt1;
				vecXP.normalize();
				Vector3d vecYP = vecXP.crossProduct(-vecY);
				vecYP.normalize();
						
				PlaneProfile ppTest = ppFace;
				if (ppTest.pointInProfile(ptMid) == _kPointOutsideProfile)
				{
					PLine pl;
					pl.createConvexHull(pn, ppFace.getGripVertexPoints());
					ppTest = PlaneProfile(cs);
					ppTest.joinRing(pl, _kAdd);
					ptMid = ppTest.closestPointTo(ptMid);
					//ptMid.vis(1);
				}
				else
					//ptMid.vis(3);
						
				if (ppTest.pointInProfile(ptMid + vecYP * dEps) == _kPointInProfile)
				{
					nSide = - 1;
					vecYP *= -1;
				}
				//vecYP.vis(ptMid, nSide);
			}
				
			LineSeg segs[0];		
			double dBulges[0];
			PLine plArcs[0];		
			PLine plines[0];
				
			// Get all segments from plTool
			for (int i=0; i<pts.length() - 1; i++) 
			{ 
				Point3d pt1 = pts[i]; 
				Point3d pt2 = pts[i + 1]; 
				Point3d ptMid = (pt1 + pt2) / 2;
						
				// collect straight segments
				PLine pl(pt1 , pt2);
				if(plTool.isOn(ptMid))
				{ 
					// segs.append(LineSeg(pt1, pt2));
					plines.append(pl);
				}
				else // is this needed when plTool is converted to PLine
				{ 
					double d1 = plTool.getDistAtPoint(pt1); //pt1.vis(1);
					
					 // pt1 coincides with ptStart
					if(d1 == plTool.length())
						d1 = 0;
							
					double d2 = plTool.getDistAtPoint(pt2); //pt2.vis(2);
					PLine pl(vecZ);
					pl.addVertex(pt1);
					double dDistAt = (d1 + d2) / 2;
							
					Point3d ptX = plTool.getPointAtDist(dDistAt); //ptX.vis(2);
							
					// get radius
					Point3d ptMid = (pt1 + pt2) / 2;
					Vector3d vecXS = pt2 - pt1;
					double s = vecXS.length();
					vecXS.normalize();
							
					Vector3d vecYH = ptX - ptMid;
					//PLine(ptX, ptMid).vis(5);
					double h = vecYH.length();
					vecYH.normalize();
							
					Vector3d vecYS = vecXS.crossProduct(-vecZ);
					int nDir = vecYS.dotProduct(vecYH) < 0 ? 1 :- 1;
							
					double r = (4 * pow(h, 2) + pow(s, 2)) / (8 * h);
					double a = 2 * acos(1 - h / r);
					double bulge = tan(nDir * a / 4);
					dBulges.append(bulge);
					pl.addVertex(pt1);
					pl.addVertex(pt2, bulge);
							
					plArcs.append(pl);
				}
						 
			}//next i
				
		//End prepare Display //endregion 		
		
		//region create PropellerSurfaceTool

			double dMaximumDeviation = 10 * dEps;
//			PlaneProfile ppInner = ppFace;
//			ppInner.shrink(dA);
//			PLine PLines[] = ppInner.allRings();
//			PLine plOffset = PLines.first();
//			plOffset.vis(5);
			
			if(beam.curvedStyle() == _kStraight)
			{ 
				// Create PropellerSurfaceTool			
				PLine pl2 = plDefining;
				pl2.transformBy(-vecZ * dA);
				//pl2.vis(5);
				
				PLine pl1 = plDefining;
				pl1.offset(dA);			
				//pl1.vis(5);
				
				PropellerSurfaceTool tt(pl1, pl2, U(40), dMaximumDeviation);
						
				if(bIsReferenceFace)
					tt.setMillSide(_kRight);
				else
					tt.setMillSide(_kLeft);
						
				tt.setCncMode(nToolIndex);
				tt.setDoSolid(false);
				beam.addTool(tt);
			}
			else
			{ 
				
				if(bIsClosed)
				{ 
					// Create PropellerSurfaceTool			
					PLine pl2 = plDefining;
					pl2.transformBy(-vecZ * dA);
					//pl2.vis(5);
					
					PLine pl1 = plDefining;
					pl1.offset(dA);			
					//pl1.vis(5);
					
					PropellerSurfaceTool tt(pl1, pl2, U(40), dMaximumDeviation);
							
					if(bIsReferenceFace)
						tt.setMillSide(_kRight);
					else
						tt.setMillSide(_kLeft);
							
					tt.setCncMode(nToolIndex);
					tt.setDoSolid(false);
					beam.addTool(tt);
				}
				else
				{	
					//region Old Way - Segmented Arc
						
						// Create PropellerSurfaceTool			
						PLine pl2 = plDefining;
						pl2.transformBy(-vecZ * dA);
						///pl2.vis(5);
						
						PLine pl1 = plDefining;
						pl1.offset(dA);			
						//pl1.vis(5);
						
						PropellerSurfaceTool tt(pl1, pl2, U(40), dMaximumDeviation);
								
						if(bIsReferenceFace)
							tt.setMillSide(_kRight);
						else
							tt.setMillSide(_kLeft);
								
						tt.setCncMode(nToolIndex);
						tt.setDoSolid(false);
						beam.addTool(tt);
					
					//End Old Way - Segmented Arc//endregion 
					
					//region New Way - Smooth Arc
						
//						// Project plClosedCurve to right plane		
//						plClosedCurve.projectPointsToPlane(pn, vecZ);
//						plClosedCurve.vis(5);
//						
//						// Collect points from arc(s) and use createSmoothArcsApproximation
//						// Collect plines for the straight segments
//						Point3d ptsDef[] = plTool.vertexPoints(true);
//						PLine plines[0];
//						Point3d ptSegments[0];
//						
//						for (int i=0; i<ptsDef.length() - 1; i++) 
//						{ 
//							Point3d pt1 = ptsDef[i]; 
//							Point3d pt2 = ptsDef[i + 1];
//							Point3d ptMid = (pt1 + pt2) / 2;
//							
//							if(!plClosedCurve.isOn(ptMid))
//							{ 
//								// This midpoint is not on plClosedCurve, this means that pt1 and pt2
//								// are a arc segment. We need to store those 2 points in collection
//								// together with the index.
//								ptSegments.append(pt1);
//								ptSegments.append(pt2);
//							}
//							else
//							{
//								// This is a straight segment create PLine and store it.
//								PLine pl(pt1, pt2);
//								plines.append(pl);															
//								
//							}
//							
//						}//next i
//					
//						PLine plArcs[0];
//						
//						// What about a beam with 2 arcs.
//						PLine plArc;
//						plArc.createSmoothArcsApproximation(pn, ptSegments, U(2));
//						plArcs.append(plArc);
//												
//						for (int i=0;i<plines.length();i++) 
//						{ 
//							PLine pl = plines[i]; 
//							
//							PLine pl2 = pl;
//							pl2.transformBy(-vecZ * dA);
//							pl2.vis(1);
//							
//							// Not always in the right direction...
//							PLine pl1 = pl;	
//							pl1.offset(dA);
//							pl1.vis(4);
//							
//						}//next i
//						
//						for (int i=0;i<plArcs.length();i++) 
//						{ 
//							PLine pl = plArcs[i]; 
//							
//							PLine pl2 = pl;
//							pl2.transformBy(-vecZ * dA);
//							pl2.vis(1);
//							
//							PLine pl1 = pl;
//							
//							if (bIsReferenceFace)
//							{ 
//								pl1.offset(-dA);	
//							}
//							else
//							{ 
//								pl1.offset(dA);
//							}
//							pl1.vis(4);
//							
//							
//						}//next i
						
						
					//End New Way - Smooth Arc//endregion 

				}
			}
					
		//End create PropellerSurfaceTool//endregion 
		
		//region create display
				
			for (int a=0; a<plines.length(); a++) 
			{ 
				PLine pl2 = plines[a]; 
				Point3d ptsA[] = pl2.vertexPoints(true);
				pl2.transformBy(-vecZ * dA);
				//pl2.vis(5);
				
				PLine pl1(vecZ);
				Point3d pt1 = ptsA[0];
				Point3d pt2 = ptsA[1];
				
				pt1.vis(1); pt2.vis(1);
				
				Point3d ptMid = (pt1 + pt2) / 2;
				Vector3d vecXT = pt2 - pt1;
				vecXT.normalize();
				Vector3d vecYT = vecXT.crossProduct(-vecZ);
				double dX = vecXT.dotProduct(pt2 - pt1);
	
				 // Draw PLine
				PLine plSym(vecXT);
					
				if(bIsCurvedBeam)
				{ 
					if(bIsReferenceFace)
					{ 												
						plSym.addVertex(pt1);
						Point3d ptNext = pt1 + dA * (vecYT);
						plSym.addVertex(ptNext);
						ptNext -= dA * (vecYT + vecZ);
						plSym.addVertex(ptNext , tan(22.5));
						plSym.close();			
					}
					else
					{		
						plSym.addVertex(pt1);
						Point3d ptNext = pt1 - dA * (vecYT);
						plSym.addVertex(ptNext);
						ptNext += dA * (vecYT - vecZ);
						plSym.addVertex(ptNext , tan(-22.5));
						plSym.close();	
					}
				}
				else
				{ 
					if (bIsReferenceFace)
					{ 
						plSym.addVertex(pt1);
						Point3d ptNext = pt1 - dA * (vecYT);
						plSym.addVertex(ptNext);
						ptNext += dA * (vecYT - vecZ);
						plSym.addVertex(ptNext , tan(-22.5));
						plSym.close();	
					}
					else
					{ 		
						plSym.addVertex(pt1);
						Point3d ptNext = pt1 + dA * (vecYT);
						plSym.addVertex(ptNext);
						ptNext -= dA * (vecYT + vecZ);
						plSym.addVertex(ptNext , tan(22.5));
						plSym.close();
					}
				}
						
				// Distribute
				PlaneProfile ppSym = Plane(ptMid, vecYT);
				ppSym = PlaneProfile(plSym);
					
				//ppSym.vis(6);
					
				if (dX > U(100))
				{
					int nNum = dX / U(1000);
					if (nNum < 3) nNum = 2;
					else if (nNum > 20) nNum = nNum * 4 / 6;
					
					if (nNum > 1)
					{
						double dDist = dX / nNum;
						Point3d ptX = pt1;
						for (int i = 0; i < nNum + 1; i++)
						{
							Point3d ptX2 = pt1 + vecXT * i * dDist;
							ppSym.transformBy(ptX2 - ptX);
							ptX = ptX2;
							dp.draw(ppSym, _kDrawFilled);
						}//next i
					}
				}	
			}//next a
		
		//End create display//endregion 
				
	}//next f
	
//End loop through faces//endregion 
#End
#BeginThumbnail
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
1H`(N(`,VH`,^(`3:5D```#L`

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
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End