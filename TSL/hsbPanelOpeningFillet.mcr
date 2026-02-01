#Version 8
#BeginDescription
version  value="1.1" date="21mar13" author="th@hsbCAD.de"
initial

/// This TSL modifies existing window or door alike opeings in an existing panel such that
/// any corner will receive a fillet with the given radius.

/// Select panel and a point inside the window or door
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL modifies existing window or door alike opeings in an existing panel such that
/// any corner will receive a fillet with the given radius.
/// </summary>

/// <insert Lang=en>
/// Select panel and a point inside the window or door
/// </insert>

/// History
///<version  value="1.1" date="21mar13" author="th@hsbCAD.de">initial</version>



// basics and props
	U(1,"mm");	
	double dEps =U(.1);
	int bDebug;
	
	PropDouble dRadius(0,U(20),T("|Radius|"));
	dRadius.setDescription(T("|Defines the radius of the fillet|"));
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();			
		else
			// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);

	// declare arrays for tsl cloning
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[1];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		String sScriptname = scriptName();
		
		dArProps.append(dRadius);

		gbAr[0]=getSip();
		while (1) 
		{
			PrPoint ssP("\n" + T("|Pick point inside opening|"));  
			if (ssP.go()==_kOk) 
			{ 
			// do the actual query
				ptAr[0]= ssP.value();
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			}
			else 
			{ // no proper selection
				break; // out of infinite while
			}
		}	
		
		eraseInstance();
		return;
	}

// on mapIO
	if (_bOnMapIO)
	{
		Map mapIn = _Map;

		Vector3d  vecNormal= mapIn.getVector3d("vecNormal");
		Point3d ptOnPlane= mapIn.getPoint3d("ptOnPlane");
		Point3d ptRef = mapIn.getPoint3d("ptOnEdge");		
		Entity ent = mapIn.getEntity("sip");
		Sip sip = (Sip)ent;
		
		if (!sip.bIsValid())
		{
			reportMessage("\n invalid sip")	;
			return;
		}

	// stretch
		PLine pl(ptRef,ptOnPlane);
		//EntPLine epl;
		//epl.dbCreate(pl);
		//epl.setColor(4);
		
		int nResult = sip.stretchEdgeTo(ptRef, Plane(ptOnPlane,vecNormal));
		_Map.setInt("Result", nResult);
		return;	
	}

	
// the sip and declare standard vectors
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;	
	}	

	Sip sip;
	Vector3d vx,vy,vz;

	sip = _Sip[0];
	//assignToGroups(sip);
	vx=sip .vecX();
	vy=sip .vecY();
	vz=sip .vecZ();		
	Point3d ptCen = sip.ptCen();		
	Quader qdr(ptCen,vx,vy,vz);
	
// collect edges
	SipEdge edges[] = sip.sipEdges();
	
// get plines
	PLine plEnvelope = sip.plEnvelope();
	PLine plOpenings[] = sip.plOpenings();
	
// declare the pline which needs to be rounded and added to the sip
	PLine plFillet;	
	
	
// test pt0 against openings
	int nOpeningIndex=-1;
	int bIsDoor;
	for(int i=0;i<plOpenings.length();i++)
	{
		PlaneProfile pp(plOpenings[i]);
		if (pp.pointInProfile(_Pt0)==_kPointInProfile)
		{
			nOpeningIndex=i;
			plFillet=plOpenings[i];
			
			break;	
		}	
	}		

// if no opening could be detected check if is a door alike opening
	if (nOpeningIndex<0)
	{	
	// get hull
		PLine plHull;
		plHull.createConvexHull(Plane(ptCen,vz),plEnvelope.vertexPoints(true));
		//plHull.vis(2);
	
	// create bounding planeprofile to collect door openings
		PlaneProfile ppHull(plHull);
		//ppHull.shrink(-U(100));	
		
	// subtract the envelope to achieve door openings
		ppHull.joinRing(plEnvelope,_kSubtract);	
		//ppHull.vis(1);	
		
	// collect all rings
	 	plOpenings.append(ppHull.allRings());
		for(int i=0;i<plOpenings.length();i++)
		{
			PlaneProfile pp(plOpenings[i]);
			if (pp.pointInProfile(_Pt0)==_kPointInProfile)
			{
				nOpeningIndex=i;
				bIsDoor=true;
				break;	
			}	
		}		
	}


// an opening could be identified
	Point3d ptsOpening[0];
	Point3d ptMidOp;
	PLine plOpening;
	if (nOpeningIndex>-1)
	{
		plOpening= plOpenings[nOpeningIndex]; 
		plOpening.projectPointsToPlane(Plane(ptCen,vz),vz);plOpening.vis(40);
		ptsOpening = plOpening.vertexPoints(true);
		ptMidOp.setToAverage(ptsOpening);
	// remove edges not on this pline
		for (int e=edges.length()-1;e>=0;e--)	
		{
			double d = (edges[e].ptMid()-plOpening.closestPointTo(edges[e].ptMid())).length();
			if (d>dEps)
			{
				edges[e].plEdge().vis(1);
				edges.removeAt(e);			
			}
		}		
	}


// a window was identified
	if (nOpeningIndex>-1 && !bIsDoor)
	{
	// loop edges and collect stretch planes
		Vector3d vecNormals[edges.length()];
		Point3d ptOnPlanes[edges.length()];
		Point3d ptMids[edges.length()];
		for (int e=0; e<edges.length();e++)
		{
			SipEdge edge = edges[e];
			Point3d ptMid =edge.ptMid();
			Vector3d vyN = edge.vecNormal();	
			vyN.vis(ptMid,4);		
			double dMax = vyN.dotProduct(ptMidOp-ptMid);
			double dDist = dRadius+U(1);
			if (dDist>dMax)dDist=dMax;
			vecNormals[e] =vyN;
			ptMids[e] = ptMid;	
			ptOnPlanes[e] = ptMid+vyN*dDist;
		}// next e edge	
		
	// loop each stretch plane, re-collect edges again
		int n =ptMids.length();
		for (int e=0; e<n;e++)
		{
			Map mapIO;
			mapIO.setEntity("sip", sip);
			mapIO.setPoint3d("ptOnEdge", ptMids[e]);
			mapIO.setPoint3d("ptOnPlane", ptOnPlanes[e]);
			mapIO.setVector3d("vecNormal",vecNormals[e]);
			
			ptMids[e].vis(e);
			vecNormals[e].vis(ptOnPlanes[e],e);


		// stretch
			TslInst().callMapIO(scriptName(), mapIO);	
		}	
/*	
	// loop each stretch plane, re-collect edges again
		for (int x=0; x<planes.length();x++)
		{
			Plane pn = planes[x];
			SipEdge edges[] = sip.sipEdges();
		// remove edges not on this pline
			for (int e=edges.length()-1;e>=0;e--)	
			{
				double d = (edges[e].ptMid()-plOpening.closestPointTo(edges[e].ptMid())).length();
				if (d>dEps)
				{
					edges[e].plEdge().vis(1);
					edges.removeAt(e);			
				}
			}	
		
		// stretch to the plane with the same normal
			for (int e=0; e<edges.length();e++)
			{
				SipEdge edge = edges[e];
				Point3d ptMid =edge.ptMid();
				Vector3d vyN = edge.vecNormal();
				if (vyN.isCodirectionalTo(pn.vecZ()) && abs(vyN.dotProduct(ptMid-ptMids[x]))<dEps)
				{
					ptMid.vis(x);
					pn.vis(x);
					sip.stretchEdgeTo(ptMid,pn);	
					break;// breaking e	
				}				
			}// next e			
						
		}// next x plane		
*/
	}// end if  window
// a door was identified
	else if (nOpeningIndex>-1 && bIsDoor)
	{
	// find free direction and stretch sip to it
		int bIsStretched;
		Vector3d vecStretch;
		
		for (int e=0; e<edges.length();e++)
		{
			SipEdge edge = edges[e];
			Point3d ptMid =edge.ptMid();
			Vector3d vyN = edge.vecNormal();
		// calculate a normalize vector to the boundings if the segment is sloped
			if (!vyN.isParallelTo(vx) && !vyN.isParallelTo(vy))
			{
				vyN=ptMidOp-ptMid;
				
				vyN=qdr.vecD(vyN);
				vyN.normalize();
				ptMid.vis(20);
			}
			
			Vector3d vxN = vyN .crossProduct(vz);
		// count intersections with envelope in vyN	
			Point3d pts[] = Line(ptMid,vyN).orderPoints(plEnvelope.intersectPoints(Plane(ptMid,vxN)));
			int nNumEnvelope;
			for (int p=0; p<pts.length();p++)
			{
				double d = vyN.dotProduct(pts[p]-ptMid);
				if (d>dEps)nNumEnvelope++;	
			}
			
		// stretch edge to outside	
			if (nNumEnvelope<1)
			{
				edge.plEdge().vis(3);
				vyN.vis(ptMid,3);
				
				ptsOpening = Line(ptMid,vyN).orderPoints(ptsOpening);
				double dMax;
				if (ptsOpening.length()>0)
					dMax=abs(vyN.dotProduct(ptMid-ptsOpening[ptsOpening.length()-1]))+2*dRadius;
			
			// stretch
				if (dMax>0)
				{
					if (!bDebug) sip.stretchEdgeTo(ptMid,Plane(ptMid+vyN*dMax,vyN));	
					bIsStretched=true;
					vecStretch=vyN;
				}		
			}
			else
				edge.plEdge().vis(1);
		}// next e edge
		
	// add rounded opening
		if (bIsStretched)
		{
			PlaneProfile pp(plOpening);
			PLine pl = plOpening;
			pl.transformBy(vecStretch*3*dRadius);
			pp.joinRing(pl,_kAdd);
			//pp.vis(2);
		
		// get biggest ring
			PLine plRings[] = pp.allRings();
			int bIsOp[] = pp.ringIsOpening();
			PLine plShape;
			for (int r=0; r<plRings.length();r++)
				if(plRings[r].area()>plShape.area() && !bIsOp[r])
					plShape= plRings[r];
					
		// clean vertices			
			plShape.createConvexHull(Plane(ptCen,vz), plShape.vertexPoints(true));
			plShape.vis(2);
			
			plFillet = plShape;
		}// end if bIsStretched			
	}// end if // a door was identified
//______________________________________ end door ________________________________________________________________________________________
			
// calculate rounded pline____________________________________________________________________________________________________________	
	if (plFillet.area()>pow(dEps,2))
	{	
		int bDebugArc=false;	
		PLine plShape = plFillet;

	// get the planeProfile
		CoordSys cs(ptCen,vx,vy,vz);
		PlaneProfile ppOp(cs);
		ppOp.joinRing(plShape,_kAdd);
		ppOp.shrink(dRadius );
				
	// get shrink poly
		PLine plShrink;
		PLine plRings[]= ppOp.allRings();
		int bIsOp[] = ppOp.ringIsOpening();
		for (int r=0;r<plRings.length();r++)	
			if (!bIsOp[r])
			{
				if(plShrink.area()<plRings[r].area())
					plShrink= plRings[r];
			}			
		if (bDebugArc)plShrink.vis(3);

		
	// declare an array of points which define the segment intersection of two straight segments being tooled with an arc. Z-value will be replaced by radius of the arc
		Point3d ptsArcEdges[0];
			
	// get vertices
		Point3d pts[0];
		pts = plShrink.vertexPoints(false);
		Point3d ptsShape[] = plShape.vertexPoints(false);
	
		PLine plNewShape(vz);
	
	// loop segment wise, test for straights and arcs
		int bIsStraight[0];
		Vector3d vxSeg[0];
		Vector3d vySeg[0];
		for (int i=0;i<pts.length()-1;i++)
		{
			Point3d pt1 = pts[i];
			Point3d pt2 = pts[i+1];
	
			double d1 = plShrink.getDistAtPoint(pt1);
			double d2 = plShrink.getDistAtPoint(pt2);
			if (i+1==pts.length()-1)
				d2=plShrink.length();
	
			Point3d ptOn = plShrink.getPointAtDist((d1+d2)/2);
	
			//ptOn.vis(i);
			if ((ptOn-pt1).isParallelTo(pt2-ptOn))
			{
				bIsStraight.append(true);
				//PLine(pt1,pt2).vis(i);
			}
			else
			{
				bIsStraight.append(false);
				//ptOn.vis(1);
			}
			
		// collect vectors per segment
			pt2 = plShrink.getPointAtDist(plShrink.getDistAtPoint(pt1)+dEps);
			Vector3d vecX=pt2-pt1;
			vecX.normalize();
			if (bDebugArc)vecX.vis(pt1,4);
			vxSeg.append(vecX);
			Vector3d vecY=vecX.crossProduct(-vz);
			Point3d ptTest = ptOn+vecY*dEps;
			if (bDebugArc)ptTest.vis(4);
			if (ppOp.pointInProfile(ptTest)==_kPointInProfile)
				vecY*=-1;	
			if (ppOp.pointInProfile(pt1+vecY*dEps)==_kPointInProfile)
				vecY*=-1;
			vySeg.append(vecY);					
		}


	

		Point3d ptsNew[0];	
		for (int i=0;i<pts.length()-1;i++)
		{
			int x1 = i;
			int x2 = i+1;
			if (x2>=pts.length()-1)x2=0;
			Point3d pt1 = pts[x1];
			Point3d pt2 = pts[x2];
			
	
			Vector3d vecX = vxSeg[x1];
			Vector3d vecY = vySeg[x1];
			//vecX.vis(pt1,1);
			//vecY.vis(pt2,3);
			
	
			ptsNew=plNewShape.vertexPoints(true);
			if (bIsStraight[x1])
			{
				Point3d pt;
				if (ptsNew.length()<1)
				{
					pt=pt1+vecY*dRadius;
					plNewShape.addVertex(pt);
					ptsNew.append(pt);
					//pt.vis(6);
				}	
				pt=pt2+vecY*dRadius;
				if (bDebugArc)pt.vis(5);
				plNewShape.addVertex(pt);	
				if (bIsStraight[x2])
				{
					Point3d pt = pt2+vySeg[x2]*dRadius;
					if (bDebugArc)vxSeg[x1].vis(ptsNew[ptsNew.length()-1],1);
					if (bDebugArc)vxSeg[x2].vis(pt,4);
					plNewShape.addVertex(pt, dRadius, _kCCWise);
					
					
					if (!vxSeg[x1].isPerpendicularTo(vySeg[x2]))
					{
						Point3d ptEdge = Line(ptsNew[ptsNew.length()-1], vxSeg[x1]).intersect(Plane(pt, vySeg[x2]),0);
						if (bDebugArc)ptEdge.vis(3);
						ptEdge.setZ(dRadius);
						ptsArcEdges.append(ptEdge);
					}
					
							
				}				
			}
		// arced	
			else if (ptsShape.length()==pts.length())
			{
				Point3d pt;
				if (ptsNew.length()<1)
				{
					ptsNew.append(ptsShape[0]);	
					plNewShape.addVertex(ptsShape[0]);
				}
				Point3d ptOn = plShape.closestPointTo(ptsNew[ptsNew.length()-1]+vecX*2*dEps);//
				//plShape.getPointAtDist(plShape.getDistAtPoint(ptsNew[ptsNew.length()-1])-dEps);	
				if (bDebugArc)ptOn.vis(3);	
				pt=ptsShape[x2];
				plNewShape.addVertex(pt, ptOn);	
			}
	
	
			
			if (bDebugArc)
			{
				plNewShape.transformBy(vz*(2+i)*U(100));
				plNewShape.vis(i);	
				plNewShape.transformBy(-vz*(2+i)*U(100));
			}		
		}
		plNewShape.close();

		plNewShape.vis(3);
		if (!bDebug) sip.addOpening(plNewShape, true);
		
	}// end if valid plFillet

// this tsl is not resident
	if (!bDebug)
		eraseInstance();



#End
#BeginThumbnail
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
C^9KTZQM(+>!(+>)88@.%B`4?I4UJM2"5WOV*I4X2V7WG_]F6
`

#End
