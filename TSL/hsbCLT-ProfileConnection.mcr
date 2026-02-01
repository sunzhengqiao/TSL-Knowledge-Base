#Version 8
#BeginDescription
#Versions
Version 1.5 31.01.2024 HSB-21257 bugfix when facet offset <=0  , Author Thorsten Huck

version value="1.4" date="24.07.2019" author="marsel.nakuci@hsbcad.com" 

HSB-5411 Bug fix at calculation of vFacet1 and vFacet2
HSB-5411 Bug fix
HSBCAD-612 support multiple panels, connection will be created for all panels and the beam 
TSL display at middle of edges

This tsl creates connection between a steel beam and a panel
It creates connection only for 1 panel and 1 beam

Select beam and panel, enter properties or catalog entry and press OK
if more than 1 beam and 1 panel are selected, only the first will be 
considered in calculation
the normal vector of the plane of panel must be normal with the beam axis
Edges of the panel will be streched to the beam and the connection will be placed there
The edge with the mid point closer to the beam axis is selected as initial edge
All edges in the same line as the initial edge will be streched

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords panel, connection, beam, profile, HEA, IPE; U
#BeginContents
/// <History>//region
// #Versions
// 1.5 31.01.2024 HSB-21257 bugfix when facet offset <=0  , Author Thorsten Huck

/// <version value="1.4" date="24.07.2019" author="marsel.nakuci@hsbcad.com"> HSB-5411 Bug fix at calculation of vFacet1 and vFacet2  </version>
/// <version value="1.3" date="03.07.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-612 support multiple panels, connection will be created for all panels and the beam </version>
/// <version value="1.2" date="21.mar2019" author="marsel.nakuci@hsbcad.com"> TSL display at middle of edges </version>
/// <version value="1.1" date="21.mar2019" author="marsel.nakuci@hsbcad.com"> fix sugestions from Roman and Thorsten in HSBCAD-612 </version>
/// <version value="1.0" date="21.mar2019" author="marsel.nakuci@hsbcad.com"> initial version </version>
/// </History>

/// <insert Lang=en>
/// Select beam and panel, enter properties or catalog entry and press OK
/// if more than 1 beam and 1 panel are selected, only the first will be 
/// considered in calculation
/// the normal vector of the plane of panel must be normal with the beam axis
/// if the panel can not intersect the beam even after stretching, calculation not possible
/// Edges of the panel will be streched to the beam and the connection will be placed there
/// The edge with the mid point closer to the beam axis is selected as initial edge
/// All edges in the same line as the initial edge will be streched
/// </insert>

/// <summary Lang=en>
/// This tsl creates connection between a steel beam and a panel
/// It creates connection only for 1 panel and 1 beam
///
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	String category = T("|Gap values|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

//region Properties
	
	// Top Gap //
	String sGapTopVerticalName=T("|Top Vertical|");	
	PropDouble dGapTopVertical(nDoubleIndex++, U(10), sGapTopVerticalName);	
	dGapTopVertical.setDescription(T("|Defines the top vertical gap|"));
	dGapTopVertical.setCategory(category);
	
	String sGapTopHorizontalName=T("|Top Horizontal|");	
	PropDouble dGapTopHorizontal(nDoubleIndex++, U(10), sGapTopHorizontalName);	
	dGapTopHorizontal.setDescription(T("|Defines the top horizontal gap|"));
	dGapTopHorizontal.setCategory(category);
	
	// Bottom Gap //
	String sGapBottomVerticalName=T("|Bottom Vertical|");	
	PropDouble dGapBottomVertical(nDoubleIndex++, U(10), sGapBottomVerticalName);	
	dGapBottomVertical.setDescription(T("|Defines the bottom vertical gap|"));
	dGapBottomVertical.setCategory(category);
	
	String sGapBottomHorizontalName=T("|Bottom Horizontal|");	
	PropDouble dGapBottomHorizontal(nDoubleIndex++, U(0), sGapBottomHorizontalName);	
	dGapBottomHorizontal.setDescription(T("|Defines the bottom horizontal gap|"));
	dGapBottomHorizontal.setCategory(category);
	
	// main vertical Gap //
	String sGapMainVerticalName=T("|Main Vertical|");	
	PropDouble dGapMainVertical(nDoubleIndex++, U(10), sGapMainVerticalName);	
	dGapMainVertical.setDescription(T("|Defines the main vertical gap|"));
	dGapMainVertical.setCategory(category);
	
	// Facet //
	String sGapFacetName=T("|Facet|");	
	PropDouble dGapFacet(nDoubleIndex++, U(15), sGapFacetName);	
	dGapFacet.setDescription(T("|Defines the facet gap|"));
	dGapFacet.setCategory(category);
	
	// Gap at the beam //
	String sGapBeamName=T("|Beam|");	
	PropDouble dGapBeam(nDoubleIndex++, U(10), sGapBeamName);	
	dGapBeam.setDescription(T("|Defines the longitudinal gap at the start and end of beam|"));
	dGapBeam.setCategory(category);
	
//End Properties//endregion 
	
	
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
		
	// prompt for selection of SIP and BEAM
		Entity ents[0];
		PrEntity ssE(T("|Select panel and beam|"), Sip());// accept SIP
		ssE.addAllowedClass(Beam());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
		
		dProps.append(dGapTopVertical);
		dProps.append(dGapTopHorizontal);
		dProps.append(dGapBottomVertical);
		dProps.append(dGapBottomHorizontal);
		dProps.append(dGapMainVertical);
		dProps.append(dGapFacet);
		dProps.append(dGapBeam);
		
		if(ents.length()<2)
		{ 
			reportMessage(TN("|there are needed at least a beam and a panel|"));
			eraseInstance();
			return;
		}
	// loop tsls
		Beam beams[0];
		Sip sips[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Beam beami=(Beam)ents[i];
			if (beami.bIsValid())
			{ 
				// collect beams
				beams.append(beami);
				continue;
			}
			Sip sipi = (Sip)ents[i];
			if(sipi.bIsValid())
			{ 
				// collect panels
				sips.append(sipi);
			}
		}
		if(beams.length()<1||sips.length()<1)
		{ 
			reportMessage(TN("|At least a beam and a panel are needed|"));
			eraseInstance();
			return;
		}
	//
	// create a TSL for each panel, we will have a TSL for each panel connected with the beam
		for (int i = 0; i < sips.length(); i++)
		{ 
			gbsTsl.setLength(0);
			gbsTsl.append(beams[0]);
			gbsTsl.append(sips[i]);
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

//region setEraseAndCopyWithBeams

// if panel is splitted a new TSL instance will be created for the newly created panel
	setEraseAndCopyWithBeams(_kBeam0);
	
//End setEraseAndCopyWithBeams//endregion 


//region trigger to change profile beam
	
// Trigger ChangeBeam//region
	String sTriggerChangeBeam = T("|Select new profile beam|");
	addRecalcTrigger(_kContext, sTriggerChangeBeam );
	if (_bOnRecalc && (_kExecuteKey==sTriggerChangeBeam))
	{
		reportMessage(TN("|_kExecuteKey::|")+_kExecuteKey);
		
		Beam bm = getBeam(TN("|Select new profile beam|"));
		_Beam[0] = bm;
		setExecutionLoops(2);
		return;
	}//endregion
	
//End trigger to change profile beam//endregion 
	
	
//region verification
	
	if(_Sip.length()<1)
	{ 
		// guard when no SIP selected
		reportMessage(TN("|no panel in selection|"));
		eraseInstance();
		return;
	}
	Sip sip = _Sip[0];
	
	if(_Beam.length()<1)
	{ 
		// guard when no beam selected
		reportMessage(TN("|no beam in selection|"));
		eraseInstance();
		return;
	}
	
//End verification//endregion 

	Beam beam = _Beam[0];
	
//region set dependency on beam
	
//set dependency on beam
	Entity entDependency = (Entity)beam;
	_Entity.append(entDependency);
	setDependencyOnEntity(entDependency);
	
//End set dependency on beam//endregion 


//region beam data
	
	Point3d ptCen = beam.ptCen();ptCen.vis(4);
	Vector3d vecX = beam.vecX();
	Vector3d vecY = beam.vecY();
	Vector3d vecZ = beam.vecZ();
	double dLengthBeam = beam.solidLength();
	
	vecX.vis(ptCen, 1);vecY.vis(ptCen, 3);vecZ.vis(ptCen, 150);
	
//End beam data//endregion 
	
//	// get name of beam extrusion profile
//	String sExtrProfile = beam.extrProfile();
//	// create instance of the profile
//	ExtrProfile extrProfile(sExtrProfile);
//	// plane profile of the extrprofile
//	PlaneProfile ppExtrProfile = extrProfile.planeProfile();
//	ppExtrProfile.transformBy(beam.coordSys());
//	ppExtrProfile.vis(3);
	
//region SIP data
	
// Sip data
	Vector3d vecXSip = sip.vecX();
	Vector3d vecYSip = sip.vecY();
	Vector3d vecZSip = sip.vecZ();
	Point3d ptCenSip = sip.ptCen();
	vecXSip.vis(ptCenSip, 1);vecYSip.vis(ptCenSip, 3);vecZSip.vis(ptCenSip, 150);
// get all edges of the panel
	SipEdge sipEdges[] = sip.sipEdges();
	
//End SIP data//endregion 

	
// connection vector
	// ptCenSip to Line is not in the plane of SIP, not reliable!!!
//	Vector3d vecZC = beam.vecD(Line(ptCen, vecX).closestPointTo(ptCenSip) - ptCenSip);
//	vecZC.vis(ptCen - vecZC * U(100),2);
//	Vector3d vecZN = vecZC.crossProduct(vecZSip).crossProduct(-vecZSip);
	
	
//region verify panel wrt beam axis
	
// The panel can only be rotated with respect to the beam axis
// the Z of the panel should be normal to the beam axis
	if(vecX.dotProduct(vecZSip)>dEps)
	{ 
		// normal vector of panel not perpendicular to beam axis
		// panel skew not accepted
		reportMessage(TN("|panel skew not accepted|"));
		reportMessage(TN("|panel can only be rotated wrt beam axis|"));
	}

//End verify panel wrt beam axis//endregion 

	
// see if the panel and the beam can intersect
// see if extension of panel can intersect the beam
// create a plane from vecX x vecZSip, plane in direction of beam and normal with the sip
	Vector3d vecPlaneProject = vecX.crossProduct(vecZSip);
	Plane planeProject(ptCen, vecPlaneProject);// plane to check intersection of beam and panel
	
// beam body
	Body bodyBeam = beam.envelopeBody(true, false);
	PlaneProfile ppBeamShadow = bodyBeam.shadowProfile(planeProject);
// project SIP
	Body bodySip = sip.envelopeBody(true, false);
	PlaneProfile ppSipShadow = bodySip.shadowProfile(planeProject);
	// 
// do the intersection of 2 planeprofiles 
	PlaneProfile ppIntersection = ppBeamShadow;
	int iHasIntersection = ppIntersection.intersectWith(ppSipShadow);
	if(!iHasIntersection)
	{ 
		// beam and panel do not intersect
		reportMessage(TN("|beam and panel not intersecting|"));
		reportMessage(TN("|extension of the panel still cannot intersect the beam|"));
		eraseInstance();
		return;
	}
	
// project the panel and the beam in the panel plane
	PLine plSip = sip.plShadow();
	PlaneProfile ppSipShadowPlane(plSip);// plane profile of SIP
	CoordSys cs = ppSipShadowPlane.coordSys();// coord system of the plane profile
	// Create a plane
	Point3d ptPlane = plSip.ptStart();// point in the SIP plane
	Plane pnSip(ptPlane, vecZSip);// plane of the SIP
	// project beam to pnSip
	PlaneProfile ppBeamSipPlane = bodyBeam.shadowProfile(pnSip);// plane profile of BEAM
	// 
// find the vector pointing from panel to beam
// vector normal with beam but in the plane of panel
	Vector3d vecBeamNormal = vecY;
	if (abs(abs(vecY.dotProduct(vecZSip)) - 1.0)<dEps)
	{ 
		// vBeamNormal and vecPlane are colinear
		// take other beam vector
		vecBeamNormal = vecZ;// not normal with plane
	}
	// create a lineSeg at ptCen with vecBeamNormal
	Point3d pt1 = ptCen;
	Point3d pt2 = pt1 + vecBeamNormal * U(100);
	LineSeg lSegBeamNormal(pt1, pt2);
	lSegBeamNormal.vis(1);
	LineSeg lSegBeamNormalArray[0];
	lSegBeamNormalArray.append(lSegBeamNormal);
	// project vecBeamNormal to the plane
	LineSeg lSegBeamNormalPlaneArray[] = pnSip.projectLineSegs(lSegBeamNormalArray);
	LineSeg lSegBeamNormalPlane = lSegBeamNormalPlaneArray[0];// get only the first entry
	Vector3d vecBeamNormalPlane = (lSegBeamNormalPlane.ptEnd() - lSegBeamNormalPlane.ptStart());
// vector normal with beam in the plane of SIP
	vecBeamNormalPlane.normalize();// normalize the vector
// center of beam should not ne same as center of sip	
	Vector3d vecSipBeam = ptCen - ptCenSip;
	if(vecSipBeam.length()<dEps)
	{ 
		// beam should not be exactly at the center of SIP
		reportMessage(TN("|center of beam at the same position as center of panel|"));
		eraseInstance();
		return;
	}
	vecSipBeam.normalize();//normalize
	// find the right direction of vecBeamNormalPlane
	if(vecBeamNormalPlane.dotProduct(vecSipBeam)<0)
	{ 
		// vectors in opposite sides
		vecBeamNormalPlane *= -1;
	}
	
// Beam vectors Y or Z most aligned with vecBeamNormalPlane
	Vector3d vecBeamAligned1 = beam.vecD(vecBeamNormalPlane);
	Vector3d vecBeamAligned = vecY;
	Vector3d vecBeamNotAligned = vecZ;
	if(abs(vecBeamAligned1.dotProduct(vecY))<dEps)
	{ 
		// normal with vecY
		vecBeamAligned = vecZ;// beam vector most aligned to panel
		vecBeamNotAligned = vecY;// other normal beam vector
	}
	vecBeamAligned.vis(ptCen - U(400) * vecX, 4);
	vecBeamNotAligned.vis(ptCen - U(400) * vecX, 4);
	// Aligned vector but pointing from pane to beam, most aligned with vecBeamNormalPlane
	Vector3d vecBeamAlignedPlane = vecBeamAligned;
	if(vecBeamAligned.dotProduct(vecBeamNormalPlane)<0)
	{ 
		vecBeamAlignedPlane *= -1;// beam vector most aligned with sip but pointing from sip to beam
	}
	Vector3d vecBeamNotAlignedUp = vecBeamNotAligned;
	if (vecBeamNotAligned.dotProduct(vecZSip) < 0)vecBeamNotAlignedUp *= -1;
	vecBeamAlignedPlane.vis(ptCen - U(500) * vecX, 4);// with one of the beam vectors
	vecBeamNormalPlane.vis(ptCen - U(500) * vecX, 4);// in the plane of panel

	
// find the edges that must be streched or cutted
// get the edges that point toward the beam
// loop all SIP and remove the edges normal with the beam and cant be streched
	if(sipEdges.length()<1)
	{ 
		// no edge was found at the panel
		reportMessage(TN("|no edge was found at the panel|"));
		eraseInstance();
		return;
	}
	for (int i=sipEdges.length()-1; i>=0 ; i--) 
	{ 
		SipEdge sipEdgei=sipEdges[i];
		if(sipEdgei.vecNormal().dotProduct(vecBeamNormalPlane)<0
		   || abs(sipEdgei.vecNormal().dotProduct(vecBeamNormalPlane))<dEps) 
		{ 
			// edge pointing oposite direction 
			// edge normal with beam direction
			sipEdges.removeAt(i);
		}
	}//next i
	
// exclude from the selections edges that are part of an opening
// get the planeprofile of all openings
	PlaneProfile ppOpening(cs);
	PLine plines[]=sip.plOpenings();// get all openings of the sip
	if(plines.length()>0)
	{ 
		// if there are openings in the SIP
		for (int j=0;j<plines.length();j++) 
			ppOpening.joinRing(plines[j],_kAdd); // plane profile of all openings
		ppOpening.vis(2);
		// remove edges of openings
		if (ppOpening.area()>pow(dEps,2))
			for (int e=sipEdges.length()-1; e>=0 ; e--) 
				if (ppOpening.pointInProfile(sipEdges[e].ptMid() + sipEdges[e].vecNormal()* 100*dEps)==_kPointInProfile)
					sipEdges.removeAt(e);
	}
	
// for each edge check if they can intersect the beam
	for (int i=sipEdges.length()-1; i>=0 ; i--) 
	{ 
		SipEdge sipEdgei = sipEdges[i];
		Point3d pt1 = sipEdgei.ptStart() - vecZSip * U(10e3);
		Point3d pt2 = sipEdgei.ptEnd() + vecZSip * U(10e3);
		LineSeg lSeg(pt1, pt2);
		PLine plRec;
		
		Point3d pts[] ={ pt1, pt2};
		Point3d ptsPn[] = pnSip.projectPoints(pts);
		// vecZ is vecZSip
		// vecXis pt1,pt2 projected to plane
		Vector3d vecXrect = ptsPn[1] - ptsPn[0];
		vecXrect.normalize();
		
		plRec.createRectangle(lSeg, vecXrect, vecZSip);
		PlaneProfile pprec(plRec);
		// check if it intersects with the projected beamshadow
		PlaneProfile pp = ppBeamShadow;
		if(!pp.intersectWith(pprec))
		{ 
			// no intersection
			sipEdges.removeAt(i);
		}
	}//next i
	
// guard if sipEdges.length<1
	if(sipEdges.length()<1)
	{ 
		reportMessage(TN("|no edge for calculation|"));
		eraseInstance();
		return;
	}
	
// find the edge closest to the beam
	// line in the beam axis
	// find the point at the wall of beam
	Plane plBeamNormal(ptCen, vecX);
	PlaneProfile ppBeamSection = bodyBeam.shadowProfile(plBeamNormal);// plane profile of the beam section
	ppBeamSection.vis(9);
// width and height of section relative to local coord
	LineSeg lSegSection = ppBeamSection.extentInDir(vecBeamAligned);
	double dWidthSec = abs(vecY.dotProduct(lSegSection.ptStart() - lSegSection.ptEnd()));
	double dHeightSec = abs(vecZ.dotProduct(lSegSection.ptStart() - lSegSection.ptEnd()));
// width and height of section relative to aligned to panel
	double dWidthSecAligned = abs(vecBeamAligned.dotProduct(lSegSection.ptStart() - lSegSection.ptEnd()));
	double dHeightSecAligned = abs(vecBeamNotAlignedUp.dotProduct(lSegSection.ptStart() - lSegSection.ptEnd()));
	
	Point3d ptCenSec = .5 * (lSegSection.ptStart() + lSegSection.ptEnd());

// line at ptCenSec and vecX
	Line lnBeamSec(ptCenSec, vecX);// line at the ptCenSec in vecX
	
	SipEdge sipEdgeMin; // closest edge to the beam
	double distanceMin = U(10e4);
	for (int i=0;i<sipEdges.length();i++) 
	{ 
		Point3d ptEdgeMid = sipEdges[i].ptMid();
//		ptEdgeMid.vis(3);
		Point3d ptEdgeMidLine = lnBeamSec.closestPointTo(ptEdgeMid);
		double distance = (ptEdgeMidLine - ptEdgeMid).length();
		if(distance<distanceMin)
		{ 
			sipEdgeMin = sipEdges[i];
			distanceMin = distance;
		}
	}//next i
	
// get the wall of the section
	ptCenSec.vis(12);
	Point3d pt1Rec = ptCenSec - 0.1 * dHeightSecAligned * vecBeamNotAlignedUp 
							   - 1.2 * dWidthSecAligned * vecBeamAligned;
	Point3d pt2Rec = ptCenSec + 0.1 * dHeightSecAligned * vecBeamNotAlignedUp 
							   + 1.2 * dWidthSecAligned * vecBeamAligned;
	LineSeg lSegRec(pt1Rec, pt2Rec);
	PLine plRect;
	plRect.createRectangle(lSegRec, vecBeamAligned, vecBeamNotAlignedUp);
	PlaneProfile ppRectWall(plRect);
// intersect of the strip with the section to get the wall width
	PlaneProfile ppBeamSectionCopy = ppBeamSection;
	ppBeamSectionCopy.intersectWith(ppRectWall);
	ppBeamSectionCopy.vis(6);
// get extents of wall profile
	LineSeg seg = ppBeamSectionCopy.extentInDir(vecY);
	Point3d ptCenWall = .5 * (seg.ptStart() + seg.ptEnd());
	double dWidthWall = abs(vecBeamAligned.dotProduct(seg.ptStart() - seg.ptEnd()));// wall width
	double dHeightWall = abs(vecBeamNotAlignedUp.dotProduct(seg.ptStart() - seg.ptEnd()));// wall height
// point in wall on the side of panel
	Point3d ptBeamWall = ptCenWall - vecBeamAlignedPlane * .5 * dWidthWall;
//	ptBeamWall.vis(7);

	Point3d ptBeamWallProp = ptBeamWall - vecBeamAlignedPlane * dGapMainVertical;
// plane of wall where the edge will be streched
	Plane pnBeamWall(ptBeamWall, vecBeamAlignedPlane);
	Plane pnBeamWallProp(ptBeamWallProp, vecBeamAlignedPlane);
	
// get all edges that are aligned with this edge
	Point3d ptStartMin = sipEdgeMin.ptStart();//ptStartMin.vis(4);
	Point3d ptMidMin = sipEdgeMin.ptMid();
	Point3d ptEndMin = sipEdgeMin.ptEnd();//ptEndMin.vis(4);
	Vector3d vecMin = ptEndMin - ptStartMin;
	vecMin.normalize();
// line at the closest edge
	Line lnEdgeMin(ptMidMin, vecMin);
	
	for (int i=sipEdges.length()-1; i>=0 ; i--)
	{ 
		// 
		SipEdge sipEdgei = sipEdges[i];
		Point3d ptStart = sipEdgei.ptStart();
		Point3d ptMid = sipEdgei.ptMid();
		Point3d ptEnd = sipEdgei.ptEnd();
		
		Vector3d veci = ptEnd - ptStart;
		veci.normalize();
		Line lnEdgei(ptMid, veci);// line at the edge
		if(abs(vecMin.dotProduct(veci)-1)>dEps)
		{ 
			// not colinear, remove
			sipEdges.removeAt(i);
			continue;
		}
		Vector3d vecDist = ptMid - lnEdgeMin.closestPointTo(ptMid);
		if(vecDist.length()>dEps)
		{
			// not in the same line remove
			sipEdges.removeAt(i);
		}
	}//next i
	
	if(sipEdges.length()<1)
	{ 
		reportMessage(TN("|no edge for calculation|"));
		eraseInstance();
		return;
	}
	
// do the stretching for each edge to the ptBeamWall plane pnBeamWall
	for (int i=0;i<sipEdges.length();i++) 
	{ 
		Point3d ptEdge = sipEdges[i].ptMid();
		// strech the SIP edge to the wall of the beam
		int iStretch = sip.stretchEdgeTo(ptEdge, pnBeamWallProp);
	}//next i
	
// draw body for the display
	Point3d ptsEdges[0];
	for (int i=0;i<sipEdges.length();i++) 
	{ 
		ptsEdges.append(sipEdges[i].ptStart());
		ptsEdges.append(sipEdges[i].ptEnd()); 
	}//next i
	ptsEdges = lnBeamSec.orderPoints(ptsEdges);
	Point3d ptMidDisplay = .5 * (ptsEdges[0] + ptsEdges[ptsEdges.length()-1]);
	
// body from the envelope of section needed for visualisation of TSL
	PLine plRectBody;
	plRectBody.createRectangle(lSegSection, vecBeamAligned, vecBeamNotAlignedUp);
	Vector3d vecExtrusion = -U(10) * vecX;
	Body bodySec(plRectBody, vecExtrusion);
	bodySec.transformBy(vecX * vecX.dotProduct(ptMidDisplay - ptCen));
	Display dp(252);
//	dp.draw(bodySec);
	
	
// if panels are joined again the TSL must be deleted
// get all TSLs and delete if one is found
	Group grp;
	Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
	TslInst tsl;
	String sTslName = scriptName();// name of the TSL
	
	for (int i = arEnt.length() - 1; i >= 0; i--)
	{
		TslInst t = (TslInst)arEnt[i];
		if(!t.bIsValid())
		{ 
			continue;
		}
		if (t.scriptName() != sTslName || t==_ThisInst)
		{
			continue;
		}
		// get sips of the TSL
		Sip sips[] = t.sip();// get sips
		Beam beams[] = t.beam();// get beams
		if (sips.length() < 1 || beams.length() < 1)
		{
			continue;
		}
		// check the sip
		if (sips[0] != sip || beams[0] != beam)
		{
			// not the same sip or beam
			continue;
		}
		// delete tsl
		arEnt[i].dbErase();
	}
	
//closest point of section with the panel
	Point3d ptSecExtreme = lSegSection.ptStart();
	if((lSegSection.ptStart()-lSegSection.ptEnd()).dotProduct(vecBeamAlignedPlane)>0)
	{ 
		// ptend closer with the panel
		ptSecExtreme = lSegSection.ptEnd();
	}
	
//	ptSecExtreme.vis(6);
	// see if ptBeamWall is at ptSecExtreme or inside
// 1)Y aligned with the panel plane
//  a- ptBeamWall inside the ppBeamSection L,C,doppioT
//  b- ptBeamWall at the ptSecExtreme reverse L, reverse C
// 2)Z aligned with the panel plane
//  a- ptbeamWall inside the ppBeamSection L
//  b- ptBeamWall at ptSecExtreme C,L, doppioT


// check the relationship of ptBeamWall and ptSecExtreme
	Vector3d vec(ptBeamWall - ptSecExtreme);
	if(vec.dotProduct(vecBeamAlignedPlane)>dEps)
	{ 
		// ptBeamWall inside the ppBeamSection
		// can be L,U,doppioT
		Point3d ptRightTop = ptCenSec - .5 * dWidthSecAligned * vecBeamAlignedPlane 
									   + .5 * dHeightSecAligned * vecBeamNotAlignedUp;
		Point3d ptRightBottom = ptCenSec - .5 * dWidthSecAligned * vecBeamAlignedPlane 
										 - .5 * dHeightSecAligned * vecBeamNotAlignedUp;
//		ptRightTop.vis(7);ptRightBottom.vis(7);
	// get the PLine of the pprofile of the section
		PLine plAllRings[] = ppBeamSection.allRings();
		if(plAllRings.length()>1)
		{ 
			reportMessage(TN("|unexpected error...|"));
			reportMessage(TN("|nr of rings in section:| ") + plAllRings.length());
			eraseInstance();
			return;
		}
	// get all points of the PLine
		Point3d plPoints[] = plAllRings[0].vertexPoints(true);// first/last point only once
	// see if top flange exists
		pt1Rec = ptRightTop - .5 * dHeightSecAligned * vecBeamNotAlignedUp 
							+ .25 * dWidthSecAligned * vecBeamAlignedPlane;
		pt2Rec = ptRightTop + .5 * dHeightSecAligned * vecBeamNotAlignedUp 
							+ .20 * dWidthSecAligned * vecBeamAlignedPlane;
		LineSeg lSegRecTop(pt1Rec, pt2Rec);
		plRect.createRectangle(lSegRecTop, vecY, vecZ);
		PlaneProfile ppRectTop(plRect);
		// intersect of the strip with the section to get the wall width
		ppBeamSectionCopy = ppBeamSection;
		// check if there is intersection
		iHasIntersection = ppBeamSectionCopy.intersectWith(ppRectTop);
		if (iHasIntersection)
		{ 
			Line ln1(ptRightTop, vecBeamAlignedPlane );
			Point3d ptIntersect;// top flange with the pnBeamWall
			int iHasInter1 = ln1.hasIntersection(pnBeamWall, ptIntersect);
			if(!iHasInter1)
			{ 
				reportMessage(TN("|unexpected error...|"));
				eraseInstance();
				return;
			}
//				ptIntersect.vis(2);
		// 2 bounding vectors in ptIntersect
			Vector3d vecBound1 = - vecBeamNotAlignedUp - dEps * vecBeamAlignedPlane;
			vecBound1.normalize();
			Vector3d vecBound2 = - vecBeamAlignedPlane - dEps * vecBeamNotAlignedUp;
			vecBound2.normalize();
		//"angle" between vecBound1 and vecBound2
			Vector3d vecBound = vecBound1.crossProduct(vecBound2);
			double dAngleBound = (vecBound1.crossProduct(vecBound2)).length();
		// gather points inside the boundary
			Point3d ptBounds[0];
			
			// index where the loop in points does not continue but breaks
			int indexCut = - 1;
			int indexCount = 0;
			int indexCutFound = false;
			for (int i = 0; i < plPoints.length(); i++)
			{ 
				// see if point in top half of section
				if (((ptRightTop - plPoints[i]).dotProduct(vecBeamNotAlignedUp) - .5 * dHeightSecAligned) > dEps)
				{ 
					// point at the bottom half, exclude
					continue;
				}
				
				Vector3d vec = plPoints[i] - ptIntersect;
				vec.normalize();
				Vector3d vecI = vecBound1.crossProduct(vec);
				if (vecBound.dotProduct(vecI) <- dEps)
				{ 
					// other side of rotation
					continue;
				}
				double dAngleI = vecI.length();
				if (dAngleI > dAngleBound)
				{ 
					// outside of the boundaries
					continue;
				}
				ptBounds.append(plPoints[i]);
//				plPoints[i].vis(2);
				if ( ! indexCutFound)
				{ 
					// index where cut not yet found
					if (indexCount == i)
					{ 
						// increment it by 1
						indexCount++;
					}
					else if (indexCount == 0)
					{ 
						// if it is stil 0 but !=i, means the first some points were not part
						// so the last point to - the first point can not be connected
						// meaning the last
						indexCut = -100;
						indexCutFound = true;
					}
					else
					{ 
						indexCut = indexCount - 1;
						indexCutFound = true;
					}
				}
			}//next i
			//
			// reorder so that indexCut will be the first point
			Point3d ptBoundsCopy[0];
			if (ptBounds.length() > 0 && indexCut >- 1)
			{ 
				ptBoundsCopy.append(ptBounds);
				for (int i = 0; i < indexCut + 1; i++)
				{ 
					ptBounds[ptBounds.length() - (indexCut + 1) + i] = ptBoundsCopy[i];
				}//next i
				
				for (int i = 0; i < ptBounds.length() - (indexCut + 1); i++)
				{ 
					ptBounds[i] = ptBoundsCopy[indexCut + 1 + i];
				}//next i
			}
			
			if (ptBounds.length() > 1)
			{ 
				Vector3d vecMax = ptBounds[1] - ptBounds[0];
				Point3d pt1VecMax = ptBounds[0];
				Point3d pt2VecMax = ptBounds[1];
				// get the longest segment
				for (int i = 0; i < ptBounds.length() - 1; i++)
				{ 
					Vector3d vecI = ptBounds[i + 1] - ptBounds[i];
					if (vecI.length() > vecMax.length())
					{ 
						vecMax = vecI;
						pt1VecMax = ptBounds[i];
						pt2VecMax = ptBounds[i + 1];
					}
				}//next i
//					pt1VecMax.vis(2);
//					pt2VecMax.vis(2);
				vecMax.normalize();
//				vecMax.vis(ptCen, 3);
			// intersection with pnBeamWall
				Point3d ptIntersect2;
				// line between 2 points of inner flange
				Line ln2(pt1VecMax, vecMax);
				iHasInter1 = ln2.hasIntersection(pnBeamWall, ptIntersect2);
				if(!iHasInter1)
				{ 
					// normally not possible
					reportMessage(TN("|unexpected error...|"));
					eraseInstance();
					return;
				}
//				ptIntersect2.vis(2);
				// plane parallel with pnBeamWall but in ptRightTop
				Plane pnBeamWall2(ptRightTop, pnBeamWall.normal());
			// intersection with pnBeamWall2
				Point3d ptIntersect3;
				iHasInter1 = ln2.hasIntersection(pnBeamWall2, ptIntersect3);
				if(!iHasInter1)
				{ 
					// normally not possible
					reportMessage(TN("|unexpected error...|"));
					eraseInstance();
					return;
				}
//				ptIntersect3.vis(2);
				
			// vector normal with vecMax and vecX
				Vector3d vec = vecMax.crossProduct(vecX);
				if (vec.dotProduct(vecBeamNotAlignedUp) < dEps)vec *= -1;
				Vector3d vecMaxAligned = vecMax;
				if (vecMax.dotProduct(vecBeamAlignedPlane) < dEps)vecMaxAligned *= -1;
				// beamcut
				double dCutHeight = U(10e3);
				Point3d ptCenFlange = .5 * (ptIntersect2 + ptIntersect3) - vecMaxAligned * .5 * dGapTopVertical;
				ptCenFlange += vec * (.5 * dCutHeight - dGapTopHorizontal);
//				ptCenFlange.vis(3);
				double dCutWidth = (ptIntersect2 - ptIntersect3).length() + dGapTopVertical;
				BeamCut bcTopFlange(ptCenFlange, vecX, vecMax, vec, 
				        dLengthBeam + 2 * dGapBeam, dCutWidth, dCutHeight);
				sip.addTool(bcTopFlange);
				bodySec.addTool(bcTopFlange);
				// beamcut in direction vecBeamNotAlignedUp
				ptCenFlange = ptCenFlange - vecMaxAligned * .5 * dCutWidth;
				ptCenFlange -= vec * .5 * dCutHeight;
				ptCenFlange += vecBeamAlignedPlane * .5 * dCutWidth;
				ptCenFlange += vecBeamNotAlignedUp * .5 * dCutHeight;
				BeamCut bcTopFlange2(ptCenFlange, vecX,vecBeamAligned, vecBeamNotAlignedUp,
				        dLengthBeam + 2 * dGapBeam, dCutWidth, dCutHeight);
				sip.addTool(bcTopFlange2);
				bodySec.addTool(bcTopFlange2);
			// facet
				Vector3d vFacet1 = vecMaxAligned; //vecBeamAlignedPlane;
				
				// rotation vector must be such that vFacet1 is rotated toward the top
				Vector3d vecxRot = vFacet1.crossProduct(vecBeamNotAlignedUp);
				if (vecxRot.dotProduct(vecX) < 0)
				{ 
					vecxRot = -vecX;
				}
				else
				{ 
					vecxRot = vecX;
				}
//				vecMaxAligned.vis(ptCen, 4);
				vFacet1 = vFacet1.rotateBy(45, vecxRot);
					vFacet1.vis(ptCen - U(200) * vecX,3);
				Vector3d vFacet2 = vFacet1.rotateBy(90, vecxRot);
					vFacet2.vis(ptCen - U(200) * vecX,3);
				double dFacetWidth = 2 * sqrt(2) * dGapFacet + sqrt(2) *dWidthWall;
				//HSB-21257 
				if (dFacetWidth>dEps && dLengthBeam+2*dGapBeam>dEps && dGapFacet>dEps )
				{ 
					BeamCut bcFacet(ptIntersect2, vecX, vFacet2, vFacet1,
									dLengthBeam+2*dGapBeam, dFacetWidth, 2 * sqrt(2) * dGapFacet );
					//bcFacet.cuttingBody().vis(3);
					sip.addTool(bcFacet);
					bodySec.addTool(bcFacet);					
				}

			}
			else if (ptBounds.length() <= 1)
			{
				
				// top flange exist create beamcut
				// distance between ptRightTop and wall
				// flange height
				LineSeg seg = ppBeamSectionCopy.extentInDir(vecBeamAligned);
				// flange width
				double dFlange = abs(vecBeamNotAlignedUp.dotProduct(seg.ptStart() - seg.ptEnd()));
				// flange length up to wall ptBeamWall
				LineSeg seg1(ptRightTop, ptBeamWall);
				double dDistance = abs(vecBeamAligned.dotProduct(seg1.ptStart() - seg1.ptEnd()));
				dDistance += dGapTopVertical;
				
				Point3d pt1 = ptRightTop + U(10e3) * vecBeamNotAlignedUp;
				Point3d pt2 = ptRightTop + vecBeamAlignedPlane * (dDistance - dGapTopVertical) - vecBeamNotAlignedUp * dFlange;
				double dCutHeight = U(10e3);
				// center of flange beamcut
				Point3d ptCenFlange = ptRightTop + .5 * (dDistance - dGapTopVertical) * vecBeamAlignedPlane
				 + (- dFlange + .5 * dCutHeight - dGapTopHorizontal) * vecBeamNotAlignedUp;
				LineSeg seg2(pt1, pt2);
				PLine plRec;
				
				plRec.createRectangle(seg2, vecBeamAligned, vecBeamNotAlignedUp);
				PlaneProfile ppFlange(plRec);
				//		ppFlange.vis(2);
				// BeamCut
				BeamCut bcTopFlange(ptCenFlange, vecX, vecBeamAligned, vecBeamNotAlignedUp,
				dLengthBeam + 2 * dGapBeam, dDistance, dCutHeight);
				sip.addTool(bcTopFlange);
				bodySec.addTool(bcTopFlange);
			
				// the facet
				Point3d pt = ptRightTop - vecBeamNotAlignedUp * dFlange;
				Line ln(pt, vecBeamAlignedPlane);
				Point3d ptInter;
				int iHasInter = ln.hasIntersection(pnBeamWall, ptInter);
				if(!iHasInter)
				{ 
					reportMessage(TN("|unexpected error...|"));
					eraseInstance();
					return;
				}
				
				Vector3d vFacet1 = vecBeamAlignedPlane;
				vFacet1 = vFacet1.rotateBy(45, vecX);
				//ptInter.vis(8);
				//vFacet1.vis(ptCen - U(200) * vecX,3);
				Vector3d vFacet2 = vFacet1.rotateBy(90,vecX);
				//vFacet2.vis(ptCen - U(200) * vecX,3);
				if (vFacet1.dotProduct(vecBeamNotAlignedUp) < 0)
				{ 
					Vector3d vec = vFacet1;
					vFacet1 = vFacet2;
					vFacet2 = vec;
				}
				double dFacetWidth1 = 2 * sqrt(2) * dGapFacet ;
				double dFacetWidth2 = 2 * sqrt(2) * dGapFacet+ sqrt(2) *dWidthWall;//;
				BeamCut bcFacet(ptInter, vecX, vFacet1, vFacet2,
								dLengthBeam+2*dGapBeam, dFacetWidth1, dFacetWidth2 );
				sip.addTool(bcFacet);
				bodySec.addTool(bcFacet);
			}
		}
	// bottom flange
		pt1Rec = ptRightBottom - .5 * dHeightSecAligned * vecBeamNotAlignedUp 
								+ .25 * dWidthSecAligned * vecBeamAlignedPlane;
		pt2Rec = ptRightBottom + .5 * dHeightSecAligned * vecBeamNotAlignedUp 
								+ .20 * dWidthSecAligned * vecBeamAlignedPlane;
		LineSeg lSegRecBottom(pt1Rec, pt2Rec);
		plRect.createRectangle(lSegRecBottom, vecY, vecZ);
		PlaneProfile ppRectBottom(plRect);
//			ppRectBottom.vis(4);
		// intersect of the strip with the section to get the wall width
		ppBeamSectionCopy = ppBeamSection;
		// check if there is intersection
		iHasIntersection = ppBeamSectionCopy.intersectWith(ppRectBottom);
		if (iHasIntersection)
		{ 
			Line ln1(ptRightBottom, vecBeamAlignedPlane );
			Point3d ptIntersect;// bottom flange with the pnBeamWall
			int iHasInter1 = ln1.hasIntersection(pnBeamWall, ptIntersect);
			if(!iHasInter1)
			{ 
				reportMessage(TN("|unexpected error...|"));
				eraseInstance();
				return;
			}
//				ptIntersect.vis(2);
			// 2 bounding vectors in ptIntersect
			Vector3d vecBound1 = vecBeamNotAlignedUp - dEps * vecBeamAlignedPlane;
			vecBound1.normalize();
			Vector3d vecBound2 = - vecBeamAlignedPlane + dEps * vecBeamNotAlignedUp;
			vecBound2.normalize();
			//"angle" between vecBound1 and vecBound2
			Vector3d vecBound = vecBound1.crossProduct(vecBound2);
			double dAngleBound = (vecBound1.crossProduct(vecBound2)).length();
			// gather points inside the boundary
			Point3d ptBounds[0];
			
			// index where the loop in points does not continue but breakes
			int indexCut = -1;
			int indexCount = 0;
			int indexCutFound = false;
			for (int i = 0; i < plPoints.length(); i++)
			{ 
				// see if point in bottom half of section
				if (((plPoints[i] - ptRightBottom).dotProduct(vecBeamNotAlignedUp) - .5 * dHeightSecAligned) > dEps)
				{ 
					// point at the top half, exclude
					continue;
				}
				
				Vector3d vec = plPoints[i] - ptIntersect;
				vec.normalize();
//					ptIntersect.vis(2);
				Vector3d vecI = vecBound1.crossProduct(vec);
				if (vecBound.dotProduct(vecI) <- dEps)
				{ 
					// other side of rotation
					continue;
				}
				double dAngleI = vecI.length();
				if (dAngleI > dAngleBound)
				{ 
					// outside of the boundaries
					continue;
				}
				ptBounds.append(plPoints[i]);
//				plPoints[i].vis(2);
				if ( ! indexCutFound)
				{ 
					// index where cut not yet found
					if (indexCount == i)
					{ 
						// increment it by 1
						indexCount++;
					}
					else if (indexCount == 0)
					{ 
						// if it is stil 0 but !=i, means the first some points were not part
						// so the last point to - the first point can not be connected
						// meaning the last
						indexCut = -100;
						indexCutFound = true;
					}
					else
					{ 
						indexCut = indexCount - 1;
						indexCutFound = true;
					}
				}
			}//next i
			//
			// reorder so that indexCut will be the first point
			Point3d ptBoundsCopy[0];
			if (ptBounds.length() > 0 && indexCut >- 1)
			{ 
				ptBoundsCopy.append(ptBounds);
				for (int i = 0; i < indexCut + 1; i++)
				{ 
					ptBounds[ptBounds.length() - (indexCut + 1) + i] = ptBoundsCopy[i];
				}//next i
				
				for (int i = 0; i < ptBounds.length() - (indexCut + 1); i++)
				{ 
					ptBounds[i] = ptBoundsCopy[indexCut + 1 + i];
				}//next i
			}
			
			if(ptBounds.length()>1)
			{ 
				Vector3d vecMax = ptBounds[1] - ptBounds[0];
//				vecMax.vis(ptBounds[0], 3);
				Point3d pt1VecMax = ptBounds[0];
				Point3d pt2VecMax = ptBounds[1];
				
				for (int i = 0; i < ptBounds.length() - 1; i++)
				{ 
					ptBounds[i].vis(2);
					Vector3d vecI = ptBounds[i + 1] - ptBounds[i];
					if (vecI.length() > vecMax.length())
					{ 
						vecMax = vecI;
						pt1VecMax = ptBounds[i];
						pt2VecMax = ptBounds[i + 1];
					}
				}//next i
				vecMax.normalize();
				vecMax.vis(ptCen, 1);
			// intersection with pnBeamWall
				Point3d ptIntersect2;
				Line ln2(pt1VecMax, vecMax);// line between 2 points of inner flange
				iHasInter1 = ln2.hasIntersection(pnBeamWall, ptIntersect2);
				if ( ! iHasInter1)
				{ 
					// normally not possible
					reportMessage(TN("|unexpected error...|"));
					eraseInstance();
					return;
				}
//					ptIntersect2.vis(2);
				// plane parallel with pnBeamWall but in ptRightTop
				Plane pnBeamWall2(ptRightBottom, pnBeamWall.normal());
			// intersection with pnBeamWall2
				Point3d ptIntersect3;
				iHasInter1 = ln2.hasIntersection(pnBeamWall2, ptIntersect3);
				if(!iHasInter1)
				{ 
					// normally not possible
					reportMessage(TN("|unexpected error...|"));
					eraseInstance();
					return;
				}
//					ptIntersect3.vis(2);
				
				// vector normal with vecMax and vecX
				Vector3d vec = vecMax.crossProduct(vecX);// orientation as vecBeamNotAlignedUp
				if (vec.dotProduct(vecBeamNotAlignedUp) < dEps)vec *= -1;
				Vector3d vecMaxAligned = vecMax;// orientation as vecBeamAlignedPlane
				vecMaxAligned.vis(ptCen, 4);
				if (vecMax.dotProduct(vecBeamAlignedPlane) < dEps)vecMaxAligned *= -1;
				// beamcut
				double dCutHeight = U(10e3);
				Point3d ptCenFlange = .5 * (ptIntersect2 + ptIntersect3) - vecMaxAligned * .5 * dGapBottomVertical;
				ptCenFlange -= vec * (.5 * dCutHeight - dGapBottomHorizontal);
				double dCutWidth = (ptIntersect2 - ptIntersect3).length() + dGapBottomVertical;// total width with gap
				BeamCut bcBottomFlange(ptCenFlange, vecX,vecMax, vec,
				        dLengthBeam + 2 * dGapBeam, dCutWidth, dCutHeight);
				sip.addTool(bcBottomFlange);
				bodySec.addTool(bcBottomFlange);
				// beamcut in direction vecBeamNotAlignedUp
				ptCenFlange = ptCenFlange - vecMaxAligned * .5 * dCutWidth;
				ptCenFlange += vec * .5 * dCutHeight;
				ptCenFlange += vecBeamAlignedPlane * .5 * dCutWidth;
				ptCenFlange -= vecBeamNotAlignedUp * .5 * dCutHeight;
				BeamCut bcBottomFlange2(ptCenFlange, vecX,vecBeamAligned, vecBeamNotAlignedUp,
				        dLengthBeam + 2 * dGapBeam, dCutWidth, dCutHeight);
				sip.addTool(bcBottomFlange2);
				bodySec.addTool(bcBottomFlange2);
			// facet bottom
				Vector3d vFacet1 = vecBeamAlignedPlane; //vecBeamAlignedPlane;
				vFacet1 = vFacet1.rotateBy(45, vecX);
				vFacet1.vis(ptCen - U(200) * vecX,2);
				Vector3d vFacet2 = vFacet1.rotateBy(90,vecX);
				vFacet2.vis(ptCen - U(200) * vecX,2);
				if(vFacet1.dotProduct(vecBeamNotAlignedUp)<0)
				{ 
					Vector3d vec = vFacet1;
					vFacet1 = vFacet2;
					vFacet2 = vec;
				}
				double dFacetWidth1 = 2 * sqrt(2) * dGapFacet + sqrt(2) *dWidthWall;
				double dFacetWidth2 = 2 * sqrt(2) * dGapFacet;//;
				
				BeamCut bcFacet(ptIntersect2, vecX, vFacet1, vFacet2,
								dLengthBeam+2*dGapBeam, dFacetWidth1, dFacetWidth2 );
				sip.addTool(bcFacet);
				bodySec.addTool(bcFacet);
			}
			else if(ptBounds.length()<=1)
			{ 
			// bottom flange exist
			// top flange exist create beamcut
			// distance between ptRightTop and wall
			// flange height
			LineSeg seg = ppBeamSectionCopy.extentInDir(vecBeamAligned);
			double dFlange = abs(vecBeamNotAlignedUp.dotProduct(seg.ptStart() - seg.ptEnd()));
			// flange length up to wall
			LineSeg seg1(ptRightBottom, ptBeamWall);
			double dDistance = abs(vecBeamAligned.dotProduct(seg1.ptStart() - seg1.ptEnd()));
			dDistance += dGapBottomVertical;
			
			Point3d pt1 = ptRightBottom - U(10e4) * vecBeamNotAlignedUp;
			Point3d pt2 = ptRightBottom + vecBeamAlignedPlane * dDistance + vecBeamNotAlignedUp * dFlange;
			double dCutHeight = U(10e3);
			Point3d ptCenFlange = ptRightBottom + .5 * (dDistance-dGapBottomVertical) * vecBeamAlignedPlane 
					+( dFlange - .5 * dCutHeight + dGapBottomHorizontal) * vecBeamNotAlignedUp;
			LineSeg seg2(pt1, pt2);
			PLine plRec;
			plRec.createRectangle(seg2, vecBeamAligned, vecBeamNotAlignedUp);
			PlaneProfile ppFlange(plRec);
	//		ppFlange.vis(2);
			// BeamCut
			BeamCut bcBottomFlange(ptCenFlange,vecX,vecBeamAligned,vecBeamNotAlignedUp,
								dLengthBeam, dDistance, dCutHeight);
			sip.addTool(bcBottomFlange);
			bodySec.addTool(bcBottomFlange);
			// the facet
			Point3d pt = ptRightBottom + vecBeamNotAlignedUp * dFlange;
			Line ln(pt, vecBeamAlignedPlane);
			Point3d ptInter;
			int iHasInter = ln.hasIntersection(pnBeamWall, ptInter);
			if(!iHasInter)
			{ 
				reportMessage(TN("|unexpected error...|"));
				eraseInstance();
				return;
			}
			
			Vector3d vFacet1 = vecBeamAlignedPlane;
			vFacet1=vFacet1.rotateBy(45, vecX);
			Vector3d vFacet2 = vFacet1.rotateBy(90,vecX);
			BeamCut bcFacet(ptInter, vecX, vFacet2, vFacet1,
							dLengthBeam, sqrt(2) * 2 * dGapFacet, 2*sqrt(2) * dGapFacet );
			sip.addTool(bcFacet);
			bodySec.addTool(bcFacet);
			}
		}
	// wall
		Point3d ptBcWall = ptBeamWall + vecBeamAlignedPlane * (dWidthSec * .5 - dGapMainVertical);
		BeamCut bcWall(ptBcWall,vecX,vecBeamAligned,vecBeamNotAlignedUp,
						dLengthBeam, dWidthSec, dHeightSec);
		bodySec.addTool(bcWall);
		// ptBeamWall is at the wall at side of panel in the level of the center
		Point3d ptWall1 = ptBeamWall + U(10e3) * vecBeamNotAlignedUp;// topright point of wall
		Point3d ptWall2 = ptBeamWall + vecBeamAlignedPlane * dWidthWall - U(10e3) * vecBeamNotAlignedUp; // bottom left point of wall
		LineSeg lSegWall(ptWall1, ptWall2);
		PLine plWall;
		plWall.createRectangle(lSegWall, vecY,vecZ);
		PlaneProfile ppWall(plWall);
	}
	else if(vec.dotProduct(vecBeamAlignedPlane)<-dEps)
	{ 
		// not possible, ptBeamWall can not be outside ptSecExtreme
		reportMessage(TN("|unexpected error...|"));
		eraseInstance();
		return;
	}
	
//		dp.draw(bodySec);
	Plane plBeamNormalDisplay(ptMidDisplay, vecX);// plane at ptMidDisplay
	PlaneProfile ppBodySec = bodySec.shadowProfile(plBeamNormalDisplay);
	LineSeg lSeg = ppBodySec.extentInDir(vecBeamAligned);
	_Pt0 = .5*(lSeg.ptStart()+lSeg.ptEnd());
	PLine plBodySec[] = ppBodySec.allRings();
	if(plBodySec.length()<1)
	{ 
		reportMessage(TN("|unexpected error...|"));
		eraseInstance();
		return;
	}
	Point3d ptBodySec[] = plBodySec[0].vertexPoints(false);
	LineSeg segBodySec[0];
	for (int i=0;i<ptBodySec.length()-1;i++) 
	{ 
		LineSeg seg(ptBodySec[i], ptBodySec[i+1]);
		segBodySec.append(seg);
	}//next i
	dp.draw(segBodySec);

#End
#BeginThumbnail
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
="WB2&(#A(U"C]*BM6J1LF_N_K_(NG3@]5^)__]FW
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
        <int nm="BreakPoint" vl="883" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21257 bugfix when facet offset &lt;=0 " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/31/2024 8:40:58 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End