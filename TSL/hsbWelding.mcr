#Version 8
#BeginDescription
version value="1.6" date="09dec13" author="th@hsbCAD.de"
symbol placement auto corrected on creation or on recalc
supports dimrequests for sdEntitySymbolDisplay






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
///<version value="1.6" date="09dec13" author="th@hsbCAD.de"> symbol placement auto corrected on creation or on recalc</version>
///<version value="1.5" date="18apr13" author="th@hsbCAD.de"> supports dimrequests for sdEntitySymbolDisplay</version>

//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);

	PropDouble dThickness(0, U(5), T("|Thickness|"));		
	String sArWeldKind[] = {T("|Kehl-Naht|"),T("|V-Naht|"),T("|HV-Naht|"),T("|Y-Naht|"),T("|HY-Naht|"),
		T("|I-Naht|")};//,T("|Gegennaht|")};
	PropString sWeldKind(0, sArWeldKind, T("|Welding Type|"));	

	String sArNY[] = {T("|No|"),T("|Yes|")};
	PropString sWeldingDouble(3, sArNY, T("|Double Welding|"));	

	String sArWeldShape[] = {T("|flat|"),T("|concave|"),T("|convex|"), T("|not set|")};
	PropString sWeldShape(2, sArWeldShape, T("|Welding Surface|"));	

	String aArWeldingType[] = {T("|Wurzel ausgearbeitet, gegengeschweißt|"),T("|Naht eingeebnet|")};
	//PropString sWeldingType(7, aArWeldingType, T("|Nahtausführung|"));	

	PropString sWeldOnsite(5, sArNY, T("|Baustellennaht|"));	
	
	String sArWeldPath[] = {T("|Segment|"),T("|Ring|"),T("|Contour|")};
	PropString sWeldPath(1, sArWeldPath, T("|Welding Contour|"));	

	String sArDrawOption[] = {T("|Solid|"),T("|Symbol|"),T("|Path|"),T("|Symbol|") + " + " + T("|Solid|") ,T("|Path|") + " + " + T("|Solid|"),
		T("|Symbol|") + " + " + T("|Path|"), T("|All|") };
	PropString sDrawOption(6, sArDrawOption, T("|Display Options|"),5);// deafult is symbol + path	
	
	PropString sDimStyle(4,_DimStyles, T("|Dimstyle|"));		
	PropInt nColor(0,254, T("|Color|"));
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		
		Entity  ent1,ent0;	
		ent0 = getEntity(T("|Select main part|"));			
		ent1 = getEntity(T("|Select secondary part|"));	
					
		_Entity.append(ent0);
		_Entity.append(ent1);
	
		_Pt0 = getPoint(T("|Pick point on welding edge|"));
		Point3d ptY = getPoint(T("|Pick second point on welding edge|"));
		Point3d _Pt0Y = getPoint(T("|Pick third point on welding plane|"));
		
	// build coordSys
		Vector3d vx,vy,vz;			
		vx = ptY-_Pt0;	vx.normalize();
		vy = _Pt0Y-_Pt0;	vy.normalize();
		if (vx.isParallelTo(vy))
		{
			reportNotice(T("|Invalid points picked, please pick three points on the welding plane|"));
			eraseInstance();
			return;				
		}
		vz = vx.crossProduct(vy);
		vy = vx.crossProduct(-vz);
		_Map.setVector3d("vx", vx);
		_Map.setVector3d("vy", vy);
		_Map.setVector3d("vz", vz);
		
	/*	
	// snap to selected edge
		Point3d ptCen0 = bm0.ptCenSolid();
		Point3d ptCen1 = bm1.ptCenSolid();
		Quader qdr0 = bm0.quader();	
		Quader qdr1 = bm1.quader();
			
	// ref plane
		Vector3d vz = ptCen0-_Pt0;
		if (vz.bIsZeroLength())
		{
			reportNotice(T("|Invalid Connection|"));
			eraseInstance();
			return;				
		}
		vz = qdr1.vecD(vz);
		Plane pn(ptCen1+vz*.5*qdr1.dD(vz),vz);
		_Pt0 = Line(ptCen0,qdr0.vecD(vz)).intersect(pn,0);

	// coord sys male (secondary)

		vx = qdr0.vecD(-vz);
		if (!vx.isParallelTo(bm0.vecX()))
			vy = bm0.vecX();
		else
			vy = bm0.vecY();	
		vz = vx.crossProduct(vy);	
		// assuming that the smaller dimension is z dimension
		if (qdr0.dD(vy)<qdr0.dD(vz))
		{
			Vector3d vt = vz;
			vz =vy;
			vy = vt;
		}	
	
	// coord sys female (main)
		vz1 = qdr1.vecD(vx);
		vx1 = qdr1.vecD(vz);
		vy1 = vx1.crossProduct(-vz1);	

	// get slice at ref plane
		PlaneProfile ppSlice= bm0.realBody().getSlice(Plane(pn.ptOrg(),vz1));
		_Pt0 = ppSlice.closestPointTo(_Pt0);
		*/

		return;
	}	
//end on insert________________________________________________________________________________
	
// validate
	if (_Entity.length()<2)
	{
		eraseInstance();
		return;	
	}
	

	
	Entity ent0 = _Entity[0];
	Entity ent1 = _Entity[1];
	
		
// add dependencies
	for (int i=0;i<_Entity.length();i++)
	{
		setDependencyOnEntity(_Entity[i]);
		// make sure the tool gets appended to the beams tools to trace it from eToolconnected in shopdrawview
		if(_Entity[i].bIsKindOf(Beam()))
		{
			Entity ent = _Entity[i];
			Beam bm= (Beam)ent;
			_Beam.append(bm);	
		}	
	}	
	setExecutionLoops(2);

// build coordSys from map
	Vector3d vx,vy,vz,vx1,vy1,vz1;
	if (_Map.hasVector3d("vx")) vx=_Map.getVector3d("vx")	; else vx = _XE;
	if (_Map.hasVector3d("vy")) vy=_Map.getVector3d("vy")	; else vy = _YE;
	if (_Map.hasVector3d("vz")) vz=_Map.getVector3d("vz")	; else vz = _ZE;
			
	if (vx.isParallelTo(vy))
	{
		reportNotice(T("|Invalid points picked, please pick three points on the welding plane|"));
		eraseInstance();
		return;				
	}
	vx.normalize();
	vy.normalize();
	vz.normalize();
	

// trigger
	String sTrigger[] = {T("|Swap Z-Axis|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger 0: Swap Z-Axis
	if (_bOnRecalc && _kExecuteKey==sTrigger[0])
	{
		vz *=-1;
		vy = vx.crossProduct(-vz);
		_Map.setVector3d("vx",vx);
		_Map.setVector3d("vy",vy);
		_Map.setVector3d("vz",vz);
	}


// get intersecting body in welding thickness
	Body bd0=ent0.realBody(), bd1=ent1.realBody();
	double dX = bd0.lengthInDirection(vx),dY = bd0.lengthInDirection(vy),dZ = bd0.lengthInDirection(vz);
	double dScaleX = (dX + dEps)/dX;
	double dScaleY = (dY+ dEps)/dY;
	double dScaleZ = (dZ+ dEps)/dZ;	
	Body bdSec = ent0.realBody();
	CoordSys csSec;
	csSec.setToAlignCoordSys(bd0.ptCen(),vx,vy,vz,bd0.ptCen(),vx*dScaleX,vy*dScaleY,vz*dScaleZ);
	bdSec.transformBy(csSec);
	bdSec.intersectWith(bd1);
	bdSec.vis(2);

	dX = bd1.lengthInDirection(vx);
	dY = bd1.lengthInDirection(vy);
	dZ = bd1.lengthInDirection(vz);
	dScaleX = (dX + dEps)/dX;
	dScaleY = (dY+ dEps)/dY;
	dScaleZ = (dZ+ dEps)/dZ;	
	Body bdMainSec = ent0.realBody();
	csSec.setToAlignCoordSys(bd1.ptCen(),vx,vy,vz,bd1.ptCen(),vx*dScaleX,vy*dScaleY,vz*dScaleZ);
	bdMainSec .transformBy(csSec);
	bdMainSec .intersectWith(bd0);
	bdMainSec .vis(2);
		
// validate ref plane
	vz.normalize();
	if (vz.dotProduct(bdSec.ptCen()-bd0.ptCen())<0)
		vz*=-1;
	if (vz.bIsZeroLength())
	{
		reportNotice(T("|Invalid Connection|"));
		eraseInstance();
		return;				
	}
	vz = vx.crossProduct(vy);
	vy = vx.crossProduct(-vz);
	vz.vis(_Pt0,150);


// ints
	int bWeldOnsite =sArNY.find(sWeldOnsite);
	int nWeldShape = sArWeldShape.find(sWeldShape);
	int nWeldPath = sArWeldPath.find(sWeldPath);
	if (nWeldPath>0)
	{
		sWeldingDouble.set(sArNY[0]);
	}
	int nWeldKind = sArWeldKind.find(sWeldKind);
	int bWeldingDouble = sArNY.find(sWeldingDouble);	
	int nDrawOption=sArDrawOption.find(sDrawOption);
	int bDrawSolid, bDrawPath, bDrawSymbol;
	if (nDrawOption!=1 && nDrawOption!=2 && nDrawOption!=5) bDrawSolid=true;
	if (nDrawOption!=0 && nDrawOption!=1 && nDrawOption!=3) bDrawPath=true;
	if (nDrawOption!=0 && nDrawOption!=2 && nDrawOption!=4) bDrawSymbol=true;
	
		

// the welding thickness is dependent from te thickness of the mainpart if not of type kehlnaht	
	//if (nWeldKind!=0)
	//{
	//	//dThickness.setReadOnly(true);
	//	double d = bd0.lengthInDirection(vz);//qdr0.dD(vz);
	//	if (bWeldingDouble) d*=.5;
	//	dThickness.set(d);
	//}

	Plane pn(_Pt0,vz);
	
// extract the welding shape
// get slice at ref plane
	PlaneProfile ppSec, ppMainSec, ppSlice;
	ppSec= bdSec.extractContactFaceInPlane(Plane(_Pt0,-vz),dThickness);	
	// try inverse if result is null
	if (ppSec.area()<pow(dEps,2))
		ppSec= bdSec.extractContactFaceInPlane(Plane(_Pt0,vz),dThickness);			

	ppMainSec= bdMainSec .extractContactFaceInPlane(Plane(_Pt0,-vz),dThickness);	
	// try inverse if result is null
	if (ppMainSec.area()<pow(dEps,2))
		ppMainSec= bdMainSec .extractContactFaceInPlane(Plane(_Pt0,vz),dThickness);	
		
	
	ppSlice=ppSec;
	ppSlice.intersectWith(ppMainSec);
	ppSlice.vis(6);
	
// collect rings
	PLine plRings[] = ppSlice.allRings();
	int bIsOp[] = ppSlice.ringIsOpening();
		
// declare the path of the welding
	PLine plWeld[0];

	
// distinguish welding shape
	PLine plThisWeld;
	double dOffsetMax = U(200000);
	for (int r=0;r<plRings.length();r++)
	{
		plRings[r].convertToLineApprox(dEps);
		
		if (nWeldPath==0)
		{		
			Point3d pt[] = plRings[r].vertexPoints(false);
			for (int p=0;p<pt.length()-1;p++)
			{
				//pt[p].vis(p);
				PLine plThis(pt[p],pt[p+1]);
				double dThisOffset = Vector3d(_Pt0-plThis.closestPointTo(_Pt0)).length();
				if (dThisOffset<dOffsetMax )
				{
					plThisWeld= plThis;
					dOffsetMax =dThisOffset; 	
				}	
			}// next point p
		}
		else if (nWeldPath==1)
		{
			PLine plThis=plRings[r];
			double dThisOffset = Vector3d(_Pt0-plThis.closestPointTo(_Pt0)).length();
			if (dThisOffset<dOffsetMax )
			{
				plThisWeld= plThis;
				dOffsetMax =dThisOffset; 	
			}	
		}			
		else if (nWeldPath==2)
		{
			plWeld.append(plRings[r]);
		}
	}// next ring r
	
	if (nWeldPath<2)
		plWeld.append(plThisWeld);	


	
// display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	double dTextHeight = dp.textHeightForStyle("O",sDimStyle);
	
	
		
// draw
	PLine plShape(_ZW);
	double dA = sqrt(2*(dThickness*dThickness));
	double dH = dThickness;	
	double dC = 2 *dH;

	CoordSys csMirr;
	if (nWeldKind==0)
	{
		plShape.addVertex(_PtW);
		plShape.addVertex(_PtW-_XW*dA);
		plShape.addVertex(_PtW-_YW*dA);	
		dH = bd1.lengthInDirection(vz);		
		if (bWeldingDouble)
		{
			dA*=.5;
			dH *=.5;	
		}	
	}	
	// V
	else if (nWeldKind==1)
	{
		//dH = bd1.lengthInDirection(vy);;
		dA = dH/sin(60);
		if (bWeldingDouble)
		{
			dA*=.5;
			dH *=.5;	
		}
		dC=dA;
		plShape.addVertex(_PtW-_XW*.5*dA);
		plShape.addVertex(_PtW+_XW*.5*dA);
		plShape.addVertex(_PtW+_YW*dH);			
	}
	// HV
	else if (nWeldKind==2)
	{
		//dH = bd1.lengthInDirection(vy);
		dA = dH/sin(60);
		if (bWeldingDouble)
		{
			dA*=.5;
			dH *=.5;	
		}
		dC=dA;
		plShape.addVertex(_PtW-_XW*.5*dA);
		plShape.addVertex(_PtW);
		plShape.addVertex(_PtW+_YW*dH);	
	}
	// Y
	else if (nWeldKind==3)
	{
		//dH = bd1.lengthInDirection(vy);
		dA = dH/sin(60);
		if (bWeldingDouble)
		{
			dA*=.5;
			dH *=.5;	
		}
		dC=dA;
		plShape.addVertex(_PtW-_XW*.5*dA);
		plShape.addVertex(_PtW+_XW*.5*dA);
		plShape.addVertex(_PtW+_XW*.05*dA+_YW*dH*.7);
		plShape.addVertex(_PtW+_XW*.05*dA+_YW*dH);
		plShape.addVertex(_PtW-_XW*.05*dA+_YW*dH);
		plShape.addVertex(_PtW-_XW*.05*dA+_YW*dH*.7);				
		plShape.addVertex(_PtW-_XW*.05*dA+_YW*dH*.7);			
	}
	// HY
	else if (nWeldKind==4)
	{
		//dH = bd1.lengthInDirection(vz);
		dA = dH/sin(60);
		if (bWeldingDouble)
		{
			dA*=.5;
			dH *=.5;	
		}
		dC=dA;
		plShape.addVertex(_PtW-_XW*.5*dA);
		plShape.addVertex(_PtW+_XW*.5*dA);
		plShape.addVertex(_PtW+_XW*.05*dA+_YW*dH*.7);
		plShape.addVertex(_PtW+_XW*.05*dA+_YW*dH);
		plShape.addVertex(_PtW+_YW*dH);
		plShape.addVertex(_PtW+_YW*dH*.7);				
		plShape.addVertex(_PtW);			
	}
	plShape.close();

		
// weld it
	Body bdWelding;
	PlaneProfile ppWelding(CoordSys(_Pt0,vx,vy,vz));
	for (int w=0;w<plWeld.length();w++)
	{
		if (bDrawPath)
			dp.draw(plWeld[w]);
		if (!bDrawSolid)
		{
			ppWelding.joinRing(plWeld[w],_kAdd);// collect rings to get a snap to pp
			continue;
		}
	// circle test of welding pline
		PlaneProfile ppWeld(plWeld[w]);
		LineSeg ls = ppWeld.extentInDir(ppWeld.coordSys().vecX());

		PLine plCirc;
		double dDiameter = abs(ppWeld.coordSys().vecX().dotProduct(ls.ptStart()-ls.ptEnd()));
		plCirc.createCircle(ls.ptMid(),ppWeld.coordSys().vecZ(),dDiameter*.5);
		if (abs(ppWeld.area()-plCirc.area())<pow(dEps,2) && dDiameter > dEps)
			ppWeld.joinRing(plCirc,_kSubtract);

	// weld by circle
		double d = abs(ppWeld.area()-plCirc.area());
		if (ppWeld.area()<pow(dEps,2) && dDiameter > dEps)
		{
			plCirc.vis(2);
			Body bdCone(ls.ptMid(), ls.ptMid()+vz*dThickness, dDiameter/2+dThickness, dDiameter/2);
			bdCone.subPart(Body(ls.ptMid(), ls.ptMid()+vz*dThickness, dDiameter/2));
			bdWelding = bdCone;
			dp.draw(bdCone);
		}
		

	
	// weld by segment
		else
		{
			Vector3d vxSeg,vySeg;
			Point3d pt[] = plWeld[w].vertexPoints(false);
			for (int p=0;p<pt.length()-1;p++)
			{	
				int a, b;
			// get previous
				if (p==0)
					a = pt.length()-2;
				else
					a=p-1;
			// get next
				if (p==pt.length()-2)
					b = 1;
				else
					b = p+2;
				
				vxSeg = pt[p+1]-pt[p];
				vxSeg.normalize();
				vySeg = vxSeg.crossProduct(-vz);	
				vySeg.normalize();
				//vx.vis(pt[p],12);
				vySeg.vis(pt[p],94);
				
			// special: on fillet and angled
				PLine plThisShape,plThisShape2;
				if (nWeldKind==0 && 0)//todo check vectors: !vxSeg.isParallelTo(vz1))
				{
					// single seam
					Point3d ptThis = pt[p];
					Point3d ptShape[0];
					ptShape.append(ptThis);					
					
					Vector3d vMitre = -vx+vy;
					vMitre.normalize();
					Plane pnThis(ptThis+vMitre*dThickness, vMitre);
					//pnThis.vis();
					ptShape.append(Line(ptThis,vx).intersect(pnThis,0));
					ptShape.append(Line(ptThis,vy).intersect(pnThis,0));					
					
					for (int i=0;i<ptShape.length();i++)
						plThisShape.addVertex(ptShape[i]);
					plThisShape.close();	
					
					// double seam					
					if (bWeldingDouble)
					{
						
						dH = bd1.lengthInDirection(vz);
						// todo verify
						ptThis = Line(pt[p]-vy*bd1.lengthInDirection(vy),vx).intersect(pn,0);
						ptThis.vis(2);
						
						ptShape.setLength(0);
						ptShape.append(ptThis);					
						
						Vector3d vMitre = -vx-vy;
						vMitre.normalize();
						Plane pnThis(ptThis+vMitre*dThickness, vMitre);
						//pnThis.vis();
						ptShape.append(Line(ptThis,vx).intersect(pnThis,0));
						ptShape.append(Line(ptThis,vy).intersect(pnThis,0));					
						
						for (int i=0;i<ptShape.length();i++)
							plThisShape2.addVertex(ptShape[i]);
						plThisShape2.close();
						plThisShape2.vis(5);
					}
				}
			// default: take the predefined shape
				else
				{
					CoordSys cs;
					cs.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,pt[p],-vz,-vySeg,-vxSeg);
					plThisShape = plShape;
					plThisShape.transformBy(cs);					
				}
				
			// the welding body
				double dX = Vector3d(pt[p]-pt[p+1]).length();
				Body bdWeld0, bdWeld1;
			// weld by pline contour	
				if (nWeldPath>0 && plThisShape.vertexPoints(true).length()>2)
				{
					dX+=2*dA;
					bdWeld0 = Body(plThisShape,vxSeg*dX,1);
					bdWeld0.transformBy(-vxSeg*dA);
					Vector3d vCut;
					vCut= pt[p]-pt[a];								
					//vCut= vxOther.crossProduct(-vz);
					vCut.normalize();
					vCut+=vxSeg;
					vCut.normalize();
					//vCut.vis(pt[p],3);
					
					bdWeld0.addTool(Cut(pt[p],-vCut),0);		
					
					vCut= pt[b]-pt[p+1];								
					//vCut= vxOther.crossProduct(-vz);
					vCut.normalize();
					vCut+=vxSeg;
					vCut.normalize();
					//vCut.vis(pt[p+1],2);									
					bdWeld0.addTool(Cut(pt[p+1],vCut),0);	
					//bdWeld0.vis(2);	
				}
			// weld by segment	
				else if(plThisShape.vertexPoints(true).length()>2)
					bdWeld0 = Body(plThisShape,vxSeg*dX,1);
				
				
			// draw the welding body	
				dp.draw(bdWeld0);
				bdWelding.addPart(bdWeld0);
				
			// double weld
				if (bWeldingDouble &&  !(nWeldKind==0))// && !vxSeg.isParallelTo(vz1)))
				{
					csMirr.setToMirroring(Plane(pt[p]-vySeg*.5*bd1.lengthInDirection(vySeg),vySeg));
					bdWeld0.transformBy(csMirr);
					bdWeld0.vis(2);
					dp.draw(bdWeld0);
					bdWelding.addPart(bdWeld0);

				}	
				else if (bWeldingDouble &&  (nWeldKind==0 && !vx.isParallelTo(vz1))  && plThisShape2.vertexPoints(true).length()>2)
				{
					bdWeld1 = Body(plThisShape2,vx*dX,1);
					dp.draw(bdWeld1);	
					bdWelding.addPart(bdWeld1);				
				}
				//plShape.vis(2);
			}
		}// end if weld by segment
	}


// snap _pt0 to welding shadow
	if (_bOnRecalc || _bOnDebug ||_bOnDbCreated)
	{
		if (bdWelding.volume()>pow(dEps,3))
			ppWelding = bdWelding.shadowProfile(Plane(_Pt0,vz));
		if (ppWelding.area()>pow(dEps,2) && ppWelding.pointInProfile(_Pt0)==_kPointOutsideProfile)
			_Pt0 = ppWelding.closestPointTo(_Pt0);	
		bdWelding.vis(3);
		ppWelding.vis(4);
	}


// declare dim request map
	Map mapRequest,mapRequests;
	mapRequest.setInt("Color", nColor);
	mapRequest.setVector3d("AllowedView", vz);

	
// draw and store symbol
	{
		Display dpSym(nColor);
		
	// the symbol will be drawn in plan view. all plines will be stored in map at the location relative to _Pt0
		Map mapSymbol, mapChild;
		double dSymLen = dTextHeight*3;
		Vector3d vxSym=_XW,vySym=_YW;
		PLine plSym(_ZW),plSymMain(_ZW), plWeldShape;
		
		Point3d ptSym[0];
		ptSym.append(_Pt0);
		ptSym.append(_Pt0+ (vxSym+vySym) *dSymLen);
		ptSym.append(ptSym[1]+ (vxSym) *dSymLen);		
		
	// draw and store the thickness of the welding
		if (bDrawSymbol)
			dpSym.draw(dThickness, ptSym[2], vxSym, vySym,1,1);		


		//mapChild.setString("text", dThickness);
		//mapChild.setPoint3d("ptOrg", ptSym[2]);	
		//mapChild.setInt("color", nColor);
		//mapSymbol.appendMap("childSymbol",mapChild);				

	// text
		Map mapRequestTxt;
		mapRequestTxt.setPoint3d("ptScale", _Pt0);		
		mapRequestTxt.setInt("deviceMode", _kDevice);		
		mapRequestTxt.setString("dimStyle", sDimStyle);	
		mapRequestTxt.setInt("Color", nColor);
		mapRequestTxt.setVector3d("AllowedView", vz);				
		mapRequestTxt.setPoint3d("ptLocation", ptSym[2] );		
		mapRequestTxt.setVector3d("vecX", vx);
		mapRequestTxt.setVector3d("vecY", vy);
		mapRequestTxt.setDouble("textHeight", dTextHeight );
		mapRequestTxt.setDouble("dXFlag", 0);
		mapRequestTxt.setDouble("dYFlag", 0);			
		mapRequestTxt.setString("text", dThickness);	
		mapRequests.appendMap("DimRequest",mapRequestTxt);	

			
		Point3d ptMain = (ptSym[1]+ptSym[2])/2;
		ptMain.vis(5);
		
	// the weld shape
		CoordSys csWeldShape, csSym;
		csWeldShape.setToAlignCoordSys(ptMain,vxSym,vySym,_ZW, 
			ptMain +vySym*1/3*dSymLen+vySym*0.05*dSymLen, vxSym, vySym,_ZW);	
		//csSym.setToAlignPlaneToWorld(Plane(mapCoordSys.getPoint3d("ptOrg"),mapCoordSys.getVector3d("vz")));
		if (nWeldShape == 0)
		{
			plWeldShape = PLine(_ZW);
			plWeldShape.addVertex(ptMain -vxSym*1/6*dSymLen);
			plWeldShape.addVertex(ptMain +vxSym*1/6*dSymLen);
			plWeldShape.addVertex(ptMain +vxSym*1/6*dSymLen-vySym*dEps);
			plWeldShape.addVertex(ptMain -vxSym*1/6*dSymLen-vySym*dEps);			
		}
		else if (nWeldShape == 1)
		{
			plWeldShape = PLine(_ZW);
			plWeldShape.addVertex(ptMain -vxSym*1/6*dSymLen);
			plWeldShape.addVertex(ptMain +vxSym*1/6*dSymLen,.5);	
			plWeldShape.addVertex(ptMain +vxSym*1/6*dSymLen-vySym*dEps);	
			plWeldShape.addVertex(ptMain -vxSym*1/6*dSymLen-vySym*dEps,-.5);			
		}	
		else if (nWeldShape == 2)
		{
			plWeldShape = PLine(_ZW);
			plWeldShape.addVertex(ptMain -vxSym*1/6*dSymLen);
			plWeldShape.addVertex(ptMain +vxSym*1/6*dSymLen,-.5);
			plWeldShape.addVertex(ptMain +vxSym*1/6*dSymLen-vySym*dEps);	
			plWeldShape.addVertex(ptMain -vxSym*1/6*dSymLen-vySym*dEps,-.5);				
			
		}	
		
	// store and display the weld shape	
		if (nWeldShape != 3)// do nothing for 'not set'
		{
			plWeldShape.transformBy(csWeldShape);
			if (bDrawSymbol) dpSym.draw(plWeldShape);	
			
			mapRequest.setPoint3d("ptScale", _Pt0);	
			mapRequest.setPLine("pline", plWeldShape);
			mapRequests.appendMap("DimRequest",mapRequest);	
		}
		if (nWeldKind==0)// kehlnaht
		{
			plSymMain.addVertex(ptMain -vxSym*1/6*dSymLen);
			plSymMain.addVertex(ptMain +vxSym*1/6*dSymLen);
			plSymMain.addVertex(ptMain -(vxSym-2*vySym)*1/6*dSymLen);	
			plSymMain.close();		
			csWeldShape.setToAlignCoordSys(ptMain,vxSym,vySym,_ZW, 
					ptMain +vxSym*1/6*dSymLen-(vxSym-vySym)*1/6*dSymLen + (vxSym+vySym)*0.05*dSymLen, (vxSym-vySym), (vxSym-vySym),_ZW);			
			
		}
		else if (nWeldKind==1)// V
		{
			plSymMain.addVertex(ptMain -(vxSym-2*vySym)*1/6*dSymLen);
			plSymMain.addVertex(ptMain);
			plSymMain.addVertex(ptMain +(vxSym+2*vySym)*1/6*dSymLen);	
		}
		else if (nWeldKind==2)// HV
		{
			plSymMain.addVertex(ptMain +(2*vySym)*1/6*dSymLen);
			plSymMain.addVertex(ptMain);
			plSymMain.addVertex(ptMain +(vxSym+2*vySym)*1/6*dSymLen);	
		}
		else if (nWeldKind==3)// Y
		{
			plSymMain.addVertex(ptMain);
			plSymMain.addVertex(ptMain+vySym*1/6*dSymLen);
			plSymMain.addVertex(ptMain+(vxSym+2*vySym)*1/6*dSymLen);
			plSymMain.addVertex(ptMain+vySym*1/6*dSymLen);
			plSymMain.addVertex(ptMain-(vxSym-2*vySym)*1/6*dSymLen);
		}
		else if (nWeldKind==4)// HY
		{
			plSymMain.addVertex(ptMain);
			plSymMain.addVertex(ptMain+vySym*1/3*dSymLen);
			plSymMain.addVertex(ptMain+vySym*1/6*dSymLen);
			plSymMain.addVertex(ptMain+(vxSym+2*vySym)*1/6*dSymLen);
		}		
		else if (nWeldKind==5)// Gegen
		{
			plSymMain.addVertex(ptMain -vxSym*1/6*dSymLen);
			plSymMain.addVertex(ptMain +vxSym*1/6*dSymLen,1);
			plSymMain.close();
		}	
		else if (nWeldKind==6)// I-Naht
		{

			plSymMain.addVertex(ptMain-(.1*vxSym-vySym)*1/3*dSymLen);
			plSymMain.addVertex(ptMain-(.1*vxSym)*1/3*dSymLen);
			plSymMain.addVertex(ptMain+(.1*vxSym)*1/3*dSymLen);
			plSymMain.addVertex(ptMain+(.1*vxSym+vySym)*1/3*dSymLen);
		}			
		if (bDrawSymbol) dpSym.draw(plSymMain);	

		mapRequest.setPoint3d("ptScale", _Pt0);	
		mapRequest.setPLine("pline", plSymMain);
		mapRequests.appendMap("DimRequest",mapRequest);	


		for(int i=0;i<ptSym.length();i++)
			plSym.addVertex(ptSym[i]);
		if (bDrawSymbol) dpSym.draw(plSym);
		// scaling work sover pp.shrink, so we need to make a closed pline
		for(int i=ptSym.length()-1;i>=0;i--)
			plSym.addVertex(ptSym[i]+(vx-vy)*dEps);	
		mapRequest.setPLine("pline", plSym);
		mapRequests.appendMap("DimRequest",mapRequest);


		plSym = PLine(_ZW);
		plSym.addVertex(_Pt0);
		plSym.addVertex(_Pt0+ (vxSym+vySym) *1/3*dSymLen	-(vxSym-vySym)*.05*dSymLen);
		plSym.addVertex(_Pt0+ (vxSym+vySym) *1/3*dSymLen	+(vxSym-vySym)*.05*dSymLen);
		plSym.close();
		if (bDrawSymbol) dpSym.draw(PlaneProfile(plSym),_kDrawFilled);
		

		mapRequest.setPLine("pline", plSym);
		mapRequest.setInt("DrawFilled", _kDrawFilled);
		mapRequests.appendMap("DimRequest",mapRequest);		
		
		mapRequest.removeAt("DrawFilled",true);		
		// surrounding welding seam
		if (nWeldPath>0)
		{
			plSym = PLine(_ZW);	
			plSym.createCircle(ptSym[1],_ZW,.05*dSymLen);
			if (bDrawSymbol) dpSym.draw(plSym);
			
			mapRequest.setPLine("pline", plSym);
			mapRequests.appendMap("DimRequest",mapRequest);
				
		}
		
		// onsite welding
		if(bWeldOnsite)
		{
			plSym = PLine(_ZW);	
			plSym.addVertex(ptSym[1]);			
			plSym.addVertex(ptSym[1]+vySym*.5*dSymLen);
			if (bDrawSymbol) dpSym.draw(plSym);
			plSym.addVertex(ptSym[1]+vySym*.5*dSymLen+vxSym*dEps);			
			plSym.addVertex(ptSym[1]+vxSym*dEps);			

			mapRequest.setPLine("pline", plSym);
			mapRequests.appendMap("DimRequest",mapRequest);			
				
			plSym = PLine(_ZW);
			plSym.addVertex(ptSym[1]+vySym*.5*dSymLen);			
			plSym.addVertex(ptSym[1]+vySym*2/6*dSymLen);	
			plSym.addVertex(ptSym[1]+vySym*5/12*dSymLen+vxSym*1/6*dSymLen);
			plSym.close();	
			if (bDrawSymbol) dpSym.draw(PlaneProfile(plSym),_kDrawFilled);	
		
			mapRequest.setPLine("pline", plSym);
			mapRequests.appendMap("DimRequest",mapRequest);												
		}
	// publish
		_Map.setMap("DimRequest[]", mapRequests);	
		
	}	

						
// assignment
	String sLayerGroup ="I";
	if (sLayerGroup != "")
	{
		Entity ent = ent0; // assign your entity here
		// find group name
		int bFound;
		Group grAll[] = Group().allExistingGroups();
		for (int i=0;i<grAll.length();i++)
			if (grAll[i].name() == sLayerGroup)
			{
				bFound=true;
				grAll[i].addEntity(_ThisInst,TRUE,0,'T');
				break;	
			}
	
		// no valid groupname found, assuming it is a layername
		if (!bFound)
		{
			String sLayer = sLayerGroup;
			sLayer.makeUpper();
	
		// group assignment via entity
			String sGroupChars[] = {	'T', 'I','J','Z','C'};
			int nFindChar = sGroupChars.find(sLayer);
			if (sLayer.length()==1 && nFindChar >-1)// if you want to allow manual layer assignments replace <1> with <_bOnDbCreated>)
			{
				//overwrite the automatic layer assignment 
				assignToLayer(ent.layerName());
				Group grEnt[0];
				grEnt = ent.groups();
				for (int g = 0; g < grEnt.length(); g++)	
					grEnt[g].addEntity(_ThisInst, false, ent.myZoneIndex(),sLayer.getAt(0));
			}
		// create a new layer and/or assign it to it
			else
				assignToLayer(sLayerGroup);
		}
	}	







#End
#BeginThumbnail
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
FH*Q2.,YZT45RI'3*38T*<\&G,@<8Z&BB@&0LAZ4W8?6BBI9)_]G\
`




#End
