#Version 8
#BeginDescription
DACH
Dieses TSL erzeugt eine Verbindung zwischen Stäben, Platten und Panelen gegen einen profilierten Stab (Stahlträger)
Gerade Balken werden automatisch gestreckt, alle anderen Objekttypen müssen als mit dem Träger kollidierende Bauteile gezeichnet werden.

EN
This TSL joins Beams, sheets or panels against a profiled beam (i.e. metal joist).
A straight beam will automatically be stretched while all other types need to be drawn with an interference to the female beam

#Versions
1.12 07.03.2022 HSB-14770: use envelopeBody  Author: Marsel Nakuci
Version 1.11    12.04.2021
HSB-11497 facet gap corrected , Author Thorsten Huck

bugfix TJI alike connections
bugfix drilled extrusion profiles





#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt eine Verbindung zwischen Stäben, Platten und Panelen gegen einen profilierten Stab (Stahlträger)
/// Gerade Balken werden automatisch gestreckt, alle anderen Objekttypen müssen als mit dem Träger kollidierende Bauteile gezeichnet werden.
/// </summary>

/// <summary Lang=en>
/// This TSL joins Beams, sheets or panels against a profiled beam (i.e. metal joist).
/// A straight beam will automatically be stretched while all other types need to be drawn with an interference to the female beam
/// </summary>

/// History
// #Versions
// 1.12 07.03.2022 HSB-14770: use envelopeBody  Author: Marsel Nakuci
// 1.11 12.04.2021 HSB-11497 facet gap corrected , Author Thorsten Huck
///<version  value="1.10" date="03may18" author="kris.riemslagh@hsbcad.com"> bugfix corner beamcuts </version>
///<version  value="1.9" date="08jan18" author="thorsten.huck@hsbcad.com"> bugfix TJI alike connections </version>
///<version  value="1.8" date="27oct17" author="thorsten.huck@hsbcad.com"> bugfix drilled extrusion profiles </version>
///<version  value="1.7" date="26apr16" author="thorsten.huck@hsbcad.com"> bugfix location facet beamcuts, cut only added for beam males </version>
///<version  value="1.6" date="26feb16" author="thorsten.huck@hsbcad.com"> bugfix facet beamcuts on asymmetric intersections </version>
///<version  value="1.5" date="07oct14" author="th@hsbCAD.de"> bugfix if axis of female beam is not centered with envelope body </version>
///<version  value="1.4" date="07jan14" author="th@hsbCAD.de"> bugfix for facets of certain profiles </version>
///<version  value="1.3" date="26sep13" author="th@hsbCAD.de"> tolerance issue for meter drawings solved </version>
///<version  value="1.2" date="10sep13" author="th@hsbCAD.de"> bugfix facet beamcut </version>
///<version  value="1.1" date="05sep13" author="th@hsbCAD.de"> bugfix panel/sheets </version>
///<version  value="1.0" date="04sep13" author="th@hsbCAD.de"> initial </version>

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

	category = T("|Gaps|");
	PropDouble dGapLength(0, 0, T("|Length|"));
	dGapLength.setCategory(category);
	dGapLength.setDescription(T("|Defines the gap in length in relation to the cross piece|"));
	
	PropDouble dGapTopVertical(1, 0, T("|Top Vertical|"));
	dGapTopVertical.setDescription(T("|Defines the vertical gap to the flange|") + " " + T("|on the top side|"));
	dGapTopVertical.setCategory(category);
	
	PropDouble dGapTopHorizontal(2, 0, T("|Top Horizontal|"));
	dGapTopHorizontal.setDescription(T("|Defines the horizontal gap to the flange|") + " " + T("|on the top side|"));
	dGapTopHorizontal.setCategory(category);
	
	PropDouble dGapBottomHorizontal(3, 0, T("|Bottom Horizontal|"));	
	dGapBottomHorizontal.setDescription(T("|Defines the horizontal gap to the flange|") + " " + T("|on the bottom side|"));
	dGapBottomHorizontal.setCategory(category);
	
	PropDouble dGapFacet(4, 0, T("|Facet|"));	
	dGapFacet.setDescription(T("|Defines the gap of detected facets|"));
	dGapFacet.setCategory(category);
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	
		
		if (_kExecuteKey.length()>0)
			setPropValuesFromCatalog(_kExecuteKey);
		else
			showDialog();
			
	// separate selection
		PrEntity ssMale(T("|Select male beams, sheets or panels|"), GenBeam());
		Entity entMales[0], entFemales[0];
		if (ssMale.go())
			entMales= ssMale.set();

		PrEntity ssFemale(T("|Select female (profiled) beams|"), Beam());
		if (ssFemale.go())
		{
		// avoid females to be added to males again
			Entity ents[0];
			ents = ssFemale.set();
			for (int i=0;i<ents.length();i++)
				if(entMales.find(ents[i])<0)entFemales.append(ents[i]);		
		}

	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[2];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;

		dArProps.append(dGapLength);
		dArProps.append(dGapTopVertical);
		dArProps.append(dGapTopHorizontal);
		dArProps.append(dGapBottomHorizontal);						
		dArProps.append(dGapFacet);	
		

	// loop males
		for (int i=0;i<entMales.length();i++)
		{
			GenBeam gb= (GenBeam)entMales[i];
			if (!gb.bIsValid())continue;
			gbAr[0] =gb;
			int bIsBeam = gb.bIsKindOf(Beam());
			Vector3d vxMale = gb.vecX();
				
		// loop females
			for (int j=0;j<entFemales.length();j++)
			{
				Beam bmFemale = (Beam) entFemales[j];
				Vector3d vxFemale = bmFemale.vecX();
				if (bIsBeam && vxMale.isParallelTo(vxFemale))continue;
				
				gbAr[1] = bmFemale;
				// create new instance	
				tslNew.dbCreate(scriptName(), vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance				
			}// next j			
	
			
		}// next i
		
		eraseInstance();
		return;
	}	
	
// male and female
	GenBeam gb0 = _GenBeam[0];
	GenBeam gb1 = _GenBeam[1];	
	Point3d ptCen0 = gb0.ptCenSolid();
	Point3d ptCen1 = gb1.ptCenSolid();//ptCen1 .vis(211);

// check type of male, flag if cutting tool may stretch
	int nMaleType; // 0= panel or sheet, 1 = beam, 2 = curved beam
	int nStretch;
	CurvedStyle curve;
	if (gb0.bIsKindOf(Beam()))
	{
		nMaleType++;
		Beam bm = (Beam)gb0;
		if (bm.curvedStyle()!=_kStraight) 
		{
			nMaleType++;
			curve = CurvedStyle(bm.curvedStyle());	
		}	
		if (nMaleType==1)	nStretch=1;	
	}

// genBeam vecs and quaders
	Quader qdr0(ptCen0, gb0.vecX(),gb0.vecY(),gb0.vecZ(),gb0.solidLength(), gb0.solidWidth(), gb0.solidHeight(),0,0,0);
	Quader qdr1(ptCen1, gb1.vecX(),gb1.vecY(),gb1.vecZ(),gb1.solidLength(), gb1.solidWidth(), gb1.solidHeight(),0,0,0);

	qdr0.vis(1);
	//qdr1.vis(222);

// male genBeam vecs 
	Vector3d vx0,vy0,vz0;
	vx0 =  gb0.vecX();
	vy0 =  gb0.vecY();
	vz0 =  gb0.vecZ();
	
// standards
	Vector3d vx,vy,vz;
	vx = _Z1;
	vz = gb1.vecD(_Z0);
	Plane pnRef =Plane(ptCen1-vx*.5*qdr1.dD(vx), vx);
	
// for sheets and panels the coordSys needs to be evaluated
	if (nMaleType==0)
	{
		_Pt0 = ptCen1;
		Vector3d vxTest = qdr0.vecD(gb1.vecX());
		Vector3d vyTest = qdr0.vecD(gb1.vecY());//_Y1);
		Vector3d vzTest = qdr0.vecD(gb1.vecZ());//_Z1);
		//vxTest.vis(gb1.ptCen(),1);	
		//vyTest.vis(gb1.ptCen(),3);	
		//vzTest.vis(gb1.ptCen(),150);	
		
		vx = qdr1.vecD(vyTest);
		if (vx.dotProduct(ptCen1-ptCen0)<0)vx*=-1;
		vz = gb1.vecD(vzTest);
		
		_Z1=vx;
		_X1=vx.crossProduct(-vz);	
		
		vx0 = qdr0.vecD(vx);	
		vz0 = qdr0.vecD(vz);
		vy0 = vx.crossProduct(-vz0);
		pnRef=Plane(ptCen1-vx*.5*qdr1.dD(vx), vx);				
		
		_X0 = vx0;	
	}
	_Pt0 = Line(ptCen0,vx).intersect(pnRef,0);
	/*else if (nMaleType==1 )//&& _bOnDbCreated)
	{
		if (_kExecutionLoopCount==0)
		{
			gb0.addTool(Cut(_Pt0,_Z1),1);
			setExecutionLoops(2);
			return;
		}
	}*/

	vy = vx.crossProduct(-vz);
	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);		


	Vector3d vx1,vy1,vz1;
	vx1 =  gb1.vecX();
	vy1 =  qdr1.vecD(vx);
	vz1 =  qdr1.vecD(vz);




// Display
	Display dp(252);
	if (_bOnDebug)dp.draw(scriptName(), _Pt0, _XW,_YW,0,0,_kDevice);

// create a body extending the male to the opposite side of the female beam
	Body bdTestMale(ptCen0, vx0,vy0,vz0, gb0.solidLength()*6, gb0.solidWidth(), gb0.solidHeight(),0,0,0);	
	bdTestMale.addTool(Cut(_Pt0+vx*qdr1.dD(vx),vx),0);
	if (nMaleType==0)// sheet or panel
	{
		bdTestMale=gb0.envelopeBody();	
	}
	else if (nMaleType==2)// curved
	{
		PLine plClosed = curve.closedCurve();

		//plClosed.transformBy(gb0.coordSys());
		CoordSys cs;
		cs.setToAlignCoordSys(_PtW,_XW,_YW,_ZW, gb0.ptRef(), gb0.vecX(),gb0.vecZ(),-gb0.vecY());
		//plClosed.vis(3);
		plClosed.transformBy(cs);
		//plClosed.transformBy(gb0.coordSys());
		bdTestMale = Body(plClosed, vy0*gb0.solidWidth(),0);
		//plClosed.vis(3);
		
	}
// get envelope of female
	Body bdFemale= gb1.envelopeBody();//(gb1.ptCenSolid(), gb1.vecX(),gb1.vecY(),gb1.vecZ(), gb1.solidLength(), gb1.solidWidth(), gb1.solidHeight(),0,0,0);	;// 

// invalidate if no intersection found
	if (!bdFemale.hasIntersection(bdTestMale))
	{
		reportMessage("\n" + T("|No intersection found between|") + " " + gb0.posnum() + "/" +gb1.posnum() + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}	
	//bdTestMale.vis(2);
	
// the intersecting body
//	Body bd1 = gb1.realBody();
// HSB-14770
	Body bd1 = gb1.envelopeBody(true,true);
	Body bdInt = bd1;
	bdInt.intersectWith(bdTestMale);
	//bdInt.vis(3);	

// get contacting profile in X	
	PlaneProfile ppContactEnv = bdTestMale.getSlice(pnRef);//gb0.envelopeBody().shadowProfile(Plane(_Pt0,_X0));
	//ppContactEnv.project(pnRef, _Z1,dEps);
	//getSlice(pnRef);
	//pnRef.vis(6);
	PlaneProfile ppContact=ppContactEnv;	
	PlaneProfile ppFemale = bdFemale.extractContactFaceInPlane(pnRef, dEps*2);ppFemale.vis(1);
	ppContactEnv.intersectWith(ppFemale);
	ppContact.intersectWith(bd1.extractContactFaceInPlane(pnRef, dEps));
	//ppContactEnv.transformBy(vz*U(300));ppContactEnv.vis(4);
	//ppContact.vis(2);

// just add a cut if the envelope and the real contact face match. this happens i.e. when touching on the back of C-side profile
	if (abs(ppContactEnv.area()-ppContact.area())<pow(dEps,2))
	{
		Cut ct(_Pt0, vx);
		gb0.addTool(ct,nStretch);// stretches only beams which are not curved
		PLine plCirc;
		double d = U(20);
		if (gb0.dH()<d)d=gb0.dH();
		if (gb0.dW()<d)d=gb0.dW();
		plCirc.createCircle(_Pt0,vx,d);
		dp.draw(plCirc);
		return;	
	}


// the intersecting body
	Body bdIntEnvelope = bdFemale;	
	bdIntEnvelope.subPart(bd1);
	bdIntEnvelope.intersectWith(bdTestMale);
	//bdIntEnvelope.vis(4);
	
// decompose and get closest lump
	Body bdLumps[] =bdIntEnvelope.decomposeIntoLumps();
	for (int i=0;i<bdLumps.length();i++)
		for (int j=0;j<bdLumps.length()-1;j++)
		{
			double d1 = _X0.dotProduct(bdLumps[j].ptCen()-gb0.ptCen());
			double d2 = _X0.dotProduct(bdLumps[j+1].ptCen()-gb0.ptCen());
			if (d1>d2)
				bdLumps.swap(j,j+1);	
		}
	if (bdLumps.length()<1)
	{
		reportMessage("\n" + T("|No intersection found between|") + " " + gb0.posnum() + "/" +gb1.posnum() +  " (2)" + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;			
	}
	Body bdThis = bdLumps[0];	

// subtract the female realbody without any tools
	{
		PlaneProfile ppProf = gb1.realBody().shadowProfile(Plane(ptCen1, gb1.vecX()));
		//ppProf.vis(4);
		Body bdProf;
		PLine plRings[] = ppProf.allRings();
		int bIsOp[] = ppProf.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
			{ 
				bdProf.combine(Body(plRings[r], gb1.vecX() * gb1.solidLength(), 0));
			}
		//bdProf.vis(4);
		bdThis.subPart(bdProf);
	}

	
	
	
// cut/stretch male to extremes and get ref point
	Point3d ptRef;
	if (nMaleType>0)
	{
		Point3d pts[] = bdThis.extremeVertices(_X0);
		if (pts.length()>0)
		{
			ptRef = pts[pts.length()-1];
			Point3d pt = ptRef-vx*dGapLength;
			//pt.vis(3);
			Cut ct(pt, vx);
			gb0.addTool(ct,nStretch);// stretches only beams which are not curved
			bdThis.addTool(ct,0);
		}	
	}
	//bdThis.vis(1);
	//ptRef.vis(2);

	
	PLine plRings[] = ppContact.allRings();
	int bIsOp[] = ppContact.ringIsOpening();
// collect ref points bottom and top from all rings	
	Point3d ptRefBottom,ptRefTop;
	int bHasBottomRef, bHasTopRef;
	Line lnZ(_Pt0,vz);
	for (int r=0;r<plRings.length();r++)
	{
		if (bIsOp[r])continue;
		LineSeg seg = PlaneProfile(plRings[r]).extentInDir(vz);
		Point3d ptMid = seg.ptMid();
		Point3d pts[] = {seg.ptStart(), seg.ptEnd()};
		pts = lnZ.orderPoints(lnZ.projectPoints(pts));
		// bottom	
		if (vz.dotProduct(ptMid-ptCen1)<0)
		{
			Point3d pt = pts[1];
			if (!bHasBottomRef || (bHasBottomRef && vz.dotProduct(ptRefBottom-pt)>0))
				ptRefBottom=pt;
			bHasBottomRef=true;
		}
		// top		
		else
		{
			Point3d pt = pts[0];
			if (!bHasTopRef|| (bHasTopRef&& vz.dotProduct(ptRefTop-pt)<0))
				ptRefTop=pt;
			bHasTopRef=true;
		}
	}	
	
// order ref points and keep only most top and most bottom
	if(bHasBottomRef) ptRefBottom.vis(1);
	if(bHasTopRef) ptRefTop.vis(2);
		
	
// get X-shadow
	PlaneProfile ppShadow = bdThis.shadowProfile(Plane(bdThis.ptCen(),_X1));
	//ppShadow.vis(1);	
		
// get all rings and evaluate all relevant segments for tooling
	plRings = ppShadow.allRings();
	bIsOp = ppShadow.ringIsOpening();
	LineSeg segs[0], segsDisplay[0];
	Vector3d normals[0];
	for (int r=0;r<plRings.length();r++)
	{
		if (bIsOp[r])continue;
		PLine pl = plRings[r];
		pl.convertToLineApprox(dEps);
		pl.vis(r);
		Point3d pts[] = pl.vertexPoints(false);
		for (int p=0;p<pts.length()-1;p++)
		{
			Point3d pt1 = pts[p];
			Point3d pt2 = pts[p+1];
			LineSeg seg(pt1,pt2);
			Point3d ptMid =seg.ptMid();
			Vector3d vxSeg = pt2-pt1;
			vxSeg.normalize();
			Vector3d vySeg = vxSeg.crossProduct(_X1);
			if (ppShadow.pointInProfile(ptMid+vySeg*dEps)!=_kPointOutsideProfile) vySeg*=-1;
			
			if (!vySeg.isCodirectionalTo(-vx))segsDisplay.append(seg);
			
		// ignore segments perp to _X0 and codirectional with _X0
			double d = vySeg.dotProduct(vx);//
			if ((!vySeg.isPerpendicularTo(vx)&& vySeg.dotProduct(vx)<0 ) || vySeg.isParallelTo(vx))
			{
				//vySeg.vis(ptMid,10);
				continue;	//
			}
			vySeg.vis(ptMid,3);	
			
			segs.append(seg);
			normals.append(vySeg);
		}	
	}// next r		

// loop all segments / normals to identify upmost and lowest
	int nFlip=1;
	Point3d ptsFace[0]; // collector of face ref points
	for (int x=0;x<2;x++)
	{
		int nInd=-1;
		double dMax;
		for (int i=0;i<segs.length();i++)
		{
			double d = normals[i].dotProduct(nFlip*qdr1.vecD(vz));
			if (d>dMax)
			{
				nInd = i;
				dMax = d;	
			}
		}
		
	// add vertical beamcut
		Vector3d vecX=vx;
		Point3d ptBc;
		if (nInd>-1)
		{
			LineSeg seg = segs[nInd];
			//seg.vis(5);
			

			Point3d ptMid = seg.ptMid();		
			Vector3d vecZ = normals[nInd];
			Vector3d vecY = _X1;
			vecX = vecY.crossProduct(-vecZ);
			if (vecX.dotProduct(vx)<0)
			{
				vecX*=-1;
				vecY*=-1;	
			}
			
		// remove this seg from the list, remaining segs will be treated as facets
			normals.removeAt(nInd);
			segs.removeAt(nInd);	
					
			//vecX .vis(ptMid,10);	vecY.vis(ptMid,96);	vecZ.vis(ptMid,160);	
	
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()))*2;
			double dY = gb1.solidLength();
			double dZ = bdThis.lengthInDirection(_X1)*2;
		
		// add vertical beamcut if not parallel with vx	
			if (dX>dEps && dY>dEps && dZ>dEps && !vecX.isParallelTo(vx))
			{
				ptBc = ptMid+vecY*vecY.dotProduct(gb1.ptCen()-ptMid) -vecX*.25*dX;
			// offset for top beamcut	
				if (x==0)
					ptBc.transformBy(-vecZ*dGapTopVertical);				
				BeamCut bcVertical(ptBc, vecX, vecY, vecZ, dX, dY, dZ, 1,0,1);
				bcVertical.cuttingBody().vis(2);
				gb0.addTool(bcVertical);
				ptBc.vis(4);	
			}
		}// END IF valid index
		
	// add bottom and top beamcut	
		double dX = gb1.solidLength();
		double dY = qdr1.dD(vy1);
		double dZ = (qdr0.dD(vz1)+qdr1.dD(vz1))*2;	
	
		Point3d ptFace =bdFemale.ptCen()+nFlip*qdr1.vecD(vz)*.5*qdr1.dD(vz); 	
		if (x==0 && bHasTopRef) 
		{
			dY+=dGapTopHorizontal*2;
			ptFace.transformBy(vz*vz.dotProduct(ptRefTop-ptFace));
		}
		else if (x==1 && bHasBottomRef) 
		{
			dY+=dGapBottomHorizontal*2;
			ptFace.transformBy(vz*vz.dotProduct(ptRefBottom-ptFace));
		}
		
	// in case of a non vx-parallel upper/lower segment transform face to intersection
		if (!vecX.isParallelTo(vx))
		{
			Point3d pt = Line(ptBc,vecX).intersect(Plane(ptFace,vx),-.5*dY);//pt.vis(1);	
			double dMove = (nFlip*vz).dotProduct(pt-ptFace);
			if (dMove<0)ptFace.transformBy((nFlip*vz)*dMove);	
		}
		else if (x==0)
		{
			ptFace.transformBy(-vz*dGapTopVertical);	
		}	
		ptsFace.append(ptFace);
		ptFace.vis(2);
		
		if (dX>dEps && dY>dEps && dZ>dEps)
		{		
			BeamCut bcFace(ptFace, vx1,vy1,vz1, dX, dY, dZ,0,0,nFlip);
			bcFace.cuttingBody().vis(x);
			gb0.addTool(bcFace);
		}
		
		nFlip*=-1;	
	}// next x	

// collect vertices of remaining segments and find the one closest to the ptsFaces
	{
		int nDir=-1;
		if (segs.length()>0)
		for (int i=0;i<ptsFace.length();i++)
		{
			nDir*=-1;
			Vector3d vecDir = _Z1+nDir*vz;
			vecDir.normalize();		
			
			Point3d ptFacet;
			Vector3d vecNFacet;
			double dMin;
			int bFoundOne = FALSE;
			for (int s = 0; s < segs.length(); s++)
			{
				Vector3d vecNSeg = normals[s];
				Point3d ptSeg = segs[s].ptStart();
				// KR: make sure the ptsFace[i] is visible from segment on the vecNSeg side
				if (vecNSeg.dotProduct(ptsFace[i] - ptSeg) < 0)
					continue;
				
				for (int b = 0; b < 2; b++)
				{
					Point3d ptP = (b==0) ? segs[s].ptStart() : segs[s].ptEnd();
					double d=(nDir*vz).dotProduct(ptsFace[i]-ptP);
					if ( !bFoundOne || d < dMin)
					{
						dMin = d;
						ptFacet = ptP;
						bFoundOne = TRUE;
						ptP.vis(2);
					}
				}
			}
			if (!bFoundOne)
				continue;
				
			ptFacet.transformBy(vx1*vx1.dotProduct(ptCen1-ptFacet));
			ptFacet -= vecDir * dGapFacet;			
			vecDir.vis(ptFacet,i);	

			Vector3d vecX, vecY, vecZ;
			double dX, dY, dZ;
			vecZ = vecDir;vecZ .normalize();
			vecX = vx1.crossProduct(vecZ);	
			vecY = vecX.crossProduct(-vecZ);
			
			Point3d ptInt = Line(ptFacet,vecX).intersect(pnRef,0);ptInt.vis(22);
			dX = (ptInt-ptFacet).length()*2;
			dZ = qdr1.dD(vecZ);
			dY = gb1.solidLength();					


// add facet beamcut
			if (dX>dEps && dY>dEps && dZ>dEps)
			{	
				BeamCut bc(ptFacet, vecX, vecY, vecZ, U(10e3), dY, dZ, 0,0,1);
				bc.cuttingBody().vis(3);
				gb0.addTool(bc);
			}
		}
	}

// draw symbol
	dp.draw(segsDisplay);

		
		
	



	
	
	
		
	








#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`:P!K``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*8T,3L6:)&)[E0:?10!%]
MF@_YXQ_]\BC[-!_SQC_[Y%2T4`1?9H/^>,?_`'R*/LT'_/&/_OD5+10!%]F@
M_P">,?\`WR*/LT'_`#QC_P"^14M%`$7V:#_GC'_WR*/LT'_/&/\`[Y%2T4`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`,ED$,+RMG
M:BECCT%>>R_&'1]FZWT^]D!&5+;%!_4UZ&Z"2-D/1@0:^1K.Y,,,UI)]^U<Q
M_4`X'\L5A7E**3B>ME-##UYRC77H>NWWQFN9,1:=H\22L<!YYBX'X`#^==!\
M._'Y\5O=6-V8OMMN2VZ,;0ZYQT]OU_"O!G*K#+NG\J4Q@LV"=BD^W<TSP_J5
MWH&M0ZAI,ZR3PY8J5*AE'4'/MQ^-8PJRO=L]3$Y?04/9TX)-];W:[:7OZ_YH
M^NJ*PO"/BBT\7>'X=3M?E)^26+.3&XZC^OXUNUV)W5T?+S@X2<9;H****9(4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5\K^*_#TV
MD>.]4M'/DM),\\71@T;,64_S_*OJBO+OBIX&U'7;RTUS20C36L)BE@`)>8%O
ME"XXXW-UK.K%N.AW9?5A3KISV9XM-"L4<X<[F8+O/3=\PS1%'!;R6<T2[1(Q
M5QG/'2NXT7X::[<:]:Q:]ID\6G3@B5HI4++W&<$XY`KOKCX,>%YK?RHWOX&'
MW72?)!]<$$5RQHSDCWJV9X>E45M>UM>MS=\'>#]+\+6SR:3+="&\5'>*60,N
M<<$<9!P<5T]5M/M38Z=;6AE:4P1+'YC#!;`QD_E5FNU*R/EJDN:3=[A1113(
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HICS11_?E1?]Y@*@?4K-.LZG_=R:`+5%9KZU;*<*LC>X''\ZJR
M:W*>$C5?>@#<HKG?[7NL_?!_`?X5(NMS]"BDG@4`;U%8JZZ>K0\>U2C6X>\;
M_@!_C0!JT5G#6K4]1(/JM/&KV9ZR$?530!>HJH-3LVZ3K^((IXOK4]+B/\6Q
M0!8HJ(7,#=)HS]&%2!U;HP/T-`"T444`%8/BO77T335-NNZ[N&\N$8S@]SCO
M_B16]7'^-TN!=:-<6]I+<_9YFD98T)Z%3C@<9Q0!F)HOC6]432ZB\);G8UP5
M(_!1@5)9ZKKWAK4[>WUUS/:7#;!(6#;3GJ#U[\@U?_X32_\`^A9OO_'O_B:P
M/%.L7FM6]MYNCW-FD,FXO("0<_@*8'I]%(/NCZ4M(`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBFM(B_>=1]30`ZBJCZG:1]9?R4FH'UJW`.
MV.1OP`H`TJ*Q7UQC_JX<?5O_`*U59-2NY,CS"/\`=XH`Z2HWGAC^_*@^K"N6
M>:5_OR,WU8G-,].Y_G0!T4FJVT>0&+'VJM)K>#A(<^Y:L<\"D_*@#1?6;EA\
MHC7Z#-5I+^ZD^](?P`%5^..:3I[T`.9V8DDEOJ:3IG]:,Y&:,DCZ4`)CU]:3
M`S2X[48XZT`!&3CGTS1D9R/K]:.X-!-`"$]Z7.2./SJ.2>*(9=U'ZU7?4K<'
MY=S?08_G0!;Z4OMBLJ35&(PB;?J<U`9[F<X!D.>RY_E0!MO(B??=5^I%5I+Z
M&/HVYO05%;:#J5R,K"%'J[`?_7K3@\'S$@SW2*.ZHI/^%`&0VJRY_=H%'J3F
MD6\OIW"(TA]D'-=A:^'K"V',0D;U<9'Y5II&D8PB*H]%&*`(K(,+"W#YW>4N
M<]<XJ>BB@`K+UK7[+08XGO/,)ER$6-<DXQGV[UJ5EZWH-EKMND=V'#1Y,;HV
M"I/7V/3O0!STGB77M8C/]B:4\,.,_:9\=/;/'\ZPM#TN^\932S7VIR^7;LN0
MWS')YX'0=*V(O!^L:<#)H^N!D(.$<$*1^H/Y5GZ/<ZCX+:YCO-+>6&9US)'(
M"%(]QGU[XI@>E#@44#D9HI`%%%%`!1110`4444`%%(6"C).!5>2_MH\@R`D=
MA0!9HK,?6H%^[&Y^N!4+ZU(1\D*CTR<T`;-'2N>DU2Z<<,$/M51W>3F1RW>@
M#IVN8$X::,'T+"H'U2T0<2;C[`USG&1UI0`>E`&Q)K8!(CB.>V>]56U>[;IL
M7MPO^-4>Q%&>1S0!.]]=2#YIY!]./Y5"SLYRS%C_`+1S32,@9_"EP1VXH`;Q
MCT]L4O)/2E_A]3[4G!QS^%``!S[48Z]Z!P>O-+T[T`)CO1W/I2XZ4G6@`Q^/
MTI,`>E&#G))SG\Z/H/>@!/H*,'\JCFNH8?\`6R*#Z5EW7B.VM]VR*20CCL!^
M=(#9[XZ>N:",XR356SU**>!)7A8;AG`?_P"M6C%J-JN/W3C\JYYXB,=E<U5)
MO<AVM_=)]*7RI#T0GZ<5>2\MW'7'U%3))"WW6!KGEB:CVT-8TH+?4R7MKJ3A
M!L]^#43Z-?./^/QORQ_+%="I&.,4O7UK.-:HOM%24']DY-_#MYDG<KGZ_P"-
M9]UI>LPG$.G&4?WA(O\`+-=[L^@H&!W_`"K18J:,_9Q/-?L6O;?WEA)'_N1Y
M_EFO0?#5M''HEJTL*+<X.\LF'SD]>]6>/0F@G'H*M8M]4+V2-*BLOH<Y-/\`
M.D4<$BJ6+75"]B^C-&BL\74H[@_6GK>2?Q!?RJUBH,7LI%VBJGVW'51^=6(I
M!+&'`QFM8583=HLAP:U8^N2\:7ERTEAHUO((A?R;)).X&0,?KS76UC>(M`37
M;-0LABNH3N@E!^Z??VXK0DM:-IBZ/I<5BLSS+'G#,`#R<X_6N,U^VN/"6J)K
M-I>/*;J5O.BD`PW?!QV_EQ27^K>,-#B7[;+:F/.U9&*$M^'!/Y4W2(9?%^H1
MOK.I0RI`-R6L3`,?J`.G'N?I3`]#C?S(U<#`8`TZCI12`****`*;ZI:*2-Y8
MCT4U6DUJ/'[N-C_O8']:Q<]3^M`Y[<T`:#ZO<O\`<(3Z#-5I+ZY<<SO^!Q4/
M(/\`.D)&>F:`',Q;EB2?>F]#_P#7H]!BC^E`"Y./Z4`\8SC\:0]*#^%`#N,T
MTGK1NZ<$TGTH`<#QS2=O\\48YSFC[O3CUH`,9&.N>U'8<<4=B,?E2]O2@`R>
MGI0<<G-`Q]#2$=STH`#CFER,<9_QJ![JWBY:1<^@.:J2:N@!\N/(_P!HT@-(
M9]\TC%5&20/7)K$DU:Y(XVJ/855>XEF;+LQ^E%PL;TE[;1Y!E4X[`Y_E5>75
MX%X0,WX5B,0HW2.$'JQQ6=<ZS86V,3"4G^X0W\J5[#L;TNK7#?=_=CZ`U5>Z
MFE^_([?CQ7*S>)Y68B&V4>A=B?TXJJ^KW\_!E"KZ*H'_`->H<T-19T\MS%""
M9'1?J>?RKF=9\26D"R*D=W*P'\%NV/S(`IL(+-\Q8_4UKVL43*`\:M]1FH=5
MKH7R(U/#.IK>^'[.<9&Y.C=16ZLH_O<UD6JI&@1%55'0*,"M",#&<5R25W<V
M31=28#J>:E648ZXJM&`1TJ95QVJ;%71.LN.A(]ZD6ZD'W97_`#-1(HZ$5(%%
M39CNB7[9..DA/UYIZZA<*.N?P%1;12[!BE8+HLKJ!_C7/XU*NHQ>F*H;1BD$
M:YH'H:/]H0G^,C\*>+F-NC`_6LGRP2<4X`KTZTA\JZ&KYH/\:_G1NSW)^E9J
MN0.14Z2<#F@"X`3T6M.T!%L@/7G^=8PE/9JV+,[K1"3GK_.NG"?&_0PK/W2>
MH9KRUMF"SW,,3$9`=PN?SJ:L?6_#5AKSPO=F56A!"F-@,@XZ\>U>@<QQ9AL]
M:\=7L>KW@-LH8PL)0%(XV@'TP2:;XGTK2-(MK6ZT6Z/VOSL`1S[R."<\=.<?
MG5F+P]X:DUR[TO-\#:Q^8\WF+L`&,YXXQFN>1]`:^*M:7JV1;;YPG!8>Y&W'
MX4Q'L%F938VYG_UQC7S,_P!['/ZU-4=N$%M$(VW1A!M;U&.#4E(84444`<%'
MJUJ^/F93Z$596[@DY208]^*Y^6W>WD,<L!CD'4$8(IA)Z#/XT`=.&Z8((]N:
M7VZUS2SRIC;(X/L34ZZA<KC$V?KB@#=/0C%`!//I62FK3#[\:GW`JQ'J\3?>
M4JWO0!?VGUI=N.:KK?6K])DS[\?SJ4SQ;=PD3'<[N*`'$8QS2X`'3\<U6>_M
MHQ_K0Q]N:K2:H^/W4/XM2`TL=*0G;@DA?Q%8SZA<-UE5/90*KO.7ZL\GNY-%
MPL;3WL$9(,F2.P!-5VU1!]R,M_O$"LHNVT\JJ^H%4I]1L(21-=IGTW9/Y"E<
M9K3:G,P(\P(/]GK^=56D>3EF=\]R<US]QXGM8LBVA\P_WB,#]:RYO$VI2$^6
MZ0C_`&$_QS0!V+91<L54>K,!6=<Z]IMJ2)+C<P_A1"<_CTKC+B\O+K_7W4T@
M]"YQ^55=GMQ0!U<WC.!.+>Q=S_>D8+^G-85]XFU.[#*)C$I/`C.TC\15`H,\
MFHV0>E,"*":6740TTKR,P/+,2>A]:U,"LR``7\7'?'Z5M",'M6-3<N.PQ4%3
MQI2I$,CBK4<0]*RN786%<&M*#(`JO%&!VJ["HXJ&RD7H),=0:OQS<=#5"*KD
M=0QJQ;BFP.AJPD^#TJHAXXJPIJ1Z%A9<G.#4JS>QJ!2*E4C'I2*T)O-!]:4/
M]:B5AG%/##UXJ0%)..*3YNM.WCM1N&.M(JXT.P/2I5<9Z8IB\FG%>:!W3)QR
M*7:,#FH`''2GAW'446$2E,]#6Q8MMLHP??\`F:PQ-CJ*U+:4&V3'O_.NG"_&
M_0QK7Y=2_P"9[TN^J@D%2*X`W,P`[9.*[SF//?$%CJNF:SJ<EM&6M]1!4N!G
M*D@D>QSD4RZMS8^`XK/$;W5Q="2148,4';..G0?G27NF2:[XUO;6ZNA#P6B8
MC<"HQ@#GT.?P-7C\.X0/^0NG_?H?_%47"QW&G1&UTNTMV.6CA1"<]P!5H'(J
M"%!'!&@.=BA<^N!BI`V*5QV'\TPOS2@T'!'(I7"Q1UO2EU*S;'$R#*'^E>;7
MEREK;/-(IVH,\=Z]<KS+QQ8K`\R*N%?#@`<8Y']*H1P2^)]2,N[RX-O]W#?X
MU>B\3R'`ELQGU5__`*U4/+5>@&:8R,:5P.AB\06KG#>9%_O`8_G6A%>07"CR
MI4<>U<6T>.3@U&R^@_*BXSO0V?X3^-.1@I+'FN$BGNX?N7$J?1R*MQZQ?IQY
MY;CC*C_"BX'9^:3]U?QJM<W45LN;B8(/0UR$NH7TW^LN9,>BG`_(55*]?7U-
M2,Z6;Q':QL5AADD([\`'\:H3>)KIN(HHXQ[DD_TK($;'Z>U+L`Z8IB%N+NXN
MR?.F9\G.#4`2K`0#G!/UHQ@=<?2@"#RLTH0"IMH/3)^M-(/:@"(KZ5&0,^M3
M%3GO32,4`0E3ZU$8QGN:L$9[4TKZT`5`NV[B/'WQ_.ML(:QY,+*K#G#`Y_&N
MC5!Z5C5W1<&0)G<!BK29':A4YZ5.JUBS2XZ-2?:K<:GCFHHQ5F/%2QW)XPWJ
M*M(&ZY%01U:3VJ6AW)8RWM4Z[L]14<=3I4V'S#EW^U/&\=J5>HS4W%*P^8BC
M9F8Y%2KGTIRJ!3@*5A\P@6EV#/>GTA)S2L-,%!%3*W3-1;A3@/0T#994\4[(
M-5AO]:>'([4$6)A@U8B?;&%JFDOKG\JF60;<BNC"_&_0SJK0N*Q9@H_&L;Q)
MX=.NS6\B7`A,2E3E-V1G([CWK6C+(.G)ZU,@9\@$#T)KLYM3&QPI\"N&P=27
MZ^3_`/94]?`+2#`U11_VP/\`\57731O#]\8SW[&HPSCE357%8U85,4$:9SM4
M+GUP,4_S/45FQWLB<%0:N0SK,,G&:EE(G5QGK^%/W>M1;%SD<4N2*FX[%JN-
M\<VXD$!_YZ(R?D0?ZUV5<[XPBWZ;#(/X)?T(/^%:F9X[L/7%(R>I%6IH@L\B
MLW`8C%,(`'R@5(RH8QV%-,1/?%6R,^I^E-*<=*`*ODXI/+]!5G:`/6D(]`!0
M!7\L=R?PH\L#H/UJ8\CDTTJ2.PH`A*>O2@`#H*E*8ZFDZ]!0!&5]:-O'`_.I
M-K>PI,#ZT`1D`=\FFX_"I&#>H4>W--VXXZT`1$`^III%2D#/)S3"?2@"/'%,
M('I3SSZTA!^E`%2Y^Z<#M701N64''6L.=?E/.>*U[-B]K&V.HK*KT+@6D9L]
M*G4GTJ%"0>E3(Q]*P-"9"<]*G4GBH$;GI4Z/[5(T649L581V]*K(]3HWM4C+
M:2,.U6(Y&Y^6JD;_`%JRC9[4F!963D<5)YA]*A4U(#[U(R99#Z4\-FHE/O3U
M)H`D!-`!)ZTW)]*7/%2RT.Y7WI0>>::&/>I1@CI0-CE8$=:=FHBH`XXI$W<G
M=F@5BP.O2I[:'>2S@A!T'J:I!FST_6K44[8"C(K:A?F=C.HM-2_\I^GO5@$J
MOR@'%8TQDD')PHZ#^M,CO+B!Q\^Y1V:NM(RN;P(8?,H!]#4+VD?5,H3^(JO!
MJ<-Q\I^1_0U9$O(QS4ZH>C*$\4D+_,H*G^(=*A#[&X)'TK:)R.OXU6DLH7'*
MD'^\O^%4I]Q<I6CU!HS\PWC\C5^&\BF^ZX^AZUC75I/$&*H60?Q+Z?2J(D;A
MLX]ZKE3V)NT=Q6?K=N+G2)TVY;;E1[UH4C*&4@]#6A!X9>HJW;@<$G-5\#'4
M$UJ:S#]GNB&)RI*D^XXK-W,<`+GZT@&#(&``/>D;&,,V:>5;H6`]A3?+Z8'U
MHL,B(I"O')`J5U[L?RIN/0?C0`S"]AN^M'S>P^E/Q[TF/0?B:0$10=<<T!*E
M(`[TTF@"(@>HIA`J?:6X`IRV['GH*`*A!QQFFG(JQ+@?*!FJ[$`\<_2@!A!(
MII4>N*>02.>GI3<9&>:`(R?[H)I/J:DSGH*81ZF@"";[IK3TMLV2`]N*SI1\
MIJ[HS$VCC'1\?H*SJ_"5#<TUQFI5(]:B!/I3P3GH:YC6Q*K#/6IT9?457!'I
M4R'CI2"Q;0CUJ92!55",=*G4CTI,:191AZBK*/5)0!4Z#TJ658NH_M4P?VJH
MA([5*K-Z"D!9#CTIX<565F':G[CZ5([%A95(ZTH<$U4)(&<4U9FSR*ELT42^
M"!UIRL0>O%5T;<O2GJ,<4Q6+.<C-*%%0!F7%/\W`Y%!-B8<4YC#Y#"1CD]DZ
M_I4*R+@50NKV6*>6)6^0XX(]A6]!-RT,JCLM1?M3JQV2,5[9-31WR,?WHP3Q
MD=*R?,H\RN]Q3.=2:-E@C#*.I%1?:98#\CL!]>*S!+@Y!Q4GVMBN&P?>ERE<
MUS7@UJ1.)#D>U3-K3,"`R_6N>,@QG-)YE+D0<[.B75V_OC\344E[;S?ZU!G^
M\O45A>92B3D4*"0<[/3Z***LD\L\60>3J5T`H!$V[)Z8//\`6N:R3W)KN?'5
ML%N6DR<R(&QCKC`_I7#\X]/PH`:5&/E&WUI,'N33RHQUIA/8#-`"'`[4UB/\
M!3PCN>E2"W'5LD^@H`JD,>E`BD(Z$U?6W`[8^M/,8'7I0!16W.,MQ3Q$!R!F
MK3+GW%,(XP3^`I6`BVGL0*9(0BDGD^IJ7IT!'N:I7+9;EL"BP%=SDDDU&>*5
MGP>%Q[FFLYP3UH&-.?I2$>WXFFEW;H`/K3?J2QHL`X\]\_2F$?\`ZA3@_'3%
M`YZ&D!$X&T\?G5O12/+F7T8&JSC@UGF[FTZZ\U,$,,%?45,H\RL-.S.P6I%`
MJK!()X4EC;*N`0:G4-CK7*:V+`45,J\5`NZI5#8ZU([%A0*F7%5E#5*H)[T@
M+2XJ92*J*&]:E4-ZTAEQ2*D!!JJNZI%W4AV+2XJ0`55&[-2J6]:0$^`:8\8Y
MQ2#=ZT[#&I:*3$0;:G5ATJ##`TX!LTDBV[EA33N#TJ%<FG#<.E!-B8+QR!6'
MJ/%[)@\\<?@*V=[>@K*O(W-Z7"8#XR^>1QC`]*Z,.[3,JJT*)W@9V-CZ4W>?
M0TMQ(T!V`G;GUXJO]I<GD\5W)LP:1/YO:CS*B6XC/#H2/:KEN=+E&)9)(F]<
M]:3E;H'+?J0>91YE6VL[!W(AO1CMDBE31S)_JY\_1<_UI>TCU'[-E/S:42?,
M*T1X<N#TF&/]PTO_``C5T,'SX\^F#2]K#N'LY=CT>BBBM"3F/&L!?3$E`'#[
M#GW!KS%@P8C/M7KWB:(2Z!<$]4VN/P(_IFO,6BB5R1R>M`%%8';M^=2"W/?`
MJR"1W`]A2'DXSS0!&(PHX%.!(XR!]!2X4=6IFX]E_$T`*0>O3U)J,X[<TYCZ
M\_4TQF4#K^`H`0Y]*82%^M(\E0EB!UH`)[@*A&>:SFEYX'YTLSEW/(Q[5"<]
MA0`,2>O%-.![FE`[\FEVY[?@*`(B?;\Z,$CC@5+Y?J*7"K]:0$0CSZ#W-*0J
M#CKZTKL,<U7DFX^4`"@!SMG.*H7@#*/6I'E8G@_E4)!<T`/T?4FT^8Q3;C;M
MGISM/TKIK?5+*<?)./\`@0(_G7,K`N.5S2_9$;JM9RIJ3N4I6.UC=6&0P(^M
M3*PKC(_M$/,4\J^V[C\JM1ZIJ$6,E)`/[Z_X8K)T7T+4T=<K#UJ17%<]!KZ=
M+B$K_M#I6Y$R21I(O*L`P^AK*47'<I-,M*X]:F5U]:K*!Z5,JKFI'H601ZU*
M&%5P@/>GA?K2U#0L!A3U8>M0*HJ15&*0]"=7`[T]7!%0A%-."8/!I!H39IP-
M0[3ZFE`/J:0R8'!ZTX,*A"Y[TX+[F@=T2[A5&>4&Y=(@9)%`+*.`OU-6PON?
MSJE?W<=AY055,TSC`/IT)/X5=)7D3)Z%:_L]\!>24*XYP%X^E8&YL$X.!U-:
M.HZZ)W:&!5VD[<D9/UJC:ZDEI=']VLD&[Y@>I%=T>9(Q=FR/S*/,KH4T;3-9
M@:33;@1R]2F>GU7_``K#OM)O-.8?:4VH?NN.5-$:L9.W4)4Y+4B\R@2D="1]
M*JDLIY!I/,]ZT,SJ)]2EN;&&Y2>42*NR3#D?,.!CZ]:IVVMWD4@W7,[+GCYS
M6*MPZ`A6X/44@ERXY[U"@EH6YO<]YHHHJR2KJ47G:9=1CJT3`?7%>3RJ?-*M
MQ@XXZ5["<$8/2O*-7MVMM6N(B`-K9_/G^M`%$#&<#CUI"0?E'Z4,R]\GZU&T
MC8.!Q0`XD#_ZU1O*!G^51L['@G'M49;N3@4`/:3(Z&HV<D>@II8GD<T@&3R?
MP%`"%O2JUP^T`5:8$`D<#WJDZEVR:0%?:2:!'D^I]:L;,<FF--$G?/L*+@-\
MKNS?E065!CMZ57EN&(P/E%0-*<]30!:DFX]!59I<9J(L3WIH4GM0`K2$FHSE
MJE$1/:I!"?2F!7"=:<D?S5:6+VYH\ND`Q4]*>$Q4H3/2G>7S2&1!*4IZ5,J%
MCA06/M5VWTN:8@LO![4[",.9&?Y5&372:=J$:VD$,BNK(BJ2>G`Q6G::,$',
M8K2338L8,:_E4R@I;C3L9T<ZN,J<BITD&:L/I,3<B,`^U0MIDR<QN1]3G^=8
MN@^C+4T3K(,5('%4O+NXCAH@X'<4\7"#_61NGU7_``K)TIKH4I19<#BGB054
M6:%_NNN?3/-2J!6;36Y6A;605(K`U4'M4JXI#LBR&I<CUJN,>IIV/>D%BP&I
M0PJN/K0/J:`L6@PKC]=G/]LS9;`4*%YZ#:#_`%KJ!]:X7Q'(1KMP,]-O_H(K
M?#_$14T0VU@GO)_+MT9CUX'05`7P2,YK:\'Z['IMXT-PJ>1*0-YZH>F?IZUH
M^,=%B9S?V2`/C]ZB+][_`&ACO71[1J?*T3[.\.9'+P7<UM*)8)7CD'1D;!KH
MM-\8R`&#5D^U0-_%M&X?4="*Y`.3QZ4WS*J4(RW(C)QV/17T+2=<A-QIDXC(
M_N<C/H5[5S.J:3<:7,4F4A?X9/X6_&L2&[EMWWPRO&_]Y&(/Z5UND>,YO*6V
MU&+[2IX\Q<;@/<=#65JD-G=&J<)[JS.:+D'!XH63YA]:[:YT#3-<C%Q8R>26
MZN@^4'T*]C^5<G?Z#J>FR_OK9WC!XEC&Y2/7(Z?C6D:L9:=2)4I1UZ'O59=_
MK]A8##3+(_\`=0@G\<5PM_K%[?NWG3N$;_EFK$+CZ5G'`K0@Z.]\97DH9;:*
M.%>S'YC_`(?I7,W=S+=3/++)ND;&XX`IK'\?Y5$^3TQB@!A89XYH;..2`*"K
MGT`H"`?7UH`BXQA5//<TQHCU/)]*MI$TAPJUI6FA7-P00H"GN:0&`(V?@`GZ
M5>M=*GN&`"M^"UU$>EV6G)NNY4!'.,9J&Y\3VL"&.SA8MTW$`4`8NJ:0=/L3
M(Y.XCOQBN8DN(T^Y\['WK5UO4)M1RTLAP/X<YKGGD[*I`HL`^69W!#,`#V%5
MB^.!2$,U*(R:8$9).<T@7/:K*0^M3+#Q0!56+/;-2B&K0B%/"8.:0%=8LBGB
M*I]N.M(1^`I@1;,=!S3=@-3X)("@_A5VVTF><\X4>E`&<H).U1D^U7+?3))N
M6!`]A72V.A!-O`_*MN#3E11P/RH`YNST5$QE36Q!8I&!@5KK;@=`*=Y&*`**
MP@=JD$0JSY5+Y5`%7RQZ4>4#UJUY9%'ET`5#`I[5&UFC]5J_LIP2@#%?2(6S
M@$'VJ(Z7)'_JI6'L1FN@\NE\L>E)I/<+G-,MW#UC#CV!%(MV%XDC9#],BND,
M0-1/:H_50?PK-T8,I3:,=)XW^ZZG\:F5AZU--I44G\(_*JK:1,AS%*1[9XK)
MX;LRU4[DH(HR*K^1>1?>57'L<4TRE?OQNOZUDZ,UT*4HEL.*X+Q,?^)Y<D8_
MA_\`0179I(C_`'9/SXKC?$<3Q:O.SCY9$5U/J,8_F#54?=EJ$[-:&3%*P<;<
M9/<UZ%H,QCM(X99S(!T+'I[>PKS.*<12AB-P4]/6NAL[NYO+F.")S;QR,`77
ME\>WI6U9,5)V.C\4^'B(FU&RCRW6:-1G_@0'\ZXB1U=<@\]_>O6M/1;2TB@:
M0M"%"JSMD_B37'^+O"[6<CZC8QYA?+2QK_`?4#T]:QH5E\+-:M+3F1QWF5)#
M+)Y@6+)=CM`'<FJ;N,\'BGP7'DRB3G('&/6NQ['(MSLM4U+[':Z=HD<K`Q`/
M=-&W.X\XS_GM78V>KI!8B2YN`^,'(7IGH/<]!7CBW),QD8\GO74:9JD-W?VL
M<DA6WA</M.?GD'W1^'7ZURUH.R.FG45V:,=XIP&P#ZU)YB,,A@?I1<:)/!G8
MP8#UX-9LJO$<2*0?>NLYB^QSTXJ)R1TR?I4*3L``<'ZTC3%B,KB@"]#:R38*
MJ3FMBS\/2RE6="J^IJMHFM164<D4L)9NJ$'\Q4]YXAN[@,L2B)2,>II`:YM]
M(TI<SO&6]"<G\JR+WQ3)@QV,:Q+V8KSBL&0A6W,2S5"P>3/10:8$EU?RSR%Y
MYFD<^IS5)Y9'R%&!4XMP/<T\0<T`4?*+<MDT&V1^J`_A6B+<<9-2+$%^M(#(
M.EJ?N@@^E,_L]UZ)Q6\$..F*"@Z'O0!A?9\=5-+L'85LO;C!W8`]^U5)HHXU
M+"F!3"`<XQ2$`<]!ZT;B3D?G5RVTV>Z89.U3W/6@"AR>@J[:Z5/<.-R,%KI-
M/\/J@!))/J:Z&VTM4H`YJQT!%"DQ<^IK>M]+2,<)6O';!0*F$0H`STM@N/EJ
M40CTJX(Z7RZ`*?E>U'EU<\ND\J@"GY?M1Y?M5ORJ/*H`J>7[4ODY[5<$5+Y=
M`%+R?:CR_:KGETACH`J^732GM5HQTACH`J[*-OM4YC-)MQ0!!L'I2&,>E6-M
M&R@"MY0/:HGM8G'*`U=VT;*`,B728'Y\O!KEO&.EA=-6Z0$FU.V3/=&/]#BO
M0-E<WXE262&:W49BD0J_T(KGQ#Y4GYFU%7;7D>,NQ5NM:$%YM*B%WW@9W*<8
M_'M6),6CF>-C\R,5/U!Q0DTF0B%B2>%'<ULU=&2=F=XMW<WMK&FHWX:TP"(D
M.`Y[;CU/TKHM"\5VS746D7<A8R?+"S#./1#_`$/X5QVF>%[YK=;G5[W^SK5A
M\BM\TK'T5>W^>*Z#2+6QTARVG6S><PP+FZ.Z0CV4<+7!4=/5+7T.RGSW3>A3
M\8^$9+-Y-0L(\V^29(U'*>X]OY5PWF5[+:ZHBB/3[^Z'GS9$.XC>_MCT]ZX;
MQ?X/GLWDU+3X]UJ?FEC4<QGN0/3^5:T*VG+,BM1^U$Y/S*M6E[Y+J,'[P.0>
M1667(ZT))\Z_45UM7.5.Q]0W&F(^<(*Q[O0U8<Q*:Z\J#4;0(W7-,#S.\\.8
M#&--A]JQIM+NH#]PD>U>NR:9#)GDBL^Y\/H^2IS^%`'E!)1L,I0T])W(P6W+
M[=:[.^\.#!#1MU]*P+G0#&28RP]B,T`4U>(].#[U)LW>XJI+;7$!^9#CUQ21
MSNC<-@^G6@"^L.?X>!4@A]OPJLE\0`'48]1Q5V.:.3&QA^-`##%CG&/<T@C(
MZ#FISC=D]J@DN`I^7!H`4H%Y8@5$\H0?)CZU%),3U.34UI87%XP*J53IDB@"
ME(Y;U/I3!87=W*,(0GJU=MIOAF)&#,&=L=3710:#;!1N2@#@[#P]M.6C!/J:
MZ6TTM4`R@KH!I,2?<8T&U9.V1[4`4HK95'W15@1^U2A,4\+0!$(_:E$?M4VV
MG!:`(A'[4>7[5-MI0M`$/E^U'E^U6-M*(Q0!6\KVI?*]JM!`*7:*`*GE>U)Y
M?M5O8*0H*`*A7VIOE^U6S&*3RJ`*93VIOE^U7#%3?+H`J&/VIIC]JN%!3=E`
M%,Q'TIIC/I5TQTTQT`4]E&PU;,8IACH`K[:YB_G9]5OK-LD<.K,.$^11CW]?
MSKK2E<1K+WL7BB5FN(A8C;F+R_F/RC^+Z\URXS^'\SHPWQGDOBJU6QUB54SM
MD/F@_7K^N:I6.K-8.K6L$0G[2N-S`^V>!^5=KXSTG[1ITMUL`DMVR#W*9Y_Q
MKS%G*.1T(JZ,E4A9DU4Z<[H[BUU0+<B[NVEN;QN%3=O<_0=%'Y5M6::C?W'G
M3.-/@`X6,AI#]2>!^5<3H6JP6;EYOW:]"X7):NIBUQKJ41Z-`;M_XG?*1+]3
MW^@KGJ1:>B-8236YU6GZ796+O-$'>:0?//,Y=R/J>GX5J:;X@L;K4#I0E\Z8
M)N)52RJ/1CT%<W::5<72,=8O)+AF_P"6$),<2CTXP6_&M>""RT>S8A8+*U7E
ML81?Q]ZY)M=[LZ(W6VAS/C7P,+5)=3TI"81\TL`Y\OW7V]NU>=(_[Q?J*]ST
M3Q''K,UQ%!!.UI&/DO"F(W]AGEOKBN4\6^!H%5M1TN(*%R\L([=\CV]JZJ&(
M<?<J&%:@I>]`]ZHHHKT#C"BBB@!"H88(!'O5.?38)L_*%)]JNT4`<W=>'2>5
M"L*YV^\-YW9C`/J!7HU,>&.0$.@.?:@#R&?0KB(_(01Z&J$D4T)Q(K#]:]@F
MT>UE.0N*K-X;L9!ATW#T-`'ED<I*89C5RTTR\OB?+C(4?Q/P*]"3PCI"2B06
MJY'8DX_+I6K'86\8PL8`]*`.-TSPML96D`=O4CBNHM=)6)1N"_E6BJ*OW5`I
MU`#4C5!@`4ZBB@`HHHH`0@'J`:88AVXJ2B@"+RR*-M2T4`1@4\"EHH`,4444
M`%%%%`!1110`4444`&*3`I:*`&%*394E%`$.RC94U&*`(/+I#'5C%(5H`JE*
MX'Q.+W^U[E(;6!U^3:SR8_A'6O1]@]*\\\37EVFNWD4>EI*D839)YP!?*@GC
M'`%<./NJ:MW_`,SIPOQOT,JXMOM5FH<KNEC*NO4!L<_A7B>I0&*)6VE71BD@
M/8CC^=>S:=>7<L]U#=VB0`_ZG$@8L>_Z5P?CG1S;ZC-,H(CO(_,4#_GH/O#Z
M]#^=886HXRLSHKPYHW1RNDM`)1),`^/X2,@?A7H5IKFG65LAEE3IQ'&N6/T4
M<UY1;('G",S*#UQUKT+PPVF6<+.[PV\8'SN[!<GW)K?%16[NS"@^B.EM;S6]
M=1CIZ#2;,<&>XCW3/_NKT7ZFM&RT&RL\R7"-J-WU-Q>GS&_#/`_"J<GB9/LJ
MG2+*;4#T#I^[B7ZNV`?PS65+:7VM'=J^I/L/'V'3R0F/]INK&N+WFM?=7X_Y
M_>=.GJSHU\46]D)TOKF'*MMAM;13++^*KG^E6=$UN]N5EFOK%;6'</*1Y,R$
M>K#H/I7&W\;6-JEK;7D&CV0X/SJI(_F3[U4?QKI>D0+;Z>CWTQ`!EDX4'UYY
M/Y52I77N*]_Z]/S%[2WQ.Q]*T445[)YH4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%</XB9DUFX9;1Y>%R0Z@?='J:[BN`\32N->N$#$#Y.G^Z*\
M_,OX2]?T9U83XWZ'/,D_VV&1;!R`V2QF4;<]_>LCQ=";G19G`(-N?-'T'#?I
MFM>YF<GK46T7C)#,,QRQD.OJ",&N&A*[OV.R2TL>$228N"Z<<Y%;^A-'(QN)
M8TF="`&G^95/LH_F:PKQ!'>3(HX5B!4*NR@A6(!ZX/6O:G#GC8\M2Y9'ID_B
MC3+=E-W=RS,H^6"-!M'Y'`^G%8&I^-;NZD\G3(C!$>%XRQ/T'_UZYS2[5+W5
M+:VD+!)9`K%>N#Z5[W;^'M*\'Z7)-IEE$;A(R_GSC?(3C^]V'L,5QU(TZ%KJ
M[_`Z:;G5O9V/++/P%XJUI1>30+"LO(ENY`I(^G+#\JV-.\*^%M/O4@GO)]:U
M!&&^"SB+1J?0D<=?4BJMIJE_XHN_-U*]G,4EQM:WB<I'CZ#D_B:]-L;6"W@2
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
        <int nm="BreakPoint" vl="577" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14770: use envelopeBody " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/7/2022 7:50:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11497 facet gap corrected" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="4/12/2021 9:02:53 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End